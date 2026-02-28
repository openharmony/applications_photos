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

import lazy { PhotoDataImpl } from './PhotoDataImpl';
import lazy Global from '../../../utils/GlobalContext';
import lazy { AlbumDefine } from '../AlbumDefine';
import lazy { FetchType } from '../../../interface/BrowserDataInterface';
import type { AsyncCallback } from '../../common/AsyncCallback';
import lazy { MediaItem } from './MediaItem';
import lazy { Constants } from '../../common/Constants';
import type { FetchOptions, PhotoAsset } from '../../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';

/* instrument ignore file */
const TAG: string = 'PhotoDataImpl';

export class BurstPhotosDataImpl extends PhotoDataImpl {
  private burstKey: string;
  public totalCount: number = 0;

  constructor(burstKey: string) {
    super();
    this.burstKey = burstKey;
  }

  getData(callback: AsyncCallback<MediaItem[]>): void {
    if (!callback) {
      this.error(TAG, 'getMediaItem, param or callback is undefined, return!');
      return;
    }

    let mediaItemList: MediaItem[] = [];
    this.getItems()
      .then((dataList: PhotoAsset[] | undefined): void => {
        if (!dataList) {
          return;
        }
        this.totalCount = dataList.length;
        for (let item of dataList) {
          try {
            this.addItemIntoList(item, mediaItemList);
          } catch (err) {
            this.error(TAG, `getMediaItem error: ${err}, code: ${err?.code}`);
          }
        }
        callback.callback(mediaItemList);
      });
  }


  public async getItems(): Promise<PhotoAsset[]> {
    try {
      const fetchOpt: FetchOptions = AlbumDefine.getBurstPhotosFetchOpt(Constants.INVALID, Constants.INVALID, false);
      let result: PhotoAsset[] | undefined;
      result = await UserFileManagerAccess.getInstance().getBurstPhotosObject(this.burstKey, fetchOpt);
      return result;
    } catch (error) {
      this.error(TAG, 'getDataByBurstKey error');
      return [];
    }
  }

  private addItemIntoList(item: PhotoAsset, mediaItemList: MediaItem[], fetchType?: FetchType): void {
    if (fetchType === FetchType.EMPTY) {
      let mediaItem: MediaItem = new MediaItem(item, fetchType);
      mediaItemList.push(mediaItem);
    } else if (fetchType === FetchType.DATE_INFO) {
      let mediaItem: MediaItem = new MediaItem(item, fetchType);
      let dateAddedLen: number = 13;
      let fileIdLen: number = 10;
      let dateAdded: string = String(item.get(photoAccessHelper.PhotoKeys.DATE_ADDED_MS.toString()));
      dateAdded = dateAdded.padStart(dateAddedLen, '0');
      mediaItem.timeId = dateAdded + (Array(fileIdLen).join('0') + item.get('file_id')).slice(-fileIdLen);
      mediaItemList.push(mediaItem);
    } else {
      let mediaItem: MediaItem = new MediaItem(item);
      mediaItem.setThumbnail(this.getThumbnailUri(mediaItem.uri, mediaItem.path, mediaItem.getDateModified(),
        mediaItem.getThumbnailReady()));
      mediaItemList.push(mediaItem);

    }
    return;
  }
}