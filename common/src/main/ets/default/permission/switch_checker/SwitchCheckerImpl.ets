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

import lazy { GlobalSwitchChecker } from './GlobalSwitchChecker';
import lazy { geoLocationManager } from '@kit.LocationKit';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { abilityAccessCtrl, common } from '@kit.AbilityKit';

/**
 * 位置、相机、录音权限即使授予了，没有打开开关的情况下，也无法正常使用
 * 所以这个三类权限的申请需要校验开关的状态，必要时需要引导用户打开全局
 * 开关
 */
export class LocationSwitchChecker extends GlobalSwitchChecker {
  isSwitchOn(): boolean {
    try {
      let locationEnabled = geoLocationManager.isLocationEnabled();
      return locationEnabled;
    } catch (err) {
      Log.error('LocationSwitchChecker', `errCode:${err.code}, message:${err.message}`);
      return false;
    }
  }

  async requestOpenSwitch(): Promise<boolean> {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    try {
      let locationSwitchOpened: boolean =
        await atManager.requestGlobalSwitch(context, abilityAccessCtrl.SwitchType.LOCATION);
      return locationSwitchOpened;
    } catch (err) {
      Log.error('LocationSwitchChecker', `requestGlobalSwitch failed data:${JSON.stringify(err)}`);
    }
    return false;
  }
}