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

import { Log } from '../../utils/Log';
import { DialogCallback } from '../../model/common/DialogUtil';
import { ColumnSize, ScreenManager } from '../../model/common/ScreenManager';
import { Constants } from '../../model/common/Constants';
import { UiUtil } from '../../utils/UiUtil';
import { StringUtil } from '../../utils/StringUtil';

const TAG: string = 'common_RenameDialog';

@CustomDialog
export struct RenameDialog {
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  controller?: CustomDialogController;
  @Consume renameFileName: string;
  @Consume dialogCallback: DialogCallback;
  @State isNull: boolean = false;
  @State dividerColor: Resource = $r('app.color.dialog_divider_h_color_182431');
  @State dividerWidth: string = '1vp';
  private inputName: string = '';
  private isPcDevice: boolean = AppStorage.get<string>('deviceType') === Constants.PC_DEVICE_TYPE;

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.inputName = this.renameFileName;
    this.isNull = this.inputName === '';
    if (this.inputName.length === Constants.RENAME_MAX_LENGTH) {
      UiUtil.showToast($r('app.string.Maximum_length_reached'));
    }
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.rename'))
          .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }.alignItems(VerticalAlign.Center)
      .height($r('app.float.dialog_title_height'))
      .margin({
        left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin')
      })

      Row() {
        Column() {
          TextInput({ placeholder: '', text: this.inputName })
            .key('RenameDialogTextInput')
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .maxLength(Constants.RENAME_MAX_LENGTH)
            .enterKeyType(EnterKeyType.Done)
            .backgroundColor($r('app.color.transparent'))
            .onChange((value: string) => {
              Log.info(TAG, `TextInput onChange : ${value}`)
              this.inputName = value
              if (value.length === Constants.RENAME_MAX_LENGTH) {
                UiUtil.showToast($r('app.string.Maximum_length_reached'));
              }
              this.isNull = this.inputName === '';
            })
            .margin({
              left: $r('app.float.input_text_margin'), right: $r('app.float.input_text_margin')
            })

          Divider().vertical(false).strokeWidth(1)
            .color($r('sys.color.ohos_id_color_secondary'))
            .margin({
              left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin')
            })
        }
      }.margin({
        bottom: $r('sys.float.ohos_id_elements_margin_vertical_l') })

      Stack({ alignContent: Alignment.Top }) {
        Row() {
          Column() {
            Button() {
              Text($r('app.string.no'))
                .fontSize($r('sys.float.ohos_id_text_size_button1'))
                .fontColor($r('app.color.color_control_highlight'))
                .fontWeight(FontWeight.Medium)
                .width('100%')
                .textAlign(TextAlign.Center)
            }
            .key('RenameDialogCancelButton')
            .margin({ right: $r('app.float.dialog_double_buttons_margin_right') })
            .backgroundColor(this.isPcDevice ? $r('sys.color.ohos_id_color_button_normal') : $r('app.color.transparent'))
            .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
            .height($r('app.float.details_dialog_button_height'))
            .onClick(() => {
              this.dialogCallback && this.dialogCallback.cancelCallback();
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
              Text($r('app.string.yes'))
                .fontSize($r('sys.float.ohos_id_text_size_button1'))
                .fontColor($r('app.color.color_control_highlight'))
                .fontWeight(FontWeight.Medium)
                .width('100%')
                .textAlign(TextAlign.Center)
            }
            .key('RenameDialogConfirmButton')
            .enabled(!this.isNull)
            .opacity(this.isNull ? $r('app.float.disable_button_opacity') : 1)
            .margin({ left: $r('app.float.dialog_double_buttons_margin_left') })
            .backgroundColor(this.isPcDevice ? $r('sys.color.ohos_id_color_button_normal') : $r('app.color.transparent'))
            .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
            .height($r('app.float.details_dialog_button_height'))
            .onClick(() => {
              let passCheck = StringUtil.checkNameInvalid(this.inputName);
              if (passCheck) {
                UiUtil.showToast($r('app.string.specific_characters_not_supported'));
                return;
              }
              if (this.inputName == this.renameFileName) {
                this.controller?.close();
                return;
              }
              this.dialogCallback && this.dialogCallback.confirmCallback(this.inputName);
              this.controller?.close();
            })
          }.width('50%')
        }
      }
      .height($r('app.float.details_dialog_button_area_height'))
      .margin({
        left: $r('app.float.dialog_double_buttons_margin'), right: $r('app.float.dialog_double_buttons_margin')
      })
    }
    .alignItems(HorizontalAlign.Start)
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
    .width(this.isPcDevice ? $r('app.float.pc_dialog_width') : ScreenManager.getInstance()
                                                                 .getColumnsWidth(ColumnSize.COLUMN_FOUR))
    .backgroundColor($r('app.color.white'))
    .margin({
      right: $r('app.float.dialog_content_margin'),
      left: $r('app.float.dialog_content_margin'),
      bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + this.leftBlank[3]
    })
    .shadow({
      radius: $r('app.float.dialog_defult_shadow_m_radio'),
      color: $r('app.color.dialog_defult_shadow_m_color'),
      offsetX: $r('app.float.dialog_defult_shadow_m_offsetX'),
      offsetY: $r('app.float.dialog_defult_shadow_m_offsetY')
    })
  }
}
