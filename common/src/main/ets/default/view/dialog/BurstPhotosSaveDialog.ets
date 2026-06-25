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
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';
import lazy { CustomContentDialog } from '@kit.ArkUI';
import lazy { Constants } from '../../model/common/Constants';

/* instrument ignore file */
const TAG: string = 'common_BurstPhotosSaveDialog';

const CONTENT_HEIGHT = 21;

interface ReportActionI {
  action: string,
  burstKey: string | undefined,
}

@CustomDialog
export struct BurstPhotosSaveDialog {
  public controller?: CustomDialogController;
  private deleteFun: Function = () => {
  };
  private saveFun: Function = () => {
  };
  private burstKey: string = '';

  aboutToAppear() {
    Log.info(TAG, 'DeleteDialog aboutToAppear');
  }

  aboutToDisappear() {

  }

  build() {
    CustomContentDialog({
      primaryTitle: $r('app.string.saving_burst_photos_dialog_title'),
      secondaryTitle: '',
      contentBuilder: () => {
        this.buildContent();
      },
      buttons: [
        {
          value: $r('app.string.dialog_delete'),
          buttonStyle: ButtonStyleMode.TEXTUAL,
          role: ButtonRole.ERROR,
          action: () => {
            this.controller?.close();
            this.deleteFun();
          }
        },
        {
          value: $r('app.string.saving_burst_photos_dialog_save_btn'),
          buttonStyle: ButtonStyleMode.TEXTUAL,
          action: () => {
            this.controller?.close();
            this.saveFun();
          }
        },
        {
          value: $r('app.string.dialog_cancel'),
          buttonStyle: ButtonStyleMode.TEXTUAL,
          action: () => {
            Log.info(TAG, 'burst_save_cancel');
            const reportAction: ReportActionI = {
              action: BigDataConstants.BURST_SAVE_CANCEL,
              burstKey: this.burstKey,
            }
            ReportToBigDataUtil.report(BigDataConstants.BURST_SAVE, reportAction);
            this.controller?.close();
          }
        },
      ],
    })
  }

  @Builder
  buildContent() {
    Text($r('app.string.saving_burst_photos_dialog_content'))
      .fontSize($r('sys.float.Subtitle_M'))
      .lineHeight(CONTENT_HEIGHT)
      .textAlign(TextAlign.Center)
      .width(Constants.FULL_PERCENT);
  }
}