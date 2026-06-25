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

import lazy { Configuration, UIExtensionAbility, UIExtensionContentSession, Want } from '@kit.AbilityKit';
import lazy { PafUiWidget } from '@ohos/privacy/src/main/ets/about/consent/PafUiWidget';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';

const TAG = 'PrivacyStatementExtension';

export default class PrivacyStatementExtension extends UIExtensionAbility {
  public onCreate(): void {
    Log.info(TAG, 'onCreate');
    global.setUiExtensionCtx(this.context);
  }

  public async onSessionCreate(want: Want, session: UIExtensionContentSession): Promise<void> {
    Log.info(TAG, 'onSessionCreate');
    global.setUiExtSession(session);
    // await PermissionPopup.initPafAsync(this.context);
    let contentPath: string = PageTitle.prefix + PageTitle.agreement;
    session.loadContent(contentPath);
    Log.info(TAG, 'onSessionCreate end');
  }

  public onSessionDestroy(session: UIExtensionContentSession): void {
    Log.info(TAG, 'onSessionDestroy');
  }

  public onForeground(): void {
    Log.info(TAG, 'onForeground');
  }

  public onBackground(): void {
    Log.info(TAG, 'onBackground');
  }

  public onDestroy(): void {
    Log.info(TAG, 'onDestroy');
  }

  public onConfigurationUpdate(config: Configuration): void {
    Log.info(TAG, 'onConfigurationUpdate');
    // PafUiWidget.configurationUpdate(config);
  }
}