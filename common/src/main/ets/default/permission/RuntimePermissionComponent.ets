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
/* instrument ignore file */

import lazy { abilityAccessCtrl, Permissions, common } from '@kit.AbilityKit';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { Log } from '../utils/Log';
import lazy PermissionGrantCallback from './PermissionGrantCallback';
import lazy { RuntimePermissionUtil } from './RuntimePermissionUtil';

const TAG: string = 'RuntimePermissionComponent';

@Component
export struct RuntimePermissionComponent {
  @Prop public permissions: Array<Permissions> = [];
  // UI占位
  @BuilderParam uiSlot: () => void = this.defaultUiContent;
  public buttonKey: string = '';

  // 默认不展示布局
  @Builder
  defaultUiContent() {
  }

  @State isNeverRefused: boolean = true;
  private onPermissionsGranted: Function = (permissions: Array<Permissions>): void => {
    Log.debug(TAG, `onPermissionsGranted, message: ${permissions.toString()}`);
  }
  private onPermissionsDenied: Function = (permissions: Array<Permissions>): void => {
    if (this.isNeverRefused) {
      this.isNeverRefused = false;
      return;
    }
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    atManager.requestPermissionOnSetting(context, permissions).then((data: Array<abilityAccessCtrl.GrantStatus>) => {
      Log.info(TAG, `requestPermissionOnSetting, data: ${JSON.stringify(data)}`);
    }).catch((err: BusinessError) => {
      Log.error(TAG, `requestPermissionOnSetting, data: ${JSON.stringify(err)}`);
    });
  }
  private onRequestPermissionsError: Function = (message: string): void => {
    Log.error(TAG, `onRequestPermissionsError, message: ${message}`);
  }
  private onAllPermissionGranted: Function = (): void => {
  }
  private callback: PermissionGrantCallback = {
    onGranted: (permissions: Permissions[]): void => {
      this.onPermissionsGranted(permissions);
    },
    onDenied: (permissions: Permissions[]): void => {
      Log.debug(TAG, `permission denied:${permissions.toString()}`);
      // 用戶拒絕後，默認的處理方式是直接拉起系統彈窗讓用戶授權，父組件可重寫
      this.onPermissionsDenied(permissions);
    },
    onError: (message: string): void => {
      Log.error(TAG, message);
      this.onRequestPermissionsError(message);
    },
    onAllPermissionGranted: (): void => {
      this.onAllPermissionGranted();
    }
  };

  build() {
    Stack() {
      this.uiSlot();
    }.onClick(() => {
      if (this.permissions?.length == 0) {
        this.onAllPermissionGranted();
        return;
      }
      const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
      RuntimePermissionUtil.checkAndRequestPermissionGrant(context, this.permissions, this.callback);
    })
    .key(this.buttonKey)
    .accessibilityRole(AccessibilityRoleType.BUTTON)
  }
}



