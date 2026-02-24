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
import lazy { TimelineSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { ISelectConfig, ISelectVariableConfig, SelectConfig } from './config/SelectConfig';
import lazy { SelectState } from './constants/SelectState';
import lazy { GridOperateFsm, OperateEventType } from './GridOperateFsm';
import lazy { FrameSelectionUtil } from '@ohos/common/src/main/ets/default/utils/FrameSelectionUtil';
import lazy { ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';

/**
 * 选择事件监听
 */
export interface SelectEventListener {
  // 选择回调
  select?: (newState: number) => void;
  // 分组更新回调
  updateGroupCount?: (dateKey?: number) => void;
  // 选择数量更新回调
  updateCount?: (newState: number) => void;
  // 全选回调
  allSelect?: (newState: boolean, isDoSelectAll?: boolean) => void;
  // 清空选中状态回调
  clearSelect?: (isDoSelectAll: boolean) => void;
  // 刷新选择状态回调
  onRefreshSelectState?: () => void;
}

/**
 * 多选观察者代理
 */
export class SelectObserverProxy
  extends ConfigListenerObserverProxy<SelectStateManager, SelectConfig, SelectEventListener> {
  public constructor(getProxyFunc: (persistentId: number) => SelectStateManager) {
    super(getProxyFunc, 'SelectObserverProxy');
  }

  /**
   * 查询宫格多选状态
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getSelectState(callback?: StateChangeCallback<SelectState>): SelectState {
    return this.getState<SelectState>(this.proxy.selectAsm, callback);
  }

  /**
   * 查询宫格选中项checkResult
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getSelectedParseResult(callback?: StateChangeCallback<ParamsWrapper>): ParamsWrapper {
    return this.getState<ParamsWrapper>(this.proxy.selectedParseResultAsm, callback);
  }
}

/**
 * 多选状态管理器
 */
export class SelectStateManager
  extends ConfigStateManager<SelectConfig, ISelectConfig, ISelectVariableConfig, SelectEventListener> {
  public override readonly config: SelectConfig = new SelectConfig();

  /**
   * 多选状态管理器
   */
  public readonly selectAsm: AttributeStateManager<SelectState>;

  /**
   * 选中mediaItems的checkResult状态管理器
   */
  public readonly selectedParseResultAsm: AttributeStateManager<ParamsWrapper>;

  // 操作状态机
  private readonly operateFsm: GridOperateFsm;

  private _selectManager: TimelineSelectManager;

  public constructor(persistentId: number, operateFsm: GridOperateFsm) {
    super(persistentId, 'SelectStateManager');
    this.operateFsm = operateFsm;
    this.selectAsm = new AttributeStateManager(persistentId, SelectState.NONE, 'Select');
    this.selectedParseResultAsm = new AttributeStateManager(persistentId, new ParamsWrapper(), 'selectedParseResultAsm');
    this._selectManager = new TimelineSelectManager();
  }

  protected override doInit(config: ISelectConfig): void {
    super.doInit(config);
    FrameSelectionUtil.isInFrame = false;
    if (!this._selectManager.photoDataImpl) {
      this._selectManager.setPhotoDataImpl();
    }
  }

  public override updateStateFromVariableConfig(_config?: ISelectVariableConfig, _reason?: string): void {
  }

  public get selectManager(): TimelineSelectManager {
    return this._selectManager;
  }

  protected override updateStateFromInitConfig(config: SelectConfig, reason?: string): void {
    // 更新可变部分
    this.updateStateFromVariableConfig(config, reason);

    if (config.selectManager) {
      this._selectManager = config.selectManager;
      if (this._selectManager.mIsSelectedMode) {
        this.operateFsm.submitEvent(OperateEventType.ENTER_SELECT);
      }
    }

    // 初始化操作状态机参数
    this.operateFsm.updateIsSupportDefaultSelect(config.isSupportDefaultSelect);
  }

  protected override onObserverStateChange(hasObserver: boolean): void {
    if (hasObserver) {
      this._selectManager.registerCallback('select', (newState: number): void => {
        this.callbackObservers(observer => observer.select?.(newState));
      });
      this._selectManager.registerCallback('updateGroupCount', (dateKey?: number) => {
        this.callbackObservers(observer => observer.updateGroupCount?.(dateKey));
      });
      this._selectManager.registerCallback('updateCount', (newState: number) => {
        this.callbackObservers(observer => observer.updateCount?.(newState));
      });
      this._selectManager.registerCallback('allSelect', (newState: boolean, isDoSelectAll?: boolean) => {
        this.callbackObservers(observer => observer.allSelect?.(newState, isDoSelectAll));
      });
    } else {
      this._selectManager.unregisterCallback('select');
      this._selectManager.unregisterCallback('updateGroupCount');
      this._selectManager.unregisterCallback('updateCount');
      this._selectManager.unregisterCallback('allSelect');
    }
  }

  /**
   * 更新选择刷新状态
   */
  public refreshSelectState(): void {
    this.callbackObservers(observer => observer.onRefreshSelectState?.());
  }

  /**
   * 更新选择模式状态
   *
   * @param isDoSelectAll 是否全选
   */
  public clearSelect(isDoSelectAll: boolean): void {
    this.callbackObservers(observer => observer.clearSelect?.(isDoSelectAll));
  }
}