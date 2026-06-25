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
import lazy { FlagUtils } from '@ohos/common/src/main/ets/default/utils/FlagUtils';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { FormIndex } from './constants/GridDefine';

const FORM_OFFSET: number = 3 * 4;
const DAY_FORM: number = 0x04 << FORM_OFFSET; // 日视图形态
const GROUP_DAY_FROM: number = 0x08 << FORM_OFFSET; // 日分组视图形态
const FORM_FLAG: number = 0xFF << FORM_OFFSET;

const FOLLOW_HAND_STATE_OFFSET: number = 2 * 4;
const FOLLOW_HAND = 0x1 << FOLLOW_HAND_STATE_OFFSET; // 跟手形态

/**
 * 宫格形态状态机-状态类型
 */
export enum FormStateType {
  /**
   * 初始态
   */
  INIT_STATE = 0,

  /**
   * 日视图态
   */
  DAY_STATE = DAY_FORM,

  /**
   * 日视图跟手态
   */
  DAY_FOLLOW_HAND_STATE = DAY_FORM | FOLLOW_HAND,

  /**
   * 日分组视图态
   */
  GROUP_DAY_STATE = GROUP_DAY_FROM,

  /**
   * 日分组跟手态
   */
  GROUP_DAY_FOLLOW_HAND_STATE = GROUP_DAY_FROM | FOLLOW_HAND,
}

/**
 * 宫格形态状态类型工具类
 */
export class FormStateTypeUtils {
  private constructor() {
  }

  /**
   * 是否处于有数据状态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isHasDataState(stateType: FormStateType): boolean {
    return stateType !== FormStateType.INIT_STATE;
  }

  /**
   * 是否处于给定形态的状态
   *
   * @param stateType 判断的状态
   * @param formIndex 给定形态
   * @returns true是/false否
   */
  public static isInFormState(stateType: FormStateType, formIndex: FormIndex): boolean {
    LogUtils.info("GridFormFsm","stateType: " + stateType + " formIndex: " + formIndex);
    if (formIndex < 0) {
      return stateType === FormStateType.INIT_STATE;
    }
    return (stateType & FORM_FLAG) === (0x1 << (formIndex + FORM_OFFSET));
  }

  /**
   * 是否处于日视图态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInDayState(stateType: FormStateType): boolean {
    return (stateType & DAY_FORM) === DAY_FORM;
  }

  /**
   * 是否处于日分组视图态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInGroupDayState(stateType: FormStateType): boolean {
    return (stateType & GROUP_DAY_FROM) === GROUP_DAY_FROM;
  }

  /**
   * 是否处于跟手态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInFollowHandState(stateType: FormStateType): boolean {
    return (stateType & FOLLOW_HAND) === FOLLOW_HAND;
  }

  /**
   * 两位相比是否为更大的形态
   *
   * @param first 第一个状态类型
   * @param second 第二个状态类型
   * @returns true是/false否
   */
  public static isLargerFrom(first: FormStateType, second: FormStateType): boolean {
    return (first & FORM_FLAG) > (second & FORM_FLAG);
  }

  /**
   * 根据状态类型获取形态索引
   *
   * @param stateType 状态类型
   * @param withoutGroup 忽略分组形态
   * @returns 形态索引
   */
  public static getFormFromStateType(stateType: FormStateType, withoutGroup: boolean = false): FormIndex {
    switch (stateType & FORM_FLAG) {
      // 高频放前面
      case DAY_FORM:
        return FormIndex.DAY;
      case GROUP_DAY_FROM:
        return withoutGroup ? FormIndex.DAY : FormIndex.GROUP_DAY;
      default:
        return FormIndex.INVALID;
    }
  }

  /**
   * 根据形态索引获取状态类型
   *
   * @param formIndex 形态索引
   * @param isFollowHand 是否跟手
   * @returns 状态类型
   */
  public static getStateTypeFromForm(formIndex: FormIndex, isFollowHand: boolean = false): FormStateType {
    if (formIndex < 0) {
      return FormStateType.INIT_STATE;
    }
    return (0x1 << (formIndex + FORM_OFFSET)) | (isFollowHand ? FOLLOW_HAND : 0);
  }
}

const EVENT_TYPE_OFFSET: number = 5 * 4;
const SWITCH_EVENT: number = 0x1 << EVENT_TYPE_OFFSET;
const PINCH_EVENT: number = 0x2 << EVENT_TYPE_OFFSET;

const EVENT_TARGET_OFFSET: number = 4 * 4;

const FOLLOW_HAND_EVENT_OFFSET: number = 3 * 4;
const TO_FOLLOW_HAND_EVENT: number = 0x1 << FOLLOW_HAND_EVENT_OFFSET;

const QUICK_OFFSET: number = 2 * 4;
const QUICK_PINCH_EVENT: number = 0x1 << QUICK_OFFSET;

/**
 * 宫格形态状态机-事件类型
 */
export enum FormEventType {
  /**
   * 无意义事件，用于创建默认事件，状态机可不处理
   */
  NONE = 0,

  /**
   * 数据加载（包括：1、从无数据状态迁移到有数据状态）
   */
  DATA_LOADED = 1,

  /**
   * 数据清空（包括：1、有数据状态进入无数据状态）
   */
  DATA_CLEAR = 2,


  /**
   * 双指捏合开始
   */
  PINCH_START = PINCH_EVENT | TO_FOLLOW_HAND_EVENT,

  /**
   * 捏合结束
   */
  PINCH_END = PINCH_EVENT,

  /**
   * 快速捏合结束
   */
  PINCH_END_QUICK = PINCH_EVENT | QUICK_PINCH_EVENT,
}

/**
 * 宫格形态事件类型工具类
 */
export class FormEventTypeUtils {
  private constructor() {
  }

  /**
   * 是否切换事件
   *
   * @param eventType 事件类型
   * @returns true是/false否
   */
  public static isSwitchEvent(eventType: FormEventType): boolean {
    return (eventType & SWITCH_EVENT) === SWITCH_EVENT;
  }

  /**
   * 是否捏合事件
   *
   * @param eventType 事件类型
   * @returns true是/false否
   */
  public static isPinchEvent(eventType: FormEventType): boolean {
    return (eventType & PINCH_EVENT) === PINCH_EVENT;
  }
  /**
   * 是否切换到跟手态事件
   *
   * @param eventType 事件类型
   * @returns true是/false否
   */
  public static isToFollowHandEvent(eventType: FormEventType): boolean {
    return (eventType & TO_FOLLOW_HAND_EVENT) === TO_FOLLOW_HAND_EVENT;
  }

  /**
   * 是否快速捏合事件
   *
   * @param eventType 事件类型
   * @returns true是/false否
   */
  public static isQuickPinchEvent(eventType: FormEventType): boolean {
    return (eventType & QUICK_PINCH_EVENT) === QUICK_PINCH_EVENT;
  }

  /**
   * 获取去掉捏合跟手位的事件类型
   *
   * @param eventType 事件类型
   * @param toFollowHand 是否去往跟手态
   * @param isQuickPinch 是否快速捏合
   * @returns 事件类型
   */
  public static getPinchEventType(eventType: FormEventType, toFollowHand: boolean = false,
    isQuickPinch: boolean = false): FormEventType {
    if (!FormEventTypeUtils.isPinchEvent(eventType)) {
      return eventType;
    }
    return FlagUtils.addOrRemoveFlag(FlagUtils.addOrRemoveFlag(eventType, TO_FOLLOW_HAND_EVENT, toFollowHand),
      QUICK_PINCH_EVENT, isQuickPinch);
  }

  /**
   * 从去往索引获取捏合事件类型
   *
   * @param formIndex 形态索引
   * @param toFollowHand 是否去往跟手态
   * @param isQuickPinch 是否快捏
   * @returns 事件类型
   */
  public static getPinchEventTypeFromForm(formIndex: FormIndex, toFollowHand: boolean = false,
    isQuickPinch: boolean = false): FormEventType {
    if (formIndex < 0) {
      return FormEventType.NONE;
    }
    return PINCH_EVENT | (0x1 << (formIndex + EVENT_TARGET_OFFSET)) | (toFollowHand ? TO_FOLLOW_HAND_EVENT : 0) |
      (isQuickPinch ? QUICK_PINCH_EVENT : 0);
  }

  /**
   * 从去往索引获取切换事件类型
   *
   * @param formIndex 形态索引
   * @returns 事件类型
   */
  public static getSwitchEventTypeFromForm(formIndex: FormIndex): FormEventType {
    if (formIndex < 0) {
      return FormEventType.NONE;
    }
    return SWITCH_EVENT | (0x1 << (formIndex + EVENT_TARGET_OFFSET));
  }
}

/**
 * 宫格形态状态机事件
 */
export class FormEvent extends AbstractEvent<FormEventType> {
  public override toString(): string {
    return FormEventType[this.eventType] ?? `Unknown_FormEvent(${this.eventType})`;
  }
}

/**
 * 抽象宫格形态状态
 */
abstract class AbstractFormState extends AbstractState<FormStateType, FormEventType> {
  public override toString(): string {
    return FormStateType[this.stateType] ?? 'Unknown_FormState';
  }
}

/**
 * 初始态
 */
class InitState extends AbstractFormState {
  public override handleEvent(eventType: FormEventType): FormStateType {
    switch (eventType) {
      case FormEventType.DATA_LOADED:
        return FormStateType.DAY_STATE;
    }
    return this.stateType;
  }
}

/**
 * 抽象有数据形态
 */
abstract class AbstractHasDataFormState extends AbstractFormState {
  public override handleEvent(eventType: FormEventType): FormStateType {
    switch (eventType) {
      case FormEventType.DATA_CLEAR:
        return FormStateType.INIT_STATE;
    }
    return this.stateType;
  }
}

/**
 * 抽象非跟手形态
 */
abstract class AbstractNotFollowHandState extends AbstractHasDataFormState {
  public override handleEvent(eventType: FormEventType): FormStateType {
    return super.handleEvent(eventType);
  }
}

/**
 * 抽象跟手形态
 */
abstract class AbstractFollowHandState extends AbstractHasDataFormState {
  public override handleEvent(eventType: FormEventType): FormStateType {
    let withoutFollowHandEventType = FormEventTypeUtils.getPinchEventType(eventType);
    let isToFollowHandEvent = FormEventTypeUtils.isToFollowHandEvent(eventType);
    return super.handleEvent(eventType);
  }
}

/**
 * 日视图态
 */
class DayState extends AbstractNotFollowHandState {
  public override handleEvent(eventType: FormEventType): FormStateType {
    switch (eventType) {
      case FormEventType.PINCH_START:
        return FormStateType.DAY_FOLLOW_HAND_STATE;
    }
    return super.handleEvent(eventType);
  }
}

/**
 * 日跟手态
 */
class DayFollowHandState extends AbstractFollowHandState {
  public override handleEvent(eventType: FormEventType): FormStateType {
    switch (eventType) {
      case FormEventType.PINCH_END:
      case FormEventType.PINCH_END_QUICK:
        return FormStateType.DAY_STATE;
    }
    return super.handleEvent(eventType);
  }
}

/**
 * 日视图分组态
 */
class GroupDayState extends AbstractNotFollowHandState {
  public override handleEvent(eventType: FormEventType): FormStateType {
    switch (eventType) {
      case FormEventType.PINCH_START:
        return FormStateType.GROUP_DAY_FOLLOW_HAND_STATE;
    }
    return super.handleEvent(eventType);
  }
}

/**
 * 日分组跟手态
 */
class GroupDayFollowHandState extends AbstractFollowHandState {
  public override handleEvent(eventType: FormEventType): FormStateType {
    switch (eventType) {
      case FormEventType.PINCH_END:
      case FormEventType.PINCH_END_QUICK:
        return FormStateType.GROUP_DAY_STATE;
    }
    return super.handleEvent(eventType);
  }
}

/**
 * 宫格状态工厂
 */
class FormStateFactory extends AbstractStateFactory<FormStateType, FormEventType> {
  public constructor() {
    super();
    this.addStateConstructor(FormStateType.INIT_STATE, InitState);
    this.addStateConstructor(FormStateType.DAY_STATE, DayState);
    this.addStateConstructor(FormStateType.DAY_FOLLOW_HAND_STATE, DayFollowHandState);
    this.addStateConstructor(FormStateType.GROUP_DAY_STATE, GroupDayState);
    this.addStateConstructor(FormStateType.GROUP_DAY_FOLLOW_HAND_STATE, GroupDayFollowHandState);
  }
}

/**
 * 宫格显示形态状态机
 */
export class GridFormFsm extends AbstractFsm<FormStateType, FormEvent, FormEventType> {
  protected _postCallback = (_oldState: FormStateType, newState: FormStateType): void => {
    if (FormStateTypeUtils.isInDayState(newState)) {
      this._isLastFormIsDayGroup = false;
    } else if (FormStateTypeUtils.isInGroupDayState(newState)) {
      this._isLastFormIsDayGroup = true;
    }
    if (this.getCurrentForm() >= 0) {
      this._lastValidForm = this.getCurrentForm();
    }
  };
  /**
   * 标记日视图最后形态是否为分组形态
   */
  private _isLastFormIsDayGroup?: boolean;

  /**
   * 记录最后的有效宫格形态
   */
  private _lastValidForm?: FormIndex;

  public constructor(persistentId: number) {
    super(persistentId, new FormStateFactory(), FormStateType.INIT_STATE, () => new FormEvent(FormEventType.NONE));
  }

  /**
   * 初始化最后的日视图是否为日分组形态
   *
   * @param isLastFormIsDayGroup 日视图是否分组形态
   */
  public initIsLastFormIsDayGroup(isLastFormIsDayGroup: boolean): void {
    if (this._isLastFormIsDayGroup === undefined) {
      LogUtils.info(this.tag, `initIsLastFormIsDayGroup: ${isLastFormIsDayGroup}`);
      this._isLastFormIsDayGroup = isLastFormIsDayGroup;
    }
  }

  /**
   * 调整最后的日视图是否为日分组形态
   * @param isLastFormIsDayGroup
   */
  public changeIsLastFormIsDayGroup(isLastFormIsDayGroup: boolean): void {
    LogUtils.info(this.tag, `changeIsLastFormIsDayGroup: ${isLastFormIsDayGroup}`);
    this._isLastFormIsDayGroup = isLastFormIsDayGroup;
  }

  /**
   * 获取当前形态索引
   *
   * @returns 形态索引
   */
  public getCurrentForm(): FormIndex {
    LogUtils.info(this.tag, `this.currentState: ${this.currentState}`);
    return FormStateTypeUtils.getFormFromStateType(this.currentState);
  }

  /**
   * 最后的日形态是否日分组
   *
   * @returns true是/false否
   */
  public isLastDayFormIsDayGroup(): boolean {
    return this._isLastFormIsDayGroup ?? false;
  }

  /**
   * 获取最后的有效宫格形态
   *
   * @returns 最后的有效宫格形态
   */
  public getLastValidForm(): FormIndex | undefined {
    return this._lastValidForm;
  }

  protected override getNextState(rawNewState: FormStateType): AbstractState<FormStateType, FormEventType> {
    if (this._isLastFormIsDayGroup && this.isSwitchToDay(rawNewState)) {
      return this.getNextState(FormStateType.GROUP_DAY_STATE);
    }
    return super.getNextState(rawNewState);
  }

  private isSwitchToDay(rawNewState: FormStateType): boolean {
    // 切换到日形态判断，此时需要判断是否切换至日分组
    if (rawNewState !== FormStateType.DAY_STATE) {
      return false;
    } else {
      return (this._currentEventType === FormEventType.DATA_LOADED && this.currentState === FormStateType.INIT_STATE);
    }
  }
}