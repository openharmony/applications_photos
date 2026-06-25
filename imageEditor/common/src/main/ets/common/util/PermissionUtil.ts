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
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import bundleManager from '@ohos.bundle.bundleManager';
import type { Context } from '@kit.AbilityKit';
import { HiLog } from './HiLog';

const TAG = 'PermissionUtil';
const PERMISSION_READ_MEDIA = 'ohos.permission.READ_IMAGEVIDEO';
const PERMISSION_WRITE_MEDIA = 'ohos.permission.WRITE_IMAGEVIDEO';
const PERMISSION_READ_AUDIO = 'ohos.permission.READ_AUDIO';
const PERMISSION_FILE_ACCESS_MANAGER = 'ohos.permission.FILE_ACCESS_MANAGER';

export class PermissionUtil {
  /**
   * Requests permissions from user
   * @param context Application context
   * @param permissionList List of permissions to request
   * @returns Promise that resolves when permissions are granted
   * @throws {Error} Throws error when:
   *                 - No data or authResults received from permission request
   *                 - User rejected some permissions
   *                 - Underlying permission request fails
   */
  public static async requestPermissions(context: Context, permissionList: Array<Permissions>): Promise<void> {
    HiLog.i(TAG, 'requestPermission begin');
    try {
      let atManager = abilityAccessCtrl.createAtManager();
      let data = await atManager.requestPermissionsFromUser(context, permissionList);

      if (!data || !data.authResults) {
        HiLog.e(TAG, 'requestPermission failed - no data or authResults');
        throw new Error('Permission request failed - no response data');
      }

      if (data.authResults.every(result => result === 0)) {
        HiLog.i(TAG, 'requestPermission granted');
        return;
      }

      HiLog.e(TAG, 'requestPermission user rejected');
      throw new Error('User rejected some permissions');
    } catch (error) {
      HiLog.e(TAG, `requestPermission error: ${error.message}`);
      throw error;
    } finally {
      HiLog.i(TAG, 'requestPermission end');
    }
  }
  /**
   * Requests audio media library read permission
   * @param context Application context
   * @returns Promise that resolves when permission is granted
   * @throws {Error} Throws error when:
   *                 - Underlying permission request fails (propagates from requestPermissions)
   */
  public static async requestMediaLibAudioPermissions(context: Context): Promise<void> {
    try {
      return PermissionUtil.requestPermissions(context, [PERMISSION_READ_AUDIO]);
    } catch (error) {
      HiLog.e(TAG, `requestMediaLibAudioPermissions failed: ${error.message}`);
      throw error;
    }
  }

  public static async checkMediaLibAudioPermission(): Promise<boolean> {
    let atManager = abilityAccessCtrl.createAtManager();
    let bundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag
      .GET_BUNDLE_INFO_WITH_APPLICATION);
    let status = await atManager.checkAccessToken(bundleInfo.appInfo.accessTokenId, PERMISSION_READ_AUDIO);
    return status !== abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;
  }
  /**
   * Requests public audio file access permission
   * @param context Application context
   * @returns Promise that resolves when permission is granted
   * @throws {Error} Throws error when:
   *                 - Underlying permission request fails (propagates from requestPermissions)
   */
  public static async requestPublicAudioPermissions(context: Context): Promise<void> {
    try {
      return PermissionUtil.requestPermissions(context, [PERMISSION_FILE_ACCESS_MANAGER]);
    } catch (error) {
      HiLog.e(TAG, `requestPublicAudioPermissions failed: ${error.message}`);
      throw error;
    }
  }

  public static async checkPublicAudioPermission(): Promise<boolean> {
    let atManager = abilityAccessCtrl.createAtManager();
    let bundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag
      .GET_BUNDLE_INFO_WITH_APPLICATION);
    let status = await atManager.checkAccessToken(bundleInfo.appInfo.accessTokenId, PERMISSION_FILE_ACCESS_MANAGER);
    return status !== abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;
  }
  /**
   * 检查是否有读写权限
   *
   * @returns boolean true|false
   */
  public static async checkWritePermission(): Promise<boolean> {
    let atManager = abilityAccessCtrl.createAtManager();
    let bundleInfo =
      await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let grantWriteStatus = await atManager.checkAccessToken(bundleInfo.appInfo.accessTokenId, PERMISSION_WRITE_MEDIA);
    let grantReadStatus = await atManager.checkAccessToken(bundleInfo.appInfo.accessTokenId, PERMISSION_READ_MEDIA);
    if (grantWriteStatus ===
    abilityAccessCtrl.GrantStatus.PERMISSION_DENIED || grantReadStatus ===
    abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
      return false;
    }
    return true;
  }
}