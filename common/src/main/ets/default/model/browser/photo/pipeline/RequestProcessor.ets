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

import type { RequestContext } from './RequestContext';
import lazy { TraceControllerUtils } from '../../../../utils/TraceControllerUtils';
import lazy { Log } from '../../../../utils/Log';

/**
 * 责任链环节
 *
 * @since 2023-10-16
 */
/* instrument ignore file */
export class RequestProcessor<T> {
  /**
   * 下一个处理环节
   */
  protected next: RequestProcessor<T> | undefined;

  /**
   * 构造函数
   *
   * @param next 下一个处理环节
   */
  constructor(next?: RequestProcessor<T>) {
    this.next = next;
  }

  /**
   * 判断当前Processor是否支持
   *
   * @param context 上下文
   * @returns 是否支持
   */
  public isSupported(context: RequestContext<T>): boolean {
    return context && !context.isCancelled;
  }

  /**
   * 处理流程
   *
   * @param context 上下文
   * @returns
   */
  public async getResult(context: RequestContext<T>): Promise<T | undefined> {
    return undefined;
  }

  /**
   * 获取环节名
   *
   * @returns 环节名称
   */
  public getProcessorName(): string {
    return 'RequestProcessor';
  }

  /**
   * 责任链对外处理入口
   *
   * @param context 上下文
   */
  public process(context: RequestContext<T> | undefined): void {
    if (!context) {
      return;
    }
    context.onRequestStart();

    TraceControllerUtils.startTraceWithTaskId(`${this.getProcessorName()}.isSupported`, context.submitTime);
    let isSupported: boolean = this.isSupported(context);
    TraceControllerUtils.finishTraceWithTaskId(`${this.getProcessorName()}.isSupported`, context.submitTime);

    if (!isSupported && this.next) {
      this.next.process(context);
      return;
    }

    let result: T | undefined = undefined;
    context.onProcessorStart(this.getProcessorName());
    TraceControllerUtils.startTraceWithTaskId(`${this.getProcessorName()}.getResult`, context.submitTime);

    this.getResult(context).then(thumbnail => {
      result = thumbnail;
    }).catch((err: Error) => {
      Log.error(this.getProcessorName(), 'err: ' + err);
    }).finally(() => {
      TraceControllerUtils.finishTraceWithTaskId(`${this.getProcessorName()}.getResult`, context.submitTime);
      context.onProcessorFinish(this.getProcessorName());
      if (result) {
        context.result = result;
        context.isFinished = true;
        context.onRequestFinish();
        return;
      }

      if (this.next) {
        this.next.process(context);
      } else {
        context.onRequestFinish();
      }
    });
  }
}