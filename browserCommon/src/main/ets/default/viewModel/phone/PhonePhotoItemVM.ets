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
import lazy { getScreen, WindowMode } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { HALF_DIVIDER, PhotoItemVM, QUARTER_DIVIDER } from '../base/PhotoItemVM';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { TAG } from '@ohos/common/src/main/ets/default/task/RequestQualityTask';

/* instrument ignore file */
export class PhonePhotoItemVM extends PhotoItemVM {
  protected isDefaultWidth(): boolean {
    return !this.isThird && this.isHorizontal && getScreen().getWinMode() !== WindowMode.UNDEFINED;
  }

  public isUpdateSlideTargetOffset(): boolean {
    return this.stateMachine.isPropertiesShow() && this.isDefaultWidth();
  }

  protected getSlideTargetOffset(): number {
    if (this.isHorizontal) {
      return this.calculatePhotoDetailWidth() / 2;
    }
    return Math.abs(this.windowLayoutWidth / 2 - this.windowLayoutHeight / 2);
  }

  public slideTargetOffset(): number {
    if (this.isOnlyShowProperties) {
      return this.windowLayoutHeight;
    }
    return this.getSlideTargetOffset();
  }

  public calculatePhotoDetailWidth(): number {
    if (this.isHorizontal) {
      if (this.stateMachine.isPropertiesShow() && getScreen().getWinMode() !== WindowMode.UNDEFINED && !this.isThird) {
        return Constants.PROPERTIES_WIDTH;
      }
      return this.windowLayoutWidth * (1 - this.clipWidthTargetPercentage);
    }

    return this.windowLayoutWidth;
  }

  protected updateClipWidth(): number {
    if (!this.isHorizontal) {
      return 1;
    }

    if (getScreen().getWinMode() !== WindowMode.UNDEFINED && !this.isThird) {
      return 1 - Constants.PROPERTIES_WIDTH / this.windowLayoutWidth;
    }
    return Math.min(this.windowLayoutWidth, this.windowLayoutHeight) /
    Math.max(this.windowLayoutWidth, this.windowLayoutHeight);
  }

  public updateSlidePullUpOffsetState(): number {
    if (this.isHorizontal && getScreen().getWinMode() !== WindowMode.UNDEFINED && !this.isThird) {
      return -Constants.SPLIT_LIST_CARD_WIDTH / HALF_DIVIDER;
    }
    return super.updateSlidePullUpOffsetState();
  }

  public updateImageSlideTargetOffset(): number {
    this.updateSlideOffset();
    if (this.stateMachine.isPropertiesShow() && this.isHorizontal &&
      getScreen().getWinMode() !== WindowMode.UNDEFINED && !this.isThird) {
      return -Constants.SPLIT_LIST_CARD_WIDTH / HALF_DIVIDER;
    }
    return super.updateSlidePullUpOffsetState();
  }

  public calcBarTopHeight(statusBarHeight: number): number {
    if (getScreen().getWinMode() === WindowMode.FULLSCREEN && this.isHorizontal) {
      return Constants.ActionBarHeight;
    }
    return Constants.ActionBarHeight + px2vp(statusBarHeight);
  }

  public async initSaliencyImageCenter(): Promise<void> {
    if (this.stateMachine.isPropertiesShow() && this.isHorizontal &&
      getScreen().getWinMode() !== WindowMode.UNDEFINED && !this.isThird) {
      return;
    }
    this.initSaliencyImageCenterInner();
  }

  public updateImageSlideInfo(currentImageWidth: number, currentImageHeight: number): void {
    let screenWidth = vp2px(this.windowLayoutWidth);
    let screenHeight = vp2px(this.windowLayoutHeight);
    if (this.isHorizontal && getScreen().getWinMode() !== WindowMode.UNDEFINED) {
      this.imageSlideTargetScale = Math.max(screenWidth / currentImageWidth, screenHeight / currentImageHeight);
      if (this.stateMachine.isPropertiesShow() && !this.isThird) {
        this.imageSlideTargetOffset = this.windowLayoutHeight / QUARTER_DIVIDER;
      }
    }
  }

  protected getColumnsEightListCardWidth(): number {
    if (this.windowLayoutWidth > this.windowLayoutHeight) {
      return this.windowLayoutWidth - this.windowLayoutHeight -
        Constants.SPLIT_LIST_CARD_MARGIN_COUNT * Constants.COLUMN_MARGIN;
    }
    return super.getColumnsEightListCardWidth();
  }

  public getImageTranslateX(isFullMode: boolean): number | string {
    Log.info(TAG, 'getImageTranslateX')
    if (isFullMode && this.isHorizontal) {
      return this.getImageSlidePullUpOffset();
    }

    if (getScreen().getWinMode() !== WindowMode.UNDEFINED &&
      this.stateMachine.isPropertiesShow() && !this.isThird && this.isHorizontal) {
      return this.getImageSlidePullUpOffset();
    }
    return 0;
  }

  public getPropertiesTranslateX(): number | string {
    if (this.isHorizontal) {
      return this.getImageSlidePullUpOffset() * HALF_DIVIDER;
    }
    return 0;
  }

  public getPropertiesTranslateY(isFullMode: boolean, isWindowPcmode: boolean): number | string {
    if (this.isHorizontal) {
      return 0;
    }
    return super.getPropertiesTranslateY(isFullMode, isWindowPcmode);
  }

  public getPropertiesPositionX(): number | string {
    if (this.isHorizontal) {
      return this.calculatePhotoDetailWidth();
    }
    return Constants.PERCENT_0;
  }

  public getPropertiesPositionY(): number | string {
    if (this.isHorizontal) {
      return Constants.PERCENT_0;
    }
    return Constants.PERCENT_100;
  }

  public getImageTranslateY(isFullMode: boolean): number | string {
    if (this.isHorizontal && isFullMode) {
      return 0;
    }

    if (this.stateMachine.isPropertiesShow() && this.isHorizontal &&
      getScreen().getWinMode() !== WindowMode.UNDEFINED && !this.isThird) {
      return 0;
    }
    return this.getImageSlidePullUpOffset();
  }

  /* 获取图片容器宽度 */
  public getPhotoColumnWidth(isFullMode: boolean, isHalfFold: boolean): number | string {
    if (LocalStorage.getShared()?.get<boolean>(Constants.IS_GALLERY_CLEANUP_PAGE)) {
      return Constants.PERCENT_100;
    }

    if (this.isHorizontal && isFullMode && this.stateMachine.isPropertiesShow()) {
      return `${this.clipWidthPercentage * 100}%`;
    }
    return Constants.PERCENT_100;
  }
}