/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { MediaItem } from './MediaItem';
import { ViewType } from './ViewType';
import { AbsDataSource } from '../AbsDataSource';
import { GetItemsCallback } from './GetItemsCallback';
import { GetMediaCountCallback } from './GetMediaCountCallback';
import { Log } from '../../../utils/Log';
import { BroadCastConstants } from '../../common/BroadCastConstants';
import { BroadCast } from '../../../utils/BroadCast';
import { BroadCastManager } from '../../common/BroadCastManager';
import { Constants } from '../../common/Constants';
import { PendingTask } from './PendingTask';
import type { PendingCondition } from './PendingCondition';
import { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import { AlbumDefine } from '../AlbumDefine';
import { BrowserDataFactory } from '../../../interface/BrowserDataFactory';
import type { BrowserDataInterface } from '../../../interface/BrowserDataInterface';
import type { QueryParam } from '../BrowserDataImpl';
import type { ViewData } from './ViewData';
import { GetItemIndexCallback } from './GetItemIndexCallback';
import { FileAsset } from '../../../access/UserFileManagerAccess';
import type { PhotoDataImpl } from './PhotoDataImpl';
import { GetItemCallback } from './GetItemCallback';

const TAG: string = 'common_MediaDataSource';

export class MediaDataSource extends AbsDataSource {
  // Number of first pictures loaded during initialization
  private static INIT_FIRST_PATCH_LOAD_COUNT = 50;
  initDataTraceName: string = 'PhotoGridPageInitData';

  // Album list, all photos, etc. may involve album aggregation display, so multiple albums are required
  photoDataImpl: BrowserDataInterface;

  // Number of elements in layout
  size: number = 0;
  realSize: number = 0;
  getItemCountFinish: boolean = false;

  // Number of media in the dataset
  mediaCount: number = 0;

  // Is the quantity changed
  isCountChanged: boolean = false;

  // Is the quantity changed
  isCountReduced: boolean = false;

  addedCount: number = Constants.NUMBER_0;

  // Save the amount of data of a window size
  items: MediaItem[] = [];

  // window Size
  windowSize: number = 0;

  // start point
  activeStart: number = 0;

  // end point
  activeEnd: number = 0;

  // layoutIndex to dataIndex
  dataIndexes: number[] = [];

  // dataIndex to layoutIndex
  layoutIndexes: number[] = [];
  broadCast: BroadCast;
  photosBroadCast: BroadCast;

  // The BroadCast of the application process. Event registration and destruction should be paired
  appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  // Whether to delay updating data
  isPendingUpdateData: boolean = true;

  // During initialization, the task to data updates before the delay when count returns
  pendingUpdateData: PendingTask;

  // Request time of the first batch of data
  firstPatchDataRequestTime: number;

  // 删除ID，通知统一使用uri，准确查询整机相册中的资源，图库再通过uri识别系统相册。
  albumUri: string = undefined;
  filterMediaType: string = undefined;
  isRefresh: boolean = false;
  isEditSaveReload: boolean = false;
  validEndIndex: number;
  private browserActiveCallback: Function = this.onPhotoBrowserActive.bind(this);
  private enableGetDataFlag: boolean = true;

  constructor(windowSize: number, photoDataImpl?: PhotoDataImpl) {
    super();
    this.photoDataImpl = photoDataImpl ?? BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO) as PhotoDataImpl;
    this.windowSize = windowSize;
    this.activeEnd = windowSize;
    this.items = new Array(windowSize);
    this.appBroadCast.on(BroadCastConstants.PHOTO_BROWSER_ACTIVE, this.browserActiveCallback);
  }

  releaseBroadCast(): void {
    Log.debug(TAG, 'release all appBroadCast');
    this.appBroadCast.off(BroadCastConstants.PHOTO_BROWSER_ACTIVE, this.browserActiveCallback);
  }

  totalCount(): number {
    if (this.lastTotalCount != this.size) {
      Log.info(TAG, `totalCount: ${this.size}`);
      this.lastTotalCount = this.size;
    }
    return this.size;
  }

  isEmpty(): boolean {
    return this.totalCount() === 0 && (this.items.length <= 0 || this.items[0] === undefined);
  }

  realTotalCount(): number {
    Log.info(TAG, `realTotalCount: ${this.size}, ${this.getItemCountFinish}`);
    if (this.getItemCountFinish == true) {
      return this.size;
    }
    return -1;
  }

  getData(index: number): ViewData {
    if (!this.enableGetDataFlag) {
      return undefined;
    }
    this.updateSlidingWindow(this.dataIndexes[index]);
    let result = this.getWrappedData(index);
    if (result == null) {
      return undefined;
    }
    return result;
  }

  // get raw MediaItem data
  getRawData(dataIndex: number): MediaItem {
    if (dataIndex < this.activeStart || dataIndex >= this.activeEnd) {
      Log.warn(TAG, `dataIndex is invalid: ${dataIndex}, ${this.activeStart} ~ ${this.activeEnd}`);
      return undefined;
    }
    return this.items[dataIndex - this.activeStart];
  }

  getFirstRawData(): MediaItem {
    if (this.items.length <= 0) {
      return undefined;
    }
    return this.items[0];
  }

  // get DataIndex with item
  getDataIndex(item: MediaItem): number {
    for (let i = 0; i < this.items.length; i++) {
      if (this.items[i] != undefined && this.items[i].uri === item.uri) {
        return i + this.activeStart;
      }
    }
    return Constants.NOT_FOUND;
  }

  getItemByUri(uri: string): MediaItem {
    for (let i = 0; i < this.items.length; i++) {
      if (this.items[i] != undefined && this.items[i].uri == uri) {
        return this.items[i];
      }
    }
    return null;
  }

  getDataIndexByUri(uri: string): number {
    for (let i = 0; i < this.items.length; i++) {
      if (this.items[i] != undefined && this.items[i].uri === uri) {
        return i + this.activeStart;
      }
    }
    return Constants.NOT_FOUND;
  }
  // Search for the index of first valid item in 500 items
  getValidStartIndex(): number {
    for (let i = 0; i < this.items.length; i++) {
      if (this.items[i]) {
        return i + this.activeStart;
      }
    }
    return Constants.NOT_FOUND;
  }
  // Search for the index of last valid item in 500 items
  getValidEndIndex(): number {
    return this.validEndIndex;
  }

  getMediaItemByUri(uri: string): MediaItem {
    if (this.items.length <= 0) {
      return undefined;
    }
    for (let item of this.items) {
      if (item != undefined && item.uri === uri) {
        return item;
      }
    }
    return undefined;
  }

  getMediaItemByUriFromAll(uri: string, itemNotifyCallback: Function): MediaItem {
    Log.info(TAG, `getMediaItemByUriFromAll uri ${uri}`);
    if (this.items.length <= 0) {
      return undefined;
    }

    for (let item of this.items) {
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

  getMediaCount(): number {
    return this.mediaCount;
  }

  resetActiveWindow(): void {
    this.activeStart = 0;
    this.activeEnd = this.windowSize;
    this.items = new Array<MediaItem>(this.windowSize);
  }

  // Initialize the first batch of data
  initData(): void {
    TraceControllerUtils.startTrace(this.initDataTraceName);
    this.getItemCountFinish = false;
    Log.info(TAG, `initData, ${this.getItemCountFinish}`);
    this.pendingUpdateData = new PendingTask(<PendingCondition> {
      shouldPending: () => {
        return this.isPendingUpdateData;
      }
    });
    let start = 0;
    let limit = MediaDataSource.INIT_FIRST_PATCH_LOAD_COUNT;
    this.firstPatchDataRequestTime = Date.now();
    this.lastUpdateTime = this.firstPatchDataRequestTime;
    let firstPatchDataCallback = {
      callback: (assets: MediaItem[], dataAlbumUri?: string): void => {
        Log.info(TAG, `took  ${(Date.now() - this.firstPatchDataRequestTime)}\
          milliseconds to load first batch: ${(assets == null ? 0 : assets.length)}`);
        if (this.isInvalidData(this.albumUri, dataAlbumUri)) {
          Log.error(TAG, 'initData callback isInvalidData:this.albumUri:' + this.albumUri + ' dataAlbumUri:' + dataAlbumUri);
          return;
        }
        if (assets?.length > 0) {
          this.updateMediaData(this.firstPatchDataRequestTime, start, assets);
        }
        if (assets?.length < limit) {
          return;
        }
        let secondPatchDataCallback: GetItemsCallback = new GetItemsCallback(this, limit);
        let secondParam: QueryParam = {
          albumUri: this.albumUri,
          start: limit,
          count: this.windowSize - limit,
        };
        if (this.filterMediaType != undefined) {
          secondParam.filterMediaType = this.filterMediaType;
        }
        this.photoDataImpl.getData(secondPatchDataCallback, secondParam);
      }
    };
    let firstParam: QueryParam = {
      albumUri: this.albumUri,
      start: start,
      count: limit,
    };
    if (this.filterMediaType != undefined) {
      firstParam.filterMediaType = this.filterMediaType;
    }
    Log.info(TAG, `queryparam ${JSON.stringify(firstParam)}`);
    this.photoDataImpl.getData(firstPatchDataCallback, firstParam);
    this.loadData();
  }

  // Query quantity
  loadData(): void {
    Log.info(TAG, `loadData, ${this.getItemCountFinish}`);
    let initCountCallback: GetMediaCountCallback = new GetMediaCountCallback(this);
    if (this.filterMediaType != undefined) {
      this.photoDataImpl.getDataCount(initCountCallback, {
        albumUri: this.albumUri,
        filterMediaType: this.filterMediaType
      });
    } else {
      this.photoDataImpl.getDataCount(initCountCallback, { albumUri: this.albumUri });
    }
  }

  getItemIndexByUri(uri: string, indexNotifyCallback: Function): void {
    Log.info(TAG, `getItemIndexByUri, ${uri}`);
    let itemIndexCallback: GetItemIndexCallback = new GetItemIndexCallback(this, indexNotifyCallback);
    if (this.filterMediaType) {
      this.photoDataImpl.getDataIndexByUri(itemIndexCallback, {
        albumUri: this.albumUri,
        filterMediaType: this.filterMediaType
      }, uri);
    } else {
      this.photoDataImpl.getDataIndexByUri(itemIndexCallback, { albumUri: this.albumUri }, uri);
    }
  }

  // update media count
  updateMediaCount(requestTime: number, count: number): void {
    TraceControllerUtils.startTraceWithTaskId('updateMediaCount', requestTime);
    Log.info(TAG, `updateMediaCount requestTime: ${requestTime}, count: ${count}, real size: ${this.realSize}`);
    this.lastUpdateTime = requestTime;

    this.getItemCountFinish = true;
    this.addedCount = (this.realSize > Constants.NUMBER_0) ? (count - this.realSize) : Constants.NUMBER_0;
    this.realSize = count;
    this.updateSize(requestTime, count);

    TraceControllerUtils.finishTraceWithTaskId('updateMediaCount', requestTime);
    if (this.isPendingUpdateData) {
      this.isPendingUpdateData = false;
      this.pendingUpdateData.flush();
    }
  }

  /**
   * Update related variables of count
   *
   * @param requestTime
   * @param count
   */
  updateSize(requestTime: number, count: number): void {
    Log.info(TAG, `updateSize, old size: ${this.size}, new size: ${count}`)
    this.isCountChanged = count != this.size;
    this.isCountReduced = count < this.size;
    this.mediaCount = count;
    this.size = this.mediaCount;
    this.dataIndexes = [];
    this.layoutIndexes = [];
    for (let i = 0; i < this.size; i++) {
      this.dataIndexes.push(i);
      this.layoutIndexes.push(i);
    }

    this.updateCountPostProcess();
  }

  /**
   * run after update count，Adjust sliding windows and query items as needed
   */
  updateCountPostProcess(): void {
    Log.info(TAG, 'updateCountPostProcess');
    // Exclude initData
    if (this.hasNewChange) {
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
        Log.info(TAG, `updateSlidingWindow, newActiveStart:
                ${this.activeStart} , newActiveEnd:${this.activeEnd}`);
      }

      if (this.mediaCount == 0) {
        this.hasNewChange = false;
        this.onDataReloaded();
      } else if (this.isEditSaveReload || this.isCountChanged || this.isRefresh) {
        // dirty data, need to get data again
        Log.info(TAG, 'dirty data, need to get data again');
        let callback: GetItemsCallback = new GetItemsCallback(this, this.activeStart);
        let param: QueryParam = {
          albumUri: this.albumUri,
          start: this.activeStart,
          count: this.windowSize,
        };
        if (this.filterMediaType != undefined) {
          param.filterMediaType = this.filterMediaType;
        }
        this.photoDataImpl.getData(callback, param);
      } else {
        this.hasNewChange = false;
      }
    }
    this.emitCountUpdateCallbacks();
  }

  emitCountUpdateCallbacks(): void {
    this.mCallbacks['updateCount'] && this.mCallbacks['updateCount'](this.mediaCount);
    this.broadCast && this.broadCast.emit(Constants.ON_LOADING_FINISHED, [this.mediaCount]);
    this.notifySizeLoadingFinished(this.mediaCount);
  }

  // Update data in data callback
  updateMediaData(requestTime: number, start: number, mediaItems: MediaItem[]): void {
    if (requestTime == this.firstPatchDataRequestTime && this.isPendingUpdateData && this.size == 0) {
      Log.info(TAG, 'the callback of mediaItems is earlier than that of count.');
      this.updateCountThroughMediaItems(requestTime, mediaItems);
      this.mediaDataUpdateExecutor(requestTime, start, mediaItems);
      TraceControllerUtils.finishTrace(this.initDataTraceName);
    } else if (this.isPendingUpdateData) {
      Log.info(TAG, 'isPendingUpdateData execute start');
      this.pendingUpdateData.execute(() => {
        this.mediaDataUpdateExecutor(requestTime, start, mediaItems);
        TraceControllerUtils.finishTrace(this.initDataTraceName);
      });
    } else {
      this.mediaDataUpdateExecutor(requestTime, start, mediaItems);
      TraceControllerUtils.finishTrace(this.initDataTraceName);
    }
  }

  /**
   * Update count through items
   *
   * @param requestTime
   * @param mediaItems mediaItems
   */
  updateCountThroughMediaItems(requestTime: number, mediaItems: MediaItem[]): void {
    Log.info(TAG, 'updateCountThroughMediaItems');
    this.updateSize(0, mediaItems == null ? 0 : mediaItems.length);
  }

  /**
   * Actual execution function of items update
   *
   * @param requestTime
   * @param start items
   * @param mediaItems mediaItems
   */
  mediaDataUpdateExecutor(requestTime: number, start: number, mediaItems: MediaItem[]): void {
    TraceControllerUtils.startTraceWithTaskId('updateMediaData', requestTime);
    Log.info(TAG, `updateMediaData requestTime: ${requestTime}, start: ${start}, this.addedCount: ${this.addedCount}, this.isEditSaveReload: ${this.isEditSaveReload}`);
    if (this.lastUpdateTime < this.lastChangeTime && this.isActive) {
      Log.info(TAG, 'request data expired, request again!');
      this.loadData();
    } else {
      this.hasNewChange = false;
    }

    if (mediaItems == undefined || mediaItems.length == 0) {
      Log.error(TAG, 'results are empty!');
      return;
    }

    if (start >= this.activeEnd || start + mediaItems.length <= this.activeStart) {
      Log.info(TAG, 'results are not in active window');
      return;
    }

    Log.info(TAG, `updateMediaData mediaItems.length: ${mediaItems.length}`);
    let fromIndex = Math.max(start, this.activeStart);
    let endIndex = Math.min(this.activeEnd, start + mediaItems.length);
    this.validEndIndex = endIndex - 1;
    Log.info(TAG, `updateMediaData listeners size ${this.listeners.length}`)

    for (let i = fromIndex; i < endIndex; i++) {
      this.items[i - this.activeStart] = mediaItems[i - start];
      Log.debug(TAG, `updateMediaData ${this.layoutIndexes[i]}, ${mediaItems[i - start].uri}, ${mediaItems[i - start].getTitle()}`);
    }

    if (this.isCountChanged || this.isRefresh) {
      if (this.photosBroadCast && (this.isCountReduced || this.isRefresh || (this.addedCount > Constants.NUMBER_0)) && !this.isEditSaveReload) {
        this.photosBroadCast.emit(BroadCastConstants.ON_DATA_RELOADED, [this.addedCount]);
        this.addedCount = Constants.NUMBER_0;
      } else if (this.broadCast) {
        this.broadCast.emit(BroadCastConstants.ON_DATA_RELOADED, []);
      } else {
        this.onDataReloaded();
      }

      this.isCountChanged = false;
      this.isCountReduced = false;
      this.isRefresh = false;
    } else {
      for (let i = fromIndex; i < endIndex; i++) {
        this.onDataChanged(this.layoutIndexes[i]);
      }
    }

    if (this.isEditSaveReload) {
      if (this.addedCount >= 0) {
        this.photosBroadCast && this.photosBroadCast.emit(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, []);
        this.addedCount = Constants.NUMBER_0;
      }
    } else {
      this.notifyDataLoadingFinished();
    }
    TraceControllerUtils.finishTraceWithTaskId('updateMediaData', requestTime);
  }

  enableGetData(flag: boolean): void {
    this.enableGetDataFlag = flag;
  }

  // Update sliding window
  public updateSlidingWindow(dataIndex: number): void {
    if (dataIndex == Constants.INVALID || dataIndex == undefined) {
      return;
    }
    let windowCenter = Math.round((this.activeStart + this.activeEnd) / 2);
    if (Math.abs(dataIndex - windowCenter) < Constants.STEP) {
      return;
    }
    if (dataIndex < windowCenter && this.activeStart == 0) {
      return;
    }
    if (dataIndex > windowCenter && this.activeEnd >= this.mediaCount) {
      return;
    }
    let newActiveStart = this.getWindowActiveStart(dataIndex, windowCenter);
    let newActiveEnd = newActiveStart + this.windowSize;
    let requestStart = newActiveStart;
    let requestCount = this.windowSize;
    Log.info(TAG, `dataIndex: ${dataIndex}, windowCenter: ${windowCenter}, newActiveStart=${newActiveStart}`
    + `, newActiveEnd=${newActiveEnd}, requestStart=${requestStart}, requestCount=${requestCount}`);

    if (newActiveEnd < this.activeStart || newActiveStart > this.activeEnd) {
      let limit = MediaDataSource.INIT_FIRST_PATCH_LOAD_COUNT;
      let start = Math.max(0, (newActiveStart + newActiveEnd) / 2 - limit / 2);
      this.firstPatchDataRequestTime = Date.now();
      this.lastUpdateTime = this.firstPatchDataRequestTime;
      let firstPatchDataCallback = {
        callback: (assets: MediaItem[], dataAlbumUri?: string): void => {
          Log.info(TAG, `took  ${(Date.now() - this.firstPatchDataRequestTime)}\
                     milliseconds to load first batch: ${(assets == null ? 0 : assets.length)}`);
          if (this.isInvalidData(this.albumUri, dataAlbumUri)) {
            Log.error(TAG, 'updateSlidingWindow callback isInvalidData:this.albumUri:' + this.getAlbumUri() + ' dataAlbumUri:' + dataAlbumUri);
            return;
          }
          if (assets?.length > 0) {
            this.updateMediaData(this.firstPatchDataRequestTime, start, assets);
          }
          if (assets?.length < limit) {
            return;
          }
          let secondPatchDataCallback: GetItemsCallback = new GetItemsCallback(this, newActiveStart);
          let secondParam: QueryParam = {
            albumUri: this.albumUri,
            start: newActiveStart,
            count: this.windowSize
          };
          if (this.filterMediaType != undefined) {
            secondParam.filterMediaType = this.filterMediaType;
          }
          this.photoDataImpl.getData(secondPatchDataCallback, secondParam);
        }
      };
      let firstParam: QueryParam = {
        albumUri: this.albumUri,
        start: start,
        count: limit
      };
      if (this.filterMediaType != undefined) {
        firstParam.filterMediaType = this.filterMediaType;
      }
      this.photoDataImpl.getData(firstPatchDataCallback, firstParam);
    }

    if (newActiveEnd < this.activeEnd && newActiveEnd > this.activeStart) {
      requestCount = this.activeStart - newActiveStart;
      this.dataReuse(newActiveStart, this.activeStart, newActiveEnd);
    }
    if (newActiveStart > this.activeStart && newActiveStart < this.activeEnd) {
      requestStart = this.activeEnd;
      requestCount = newActiveEnd - this.activeEnd;
      this.dataReuse(newActiveStart, newActiveStart, this.activeEnd);
    }
    if (newActiveStart > this.activeEnd || newActiveEnd < this.activeStart) {
      this.items = new Array(this.windowSize);
    }
    Log.info(TAG, `activeStart=${this.activeStart}, activeEnd=${this.activeEnd}, newActiveStart=${newActiveStart}`
    + `, newActiveEnd=${newActiveEnd}, requestStart=${requestStart}, requestCount=${requestCount}`);
    this.activeStart = newActiveStart;
    this.activeEnd = newActiveEnd;

    let callback: GetItemsCallback = new GetItemsCallback(this, requestStart);
    let param: QueryParam = {
      albumUri: this.albumUri,
      start: requestStart,
      count: requestCount
    };
    if (this.filterMediaType != undefined) {
      param.filterMediaType = this.filterMediaType;
    }
    this.photoDataImpl.getData(callback, param);
  }

  getMediaItemSafely(index: number): MediaItem {
    let mediaItem: MediaItem = this.items[index];
    if (mediaItem == null) {
      Log.error(TAG, `invalid data, index:${index}, active Start:${this.activeStart}, End:${this.activeEnd}`);
      mediaItem = new MediaItem(null);
    }
    return mediaItem;
  }

  // Forced refresh interface
  forceUpdate() {
    this.onDataReloaded();
  }

  // Packaging data for the view layer
  getWrappedData(index: number): ViewData {
    let mediaItemIndex: number = this.dataIndexes[index] - this.activeStart;
    if (mediaItemIndex < 0 || mediaItemIndex >= this.items.length) {
      return undefined;
    }
    let result = {
      viewType: ViewType.ITEM,
      mediaItem: this.getMediaItemSafely(mediaItemIndex),
      viewIndex: index
    };
    return result;
  }

  setAlbumUri(uri: string): void {
    Log.info(TAG, `setAlbumUri: ${uri}`)
    this.albumUri = uri;
  }

  getAlbumUri(): string {
    return this.albumUri;
  }

  setFilterMediaType(filterMediaType: string): void {
    Log.info(TAG, `set filterMediaType: ${filterMediaType}`)
    this.filterMediaType = filterMediaType;
  }

  setBroadCast(broadCastParam: BroadCast): void {
    this.broadCast = broadCastParam;
  }

  setPhotoBroadCast(broadCastParam: BroadCast): void {
    this.photosBroadCast = broadCastParam;
  }

  releasePhotoBroadCast(): void {
    this.photosBroadCast = null;
  }

  onPhotoBrowserActive(isActive: boolean, transition: string): void {
    if (transition == Constants.PHOTO_TRANSITION_ALBUM || transition == Constants.PHOTO_TRANSITION_CAMERA) {
      if (isActive) {
        Log.info(TAG, 'onPhotoBrowserActive')
        this.onActive();
      } else {
        this.onInActive();
      }
    } else if (transition == Constants.PHOTO_TRANSITION_EDIT) {
      if (isActive) {
        this.isEditSaveReload = true;
        this.onActive();
      } else {
        this.isEditSaveReload = false;
      }
    }
  }

  getIndexByMediaItem(item: MediaItem): number {
    for (let index = 0; index < this.items.length; index++) {
      if (item.uri == this.items[index].uri) {
        this.items[index] = item
        return index;
      }
    }
    return -1;
  }

  // 父类方法需要子类覆写
  getPositionByIndex(index: number): number {
    return index;
  }

  onChange(mediaType: string): void {
    if (mediaType === 'image' || mediaType === 'video' || mediaType === 'album') {
      Log.debug(TAG, `local onChange ${mediaType}`);
      super.onChange(mediaType);
    }
  }

  switchRefreshOn(): void {
    this.isRefresh = true
  }

  getGroupCountBeforeItem(item: MediaItem): number {
    return 0;
  }

  private getWindowActiveStart(dataIndex: number, windowCenter: number): number {
    let isForward = (dataIndex > windowCenter);
    let halfWinSize = Math.round(this.windowSize / 2);
    // The end of the window does not exceed the total amount of data when the window moves forward.
    if (isForward) {
      let forwardStep = dataIndex - windowCenter;
      forwardStep = forwardStep % Constants.STEP == 0
        ? forwardStep
        : Math.ceil(forwardStep / Constants.STEP) * Constants.STEP;
      let forwardStepSize = Math.min(forwardStep, Math.abs(this.mediaCount - this.activeEnd));
      Log.info(TAG, `forwardStep=${forwardStep}, stepSize=${forwardStepSize}, activeStart=${this.activeStart}`);
      return (this.activeStart + forwardStepSize);
    } else {
      let backwardStep = windowCenter - dataIndex;
      backwardStep = backwardStep % Constants.STEP == 0
        ? backwardStep
        : Math.ceil(backwardStep / Constants.STEP) * Constants.STEP;
      Log.info(TAG, `backward step ${backwardStep}, activeStart=${this.activeStart}`);
      return Math.max(0, this.activeStart - backwardStep);
    }
  }

  /**
   * data Reuse
   *
   * @param newActiveStart
   * @param startIndex
   * @param endIndex
   */
  private dataReuse(newActiveStart: number, startIndex: number, endIndex: number): void {
    let newData: MediaItem[] = new Array(this.windowSize);
    for (let i = startIndex; i < endIndex; i++) {
      newData[i - newActiveStart] = this.items[i - this.activeStart];
    }
    this.items = newData;
  }

  isInvalidData(requestUri: string, dataUri: string): boolean {
    if (dataUri === '' || dataUri === undefined || dataUri === null) {
      return false;
    }
    return !(requestUri === dataUri);
  }
}