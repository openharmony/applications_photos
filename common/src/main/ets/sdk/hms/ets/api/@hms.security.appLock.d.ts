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
 * @file This module provides the capabilities to app lock.
 * @kit SystemKit
 */

import type { Callback } from '@ohos.base';

/**
 * @namespace appLock
 * @syscap SystemCapability.Security.AppLock
 * @systemapi
 * @since 5.0.2(14)
 */
declare namespace appLock {
  /**
   * Set enabled state of app lock.
   *
   * @permission ohos.permission.WRITE_APP_LOCK
   * @param { boolean } enabled - The enabled state.
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<void> } Promise used to return the result.
   * @throws { BusinessError } 401 - The parameter check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied. Interface caller does not have permission "ohos.permission.WRITE_APP_LOCK".
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  function setEnabled(enabled: boolean, userId?: number): Promise<void>;

  /**
   * Check the enabled state of app lock.
   *
   * @permission ohos.permission.READ_APP_LOCK
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<boolean> } Result of enabled state. True indicates app lock is enabled, false otherwise.
   * @throws { BusinessError } 401 - The parameter check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied. Interface caller does not have permission "ohos.permission.READ_APP_LOCK".
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  function isEnabled(userId?: number): Promise<boolean>;

  /**
   * Set the switch state of the app to turn on or off the app lock.
   *
   * @permission ohos.permission.WRITE_APP_LOCK
   * @param { Array<AppInfo> } appInfos - The array of app info.
   * @param { boolean } isOn - Indicates the switch state to be set. True is on, false otherwise.
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<void> } Promise used to return the result.
   * @throws { BusinessError } 401 - The parameter check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied. Interface caller does not have permission "ohos.permission.WRITE_APP_LOCK".
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  function setSwitchState(appInfos: Array<AppInfo>, isOn: boolean, userId?: number): Promise<void>;

  /**
   * Check whether the specific app has turned on or off app lock.
   *
   * @permission ohos.permission.READ_APP_LOCK
   * @param { string } bundleName - The bundle name.
   * @param { Options } options - The app info option. For default values, refer to the description of appLock.Options.
   * @returns { Promise<boolean> } Result of switch state. True indicates switch is on, false otherwise.
   * @throws { BusinessError } 401 - The parameter check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied. Interface caller does not have permission "ohos.permission.READ_APP_LOCK".
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  function isSwitchEnabled(bundleName: string, options?: Options): Promise<boolean>;

  /**
   * Get array of app info with the app lock switch turned on.
   *
   * @permission ohos.permission.READ_APP_LOCK
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<Array<AppInfo>> } The array of switch enabled app info.
   * @throws { BusinessError } 401 - The parameter check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied. Interface caller does not have permission "ohos.permission.READ_APP_LOCK".
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  function getSwitchEnabledAppInfos(userId?: number): Promise<Array<AppInfo>>;

  /**
   * Get array of exempted bundle info.
   *
   * @permission ohos.permission.READ_APP_LOCK
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<Array<BundleInfo>> } The array of bundle info.
   * @throws { BusinessError } 401 - The parameter check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied. Interface caller does not have permission "ohos.permission.READ_APP_LOCK".
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  function getExemptedBundleInfos(userId?: number): Promise<Array<BundleInfo>>;

  /**
   * Check whether the specific bundle name exempted.
   *
   * @permission ohos.permission.READ_APP_LOCK
   * @param { string } bundleName - The bundle name.
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<boolean> } Returns {@code true} indicates the bundle name should be exempted, {@code false} otherwise.
   * @throws { BusinessError } 401 - The parameter check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied. Interface caller does not have permission "ohos.permission.READ_APP_LOCK".
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  function isExemptedBundleName(bundleName: string, userId?: number): Promise<boolean>;

  /**
   * Set the protected state of the app.
   *
   * @permission ohos.permission.WRITE_APP_LOCK
   * @param { Array<AppInfo> } appInfos - The array of app info.
   * @param { boolean } isProtected - Indicates the protected state to be set. {@code true} indicates should be protected, {@code false} otherwise.
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<void> } Promise used to return the result.
   * @throws { BusinessError } 401 - The parameter check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied. Interface caller does not have permission "ohos.permission.WRITE_APP_LOCK".
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  function setAppProtectedState(appInfos: Array<AppInfo>, isProtected: boolean, userId?: number): Promise<void>;

  /**
   * Check whether the specific app should be protected.
   *
   * @permission ohos.permission.READ_APP_LOCK
   * @param { string } bundleName - The bundle name.
   * @param { Options } options - The app info option. For default values, refer to the description of appLock.Options.
   * @returns { Promise<boolean> } Result of protected state. {@code true} indicates should be protected, {@code false} otherwise.
   * @throws { BusinessError } 401 - The parameter check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied. Interface caller does not have permission "ohos.permission.READ_APP_LOCK".
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  function isAppProtected(bundleName: string, options?: Options): Promise<boolean>;

  /**
   * Get the array of app info protected by App Lock.
   *
   * @permission ohos.permission.READ_APP_LOCK
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<Array<AppInfo>> } The array of switch enabled app info.
   * @throws { BusinessError } 401 - The parameter check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied. Interface caller does not have permission "ohos.permission.READ_APP_LOCK".
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  function getProtectedAppInfos(userId?: number): Promise<Array<AppInfo>>;

  /**
   * Set the authentication type allowed by App Lock.
   *
   * @permission ohos.permission.WRITE_APP_LOCK
   * @param { AuthType } authType - The auth type enum, see the definition of AuthType for details.
   * @param { boolean } isAllowed - Indicates whether the auth type is allowed.
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<void> } Promise used to return the result.
   * @throws { BusinessError } 401 - The parameter check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied. Interface caller does not have permission "ohos.permission.WRITE_APP_LOCK".
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  function setAllowedAuthType(authType: AuthType, isAllowed: boolean, userId?: number): Promise<void>;

  /**
   * Check whether the auth type is allowed.
   *
   * @permission ohos.permission.READ_APP_LOCK
   * @param { AuthType } authType - The auth type enum, see the definition of AuthType for details.
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<boolean> } Return {@code true} indicates auth type is allowed, {@code false} otherwise.
   * @throws { BusinessError } 401 - The parameter check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied. Interface caller does not have permission "ohos.permission.READ_APP_LOCK".
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  function isAuthTypeAllowed(authType: AuthType, userId?: number): Promise<boolean>;

  /**
   * Get the array of auth type allowed by App Lock.
   *
   * @permission ohos.permission.READ_APP_LOCK
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<Array<AuthType>> } The array of AuthType.
   * @throws { BusinessError } 401 - The parameter check failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied. Interface caller does not have permission "ohos.permission.READ_APP_LOCK".
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  function getAllowedAuthTypes(userId?: number): Promise<Array<AuthType>>;

  /**
   * Subscribe switch state of app changed.
   *
   * @permission ohos.permission.READ_APP_LOCK
   * @param { 'switchStateChange' } type - Indicates the app lock event to be subscribed.
   * @param { Callback<Array<SwitchState>> } callback - Indicates the callback for reporting the switch state.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied. Interface caller does not have permission "ohos.permission.READ_APP_LOCK".
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  function on(type: 'switchStateChange', callback: Callback<Array<SwitchState>>): void;

  /**
   * Unsubscribe switch state of app changed.
   *
   * @permission ohos.permission.READ_APP_LOCK
   * @param { 'switchStateChange' } type - Indicates the app lock event to be subscribed.
   * @param { Callback<Array<SwitchState>> } callback - Indicates the callback for reporting the switch state.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied. Interface caller does not have permission "ohos.permission.READ_APP_LOCK".
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  function off(type: 'switchStateChange', callback?: Callback<Array<SwitchState>>): void;

  /**
   * Subscribe protected state of app changed.
   *
   * @permission ohos.permission.READ_APP_LOCK
   * @param { 'appProtectedStateChange' } type - Indicates the app lock event to be subscribed.
   * @param {  Callback<Array<AppProtectedState>> } callback - Indicates the callback for reporting the app protected state.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied. Interface caller does not have permission "ohos.permission.READ_APP_LOCK".
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  function on(type: 'appProtectedStateChange', callback: Callback<Array<AppProtectedState>>): void;

  /**
   * Unsubscribe protected state of app changed.
   *
   * @permission ohos.permission.READ_APP_LOCK
   * @param { 'appProtectedStateChange' } type - Indicates the app lock event to be subscribed.
   * @param {  Callback<Array<AppProtectedState>> } callback - Indicates the callback for reporting the app protected state.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied. Interface caller does not have permission "ohos.permission.READ_APP_LOCK".
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  function off(type: 'appProtectedStateChange', callback?: Callback<Array<AppProtectedState>>): void;

  /**
   * Enum for Auth type.
   *
   * @enum { number } AuthType
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  enum AuthType {
    /**
     * The auth type is pin.
     *
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.0.2(14)
     */
    PIN = 1,

    /**
     * The auth type is face.
     *
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.0.2(14)
     */
    FACE = 2,

    /**
     * The auth type is privacy pin.
     *
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.0.2(14)
     */
    PRIVACY_PIN = 3,

    /**
     * The auth type is fingerprint.
     *
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.0.2(14)
     */
    FINGERPRINT = 4
  }

  /**
   * Provides optional params of app info.
   *
   * @interface Options
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  interface Options {
    /**
     * The app index. Default is main app index.
     *
     * @type { ?number }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.0.2(14)
     */
    appIndex?: number;

    /**
     * The user id. Default is main user id.
     *
     * @type { ?number }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.0.2(14)
     */
    userId?: number;
  }

  /**
   * Provides app information.
   *
   * @interface AppInfo
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  interface AppInfo {
    /**
     * The bundle name.
     *
     * @type { string }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.0.2(14)
     */
    bundleName: string;

    /**
     * The app index.
     *
     * @type { number }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.0.2(14)
     */
    appIndex: number;
  }

  /**
   * Provides switch state information.
   *
   * @interface SwitchState
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  interface SwitchState {
    /**
     * The user id.
     *
     * @type { number }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.0.2(14)
     */
    userId: number;

    /**
     * The app info, see definition of appLock.AppInfo.
     *
     * @type { AppInfo }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.0.2(14)
     */
    appInfo: AppInfo;

    /**
     * The switch state. True is on, false otherwise.
     *
     * @type { boolean }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.0.2(14)
     */
    isOn: boolean;
  }

  /**
   * Provides app protected state information.
   *
   * @interface AppProtectedState
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  interface AppProtectedState {
    /**
     * The user id.
     *
     * @type { number }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.0.2(14)
     */
    userId: number;

    /**
     * The app info, see definition of appLock.AppInfo.
     *
     * @type { AppInfo }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.0.2(14)
     */
    appInfo: AppInfo;

    /**
     * The app protected state. True is protected, false otherwise.
     *
     * @type { boolean }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.0.2(14)
     */
    isProtected: boolean;
  }

  /**
   * Provides bundle information.
   *
   * @interface BundleInfo
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.0.2(14)
   */
  interface BundleInfo {
    /**
     * The bundle name.
     *
     * @type { string }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.0.2(14)
     */
    bundleName: string;

    /**
     * The app identifier.
     *
     * @type { string }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.0.2(14)
     */
    appIdentifier: string;

    /**
     * The app id.
     *
     * @type { string }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.0.2(14)
     */
    appId: string;
  }

  /**
   * Get the app lock condition.
   *
   * @permission ohos.permission.READ_APP_LOCK
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<AppLockCondition> } Return the app lock condition, see the definition of AppLockCondition for details.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 1015520001 - Database operation failed.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.1.1(19)
   */
  function getAppLockCondition(userId?: number): Promise<AppLockCondition>;

  /**
   * Start authentication using allowed auth type of app lock with auth widget by IAM.
   *
   * @permission ohos.permission.READ_APP_LOCK
   * @param { AuthParams } authParams - The auth parameters, default value refer definition of AuthParams.
   * @returns { Promise<void> } Promise used to return the result.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 1015550001 - Athentication fail.
   * @throws { BusinessError } 1015550002 - Athentication cancel.
   * @throws { BusinessError } 1015550003 - Athentication type is not enrolled.
   * @throws { BusinessError } 1015550004 - Other error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.1.1(19)
   */
  function startAppLockAuth(authParams?: AuthParams): Promise<void>;

  /**
   * Set the switch state of access app lock in multi situation. <br/>
   * 1. When app lock is not enabled, it will start introduction page. <br/>
   * 2. When app lock is allowd by privacy pin, it will start auth widget to recheck privacy pin. <br/>
   * 3. Otherwise, it will set allowed auth type directly. <br/>
   *
   * @permission ohos.permission.WRITE_APP_LOCK
   * @param { common.Context } context - Application Context.
   * @param { AuthType } authType - The auth type enum, see the definition of AuthType for details.
   * @param { boolean } isAllowed - Indicates whether the auth type is allowed to access app lock.
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<void> } Promise used to return the result.
   * @throws { BusinessError } 301 - Create modal UI extension ability failed.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 1015540002 - Start UI extension ability failed.
   * @throws { BusinessError } 1015540004 - Release UI extension ability.
   * @throws { BusinessError } 1015540005 - Destroy UI extension ability.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.1.1(19)
   */
  function setVisitAppLock(context: common.Context, authType: AuthType, isAllowed: boolean, userId?: number): Promise<void>;

  /**
   * Enum for app lock condition.
   *
   * @enum { number } AppLockCondition
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.1.1(19)
   */
  enum AppLockCondition {

    /**
     * The app lock condition indicates app will be relocked only after lock screen.
     *
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.1.1(19)
     */
    ONLY_LOCK_SCREEN = 0,

    /**
     * The app lock condition indicates app will be relocked after exit app or lock screen.
     *
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.1.1(19)
     */
    LOCK_SCREEN_OR_EXIST_APP = 1
  }

  /**
   * Provides auth type information.
   *
   * @interface AllowedAuthType
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.1.1(19)
   */
  interface AllowedAuthType {

    /**
     * The user id.
     *
     * @type { number }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.1.1(19)
     */
    userId: number;

    /**
     * The auth type.
     *
     * @type { AuthType }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.1.1(19)
     */
    authType: AuthType;

    /**
     * Indicates whether the auth type is allowed.
     *
     * @type { boolean }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.1.1(19)
     */
    isAllowed: boolean;
  }

  /**
   * Provides params of app lock authentication.
   *
   * @interface AuthParams
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.1.1(19)
   */
  interface AuthParams {

    /**
     * The user id. Default is main user id.
     *
     * @type { ?number }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.1.1(19)
     */
    userId?: number;

    /**
     * The title of widget. Default is empty string.
     *
     * @type { ?string }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.1.1(19)
     */
    titleStr?: string;

    /**
     * The mode for reusing unlock authentication result. Default is zero.
     *
     * @type { ?number }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.1.1(19)
     */
    reuseMode?: number;

    /**
     * The reuse duration. Default is zero.
     *
     * @type { ?number }
     * @syscap SystemCapability.Security.AppLock
     * @systemapi
     * @since 5.1.1(19)
     */
    reuseDuration?: number;
  }

  /**
   * Subscribe allowed auth type changed.
   *
   * @permission ohos.permission.READ_APP_LOCK
   * @param { 'allowedAuthTypeChange' } type - Indicates the app lock event to be subscribed.
   * @param { Callback<AllowedAuthType> } callback - Indicates the callback for reporting the allowed auth type.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.1.1(19)
   */
  function on(type: 'allowedAuthTypeChange', callback: Callback<AllowedAuthType>): void;

  /**
   * Unsubscribe allowed auth type changed.
   *
   * @permission ohos.permission.READ_APP_LOCK
   * @param { 'allowedAuthTypeChange' } type - Indicates the app lock event to be unsubscribed.
   * @param { Callback<AllowedAuthType> } callback - Indicates the callback for reporting the allowed auth type.
   * @throws { BusinessError } 202 - The non-system app should not call this system api.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 1015500001 - App lock internal error.
   * @syscap SystemCapability.Security.AppLock
   * @systemapi
   * @since 5.1.1(19)
   */
  function off(type: 'allowedAuthTypeChange', callback?: Callback<AllowedAuthType>): void;
}

export default appLock;
