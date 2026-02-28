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
import lazy { HALF_DIVIDER, PhotoItemVM, QUARTER_DIVIDER } from '../base/PhotoItemVM';
import lazy { window } from '@kit.ArkUI';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';

/**
 * 悬浮窗窗口宽高比 9：16
 */
const FLOATING_RATIO: number = 0.5625;

/* instrument ignore file */
export class TabletPhotoItemVM extends PhotoItemVM {
  protected isDefaultWidth(): boolean {
    return getScreen().getWinMode() !== WindowMode.FLOATING || (this.isWindowPcmodeSwitchStatus() ?? true);
  }

  public slideTargetOffset(): number {
    if (this.isSmallFloating()) {
      return this.windowLayoutHeight;
    }
    if (this.isOnlyShowProperties && getScreen().getWinMode() !== WindowMode.FLOATING) {
      return this.windowLayoutHeight;
    }

    if (this.isHorizontal || getScreen().getWinMode() !== WindowMode.FLOATING ||
      this.stateMachine.isPropertiesShow()) {
      return this.calculatePhotoDetailWidth() / 2;
    }
    return Math.abs(this.windowLayoutWidth / 2 - this.windowLayoutHeight / 2);
  }

  public calculatePhotoDetailWidth(): number {
    if (this.isSmallFloating()) {
      return this.windowLayoutWidth;
    }

    if (this.isWindowPcmodeSwitchStatus()) {
      return this.windowLayoutWidth * (1 - this.clipWidthTargetPercentage);
    }

    if (getScreen().getWinMode() !== WindowMode.FLOATING) {
      return Constants.PROPERTIES_WIDTH;
    }

    if (this.isHorizontal) {
      return this.windowLayoutWidth * (1 - this.clipWidthTargetPercentage);
    }
    return this.windowLayoutWidth;
  }

  public isWindowPcmodeSwitchStatus(): boolean | undefined {
    let windowPcmodeSwitchStatus = AppStorage.get<boolean>('windowPcmodeSwitchStatus');
    return windowPcmodeSwitchStatus;
  }

  public isSmallFloating(): boolean {
    let windowStatus = AppStorage.get<window.WindowStatusType>('windowStatus');
    let windowPcmodeSwitchStatus = AppStorage.get<boolean>('windowPcmodeSwitchStatus');
    if (windowStatus !== window.WindowStatusType.FLOATING) {
      return false;
    }

    if (windowPcmodeSwitchStatus) {
      return false;
    }

    if (!this.isFloatingSmallSize()) {
      return false;
    }
    return true;
  }

  private isFloatingSmallSize(): boolean {
    return getScreen().getWinWidth() <= FLOATING_RATIO * getScreen().getWinHeight();
  }

  protected updateClipWidth(): number {
    if (this.isSmallFloating()) {
      return 1;
    }

    if (this.isWindowPcmodeSwitchStatus()) {
      return 1 - Constants.PROPERTIES_WIDTH / this.windowLayoutWidth;
    }

    if (getScreen().getWinMode() !== WindowMode.FLOATING) {
      return 1 - Constants.PROPERTIES_WIDTH / this.windowLayoutWidth;
    }

    if (this.isHorizontal || this.stateMachine.isPropertiesShow()) {
      return Math.min(this.windowLayoutWidth, this.windowLayoutHeight) /
      Math.max(this.windowLayoutWidth, this.windowLayoutHeight);
    }
    return 1;
  }

  protected isUpdateAllSystemUi(): boolean {
    return false;
  }

  public updateSlidePullUpOffsetState(): number {
    if (this.isSmallFloating()) {
      return -this.windowLayoutHeight;
    }

    if (this.isWindowPcmodeSwitchStatus()) {
      return -Constants.SPLIT_LIST_CARD_WIDTH / HALF_DIVIDER;
    }

    if (getScreen().getWinMode() !== WindowMode.FLOATING) {
      return -Constants.SPLIT_LIST_CARD_WIDTH / HALF_DIVIDER;
    }

    return (-Constants.SPLIT_LIST_CARD_WIDTH - Constants.PHOTO_LIST_CARD_PADDING * 2) / 2;
  }

  public updateImageSlideTargetOffset(): number {
    this.updateSlideOffset();
    if (this.isSmallFloating() && this.stateMachine.isPropertiesShow()) {
      return -this.windowLayoutHeight;
    }
    if (this.isWindowPcmodeSwitchStatus()) {
      return -Constants.SPLIT_LIST_CARD_WIDTH / HALF_DIVIDER;
    }

    if (getScreen().getWinMode() !== WindowMode.FLOATING) {
      return -Constants.SPLIT_LIST_CARD_WIDTH / HALF_DIVIDER;
    }
    return (-Constants.SPLIT_LIST_CARD_WIDTH - Constants.PHOTO_LIST_CARD_PADDING * 2) / 2;
  }

  public updateWindowImageSlideTargetOffset(): number {
    if (!this.stateMachine.isPropertiesShow()) {
      return 0;
    }
    if (this.isWindowPcmodeSwitchStatus()) {
      return (-Constants.SPLIT_LIST_CARD_WIDTH) / 2;
    }
    if (this.isSmallFloating()) {
      return -this.windowLayoutHeight;
    }

    if (!this.isOnlyShowProperties) {
      return -this.imageSlideTargetOffset;
    }

    if (getScreen().getWinMode() === WindowMode.FLOATING) {
      (-Constants.SPLIT_LIST_CARD_WIDTH - Constants.PHOTO_LIST_CARD_PADDING * 2) / 2;
    }
    return -this.windowLayoutHeight;
  }

  public async initSaliencyImageCenter(): Promise<void> {
    if (getScreen().getWinMode() !== WindowMode.FLOATING) {
      return;
    }
    this.initSaliencyImageCenterInner();
  }

  public updateImageSlideInfo(currentImageWidth: number, currentImageHeight: number): void {
    let screenWidth = vp2px(this.windowLayoutWidth);
    let screenHeight = vp2px(this.windowLayoutHeight);
    if (getScreen().getWinMode() !== WindowMode.FLOATING) {
      this.imageSlideTargetOffset = this.windowLayoutHeight / QUARTER_DIVIDER;
      this.imageSlideTargetScale = Math.max(screenWidth / currentImageWidth, screenHeight / currentImageHeight);
    } else {
      this.imageSlideTargetScale = Math.max(screenWidth, screenHeight) / this.minWidthOrHeight;
    }
  }

  public updatePropertiesIndex(): void {
    super.updatePropertiesIndex();
    if (getScreen().getWinMode() === WindowMode.FLOATING) {
      this.propertiesIndex = 1;
      this.ratioOffset = this.windowLayoutHeight / (Constants.SPLIT_LIST_CARD_WIDTH +
        Constants.PHOTO_LIST_CARD_PADDING * HALF_DIVIDER) * HALF_DIVIDER;
    }
    if (this.isFloatingSmallSize() && getScreen().getWinMode() !== WindowMode.FULLSCREEN) {
      this.propertiesIndex = 2;
    }
  }

  public getListCardWidth(listCardWidth: number): number {
    if (this.isSmallFloating()) {
      return Constants.SPLIT_LIST_CARD_WIDTH;
    }

    if (this.isWindowPcmodeSwitchStatus()) {
      return Constants.SPLIT_LIST_CARD_WIDTH - Constants.PHOTO_LIST_CARD_PADDING * HALF_DIVIDER;
    }

    if (getScreen().getWinMode() === WindowMode.FLOATING) {
      return Constants.SPLIT_LIST_CARD_WIDTH;
    }
    return super.getListCardWidth(listCardWidth);
  }

  protected getColumnsTwelveListCardWidth(): number {
    if (this.windowLayoutWidth > this.windowLayoutHeight) {
      return this.windowLayoutWidth - this.windowLayoutHeight -
        Constants.SPLIT_LIST_CARD_MARGIN_COUNT * Constants.COLUMN_MARGIN;
    }
    return super.getColumnsTwelveListCardWidth();
  }

  public getImageTranslateX(isFullMode: boolean): number | string {
    if (this.isSmallFloating()) {
      return 0;
    }

    if (isFullMode && this.isHorizontal) {
      return this.getImageSlidePullUpOffset();
    }

    if (getScreen().getWinMode() !== WindowMode.PRIMARY) {
      return this.getImageSlidePullUpOffset();
    }
    return 0;
  }

  public getPropertiesTranslateX(): number | string {
    if (this.isSmallFloating()) {
      return 0;
    }
    return this.getImageSlidePullUpOffset() * HALF_DIVIDER;
  }

  public getPropertiesTranslateY(isFullMode: boolean, isWindowPcmode: boolean): number | string {
    if (this.isSmallFloating()) {
      return this.getImageSlidePullUpOffset();
    }
    if (this.isWindowPcmodeSwitchStatus()) {
      return 0;
    }
    if (getScreen().getWinMode() === WindowMode.FLOATING) {
      return this.ratioOffset * this.getImageSlidePullUpOffset();
    }
    return 0;
  }

  public getPropertiesPositionX(): number | string {
    if (this.isSmallFloating()) {
      return Constants.PERCENT_0;
    }
    return this.calculatePhotoDetailWidth();
  }

  public getPropertiesPositionY(): number | string {
    if (this.isSmallFloating()) {
      return Constants.PERCENT_100;
    }
    return Constants.PERCENT_0;
  }

  public getImageTranslateY(isFullMode: boolean): number | string {
    if (this.isSmallFloating()) {
      return this.getImageSlidePullUpOffset();
    }
    return 0;
  }

  public getPhotoColumnAlignItems(isFullMode: boolean, isDoingImageSlideAnimation: boolean): HorizontalAlign {
    if (this.isSmallFloating()) {
      return HorizontalAlign.Center;
    }

    if (!this.stateMachine.isPropertiesShow() && !isDoingImageSlideAnimation) {
      return HorizontalAlign.Center;
    }

    if (this.isHorizontal && isFullMode) {
      return HorizontalAlign.Start;
    }

    if (getScreen().getWinMode() === WindowMode.FLOATING) {
      return HorizontalAlign.Start;
    }
    return HorizontalAlign.Center;
  }

  public getPhotoPropertiesAlignItems(isFullMode: boolean, isDoingImageSlideAnimation: boolean): HorizontalAlign {
    if (this.isSmallFloating()) {
      return HorizontalAlign.Center;
    }

    if (this.isWindowPcmodeSwitchStatus()) {
      return HorizontalAlign.End;
    }

    if (!this.stateMachine.isPropertiesShow() && isDoingImageSlideAnimation) {
      return HorizontalAlign.Center;
    }

    if (this.isHorizontal && isFullMode) {
      return HorizontalAlign.End;
    }

    if (!this.isHorizontal && getScreen().getWinMode() !== WindowMode.FLOATING) {
      return HorizontalAlign.End;
    }

    if (getScreen().getWinMode() === WindowMode.FLOATING) {
      return HorizontalAlign.End;
    }
    return HorizontalAlign.Center;
  }

  public getPhotoColumnWidth(isFullMode: boolean, isHalfFold: boolean): number | string {
    if (this.isSmallFloating() || LocalStorage.getShared()?.get<boolean>(Constants.IS_GALLERY_CLEANUP_PAGE)) {
      return Constants.PERCENT_100;
    }

    if (!this.stateMachine.isPropertiesShow()) {
      return Constants.PERCENT_100;
    }

    if (this.isWindowPcmodeSwitchStatus()) {
      return `${this.clipWidthPercentage * 100}%`;
    }

    if (getScreen().getWinMode() !== WindowMode.FLOATING && !this.isHorizontal && !this.isThird) {
      return `${this.clipWidthPercentage * 100}%`;
    }

    if (getScreen().getWinMode() === WindowMode.FLOATING) {
      return getScreen().getSplitImageWidth();
    }

    if (this.isHorizontal && isFullMode) {
      return `${this.clipWidthPercentage * 100}%`;
    }
    return Constants.PERCENT_100;
  }
}