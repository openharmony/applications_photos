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

import lazy { DateUtil } from './DateUtil';
import lazy { Log } from './Log';
import type { TimelineData } from '../model/browser/photo/TimelineData';

export const TASKPOOL_TAG = 'TimelineScrollBarManager';

/* instrument ignore file */
const TAG = 'timelineScrollBarUtils';

/**
 * yearMonthText: 年月文本
 * rowCount: 行数
 */
export class DateYearMontCapsule {
  public yearMonthText: string = '';
  public rowCount: number = 0;
}

/**
 * 计算出日期对应的行数及gaps
 * needCalcData: 需要计算的数据
 * isYear: 是否只需要计算年的数据
 * gridRowCount：宫格一行有多少个griditem
 * currentScrollerHeight：scrollbar的高度(vp)
 * allRowNum：宫格照片总行数
 * barBigHeight：滚动条游标高度(vp)
 * callBack：回调
 */
export function calcRowAndGaps(needCalcData: TimelineData[] | undefined, isYear: boolean, gridRowCount: number,
  currentScrollerHeight: number, allRowNum: number, barBigHeight: number,
  callBack: Function, isCapsule: boolean = false): void {
  if (!needCalcData || needCalcData.length === 0) {
    return;
  }
  let rowCount = 0;
  let time: string;
  let remainder = 0;
  for (let index = 0; index < needCalcData.length; index++) {
    Log.debug(TAG, `needCalcData-${JSON.stringify(needCalcData[index])}--${isYear}`);
    let item = needCalcData[index];
    if (remainder === 0) {
      rowCount = Math.ceil(item.count / gridRowCount);
      remainder = item.count % gridRowCount;
    } else {
      rowCount = (item.count - (gridRowCount - remainder)) / gridRowCount;
      if (rowCount >= 0) {
        rowCount = Math.ceil(rowCount);
      }
      if (rowCount < 0) {
        remainder = remainder + item.count;
      } else if (rowCount > 0) {
        remainder = (item.count - (gridRowCount - remainder)) % gridRowCount;
      } else if (rowCount === 0) {
        remainder = 0;
      }
    }
    if (isYear) {
      time = DateUtil.getLocalizedYearString(item.startDate as number);
    } else {
      time = DateUtil.getLocalizedYearAndMonth(item.startDate as number);
    }
    let gap: number = 0;
    const keepDecimals: number = 5;
    if (isYear) {
      gap = Number(((currentScrollerHeight - barBigHeight) * rowCount / allRowNum).toFixed(keepDecimals));
      Log.debug(TAG, `year-gapS${gap}---${time}`);
      if (gap < 0) {
        gap = 0;
      }
    }
    Log.debug(TAG, `currentRowAndGaps-${time}-${gap}-${rowCount}-${allRowNum}-${remainder}-${isYear}` +
      `-${currentScrollerHeight}-${barBigHeight}`);
    callBack(gap, time, rowCount);
  }
}

// 把以日为组的数据转换为以月为组
export function dayToMonth(dayData: TimelineData[]): TimelineData[] {
  let dateYearMonthDataResult: TimelineData[] = [];
  let yearMonthText = '';
  Log.debug(TAG, `yearMonthDataTmpLength:${dayData.length}`);
  // 把以日为组的数据转换为以月为组
  for (let i = 0; i < dayData.length; i++) {
    Log.debug(TAG, `yearMonthDataTmp:${JSON.stringify(dayData[i])}`);
    let time = DateUtil.getLocalizedYearAndMonth(dayData[i].startDate as number);
    if (yearMonthText === time) {
      dateYearMonthDataResult[dateYearMonthDataResult.length - 1].count += dayData[i].count;
    } else {
      dateYearMonthDataResult.push(JSON.parse(JSON.stringify(dayData[i])));
      yearMonthText = time;
    }
  }
  return dateYearMonthDataResult;
}