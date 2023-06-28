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

import { Log } from './Log';
import { Constants } from '../model/common/Constants';
import display from '@ohos.display';
import image from '@ohos.multimedia.image';

const TAG: string = 'common_ImageUtil';

type ImageSize = {
  width: number;
  height: number;
};

export class ImageUtil {
  // 默认缩略图大小，用于大图跳转
  static readonly DEFAULT_THUMBNAIL_SIZE: number = 640;

  static computeSampleSize(width: number, height: number, minSideLength: number, maxNumOfPixels: number): number {
    if (width == 0 || height == 0 || minSideLength == 0 || maxNumOfPixels == 0) {
      return 2;
    }
    let initialSize = ImageUtil.computeInitialSampleSize(width, height, minSideLength, maxNumOfPixels);
    Log.debug(TAG, `initialSize:  ${initialSize}`);
    return initialSize <= 8 ? ImageUtil.nextPowerOf2(initialSize) : Math.floor((initialSize + 8 - 1) / 8) * 8;
  }

  static getScreenNailSize(size: image.Size): void {
    let displayClass: display.Display = display.getDefaultDisplaySync();
    // 屏幕最长边px值
    let screenWidth: number = displayClass.width;
    let screenHeight: number = displayClass.height;
    let maxScreenSideLength = Math.max(screenWidth, screenHeight);
    Log.info(TAG, `getScreenNailSize maxSideLength: ${maxScreenSideLength}`);
    let targetSize = maxScreenSideLength * Constants.NUMBER_1 / Constants.NUMBER_4;
    let sizeWidth: number = size.width;
    let sizeHeight: number = size.height;
    let maxImageSideLength: number = Math.max(sizeWidth, sizeHeight);
    if (maxImageSideLength === 0) {
      Log.error(TAG, 'screen max length is zero');
      return;
    }
    let scale = targetSize / maxImageSideLength;
    size.width = Math.ceil(size.width * scale);
    size.height = Math.ceil(size.height * scale);
    Log.info(TAG, `getScreenNailSize scale: ${scale}, target height ${size.height}`);
  }

  static nextPowerOf2(value: number): number {
    let useValue = value;
    if (useValue <= 0 || useValue > (1 << 30)) {
      Log.warn(TAG, `invalid sample value ${useValue}!`);
      return 1;
    }
    useValue -= 1;
    useValue |= useValue >> 16;
    useValue |= useValue >> 8;
    useValue |= useValue >> 4;
    useValue |= useValue >> 2;
    useValue |= useValue >> 1;
    Log.debug(TAG, `nextPowerOf2:${useValue}`);
    return useValue + 1;
  }

  /**
   * Calculate the aspect ratio, considering the direction of rotation
   *
   * @param info include orientation width height
   * @return the aspect ratio
   */
  static calcRatio(info: ImageSize): number {
    if (info == null || info == undefined) {
      return 1;
    }
    if (info.width == 0 || info.height == 0) {
      return 1;
    }
    return info.width / info.height;
  }

  /**
   * 计算缩略图大小生成对应路径
   * 计算缩略图大小规格：短边等于不小于给定大小；如果原图短边小于给定大小则返回原图大小
   *
   * @param uri 图片媒体路径
   * @param imageHeight 图片原高
   * @param imageWidth 图片原宽
   */
  static calcThumbnail(uri: string, imageHeight: number, imageWidth: number, orientation?: number): string {
    if (uri == null) {
      return '';
    }
    if (!imageWidth || !imageHeight) {
      // 长宽无效返回缩略图默认值256 * 256
      return `${uri}/thumbnail/256/256`
    }
    if (imageHeight < this.DEFAULT_THUMBNAIL_SIZE || imageWidth < this.DEFAULT_THUMBNAIL_SIZE) {
      return `${uri}/thumbnail/${imageWidth}/${imageHeight}`
    }

    let width = 0;
    let height = 0;
    if (orientation != null && (orientation == Constants.ANGLE_90 || orientation == Constants.ANGLE_270)) {
      let temp = imageWidth;
      imageWidth = imageHeight;
      imageHeight = temp;
    }
    if (imageHeight < imageWidth) {
      height = this.DEFAULT_THUMBNAIL_SIZE;
      width = Math.round(height * imageWidth / imageHeight)
    } else {
      width = this.DEFAULT_THUMBNAIL_SIZE;
      height = Math.round(width * imageHeight / imageWidth);
    }
    return `${uri}/thumbnail/${width}/${height}`
  }

  private static computeInitialSampleSize(width: number, height: number,
                                          minSideLength: number, maxNumOfPixels: number): number {
    if ((maxNumOfPixels == -1) && (minSideLength == -1)) {
      return 1;
    }

    let lowerBound: number = (maxNumOfPixels == -1) ? 1 : Math.ceil(Math.sqrt((width * height) / maxNumOfPixels));
    Log.debug(TAG, `lowerBound: ${lowerBound}`);
    if (minSideLength == -1) {
      return lowerBound;
    } else {
      let sampleSize = Math.min(width / minSideLength, height / minSideLength);
      return Math.max(sampleSize, lowerBound);
    }
  }
}