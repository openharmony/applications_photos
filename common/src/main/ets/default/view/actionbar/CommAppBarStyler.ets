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
import lazy { AppBarController, AppBarStyler } from './AppBar';
import lazy { ActionBarVar, SideBarStatusListener, SideBarViewModel } from '@ohos/tools/src/main/variables/ActionBarVar';
import lazy { FoldUtil } from '../../utils/FoldUtil';
import lazy { SelectManager, SelectListener } from '../../model/browser/SelectManager';

/* instrument ignore file */
const TAG = 'CommAppBarStyler';

/**
 * 通用Appbar样式管理器，用来管理AppBar位置，根据横竖屏等状态让开状态栏、挖孔等
 */
export class CommAppBarStyler implements AppBarStyler {
  public readonly controller: AppBarController;
  private static readonly PADDING_VERTICAL = 16; // vp
  private static readonly PADDING_HORIZONTAL = 24; // vp
  private static readonly TABLET_PADDING_VERTICAL = 16; // vp
  private static readonly TABLET_PADDING_HORIZONTAL = 32; // vp
  private static readonly TABLET_LEFT_PADDING_VERTICAL = 64; // vp
  private static readonly TABLET_LEFT_PADDING_HORIZONTAL = 48; // vp
  private readonly context: Context;
  private readonly manager: ScreenManager;
  private readonly selectManager: SelectManager | undefined;
  private readonly onLayoutChangedFunc: Function = (): void => this.updateLayout();
  private sideBarListener: SideBarStatusListener = {
    onStatusChanged: (status: boolean): void => this.updateLayout(),
  } as SideBarStatusListener;
  private readonly selectListener: SelectListener = {
    onModeChanged: (): void => this.onSelectModeChanged(),
  }

  /**
   * 构造函数
   * @param controller 控制器
   * @param manager 屏幕状态管理器
   */
  public constructor(context: Context, controller: AppBarController, manager: ScreenManager,
    selectManager?: SelectManager) {
    if (!context || !controller || !manager) {
      throw new Error('invalid input');
    }

    this.context = context;
    this.controller = controller;
    this.manager = manager;
    if (selectManager) {
      this.selectManager = selectManager;
    }
  }

  /**
   * 注册监听
   */
  public register(): void {
    this.manager.on(ScreenManager.ON_ORIENTATION_CHANGED, this.onLayoutChangedFunc);
    this.manager.on(ScreenManager.ON_STATUS_BAR_HEIGHT_CHANGED, this.onLayoutChangedFunc);
    this.manager.on(ScreenManager.ON_DIGGING_HOLE_CHANGED, this.onLayoutChangedFunc);
    LocalStorage.getShared()?.get<SideBarViewModel>(SideBarViewModel.STORAGE_KEY)?.register(this.sideBarListener);
    this.selectManager?.addListener(this.selectListener);
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
    this.selectManager?.removeListener(this.selectListener);
  }

  private onSelectModeChanged(): void {
    Log.info(TAG, `onSelectStateChanged ${this.selectManager?.mIsSelectedMode}`);
    this.updateLayout();
  }

  private updateLayout() {
    const statusBarHeight = this.manager.getStatusBarHeight();
    const isHorizontal = this.manager.isHorizontal();
    const isFoldExpanded: boolean = DeviceInfo.isFoldable();
    const isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
    let foldStatus = FoldUtil.getInstance().getCurFoldStatus();
    const isTablet: boolean = DeviceInfo.isTablet() || FoldUtil.isTriExpand(foldStatus);
    const holeArea: DiggingHoleCameraArea = this.manager.getDiggingHoleCameraArea();
    const isFloatingOrSplit: boolean = this.manager.isSplitOrFloating();
    const windowPcmodeSwitchStatus: boolean | undefined = AppStorage.get<boolean>('windowPcmodeSwitchStatus')
    const isFullMode: boolean = this.manager.isFullModeReal();

    let msg: string[] = [`updateLayout status: ${statusBarHeight}`];
    msg.push(`isHorizontal: ${isHorizontal}`);
    msg.push(`fold: ${isFoldExpanded}`);
    msg.push(`tablet: ${isTablet}`);
    msg.push(`isShowSideBar: ${ActionBarVar.isShowSideBar}`);
    msg.push(`holeArea: ${JSON.stringify(holeArea)}`);
    msg.push(`isFloatingOrSplit: ${isFloatingOrSplit}`);
    msg.push(`windowPcmodeSwitchStatus: ${windowPcmodeSwitchStatus}`);
    msg.push(`isFullMode: ${isFullMode}`);
    msg.push(`selectManager: ${this.selectManager?.mIsSelectedMode}`);
    Log.info(TAG, msg.join(', '));

    let paddingTop = 0;
    let paddingLeft = 0;
    let paddingRight = 0;
    if (isFoldExpanded) {
      paddingTop = statusBarHeight;
      paddingLeft = CommAppBarStyler.PADDING_HORIZONTAL;
      paddingRight = CommAppBarStyler.PADDING_HORIZONTAL;
    } else if (isTablet) {
      if (windowPcmodeSwitchStatus && !isFullMode) {
        paddingTop = 0;
      } else {
        paddingTop = statusBarHeight;
      }
      if (isHorizontal) {
        paddingLeft = CommAppBarStyler.TABLET_PADDING_HORIZONTAL +
          (ActionBarVar.isShowSideBar || (isFloatingOrSplit && !windowPcmodeSwitchStatus) ||
            this.selectManager?.mIsSelectedMode ? 0 :
            CommAppBarStyler.TABLET_LEFT_PADDING_HORIZONTAL);
        paddingRight = CommAppBarStyler.TABLET_PADDING_HORIZONTAL;
      } else {
        paddingLeft = CommAppBarStyler.TABLET_PADDING_VERTICAL +
          (ActionBarVar.isShowSideBar || (isFloatingOrSplit && !windowPcmodeSwitchStatus) ||
            this.selectManager?.mIsSelectedMode ? 0 : CommAppBarStyler.TABLET_LEFT_PADDING_VERTICAL);
        paddingRight = CommAppBarStyler.TABLET_PADDING_VERTICAL;
      }
    } else {
      paddingTop = isHorizontal || isVerdeFoldable ? 0 : statusBarHeight;
      let padding: number = isHorizontal ? CommAppBarStyler.PADDING_HORIZONTAL : CommAppBarStyler.PADDING_VERTICAL;
      paddingLeft = padding + holeArea.left;
      paddingRight = padding + holeArea.right;
    }

    this.controller.padding = {
      top: paddingTop,
      left: paddingLeft,
      right: paddingRight,
      bottom: 0,
    };
  }
}