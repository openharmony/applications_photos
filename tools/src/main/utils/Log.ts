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
/* instrument ignore file  */
export type Loggable = Resource | string | number | boolean | undefined | object | Object | Error | Function;

const DOMAIN: number = 0x0220;
const TAG: string = 'Photos';
const BAR_WIDTH = 23;
const SEPARATOR = ' ';
const PATH = 'tools/src/main/utils/Log.ts';

export class Log {
  public static debug(className: string, message: string, ...args: string[]): boolean {
    if (HiLog.isLoggable(DOMAIN, TAG, HiLog.LogLevel.DEBUG)) {
      HiLog.debug(DOMAIN, fitWidth(className), message, args);
      return true;
    }
    return false;
  }

  public static info(className: string, message: string, ...args: string[]): boolean {
    if (HiLog.isLoggable(DOMAIN, TAG, HiLog.LogLevel.INFO)) {
      HiLog.info(DOMAIN, fitWidth(className), encrypt(message), args);
      return true;
    }
    return false;
  }

  public static warn(className: string, message: string, ...args: string[]): boolean {
    if (HiLog.isLoggable(DOMAIN, TAG, HiLog.LogLevel.WARN)) {
      HiLog.warn(DOMAIN, fitWidth(className), encrypt(message), args);
      return true;
    }
    return false;
  }

  public static error(className: string, message: string, ...args: string[]): boolean {
    if (HiLog.isLoggable(DOMAIN, TAG, HiLog.LogLevel.ERROR)) {
      HiLog.error(DOMAIN, fitWidth(className), encrypt(message), args);
      return true;
    }
    return false;
  }
  /* instrument ignore next */
  public static fatal(className: string, message: string, ...args: string[]): void {
    HiLog.fatal(DOMAIN, className, Log.fmtStack(Log.stringify(new Error(message + SEPARATOR + Log.join(...args)))));
  }

  /* instrument ignore next */
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

  /* instrument ignore next */
  private static join(...args: Loggable []): string {
    for (let i = 0; i < args.length; i++) {
      try {
        args[i] = Log.stringify(args[i]);
      } catch (err) {
        HiLog.warn(DOMAIN, TAG,
          `${args[i] instanceof Error}${i} type: ${typeof args[i]}, ${args[i]}, stringify error: ${getStack(err)}`);
        args[i] = String(args[i]);
      }
    }
    return args.join(SEPARATOR);
  }

  /* instrument ignore next */
  private static fmtStack(stack: string): string {
    return stack.replace(/\\?\\n/g, '\n').replace(`at e (${PATH}:`, '');
  }
}

/* instrument ignore next */
export function reportEmpty<T>(target: T, ...msg: string[]): T {
  if (isEmpty(target)) {
    Log.warn(TAG, `target is empty. ${String(msg)}`);
  }
  return target;
}

/* instrument ignore next */
export function isEmpty<T>(target: T): boolean {
  switch (typeof target) {
    case 'boolean':
      return false;
    case 'number':
      return Number.isNaN(target);
  }
  return !target;
}

/* instrument ignore next */
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

/* instrument ignore next */
export function getStack(e: Error): string {
  return JSON.stringify(e, (e instanceof Error) ? Object.getOwnPropertyNames(e) : undefined);
}

export function fitWidth(name: string): string {
  return name.substring(name.length - BAR_WIDTH);
}

function encrypt(data: string): string {
  if (!data || data?.indexOf('file:///data/storage/') !== -1) {
    return '';
  }
  let encryptedData = data.replace(/(\/\w+)\./g, '/******.');
  encryptedData = encryptedData.replace(/"userComment":"([^"]|\")*"/g, '"userComment":"******"');
  return encryptedData;
}