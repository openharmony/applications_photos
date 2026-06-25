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
import lazy { DiggingHoleCameraArea, ScreenManager } from '../../model/common/ScreenManager';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { Log } from '../../utils/Log';
import lazy { AppBarController } from './AppBar';
import lazy { ActionBarVar, SideBarStatusListener, SideBarViewModel } from '@ohos/tools/src/main/variables/ActionBarVar';

/* instrument ignore file */
const TAG = 'CommSheetAppBarStyler';

/**
 * 半模态通用Appbar样式管理器，用来管理AppBar位置，根据横竖屏等状态改变布局
 */
export class CommSheetAppBarStyler {
  private static readonly PADDING_VERTICAL = 16; // vp
  private static readonly PADDING_HORIZONTAL = 24; // vp
  private static readonly TABLET_PADDING_VERTICAL = 16; // vp
  private static readonly TABLET_PADDING_HORIZONTAL = 32; // vp
  private static readonly TABLET_LEFT_PADDING_VERTICAL = 64; // vp
  private static readonly TABLET_LEFT_PADDING_HORIZONTAL = 48; // vp
  private readonly context: Context;
  private readonly controller: AppBarController;
  private readonly manager: ScreenManager;
  private readonly onLayoutChangedFunc: Function = (): void => this.updateLayout();
  private sideBarListener: SideBarStatusListener = {
    onStatusChanged: (status: boolean): void => this.updateLayout(),
  } as SideBarStatusListener;

  /**
   * 构造函数
   * @param controller 控制器
   * @param manager 屏幕状态管理器
   */
  public constructor(context: Context, controller: AppBarController, manager: ScreenManager) {
    if (!context || !controller || !manager) {
      throw new Error('invalid input');
    }

    this.context = context;
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
    LocalStorage.getShared()?.get<SideBarViewModel>(SideBarViewModel.STORAGE_KEY)?.register(this.sideBarListener);
    this.updateLayout();
  }

  /**
   * 取消监听
   */
  public unregister(): void {
    this.manager.off(ScreenManager.ON_ORIENTATION_CHANGED, this.onLayoutChangedFunc);
    this.manager.off(ScreenManager.ON_STATUS_BAR_HEIGHT_CHANGED, this.onLayoutChangedFunc);
    this.manager.off(ScreenManager.ON_DIGGING_HOLE_CHANGED, this.onLayoutChangedFunc);
    LocalStorage.getShared()?.get<SideBarViewModel>(SideBarViewModel.STORAGE_KEY)?.unregister(this.sideBarListener);
  }

  private updateLayout() {
    // TODO 具体值待定
    const statusBarHeight = CommSheetAppBarStyler.PADDING_VERTICAL - 8;
    const isHorizontal = this.manager.isHorizontal();
    const isFoldExpanded: boolean = DeviceInfo.isFoldable();
    const isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
    const isTablet: boolean = DeviceInfo.isTablet();
    const holeArea: DiggingHoleCameraArea = this.manager.getDiggingHoleCameraArea();

    let msg: string[] = [`updateLayout status: ${statusBarHeight}`];
    msg.push(`isHorizontal: ${isHorizontal}`);
    msg.push(`fold: ${isFoldExpanded}`);
    msg.push(`tablet: ${isTablet}`);
    msg.push(`isShowSideBar: ${ActionBarVar.isShowSideBar}`);
    msg.push(`holeArea: ${JSON.stringify(holeArea)}`);
    Log.info(TAG, msg.join(', '));

    let paddingTop = 0;
    let paddingLeft = 0;
    let paddingRight = 0;
    if (isFoldExpanded) {
      paddingTop = statusBarHeight;
    } else if (isTablet) {
      paddingTop = statusBarHeight;
    } else {
      paddingTop = isHorizontal || isVerdeFoldable ? 0 : statusBarHeight;
    }
    paddingLeft = CommSheetAppBarStyler.PADDING_VERTICAL;
    paddingRight = CommSheetAppBarStyler.PADDING_VERTICAL;

    this.controller.padding = {
      top: paddingTop,
      left: paddingLeft,
      right: paddingRight,
      bottom: 0,
    };
  }
}