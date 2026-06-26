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

import lazy { Log } from '../../default/utils/Log';
import lazy { DeviceInfo } from '../../default/utils/DeviceInfo';

const TAG: string = 'SearchSwitchManager';

/**
 * SearchSwitchManager
 * 搜索默认支持，保留这个类，以便后续搜索独立后判断支持情况
 */
export class SearchSwitchManager {
  private isSupportSearch: boolean = true;

  private constructor() {
    Log.info(TAG, `current search enable: ${this.isSupportSearch}`);
  }

  public static getInstance(): SearchSwitchManager {
    if (!SearchSwitchManager.instance) {
      SearchSwitchManager.instance = new SearchSwitchManager();
    }
    return SearchSwitchManager.instance;
  }

  public static instance: SearchSwitchManager | undefined = undefined;

  public isSupportPhotoSearch(): boolean {
    return this.isSupportSearch && !DeviceInfo.isEmulator();
  }
}