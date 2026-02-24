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
const SHOW: number = 0x1 << 4;
const SURE: number = 0x1;

/**
 * 宫格显示状态机-状态类型
 */
export enum GridShowStateType {
  /**
   * 初始态
   */
  INIT_STATE = 0,

  /**
   * 隐藏态
   */
  HIDE_STATE = INITIALIZED,

  /**
   * 即将显示态
   */
  WILL_SHOW_STATE = INITIALIZED | SHOW,

  /**
   * 显示态
   */
  SHOW_STATE = INITIALIZED | SHOW | SURE,
}

/**
 * 宫格显示状态类型工具类
 */
export class GridShowStateTypeUtils {
  private constructor() {
  }

  /**
   * 是否处于显示状态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isShowState(stateType: GridShowStateType): boolean {
    return (stateType & SHOW) === SHOW;
  }
}

/**
 * 宫格形态状态机-事件类型
 */
export enum GridShowEventType {
  /**
   * 无意义事件，用于创建默认事件，状态机可不处理
   */
  NONE = 0,

  /**
   * 直接隐藏（包括：1、数据清空 2、初始化时不在本层状态）
   */
  DIRECTION_HIDE,

  /**
   * 直接显示（包括：1、本层状态到达）
   */
  DIRECTION_SHOW,

  /**
   * 其他层级显示动效结束（包括：1、其他层级切换动效结束且不处于滑动保持显示中 2、其他层级捏合离手动效结束）
   */
  OTHER_END_ANIMATION,

  /**
   * 其他层级显示动效结束并保持显示（包括：1、其他层级切换动效结束且处于保持显示状态）
   */
  OTHER_KEEP_SHOW_END_ANIMATION,

  /**
   * 即将显示，包括（1、捏合动效即将显示 2、切换动效即将显示）
   */
  WILL_SHOW,

  /**
   * 取消滑动保持显示（注：滑动保持显示，即SegmentButton按下未抬起时，此时避免视图反复上下树，估先不下树）
   * 包括（1、SegmentButton按下时）
   */
  CANCEL_KEEP_SHOW,
}

/**
 * 宫格显示状态机事件
 */
export class GridShowEvent extends AbstractEvent<GridShowEventType> {
  public override toString(): string {
    return GridShowEventType[this.eventType] ?? `Unknown_GridShowEvent(${this.eventType})`;
  }
}

/**
 * 抽象宫格形态状态
 */
abstract class AbstractGridShowState extends AbstractState<GridShowStateType, GridShowEventType> {
  public override toString(): string {
    return GridShowStateType[this.stateType] ?? 'Unknown_GridShowState';
  }

  public override handleEvent(eventType: GridShowEventType): GridShowStateType {
    switch (eventType) {
      case GridShowEventType.DIRECTION_HIDE:
        return GridShowStateType.HIDE_STATE;
      case GridShowEventType.DIRECTION_SHOW:
        return GridShowStateType.SHOW_STATE;
    }
    return this.stateType;
  }
}

/**
 * 初始态
 */
class InitState extends AbstractGridShowState {
}

/**
 * 隐藏态
 */
class HideState extends AbstractGridShowState {
  public override handleEvent(eventType: GridShowEventType): GridShowStateType {
    switch (eventType) {
      case GridShowEventType.WILL_SHOW:
        return GridShowStateType.WILL_SHOW_STATE;
    }
    return super.handleEvent(eventType);
  }
}

/**
 * 即将显示态
 */
class WillShowState extends AbstractGridShowState {
  public override handleEvent(eventType: GridShowEventType): GridShowStateType {
    switch (eventType) {
      case GridShowEventType.CANCEL_KEEP_SHOW:
      case GridShowEventType.OTHER_END_ANIMATION:
        return GridShowStateType.HIDE_STATE;
    }
    return super.handleEvent(eventType);
  }
}

/**
 * 显示态
 */
class ShowState extends AbstractGridShowState {
  public override handleEvent(eventType: GridShowEventType): GridShowStateType {
    switch (eventType) {
      case GridShowEventType.OTHER_END_ANIMATION:
        return GridShowStateType.HIDE_STATE;
      case GridShowEventType.OTHER_KEEP_SHOW_END_ANIMATION:
        return GridShowStateType.WILL_SHOW_STATE;
    }
    return super.handleEvent(eventType);
  }
}

/**
 * 宫格显示状态工厂
 */
class GridShowStateFactory extends AbstractStateFactory<GridShowStateType, GridShowEventType> {
  public constructor() {
    super();
    this.addStateConstructor(GridShowStateType.INIT_STATE, InitState);
    this.addStateConstructor(GridShowStateType.HIDE_STATE, HideState);
    this.addStateConstructor(GridShowStateType.WILL_SHOW_STATE, WillShowState);
    this.addStateConstructor(GridShowStateType.SHOW_STATE, ShowState);
  }
}

/**
 * 宫格显示形态状态机
 */
export class GridShowFsm extends AbstractFsm<GridShowStateType, GridShowEvent, GridShowEventType> {
  public constructor(persistentId: number, tag?: string) {
    super(persistentId, new GridShowStateFactory(), GridShowStateType.HIDE_STATE,
      () => new GridShowEvent(GridShowEventType.NONE), tag);
  }
}