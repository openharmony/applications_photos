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

import lazy { ColumnSize, getScreen, isOrientationHorizontal } from '../../model/common/ScreenManager';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';

/* instrument ignore file */
const TAG: string = 'common_CopyOrMoveDialog';

@Observed
export class OperateParam {
  copyFunc: Function = (): void => {
  };
}

@CustomDialog
export struct CopyOrMoveDialog {
  public static readonly INTERNAL_PREFIX_NUM: number = 3;
  public static readonly EXTERNAL_PREFIX_NUM: number = 2;
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = getScreen().isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] = getScreen().getLeftBlank();
  public controller?: CustomDialogController;
  public dataTime: string = '';
  @Consume operateParam: OperateParam;

  aboutToAppear() {

  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.copy_or_move'))
          .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
      }.alignItems(VerticalAlign.Center)
      .height($r('app.float.dialog_title_height'))


      Row() {
        Text($r('app.string.add'))
          .fontSize($r('sys.float.Subtitle_M'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor($r('sys.color.font_primary'))
      }
      .height($r('app.float.dialog_list_card_height'))
      .width('100%')
      .key('Copy')
      .onClick((): void => {
        this.controller?.close();
        this.operateParam.copyFunc();
      })


      Divider()
        .vertical(false)
        .color($r('sys.color.comp_divider'))
        .width('100%')

      Stack({ alignContent: Alignment.Top }) {
        Button() {
          Text($r('app.string.dialog_cancel'))
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_emphasize'))
            .width('100%')
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Medium)
        }
        .backgroundColor(DeviceInfo.isPc() ?
        $r('sys.color.comp_background_tertiary') : Color.Transparent)
        .height($r('app.float.details_dialog_button_height'))
        .key('Cancel')
        .onClick((): void => {
          this.controller?.close();
        })
        .margin({
          left: $r('app.float.dialog_single_button_indent_margin'),
          right: $r('app.float.dialog_single_button_indent_margin'),
        })
      }.width('100%')
      .height(DeviceInfo.isPc() ?
      $r('app.float.details_dialog_button_area_height_pc') : $r('app.float.details_dialog_button_area_height'))
    }
    .padding({ left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin') })
    .alignItems(HorizontalAlign.Start)
    .borderRadius($r('sys.float.corner_radius_level16'))
    .width(DeviceInfo.isPc() ? $r('app.float.pc_dialog_width') : getScreen()
      .getColumnsWidth(ColumnSize.COLUMN_FOUR))
    .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
    .margin({
      right: $r('sys.float.padding_level6'),
      left: $r('sys.float.padding_level6'),
      bottom: $r('app.float.navigation_margin_bottom'),
    })
    .shadow({
      radius: $r('app.float.dialog_default_shadow_m_radio'),
      color: $r('app.color.dialog_default_shadow_m_color'),
      offsetX: $r('app.float.dialog_default_shadow_m_offsetX'),
      offsetY: $r('app.float.dialog_default_shadow_m_offsetY'),
    })
  }
}
