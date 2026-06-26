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

import lazy { AttributeStateManager } from '@ohos/common/src/main/ets/default/model/AttributeStateManager';
import lazy {
  ConfigListenerObserverProxy
} from '@ohos/common/src/main/ets/default/model/ConfigObserverProxy';
import lazy { ConfigStateManager } from '@ohos/common/src/main/ets/default/model/ConfigStateManager';
import lazy { StateChangeCallback } from '@ohos/common/src/main/ets/default/model/StateObserverManager';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { AnimationScale } from '../viewcontroller/animation/AnimationDefine';
import lazy { SwitchStartInfo } from './common/SwitchStartInfo';
import lazy { IPinchConfig, IPinchVariableConfig, PinchConfig } from './config/PinchConfig';
import lazy { FORM_SIZE, FormIndex } from './constants/GridDefine';
import lazy { PINCH_SPEED_THRESHOLD, PinchAction } from './constants/PinchDefine';
import lazy { SwitchDirection } from './constants/SwitchDefine';
import lazy { GridFormFsm } from './GridFormFsm';

const DEFAULT_SCALE: number = 1.0;

/**
 * 捏合状态更新参数
 */
export class PinchStateUpdateParams {
  /**
   * 捏合动作
   */
  public pinchAction: PinchAction = PinchAction.NONE;

  /**
   * 捏合事件
   */
  public pinchEvent?: GestureEvent;

  /**
   * 切换开始信息
   */
  public pinchStartInfo?: SwitchStartInfo;

  /**
   * 即将到达的形态索引
   */
  public willArriveForm?: FormIndex;

  /**
   * 捏合方向
   */
  public pinchDirection?: SwitchDirection;

  /**
   * 目标形态
   */
  public targetForm?: FormIndex;
}

/**
 * 捏合事件监听
 */
export interface PinchEventListener {
  /**
   * 捏合状态变化
   *
   * @param pinchState 捏合状态
   */
  onPinchStateChange?: (pinchState: PinchAction) => void;

  /**
   * 形态即将达到
   *
   * @param formIndex 即将到达的形态
   * @param direction 捏合方向
   */
  onPinchWillArrive?: (formIndex: FormIndex, direction?: SwitchDirection) => void;

  /**
   * 捏合动效结束通知
   *
   * @param formIndex 动效层级
   */
  onPinchEndAnimation?: (formIndex: FormIndex) => void;

  /**
   * 形态切换前动作
   *
   * @param targetForm 目标形态
   */
  onPreFromSwitch?: (targetForm: FormIndex) => void;
}

/**
 * 捏合观察者代理
 */
export class PinchObserverProxy
  extends ConfigListenerObserverProxy<PinchStateManager, PinchConfig, PinchEventListener> {
  public constructor(getProxyFunc: (persistentId: number) => PinchStateManager) {
    super(getProxyFunc, 'GRID_SWITCH_PinchObserverProxy');
  }

  /**
   * 获取捏合开始信息
   *
   * @returns 捏合开始信息
   */
  public get switchStartInfo(): SwitchStartInfo | undefined {
    return this.proxy.switchStartInfo;
  }

  /**
   * 获取捏合速度阈值
   *
   * @returns 捏合速度阈值
   */
  public get pinchSpeedThreshold(): number {
    return this.proxy.pinchSpeedThreshold;
  }

  /**
   * 查询宫格捏合放缩系数
   *
   * @param gridForm 宫格形态索引
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getGridPinchScale(gridForm: FormIndex, callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.getScaleManager(gridForm), callback);
  }
}

/**
 * 捏合状态管理器
 */
export class PinchStateManager
  extends ConfigStateManager<PinchConfig, IPinchConfig, IPinchVariableConfig, PinchEventListener> {
  public override readonly config: PinchConfig = new PinchConfig();

  /**
   * 宫格捏合放缩系数管理器列表
   */
  private readonly _pinchScaleManagers: AttributeStateManager<number>[] = [];

  // 捏合标准系数
  private readonly _pinchStandardScales: number[] = new Array(FORM_SIZE).fill(DEFAULT_SCALE);

  // 捏合放缩系数
  private _pinchScale: number = DEFAULT_SCALE;

  // 捏合开始信息
  private _switchStartInfo?: SwitchStartInfo;

  // 捏合速度阈值
  private _pinchSpeedThreshold: number = PINCH_SPEED_THRESHOLD;

  // 宫格形态状态机
  private readonly formFsm: GridFormFsm;

  public constructor(persistentId: number, formFsm: GridFormFsm) {
    super(persistentId, 'GRID_SWITCH_PinchStateManager');
    this.formFsm = formFsm;

    for (let formIndex = 0; formIndex < FORM_SIZE; formIndex++) {
      this._pinchScaleManagers.push(
        new AttributeStateManager(persistentId, DEFAULT_SCALE, `${FormIndex[formIndex]}Scale`, false));
    }
  }

  /**
   * 获取捏合开始信息
   *
   * @returns 捏合开始信息
   */
  public get switchStartInfo(): SwitchStartInfo | undefined {
    return this._switchStartInfo;
  }

  /**
   * 获取捏合速度阈值
   *
   * @returns 捏合速度阈值
   */
  public get pinchSpeedThreshold(): number {
    return this._pinchSpeedThreshold;
  }

  /**
   * 获取放缩系数管理器
   *
   * @param formIndex 形态索引
   * @returns 放缩系数管理器
   */
  public getScaleManager(formIndex: FormIndex): AttributeStateManager<number> {
    return this._pinchScaleManagers[formIndex];
  }

  /**
   * 更新捏合状态
   *
   * @param updateParams 更新参数
   */
  public updatePinchState(updateParams: PinchStateUpdateParams): void {
    // 初始化事件
    if (updateParams.pinchAction === PinchAction.START) {
      this._switchStartInfo = updateParams.pinchStartInfo;
      this.updatePinchScales(DEFAULT_SCALE, `Pinch_${PinchAction[updateParams.pinchAction]}`);
    } else {
      // 更新缩放系数
      if (!!updateParams?.pinchEvent) {
        this.updatePinchScales(updateParams.pinchEvent.scale, `Pinch_${PinchAction[updateParams.pinchAction]}`);
      }

      // 广播即将到达形态
      if (updateParams?.willArriveForm !== undefined) {
        let targetForm = updateParams?.willArriveForm;
        this.callbackObservers(observer => observer?.onPinchWillArrive?.(targetForm, updateParams.pinchDirection));
      }
    }

    // 更新状态，触发子页面写入捏合初始信息（例如：锚点项对应的索引）
    if (updateParams.targetForm !== undefined && updateParams.targetForm !== this.formFsm.getCurrentForm()) {
      this.callbackObservers(observer => observer?.onPreFromSwitch?.(updateParams.targetForm as FormIndex));
    }
    this.callbackObservers(observer => observer?.onPinchStateChange?.(updateParams.pinchAction));
  }

  /**
   * 清空切换开始信息，切换完成后清除
   */
  public clearStartInfo(): void {
    this._switchStartInfo = undefined;
  }

  /**
   * 更新标准放缩系数
   *
   * @param standardScales 标准放缩系数
   * @param reason 更新原因
   */
  public updateStandardScales(standardScales: number[], reason?: string): void {
    if (!standardScales || standardScales.length !== FORM_SIZE) {
      LogUtils.warn(this.tag, 'updateStandardScales invalid standardScales.');
      return;
    }
    for (let formIndex = 0; formIndex < FORM_SIZE; formIndex++) {
      if (standardScales[formIndex] <= 0) {
        LogUtils.warn(this.tag, `updateStandardScales invalid index: ${formIndex} - ${standardScales[formIndex]}.`);
        continue;
      }
      this._pinchStandardScales[formIndex] = standardScales[formIndex];
    }
    this.updatePinchScales(this._pinchScale, reason);
  }

  /**
   * 通知捏合动效结束
   *
   * @param formIndex 动效发生层级
   */
  public notifyAnimationFinished(formIndex: FormIndex): void {
    this.callbackObservers(observer => observer?.onPinchEndAnimation?.(formIndex));
  }

  public override updateStateFromVariableConfig(config?: IPinchVariableConfig, reason?: string): void {
    // 更新捏合阈值
    if (config?.pinchSpeedThreshold !== undefined) {
      this.updatePinchSpeedThreshold(config.pinchSpeedThreshold, reason);
    }
  }

  protected override updateStateFromInitConfig(config: PinchConfig, reason?: string): void {
    // 更新可变部分
    this.updateStateFromVariableConfig(config, reason);
  }

  private updatePinchScales(scale: number, reason?: string): void {
    this._pinchScale = Math.max(this._pinchStandardScales[0] * AnimationScale.MIN_SCALE,
      Math.min(this._pinchStandardScales[FORM_SIZE - 1] * AnimationScale.MAX_SCALE, scale));
    for (let formIndex = 0; formIndex < FORM_SIZE; formIndex++) {
      this.getScaleManager(formIndex).updateState(this._pinchScale / this._pinchStandardScales[formIndex], reason);
    }
  }

  private updatePinchSpeedThreshold(pinchSpeedThreshold: number, reason?: string): void {
    if (this._pinchSpeedThreshold !== pinchSpeedThreshold && pinchSpeedThreshold > 0) {
      LogUtils.info(this.tag, `updatePinchSpeedThreshold: ${pinchSpeedThreshold}, reason: ${reason}`);
      this._pinchSpeedThreshold = pinchSpeedThreshold;
    }
  }
}