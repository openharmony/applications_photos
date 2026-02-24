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

const TAG = 'JsonUtil';

export class JsonUtil {
  static getValueFromJson<T>(jsonString: string, path: string): T | undefined {
    // 解析 JSON 字符串
    let parsedObject;
    try {
      parsedObject = JSON.parse(jsonString);
    } catch (error) {
      HiLog.e(TAG, `Failed to parse JSON: ${error instanceof Error ? error.message : String(error)}`);
      return undefined;
    }

    // 如果路径为空，返回空
    if (!path) {
      return undefined;
    }

    // 分割路径
    const keys = path.split('.');
    let current = parsedObject;

    // 遍历路径
    for (const key of keys) {
      if (current === null || current === undefined) {
        return undefined;
      }

      // 检查当前值是否是对象且包含该属性
      if (typeof current === 'object' && key in current) {
        current = current[key];
      } else {
        return undefined;
      }
    }

    return current;
  }
}