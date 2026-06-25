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

import { ButtonOptions, CustomContentDialog } from '@kit.ArkUI';
import { HiLog } from '@oh-image-editor/editor-common';

/* instrument ignore file */
const TAG: string = 'common_changeArtSignatureDialog';
const WATERMARK_ARK_SIGN_MIN_SHOW_LEN: number = 10;
const WATERMARK_ARK_SIGN_MAX_LEN: number = 12;
const HEIGHT_BOTTOM: number = 40;
const LINE_END_POINT_Y: number = 32;
const LINE_STROKE_WIDTH: number = 0.5;

@CustomDialog
export struct changeArtSignatureDialog {
  public controller?: CustomDialogController;
  private textInputController: TextInputController = new TextInputController();
  public closeRenamePhotoDialog?: Function;
  @State isFirstButtonTouchDown: boolean = false;
  @State isSecondButtonTouchDown: boolean = false;
  @State inputValue: string = '';
  public onConfirm?: (value: string) => void;
  @State inputText: string = '';
  @State charCount: number = 0;
  @StorageLink('isShowPage') @Watch('showPageStatus') isShowPage: boolean = true;

  aboutToAppear(): void {
    HiLog.i(TAG, 'aboutToAppear');
  }

  showPageStatus(changedPropertyName: string) {
    HiLog.i(TAG, 'showPageStatus');
    if (this.isShowPage == false) {
      if (this.onConfirm) {
        this.onConfirm(this.inputValue)
      }
      this.closeFunc();
    }
  }

  build() {
    CustomContentDialog({
      primaryTitle: $r('app.string.seal_shoot_sign_imageEdit'),
      contentBuilder: (): void => {
        this.buildDialog();
      },
      contentAreaPadding: {
        top: 0,
        right: $r('sys.float.padding_level8'),
        bottom: $r('sys.float.padding_level8'),
        left: $r('sys.float.padding_level8'),
      },
      themeColorMode: ThemeColorMode.DARK
    })
  }

  @Builder
  buildDialog() {
    Column() {
      // 输入框
      TextInput({ placeholder: '', text: this.inputValue, controller: this.textInputController })
        .defaultFocus(true)
        .draggable(false)
        .showUnderline(true)
        .underlineColor({
          normal: $r('app.color.text_input_underline'),
          typing: $r('app.color.text_input_underline'),
          error: $r('app.color.text_input_underline'),
          disable: $r('app.color.text_input_underline'),
        })
        .key('changeArtSignatureDialogTextInput')
        .backgroundColor($r('app.color.transparent'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .maxLength(WATERMARK_ARK_SIGN_MAX_LEN)
        .enterKeyType(EnterKeyType.Done)
        .onChange((value: string): void => {
          this.inputValue = value;
          this.charCount = value.length;
        })

      Row() {
        // 字数统计
        Text(`${this.charCount}/${WATERMARK_ARK_SIGN_MAX_LEN}`)
          .fontSize($r('sys.float.Caption_L'))
          .fontColor(this.charCount >= WATERMARK_ARK_SIGN_MAX_LEN ? '#ff0000' : '#999999')
          .fontWeight(FontWeight.Medium)
          .textCase(TextCase.UpperCase)
          .fontFeature('\"ss01\" on')
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
      .visibility(this.charCount >= WATERMARK_ARK_SIGN_MIN_SHOW_LEN ? Visibility.Visible : Visibility.None)
      .padding({
        top: $r('sys.float.padding_level4'),
      })

      Row() {
        Button({ stateEffect: false, buttonStyle: ButtonStyleMode.TEXTUAL }) {
          Text($r('app.string.no'))
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.brand_font_contrary'))
            .fontWeight(FontWeight.Medium)
            .textCase(TextCase.UpperCase)
            .fontFeature('\"ss01\" on')
            .align(Alignment.Center)
        }
        .width('48%')
        .height(HEIGHT_BOTTOM)
        .backgroundColor(this.isFirstButtonTouchDown ? '#26ffffff' : Color.Transparent)
        .onTouch(this.touchFirstEvent)
        .onClick((): void => {
          HiLog.i(TAG, 'first button onclick');
          this.closeFunc();
        })

        Line()
          .startPoint(['50%', 0])
          .endPoint(['50%', LINE_END_POINT_Y])
          .stroke($r('sys.color.comp_background_list_card'))
          .strokeWidth(LINE_STROKE_WIDTH)
          .width('4%')

        Button({ stateEffect: false, buttonStyle: ButtonStyleMode.TEXTUAL }) {
          Text($r('app.string.yes'))
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.brand_font_contrary'))
            .fontWeight(FontWeight.Medium)
            .textCase(TextCase.UpperCase)
            .fontFeature('\"ss01\" on')
            .align(Alignment.Center)
        }
        .width('48%')
        .height(HEIGHT_BOTTOM)
        .backgroundColor(this.isSecondButtonTouchDown ? '#26ffffff' : Color.Transparent)
        .onTouch(this.touchSecondEvent)
        .enabled(!(this.inputValue.trim().length === 0 && this.inputValue.length != 0))
        .onClick((): void => {
          HiLog.i(TAG, 'second button onclick');
          if (this.onConfirm) {
            this.onConfirm(this.inputValue)
          }
          this.closeFunc();
        })

      }
      .width('100%')
      .margin({ top: $r('sys.float.padding_level4') })
    }
    .width('100%')
  }

  private touchFirstEvent = (event: TouchEvent) => {
    if (event) {
      if (event.type === TouchType.Down) {
        this.isFirstButtonTouchDown = true;
      }
      if (event.type === TouchType.Up) {
        this.isFirstButtonTouchDown = false;
      }
    }
  }

  private touchSecondEvent = (event: TouchEvent) => {
    if (event) {
      if (event.type === TouchType.Down) {
        this.isSecondButtonTouchDown = true;
      }
      if (event.type === TouchType.Up) {
        this.isSecondButtonTouchDown = false;
      }
    }
  }

  private closeFunc(): void {
    this.controller?.close();
  }
}
