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

import hilog from '@ohos.hilog';
import hiTraceMeter from '@ohos.hiTraceMeter';

const DOMAIN: number = 0x00D30;

/**
 * HiLog Util
 *
 * standard :
 * 1. define TAG, recommend class name。
 * 2. switch IS_DEBUG_ON as true, when debugging.
 * 3. msg should be short and valuable.
 * 4. choose appropriate function.
 * 5. the function execute many times can not print.
 * 6. uniqueness.
 */
export class HiLog {
  private static readonly IS_DEBUG_ON: boolean = false;
  private static readonly TRACE_LOG_BEGIN: string = ' begin.';
  private static readonly TRACE_LOG_END: string = ' end.';
  private static readonly TRACE_LOG_SEPARATE: string = '::';
  private static keyMap: Map<string, number> = new Map();

  static begin(tag: string, methodName: string): void {
    hilog.info(DOMAIN, tag, methodName + this.TRACE_LOG_BEGIN);
    hiTraceMeter.startTrace(tag + this.TRACE_LOG_SEPARATE + methodName, 1);
  }

  static end(tag: string, methodName: string): void {
    hilog.info(DOMAIN, tag, methodName + this.TRACE_LOG_END);
    hiTraceMeter.finishTrace(tag + this.TRACE_LOG_SEPARATE + methodName, 1);
  }

  static d(tag: string, msg: string, ...args: any[]): void {
    if (this.IS_DEBUG_ON) {
      hilog.info(DOMAIN, tag, msg, args);
    } else {
      hilog.debug(DOMAIN, tag, msg, args);
    }
  }

  static i(tag: string, msg: string, ...args: any[]): void {
    hilog.info(DOMAIN, tag, msg, args);
  }

  // 打印URI时做匿名处理。
  static iWithUri(tag: string, msg: string, ...args: any[]): void {
    hilog.info(DOMAIN, tag, anonymousUri(msg), args);
  }

  static w(tag: string, msg: string, ...args: any[]): void {
    hilog.warn(DOMAIN, tag, msg, args);
  }

  static e(tag: string, msg: string, ...args: any[]): void {
    hilog.error(DOMAIN, tag, msg, args);
  }

  static f(tag: string, msg: string, ...args: any[]): void {
    hilog.fatal(DOMAIN, tag, msg, args);
  }

  // 公用处频繁日志打印
  static iFreq(tag: string, msg: string, isFreq: boolean, ...args: any[]): void {
    if (isFreq) {
      hilog.debug(DOMAIN, tag, msg, args);
    } else {
      hilog.info(DOMAIN, tag, msg, args);
    }
  }

  static beginTraceFreq(tag: string, methodName: string, isFreq: boolean): void {
    if (!isFreq) {
      hilog.info(DOMAIN, tag, methodName + this.TRACE_LOG_BEGIN);
      hiTraceMeter.startTrace(tag + this.TRACE_LOG_SEPARATE + methodName, 1);
    }
  }

  static endTraceFreq(tag: string, methodName: string, isFreq: boolean): void {
    if (!isFreq) {
      hilog.info(DOMAIN, tag, methodName + this.TRACE_LOG_END);
      hiTraceMeter.finishTrace(tag + this.TRACE_LOG_SEPARATE + methodName, 1);
    }
  }

  // 限制频繁打印，但是又需要查看i级别的日志，每隔一段时间打印一次
  // 每个频繁打印的mapKey一定要唯一
  static limitLog(tag: string, msg: string, mapKey: string, freqTime: number = 2): void {
    const preTime: number = this.keyMap.get(mapKey) ?? 0;
    const time: number = Date.now();
    const intervalTime: number = freqTime * 1000;
    if (this.keyMap.has(mapKey) && time - preTime < intervalTime) {
      return;
    }
    this.keyMap.set(mapKey, time);
    hilog.info(DOMAIN, tag, msg);
  }
}

function anonymousUri(uri: string): string {
  // Find the position of the last '/' and the first '.'
  const lastSlashIndex = uri.lastIndexOf('/');
  const firstDotIndex = uri.indexOf('.');

  // Ensure both indices are valid
  if (lastSlashIndex === -1 || firstDotIndex === -1 || lastSlashIndex >= firstDotIndex) {
    return uri; // Return the original string if conditions are not met
  }

  // Replace the substring between last '/' and first '.'
  const before = uri.substring(0, lastSlashIndex + 1);
  const mid = uri.substring(lastSlashIndex + 1, firstDotIndex);
  const replacement = `${mid[0]}xxxxxx${mid[mid.length - 1]}`;
  const after = uri.substring(firstDotIndex);
  return before + replacement + after;
}