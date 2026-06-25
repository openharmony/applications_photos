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

import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { FaceBeautyConstants } from '@ohos/common/src/main/ets/default/model/common/FaceBeautyConstants';

/* instrument ignore file */
const TAG: string = 'PhotoScaleUtil';

export class PhotoScaleUtil {
  // 计算主体放大倍率
  public static calcSubjectScale(
    faceWidth: number, faceHeight: number, imageWidth: number, imageHeight: number): number {
    let screenWidth: number = vp2px(getScreen().getWinWidth());
    let screenHeight: number = vp2px(getScreen().getWinHeight());
    let originalScale: number = Math.min(screenWidth / imageWidth, screenHeight / imageHeight);
    let widthScale: number = FaceBeautyConstants.MAX_WINDOW_SCALE_RATIO * screenWidth / (faceWidth * originalScale);
    let heightScale: number = FaceBeautyConstants.MAX_WINDOW_SCALE_RATIO * screenHeight / (faceHeight * originalScale);
    let scale: number = Math.min(widthScale, heightScale);
    Log.info(TAG, `calcSubjectScale scale: ${scale} originalScale: ${originalScale}`);
    if (scale < 1) {
      return 1;
    }
    return Math.min(scale, FaceBeautyConstants.SCALE_RATIO);
  }

  /**
   * 原图中某一像素点在屏幕中的位置
   *
   * @param centerX: 像素点坐标
   * @param centerY
   * @param imageWidth：原图尺寸
   * @param imageHeight
   * @returns
   */
  public static getPosInScreen(centerX: number, centerY: number, imageWidth: number, imageHeight: number): number[] {
    let screenWidth: number = vp2px(getScreen().getWinWidth());
    let screenHeight: number = vp2px(getScreen().getWinHeight());
    let widthScale: number = screenWidth / imageWidth;
    let heightScale: number = screenHeight / imageHeight;
    let imageScales: number = Math.min(widthScale, heightScale);
    let visibleImageWidth: number = imageWidth * imageScales;
    let visibleImageHeight: number = imageHeight * imageScales;

    let offsetX: number = (screenWidth - visibleImageWidth) / 2;
    let offsetY: number = (screenHeight - visibleImageHeight) / 2;

    let positionX: number = centerX * imageScales + offsetX;
    let positionY: number = centerY * imageScales + offsetY;
    Log.info(TAG, `offsetX: ${offsetX} offsetY: ${offsetY} positionX: ${positionX} positionY: ${positionY}`);
    return [positionX, positionY];
  }

  /**
   * 获取图片显示区域右下角在屏幕中的坐标
   *
   * @param width: 图片显示的宽
   * @param height: 图片显示的高
   * @param scale: 图片放大倍数
   * @returns 屏幕坐标
   */
  public static getCornerPosition(width: number, height: number, scale: number): number[] {
    let componentWidth: number = vp2px(getScreen().getWinWidth());
    let componentHeight: number = vp2px(getScreen().getWinHeight());
    let widthScale: number = componentWidth / width;
    let heightScale: number = componentHeight / height;
    let imageScales: number = Math.min(widthScale, heightScale);
    let visibleImageWidth: number = width * imageScales;
    let visibleImageHeight: number = height * imageScales;

    let position: number[] = [];
    if (visibleImageWidth === componentWidth) {
      position[0] = componentWidth;
      position[1] = (componentHeight + visibleImageHeight * scale) / 2;
      if (position[1] > componentHeight) {
        position[1] = componentHeight;
      }
    }
    if (visibleImageHeight === componentHeight) {
      position[0] = (componentWidth + visibleImageWidth * scale) / 2;
      if (position[0] > componentWidth) {
        position[0] = componentWidth;
      }
      position[1] = componentHeight;
    }
    return position;
  }
}
