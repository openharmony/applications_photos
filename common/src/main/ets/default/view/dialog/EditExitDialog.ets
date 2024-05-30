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

import router from '@ohos.router';
import { ColumnSize, ScreenManager } from '../../model/common/ScreenManager';
import { Constants } from '../../model/common/Constants';

@Observed
export class EditExitDialogCallback {
  public discardCallback: Function = (): void => {};
}

@CustomDialog
export struct EditExitDialog {
  @Consume editExitDialogCallback: EditExitDialogCallback;
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  controller?: CustomDialogController;
  private isPcDevice: boolean = AppStorage.get<string>('deviceType') === Constants.PC_DEVICE_TYPE;

  build() {
    Column() {
      Column() {
        Text($r('app.string.edit_exit_dialog_context_text'))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontWeight(FontWeight.Regular)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }
      .width('100%')
      .margin({
        top: $r('app.float.dialog_content_margin'),
        bottom: $r('sys.float.ohos_id_elements_margin_vertical_l')
      })

      Column() {
        Row() {
          Column() {
            Button() {
              Text($r('app.string.save_dialog_cancel_text'))
                .fontSize($r('sys.float.ohos_id_text_size_button1'))
                .fontColor($r('app.color.color_control_highlight'))
                .fontWeight(FontWeight.Medium)
                .width('100%')
                .textAlign(TextAlign.Center)
            }
            .key('Cancel')
            .margin({
              right: $r('app.float.dialog_double_buttons_margin_right')
            })
            .backgroundColor(this.isPcDevice ? $r('sys.color.ohos_id_color_button_normal') : $r('app.color.transparent'))
            .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
            .height($r('app.float.details_dialog_button_height'))
            .onClick(() => {
              this.controller?.close();
            })
          }.width('50%')

          if (!this.isPcDevice) {
            Divider()
              .vertical(true)
              .color(Constants.DEFAULT_DIVIDER_COLOR)
              .height(Constants.DEFAULT_DIVIDER_HEIGHT)
          }

          Column() {
            Button() {
              Text($r('app.string.edit_exit_dialog_discard_text'))
                .fontSize($r('sys.float.ohos_id_text_size_button1'))
                .fontColor($r('app.color.color_control_highlight'))
                .fontWeight(FontWeight.Medium)
                .width('100%')
                .textAlign(TextAlign.Center)
            }
            .key('Discard')
            .margin({
              left: $r('app.float.dialog_double_buttons_margin_left')
            })
            .backgroundColor(this.isPcDevice ? $r('sys.color.ohos_id_color_button_normal') : $r('app.color.transparent'))
            .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
            .height($r('app.float.details_dialog_button_height'))
            .onClick(() => {
              this.controller?.close();
              this.editExitDialogCallback && this.editExitDialogCallback.discardCallback()
              router.back()
            })
          }.width('50%')
        }
      }
      .width('100%')
      .height($r('app.float.details_dialog_button_area_height'))
    }
    .width(this.isPcDevice ? $r('app.float.pc_dialog_width') : ScreenManager.getInstance()
                                                                 .getColumnsWidth(ColumnSize.COLUMN_FOUR))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
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