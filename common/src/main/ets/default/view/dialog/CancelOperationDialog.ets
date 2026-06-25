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
const TAG: string = 'common_CancelOperationDialog';

@Observed
export class CancelParam {
  continueFunc: Function = (): void => {
  };
  cancelFunc: Function = (): void => {
  };
}

@CustomDialog
export struct CancelOperationDialog {
  public controller?: CustomDialogController;
  private cancelMessage: Resource = $r('app.string.common_place_holder', '');
  @Consume cancelParam: CancelParam;
  private message: Resource = $r('app.string.common_place_holder', '');

  aboutToAppear(): void {
    this.message = this.cancelMessage;
  }

  build() {
    AlertDialog({
      primaryTitle: $r('app.string.cancel_process_title'),
      content: this.message,
      primaryButton: {
        value: $r('app.string.continue'),
        action: (): void => {
          Log.info(TAG, 'primaryButton onclick');
          this.cancelParam.continueFunc();
          this.controller?.close();
        }
      },
      secondaryButton: {
        value: $r('app.string.stop'),
        fontColor: $r('sys.color.warning'),
        action: (): void => {
          Log.info(TAG, 'secondaryButton onclick');
          this.cancelParam.cancelFunc();
          this.controller?.close();
        }
      }
    })
  }
}
