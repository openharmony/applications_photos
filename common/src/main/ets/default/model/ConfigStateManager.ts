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
import lazy { AbstractConfig } from './AbstractConfig';

/**
 * 获取配置接口
 */
export interface IGetConfig<C> {
  /**
   * 获取配置
   *
   * @returns 相关配置
   */
  get config(): C;
}

/**
 * 带配置的状态观察管理器
 *
 * @param L 管理器的监听器
 * @param C 管理器的配置类型
 * @param T 管理器的初始化参数类型
 * @param V 管理器的可变参数类型
 */
export abstract class ConfigStateManager<C extends AbstractConfig<T>, T, V, L = IObserver>
  extends ObserverManager<L, T> implements IGetConfig<C> {
  /**
   * 获取配置
   *
   * @returns 相关配置
   */
  public readonly config: C;

  public constructor(persistentId: number, tag?: string) {
    super(tag);
    this._persistentId = persistentId;
  }

  /**
   * 根据可变配置更新状态
   *
   * @param config? 配置信息
   * @param reason? 更新原因
   */
  public abstract updateStateFromVariableConfig(config?: V, reason?: string): void;

  protected override doInit(config: T): void {
    super.doInit(config);
    this.config.setPersistentId(this.persistentId);
    this.config.init(config);
    this.updateStateFromInitConfig(this.config, 'updateStateFromInitConfig');
  }

  protected override doRelease(): void {
    this.config.release();
    super.doRelease();
  }

  /**
   * 根据初始化配置更新状态
   *
   * @param config 初始化配置
   * @param reason? 更新原因
   */
  protected abstract updateStateFromInitConfig(config: C, reason?: string): void;
}