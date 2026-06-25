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
import { HiLog } from '../util/HiLog';
import i18n from '@ohos.i18n';
import sim from '@ohos.telephony.sim';
import { GlobalThisUtil } from './GlobalThisUtil';

export class CountryCodeUtil {
  private static LOG_TAG = 'CountryCodeUtil';

  private static async getSimCountryCode(): Promise<string> {
    try {
      if (canIUse('SystemCapability.Telephony.CoreService')) {
        let defaultSimSlotId = await sim.getDefaultVoiceSlotId();
        let data = await sim.getISOCountryCodeForSim(defaultSimSlotId);
        HiLog.i(CountryCodeUtil.LOG_TAG, `getISOCountryCodeForSim success: ${data}`);
        return data.toUpperCase();
      } else {
        HiLog.i(CountryCodeUtil.LOG_TAG, 'current device do not support sim cap.');
        return '';
      }
    } catch (e) {
      HiLog.e(CountryCodeUtil.LOG_TAG, `getISOCountryCodeForSim failed: ${e.message}`);
      return '';
    }
  }

  private static getRegionCountryCode(): string {
    let region = i18n.System.getSystemRegion();
    HiLog.i(CountryCodeUtil.LOG_TAG, `region: ${region}`);
    return region.toUpperCase();
  }

  private static getVendorCountryCode(): string {
    // 当前系统不支持.
    return '';
  }

  public static async initialize() {
    let countryCode = CountryCodeUtil.getVendorCountryCode();
    if (countryCode.length > 0) {
      GlobalThisUtil.setProperty('_CountryCode', countryCode);
      GlobalThisUtil.setProperty('_CountryCodeSource', 'VENDOR_COUNTRY');
      return;
    }

    countryCode = await CountryCodeUtil.getSimCountryCode();
    if (countryCode.length > 0) {
      GlobalThisUtil.setProperty('_CountryCode', countryCode);
      GlobalThisUtil.setProperty('_CountryCodeSource', 'SIM_COUNTRY');
      return;
    }

    countryCode = CountryCodeUtil.getRegionCountryCode();
    if (countryCode.length > 0) {
      GlobalThisUtil.setProperty('_CountryCode', countryCode);
      GlobalThisUtil.setProperty('_CountryCodeSource', 'LOCALE_INFO');
      return;
    }

    // 默认值.
    GlobalThisUtil.setProperty('_CountryCode', 'CN');
    GlobalThisUtil.setProperty('_CountryCodeSource', 'UNKNOWN');
  }
}