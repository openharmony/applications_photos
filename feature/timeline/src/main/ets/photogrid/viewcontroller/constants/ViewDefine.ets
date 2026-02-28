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

/**
 * 组件ID
 */
export enum ViewId {
  /**
   * 无数据提示信息
   */
  NO_DATA = 'noDataView',

  /**
   * 年宫格
   */
  YEAR_GRID = 'yearGrid',

  /**
   * 年宫格项
   */
  YEAR_GRID_ITEM = 'yearGridItem',

  /**
   * 年宫格截图
   */
  YEAR_GRID_SNAPSHOT = 'yearGridSnapshot',

  /**
   * 年滚动条
   */
  YEAR_SCROLLER = 'yearScroller',

  /**
   * 年胶囊
   */
  YEAR_CAPSULES = 'yearCapsules',

  /**
   * 月宫格
   */
  MONTH_GRID = 'monthGrid',

  /**
   * 月宫格项
   */
  MONTH_GRID_ITEM = 'monthGridItem',

  /**
   * 月宫格截图
   */
  MONTH_GRID_SNAPSHOT = 'monthGridSnapshot',

  /**
   * 月滚动条
   */
  MONTH_SCROLLER = 'monthScroller',

  /**
   * 日宫格
   */
  DAY_GRID = 'dayGrid',

  /**
   * 日宫格截图
   */
  DAY_GRID_SNAPSHOT = 'dayGridSnapshot',

  /**
   * 日预览宫格
   */
  DAY_PREVIEW_GRID = 'dayPreviewGrid',

  /**
   * 日宫格
   */
  DAY_SCROLLER = 'dayScroller',

  /**
   * 日分组宫格
   */
  GROUP_DAY_GRID = 'groupDayGrid',

  /**
   * 日分组预览宫格
   */
  GROUP_DAY_PREVIEW_GRID = 'groupDayPreviewGrid',

  /**
   * 日分组滚动条
   */
  GROUP_DAY_SCROLLER = 'groupDayScroller',

  /**
   * 切换组件
   */
  SWITCH = 'switch',

  /**
   * 标题栏
   */
  TITLE_BAR = 'titleBar',

  /**
   * 标题栏下方蒙层
   */
  TITLE_BAR_MASK = 'titleBarMask',

  /**
   * 工具栏
   */
  TOOL_BAR = 'toolBar',

  /**
   * 不规则区域
   */
  IRREGULAR_VIEW = 'irregularView',

  /**
   * 固定不规则区域
   */
  FIXED_IRREGULAR_VIEW = 'fixedIrregularView',

  /**
   * 底部规避区域导航线
   */
  BOTTOM_AVOID_GUIDELINE = 'bottomAvoidGuideline',

  /**
   * 顶部规避区域导航线
   */
  TOP_AVOID_GUIDELINE = 'topAvoidGuideline',

  /**
   * 不规则区域底部导航线
   */
  IRREGULAR_BOTTOM_GUIDELINE = 'irregularBottom',

  /**
   * 父容器ID
   */
  CONTAINER = '__container__',
}

const LOW_GRID_LAYER: number = 100;
const GRID_LAYER: number = 200;
/**
 * 宫格低层级与正常层级距离
 */
export const LOW_GRID_GAP: number = GRID_LAYER - LOW_GRID_LAYER;
const UNDER_SCROLLER_LAYER: number = 300;
const SCROLLER_LAYER: number = 400;
const BAR_LAYER: number = 500;
const OVER_BAR_LAYER: number = 600;

const YEAR_ORDER: number = 10;
const MONTH_ORDER: number = 20;
const DAY_ORDER: number = 30;
const GROUP_DAY_ORDER: number = 40;

/**
 * 组件Z序（注：最上面是标题栏、工具栏、切换视图，然后依次日分组视图、日视图、月视图、年视图）
 */
export enum ViewZIndex {
  /**
   * 无数据提示信息
   */
  NO_DATA = 1,

  /**
   * 年宫格
   */
  YEAR_GRID = GRID_LAYER + YEAR_ORDER,

  /**
   * 年宫格截图
   */
  YEAR_GRID_SNAPSHOT = YEAR_GRID + 1,

  /**
   * 年宫格
   */
  LOW_YEAR_GRID = LOW_GRID_LAYER + YEAR_ORDER,

  /**
   * 年滚动条
   */
  YEAR_SCROLLER = SCROLLER_LAYER + YEAR_ORDER,

  /**
   * 年胶囊
   */
  YEAR_CAPSULES = OVER_BAR_LAYER + YEAR_ORDER,

  /**
   * 月宫格
   */
  MONTH_GRID = GRID_LAYER + MONTH_ORDER,

  /**
   * 月宫格截图
   */
  MONTH_GRID_SNAPSHOT = MONTH_GRID + 1,

  /**
   * 低月宫格
   */
  LOW_MONTH_GRID = LOW_GRID_LAYER + MONTH_ORDER,

  /**
   * 月滚动条
   */
  MONTH_SCROLLER = SCROLLER_LAYER + MONTH_ORDER,

  /**
   * 日宫格
   */
  DAY_GRID = GRID_LAYER + DAY_ORDER,

  /**
   * 日宫格截图
   */
  DAY_GRID_SNAPSHOT = DAY_GRID + 1,

  /**
   * 低日宫格
   */
  LOW_DAY_GRID = LOW_GRID_LAYER + DAY_ORDER,

  /**
   * 日预览宫格
   */
  DAY_PREVIEW_GRID = DAY_GRID + 1,

  /**
   * 日滚动条
   */
  DAY_SCROLLER = SCROLLER_LAYER + DAY_ORDER,

  /**
   * 日分组宫格
   */
  GROUP_DAY_GRID = GRID_LAYER + GROUP_DAY_ORDER,

  /**
   * 低日宫格
   */
  LOW_GROUP_DAY_GRID = LOW_GRID_LAYER + GROUP_DAY_ORDER,

  /**
   * 日分组预览宫格
   */
  GROUP_DAY_PREVIEW_GRID = GROUP_DAY_GRID + 1,

  /**
   * 日分组滚动条
   */
  GROUP_DAY_SCROLLER = SCROLLER_LAYER + GROUP_DAY_ORDER,

  /**
   * 年月日切换组件
   */
  SWITCH = UNDER_SCROLLER_LAYER,

  /**
   * 标题栏
   */
  TITLE_BAR = BAR_LAYER,

  /**
   * 标题栏下方蒙层
   */
  TITLE_BAR_MASK = UNDER_SCROLLER_LAYER + 99,

  /**
   * 工具栏
   */
  TOOL_BAR = BAR_LAYER,

  /**
   * 消息头
   */
  IRREGULAR_VIEW = UNDER_SCROLLER_LAYER,

  /**
   * 固定不规则区域
   */
  FIXED_IRREGULAR_VIEW = IRREGULAR_VIEW + 1,
}