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

import lazy common from '@ohos.app.ability.common';
import lazy Want from '@ohos.app.ability.Want';
import lazy { BusinessError } from '@ohos.base';
import lazy { Log } from './Log';

export enum NavEntryKey {
  BIOMETRICS_PASSWORD_ENTRY = 'biometrics_and_password_settings', // Phone HOME-生物识别和密码二级页面
}

const TAG: string = 'LockAuthenticCation';

@Observed
export class LockAuthenticCation {
  constructor() {
  }

  // 显示拉起设置应用的WLAN页面
  startSettingsWifiSettingsAbilityExplicit(): void {
    let context = getContext(this) as common.UIAbilityContext;
    let want: Want = {
      bundleName: 'com.ohos.settings',
      abilityName: 'com.ohos.settings.MainAbility',
      uri: 'biometrics_and_password_settings',
      parameters: {},
    }
    context?.startAbility(want)
      .then((res) => {
        Log.info(TAG, `Started successfully res:${res}`);
      })
      .catch((err: BusinessError) => {
        Log.error(TAG, `Failed to startAbility. ${err}, code: ${err?.code}`);
      });
  }
}

/**
 * 隐藏相册安全控件接口返回参数,供PC、pad、phone使用
 *
 */

export enum LockResult {
  SUCCESS = 12500000, // 执行成功。
  FAIL = 12500001, // 认证失败。
  GENERAL_ERROR = 12500002, // 操作通用错误。
  CANCELED = 12500003, // 操作取消。
  TIMEOUT = 12500004, // 操作超时。
  TYPE_NOT_SUPPORT = 12500005, // 不支持的认证类型。
  TRUST_LEVEL_NOT_SUPPORT = 12500006, // 不支持的认证等级。
  BUSY = 12500007, // 忙碌状态。
  LOCKED = 12500009, // 认证器已锁定。
  NOT_ENROLLED = 12500010, // 用户未录入认证信息
}