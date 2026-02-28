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
import { HiLog } from './util/HiLog';
import type image from '@ohos.multimedia.image';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { PixelMapUtil } from './util/PixelMapUtil';

/* instrument ignore file */
const TAG: string = 'EditorPixelMapManager';
const MAX_THUMBNAIL_SIZE = 2048;

export class EditorPixelMapManager {
  public static async getThumbnailByAsset(photoAsset?: photoAccessHelper.PhotoAsset):
    Promise<image.PixelMap | undefined> {
    let pixelMap: image.PixelMap | undefined = undefined;
    try {
      let width = Number(photoAsset?.get(photoAccessHelper.PhotoKeys.WIDTH));
      let height = Number(photoAsset?.get(photoAccessHelper.PhotoKeys.HEIGHT));
      if (width == 0 || height == 0) {
        HiLog.w(TAG, 'getThumbnailByAsset, database size is isInvalid')
      }
      const orientation = Number(photoAsset?.get(photoAccessHelper.PhotoKeys.ORIENTATION));
      // EXIF 旋转角度
      HiLog.i(TAG, `getThumbnailByAsset exif orientation: ${orientation}, size=${width},${height}`);
      if (orientation === 90 || orientation === 270) {
        let tmp = width;
        width = height;
        height = tmp;
      }
      let size: image.Size = {
        width: width == 0 ? -1 : width,
        height: height == 0 ? -1 : height,
      };
      if (!photoAsset) {
        HiLog.e(TAG, 'getThumbnailByAsset no asset found: ');
        return pixelMap;
      }
      size = PixelMapUtil.calculateDownSampleSize(size, MAX_THUMBNAIL_SIZE);
      pixelMap = await photoAsset?.getThumbnail(size);
      if (!pixelMap) {
        HiLog.e(TAG, 'getThumbnailByAsset no pixelMap: ');
      }
      HiLog.i(TAG, 'getThumbnailByAsset success, width=${size?.width}, height=${size?.height}');
      return pixelMap;
    } catch (err) {
      HiLog.e(TAG, `getThumbnailByAsset failed with err: ${err}`);
    }
    return pixelMap;
  }
}