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

import lazy { Log } from '../utils/Log';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { UiUtil } from '../utils/UiUtil';
import lazy { BroadCast } from '../utils/BroadCast';
import lazy { BroadCastConstants } from '../model/common/BroadCastConstants';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../utils/ReportToBigDataUtil';
import lazy { BroadCastManager } from '../model/common/BroadCastManager';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';

const TAG: string = 'Heic2JPGManagerAccess';
const JUMP_DELAY_TIME: number = 500;
const MAX_TRY_JUMP_COUNT: number = 3;
const appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

export class Heic2JPGManagerAccess {
  private static singletonInstance: Heic2JPGManagerAccess;
  public static MAX_WAIT_TIME: number = 30;
  public static AFTER_TOAST_DELAY: number = 1000;

  public static getInstance(): Heic2JPGManagerAccess {
    if (!Heic2JPGManagerAccess.singletonInstance) {
      Heic2JPGManagerAccess.singletonInstance = new Heic2JPGManagerAccess();
    }
    return Heic2JPGManagerAccess.singletonInstance;
  }

  public static isDirtyToJPG: boolean = false;
  public static jump2jpgTimer?: number = undefined;
  public static isJumpSuccess: boolean = false;
  public static targetIndex: number = -1;
  public static addedResUri: string = '';
  public static isToastShowing: boolean = false;
  public static toastShowingTimer: number = -1;
  private tryJumpTimes = 0;

  private jumpToIndex(targetIndex: number, isAnimating: boolean, controller?: SwiperController): void {
    if (!controller) {
      appBroadCast.emit(BroadCastConstants.SWIPER_CHANGE_AFTER_CONVERT, [targetIndex, isAnimating]);
    } else {
      controller.changeIndex(targetIndex, isAnimating);
    }
  }

  public setJumpPlan(targetIndex: number, isAnimating: boolean, controller?: SwiperController) {
    Heic2JPGManagerAccess.targetIndex = targetIndex;
    this.tryJumpTimes = 0;
    this.jumpToIndex(targetIndex, isAnimating, controller);
    Log.info(TAG, `setJumpPlan ${targetIndex}`);
    Heic2JPGManagerAccess.jump2jpgTimer && clearInterval(Heic2JPGManagerAccess.jump2jpgTimer);
    Heic2JPGManagerAccess.jump2jpgTimer = setInterval(() => {
      Log.info(TAG, `changeIndex newIndex ${Heic2JPGManagerAccess.targetIndex}`);
      this.jumpToIndex(targetIndex, isAnimating, controller);
      if (this.tryJumpTimes++ >= MAX_TRY_JUMP_COUNT) {
        clearInterval(Heic2JPGManagerAccess.jump2jpgTimer);
        Heic2JPGManagerAccess.jump2jpgTimer = undefined;
      }
    }, JUMP_DELAY_TIME)
    Heic2JPGManagerAccess.isDirtyToJPG = false;
    Heic2JPGManagerAccess.isJumpSuccess = false;
  }

  public verifyJumpSuccess(index: number) {
    if (index === Heic2JPGManagerAccess.targetIndex) {
      Heic2JPGManagerAccess.isJumpSuccess = true;
      Heic2JPGManagerAccess.jump2jpgTimer && clearInterval(Heic2JPGManagerAccess.jump2jpgTimer);
      Heic2JPGManagerAccess.jump2jpgTimer = undefined;
      Heic2JPGManagerAccess.targetIndex = -1;
      this.tryJumpTimes = 0;
      Log.info(TAG, `onDataPrepare ${index} isJumpSuccess = true`);
    }
  }

  /* instrument ignore next */
  private getFormatNumber(str: string): string {
    if (str.length === 1) {
      return `0${str}`;
    }
    return str;
  }
}