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

import lazy { Constants } from '../model/common/Constants';
import lazy { DayRegularGridScrollStrategy, GridScrollBaseStrategy } from './GridScrollBaseStrategy';
import lazy { GridScreenInfo } from './GridScreenInfo';
import type { FetchOptions, PhotoAsset } from '../access/UserFileManagerAccess';
import lazy { GridDragScrollBaseHelper } from './GridDragScrollBaseHelper';
import lazy { GridScrollInfo, RegularGridScrollInfo } from './GridScrollBaseHelper';
import lazy { ImageCacheUtil } from './ImageCacheUtil';
import lazy { Log } from '../utils/Log';
import lazy { MediaDataSource } from '../model/browser/photo/MediaDataSource';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { PhotoAlbum } from '../access/PhotoAccessHelperAccess';
import type { QueryParam } from '../interface/BrowserDataInterface';
import lazy { Region } from './Region';
import lazy { SimpleGridMediaItem, FETCH_COLUMNS } from '../model/browser/photo/SimpleGridMediaItem';
import lazy { TraceControllerUtils } from './TraceControllerUtils';
import lazy { getScreen } from '../model/common/ScreenManager';
import lazy { UnionAlbumMediaDataSource } from '../model/browser/photo/UnionAlbumMediaDataSource';

/* instrument ignore file */
const TAG: string = 'common_DayRegularGridDragScrollHelper';

const REGION_PRELOAD: string = 'preloadRegion';

const REGION_TO_FETCH_URI: string = 'regionToFetchUri';

const REGION_ALREADY_FETCHED_URI: string = 'regionAlreadyFetchedUri';


const SCREEN_NUM_TO_CACHE_MEDIA_ITEMS: number = 5;

/**
 * 宫格规则布局日视图的滚动条拖拽滑动场景辅助类
 */
export class DayRegularGridDragScrollHelper extends GridDragScrollBaseHelper {
  /**
   * 当前帧数
   */
  private frameNum: number = 0;
  /**
   * 滑动信息
   */
  private scrollInfo?: RegularGridScrollInfo;
  /**
   * 滑动策略类
   */
  private scrollStrategy: GridScrollBaseStrategy = new DayRegularGridScrollStrategy();
  /**
   * 预期坐标偏移量
   */
  private expectedScrollOffset: number = 0;

  /**
   * 预期坐标偏移量
   */
  private savedScrollOffset: number = 0;
  /**
   * 前一次预加载坐标偏移量
   */
  private lastPreloadOffset: number = 0;
  /**
   * 当前预加载坐标偏移量
   */
  private currentPreloadOffset: number = 0;
  /**
   * 宫格坐标最大可偏移量
   */
  private maxGridOffset: number = 0;
  /**
   * 前一次滑动索引区间
   */
  private lastScrollIndexRegion: Region = new Region('lastScrollIndexRegion', 0, 0);
  /**
   * 前一次预加载索引区间
   */
  private lastPreloadIndexRegion: Region = new Region('lastPreloadIndexRegion', 0, 0);
  /**
   * 当前预加载索引区间
   */
  private currentPreloadIndexRegion: Region = new Region('currentPreloadIndexRegion', 0, 0);
  /**
   * 屏幕宫格数
   */
  private screenGridCnt: number = 0;
  /**
   * 预加载宫格数
   */
  private preloadGridCnt: number = 0;
  /**
   * 待发起预加载的索引区间集
   */
  private preloadRegions: Region[] = [];
  /**
   * 需获取uri的索引区间
   */
  private regionsToFetchUri: Region[] = [];
  /**
   * 已获取uri的索引区间
   */
  private regionsAlreadyFetchedUri: Region[] = [];
  /**
   * 前一帧预加载uri的完整索引区间
   */
  private lastAllPreloadRegions: Region[] = [];
  /**
   * 当前帧预加载uri的完整索引区间
   */
  private currentAllPreloadRegions: Region[] = [];
  /**
   * 预加载的uri集
   */
  private preloadUriArr: string[] = [];
  /**
   * 相册
   */
  private album?: PhotoAlbum;
  /**
   * 宫格高度
   */
  private imageGridItemHeight: number = 0;
  /**
   * 窗口宽度
   */
  private winHeight: number = getScreen().getWinHeight();
  /**
   * 顶部非常规宫格高度，用于计算预加载偏移
   */
  private irregularRegionHeight: number = 0;

  public init(scroller: Scroller, dataSource: MediaDataSource): void {
    super.init(scroller, dataSource);
    let gridScreenInfo: GridScreenInfo = this.scrollStrategy.getGridScreenInfo();
    let screenMaxGridNum: number = Math.max(gridScreenInfo.screenMaxGridNum, 0);
    this.dataSource?.createSimpleMediaItems(SCREEN_NUM_TO_CACHE_MEDIA_ITEMS * screenMaxGridNum);

    let albumUri: string = this.dataSource?.getAlbumUri() ?? '';
    if (albumUri) {
      if (this.gridPageInfo?.gridScene === Constants.PHOTO_TRANSITION_HIDDEN) {
        Log.info(TAG, `getHiddenAlbum of albumUri:${albumUri} begin`);
        this.scrollStrategy.getHiddenAlbum(albumUri, this.gridPageInfo?.isHiddenSubAlbumQuery)
          .then((album: PhotoAlbum | undefined): void => {
            Log.info(TAG, `getHiddenAlbum of albumUri:${albumUri} end`);
            this.album = album;
          });
      } else {
        Log.info(TAG, `getAlbum of albumUri:${albumUri} begin`);
        this.scrollStrategy.getAlbum(albumUri).then((album: PhotoAlbum | undefined): void => {
          Log.info(TAG, `getAlbum of albumUri:${albumUri} end`);
          this.album = album;
        });
      }
    }
  }

  public switchAlbum(albumUri: string): void {
    Log.info(TAG, `switchAlbum:${albumUri} start`);
    this.scrollStrategy?.getAlbum(albumUri).then((album: PhotoAlbum | undefined): void => {
      this.album = album;
      Log.info(TAG, `switchAlbum:${album?.albumUri} end`);
    });
  }

  public recordScrollInfo(scrollInfo: GridScrollInfo): void {
    if (scrollInfo === undefined || scrollInfo === null) {
      return;
    }
    this.scrollInfo = scrollInfo as RegularGridScrollInfo;
  }

  public setIrregularRegionHeight(height: number): void {
    this.irregularRegionHeight = height;
  }

  public handleScrollStart(): void {
    TraceControllerUtils.startTrace('day scrollbar scrollStart');

    // 日视图滚动开启H8
    // ImageCacheUtil.enableH8();

    if (this.dataSource) {
      if (this.dataSource.getDataSourceMode()) {
        this.dataSource.pause();
      } else {
        // 开始滚动时禁用滑窗
        this.dataSource.enableDaySlidingWindow(false);
        // 开始滚动时，错帧预加载机制下主线程会查询媒体库元数据，同时若数据变更导致子线程也在操作媒体库时，会产生查询冲突，
        // 导致主线程严重恶化。因此，在开始滚动时禁用数据查询，拦截滚动期间数据变更，保持数据静态
        this.dataSource.enableQueryData(false);
      }
    }

    // 初始化每帧的滚动参数
    this.frameNum = 0;
    this.expectedScrollOffset = 0;
    this.lastPreloadOffset = 0;
    this.currentPreloadOffset = 0;
    this.maxGridOffset = 0;
    this.lastPreloadIndexRegion.start = this.lastScrollIndexRegion.start;
    this.lastPreloadIndexRegion.end = this.lastScrollIndexRegion.end;
    this.currentPreloadIndexRegion.start = this.lastPreloadIndexRegion.start;
    this.currentPreloadIndexRegion.end = this.lastPreloadIndexRegion.end;
    let gridScreenInfo: GridScreenInfo = this.scrollStrategy.getGridScreenInfo();
    this.imageGridItemHeight = this.scrollInfo?.imageGridItemHeight ?? 0;
    let imageGridItemHeight: number = this.imageGridItemHeight + Constants.GRID_GUTTER;
    let gridRowCnt: number = Math.ceil(this.winHeight / imageGridItemHeight) + 1;
    let gridColCnt: number = Math.max(gridScreenInfo.screenGridColNum, 0);
    if (this.scrollInfo?.gridRowCount && this.scrollInfo?.gridRowCount > 0) {
      gridColCnt = this.scrollInfo?.gridRowCount + 1;
    }
    this.screenGridCnt = gridRowCnt * gridColCnt;
    this.preloadGridCnt = this.screenGridCnt + 2 * gridColCnt;
    Log.info(TAG, `scroll start, grid:[${gridRowCnt} * ${gridColCnt}]`);

    TraceControllerUtils.finishTrace('day scrollbar scrollStart');
  }

  public handleScrollStop(): void {
    TraceControllerUtils.startTrace('day scrollbar scrollStop');

    // 日视图滚动关闭H8
    // ImageCacheUtil.resetH8();

    if (this.dataSource) {
      // 停止滚动时恢复使能滑窗、数据查询
      if (this.dataSource.getDataSourceMode()) {
        this.dataSource.resume();
      } else {
        this.dataSource.enableDaySlidingWindow(true);
        this.dataSource.enableQueryData(true);
        // 停止滚动时只基于当前最靠后的有效区间触发一次滑窗，
        // 避免历史区间被依次回放导致窗口回跳到更早位置。
        let finalIndex: number = -1;
        for (let region of this.lastAllPreloadRegions) {
          if (region === null || !region.isValid()) {
            continue;
          }
          finalIndex = Math.max(finalIndex, region.start);
        }
        if (finalIndex >= 0) {
          // 方向保护：释放滚动条时仅允许保持/向后推进滑窗，屏蔽向前回拉更新。
          if (finalIndex < this.dataSource.activeStart) {
            Log.warn(TAG, `skip rebound sliding window, finalIndex:${finalIndex}, activeStart:${this.dataSource.activeStart}`);
          } else {
            TraceControllerUtils.startTrace(`trigger sliding window:${finalIndex}`);
            Log.info(TAG, `scrollbar scroll stop, trigger sliding window index:${finalIndex}`);
            this.dataSource.updateSlidingWindow(finalIndex);
            TraceControllerUtils.finishTrace(`trigger sliding window:${finalIndex}`);
          }
        }
      }
    }

    // 滚动停止时的前一帧错帧预加载为冗余请求，需要取消
    this.tryCancelPreload();

    // 重置每帧的滚动参数
    this.lastPreloadIndexRegion.reset();
    this.currentPreloadIndexRegion.reset();
    this.preloadRegions = [];
    this.preloadUriArr = [];
    this.regionsToFetchUri = [];
    this.regionsAlreadyFetchedUri = [];
    this.lastAllPreloadRegions = [];
    this.currentAllPreloadRegions = [];
    this.screenGridCnt = 0;
    this.preloadGridCnt = 0;

    TraceControllerUtils.finishTrace('day scrollbar scrollStop');
  }

  public handleScrollIndex(start: number, end: number): void {
    if (start < 0 || end < 0 || start > end) {
      return;
    }
    this.lastScrollIndexRegion.start = start;
    this.lastScrollIndexRegion.end = end;

    if (this.dataSource) {
      if (this.lastScrollIndexRegion.start >= this.dataSource.totalCount()) {
        this.lastScrollIndexRegion.start = this.dataSource.totalCount() - 1;
      }
    }

    let gridRowCnt: number = this.scrollInfo?.gridRowCount ?? 0;
    let imageGridItemHeight: number = this.scrollInfo?.imageGridItemHeight ?? 0;
    let actionAndRefreshHeight: number = this.scrollInfo?.actionAndRefreshHeight ?? 0;
    let currentGridCnt: number = end - start + 1;
    Log.debug(TAG, `handleScrollIndex, start:${start}, end:${end}, currentGridCnt:${currentGridCnt}` +
      `, gridRowCnt:${gridRowCnt}, imageGridItemHeight:${imageGridItemHeight}` +
      `, actionAndRefreshHeight: ${actionAndRefreshHeight}`);
    this.logTracker?.info(TAG, `handleScrollIndex, start:${start}, end:${end}, currentGridCnt:${currentGridCnt}` +
      `, gridRowCnt:${gridRowCnt}, imageGridItemHeight:${imageGridItemHeight}` +
      `, actionAndRefreshHeight: ${actionAndRefreshHeight}`);

    if (this.screenGridCnt > 0 && currentGridCnt > this.screenGridCnt) {
      // 当onScrollIndex回调的index区间范围超过屏幕宫格数时，打印此异常状态
      Log.warn(TAG, `error of currentGridCnt:${currentGridCnt} exceeding` +
        ` screenGridCnt:${this.screenGridCnt}, start:${start}, end:${end}, gridRowCnt:${gridRowCnt}`);
    }
  }

  public handleScroll(offset: number): void {
    this.logTracker?.info(TAG, `handleScroll, offset:${offset}`);
  }

  public handleWillScroll(offset: number, source: ScrollSource): number {
    if (offset === 0) {
      return offset;
    }
    this.frameNum++;
    let expectedOffset: number = this.expectedScrollOffset;
    if (this.isNewFrame) {
      if (this.frameNum % this.sLimitFrames !== 1) {
        this.savedScrollOffset += offset;
        return 0;
      }
    }
    let tempOffset =  offset + this.savedScrollOffset;
    this.savedScrollOffset = 0;
    this.logTracker?.info(TAG, `++++++++++++frame:${this.frameNum}++++++++++++\n` +
      `handleWillScroll, expectedOffset:${expectedOffset}, offset:${tempOffset}`);
    if (this.scrollInfo === undefined || this.scrollInfo === null || this.scrollInfo.gridRowCount <= 0) {
      return expectedOffset;
    }
    if (this.isAboutToCrossBorder(tempOffset)) {
      this.expectedScrollOffset = tempOffset;
      return expectedOffset;
    }

    let mediaCnt: number = this.dataSource?.getMediaCount() ?? 0;
    let totalGridRowCnt: number = Math.ceil(mediaCnt / this.scrollInfo.gridRowCount);
    this.maxGridOffset = (this.scrollInfo.actionAndRefreshHeight ?? 0) +
      ((totalGridRowCnt === 0) ? 0 : (totalGridRowCnt - 1) *
        (this.scrollInfo.imageGridItemHeight + Constants.GRID_GUTTER) + this.scrollInfo.imageGridItemHeight);
    let globalOffset: number = this.scroller?.currentOffset()?.yOffset ?? 0;
    if (globalOffset >= this.maxGridOffset) {
      this.logTracker?.info(TAG, `globalOffset:${globalOffset} exceeds maxGridOffset:${this.maxGridOffset}`);
      this.expectedScrollOffset = tempOffset;
      return expectedOffset;
    }

    let actualOffset: number;
    if (expectedOffset + globalOffset > this.maxGridOffset) {
      actualOffset = this.maxGridOffset - globalOffset;
      tempOffset = 0;
      this.logTracker?.info(TAG, `limit expected offset:${expectedOffset} to actual offset:${actualOffset}`);
    } else if (expectedOffset + globalOffset < 0) {
      actualOffset = -globalOffset;
      this.logTracker?.info(TAG, `limit expected offset:${expectedOffset} to actual offset:${actualOffset}`);
    } else {
      actualOffset = expectedOffset;
    }
    this.lastPreloadOffset = this.currentPreloadOffset;
    this.currentPreloadOffset = globalOffset + actualOffset + tempOffset;
    this.logTracker?.info(TAG, `recordScrollOffset, expectedOffset:${expectedOffset}` +
      `, actualOffset:${actualOffset}, nextOffset:${tempOffset}, globalOffset:${globalOffset}` +
      `, screenGridCnt:${this.screenGridCnt}, preloadGridCnt:${this.preloadGridCnt}` +
      `, lastPreloadOffset:${this.lastPreloadOffset}, currentPreloadOffset:${this.currentPreloadOffset}`);
    this.limitPreloadOffset();
    this.expectedScrollOffset = tempOffset;

    this.startPreload(this.frameNum);
    return expectedOffset;
  }

  /**
   * 根据滑动偏移量，判断是否即将跨越grid边界
   *
   * @param offset 滑动偏移量
   * @returns true表示即将跨越grid边界
   */
  private isAboutToCrossBorder(offset: number): boolean {
    let globalOffset: number = this.scroller?.currentOffset()?.yOffset ?? 0;
    if (globalOffset === 0 && offset <= 0) {
      // 当前在顶部，且预期向上滑动
      this.logTracker?.info(TAG, 'about to cross top border');
      return true;
    }
    if (this.scroller?.isAtEnd() && offset >= 0) {
      // 当前在底部，且预期向下滑动
      this.logTracker?.info(TAG, 'about to cross bottom border');
      return true;
    }
    return false;
  }

  /**
   * 限制预加载区间
   */
  private limitPreloadOffset(): void {
    if (this.scrollInfo === undefined || this.scrollInfo === null || this.scrollInfo.gridRowCount <= 0) {
      return;
    }

    let preloadRowCount: number = this.preloadGridCnt / this.scrollInfo.gridRowCount;
    let preloadRowsOffset: number = (preloadRowCount === 0) ? 0 : (preloadRowCount - 1) *
      (this.scrollInfo.imageGridItemHeight + Constants.GRID_GUTTER) + this.scrollInfo.imageGridItemHeight;

    // maxGridOffset是根据宫格数和宫格高度得到的规则值，并未考虑到宫格底部的不规则GridItem。
    // 这里增加两行余量以处理滚动到底部时的不规则情况
    let extraHeight: number = 2 * this.scrollInfo.imageGridItemHeight;

    // 预加载坐标范围超过宫格最大高度时（包括规则宫格高度 + 宫格底部余量），对范围进行限制
    let maxPreloadOffset: number = this.maxGridOffset + extraHeight - preloadRowsOffset + this.irregularRegionHeight;
    if (this.currentPreloadOffset > maxPreloadOffset) {
      this.logTracker?.info(TAG, `currentPreloadOffset:${this.currentPreloadOffset}` +
        ` + preloadRowsOffset:${preloadRowsOffset} > maxGridOffset:${this.maxGridOffset}` +
        ` + extraHeight:${extraHeight}, limit it to ${maxPreloadOffset}`);
      this.currentPreloadOffset = maxPreloadOffset;
      return;
    }

    // 预加载坐标偏移量为负时，置为0
    if (this.currentPreloadOffset < 0) {
      this.logTracker?.info(TAG, `currentPreloadOffset:${this.currentPreloadOffset} < 0, limit it to 0`);
      this.currentPreloadOffset = 0;
    }
  }

  /**
   * 开始预加载
   */
  private startPreload(frameNum: number): void {
    if (frameNum !== 2) {
      this.tryCancelPreload();
    }

    this.computePreloadRegion();
    this.printRegionsInfo(TAG, 'preloadRegions', this.preloadRegions);

    this.tryPreload();
  }

  /**
   * 计算预加载索引区间
   */
  private computePreloadRegion(): void {
    let mediaCnt: number = this.dataSource?.getMediaCount() ?? 0;
    if (mediaCnt === 0) {
      return;
    }
    if (this.scrollInfo === undefined || this.scrollInfo === null || this.scrollInfo.gridRowCount <= 0) {
      return;
    }

    this.lastPreloadIndexRegion.start = this.currentPreloadIndexRegion.start;
    this.lastPreloadIndexRegion.end = this.currentPreloadIndexRegion.end;
    let preloadStartRow: number = Math.floor((this.currentPreloadOffset - this.irregularRegionHeight -
      (this.scrollInfo.actionAndRefreshHeight ?? 0)) / (this.scrollInfo.imageGridItemHeight + Constants.GRID_GUTTER));
    preloadStartRow = (preloadStartRow > 0) ? preloadStartRow - 1 : 0;
    let preloadStartIndex: number = preloadStartRow * this.scrollInfo.gridRowCount;
    this.currentPreloadIndexRegion.start = preloadStartIndex;
    this.currentPreloadIndexRegion.end = preloadStartIndex + this.preloadGridCnt > mediaCnt ?
      mediaCnt - 1 : preloadStartIndex + this.preloadGridCnt - 1;
    this.logTracker?.info(TAG, `startPreload, currentPreloadOffset:${this.currentPreloadOffset}` +
      `, ${this.lastScrollIndexRegion.toString()}, preloadStartIndex:${preloadStartIndex}` +
      `, ${this.lastPreloadIndexRegion.toString()}, ${this.currentPreloadIndexRegion.toString()}` +
      `, irregularRegionHeight: ${this.irregularRegionHeight}`);
    Log.debug(TAG, `startPreload, currentPreloadOffset:${this.currentPreloadOffset}` +
      `, ${this.lastScrollIndexRegion.toString()}, preloadStartIndex:${preloadStartIndex}` +
      `, ${this.lastPreloadIndexRegion.toString()}, ${this.currentPreloadIndexRegion.toString()}` +
      `, irregularRegionHeight: ${this.irregularRegionHeight}`);
    if (this.currentPreloadIndexRegion.equals(this.lastPreloadIndexRegion)) {
      this.logTracker?.info(TAG, '2 continuous preload region not change');
      return;
    }
    this.preloadRegions = [];
    this.preloadUriArr = [];

    let lastStart: number = this.lastPreloadIndexRegion.start;
    let lastEnd: number = this.lastPreloadIndexRegion.end;
    let curStart: number = this.currentPreloadIndexRegion.start;
    let curEnd: number = this.currentPreloadIndexRegion.end;
    if (curStart >= lastStart) {
      if (curStart > lastEnd) {
        this.preloadRegions.push(new Region(REGION_PRELOAD, curStart, curEnd));
      } else {
        if (curEnd > lastEnd) {
          this.preloadRegions.push(new Region(REGION_PRELOAD, lastEnd + 1, curEnd));
        }
      }
      return;
    }

    if (curEnd < lastStart) {
      this.preloadRegions.push(new Region(REGION_PRELOAD, curStart, curEnd));
    } else {
      this.preloadRegions.push(new Region(REGION_PRELOAD, curStart, lastStart - 1));
      if (curEnd > lastEnd) {
        this.preloadRegions.push(new Region(REGION_PRELOAD, lastEnd + 1, curEnd));
      }
    }
  }

  /**
   * 尝试取消预加载
   */
  private tryCancelPreload(): void {
    let cancelPreloadRegions: Region[] = this.preloadRegions;
    if (cancelPreloadRegions.length === 0 || this.preloadUriArr.length === 0) {
      return;
    }

    this.printRegionsInfo(TAG, 'cancelPreloadRegions', cancelPreloadRegions);
    ImageCacheUtil.stopCachingImages(this.preloadUriArr);
  }

  /**
   * 尝试预加载
   */
  private tryPreload(): void {
    if (this.preloadRegions.length === 0) {
      return;
    }

    for (let region of this.preloadRegions) {
      if (region !== null && region.isValid()) {
        this.tryPreloadRegion(region);
      }
    }
  }

  /**
   * 预加载某个索引区间
   *
   * @param region 待预加载的索引区间
   */
  private tryPreloadRegion(region: Region): void {
    this.lastAllPreloadRegions = this.currentAllPreloadRegions;
    this.computeUriPrefetchRegion(region);
    this.printRegionsInfo(TAG, 'regionsAlreadyFetchedUri', this.regionsAlreadyFetchedUri);
    this.printRegionsInfo(TAG, 'regionsToFetchUri', this.regionsToFetchUri);
    this.preloadRegionsAlreadyFetchedUri();
    this.preloadRegionsNeedingFetchUri();
    this.currentAllPreloadRegions = this.regionsAlreadyFetchedUri.concat(this.regionsToFetchUri);
  }

  private computeUriPrefetchRegion(region: Region): void {
    this.regionsToFetchUri = [];
    this.regionsAlreadyFetchedUri = [];
    if (region === null || !region.isValid()) {
      return;
    }

    let validDataStart: number = this.dataSource?.getValidStartIndex() ?? Constants.NOT_FOUND;
    let validDataEnd: number = this.dataSource?.getValidEndIndex() ?? Constants.NOT_FOUND;
    this.logTracker?.info(TAG, `computeUriPrefetchRegion, validData:[${validDataStart}, ${validDataEnd}]` +
      `, region:${region.toString()}`);
    if (validDataStart === Constants.NOT_FOUND || validDataEnd === Constants.NOT_FOUND ||
      validDataStart > validDataEnd) {
      this.regionsToFetchUri.push(new Region(REGION_TO_FETCH_URI, region.start, region.end));
      return;
    }
    if (region.start >= validDataStart) {
      if (region.start > validDataEnd) {
        this.regionsToFetchUri.push(new Region(REGION_TO_FETCH_URI, region.start, region.end));
      } else {
        if (region.end > validDataEnd) {
          this.regionsToFetchUri.push(new Region(REGION_TO_FETCH_URI, validDataEnd + 1, region.end));
          this.regionsAlreadyFetchedUri.push(new Region(REGION_ALREADY_FETCHED_URI, region.start, validDataEnd));
        } else {
          this.regionsAlreadyFetchedUri.push(new Region(REGION_ALREADY_FETCHED_URI, region.start, region.end));
        }
      }
      return;
    }

    if (region.end < validDataStart) {
      this.regionsToFetchUri.push(new Region(REGION_TO_FETCH_URI, region.start, region.end));
    } else {
      this.regionsToFetchUri.push(new Region(REGION_TO_FETCH_URI, region.start, validDataStart - 1));
      if (region.end > validDataEnd) {
        this.regionsToFetchUri.push(new Region(REGION_TO_FETCH_URI, validDataEnd + 1, region.end));
        this.regionsAlreadyFetchedUri.push(new Region(REGION_ALREADY_FETCHED_URI, validDataStart, validDataEnd));
      } else {
        this.regionsAlreadyFetchedUri.push(new Region(REGION_ALREADY_FETCHED_URI, validDataStart, region.end));
      }
    }
  }

  /**
   * 根据已经获取到的uri，发起预加载
   */
  private preloadRegionsAlreadyFetchedUri(): void {
    // if (this.regionsAlreadyFetchedUri.length === 0) {
    //   return;
    // }
    //
    // let alreadyFetchedUriArr: string[] = [];
    // for (let region of this.regionsAlreadyFetchedUri) {
    //   if (region === null || !region.isValid()) {
    //     continue;
    //   }
    //   let hasEmptyUri: boolean = false;
    //   for (let index: number = region.start; index <= region.end; index++) {
    //     let mediaItem: MediaItem | undefined = this.dataSource?.getRawData(index);
    //     let uri: string = mediaItem?.thumbnail ?? '';
    //     if (!uri) {
    //       hasEmptyUri = true;
    //       break;
    //     }
    //     alreadyFetchedUriArr.push(uri);
    //     let gridMediaItem: SimpleGridMediaItem | undefined = SimpleGridMediaItem.parseFromMediaItem(mediaItem);
    //     if (gridMediaItem !== undefined && mediaItem) {
    //       gridMediaItem.setThumbnailUri(uri);
    //       gridMediaItem.setThumbnailReady(mediaItem?.thumbnailReady);
    //       gridMediaItem.setOrientation(mediaItem?.orientation);
    //       gridMediaItem.setFavorite(mediaItem?.isFavor);
    //       gridMediaItem.setDuration(mediaItem?.duration);
    //       gridMediaItem.setDateTrashed(mediaItem?.dateTrashed);
    //       gridMediaItem.setDateAdded(mediaItem?.getDateAdded());
    //       gridMediaItem.setPosition(mediaItem?.getPosition());
    //       this.dataSource?.recordSimpleMediaItem(index, gridMediaItem);
    //     }
    //   }
    //   if (hasEmptyUri) {
    //     this.logTracker?.info(TAG, `emptyUriRegion:${region.toString()}, need prefetch`);
    //     this.regionsToFetchUri.push(new Region(REGION_TO_FETCH_URI, region.start, region.end));
    //   } else {
    //     this.logTracker?.info(TAG, `cache:${region.toString()}`);
    //   }
    // }
    // ImageCacheUtil.startCachingImages(alreadyFetchedUriArr);
    // this.preloadUriArr = this.preloadUriArr.concat(alreadyFetchedUriArr);
  }

  /**
   * 发起需提前获取uri的预加载流程
   */
  private preloadRegionsNeedingFetchUri(): void {
    if (this.regionsToFetchUri.length === 0) {
      return;
    }

    for (let region of this.regionsToFetchUri) {
      if (region !== null && region.isValid()) {
        let cntToFetchUri: number = region.end - region.start + 1;
        this.logTracker?.info(TAG, `fetchData:${region.toString()}`);
        this.fetchMediaDataSync(region.start, cntToFetchUri);
      }
    }
  }

  /**
   * 同步阻塞获取媒体库数据
   *
   * @param startIndex 查询起点
   * @param count 查询个数
   */
  private async  fetchMediaDataSync(startIndex: number, count: number) {
    let queryParam: QueryParam | undefined = this.scrollStrategy.getGirdDataQueryParam(
      this.dataSource, startIndex, count, this.gridPageInfo);
    if (queryParam === undefined) {
      this.logTracker?.warn(TAG, 'queryParam is unknown, could not fetch');
      return;
    }
    let fetchOpt: FetchOptions | undefined = this.scrollStrategy.getGirdDataFetchOptions(this.dataSource, queryParam);
    if (fetchOpt === undefined) {
      this.logTracker?.warn(TAG, 'fetchOpt is unknown, could not fetch');
      return;
    }
    fetchOpt.fetchColumns = FETCH_COLUMNS;
    let assetList: PhotoAsset[];
    let isUnionAlbum: boolean = this.dataSource instanceof UnionAlbumMediaDataSource && this.dataSource.isUnionAlbum;
    if (!queryParam.albumUri || isUnionAlbum) {
      assetList = await this.scrollStrategy.getAssetsSync(fetchOpt);
    } else {
      assetList = await this.scrollStrategy.getAlbumAssetsSync(this.album, fetchOpt);
    }
    if (assetList === null || assetList.length === 0) {
      this.logTracker?.warn(TAG, 'assetList is null or size 0');
      return;
    }

    this.logTracker?.info(TAG, `cache:${startIndex}-${startIndex + count - 1}`);
    let fetchedUriArr: string[] = [];
    for (let i: number = 0; i < assetList.length; i++) {
      if (assetList[i] !== null) {
        let mediaItem: SimpleGridMediaItem = new SimpleGridMediaItem(assetList[i])
          .parseFromPhotoAsset().parseFromAlbum(this.album);
        let uri: string = mediaItem.getThumbnailUri();
        fetchedUriArr.push(uri);
        this.dataSource?.recordSimpleMediaItem(startIndex + i, mediaItem);
      }
    }
    this.logTracker?.info(TAG, `fetched assetList size:${assetList.length}` +
      `, fetchedUriArr size:${fetchedUriArr.length}`);
    ImageCacheUtil.startCachingImages(fetchedUriArr);
    this.preloadUriArr = this.preloadUriArr.concat(fetchedUriArr);
  }
}