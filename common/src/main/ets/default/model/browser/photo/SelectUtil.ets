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

import lazy { Log } from '../../../utils/Log';
import type { MediaItem } from './MediaItem';
import lazy { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';

/* instrument ignore file */
const TAG: string = 'common_SelectUtil';

export class SelectUtil {
  public static getUriArray(selectedPhotos: Set<string>): string[] {
    let uriArray: string[] = [];
    if (!selectedPhotos) {
      return uriArray;
    }
    selectedPhotos.forEach((uri): void => {
      uriArray.push(uri);
    });
    return uriArray;
  }

  public static getCountOfMedia(uriArray: string[], selectedMap: Map<string, MediaItem>): Promise<number[]> {
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
      let mediaItem: MediaItem | undefined = selectedMap.get(uriArray[i]);
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
}