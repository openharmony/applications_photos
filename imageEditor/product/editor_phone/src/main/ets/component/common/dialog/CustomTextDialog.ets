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

import { CustomContentDialog } from '@kit.ArkUI';
import { HiLog } from '@oh-image-editor/editor-common';

/* instrument ignore file */
const TAG: string = 'common_CustomTextDialog';
const WATERMARK_ARK_SIGN_MIN_SHOW_LEN: number = 10;
const WATERMARK_ARK_SIGN_MAX_LEN: number = 12;

@CustomDialog
export struct CustomTextDialog {
  public controller?: CustomDialogController;
  private textInputController: TextInputController = new TextInputController();
  public closeRenamePhotoDialog?: Function;
  @State inputType: string = '';
  @State inputValue: string = '';
  public onConfirm?: (value: string) => void;
  @State charCount: number = 0;
  @StorageLink('isShowPage') @Watch('showPageStatus') isShowPage: boolean = true;

  aboutToAppear(): void {
    HiLog.i(TAG, 'aboutToAppear');
  }

  showPageStatus() {
    HiLog.i(TAG, 'showPageStatus');
    if (this.isShowPage == false) {
      this.closeFunc();
    }
  }

  build() {
    CustomContentDialog({
      primaryTitle: this.inputType?.includes('sign_') ? $r('app.string.seal_shoot_sign_imageEdit') :
        $r('app.string.beauty_Custom_imageEdit'),
      contentBuilder: () => {
        this.buildDialog();
      },
      contentAreaPadding: {
        top: 0,
        right: 24,
        bottom: 0,
        left: 24,
      },
      buttons: [{
        value: $r('app.string.no'),
        buttonStyle: ButtonStyleMode.TEXTUAL,
        fontColor: $r('sys.color.font_emphasize'),
        action: () => {
          HiLog.i(TAG, 'first button onclick');
          this.closeFunc();
        }
      }, {
        value: $r('app.string.yes'),
        buttonStyle: ButtonStyleMode.TEXTUAL,
        fontColor: $r('sys.color.font_emphasize'),
        action: async () => {
          HiLog.i(TAG, 'second button onclick');
          if (this.onConfirm && this.charCount <= WATERMARK_ARK_SIGN_MAX_LEN) {
            this.onConfirm(this.inputValue);
          }
          this.closeFunc();
        }
      }]
    })
  }

  @Builder
  buildDialog() {
    Column() {
      TextInput({ placeholder: '', text: this.inputValue, controller: this.textInputController })
        .defaultFocus(true)
        .draggable(false)
        .showUnderline(true)
        .key('customText_Dialog_textInput')
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
          .maxFontScale(2)
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
      .visibility(this.charCount >= WATERMARK_ARK_SIGN_MIN_SHOW_LEN ? Visibility.Visible : Visibility.None)
      .padding({
        top: $r('sys.float.padding_level4'),
      })
    }
    .width('100%')
  }

  private closeFunc(): void {
    this.controller?.close();
  }
}
