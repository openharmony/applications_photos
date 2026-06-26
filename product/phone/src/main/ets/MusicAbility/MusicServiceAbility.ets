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
import lazy ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility';
import lazy MusicServiceStub from './MusicServiceStub';
import lazy Want from '@ohos.app.ability.Want';
import lazy rpc from '@ohos.rpc';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG: string = 'MusicServiceAbility';

export default class MusicServiceAbility extends ServiceExtensionAbility {
  onCreate(want: Want) {
    Log.info(TAG, `onCreate, want: ${want.abilityName}`);
  }

  onRequest(want: Want) {
    Log.info(TAG, `onRequest, want: ${want.abilityName}`);
  }

  onConnect(want: Want) {
    Log.info(TAG, `ServiceAbility onConnect, want: ${want.abilityName}`);
    let musicServiceStub: MusicServiceStub = new MusicServiceStub('ohos.abilityshell.DistributedConnection',
      this.context);
    return musicServiceStub as rpc.RemoteObject;
  }

  onDisconnect(want: Want) {
    Log.info(TAG, `ServiceAbility onDisconnect, want: ${want.abilityName}`);
  }

  onDestroy() {
    console.info(TAG, 'onDestroy');
  }
}
