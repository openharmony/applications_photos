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
import type { TimelineData } from '../browser/photo/TimelineData';
import lazy taskpool from '@ohos.taskpool';
import type { DateYearMontCapsule } from '../../utils/timelineScrollBarUtils';
import lazy { calcRowAndGaps, TASKPOOL_TAG } from '../../utils/timelineScrollBarUtils';
import { HashMap } from '@kit.ArkTS';
import lazy { DateUtil } from '../../utils/DateUtil';

/* instrument ignore file */
const TAG = 'TimelineScrollBarManager';
const GROUP_TITLE_HEIGHT: number = 68;
const ACCURACY: number = 10;
const YEAR_INDEX: number = 4;

export class DateCapsule {
  public gap: number = 0;
  public yearTime: string = '';
  public top: number = 0;
  public rowCount: number = 0;
}

export class YearDateCapsule {
  public gap: number = 0;
  public yearTime: string = '';
  public top: number = 0;
  public groupHeight: number = 0;
}

// taskpool执行的任务-获取到每行对应年月值的map
function calcEveryRowData(yearMonthData: string, allRowNum: number, gridRowCount: number,
  currentScrollerHeight: number, barBigHeight: number): Map<number, string> | void {
  'use concurrent';
  Log.debug(TASKPOOL_TAG, 'calcEveryRowDataInit');
  let yearMonthDataTmp: TimelineData[] = JSON.parse(yearMonthData);
  if (!yearMonthDataTmp) {
    Log.error(TASKPOOL_TAG, 'yearMonthDataTmp length is 0 or null');
    return undefined;
  }

  // 日分组数据转换为月分组数据
  let dateYearMonthDataResult: TimelineData[] = yearMonthDataTmp;

  // 计算出所有分组的行数及占滚动条的距离
  let dateYearMonthData: DateYearMontCapsule[] = [];
  calcRowAndGaps(dateYearMonthDataResult, false, gridRowCount, currentScrollerHeight,
    allRowNum, barBigHeight, (gap: number, time: string, rowCount: number): void => {
      dateYearMonthData.push({
        yearMonthText: time,
        rowCount
      });
    });

  // 每行对应的年月转换为map 方便直查
  Log.debug(TASKPOOL_TAG, `getYearMonthDateLength:${dateYearMonthData.length}`);
  let yearMonthRowMap: Map<number, string> = new Map();
  let currentIndex = 0;
  for (let index = 0; index < dateYearMonthData.length; index++) {
    for (let i = 0; i < dateYearMonthData[index].rowCount; i++) {
      yearMonthRowMap.set(currentIndex, dateYearMonthData[index].yearMonthText);
      currentIndex++;
    }
  }
  return yearMonthRowMap;
}

// taskpool执行的任务-获取到年胶囊分布
function calcYearData(yearData: string, allRowNum: number, gridRowCount: number, currentScrollerHeight: number,
  barBigHeight: number, marginTopTmp: number, smallDateCapsuleHeight: number): DateCapsule[] {
  'use concurrent';
  Log.debug(TASKPOOL_TAG, 'calcYearDataInit');
  let yearDataTmp: TimelineData[] = JSON.parse(yearData);
  if (!yearDataTmp) {
    Log.error(TASKPOOL_TAG, 'yearDataTmp length is 0 or null');
    return [];
  }
  let bottomArr: DateCapsule[] = [];
  calcRowAndGaps(yearDataTmp, true, gridRowCount, currentScrollerHeight, allRowNum, barBigHeight,
    (gap: number, time: string, rowCount: number): void => {
      bottomArr.push({
        gap,
        yearTime: time,
        rowCount: rowCount,
        top: 0,
      });
    }, true);
  let resultBottomArr: DateCapsule[] = [];
  let marginBottomTmp: number = 0;
  const intervalCapsule: number = 2;
  for (let index = 0; index < bottomArr.length; index++) {
    Log.debug(TASKPOOL_TAG, `bottomArr-item:${JSON.stringify(bottomArr[index])}}`);
    // 避让，避免重叠
    if (bottomArr[index].gap >= smallDateCapsuleHeight + intervalCapsule) {
      resultBottomArr.push({
        yearTime: bottomArr[index].yearTime,
        gap: marginBottomTmp + bottomArr[index].gap - smallDateCapsuleHeight,
        top: resultBottomArr.length === 0 ? marginTopTmp : 0,
        rowCount: bottomArr[index].rowCount,
      });
      marginBottomTmp = 0;
    } else {
      if (resultBottomArr.length > 0) {
        resultBottomArr[resultBottomArr.length - 1].gap += bottomArr[index].gap;
        resultBottomArr[resultBottomArr.length - 1].rowCount += bottomArr[index].rowCount;
      } else {
        marginTopTmp += bottomArr[index].gap;
      }
    }
    Log.debug(TASKPOOL_TAG, `resultBottomArrItem---${bottomArr[index].gap - smallDateCapsuleHeight}`);
  }
  return resultBottomArr;
}

/**
 * 照片宮格页滚动条工具类
 */
export class TimelineScrollBarManager {
  private needCalcData: string = '';
  private allRowNum: number = 0;
  private gridRowCount: number = 0;
  private currentScrollerHeight: number = 0;
  private barBigHeight: number = 0;
  private marginTopTmp: number = 0;
  private smallDateCapsuleHeight: number = 0;
  public isYearLeft: boolean = false;
  public eachRowHeight: number = 0;
  private isGroupView: boolean = false;
  private totalCount: number = 0;
  private groups: TimelineData[] = [];
  private timeTitleHeight: number | undefined = 0;
  private imageGridItemHeight: number = 0;
  private countD: number = 4;

  public setIsGroupView(isGroupView: boolean): void {
    this.isGroupView = isGroupView;
  }

  public setTotalCount(totalCount: number): void {
    this.totalCount = totalCount;
  }

  public setGroups(groups: TimelineData[]): void {
    this.groups = groups;
  }

  public setTimeTitleHeight(timeTitleHeight: number | undefined): void {
    this.timeTitleHeight = timeTitleHeight;
  }

  public setImageGridItemHeight(imageGridItemHeight: number): void {
    this.imageGridItemHeight = imageGridItemHeight;
  }

  public setParams(needCalcData: string, allRowNum: number, gridRowCount: number, currentScrollerHeight: number,
    barBigHeight: number, marginTopTmp?: number, smallDateCapsuleHeight?: number): void {
    this.needCalcData = needCalcData;
    this.allRowNum = allRowNum;
    this.gridRowCount = gridRowCount;
    this.currentScrollerHeight = currentScrollerHeight;
    this.barBigHeight = barBigHeight;
    if (marginTopTmp) {
      this.marginTopTmp = marginTopTmp;
    }
    if (smallDateCapsuleHeight) {
      this.smallDateCapsuleHeight = smallDateCapsuleHeight;
    }
  }

  // 获取年月胶囊每行对应日期任务池
  public async dateYearMonthDataTask(): Promise<Map<number, string> | void> {
    // 实例化taskpool并执行
    try {
      Log.debug(TAG, 'dateYearMonthDataTaskInit');
      let result: Map<number, string> | void = calcEveryRowData(this.needCalcData, this.allRowNum,
        this.gridRowCount, this.currentScrollerHeight, this.barBigHeight);
      if (result) {
        return result;
      } else {
        return new Map();
      }
    } catch (e) {
      Log.debug(TAG, `taskpool execute error is: ${JSON.stringify(e)}`);
    }
    return undefined;
  }

  // 获取年胶囊固定排布
  public async dateYearDataTask(): Promise<DateCapsule[] | void> {
    // 实例化taskpool并执行
    try {
      Log.info(TAG, 'dateYearDataTask:' + this.isGroupView);
      if (this.isGroupView) {
        return this.handleGroupDayCapsule();
      }
      let task: taskpool.Task = new taskpool.Task(calcYearData, this.needCalcData, this.allRowNum,
        this.gridRowCount, this.currentScrollerHeight, this.barBigHeight, this.marginTopTmp,
        this.smallDateCapsuleHeight);
      let result = await taskpool.execute(task) as DateCapsule[];
      if (result) {
        return result;
      } else {
        return [];
      }
    } catch (e) {
      Log.debug(TAG, `taskpool execute error is: ${JSON.stringify(e)}`);
    }
    return undefined;
  }

  /**
   * 分组视图年份胶囊分布计算原则
   * 计算当前年份的每个分组中缩略图高度和日期标题高度并累加得到当前年份的高度，根据当前年份高度占所有图片的总高度的比例得到当前年份的占比
   */
  private handleGroupDayCapsule(): DateCapsule[] {
    let yearGapMap: HashMap<string, number> = new HashMap<string, number>();
    let currentGroupTitleHeight: number = GROUP_TITLE_HEIGHT;
    // 分组标题高度无效时使用默认高度
    if (this.timeTitleHeight) {
      currentGroupTitleHeight = this.timeTitleHeight;
    }
    if (this.gridRowCount <= 0) {
      this.gridRowCount = this.countD - 1;
    }
    let initTotalHeight: number = Math.ceil(this.totalCount / this.gridRowCount) * this.imageGridItemHeight +
      this.groups?.length * currentGroupTitleHeight;
    let totalHeight: number = 0;
    Log.info(TAG, `handleGroupDayCapsule totalCount:${this.totalCount} groups:${this.groups?.length} ` +
      `currentScrollerHeight:${this.currentScrollerHeight} bigHeight:${this.barBigHeight} timeTitleHeight:` +
      `${this.timeTitleHeight} imageGridItemHeight:${this.imageGridItemHeight} initTotalHeight:${initTotalHeight} ` +
      `gridRowCount:${this.gridRowCount} smallDateCapsuleHeight:${this.smallDateCapsuleHeight} ${this.marginTopTmp}`);
    if (this.groups && this.totalCount > 0) {
      let groupLength: number = this.groups?.length ?? 0;
      // 遍历所有日期分组，计算每个分组占当前屏幕的gap
      for (let index = 0; index < groupLength; index++) {
        let dateDay: string = this.groups[index].dateDay ?? '';
        let count: number = this.groups[index].count;
        let rowImageCount: number = Math.ceil(count / this.gridRowCount);
        // 每个分组都有一行标题
        // 当前分组的总高度等于缩略图的总高度加分组标题的高度
        let groupHeight: number = rowImageCount * this.imageGridItemHeight + currentGroupTitleHeight;
        totalHeight += groupHeight;
        // 按年份合并当前年份的所有分组行数
        let year: string = dateDay?.substring(0, YEAR_INDEX);
        if (yearGapMap.hasKey(year)) {
          let currentGroupHeight: number = yearGapMap.get(year) as number;
          currentGroupHeight += groupHeight;
          yearGapMap.set(year, currentGroupHeight);
        } else {
          yearGapMap.set(year, groupHeight);
        }
        Log.debug(TAG, `handleGroupDayCapsule:${index} year:${year} dateDay:${dateDay} ` +
          `count:${count} gridRowCount:${this.gridRowCount} rowImageCount:${rowImageCount} groupHeight:${groupHeight} ` +
          `totalHeight:${totalHeight}`);
      }
      let groupCapsuleResult: YearDateCapsule[] = this.calcCurrentYearGap(yearGapMap, totalHeight);
      Log.info(TAG, `handleGroupDayCapsule ${totalHeight} ${JSON.stringify(groupCapsuleResult)}`);
      if (groupCapsuleResult && groupCapsuleResult.length > 0) {
        return this.compareGapWithThreshold(groupCapsuleResult);
      }
    } else {
      Log.info(TAG, `handleGroupDayCapsule groups null totalCount:${this.totalCount} ${this.gridRowCount}`);
    }
    return [];
  }

  private calcCurrentYearGap(yearGapMap: HashMap<string, number>, totalHeight: number): YearDateCapsule[] {
    let groupCapsuleResult: YearDateCapsule[] = [];
    if (totalHeight > 0) {
      let difference : number = this.currentScrollerHeight - this.barBigHeight;
      // 按年份计算当前年份的gap
      yearGapMap?.forEach((groupHeight: number, year: string) => {
        let currentGap: number = Number((difference * groupHeight / totalHeight).toFixed(ACCURACY));
        groupCapsuleResult.push({
          yearTime: year,
          gap: currentGap,
          top: 0,
          groupHeight: groupHeight,
        });
        Log.debug(TAG, `calcCurrentYearGap year:${year} groupHeight:${groupHeight} Gap:${currentGap}`);
      });
    }
    // 按照年份降序排序
    groupCapsuleResult.sort((dateCapsule1, dateCapsule2) => {
      return parseInt(dateCapsule2.yearTime) - parseInt(dateCapsule1.yearTime);
    });
    return groupCapsuleResult;
  }

  private compareGapWithThreshold(groupCapsuleResult: YearDateCapsule[]): DateCapsule[] {
    let gapThreshold: number = this.smallDateCapsuleHeight + 2;
    let resultGapArr: DateCapsule[] = [];
    // 判断当前年份的gap值是否大于gap阈值，大于阈值则显示当前年份日期胶囊，小于阈值则将当前年份gap值合并到上一个年份
    for (let index = 0; index < groupCapsuleResult.length; index++) {
      let yearDateCapsule: YearDateCapsule = groupCapsuleResult[index];
      const dateYear = new Date(yearDateCapsule.yearTime);
      let yearTime: string = DateUtil.getLocalizedYearString(dateYear.getTime());
      let groupHeight: number = yearDateCapsule.groupHeight;
      let currentGap: number = yearDateCapsule.gap;
      // 避让，避免重叠
      if (currentGap >= gapThreshold) {
        resultGapArr.push({
          yearTime: yearTime,
          gap: currentGap - this.smallDateCapsuleHeight,
          top: resultGapArr.length === 0 ? this.marginTopTmp : 0,
          rowCount: 0,
        });
      } else {
        if (resultGapArr.length > 0) {
          resultGapArr[resultGapArr.length - 1].gap += currentGap;
        } else {
          this.marginTopTmp += currentGap;
        }
      }
      Log.debug(TAG, `handleGroupDayCapsule yearTime:${yearTime} gapThreshold:${gapThreshold} ` +
        `groupHeight:${groupHeight} marginTopTmp:${this.marginTopTmp} gap:${currentGap}`);
    }
    Log.info(TAG, `handleGroupDayCapsule ${JSON.stringify(resultGapArr)}`);
    return resultGapArr;
  }
}