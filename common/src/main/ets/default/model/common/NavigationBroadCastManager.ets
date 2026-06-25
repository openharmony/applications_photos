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

import lazy { Log } from '../../utils/Log';
import lazy { BroadCast } from '../../utils/BroadCast';

const TAG: string = 'common_NavigationBroadCastManager';

export class NavigationBroadCastManager {
  private broadCast: BroadCast;
  public targetName: string;

  private constructor() {
    Log.info(TAG, 'constructor');
    this.broadCast = new BroadCast();
    this.targetName = '';
  }

  public static getInstance(): NavigationBroadCastManager {
    if (!NavigationBroadCastManager.instance) {
      NavigationBroadCastManager.instance = new NavigationBroadCastManager();
    }
    return NavigationBroadCastManager.instance;
  }

  public static instance: NavigationBroadCastManager | undefined = undefined;

  public getBroadCast(): BroadCast {
    return this.broadCast;
  }
}
