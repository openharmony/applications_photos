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
import { HiLog } from '../../../../common/util/HiLog';
import { App, BaseEditor } from '../../../App';
import { ScreenManager } from '../../../../common/util/ScreenManager';
import {
  DEVICE_FOLD_STATUS,
  SCREEN_ORIENTATION_PORTRAIT,
  CURRENT_LANGUAGE,
  WIN_HEIGHT_KEY,
  WIN_WIDTH_KEY,
  HOT_SPOT_HEIGHT,
  HOT_SPOT_WIDTH
} from '../../../../common/const';
import { Constants } from '../util/Const';
import { deepCopy, displayOption, generateUniqueId, TextAreaInfo } from '../model/TextAreaInfo';
import { TextAreaManager } from '../viewModel/TabTextAreaManager';
import { UndoRedoManager } from '../viewModel/TabUndoRedoManager';
import { RectValue, SwitchAnimator } from '../../../EditorSDK';
import { TextEditPage } from './TextEditPage';
import { FontStylesBuilder } from './FontStylesBuilder';
import { Operation } from '../model/Operation';
import { ScaleValues } from '../model/ScaleValues';
import { Asset } from '../../../Asset';
import { UiUtil } from '../../../../common/util/UiUtil';
import { ScreenClass } from '../../../../service/App';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { calculateObjectFit } from '../../mosaic/GestureController';

const TAG = 'TextEditView';

@Component
export struct TextEditView {
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State asset: Asset = App.getInstance().myEditor().asset;
  @State @Watch('refreshWinSize') screenClass: ScreenClass = App.getInstance().screenClass;
  @State isShowImage: boolean = false; // 是否展示
  @State operationRect: RectValue = new RectValue(0, 0, 0, 0); // vp 实际可操作区域
  @Provide rotateScale: number = 1;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) @Watch('refreshWinSize') isScreenPortrait: boolean =
    ScreenManager.getInstance().isScreenPortrait();
  @StorageProp(DEVICE_FOLD_STATUS) @Watch('refreshWinSize') isFold: boolean =
    ScreenManager.getInstance().isDeviceFold();
  @StorageProp(WIN_WIDTH_KEY) @Watch('refreshWinSize') winWidth: number = ScreenManager.getInstance().width;
  @StorageProp(WIN_HEIGHT_KEY) @Watch('refreshWinSize') winHeight: number = ScreenManager.getInstance().height;
  @StorageLink(CURRENT_LANGUAGE) @Watch('refreshWinSize') currentLanguage: string | undefined = undefined;
  @State updateInterval: boolean = false;
  @State imagePositionX: number = 0;
  @State imagePositionY: number = 0;
  @State imageViewWidth: number = 0;
  @State imageViewHeight: number = 0;
  @Link currentFontColor: Color | string | Resource;
  @Link currentFontSize: number;
  @Link isFontSizeChange: boolean;
  @Link textInputAreaHide: boolean;
  @Link keyboardHeight: number;
  @Link isShowBorder: boolean;
  @Link previousTextArea: TextAreaInfo | undefined;
  @Link realTimeContent: string | undefined;
  @State isShow: boolean = false;
  @State isShowTextAnnotationPop: boolean = false;
  @State scaleX: number = 1;
  @State scaleY: number = 1;
  @Link isShowInPopup: boolean;
  @Link textCanClickStyle: boolean;
  @Link textCanUndo: boolean;
  @Link textCanRedo: boolean;
  private timer: number = -1;
  private textAreaManager: TextAreaManager = TextAreaManager.getInstance();
  private undoRedoManager: UndoRedoManager = UndoRedoManager.getInstance();
  public lastPositionX: number = 0;
  public lastPositionY: number = 0;
  public isTimeShortPinch = false;
  public lastWidth: number = Constants.DEFAULT_TEXTAREA_WIDTH;
  public lastHeight: number = Constants.DEFAULT_TEXTAREA_HEIGHT;
  public lastFontSize: number = this.currentFontSize;
  @State isGestureRunning: boolean = false;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private canvasSize: Size = { width: 0, height: 0, };

  aboutToAppear() {
    HiLog.i(TAG, 'TextEditView aboutToAppear');
    this.appBroadCast.on('initTextEditView', this.initData);
    this.appBroadCast.on('switchTab', this.switchTab);
    this.appBroadCast.on('clickTextInputMask', this.clickTextMask);
    this.appBroadCast.on('clearText', this.clearText);
  }

  aboutToDisappear() {
    HiLog.i(TAG, 'TextEditView aboutToDisappear');
    this.appBroadCast.off('initTextEditView', this.initData);
    this.appBroadCast.off('switchTab', this.switchTab);
    this.appBroadCast.off('clickTextInputMask', this.clickTextMask);
    this.appBroadCast.off('clearText', this.clearText);
    this.isShowInPopup = false;
    this.isShow = false
  }

  clearText = () => {
    HiLog.i(TAG, 'clearText after enter');
    this.textAreaManager.clear();
    this.editor.isComposing = false;
  }
  private refreshTimer: number = -1;

  refreshWinSize() {
    clearTimeout(this.refreshTimer);
    this.refreshTimer = setTimeout(() => {
      HiLog.i(TAG, 'refreshWinSize');
      if (!this.imageViewWidth) {
        return;
      }
      this.updateInterval = false;
      this.getPreviewOperationRect();
      const output = calculateObjectFit({
        imgWidth: this.imageViewWidth,
        imgHeight: this.imageViewHeight,
        containerWidth: this.operationRect.width,
        containerHeight: this.operationRect.height,
      });
      const imageRect = new RectValue(output.x, output.y, output.width, output.height);
      HiLog.i(TAG, `updatePageSize rotateScale = ${this.rotateScale}`);
      this.imagePositionX = imageRect.x;
      this.imagePositionY = imageRect.y;
      this.rotateScale = this.canvasSize.width === 0 ? 1 : imageRect.width / this.canvasSize.width;
    }, 50);
  }

  build() {
    if (this.isShowImage) {
      Stack() {
        this.TabTextEditPage();
        this.FontStylesBuilder();
      }
      .width(this.operationRect.width)
      .height(this.operationRect.height)
      .visibility(this.asset.textEdit().isComparing ? Visibility.Hidden : Visibility.Visible)
      .position({
        x: this.operationRect.x,
        y: this.operationRect.y,
      })
    }
  }

  // 文本Tab初始化
  initData = (interval: number) => {
    this.editor.getExportRect(this.operationRectInit);
  }

  switchTab = (interval: number, onlyHide = false) => {
    this.updateInterval = true;
    /* instrument ignore if */
    if (onlyHide) {
      return;
    }
    clearTimeout(this.timer);
    this.timer = setTimeout(() => {
      HiLog.i(TAG, 'start deformationOperation');
      this.isShowImage = true;
    }, interval);
  }
  private getPreviewOperationRect = () => {
    const cropRect =
      SwitchAnimator.getPreviewPosition({
        width: ScreenManager.getInstance().width,
        height: ScreenManager.getInstance().height,
      }, this.isScreenPortrait);
    const mirrorOffsetx = vp2px(UiUtil.getPreviewRectOffset());
    cropRect.x += mirrorOffsetx;
    this.operationRect =
      new RectValue(
        px2vp(cropRect.x) - HOT_SPOT_WIDTH,
        px2vp(cropRect.y) - HOT_SPOT_HEIGHT,
        px2vp(cropRect.width) + HOT_SPOT_WIDTH * 2,
        px2vp(cropRect.height) + HOT_SPOT_HEIGHT * 2
      );
  };
  operationRectInit = (width: number, height: number) => {
    if (width === 0 || height === 0 || this.asset.textEdit().operationRectInited) {
      HiLog.e(TAG, `text init error w=${width} h=${height} inited=${this.asset.textEdit().operationRectInited}`);
      return;
    }
    HiLog.e(TAG, `text operationRectInit`);
    this.isShowImage = true;
    this.rotateScale = 1;
    this.asset.textEdit().operationRectInited = true;
    this.updateInterval = false;
    this.getPreviewOperationRect();
    const output = calculateObjectFit({
      imgWidth: width,
      imgHeight: height,
      containerWidth: this.operationRect.width,
      containerHeight: this.operationRect.height,
    });
    const imageRect = new RectValue(output.x, output.y, output.width, output.height);
    this.imageViewWidth = imageRect.width;
    this.imageViewHeight = imageRect.height;
    this.imagePositionX = imageRect.x;
    this.imagePositionY = imageRect.y;
    this.asset.textEdit().textRect = imageRect;
    this.textAreaManager.setCurrentWidth(this.operationRect.width);
    this.textAreaManager.setCurrentHeight(this.operationRect.height);
    HiLog.i(TAG, `text init rect ${JSON.stringify(imageRect)}`);
    this.canvasSize = {
      width: imageRect.width,
      height: imageRect.height,
    };
  };

  onPinGestureEnd() {
    let textArea = this.textAreaManager.getEditingTextArea();
    /* instrument ignore if */
    if (!textArea) {
      return
    }
    this.lastPositionX = textArea.localPositionX;
    this.lastPositionY = textArea.localPositionY;
    this.lastWidth = textArea.width;
    this.lastHeight = textArea.height;
    this.lastFontSize = this.currentFontSize;
    HiLog.i(TAG, `onPinGestureEnd${this.toString()}`);
  }

  onPinchGestureUpdate(event: GestureEvent | undefined) {
    HiLog.i(TAG, `gesture PinchGesture onPinchGestureUpdate`);
    /* instrument ignore if */
    if (this.isTimeShortPinch) {
      return;
    }
    let textArea = this.textAreaManager.getEditingTextArea();
    /* instrument ignore if */
    if (!textArea) {
      return
    }
    this.isTimeShortPinch = true;
    setTimeout((): void => {
      this.isTimeShortPinch = false;
    }, 13)
    const MAGNIFY_DILUTION_TIME = 0.95;
    const SHRINK_DILUTION_TIME = 0.95;
    // 缩放系数进行稀释，避免每帧放大过多距离导致剧烈抖动
    const scale: number = event?.scale ?? 0;
    /* instrument ignore next */
    let scaleTime = scale > 1 ? ((scale - 1) * MAGNIFY_DILUTION_TIME + 1) : (1 - (1 - scale) * SHRINK_DILUTION_TIME);
    /* instrument ignore if */
    if (this.lastWidth * scaleTime <= Constants.DEFAULT_TEXTAREA_WIDTH ||
      this.lastHeight * scaleTime <= Constants.DEFAULT_TEXTAREA_HEIGHT) {
      return;
    }
    this.currentFontSize = Math.min(
      Math.max(this.lastFontSize * scaleTime, Constants.MIN_FONT_SIZE), Constants.MAX_FONT_SIZE);
    textArea.fontSize = this.currentFontSize;
    textArea.width = this.lastWidth * scaleTime;
    textArea.height = this.lastHeight * scaleTime;
    textArea.localPositionX = this.lastPositionX - (textArea.width - this.lastWidth) / 2;
    textArea.localPositionY = this.lastPositionY - (textArea.height - this.lastHeight) / 2;
  }

  @Builder
  GesturePage() {
    Column() {
    }
    .width('100%')
    .height('100%')
    .hitTestBehavior(HitTestMode.Transparent)
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        // 在组件上绑定捏合手势
        PinchGesture({ fingers: 2 })
          .onActionStart((event: GestureEvent | undefined) => {
            HiLog.i(TAG, `gesture PinchGesture onActionStart`);
            let textArea = this.textAreaManager.getEditingTextArea();
            if (!textArea) {
              return
            }
            this.isGestureRunning = true;
            this.lastPositionX = textArea.localPositionX;
            this.lastPositionY = textArea.localPositionY;
            this.lastWidth = textArea.width;
            this.lastHeight = textArea.height;
            this.lastFontSize = this.currentFontSize;
          })
          .onActionUpdate((event: GestureEvent | undefined) => {
            this.onPinchGestureUpdate(event);
          })
          .onActionEnd(() => {
            this.onPinGestureEnd();
            this.isGestureRunning = false;
          })
          .onActionCancel(() => {
            HiLog.i(TAG, 'gesture PinchGesture onActionCancel');
            this.isGestureRunning = false;
          })
      )
    )
  }

  @Builder
  ClickPage() {
    Column()
      .id('textedit_ClickImage')
      .position({
        x: -this.imagePositionX,
        y: 0,
      })
      .width(this.operationRect.width)
      .height(this.operationRect.height)
      .visibility(this.asset.textEdit().isInTextTab && !this.textInputAreaHide ? Visibility.Visible : Visibility.Hidden)
      .onClick(() => {
        HiLog.i(TAG, 'clickPage onClick');
        this.editor.isInTextArea = false;
        this.textCanClickStyle = false;
        this.isShowInPopup = false;
        this.textAreaManager.flush('');
      })
      .accessibilityLevel('no')
      .focusable(false)
  }

  @Builder
  TabTextEditPage() {
    Stack() {
      this.ClickPage();
      TextEditPage({
        imageViewWidth: this.imageViewWidth,
        imageViewHeight: this.imageViewHeight,
        imagePostionX: this.imagePositionX,
        imagePostionY: this.imagePositionY,
        portraitScale: new ScaleValues(this.scaleX, this.scaleY),
        canUndo: this.textCanUndo,
        canRedo: this.textCanRedo,
        isShowInPopup: this.isShowInPopup,
        textCanClickStyle: this.textCanClickStyle,
        textInputAreaHide: this.textInputAreaHide,
        keyboardHeight: this.keyboardHeight,
        isShowBorder: this.isShowBorder,
        currentFontColor: this.currentFontColor,
        currentFontSize: this.currentFontSize,
        isFontSizeChange: this.isFontSizeChange,
        foldStatus: false,
        isGestureRunning: this.isGestureRunning,
      })
        .scale({ x: this.rotateScale, y: this.rotateScale })
        .id('textedit_textEditPage')
        .width(this.imageViewWidth)
        .height(this.imageViewHeight)
        .clip(true)
        .visibility(this.updateInterval || this.editor.stylusMode ?
        Visibility.Hidden : Visibility.Visible)
        .hitTestBehavior(HitTestMode.None)

      this.GesturePage();
    }
    .position({
      x: this.imagePositionX,
      y: this.imagePositionY,
    })
    .width(this.imageViewWidth * this.rotateScale)
    .height(this.imageViewHeight * this.rotateScale)
  }

  @Builder
  FontStylesBuilder() {
    FontStylesBuilder({
      isShowInPopup: this.isShowInPopup,
      isShow: this.isShow,
      currentFontColor: this.currentFontColor,
      currentFontSize: this.currentFontSize,
      canUndo: this.textCanUndo,
      canRedo: this.textCanRedo,
      isFontSizeChange: this.isFontSizeChange,
      textCanClickStyle: this.textCanClickStyle,
    })
      .id('textedit_fontStylesBuilder')
  }

  public clickTextMask = () => {
    HiLog.i(TAG, 'clickTextMask');
    this.editor.isInTextArea = false;
    this.textAreaManager.getTextAreaList().forEach((textArea: TextAreaInfo) => {
      if (textArea.editState === 1 && this.previousTextArea !== undefined) {
        /* instrument ignore else */
        if (this.previousTextArea.id === textArea.id) {
          this.undoRedoManager.push(
            new Operation(Constants.UPDATE_CONTENT, textArea.id, this.previousTextArea, deepCopy(textArea)));
          this.textCanUndo = this.undoRedoManager.canUndo();
          this.textCanRedo = this.undoRedoManager.canRedo();
        } else {
          HiLog.e(TAG, 'unexpected match');
        }
      }
    });
  }
}