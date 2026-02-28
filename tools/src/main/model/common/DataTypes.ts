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
/* instrument ignore file  */
const TAG: string = 'DataTypes';

export type DisplayName = Resource | string;

export type Loggable = Resource | string | number | boolean | undefined | object | Object | Error | Function;

/**
 * 为什么不建议使用as
 * as只能被用在100%确定类型一致的情况下, 绕过编译器的强类型检测, 并不能在as断言出现问题时提醒开发人员
 * as在断言失败之后, 依旧会往下运行且不会报错. 不利于强类型的编码 使用assert 可以判断是否断言失败方便定位问题
 * 这里可以用一个示例表示:
 *  print(typeof (6 as string))
 * 这里依旧会输出number 而不是string
 * 因为as 只影响编译时,不影响运行时
 * 无法清晰分析断言的结果，导致代码完全不可控，难以review发现问题
 * 建议的方案↓ 在运行时介入干预 并输出维测
 */
export namespace assert {
  /**
   * 进行默认值断言,比as多了维测,方便定位问题
   * 只允许简单类型的断言, 复杂类型和class不适用(用instanceof代替)
   * @param obj 被断言的值
   * @param defaultValue 默认值
   * @param msg 维测字符串, 请添加以方便定位问题
   * @returns 断言失败时, 返回默认值
   */
  export function asDefault<T>(obj: Loggable, defaultValue: T, msg?: string): T {
    const res: T | undefined = withUndefined(obj, defaultValue, msg);
    if (res === undefined) {
      return defaultValue;
    }
    return res;
  }

  /**
   * 进行默认值断言,比parse多了维测,方便定位问题
   * 只允许简单类型的断言, 复杂类型和class不适用(用instanceof代替)
   * @param obj 被断言的值
   * @param defaultValue 默认值
   * @param msg 维测字符串, 请添加以方便定位问题
   * @returns 断言失败时, 返回默认值
   */
  export function parse<T>(text: string, defaultValue: T, reviver?: (this: T, key: string, value: T) =>
  T, msg?: string): T {
    let res: T | undefined = undefined;
    try {
      res = JSON.parse(text, reviver) as T | undefined;
    } catch (err) {
      Log.error(TAG, `JSON.parse error: ${msg + err}`);
    }
    if (res === undefined) {
      return defaultValue;
    }
    return res;
  }

  /**
   * 进行断言,比as string 多了维测,方便定位问题, 只允许简单类型的断言, 复杂类型和class不适用(用instanceof代替)
   * @param obj 被断言的值
   * @param msg 维测字符串, 请添加以方便定位问题
   * @returns 断言失败时, 返回undefined
   */
  export function asString(obj: Loggable, msg?: string): string | undefined {
    return withUndefined(obj, '', msg);
  }

  /**
   * 进行断言,比as 多了维测,方便定位问题, 只允许简单类型的断言, 复杂类型和class不适用(用instanceof代替)
   * @param obj 被断言的值
   * @param msg 维测字符串, 请添加以方便定位问题
   * @returns 断言失败时, 返回undefined
   */
  export function asNumber(obj: Loggable, msg?: string): number | undefined {
    return withUndefined(obj, 0, msg);
  }

  /**
   * 进行断言,比as 多了维测,方便定位问题, 只允许简单类型的断言, 复杂类型和class不适用(用instanceof代替)
   * @param obj 被断言的值
   * @param msg 维测字符串, 请添加以方便定位问题
   * @returns 断言失败时, 返回undefined
   */
  export function asBoolean(obj: Loggable, msg?: string): boolean | undefined {
    return withUndefined(obj, false, msg);
  }

  /**
   * 进行默认值断言,比as多了维测,方便定位问题
   * 只允许简单类型的断言, 复杂类型和class不适用(用instanceof代替)
   * @param obj 被断言的值
   * @param msg 维测字符串, 请添加以方便定位问题
   * @param defaultValue 默认值
   * @returns 断言失败时, 返回默认值
   */
  function withUndefined<T>(obj: Loggable, targetType: T, msg: string = ''): T | undefined {
    if (typeof obj === 'object') {
      Log.error(TAG, `${msg} only simple value type can be asserted.`);
      return undefined;
    }
    if (typeof obj === typeof targetType) {
      return obj as T;
    }
    Log.error(TAG, `${obj} target type not matched, ${msg}, typeof obj is [${typeof
    obj}], but expect type [${typeof targetType}]`);
    return undefined;
  }
}