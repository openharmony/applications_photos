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
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { DateUtil } from '../../utils/DateUtil';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { ButtonOptions, CustomContentDialog } from '@kit.ArkUI';
import lazy { MoveDialogCallback } from '../../model/common/DialogUtil';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { AssetHelper } from '../../utils/AssetHelper';
import lazy { ImageUtil } from '../../utils/ImageUtil';
import lazy { Constants } from '../../model/common/Constants';
import lazy { BroadCastManager } from '../../model/common/BroadCastManager';
import lazy { UiUtil } from '../../utils/UiUtil';

export type PhotoAsset = photoAccessHelper.PhotoAsset;

/* instrument ignore file */
const TAG: string = 'common_MoveDialog';
const LIST_MARGIN: number = 24;
const TEXT_HEIGHT: number = 21;
const THUMBNAIL_IMAGE_SIZE: number = 50;

@CustomDialog
export struct MoveDialog {
  private controller?: CustomDialogController;
  @StorageLink('choiceMode') choiceMode: string = 'None';
  @Consume moveDialogCallback?: MoveDialogCallback;
  @Consume repeatPhotos: PhotoAsset[];
  private reshowProgressDialog?: Function;
  @Prop broadCast: BroadCast;
  private buttons: ButtonOptions[] = [];
  private photos: PhotoAsset[] = [];
  private isContinue: boolean = false;
  private hasSameAssets: boolean | undefined = false;
  @Consume dialogBroadCast: BroadCast;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private hdrDelayTime: number = 400;
  public static timerToHdr: number = 0;

  private getThumbnailUri(photo: PhotoAsset) {
    let sourceUri: string = photo.uri ?? '';
    let path: string = String(AssetHelper.get(photo, Constants.KEY_FILE_DATA, ''));
    let dateModified: number = Number(AssetHelper.get(photo, photoAccessHelper.PhotoKeys.DATE_MODIFIED_MS.toString()));
    return ImageUtil.getThumbnailUri(sourceUri, path, dateModified, true);
  }

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.broadCast.emit(BroadCastConstants.HIDE_PROGRESS_DIALOG, []);
    this.hasSameAssets = AppStorage.get('hasSameAssets');
    this.buttons.push({
      value: $r('app.string.replace_with_new_file'),
      action: async (): Promise<void> => {
        Log.info(TAG, 'first button onclick');
        if (this.isContinue) {
          AppStorage.set<string>('choiceMode', 'Replace');
          this.hasSameAssets = false;
        }
        this.dialogBroadCast.emit(BroadCastConstants.HIDE_MOVE_DIALOG, []);
        if (!this.hasSameAssets) {
          this.reshowProgressDialog?.();
        }
        this.moveDialogCallback && this.moveDialogCallback?.replaceCallback?.();
        Log.info(TAG, 'replace with new file execute delay hdr111');
      }
    });
    this.buttons.push({
      value: $r('app.string.skip_current_file'),
      action: async (): Promise<void> => {
        Log.info(TAG, 'second button onclick');
        if (this.isContinue) {
          AppStorage.set<string>('choiceMode', 'Skip');
          this.hasSameAssets = false;
        }
        this.dialogBroadCast.emit(BroadCastConstants.HIDE_MOVE_DIALOG, []);
        if (!this.hasSameAssets) {
          this.reshowProgressDialog?.();
        }
        this.moveDialogCallback && this.moveDialogCallback?.skipCallback?.();
      }
    });
    this.buttons.push({
      value: $r('app.string.cancel_move'),
      action: (): void => {
        Log.info(TAG, 'third button onclick');
        this.isContinue = false;
        this.dialogBroadCast.emit(BroadCastConstants.HIDE_MOVE_DIALOG, []);
        this.moveDialogCallback && this.moveDialogCallback?.cancelCallback?.();
      }
    });
    this.photos = this.repeatPhotos;
  }

  build() {
    CustomContentDialog({
      primaryTitle: $r('app.string.find_same_name'),
      contentBuilder: (): void => {
        this.buildContent();
      },
      buttons: this.buttons,
      contentAreaPadding: { right: 0, left: 0 },
    })
  }

  @Builder
  buildContent() {
    List({ space: 16 }) {
      ListItem() {
        Text($r('app.string.target_has_same_name_file'))
          .fontSize(16)
          .fontWeight(FontWeight.Regular)
          .fontColor($r('sys.color.font_primary'))
          .textAlign(TextAlign.Center)
          .width('100%')
          .lineHeight(TEXT_HEIGHT)
          .maxFontScale(1.45)
      }
      .height(TEXT_HEIGHT)
      .margin({ left: LIST_MARGIN, right: LIST_MARGIN })

      ListItem() {
        this.buildPhoto($r('app.string.source_file_location'), this.photos[0], true);
      }
      .margin({ left: LIST_MARGIN, right: LIST_MARGIN })

      ListItem() {
        Column({ space: DeviceInfo.isPc() ? 8 : 0 }) {
          this.buildPhoto($r('app.string.target_file_location'), this.photos[1]);

          Row() {
            Toggle({ type: ToggleType.Checkbox, isOn: this.isContinue })
              .width($r('app.float.checkbox_size'))
              .height($r('app.float.checkbox_size'))
              .margin({
                left: $r('app.float.checkbox_selected_margin'),
                right: $r('app.float.dialog_window_margin'),
              })
              .onClick((): void => {
                this.isContinue = !this.isContinue;
              })

            Text($r('app.string.do_same_action'))
              .fontSize($r('app.float.account_enable_cloud_font_size'))
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
          }
          .height($r('app.float.dialog_list_card_height'))
        }
        .alignItems(HorizontalAlign.Start)
      }
      .margin({ left: LIST_MARGIN, right: LIST_MARGIN })
    }
  }

  @Builder
  buildPhoto(text: Resource | string, photo: PhotoAsset, isDivider?: boolean) {
    Column() {
      Text(text)
        .fontSize($r('sys.float.padding_level8'))
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Regular)
        .textAlign(TextAlign.Start)
        .width('100%')
        .lineHeight(TEXT_HEIGHT)

      Row({ space: DeviceInfo.isPc() ? 8 : 16 }) {
        Image(this.getThumbnailUri(photo))
          .width(THUMBNAIL_IMAGE_SIZE)
          .height(THUMBNAIL_IMAGE_SIZE)
          .border({
            width: $r('app.float.album_card_border_width'),
            color: $r('app.color.album_card_border_color'),
            radius: $r('app.float.same_name_date_dialog_bottom'),
          })
          .aspectRatio(1)

        Column({ space: 2 }) {
          Text(this.photoAssetToSizeInfo(photo))
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_primary'))
            .fontWeight(FontWeight.Medium)
            .textAlign(UiUtil.isMirrorMode() ? TextAlign.End : TextAlign.Start)
            .width('100%')
            .lineHeight(TEXT_HEIGHT)
            .maxFontScale(1.45)

          Column({ space: DeviceInfo.isPc() ? 9 : 14 }) {
            Text(this.photoAssetToTimeInfo(photo))
              .fontSize($r('sys.float.Body_M'))
              .fontColor($r('sys.color.font_secondary'))
              .fontWeight(FontWeight.Regular)
              .textAlign(TextAlign.Start)
              .width('100%')
              .maxFontScale(1.45)
              .lineHeight(19)

            if (isDivider) {
              Divider();
            }
          }
        }
        .layoutWeight(1)
        .width('100%')
        .margin({ top: isDivider ? (DeviceInfo.isPc() ? 10 : 14) : 0 })
      }
      .height(DeviceInfo.isPc() ? 64 : 72)
      .alignItems(VerticalAlign.Center)
    }
  }

  private photoAssetToTimeInfo(photo: PhotoAsset): string {
    const dateAdded: number = Number(AssetHelper.get(photo, 'date_added_ms', 0));
    let photoTime = DateUtil.getLocalizedDate(dateAdded) + ` ${DateUtil.getLocalizedTime(dateAdded)}`;
    return photoTime;
  }

  private photoAssetToSizeInfo(photo: PhotoAsset): string {
    let size: number = Number(AssetHelper.get(photo, photoAccessHelper.PhotoKeys.SIZE.toString(), 0));
    return ImageUtil.getDisplaySize(size);
  }
}