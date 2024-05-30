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
import { DialogCallback } from '../../model/common/DialogUtil';
import { Log } from '../../utils/Log';
import { ColumnSize, ScreenManager } from '../../model/common/ScreenManager';
import { Constants } from '../../model/common/Constants';
import data_preferences from '@ohos.data.preferences';
import { BusinessError } from '@ohos.base';

const TAG: string = 'common_DeleteDialog';

@CustomDialog
export struct DeleteDialog {
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  @Consume dialogCallback: DialogCallback;
  @Consume dialogMessage: Resource;
  controller?: CustomDialogController;
  @StorageLink('isFirstTimeDelete') isFirstTimeDelete: boolean = false;
  @StorageLink('confirmText') confirmText: Resource = $r('app.string.dialog_delete');
  private isPcDevice: boolean = AppStorage.get<string>('deviceType') === Constants.PC_DEVICE_TYPE;

  aboutToDisappear() {
    if (this.isFirstTimeDelete) {
      AppStorage.setOrCreate(Constants.IS_FIRST_TIME_DELETE, false);
      let pref: data_preferences.Preferences =
        AppStorage.get<data_preferences.Preferences>(Constants.PHOTOS_STORE_KEY) as data_preferences.Preferences;
      pref.put(Constants.IS_FIRST_TIME_DELETE, false).then(() => {
        Log.debug(TAG, `Succeeded in putting the value of '${Constants.IS_FIRST_TIME_DELETE}'.`);
        pref.flush();
      }).catch((err: BusinessError) => {
        Log.error(TAG, `Failed to put the value of '${Constants.IS_FIRST_TIME_DELETE}'. Cause: ${err}`);
      });
    }
  }

  build() {
    Column() {
      Column() {
        if (this.isFirstTimeDelete) {
          Image($r('app.media.first_delete_dialog_ico'))
            .objectFit(ImageFit.Cover)
            .height($r('app.float.first_delete_dialog_ico_height'))
            .width($r('app.float.first_delete_dialog_ico_width'))
            .margin({
              bottom: $r('app.float.first_delete_dialog_ico_margin_bottom')
            })
        }

        Text(this.dialogMessage)
          .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .textAlign(TextAlign.Center)

        if (this.isFirstTimeDelete) {
          Text($r('app.plural.first_delete_message', Constants.RECYCLE_DAYS_MAX, Constants.RECYCLE_DAYS_MAX))
            .textAlign(TextAlign.Center)
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .margin({ top: $r('app.float.first_delete_message_margin_top') })
        }
      }
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .margin({
        top: $r('app.float.dialog_content_margin'),
        bottom: $r('app.float.dialog_button_and_text_margin')
      })


      Stack({ alignContent: Alignment.Top }) {
        Row() {
          Column() {
            Button() {
              Text($r('app.string.dialog_cancel'))
                .fontSize($r('sys.float.ohos_id_text_size_button1'))
                .fontColor($r('app.color.color_control_highlight'))
                .fontWeight(FontWeight.Medium)
                .width('100%')
                .textAlign(TextAlign.Center)
            }
            .key('DeleteDialogCancelButton')
            .margin({
              right: $r('app.float.dialog_double_buttons_margin_right')
            })
            .backgroundColor(this.isPcDevice ? $r('sys.color.ohos_id_color_button_normal') : $r('app.color.transparent'))
            .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
            .height($r('app.float.details_dialog_button_height'))
            .onClick(() => {
              Log.debug(TAG, `cancelCallback`);
              this.controller?.close();
              this.dialogCallback && this.dialogCallback.cancelCallback();
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
              Text(this.confirmText)
                .fontSize($r('sys.float.ohos_id_text_size_button1'))
                .fontColor($r('sys.color.ohos_id_color_warning'))
                .fontWeight(FontWeight.Medium)
                .width('100%')
                .textAlign(TextAlign.Center)
            }
            .key('DeleteDialogConfirmButton')
            .margin({
              left: $r('app.float.dialog_double_buttons_margin_left')
            })
            .backgroundColor(this.isPcDevice ? $r('sys.color.ohos_id_color_button_normal') : $r('app.color.transparent'))
            .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
            .height($r('app.float.details_dialog_button_height'))
            .onClick(() => {
              Log.debug(TAG, `confirmCallback`);
              this.controller?.close();
              this.dialogCallback && this.dialogCallback.confirmCallback();
            })
          }.width('50%')
        }
      }
      .width('100%')
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
    .alignItems(HorizontalAlign.Center)
    .shadow({
      radius: $r('app.float.dialog_defult_shadow_m_radio'),
      color: $r('app.color.dialog_defult_shadow_m_color'),
      offsetX: $r('app.float.dialog_defult_shadow_m_offsetX'),
      offsetY: $r('app.float.dialog_defult_shadow_m_offsetY')
    })
  }
}
