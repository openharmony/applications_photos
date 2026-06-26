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
import hiTraceMeter from '@ohos.hiTraceMeter';
import { HiLog } from './HiLog';

export class Trace {
  private static taskId: number = 0;
  private static maxId: number = 1000000;
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

  public static begin(name: string, level?:number): void {
    HiLog.i('Trace', name + ' begin');
    Trace.startAsyncTrace(level ?? Trace.COMMERCIAL, name, 0, 'default');
  }

  public static beginWithId(name: string, level?:number): number {
    /* instrument ignore if */
    if (Trace.taskId > Trace.maxId) {
      Trace.taskId = 0;
    }
    Trace.taskId++;
    HiLog.i('Trace', name + ' begin_' + Trace.taskId);
    Trace.startAsyncTrace(level ?? Trace.COMMERCIAL, name, Trace.taskId, 'default');
    return Trace.taskId;
  }

  public static end(name: string, id?: number, level?:number): void {
    if (id) {
      HiLog.i('Trace', name + ' end_' + id);
      Trace.finishAsyncTrace(level ?? Trace.COMMERCIAL, name, id);
    } else {
      HiLog.i('Trace', name + ' end');
      Trace.finishAsyncTrace(level ?? Trace.COMMERCIAL, name, 0);
    }
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
}
