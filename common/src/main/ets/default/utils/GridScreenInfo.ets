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

import lazy { UiUtil } from './UiUtil';

/**
 * 宫格屏幕信息
 */
export class GridScreenInfo {
  /**
   * 宫格列数
   */
  public screenGridColNum: number = UiUtil.GRID_NUM_UNKNOWN;
  /**
   * 宫格行数
   */
  public screenGridRowNum: number = UiUtil.GRID_NUM_UNKNOWN;
  /**
   * 基于设备的xxx、横竖屏状态计算的宫格最大数量
   */
  public screenMaxGridNum: number = UiUtil.GRID_NUM_UNKNOWN;
}