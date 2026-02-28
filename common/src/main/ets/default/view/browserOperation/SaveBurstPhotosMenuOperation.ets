/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import lazy { Log } from '../../utils/Log';
import type { MenuContext } from './MenuContext';
import lazy { ProcessMenuOperation } from './ProcessMenuOperation';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { Constants } from '../../model/common/Constants';
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import lazy { Constants as BrowserConstants } from '../../model/browser/photo/Constants';
import type { FetchOptions, PhotoAsset } from '../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import lazy { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import lazy { UiUtil } from '../../utils/UiUtil';
import lazy taskpool from '@ohos.taskpool';
import lazy common from '@ohos.app.ability.common';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { dataSharePredicates } from '@kit.ArkData';

/* instrument ignore file */
const TAG: string = 'common_SaveBurstPhotosMenuOperation';

/* instrument ignore next */
@Concurrent
async function createdImageTask(context: common.UIAbilityContext,
  uri: string, cameraShotKey: string, isHiddenAlbum: boolean): Promise<photoAccessHelper.PhotoAsset | undefined> {
  Log.info('common_SaveBurstPhotosMenuOperation', 'createdImageTask');
  let photoAccessHelper: UserFileManagerAccess = new UserFileManagerAccess();
  photoAccessHelper.onCreate(context);
  let photoAsset: photoAccessHelper.PhotoAsset | undefined = undefined;
  try {
    photoAsset = await photoAccessHelper.createNewImage(context, uri, cameraShotKey, isHiddenAlbum);
  } catch (error) {
    Log.error('common_SaveBurstPhotosMenuOperation', `createdImageTask error: ${error}, code: ${error?.code}`);
  } finally {
    photoAccessHelper.release();
  }
  return photoAsset;
}

export class SaveBurstPhotosMenuOperation extends ProcessMenuOperation {
  // 新创建的Image Asset 数组
  private photoAssets: photoAccessHelper.PhotoAsset[] = [];
  // 当前相册
  private targetAlbumInfo?: AlbumInfo;
  private readonly sourceType: string[] = ['图库'];

  constructor(menuContext: MenuContext) {
    super(menuContext);
    this.operationType = 'SAVE_BURST_PHOTOS';
    this.traceOperationType = 'SAVE_BURST_PHOTOS';
  }

  public async doAction(): Promise<void> {
    Log.info(TAG, `doAction Start, albumInfo:${this.menuContext.albumInfo}`);
    if (this.menuContext == null) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    this.onOperationEnd = this.menuContext.onOperationEnd;
    this.targetAlbumInfo = this.menuContext.albumInfo;

    if (!this.menuContext.burstPhotos || !this.menuContext.burstPhotos.length) {
      Log.error(TAG, 'selected no mediaItems, return');
      return;
    }
    this.count = this.menuContext.burstPhotos.length;
    this.callback(this.menuContext.burstPhotos.map(item => item.uri));

    this.menuContext.broadCast?.on(BrowserConstants.BURST_PHOTOS_CANCEL_PROGRESS, () => {
      this.cancelProgress();
    });
    this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
      [UiUtil.getResourceStringSync($r('app.string.saving_burst_photos')), (): void => {
        this.cancelFunc();
      }]);
  }

  public selectAssetCallback(assets: PhotoAsset[]): void {
    this.selectAssets = assets;
    this.processOperation();
  }

  public callback(uris: string[]): void {
    this.uris = uris;
    this.processOperation();
  }

  public requestOneBatchOperation(): void {
    this.currentBatch++;
    let startIndex = (this.currentBatch - 1) * this.BATCH_SIZE;
    let endIndex = this.currentBatch * this.BATCH_SIZE;
    let cameraShotKey: string = '';
    if (AppStorage.get<string>('cameraShotKey')) {
      cameraShotKey = AppStorage.get<string>('cameraShotKey') as string;
    }
    this.createImages(startIndex, Math.min(endIndex, this.uris?.length ?? 0), cameraShotKey);
  }

  private async createImages(startIndex: number, endIndex: number, cameraShotKey: string): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;
    for (let i = startIndex; i < endIndex; i++) {
      let photoAsset: photoAccessHelper.PhotoAsset | undefined =
        await taskpool.execute(createdImageTask, context, this.uris[i],
          cameraShotKey) as photoAccessHelper.PhotoAsset | undefined;
      let isDeletedBurstPhotos = AppStorage.get<string>(Constants.KEY_OF_IS_DELETED_BURST_PHOTOS);
      if (photoAsset && startIndex === 0 && !isDeletedBurstPhotos) {
        AppStorage.setOrCreate<string>(Constants.KEY_OF_BURST_PHOTOS_URI, photoAsset.uri);
        Log.info(TAG, 'saveBurstPhotosUri' + photoAsset.uri);
      }
      if (photoAsset && this.isNeedRemoveToUserAlbum()) {
        this.photoAssets.push(photoAsset);
      }
    }
    Log.info(TAG, `createImages: create image number: ${this.photoAssets.length}`);

    if (this.photoAssets.length !== 0 && this.isNeedRemoveToUserAlbum()) {
      this.removeImageToTargetAlbum();
    }

    this.onCompleted();
  }

  private async removeImageToTargetAlbum(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext;

    // 获取创建的Image所在的相册
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.in(Constants.ALBUM_NAME_PREDICATE, this.sourceType);
    let fetchOption: photoAccessHelper.FetchOptions = {
      predicates: predicates,
      fetchColumns: [],
    };
    let accessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let originalFetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album>[] | undefined = undefined;
    try {
      accessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      originalFetchResult = await Promise.all([
        accessHelper.getAlbums(Constants.SOURCE_QUERY_TYPE, Constants.SOURCE_QUERY_SUB_TYPE, fetchOption)
      ]);
      let originalAlbumArray: photoAccessHelper.Album[] = await originalFetchResult[0].getAllObjects();
      let originalAlbum: photoAccessHelper.Album | null = null;
      if (originalAlbumArray.length > 0) {
        originalAlbum = originalAlbumArray[0];
      }

      let targetAlbum: photoAccessHelper.Album | undefined =
        await UserFileManagerAccess.getInstance().getAlbumByUri(this.targetAlbumInfo?.uri);

      if (originalAlbum && targetAlbum && (originalAlbum !== targetAlbum)) {
        let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
          new photoAccessHelper.MediaAlbumChangeRequest(originalAlbum);
        Log.info(TAG, 'removeImageToTargetAlbum: Start Move');
        albumChangeRequest.moveAssets(this.photoAssets, targetAlbum);
        await accessHelper.applyChanges(albumChangeRequest);
      }
    } catch (err) {
      Log.error(TAG, `removeImageToTargetAlbum.moveAssets is error :${err?.code}, ${err?.message}`);
    } finally {
      originalFetchResult?.forEach((fetchResult) => {
        fetchResult?.close();
      })
      accessHelper?.release();
      Log.info(TAG, `originalFetchResult is close.`);
    }
  }

  public cancelFunc(): void {
    this.onOperatePause();
    this.menuContext.broadCast?.emit(BrowserConstants.BURST_PHOTOS_CANCEL_SAVE,
      [(): void => {
        this.onOperateContinue();
      }, (): void => {
        this.onOperateCancelled();
      }]);
  }

  public onProcessDone(): void {
    if (!this.menuContext.broadCast) {
      Log.warn(TAG, 'onProcessDone broadCast undefined');
      return;
    }
    this.menuContext.broadCast?.emit(BroadCastConstants.UPDATE_PROGRESS, [100, this.currentBatch]);
    this.navigationPageFunc?.();
    if (this.startTime != null) {
      let operateCount = this.currentBatch >= this.totalBatches ? this.count : this.currentBatch * this.BATCH_SIZE;
      let costTime = Date.now() - this.startTime;
      Log.debug(TAG, `process data operate done, operate ${operateCount} items, cost time ${costTime} ms,\
            average ${(costTime / operateCount)} .`);
    }
    TraceControllerUtils.finishTraceWithTaskId(this.traceOperationType + '_ProgressOperation', this.requestTime);
    if (!this.isCancelled) {
      this.onOperationEnd?.(this.isError, this.successBatch, this.count);
    }
  }

  private isNeedRemoveToUserAlbum(): boolean {
    if (this.targetAlbumInfo && (this.targetAlbumInfo.isUserCreatedAlbum || this.targetAlbumInfo.isSourceAlbum)) {
      Log.info(TAG, 'isNeedRemoveToUserAlbum true');
      return true;
    }
    return false;
  }
}