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
 * 恢复占位状态机-状态类型
 */
export enum RestoreFpStateType {
  /**
   * 初始态
   */
  INIT_STATE = 0,

  /**
   * 空闲态
   */
  IDLE_STATE,

  /**
   * 占位态
   */
  FILL_POSITION_STATE,

  /**
   * 动效准备态
   */
  ANIMATION_PREPARE_STATE,

  /**
   * 动效准备完成态
   */
  ANIMATION_READY_STATE,
}

/**
 * 恢复占位状态机-事件类型
 */
export enum RestoreFpEventType {
  /**
   * 无意义事件，用于创建默认事件，状态机可不处理
   */
  NONE = 0,

  /**
   * 发生占位（包括：1、占位从0到非0）
   */
  FILL_POSTION,

  /**
   * 取消占位（包括：1、占位从非0到0）
   */
  CANCEL_FILL_POSTION,

  /**
   * 发起动效（包括：1、退出沉浸态 2、切换完成）
   */
  START_ANIMATION,

  /**
   * 取消动效（包括：1、进入沉浸态 2、进入切换中 3、退出当前状态）
   */
  CANCEL_ANIMATION,

  /**
   * 动效准备完成，包括（1、截图完成）
   */
  ANIMATION_PREPARE_COMPLETE,

  /**
   * 动效执行完成，包括（1、占位动效执行完成）
   */
  ANIMATION_COMPLETE,
}

/**
 * 恢复占位状态机-事件
 */
export class RestoreFpEvent extends AbstractEvent<RestoreFpEventType> {
  public override toString(): string {
    return RestoreFpEventType[this.eventType] ?? `Unknown_RestoreFpEvent(${this.eventType})`;
  }
}

/**
 * 恢复占位状态机-状态
 */
abstract class AbstractRestoreFpState extends AbstractState<RestoreFpStateType, RestoreFpEventType> {
  public override toString(): string {
    return RestoreFpStateType[this.stateType] ?? `Unknown_RestoreFpState(${this.stateType})`;
  }

  public override handleEvent(eventType: RestoreFpEventType): RestoreFpStateType {
    switch (eventType) {
      case RestoreFpEventType.FILL_POSTION:
        return RestoreFpStateType.FILL_POSITION_STATE;
    }
    return this.stateType;
  }
}

/**
 * 初始态
 */
class InitState extends AbstractRestoreFpState {
  public override handleEvent(eventType: RestoreFpEventType): RestoreFpStateType {
    switch (eventType) {
      case RestoreFpEventType.CANCEL_FILL_POSTION:
        return RestoreFpStateType.IDLE_STATE;
    }
    return super.handleEvent(eventType);
  }
}

/**
 * 空闲态
 */
class IdleState extends AbstractRestoreFpState {
}

/**
 * 占位态
 */
class FillPositionState extends AbstractRestoreFpState {
  public override handleEvent(eventType: RestoreFpEventType): RestoreFpStateType {
    switch (eventType) {
      case RestoreFpEventType.CANCEL_FILL_POSTION:
        return RestoreFpStateType.IDLE_STATE;
      case RestoreFpEventType.START_ANIMATION:
        return RestoreFpStateType.ANIMATION_PREPARE_STATE;
    }
    return super.handleEvent(eventType);
  }
}

/**
 * 抽象动效态
 */
abstract class AbstractAnimationState extends AbstractRestoreFpState {
  public override handleEvent(eventType: RestoreFpEventType): RestoreFpStateType {
    switch (eventType) {
      case RestoreFpEventType.CANCEL_ANIMATION:
        return RestoreFpStateType.FILL_POSITION_STATE;
      case RestoreFpEventType.ANIMATION_COMPLETE:
        return RestoreFpStateType.IDLE_STATE;
    }
    return super.handleEvent(eventType);
  }
}

/**
 * 动效准备态
 */
class AnimationPrepareState extends AbstractAnimationState {
  public override handleEvent(eventType: RestoreFpEventType): RestoreFpStateType {
    switch (eventType) {
      case RestoreFpEventType.ANIMATION_PREPARE_COMPLETE:
        return RestoreFpStateType.ANIMATION_READY_STATE;
    }
    return super.handleEvent(eventType);
  }
}

/**
 * 动效准备完成态
 */
class AnimationReadyState extends AbstractAnimationState {
}

/**
 * 动效准备完成态
 */
class RestoreFpStateFactory extends AbstractStateFactory<RestoreFpStateType, RestoreFpEventType> {
  public constructor() {
    super();
    this.addStateConstructor(RestoreFpStateType.INIT_STATE, InitState);
    this.addStateConstructor(RestoreFpStateType.IDLE_STATE, IdleState);
    this.addStateConstructor(RestoreFpStateType.FILL_POSITION_STATE, FillPositionState);
    this.addStateConstructor(RestoreFpStateType.ANIMATION_PREPARE_STATE, AnimationPrepareState);
    this.addStateConstructor(RestoreFpStateType.ANIMATION_READY_STATE, AnimationReadyState);
  }
}

/**
 * 宫格恢复占位状态机
 */
export class RestoreFpFsm extends AbstractFsm<RestoreFpStateType, RestoreFpEvent, RestoreFpEventType> {
  /**
   * 此状态机相同状态依然回调
   */
  protected override _isSameStateCallback: boolean = true;

  public constructor(persistentId: number, tag?: string) {
    super(persistentId, new RestoreFpStateFactory(), RestoreFpStateType.INIT_STATE,
      () => new RestoreFpEvent(RestoreFpEventType.NONE), tag);
  }
}