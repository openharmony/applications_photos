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

import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { DialogCallback } from '../../model/common/DialogUtil';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { Log } from '../../utils/Log';
import lazy { AlertDialog } from '@ohos.arkui.advanced.Dialog';

/* instrument ignore file */
const TAG: string = 'common_PromptNewAlbumDialog';

@CustomDialog
export struct PromptNewAlbumDialog {
  @Consume dialogCallback?: DialogCallback;
  @Consume dialogBroadCast: BroadCast;
  @Consume dialogMessage: Resource;
  public controller?: CustomDialogController;
  private content: Resource = $r('app.string.common_place_holder', '');

  aboutToAppear(): void {
    this.content = this.dialogMessage;
  }

  build() {
    AlertDialog({
      primaryTitle: $r('app.string.prompt_new_album_dialog_title'),
      content: this.content,
      primaryButton: {
        value: $r('app.string.dialog_cancel'),
        action: (): void => {
          Log.info(TAG, 'primaryButton onclick');
          this.dialogBroadCast.emit(BroadCastConstants.HIDE_PROMPT_DIALOG, []);
          this.dialogCallback && this.dialogCallback?.cancelCallback?.();
        }
      },
      secondaryButton: {
        value: $r('app.string.action_new'),
        action: (): void => {
          Log.info(TAG, 'secondaryButton onclick');
          this.dialogBroadCast.emit(BroadCastConstants.HIDE_PROMPT_DIALOG, []);
          this.dialogCallback && this.dialogCallback?.confirmCallback?.();
        }
      }
    })
  }
}
