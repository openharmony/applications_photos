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

import lazy { Log } from '../../utils/Log';
import lazy { ColumnSize, getScreen, ScreenManager } from './ScreenManager';

const TAG: string = 'Screen';

export const MIN_WINDOW_WIDTH = 840;

export const MIN_WINDOW_HEIGHT = 560;

/**
 卡片栅格宽度适配规则:

 1.0<=水平vp<600 时:4 Columns  ;栅格,Margin=16,Gutter=8,卡片宽度占4 Columns

 2.600<=水平 vp<840 时:8 Columns 栅格,Margin=24,Gutter=12,卡片宽度占6 Columns

 3.840<=水平 vp<1440:12Columns 栅格,Margin=32,Gutter=16,卡片宽度占8 Columns

 4.1440<=水平vp 时:12Columns 栅格,Margin=32,Gutter=16,卡片宽度占8 Columns

 5.栅格最大使用宽度:最大使用宽度为 2220vp,当窗口不断拉宽大于 2220vp 时,栅格内的内容不再变化,多出的区域留白
 * @param size
 */
export function getListCardWidth(): number {
  const windowColumns = getScreen().getScreenColumns();
  if (windowColumns === ColumnSize.COLUMN_FOUR) {
    return getScreen().getColumnsWidth(ColumnSize.COLUMN_FOUR);
  } else if (windowColumns === ColumnSize.COLUMN_EIGHT) {
    return getScreen().getColumnsWidth(ColumnSize.COLUMN_SIX);
  } else if (windowColumns === ColumnSize.COLUMN_TWELVE) {
    return getScreen().getColumnsWidth(ColumnSize.COLUMN_EIGHT);
  }
  Log.error(TAG, `screenColumns is: ${windowColumns}`);
  return Number.NaN;
}

export class LeftBlankListener {
  public static on(fn: Function): void {
    getScreen().on(ScreenManager.ON_LEFT_BLANK_CHANGED, fn);
  }

  public static off(fn: Function): void {
    getScreen().off(ScreenManager.ON_LEFT_BLANK_CHANGED, fn);
  }
}

export class WinSizeListener {
  public static on(fn: Function): void {
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, fn);
  }

  public static off(fn: Function): void {
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, fn);
  }
}

/**
 * 绑定上下文的屏幕参数（横竖屏、大小、安全区域等）工具类
 */
export class ScreenHelper {
}