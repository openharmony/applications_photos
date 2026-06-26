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
import lazy rpc from '@ohos.rpc';
import lazy Want from '@ohos.app.ability.Want';
import lazy ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy CommonRecentPhotoServiceStub from './CommonRecentPhotoInfoStub';

const TAG: string = 'RecentPhotoSA';

export default class CommonRecentPhotoInfoAbility extends ServiceExtensionAbility {
  onCreate(want: Want) {
    Log.info(TAG, `onCreate, want: ${want.abilityName}`);
  }

  onRequest(want: Want) {
    Log.info(TAG, `onRequest, want: ${want.abilityName}`);
  }

  onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    Log.info(TAG, `ServiceAbility onConnect, want: ${want.abilityName}`);
    let serviceStub: CommonRecentPhotoServiceStub = new CommonRecentPhotoServiceStub(
      'rpcRecentPhotoInfoServiceAbility', this.context);
    return serviceStub as rpc.RemoteObject;
  }

  onDisconnect(want: Want) {
    Log.info(TAG, `ServiceAbility onDisconnect, want: ${want.abilityName}`);
  }

  onDestroy() {
    console.info(TAG, 'onDestroy');
  }
}