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

export class StorageUtils {
  private constructor() {
  }

  /**
   * 从LocalStorage获取给定键的元素
   * 不存在的情况下，如果给了实例，则设置进去
   * @param context 上下文
   * @param key 键
   * @param instance 实例
   * @returns 实例
   */
  public static get<T>(context: UIContext | undefined, key: string, instance?: T): T | undefined {
    let storage: LocalStorage | undefined = context?.getSharedLocalStorage();
    if (!storage) {
      return undefined;
    }

    if (storage.has(key)) {
      return storage.get<T>(key);
    }

    if (!instance) {
      return undefined;
    }
    storage.setOrCreate(key, instance);
    return instance;
  }
}