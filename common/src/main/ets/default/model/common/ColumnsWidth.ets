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
/* instrument ignore file*/
import lazy { Log } from '../../utils/Log';
import lazy { ColumnSize, getScreen } from './ScreenManager';


const TAG: string = 'ColumnsWidth';

/**
 * 卡片栅格宽度适配, 此逻辑不适用于长按菜单的短栅格
 */
export namespace ColumnsWidth {
  /**
   卡片栅格宽度适配规则:

   1.0<=水平vp<600 时:4 Columns  ;栅格,Margin=16,Gutter=8,卡片宽度占4 Columns

   2.600<=水平 vp<840 时:8 Columns 栅格,Margin=24,Gutter=12,卡片宽度占6 Columns

   3.840<=水平 vp<1440:12Columns 栅格,Margin=32,Gutter=16,卡片宽度占8 Columns

   4.1440<=水平vp 时:12Columns 栅格,Margin=32,Gutter=16,卡片宽度占8 Columns

   5.栅格最大使用宽度:最大使用宽度为 2220vp,当窗口不断拉宽大于 2220vp 时,栅格内的内容不再变化,多出的区域留白
   * @param size
   */
  export function updateListCardWidth(): number {
    let listCardWidth: number = 0;
    const windowColumns = getScreen().getScreenColumns();
    if (windowColumns === ColumnSize.COLUMN_FOUR) {
      listCardWidth = getScreen().getColumnsWidth(ColumnSize.COLUMN_FOUR);
    } else if (windowColumns === ColumnSize.COLUMN_EIGHT) {
      listCardWidth = getScreen().getColumnsWidth(ColumnSize.COLUMN_SIX);
    } else if (windowColumns === ColumnSize.COLUMN_TWELVE) {
      listCardWidth = getScreen().getColumnsWidth(ColumnSize.COLUMN_EIGHT);
    } else {
      Log.error(TAG, `screenColumns is: ${windowColumns}`);
    }
    return listCardWidth;
  }

  export function updateCleanupPageListCardWidth(): number {
    let listCardWidth: number = 0;
    const windowColumns = getScreen().getScreenColumns();
    if (windowColumns === ColumnSize.COLUMN_FOUR) {
      listCardWidth = getScreen().getColumnsWidth(ColumnSize.COLUMN_FOUR);
    } else if (windowColumns === ColumnSize.COLUMN_EIGHT) {
      listCardWidth = getScreen().getColumnsWidth(ColumnSize.COLUMN_EIGHT);
    } else if (windowColumns === ColumnSize.COLUMN_TWELVE) {
      listCardWidth = getScreen().getColumnsWidth(ColumnSize.COLUMN_TWELVE);
    } else {
      Log.error(TAG, `screenColumns is: ${windowColumns}`);
    }
    return listCardWidth;
  }
}