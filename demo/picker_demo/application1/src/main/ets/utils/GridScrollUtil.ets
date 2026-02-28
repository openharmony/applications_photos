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

import lazy { ApsUtil } from '../utils/ApsUtil';
import lazy { DayGridSlideHelper } from './DayGridSlideHelper';
import lazy { DayRegularGridDragScrollHelper } from './DayRegularGridDragScrollHelper';
import lazy { DeviceInfo } from './DeviceInfo';
import lazy { GridDragScrollBaseHelper } from './GridDragScrollBaseHelper';
import lazy { GridScrollBaseHelper } from './GridScrollBaseHelper';
import lazy { GridSlideBaseHelper } from './GridSlideBaseHelper';
import lazy { StringUtil } from '../utils/StringUtil';
import lazy systemParameter from '@ohos.systemparameter';
import lazy { YearMonthScrollHelper } from './YearMonthScrollHelper';

/**
 * 控制是否使能宫格滚动条浏览场景优化
 */
const SCROLLBAR_SCROLL_OPTIMIZE_ENABLE: string = 'const.sys.photos.scrollbar.scroll.optimize.enable';

/**
 * 控制是否使能年月日场景优化
 */
const YEAR_MONTH_ENABLE: string = 'const.sys.photos.yearMonth.enable';

const ENABLE: string = 'on';

/**
 * 宫格滑动场景
 */
export enum GridScrollScene {
  /**
   * 日视图滑动场景
   */
  DAY_VIEW_GRID_SLIDE,

  /**
   * 日视图规则布局滚动场景
   */
  DAY_VIEW_REGULAR_GRID_DRAG_SCROLL,

  /**
   * 年月视图浏览场景
   */
  YEAR_MONTH_GRID_SCROLL,
}

/**
 * 宫格滑动工具类
 */
export class GridScrollUtil {
  private static isScrollbarScrollOptimizeEnabled: boolean = GridScrollUtil.isSupportScrollbarScrollOptimize();
  private static isYearMonthOptimizeEnabled: boolean = GridScrollUtil.isSupportYearMonthOptimize();

  /**
   * 是否使能宫格滚动条浏览场景优化（默认使能）
   *
   * @returns true表示使能
   */
  public static isSupportScrollbarScrollOptimize(): boolean {
    let param: string = systemParameter.getSync(SCROLLBAR_SCROLL_OPTIMIZE_ENABLE, ENABLE);
    return StringUtil.size(param) !== 0 && param === ENABLE;
  }

  /**
   * 是否使能年月日场景优化（默认使能）
   *
   * @returns true表示使能
   */
  public static isSupportYearMonthOptimize(): boolean {
    let param: string = systemParameter.getSync(YEAR_MONTH_ENABLE, ENABLE);
    return StringUtil.size(param) !== 0 && param === ENABLE;
  }

  /**
   * 根据滑动场景创建滑动辅助类
   *
   * @param 滑动场景
   * @returns 滑动辅助类
   */
  public static createSlideHelper(scene: GridScrollScene): GridSlideBaseHelper | undefined {
    if (scene == GridScrollScene.DAY_VIEW_GRID_SLIDE) {
      return new DayGridSlideHelper();
    } else {
      return undefined;
    }
  }

  /**
   * 根据滚动场景创建滑动辅助类
   *
   * @param 滚动场景
   * @returns 滚动辅助类
   */
  public static createDragScrollHelper(scene: GridScrollScene): GridDragScrollBaseHelper | undefined {
    if (scene == GridScrollScene.DAY_VIEW_REGULAR_GRID_DRAG_SCROLL &&
    GridScrollUtil.isYearMonthOptimizeEnabled && GridScrollUtil.isScrollbarScrollOptimizeEnabled &&
    DeviceInfo.isPhone() && ApsUtil.isSupportAps()) {
      return new DayRegularGridDragScrollHelper();
    } else {
      return undefined;
    }
  }

  /**
   * 根据年月场景创建浏览辅助类
   *
   * @param 年月浏览场景
   * @returns 浏览辅助类
   */
  public static createYearMonthScrollHelper(scene: GridScrollScene): GridScrollBaseHelper | undefined {
    if (scene == GridScrollScene.YEAR_MONTH_GRID_SCROLL && GridScrollUtil.isYearMonthOptimizeEnabled) {
      return new YearMonthScrollHelper();
    } else {
      return undefined;
    }
  }
}