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

import lazy { Log } from '../../utils/Log';
import lazy { DialogCallback } from '../../model/common/DialogUtil';
import lazy { Constants } from '../../model/common/Constants';
import lazy { UiUtil } from '../../utils/UiUtil';
import lazy { StringUtil } from '../../utils/StringUtil';
import lazy { ButtonOptions, CustomContentDialog } from '@ohos.arkui.advanced.Dialog';
import lazy { AlbumDefine } from '../../model/browser/AlbumDefine';

/* instrument ignore file */
const TAG: string = 'common_NewAlbumDialog';

@CustomDialog
export struct NewAlbumDialog {
  public controller?: CustomDialogController;
  @Consume dialogCallback?: DialogCallback;
  @State isNull: boolean = false;
  @State isFocusable: boolean = true;
  @Consume inputText: string;
  private inputName: string = '';
  private textInputController: TextInputController = new TextInputController();
  private hasClickedOK: boolean = false;
  public closeNewAlbumDialog?: Function;
  private buttons: ButtonOptions[] = [];

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.buttons.push({
      value: $r('app.string.dialog_cancel'),
      action: (): void => {
        Log.info(TAG, 'first button onclick');
        this.dialogCallback && this.dialogCallback?.cancelCallback?.();
        this.closeFunc();
      }
    });
    this.buttons.push({
      value: $r('app.string.yes'),
      action: (): void => {
        Log.info(TAG, 'second button onclick');
        let passCheck = StringUtil.checkNameInvalid(this.inputName);
        if (passCheck) {
          UiUtil.showToast($r('app.string.specific_characters_not_supported'));
          return;
        }
        if (this.hasClickedOK) {
          Log.info(TAG, 'the OK button has been clicked');
          return;
        }
        this.isFocusable = false;
        this.hasClickedOK = true;
        this.textInputController.stopEditing(); // 主动收起键盘
        // 停留30ms，等待键盘收起
        setTimeout(() => {
          this.handleConfirmCallback();
        }, 30);
      }
    })
    this.inputName = this.inputText;
    this.isNull = this.inputName === '';
    if (this.inputName.length === Constants.RENAME_MAX_LENGTH) {
      UiUtil.showToast($r('app.string.Maximum_length_reached'));
    }
  }

  build() {
    CustomContentDialog({
      primaryTitle: $r('app.string.album_new_album_title'),
      contentBuilder: (): void => {
        this.buildNewAlbum();
      },
      buttons: this.buttons,
    })
  }

  @Builder
  buildNewAlbum() {
    TextInput({ placeholder: '', text: this.inputName, controller: this.textInputController })
      .defaultFocus(true)
      .showUnderline(true)
      .draggable(false)
      .key('NewAlbumDialogTextInput')
      .backgroundColor($r('app.color.transparent'))
      .focusable(this.isFocusable)
      .selectAll(true)
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .maxLength(Constants.RENAME_MAX_LENGTH)
      .enterKeyType(EnterKeyType.Done)
      .onTouch((event: TouchEvent): void => {
        if (event.type == TouchType.Down && !this.isFocusable) {
          this.isFocusable = true;
        }
      })
      .onChange((value: string) => {
        Log.info(TAG, `TextInput onChange : ${AlbumDefine.getAnonymizeAlbumName(value)}`);
        this.inputName = value;
        this.inputText = value;
        if (value.length === Constants.RENAME_MAX_LENGTH) {
          UiUtil.showToast($r('app.string.Maximum_length_reached'));
        }
        this.isNull = this.inputName === '';
        this.hasClickedOK = false;
      })
  }

  private handleConfirmCallback(): void {
    if (this.dialogCallback === null || this.dialogCallback === undefined) {
      this.closeFunc();
      return;
    }
    let confirmCb: Promise<Function> = this.dialogCallback?.confirmCallback?.(this.inputName) as Promise<Function>;
    confirmCb.then((res: Function): void => {
      if (res) {
        this.closeFunc();
        return;
      }
      Log.warn(TAG, 'new album name is not available!');
      this.isFocusable = false;
      this.hasClickedOK = false;
    });
  }

  private closeFunc() {
    if (this.closeNewAlbumDialog) {
      this.closeNewAlbumDialog();
    } else {
      this.controller?.close();
    }
  }
}