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
 
import lazy ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility'
import lazy FaCardServiceStub from './FACardServiceStub'
import lazy Want from '@ohos.app.ability.Want'
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG: string = 'FACardServiceAbilityCommon';

export default class FACardServiceAbilityCommon extends ServiceExtensionAbility {

  onCreate(want: Want): void {
    Log.info(TAG, 'FACardServiceAbilityCommon onCreate');
    if (!AppStorage.get('formContext')) {
      AppStorage.setOrCreate('formContext', this.context);
    }
  }

  onRequest(want: Want): void {
    Log.info(TAG, 'FACardServiceAbilityCommon onRequest');
    this.handler(want);
  }

  handler(want: Want) {
    FaCardServiceStub.getInstance(this.context).submitToStream(want);
  }

  onDisconnect(want: Want): void | Promise<void> {
    Log.info(TAG, 'FACardServiceAbilityCommon onDisconnect');
  }

  onDestroy(): void {
    Log.info(TAG, 'FACardServiceAbilityCommon onDestroy');
  }
}