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

import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { ColumnSize, getScreen, isOrientationHorizontal } from '../../model/common/ScreenManager';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { UiUtil } from '../../utils/UiUtil';
import lazy { Log } from '../../utils/Log';

const TAG: string = 'SaveImageDialog';

@CustomDialog
export struct SaveImageDialog {
  @Consume broadCast: BroadCast;
  public controller?: CustomDialogController;
  private onExitSaveProgressCloseFunc: Function = (): void => this.controllerClose();

  /* instrument ignore file */
  controllerClose(): void {
    Log.info(TAG, 'controllerClose');
    this.controller?.close();
  }

  aboutToAppear() {
    this.broadCast.on(BroadCastConstants.EXIT_SAVE_PROGRESS_CLOSE, this.onExitSaveProgressCloseFunc);
  }

  aboutToDisappear(): void {
    this.broadCast?.off(BroadCastConstants.EXIT_SAVE_PROGRESS_CLOSE, this.onExitSaveProgressCloseFunc);
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.edit_save_picture_text'))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontColor($r('sys.color.font_primary'))
          .maxFontScale(3.2)
          .width('calc(100% - 56vp)')
        LoadingProgress()
          .width($r('app.float.dialog_add_notes_content_height'))
          .height($r('app.float.dialog_add_notes_content_height'))
          .margin({
            left: $r('app.float.loading_progress_left_margin'),
          })
      }
      .margin({ bottom: $r('app.float.dialog_content_margin'), top: $r('app.float.dialog_content_margin') })
      .width('100%')
    }
    .alignItems(HorizontalAlign.Start)
    .width(DeviceInfo.isPc() ? $r('app.float.pc_dialog_width') : getScreen()
      .getColumnsWidth(ColumnSize.COLUMN_FOUR))
    .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
    .borderRadius($r('sys.float.ohos_id_corner_radius_dialog'))
    .margin({
      right: $r('sys.float.ohos_id_dialog_margin_end'),
      left: $r('sys.float.ohos_id_dialog_margin_start'),
    })
    .padding({ left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin') })
    .shadow({
      radius: $r('app.float.dialog_default_shadow_m_radio'),
      color: $r('app.color.dialog_default_shadow_m_color'),
      offsetX: $r('app.float.dialog_default_shadow_m_offsetX'),
      offsetY: $r('app.float.dialog_default_shadow_m_offsetY'),
    })
  }
}