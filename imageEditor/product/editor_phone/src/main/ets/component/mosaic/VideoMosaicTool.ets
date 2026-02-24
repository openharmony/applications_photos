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

import {
  App,
  HiLog,
  BaseEditor,
  SCREEN_ORIENTATION_PORTRAIT,
  TOOL_CONTAINER_HEIGHT,
  WIN_HEIGHT_KEY,
  WIN_WIDTH_KEY,
  WINDOW_STATUS_KEY,
  TOP_OFFSET_PHONE,
  LANDSCAPE_TOP_MARGIN,
  BOTTOM_AVOID_HEIGHT,
  LANDSCAPE_LENGTH_RATIO,
  WINDOW_MODE_DECOR_BAR,
  BOTTOM_NAVIGATION_HEIGHT,
  BOTTOM_LANDSCAPE_OFFSET_PHONE_FOR_IMAGE,
  THIRD_TOOL_BAR_HEIGHT,
  ScreenManager,
  DEVICE_FOLD_STATUS,
  Asset,
  MosaicAttr,
  ResourceButtonItem,
  DeviceUtil,
  UiUtil
} from '@oh-image-editor/editor-common';
import { accessibility } from '@kit.AccessibilityKit';
import { MosaicSelection } from './MosaicSelection';
import { ScreenClass } from '@oh-image-editor/editor-common/src/main/ets/service/App';
import { ADJUST_AND_FILTER_SCROLL_DELAY } from '@oh-image-editor/editor-common/src/main/ets/common/const';
import { PenSizeBar } from "@oh-image-editor/editor-common/src/main/ets/common/components/PenSizeBar";

const PORTRAIT_BAR_LENGTH: number = 176;
// 按钮总长度
const BUTTONS_LENGTH: number = 152;
const BUTTONS_WIDTH: number = 104;
// 笔画粗细调节条两端半径大小
const BAR_MIN_RADIUS: number = 1.5;
const BAR_MAX_RADIUS: number = 5.5;
// 平板笔画粗细调节条两端半径大小
const PAD_BAR_MIN_RADIUS: number = 2
const PAD_BAR_MAX_RADIUS: number = 8;
const PAD_PORTRAIT_BAR_MARGIN: number = 72;
const PHONE_PORTRAIT_BAR_MARGIN: number = 16;
// 笔画粗细调节条最大长度
const BAR_MAX_LENGTH: number = 470;

let TAG: string = 'VideoMosaicTool';

@Component
export struct VideoMosaicTool {
  @State @Watch('changeProgress') mosaicAttr: MosaicAttr = App.getInstance().myEditor().asset.mosaic();
  // 判断是否镜像语言
  @StorageLink('currentLanguage') @Watch('onLanguageChanged') language: string = '';
  @StorageProp(WIN_HEIGHT_KEY) @Watch('refreshHeight') winHeight: number = ScreenManager.getInstance().height;
  @StorageProp(WIN_WIDTH_KEY) @Watch('refreshHeight') winWidth: number = ScreenManager.getInstance().width;
  @StorageProp(WINDOW_STATUS_KEY) @Watch('refreshToolContainerParam') isSmallWindowMode: boolean =
    ScreenManager.getInstance().getSmallWindowMode();
  @State @Watch('refreshToolContainerParam') screenClass: ScreenClass = App.getInstance().screenClass;
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State asset: Asset = App.getInstance().myEditor().asset;
  public imageDataList: ResourceButtonItem[] = this.mosaicAttr.mosaicImageList as ResourceButtonItem[];
  @State isScrolling: number = 0;
  @State isScroll: boolean = false;
  @State isMirrorMode: boolean = false;
  @State penSizeBarLength: number = PORTRAIT_BAR_LENGTH; // 画笔粗细调节条长度
  @State minRadius: number = BAR_MIN_RADIUS; // 画笔粗细调节条小端半径大小
  @State maxRadius: number = BAR_MAX_RADIUS; // 画笔粗细调节条大端半径大小
  @State toolContainerWidth: Length = '100%';
  @State toolContainerHeight: Length = THIRD_TOOL_BAR_HEIGHT;
  @State isSplitMode: boolean = false;
  @StorageProp(DEVICE_FOLD_STATUS) @Watch('scrolling') isFold: boolean = ScreenManager.getInstance().isDeviceFold();
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) @Watch('scrolling') isScreenPortrait: boolean =
    ScreenManager.getInstance().isScreenPortrait();
  private scrollTimeFn = -1;
  private languageChangedTimer: number = -1;
  private refreshHeightTimer: number = -1;

  changeProgress(): void {
    if (this.mosaicAttr.isClickUndoRedo || this.editor.isOpenInitReset || this.editor.isResetFilter) {
      this.isScrolling++;
    }
  }

  onLanguageChanged() {
    if (this.languageChangedTimer != -1) {
      clearTimeout(this.languageChangedTimer);
    }
    this.languageChangedTimer = setTimeout(() => {
      this.isMirrorMode = UiUtil.isMirrorMode();
      this.languageChangedTimer = -1;
      HiLog.i(TAG, `onLanguageChanged is ${this.isMirrorMode}`);
    }, 5)
  }

  scrolling(): void {
    clearTimeout(this.scrollTimeFn);
    this.scrollTimeFn = setTimeout((): void => {
      this.isScrolling++;
    }, ADJUST_AND_FILTER_SCROLL_DELAY)
    this.refreshHeight();
  }

  refreshHeight() {
    if (this.refreshHeightTimer !== -1) {
      clearTimeout(this.refreshHeightTimer);
    }
    this.refreshHeightTimer = setTimeout((): void => {
      HiLog.i(TAG, 'refreshHeight enter');
      this.isSplitMode = ScreenManager.getInstance().isSplitMode();
      this.isFold = ScreenManager.getInstance().isDeviceFold();
      this.isScreenPortrait = ScreenManager.getInstance().isScreenPortrait();
      this.refreshToolContainerParam();
      this.refreshHeightTimer = -1;
    }, 50);
  }
  // instrument ignore next
  private refreshToolContainerParam(): void {
    this.winHeight = ScreenManager.getInstance().height;
    this.winWidth = ScreenManager.getInstance().width;
    HiLog.i(TAG, `refreshToolContainerParam winHeight ${this.winHeight} winWidth is ${this.winWidth}`);
    this.minRadius = PAD_BAR_MIN_RADIUS;
    this.maxRadius = PAD_BAR_MAX_RADIUS;
    if (this.isFoldableLayout() || this.isTriFoldableLayout()) {
      if (!this.asset.isUnfoldPortrait) {
        this.screenFlodLeftRightLayout();
        return;
      }
      if (DeviceUtil.isTriFoldFullExpanded()) {
        this.screenThreeFlodUpDownLandLayout();
      } else {
        this.screenFlodUpDownLayout();
      }
    } else if (this.isPadLayout()) {
      this.screenIpadLayout();
    } else {
      this.screenCommonLayout();
    }
    HiLog.i(TAG, `refreshToolContainerParam penSizeBarLength is ${this.penSizeBarLength}`);
  }

  // xxxxxx上下横屏布局
  // instrument ignore next
  private screenThreeFlodUpDownLandLayout(): void {
    const lauoutWidth = this.isScreenPortrait ? this.winWidth : this.winHeight;
    const scale = this.isScreenPortrait ? (lauoutWidth > 1000 ? LANDSCAPE_LENGTH_RATIO : 0.8) : LANDSCAPE_LENGTH_RATIO;
    this.toolContainerWidth = (lauoutWidth - TOP_OFFSET_PHONE - this.screenClass.avoidTop -
      BOTTOM_AVOID_HEIGHT) * scale;
    this.setBarMaxLength(this.toolContainerWidth - BUTTONS_WIDTH);
    HiLog.i(TAG, 'refreshToolContainerParam screenThreeFlodUpDownLandLayout');
  }

  // xxxxxx上下横竖屏布局
  private screenFlodUpDownLayout(): void {
    this.toolContainerWidth = this.winWidth - PAD_PORTRAIT_BAR_MARGIN * 2;
    this.setBarMaxLength(this.toolContainerWidth - BUTTONS_LENGTH);
    HiLog.i(TAG, 'refreshToolContainerParam screenFlodUpDownLayout');
  }

  // xxxxxx左右横竖屏布局
  private screenFlodLeftRightLayout(): void {
    this.toolContainerHeight = (this.winHeight - TOP_OFFSET_PHONE - this.screenClass.avoidTop -
      BOTTOM_AVOID_HEIGHT) * LANDSCAPE_LENGTH_RATIO;
    this.setBarMaxLength(this.toolContainerHeight - BUTTONS_WIDTH);
    HiLog.i(TAG, `refreshToolContainerParam screenFlodLeftRightLayout ${this.penSizeBarLength}`);
  }

  // iPad布局
  // instrument ignore next
  private screenIpadLayout(): void {
    let decorBar: number = ScreenManager.getInstance().isWindowMode() ? WINDOW_MODE_DECOR_BAR : 0;
    this.toolContainerWidth = this.isScreenPortrait ?
      this.winWidth - PAD_PORTRAIT_BAR_MARGIN * 2 : THIRD_TOOL_BAR_HEIGHT;
    this.toolContainerHeight = this.isScreenPortrait ? THIRD_TOOL_BAR_HEIGHT : (this.winHeight -
    this.screenClass.avoidTop - BOTTOM_AVOID_HEIGHT - TOP_OFFSET_PHONE - decorBar) * LANDSCAPE_LENGTH_RATIO;
    const barLen = this.isScreenPortrait ? this.toolContainerWidth - BUTTONS_LENGTH :
      this.toolContainerHeight - BUTTONS_WIDTH;
    this.setBarMaxLength(barLen);
    HiLog.i(TAG, 'refreshToolContainerParam isPad');
  }

  // 屏幕通用布局（直板布局）
  private screenCommonLayout(): void {
    this.minRadius = BAR_MIN_RADIUS;
    this.maxRadius = BAR_MAX_RADIUS;
    this.toolContainerHeight = this.isScreenPortrait ? THIRD_TOOL_BAR_HEIGHT :
      this.winHeight - TOP_OFFSET_PHONE - LANDSCAPE_TOP_MARGIN - this.screenClass.avoidTop - BOTTOM_NAVIGATION_HEIGHT;
    this.toolContainerWidth = this.isScreenPortrait ?
      this.winWidth - PHONE_PORTRAIT_BAR_MARGIN * 2 : THIRD_TOOL_BAR_HEIGHT;
    const barLen = this.isScreenPortrait ? this.toolContainerWidth - BUTTONS_LENGTH :
      this.toolContainerHeight - BOTTOM_LANDSCAPE_OFFSET_PHONE_FOR_IMAGE;
     this.setBarMaxLength(barLen);
    HiLog.i(TAG, 'refreshTriFoldScreen screenCommonLayout');
  }

  // 设置画笔最大高度
  // instrument ignore next
  private setBarMaxLength(barLen: number): void {
    const penBarLen = barLen - this.minRadius - this.maxRadius;
    this.penSizeBarLength = penBarLen > BAR_MAX_LENGTH ? BAR_MAX_LENGTH : penBarLen;
  }

  // 是否xxx
  private isTriFoldableLayout(): boolean {
    return (DeviceUtil.isTriFoldLandScape() || DeviceUtil.isTriFoldFullExpanded()) &&
      !this.isSplitMode && !this.isSmallWindowMode;
  }

  // 是否xxx
  private isFoldableLayout(): boolean {
    return DeviceUtil.isFoldable() && !this.isFold && !this.isSplitMode && !this.isSmallWindowMode;
  }

  // 是否IPad
  private isPadLayout(): boolean {
    return (DeviceUtil.isPad() || (DeviceUtil.isPad() && this.isSplitMode));
  }

  aboutToAppear() {
    this.onLanguageChanged();
    this.refreshToolContainerParam();
  }

  build() {
    Flex({
      direction: this.isScreenPortrait ? FlexDirection.Column : FlexDirection.Row,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center,
    }) {
      this.subMosaicSize();
      this.subMosaicType();
    }
    .id('petalclip_videoMosaicTool')
  }

  @Builder
  subMosaicSize() {
    Flex({
      direction: this.isScreenPortrait ? FlexDirection.Row : FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center,
    }) {
      Stack() {
        PenSizeBar({
          minRadius: this.minRadius,
          maxRadius: this.maxRadius,
          maxLength: this.penSizeBarLength,
          maxLevels: 5,
          updateShowRevert: false,
          currentValue: this.mosaicAttr.selectMosaicSize,
          isScreenPortrait: this.isScreenPortrait,
          onCurrentSizeChange: this.handleCurrentSizeChange,
          onEnd: this.handleEnd,
        });
      }
    }
    .id('petalclip_videoMosaicTool_mosaicSize')
    .width(this.isScreenPortrait ? '100%' : THIRD_TOOL_BAR_HEIGHT)
    .height(this.isScreenPortrait ? THIRD_TOOL_BAR_HEIGHT : '100%')
    .margin({ top: this.isScreenPortrait ? 8 : 0, left: this.isScreenPortrait ? 0 : 8 })
  }

  private handleEnd = () => {
    if (accessibility.isOpenAccessibilitySync()) {
    }
    HiLog.i(TAG, `mosaic penSize is ${this.mosaicAttr.selectMosaicSize}`);
  }

  private handleCurrentSizeChange = (val: number) => {
    let scrollVal: number = Number(val.toFixed(1));
    HiLog.i(TAG, `mosaic penSize scrollVal is ${scrollVal}, size is ${this.mosaicAttr.selectMosaicSize}`);
    this.mosaicAttr.selectMosaicSize = scrollVal;
  }

  @Builder
  subMosaicType() {
    Flex({
      direction: this.isScreenPortrait ? FlexDirection.Row : FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center,
    }) {
      MosaicSelection({
        imageDataList: this.imageDataList,
        selectionKey: this.mosaicAttr.selectMosaicKey,
        isScrollToIndex: this.isScrolling,
        onSelectChange: (selectkey: number) => {
          HiLog.i('VideoMosaicTool onSelectChange index:', String(selectkey));
        }
      })
    }
    .id('petalclip_videoMosaicTool_mosaicType')
    .enabled(!this.isScroll || !this.asset.isTouching)
    .width(this.isScreenPortrait ? '100%' : TOOL_CONTAINER_HEIGHT)
    .height(this.isScreenPortrait ? TOOL_CONTAINER_HEIGHT : '100%')
  }
}
