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

import lazy { AbstractInitialAble, InitialAble } from '../utils/AbstractInitialAble';
import lazy { LogUtils } from '../utils/LogUtils';
import lazy { IObserver, ObserverManager } from '../utils/ObserverManager';
import lazy { IStateChangeObserver, StateChangeCallback, StateObserverManager } from './StateObserverManager';

/**
 * 状态变化观察者
 *
 * @param S 观察的状态类型
 * @param E 引起状态变化的事件类型
 */
export class ObserverWrapper<S, E = string> extends AbstractInitialAble {
  private readonly _observer: IStateChangeObserver<S, E>;
  private readonly _observerManager: StateObserverManager<S, E>;
  private readonly _callback: StateChangeCallback<S, E>;
  private readonly _isCallbackImmediately: boolean;

  constructor(observerManager: StateObserverManager<S, E>, callback: StateChangeCallback<S, E>,
    isCallbackImmediately: boolean = true) {
    super();
    this._observer = { onStateChange: callback };
    this._observerManager = observerManager;
    this._callback = callback;
    this._isCallbackImmediately = isCallbackImmediately;
  }

  public get callback(): Function {
    return this._callback;
  }

  protected override doInit(): void {
    this._observerManager.registerObserver(this._observer, this._isCallbackImmediately);
  }

  protected override doRelease(): void {
    this._observerManager.unRegisterObserver(this._observer);
  }
}

// 触发状态变化的事件类型（整形和字符串基本能囊括当前所需，注：状态机属于整形，属性状态管理器默认为字符串）
type EventType = number | string;

/**
 * 抽象状态观察者代理
 *
 * @param P 代理的对象类型
 * @param E 事件类型
 */
export abstract class AbstractObserverProxy<P, T = number, E = EventType>
  extends ObserverManager<ObserverWrapper<IObserver, E>, T> {
  // 获取代理方法
  protected readonly getProxyFunc: (persistentId: number) => P;

  public constructor(getProxyFunc: (persistentId: number) => P, tag?: string) {
    super(tag);
    this.getProxyFunc = getProxyFunc;
  }

  /**
   * 释放回调
   *
   * @param callback 回调函数
   */
  public releaseCallback<S, E>(callback: StateChangeCallback<S, E>): void {
    this.callbackObservers(observerProxy => {
      if (observerProxy.callback === callback) {
        observerProxy.release();
        this.unRegisterObserver(observerProxy);
      }
    });
  }

  protected override doInit(param: T): void {
    super.doInit(param);
  }

  protected override doRelease(): void {
    this.callbackObservers(observerProxy => {
      observerProxy.release();
      this.unRegisterObserver(observerProxy);
    });
    super.doRelease();
  }

  /**
   * 获取状态管理器
   *
   * @returns 状态管理器
   */
  protected get proxy(): P {
    return this.getProxyFunc(this.persistentId);
  }

  /**
   * 从状态管理器中获取状态值
   *
   * @param observerManager 状态管理器
   * @param callback 回调接口
   * @param isCallbackImmediately 是否立即回调
   * @returns
   */
  protected getState<S>(observerManager: StateObserverManager<S, E>, callback?: StateChangeCallback<S, E>,
    isCallbackImmediately: boolean = true): S {
    let currentState: S = observerManager.currentState;
    if (callback) {
      let observerProxy: ObserverWrapper<S, E> =
        new ObserverWrapper(observerManager, callback, isCallbackImmediately);
      observerProxy.init();
      this.registerObserver(observerProxy);
    }
    return currentState;
  }
}