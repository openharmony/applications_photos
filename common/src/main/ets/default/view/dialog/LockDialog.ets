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
import lazy { Constants } from '../../model/common/Constants';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { LockAuthenticCation } from '../../utils/LockAuthenticCation';
import lazy { ValueType } from '@ohos.data.ValuesBucket';
import lazy { DataStoreUtil } from '../../utils/DataStoreUtil';
import lazy { BroadCastManager } from '../../model/common/BroadCastManager';
import lazy { ButtonOptions, CustomContentDialog } from '@ohos.arkui.advanced.Dialog';

/* instrument ignore file */
const TAG: string = 'common_LockDialog';


@CustomDialog
export struct LockDialog {
  private cancelCallback?: Function;
  public controller?: CustomDialogController;
  @StorageLink('toSetUp') toSetUp: Resource = $r('app.string.to_set_up');
  @State isAgain: ValueType = false;
  @State isCloseTip: boolean = false;
  @State broadCast: BroadCast = new BroadCast();
  public hideLockDialog?: Function;
  @State needUnlock: boolean = true;
  @Consume vanishingState: boolean | undefined;
  public appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private buttons: ButtonOptions[] = [];

  aboutToAppear(): void {
    this.buttons.push({
      value: $r('app.string.dialog_cancel'),
      action: (): void => {
        Log.info(TAG, 'first button onclick');
        this.hideLockDialog?.();
        this.onVanishingState();
        this.broadCast.emit(BroadCastConstants.HIDE_LOCK_DIALOG, []);
        this.cancelCallback?.();
      }
    });
    this.buttons.push({
      value: this.toSetUp,
      action: (): void => {
        this.cancelLock();
        this.hideLockDialog?.();
        let certified = new LockAuthenticCation();
        certified.startSettingsWifiSettingsAbilityExplicit();
        this.broadCast.emit(BroadCastConstants.HIDE_LOCK_DIALOG, []);
        this.appBroadCast.emit(BroadCastConstants.HIDE_LOCK_DIALOG, []);
        this.cancelCallback?.();
      }
    })
  }

  cancelLock() {
    this.isTipsPermanentSet(this.isCloseTip).then(() => {
      this.hideLockDialog?.();
      this.broadCast.emit(BroadCastConstants.HIDE_LOCK_DIALOG, []);
      this.cancelCallback?.();
    })
  }

  public async isTipsPermanentSet(isAgain: ValueType): Promise<void> {
    Log.info(TAG, `isTipsPermanentSet ${isAgain}`);
    let dataStore = DataStoreUtil.getInstance();
    await dataStore.init();
    await dataStore.putData(Constants.PROMPT_AGAIN, isAgain);
    await dataStore.flush();
  }

  onVanishingState() {
    this.vanishingState = false;
  }

  build() {
    CustomContentDialog({
      contentBuilder: (): void => {
        this.buildLock();
      },
      buttons: this.buttons,
    })
  }

  @Builder
  buildLock() {
    Column() {
      Text($r('app.string.lock_tips_password'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
      Row() {
        Toggle({ type: ToggleType.Checkbox, isOn: this.isCloseTip })
          .width($r('app.float.checkbox_size'))
          .height($r('app.float.checkbox_size'))
          .margin({
            left: $r('app.float.checkbox_selected_margin'),
            right: $r('app.float.dialog_window_margin'),
          })
          .onClick((): void => {
            this.isCloseTip = !this.isCloseTip;
          })

        Text($r('app.string.not_prompt_again'))
          .fontSize($r('app.float.account_enable_cloud_font_size'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }
      .height($r('app.float.dialog_list_card_height'))
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
  }
}
