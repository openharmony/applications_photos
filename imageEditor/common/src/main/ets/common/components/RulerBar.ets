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
import { LengthMetrics } from '@kit.ArkUI';
import { App } from '../../service/App';
import { Asset, BaseEditor } from '../../service/BaseEditor';
import { i18n } from '@kit.LocalizationKit';
import {
  DEVICE_FOLD_STATUS,
  SCREEN_ORIENTATION_PORTRAIT,
  FIRST_FRAME_STATUS,
  WIN_HEIGHT_KEY,
  WIN_WIDTH_KEY,
  SCROLL_SHADOW_WIDTH,
  FOCUS_SCROLL
} from '../const';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { Event } from '../jul';
import { DeviceUtil } from '../util/DeviceUtil';
import { HiLog } from '../util/HiLog';
import { ScreenManager } from '../util/ScreenManager';
import { UiUtil } from '../util/UiUtil';
import { ButtonItem } from '../../../../../../common';
import { CropAttr } from '../../service/model/menu/CropAttr';

@Extend(Text)
function centerLine(isVertical: boolean) {
  .width(isVertical ? 1.5 : 18)
  .height(isVertical ? 18 : 1.5)
  .backgroundColor('rgba(255,255,255,1)')
  .border({ radius: 0.5 })
  .position({
    x: isVertical ? -0.7 : 28,
    y: (isVertical || DeviceUtil.isPc()) ? 28 : -0.7
  })
  .margin({ left: isVertical ? '50%' : 0, top: isVertical ? 0 : '50%' })
  .enabled(false)
}

const LINE_WIDTH: number = 1;
const LINE_GAP: number = 8;
const SNAP_DISTANCE = 0.5;
const PROGRESS_PRECISION = 0.01;
const TAG = 'RulerBar';

@Component
export struct RulerBar {
  @State item: ButtonItem =
    new ButtonItem($r('app.string.crop_rotate_imageEdit'), $r('app.media.edit_menu_rotate'), false, 'rotation', -45, 45,
      1);
  @Link progress: number;
  @Prop stateClosed: boolean; // 标注刻度尺的关闭状态，用于显示刻度线的颜色变化
  @Prop @Watch('onStateChange') stateChange: number = -1;
  @Prop min: number = -1; // prop outter
  @Prop max: number = -1; // prop outter
  @Prop visibleWidth: number;
  @State touchMoving: boolean = false // 标注刻度尺的滑动中状态
  @State snappingValue: number = 0 // prop outter 吸附值
  @State canvasOpacity: number = 1;
  @State showScroll: boolean = true;
  @Prop gapVal: number = -1 // 一格刻度条代表数值
  @Prop showGapNum: number = -1 // 一大格标注的数值
  @State @Watch('watchProgressChange') preProgress: number = 0;
  @State isFastScroll: boolean = false;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) @Watch('onStateChange') isScreenPortrait: boolean =
    ScreenManager.getInstance()
      .isScreenPortrait();
  @StorageProp(DEVICE_FOLD_STATUS) isFold: boolean = ScreenManager.getInstance().isDeviceFold()
  @StorageLink('currentLanguage') @Watch('onLanguageChange') currentLanguage: string | undefined = undefined;
  @State @Watch('isRTLChange') isRTL: boolean = UiUtil.isMirrorMode();
  @Prop startOptical: number;
  @Prop endOptical: number;
  @Prop isSnapping: boolean = false;
  @Link isInitData: boolean;
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State asset: Asset = App.getInstance().myEditor().asset;
  public onProgressChange: (val: number, isFastScroll: boolean) => void = Event;
  public onStateClosedChange: (val: boolean) => void = Event;
  public onTouchMovingChange: (val: boolean) => void = Event;
  public onEnd: () => void = Event;
  public onScrollStart: () => void = Event;
  private scroller: Scroller = new Scroller();
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private changeEnabled: boolean = false // 用于规避第一次显示时执行onScroll，因xOffset为0导致跳转刻度尺最小值问题
  private isClickScrolling: boolean = false;
  private MOVE_THRESHOLD = 0.1;
  private scrollWidth: number = 0;
  private snappingState: boolean = false // 标志是否0点吸附状态
  private sumSnappingValue: number = 0 // 记录吸附状态下，刻度尺移动值
  private inSnapping: boolean = false;
  private isScrolling: boolean = false;
  private rulerCenterIndex = 124;
  @StorageProp(WIN_HEIGHT_KEY) @Watch('refreshHeight') winHeight: number = ScreenManager.getInstance().height;
  @StorageProp(WIN_WIDTH_KEY) @Watch('refreshHeight') winWidth: number = ScreenManager.getInstance().width;
  @StorageProp(FOCUS_SCROLL) focusScroll: string = '';
  @State isShowShadowStart: boolean = true;
  @State isShowShadowEnd: boolean = true;
  @State scrollDistance: number = 0;
  @State shadowRate: number = 0;
  private scrollTimeFn: number = -1;
  private canvasTimeFn: number = -1;
  private scrollEndFn: number = -1;
  private touchX: number = 0;
  private touchY: number = 0;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @State cropsAttr: CropAttr = App.getInstance().myEditor().asset.crops();

  aboutToAppear() {
    this.progress = this.cropsAttr.cropTabs[this.cropsAttr.cropMenuIndex].value;
    this.preProgress = this.progress;
    this.scrollWidth = (this.max - this.min) * (LINE_WIDTH + LINE_GAP) / this.gapVal;
    this.appBroadCast.on(BroadCastConstants.EDIT_VALUE_ADD, this.handleEditValueAdd);
    this.appBroadCast.on(BroadCastConstants.EDIT_VALUE_SUB, this.handleEditValueSub);
    this.appBroadCast.on(BroadCastConstants.EDIT_VALUE_CHANGE_END, this.handleEditValueChangeEnd);
    this.onLanguageChange();
  }

  aboutToDisappear() {
    this.appBroadCast.off(BroadCastConstants.EDIT_VALUE_ADD, this.handleEditValueAdd);
    this.appBroadCast.off(BroadCastConstants.EDIT_VALUE_SUB, this.handleEditValueSub);
    this.appBroadCast.off(BroadCastConstants.EDIT_VALUE_CHANGE_END, this.handleEditValueChangeEnd);
  }

  private onLanguageChange(): void {
    if (this.currentLanguage) {
      const isRTL = i18n.isRTL(this.currentLanguage)
      this.isRTL = DeviceUtil.isPc() ? isRTL : isRTL && this.isScreenPortrait;
    }
  }

  handleEditValueChange = (add: boolean = true) => {
    if (this.item.key !== this.focusScroll) {
      return;
    }
    const offset = add ? 5 : -5;
    this.scroller.scrollBy(offset, 0);
    this.changeProgress();
  }
  handleEditValueAdd = () => {
    this.handleEditValueChange();
  }
  handleEditValueSub = () => {
    this.handleEditValueChange(false);
  }
  handleEditValueChangeEnd = () => {
    if (this.item.key !== this.focusScroll) {
      return;
    }
    this.onEnd();
  }

  refreshHeight() {
    this.scrollDistance = 0;
    this.handleScroll();
    this.onStateChange();
  }

  handleScroll(state?: ScrollState) {
    if (!this.scroller.currentOffset()) {
      return;
    }
    const scrollDistance = (
      this.isScreenPortrait ? this.scroller.currentOffset().xOffset : this.scroller.currentOffset().yOffset
    ) ?? 0;
    this.isShowShadowStart = scrollDistance > 0 ? true : false;
    if (!this.isShowShadowEnd && state !== undefined && state === ScrollState.Fling) {
      return;
    }
    this.isShowShadowEnd = this.scrollDistance === 0 || scrollDistance < this.scrollDistance ? true : false;
  }

  private scrollToValue = (): void => {
    this.isScreenPortrait ? this.scroller.scrollTo({
      xOffset: this.getShowValue(this.isRTL ? -this.preProgress : this.preProgress),
      yOffset: 0,
    })
      : this.scroller.scrollTo({
      xOffset: 0,
      yOffset: this.getShowValue(this.isRTL ? -this.preProgress : this.preProgress),
    });
  }

  onStateChange(): void {
    clearTimeout(this.scrollTimeFn);
    clearTimeout(this.canvasTimeFn);
    this.onLanguageChange();
    this.changeEnabled = false;
    this.preProgress = this.progress;
    this.showScroll = false;
    this.scrollTimeFn = setTimeout(this.scrollToValue, 5)
    if (this.editor.isStopScrolling || this.isInitData) {
      this.onDraw();
      this.showScroll = true;
      this.isInitData = false;
    } else {
      this.canvasTimeFn = setTimeout((): void => {
        this.onDraw();
        this.showScroll = true;
      }, 25)
    }
  }

  isRTLChange(): void {
    HiLog.i(TAG, `isRTLChange: ${this.isRTL}`);
    this.changeProgress();
    this.onDraw();
    this.editor.stopEditorOperate();
  }

  watchProgressChange(): void {
    this.onDraw();
  }

  build() {
    Stack() {
      Scroll(this.scroller) {
        Canvas(this.context)
          .opacity(this.showScroll ? 1 : 0)
          .width(this.isScreenPortrait ? (this.scrollWidth + this.visibleWidth) : '100%')
          .height(this.isScreenPortrait ? '100%' : (this.scrollWidth + this.visibleWidth))
          .direction(Direction.Ltr)
      }
      .id('petalclip_RulerBar_rulerScroller')
      .height('100%')
      .width('100%')
      .onTouch((event: TouchEvent): void => {
        if (event.type === TouchType.Down) {
          clearTimeout(this.scrollEndFn);
          // onScrollStop概率不执行，临时定时执行onEnd
          this.touchMoving = true;
          this.onTouchMovingChange(this.touchMoving);
        }
        if (event.type === TouchType.Move) {
          if (this.stateClosed === true) {
            this.stateClosed = false;
            this.onStateClosedChange(this.stateClosed);
          }
        } else if (event.type === TouchType.Up) {
          this.scrollEndFn = setTimeout((): void => {
            HiLog.i(TAG, 'End Scrolling')
            if (!this.touchMoving && this.inSnapping) {
              return;
            }
            this.asset.isTouching = false;
          }, 1500)
          this.touchMoving = false;
          this.onTouchMovingChange(this.touchMoving);
        }
      })
      .scrollable(this.isScreenPortrait ? ScrollDirection.Horizontal :
      ScrollDirection.Vertical)
      .edgeEffect(EdgeEffect.Spring)
      .scrollBar(BarState.Off)
      .onAppear((): void => {
        this.onOutChangeProgress();
        this.onDraw();
      })
      .onMouse((event: MouseEvent) => {
        this.operateMouse(event);
      })
      .onScrollFrameBegin((value: number) => {
        this.isFastScroll = Math.abs(value) > 2 * LINE_WIDTH;
        value = this.touchMoving ? value : value / 5;
        return { offsetRemain: value }
      })
      .onScrollStart((): void => {
        this.isClickScrolling = true;
        this.onScrollStart();
      })
      .onDidScroll((x: number, y: number, state: ScrollState) => {
        let scrollNum = this.isScreenPortrait ? x : y
        if (scrollNum == 0) {
          return;
        }
        if (!this.changeEnabled) {
          this.changeEnabled = true;
          this.onProgressChange(this.preProgress, this.isFastScroll)
          return;
        }
        if (this.isClickScrolling) {
          this.changeProgress();
        }
        this.handleScroll(state);
      })
      .onScrollEdge((side: Edge) => {
        if (side === Edge.Start || side === Edge.Top) {
          this.isShowShadowStart = false;
        } else {
          this.isShowShadowStart = true;
        }
        if (side === 3 || side === Edge.Bottom) { // 3: Edge.End
          this.scrollDistance = (
            this.isScreenPortrait ? this.scroller.currentOffset().xOffset : this.scroller.currentOffset().yOffset
          ) ?? 0;
          this.isShowShadowEnd = false;
        } else {
          this.isShowShadowEnd = true;
        }
      })
      .onScrollStop((): void => {
        clearTimeout(this.scrollEndFn);
        this.isClickScrolling = false;
        if (!this.touchMoving && this.inSnapping) {
          return;
        }
        this.onEnd();
      })
      // .blendMode(BlendMode.SRC_IN, BlendApplyType.OFFSCREEN)
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.shadowRate = SCROLL_SHADOW_WIDTH / Number(this.isScreenPortrait ? newValue.width : newValue.height);
      })

      Text().centerLine(this.isScreenPortrait)
    }
    .width('100%')
    .linearGradient({
      angle: this.isScreenPortrait ? 90 : 180,
      colors: [
        ['rgba(0, 0, 0, 0)', 0],
        ['rgba(0, 0, 0, 1)', this.isShowShadowStart ? this.shadowRate : 0],
        ['rgba(0, 0, 0, 1)', this.isShowShadowEnd ? 1 - this.shadowRate : 1],
        ['rgba(0, 0, 0, 0)', 1]]
    })
    .transition(
      TransitionEffect.asymmetric(
        TransitionEffect.OPACITY.animation({ duration: 100, delay: 100 }),
        TransitionEffect.OPACITY.animation({ duration: 100 })
      )
    )
    .accessibilityLevel('no')
    .focusBox({ margin: LengthMetrics.vp(-2) })
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
    .id('petalclip_RulerBar_RulerBar')
  }

  /* instrument ignore next */
  operateMouse(event: MouseEvent) {
    if (!event || event.button != MouseButton.Left) {
      return;
    }
    if (event.action === MouseAction.Press) {
      this.touchMoving = true;
      this.touchX = event.x;
      this.touchY = event.y;
      if (DeviceUtil.isPc()) {
        let offset = this.rulerCenterIndex - this.touchX;
        this.scroller.scrollBy(-offset, 0);
        this.changeProgress();
        return;
      }
    }
    if (event.action === MouseAction.Move) {
      if (!this.touchMoving) {
        return;
      }
      if (!this.isScrolling) {
        this.isScrolling = true;
        this.onScrollStart();
      }
      this.isFastScroll = false;
      this.onTouchMovingChange(this.touchMoving);
      let offset = this.isScreenPortrait ? event.x - this.touchX : event.y - this.touchY;
      this.touchX = event.x;
      this.touchY = event.y;
      this.isScreenPortrait ? this.scroller.scrollBy(-offset, 0) : this.scroller.scrollBy(0, -offset);
      this.changeProgress();
    }

    if (event.action === MouseAction.Release) {
      this.touchMoving = false;
      this.isScrolling = false;
      this.onTouchMovingChange(this.touchMoving);
      this.onEnd();
    }
  }

  changeProgress() {
    let cropsValue = this.asset.crops()
      .cropTabs[this.asset.crops().cropMenuIndex]
      .value;
    if (Math.abs(cropsValue - Number(this.preProgress.toFixed(1))) <= PROGRESS_PRECISION &&
      !(this.asset.isTouching || this.asset.crops().isScrolling)) {
      HiLog.i(TAG, `no need change progress cause preProgress not changed`)
      return;
    }

    let value = (this.isSnapping && this.showScroll && !this.isFastScroll) ? this.getSnapValue(this.getOffset(),
      this.preProgress) : this.getProgress(this.getOffset());
    value = this.isRTL ? -value : value;
    HiLog.i(TAG, ` value: ${value}`)
    if (value > this.max) {
      value = this.max;
      this.onDraw();
    } else if (value < this.min) {
      value = this.min;
      this.onDraw();
    }
    this.preProgress = value;
    this.onProgressChange(this.preProgress, this.isFastScroll);
  }

  getOffset(): number {
    let offset: OffsetResult = this.scroller.currentOffset();
    if (!offset) {
      HiLog.w(TAG, 'onDidScroll ignored');
      return 0;
    }
    return this.isScreenPortrait ? offset.xOffset : offset.yOffset
  }

  /* instrument ignore next */
  getSnapValue(value: number, preProgress: number): number {
    let progress = this.getProgress(value);
    if (this.snappingState === true) {
      // 若当前是自动吸附状态
      this.sumSnappingValue = this.sumSnappingValue + Math.abs(progress);
      if (this.sumSnappingValue <= SNAP_DISTANCE) {
        // 在吸附范围内滑动做停顿
        if (progress != this.snappingValue) {
          progress = this.snappingValue;
          this.isScreenPortrait ? this.scroller.scrollTo({
            xOffset: this.getShowValue(this.snappingValue),
            yOffset: 0,
          })
            : this.scroller.scrollTo({ xOffset: 0, yOffset: this.getShowValue(this.snappingValue) });
        }
      } else {
        // 滑动累积超出吸附范围，跳出停顿
        this.snappingState = false;
        this.inSnapping = false;
        this.sumSnappingValue = 0;
      }
    } else if (this.isSnap(progress, preProgress)) {
      // 从正值往0点刻度滑动，滑动至吸附范围，自动跳转至0刻度
      this.snappingState = true;
      this.inSnapping = true;
      progress = this.snappingValue;
      this.isScreenPortrait ? this.scroller.scrollTo({
        xOffset: this.getShowValue(this.snappingValue),
        yOffset: 0,
      })
        : this.scroller.scrollTo({ xOffset: 0, yOffset: this.getShowValue(this.snappingValue) });
      this.inSnapping = false;
    }

    return progress;
  }

  isSnap(progress: number, preProgress: number): boolean {
    let isUpSnap = progress > this.snappingValue && progress < preProgress && progress - this.snappingValue <=
      SNAP_DISTANCE;
    let isDownSnap = progress < this.snappingValue && progress > preProgress && this.snappingValue - progress <=
      SNAP_DISTANCE;
    return isUpSnap || isDownSnap;
  }

  getShowValue(value: number): number {
    let showVal = this.isScreenPortrait ? (value - this.min) * this.scrollWidth / (this.max - this.min) :
      (this.max - value) * this.scrollWidth / (this.max - this.min);
    return showVal;
  }

  getProgress(value: number): number {
    let showVal = this.isScreenPortrait ? this.min + value * (this.max - this.min) / this.scrollWidth :
      this.max - value * (this.max - this.min) / this.scrollWidth;
    return this.isRTL && this.isScreenPortrait ? -showVal : showVal;
  }

  onDraw = (): void => {
    this.context.clearRect(0, 0,
      this.isScreenPortrait ? (this.scrollWidth + this.visibleWidth) : this.context.width,
      this.isScreenPortrait ? this.context.height : (this.scrollWidth + this.visibleWidth));
    this.context.lineWidth = LINE_WIDTH;
    this.context.beginPath();
    let start = this.visibleWidth / 2;
    let fontSize = vp2px(12);
    this.context.font = `${fontSize}px`;
    this.context.lineCap = 'round';
    HiLog.i(TAG, `onDraw UiUtil.isMirrorMode(): ${UiUtil.isMirrorMode()}, this.isRTL: ${this.isRTL}`)
    for (let i = 0; i <= (this.max - this.min); i += this.gapVal) {
      this.context.beginPath();
      let x = start + i * (LINE_GAP + LINE_WIDTH) / this.gapVal;
      let showNum = this.isScreenPortrait ? this.isRTL ? -(this.min + i) : (this.min + i) : -(this.min + i);
      let isScrolled = (showNum <= Math.round(this.preProgress) && showNum >= 0) ||
        (showNum >= Math.round(this.preProgress) && showNum <= 0);
      let offsetNum = Math.abs(showNum - this.preProgress);
      let fullOpt = isScrolled ? 0.9 : 0.6
      let optical = offsetNum < this.startOptical ? fullOpt : offsetNum > this.endOptical ? 0 :
        (this.endOptical - offsetNum) * fullOpt / (this.endOptical - this.startOptical)
      this.context.strokeStyle = `rgba(255,255,255,${optical}` + ')';
      this.context.fillStyle = `rgba(255,255,255,${optical}` + ')';
      if (showNum % this.showGapNum == 0) {
        let xOffset = showNum < 0 || showNum >= 100 ? -12 : (showNum === 0) ? -3.5 : -7;
        let yOffset = showNum < 0 || showNum >= 100 ? 0 : (showNum === 0) ? 8 : 5;
        this.isScreenPortrait ? this.context.moveTo(x, 42) : this.context.moveTo(42, x)
        this.isScreenPortrait ? this.context.lineTo(x, 32) : this.context.lineTo(32, x)
        this.isScreenPortrait ? this.context.fillText(showNum.toString(), x + xOffset, 18) :
        this.context.fillText(showNum.toString(), yOffset, x + 3);
      } else {
        this.isScreenPortrait ? this.context.moveTo(x, 42) : this.context.moveTo(42, x)
        this.isScreenPortrait ? this.context.lineTo(x, 36) : this.context.lineTo(36, x)
      }
      this.context.closePath();
      this.context.stroke();
    }
  }
  onOutChangeProgress: () => void = (): void => {
    HiLog.i(TAG, ' progress: ' + this.preProgress + ' min: ' + this.min + ' max: ' + this.max +
      ' stateChange:' + this.stateChange)
    this.changeEnabled = false;
    this.scrollToValue();
  }

  /**
   * 加减进度条
   * @param newValue 加减数值（正负表示）
   */
  private addOrSubProgress(value: number) {
    let newProgress = this.preProgress + value;
    if (newProgress <= this.max && newProgress >= this.min) {
      this.preProgress = newProgress;
      this.onProgressChange(UiUtil.isMirrorMode() ? -this.preProgress : this.preProgress, this.isFastScroll);
      this.scrollToValue();
      this.onEnd();
    }
  }
}