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
import lazy common from '@ohos.app.ability.common';
import lazy { collections, JSON, taskpool } from '@kit.ArkTS';
import lazy { SendableMediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/SendableMediaItem';
import lazy { QueryParam } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';
import lazy { PickerDataManager } from './PickerDataManager';
import lazy { PhotoDataImpl } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImpl';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { AsyncCallback } from '@ohos/common/src/main/ets/default/model/common/AsyncCallback';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { SendablePhotoAlbum } from '@ohos/common/src/main/ets/default/access/SendablePhotoAccessHelper';
import lazy { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { SelectConstants, SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import type { FetchOptions, PhotoAsset } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';

/* instrument ignore file */
const TAG: string = 'PickerDataImplAsync';

/* instrument ignore next */
@Concurrent
async function getItemsTask(context: common.Context, queryParam: QueryParam,
  result: collections.Array<SendableMediaItem>, userId: number): Promise<SendablePhotoAlbum | undefined> {
  let manager = new PickerDataManager(context, queryParam, userId);
  let album: SendablePhotoAlbum | undefined;
  try {
    TraceControllerUtils.startTrace('manager.getItemsTask');
    album = await manager.getItemsTask(result);
    TraceControllerUtils.finishTrace('manager.getItemsTask');
    return album;
  } catch (err) {
    Log.error('PickerDataImplAsync', `getItemsTask error: ${err}, code: ${err?.code}`);
    return album;
  } finally {
    manager.onDestroy();
  }
}

export class PickerDataImplAsync extends PhotoDataImpl {
  private context: common.Context | undefined;
  private storage: LocalStorage | undefined;
  private currentAlbum: SendablePhotoAlbum | undefined;
  private isFirstLoad: boolean = true;

  public constructor(storage?: LocalStorage) {
    super();
    this.storage = storage;
  }

  public setContext(context: common.Context): void {
    this.context = context;
  }

  public isFirstBatchLoad(): boolean {
    return this.isFirstLoad;
  }

  public resetFirstBatchLoad(): void {
    this.isFirstLoad = false;
  }

  public async checkMediaItemsInDataSource(selectedUris: string[], albumUris: string[]): Promise<string[]> {
    if (!this.context) {
      Log.error(TAG, 'context is undefined, return!');
      return [];
    }
    Log.info(TAG, `selectedUris length is ${selectedUris.length}`);
    let param: SelectParams | undefined =
      LocalStorage.getShared()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY);
    let queryParam: QueryParam = {
      filterMediaType: param?.filterMediaType,
      filterConditions: {
        recommendationType : param?.recommendationType,
        photoViewMimeTypeFilter : param?.photoViewMimeTypeFilter,
        fileSizeFilter : param?.fileSizeFilter,
        videoDurationFilter : param?.videoDurationFilter,
      },
      needThumbnailReady: true,
      uris: selectedUris
    };
    if (albumUris.length > 1) {
      queryParam.albumUris = albumUris;
    } else {
      queryParam.albumUri = albumUris[0];
    }
    let mediaItems: MediaItem[] = await this.getDataAsync(queryParam, this.context);
    let result: string[] = mediaItems.map(item => item.uri);
    Log.info(TAG, `result length is ${result.length}`);
		return result;
	}

  private async getDataAsync(queryParam: QueryParam, context: common.Context): Promise<MediaItem[]> {
    let userId = this.storage?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.userId ?? -1;
    if (userId > 0) {
      Log.info(TAG, `getDataAsync queryParam.userId: ${userId}`);
    }
    let array: collections.Array<SendableMediaItem> = new collections.Array<SendableMediaItem>();
    TraceControllerUtils.startTrace('getDataAsync');
    let task1: taskpool.Task = new taskpool.Task(getItemsTask, context, queryParam, array, userId);
    let album = await taskpool.execute(task1, taskpool.Priority.HIGH);
    this.currentAlbum = album ? (album as SendablePhotoAlbum) : undefined;
    Log.info(TAG, `taskpool return data size: ${array.length}, currentAlbum: ${this.currentAlbum?.albumUri}`);
    let result = SendableMediaItem.createMediaItems(array);
    array.splice(0, array.length);
    TraceControllerUtils.finishTrace('getDataAsync');
    return result;
  }

  private async getFirstBatchData(queryParam: QueryParam, context: common.Context): Promise<MediaItem[]> {
    let fetchOpt: FetchOptions | undefined = this.getFetchOpt(queryParam);
    let userId = this.storage?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.userId ?? -1;
    if (userId > 0) {
      Log.info(TAG, `getFirstBatchData start , userId:${userId}`);
      fetchOpt.predicates.notEqualTo(photoAccessHelper.PhotoKeys.POSITION.toString(), 2);
      fetchOpt.predicates.notEqualTo(photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE.toString(), 4);
    }
    TraceControllerUtils.startTrace('getFirstBatchData');
    if (queryParam.filterConditions) {
      AlbumDefine.setFilterConditions(fetchOpt, queryParam.filterConditions);
    }
    let assetList: PhotoAsset[] = []
    // const singleAsset =
    //   await (await UserFileManagerAccess.getInstance(this.storage).getMediaLibrary().getAssets(fetchOpt))?.getFirstObject();
    // assetList = singleAsset ? [singleAsset] : [];
    const allAsset =
      await (await UserFileManagerAccess.getInstance(this.storage).getMediaLibrary().getAssets(fetchOpt))?.getAllObjects();
    Log.info(TAG, `getFirstBatchData assetList length: ${assetList.length}`);
    assetList = allAsset ;
    let mediaItemList: MediaItem[] = [];
    for (let item of assetList) {
      try {
        this.addItemIntoArray(item, mediaItemList);
      } catch (err) {
        this.error(TAG, `addItemIntoArray error: ${err}, code: ${err?.code}`);
      }
    }
    TraceControllerUtils.finishTrace('getFirstBatchData');
    return mediaItemList;
  }

  public getData(callback: AsyncCallback<MediaItem[]> | undefined, param: QueryParam): void {
    Log.info(TAG, `getMediaItemAsyc start,albumUri: ${param.albumUri}, start: ${param.start}, count: ${param.count}`);
    if (!callback) {
      Log.error(TAG, 'getMediaItem, param or callback is undefined, return!');
      return;
    }
    if (!this.context) {
      Log.error(TAG, 'context is undefined, return!');
      return;
    }

    // 当传入albumUri时候说明为需要查看特定相册的照片
    if (this.isFirstLoad && !param.albumUri) {
      this.getFirstBatchData(param, this.context).then((ret: MediaItem[]) => {
        Log.info(TAG, `getFirstBatchData MediaItem size: ${ret.length},start: ${param.start},end: ${param.count},` +
          `startTime: ${param.startTime}`
        );
        if (ret.length > 0) {
          callback.callback(ret, param.albumUri);
        }
        this.isFirstLoad = false;
      });
    } else {
      this.getDataAsync(param, this.context).then((ret: MediaItem[]) => {
        Log.info(TAG, `getDataAsync MediaItem size: ${ret.length},start: ${param.start},end: ${param.count},` +
          `startTime: ${param.startTime}`
        );
        if (ret.length > 0) {
          callback.callback(ret, param.albumUri);
        }
      });
    }
  }

  public getDataCount(callback: AsyncCallback<number>, param: QueryParam): void {
    if (!callback || !param) {
      return;
    }
    this.info(TAG, `getMediaItemCount: ${JSON.stringify(param)}`);
    this.getItemsCount(param.albumUri, param?.filterMediaType,
      param.needThumbnailReady, this.storage, param.filterConditions)
      .then((count): void => {
        this.info(TAG, `getMediaItemCount callback: ${count}. album:${param?.albumUri}`);
        callback.callback(count, param.albumUri);
      });
  }

  public getDataIndexByUri(callback: AsyncCallback<number>, param: QueryParam, uri: string): void {
    this.debug(TAG, `pickerdataimpl getDataIndexByUri: ${uri}, ${JSON.stringify(param)}`);
    this.getItemIndexByUri(uri, param.albumUri, param.filterMediaType,
      UserFileManagerAccess.FILE_KEY_DATE_ADDED.toString()).then((index): void => {
      this.debug(TAG, `getItemIndexByUri callback: ${index}`);
      callback.callback(index);
    });
  }

  public getFetchOpt(query: QueryParam): photoAccessHelper.FetchOptions {
    const startIndex: number | undefined = query?.start;
    const count: number | undefined = query?.count;
    const filterMediaType: string | undefined = query?.filterMediaType;
    let fetchOpt: photoAccessHelper.FetchOptions;
    if (!query?.albumUri) {
      fetchOpt = AlbumDefine.getFileFetchOpt(startIndex, count, filterMediaType,
        query.needThumbnailReady, UserFileManagerAccess.FILE_KEY_DATE_ADDED.toString(), undefined, false);
    } else {
      fetchOpt = super.getFetchOpt(query);
    }
    AlbumDefine.setFilterConditions(fetchOpt, query.filterConditions);
    return fetchOpt;
  }
}