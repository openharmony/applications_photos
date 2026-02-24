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

/**
 * 请求监听
 *
 * @since 2023-10-16
 */
export interface RequestListener<T> {
  /**
   * 请求开始
   *
   * @param context 任务上下文
   */
  onRequestStart(context: RequestContext<T>): void;

  /**
   * 请求结束
   *
   * @param context 任务上下文
   */
  onRequestFinish(context: RequestContext<T>): void;

  /**
   * 流程某环节开始
   *
   * @param context 任务上下文
   * @param processorName 环节名
   */
  onProcessorStart(context: RequestContext<T>, processorName: string): void;

  /**
   * 流程某环节结束
   *
   * @param context 任务上下文
   * @param processorName 环节名
   */
  onProcessorFinish(context: RequestContext<T>, processName: string): void;
}