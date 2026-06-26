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

import lazy { PhotoDataImpl } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImpl';
import lazy { AsyncCallback } from '@ohos/common/src/main/ets/default/model/common/AsyncCallback';
import lazy { QueryParam } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { dataSharePredicates } from '@kit.ArkData';
import lazy { SendableMediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/SendableMediaItem';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy {
  FetchOptions,
  SendablePhotoAsset
} from '@ohos/common/src/main/ets/default/access/SendablePhotoAccessHelper';
import lazy { common } from '@kit.AbilityKit';
import lazy { collections } from '@kit.ArkTS';
import lazy sendablePhotoAccessHelper from '@ohos.file.sendablePhotoAccessHelper';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';

const TAG: string = 'GrantPhotoUrisDataImpl';

export class GrantPhotoUrisDataImpl extends PhotoDataImpl {
  private context: common.Context;
  private uris: string[] = [];
  private size: number = -1;
  private countCallback: AsyncCallback<number> | undefined = undefined;

  public constructor(context: common.Context, uris: string[]) {
    super();
    this.context = context;
    this.uris = uris;
  }

  public getData(callback?: AsyncCallback<MediaItem[]>, param?: QueryParam | undefined): void {
    if (!callback || this.uris?.length === 0) {
      return;
    }
    Log.info(TAG, `getData GrantPhotoUrisDataImpl uris.length = ${this.uris?.length}`);
    this.getPhotoAssetByUriArray(this.uris).then((photoAssets: SendablePhotoAsset[]) => {
      let array: collections.Array<SendableMediaItem> = new collections.Array<SendableMediaItem>();
      for (let item of photoAssets) {
        try {
          let mediaItem: SendableMediaItem = new SendableMediaItem(item);
          mediaItem.setThumbnail(ImageUtil.getThumbnailUri(mediaItem.uri, mediaItem.path, mediaItem.dateModified,
            false, mediaItem?.thumbnailReady, true));
          array.push(mediaItem);
        } catch (err) {
          Log.error(TAG, `getData: err_message:${err}`);
        }
      }
      let result = SendableMediaItem.createMediaItems(array);
      this.size = result?.length;
      Log.info(TAG, `getData GrantPhotoUrisDataImpl size = ${this.size}`);
      if (result?.length > 0) {
        callback.callback(result, param?.albumUri);
        this.countCallback?.callback(this.size, param?.albumUri);
      }
    });
  }

  public getDataCount(callback: AsyncCallback<number>, param: QueryParam): void {
    Log.info(TAG, `getDataCount GrantPhotoUrisDataImpl${this.size}`);
    this.countCallback = callback;
    if (this.size >= 0) {
      callback?.callback(this.size, param?.albumUri);
    }
  }

  public async getPhotoAssetByUriArray(uriArr: string[]): Promise<SendablePhotoAsset[]> {
    let result: SendablePhotoAsset[] = [];
    try {
      Log.info(TAG, 'getPhotoAssetByUriArray start');
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.beginWrap();
      for (let i = 0; i < uriArr.length; i++) {
        predicates.equalTo(photoAccessHelper.PhotoKeys.URI.toString(), uriArr[i]);
        if (i < uriArr.length - 1) {
          predicates.or();
        }
      }
      predicates.endWrap();

      let fetchOpt: FetchOptions = AlbumDefine.getFileFetchOptWithCamera(0, 100, AlbumDefine.FILTER_MEDIA_TYPE_ALL);
      fetchOpt.predicates = predicates;
      result = await this.getAllObjects(fetchOpt);
      Log.info(TAG, 'getPhotoAssetByUriArray end');
      return result;
    } catch (err) {
      Log.error(TAG, `getPhotoAssetByUriArray: err_message:${err}`);
    }
    return result;
  }

  private async getAllObjects(fetchOpt: FetchOptions): Promise<SendablePhotoAsset[]> {
    Log.info(TAG, `getAllObject: ${JSON.stringify(fetchOpt)}`);
    let fetchResult: sendablePhotoAccessHelper.FetchResult<SendablePhotoAsset> | undefined = undefined;
    let photoAccessHelper = sendablePhotoAccessHelper.getPhotoAccessHelper(this.context);
    try {
      fetchResult = await TraceControllerUtils.checkAsyncDelay(
        async (): Promise<sendablePhotoAccessHelper.FetchResult<SendablePhotoAsset> | undefined> => {
          if (!photoAccessHelper) {
            return undefined;
          }
          return await photoAccessHelper.getAssets(fetchOpt);
        }, 'getAllObject --> getAssets');
      if (!fetchResult) {
        Log.warn(TAG, 'get all Object Data with empty dataList');
        return [];
      }
      Log.info(TAG, `get all Object Data raw data size: ${fetchResult.getCount()}`);
      if (fetchResult.getCount() <= 0) {
        Log.warn(TAG, 'getCount = 0');
        return [];
      }

      let result: SendablePhotoAsset[] = await TraceControllerUtils.checkAsyncDelay(
        async (): Promise<SendablePhotoAsset[]> => {
          return await fetchResult?.getAllObjects() ?? [];
        }, 'getAllObject --> getAllObjects');
      return result;
    } catch (error) {
      Log.error(TAG, `getAllObject error: ${error}, code: ${error?.code}`);
      return [];
    } finally {
      fetchResult?.close();
      photoAccessHelper.release();
      Log.info(TAG, `fetchResult is close.`);
    }
  }
}