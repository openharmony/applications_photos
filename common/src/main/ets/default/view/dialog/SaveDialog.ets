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
import { ColumnSize, ScreenManager } from '../../model/common/ScreenManager';
import { BroadCastConstants } from '../../model/common/BroadCastConstants';
import { Constants } from '../../model/common/Constants';

@Observed
export class SaveDialogCallback {
  public saveAsNewCallback: Function = (): void => {};
  public replaceOriginalCallback: Function = (): void => {};
}

@Extend(Text) 
function buttonTextExtend() {
  .fontSize($r('sys.float.ohos_id_text_size_button1'))
  .fontColor($r('app.color.color_control_highlight'))
  .textAlign(TextAlign.Center)
  .fontWeight(FontWeight.Medium)
}

@Extend(Button) 
function verticalButtonExtend(isPcDevice: boolean) {
  .width('100%')
  .height($r('app.float.details_dialog_button_height'))
  .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
  .backgroundColor(isPcDevice ? $r('sys.color.ohos_id_color_button_normal') : $r('app.color.transparent'))
}

@CustomDialog
export struct SaveDialog {
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  @Consume broadCast: BroadCast;
  @Consume saveDialogCallback: SaveDialogCallback;
  controller?: CustomDialogController;
  readonly buttonWidth: number = 100 / 3;
  private isPcDevice: boolean = AppStorage.get<string>('deviceType') === Constants.PC_DEVICE_TYPE;

  @Builder
  horizontalThreeButtons() {
    Stack({ alignContent: Alignment.Top }) {
      Row() {
        Column() {
          Button() {
            Text($r('app.string.save_dialog_cancel_text'))
              .width('100%')
              .buttonTextExtend()
          }
          .key('Cancel')
          .margin({ left: $r('app.float.dialog_double_buttons_margin_left') })
          .backgroundColor($r('app.color.transparent'))
          .height($r('app.float.details_dialog_button_height'))
          .onClick(() => {
            this.controller?.close();
          })
        }.width(`${this.buttonWidth}%`)

        Column() {
          Button() {
            Text($r('app.string.save_dialog_overwrite_text'))
              .width('100%')
              .buttonTextExtend()
          }
          .key('Replace')
          .margin({
            left: $r('app.float.dialog_double_buttons_margin_left'),
            right: $r('app.float.dialog_double_buttons_margin_right')
          })
          .backgroundColor($r('app.color.transparent'))
          .height($r('app.float.details_dialog_button_height'))
          .onClick(() => {
            this.broadCast.emit(BroadCastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG, []);
            this.controller?.close();
            this.saveDialogCallback && this.saveDialogCallback.replaceOriginalCallback()
          })
        }.width(`${this.buttonWidth}%`)

        Column() {
          Button() {
            Text($r('app.string.save_dialog_save_text'))
              .width('100%')
              .buttonTextExtend()
          }
          .key('SaveAsNew')
          .margin({
            right: $r('app.float.dialog_double_buttons_margin_right')
          })
          .backgroundColor($r('app.color.transparent'))
          .height($r('app.float.details_dialog_button_height'))
          .onClick(() => {
            this.controller?.close();
            this.broadCast.emit(BroadCastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG, []);
            this.saveDialogCallback && this.saveDialogCallback.saveAsNewCallback()
          })
        }.width(`${this.buttonWidth}%`)
      }.margin({
        left: $r('app.float.dialog_button_indent_margin'),
        right: $r('app.float.dialog_button_indent_margin')
      })
    }
    .width('100%')
    .height($r('app.float.details_dialog_button_area_height'))
  }

  @Builder
  verticalThreeButtons() {
    Column() {
      Column() {
        Button() {
          Text($r('app.string.save_dialog_save_text'))
            .buttonTextExtend()
        }
        .key('SaveAsNew')
        .verticalButtonExtend(this.isPcDevice)
        .margin({ bottom: $r('app.float.vertical_three_buttons_margin_bottom') })
        .onClick(() => {
          this.controller?.close();
          this.broadCast.emit(BroadCastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG, []);
          this.saveDialogCallback && this.saveDialogCallback.saveAsNewCallback()
        })
      }.width('100%')

      Column() {
        Button() {
          Text($r('app.string.save_dialog_overwrite_text'))
            .buttonTextExtend()
        }
        .key('Replace')
        .verticalButtonExtend(this.isPcDevice)
        .margin({ bottom: $r('app.float.vertical_three_buttons_margin_bottom') })
        .onClick(() => {
          this.broadCast.emit(BroadCastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG, []);
          this.controller?.close();
          this.saveDialogCallback && this.saveDialogCallback.replaceOriginalCallback()
        })
      }

      Column() {
        Button() {
          Text($r('app.string.save_dialog_cancel_text'))
            .buttonTextExtend()
        }
        .key('Cancel')
        .verticalButtonExtend(this.isPcDevice)
        .onClick(() => {
          this.controller?.close();
        })
      }.width('100%')
    }
    .margin({
      right: $r('app.float.image_save_dialog_button_margin'),
      left: $r('app.float.image_save_dialog_button_margin'),
      bottom: this.isPcDevice ? $r('app.float.pc_image_save_dialog_button_margin_bottom') : $r('app.float.image_save_dialog_button_margin_bottom'),
    })
  }

  build() {
    Column() {
      Text($r('app.string.save_dialog_title_text'))
        .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)
        .height($r('app.float.title_default'))
        .padding({ left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin') })

      Text($r('app.string.save_dialog_context_text'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .margin({ bottom: $r('sys.float.ohos_id_elements_margin_vertical_l') })
        .padding({ left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin') })

      this.verticalThreeButtons()
    }
    .alignItems(HorizontalAlign.Start)
    .width(this.isPcDevice ? $r('app.float.pc_dialog_width') : ScreenManager.getInstance()
                                                                 .getColumnsWidth(ColumnSize.COLUMN_FOUR))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('sys.float.ohos_id_corner_radius_dialog'))
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
