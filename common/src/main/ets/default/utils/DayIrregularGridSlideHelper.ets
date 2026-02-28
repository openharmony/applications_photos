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
import lazy { Constants } from '../model/common/Constants';
import lazy { DayIrregularGridScrollStrategy, GridScrollBaseStrategy } from './GridScrollBaseStrategy';
import lazy { GridScreenInfo } from './GridScreenInfo';
import lazy { GridScrollInfo, IrregularGridScrollInfo } from './GridScrollBaseHelper';
import lazy { GridSlideBaseHelper } from './GridSlideBaseHelper';
import lazy { ImageCacheUtil } from './ImageCacheUtil';
import lazy { Log } from '../utils/Log';
import lazy { Region } from './Region';
import lazy { TraceControllerUtils } from './TraceControllerUtils';
import lazy { ViewType } from '../model/browser/photo/ViewType';
import lazy { getScreen } from '../model/common/ScreenManager';
import lazy { TimelineData } from '../model/browser/photo/TimelineData';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { DayGridSlideHelper } from './DayGridSlideHelper';
import lazy Global from './GlobalContext';


const TAG: string = 'common_DayIrregularGridSlideHelper';

const ADDED_REGION: string = 'added';

const REMOVED_REGION: string = 'removed';

/**
 * Day view grid's slide helper.
 */
export class DayIrregularGridSlideHelper extends GridSlideBaseHelper {
  /**
   * Current frame num.
   */
  private frameNum: number = 0;
  /**
   * Slide info.
   */
  private scrollInfo?: IrregularGridScrollInfo;
  /**
   * Slide strategy.
   */
  private slideStrategy: GridScrollBaseStrategy = new DayIrregularGridScrollStrategy();
  /**
   * Previous visible region.
   */
  private lastVisibleRegion: Region = new Region('lastVis');
  /**
   * Current visible region.
   */
  private currentVisibleRegion: Region = new Region('curVis');
  /**
   * Previous preheat region.
   */
  private lastPreheatRegion: Region = new Region('lastPreheat');
  /**
   * Current preheat region.
   */
  private currentPreheatRegion: Region = new Region('curPreheat');
  /**
   * Ratio of preheat area in one side, which is the scale of the current window's grid element number.
   */
  private preheatRatio: number = 0.5;
  /**
   * Screen grid num.
   */
  private screenGridCnt: number = 0;
  /**
   * Max offset of grid.
   */
  private maxGridOffset: number = 0;
  /**
   * Maximum preheat count in one side computed by preheat ratio.
   */
  private maxPreheatCnt: number = 0;
  /**
   * Whether support preload.
   */
  private isPreloadSupported: boolean = false;
  /**
   * Regions to preload.
   */
  private addedRegions: Region[] = [];
  /**
   * Uris to preload.
   */
  private uriArrToPreload: string[] = [];
  /**
   * Height of window
   */
  private winHeight: number = getScreen().getWinHeight();
  /**
   * Height of time_title
   */
  private timeHeight: number = 72;
  /**
   * Height of imageGridItem
   */
  private imageGridItemHeight: number = 0;
  private gridColCnt: number = 0;
  private gutter: number = 0;
  /**
   * 是否需要清空宫格滚动条浏览场景下的极简MediaItems（仅定义最小集必须参数）。当滚动条浏览结束时，必须清空
   */
  private needClearSimpleMediaItems: boolean = false;

  constructor() {
    super();
    this.isPreloadSupported = this.isSupportPreload();
    Log.info(TAG, `DayIrregularGridSlideHelper is support preload:${this.isPreloadSupported}`);
  }

  public recordScrollInfo(scrollInfo: GridScrollInfo): void {
    if (scrollInfo === undefined || scrollInfo === null) {
      return;
    }
    this.scrollInfo = scrollInfo as IrregularGridScrollInfo;
  }

  /**
   * Handle scroll start event.
   */
  public handleScrollStart(): void {
    TraceControllerUtils.startTrace('Irregular day scrollStart');
    this.frameNum = 0;
    this.maxPreheatCnt = 0;
    this.lastVisibleRegion.reset();
    this.lastPreheatRegion.reset();
    this.currentPreheatRegion.reset();
    this.addedRegions = [];
    this.uriArrToPreload = [];
    this.gutter = DeviceInfo.isPc() ? Constants.PC_GRID_GUTTER : Constants.GRID_GUTTER;
    this.imageGridItemHeight = this.scrollInfo?.imageGridItemHeight ?? 0;
    this.timeHeight = this.scrollInfo?.timeTitleHeight ?? 0;
    let gridColumCnt: number = Math.floor(this.winHeight / (this.imageGridItemHeight + this.gutter));
    this.gridColCnt = this.scrollInfo?.gridRowCount ?? 0;
    this.screenGridCnt = gridColumCnt * this.gridColCnt;
    this.maxGridOffset =
      this.dataSource?.computeMaxGridOffset(this.imageGridItemHeight, this.timeHeight, this.gridColCnt) as number;
    TraceControllerUtils.finishTrace('Irregular day scrollStart');
    // 滑动开始时：
    // 针对其中的拖拽滚动条滚动停止场景，需要清空元数据的LRUCache缓存
    this.dataSource?.clearSimpleMediaItems();
    this.needClearSimpleMediaItems = false;
  }

  /**
   * Handle scroll stop event.
   */
  public handleScrollStop(): void {
    TraceControllerUtils.startTrace('day scrollStop');
    Log.info(TAG, 'Irregular slide stop');

    // 滚动结束时标志需要清空极简MediaItems
    this.needClearSimpleMediaItems = true;

    TraceControllerUtils.finishTrace('day scrollStop');
  }

  public handleScrollIndex(start: number, end: number): void {
    if (start < 0 || end < 0 || start > end) {
      return;
    }
    this.logTracker?.info(TAG, `handleScrollIndex, start:${start}, end:${end}`);

    if (this.needClearSimpleMediaItems) {
      this.dataSource?.clearSimpleMediaItems();
      this.needClearSimpleMediaItems = false;
    }
  }

  public handleWillScroll(offset: number, source: ScrollSource): number {
    if (!this.isPreloadSupported) {
      return offset;
    }
    if (offset === 0) {
      return offset;
    }
    if (this.scrollInfo === undefined || this.scrollInfo === null || this.scrollInfo.gridRowCount <= 0) {
      return offset;
    }

    this.frameNum++;
    let mediaCnt: number = this.dataSource?.totalCount() ?? 0;
    this.maxGridOffset = (this.scrollInfo.actionAndRefreshHeight ?? 0) + this.maxGridOffset;
    let globalOffset: number = this.scroller?.currentOffset().yOffset ?? 0;
    let curFrameGlobalOffset: number = globalOffset + offset;
    if (curFrameGlobalOffset < 0) {
      curFrameGlobalOffset = 0;
    } else if (curFrameGlobalOffset >= this.maxGridOffset) {
      curFrameGlobalOffset = this.maxGridOffset;
    }

    this.logTracker?.info(TAG, `++++++++++++frame:${this.frameNum}++++++++++++\n` +
      `handleWillScroll, globalOffset:${globalOffset}` +
      `, offset:${offset}, curFrameGlobalOffset:${curFrameGlobalOffset}` +
      `, maxGridOffset:${this.maxGridOffset}, mediaCnt:${mediaCnt}`);
    this.computePreheatRegion(curFrameGlobalOffset);
    this.startPreload();
    return offset;
  }

  /**
   * 预加载视图数据
   *
   * @param startIndex 左上第一个缩略图Index
   */
  public preloadViewData(startIndex: number): void {
    let gridScreenInfo: GridScreenInfo = this.slideStrategy.getGridScreenInfo();
    let gridRowCnt: number = Math.max(gridScreenInfo.screenGridRowNum, 0);
    let gridColCnt: number = 3;
    let screenGridCnt: number = gridRowCnt * gridColCnt;
    // 当前视图最后一个缩略图Index
    let endIndex: number = startIndex + screenGridCnt - 1;
    let addedRegions: Region[] = [];
    // 预加载数据超出总数据范围时需要矫正预加载范围，否则会导致数据预加载异常
    let totalCount: number = this.dataSource?.totalCount() ?? 0;
    if (endIndex > totalCount) {
      endIndex = totalCount - 1;
      startIndex = totalCount - screenGridCnt + 1;
    }
    addedRegions.push(new Region(ADDED_REGION, startIndex, endIndex));
    let uriArrToPreload: string[] = this.getURIsToHandlePreload(addedRegions);
    Log.info(TAG, `preloadViewData grid:[${gridRowCnt} * ${gridColCnt}, addedRegions:${addedRegions.join(';')}` +
      ` ${startIndex} to ${endIndex}, uriPreload:${uriArrToPreload.length}`);
    ImageCacheUtil.startCachingImages(uriArrToPreload);
  }

  /**
   * Check if support preload.
   *
   * @returns True means support preload.
   */
  private isSupportPreload(): boolean {
    return true;
  }

  /**
   * Compute the preheat region.
   *
   * @param curOffset Current global offset.
   */
  private computePreheatRegion(curGlobalOffset: number): void {
    if (this.gridColCnt <= 0 || this.imageGridItemHeight <= 0) {
      return;
    }
    let mediaCnt: number = this.dataSource?.totalCount() ?? 0;
    let currentPreOffset: number = curGlobalOffset - (this.scrollInfo?.actionAndRefreshHeight ?? 0);
    let startIndex: number = (currentPreOffset < 0) ? 0 : (currentPreOffset >= this.maxGridOffset) ? mediaCnt + 1 :
      this.dataSource?.computeStartIndex(currentPreOffset, this.imageGridItemHeight, this.timeHeight,
        this.gridColCnt) as number;

    let preloadEndIndex: number = startIndex + this.screenGridCnt > mediaCnt ?
      mediaCnt : startIndex + this.screenGridCnt - 1;
    let endIndex: number = preloadEndIndex;

    if (!this.lastVisibleRegion.isValid()) {
      this.lastVisibleRegion.start = startIndex;
      this.lastVisibleRegion.end = endIndex;
    } else {
      this.lastVisibleRegion.start = this.currentVisibleRegion.start;
      this.lastVisibleRegion.end = this.currentVisibleRegion.end;
      this.lastPreheatRegion.start = this.currentPreheatRegion.start;
      this.lastPreheatRegion.end = this.currentPreheatRegion.end;
    }

    // Compute current visible region.
    this.currentVisibleRegion.start = startIndex;
    this.currentVisibleRegion.end = endIndex;

    // Compute preheat count in each slide.
    this.maxPreheatCnt = Math.ceil(this.screenGridCnt * this.preheatRatio);

    // Compute current preheat region.
    this.currentPreheatRegion.start = (this.currentVisibleRegion.start - this.maxPreheatCnt < 0)
      ? 0 : this.currentVisibleRegion.start - this.maxPreheatCnt;
    if (mediaCnt > 0) {
      this.currentPreheatRegion.end = (this.currentVisibleRegion.end + this.maxPreheatCnt >= mediaCnt) ?
        mediaCnt : this.currentVisibleRegion.end + this.maxPreheatCnt;
    }
    this.logTracker?.info(TAG, 'computePreheatRegion' +
      `, startIndex:${startIndex}, endIndex:${endIndex}` +
      `, ${this.lastVisibleRegion.toString()}, ${this.currentVisibleRegion.toString()}` +
      `, ${this.lastPreheatRegion.toString()}, ${this.currentPreheatRegion.toString()}`);
  }

  /**
   * Start preload.
   */
  private startPreload(): void {
    // cancel previous preload.
    this.printRegionsInfo(TAG, 'previousRegionsToCancel', this.addedRegions);
    ImageCacheUtil.stopCachingImages(this.uriArrToPreload);

    // Compute the regions that needs to be incrementally cancelled based on the last cancelled region.
    let removedRegions: Region[] = this.getRegionsToRemove();
    let needStopPreload: boolean = this.needHandlePreload(removedRegions);

    // Compute the regions that needs to be incrementally preloaded based on the last preloaded region.
    this.addedRegions = this.getRegionsToAdd();
    let needPreload: boolean = this.needHandlePreload(this.addedRegions);
    this.uriArrToPreload = [];

    // If need start/stop preload, then launch it.
    if (needStopPreload) {
      this.printRegionsInfo(TAG, 'removedRegions', removedRegions);
      Log.info(TAG, 'removedRegions');
      let uriArrToStopPreload: string[] = this.getURIsToHandlePreload(removedRegions);
      ImageCacheUtil.stopCachingImages(uriArrToStopPreload);
    }
    if (needPreload) {
      Log.info(TAG, 'needPreload')
      this.printRegionsInfo(TAG, 'addedRegions', this.addedRegions);
      this.uriArrToPreload = this.getURIsToHandlePreload(this.addedRegions);
      ImageCacheUtil.startCachingImages(this.uriArrToPreload);
    }
  }

  /**
   * Check if need handle preload or cancel preload.
   *
   * @param regions Regions to handle.
   * @returns True means need handle.
   */
  private needHandlePreload(regions: Region[]): boolean {
    if (regions === undefined || regions === null || regions.length === 0) {
      return false;
    }
    for (let region of regions) {
      if (region !== undefined && region !== null && region.isValid()) {
        return true;
      }
    }
    return false;
  }

  /**
   * Obtaining incremental preloading regions.
   *
   * @returns Incremental preloading regions.
   */
  private getRegionsToAdd(): Region[] {
    let addedRegions: Region[] = [];
    if (!this.lastPreheatRegion.isValid()) {
      // When the grid is displayed for the first time, the top/bottom region needs to be preloaded.
      if (this.currentPreheatRegion.end > this.currentVisibleRegion.end) {
        addedRegions.push(new Region(ADDED_REGION, this.currentVisibleRegion.end + 1, this.currentPreheatRegion.end));
        this.logTracker?.info(TAG, 'grid first time shown');
      }
      if (this.currentPreheatRegion.start < this.currentVisibleRegion.start) {
        addedRegions.push(new Region(ADDED_REGION, this.currentPreheatRegion.start,
          this.currentVisibleRegion.start - 1));
        this.logTracker?.info(TAG, 'grid first time shown');
      }
      return addedRegions;
    }

    // Slide down or up. No intersection between the two regions. In this case we do not process preload.
    if (this.currentPreheatRegion.start > this.lastPreheatRegion.end ||
      this.currentPreheatRegion.end < this.lastPreheatRegion.start) {
      this.logTracker?.info(TAG, 'preheat regions not intersect, not add');
      return addedRegions;
    }

    // The new region at the bottom needs to be preloaded. Preload count is limited by max preheat count.
    if (this.currentPreheatRegion.end > this.lastPreheatRegion.end) {
      let maxLastRegionEnd: number = Math.max(this.lastPreheatRegion.end, this.currentVisibleRegion.end);
      addedRegions.push(new Region(ADDED_REGION, maxLastRegionEnd + 1, this.currentPreheatRegion.end));
      if (this.currentVisibleRegion.end > this.lastPreheatRegion.end) {
        this.logTracker?.info(TAG, `slide so fast that curVisEnd:${this.currentVisibleRegion.end}` +
          ` exceeds lastPreheatEnd:${this.lastPreheatRegion.end}`);
      }
    }

    // The new region on the top needs to be preloaded. Preload count is limited by max preheat count.
    if (this.currentPreheatRegion.start < this.lastPreheatRegion.start) {
      let minLastRegionStart: number = Math.min(this.lastPreheatRegion.start, this.currentVisibleRegion.start);
      addedRegions.push(new Region(ADDED_REGION, this.currentPreheatRegion.start, minLastRegionStart - 1));
      if (this.currentVisibleRegion.start < this.lastPreheatRegion.start) {
        this.logTracker?.info(TAG, `slide so fast that curVisStart:${this.currentVisibleRegion.start}` +
          ` exceeds lastPreheatStart:${this.lastPreheatRegion.start}`);
      }
    }
    return addedRegions;
  }

  /**
   * Obtain incremental cancel preload regions.
   *
   * @returns Incremental cancel preload regions.
   */
  private getRegionsToRemove(): Region[] {
    let removedRegions: Region[] = [];
    if (!this.lastPreheatRegion.isValid()) {
      return removedRegions;
    }

    // Slide down or up. No intersection between the two regions. In this case we do not process cancel preload.
    if (this.currentPreheatRegion.start > this.lastPreheatRegion.end ||
      this.currentPreheatRegion.end < this.lastPreheatRegion.start) {
      this.logTracker?.info(TAG, 'preheat regions not intersect, not remove');
      return removedRegions;
    }

    // The disappearing region on the top needs to be cancelled.
    if (this.currentPreheatRegion.start > this.lastPreheatRegion.start) {
      let minLastRegionStart: number = Math.min(this.lastVisibleRegion.start, this.currentPreheatRegion.start);
      removedRegions.push(new Region(REMOVED_REGION, this.lastPreheatRegion.start, minLastRegionStart - 1));
    }

    // The disappearing region at the bottom needs to be cancelled.
    if (this.currentPreheatRegion.end < this.lastPreheatRegion.end) {
      let maxLastRegionEnd: number = Math.max(this.lastVisibleRegion.end, this.currentPreheatRegion.end);
      removedRegions.push(new Region(REMOVED_REGION, maxLastRegionEnd + 1, this.lastPreheatRegion.end));
    }
    return removedRegions;
  }

  /**
   * Obtain URIs to handle preload.
   *
   * @param regions Regions to handle preload.
   * @returns URIs to handle preload.
   */
  private getURIsToHandlePreload(regions: Region[]): string[] {
    if (regions === undefined || regions === null || regions.length === 0) {
      return [];
    }
    if (this.dataSource === undefined || this.dataSource === null) {
      return [];
    }

    let uriArr: string[] = [];
    for (let region of regions) {
      if (region === undefined || region === null || !region.isValid()) {
        continue;
      }
      for (let index: number = region.start; index <= region.end; index++) {
        uriArr.push(this.dataSource?.getRawData(index)?.thumbnail ?? '');
      }
    }
    return uriArr;
  }
}