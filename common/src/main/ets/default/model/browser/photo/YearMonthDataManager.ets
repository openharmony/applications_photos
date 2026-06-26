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
/* instrument ignore file */

import lazy { Constants } from '../../common/Constants';
import lazy { ImageCacheUtil } from '../../../utils/ImageCacheUtil';
import lazy { ImageUtil } from '../../../../default/utils/ImageUtil';
import lazy { Log } from '../../../utils/Log';
import lazy {
  MediaObserverCallback,
  MediaObserverNfyInfo,
  MediaObserverNfyType
} from '../../browser/dataObserver/MediaObserverCallback';
import { AlbumUtils } from '../../../utils/AlbumUtils'
import { Throttle } from '../../../utils/Throttle';
import { PhotoAssetChangeInfos, MediaChangeListener } from '../../browser/dataObserver/MediaObserver';
import lazy { Priority, YearMonthQueryParam } from './YearMonthQueryParam';
import lazy { Region } from '../../../utils/Region';
import lazy { SendablePhotoAccessHelper } from '../../../access/SendablePhotoAccessHelper';
import lazy util from '@ohos.util';
import lazy { YearMonthDataImpl } from './YearMonthDataImpl';
import lazy { YearMonthDataInterface } from '../../../interface/BrowserDataInterface';
import lazy { YearMonthMediaItem } from './YearMonthMediaItem';
import lazy { YearMonthMediaQueryWorker } from './YearMonthMediaQueryWorker';
import lazy { YearMonthUtil } from './YearMonthUtil';
import lazy { YearMonthViewData, YearMonthViewDataBuilder } from './YearMonthViewData';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

const TAG: string = 'YearMonthDataManager';

/**
 * 年月视图View数据的最大缓存数
 */
const YEAR_MONTH_VIEW_DATA_CACHE_NUM: number = 20;
/**
 * 年月视图子线程查询的节流间隔
 */
const FULL_QUERY_DATA_DURATION: number = 2000;

/**
 * 年/月视图控件信息
 */
class ItemInfoPerGroup {
  /**
   * 单个年/月视图控件的小图行数
   */
  private row: number;
  /**
   * 单个年/月视图控件的小图列数
   */
  private column: number;
  /**
   * 单个年/月视图控件的宽度
   */
  private viewWidth: number;

  constructor(row: number, column: number, viewWidth: number) {
    this.row = row >= 0 ? row : 0;
    this.column = column >= 0 ? column : 0;
    this.viewWidth = viewWidth >= 0 ? viewWidth : 0;
  }

  public getRow(): number {
    return this.row;
  }

  public getColumn(): number {
    return this.column;
  }

  public getCount(): number {
    return this.row * this.column;
  }

  public getViewWidth(): number {
    return this.viewWidth;
  }
}

/**
 * 年月视图数据管理类
 */
export class YearMonthDataManager implements MediaObserverCallback, MediaChangeListener {
  /**
   * 年视图控件信息。针对不同产品设备、横竖屏状态，在应用初始化时、状态变化时按实际值刷新
   */
  private yearItemInfoPerGroup?: ItemInfoPerGroup;
  /**
   * 月视图控件信息。针对不同产品设备、横竖屏状态，在应用初始化时、状态变化时按实际值刷新
   */
  private monthItemInfoPerGroup?: ItemInfoPerGroup;
  /**
   * 异步查询数据回调通知结果
   */
  private getMediaItemDataCallbackFunc: Function =
    (queryParam: YearMonthQueryParam, items: YearMonthMediaItem[]):
      void => this.onQueryMediaItemResult(queryParam, items);
  /**
   * 年月视图查询任务管理
   */
  private yearMonthQueryWorker: YearMonthMediaQueryWorker;
  /**
   * 实现年月视图任务查询
   */
  private yearMonthQueryMediaData: YearMonthDataInterface;
  /**
   * 高优先级任务完成或者数据变更查询完成后需要通知dataSource刷新界面
   */
  private notifyCallbackFunc: Function;
  /**
   * 当前图片数量
   */
  private currentMediaCount: number = 0;
  /**
   * 是否需要初始化年月元数据查询，冷启动时默认需要触发一次查询
   */
  private needInitMediaDataQuery: boolean = true;
  /**
   * 是否正在创建批量任务中。一次仅允许一个流程创建批量任务，避免影响性能
   */
  private isCreatingBatchTask: boolean = false;
  /**
   * 是否需要处理年月视图元数据变更
   */
  private needHandleMediaDataChange: boolean = false;
  /**
   * 年月元数据是否在变更中
   */
  private isDuringMediaDataChange: boolean = false;
  /**
   * 数据发生变更时, 是否需要触发年月视图的查询任务（仅在年月界面开始查询任务，避免数据变更添加任务影响其他业务）
   */
  private needCreateMediaDataQueryTask: boolean = false;
  /**
   * 是否支持后台查询年月元数据
   */
  private isEnableBackgroundMediaQuery: boolean;
  /**
   * 年月界面是否在前台
   */
  private isCurrentViewShown: boolean = false;
  /**
   * 当前年月界面
   */
  private currentView: string = '';
  /**
   * 是否需要刷新当前年月视图
   */
  private needRefreshView: boolean = false;
  /**
   * 年月视图是否正在滑动中
   */
  private isScrolling: boolean = false;
  /**
   * 前一次年月视图宫格索引区间（视图最上面及最下面的宫格索引）
   */
  private lastViewRegion: Region = new Region('lastViewRegion');
  /**
   * 当前年月视图宫格索引区间（视图最上面及最下面的宫格索引）
   */
  private currentViewRegion: Region = new Region('currentViewRegion');
  /**
   * 当前年月视图宫格元数据索引区间（视图最上面及最下面的宫格元数据索引）
   */
  private currentMediaDataRegion: Region = new Region('currentMediaDataRegion');
  /**
   * 缓存的年月视图元数据，注意：
   * a) 这里只需存储年视图数据，月视图可以直接复用年视图数据
   * b) 每个年视图小缩略图数据只需要dateTaken、fileId、dateModified、mediaType 4个字段，共占用8字节 * 4，
   *    因此对于50w图片，占用50w * 8字节 * 4 = 15.26MB，内存可控
   */
  private cachedMediaItem: YearMonthMediaItem[] = [];
  /**
   * 缓存的年月视图View数据（主要包括每个小缩略图uri）。每个年月视图View数据较大（主要是uri数组），控制最大缓存数，避免内存占用过大
   */
  private cachedViewData: util.LRUCache<string, YearMonthViewData> =
    new util.LRUCache<string, YearMonthViewData>(YEAR_MONTH_VIEW_DATA_CACHE_NUM);
  /**
   * 视图是否为销毁状态
   */
  private isDestroyed: boolean = false;
  /**
   * 子线程查询的节流器
   */
  private readonly queryThrottle: Throttle<void> = new Throttle<void>(FULL_QUERY_DATA_DURATION, TAG);


  constructor(callbackFunc: Function) {
    this.notifyCallbackFunc = callbackFunc;
    this.yearMonthQueryMediaData = new YearMonthDataImpl();
    this.yearMonthQueryWorker = new YearMonthMediaQueryWorker(this.yearMonthQueryMediaData);
    this.isEnableBackgroundMediaQuery = YearMonthUtil.isEnableBackgroundMediaQuery();
    Log.i(TAG, `is enable background media query:${this.isEnableBackgroundMediaQuery}`);
  }

  /**
   * 响应变更
   *
   * @param mediaType 变更类型
   */
  public onChange(mediaType: string): void {
  }

  /**
   * 响应年月视图元数据变更
   *
   * @param nfyInfo 元数据变更信息
   */
  public onNotify(nfyInfo: MediaObserverNfyInfo): void {
    if (AlbumUtils.useAccurateNotify()) {
      return;
    }
    this.recordMediaDataChange(nfyInfo);
  }

  /**
   * 精准通知响应年月视图元数据变更
   *
   * @param type 元数据变更类型
   * @param nfyInfo 元数据变更信息
   */
  public onAccurateNotify(type: string, nfyInfo: PhotoAssetChangeInfos): void {
    this.needHandleMediaDataChange = true;
  }

  public onDestroy(): void {
    Log.i(TAG, 'onDestroy');
    this.isDestroyed = true;

    // 移除所有查询任务
    this.yearMonthQueryWorker.removeAllTasks();

    // 清空所有元数据、view数据缓存
    this.clearAllCachedMediaItemData();
    this.clearAllCachedViewData();
  }

  /**
   * 初始化年/月视图控件信息
   *
   * @param currentView 当前视图
   * @param row 单个年/月视图控件的小图行数
   * @param column 单个年/月视图控件的小图列数
   * @param viewWidth 单个年/月视图控件的宽度
   */
  public initItemInfoPerGroup(currentView: string, row: number, column: number, viewWidth: number): void {
    Log.i(TAG, ` initItemInfoPerGroup, view:${currentView}, row:${row}, column:${column}, viewWidth:${viewWidth}`);
    if (currentView === Constants.YEAR) {
      this.yearItemInfoPerGroup = new ItemInfoPerGroup(row, column, viewWidth);
    } else if (currentView === Constants.MONTH) {
      this.monthItemInfoPerGroup = new ItemInfoPerGroup(row, column, viewWidth);
    }
  }

  /**
   * 获取单个年/月视图控件的小图数
   *
   * @param currentView 当前视图
   * @returns 单个年/月视图控件的小图数
   */
  private getItemCountPerGroup(currentView: string): number {
    if (currentView === Constants.YEAR && this.yearItemInfoPerGroup) {
      return this.yearItemInfoPerGroup.getCount();
    } else if (currentView === Constants.MONTH && this.monthItemInfoPerGroup) {
      return this.monthItemInfoPerGroup.getCount();
    } else {
      return 0;
    }
  }

  /**
   * 获取单个年/月视图控件的小图列数
   *
   * @param currentView 当前视图
   * @returns 单个年/月视图控件的小图列数
   */
  private getItemColumnPerGroup(currentView: string): number {
    if (currentView === Constants.YEAR && this.yearItemInfoPerGroup) {
      return this.yearItemInfoPerGroup.getColumn();
    } else if (currentView === Constants.MONTH && this.monthItemInfoPerGroup) {
      return this.monthItemInfoPerGroup.getColumn();
    } else {
      return 0;
    }
  }

  /**
   * 获取单个年/月视图控件的宽度
   *
   * @param currentView 当前视图
   * @returns 单个年/月视图控件的宽度
   */
  private getItemWidthPerGroup(currentView: string): number {
    if (currentView === Constants.YEAR && this.yearItemInfoPerGroup) {
      return this.yearItemInfoPerGroup.getViewWidth();
    } else if (currentView === Constants.MONTH && this.monthItemInfoPerGroup) {
      return this.monthItemInfoPerGroup.getViewWidth();
    } else {
      return 0;
    }
  }

  /**
   * 设置当前视图标志
   *
   * @param isShow 当前视图是否在显示
   * @param currentView 当前视图
   */
  public setCurrentViewShowFlag(isShow: boolean, currentView: string): void {
    this.isCurrentViewShown = isShow;
    this.currentView = currentView;
    this.needRefreshView = this.isCurrentViewShown && YearMonthUtil.isYearMonthView(this.currentView);
    Log.i(TAG, `setCurrentViewShowFlag, isShow:${isShow}, currentView:${currentView}` +
      `, needRefreshView:${this.needRefreshView}`);
  }

  /**
   * 设置当前年月视图是否在滑动/滚动中
   *
   * @param isScrolling 是否在滑动/滚动中
   */
  public setDuringScroll(isScrolling: boolean): void {
    Log.i(TAG, `setDuringScroll, currentView:${this.currentView}, isScrolling:${isScrolling}`);
    this.isScrolling = isScrolling;
    if (isScrolling) {
      this.pauseCachingMediaItemDataTask();
    } else {
      this.resumeCachingMediaItemDataTask();
    }
  }

  /**
   * 刷新当前年月视图。针对元数据变更场景，需要重新查询元数据并刷新视图
   */
  private refreshCurrentView(isFullQuery: boolean = true): void {
    this.computeCurrentMediaDataRegion();
    if (!this.currentMediaDataRegion.isValid()) {
      return;
    }

    let itemCountPerGroup: number = this.getItemCountPerGroup(this.currentView);
    let start: number = this.currentMediaDataRegion.start;
    let count: number = this.currentMediaDataRegion.end - this.currentMediaDataRegion.start + 1;
    if (itemCountPerGroup !== 0 && this.currentMediaDataRegion.start >= itemCountPerGroup) {
      // 多刷新前一个宫格(start左侧)的元数据
      start -= itemCountPerGroup;
      count += itemCountPerGroup;
    }
    if (!isFullQuery) {
      let left: number = start;
      let right: number = start + count;
      let i: number = left;
      let j: number = right;
      if (i <= this.cachedMediaItem.length) {
        while (i <= right) {
          if (!this.cachedMediaItem[i]?.dateModified) {
            break;
          }
          i++;
        }
      }
      if (this.cachedMediaItem.length >= right) {
        while (j >= left) {
          if (!this.cachedMediaItem[j]?.dateModified) {
            break;
          }
          j--;
        }
      }
      if (j >= i) {
        start = i;
        count = j - i + 1;
        Log.info(TAG, `[accurateNotify] YM incremental items: loadStart: ${start} loadCount: ${count}`);
      }
    }
    let queryParam: YearMonthQueryParam = new YearMonthQueryParam(start, count, Priority.HIGH);
    Log.i(TAG, `refreshCurrentView:${this.currentView}, ${this.currentViewRegion.toString()}` +
      `, ${this.currentMediaDataRegion.toString()}, ${queryParam.toString()}`);
    this.queryMediaItemAsync(queryParam);
  }

  /**
   * 记录当前年月视图宫格索引区间
   *
   * @param start 宫格索引起点
   * @param end 宫格索引终点
   */
  public recordCurrentViewIndex(start: number, end: number): void {
    if (start < 0 || end < 0 || start > end) {
      return;
    }

    this.lastViewRegion.start = this.currentViewRegion.start;
    this.lastViewRegion.end = this.currentViewRegion.end;
    this.currentViewRegion.start = start;
    this.currentViewRegion.end = end;

    // 年月视图宫格索引发生变化时，若当前在元数据变更期间：
    // a) 如果是由非滑动/滚动触发的宫格索引变化，则需要针对当前界面发起元数据重查，确保基于重查结果进行界面刷新；
    // b) 如果是由滑动/滚动浏览过程触发的宫格索引变化，则没必要进行界面刷新，避免滑动/滚动中宫格缩略图产生变化、影响体验
    if (this.isMediaDataChanging() && !this.isScrolling) {
      if (this.currentViewRegion.start >= this.lastViewRegion.start &&
        this.currentViewRegion.end <= this.lastViewRegion.end) {
        // 当前视图区间与前一次视图区间重叠、或者为子集时，不需要再触发元数据重查
        return;
      }

      this.computeCurrentMediaDataRegion();
      if (!this.currentMediaDataRegion.isValid()) {
        return;
      }

      Log.debug(TAG, `recordCurrentViewIndex, dataChanging, ${this.lastViewRegion.toString()}` +
        `, ${this.currentViewRegion.toString()}, ${this.currentMediaDataRegion.toString()}`);
      let count: number = this.currentMediaDataRegion.end - this.currentMediaDataRegion.start + 1;
      let queryParam: YearMonthQueryParam = new YearMonthQueryParam(
        this.currentMediaDataRegion.start, count, Priority.HIGH);
      this.queryMediaItemAsync(queryParam);
    }
  }

  /**
   * 主线程同步查询元数据
   *
   * @param queryParam 查询参数
   * @returns 查询结果
   */
  // public queryMediaItemSync(queryParam: YearMonthQueryParam): YearMonthMediaItem[] {
  //   if (!queryParam || !queryParam.isValid()) {
  //     return [];
  //   }
  //   let ret: YearMonthMediaItem[] = YearMonthUtil.queryMediaItem(SendablePhotoAccessHelper.getInstance(),
  //     queryParam.start, queryParam.count, queryParam.priority, ImageUtil.isThumbnailReady());
  //   this.saveMediaItemDataToCache(queryParam.start, ret);
  //   return ret;
  // }

  /**
   * 子线程异步查询元数据
   *
   * @param queryParam 查询参数
   */
  public queryMediaItemAsync(queryParam: YearMonthQueryParam): void {
    this.yearMonthQueryWorker.addHighMediaDataTask(queryParam, this.getMediaItemDataCallbackFunc);
  }

  /**
   * 取消子线程异步查询元数据的任务
   *
   * @param queryParam 查询参数
   */
  public cancelQueryMediaItem(queryParam: YearMonthQueryParam): void {
    this.yearMonthQueryWorker.removeMediaDataTask(queryParam);
  }

  /**
   * 异步查询数据回调通知结果
   *
   * @param queryParam 查询参数
   * @param mediaItems 查询结果
   */
  private onQueryMediaItemResult(queryParam: YearMonthQueryParam,
    mediaItems: YearMonthMediaItem[]): void {
    if (!queryParam || !queryParam.isValid()) {
      Log.w(TAG, 'onQueryMediaItemResult queryParam invalid');
      return;
    }
    if (!mediaItems || mediaItems.length === 0) {
      Log.w(TAG, `onQueryMediaItemResult mediaItems invalid, ${queryParam.toString()}`);
      return;
    }
    if (mediaItems.length !== queryParam.count) {
      Log.w(TAG, `query count: ${queryParam.count} mismatch with callback` +
        ` media count:${mediaItems.length}, ${queryParam.toString()}`);
    }

    if ((queryParam.priority === Priority.HIGH) ||
      (queryParam.priority === Priority.LOW && queryParam.start % Constants.YEAR_MONTH_MEDIA_DATA_BATCH_NUM === 0)) {
      // 控制低优先级任务的查询结果打印，避免低优先级打印高频
      Log.i(TAG, `onQueryMediaItemResult, ${queryParam.toString()}`);
    }
    this.saveMediaItemDataToCache(queryParam.start, mediaItems);
    if (queryParam.priority === Priority.HIGH) {
      // 回调通知页面刷新
      this.notifyCallbackFunc();

      // 针对预查询，发起相应区间的图片预加载
      if (queryParam.isPreQuery) {
        this.cacheViewPixelMap(queryParam, mediaItems);
      }
      return;
    }
    if (queryParam.priority === Priority.LOW) {
      // 收到所有低优先级查询任务结果时，刷新标志位表示元数据不在变更中
      if (queryParam.start + queryParam.count >= this.currentMediaCount) {
        Log.i(TAG, `low-prio query finish, ${queryParam.toString()}, mediaCount:${this.currentMediaCount}`);
        this.setMediaDataChanging(false);
      }
    }
  }

  /**
   * 记录年月视图元数据变更信息
   *
   * @param nfyInfo 元数据变更信息
   */
  public recordMediaDataChange(nfyInfo: MediaObserverNfyInfo): void {
    // 年月视图仅响应新增、删除、更新通知
    if (!nfyInfo || nfyInfo.type < MediaObserverNfyType.PHOTO_ADD ||
      nfyInfo.type > MediaObserverNfyType.PHOTO_ADD_ASTC) {
      return;
    }

    this.needHandleMediaDataChange = true;
  }

  /**
   * 是否在元数据变更中
   *
   * @returns true表示在元数据变更中
   */
  private isMediaDataChanging(): boolean {
    return this.isDuringMediaDataChange;
  }

  /**
   * 设置是否在元数据变更中
   *
   * @param isChanging true表示在元数据变更中
   */
  private setMediaDataChanging(isChanging: boolean): void {
    this.isDuringMediaDataChange = isChanging;
  }

  /**
   * 通知查询年月视图元数据
   *
   * @param totalMediaCount 元数据总数
   */
  public notifyQueryMediaData(totalMediaCount: number, nfyChangeInfos?: PhotoAssetChangeInfos): void {
    if (totalMediaCount < 0) {
      return;
    }

    this.currentMediaCount = totalMediaCount;

    // 冷启动时首次触发一次元数据查询
    if (this.needInitMediaDataQuery) {
      Log.i(TAG, `init trigger year month media data query, mediaCount:${totalMediaCount}`);
      this.needCreateMediaDataQueryTask = true;
      this.queryMediaData(totalMediaCount);
      this.needInitMediaDataQuery = false;
      return;
    }

    let isFullQuery: boolean = true;
    if (!this.isDuringMediaDataChange && nfyChangeInfos?.assetChangeDatas?.length) {
      isFullQuery = this.handleChangeInfo(nfyChangeInfos);
    }

    // 针对元数据变更场景进行处理
    this.queryMediaDataOnChange(totalMediaCount, isFullQuery);
  }

  /**
   * 增量更新年月视图元数据
   *
   * @param changeInfo 媒体库通知信息
   *
   * @returns true表示不能增量更新，需要全量查询
   */
  private handleChangeInfo(changeInfo: PhotoAssetChangeInfos): boolean {
    Log.info(TAG, `handleChangeInfo ${changeInfo.type} ${changeInfo.assetChangeDatas?.length}`);
    if (changeInfo?.assetChangeDatas === null || changeInfo.assetChangeDatas?.length === 0) {
      return true;
    }
    if (changeInfo.type === photoAccessHelper.NotifyChangeType.NOTIFY_CHANGE_ADD) {
      for (let asset of changeInfo.assetChangeDatas) {
        if (asset.assetAfterChange === null || (ImageUtil.isThumbnailReady() &&
          asset.assetAfterChange.thumbnailVisible !== 1)) {
          return true;
        }
        let item: YearMonthMediaItem = new YearMonthMediaItem(asset.assetAfterChange.dateTakenMs,
          asset.assetAfterChange.fileId, 0, asset.assetAfterChange.mediaType);
        if (!this.insertToCache(item)) {
          return true;
        };
      }
    } else if (changeInfo.type === photoAccessHelper.NotifyChangeType.NOTIFY_CHANGE_REMOVE) {
      for (let asset of changeInfo.assetChangeDatas) {
        if (asset.assetBeforeChange === null || (ImageUtil.isThumbnailReady()
          && asset.assetBeforeChange.thumbnailVisible === 1)) {
          return true;
        }
        let item: YearMonthMediaItem = new YearMonthMediaItem(asset.assetBeforeChange.dateTakenMs,
          asset.assetBeforeChange.fileId, 0, asset.assetBeforeChange.mediaType);
        this.deleteItem(item);
      }
    } else {
      if (!ImageUtil.isThumbnailReady()) {
        return true;
      }
      for (let asset of changeInfo.assetChangeDatas) {
        if (asset.assetAfterChange === null || asset.assetBeforeChange === null) {
          return true;
        }
        if (asset.assetBeforeChange.thumbnailVisible === 0 && asset.assetAfterChange.thumbnailVisible === 1) {
          let item: YearMonthMediaItem = new YearMonthMediaItem(asset.assetAfterChange.dateTakenMs,
            asset.assetAfterChange.fileId, 0, asset.assetAfterChange.mediaType);
          if (!this.insertToCache(item)) {
            return true;
          };
        } else if (asset.assetBeforeChange.thumbnailVisible === 1 && asset.assetAfterChange.thumbnailVisible === 0) {
          let item: YearMonthMediaItem = new YearMonthMediaItem(asset.assetBeforeChange.dateTakenMs,
            asset.assetBeforeChange.fileId, 0, asset.assetBeforeChange.mediaType);
          this.deleteItem(item);
        }
      }
    }

    return false;
  }

  /**
   * 插入一条年月视图元数据到全量缓存数据中
   *
   * @param item 一条年月元数据
   *
   * @returns true表示插入成功，不需要全量查询
   */
  private insertToCache(item: YearMonthMediaItem): boolean {
    let left: number = 0;
    let right: number = this.cachedMediaItem.length - 1;
    let pos: number = this.cachedMediaItem.length;
    let mid: number = 0;

    while (left <= right) {
      mid = Math.floor((left + right) / 2);
      if (this.cachedMediaItem[mid]?.dateTaken < item.dateTaken) {
        pos = mid;
        right = mid - 1;
      } else {
        left = mid + 1;
      }
    }

    if (pos - 1 >= 0 && this.cachedMediaItem[pos - 1]?.dateTaken === item.dateTaken) {
      return false;
    }

    if (pos + 1 < this.cachedMediaItem.length && this.cachedMediaItem[pos + 1]?.dateTaken === item.dateTaken) {
      return false;
    }

    Log.debug(TAG, `[accurateNotify] insertToCache pos: ${pos}`);
    this.cachedMediaItem.splice(pos, 0, item);
    return true;
  }

  /**
   * 从全量缓存数据中删除一条年月视图元数据
   *
   * @param item 一条年月元数据
   */
  private deleteItem(item: YearMonthMediaItem): void {
    let left: number = 0;
    let right: number = this.cachedMediaItem.length - 1;
    let mid: number = 0;
    while (left <= right) {
      mid = Math.floor((left + right) / 2);
      if (item.dateTaken === this.cachedMediaItem[mid]?.dateTaken) {
        if (item.fileId === this.cachedMediaItem[mid]?.fileId) {
          Log.debug(TAG, `[accurateNotify] deleteItem pos: ${mid}`);
          this.cachedMediaItem.splice(mid, 1);
          return;
        } else {
          let leftIndex = mid - 1;
          let rightIndex = mid + 1;
          while (leftIndex >= left) {
            if (this.cachedMediaItem[leftIndex]?.dateTaken !== item.dateTaken) {
              break;
            }
            if (this.cachedMediaItem[leftIndex]?.fileId === item.fileId) {
              Log.debug(TAG, `[accurateNotify] deleteItem pos: ${leftIndex}`);
              this.cachedMediaItem.splice(leftIndex, 1);
              return;
            }
            leftIndex--;
          }
          while (rightIndex <= right) {
            if (this.cachedMediaItem[rightIndex]?.dateTaken !== item.dateTaken) {
              break;
            }
            if (this.cachedMediaItem[rightIndex]?.fileId === item.fileId) {
              Log.debug(TAG, `[accurateNotify] deleteItem pos: ${rightIndex}`);
              this.cachedMediaItem.splice(rightIndex, 1);
              return;
            }
            rightIndex++;
          }
          return;
        }
      } else if (this.cachedMediaItem[mid]?.dateTaken < item.dateTaken) {
        right = mid - 1;
      } else {
        left = mid + 1;
      }
    }
  }

  /**
   * 元数据变更时进行查询
   *
   * @param totalMediaCount 元数据总数
   */
  private queryMediaDataOnChange(totalMediaCount: number, isFullQuery: boolean = true): void {
    if (!this.needHandleMediaDataChange) {
      // 过滤不需要处理的元数据变更场景
      Log.debug(TAG, `notifyQueryMediaData, ignore other data change, mediaCount:${totalMediaCount}`);
      return;
    }

    // 销毁状态时，不再响应
    if (this.isDestroyed) {
      Log.i(TAG, `notifyQueryMediaData, ignore when destroyed, mediaCount:${totalMediaCount}`);
      return;
    }

    Log.i(TAG, `notifyQueryMediaData, currentView:${this.currentView}, isCurrentViewShown:${this.isCurrentViewShown}` +
      `, mediaCount:${totalMediaCount}`);

    // 元数据发生变更时，需要移除所有剩余的低优先级任务，不再冗余查询
    this.yearMonthQueryWorker.removeAllLowTasks();

    // 设置状态标志，表示元数据是否在变更中，当此次元数据后台全量查询结束后，恢复标志位
    this.setMediaDataChanging(true);
    this.needCreateMediaDataQueryTask = true;

    if (this.isCurrentViewShown) {
      // 元数据发生变更时，若当前视图在前台，则高优先级触发刷新当前视图的元数据，并重新触发全量元数据查询
      this.refreshCurrentView(isFullQuery);
      this.queryThrottle.execute(() => { this.queryMediaData(totalMediaCount); });
    } else {
      // 元数据发生变更时，若当前视图在后台，则暂不处理并置标志位，等回到前台时触发
      this.needRefreshView = true;
    }

    // 恢复标志位，以应对下一次元数据变更
    this.needHandleMediaDataChange = false;
  }

  /**
   * 查询元数据
   *
   * @param totalMediaCount 元数据总数
   */
  private queryMediaData(totalMediaCount: number): void {
    // 年月视图不在前台时，仅记录参数，不触发批量任务创建，查询任务挂起。年月视图在前台时，触发批量任务创建，发起查询任务
    if (this.isCurrentViewShown && !this.isCreatingBatchTask && totalMediaCount !== 0) {
      this.handleQueryTask();
    }
  }

  /**
   * 处理元数据查询任务
   */
  private handleQueryTask(): void {
    this.isCreatingBatchTask = true;

    if (this.isEnableBackgroundMediaQuery) {
      // 创建批量后台元数据查询任务。注意：需要分为较大的批次进行查询，如果按每个年视图宫格数160个进行查询，
      // 则会导致taskpool异步查询任务过多，导致查询时内存占用来不及释放
      this.yearMonthQueryWorker.addBatchMediaDataTask(0, this.currentMediaCount,
        Constants.YEAR_ITEM_GROUP_COUNT * Constants.YEAR_ITEM_COUNT_PER_GROUP,
        this.getMediaItemDataCallbackFunc);
    }

    this.needCreateMediaDataQueryTask = false;
    this.isCreatingBatchTask = false;
  }

  /**
   * 计算当前视图所在的元数据区间
   */
  private computeCurrentMediaDataRegion(): void {
    let itemCountPerGroup: number = this.getItemCountPerGroup(this.currentView);
    if (itemCountPerGroup !== 0) {
      this.currentMediaDataRegion.start = this.currentViewRegion.start * itemCountPerGroup;
      this.currentMediaDataRegion.end = (this.currentViewRegion.end + 1) * itemCountPerGroup - 1;
      if (this.currentMediaDataRegion.end + 1 > this.currentMediaCount) {
        this.currentMediaDataRegion.end = this.currentMediaCount - 1;
      }
    }
  }

  /**
   * 暂停元数据后台查询任务
   */
  public pauseCachingMediaItemDataTask(): void {
    Log.i(TAG, 'pauseCachingMediaItemDataTask');
    this.yearMonthQueryWorker.pauseLowMediaDataTask();
  }

  /**
   * 恢复元数据后台查询任务
   */
  public resumeCachingMediaItemDataTask(): void {
    if (!this.isCurrentViewShown) {
      Log.i(TAG, 'year or month not shown, do not resume tasks');
      return;
    }

    Log.i(TAG, `resumeCachingMediaItemDataTask, currentView:${this.currentView}` +
      `, needRefreshView:${this.needRefreshView}`);

    if (this.needRefreshView) {
      // 当年月视图回到前台时，需要高优先级触发刷新当前视图
      this.needRefreshView = false;
      this.refreshCurrentView();
    }

    // 继续执行剩余任务
    this.yearMonthQueryWorker.resumeMediaDataTask();

    // 数据变更挂起的任务触发查询（无任务正在创建，并且图片数量不为0）
    if (this.needCreateMediaDataQueryTask && !this.isCreatingBatchTask && this.currentMediaCount !== 0) {
      Log.i(TAG, `resume handleQueryTask, currentView:${this.currentView}, mediaCount:${this.currentMediaCount}`);
      this.handleQueryTask();
    }
  }

  /**
   * 保存年月视图元数据
   *
   * @param start 元数据起始
   * @param items 元数据
   */
  public saveMediaItemDataToCache(start: number, items: YearMonthMediaItem[]) {
    if (start < 0 || !items || items.length === 0) {
      return;
    }

    for (let index: number = 0; index < items.length; index++) {
      if (!items[index]) {
        continue;
      }
      this.cachedMediaItem[start + index] = items[index];
    }
  }

  /**
   * 查询年月视图元数据
   *
   * @param queryParam 查询参数
   * @returns 年月视图元数据
   */
  public queryCachedMediaItemData(queryParam: YearMonthQueryParam): YearMonthMediaItem[] {
    if (this.cachedMediaItem.length === 0) {
      return [];
    }
    if (!queryParam || !queryParam.isValid()) {
      return [];
    }

    let items: YearMonthMediaItem[] | undefined = this.cachedMediaItem.slice(
      queryParam.start, queryParam.start + queryParam.count);
    if (!items || items.length !== queryParam.count) {
      // 查询不到，或者查询到的数量跟预期数量不一致，均认为失败
      return [];
    }
    for (let item of items) {
      if (!item) {
        // 只要有一个item查询不到，则认为整批查询失败
        return [];
      }
    }
    return items;
  }

  /**
   * 清空缓存的年月视图所有元数据
   */
  public clearAllCachedMediaItemData() {
    this.cachedMediaItem = [];
  }

  /**
   * 查询缓存的年月dateTaken信息
   *
   * @param index 查询位置
   * @returns 查询到的年月dateTaken信息
   */
  public queryDateTakenInfo(index: number): number | undefined {
    return this.cachedMediaItem[index]?.dateTaken;
  }

  /**
   * 缓存年月视图View数据
   *
   * @param viewKey View键
   * @param viewData View数据
   */
  public cacheViewData(viewKey: string, viewData: YearMonthViewData): void {
    if (!viewKey) {
      return;
    }
    if (viewData === null) {
      return;
    }
    this.cachedViewData.put(viewKey, viewData);
  }

  /**
   * 获取缓存的年月视图View数据
   *
   * @param viewKey View键
   * @returns View数据
   */
  public getCachedViewData(viewKey: string): YearMonthViewData | undefined {
    if (!viewKey) {
      return undefined;
    }
    return this.cachedViewData.get(viewKey);
  }

  /**
   * 清空缓存的年月视图所有View数据
   */
  public clearAllCachedViewData(): void {
    if (this.cachedViewData.length !== 0) {
      this.cachedViewData.clear();
    }
  }

  /**
   * 缓存年月视图元数据索引区间对应的图片PixelMap
   *
   * @param queryParam 查询参数
   * @param mediaItems 年月视图元数据
   */
  private cacheViewPixelMap(queryParam: YearMonthQueryParam, mediaItems: YearMonthMediaItem[]): void {
    let itemCountPerGroup: number = this.getItemCountPerGroup(this.currentView);
    let itemColumnPerGroup: number = this.getItemColumnPerGroup(this.currentView);
    let itemWidthPerGroup: number = this.getItemWidthPerGroup(this.currentView);
    if (itemCountPerGroup === 0 || itemColumnPerGroup === 0 || itemWidthPerGroup === 0) {
      return;
    }

    let viewKey: string = YearMonthUtil.generateYearMonthViewKey(this.currentView,
      itemCountPerGroup, itemColumnPerGroup, queryParam.start / itemCountPerGroup);
    let viewData: YearMonthViewData | undefined = this.getCachedViewData(viewKey);
    if (viewData) {
      viewData.updateViewDataIfNeed(this.currentView, itemWidthPerGroup, mediaItems, queryParam.count);
    } else {
      viewData = new YearMonthViewDataBuilder()
        .viewKey(viewKey)
        .currentView(this.currentView)
        .viewWidth(itemWidthPerGroup)
        .column(itemColumnPerGroup)
        .build(mediaItems, queryParam.count);
    }
    this.cacheViewData(viewKey, viewData);

    // let astcResources: mediaImageLoader.ASTCResource[] = [];
    // astcResources.push({ sources: viewData.data.uris, column: viewData.column });
    // Log.i(TAG, `cacheViewPixelMap, ${queryParam.toString()}`);
    // let requestOption: mediaImageLoader.RequestOptions =
    //   { width: viewData.data.thumbnailSize, height: viewData.data.thumbnailSize };
    // ImageCacheUtil.startCachingASTCResources(astcResources, requestOption);
  }
}