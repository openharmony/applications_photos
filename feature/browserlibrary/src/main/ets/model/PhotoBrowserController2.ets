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

import lazy common from '@ohos.app.ability.common';
import lazy { PhotoBrowserController } from './PhotoBrowserController';
import lazy uiExtensionHost from '@ohos.uiExtensionHost';
import lazy { PhotoConfig } from '@ohos/common/src/main/ets/default/config/PhotoConfig';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';

@Observed
export class PhotoBrowserController2 extends PhotoBrowserController {
  /**
   * 大图组件控制器，使用三方传递的上下信息，完成初始化
   *
   * @param abilityContext 三方传入的 ability 上下文信息
   * @param windowStage 三方传入的窗口信息
   * @param abilityStage 三方传入的 ability 信息
   */
  constructor(abilityContext: Context, proxy: uiExtensionHost.UIExtensionHostWindowProxy, abilityStage: Context) {
    super(abilityContext as common.UIAbilityContext, undefined, abilityStage);
    if (proxy) {
      LocalStorage.getShared()?.setOrCreate<uiExtensionHost.UIExtensionHostWindowProxy>('photosUiExtensionStage',
        proxy);
    }
    this.bundleName = (abilityContext as common.UIExtensionContext).extensionAbilityInfo?.bundleName;
    if (this.bundleName === Constants.MEETIME_SERVICE) {
      PhotoConfig.setIsFromMeetime(true);
    }
  }
}