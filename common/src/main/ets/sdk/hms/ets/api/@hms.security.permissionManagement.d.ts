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

/**
 * @file This module provides the capabilities of permission management.
 * @kit SystemKit
 */

import type { AsyncCallback } from '@ohos.base';
import type common from '@ohos.app.ability.common';

/**
 * @namespace permissionManagement
 * @syscap SystemCapability.Security.SecurityPrivacyServer
 * @systemapi
 * @since 4.1.0(11)
 */
declare namespace permissionManagement {
  /**
   * The app permission group info.
   *
   * @typedef AppPermissionGroupInfo
   * @syscap SystemCapability.Security.SecurityPrivacyServer
   * @systemapi
   * @since 4.1.0(11)
   */
  interface AppPermissionGroupInfo {
    /**
     * Indicates the app bundle name.
     *
     * @type { string }
     * @syscap SystemCapability.Security.SecurityPrivacyServer
     * @systemapi
     * @since 4.1.0(11)
     */
    bundleName: string;

    /**
     * Indicates the app uid, i32. It is ohos format.
     *
     * @type { number }
     * @syscap SystemCapability.Security.SecurityPrivacyServer
     * @systemapi
     * @since 4.1.0(11)
     */
    uid: number;

    /**
     * Indicates the permission group.<br/>
     * Valid permission groups: <br/>
     * LOCATION -- For <b>ohos</b> and <b><b>anco</b></b>;<br/>
     * PRECISE_LOCATION -- For <b>ohos</b> and <b>anco</b>;<br/>
     * CAMERA -- For <b>ohos</b> and <b>anco</b>;<br/>
     * MICROPHONE -- For <b>ohos</b> and <b>anco</b>;<br/>
     * IMAGE_AND_VIDEO -- For <b>ohos</b> only;<br/>
     * CONTACTS -- For <b>ohos</b> and <b>anco</b>;<br/>
     * ADS -- For <b>ohos</b> only;<br/>
     * PASTEBOARD -- For <b>ohos</b> only;<br/>
     * DOCUMENT -- For <b>ohos</b> only;<br/>
     * AUDIO -- For <b>ohos</b> only;<br/>
     * ACTIVITY_RECOGNITION -- For <b>ohos</b> and <b>anco</b>;<br/>
     * CALENDAR -- For <b>ohos</b> and <b>anco</b>;<br/>
     * STORAGE -- For <b>anco</b> only;<br/>
     * PHONE -- For <b>anco</b> only;<br/>
     * SMS -- For <b>anco</b> only;<br/>
     * CALL_LOG -- For <b>anco</b> only;<br/>
     * SENSORS -- For <b>anco</b> only;<br/>
     * NEARBY_DEVICES -- For <b>anco</b> only;<br/>
     * REQUEST_INSTALL_PACKAGES -- For <b>anco</b> only;<br/>
     * SHORTCUT -- For <b>anco</b> only;<br/>
     * SYSTEM_ALERT_WINDOW -- For <b>anco</b> only;<br/>
     * GET_INSTALLED_APPS -- For <b>anco</b> only;<br/>
     * POPUP_BACKGROUND_WINDOW -- For <b>anco</b> only;<br/>
     * DISTRIBUTION -- For <b>anco</b> only;<br/>
     *
     * @type { string }
     * @syscap SystemCapability.Security.SecurityPrivacyServer
     * @systemapi
     * @since 4.1.0(11)
     */
    permissionGroup: string;

    /**
     * Indicates the permission group checked state.<br/>
     * Valid permission group state: <br/>
     * ALLOW -- Any sub permission is granted for this permission group.<br/>
     * ALLOW_ALL_THE_TIME -- Foreground permission and background permission are both granted.<br/>
     * ALLOW_ONLY_WHILE_IN_USE -- Only foreground permission are granted.<br/>
     * ASK_EACH_TIME -- Permission state is onetime.<br/>
     * DENY -- All sub permission is denied.<br/>
     * MEDIA_ONLY -- Anco storage permission state, only media.<br/>
     * ALLOW_MANAGEMENT_OF_ALL_FILES -- Anco storage permission state, all files.<br/>
     *
     * @type { string }
     * @syscap SystemCapability.Security.SecurityPrivacyServer
     * @systemapi
     * @since 4.1.0(11)
     */
    checkedState: string;

    /**
     * Indicates the permission group shown states. It has order.<br/>
     * Valid permission group state see {@link checkedState}.
     *
     * @type { Array<string> }
     * @syscap SystemCapability.Security.SecurityPrivacyServer
     * @systemapi
     * @since 4.1.0(11)
     */
    shownStates: Array<string>;

    /**
     * Indicates the permission group disabled states.<br/>
     * Valid permission group state see {@link checkedState}.
     *
     * @type { Array<string> }
     * @syscap SystemCapability.Security.SecurityPrivacyServer
     * @systemapi
     * @since 4.1.0(11)
     */
    disabledStates: Array<string>;

    /**
     * Indicates the permission group disabled reason. None if empty disabled states.<br/>
     * Valid reason: NONE, POLICY_OR_SYSTEM_FIXED.
     *
     * @type { string }
     * @syscap SystemCapability.Security.SecurityPrivacyServer
     * @systemapi
     * @since 4.1.0(11)
     */
    disabledReason: string;

    /**
     * Some addition flags, i64.<br/>
     * FLAG_PERMISSION_GROUP_USER_SET: 1 << 0. <br/>
     * -- User has edit this permission on settings UI, app can request permission.<br/>
     * FLAG_PERMISSION_GROUP_USER_FIXED: 1 << 1.<br/>
     * -- User has edit this permission on UI, app can't request permission.<br/>
     *
     * @type { number }
     * @syscap SystemCapability.Security.SecurityPrivacyServer
     * @systemapi
     * @since 4.1.0(11)
     */
    flags: number;
  }

  /**
   * The checked state parameter. Used for set app permission group checked state.<br/>
   * This is state part of app permission group, only contains checked state and permission group flags.<br/>
   *
   * @typedef CheckedStateParameter
   * @syscap SystemCapability.Security.SecurityPrivacyServer
   * @systemapi
   * @since 4.1.0(11)
   */
  interface CheckedStateParameter {
    /**
     * Indicates the permission group checked state.<br/>
     * See {@link AppPermissionGroupInfo.checkedState}.<br/>
     *
     * @type { string }
     * @syscap SystemCapability.Security.SecurityPrivacyServer
     * @systemapi
     * @since 4.1.0(11)
     */
    checkedState: string,

    /**
     * Some addition flags, i64.<br/>
     * The bit is 1 means set checked state api wants to edit this state.<br/>
     * See {@link AppPermissionGroupInfo.flags}.<br/>
     *
     * @type { number }
     * @syscap SystemCapability.Security.SecurityPrivacyServer
     * @systemapi
     * @since 4.1.0(11)
     */
    flagMask: number,

    /**
     * Some addition flags, i64.<br/>
     * The bit is 1 means the value set checked state api wants to set.
     * See {@link AppPermissionGroupInfo.flags}.<br/>
     *
     * @type { number }
     * @syscap SystemCapability.Security.SecurityPrivacyServer
     * @systemapi
     * @since 4.1.0(11)
     */
    flagValue: number,
  }

  /**
   * Get app permission group infos by app.<br/>
   *
   * @permission ohos.permission.GET_SENSITIVE_PERMISSIONS
   * @param { string } bundleName - Query app bundle name.
   * @param { number } userId - Query app user id.
   * @param { Array<string> } interestedPermissionGroups - The app interested permission groups, could not be empty.
   * @returns { Promise<Array<AppPermissionGroupInfo>> } Returns array of AppPermissionGroupInfos.
   * @throws { BusinessError } 201 - Permission check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 401 - Input parameter error.
   * @syscap SystemCapability.Security.SecurityPrivacyServer
   * @systemapi
   * @since 4.1.0(11)
   */
  function getAppPermissionGroupInfosByApp(bundleName: string, userId: number,
    interestedPermissionGroups: Array<string>): Promise<Array<AppPermissionGroupInfo>>;

  /**
   * Get app permission group infos by app.<br/>
   *
   * @permission ohos.permission.GET_SENSITIVE_PERMISSIONS
   * @param { string } bundleName - Query app bundle name.
   * @param { number } userId - Query app user id.
   * @param { Array<string> } interestedPermissionGroups - The app interested permission groups, could not be empty.
   * @param { AsyncCallback<Array<AppPermissionGroupInfo>> } callback - Async callback array of AppPermissionGroupInfos.
   * @throws { BusinessError } 201 - Permission check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 401 - Input parameter error.
   * @syscap SystemCapability.Security.SecurityPrivacyServer
   * @systemapi
   * @since 4.1.0(11)
   */
  function getAppPermissionGroupInfosByApp(bundleName: string, userId: number,
    interestedPermissionGroups: Array<string>, callback: AsyncCallback<Array<AppPermissionGroupInfo>>): void;

  /**
   * Get app permission groups infos by permission.<br/>
   *
   * @permission ohos.permission.GET_SENSITIVE_PERMISSIONS
   * @param { string } permissionGroup - Query permission group.
   * @param { number } userId - Query app user id.
   * @param { Array<string> } interestedBundleNames - The interested app bundle names, empty means query all.
   * @returns { Promise<Array<AppPermissionGroupInfo>> } Returns array of AppPermissionGroupInfos.
   * @throws { BusinessError } 201 - Permission check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 401 - Input parameter error.
   * @syscap SystemCapability.Security.SecurityPrivacyServer
   * @systemapi
   * @since 4.1.0(11)
   */
  function getAppPermissionGroupInfosByPermission(permissionGroup: string, userId: number,
    interestedBundleNames: Array<string>): Promise<Array<AppPermissionGroupInfo>>;

  /**
   * Get app permission group infos by permission.<br/>
   *
   * @permission ohos.permission.GET_SENSITIVE_PERMISSIONS
   * @param { string } permissionGroup - Query permission group.
   * @param { number } userId - Query app user id.
   * @param { Array<string> } interestedBundleNames - The interested app bundle names, empty means query all.
   * @param { AsyncCallback<Array<AppPermissionGroupInfo>> } callback - Async callback array of AppPermissionGroupInfos.
   * @throws { BusinessError } 201 - Permission check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 401 - Input parameter error.
   * @syscap SystemCapability.Security.SecurityPrivacyServer
   * @systemapi
   * @since 4.1.0(11)
   */
  function getAppPermissionGroupInfosByPermission(permissionGroup: string, userId: number,
    interestedBundleNames: Array<string>, callback: AsyncCallback<Array<AppPermissionGroupInfo>>): void;

  /**
   * Set app permission group to new checked state.<br/>
   * If new checked state is going to grant permission, caller must hold grant permission. If it is going to revoke
   * permission, caller must hold revoke permission.<br/>
   *
   * @permission ohos.permission.GRANT_SENSITIVE_PERMISSIONS or ohos.permission.REVOKE_SENSITIVE_PERMISSIONS
   * @param { string } bundleName - The app bundle name.
   * @param { number } uid - The app uid, in ohos format.
   * @param { string } permissionGroup - The permission group. See {@link AppPermissionGroupInfo.permissionGroup}.
   * @param { CheckedStateParameter } newCheckedState - New checked state. See {@link CheckedStateParameter}.
   * @returns { Promise<boolean> } Returns true for set success, otherwise failure.
   * @throws { BusinessError } 201 - Permission check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 401 - Input parameter error.
   * @syscap SystemCapability.Security.SecurityPrivacyServer
   * @systemapi
   * @since 4.1.0(11)
   */
  function setAppPermissionGroupCheckedState(bundleName: string, uid: number, permissionGroup: string,
    newCheckedState: CheckedStateParameter): Promise<boolean>;

  /**
   * Set app permission group to new checked state.<br/>
   * If new checked state is going to grant permission, caller must hold grant permission. If it is going to revoke
   * permission, caller must hold revoke permission.<br/>
   *
   * @permission ohos.permission.GRANT_SENSITIVE_PERMISSIONS or ohos.permission.REVOKE_SENSITIVE_PERMISSIONS
   * @param { string } bundleName - The app bundle name.
   * @param { number } uid - The app uid, in ohos format.
   * @param { string } permissionGroup - The permission group. See {@link AppPermissionGroupInfo.permissionGroup}.
   * @param { CheckedStateParameter } newCheckedState - New checked state. See {@link CheckedStateParameter}.
   * @param { AsyncCallback<boolean> } callback - Async callback true for set success, otherwise failure.
   * @throws { BusinessError } 201 - Permission check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 401 - Input parameter error.
   * @syscap SystemCapability.Security.SecurityPrivacyServer
   * @systemapi
   * @since 4.1.0(11)
   */
  function setAppPermissionGroupCheckedState(bundleName: string, uid: number, permissionGroup: string,
    newCheckedState: CheckedStateParameter, callback: AsyncCallback<boolean>): void;

  enum MoreInfoDialogType {
    GALLERY_PICKER,
    CONTACTS_PICKER,
    FILES_PICKER,
    DOCUMENTS_PICKER,
    AUDIO_PICKER,
    LOCATION_PICKER,
    CAMERA_PICKER,
    SCAN_PICKER,
  }

  function showMoreInfoDialog(context: common.Context, businessId: MoreInfoDialogType): Promise<void>;

  function showMoreInfoDialog(context: common.Context, businessId: MoreInfoDialogType,
    callback: AsyncCallback<void>): void;
}

export default permissionManagement;
