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
}
