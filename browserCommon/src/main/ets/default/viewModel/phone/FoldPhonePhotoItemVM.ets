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

import lazy { display } from '@kit.ArkUI';
import lazy { getScreen, WindowMode } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { PhonePhotoItemVM } from './PhonePhotoItemVM';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { HALF_DIVIDER, QUARTER_DIVIDER } from '../base/PhotoItemVM';

/**
 * xxxxxx信息详情比例
 */
export const FOLD_EXPANDED_PERCENTAGE: number = 0.5;

export const FOLD_EXPANDED_RATIO_OFFSET: number = 5;

/* instrument ignore file */
export class FoldPhonePhotoItemVM extends PhonePhotoItemVM {
  private primaryRationOffset: number = 3;

  protected useImageSlideScale(): boolean {
    return (!DeviceInfo.isHalfFoldState() || this.isHorizontal);
  }

  protected isFoldExpanded(): boolean {
    let isFoldExpanded = AppStorage.get<boolean>('getFoldStatus') ?? false;
    return isFoldExpanded;
  }

  protected isDefaultWidth(): boolean {
    return !this.isFoldExpanded() && super.isDefaultWidth();
  }

  public isReachLowestBound(winLayoutW: number): boolean {
    let isReachLowestBound: boolean = super.isReachLowestBound(winLayoutW);

    if (this.isFoldExpanded() && !this.isThird && getScreen().getWinMode() !== WindowMode.UNDEFINED) {
      this.clipWidthTargetPercentage = 1 - this.getUnFolderVerticalDeviceWidth() / winLayoutW;
      // 窗口缩小
      isReachLowestBound = this.windowLayoutWidth >= winLayoutW && getScreen().isWinWidthGetToMinBound();
    }
    return isReachLowestBound;
  }

  // xxxxxx获取xxx竖屏宽度
  protected getUnFolderVerticalDeviceWidth(): number {
    let data: display.FoldCreaseRegion = display.getCurrentFoldCreaseRegion();
    let rectArea = data?.creaseRects[0] || {
      width: 0,
      left: 0,
      top: 0,
      height: 0,
    };
    let foldWidth = (rectArea.width / 2) - rectArea.height + Constants.FOLD_CREASE_REGION_DIFF_SIZE;
    return px2vp(foldWidth);
  }

  public slideTargetOffset(): number {
    /* instrument ignore next */
    if (DeviceInfo.isVerdeFoldable()) {
      return this.windowLayoutHeight / 2;
    }

    /* instrument ignore next */
    if (DeviceInfo.isPhoneVde() && !this.isHorizontal) {
      return this.windowLayoutHeight / 4;
    }

    if (this.isOnlyShowProperties && !DeviceInfo.isFoldable() && getScreen().getWinMode() !== WindowMode.FLOATING) {
      return this.windowLayoutHeight;
    }

    return this.getSlideTargetOffset();
  }

  protected getSlideTargetOffset(): number {
    if (this.isFoldExpanded()) {
      return this.calculatePhotoDetailWidth() / 2;
    }

    return super.getSlideTargetOffset();
  }

  public calculatePhotoDetailWidth(): number {
    if (this.isFoldExpanded()) {
      if (getScreen().getWinMode() !== WindowMode.UNDEFINED && !this.isThird) {
        return this.getUnFolderVerticalDeviceWidth();
      }
      return this.windowLayoutWidth * (1 - this.clipWidthTargetPercentage);
    }
    return super.calculatePhotoDetailWidth();
  }

  protected updateClipWidth(): number {
    let isHorizontal = this.isHorizontal;
    let isFoldExpanded = this.isFoldExpanded();
    if (isHorizontal && getScreen().getWinMode() !== WindowMode.UNDEFINED && !isFoldExpanded && !this.isThird) {
      return 1 - Constants.PROPERTIES_WIDTH / this.windowLayoutWidth;
    }

    if (isFoldExpanded) {
      return this.getFoldExpandedPercentage() || FOLD_EXPANDED_PERCENTAGE;
    }

    if (isHorizontal) {
      return Math.min(this.windowLayoutWidth, this.windowLayoutHeight) /
      Math.max(this.windowLayoutWidth, this.windowLayoutHeight);
    }
    return 1;
  }

  protected getFoldExpandedPercentage() {
    const unFolderWidth = this.getUnFolderVerticalDeviceWidth();
    return 1 - unFolderWidth / this.windowLayoutWidth;
  }

  public updateSlidePullUpOffsetState(): number {
    if (this.isDefaultWidth()) {
      return -Constants.SPLIT_LIST_CARD_WIDTH / HALF_DIVIDER;
    }

    if (this.isOnlyShowProperties) {
      return -this.windowLayoutHeight;
    }
    return -this.imageSlideTargetOffset;
  }

  public updateImageSlideTargetOffset(): number {
    this.updateSlideOffset();
    if (this.stateMachine.isPropertiesShow() && this.isDefaultWidth()) {
      return -Constants.SPLIT_LIST_CARD_WIDTH / HALF_DIVIDER;
    }

    if (this.isOnlyShowProperties) {
      return -this.windowLayoutHeight;
    }
    return -this.imageSlideTargetOffset;
  }

  public calcBarTopHeight(statusBarHeight: number): number {
    if (getScreen().getWinMode() === WindowMode.FULLSCREEN && this.isHorizontal &&
      !DeviceInfo.isFoldable() && !DeviceInfo.isHalfFoldState()) {
      return Constants.ActionBarHeight;
    }
    return Constants.ActionBarHeight + px2vp(statusBarHeight);
  }

  public calcBarBottomHeight(isSlideBarVisibility: boolean): number {
    if (getScreen().getWinMode() === WindowMode.FULLSCREEN) {
      if (this.isHorizontal) {
        return Constants.PreviewHeightHorizontal;
      }
      /* instrument ignore next */
      if (DeviceInfo.isFoldable()) {
        return Constants.ToolBarAvoidHeight + Constants.PreviewHeight;
      }
      /* instrument ignore next */
      if (DeviceInfo.isVerdeFoldable()) {
        if (isSlideBarVisibility) {
          return Constants.ToolBarHeight + Constants.PreviewHeight;
        }
        return Constants.ToolBarHeight;
      }
      return Constants.ToolBarAvoidHeight + Constants.ToolBarHeight + Constants.PreviewHeight;
    }

    if (getScreen().getWinMode() === WindowMode.FLOATING) {
      return Constants.ToolBarHeight + Constants.PreviewHeight;
    }
    return Constants.ToolBarHeight + Constants.PreviewHeight + this.aiBarBottomHeight;
  }

  protected isSetTargetW(): boolean {
    return this.isFoldExpanded() || super.isSetTargetW();
  }

  public async initSaliencyImageCenter(): Promise<void> {
    if (this.stateMachine.isPropertiesShow() && this.isDefaultWidth()) {
      return;
    }
    this.initSaliencyImageCenterInner();
  }

  protected isUpdateAllSystemUi(): boolean {
    return (this.isHorizontal || DeviceInfo.isHalfFoldState()) && !DeviceInfo.isFoldable();
  }

  public updateImageSlideInfo(currentImageWidth: number, currentImageHeight: number): void {
    if (getScreen().getWinMode() === WindowMode.UNDEFINED) {
      return;
    }

    let screenWidth = vp2px(this.windowLayoutWidth);
    let screenHeight = vp2px(this.windowLayoutHeight);
    if (this.stateMachine.isPropertiesShow() && this.isHorizontal && !this.isFoldExpanded() && !this.isThird) {
      this.imageSlideTargetScale = Math.max(screenWidth / currentImageWidth, screenHeight / currentImageHeight);
      this.imageSlideTargetOffset = this.windowLayoutHeight / QUARTER_DIVIDER;
    }

    if (this.isFoldExpanded() && !this.isThird) {
      this.imageSlideTargetOffset = this.windowLayoutHeight / QUARTER_DIVIDER;
      this.imageSlideTargetScale = Math.max(screenWidth / currentImageWidth, screenHeight / currentImageHeight);
    }

    if (this.isHorizontal) {
      this.imageSlideTargetScale = Math.max(screenWidth / currentImageWidth, screenHeight / currentImageHeight);
    }
  }

  protected needClip(screenWidth: number, screenHeight: number): boolean {
    if (this.isFoldExpanded() && !this.isThird && !this.isOnlyShowProperties) {
      return true;
    }
    return super.needClip(screenWidth, screenHeight);
  }

  protected getColumnsEightListCardWidth(): number {
    if (this.isFoldExpanded() && getScreen().getWinMode() !== WindowMode.UNDEFINED && !this.isThird) {
      return this.getUnFolderVerticalDeviceWidth() -
        Constants.SPLIT_LIST_CARD_MARGIN_COUNT * Constants.COLUMN_MARGIN;
    }
    return super.getColumnsEightListCardWidth();
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

    /* instrument ignore next */
    if (DeviceInfo.isFoldable() && getScreen().getWinMode() === WindowMode.PRIMARY) {
      return 0;
    }

    if (this.stateMachine.isPropertiesShow() && isHorizontal &&
      getScreen().getWinMode() !== WindowMode.UNDEFINED && !isFoldExpanded && !this.isThird) {
      return this.getImageSlidePullUpOffset();
    }
    return 0;
  }

  public getPropertiesTranslateX(): number | string {
    if (this.isFoldExpanded() && getScreen().getWinMode() === WindowMode.FULLSCREEN) {
      return this.getImageSlidePullUpOffset() * HALF_DIVIDER;
    }
    return super.getPropertiesTranslateX();
  }

  protected getFoldExpandedRatioOffset(): number {
    // return 10 * this.getFoldExpandedPercentage()
    return this.windowLayoutHeight / this.getUnFolderVerticalDeviceWidth() * HALF_DIVIDER;
  }

  public getPropertiesTranslateY(isFullMode: boolean, isWindowPcmode: boolean): number | string {
    let isFoldExpanded = this.isFoldExpanded();
    if (this.isHorizontal) {
      return 0;
    }

    if (isFoldExpanded && getScreen().getWinMode() === WindowMode.FULLSCREEN) {
      return 0;
    }
    if (!isFoldExpanded && !isFullMode) {
      return this.getImageSlidePullUpOffset();
    }

    if (isFoldExpanded && getScreen().getWinMode() === WindowMode.PRIMARY) {
      return this.primaryRationOffset * this.getImageSlidePullUpOffset();
    }

    if (isFoldExpanded && getScreen().getWinMode() === WindowMode.FLOATING) {
      return this.getImageSlidePullUpOffset();
    }

    if (isFoldExpanded) {
      let offset = (this.getFoldExpandedRatioOffset() || FOLD_EXPANDED_RATIO_OFFSET) * this.getImageSlidePullUpOffset();
      if (offset > -this.windowLayoutHeight) {
        return offset;
      }
      return -this.windowLayoutHeight;
    }
    return this.ratioOffset * this.getImageSlidePullUpOffset();
  }

  public getPropertiesPositionX(): number | string {
    if (this.isFoldExpanded() && getScreen().getWinMode() === WindowMode.FULLSCREEN) {
      return this.calculatePhotoDetailWidth();
    }
    return super.getPropertiesPositionX();
  }

  public getPropertiesPositionY(): number | string {
    if (this.isFoldExpanded() && getScreen().getWinMode() === WindowMode.FULLSCREEN) {
      return Constants.PERCENT_0;
    }
    return super.getPropertiesPositionY();
  }

  public getImageTranslateY(isFullMode: boolean): number | string {
    let isFoldExpanded = this.isFoldExpanded();
    let isHorizontal = this.isHorizontal;
    if (isFoldExpanded && isFullMode) {
      return 0;
    }

    if (isHorizontal && isFullMode) {
      return 0;
    }

    /* instrument ignore next */
    if (DeviceInfo.isFoldable() && getScreen().getWinMode() === WindowMode.PRIMARY) {
      return this.getImageSlidePullUpOffset();
    }

    if (this.stateMachine.isPropertiesShow() && isHorizontal && getScreen().getWinMode() !== WindowMode.UNDEFINED &&
      !isFoldExpanded && !this.isThird) {
      return 0
    }
    return this.getImageSlidePullUpOffset();
  }

  public getPhotoColumnAlignItems(isFullMode: boolean, isDoingImageSlideAnimation: boolean): HorizontalAlign {
    if (!this.stateMachine.isPropertiesShow() && !isDoingImageSlideAnimation) {
      return HorizontalAlign.Center;
    }

    if (isFullMode && (this.isHorizontal || this.isFoldExpanded())) {
      return HorizontalAlign.Start;
    }

    /* instrument ignore next */
    if (DeviceInfo.isFoldable() && getScreen().getWinMode() === WindowMode.PRIMARY) {
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

    /* instrument ignore next */
    if (DeviceInfo.isFoldable() && getScreen().getWinMode() === WindowMode.PRIMARY) {
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
    if (isFoldExpanded && getScreen().getWinMode() === WindowMode.PRIMARY) {
      return Constants.PERCENT_100;
    }

    if (isFoldExpanded && !this.isThird && getScreen().getWinMode() === WindowMode.FLOATING) {
      return Constants.PERCENT_100;
    }

    if (isFoldExpanded && !this.isThird && getScreen().getWinMode() !== WindowMode.UNDEFINED) {
      return `${this.clipWidthPercentage * 100}%`;
    }

    const isSpecialCase: boolean = ((isFoldExpanded && isFullMode) || (isHorizontal && isFullMode) ||
      (DeviceInfo.isFoldable() && getScreen().getWinMode() === WindowMode.PRIMARY));

    if (!isSpecialCase) {
      return Constants.PERCENT_100;
    }

    return (isHalfFold && !this.isHorizontal) ? Constants.PERCENT_100 : `${this.clipWidthPercentage * 100}%`;
  }

  public onWinModeChanged(): void {
    /* instrument ignore next */
    if (DeviceInfo.isFoldable() && getScreen().getWinMode() === WindowMode.PRIMARY) {
      this.propertiesIndex = 2;
    }
    this.clipWidthPercentage = this.isFoldExpanded() && !this.stateMachine.isPropertiesShow() ?
      this.clipWidthStartPercentage : this.clipWidthTargetPercentage;
    this.updateSlideOffset();
    this.setImageSlidePullUpOffset(this.updateWindowImageSlideTargetOffset());
  }
}