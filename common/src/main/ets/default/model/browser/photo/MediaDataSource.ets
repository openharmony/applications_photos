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
import lazy { AbsDataSource } from '../AbsDataSource';
import lazy { GetItemsCallback } from './GetItemsCallback';
import lazy { GetMediaCountCallback } from './GetMediaCountCallback';
import lazy { Log } from '../../../utils/Log';
import lazy { BroadCastConstants } from '../../common/BroadCastConstants';
import type { BroadCast } from '../../../utils/BroadCast';
import lazy { BroadCastManager } from '../../common/BroadCastManager';
import lazy { Constants } from '../../common/Constants';
import lazy { PendingTask } from './PendingTask';
import type { PendingCondition } from './PendingCondition';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy { BrowserDataFactory } from '../../../interface/BrowserDataFactory';
import type { BrowserDataInterface, QueryParam } from '../../../interface/BrowserDataInterface';
import type { FilterConditions } from '../../../model/FilterConditions';
import lazy { ViewData } from './ViewData';
import lazy { GetItemIndexCallback } from './GetItemIndexCallback';
import lazy { GetItemCallback } from './GetItemCallback';
import type { PhotoDataImpl } from './PhotoDataImpl';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../../utils/ReportToBigDataUtil';
import lazy fileUri from '@ohos.file.fileuri';
import lazy { CommonUtil } from '../../../utils/CommonUtil';
import type { MediaObserverNfyInfo } from '../dataObserver/MediaObserverCallback';
import lazy { MediaObserverNfyType } from '../dataObserver/MediaObserverCallback';
import lazy { PhotoAssetChangeInfos, MediaChangeListener } from '../dataObserver/MediaObserver';
import lazy { SimpleGridMediaItem } from './SimpleGridMediaItem';
import lazy util from '@ohos.util';
import lazy { IndexConvertor } from '../../IndexConvertor';
import lazy { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy { DeviceInfo } from '../../../utils/DeviceInfo';
import lazy { PhotoConfig } from '../../../config/PhotoConfig';
import lazy { AsyncCallback } from '../../common/AsyncCallback';
import lazy { GroupDataProvider, TimelineData } from './TimelineData';
import lazy { LoadingInfo, LoadingState, LoadingTask, NO_NEED } from '../../DataSource';
import lazy { DataWindow } from '../../../utils/DataSourceWindowUtil';
import lazy { AlbumInfo } from '../album/AlbumInfo';
import lazy { GridViewMode } from '../../../view/grid/GridView';
import lazy { PickerEditorPhotoContext } from '../../../utils/PickerEditorPhotoContext';

const TAG: string = 'common_MediaDataSource';

export class MediaDataSource extends AbsDataSource<MediaItem> implements IndexConvertor, GroupDataProvider,
  MediaChangeListener {
  // Number of first pictures loaded during initialization
  private static readonly INIT_FIRST_PATCH_LOAD_COUNT = DeviceInfo.isPhoneUx() ? 72 : 100;
  public initDataTraceName: string = 'PhotoGridPageInitData';
  // Album list, all photos, etc. may involve album aggregation display, so multiple albums are required
  public photoDataImpl: BrowserDataInterface | PhotoDataImpl;
  // Number of elements in layout
  public size: number = 0;
  public realSize: number = 0;
  public getItemCountFinish: boolean = false;
  // Number of media in the dataset
  public mediaCount: number = 0;
  // 根据分组数据算出，用于推导dataIndexes，groupViewIndexes，groupIndexes，dataToGroupIndexes数据
  protected offsetMediaCount: number[] = [];
  // 全量count查询标志位
  public albumInfo: AlbumInfo | undefined = undefined;
  public needFullQueryCount: boolean = true;
  // Is the quantity changed
  public isCountChanged: boolean = false;
  // Is the quantity changed
  public isCountReduced: boolean = false;
  public addedCount: number = 0;
  // Save the amount of data of a window size
  public items: MediaItem[] = [];
  /* instrument ignore next */
  public itemChangeListener?: () => void;
  public viewDataCache: Map<string, ViewData> = new Map<string, ViewData>();
  public groupGlobalOffsets: number[] = [];
  public groupGlobalIndex: number[] = [];
  public unifyNotify: boolean = false;

  // 释放单张图片的ViewData
  public releaseViewDataCache(item: MediaItem | undefined): void {
    if (!item?.uniqueId) {
      return;
    }
    this.viewDataCache.delete(item.uniqueId);
  }
  // Save the amount of data of a window size
  public cameraItems: MediaItem[] = [];
  public broadCast: BroadCast | undefined;
  public photosBroadCast?: BroadCast;
  // The BroadCast of the application process. Event registration and destruction should be paired
  public appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  // Whether to delay updating data
  public isPendingUpdateData: boolean = true;
  // During initialization, the task to data updates before the delay when count returns
  /* instrument ignore next */
  public pendingUpdateData?: PendingTask = new PendingTask({
    shouldPending: () => false,
  });
  // Request time of the first batch of data
  public firstPatchDataRequestTime: number = 0;
  // 删除ID，通知统一使用uri，准确查询整机相册中的资源，图库再通过uri识别系统相册。
  public albumUri: string = '';
  public filterMediaType: string = '';
  public filterConditions?: FilterConditions;
  public isRefresh: boolean = false;
  public isEditSaveReload: boolean = false;
  public validEndIndex: number = 0;
  protected browserActiveCallback: Function = this.onPhotoBrowserActive.bind(this);
  public enableGetDataFlag: boolean = true;
  /**
   * 是否使能查询数据
   */
  private enableQueryDataFlag: boolean = true;
  /**
   * 是否使能滑窗
   */
  protected enableSlidingWindowFlag: boolean = true;
  /**
   * 是否使能滑窗
   */
  protected enableDaySlidingWindowFlag: boolean = true;
  /**
   * 是否使能滑窗
   */
  protected enableGroupSlidingWindowFlag: boolean = true;
  public deleteIndex: number = -1;
  public isSourceAlbum: boolean = false;
  public isShootOrClassAlbum: boolean | undefined = false;
  public yearMonthDayViewIndex: number = 0;
  public isInInitData: boolean = false;
  // Simple media items for data source.
  protected simpleMediaItems?: util.LRUCache<number, SimpleGridMediaItem>;
  /**
   * 是否优化媒体库变更通知
   */
  public shouldOptNotify: boolean = true;
  /**
   * 是否仅读取缩略图已生成的图片、视频资源
   */
  public needThumbnailReady: boolean = false;
  /**
   * 通知类型
   */
  protected nfyInfoType: number = MediaObserverNfyType.NONE;
  protected previewItems: MediaItem[] = [];
  public invalidUris: string[] = [];
  private isDataSourceMode: boolean = false;
  protected queryParam?: QueryParam = {};
  protected hasWrapper: boolean = false;

  public constructor(windowSize: number, photoDataImpl?: PhotoDataImpl, isDataSourceMode?: boolean,
    queryParam?: QueryParam) {
    super();
    this.tag = TAG;
    this.photoDataImpl =
      photoDataImpl ?? BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO) as PhotoDataImpl;
    this.windowSize = windowSize;
    this.activeEnd = windowSize;
    if (DeviceInfo.isPcOrTablet()) {
      this.stepSize = Constants.STEP_PAD_AND_PC;
    } else if (PhotoConfig.isLibrary()) {
      this.stepSize = Constants.SLIDING_STEP_LIBRARY;
    } else {
      this.stepSize = Constants.SLIDING_STEP_DEFAULT;
    }
    this.items = new Array<MediaItem>(windowSize);
    this.appBroadCast.on(BroadCastConstants.PHOTO_BROWSER_ACTIVE, this.browserActiveCallback);
    if (isDataSourceMode) {
      this.isDataSourceMode = isDataSourceMode;
    }
    this.queryParam = queryParam;
  }

  /* instrument ignore next */
  public getGroupData(): TimelineData[] {
    return [];
  }

  public getDataSourceMode(): boolean {
    return this.isDataSourceMode;
  }

  public setWrapperMode(hasWrapper: boolean): void {
    this.hasWrapper = hasWrapper;
  }

  // 广播资源释放
  public releaseBroadCast(): void {
    Log.debug(TAG, 'release all appBroadCast');
    this.appBroadCast.off(BroadCastConstants.PHOTO_BROWSER_ACTIVE, this.browserActiveCallback);
    this.broadCast?.off(BroadCastConstants.PHOTO_BROWSER_ACTIVE, this.browserActiveCallback);
  }

  /* instrument ignore next */
  public getDataByDisplayName(displayName: string): MediaItem | undefined {
    let res: MediaItem | undefined;
    if (!this.items || !displayName) {
      return res;
    }
    let targetName: string = displayName.replace('_enhanced', '');
    for (let i = this.activeStart; i < this.activeEnd; i++) {
      let mediaItem: MediaItem = this.items[i] ?? new MediaItem();
      if (mediaItem.displayName === targetName) {
        return mediaItem;
      }
    }
    return res;
  }

  // 设置删除图片index
  public setDeleteIndex(index: number): void {
    this.deleteIndex = index;
  }

  public setYearMonthDayViewIndex(yearMonthDayViewIndex: number): void {
    if (!this.enableGetDataFlag) {
      return;
    }
    this.yearMonthDayViewIndex = yearMonthDayViewIndex;
  }

  public getDeleteIndex(): number {
    return this.deleteIndex;
  }

  public totalCount(): number {
    if (this.lastTotalCount !== this.size) {
      Log.info(this.tag, `mediaDatasource totalCount: ${this.size}`);
      this.lastTotalCount = this.size;
    }
    if (this.invalidUris.length > 0) {
      Log.info(this.tag, `get totalCount ${this.size} -> ${this.size - this.invalidUris.length}`);
    }
    return this.size - this.invalidUris.length;
  }

  /* instrument ignore next */
  public realTotalCount(): number {
    Log.info(TAG, `realTotalCount: ${this.size}, ${this.getItemCountFinish}`);
    if (this.getItemCountFinish) {
      return this.size - this.invalidUris.length;
    }
    return -1;
  }

  public getPreviewArray(): MediaItem[] {
    return this.previewItems;
  }

  public clearPreviewArray(): void {
    this.previewItems = [];
  }

  /* instrument ignore next */
  protected clearInvalidUris(mediaItems: (MediaItem | undefined)[]): void {
    const oldLength: number = this.invalidUris.length;
    const uriList: (string | undefined)[] = [];

    for (let i = 0; i < mediaItems.length; i++) {
      if (!mediaItems[i] || !mediaItems[i]?.uri) {
        continue;
      }
      uriList.push(mediaItems[i]?.uri);
    }

    let i: number = 0;
    while (i < this.invalidUris.length) {
      const currUri: string = this.invalidUris[i];
      if (!uriList.includes(currUri)) {
        Log.info(TAG, `delete from invalidUris: ${this.invalidUris[i]}`);
        this.invalidUris.splice(i, 1);
      } else {
        i++;
      }
    }
    Log.info(TAG, `clear filter list oldLength: ${oldLength} -> newLength: ${this.invalidUris.length}`);
  }

  public getData(index: number): ViewData | undefined {
    if (!this.enableGetDataFlag) {
      return undefined;
    }
    if (DeviceInfo.isGRLFoldScreen()) {
      let isRecoverGridView = LocalStorage.getShared()?.get<boolean>(Constants.APP_KEY_GRL_RECOVER_GRID_VIEW);
      let startIndex = LocalStorage.getShared()?.get<number>(Constants.APP_KEY_GRL_GRID_SCROLL_INDEX_TMP);
      if (isRecoverGridView && startIndex && startIndex > Constants.DEFAULT_SLIDING_WIN_SIZE && index <
      Constants.GRL_RECOVER_NUM) {
        return;
      }
    }
    const wrappedData = this.getWrappedData(index);
    let isThumbnailInvalid: boolean = !wrappedData?.mediaItem?.thumbnail;
    if (wrappedData && isThumbnailInvalid) {
      wrappedData.simpleMediaItem = this.getSimpleMediaItem(index);
      /* instrument ignore if */
      if (wrappedData.simpleMediaItem) {
        wrappedData.mediaItem = new MediaItem();
        wrappedData.mediaItem.thumbnail = wrappedData.simpleMediaItem.getThumbnailUri();
        wrappedData.mediaItem.uri = wrappedData.simpleMediaItem.uri;
        if (this.albumInfo?.isTrashAlbum) {
          wrappedData.mediaItem.mediaType = wrappedData.simpleMediaItem.mediaType;
          wrappedData.mediaItem.duration = wrappedData.simpleMediaItem.getDuration();
        }
        isThumbnailInvalid = !wrappedData.mediaItem.thumbnail;
      }
    }
    if (index !== 0 && isThumbnailInvalid) {
      Log.e(this.tag, `getData index: ${index} thumbnail is null`);
    }
    if (this.enableSlidingWindowFlag) {
      this.updateSlidingWindow(index);
    }
    Log.info(TAG, `getdata index ${index}, data: ${wrappedData?.mediaItem?.uri}, isinvalid:${isThumbnailInvalid}`);
    return wrappedData;
  }

  // get raw MediaItem data
  public getRawData(dataIndex: number): MediaItem | undefined {
    if (dataIndex < this.activeStart || dataIndex >= this.activeEnd) {
      Log.warn(this.tag, `dataIndex is invalid:${JSON.stringify({
        dataIndex,
        activeStart: this.activeStart,
        activeEnd: this.activeEnd,
      })}`);
      return undefined;
    }
    return this.items[dataIndex - this.activeStart];
  }

  // 根据burstKey获取对应的连拍图片(倒序)
  public async getMediaItemsByBurstKey(burstKey: string, isTrash?: boolean): Promise<MediaItem[]> {
    if (!burstKey) {
      return [];
    }
    if (this.photoDataImpl.getDataByBurstKey) {
      return this.photoDataImpl.getDataByBurstKey(burstKey, Constants.INVALID, Constants.INVALID, true, isTrash);
    }
    return [];
  }

  /* instrument ignore next */
  public getFirstRawData(): MediaItem {
    return this.items?.[0];
  }

  // get DataIndex with item
  public getDataIndex(item: MediaItem | undefined): number {
    if (!item || !item.uniqueId) {
      return Constants.NOT_FOUND;
    }
    for (let i = 0; i < this.items.length; i++) {
      if (this.items[i]?.uniqueId === item.uniqueId) {
        return i + this.activeStart;
      }
    }
    return Constants.NOT_FOUND;
  }

  // get mediaItem by uri
  public getItemByUri(uri: string): MediaItem {
    for (let i = 0; i < this.items.length; i++) {
      if (this.items[i]?.uri === uri) {
        return this.items[i];
      }
    }
    return new MediaItem();
  }

  /* instrument ignore next */
  public getItemByUriOrThumbnail(coverUri: string): MediaItem | undefined {
    for (let i = 0; i < this.items.length; i++) {
      if (this.items[i]?.uri === coverUri || coverUri.includes(this.items[i].uri)) {
        return this.items[i];
      }
    }
    return undefined;
  }

  public getItemByPath(path: string): MediaItem {
    for (let i = 0; i < this.items.length; i++) {
      if (this.items[i]?.path === path) {
        return this.items[i];
      }
    }
    return new MediaItem();
  }

  public getDataIndexByUri(uri: string): number {
    for (let i = 0; i < this.items.length; i++) {
      if (this.items[i]?.uri === uri) {
        return i + this.activeStart;
      }
    }
    return Constants.NOT_FOUND;
  }

  public getDataIndexByDisplayName(displayName: string): number {
    for (let i = 0; i < this.items.length; i++) {
      if (this.items[i]?.displayName === displayName) {
        return i + this.activeStart;
      }
    }
    return Constants.NOT_FOUND;
  }

  /* instrument ignore next */
  getGroupCountBeforeItem(item: MediaItem | undefined): number {
    return 0;
  }

  // Search for the index of first valid item in 500 items
  /* instrument ignore next */
  public getValidStartIndex(): number {
    for (let i = 0; i < this.items.length; i++) {
      if (this.items[i]) {
        return i + this.activeStart;
      }
    }
    return Constants.NOT_FOUND;
  }

  // Search for the index of last valid item in 500 items
  /* instrument ignore next */
  public getValidEndIndex(): number {
    return this.validEndIndex;
  }

  // 是否基于ready机制读取uri
  public setThumbnailReady(needThumbnailReady: boolean): void {
  }

  public setPreloadStartIndex(index: number) {
  }

  /**
   * 同步结果：在当前结果集中能查到则返回，查不到返回undefined
   * @param uri
   * @param itemNotifyCallback
   * @returns
   */
  /* instrument ignore next */
  public getMediaItemByUri(uri: string, itemNotifyCallback?: Function): MediaItem | undefined {
    Log.info(TAG, `getMediaItemByUri, ${uri}`);
    if (this.items.length > 0) {
      for (let item of this.items) {
        if (item?.uri === uri) {
          itemNotifyCallback?.(item);
          Log.info(TAG, 'uri in items');
          return item;
        }
      }
    }
    if (itemNotifyCallback) {
      // 若当前数据不存在于当前列表的处理
      let itemIndexCallback: GetItemCallback = new GetItemCallback(this, itemNotifyCallback);
      this.photoDataImpl.getMediaItemByUri(itemIndexCallback, uri);
    }
    return undefined;
  }

  /**
   * 已有数据中找不到目标时需要使用itemNotifyCallback获取结果，必须处理直接调用返回为undefinde的情形
   * @param uri
   * @param itemNotifyCallback
   * @returns
   */
  public getMediaItemByUriFromAll(uri: string, itemNotifyCallback: Function): MediaItem | undefined {
    Log.info(TAG, `getMediaItemByUriFromAll uri ${uri}`);
    if (this.items.length <= 0 && this.cameraItems.length <= 0) {
      return undefined;
    }

    for (let item of this.items) {
      if (item?.uri === uri) {
        return item;
      }
    }

    for (let item of this.cameraItems) {
      if (item?.uri === uri) {
        return item;
      }
    }

    // 若当前数据不存在于当前列表的处理
    Log.info(TAG, `getMediaItemByUriFromAll, ${uri}`);
    let itemIndexCallback: GetItemCallback = new GetItemCallback(this, itemNotifyCallback);
    this.photoDataImpl.getMediaItemByUri(itemIndexCallback, uri);

    return undefined;
  }

  // get media size in the dataset
  public getMediaCount(): number {
    return this.mediaCount;
  }

  public resetActiveWindow(): void {
    this.activeStart = 0;
    this.activeEnd = this.windowSize;
    this.items = new Array<MediaItem>(this.windowSize);
  }

  protected getBatchData(callback: AsyncCallback<MediaItem[]>, start: number, count: number,
    needThumbnailReady?: boolean): void {
    /* instrument ignore if */
    if (!callback || start === undefined || start === null || count === undefined || count === null) {
      Log.error(TAG, 'getBatchData, callback or start or count is undefined');
      return;
    }
    let firstParam: QueryParam = {
      albumUri: this.albumUri as string,
      start: start,
      count: count,
      needThumbnailReady: this.queryParam?.needThumbnailReady ?? needThumbnailReady,
      filterMediaType: this.filterMediaType,
      filterConditions: this.queryParam?.filterConditions,
    };
    this.photoDataImpl.getData(callback, firstParam);
  }

  // Initialize the first batch of data
  public initData(): void {
    TraceControllerUtils.startTrace(this.initDataTraceName);
    this.getItemCountFinish = false;
    this.isInInitData = true;
    Log.info(TAG, `initData, ${this.getItemCountFinish}, ${this.isInInitData}`);
    const condition: PendingCondition = {
      shouldPending: () => {
        return this.isPendingUpdateData;
      }
    }
    this.pendingUpdateData = new PendingTask(condition);
    let start = 0;
    let limit = MediaDataSource.INIT_FIRST_PATCH_LOAD_COUNT;
    this.firstPatchDataRequestTime = Date.now();
    this.lastUpdateTime = this.firstPatchDataRequestTime;
    // TODO：Object literal must correspond to some explicitly declared class or interface
    let firstPatchDataCallback: AsyncCallback = {
      callback: (assets: MediaItem[], dataAlbumUri: string): void => {
        Log.info(TAG, `took ${(
          Date.now() - this.firstPatchDataRequestTime)} milliseconds to load first batch: ${assets?.length}`);
        /* instrument ignore if */
        if (this.isInvalidData(this.albumUri, dataAlbumUri)) {
          Log.error(TAG, 'initData isInvalidData: this.albumUri:' + this.albumUri + ` dataAlbumUri:${dataAlbumUri}`);
          return;
        }
        /* instrument ignore if */
        if (assets?.length > 0) {
          this.updateMediaData(this.firstPatchDataRequestTime, start, assets, true);
        }
        ReportToBigDataUtil.report(BigDataConstants.DATA_LOAD_FINISH);
        if (assets?.length < limit) {
          return;
        }
        this.getSecondPatchData(limit);
      }
    };
    Log.info(TAG, `queryparam start: ${start} count: ${limit} needThumbnailReady: ${
    this.needThumbnailReady} filterMediaType: ${this.filterMediaType}`);
    this.getBatchData(firstPatchDataCallback, start, limit, this.needThumbnailReady);
    ReportToBigDataUtil.report(BigDataConstants.DATA_LOAD_START);
    this.loadData();
  }

  public getSecondPatchData(limit: number): void {
    let secondPatchDataCallback: GetItemsCallback = new GetItemsCallback(this, limit);
    this.getBatchData(secondPatchDataCallback, limit, this.windowSize - limit, this.needThumbnailReady);
  }

  private isSupportChangeCountByNotify(): boolean | undefined {
    if (this.albumUri) {
      // 目前仅开放图片、视频、用户自定义相册、来源相册根据Album类通知中count赋值
      return UserFileManagerAccess.isImageAlbumUri(this.albumUri) ||
      UserFileManagerAccess.isVideoAlbumUri(this.albumUri) || this.albumInfo?.isUserCreatedAlbum ||
        this.albumInfo?.isSourceAlbum;
    }
    return false;
  }

  // 全量查询相册count
  private fullQueryAlbumCount(initCountCallback: GetMediaCountCallback): void {
    let data: QueryParam = {
      albumUri: this.albumUri,
      filterMediaType: this.filterMediaType,
      filterConditions: this.queryParam?.filterConditions,
      needThumbnailReady: this.queryParam?.needThumbnailReady ?? this.needThumbnailReady,
    };
    Log.info(TAG, 'loadData will full query count');
    this.photoDataImpl.getDataCount(initCountCallback, data);
  }

  public isUriInCache(uri: string, indexNotifyCallback: Function): boolean {
    for (let i = 0; i < this.items.length; i++) {
      if (this.items[i]?.uri === uri) {
        indexNotifyCallback(i);
        return true;
      }
    }
    return false;
  }


  // Query quantity
  public loadData(): void {
    Log.info(this.tag, `loadData, ${this.getItemCountFinish}`);
    let initCountCallback: GetMediaCountCallback = new GetMediaCountCallback(this);
    this.fullQueryAlbumCount(initCountCallback);
  }

  /* instrument ignore next */
  public getItemIndexByUri(uri: string, indexNotifyCallback: (index: number) => void,
    isFromCard: boolean = false): void {
    Log.info(TAG, `getItemIndexByUri, ${uri}`);
    let itemIndexCallback: GetItemIndexCallback = new GetItemIndexCallback(this, indexNotifyCallback);
    if (this.filterMediaType) {
      this.photoDataImpl.getDataIndexByUri(itemIndexCallback, {
        albumUri: this.albumUri,
        filterMediaType: this.filterMediaType,
      }, uri, isFromCard);
    } else {
      this.photoDataImpl.getDataIndexByUri(itemIndexCallback, { albumUri: this.albumUri }, uri, isFromCard);
    }
  }

  // update media count
  public updateMediaCount(requestTime: number, count: number): void {
    TraceControllerUtils.startTraceWithTaskId('updateMediaCount', requestTime);
    Log.info(TAG, `updateMediaCount requestTime: ${requestTime}, count: ${count}, real size: ${this.realSize}`);
    this.lastUpdateTime = requestTime;
    this.getItemCountFinish = true;
    this.addedCount = (this.realSize > 0) ? (count - this.realSize) : 0;
    this.realSize = count;
    this.updateSize(requestTime, count);
    this.isInInitData = false;
    Log.info(TAG, `updateMediaCount isInInitData: ${this.isInInitData}`);

    TraceControllerUtils.finishTraceWithTaskId('updateMediaCount', requestTime);
    if (this.isPendingUpdateData) {
      this.isPendingUpdateData = false;
      this.pendingUpdateData?.flush();
    }
  }

  /**
   * Update related variables of count
   *
   * @param requestTime
   * @param count
   */
  public updateSize(requestTime: number, count: number): void {
    Log.info(TAG, `updateSize, old size: ${this.size}, new size: ${count}, isCountChanged:${this.isCountChanged}`);
    if (this.firstPatchDataRequestTime !== requestTime) {
      this.isCountChanged = count !== this.size;
      this.isCountReduced = count < this.size;
    }
    this.mediaCount = count;
    this.size = this.mediaCount;
    this.updateCountPostProcess();
  }

  protected excludeInitData(callback = (): void => {
  }): void {
    if (this.mediaCount === 0) {
      callback();
    }
    this.updateSlideWindow();
    Log.info(TAG, `excludeInitData isEditSaveReload: ${
    this.isEditSaveReload}, isCountChanged: ${this.isCountChanged}, isRefresh: ${this.isRefresh}`);
    if (this.mediaCount === 0) {
      this.hasNewChange = false;
      if (!PhotoConfig.isLibrary()) {
        this.onDataReloaded();
      }
      this.invalidUris = [];
    } else if (!this.isInInitData && this.isDirtyData()) {
      // dirty data, need to get data again
      Log.info(TAG, 'dirty data, need to get data again');
      this.queryData(callback);
    } else {
      callback();
      this.hasNewChange = false;
    }
  }

  protected updateSlideWindow(): void {
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
      Log.info(TAG, `updateSlidingWindow, newActiveStart:${this.activeStart} , newActiveEnd:${this.activeEnd}`);
    }
  }

  protected isDirtyData(): boolean {
    return this.isEditSaveReload || this.isCountChanged || this.isRefresh ||
      this.nfyInfoType === MediaObserverNfyType.PHOTO_ADD || this.nfyInfoType === MediaObserverNfyType.PHOTO_REMOVE;
  }

  protected queryData(callback: () => void): void {
    if (!this.enableQueryDataFlag) {
      // 关闭数据查询时，需要恢复标志位
      Log.info(TAG, 'queryData enableQueryDataFlag: false');
      this.hasNewChange = false;
      callback();
      return;
    }
    let getItemsCallback: GetItemsCallback = new GetItemsCallback(this, this.activeStart, callback);
    this.getBatchData(getItemsCallback, this.activeStart, this.windowSize, this.needThumbnailReady);
  }

  /**
   * run after update count，Adjust sliding windows and query items as needed
   */
  updateCountPostProcess(callback = (): void => {
  }): void {
    Log.info(TAG, `updateCountPostProcess hasNewChange: ${this.hasNewChange}`);
    if (this.hasNewChange) {
      this.excludeInitData(callback);
    } else {
      callback();
    }
    this.invalidUris.length === 0 && this.emitCountUpdateCallbacks();
  }

  public emitCountUpdateCallbacks(): void {
    const totalCount: number = Math.max(this.mediaCount - this.invalidUris.length, 0);
    this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')?.(totalCount);
    this.broadCast?.emit(Constants.ON_LOADING_FINISHED, [totalCount]);
    this.notifySizeLoadingFinished(totalCount);
  }

  // Update data in data callback
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

  /**
   * Update count through items
   *
   * @param requestTime
   * @param mediaItems mediaItems
   */
  public updateCountThroughMediaItems(requestTime: number, mediaItems: MediaItem[]): void {
    Log.info(TAG, 'updateCountThroughMediaItems');
    this.updateSize(0, mediaItems?.length ?? 0);
  }

  /**
   * Actual execution function of items update
   *
   * @param requestTime
   * @param start items
   * @param mediaItems mediaItems
   */
  public mediaDataUpdateExecutor(requestTime: number, start: number, mediaItems: MediaItem[]): void {
    TraceControllerUtils.startTraceWithTaskId('mediaDataUpdateExecutor', requestTime);
    Log.info(TAG, `mediaDataUpdateExecutor requestTime: ${
    requestTime}, start: ${start}, this.addedCount: ${this.addedCount}` +
      `, this.isEditSaveReload: ${this.isEditSaveReload}` +
      `, this.lastUpdateTime: ${this.lastUpdateTime}` +
      `, this.lastRequestTime: ${this.lastRequestTime}` +
      `， this.isActive： ${this.isActive}` +
      `, mediaItems?.length: ${mediaItems?.length}`);
    if (this.lastUpdateTime < this.lastRequestTime && this.isActive) {
      this.loadData();
    } else {
      this.hasNewChange = false;
    }

    if (!mediaItems?.length) {
      Log.error(TAG, 'results are empty!');
      TraceControllerUtils.finishTraceWithTaskId('mediaDataUpdateExecutor', requestTime);
      return;
    }

    /* instrument ignore if */
    if (start >= this.activeEnd || start + mediaItems.length <= this.activeStart) {
      Log.warn(TAG, 'results are not in active window');
      TraceControllerUtils.finishTraceWithTaskId('mediaDataUpdateExecutor', requestTime);
      return;
    }

    this.clearInvalidUris(mediaItems);
    let index: number = 0;
    while (index < mediaItems.length) {
      if (this.invalidUris.includes(mediaItems[index].uri)) {
        Log.info(TAG, `remove invalid item ${index}, invalid uri ${mediaItems[index].uri}`);
        mediaItems.splice(index, 1);
      } else {
        index++;
      }
    }

    Log.info(TAG, `mediaDataUpdateExecutor mediaItemsLen: ${
    mediaItems.length}, listenersLen: ${this.listeners.length}`);
    let fromIndex = Math.max(start, this.activeStart);
    let endIndex = Math.min(this.activeEnd, start + mediaItems.length);
    this.validEndIndex = endIndex - 1;
    let previewNum = DeviceInfo.getFirstPatchNum();

    for (let i = fromIndex; i < endIndex; i++) {
      this.items[i - this.activeStart] = mediaItems[i - start];
      if (fromIndex === 0 && i < previewNum) {
        this.previewItems[i] = mediaItems[i - start];
      }
    }

    /* instrument ignore if */
    if (this.itemChangeListener) {
      this.itemChangeListener();
    }
    this.triggerDataRefresh(fromIndex, endIndex);

    if ((this.isEditSaveReload || PickerEditorPhotoContext.getInstance().isPickerWaitingEditExitBroadCast())
      && this.addedCount >= 0) {
      this.photosBroadCast?.emit(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, []);
      this.addedCount = 0;
    } else {
      this.notifyDataLoadingFinished();
    }
    this.invalidUris.length > 0 && this.emitCountUpdateCallbacks();
    TraceControllerUtils.finishTraceWithTaskId('mediaDataUpdateExecutor', requestTime);
  }

  public clearData(fromIndex: number, endIndex: number): void {
    this.triggerDataRefresh(fromIndex, endIndex);
  }

  public triggerDataRefresh(fromIndex: number, endIndex: number): void {
    Log.info(TAG, `triggerDataRefresh isCountChanged: ${
    this.isCountChanged}, isRefresh: ${this.isRefresh}, addedCount: ${this.addedCount}`);
    if (this.isCountChanged || this.isRefresh ||
      this.nfyInfoType === MediaObserverNfyType.PHOTO_ADD || this.nfyInfoType === MediaObserverNfyType.PHOTO_REMOVE) {
      let needEmitPhotosBC: boolean =
        (this.isCountReduced || this.isRefresh || this.addedCount > 0) && !this.isEditSaveReload;
      Log.info(TAG, `triggerDataRefresh photosBroadCast: ${
      this.photosBroadCast}, needEmitPhotosBC: ${needEmitPhotosBC}, broadCast:${this.broadCast}`);
      if (this.photosBroadCast && (needEmitPhotosBC ||
        this.nfyInfoType ===
        MediaObserverNfyType.PHOTO_ADD || this.nfyInfoType === MediaObserverNfyType.PHOTO_REMOVE)) {
        Log.info(TAG, `triggerDataRefresh and photosBroadCast wrapper: ${this.hasWrapper}`);
        this.photosBroadCast.emit(BroadCastConstants.ON_DATA_RELOADED, [this.addedCount]);
        if (this.hasWrapper) {
          this.broadCast?.emit(BroadCastConstants.ON_DATA_RELOADED_WRAPPED, []);
        }
        this.addedCount = 0;
      } else if (this.broadCast) {
        Log.info(TAG, 'triggerDataRefresh and broadCast');
        this.broadCast.emit(BroadCastConstants.ON_DATA_RELOADED, []);
        if (this.hasWrapper) {
          this.broadCast?.emit(BroadCastConstants.ON_DATA_RELOADED_WRAPPED, []);
        }
      } else {
        Log.info(TAG, 'triggerDataRefresh onDataReloaded');
        this.onDataReloaded();
      }
      this.isCountChanged = false;
      this.isCountReduced = false;
      this.isRefresh = false;
      return;
    }
    if (this.hasWrapper) {
      this.broadCast?.emit(BroadCastConstants.ON_DATA_RELOADED_WRAPPED, [fromIndex, endIndex]);
    }
    for (let i = fromIndex; i < endIndex; i++) {
      this.onDataChanged(this.dataToLayout(i));
    }
    /* instrument ignore if */
    if (this.nfyInfoType === MediaObserverNfyType.PHOTO_UPDATE) {
      Log.info(TAG, 'trigger photo update data reload');
      this.photosBroadCast?.emit(BroadCastConstants.ON_DATA_RELOADED, [0]);
    }
  }

  public enableGetData(flag: boolean): void {
    this.enableGetDataFlag = flag;
  }

  /**
   * 设置是否使能查询数据
   *
   * @param flag true表示使能
   */
  public enableQueryData(flag: boolean): void {
    this.enableQueryDataFlag = flag;
  }

  /**
   * 设置是否使能滑窗
   *
   * @param flag true表示使能
   */
  public enableSlidingWindow(flag: boolean): void {
    this.enableSlidingWindowFlag = flag;
  }

  /**
   * 设置四宫格是否使能滑窗
   *
   * @param flag true表示使能
   */
  public enableDaySlidingWindow(flag: boolean): void {
    this.enableDaySlidingWindowFlag = flag;
  }

  /**
   * 设置三宫格是否使能滑窗
   *
   * @param flag true表示使能
   */
  public enableGroupSlidingWindow(flag: boolean): void {
    this.enableGroupSlidingWindowFlag = flag;
  }

  // Update sliding window
  public updateSlidingWindow(dataIndex: number): void {
    if (!Number.isFinite(dataIndex) || dataIndex === Constants.INVALID || dataIndex === null) {
      Log.error(TAG, `updateSlidingWindow failed, invalid dataIndex:${dataIndex}`);
      return;
    }
    let windowCenter = Math.round((this.activeStart + this.activeEnd) / 2);
    if (Math.abs(dataIndex - windowCenter) < this.stepSize) {
      return;
    }
    /* instrument ignore if */
    if (dataIndex < windowCenter && this.activeStart === 0) {
      return;
    }
    /* instrument ignore if */
    if (dataIndex > windowCenter && this.activeEnd >= this.mediaCount) {
      return;
    }

    TraceControllerUtils.startTrace('updateSlidingWindow');
    let newActiveStart = this.getWindowActiveStart(dataIndex, windowCenter, Math.abs(this.mediaCount - this.activeEnd));
    let newActiveEnd = newActiveStart + this.windowSize;
    let requestStart = newActiveStart;
    let requestCount = this.windowSize;

    /* instrument ignore if */
    if (newActiveEnd < this.activeStart || newActiveStart >= this.activeEnd) {
      let limit = MediaDataSource.INIT_FIRST_PATCH_LOAD_COUNT;
      let start = Math.max(0, (newActiveStart + newActiveEnd) / 2 - limit / 2);
      this.firstPatchDataRequestTime = Date.now();
      this.lastUpdateTime = this.firstPatchDataRequestTime;
      // TODO:Object literal must correspond to some explicitly declared class or interface
      let firstPatchDataCallback: AsyncCallback = {
        callback: (assets: MediaItem[], dataAlbumUri: string): void => {
          Log.info(TAG, `took ${(
            Date.now() - this.firstPatchDataRequestTime)} milliseconds to load first batch: ${(assets?.length)}`);
          if (this.isInvalidData(this.albumUri, dataAlbumUri)) {
            Log.error(TAG, 'updateSlidingWindow isInvalidData: this.albumUri:' +
            this.albumUri + ` dataAlbumUri:${dataAlbumUri}`);
            return;
          }
          if (assets?.length > 0) {
            this.updateMediaData(this.firstPatchDataRequestTime, start, assets);
          }
          if (assets?.length < limit) {
            return;
          }
          let secondPatchDataCallback: GetItemsCallback = new GetItemsCallback(this, newActiveStart);
          this.getBatchData(secondPatchDataCallback, newActiveStart, this.windowSize, this.needThumbnailReady);
        }
      };
      this.getBatchData(firstPatchDataCallback, start, limit, this.needThumbnailReady);
    }

    /* instrument ignore if */
    if (newActiveEnd < this.activeEnd && newActiveEnd > this.activeStart) {
      requestCount = this.activeStart - newActiveStart;
      this.dataReuse(newActiveStart, this.activeStart, newActiveEnd);
    }
    /* instrument ignore if */
    if (newActiveStart > this.activeStart && newActiveStart < this.activeEnd) {
      requestStart = this.activeEnd;
      requestCount = newActiveEnd - this.activeEnd;
      this.dataReuse(newActiveStart, newActiveStart, this.activeEnd);
    }
    /* instrument ignore if */
    if (newActiveStart >= this.activeEnd || newActiveEnd <= this.activeStart) {
      this.items = new Array<MediaItem>(this.windowSize);
    }
    Log.info(TAG,
      `updateSlidingWindow dataIndex=${dataIndex}, activeStart=${this.activeStart}, activeEnd=${this.activeEnd}, ` +
        `newActiveStart=${newActiveStart}, newActiveEnd=${newActiveEnd}, requestStart=${requestStart}, ` +
        `requestCount=${requestCount}`);
    this.activeStart = newActiveStart;
    this.activeEnd = newActiveEnd;

    let callback: GetItemsCallback = new GetItemsCallback(this, requestStart);
    this.getBatchData(callback, requestStart, requestCount, this.needThumbnailReady);
    TraceControllerUtils.finishTrace('updateSlidingWindow');
  }

  public getMediaItemSafely(index: number): MediaItem {
    let mediaItem: MediaItem = this.items[index];
    if (!mediaItem) {
      Log.e(TAG, `invalid data, index:${index}, active Start:${this.activeStart}, End:${this.activeEnd}, ` +
        `items.length: ${this.items.length}`);
      mediaItem = new MediaItem();
    }
    return mediaItem;
  }

  public getMediaItemByPosition(position: number): MediaItem | undefined {
    let dataIndexInWindow = position - this.activeStart;
    if (dataIndexInWindow > this.items.length || dataIndexInWindow < 0) {
      Log.error(TAG, 'index out of active window when getMediaItemByPosition, ' +
        `dataIndexInWindow: ${dataIndexInWindow}, items.length: ${this.items.length}`);
      return undefined;
    } else {
      return this.getMediaItemSafely(dataIndexInWindow);
    }
  }

  // Forced refresh interface
  public forceUpdate(): void {
    this.onDataReloaded();
  }

  // Packaging data for the view layer
  public getWrappedData(index: number, isSubParam?: boolean): ViewData | undefined {
    let mediaItemIndex: number = index - this.activeStart;
    /* instrument ignore if */
    if (mediaItemIndex < 0 || mediaItemIndex >= this.items.length) {
      Log.e(TAG, `getWrappedData, invalid index: ${index}, size: ${mediaItemIndex}, start: ${this.activeStart}`);
      return ViewData.getEmptyInstance();
    }
    let result: ViewData;
    const mediaItem: MediaItem = this.getMediaItemSafely(mediaItemIndex);
    const tmp: ViewData | undefined =
      mediaItem.uniqueId === '' ? undefined : this.viewDataCache.get(mediaItem.uniqueId);
    /* instrument ignore if */
    if (tmp) {
      result = tmp;
      result.update(mediaItem);
    } else {
      result = new ViewData(mediaItem);
      /* instrument ignore if */
      if (mediaItem.uniqueId !== '') {
        this.viewDataCache.set(mediaItem.uniqueId, result);
      }
    }
    return result;
  }

  public setAlbumInfo(albumInfo: AlbumInfo | undefined): void {
    this.albumInfo = albumInfo;
  }

  public setAlbumUri(uri: string): void {
    Log.info(TAG, `setAlbumUri: ${uri}`);
    this.albumUri = uri;
  }

  public getAlbumUri(): string {
    return this.albumUri;
  }

  public setFilterMediaType(filterMediaType: string): void {
    Log.info(TAG, `set filterMediaType: ${filterMediaType}`);
    this.filterMediaType = filterMediaType;
  }

  setQueryParam(queryParam: QueryParam): void {
    this.queryParam = queryParam;
  }

  public setBroadCast(broadCastParam: BroadCast): void {
    this.broadCast = broadCastParam;
    this.broadCast.on(BroadCastConstants.PHOTO_BROWSER_ACTIVE, this.browserActiveCallback);
  }

  public setPhotoBroadCast(broadCastParam: BroadCast): void {
    this.photosBroadCast = broadCastParam;
  }

  public setAlbumType(isSource: boolean, isShootOrClass?: boolean): void {
    Log.info(TAG, `setAlbumType isSource: ${isSource} isShootOrClass: ${isShootOrClass}`);
    this.isSourceAlbum = isSource;
    this.isShootOrClassAlbum = isShootOrClass;
  }

  public releasePhotoBroadCast(): void {
    this.photosBroadCast = undefined;
  }

  public onPhotoBrowserActive(isActive: boolean, transition: string): void {
    Log.info(this.tag, `onPhotoBrowserActive ${isActive}, ${transition}`);
    if (transition === Constants.PHOTO_TRANSITION_ALBUM || transition === Constants.PHOTO_TRANSITION_CAMERA) {
      if (isActive) {
        this.onActive();
      } else {
        this.onInActive();
      }
    } else if (transition === Constants.PHOTO_TRANSITION_EDIT) {
      // If the dataSource is not activated, ignore the broadcast.
      if (!this.isActive) {
        return;
      }
      this.isEditSaveReload = isActive;
      if (isActive) {
        if (this.unifyNotify) {
          this.onMediaLibDataChange('image');
        } else {
          this.onChange('image');
        }
        this.onActive();
      }
    }
  }

  /* instrument ignore next */
  public getIndexByMediaItem(item: MediaItem): number {
    for (let index = 0; index < this.items.length; index++) {
      if (item?.uri === this.items[index]?.uri) {
        this.items[index] = item;
        return index;
      }
    }
    return Constants.NOT_FOUND;
  }

  public updateSingleItem(itemIndex: number): void {
    Log.info(TAG, `updateSingleItem item: ${itemIndex}, ${this.items[itemIndex - this.activeStart]?.uri}`);
    if (!this.isActive) {
      return;
    }
    let callback: GetItemsCallback = new GetItemsCallback(this, itemIndex);
    this.getBatchData(callback, itemIndex, 1);
  }

  protected checkAlbumUri(albumUri: string): boolean {
    return this.albumUri === albumUri;
  }

  private handlePhotoAdd(nfyInfo: MediaObserverNfyInfo, isForceUpdate?: boolean): void {
    /* instrument ignore if */
    if (!CommonUtil.isAllPhotoAlbum(this.albumUri)) {
      return;
    }
    super.onNotify(nfyInfo, isForceUpdate);
  }

  private handlePhotoRemove(nfyInfo: MediaObserverNfyInfo, isForceUpdate?: boolean): void {
    let isHiddenAlbum: boolean = UserFileManagerAccess.getInstance().getIsHiddenAlbum();
    let isTrashAlbum: boolean = this.albumUri ===
    UserFileManagerAccess.getInstance().getSystemAlbumUri(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE);
    /* instrument ignore if */
    if (!this.isShootOrClassAlbum && !this.isSourceAlbum &&
      !CommonUtil.isAllPhotoAlbum(this.albumUri) && !isTrashAlbum && !isHiddenAlbum) {
      return;
    }
    let newActiveEnd = this.activeEnd;
    /* instrument ignore next */
    for (let index = 0; index < nfyInfo.uris.length; index++) {
      let count: number = this.activeEnd - this.activeStart;
      for (let itemIndex = 0; itemIndex < count; itemIndex++) {
        if (!this.items[itemIndex]) {
          continue;
        }
        if (this.items[itemIndex].uri === nfyInfo.uris[index]) {
          if ((this.activeStart + itemIndex) < newActiveEnd) {
            newActiveEnd = this.activeStart + itemIndex;
          }
        }
      }
    }
    super.onNotify(nfyInfo, isForceUpdate);
  }

  private handlePhotoUpdate(nfyInfo: MediaObserverNfyInfo, isForceUpdate?: boolean): void {
    if (CommonUtil.isFavoriteAlbum(this.albumUri)) {
      super.onNotify(nfyInfo, isForceUpdate);
      return;
    }
    /* instrument ignore next */
    for (let index = 0; index < nfyInfo.uris.length; index++) {
      let count: number = this.activeEnd - this.activeStart;
      for (let itemIndex = 0; itemIndex < count; itemIndex++) {
        if (!this.items[itemIndex]) {
          continue;
        }
        if (this.items[itemIndex].uri === nfyInfo.uris[index]) {
          this.updateSingleItem(this.activeStart + itemIndex);
          break;
        }
      }
    }
    let keyOfAlbumUri = AppStorage.get<string>(Constants.KEY_OF_ALBUM_URI);
    /* instrument ignore if */
    if (keyOfAlbumUri === this.albumUri) {
      super.onNotify(nfyInfo, isForceUpdate);
    } else {
      // 优化查询场景直接转换到Loading，然后紧接着通知加载完成
      this.setState(LoadingState.LOADING);
      this.notifyDataLoaded({ info: NO_NEED, oldPageData: this.pageData, newPageData: this.pageData, });
    }
  }

  /* instrument ignore next */
  private handlePhotoAddASTC(nfyInfo: MediaObserverNfyInfo, isForceUpdate?: boolean): void {
    super.onNotify(nfyInfo, isForceUpdate);
  }

  private handlePhotoAddToAlbum(nfyInfo: MediaObserverNfyInfo, isForceUpdate?: boolean): void {
    if (!this.checkAlbumUri(nfyInfo.albumUris[0])) {
      return;
    }
    super.onNotify(nfyInfo, isForceUpdate);
  }

  private handlePhotoRemoveFromAlbum(nfyInfo: MediaObserverNfyInfo, isForceUpdate?: boolean): void {
    if (!this.checkAlbumUri(nfyInfo.albumUris[0])) {
      return;
    }
    let newActiveEnd = this.activeEnd;
    /* instrument ignore next */
    for (let index = 0; index < nfyInfo.uris.length; index++) {
      let count: number = this.activeEnd - this.activeStart;
      for (let itemIndex = 0; itemIndex < count; itemIndex++) {
        if (!this.items[itemIndex]) {
          continue;
        }
        if (this.items[itemIndex].uri === nfyInfo.uris[index]) {
          if ((this.activeStart + itemIndex) < newActiveEnd) {
            newActiveEnd = this.activeStart + itemIndex;
          } else {
            newActiveEnd = this.activeStart;
          }
        }
      }
    }
    super.onNotify(nfyInfo, isForceUpdate);
  }

  private isInfoValidForUpdateOtherAlbumCount(nfyInfo: MediaObserverNfyInfo): boolean {
    if (!nfyInfo) {
      return true;
    }
    let nfyInfoType: number = nfyInfo.type;
    // Album类通知，同时保证shared的AlbumAssets和ExtraPhotoAssets>0，并判断changeData_type为3、4
    if (nfyInfoType !== MediaObserverNfyType.ADD_PHOTO_INTO_ALBUM &&
      nfyInfoType !== MediaObserverNfyType.REMOVE_PHOTO_FROM_ALBUM && nfyInfoType !== MediaObserverNfyType.ALBUM_ADD) {
      return true;
    }
    /* instrument ignore if */
    if (!nfyInfo.sharedAlbumAssets?.length) {
      return true;
    }
    return false;
  }

  // 判断notify中是否含有当前相册有效信息
  /* instrument ignore next */
  private hasCurrentAlbumInNotify(nfyInfo: MediaObserverNfyInfo): boolean {
    for (let sharedAlbumAsset of nfyInfo.sharedAlbumAssets) {
      let changeAlbumUri: string =
        UserFileManagerAccess.REGISTER_TYPE_ALL_ALBUMS + `/${sharedAlbumAsset?.albumId}`;
      if (changeAlbumUri === this.albumUri) {
        return true;
      }
    }
    return false;
  }

  public updateNotifyCountStatus(nfyInfo: MediaObserverNfyInfo): void {
    this.needFullQueryCount = this.isInfoValidForUpdateOtherAlbumCount(nfyInfo);
    Log.debug(TAG, `mediadatasource updateNotifyCountStatus this.needFullQueryCount = ${this.needFullQueryCount}`);
  }

  public setNeedFullQueryCount(needFullQueryCount: boolean): void {
    this.needFullQueryCount = needFullQueryCount;
    Log.info(TAG, `this.needFullQueryCount = ${this.needFullQueryCount}`);
  }

  public onAccurateNotify(type: string, nfyInfo: PhotoAssetChangeInfos): void {
  }

  public onNotify(nfyInfo: MediaObserverNfyInfo, isForceUpdate?: boolean): void {
    if (!nfyInfo) {
      return;
    }
    let msg: string[] = [`onNotify nfyInfo type: ${nfyInfo.type}`];
    msg.push(`isForceUpdate: ${isForceUpdate}`);
    msg.push(`shouldOptNotify: ${this.shouldOptNotify}`);
    msg.push(`isLib: ${PhotoConfig.isLibrary()}`);
    Log.info(TAG, `MediaDataSource onNotify, msg:${msg.join(', ')}`);
    // album宫格精细化通知更新限制album类型
    this.nfyInfoType = nfyInfo.type;
    let isGalleryCleanupPage = LocalStorage.getShared()?.get<boolean>(Constants.IS_GALLERY_CLEANUP_PAGE) ?? false;
    /* instrument ignore if */
    if (this.isSupportChangeCountByNotify() && !isGalleryCleanupPage) {
      // 相册宫格忽略Photos通知
      if (nfyInfo.type < MediaObserverNfyType.ALBUM_ADD && nfyInfo.type != MediaObserverNfyType.PHOTO_UPDATE) {
        Log.info(TAG, 'Current notify is Photos, album can not handle it!!');
        return;
      }
      this.updateNotifyCountStatus(nfyInfo);
      let isInvalidNotify: boolean = !this.needFullQueryCount && !this.hasCurrentAlbumInNotify(nfyInfo);
      if (isInvalidNotify) {
        Log.info(TAG, 'The current album is not included in this nfyInfo');
        return;
      }
      // 针对端云场景的Album_ADD通知刷新
      if (nfyInfo.type === MediaObserverNfyType.ALBUM_ADD) {
        Log.info(TAG, 'MediaDataSource handle ALBUM_ADD Notify, loadData will change count');
        super.onNotify(nfyInfo, true);
        return;
      }
    }
    if ((isForceUpdate || !this.shouldOptNotify) && !PhotoConfig.isLibrary()) {
      super.onNotify(nfyInfo, isForceUpdate);
      return;
    }
    switch (nfyInfo.type) {
      case MediaObserverNfyType.PHOTO_ADD: {
        this.handlePhotoAdd(nfyInfo, isForceUpdate);
        break;
      }
      case MediaObserverNfyType.PHOTO_REMOVE: {
        this.handlePhotoRemove(nfyInfo, isForceUpdate);
        break;
      }
      case MediaObserverNfyType.PHOTO_UPDATE: {
        this.handlePhotoUpdate(nfyInfo, isForceUpdate);
        break;
      }
      case MediaObserverNfyType.PHOTO_ADD_ASTC: {
        this.handlePhotoAddASTC(nfyInfo, isForceUpdate);
        break;
      }
      case MediaObserverNfyType.ADD_PHOTO_INTO_ALBUM: {
        this.handlePhotoAddToAlbum(nfyInfo, isForceUpdate);
        break;
      }
      case MediaObserverNfyType.REMOVE_PHOTO_FROM_ALBUM: {
        this.handlePhotoRemoveFromAlbum(nfyInfo, isForceUpdate);
        break;
      }
      case MediaObserverNfyType.NONE: {
        if (this.isSourceAlbum || this.isShootOrClassAlbum) {
          this.handlePhotoRemove(nfyInfo, isForceUpdate);
        }
        // 优化查询场景直接转换到Loading，然后紧接着通知加载完成
        this.setState(LoadingState.LOADING);
        this.notifyDataLoaded({ info: NO_NEED, oldPageData: this.pageData, newPageData: this.pageData, });
        break;
      }
      default: {
        // 优化查询场景直接转换到Loading，然后紧接着通知加载完成
        this.setState(LoadingState.LOADING);
        this.notifyDataLoaded({ info: NO_NEED, oldPageData: this.pageData, newPageData: this.pageData, });
      }
    }
  }

  public onChange(mediaType: string, isForceUpdate?: boolean): void {
    if (mediaType === 'image' || mediaType === 'video' || mediaType === 'album') {
      Log.info(TAG, `local onChange ${mediaType}`);
      super.onChange(mediaType, isForceUpdate);
    }
  }

  public switchRefreshOn(): void {
    this.isRefresh = true;
  }

  public getCategory(): Resource {
    return $r('app.string.common_place_holder', '');
  }

  protected getWindowActiveStart(dataIndex: number, windowCenter: number, lastForwardStepSize: number): number {
    let isForward = dataIndex > windowCenter;
    // The end of the window does not exceed the total amount of data when the window moves forward.
    if (isForward) {
      let forwardStep = dataIndex - windowCenter;
      forwardStep = forwardStep % this.stepSize === 0 ?
        forwardStep : Math.ceil(forwardStep / this.stepSize) * this.stepSize;
      let forwardStepSize = Math.min(forwardStep, lastForwardStepSize);
      Log.info(TAG, `forwardStep=${forwardStep}, stepSize=${forwardStepSize}, activeStart=${this.activeStart}`);
      return this.activeStart + forwardStepSize;
    }
    let backwardStep = windowCenter - dataIndex;
    backwardStep = backwardStep % this.stepSize === 0 ?
      backwardStep : Math.ceil(backwardStep / this.stepSize) * this.stepSize;
    Log.info(TAG, `backward step ${backwardStep}, activeStart=${this.activeStart}`);
    return Math.max(0, this.activeStart - backwardStep);
  }

  /**
   * data Reuse
   *
   * @param newActiveStart
   * @param startIndex
   * @param endIndex
   */
  public dataReuse(newActiveStart: number, startIndex: number, endIndex: number): void {
    let newData: MediaItem[] = new Array<MediaItem>(this.windowSize);
    for (let i = startIndex; i < endIndex; i++) {
      newData[i - newActiveStart] = this.items[i - this.activeStart];
    }
    this.items = newData;
  }

  public isEmpty(): boolean {
    return this.totalCount() === 0;
  }

  public isInvalidData(requestUri?: string, dataUri?: string): boolean {
    if (!requestUri && !dataUri) {
      return false;
    }
    return !(requestUri === dataUri);
  }

  /* instrument ignore next */
  public getUriByDataIndex(index: number): string | undefined {
    if (this.items[index] !== undefined) {
      return this.items[index].uri;
    }
    return undefined;
  }

  /**
   * Get query param of data source.
   *
   * @param start Query start.
   * @param count Query count.
   * @returns Query param.
   */
  public getQueryParam(start: number, count: number): QueryParam {
    return {
      albumUri: this.albumUri,
      start: start,
      count: count,
      filterMediaType: this.filterMediaType,
    };
  }

  /**
   * Init simple media items.
   *
   * @param capacity Capacity to init.
   */
  public createSimpleMediaItems(capacity: number): void {
    if (capacity >= 0) {
      this.simpleMediaItems = new util.LRUCache<number, SimpleGridMediaItem>(capacity);
    }
  }

  /**
   * Clear simple media items.
   */
  public clearSimpleMediaItems(): void {
    if (this.simpleMediaItems && this.simpleMediaItems.length !== 0) {
      this.simpleMediaItems.clear();
    }
  }

  /**
   * Get simple media item by index.
   *
   * @param index Index.
   * @returns Simple media item.
   */
  public getSimpleMediaItem(index: number): SimpleGridMediaItem | undefined {
    if (index < 0) {
      return undefined;
    }
    return this.simpleMediaItems?.get(index);
  }

  /**
   * Get simple media index by uri.
   *
   * @param uri Uri.
   * @returns Simple media index.
   */
  public getSimpleMediaItemIndexByUri(uri: string): number {
    if (!this.simpleMediaItems || !uri) {
      return Constants.NOT_FOUND;
    }
    for (let value of this.simpleMediaItems) {
      if (value[1].uri === uri) {
        return value[0];
      }
    }
    return Constants.NOT_FOUND;
  }

  /**
   * Record simple media item corresponding to index.
   *
   * @param index Index.
   * @param item Simple media item to record.
   */
  /* instrument ignore next */
  public recordSimpleMediaItem(index: number, item: SimpleGridMediaItem, useNewPhoto?: boolean): void {
    if (index < 0 || item === null) {
      return;
    }
    this.simpleMediaItems?.put(index, item);
  }

  public layoutToData(index: number): number {
    return index;
  }

  public dataToLayout(index: number): number {
    return index;
  }

  public getGroupIndexByDataIndex(dataIndex: number): number {
    return 0;
  }

  public findGroupViewIndexes(index: number): number {
    return -1;
  }

  // 当前照片所在分组的索引
  public timeGroupIndexes(index: number): number {
    return -1;
  }

  public indexesToGroup(index: number): TimelineData | undefined {
    return undefined;
  }

  public computeGroupGlobalOffset(imageGridHeight: number, timeTitleHeight: number, gridColCnt: number): void {
  }

  public computeMaxGridOffset(imageGridHeight: number, timeTitleHeight: number, gridColCnt: number): number {
    return -1;
  }

  public computeStartIndex(offset: number, imageGridHeight: number, timeTitleHeight: number,
    gridColCnt: number): number {
    return -1;
  }

  public computeStartIndexWithMassage(offset: number, imageGridHeight: number, timeTitleHeight: number,
    gridColCnt: number): number {
    return -1;
  }

  protected buildLoadingTask(info: LoadingInfo): LoadingTask<MediaItem> | undefined {
    return undefined;
  }

  public onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
  }

  public onMediaLibDataChange(changeType: string): void {
  }

  public updateGroupDaySlidingWindow(dataIndex: number): void {
  }

  public async changeWindow(dataWindow: DataWindow): Promise<void> {
    if (this.isActive) {
      if (dataWindow.activeStart >= this.activeStart && dataWindow.activeEnd <= this.activeEnd) {
        Log.info(this.tag, 'slice window');
        let oldActiveStart: number = this.activeStart;
        this.windowSize = dataWindow.windowSize;
        this.stepSize = dataWindow.stepSize;
        this.activeStart = dataWindow.activeStart;
        this.activeEnd = dataWindow.activeEnd;
        this.items = this.items.slice(this.activeStart - oldActiveStart, this.activeEnd - oldActiveStart);
      } else if (dataWindow.activeStart <= this.activeStart && dataWindow.activeEnd >= this.activeEnd) {
        Log.info(this.tag, 'expand window');
        let oldActiveStart = this.activeStart;
        this.windowSize = dataWindow.windowSize;
        this.stepSize = dataWindow.stepSize;
        this.activeStart = dataWindow.activeStart;
        this.activeEnd = dataWindow.activeEnd;

        let tempItems: MediaItem[] = new Array<MediaItem>(this.windowSize);
        let headEmptyCount = oldActiveStart - this.activeStart;
        for (let i = 0; i < this.items.length; i++) {
          tempItems[i + headEmptyCount] = this.items[i];
        }
        this.items = tempItems;
        if (this.unifyNotify) {
          this.onMediaLibDataChange('image');
        } else {
          this.switchRefreshOn();
          this.onChange('image');
        }
      } else {
        if (this.unifyNotify) {
          this.onMediaLibDataChange('image');
        } else {
          this.switchRefreshOn();
          this.onChange('image');
        }
      }
    }
  }

  public setViewMode(mode: GridViewMode): void {
  }
}