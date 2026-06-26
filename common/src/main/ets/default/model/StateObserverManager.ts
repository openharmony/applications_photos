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

/* instrument ignore file */

import lazy { IObserver, ObserverManager } from '../utils/ObserverManager';

/**
 * 状态变化观察者接口
 *
 * @param S 观察的状态类型
 * @param E 引起状态变化的事件类型
 */
export interface IStateChangeObserver<S, E = string> extends IObserver {
  /**
   * 状态变化回调
   *
   * @param oldState 原状态
   * @param newState 新状态
   * @param event 事件
   */
  onStateChange(oldState: S, newState: S, event?: E): void;
}

/**
 * 状态变化回调函数
 *
 * @param S 观察的状态类型
 * @param E 引起状态变化的事件类型
 */
export type StateChangeCallback<S, E = string> = (oldState: S, newState: S, event?: E) => void;

/**
 * 状态观察者管理类
 *
 * @param S 状态值类型
 * @param T 事件类型
 */
export abstract class StateObserverManager<S, E = string> extends ObserverManager<IStateChangeObserver<S, E>> {
  private readonly _initState: S; // 初始状态值

  protected constructor(persistentId: number, initState: S, tag?: string) {
    super(tag);
    this._persistentId = persistentId;
    this._initState = initState;
  }

  /**
   * 获取当前实例ID
   *
   * @returns 当前实例ID
   */
  public get persistentId(): number {
    return this._persistentId;
  }

  /**
   * 获取当前状态
   *
   * @returns 当前状态
   */
  public abstract get currentState(): S;

  /**
   * 获取初始状态
   *
   * @returns 初始状态
   */
  protected get initState(): S {
    return this._initState;
  }

  protected override doImmediatelyCallback(observer: IStateChangeObserver<S, E>): void {
    observer.onStateChange(this.initState, this.currentState);
  }
}