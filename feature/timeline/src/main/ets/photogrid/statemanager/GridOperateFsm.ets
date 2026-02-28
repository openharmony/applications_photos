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

const INITIALIZED: number = 0x1 << 8;
const HAS_DATA: number = 0x1 << 4;
const SELECT: number = 0x1;

/**
 * 定义：宫格操作状态机-状态类型
 */
export enum OperateStateType {
  /**
   * 初始态
   */
  INIT_STATE = 0,

  /**
   * 无数据态
   */
  NO_DATA_STATE = INITIALIZED,

  /**
   * 浏览态
   */
  BROWSE_STATE = INITIALIZED | HAS_DATA,

  /**
   * 多选态
   */
  SELECT_STATE = INITIALIZED | HAS_DATA | SELECT,
}

/**
 * 宫格操作状态类型工具类
 */
export class OperateStateTypeUtils {
  private constructor() {
  }

  /**
   * 是否处于初始态（以此可以判断数据是否加载完成）
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInitState(stateType: OperateStateType): boolean {
    return stateType === OperateStateType.INIT_STATE;
  }

  /**
   * 是否处于无数据状态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInNotDataState(stateType: OperateStateType): boolean {
    return stateType === OperateStateType.NO_DATA_STATE;
  }

  /**
   * 是否处于有数据状态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInHasDataState(stateType: OperateStateType): boolean {
    return (stateType & HAS_DATA) === HAS_DATA;
  }

  /**
   * 是否处于宫格浏览态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInGridBrowseState(stateType: OperateStateType): boolean {
    return stateType === OperateStateType.BROWSE_STATE;
  }

  /**
   * 是否处于多选状态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInSelectState(stateType: OperateStateType): boolean {
    return stateType === OperateStateType.SELECT_STATE;
  }
}

/**
 * 定义：宫格操作状态机-事件类型
 */
export enum OperateEventType {
  /**
   * 无意义事件，用于创建默认事件，状态机可不处理
   */
  NONE,

  /**
   * 数据加载（包括：1、从无数据状态迁移到有数据状态）
   */
  DATA_LOADED,

  /**
   * 数据清空（包括：1、有数据状态进入无数据状态）
   */
  DATA_CLEAR,

  /**
   * 切换到宫格浏览态（包括：1、）
   */
  ENTER_BROWSER,

  /**
   * 切换到多选态（包括：1、点击多选 2、悬浮操作态场景下多选）
   */
  ENTER_SELECT,
}

/**
 * 宫格操作状态机事件
 */
export class OperateEvent extends AbstractEvent<OperateEventType> {
  public override toString(): string {
    return OperateEventType[this.eventType] ?? 'Unknown_OperateEvent';
  }
}

/**
 * 抽象宫格操作状态
 */
abstract class AbstractOperateState extends AbstractState<OperateStateType, OperateEventType> {
  public override toString(): string {
    return OperateStateType[this.stateType] ?? 'Unknown_OperateState';
  }
}

/**
 * 初始态
 */
class InitState extends AbstractOperateState {
  public override handleEvent(eventType: OperateEventType): OperateStateType {
    switch (eventType) {
      case OperateEventType.DATA_CLEAR:
        return OperateStateType.NO_DATA_STATE;
      case OperateEventType.DATA_LOADED:
        return OperateStateType.BROWSE_STATE;
    }
    return this.stateType;
  }
}

/**
 * 无数据状态
 */
class NoDataState extends AbstractOperateState {
  public override handleEvent(eventType: OperateEventType): OperateStateType {
    switch (eventType) {
      case OperateEventType.DATA_LOADED:
        return OperateStateType.BROWSE_STATE;
    }
    return this.stateType;
  }
}

/**
 * 浏览态
 */
class BrowserState extends AbstractOperateState {
  public override handleEvent(eventType: OperateEventType): OperateStateType {
    switch (eventType) {
      case OperateEventType.DATA_CLEAR:
        return OperateStateType.NO_DATA_STATE;
      case OperateEventType.ENTER_SELECT:
        return OperateStateType.SELECT_STATE;
    }
    return this.stateType;
  }
}

/**
 * 多选态
 */
class SelectState extends AbstractOperateState {
  public override handleEvent(eventType: OperateEventType): OperateStateType {
    switch (eventType) {
      case OperateEventType.DATA_CLEAR:
        return OperateStateType.NO_DATA_STATE;
      case OperateEventType.ENTER_BROWSER:
        return OperateStateType.BROWSE_STATE;
    }
    return this.stateType;
  }
}

/**
 * 宫格状态工厂
 */
class GridOperateStateFactory extends AbstractStateFactory<OperateStateType, OperateEventType> {
  public constructor() {
    super();
    this.addStateConstructor(OperateStateType.INIT_STATE, InitState);
    this.addStateConstructor(OperateStateType.NO_DATA_STATE, NoDataState);
    this.addStateConstructor(OperateStateType.BROWSE_STATE, BrowserState);
    this.addStateConstructor(OperateStateType.SELECT_STATE, SelectState);
  }
}

/**
 * 宫格操作状态机
 */
export class GridOperateFsm extends AbstractFsm<OperateStateType, OperateEvent, OperateEventType> {
  // 是否支持默认在多选态（PC支持）
  private isSupportDefaultSelect: boolean = false;

  public constructor(persistentId: number) {
    super(persistentId, new GridOperateStateFactory(), OperateStateType.INIT_STATE,
      () => new OperateEvent(OperateEventType.NONE));
  }

  /**
   * 更新是否支持默认在多选态
   *
   * @param isSupportDefaultSelect 是否支持默认在多选态
   */
  public updateIsSupportDefaultSelect(isSupportDefaultSelect: boolean): void {
    this.isSupportDefaultSelect = isSupportDefaultSelect;
  }

  protected override getNextState(rawNewState: OperateStateType): AbstractState<OperateStateType, OperateEventType> {
    if (rawNewState === OperateStateType.BROWSE_STATE && this.isSupportDefaultSelect) {
      return super.getNextState(OperateStateType.SELECT_STATE);
    }
    return super.getNextState(rawNewState);
  }
}