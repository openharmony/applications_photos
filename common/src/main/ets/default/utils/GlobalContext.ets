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

import lazy { GenericBase } from './GenericBase';

/**
 * 同样作为全局变量获取, Global 与 AppStorage 的主要区别
 * Global.getX 返回值为单一类型, 当键值不存在时默认返回当前类型可判空的值 $ if(!Global.getX())return;
 * 第二个参数可选, 可以自定义本次键值不存在时想要返回的默认值
 * AppStorage 带泛型, 返回值为复合类型, 当键值不存在时不返回当前类型, 返回 undefined
 * Global 粒度更小, 不带状态
 */
export default class Global {
  /**
   * GlobalNumber
   * @param onEmpty 缺省值默认为 Number.NaN
   */
  public static getNumber(value: string, onEmpty?: number): number {
    return GlobalNumberConstructor.getInstance().get(value) ?? onEmpty ?? GlobalNumberConstructor.DEFAULT;
  }

  /**
   * 对空返回值敏感需求额外判断的建议使用 AppStorage.set
   */
  public static setNumber(key: string, value?: number): void {
    GlobalNumberConstructor.getInstance().set(key, value);
  }

  public static deleteNumber(key: string): void {
    GlobalNumberConstructor.getInstance().delete(key);
  }

  /**
   * GlobalBool
   * @param onEmpty 缺省值默认为 false
   */
  public static getString(value: string, onEmpty?: string): string {
    return GlobalStringConstructor.getInstance().get(value) ?? onEmpty ?? GlobalStringConstructor.DEFAULT;
  }

  /**
   * 对空返回值敏感需求额外判断的建议使用 AppStorage.set
   */
  public static setString(key: string, value?: string): void {
    GlobalStringConstructor.getInstance().set(key, value);
  }

  public static deleteString(key: string): void {
    GlobalStringConstructor.getInstance().delete(key);
  }

  /**
   * GlobalString
   * @param onEmpty 缺省值默认为 ''
   */
  public static getBoolean(value: string, onEmpty?: boolean): boolean {
    return GlobalBoolConstructor.getInstance().get(value) ?? onEmpty ?? GlobalBoolConstructor.DEFAULT;
  }

  /**
   * 对空返回值敏感需求额外判断的建议使用 AppStorage.set
   */
  public static setBoolean(key: string, value?: boolean): void {
    GlobalBoolConstructor.getInstance().set(key, value);
  }

  public static deleteBoolean(key: string): void {
    GlobalBoolConstructor.getInstance().delete(key);
  }
}

class GlobalNumberConstructor extends GenericBase<number> {
  public static readonly DEFAULT = Number.NaN;
  private static instance: GlobalNumberConstructor;

  public static getInstance(): GlobalNumberConstructor {
    if (!Boolean(GlobalNumberConstructor.instance).valueOf()) {
      GlobalNumberConstructor.instance = new GlobalNumberConstructor();
    }
    return GlobalNumberConstructor.instance;
  }
}

class GlobalBoolConstructor extends GenericBase<boolean> {
  public static readonly DEFAULT = false;
  private static instance: GlobalBoolConstructor;

  public static getInstance(): GlobalBoolConstructor {
    if (!Boolean(GlobalBoolConstructor.instance).valueOf()) {
      GlobalBoolConstructor.instance = new GlobalBoolConstructor();
    }
    return GlobalBoolConstructor.instance;
  }
}

class GlobalStringConstructor extends GenericBase<string> {
  public static readonly DEFAULT = '';
  private static instance: GlobalStringConstructor;

  public static getInstance(): GlobalStringConstructor {
    if (!Boolean(GlobalStringConstructor.instance).valueOf()) {
      GlobalStringConstructor.instance = new GlobalStringConstructor();
    }
    return GlobalStringConstructor.instance;
  }
}
