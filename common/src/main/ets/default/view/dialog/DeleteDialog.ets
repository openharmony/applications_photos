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
import lazy { Constants } from '../../model/common/Constants';
import lazy data_preferences from '@ohos.data.preferences';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { BusinessError } from '@ohos.base';
import lazy { BroadCastManager } from '../../model/common/BroadCastManager';
import lazy { AlertDialog } from '@ohos.arkui.advanced.Dialog';
import lazy { ButtonOptions } from '../../utils/ButtonOptionUtil';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { FocusUtil } from '../../utils/FocusUtil';
import lazy { ShortCut } from '../../model/ShortCut';

const TAG: string = 'common_DeleteDialog';

@CustomDialog
export struct DeleteDialog {
  public confirmCallback: Function | undefined = undefined;
  public cancelCallback: Function | undefined = undefined;
  @State public dialogBroadCast: BroadCast = new BroadCast();
  @State public dialogMessage: Resource = $r('app.string.common_place_holder', String(''));
  @State dialogContent: Resource = $r('app.string.common_place_holder', String(''));
  public controller?: CustomDialogController;
  public appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @StorageLink('isFirstTimeDelete') isFirstTimeDelete: boolean = false;
  @StorageLink('confirmText') confirmText: Resource = $r('app.string.dialog_delete');
  @StorageLink('isShowDeleteFollowDialog') isShow: boolean = false;
  @State public isAlbumDelete: boolean = false;
  private title: Resource = $r('app.string.common_place_holder', '');
  private content: Resource = $r('app.string.common_place_holder', '');
  private cancelButton: ButtonOptions = {
    defaultFocus: false,
    value: $r('app.string.dialog_cancel'),
    fontColor: DeviceInfo.isTv() ? $r('sys.color.font') : undefined,
    action: (): void => {
      Log.info(TAG, 'primaryButton onclick');
      ShortCut.deleteDialogOpenFlag = false;
      this.isShow = false;
      this.dialogBroadCast.emit(BroadCastConstants.HIDE_DELETE_DIALOG, []);
      BroadCastManager.getInstance().getBroadCast().emit(BroadCastConstants.HIDE_DELETE_DIALOG, []);
      this.cancelCallback?.();
    },
  };
  private confirmButton: ButtonOptions = {
    defaultFocus: true,
    value: this.confirmText,
    fontColor: DeviceInfo.isTv() ? $r('sys.color.font') : $r('sys.color.warning'),
    background: DeviceInfo.isTv() ? $r('app.color.tv_delete_dialog_button_bg') : undefined,
    action: (): void => {
      Log.info(TAG, 'secondaryButton onclick');
      ShortCut.deleteDialogOpenFlag = false;
      this.isShow = false;
      this.dialogBroadCast.emit(BroadCastConstants.HIDE_DELETE_DIALOG, []);
      this.confirmCallback?.();
      FocusUtil.clearFocus(this.getUIContext()?.getFocusController());
    },
  };

  aboutToAppear() {
    Log.info(TAG, 'DeleteDialog aboutToAppear');
    this.title = this.dialogMessage;
    this.content = this.dialogContent;
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      FocusUtil.activateFocus(this.getUIContext()?.getFocusController());
      AppStorage.setOrCreate<boolean>('hasDeleteDialog', true);
    }
  }

  public async aboutToDisappear() {
    Log.info(TAG, 'DeleteDialog aboutToDisappear');
    this.appBroadCast.emit(BroadCastConstants.HAS_CLICKED_ALBUM_DELETE_BUTTON, []);
    await this.putIsFirstTimeDelete();
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      AppStorage.setOrCreate<boolean>('hasDeleteDialog', false);
      // 删除弹窗出现后，键盘CTRL与shift设置为false
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHIFT_PRESS, false);
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_CTRL_PRESS, false);
    }
  }

  private putIsFirstTimeDelete(): void {
    if (this.isFirstTimeDelete && !this.isAlbumDelete) {
      AppStorage.setOrCreate(Constants.IS_FIRST_TIME_DELETE, false);
      let pref: data_preferences.Preferences =
        AppStorage.get<data_preferences.Preferences>(Constants.PHOTOS_STORE_KEY) as data_preferences.Preferences;
      pref.put(Constants.IS_FIRST_TIME_DELETE, false).then((): void => {
        Log.debug(TAG, `Succeeded in putting the value of '${Constants.IS_FIRST_TIME_DELETE}'.`);
        pref.flush();
      }).catch((err: BusinessError) => {
        Log.error(TAG, `Failed to put the value of '${
        Constants.IS_FIRST_TIME_DELETE}'. Cause: ${err}, code: ${err?.code}`);
      });
    }
  }

  build() {
    this.delete();
  }

  @Builder
  delete() {
    AlertDialog({
      primaryTitle: this.title,
      content: this.content,
      primaryButton: this.cancelButton,
      secondaryButton: this.confirmButton,
    })
  }
}
