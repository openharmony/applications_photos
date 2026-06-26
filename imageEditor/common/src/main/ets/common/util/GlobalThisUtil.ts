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
import { HiLog } from './HiLog';
import dataPreferences from '@ohos.data.preferences';
import { common } from '@kit.AbilityKit';

/**
 * 由于globalThis在ts文件、c++中都有使用，因此采用推荐的暂时规避手段，在ts中引用globalThis，ets中应用ts
 * 随着ets语法调整，globalThis可能被删除。后续可以考虑对globalThis进行彻底清理，通过其他方式传递全局参数
 */

export class GlobalThisUtil {
  private static tag = 'GlobalThisUtil';

  public static setProperty<T>(name: string, value: T): void {
    if (value == null) {
      HiLog.e(GlobalThisUtil.tag, `setProperty failed: ${name} is null or undefined`);
      return;
    }
    globalThis[name] = value;
  }

  public static getProperty<T>(name: string): T {
    return globalThis[name] ?? AppStorage.get<T>(name) ?? LocalStorage.getShared().get<T>(name);
  }

  public static getLocalProperty<T>(name: string): T {
    return globalThis[name] ?? LocalStorage.getShared()?.get<T>(name);
  }
}


/**
 * 读取轻量存储preferences中的key值
 *
 * @param {string} key - 存储键
 * @param {string} [storeName] - 名称
 * @param {context=} - context
 * @return Promise<ValueType> - 返回存储值
 */
export function preferencesGet(
  key: string,
  context: common.UIAbilityContext,
  storeName: string,
): Promise<dataPreferences.ValueType> {
  try {
    return dataPreferences.getPreferences(context, storeName).then((preferences: dataPreferences.Preferences) => {
      return preferences.get(key, '');
    });
  } catch (err) {
    HiLog.e('preferences', 'get value failed');
    return new Promise<boolean>(() => {
      return '';
    });
  };
}

/**
 * 存入轻量存储preferences中key的value值
 *
 * @param {string} key - 存储键
 * @param {string} value - 存储值
 * @param {string} [storeName] - 名称
 * @param {context=} - context
 * @return Promise<void> - 返回
 */
export function preferencesPut(
  key: string,
  value: string | boolean | number,
  context: common.UIAbilityContext,
  storeName: string,
): Promise<void> {
  try {
    return dataPreferences.getPreferences(context, storeName).then((preferences: dataPreferences.Preferences) => {
      return preferences.put(key, value).then(() => {
        preferences.flush();
      });
    });
  } catch (err) {
    HiLog.e('preferences', 'get value failed');
    return new Promise<void>(() => {});
  };
};