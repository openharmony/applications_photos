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

import lazy { MediaItem } from './browser/photo/MediaItem';
import lazy { ChangeInfo, ChangeType, DataSource, LoadingInfo, LoadingResult, LoadingTask } from './DataSource';
import lazy { PageData } from './PageData';
import lazy { Log } from '../utils/Log';
import lazy { AlbumUtils } from '../utils/AlbumUtils'
import lazy { MediaObserverNfyInfo } from './browser/dataObserver/MediaObserverCallback';
import lazy { MediaObserver, MediaChangeListener } from './browser/dataObserver/MediaObserver';
import lazy { MediaDataSource } from './browser/photo/MediaDataSource';
import lazy { Constants } from './common/Constants';
import lazy { PhotoDataImpl } from './browser/photo/PhotoDataImpl';
import lazy { PhotoDataImplAsync } from './browser/photo/PhotoDataImplAsync';
import lazy { ColdStartState } from './ColdStartState';
import lazy { AccurateUpdater } from './AccurateUpdater';
import lazy { MediaLibChangeInfo } from './MediaLibChangeInfo';
import lazy { DataSourceWindowUtil, DataWindow } from '../utils/DataSourceWindowUtil';
import lazy { MediaLibLoadingInfo } from './MediaLibLoadingInfo';
import lazy { TraceControllerUtils } from '../utils/TraceControllerUtils';
import lazy { PhotoConfig } from '../config/PhotoConfig';
import type { BrowserDataInterface, QueryParam } from '../interface/BrowserDataInterface';
import lazy { AsyncCallback } from './common/AsyncCallback';
import lazy { DeviceInfo } from '../utils/DeviceInfo';
import lazy { BroadCastConstants } from './common/BroadCastConstants';
import lazy { AlbumInfo } from './browser/album/AlbumInfo';
import lazy { AccurateChecker, AlbumAccurateUpdater } from './AlbumAccurateUpdater';
import lazy { UserFileManagerAccess } from '../access/UserFileManagerAccess';
import lazy { TimelineData } from './browser/photo/TimelineData';
import lazy { CommonContext, TimelineDataManager } from './browser/photo/TimelineDataManager';
import lazy collections from '@arkts.collections';
import lazy taskpool from '@ohos.taskpool';
import lazy { getTimelineDataFunc } from './browser/photo/TimelineDataImplAsync';
import lazy { GridViewMode } from '../view/grid/GridView';
import lazy { DateUtil } from '../utils/DateUtil';
import lazy { AlbumGridSortHelper, SortRuleString } from './AlbumGridSortHelper';
import lazy { SimpleGridMediaItem } from './browser/photo/SimpleGridMediaItem';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../utils/ReportToBigDataUtil';
import lazy { NormalAlbumAccurateUpdater } from './NormalAlbumAccurateUpdater';
import lazy { ImageAlbumAccurateUpdater } from './ImageAlbumAccurateUpdater';
import lazy { VideoAlbumAccurateUpdater } from './VideoAlbumAccurateUpdater';
import lazy { FavoriteAlbumAccurateUpdater } from './FavoriteAlbumAccurateUpdater';
import lazy { TrashAlbumAccurateUpdater } from './TrashAlbumAccurateUpdater';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { TimelineAccurateUpdater } from './TimelineAccurateUpdater';
import lazy { IClassifyFromPhoto } from './browser/photo/PhotoDataManager';
import lazy { PositionFilter } from './PositionFilter';

const TAG: string = 'common_AlbumDataSource';

export class GroupPageData<T> extends PageData<T> {
  public readonly groups: TimelineData[];
  public readonly mode: GridViewMode;

  public constructor(version: number = PageData.nextVersion(), data: (T | undefined) [] = [],
    placeholdersBefore: number = 0, placeholdersAfter: number = 0, groups: TimelineData[] = [],
    mode: GridViewMode = GridViewMode.GRID) {
    super(version, data, placeholdersBefore, placeholdersAfter);
    this.groups = groups ?? [];
    this.mode = mode;
  }

  public trim(): GroupPageData<T> {
    let pageData: PageData<T> = super.trim();
    return new GroupPageData<T>(pageData.version, pageData.data, pageData.placeholdersBefore,
      pageData.placeholdersAfter, this.groups, this.mode);
  }

  /**
   * 拷贝当前GroupPageData
   * @returns 拷贝的新GroupPageData
   */
  public copy(): GroupPageData<T> {
    let version = this.version;
    let placeholdersBefore = this.placeholdersBefore;
    let placeholdersAfter = this.placeholdersAfter;
    let data: (T | undefined)[] = this.data.slice();
    let groups: TimelineData[] = this.groups.slice();
    let mode: GridViewMode = this.mode;
    return new GroupPageData(version, data, placeholdersBefore, placeholdersAfter, groups, mode);
  }
}

export interface AlbumLoadingInfo extends MediaLibLoadingInfo {
  albumInfo: AlbumInfo;
  needThumbnailReady: boolean;
  filterMediaType: string;
  initCount: number | undefined;
}

export interface AlbumLoadingTaskParams {
  info: LoadingInfo;
  source: DataSource<MediaItem>;
  pageData: PageData<MediaItem>;
  accurateUpdater: AccurateUpdater<MediaItem>;
  coldStartState: ColdStartState;
  context: Context;
  dataImpl: BrowserDataInterface | PhotoDataImpl;
  readonly viewMode: GridViewMode;
  readonly albumInfo: AlbumInfo;
}

export interface AlbumLoadingTaskResult extends LoadingResult<MediaItem> {
  readonly coldStartState: ColdStartState;
}

export class AlbumLoadingTask extends LoadingTask<MediaItem> {
  protected readonly params: AlbumLoadingTaskParams;
  private readonly operationType: string = "REQUEST_VIEW_TYPE_PHOTOS";
  private startTime: number = 0;
  private operateCount: number = 0;
  /**
   * 构造函数
   * @param info 加载信息
   * @param source 数据源
   * @param pageData 当前滑窗数据
   */
  public constructor(params: AlbumLoadingTaskParams) {
    super(params.info, params.source, params.pageData);
    this.params = params;
  }

  public async start(): Promise<LoadingResult<MediaItem>> {
    if (!this.params.context) {
      Log.warn(TAG, 'invalid context');
    }

    if (this.info.start < 0 || this.info.count <= 0) {
      return {
        info: this.info,
        oldPageData: this.pageData,
        newPageData: this.pageData,
        coldStartState: this.params.coldStartState,
      } as AlbumLoadingTaskResult;
    }

    Log.info(TAG, 'AlbumLoadingTask.start');
    switch (this.params.coldStartState) {
      case ColdStartState.FIRST_BATCH:
        return this.loadFirstBatch();
      case ColdStartState.SECOND_BATCH:
        return this.loadSecondBatch();
      default:
        if (this.loadVersion === this.pageData.version) {
          // 仅滑窗变更
          return this.loadDataWhenSlide();
        } else {
          // 数据刷新
          return this.loadDataWhenRefresh();
        }
    }
  }

  protected async loadFirstBatch(): Promise<AlbumLoadingTaskResult> {
    // 首批数据查询，不查总数量，直接进行分页查询
    let loadingInfo: AlbumLoadingInfo = this.info as AlbumLoadingInfo;
    let msg: string[] = [`loadFirstBatch mode: ${this.params.albumInfo.viewMode}`];
    let startTime: number = Date.now();
    let items: MediaItem[] = await this.loadData(loadingInfo.start, loadingInfo.count);
    let count: number = 0;
    msg.push(`initCount: ${loadingInfo.initCount}`);
    if (loadingInfo.initCount) {
      count = loadingInfo.initCount;
    }
    msg.push(`cost: ${Date.now() - startTime}`, `items: ${items.length}`);
    let groups: TimelineData[] = [];
    const albumKey: string = AlbumGridSortHelper.getAlbumKeyByAlbumInfo(this.params.albumInfo);
    const orderBy: string = AlbumGridSortHelper.getOrderPropByAlbumUri(this.params.albumInfo?.uri ?? '', albumKey);
    const isDesc: boolean =
      AlbumGridSortHelper.getInstance().getSortRule('loadFirstBatch', albumKey ?? '')?.type === SortRuleString.DESC;
    if (
      orderBy === UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString() &&
        isDesc ||
        this.params.viewMode === GridViewMode.GROUP
    ) {
      // 图片、视频相册以添加时间排序，首批组装的数据不可信
      groups = TimelineDataManager.parseGroupData(items);
    }
    msg.push(`groups: ${JSON.stringify(groups)}`);
    Log.info(TAG, msg.join(', '));
    return {
      info: this.info,
      oldPageData: this.pageData,
      newPageData: new GroupPageData<MediaItem>(this.loadVersion, items, 0, count > items.length ?
        count - items.length : 0, groups, this.params.viewMode),
      coldStartState: this.params.coldStartState,
    } as AlbumLoadingTaskResult;
  }

  protected async loadData(start: number, count: number): Promise<MediaItem[]> {
    let loadingInfo: AlbumLoadingInfo = this.info as AlbumLoadingInfo;
    let param: QueryParam = {
      albumUri: loadingInfo.albumInfo.uri as string,
      start: start,
      count: count,
      needThumbnailReady: loadingInfo.needThumbnailReady,
    };
    if (loadingInfo.filterMediaType) {
      param.filterMediaType = loadingInfo.filterMediaType;
    }
    if (this.params.viewMode === GridViewMode.GROUP) {
      param.orderBy = UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString();
    } else {
      const albumKey: string = AlbumGridSortHelper.getAlbumKeyByAlbumInfo(this.params.albumInfo);
      param.orderBy =
        AlbumGridSortHelper.getOrderPropByAlbumUri(this.params.albumInfo?.uri ?? '', albumKey);
    }
    return new Promise<MediaItem[]>((resolve) => {
      let asyncCallback: AsyncCallback<MediaItem[]> | undefined = {
        callback: (items: MediaItem[], albumUri: string) => {
          asyncCallback = undefined;
          resolve(items);
        },
      };
      this.params.dataImpl.getData(asyncCallback, param);
    });
  }

  protected async loadDataCount(): Promise<number> {
    let loadingInfo: AlbumLoadingInfo = this.info as AlbumLoadingInfo;
    let param: QueryParam =
        loadingInfo.filterMediaType ?
        { albumUri: loadingInfo.albumInfo.uri, filterMediaType: loadingInfo.filterMediaType, } :
        { albumUri: loadingInfo.albumInfo.uri, };
    return new Promise<number>((resolve) => {
      let asyncCallback: AsyncCallback<number> | undefined = {
        callback: (count: number, albumUri: string) => {
          asyncCallback = undefined;
          resolve(count);
        },
      };
      this.params.dataImpl.getDataCount(asyncCallback, param);
    });
  }

  protected async loadGroupData(): Promise<TimelineData[]> {
    let albumUri: string = (this.info as AlbumLoadingInfo)?.albumInfo.uri ?? '';
    let result: Object = await taskpool.execute(getTimelineDataFunc, this.params.context as CommonContext, albumUri,
      (this.params.dataImpl as PhotoDataImpl).positionFilter);
    let array: collections.Array<TimelineData> =
      (result as collections.Array<TimelineData>) ?? new collections.Array<TimelineData>();
    Log.info(TAG, `loadGroupData ${array.length}`);
    return TimelineData.convertTimelineData(array);
  }

  protected async loadSecondBatch(): Promise<AlbumLoadingTaskResult> {
    this.startTime = Date.now();
    TraceControllerUtils.startTraceWithTaskId(this.operationType, this.startTime);
    Log.info(TAG, `loadSecondBatch start ${this.startTime}-${this.operateCount}`);
    // 第二批数据按照常规查询流程，先查总量，再查分页数据
    let msg: string[] = [`loadSecondBatch mode: ${this.params.viewMode}`];
    if (this.pageData.size < DataSourceWindowUtil.INIT_FIRST_PATCH_LOAD_COUNT &&
      this.loadVersion === this.pageData.version) {
      // 如果数据总量少于首批加载的量，第二批不需要再加载
      Log.info(TAG, msg.join(', '));
      return {
        info: this.info,
        oldPageData: this.pageData,
        newPageData: this.pageData,
        coldStartState: this.params.coldStartState,
      } as AlbumLoadingTaskResult;
    }

    let startTime: number = Date.now();
    let count: number = this.pageData.size;
    let groups: TimelineData[] | undefined = (this.pageData as GroupPageData<MediaItem>)?.groups ?? [];
    if (this.params.viewMode === GridViewMode.GROUP) {
      groups = await this.loadGroupData();
      count = 0;
      groups.forEach((data: TimelineData) => count += data.count);
    } else {
      count = await this.loadDataCount();
    }

    msg.push(`countCost: ${Date.now() - startTime}`, `count:${count}`);
    startTime = Date.now();
    let loadingInfo: AlbumLoadingInfo = this.info as AlbumLoadingInfo;
    let items: MediaItem[] = await this.loadData(loadingInfo.start, loadingInfo.count);
    msg.push(`itemCost: ${Date.now() - startTime}`, `items:${items.length}`);
    let finalData: MediaItem[] = [];
    for (let i = 0; i < this.info.start + items.length; i++) {
      if (i < this.info.start) {
        finalData.push(this.pageData.getData(i) ?? new MediaItem());
      } else {
        finalData.push(items[i - this.info.start] ?? new MediaItem());
      }
    }
    msg.push(`groups: ${JSON.stringify(groups)}`);
    Log.info(TAG, msg.join(', '));
    let e2eLatency = Date.now() - this.startTime;
    this.operateCount = count;
    if (e2eLatency >= BigDataConstants.FAULT_THRESHOLD) {
      ReportToBigDataUtil.reportOperationLatency(this.operationType, this.startTime, e2eLatency, this.operateCount);
      Log.info(TAG, `loadSecondBatch:${this.operationType}-${this.startTime} -${e2eLatency}-${this.operateCount}`);
    }
    TraceControllerUtils.finishTraceWithTaskId(this.operationType, this.startTime);
    return {
      info: this.info,
      oldPageData: this.pageData,
      newPageData: new GroupPageData<MediaItem>(this.loadVersion, finalData, 0, count - finalData.length, groups,
        this.params.viewMode),
      coldStartState: this.params.coldStartState,
    } as AlbumLoadingTaskResult;
  }

  protected async loadDataWhenSlide(): Promise<AlbumLoadingTaskResult> {
    let msg: string[] = ['loadDataWhenSlide'];
    let loadingInfo: AlbumLoadingInfo = this.info as AlbumLoadingInfo;
    let startTime: number = Date.now();
    let items: MediaItem[] = await this.loadData(loadingInfo.start, loadingInfo.count);
    msg.push(`query: (${this.info.start},${this.info.start + this.info.count})`, `cost: ${Date.now() - startTime}`,
      `items: ${items.length}`);

    // 数据集不变，增量查询场景，合并旧的滑窗数据得到新的数据
    let newItems: (MediaItem | undefined)[] = [];
    let end: number = Math.min(this.pageData.size, this.source.activeEnd);
    for (let i: number = this.source.activeStart; i < end; i++) {
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
      coldStartState: this.params.coldStartState,
    } as AlbumLoadingTaskResult;
  }

  protected async loadDataWhenRefresh(): Promise<AlbumLoadingTaskResult> {
    let msg: string[] = [`loadDataWhenRefresh mode: ${this.params.viewMode} ${this.info.start} ${this.info.count}`];
    let startTime: number = Date.now();
    let newDataCount: number = this.pageData.size;
    let groups: TimelineData[] | undefined = (this.pageData as GroupPageData<MediaItem>)?.groups;
    let snapShot: PageData<MediaItem> | undefined = undefined;
    if (this.params.accurateUpdater.data) {
      snapShot = this.params.accurateUpdater.data;
    }
    if (this.params.accurateUpdater instanceof AlbumAccurateUpdater &&
      !this.params.accurateUpdater.shouldQueryCount() &&
      (this.params.dataImpl as PhotoDataImpl).positionFilter === undefined) {
      // 通过精准通知获取数据集总大小,count必然可用，查询or增量更新的
      newDataCount = this.params.accurateUpdater.getTotalCount();
      groups = (this.params.accurateUpdater.data as GroupPageData<MediaItem>)?.groups;
      msg.push(`incremental count: ${newDataCount}, `);
    } else {
      msg.push('full query count');
      if (this.params.viewMode === GridViewMode.GROUP) {
        groups = await this.loadGroupData();
        newDataCount = 0;
        groups.forEach((data: TimelineData) => newDataCount += data.count);
      } else {
        newDataCount = await this.loadDataCount();
      }
    }
    msg.push(`countCost: ${Date.now() - startTime}`);

    if (newDataCount === 0) {
      Log.info(TAG, msg.join(', '));
      return {
        info: this.info,
        oldPageData: this.pageData,
        newPageData: new GroupPageData<MediaItem>(this.loadVersion, [], 0, 0, groups, this.params.viewMode),
        coldStartState: this.params.coldStartState,
      } as AlbumLoadingTaskResult;
    }

    // 根据新的数据集范围，调整数据加载位置
    let loadCount: number = Math.min(this.info.count, newDataCount); // 确定查询数量
    let loadStart: number = Math.min(newDataCount - loadCount, this.info.start); // start尽可能往前移

    // 加载对应范围的数据，这里同样可以根据数据库通知，调整查询策略，比如只更新单条
    let newPageData: AlbumLoadingTaskResult =
      await this.preciseQueryData(loadStart, loadCount, snapShot, msg, groups, newDataCount);
    msg.push(`loadData cost time: ${Date.now() - startTime} ms`);
    msg.push(`groups: ${JSON.stringify(groups)}`);
    Log.info(TAG, msg.join(','));
    return newPageData;
  }

  protected async preciseQueryData(loadStart: number, loadCount: number, snapShot: PageData<MediaItem> | undefined,
    msg: string[], groups: TimelineData[] | undefined, newDataCount: number): Promise<AlbumLoadingTaskResult> {
    // 加载对应范围的数据，这里同样可以根据数据库通知，调整查询策略，比如只更新单条
    let cachedItems: MediaItem[] | undefined = undefined;
    let startTime: number = Date.now();
    if (!this.params.accurateUpdater.shouldQueryData() && snapShot &&
      (this.params.dataImpl as PhotoDataImpl).positionFilter === undefined) {
      msg.push('incremental items');
      // 可用场景取交集，交集部分判断有无不能复用
      const total = snapShot.placeholdersBefore + snapShot.data.length +
      snapShot.placeholdersAfter; // 总数据集的大小为before + data.length + after
      const end = loadStart + loadCount - 1; // 需要加载的窗口的结束位置
      const dataStart = snapShot.placeholdersBefore; // data数据的起始index
      const dataEnd = dataStart + snapShot.data.length - 1; // data数据的结束index

      // 计算交集的位置，交集的开始为查询start和数据start的最大值，交集的结束为查询end和数据end的最小值
      const overlapStart = Math.max(loadStart, dataStart);
      const overlapEnd = Math.min(end, dataEnd);

      // 交集的start大于end的时候，代表没有可以复用的交集部分，直接全量查询
      if (overlapStart > overlapEnd) { // 加载整个窗口的位置
        const newData = await this.queryData(loadStart, loadCount);
        const newBefore = loadStart;
        const newAfter = total - loadStart - loadCount;
        msg.push(`query all, start: ${loadStart} count: ${loadCount} before: ${newBefore} after: ${newAfter}`);
        return {
          info: this.info,
          oldPageData: this.pageData,
          newPageData: new GroupPageData<MediaItem>(this.loadVersion, newData, newBefore, newAfter, groups,
            this.params.viewMode),
          coldStartState: this.params.coldStartState,
        } as AlbumLoadingTaskResult;
      }

      // 计算出来可以复用的交集部分
      msg.push(`reusedData start: ${overlapStart - dataStart} end: ${overlapEnd - dataStart + 1}`)
      let reusedData: MediaItem[] =
        snapShot.data.slice(overlapStart - dataStart, overlapEnd - dataStart + 1) as MediaItem[];
      // 分别计算出前后缺失的部分，前面缺失部分的end减去start，加上1等于要加载的count个数。
      const missingFrontCount = (overlapStart - 1) - loadStart + 1;
      const missingBackCount = end - (overlapEnd + 1) + 1; // 后面缺失的部分的end减去start，加上1等于要加载的count个数。
      let hasMissingFront = missingFrontCount > 0, hasMissingBack = missingBackCount > 0; // 小于等于0表示没有缺失数据

      // 判断缺失的部分是否是连续的
      let loadDataStart: number | undefined = undefined, loadDataCount: number | undefined = undefined;
      msg.push(`hasMissingFront: ${hasMissingFront}, hasMissingBack: ${hasMissingBack}`);
      if (hasMissingFront && hasMissingBack) { // 前后都有缺失，则直接全量查询数据，生成新的pageData直接return
        const newData = await this.queryData(loadStart, loadCount);
        const newBefore = loadStart;
        const newAfter = total - loadStart - loadCount;
        msg.push(`query front and back, start: ${loadStart} count: ${loadCount}`);
        msg.push(`new before: ${newBefore} after: ${newAfter}`);
        return {
          info: this.info,
          oldPageData: this.pageData,
          newPageData: new GroupPageData<MediaItem>(this.loadVersion, newData, newBefore, newAfter, groups,
            this.params.viewMode),
          coldStartState: this.params.coldStartState,
        } as AlbumLoadingTaskResult;
      } else if (hasMissingFront) {
        // 只有前面缺失，加载前面的数据
        loadDataStart = loadStart;
        loadDataCount = missingFrontCount;

        // 如果存在脏数据，区间后移，覆盖脏数据范围
        let i: number = snapShot.data.length - 1;
        for (; i >= 0; i--) {
          if (snapShot.data[i]?.isInfoMissing) {
            break;
          }
        }
        loadDataCount += i + 1;
        reusedData = reusedData.splice(loadDataStart + loadDataCount - overlapStart);
      } else if (hasMissingBack) {
        // 只有后面缺失，加载后面的数据
        loadDataStart = overlapEnd + 1;
        loadDataCount = missingBackCount;

        // 如果存在脏数据，区间前移，覆盖脏数据范围
        let i: number = 0;
        for (; i < snapShot.data.length; i++) {
          if (snapShot.data[i]?.isInfoMissing) {
            break;
          }
        }
        loadDataStart = Math.max(loadDataStart - (snapShot.data.length - i), 0);
        loadDataCount += snapShot.data.length - i;
        reusedData = reusedData.splice(0, loadDataStart - overlapStart);
      } else {
        // 前后都不缺失，代表窗口完全覆盖，需要计算脏数据位置，加载x->y
        let left: number = 0, right: number = snapShot.data.length - 1;
        let isLeftDirty: boolean = false, isRightDirty: boolean = false;
        while (left <= right && !(isLeftDirty && isRightDirty)) {
          !snapShot.data[left]?.isInfoMissing ? left++ : isLeftDirty = true;
          !snapShot.data[right]?.isInfoMissing ? right-- : isRightDirty = true;
        }
        msg.push(`check dirtyItems left : ${left}  right: ${right}`);
        if (left <= right) {
          msg.push(`load dirty position: start:${snapShot.placeholdersBefore + left}, count:${right - left + 1}`);
          let loadedData: MediaItem[] = await this.queryData(snapShot.placeholdersBefore + left, right - left + 1);
          let data: MediaItem[] = snapShot.data as MediaItem[];
          for (let i = left; i <= right; i++) {
            data[i] = loadedData[i - left];
          }
          return {
            info: this.info,
            oldPageData: this.pageData,
            newPageData: new GroupPageData<MediaItem>(this.loadVersion, data, snapShot.placeholdersBefore,
              snapShot.placeholdersAfter, groups, this.params.viewMode).trim(),
            coldStartState: this.params.coldStartState,
          } as AlbumLoadingTaskResult;
        }
      }

      // 如果前后都没有缺失的部分，代表旧窗口是覆盖了新窗口，不需要load
      let loadedData: MediaItem[] = [];
      if (typeof loadDataStart === 'number' && loadDataStart >= 0 && loadDataCount) {
        msg.push(`loadDataStart: ${loadDataStart}, loadDataCount: ${loadDataCount}`);
        loadedData = await this.queryData(loadDataStart, loadDataCount);
      }

      // 拼出来新的data数组
      let newData: MediaItem[] = [];
      if (hasMissingFront) {
        // 有前面缺失的加载数据，拼接到结果中
        msg.push('concat missingFront');
        newData = newData.concat(loadedData);
      }
      newData = newData.concat(reusedData);
      if (hasMissingBack) {
        // 有后面缺失的加载数据，拼接到结果中
        msg.push(`concat missingBack ${missingFrontCount} ${missingFrontCount + missingBackCount}`);
        newData = newData.concat(loadedData);
      }

      // 计算pageData里面新的before和after
      const newBefore = loadStart, newAfter = total - loadStart - loadCount;
      msg.push(`new before: ${newBefore} after: ${newAfter}`);

      return {
        info: this.info,
        oldPageData: this.pageData,
        newPageData: new GroupPageData<MediaItem>(this.loadVersion, newData, newBefore, newAfter, groups,
          this.params.viewMode),
        coldStartState: this.params.coldStartState,
      } as AlbumLoadingTaskResult;
    }
    return this.fullyQueryData(startTime, loadStart, loadCount, cachedItems, msg, newDataCount, groups);
  }

  protected async queryData(loadStart: number, loadCount: number): Promise<MediaItem[]> {
    let result: MediaItem[] = [];
    try {
      result = await this.loadData(loadStart, loadCount);
    } catch (e) {
      Log.info(TAG, `[accurateNotify] queryData error: ${e}`);
    }
    return result;
  }

  protected async fullyQueryData(startTime: number, loadStart: number, loadCount: number,
    cachedItems: MediaItem[] | undefined, msg: string[], newDataCount: number, groups: TimelineData[] | undefined):
    Promise<AlbumLoadingTaskResult> {
    msg.push('full query items');
    let items: MediaItem[] = [];
    try {
      items = await this.loadData(loadStart, loadCount);
    } catch (e) {
      Log.info(TAG, `[accurateNotify] fullyQueryData error: ${e}`);
    }

    msg.push(`start:${loadStart}, end:${loadStart + loadCount})`, `cost: ${Date.now() - startTime}`,
      `items: ${items.length}`);
    return {
      info: this.info,
      oldPageData: this.pageData,
      newPageData: new GroupPageData<MediaItem>(this.loadVersion, items, loadStart,
        newDataCount - loadStart - items.length, groups, this.params.viewMode).trim(),
      coldStartState: this.params.coldStartState,
    } as AlbumLoadingTaskResult;
  }
}

export interface AlbumDataSourceParam {
  readonly context: Context;
  readonly albumInfo: AlbumInfo;
  readonly dataImpl?: PhotoDataImpl;
  readonly initCount?: number;
  readonly windowSize?: number;
  readonly updaterCreator?: (accurateChecker: AccurateChecker) => AlbumAccurateUpdater;
  readonly isAccurateNotify?: boolean;
  readonly classifyFromPhoto?: IClassifyFromPhoto;
}

export class AlbumDataSource extends MediaDataSource implements MediaChangeListener {
  protected readonly param: AlbumDataSourceParam;
  protected readonly context: Context;
  protected accurateChecker: AccurateChecker = {
    canAccurateUpdate: () => this.canAccurateUpdate(),
    canAccurateUpdateForCurrentAlbum: (nfyInfo: MediaObserverNfyInfo) => this.canAccurateUpdateForCurrentAlbum(nfyInfo),
  };
  protected accurateUpdater: AlbumAccurateUpdater = new AlbumAccurateUpdater(this.accurateChecker);
  protected coldStartState: ColdStartState = ColdStartState.FIRST_BATCH;
  protected groups: TimelineData[] | undefined = undefined;
  protected viewMode: GridViewMode;
  protected isAccurateUpdating: boolean = false;
  protected notifyLists: photoAccessHelper.PhotoAssetChangeInfos[] = [];
  protected isAccurateNotify: boolean = false;
  protected preloadDataIndex: number = -1;
  // 分批更新滑窗时最小更新数量
  protected updateMinCount: number = 50;

  public constructor(param: AlbumDataSourceParam) {
    super(param.windowSize ?? Constants.DEFAULT_SLIDING_WIN_SIZE,
      param.dataImpl ?? new PhotoDataImplAsync('_AlbumDataSource', param.classifyFromPhoto), true);
    this.param = param;
    this.context = param.context;
    this.tag = TAG;
    this.albumUri = param.albumInfo.uri;
    this.albumInfo = param.albumInfo;
    this.isSourceAlbum = param.albumInfo.isSourceAlbum;
    this.accurateUpdater = param.updaterCreator?.(this.accurateChecker) ?? this.accurateUpdater;
    this.isAccurateNotify = param.isAccurateNotify ?? false;
    this.createAccurateUpdater(this.albumInfo);
    this.isShootOrClassAlbum =  param.albumInfo.isShootingAlbum ||
      (param.albumInfo.subType === Constants.CITY_QUERY_SUB_TYPE);
    this.initDataTraceName = 'AlbumDataSource_init';
    this.isInInitData = true;
    this.initCount = param.initCount;
    this.viewMode = GridViewMode.GRID;
    this.addListener(this.accurateUpdater);
    Log.info(this.tag, `create AlbumDataSource for ${this.albumUri}`);
  }

  private createAccurateUpdater(albumInfo: AlbumInfo): void {
    let msg: string[] = [];
    msg.push(`AlbumDataSource constructor albumUri: ${this.albumInfo?.uri}`);
    msg.push(`subType: ${this.albumInfo?.subType}, isTimeline: ${this.albumInfo?.isTimeline}`);
    Log.info(this.tag, msg.join(`,`));

    if (Number(albumInfo.subType) === Number(photoAccessHelper.AlbumSubtype.IMAGE)) {
      this.accurateUpdater = new ImageAlbumAccurateUpdater(this.accurateChecker);
    } else if (Number(albumInfo.subType) === Number(photoAccessHelper.AlbumSubtype.VIDEO)) {
      this.accurateUpdater = new VideoAlbumAccurateUpdater(this.accurateChecker);
    } else if (Number(albumInfo.subType) === Number(photoAccessHelper.AlbumSubtype.FAVORITE)) {
      this.accurateUpdater = new FavoriteAlbumAccurateUpdater(this.accurateChecker);
    } else if (Number(albumInfo.subType) === Number(photoAccessHelper.AlbumSubtype.USER_GENERIC) ||
      Number(albumInfo.subType) === Number(photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)) {
      this.accurateUpdater = new NormalAlbumAccurateUpdater(this.accurateChecker);
    } else if (Number(albumInfo.subType) === Number(photoAccessHelper.AlbumSubtype.TRASH)) {
      this.accurateUpdater = new TrashAlbumAccurateUpdater(this.accurateChecker);
    } else if (albumInfo.isTimeline) {
      this.accurateUpdater = new TimelineAccurateUpdater(this.accurateChecker);
    } else {
      this.isAccurateNotify = false;
    }
    this.accurateUpdater.setAlbumUri(this.albumUri);
    this.accurateUpdater.albumInfo = albumInfo;
  }

  public getGroupData(): TimelineData[] {
    return (this.pageData as GroupPageData<MediaItem>)?.groups ?? [];
  }

  public initialize(): void {
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

  public releaseBroadCast(): void {
    super.releaseBroadCast();
    this.removeListener(this.accurateUpdater);
  }

  public onChange(mediaType: string, isForceUpdate?: boolean): void {
    if (mediaType === 'image' || mediaType === 'video' || mediaType === 'album') {
      Log.info(TAG, `local onChange ${mediaType}`);
      this.notifyDirty({ changeType: ChangeType.DATA, changeTypes: [mediaType] } as MediaLibChangeInfo);
    }
  }

  protected canAccurateUpdate(): boolean {
    if (this.albumInfo) {
      return UserFileManagerAccess.isImageAlbumUri(this.albumUri) ||
      UserFileManagerAccess.isVideoAlbumUri(this.albumUri) || this.albumInfo.isUserCreatedAlbum ||
      this.albumInfo.isSourceAlbum;
    }
    return false;
  }

  protected canAccurateUpdateForCurrentAlbum(nfyInfo: MediaObserverNfyInfo): boolean {
    for (let sharedAlbumAsset of nfyInfo.sharedAlbumAssets) {
      let changeAlbumUri: string =
        UserFileManagerAccess.REGISTER_TYPE_ALL_ALBUMS + `/${sharedAlbumAsset?.albumId}`;
      if (changeAlbumUri === this.albumUri) {
        Log.info(TAG, `canAccurateUpdateForCurrentAlbum ${changeAlbumUri} === ${this.albumUri}`);
        return true;
      }
    }
    return false;
  }

  public override onNotify(nfyInfo: MediaObserverNfyInfo, isForceUpdate?: boolean): void {
    if (AlbumUtils.useAccurateNotify() && this.isAccurateNotify) {
      return;
    }
    let msg: string[] = ['onNotify nfyInfo: ' + nfyInfo?.info()];
    msg.push(`isForceUpdate: ${isForceUpdate}`);
    msg.push(`shouldOptNotify: ${this.shouldOptNotify}`);
    msg.push(`isLib: ${PhotoConfig.isLibrary()}`);
    Log.info(this.tag, msg.join(', '));

    if (!this.accurateUpdater.checkNotify(nfyInfo)) {
      return;
    }

    this.notifyDirty({ changeType: ChangeType.DATA, nfyInfos: [nfyInfo] } as MediaLibChangeInfo);
  }

  public onAccurateNotify(type: string, nfyInfo: photoAccessHelper.PhotoAssetChangeInfos) {
    if (!AlbumUtils.useAccurateNotify() || !this.isAccurateNotify) {
      return;
    }
    Log.info(TAG, '[accurateNotify] common_AlbumDataSource onAccurateNotify');
    if (this.isActive) {
      this.accurateUpdater.onAccurateNotify(type, nfyInfo);
    }
    this.notifyDirty({ changeType: ChangeType.DATA } as MediaLibChangeInfo);
  }

  /* instrument ignore next */
  public updateSlidingWindow(index: number): void {
    if (!this.isValidDataIndex(index)) {
      Log.warn(this.tag, `updateSlidingWindow invalid data index: ${index}, total: ${this.pageData.size}`);
      return;
    }
    let windowCenter = Math.round((this.activeStart + this.activeEnd) / 2);
    /* instrument ignore if */
    if (Math.abs(index - windowCenter) < this.stepSize) {
      // 数据相较窗口中心的偏移值不超过一个步长时，不触发滑窗更新
      return;
    }
    /* instrument ignore if */
    // 滑窗已经对齐数据集起点/终点时不再滑动
    if (index < windowCenter && this.activeStart === 0) {
      return;
    }
    /* instrument ignore if */
    if (index > windowCenter && this.activeEnd >= this.pageData.size) {
      return;
    }

    let winStart: number = this.activeStart;
    let winEnd: number = this.activeEnd;
    if (this.windowSize >= this.pageData.size) {
      // 窗口比总量大的场景，窗口移到[0, winSize]
      winStart = 0;
      winEnd = this.windowSize;
    } else {
      // 窗口比总量小的场景，以index为中心，计算新的窗口位置，起点取值范围为[0, size - winSize]
      winStart = Math.max(0, index - Math.round(this.windowSize / 2));
      winStart = Math.min(winStart, this.pageData.size - this.windowSize);
      winEnd = winStart + this.windowSize;
    }

    // 调整滑窗，触发查询
    TraceControllerUtils.startTrace('updateSlidingWindow');
    let newData: MediaItem[] = new Array<MediaItem>(this.windowSize).fill(new MediaItem());
    for (let i = winStart; i < winEnd; i++) {
      newData[i - winStart] = this.pageData.getData(i) ?? new MediaItem();
    }
    this.items = newData;
    Log.info(this.tag, `updateSlidingWindow (${this.activeStart},${this.activeEnd}) -> (${winStart},${winEnd})`);
    this.activeStart = winStart;
    this.activeEnd = winEnd;
    // 视图切换场景当前屏幕需要显示的数据较少，滑窗一次更新的数据较多，此时会闪白屏，因此先更新一屏数据的滑窗，保证切换后的视图不闪白，然后再执行完整滑窗，预加载多屏数据
    if (this.preloadDataIndex < 0) {
      this.notifyDirty({ changeType: ChangeType.WINDOW });
    } else {
      this.batchUpdateSlidingWindow(this.preloadDataIndex);
      // 单屏数据更新完成后重置其实坐标
      this.preloadDataIndex = -1;
    }
    TraceControllerUtils.finishTrace('updateSlidingWindow');
  }

  /* instrument ignore next */
  private batchUpdateSlidingWindow(start: number): void {
    let oneScreenDataRequestTime: number = Date.now();
    let oneScreenDataCallback: AsyncCallback = {
      callback: (assets: MediaItem[], dataAlbumUri: string): void => {
        TraceControllerUtils.finishTrace('batchUpdateSlidingWindow');
        let useTime: number = Date.now() - oneScreenDataRequestTime;
        Log.info(TAG, `updateSlidingWindow ${start} time:${useTime} assets:${(assets?.length)}`);
        if (this.isInvalidData(this.albumUri, dataAlbumUri)) {
          Log.error(TAG, `updateSlidingWindow isInvalidData albumUri:${this.albumUri}, dataAlbumUri:${dataAlbumUri}`);
          return;
        }
        if (assets?.length > 0) {
          this.updateMediaData(oneScreenDataRequestTime, start, assets);
        }
        // 先更新一屏数据的滑窗，保证切换后的视图不白屏，然后再执行完整滑窗，预加载多屏数据
        this.notifyDirty({ changeType: ChangeType.WINDOW });
      }
    };
    TraceControllerUtils.startTrace('batchUpdateSlidingWindow');
    this.getBatchData(oneScreenDataCallback, start, this.updateMinCount, this.needThumbnailReady);
  }

  public override enableDaySlidingWindow(flag: boolean): void {
    this.enableDaySlidingWindowFlag = flag;
    // albumDataSource加载依赖父类，需要使用父类使能接口，mediaDataSource日落后可废弃此处逻辑
    this.enableSlidingWindow(flag);
  }

  protected onSlidingWindowChanged(winStart: number, winEnd: number): void {
    let newData: MediaItem[] = new Array<MediaItem>(this.windowSize).fill(new MediaItem());
    for (let i = winStart; i < winEnd; i++) {
      newData[i - winStart] = this.pageData.getData(i) ?? new MediaItem();
    }
    this.items = newData;
  }

  protected buildLoadingInfo(changeInfo: ChangeInfo): LoadingInfo {
    let loadingInfo: LoadingInfo = super.buildLoadingInfo(changeInfo);
    let initCount: number | undefined = this.initCount;
    this.initCount = undefined;
    return {
      start: loadingInfo.start,
      count: this.coldStartState === ColdStartState.FIRST_BATCH ? DataSourceWindowUtil.INIT_FIRST_PATCH_LOAD_COUNT :
        loadingInfo.count,
      changeInfo: changeInfo as MediaLibChangeInfo,
      albumInfo: this.albumInfo ?? new AlbumInfo(),
      needThumbnailReady: this.needThumbnailReady,
      filterMediaType: this.filterMediaType,
      initCount: initCount,
    } as AlbumLoadingInfo;
  }

  public buildLoadingTask(info: LoadingInfo): LoadingTask<MediaItem> | undefined {
    Log.info(TAG, `buildLoadingTask ${info?.start}, ${info?.count}`);
    let task: LoadingTask<MediaItem> | undefined = new AlbumLoadingTask({
      info: info,
      source: this,
      pageData: this.pageData,
      accurateUpdater: this.accurateUpdater,
      coldStartState: this.coldStartState,
      context: this.context,
      dataImpl: this.photoDataImpl,
      albumInfo: this.albumInfo ?? new AlbumInfo(),
      viewMode: this.viewMode,
    } as AlbumLoadingTaskParams);
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

  public setAlbumUri(uri: string): void {
    super.setAlbumUri(uri);
    if (this.albumInfo) {
      this.albumInfo.uri = uri;
      this.accurateUpdater.setAlbumUri(uri);
    }
  }

  protected dispatchUpdates(result: LoadingResult<MediaItem>): void {
    let loadingResult: AlbumLoadingTaskResult = result as AlbumLoadingTaskResult;
    const startTime: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('dispatchUpdates', startTime);
    let msg: string[] =
      [`dispatchUpdates ver: ${loadingResult.oldPageData.version}->${loadingResult.newPageData.version}`];
    msg.push(`size: ${loadingResult.oldPageData.size}->${loadingResult.newPageData.size}`);
    msg.push(`before: ${loadingResult.newPageData.placeholdersBefore}`);
    Log.info(this.tag, msg.join(', '));
    this.isInInitData = false;
    this.getItemCountFinish = true;
    let count: number = loadingResult.newPageData.size;
    this.groups = (loadingResult.newPageData as GroupPageData<MediaItem>)?.groups;
    this.addedCount = (this.realSize > 0) ? (count - this.realSize) : 0;
    this.realSize = count;

    this.isCountChanged = count !== this.size;
    this.isCountReduced = count < this.size;
    this.mediaCount = count;
    this.size = this.mediaCount;
    this.clearInvalidUris(result.newPageData.data);

    if (loadingResult.oldPageData.version === loadingResult.newPageData.version &&
      loadingResult.coldStartState === ColdStartState.DONE) {
      // 非数据集刷新场景，不需要通知数量/分组数据的刷新，只需要通知加载起止范围内的元素刷新
      this.updateItems(result);
    } else {
      // 数据集刷新场景，分别更新分组数据以及items，最后通知界面及相关组件刷新
      this.updateGroups();
      this.dispatchWithDataChange(result);
    }
    super.dispatchUpdates(result);

    if (this.isPendingUpdateData) {
      this.isPendingUpdateData = false;
      this.pendingUpdateData?.flush();
    }
    TraceControllerUtils.finishTraceWithTaskId('dispatchUpdates', startTime);
  }

  private updateGroups(): void {
    if (!this.groups || !this.groups.length) {
      this.offsetMediaCount = [];
      return;
    }
    const groupLength = this.groups.length;
    let groupSize = 0;
    this.offsetMediaCount = new Array(groupLength).fill(0);

    for (let groupIndex = 0; groupIndex < groupLength; groupIndex++) {
      let group = this.groups[groupIndex];
      groupSize += group.count;
      this.offsetMediaCount[groupIndex] = groupSize - 1;
    }
  }

  /**
   * 用二分法从offsetMediaCount数组中获取对应图片所在分组的index
   * 用于推导dataIndexes，groupViewIndexes，groupIndexes，dataToGroupIndexes数据
   *
   * @param index 图片的index
   * @param includeTitle 是否包含日期标题
   * @returns dataIndexes 图片所属的分组
   */
  public getGroupIndex(index: number, includeTitle?: boolean): number {
    let left = 0;
    let right = this.offsetMediaCount.length;

    while (left < right) {
      const mid = left + Math.floor((right - left) / 2);
      const mediaCount = includeTitle ? this.offsetMediaCount[mid] + mid + 1 : this.offsetMediaCount[mid];
      if (mediaCount < index) {
        left = mid + 1;
      } else {
        right = mid;
      }
    }

    return left < this.offsetMediaCount.length ? left : -1;
  }

  /**
   * 获取图片在对应分组中的index
   *
   * @param index 图片的index
   * @returns dataIndexes 图片在对应分组中的位置
   */
  public getDataIndexes(index: number): number {
    const getIndex = this.getGroupIndex(index, true);
    // 判断是否为日期标题，日期标题返回-1
    // 图片index - （所在分组 + 之前所有分组的图片数量 + 1）- 1
    // offsetMediaCount的计算在updateGroups()中
    if (
      getIndex > 0 &&
        index - (getIndex + this.offsetMediaCount[getIndex - 1] + 1) - 1 === -1
    ) {
      return -1;
    }

    const dataIndex = index - getIndex - 1;
    return dataIndex;
  }

  /**
   * 获取图片的groupViewIndexes
   *
   * @param index 图片的index
   * @returns groupViewIndexes 图片的groupViewIndexes
   */
  public findGroupViewIndexes(index: number): number {
    const getIndex = this.getGroupIndex(index, true);

    if (getIndex === 0) {
      return index - 1
    }

    const viewIndex = index - (getIndex + this.offsetMediaCount[getIndex - 1] + 1) - 1;
    return viewIndex;
  }

  /**
   * 获取图片对应分组的index，包含日期标题
   *
   * @param index 图片的index
   * @returns groupIndexes 图片对应分组的位置（包含日期标题）
   */
  public timeGroupIndexes(index: number): number {
    return this.getGroupIndex(index, true);
  }

  /**
   * 获取图片对应分组的index，不包含日期标题
   *
   * @param dataIndex 图片的index
   * @returns dataToGroupIndexes 图片对应分组的位置（不包含日期标题）
   */
  public getGroupIndexByDataIndex(dataIndex: number): number {
    return this.getGroupIndex(dataIndex);
  }

  protected updateItems(loadingResult: LoadingResult<MediaItem>): void {
    for (let i: number = 0; i < loadingResult.info.count; i++) {
      let dataIndex: number = i + loadingResult.info.start;
      if (dataIndex >= this.activeStart && dataIndex < this.activeEnd) {
        this.items[dataIndex - this.activeStart] = loadingResult.newPageData.getData(dataIndex) ?? new MediaItem();
      }
    }
  }

  protected dispatchWithDataChange(loadingResult: LoadingResult<MediaItem>): void {
    this.adjustSlidingWindow(loadingResult);
    this.updateItems(loadingResult);
    this.validEndIndex = loadingResult.newPageData.placeholdersBefore + loadingResult.newPageData.data.length - 1;
    this.refreshPreviewItems(loadingResult);
    this.dispatchCallbacks(loadingResult);
  }

  private refreshPreviewItems(loadingResult: LoadingResult<MediaItem>): void {
    if (loadingResult.newPageData.placeholdersBefore !== 0) {
      return;
    }
    let previewNum: number = DeviceInfo.getFirstPatchNum();
    this.previewItems = new Array(Math.min(loadingResult.newPageData.size, previewNum));
    for (let i = 0; i < this.previewItems.length; i++) {
      this.previewItems[i] = loadingResult.newPageData.getData(i) ?? new MediaItem();
    }
  }

  protected adjustSlidingWindow(loadingResult: LoadingResult<MediaItem>): void {
    // 按需调整滑窗位置，返回是否更新了滑窗
    let newDataCount: number = loadingResult.newPageData.size;
    let newStart: number = 0;
    let newEnd: number = 0;
    if (newDataCount <= this.windowSize) {
      newEnd = this.windowSize;
      newStart = 0;
    } else {
      newEnd = Math.min(this.activeEnd, newDataCount);
      newStart = newEnd - this.windowSize;
    }

    // 窗口不变不需要进一步调整
    if (newStart === this.activeStart && newEnd === this.activeEnd) {
      return;
    }
    this.items = new Array(newEnd - newStart).fill(new MediaItem());
  }

  protected dispatchCallbacks(loadingResult: LoadingResult<MediaItem>): void {
    this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')?.(this.mediaCount);
    this.mCallbacks.has('updateGroupData') && this.mCallbacks.get('updateGroupData')?.(this.groups);

    this.broadCast?.emit(Constants.ON_LOADING_FINISHED, [this.mediaCount]);
    this.notifySizeLoadingFinished(this.mediaCount);
    Log.info(this.tag, `dispatchCallbacks isCountChanged: ${this.isCountChanged}`);
    this.photosBroadCast?.emit(BroadCastConstants.ON_DATA_RELOADED, [this.addedCount]);
    this.broadCast?.emit(BroadCastConstants.ON_DATA_RELOADED, []);
    this.isCountChanged = false;
    this.isCountReduced = false;
    if (this.isEditSaveReload && this.addedCount >= 0) {
      this.photosBroadCast?.emit(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, []);
    } else {
      this.notifyDataLoadingFinished();
    }
    this.addedCount = 0;
  }

  /**
   * 设置激活状态
   */
  public onActive(): void {
    Log.info(this.tag, 'onActive');
    this.resume();
  }

  public async changeWindow(dataWindow: DataWindow): Promise<void> {
    if (!this.isActive) {
      return;
    }
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
      this.notifyDirty({ changeType: ChangeType.WINDOW });
    }
  }

  public setNeedFullQueryCount(needFullQueryCount: boolean): void {
  }

  public getGroupCountBeforeItem(item: MediaItem | undefined): number {
    if (!item || this.viewMode === GridViewMode.GRID) {
      return 0;
    }
    let groupCount = 0;
    let itemTime: number = item.getDateTaken();
    Log.info(TAG, `updateIndex: itemTime ${itemTime}`)
    if (!this.groups) {
      return groupCount;
    }
    for (let index = 0; index < this.groups.length; index++) {
      const group: TimelineData = this.groups[index];
      if (DateUtil.isTheSameDay(itemTime, group.startDate as number)) {
        groupCount = index + 1;
        break;
      }
    }
    return groupCount;
  }

  public setViewMode(mode: GridViewMode): void {
    if (this.viewMode === mode) {
      return;
    }
    Log.info(this.tag, `setViewMode ${mode}`);
    this.viewMode = mode;
    if (this.accurateUpdater instanceof AlbumAccurateUpdater) {
      this.accurateUpdater.gridViewMode = mode;
    }

    // 重置滑窗以及冷启状态，以快速加载首屏数据
    this.coldStartState = ColdStartState.FIRST_BATCH;
    this.activeStart = 0;
    this.activeEnd = this.windowSize;
    this.items = new Array(this.windowSize);
    this.notifyDirty();
  }

  public dataToLayout(index: number): number {
    if (this.viewMode === GridViewMode.GRID) {
      return index;
    }
    let layoutIndex = this.dataToLayoutInGroup(index);
    return layoutIndex;
  }

  public layoutToData(index: number): number {
    if (this.viewMode === GridViewMode.GRID) {
      return index;
    }
    return index - this.timeGroupIndexes(index) - 1;
  }

  /**
   * 分组模式下数据index转为布局Index
   * @param index
   * @returns
   */
  public dataToLayoutInGroup(index: number): number {
    const getIndex = this.getGroupIndexByDataIndex(index);
    if (getIndex < 0) {
      return index;
    }
    return getIndex + index + 1;
  }

  public computeMaxGridOffset(imageGridHeight: number, timeTitleHeight: number, gridColCnt: number): number {
    if (!this.groups) {
      return -1;
    }
    let gutter: number = DeviceInfo.isPc() ? Constants.PC_GRID_GUTTER : Constants.GRID_GUTTER;
    let imageGridItemHeight: number = imageGridHeight + gutter;
    let timelineTitleHeight: number = timeTitleHeight + gutter;
    let groupLength: number = this.groups.length;
    let groupGlobalOffsetLength: number = this.groupGlobalOffsets.length;
    let maxOffset: number = 0;
    if (groupLength == 0) {
      return maxOffset;
    }
    let lastGroupCnt = this.groups[groupLength - 1].count as number;
    let lastGroupOffset = Math.ceil(lastGroupCnt / gridColCnt) * imageGridItemHeight + timelineTitleHeight;
    maxOffset = lastGroupOffset + this.groupGlobalOffsets[groupGlobalOffsetLength - 1] - gutter;
    return maxOffset;
  }

  public computeStartIndexWithMassage(offset: number, imageGridHeight: number, timeTitleHeight: number,
    gridColCnt: number): number {
    let startIndex = this.computeStartIndex(offset, imageGridHeight, timeTitleHeight, gridColCnt);
    startIndex -= (Constants.DRAG_OFFSET_COUNT * gridColCnt);
    let startIndexWithMassage = startIndex < 0 ? 0 : startIndex;
    return startIndexWithMassage;
  }

  // 计算开始索引
  public computeStartIndex(offset: number, imageGridHeight: number, timeTitleHeight: number,
    gridColCnt: number): number {
    let imageGridItemHeight: number = imageGridHeight + Constants.GRID_GUTTER;
    let timelineHeight: number = timeTitleHeight + Constants.GRID_GUTTER;
    if (offset <= 0) {
      return 0;
    }
    let currentHeight: number = 0;
    let groupIndex: number = 0;
    let targetIndex: number = 0;
    let groupGlobalLength = this.groupGlobalOffsets.length as number;
    let groupGlobalOffset = this.groupGlobalOffsets[groupGlobalLength - 1] as number;
    if (offset > groupGlobalOffset) {
      currentHeight = groupGlobalOffset + timelineHeight;
      targetIndex = this.groupGlobalIndex[groupGlobalLength - 1] as number;
    } else {
      currentHeight = this.groupGlobalOffsets.find(globalOffset => globalOffset >= offset) as number;
      groupIndex = this.groupGlobalOffsets.findIndex(globalOffset => globalOffset >= offset) as number;
      // 防止数据加载时，访问数组越界
      if (groupIndex === 0) {
        return 0;
      }
      let groupCnt: number = (this.indexesToGroup(groupIndex - 1) as TimelineData)?.count;
      currentHeight -= Math.ceil(groupCnt / gridColCnt) * imageGridItemHeight;
      targetIndex = this.groupGlobalIndex[groupIndex - 1];
    }
    if (currentHeight <= offset) {
      targetIndex++;
      let gapRow: number = Math.floor((offset - currentHeight) / imageGridItemHeight);
      targetIndex += gapRow * gridColCnt;
    }
    return targetIndex;
  }

  public computeGroupGlobalOffset(imageGridHeight: number, timeTitleHeight: number, gridColCnt: number): void {
    if (!this.groups) {
      Log.error(TAG, `computeGroupGlobalOffset groups empty`);
      return;
    }
    Log.info(TAG, `computeGroupGlobalOffset start ${gridColCnt}, ${this.groups?.length}`);
    let gutter: number = DeviceInfo.isPc() ? Constants.PC_GRID_GUTTER : Constants.GRID_GUTTER;
    let imageGridItemHeight: number = imageGridHeight + gutter;
    let timelineTitleHeight: number = timeTitleHeight + gutter;
    let groupLength: number = this.groups.length;
    let currentTitleIndex = 1;
    this.groupGlobalOffsets = [];
    this.groupGlobalIndex = [];
    this.groupGlobalOffsets.push(0);
    this.groupGlobalIndex.push(currentTitleIndex);
    for (let groupIndex = 0; groupIndex < groupLength - 1; groupIndex++) {
      let groupCount = this.groups[groupIndex].count as number;
      currentTitleIndex = currentTitleIndex + this.groups[groupIndex].count + 1;
      this.groupGlobalIndex.push(currentTitleIndex);
      let groupRow = Math.ceil(groupCount / gridColCnt);
      let groupOffset = groupRow * imageGridItemHeight + timelineTitleHeight;
      let groupGlobalOffset = groupOffset + this.groupGlobalOffsets[groupIndex];
      this.groupGlobalOffsets.push(groupGlobalOffset);
    }
    Log.info(TAG, `computeGroupGlobalOffset end`);
  }

  // 每组的分组数量
  public indexesToGroup(index: number): TimelineData | undefined {
    if (!this.groups) {
      Log.error(TAG, `indexesToGroup groups empty`);
      return undefined;
    }
    return this.groups[index];
  }

  public recordSimpleMediaItem(index: number, item: SimpleGridMediaItem, useNewPhoto?: boolean): void {
    if (index < 0 || item === null) {
      return;
    }

    this.simpleMediaItems?.put(useNewPhoto ? index : this.layoutToData(index), item);
  }

  /**
   * Get query param of data source.
   *
   * @param start Query start.
   * @param count Query count.
   * @returns Query param.
   */
  public getQueryParam(start: number, count: number): QueryParam {
    let orderBy: string;
    if (this.viewMode === GridViewMode.GROUP) {
      orderBy = UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString();
    } else {
      const albumKey: string = AlbumGridSortHelper.getAlbumKeyByAlbumInfo(this.albumInfo);
      orderBy = AlbumGridSortHelper.getOrderPropByAlbumUri(this.albumUri, albumKey);
    }
    return {
      albumUri: this.albumUri,
      start: start,
      count: count,
      filterMediaType: this.filterMediaType,
      orderBy: orderBy
    };
  }

  /**
   * 设置过滤位置
   *
   * @param positionFilter 位置
   */
  public setPositionFilter(positionFilter: PositionFilter | undefined): void {
    let dataImpl: PhotoDataImpl | undefined = this.photoDataImpl as PhotoDataImpl;
    let oldPosition: number | undefined = dataImpl.positionFilter;
    dataImpl.positionFilter = positionFilter;
    Log.info(this.tag, `positionFilter ${oldPosition} -> ${dataImpl.positionFilter}`);
    setTimeout(() => this.notifyDirty());
  }

  /**
   * 设置分批更新滑窗起始Index
   *
   * @param startIndex 更新滑窗起始Index
   */
  public setPreloadStartIndex(startIndex: number) {
    this.preloadDataIndex = startIndex;
  }
}

