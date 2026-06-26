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
 * @file This module provides the capabilities to get information hiding status.
 * @kit SystemKit
 */

import type { Callback } from '@ohos.base';

/**
 * This module provides information hiding status detection abilities.
 *
 * @namespace dlpHideInfo
 * @syscap SystemCapability.Security.DlpInfoHide
 * @systemapi
 * @since 5.1.0(18)
 */
declare namespace dlpHideInfo {
  /**
   * Enumerates the response of dlp information hiding state change.
   *
   * @enum { number }
   * @syscap SystemCapability.Security.DlpInfoHide
   * @systemapi
   * @since 5.1.0(18)
   */
  enum DlpHideStatus {
    /**
     * Information hiding error.
     * @syscap SystemCapability.Security.DlpInfoHide
     * @systemapi
     * @since 5.1.0(18)
     */
    ABNORMAL = -1,

    /**
     * Information hiding disabled.
     * @syscap SystemCapability.Security.DlpInfoHide
     * @systemapi
     * @since 5.1.0(18)
     */
    PASS = 0,

    /**
     * Information hiding enabled.
     * @syscap SystemCapability.Security.DlpInfoHide
     * @systemapi
     * @since 5.1.0(18)
     */
    HIDE = 1,
  }

  /**
   * Enumerates the response of dlp information notification state change.
   * @enum { number }
   * @syscap SystemCapability.Security.DlpInfoHide
   * @systemapi
   * @since 5.1.0(18)
   */
  enum DlpNotificationStatus {
    /**
     * Abnormal status of notification status.
     * @syscap SystemCapability.Security.DlpInfoHide
     * @systemapi
     * @since 5.1.0(18)
     */
    ABNORMAL = -1,

    /**
     * No notification status of notification status.
     * @syscap SystemCapability.Security.DlpInfoHide
     * @systemapi
     * @since 5.1.0(18)
     */
    NO_NOTIFICATION = 0,

    /**
     * Phone notification status.
     *
     * @syscap SystemCapability.Security.DlpInfoHide
     * @systemapi
     * @since 5.1.0(18)
     */
    PHONE_NOTIFICATION = 1,

    /**
     * Wear notification status.
     *
     * @syscap SystemCapability.Security.DlpInfoHide
     * @systemapi
     * @since 5.1.0(18)
     */
    WEAR_NOTIFICATION = 2
  }

  /**
   * Enumerates the response of dlp information hiding and notification state change.
   *
   * @typedef DlpHideInfoAction
   * @syscap SystemCapability.Security.DlpInfoHide
   * @systemapi
   * @since 5.1.0(18)
   */
  export interface DlpHideInfoAction {

    /**
     * Hide status.
     *
     * @type { DlpHideStatus }
     * @syscap SystemCapability.Security.DlpInfoHide
     * @systemapi
     * @since 5.1.0(18)
     */
    hideStatus: DlpHideStatus;

    /**
     * Notification status.
     *
     * @type { DlpNotificationStatus }
     * @syscap SystemCapability.Security.DlpInfoHide
     * @systemapi
     * @since 5.1.0(18)
     */
    notificationStatus: DlpNotificationStatus;
  }

  /**
   * subscribe information hiding status and obtaining callback.
   *
   * @permission ohos.permission.DLP_GET_HIDE_STATUS
   * @param { 'dlpHideInfo' } type - Indicates the multiple eye gaze event to be subscribed.
   * @param { number } domainId - A unique identifier for the domain to use hide information.
   * @param { Callback<DlpHideInfoAction> } callback - The callback object used to return information hiding status.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - The caller is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
   *  2. Incorrect parameter types.
   * @throws { BusinessError } 801 - Capability not supported.function on can not work correctly due to limited
   *  device capabilities.
   * @throws { BusinessError } 1017800001 - Internal error.
   * @syscap SystemCapability.Security.DlpInfoHide
   * @systemapi
   * @since 5.1.0(18)
   */
  function on(type: 'dlpHideInfo', domainId: number, callback: Callback<DlpHideInfoAction>): void;

  /**
   * unsubscribe information hiding status and remove callback.
   *
   * @permission ohos.permission.DLP_GET_HIDE_STATUS
   * @param { 'dlpHideInfo' } type - Indicates the multiple eye gaze event to be subscribed.
   * @param { number } domainId - A unique identifier for the domain to use hide information.
   * @param { Callback<DlpHideInfoAction> } callback - The callback object used to cancel subscription relationship.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - The caller is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
   *  2. Incorrect parameter types.
   * @throws { BusinessError } 801 - Capability not supported.function off can not work correctly due to
   *  limited device capabilities.
   * @throws { BusinessError } 1017800001 - Internal error.
   * @syscap SystemCapability.Security.DlpInfoHide
   * @systemapi
   * @since 5.1.0(18)
   */
  function off(type: 'dlpHideInfo', domainId: number, callback?: Callback<DlpHideInfoAction>): void;

  /**
   * get the information hiding status of the current service.
   *
   * @permission ohos.permission.DLP_GET_HIDE_STATUS
   * @param { number } domainId - A unique identifier for the domain to use hide information.
   * @returns { DlpHideInfoAction } result of information hiding status.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - The caller is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
   *  2. Incorrect parameter types.
   * @throws { BusinessError } 801 - Capability not supported.function getDlpHideInfo can not work correctly due to
   *  limited device capabilities.
   * @throws { BusinessError } 1017800001 - Internal error.
   * @syscap SystemCapability.Security.DlpInfoHide
   * @systemapi
   * @since 5.1.0(18)
   */
  function getDlpHideInfo(domainId: number): DlpHideInfoAction;

  /**
   * pass the information hiding status of the service.
   *
   * @permission ohos.permission.DLP_GET_HIDE_STATUS
   * @param { number } domainId - A unique identifier for the domain to use hide information.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - The caller is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
   *  2. Incorrect parameter types.
   * @throws { BusinessError } 801 - Capability not supported.function passDlpHideInfo can not work correctly due to
   *  limited device capabilities.
   * @throws { BusinessError } 1017800001 - Internal error.
   * @syscap SystemCapability.Security.DlpInfoHide
   * @systemapi
   * @since 5.1.0(18)
   */
  function passDlpHideInfo(domainId: number): void;

  /**
   * Provides app information.
   *
   * @interface AppInfo
   * @syscap SystemCapability.Security.DlpInfoHide
   * @systemapi
   * @since 5.1.0(18)
   */
  interface AppInfo {
    /**
     * The bundle name.
     *
     * @type { string }
     * @syscap SystemCapability.Security.DlpInfoHide
     * @systemapi
     * @since 5.1.0(18)
     */
    bundleName: string;

    /**
     * The app index.
     *
     * @type { number }
     * @syscap SystemCapability.Security.DlpInfoHide
     * @systemapi
     * @since 5.1.0(18)
     */
    appIndex: number;
  }

  /**
   * Set the switch state of the app to turn on or off the app lock.
   *
   * @permission ohos.permission.WRITE_DLP_HIDE_SWITCH
   * @param { AppInfo[] } appInfos - The array of app info.
   * @param { boolean } isOn - Indicates the switch state to be set. True is on, false otherwise.
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<void> } Promise used to return the result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - The caller is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
   *  2. Incorrect parameter types.
   * @throws { BusinessError } 801 - Capability not supported.function passDlpHideInfo can not work correctly due to
   *  limited device capabilities.
   * @throws { BusinessError } 1017800001 - Internal error.
   * @syscap SystemCapability.Security.DlpInfoHide
   * @systemapi
   * @since 5.1.0(18)
   */
  function setDlpHideSwitch(appInfos: AppInfo[], isOn: boolean, userId?: number): Promise<void>;

  /**
   * Check whether the specific app has turned on or off app lock.
   *
   * @permission ohos.permission.READ_DLP_HIDE_SWITCH
   * @param { string } bundleName - The bundle name.
   * @param { number } appIndex - The app index.
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<boolean> } Result of switch state. True indicates switch is on, false otherwise.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - The caller is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
   *  2. Incorrect parameter types.
   * @throws { BusinessError } 801 - Capability not supported.function passDlpHideInfo can not work correctly due to
   *  limited device capabilities.
   * @throws { BusinessError } 1017800001 - Internal error.
   * @syscap SystemCapability.Security.DlpInfoHide
   * @systemapi
   * @since 5.1.0(18)
   */
  function isDlpHideSwitchOn(bundleName: string, appIndex?: number, userId?: number): Promise<boolean>;

  /**
   * Get array of app info with the app lock switch turned on.
   *
   * @permission ohos.permission.READ_DLP_HIDE_SWITCH
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<AppInfo[]> } The array of switch enabled app info.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - The caller is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
   *  2. Incorrect parameter types.
   * @throws { BusinessError } 801 - Capability not supported.function passDlpHideInfo can not work correctly due to
   *  limited device capabilities.
   * @throws { BusinessError } 1017800001 - Internal error.
   * @syscap SystemCapability.Security.DlpInfoHide
   * @systemapi
   * @since 5.1.0(18)
   */
  function getSwitchOnAppInfos(userId?: number): Promise<AppInfo[]>;

  /**
   * Get array of recommended app info.
   *
   * @permission ohos.permission.READ_DLP_HIDE_SWITCH
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<AppInfo[]> } The array of app info.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - The caller is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
   *  2. Incorrect parameter types.
   * @throws { BusinessError } 801 - Capability not supported.function passDlpHideInfo can not work correctly due to
   *  limited device capabilities.
   * @throws { BusinessError } 1017800001 - Internal error.
   * @syscap SystemCapability.Security.DlpInfoHide
   * @systemapi
   * @since 5.1.0(18)
   */
  function getRecommendedBundleInfos(userId?: number): Promise<AppInfo[]>;

  /**
   * Check whether the specific bundle name recommended.
   *
   * @permission ohos.permission.READ_DLP_HIDE_SWITCH
   * @param { string } bundleName - The bundle name.
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<boolean> } Returns {@code true} indicates the bundle name should be recommended,
   * {@code false} otherwise.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - The caller is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
   *  2. Incorrect parameter types.
   * @throws { BusinessError } 801 - Capability not supported.function passDlpHideInfo can not work correctly due to
   *  limited device capabilities.
   * @throws { BusinessError } 1017800001 - Internal error.
   * @syscap SystemCapability.Security.DlpInfoHide
   * @systemapi
   * @since 5.1.0(18)
   */
  function isRecommendedBundleName(bundleName: string, userId?: number): Promise<boolean>;

  /**
   * Set enabled state of dlp hide.
   *
   * @permission ohos.permission.WRITE_DLP_HIDE_SWITCH
   * @param { boolean } enabled - The enabled state.
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<void> } Promise used to return the result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - The caller is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
   *  2. Incorrect parameter types.
   * @throws { BusinessError } 801 - Capability not supported.function passDlpHideInfo can not work correctly due to
   *  limited device capabilities.
   * @throws { BusinessError } 1017800001 - Internal error.
   * @syscap SystemCapability.Security.DlpInfoHide
   * @systemapi
   * @since 5.1.0(18)
   */
  function setDlpHideStatus(enabled: boolean, userId?: number): Promise<void>;

  /**
   * Check the enabled state of dlp hide.
   *
   * @permission ohos.permission.READ_DLP_HIDE_SWITCH
   * @param { number } userId - The userId. Default is main userId.
   * @returns { Promise<boolean> } Result of enabled state. True indicates app lock is enabled, false otherwise.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - The caller is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
   *  2. Incorrect parameter types.
   * @throws { BusinessError } 801 - Capability not supported.function passDlpHideInfo can not work correctly due to
   *  limited device capabilities.
   * @throws { BusinessError } 1017800001 - Internal error.
   * @syscap SystemCapability.Security.DlpInfoHide
   * @systemapi
   * @since 5.1.0(18)
   */
  function isDlpHideStatusOn(userId?: number): Promise<boolean>;
}
export default dlpHideInfo;
