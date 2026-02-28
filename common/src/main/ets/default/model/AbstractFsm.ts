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
import lazy { ObjectPool, Recyclable } from '../utils/ObjectPool';
import lazy { SystemTimeUtils } from '../utils/SystemTimeUtils';
import lazy { StateChangeCallback, StateObserverManager } from './StateObserverManager';

const FSM_EVENT_POOL_SIZE: number = 10;
const PRE_CALLBACK_TIME_LIMIT: number = 10; // 单位毫秒
const CALLBACK_TIME_LIMIT: number = 30; // 单位毫秒
const POST_CALLBACK_TIME_LIMIT: number = 10; // 单位毫秒

type Constructor<ST, S = {}> = new (stateType: ST) => S;

/**
 * 定义事件
 */
export abstract class AbstractEvent<ET> implements Recyclable {
  private _eventType: ET;

  constructor(eventType: ET) {
    this._eventType = eventType;
  }

  public get eventType(): ET {
    return this._eventType;
  }

  public set eventType(eventType: ET) {
    this._eventType = eventType;
  }

  public recycle(): void {
  }

  /**
   * 转化为字符串形式
   *
   * @returns 字符串形式
   */
  public abstract toString(): string;
}

/**
 * 定义状态
 */
export abstract class AbstractState<ST, ET> {
  /**
   * 状态码
   */
  private readonly _stateType: ST;

  constructor(stateType: ST) {
    this._stateType = stateType;
  }

  public get stateType(): ST {
    return this._stateType;
  }

  /**
   * 转化为字符串形式
   *
   * @returns 字符串形式
   */
  public abstract toString(): string;

  /**
   * 处理事件
   *
   * @param event 事件
   * @returns 下一状态
   */
  public abstract handleEvent(eventType: ET): ST;
}

/**
 * 定义状态工厂
 */
export abstract class AbstractStateFactory<ST, ET> {
  /**
   * 状态表
   */
  private readonly _states: Map<ST, AbstractState<ST, ET>> = new Map();

  /**
   * 状态构造器表
   */
  private readonly _constructors: Map<ST, Constructor<ST, AbstractState<ST, ET>>> = new Map();

  protected constructor() {
  }

  /**
   * 获取状态
   *
   * @param stateType 状态类型
   * @returns 状态值
   */
  public getState(stateType: ST): AbstractState<ST, ET> {
    if (this._states.has(stateType)) {
      return this._states.get(stateType)!;
    }

    let newState: AbstractState<ST, ET>;
    if (this._constructors.has(stateType)) {
      let constructor: Constructor<ST, AbstractState<ST, ET>> = this._constructors.get(stateType);
      newState = new constructor(stateType);
    } else {
      throw new Error(`Create state ${stateType} failed, please check state focatory.`);
    }
    this._states.set(stateType, newState);
    return newState;
  }

  /**
   * 增加状态构造方法（按需加载）
   *
   * @param stateType 状态类型
   * @param constructor 构造方法
   */
  public addStateConstructor(stateType: ST, constructor: Constructor<ST, AbstractState<ST, ET>>): void {
    this._constructors.set(stateType, constructor);
  }
}

/**
 * 定义状态机
 */
export abstract class AbstractFsm<ST, E extends AbstractEvent<ET>, ET> extends StateObserverManager<ST, ET> {
  /**
   * 回调前回调
   */
  protected _preCallback?: StateChangeCallback<ST, ET>;

  /**
   * 回调后回调
   */
  protected _postCallback?: StateChangeCallback<ST, ET>;

  /**
   * 事件对象池
   */
  protected readonly _eventPool: ObjectPool<E>;

  /**
   * 当前正在处理的事件类型
   */
  protected _currentEventType?: ET;

  /**
   * 状态相同时是否回调
   */
  protected readonly _isSameStateCallback: boolean = false;

  private readonly _pendingEvents: Array<E> = new Array();
  private readonly _stateFactory: AbstractStateFactory<ST, ET>;
  private _currentState: AbstractState<ST, ET>;
  private _isRunning: boolean = false;

  constructor(persistentId: number, stateFactory: AbstractStateFactory<ST, ET>, initStateType: ST,
    eventBuilder: () => E, tag?: string) {
    super(persistentId, initStateType, tag);
    this._stateFactory = stateFactory;
    this._eventPool = new ObjectPool(FSM_EVENT_POOL_SIZE, eventBuilder);
    this._currentState = stateFactory.getState(initStateType);
  }

  public override get currentState(): ST {
    return this._currentState.stateType;
  }

  /**
   * 获取状态机事件
   *
   * @returns 状态机事件
   */
  public obtainEvent(): E | null {
    return this._eventPool.acquire();
  }

  /**
   * 提交状态机事件
   *
   * @param event 事件或事件类型
   */
  public submitEvent(event: E | ET): void {
   try {
     if (!event) {
       return;
     }
     if (event instanceof AbstractEvent) {
       this._pendingEvents.push(event as E);
     } else {
       let obtainEvent: E = this._eventPool.acquire();
       if (!obtainEvent) {
         LogUtils.warn(this.tag, `submitEvent failed: ${event}`);
         return;
       }
       obtainEvent.eventType = event as ET;
       this._pendingEvents.push(obtainEvent);
     }
     this.handleEvent();
   }catch (e) {
     LogUtils.error(this.tag, `submitEvent failed: ${e}`);
   }
  }

  private handleEvent(): void {
    if (this._isRunning) {
      LogUtils.info(this.tag, `isRunning, will handle event later.`);
      return;
    }
    LogUtils.debug(this.tag, `handle event begin. handler count: ${this.observerSize}`);
    this._isRunning = true;
    while (this._pendingEvents.length > 0) {
      let oldState: AbstractState<ST, ET> = this._currentState;
      let event: E = this._pendingEvents.pop()!;
      this._currentEventType = event.eventType;
      this._currentState = this.getNextState(this._currentState.handleEvent(event.eventType));
      this._currentEventType = undefined;
      if (oldState.stateType !== this._currentState.stateType || this._isSameStateCallback) {
        LogUtils.info(this.tag, this.getTransitionLog(oldState, this._currentState, event));
        this.doCallback(oldState.stateType, this._currentState.stateType, event.eventType);
      } else {
        LogUtils.debug(this.tag, this.getTransitionLog(oldState, this._currentState, event));
      }
      this._eventPool.release(event);
    }
    this._isRunning = false;
    LogUtils.debug(this.tag, `handle event end.`);
  }

  /**
   * 获取下一跳状态（重写此方法，可做定制修改）
   *
   * @param rawNewState 初始下一跳状态
   * @returns 下一跳
   */
  protected getNextState(rawNewState: ST): AbstractState<ST, ET> {
    return this._stateFactory.getState(rawNewState);
  }

  protected override doRelease(): void {
    super.doRelease();
    this._eventPool.destroy();
  }

  private getTransitionLog(oldState: AbstractState<ST, ET>, newState: AbstractState<ST, ET>, event: E): string {
    return `transition: ${event.toString()} [${oldState.toString()} --> ${newState.toString()}]`;
  }

  private doCallback(oldState: ST, newState: ST, event: ET): void {
    if (this._preCallback) {
      this.logProcessTime((): void => {
        this._preCallback?.(oldState, newState, event);
      }, PRE_CALLBACK_TIME_LIMIT, 'pre callback');
    }
    if (this.hasObserver()) {
      this.logProcessTime((): void => {
        this.callbackObservers(observer => observer.onStateChange(oldState, newState, event));
      }, CALLBACK_TIME_LIMIT, 'callback');
    }
    if (this._postCallback) {
      this.logProcessTime((): void => {
        this._postCallback?.(oldState, newState, event);
      }, POST_CALLBACK_TIME_LIMIT, 'post callback');
    }
  }

  private logProcessTime(processFunc: Function, warningTimeLimit: number, processName: string): void {
    let curTime: number = SystemTimeUtils.getStartUpTime();
    processFunc();
    let useTime: number = SystemTimeUtils.getStartUpTime() - curTime;
    if (useTime > warningTimeLimit) {
      LogUtils.warn(this.tag, `${processName} use ${useTime}ms over limit ${warningTimeLimit}`);
    }
  }
}