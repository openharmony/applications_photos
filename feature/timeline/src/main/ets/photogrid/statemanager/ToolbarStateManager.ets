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
import lazy { ConfigObserverProxy } from '@ohos/common/src/main/ets/default/model/ConfigObserverProxy';
import lazy { ConfigStateManager } from '@ohos/common/src/main/ets/default/model/ConfigStateManager';
import lazy { StateChangeCallback } from '@ohos/common/src/main/ets/default/model/StateObserverManager';
import lazy { IToolbarConfig, IToolbarVariableConfig, ToolbarConfig } from './config/ToolbarConfig';
import lazy { GridToolBarPosition } from './constants/ToolBarDefine';

/**
 * 工具栏观察者代理
 */
export class ToolbarObserverProxy extends ConfigObserverProxy<ToolbarStateManager, ToolbarConfig> {
  public constructor(getProxyFunc: (persistentId: number) => ToolbarStateManager) {
    super(getProxyFunc, 'ToolbarObserverProxy');
  }

  /**
   * 查询宫格工具栏位置
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getToolbarPosition(callback?: StateChangeCallback<GridToolBarPosition>): GridToolBarPosition {
    return this.getState<GridToolBarPosition>(this.proxy.toolBarPositionAsm, callback);
  }
}

/**
 * 工具栏状态管理器
 */
export class ToolbarStateManager extends ConfigStateManager<ToolbarConfig, IToolbarConfig, IToolbarVariableConfig> {
  public override readonly config: ToolbarConfig = new ToolbarConfig();

  /**
   * 宫格工具栏位置管理器
   */
  public readonly toolBarPositionAsm: AttributeStateManager<GridToolBarPosition>;

  public constructor(persistentId: number) {
    super(persistentId, 'ToolbarStateManager');

    this.toolBarPositionAsm = new AttributeStateManager(persistentId, GridToolBarPosition.BOTTOM, 'ToolBarPosition');
  }

  public override updateStateFromVariableConfig(config?: IToolbarVariableConfig, reason?: string): void {
    // 更新工具栏位置
    this.toolBarPositionAsm.updateState(config?.toolbarPosition, reason);
  }

  protected override updateStateFromInitConfig(config: ToolbarConfig, reason?: string): void {
    // 更新可变部分
    this.updateStateFromVariableConfig(config, reason);
  }
}