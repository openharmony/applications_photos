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

import lazy Curves from '@ohos.curves';
import lazy { Constants } from '../model/common/Constants';
import lazy { PhotoDataSource } from '../model/browser/photo/PhotoDataSource';
import lazy { DeviceInfo } from '../utils/DeviceInfo';

export enum SwiperDirection {
  LEFT,
  RIGHT,
  DEFAULT
}

export default class Swipes {
  /* instrument ignore file */
  public static readonly MAIN_SWIPE_DURATION: number = 300;
  public static readonly THUMB_SOURCE_DELAY_TIME: number = 120;
  public static readonly DELETE_OFFSET_DURATION: number = 2;
  /**
   * Swiper z 序，展示当前图片时候， z 序为 2
   */
  public static readonly ORDER_2: number = 2;
  /**
   * Swiper z 序，非展示当前图片时候， z 序为 1
   */
  public static readonly ORDER_1: number = 1;
  public static readonly SCROLL_ANIMATION_DURATION = 100;
  public static readonly DEPTH_OFFSET_RATIO_BY_HAND = 0.2;
  public static readonly DEPTH_INIT_RATIO_OF_WIDTH = 0.2;
  /**
   * delete browser photo animation curve
   * 减速曲线参数
   * 标志当前是否手指触屏，并在屏幕进行切图滑动操作
   */
  public static readonly DELETE_PHOTO_CURVE: string = Curves.cubicBezier(0, 0, 0.2, 1);
  // Swiper depth animation
  public static readonly SPRING_CURVE: Curves.ICurve = Curves.springMotion(0.416114, 0.993399, 0);
  public static readonly INTERPOLATING_CURVE = Curves.interpolatingSpring(0, 1, 328, 34);
  public static readonly SMALL_IMG_LOW: number = 18;
  public static readonly SMALL_IMG_HEIGHT: number = 36;

  public static getIndexByUri(uri: string, src?: PhotoDataSource): number {
    let index: number = src?.getDataIndexByUri(uri) ?? Number.NaN;
    if (Number.isFinite(index) && index === Constants.NOT_FOUND) {
      index = Number.NaN;
    }
    return index;
  }

  public static getCurrentProcess(currentOffset: number, offsetSafe: number, imageWidth: number): number {
    // pc上最后一个item触发左滑切图动效且currentOffset极小时，则offset需返回0，避免获取的offset不为0，导致item最终落点错误，图片或视频显示不全
    if (Math.abs(currentOffset) < offsetSafe || (DeviceInfo.isPc() && Math.abs(currentOffset) < 1)) {
      return 0;
    }
    const calibratedWidth = Swipes.DEPTH_INIT_RATIO_OF_WIDTH * imageWidth / Swipes.DEPTH_OFFSET_RATIO_BY_HAND;
    let offset = currentOffset < 0 ? currentOffset + offsetSafe : currentOffset - offsetSafe;
    if (Math.abs(offset) >= Math.abs(calibratedWidth)) {
      return offset < 0 ? -calibratedWidth : calibratedWidth;
    }
    return offset;
  }

  public static getTargetProcess(currentOffset: number, offsetSafe: number, imageWidth: number): number {
    const calibratedWidth = Swipes.DEPTH_INIT_RATIO_OF_WIDTH * imageWidth / Swipes.DEPTH_OFFSET_RATIO_BY_HAND;
    if (Math.abs(currentOffset) >= offsetSafe) {
      let offset = currentOffset < 0 ? currentOffset + offsetSafe : currentOffset - offsetSafe;
      if (Math.abs(offset) >= Math.abs(calibratedWidth)) {
        return 0;
      }
      return offset < 0 ? offset + calibratedWidth : offset - calibratedWidth;
    }
    return currentOffset < 0 ? calibratedWidth : -calibratedWidth;
  }

  public static getDepthByHand(isHorizontal: boolean, isPullingUp: boolean, currentOffset: number, windowLayoutWidth:
    number, windowLayoutHeight: number, currentImageWidth: number, nextDisplayedWidth: number): number[] {
    if (DeviceInfo.isPhoneUx() && isHorizontal && isPullingUp) {
      if (currentOffset < 0) {
        return [currentOffset / 2
          , currentOffset / 2 +
            Swipes.DEPTH_INIT_RATIO_OF_WIDTH * windowLayoutHeight / Swipes.DEPTH_OFFSET_RATIO_BY_HAND];
      } else if (Math.abs(currentOffset) > windowLayoutWidth - windowLayoutHeight) {
        const offset = currentOffset - (windowLayoutWidth - windowLayoutHeight);
        return [offset
          , offset - Swipes.DEPTH_INIT_RATIO_OF_WIDTH * windowLayoutHeight / Swipes.DEPTH_OFFSET_RATIO_BY_HAND];
      }
    } else if (DeviceInfo.isPhoneUx() && !isHorizontal && isPullingUp) {
      return [currentOffset
        , currentOffset + (currentOffset < 0 ? 1 : -1) * Swipes.DEPTH_INIT_RATIO_OF_WIDTH * windowLayoutWidth /
        Swipes.DEPTH_OFFSET_RATIO_BY_HAND];
    }
    return [Swipes.getCurrentProcess(currentOffset, (windowLayoutWidth - px2vp(currentImageWidth)) /
      2, px2vp(currentImageWidth))
      , Swipes.getTargetProcess(currentOffset, (windowLayoutWidth - nextDisplayedWidth) / 2, nextDisplayedWidth)];
  }

  public static getDepthOffHand(index: number,
    targetIndex: number,
    targetProcess: number, nextDisplayedWidth: number, currentImageWidth: number): number[] {
    if (index === targetIndex) {
      return [0, (targetProcess > 0 ? 1 : -1) * Swipes.DEPTH_INIT_RATIO_OF_WIDTH * nextDisplayedWidth /
      Swipes.DEPTH_OFFSET_RATIO_BY_HAND];
    }
    return [(targetIndex < index ? 1 : -1) * Swipes.DEPTH_INIT_RATIO_OF_WIDTH * px2vp(currentImageWidth) /
    Swipes.DEPTH_OFFSET_RATIO_BY_HAND, 0]
  }

  public static calcPxRoundToInteger(vp: number | undefined): number {
    return Number.isFinite(vp) ? px2vp(Math.round(vp2px(vp))) : 0;
  }
}
