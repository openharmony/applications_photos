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
import type common from '@ohos.app.ability.common';

import type { ImageRequest } from './ImageRequest';
import type { RequestListener } from './RequestListener';

/**
 * 请求上下文
 *
 * @since 2023-10-16
 */
export class RequestContext<T> {
  /**
   * app上下文
   */
  public appCtx: common.Context | undefined = undefined;
  /**
   * 请求
   */
  public request: ImageRequest | undefined = undefined;
  /**
   * 请求结果
   */
  public result: T | undefined = undefined;
  /**
   * 任务提交时间
   */
  public submitTime: number = Number.NaN;
  /**
   * 是否被取消
   */
  public isCancelled: boolean = false;
  /**
   * 是否已完成
   */
  public isFinished: boolean = false;
  /**
   * 参数，可用于processor间传递上下文参数
   */
  public params: Map<string, Object> = new Map();
  private listeners: RequestListener<T>[] = [];
  public onDeCodeFinishCb: Function | undefined = undefined;

  /**
   * 构造函数
   *
   * @param request 请求
   */
  constructor(appCtx: common.Context, request: ImageRequest, onDeCodeFinishCb?: Function) {
    if (!appCtx || !request) {
      throw new Error('invalid params!');
    }
    this.appCtx = appCtx;
    this.request = request;
    if (onDeCodeFinishCb) {
      this.onDeCodeFinishCb = onDeCodeFinishCb;
    }
  }

  /**
   * 添加监听
   *
   * @param listener 监听
   */
  public addListener(listener: RequestListener<T>): void {
    if (!listener || this.listeners.includes(listener)) {
      return;
    }
    this.listeners.push(listener);
  }

  /**
   * 请求开始
   */
  public onRequestStart(): void {
    for (let listener of this.listeners) {
      listener.onRequestStart(this);
    }
  }

  /**
   * 请求结束
   */
  public onRequestFinish(): void {
    for (let listener of this.listeners) {
      listener.onRequestFinish(this);
    }
  }

  public onProcessorStart(processorName: string): void {
    for (let listener of this.listeners) {
      listener.onProcessorStart(this, processorName);
    }
  }

  public onProcessorFinish(processorName: string): void {
    for (let listener of this.listeners) {
      listener.onProcessorFinish(this, processorName);
    }
  }
}