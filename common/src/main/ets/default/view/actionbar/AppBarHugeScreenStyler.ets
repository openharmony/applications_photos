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

import lazy window from '@ohos.window';
import lazy { LengthMetrics } from '@kit.ArkUI';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { getScreen, ScreenManager } from '../../model/common/ScreenManager';
import lazy { AppBarController, AppBarStyler } from './AppBar';
import { SearchSwitchManager } from '../../model/SearchSwitchManager';

// L1区域最小阈值
export const L1_WIDTH: number = 210;

// 单个按钮所需宽度 40 + 8
export const ICON_WIDTH: number = 48;

// 搜索框(200)
export const SEARCH_WIDTH1: number = 200;

// 搜索框(159)
export const SEARCH_WIDTH2: number = 159;

// 搜索框(40)
export const SEARCH_WIDTH3: number = 40;

// 搜索框和更多按钮间距(8)
export const PITCH_WIDTH: number = 8;

// 三键(176)
export const WIN_ICON_WIDTH: number = 176;

const TAG = 'AppBarHugeScreenStyler';

/**
 * PcAppBar样式管理器，用来管理PcAppBar边距
 */
export class AppBarHugeScreenStyler implements AppBarStyler {
  public readonly controller: AppBarController;
  protected readonly manager: ScreenManager = getScreen();
  private readonly onLayoutChangedFunc: Function = (size: window.Size): void => {
    this.updateLayout();
  };
  /**
   * appbar左边功能区域 (收起按钮+标题) 最小宽度
   */
  public titleRegionMinWidth: number = L1_WIDTH;
  /**
   * appbar中间功能区域 (分享/更多...) 功能按钮个数
   */
  public actionButtonCount: number = 5;
  /**
   * appbar右边功能区域 (搜索+窗口三键)
   */
  public extraWidth: number = WIN_ICON_WIDTH;
  /**
   * 是否为日分组视图
   */
  public isGroupDayView: boolean = false;

  /**
   * 构造函数
   * @param controller 控制器
   */
  public constructor(controller: AppBarController) {
    if (!controller) {
      Log.error(TAG, 'controller is null');
    }
    this.controller = controller;
  }

  /**
   * 注册监听
   */
  public register(): void {
    this.manager.on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onLayoutChangedFunc);
    this.updateLayout();
  }

  /**
   * 取消监听
   */
  public unregister(): void {
    this.manager.off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onLayoutChangedFunc);
  }

  /**
   * 计算padding
   */
  protected updateLayout() {
    const isInBreakPoint: boolean = this.manager.getIsInBreakPoint();
    let isSupportPhotoSearch = SearchSwitchManager.getInstance().isSupportPhotoSearch();
    if (!isSupportPhotoSearch) {
      this.extraWidth = WIN_ICON_WIDTH;
    }
    Log.info(TAG,
      `updateLayout. isInBreakPoint:${isInBreakPoint} isGroupDayView:${this.isGroupDayView} isSupportPhotoSearch:${isSupportPhotoSearch}`);
    this.controller.padding = {
      top: LengthMetrics.vp(8),
      bottom: LengthMetrics.vp(this.isGroupDayView ? 16 : 8),
      start: LengthMetrics.vp(isInBreakPoint ? 64 : 16),
      end: LengthMetrics.vp(this.extraWidth),
    };
  }

  /**
   * 根据宽度计算appbar中间功能区域能放的下action按钮个数
   */
  public getActionCountForWidth(width: number): number {
    return Math.floor((width - this.titleRegionMinWidth - this.extraWidth) / ICON_WIDTH);
  };

  /**
   * 根据宽度计算appbar中间功能区域放下action按钮后剩余空间
   */
  public getActionRemainderForWidth(width: number): number {
    return (width - this.titleRegionMinWidth - this.extraWidth) % ICON_WIDTH;
  };
}