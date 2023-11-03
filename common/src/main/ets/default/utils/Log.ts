/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import HiLog from '@ohos.hilog';

const DOMAIN: number = 0x0220;
const TAG: string = 'Photos';
const COLON = ': ';
const SEPARATOR = ' ';

export class Log {
  static debug(className: string, message: string, ...args: string[]): boolean {
    if (HiLog.isLoggable(DOMAIN, TAG, HiLog.LogLevel.DEBUG)) {
      HiLog.debug(DOMAIN, TAG, className + COLON + message, args);
      return true;
    }
    return false;
  }

  static info(className: string, message: string, ...args: string[]): boolean {
    if (HiLog.isLoggable(DOMAIN, TAG, HiLog.LogLevel.INFO)) {
      HiLog.info(DOMAIN, TAG, className + COLON + message, args);
      return true;
    }
    return false;
  }

  static warn(className: string, message: string, ...args: string[]): boolean {
    if (HiLog.isLoggable(DOMAIN, TAG, HiLog.LogLevel.WARN)) {
      HiLog.warn(DOMAIN, TAG, className + COLON + message, args);
      return true;
    }
    return false;
  }

  static error(className: string, message: string, ...args: string[]): boolean {
    if (HiLog.isLoggable(DOMAIN, TAG, HiLog.LogLevel.ERROR)) {
      HiLog.error(DOMAIN, TAG, className + COLON + message, args);
      return true;
    }
    return false;
  }

  static fatal(className: string, message: string, ...args: string[]): boolean {
    if (HiLog.isLoggable(DOMAIN, TAG, HiLog.LogLevel.FATAL)) {
      HiLog.fatal(DOMAIN, TAG, className + COLON + message, args);
      return true;
    }
    return false;
  }

  /**
   * 使用方法 直接逗号分隔开:
   ```
   Log.debug(TAG, `params = , ${JSON.stringify(param1)},  ${JSON.stringify(param2)...`)
   简化为 Log.d(TAG, 'params = ', param1, param2...)
   Log.error(TAG, `${JSON.stringify(err)obj = key1: ${JSON.stringify(v1)}, key2: ${JSON.stringify(v2)...`)
   简化为 Log.e(TAG, err, 'obj = ', { key1: v1, key2: v2 })
   ```
   */
  static d(className: string, ...args): void {
    return HiLog.debug(DOMAIN, TAG, className + COLON + this.join(...args));
  }

  static i(className: string, ...args): void {
    return HiLog.info(DOMAIN, TAG, className + COLON + this.join(...args));
  }

  static w(className: string, ...args): void {
    return HiLog.warn(DOMAIN, TAG, className + COLON + this.join(...args));
  }

  static e(className: string, ...args): void {
    return HiLog.error(DOMAIN, TAG, className + COLON + this.join(...args));
  }

  static f(className: string, ...args): void {
    return HiLog.fatal(DOMAIN, TAG, className + COLON + this.join(...args));
  }

  static stringify(a): string {
    let res: string;
    if (typeof a !== 'string') {
      try {
        res = JSON.stringify(a);
        HiLog.debug(DOMAIN, TAG, a);
      } catch (e) {
        if (e) {
          HiLog.error(DOMAIN, TAG, `${e} type: ${typeof a}, ${a}, catch error: ${JSON.stringify(e)}`);
        }
        res = e;
      }
    }
    if (res === '{}') {
      try {
        res = String(a);
      } catch (e) {
        if (e) {
          HiLog.warn(DOMAIN, TAG, `${e} type: ${typeof a}, ${a}, catch error: ${JSON.stringify(e)}`);
        }
      }
    }
    return res ?? a;
  }

  static join(...args): string {
    for (let i = 0; i < args.length; i++) {
      try {
        args[i] = this.stringify(args[i]);
      } catch (e) {
        HiLog.warn(DOMAIN, TAG, `${e} type: ${typeof args[i]}, ${args[i]}, catch error: ${JSON.stringify(e)}`);
      }
    }
    return args.join(SEPARATOR);
  }
}
