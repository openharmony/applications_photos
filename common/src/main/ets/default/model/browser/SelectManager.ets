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

import type { TimelineData } from './photo/TimelineData';
import lazy { Log } from '../../utils/Log';
import type { MediaItem } from './photo/MediaItem';
import type { AsyncCallback } from '../common/AsyncCallback';
import lazy { BrowserDataFactory } from '../../interface/BrowserDataFactory';
import type { BrowserDataInterface, QueryParam } from '../../interface/BrowserDataInterface';
import lazy { FetchType } from '../../interface/BrowserDataInterface';
import lazy { Constants, SelectMediaType } from '../common/Constants';
import lazy { BigDataConstants, ReportToBigDataUtil, PhotoInfo } from '../../utils/ReportToBigDataUtil';
import lazy { PhotoDataImpl } from './photo/PhotoDataImpl';
import lazy HashMap from '@ohos.util.HashMap';
import type { PhotoAsset } from '../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess, toString } from '../../access/UserFileManagerAccess';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import type { SelectParams } from '../common/SelectParams';
import type { MediaDataSource } from './photo/MediaDataSource';
import lazy { HeadTailPosition, PositionInfo } from '../common/DataTypes';
import lazy { AlbumInfo } from '../browser/album/AlbumInfo';
import lazy { FrameManager } from '../../utils/FrameManager';
import lazy { ParamsWrapper } from '../../view/actionbar/Menu';
import lazy { DataSource, LoadingInfo, LoadingResult, LoadingTask } from '../DataSource';
import lazy { PageData } from '../PageData';
import lazy { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import lazy { ImageUtil } from '../../utils/ImageUtil';
import lazy { collections, JSON, taskpool } from '@kit.ArkTS';
import lazy common from '@ohos.app.ability.common';
import lazy { PickerQueryUriManager } from '../PickerQueryUriManager';
import lazy { SendableMediaItem } from './photo/SendableMediaItem';
import lazy { AssetHelper } from '../../utils/AssetHelper';
import lazy { PreselectedInfo } from '@ohos.file.PhotoPickerComponent';

const TAG: string = 'SelectManager';

const LOOP_BATCH_COUNT_LIMIT: number = 10000;
// 全选场景撤销功能数据批次上限
const SELECT_ALL_COUNT_LIMIT: number = 30;
const AREA_LENGTH: number = 2;

/**
 * 选择监听
 */
export interface SelectListener {
  onDeSelectAll?: () => void;
  onSelectionChange?: (item: MediaItem | AlbumInfo, isSelected: boolean) => void;
  onModeChanged?: (newMode: boolean) => void;
  onSelectCountChanged?: (newCount: number) => void;
  onGroupSelectionChanged?: (dateKey: number, isSelected: boolean) => void;
}

/**
 * 选择事件派发器
 */
export class SelectEventDispatcher implements SelectListener {
  private readonly listeners: SelectListener[] = [];

  public onDeSelectAll(): void {
    for (let listener of this.listeners) {
      listener.onDeSelectAll?.();
    }
  }

  public onSelectionChange(item: MediaItem | AlbumInfo, isSelected: boolean): void {
    for (let listener of this.listeners) {
      listener.onSelectionChange?.(item, isSelected);
    }
  }

  public onModeChanged(newMode: boolean): void {
    for (let listener of this.listeners) {
      listener.onModeChanged?.(newMode);
    }
  }

  public onSelectCountChanged(newCount: number): void {
    for (let listener of this.listeners) {
      listener.onSelectCountChanged?.(newCount);
    }
  }

  public onGroupSelectionChanged(dateKey: number, isSelected: boolean): void {
    for (let listener of this.listeners) {
      listener.onGroupSelectionChanged?.(dateKey, isSelected);
    }
  }

  public add(listener: SelectListener): void {
    if (!listener || this.listeners.indexOf(listener) !== -1) {
      return;
    }
    this.listeners.push(listener);
  }

  public remove(listener: SelectListener): void {
    if (!listener) {
      return;
    }
    let index = this.listeners.indexOf(listener);
    if (index === -1) {
      return;
    }
    this.listeners.splice(index, 1);
  }
}

/* instrument ignore file */
export class BucketSelectionEntry {
  private dateKey = -1;
  private clickedSet: Set<string> = new Set();
  private totalCount = 0;
  private inverseSelection = false;
  private groupSelect = false;
  private selectedMap: Map<string, MediaItem> = new Map();
  public mCallbacks = new Map<string, Function>();

  public setDateKey(dateKey: number): void {
    this.dateKey = dateKey;
  }

  public getDateKey(): number {
    return this.dateKey;
  }

  public setTotalCount(totalCount: number): void {
    this.totalCount = totalCount;
  }

  public getTotalCount(): number {
    return this.totalCount;
  }

  public setGroupSelect(selectMode: boolean): void {
    this.groupSelect = selectMode;
  }

  public getGroupSelect(): boolean {
    return this.groupSelect;
  }

  public removeClickSet(targetId: string): void {
    this.clickedSet.delete(targetId);
  }

  public removeSelectedMap(targetId: string): void {
    this.selectedMap.delete(targetId);
  }

  public getClickSet(): Set<string> {
    return this.clickedSet;
  }

  public getSelectedMap(): Map<string, MediaItem> {
    return this.selectedMap;
  }

  public getSelectedCount(): number {
    if (this.inverseSelection) {
      return this.totalCount - this.clickedSet.size;
    }
    return this.clickedSet.size;
  }

  public selectAll(): void {
    this.inverseSelection = true;
    this.groupSelect = true;
    this.clickedSet.clear();
    this.selectedMap.clear();
  }

  public deSelectAll(): void {
    this.inverseSelection = false;
    this.groupSelect = false;
    this.clickedSet.clear();
    this.selectedMap.clear();
  }

  public isItemSelected(targetId: string): boolean {
    return this.inverseSelection !== this.clickedSet.has(targetId);
  }

  public inSelectAllMode(): boolean {
    return this.inverseSelection && this.clickedSet.size === 0;
  }

  /**
   * Change the select all status of the entry, depending on the total deselection status of the timeline
   *
   * @param isInverseMode The total inverse selection status of the timeline. If it is true,
   * it is global inverse selection and requires reverse operation
   */
  public changeSelectMode(isInverseMode: boolean): void {
    Log.warn(TAG, `groupClick changeSelectMode`);
    isInverseMode ?
      (this.getSelectedCount() === 0 ? this.selectAll() : this.deSelectAll()) :
      (this.inSelectAllMode() ? this.deSelectAll() : this.selectAll());
  }

  public getInverseSelection(): boolean {
    return this.inverseSelection;
  }

  public setInverseSelection(inverse: boolean): void {
    this.inverseSelection = inverse;
  }
}

export class ItemCoordinate {
  dateKey = -1;
  subIndex = -1;

  constructor() {
  }

  public setDateKey(dateKey: number): ItemCoordinate {
    this.dateKey = dateKey;
    return this;
  }

  public getDateKey(): number {
    return this.dateKey;
  }

  public setIndex(index: number): ItemCoordinate {
    this.subIndex = index;
    return this;
  }

  public getIndex(): number {
    return this.subIndex;
  }
}

/**
 * 属性检查器
 */
export interface ItemChecker {
  checkItems(items: MediaItem[], paramsWrapper: ParamsWrapper): boolean;
}

/**
 * 图片未收藏检查器
 */
export class FavoriteChecker implements ItemChecker {
  public static readonly KEY_HAS_UN_FAVORITE = 'com.ohos.photos.has_un_favorite';

  /**
   * 检查是否存在未收藏资源
   * @param items 检查的资源
   * @param paramsWrapper
   * @returns 是否中断查询，当该检查器找到符合条件数据，由业务判断是否可以中止查询
   */
  public checkItems(items: MediaItem[], paramsWrapper: ParamsWrapper): boolean {
    // 如果之前已经查询到未收藏的图片，直接返回
    if (paramsWrapper.get<boolean>(FavoriteChecker.KEY_HAS_UN_FAVORITE)) {
      return true;
    }
    let assets: PhotoAsset[] = [];
    for (let item of items) {
      if (item?.data) {
        assets.push(item.data);
      }
    }
    for (let item of assets) {
      let isFavor = Boolean(AssetHelper.get(item, photoAccessHelper.PhotoKeys.FAVORITE));
      if (!isFavor) {
        paramsWrapper.set(FavoriteChecker.KEY_HAS_UN_FAVORITE, true);
        Log.info(TAG, `current batch has unFavor result: true`)
        return true;
      }
    }
    paramsWrapper.set(FavoriteChecker.KEY_HAS_UN_FAVORITE, false);
    Log.info(TAG, `current batch has unFavor result: false`)
    return false;
  }
}

/**
 * 动态照片检查器
 */
export class MovingPhotoChecker implements ItemChecker {
  public static readonly KEY_IS_NOT_MOVING_PHOTO = 'com.ohos.photos.is_not_moving_photo';

  /**
   * 检查是否存在资源
   * @param items 检查的资源
   * @param paramsWrapper
   * @returns 是否中断查询，当该检查器找到符合条件数据，由业务判断是否可以中止查询
   */
  public checkItems(items: MediaItem[], paramsWrapper: ParamsWrapper): boolean {
    if (paramsWrapper.get<boolean>(MovingPhotoChecker.KEY_IS_NOT_MOVING_PHOTO)) {
      return true;
    }
    for (let item of items) {
      let isMovingPhoto: boolean = false;
      // if (item) {
      //   isMovingPhoto =
      //     Boolean(item?.getIsMovingPhoto() && item?.getPosition() !== photoAccessHelper.PositionType.CLOUD);
      // }
      if (!isMovingPhoto) {
        paramsWrapper.set(MovingPhotoChecker.KEY_IS_NOT_MOVING_PHOTO, true);
        Log.info(TAG, `current batch isNotMovingPhoto result: true`)
        return true;
      }
    }
    paramsWrapper.set(MovingPhotoChecker.KEY_IS_NOT_MOVING_PHOTO, false);
    Log.info(TAG, `current batch isNotMovingPhoto result: false`)
    return false;
  }
}

/**
 * 媒体类型检查器
 */
export class MediaTypeChecker implements ItemChecker {
  public static readonly KEY_SELECT_MEDIA_TYPE = 'com.ohos.photos.select_media_type';

  /**
   * 检查选中的媒体资源类型
   * @param items 检查的资源
   * @param paramsWrapper
   * @returns 是否中断查询，当该检查器找到符合条件数据，由业务判断是否可以中止查询
   */
  public checkItems(items: MediaItem[], paramsWrapper: ParamsWrapper): boolean {
    // 如果之前媒体类型已经两种都有了，那就直接退出
    let mediaType: number = paramsWrapper.get<number>(MediaTypeChecker.KEY_SELECT_MEDIA_TYPE) ?? 0;
    if (mediaType === SelectMediaType.IMAGE_VIDEO) {
      return true;
    }
    for (let item of items) {
      if (item?.data) {
        mediaType |= item.data.photoType;
        if (mediaType === SelectMediaType.IMAGE_VIDEO) {
          paramsWrapper.set(MediaTypeChecker.KEY_SELECT_MEDIA_TYPE, mediaType);
          Log.info(TAG, `current batch photoTypeParam result: ${mediaType}`);
          return true;
        }
      }
    }
    paramsWrapper.set(MediaTypeChecker.KEY_SELECT_MEDIA_TYPE, mediaType);
    Log.info(TAG, `current batch photoTypeParam result: ${mediaType}`);
    return false;
  }
}

/**
 * gif照片检查器
 */
export class GIFPhotoChecker implements ItemChecker {
  public static readonly KEY_IS_GIF_PHOTO = 'com.ohos.photos.is_GIF_photo';

  /**
   * 检查是否存在资源
   * @param items 检查的资源
   * @param paramsWrapper
   * @returns 是否中断查询，当该检查器找到符合条件数据，由业务判断是否可以中止查询
   */
  public checkItems(items: MediaItem[], paramsWrapper: ParamsWrapper): boolean {
    if (paramsWrapper.get<boolean>(GIFPhotoChecker.KEY_IS_GIF_PHOTO)) {
      return true;
    }
    for (let item of items) {
      let isMovingPhoto: boolean = false;
      if (item) {
        isMovingPhoto = Boolean(item?.getFileExtension() === Constants.EXTENSION_GIF);
        Log.info(TAG, `current batch isMovingPhoto: ${isMovingPhoto}`)
      }
      if (isMovingPhoto) {
        paramsWrapper.set(GIFPhotoChecker.KEY_IS_GIF_PHOTO, true);
        Log.info(TAG, `current batch result: true`)
        return true;
      }
    }
    paramsWrapper.set(GIFPhotoChecker.KEY_IS_GIF_PHOTO, false);
    Log.info(TAG, `current batch result: false`)
    return false;
  }
}

interface SelectedItemsParserTaskParams {
  info: LoadingInfo;
  source: DataSource<ParamsWrapper>;
  pageData: PageData<ParamsWrapper>;
  checkers: ItemChecker[];
  selectManager: SelectManager;
}

export class SelectedItemsParserLoadingTask extends LoadingTask<ParamsWrapper> {
  private params: SelectedItemsParserTaskParams;

  public constructor(params: SelectedItemsParserTaskParams) {
    super(params.info, params.source, params.pageData);
    this.params = params;
  }

  public async start(): Promise<LoadingResult<ParamsWrapper>> {
    let newPageData: ParamsWrapper = new ParamsWrapper();
    let totalCount = this.params.selectManager.totalCount;
    Log.info(TAG, `check task totalCount: ${this.params.selectManager.totalCount}`);
    if (totalCount <= 0) {
      return {
        info: this.info,
        oldPageData: this.pageData,
        newPageData: new PageData(this.loadVersion, [newPageData], 0, 0),
      } as LoadingResult<ParamsWrapper>;
    }
    return this.batchApplyCheckers();
  }

  private async batchApplyCheckers(): Promise<LoadingResult<ParamsWrapper>> {
    let msg: string[] = ['SelectedItemsParserLoadingTask start'];
    let checkResult: ParamsWrapper = new ParamsWrapper();
    let totalCount: number = this.params.selectManager.totalCount;
    let totalBatches: number = Math.ceil(totalCount / SelectManager.BATCH_SIZE);
    let startTime: number = Date.now();
    let parsedCount: number = 0;
    let currentBatch: number = 0;

    let isBatchToggle: boolean[] = new Array(totalBatches).fill(false);
    if (this.params.selectManager instanceof TimelineSelectManager && !this.params.selectManager.inverseSelection) {
      let areas: Array<Array<number>> = this.params.selectManager.getSelectedArray();
      for (let area of areas) {
        if (area?.length !== AREA_LENGTH) {
          continue;
        }
        const start: number = Math.floor(area[0] / SelectManager.BATCH_SIZE);
        const end: number = Math.floor(area[1] / SelectManager.BATCH_SIZE);
        for (let i = start; i <= end; i++) {
          isBatchToggle[i] = true;
        }
      }
      Log.info(TAG, `isBatchToggle ${isBatchToggle}`);
    } else {
      isBatchToggle.fill(true, 0, isBatchToggle.length);
    }

    while (currentBatch < totalBatches && parsedCount < this.params.selectManager.getSelectedCount()) {
      if (!isBatchToggle[currentBatch]) {
        currentBatch++;
        continue;
      }
      Log.info(TAG, `start current batch: ${currentBatch}, total batch: ${totalBatches}`)
      let startIndex: number = currentBatch * SelectManager.BATCH_SIZE;
      let shouldInterrupt: boolean = false;
      let items: MediaItem[] = [];
      try {
        items = await this.batchGetSelectAsset(startIndex, SelectManager.BATCH_SIZE);
      } catch (e) {
        Log.warn(TAG, `failed to get batch: ${currentBatch}, err: ${e}`);
        break;
      }
      Log.info(TAG, `get one batch data start: ${startIndex}, size: ${items.length}`);
      parsedCount += items.length;
      this.params.checkers.forEach((checker) => {
        shouldInterrupt = checker.checkItems(items, checkResult) && shouldInterrupt;
      })
      Log.info(TAG, `should interrupt curent batch query: ${shouldInterrupt}`);
      if (shouldInterrupt) {
        break;
      }
      currentBatch++;
    }
    msg.push(`total: ${totalCount}`, `totalBatch: ${totalBatches}`, `cost: ${Date.now() - startTime}`,
      `checkResult: ${checkResult.getParamsInfo()}`);
    Log.info(TAG, msg.join(', '));

    return {
      info: this.info,
      oldPageData: this.pageData,
      newPageData: new PageData(this.loadVersion, [checkResult], 0, 0),
    } as LoadingResult<ParamsWrapper>;
  }

  private async batchGetSelectAsset(start: number, count: number): Promise<MediaItem[]> {
    return new Promise<MediaItem[]>((resolve) => {
      let callBack: Function = (assets: MediaItem[]) => resolve(assets);
      this.params.selectManager.batchGetSelectAsset(callBack, start, count);
    });
  }
}

export class SelectedItemsParser extends DataSource<ParamsWrapper> {
  /**
   * 日志tag
   */
  protected tag: string = 'SelectedItemsParser';
  private checkers: ItemChecker[] = [];
  private readonly selectManager: SelectManager;

  constructor(selectManager: SelectManager) {
    super();
    this.selectManager = selectManager;
  }

  protected buildLoadingTask(info: LoadingInfo): LoadingTask<ParamsWrapper> | undefined {
    let task: LoadingTask<ParamsWrapper> | undefined = new SelectedItemsParserLoadingTask({
      info: info,
      source: this,
      pageData: this.pageData,
      checkers: this.checkers,
      selectManager: this.selectManager,
    });
    return task;
  }

  /**
   * 添加一个检查器
   * @param checker 属性检查器
   */
  public addChecker(checker: ItemChecker): void {
    if (!checker || this.checkers.indexOf(checker) !== -1) {
      return;
    }
    this.checkers.push(checker);
  }

  /**
   * 删除一个检查器
   * @param checker 属性检查器
   */
  public removeChecker(checker: ItemChecker): void {
    if (!checker) {
      return;
    }
    let index = this.checkers.indexOf(checker);
    if (index === -1) {
      return;
    }
    this.checkers.splice(index, 1);
  }

  public removeAllCheckers(): void {
    this.checkers.splice(0, this.checkers.length);
  }
}

@Concurrent
async function getItemsTask(context: common.Context, uriArray: string[],
  result: collections.Array<SendableMediaItem>): Promise<void> {
  let manager: PickerQueryUriManager = new PickerQueryUriManager(context);
  try {
    TraceControllerUtils.startTrace(`getMediaItemsByUriList`);
    await manager.getMediaItemsByUriList(uriArray, result);
    TraceControllerUtils.finishTrace(`getMediaItemsByUriList`);
  } catch (err) {
    Log.error('getItemsTask', `getItemsTask error: ${toString(err)}`);
    return;
  } finally {
    manager.onDestroy();
  }
}

export class SelectManager {
  public mIsSelectedMode = false;
  public clickedSet: Set<string> = new Set();
  public totalCount = 0;
  public inverseSelection = false;
  public inSingleMode = false;
  public isAllSelected = false;
  public selectParam?: SelectParams;
  public mCallbacks = new Map<string, Function>();
  public photoDataImpl?: BrowserDataInterface;
  public albumUri?: string;
  public albumInfo?: AlbumInfo;
  public deviceId?: string;
  public selectedMap: Map<string, MediaItem> = new Map();
  // 全量查找时需要使用callback
  public getMediaItemFunc?: Function;
  public getMediaItemsFunc?: Function;
  public isSecondarySelection: boolean = false;
  public isPickerIndexSet: boolean = false;
  public totalSelectedItemUriList: string[] = [];
  public totalSelectedItemUriWithPickerIndex: PreselectedInfo[] = [];
  private isHidden: boolean = false;
  public unFavorItemCount: number = 0;
  public isGetItemsFromDataSource: boolean = false;
  public isPickerUsedSubwindow: boolean = false;
  public needCheckCloudImage: boolean = false;
  public batchSelectAll: PhotoAsset[][] = [];
  public isBeyondLimit: boolean = false;
  public lastSelectMode: boolean = false;
  // 头尾节点信息
  protected headTailPosition: HeadTailPosition = {
    headPosition: undefined,
    tailPosition: undefined,
  };
  protected dataSource: MediaDataSource | undefined;
  protected dataSourceProxy: MediaDataSource | undefined;
  protected dispatcher: SelectEventDispatcher = new SelectEventDispatcher();
  public static readonly BATCH_SIZE: number = 500;
  public isRealTimeSearchSlotItemPage = false;
  private updateCountTimeout: number = 0;

  public isSelectedMode(): boolean {
    return this.mIsSelectedMode;
  }

  public setDataSource(data: MediaDataSource): void {
    this.dataSource = data;
  }

  public setDataSourceProxy(data: MediaDataSource): void {
    this.dataSourceProxy = data;
  }

  public setIsGetItemsFromDataSource(isGetItemsFromDataSource: boolean): void {
    this.isGetItemsFromDataSource = isGetItemsFromDataSource;
  }

  /* instrument ignore next */
  public handleFavorChange(callback: Function): void {
    if (!this.getSelectedCount()) {
      return;
    }

    this.getSelectedItems((selectedItems: MediaItem[]): void => {
      const favorList: MediaItem[] = [];
      const unfavorList: MediaItem[] = [];
      for (let i: number = 0; i < selectedItems.length; i++) {
        let cur = this.dataSource?.getMediaItemByUri(selectedItems[i].uri);
        if (cur) {
          if (cur.isFavor) {
            favorList.push(cur);
          } else {
            unfavorList.push(cur);
          }
        }
      }
      let todoList: MediaItem[] = unfavorList.length > 0 ? unfavorList : favorList;
      this.unFavorItemCount = unfavorList.length;
      let lastCount: number = this.unFavorItemCount;
      for (let i: number = 0; i < todoList.length; i++) {
        let item: MediaItem = todoList[i];
        item.isFavor = unfavorList.length > 0;
        this.unFavorItemCount += !item.isFavor ? 1 : -1;
        callback(item);
      }
      if (this.unFavorItemCount !== lastCount) {
        this.mCallbacks.has('unFavorItemCountUpdate') &&
          this.mCallbacks.get('unFavorItemCountUpdate')?.(this.getSelectedCount());
      }
    });
  }

  protected dispatchUpdates(): void {
    this.dispatcher.onDeSelectAll();
  }

  public addListener(listener: SelectListener): void {
    this.dispatcher.add(listener);
  }

  public removeListener(listener: SelectListener): void {
    this.dispatcher.remove(listener);
  }

  /* instrument ignore next */
  public getFavorable(): boolean {
    Log.info(TAG, `getFavorable: ${this.unFavorItemCount} totalCount:${this.totalCount}`);
    return this.unFavorItemCount > 0;
  }

  public setSecondarySelectionStatus(isSecondarySelection: boolean): void {
    this.isSecondarySelection = isSecondarySelection;
  }

  public updateCount(): void {
    if (!this.updateCountTimeout) {
      this.updateCountTimeout = setTimeout(() => {
        this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')?.(this.getSelectedCount());
        this.dispatcher.onSelectCountChanged(this.getSelectedCount());
        this.updateCountTimeout = 0;
      }, 100);
    }
  }

  public setTotalCount(count: number): void {
    this.totalCount = count;
    this.updateCount();

    if (this.isAllSelected) {
      this.isAllSelected = false;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(false);
    }
    if (this.totalCount === this.getSelectedCount()) {
      this.isAllSelected = true;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(true);
    }
  }

  public setSelectParam(param: SelectParams): void {
    this.selectParam = param;
    // Set picker index setting
    this.isPickerIndexSet = param.pickerIndex !== undefined &&
      param.pickerIndex !== null &&
      param.pickerIndex !== Constants.INVALID;
    // Set totalSelectedItemsWithPickerIndex from params
    this.setTotalSelectedItemUriWithPickerIndex(param.preselectedInfos);
  }

  public setTotalSelectedItemUriWithPickerIndex(preselectedInfos: PreselectedInfo[]) {
    this.totalSelectedItemUriWithPickerIndex = [];
    for (const item of preselectedInfos) {
      this.totalSelectedItemUriWithPickerIndex.push(item);
    }
  }

  public setPhotoDataImpl(photoDataImpl?: PhotoDataImpl): void {
    this.photoDataImpl =
      (photoDataImpl ?? BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO_ASYNC)) as BrowserDataInterface;
  }

  public setAlbumUri(albumUri: string): void {
    this.albumUri = albumUri;
  }

  public setAlbumInfo(albumInfo: AlbumInfo): void {
    this.albumInfo = albumInfo;
  }

  public setDeviceId(deviceId: string): void {
    this.deviceId = deviceId;
  }

  public registerCallback(name: string, cb: Function): void {
    this.mCallbacks.set(name, cb);
  }

  public unregisterCallback(name: string, cb?: Function): void {
    if (!cb) {
      this.mCallbacks.delete(name);
      return;
    }
    if (this.mCallbacks.get(name) === cb) {
      this.mCallbacks.delete(name);
    }
  }

  public emitCallback(name: string, argument: number[]): void {
    this.mCallbacks.has(name) && this.mCallbacks.get(name)?.(...argument);
  }

  public hasSelectedUnFavorItem(): boolean {
    Log.debug(TAG, `hasSelectedUnFavorItem = ${this.unFavorItemCount > 0}`);
    return this.unFavorItemCount > 0;
  }

  public toggleWithCheckOriginalState(targetId: string, isSelected: boolean, targetIndex?: number): void {
    if (!targetId) {
      return;
    }
    if (this.isItemSelected(targetId, targetIndex) !== isSelected) {
      this.toggle(targetId, isSelected, targetIndex);
    }
  }

  public toggleWithCheckOriginalStateScrolling(targetId: string, isSelected: boolean, targetIndex?: number): void {
    if (!targetId) {
      return;
    }
    if (this.isItemSelected(targetId, targetIndex) !== isSelected) {
      let task = () => {
        this.toggle(targetId, isSelected, targetIndex ?? 0);
      }
      FrameManager.getInstance().postTask(TAG, task);
    }
  }

  public toggleForSelectBrowser(targetId: string, isSelected: boolean, targetIndex?: number): boolean {
    return this.toggle(targetId, isSelected, targetIndex);
  }

  public toggle(targetId: string, isSelected: boolean, targetIndex?: number, item?: MediaItem): boolean {
    if (!targetId && targetId !== '') {
      return true;
    }
    if (isSelected !== this.inverseSelection) {
      this.clickedSet.add(targetId);
      if (this.getMediaItemFunc) {
        if (!item) {
          item = this.getMediaItemFunc(targetId);
        }
        if (item) {
          this.selectedMap.set(targetId, item);
          this.updateUnFavorItemCount(item?.data, true);
        }
      }
      Log.i(TAG, `add targetID ${targetId}`);
    } else {
      this.clickedSet.delete(targetId);
      if (this.getMediaItemFunc) {
        const mediaItem = this.selectedMap.get(targetId);
        this.selectedMap.delete(targetId);
        this.updateUnFavorItemCount(mediaItem?.data, false);
      }
    }
    if (this.totalCount === this.getSelectedCount()) {
      this.isAllSelected = true;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(true);
    } else {
      this.isAllSelected = false;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(false);
    }
    this.updateCount();
    if (targetIndex !== undefined) {
      this.mCallbacks.has('select') && this.mCallbacks.get('select')?.(targetIndex);
    }
    if (this.isSecondarySelection) {
      this.mCallbacks.has('verifySecondarySelection') &&
        this.mCallbacks.get('verifySecondarySelection')?.(isSelected, targetId);
    }
    return true;
  }

  /* instrument ignore next */
  public removeItem(targetId: string | undefined): void {
    Log.info(TAG, `removeItem targetId：${targetId}`);
    if (!targetId) {
      return;
    }
    this.clickedSet.delete(targetId);
    this.selectedMap.delete(targetId);
    this.updateCount();
  }

  protected async updateUnFavorItemCount(asset: PhotoAsset | undefined, isSelect: boolean): Promise<void> {
    if (Boolean(asset?.get(photoAccessHelper.PhotoKeys.FAVORITE))) {
      return;
    }
    if (isSelect) {
      this.unFavorItemCount += this.inverseSelection ? -1 : 1;
    } else {
      this.unFavorItemCount += this.inverseSelection ? 1 : -1;
    }
    Log.info(TAG, `updateUnFavorItemCount unFavorItemCount = ${this.unFavorItemCount}`);
    this.mCallbacks.has('unFavorItemCountUpdate') &&
      this.mCallbacks.get('unFavorItemCountUpdate')?.(this.getSelectedCount());
  }

  public async updateSelectedUnFavorItemCount(asset: PhotoAsset | undefined): Promise<void> {
    let isFavor: boolean = Boolean(asset?.get(photoAccessHelper.PhotoKeys.FAVORITE));
    let add = isFavor ? -1 : 1;
    this.unFavorItemCount += this.inverseSelection ? -add : add;
    Log.info(TAG, `updateSelectedUnFavorItemCount unFavorItemCount = ${this.unFavorItemCount}`);
    this.mCallbacks.has('unFavorItemCountUpdate') &&
      this.mCallbacks.get('unFavorItemCountUpdate')?.(this.getSelectedCount());
  }

  public setIsHidden(isHidden: boolean): void {
    this.isHidden = isHidden;
  }

  public getSelectUris(): string[] {
    return this.totalSelectedItemUriList;
  }

  public getSelectedUrisWithPickerIndex(): string[] {
    let selected: string[] = [];
    for (let item of this.totalSelectedItemUriWithPickerIndex) {
      if(this.isPickerIndexMatch(this.selectParam?.pickerIndex, item.preselectablePickerIndex)) {
        selected.push(item.uri)
      }
    }
    return selected;
  }

  public filterWithPickerIndex(item: PreselectedInfo): boolean {
    if (item.preselectablePickerIndex === undefined) {
      // set default item pickerIndex to -1
      item.preselectablePickerIndex = Constants.INVALID;
    }
    return !this.isPickerIndexSet
      || this.isPickerIndexMatch(this.selectParam?.pickerIndex, item.preselectablePickerIndex);
  }

  public selectAllWithoutNotify(reverseSelection: boolean, shouldCallSelectALl: boolean): void {
    if (reverseSelection) {
      this.inverseSelection = true;
      this.clickedSet.clear();
      this.selectedMap.clear();
      this.isAllSelected = true;
    } else {
      this.isAllSelected = true;
    }
    AppStorage.setOrCreate<boolean>('focusUpdate', true);
    if (shouldCallSelectALl) {
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(true);
    }
    this.updateCount();
  }

  public selectAll(reverseSelection: boolean): void {
    this.selectAllWithoutNotify(reverseSelection, true);
    ReportToBigDataUtil.report(BigDataConstants.SELECT_ALL_ID,
      { 'scenario': ReportToBigDataUtil.getPhotoBrowserScenario(PhotoInfo.scenarioIndex) });
    if (this.isGetItemsFromDataSource && this.dataSource) {
      this.getItemsFromDataSource(this.dataSource, 0, this.totalCount, (items: MediaItem[]): void => {
        let newUnFavorCount: number = 0;
        for (let item of items) {
          if (item && !item.isFavor) {
            newUnFavorCount++;
          }
        }
        this.unFavorItemCount = newUnFavorCount;
        this.mCallbacks.has('unFavorItemCountUpdate') &&
          this.mCallbacks.get('unFavorItemCountUpdate')?.(this.getSelectedCount());
      });
      return;
    }
    this.photoDataImpl?.getUnFavorCount(this.albumUri).then((count: number) => {
      this.unFavorItemCount = count;
      this.mCallbacks.has('unFavorItemCountUpdate') &&
        this.mCallbacks.get('unFavorItemCountUpdate')?.(this.getSelectedCount());
    });
  }

  public resetUnFavorItemCount(isFavorAction: boolean): void {
    this.unFavorItemCount = isFavorAction ? 0 : this.getSelectedCount();
    this.mCallbacks.has('unFavorItemCountUpdate') &&
      this.mCallbacks.get('unFavorItemCountUpdate')?.(this.getSelectedCount());
  }

  public deSelectAll(isDoSelectAll?: boolean): void {
    Log.info(TAG, `deSelectAll`)
    this.inverseSelection = false;
    this.isAllSelected = false;
    this.clickedSet.clear();
    this.selectedMap.clear();
    this.unFavorItemCount = 0;
    AppStorage.setOrCreate<boolean>('focusUpdate', true);
    this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(false, isDoSelectAll);
    this.updateCount();
    this.dispatcher.onDeSelectAll();
  }

  public selectByArrowKey(): void {
    this.inverseSelection = false;
    this.isAllSelected = false;
    this.clickedSet.clear();
    this.selectedMap.clear();
    this.unFavorItemCount = 0;
  }

  public isItemSelected(targetId?: string, index?: number): boolean {
    if (!targetId) {
      Log.error(TAG, 'getIsItemSelected error uri: undefined');
      return false;
    }
    return this.inverseSelection !== this.clickedSet.has(targetId);
  }

  public isItemSelectedForBrowser(targetId: string, index: number | undefined): boolean {
    return this.isItemSelected(targetId, index);
  }

  public getSelectedCount(): number {
    Log.info(TAG,
      `getSelectedCount, this.totalCount: ${this.totalCount}, this.clickedSet.size: ${this.clickedSet.size}`)
    return this.inverseSelection ? this.totalCount - this.clickedSet.size : this.clickedSet.size;
  }

  /**
   * 刷新选中项数量
   * @param deleteItems 更新删除的数据
   * @param number 当前选中的item
   */
  public updateSelectCount(deleteItems: string[]) {
    // 增加判断，刷新clickSet,防止已经删除的item
    deleteItems.forEach(deleteItem => {
      if (this.clickedSet.has(deleteItem)) {
        this.clickedSet.delete(deleteItem);
        this.selectedMap.delete(deleteItem);
      }
    })
    Log.info(TAG, `dataSource : ${this.dataSource?.size}  clickedSet : ${this.clickedSet.size}`);
  }

  // 最近删除相册的count计算和其他相册不一样，非选择态下可以点击右上角’清空最近删除‘，即非选择态意味全选
  public getSelectedCountForRecycle(): number {
    if (this.mIsSelectedMode) {
      return this.getSelectedCount();
    }
    return this.totalCount;
  }

  public onModeChange(newMode: boolean): void {
    let oldMode: boolean = this.mIsSelectedMode;
    this.mIsSelectedMode = newMode;
    if (oldMode !== newMode) {
      Log.info(TAG, `onModeChange ${oldMode}->${newMode}`);
      this.dispatcher.onModeChanged(newMode);
    }
    if (newMode) {
      return;
    }
    this.inverseSelection = false;
    this.isAllSelected = false;
    this.clickedSet.clear();
    this.selectedMap.clear();
    AppStorage.setOrCreate<boolean>('focusUpdate', true);
    this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(false);
    this.updateCount();
  }

  /* instrument ignore next */
  public getSelectMediaCountByType(type: number): number {
    let count = 0;
    this.selectedMap.forEach((item, key) => {
      if (item?.mediaType === type) {
        if (this.selectParam?.isFromPickerView && this.selectParam?.isRepeatSelectSupported) {
          count += this.getCountByUri(item.uri);
        } else {
          count++;
        }
      }
    });
    return count;
  }

  public addClicked(uri: string): void {
    if (uri !== '') {
      this.clickedSet.add(uri);
    }
  }

  /* instrument ignore next */
  public getCountByUri(uri: string): number {
    let count = 0;
    this.totalSelectedItemUriList.forEach(item => {
      if (item === uri) {
        count++;
      }
    });
    Log.info(TAG, `getCountByUri: ${count}`);
    return count;
  }

  /* instrument ignore next */
  public isSelectFull(mediaItem: MediaItem): boolean {
    if (!this.selectParam) {
      return false;
    }
    if (!this.selectParam.isFromPickerView) {
      return this.getSelectedCount() >= this.selectParam.maxSelectCount;
    }
    if (this.getSelectedCount() >= this.selectParam.maxSelectCount) {
      return true;
    }
    if (mediaItem?.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE &&
      this.getSelectMediaCountByType(UserFileManagerAccess.MEDIA_TYPE_IMAGE) >=
      this.selectParam.maxPhotoSelectNumber) {
      return true;
    }
    if (mediaItem?.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO &&
      this.getSelectMediaCountByType(UserFileManagerAccess.MEDIA_TYPE_VIDEO) >=
      this.selectParam.maxVideoSelectNumber) {
      return true;
    }
    return false;
  }

  /* instrument ignore next */
  public updateMediaItemFullState(): void {
    if (!this.selectParam) {
      return;
    }
    if (!this.selectParam.isFromPickerView ||
      this.selectParam.maxSelectedReminderMode !== Constants.MASK_REMIND_MODE) {
      return;
    }
    let selectImageCount = this.getSelectMediaCountByType(UserFileManagerAccess.MEDIA_TYPE_IMAGE) ?? 0;
    let selectVideoCount = this.getSelectMediaCountByType(UserFileManagerAccess.MEDIA_TYPE_VIDEO) ?? 0;
    let isImageFull = false;
    let isVideoFull = false;
    if (selectImageCount >= this.selectParam.maxPhotoSelectNumber) {
      isImageFull = true;
    } else {
      isImageFull = false;
    }
    if (selectVideoCount >= this.selectParam.maxVideoSelectNumber) {
      isVideoFull = true;
    } else {
      isVideoFull = false;
    }
    if (this.getSelectedCount() >= this.selectParam.maxSelectCount) {
      isImageFull = true;
      isVideoFull = true;
    }
    LocalStorage.getShared()?.setOrCreate<Boolean>('isImageFull', isImageFull);
    LocalStorage.getShared()?.setOrCreate<Boolean>('isVideoFull', isVideoFull);
  }

  public selectedCallback(callback: AsyncCallback<string[]>): void {
    if (this.inverseSelection) {
      // 反选场景需要查询数据源中的所有项目，然后排除clickedSet中的元素
      const param: QueryParam = {
        albumUri: this.albumUri,
        albumUris: this.albumInfo?.unionAlbumUris,
        fetchType: FetchType.EMPTY,
      };
      this.photoDataImpl?.getData(new SelectManagerCallback(this.clickedSet, callback), param);
    } else {
      const result: string[] = Array.from(this.clickedSet);
      callback.callback(result);
    }
  }

  /**
   * 获取选中态的宫格Item
   * @param callback
   * @param isSkipClear 是否跳过清空,三宫格专用（拖动和分享需跳过）
   * @param start 查询的起始位置
   * @param count 查询的总个数
   */
  public getSelectAsset(callback: Function, isSkipClear: boolean = false, start?: number, count?: number): void {
    Log.info(TAG, `inversion ` + this.inverseSelection + ` start ${start} count ${count}`);
    if (this.inverseSelection) {
      const newCallback: Function = (result: MediaItem[]) => {
        const assets = result.map((item) => item.data);
        callback(assets);
      };
      if (this.isGetItemsFromDataSource && this.dataSource) {
        this.getItemsFromDataSource(this.dataSource, 0, this.totalCount, (items: MediaItem[]): void => {
          let assets: PhotoAsset[] = [];
          for (let item of items) {
            if (item && !this.clickedSet.has(item.uri) && item.data) {
              assets.push(item.data);
            }
          }
          callback(assets);
        })
        return;
      }
      // 反选场景需要查询数据源中的所有项目，然后排除clickedSet中的元素
      if (start === undefined) {
        let result: MediaItem[] = [];
        this.loopGetSelectAsset(0, Math.ceil(this.getSelectedCount() / LOOP_BATCH_COUNT_LIMIT), newCallback, result);
      } else {
        this.photoDataImpl?.getData(new AssetSelectManagerCallback(this.clickedSet, newCallback), {
          albumUri: this.albumUri,
          fetchType: FetchType.EMPTY,
          albumUris: this.albumInfo?.unionAlbumUris,
          start: start,
          count: count,
        });
      }
    } else {
      let mediaArray: MediaItem[] = Array.from(this.selectedMap.values());
      let result: PhotoAsset[] = [];
      for (let i: number = 0; i < mediaArray.length; i++) {
        if (mediaArray[i] && this.clickedSet.has(mediaArray[i].uri)) {
          result.push(mediaArray[i].data as photoAccessHelper.PhotoAsset);
        }
      }
      Log.info(TAG, ` this.selectedMap.size: ${result.length}`);
      callback(result);
    }
  }

  /**
   * 循环分批查询获取选中态的宫格Item
   * @param loopIndex 循环的index
   * @param totalCount 选中的宫格总个数
   * @param callback 回调函数
   * @param result 查询结果的数组
   */
  private loopGetSelectAsset(loopIndex: number, totalCount: number, callback: Function, result: MediaItem[]) {
    if (loopIndex < totalCount) {
      Log.info(TAG, `batchQueryData loopIndex: ` + loopIndex);
      loopIndex++;
      if (!this.photoDataImpl) {
        this.setPhotoDataImpl();
      }
      this.photoDataImpl?.getData(new AssetSelectManagerCallback(this.clickedSet, (mediaArray: MediaItem[]) => {
        result.push(...mediaArray);
        this.loopGetSelectAsset(loopIndex, totalCount, callback, result);
      }), {
        albumUri: this.albumUri,
        fetchType: FetchType.EMPTY,
        start: (loopIndex - 1) * LOOP_BATCH_COUNT_LIMIT,
        count: LOOP_BATCH_COUNT_LIMIT,
      });
    } else {
      callback(result);
    }
  }

  /**
   * 分批查询获取选中态的宫格Item
   * @param callback 回调函数
   * @param start 查询的起始位置
   * @param count 查询的个数
   */
  public batchGetInverseSelectAssets(callback: Function, start: number, count: number): void {
    Log.info(TAG, `inversion: ` + this.inverseSelection + ` start: ${start} count: ${count}`);
    if (callback === undefined || start === undefined || count === undefined) {
      Log.error(TAG, `batchGetSelectAsset params undefined`);
      return;
    }
    const newCallback: Function = (result: MediaItem[]) => {
      callback(result);
    };
    // 反选场景需要查询数据源中的所有项目，然后排除clickedSet中的元素
    if (!this.photoDataImpl) {
      this.setPhotoDataImpl();
    }
    this.photoDataImpl?.getData(new AssetSelectManagerCallback(this.clickedSet, newCallback), {
      albumUri: this.albumUri,
      fetchType: FetchType.EMPTY,
      start: start,
      count: count,
    });
  }

  /**
   * 分批查询获取选中态的宫格媒体资源,包含正选和反选场景下选中的资源
   * @param callback 结果集回调处理函数
   * @param start 当前批次开始index
   * @param count 当前批次查询数量
   */
  public batchGetSelectAsset(callback: Function, start: number, count: number): void {
    Log.info(TAG, `batchGetSelectAsset inverseSelection: ${this.inverseSelection}`)
    if (this.inverseSelection) {
      this.batchGetInverseSelectAssets(callback, start, count);
    } else {
      let mediaArray: MediaItem[] = Array.from(this.selectedMap.values());
      mediaArray = mediaArray.slice(start, start + count);
      callback(mediaArray);
    }
  }

  // 获取选择的所有照片（包括连拍的非封面照片）
  public getSelectAssetsWidthBurstPhotos(callback: Function, isTrash?: boolean): void {
    Log.info(TAG, `getSelectAssetsWidthBurstPhotos`)
    let result: MediaItem[] = [];
    const newCallback: Function = async (mediaArray: MediaItem[]) => {
      if (!this.photoDataImpl) {
        this.setPhotoDataImpl();
      }
      for (let i: number = 0; i < mediaArray.length; i++) {
        if (!mediaArray[i]) {
          Log.error(TAG, `mediaArray ${i} is undefined`);
          continue;
        }
        if (mediaArray[i].getIsBurstPhotos() && this.photoDataImpl?.getDataByBurstKey) {
          const mediaItems = await this.photoDataImpl.getDataByBurstKey(mediaArray[i].burstKey as string,
            Constants.INVALID, Constants.INVALID, true, isTrash);
          result.push(...mediaItems);
        } else {
          result.push(mediaArray[i]);
        }
      }
      const assets = result.map(item => item.data);
      callback(assets);
      result.splice(0, result.length);
    };
    if (this.inverseSelection) {
      Log.info(TAG, `inverseSelection`);
      // 反选场景需要查询数据源中的所有项目，然后排除clickedSet中的元素
      const initialTotalCount = this.totalCount;
      Log.info(TAG, `initialTotalCount: ${initialTotalCount}, clickedSet.size: ${this.clickedSet.size}`);
      let totalBatchCount = Math.ceil(initialTotalCount / LOOP_BATCH_COUNT_LIMIT);
      Log.info(TAG, `totalBatchCount: ${totalBatchCount}`);
      const batchCallback: Function = (finalResult: MediaItem[]) => {
        Log.info(TAG, `batchCallback called with ${finalResult.length} items, expected: ${initialTotalCount}`);
        const assets = finalResult.map(item => item.data);
        callback(assets);
      };
      this.batchQueryData(0, totalBatchCount, batchCallback, result, isTrash);
    } else {
      const mediaArray: MediaItem[] = Array.from(this.selectedMap.values())
        .filter(item => item && this.clickedSet.has(item.uri));
      newCallback(mediaArray);
    }
  }

  public getClickedPath(callback: Function): void {
    if (this.inverseSelection) {
      // 反选场景需要查询数据源中的所有项目，然后排除clickedSet中的元素
      callback(this.clickedSet);
    }
  }

  /**
   * 分批获取选择的所有照片（包括连拍的非封面照片）
   * @param callback 回调函数
   * @param clickedSet 点选的宫格
   * @param inverseSelection 是否反选操作
   * @param isTrash 是否最近删除
   * @param start 查询的起始位置
   * @param count 查询的元素个数
   */
  public batchGetSelectAssetsWidthBurstPhotos(callback: Function, clickedSet: Set<string>, inverseSelection: boolean,
    isTrash?: boolean, start?: number, count?: number, currentBatch?: number): void {
    if (!callback || !clickedSet) {
      Log.error(TAG, `batchGetSelectAssetsWidthBurstPhotos params undefined`);
      return;
    }
    const newCallback: Function = async (mediaArray: MediaItem[]) => {
      if (!this.photoDataImpl) {
        this.setPhotoDataImpl();
      }
      const result: MediaItem[] = [];
      for (let i: number = 0; i < mediaArray.length; i++) {
        if (!mediaArray[i]) {
          Log.error(TAG, `mediaArray ${i} is undefined`);
          continue;
        }
        if (mediaArray[i].getIsBurstPhotos() && this.photoDataImpl?.getDataByBurstKey) {
          const mediaItems = await this.photoDataImpl.getDataByBurstKey(mediaArray[i].burstKey as string,
            Constants.INVALID, Constants.INVALID, true, isTrash);
          result.push(...mediaItems);
        } else {
          result.push(mediaArray[i]);
        }
      }
      const assets = result.map(item => item.data);
      if (inverseSelection && !isTrash && DeviceInfo.isPc() && !this.isBeyondLimit) {
        this.getSelectAllData(assets);
      }
      callback(assets);
    };
    Log.info(TAG, `selectmanager inversion ` + inverseSelection);
    // 在RealTimeSearchSlotItem页面，全选不能选择全部数据，而是页面的那些数据
    if (inverseSelection && !this.isRealTimeSearchSlotItemPage) {
      // 反选场景需要查询数据源中的所有项目，然后排除clickedSet中的元素
      this.photoDataImpl?.getData(new AssetSelectManagerCallback(clickedSet, newCallback), {
        albumUri: this.albumUri,
        fetchType: FetchType.EMPTY,
        albumUris: this.albumInfo?.unionAlbumUris,
        start: start,
        count: count,
      });
    } else if (inverseSelection && this.isRealTimeSearchSlotItemPage) {
      const mediaArray = this.dataSource?.items;
      if (!mediaArray) {
        return;
      }
      Log.info(TAG, `batchGetSelectAssetsWidthBurstPhotos, mediaArray: ${mediaArray.length}`)
      if (mediaArray.length > this.totalCount) {
        newCallback(mediaArray.slice(0, this.totalCount));
      } else {
        newCallback(mediaArray);
      }
    } else {
      const mediaArray: MediaItem[] = Array.from(this.selectedMap.values())
        .filter(item => item && clickedSet.has(item.uri));
      newCallback(mediaArray);
    }
  }

  /**
   * 全选数据存入撤销栈中
   * @param assets 数据源
   */
  private getSelectAllData(assets: (photoAccessHelper.PhotoAsset | undefined)[]): void {
    let tempPhotoAsset: PhotoAsset[] = [];
    assets.forEach(item => {
      if (item !== undefined) {
        tempPhotoAsset.push(item);
      }
    })
    Log.info(TAG, `tempPhotoAsset: ${tempPhotoAsset.length}, assets: ${assets.length}`);
    this.batchSelectAll.push(tempPhotoAsset);
    if (this.batchSelectAll.length >= SELECT_ALL_COUNT_LIMIT) {
      Log.warn(TAG, 'selectAllData count beyond limit');
      this.batchSelectAll = [];
      this.isBeyondLimit = true;
    }
  }

  private batchQueryData(loopIndex: number, totalCount: number, callback: Function,
    result: MediaItem[], isTrash?: boolean): void {
    if (loopIndex < totalCount) {
      Log.info(TAG, `batchQueryData loopIndex: ${loopIndex}, totalCount: ${totalCount}`);
      loopIndex++;
      const currentStart = (loopIndex - 1) * LOOP_BATCH_COUNT_LIMIT;
      const currentCount = LOOP_BATCH_COUNT_LIMIT;
      Log.info(TAG, `batchQueryData query start: ${currentStart}, count: ${currentCount}`);
      this.photoDataImpl?.getData(new AssetSelectManagerCallback(this.clickedSet, async (mediaArray: MediaItem[]) => {
        Log.info(TAG, `batchQueryData received ${mediaArray.length} items, clickedSet.size: ${this.clickedSet.size}`);
        for (let i: number = 0; i < mediaArray.length; i++) {
          if (!mediaArray[i]) {
            Log.error(TAG, `mediaArray ${i} is undefined`);
            continue;
          }
          if (mediaArray[i].getIsBurstPhotos() && this.photoDataImpl?.getDataByBurstKey) {
            const mediaItems = await this.photoDataImpl.getDataByBurstKey(mediaArray[i].burstKey as string,
              Constants.INVALID, Constants.INVALID, true, isTrash);
            result.push(...mediaItems);
          } else {
            result.push(mediaArray[i]);
          }
        }
        Log.info(TAG, `batchQueryData result.length: ${result.length}, continuing to next batch`);
        this.batchQueryData(loopIndex, totalCount, callback, result, isTrash);
      }), {
        albumUri: this.albumUri,
        fetchType: FetchType.EMPTY,
        albumUris: this.albumInfo?.unionAlbumUris,
        start: currentStart,
        count: currentCount,
      });
    } else {
      Log.info(TAG, `batchQueryData loopIndex: ${loopIndex}, totalCount: ${totalCount}, all batches completed, result.length: ${result.length}`);
      callback(result);
    }
  }

  public async getSelectedItems(callback: Function): Promise<void> {
    let result: MediaItem[] = [];
    Log.info(TAG, `getSelectedItems this.inverseSelection: ${this.inverseSelection}`);
    if (!this.inverseSelection) {
      let result: MediaItem[] = [];
      result = Array.from(this.selectedMap.values());
      Log.info(TAG, `getSelectedItems result length:${result.length}`);
      callback(result);
      return;
    }
    await this.getMediaItems(0, this.totalCount, FetchType.DATE_INFO, (temp: MediaItem[]) => {
      temp.forEach((item, index) => {
        item.mPosition = index;
        if (item && !this.clickedSet.has(item.uri)) {
          result.push(item);
        }
      });
      Log.info(TAG, `enter callback result ${result.length}`);
      callback(result);
    });
  }

  private async getMediaItems(start: number, count: number, fetchType: FetchType,
    callbackFunc: Function): Promise<void> {
    if (this.isGetItemsFromDataSource && this.dataSource) {
      this.getItemsFromDataSource(this.dataSource, start, count, (items: MediaItem[]): void => callbackFunc(items));
      return;
    }
    if (this.photoDataImpl) {
      await this.getItems(this.photoDataImpl, start, count, fetchType,
        (items: MediaItem[]): void => callbackFunc(items));
      return;
    }
    Log.warn(TAG,
      `getMediaItems failed:  no dataImpl or dataSource, isGetItemsFromDataSource:${this.isGetItemsFromDataSource}`);
  }

  /* instrument ignore next */
  public async getItems(photoDataImpl: BrowserDataInterface | undefined, start: number, count: number, fetchType:
    FetchType, callbackFunc: Function):
    Promise<void> {
    let albumUris: string[] | undefined = this.albumInfo?.unionAlbumUris;
    if (this.isPickerUsedSubwindow) {
      albumUris = this.selectParam?.unionAlbumUris;
      fetchType = FetchType.NORMAL;
      this.needCheckCloudImage = true;
    }
    Log.info(TAG, `getItems start: ${start} count: ${count}
      fetchType: ${fetchType} albumUri: ${this.albumUri} albumUris: ${albumUris}`);
    let cb: AsyncCallback<MediaItem[]> = {
      callback: (t: MediaItem[]) => {
        //注意命名不要冲突
        callbackFunc(t);
      }
    };
    photoDataImpl?.getData(cb, {
      albumUri: this.albumUri,
      albumUris: albumUris,
      start: start,
      count: count,
      fetchType: fetchType,
    });
  }

  private getItemsFromDataSource(mediaDataSource: MediaDataSource | undefined, start: number, count: number,
    callbackFunc: Function): void {
    if (!mediaDataSource) {
      Log.error(TAG, 'getItemsFromDataSource params is invalid, return');
      return;
    }
    Log.info(TAG, `getItemsFromDataSource start from dataSource: ${start} count: ${count}`);
    let items: MediaItem[] = [];
    let realCount: number = Math.min(count, mediaDataSource.totalCount() - start);
    for (let i: number = 0; i < realCount; i++) {
      let index: number = i + start;
      items.push(mediaDataSource.getMediaItemSafely(index));
    }
    callbackFunc(items);
  }

  public getClassName(): string {
    return 'SelectManager';
  }

  public setGetMediaItemFunc(func: Function): void {
    this.getMediaItemFunc = func;
  }

  public releaseGetMediaItemFunc(func?: Function): void {
    if (!func) {
      this.getMediaItemFunc = undefined;
      return;
    }
    if (this.getMediaItemFunc === func) {
      this.getMediaItemFunc = undefined;
    }
  }

  public setGetMediaItemsFunc(func: Function): void {
    this.getMediaItemsFunc = func;
  }

  public releaseGetMediaItemsFunc(): void {
    this.getMediaItemsFunc = undefined;
  }

  /**
   * 根据图库资源Id返回索引位置
   * @param targetId 图库资源Id
   * @returns 图库资源所在的位置
   */
  /* instrument ignore next */
  public getSelectItemIndexByUri(targetId: string): number {
    let index = 0;
    for (let selectItem of this.selectedMap.keys()) {
      if (targetId === selectItem) {
        return index;
      }
      index++;
    }
    return Constants.INVALID;
  }

  public getSelectMediaItemByUri(uri: string): MediaItem | undefined {
    for (let selectItem of this.selectedMap.values()) {
      if (uri === selectItem.uri) {
        return selectItem;
      }
    }
    return undefined;
  }

  /* instrument ignore next */
  public getShowIndexByUri(targetId: string): number {
    if (!this.totalSelectedItemUriList || this.totalSelectedItemUriList.length === 0) {
      Log.info(TAG, 'getShowIndexByUri');
      let index: number = this.getSelectItemIndexByUri(targetId);
      return index;
    }
    let index1: number = this.totalSelectedItemUriList?.indexOf(targetId);
    Log.info(TAG, `getShowIndexByUri, index1 =${index1}`);
    return index1;
  }

  public getShowIndexByUriAndPickerIndex(targetId: string, pickerIndex: number): number {
    if (!this.totalSelectedItemUriWithPickerIndex || this.totalSelectedItemUriWithPickerIndex.length === 0) {
      let index: number = this.getSelectItemIndexByUri(targetId);
      return index;
    }
    let index1: number = this.totalSelectedItemUriWithPickerIndex?.findIndex(
      item => item.uri === targetId && this.isPickerIndexMatch(pickerIndex, item.preselectablePickerIndex)
    );
    return index1;
  }

  /**
   * isPickerIndexMatch
   *
   * @param pickerIndex index of the Picker
   * @param itemPickerIndex index of the item
   * @returns boolean true if picker index or item index is -1 or equal to each other
   */
  public isPickerIndexMatch(pickerIndex: number | undefined, itemPickerIndex: number | undefined): boolean {
    return itemPickerIndex === Constants.INVALID ||
      pickerIndex === Constants.INVALID ||
      itemPickerIndex === pickerIndex;
  }

  /* instrument ignore next */
  public updateTotalSelectUris(targetId: string, isSelected: boolean): void {
    if (!targetId) {
      return;
    }
    if (isSelected) {
      this.totalSelectedItemUriList?.push(targetId);
      if (this.isPickerIndexSet) {
        this.totalSelectedItemUriWithPickerIndex.push({
          uri: targetId,
          preselectablePickerIndex: this.selectParam?.pickerIndex
        });
      }
      return;
    }
    if (this.selectParam?.isRepeatSelectSupported && this.totalSelectedItemUriList?.length > 0) {
      for (let index = this.totalSelectedItemUriList?.length - 1; index >= 0; index--) {
        if (this.totalSelectedItemUriList[index] === targetId) {
          this.totalSelectedItemUriList.splice(index, 1);
          break;
        }
      }
    } else {
      this.totalSelectedItemUriList = this.totalSelectedItemUriList?.filter((item: string) => {
        return item !== targetId;
      });
    }
    if (this.totalSelectedItemUriWithPickerIndex?.length > 0) {
      const index = this.totalSelectedItemUriWithPickerIndex.findIndex(item => {
        return item.uri === targetId && item.preselectablePickerIndex === this.selectParam?.pickerIndex
      });
      if (index !== Constants.INVALID) {
        this.totalSelectedItemUriWithPickerIndex.splice(index, 1);
      }
    }
  }

  /**
   * 根据上次选中的数据对selectedMap重新排序
   * @param preSequence 上次选中的图库资源Id列表
   */
  /* instrument ignore next */
  public selectedMapSortByPreSequence(preSequence: string[]): void {
    if (preSequence.length > 0) {
      let temp = Array.from(this.selectedMap);
      let newSequence = temp.sort((a, b) => preSequence.findIndex(o => o ===
      a[0]) - preSequence.findIndex(o => o === b[0]));
      this.selectedMap = new Map(newSequence);
    }
  }

  /**
   * 根据上次选中的数据对clickedSet重新排序
   * @param preSequence 上次选中的图库资源Id列表
   */
  /* instrument ignore next */
  public clickedSetSortByPreSequence(preSequence: string[]): void {
    if (preSequence.length > 0) {
      let temp = Array.from(this.clickedSet);
      let newSequence = temp.sort((a, b) => preSequence.findIndex(o => o === a) - preSequence.findIndex(o => o === b));
      this.clickedSet = new Set(newSequence);
    }
  }

  /**
   * 删除首尾数据
   */
  public deSelectHeadTailPosition(isDoSelectAll?: boolean): void {
    Log.info(TAG, `deSelectHeadTailPosition isDoSelectAll: ${isDoSelectAll}`);
    this.headTailPosition.headPosition = undefined;
    this.headTailPosition.tailPosition = undefined;
    this.deSelectAll(isDoSelectAll);
    return;
  }

  /**
   * 接续场景下删除首尾数据
   */
  public deSelectHeadTailPositionKeep(): void {
    this.headTailPosition.headPosition = undefined;
    this.headTailPosition.tailPosition = undefined;
  }

  /**
   * 选中节点并刷新
   * @param temp
   * @returns
   */
  /* instrument ignore next */
  protected getHeadToTailData(temp: MediaItem[] | AlbumInfo[]): void {
    if (temp.length === 0) {
      Log.error(TAG, 'getHeadToTailData exec fail because data length is zero');
      return;
    }
    Log.info(TAG, `getHeadToTailData`)
    this.deSelectAll();
    for (let item of temp) {
      if (!item || !item.uri) {
        continue;
      }
      this.clickedSet.add(item.uri);
      this.selectedMap.set(item.uri, item as MediaItem);
      this.updateUnFavorItemCount((item as MediaItem)?.data, true);
    }
    if (this.totalCount === this.getSelectedCount()) {
      this.isAllSelected = true;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(true);
    } else {
      this.isAllSelected = false;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(false);
    }
    this.updateCount();
    return;
  }

  /**
   * 获取从头到尾所有节点信息
   * @param headPosition
   * @param endPosition
   * @param callback
   * @returns
   */
  /* instrument ignore next */
  protected async getImageFromHeadToTail(headPosition: PositionInfo,
    endPosition: PositionInfo, callback: Function): Promise<void> {
    try {
      await this.getMediaItems(headPosition.index,
        endPosition.index - headPosition.index + 1, FetchType.DATE_INFO,
        (temp: MediaItem[]) => {
          this.getHeadToTailData(temp);
          callback();
          return;
        });
    } catch (err) {
      Log.error(TAG, `get Item error, message: ${err.message}, error code: ${
      err.code}, headindex: ${headPosition.index}, endindex: ${endPosition.index}`);
    }
  }

  /**
   * 选择从头到尾图片
   * @param headPosition
   * @param endPosition
   * @param callback
   * @returns
   */
  /* instrument ignore next */
  protected selectImageFromHeadToTail(headPosition: PositionInfo, endPosition: PositionInfo,
    callback: Function): void {
    Log.info(TAG, `selectImageFromHeadToTail head:${headPosition.index} ,tail=${endPosition.index}`);
    let tempHead: PositionInfo = headPosition;
    let tempEnd: PositionInfo = endPosition;
    if (headPosition.index > endPosition.index) {
      tempHead = endPosition;
      tempEnd = headPosition;
    }
    this.getImageFromHeadToTail(tempHead, tempEnd,
      (): void => {
        callback();
      });
  }

  /**
   * 根据按键按压状态选中图片
   * @param id
   * @param index
   * @param isNowSelected
   * @param callback
   */
  /* instrument ignore next */
  private setKeyOperation(id: string, index: number, isNowSelected: boolean,
    callback: Function): void {
    // 未点击shift/ctrl键时，更新首节点，初始化尾结点
    if (!AppStorage.get<boolean>(Constants.KEY_OF_IS_SHIFT_PRESS) &&
      !AppStorage.get<boolean>(Constants.KEY_OF_IS_CTRL_PRESS)) {
      this.headTailPosition.headPosition = {
        id: id,
        index: index,
      };
      this.headTailPosition.tailPosition = undefined;
      this.toggle(id, isNowSelected, index);
      callback(isNowSelected);
      return;
    }
    // 点击ctrl键时，更新首节点，初始化尾结点
    if (!AppStorage.get<boolean>(Constants.KEY_OF_IS_SHIFT_PRESS) &&
    AppStorage.get<boolean>(Constants.KEY_OF_IS_CTRL_PRESS)) {
      this.headTailPosition.headPosition = {
        id: id,
        index: index,
      };
      this.headTailPosition.tailPosition = undefined;
      this.toggle(id, isNowSelected, index);
      callback(isNowSelected);
      return;
    }
    // 点击shift键时，如果首节点不存在，更新首节点，否则不对首节点更新
    if (this.headTailPosition.headPosition === undefined) {
      this.headTailPosition.headPosition = {
        id: id,
        index: index,
      };
      this.headTailPosition.tailPosition = undefined;
      this.toggle(id, isNowSelected, index);
      callback(isNowSelected);
      return;
    }
    this.headTailPosition.tailPosition = {
      id: id,
      index: index,
    };
    this.selectImageFromHeadToTail(this.headTailPosition.headPosition, this.headTailPosition.tailPosition,
      () => {
        this.toggle(id, isNowSelected, index);
        callback(isNowSelected);
      });
    return;
  }


  /**
   * 获取最终选中状态
   * @param isNowSelected
   * @returns
   */
  /* instrument ignore next */
  public getEndSelected(isNowSelected: boolean): boolean {
    if (!DeviceInfo.isPcOrTablet()) {
      return false;
    }
    if (AppStorage.get(Constants.KEY_OF_IS_CTRL_PRESS) && !isNowSelected) {
      return false;
    }
    return true;
  }

  /**
   * 设置首尾节点
   * @param isSelectedMode
   * @param id
   * @param index
   * @param callback
   */
  /* instrument ignore next */
  public setImageHeadTailPosition(isSelectedMode: boolean, value: boolean, id: string, index: number,
    callback: Function): void {
    let isNowSelected: boolean = value;
    if (!isSelectedMode) {
      isNowSelected = this.getEndSelected(isNowSelected);
    }
    if (!isSelectedMode && !AppStorage.get<boolean>(Constants.KEY_OF_IS_CTRL_PRESS) &&
      !AppStorage.get<boolean>(Constants.KEY_OF_IS_SHIFT_PRESS)) {
      this.deSelectAll();
    }
    if (!id || index < 0) {
      this.toggle(id, isNowSelected, index);
      callback(isNowSelected);
      return;
    }
    this.setKeyOperation(id, index, isNowSelected, callback);
    return;
  }

  public async getSelectedUri(): Promise<string[]> {
    if (this.inverseSelection) {
      return new Promise((resolve, reject) => {
        // 反选场景需要查询数据源中的所有项目，然后排除clickedSet中的元素
        let callback: AsyncCallback<string[]> = {
          callback: (uriList: string[]) => resolve(uriList),
        };
        this.photoDataImpl?.getData(new SelectManagerCallback(this.clickedSet, callback), {
          albumUri: this.albumUri,
          albumUris: this.albumInfo?.unionAlbumUris,
          fetchType: FetchType.EMPTY,
        });
      });
    } else {
      return Array.from(this.clickedSet);
    }
  }
}

export class SelectManagerCallback implements AsyncCallback<MediaItem[]> {
  readonly clickedSet: Set<string> = new Set();
  readonly subCallback: AsyncCallback<string[]>;

  constructor(clickedSet: Set<string>, callback: AsyncCallback<string[]>) {
    if (clickedSet) {
      clickedSet.forEach(item => this.clickedSet.add(item));
    }
    this.subCallback = callback;
  }

  public callback(mediaItems: MediaItem[]): void {
    if (!this.subCallback) {
      return;
    }
    let result: string[] = [];
    mediaItems.forEach((mediaItem) => {
      if (mediaItem && !this.clickedSet.has(mediaItem.uri)) {
        result.push(mediaItem.uri);
      }
    });
    this.subCallback.callback(result);
  }
}

export class AssetSelectManagerCallback {
  readonly clickedSet: Set<string> = new Set();
  readonly callbackFunc: Function;

  constructor(clickedSet: Set<string>, callback: Function) {
    if (clickedSet) {
      clickedSet.forEach(item => this.clickedSet.add(item));
    }
    this.callbackFunc = callback;
  }

  public callback(mediaItems: MediaItem[]): void {
    if (!this.callbackFunc) {
      return;
    }
    let result: MediaItem[] = [];
    mediaItems.forEach((mediaItem) => {
      if (mediaItem && !this.clickedSet.has(mediaItem.uri)) {
        result.push(mediaItem);
      }
    });
    this.callbackFunc(result);
  }
}

export class ThirdSelectManager extends SelectManager {
  public type?: string;
  public isMultiPick?: boolean;
  public indexMap: Map<MediaItem, number> = new Map();
  public previewSet: Set<string> = new Set();
  public isPreview: boolean = false;
  public preSelectItemUriList: string[] = [];
  private readonly QUERY_BATCH_SIZE: number = 100;
  private tasks: taskpool.Task[] = [];

  constructor() {
    super();
  }

  public setType(type: string): void {
    this.type = type;
  }

  public getType(): string | undefined {
    return this.type;
  }

  public setIsMultiPick(isMultiPick: boolean): void {
    this.isMultiPick = isMultiPick;
  }

  public getIsMultiPick(): boolean | undefined {
    return this.isMultiPick;
  }

  public getSelectedSet(): Set<string> {
    return super.clickedSet;
  }

  /**
   * 初始化图库图片预选择
   *
   * @param targetIdList 预选择图库资源Id
   */
  /* instrument ignore next */
  public async initPreSelectPhotos(targetIdList: string[], isHighlightPickerView: boolean = false): Promise<void> {
    this.reportPickerIndexBigData(targetIdList);
    this.deSelectAll();
    if (isHighlightPickerView) {
      targetIdList.forEach((targetId: string): void => {
        this.clickedSet.add(targetId);
      });
    }
    this.totalSelectedItemUriList = Array.from(targetIdList);
    this.preSelectItemUriList = [...targetIdList];

    const chunkSize = this.QUERY_BATCH_SIZE;
    const newArrays: string[][] = [];
    // 做分批查询，一批最大查询数量为100
    for (let i = 0; i < targetIdList.length; i += chunkSize) {
      newArrays.push(targetIdList.slice(i, i + chunkSize));
    }

    this.setSecondarySelectionStatus(true);
    Log.info(TAG, `newArrays length is : ${newArrays.length}`);
    TraceControllerUtils.startTrace(`getItemsTask`);
    for (let uriArray of newArrays) {
      try {
        let array: collections.Array<SendableMediaItem> = new collections.Array<SendableMediaItem>();
        let task1: taskpool.Task = new taskpool.Task(getItemsTask, getContext(), uriArray, array);
        await taskpool.execute(task1, taskpool.Priority.HIGH) as SendableMediaItem[];
        this.tasks.push(task1);

        let mediaItems: MediaItem[] = SendableMediaItem.createMediaItems(array);
        if (mediaItems.length > 0) {
          mediaItems.forEach((mediaItem: MediaItem): void => {
            mediaItem.setThumbnail(ImageUtil.getThumbnailUri(mediaItem.uri, mediaItem.path,
              mediaItem.getDateModified(), false, mediaItem.getThumbnailReady()));
          })
        }
        Log.info(TAG, ` mediaItems size=${mediaItems.length}`);
        this.setSelectedMap(mediaItems);
      } catch (error) {
        Log.info(TAG, `error=${toString(error)}`);
      }
    }
    TraceControllerUtils.finishTrace(`getItemsTask`);
    this.selectedMapSortByPreSequence(this.preSelectItemUriList);
    this.clickedSetSortByPreSequence(this.preSelectItemUriList);
  }

  private reportPickerIndexBigData(targetIdList: string[]) {
    if (this.selectParam?.pickerIndex && this.selectParam.preselectedInfos.length > 0) {
      Log.info(TAG, 'params.pickerIndex report');
      let msg: Record<string, number | string | boolean> = {
        'PICKER_INDEX': this.selectParam.pickerIndex ? 1 : 0,
        'PRESELECTED_INFO_LENGTH': this.selectParam.preselectedInfos?.length,
        'PRESELECTED_INFO_LENGTH_MATCHED': targetIdList?.length
      };
      ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_INDEX, msg);
    }
  }

  public clearTaskMission(): void {
    this.tasks.forEach((task: taskpool.Task): void => {
      if (!task && !(task as taskpool.Task).isDone()) {
        taskpool.cancel(task);
        Log.info(TAG, `targetIdList query task is canceled.`);
      }
    })
  }

  private setSelectedMap(mediaItems: MediaItem[]): void {
    for (let index = 0; index < mediaItems.length; index++) {
      let mediaItem: MediaItem = mediaItems[index];
      try {
        if (mediaItem) {
          this.indexMap.set(mediaItem, Number.NaN);
          super.toggle(mediaItem?.uri, true, undefined, mediaItem);
        }
      } catch (error) {
        Log.error(TAG, `error=${toString(error)}`);
      }
    }
  }

  /* instrument ignore next */
  public updateSelectUris(targetIdList: string[], filterDuplicates: boolean = true): void {
    this.reportPickerIndexBigData(targetIdList);
    if (!targetIdList) {
      return;
    }
    if (targetIdList.length >= Constants.PICKER_LONG_LOG_LIMIT_SIZE) {
      Log.info(TAG, `updateSelectUris: ${targetIdList?.length}`);
    } else {
      Log.info(TAG, `updateSelectUris: ${targetIdList?.toString()}`);
    }
    if (this.selectParam && targetIdList.length > this.selectParam?.maxSelectCount) {
      targetIdList = targetIdList.slice(0, this.selectParam?.maxSelectCount);
    }

    // 去重
    if (!this.selectParam?.isRepeatSelectSupported && filterDuplicates) {
      targetIdList = targetIdList?.filter((item, index, array) => {
        return array.indexOf(item) === index;
      });
    }
    if (this.totalSelectedItemUriList.length === targetIdList.length) {
      targetIdList.forEach((targetId: string): void => {
        this.clickedSet.delete(targetId);
      });
    }
    Log.info(TAG, `updateSelectUris: ${this.totalSelectedItemUriList.length}; ${this.clickedSet.size}`);
    this.totalSelectedItemUriList = targetIdList;
    this.setSecondarySelectionStatus(true);
    let tempClickedSet: Set<string> = new Set();
    this.clickedSet.forEach((targetId: string): void => {
      tempClickedSet.add(targetId);
    });

    // 筛选出新增的，做增量刷新
    targetIdList?.forEach((targetId: string): void => {
      if (tempClickedSet.has(targetId)) {
        tempClickedSet.delete(targetId);
      } else {
        super.toggle(targetId, true);
      }
    });

    // 筛选出减少的的，做减量刷新
    tempClickedSet.forEach((targetId: string): void => {
      super.toggle(targetId, false);
    });
  }

  /**
   * 针对指定mediaItem预加载缓存
   *
   * @param targetId 图库资源Id
   * @param isSelected 图库资源是否被选中
   * @param mediaItem mediaItem
   * @returns 是否成功
   */
  /* instrument ignore next */
  public toggleWithItem(targetId: string, isSelected: boolean, mediaItem: MediaItem): boolean {
    if (mediaItem) {
      let containsUri = this.selectedMap.has(targetId);
      if (isSelected && !containsUri) {
        this.selectedMap.set(targetId, mediaItem);
        this.indexMap.set(mediaItem, Number.NaN);
        this.clickedSet.add(targetId);
        this.selectedMapSortByPreSequence(this.preSelectItemUriList);
        this.clickedSetSortByPreSequence(this.preSelectItemUriList);
      }
      return super.toggle(targetId, isSelected, undefined);
    }
    return false;
  }

  public toggleForSelectBrowser(targetId: string, isSelected: boolean, targetIndex?: number): boolean {
    return this.toggle(targetId, isSelected, targetIndex);
  }

  public toggle(targetId: string, isSelected: boolean, targetIndex?: number): boolean {
    if (this.getMediaItemFunc) {
      let containsUri = this.selectedMap.has(targetId);
      if (isSelected && !containsUri) {
        let mediaItem: MediaItem = this.getMediaItemFunc(targetId, (photoItem: MediaItem) => {
          this.selectedMap.set(targetId, photoItem);
          this.indexMap.set(photoItem, targetIndex ?? Number.NaN);
        });
        if (mediaItem) {
          this.selectedMap.set(targetId, mediaItem);
          this.indexMap.set(mediaItem, targetIndex ?? Number.NaN);
        }
      }
      if (!isSelected && containsUri) {
        this.selectedMap.delete(targetId);
        this.indexMap.delete(this.getMediaItemFunc(targetId));
      }
    }

    if (this.isPreview) {
      return this.togglePreview(targetId, isSelected, targetIndex);
    }

    return super.toggle(targetId, isSelected, targetIndex);
  }

  /**
   * 编辑后修改已选列表当前项
   * @param targetId
   * @param targetIndex
   */
  private toggleEditUpdateCurSelectItem(targetId: string, targetIndex?: number) {
    if (!this.getMediaItemFunc) {
      Log.error(TAG, `toggleEditUpdateCurSelectItem getMediaItemFunc dose not exist`)
      return;
    }
    const mediaItem: MediaItem | undefined = this.getMediaItemFunc(targetId);

    if (!mediaItem) {
      Log.error(TAG, `toggleEditUpdateCurSelectItem invalid mediaItem`)
    } else {
      this.selectedMap.set(targetId, mediaItem);
      this.indexMap.set(mediaItem, targetIndex ?? Number.NaN);
    }
  }

  /* instrument ignore next */
  public toggleEdit(targetId: string, isSelected: boolean, targetIndex?: number,
    oldSelectedMovingPhotoUri?: string): boolean {
    if (this.getMediaItemFunc) {
      const containsUri = this.selectedMap.has(targetId);
      if (isSelected && (!containsUri || targetIndex != null)) {
        if (oldSelectedMovingPhotoUri && targetIndex && oldSelectedMovingPhotoUri) {
          this.dealMovingPhotoMap(oldSelectedMovingPhotoUri, targetId, targetIndex);
          this.updateTotalSelectUris(oldSelectedMovingPhotoUri, false);
          this.clickedSet.delete(oldSelectedMovingPhotoUri);
        } else {
          this.toggleEditUpdateCurSelectItem(targetId, targetIndex)
        }
      }
      if (!isSelected && containsUri) {
        this.selectedMap.delete(targetId);
        this.indexMap.delete(this.getMediaItemFunc(targetId));
      }
    }

    if (this.isPreview) {
      let result: boolean = this.togglePreview(targetId, isSelected, targetIndex);
      // 优先将数据同步
      this.clickedSet.clear();
      for (let item of this.previewSet) {
        this.clickedSet.add(item as string);
      }
      return result;
    }

    return super.toggle(targetId, isSelected, targetIndex);
  }

  private dealMovingPhotoMap(oldSelectedMovingPhotoUri: string, targetId: string, targetIndex: number): void {
    let newSelectedMap: Map<string, MediaItem> = new Map();
    if (this.getMediaItemFunc) {
      const mediaItem: MediaItem = this.getMediaItemFunc(targetId);
      this.selectedMap.forEach((item, key) => {
        if (key === oldSelectedMovingPhotoUri) {
          newSelectedMap.set(targetId, mediaItem);
        } else {
          newSelectedMap.set(key, item);
        }
      });
      this.selectedMap = newSelectedMap;
      let newIndexMap: Map<MediaItem, number> = new Map();
      this.indexMap.forEach((key, item) => {
        if (item.uri === oldSelectedMovingPhotoUri) {
          newIndexMap.set(mediaItem, targetIndex ?? Number.NaN);
        } else {
          newIndexMap.set(item, key);
        }
      });
      this.indexMap = newIndexMap;
    }
  }

  /* instrument ignore next */
  public toggleEditThree(targetId: string, isSelected: boolean, mediaItem: MediaItem, targetIndex?: number): boolean {
    let containsUri = this.selectedMap.has(targetId);
    if (isSelected && !containsUri) {
      this.selectedMap.set(targetId, mediaItem);
      this.indexMap.set(mediaItem, targetIndex ?? Number.NaN);
    }
    if (!isSelected && containsUri) {
      this.selectedMap.delete(targetId);
      this.indexMap.delete(mediaItem);
    }

    if (this.isPreview) {
      let result: boolean = this.togglePreview(targetId, isSelected, targetIndex);
      // 优先将数据同步
      this.clickedSet.clear();
      for (let item of this.previewSet) {
        this.clickedSet.add(item as string);
      }
      return result;
    }

    return super.toggle(targetId, isSelected, targetIndex);
  }

  public deSelectAll(isDoSelectAll?: boolean): void {
    this.selectedMap.clear();
    this.indexMap.clear();
    this.previewSet.clear();
    super.deSelectAll(isDoSelectAll);
  }

  /* instrument ignore next */
  public getSelectItemIndex(item: MediaItem): number {
    if (!item) {
      Log.error(TAG, 'getSelectItemIndex: item is undefined');
      return Constants.INVALID;
    }
    if (!this.selectedMap) {
      Log.error(TAG, 'getSelectItemIndex: selectedMap is undefined');
      return Constants.INVALID;
    }
    let index = 0;
    for (let selectItem of this.selectedMap.values()) {
      if (item.uri === selectItem?.uri) {
        return index;
      }
      index++;
    }
    return Constants.INVALID;
  }

  public getSelectedItem(selectedItemUri: string): MediaItem | undefined {
    let selectedItem: MediaItem | undefined = Array.from(this.selectedMap.values()).find(item => {
      return item?.uri === selectedItemUri;
    })
    return selectedItem;
  }

  /* instrument ignore next */
  public getSelectItemDataSourceIndex(item: MediaItem): number | undefined {
    return this.indexMap.get(item) ? this.indexMap.get(item) : Constants.INVALID;
  }

  /* instrument ignore next */
  public checkItemInSelectMap(item: MediaItem): number {
    let index = -1;
    for (let selectItem of this.selectedMap.values()) {
      index++;
      if (item.uri === selectItem.uri) {
        return index;
      }
    }
    return -1;
  }

  public getSelectItems(): MediaItem[] {
    let itemArray: MediaItem[] = [];
    if (this.selectedMap.size === 0) {
      return itemArray;
    }
    for (let item of this.selectedMap.values()) {
      itemArray.push(item);
    }
    return itemArray;
  }

  public getClassName(): string {
    return 'ThirdSelectManager';
  }

  /* instrument ignore next */
  public refreshData(): void {
    this.mCallbacks.has('refreshData') && this.mCallbacks.get('refreshData')?.(true);
  }

  /* instrument ignore next */
  public isSelected(uri: string): boolean {
    if (this.isPreview) {
      return this.previewSet.has(uri);
    } else {
      return this.clickedSet.has(uri);
    }
  }

  /* instrument ignore next */
  public isItemSelected(targetId: string, index?: number): boolean {
    Log.info(TAG, `isItemSelected ${targetId}, ${index}, ${this.isPreview}`);
    if (this.isPreview) {
      return this.previewSet.has(targetId);
    } else {
      return super.isItemSelected(targetId, index);
    }
  }

  public getSelectedCount(): number {
    if (this.isPreview) {
      return this.previewSet.size;
    }
    if (this.selectParam?.isFromPickerView && this.selectParam?.isRepeatSelectSupported) {
      return this.inverseSelection ?
        this.totalCount - this.totalSelectedItemUriList.length : this.totalSelectedItemUriList.length;
    } else {
      return this.inverseSelection ? this.totalCount - this.clickedSet.size : this.clickedSet.size;
    }
  }

  /* instrument ignore next */
  public togglePreview(targetId: string, isSelected: boolean, targetIndex?: number): boolean {
    Log.info(TAG, `togglePreview ${targetId} ${isSelected} ${targetIndex}`);
    if (targetId == null) {
      return true;
    }

    if (isSelected) {
      this.previewSet.add(targetId);
      Log.info(TAG, `add targetID ${targetId}`);
    } else {
      this.previewSet.delete(targetId);
    }
    if (this.totalCount === this.getSelectedCount()) {
      this.isAllSelected = true;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(true);
    } else {
      this.isAllSelected = false;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(false);
    }
    this.updateCount();
    if (targetIndex !== undefined) {
      this.mCallbacks.has('select') && this.mCallbacks.get('select')?.(targetIndex);
    }
    return true;
  }
}

/* instrument ignore next */
export class TimelineSelectManager extends SelectManager {
  public mGroupData: TimelineData[] = [];
  public mIsDayGroupState: boolean = false;
  //具体的时间戳为map的key
  private mSelectionEntryMap: HashMap<number, BucketSelectionEntry> = new HashMap<number, BucketSelectionEntry>();
  private mSelectionDateKeyRangeMap: HashMap<number, number[]> = new HashMap<number, number[]>();
  private readonly DELETE_BATCH_SIZE: number = 1000;
  private readonly FIRST_BATCH: number = 1;
  private selectionMapCopy: HashMap<number, BucketSelectionEntry> = new HashMap<number, BucketSelectionEntry>();
  private totalCountForDelete: number = 0;
  private readonly UPDATE_DELAY: number = 300;
  private lastSelectModeTimeoutId: number = -1;
  private isGroupSelect: boolean = false;

  constructor() {
    super();
  }

  public selectAll(reverseSelection: boolean): void {
    this.isGroupSelect = true;
    if (!this.mIsDayGroupState) {
      super.selectAll(reverseSelection);
      return;
    }
    Log.info(TAG, `selectAll ${reverseSelection}`);
    if (reverseSelection) {
      this.inverseSelection = true;
      this.clearEntryArray();
    }
    this.isAllSelected = true;
    AppStorage.setOrCreate<boolean>('focusUpdate', true);
    this.mCallbacks.has('updateGroupCount') && this.mCallbacks.get('updateGroupCount')?.();
    this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(true);
    this.updateCount();
    ReportToBigDataUtil.report(BigDataConstants.SELECT_ALL_ID,
      { 'scenario': ReportToBigDataUtil.getPhotoBrowserScenario(PhotoInfo.scenarioIndex) });
  }

  public deSelectAll(isDoSelectAll?: boolean): void {
    if (!this.mIsDayGroupState) {
      super.deSelectAll(isDoSelectAll);
      return;
    }
    this.inverseSelection = false;
    this.isAllSelected = false;
    if (DeviceInfo.isPc()) {
      this.clickedSet.clear();
      this.selectedMap.clear();
    }
    this.unFavorItemCount = 0;
    this.clearEntryArray();
    AppStorage.setOrCreate<boolean>('focusUpdate', true);
    this.mCallbacks.has('updateGroupCount') && this.mCallbacks.get('updateGroupCount')?.();
    this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(false, isDoSelectAll);
    this.updateCount();
  }

  /**
   * 选中节点并刷新
   * @param temp
   * @returns
   */
  /* instrument ignore next */
  public getHeadToTailData(temp: MediaItem[] | AlbumInfo[]): void {
    Log.info(TAG, `getHeadToTailData temp length ${temp.length}`);
    if (!this.mIsDayGroupState || !DeviceInfo.isPc()) {
      return super.getHeadToTailData(temp);
    }
    if (temp.length === 0) {
      Log.error(TAG, 'getHeadToTailData exec fail because data length is zero');
      return;
    }
    this.deSelectAll();
    let count = this.mGroupData.length;
    let groupIndex = 0;
    let headPos = this.headTailPosition.headPosition?.index ?? 0;
    let tailPos = this.headTailPosition.tailPosition?.index ?? 0;
    let ptr = (headPos < tailPos) ? headPos : tailPos;
    let i = 0;
    for (; i < count; i++) {
      if (groupIndex < ptr) {
        groupIndex += this.mGroupData[i].count + 1;
      } else {
        break;
      }
    }
    for (let item of temp) {
      if (!item || !item.uri) {
        continue;
      }
      if (ptr === groupIndex) {
        if (i < count) {
          groupIndex += this.mGroupData[i].count + 1;
          i++;
        }
        ptr++;
      }
      let itemCoordinate = this.getCoordinateFromPosition(ptr++);
      if (!itemCoordinate.dateKey) {
        continue;
      }
      let entry = this.getGroupEntry(itemCoordinate);
      this.selectEntryItem(entry, item.uri, true, (item as MediaItem));
      let entrySelectedCount = entry.getSelectedCount();
      if (entrySelectedCount === entry.getTotalCount()) {
        entry.selectAll();
      }
      this.selectedMap.set(item.uri, item as MediaItem);
      this.clickedSet.add(item.uri);
    }

    this.mCallbacks.has('updateGroupCount') && this.mCallbacks.get('updateGroupCount')?.();
    if (this.totalCount === this.getSelectedCount()) {
      this.isAllSelected = true;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(true);
    } else {
      this.isAllSelected = false;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(false);
    }
    this.updateCount();
    return;
  }

  /**
   * 获取已选择图片的位置
   *
   * @returns 二维数组，已选中的图片所在的日期相较于全量数据集的范围
   */
  public getSelectedArray(): Array<Array<number>> {
    let ret: Array<Array<number>> = [];
    if (!this.mIsDayGroupState || !this.isGroupSelect) {
      ret.push([0, this.totalCount]);
      return ret;
    }
    this.mSelectionEntryMap.forEach((value, key) => {
      ret.push(this.mSelectionDateKeyRangeMap.get(key));
    });
    return ret;
  }

  private selectEntryItem(entry: BucketSelectionEntry, targetId: string, isSelected: boolean, item?: MediaItem): void {
    let select = isSelected !== this.inverseSelection;
    let clickSet = entry.getClickSet();
    let selectedMap = entry.getSelectedMap();
    if (select !== entry.getInverseSelection()) {
      if (item) {
        selectedMap.set(targetId, item);
      }
      clickSet.add(targetId);
    } else {
      selectedMap.delete(targetId);
      clickSet.delete(targetId);
    }
  }

  /**
   * 选择从头到尾图片
   * @param headPosition
   * @param endPosition
   * @param callback
   * @returns
   */
  /* instrument ignore next */
  public selectImageFromHeadToTail(headPosition: PositionInfo, endPosition: PositionInfo,
    callback: Function): void {
    if (!this.mIsDayGroupState || !DeviceInfo.isPc()) {
      return super.selectImageFromHeadToTail(headPosition, endPosition, callback);
    }
    let ptrHead: PositionInfo = headPosition;
    let ptrEnd: PositionInfo = endPosition;
    if (headPosition.index > endPosition.index) {
      ptrHead = endPosition;
      ptrEnd = headPosition;
    }
    // shift选择节点前面的title个数
    let beforeHeadCount = 1;
    let beforeTailCount = 1;
    let groupIndex = 0;
    for (let idx = 0; idx < this.mGroupData.length; idx++) {
      groupIndex += this.mGroupData[idx].count + 1;
      if (groupIndex < ptrHead.index) {
        beforeHeadCount++;
      }
      if (groupIndex < ptrEnd.index) {
        beforeTailCount++;
      } else {
        break;
      }
    }
    let beginIndex = (ptrHead.index - beforeHeadCount < 0) ? 0 : (ptrHead.index - beforeHeadCount);
    let endIndex = (ptrEnd.index - beforeTailCount < 0) ? 0 : (ptrEnd.index - beforeTailCount);
    let tempHead: PositionInfo = {
      id: ptrHead.id,
      index: beginIndex,
    };
    let tempEnd: PositionInfo = {
      id: ptrEnd.id,
      index: endIndex,
    };
    this.getImageFromHeadToTail(tempHead, tempEnd, (): void => {
      callback();
    });
  }

  // 获取选择的所有照片（包括连拍的非封面照片）
  public getSelectAssetsWidthBurstPhotos(callback: Function, isTrash?: boolean): void {
    if (!this.mIsDayGroupState) {
      super.getSelectAssetsWidthBurstPhotos(callback, isTrash);
      return;
    }
    const newCallback: Function = async (mediaArray: MediaItem[]) => {
      Log.info(TAG, `newCallback async start`);
      if (!this.photoDataImpl) {
        this.setPhotoDataImpl();
      }
      try {
        Log.info(TAG, `newCallback mediaArray length is ${mediaArray.length}`);
        const result: MediaItem[] = [];
        for (let i: number = 0; i < mediaArray.length; i++) {
          if (!mediaArray[i]) {
            Log.error(TAG, `mediaArray ${i} is undefined`);
            continue;
          }
          if (mediaArray[i].getIsBurstPhotos() && this.photoDataImpl?.getDataByBurstKey) {
            const mediaItems = await this.photoDataImpl.getDataByBurstKey(mediaArray[i].burstKey as string,
              Constants.INVALID, Constants.INVALID, true, isTrash);
            result.push(...mediaItems);
          } else {
            result.push(mediaArray[i]);
          }
        }
        Log.info(TAG, `newCallback result length is ${result.length}`);
        // const assets = result.map(item => item.data);
        // callback(assets);
      } catch (err) {
        Log.error(TAG, `failed to create assets in newCallback, code: ${err.code}, message: ${err.message}`);
      }

    };
    this.getSelected(FetchType.NORMAL, (uriTemp: string[], itemTemp: MediaItem[]) => {
      Log.info(TAG, `getSelected callback start`);
      newCallback(itemTemp);
      // 操作完成退出多选模式，清除选择数据(如果操作完无需清除选择数据，需要单独判断处理)
      if (!DeviceInfo.isPc()) {
        this.clearEntryArray();
      }
    });
  }

  public toggleWithCheckOriginalState(targetId: string, isSelected: boolean, targetIndex?: number): void {
    if (!targetId) {
      return;
    }
    if (this.isItemSelected(targetId, targetIndex) !== isSelected) {
      this.toggle(targetId, isSelected, targetIndex ?? 0);
    }
  }

  public toggleForSelectBrowser(targetId: string, isSelected: boolean, targetIndex?: number): boolean {
    if (!this.mIsDayGroupState) {
      return this.toggle(targetId, isSelected, targetIndex ?? 0);
    }
    let groupBefore: number = 0;
    if (this.getMediaItemFunc) {
      groupBefore = this.dataSourceProxy?.getGroupCountBeforeItem(this.getMediaItemFunc(targetId)) ?? 0;
      Log.info(TAG, `toggleInSelectBrowser: index ${targetIndex}, before: ${groupBefore}`);
    }
    let index: number = (targetIndex ?? 0) + groupBefore;
    return this.toggle(targetId, isSelected, index);
  }

  public toggle(targetId: string, isSelected: boolean, targetIndex: number): boolean {
    if (!this.mIsDayGroupState) {
      return super.toggle(targetId, isSelected, targetIndex);
    }
    let itemCoordinate = this.getCoordinateFromPosition(targetIndex);
    if (!itemCoordinate.dateKey) {
      return false;
    }
    let entry = this.getGroupEntry(itemCoordinate);
    this.toggleClickSet(entry, targetId, isSelected);
    let entrySelectedCount = entry.getSelectedCount();
    if (isSelected) {
      this.clickedSet.add(targetId);
    } else {
      this.clickedSet.delete(targetId);
    }
    if (this.getMediaItemFunc) {
      let mediaItem: MediaItem = this.getMediaItemFunc(targetId);
      if (mediaItem) {
        if (isSelected) {
          this.selectedMap.set(targetId, mediaItem);
          super.updateUnFavorItemCount(mediaItem.data, true);
        } else {
          this.selectedMap.delete(targetId);
          super.updateUnFavorItemCount(mediaItem.data, false);
        }
      }
    }

    if (entrySelectedCount === entry.getTotalCount()) {
      Log.info(TAG, 'group selectAll');
      entry.selectAll();
    }

    this.mCallbacks.has('updateGroupCount') && this.mCallbacks.get('updateGroupCount')?.(itemCoordinate.getDateKey());

    if (this.isAllSelected && (entrySelectedCount < entry.getTotalCount())) {
      this.isAllSelected = false;
      this.updateCount();
    }

    if (this.getSelectedCount() === this.totalCount) {
      this.isAllSelected = true;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(true);
      this.updateCount();
    } else {
      this.isAllSelected = false;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(false);
      this.updateCount();
    }
    if (targetIndex !== undefined) {
      this.mCallbacks.has('select') && this.mCallbacks.get('select')?.(targetIndex);
    }
    return true;
  }

  public toggleGroup(itemCoordinate: ItemCoordinate): boolean {
    Log.info(TAG, `check  toggleGroup: ${itemCoordinate.getDateKey()}, ${this.inverseSelection}`);
    this.isGroupSelect = true;
    if (this.inverseSelection) {
      let entryFromMap = this.mSelectionEntryMap.get(itemCoordinate.getDateKey());
      if (entryFromMap === undefined) {
        entryFromMap = this.getGroupEntry(itemCoordinate);
        entryFromMap.selectAll();
      } else {
        entryFromMap.changeSelectMode(true);
      }
    } else {
      this.getGroupEntry(itemCoordinate)?.changeSelectMode(false);
    }

    if (this.getSelectedCount() === this.totalCount) {
      this.selectAll(false);
    }
    this.mCallbacks.has('updateGroupCount') && this.mCallbacks.get('updateGroupCount')?.();
    this.updateCount();
    if (this.getSelectedCount() === this.totalCount) {
      this.isAllSelected = true;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(true);
    } else {
      this.isAllSelected = false;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(false);
    }
    this.dispatcher.onGroupSelectionChanged(itemCoordinate.dateKey, this.isGroupSelected(itemCoordinate.getDateKey()));
    return true;
  }

  public getTitleCoordinate(dateKey: number): ItemCoordinate {
    return new ItemCoordinate().setDateKey(dateKey).setIndex(-1);
  }

  public removeItem(targetId: string | undefined): void {
    Log.info(TAG, `removeItem targetId：${targetId}`);
    if (!targetId) {
      return;
    }
    if (!this.mIsDayGroupState) {
      return super.removeItem(targetId);
    }
    this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')?.(this.getSelectedCount(targetId));
    this.dispatcher.onSelectCountChanged(this.getSelectedCount());
  }

  public getSelectedCount(targetId?: string | undefined): number {
    if (!this.mIsDayGroupState) {
      return super.getSelectedCount();
    }
    let count = 0;
    this.mSelectionEntryMap.forEach((item): void => {
      if (targetId) {
        item?.removeClickSet(targetId);
        item?.removeSelectedMap(targetId);
      }
      count += item ? item.getSelectedCount() : 0;
    });
    if (this.inverseSelection) {
      Log.info(TAG, `inverseSelection totalCount: ${this.totalCount - count}`);
      return this.totalCount - count;
    }
    return count;
  }

  public async getItems(photoDataImpl: BrowserDataInterface | undefined, start: number, count: number, fetchType:
    FetchType, callbackFunc: Function):
    Promise<void> {
    let albumUris: string[] | undefined = this.albumInfo?.unionAlbumUris;
    if (this.isPickerUsedSubwindow) {
      albumUris = this.selectParam?.unionAlbumUris;
      fetchType = FetchType.NORMAL
    }
    Log.info(TAG, `getItems start: ${start} count: ${count}
      fetchType: ${fetchType} albumUri: ${this.albumUri} albumUris: ${albumUris}`);
    let cb: AsyncCallback<MediaItem[]> = {
      callback: (t: MediaItem[]) => {
        // 注意命名不要冲突
        callbackFunc(t);
      }
    };
    photoDataImpl?.getData(cb, {
      albumUri: this.albumUri,
      albumUris: albumUris,
      start: start,
      count: count,
      fetchType: fetchType,
      orderBy: this.mIsDayGroupState ? UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString() : undefined,
    });
  }

  public onModeChange(newMode: boolean): void {
    if (DeviceInfo.isPc()) {
      this.delayUpdateLastSelectMode();
    }
    let oldMode: boolean = this.mIsSelectedMode;
    this.mIsSelectedMode = newMode;
    if (oldMode !== newMode) {
      AppStorage.setOrCreate<boolean>('isShowDeleteAll', !newMode)
      Log.info(TAG, `onModeChange ${oldMode}->${newMode}`);
      this.isGroupSelect = false;
      this.dispatcher.onModeChanged(newMode);
    }
    if (newMode) {
      return;
    }
    this.inverseSelection = false;
    this.isAllSelected = false;
    this.clickedSet.clear();
    this.selectedMap.clear();
    AppStorage.setOrCreate<boolean>('focusUpdate', true);
    this.mCallbacks.has('updateGroupCount') && this.mCallbacks.get('updateGroupCount')?.();
    this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')?.(false);
    this.updateCount();
    AppStorage.setOrCreate<boolean>(Constants.APP_STORAGE_KEY_CLOUD_DOWNLOAD_FINISH_STATUS, false);
  }

  /**
   *  临时方案,解决PC图库进多选模式下自动获焦问题；
   */
  private delayUpdateLastSelectMode(): void {
    if (this.lastSelectModeTimeoutId >= 0) {
      return;
    }
    this.lastSelectModeTimeoutId = setTimeout((): void => {
      this.lastSelectMode = !!this.isSelectedMode();
      this.lastSelectModeTimeoutId = -1;
    }, this.UPDATE_DELAY);
  }

  public isItemSelectedForBrowser(targetId: string, index: number | undefined): boolean {
    if (this.getMediaItemFunc && this.mIsDayGroupState) {
      let mediaItem: MediaItem = this.getMediaItemFunc(targetId);
      let newIndex = this.dataSourceProxy?.getDataIndex(mediaItem) ?? 0;
      let position = this.dataSourceProxy?.dataToLayout(newIndex);
      return this.isItemSelected(targetId, position);
    }
    return this.isItemSelected(targetId, index);
  }

  public isItemSelected(targetId: string, index: number | undefined): boolean {
    if (!this.mIsDayGroupState) {
      return super.isItemSelected(targetId, index);
    }
    if (index === undefined) {
      return false;
    }
    let itemCoordinate = this.getCoordinateFromPosition(index);

    let entry = this.mSelectionEntryMap.get(itemCoordinate.getDateKey());
    let result: boolean;
    if (this.inverseSelection) {
      result = entry === undefined || !entry.isItemSelected(targetId);
    } else {
      result = entry?.isItemSelected(targetId);
    }
    return (result === undefined) ? false : result;
  }

  public isGroupSelected(dateKey: number | undefined): boolean {
    if (dateKey === undefined) {
      return false;
    }
    let entry: BucketSelectionEntry = this.mSelectionEntryMap.get(dateKey);
    if (this.inverseSelection) {
      return !entry || entry.getSelectedCount() === 0;
    }
    return entry?.inSelectAllMode() ?? false;
  }

  public setGroupData(groupData: TimelineData[]): void {
    if (!groupData) {
      return;
    }
    this.mGroupData = groupData;
  }

  public updateGroupData(groupData: TimelineData[]): void {
    this.setGroupData(groupData);
    this.mGroupData = groupData;
    this.mSelectionDateKeyRangeMap.clear();
    let start = 0;
    this.mGroupData.forEach((item: TimelineData): void => {
      let dateKey = item.getDateKey();
      this.mSelectionEntryMap.get(dateKey)?.setTotalCount(item.count);
      this.mSelectionDateKeyRangeMap.set(dateKey, [start, start + item.count - 1]);
      start += item.count;
    });
    this.updateCount();
  }

  public async selectedCallback(callback: AsyncCallback<string[]>): Promise<void> {
    if (!this.mIsDayGroupState || this.totalCount === 0) {
      super.selectedCallback(callback);
      return;
    }
    await this.getSelected(FetchType.EMPTY, (uriTemp: string[], itemTemp: MediaItem[]) => {
      callback.callback(uriTemp);
    });
    // 操作完成退出多选模式，清除选择数据(如果操作完无需清除选择数据，需要单独判断处理)
    this.clearEntryArray();
  }

  public getSelectAsset(callback: Function, isSkipClear: boolean = false): void {
    if (!this.mIsDayGroupState) {
      super.getSelectAsset(callback);
      return;
    }
    this.getSelected(FetchType.EMPTY, (uriTemp: string[], itemTemp: MediaItem[]) => {
      let result: PhotoAsset[] = [];
      for (let i: number = 0; i < itemTemp.length; i++) {
        result.push(itemTemp[i].data as photoAccessHelper.PhotoAsset);
      }
      callback(result);
      if (!isSkipClear) {
        this.clearEntryArray();
      }
    });
  }

  public async getSelectedItems(callback: Function): Promise<void> {
    Log.info(TAG, 'getSelectedItems');
    if (!this.mIsDayGroupState) {
      super.getSelectedItems(callback);
      return;
    }
    await this.getSelected(FetchType.DATE_INFO, (uriTemp: string[], itemTemp: MediaItem[]) => {
      callback(itemTemp);
    });
  }

  private async getSelected(fetchType: FetchType, callback: Function): Promise<void> {
    let itemResult: MediaItem[] = [];
    let uriResult: string[] = [];
    let start = 0;
    let doneCount = 0;
    if (this.inverseSelection) {
      for (let i = 0; i < this.mGroupData.length; i++) {
        let dateKey = this.mGroupData[i].getDateKey();
        if (this.mSelectionEntryMap.hasKey(dateKey)) {
          //全选模式下用户操作过的日期下的items根据用户选择反选
          await this.getInverseSelectedFromEntry(this.mSelectionEntryMap.get(dateKey),
            start, this.mGroupData[i].count, fetchType, (uriTemp: string[], itemTemp: MediaItem[]) => {
              itemResult = itemResult.concat(itemTemp);
              uriResult = uriResult.concat(uriTemp);
              Log.info(TAG, `getInverseSelectedFromEntry result ${uriResult.length}`);
              doneCount++;
              this.checkIsGetSelectionFinish(doneCount, uriResult, itemResult, callback);
            });
        } else {
          //全选模式下用户未操作过的日期下的items全量选中
          await this.getItems(this.photoDataImpl, start, this.mGroupData[i].count,
            fetchType, (temp: MediaItem[]) => {
              temp.forEach((item): void => {
                itemResult.push(item);
                uriResult.push(item.uri);
              });
              Log.info(TAG, `getInverseGroupItems result ${uriResult.length}`);
              doneCount++;
              this.checkIsGetSelectionFinish(doneCount, uriResult, itemResult, callback);
            });
        }
        start += this.mGroupData[i].count;
      }
    } else {
      for (let i = 0; i < this.mGroupData.length; i++) {
        let dateKey = this.mGroupData[i].getDateKey();
        if (this.mSelectionEntryMap.hasKey(dateKey)) {
          //正选模式下根据遍历日期分组用户选择正常取item
          await this.getSelectedFromEntry(this.mSelectionEntryMap.get(dateKey), start,
            this.mGroupData[i].count, FetchType.EMPTY, (uriTemp: string[], itemTemp: MediaItem[]) => {
              itemResult = itemResult.concat(itemTemp);
              uriResult = uriResult.concat(uriTemp);
              Log.info(TAG, `getSelectedFromEntry uris ${uriResult.length} items ${itemResult.length}`);
              doneCount++;
              this.checkIsGetSelectionFinish(doneCount, uriResult, itemResult, callback);
            });
        } else {
          //正选模式下未操作过的分组直接跳过
          doneCount++;
          this.checkIsGetSelectionFinish(doneCount, uriResult, itemResult, callback);
        }
        start += this.mGroupData[i].count;
      }
    }
  }

  /**
   * 缓存三宫格已点击分组信息，删除场景会退出选择模式
   *
   * @param entryMap 分组点击信息
   * @returns 缓存已点击分组map
   */
  public copySelectionEntryMap(entryMap: HashMap<number, BucketSelectionEntry>): void {
    // 先清空之前的数据
    this.selectionMapCopy.clear();
    entryMap.forEach((value, key) => {
      if (value) {
        let entry: BucketSelectionEntry = new BucketSelectionEntry();
        entry.setInverseSelection(value.getInverseSelection());
        value.getClickSet().forEach((item) => entry.getClickSet().add(item));
        value.getSelectedMap().forEach((mediaItem, key) => entry.getSelectedMap().set(key, mediaItem));
        this.selectionMapCopy.set(key, entry);
      }
    })
  }

  /**
   * 分批获取选择的所有照片（包括连拍的非封面照片）
   * @param callback 回调函数
   * @param clickedSet 点选的宫格
   * @param inverseSelection 是否反选操作
   * @param isTrash 是否最近删除
   * @param start 查询的起始位置
   * @param count 查询的元素个数
   */
  public batchGetSelectAssetsWidthBurstPhotos(callback: Function, clickedSet: Set<string>, inverseSelection: boolean,
    isTrash?: boolean, start?: number, count?: number, currentBatch?: number): void {
    if (!this.mIsDayGroupState) {
      super.batchGetSelectAssetsWidthBurstPhotos(callback, clickedSet, inverseSelection, isTrash, start, count);
      return;
    }
    if (!callback || start === undefined || count === undefined) {
      Log.error(TAG, `batchGetSelectAssetsWidthBurstPhotos params undefined`);
      return;
    }

    const newCallback: Function = async (mediaArray: MediaItem[]) => {
      const result: MediaItem[] = [];
      for (let i: number = 0; i < mediaArray.length; i++) {
        if (!mediaArray[i]) {
          Log.error(TAG, `mediaArray ${i} is undefined`);
          continue;
        }
        if (mediaArray[i].getIsBurstPhotos() && this.photoDataImpl?.getDataByBurstKey) {
          const mediaItems = await this.photoDataImpl.getDataByBurstKey(mediaArray[i].burstKey as string,
            Constants.INVALID, Constants.INVALID, true, isTrash);
          result.push(...mediaItems);
        } else {
          result.push(mediaArray[i]);
        }
      }
      const assets = result.map(item => item.data);
      callback(assets);
      if (currentBatch && currentBatch * this.DELETE_BATCH_SIZE >= this.totalCountForDelete) {
        this.selectionMapCopy.clear();
      }
    };

    let startForDelete = start ?? 0;
    let countForDelete = count ?? this.DELETE_BATCH_SIZE;
    if (currentBatch !== undefined) {
      if (currentBatch === this.FIRST_BATCH) {
        this.copySelectionEntryMap(this.mSelectionEntryMap);
        this.totalCountForDelete = this.totalCount;
      }
      // 倒序查询，删除一批后，索引会变化
      let totalBatch = Math.ceil(this.totalCountForDelete / this.DELETE_BATCH_SIZE);
      startForDelete = (totalBatch - currentBatch) * this.DELETE_BATCH_SIZE;
      countForDelete = Math.min(this.DELETE_BATCH_SIZE, this.totalCountForDelete - startForDelete);
      Log.info(TAG, `totalBatch: ${totalBatch}, currentBatch: ${currentBatch},
       start: ${startForDelete}, countForDelete: ${countForDelete}`);
    }

    let dealEntryCallBack: Function = (items: MediaItem[]) => {
      this.loopGetDeletedItems(newCallback, startForDelete, countForDelete, items, this.selectionMapCopy);
    };
    // 从媒体库中直接查询出一批数据，然后根据分组情况过滤出该批次中选中的资源；不需要考虑分组情况
    super.getItems(this.photoDataImpl, startForDelete, countForDelete, FetchType.EMPTY, dealEntryCallBack);
  }

  private async loopGetDeletedItems(callback: Function, start: number, count: number, items: MediaItem[],
    entryMap: HashMap<number, BucketSelectionEntry>) {
    let skipCount = 0;
    let startIndex = start;
    let remainingCount = count;
    let result: MediaItem[] = [];
    let isFirstReach = false;
    for (let i = 0; i < this.mGroupData.length; i++) {
      // 跳过非当前批次的分组
      if (skipCount + this.mGroupData[i].count < start) {
        skipCount += this.mGroupData[i].count;
        continue;
      }
      // firstReach用来判断正选场景下，是否第一次查询当前分组，如果是第一次查询，直接查询整个分组数据
      isFirstReach = skipCount === startIndex;
      let searchCount = Math.min(skipCount + this.mGroupData[i].count - startIndex, remainingCount);
      // 查询分组中选中图片数量
      let entryResult =
        await this.getDeletedSetFromEntry(this.mGroupData[i], startIndex, searchCount, isFirstReach, items, entryMap);
      result = result.concat(entryResult);
      startIndex += searchCount;
      remainingCount -= searchCount;
      skipCount += this.mGroupData[i].count;
      if (remainingCount === 0) {
        break;
      }
    }
    callback(result);
  }

  private getDeletedSetFromEntry(timelineData: TimelineData, start: number, count: number,
    isFirstReach: boolean, items: MediaItem[], entryMap: HashMap<number, BucketSelectionEntry>) {
    if (entryMap.hasKey(timelineData.getDateKey())) {
      let selectedEntry = entryMap.get(timelineData.getDateKey());
      //全选模式下用户操作过的日期下的items根据用户选择反选
      if (selectedEntry.getInverseSelection() && isFirstReach) {
        return this.getEntryNormalSelected(selectedEntry);
      } else {
        return this.getEntryInverseSelectAsset(selectedEntry, start, count, items, this.DELETE_BATCH_SIZE);
      }
    } else {
      // 全选模式下用户未操作过的日期下的items全量选中
      if (this.mIsDayGroupState) {
        return this.getEntryAllSelectAsset(start, count, items, this.DELETE_BATCH_SIZE);
      } else {
        return new Promise<MediaItem[]>((resolve) => {
          let callBack: Function = (assets: MediaItem[]) => resolve(assets);
          this.batchGetInverseSelectAssets(callBack, start, count);
        });
      }
    }
  }

  /**
   * 分批查询获取选中态的三宫格媒体资源,包含正选和反选场景下选中的资源
   * @param callback 回调函数
   * @param start 查询的起始位置
   * @param count 查询的个数
   */
  public batchGetSelectAsset(callback: Function, start: number, count: number): void {
    if (!this.mIsDayGroupState || !this.isGroupSelect) {
      super.batchGetSelectAsset(callback, start, count);
      return;
    }
    Log.info(TAG, `TimelineSelectManager inversion: ` + this.inverseSelection + ` start: ${start} count: ${count}`);
    if (callback === undefined || start === undefined || count === undefined) {
      Log.error(TAG, `TimelineSelectManager batchGetSelectAsset params undefined`);
      return;
    }

    if (!this.photoDataImpl) {
      this.setPhotoDataImpl();
    }

    let dealEntryCallBack: Function = (items: MediaItem[]) => {
      this.loopGetSelectedItems(callback, start, count, items);
    };
    // 从媒体库中直接查询出一批数据，然后根据分组情况过滤出该批次中选中的资源；不需要考虑分组情况
    this.getItems(this.photoDataImpl, start, count, FetchType.EMPTY, dealEntryCallBack);
  }

  /**
   * 循环查询每个分组中选中的图片
   * @param callback 结果回调
   * @param start 批次起始index
   * @param count 批次数量
   */
  private async loopGetSelectedItems(callback: Function, start: number, count: number, items: MediaItem[]) {
    let skipCount = 0;
    let startIndex = start;
    let remainingCount = count;
    let result: MediaItem[] = [];
    let isFirstReach = false;
    for (let i = 0; i < this.mGroupData.length; i++) {
      // 跳过非当前批次的分组
      if (skipCount + this.mGroupData[i].count < start) {
        skipCount += this.mGroupData[i].count;
        continue;
      }
      // firstReach用来判断正选场景下，是否第一次查询当前分组，如果是第一次查询，直接查询整个分组数据
      isFirstReach = skipCount === startIndex;
      let searchCount = Math.min(skipCount + this.mGroupData[i].count - startIndex, remainingCount);
      // 查询分组中选中图片数量
      let entryResult =
        await this.getSelectedSetFromEntry(this.mGroupData[i], startIndex, searchCount, isFirstReach, items);
      result = result.concat(entryResult);
      startIndex += searchCount;
      remainingCount -= searchCount;
      skipCount += this.mGroupData[i].count;
      if (remainingCount === 0) {
        break;
      }
    }
    callback(result);
  }

  /**
   * 根据是否全选，分组里是否反选获取分组中选中的图片
   * @param timelineData 分组数据
   * @param start 开始位置
   * @param count 获取大小
   * @param isFirstReach 是否首次查询该分组
   * @returns 当前分组中所有选中的图片
   */
  private async getSelectedSetFromEntry(timelineData: TimelineData, start: number, count: number,
    isFirstReach: boolean, items: MediaItem[]): Promise<MediaItem[]> {
    if (this.inverseSelection) {
      if (this.mSelectionEntryMap.hasKey(timelineData.getDateKey())) {
        let selectedEntry = this.mSelectionEntryMap.get(timelineData.getDateKey());
        //全选模式下用户操作过的日期下的items根据用户选择反选
        if (selectedEntry.getInverseSelection() && isFirstReach) {
          return this.getEntryNormalSelected(selectedEntry);
        } else {
          return this.getEntryInverseSelectAsset(selectedEntry, start, count, items);
        }
      } else {
        // 全选模式下用户未操作过的日期下的items全量选中
        if (this.mIsDayGroupState) {
          return this.getEntryAllSelectAsset(start, count, items);

        } else {
          return new Promise<MediaItem[]>((resolve) => {
            let callBack: Function = (assets: MediaItem[]) => resolve(assets);
            this.batchGetInverseSelectAssets(callBack, start, count);
          });
        }
      }
    } else {
      // 正选场景下，只需要查询有选中的分组数据
      if (this.mSelectionEntryMap.hasKey(timelineData.getDateKey())) {
        let selectedEntry = this.mSelectionEntryMap.get(timelineData.getDateKey());
        if (selectedEntry.getInverseSelection()) {
          return this.getEntryInverseSelectAsset(selectedEntry, start, count, items);
        } else {
          if (isFirstReach) {
            // 正选场景下，第一次查询到该分组，查询该分组所有数据
            return this.getEntryNormalSelected(selectedEntry);
          }
        }
      }
    }
    return [];
  }

  /**
   * 如果分组全选了，直接从媒体库查询起始位置开始的count大小的数据
   * @param start 起始位置
   * @param count 获取数据大小
   * @returns 选中的图片
   */
  private getEntryAllSelectAsset(start: number, count: number, items: MediaItem[],
    batchSize?: number): MediaItem[] {
    let startInArray: number = start % (batchSize ? batchSize : SelectManager.BATCH_SIZE);
    let mediaItems = items.slice(startInArray, startInArray + count);
    return mediaItems;
  }

  /**
   * 反选场景下，获取该分组选中的图片
   *   1. 先根据起始位置，查询的总数去媒体库查询数据
   *   2. 排除取消选择的（selectManager.clickSet的数据）
   * @param selectedEntry 当前分组
   * @param start 分组在所有数据里的起始位置
   * @param count 查询的数量，如果小于BatchSize，就是分组总数，否则就是BatchSize
   * @returns 当前分组选中图片数量
   */
  private getEntryInverseSelectAsset(selectedEntry: BucketSelectionEntry,
    start: number, count: number, items: MediaItem[], batchSize?: number): MediaItem[] {
    let result: MediaItem[] = [];
    let startInArray: number = start % (batchSize ? batchSize : SelectManager.BATCH_SIZE);
    let mediaItems = items.slice(startInArray, startInArray + count);
    mediaItems.forEach((mediaItem) => {
      if (mediaItem && !selectedEntry.getClickSet()?.has(mediaItem.uri)) {
        result.push(mediaItem);
      }
    });
    return result;
  }

  /**
   * 正选情况，查询分组下所有选中的图片
   * @param selectedEntry 分组
   * @returns 当前分组所有选中的图片
   */
  private getEntryNormalSelected(selectedEntry: BucketSelectionEntry): MediaItem[] {
    return Array.from(selectedEntry.getSelectedMap().values());
  }

  private toggleClickSet(entry: BucketSelectionEntry, targetId: string, isSelected: boolean): void {
    Log.info(TAG, `toggleClickSet: ${targetId} + ${isSelected}`);
    this.toggleEntryItem(entry, targetId, isSelected !== this.inverseSelection);
  }

  private toggleEntryItem(entry: BucketSelectionEntry, targetId: string, isSelected: boolean): void {
    let clickSet = entry.getClickSet();
    let selectedMap = entry.getSelectedMap();
    if (isSelected !== entry.getInverseSelection()) {
      if (this.getMediaItemFunc) {
        selectedMap.set(targetId, this.getMediaItemFunc(targetId));
      }
      clickSet.add(targetId);
    } else {
      if (this.getMediaItemFunc) {
        selectedMap.delete(targetId);
      }
      clickSet.delete(targetId);
    }
  }

  private getCoordinateFromPosition(position: number): ItemCoordinate {
    let index = 0;
    let group = 0;
    let totalSize = this.mGroupData.length;
    for (; group < totalSize; group++) {
      let count = this.mGroupData[group].count;
      index = index + (count + 1); //为PC时，适配差异化年月日视图
      if (index > position) {
        index -= count;
        group = Math.max(0, group);
        break;
      }
    }
    return new ItemCoordinate().setDateKey(this.mGroupData[group]?.getDateKey()).setIndex(position - index);
  }

  private getGroupEntry(itemCoordinate: ItemCoordinate): BucketSelectionEntry {
    let dateKey = itemCoordinate.getDateKey();
    let entryFromMap = this.mSelectionEntryMap.get(dateKey);
    if (entryFromMap === undefined) {
      entryFromMap = new BucketSelectionEntry();
      entryFromMap.setDateKey(dateKey);
      if (dateKey >= 0) {
        let item = this.mGroupData.find((item: TimelineData) => {
          return item.getDateKey() === dateKey;
        });
        if (item) {
          entryFromMap.setTotalCount(item.count);
        }
      }
      Log.info(TAG, `getGroupEntry mSelectionEntryArray ${itemCoordinate.dateKey} entry: ${entryFromMap}`);
      this.mSelectionEntryMap.set(itemCoordinate.getDateKey(), entryFromMap);
    }
    return entryFromMap;
  }

  public exitSelectMode(): void {
    Log.info(TAG, 'cancelSelected');
    this.clearEntryArray();
  }

  private clearEntryArray(): void {
    Log.info(TAG, 'clearEntryArray');
    this.mSelectionEntryMap.clear();
  }

  private checkIsGetSelectionFinish(doneCount: number, uris: string[], items: MediaItem[], callback: Function): void {
    if (this.mGroupData.length === doneCount) {
      Log.info(TAG, `checkIsGetSelectionFinish uris ${uris.length} items ${items.length}`);
      callback(uris, items);
    }
  }

  private async getSelectedFromEntry(entry: BucketSelectionEntry, start: number, count:
    number, fetchType: FetchType, callback: Function): Promise<void> {
    Log.info(TAG, `getSelectedFromEntry start: ${start}, count: ${count}`);
    let itemResult: MediaItem[] = [];
    let uriResult: string[] = [];

    if (!entry.getInverseSelection()) {
      Log.info(TAG, `getSelectedFromEntry not inverse, SelectedMap size: ${entry.getSelectedMap().size}`);
      uriResult = Array.from(entry.getClickSet());
      itemResult = Array.from(entry.getSelectedMap().values());
      callback(uriResult, itemResult);
      return;
    }
    await this.getItems(this.photoDataImpl, start, count, fetchType, (temp: MediaItem[]) => {
      temp.forEach((item) => {
        if (!entry.getClickSet().has(item.uri)) {
          uriResult.push(item.uri);
          itemResult.push(item);
        }
      });
      callback(uriResult, itemResult);
    });
  }

  private async getInverseSelectedFromEntry(entry: BucketSelectionEntry, start: number, count:
    number, fetchType: FetchType, callback: Function): Promise<void> {
    Log.info(TAG, `getInverseSelectedFromEntry start: ${start}, count: ${count}`);
    let itemResult: MediaItem[] = [];
    let uriResult: string[] = [];

    if (entry.getInverseSelection()) {
      uriResult = Array.from(entry.getClickSet());
      itemResult = Array.from(entry.getSelectedMap().values());
      callback(uriResult, itemResult);
      return;
    }

    Log.info(TAG, 'getInverseSelectedFromEntry not inverse');
    await this.getItems(this.photoDataImpl, start, count, fetchType, (temp: MediaItem[]) => {
      Log.info(TAG, `enter callback temp: ${entry.getClickSet().size}`);
      temp.forEach((item) => {
        if (!entry.getClickSet().has(item.uri)) {
          uriResult.push(item.uri);
          itemResult.push(item);
        }
      });
      Log.info(TAG, `enter callback result ${uriResult.length}`);
      callback(uriResult, itemResult);
    });
  }
}

export class AlbumSetSelectManager extends SelectManager {
  public isDisableRenameClickedSet: Set<string> = new Set();
  public isDisableDeleteClickedSet: Set<string> = new Set();

  constructor() {
    super();
  }

  public getItems(photoDataImpl: BrowserDataInterface, start: number, count: number, fetchType: FetchType,
    callbackFunc: Function): Promise<void> {
    let tempAlbums: AlbumInfo[] = [];
    return callbackFunc(tempAlbums);
  }

  public toolBarStateToggle(targetId: string, isSelected: boolean, isDisableRename: boolean, isDisableDelete: boolean
  ): void {
    Log.info(TAG, `toolBarStateToggle${targetId}/${isSelected}/${isDisableRename}/${isDisableDelete}`);
    if (isSelected !== this.inverseSelection) {
      if (isDisableRename) {
        Log.info(TAG, `add isDisableRename targetID ${targetId}`);
        this.isDisableRenameClickedSet.add(targetId);
      }
      if (isDisableDelete) {
        Log.info(TAG, `add isDisableDelete targetID ${targetId}`);
        this.isDisableDeleteClickedSet.add(targetId);
      }
    } else {
      if (isDisableRename) {
        Log.info(TAG, `delete isDisableRename targetID ${targetId}`);
        this.isDisableRenameClickedSet.delete(targetId);
      }
      if (isDisableDelete) {
        Log.info(TAG, `delete isDisableDelete targetID ${targetId}`);
        this.isDisableDeleteClickedSet.delete(targetId);
      }
    }

    let isDisableRenameFlag = this.isDisableRenameClickedSet.size !== 0;
    let isDisableDeleteFlag = this.isDisableDeleteClickedSet.size !== 0;
    this.mCallbacks.has('updateToolBarState') &&
      this.mCallbacks.get('updateToolBarState')?.(isDisableRenameFlag, isDisableDeleteFlag);
  }

  public onModeChange(newMode: boolean): void {
    super.onModeChange(newMode);
    if (!newMode) {
      this.isDisableRenameClickedSet.clear();
      this.isDisableDeleteClickedSet.clear();
    }
  }
}
