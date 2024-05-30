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

import { BroadCastConstants } from '../../model/common/BroadCastConstants';
import { BroadCast } from '../../utils/BroadCast';
import { ColumnSize, ScreenManager } from '../../model/common/ScreenManager';
import { Constants } from '../../model/common/Constants';

@CustomDialog
export struct SaveImageDialog {
  @Consume broadCast: BroadCast
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  controller?: CustomDialogController;
  private isPcDevice: boolean = AppStorage.get<string>('deviceType') === Constants.PC_DEVICE_TYPE;

  controllerClose() {
    this.controller?.close();
  }

  aboutToAppear() {
    this.broadCast.on(BroadCastConstants.EXIT_SAVE_PROGRESS_CLOSE, (): void => this.controllerClose());
  }

  aboutToDisappear(): void {
    this.broadCast.off(BroadCastConstants.EXIT_SAVE_PROGRESS_CLOSE, (): void => {});
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.edit_save_picture_text')).fontSize($r('sys.float.ohos_id_text_size_body1'))
          .flexGrow(1)
        LoadingProgress()
          .width($r('app.float.loading_progress_size'))
          .height($r('app.float.loading_progress_size'))
          .margin({
            left: $r('app.float.loading_progress_left_margin')
          })
      }
      .margin({ bottom: $r('app.float.dialog_content_margin'), top: $r('app.float.dialog_content_margin') })
      .height(48)
      .width('100%')
    }
    .alignItems(HorizontalAlign.Start)
    .width(this.isPcDevice ? $r('app.float.pc_dialog_width') : ScreenManager.getInstance()
                                                                 .getColumnsWidth(ColumnSize.COLUMN_FOUR))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
    .margin({
      right: $r('app.float.dialog_content_margin'),
      left: $r('app.float.dialog_content_margin'),
      bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + this.leftBlank[3]
    })
    .padding({ left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin') })
    .shadow({
      radius: $r('app.float.dialog_defult_shadow_m_radio'),
      color: $r('app.color.dialog_defult_shadow_m_color'),
      offsetX: $r('app.float.dialog_defult_shadow_m_offsetX'),
      offsetY: $r('app.float.dialog_defult_shadow_m_offsetY')
    })
  }
}