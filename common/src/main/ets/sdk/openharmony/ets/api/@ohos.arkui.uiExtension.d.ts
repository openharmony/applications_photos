/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @file
 * @kit ArkUI
 */


import { Callback } from './@ohos.base';
import window from './@ohos.window';

/**
 * uiExtension.
 *
 * @namespace uiExtension
 * @syscap SystemCapability.ArkUI.ArkUI.Full
 * @atomicservice
 * @since 12
 */
declare namespace uiExtension {
  /**
   * The proxy of the UIExtension window.
   *
   * @interface WindowProxy
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @atomicservice
   * @since 12
   */
  interface WindowProxy {
    /**
     * Get the avoid area.
     *
     * @param { window.AvoidAreaType } type - Type of the avoid area.
     * @returns { window.AvoidArea } Area where the window cannot be displayed.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     * <br> 1. Mandatory parameters are left unspecified.
     * <br> 2. Incorrect parameters types.
     * <br> 3. Parameter verification failed.
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @atomicservice
     * @since 12
     */
    getWindowAvoidArea(type: window.AvoidAreaType): window.AvoidArea;

    /**
     * Register the callback of avoidAreaChange.
     *
     * @param { 'avoidAreaChange' } type - The value is fixed at 'avoidAreaChange', indicating the event of changes to the avoid area.
     * @param { Callback<AvoidAreaInfo> } callback - Callback used to return the avoid area information.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     * <br> 1. Mandatory parameters are left unspecified.
     * <br> 2. Incorrect parameters types.
     * <br> 3. Parameter verification failed.
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @atomicservice
     * @since 12
     */
    on(type: 'avoidAreaChange', callback: Callback<AvoidAreaInfo>): void;

    /**
     * Unregister the callback of avoidAreaChange.
     *
     * @param { 'avoidAreaChange' } type - The value is fixed at 'avoidAreaChange', indicating the event of changes to the avoid area.
     * @param { Callback<AvoidAreaInfo> } callback - Callback used to return the avoid area information.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     * <br> 1. Mandatory parameters are left unspecified.
     * <br> 2. Incorrect parameters types.
     * <br> 3. Parameter verification failed.
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @atomicservice
     * @since 12
     */
    off(type: 'avoidAreaChange', callback?: Callback<AvoidAreaInfo>): void;

    /**
     * Register the callback of windowSizeChange.
     *
     * @param { 'windowSizeChange' } type - The value is fixed at 'windowSizeChange', indicating the window size change event.
     * @param { Callback<window.Size> } callback - Callback used to return the window size.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     * <br> 1. Mandatory parameters are left unspecified.
     * <br> 2. Incorrect parameters types.
     * <br> 3. Parameter verification failed.
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @atomicservice
     * @since 12
     */
    on(type: 'windowSizeChange', callback: Callback<window.Size>): void;

    /**
     * Unregister the callback of windowSizeChange.
     *
     * @param { 'windowSizeChange' } type - The value is fixed at 'windowSizeChange', indicating the window size change event.
     * @param { Callback<window.Size> } callback - Callback used to return the window size.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     * <br> 1. Mandatory parameters are left unspecified.
     * <br> 2. Incorrect parameters types.
     * <br> 3. Parameter verification failed.
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @atomicservice
     * @since 12
     */
    off(type: 'windowSizeChange', callback?: Callback<window.Size>): void;

    /**
     * Hide the non-secure windows.
     *
     * @param { boolean } shouldHide - Hide the non-secure windows if true, otherwise means the opposite.
     * @returns { Promise<void> } - The promise returned by the function.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     * <br> 1. Mandatory parameters are left unspecified.
     * <br> 2. Incorrect parameters types.
     * <br> 3. Parameter verification failed.
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @systemapi
     * @since 12
     */
    hideNonSecureWindows(shouldHide: boolean): Promise<void>;

    /**
     * Create sub window.
     *
     * @param { string } name - window name of sub window.
     * @param { window.SubWindowOptions } subWindowOptions - options of sub window creation.
     * @returns { Promise<window.Window> } Promise used to return the subwindow.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     * <br> 1. Mandatory parameters are left unspecified.
     * <br> 2. Incorrect parameters types.
     * <br> 3. Parameter verification failed.
     * @throws { BusinessError } 801 - Capability not supported. Failed to call the API due to limited device capabilities.
     * @throws { BusinessError } 1300002 - This window state is abnormal.
     * @throws { BusinessError } 1300005 - This window proxy is abnormal.
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @StageModelOnly
     * @atomicservice
     * @since 12
     */
    createSubWindowWithOptions(name: string, subWindowOptions: window.SubWindowOptions): Promise<window.Window>;

    /**
     * Set the watermark flag on the UIExtension window
     *
     * @param { boolean } enable - Add water mark flag to the UIExtension window if true, or remove flag if false
     * @returns { Promise<void> } - The promise returned by the function
     * @throws { BusinessError } 1300002 - The UIExtension window proxy is abnormal.
     * @throws { BusinessError } 1300003 - This window manager service works abnormally.
     * @throws { BusinessError } 1300008 - The display device is abnormal.
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @systemapi
     * @since 12
     */
    setWaterMarkFlag(enable: boolean): Promise<void>;

    /**
     * Set events that only need to be handled by the UIExtension provider
     *
     * @param { EventFlag } eventFlags - The events to be set.
     * @returns { Promise<void> } - The promise returned by the function
     * @throws { BusinessError } 401 - Parameter error. Possible cause:
     * <br> 1. Mandatory parameters are left unspecified.
     * <br> 2. Incorrect parameters types.
     * <br> 3. Parameter verification failed.
     * @throws { BusinessError } 1300002 - This window state is abnormal.
     * @throws { BusinessError } 1300003 - This window manager service works abnormally.
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @atomicservice
     * @since 18
     */
    occupyEvents(eventFlags: number): Promise<void>;

    /**
     * Hide the display content when snapshot.
     *
     * @param { boolean } shouldHide - Hide the display content of UIExtensionAbility when the host application takes
     * snapshots if true, otherwise means the opposite.
     * @returns { Promise<void> } - The promise returned by the function.
     * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     * <br> 1. Mandatory parameters are left unspecified.
     * <br> 2. Incorrect parameters types.
     * <br> 3. Parameter verification failed.
     * @throws { BusinessError } 1300002 - Abnormal state. Possible causes:
     * <br> 1. The UIExtension window proxy is abnormal.
     * <br> 2. Not the UIExtensionAbility process calling.
     * @systemapi
     * @since 13
     */
    hidePrivacyContentForHost(shouldHide: boolean): Promise<void>;
  }

  /**
   * Gesture event type
   *
   * @enum { number }
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @atomicservice
   * @since 18
   */
  enum EventFlag {
    /**
     * None gesture event
     *
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @atomicservice
     * @since 18
     */
    EVENT_NONE = 0x00000000,
    /**
     * Pan gesture left events
     *
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @atomicservice
     * @since 18
     */
    EVENT_PAN_GESTURE_LEFT = 0x00000001,
    /**
     * Pan gesture right events
     *
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @atomicservice
     * @since 18
     */
    EVENT_PAN_GESTURE_RIGHT = 0x00000002,
    /**
     * Pan gesture up events
     *
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @atomicservice
     * @since 18
     */
    EVENT_PAN_GESTURE_UP = 0x00000004,
    /**
     * Pan gesture down events
     *
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @atomicservice
     * @since 18
     */
    EVENT_PAN_GESTURE_DOWN = 0x00000008,
    /**
     * Click gesture events
     *
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @atomicservice
     * @since 18
     */
    EVENT_CLICK = 0x00000100,
    /**
     * Long press gesture events
     *
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @atomicservice
     * @since 18
     */
    EVENT_LONG_PRESS = 0x00000200,
  }

  /**
   * Defines the avoid area information.
   *
   * @interface AvoidAreaInfo
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @atomicservice
   * @since 12
   */
  interface AvoidAreaInfo {
    /**
     * Describes the type of avoid area.
     *
     * @type { window.AvoidAreaType }
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @atomicservice
     * @since 12
     */
    type: window.AvoidAreaType;

    /**
     * Describes the position and size of avoid area.
     *
     * @type { window.AvoidArea }
     * @syscap SystemCapability.ArkUI.ArkUI.Full
     * @atomicservice
     * @since 12
     */
    area: window.AvoidArea;
  }
}

export default uiExtension;
