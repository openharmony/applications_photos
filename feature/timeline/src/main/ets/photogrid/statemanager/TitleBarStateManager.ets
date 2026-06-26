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
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { ConfigObserverProxy } from '@ohos/common/src/main/ets/default/model/ConfigObserverProxy';
import lazy { ConfigStateManager } from '@ohos/common/src/main/ets/default/model/ConfigStateManager';
import lazy { StateChangeCallback } from '@ohos/common/src/main/ets/default/model/StateObserverManager';
import lazy { Throttle } from '@ohos/common/src/main/ets/default/utils/Throttle';
import lazy { AppBarController } from '@ohos/common/src/main/ets/default/view/actionbar/AppBar';
import lazy { ITitleBarConfig, ITitleBarVariableConfig, TitleBarConfig } from './config/TitleBarConfig';
import lazy { FormIndex } from './constants/GridDefine';

export interface FindAddressParam {
  firstIndex: number;
  columnCount: number;
  formIndex: FormIndex;
}

const UPDATE_ADDRESS_DURATION = 200;

/**
 * 标题栏观察者代理
 */
export class TitleBarObserverProxy extends ConfigObserverProxy<TitleBarStateManager, TitleBarConfig> {
  public constructor(getProxyFunc: (persistentId: number) => TitleBarStateManager) {
    super(getProxyFunc, 'TitleBarObserverProxy');
  }

  /**
   * 查询沉浸态高度阈值
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getImmersiveThreshold(callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.immersiveThresholdAsm, callback);
  }

  /**
   * 查询title bar高度
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getTitleBarHeight(callback?: StateChangeCallback<number>): number {
    return this.getState<number>(this.proxy.titleBarHeightAsm, callback);
  }

  /**
   * 查询主标题
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getMainContent(callback?: StateChangeCallback<string | Resource>): string | Resource {
    return this.getState<string | Resource>(this.proxy.mainTitleContentAsm, callback);
  }

  /**
   * 查询title bar高度
   *
   * @param callback 更新回调
   * @returns 属性状态
   */
  public getSubContent(callback?: StateChangeCallback<string>): string {
    return this.getState<string>(this.proxy.subTitleContentAsm, callback);
  }

  public getTitleBarPadding(): Padding | LocalizedPadding {
    return this.proxy.titleBarAppBarController.padding;
  }
}

/**
 * 标题栏状态管理器
 */
export class TitleBarStateManager
  extends ConfigStateManager<TitleBarConfig, ITitleBarConfig, ITitleBarVariableConfig> {
  public override readonly config: TitleBarConfig = new TitleBarConfig();
  public readonly findAddressThrottle: Throttle<FindAddressParam> = new Throttle(UPDATE_ADDRESS_DURATION);
  /**
   * 进入沉浸态高度阈值
   */
  public readonly immersiveThresholdAsm: AttributeStateManager<number>;
  /**
   * 标题栏高度
   */
  public readonly titleBarHeightAsm: AttributeStateManager<number>;
  public readonly mainTitleContentAsm: AttributeStateManager<string | Resource>;
  public readonly subTitleContentAsm: AttributeStateManager<string>;
  public titleBarAppBarController: AppBarController;

  public constructor(persistentId: number) {
    super(persistentId, 'TitleBarStateManager');

    this.immersiveThresholdAsm = new AttributeStateManager(persistentId, Number.MAX_SAFE_INTEGER,
      'ImmersiveThreshold');
    this.titleBarHeightAsm = new AttributeStateManager(persistentId, Constants.ActionBarHeight, 'TitleBarHeight');
    this.mainTitleContentAsm = new AttributeStateManager(persistentId, '', 'MainTitleContent');
    this.subTitleContentAsm = new AttributeStateManager(persistentId, '', 'SubTitleContent');
    this.titleBarAppBarController = new AppBarController();
  }

  public setTitleBarAppBarController(newController: AppBarController) {
    this.titleBarAppBarController = newController;
  }

  public override updateStateFromVariableConfig(_config?: ITitleBarVariableConfig, _reason?: string): void {
  }

  protected override updateStateFromInitConfig(config: TitleBarConfig, reason?: string): void {
    // 更新可变部分
    this.updateStateFromVariableConfig(config, reason);

    this.titleBarHeightAsm.updateState(config?.titleBarHeight, reason);
  }
}