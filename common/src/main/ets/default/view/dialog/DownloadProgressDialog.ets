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
import lazy { ColumnSize, getScreen, ScreenManager } from '../../model/common/ScreenManager';
import lazy { Constants } from '../../model/common/Constants';
import lazy { CustomContentDialog } from '@ohos.arkui.advanced.Dialog';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';

/* instrument ignore file */
const TAG: string = 'common_DownloadProgressDialog';

const VDE_PROGRESS_WIDTH: number = 120;

@CustomDialog
export struct DownloadProgressDialog {
  controller?: CustomDialogController
  @StorageLink(Constants.APP_STORAGE_KEY_DOWNLOAD_PROGRESS) @Watch('onDownloadProgressChange') downloadProgress:
    number = 0;
  @Consume downloadUri: string;
  /**
   * 122 = Progress宽度（getScreen().getColumnsWidth(ColumnSize.COLUMN_FOUR) -  88） - deleteProgress宽度(34)
   */
  readonly PROGRESS_MESSAGE_WIDTH: number = 154;
  /**
   * 84 = 左右padding（24 * 2） + 关闭图片宽度（24） + 图片与Progress间距(12)
   */
  readonly PROGRESS_WIDTH: number = 84;

  /**
   * 316 = pc弹框固定长度400 - (左右padding（24 * 2） + 关闭图片宽度（24） + 图片与Progress间距(12))
   */
  readonly PC_PROGRESS_WIDTH: number = 316;
  @State textWidth: number = 0;
  @State progressWidth: number = 0;
  private onWindowSizeChangedFun: Function = (): void => this.onWindowSizeChanged();
  @State isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();

  private onWindowSizeChanged(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
    this.textWidth = getScreen().getColumnsWidth(ColumnSize.COLUMN_THREE) -
      (this.isVerdeFoldable ? VDE_PROGRESS_WIDTH : this.PROGRESS_MESSAGE_WIDTH);
    this.progressWidth = getScreen().getColumnsWidth(ColumnSize.COLUMN_THREE) - this.PROGRESS_WIDTH;
    if (DeviceInfo.isPc()) {
      this.progressWidth = this.PC_PROGRESS_WIDTH;
    }
  }

  aboutToAppear() {
    Log.info(TAG, 'download dialog appear.');
    AppStorage.set<boolean>('isDownloading', true);
    this.onWindowSizeChanged();
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangedFun);
    this.downloadProgress = 0;
  }

  aboutToDisappear() {
    Log.info(TAG, 'download dialog disappear.');
    AppStorage.set<boolean>('isDownloading', false);
    AppStorage.set<boolean>('isVideoDownloading', false);
    if (this.downloadProgress !== 100) {

    }
  }

  // 下载进度为100%时，关闭弹框
  onDownloadProgressChange(): void {
    Log.info(TAG, `download dialog progress update: ${this.downloadProgress}`);
    if (this.downloadProgress === 100 || this.downloadProgress === Constants.INVALID) {
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
    Column() {
      Row() {
        Text($r('app.string.social_gallery_downloading_toast'))
          .draggable(false)
          .fontSize($r('sys.float.Body_M'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor($r('sys.color.font_primary'))
          .maxLines(1)
          .maxFontScale(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(`${this.downloadProgress}%`)
          .draggable(false)
          .fontSize($r('sys.float.Body_M'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .maxLines(1)
          .maxFontScale(2)
          .textAlign(TextAlign.End)
          .fontColor($r('sys.color.font_secondary'))
          .margin({
            right: $r('sys.float.padding_level8'),
            left: $r('app.float.progress_image_right_margin'),
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        right: $r('sys.float.padding_level12'),
      })

      Row() {
        Progress({ value: 0, total: 100, style: ProgressStyle.Linear })
          .value(this.downloadProgress)
          .color($r('sys.color.comp_background_emphasize'))
          .flexGrow(1)
          .width(this.progressWidth)
          .margin({
            right: $r('app.float.download_progress_image_right_margin'),
          })
        Image($r('app.media.xmark_circle_fill'))
          .draggable(false)
          .width($r('app.float.icon_size'))
          .height($r('app.float.icon_size'))
          .onClick((): void => {
            Log.info(TAG, 'download cancel');
            this.controller?.close();
          })
          .responseRegion({
            width: '166%',
            height: '166%',
          })
      }
      .width('100%')
    }
    .justifyContent(FlexAlign.End)
    .height($r('app.float.progress_dialog_height'))
  }
}
