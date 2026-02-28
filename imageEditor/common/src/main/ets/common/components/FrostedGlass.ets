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

import { Asset } from '../../service/Asset';
import { Event } from '../jul';
import { Rectangle, RectangleAnimated } from '../util/types';
import { HiLog } from '../util/HiLog';
import { App, BaseEditor, TabName } from '../../service/App';
import { CropAttr, Timeline } from '../../service/BaseEditor';
import { UiUtil } from '../util/UiUtil';
import { Action, DownPos, DragObj } from '../../service/model/CropModel';
import { ScreenManager } from '../util/ScreenManager';
import { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import {
  PHONE_MIN_CROP,
  SCREEN_ORIENTATION_PORTRAIT,
  ANIMATION_DURATION,
  CURRENT_LANGUAGE,
  AVOID_LEFT_OFFSET,
  LONG_SCREENSHOT_CROP_HOT_AREA,
  PositionType
} from '../const';
import { Trace } from '../util/Trace';
import { FillCropType } from '../../service/model/Enum';
import { ScreenClass } from '../../service/App';
import { PathShape } from '@kit.ArkUI';
import { LengthUnit, display } from '@kit.ArkUI';
import { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo'

const TAG = 'FrostedGlass';

let offsetX: number = 0;
let offsetY: number = 0;
let scaleRatio = 1;
let animationTime = 100;
let percentage = 100;
let cropFrameResetTime = 800;
const ONE_SCALE_RATION = 1;

@Extend(Row)
function rowStyle() {
  .width('100%')
  .height(1)
  .backgroundColor('#FFFFFF')
  .opacity(0.5)
}

@Extend(Row)
function rowStyle1(hasSplitLine: boolean) {
  .width('100%')
  .height(0.5)
  .backgroundColor('#FFFFFF')
  .opacity(hasSplitLine ? 0.5 : 0)
}

@Extend(Row)
function rowStyle2(hasMoreSplitLine: boolean) {
  .width('100%')
  .height(0.5)
  .backgroundColor('#FFFFFF')
  .opacity(hasMoreSplitLine ? 0.2 : 0)
}

@Extend(Column)
function columnStyle() {
  .width(1)
  .height('100%')
  .backgroundColor('#FFFFFF')
  .opacity(0.5)
}

@Extend(Column)
function columnStyle1(hasSplitLine: boolean) {
  .width(0.5)
  .height('100%')
  .backgroundColor('#FFFFFF')
  .opacity(hasSplitLine ? 0.5 : 0)
}

@Extend(Column)
function columnStyle2(hasMoreSplitLine: boolean) {
  .width(0.5)
  .height('100%')
  .backgroundColor('#FFFFFF')
  .opacity(hasMoreSplitLine ? 0.2 : 0)
}

function getPath(points: RectangleAnimated): string {
  return `M0 ${points.roundTop()} L0 ${points.roundBottom()} L${points.roundLeft()} ${points.roundBottom()} L${points.roundLeft()} ${points.roundTop()}
    M0 0 L0 ${points.roundTop()} L${vp2px(ScreenManager.getInstance().width)} ${points.roundTop()} L${vp2px(ScreenManager.getInstance().width)} 0
    M${points.roundRight()} ${points.roundTop()} L${points.roundRight()} ${points.roundBottom()} L${vp2px(ScreenManager.getInstance().width)} ${points.roundBottom()} L${vp2px(ScreenManager.getInstance().width)} ${points.roundTop()}
    M0 ${points.roundBottom()} L0 ${vp2px(ScreenManager.getInstance().height)} L${vp2px(ScreenManager.getInstance().width)} ${vp2px(ScreenManager.getInstance().height)} L${vp2px(ScreenManager.getInstance().width)} ${points.roundBottom()}`
}

@AnimatableExtend(Row) function animatablePath(points: RectangleAnimated) {
  .clipShape(new PathShape({commands: getPath(points)}))
}

let expandedHotspotsWidth: number = 20 // 扩展热区宽度

@Component
export struct ScreenMask {
  @BuilderParam content?: () => void
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State screenClass: ScreenClass = App.getInstance().screenClass;
  @State crop: CropAttr = App.getInstance().myEditor().asset.crops();
  @State clipSize: Rectangle = App.getInstance()
    .myEditor()
    .asset
    .crops()
    .cropRect;
  @State xOffset: number = UiUtil.getPreviewRectOffset();
  private isEnableMaskOfLast: boolean = false;

  @Builder
  blurBack() {
    EffectComponent() {
      Row() {
      }
      .width(`${this.clipSize.roundLeft()}px`)
      .height(`${this.clipSize.roundHeight()}px`)
      .position({ x: 0, y: this.clipSize.roundTop() + 'px' })
      .useEffect(true)
      .visibility(this.crop.isEnableBlur ? Visibility.Visible : Visibility.Hidden)

      Row() {
      }
      .width('100%')
      .height(`${this.clipSize.roundTop()}px`)
      .position({ x: 0, y: 0 })
      .useEffect(true)
      .visibility(this.crop.isEnableBlur ? Visibility.Visible : Visibility.Hidden)

      Row() {
      }
      .width(display.getDefaultDisplaySync().width - this.clipSize.roundRight() + 'px')
      .height(`${this.clipSize.roundHeight()}px`)
      .position({ x: this.clipSize.roundRight() + 'px', y: this.clipSize.roundTop() + 'px' })
      .useEffect(true)
      .visibility(this.crop.isEnableBlur ? Visibility.Visible : Visibility.Hidden)

      Row() {
      }
      .width('100%')
      .height('100%')
      .position({ x: 0, y: this.clipSize.roundBottom() + 'px' })
      .useEffect(true)
      .visibility(this.crop.isEnableBlur ? Visibility.Visible : Visibility.Hidden)
    }
    .backdropBlur(50)
  }

  @Builder
  blurMask() {
    this.blurBack();
    Row() {
    }
    .width(`${this.clipSize.roundLeft()}px`)
    .height(`${this.clipSize.roundHeight()}px`)
    .position({ x: 0, y: this.clipSize.roundTop() + 'px' })
    .backgroundColor('rgba(0,0,0,0.8)')
    .visibility(this.crop.isEnableMask ? Visibility.Visible : Visibility.Hidden)

    Row() {
    }
    .width('100%')
    .height(`${this.clipSize.roundTop()}px`)
    .position({ x: 0, y: 0 })
    .backgroundColor('rgba(0,0,0,0.8)')
    .visibility(this.crop.isEnableMask ? Visibility.Visible : Visibility.Hidden)

    Row() {
    }
    .width(display.getDefaultDisplaySync().width - this.clipSize.roundRight() + 'px')
    .height(`${this.clipSize.roundHeight()}px`)
    .position({ x: this.clipSize.roundRight() + 'px', y: this.clipSize.roundTop() + 'px' })
    .backgroundColor('rgba(0,0,0,0.8)')
    .visibility(this.crop.isEnableMask ? Visibility.Visible : Visibility.Hidden)

    Row() {
    }
    .width('100%')
    .height('100%')
    .position({ x: 0, y: this.clipSize.roundBottom() + 'px' })
    .backgroundColor('rgba(0,0,0,0.8)')
    .visibility(this.crop.isEnableMask ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  blackMask() {
    Row() {
    }
    .backgroundColor(this.imageEditorBgColor())
    .animation({
      duration: this.isEnableMaskOfLast ? animationTime : 0,
      curve: Curve.Linear,
      delay: 0,
      playMode: PlayMode.Normal,
    })
    .width(`${this.clipSize.roundLeft()}px`)
    .height(`${this.clipSize.roundHeight()}px`)
    .position({ x: 0, y: this.clipSize.roundTop() + 'px' })
    .visibility(this.crop.isEnableMask ? Visibility.Visible : Visibility.Hidden)

    Row() {
    }
    .backgroundColor(this.imageEditorBgColor())
    .animation({
      duration: this.isEnableMaskOfLast ? animationTime : 0,
      curve: Curve.Linear,
      delay: 0,
      playMode: PlayMode.Normal,
    })
    .width('100%')
    .height(`${this.clipSize.roundTop()}px`)
    .position({ x: 0, y: 0 })
    .visibility(this.crop.isEnableMask ? Visibility.Visible : Visibility.Hidden)

    Row() {
    }
    .backgroundColor(this.imageEditorBgColor())
    .animation({
      duration: this.isEnableMaskOfLast ? animationTime : 0,
      curve: Curve.Linear,
      delay: 0,
      playMode: PlayMode.Normal,
    })
    .width(display.getDefaultDisplaySync().width - this.clipSize.roundRight() + 'px')
    .height(`${this.clipSize.roundHeight()}px`)
    .position({ x: this.clipSize.roundRight() + 'px', y: this.clipSize.roundTop() + 'px' })
    .visibility(this.crop.isEnableMask ? Visibility.Visible : Visibility.Hidden)

    Row() {
    }
    .backgroundColor(this.imageEditorBgColor())
    .animation({
      duration: this.animatableTimeAndMaskStatus(),
      curve: Curve.Linear,
      delay: 0,
      playMode: PlayMode.Normal,
    })
    .width('100%')
    .height('100%')
    .position({ x: 0, y: this.clipSize.roundBottom() + 'px' })
    .visibility(this.crop.isEnableMask ? Visibility.Visible : Visibility.Hidden)
  }

  build() {
    Stack() {
      if (this.content) {
        this.content();
      }
      /* instrument ignore next */
      if (DeviceInfo.isSupportLiteVisualEffect()) {
        this.blackMask();
      } else {
        this.blurMask();
      }
    }
    .width('100%').height('100%')
  }

  /* instrument ignore next */
  imageEditorBgColor() {
    if (this.crop.isEnableBlur) {
      return 'rgba(0,0,0,1)';
    } else {
      return this.crop.isEnableMask ? 'rgba(0,0,0,0.8)' : 'rgba(0,0,0,0.0)';
    }
  }

  animatableTimeAndMaskStatus() {
    let time = this.isEnableMaskOfLast ? animationTime : 0;
    this.isEnableMaskOfLast = this.crop.isEnableMask;
    return time;
  }
}

const SCALE_THRESHOLD = 0.1;

@Component
export struct ScreenSizer {
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State asset: Asset = App.getInstance().myEditor().asset;
  @State clipSize: Rectangle = new Rectangle(50, 150, 250, 550);
  @State cropAttr: CropAttr = App.getInstance().myEditor().asset.crops()
  @State timeline: Timeline = App.getInstance().myEditor().timeline;
  public onSizing: (l: number, t: number, r: number, b: number, directionLeft: number, directionTop: number,
    directionRight: number, directionBottom: number, pressure: number) => void = Event // 拖放中
  public onSizeEnd: (l: number, t: number, r: number, b: number) => void = Event // 拖放结束
  private minSize = PHONE_MIN_CROP //最小宽高
  public onPanGestureMove: (moveX: number, moveY: number) => void = Event // 组合手势移动中
  public onPinchGestureScale: (ratio: number, centerX: number, centerY: number) => void = Event // 组合手势缩放中
  public onGestureEnd: () => void = Event;
  private fingerIds: number[] = [0]
  @Prop maxWidth: number = 0;
  @Prop maxHeight: number = 0;
  private dragObj: DragObj = new DragObj(false);
  @Prop clipVisible: boolean = false;
  @Prop isRotateAndMirrorStatus: boolean = false;
  @Prop hasSplitLine: boolean = false;
  @Prop isStopOperating: boolean = false;
  @Prop isRecordOperating: boolean = false;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) @Watch('onPortraitChange')
    isScreenPortrait: boolean = ScreenManager.getInstance().isScreenPortrait();
  private isTouchScreen: boolean = false;
  private relateScale: number = 1;
  @StorageLink('windowFocused') @Watch('resetOperate') private isWindowFocused: boolean = true;
  private startClipSize: Rectangle = new Rectangle(0, 0, 0, 0);

  build() {
    Stack() {
      RectangleSizer({
        clipSize: this.clipSize,
        clipVisible: this.clipVisible,
        hasSplitLine: this.hasSplitLine,
      })
    }
    .width('100%').height('100%')
    .gesture(
      GestureGroup(
        GestureMode.Exclusive, // 手势组合并发识别
        PinchGesture({ fingers: 2, distance: 0.01 })// 最小识别距离，单位为vp。默认值：3
          .onActionStart((event: GestureEvent) => {
            /* instrument ignore if */
            if (!event || this.asset.isTouching) {
              return
            }
            /* instrument ignore if */
            if (this.isStopOperating) {
              this.asset.isGestureOperate = false;
              return;
            }

            this.fingerIds = this.getFingerIds(event);
            /* instrument ignore if */
            if (this.isFingerListEmpty(this.fingerIds)) {
              return;
            }
            /* instrument ignore if */
            if (this.editor.tabIndex == TabName.TabAperture) {
            }

            this.fingerIds = this.getFingerIds(event);
            let isInHotArea = (this.editor.tabIndex === TabName.TabCrop) && this.isCropFrameHotArea(event);
            /* instrument ignore if */
            if (!this.isTouchScreen && this.isRecordOperating) {
              // 启动记录撤销恢复的值
              App.getInstance().myEditor().startEditorOperate();
              App.getInstance().myEditor().asset.fillCropRect(0, FillCropType.PinchStart);
              this.isTouchScreen = true;
            }

            if (this.dragObj.dragging || this.isRotateAndMirrorStatus) {
              this.asset.isGestureOperate = false;
              HiLog.i('FrostedGlass', 'PinchGesture set hasActionStarted = false');
              return;
            }

            // 焦点位置计算
            Trace.begin('pinch gesture')
            App.getInstance().myEditor().interrupt = true;
            // 缩放视频
            this.asset.isGestureOperate = true;
            HiLog.i('FrostedGlass', 'PinchGesture start');
            scaleRatio = 1;
            this.relateScale = 1;
            offsetX = (event.fingerList[this.fingerIds[0]]?.localX + event.fingerList[this.fingerIds[1]]?.localX) / 2;
            offsetY = (event.fingerList[this.fingerIds[0]]?.localY + event.fingerList[this.fingerIds[1]]?.localY) / 2;
          })
          .onActionUpdate((event: GestureEvent) => {
            // 裁剪和手势组合互斥
            HiLog.i('FrostedGlass', 'PinchGesture scale hasActionStarted = ' + this.asset.isGestureOperate);
            /* instrument ignore if */
            if (!this.asset.isGestureOperate) {
              return;
            }

            let fingerIds: number[] = this.getFingerIds(event);
            /* instrument ignore if */
            if (this.isFingerListEmpty(fingerIds)) {
              return;
            }
            let mx = (event.fingerList[fingerIds[0]]?.localX + event.fingerList[fingerIds[1]]?.localX) / 2;
            let my = (event.fingerList[fingerIds[0]]?.localY + event.fingerList[fingerIds[1]]?.localY) / 2;
            this.onPanGestureMove(mx - offsetX, my - offsetY);
            offsetX = mx;
            offsetY = my;

            /* instrument ignore if */
            if ((Math.abs(event.scale - this.relateScale) <= SCALE_THRESHOLD)) {
              return;
            } else {
              this.relateScale = event.scale < this.relateScale ? (event.scale + SCALE_THRESHOLD) :
                (event.scale - SCALE_THRESHOLD)
            }
            let centerX = (event.fingerList[fingerIds[0]].globalX + event.fingerList[fingerIds[1]].globalX) / 2;
            let centerY = (event.fingerList[fingerIds[0]].globalY + event.fingerList[fingerIds[1]].globalY) / 2;
            // 缩放比例
            this.onPinchGestureScale(
              this.relateScale / scaleRatio,
              centerX,
              centerY
            );

            HiLog.i(TAG, 'offsetX is ' + offsetX + ', offsetY is ' + offsetY + ', centerX is ' + centerX +
              'centerY is ' + centerY + ', relateScale is ' + this.relateScale + ', scaleRatio is ' + scaleRatio)
            scaleRatio = this.relateScale;
          })
          .onActionEnd((): void => {
            /* instrument ignore if */
            if (!this.asset.isGestureOperate) {
              return;
            }
            /* instrument ignore if */
            if (!ScreenManager.getInstance().getIsFirstFrame()) {
              return;
            }
            Trace.end('pinch gesture')
            setTimeout(() => {
              // 标识延时50ms设置，避免与父组件或兄弟onTouch事件冲突
              this.asset.isGestureOperate = false;
            }, 50)

            // 平移缩放同时进行时，缩放结束重置比例
            scaleRatio = ONE_SCALE_RATION;
            // 缩放结束
            HiLog.i('FrostedGlass', 'PinchGesture end');
            this.isTouchScreen = false;
            App.getInstance().myEditor().asset.fillCropRect(ANIMATION_DURATION, FillCropType.PinchEnd, () => {
              this.onGestureEnd();
              this.editor.asset.overSizePrompt();
              /* instrument ignore if */
              if (this.editor.isEdit) {
                this.editor.isShowRevert = !this.editor.isEdited();
              }
            });
          })
          .onActionCancel((): void => {
          /* instrument ignore if */
          if (!this.asset.isGestureOperate) {
            return;
          }
          /* instrument ignore if */
          if (!ScreenManager.getInstance().getIsFirstFrame()) {
            return;
          }
          Trace.end('pinch gesture')
          setTimeout(() => {
            // 标识延时50ms设置，避免与父组件或兄弟onTouch事件冲突
            this.asset.isGestureOperate = false;
          }, 50)

          // 平移缩放同时进行时，缩放结束重置比例
          scaleRatio = 1;
          // 缩放结束
          HiLog.i('FrostedGlass', 'PinchGesture end');
          this.isTouchScreen = false;
          App.getInstance().myEditor().asset.fillCropRect(ANIMATION_DURATION, FillCropType.PinchEnd, () => {
            this.onGestureEnd();
            this.editor.asset.overSizePrompt();
            /* instrument ignore if */
            if (this.editor.isEdit) {
              this.editor.isShowRevert = !this.editor.isEdited();
            }
          });
        }),
        PanGesture({ distance: 0.01, fingers: 1 })// 最小拖动识别距离，单位为vp。默认值：5
          .onActionStart((event: GestureEvent | undefined): void => {
            HiLog.i(TAG, 'FrostedGlass, start PanGesture');
            this.startClipSize = this.clipSize.clone();
            this.isTouchScreen = false;
            // 裁剪和手势组合互斥
            /* instrument ignore if */
            if (this.dragObj.dragging || this.isRotateAndMirrorStatus || this.isStopOperating ||
            this.asset.isTouching) {
              this.asset.isGestureOperate = false;
              HiLog.i(TAG, `PanGesture dragging: ${this.dragObj.dragging} [isRotateAndMirrorStatus:${
              this.isRotateAndMirrorStatus} isStopOperating: ${this.isStopOperating} isTouching:${
              this.asset.isTouching}]`);
              return;
            }
            /* instrument ignore if */
            if (this.editor.tabIndex == TabName.TabAperture) {
            }

            this.fingerIds = this.getFingerIds(event);
            let isInHotArea = (this.editor.tabIndex === TabName.TabCrop) && this.isCropFrameHotArea(event);
            /* instrument ignore if */
            if (!this.isTouchScreen && this.isRecordOperating) {
              // 启动记录撤销恢复的值
              App.getInstance().myEditor().startEditorOperate();
              !isInHotArea && App.getInstance().myEditor().asset.fillCropRect(0, FillCropType.MoveStart);
              this.isTouchScreen = true;
            }
            /* instrument ignore if */
            if (isInHotArea) {
              HiLog.i(TAG, 'start drag frame');
              Trace.begin('EditorCropBoxDrag');
              return
            }

            Trace.begin('pan gesture')
            App.getInstance().myEditor().interrupt = true;
            HiLog.i('FrostedGlass', 'PanGesture start');
            // 拖动视频
            offsetX = 0;
            offsetY = 0;
            this.asset.isGestureOperate = !this.dragObj.dragging;
          })
          .onActionUpdate((event: GestureEvent) => {
            /* instrument ignore if */
            if (!event || !event.fingerList || event.fingerList.length === 0 ||
              !this.fingerIds || this.fingerIds.length === 0 || this.fingerIds[0] === undefined) {
              HiLog.e(TAG, `PanGesture event is empty or fingerIds length is zero!` +
                `PanGesture event:[ ${JSON.stringify(event)} ]`);
              return;
            }
            let index: number = (!event.fingerList[this.fingerIds[0]]) ?
              ((!event.fingerList[0]) ? -1 : 0) : this.fingerIds[0];
            if (index === -1) {
              HiLog.e(TAG, `PanGesture event is undefined!` +
                `PanGesture event:[ ${JSON.stringify(event)} ]`);
              return;
            }
            HiLog.i('FrostedGlass', 'PanGesture move hasActionStarted = ' + this.asset.isGestureOperate);
            if (this.dragObj.dragging) {
              let touch = event.fingerList[index];
              let delX: number = touch.globalX - this.dragObj.x;
              let delY: number = touch.globalY - this.dragObj.y;
              // 裁剪和缩放平移手势互斥
              let newPosition = this.clipSize.clone()
              let direction = this.dragObj.action
              Trace.begin('getEditorCropRect');
              if (this.dragObj.multiCrop) {
                this.getMultiCropRect(delX, delY, newPosition, direction, event.pressure)
              } else {
                this.getSingleCropRect(delX, delY, newPosition, direction, event.pressure)
              }
              Trace.end('getEditorCropRect');
              return
            }
            /* instrument ignore if */
            if (!this.asset.isGestureOperate) {
              return;
            }
            // 移动距离 正负值
            let mx = event.offsetX;
            let my = event.offsetY;
            if (Math.round(mx - offsetX) != 0 || Math.round(my - offsetY) != 0) {
              this.onPanGestureMove(mx - offsetX, my - offsetY);
              offsetX = mx;
              offsetY = my;
            }
            let offset: PositionType = {
              x: offsetX,
              y: offsetY,
            }
            App.getInstance()
              .myEditor()
              .asset
          })
          .onActionEnd((event: GestureEvent) => {
            setTimeout((): void => {
              this.broadcastCropSize(this.dragObj.action);
            }, cropFrameResetTime);

            if (this.dragObj.dragging) {
              Trace.end('EditorCropBoxDrag');
              this.editor.stopEditorOperate()
              this.onSizeEnd(this.clipSize.left, this.clipSize.top, this.clipSize.right, this.clipSize.bottom);
              if (this.editor.isEdit) {
                this.editor.isShowRevert = !this.editor.editModified;
              }
              this.dragObj.dragging = false
              return
            }
            /* instrument ignore if */
            if (!this.asset.isGestureOperate) {
              return;
            }
            Trace.end('pan gesture')
            this.endGestureOperate(event);
            HiLog.i('FrostedGlass', 'PanGesture end');
          })
          .onActionCancel((event: GestureEvent) => {
            App.getInstance()
              .myEditor()
              .asset
            setTimeout((): void => {
              this.broadcastCropSize(this.dragObj.action);
            }, cropFrameResetTime);

            if (this.dragObj.dragging) {
              Trace.end('EditorCropBoxDrag');
              this.editor.stopEditorOperate()
              this.onSizeEnd(this.clipSize.left, this.clipSize.top, this.clipSize.right, this.clipSize.bottom);
              if (this.editor.isEdit) {
                this.editor.isShowRevert = !this.editor.editModified;
              }
              this.dragObj.dragging = false
              return
            }
            /* instrument ignore if */
            if (!this.asset.isGestureOperate) {
              return;
            }
            Trace.end('pan gesture')
            this.endGestureOperate(event);
            HiLog.i('FrostedGlass', 'PanGesture end');
        }),
      )
    )
  }

  broadcastCropSize(direction: Action) {
    let dirction: string | undefined = this.actionDirection(direction);
    if (dirction == undefined) {
      HiLog.w(TAG, 'action dirction is unknown');
      return;
    }
    // 计算裁剪面积
    let oldAear: number = this.startClipSize.width() * this.startClipSize.height();
    let curAear: number = this.clipSize.width() * this.clipSize.height();
    let cutRatio: number = Math.abs((oldAear - curAear) / Math.max(oldAear, curAear));
    cutRatio = Math.round(cutRatio * percentage);
    HiLog.i(TAG, 'cutting ratio:' + cutRatio)
    if (cutRatio < 1) {
      HiLog.i(TAG, 'image not cropped');
      return;
    }
    let content: string =
      getContext().resourceManager.getStringSync($r('app.string.cutting_percentage'), dirction, `${cutRatio}%`);
    AccessibilityUtil.sendAnnounceAccessibilityEvent(content);
  }

  actionDirection(direction: Action): string | undefined {
    let directionStr: string | undefined = undefined;
    if (direction.left && direction.top) {
      directionStr = UiUtil.getResourceString($r('app.string.direction_left_top'));
    } else if (direction.left && direction.bottom) {
      directionStr = UiUtil.getResourceString($r('app.string.direction_left_bottom'));
    } else if (direction.right && direction.top) {
      directionStr = UiUtil.getResourceString($r('app.string.direction_right_top'));
    } else if (direction.right && direction.bottom) {
      directionStr = UiUtil.getResourceString($r('app.string.direction_right_bottom'));
    } else if (direction.left) {
      directionStr = UiUtil.getResourceString($r('app.string.direction_left'));
    } else if (direction.top) {
      directionStr = UiUtil.getResourceString($r('app.string.direction_top'));
    } else if (direction.right) {
      directionStr = UiUtil.getResourceString($r('app.string.direction_right'));
    } else if (direction.bottom) {
      directionStr = UiUtil.getResourceString($r('app.string.direction_bottom'));
    }
    return directionStr;
  }

  isCropFrameHotArea(event: GestureEvent | undefined): boolean {
    /* instrument ignore if */
    if (!event || !event.fingerList || (event.fingerList.length !== 1) ||
      !this.fingerIds || this.fingerIds.length === 0 || this.fingerIds[0] === undefined) {
      HiLog.e(TAG, `event is unexpected or undefined!` +
        `event :[ ${JSON.stringify(event)} ]`);
      return false;
    }

    let index: number = (!event.fingerList[this.fingerIds[0]]) ?
      ((!event.fingerList[0]) ? -1 : 0) : this.fingerIds[0];
    if (index === -1) {
      HiLog.e(TAG, `event is undefined! event :[ ${JSON.stringify(event)} ]`);
      return false;
    }
    let exWidth: number = expandedHotspotsWidth;
    let localX: number = event.fingerList[index].localX;
    let localY: number = event.fingerList[index].localY;
    let OpAreaTop: number = px2vp(UiUtil.getOperationArea(vp2px(exWidth), 0,
      undefined, this.isScreenPortrait).top);
    let previewRectOffset: number = UiUtil.getPreviewRectOffset();
    let bottom: number = this.clipSize.bottom - OpAreaTop;
    let top: number = this.clipSize.top - OpAreaTop;
    let left: number = this.clipSize.left - previewRectOffset;
    let right: number = this.clipSize.right - previewRectOffset;
    HiLog.i(TAG, `localX: ${localX}, localY: ${localY}, previewRectOffset: ${previewRectOffset}` +
      `, bottom: ${bottom}, top: ${top}, left: ${left}, right: ${right}`);
    let isInLeftRight: boolean = (localX > (left - exWidth)) && localX < (right + exWidth);
    let isInTopBottom: boolean = (localY > (top - exWidth)) && (localY < (bottom + exWidth));
    let eventTop: boolean = (Math.abs(localY - top) < exWidth) && isInLeftRight;
    let eventBottom: boolean = (Math.abs(localY - bottom) < exWidth) && isInLeftRight;
    let eventLeft: boolean = (Math.abs(localX - left) < exWidth) && isInTopBottom;
    let eventRight: boolean = (Math.abs(localX - right) < exWidth) && isInTopBottom;

    let eventCount = (eventLeft ? 1 : 0) + (eventTop ? 1 : 0) + (eventRight ? 1 : 0) + (eventBottom ? 1 : 0);
    HiLog.i(TAG, `onTouch eventCount: ${eventCount} [eventLeft: ${eventLeft} eventTop: ${eventTop
    } eventRight: ${eventRight} eventBottom: ${eventBottom}]`);
    // 解决长截图图片 宽/高 < 43，单指触摸触发3个方向热区、同时触发上下/左右热区的异常场景
    /* instrument ignore if */
    if (eventCount >= LONG_SCREENSHOT_CROP_HOT_AREA) {
      if (eventLeft && eventRight) {
        eventLeft = false;
        eventRight = false;
        eventCount = eventCount - LONG_SCREENSHOT_CROP_HOT_AREA;
      }
      if (eventTop && eventBottom) {
        eventTop = false;
        eventBottom = false;
        eventCount = eventCount - LONG_SCREENSHOT_CROP_HOT_AREA;
      }
    }
    if (eventCount > 0) {
      this.cropAttr.animateShowSplitLine(true);
      let downPos = new DownPos(this.clipSize.left, this.clipSize.top, this.clipSize.bottom, this.clipSize.right);
      let action = new Action(eventLeft, eventTop, eventRight, eventBottom);
      this.dragObj = new DragObj(true, event.fingerList[index].globalX,
        event.fingerList[index].globalY, action, downPos, eventCount > 1);
      this.asset.isGestureOperate = false;
      return true;
    }
    return false;
  }

  private getFingerIds(event: GestureEvent): number[] {
    let fingerIds: number[] = [];
    if(!event || !event.fingerList) {
      HiLog.e(TAG, 'getFingerIds, event or event.fingerList is null or undefined.');
      return fingerIds;
    }
    event.fingerList.forEach((fingerInfo: FingerInfo) => {
      /* instrument ignore if */
      if (!fingerInfo || fingerInfo.id === null || fingerInfo.id === undefined) {
        HiLog.e(TAG, 'getFingerIds, fingerInfo is empty or fingerInfo id is null or undefined.');
      } else {
        fingerIds.push(fingerInfo.id)
      }
    })
    return fingerIds
  }

  private isFingerListEmpty(fingerIds: number[]): boolean {
    /* instrument ignore if */
    if (!fingerIds || fingerIds.length < 2) {
      HiLog.e(TAG, 'FrostedGlass, fingerList is empty!');
      return true
    }
    return false
  }

  touchHandler: (event: TouchEvent) => void = (event: TouchEvent): void => {
    /* instrument ignore if */
    if (!ScreenManager.getInstance().getIsFirstFrame()) {
      return;
    }
    /* instrument ignore if */
    if (event.stopPropagation === null || event.stopPropagation === undefined) {
      return;
    }
    event.stopPropagation();
    /* instrument ignore if */
    if (this.isStopOperating) {
      return;
    }
    if (event.type === TouchType.Up) {
      this.endDraggingOperate();
    }

    if (event.type === TouchType.Down && this.dragObj.dragging) {
      this.editor.startEditorOperate();
    }

    if (event.type === TouchType.Move) {
      /* instrument ignore if */
      if (!this.dragObj.dragging) {
        return;
      }
      let touch = event.touches[0];
      let delX: number = touch.screenX - this.dragObj.x;
      let delY: number = touch.screenY - this.dragObj.y;
      // 裁剪和缩放平移收拾互斥

      let newPosition = this.clipSize.clone();

      let direction = this.dragObj.action;
      if (this.dragObj.multiCrop) {
        this.getMultiCropRect(delX, delY, newPosition, direction, event.pressure);
      } else {
        this.getSingleCropRect(delX, delY, newPosition, direction, event.pressure);
      }
    }
  }

  private endDraggingOperate() {
    if (this.dragObj.dragging) {
      this.editor.stopEditorOperate();
      this.onSizeEnd(this.clipSize.left, this.clipSize.top, this.clipSize.right, this.clipSize.bottom);
      if (this.editor.isEdit) {
        this.editor.isShowRevert = !this.editor.isEdited();
      }
    }
    this.dragObj.dragging = false;
  }

  private endGestureOperate(event?: GestureEvent) {
    this.asset.isGestureOperate = false;
    // 平移缩放同时进行时，拖拽结束重置比例
    offsetX = 0;
    offsetY = 0;
    this.isTouchScreen = false;
    App.getInstance()
      .myEditor()
      .asset
      .inertialMove(event)
      .then(() => {
        App.getInstance().myEditor().asset.fillCropRect(ANIMATION_DURATION, FillCropType.MoveEnd, () => {
          this.onGestureEnd();
          this.editor.asset.overSizePrompt();
          if (this.editor.isEdit) {
            this.editor.isShowRevert = !this.editor.isEdited();
          }
        });
      });
  }

  getMultiCropRect(delX: number, delY: number, newPosition: Rectangle, direction: Action, pressure: number) {
    if (direction.left) {
      newPosition.left = this.dragObj.downPos.left + delX;
      let width = this.clipSize.right - newPosition.left;
      if (App.getInstance()
        .myEditor()
        .asset
        .crops()
        .clipRatio > 0) {
        let height = width / App.getInstance()
          .myEditor()
          .asset
          .crops()
          .clipRatio;
        if (height <= this.minSize) {
          newPosition.left = this.clipSize.right - this.minSize * App.getInstance()
            .myEditor()
            .asset
            .crops()
            .clipRatio;
        }
      } else if (width <= this.minSize) {
        newPosition.left = this.clipSize.right - this.minSize;
      }
    }
    if (direction.top) {
      newPosition.top = this.dragObj.downPos.top + delY;
      let height = this.clipSize.bottom - newPosition.top;
      if (App.getInstance()
        .myEditor()
        .asset
        .crops()
        .clipRatio > 0) {
        let width = height * App.getInstance()
          .myEditor()
          .asset
          .crops()
          .clipRatio;
        /* instrument ignore if */
        if (width <= this.minSize) {
          newPosition.top = this.clipSize.bottom - this.minSize / App.getInstance()
            .myEditor()
            .asset
            .crops()
            .clipRatio;
        }
      } else if (height <= this.minSize) {
        newPosition.top = this.clipSize.bottom - this.minSize;
      }
    }
    if (direction.right) {
      newPosition.right = this.dragObj.downPos.right + delX;
      let width = newPosition.right - this.clipSize.left;
      if (App.getInstance()
        .myEditor()
        .asset
        .crops()
        .clipRatio > 0) {
        let height = width / App.getInstance()
          .myEditor()
          .asset
          .crops()
          .clipRatio;
        if (height <= this.minSize) {
          newPosition.right = this.clipSize.left + this.minSize * App.getInstance()
            .myEditor()
            .asset
            .crops()
            .clipRatio;
        }
      } else if (width <= this.minSize) {
        newPosition.right = this.clipSize.left + this.minSize;
      }
    }
    if (direction.bottom) {
      newPosition.bottom = this.dragObj.downPos.bottom + delY;
      let height = newPosition.bottom - this.clipSize.top;
      if (App.getInstance()
        .myEditor()
        .asset
        .crops()
        .clipRatio > 0) {
        let width = height * App.getInstance()
          .myEditor()
          .asset
          .crops()
          .clipRatio;
        if (width <= this.minSize) {
          newPosition.bottom = this.clipSize.top + this.minSize / App.getInstance()
            .myEditor()
            .asset
            .crops()
            .clipRatio;
        }
      } else if (height <= this.minSize) {
        newPosition.bottom = this.clipSize.top + this.minSize;
      }
    }
    this.onSizing(newPosition.left, newPosition.top, newPosition.right, newPosition.bottom,
      direction.left ? 1 : 0, direction.top ? 1 : 0, direction.right ? 1 : 0, direction.bottom ? 1 : 0, pressure)
  }

  getSingleCropRect(delX: number, delY: number, newPosition: Rectangle, direction: Action, pressure: number) {
    if (direction.left) {
      let newX = this.dragObj.downPos.left + delX;
      newX = newX < this.dragObj.downPos.right - this.minSize ? newX : this.dragObj.downPos.right - this.minSize
      if (App.getInstance()
        .myEditor()
        .asset
        .crops()
        .clipRatio > 0) {
        let width = this.clipSize.right - newX;
        let height = width / App.getInstance()
          .myEditor()
          .asset
          .crops()
          .clipRatio;
        newPosition.top = this.clipSize.top - (height - this.clipSize.height()) / 2;
        newPosition.bottom = this.clipSize.bottom + (height - this.clipSize.height()) / 2;
        if (height <= this.minSize) {
          newX = this.clipSize.right - this.minSize * App.getInstance()
            .myEditor()
            .asset
            .crops()
            .clipRatio;
        }
      }
      newPosition.left = newX;
    } else if (direction.right) {
      let newX = this.dragObj.downPos.right + delX;
      if (newX < this.dragObj.downPos.left + this.minSize) {
        newX = this.dragObj.downPos.left + this.minSize;
      }
      if (App.getInstance()
        .myEditor()
        .asset
        .crops()
        .clipRatio > 0) {
        let width = newX - this.clipSize.left;
        let height = width / App.getInstance()
          .myEditor()
          .asset
          .crops()
          .clipRatio;
        newPosition.top = this.clipSize.top - (height - this.clipSize.height()) / 2;
        newPosition.bottom = this.clipSize.bottom + (height - this.clipSize.height()) / 2;
        if (height <= this.minSize) {
          newX = this.minSize * App.getInstance()
            .myEditor()
            .asset
            .crops()
            .clipRatio + this.clipSize.left;
        }
      }
      newPosition.right = newX;
    } else if (direction.top) {
      let newY = this.dragObj.downPos.top + delY;
      newY = newY < this.dragObj.downPos.bottom - this.minSize ? newY : this.dragObj.downPos.bottom - this.minSize
      if (App.getInstance()
        .myEditor()
        .asset
        .crops()
        .clipRatio > 0) {
        let height = this.clipSize.bottom - newY;
        let width = height * App.getInstance()
          .myEditor()
          .asset
          .crops()
          .clipRatio;
        newPosition.left = this.clipSize.left - (width - this.clipSize.width()) / 2;
        newPosition.right = this.clipSize.right + (width - this.clipSize.width()) / 2;
        if (width <= this.minSize) {
          newY = this.clipSize.bottom - this.minSize / App.getInstance()
            .myEditor()
            .asset
            .crops()
            .clipRatio;
        }
      }
      newPosition.top = newY;
    } else if (direction.bottom) {
      let newY = this.dragObj.downPos.bottom + delY;
      if (newY < this.dragObj.downPos.top + this.minSize) {
        newY = this.dragObj.downPos.top + this.minSize;
      }
      if (App.getInstance()
        .myEditor()
        .asset
        .crops()
        .clipRatio > 0) {
        let height = newY - this.clipSize.top;
        let width = height * App.getInstance()
          .myEditor()
          .asset
          .crops()
          .clipRatio;
        newPosition.left = this.clipSize.left - (width - this.clipSize.width()) / 2;
        newPosition.right = this.clipSize.right + (width - this.clipSize.width()) / 2;
        if (width <= this.minSize) {
          newY = this.minSize / App.getInstance()
            .myEditor()
            .asset
            .crops()
            .clipRatio + this.clipSize.top;
        }
      }
      newPosition.bottom = newY;
    }

    this.onSizing(newPosition.left, newPosition.top, newPosition.right, newPosition.bottom,
      direction.left ? 1 : 0, direction.top ? 1 : 0, direction.right ? 1 : 0, direction.bottom ? 1 : 0, pressure)
  }

  resetOperate() {
    if (this.dragObj.dragging) {
      HiLog.i(TAG, 'focus changed when dragging');
      this.endDraggingOperate();
    }

    if (this.asset.isGestureOperate) {
      HiLog.i(TAG, 'focus changed when gestureOperate');
      this.endGestureOperate();
    }
  }

  onPortraitChange() {
    HiLog.w(TAG, `isImageMove: ${this.editor.isImageMove}`);
    if (this.editor.isImageMove) {
      setTimeout((): void => {
        this.endGestureOperate();
      }, ANIMATION_DURATION);
    }
  }
}

@Component
export struct RectangleSizer {
  @Prop clipSize: Rectangle = new Rectangle(0, 0, 0, 0);
  @State cropAttr: CropAttr = App.getInstance().myEditor().asset.crops();
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State asset: Asset = App.getInstance().myEditor().asset;
  @Prop clipVisible: boolean = false;
  @State show: boolean = this.cropAttr.isScrolling;
  @State isTouched: boolean = false;
  @State screenClass: ScreenClass = App.getInstance().screenClass;
  @Prop hasSplitLine: boolean = false;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) isScreenPortrait: boolean = ScreenManager.getInstance().isScreenPortrait();

  build() {
    Column() {
      Stack() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
          Row().rowStyle().id('petalClip_frostedGlass_top')
          Row().rowStyle2(this.cropAttr.isScrolling).id('petalClip_frostedGlass_row_81_1')
          Row().rowStyle2(this.cropAttr.isScrolling).id('petalClip_frostedGlass_row_81_2')
          Row().rowStyle1(this.hasSplitLine || this.cropAttr.isScrolling).id('petalClip_frostedGlass_row_9_1')
          Row().rowStyle2(this.cropAttr.isScrolling).id('petalClip_frostedGlass_row_81_3')
          Row().rowStyle2(this.cropAttr.isScrolling).id('petalClip_frostedGlass_row_81_4')
          Row().rowStyle1(this.hasSplitLine || this.cropAttr.isScrolling).id('petalClip_frostedGlass_row_9_2')
          Row().rowStyle2(this.cropAttr.isScrolling).id('petalClip_frostedGlass_row_81_5')
          Row().rowStyle2(this.cropAttr.isScrolling).id('petalClip_frostedGlass_row_81_6')
          Row().rowStyle().id('petalClip_frostedGlass_bottom')
        }
        .padding({
          top: expandedHotspotsWidth,
          left: expandedHotspotsWidth + 1,
          bottom: expandedHotspotsWidth,
          right: expandedHotspotsWidth + 1,
        })

        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
          Column().columnStyle().id('petalClip_frostedGlass_left')
          Column().columnStyle2(this.cropAttr.isScrolling).id('petalClip_frostedGlass_column_81_1')
          Column().columnStyle2(this.cropAttr.isScrolling).id('petalClip_frostedGlass_column_81_2')
          Column()
            .columnStyle1(this.hasSplitLine || this.cropAttr.isScrolling)
            .id('petalClip_frostedGlass_column_9_1')
          Column().columnStyle2(this.cropAttr.isScrolling).id('petalClip_frostedGlass_column_81_3')
          Column().columnStyle2(this.cropAttr.isScrolling).id('petalClip_frostedGlass_column_81_4')
          Column()
            .columnStyle1(this.hasSplitLine || this.cropAttr.isScrolling)
            .id('petalClip_frostedGlass_column_9_2')
          Column().columnStyle2(this.cropAttr.isScrolling).id('petalClip_frostedGlass_column_81_5')
          Column().columnStyle2(this.cropAttr.isScrolling).id('petalClip_frostedGlass_column_81_6')
          Column().columnStyle().id('petalClip_frostedGlass_right')
        }
        .padding(expandedHotspotsWidth)

        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
            Row()
              .width(20)
              .height(20)
              .border({
                width: { top: { value: 3, unit: LengthUnit.VP }, start: { value: 3, unit: LengthUnit.VP } },
                color: '#FFFFFF',
              })
              .id('petalClip_frostedGlass_rect_leftTop')
              .enabled(true)
              .accessibilityLevel('yes')
              .accessibilityText(UiUtil.getResourceString($r('app.string.rect_left_top')))
            Row()
              .width(20)
              .height(20)
              .border({ width: { top: { value: 3, unit: LengthUnit.VP } }, color: { top: '#FFFFFF' } })
              .id('petalClip_frostedGlass_rect_topMiddle')
              .enabled(true)
              .accessibilityLevel('yes')
              .accessibilityText(UiUtil.getResourceString($r('app.string.rect_top_middle')))
            Row()
              .width(20)
              .height(20)
              .border({
                width: { top: { value: 3, unit: LengthUnit.VP }, end: { value: 3, unit: LengthUnit.VP } },
                color: '#FFFFFF',
              })
              .id('petalClip_frostedGlass_rect_rightTop')
              .enabled(true)
              .accessibilityLevel('yes')
              .accessibilityText(UiUtil.getResourceString($r('app.string.rect_right_top')))
          }
          .height(Math.min(20, this.clipSize.height() / 3 + 4)).clip(true)

          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
            Row()
              .width(20)
              .height(20)
              .border({ width: { start: { value: 3, unit: LengthUnit.VP } }, color: { start: '#FFFFFF' } })
              .id('petalClip_frostedGlass_rect_leftMiddle')
              .enabled(true)
              .accessibilityLevel('yes')
              .accessibilityText(UiUtil.getResourceString($r('app.string.rect_left_middle')))
            Row()
              .width(20)
              .height(20)
              .border({ width: { end: { value: 3, unit: LengthUnit.VP } }, color: { end: '#FFFFFF' } })
              .id('petalClip_frostedGlass_rect_rightMiddle')
              .enabled(true)
              .accessibilityLevel('yes')
              .accessibilityText(UiUtil.getResourceString($r('app.string.rect_right_middle')))
          }
          .height(Math.min(20, this.clipSize.height() / 3 + 1)).clip(true)

          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
            Row()
              .width(20)
              .height(Math.min(20, this.clipSize.height() / 3 + 4))
              .border({
                width: {
                  bottom: { value: 3, unit: LengthUnit.VP }, start: {
                    value: 3, unit:
                    LengthUnit.VP
                  }
                }, color: '#FFFFFF'
              })
              .id('petalClip_frostedGlass_rect_leftBottom')
              .enabled(true)
              .accessibilityLevel('yes')
              .accessibilityText(UiUtil.getResourceString($r('app.string.rect_left_bottom')))
            Row()
              .width(20)
              .height(Math.min(20, this.clipSize.height() / 3 + 4))
              .border({ width: { bottom: { value: 3, unit: LengthUnit.VP } }, color: { bottom: '#FFFFFF' } })
              .id('petalClip_frostedGlass_rect_middleBottom')
              .enabled(true)
              .accessibilityLevel('yes')
              .accessibilityText(UiUtil.getResourceString($r('app.string.rect_middle_bottom')))
            Row()
              .width(20)
              .height(Math.min(20, this.clipSize.height() / 3 + 4))
              .border({
                width: { bottom: { value: 3, unit: LengthUnit.VP }, end: { value: 3, unit: LengthUnit.VP } },
                color: '#FFFFFF',
              })
              .id('petalClip_frostedGlass_rect_rightBottom')
              .enabled(true)
              .accessibilityLevel('yes')
              .accessibilityText(UiUtil.getResourceString($r('app.string.rect_right_bottom')))
          }
        }
        .padding(expandedHotspotsWidth - 4)
      }
    }
    .width('100%')
    .height('100%')
    .id('petalClip_frostedGlass_rectangleSizer')
    .width(this.clipSize.width() + expandedHotspotsWidth * 2)
    .height(this.clipSize.height() + expandedHotspotsWidth * 2)
    .transition(TransitionEffect.asymmetric(TransitionEffect.OPACITY.animation({
      duration: 100, delay: this.isScreenPortrait ? 200 : 500,
    }), TransitionEffect.OPACITY.animation({ duration: 0 })))
    .visibility((this.clipVisible && !this.asset.isAnimating) ? Visibility.Visible : Visibility.Hidden)
    .enabled(true)
    .accessibilityLevel('yes')
    .accessibilityText(UiUtil.getResourceString($r('app.string.rectangle_sizer')))
    .position({
      x: this.clipSize.left - expandedHotspotsWidth - UiUtil.getPreviewRectOffset(),
      y: this.clipSize.top - px2vp(UiUtil.getOperationArea(vp2px(expandedHotspotsWidth), vp2px(expandedHotspotsWidth),
        undefined, this.isScreenPortrait).top),
    })
  }
}