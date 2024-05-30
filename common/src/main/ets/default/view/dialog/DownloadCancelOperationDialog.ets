/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { BroadCast } from '../../utils/BroadCast';
import { Log } from '../../utils/Log';
import { ColumnSize, ScreenManager } from '../../model/common/ScreenManager';
import { Constants } from '../../model/common/Constants';

const TAG: string = 'common_DownloadCancelOperationDialog';

@Observed
export class CancelParam {
  public continueFunc: Function = (): void => {};
  public cancelFunc: Function = (): void => {};
}

@CustomDialog
export struct DownloadCancelOperationDialog {
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  controller?: CustomDialogController;
  @Consume broadCast: BroadCast;
  @Consume deleteProgress: number;
  @Consume cancelParam: CancelParam;
  private isPcDevice: boolean = AppStorage.get<string>('deviceType') === Constants.PC_DEVICE_TYPE;

  build() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        Text($r('app.string.download_cancel_message'))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontWeight(FontWeight.Regular)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }.width('100%')
      .margin({
        top: $r('app.float.dialog_content_margin'),
        bottom: $r('sys.float.ohos_id_elements_margin_vertical_l')
      })

      Stack({ alignContent: Alignment.Top }) {
        Row() {
          Column() {
            Button() {
              Text($r('app.string.download_progress_continue'))
                .fontColor($r('app.color.color_control_highlight'))
                .fontWeight(FontWeight.Medium)
                .fontSize($r('sys.float.ohos_id_text_size_button1'))
                .width('100%')
                .textAlign(TextAlign.Center)
            }
            .margin({
              right: $r('app.float.dialog_double_buttons_margin_right')
            })
            .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
            .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
            .height($r('app.float.details_dialog_button_height'))
            .onClick(() => {
              Log.info(TAG, 'click continue')
              this.cancelParam.continueFunc();
              this.controller?.close();
            })
          }.width('50%')

          Column() {
            Button() {
              Text($r('app.string.download_progress_cancel'))
                .fontColor($r('sys.color.ohos_id_color_warning'))
                .fontSize($r('sys.float.ohos_id_text_size_button1'))
                .fontWeight(FontWeight.Medium)
                .width('100%')
                .textAlign(TextAlign.Center)
            }
            .margin({
              left: $r('app.float.dialog_double_buttons_margin_left')
            })
            .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
            .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
            .height($r('app.float.details_dialog_button_height'))
            .onClick(() => {
              Log.info(TAG, 'click cancel')
              this.cancelParam.cancelFunc();
              this.controller?.close();
            })
          }.width('50%')
        }
      }.width('100%')
      .height($r('app.float.details_dialog_button_area_height'))
    }
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
    .width(this.isPcDevice ? $r('app.float.pc_dialog_width') : ScreenManager.getInstance()
                                                                 .getColumnsWidth(ColumnSize.COLUMN_FOUR))
    .backgroundColor($r('app.color.white'))
    .margin({
      right: $r('app.float.dialog_content_margin'),
      left: $r('app.float.dialog_content_margin'),
      bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + this.leftBlank[3]
    })
    .padding({
      left: $r('app.float.dialog_double_buttons_padding'),
      right: $r('app.float.dialog_double_buttons_padding')
    })
    .alignItems(HorizontalAlign.Start)
    .shadow({
      radius: $r('app.float.dialog_defult_shadow_m_radio'),
      color: $r('app.color.dialog_defult_shadow_m_color'),
      offsetX: $r('app.float.dialog_defult_shadow_m_offsetX'),
      offsetY: $r('app.float.dialog_defult_shadow_m_offsetY')
    })
  }
}
