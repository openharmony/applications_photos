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

import lazy {
  AbstractEvent,
  AbstractFsm,
  AbstractState,
  AbstractStateFactory
} from '@ohos/common/src/main/ets/default/model/AbstractFsm';

/**
 * 宫格预加载状态机-状态类型
 */
export enum PreloadStateType {
  /**
   * 初始态
   */
  INIT_STATE = 0,

  /**
   * 预加载态
   */
  PRELOAD_STATE,

  /**
   * 预加载超时态
   */
  PRELOAD_TIMEOUT_STATE,

  /**
   * 预览界面已加载态
   */
  LOADED_STATE,

  /**
   * 宫格界面已完全加载，预览界面隐藏态
   */
  HIDDEN_STATE,
}

/**
 * 宫格预加载状态类型工具类
 */
export class PreloadStateTypeUtils {
  private constructor() {
  }

  /**
   * 是否处于预加载态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInPreloadState(stateType: PreloadStateType): boolean {
    return stateType !== PreloadStateType.HIDDEN_STATE;
  }

  /**
   * 是否处在初始化或预加载态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInitOrPreloadState(stateType: PreloadStateType): boolean {
    return stateType === PreloadStateType.INIT_STATE || stateType === PreloadStateType.PRELOAD_STATE;
  }

  /**
   * 是否处在预加载或预加载超时态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInPreloadOrTimeoutState(stateType: PreloadStateType): boolean {
    return stateType === PreloadStateType.PRELOAD_STATE || stateType === PreloadStateType.PRELOAD_TIMEOUT_STATE;
  }

  /**
   * 是否超过了预加载态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInLoadedOrTimeoutState(stateType: PreloadStateType): boolean {
    return stateType === PreloadStateType.PRELOAD_TIMEOUT_STATE || stateType === PreloadStateType.LOADED_STATE ||
      stateType === PreloadStateType.HIDDEN_STATE;
  }

  /**
   * 是否处于宫格页
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInLoadedState(stateType: PreloadStateType): boolean {
    return stateType === PreloadStateType.LOADED_STATE || stateType === PreloadStateType.HIDDEN_STATE;
  }
}

/**
 * 预加载作状态机-事件类型
 */
export enum PreloadEventType {
  /**
   * 无意义事件，用于创建默认事件，状态机可不处理
   */
  NONE,

  /**
   * 进入预览状态
   */
  ENTER_PRELOAD,

  /**
   * 预加载超时
   */
  PRELOAD_TIMEOUT,

  /**
   * 加载结束
   */
  LOAD_FINISH,

  /**
   * 预览隐藏
   */
  HIDE,
}

/**
 * 宫格预加载状态机事件
 */
export class PreloadEvent extends AbstractEvent<PreloadEventType> {
  public override toString(): string {
    return PreloadEventType[this.eventType] ?? 'Unknown_PreloadEvent';
  }
}

/**
 * 抽象宫格操作状态
 */
abstract class AbstractOperateState extends AbstractState<PreloadStateType, PreloadEventType> {
  public override toString(): string {
    return PreloadStateType[this.stateType] ?? 'Unknown_PreloadState';
  }
}

/**
 * 初始态
 */
class InitState extends AbstractOperateState {
  public handleEvent(eventType: PreloadEventType): PreloadStateType {
    switch (eventType) {
      case PreloadEventType.ENTER_PRELOAD:
        return PreloadStateType.PRELOAD_STATE;
      case PreloadEventType.LOAD_FINISH:
        return PreloadStateType.LOADED_STATE;
      case PreloadEventType.HIDE:
        return PreloadStateType.HIDDEN_STATE;
    }
    return this.stateType;
  }
}

/**
 * 预加载态
 */
class PreloadState extends AbstractOperateState {
  public handleEvent(eventType: PreloadEventType): PreloadStateType {
    switch (eventType) {
      case PreloadEventType.PRELOAD_TIMEOUT:
        return PreloadStateType.PRELOAD_TIMEOUT_STATE;
      case PreloadEventType.LOAD_FINISH:
        return PreloadStateType.LOADED_STATE;
      case PreloadEventType.HIDE:
        return PreloadStateType.HIDDEN_STATE;
    }
    return this.stateType;
  }
}

/**
 * 预加载超时态
 */
class PreloadTimeoutState extends AbstractOperateState {
  public handleEvent(eventType: PreloadEventType): PreloadStateType {
    switch (eventType) {
      case PreloadEventType.LOAD_FINISH:
        return PreloadStateType.LOADED_STATE;
      case PreloadEventType.HIDE:
        return PreloadStateType.HIDDEN_STATE;
    }
    return this.stateType;
  }
}

/**
 * 已加载态
 */
class LoadedState extends AbstractOperateState {
  public handleEvent(eventType: PreloadEventType): PreloadStateType {
    switch (eventType) {
      case PreloadEventType.HIDE:
        return PreloadStateType.HIDDEN_STATE;
    }
    return this.stateType;
  }
}

class HiddenState extends AbstractOperateState {
  public handleEvent(eventType: PreloadEventType): PreloadStateType {
    switch (eventType) {
      case PreloadEventType.HIDE:
        return PreloadStateType.HIDDEN_STATE;
    }
    return this.stateType;
  }
}

/**
 * 宫格状态工厂
 */
class GridOperateStateFactory extends AbstractStateFactory<PreloadStateType, PreloadEventType> {
  public constructor() {
    super();
    this.addStateConstructor(PreloadStateType.INIT_STATE, InitState);
    this.addStateConstructor(PreloadStateType.PRELOAD_STATE, PreloadState);
    this.addStateConstructor(PreloadStateType.PRELOAD_TIMEOUT_STATE, PreloadTimeoutState);
    this.addStateConstructor(PreloadStateType.LOADED_STATE, LoadedState);
    this.addStateConstructor(PreloadStateType.HIDDEN_STATE, HiddenState);
  }
}

/**
 * 宫格预加载状态机
 */
export class GridPreloadFsm extends AbstractFsm<PreloadStateType, PreloadEvent, PreloadEventType> {
  protected _postCallback = (_oldState: PreloadStateType, newState: PreloadStateType): void => {
    if (PreloadStateTypeUtils.isInLoadedState(newState)) {
      this._eventPool.destroy();
    }
  };

  public constructor(persistentId: number) {
    super(persistentId, new GridOperateStateFactory(), PreloadStateType.INIT_STATE,
      () => new PreloadEvent(PreloadEventType.NONE));
  }
}