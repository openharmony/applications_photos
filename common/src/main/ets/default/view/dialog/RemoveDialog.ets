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
import lazy { DialogCallback } from '../../model/common/DialogUtil';
import lazy { Log } from '../../utils/Log';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { AlertDialog } from '@ohos.arkui.advanced.Dialog';
import lazy { BroadCastManager } from '../../model/common/BroadCastManager';
import lazy { ButtonOptions } from '../../utils/ButtonOptionUtil';

const TAG: string = 'common_RemoveDialog';

@CustomDialog
export struct RemoveDialog {
  @Consume dialogCallback?: DialogCallback;
  @Consume dialogBroadCast: BroadCast;
  @Consume dialogMessage: Resource;
  @Consume dialogContent: Resource;
  public controller?: CustomDialogController;
  @StorageLink('confirmText') confirmText: Resource = $r('app.string.dialog_remove');
  private message: Resource = $r('app.string.common_place_holder', '');
  private content: Resource = $r('app.string.common_place_holder', '');
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private cancelButton: ButtonOptions = {
    defaultFocus: false,
    value: $r('app.string.dialog_cancel'),
    action: (): void => {
      Log.info(TAG, 'primaryButton onclick');
      this.dialogBroadCast.emit(BroadCastConstants.HIDE_REMOVE_DIALOG, []);
      this.dialogCallback && this.dialogCallback?.cancelCallback?.();
    },
  };
  private confirmButton: ButtonOptions = {
    defaultFocus: true,
    value: this.confirmText,
    fontColor: $r('sys.color.warning'),
    action: (): void => {
      Log.info(TAG, 'secondaryButton onclick');
      this.dialogBroadCast.emit(BroadCastConstants.HIDE_REMOVE_DIALOG, []);
      this.dialogCallback && this.dialogCallback?.confirmCallback?.();
    },
  };

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.message = this.dialogMessage;
    this.content = this.dialogContent;
  }

  build() {
    AlertDialog({
      primaryTitle: this.message,
      content: this.content,
      primaryButton: this.cancelButton,
      secondaryButton: this.confirmButton,
    })
  }
}
