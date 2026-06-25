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
import lazy { DialogCallback } from '../../model/common/DialogUtil';
import lazy { Log } from '../../utils/Log';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { BroadCastManager } from '../../model/common/BroadCastManager';
import lazy { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { Constants } from '../../model/common/Constants';

const TAG: string = 'common_SubScreenDeleteDialog';

@CustomDialog
export struct SubScreenDeleteDialog {
  @Consume dialogCallback?: DialogCallback;
  @Consume dialogBroadCast: BroadCast;
  @Consume dialogMessage: Resource;
  public controller?: CustomDialogController;
  public appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @Prop private mediaType: number = 0;

  aboutToAppear() {
  }

  aboutToDisappear() {
  }

  build() {
    this.isFromSubScreenDelete();
  }

  @Builder
  isFromSubScreenDelete() {
    // lem外屏的删除界面
    Stack() {
      Column() {
      }
      .key('PhotoBrowserBg')
      .backgroundColor('#000000')
      .width('100%')
      .height('100%')
      .clip(DeviceInfo.isPhonePSD() ? true : new Circle({ width: '100%', height: '100%' }))

      Column() {
        Column() {
          Text(this.mediaType ===
          UserFileManagerAccess.MEDIA_TYPE_VIDEO ?
          $r('app.string.recycle_video_tips') : $r('app.string.recycle_picture_tips')) {
          }
          .textAlign(TextAlign.Center)
          .width('100%')
          .height(22)
          .fontColor('#FFFFFF')
          .fontSize(15)
          .maxFontScale(Constants.FONT_SCALE_LEVEL3_SIZE)
        }
        .margin({
          top: DeviceInfo.isPhonePSD() ? '0vp' : '50vp',
          bottom: '15vp',
        })

        Button({ type: ButtonType.Capsule, stateEffect: true }) {
          Text($r('app.string.action_delete'))
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.warning'))
            .textAlign(TextAlign.Center)
            .maxFontScale(Constants.FONT_SCALE_LEVEL3_SIZE)
        }
        .width(120)
        .height(40)
        .backgroundColor($r('sys.color.ohos_id_color_button_normal_dark'))
        .margin({
          top: DeviceInfo.isPhonePSD() ? '11vp' : '15vp',
          bottom: DeviceInfo.isPhonePSD() ? '12vp' : '8vp',
        })
        .onClick((): void => {
          Log.debug(TAG, 'confirmCallback');
          this.dialogBroadCast.emit(BroadCastConstants.HIDE_SUB_SCREEN_DELETE_DIALOG, []);
          this.dialogCallback && this.dialogCallback?.confirmCallback?.();
          LocalStorage.getShared().set('isDeleteDialogOpen', false);
        })

        Button({ type: ButtonType.Capsule, stateEffect: true }) {
          Text($r('app.string.dialog_cancel'))
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.brand_font'))
            .textAlign(TextAlign.Center)
            .maxFontScale(Constants.FONT_SCALE_LEVEL3_SIZE)
        }
        .width(120)
        .height(40)
        .backgroundColor($r('sys.color.ohos_id_color_button_normal_dark'))
        .margin({
          top: DeviceInfo.isPhonePSD() ? '0vp' : '8vp',
        })
        .onClick((): void => {
          Log.debug(TAG, 'cancelCallback');
          this.dialogBroadCast.emit(BroadCastConstants.HIDE_SUB_SCREEN_DELETE_DIALOG, []);
          this.dialogCallback && this.dialogCallback?.cancelCallback?.();
          LocalStorage.getShared().set('isDeleteDialogOpen', false);
        })
      }
    }
  }
}
