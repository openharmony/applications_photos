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
import pointer from '@ohos.multimodalInput.pointer';
import {
  Action,
  App,
  BaseEditor,
  copyAttrTo,
  CropAttr,
  CropType,
  DownPos,
  DragObj,
  Rectangle,
  ScreenManager,
  TabName,
  Timeline
} from '@oh-image-editor/editor-common';
import { Service } from '@oh-image-editor/editor-common/src/main/ets/common/util/Service';
import { HiLog } from '@oh-image-editor/editor-common/src/main/ets/common/util/HiLog';
import {
  ANIMATION_DURATION,
  PC_MIN_CROP,
  SCREEN_ORIENTATION_PORTRAIT
} from '@oh-image-editor/editor-common/src/main/ets/common/const';
import { FillCropType } from '@oh-image-editor/editor-common/src/main/ets/service/model/Enum';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { LengthUnit } from '@kit.ArkUI';

@Extend(Row)
function rowStyle() {
  .width('100%')
  .height(1)
  .backgroundColor('#FFFFFF')
}

@Extend(Row)
function rowStyle1(hasSplitLine: boolean) {
  .width('100%')
  .height(1)
  .backgroundColor('#FFFFFF')
  .opacity(hasSplitLine ? 0.5 : 0)
}

@Extend(Column)
function columnStyle() {
  .width(1)
  .height('100%')
  .backgroundColor('#FFFFFF')
}

@Extend(Column)
function columnStyle1(hasSplitLine: boolean) {
  .width(1)
  .height('100%')
  .backgroundColor('#FFFFFF')
  .opacity(hasSplitLine ? 0.5 : 0)
}

@Extend(Row)
function contactStyle() {
  .width(20)
  .height(20)
}

@Extend(Row)
function topBottomHot(yPosition: number, height: number) {
  .height(height)
  .width('100%')
  .position({ x: 0, y: yPosition })
}

@Extend(Column)
function leftRightHot(xPosition: number, width: number) {
  .height('100%')
  .width(width)
  .position({ x: xPosition, y: 0 })
}

@Extend(Column)
function cornerHot(xPosition: number, yPosition: number, hotWidth: number) {
  .height(hotWidth)
  .width(hotWidth)
  .position({ x: xPosition, y: yPosition })
}

const TAG = 'CropFrame';
let offsetX: number = 0;
let offsetY: number = 0;
let hasActionStarted: boolean = false;
let scaleRatio = 1;
/**
 * ctrl + “+”放大比例
 */
const LARGER_SCALE: number = 1.25;

/**
 * ctrl + “-”缩小比例
 */
const SMALLER_SCALE: number = 1 / LARGER_SCALE;


@Component
export struct CropFrame {
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private onShortcutLargerFunc: Function = (): void => this.handleShortcutScaleChange(LARGER_SCALE);
  private onShortcutSmallerFunc: Function = (): void => this.handleShortcutScaleChange(SMALLER_SCALE);
  @State clipSize: Rectangle = App.getInstance()
    .myEditor()
    .asset
    .crops()
    .cropRect;
  @State cropAttr: CropAttr = App.getInstance().myEditor().asset.crops();
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State timeLine: Timeline = App.getInstance().myEditor().timeline;
  private dragObj: DragObj = new DragObj(false);
  private minSize = PC_MIN_CROP //最小宽高
  private hotWidth: number = 10;
  private touchHotWidth: number = 36;
  private isMouseOperating: boolean = false;
  private isTouchScreen: boolean = false;
  private mouseX: number = 0;
  private mouseY: number = 0;
  private gestureRatio: number = 1;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) isScreenPortrait: boolean = ScreenManager.getInstance().isScreenPortrait();

  private handleShortcutScaleChange(scale: number): void {
    HiLog.i(TAG, `CropFrame onShortcutSmaller scale:${scale}`);
    if (!this.isTouchScreen) {
      App.getInstance().myEditor().startEditorOperate();
      App.getInstance().myEditor().asset.fillCropRect(0, FillCropType.PinchStart);
      this.isTouchScreen = true;
    }
    hasActionStarted = true;
    let uiContext: UIContext = LocalStorage.getShared()?.get('uiContext') as UIContext;
    let rect = uiContext.getComponentUtils().getRectangleById('editor_page_operation_area');
    HiLog.i(TAG, 'editor_page_operation_area size:' + rect.size.width + `,${rect.size.height}`);
    // 缩放比例
    this.onPinchGestureScale(scale, px2vp(rect.size.width >> 1), px2vp(rect.size.height >> 1));
    scaleRatio = scale;

    this.zoomEnd();
  }

  build() {
    Column() {
      Stack() {
        this.horizontalLine();
        this.verticalLine();
        this.contacts();
        this.hotArea();
      }
      .id('editor_page_operation_area')
      .width(this.clipSize.width() + this.hotWidth)
      .height(this.clipSize.height() + this.hotWidth)
      .position({ x: this.clipSize.left - this.hotWidth / 2, y: this.clipSize.top - this.hotWidth / 2 })
      .visibility(this.editor.tabIndex === TabName.TabCrop ? Visibility.Visible : Visibility.None)
      .onHover((isHover: boolean, event: HoverEvent): void => {
        !this.isMouseOperating && this.hoverChangeMouseShape(pointer.PointerStyle.HAND_OPEN, isHover, event)
      })
    }
    .opacity(this.cropAttr.isRotateAndMirrorStatus ? 0 : 1)
    .onHover((isHover: boolean, event: HoverEvent): void => {
      !this.isMouseOperating && this.hoverChangeMouseShape(pointer.PointerStyle.DEFAULT, isHover, event)
    })
    .onMouse((event: MouseEvent): void => {
      if (event.stopPropagation === undefined || this.editor.tabIndex != TabName.TabCrop) {
        return;
      }
      this.mouseX = event.x;
      this.mouseY = event.y;
      event.stopPropagation();
      this.mouseOperating(event);
    })
    .gesture(
      GestureGroup(
        GestureMode.Parallel,
        PinchGesture({ fingers: 2, distance: 1 })// 最小识别距离，单位为vp。默认值：3
          .onActionStart((): void => {
            if (this.isMouseOperating) {
              return;
            }
            this.cropAttr.hasSplitLine = true;
            this.zoomStart();
            App.getInstance().myEditor().interrupt = true;
          })
          .onActionUpdate((event: GestureEvent) => {
            if (!event || this.isMouseOperating) {
              return;
            }
            this.zoomUpdate(event);
          })
          .onActionEnd((): void => {
            if (this.isMouseOperating) {
              return;
            }
            this.zoomEnd()
          }),
        PanGesture({ distance: 1 })// 最小拖动识别距离，单位为vp。默认值：5
          .onActionStart((event: GestureEvent) => {
            if (!event || this.isMouseOperating || event.source === SourceType.Mouse) {
              return;
            }
            this.dragStart(event);
            App.getInstance().myEditor().interrupt = true;
          })
          .onActionUpdate((event: GestureEvent) => {
            if (!event || this.isMouseOperating || event.source === SourceType.Mouse) {
              return;
            }
            if (this.dragObj.dragging) {
              HiLog.i(TAG, 'operating flame');
              this.dragFrame(event.offsetX, event.offsetY);
            } else {
              this.updatePos(event.offsetX, event.offsetY);
            }
          })
          .onActionEnd((event: GestureEvent) => {
            if (this.isMouseOperating || !event || event.source === SourceType.Mouse) {
              return;
            }
            if (this.dragObj.dragging) {
              HiLog.i(TAG, 'operating flame end');
              this.releaseFrame();
            } else {
              this.updateEnd();
              Service.changeMouseShape(pointer.PointerStyle.DEFAULT)
            }
          })
      )
    )
    .width('100%')
    .height('100%')
  }

  @Builder
  horizontalLine() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
      Row().rowStyle().id('petalClip_CropFrame_top')
      Row().rowStyle1(this.cropAttr.hasSplitLine).id('petalClip_CropFrame_row_9_1')
      Row().rowStyle1(this.cropAttr.hasSplitLine).id('petalClip_CropFrame_row_9_2')
      Row().rowStyle().id('petalClip_CropFrame_bottom')
    }.padding(this.hotWidth / 2)
  }

  @Builder
  verticalLine() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
      Column().columnStyle().id('petalClip_CropFrame_left')
      Column().columnStyle1(this.cropAttr.hasSplitLine).id('petalClip_CropFrame_column_9_1')
      Column().columnStyle1(this.cropAttr.hasSplitLine).id('petalClip_CropFrame_column_9_2')
      Column().columnStyle().id('petalClip_CropFrame_right')
    }.padding(this.hotWidth / 2)
  }

  @Builder
  contacts() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        Row()
          .contactStyle()
          .border({
            width: { top: { value: 3, unit: LengthUnit.VP }, start: { value: 3, unit: LengthUnit.VP } },
            color: { top: '#FFFFFF', start: '#FFFFFF' },
          })
          .id('petalClip_CropFrame_contacts_leftTop')
        Row()
          .contactStyle()
          .border({ width: { top: { value: 3, unit: LengthUnit.VP } }, color: { top: '#FFFFFF' } })
          .id('petalClip_CropFrame_contacts_topMiddle')
        Row()
          .contactStyle()
          .border({
            width: { top: { value: 3, unit: LengthUnit.VP }, end: { value: 3, unit: LengthUnit.VP } },
            color: { top: '#FFFFFF', end: '#FFFFFF' },
          })
          .id('petalClip_CropFrame_contacts_rightTop')
      }.height(20).clip(true)

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        Row()
          .contactStyle()
          .border({ width: { start: { value: 3, unit: LengthUnit.VP } }, color: { start: '#FFFFFF' } })
          .id('petalClip_CropFrame_contacts_leftMiddle')
        Row()
          .contactStyle()
          .border({ width: { end: { value: 3, unit: LengthUnit.VP } }, color: { end: '#FFFFFF' } })
          .id('petalClip_CropFrame_contacts_rightMiddle')
      }.height(20).clip(true)

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        Row()
          .contactStyle()
          .border({
            width: { bottom: { value: 3, unit: LengthUnit.VP }, start: { value: 3, unit: LengthUnit.VP } },
            color: { bottom: '#FFFFFF', start: '#FFFFFF' },
          })
          .id('petalClip_CropFrame_contacts_leftBottom')
        Row()
          .contactStyle()
          .border({ width: { bottom: { value: 3, unit: LengthUnit.VP } }, color: { bottom: '#FFFFFF' } })
          .id('petalClip_CropFrame_contacts_middleBottom')
        Row()
          .contactStyle()
          .border({
            width: { bottom: { value: 3, unit: LengthUnit.VP }, end: { value: 3, unit: LengthUnit.VP } },
            color: { bottom: '#FFFFFF', end: '#FFFFFF' },
          })
          .id('petalClip_CropFrame_contacts_rightBottom')
      }
    }
  }

  @Builder
  hotArea() {
    Column() {
      // 上下热区
      Row().topBottomHot(0, this.hotWidth)
        .onHover((isHover: boolean, event: HoverEvent): void => {
          !this.isMouseOperating && this.hoverChangeMouseShape(pointer.PointerStyle.NORTH_SOUTH, isHover, event)
        })
      Row().topBottomHot(this.clipSize.height(), this.hotWidth)
        .onHover((isHover: boolean, event: HoverEvent): void => {
          !this.isMouseOperating && this.hoverChangeMouseShape(pointer.PointerStyle.NORTH_SOUTH, isHover, event)
        })

      // 左右热区
      Column().leftRightHot(0, this.hotWidth)
        .onHover((isHover: boolean, event: HoverEvent): void => {
          !this.isMouseOperating && this.hoverChangeMouseShape(pointer.PointerStyle.WEST_EAST, isHover, event)
        })
      Column().leftRightHot(this.clipSize.width(), this.hotWidth)
        .onHover((isHover: boolean, event: HoverEvent): void => {
          !this.isMouseOperating && this.hoverChangeMouseShape(pointer.PointerStyle.WEST_EAST, isHover, event)
        })


      // 四角热区
      Column().cornerHot(0, 0, this.hotWidth)
        .onHover((isHover: boolean, event: HoverEvent): void => {
          !this.isMouseOperating && this.hoverChangeMouseShape(pointer.PointerStyle.NORTH_WEST_SOUTH_EAST, isHover,
            event);
        })
      Column().cornerHot(0, this.clipSize.height(), this.hotWidth)
        .onHover((isHover: boolean, event: HoverEvent): void => {
          !this.isMouseOperating && this.hoverChangeMouseShape(pointer.PointerStyle.NORTH_EAST_SOUTH_WEST, isHover,
            event);
        })
      Column().cornerHot(this.clipSize.width(), 0, this.hotWidth)
        .onHover((isHover: boolean, event: HoverEvent): void => {
          !this.isMouseOperating && this.hoverChangeMouseShape(pointer.PointerStyle.NORTH_EAST_SOUTH_WEST, isHover,
            event);
        })
      Column().cornerHot(this.clipSize.width(), this.clipSize.height(), this.hotWidth)
        .onHover((isHover: boolean, event: HoverEvent): void => {
          !this.isMouseOperating && this.hoverChangeMouseShape(pointer.PointerStyle.NORTH_WEST_SOUTH_EAST, isHover,
            event);
        })
    }.height('100%').width('100%')
  }

  private hoverChangeMouseShape = (shape: pointer.PointerStyle, isHover: boolean, event: HoverEvent): void => {
    if (event.stopPropagation === undefined) {
      return;
    }
    event.stopPropagation();
    isHover && Service.changeMouseShape(shape);
  }
  private operatingStart = (event: MouseEvent) => {
    if (!event || !this.inOperateArea(event.x, event.y, this.hotWidth)) {
      return;
    }
    this.cropAttr.hasSplitLine = (this.editor.tabIndex == TabName.TabCrop);
    let touchHotArea = this.isHotArea(event.x, event.y, this.hotWidth);
    if (!touchHotArea) {
      this.startMove(event.x, event.y);
      App.getInstance().myEditor().startEditorOperate();
      App.getInstance().myEditor().asset.fillCropRect(0, FillCropType.MoveStart);
    }
  }
  private startMove = (pressX: number = 0, pressY: number = 0) => {
    offsetX = pressX;
    offsetY = pressY;
    hasActionStarted = true;
  }
  private isHotArea = (x: number, y: number, hotWidth: number, fingerOperate: boolean = false): boolean => {
    let touchX = x - this.clipSize.left + hotWidth / 2;
    let touchY = y - (this.clipSize.top - hotWidth / 2);
    let inLeftHot = touchX <= hotWidth && touchX >= 0;
    let inTopHot = touchY <= hotWidth && touchY >= 0;
    let inRightHot = touchX >= this.clipSize.width() && touchX <= this.clipSize.width() + hotWidth;
    let inBottomHot = touchY >= this.clipSize.height() && touchY <= this.clipSize.height() + hotWidth;
    if (inLeftHot || inTopHot || inRightHot || inBottomHot) {
      let downPos = new DownPos(this.clipSize.left, this.clipSize.top, this.clipSize.bottom, this.clipSize.right);
      let action = new Action(inLeftHot, inTopHot, inRightHot, inBottomHot);
      this.dragObj = fingerOperate ?
        new DragObj(true, 0, 0, action, downPos) : new DragObj(true, x, y, action, downPos)
      return true;
    }
    return false;
  }

  private inOperateArea(x: number, y: number, hotWidth: number): boolean {
    let touchX = x - this.clipSize.left + hotWidth / 2;
    let touchY = y - (this.clipSize.top - hotWidth / 2);
    let inHorizontalArea = touchX >= 0 && touchX <= this.clipSize.width() + hotWidth;
    let inVerticalArea = touchY >= 0 && touchY <= this.clipSize.height() + hotWidth;
    return inHorizontalArea && inVerticalArea;
  }

  private changeMouseShapeByPos(hotWidth: number) {
    let touchX = this.mouseX - this.clipSize.left + hotWidth / 2;
    let touchY = this.mouseY - (this.clipSize.top - hotWidth / 2);
    let inLeftHot = touchX <= hotWidth && touchX >= 0;
    let inTopHot = touchY <= hotWidth && touchY >= 0;
    let inRightHot = touchX >= this.clipSize.width() && touchX <= this.clipSize.width() + hotWidth;
    let inBottomHot = touchY >= this.clipSize.height() && touchY <= this.clipSize.height() + hotWidth;
    let inHorizontalArea = touchX >= 0 && touchX <= this.clipSize.width() + hotWidth;
    let inVerticalArea = touchY >= 0 && touchY <= this.clipSize.height() + hotWidth;
    if (inHorizontalArea && inVerticalArea) {
      if ((inLeftHot && inTopHot) || (inRightHot && inBottomHot)) {
        Service.changeMouseShape(pointer.PointerStyle.NORTH_WEST_SOUTH_EAST)
      } else if ((inLeftHot && inBottomHot) || (inRightHot && inTopHot)) {
        Service.changeMouseShape(pointer.PointerStyle.NORTH_EAST_SOUTH_WEST)
      } else if (inLeftHot || inRightHot) {
        Service.changeMouseShape(pointer.PointerStyle.WEST_EAST)
      } else if (inTopHot || inBottomHot) {
        Service.changeMouseShape(pointer.PointerStyle.NORTH_SOUTH)
      } else {
        Service.changeMouseShape(pointer.PointerStyle.HAND_OPEN)
      }
    } else {
      Service.changeMouseShape(pointer.PointerStyle.DEFAULT)
    }
  }

  private dragStart = (event: GestureEvent) => {
    if (this.dragObj.dragging || this.cropAttr.isRotateAndMirrorStatus || !event.fingerList[0]) {
      HiLog.i(TAG, 'operatingCanvas set hasActionStarted = false');
      return;
    }
    if (!this.inOperateArea(event.fingerList[0].localX, event.fingerList[0].localY, this.touchHotWidth)) {
      return;
    }
    this.cropAttr.hasSplitLine = (this.editor.tabIndex == TabName.TabCrop);
    let touchHotArea = this.isHotArea(event.fingerList[0].localX, event.fingerList[0].localY, this.touchHotWidth, true);
    if (!touchHotArea) {
      this.startMove();
      if (!this.isTouchScreen) {
        // 启动记录撤销恢复的值
        App.getInstance().myEditor().startEditorOperate();
        App.getInstance().myEditor().asset.fillCropRect(0, FillCropType.MoveStart);
        this.isTouchScreen = true;
      }
    }
  }
  private updatePos = (x: number, y: number, moveType: number = 0) => {
    HiLog.i(TAG, `Move hasActionStarted = ${hasActionStarted}`);
    if (!hasActionStarted) {
      return;
    }
    Service.changeMouseShape(pointer.PointerStyle.HAND_GRABBING)
    // 移动距离 正负值
    let mx = x;
    let my = y;
    if (Math.round(mx - offsetX) != 0 || Math.round(my - offsetY) != 0) {
      this.panGestureMove(mx - offsetX, my - offsetY, moveType);
      offsetX = mx;
      offsetY = my;
    }
  }
  private updateEnd = (hotWidth: number = 0, isChangeMouse: boolean = false) => {
    if (!hasActionStarted) {
      return;
    }
    hasActionStarted = false;
    // 平移缩放同时进行时，拖拽结束重置比例
    offsetX = 0;
    offsetY = 0;
    HiLog.i(TAG, 'Mouse move end');
    this.isTouchScreen = false;
    App.getInstance().myEditor().asset.fillCropRect(ANIMATION_DURATION, FillCropType.MoveEnd);
    this.gestureEnd(hotWidth, isChangeMouse);
  }
  private mouseOperating: (event: MouseEvent) => void = (event: MouseEvent): void => {
    if (event.stopPropagation === undefined) {
      return;
    }
    event.stopPropagation();
    if (event.button != MouseButton.Left || this.cropAttr.isRotateAndMirrorStatus) {
      return;
    }
    if (this.dragObj.dragging) {
      HiLog.i(TAG, 'operating flame');
      this.operatingFrame(event);
      return;
    }

    if (event.action === MouseAction.Press) {
      this.isMouseOperating = true;
      this.operatingStart(event);
    }

    if (event.action === MouseAction.Move) {
      this.updatePos(event.x, event.y, 1);
    }

    if (event.action === MouseAction.Release) {
      this.changeMouseShapeByPos(this.hotWidth);
      this.isMouseOperating = false;
      this.updateEnd(this.hotWidth, true);
    }
  }
  private gestureEnd = (hotWidth: number = 0, isChangeMouse: boolean = false): void => {
    this.clearTimeout();
    App.getInstance().myEditor().stopEditorOperate();
    this.editor.imageMove = setTimeout(() => {
      this.editor.isImageMove = false;
    }, 300);
    this.editor.timeBlur = setTimeout((): void => {
      this.editor.tabIndex == TabName.TabCrop && (this.editor.asset.crops().isEnableBlur = true);
      this.cropAttr.hasSplitLine = false;
      App.getInstance().myEditor().interrupt = false;
      isChangeMouse && this.changeMouseShapeByPos(hotWidth);
    }, 1300);

    this.editor.timeStartZoom = setTimeout((): void => {
      this.cropAttr.isDragCrop && this.sizeAnimate(300);
      this.cropAttr.isDragCrop = false;
    }, 1000)
  }
  private panGestureMove: (movex: number, movey: number, moveType: number) =>
  void = (movex: number, movey: number, moveType: number): void => {
    this.clearTimeout();
    this.editor.asset.crops().isEnableBlur = false;
    this.editor.asset.crops().hasSplitLine = (this.editor.tabIndex == TabName.TabCrop); // 显示九宫格
    this.editor.asset.translate(vp2px(movex), vp2px(movey), moveType);
  }

  private clearTimeout(): void {
    clearTimeout(this.editor.timeStartZoom);
    clearTimeout(this.editor.timeBlur);
    clearTimeout(this.editor.imageMove);
  }

  releaseFrame(hotWidth: number = 0, isChangeMouse: boolean = false): void {
    this.dragObj = new DragObj(false);
    this.actionEnd(hotWidth, isChangeMouse);
  }

  dragFrame(x: number, y: number): void {
    let delX: number = x - this.dragObj.x;
    let delY: number = y - this.dragObj.y;

    let newPosition = this.clipSize.clone();

    let direction = this.dragObj.action;
    if (direction.left) {
      this.calcLeftPos(delX, newPosition);
    }
    if (direction.right) {
      this.calcRightPos(delX, newPosition);
    }
    if (direction.top) {
      this.calcTopPos(delY, newPosition);
    }
    if (direction.bottom) {
      this.calcBottomPos(delY, newPosition);
    }

    this.onAction(newPosition.left, newPosition.top, newPosition.right, newPosition.bottom,
      direction.left ? 1 : 0, direction.top ? 1 : 0, direction.right ? 1 : 0, direction.bottom ? 1 : 0)
  }

  operatingFrame: (event: MouseEvent) => void = (event: MouseEvent): void => {
    if (event.action === MouseAction.Release) {
      this.isMouseOperating = false;
      this.releaseFrame(this.hotWidth, true);
    }
    if (event.action === MouseAction.Move) {
      this.dragFrame(event.x, event.y);
    }
  }

  onAction(l: number, t: number, r: number, b: number,
    directionLeft: number, directionTop: number, directionRight: number, directionBottom: number): void {
    this.cropAttr.isDragCrop = true;
    this.editor.asset.crops().isEnableBlur = false;
    this.editor.asset.crops().hasSplitLine = (this.editor.tabIndex == TabName.TabCrop);
    clearTimeout(this.editor.timeBlur);
    clearTimeout(this.editor.timeStartZoom);
    // 裁剪单边拖动可移动边设置
    if (this.editor.asset.crops()
      .clipRatio > 0 && (directionLeft + directionTop + directionRight + directionBottom) === 1) {
      if (directionLeft || directionRight) {
        directionTop = 1;
        directionBottom = 1;
      } else if (directionTop || directionBottom) {
        directionLeft = 1;
        directionRight = 1;
      }
    }
    let newCrop = this.editor.asset.getReachableCropRect(l, t, r, b, this.editor.asset.crops().clipRatio,
      directionLeft, directionTop, directionRight, directionBottom);
    if (newCrop !== undefined) {
      copyAttrTo(newCrop, this.editor.asset.crops().cropRect);
    }
  }

  actionEnd(hotWidth: number = 0, isChangeMouse: boolean = false): void {
    clearTimeout(this.editor.timeBlur);
    clearTimeout(this.editor.timeStartZoom);
    isChangeMouse && this.changeMouseShapeByPos(hotWidth);
    this.editor.timeBlur = setTimeout((): void => {
      this.editor.asset.crops().isEnableBlur = true;
      isChangeMouse && this.changeMouseShapeByPos(hotWidth);
    }, 1300); // 裁剪恢复后再开高斯模糊，时间轴等显示 == 恢复速度很快，暂定300ms
    //  裁剪结束后等待恢复时长 500ms
    this.editor.timeStartZoom = setTimeout((): void => {
      this.editor.asset.crops().hasSplitLine = false;
      this.sizeAnimate(250);
      this.cropAttr.isDragCrop = false;
    }, 500)
  }

  sizeAnimate(aniDuration: number): void {
    this.editor.asset.setClipCropRect(aniDuration, CropType.FRAME_CROP, false);
  }

  zoomStart: () => void = (): void => {
    if (this.dragObj.dragging || this.cropAttr.isRotateAndMirrorStatus) {
      hasActionStarted = false;
      HiLog.i('FrostedGlass', 'PinchGesture set hasActionStarted = false');
      return;
    }
    if (!this.isTouchScreen) {
      App.getInstance().myEditor().startEditorOperate();
      App.getInstance().myEditor().asset.fillCropRect(0, FillCropType.PinchStart);
      this.isTouchScreen = true;
    }
    App.getInstance().myEditor().interrupt = true;
    // 缩放视频
    hasActionStarted = true;
    HiLog.i('FrostedGlass', 'PinchGesture start');
    scaleRatio = 1;
    this.cropAttr.hasSplitLine = (this.editor.tabIndex == TabName.TabCrop);
  }
  zoomUpdate: (event: GestureEvent) => void = (event: GestureEvent): void => {
    // 裁剪和手势组合互斥
    HiLog.i('FrostedGlass', 'PanGesture scale hasActionStarted = ' + hasActionStarted);
    if (!hasActionStarted) {
      return;
    }
    this.gestureRatio = event.scale / scaleRatio;
    if (Number(this.gestureRatio.toFixed(5)) != 1) {
      let centerX = event.pinchCenterX;
      let centerY = event.pinchCenterY;
      // 缩放比例
      this.onPinchGestureScale(this.gestureRatio, centerX, centerY);
      scaleRatio = event.scale;
    }
  }
  onPinchGestureScale: (ratio: number, centerx: number, centery: number) => void = (ratio: number, centerx: number,
    centery: number): void => {
    this.clearTimeout();
    this.editor.asset.crops().isEnableBlur = false;
    this.editor.asset.crops().hasSplitLine = (this.editor.tabIndex == TabName.TabCrop); // 显示九宫格
    this.editor.asset.scale(ratio, vp2px(centerx), vp2px(centery));
    this.editor.isImageMove = true;
  }
  zoomEnd: () => void = (): void => {
    if (!hasActionStarted) {
      return;
    }
    hasActionStarted = false;
    // 平移缩放同时进行时，缩放结束重置比例
    scaleRatio = 1;
    // 缩放结束
    HiLog.i(TAG, 'PinchGesture end');
    App.getInstance().myEditor().asset.fillCropRect(ANIMATION_DURATION, FillCropType.PinchEnd, () => {
      this.isTouchScreen = false;
      this.gestureEnd();
    });
  }

  calcLeftPos(delX: number, newPosition: Rectangle): void {
    let newX = this.dragObj.downPos.left + delX;
    newX = newX < this.dragObj.downPos.right - this.minSize ? newX : this.dragObj.downPos.right - this.minSize
    if (App.getInstance()
      .myEditor()
      .asset
      .crops()
      .clipRatio > 0) {
      let width = this.clipSize.right - newX;
      let height = this.clipSize.height();
      height = width / App.getInstance()
        .myEditor()
        .asset
        .crops()
        .clipRatio;
      if (height >= this.timeLine.operHeight) {
        newX = this.clipSize.right - this.timeLine.operHeight * App.getInstance()
          .myEditor()
          .asset
          .crops()
          .clipRatio;
      }
      if (height <= this.minSize) {
        newX = this.clipSize.right - this.minSize * App.getInstance()
          .myEditor()
          .asset
          .crops()
          .clipRatio;
      }
    }
    newPosition.left = newX;
  }

  calcRightPos(delX: number, newPosition: Rectangle): void {
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
      let height = this.clipSize.height();
      height = width / App.getInstance()
        .myEditor()
        .asset
        .crops()
        .clipRatio;
      if (height >= this.timeLine.operHeight) {
        newX = this.timeLine.operHeight * App.getInstance()
          .myEditor()
          .asset
          .crops()
          .clipRatio + this.clipSize.left;
      }
      if (height <= this.minSize) {
        newX = this.minSize * App.getInstance()
          .myEditor()
          .asset
          .crops()
          .clipRatio + this.clipSize.left;
      }
    }
    newPosition.right = newX;
  }

  calcTopPos(delY: number, newPosition: Rectangle): void {
    let newY = this.dragObj.downPos.top + delY;
    newY = newY < this.dragObj.downPos.bottom - this.minSize ? newY : this.dragObj.downPos.bottom - this.minSize
    if (App.getInstance()
      .myEditor()
      .asset
      .crops()
      .clipRatio > 0) {
      let height = this.clipSize.bottom - newY;
      let width = this.clipSize.width();
      width = height * App.getInstance()
        .myEditor()
        .asset
        .crops()
        .clipRatio;
      if (width >= this.timeLine.operWidth) {
        newY = this.clipSize.bottom - this.timeLine.operWidth / App.getInstance()
          .myEditor()
          .asset
          .crops()
          .clipRatio;
      }
      if (width <= this.minSize) {
        newY = this.clipSize.bottom - this.minSize / App.getInstance()
          .myEditor()
          .asset
          .crops()
          .clipRatio;
      }
    }
    newPosition.top = newY < App.getInstance().myEditor().timeline.operTop ?
    App.getInstance().myEditor().timeline.operTop : newY
  }

  calcBottomPos(delY: number, newPosition: Rectangle): void {
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
      let width = this.clipSize.width();
      width = height * App.getInstance()
        .myEditor()
        .asset
        .crops()
        .clipRatio;
      if (width >= this.timeLine.operWidth) {
        newY = this.timeLine.operWidth / App.getInstance()
          .myEditor()
          .asset
          .crops()
          .clipRatio + this.clipSize.top;
      }
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

  handleSizeChange = (isVertical: boolean = true, add: boolean = true) => {
    let newPosition = this.clipSize.clone();
    const changeValue = add ? 10 : -10;

    if (isVertical) {
      newPosition.top -= changeValue;
    } else {
      newPosition.left -= changeValue;
    }
    this.onAction(newPosition.left, newPosition.top, newPosition.right, newPosition.bottom,
      isVertical ? 0 : 1, isVertical ? 1 : 0, 0, 0);
    newPosition = this.clipSize.clone();
    if (isVertical) {
      newPosition.bottom += changeValue;
    } else {
      newPosition.right += changeValue;
    }
    this.onAction(newPosition.left, newPosition.top, newPosition.right, newPosition.bottom,
      0, 0, isVertical ? 0 : 1, isVertical ? 1 : 0);
    this.releaseFrame();
  }
  handleHeightAdd = () => {
    this.handleSizeChange();
  }
  handleHeightSub = () => {
    this.handleSizeChange(true, false);
  }
  handleWidthAdd = () => {
    this.handleSizeChange(false);
  }
  handleWidthSub = () => {
    this.handleSizeChange(false, false);
  }

  aboutToAppear(): void {
    this.appBroadCast?.on(BroadCastConstants.MEDIA_LARGER, this.onShortcutLargerFunc);
    this.appBroadCast?.on(BroadCastConstants.MEDIA_SMALLER, this.onShortcutSmallerFunc);
    this.appBroadCast.on(BroadCastConstants.CROP_HEIGHT_ADD, this.handleHeightAdd);
    this.appBroadCast.on(BroadCastConstants.CROP_HEIGHT_SUB, this.handleHeightSub);
    this.appBroadCast.on(BroadCastConstants.CROP_WIDTH_ADD, this.handleWidthAdd);
    this.appBroadCast.on(BroadCastConstants.CROP_WIDTH_SUB, this.handleWidthSub);
  }

  aboutToDisappear(): void {
    this.appBroadCast?.off(BroadCastConstants.MEDIA_LARGER, this.onShortcutLargerFunc);
    this.appBroadCast?.off(BroadCastConstants.MEDIA_SMALLER, this.onShortcutSmallerFunc);
    this.appBroadCast.off(BroadCastConstants.CROP_HEIGHT_ADD, this.handleHeightAdd);
    this.appBroadCast.off(BroadCastConstants.CROP_HEIGHT_SUB, this.handleHeightSub);
    this.appBroadCast.off(BroadCastConstants.CROP_WIDTH_ADD, this.handleWidthAdd);
    this.appBroadCast.off(BroadCastConstants.CROP_WIDTH_SUB, this.handleWidthSub);
  }
}