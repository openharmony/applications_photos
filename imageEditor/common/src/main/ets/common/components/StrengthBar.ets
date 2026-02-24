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
import { KeyCode } from '@kit.InputKit';
import { Event } from '../jul'
import { BaseEditor, App, TabName, ScreenClass } from '../../service/App'
import { AdjustAttr } from '../../service/BaseEditor'
import { UiUtil } from '../util/UiUtil'
import {
  DEFAULT_STRENGTH_BAR_WIDTH,
  FOLDANDPAD_LR_STRENGTH_BAR_WIDTH,
  PHONE_TB_STRENGTH_BAR_WIDTH,
  PHONE_LR_STRENGTH_BAR_WIDTH,
  DEVICE_FOLD_STATUS,
  WIN_WIDTH_KEY,
  WIN_HEIGHT_KEY,
  FOCUS_SCROLL
} from '../const'
import { DeviceUtil } from '../util/DeviceUtil'
import { ScreenManager } from '../util/ScreenManager'
import { HiLog } from '../util/HiLog'
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { ButtonItem } from '../../../../../../common';

let TAG: string = 'StrengthBar';
let touchX = 0;

@Component
export struct StrengthBar {
  @State adjustAttr: AdjustAttr = App.getInstance().myEditor().asset.adjusts();
  @State item: ButtonItem = this.adjustAttr.tabs[0];
  @State editor: BaseEditor = App.getInstance().myEditor();
  @Prop min: number = 0;
  @Prop max: number = 0;
  @Prop progress: number = 0;
  @State strengthBarDiameter: number = 16;
  @Prop duration: number = 0;
  @State barWidth: number = 240;
  @StorageProp(DEVICE_FOLD_STATUS) @Watch('changeBarWidth') isFold: boolean = ScreenManager.getInstance().isDeviceFold()
  public onCurrentXChange: (val: number) => void = Event;
  @Prop color: string = '#E6E6E6';
  @Prop isCheck: boolean = true;
  public onEnd: () => void = Event;
  @Prop @Watch('changeBarWidth') isScreenPortrait: boolean = true;
  @Link isSlide: boolean;
  @StorageProp(WIN_WIDTH_KEY) @Watch('changeBarWidth') winWidth: number = ScreenManager.getInstance().width;
  @StorageProp(WIN_HEIGHT_KEY) @Watch('changeBarWidth') winHeight: number = ScreenManager.getInstance().height;
  @StorageProp(FOCUS_SCROLL) focusScroll: string = '';
  private isVibrate: boolean = false;
  private MOVE_THRESHOLD = 0.1;
  private isDevicePhone: boolean = DeviceUtil.isPhone();
  private tipTimeFn = -1;
  private offsetWidth = 36;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  aboutToAppear() {
    this.appBroadCast.on(BroadCastConstants.EDIT_VALUE_ADD, this.handleEditValueAdd);
    this.appBroadCast.on(BroadCastConstants.EDIT_VALUE_SUB, this.handleEditValueSub);
    this.appBroadCast.on(BroadCastConstants.EDIT_VALUE_CHANGE_END, this.handleEditValueChangeEnd);
    this.changeBarWidth();
    if (typeof (this.duration) === 'undefined' || this.duration === 0) {
      return;
    }
  }

  aboutToDisappear() {
    this.appBroadCast.off(BroadCastConstants.EDIT_VALUE_ADD, this.handleEditValueAdd);
    this.appBroadCast.off(BroadCastConstants.EDIT_VALUE_SUB, this.handleEditValueSub);
    this.appBroadCast.off(BroadCastConstants.EDIT_VALUE_CHANGE_END, this.handleEditValueChangeEnd);
  }

  changeBarWidth() {
    // instrument ignore if
    if (DeviceUtil.isPc()) {
      this.barWidth = DEFAULT_STRENGTH_BAR_WIDTH;
      return;
    }

    /**
     * xxx展开&&pad 左右布局：滑动条定宽272
     * xxx展开&&pad 上下布局：左右边距72，滑动条撑满
     * 手机横屏：滑动条定宽186
     * 手机竖屏：滑动条定宽256
     */
    if (ScreenManager.getInstance().isFoldAndPadLR()) {
      this.barWidth = FOLDANDPAD_LR_STRENGTH_BAR_WIDTH;
    } else if (this.isScreenPortrait && (DeviceUtil.isPad() ||
      (!this.isFold && (ScreenManager.getInstance().getWidthScale() === 1)))) {
      this.barWidth = this.winWidth - 16 - 72 * 2;
    } else if (ScreenManager.getInstance().isPhoneLR()) {
      this.barWidth = PHONE_LR_STRENGTH_BAR_WIDTH;
    } else {
      this.barWidth = PHONE_TB_STRENGTH_BAR_WIDTH;
    }

    HiLog.i('strengthBar', 'changeBarWidth is ' + this.barWidth + ', this.offsetWidth is ' + this.offsetWidth)
  }

  moveStrengthBar = (add: boolean = true) => {
    if (this.item.key !== this.focusScroll) {
      return;
    }
    if (this.adjustAttr.barDisabled) {
      return;
    }
    if (!this.editor.immersiveMode) {
      this.editor.operationTip.name = '';
    }
    if (!DeviceUtil.isPhone()) {
      this.editor.refreshThumbnail.ifRefreshThumbnail = true;
    }
    if (this.editor.isEdit) {
      this.editor.isShowRevert = !this.editor.isEdited();
    }
    const offset = (add ? 0.05 : -0.05) * this.duration;
    this.progress += offset;
    if (this.progress > this.max) {
      this.progress = this.max;
    }
    if (this.progress < this.min) {
      this.progress = this.min;
    }
    this.onCurrentXChange(Math.round(this.progress));
  }
  handleEditValueAdd = () => {
    this.moveStrengthBar();
  }
  handleEditValueSub = () => {
    this.moveStrengthBar(false);
  }
  handleEditValueChangeEnd = () => {
    if (this.item.key !== this.focusScroll) {
      return;
    }
    this.onEnd();
  }

  touchStrengthBar(event: TouchEvent) {
    if (event.stopPropagation === null || event.stopPropagation === undefined) {
      return;
    }
    event.stopPropagation();
    let unchangeable: boolean = true;
    if (event.type == TouchType.Down) {
      unchangeable = this.adjustAttr.barDisabled;
      touchX = this.isScreenPortrait ? event.touches[0].x : event.touches[0].y
      this.editor.asset.isTouching = false;
      this.isSlide = false;
    }
    if (event.type == TouchType.Move) {
      let nowX = this.isScreenPortrait ? event.touches[0].x : event.touches[0].y
      if (Math.abs(nowX - touchX) >= this.MOVE_THRESHOLD) {
        unchangeable = false;
        this.adjustAttr.barDisabled = false;
        if (!this.editor.immersiveMode) {
          this.editor.operationTip.name = '';
          this.editor.asset.isTouching = true;
        }
        this.isSlide = true;
      }
      touchX = nowX;

    }
    if (event.type == TouchType.Up) {
      unchangeable = this.adjustAttr.barDisabled;
      this.editor.asset.isTouching = false;
      // instrument ignore if
      if (!DeviceUtil.isPhone()) {
        this.editor.refreshThumbnail.ifRefreshThumbnail = true;
      }
      if (this.editor.isEdit) {
        this.editor.isShowRevert = !this.editor.isEdited();
      }
    }
    if (unchangeable) {
      return;
    }
    let touchValue = touchX;
    if (touchValue < 0) {
      touchValue = 0;
    }
    if (touchValue > this.barWidth) {
      touchValue = this.barWidth;
    }
    if (this.min >= 0) {
      this.progress = touchValue / this.barWidth * this.duration;
    } else {
      if (touchValue >= this.barWidth / 2) {
        this.progress = (touchValue - this.barWidth / 2) / (this.barWidth / 2) * this.max;
      } else {
        this.progress = (this.barWidth / 2 - touchValue) / (this.barWidth / 2) * this.min;
      }
    }

    let progress = Math.abs(this.progress);
    if (this.isDevicePhone) {
      // instrument ignore else
      if (progress >= 1) {
        this.isVibrate = true;
      } else {
        this.progress = 0;
        if (this.isVibrate && this.min == -100) {
          UiUtil.vibrateById(UiUtil.CAMERA_GEAR_SLIP_LIGHT_ID);
        }
        this.isVibrate = false;
      }
    } else {
      if (progress < 1) {
        this.progress = 0;
      }
    }
    this.onCurrentXChange(Math.round(this.progress));
    this.editor.operationTip.isShowNum = true;
    if (App.getInstance().myEditor().tabIndex == TabName.TabFilter) {
      HiLog.i('filterValue', 'filterValue' + Math.round(this.progress));
    }
    if (event.type == TouchType.Up) {
      this.onEnd();
    }
  }

  getBarCurrentX() {
    let currentX = 0;
    if (this.min >= 0) {
      currentX = this.min + 8;
    } else {
      if (this.progress >= 0) {
        currentX = this.barWidth / 2 + 8;
      } else {
        currentX = this.barWidth / 2 + this.progress / this.duration * this.barWidth + 8;
      }
    }
    return currentX;
  }

  getCircleCurrentX() {
    let currentX = 0;
    if (this.min >= 0) {
      currentX = (this.progress - this.min) / this.duration * this.barWidth;
    } else {
      if (this.progress >= 0) {
        currentX = this.progress / this.duration * this.barWidth + this.barWidth / 2;
      } else {
        currentX = this.barWidth / 2 + this.progress / this.duration * this.barWidth;
      }
    }
    return currentX;
  }

  getWidth() {
    let currentWidth = 0;
    if (this.min >= 0) {
      currentWidth = (this.progress - this.min) / this.duration * this.barWidth;
    } else {
      currentWidth = Math.abs(this.progress / this.duration * this.barWidth);
    }
    return currentWidth;
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        Row()
          .id('petalClip_strengthBar_background')
          .height(this.isScreenPortrait ? 4 : this.barWidth)
          .width(this.isScreenPortrait ? this.barWidth : 4)
          .backgroundColor($r('sys.color.ohos_id_color_fourth_dark'))
          .border({ radius: 2 })
        Row()
          .id('petalClip_strengthBar_value')
          .height(this.isScreenPortrait ? 4 : this.getWidth())
          .width(this.isScreenPortrait ? this.getWidth() : 4)
          .backgroundColor(this.color)
          .border({ radius: 2 })
          .position(this.isScreenPortrait ? { x: this.getBarCurrentX(), y: 18 } : { x: 18, y: this.getBarCurrentX() })
          .opacity(1)
        Row()
          .id('petalClip_strengthBar_circle')
          .width(this.strengthBarDiameter)
          .height(this.strengthBarDiameter)
          .backgroundColor(this.color)
          .borderRadius(16)
          .position(this.isScreenPortrait ? { x: this.getCircleCurrentX(), y: 12 } :
            { x: 12, y: this.getCircleCurrentX() })
          .shadow({
            radius: 4,
            color: 'rgba(0,0,0,0.3)',
            offsetX: 0,
            offsetY: 0,
          })
      }
      .width(this.isScreenPortrait ? '100%' : 40)
      .height(this.isScreenPortrait ? 40 : '100%')
      .onTouch((event: TouchEvent): void => {
        clearTimeout(this.tipTimeFn);
        this.tipTimeFn = setTimeout((): void => {
          this.editor.operationTip.isShowNum = false;
        }, 1000)
        this.touchStrengthBar(event);
      })
      .accessibilityLevel('no')
      .onClick(() => {
        // 这里加个空的onClick事件是为了能在按tab键切换时获焦,ArkUI提供的提供的其他属性都没用,这个方法有用且不影响业务
      })
      .onKeyEvent((event: KeyEvent) => {
        const arrowKeys =
          [KeyCode.KEYCODE_DPAD_UP, KeyCode.KEYCODE_DPAD_DOWN, KeyCode.KEYCODE_DPAD_LEFT,
            KeyCode.KEYCODE_DPAD_RIGHT];
        if (event.type === KeyType.Up) {
          return;
        }
        if (event.keyCode === KeyCode.KEYCODE_DPAD_UP) {
          HiLog.i(TAG, 'keyboardShortcut ↑');
          this.addOrSubProgress(1);
        } else if (event.keyCode === KeyCode.KEYCODE_DPAD_DOWN) {
          HiLog.i(TAG, 'keyboardShortcut ↓');
          this.addOrSubProgress(-1);
        } else if (event.keyCode === KeyCode.KEYCODE_DPAD_LEFT) {
          HiLog.i(TAG, 'keyboardShortcut ←');
          this.addOrSubProgress(-1);
        } else if (event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT) {
          HiLog.i(TAG, 'keyboardShortcut →');
          this.addOrSubProgress(1);
        }
        // 上下左右按键需要用于数值的调整,这里阻止按键冒泡,不然会被用于焦点的切换
        if (arrowKeys.includes(event.keyCode)) {
          event.stopPropagation();
        }
      })
    }
    .transition(TransitionEffect.asymmetric(TransitionEffect.OPACITY.animation({
      duration: 100,
    }), TransitionEffect.OPACITY.animation({ duration: 100 })))
    .id('petalClip_strengthBar_strengthBar')
    .width(this.isScreenPortrait ? this.barWidth + 16 : 56)
    .height(this.isScreenPortrait ? 56 : this.barWidth + 16)
    .justifyContent(FlexAlign.Center)
    .rotate(this.isScreenPortrait && !UiUtil.isMirrorMode() ? { angle: 0 } : { angle: 180 })
    .margin(this.isScreenPortrait && !DeviceUtil.isPc() && (DeviceUtil.isPad() ||
      (!this.isFold && (ScreenManager.getInstance().getWidthScale() === 1))) ?
      { left: 72, right: 72 } : {})
  }

  /**
   * 加减进度条
   * @param newValue 加减数值（正负表示）
   */
  private addOrSubProgress(value: number) {
    let newProgress = this.progress + value;
    if (newProgress <= this.max && newProgress >= this.min) {
      this.progress = newProgress;
      this.onCurrentXChange(Math.round(this.progress));
      this.editor.operationTip.isShowNum = true;
      clearTimeout(this.tipTimeFn);
      this.tipTimeFn = setTimeout(() => {
        this.editor.operationTip.isShowNum = false;
      }, 1000);
      if (App.getInstance().myEditor().tabIndex == TabName.TabFilter) {
        HiLog.i('filterValue', 'filterValue' + Math.round(this.progress));
      }
      this.onEnd();
      if (App.getInstance().myEditor().tabIndex == TabName.TabFilter) {
      }
    }
  }
}