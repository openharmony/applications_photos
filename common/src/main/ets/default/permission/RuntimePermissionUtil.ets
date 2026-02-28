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

import lazy PermissionGrantCallback from './PermissionGrantCallback';
import lazy { abilityAccessCtrl, bundleManager, Permissions, common } from '@kit.AbilityKit';
import lazy { BusinessError } from '@kit.BasicServicesKit';

export class RuntimePermissionUtil {
  /**
   * 檢查並申請未被授權的權限
   *
   * @param context context
   * @param permissions permissions
   * @param callback callback
   */
  /* instrument ignore next */
  public static async checkAndRequestPermissionGrant(context: common.UIAbilityContext,
    permissions: Array<Permissions>, callback: PermissionGrantCallback) {
    let requestPermissions: Permissions[] = [];
    for (let permission of permissions) {
      let isGranted: boolean =
        await RuntimePermissionUtil.checkPermissionGrant(permission, callback) ===
        abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
      if (!isGranted) {
        requestPermissions.push(permission);
      }
    }
    if (requestPermissions.length !== 0) {
      RuntimePermissionUtil.reqPermissionsFromUser(requestPermissions, context, callback);
    } else {
      callback?.onAllPermissionGranted();
    }
  }

  /* instrument ignore next */
  private static async checkPermissionGrant(permission: Permissions, callback: PermissionGrantCallback):
    Promise<abilityAccessCtrl.GrantStatus> {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;

    // 获取应用程序的accessTokenID
    let tokenId: number = 0;
    try {
      let bundleInfo: bundleManager.BundleInfo =
        await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      tokenId = appInfo.accessTokenId;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      callback?.onError(
        `checkPermissionGrant:Failed to get bundle info for self. Code is ${err.code}, message is ${err.message}`);
    }

    // 校验应用是否被授予权限
    try {
      grantStatus = await atManager.checkAccessToken(tokenId, permission);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      callback?.onError(
        `checkPermissionGrant:Failed to check access token. Code is ${err.code}, message is ${err.message}`);
    }
    return grantStatus;
  }

  /* instrument ignore next */
  private static reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext,
    callback: PermissionGrantCallback): void {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      let grantStatus: number[] = data.authResults;
      let length: number = grantStatus.length;
      let grantedPermission: Permissions[] = [];
      let deniedPermission: Permissions[] = [];
      for (let i = 0; i < length; i++) {
        if (grantStatus[i] === 0) {
          // 用户授权，可以继续访问目标操作
          grantedPermission.push(permissions[i]);
        } else {
          // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
          deniedPermission.push(permissions[i]);
        }
      }
      if (grantedPermission?.length > 0) {
        callback?.onGranted(grantedPermission);
      }
      if (deniedPermission?.length > 0) {
        callback?.onDenied(deniedPermission);
      }
      // 授权成功
      if (grantedPermission.length === length) {
        callback?.onAllPermissionGranted();
      }
    }).catch((err: BusinessError) => {
      callback?.onError(`Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`);
    })
  }
}