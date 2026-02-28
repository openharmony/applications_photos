/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License"),
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
 * @kit FormKit
 */

import ExtensionAbility from './@ohos.app.ability.ExtensionAbility';
import LiveFormExtensionContext from './application/LiveFormExtensionContext';
import type UIExtensionContentSession from './@ohos.app.ability.UIExtensionContentSession';
import formInfo from './@ohos.app.form.formInfo';

/**
 * Provides information about a live form.
 * @typedef { LiveFormInfo }
 * @syscap SystemCapability.Ability.Form
 * @stagemodelonly
 * @atomicservice
 * @since 20
 */
export interface LiveFormInfo {
  /**
   * The form id.
   *
   * @type { string }
   * @syscap SystemCapability.Ability.Form
   * @stagemodelonly
   * @atomicservice
   * @since 20
   */
  formId: string;

  /**
   * The live form display area.
   *
   * @type { formInfo.Rect }
   * @syscap SystemCapability.Ability.Form
   * @stagemodelonly
   * @atomicservice
   * @since 20
   */
  rect: formInfo.Rect;

  /**
   * The form border radius.
   *
   * @type { number }
   * @syscap SystemCapability.Ability.Form
   * @stagemodelonly
   * @atomicservice
   * @since 20
   */
  borderRadius: number;
}

/**
 * The class of live form extension ability.
 *
 * @extends ExtensionAbility
 * @syscap SystemCapability.Ability.Form
 * @stagemodelonly
 * @atomicservice
 * @since 20
 */
export default class LiveFormExtensionAbility extends ExtensionAbility {
  /**
   * Indicates configuration information about a live form extension ability context.
   *
   * @type { LiveFormExtensionContext }
   * @syscap SystemCapability.Ability.Form
   * @stagemodelonly
   * @atomicservice
   * @since 20
   */
  context: LiveFormExtensionContext;

  /**
   * Called back when a live form extension is started for initialization.
   *
   * @param { LiveFormInfo } liveFormInfo - Indicates the live form info.
   * @param { UIExtensionContentSession } session - Indicates the session of the UI extension page.
   * @syscap SystemCapability.Ability.Form
   * @stagemodelonly
   * @atomicservice
   * @since 20
   */
  onLiveFormCreate(liveFormInfo: LiveFormInfo, session: UIExtensionContentSession): void;

  /**
   * Called back when a live form extension is destroyed.
   *
   * @param { LiveFormInfo } liveFormInfo - Indicates the live form info.
   * @syscap SystemCapability.Ability.Form
   * @stagemodelonly
   * @atomicservice
   * @since 20
   */
  onLiveFormDestroy(liveFormInfo: LiveFormInfo): void;
}