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

import fileShare from '@ohos.fileshare';
import wantConstant from '@ohos.ability.wantConstant';
import { Log } from '../../../utils/Log';
import { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import { MediaItem } from './MediaItem';

const TAG: string = 'common_SelectUtil';

export class SelectUtil {
  static getUriArray(selectedPhotos: Set<string>): Array<string> {
    let uriArray = new Array<string>();
    if (selectedPhotos == undefined) {
      return uriArray;
    }
    selectedPhotos.forEach((uri) => {
      uriArray.push(uri);
    })
    return uriArray;
  }

  static getCountOfMedia(uriArray: Array<string>, selectedMap: Map<string, MediaItem>): Promise<Array<number>> {
    let result = [0, 0];
    if (uriArray === null || uriArray === undefined || uriArray.length <= 0) {
      Log.info(TAG, 'uriArray is null or empty!');
      return new Promise((resolve): void => {
        resolve(result);
      });
    }

    if (selectedMap === undefined || selectedMap.size <= 0) {
      Log.info(TAG, 'selectedMap is null or empty!');
      return new Promise((resolve): void => {
        resolve(result);
      });
    }

    let imageCount: number = 0;
    let videoCount: number = 0;
    for (let i = 0; i < uriArray.length; i++) {
      let mediaItem: MediaItem = selectedMap.get(uriArray[i]);
      if (mediaItem?.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE) {
        imageCount++;
      } else if (mediaItem?.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        videoCount++;
      }
    }
    result = [imageCount, videoCount];
    return new Promise((resolve): void => {
      resolve(result);
    });
  }

  static async grantPermissionForUris(uris: Array<string>, bundleName: string): Promise<void> {
    Log.info(TAG, `start uris grant. bundleName: ${bundleName}`);
    let promises: Array<Promise<void>> = [];
    for (let uri of uris) {
      promises.push(SelectUtil.grantPermissionForUri(uri, bundleName));
    }
    await Promise.all(promises);
  }

  private static async grantPermissionForUri(uri: string, bundleName: string): Promise<void> {
    Log.debug(TAG, `start uri grant. uri: ${uri}`);
    try {
      await fileShare.grantUriPermission(uri, bundleName, wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION);
    } catch (err) {
      Log.error(TAG, `grant permission error: ${JSON.stringify(err)}`);
    }
  }
}