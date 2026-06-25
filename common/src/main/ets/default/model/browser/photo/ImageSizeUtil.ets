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
/* instrument ignore file*/
import lazy { Log } from '../../../utils/Log';
import lazy { MathUtil } from '../../../utils/MathUtil';
import type { MediaItem } from './MediaItem';
import lazy { Size } from '@kit.ArkUI';

const TAG: string = 'ImageSizeUtil';
const MIN: number = 0.5;
const MAX: number = 2;
const IMAGE_HEIGHT = 96;
const IMAGE_WIDTH = 48;

export class ImageSizeUtil {
  /**
   * 高宽比 在 0.5 ~ 2 之间的 按照 原始比例缩小到高为96的图片 0.5之下的，按照 0.5比例显示  96：48   2之上的 96 ： 192
   */
  public static getImageSizeByMediaItem(mediaItem?: MediaItem): Size {
    if (!mediaItem) {
      Log.warn(TAG, 'mediaItem is undefined');
      return {
        height: Number.NaN,
        width: Number.NaN,
      };
    }
    let height = mediaItem.height;
    let width = mediaItem.width;
    let ratio = height / width;
    Log.info(TAG, `getImageSizeByMediaItem${JSON.stringify({ height, width, ratio })}`);
    if (ratio < MAX && ratio > MIN) {
      return {
        height: IMAGE_HEIGHT,
        width: IMAGE_HEIGHT / ratio,
      };
    } else if (ratio < MIN) {
      return {
        height: IMAGE_HEIGHT,
        width: IMAGE_WIDTH,
      };
    }
    return {
      height: IMAGE_HEIGHT,
      width: IMAGE_HEIGHT * MAX,
    };
  }

  /**
   * 从MediaItem中获取图片比例
   *
   * @param mediaItem 图片mediaItem
   * @returns 图片的比例值
   */
  public static getImageHeightWidthRatio(mediaItem?: MediaItem): number {
    if (!mediaItem) {
      Log.warn(TAG, 'mediaItem is undefined');
      return MIN;
    }
    let height = mediaItem.height;
    let width = mediaItem.width;
    // 对媒体库特殊情况下返回的对象没有宽高，做规避处理
    if (!height || height === 0 || !width || width === 0) {
      return MIN;
    }
    let ratio = width / height;
    Log.debug(TAG, `getImageHeightWidthRatio from Item height: ${height} width: ${width}, ratio: ${ratio}`);
    return MathUtil.clamp(ratio, MIN, MAX);
  }

  /**
   * 获取图片比例
   *
   * @param height 图片高度
   * @param width 图片宽度
   * @returns 图片的比例值
   */
  public static getImageRatio(height: number, width: number): number {
    if (!height || height === 0 || !width || width === 0) {
      return MIN;
    }
    let ratio = width / height;
    Log.debug(TAG, `getImageHeightWidthRatio height: ${height} width: ${width}, ratio: ${ratio}`);
    return MathUtil.clamp(ratio, MIN, MAX);
  }
}