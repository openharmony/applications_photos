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
 * 形态数目
 */
export const FORM_SIZE: number = 4;

/**
 * 不规则数目
 */
export const IRREGULAR_SIZE: number = 6;

/**
 * 默认宫格列数
 */
export const DEFAULT_COLUMN: number[] = [16, 8, 4, 3];

/**
 * 默认宫格图片间距
 */
export const DEFAULT_GUTTER: number[] = [0, 0, 2, 2];

/**
 * 默认宫格缓存量（PC有所不同，通过这里来实现差异化）
 */
export const DEFAULT_CACHE_COUNT: number[] = [1, 1, 1, 1];

/**
 * 默认宫格左右内距
 */
export const DEFAULT_PADDING: number = 0;

/**
 * 分组标题高度
 */
export const GROUP_TITLE_HEIGHT: number = 68;

/**
 * 年月视图每个图片块的最大行数
 */
export const MAX_COLUMN_COUNT_FOR_YEARMONTH_ITEM: number = 10;

/**
 * 默认初始宫格挡位
 */
export const DEFAULT_GRID_MAGNITUDE: number = 2;

/**
 * 默认最大宫格挡位
 */
export const MAX_GRID_MAGNITUDE: number = 3;

/**
 * 默认最小宫格挡位
 */
export const MIN_GRID_MAGNITUDE: number = 1;

/**
 * 新宫格最近删除相册消息头占位高度补充值
 */
export const TRASH_HEIGHT: number = 20;

/**
 * 新宫格最近删除相册文本信息间距
 */
export const TRASH_MSG_BOTTOM: number = 16;

/**
 * 形态索引
 */
export enum FormIndex {
  /**
   * 无效
   */
  INVALID = -1,

  /**
   * 年
   */
  YEAR = 0,

  /**
   * 月
   */
  MONTH = 1,

  /**
   * 日
   */
  DAY = 2,

  /**
   * 日分组
   */
  GROUP_DAY = 3,
}

/**
 * 显示模式
 */
export enum ShowMode {
  /**
   * 改变可见性
   */
  VISIBLE,

  /**
   * 上树
   */
  ON_TREE,
}

/**
 * 不规则类型
 */
export enum IrregularType {
  /**
   * 头部消息
   */
  HEAD_MSG = 0,

  /**
   * 云同步卡片
   */
  CLOUD_SYNC_CARD = 1,

  /**
   * 排序选择器
   */
  SORT_SELECTOR = 2,

  /**
   * 固定不规则区域
   */
  FIXED_IRREGULAR = 3,

  /**
   *
   */
  PORTRAIT_SWIPER = 4,

  /**
   * 分类相册二级筛选
   */
  Classify_SELECTOR = 5,
}

/**
 * 宫格滚动原因
 */
export enum ScrollReason {
  /**
   * 默认，即用户滚动
   */
  DEFAULT = 'default',

  /**
   * 宫格切换
   */
  SWITCH = 'switch',

  /**
   * 外部触发
   */
  OUTER = 'outer',

  /**
   * 显示区域大小变化
   */
  SIZE_CHANGE = 'areaSizeChange',

  /**
   * 状态栏
   */
  STATUS_BAR = 'statusBar',
}

/**
 * 消息头下拉状态
 */
export enum PullDownState {
  /**
   * 默认
   */
  NONE,

  /**
   * 部分下拉
   */
  PARTIAL,

  /**
   * 完全下拉
   */
  FULL,
}