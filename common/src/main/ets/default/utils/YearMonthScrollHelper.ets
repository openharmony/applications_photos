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

import lazy { ApsUtil } from '../utils/ApsUtil';
import lazy { Log } from './Log';
import lazy { Region } from './Region';
import lazy { YearMonthMediaDataSource } from '../model/browser/photo/YearMonthMediaDataSource';
import lazy { GridDragScrollBaseHelper } from './GridDragScrollBaseHelper';
import lazy { GridScrollInfo, YearMonthGridScrollInfo } from './GridScrollBaseHelper';
import lazy { TraceControllerUtils } from '../utils/TraceControllerUtils';
import lazy { Priority, YearMonthQueryParam } from '../model/browser/photo/YearMonthQueryParam';
import lazy { YearMonthMediaItem } from '../model/browser/photo/YearMonthMediaItem';
import lazy { YearMonthUtil } from '../model/browser/photo/YearMonthUtil';
import lazy { YearMonthViewData, YearMonthViewDataBuilder } from '../model/browser/photo/YearMonthViewData';

/* instrument ignore file */
const TAG: string = 'YearMonthScrollHelper';

export class YearMonthScrollHelper extends GridDragScrollBaseHelper {
  /**
   * 区分年月视图使用标识
   */
  private scrollFlag: string = '';
  /**
   * 默认年月行数均为10行
   */
  private rows: number = 10;
  /**
   * 年月视图第一个item显示日期，不显示图片数据，增加偏移量
   */
  private firstGridItemOffset: number = 1;
  /**
   * 年月视图的列数
   */
  private column: number = 0;
  /**
   * 前一次预加载坐标偏移量
   */
  private lastPreloadOffset: number = 0;
  /**
   * 当前预加载坐标偏移量
   */
  private currentPreloadOffset: number = 0;
  /**
   * 预加载数据
   */
  private preloadData: YearMonthViewData[] = [];
  /**
   * 上次预加载的数据
   */
  private lastPreloadRegion: Region[] = [];
  /**
   * 本次待预加载的数据
   */
  private currentPreloadRegion: Region[] = [];
  /**
   * 每个视图控件的最大高度
   */
  private maxHeightPerGroup: number = 0;
  /**
   * 每个视图控件的最大宽度, 即屏幕的尺寸宽度
   */
  private maxWidthPerGroup: number = 0;
  /**
   * 屏幕的高度
   */
  private screenHeight: number = 0;
  /**
   * 每个视图控件最多显示的图片数量
   */
  private maxCountPerGroup: number = 0;
  /**
   * 上次预加载的起始位置
   */
  private lastStartIndex: number = -1;
  /**
   * 上次预加载的end位置
   */
  private lastEndIndex: number = -1;
  /***
   * 可视区域的高度
   */
  private currentShowAreaHeight: number = 0;
  /***
   * 计算当前屏幕最多展示多少视图控件数量
   */
  private maxViewNumPerScreen: number = 0;
  /**
   * 滑动信息
   */
  private scrollInfo?: YearMonthGridScrollInfo;
  /**
   * 占位标识
   */
  private fillPostion: number = 0;

  public recordScrollInfo(scrollInfo: GridScrollInfo): void {
    if (scrollInfo === undefined || scrollInfo === null) {
      Log.error(TAG, 'scrollInfo is undefined');
      return;
    }
    this.scrollInfo = scrollInfo as YearMonthGridScrollInfo;
    if (this.scrollInfo?.columns !== 0) {
      this.maxHeightPerGroup = this.maxWidthPerGroup / this.scrollInfo?.columns * this.rows;
    }
    this.maxCountPerGroup = this.scrollInfo?.columns * this.rows;
    this.scrollFlag = this.scrollInfo?.scrollFlag;
    this.column = this.scrollInfo?.columns;
    this.currentShowAreaHeight = this.screenHeight;
    if (this.maxHeightPerGroup !== 0) {
      this.maxViewNumPerScreen = this.currentShowAreaHeight / (this.maxHeightPerGroup);
    }
    this.fillPostion = this.scrollInfo?.fillPostion ?? 0;
  }

  public handleScrollStart(): void {
    TraceControllerUtils.startTrace('yearMonth scrollStart');
    Log.info(TAG, 'handleScrollStart');
    (this.dataSource as YearMonthMediaDataSource).setAccessDataFlag(true);
    // ImageCacheUtil.enableH8();
    TraceControllerUtils.finishTrace('yearMonth scrollStart');
  }

  public handleScrollStop(): void {
    TraceControllerUtils.startTrace('yearMonth scrollStop');
    Log.info(TAG, 'handleScrollStop');
    (this.dataSource as YearMonthMediaDataSource).setAccessDataFlag(false);
    this.lastPreloadOffset = 0;
    this.currentPreloadOffset = 0;
    this.lastPreloadRegion = [];
    this.currentPreloadRegion = [];
    // ImageCacheUtil.resetH8();
    TraceControllerUtils.finishTrace('yearMonth scrollStop');
  }

  public setWinSize(width: number, height: number) {
    Log.info(TAG, `setWinSize width:${width} height:${height}`);
    this.maxWidthPerGroup = width;
    this.screenHeight = height;
  }

  public handleWillScroll(offset: number, source: ScrollSource): number {
    // 拖动滚动条离手后停止宫格滚动
    if (source === ScrollSource.SCROLL_BAR_FLING) {
      return 0;
    }
    if (source !== ScrollSource.SCROLL_BAR) {
      return offset;
    }

    // 拖动滚动条场景走错帧预加载方案
    this.lastPreloadOffset = this.currentPreloadOffset;
    this.currentPreloadOffset = offset;
    this.cancelLastMediaItemQuery();
    this.computePreloadInfo(offset, this.scroller?.currentOffset()?.yOffset ?? 0);
    this.startPreload();
    return this.lastPreloadOffset;
  }

  /**
   * 预加载视图数据
   *
   * @param startIndex 左上第一个缩略图Index
   */
  public preloadViewData(startIndex: number): void {
    this.createPreloadData(startIndex, true);
    this.startPreload();
  }

  private computePreloadInfo(offset: number, currentPosition: number): void {
    this.preloadData = [];
    if (!this.dataSource) {
      return;
    }
    if (offset === 0) {
      return;
    }

    if (this.maxHeightPerGroup - this.firstGridItemOffset === 0) {
      return;
    }
    // 计算预期加载的视图控件起始位置: 当前位置+当前帧预期移动的位置+下一帧预偏移的位置
    let start: number =
      (currentPosition + this.lastPreloadOffset + offset) / this.maxHeightPerGroup - this.firstGridItemOffset;
    if (start < 0) {
      start = 0;
    }
    this.createPreloadData(start);
  }

  private createPreloadData(start: number, isForceSyncQuery?: boolean): void {
    if (!this.dataSource) {
      return;
    }
    let startIndex: number = Math.floor(start);
    let endIndex: number = Math.ceil(start + this.maxViewNumPerScreen);
    // 预加载数据超出总数据范围时需要矫正预加载范围，否则会导致数据预加载异常
    let totalCount: number = this.dataSource?.totalCount() ?? 0;
    let maxIndex: number = 0;
    if (this.maxCountPerGroup > 0) {
      maxIndex = totalCount / this.maxCountPerGroup;
    }
    if (endIndex > maxIndex) {
      endIndex = totalCount - 1;
      startIndex = totalCount - this.maxViewNumPerScreen + 1;
    }
    Log.info(TAG, `preloadViewData startIndex:${startIndex}, endIndex:${endIndex}, maxIndex:${maxIndex}` +
      `, ${this.maxCountPerGroup}, ${this.maxViewNumPerScreen}`);
    if (this.lastStartIndex === startIndex && this.lastEndIndex === endIndex) {
      return;
    }

    if (startIndex < 0) {
      startIndex = 0;
    }

    this.lastStartIndex = startIndex;
    this.lastEndIndex = endIndex;

    // 根据预加载的视图控件个数计算每个预加载的视图控件的mediaItem信息
    this.currentPreloadRegion = [];
    for (let index = startIndex; index <= endIndex; index++) {
      let start: number = index * this.maxCountPerGroup;
      let count: number = Math.min(this.maxCountPerGroup, this.dataSource.mediaCount - start);
      if (count <= 0) {
        return;
      }
      this.currentPreloadRegion.push(new Region('preload', start, start + count - 1));

      // 过滤上次已预加载的区域
      if (this.hasPreloaded(start, start + count - 1)) {
        continue;
      }

      let queryParam: YearMonthQueryParam = new YearMonthQueryParam(
        start, count, Priority.HIGH, true, isForceSyncQuery);
      let mediaItems: YearMonthMediaItem[] | undefined = this.queryMediaItems(queryParam);
      if (mediaItems.length === 0) {
        continue;
      }

      if (this.dataSource instanceof YearMonthMediaDataSource && this.maxCountPerGroup > 0) {
        let viewKey: string = YearMonthUtil.generateYearMonthViewKey(this.scrollFlag,
          this.maxCountPerGroup, this.column, start / this.maxCountPerGroup, this.fillPostion);
        let viewData: YearMonthViewData | undefined = (this.dataSource as YearMonthMediaDataSource)
          .getYearMonthDataManager().getCachedViewData(viewKey);
        if (viewData) {
          viewData.updateViewDataIfNeed(this.scrollFlag, this.maxWidthPerGroup, mediaItems, count);
        } else {
          viewData = new YearMonthViewDataBuilder()
            .viewKey(viewKey)
            .currentView(this.scrollFlag)
            .viewWidth(this.maxWidthPerGroup)
            .column(this.column)
            .groupIndex(index)
            .fillPosition(this.fillPostion)
            .build(mediaItems, count);
        }
        (this.dataSource as YearMonthMediaDataSource).getYearMonthDataManager().cacheViewData(viewKey, viewData);
        this.preloadData.push(viewData);
      }
      if (count < this.maxCountPerGroup) {
        break;
      }
    }
  }

  private queryMediaItems(queryParam: YearMonthQueryParam): YearMonthMediaItem[] {
    // if (this.dataSource instanceof YearMonthMediaDataSource) {
    //   return (this.dataSource as YearMonthMediaDataSource).queryMediaItems(queryParam);
    // }
    return [];
  }

  private cancelQueryMediaItems(queryParam: YearMonthQueryParam): void {
    if (this.dataSource instanceof YearMonthMediaDataSource) {
      (this.dataSource as YearMonthMediaDataSource).cancelQueryMediaItems(queryParam);
    }
  }

  private hasPreloaded(start: number, end: number): Boolean {
    let len = this.lastPreloadRegion.length;
    if (len === 0) {
      return false;
    }
    for (let index: number = 0; index < len; index++) {
      let first = this.lastPreloadRegion[index].start;
      let second = this.lastPreloadRegion[index].end;
      if (start === first && end === second) {
        return true;
      }
    }
    return false;
  }

  private startPreload(): void {
    // let len = this.preloadData.length;
    // if (len === 0) {
    //   return;
    // }
    // // let astcResources: mediaImageLoader.ASTCResource[] = [];
    // for (let index = 0; index < len; index++) {
    //   let uris = this.preloadData[index].data.uris;
    //   let column = this.preloadData[index].column;
    //   astcResources.push({ sources: uris, column: column });
    // }
    // Log.info(TAG, `startPreload astcResources size: ${astcResources.length}`);
    // let requestOption: mediaImageLoader.RequestOptions =
    //   { width: this.preloadData[0].data.thumbnailSize, height: this.preloadData[0].data.thumbnailSize };
    // ImageCacheUtil.startCachingASTCResources(astcResources, requestOption);
  }

  /**
   * 取消前一帧发起但未完成的元数据查询任务，避免阻塞当前帧新的元数据查询任务
   */
  private cancelLastMediaItemQuery(): void {
    this.lastPreloadRegion = this.currentPreloadRegion;

    for (let region of this.lastPreloadRegion) {
      if (region !== null && region.isValid()) {
        let queryParam: YearMonthQueryParam = new YearMonthQueryParam(region.start,
          region.end - region.start + 1, Priority.HIGH, true);
        this.cancelQueryMediaItems(queryParam);
      }
    }
  }

  /**
   * 开启数据缓存
   */
  public enableDataCaching(): void {
    (this.dataSource as YearMonthMediaDataSource).setAccessDataFlag(true);
  }

  public setFrameControl(source: ScrollSource, isEnable: boolean) {
    if (source === ScrollSource.SCROLL_BAR && this.dataSource instanceof YearMonthMediaDataSource) {
      if ((this.dataSource as YearMonthMediaDataSource).isSyncQuery()) {
        // 针对同步查询元数据过程，不进行滚动过程帧率控制
        return;
      }

      // 针对异步查询元数据过程，进行滚动过程帧率控制
      if (isEnable) {
        // 使能帧率控制
        ApsUtil.enableGridDragScrollApsState();
        this.hasSetScrollFrame = true;
      } else if (this.hasSetScrollFrame) {
        // 恢复帧率控制时，仅当确实设置过帧率控制，才需要调用接口恢复
        ApsUtil.disableGridDragScrollApsState();
        this.hasSetScrollFrame = false;
      }
    }
  }
}