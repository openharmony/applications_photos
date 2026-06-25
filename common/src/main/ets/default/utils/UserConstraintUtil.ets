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

import lazy { osAccount, systemParameterEnhance } from '@kit.BasicServicesKit';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';

const TAG: string = 'UserConstrainsUtil';
const IS_ENTERPRISE_DEVICE: string = 'const.edm.is_enterprise_device';
const TRUE_VALUE: string = 'true';
const FALSE_VALUE: string = 'false';

export enum UserConstraint {
  CONSTRAINT_WALLPAPER_SET = 'constraint.wallpaper.set'
}

export class UserConstraintUtil {
  private static isConstraintModifyWallpaper: boolean = false;
  private static isEnterpriseDeviceFlag?: boolean = undefined;

  /**
   * 是否限制用户设置壁纸
   * @returns true:限制用户设置壁纸 false:不限制
   */
  public static isConstraintUserModifyWallpaper(): boolean {
    Log.info(TAG, `isConstraintModifyWallpaper: ${UserConstraintUtil.isConstraintModifyWallpaper}`);
    return UserConstraintUtil.isConstraintModifyWallpaper;
  }

  /**
   * 初始化是否限制用户设置壁纸
   */
  public static async initConstraints() {
    Log.info(TAG, 'initConstraints start');
    if (!UserConstraintUtil.isEnterpriseDevice()) {
      return;
    }
    try {
      UserConstraintUtil.isConstraintModifyWallpaper =
        await osAccount.getAccountManager().isOsAccountConstraintEnabled(UserConstraint.CONSTRAINT_WALLPAPER_SET);
    } catch (err) {
      Log.error(TAG, `osAccount get isOsAccountConstraintEnabled error: ${err?.code}, ${err?.msg}`);
    }
  }

  /**
   * 是否为企业设备
   * @returns true:是企业设备,false:不是企业设备
   */
  public static isEnterpriseDevice(): boolean {
    if (UserConstraintUtil.isEnterpriseDeviceFlag !== undefined) {
      return UserConstraintUtil.isEnterpriseDeviceFlag;
    }
    try {
      const isEnterpriseDevice: string = systemParameterEnhance.getSync(IS_ENTERPRISE_DEVICE, FALSE_VALUE);
      Log.info(TAG, `isEnterpriseDevice:${isEnterpriseDevice}`);
      if (isEnterpriseDevice === TRUE_VALUE) {
        UserConstraintUtil.isEnterpriseDeviceFlag = true;
        return UserConstraintUtil.isEnterpriseDeviceFlag;
      }
    } catch (err) {
      Log.error(TAG, `systemParameterEnhance get isEnterpriseDevice error: ${err?.code}, ${err?.msg}`);
    }
    UserConstraintUtil.isEnterpriseDeviceFlag = false;
    return UserConstraintUtil.isEnterpriseDeviceFlag;
  }
}