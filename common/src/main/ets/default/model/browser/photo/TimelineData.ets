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

import lazy { collections } from '@kit.ArkTS';

export interface GroupDataProvider {
  /**
   * 获取分组数据
   * @returns 分组数据
   */
  getGroupData(): TimelineData[];
}

@Sendable
export class TimelineData {
  public startDate: number = 0;
  public endDate: number = 0;
  public count: number = 0;
  public readonly dateDay?: string;

  constructor(startDate?: number, endDate?: number, count?: number, dateDay?: string) {
    if (startDate) {
      this.startDate = startDate;
    }
    if (endDate) {
      this.endDate = endDate;
    }
    if (count) {
      this.count = count;
    }
    if (dateDay) {
      this.dateDay = dateDay;
    }
  }

  /**
   * 转换TimelineData类型
   *
   * @param input collections.Array类型的TimelineData数据
   * @returns 数组类型的TimelineData数据
   */
  public static convertTimelineData(input: collections.Array<TimelineData>): TimelineData[] {
    let ret: TimelineData[] = [];
    if (!input || input.length <= 0) {
      return ret;
    }
    input.forEach((item: TimelineData) => {
      if (!item) {
        return;
      }
      let timelineData = new TimelineData(0, 0, 0, item.dateDay);
      timelineData.startDate = item.startDate;
      timelineData.endDate = item.endDate;
      timelineData.count = item.count;
      ret.push(timelineData);
    });
    return ret;
  }

  /**
   * 获取分组信息中key值
   * @returns
   */
  public getDateKey(): number {
    if (this.dateDay && this.dateDay !== '' && /^[0-9]+$/.test(this.dateDay)) {
      return parseInt(this.dateDay);
    }
    const startDate: Date = new Date(this.startDate);
    const year = String(startDate.getFullYear()); // 获取年份
    const month = String(startDate.getMonth() + 1).padStart(2, '0'); // 获取月份，并补零
    const day = String(startDate.getDate()).padStart(2, '0');
    return parseInt(`${year}${month}${day}`);
  }

  /**
   * 获取分组信息中dateDay值
   * @returns 分组的日信息
   */
  public getDateDayStr(): string {
     return this.getDateKey().toString();
  }
}