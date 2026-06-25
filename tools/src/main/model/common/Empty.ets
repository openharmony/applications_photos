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

export namespace RemoveUndefinedValues {
  /**
   * 去除空值, 将(T | null | undefined)[]) 类型转为: T[]类型
   * @param list
   * @returns
   */
  export function list<T>(list: (T | null | undefined)[]): T[] {
    if (!list || list?.length === 0) {
      return [];
    }
    let result: T[] = [];
    for (let item of list) {
      if (item !== null && item !== undefined) {
        result.push(item);
      }
    }
    return result;
  }
}

/**
 * 一般来说, 判空就不要抽函数了, **包装函数之后编辑器会失去判空检测功能** 直接 if (str) 就行
 */
export namespace IsEmpty {
  /**
   * 判断字串或其他类型为空就不要抽函数了, **包装函数之后编辑器会失去判空检测功能** 直接 if (str) 就行
   * 只有boolean和number有特殊情况
   * @param generic
   * @returns
   */
  export function allTypes<T>(generic: T): boolean {
    switch (typeof generic) {
      case 'boolean':
        return false;
      case 'number':
        return !Number.isFinite(generic);
    }
    return !generic;
  }

  /**
   * @deprecated
   * @param list
   * @returns
   * 判断数组为空就不要抽函数了, **包装函数之后编辑器会失去判空检测功能**  直接 if (list?.length) 就行
   */
  export function list<T>(list: (T | null | undefined)[]): boolean {
    return !list?.length;
  }
}