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
import lazy { PhotoItemVM } from './PhotoItemVM';
import lazy { ImageToolConstants } from '@ohos/common/src/main/ets/default/model/common/ImageToolConstants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MathUtil } from '@ohos/common/src/main/ets/default/utils/MathUtil';

const TAG = 'ImageToolLog'

@Observed
export class ImageToolComponentVM {
  
  /**
   * 特定比例的照片 满足出现画中画条件
   * @returns 
   */
  public isPhotoAndDeviceSatisfy(photoItemVM: PhotoItemVM): boolean {
    if (MathUtil.equals(photoItemVM.windowLayoutHeight, 0.0) ||
    MathUtil.equals(photoItemVM.item.height, 0.0)) {
      Log.error(TAG, 'special Photo calculate error, window height or mediaitem height is zero');
      return false;
    }
    const winRatio = photoItemVM.windowLayoutWidth / photoItemVM.windowLayoutHeight;
    const imageRatio = photoItemVM.item.width / photoItemVM.item.height;
    Log.info(TAG, `isPhotoAndDeviceSatisfy winRatio:${winRatio} imageRatio:${imageRatio} isHorizontal:${photoItemVM.isHorizontal}`);
    // ① 设备屏幕宽高比在0.8~1.25之内，图片宽高比>=3:1或<=1:3，则支持画中画；
    if (winRatio >= ImageToolConstants.IMAGE_TOOL_SCREEN_RATIO_MIN &&
      winRatio <= ImageToolConstants.IMAGE_TOOL_SCREEN_RATIO_NAX) {
      if (imageRatio >= ImageToolConstants.IMAGE_TOOL_SPECIAL_RATIO_FIRST ||
        imageRatio <= 1 / ImageToolConstants.IMAGE_TOOL_SPECIAL_RATIO_FIRST) {
        Log.debug(TAG, 'screen ratio regular and image ratio satisfy, enter inner photo');
        return true;
      }
      Log.debug(TAG, 'screen ratio regular and image ratio satisfy, cannot enter inner photo');
      return false;
    }
    // ② 屏幕宽高比<0.8或>1.25,
    if (photoItemVM.isHorizontal) {
      // 横屏显示时，图片宽高比>=3.5或者高宽比>=2.5，支持画中画。
      if (imageRatio >= ImageToolConstants.IMAGE_TOOL_SPECIAL_RATIO_THIRD ||
        imageRatio <= 1 / ImageToolConstants.IMAGE_TOOL_SPECIAL_RATIO_SECOND) {
        Log.debug(TAG, 'special screen ratio and horizontal image ratio satisfy, enter inner photo');
        return true;
      }
      Log.debug(TAG, 'special screen ratio and horizontal image ratio satisfy, cannot enter inner photo');
      return false;
    }
    // 竖屏显示时，图片宽高比>=2.5 或者高宽比>=3.5，支持画中画；
    if (imageRatio >= ImageToolConstants.IMAGE_TOOL_SPECIAL_RATIO_SECOND ||
      imageRatio <= 1 / ImageToolConstants.IMAGE_TOOL_SPECIAL_RATIO_THIRD) {
      Log.debug(TAG, 'special screen ratio and nonhorizontal image ratio satisfy, enter inner photo');
      return true;
    }
    Log.debug(TAG, 'special screen ratio and nonhorizontal image ratio satisfy, cannot enter inner photo');
    return false;
  }
}