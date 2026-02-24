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

import lazy { FormIndex } from '../photogrid/statemanager/constants/GridDefine';

export class Constants {
  /**
   * zoomIn 2X
   */
  public static readonly ZOOM_IN_2X: number = 2;
  /**
   * zoomOut 0.5X
   */
  public static readonly ZOOM_OUT_HALF: number = 0.5;
  // 视图动效持续时间
  public static readonly ANIMATE_DURATION_TIME: number = 200;
  // 日期动效延迟时间
  public static readonly DATE_ANIMATE_DELAY_TIME: number = 100;
  // 日期动效持续时间
  public static readonly DATE_ANIMATE_DURATION_TIME: number = 200;
  // 默认缩放比
  public static readonly DEFAULT_SCALE: number = 1;
  // 最小缩放比例
  public static readonly MIN_SCALE_PROPORTIONS: number = 0.97;
  // 最大缩放比例
  public static readonly MAX_SCALE_PROPORTIONS: number = 1.05;
  // 年视图过界阈值
  public static readonly YEAR_SCALE_THRESHOLD: number = 0.67;
  // 日视图过界阈值
  public static readonly DAY_SCALE_THRESHOLD: number = 0.33;
  // 捏合手指数量
  public static readonly FINGER_COUNT: number = 2;
  // 捏合操作响应最小距离
  public static readonly MIN_PINCH_DISTANCE: number = 0.01;
  // 手机最大捏合速度阈值。大于阈值时判断为快速捏合， mm/s
  public static readonly MAX_SPEED_PHONE_THRESHOLD: number = 98;
  // xxxxxx最大捏合速度阈值。大于阈值时判断为快速捏合， mm/s
  public static readonly MAX_SPEED_FOLD_DISPLAY_MODE_FULL_THRESHOLD: number = 100;
  // PAD最大捏合速度阈值。大于阈值时判断为快速捏合， mm/s
  public static readonly MAX_SPEED_PAD_THRESHOLD: number = 128;
  // PPI转换阈值
  public static readonly PPI_THRESHOLD: number = 25.4;
  // DPI转换阈值
  public static readonly DPI_THRESHOLD: number = 160;
  // 捏合响应最新VP值
  public static readonly MIN_PINCH_VP_THRESHOLD: number = 10;
  // 纳秒转秒
  public static readonly NANOSECOND_TO_MILLISECOND: number = 1000000000;
  // 捏合操作缩放比阈值
  public static readonly PINCH_SCALE_CHANGE_THRESHOLD: number = 0.001;
  // 最小捏合响应时间
  public static readonly PINCH_MIN_TIME: number = 0.000001;
  // 捏合跨档阈值
  public static readonly STRADDLE_GEAR_THRESHOLD: number = 1;
  // 快速捏合动效短持续时间
  public static readonly PINCH_ANIMATE_SHORT_DURATION_TIME: number = 100;
  // 快速捏合动效长持续时间
  public static readonly PINCH_ANIMATE_DURATION_TIME: number = 200;
  // 慢速捏合动效长持续时间
  public static readonly LONG_PINCH_ANIMATE_DURATION_TIME: number = 400;
  // 年视图下标
  public static readonly YEAR_INDEX: number = 0;
  // 月视图下标
  public static readonly MONTH_INDEX: number = 1;
  // 日视图下标
  public static readonly DAY_INDEX: number = 2;
  // 日期分割视图下标
  public static readonly GROUP_DAY_INDEX: number = 3;
  // 年到月视图放大系数
  public static readonly YEAR_TO_MONTH_ZOOM_IN_THRESHOLD: number = 0.1;
  // 月到日视图放大系数
  public static readonly MONTH_TO_DAY_ZOOM_IN_THRESHOLD: number = 0.1;
  // 日到月视图缩小系数
  public static readonly DAY_TO_MONTH_ZOOM_OUT_THRESHOLD: number = 0.1;
  // 月到年视图缩小系数
  public static readonly MONTH_TO_YEAR_ZOOM_OUT_THRESHOLD: number = 0.1;
  // 年到月视图双指滑动系数
  public static readonly YEAR_TO_MONTH_ABNORMAL_THRESHOLD: number = 0.5;
  // 月到日视图双指滑动系数
  public static readonly MONTH_TO_DAY_ABNORMAL_THRESHOLD: number = 0.5;
  // 日到月视图双指滑动系数
  public static readonly DAY_TO_MONTH_ABNORMAL_THRESHOLD: number = 0.5;
  // 月到年视图双指滑动系数
  public static readonly MONTH_TO_YEAR_ABNORMAL_THRESHOLD: number = 0.5;
  // 视图原缩放比
  public static readonly VIEW_ORIGINAL_ZOOM_RATIO = 1;
  // 视图放大一档缩放比
  public static readonly FIRST_GEAR_ZOOM_IN = 2;
  // 视图放大两档缩放比
  public static readonly SECOND_GEAR_ZOOM_IN = 4;
  // 视图缩小一档缩放比
  public static readonly FIRST_GEAR_ZOOM_OUT = 0.5;
  // 视图缩小两档缩放比
  public static readonly SECOND_GEAR_ZOOM_OUT = 0.25;
  // 日到月预设锚点数量
  public static readonly DAY_TO_MONTH_ANCHOR_COUNT: number = 5;
  // 年到月预设锚点数量
  public static readonly YEAR_TO_MONTH_ANCHOR_COUNT: number = 9;
  // 4倍缩放比
  public static readonly ZOOM_RATIO_4X: number = 4;
  // 2倍缩放比
  public static readonly ZOOM_RATIO_2X: number = 2;
  // 最上层的年月日分段按钮、ToolBar视图
  public static readonly FIRST_LEVEL_VIEW: number = 5;
  // 顶部视图
  public static readonly TOP_VIEW: number = 4;
  // 中间层视图
  public static readonly MIDDLE_TOP_VIEW: number = 3;
  public static readonly MIDDLE_BOTTOM_VIEW: number = 2;
  // 底部视图
  public static readonly BOTTOM_VIEW: number = 1;
  // 缩放比方向变化次数
  public static readonly ZOOM_DIRECTION_CHANGE_TIMES: number = 5;
  // 预加载1.5屏数据
  public static readonly SCREEN_MULTIPLIER: number = 1.5;
  // 分段按钮边距
  public static readonly BUTTON_PADDING: string = '9.6vp';
  // 分段数量
  public static readonly SEGMENT_COUNT: number = 3.0;
}

/**
 * 捏合方向
 */
export enum PinchDirection {
  None = 'None',
  ScaleDown = 'ScaleDown',
  ScaleUp = 'ScaleUp',
}

/**
 * 年月日视图枚举类型
 */
export enum MViewType {
  YEAR,
  MONTH,
  DAY,
  GROUP_DAY
}

/**
 * 年月日视图切换触发方式
 */
export enum TabSelectedIndexesChangeFromType {
  CLICK = 'CLICK',
  CUSTOM = 'CUSTOM',
  TAP_GESTURE = 'TAP_GESTURE',
}

/**
 * 一档放大缩小手势0.75 - 1 - 1.5
 */
export enum Zoom1ST {
  UP = 1.5,
  MIDDLE = 1,
  DOWN = 0.75,
}

/**
 * 二档放大手势1.5 - 2 - 3
 */
export enum ZoomIn2ND {
  UP = 3,
  MIDDLE = 2,
  DOWN = 1.5,
}

/**
 * 三档放大手势 3- 4
 */
export enum ZoomIn3RD {
  UP = 4,
  DOWN = 3,
}

/**
 * 二档缩小手势 0.75- 0.5 -0.375
 */
export enum ZoomOut2ND {
  UP = 0.75,
  MIDDLE = 0.5,
  DOWN = 0.375,
}

/**
 * 三档缩小手势 0.375 - 0.25
 */
export enum ZoomOut3RD {
  UP = 0.375,
  DOWN = 0.25,
}

/**
 * 放大手势显示下一个视图的阈值
 */
export enum ZoomNext {
  YEAR_TO_MONTH_1ST = 1.2,
  MONTH_TO_DAY_1ST = 2.4,
  YEAR_TO_MONTH_2ND = 0.6,
  MONTH_TO_DAY_2ND = 1.2,
  YEAR_TO_MONTH_3RD = 0.3,
  MONTH_TO_DAY_3RD = 0.6,
}

export function convertToMViewType(index: FormIndex): MViewType {
  switch (index) {
    case FormIndex.YEAR:
      return MViewType.YEAR;
    case FormIndex.MONTH:
      return MViewType.MONTH;
    case FormIndex.DAY:
      return MViewType.DAY;
    case FormIndex.GROUP_DAY:
      return MViewType.GROUP_DAY;
    default:
      return MViewType.DAY;
  }
}