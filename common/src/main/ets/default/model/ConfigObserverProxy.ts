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

import lazy { IObserverManager } from '../utils/ObserverManager';
import lazy { AbstractObserverProxy } from './AbstractObserverProxy';
import lazy { IGetConfig } from './ConfigStateManager';

/**
 * 带观察者管理器的获取配置接口
 */
export interface IObserverGetConfig<C, L> extends IGetConfig<C>, IObserverManager<L> {
}

/**
 * 带配置的状态观察者代理
 *
 * @param P 代理的对象类型
 * @param C 代理的配置类型
 */
export class ConfigObserverProxy<P extends IGetConfig<C>, C> extends AbstractObserverProxy<P>
  implements IGetConfig<C> {
  /**
   * 获取配置
   *
   * @returns 相关配置
   */
  public get config(): C {
    return this.proxy.config;
  }
}

/**
 * 带配置的状态观察者代理
 *
 * @param P 代理的对象类型
 * @param C 代理的配置类型
 * @param L 监听代理
 */
export class ConfigListenerObserverProxy<P extends IObserverGetConfig<C, L>, C, L> extends ConfigObserverProxy<P, C> {
  // 数据源监听器
  private readonly listeners: Set<L> = new Set();

  /**
   * 注册事件监听
   *
   * @param eventListener 事件监听回调
   */
  public registerEventListener(eventListener: L): void {
    this.listeners.add(eventListener);
    this.proxy.registerObserver(eventListener);
  }

  /**
   * 注销事件监听
   *
   * @param eventListener 事件监听回调
   */
  public unRegisterEventListener(eventListener: L): void {
    this.listeners.delete(eventListener);
    this.proxy.unRegisterObserver(eventListener);
  }

  protected override doRelease(): void {
    this.clearListeners();
    super.doRelease();
  }

  private clearListeners(): void {
    if (this.listeners.size > 0) {
      for (let listener of this.listeners) {
        this.proxy.unRegisterObserver(listener);
      }
      this.listeners.clear();
    }
  }
}