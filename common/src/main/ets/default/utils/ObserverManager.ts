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

import lazy { AbstractInitialAble } from './AbstractInitialAble';

const ONLY_ONE_OBSERVER: number = 1;
const NO_OBSERVER: number = 0;

/**
 * 观察者接口
 */
export interface IObserver {
}

/**
 * 观察者管理器接口
 *
 * @param E 观察者类型
 */
export interface IObserverManager<E extends IObserver> {
  /**
   * 注册观察者
   *
   * @param observer 观察者
   */
  registerObserver(observer: E): void;

  /**
   * 注销观察者
   *
   * @param observer 观察者
   */
  unRegisterObserver(observer: E): void;
}

/**
 * 观察者管理类
 *
 * @param E 观察者类型
 * @param T 初始化参数类型
 * @param P 代理者类型
 */
export class ObserverManager<E extends IObserver, T = number> extends AbstractInitialAble<T>
  implements IObserverManager<E> {
  /**
   * 观察着列表
   */
  private readonly _observers: Set<E> = new Set<E>();

  /**
   * 注册观察者
   *
   * @param observer 观察者
   * @param isCallbackImmediately 是否注册时立即回调
   */
  public registerObserver(observer: E, isCallbackImmediately: boolean = false): void {
    this._observers.add(observer);
    if (this.observerSize === ONLY_ONE_OBSERVER) {
      this.onObserverStateChange?.(true);
    }
    if (isCallbackImmediately) {
      this.doImmediatelyCallback?.(observer);
    }
  }

  /**
   * 注销观察者
   *
   * @param observer 观察者
   */
  public unRegisterObserver(observer: E): void {
    if (this._observers.delete(observer)) {
      if (this.observerSize === NO_OBSERVER) {
        this.onObserverStateChange?.(false);
      }
    }
  }

  protected override doInit(param?: T): void {
    if (this._persistentId !== undefined || param === undefined) {
      return;
    }
    if (param instanceof AbstractInitialAble) {
      this._persistentId = param.persistentId;
    } else {
      this._persistentId = param as number;
    }
  }

  protected override doRelease(): void {
    this._observers.clear();
  }

  /**
   * 判断是否有观察者
   *
   * @returns true是/false否
   */
  protected hasObserver(): boolean {
    return this._observers.size > 0;
  }

  /**
   * 获取观察者数目
   *
   * @returns 观察者数目
   */
  protected get observerSize(): number {
    return this._observers.size;
  }

  /**
   * 执行立即回调
   *
   * @param observer 观察者
   */
  protected doImmediatelyCallback?(observer: E): void;

  /**
   * 有无观察者状态变更回调
   *
   * @param hasObserver 是否有观察者
   */
  protected onObserverStateChange?(hasObserver: boolean): void;

  /**
   * 回调监听者
   *
   * @param callback 回调动作
   */
  protected callbackObservers(callback: (observer: E) => void): void {
    if (this.hasObserver()) {
      this._observers.forEach(observer => callback(observer));
    }
  }
}