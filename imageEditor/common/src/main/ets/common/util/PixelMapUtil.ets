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

import { HiLog } from '../util/HiLog';
import { image } from '@kit.ImageKit';

const TAG = 'PixelMapUtil';
const MIN_IMAGE_SIZE = 2;

export class PixelMapUtil {
  public static setMemoryNameSync = (pixelmap: PixelMap, name: string) => {
    try {
      pixelmap?.setMemoryNameSync?.(name);
    } catch (e) {
      HiLog.e(TAG, `failed set memory name: ${name}, error: ${e?.code} ${e?.message}`);
    }
  };

  public static calculateDownSampleSize(size: image.Size, maxSize: number): image.Size {
    if (maxSize <= 0) {
      return size;
    }
    if (size.height <= maxSize && size.width <= maxSize) {
      return size;
    }
    let sampleSize: number = MIN_IMAGE_SIZE;
    let curSize = Math.max(size.width, size.height);

    while (curSize / sampleSize > maxSize) {
      sampleSize *= MIN_IMAGE_SIZE;
    }
    let width: number = Math.max(size.width / sampleSize, MIN_IMAGE_SIZE);
    let height: number = Math.max(size.height / sampleSize, MIN_IMAGE_SIZE);
    let resultSize: image.Size = { width: width, height: height };
    return resultSize;
  }
}