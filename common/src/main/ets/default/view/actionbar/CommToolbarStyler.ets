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
import lazy { ScreenManager } from '../../model/common/ScreenManager';
import lazy { AppBarController, AppBarStyler } from './AppBar';
import lazy { AppBarStyles } from './AppBarStyles';

/* instrument ignore file */
const TAG = 'CommToolbarStyler';

/**
 * 通用Toolbar样式管理器，用来管理AppBar位置，根据横竖屏等状态让开状态栏、挖孔等
 */
export class CommToolbarStyler implements AppBarStyler {
  public readonly controller: AppBarController;
  private readonly manager: ScreenManager;
  private readonly onLayoutChangedFunc: Function = (): void => this.updateLayout();

  /**
   * 构造函数
   * @param controller 控制器
   * @param manager 屏幕状态管理器
   */
  public constructor(controller: AppBarController, manager: ScreenManager) {
    if (!controller) {
      throw new Error('invalid input');
    }
    this.controller = controller;
    this.manager = manager;
  }

  /**
   * 注册监听
   */
  public register(): void {
    this.manager.on(ScreenManager.ON_ORIENTATION_CHANGED, this.onLayoutChangedFunc);
    this.manager.on(ScreenManager.ON_STATUS_BAR_HEIGHT_CHANGED, this.onLayoutChangedFunc);
    this.manager.on(ScreenManager.ON_DIGGING_HOLE_CHANGED, this.onLayoutChangedFunc);
    this.updateLayout();
  }

  /**
   * 取消监听
   */
  public unregister(): void {
    this.manager.off(ScreenManager.ON_ORIENTATION_CHANGED, this.onLayoutChangedFunc);
    this.manager.off(ScreenManager.ON_STATUS_BAR_HEIGHT_CHANGED, this.onLayoutChangedFunc);
    this.manager.off(ScreenManager.ON_DIGGING_HOLE_CHANGED, this.onLayoutChangedFunc);
  }

  private updateLayout() {
    let horizontalPadding: number = AppBarStyles.TOOLBAR_PADDING;
    this.controller.padding = {
      left: horizontalPadding,
      right: horizontalPadding,
      bottom: this.manager.getAiBarHeight(),
    };
  }
}