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
import lazy { GridScreenInfo } from './GridScreenInfo';
import type { FetchOptions, PhotoAsset } from '../access/UserFileManagerAccess';
import lazy { GridDragScrollBaseHelper } from './GridDragScrollBaseHelper';
import lazy { GridScrollInfo, IrregularGridScrollInfo } from './GridScrollBaseHelper';
import lazy { ImageCacheUtil } from './ImageCacheUtil';
import lazy { Log } from '../utils/Log';
import lazy { MediaDataSource } from '../model/browser/photo/MediaDataSource';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { PhotoAlbum } from '../access/PhotoAccessHelperAccess';
import type { QueryParam } from '../interface/BrowserDataInterface';
import lazy { Region } from './Region';
import lazy { SimpleGridMediaItem } from '../model/browser/photo/SimpleGridMediaItem';
import lazy { TraceControllerUtils } from './TraceControllerUtils';
import lazy { getScreen } from '../model/common/ScreenManager';
import { DayIrregularGridScrollStrategy, GridScrollBaseStrategy } from './GridScrollBaseStrategy';

/* instrument ignore file */
const TAG: string = 'common_DayIrregularGridDragScrollHelper';

const REGION_PRELOAD: string = 'preloadRegion';

const REGION_TO_FETCH_URI: string = 'regionToFetchUri';

const REGION_ALREADY_FETCHED_URI: string = 'regionAlreadyFetchedUri';

const SCREEN_NUM_TO_CACHE_MEDIA_ITEMS: number = 5;

const TITLE_DATA_INDEX = -1;

/**
 * 宫格规则布局日视图的滚动条拖拽滑动场景辅助类
 */
export class DayIrregularGridDragScrollHelper extends GridDragScrollBaseHelper {
  /**
   * 当前帧数
   */
  private frameNum: number = 0;
  /**
   * 滑动信息
   */
  private scrollInfo?: IrregularGridScrollInfo;
  /**
   * 滑动策略类
   */
  private scrollStrategy: GridScrollBaseStrategy = new DayIrregularGridScrollStrategy();
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
   * 已获取的uri
   */
  private alreadyFetchedUriArr: string[] = [];
  /**
   * 需要获取的uri
   */
  private fetchedUriArr: string[] = [];
  /**
   * 预加载的uri集
   */
  private preloadUriArr: string[] = [];
  private album?: PhotoAlbum;
  /**
   * Height of time_title
   */
  private timeHeight: number = 0;
  private imageGridItemHeight: number = 0;
  private gridColCnt: number = 0;
  private offsetCount: number = 0;
  /**
   * Height of window
   */
  private winHeight: number = getScreen().getWinHeight();

  public init(scroller: Scroller, dataSource: MediaDataSource): void {
    super.init(scroller, dataSource);
    let gridScreenInfo: GridScreenInfo = this.scrollStrategy.getGridScreenInfo();
    let screenMaxGridNum: number = Math.max(gridScreenInfo.screenMaxGridNum, 0);
    this.dataSource?.createSimpleMediaItems(SCREEN_NUM_TO_CACHE_MEDIA_ITEMS * screenMaxGridNum);

    let albumUri: string = this.dataSource?.getAlbumUri() ?? '';
    if (albumUri) {
      this.scrollStrategy.getAlbum(albumUri).then((album: PhotoAlbum | undefined): void => {
        this.album = album;
      });
    }
  }

  public recordScrollInfo(scrollInfo: GridScrollInfo): void {
    if (scrollInfo === undefined || scrollInfo === null) {
      return;
    }
    this.scrollInfo = scrollInfo as IrregularGridScrollInfo;
  }

  public handleScrollStart(): void {
    TraceControllerUtils.startTrace('day scrollbar scrollStart');

    if (this.dataSource) {
      // 开始滚动时禁用滑窗
      this.dataSource.enableGroupSlidingWindow(false);

      // 开始滚动时，错帧预加载机制下主线程会查询媒体库元数据，同时若数据变更导致子线程也在操作媒体库时，会产生查询冲突，
      // 导致主线程严重恶化。因此，在开始滚动时禁用数据查询，拦截滚动期间数据变更，保持数据静态
      this.dataSource.enableQueryData(false);
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
    this.imageGridItemHeight = this.scrollInfo?.imageGridItemHeight ?? 0;
    this.timeHeight = this.scrollInfo?.timeTitleHeight ?? 0;
    let imageGridItemHeight: number = this.imageGridItemHeight + Constants.GRID_GUTTER;
    let gridRowCnt: number = Math.ceil(this.winHeight / imageGridItemHeight);
    this.gridColCnt = this.scrollInfo?.gridRowCount ?? 0;
    this.screenGridCnt = gridRowCnt * this.gridColCnt;
    this.offsetCount = Constants.DRAG_OFFSET_COUNT * this.gridColCnt;
    this.preloadGridCnt = this.screenGridCnt + this.offsetCount + this.gridColCnt;

    TraceControllerUtils.finishTrace('day scrollbar scrollStart');
  }

  public handleScrollStop(): void {
    TraceControllerUtils.startTrace('day scrollbar scrollStop');
    Log.info(TAG, `scroll stop, trigger sliding window index:${this.lastScrollIndexRegion.start}`);
    // 日视图滚动关闭H8
    ImageCacheUtil.resetH8();

    if (this.dataSource) {
      // // 停止滚动时恢复使能滑窗、数据查询
      this.dataSource.enableGroupSlidingWindow(true);
      this.dataSource.enableQueryData(true);

      let updateLastIndexInGrid: number = this.lastScrollIndexRegion.start - 1;
      let updateLastIndexInMedia: number = updateLastIndexInGrid < 0 ? 0 :
        this.dataSource.layoutToData(updateLastIndexInGrid);
      this.dataSource.updateSlidingWindow(updateLastIndexInMedia);
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
    let tempOffset = offset + this.savedScrollOffset;
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
    //计算最大偏移量
    this.maxGridOffset = (this.scrollInfo.actionAndRefreshHeight ?? 0) +
      (this.dataSource?.computeMaxGridOffset(this.imageGridItemHeight, this.timeHeight, this.gridColCnt) as number);

    let globalOffset: number = this.scroller?.currentOffset().yOffset ?? 0;
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
    let globalOffset: number = this.scroller?.currentOffset().yOffset ?? 0;
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

    let preloadRowCount: number = 0;
    if (this.gridColCnt > 0) {
      preloadRowCount = this.preloadGridCnt / this.gridColCnt;
    }
    let preloadRowsOffset: number = (preloadRowCount === 0) ? 0 : (preloadRowCount - 1) *
      (this.imageGridItemHeight + Constants.GRID_GUTTER) + this.imageGridItemHeight;
    if (this.currentPreloadOffset + preloadRowsOffset > this.maxGridOffset) {
      this.logTracker?.info(TAG, `currentPreloadOffset:${this.currentPreloadOffset} + preloadRowsOffset:` +
        ` > maxGridOffset:${this.maxGridOffset}, limit it to ${this.maxGridOffset - preloadRowsOffset}`);
      this.currentPreloadOffset = this.maxGridOffset - preloadRowsOffset;
      return;
    }
    if (this.currentPreloadOffset < 0) {
      this.logTracker?.info(TAG, `currentPreloadOffset:${this.currentPreloadOffset} < 0, limit it to 0`);
      this.currentPreloadOffset = 0;
    }
  }

  /**
   * 开始预加载
   *
   * @param frameNum 预加载的次数
   */
  private startPreload(frameNum: number): void {
    // 第一帧只准备数据没有绘制，没有足够的时间给ImageCacheLoader缓存数据，所以第二帧开始的时候不取消第一帧发起的缓存任务
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
    this.preloadRegions = [];
    this.preloadUriArr = [];
    let mediaCnt: number = this.dataSource?.totalCount() ?? 0;
    if (mediaCnt === 0) {
      return;
    }
    let isScrollInfoInvalid: boolean =
      this.scrollInfo === undefined || this.scrollInfo === null || this.scrollInfo.gridRowCount <= 0;
    if (isScrollInfoInvalid) {
      return;
    }
    this.lastPreloadIndexRegion.start = this.currentPreloadIndexRegion.start;
    this.lastPreloadIndexRegion.end = this.currentPreloadIndexRegion.end;
    let actionAndRefreshHeight = this.scrollInfo?.actionAndRefreshHeight ?? 0;
    let currentPreOffset: number = this.currentPreloadOffset - actionAndRefreshHeight;
    let startIndex: number = (currentPreOffset >= this.maxGridOffset) ? mediaCnt + 1 :
      this.dataSource?.computeStartIndexWithMassage(currentPreOffset, this.imageGridItemHeight, this.timeHeight,
        this.gridColCnt) as number;
    this.currentPreloadIndexRegion.start = startIndex;

    let preloadEndIndex: number = this.currentPreloadIndexRegion.start + this.preloadGridCnt >= mediaCnt + 1 ?
      mediaCnt + 1 : this.currentPreloadIndexRegion.start + this.preloadGridCnt + 2;
    this.currentPreloadIndexRegion.end = preloadEndIndex;

    Log.info(TAG, `DragScroll:${this.currentPreloadIndexRegion.start} to ${this.currentPreloadIndexRegion.end}`)
    this.logTracker?.info(TAG, `startPreload, currentPreloadOffset:${this.currentPreloadOffset}` +
      `, ${this.lastScrollIndexRegion.toString()}, preloadStartIndex:${startIndex}` +
      `, ${this.lastPreloadIndexRegion.toString()}, ${this.currentPreloadIndexRegion.toString()}`);
    if (this.currentPreloadIndexRegion.equals(this.lastPreloadIndexRegion)) {
      this.logTracker?.info(TAG, '2 continuous preload region not change');
      return;
    }
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
    this.computeUriPrefetchRegion(region);
    this.preloadRegionsAlreadyFetchedUri();
    this.preloadRegionsNeedingFetchUri();
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
    if (this.regionsAlreadyFetchedUri.length === 0) {
      return;
    }
    this.alreadyFetchedUriArr = [];
    for (let region of this.regionsAlreadyFetchedUri) {
      this.getValidRegion(region);
    }
    ImageCacheUtil.startCachingImages(this.alreadyFetchedUriArr);
    this.preloadUriArr = this.preloadUriArr.concat(this.alreadyFetchedUriArr);
  }

  private getValidRegion(region: Region): void {
    let hasEmptyUri: boolean = false;
    for (let index: number = region.start; index <= region.end; index++) {
      if (this.dataSource?.findGroupViewIndexes(index - 1) === TITLE_DATA_INDEX) {
        continue;
      }
      let mediaItem: MediaItem | undefined = this.dataSource?.getRawData(index);
      let uri: string = mediaItem?.thumbnail ?? '';
      if (!uri) {
        hasEmptyUri = true;
        break;
      }
      this.alreadyFetchedUriArr.push(uri);
      this.getAlreadyFetchedUri(index);
    }
    if (hasEmptyUri) {
      this.regionsToFetchUri.push(new Region(REGION_TO_FETCH_URI, region.start, region.end));
    } else {
      this.logTracker?.info(TAG, `cache:${region.toString()}`);
    }
  }

  private getAlreadyFetchedUri(index: number): void {
    let mediaItem: MediaItem | undefined = this.dataSource?.getRawData(index);
    let uri: string = mediaItem?.thumbnail ?? '';
    let gridMediaItem: SimpleGridMediaItem | undefined = SimpleGridMediaItem.parseFromMediaItem(mediaItem);
    if (gridMediaItem !== undefined && mediaItem) {
      gridMediaItem.setThumbnailUri(uri);
      gridMediaItem.setThumbnailReady(mediaItem?.thumbnailReady);
      gridMediaItem.setOrientation(mediaItem?.orientation);
      gridMediaItem.setFavorite(mediaItem?.isFavor);
      gridMediaItem.setDuration(mediaItem?.duration);
      gridMediaItem.setDateTrashed(mediaItem?.dateTrashed);
      gridMediaItem.setDateAdded(mediaItem?.getDateAdded());
      this.dataSource?.recordSimpleMediaItem(index, gridMediaItem);
    }
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
    let actualIndex = startIndex;
    if (startIndex === 0) {
      actualIndex++;
    }
    let actualStartIndex: number =
      (this.dataSource?.findGroupViewIndexes(actualIndex - 1) === TITLE_DATA_INDEX) ? actualIndex + 1 : actualIndex;
    let startIndexGroupIndex = this.dataSource?.timeGroupIndexes(actualStartIndex - 1) as number;
    let mediaStartIndex: number = actualStartIndex - startIndexGroupIndex - 2;
    let queryParam: QueryParam | undefined = this.scrollStrategy.getGirdDataQueryParam(
      this.dataSource, mediaStartIndex, count, this.gridPageInfo);
    if (queryParam === undefined) {
      Log.debug(TAG, 'queryParam is unknown, could not fetch')
      this.logTracker?.warn(TAG, 'queryParam is unknown, could not fetch');
      return;
    }
    let fetchOpt: FetchOptions | undefined = this.scrollStrategy.getGirdDataFetchOptions(this.dataSource, queryParam);
    if (fetchOpt === undefined) {
      this.logTracker?.warn(TAG, 'fetchOpt is unknown, could not fetch');
      return;
    }
    let assetList: PhotoAsset[];
    if (!queryParam.albumUri) {
      assetList = await this.scrollStrategy.getAssetsSync(fetchOpt);
    } else {
      assetList = await this.scrollStrategy.getAlbumAssetsSync(this.album, fetchOpt);
    }
    if (assetList === null || assetList.length === 0) {
      this.logTracker?.warn(TAG, 'assetList is null or size 0');
      return;
    }
    this.logTracker?.info(TAG, `fetchMediaDataSync cache:${startIndex}-${startIndex + count - 1}`);
    this.fetchedUriArr = [];
    let layoutStartIndex: number = actualIndex;
    for (let i: number = 0; i < assetList.length; i++) {
      if (this.dataSource?.findGroupViewIndexes(layoutStartIndex + i - 1) === TITLE_DATA_INDEX) {
        layoutStartIndex++;
      }
      this.fetchIndexMediaUriSync(layoutStartIndex, i, assetList);
    }
    this.logTracker?.info(TAG, `fetched assetList size:${assetList.length}` +
      `, fetchedUriArr size:${this.fetchedUriArr.length}`);
    ImageCacheUtil.startCachingImages(this.fetchedUriArr);
    this.preloadUriArr = this.preloadUriArr.concat(this.fetchedUriArr);
  }

  private fetchIndexMediaUriSync(layoutStartIndex: number, indexOffset: number, assetList: PhotoAsset[]): void {
    if (assetList[indexOffset] !== null) {
      let mediaItem: SimpleGridMediaItem = new SimpleGridMediaItem(assetList[indexOffset])
        .parseFromPhotoAsset().parseFromAlbum(this.album);
      let uri: string = mediaItem.getThumbnailUri();
      this.fetchedUriArr.push(uri);
      Log.info(TAG, `assetList index:${layoutStartIndex + indexOffset - 1}, uri:${uri}`);
      this.dataSource?.recordSimpleMediaItem(layoutStartIndex + indexOffset - 1, mediaItem);
    }
  }
}