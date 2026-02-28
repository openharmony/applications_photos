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
import lazy UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import lazy Want from '@ohos.app.ability.Want';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';

export class CommonDeleteAbility extends UIExtensionAbility {
  onSessionCreate(want: Want, session: UIExtensionContentSession) {
    let storage: LocalStorage = new LocalStorage();
    this.parseParams(want, storage);
    storage?.setOrCreate(Constants.APP_KEY_SESSION, session);
    session.loadContent('DeleteAbility/view/DeleteUIExtensionPage', storage);
  }

  private parseParams(want: Want, storage: LocalStorage) {
    let wantParam: Record<string, Object> = want.parameters as Record<string, Object>;
    let uris = wantParam?.uris as string[];
    let appName: string = wantParam?.appName as string;
    storage?.setOrCreate(Constants.APP_KEY_DELETE_UI_EXT_URIS, uris);
    storage?.setOrCreate(Constants.APP_KEY_DELETE_UI_EXT_NAME, appName);
  }
}