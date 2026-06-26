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
import { LengthMetrics, window } from '@kit.ArkUI';
import { UiUtil } from '../../../../common/util/UiUtil';
import { BusinessError } from '@kit.BasicServicesKit';
import { ScreenManager } from '../../../../common/util/ScreenManager';
import { Constants } from '../util/Const';
import { deepCopy, displayOption, TextAreaInfo } from '../model/TextAreaInfo';
import { TextAreaManager } from '../viewModel/TabTextAreaManager';
import { UndoRedoManager } from '../viewModel/TabUndoRedoManager';
import { Operation } from '../model/Operation';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { SCREEN_ORIENTATION_PORTRAIT, WIN_WIDTH_KEY } from '../../../../common/const';
import { RichEditorHelper } from '../util/RichEditorHelper';
import { DeviceUtil } from '../../../../common/util/DeviceUtil';
import { App, ScreenClass } from '../../../App';
import { inputMethod } from '@kit.IMEKit';

const TAG = 'TextInputEditItem';

@Extend(SymbolGlyph)
function symbolGlyph() {
  .fontSize(`${vp2px(24)}px`)
  .height(24)
  .width(24)
  .fontColor(['#FFFFFF'])
}

/**
 * 文本标注底部输入框
 */
@Component
export struct TextInputEditItem {
  @Link keyboardHeight: number;
  private navHeight: number = 0;
  @State inputBoxHeight: number = 0;
  private lastWindow?: window.Window;
  private keyboardHeightChangeCallback?: (size: number) => void;
  private avoidAreaChangeCallback?: (options: window.AvoidAreaOptions) => void;
  @Link @Watch('currentFontColorChange') currentFontColor: Color | string | Resource;
  @Link @Watch('currentFontSizeChange') currentFontSize: number;
  @Link isFontSizeChange: boolean;
  @Link textCanClickStyle: boolean;
  @State displayContent: string = UiUtil.getResourceString($r('app.string.edit_text_imageEdit'));
  @State textInputAreaOffset: number = 0;
  @State textInputAreaEnd: number = 0;
  @State textLength: number = 0;
  @State start: number = 0;
  @State end: number = 0;
  @State textPaddingLeftAndRight: number =
    ScreenManager.getInstance().updateEditorPageGridPaddingLeftAndRight();
  @State screenClass: ScreenClass = App.getInstance().screenClass;
  @Link @Watch('textInputAreaHideChange') textInputAreaHide: boolean;
  @Link canUndo: boolean;
  @Link canRedo: boolean;
  @Link previousTextArea: TextAreaInfo | undefined;
  @Link realTimeContent: string | undefined;
  private richEditorController = new RichEditorController();
  @StorageProp('currentColorMode') @Watch('onColorModeChange') private currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) isPortrait: boolean =
    ScreenManager.getInstance().isScreenPortrait();
  @StorageProp(WIN_WIDTH_KEY) @Watch('refreshScreenWidth') screenWidth: number = ScreenManager.getInstance().width;
  @State inputAvoidLeft: number = (this.isPortrait ? this.textPaddingLeftAndRight : 0) + this.screenClass.avoidLeft;
  @State inputAvoidRight: number = this.textPaddingLeftAndRight + this.screenClass.avoidRight;
  private inputToCheckMark: number = 16;
  @State richEditorWidth: number =
    this.screenWidth - this.inputAvoidLeft - this.inputAvoidRight - this.inputToCheckMark - Constants.iconSize;
  @Prop fromId: string;
  private textArea: TextAreaInfo | undefined = undefined;
  private lineCount = 1;
  private textAreaManager: TextAreaManager = TextAreaManager.getInstance();
  private undoRedoManager: UndoRedoManager = UndoRedoManager.getInstance();
  public timer: number = -1;

  textInputAreaHideChange() {
    if (this.textInputAreaHide) {
      // 某些设备/输入法（如手写面板）可能不触发 keyboardHeightChange，兜底给一个默认高度；
      // 如果后续从 avoidAreaChange / keyboardHeightChange 获得真实高度，会自动覆盖。
      const DEFAULT_KEYBOARD_HEIGHT_VP = 366;
      if (this.keyboardHeight <= 0) {
        this.keyboardHeight = DEFAULT_KEYBOARD_HEIGHT_VP;
      }
      this.timer = setTimeout((): void => {
        focusControl.requestFocus('text_edit_input_' + this.fromId);
      }, 100)
    } else {
      this.keyboardHeight = 0;
    }
  }

  refreshScreenWidth() {
    this.textPaddingLeftAndRight = ScreenManager.getInstance().updateEditorPageGridPaddingLeftAndRight();
    this.inputAvoidLeft = (this.isPortrait ? this.textPaddingLeftAndRight : 0) + this.screenClass.avoidLeft;
    this.inputAvoidRight = this.textPaddingLeftAndRight + this.screenClass.avoidRight;
    this.richEditorWidth =
      this.screenWidth - this.inputAvoidLeft - this.inputAvoidRight - this.inputToCheckMark - Constants.iconSize;
    this.richEditorController.stopEditing();
    this.textInputAreaHide = false;
  }

  onColorModeChange() {

  }

  currentFontColorChange(): void {
    this.textArea = this.textAreaManager.getTextAreaList().filter(item => item.editState === 1)[0];
    if (this.textArea) {
      HiLog.i(TAG, `current operate id:${this.textArea.id}, editState:${this.textArea.editState}`);
      this.changeTextSpan(this.textArea, true, false);
    } else {
      HiLog.e(TAG, 'unexpected editState');
    }
  }

  currentFontSizeChange(): void {
    this.textArea = this.textAreaManager.getTextAreaList().filter(item => item.editState === 1)[0];
    if (this.textArea) {
      this.changeTextSpan(this.textArea, false, true);
    } else {
      HiLog.e(TAG, 'unexpected editState');
    }
  }

  changeTextSpan(textArea: TextAreaInfo, changeColor: boolean, changeSize: boolean) {
    HiLog.i(TAG, `changeTextSpan, changeColor:${changeColor}, changeSize:${changeSize}`);
    let fontColor: Color | string | Resource = textArea.getShowColor();
    let fontSize: number = textArea.fontSize;
    if (changeSize) {
      fontSize = this.currentFontSize;
    }
    textArea.richEditorController.deleteSpans();
    textArea.richEditorController.addTextSpan(textArea.content === '' ?
      UiUtil.getResourceString($r('app.string.edit_text_imageEdit')) : textArea.content, {
      style: {
        fontColor: fontColor,
        fontSize: vp2px(fontSize) + 'px',
        fontWeight: textArea.isBold ? FontWeight.Bold : FontWeight.Normal,
        fontStyle: textArea.isItalic ? FontStyle.Italic : FontStyle.Normal,
        //设置下划线
        decoration: {
          type: textArea.isUnderline ? TextDecorationType.Underline : TextDecorationType.None,
          color: textArea.getShowColor(),
        },
        //阴影
        textShadow: textArea.isTextShadow ? Constants.borderShadow : { radius: 0 },
      },
      paragraphStyle: {
        textAlign: textArea.textAlign,
      }
    });
    //更新lastTextArea样式
    this.textAreaManager.copyStyle(this.textAreaManager.getLastTextArea(), textArea);
    this.textAreaManager.getLastTextArea().fontSize = fontSize;
  }

  aboutToAppear() {
    HiLog.i(TAG, 'TextInputEditItem aboutToAppear');
    this.textArea = this.textAreaManager.getTextAreaList().filter(item => item.editState === 1)[0];
    window.getLastWindow(getContext()).then(lastWindow => {
      this.lastWindow = lastWindow;

      this.keyboardHeightChangeCallback = (size: number) => {

        const heightVp = px2vp(size);
        if (heightVp <= 0) {
          this.keyboardHeight = 0;
        } else {
          this.keyboardHeight = Math.max(this.keyboardHeight, heightVp);
        }
        HiLog.i(TAG, `TextInputEditItem keyboardHeightChange keyboardHeight:${this.keyboardHeight}`);
      };
      lastWindow.on('keyboardHeightChange', this.keyboardHeightChangeCallback);

      this.avoidAreaChangeCallback = (options: window.AvoidAreaOptions) => {
        if (!options) {
          return;
        }
        if (options.type === window.AvoidAreaType.TYPE_KEYBOARD) {
          const kbHeightVp = px2vp(options.area?.bottomRect?.height ?? 0);
          this.keyboardHeight = kbHeightVp;
          HiLog.i(TAG, `TextInputEditItem avoidAreaChange(TYPE_KEYBOARD) keyboardHeight:${this.keyboardHeight}`);
        } else if (options.type === window.AvoidAreaType.TYPE_SYSTEM) {
          this.navHeight = px2vp(options.area?.bottomRect?.height ?? 0);
        }
      };
      lastWindow.on('avoidAreaChange', this.avoidAreaChangeCallback);


      this.navHeight = px2vp(lastWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).bottomRect.height);

      try {
        const kbArea = lastWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_KEYBOARD);
        const kbHeightVp = px2vp(kbArea?.bottomRect?.height ?? 0);
        if (kbHeightVp > 0) {
          this.keyboardHeight = kbHeightVp;
        }
      } catch (e) {

      }
    }).catch((err: BusinessError) => {
      HiLog.e(TAG, `TextInputEditItem aboutToAppear err:${err.message}`);
    })

  }

  aboutToDisappear() {
    HiLog.i(TAG, 'aboutToDisAppear: %{public}s', this.fromId);
    this.textArea = undefined;
    clearTimeout(this.timer);
    if (this.lastWindow) {
      try {
        this.keyboardHeightChangeCallback &&
        this.lastWindow.off('keyboardHeightChange', this.keyboardHeightChangeCallback);
        this.avoidAreaChangeCallback && this.lastWindow.off('avoidAreaChange', this.avoidAreaChangeCallback);
      } catch (e) {

      }
    }
    this.lastWindow = undefined;
    this.keyboardHeightChangeCallback = undefined;
    this.avoidAreaChangeCallback = undefined;
  }

  getInputValue(): string {
    let inputResult = '';
    let getSpans = this.richEditorController.getSpans()
    getSpans.forEach(index => {
      let spanTextValue: RichEditorTextSpanResult = index as RichEditorTextSpanResult;
      if (spanTextValue.value !== undefined) {
        inputResult = inputResult + spanTextValue.value;
      } else {
        HiLog.e(TAG, 'unexpected spanTextValue');
      }
    });
    return inputResult;
  }

  // 输入框文字校验
  inputNumCheck() {
    this.richEditorController.getSpans({
      start: this.start,
      end: this.end,
    }).forEach(item => {
      if (typeof (item as RichEditorImageSpanResult)['imageStyle'] !== 'undefined') {
        this.textLength++;
      } else {
        this.textLength = (item as RichEditorTextSpanResult).value.length;
      }
    })
  }

  // 获取选中的字符个数
  getSelection(): number {
    let select = this.richEditorController.getSelection();
    return (select.selection[1] - select.selection[0]);
  }

  @Builder
  richEditorBuilder() {
    RichEditor({
      controller: this.richEditorController,
    })
      .placeholder($r('app.string.edit_text_imageEdit'), {
        font: {
          size: vp2px(Constants.DEFAULT_TEXTAREA_FONT_SIZE) + 'px',
        },
        fontColor: ($r('sys.color.font_secondary')),
      })
      .constraintSize({ minHeight: 40 })
      .id('text_edit_input_' + this.fromId)
      .align(Alignment.Center)
      .width(this.richEditorWidth)
      .borderRadius(24)
      .align(Alignment.Center)
      .opacity(0.9)
      .backgroundColor($r('sys.color.ohos_id_color_text_field_sub_bg'))
      .margin({
        top: 8,
        bottom: 8,
      })
      .onFocus(this.richEditorOnFocusEvent)
      .onBlur(() => {
        if (this.textArea) {
          displayOption(this.textArea, false, false, 0);
          HiLog.i(TAG, 'TextInputEditItem onBlur, editState clear %{public}i', this.textArea?.editState);
        }
        this.richEditorController.deleteSpans();
        this.textCanClickStyle = false;
        this.textInputAreaHide = false;
      })
      .onPaste(this.richEditorOnPasteEvent)
      .onIMEInputComplete((value: RichEditorTextSpanResult) => {
        HiLog.i(TAG, 'TextInputEditItem onIMEInputComplete');
        this.textCanClickStyle = true;
        if (!this.textArea) {
          return;
        }
        let inputResult = this.getInputValue();
        this.textArea.content = inputResult;
        this.changeTextSpan(this.textArea, false, false);
        this.realTimeContent = this.textArea.content;
      })
      .aboutToIMEInput((value: RichEditorInsertValue) => {
        if (!this.textArea) {
          return;
        }
        if ((this.textArea.content.length + value.insertValue.length - this.getSelection()) <=
        Constants.INPUT_TEXT_LENGTH) {
          return true;
        }
        return false;
      })
      .onDeleteComplete(this.richEditorOnDeleteCompleteEvent)
      .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
        this.inputBoxHeight = Number(newValue.height);
        HiLog.i(TAG, 'this.inputBoxHeight: %{public}i', this.inputBoxHeight)
      })
  }

  richEditorOnFocusEvent = () => {
    this.richEditorController.setTypingStyle({ fontSize: vp2px(Constants.DEFAULT_TEXTAREA_FONT_SIZE) + 'px' })
    HiLog.i(TAG, 'TextInputEditItem onFocus');
    this.textArea = this.textAreaManager.getTextAreaList().filter(item => item.editState === 1)[0];
    if (this.textArea) {
      HiLog.i(TAG, 'this.textArea.id = %{public}s', this.textArea.id);
      this.previousTextArea = deepCopy(this.textArea);
      displayOption(this.textArea, undefined, false);
      if (this.textArea.content == UiUtil.getResourceString($r('app.string.edit_text_imageEdit'))) {
        return;
      }
      this.richEditorController.deleteSpans();
      this.richEditorController.addTextSpan(this.textArea.content, {
        style: {
          fontSize: vp2px(Constants.DEFAULT_TEXTAREA_FONT_SIZE) + 'px',
        },
      });
      this.timer = setTimeout((): void => {
        this.richEditorController.setSelection(0, this.textArea?.content.length);
      }, 100)
      // 悬浮窗转移焦点没法拉起软键盘，需要应用自己拉起软键盘
      let inputMethodController = inputMethod.getController();
      inputMethodController.showTextInput((err: BusinessError) => {
        if (err) {
          console.error(`TextInputEditItem Failed to showTextInput: ${JSON.stringify(err)}`);
          return;
        }
        console.log('TextInputEditItem Succeeded in showing the inputMethod.');
      });
    } else {
      HiLog.e(TAG, 'unexpected editState');
      this.richEditorController.stopEditing();
      this.textInputAreaHide = false;
    }
  }
  richEditorOnPasteEvent = async (event: PasteEvent) => {
    HiLog.i(TAG, 'TextInputEditItem onPaste');
    event?.preventDefault!();
    if (!this.textArea) {
      return;
    }
    const newContent = await RichEditorHelper.getNewContentFromSystemPaste();
    HiLog.i(TAG, `TextInputEditItem onPaste newContent:${newContent}`);
    if (this.textArea.content.length + newContent.length - this.getSelection() > Constants.INPUT_TEXT_LENGTH) {
      return;
    }
    this.richEditorController.deleteSpans({
      start: this.richEditorController.getCaretOffset() - this.getSelection(),
      end: this.richEditorController.getCaretOffset(),
    })
    this.richEditorController.addTextSpan(newContent, {
      style: {
        fontColor: Constants.DEFAULT_TEXT_INPUT_ITEM_FONT_COLOR,
        fontSize: vp2px(Constants.DEFAULT_TEXTAREA_FONT_SIZE) + 'px',
      },
      offset: this.richEditorController.getCaretOffset(),
    });
    let inputResult = this.getInputValue();
    this.textArea.content = inputResult;
    this.changeTextSpan(this.textArea, false, false);
    this.realTimeContent = this.textArea.content;
  }
  richEditorOnDeleteCompleteEvent = () => {
    HiLog.i(TAG, 'TextInputEditItem onDeleteComplete');
    if (!this.textArea) {
      return;
    }
    let getSpans = this.richEditorController.getSpans({ start: 0 });
    HiLog.i(TAG, `TextInputEditItem onDeleteComplete getSpans length:${getSpans.length}`);
    if (getSpans.length == 0) {
      this.textArea.content = '';
    } else {
      this.textArea.content = this.getInputValue();
    }
    this.changeTextSpan(this.textArea, false, false);
    this.realTimeContent = this.textArea.content;

    this.isFontSizeChange = !this.isFontSizeChange;
  }

  build() {
    Row() {
      this.richEditorBuilder();
      SymbolGlyph($r('sys.symbol.checkmark'))
        .symbolGlyph()
        .fontColor([$r('sys.color.icon_primary')])
        .id('edit_box_check_mark')
        .accessibilityLevel('yes')
        .accessibilityText(UiUtil.getResourceString($r('app.string.petalClip_stylus_finish')) +
        UiUtil.getResourceString($r('app.string.button_imageEdit')))
        .onClick((): void => {
          if (!this.textArea) {
            return;
          }
          HiLog.i(TAG, 'submit input, length: %{public}i', this.textArea.content.length);
          this.textInputAreaHide = false;
          this.richEditorController.stopEditing();
          this.undoRedoManager.push(
            new Operation(Constants.UPDATE_CONTENT, this.textArea.id, this.previousTextArea, deepCopy(this.textArea)));
          this.canUndo = this.undoRedoManager.canUndo();
          this.canRedo = this.undoRedoManager.canRedo();
          setTimeout((): void => {
            if (this.textArea) {
              displayOption(this.textArea, true, true, 1);
              this.textCanClickStyle = true;
            }
          }, 5);
        })
        .margin({
          left: 16,
        })
    }
    .padding({
      start: LengthMetrics.vp((this.isPortrait ? this.textPaddingLeftAndRight : 0) + this.screenClass.avoidLeft),
      end: LengthMetrics.vp(this.textPaddingLeftAndRight + this.screenClass.avoidRight),
    })
    .backgroundColor(this.currentMode === 1 ? '#e3e4e6' : '#242424')
    .width(this.screenWidth)
    .position({
      y: ScreenManager.getInstance().height - this.keyboardHeight - this.inputBoxHeight - this.navHeight - 16,
    })
    .visibility(this.textInputAreaHide ? Visibility.Visible : Visibility.None)
  }
}