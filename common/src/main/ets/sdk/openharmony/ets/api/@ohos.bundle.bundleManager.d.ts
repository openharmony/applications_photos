/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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
 * @kit AbilityKit
 */

import { AsyncCallback } from './@ohos.base';
import type { ApplicationInfo as _ApplicationInfo, ModuleMetadata as _ModuleMetadata,
  PreinstalledApplicationInfo as _PreinstalledApplicationInfo } from './bundleManager/ApplicationInfo';
import { Metadata as _Metadata } from './bundleManager/Metadata';
import { PermissionDef as _PermissionDef } from './bundleManager/PermissionDef';
import { ElementName as _ElementName } from './bundleManager/ElementName';
import { SharedBundleInfo as _SharedBundleInfo } from './bundleManager/SharedBundleInfo';
import type { RecoverableApplicationInfo as _RecoverableApplicationInfo } from './bundleManager/RecoverableApplicationInfo';
import Want from './@ohos.app.ability.Want';
import * as _AbilityInfo from './bundleManager/AbilityInfo';
import * as _AppProvisionInfo from './bundleManager/AppProvisionInfo';
import * as _BundleInfo from './bundleManager/BundleInfo';
import * as _HapModuleInfo from './bundleManager/HapModuleInfo';
import * as _ExtensionAbilityInfo from './bundleManager/ExtensionAbilityInfo';
import * as _Skill from './bundleManager/Skill';
/**
 * This module is used to obtain package information of various applications installed on the current device.
 *
 * @namespace bundleManager
 * @syscap SystemCapability.BundleManager.BundleFramework.Core
 * @since 9
 */
/**
 * This module is used to obtain package information of various applications installed on the current device.
 *
 * @namespace bundleManager
 * @syscap SystemCapability.BundleManager.BundleFramework.Core
 * @atomicservice
 * @since 11
 */
/**
 * This module is used to obtain package information of various applications installed on the current device.
 *
 * @namespace bundleManager
 * @syscap SystemCapability.BundleManager.BundleFramework.Core
 * @crossplatform
 * @atomicservice
 * @since 12
 */
declare namespace bundleManager {
  /**
   * Used to query the enumeration value of bundleInfo. Multiple values can be passed in the form.
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Used to query the enumeration value of bundleInfo. Multiple values can be passed in the form.
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  enum BundleFlag {
    /**
     * Used to obtain the default bundleInfo. The obtained bundleInfo does not contain information of
     * signatureInfo, applicationInfo, hapModuleInfo, ability, extensionAbility and permission.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Used to obtain the default bundleInfo. The obtained bundleInfo does not contain information of
     * signatureInfo, applicationInfo, hapModuleInfo, ability, extensionAbility and permission.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    GET_BUNDLE_INFO_DEFAULT = 0x00000000,
    /**
     * Used to obtain the bundleInfo containing applicationInfo. The obtained bundleInfo does not
     * contain the information of signatureInfo, hapModuleInfo, ability, extensionAbility and permission.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Used to obtain the bundleInfo containing applicationInfo. The obtained bundleInfo does not
     * contain the information of signatureInfo, hapModuleInfo, ability, extensionAbility and permission.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    GET_BUNDLE_INFO_WITH_APPLICATION = 0x00000001,
    /**
     * Used to obtain the bundleInfo containing hapModuleInfo. The obtained bundleInfo does not
     * contain the information of signatureInfo, applicationInfo, ability, extensionAbility and permission.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Used to obtain the bundleInfo containing hapModuleInfo. The obtained bundleInfo does not
     * contain the information of signatureInfo, applicationInfo, ability, extensionAbility and permission.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    GET_BUNDLE_INFO_WITH_HAP_MODULE = 0x00000002,
    /**
     * Used to obtain the bundleInfo containing ability. The obtained bundleInfo does not
     * contain the information of signatureInfo, applicationInfo, extensionAbility and permission.
     * It can't be used alone, it needs to be used with GET_BUNDLE_INFO_WITH_HAP_MODULE.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Used to obtain the bundleInfo containing ability. The obtained bundleInfo does not
     * contain the information of signatureInfo, applicationInfo, extensionAbility and permission.
     * It can't be used alone, it needs to be used with GET_BUNDLE_INFO_WITH_HAP_MODULE.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    GET_BUNDLE_INFO_WITH_ABILITY = 0x00000004,
    /**
     * Used to obtain the bundleInfo containing extensionAbility. The obtained bundleInfo does not
     * contain the information of signatureInfo, applicationInfo, ability and permission.
     * It can't be used alone, it needs to be used with GET_BUNDLE_INFO_WITH_HAP_MODULE.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Used to obtain the bundleInfo containing extensionAbility. The obtained bundleInfo does not
     * contain the information of signatureInfo, applicationInfo, ability and permission.
     * It can't be used alone, it needs to be used with GET_BUNDLE_INFO_WITH_HAP_MODULE.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    GET_BUNDLE_INFO_WITH_EXTENSION_ABILITY = 0x00000008,
    /**
     * Used to obtain the bundleInfo containing permission. The obtained bundleInfo does not
     * contain the information of signatureInfo, applicationInfo, hapModuleInfo, extensionAbility and ability.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Used to obtain the bundleInfo containing permission. The obtained bundleInfo does not
     * contain the information of signatureInfo, applicationInfo, hapModuleInfo, extensionAbility and ability.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    GET_BUNDLE_INFO_WITH_REQUESTED_PERMISSION = 0x00000010,
    /**
     * Used to obtain the metadata contained in applicationInfo, moduleInfo and abilityInfo.
     * It can't be used alone, it needs to be used with GET_BUNDLE_INFO_WITH_APPLICATION,
     * GET_BUNDLE_INFO_WITH_HAP_MODULE, GET_BUNDLE_INFO_WITH_ABILITIES, GET_BUNDLE_INFO_WITH_EXTENSION_ABILITY.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Used to obtain the metadata contained in applicationInfo, moduleInfo and abilityInfo.
     * It can't be used alone, it needs to be used with GET_BUNDLE_INFO_WITH_APPLICATION,
     * GET_BUNDLE_INFO_WITH_HAP_MODULE, GET_BUNDLE_INFO_WITH_ABILITIES, GET_BUNDLE_INFO_WITH_EXTENSION_ABILITY.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    GET_BUNDLE_INFO_WITH_METADATA = 0x00000020,
    /**
     * Used to obtain the default bundleInfo containing disabled application and ability.
     * The obtained bundleInfo does not contain information of signatureInfo, applicationInfo,
     * hapModuleInfo, ability, extensionAbility and permission.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Used to obtain the default bundleInfo containing disabled application and ability.
     * The obtained bundleInfo does not contain information of signatureInfo, applicationInfo,
     * hapModuleInfo, ability, extensionAbility and permission.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    GET_BUNDLE_INFO_WITH_DISABLE = 0x00000040,
    /**
     * Used to obtain the bundleInfo containing signatureInfo. The obtained bundleInfo does not
     * contain the information of applicationInfo, hapModuleInfo, extensionAbility, ability and permission.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Used to obtain the bundleInfo containing signatureInfo. The obtained bundleInfo does not
     * contain the information of applicationInfo, hapModuleInfo, extensionAbility, ability and permission.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    GET_BUNDLE_INFO_WITH_SIGNATURE_INFO = 0x00000080,
    /**
     * Used to obtain the bundleInfo containing menu configuration in hapModuleInfo.
     * The obtained bundleInfo does not contain the information of applicationInfo, extensionAbility,
     * ability and permission.
     * It can't be used alone, it needs to be used with GET_BUNDLE_INFO_WITH_HAP_MODULE.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    GET_BUNDLE_INFO_WITH_MENU = 0x00000100,
    /**
     * Used to obtain the bundleInfo containing router map configuration in hapModuleInfo.
     * The obtained bundleInfo does not contain the information of applicationInfo, extensionAbility,
     * ability and permission.
     * It can't be used alone, it needs to be used with GET_BUNDLE_INFO_WITH_HAP_MODULE.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 12
     */
    GET_BUNDLE_INFO_WITH_ROUTER_MAP = 0x00000200,
    /**
     * Used to obtain the skillInfo contained in abilityInfo and extensionInfo.
     * It can't be used alone, it needs to be used with GET_BUNDLE_INFO_WITH_HAP_MODULE,
     * GET_BUNDLE_INFO_WITH_ABILITIES, GET_BUNDLE_INFO_WITH_EXTENSION_ABILITY.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 12
     */
    GET_BUNDLE_INFO_WITH_SKILL = 0x00000800,
    /**
     * Used to return only the applications that have an icon displayed on the homescreen.
     * Only effective on {@link getAllBundleInfo}
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 12
     */
    GET_BUNDLE_INFO_ONLY_WITH_LAUNCHER_ABILITY = 0x00001000,
    /**
     * Used to obtain the bundleInfo only if any user installed
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 12
     */
    GET_BUNDLE_INFO_OF_ANY_USER = 0x00002000,
    /**
     * Used to return all applications that exclude app clone information.
     * Only effective on {@link getAllBundleInfo}
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 12
     */
    GET_BUNDLE_INFO_EXCLUDE_CLONE = 0x00004000,
  }

  /**
   * Used to query the enumeration value of applicationInfo. Multiple values can be passed in the form.
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  enum ApplicationFlag {
    /**
     * Used to obtain the default applicationInfo. The obtained applicationInfo does not contain the information of
     * permission and metadata.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 9
     */
    GET_APPLICATION_INFO_DEFAULT = 0x00000000,
    /**
     * Used to obtain the applicationInfo containing permission.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 9
     */
    GET_APPLICATION_INFO_WITH_PERMISSION = 0x00000001,
    /**
     * Used to obtain the applicationInfo containing metadata.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 9
     */
    GET_APPLICATION_INFO_WITH_METADATA = 0x00000002,
    /**
     * Used to obtain the applicationInfo containing disabled application.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 9
     */
    GET_APPLICATION_INFO_WITH_DISABLE = 0x00000004
  }

  /**
   * Used to query the enumeration value of abilityInfo. Multiple values can be passed in the form.
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  enum AbilityFlag {
    /**
     * Used to obtain the default abilityInfo. The obtained abilityInfo does not contain the information of
     * permission, metadata and disabled abilityInfo.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 9
     */
    GET_ABILITY_INFO_DEFAULT = 0x00000000,
    /**
     * Used to obtain the abilityInfo containing permission.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 9
     */
    GET_ABILITY_INFO_WITH_PERMISSION = 0x00000001,
    /**
     * Used to obtain the abilityInfo containing applicationInfo.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 9
     */
    GET_ABILITY_INFO_WITH_APPLICATION = 0x00000002,
    /**
     * Used to obtain the abilityInfo containing metadata.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 9
     */
    GET_ABILITY_INFO_WITH_METADATA = 0x00000004,
    /**
     * Used to obtain the abilityInfo containing disabled abilityInfo.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 9
     */
    GET_ABILITY_INFO_WITH_DISABLE = 0x00000008,
    /**
     * Used to obtain the abilityInfo only for system app.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 9
     */
    /**
     * Used to obtain the abilityInfo only for system app.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 11
     */
    GET_ABILITY_INFO_ONLY_SYSTEM_APP = 0x00000010,
    /**
     * Used to obtain the abilityInfo with domain verification.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 12
     */
    GET_ABILITY_INFO_WITH_APP_LINKING = 0x00000040,
    /**
     * Used to obtain the abilityInfo with Skill
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 12
     */
    GET_ABILITY_INFO_WITH_SKILL = 0x00000080,
  }

  /**
   * Used to query the enumeration value of ExtensionAbilityInfo. Multiple values can be passed in the form.
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  enum ExtensionAbilityFlag {
    /**
     * Used to obtain the default extensionAbilityInfo. The obtained extensionAbilityInfo does not contain the
     * information of permission, metadata and disabled abilityInfo.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 9
     */
    GET_EXTENSION_ABILITY_INFO_DEFAULT = 0x00000000,
    /**
     * Used to obtain the extensionAbilityInfo containing permission.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 9
     */
    GET_EXTENSION_ABILITY_INFO_WITH_PERMISSION = 0x00000001,
    /**
     * Used to obtain the extensionAbilityInfo containing applicationInfo.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 9
     */
    GET_EXTENSION_ABILITY_INFO_WITH_APPLICATION = 0x00000002,
    /**
     * Used to obtain the extensionAbilityInfo containing metadata.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 9
     */
    GET_EXTENSION_ABILITY_INFO_WITH_METADATA = 0x00000004,
    /**
     * Used to obtain the extensionAbilityInfo with Skill
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 12
     */
    GET_EXTENSION_ABILITY_INFO_WITH_SKILL = 0x00000010,
  }

  /**
   * This enumeration value is used to identify various types of extension ability
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * This enumeration value is used to identify various types of extension ability
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export enum ExtensionAbilityType {
    /**
     * Indicates extension info with type of form
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates extension info with type of form
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    FORM = 0,

    /**
     * Indicates extension info with type of work schedule
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    WORK_SCHEDULER = 1,

    /**
     * Indicates extension info with type of input method
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    INPUT_METHOD = 2,

    /**
     * Indicates extension info with type of service
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    SERVICE = 3,

    /**
     * Indicates extension info with type of accessibility
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    ACCESSIBILITY = 4,

    /**
     * Indicates extension info with type of dataShare
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    DATA_SHARE = 5,

    /**
     * Indicates extension info with type of filesShare
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    FILE_SHARE = 6,

    /**
     * Indicates extension info with type of staticSubscriber
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    STATIC_SUBSCRIBER = 7,

    /**
     * Indicates extension info with type of wallpaper
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    WALLPAPER = 8,

    /**
     * Indicates extension info with type of backup
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    BACKUP = 9,

    /**
     * Indicates extension info with type of window
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    WINDOW = 10,

    /**
     * Indicates extension info with type of enterprise admin
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    ENTERPRISE_ADMIN = 11,

    /**
     * Indicates extension info with type of thumbnail
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    THUMBNAIL = 13,

    /**
     * Indicates extension info with type of preview
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    PREVIEW = 14,

    /**
     * Indicates extension info with type of print
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 10
     */
    PRINT = 15,

    /**
     * Indicates extension info with type of share
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 10
     */
    SHARE = 16,

    /**
     * Indicates extension info with type of push
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 10
     */
    PUSH = 17,

    /**
     * Indicates extension info with type of driver
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 10
     */
    DRIVER = 18,

    /**
     * Indicates extension info with type of action
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 10
     */
    ACTION = 19,

    /**
     * Indicates extension info with type of ads service
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 11
     */
    ADS_SERVICE = 20,

    /**
     * Indicates extension info with type of embedded UI
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 12
     */
    EMBEDDED_UI = 21,

    /**
     * Indicates extension info with type of insight intent UI
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 12
     */
    INSIGHT_INTENT_UI = 22,

    /**
     * Indicates extension info with type of FENCE
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 18
     */
    FENCE = 24,

    /**
     * Indicates extension info with type of CALLER_INFO_QUERY
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 19
     */
    CALLER_INFO_QUERY = 25,

    /**
     * Indicates extension info with type of asset acceleration
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 18
     */
    ASSET_ACCELERATION = 26,

    /**
     * Indicates extension info with type of form edit
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 18
     */
    FORM_EDIT = 27,

    /**
     * Indicates extension info with type of distributed
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 18
     */
    DISTRIBUTED = 28,

    /**
     * Indicates extension info with type of app service
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 20
     */
    APP_SERVICE = 29,

    /**
     * Indicates extension info with type of the live form
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 20
     */
    LIVE_FORM = 30,

    /**
     * Indicates extension info with type of unspecified
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    UNSPECIFIED = 255
  }

  /**
   * PermissionGrantState
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * PermissionGrantState
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export enum PermissionGrantState {
    /**
     * PERMISSION_DENIED
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * PERMISSION_DENIED
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    PERMISSION_DENIED = -1,

    /**
     * PERMISSION_GRANTED
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * PERMISSION_GRANTED
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    PERMISSION_GRANTED = 0
  }

  /**
   * Support window mode
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Support window mode
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export enum SupportWindowMode {
    /**
     * Indicates supported window mode of full screen mode
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates supported window mode of full screen mode
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    FULL_SCREEN = 0,
    /**
     * Indicates supported window mode of split mode
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates supported window mode of split mode
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    SPLIT = 1,
    /**
     * Indicates supported window mode of floating mode
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates supported window mode of floating mode
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    FLOATING = 2
  }

  /**
   * Launch type
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Launch type
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @crossplatform
   * @since 10
   */
  /**
   * Launch type
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @crossplatform
   * @atomicservice
   * @since 11
   */
  export enum LaunchType {
    /**
     * Indicates that the ability has only one instance
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates that the ability has only one instance
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @crossplatform
     * @since 10
     */
    /**
     * Indicates that the ability has only one instance
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @crossplatform
     * @atomicservice
     * @since 11
     */
    SINGLETON = 0,

    /**
     * Indicates that the ability can have multiple instances
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates that the ability can have multiple instances
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @crossplatform
     * @since 10
     */
    /**
     * Indicates that the ability can have multiple instances
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @crossplatform
     * @atomicservice
     * @since 11
     */
    MULTITON = 1,

    /**
     * Indicates that the ability can have specified instances
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates that the ability can have specified instances
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    SPECIFIED = 2
  }

  /**
   * Indicates ability type
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @FAModelOnly
   * @since 9
   */
  export enum AbilityType {
    /**
     * Indicates that the ability has a UI
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @FAModelOnly
     * @since 9
     */
    PAGE = 1,

    /**
     * Indicates that the ability does not have a UI
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @FAModelOnly
     * @since 9
     */
    SERVICE = 2,

    /**
     * Indicates that the ability is used to provide data access services
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @FAModelOnly
     * @since 9
     */
    DATA = 3
  }

  /**
   * Display orientation
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Display orientation
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export enum DisplayOrientation {
    /**
     * Indicates that the system automatically determines the display orientation
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates that the system automatically determines the display orientation
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    UNSPECIFIED,

    /**
     * Indicates the landscape orientation
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates the landscape orientation
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    LANDSCAPE,

    /**
     * Indicates the portrait orientation
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates the portrait orientation
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    PORTRAIT,

    /**
     * Indicates the page ability orientation is the same as that of the nearest ability in the stack
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates the page ability orientation is the same as that of the nearest ability in the stack
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    FOLLOW_RECENT,

    /**
     * Indicates the inverted landscape orientation
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates the inverted landscape orientation
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    LANDSCAPE_INVERTED,

    /**
     * Indicates the inverted portrait orientation
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates the inverted portrait orientation
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    PORTRAIT_INVERTED,

    /**
     * Indicates the orientation can be auto-rotated
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates the orientation can be auto-rotated
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    AUTO_ROTATION,

    /**
     * Indicates the landscape orientation rotated with sensor
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates the landscape orientation rotated with sensor
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    AUTO_ROTATION_LANDSCAPE,

    /**
     * Indicates the portrait orientation rotated with sensor
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates the portrait orientation rotated with sensor
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    AUTO_ROTATION_PORTRAIT,

    /**
     * Indicates the sensor restricted mode
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates the sensor restricted mode
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    AUTO_ROTATION_RESTRICTED,

    /**
     * Indicates the sensor landscape restricted mode
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates the sensor landscape restricted mode
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    AUTO_ROTATION_LANDSCAPE_RESTRICTED,

    /**
     * Indicates the sensor portrait restricted mode
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates the sensor portrait restricted mode
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    AUTO_ROTATION_PORTRAIT_RESTRICTED,

    /**
     * Indicates the locked orientation mode
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates the locked orientation mode
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    LOCKED,

    /**
     * Indicates the system automatically determines the sensor restricted mode
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 12
     */
    AUTO_ROTATION_UNSPECIFIED,

    /**
     * Indicates the orientation follow the desktop rotate mode
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 12
     */
    FOLLOW_DESKTOP
  }

  /**
   * Indicates module type
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Indicates module type
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export enum ModuleType {
    /**
     * Indicates entry type
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates entry type
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    ENTRY = 1,
    /**
     * Indicates feature type
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates feature type
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    FEATURE = 2,
    /**
     * Indicates shared type
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates shared type
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    SHARED = 3
  }

  /**
   * Indicates bundle type
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Indicates bundle type
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export enum BundleType {
    /**
     * Indicates app
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates app
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    APP = 0,
    /**
     * Indicates atomic service
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 9
     */
    /**
     * Indicates atomic service
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    ATOMIC_SERVICE = 1
  }

  /**
   * Shared bundle compatible policy
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 10
   */
  /**
   * Shared bundle compatible policy
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export enum CompatiblePolicy {
    /**
     * Indicates that the app is a shared bundle and the shared bundle type is backward compatibility
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 10
     */
    /**
     * Indicates that the app is a shared bundle and the shared bundle type is backward compatibility
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @atomicservice
     * @since 11
     */
    BACKWARD_COMPATIBILITY = 1
  }

  /**
   * This enumeration value is used to identify various types of JSON profile.
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 11
   */
  export enum ProfileType {
    /**
     * Indicates JSON profile about intent framework.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 11
     */
    INTENT_PROFILE = 1
  }

  /**
   * This enumeration value is used to identify the distribution type of application.
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  export enum AppDistributionType {
    /**
     * Indicates the application is distributed by the App Gallery.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 12
     */
    APP_GALLERY = 1,

    /**
     * Indicates the enterprise application, which can be installed in personal devices.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 12
     */
    ENTERPRISE = 2,

    /**
     * Indicates the normal enterprise application.
     * This kind of application can only be installed on enterprise devices through the enterprise MDM application and
     * does not require device management privileges.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 12
     */
    ENTERPRISE_NORMAL = 3,

    /**
     * Indicates the enterprise MDM application, which can only be installed on enterprise devices.
     * This kind of application requires device management privileges, such as remote locking, which can install normal
     * enterprise applications, etc.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 12
     */
    ENTERPRISE_MDM = 4,

    /**
     * Indicates the system preinstalled application.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 12
     */
    OS_INTEGRATION = 5,

    /**
     * Indicates the crowdtesting application.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 12
     */
    CROWDTESTING = 6,

    /**
     * Indicates other types of application.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 12
     */
    NONE = 7
  }

  /**
   * This enumeration value is used to identify various types of extension ability
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 12
  */
  export enum MultiAppModeType {
    /**
     * Indicates multi app mode with type of unspecified
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 12
     */
    UNSPECIFIED = 0,
    /**
     * Indicates multi app mode with type of multiInstance
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 12
     */
    MULTI_INSTANCE = 1,
    /**
     * Indicates multi app mode with type of appClone
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @since 12
    */
    APP_CLONE = 2,
  }

  /**
   * This enumeration value is used to identify various flags of application
   *
   * @enum { number }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
  */
  export enum ApplicationInfoFlag {
    /**
     * Indicates the application is currently installed for the calling user.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 12
     */
    FLAG_INSTALLED = 0x00000001,
    /**
     * Indicates the application is currently installed for the other user.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 15
     */
    FLAG_OTHER_INSTALLED = 0x00000010,
    /**
     * Indicates the application is a preinstall app.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 15
     */
    FLAG_PREINSTALLED_APP = 0x00000020,
    /**
     * Indicates the application is an updated preinstall app.
     *
     * @syscap SystemCapability.BundleManager.BundleFramework.Core
     * @systemapi
     * @since 15
     */
    FLAG_PREINSTALLED_APP_UPDATE = 0x00000040,
  }

  /**
   * Obtains own bundleInfo.
   *
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo objects
   *     that will be returned.
   * @returns { Promise<BundleInfo> } The result of getting the bundle info.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Obtains own bundleInfo.
   *
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo objects
   *     that will be returned.
   * @returns { Promise<BundleInfo> } The result of getting the bundle info.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  function getBundleInfoForSelf(bundleFlags: number): Promise<BundleInfo>;

  /**
   * Obtains own bundleInfo.
   *
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo objects
   *     that will be returned.
   * @param { AsyncCallback<BundleInfo> } callback - The callback of getting bundle info result.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Obtains own bundleInfo.
   *
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo objects
   *     that will be returned.
   * @param { AsyncCallback<BundleInfo> } callback - The callback of getting bundle info result.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  function getBundleInfoForSelf(bundleFlags: number, callback: AsyncCallback<BundleInfo>): void;

  /**
   * Obtains own bundleInfo.
   *
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo objects
   *     that will be returned.
   * @returns { BundleInfo } The result of getting the bundle info.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 10
   */
  /**
   * Obtains own bundleInfo.
   *
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo objects
   *     that will be returned.
   * @returns { BundleInfo } The result of getting the bundle info.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  function getBundleInfoForSelfSync(bundleFlags: number): BundleInfo;

  /**
   * Obtains bundleInfo based on bundleName, bundleFlags.
   * The application requires to be a system application when requesting the permission of
   * ohos.permission.GET_BUNDLE_INFO.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { string } bundleName - Indicates the application bundle name to be queried.
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo objects
   *     that will be returned.
   * @param { AsyncCallback<BundleInfo> } callback - The callback of getting bundle info result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 14
   */
  function getBundleInfo(bundleName: string, bundleFlags: number, callback: AsyncCallback<BundleInfo>): void;

  /**
   * Obtains bundleInfo based on bundleName, bundleFlags and userId.
   * The application requires to be a system application when requesting the permission of
   * ohos.permission.GET_BUNDLE_INFO.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { string } bundleName - Indicates the application bundle name to be queried.
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo objects
   *     that will be returned.
   * @param { number } userId - Indicates the user ID or do not pass user ID.
   * @param { AsyncCallback<BundleInfo> } callback - The callback of getting bundle info result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 14
   */
  function getBundleInfo(bundleName: string,
    bundleFlags: number, userId: number, callback: AsyncCallback<BundleInfo>): void;

  /**
   * Obtains bundleInfo based on bundleName, bundleFlags and userId.
   * The application requires to be a system application when requesting the permission of
   * ohos.permission.GET_BUNDLE_INFO.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { string } bundleName - Indicates the application bundle name to be queried.
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo objects
   *     that will be returned.
   * @param { number } userId - Indicates the user ID or do not pass user ID.
   * @returns { Promise<BundleInfo> } The result of getting the bundle info.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 14
   */
  function getBundleInfo(bundleName: string, bundleFlags: number, userId?: number): Promise<BundleInfo>;

  /**
   * Obtains application info based on a given bundle name. ohos.permission.GET_BUNDLE_INFO_PRIVILEGED is required for
   * cross user access.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { string } bundleName - Indicates the application bundle name to be queried.
   * @param { number } appFlags - Indicates the flag used to specify information contained in the ApplicationInfo
   *     objects that will be returned.
   * @param { AsyncCallback<ApplicationInfo> } callback - The callback of getting application info result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getApplicationInfo(bundleName: string, appFlags: number, callback: AsyncCallback<ApplicationInfo>): void;

  /**
   * Obtains application info based on a given bundle name. ohos.permission.GET_BUNDLE_INFO_PRIVILEGED is required for
   * cross user access.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { string } bundleName - Indicates the application bundle name to be queried.
   * @param { number } appFlags - Indicates the flag used to specify information contained in the ApplicationInfo
   *     objects that will be returned.
   * @param { number } userId - Indicates the user ID or do not pass user ID.
   * @param { AsyncCallback<ApplicationInfo> } callback - The callback of getting application info result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getApplicationInfo(bundleName: string,
    appFlags: number, userId: number, callback: AsyncCallback<ApplicationInfo>): void;

  /**
   * Obtains application info based on a given bundle name. ohos.permission.GET_BUNDLE_INFO_PRIVILEGED is required for
   * cross user access.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { string } bundleName - Indicates the application bundle name to be queried.
   * @param { number } appFlags - Indicates the flag used to specify information contained in the ApplicationInfo
   *     objects that will be returned.
   * @param { number } userId - Indicates the user ID or do not pass user ID.
   * @returns { Promise<ApplicationInfo> } The result of getting the application info.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getApplicationInfo(bundleName: string, appFlags: number, userId?: number): Promise<ApplicationInfo>;

  /**
   * Obtains BundleInfo of all bundles available in the system.
   *
   * @permission ohos.permission.GET_INSTALLED_BUNDLE_LIST
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo that
   *     will be returned.
   * @param { AsyncCallback<Array<BundleInfo>> } callback - The callback of getting a list of BundleInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getAllBundleInfo(bundleFlags: number, callback: AsyncCallback<Array<BundleInfo>>): void;

  /**
   * Obtains BundleInfo of all bundles available in the system.
   *
   * @permission ohos.permission.GET_INSTALLED_BUNDLE_LIST
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo that
   *     will be returned.
   * @param { number } userId - Indicates the user id.
   * @param { AsyncCallback<Array<BundleInfo>> } callback - The callback of getting a list of BundleInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getAllBundleInfo(bundleFlags: number, userId: number, callback: AsyncCallback<Array<BundleInfo>>): void;

  /**
   * Obtains BundleInfo of all bundles available in the system.
   *
   * @permission ohos.permission.GET_INSTALLED_BUNDLE_LIST
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo that
   *     will be returned.
   * @param { number } userId - Indicates the user id.
   * @returns { Promise<Array<BundleInfo>> } Returns a list of BundleInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getAllBundleInfo(bundleFlags: number, userId?: number): Promise<Array<BundleInfo>>;

  /**
   * Obtains information about all installed applications of a specified user.
   *
   * @permission ohos.permission.GET_INSTALLED_BUNDLE_LIST
   * @param { number } appFlags - Indicates the flag used to specify information contained in the ApplicationInfo
   *     objects that will be returned.
   * @param { AsyncCallback<Array<ApplicationInfo>> } callback - The callback of getting a list of ApplicationInfo
   *     objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getAllApplicationInfo(appFlags: number, callback: AsyncCallback<Array<ApplicationInfo>>): void;

  /**
   * Obtains information about all installed applications of a specified user.
   *
   * @permission ohos.permission.GET_INSTALLED_BUNDLE_LIST
   * @param { number } appFlags - Indicates the flag used to specify information contained in the ApplicationInfo
   *     objects that will be returned.
   * @param { number } userId - Indicates the user ID or do not pass user ID.
   * @param { AsyncCallback<Array<ApplicationInfo>> } callback - The callback of getting a list of ApplicationInfo
   *     objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getAllApplicationInfo(appFlags: number,
    userId: number, callback: AsyncCallback<Array<ApplicationInfo>>): void;

  /**
   * Obtains information about all installed applications of a specified user.
   *
   * @permission ohos.permission.GET_INSTALLED_BUNDLE_LIST
   * @param { number } appFlags - Indicates the flag used to specify information contained in the ApplicationInfo
   *     objects that will be returned.
   * @param { number } userId - Indicates the user ID or do not pass user ID.
   * @returns { Promise<Array<ApplicationInfo>> } Returns a list of ApplicationInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getAllApplicationInfo(appFlags: number, userId?: number): Promise<Array<ApplicationInfo>>;

  /**
   * Query the AbilityInfo by the given Want. ohos.permission.GET_BUNDLE_INFO_PRIVILEGED is required for cross user
   * access.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { Want } want - Indicates the Want containing the application bundle name to be queried.
   * @param { number } abilityFlags - Indicates the flag used to specify information contained in the AbilityInfo
   *     objects that will be returned.
   * @param { AsyncCallback<Array<AbilityInfo>> } callback - The callback of querying ability info result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * 2. Incorrect parameter types;
   * 3. At least one parameter(action, entity, uri or type) is required for implicit query.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified ability is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @throws { BusinessError } 17700029 - The specified ability is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function queryAbilityInfo(want: Want, abilityFlags: number, callback: AsyncCallback<Array<AbilityInfo>>): void;

  /**
   * Query the AbilityInfo by the given Want. ohos.permission.GET_BUNDLE_INFO_PRIVILEGED is required for cross user
   * access.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { Want } want - Indicates the Want containing the application bundle name to be queried.
   * @param { number } abilityFlags - Indicates the flag used to specify information contained in the AbilityInfo
   *     objects that will be returned.
   * @param { number } userId - userId Indicates the user ID.
   * @param { AsyncCallback<Array<AbilityInfo>> } callback - The callback of querying ability info result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * 2. Incorrect parameter types;
   * 3. At least one parameter(action, entity, uri or type) is required for implicit query.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified ability is not found.
   * @throws { BusinessError } 17700004 - The specified userId is invalid.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @throws { BusinessError } 17700029 - The specified ability is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function queryAbilityInfo(want: Want,
    abilityFlags: number, userId: number, callback: AsyncCallback<Array<AbilityInfo>>): void;

  /**
   * Query the AbilityInfo by the given Want. ohos.permission.GET_BUNDLE_INFO_PRIVILEGED is required for cross user
   * access.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { Want } want - Indicates the Want containing the application bundle name to be queried.
   * @param { number } abilityFlags - Indicates the flag used to specify information contained in the AbilityInfo
   *     objects that will be returned.
   * @param { number } userId - userId Indicates the user ID.
   * @returns { Promise<Array<AbilityInfo>> } Returns a list of AbilityInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * 2. Incorrect parameter types;
   * 3. At least one parameter(action, entity, uri or type) is required for implicit query.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified ability is not found.
   * @throws { BusinessError } 17700004 - The specified userId is invalid.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @throws { BusinessError } 17700029 - The specified ability is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function queryAbilityInfo(want: Want, abilityFlags: number, userId?: number): Promise<Array<AbilityInfo>>;

  /**
   * Query the AbilityInfo by the given Want Array. ohos.permission.GET_BUNDLE_INFO_PRIVILEGED is required for cross
   * user access.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { Array<Want> } wants - Indicates the Want Array containing the application bundle name to be queried.
   * @param { number } abilityFlags - Indicates the flag used to specify information contained in the AbilityInfo
   *     objects that will be returned.
   * @param { number } [userId] - userId Indicates the user ID.
   * @returns { Promise<Array<AbilityInfo>> } Returns a list of AbilityInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * 2. Incorrect parameter types;
   * 3. At least one parameter(action, entity, uri or type) is required for implicit query.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified ability is not found.
   * @throws { BusinessError } 17700004 - The specified userId is invalid.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @throws { BusinessError } 17700029 - The specified ability is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function queryAbilityInfo(wants: Array<Want>, abilityFlags: number, userId?: number): Promise<Array<AbilityInfo>>;

  /**
   * Query the AbilityInfo by the given Want. ohos.permission.GET_BUNDLE_INFO_PRIVILEGED is required for cross user
   * access.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { Want } want - Indicates the Want containing the application bundle name to be queried.
   * @param { number } abilityFlags - Indicates the flag used to specify information contained in the AbilityInfo
   *     objects that will be returned.
   * @param { number } userId - userId Indicates the user ID.
   * @returns { Array<AbilityInfo> } Returns a list of AbilityInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * 2. Incorrect parameter types;
   * 3. At least one parameter(action, entity, uri or type) is required for implicit query.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified ability is not found.
   * @throws { BusinessError } 17700004 - The specified userId is invalid.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @throws { BusinessError } 17700029 - The specified ability is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function queryAbilityInfoSync(want: Want, abilityFlags: number, userId?: number): Array<AbilityInfo>;
  
  /**
   * Get AbilityInfo by the given uri.
   *
   * @permission ohos.permission.GET_ABILITY_INFO
   * @param { string } uri - Indicates the uri used for matching ability.
   * @param { number } abilityFlags {@link AbilityFlag} - Indicates the flag used to specify information contained in
   *     the AbilityInfo objects that will be returned.
   * @returns { Promise<Array<AbilityInfo>> } Returns a list of AbilityInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 17700003 - The ability is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 20
   */
  function getAbilityInfo(uri: string, abilityFlags: number): Promise<Array<AbilityInfo>>;

  /**
   * Query extension info of by utilizing a Want. ohos.permission.GET_BUNDLE_INFO_PRIVILEGED is required for cross user
   * access.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { Want } want - Indicates the Want containing the application bundle name to be queried.
   * @param { ExtensionAbilityType } extensionAbilityType - Indicates ExtensionAbilityType.
   * @param { number } extensionAbilityFlags - Indicates the flag used to specify information contained in the
   *  ExtensionAbilityInfo objects that will be returned.
   * @param { AsyncCallback<Array<ExtensionAbilityInfo>> } callback - The callback of querying extension ability info
   *     result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * 2. Incorrect parameter types;
   * 3. At least one parameter(action, entity, uri or type) is required for implicit query.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified extensionAbility is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function queryExtensionAbilityInfo(want: Want, extensionAbilityType: ExtensionAbilityType,
    extensionAbilityFlags: number, callback: AsyncCallback<Array<ExtensionAbilityInfo>>): void;

  /**
   * Query extension info of by utilizing a Want. ohos.permission.GET_BUNDLE_INFO_PRIVILEGED is required for cross user
   * access.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { Want } want - Indicates the Want containing the application bundle name to be queried.
   * @param { ExtensionAbilityType } extensionAbilityType - Indicates ExtensionAbilityType.
   * @param { number } extensionAbilityFlags - Indicates the flag used to specify information contained in the
   *  ExtensionAbilityInfo objects that will be returned.
   * @param { number } userId - Indicates the user ID.
   * @param { AsyncCallback<Array<ExtensionAbilityInfo>> } callback - The callback of querying extension ability info
   *     result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * 2. Incorrect parameter types;
   * 3. At least one parameter(action, entity, uri or type) is required for implicit query.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified extensionAbility is not found.
   * @throws { BusinessError } 17700004 - The specified userId is invalid.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function queryExtensionAbilityInfo(want: Want, extensionAbilityType: ExtensionAbilityType,
    extensionAbilityFlags: number, userId: number, callback: AsyncCallback<Array<ExtensionAbilityInfo>>): void;

  /**
   * Query the ExtensionAbilityInfo by the given Want. ohos.permission.GET_BUNDLE_INFO_PRIVILEGED is required for cross
   * user access.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { Want } want - Indicates the Want containing the application bundle name to be queried.
   * @param { ExtensionAbilityType } extensionAbilityType - Indicates ExtensionAbilityType.
   * @param { number } extensionAbilityFlags - Indicates the flag used to specify information contained in the
   *  ExtensionAbilityInfo objects that will be returned.
   * @param { number } userId - Indicates the user ID.
   * @returns { Promise<Array<ExtensionAbilityInfo>> } Returns a list of ExtensionAbilityInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * 2. Incorrect parameter types;
   * 3. At least one parameter(action, entity, uri or type) is required for implicit query.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified extensionAbility is not found.
   * @throws { BusinessError } 17700004 - The specified userId is invalid.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function queryExtensionAbilityInfo(want: Want, extensionAbilityType: ExtensionAbilityType,
    extensionAbilityFlags: number, userId?: number): Promise<Array<ExtensionAbilityInfo>>;

  /**
   * Query the ExtensionAbilityInfo by the given Want. ohos.permission.GET_BUNDLE_INFO_PRIVILEGED is required for cross
   * user access.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { Want } want - Indicates the Want containing the application bundle name to be queried.
   * @param { ExtensionAbilityType } extensionAbilityType - Indicates ExtensionAbilityType.
   * @param { number } extensionAbilityFlags - Indicates the flag used to specify information contained in the
   *  ExtensionAbilityInfo objects that will be returned.
   * @param { number } userId - Indicates the user ID.
   * @returns { Array<ExtensionAbilityInfo> } Returns a list of ExtensionAbilityInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * 2. Incorrect parameter types;
   * 3. At least one parameter(action, entity, uri or type) is required for implicit query.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified extensionAbility is not found.
   * @throws { BusinessError } 17700004 - The specified userId is invalid.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function queryExtensionAbilityInfoSync(want: Want, extensionAbilityType: ExtensionAbilityType,
    extensionAbilityFlags: number, userId?: number): Array<ExtensionAbilityInfo>;

  /**
   * Query the ExtensionAbilityInfo by the given Want. ohos.permission.GET_BUNDLE_INFO_PRIVILEGED is required for cross
   * user access.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { Want } want - Indicates the Want containing the application bundle name to be queried.
   * @param { string } extensionAbilityType - Indicates extensionAbilityType.
   * @param { number } extensionAbilityFlags - Indicates the flag used to specify information contained in the
   *  ExtensionAbilityInfo objects that will be returned.
   * @param { number } userId - Indicates the user ID.
   * @returns { Array<ExtensionAbilityInfo> } Returns a list of ExtensionAbilityInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * 2. Incorrect parameter types;
   * 3. At least one parameter(action, entity, uri or type) is required for implicit query.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified extensionAbility is not found.
   * @throws { BusinessError } 17700004 - The specified userId is invalid.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 11
   */
  function queryExtensionAbilityInfoSync(want: Want, extensionAbilityType: string,
    extensionAbilityFlags: number, userId?: number): Array<ExtensionAbilityInfo>;

  /**
   * Query the ExtensionAbilityInfo by extension ability type. ohos.permission.GET_BUNDLE_INFO_PRIVILEGED is required
   * for cross user access.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { string } extensionAbilityType - Indicates ExtensionAbilityType.
   * @param { number } extensionAbilityFlags - Indicates the flag used to specify information contained in the
   *  ExtensionAbilityInfo objects that will be returned.
   * @param { number } userId - Indicates the user ID.
   * @returns { Array<ExtensionAbilityInfo> } Returns a list of ExtensionAbilityInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * 2. Incorrect parameter types; 3. Parameter extensionAbilityType is empty.
   * @throws { BusinessError } 17700003 - The specified extensionAbility is not found.
   * @throws { BusinessError } 17700004 - The specified userId is invalid.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 11
   */
  function queryExtensionAbilityInfoSync(extensionAbilityType: string, extensionAbilityFlags: number,
    userId?: number): Array<ExtensionAbilityInfo>;

  /**
   * Obtains bundle name by the given uid.
   * The application requires to be a system application when requesting the permission of
   * ohos.permission.GET_BUNDLE_INFO.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { number } uid - Indicates the UID of an application.
   * @param { AsyncCallback<string> } callback - The callback of getting bundle name.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700021 - The uid is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 14
   */
  function getBundleNameByUid(uid: number, callback: AsyncCallback<string>): void;

  /**
   * Obtains bundle name by the given uid.
   * The application requires to be a system application when requesting the permission of
   * ohos.permission.GET_BUNDLE_INFO.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { number } uid - Indicates the UID of an application.
   * @returns { Promise<string> } Returns the bundle name.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700021 - The uid is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 14
   */
  function getBundleNameByUid(uid: number): Promise<string>;

  /**
   * Obtains bundle name by the given uid.
   * The application requires to be a system application when requesting the permission of
   * ohos.permission.GET_BUNDLE_INFO.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { number } uid - Indicates the UID of an application.
   * @returns { string } Returns the bundle name.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700021 - The uid is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 14
   */
  function getBundleNameByUidSync(uid: number): string;

  /**
   * Obtains information about an application bundle contained in an ohos Ability Package (HAP).
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } hapFilePath - Indicates the path storing the HAP.
   *  The path should be the relative path to the data directory of the current application.
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo object
   *     to be returned.
   * @param { AsyncCallback<BundleInfo> } callback - The callback of getting bundle archive info result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700022 - The hapFilePath is invalid.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getBundleArchiveInfo(hapFilePath: string, bundleFlags: number, callback: AsyncCallback<BundleInfo>): void;

  /**
   * Obtains information about an application bundle contained in an ohos Ability Package (HAP).
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } hapFilePath - Indicates the path storing the HAP.
   *  The path should be the relative path to the data directory of the current application.
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo object
   *     to be returned.
   * @returns { Promise<BundleInfo> } Returns the BundleInfo object.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700022 - The hapFilePath is invalid.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getBundleArchiveInfo(hapFilePath: string, bundleFlags: number): Promise<BundleInfo>;

  /**
   * Obtains information about an application bundle contained in an ohos Ability Package (HAP).
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } hapFilePath - Indicates the path storing the HAP.
   *  The path should be the relative path to the data directory of the current application.
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo object
   *     to be returned.
   * @returns { BundleInfo } Returns the BundleInfo object.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700022 - The hapFilePath is invalid.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function getBundleArchiveInfoSync(hapFilePath: string, bundleFlags: number): BundleInfo;

  /**
   * Clears cache data of a specified application.
   *
   * @permission ohos.permission.REMOVE_CACHE_FILES
   * @param { string } bundleName - Indicates the bundle name of the application whose cache data is to be cleaned.
   * @param { AsyncCallback<void> } callback - The callback of cleaning bundle cache files result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700030 - The specified bundle does not support clearing of cache files.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function cleanBundleCacheFiles(bundleName: string, callback: AsyncCallback<void>): void;

  /**
   * Clears cache data of a specified application.
   *
   * @permission ohos.permission.REMOVE_CACHE_FILES
   * @param { string } bundleName - Indicates the bundle name of the application whose cache data is to be cleaned.
   * @returns { Promise<void> } Clean bundle cache files result
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700030 - The specified bundle does not support clearing of cache files.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function cleanBundleCacheFiles(bundleName: string): Promise<void>;

  /**
   * Clears cache data of a specified application.
   *
   * @permission ohos.permission.REMOVE_CACHE_FILES
   * @param { string } bundleName - Indicates the bundle name of the application whose cache data is to be cleaned.
   * @param { number } appIndex - Indicates the index of clone app.
   * @returns { Promise<void> } Clean bundle cache files result
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700030 - The specified bundle does not support clearing of cache files.
   * @throws { BusinessError } 17700061 - AppIndex not in valid range.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 15
   */
  function cleanBundleCacheFiles(bundleName: string, appIndex: number): Promise<void>;

  /**
   * Get the all bundle cache size of the current user.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @returns { Promise<number> } Returns all bundle cache size.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 15
   */
  function getAllBundleCacheSize(): Promise<number>;

  /**
   * Clean all bundle cache files of the current user, does not include the currently running program.
   *
   * @permission ohos.permission.REMOVE_CACHE_FILES
   * @returns { Promise<void> } Clear all bundle cache results.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 15
   */
  function cleanAllBundleCache(): Promise<void>;

  /**
   * Sets whether to enable a specified application.
   *
   * @permission ohos.permission.CHANGE_ABILITY_ENABLED_STATE
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @param { number } appIndex - Indicates the index of clone app.
   * @param { boolean } isEnabled - The value true means to enable it, and the value false means to disable it.
   * @returns { Promise<void> } set app enabled result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700061 - AppIndex not in valid range.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function setApplicationEnabled(bundleName: string, appIndex: number, isEnabled: boolean): Promise<void>;

  /**
   * Sets whether to enable a specified application.
   *
   * @permission ohos.permission.CHANGE_ABILITY_ENABLED_STATE
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @param { boolean } isEnabled - The value true means to enable it, and the value false means to disable it.
   * @param { AsyncCallback<void> } callback - The callback of setting app enabled result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function setApplicationEnabled(bundleName: string, isEnabled: boolean, callback: AsyncCallback<void>): void;

  /**
   * Sets whether to enable a specified application.
   *
   * @permission ohos.permission.CHANGE_ABILITY_ENABLED_STATE
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @param { boolean } isEnabled - The value true means to enable it, and the value false means to disable it.
   * @returns { Promise<void> } set app enabled result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function setApplicationEnabled(bundleName: string, isEnabled: boolean): Promise<void>;

  /**
   * Sets whether to enable a specified application.
   *
   * @permission ohos.permission.CHANGE_ABILITY_ENABLED_STATE
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @param { boolean } isEnabled - The value true means to enable it, and the value false means to disable it.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function setApplicationEnabledSync(bundleName: string, isEnabled: boolean): void;

  /**
   * Sets whether to enable a specified ability.
   *
   * @permission ohos.permission.CHANGE_ABILITY_ENABLED_STATE
   * @param { AbilityInfo } info - Indicates information about the ability to set.
   * @param { number } appIndex - Indicates the index of clone app.
   * @param { boolean } isEnabled - The value true means to enable it, and the value false means to disable it.
   * @returns { Promise<void> } set ability enabled result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified abilityInfo is not found.
   * @throws { BusinessError } 17700061 - AppIndex not in valid range.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function setAbilityEnabled(info: AbilityInfo, appIndex: number, isEnabled: boolean): Promise<void>;

  /**
   * Sets whether to enable a specified ability.
   *
   * @permission ohos.permission.CHANGE_ABILITY_ENABLED_STATE
   * @param { AbilityInfo } info - Indicates information about the ability to set.
   * @param { boolean } isEnabled - The value true means to enable it, and the value false means to disable it.
   * @param { AsyncCallback<void> } callback - The callback of setting ability enabled result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified abilityInfo is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function setAbilityEnabled(info: AbilityInfo, isEnabled: boolean, callback: AsyncCallback<void>): void;

  /**
   * Sets whether to enable a specified ability.
   *
   * @permission ohos.permission.CHANGE_ABILITY_ENABLED_STATE
   * @param { AbilityInfo } info - Indicates information about the ability to set.
   * @param { boolean } isEnabled - The value true means to enable it, and the value false means to disable it.
   * @returns { Promise<void> } set ability enabled result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified abilityInfo is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function setAbilityEnabled(info: AbilityInfo, isEnabled: boolean): Promise<void>;

  /**
   * Sets whether to enable a specified ability.
   *
   * @permission ohos.permission.CHANGE_ABILITY_ENABLED_STATE
   * @param { AbilityInfo } info - Indicates information about the ability to set.
   * @param { boolean } isEnabled - The value true means to enable it, and the value false means to disable it.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified abilityInfo is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function setAbilityEnabledSync(info: AbilityInfo, isEnabled: boolean): void;

  /**
   * Checks whether a specified application is enabled.
   *
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @param { number } appIndex - Indicates the index of clone app.
   * @returns { Promise<boolean> } Returns true if the application is enabled; returns false otherwise.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700061 - AppIndex not in valid range.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function isApplicationEnabled(bundleName: string, appIndex: number): Promise<boolean>;

  /**
   * Checks whether a specified application is enabled.
   *
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @param { AsyncCallback<boolean> } callback - The callback of checking application enabled result.
   *     The result is true if enabled, false otherwise.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function isApplicationEnabled(bundleName: string, callback: AsyncCallback<boolean>): void;

  /**
   * Checks whether a specified application is enabled.
   *
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @returns { Promise<boolean> } Returns true if the application is enabled; returns false otherwise.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function isApplicationEnabled(bundleName: string): Promise<boolean>;

  /**
   * Checks whether a specified application is enabled.
   *
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @returns { boolean } Returns true if the application is enabled; returns false otherwise.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function isApplicationEnabledSync(bundleName: string): boolean;

  /**
   * Checks whether a specified ability is enabled.
   *
   * @param { AbilityInfo } info - Indicates information about the ability to check.
   * @param { number } appIndex - Indicates the index of clone app.
   * @returns { Promise<boolean> } Returns true if the ability is enabled; returns false otherwise.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified abilityName is not found.
   * @throws { BusinessError } 17700061 - AppIndex not in valid range.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function isAbilityEnabled(info: AbilityInfo, appIndex: number): Promise<boolean>;

  /**
   * Checks whether a specified ability is enabled.
   *
   * @param { AbilityInfo } info - Indicates information about the ability to check.
   * @param { AsyncCallback<boolean> } callback - The callback of checking ability enabled result.
   *     The result is true if enabled, false otherwise.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified abilityName is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function isAbilityEnabled(info: AbilityInfo, callback: AsyncCallback<boolean>): void;

  /**
   * Checks whether a specified ability is enabled.
   *
   * @param { AbilityInfo } info - Indicates information about the ability to check.
   * @returns { Promise<boolean> } Returns true if the ability is enabled; returns false otherwise.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified abilityName is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function isAbilityEnabled(info: AbilityInfo): Promise<boolean>;

  /**
   * Checks whether a specified ability is enabled.
   *
   * @param { AbilityInfo } info - Indicates information about the ability to check.
   * @returns { boolean } Returns true if the ability is enabled; returns false otherwise.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700003 - The specified abilityName is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function isAbilityEnabledSync(info: AbilityInfo): boolean;

  /**
   * Obtains the Want for starting the main ability of an application based on the
   * given bundle name. The main ability of an application is the ability that has the
   * #ACTION_HOME and #ENTITY_HOME Want filters set in the application's <b>config.json</b> or <b>module.json</b> file.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @param { number } userId - Indicates the user ID or do not pass user ID.
   * @param { AsyncCallback<Want> } callback - The callback for starting the application's main ability.
   * @throws { BusinessError } 201 - Calling interface without permission 'ohos.permission.GET_BUNDLE_INFO_PRIVILEGED'.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getLaunchWantForBundle(bundleName: string, userId: number, callback: AsyncCallback<Want>): void;

  /**
   * Obtains the Want for starting the main ability of an application based on the
   * given bundle name. The main ability of an application is the ability that has the
   * #ACTION_HOME and #ENTITY_HOME Want filters set in the application's <b>config.json</b> or <b>module.json</b> file.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @param { AsyncCallback<Want> } callback - The callback for starting the application's main ability.
   * @throws { BusinessError } 201 - Calling interface without permission 'ohos.permission.GET_BUNDLE_INFO_PRIVILEGED'.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getLaunchWantForBundle(bundleName: string, callback: AsyncCallback<Want>): void;

  /**
   * Obtains the Want for starting the main ability of an application based on the
   * given bundle name. The main ability of an application is the ability that has the
   * #ACTION_HOME and #ENTITY_HOME Want filters set in the application's <b>config.json</b> or <b>module.json</b> file.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @param { number } userId - Indicates the user ID or do not pass user ID.
   * @returns { Promise<Want> } the Want for starting the application's main ability.
   * @throws { BusinessError } 201 - Calling interface without permission 'ohos.permission.GET_BUNDLE_INFO_PRIVILEGED'.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getLaunchWantForBundle(bundleName: string, userId?: number): Promise<Want>;

  /**
   * Obtains the Want for starting the main ability of an application based on the
   * given bundle name. The main ability of an application is the ability that has the
   * #ACTION_HOME and #ENTITY_HOME Want filters set in the application's <b>config.json</b> or <b>module.json</b> file.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @param { number } userId - Indicates the user ID or do not pass user ID.
   * @returns { Want } the Want for starting the application's main ability.
   * @throws { BusinessError } 201 - Calling interface without permission 'ohos.permission.GET_BUNDLE_INFO_PRIVILEGED'.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function getLaunchWantForBundleSync(bundleName: string, userId?: number): Want;

  /**
   * Obtains the Want for starting the main ability of own application.
   * The main ability of an application is the ability that has the
   * #ACTION_HOME and #ENTITY_HOME Want filters set in the application's <b>config.json</b> or <b>module.json</b> file.
   *
   * @returns { Want } the Want for starting the application's main ability.
   * @throws { BusinessError } 17700072 - The launch want is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 13
   */
  function getLaunchWant(): Want;

  /**
   * Obtains the profile designated by metadata name, abilityName and moduleName from the current application.
   *
   * @param { string } moduleName - Indicates the moduleName of the application.
   * @param { string } abilityName - Indicates the abilityName of the application.
   * @param { string } metadataName - Indicates the name of metadata in ability.
   * @param { AsyncCallback<Array<string>> } callback - The callback of returning string in json-format of the
   *     corresponding config file.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700002 - The specified moduleName is not existed.
   * @throws { BusinessError } 17700003 - The specified abilityName is not existed.
   * @throws { BusinessError } 17700024 - Failed to get the profile because there is no profile in the HAP.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @throws { BusinessError } 17700029 - The specified ability is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Obtains the profile designated by metadata name, abilityName and moduleName from the current application.
   *
   * @param { string } moduleName - Indicates the moduleName of the application.
   * @param { string } abilityName - Indicates the abilityName of the application.
   * @param { string } metadataName - Indicates the name of metadata in ability.
   * @param { AsyncCallback<Array<string>> } callback - The callback of returning string in json-format of the
   *     corresponding config file.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700002 - The specified moduleName is not existed.
   * @throws { BusinessError } 17700003 - The specified abilityName is not existed.
   * @throws { BusinessError } 17700024 - Failed to get the profile because there is no profile in the HAP.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @throws { BusinessError } 17700029 - The specified ability is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  function getProfileByAbility(moduleName: string, abilityName: string, metadataName: string,
    callback: AsyncCallback<Array<string>>): void;

  /**
   * Obtains the profile designated by metadata name, abilityName and moduleName from the current application.
   *
   * @param { string } moduleName - Indicates the moduleName of the application.
   * @param { string } abilityName - Indicates the abilityName of the application.
   * @param { string } metadataName - Indicates the name of metadata in ability.
   * @returns { Promise<Array<string>> } Returns string in json-format of the corresponding config file.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700002 - The specified moduleName is not existed.
   * @throws { BusinessError } 17700003 - The specified abilityName is not existed.
   * @throws { BusinessError } 17700024 - Failed to get the profile because there is no profile in the HAP.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @throws { BusinessError } 17700029 - The specified ability is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Obtains the profile designated by metadata name, abilityName and moduleName from the current application.
   *
   * @param { string } moduleName - Indicates the moduleName of the application.
   * @param { string } abilityName - Indicates the abilityName of the application.
   * @param { string } metadataName - Indicates the name of metadata in ability.
   * @returns { Promise<Array<string>> } Returns string in json-format of the corresponding config file.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700002 - The specified moduleName is not existed.
   * @throws { BusinessError } 17700003 - The specified abilityName is not existed.
   * @throws { BusinessError } 17700024 - Failed to get the profile because there is no profile in the HAP.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @throws { BusinessError } 17700029 - The specified ability is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  function getProfileByAbility(moduleName: string, abilityName: string, metadataName?: string): Promise<Array<string>>;

  /**
   * Obtains the profile designated by metadata name, abilityName and moduleName from the current application.
   *
   * @param { string } moduleName - Indicates the moduleName of the application.
   * @param { string } abilityName - Indicates the abilityName of the application.
   * @param { string } metadataName - Indicates the name of metadata in ability.
   * @returns { Array<string> } Returns string in json-format of the corresponding config file.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700002 - The specified moduleName is not existed.
   * @throws { BusinessError } 17700003 - The specified abilityName is not existed.
   * @throws { BusinessError } 17700024 - Failed to get the profile because there is no profile in the HAP.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @throws { BusinessError } 17700029 - The specified ability is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 10
   */
  /**
   * Obtains the profile designated by metadata name, abilityName and moduleName from the current application.
   *
   * @param { string } moduleName - Indicates the moduleName of the application.
   * @param { string } abilityName - Indicates the abilityName of the application.
   * @param { string } metadataName - Indicates the name of metadata in ability.
   * @returns { Array<string> } Returns string in json-format of the corresponding config file.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700002 - The specified moduleName is not existed.
   * @throws { BusinessError } 17700003 - The specified abilityName is not existed.
   * @throws { BusinessError } 17700024 - Failed to get the profile because there is no profile in the HAP.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @throws { BusinessError } 17700029 - The specified ability is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  function getProfileByAbilitySync(moduleName: string, abilityName: string, metadataName?: string): Array<string>;

  /**
   * Obtains the profile designated by metadata name, extensionAbilityName and moduleName from the current application.
   *
   * @param { string } moduleName - Indicates the moduleName of the application.
   * @param { string } extensionAbilityName - Indicates the extensionAbilityName of the application.
   * @param { string } metadataName - Indicates the name of metadata in ability.
   * @param { AsyncCallback<Array<string>> } callback - The callback of returning string in json-format of the
   *     corresponding config file.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700002 - The specified moduleName is not existed.
   * @throws { BusinessError } 17700003 - The specified extensionAbilityName not existed.
   * @throws { BusinessError } 17700024 - Failed to get the profile because there is no profile in the HAP.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Obtains the profile designated by metadata name, extensionAbilityName and moduleName from the current application.
   *
   * @param { string } moduleName - Indicates the moduleName of the application.
   * @param { string } extensionAbilityName - Indicates the extensionAbilityName of the application.
   * @param { string } metadataName - Indicates the name of metadata in ability.
   * @param { AsyncCallback<Array<string>> } callback - The callback of returning string in json-format of the
   *     corresponding config file.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700002 - The specified moduleName is not existed.
   * @throws { BusinessError } 17700003 - The specified extensionAbilityName not existed.
   * @throws { BusinessError } 17700024 - Failed to get the profile because there is no profile in the HAP.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  function getProfileByExtensionAbility(moduleName: string, extensionAbilityName: string, metadataName: string,
    callback: AsyncCallback<Array<string>>): void;

  /**
   * Obtains the profile designated by metadata name, extensionAbilityName and moduleName from the current application.
   *
   * @param { string } moduleName - Indicates the moduleName of the application.
   * @param { string } extensionAbilityName - Indicates the extensionAbilityName of the application.
   * @param { string } metadataName - Indicates the name of metadata in ability.
   * @returns { Promise<Array<string>> } Returns string in json-format of the corresponding config file.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700002 - The specified moduleName is not existed.
   * @throws { BusinessError } 17700003 - The specified extensionAbilityName not existed.
   * @throws { BusinessError } 17700024 - Failed to get the profile because there is no profile in the HAP.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Obtains the profile designated by metadata name, extensionAbilityName and moduleName from the current application.
   *
   * @param { string } moduleName - Indicates the moduleName of the application.
   * @param { string } extensionAbilityName - Indicates the extensionAbilityName of the application.
   * @param { string } metadataName - Indicates the name of metadata in ability.
   * @returns { Promise<Array<string>> } Returns string in json-format of the corresponding config file.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700002 - The specified moduleName is not existed.
   * @throws { BusinessError } 17700003 - The specified extensionAbilityName not existed.
   * @throws { BusinessError } 17700024 - Failed to get the profile because there is no profile in the HAP.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  function getProfileByExtensionAbility(moduleName: string, extensionAbilityName: string, metadataName?: string):
    Promise<Array<string>>;

  /**
   * Obtains the profile designated by metadata name, extensionAbilityName and moduleName from the current application.
   *
   * @param { string } moduleName - Indicates the moduleName of the application.
   * @param { string } extensionAbilityName - Indicates the extensionAbilityName of the application.
   * @param { string } metadataName - Indicates the name of metadata in ability.
   * @returns { Array<string> } Returns string in json-format of the corresponding config file.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700002 - The specified moduleName is not existed.
   * @throws { BusinessError } 17700003 - The specified extensionAbilityName not existed.
   * @throws { BusinessError } 17700024 - Failed to get the profile because there is no profile in the HAP.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 10
   */
  /**
   * Obtains the profile designated by metadata name, extensionAbilityName and moduleName from the current application.
   *
   * @param { string } moduleName - Indicates the moduleName of the application.
   * @param { string } extensionAbilityName - Indicates the extensionAbilityName of the application.
   * @param { string } metadataName - Indicates the name of metadata in ability.
   * @returns { Array<string> } Returns string in json-format of the corresponding config file.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700002 - The specified moduleName is not existed.
   * @throws { BusinessError } 17700003 - The specified extensionAbilityName not existed.
   * @throws { BusinessError } 17700024 - Failed to get the profile because there is no profile in the HAP.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  function getProfileByExtensionAbilitySync(moduleName: string, extensionAbilityName: string, metadataName?: string):
    Array<string>;

  /**
   * Get the permission details by permission name.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } permissionName - Indicates permission name.
   * @param { AsyncCallback<PermissionDef> } callback - The callback of get permissionDef object result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700006 - The specified permission is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getPermissionDef(permissionName: string, callback: AsyncCallback<PermissionDef>): void;

  /**
   * Get the permission details by permission name.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } permissionName - Indicates permission name.
   * @returns { Promise<PermissionDef> } Returns permissionDef object.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700006 - The specified permission is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getPermissionDef(permissionName: string): Promise<PermissionDef>;

  /**
   * Get the permission details by permission name.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } permissionName - Indicates permission name.
   * @returns { PermissionDef } Returns permissionDef object.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700006 - The specified permission is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function getPermissionDefSync(permissionName: string): PermissionDef;

  /**
   * Obtains the label of a specified ability.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { string } bundleName - Indicates the bundle name of the application to which the ability belongs.
   * @param { string } moduleName - Indicates the module name.
   * @param { string } abilityName - Indicates the ability name.
   * @param { AsyncCallback<string> } callback - The callback of getting ability label result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 801 - Capability not supported.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700002 - The specified moduleName is not found.
   * @throws { BusinessError } 17700003 - The specified abilityName is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @throws { BusinessError } 17700029 - The specified ability is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Resource
   * @systemapi
   * @since 9
   */
  function getAbilityLabel(bundleName: string, moduleName: string, abilityName: string,
    callback: AsyncCallback<string>): void;

  /**
   * Obtains the label of a specified ability.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { string } bundleName - Indicates the bundle name of the application to which the ability belongs.
   * @param { string } moduleName - Indicates the module name.
   * @param { string } abilityName - Indicates the ability name.
   * @returns { Promise<string> } Returns the label representing the label of the specified ability.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 801 - Capability not supported.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700002 - The specified moduleName is not found.
   * @throws { BusinessError } 17700003 - The specified abilityName is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @throws { BusinessError } 17700029 - The specified ability is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Resource
   * @systemapi
   * @since 9
   */
  function getAbilityLabel(bundleName: string, moduleName: string, abilityName: string): Promise<string>;

  /**
   * Obtains the label of a specified ability.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { string } bundleName - Indicates the bundle name of the application to which the ability belongs.
   * @param { string } moduleName - Indicates the module name.
   * @param { string } abilityName - Indicates the ability name.
   * @returns { string } Returns the label representing the label of the specified ability.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 801 - Capability not supported.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700002 - The specified moduleName is not found.
   * @throws { BusinessError } 17700003 - The specified abilityName is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @throws { BusinessError } 17700029 - The specified ability is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Resource
   * @systemapi
   * @since 10
   */
  function getAbilityLabelSync(bundleName: string, moduleName: string, abilityName: string): string;

  /**
   * Obtains applicationInfo based on a given bundleName and bundleFlags.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { string } bundleName - Indicates the application bundle name to be queried.
   * @param { number } applicationFlags - Indicates the flag used to specify information contained in the
   *     ApplicationInfo object that will be returned.
   * @param { number } userId - Indicates the user ID or do not pass user ID.
   * @returns { ApplicationInfo } - Returns the ApplicationInfo object.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getApplicationInfoSync(bundleName: string, applicationFlags: number, userId: number): ApplicationInfo;

  /**
   * Obtains applicationInfo based on a given bundleName and bundleFlags.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { string } bundleName - Indicates the application bundle name to be queried.
   * @param { number } applicationFlags - Indicates the flag used to specify information contained in the
   *     ApplicationInfo object that will be returned.
   * @returns { ApplicationInfo } - Returns the ApplicationInfo object.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  function getApplicationInfoSync(bundleName: string, applicationFlags: number): ApplicationInfo;

  /**
   * Obtains bundleInfo based on bundleName, bundleFlags and userId.
   * The application requires to be a system application when requesting the permission of
   * ohos.permission.GET_BUNDLE_INFO.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { string } bundleName - Indicates the application bundle name to be queried.
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo object
   *     that will be returned.
   * @param { number } userId - Indicates the user ID or do not pass user ID.
   * @returns { BundleInfo } - Returns the BundleInfo object.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 14
   */
  function getBundleInfoSync(bundleName: string, bundleFlags: number, userId: number): BundleInfo;

  /**
   * Obtains bundleInfo based on bundleName, bundleFlags.
   * The application requires to be a system application when requesting the permission of
   * ohos.permission.GET_BUNDLE_INFO.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { string } bundleName - Indicates the application bundle name to be queried.
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo object
   *     that will be returned.
   * @returns { BundleInfo } - Returns the BundleInfo object.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 14
   */
  function getBundleInfoSync(bundleName: string, bundleFlags: number): BundleInfo;

  /**
   * Obtains SharedBundleInfo of all shared bundle available in the system.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { AsyncCallback<Array<SharedBundleInfo>> } callback - The callback of getting a list of SharedBundleInfo
   *     objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function getAllSharedBundleInfo(callback: AsyncCallback<Array<SharedBundleInfo>>): void;

  /**
   * Obtains SharedBundleInfo of all shared bundle available in the system.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @returns { Promise<Array<SharedBundleInfo>> } Returns a list of SharedBundleInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function getAllSharedBundleInfo(): Promise<Array<SharedBundleInfo>>;

  /**
   * Obtains SharedBundleInfo of shared bundle by bundle name and module name.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the bundleName of the application.
   * @param { string } moduleName - Indicates the moduleName of the application.
   * @param { AsyncCallback<Array<SharedBundleInfo>> } callback - The callback of getting a list of SharedBundleInfo
   *     objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700002 - The specified moduleName is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function getSharedBundleInfo(bundleName: string, moduleName: string,
    callback: AsyncCallback<Array<SharedBundleInfo>>): void;

  /**
   * Obtains SharedBundleInfo of shared bundle by bundle name and module name.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the bundleName of the application.
   * @param { string } moduleName - Indicates the moduleName of the application.
   * @returns { Promise<Array<SharedBundleInfo>> } Returns a list of SharedBundleInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700002 - The specified moduleName is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function getSharedBundleInfo(bundleName: string, moduleName: string): Promise<Array<SharedBundleInfo>>;

  /**
   * Obtains the profile file information of a specified bundle.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the bundle name of the application to which the ability belongs.
   * @param { AsyncCallback<AppProvisionInfo> } callback - Indicates the callback of getting AppProvisionInfo result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * 2. Incorrect parameter types; 3. Parameter bundleName is empty.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function getAppProvisionInfo(bundleName: string, callback: AsyncCallback<AppProvisionInfo>): void;

  /**
   * Obtains the profile file information of a specified bundle.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the bundle name of the application to which the ability belongs.
   * @param { number } userId - Indicates the user ID or do not pass user ID.
   * @param { AsyncCallback<AppProvisionInfo> } callback - Indicates the callback of getting AppProvisionInfo result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * 2. Incorrect parameter types; 3. Parameter bundleName is empty.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function getAppProvisionInfo(bundleName: string, userId: number, callback: AsyncCallback<AppProvisionInfo>): void;

  /**
   * Obtains the profile file information of a specified bundle.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the bundle name of the application to which the ability belongs.
   * @param { number } userId - Indicates the user ID or do not pass user ID.
   * @returns { Promise<AppProvisionInfo> } Returns the AppProvisionInfo object.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * 2. Incorrect parameter types; 3. Parameter bundleName is empty.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function getAppProvisionInfo(bundleName: string, userId?: number): Promise<AppProvisionInfo>;

  /**
   * Obtains the profile file information of a specified bundle.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the bundle name of the application to which the ability belongs.
   * @param { number } userId - Indicates the user ID or do not pass user ID.
   * @returns { AppProvisionInfo } Returns the AppProvisionInfo object.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   *  2. Incorrect parameter types; 3. Parameter bundleName is empty.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function getAppProvisionInfoSync(bundleName: string, userId?: number): AppProvisionInfo;

  /**
   * Obtains the distribution type specified during bundle installation.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the application bundle name to be queried.
   * @returns { string } The specified distribution type.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function getSpecifiedDistributionType(bundleName: string): string;

  /**
   * Obtains the additional information during bundle installation.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the application bundle name to be queried.
   * @returns { string } The additional information.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * 2. Incorrect parameter types; 3. Parameter bundleName is empty.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  function getAdditionalInfo(bundleName: string): string;

  /**
   * Obtains the JSON profile designated by profileType, bundleName and moduleName.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { ProfileType } profileType - Indicates the type of profile to be obtained.
   * @param { string } bundleName - Indicates the name of the bundle to which the profile belongs.
   * @param { string } moduleName - Indicates the name of the module to which the profile belongs.
   * @returns { string } Returns string in json-format of the designated profile.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700002 - The specified moduleName is not found.
   * @throws { BusinessError } 17700024 - Failed to get the profile because the specified profile is not found in the
   *     HAP.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 11
   */
  /**
   * Obtains the JSON profile designated by profileType, bundleName, moduleName and userId.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { ProfileType } profileType - Indicates the type of profile to be obtained.
   * @param { string } bundleName - Indicates the name of the bundle to which the profile belongs.
   * @param { string } moduleName - Indicates the name of the module to which the profile belongs.
   * @param { number } userId - Indicates the user ID or do not pass user ID.
   * @returns { string } Returns string in json-format of the designated profile.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700002 - The specified moduleName is not found.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @throws { BusinessError } 17700024 - Failed to get the profile because the specified profile is not found in the
   *     HAP.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function getJsonProfile(profileType: ProfileType, bundleName: string, moduleName?: string, userId?: number): string;

   /**
   * Get extend resources.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { string } bundleName - Indicates the bundleName.
   * @returns { Promise<Array<string>> } Returns getExtResource result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700303 - Failed to obtain extended resources.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
   function getExtResource(bundleName: string): Promise<Array<string>>;

  /**
   * Enable dynamic icon.
   *
   * @permission ohos.permission.ACCESS_DYNAMIC_ICON
   * @param { string } bundleName - Indicates the bundleName.
   * @param { string } moduleName - Indicates the moduleName for extend resource.
   * @returns { Promise<void> } Returns enableDynamicIcon result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700002 - The specified moduleName is not found.
   * @throws { BusinessError } 17700304 - Failed to enable the dynamic icon.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function enableDynamicIcon(bundleName: string, moduleName: string): Promise<void>;

  /**
   * Disable dynamic icon.
   *
   * @permission ohos.permission.ACCESS_DYNAMIC_ICON
   * @param { string } bundleName - Indicates the bundleName.
   * @returns { Promise<void> } Returns disableDynamicIcon result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700305 - Failed to disable the dynamic icon.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function disableDynamicIcon(bundleName: string): Promise<void>;

  /**
   * Get dynamic icon.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { string } bundleName - Indicates the bundleName.
   * @returns { Promise<string> } Returns dynamic icon key.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700306 - Failed to obtain the dynamic icon.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function getDynamicIcon(bundleName: string): Promise<string>;

  /**
   * Verifies the validity of .abc files. Only .abc files passed the verification can run on the restricted VM.
   *
   * @permission ohos.permission.RUN_DYN_CODE
   * @param { Array<string> } abcPaths - The abc path.
   * @param { boolean } deleteOriginalFiles - Used to decide whether to delete the original files.
   * @param { AsyncCallback<void> } callback - Indicates the callback of verifyAbc result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700201 - Failed to verify the abc file.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 11
   */
  /**
   * Verifies the validity of .abc files. Only .abc files passed the verification can run on the restricted VM.
   *
   * @permission ohos.permission.RUN_DYN_CODE
   * @param { Array<string> } abcPaths - The abc path.
   * @param { boolean } deleteOriginalFiles - Used to decide whether to delete the original files.
   * @param { AsyncCallback<void> } callback - Indicates the callback of verifyAbc result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700201 - Failed to verify the abc file.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function verifyAbc(abcPaths: Array<string>, deleteOriginalFiles: boolean, callback: AsyncCallback<void>): void;

  /**
   * Verifies the validity of .abc files. Only .abc files passed the verification can run on the restricted VM.
   *
   * @permission ohos.permission.RUN_DYN_CODE
   * @param { Array<string> } abcPaths - The abc path.
   * @param { boolean } deleteOriginalFiles - Used to decide whether to delete the original files.
   * @returns { Promise<void> } Returns verifyAbc result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700201 - Failed to verify the abc file.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 11
   */
  /**
   * Verifies the validity of .abc files. Only .abc files passed the verification can run on the restricted VM.
   *
   * @permission ohos.permission.RUN_DYN_CODE
   * @param { Array<string> } abcPaths - The abc path.
   * @param { boolean } deleteOriginalFiles - Used to decide whether to delete the original files.
   * @returns { Promise<void> } Returns verifyAbc result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700201 - Failed to verify the abc file.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function verifyAbc(abcPaths: Array<string>, deleteOriginalFiles: boolean): Promise<void>;

  /**
   * Obtains recoverable preinstalled applications.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { AsyncCallback<Array<RecoverableApplicationInfo>> } callback - The callback of getting a list of
   *     RecoverableApplicationInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 11
   */
  function getRecoverableApplicationInfo(callback: AsyncCallback<Array<RecoverableApplicationInfo>>): void;

  /**
   * Obtains recoverable preinstalled applications.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @returns { Promise<Array<RecoverableApplicationInfo>> } Returns a list of RecoverableApplicationInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 11
   */
  function getRecoverableApplicationInfo(): Promise<Array<RecoverableApplicationInfo>>;

  /**
   * Set additional information to the specified application.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @param { string } additionalInfo - The additional information.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * 2. Incorrect parameter types; 3. Parameter bundleName is empty.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700053 - The caller is not AppGallery.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 11
   */
  function setAdditionalInfo(bundleName: string, additionalInfo: string): void;

  /**
   * Delete the verified .abc file.
   *
   * @permission ohos.permission.RUN_DYN_CODE
   * @param { string } abcPath - The abc path.
   * @returns { Promise<void> } Returns deleteAbc result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700202 - Failed to delete the abc file.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 11
   */
  /**
   * Delete the verified .abc file.
   *
   * @permission ohos.permission.RUN_DYN_CODE
   * @param { string } abcPath - The abc path.
   * @returns { Promise<void> } Returns deleteAbc result.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700202 - Failed to delete the abc file.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function deleteAbc(abcPath: string): Promise<void>;

  /**
   * Check whether the link can be opened.
   *
   * @param { string } link - Indicates the link to be opened.
   * @returns { boolean } Returns true if the link can be opened; returns false otherwise.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700055 - The specified link is invalid.
   * @throws { BusinessError } 17700056 - The scheme of the specified link is not in the querySchemes.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 12
   */
  function canOpenLink(link: string): boolean;

  /**
   * Obtains PreinstalledApplicationInfo of all applications preinstalled in the system.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @returns { Promise<Array<PreinstalledApplicationInfo>> } Returns a list of PreinstalledApplicationInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function getAllPreinstalledApplicationInfo(): Promise<Array<PreinstalledApplicationInfo>>;

  /**
   * Get a list of BundleInfo objects by developerId.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } developerId - Indicates the developerId of the application.
   * @returns { Array<BundleInfo> } Returns a list of BundleInfo objects.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * 2. Incorrect parameter types; 3. Parameter developerId is empty.
   * @throws { BusinessError } 17700059 - The specified developerId is invalid.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function getAllBundleInfoByDeveloperId(developerId: string): Array<BundleInfo>;

  /**
   * Get a list of developedId by distribution type.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { number } appDistributionType - Indicates the distribution type of the application, and if not passed in,
   *     it gets all the developerId.
   * @returns { Array<String> } Returns a list of developerId.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function getDeveloperIds(appDistributionType?: number): Array<String>;

  /**
   * Switch uninstall state of a specified application.
   *
   * @permission ohos.permission.CHANGE_BUNDLE_UNINSTALL_STATE
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @param { boolean } state - Indicates whether the specified application can be uninstalled.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700060 - The specified application cannot be uninstalled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function switchUninstallState(bundleName: string, state: boolean): void;

  /**
   * Get the SignatureInfo of the application through UID.
   *
   * @permission ohos.permission.GET_SIGNATURE_INFO
   * @param { number } uid - Indicates the UID of an application.
   * @returns { SignatureInfo } The result of getting the signature info.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700021 - The uid is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 18
   */
  function getSignatureInfo(uid: number): SignatureInfo;

  /**
   * Get the BundleInfo of the specified MultiIsolation App.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the application bundle name to be queried.
   * @param { number } appIndex - Indicates the index of clone app.
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo objects
   *     that will be returned.
   * @param { number } [userId] - Indicates the user ID, If the user id is not specified, the current user id is used by
   *     default.
   * @returns { Promise<BundleInfo> } Returns A BundleInfo Of MultiApp Mode.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @throws { BusinessError } 17700026 - The specified bundle is disabled.
   * @throws { BusinessError } 17700061 - AppIndex not in valid range.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function getAppCloneBundleInfo(bundleName: string, appIndex: number, bundleFlags: number, userId?: number):
    Promise<BundleInfo>;

  /**
   * Get all BundleInfo of clone app.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the application bundle name to be queried.
   * @param { number } bundleFlags - Indicates the flag used to specify information contained in the BundleInfo objects
   *     that will be returned.
   * @param { number } [userId] - Indicates the user ID, If the user id is not specified, the current user id is used by
   *     default.
   * @returns { Promise<Array<BundleInfo>> } Returns BundleInfo Arrays Of MultiApp Mode.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @throws { BusinessError } 17700026 - The specified bundle and clone apps are all disabled.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  function getAllAppCloneBundleInfo(bundleName: string, bundleFlags: number, userId?: number):
    Promise<Array<BundleInfo>>;

  /**
   * Obtains AppCloneIdentity contains bundleName and appIndex by the given uid.
   * The application requires to be a system application when requesting the permission of
   * ohos.permission.GET_BUNDLE_INFO.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED or ohos.permission.GET_BUNDLE_INFO
   * @param { number } uid - Indicates the UID of an application.
   * @returns { Promise<AppCloneIdentity> } Returns the clone Identity contains bundleName and appIndex.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700021 - The uid is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 14
   */
  function getAppCloneIdentity(uid: number): Promise<AppCloneIdentity>;

  /**
   * Get all plugin info of host application.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } hostBundleName - Indicates the host application bundle name to be queried.
   * @param { number } [userId] - Indicates the user ID or do not pass user ID.
   * @returns { Promise<Array<PluginBundleInfo>> } Returns PluginBundleInfo Arrays.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700004 - The specified user ID is not found.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 19
   */
  function getAllPluginInfo(hostBundleName: string, userId?: number): Promise<Array<PluginBundleInfo>>;

  /**
   * Migrate files from the source paths to the destination path.
   * 
   * @permission ohos.permission.MIGRATE_DATA
   * @param { Array<string> } sourcePaths - Indicates the source paths to be migrated.
   * @param { string } destinationPath - Target path for data migration.
   * @returns { Promise<void> } The result of migrating data.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1. Mandatory parameters are left unspecified; 2. Incorrect parameter types.
   * @throws { BusinessError } 17700080 - The source paths are invalid.
   * @throws { BusinessError } 17700081 - The destination path is invalid.
   * @throws { BusinessError } 17700082 - User authentication failed.
   * @throws { BusinessError } 17700083 - Waiting for user authentication timeout.
   * @throws { BusinessError } 17700084 - There are inaccessible path in the source paths.
   * @throws { BusinessError } 17700085 - The destination path cannot be accessed.
   * @throws { BusinessError } 17700086 - System error occurred during copy execution.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 18
   */
  function migrateData(sourcePaths: Array<string>, destinationPath: string): Promise<void>;

  /**
   * Obtains sandbox data directory by bundleName and appIndex.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the application bundle name to be queried.
   * @param { number } appIndex - Indicates the index of clone app.
   * @returns { string } Returns the sandbox data directory.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Permission denied, non-system app called system api.
   * @throws { BusinessError } 17700001 - The specified bundleName is not found.
   * @throws { BusinessError } 17700061 - AppIndex not in valid range.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 20
   */
  function getSandboxDataDir(bundleName: string, appIndex: number): string;

  /**
   * Obtains AppCloneIdentity contains bundleName and appIndex by the sandbox data directory.
   *
   * @param { string } sandboxDataDir - Indicates the sandbox data directory.
   * @returns { AppCloneIdentity } Returns the clone Identity contains bundleName and appIndex.
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 20
   */
  function getAppCloneIdentityBySandboxDataDir(sandboxDataDir: string): AppCloneIdentity;

  /**
   * Obtains configuration information about an application.
   *
   * @typedef { _ApplicationInfo }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Obtains configuration information about an application.
   *
   * @typedef { _ApplicationInfo }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export type ApplicationInfo = _ApplicationInfo;

  /**
   * Indicates the metadata information about a module.
   *
   * @typedef { _ModuleMetadata }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 10
   */
  /**
   * Indicates the metadata information about a module.
   *
   * @typedef { _ModuleMetadata }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export type ModuleMetadata = _ModuleMetadata;

  /**
   * Indicates the Metadata.
   *
   * @typedef { _Metadata }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Indicates the Metadata.
   *
   * @typedef { _Metadata }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export type Metadata = _Metadata;

  /**
   * Obtains configuration information about a bundle.
   *
   * @typedef { _BundleInfo.BundleInfo }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Obtains configuration information about a bundle.
   *
   * @typedef { _BundleInfo.BundleInfo }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export type BundleInfo = _BundleInfo.BundleInfo;

  /**
   * The scene which is used.
   *
   * @typedef { _BundleInfo.UsedScene }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * The scene which is used.
   *
   * @typedef { _BundleInfo.UsedScene }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export type UsedScene = _BundleInfo.UsedScene;

  /**
   * Indicates the required permissions details defined in file config.json.
   *
   * @typedef { _BundleInfo.ReqPermissionDetail }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Indicates the required permissions details defined in file config.json.
   *
   * @typedef { _BundleInfo.ReqPermissionDetail }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export type ReqPermissionDetail = _BundleInfo.ReqPermissionDetail;

  /**
   * Indicates the SignatureInfo.
   *
   * @typedef { _BundleInfo.SignatureInfo }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Indicates the SignatureInfo.
   *
   * @typedef { _BundleInfo.SignatureInfo }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export type SignatureInfo = _BundleInfo.SignatureInfo;

  /**
   * AppCloneIdentity Contain BundleName and appIndex.
   *
   * @typedef { _BundleInfo.AppCloneIdentity }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 15
   */
  export type AppCloneIdentity = _BundleInfo.AppCloneIdentity;

  /**
   * Obtains configuration information about a module.
   *
   * @typedef { _HapModuleInfo.HapModuleInfo }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Obtains configuration information about a module.
   *
   * @typedef { _HapModuleInfo.HapModuleInfo }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export type HapModuleInfo = _HapModuleInfo.HapModuleInfo;

  /**
   * Obtains preload information about a module.
   *
   * @typedef { _HapModuleInfo.PreloadItem }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Obtains preload information about a module.
   *
   * @typedef { _HapModuleInfo.PreloadItem }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export type PreloadItem = _HapModuleInfo.PreloadItem;

  /**
   * Obtains dependency information about a module.
   *
   * @typedef { _HapModuleInfo.Dependency }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Obtains dependency information about a module.
   *
   * @typedef { _HapModuleInfo.Dependency }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export type Dependency = _HapModuleInfo.Dependency;

  /**
   * Obtains the router item about a module.
   *
   * @typedef { _HapModuleInfo.RouterItem}
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 12
   */
  export type RouterItem = _HapModuleInfo.RouterItem;

  /**
   * Obtains the data item within router item.
   *
   * @typedef { _HapModuleInfo.DataItem }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 12
   */
  export type DataItem = _HapModuleInfo.DataItem;

  /**
   * Obtains configuration information about an ability.
   *
   * @typedef { _AbilityInfo.AbilityInfo }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Obtains configuration information about an ability.
   *
   * @typedef { _AbilityInfo.AbilityInfo }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export type AbilityInfo = _AbilityInfo.AbilityInfo;

  /**
   * Contains basic Ability information. Indicates the window size..
   *
   * @typedef { _AbilityInfo.WindowSize }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Contains basic Ability information. Indicates the window size..
   *
   * @typedef { _AbilityInfo.WindowSize }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export type WindowSize = _AbilityInfo.WindowSize;

  /**
   * Obtains extension information about a bundle.
   *
   * @typedef { _ExtensionAbilityInfo.ExtensionAbilityInfo }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Obtains extension information about a bundle.
   *
   * @typedef { _ExtensionAbilityInfo.ExtensionAbilityInfo }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export type ExtensionAbilityInfo = _ExtensionAbilityInfo.ExtensionAbilityInfo;

  /**
   * Indicates the defined permission details in file config.json.
   *
   * @typedef { _PermissionDef }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 9
   */
  export type PermissionDef = _PermissionDef;

  /**
   * Contains basic Ability information, which uniquely identifies an ability.
   *
   * @typedef { _ElementName }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @since 9
   */
  /**
   * Contains basic Ability information, which uniquely identifies an ability.
   *
   * @typedef { _ElementName }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 11
   */
  export type ElementName = _ElementName;

  /**
   * Contains shared bundle info.
   *
   * @typedef { _SharedBundleInfo }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  export type SharedBundleInfo = _SharedBundleInfo;

  /**
   * Obtains profile file information about a bundle.
   *
   * @typedef { _AppProvisionInfo.AppProvisionInfo }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  export type AppProvisionInfo = _AppProvisionInfo.AppProvisionInfo;

  /**
   * Obtains profile file validity about a bundle.
   *
   * @typedef { _AppProvisionInfo.Validity }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 10
   */
  export type Validity = _AppProvisionInfo.Validity;

  /**
   * Obtains information about a recoverable preinstalled application.
   *
   * @typedef { _RecoverableApplicationInfo }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 11
   */
  export type RecoverableApplicationInfo = _RecoverableApplicationInfo;

  /**
   * Obtains configuration information about an skill
   *
   * @typedef { _Skill.Skill }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 12
   */
  export type Skill = _Skill.Skill;

  /**
   * Obtains configuration information about an skillUri
   *
   * @typedef { _Skill.SkillUri }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @atomicservice
   * @since 12
   */
  export type SkillUrl = _Skill.SkillUri;
 
  /**
   * Indicates the information of preinstalled application.
   *
   * @typedef { _PreinstalledApplicationInfo  }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 12
   */
  export type PreinstalledApplicationInfo = _PreinstalledApplicationInfo;

  /**
   * Indicates the information about a plugin.
   *
   * @typedef { _PluginBundleInfo  }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 19
   */
  export type PluginBundleInfo = _PluginBundleInfo;

  /**
   * Indicates the plugin module info.
   *
   * @typedef { _PluginModuleInfo  }
   * @syscap SystemCapability.BundleManager.BundleFramework.Core
   * @systemapi
   * @since 19
   */
  export type PluginModuleInfo = _PluginModuleInfo;
}

export default bundleManager;
