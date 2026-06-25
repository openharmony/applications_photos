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

import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy {
  YearMonthMediaDataSource
} from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthMediaDataSource';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { YearMonthDataView } from '../../model/YearMonthDataView';
import lazy { DataSourceManager } from '../model/DataSourceManager';
import lazy { FormIndex } from '../statemanager/constants/GridDefine';
import lazy { DisplayStateManager } from '../statemanager/DisplayStateManager';
import lazy { OperateEventType, OperateStateTypeUtils } from '../statemanager/GridOperateFsm';
import lazy { GridStateManager } from '../statemanager/GridStateManager';
import lazy { GridStateObserverProxy } from '../statemanager/GridStateObserverProxy';
import lazy { GridStateProxy } from '../statemanager/GridStateProxy';
import lazy { PinchStateManager } from '../statemanager/PinchStateManager';
import lazy { ScrollerStateManager } from '../statemanager/ScrollerStateManager';
import lazy { SelectStateManager } from '../statemanager/SelectStateManager';
import lazy { SwitchStateManager } from '../statemanager/SwitchStateManager';
import lazy { TitleBarStateManager } from '../statemanager/TitleBarStateManager';
import lazy { ToolbarStateManager } from '../statemanager/ToolbarStateManager';
import lazy { AlbumStateManager } from '../statemanager/AlbumStateManager';
import lazy { FormStateTypeUtils } from '../statemanager/GridFormFsm';

/**
 * 抽象视图模型
 */
export class AbstractVm extends GridStateObserverProxy {
  /**
   * 设置多选模式
   */
  public changeSelectMode(isSelectMode: boolean): void {
    LogUtils.info(this.tag, `changeSelectMode: ${isSelectMode}`);
    this.stateProxy.operateFsm.submitEvent(
      isSelectMode ? OperateEventType.ENTER_SELECT : OperateEventType.ENTER_BROWSER);
  }

  /**
   * 判断是否在多选模式
   *
   * @returns 是否在多选模式
   */
  public isInSelectMode(): boolean {
    return OperateStateTypeUtils.isInSelectState(this.stateProxy.operateFsm.currentState);
  }

  protected get stateProxy(): GridStateProxy {
    return this.proxy;
  }

  /**
   * 获取宫格状态管理器
   *
   * @returns 状态管理器
   */
  protected get gridStateManager(): GridStateManager {
    return this.stateProxy.gridStateManager;
  }

  /**
   * 获取切换状态管理器
   *
   * @returns 状态管理器
   */
  protected get switchStateManager(): SwitchStateManager {
    return this.stateProxy.switchStateManager;
  }

  /**
   * 获取捏合状态管理器
   *
   * @returns 状态管理器
   */
  protected get pinchStateManager(): PinchStateManager {
    return this.stateProxy.pinchStateManager;
  }

  /**
   * 获取工具栏状态管理器
   *
   * @returns 状态管理器
   */
  protected get toolbarStateManager(): ToolbarStateManager {
    return this.stateProxy.toolbarStateManager;
  }

  /**
   * 获取多选状态管理器
   *
   * @returns 状态管理器
   */
  protected get selectStateManager(): SelectStateManager {
    return this.stateProxy.selectStateManager;
  }

  /**
   * 获取屏幕显示状态管理器
   *
   * @returns 状态管理器
   */
  protected get displayStateManager(): DisplayStateManager {
    return this.stateProxy.displayStateManager;
  }

  /**
   * 获取滚动条状态管理器
   *
   * @returns 状态管理器
   */
  protected get scrollerStateManager(): ScrollerStateManager {
    return this.stateProxy.scrollerStateManager;
  }

  /**
   * 相册状态管理器
   *
   * @returns 状态管理器
   */
  protected get albumStateManager(): AlbumStateManager {
    return this.stateProxy.albumStateManager;
  }

  /**
   * 获取标题栏状态管理器
   *
   * @returns 状态管理器
   */
  protected get titleBarStateManager(): TitleBarStateManager {
    return this.stateProxy.titleBarStateManager;
  }

  /**
   * 获取当前形态
   *
   * @returns 当前形态
   */
  protected get currentForm(): FormIndex {
    return this.stateProxy.formFsm.getCurrentForm();
  }

  /**
   * 获取数据源代理
   *
   * @returns 数据源代理
   */
  protected get dataSourceManager(): DataSourceManager {
    return this.stateProxy.dataSourceManager;
  }

  /**
   * 获取日数据源
   *
   * @returns 数据源代理
   */
  protected get dayDataSource(): AlbumDataSource {
    return this.stateProxy.dataSourceManager.dayDataSource;
  }

  /**
   * 获取数据源代理
   *
   * @returns 数据源代理
   */
  protected get groupDayDataSource(): AlbumDataSource {
    return this.stateProxy.dataSourceManager.groupDayDataSource;
  }

  /**
   * 更新沉浸态
   *
   * @param reason 更新原因
   */
  protected updateImmersiveState(reason?: string): void {
    // 只有当isAlwaysImmersive为true时，才根据滚动偏移量决定是否进入沉浸式状态
    const isAlwaysImmersive = this.albumObserverProxy.config.isAlwaysImmersive;
    this.gridStateManager.immersiveAsm.updateState(isAlwaysImmersive && !this.gridObserverProxy.getIsInGroupState() &&
    FormStateTypeUtils.isHasDataState(this.getFormState()) &&
      this.gridObserverProxy.getScrollOffset(this.getCurrentForm()) >=
      this.titleBarObserverProxy.getImmersiveThreshold(), reason);
  }
}