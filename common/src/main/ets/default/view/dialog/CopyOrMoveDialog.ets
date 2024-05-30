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
import { ColumnSize, ScreenManager } from '../../model/common/ScreenManager';
import { Constants } from '../../model/common/Constants';

const TAG: string = 'common_CopyOrMoveDialog';

@Observed
export class OperateParam {
  public moveFunc: Function = (): void => {};
  public copyFunc: Function = (): void => {};
}

@CustomDialog
export struct CopyOrMoveDialog {
  static readonly INTERNAL_PREFIX_NUM = 3;
  static readonly EXTERNAL_PREFIX_NUM = 2;
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  controller?: CustomDialogController;
  dataTime: string = '';
  @Consume operateParam: OperateParam;
  private isPcDevice: boolean = AppStorage.get<string>('deviceType') === Constants.PC_DEVICE_TYPE;

  aboutToAppear() {

  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.copy_or_move'))
          .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }.alignItems(VerticalAlign.Center)
      .height($r('app.float.dialog_title_height'))


      Row() {
        Column() {
          Text($r('app.string.add'))
            .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
        }
      }
      .height($r('app.float.dialog_list_card_height'))
      .width('100%')
      .key('Copy')
      .onClick(() => {
        this.controller?.close();
        this.operateParam.copyFunc();
      })


      Divider()
        .vertical(false)
        .color($r('sys.color.ohos_id_color_list_separator'))
        .width('100%')

      Row() {
        Column() {
          Text($r('app.string.move'))
            .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
        }

      }
      .height($r('app.float.dialog_list_card_height'))
      .width('100%')
      .onClick(() => {
        this.controller?.close();
        this.operateParam.moveFunc();
      })

      Stack({ alignContent: Alignment.Top }) {
        Button() {
          Text($r('app.string.cancel_button'))
            .fontSize($r('sys.float.ohos_id_text_size_button1'))
            .fontColor($r('app.color.color_control_highlight'))
            .width('100%')
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Medium)
        }
        .backgroundColor(this.isPcDevice ?
        $r('sys.color.ohos_id_color_button_normal') : $r('app.color.transparent'))
        .height($r('app.float.details_dialog_button_height'))
        .key('Cancel')
        .onClick(() => {
          this.controller?.close();
        })
        .margin({
          left: $r('app.float.dialog_single_button_indent_margin'),
          right: $r('app.float.dialog_single_button_indent_margin')
        })
      }.width('100%')
      .height($r('app.float.details_dialog_button_area_height'))
    }
    .padding({ left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin') })
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
