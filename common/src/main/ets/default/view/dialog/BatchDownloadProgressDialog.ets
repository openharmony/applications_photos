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

import lazy { Log } from '../../utils/Log';
import lazy { ColumnSize, getScreen } from '../../model/common/ScreenManager';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { CancelRegistry } from '../CancelRegistry';
import lazy { CustomContentDialog } from '@ohos.arkui.advanced.Dialog';

/* instrument ignore file */
const TAG: string = 'common_DownloadProgressDialog';

@CustomDialog
export struct BatchDownloadProgressDialog {
  public controller?: CustomDialogController;
  public cancelRegistry?: CancelRegistry | undefined = new CancelRegistry();
  @StorageLink('batchDownloadProgress') @Watch('onDownloadProgressChange') downloadProgress: number = 0;
  @Consume downloadUri: string;
  /**
   * 122 = Progress宽度（getScreen().getColumnsWidth(ColumnSize.COLUMN_FOUR) -  88） - deleteProgress宽度(34)
   */
  readonly PROGRESS_MESSAGE_WIDTH: number = 154;
  /**
   * 88 = 左右padding（24 * 2） + 关闭图片宽度（24） + 图片与Progress间距(16)
   */
  readonly PROGRESS_WIDTH: number = 88;

  aboutToAppear() {
    Log.info(TAG, 'download dialog aboutToAppear.');
    this.downloadProgress = 0;
  }

  aboutToDisappear() {
    Log.info(TAG, `download dialog disappear, current downloadProgerss:${this.downloadProgress}`);
    if (this.downloadUri !== undefined && this.downloadUri.length > 0) {

    }
    if (this.downloadProgress !== 100) {
      this.cancelRegistry?.cancel();
      this.controller?.close();
    }
  }

  // 下载进度为100%时，关闭弹框
  onDownloadProgressChange(): void {
    Log.info(TAG, `download dialog progress update: ${this.downloadProgress}`);
    if (this.downloadProgress === 100) {
      this.cancelRegistry?.clear();
      this.controller?.close();
    }
  }

  build() {
    CustomContentDialog({
      contentBuilder: (): void => {
        this.progress();
      }
    })
  }

  @Builder
  progress() {
    Row() {
      Text($r('app.string.social_gallery_downloading_toast'))
        .draggable(false)
        .fontSize($r('sys.float.Body_M'))
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .width(getScreen().getColumnsWidth(ColumnSize.COLUMN_FOUR) - this.PROGRESS_MESSAGE_WIDTH)
        .fontColor($r('sys.color.font_primary'))
        .maxLines(2)
        .layoutWeight(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(`${this.downloadProgress}%`)
        .draggable(false)
        .fontSize($r('sys.float.Body_M'))
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .width($r('app.float.progress_percentage_text_width'))
        .layoutWeight(0)
        .textAlign(TextAlign.End)
        .fontColor($r('sys.color.font_secondary'))
        .margin({
          left: $r('app.float.progress_image_right_margin'),
          right: $r('sys.float.padding_level8'),
        })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({
      top: DeviceInfo.isPc() ? 0 : $r('sys.float.padding_level2'),
      bottom: $r('sys.float.padding_level1'),
    })
    .padding({
      right: $r('sys.float.padding_level12'),
    })

    Row() {
      Progress({ value: 0, total: 100, style: ProgressStyle.Linear })
        .value(this.downloadProgress)
        .color($r('sys.color.comp_background_emphasize'))
        .flexGrow(1)
        .layoutWeight(1)
        .width(getScreen().getColumnsWidth(ColumnSize.COLUMN_FOUR) - this.PROGRESS_WIDTH)
        .margin({
          right: $r('app.float.progress_image_right_margin'),
        })
      Image($r('app.media.ic_public_close_filled'))
        .draggable(false)
        .width($r('app.float.icon_size'))
        .height($r('app.float.icon_size'))
        .fillColor($r('sys.color.icon_secondary'))
        .layoutWeight(0)
        .accessibilityText($r('app.string.save_dialog_cancel_text'))
        .accessibilityRole(AccessibilityRoleType.BUTTON)
        .onClick((): void => {
          Log.info(TAG, 'download cancel');
          if (this.downloadUri !== undefined && this.downloadUri.length > 0) {

          }
          this.cancelRegistry?.cancel();
          this.controller?.close();
        })
    }
    .width('100%')
    .margin({
      top: $r('sys.float.padding_level1'),
      bottom: DeviceInfo.isPc() ? 0 : $r('sys.float.padding_level2'),
    })
  }
}
