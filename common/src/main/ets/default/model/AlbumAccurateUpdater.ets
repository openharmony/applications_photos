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
import lazy { AccurateUpdater } from './AccurateUpdater';
import lazy { MediaObserverNfyInfo, MediaObserverNfyType } from './browser/dataObserver/MediaObserverCallback';
import lazy { MediaItem } from './browser/photo/MediaItem';
import lazy { Log } from '../utils/Log';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { CachedData, AccurateUpdaterUtils } from './AccurateUpdaterUtils';
import lazy { TimelineData } from './browser/photo/TimelineData';
import lazy { LoadingResult } from './DataSource';
import lazy { PhotoAssetChangeInfos, PhotoAssetChangeInfo, MediaObserver, PhotoAssetChangeData }
  from './browser/dataObserver/MediaObserver';
import lazy { AlbumInfo } from './browser/album/AlbumInfo';
import lazy { AlbumGridSortHelper, SortRuleString } from './AlbumGridSortHelper';
import lazy { UserFileData } from './UserFileData';
import lazy { GridViewMode } from '../view/grid/GridView';
import lazy { GroupPageData } from './AlbumDataSource';

const TAG: string = 'common_AlbumAccurateUpdater';

export interface AccurateChecker {
  canAccurateUpdate: () => boolean;
  canAccurateUpdateForCurrentAlbum: (nfyInfo: MediaObserverNfyInfo) => boolean;
}

/**
 * 提供精准通知在进行滑窗判断及二分位置等场景获取比较值的接口
 */
export interface OrderStrategy {
  getItemValue(item: MediaItem): number;
  getNfyValue(changeInfo: PhotoAssetChangeInfo): number;
  getItemName?(item: MediaItem): string;
  getNfyName?(changeInfo: PhotoAssetChangeInfo): string;
  isDesc: boolean;
  isString?: boolean;
}

export class DataAddedOrderStrategy implements OrderStrategy {
  public isDesc: boolean;

  constructor(isDesc: boolean) {
    this.isDesc = isDesc;
  }

  public getItemValue(item: MediaItem): number {
    return item?.getDateAdded() ?? 0;
  }

  public getNfyValue(changeInfo: PhotoAssetChangeInfo): number {
    return changeInfo.dateAddedMs ?? 0;
  }
}

export class DataTakenOrderStrategy implements OrderStrategy {
  public isDesc: boolean;

  constructor(isDesc: boolean) {
    this.isDesc = isDesc;
  }

  public getItemValue(item: MediaItem): number {
    return item?.dateTaken ?? 0;
  }

  public getNfyValue(changeInfo: PhotoAssetChangeInfo): number {
    return changeInfo.dateTakenMs ?? 0;
  }
}

export class FileSizeOrderStrategy implements OrderStrategy {
  public isDesc: boolean;

  constructor(isDesc: boolean) {
    this.isDesc = isDesc;
  }

  public getItemValue(item: MediaItem): number {
    return item?.size ?? 0;
  }

  public getNfyValue(changeInfo: PhotoAssetChangeInfo): number {
    return changeInfo.size ?? 0;
  }
}

export class DisplayNameOrderStrategy implements OrderStrategy {
  public isDesc: boolean;
  public isString?: boolean | undefined;

  constructor(isDesc: boolean, isString?: boolean) {
    this.isDesc = isDesc;
    this.isString = isString;
  }

  public getItemValue(item: MediaItem): number {
    return 0;
  }

  public getNfyValue(changeInfo: PhotoAssetChangeInfo): number {
    return 0;
  }

  public getItemName(item: MediaItem): string {
    return item?.displayName ?? '';
  }

  public getNfyName(changeInfo: PhotoAssetChangeInfo): string {
    return changeInfo.displayName ?? '';
  }
}

/**
 * 增量更新器，相册宫格实现
 */
export class AlbumAccurateUpdater extends AccurateUpdater<MediaItem> {
  public albumInfo: AlbumInfo = new AlbumInfo();
  public gridViewMode: GridViewMode = GridViewMode.GRID;
  public isDirty: boolean = true;
  public shouldHandleType: string = MediaObserver.REGISTER_PHOTO_CHANGE;
  protected isSuccess: boolean = true;
  protected albumUri: string = '';
  protected _tag: string = 'AlbumAccurateUpdater';
  private accurateChecker: AccurateChecker | undefined = undefined;

  public constructor(accurateChecker: AccurateChecker | undefined) {
    super();
    this.accurateChecker = accurateChecker;
  }

  public onAccurateNotify(type: string, nfyInfo: PhotoAssetChangeInfos): void {
    Log.info(this.tag, `[accurateNotify] onAccurateNotify, type: ${nfyInfo.type}, notify from: ${type},
      changeData length: ${nfyInfo.assetChangeDatas?.length} isForRecheck: ${nfyInfo.isForRecheck}`);
    Log.info(this.tag, `[accurateNotify] ${this.albumInfo}`);
    this.isDirty = true;
    if (nfyInfo.assetChangeDatas === null) {
      return;
    }

    let orderStrategy: OrderStrategy = this.getTargetStrategy();

    if (!this.shouldProcessNotification(type, this.shouldHandleType, nfyInfo)) {
      Log.info(this.tag, `[accurateNotify] shouldProcessNotification: false`);
      return;
    }

    if (!this.data) {
      Log.info(this.tag, `[accurateNotify] dataInner: undefined`);
      return; // 没有可用的pageData，直接标脏return
    }

    let cachedData: CachedData = {
      placeholdersBefore: this.data.placeholdersBefore,
      placeholdersAfter: this.data.placeholdersAfter,
      data: this.data.data as MediaItem[],
      groups: (this.data as GroupPageData<MediaItem>)?.groups,
    };

    if (nfyInfo.type === photoAccessHelper.NotifyChangeType.NOTIFY_CHANGE_REMOVE) {
      for (let info of nfyInfo.assetChangeDatas) {
        Log.info(this.tag, `[accurateNotify] ${info}`);
        if (info.assetBeforeChange === null || !this.isSuccess) {
          return;
        }
        this.handleRemove(info.assetBeforeChange, cachedData, orderStrategy);
      }
    } else if (nfyInfo.type === photoAccessHelper.NotifyChangeType.NOTIFY_CHANGE_ADD) {
      for (let info of nfyInfo.assetChangeDatas) {
        Log.info(this.tag, `[accurateNotify] ${info}`);
        if (info.assetAfterChange === null || !this.isSuccess) {
          return;
        }
        this.handleAdd(info.assetAfterChange, cachedData, orderStrategy);
        Log.info(this.tag, `[accurateNotify] dateDay : ${info.assetAfterChange.dateDay}`);
      }
    } else {
      for (let info of nfyInfo.assetChangeDatas) {
        Log.info(this.tag, `[accurateNotify] ${info}`);
        if (!this.isSuccess || this.checkOrderDataChanged(info)) {
          return;
        }
        this.handleUpdate(info, cachedData, orderStrategy);
      }
    }
    this.data = new GroupPageData(this.data.version, cachedData.data, cachedData.placeholdersBefore,
      cachedData.placeholdersAfter, cachedData.groups);
    this.isDirty = false;
    Log.info(this.tag, `[accurateNotify] before: ${cachedData.placeholdersBefore}
      after: ${cachedData.placeholdersAfter} data:${cachedData.data.length}, groups: ${cachedData.groups?.length}`);
  }

  private checkOrderDataChanged(asset: PhotoAssetChangeData): boolean {
    if (asset.assetBeforeChange === null || asset.assetAfterChange === null) {
      return true;
    }
    const before: PhotoAssetChangeInfo = asset.assetBeforeChange;
    const after: PhotoAssetChangeInfo = asset.assetAfterChange;
    if (before.dateTakenMs !== after.dateTakenMs || before.dateAddedMs !== after.dateAddedMs ||
      before?.size !== after?.size || before?.displayName !== after?.displayName ||
      before.dateTrashedMs !== after.dateTrashedMs) {
      Log.info(this.tag, `order info changed, should fully query data.`);
      this.isSuccess = false;
      return true;
    }
    return false;
  }

  public onLoadingFinished(result: LoadingResult<MediaItem>): void {
    this.data = (result.newPageData as GroupPageData<MediaItem>).copy();
    this.isDirty = true;
    this.isSuccess = true;
    let msg: string[] = [];
    msg.push(`[accurateNotify] onLoadingFinished ${this.data.placeholdersBefore}`);
    msg.push(`${this.data.data.length} ${this.data.placeholdersAfter}.`);
    Log.info(TAG, msg.join(`,`));
  }

  public getTargetStrategy(): OrderStrategy {
    const albumKey: string = AlbumGridSortHelper.getAlbumKeyByAlbumInfo(this.albumInfo);
    const orderBy: string = AlbumGridSortHelper.getOrderPropByAlbumUri(this.albumInfo?.uri ?? '', albumKey);
    const isDesc: boolean =
      AlbumGridSortHelper.getInstance().getSortRule(this.tag, albumKey ?? '')?.type === SortRuleString.DESC;
    Log.info(this.tag, `[accurateNotify] orderBy: ${orderBy}, isDesc: ${isDesc}, gridViewMode: ${this.gridViewMode}`);
    let orderStrategy: OrderStrategy = new DataTakenOrderStrategy(true);
    if (Number(this.gridViewMode) === Number(GridViewMode.GROUP)) {
      return orderStrategy;
    } else if (orderBy === UserFileData.FILE_KEY_DATE_ADDED.toString()) {
      orderStrategy = new DataAddedOrderStrategy(isDesc);
    } else if (orderBy === UserFileData.FILE_KEY_DATE_TAKEN_MS.toString()) {
      orderStrategy = new DataTakenOrderStrategy(isDesc);
    } else if (orderBy === UserFileData.FILE_KEY_DISPLAY_NAME.toString()) {
      this.isSuccess = false; // 按照文件名排序，暂不能实现精准刷新
    } else if (orderBy === UserFileData.FILE_KEY_SIZE.toString()) {
      orderStrategy = new FileSizeOrderStrategy(isDesc);
    }
    return orderStrategy;
  }

  public getTotalCount(): number {
    return (this.data?.placeholdersBefore ?? 0) + (this.data?.placeholdersAfter ?? 0) + (this.data?.data.length ?? 0);
  }

  public handleAdd(info: PhotoAssetChangeInfo, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    this.handlePhotoAdd(info, cachedData, orderStrategy);
  }

  public handleRemove(info: PhotoAssetChangeInfo, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    this.handlePhotoRemove(info, cachedData, orderStrategy);
  }

  public handleUpdate(changeData: PhotoAssetChangeData, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    if (changeData.assetAfterChange === null) {
      return;
    }
    this.handlePhotoUpdate(changeData.assetAfterChange, cachedData, orderStrategy);
  }

  protected shouldProcessNotification(type: string, targetType: string, nfyInfo: PhotoAssetChangeInfos): boolean {
    if (type !== targetType) {
      // 非目标通知时，不用做增量更新
      Log.info(this.tag, `[accurateNotify] shouldProcessNotification: type`);
      return false;
    }

    if (nfyInfo.isForRecheck) {
      Log.info(this.tag, `[accurateNotify] shouldProcessNotification: recheck`);
      return false;
    }

    if (!nfyInfo.assetChangeDatas?.length || !this.data?.data.length) {
      Log.info(this.tag, `[accurateNotify] shouldProcessNotification:${nfyInfo.assetChangeDatas?.length}
        ${this.data?.data.length}`);
      return false;
    }

    return true;
  }

  /**
   * 获取标记
   *
   * @returns 标记
   */
  public get tag(): string {
    return this._tag;
  }

  public shouldQueryCount(): boolean {
    Log.info(this.tag, `[accurateNotify] shouldQueryCount: ${this.isDirty}`);
    return !this.isSuccess || this.isDirty;
  }

  public shouldQueryData(): boolean {
    return !this.isSuccess || this.isDirty;
  }

  public handlePhotoAdd(info: PhotoAssetChangeInfo, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    Log.info(this.tag, `[accurateNotify] handlePhotoAdd ${this.checkIsBeforeWindow(info, cachedData, orderStrategy)}
      ${this.checkIsAfterWindow(info, cachedData, orderStrategy)}`);
    if (this.checkIsBeforeWindow(info, cachedData, orderStrategy)) {
      cachedData.placeholdersBefore++;
    } else if (this.checkIsAfterWindow(info, cachedData, orderStrategy)) {
      cachedData.placeholdersAfter++;
    } else {
      let mediaItem: MediaItem = new MediaItem();
      mediaItem.uri = info.uri;
      mediaItem.dateTaken = info.dateTakenMs;
      mediaItem.size = info.size ?? 0;
      mediaItem.displayName = info.displayName ?? '';
      mediaItem.dateTrashed = info.dateTrashedMs;
      mediaItem.setDateAdded(info.dateAddedMs);
      mediaItem.isInfoMissing = true;
      let insertIndex = AccurateUpdaterUtils.insertMediaItem(mediaItem, orderStrategy, cachedData.data);
      Log.info(TAG, `[accurateNotify] insertIndex: ${insertIndex}`);
      if (insertIndex === -1) {
        Log.error(TAG, `[accurateNotify] insertIndex error`);
        this.isSuccess = false;
      }
      cachedData.data.splice(insertIndex, 0, mediaItem);
    }
    this.updateGroups(photoAccessHelper.NotifyChangeType.NOTIFY_CHANGE_ADD, info, cachedData.groups);
  }

  public handlePhotoRemove(info: PhotoAssetChangeInfo, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    Log.info(this.tag, '[accurateNotify] handlePhotoRemove');
    if (this.checkIsBeforeWindow(info, cachedData, orderStrategy)) {
      cachedData.placeholdersBefore--;
    } else if (this.checkIsAfterWindow(info, cachedData, orderStrategy)) {
      cachedData.placeholdersAfter--;
    } else {
      let index: number = AccurateUpdaterUtils.findMediaItemIndex(info, orderStrategy, cachedData.data);
      Log.info(this.tag, `[accurateNotify] handlePhotoRemove index is: ${index}`);
      Log.info(this.tag, '[accurateNotify] getNfyValue ' + orderStrategy.getNfyValue(info));
      if (index !== -1) {
        cachedData.data.splice(index, 1);
      } else {
        this.isSuccess = false;
      }
    }
    this.updateGroups(photoAccessHelper.NotifyChangeType.NOTIFY_CHANGE_REMOVE, info, cachedData.groups);
  }

  public handlePhotoUpdate(info: PhotoAssetChangeInfo, cachedData: CachedData,
    orderStrategy: OrderStrategy): void {
    Log.info(this.tag, '[accurateNotify] handlePhotoUpdate');
    if (!this.checkIsBeforeWindow(info, cachedData, orderStrategy) &&
      !this.checkIsAfterWindow(info, cachedData, orderStrategy)) {
      let index: number = AccurateUpdaterUtils.findMediaItemIndex(info, orderStrategy, cachedData.data);
      Log.info(this.tag, `[accurateNotify] handlePhotoUpdate index is: ${index}`);
      if (0 <= index && index < cachedData.data.length) {
        cachedData.data[index].isInfoMissing = true;
      }
    }
  }

  private checkIsBeforeWindow(info: PhotoAssetChangeInfo, cachedData: CachedData,
    orderStrategy: OrderStrategy): boolean {
    if (!cachedData.data.length) {
      return true;
    }
    Log.info(this.tag, `[accurateNotify] checkBefore bool ${orderStrategy.isString},
      ${orderStrategy instanceof DisplayNameOrderStrategy}`);
    Log.info(this.tag, `[accurateNotify] checkBefore value ${orderStrategy.getNfyValue(info)}
      ${orderStrategy.getItemValue(cachedData.data[0])}`);
    if (orderStrategy.isString && orderStrategy instanceof DisplayNameOrderStrategy) {
      return orderStrategy.isDesc ?
        orderStrategy.getNfyName(info).localeCompare(orderStrategy.getItemName(cachedData.data[0])) > 0 :
        orderStrategy.getNfyName(info).localeCompare(orderStrategy.getItemName(cachedData.data[0])) < 0;
    }
    return orderStrategy.isDesc ?
      orderStrategy.getNfyValue(info) > orderStrategy.getItemValue(cachedData.data[0]) :
      orderStrategy.getNfyValue(info) < orderStrategy.getItemValue(cachedData.data[0]);
  }

  private checkIsAfterWindow(info: PhotoAssetChangeInfo, cachedData: CachedData,
    orderStrategy: OrderStrategy): boolean {
    if (!cachedData.data.length) {
      return true;
    }
    const end = cachedData.data.length - 1;
    Log.info(this.tag, `[accurateNotify] checkAfter value ${orderStrategy.getNfyValue(info)}
      ${orderStrategy.getItemValue(cachedData.data[end])}`);
    Log.info(this.tag, `[accurateNotify] checkAfter bool ${orderStrategy.isString},
      ${orderStrategy instanceof DisplayNameOrderStrategy}`);
    if (orderStrategy.isString && orderStrategy instanceof DisplayNameOrderStrategy) {
      return orderStrategy.isDesc ?
        orderStrategy.getNfyName(info).localeCompare(orderStrategy.getItemName(cachedData.data[end])) < 0 :
        orderStrategy.getNfyName(info).localeCompare(orderStrategy.getItemName(cachedData.data[end])) > 0;
    }
    return orderStrategy.isDesc ?
      orderStrategy.getNfyValue(info) < orderStrategy.getItemValue(cachedData.data[end]) :
      orderStrategy.getNfyValue(info) > orderStrategy.getItemValue(cachedData.data[end]);
  }

  public updateGroups(type: photoAccessHelper.NotifyChangeType, info: PhotoAssetChangeInfo,
    groups?: TimelineData[]): void {
    if (!groups || !(info?.dateDay?.length)) {
      Log.error(this.tag, `updateGroups error, info ${info?.dateDay}`);
      this.isSuccess = false;
      return;
    }
    const existingGroupIndex = groups.findIndex(group => group.getDateDayStr() === info.dateDay);
    const existingGroup = existingGroupIndex !== -1;
    Log.info(this._tag, `dateDay:${info.dateDay},groupIndex:${existingGroupIndex},exist:${existingGroup}`);

    if (existingGroup && type === photoAccessHelper.NotifyChangeType.NOTIFY_CHANGE_ADD) {
      // 如果对应的dateDay存在并且是新增，根据dateTaken，更新start和end，然后count+1
      const group = groups[existingGroupIndex];
      if (info.dateTakenMs < group.startDate) {
        group.startDate = info.dateTakenMs;
      }
      if (info.dateTakenMs > group.endDate) {
        group.endDate = info.dateTakenMs;
      }
      group.count++;
    } else if (type === photoAccessHelper.NotifyChangeType.NOTIFY_CHANGE_ADD && !existingGroup) {
      // 如果对应的dateDay不存在并且是新增，根据dateDay的顺序，插入一条新的TimelineData，并且更新start和end，然后count+1
      let newGroup: TimelineData = new TimelineData(info.dateTakenMs, info.dateTakenMs, 1, info.dateDay);
      // 根据dateDay的顺序插入到groups中
      let insertIndex = 0;
      while (insertIndex < groups.length && (groups[insertIndex]?.dateDay ?? '') > (newGroup.dateDay ?? '')) {
        insertIndex++;
      }
      groups.splice(insertIndex, 0, newGroup);
    } else if (existingGroup && type === photoAccessHelper.NotifyChangeType.NOTIFY_CHANGE_REMOVE) {
      // 如果对应的dateDay存在并且是删除，根据dateTaken，更新start和end，然后count-1
      const group = groups[existingGroupIndex];
      group.count--;
      if (!group.count) {
        groups.splice(existingGroupIndex, 1);
      }
    }
  }

  public onNotify(nfyInfo: MediaObserverNfyInfo): void {
    if (!this.accurateChecker?.canAccurateUpdate()) {
      return;
    }

    if (this.shouldQueryCount()) {
      // count已脏，不能进行增量更新
      return;
    }
  }

  public checkNotify(nfyInfo: MediaObserverNfyInfo): boolean {
    if (!this.accurateChecker?.canAccurateUpdate()) {
      this.isCountDirty = true;
      return true;
    }

    this.updateNotifyCountStatus(nfyInfo);
    let isInvalidNotify: boolean = !this.isCountDirty &&
      !this.accurateChecker?.canAccurateUpdateForCurrentAlbum(nfyInfo);
    if (isInvalidNotify) {
      Log.info(this.tag, 'The current album is not included in this nfyInfo');
      return false;
    }

    // 针对端云场景的Album_ADD通知刷新
    if (nfyInfo.type === MediaObserverNfyType.ALBUM_ADD) {
      Log.info(this.tag, 'MediaDataSource handle ALBUM_ADD Notify, loadData will change count');
      return true;
    }

    return true;
  }

  private isInfoValidForUpdateOtherAlbumCount(nfyInfo: MediaObserverNfyInfo): boolean {
    let nfyInfoType: number = nfyInfo.type;
    // Album类通知，同时保证shared的AlbumAssets和ExtraPhotoAssets>0，并判断changeData_type为3、4
    if (nfyInfoType !== MediaObserverNfyType.ALBUM_ADD || !nfyInfo.sharedAlbumAssets?.length) {
      return true;
    }
    return false;
  }

  private updateNotifyCountStatus(nfyInfo: MediaObserverNfyInfo): void {
    this.isCountDirty = this.isInfoValidForUpdateOtherAlbumCount(nfyInfo);
    Log.debug(this.tag, `AlbumDataSource updateNotifyCountStatus this.isCountDirty = ${this.isCountDirty}`);
  }

  public setAlbumUri(albumUri: string): void {
    this.albumUri = albumUri;
    Log.info(this.tag, `accurateUpater setAlbumUri: ${this.albumUri}`);
  }
}