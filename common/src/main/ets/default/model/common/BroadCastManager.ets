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

import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { Log } from '../../utils/Log';
import lazy { Constants } from '../common/Constants'

const TAG: string = 'BroadCastManager';

export class BroadCastManager {
  private broadCast: BroadCast;
  private static instance: BroadCastManager | undefined = undefined;

  private constructor() {
    Log.info(TAG, 'BroadCastManager constructor');
    this.broadCast = new BroadCast();
  }

  public static getInstance(): BroadCastManager {
    if (BroadCastManager.instance) {
      return BroadCastManager.instance;
    }
    let manager = AppStorage.get<BroadCastManager>(Constants.BROADCAST_MANAGER);
    if (manager) {
      Log.info(TAG, `appStorage-BroadCastManager exist`);
      BroadCastManager.instance = manager;
      return manager;
    } else {
      Log.info(TAG, `appStorage-BroadCastManager not exist`);
      BroadCastManager.instance = new BroadCastManager();
      AppStorage.setOrCreate(Constants.BROADCAST_MANAGER,
        BroadCastManager.instance);
      return BroadCastManager.instance;
    }
  }

  public getBroadCast(): BroadCast {
    return this.broadCast
  }
}
