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
/**
 * 大图浏览请求高质量耗时级别
 */
import lazy { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG: string = 'common_BrowserCostReportManager';

enum BrowserRequestCostLevel {
  /**
   * 请求高质量图耗时 500ms以内
   */
  REQUEST_COST_LEVEL_FIRST = 500,

  /**
   * 请求高质量图耗时 1000ms以内
   */
  REQUEST_COST_LEVEL_SECOND = 1000,

  /**
   * 请求高质量图耗时 2000ms以内
   */
  REQUEST_COST_LEVEL_THIRD = 2000,

  /**
   * 请求高质量图耗时 4000ms以内
   */
  REQUEST_COST_LEVEL_FOURTH = 4000,

  /**
   * 请求高质量图耗时 超过4000ms,或没有返回结果
   */
  REQUEST_COST_LEVEL_DEFAULT = -1
}

/**
 * 大图浏览停留时间耗时级别
 */
enum BrowserSwitchCostLevel {
  /**
   * 大图浏览切换停留 1s以内
   */
  REQUEST_COST_LEVEL_FIRST = 1,

  /**
   * 大图浏览切换停留 3s以内
   */
  REQUEST_COST_LEVEL_SECOND = 3,

  /**
   * 大图浏览切换停留 5s以内
   */
  REQUEST_COST_LEVEL_THIRD = 5,

  /**
   * 大图浏览切换停留 10s以内
   */
  REQUEST_COST_LEVEL_FOURTH = 10,

  /**
   * 大图浏览切换停留 超过10s的
   */
  REQUEST_COST_LEVEL_DEFAULT = -1
}

interface BrowserCostInfo {
  photoBrowserCount: number, // 大图浏览数量
  photoSwitchIntervalCount: string, //浏览切换间隔信息
  requestImageCost: string //请求高质量耗时信息
}


export class BrowserCostReportManager {
  private requestImageCostMap: Map<BrowserRequestCostLevel, number> = new Map();
  private switchCostMap: Map<BrowserSwitchCostLevel, number> = new Map();
  private lastSwitchTime: number = Date.now();
  private browserCount: number = 0;
  private static instance: BrowserCostReportManager = new BrowserCostReportManager();

  private constructor() {
  }

  clear(): void {
    this.requestImageCostMap.clear();
    this.switchCostMap.clear();
  }

  public static getInstance(): BrowserCostReportManager {
    return BrowserCostReportManager.instance;
  }

  public resetCostInfo(): void {
    Log.info(TAG, 'reset browser cost info');
    this.lastSwitchTime = Date.now();
    this.browserCount = 0;
    this.clear();
  }

  /* instrument ignore next */
  public switch(): void {
    Log.info(TAG, 'browser switch');
    this.browserCount++;
    let currentTime = Date.now();
    let costSecond = (currentTime - this.lastSwitchTime) / DateUtil.MILLISECONDS_PER_SECOND;
    this.lastSwitchTime = currentTime;
    if (costSecond <= BrowserSwitchCostLevel.REQUEST_COST_LEVEL_FIRST) {
      this.switchCountStep(BrowserSwitchCostLevel.REQUEST_COST_LEVEL_FIRST);
    } else if (costSecond <= BrowserSwitchCostLevel.REQUEST_COST_LEVEL_SECOND) {
      this.switchCountStep(BrowserSwitchCostLevel.REQUEST_COST_LEVEL_SECOND);
    } else if (costSecond <= BrowserSwitchCostLevel.REQUEST_COST_LEVEL_THIRD) {
      this.switchCountStep(BrowserSwitchCostLevel.REQUEST_COST_LEVEL_THIRD);
    } else if (costSecond <= BrowserSwitchCostLevel.REQUEST_COST_LEVEL_FOURTH) {
      this.switchCountStep(BrowserSwitchCostLevel.REQUEST_COST_LEVEL_FOURTH);
    } else {
      this.switchCountStep(BrowserSwitchCostLevel.REQUEST_COST_LEVEL_DEFAULT);
    }
  }

  /* instrument ignore next */
  private switchCountStep(costLevel: BrowserSwitchCostLevel) {
    let count = this.switchCostMap.get(costLevel);
    count = count ? ++count : 1;
    this.switchCostMap.set(costLevel, count);
  }

  public requestImage(durationTime: number) {
    Log.info(TAG, 'request Image');
    if (durationTime <= BrowserRequestCostLevel.REQUEST_COST_LEVEL_FIRST) {
      this.requestImageCountStep(BrowserRequestCostLevel.REQUEST_COST_LEVEL_FIRST);
    } else if (durationTime <= BrowserRequestCostLevel.REQUEST_COST_LEVEL_SECOND) {
      this.requestImageCountStep(BrowserRequestCostLevel.REQUEST_COST_LEVEL_SECOND);
    } else if (durationTime <= BrowserRequestCostLevel.REQUEST_COST_LEVEL_THIRD) {
      this.requestImageCountStep(BrowserRequestCostLevel.REQUEST_COST_LEVEL_THIRD);
    } else if (durationTime <= BrowserSwitchCostLevel.REQUEST_COST_LEVEL_FOURTH) {
      this.requestImageCountStep(BrowserRequestCostLevel.REQUEST_COST_LEVEL_FOURTH);
    } else {
      this.requestImageCountStep(BrowserRequestCostLevel.REQUEST_COST_LEVEL_DEFAULT);
    }

  }

  /* instrument ignore next */
  private requestImageCountStep(costLevel: BrowserRequestCostLevel) {
    let count = this.requestImageCostMap.get(costLevel);
    count = count ? ++count : 1;
    this.requestImageCostMap.set(costLevel, count);
  }

  public report(): void {
    // 上报前需要统计最后一张浏览图的switch 耗时
    this.switch();
    let msg: BrowserCostInfo = {
      photoBrowserCount: this.browserCount,
      photoSwitchIntervalCount: this.generateSwitchReportInfo(),
      requestImageCost: this.generateRequestReportInfo(),
    };
    Log.info(TAG, `cost report:${JSON.stringify(msg)}`);
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_BROWSER_COST_INFO, msg);
  }

  private generateSwitchReportInfo(): string {
    return `<1s:${
    this.mapGetOrDefault(this.switchCostMap, BrowserSwitchCostLevel.REQUEST_COST_LEVEL_FIRST, 0)},<3s:${
    this.mapGetOrDefault(this.switchCostMap, BrowserSwitchCostLevel.REQUEST_COST_LEVEL_SECOND, 0)}, <5s:${
    this.mapGetOrDefault(this.switchCostMap, BrowserSwitchCostLevel.REQUEST_COST_LEVEL_THIRD, 0)}, <10s:${
    this.mapGetOrDefault(this.switchCostMap,
      BrowserSwitchCostLevel.REQUEST_COST_LEVEL_FOURTH,
      0)},>=10s:${this.mapGetOrDefault(this.switchCostMap, BrowserSwitchCostLevel.REQUEST_COST_LEVEL_DEFAULT, 0)}`;
  }


  private generateRequestReportInfo(): string {
    return `<500ms:${
    this.mapGetOrDefault(this.requestImageCostMap, BrowserRequestCostLevel.REQUEST_COST_LEVEL_FIRST, 0)},<1000ms:${
    this.mapGetOrDefault(this.requestImageCostMap, BrowserRequestCostLevel.REQUEST_COST_LEVEL_SECOND, 0)}, <2000ms:${
    this.mapGetOrDefault(this.requestImageCostMap, BrowserRequestCostLevel.REQUEST_COST_LEVEL_THIRD, 0)}, <4000ms:${
    this.mapGetOrDefault(this.requestImageCostMap,
      BrowserRequestCostLevel.REQUEST_COST_LEVEL_FOURTH,
      0)},>=4000ms:${
    this.mapGetOrDefault(this.requestImageCostMap, BrowserRequestCostLevel.REQUEST_COST_LEVEL_DEFAULT, 0)}`;
  }

  /* instrument ignore next */
  private mapGetOrDefault<T>(paramMap: Map<Object, T>, key: Object, defaultValue: T): T {
    let value = paramMap.get(key);
    return value ?? defaultValue;
  }
}