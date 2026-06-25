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
import lazy { AlertDialog } from '@ohos.arkui.advanced.Dialog';

/* instrument ignore file */
const TAG: string = 'common_UseMobileNetWorkDialog';

@CustomDialog
export struct UseMobileNetWorkDialog {
  controller: CustomDialogController;

  build() {
    AlertDialog({
      primaryTitle: $r('app.string.message_use_mobile_newwork_dialog_title'),
      content: $r('app.string.message_use_mobile_newwork_dialog_content'),
      primaryButton: {
        value: $r('app.string.action_cancel'),
        action: (): void => {
          Log.info(TAG, 'primaryButton onclick');
          this.controller.close();

        }
      },
      secondaryButton: {
        value: $r('app.string.message_use_mobile_newwork_dialog_button'),
        action: (): void => {
          Log.info(TAG, 'secondaryButton onclick');
          AppStorage.setOrCreate('unlimitedUseOfMobileNetwork', true);
          this.updateUnlimitedNetworkStatus();
          this.controller.close();

        }
      }
    })
      .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
  }

  updateUnlimitedNetworkStatus(): void {
    const isFromDS = AppStorage.get<boolean>('unlimitedStatusChangeIsFromDS');
    Log.info(TAG, `[Cloud Status] unlimited status change start, isFromDS: ${isFromDS}`);

    if (isFromDS) {
      AppStorage.setOrCreate<boolean>('unlimitedStatusChangeIsFromDS', false);
    } else {
    }
  }
}
