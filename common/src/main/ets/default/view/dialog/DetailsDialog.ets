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
import { DateUtil } from '../../utils/DateUtil';
import { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import { ColumnSize, ScreenManager } from '../../model/common/ScreenManager';
import { Constants } from '../../model/common/Constants';
import { DetailsDialogComponent } from '../DetailsDialogComponent';

const TAG: string = 'common_DetailsDialog';

@Observed
export class MediaDetails {
  public mediaType: number = 0;
  public height: number = 0;
  public width: number = 0;
  public size: number = 0;
  public duration: number = 0;
  public title: string = '';
  public dateTaken: number = 0;
  public uri: string = '';
  public displayName: string = '';
  public dateModified: number = 0;
}

@CustomDialog
export struct DetailsDialog {
  static readonly INTERNAL_PREFIX_NUM = 3;
  static readonly EXTERNAL_PREFIX_NUM = 2;
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  sizeConvert = 1024;
  controller?: CustomDialogController;
  dataTime: string = '';
  @Consume mediaDetails: MediaDetails;
  @Consume isDistributedAlbum: boolean;
  @State refresh: boolean = false;
  private isPcDevice: boolean = AppStorage.get<string>('deviceType') === Constants.PC_DEVICE_TYPE;
  onWindowSizeChangeCallBack = (): void => this.updateDialogSize();

  aboutToAppear() {
    let localizedDate = DateUtil.getLocalizedDate(this.mediaDetails.dateTaken);
    let localizedTime = DateUtil.getLocalizedTime(this.mediaDetails.dateTaken);
    this.dataTime = `${localizedDate} ${localizedTime}`;
    let self = this;

    ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    ScreenManager.getInstance().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
  }

  getResolution(height: number, width: number): string {
    return `${width}x${height}`;
  }

  getTitle() {
    Log.info(TAG, 'getTitle');
    if (this.mediaDetails.title) {
      return this.mediaDetails.title;
    }
    let index = this.mediaDetails.displayName.lastIndexOf('.');
    return this.mediaDetails.displayName.substr(0, index);
  }

  getSize(size: number): string {
    Log.info(TAG, `file size is: ${size}`);
    if (size / (this.sizeConvert * this.sizeConvert) > 1) {
      return `${(size / (this.sizeConvert * this.sizeConvert)).toFixed(2)}MB`;
    } else {
      return `${(size / this.sizeConvert).toFixed(2)}KB`;
    }
  }

  updateDialogSize() {
    this.refresh = !this.refresh;
  }

  build() {
    Column() {
      if (this.refresh && false) {
        Column()
      }
      Row() {
        Text($r('app.string.details'))
          .key('DetailsBigTitle')
          .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }.alignItems(VerticalAlign.Center)
      .height($r('app.float.dialog_title_height'))

      DetailsDialogComponent({
        title: $r('app.string.title'),
        content: this.getTitle(),
        keyForAutoTest: Constants.KEY_FOR_AUTO_TEST_TITLE
      })
      DetailsDialogComponent({
        title: $r('app.string.time'),
        content: this.dataTime,
        keyForAutoTest: Constants.KEY_FOR_AUTO_TEST_TIME
      })
      DetailsDialogComponent({
        title: $r('app.string.size'),
        content: `${this.getSize(this.mediaDetails.size)}`,
        keyForAutoTest: Constants.KEY_FOR_AUTO_TEST_SIZE
      })
      DetailsDialogComponent({
        title: $r('app.string.resolution'),
        content: this.getResolution(this.mediaDetails.height, this.mediaDetails.width),
        isLast: this.mediaDetails.mediaType != UserFileManagerAccess.MEDIA_TYPE_VIDEO && this.isDistributedAlbum,
        keyForAutoTest: Constants.KEY_FOR_AUTO_TEST_RESOLUTION
      })
      if (this.mediaDetails.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        DetailsDialogComponent({
          title: $r('app.string.duration'),
          content: DateUtil.getFormattedDuration(this.mediaDetails.duration),
          isLast: this.isDistributedAlbum != null && this.isDistributedAlbum,
          keyForAutoTest: Constants.KEY_FOR_AUTO_TEST_DURATION
        })
      }

      Stack({ alignContent: Alignment.Top }) {
        Button() {
          Text($r('app.string.detail_dialog_confirm'))
            .fontSize($r('sys.float.ohos_id_text_size_button1'))
            .fontColor($r('app.color.color_control_highlight'))
            .width('100%')
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Medium)
        }
        .key('DetailsDialogConfirm')
        .backgroundColor(this.isPcDevice ? $r('sys.color.ohos_id_color_button_normal') : $r('app.color.transparent'))
        .height($r('app.float.details_dialog_button_height'))
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
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
    .width(this.isPcDevice ? $r('app.float.pc_dialog_width') : ScreenManager.getInstance()
                                                                 .getColumnsWidth(ColumnSize.COLUMN_FOUR))
    .backgroundColor($r('app.color.white'))
    .margin({
      right: $r('app.float.dialog_window_margin'),
      left: $r('app.float.dialog_window_margin'),
      bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + this.leftBlank[3]
    })
    .padding({ left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin') })
    .alignItems(HorizontalAlign.Start)
    .shadow({
      radius: $r('app.float.dialog_defult_shadow_m_radio'),
      color: $r('app.color.dialog_defult_shadow_m_color'),
      offsetX: $r('app.float.dialog_defult_shadow_m_offsetX'),
      offsetY: $r('app.float.dialog_defult_shadow_m_offsetY')
    })
  }
}
