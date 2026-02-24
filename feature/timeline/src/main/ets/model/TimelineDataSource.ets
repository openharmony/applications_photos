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

import lazy { AsyncCallback } from '@ohos/common/src/main/ets/default/model/common/AsyncCallback';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BrowserDataInterface, QueryParam } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';
import lazy { CommonObserverCallback } from '@ohos/common/src/main/ets/default/model/browser/CommonObserverCallback';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy {
  MediaObserver,
  PhotoAssetChangeInfos,
  MediaChangeListener,
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy {
  MediaChangeDataSource,
  MediaDataProvider,
  MediaDataVaryInfo,
  MediaObserverNfyInfo,
  MediaObserverNfyType
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy { PhotoDataImplAsync } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImplAsync';
import lazy { TimelineData } from '@ohos/common/src/main/ets/default/model/browser/photo/TimelineData';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { ViewData } from '@ohos/common/src/main/ets/default/model/browser/photo/ViewData';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy {
  ChangeInfo,
  ChangeType,
  DataSource,
  LoadingInfo,
  LoadingResult,
  LoadingState,
  LoadingTask
} from '@ohos/common/src/main/ets/default/model/DataSource';
import lazy { Throttle } from '@ohos/common/src/main/ets/default/utils/Throttle';
import lazy { TimelineDataImplAsync } from '@ohos/common/src/main/ets/default/model/browser/photo/TimelineDataImplAsync';
import lazy {
  AccurateUpdateItemsInfo,
  BackFillMode
} from '@ohos/common/src/main/ets/default/model/AccurateUpdateItemsInfo';
import lazy { TimelineLoadingInfo } from '@ohos/common/src/main/ets/default/model/MediaLibLoadingInfo';
import lazy { AccurateGroupQueryInfo } from '@ohos/common/src/main/ets/default/model/AccurateGroupInfo';
import lazy { MediaLibChangeInfo } from '@ohos/common/src/main/ets/default/model/MediaLibChangeInfo';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy {
  CommonContext,
  TimelineDataManager
} from '@ohos/common/src/main/ets/default/model/browser/photo/TimelineDataManager';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { DataWindow } from '@ohos/common/src/main/ets/default/utils/DataSourceWindowUtil';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { AlbumDataSource, AlbumLoadingTask,
  AlbumLoadingTaskParams,
  AlbumLoadingTaskResult,
  GroupPageData } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { ColdStartState } from '@ohos/common/src/main/ets/default/model/ColdStartState';
import lazy { AlbumUtils } from '@ohos/common/src/main/ets/default/utils/AlbumUtils';
import lazy { Protocol } from '@ohos/tools/src/main/variables/PrivacyGlobal';
import lazy { AlbumAccurateUpdater } from '@ohos/common/src/main/ets/default/model/AlbumAccurateUpdater';
import lazy { AccurateUpdater } from '@ohos/common/src/main/ets/default/model/AccurateUpdater';
import lazy { PageData } from '@ohos/common/src/main/ets/default/model/PageData';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { DataStoreUtil } from '@ohos/common/src/main/ets/default/utils/DataStoreUtil';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';

const TAG: string = 'TimelineDataSource';
const DAY_VIEW_TAG: string = '_DayView';

// TimelineDataSource
const TITLE_DATA_INDEX = -1;

/**
 * 初始第一批加载数量，设置为较小的，以提升冷启加载速度
 */
const INIT_FIRST_PATCH_LOAD_COUNT: number = DeviceInfo.isPc() ? 100 : 72;

/**
 * 定义最大可替换数目
 */
const MAX_REPLACE_NEW_ITEMS_COUNT: number = 200;

/**
 * 精准更新数据量门槛
 */
const ACCURATE_UPDATE_THRESHOLD = 20000;

interface TimelineLoadingTaskParams extends AlbumLoadingTaskParams {
  dataImpl: PhotoDataImplAsync;
  groupDataImpl: TimelineDataImplAsync;
  oldGroupData: TimelineData[];
  firstIndex: number;
  needThumbnailReady: boolean;
}

class TimelineLoadingTask extends AlbumLoadingTask {
  private readonly dataImpl: PhotoDataImplAsync;
  private readonly groupDataImpl: TimelineDataImplAsync;
  private readonly oldGroupData: TimelineData[];
  private readonly coldStartState: ColdStartState;
  private firstIndex: number = 0;
  private context: CommonContext;
  private needThumbnailReady: boolean = true;

  public constructor(params: TimelineLoadingTaskParams) {
    super(params);
    this.dataImpl = params.dataImpl;
    this.groupDataImpl = params.groupDataImpl;
    this.oldGroupData = params.oldGroupData;
    this.coldStartState = params.coldStartState;
    this.firstIndex = params.firstIndex;
    this.needThumbnailReady = params.needThumbnailReady;
    this.context = params.context as CommonContext;
  }

  // 改覆写
  protected override async loadFirstBatch(): Promise<AlbumLoadingTaskResult> {
    // 首批数据先分页查询，再通过查询结果组装分组数据
    let msg: string[] = ['TimelineLoadingTask first batch'];
    let param: QueryParam = {
      albumUri: '',
      start: this.info.start,
      count: this.info.count,
      needThumbnailReady: this.needThumbnailReady,
    };
    let startTime: number = Date.now();
    let items: MediaItem[] = await this.dataImpl.queryData(param);
    msg.push(`query: (${this.info.start},${this.info.start + this.info.count})`, `cost: ${Date.now() - startTime}`,
      `items: ${items.length} ${this.firstIndex}`, `coolStartState ${this.coldStartState});
     `);
    let groups: TimelineData[] = TimelineDataManager.parseGroupData(items);
    Log.info(TAG, msg.join(', '));
    return {
      info: this.info,
      oldPageData: this.pageData,
      newPageData: new GroupPageData<MediaItem>(this.loadVersion, items, 0, 0, groups, this.params.viewMode),
      coldStartState: this.coldStartState,
    } as AlbumLoadingTaskResult;
  }

  protected override async loadSecondBatch(): Promise<AlbumLoadingTaskResult> {
    // 第二批数据按照常规查询流程，先查分组，再先分页查询
    let msg: string[] = ['TimelineLoadingTask second batch'];
    /* instrument ignore if */
    if (this.pageData.size < INIT_FIRST_PATCH_LOAD_COUNT && this.loadVersion === this.pageData.version) {
      // 如果数据总量少于首批加载的量，第二批不需要再加载
      Log.info(TAG, msg.join(', '));
      return {
        info: this.info,
        oldPageData: this.pageData,
        newPageData: this.pageData,
        coldStartState: this.coldStartState,
      } as AlbumLoadingTaskResult;
    }

    let startTime: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('TimelineDayGetGroupData', startTime);
    let groups: TimelineData[] = await this.groupDataImpl.getDataAsync(this.context);
    TraceControllerUtils.finishTraceWithTaskId('TimelineDayGetGroupData', startTime);
    let totalCount: number = 0;
    groups.forEach((data: TimelineData) => totalCount += data.count);
    msg.push(`groupCost: ${Date.now() - startTime}`, `total: ${totalCount}`);

    let param: QueryParam = {
      albumUri: '',
      start: this.info.start,
      count: this.info.count,
      needThumbnailReady: this.needThumbnailReady,
    };
    startTime = Date.now();
    let items: MediaItem[] = await this.dataImpl.queryData(param);
    msg.push(`query: (${this.info.start},${this.info.start + this.info.count})`, `cost: ${Date.now() - startTime}`,
      `items: ${items.length} ${this.firstIndex}`, `coolStartState ${this.coldStartState}`);

    let finalData: MediaItem[] = [];
    for (let i = 0; i < this.info.start + items.length; i++) {
      if (i < this.info.start) {
        finalData.push(this.pageData.getData(i) ?? new MediaItem());
      } else {
        finalData.push(items[i - this.info.start] ?? new MediaItem());
      }
    }

    Log.info(TAG, msg.join(', '));
    return {
      info: this.info,
      oldPageData: this.pageData,
      newPageData: new GroupPageData<MediaItem>(this.loadVersion, finalData, 0, totalCount - finalData.length, groups,
        this.params.viewMode),
      coldStartState: this.coldStartState,
    } as AlbumLoadingTaskResult;
  }

  /* instrument ignore next */
  protected override async loadDataWhenSlide(): Promise<AlbumLoadingTaskResult> {
    let msg: string[] = ['TimelineLoadingTask'];
    msg.push(`groups: ${this.oldGroupData.length}`, `total: ${this.pageData.size}`);
    let param: QueryParam = {
      albumUri: '',
      start: this.info.start,
      count: this.info.count,
      needThumbnailReady: this.needThumbnailReady,
    };
    let startTime: number = Date.now();
    let items: MediaItem[] = await this.dataImpl.queryData(param);
    msg.push(`query: (${this.info.start},${this.info.start + this.info.count})`, `cost: ${Date.now() - startTime}`,
      `items: ${items.length}`);

    // 数据集不变，增量查询场景，合并旧的滑窗数据得到新的数据
    let newItems: (MediaItem | undefined)[] = [];
    for (let i: number = this.source.activeStart; i < this.source.activeEnd; i++) {
      if (i >= this.info.start && i < this.info.start + items.length) {
        // 在新加载的数据范围内，优先取新加载的数据
        newItems.push(items[i - this.info.start]);
      } else {
        newItems.push(this.pageData.getData(i));
      }
    }

    Log.info(TAG, msg.join(', '));
    return {
      info: this.info,
      oldPageData: this.pageData,
      newPageData: new GroupPageData<MediaItem>(this.loadVersion, newItems, this.source.activeStart,
        this.pageData.size - this.source.activeStart - newItems.length,
        (this.pageData as GroupPageData<MediaItem>)?.groups, this.params.viewMode).trim(),
      coldStartState: this.coldStartState,
    } as AlbumLoadingTaskResult;
  }

  /* instrument ignore next */
  protected override async loadDataWhenRefresh(): Promise<AlbumLoadingTaskResult> {
    let msg: string[] = ['TimelineLoadingTask'];
    let groups: TimelineData[] = this.oldGroupData;
    /*
     * 这里可以根据 LoadingInfo 中封装的changeInfo（可能包含数据库通知），调整分组数据的组装，而不经过数据库查询
     * 比如仅滑窗更新场景，不需要查询；又如，数据库通知为新增，但是只到新增数据在哪一天，直接更新对应的分组即可
     */
    let startTime: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('TimelineDayGetGroupData', startTime);
    let info: TimelineLoadingInfo = this.info as TimelineLoadingInfo;
    let newDataCount: number = 0;
    let snapShot: PageData<MediaItem> | undefined = undefined;
    if (this.params.accurateUpdater.data) {
      snapShot = this.params.accurateUpdater.data;
    }
    if (!this.params.accurateUpdater.shouldQueryCount() && snapShot) {
      newDataCount = snapShot.placeholdersBefore + snapShot.data.length + snapShot.placeholdersAfter;
      groups = (this.params.accurateUpdater.data as GroupPageData<MediaItem>)?.groups;
      msg.push(`refresh update count: ${newDataCount},`);
    } else {
      groups = await this.groupDataImpl.getDataAsync(this.context);
      groups.forEach((data: TimelineData) => newDataCount += data.count);
      msg.push('refresh all');
    }

    TraceControllerUtils.finishTraceWithTaskId('TimelineDayGetGroupData', startTime);
    msg.push(`groupCost: ${Date.now() - startTime}`, `groups: ${groups.length}`, `total: ${newDataCount}`);

    if (newDataCount === 0) {
      Log.info(TAG, msg.join(', '));
      return {
        info: this.info,
        oldPageData: this.pageData,
        newPageData: new GroupPageData<MediaItem>(this.loadVersion, [], 0, 0, groups, this.params.viewMode),
        coldStartState: this.coldStartState,
      } as AlbumLoadingTaskResult;
    }

    // 根据新的数据集范围，调整数据加载位置
    let loadCount: number = Math.min(this.info.count, newDataCount);
    let loadStart: number = Math.min(newDataCount - loadCount, this.info.start);

    // 加载对应范围的数据，这里同样可以根据数据库通知，调整查询策略，比如只更新单条
    startTime = Date.now();
    let newPageData: AlbumLoadingTaskResult =
      await this.preciseQueryData(loadStart, loadCount, snapShot, msg, groups, newDataCount);
    Log.info(TAG, msg.join(','));
    return newPageData;
  }

  protected async queryData(loadStart: number, loadCount: number): Promise<MediaItem[]> {
    let param: QueryParam = {
      albumUri: '',
      start: loadStart,
      count: loadCount,
      needThumbnailReady: true,
    };
    return this.dataImpl.queryData(param);
  }

  protected async fullyQueryData(startTime: number, loadStart: number, loadCount: number,
    cachedItems: MediaItem[] | undefined, msg: string[], newDataCount: number, groups: TimelineData[] | undefined):
    Promise<AlbumLoadingTaskResult> {
    let items: MediaItem[] = [];
    if (cachedItems === undefined) {
      let param: QueryParam = {
        albumUri: '',
        start: loadStart,
        count: loadCount,
        needThumbnailReady: this.needThumbnailReady,
      };
      items = await this.dataImpl.queryData(param);
      msg.push('getNewItems from query');
    }
    msg.push(`(start:${loadStart}, end:${loadStart + loadCount})`, `cost: ${Date.now() - startTime}`,
      `items: ${items.length}, ${this.firstIndex}`);
    Log.info(TAG, msg.join(', '));
    return {
      info: this.info,
      oldPageData: this.pageData,
      newPageData: new GroupPageData<MediaItem>(this.loadVersion, items, loadStart,
        newDataCount - loadStart - items.length, groups, this.params.viewMode).trim(),
      coldStartState: this.coldStartState,
    } as AlbumLoadingTaskResult;
  }

  /* instrument ignore next */
  private isDataFromNewGroup(info: TimelineLoadingInfo): boolean {
    // info/info.newGroupsHandleInfo数据存在；非dirty状态；且newGroups有数据
    return info && info.newGroupsHandleInfo && info.newGroupsHandleInfo.newGroups !== undefined
      && info.newGroupsHandleInfo.newGroups.length !== 0;
  }

  /* instrument ignore next */
  private isDataFromNewItems(info: TimelineLoadingInfo, loadStart: number): boolean {
    return this.isDataFromNewGroup(info) && info.newItemsUpdateInfo.isCanAccurateUpdate() &&
      info.start === this.pageData.placeholdersBefore &&
      info.start === info.newItemsUpdateInfo.start &&
      loadStart === info.newItemsUpdateInfo.start;
  }

  /* instrument ignore next */
  private async getNewItemsFromCache(info: TimelineLoadingInfo, loadStart: number, loadCount: number):
    Promise<MediaItem[] | undefined> {
    let appendTailCount: number = info.newItemsUpdateInfo.getAppendTailCount();
    if (info.newItemsUpdateInfo.hasAppendHeadItems() && appendTailCount > 0) {
      // 同时需要前方补位和后方补位，直接走全量更新流程
      Log.info(TAG, 'getNewItemsFromCache encounter FillHead and FillTail.');
      return undefined;
    }
    let fileIds: number[] | undefined = info.newItemsUpdateInfo.getQueryFileIds();
    if (fileIds && fileIds.length > MAX_REPLACE_NEW_ITEMS_COUNT) {
      // 超过最大replace数目，直接走全量更新流程
      Log.info(TAG, `getNewItemsFromCache encounter over max replace count ${MAX_REPLACE_NEW_ITEMS_COUNT}.`);
      return undefined;
    }

    if (fileIds && fileIds.length > 0) {
      Log.info(TAG, `getNewItemsFromCache REPLACE count: ${fileIds.length}`);
      let param: QueryParam = {
        albumUri: '',
        needThumbnailReady: this.needThumbnailReady,
        fileIds: fileIds,
      };
      let queryItems: MediaItem[] = await this.dataImpl.queryData(param);
      // 查询信息回填原始队列
      if (!info.newItemsUpdateInfo.backFillOriginal(queryItems, BackFillMode.REPLACE)) {
        Log.warn(TAG, `getNewItemsFromCache REPLACE failed, queryItems count: ${queryItems.length}`);
        return undefined;
      }
    }

    if (info.newItemsUpdateInfo.hasAppendHeadItems()) {
      let appendCount: number = info.newItemsUpdateInfo.getAppendHeadCount();
      Log.info(TAG, `getNewItemsFromCache FILL_HEAD count: ${appendCount}`);
      let param: QueryParam = {
        albumUri: '',
        start: loadStart,
        count: appendCount,
        needThumbnailReady: this.needThumbnailReady,
      };
      let queryItems: MediaItem[] = await this.dataImpl.queryData(param);
      if (!info.newItemsUpdateInfo.backFillOriginal(queryItems, BackFillMode.FILL_HEAD)) {
        Log.warn(TAG, `getNewItemsFromCache FILL_HEAD failed, queryItems count: ${queryItems.length}`);
        return undefined;
      }
    }

    if (appendTailCount > 0) {
      Log.info(TAG, `getNewItemsFromCache FILL_TAIL count: ${appendTailCount}`);
      let param: QueryParam = {
        albumUri: '',
        start: loadStart + loadCount - appendTailCount,
        count: appendTailCount,
        needThumbnailReady: this.needThumbnailReady,
      };
      let queryItems: MediaItem[] = await this.dataImpl.queryData(param);
      if (!info.newItemsUpdateInfo.backFillOriginal(queryItems, BackFillMode.FILL_TAIL)) {
        Log.warn(TAG, `getNewItemsFromCache FILL_TAIL failed, queryItems count: ${queryItems.length}`);
        return undefined;
      }
    }
    return info.newItemsUpdateInfo.newItems as MediaItem[];
  }
}

export class TimelineDataSource extends AlbumDataSource {
  private static readonly DAY_UPDATE_TIMEOUT_MS = 1000;
  /**
   * 最多暂存50个通知消息
   */
  private static readonly MAX_STASH_NOTIFY_COUNT: number = 10;
  public dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  public groups: TimelineData[] = [];
  public groupBrowserDataImpl?: BrowserDataInterface;
  public realMediaSize: number = 0;
  public realMediaCountFinish: boolean = false;
  private readonly notifyThrottle: Throttle<Object> =
    new Throttle<Object>(TimelineDataSource.DAY_UPDATE_TIMEOUT_MS, TAG);
  private nfyTimer: number = 0;
  private dayDataOffset: number = 0;
  // 配置为1.5屏年视图的数据，需要根据设备计算，默认为800张缩略图
  private maxPhotoNum: number = 800;

  private pendingNtfInfos: MediaObserverNfyInfo[] = [];
  private groupQueryInfo: AccurateGroupQueryInfo = new AccurateGroupQueryInfo();
  private readonly newItemsUpdateInfo: AccurateUpdateItemsInfo = new AccurateUpdateItemsInfo();
  private totalDataCount: number = 0;
  // 当前屏幕第一张缩略图Index
  private firstIndex: number = 0;
  private isAgreed: boolean = false;

  public constructor(windowSize: number, broadCast: BroadCast) {
    super({
      context: getContext() || global.uiAbilityContext(),
      albumInfo: TimelineDataSource.getTimelineAlbumInfo(),
      dataImpl: new PhotoDataImplAsync(DAY_VIEW_TAG),
      windowSize: windowSize,
      isAccurateNotify: true,
    });
    // 看下这个
    this.unifyNotify = true;
    this.initDataTraceName = 'TimeLinePageInitData';
    this.tag = TAG;
    this.groupBrowserDataImpl = new TimelineDataImplAsync();
    this.broadCast = broadCast;
    this.setThumbnailReady(true);
    this.isInInitData = true;
    DataStoreUtil.getInstance().getData<boolean>(Constants.THUMBNAIL_READY_FLAG, true)
      .then((isReady: boolean) => {
        Log.info(TAG, `restore ThumbnailReady: ${isReady}`);
        ImageUtil.setThumbnailReadyFlag(isReady);
        this.needThumbnailReady = isReady;
        this.notifyDirtyAfterPrivacyAgreed();
      }).catch((): void => {
        Log.error(TAG, `Get ThumbnailReady failed`);
        this.notifyDirtyAfterPrivacyAgreed();
      });
    if (!AlbumUtils.useNewPhotoGrid()) {
      UserFileManagerAccess.updateYearMonthGroup();
    }
  }

  /**
   *  同意隐私协议后才通知重新加载数据
   * 隐私协议相关see
   * NewPhotos/feature/privacy/src/main/ets/components/mainpage/Welcome.ets
   * @returns
   */
  private notifyDirtyAfterPrivacyAgreed() {
    Protocol.getIsAgreedPref(this.context).then((isAgreed: boolean) => {
      Log.info(TAG, `notifyDirtyAfterPrivacyAgreed, isAgreed is ${this.isAgreed}`);
      // if (this.isAgreed) {
      //   this.notifyDirty();
      // }
      this.notifyDirty();
    })
  }

  public initialize(): void {
  }

  // 是否基于ready机制读取uri
  public setThumbnailReady(needThumbnailReady: boolean): void {
    Log.info(TAG, `setThumbnailReady: ${needThumbnailReady}`);
    let needThumbnailReadyBefore: boolean = this.needThumbnailReady;
    this.needThumbnailReady = needThumbnailReady;

    // ready切换到按需加载时，触发日视图分组和滑窗的查询更新
    /* instrument ignore next */
    if (needThumbnailReadyBefore && !this.needThumbnailReady) {
      Log.info(TAG, 'setThumbnailReady: convert ready loading to on-demand loading');
      this.groupQueryInfo.setGroupDataDirty('convert ready to on-demand');
      this.notifyDirty({ changeType: ChangeType.DATA } as MediaLibChangeInfo);
    }
  }

  public registerDataChangeListener(listener: DataChangeListener): void {
    let before: number = this.listeners.length;
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
    Log.info(this.tag, `add listener ${before} -> ${this.listeners.length}`);
  }

  public unregisterDataChangeListener(listener: DataChangeListener): void {
    let before: number = this.listeners.length;
    let pos: number = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
    Log.info(this.tag, `remove listener ${before} -> ${this.listeners.length}`);
  }

  /* instrument ignore next */
  public onChange(mediaType: string, isForceUpdate?: boolean | undefined): void {
    this.onMediaLibDataChange(mediaType);
  }

  /* instrument ignore next */
  public onNotify(nfyInfo: MediaObserverNfyInfo, isForceUpdate?: boolean | undefined): void {
    if (AlbumUtils.useAccurateNotify() && this.isAccurateNotify) {
      return;
    }
    this.onMediaLibDataNfy(nfyInfo);
  }

  /* instrument ignore next */
  public initData(): void {
    this.notifyDirty();
  }

  // 获取数据
  getData(index: number): ViewData | undefined {
    /* instrument ignore if */
    if (!this.enableGetDataFlag) {
      return ViewData.getEmptyInstance();
    }
    let modifiedStart: number = this.getModifiedStart(index);
    const wrappedData = this.getWrappedData(modifiedStart);
    let isThumbnailInvalid: boolean = !wrappedData?.mediaItem?.thumbnail;
    /* instrument ignore if */
    if (isThumbnailInvalid && wrappedData) {
      wrappedData.simpleMediaItem = this.getSimpleMediaItem(modifiedStart);
      if (wrappedData.simpleMediaItem) {
        wrappedData.mediaItem = new MediaItem();
        wrappedData.mediaItem.thumbnail = wrappedData.simpleMediaItem.getThumbnailUri();
        wrappedData.mediaItem.uri = wrappedData.simpleMediaItem.uri;
        isThumbnailInvalid = !wrappedData.mediaItem.thumbnail;
      }
      Log.error(TAG, `getData index: ${modifiedStart} isThumbnailInvalid is null`);
    }
    if (modifiedStart !== 0 && isThumbnailInvalid) {
      Log.error(TAG, `getData index: ${modifiedStart} thumbnail is null`);
    }
    if (this.enableDaySlidingWindowFlag) {
      this.updateSlidingWindow(this.layoutToData(modifiedStart));
    }
    Log.info(TAG, `day get data index=${modifiedStart}, ${this.enableDaySlidingWindowFlag}` +
      `, activeIndex:${this.activeStart} to ${this.activeEnd}, DateTaken=${wrappedData?.mediaItem?.getDateTaken()}` +
      `, DateDay=${wrappedData?.mediaItem?.getDateDay()}`);
    return wrappedData;
  }

  // 获取分组数据
  getGroupData(): TimelineData[] {
    return this.groups;
  }

  // 注册监听
  public registerTimelineObserver(): void {
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    MediaObserver.getInstance().register(MediaObserver.REGISTER_PHOTO_CHANGE, this, TAG);
  }

  // 取消监听
  /* instrument ignore next */
  public unregisterTimelineObserver(): void {
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    MediaObserver.getInstance().unregister(MediaObserver.REGISTER_PHOTO_CHANGE, this, TAG);
  }

  /* instrument ignore next */
  private checkUpdateNewItems(nfyInfo: MediaObserverNfyInfo): void {
    Log.info(TAG, 'checkUpdateNewItems start');
    if (this.groupQueryInfo.isDirtyState() || this.newItemsUpdateInfo.isItemsDataDirty || !nfyInfo.sharedPhotoAssets) {
      return;
    }
    if (this.totalDataCount <= ACCURATE_UPDATE_THRESHOLD) {
      this.setItemsDataDirty(`checkUpdateNewItems totalDataCount: ${this.totalDataCount}`);
      return;
    }
    let totalReadDataCount: number = this.groupQueryInfo.getTotalFromGroup();
    if (totalReadDataCount < this.windowSize * 2) {
      // 小批量场景涉及较多补位信息不足场景，考虑到对性能影响不大，暂不处理
      this.setItemsDataDirty(`checkUpdateNewItems totalReadDataCount: ${totalReadDataCount}`);
      return;
    }
    this.newItemsUpdateInfo.handledCount += nfyInfo.sharedPhotoAssets.length;
    if (this.newItemsUpdateInfo.handledCount >= this.windowSize) {
      // 数量过多保护
      this.setItemsDataDirty(`checkUpdateNewItems photoAsset too large over ${this.windowSize}.`);
      return;
    }

    if (this.newItemsUpdateInfo.newItems === undefined) {
      // 初始化数据
      this.newItemsUpdateInfo.newItems = this.pageData.data.slice();
      this.newItemsUpdateInfo.start = this.activeStart;
    }

    Log.info(TAG, `checkUpdateNewItems count: ${nfyInfo.sharedPhotoAssets.length}`);
    if (nfyInfo.type == MediaObserverNfyType.PHOTO_ADD_ASTC) {
      this.updateAddNewItems(nfyInfo.sharedPhotoAssets);
    } else if (nfyInfo.type === MediaObserverNfyType.PHOTO_REMOVE) {
      this.updateDeleteNewItems(nfyInfo.sharedPhotoAssets);
    } else {
      this.setItemsDataDirty('checkUpdateNewItems');
    }
  }

  /* instrument ignore next */
  private updateAddNewItems(originalPhotoAssets: Array<photoAccessHelper.SharedPhotoAsset>): void {
    Log.debug(TAG, 'updateAddNewItems start');
    // 由于Items是按照dateTaken进行排序，此处采用有序数组合并算法
    let photoAssets: photoAccessHelper.SharedPhotoAsset[] = originalPhotoAssets.slice();
    photoAssets.sort((first, second) => {
      // 当前dateTaken有可能是秒级，相等场景下，按照file_id排序，首先，dateTaken越大越靠前，其次，file_id越大越靠前
      let result: number = second.dateTaken - first.dateTaken;
      return (result === 0) ? second.fileId - first.fileId : result;
    });
    let paIndex: number = 0;
    let newItems: (MediaItem | undefined)[] = this.newItemsUpdateInfo.newItems as (MediaItem | undefined)[];
    let itemIndex: number = 0;
    for (; paIndex < photoAssets.length; paIndex++) {
      let photoAsset: photoAccessHelper.SharedPhotoAsset = photoAssets[paIndex];
      if (!photoAsset) {
        continue;
      }
      let exist: boolean = false;
      let findPosition: boolean = false;
      for (; itemIndex < newItems.length; itemIndex++) {
        let item = newItems[itemIndex];
        if (!item) {
          continue;
        }
        if (item.uri === photoAsset.uri) {
          exist = true;
          break;
        } else if (this.isLarger(photoAsset, item)) {
          // dateTaken时间相等时，后插入的在后面
          findPosition = true;
          break;
        }
      }
      if (exist) {
        // 收到一个已经存在于滑窗中的图片，当前策略不处理
        Log.info(TAG, `updateAddNewItems exist uri: ${newItems[itemIndex]?.uri}.`);
        continue;
      }
      if (!findPosition) {
        // 未找到位置，说明位置在滑窗后方不可见区域，此时当前和后续新增都无须处理
        break;
      }
      if ((itemIndex > 0 && itemIndex < newItems.length) || (itemIndex === 0 && this.activeStart === 0)) {
        // 成功找到中间位置，或前方位置
        newItems.splice(itemIndex, 0, this.buildMediaItem(photoAsset)); // 插入数据项
        itemIndex++; // 从下一项开始遍历
      } else {
        // 此时说明插入数据在滑窗前方，涉及前方补位，标记数量
        this.newItemsUpdateInfo.updateAppendHead();
      }
      if (newItems.length + this.newItemsUpdateInfo.getAppendHeadCount() > this.windowSize) {
        // 超过滑窗长度，需要删除末位项
        newItems.splice(newItems.length - 1, 1);
        // 标记删除数量
        this.newItemsUpdateInfo.updateDelete();
      }
    }
    Log.debug(TAG, 'updateAddNewItems end');
  }

  private isLarger(photoAsset: photoAccessHelper.SharedPhotoAsset, mediaItem: MediaItem): boolean {
    return (photoAsset.dateTaken > mediaItem.getDateTaken()) ||
      (photoAsset.dateTaken === mediaItem.getDateTaken() && photoAsset.fileId > mediaItem.getFileId());
  }

  private buildMediaItem(photoAsset: photoAccessHelper.SharedPhotoAsset): MediaItem {
    let mediaItem: MediaItem = new MediaItem(undefined, undefined, photoAsset);
    mediaItem.setDateTaken(photoAsset?.dateTaken);
    mediaItem.setDateDay(photoAsset?.dateDay);
    mediaItem.isFromNtf = true;
    Log.info(TAG, `buildMediaItem mediaItem:${mediaItem.getDateTaken()} ${mediaItem.getDateDay()}`);
    return mediaItem;
  }

  /* instrument ignore next */
  private updateDeleteNewItems(originalPhotoAssets: Array<photoAccessHelper.SharedPhotoAsset>): void {
    Log.debug(TAG, 'updateDeleteNewItems start');
    if (!this.newItemsUpdateInfo.newItems) {
      // 当前数组中没有数据时，不处理
      this.setItemsDataDirty('updateDeleteNewItems invalid newItems.');
      return;
    }

    let newItems: (MediaItem | undefined)[] = this.newItemsUpdateInfo.newItems;
    // 由于Items是按照dateTaken进行排序，此处采用有序数组查找算法
    let photoAssets: photoAccessHelper.SharedPhotoAsset[] = originalPhotoAssets.slice();
    photoAssets.sort((first, second) => {
      // 当前dateTaken有可能是秒级，相等场景下，按照file_id排序，首先，dateTaken越大越靠前，其次，file_id越大越靠前
      let result: number = first.dateTaken - second.dateTaken;
      return result === 0 ? first.fileId - second.fileId : result;
    }); // 日期由大到小排列
    let paIndex: number = photoAssets.length - 1;
    let itemIndex: number = newItems.length - 1;
    for (; paIndex >= 0; paIndex--) {
      let photoAsset: photoAccessHelper.SharedPhotoAsset = photoAssets[paIndex];
      if (!photoAsset) {
        continue;
      }
      let findPosition: boolean = false;
      for (; itemIndex >= 0; itemIndex--) {
        let item = newItems[itemIndex];
        if (!item) {
          continue;
        }
        if (item.uri === photoAsset.uri) {
          // 找到待删元素
          findPosition = true;
          break;
        } else if (!this.isLarger(photoAsset, item)) {
          // 此处说明后续不再可能找到，也就不需要继续查找
          break;
        }
      }
      if (findPosition) {
        Log.info(TAG, `updateDeleteNewItems find delete position: ${itemIndex}.`);
        newItems.splice(itemIndex, 1);
        this.newItemsUpdateInfo.updateDelete();
        continue;
      }
      // 未找到待删除项，说明待删除数据不在滑窗中
      if (newItems[newItems.length - 1] && !this.isLarger(photoAsset, newItems[newItems.length - 1] as MediaItem)) {
        // 说明待删除项在滑窗后方，此时不做任何处理
        Log.info(TAG, 'updateDeleteNewItems not need delete scene 1');
        continue;
      } else if (newItems[0] && this.isLarger(photoAsset, newItems[0] as MediaItem)) {
        // 说明待删除项在滑窗前方
        if (this.newItemsUpdateInfo.hasAppendHeadItems()) {
          // 当存在前方追加时，直接减少前方追加即可
          this.newItemsUpdateInfo.updateAppendHead(-1);
        } else {
          // 否则就需要删除列表元素
          newItems.slice(0, 1);
          this.newItemsUpdateInfo.updateDelete();
        }
      } else {
        // 异常场景，直接标脏
        this.setItemsDataDirty('updateDeleteNewItems find position failed.');
        break;
      }
    }
    Log.debug(TAG, 'updateDeleteNewItems end');
  }

  private setItemsDataDirty(reason: string): void {
    this.newItemsUpdateInfo.setItemsDataDirty(reason);
  }

  private clearNewItems(reason: string): void {
    this.newItemsUpdateInfo.clearNewItems(reason);
  }

  /* instrument ignore next */
  public onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    if (AlbumUtils.useAccurateNotify()) {
      return;
    }
    // ready场景忽略PHOTO_ADD, 按需加载场景忽略PHOTO_ADD_ASTC, 仅包含照片场景
    if (nfyInfo.uris?.length === 0 || nfyInfo.type >= MediaObserverNfyType.ALBUM_ADD ||
      (nfyInfo.type === MediaObserverNfyType.PHOTO_ADD && nfyInfo.sharedPhotoAssets &&
        nfyInfo.sharedPhotoAssets.length > 0 && this.needThumbnailReady) ||
      (nfyInfo.type === MediaObserverNfyType.PHOTO_ADD_ASTC && !this.needThumbnailReady)) {
      Log.info(TAG, `onMediaLibDataNfy no need to load data nfyInfo.type:${nfyInfo.type}`);
      return;
    }
    this.groupQueryInfo.onMediaLibDataNfy(nfyInfo, this.groups);
    this.checkUpdateNewItems(nfyInfo);
    Log.info(TAG, `onMediaLibDataNfy nfyInfo: ${nfyInfo.info()}, isEditSaveReload:${this.isEditSaveReload}`);
    if (this.isEditSaveReload) {
      this.notifyDirty({ changeType: ChangeType.DATA, nfyInfos: [nfyInfo] } as MediaLibChangeInfo);
    } else {
      this.notifyThrottle.execute(() => {
        // 不需要节流的场景直接派发
        Log.info(TAG, 'exec notifies.');
        this.notifyDirty({ changeType: ChangeType.DATA, nfyInfos: [nfyInfo] } as MediaLibChangeInfo);
      }, () => {
        // 延迟触发场景，暂存通知
        Log.info(TAG, `exec notifies after stash. pendingNtfInfos.length:${this.pendingNtfInfos.length}`);
        this.stashNotifies(nfyInfo);
        this.notifyDirty({ changeType: ChangeType.DATA, nfyInfos: this.pendingNtfInfos.slice() } as MediaLibChangeInfo);
        this.pendingNtfInfos = [];
      }, () => {
        // 被节流场景也暂存
        Log.warn(TAG, 'stash notifies.');
        this.stashNotifies(nfyInfo);
      });
    }
  }

  /* instrument ignore next */
  public onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    this.notifyDirty({ changeType: ChangeType.DATA, changeTypes: [changeType] } as MediaLibChangeInfo);
  }

  getWrappedData(index: number, isDayGroupState?: boolean): ViewData | undefined {
    let dataIndexInWindow: number = this.layoutToData(index) - this.activeStart;
    if (isDayGroupState) {
      dataIndexInWindow = this.getDataIndexes(index) - this.activeStart;
      if (dataIndexInWindow === TITLE_DATA_INDEX) {
        let result: ViewData = ViewData.getEmptyInstance();
        return result;
      }
    }
    let result: ViewData;
    if (!isDayGroupState && (dataIndexInWindow > this.items.length || dataIndexInWindow < 0)) {
      Log.error(TAG, `getWrappedData, groupMode: ${isDayGroupState}, index: ${index}, activeStart: ${this.activeStart}, dataIndexInWindow: ${dataIndexInWindow}, items length: ${this.items.length}, index out of active window index`);
      return ViewData.getEmptyInstance();
    }

    const dataIndexesLength: number = this.mediaCount + this.offsetMediaCount.length;
    if (isDayGroupState && (index > dataIndexesLength || index < 0)) {
      Log.error(TAG, `getWrappedData, groupMode: ${isDayGroupState}, index: ${index}, activeStart: ${this.activeStart}, dataIndexInWindow: ${dataIndexInWindow}, dataIndexes length: ${dataIndexesLength}, index out of active window index`);
      return ViewData.getEmptyInstance();
    }

    const mediaItem: MediaItem = this.getMediaItemSafely(dataIndexInWindow);
    const tmp: ViewData | undefined =
      mediaItem.uniqueId === '' ? undefined : this.viewDataCache.get(mediaItem.uniqueId);
    if (tmp) {
      result = tmp;
      result.update(mediaItem);
    } else {
      result = new ViewData(mediaItem);
      if (mediaItem.uniqueId !== '') {
        this.viewDataCache.set(mediaItem.uniqueId, result);
      }
    }
    return result;
  }

  /**
   * 设置日视图重置补位参数
   *
   * @param dataOffset 重置补位参数
   * @param maxPhotoNum 补位生效数量限制
   * @deprecated 原补位逻辑待废弃
   */
  public setDayDataOffset(dataOffset: number, maxPhotoNum: number): void {
    this.dayDataOffset = dataOffset;
    this.maxPhotoNum = maxPhotoNum;
  }

  /**
   * 重置补位参数
   *
   * @deprecated
   */
  public resetDataOffset(): void {
    this.dayDataOffset = 0;
  }

  /**
   * 修改视图起始Index
   *
   * @param index 起始Index
   * @returns 修改后的起始Index
   * @deprecated
   */
  public getModifiedStart(index: number): number {
    let modifiedStart: number = index;
    if (index < this.maxPhotoNum) {
      this.resetDataOffset();
    } else {
      modifiedStart = index - this.dayDataOffset;
      if (modifiedStart < 0) {
        modifiedStart = index;
        this.resetDataOffset();
      }
    }
    return modifiedStart;
  }

  /* instrument ignore next */
  private stashNotifies(nfyInfo: MediaObserverNfyInfo): void {
    if (this.pendingNtfInfos.length >= TimelineDataSource.MAX_STASH_NOTIFY_COUNT) {
      Log.warn(this.tag, 'exceed max stash count');

      // 超过数量，清空，添加一个add通知，来触发全量数据查询
      let info: MediaObserverNfyInfo = new MediaObserverNfyInfo();
      info.type = MediaObserverNfyType.PHOTO_ADD;
      this.pendingNtfInfos = [info];
      return;
    }
    this.pendingNtfInfos.push(nfyInfo);
    Log.info(TAG, `stashNotifies, pendingNtfInfos size:${this.pendingNtfInfos.length}, nfyInfo:${nfyInfo.info()}`);
  }

  protected buildLoadingInfo(changeInfo: ChangeInfo): LoadingInfo {
    let loadingInfo: LoadingInfo = super.buildLoadingInfo(changeInfo);
    return {
      start: loadingInfo.start,
      count: this.coldStartState === ColdStartState.FIRST_BATCH ? INIT_FIRST_PATCH_LOAD_COUNT : loadingInfo.count,
      changeInfo: changeInfo as MediaLibChangeInfo,
      newGroupsHandleInfo: this.groupQueryInfo.getGroupHandleInfo(),
      newItemsUpdateInfo: this.newItemsUpdateInfo.copy(),
    } as TimelineLoadingInfo;
  }

  public setViewFirstIndex(firstIndex: number): void {
    this.firstIndex = firstIndex;
  }

  public override buildLoadingTask(info: LoadingInfo): LoadingTask<MediaItem> | undefined {
    this.groupQueryInfo.loadData();
    let task: LoadingTask<MediaItem> | undefined = new TimelineLoadingTask({
      info: info,
      source: this,
      pageData: this.pageData,
      dataImpl: this.photoDataImpl as PhotoDataImplAsync,
      groupDataImpl: this.groupBrowserDataImpl as TimelineDataImplAsync,
      oldGroupData: this.groups,
      coldStartState: this.coldStartState,
      firstIndex: this.firstIndex,
      accurateUpdater: this.accurateUpdater,
      context: this.context,
      viewMode: this.viewMode,
      albumInfo: this.albumInfo ?? new AlbumInfo(),
      needThumbnailReady: this.needThumbnailReady,
    });
    switch (this.coldStartState) {
      case ColdStartState.FIRST_BATCH:
        this.coldStartState = ColdStartState.SECOND_BATCH;
        setTimeout((): void => this.notifyDirty({ changeType: ChangeType.WINDOW }), 0);
        break;
      case ColdStartState.SECOND_BATCH:
        this.coldStartState = ColdStartState.DONE;
        break;
      default:
        break;
    }
    return task;
  }

  private updateAndDispatchItemsChange(loadingResult: AlbumLoadingTaskResult): void {
    let offset: number = 0;
    for (let i: number = 0; i < loadingResult.info.count; i++) {
      let dataIndex: number = i + loadingResult.info.start;
      if (dataIndex >= this.activeStart && dataIndex < this.activeEnd) {
        const mediaItem: MediaItem = loadingResult.newPageData.getData(dataIndex) ?? new MediaItem();
        /* instrument ignore if */
        if (this.invalidUris.includes(mediaItem.uri)) {
          offset++;
          continue;
        }
        this.items[dataIndex - this.activeStart - offset] = mediaItem;
        if (loadingResult.oldPageData.version === loadingResult.newPageData.version) {
          // 数据集不变场景只需要刷新单条元素，数据集变化场景通过onDataReloaded整体刷新
          this.onDataChanged(this.dataToLayout(dataIndex));
        }
      }
    }
  }

  protected override dispatchWithDataChange(loadingResult: AlbumLoadingTaskResult): void {
    this.groupQueryInfo.notifyLoadDataDone(this.groups);
    if ((loadingResult.info as TimelineLoadingInfo)?.newItemsUpdateInfo.isItemsDataDirty ||
      this.pageData.data.length !== this.newItemsUpdateInfo.newItems?.length ||
      (this.newItemsUpdateInfo.newItems && this.newItemsUpdateInfo.newItems[0]?.uri !== this.pageData.data[0]?.uri)) {
      this.clearNewItems('ItemDataDirty');
    }
    this.adjustSlidingWindow(loadingResult);
    this.clearInvalidUris(loadingResult.newPageData.data);
    this.updateAndDispatchItemsChange(loadingResult);
    this.validEndIndex = loadingResult.newPageData.placeholdersBefore + loadingResult.newPageData.data.length - 1;
    this.dispatchCallbacks(loadingResult);
  }

  protected override dispatchCallbacks(loadingResult: AlbumLoadingTaskResult): void {
    // 通知前台刷新各种属性值，不建议数据层直接调用 onDataReloaded ，由视图层自行刷新，以实现动效等
    this.mCallbacks.has('updateGroupData') && this.mCallbacks.get('updateGroupData')?.(this.groups);
    this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')?.(this.mediaCount);

    // 分组更新老方案照片页专用，后续废弃，group更新要早于loading finish
    this.broadCast?.emit(Constants.ON_GROUP_FINISHED, [this.groups]);

    this.broadCast?.emit(Constants.ON_LOADING_FINISHED, [this.mediaCount]);
    this.notifySizeLoadingFinished(this.mediaCount);
    let addedCount: number = Math.max(0, loadingResult.newPageData.size - loadingResult.oldPageData.size);
    Log.info(TAG, `dispatchCallbacks, isCountChanged: ${this.isCountChanged},
    addedCount: ${addedCount}, newPageData size: ${loadingResult.newPageData.size},
    oldPageData size: ${loadingResult.oldPageData.size}`);
    this.photosBroadCast?.emit(BroadCastConstants.ON_DATA_RELOADED, [addedCount]);
    this.broadCast?.emit(BroadCastConstants.ON_DATA_RELOADED, []);
    /* instrument ignore if */
    if (this.isEditSaveReload) {
      this.photosBroadCast?.emit(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, []);
    } else {
      this.notifyDataLoadingFinished();
    }
  }

  public async changeWindow(dataWindow: DataWindow): Promise<void> {
    /* instrument ignore if */
    if (!this.isActive || !dataWindow) {
      return;
    }
    this.newItemsUpdateInfo.setItemsDataDirty('changeWindow.');
  }

  /**
   * 设置分批更新滑窗的最小数量
   *
   * @param updateCount 最小数量
   */
  public setUpdateMinCount(updateCount: number) {
    this.updateMinCount = updateCount;
  }

  private static getTimelineAlbumInfo(): AlbumInfo {
    let albumInfo: AlbumInfo = new AlbumInfo();
    albumInfo.isTimeline = true;
    return albumInfo;
  }
}
