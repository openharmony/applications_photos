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
import lazy { SwitchStartInfo } from './common/SwitchStartInfo';
import lazy { ISwitchConfig, ISwitchVariableConfig, SwitchConfig } from './config/SwitchConfig';
import lazy { FormIndex } from './constants/GridDefine';
import lazy { SwitchDirection, SwitchMode, SwitchShowUpdateReason } from './constants/SwitchDefine';
import lazy { GridFormFsm } from './GridFormFsm';

/**
 * 切换状态更新参数
 */
export class SwitchStateUpdateParams {
  /**
   * 目标形态
   */
  public targetForm: FormIndex = FormIndex.INVALID;

  /**
   * 切换起始信息
   */
  public switchStartInfo?: SwitchStartInfo;

  /**
   * 当前形态(点击场景需要用于计算锚点)
   */
  public currentForm?: FormIndex;

  /**
   * 切换方向
   */
  public switchDirection?: SwitchDirection;

  /**
   * 切换起始点X轴坐标
   */
  public startX?: number;

  /**
   * 切换起始点Y轴坐标
   */
  public startY?: number;
}

/**
 * 切换事件监听
 */
export interface SwitchEventListener {
  /**
   * 切换状态变化
   *
   * @param switchAction 切换状态
   * @param switchDirection 切换方向
   */
  onSwitchWillArrive?: (formIndex: FormIndex, switchDirection?: SwitchDirection) => void;

  /**
   * 切换动效结束通知
   *
   * @param formIndex 动效层级
   */
  onSwitchEndAnimation?: (formIndex: FormIndex) => void;

  /**
   * 形态切换前动作
   *
   * @param targetForm 目标形态
   */
  onPreFromSwitch?: (targetForm: FormIndex) => void;
}

/**
 * 切换观察者代理
 */
export class SwitchObserverProxy
  extends ConfigListenerObserverProxy<SwitchStateManager, SwitchConfig, SwitchEventListener> {
  public constructor(getProxyFunc: (persistentId: number) => SwitchStateManager) {
    super(getProxyFunc, 'GRID_SWITCH_SwitchObserverProxy');
  }

  /**
   * 获取切换开始信息
   *
   * @returns 切换开始信息
   */
  public get switchStartInfo(): SwitchStartInfo | undefined {
    return this.proxy.switchStartInfo;
  }

  /**
   * 获取日分组导航是否开启状态
   *
   * @returns 切换开始信息
   */
  public getGroupDayGuideOpenState(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.groupDayGuideOpenAsm, callback);
  }

  /**
   * 查询切换组件模式
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getSwitchMode(callback?: StateChangeCallback<SwitchMode>): SwitchMode {
    return this.getState<SwitchMode>(this.proxy.switchModeAsm, callback);
  }

  /**
   * 查询切换组件是否在触摸中
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getSwitchIsTouched(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.switchIsTouchedAsm, callback);
  }

  /**
   * 查询切换组件是否隐藏到底部
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getSwitchIsHidToBottom(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.switchHidToBottomAsm, callback);
  }

  /**
   * 获取是否需要更新切换向导状态
   *
   * @param callback 更新回调
   * @returns 当前视图Index
   */
  public getIsUpdateGuideState(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.isUpdateGuideStateAsm, callback);
  }

  /**
   * 获取是否显示提醒气泡
   *
   * @returns 是否显示气泡
   */
  public getDayGuideState(callback?: StateChangeCallback<boolean>): boolean {
    return this.getState<boolean>(this.proxy.isDayGuideShowAsm, callback);
  }
}

/**
 * 切换状态管理器
 */
export class SwitchStateManager
  extends ConfigStateManager<SwitchConfig, ISwitchConfig, ISwitchVariableConfig, SwitchEventListener> {
  public override readonly config: SwitchConfig = new SwitchConfig();

  /**
   * 日分组导航状态（是否导航中）
   */
  public readonly groupDayGuideOpenAsm: AttributeStateManager<boolean>;

  /**
   * 切换组件模式状态
   */
  public readonly switchModeAsm: AttributeStateManager<SwitchMode>;

  /**
   * 切换组件是否被按压状态（是否在按压中）
   */
  public readonly switchIsTouchedAsm: AttributeStateManager<boolean>;

  /**
   * 切换组件是否隐藏到底部
   */
  public readonly switchHidToBottomAsm: AttributeStateManager<boolean>;

  /**
   * 是否更新切换向导状态
   */
  public readonly isUpdateGuideStateAsm: AttributeStateManager<boolean>;

  /**
   * 是否显示提醒气泡
   */
  public readonly isDayGuideShowAsm: AttributeStateManager<boolean>;

  // 宫格形态状态机
  private readonly _formFsm: GridFormFsm;

  // 开始信息
  private _switchStartInfo?: SwitchStartInfo;

  public constructor(persistentId: number, formFsm: GridFormFsm) {
    super(persistentId, 'GRID_SWITCH_SwitchStateManager');

    this._formFsm = formFsm;
    this.groupDayGuideOpenAsm = new AttributeStateManager(persistentId, false, 'GroupDayGuideOpen');
    this.switchModeAsm = new AttributeStateManager(persistentId, SwitchMode.NORMAL, 'SwitchMode');
    this.switchIsTouchedAsm = new AttributeStateManager(persistentId, false, 'SwitchIsTouched');
    this.switchHidToBottomAsm = new AttributeStateManager(persistentId, false, 'SwitchHidToBottom');
    this.isUpdateGuideStateAsm = new AttributeStateManager(persistentId, false, 'isUpdateGuideState');
    this.isDayGuideShowAsm = new AttributeStateManager(persistentId, false, 'isDayGuideShow');
  }

  /**
   * 获取切换开始信息
   *
   * @returns 切换开始信息
   */
  public get switchStartInfo(): SwitchStartInfo | undefined {
    return this._switchStartInfo;
  }

  /**
   * 更新切换状态
   *
   * @param switchEvent 切换事件
   */
  public updateSwitchState(switchParams: SwitchStateUpdateParams): void {
    this._switchStartInfo = switchParams.switchStartInfo;

    // 更新状态，触发子页面写入捏合初始信息（例如：锚点项对应的索引）
    this.callbackObservers(observer => observer?.onPreFromSwitch?.(switchParams.targetForm));

    // 通知状态即将更新
    if (switchParams.targetForm !== undefined && switchParams.targetForm !== FormIndex.INVALID) {
      let targetForm = switchParams.targetForm;
      let currentForm: FormIndex = this._formFsm.getCurrentForm();
      if (targetForm === currentForm) {
        return;
      }
      this.callbackObservers(observer => observer?.onSwitchWillArrive?.(
        targetForm, targetForm > currentForm ? SwitchDirection.SCALE_UP : SwitchDirection.SCALE_DOWN));
    }
  }

  /**
   * 清空切换开始信息，切换完成后清除
   */
  public clearStartInfo(): void {
    this._switchStartInfo = undefined;
  }

  /**
   * 通知切换动效结束
   *
   * @param formIndex 动效发生层级
   */
  public notifyAnimationFinished(formIndex: FormIndex): void {
    this.callbackObservers(observer => observer?.onSwitchEndAnimation?.(formIndex));
  }

  public override updateStateFromVariableConfig(config?: ISwitchVariableConfig, reason?: string): void {
    // 更新日分组导航开关
    this.groupDayGuideOpenAsm.updateState(config?.isOpenGroupDayGuide, reason);

    // 初始化切换组件模式
    this.switchModeAsm.updateState(config?.switchMode, reason);

    // 初始化是否隐藏Switch到底部
    if (config?.switchHidToBottom !== undefined &&
      config.switchHidToBottom !== this.switchHidToBottomAsm.currentState) {
      this.switchHidToBottomAsm.updateState(config?.switchHidToBottom, SwitchShowUpdateReason.OUTER_REASON);
    }
  }

  protected override updateStateFromInitConfig(config: SwitchConfig, reason?: string): void {
    // 更新可变部分
    this.updateStateFromVariableConfig(config, reason);
  }
}