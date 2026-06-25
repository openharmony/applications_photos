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
import lazy { PhotoDataImpl } from './PhotoDataImpl';
import type { QueryParam } from '../../../interface/BrowserDataInterface';
import lazy { Log } from '../../../utils/Log';
import type { AsyncCallback } from '../../common/AsyncCallback';
import type { FetchOptions } from '../../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { AlbumDefine } from '../AlbumDefine';
import lazy { MediaItem } from './MediaItem';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { SendableMediaItem } from './SendableMediaItem';
import lazy { collections, taskpool } from '@kit.ArkTS';
import lazy { CleanupDataManager } from './CleanupDataManager';
import lazy { PhotoAsset } from '../../../view/dialog/MoveDialog';

/* instrument ignore file */
const TAG: string = 'CleanupDataImplAsync';

@Concurrent
async function getItemsTask(context: common.UIAbilityContext | common.ServiceExtensionContext,
  queryParam: QueryParam, result: collections.Array<SendableMediaItem>, fromPage: string,
  imageOrderByName: string): Promise<void> {
  let task = new CleanupDataManager(context, queryParam, fromPage, imageOrderByName);
  try {
    // 直接操作共享实例, FileAsset部分暂不支持共享，这部分通过序列化形式返回，主线程组装。
    await task.getItemsTask(result);
  } catch (err) {
    Log.error('CleanupDataImplAsync', `getItemsTask error: ${err}, code: ${err?.code}`);
  } finally {
    task.onDestroy();
  }
}

export class CleanupDataImplAsync extends PhotoDataImpl {
  private context: common.Context | undefined;
  private storage: LocalStorage | undefined;
  private fromPage: string = '';
  private imageOrderByName: string = photoAccessHelper.PhotoKeys.DATE_TAKEN_MS;

  public constructor(storage?: LocalStorage) {
    super();
    if (storage) {
      this.storage = storage;
    }
  }

  public setContext(context: common.Context): void {
    this.context = context;
  }

  public setFromPage(fromPage: string): void {
    this.fromPage = fromPage;
  }

  public setImageOrderByName(imageOrderByName: string): void {
    this.imageOrderByName = imageOrderByName;
  }

  public getDataCount(callback: AsyncCallback<number>, param: QueryParam): void {
    if (!callback || !param || !param.albumUri) {
      this.error(TAG, 'getDataCount, callback or param or param.albumUris is undefined');
      return;
    }
    Log.info(TAG, `getDataCount: ${JSON.stringify(param)}`);
    this.getCleanupAlbumItemsCount(param.albumUri, param.filterMediaType, this.storage)
      .then((count): void => {
        Log.info(TAG, `getDataCount callback: ${count}`);
        callback.callback(count, param.albumUri);
      }).catch((error: BusinessError) => {
      Log.error(TAG, `getDataCount has error: ${error}, code: ${error?.code}`);
    });
  }

  private async getCleanupAlbumItemsCount(albumUri: string, filterMediaType?: string,
    storage?: LocalStorage): Promise<number> {
    let count: number = 0;
    let query: QueryParam = {
      filterMediaType: filterMediaType,
    }
    let fetchOpt: FetchOptions = this.getFetchOpt(query);
    count = await UserFileManagerAccess.getInstance(storage).getAlbumAssetsCountByAlbumUri(albumUri, fetchOpt);
    Log.info(TAG, `getCleanupAlbumItemsCount count: ${count}`);
    return count;
  }

  public getData(callback: AsyncCallback<MediaItem[]> | undefined, param: QueryParam): void {
    Log.info(TAG, `getData start ${JSON.stringify(param)}`);
    if (!callback || !param) {
      Log.error(TAG, 'getData, param or callback or context is undefined, return!');
      return;
    }
    type commonContext = common.UIAbilityContext | common.ServiceExtensionContext;
    let context = getContext(this) as commonContext;
    this.getDataAsync(param, context).then((ret: MediaItem[]) => {
      Log.info(TAG, `getDataAsync MediaItem size: ${ret.length},start: ${param.start},end: ${param.count},` +
        `startTime: ${param.startTime}`);
      Log.info(TAG, 'call callback directly');
      callback.callback(ret, param.albumUri);
    });
  }

  public async getDataAsync(queryParam: QueryParam, context: common.Context): Promise<MediaItem[]> {
    Log.info(TAG, 'getDataAsync start');
    let array: collections.Array<SendableMediaItem> = new collections.Array<SendableMediaItem>();
    await taskpool.execute(getItemsTask, context, queryParam, array, this.fromPage, this.imageOrderByName);
    Log.info(TAG, `taskpool return data size: ${array.length}`);
    let mediaItemList = SendableMediaItem.createMediaItems(array);
    return mediaItemList;
  }

  public getFetchOpt(query: QueryParam): photoAccessHelper.FetchOptions {
    const startIndex: number | undefined = query?.start;
    const count: number | undefined = query?.count;
    return AlbumDefine.getFileFetchOptWithCleanupPage(this.fromPage, startIndex, count, undefined,
      this.imageOrderByName);
  }

  public async getDataByBurstKey(burstKey: string, start: number, count: number, isDesc?: boolean, isTrash?: boolean):
    Promise<MediaItem[]> {
    if (!burstKey) {
      Log.info(TAG, 'burstKey is empty');
      return [];
    }
    try {
      let result: PhotoAsset[] = [];
      const fetchOpt: FetchOptions = AlbumDefine.getCleanupPageBurstPhotosFetchOpt(start, count);
      const photoAsset = await UserFileManagerAccess.getInstance().getBurstPhotosCoverObject(burstKey, fetchOpt);
      if (!photoAsset) {
        return [];
      }
      result.push(photoAsset);
      // return [];
      return result.map(item => new MediaItem(item));
    } catch (error) {
      this.error(TAG, 'getDataByBurstKey error');
      return [];
    }
  }
}