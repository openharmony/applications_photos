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

import lazy HiLog from '@ohos.hilog';

const DOMAIN: number = 0x0220;
const TAG: string = 'Photos';
const BAR_WIDTH = 23;

export class Log {
  private static isDebugLoggable = HiLog.isLoggable(DOMAIN, TAG, HiLog.LogLevel.DEBUG);

  private static isInfoLoggable = HiLog.isLoggable(DOMAIN, TAG, HiLog.LogLevel.INFO);

  private static isWarnLoggable = HiLog.isLoggable(DOMAIN, TAG, HiLog.LogLevel.WARN);

  private static isErrorLoggable = HiLog.isLoggable(DOMAIN, TAG, HiLog.LogLevel.ERROR);

  private static isFatalLoggable = HiLog.isLoggable(DOMAIN, TAG, HiLog.LogLevel.FATAL);

  public static debug(className: string, message: string, ...args: string[]): boolean {
    if (this.isDebugLoggable) {
      HiLog.debug(DOMAIN, fitWidth(className), message, args);
      return true;
    }
    return false;
  }

  /**
   * 打印info级别日志（默认进行匿名化处理）
   *
   * @param className 日志标签
   * @param message 日志信息
   * @param args 可选参数
   * @returns 是否可打印
   */
  public static info(className: string, message: string, ...args: string[]): boolean {
    if (this.isInfoLoggable) {
      HiLog.info(DOMAIN, fitWidth(className), encrypt(message), args);
      return true;
    }
    return false;
  }

  /**
   * 打印info级别日志（不进行匿名化处理）
   *
   * @param className 日志标签
   * @param message 日志信息
   * @param args 可选参数
   * @returns 是否可打印
   */
  public static i(className: string, message: string, ...args: string[]): boolean {
    if (this.isInfoLoggable) {
      HiLog.info(DOMAIN, fitWidth(className), message, args);
      return true;
    }
    return false;
  }

  public static warn(className: string, message: string, ...args: string[]): boolean {
    if (this.isWarnLoggable) {
      HiLog.warn(DOMAIN, fitWidth(className), encrypt(message), args);
      return true;
    }
    return false;
  }

  /**
   * 打印warn级别日志（不进行匿名化处理）
   *
   * @param className 日志标签
   * @param message 日志信息
   * @param args 可选参数
   * @returns 是否可打印
   */
  public static w(className: string, message: string, ...args: string[]): boolean {
    if (this.isWarnLoggable) {
      HiLog.warn(DOMAIN, fitWidth(className), message, args);
      return true;
    }
    return false;
  }

  public static error(className: string, message: string, ...args: string[]): boolean {
    if (this.isErrorLoggable) {
      HiLog.error(DOMAIN, fitWidth(className), encrypt(message), args);
      return true;
    }
    return false;
  }

  /**
   * 打印error级别日志（不进行匿名化处理）
   *
   * @param className 日志标签
   * @param message 日志信息
   * @param args 可选参数
   * @returns 是否可打印
   */
  public static e(className: string, message: string, ...args: string[]): boolean {
    if (this.isErrorLoggable) {
      HiLog.error(DOMAIN, fitWidth(className), message, args);
      return true;
    }
    return false;
  }

  public static fatal(className: string, message: string, ...args: string[]): boolean {
    if (this.isFatalLoggable) {
      HiLog.fatal(DOMAIN, fitWidth(className), message, args);
      return true;
    }
    return false;
  }

  public static stringify<T>(a?: T): string {
    if (a instanceof Error) {
      return getStack(a);
    }
    switch (typeof a) {
      case 'undefined':
        return typeof a;
      case 'string':
        return a;
      case 'function':
        return a.name;
      case 'object':
        return String(a) === '[object Object]' ? expand(a) : String(a);
    }
    return String(a);
  }
}

export function reportEmpty<T>(target: T, ...msg: string[]): T {
  /* instrument ignore if*/
  if (isEmpty(target)) {
    Log.warn(TAG, `target is empty. ${String(msg)}`);
  }
  return target;
}

export function isEmpty<T>(target: T): boolean {
  switch (typeof target) {
    case 'boolean':
      return false;
    case 'number':
      return Number.isNaN(target);
  }
  return !target;
}

export function expand<T>(target: T): string {
  if (typeof target !== 'object') {
    HiLog.warn(DOMAIN, TAG, `${target instanceof Error}target type: ${typeof target} is not object, ${target}`);
    return String(target);
  }
  let str: string = '{';
  Object.getOwnPropertyNames(target)?.forEach(
    (key: string): void => {
      const e = target?.[key];
      str += key + ': ' + getStack(e) + ', ';
    }
  );
  str;
  return `${str}}`;
}

export function getStack(e: Error): string {
  return JSON.stringify(e, (e instanceof Error) ? Object.getOwnPropertyNames(e) : undefined);
}

function fitWidth(name: string): string {
  return name.substring(name.length - BAR_WIDTH);
}

function encrypt(data: string): string {
  /* instrument ignore if*/
  if (data?.indexOf('file:///data/storage/') !== -1) {
    return '';
  }
  let encryptedData = data.replace(/(\/\w+)\./g, '/******.');
  encryptedData = encryptedData.replace(/"userComment":"([^"]|\")*"/g, '"userComment":"******"');
  return encryptedData;
}