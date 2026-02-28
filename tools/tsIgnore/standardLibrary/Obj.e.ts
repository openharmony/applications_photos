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
/**
 * 提供ets不支持的ts标准库
 * 专门用于ets报错且解决不了的函数
 */
export namespace Obj {
  /**
   *  Copy the values of all of the enumerable own properties from one or more source objects to a target object.
   *
   *
   * @param targetT he target object to copy to.
   * @param source1 The first source object from which to copy properties.
   * @param source2 The second source object from which to copy properties.
   * @returns
   * @returns the target object.
   */
  export function assign<T extends {}, U, V>(target: T, source1: U, source2: V): T & U & V {
    return Object.assign({}, target, source1, source2);
  }

  /** reference lib='es2015.iterable'
   * @param entries An iterable object that contains key-value entries for properties and methods.
   * @Returns an object created by key-value entries for properties and methods
   */
  export function fromEntries<T>(entries: Iterable<readonly [PropertyKey, T]>): { [k: string]: T } {
    return Object.fromEntries(entries);
  }

  export function reduce(keys: string[], values: number[], oldValues: number[]): {} {
    return keys.reduce((p, c, i) => ((p[c] = values[i] + oldValues[i]), p), {});
  }
}