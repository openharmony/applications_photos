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
import lazy { FocusUtil } from '../../utils/FocusUtil';
import lazy { ButtonOptions } from '../../utils/ButtonOptionUtil';
import lazy { AlertDialog } from '@ohos.arkui.advanced.Dialog';


const TAG: string = 'common_restoreDefaultAlbumSortingDialog';

@CustomDialog
export struct RestoreDefaultAlbumSortingDialog {
  @Prop dialogCallback?: DialogCallback;
  public closeFunc?: Function;
  private confirmCallback: Function = (): void => {
  };
  private cancelCallback: Function = (): void => {
  };
  public controller?: CustomDialogController;
  private content: ResourceStr = $r('app.string.restore_default_sort_message');

  private cancelButton: ButtonOptions = {
    defaultFocus: false,
    value: $r('app.string.dialog_cancel'),
    action: (): void => {
      Log.info(TAG, 'cancelButton onclick');
      this.cancelCallback?.();
      this.closeFunc?.();
    },
  };
  private confirmButton: ButtonOptions = {
    defaultFocus: true,
    value: $r('app.string.action_recover'),
    action: (): void => {
      Log.info(TAG, 'confirmButton onclick');
      this.confirmCallback?.();
      this.closeFunc?.();
      FocusUtil.clearFocus(this.getUIContext()?.getFocusController());
    },
  };


  build() {
    AlertDialog({
      content: this.content,
      primaryButton: this.cancelButton,
      secondaryButton: this.confirmButton,
    })
  }
}
