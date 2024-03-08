/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { AlbumDefine } from '../AlbumDefine';
import type { QueryParam } from '../BrowserDataImpl';
import { BrowserDataImpl } from '../BrowserDataImpl';
import { Log } from '../../../utils/Log';
import type { AsyncCallback } from '../../common/AsyncCallback';
import { MediaItem } from './MediaItem';
import type { FileAsset } from '../../../access/UserFileManagerAccess';
import { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';

const TAG: string = 'common_PhotoDataImpl';

export class PhotoDataImpl extends BrowserDataImpl {

  constructor() {
    super()
  }

  async getDataByUri(uri: string): Promise<FileAsset> {
    Log.debug(TAG, 'getDataByUri');
    try {
      let result = await UserFileManagerAccess.getInstance().getFirstObject(AlbumDefine.getFileFetchOptByUri(uri));
      return result.obj;
    } catch (error) {
      Log.error(TAG, 'getDataByUri error');
      return null;
    }
  }

  getData(callback: AsyncCallback<MediaItem[]>, param: QueryParam): void {
    Log.info(TAG, `getMediaItem start ${JSON.stringify(param)}`);
    if (callback == null) {
      Log.error(TAG, 'getMediaItem, param or callback is null, return!');
      return;
    }

    // Querying MediaLibrary data
    let mediaItemList: MediaItem[] = [];
    this.getItems(param.albumUri, param.start, param.count, param?.filterMediaType).then(async (dataList: Array<FileAsset>) => {
      Log.info(TAG, 'getMediaItem coming');
      if (dataList) {
        for (let item of dataList) {
          try {
            let mediaItem: MediaItem = new MediaItem(item);
            mediaItem.setThumbnail(this.getThumbnailSafe(mediaItem.uri, mediaItem.path));
            mediaItemList.push(mediaItem);
          } catch (err) {
            Log.error(TAG, `getMediaItem error: ${err}`);
          }
        }
        Log.info(TAG, `getMediaItem item size: ${mediaItemList.length}`);
        callback.callback(mediaItemList, param.albumUri);
      }
    });
  }

  getFileAssets(callback: AsyncCallback<FileAsset[]>, param: QueryParam): void {
    Log.info(TAG, `getFileAssets start ${JSON.stringify(param)}`);
    if (callback == null) {
      Log.error(TAG, 'getFileAssets, param or callback is null, return!');
      return;
    }
    this.getItems(param.albumUri, param.start, param.count).then((fileAssets) => {
      if (!fileAssets) {
        Log.warn(TAG, 'Get fileAssets failed or the result is empty.');
        return;
      }
      callback.callback(fileAssets);
    })
  }

  getDataCount(callback: AsyncCallback<number>, param: QueryParam): void {
    Log.debug(TAG, `getMediaItemCount: ${JSON.stringify(param)}`);
    this.getItemsCount(param.albumUri, param?.filterMediaType).then((count) => {
      Log.debug(TAG, `getMediaItemCount callback: ${count}`);
      callback.callback(count, param.albumUri);
    });
  }

  getDataIndexByUri(callback: AsyncCallback<number>, param: QueryParam, uri: string): void {
    Log.debug(TAG, `getDataIndexByUri: ${uri}, ${JSON.stringify(param)}`);
    this.getItemIndexByUri(uri, param.albumUri).then((index) => {
      Log.debug(TAG, `getItemIndexByUri callback: ${index}`);
      callback.callback(index);
    });
  }

  getMediaItemByUri(callback: AsyncCallback<MediaItem>, uri: string): void {
    Log.debug(TAG, `getMediaItemByUri: ${uri}`);

    try {
      this.getItemByUri(uri).then((result): void => {
        let mediaItem: MediaItem = new MediaItem(result);
        mediaItem.setThumbnail(this.getThumbnail(mediaItem.uri, mediaItem.path));
        callback.callback(mediaItem);
      });
    } catch (error) {
      Log.error(TAG, 'getItemIndexByUri error');
    }
  }

  getThumbnail(sourceUri: string, path: string, size?): string {
    return this.getThumbnailSafe(sourceUri, path, size);
  }

  async getDataByName(name: string, albumUri: string): Promise<FileAsset> {
    Log.debug(TAG, 'getDataByName name:' + JSON.stringify(name) + '-' + JSON.stringify(albumUri));

    let dataList;
    if (albumUri) {
      dataList = await UserFileManagerAccess.getInstance().getUserAlbumObject(AlbumDefine.getAlbumFetchOptByUri(albumUri),
        AlbumDefine.getFileFetchOptByName(name))
    } else {
      dataList = await UserFileManagerAccess.getInstance().getAllObject(AlbumDefine.getFileFetchOptByName(name))
    }

    if (dataList != null) {
      if (dataList.length > 0) {
        return dataList[0];
      } else {
        Log.info(TAG, 'fileAsset is null');
        return null;
      }
    }
    Log.debug(TAG, 'getFileAsset end');
    return null;
  }
}