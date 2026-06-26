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

import lazy hiTraceMeter from '@ohos.hiTraceMeter';
import lazy { Log } from './Log';

const TAG: string = 'TraceControllerUtils';

export class TraceControllerUtils {
  // 仅用于调试的输出级别，优先级最低。
  public static readonly DEBUG: number = hiTraceMeter.HiTraceOutputLevel.DEBUG;
  // 用于log版本的输出级别
  public static readonly INFO: number = hiTraceMeter.HiTraceOutputLevel.INFO;
  // 用于log版本的输出级别，优先级高于INFO。
  public static readonly CRITICAL: number = hiTraceMeter.HiTraceOutputLevel.CRITICAL;
  // 用于nolog版本的输出级别，优先级最高。
  public static readonly COMMERCIAL: number = hiTraceMeter.HiTraceOutputLevel.COMMERCIAL;
  // 输出级别范围限制，MAX = COMMERCIAL。
  public static readonly MAX: number = hiTraceMeter.HiTraceOutputLevel.MAX;

  // Used to track the start of sequential tasks
  public static startTrace(name: string): void {
    TraceControllerUtils.startAsyncTrace(TraceControllerUtils.COMMERCIAL, name, 1, 'default');
  }

  // Used to track the end of sequential tasks. The name must be the same as that at start
  public static finishTrace(name: string): void {
    TraceControllerUtils.finishAsyncTrace(TraceControllerUtils.COMMERCIAL, name, 1);
  }

  // Used to track the start of cross tasks
  // (scenarios where the next task starts before the previous task is finished)
  public static startTraceWithTaskId(name: string, taskId: number): void {
    TraceControllerUtils.startAsyncTrace(TraceControllerUtils.COMMERCIAL, name, taskId);
  }

  // Used to track the end of cross tasks. The name and taskid must be the same as at start
  public static finishTraceWithTaskId(name: string, taskId: number): void {
    TraceControllerUtils.finishAsyncTrace(TraceControllerUtils.COMMERCIAL, name, taskId);
  }

  // Records a trace marking it as the start of a task. api:19+
  public static startSyncTrace(level: hiTraceMeter.HiTraceOutputLevel, name: string,
    customArgs: string = 'default'): void {
    hiTraceMeter.startSyncTrace(level, name, customArgs);
  }

  // Records a trace and marks it as the end of a task. api:19+
  public static finishSyncTrace(level: hiTraceMeter.HiTraceOutputLevel): void {
    hiTraceMeter.finishSyncTrace(level);
  }

  // Records a trace marking it as the start of a task. api:19+
  public static startAsyncTrace(level: hiTraceMeter.HiTraceOutputLevel, name: string, taskId: number,
    customCategory: string = 'default', customArgs?: string): void {
    hiTraceMeter.startAsyncTrace(level, name, taskId, customCategory, customArgs);
  }

  // Records a trace and marks it as the end of a task. api:19+
  public static finishAsyncTrace(level: hiTraceMeter.HiTraceOutputLevel, name: string, taskId: number): void {
    hiTraceMeter.finishAsyncTrace(level, name, taskId);
  }

  // Records a trace for generating a count, such as clock pulse and the number of layers.
  public static traceByValue(level: hiTraceMeter.HiTraceOutputLevel, name: string, count: number): void {
    hiTraceMeter.traceByValue(level, name, count);
  }

  // Return whether the current process is allowed to output trace.
  public static isTraceEnabled(): boolean {
    try {
      return hiTraceMeter.isTraceEnabled();
    } catch (error) {
      Log.error(TAG, `isTraceEnabled not callable`);
    }
    return false;
  }

  public static async checkAsyncDelay<R = number, P = never>(func: (...params: P[]) => Promise<R>, funcName:
    string, tag: string = 'photo_browser', timeoutThreshold = 100, ...params: P[]): Promise<R> {
    const name = funcName ?? func.name ?? 'anonymous';
    const API_RESPONSE_DELAY_TIMEOUT: number = 95271001;
    const start: number = Date.now();
    const result: R = await func(...params);
    const delay: number = Date.now() - start;
    if (delay > timeoutThreshold) {
      Log.warn(tag, `code = ${API_RESPONSE_DELAY_TIMEOUT}, func = ${name}, delay = ${delay} ms`);
    }
    return result;
  }
}