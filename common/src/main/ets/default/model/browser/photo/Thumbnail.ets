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

import type { Releasable } from '../../common/Releasable';
import type image from '@ohos.multimedia.image';
import lazy { sendableImage } from '@kit.ImageKit';

/**
 * Thumbnail, view layer, data encapsulation
 */
export class Thumbnail implements Releasable {
  /**
   * url
   */
  public readonly url: string = '';
  /**
   * pixelMap
   */
  public pixelMap: sendableImage.PixelMap | undefined = undefined;
  /**
   * yuvPixelMap
   */
  public yuvPixelMap: image.PixelMap | undefined = undefined;
  /**
   * width
   */
  public readonly width: number = 0;
  /**
   * height
   */
  public readonly height: number = 0;
  public moireOriginPixelMap: sendableImage.PixelMap | image.PixelMap | '' = '';

  constructor(url?: string, pixelMap?: sendableImage.PixelMap, width?: number, height?: number) {
    this.url = url ? url : '';
    this.pixelMap = pixelMap ? pixelMap : undefined;
    if (width !== undefined && width !== null) {
      this.width = width;
    }
    if (height !== undefined && width !== null) {
      this.height = height;
    }
  }

  /**
   * release source
   */
  public release(): void {
    this.pixelMap?.release();
    this.pixelMap = undefined;
    this.yuvPixelMap?.release();
    this.yuvPixelMap = undefined;
    (this.moireOriginPixelMap as image.PixelMap)?.release?.();
  }

  /**
   * 对比两者内容是否相等
   *
   * @param other 另一个对象
   * @returns 是否相等
   */
  public equals(other: Thumbnail | undefined): boolean {
    return other?.url === this.url && other?.pixelMap === this.pixelMap &&
      other?.width === this.width && other?.height === this.height;
  }
}