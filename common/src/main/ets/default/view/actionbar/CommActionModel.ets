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

import lazy { ActionModel, MenuConstants, ParamsWrapper } from './Menu';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import type { BroadCast } from '../../utils/BroadCast';
import type { SelectManager } from '../../model/browser/SelectManager';

/**
 * 通用Model层实现，提供SelectionManager、Broadcast等
 */
export class CommActionModel implements ActionModel {
  /**
   * 额外定制参数
   */
  public readonly extraParams: ParamsWrapper = new ParamsWrapper();
  /**
   * 选择器
   */
  protected readonly manager: SelectManager;
  /**
   * 广播
   */
  protected readonly broadcast: BroadCast;
  /**
   * NavPathStack
   */
  protected readonly navPathStack: NavPathStack | undefined;
  /**
   * nav广播
   */
  protected readonly navBroadcast: BroadCast | undefined;

  /**
   * 构造函数
   *
   * @param manager 选择器
   * @param broadcast 广播
   */
  constructor(manager: SelectManager, broadcast: BroadCast, navPathStack?: NavPathStack, navBroadcast?: BroadCast) {
    this.manager = manager;
    this.broadcast = broadcast;
    this.navPathStack = navPathStack;
    this.navBroadcast = navBroadcast;
  }

  produce(): MenuContext {
    let menuContext = new MenuContext().set(MenuConstants.KEY_SELECTION_MANAGER, this.manager)
      .set(MenuConstants.KEY_BROADCAST, this.broadcast);
    if (this.navPathStack !== undefined) {
      menuContext.set(MenuConstants.KEY_NAV_PATH_STACK, this.navPathStack);
    }
    if (this.navBroadcast !== undefined) {
      menuContext.set(MenuConstants.KEY_NAVIGATION_BROADCAST, this.navBroadcast);
    }
    for (let key of this.extraParams.params.keys()) {
      menuContext.set(key, this.extraParams.params.get(key));
    }
    return menuContext;
  }
}