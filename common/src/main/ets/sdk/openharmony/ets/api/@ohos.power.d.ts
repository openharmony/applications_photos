/*
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
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
 * @file
 * @kit BasicServicesKit
 */

import { AsyncCallback, BusinessError } from './@ohos.base';

/**
 * Provides interfaces to manage power.
 *
 * @namespace power
 * @syscap SystemCapability.PowerManager.PowerManager.Core
 * @since 7
 */
declare namespace power {
  /**
   * Shuts down the system.
   * <p>This method requires the ohos.permission.REBOOT permission.
   *
   * @permission ohos.permission.REBOOT
   * @param { string } reason Indicates the shutdown reason.
   * reason parameter must be of type string.
   * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
   * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Incorrect parameter types;
   * @throws { BusinessError } 4900101 - Failed to connect to the service.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @systemapi
   * @since 7
   */
  function shutdown(reason: string): void;

  /**
   * Restarts the system.
   * <p>This method requires the ohos.permission.REBOOT permission.
   *
   * @permission ohos.permission.REBOOT
   * @param { string } reason Indicates the restart reason. For example, "updater" indicates entering the updater mode
   * after the restart. If the parameter is not specified, the system enters the normal mode after the restart.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @since 7
   * @deprecated since 9
   * @useinstead power#reboot
   */
  function rebootDevice(reason: string): void;

  /**
   * Restarts the system.
   * <p>This method requires the ohos.permission.REBOOT permission.
   *
   * @permission ohos.permission.REBOOT
   * @param { string } reason Indicates the restart reason. For example, "updater" indicates entering the updater mode
   * after the restart. If the parameter is not specified, the system enters the normal mode after the restart.
   * reason parameter must be of type string.
   * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
   * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Incorrect parameter types;
   * @throws { BusinessError } 4900101 - Failed to connect to the service.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @systemapi
   * @since 9
   */
  function reboot(reason: string): void;

  /**
   * Checks whether the screen of a device is on or off.
   *
   * @param { AsyncCallback<boolean> } callback Returns true if the screen is on; returns false otherwise.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @since 7
   * @deprecated since 9
   * @useinstead power#isActive
   */
  function isScreenOn(callback: AsyncCallback<boolean>): void;

  /**
   * Checks whether the screen of a device is on or off.
   *
   * @returns { Promise<boolean> } Returns true if the screen is on; returns false otherwise.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @since 7
   * @deprecated since 9
   * @useinstead power#isActive
   */
  function isScreenOn(): Promise<boolean>;

  /**
   * Checks whether the device is active.
   * <p>
   * The screen will be on if device is active, screen will be off otherwise.
   *
   * @returns { boolean } Returns true if the device is active; returns false otherwise.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @since 9
   */
  function isActive(): boolean;

  /**
   * Wakes up the device to turn on the screen.
   *
   * @param { string } detail Indicates the detail information who request wakeup.
   * detail parameter must be of type string.
   * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Incorrect parameter types;
   * @throws { BusinessError } 4900101 - Failed to connect to the service.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @systemapi
   * @since 9
   */
  /**
   * Wakes up the device to turn on the screen with permission.
   *
   * @permission ohos.permission.POWER_MANAGER
   * @param { string } detail Indicates the detail information who request wakeup.
   * detail parameter must be of type string.
   * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
   * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Incorrect parameter types;
   * @throws { BusinessError } 4900101 - Failed to connect to the service.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @systemapi
   * @since 19
   */
  function wakeup(detail: string): void;

  /**
   * Suspends the device to turn off the screen.
   *
   * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Parameter verification failed.
   * @throws { BusinessError } 4900101 - Failed to connect to the service.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @systemapi
   * @since 9
   */
  /**
   * Suspends the device to turn off the screen.
   *
   * @param { boolean } isImmediate Indicates whether suspend the device immediately.
   * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Parameter verification failed.
   * @throws { BusinessError } 4900101 - Failed to connect to the service.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @systemapi
   * @since 10
   */
  /**
   * Suspends the device to turn off the screen with permission.
   *
   * @permission ohos.permission.POWER_MANAGER
   * @param { boolean } isImmediate Indicates whether suspend the device immediately.
   * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
   * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Parameter verification failed.
   * @throws { BusinessError } 4900101 - Failed to connect to the service.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @systemapi
   * @since 19
   */
  function suspend(isImmediate?: boolean): void;

  /**
   * Obtains the power mode of the current device. For details, see {@link DevicePowerMode}.
   *
   * @returns { DevicePowerMode } The power mode {@link DevicePowerMode} of current device .
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @since 9
   */
  function getPowerMode(): DevicePowerMode;

  /**
   * Obtains the power mode of the current device. For details, see {@link DevicePowerMode}.
   *
   * @permission ohos.permission.POWER_OPTIMIZATION
   * @param { DevicePowerMode } mode Indicates power mode {@link DevicePowerMode} to set.
   * the DevicePowerMode type is an enumeration class.
   * @param { AsyncCallback<void> } callback Indicates the callback of setting the power mode.
   * @throws { BusinessError } 201 – Permission verification failed. The application does not have the permission required to call the API.
   * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Parameter verification failed.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @systemapi
   * @since 9
   */
  function setPowerMode(mode: DevicePowerMode, callback: AsyncCallback<void>): void;

  /**
   * Sets the power mode of current device. For details, see {@link DevicePowerMode}.
   *
   * @permission ohos.permission.POWER_OPTIMIZATION
   * @param { DevicePowerMode } mode Indicates power mode {@link DevicePowerMode} to set.
   * the DevicePowerMode type is an enumeration class.
   * @returns { Promise<void> }
   * @throws { BusinessError } 201 – Permission verification failed. The application does not have the permission required to call the API.
   * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Parameter verification failed.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @systemapi
   * @since 9
   */
  function setPowerMode(mode: DevicePowerMode): Promise<void>;

  /**
   * Returns true if the device is currently in idle mode.
   *
   * @returns { boolean } Returns true if the device is in idle mode; returns false otherwise.
   * @throws { BusinessError } 4900101 - Failed to connect to the service.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @since 10
   */
  function isStandby(): boolean;

  /**
   * hibernate the device.
   *
   * @param { boolean } clearMemory - Indicates whether to clear the memory before the device hibernates.
   * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Parameter verification failed.
   * @throws { BusinessError } 4900101 - Failed to connect to the service.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @systemapi
   * @since 12
   */
  /**
   * hibernate the device with permission.
   *
   * @permission ohos.permission.POWER_MANAGER
   * @param { boolean } clearMemory - Indicates whether to clear the memory before the device hibernates.
   * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
   * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Parameter verification failed.
   * @throws { BusinessError } 4900101 - Failed to connect to the service.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @systemapi
   * @since 19
   */
  function hibernate(clearMemory: boolean): void;

  /**
   * Sets the timeout duration(ms) for turning off the screen.
   *
   * @param { number } timeout - Indicates duration(ms) for turning off the screen. The value -1 means restore the default value.
   * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Parameter verification failed.
   * @throws { BusinessError } 4900101 - Failed to connect to the service.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @systemapi
   * @since 12
   */
  /**
   * Sets the timeout duration(ms) for turning off the screen with permission.
   *
   * @permission ohos.permission.POWER_MANAGER
   * @param { number } timeout - Indicates duration(ms) for turning off the screen. The value -1 means restore the default value.
   * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
   * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Parameter verification failed.
   * @throws { BusinessError } 4900101 - Failed to connect to the service.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @systemapi
   * @since 19
   */
  function setScreenOffTime(timeout: number): void;

  /**
   * Power mode of a device.
   *
   * @enum { number }
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @since 9
   */
  export enum DevicePowerMode {
    /**
     * Normal power mode
     *
     * @syscap SystemCapability.PowerManager.PowerManager.Core
     * @since 9
     */
    MODE_NORMAL = 600,
    /**
     * Power save mode
     *
     * @syscap SystemCapability.PowerManager.PowerManager.Core
     * @since 9
     */
    MODE_POWER_SAVE,
    /**
     * Performance power mode
     *
     * @syscap SystemCapability.PowerManager.PowerManager.Core
     * @since 9
     */
    MODE_PERFORMANCE,
    /**
     * Extreme power save mode
     *
     * @syscap SystemCapability.PowerManager.PowerManager.Core
     * @since 9
     */
    MODE_EXTREME_POWER_SAVE,
    /**
     * Custom power save mode
     *
     * @syscap SystemCapability.PowerManager.PowerManager.Core
     * @since 9
     */
    MODE_CUSTOM_POWER_SAVE
  }
}
export default power;
