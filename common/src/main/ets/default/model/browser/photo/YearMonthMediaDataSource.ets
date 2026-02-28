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

import lazy { MediaItem } from './MediaItem';
import lazy { Log } from '../../../utils/Log';
import lazy { BroadCastConstants } from '../../common/BroadCastConstants';
import lazy { BroadCast } from '../../../utils/BroadCast';
import lazy { BroadCastManager } from '../../common/BroadCastManager';
import lazy { Constants } from '../../common/Constants';
import lazy { PendingTask } from './PendingTask';
import type { PendingCondition } from './PendingCondition';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy { BrowserDataFactory } from '../../../interface/BrowserDataFactory';
import type { BrowserDataInterface } from '../../../interface/BrowserDataInterface';
import lazy { FetchType } from '../../../interface/BrowserDataInterface';
import type { ViewData } from './ViewData';
import type { PhotoDataImpl } from './PhotoDataImpl';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../../utils/ReportToBigDataUtil';
import lazy {
  MediaChangeDataSource,
  MediaDataProvider,
  MediaObserverNfyInfo,
  MediaObserverNfyType
} from '../dataObserver/MediaObserverCallback';
import lazy { PhotoQueryWorker } from './PhotoQueryWorker';
import lazy { AlbumInfo } from '../../browser/album/AlbumInfo';
import lazy { AlbumDataSource } from '../../AlbumDataSource';
import lazy LightWeightMap from '@ohos.util.LightWeightMap';
import lazy { YearMonthDataManager } from './YearMonthDataManager';
import lazy { YearMonthMediaItem } from './YearMonthMediaItem';
import lazy { YearMonthQueryParam } from './YearMonthQueryParam';
import lazy { YearMonthUtil } from './YearMonthUtil';
import lazy { ImageUtil } from '../../../utils/ImageUtil';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import { PhotoAssetChangeInfos } from '../dataObserver/MediaObserver';

const TAG: string = 'common_YearMonthMediaDataSource';

export class YearMonthMediaDataSource extends AlbumDataSource implements MediaChangeDataSource {
  // Number of first pictures loaded during initialization
  private static readonly ONE_SCREEN_COUNT = 432;
  private static readonly YEAR_MONTH_UPDATE_TIMEOUT_MS = 2000;
  private static readonly MATH_HALF = 2;
  private static readonly MATH_DOUBLE = 2;
  public static DATE_TAKEN_INFO_CACHE_NUM: number = 500;
  // Album list, all photos, etc. may involve album aggregation display, so multiple albums are required
  public photoDataImpl: BrowserDataInterface | PhotoDataImpl;
  // Number of elements in layout
  public size: number = 0;
  public realSize: number = 0;
  public getItemCountFinish: boolean = false;
  // Number of media in the dataset
  public mediaCount: number = 0;
  // Number of exhibit data count, recorded to avoid querying all data frequently
  public mediaDataProvider: MediaDataProvider = MediaDataProvider.getInstance();
  // 继承MediaChangeDataSource
  public needRefreshCount: boolean = true;
  // Is the quantity changed
  public isCountChanged: boolean = false;
  // Is the quantity changed
  public isCountReduced: boolean = false;
  public addedCount: number = 0;
  // Save the amount of data of a window size
  public items: MediaItem[] = [];
  // First item of the year or month
  public firstItem: MediaItem | undefined = undefined;
  // Save the amount of data of a window size
  public cameraItems: MediaItem[] = [];
  public queryWorker: PhotoQueryWorker;
  public getPhotoDataCallbackFunc: Function =
    (assets: MediaItem[], start: number, dataAlbumUri: string):
      void => this.getPhotoDataCallback(assets, start, dataAlbumUri);
  public dataRequestTime: number = 0;
  public firstFetchDataRequestTime: number = 0;
  public initDataTraceName: string = 'MediaDataSourceInitData';
  public getPhotoDataCountCallbackFunc: Function =
    (count: number, dataAlbumUri: string): void => this.getPhotoDataCountCallback(count, dataAlbumUri);
  public dataCountRequestTime: number = 0;
  public yearMonthDayViewIndex: number = 0;
  public nfyPendingCount: number = 0;
  public lastNfyTimestamp: number = 0;
  public nfyTimer: number = 0;
  // dataIndex to layoutIndex
  public broadCast: BroadCast | undefined;
  public photosBroadCast?: BroadCast;
  // The BroadCast of the application process. Event registration and destruction should be paired
  public appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  // Whether to delay updating data
  public isPendingUpdateData: boolean = true;
  // Request time of the first batch of data
  public firstPatchDataRequestTime: number = 0;
  // 删除ID，通知统一使用uri，准确查询整机相册中的资源，图库再通过uri识别系统相册。
  public albumUri: string = '';
  public filterMediaType: string = '';
  public isRefresh: boolean = false;
  public isEditSaveReload: boolean = false;
  public validEndIndex: number = 0;
  public enableGetDataFlag: boolean = true;
  public deleteIndex: number = -1;
  // 月视图数据偏移量
  private monthDataOffset: number = 0;
  // 年视图数据偏移量
  private yearDataOffset: number = 0;
  // 当前页面的标识
  private currentViewType: number = 0;
  // 配置为1.5屏年视图的数据，需要根据设备计算，默认为800张缩略图
  private maxPhotosNum: number = 800;
  /**
   * 是否在滑动时访问数据
   */
  private isAccessData: boolean = false;
  public isYearMonthViewShown: boolean = false;
  public isDayViewShown: boolean = true;
  // 元数据管理
  private yearMonthDataManager: YearMonthDataManager;
  // 元数据变更通知dataSource刷新
  private mediaItemDataChangeFunc: Function = (): void => this.onQueryMediaItemResult();
  // 指定数据量以内，若未命中缓存，采用主线程查询；超过指定数据量，若未命中缓存，采用子线程查询
  private maxMediaQueryCount: number;
  /**
   * 是否支持同步查询年月元数据
   */
  private isEnableSyncMediaQuery: boolean;
  /**
   * 缓存count变化时的年月通知数据
   */
  private nfyChangeInfos: PhotoAssetChangeInfos[] = [];

  constructor(windowSize: number, photoDataImpl?: PhotoDataImpl) {
    super({
      context: getContext() || global.uiAbilityContext(),
      albumInfo: new AlbumInfo(),
      windowSize:windowSize,
      dataImpl:photoDataImpl,
    });
    this.photoDataImpl =
      photoDataImpl ?? BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO);
    this.windowSize = windowSize;
    this.activeEnd = windowSize;
    this.items = new Array<MediaItem>(windowSize);
    this.queryWorker = new PhotoQueryWorker(this.photoDataImpl as BrowserDataInterface);
    this.queryWorker.updateGetDataTaskCoverage(this.activeStart, this.activeEnd);
    this.yearMonthDataManager = new YearMonthDataManager(this.mediaItemDataChangeFunc);
    this.maxMediaQueryCount = YearMonthUtil.getMaxMediaQueryCount();
    this.isEnableSyncMediaQuery = YearMonthUtil.isEnableSyncMediaQuery();
  }

  public onDestroy(): void {
    this.yearMonthDataManager.onDestroy();
  }

  /* instrument ignore next */
  public releaseBroadCast(): void {
    Log.debug(TAG, 'release all appBroadCast');
    this.appBroadCast.off(BroadCastConstants.PHOTO_BROWSER_ACTIVE, this.browserActiveCallback);
    this.broadCast?.off(BroadCastConstants.PHOTO_BROWSER_ACTIVE, this.browserActiveCallback);
    super.releaseBroadCast();
    this.releasePhotoBroadCast();
  }

  /* instrument ignore next */
  public setDeleteIndex(index: number): void {
    this.deleteIndex = index;
    this.hasNewChange = false;
  }

  /* instrument ignore next */
  public getDeleteIndex(): number {
    return this.deleteIndex;
  }

  public setYearMonthDayViewIndex(yearMonthDayViewIndex: number): void {
    if (!this.enableGetDataFlag) {
      return;
    }
    Log.info(TAG, `setYearMonthDayViewIndex yearMonthDayViewIndex=${yearMonthDayViewIndex}`);
    this.yearMonthDayViewIndex = yearMonthDayViewIndex;
  }

  /* instrument ignore next */
  public totalCount(): number {
    if (this.lastTotalCount !== this.size) {
      Log.info(TAG, `totalCount: ${this.size}`);
      this.lastTotalCount = this.size;
    }
    return this.size;
  }

  /* instrument ignore next */
  public realTotalCount(): number {
    Log.info(TAG, `realTotalCount: ${this.size}, ${this.getItemCountFinish}`);
    if (this.getItemCountFinish) {
      return this.size;
    }
    return -1;
  }

  /* instrument ignore next */
  public getData(index: number): ViewData | undefined {
    return undefined;
  }

  public getYearMonthDataManager(): YearMonthDataManager {
    return this.yearMonthDataManager;
  }

  /**
   * 是否同步查询元数据
   * a) 若prop开关设置为不支持同步查询（默认支持），则进行子线程查询
   * b) 若携带查询参数，且参数指定强制同步查询，则进行主线程查询
   * c) 若未携带强制同步查询参数，则指定数据量以内，采用主线程查询；超过指定数据量，采用子线程查询
   *
   * @param queryParam 查询参数（可选），携带是否强制同步查询标志
   * @returns true表示同步查询元数据
   */
  public isSyncQuery(queryParam?: YearMonthQueryParam): boolean {
    if (!this.isEnableSyncMediaQuery) {
      return false;
    }
    if (queryParam && queryParam.isForceSyncQuery) {
      return true;
    }
    return this.mediaCount <= this.maxMediaQueryCount;
  }

  // public queryMediaItems(queryParam: YearMonthQueryParam): YearMonthMediaItem[] {
  //   // // 查询缓存
  //   // let mediaItems: YearMonthMediaItem[] = this.yearMonthDataManager.queryCachedMediaItemData(queryParam);
  //   // if (mediaItems.length !== 0) {
  //   //   return mediaItems;
  //   // }
  //   //
  //   // /* instrument ignore if*/
  //   // /* instrument ignore else*/
  //   // if (this.isSyncQuery(queryParam)) {
  //   //   // 调用方指定要求主线程查询，或者未指定、但是元数据少于指定数据量，采用主线程同步查询
  //   //   // return this.yearMonthDataManager.queryMediaItemSync(queryParam);
  //   // } else {
  //   //   // 元数据超过指定数据量，采用子线程异步查询
  //   //   this.yearMonthDataManager.queryMediaItemAsync(queryParam);
  //   //   return [];
  //   // }
  // }

  public cancelQueryMediaItems(queryParam: YearMonthQueryParam): void {
    if (this.mediaCount > this.maxMediaQueryCount) {
      // 超过指定数据量，元数据为子线程异步查询，支持任务取消
      this.yearMonthDataManager.cancelQueryMediaItem(queryParam);
    }
  }

  /**
   * 设置是否访问数据
   *
   * @param isAccessData 是否访问数据
   */
  public setAccessDataFlag(isAccessData: boolean): void {
    this.isAccessData = isAccessData;
  }

  public getCachedDateTaken(key: number): number | undefined {
    // return this.yearMonthDataManager.queryDateTakenInfo(key);
    return undefined
  }

  /* instrument ignore next */
  public updateSlidingWindowForMediaItemGroup(startIndex: number, count: number): void {
    let endIndex: number = startIndex + count;
    let windowCenter: number = Math.round((this.activeStart + this.activeEnd) / YearMonthMediaDataSource.MATH_HALF);
    let startDiff: number = Math.abs(startIndex - windowCenter);
    let endDiff: number = Math.abs(endIndex - windowCenter);
    let newWindowCenter: number = windowCenter;
    if (startDiff > this.windowSize / YearMonthMediaDataSource.MATH_HALF) {
      if (startIndex < newWindowCenter) {
        newWindowCenter = windowCenter - (startDiff - this.windowSize / YearMonthMediaDataSource.MATH_HALF);
      } else {
        newWindowCenter = windowCenter + (startDiff - this.windowSize / YearMonthMediaDataSource.MATH_HALF);
      }
    } else if (endDiff > this.windowSize / YearMonthMediaDataSource.MATH_HALF) {
      if (endIndex < newWindowCenter) {
        newWindowCenter = windowCenter - (endDiff - this.windowSize / YearMonthMediaDataSource.MATH_HALF);
      } else {
        newWindowCenter = windowCenter + (endDiff - this.windowSize / YearMonthMediaDataSource.MATH_HALF);
      }
    } else {
      Log.info(TAG, `No need to update slidingWindow, index[${startIndex}, ${endIndex}],
        Diff: [${startDiff}, ${endDiff}], oldWindowCenter = ${windowCenter}, newWindowCenter = ${newWindowCenter}`);
      return;
    }
    Log.info(TAG, `updateSlidingWindowForMediaItemGroup, index[${startIndex}, ${endIndex}], ` +
      `oldWindowCenter = ${windowCenter}, newWindowCenter = ${newWindowCenter}`);
    this.updateSlidingWindowInner(newWindowCenter);
  }

  /* instrument ignore next */
  public getPhotoDataCallback(assets: MediaItem[], start: number, dataAlbumUri: string): void {
    if (this.isInvalidData(this.albumUri, dataAlbumUri)) {
      Log.error(TAG, 'initData isInvalidData: this.albumUri:' + this.albumUri + ` dataAlbumUri:${dataAlbumUri}`);
      return;
    }
    if (assets?.length > 0) {
      this.updateMediaData(this.dataRequestTime, start, assets, true);
    }
    ReportToBigDataUtil.report(BigDataConstants.DATA_LOAD_FINISH);
    return;
  }

  public getPhotoDataCountCallback(count: number, dataAlbumUri: string): void {
    if (this.isInvalidData(this.albumUri, dataAlbumUri)) {
      Log.error(TAG, 'initData isInvalidData: this.albumUri:' + this.albumUri + ` dataAlbumUri:${dataAlbumUri}`);
      return;
    }
    this.updateMediaCount(this.dataCountRequestTime, count);
    this.needRefreshCount = false;
    ReportToBigDataUtil.report(BigDataConstants.DATA_LOAD_FINISH);
    return;
  }

  /* instrument ignore next */
  public updateMediaData(requestTime: number, start: number, mediaItems: MediaItem[], onInit?: boolean): void {
    if (requestTime === this.firstPatchDataRequestTime && this.isPendingUpdateData && this.size === 0) {
      Log.info(TAG, 'the callback of mediaItems is earlier than that of count.');
      this.updateCountThroughMediaItems(requestTime, mediaItems);
      this.mediaDataUpdateExecutor(requestTime, start, mediaItems);
      TraceControllerUtils.finishTrace(this.initDataTraceName);
      return;
    }
    if (this.isPendingUpdateData) {
      Log.info(TAG, 'isPendingUpdateData execute start');
      this.pendingUpdateData?.execute((): void => {
        this.mediaDataUpdateExecutor(requestTime, start, mediaItems);
        TraceControllerUtils.finishTrace(this.initDataTraceName);
      });
      return;
    }
    this.mediaDataUpdateExecutor(requestTime, start, mediaItems);
    TraceControllerUtils.finishTrace(this.initDataTraceName);
  }

  /* instrument ignore next */
  public mediaDataUpdateExecutor(requestTime: number, start: number, mediaItems: MediaItem[]): void {
    TraceControllerUtils.startTraceWithTaskId('yearMonthMediaDataUpdateExecutor', requestTime);
    Log.info(TAG, `yearMonthMediaDataUpdateExecutor requestTime: ${
    requestTime}, start: ${start}, this.addedCount: ${this.addedCount}` +
      `, count = ${mediaItems.length}, this.isEditSaveReload: ${this.isEditSaveReload}`);
    if (this.lastUpdateTime < this.lastRequestTime && this.isActive) {
      this.loadData();
    } else {
      this.hasNewChange = false;
    }
    if (!mediaItems?.length) {
      Log.error(TAG, 'results are empty!');
      return;
    }
    if (start >= this.activeEnd || start + mediaItems.length <= this.activeStart) {
      Log.warn(TAG, 'results are not in active window');
      return;
    }
    Log.info(TAG, `yearMonthMediaDataUpdateExecutor mediaItemsLen: ${mediaItems.length}, listenersLen: ${
    this.listeners.length}`);
    let fromIndex = Math.max(start, this.activeStart);
    let endIndex = Math.min(this.activeEnd, start + mediaItems.length);
    this.validEndIndex = endIndex - 1;
    for (let i = fromIndex; i < endIndex; i++) {
      this.items[i - this.activeStart] = mediaItems[i - start];
    }
    this.triggerDataRefresh(fromIndex, endIndex);
    if (this.isEditSaveReload && this.addedCount >= 0) {
      this.photosBroadCast?.emit(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, []);
      this.addedCount = 0;
    } else {
      this.notifyDataLoadingFinished();
    }
    TraceControllerUtils.finishTraceWithTaskId('yearMonthMediaDataUpdateExecutor', requestTime);
  }

  /* instrument ignore next */
  public updateCountThroughMediaItems(requestTime: number, mediaItems: MediaItem[]): void {
    Log.info(TAG, 'updateCountThroughMediaItems');
    this.updateSize(0, mediaItems?.length ?? 0);
  }

  public updateMediaCount(requestTime: number, count: number, changeInfo?: PhotoAssetChangeInfos): void {
    TraceControllerUtils.startTraceWithTaskId('updateMediaCount', requestTime);
    Log.info(TAG, `updateMediaCount requestTime: ${requestTime}, count: ${count}, real size: ${this.realSize}`);
    this.lastUpdateTime = requestTime;

    this.getItemCountFinish = true;
    this.addedCount = (this.realSize > 0) ? (count - this.realSize) : 0;
    this.realSize = count;
    this.updateSize(0, count, changeInfo);

    TraceControllerUtils.finishTraceWithTaskId('updateMediaCount', requestTime);
    if (this.isPendingUpdateData) {
      this.isPendingUpdateData = false;
      this.pendingUpdateData?.flush();
    }
  }

  public updateSize(requestTime: number, count: number, changeInfo?: PhotoAssetChangeInfos): void {
    Log.info(TAG, `updateSize, old size: ${this.size}, new size: ${count}, isCountChanged: ${this.isCountChanged}`);
    this.isCountChanged = count !== this.size;
    this.isCountReduced = count < this.size;
    this.mediaCount = count;
    this.notifyQueryMediaData(changeInfo);
    this.size = this.mediaCount;
    this.updateCountPostProcess();
  }

  public dataReuse(newActiveStart: number, startIndex: number, endIndex: number): void {
    let newData: MediaItem[] = new Array<MediaItem>(this.windowSize);
    for (let i = startIndex; i < endIndex; i++) {
      newData[i - newActiveStart] = this.items[i - this.activeStart];
    }
    this.items = newData;
  }

  private updateData(callback: Function): void {
    // when the total count less to activeEnd, the window need to change
    if (this.activeEnd > this.mediaCount) {
      let newActiveStart = Math.max(0, this.activeStart - (this.activeEnd - this.mediaCount));
      let newActiveEnd = newActiveStart + this.windowSize;
      // data reuse
      if (newActiveEnd > this.activeStart) {
        this.dataReuse(newActiveStart, this.activeStart, newActiveEnd);
      }
      this.activeStart = newActiveStart;
      this.activeEnd = newActiveEnd;
      this.queryWorker.updateGetDataTaskCoverage(this.activeStart, this.activeEnd);
      Log.info(TAG, `updateSlidingWindow, newActiveStart: ${this.activeStart} , newActiveEnd: ${this.activeEnd}`);
    }
    if (this.mediaCount === 0 || this.isEditSaveReload || this.isCountChanged || this.isRefresh) {
      this.onDataReloaded();
    } else {
      callback();
    }
    this.hasNewChange = false;
  }

  updateCountPostProcess(callback = (): void => {
  }): void {
    Log.info(TAG, 'updateCountPostProcess');
    if (this.hasNewChange) {
      this.updateData(callback);
    } else {
      callback();
    }
    this.emitCountUpdateCallbacks();
  }

  public emitCountUpdateCallbacks(): void {
    this.broadCast?.emit(Constants.ON_LOADING_FINISHED, [this.mediaCount]);
    this.notifySizeLoadingFinished(this.mediaCount);
    if (!this.isYearMonthViewShown && !this.isDayViewShown) {
      Log.info(TAG, 'onDataReloaded when emitCountUpdateCallbacks');
      this.onDataReloaded();
    }
  }

  public initData(): void {
    if (this.isInitData) {
      return;
    }
    this.isInitData = true;
    this.getItemCountFinish = false;
    Log.info(TAG, `initData, ${this.getItemCountFinish}`);
    const condition: PendingCondition = {
      shouldPending: () => {
        return this.isPendingUpdateData;
      }
    };
    this.pendingUpdateData = new PendingTask(condition);
    this.firstPatchDataRequestTime = Date.now();
    this.lastUpdateTime = this.firstPatchDataRequestTime;
    TraceControllerUtils.startTrace(this.initDataTraceName);
    this.dataRequestTime = Date.now();
    this.firstFetchDataRequestTime = this.dataRequestTime;
    ReportToBigDataUtil.report(BigDataConstants.DATA_LOAD_START);
    this.loadData();
  }

  public loadData(): void {
    Log.info(TAG, 'Refresh data in YearMonthSource');
    this.queryWorker.addDataCountTask(this.getPhotoDataCountCallbackFunc, this.albumUri, this.filterMediaType);
  }

  // 根据锚点获取新的中心点
  /* instrument ignore next */
  public getNewWindowCenter(dataIndex: number): number {
    if (dataIndex < this.windowSize / YearMonthMediaDataSource.MATH_HALF) {
      return this.windowSize / YearMonthMediaDataSource.MATH_HALF;
    }
    if (dataIndex > this.mediaCount - this.windowSize / YearMonthMediaDataSource.MATH_HALF) {
      return this.mediaCount - this.windowSize / YearMonthMediaDataSource.MATH_HALF;
    }
    return dataIndex;
  }

  // 根据中心点获取新的缓存开始点
  /* instrument ignore next */
  public getNewStart(newWindowCenter: number): number {
    return newWindowCenter - this.windowSize / YearMonthMediaDataSource.MATH_HALF;
  }

  // 根据中心点获取新的缓存结束点
  /* instrument ignore next */
  public getNewEnd(newWindowCenter: number): number {
    return newWindowCenter + this.windowSize / YearMonthMediaDataSource.MATH_HALF;
  }

  // 滑窗改变时获取新缓存数据-复用/查询
  /* instrument ignore next */
  public updateMedia(taskStart: number, taskEnd: number,
    oldItems: MediaItem[], oldActiveStart: number, oldActiveEnd: number):

    void {
    Log.info(TAG, `updateMedia start ${taskStart}-${taskEnd}-${oldActiveStart}-${oldActiveEnd}`);
    if (taskStart < 0 || taskEnd > this.mediaCount) {
      Log.error(TAG, `updateMedia is Error! taskStart: ${taskStart}, taskEnd: ${taskEnd}`);
      return;
    }
    let requestStart = 0;
    let requestCount = 0;
    if (taskStart > oldActiveEnd || taskEnd < oldActiveStart) {
      // 当前请求的数据在老数据两边没有重复部分或只有最左边最右边一个数重复 需要重新查询
      requestStart = taskStart;
      requestCount = taskEnd - taskStart + 1;
      Log.info(TAG, 'updateMedia with no dateReuse');
    } else if (taskEnd > oldActiveStart && taskStart < oldActiveStart) {
      // 当前请求的数据在老数据左边有重复部分 需要查询剩下部分 复用部分老数据
      requestStart = taskStart;
      requestCount = oldActiveStart - taskStart;
      this.dataReuseNew(oldActiveStart, taskEnd, oldItems, oldActiveStart);
      Log.info(TAG, `updateMedia with left dateReuse[${oldActiveStart}-${taskEnd}]`);
    } else if (taskEnd >= oldActiveEnd && taskStart < oldActiveEnd) {
      // 当前请求的数据在老数据右边有重复部分 需要查询剩下部分 复用部分老数据
      requestStart = oldActiveEnd + 1;
      requestCount = taskEnd - oldActiveEnd;
      this.dataReuseNew(taskStart, oldActiveEnd, oldItems, oldActiveStart);
      Log.info(TAG, `updateMedia with right dateReuse[${taskStart}-${oldActiveEnd}]`);
    } else if (taskEnd <= oldActiveEnd && taskStart >= oldActiveStart) {
      // 当前请求的数据在老数据中间 不需要查询 直接复用老数据
      this.dataReuseNew(taskStart, taskEnd, oldItems, oldActiveStart);
      Log.info(TAG, 'updateMedia with all dateReuse');
    } else {
      Log.error(TAG, `updateMedia has an error: ${taskStart}-${taskEnd}-${oldActiveStart}-${oldActiveEnd}`);
    }
    if (requestCount) {
      // 需要查询时调用任务队列查询
      Log.info(TAG, `updateMedia request[${requestStart}-${requestStart + requestCount}]`);
      this.queryWorker.addDataTask(requestStart, requestCount,
        this.getPhotoDataCallbackFunc, this.albumUri, this.filterMediaType, FetchType.DATE_INFO);
    }
  }

  // 新复用数据
  /* instrument ignore next */
  public dataReuseNew(start: number, end: number, oldItems: MediaItem[], oldStart: number): void {
    for (let i = start; i <= end; i++) {
      this.items[i - this.activeStart] = oldItems[i - oldStart];
    }
  }

  // 滑窗调整时触发
  /* instrument ignore next */
  public updateSlidingWindow(dataIndex: number): void {
    // dataIndex：锚点在媒体库中index
    if (!Number.isFinite(dataIndex) || dataIndex === Constants.INVALID) {
      return;
    }
    let windowCenter = Math.round((this.activeStart + this.activeEnd) / YearMonthMediaDataSource.MATH_HALF);
    // 初始化后滑动不超过当前滑窗的一半不需要更新
    if (this.activeStart === 0 && dataIndex < windowCenter) {
      return;
    }
    // 滑动未超出步长不需要更新
    if (Math.abs(dataIndex - windowCenter) < Constants.YEAR_MONTH_STEP) {
      return;
    }
    // 结尾左滑动不超过当前滑窗的一半不需要更新
    if (this.activeEnd >= this.mediaCount && dataIndex > windowCenter) {
      return;
    }
    this.updateSlidingWindowInner(dataIndex);
  }

  /* instrument ignore next */
  public updateSlidingWindowInner(dataIndex: number): void {
    let newCenter = this.getNewWindowCenter(dataIndex);
    let newStart = this.getNewStart(newCenter);
    let newEnd = this.getNewEnd(newCenter);
    let oldItems = this.items;
    this.items = new Array<MediaItem>(this.windowSize);
    let oldActiveStart = this.activeStart;
    let oldActiveEnd = this.activeEnd - 1;
    this.activeStart = newStart;
    this.activeEnd = newEnd;
    this.queryWorker.updateGetDataTaskCoverage(this.activeStart, this.activeEnd);
    let limit = YearMonthMediaDataSource.ONE_SCREEN_COUNT;
    this.updateMedia(newCenter - limit, newCenter + limit, oldItems, oldActiveStart, oldActiveEnd);
    this.updateMedia(newCenter - YearMonthMediaDataSource.MATH_DOUBLE * limit,
      newCenter - limit - 1, oldItems, oldActiveStart, oldActiveEnd);
    this.updateMedia(newCenter + limit + 1, newCenter +
      YearMonthMediaDataSource.MATH_DOUBLE * limit, oldItems, oldActiveStart, oldActiveEnd);
    this.updateMedia(newCenter - this.windowSize / YearMonthMediaDataSource.MATH_DOUBLE,
      newCenter - YearMonthMediaDataSource.MATH_DOUBLE * limit - 1, oldItems, oldActiveStart, oldActiveEnd);
    this.updateMedia(newCenter + YearMonthMediaDataSource.MATH_DOUBLE * limit + 1,
      newCenter + this.windowSize / YearMonthMediaDataSource.MATH_DOUBLE - 1, oldItems, oldActiveStart, oldActiveEnd);
    Log.info(TAG, `updateSlidingWindowInfo activeStart: ${this.activeStart}, activeEnd: ${this.activeEnd}, ` +
      `dataIndex:${dataIndex}, newCenter: ${newCenter}, ` +
      `oldCenter: ${Math.round((oldActiveStart + oldActiveEnd + 1) / YearMonthMediaDataSource.MATH_HALF)}`);
  }

  /* instrument ignore next */
  public clearData(fromIndex: number, endIndex: number): void {
    this.triggerDataRefresh(fromIndex, endIndex);
  }

  /* instrument ignore next */
  public triggerDataRefresh(fromIndex: number, endIndex: number): void {
    Log.info(TAG, `triggerDataRefresh ${fromIndex}, ${endIndex}`);
    if (this.isCountChanged || this.isRefresh) {
      let needEmitPhotosBC: boolean =
        (this.isCountReduced || this.isRefresh || this.addedCount > 0) && !this.isEditSaveReload;
      if (this.photosBroadCast && needEmitPhotosBC) {
        this.photosBroadCast.emit(BroadCastConstants.ON_DATA_RELOADED, [this.addedCount]);
        this.addedCount = 0;
      } else if (this.broadCast) {
        this.broadCast.emit(BroadCastConstants.ON_DATA_RELOADED, []);
      } else {
        this.onDataReloaded();
      }
      this.isCountChanged = false;
      this.isCountReduced = false;
      this.isRefresh = false;
      return;
    }
    this.onDataReloaded();
  }

  public enableGetData(flag: boolean): void {
    this.enableGetDataFlag = flag;
  }

  /* instrument ignore next */
  public getMediaItemSafely(index: number): MediaItem {
    let mediaItem: MediaItem = this.items[index];
    if (!mediaItem) {
      Log.error(TAG, `invalid data, index:${index}, active Start:${this.activeStart}, End:${this.activeEnd}`);
      mediaItem = new MediaItem();
    }
    return mediaItem;
  }

  /* instrument ignore next */
  public setAlbumUri(uri: string): void {
    Log.info(TAG, `setAlbumUri: ${uri}`);
    this.albumUri = uri;
  }

  /* instrument ignore next */
  public getAlbumUri(): string {
    return this.albumUri;
  }

  /* instrument ignore next */
  public setFilterMediaType(filterMediaType: string): void {
    Log.info(TAG, `set filterMediaType: ${filterMediaType}`);
    this.filterMediaType = filterMediaType;
  }

  public setBroadCast(broadCastParam: BroadCast): void {
    this.broadCast = broadCastParam;
    this.broadCast.on(BroadCastConstants.PHOTO_BROWSER_ACTIVE, this.browserActiveCallback);
  }

  public setPhotoBroadCast(broadCastParam: BroadCast): void {
    this.photosBroadCast = broadCastParam;
  }

  public releasePhotoBroadCast(): void {
    this.photosBroadCast = undefined;
  }

  /* instrument ignore next */
  public onPhotoBrowserActive(isActive: boolean, transition: string): void {
    Log.debug(TAG, `onPhotoBrowserActive ${isActive}, ${transition}`);
    if (transition === Constants.PHOTO_TRANSITION_ALBUM || transition === Constants.PHOTO_TRANSITION_CAMERA) {
      if (isActive) {
        this.onActive();
      } else {
        this.onInActive();
      }
    } else if (transition === Constants.PHOTO_TRANSITION_EDIT) {
      this.isEditSaveReload = isActive;
      if (isActive) {
        this.onActive();
      }
    }
  }

  /* instrument ignore next */
  public getIndexByMediaItem(item: MediaItem): number {
    for (let index = 0; index < this.items.length; index++) {
      if (item.uri === this.items[index].uri) {
        this.items[index] = item;
        return index;
      }
    }
    return Constants.NOT_FOUND;
  }

  public onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    Log.debug(TAG, `onMediaLibDataNfy nfyInfo: ${JSON.stringify(nfyInfo)}`);
    if (nfyInfo.type === MediaObserverNfyType.ADD_PHOTO_INTO_ALBUM ||
      nfyInfo.type === MediaObserverNfyType.REMOVE_PHOTO_FROM_ALBUM) {
      // 年月视图页面不监听相册内容变更的事件通知
      return;
    }
    this.switchRefreshOn();
    this.onNotify(nfyInfo);
  }

  /* instrument ignore next */
  public onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    this.switchRefreshOn();
    this.onChange(changeType);
  }

  /* instrument ignore next */
  // 继承MediaChangeDataSource
  public updateNotifyCountStatus(nfyInfo: MediaObserverNfyInfo): void {
    if (nfyInfo.type < MediaObserverNfyType.ALBUM_ADD) {
      this.needRefreshCount = MediaDataProvider.isInfoValidForCountUpdate(nfyInfo);
      Log.debug(TAG, `updateNotifyCountStatus needRefreshCount = ${this.needRefreshCount}`);
    }
  }

  /**
   * 通知查询年月视图元数据
   */
  /* instrument ignore next */
  private notifyQueryMediaData(changeInfo?: PhotoAssetChangeInfos): void {
    // this.yearMonthDataManager.notifyQueryMediaData(this.mediaCount, changeInfo);
  }

  /**
   * 元数据查询结果回调
   */
  /* instrument ignore next */
  private onQueryMediaItemResult(): void {
    this.onDataReloaded();
  }

  /* instrument ignore next */
  public onNotify(nfyInfo: MediaObserverNfyInfo, isForceUpdate?: boolean): void {
    Log.debug(TAG, `yearMonthDataSource onNotify nfyInfo: ${
    JSON.stringify(nfyInfo)}, isForceUpdate: ${isForceUpdate}`);
    this.updateNotifyCountStatus(nfyInfo);
    let timeNow: number = Date.now();
    if (this.lastNfyTimestamp === 0) {
      this.lastNfyTimestamp = timeNow;
    }
    this.nfyPendingCount++;
    if (timeNow - this.lastNfyTimestamp > YearMonthMediaDataSource.YEAR_MONTH_UPDATE_TIMEOUT_MS) {
      if (this.nfyTimer > 0) {
        clearTimeout(this.nfyTimer);
        this.nfyTimer = 0;
      }
      if (this.nfyPendingCount > 0) {
        Log.info(TAG, `onNotifyForYearMonth nfyInfo: count = ${this.nfyPendingCount}`);
        super.onNotify(nfyInfo);
        this.nfyPendingCount = 0;
      }
      this.lastNfyTimestamp = timeNow;

      return;
    }

    if (this.nfyTimer === 0) {
      this.nfyTimer = setTimeout((): void => {
        if (this.nfyPendingCount > 0) {
          Log.info(TAG, `onNotifyForYearMonth in timeout nfyInfo: count = ${this.nfyPendingCount}`);
          super.onNotify(nfyInfo, true);
          this.nfyPendingCount = 0;
          this.nfyTimer = 0;
        }
      }, YearMonthMediaDataSource.YEAR_MONTH_UPDATE_TIMEOUT_MS);
    }
  }

  /* instrument ignore next */
  public onChange(mediaType: string, isForceUpdate?: boolean): void {
    if (mediaType === 'image' || mediaType === 'video' || mediaType === 'album') {
      Log.debug(TAG, `local onChange ${mediaType}`);
      super.onChange(mediaType, isForceUpdate);
    }
  }

  /* instrument ignore next */
  public switchRefreshOn(): void {
    this.isRefresh = true;
  }

  public isEmpty(): boolean {
    return this.totalCount() === 0 && (this.items.length <= 0 || this.items[0] === undefined);
  }

  public isInvalidData(requestUri: string, dataUri: string): boolean {
    return !(requestUri === dataUri);
  }

  /* instrument ignore next */
  public onYearMonthViewStateChange(isYearMonthViewShown: boolean): void {
    this.isYearMonthViewShown = isYearMonthViewShown;
  }

  public onDayViewStateChange(isDayViewShown: boolean): void {
    this.isDayViewShown = isDayViewShown;
  }

  /**
   * 设置当前视图类型
   *
   * @param currentViewType 当前视图类型
   */
  public setCurrentViewType(currentViewType: number): void {
    this.currentViewType = currentViewType;
  }

  /**
   * 设置当前年视图X轴偏移量
   *
   * @param dataOffset X轴偏移量
   * @param maxPhotoNum 最大数量
   */
  public setYearDataOffset(dataOffset: number, maxPhotoNum: number): void {
    this.yearDataOffset = dataOffset;
    this.maxPhotosNum = maxPhotoNum;
  }

  /**
   * 设置当前月视图X轴偏移量
   *
   * @param dataOffset X轴偏移量
   * @param maxPhotoNum 最大数量
   */
  public setMonthDataOffset(dataOffset: number, maxPhotoNum: number): void {
    this.monthDataOffset = dataOffset;
    this.maxPhotosNum = maxPhotoNum;
  }

  /**
   * 重置偏移量
   */
  public resetDataOffset(): void {
    this.yearDataOffset = 0;
    this.monthDataOffset = 0;
  }

  /**
   * 获取开始偏移坐标
   *
   * @param start 原始开始坐标
   * @returns 偏移坐标
   */
  public getModifiedStart(start: number): number {
    let modifiedStart: number = start;
    let startOffset: number = 0;
    if (start < this.maxPhotosNum) {
      this.resetDataOffset();
    } else {
      startOffset = this.currentViewType === 0 ? this.yearDataOffset : this.monthDataOffset;
      modifiedStart = start - startOffset;
      if (modifiedStart < 0) {
        modifiedStart = start;
        this.resetDataOffset();
      }
    }
    return modifiedStart;
  }
}