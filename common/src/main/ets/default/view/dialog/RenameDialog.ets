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
import lazy { ButtonOptions, CustomContentDialog } from '@kit.ArkUI';
import lazy { AlbumDefine } from '../../model/browser/AlbumDefine';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';

/* instrument ignore file */
const TAG: string = 'common_RenameDialog';

@CustomDialog
export struct RenameDialog {
  public controller?: CustomDialogController;
  @Consume renameFileName: string;
  @Consume dialogCallback?: DialogCallback;
  @State isNull: boolean = false;
  @Consume inputText: string;
  private inputName: string = '';
  private textInputController: TextInputController = new TextInputController();
  public closeRenamePhotoDialog?: Function;
  private buttons: ButtonOptions[] = [];
  @State initInputText: string = '';

  onOk(): void {
    Log.info(TAG, 'second button onclick');
    if (StringUtil.isInvalid(this.inputName)) { // 空字符串检查
      UiUtil.showToast($r('app.string.please_enter_name'));
      return;
    }
    let passCheck = StringUtil.checkNameInvalid(this.inputName);
    if (passCheck) {
      UiUtil.showToast($r('app.string.specific_characters_not_supported'));
      return;
    }
    if (this.inputName === this.renameFileName) {
      this.closeFunc();
      return;
    }
    if (this.inputName.trim() === '') {
      this.inputName = this.initInputText;
      UiUtil.showToast($r('app.string.please_enter_name'));
    } else {
      this.inputName = this.inputName.trim();
    }
    this.dialogCallback && this.dialogCallback?.confirmCallback?.(this.inputName);
    this.closeFunc();
  }

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.buttons.push({
      value: $r('app.string.no'),
      action: (): void => {
        Log.info(TAG, 'first button onclick');
        this.dialogCallback && this.dialogCallback?.cancelCallback?.();
        this.closeFunc();
      }
    });
    this.buttons.push({
      value: $r('app.string.yes'),
      action: (): void => this.onOk(),
    });
    this.inputName = this.inputText;
    this.isNull = this.inputName === '';
    if (this.inputName?.length === Constants.RENAME_MAX_LENGTH) {
      UiUtil.showToast($r('app.string.Maximum_length_reached'));
    }
  }

  build() {
    CustomContentDialog({
      primaryTitle: $r('app.string.rename'),
      contentBuilder: (): void => {
        this.buildRename();
      },
      buttons: this.buttons,
    })
  }

  @Builder
  buildRename() {
    TextInput({ placeholder: '', text: this.inputName, controller: this.textInputController })
      .defaultFocus(true)
      .draggable(false)
      .showUnderline(true)
      .key('RenameDialogTextInput')
      .backgroundColor($r('app.color.transparent'))
      .fontSize($r('sys.float.ohos_id_text_size_body1'))
      .fontFamily($r('app.string.id_text_font_family_regular'))
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .maxLength(Constants.RENAME_MAX_LENGTH)
      .enterKeyType(EnterKeyType.Done)
      .selectAll(true)
      .onSubmit((enterKeyType): void => {
        /* instrument ignore next */
        if (DeviceInfo.isPc()) {
          Log.info(TAG, `onKeyEvent--enterKeyType: ${enterKeyType}`);
          this.onOk();
        }
      })
      .onChange((value: string): void => {
        Log.info(TAG, `TextInput onChange : ${AlbumDefine.getAnonymizeAlbumName(value)}`);
        this.inputName = value;
        this.inputText = value;
        if (value?.length === Constants.RENAME_MAX_LENGTH) {
          UiUtil.showToast($r('app.string.Maximum_length_reached'));
        }
        this.isNull = this.inputName === '';
      })
      .onFocus((): void => {
        this.initInputText = this.inputName;
        /* instrument ignore next */
        if (DeviceInfo.isPc()) {
          this.textInputController.setTextSelection(0, this.initInputText.length, { menuPolicy: MenuPolicy.HIDE });
        }
      })
  }

  private closeFunc(): void {
    if (this.closeRenamePhotoDialog) {
      this.closeRenamePhotoDialog();
    } else {
      this.controller?.close();
    }
  }
}
