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

import lazy { LogUtils } from '../utils/LogUtils';
import lazy { StateObserverManager } from './StateObserverManager';

/**
 * 属性状态管理类
 *
 * @param S 观察的状态类型
 * @param E 引起状态变化的事件类型
 */
export class AttributeStateManager<S, E = string> extends StateObserverManager<S, E> {
  private _currentState: S; // 当前状态值
  private readonly _withLog: boolean;

  public constructor(persistentId: number, initState: S, tag?: string, withLog: boolean = true) {
    super(persistentId, initState, tag !== undefined ? (tag + 'Asm') : undefined);
    this._currentState = initState;
    this._withLog = withLog;
  }

  public override get currentState(): S {
    return this._currentState;
  }

  /**
   * 更新状态
   *
   * @param newState 新的状态
   * @param reason 更新原因
   */
  public updateState(newState: S, reason?: E): void {
    if (newState !== undefined && this._currentState !== newState) {
      let oldState: S = this._currentState;
      this._currentState = newState;
      if (this._withLog) {
        LogUtils.info(this.tag, `updateState: <${this.logState(oldState)} -> ${this.logState(newState)}>,` +
          ` reason: ${this.logReason(reason)} ${this.tag}`);
      } else {
        if (LogUtils.isDebuggable()) {
          LogUtils.debug(this.tag, `updateState: <${this.logState(oldState)} -> ${this.logState(newState)}>,` +
            ` reason: ${this.logReason(reason)} ${this.tag}`);
        }
      }
      this.callbackObservers(observer => observer.onStateChange(oldState, newState, reason));
    }
  }

  /**
   * 记录状态
   *
   * @param state 状态值
   * @returns 状态字符串
   */
  protected logState(state: S): string {
    return `${state}`;
  }

  /**
   * 记录原因
   *
   * @param reason 原因
   * @returns 状态字符串
   */
  protected logReason(reason?: E): string {
    return `${reason}`;
  }
}