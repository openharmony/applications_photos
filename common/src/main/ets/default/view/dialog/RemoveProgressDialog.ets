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

const TAG: string = 'common_RemoveProgressDialog';

@Observed
export class RemoveProgressParam {
  public currentCount: number = 0;
  public totalCount: number = 0;
  public message?: Resource
}

@CustomDialog
export struct RemoveProgressDialog {
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  controller?: CustomDialogController
  @Consume removeProgress: number;
  @Consume removeProgressParam: RemoveProgressParam;
  private isPcDevice: boolean = AppStorage.get<string>('deviceType') === Constants.PC_DEVICE_TYPE;

  build() {
    Column() {
      Row() {
        Text(this.removeProgressParam.message)
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(`${this.removeProgressParam.currentCount}/${this.removeProgressParam.totalCount}`)
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .flexGrow(1)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(`${this.removeProgress}%`)
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      }
      .width('100%')
      .margin({
        top: $r('app.float.process_bar_text_margin_top'),
        bottom: $r('app.float.process_bar_text_margin_bottom')
      })

      Row() {
        Progress({ value: 0, total: 100, style: ProgressStyle.Linear })
          .value(this.removeProgress)
          .color($r('app.color.color_control_highlight'))
      }
      .width('100%')
      .margin({
        top: $r('app.float.process_bar_progress_margin_top'),
        bottom: $r('app.float.process_bar_progress_margin_bottom')
      })
    }
    .padding({
      left: $r('app.float.max_padding_start'),
      right: $r('app.float.max_padding_end'),
      top: $r('app.float.max_padding_start'),
      bottom: $r('app.float.max_padding_end'),
    })
    .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
    .width(this.isPcDevice ? $r('app.float.pc_dialog_width') : ScreenManager.getInstance()
                                                                 .getColumnsWidth(ColumnSize.COLUMN_FOUR))
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
