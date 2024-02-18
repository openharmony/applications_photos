/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import type { Releasable } from '../../common/Releasable';
import image from '@ohos.multimedia.image';

/**
 * Thumbnail, view layer, data encapsulation
 */
export class Thumbnail implements Releasable {
  /**
   * url
   */
  readonly url: string = '';

  /**
   * pixelMap
   */
  pixelMap?: any = undefined;

  /**
   * width
   */
  width?: number = 0;

  /**
   * height
   */
  height?: number = 0;

  constructor(url?: string, pixelMap?: image.PixelMap, width?: number, height?: number) {
    this.url = url ? url : '';
    this.pixelMap = pixelMap ? pixelMap : undefined;
    this.width = width;
    this.height = height;
  }

  /**
   * release source
   */
  release(): void {
    if (this.pixelMap != null && this.pixelMap != undefined) {
      this.pixelMap.release();
    }
    this.width = 0;
    this.height = 0;
  }
}