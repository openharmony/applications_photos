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

import lazy systemParameterEnhance from '@ohos.systemParameterEnhance';
import lazy { Log } from './Log';
import lazy { BusinessError } from '@ohos.base';

const TAG: string = 'common_SystemPropertiesManager';

export class SystemPropertiesManager {
  private static instance: SystemPropertiesManager | undefined = undefined;
  /**
   * 参数
   */
  private readonly params: Map<string, string> = new Map();
  /**
   * 参数
   */
  private readonly paramStatus: Map<string, boolean> = new Map();

  private constructor() {
  }

  public static getInstance(): SystemPropertiesManager {
    if (SystemPropertiesManager.instance) {
      return SystemPropertiesManager.instance;
    }
    SystemPropertiesManager.instance = new SystemPropertiesManager();
    return SystemPropertiesManager.instance;
  }

  /**
   * 获取配置项
   *
   * @param key 键
   * @returns 值
   */
  public get(key: string, defaultValue?: string): string {
    if (!key) {
      return '';
    }
    if (this.paramStatus.get(key)) {
      return this.params.get(key) ?? '';
    }

    let prop: string | undefined = undefined;
    try {
      prop = systemParameterEnhance.getSync(key, defaultValue);
    } catch (e) {
      Log.warn(TAG, `failed to get system param: ${key}, err: ${(e as BusinessError)?.code}`);
    } finally {
      this.paramStatus.set(key, true);
      if (!prop) {
        prop = defaultValue ?? '';
      }
      this.params.set(key, prop);
    }

    return prop ?? '';
  }
}