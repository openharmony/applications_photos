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
// instrument ignore file
import { TextEditMenu } from './TextEditMenu';
import { deepCopy, displayOption, TextAreaInfo } from '../model/TextAreaInfo';
import { UndoRedoManager } from '../viewModel/TabUndoRedoManager';
import { ScreenManager } from '../../../../common/util/ScreenManager';
import { HiLog } from '../../../../common/util/HiLog';
import { Operation } from '../model/Operation';
import { Constants, ResizeDirectionEdit, TouchMoveType } from '../util/Const';
import { TextAreaManager } from '../viewModel/TabTextAreaManager';
import { TextInputData } from '../model/TextInputData';
import { DeviceUtil } from '../../../../common/util/DeviceUtil';
import { FontStyleTitleAndClose } from './FontAlignTools';
import { SCREEN_ORIENTATION_PORTRAIT } from '../../../../common/const';
import { ScaleValues } from '../model/ScaleValues';
import { UiUtil } from '../../../../common/util/UiUtil';
import { Asset } from '../../../Asset';
import { App } from '../../../App';
import { accessibility } from '@kit.AccessibilityKit';
import { resourceManager } from '@kit.LocalizationKit';
import { LengthUnit } from '@kit.ArkUI';
import { AccessibilityManager } from '../../../../common/util/AccessibilityManager';
import { Point } from '../../../../common/util/PointUtil';

const TAG = 'TextEditItem';

@Component
export struct TextEditItem {
  @State asset: Asset = App.getInstance().myEditor().asset;
  @State isRotate: boolean = false;
  @State minHeight: number = 0;
  @State @Watch('textInputDataChange') textInputData: TextInputData = new TextInputData();
  @State touchStart: boolean = false;
  @State rotatePercentage: string = '';
  @Link isShowBorder: boolean;
  @Link isShowInPopup: boolean;
  @Link textCanClickStyle: boolean;
  @Link textInputAreaHide: boolean;
  @State isPullUpTextInput: boolean = false; // 是否可以拉起输入框
  @ObjectLink textArea: TextAreaInfo;
  @Link canUndo: boolean;
  @Link canRedo: boolean;
  @Link keyboardHeight: number;
  @Link currentFontColor: Color | string | Resource;
  @Link currentFontSize: number;
  @Link @Watch('fontSizeChange') isFontSizeChange: boolean;
  @Link portraitScale: ScaleValues;
  @Prop paintViewWidth: number;
  @Prop paintViewHeight: number;
  @Prop imagePositionX: number;
  @Prop imagePositionY: number;
  @State initPositionX: number = 0;
  @State initPositionY: number = 0;
  @State menuHeight: number = 0;
  @State menuPoint: Point = { x: 0, y: 0 } as Point;
  @State @Watch('menuWidthChange') menuWidth: number = 0;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) @Watch('onPortraitChange') isPortrait: boolean = ScreenManager.getInstance()
    .isScreenPortrait();
  @StorageLink('currentLanguage') @Watch('onLanguageChange') currentLanguage: string | undefined = undefined;
  @StorageLink('isAccessibilityMode') isAccessibilityMode: boolean = AccessibilityManager.getInstance()
    .getIsAccessibilityMode();
  @State scaleValueX: number =
    this.isPortrait || (DeviceUtil.isFoldable() && !ScreenManager.getInstance().isDeviceFold()) ?
    1 : this.portraitScale.scaleValueX;
  @State scaleValueY: number =
    this.isPortrait || (DeviceUtil.isFoldable() && !ScreenManager.getInstance().isDeviceFold()) ?
    1 : this.portraitScale.scaleValueY;
  @Prop isGestureRunning: boolean;
  @Consume rotateScale: number;
  private undoRedoManager: UndoRedoManager = UndoRedoManager.getInstance();
  private textAreaManager: TextAreaManager = TextAreaManager.getInstance();
  private rotateIconWidth: number = 39.25;
  private rotateIconHeight: number = 24;
  private lastTouchType: TouchType = TouchType.Down;

  menuWidthChange() {
    this.menuPoint = this.textInputData.refreshMenuPosition(this.textArea, this.paintViewWidth, this.paintViewHeight,
      this.textArea.localPositionX, this.textArea.localPositionY, this.textArea.textEditMenuWidth, this.rotateScale,
      this.rotateScale);
  }

  fontSizeChange() {
    if (this.textArea.editState) {
      HiLog.i(TAG, `fontSizeChange:${this.textArea.id}`);
      this.textInputData.height = this.textInputData.calWordHeight(this.textArea);
    }
  }

  onLanguageChange() {
    /* instrument ignore if */
    if (this.textArea.content != '') {
      return;
    }
    this.changeTextSpan(getContext().resourceManager.getStringSync($r('app.string.edit_text_imageEdit')));
  }

  editCallback: Function = () => {
    this.textArea.richEditorController.stopEditing();
    this.textArea.editState = 1;
    this.textArea.isShownMenu = false;
    this.textCanClickStyle = false;
    if (!ScreenManager.getInstance().isUIExtensionEnv()) {
      this.textInputAreaHide = !this.textInputAreaHide;
    } else {
      try {
        focusControl.requestFocus(this.textArea.id);
      } catch (error) {
        HiLog.e(TAG, 'TextEditItem onClick failed' + error.code + ` message is ${error.message}`);
      }
    }
    HiLog.i(TAG, 'TextEditItem edit click, editState: %{public}i', this.textArea.editState);
  };
  modifyStyleCallback: Function = () => {
    this.textArea.richEditorController.stopEditing();
    this.textArea.editState = 1;
    this.isShowInPopup = !this.isShowInPopup;
    this.textInputAreaHide = false;
    HiLog.i(TAG, 'TextEditItem modifyStyle click, editState: %{public}i', this.textArea.editState);
  };
  copyStyleCallback: Function = () => {
    /* instrument ignore if */
    if (this.textAreaManager.checkTextNumber()) {
      return;
    }
    this.textAreaManager.copy(this.asset.textEdit().textRect.width, this.asset.textEdit().textRect.height,
      this.textInputData.isRightEdge(this.textArea.localPositionX + Constants.TEXT_COPY_OFFSET, this.textArea.width,
        this.paintViewWidth, this.rotateScale),
      this.textInputData.isBottomEdge(this.textArea.localPositionY + Constants.TEXT_COPY_OFFSET, this.textArea.height,
        this.paintViewHeight));
    this.canUndo = this.undoRedoManager.canUndo();
    this.canRedo = this.undoRedoManager.canRedo();
    this.textCanClickStyle = true;
    this.menuWidthChange();
  };
  deleteCallback: Function = () => {
    this.textArea.editState = 0;
    this.textAreaManager.unRegister(this.textArea.id);
    this.textInputAreaHide = false;
    this.canUndo = this.undoRedoManager.canUndo();
    this.canRedo = this.undoRedoManager.canRedo();
    this.textCanClickStyle = false;
  };
  controller: TextInputController = new TextInputController();

  textInputDataChange(): void {
    this.textArea.height = this.textInputData.height;
  }

  onPortraitChange() {
    this.scaleValueX = this.isPortrait ? 1 : this.rotateScale;
    this.scaleValueY = this.isPortrait ? 1 : this.rotateScale;
  }

  aboutToAppear() {
    HiLog.i(TAG, 'TextEditItem aboutToAppear');

    this.isShowBorder = true;
    this.textArea.localPositionX = this.textArea.positionX;
    this.textArea.localPositionY = this.textArea.positionY;
    this.textInputData.height = this.textArea.height;
    this.textInputData.angle = this.textArea.angle;
    this.rotatePercentage =
      (((this.textArea.width / 2) / (this.textArea.width + this.rotateIconWidth)) * 100).toFixed(1) + '%'
    HiLog.i(TAG, `TextEditItem aboutToAppear rotatePercentage:${this.rotatePercentage}`);
    this.initPositionX =
      this.textInputData.getRealPositionX(this.textArea.localPositionX, this.textArea.width,
        this.paintViewWidth,
        this.rotateScale);
    this.initPositionY =
      this.textInputData.getRealPositionY(this.textArea.localPositionY, this.textArea.height,
        this.paintViewHeight,
        this.rotateScale);
    HiLog.i(TAG,
      `TextEditItem aboutToAppear paintViewWidth=${this.paintViewWidth} paintViewHeight=${this.paintViewHeight}`);
    // 切换窗口的时候关闭输入框
    try {
      ScreenManager.getInstance().getMainWindow().on('windowStatusChange', this.windowStatusType);
    } catch (exception) {
      HiLog.e(TAG, `TextEditItem windowStatusChange err:${exception.message}`);
    }
  }

  aboutToDisappear() {
    HiLog.i(TAG, 'TextEditItem aboutToDisappear');
    try {
      ScreenManager.getInstance().getMainWindow().off('windowStatusChange', this.windowStatusType);
    } catch (exception) {
      HiLog.e(TAG, `TextEditItem windowStatusChange err:${exception.message}`);
    }
  }

  windowStatusType = (windowStatusType: WindowStatusType) => {
    HiLog.i(TAG, `TextEditItem windowStatusChange windowStatusType:${windowStatusType}`);
    HiLog.i(TAG, 'TextEditItem windowStatusChange')
    this.textInputAreaHide = false;
  };

  changeTextSpan(content: string) {
    HiLog.i(TAG, 'changeTextSpan');
    this.textArea.richEditorController.deleteSpans();
    this.textArea.richEditorController.addTextSpan(content, {
      style: {
        fontColor: this.textArea.getShowColor(),
        fontSize: vp2px(this.textArea.fontSize) + 'px',
        fontWeight: this.textArea.isBold ? FontWeight.Bold : FontWeight.Normal,
        fontStyle: this.textArea.isItalic ? FontStyle.Italic : FontStyle.Normal,
        //设置下划线
        decoration: {
          type: this.textArea.isUnderline ? TextDecorationType.Underline : TextDecorationType.None,
          color: this.textArea.getShowColor(),
        },
        //阴影
        textShadow: this.textArea.isTextShadow ? Constants.borderShadow : { radius: 0 },
      },
      paragraphStyle: {
        textAlign: this.textArea.textAlign,
      }
    });
    //更新lastTextArea样式
    this.textAreaManager.copyStyle(this.textAreaManager.getLastTextArea(), this.textArea);
  }

  // 触摸移动事件
  private dealTouch(event: TouchEvent, isResize: Boolean,
    resizeDirection: ResizeDirectionEdit = ResizeDirectionEdit.TOP_LEFT, oriHeight: number, scaleValue: number = 1) {
    /* instrument ignore if */
    if (this.textArea.height >= this.textInputData.getTextMaxHeight()) {
      return;
    }
    let touchType: TouchType = event.type;
    if (this.lastTouchType == TouchType.Up) {
      touchType = TouchType.Down;
    }
    if (touchType === TouchType.Down) {
      this.dealTouchDown(event, oriHeight, isResize);
    } else if (touchType === TouchType.Move) {
      if (!this.isGestureRunning) {
        this.dealTouchMove(event, isResize, resizeDirection, scaleValue);
      }
    } else if (touchType === TouchType.Up) {
      // let movePoint = this.dealTouchUp(event, scaleValue);
      // if (movePoint.x === 0 && movePoint.y === 0) {
      //   return;
      // }
      this.reportMsg(isResize);
    } else if (touchType === TouchType.Cancel) {
      HiLog.i(TAG, 'TextEditItem dealTouch Cancel');
      this.touchEndDeal();
    } else {
      HiLog.w(TAG, 'TextEditItem dealTouch fault');
      this.touchEndDeal();
    }
    this.lastTouchType = touchType;
  }

  private dealTouchDown(event: TouchEvent, oriHeight: number, isResize: Boolean) {
    HiLog.i(TAG, 'TextEditItem dealTouch Down');
    this.textInputData.dealDownEvent(event, oriHeight, this.textArea);
    if (isResize) {
      this.textInputData.moveType = TouchMoveType.RESIZE;
    }
    this.textAreaManager.getTextAreaList().forEach(textArea => {
      if (this.textArea.id !== textArea.id) {
        displayOption(textArea, false, false, 0);
      }
    });
  }

  private dealTouchMove(event: TouchEvent, isResize: Boolean,
    resizeDirection: ResizeDirectionEdit, scaleValue: number) {
    /* instrument ignore if */
    if (!this.textArea.isShownBorder) {
      return;
    }
    /* instrument ignore if */
    if (DeviceUtil.isFoldable() && !ScreenManager.getInstance().isDeviceFold() ||
    DeviceUtil.isPad() || DeviceUtil.isPc()) {
      this.isShowInPopup = false;
    }
    displayOption(this.textArea, undefined, false);
    let touchMoveType: TouchMoveType = isResize ? TouchMoveType.RESIZE : TouchMoveType.MOVE;
    this.textInputData.dealMoveEvent(event, touchMoveType, resizeDirection, this.rotateScale, this.paintViewHeight,
      this.textArea);
  }

  private dealTouchUp(event: TouchEvent, scaleValue: number) {
    const previousTextArea: TextAreaInfo = deepCopy(this.textArea);
    HiLog.i(TAG, 'TextEditItem dealTouch Up, angle: %{public}i', this.textInputData.angle);
    this.textArea.angle = this.textInputData.angle;
    this.textCanClickStyle = true;
    this.textAreaManager.flush(this.textArea.id);
    const newPositionX: number =
      this.textInputData.getRealPositionX(this.textArea.localPositionX, this.textArea.width,
        this.paintViewWidth,
        this.rotateScale);
    const newPositionY: number =
      this.textInputData.getRealPositionY(this.textArea.localPositionY, this.textArea.height,
        this.paintViewHeight,
        this.rotateScale);
    if (this.textArea.positionX !== newPositionX || this.textArea.positionY !== newPositionY) {
      HiLog.i(TAG, `update position, positionX:${newPositionX},positionY:${newPositionY}`);
      this.textArea.positionX = newPositionX;
      this.textArea.positionY = newPositionY;
      this.undoRedoManager.push(
        new Operation(Constants.MOVE_TEXTAREA, this.textArea.id, previousTextArea, deepCopy(this.textArea)));
      this.canUndo = this.undoRedoManager.canUndo();
      this.canRedo = this.undoRedoManager.canRedo();
    }
    this.textInputData.dealUpEvent();
    this.touchEndDeal();
    this.rotatePercentage =
      (((this.textArea.width / 2) / (this.textArea.width + this.rotateIconWidth)) * 100).toFixed(1) + '%';
    this.menuPoint = this.textInputData.refreshMenuPosition(this.textArea, this.paintViewWidth, this.paintViewHeight,
      this.textArea.localPositionX, this.textArea.localPositionY, this.textArea.textEditMenuWidth, this.rotateScale,
      this.rotateScale);
    let movePoint = this.textInputData.getPositionOffset(event, scaleValue);
    return movePoint;
  }

  private reportMsg(isResize: Boolean) {
    let msg: Record<string, number | string | boolean> = {};
    if (isResize) {
      msg = {
        'WIDTH': this.textArea.width,
        'HEIGHT': this.textArea.height
      };
    } else {
      msg = {
        'X': this.textInputData.getRealPositionX(this.textArea.localPositionX, this.textArea.width,
          this.paintViewWidth,
          this.rotateScale),
        'Y': this.textInputData.getRealPositionY(this.textArea.localPositionY, this.textArea.height,
          this.paintViewHeight,
          this.rotateScale),
        'INIT_X': this.initPositionX,
        'INIT_Y': this.initPositionY
      };
    }
  }

  private touchEndDeal() {
    this.touchStart = false;
    this.textInputData.moveType = TouchMoveType.DEFAULT;
  }

  /* instrument ignore next */
  private dealTouchRotate(event: TouchEvent) {
    let touchType: TouchType = event.type;
    if (touchType === TouchType.Down) {
      this.textInputData.touchStart(event);
    } else if (touchType === TouchType.Move) {
      this.textInputData.areaRotate(event, this.textArea);
    } else if (touchType === TouchType.Up) {
      HiLog.i(TAG, `TextEditItem dealTouchRotate Up.TextAreaInfo:${this.textArea},`);
    }
  }

  // 左上角缩放图标
  @Builder
  upperLeftZoomIcon() {
    Row()
      .id('text_edit_top_left_corner')
      .width(Constants.RESIZE_ICON_WIDTH * this.textInputData.dpiRatio)
      .height(Constants.RESIZE_ICON_HEIGHT * this.textInputData.dpiRatio)
      .offset({
        top: { value: -Constants.RESIZE_ICON_WIDTH / 2 - 1, unit: LengthUnit.VP },
        start: { value: -Constants.RESIZE_ICON_WIDTH / 2 - 1, unit: LengthUnit.VP },
      })
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        start: { anchor: '__container__', align: HorizontalAlign.Start },
      })
      .responseRegion({
        x: -Constants.RESIZE_ICON_WIDTH,
        y: -Constants.RESIZE_ICON_HEIGHT,
        width: Constants.RESIZE_ICON_WIDTH * this.textInputData.dpiRatio + Constants.RESIZE_ICON_WIDTH * 3,
        height: Constants.RESIZE_ICON_HEIGHT * this.textInputData.dpiRatio + Constants.RESIZE_ICON_HEIGHT * 3,
      })
      .borderRadius(Constants.RESIZE_ICON_HEIGHT / 2)
      .backgroundColor(this.isShowBorder && this.textArea.isShownBorder ? Color.White : Color.Transparent)
      .shadow(this.textArea.editState === 1 && this.isShowBorder && this.textArea.isShownBorder ?
      Constants.borderShadow : { radius: 0 })
      .direction(Direction.Ltr)
      .accessibilityLevel('yes')
      .accessibilityText($r('app.string.upper_left_zoom_imageEdit'))
      .onTouch((event: TouchEvent | undefined) => {
        /* instrument ignore if */
        if (!event) {
          return;
        }
        /* instrument ignore if */
        if (this.keyboardHeight > 0) {
          return;
        }
        event.stopPropagation();
        this.dealTouch(event as TouchEvent, true, ResizeDirectionEdit.TOP_LEFT, this.minHeight);
      })
  }

  // 右上角缩放图标
  @Builder
  upperRightZoomIcon() {
    Row()
      .id('text_edit_top_right_corner')
      .width(Constants.RESIZE_ICON_WIDTH * this.textInputData.dpiRatio)
      .height(Constants.RESIZE_ICON_HEIGHT * this.textInputData.dpiRatio)
      .offset({
        top: { value: -Constants.RESIZE_ICON_WIDTH / 2 - 1, unit: LengthUnit.VP },
        end: { value: -Constants.RESIZE_ICON_WIDTH / 2 - 1, unit: LengthUnit.VP },
      })
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        end: { anchor: '__container__', align: HorizontalAlign.End },
      })
      .responseRegion({
        x: -Constants.RESIZE_ICON_WIDTH,
        y: -Constants.RESIZE_ICON_HEIGHT,
        width: Constants.RESIZE_ICON_WIDTH * this.textInputData.dpiRatio + Constants.RESIZE_ICON_WIDTH * 3,
        height: Constants.RESIZE_ICON_HEIGHT * this.textInputData.dpiRatio + Constants.RESIZE_ICON_HEIGHT * 3,
      })
      .borderRadius(Constants.RESIZE_ICON_HEIGHT / 2 * this.textInputData.dpiRatio)
      .backgroundColor(this.isShowBorder && this.textArea.isShownBorder ? Color.White : Color.Transparent)
      .shadow(this.textArea.editState === 1 && this.isShowBorder && this.textArea.isShownBorder ?
      Constants.borderShadow : { radius: 0 })
      .direction(Direction.Ltr)
      .accessibilityLevel('yes')
      .accessibilityText($r('app.string.upper_right_zoom_imageEdit'))
      .onTouch((event: TouchEvent | undefined) => {
        /* instrument ignore if */
        if (!event) {
          return;
        }
        /* instrument ignore if */
        if (this.keyboardHeight > 0) {
          return;
        }
        event.stopPropagation();
        this.dealTouch(event as TouchEvent, true, ResizeDirectionEdit.TOP_RIGHT, this.minHeight);
      })
  }

  // 右下角缩放图标
  @Builder
  bottomRightZoomIcon() {
    Row()
      .id('text_edit_lower_right_corner')
      .width(Constants.RESIZE_ICON_WIDTH * this.textInputData.dpiRatio)
      .height(Constants.RESIZE_ICON_HEIGHT * this.textInputData.dpiRatio)
      .offset({
        bottom: { value: -Constants.RESIZE_ICON_WIDTH / 2 - 1, unit: LengthUnit.VP },
        end: { value: -Constants.RESIZE_ICON_WIDTH / 2 - 1, unit: LengthUnit.VP },
      })
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        end: { anchor: '__container__', align: HorizontalAlign.End },
      })
      .responseRegion({
        x: -Constants.RESIZE_ICON_WIDTH,
        y: -Constants.RESIZE_ICON_HEIGHT,
        width: Constants.RESIZE_ICON_WIDTH * this.textInputData.dpiRatio + Constants.RESIZE_ICON_WIDTH * 3,
        height: Constants.RESIZE_ICON_HEIGHT * this.textInputData.dpiRatio + Constants.RESIZE_ICON_HEIGHT * 3,
      })
      .borderRadius(Constants.RESIZE_ICON_HEIGHT / 2)
      .backgroundColor(this.isShowBorder && this.textArea.isShownBorder ? Color.White : Color.Transparent)
      .shadow(this.textArea.editState === 1 && this.isShowBorder && this.textArea.isShownBorder ?
      Constants.borderShadow : { radius: 0 })
      .direction(Direction.Ltr)
      .accessibilityLevel('yes')
      .accessibilityText($r('app.string.bottom_right_zoom_imageEdit'))
      .onTouch((event: TouchEvent | undefined) => {
        /* instrument ignore if */
        if (!event) {
          return;
        }
        /* instrument ignore if */
        if (this.keyboardHeight > 0) {
          return;
        }
        event.stopPropagation();
        this.dealTouch(event as TouchEvent, true, ResizeDirectionEdit.BOTTOM_RIGHT, this.minHeight);
      })
  }

  // 左下角缩放图标
  @Builder
  bottomLeftZoomIcon() {
    Row()
      .id('text_edit_lower_left_corner')
      .width(Constants.RESIZE_ICON_WIDTH * this.textInputData.dpiRatio)
      .height(Constants.RESIZE_ICON_HEIGHT * this.textInputData.dpiRatio)
      .offset({
        bottom: { value: -Constants.RESIZE_ICON_WIDTH / 2 - 1, unit: LengthUnit.VP },
        start: { value: -Constants.RESIZE_ICON_WIDTH / 2 - 1, unit: LengthUnit.VP },
      })
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        start: { anchor: '__container__', align: HorizontalAlign.Start },
      })
      .responseRegion({
        x: -Constants.RESIZE_ICON_WIDTH,
        y: -Constants.RESIZE_ICON_HEIGHT,
        width: Constants.RESIZE_ICON_WIDTH * this.textInputData.dpiRatio + Constants.RESIZE_ICON_WIDTH * 3,
        height: Constants.RESIZE_ICON_HEIGHT * this.textInputData.dpiRatio + Constants.RESIZE_ICON_HEIGHT * 3,
      })
      .borderRadius(Constants.RESIZE_ICON_HEIGHT / 2)
      .backgroundColor(this.isShowBorder && this.textArea.isShownBorder ? Color.White : Color.Transparent)
      .shadow(this.textArea.editState === 1 && this.isShowBorder && this.textArea.isShownBorder ?
      Constants.borderShadow : { radius: 0 })
      .direction(Direction.Ltr)
      .accessibilityLevel('yes')
      .accessibilityText($r('app.string.bottom_left_zoom_imageEdit'))
      .onTouch((event: TouchEvent | undefined) => {
        /* instrument ignore if */
        if (!event) {
          return;
        }
        /* instrument ignore if */
        if (this.keyboardHeight > 0) {
          return;
        }
        event.stopPropagation();
        this.dealTouch(event as TouchEvent, true, ResizeDirectionEdit.BOTTOM_LEFT, this.minHeight);
      })
  }

  // 旋转
  /* instrument ignore next */
  @Builder
  rotateTool() {
    Stack() {
      Row() {

      }
      .height(2)
      .width(15)
      .shadow(Constants.borderShadow)
      .backgroundColor(Color.White)
      .position({
        x: -2,
        y: 12,
      })

      Row() {
        SymbolGlyph($r('sys.symbol.arrow_2_circlepath'))
          .fontSize('14vp')
      }
      .align(Alignment.Center)
      .justifyContent(FlexAlign.Center)
      .width(24)
      .height(24)
      .borderRadius(45)
      .shadow(Constants.borderShadow)
      .accessibilityLevel('yes')
      .accessibilityText(getContext()
        .resourceManager
        .getStringSync($r('app.string.rotate_scope_imageEdit'),
          getContext()
            .resourceManager
            .getPluralStringValueSync($r('app.plural.rotate_angle_imageEdit'), this.textInputData.angle), 0, 360))
      .backgroundColor(Color.White)
      .position({
        x: 12,
      })
    }
    .position({
      x: this.textArea.width + Constants.SHADOW_IMAGE_BORDER_WIDTH / 2 + 2,
      y: this.textArea.height / 2 - Constants.DASHED_EFFECT,
    })
    .width(this.rotateIconWidth)
    .height(this.rotateIconHeight)
    .draggable(false)
    .focusable(true)
    .responseRegion({
      x: -Constants.RESIZE_ICON_WIDTH,
      y: -Constants.RESIZE_ICON_HEIGHT,
      width: this.rotateIconWidth + Constants.RESIZE_ICON_WIDTH * 2,
      height: this.rotateIconHeight + Constants.RESIZE_ICON_HEIGHT * 2,
    })
    .onTouch(this.textRotateTouch)
    .visibility(this.isShowBorder && this.textArea.isShownBorder ? Visibility.Visible : Visibility.Hidden)
  }

  private textRotateTouch = (event: TouchEvent | undefined) => {
    if (!event) {
      return;
    }
    if (this.keyboardHeight > 0) {
      return;
    }
    let type = event.type;
    if (type === TouchType.Down) {
      HiLog.i(TAG, 'rotate down');
      displayOption(this.textArea, true, false);
    }
    if (type === TouchType.Up) {
      HiLog.i(TAG, 'rotate up');
      const previousTextArea: TextAreaInfo = deepCopy(this.textArea);
      displayOption(this.textArea, true, true, 1);
      this.textCanClickStyle = true;
      this.isRotate = false;
      this.textArea.angle = this.textInputData.angle;
      this.undoRedoManager.push(
        new Operation(Constants.ROTATE, this.textArea.id, previousTextArea, deepCopy(this.textArea)));
      this.canUndo = this.undoRedoManager.canUndo();
      this.canRedo = this.undoRedoManager.canRedo();
      this.menuPoint =
        this.textInputData.refreshMenuPosition(this.textArea, this.paintViewWidth, this.paintViewHeight,
          this.textArea.localPositionX, this.textArea.localPositionY, this.textArea.textEditMenuWidth,
          this.rotateScale, this.rotateScale);
      HiLog.i(TAG, `TextEditItem textRotate angle:${this.textInputData.angle}`);
      if (this.textInputData.angle >= 90 - Constants.ADSORPTION_ANGLE &&
        this.textInputData.angle <= 90 + Constants.ADSORPTION_ANGLE) {
        this.textInputData.angle = 90;
      }
      if ((this.textInputData.angle >= 360 - Constants.ADSORPTION_ANGLE && this.textInputData.angle < 360) ||
        (this.textInputData.angle >= 0 && this.textInputData.angle < Constants.ADSORPTION_ANGLE)) {
        this.textInputData.angle = 0;
      }
      if (this.textInputData.angle >= 180 - Constants.ADSORPTION_ANGLE &&
        this.textInputData.angle <= 180 + Constants.ADSORPTION_ANGLE) {
        this.textInputData.angle = 180;
      }
      if (this.textInputData.angle >= 270 - Constants.ADSORPTION_ANGLE &&
        this.textInputData.angle <= 270 + Constants.ADSORPTION_ANGLE) {
        this.textInputData.angle = 270;
      }
      let msg: Record<string, number | string | boolean> = {
        'ANGLES': this.textInputData.angle
      };
      let resMgr: resourceManager.ResourceManager = getContext().resourceManager;
      let textAnnounced: string =
        resMgr.getPluralStringValueSync($r('app.plural.rotate_broadcast_imageEdit'), this.textInputData.angle);
      this.sendAccessibilityEvent(textAnnounced);
      return;
    }
    this.isRotate = true;
  }

  private sendAccessibilityEvent(textAnnounced: string): void {
    let eventInfo: accessibility.EventInfo = ({
      type: 'announceForAccessibility',
      bundleName: 'com.ohos.photos',
      triggerAction: 'common',
      textAnnouncedForAccessibility: textAnnounced,
    });
    accessibility.sendAccessibilityEvent(eventInfo).then(() => {
      HiLog.i(TAG, `sendAccessibilityEvent, Text=${textAnnounced}`);
    });
  }

  @Builder
  divider() {
    Divider()
      .padding({ left: 16, right: 16 })
      .strokeWidth('1px')
      .width('100%')
      .color($r('sys.color.ohos_id_color_list_separator'))
  }

  closeFontStyleCallback() {
    this.isShowInPopup = false;
    this.textAreaManager.getTextAreaList().forEach(textArea => {
      /* instrument ignore if */
      if (textArea.editState === 1) {
        textArea.isShownMenu = true;
        this.textCanClickStyle = true;
      }
    })
  }

  @Builder
  fontStyleTitleAndClose() {
    FontStyleTitleAndClose({
      closeFontStyleCallback: () => {
        this.closeFontStyleCallback();
      }
    })
      .width('100%')
  }

  @Builder
  broderBuilder() {
    RelativeContainer() {
      Row()
        .width(Constants.DEFAULT_TEXTAREA_BORDER_WIDTH)
        .height(this.textArea.height)
        .shadow(Constants.borderShadow)
        .direction(Direction.Ltr)
        .offset({ start: { value: -2, unit: LengthUnit.VP } })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          start: { anchor: '__container__', align: HorizontalAlign.Start },
        })

      Row()
        .width(Constants.DEFAULT_TEXTAREA_BORDER_WIDTH)
        .height(this.textArea.height)
        .shadow(Constants.borderShadow)
        .direction(Direction.Ltr)
        .offset({ start: { value: 2, unit: LengthUnit.VP } })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          end: { anchor: '__container__', align: HorizontalAlign.End },
        })

      Row()
        .width(this.textArea.width)
        .height(Constants.DEFAULT_TEXTAREA_BORDER_WIDTH)
        .shadow(Constants.borderShadow)
        .direction(Direction.Ltr)
        .offset({ top: { value: -2, unit: LengthUnit.VP } })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          start: { anchor: '__container__', align: HorizontalAlign.Start },
        })

      Row()
        .width(this.textArea.width)
        .height(Constants.DEFAULT_TEXTAREA_BORDER_WIDTH)
        .shadow(Constants.borderShadow)
        .direction(Direction.Ltr)
        .offset({ top: { value: 2, unit: LengthUnit.VP } })
        .alignRules({
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          end: { anchor: '__container__', align: HorizontalAlign.End },
        })

      this.upperLeftZoomIcon();
      this.upperRightZoomIcon();
      this.bottomRightZoomIcon();
      this.bottomLeftZoomIcon();
    }
    .zIndex(this.isAccessibilityMode ? 1 : 0)
    .direction(Direction.Ltr)
    .width(this.textArea.width)
    .height(this.textArea.height)
    .position({
      x: Constants.LEFT_TOP_POSITION,
      y: Constants.LEFT_TOP_POSITION,
    })
    .border({
      width: Constants.DEFAULT_TEXTAREA_BORDER_WIDTH,
      color: this.isShowBorder && this.textArea.isShownBorder ? Color.White : Color.Transparent,
      style: BorderStyle.Dashed,
      dashGap: {
        left: 2,
        top: 2,
        right: 2,
        bottom: 2,
      }
    })
    .visibility(this.isShowBorder && this.textArea.isShownBorder ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  emptyMenu() {
    Column() {

    }
  }

  getInputValue(): string {
    let inputResult = '';
    let getSpans = this.textArea.richEditorController.getSpans()
    getSpans.forEach(index => {
      let spanTextValue: RichEditorTextSpanResult = index as RichEditorTextSpanResult;
      /* instrument ignore if */
      if (spanTextValue.value !== undefined) {
        inputResult = inputResult + spanTextValue.value;
      } else {
        HiLog.e(TAG, 'unexpected spanTextValue');
      }
    });
    return inputResult;
  }

  @Builder
  richEditorComponent() {
    RichEditor({
      controller: this.textArea.richEditorController,
    })
      .placeholder(this.textArea.content ? undefined : $r('app.string.edit_text_imageEdit'), {
        font: {
          size: vp2px(this.textArea.fontSize) + 'px',
        },
        fontColor: this.textArea.getShowColor(),
      })
      .constraintSize({
        maxWidth: this.textInputData.getTextMaxWidth(),
        minWidth: (this.textInputData.isNewTextView ?
        this.textArea.width : this.textInputData.getTextMinWidth()),
        minHeight: this.textArea.height,
        maxHeight: this.textInputData.getTextMaxHeight(),
      })
      .id(this.textArea.id)
      .barState(BarState.Off)
      .width(this.textArea.width)
      .copyOptions(CopyOptions.None)
      .backgroundColor(this.textArea.isBackground ? this.textArea.fontColor : Color.Transparent)
      .borderRadius(8)
      .focusable(this.textArea.isShownBorder)
      .enablePreviewText(false)
      .accessibilityDescription(' ')
      .accessibilityLevel('yes')
      .accessibilityText(UiUtil.getResourceString($r('app.string.text_box_imageEdit')) +
      UiUtil.getResourceString($r('app.string.double_click_edit_imageEdit')))
      .responseRegion({
        x: Constants.RESIZE_ICON_WIDTH,
        y: Constants.RESIZE_ICON_WIDTH,
        width: this.textArea.width - Constants.RESIZE_ICON_WIDTH * 2,
        height: this.textArea.height - Constants.RESIZE_ICON_WIDTH * 2,
      })
      .bindSelectionMenu(RichEditorSpanType.TEXT, this.emptyMenu(), ResponseType.LongPress, {
        onAppear: () => {
          this.textArea.richEditorController.closeSelectionMenu();
        }
      })
      .onDeleteComplete(() => {
        let getSpans = this.textArea.richEditorController.getSpans({ start: 0 })
        if (getSpans.length == 0) {
          this.textArea.content = '';
        } else {
          this.textArea.content = this.getInputValue();
        }
        let caretOffset = this.textArea.richEditorController.getCaretOffset();
        this.changeTextSpan(this.textArea.content)
        this.textArea.richEditorController.setCaretOffset(caretOffset)
      })
      .onIMEInputComplete((value: RichEditorTextSpanResult) => {
        this.textCanClickStyle = true;
        if (this.keyboardHeight === 0) {
          HiLog.i(TAG, `TextEditItem onIMEInputComplete value:${value.value}`);
          if (!this.textArea) {
            return;
          }
          let caretOffset = this.textArea.richEditorController.getCaretOffset();
          let inputResult = this.getInputValue();
          this.textArea.content = inputResult;
          this.changeTextSpan(inputResult)
          this.textArea.richEditorController.setCaretOffset(caretOffset)
        }
      })
      .onReady(() => {
        HiLog.i(TAG, 'getSmallWindowMode: %{public}s', ScreenManager.getInstance().getSmallWindowMode());
        this.menuPoint =
          this.textInputData.refreshMenuPosition(this.textArea, this.paintViewWidth, this.paintViewHeight,
            this.textArea.localPositionX, this.textArea.localPositionY, this.textArea.textEditMenuWidth,
            this.rotateScale, this.rotateScale);
        /* instrument ignore if */
        if (ScreenManager.getInstance().isUIExtensionEnv() && this.textArea.content === '') {
          HiLog.i(TAG, 'isUIExtensionEnv onReady return');
          return;
        }
        this.changeTextSpan(this.textArea.content === '' ?
        UiUtil.getResourceString($r('app.string.edit_text_imageEdit')) : this.textArea.content);
      })
      .focusable(ScreenManager.getInstance().isUIExtensionEnv() && this.textArea.isShownBorder)
      .onFocus((): void => {
        HiLog.i(TAG, 'TextEditItem RichEditor onFocus');
        this.textArea.editState = 1;
      })
      .onBlur(() => {
        HiLog.i(TAG, 'TextEditItem RichEditor onBlur');
      })
      .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
        this.textInputData.height = Number(newValue.height);
      })
      .onClick((): void => {
        HiLog.i(TAG, 'TextEditItem onClick');
        if (!ScreenManager.getInstance().isUIExtensionEnv() && this.isPullUpTextInput) {
          this.textInputAreaHide = !this.textInputAreaHide;
        }
        App.getInstance().myEditor().isInTextArea = true;
        displayOption(this.textArea, true, true, 1);
        this.textCanClickStyle = true;
        this.isShowInPopup = false;
        /* instrument ignore if */
        if (this.keyboardHeight > 0) {
          HiLog.i(TAG, 'TextEditItem textArea focusShift');
          focusControl.requestFocus('text_edit_focus_shift_tab');
        }
        this.isPullUpTextInput = true;
      }, 1)
      .padding({
        top: DeviceUtil.isPad() ? Constants.PADDING_TOP_PAD : Constants.PADDING_TOP,
      })
      .position({
        x: Constants.LEFT_TOP_POSITION,
        y: Constants.LEFT_TOP_POSITION,
      })
  }

  @Builder
  richEditorBuilder() {
    Column() {
      Stack() {
        this.rotateTool();
        this.broderBuilder();
        this.richEditorComponent()
      }
      .width('100%')
      .height('100%')
    }
    .enabled(this.asset.textEdit().isInTextTab && !this.textInputAreaHide)
    .direction(Direction.Ltr)
    .position({
      x: Constants.DEFAULT_TEXTAREA_MARGIN_LEFT - Constants.SHADOW_IMAGE_EFFECT_WIDTH,
      y: -Constants.SHADOW_IMAGE_EFFECT_WIDTH,
    })
    .width('100%')
    .height('100%')
    .rotate({
      z: 1,
      centerX: this.rotatePercentage,
      centerY: '50%',
      angle: this.textInputData.angle,
    })
    .responseRegion({
      x: 0,
      y: 0,
      width: this.textArea.width + this.rotateIconWidth + Constants.RESIZE_ICON_WIDTH * 3,
      height: this.textArea.height + this.rotateIconHeight + Constants.RESIZE_ICON_HEIGHT,
    })
    .onTouch((event: TouchEvent | undefined) => {
      this.isPullUpTextInput = this.textCanClickStyle;
      /* instrument ignore if */
      if (!event || !App.getInstance().myEditor().isInTextArea) {
        return;
      }
      /* instrument ignore if */
      if (this.keyboardHeight > 0) {
        return;
      }
      this.isShowInPopup = false;
      if (event.type == TouchType.Up) {
        this.textArea.angle = this.textInputData.angle;
        this.menuPoint =
          this.textInputData.refreshMenuPosition(this.textArea, this.paintViewWidth, this.paintViewHeight,
            this.textArea.localPositionX, this.textArea.localPositionY, this.textArea.textEditMenuWidth,
            this.rotateScale, this.rotateScale);
      }
      /* instrument ignore if */
      if (this.isRotate) {
        this.dealTouchRotate(event);
        event.stopPropagation();
      } else {
        this.dealTouch(event as TouchEvent, false, ResizeDirectionEdit.TOP_LEFT, this.minHeight);
      }
    });
  }

  build() {
    Stack() {
      Column() {
        TextEditMenu({
          editCallback: this.editCallback,
          modifyStyleCallback: this.modifyStyleCallback,
          deleteCallback: this.deleteCallback,
          textArea: this.textArea,
          copyStyleCallback: this.copyStyleCallback,
          menuWidth: this.menuWidth,
        })
          .visibility(this.isShowBorder && this.textArea.isShownMenu ? Visibility.Visible : Visibility.Hidden)
      }
      .width(this.textArea.width + this.rotateIconWidth)
      .visibility(this.isShowBorder && this.textArea.isShownMenu ? Visibility.Visible : Visibility.Hidden)
      .alignItems(HorizontalAlign.Center)
      .hitTestBehavior(HitTestMode.Transparent)
      .position({
        x: this.menuPoint.x,
        y: this.textInputData.isOuterPage ?
          this.menuPoint.y + this.textArea.height + Constants.DEFAULT_TEXTAREA_TOP_MENU_MARGIN :
          -this.menuPoint.y - Constants.DEFAULT_TEXTAREA_TOP_MENU_HEIGHT - Constants.DEFAULT_TEXTAREA_TOP_MENU_MARGIN
      })

      this.richEditorBuilder();
    }
    .zIndex(this.textArea.isShownBorder ? 10 : 1)
    .width(this.textArea.width + this.rotateIconWidth)
    .height(this.textArea.height + Constants.SHADOW_IMAGE_BORDER_WIDTH)
    .position({
      x: this.textInputData.getRealPositionX(this.textArea.localPositionX, this.textArea.width,
        this.paintViewWidth,
        1),
      y: this.textInputData.getRealPositionY(this.textArea.localPositionY, this.textArea.height,
        this.paintViewHeight,
        1)
    })
  }
}