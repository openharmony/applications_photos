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

import lazy { ColumnSize, getScreen, WindowMode } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { FoldUtil } from '@ohos/common/src/main/ets/default/utils/FoldUtil';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { FoldPhonePhotoItemVM, FOLD_EXPANDED_PERCENTAGE, FOLD_EXPANDED_RATIO_OFFSET } from './FoldPhonePhotoItemVM';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { HALF_DIVIDER, QUARTER_DIVIDER } from '../base/PhotoItemVM';

/* instrument ignore file */
export class ThirdFoldPhonePhotoItemVM extends FoldPhonePhotoItemVM {
  private isTriExpand(): boolean {
    let curFoldStatus = FoldUtil.getInstance().getCurFoldStatus();
    return FoldUtil.isTriExpand(curFoldStatus);
  }

  protected isDefaultWidth(): boolean {
    if (this.isTriExpand()) {
      return getScreen().getWinMode() !== WindowMode.FLOATING ||
        (this.isWindowPcmodeSwitchStatus() ?? true);
    }
    return super.isDefaultWidth();
  }

  public isUpdateSlideTargetOffset(): boolean {
    if (this.isTriExpand()) {
      return getScreen().getWinMode() !== WindowMode.FLOATING;
    }
    return super.isUpdateSlideTargetOffset();
  }

  protected isUpdateAllSystemUi(): boolean {
    if (this.isTriExpand()) {
      return false;
    }
    return super.isUpdateAllSystemUi();
  }

  public slideTargetOffset(): number {
    let isTriExpand = this.isTriExpand();
    let winMode = getScreen().getWinMode();
    if (this.isOnlyShowProperties && !DeviceInfo.isFoldable() &&
      !(winMode === WindowMode.FLOATING && isTriExpand)) {
      return this.windowLayoutHeight;
    }

    if (isTriExpand) {
      if (winMode === WindowMode.FLOATING && this.stateMachine.isPropertiesShow()) {
        return this.calculatePhotoDetailWidth() / 2;
      }

      if (!this.isHorizontal && winMode !== WindowMode.FLOATING) {
        return this.calculatePhotoDetailWidth() / 2;
      }
    }
    return this.getSlideTargetOffset();
  }

  public calculatePhotoDetailWidth(): number {
    let isTriExpand = this.isTriExpand();
    let winMode = getScreen().getWinMode();
    if (this.isFoldExpanded()) {
      if (winMode !== WindowMode.UNDEFINED && !this.isThird) {
        return this.getUnFolderVerticalDeviceWidth();
      }

      if (isTriExpand && this.isWindowPcmodeSwitchStatus()) {
        return this.windowLayoutWidth * (1 - this.clipWidthTargetPercentage);
      }

      if (isTriExpand && winMode !== WindowMode.FLOATING) {
        return Constants.PROPERTIES_WIDTH;
      }
      return this.windowLayoutWidth * (1 - this.clipWidthTargetPercentage);
    }

    if (this.isHorizontal) {
      if (isTriExpand && winMode !== WindowMode.FLOATING) {
        return Constants.PROPERTIES_WIDTH;
      }

      if (!isTriExpand && this.stateMachine.isPropertiesShow() &&
        winMode !== WindowMode.UNDEFINED && !this.isThird) {
        return Constants.PROPERTIES_WIDTH;
      }
      return this.windowLayoutWidth * (1 - this.clipWidthTargetPercentage);
    }

    if (isTriExpand && winMode !== WindowMode.FLOATING) {
      return Constants.PROPERTIES_WIDTH;
    }
    return this.windowLayoutWidth;
  }

  public isWindowPcmodeSwitchStatus(): boolean | undefined {
    return AppStorage.get<boolean>('windowPcmodeSwitchStatus') ?? false;
  }

  protected updateClipWidth(): number {
    let isTriExpand = this.isTriExpand();
    let winMode = getScreen().getWinMode();
    if (isTriExpand && winMode !== WindowMode.FLOATING) {
      return 1 - Constants.PROPERTIES_WIDTH / this.windowLayoutWidth;
    }

    if (isTriExpand && this.isWindowPcmodeSwitchStatus()) {
      return 1 - Constants.PROPERTIES_WIDTH / this.windowLayoutWidth;
    }

    if (!isTriExpand && this.isHorizontal &&
      winMode !== WindowMode.UNDEFINED && !this.isThird && !this.isFoldExpanded()) {
      return 1 - Constants.PROPERTIES_WIDTH / this.windowLayoutWidth;
    }

    if (this.isFoldExpanded()) {
      return this.getFoldExpandedPercentage() || FOLD_EXPANDED_PERCENTAGE;
    }

    if (this.isHorizontal) {
      return Math.min(this.windowLayoutWidth, this.windowLayoutHeight) /
      Math.max(this.windowLayoutWidth, this.windowLayoutHeight);
    }

    if (winMode === WindowMode.FLOATING && isTriExpand &&
    this.stateMachine.isPropertiesShow()) {
      return Math.min(this.windowLayoutWidth, this.windowLayoutHeight) /
      Math.max(this.windowLayoutWidth, this.windowLayoutHeight);
    }
    return 1;
  }

  public updateSlidePullUpOffsetState(): number {
    if (this.isDefaultWidth()) {
      return -Constants.SPLIT_LIST_CARD_WIDTH / HALF_DIVIDER;
    }

    let isTriExpand = this.isTriExpand();
    if (isTriExpand && this.isWindowPcmodeSwitchStatus()) {
      return -Constants.SPLIT_LIST_CARD_WIDTH / HALF_DIVIDER;
    }

    if (isTriExpand && getScreen().getWinMode() === WindowMode.FLOATING) {
      return (-Constants.SPLIT_LIST_CARD_WIDTH - Constants.PHOTO_LIST_CARD_PADDING * 2) / 2;
    }

    if (this.isOnlyShowProperties) {
      return -this.windowLayoutHeight;
    }
    return -this.imageSlideTargetOffset;
  }

  public updateImageSlideTargetOffset(): number {
    this.updateSlideOffset();
    let isTriExpand = this.isTriExpand();
    let winMode = getScreen().getWinMode();
    if (isTriExpand && winMode !== WindowMode.FLOATING) {
      return -Constants.SPLIT_LIST_CARD_WIDTH / HALF_DIVIDER;
    }

    if (isTriExpand && this.isWindowPcmodeSwitchStatus()) {
      return -Constants.SPLIT_LIST_CARD_WIDTH / HALF_DIVIDER;
    }

    if (!isTriExpand && this.stateMachine.isPropertiesShow() && this.isHorizontal &&
      winMode !== WindowMode.UNDEFINED && !this.isFoldExpanded && !this.isThird) {
      return -Constants.SPLIT_LIST_CARD_WIDTH / HALF_DIVIDER;
    }

    if (isTriExpand && winMode === WindowMode.FLOATING) {
      return (-Constants.SPLIT_LIST_CARD_WIDTH - Constants.PHOTO_LIST_CARD_PADDING * 2) / 2;
    }

    if (this.isOnlyShowProperties) {
      return -this.windowLayoutHeight;
    }
    return -this.imageSlideTargetOffset;
  }

  public updateWindowImageSlideTargetOffset(): number {
    if (!this.stateMachine.isPropertiesShow()) {
      return 0;
    }
    let isTriExpand = this.isTriExpand();
    if (isTriExpand && this.isWindowPcmodeSwitchStatus()) {
      return (-Constants.SPLIT_LIST_CARD_WIDTH) / 2;
    }

    if (!this.isOnlyShowProperties) {
      return -this.imageSlideTargetOffset;
    }

    if (isTriExpand && getScreen().getWinMode() === WindowMode.FLOATING) {
      return (-Constants.SPLIT_LIST_CARD_WIDTH - Constants.PHOTO_LIST_CARD_PADDING * 2) / 2;
    }
    return -this.windowLayoutHeight;
  }

  public calcBarTopHeight(statusBarHeight: number): number {
    if (getScreen().getWinMode() === WindowMode.FULLSCREEN && this.isHorizontal &&
      !this.isTriExpand() && !DeviceInfo.isFoldable() && !DeviceInfo.isHalfFoldState()) {
      return Constants.ActionBarHeight;
    }
    return Constants.ActionBarHeight + px2vp(statusBarHeight);
  }

  public calcBarBottomHeight(isSlideBarVisibility: boolean): number {
    let winMode = getScreen().getWinMode();
    // 全屏
    if (winMode === WindowMode.FULLSCREEN) {
      if (this.isHorizontal) {
        return Constants.PreviewHeightHorizontal;
      }
      /* instrument ignore next */
      if (DeviceInfo.isFoldable()) {
        return Constants.ToolBarAvoidHeight + Constants.PreviewHeight;
      }
      return Constants.ToolBarAvoidHeight + Constants.ToolBarHeight + Constants.PreviewHeight;
    }
    // 悬浮窗
    if (winMode === WindowMode.FLOATING) {
      return Constants.ToolBarHeight + Constants.PreviewHeight;
    }
    return Constants.ToolBarHeight + Constants.PreviewHeight + this.aiBarBottomHeight;
  }

  public async initSaliencyImageCenter(): Promise<void> {
    let isTriExpand = this.isTriExpand();
    let winMode = getScreen().getWinMode();
    if (isTriExpand && winMode !== WindowMode.FLOATING) {
      return;
    }

    if (!isTriExpand && this.stateMachine.isPropertiesShow() && this.isHorizontal && !this.isFoldExpanded() &&
      winMode !== WindowMode.UNDEFINED && !this.isThird) {
      return;
    }
    this.initSaliencyImageCenterInner();
  }

  public updateImageSlideInfo(currentImageWidth: number, currentImageHeight: number): void {
    let screenWidth = vp2px(this.windowLayoutWidth);
    let screenHeight = vp2px(this.windowLayoutHeight);
    let isTriExpand = this.isTriExpand();
    let winMode = getScreen().getWinMode();
    if (isTriExpand && winMode !== WindowMode.FLOATING) {
      this.imageSlideTargetOffset = this.windowLayoutHeight / QUARTER_DIVIDER;
      this.imageSlideTargetScale = Math.max(screenWidth / currentImageWidth, screenHeight / currentImageHeight);
    }

    if (!isTriExpand && this.stateMachine.isPropertiesShow() && this.isHorizontal &&
      winMode !== WindowMode.UNDEFINED && !this.isThird) {
      this.imageSlideTargetOffset = this.windowLayoutHeight / QUARTER_DIVIDER;
      this.imageSlideTargetScale = Math.max(screenWidth / currentImageWidth, screenHeight / currentImageHeight);
    }

    if (this.isFoldExpanded() && winMode !== WindowMode.UNDEFINED && !this.isThird) {
      this.imageSlideTargetOffset = this.windowLayoutHeight / QUARTER_DIVIDER;
      this.imageSlideTargetScale = Math.max(screenWidth / currentImageWidth, screenHeight / currentImageHeight);
    }

    if (!isTriExpand && this.isHorizontal && winMode !== WindowMode.UNDEFINED) {
      this.imageSlideTargetScale = Math.max(screenWidth / currentImageWidth,
        screenHeight / currentImageHeight);
    }

    if (isTriExpand && winMode === WindowMode.FLOATING) {
      this.imageSlideTargetScale = Math.max(screenWidth, screenHeight) / this.minWidthOrHeight;
    }
  }

  public updatePropertiesIndex(): void {
    super.updatePropertiesIndex();
    if (getScreen().getWinMode() === WindowMode.FLOATING && this.isTriExpand()) {
      this.propertiesIndex = 2;
      this.ratioOffset = this.windowLayoutHeight / (Constants.SPLIT_LIST_CARD_WIDTH +
        Constants.PHOTO_LIST_CARD_PADDING * HALF_DIVIDER) * HALF_DIVIDER;
    }
  }

  protected getColumnsEightListCardWidth(): number {
    if (this.isFoldExpanded() && getScreen().getWinMode() !== WindowMode.UNDEFINED && !this.isThird) {
      return this.getUnFolderVerticalDeviceWidth() -
        Constants.SPLIT_LIST_CARD_MARGIN_COUNT * Constants.COLUMN_MARGIN;
    }

    if (this.windowLayoutWidth > this.windowLayoutHeight && !this.isTriExpand()) {
      return this.windowLayoutWidth - this.windowLayoutHeight -
        Constants.SPLIT_LIST_CARD_MARGIN_COUNT * Constants.COLUMN_MARGIN;
    }
    return getScreen().getColumnsWidth(ColumnSize.COLUMN_SIX);
  }

  public getListCardWidth(listCardWidth: number): number {
    if (this.isTriExpand() && this.isWindowPcmodeSwitchStatus()) {
      return Constants.SPLIT_LIST_CARD_WIDTH - Constants.PHOTO_LIST_CARD_PADDING * HALF_DIVIDER;
    }

    if (getScreen().getWinMode() === WindowMode.FLOATING && this.isTriExpand()) {
      return Constants.SPLIT_LIST_CARD_WIDTH;
    }
    return super.getListCardWidth(listCardWidth);
  }

  protected getColumnsTwelveListCardWidth(): number {
    if (this.windowLayoutWidth > this.windowLayoutHeight && this.isTriExpand()) {
      return this.windowLayoutWidth - this.windowLayoutHeight -
        Constants.SPLIT_LIST_CARD_MARGIN_COUNT * Constants.COLUMN_MARGIN;
    }
    return super.getColumnsTwelveListCardWidth();
  }

  public getImageTranslateX(isFullMode: boolean): number | string {
    let isFoldExpanded = this.isFoldExpanded();
    let isHorizontal = this.isHorizontal;
    /* instrument ignore if */
    if (isFoldExpanded && isFullMode) {
      return 0;
    }
    if (isFullMode && (isFoldExpanded || isHorizontal)) {
      return this.getImageSlidePullUpOffset();
    }

    let isTriExpand = this.isTriExpand();
    let winMode = getScreen().getWinMode();
    if (isTriExpand && winMode !== WindowMode.FLOATING) {
      return this.getImageSlidePullUpOffset();
    }

    /* instrument ignore next */
    if (DeviceInfo.isFoldable() && winMode === WindowMode.PRIMARY) {
      return this.getImageSlidePullUpOffset();
    }

    if (this.stateMachine.isPropertiesShow() && isHorizontal && !isFoldExpanded && !isTriExpand &&
      winMode !== WindowMode.UNDEFINED && !isFoldExpanded && !this.isThird) {
      return this.getImageSlidePullUpOffset();
    }
    return 0;
  }

  public getPropertiesTranslateX(): number | string {
    if (this.isHorizontal) {
      return this.getImageSlidePullUpOffset() * HALF_DIVIDER;
    }
    let winMode = getScreen().getWinMode();
    let isTriExpand = this.isTriExpand();
    if(isTriExpand) {
      if(winMode !== WindowMode.FLOATING || this.isWindowPcmodeSwitchStatus()) {
        return this.getImageSlidePullUpOffset() * HALF_DIVIDER;
      }
    }
    if (this.isFoldExpanded() && winMode === WindowMode.FULLSCREEN) {
      return this.getImageSlidePullUpOffset() * HALF_DIVIDER;
    }
    return 0;
  }

  public getPropertiesTranslateY(isFullMode: boolean, isWindowPcmode: boolean): number | string {
    if (this.isTriExpand()) {
      if (this.isWindowPcmodeSwitchStatus()) {
        return 0;
      }

      return getScreen().getWinMode() === WindowMode.FLOATING ?
        this.ratioOffset * this.getImageSlidePullUpOffset() : 0
    }
    return super.getPropertiesTranslateY(isFullMode, isWindowPcmode);
  }

  public getPropertiesPositionX(): number | string {
    if (this.isTriExpand()) {
      return getScreen().getWinMode() === WindowMode.FLOATING && !this.isWindowPcmodeSwitchStatus() ?
        0 : this.calculatePhotoDetailWidth();
    }
    return super.getPropertiesPositionX();
  }

  public getPropertiesPositionY(): number | string {
    if (this.isTriExpand() && getScreen().getWinMode() !== WindowMode.FLOATING) {
      return Constants.PERCENT_0;
    }
    return super.getPropertiesPositionY();
  }

  public getImageTranslateY(isFullMode: boolean): number | string {
    if (this.isTriExpand() && getScreen().getWinMode() !== WindowMode.FLOATING) {
      return 0;
    }

    if (this.isTriExpand() && getScreen().getWinMode() === WindowMode.FLOATING) {
      return this.ratioOffset * this.getImageSlidePullUpOffset();
    }

    return super.getImageTranslateY(isFullMode);
  }

  public getPhotoColumnAlignItems(isFullMode: boolean, isDoingImageSlideAnimation: boolean): HorizontalAlign {
    if (!this.stateMachine.isPropertiesShow() && !isDoingImageSlideAnimation) {
      return HorizontalAlign.Center;
    }

    if (isFullMode) {
      if (this.isHorizontal || this.isFoldExpanded()) {
        return HorizontalAlign.Start;
      }
    }
    let winMode = getScreen().getWinMode();
    if (this.isTriExpand()) {
      return winMode === WindowMode.FLOATING ? HorizontalAlign.Center :
        HorizontalAlign.Start;
    }
    /* instrument ignore next */
    if (DeviceInfo.isFoldable() && winMode === WindowMode.PRIMARY) {
      return HorizontalAlign.Start;
    }
    return HorizontalAlign.Center;
  }

  public getPhotoPropertiesAlignItems(isFullMode: boolean, isDoingImageSlideAnimation: boolean): HorizontalAlign {
    if (!this.stateMachine.isPropertiesShow() && isDoingImageSlideAnimation) {
      return HorizontalAlign.Center;
    }

    if (isFullMode) {
      if (this.isFoldExpanded() || this.isHorizontal) {
        return HorizontalAlign.End;
      }
    }

    let winMode = getScreen().getWinMode();
    if (this.isTriExpand()) {
      if (this.isWindowPcmodeSwitchStatus()) {
        return HorizontalAlign.End;
      }

      if (winMode === WindowMode.FLOATING) {
        return HorizontalAlign.Center;
      }

      if (!this.isHorizontal) {
        return HorizontalAlign.End;
      }
    }

    /* instrument ignore next */
    if (DeviceInfo.isFoldable() && winMode === WindowMode.PRIMARY) {
      return HorizontalAlign.End;
    }
    return HorizontalAlign.Center;
  }

  public getPhotoColumnWidth(isFullMode: boolean, isHalfFold: boolean): number | string {
    if (LocalStorage.getShared()?.get<boolean>(Constants.IS_GALLERY_CLEANUP_PAGE)) {
      return Constants.PERCENT_100;
    }

    if (!this.stateMachine.isPropertiesShow()) {
      return Constants.PERCENT_100;
    }

    let isFoldExpanded = this.isFoldExpanded();
    let isHorizontal = this.isHorizontal;
    let isTriExpand = this.isTriExpand();
    let winMode = getScreen().getWinMode();
    if (isTriExpand && this.isWindowPcmodeSwitchStatus()) {
      return `${this.clipWidthPercentage * 100}%`;
    }

    if (isTriExpand && winMode !== WindowMode.FLOATING && !isHorizontal && !this.isThird) {
      return `${this.clipWidthPercentage * 100}%`;
    }

    if (isFoldExpanded && !this.isThird && getScreen().getWinMode() === WindowMode.FLOATING) {
      return Constants.PERCENT_100;
    }

    if (isFoldExpanded && !this.isThird && winMode !== WindowMode.UNDEFINED) {
      return `${this.clipWidthPercentage * 100}%`;
    }

    if (isTriExpand && winMode === WindowMode.FLOATING) {
      return getScreen().getSplitImageWidth();
    }

    if (isFullMode && isFoldExpanded) {
      if (!isHorizontal && isHalfFold) {
        return Constants.PERCENT_100;
      }
      return `${this.clipWidthPercentage * 100}%`;
    }

    if (isHorizontal && isFullMode) {
      return `${this.clipWidthPercentage * 100}%`;
    }

    /* instrument ignore next */
    if (DeviceInfo.isFoldable() && winMode === WindowMode.PRIMARY) {
      if (!isHorizontal && isHalfFold) {
        return Constants.PERCENT_100;
      }
      return `${this.clipWidthPercentage * 100}%`;
    }

    return Constants.PERCENT_100;
  }

  public onWinModeChanged(): void {
    /* instrument ignore next */
    if (DeviceInfo.isFoldable() && getScreen().getWinMode() === WindowMode.PRIMARY) {
      this.propertiesIndex = 2;
    }
    let curFoldStatus = FoldUtil.getInstance().getCurFoldStatus();
    this.clipWidthPercentage = (FoldUtil.isTriFullExpand(curFoldStatus) || this.isFoldExpanded()) &&
      !this.stateMachine.isPropertiesShow() ? this.clipWidthStartPercentage : this.clipWidthTargetPercentage;
    this.updateSlideOffset();
    this.setImageSlidePullUpOffset(this.updateWindowImageSlideTargetOffset());
  }
}