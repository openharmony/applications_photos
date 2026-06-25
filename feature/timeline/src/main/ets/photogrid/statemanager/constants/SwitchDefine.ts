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
 * 年月日切换组件宽度
 */
export const SWITCH_WIDTH: number = 220;

/**
 * 年月日切换组件高度
 */
export const SWITCH_HEIGHT: number = 40;

/**
 * 年月日切换组件底部边距
 */
export const SWITCH_BOTTOM_MARGIN: number = 8;

/**
 * 年月日切换组件上方避让区域
 */
export const SWITCH_TOP_AVOID: number = 8;

/**
 * 切换方向
 */
export enum SwitchDirection {
  /**
   * 变化太小，不确定
   */
  NONE,

  /**
   * 缩小（日分组->日->月->年）
   */
  SCALE_DOWN,

  /**
   * 放大（年->月->日->日分组）
   */
  SCALE_UP,
}

/**
 * 切换组件模式
 */
export enum SwitchMode {
  /**
   * 正常模式（即一直显示）
   */
  NORMAL,

  /**
   * 底部显示模式（即宫格滑到底部时才显示）
   */
  ONLY_BOTTOM_SHOW,

  /**
   * 隐藏模式（即一直不显示,当前vde外屏场景专用）
   */
  HIDE,
}

/**
 * 切换组件显示状态更新原因
 */
export enum SwitchShowUpdateReason {
  /**
   * 不确定的原因
   */
  INNER_REASON = 'innerReason',

  /**
   * 不确定的原因
   */
  OUTER_REASON = 'outerReason',
}