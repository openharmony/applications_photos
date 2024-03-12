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

import { TimelineData } from './photo/TimelineData';
import { Log } from '../../utils/Log';
import { MediaItem } from './photo/MediaItem';
import type { AsyncCallback } from '../common/AsyncCallback';
import { BrowserDataFactory } from '../../interface/BrowserDataFactory';
import type { BrowserDataInterface } from '../../interface/BrowserDataInterface';
import { Constants } from '../common/Constants';

const TAG: string = 'common_SelectManager';

export class BucketSelectionEntry {
  private groupId = -1;
  private clickedSet: Set<string> = new Set();
  private totalCount = 0;
  private inverseSelection = false;
  private groupSelect = false;
  private selectedMap: Map<string, MediaItem> = new Map();

  public setGroupId(groupId: number): void {
    this.groupId = groupId;
  }

  public getGroupId(): number {
    return this.groupId;
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
    return (this.inverseSelection != this.clickedSet.has(targetId));
  }

  public inSelectAllMode(): boolean {
    return this.inverseSelection && (this.clickedSet.size == 0);
  }

  /**
   * Change the select all status of the entry, depending on the total deselection status of the timeline
   *
   * @param isInverseMode The total inverse selection status of the timeline. If it is true,
   * it is global inverse selection and requires reverse operation
   */
  public changeSelectMode(isInverseMode: boolean): void {
      isInverseMode
      ? (this.getSelectedCount() == 0 ? this.selectAll() : this.deSelectAll())
      : (this.inSelectAllMode() ? this.deSelectAll() : this.selectAll())
  }

  public getInverseSelection(): boolean {
    return this.inverseSelection;
  }
}

export class ItemCoordinate {
  groupId = -1;
  subIndex = -1;

  constructor() {
  }

  public setGroupId(id: number): ItemCoordinate {
    this.groupId = id;
    return this;
  }

  public getGroupId(): number {
    return this.groupId;
  }

  public setIndex(index: number): ItemCoordinate {
    this.subIndex = index;
    return this;
  }

  public getIndex(): number {
    return this.subIndex;
  }
}

export class SelectManager {
  mIsSelectedMode = false;
  clickedSet: Set<string> = new Set();
  totalCount = 0;
  inverseSelection = false;
  inSingleMode = false;
  isAllSelected = false;
  mCallbacks = new Map<string, Function>();
  photoDataImpl: BrowserDataInterface;
  selectManagerCallback: SelectManagerCallback;
  albumUri = undefined;
  deviceId = undefined;
  selectedMap: Map<string, MediaItem> = new Map();
  getMediaItemFunc: Function;

  constructor() {
    this.selectManagerCallback = new SelectManagerCallback(this);
  }

  public setTotalCount(count: number): void {
    this.totalCount = count;
    this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')(this.getSelectedCount());

    if (this.isAllSelected) {
      this.isAllSelected = false;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')(false);
    }
    if (this.totalCount == this.getSelectedCount()) {
      this.isAllSelected = true;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')(true);
    }
  }

  public setPhotoDataImpl(): void {
    this.photoDataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO);
  }

  public setAlbumUri(albumUri): void {
    this.albumUri = albumUri;
  }

  public setDeviceId(deviceId: string): void {
    this.deviceId = deviceId;
  }

  public registerCallback(name: string, cb: Function): void {
    this.mCallbacks.set(name, cb);
  }

  public unregisterCallback(name: string): void {
    this.mCallbacks.delete(name);
  }

  public emitCallback(name: string, argument: unknown[]): void {
    this.mCallbacks.has(name) && this.mCallbacks.get(name).apply(this, argument);
  }

  public toggle(targetId: string, isSelected: boolean, targetIndex?: number): boolean {
    Log.info(TAG, `toggle ${targetId} ${isSelected} ${targetIndex}`);
    if (targetId == undefined) {
      return true;
    }
    if (isSelected == (!this.inverseSelection)) {
      this.clickedSet.add(targetId);
      if (this.getMediaItemFunc) {
        this.selectedMap.set(targetId, this.getMediaItemFunc(targetId));
      }
      Log.info(TAG, `add targetID ${targetId}`);
    } else {
      this.clickedSet.delete(targetId);
      if (this.getMediaItemFunc) {
        this.selectedMap.delete(targetId);
      }
    }
    if (this.totalCount == this.getSelectedCount()) {
      this.isAllSelected = true;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')(true);
    } else {
      this.isAllSelected = false;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')(false);
    }
    this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')(this.getSelectedCount());
    if (targetIndex !== undefined) {
      this.mCallbacks.has('select') && this.mCallbacks.get('select')(targetIndex);
    }
    return true;
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
    AppStorage.setOrCreate('focusUpdate', true);
    if (shouldCallSelectALl) {
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')(true);
    }
    this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')(this.getSelectedCount());
  }

  public selectAll(reverseSelection: boolean): void {
    this.selectAllWithoutNotify(reverseSelection, true);
  }

  public deSelectAll(): void {
    this.inverseSelection = false;
    this.isAllSelected = false;
    this.clickedSet.clear();
    this.selectedMap.clear();
    AppStorage.setOrCreate('focusUpdate', true);
    this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')(false);
    this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')(this.getSelectedCount());
  }

  public isItemSelected(targetId: string, index?: number): boolean {
    Log.info(TAG, `isItemSelected ${targetId}, ${index}`);
    return (this.inverseSelection != this.clickedSet.has(targetId));
  }

  public getSelectedCount(): number {
    return (this.inverseSelection) ? this.totalCount - this.clickedSet.size : this.clickedSet.size;
  }

  public onModeChange(newMode: boolean): void {
    if (newMode) {
      this.mIsSelectedMode = true;
    } else {
      this.mIsSelectedMode = false;
      this.inverseSelection = false;
      this.isAllSelected = false;
      this.clickedSet.clear();
      this.selectedMap.clear();
      AppStorage.setOrCreate('focusUpdate', true);
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')(false);
      this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')(this.getSelectedCount());
    }
  }

  public getSelection(callback: AsyncCallback<string[]>): void {
    if (this.inverseSelection) {
      this.selectManagerCallback.setSubCallback(callback);
      this.photoDataImpl.getData(this.selectManagerCallback, {
        albumUri: this.albumUri
      });
    } else {
      let result = [];
      result = Array.from(this.clickedSet);
      callback.callback(result);
    }
  }

  public getDeleteSelection(callback: AsyncCallback<string[]>): void {
    if (this.inverseSelection) {
      this.selectManagerCallback.setSubCallback(callback);
      this.photoDataImpl.getData(this.selectManagerCallback, {
        albumUri: this.albumUri
      });
    } else {
      let result = [];
      result = Array.from(this.clickedSet);
      callback.callback(result);
    }
  }

  public async getSelectedItems(callback: Function): Promise<void> {
    let result = new Array<MediaItem>();
    Log.info(TAG, 'getSelectedItems this.inverseSelection: ' + this.inverseSelection);
    if (this.inverseSelection) {
      await this.getItems(this.photoDataImpl, 0, this.totalCount, (temp: MediaItem[]) => {
        temp.forEach((item) => {
          if (item && !this.clickedSet.has(item.uri)) {
            result.push(item);
          }
        });
        Log.info(TAG, `enter callback result ${result.length}`);
        callback(result);
      });
    } else {
      let result = [];
      result = Array.from(this.selectedMap.values());
      callback(result);
    }
  }

  public handleSelection(mediaItems: MediaItem[], callback: AsyncCallback<string[]>): void {
    let result = [];
    mediaItems.forEach((mediaItem) => {
      if (mediaItem && !this.clickedSet.has(mediaItem.uri)) {
        result.push(mediaItem.uri);
      }
    })
    callback.callback(result);
  }

  public async getItems(photoDataImpl: BrowserDataInterface,
                        start: number, count: number, callbackFunc: Function): Promise<void> {
    Log.info(TAG, `getItems start: ${start} count: ${count}`);
    let cb: AsyncCallback<MediaItem[]> = {
      callback: (t: MediaItem[]) => {
        //注意命名不要冲突
        callbackFunc(t);
      }
    }
    photoDataImpl.getData(cb, { albumUri: this.albumUri, start: start, count: count });
  }

  public getClassName(): string {
    return 'SelectManager';
  }

  public setGetMediaItemFunc(func: Function): void {
    this.getMediaItemFunc = func;
  }

  public releaseGetMediaItemFunc(): void {
    this.getMediaItemFunc = undefined;
  }
}

class SelectManagerCallback implements AsyncCallback<MediaItem[]> {
  source: SelectManager;
  subCallback: AsyncCallback<string[]>;

  constructor(source: SelectManager) {
    this.source = source;
  }

  public setSubCallback(cb: AsyncCallback<string[]>): void {
    this.subCallback = cb;
  }

  public callback(mediaSetList: MediaItem[]): void {
    this.source.handleSelection(mediaSetList, this.subCallback);
  }
}

export class ThirdSelectManager extends SelectManager {
  type: string;
  isMultiPick: boolean;
  selectedMap: Map<string, MediaItem> = new Map();
  indexMap: Map<MediaItem, number> = new Map();
  previewSet: Set<string> = new Set();
  isPreview: boolean = false;

  constructor() {
    super();
  }

  public setType(type: string): void {
    this.type = type;
  }

  public getType(): string {
    return this.type;
  }

  public setIsMultiPick(isMultiPick: boolean): void {
    this.isMultiPick = isMultiPick;
  }

  public getIsMultiPick(): boolean {
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
  public initPreSelectPhotos(targetIdList: string[]): void {
    this.deSelectAll();
    if (this.getMediaItemFunc) {
      targetIdList.forEach((targetId: string): void => {
        let containUri = this.selectedMap.has(targetId);
        if (!containUri) {
          this.getMediaItemFunc(targetId, (item) => {
            this.toggleWithItem(targetId, true, item);
          });
        }
      });
    }
  }

  /**
   * 针对指定mediaItem预加载缓存
   *
   * @param targetId 图库资源Id
   * @param isSelected 图库资源是否被选中
   * @param mediaItem mediaItem
   * @returns 是否成功
   */
  public toggleWithItem(targetId: string, isSelected: boolean, mediaItem: MediaItem): boolean {
    if (mediaItem) {
      let containUri = this.selectedMap.has(targetId);
      if (isSelected && !containUri) {
        this.selectedMap.set(targetId, mediaItem);
        this.indexMap.set(mediaItem, undefined);
      }
      if (!isSelected && containUri) {
        this.selectedMap.delete(targetId);
        this.indexMap.delete(mediaItem);
      }
      return super.toggle(targetId, isSelected, undefined);
    }
    return false;
  }

  public toggle(targetId: string, isSelected: boolean, targetIndex?: number): boolean {
    if (this.getMediaItemFunc) {
      let containsUri = this.selectedMap.has(targetId);
      if (isSelected && !containsUri) {
        this.selectedMap.set(targetId, this.getMediaItemFunc(targetId));
        this.indexMap.set(this.getMediaItemFunc(targetId), targetIndex);
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

  public toggleEdit(targetId: string, isSelected: boolean, targetIndex?: number): boolean {
    if (this.getMediaItemFunc) {
      let containsUri = this.selectedMap.has(targetId);
      if (isSelected && !containsUri) {
        this.selectedMap.set(targetId, this.getMediaItemFunc(targetId));
        this.indexMap.set(this.getMediaItemFunc(targetId), targetIndex as number);
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

  public toggleEditThree(targetId: string, isSelected: boolean, mediaItem: MediaItem, targetIndex?: number): boolean {
    let containsUri = this.selectedMap.has(targetId);
    if (isSelected && !containsUri) {
      this.selectedMap.set(targetId, mediaItem);
      this.indexMap.set(mediaItem, targetIndex as number);
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
    this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')?.(this.getSelectedCount());
    if (targetIndex !== undefined) {
      this.mCallbacks.has('select') && this.mCallbacks.get('select')?.(targetIndex);
    }
    return true;
  }

  public deSelectAll(): void {
    this.selectedMap.clear();
    this.indexMap.clear();
    super.deSelectAll();
  }

  public getSelectItemIndex(item: MediaItem): number {
    let index = 0;
    for (let selectItem of this.selectedMap.values()) {
      if (item === selectItem) {
        return index;
      }
      index++;
    }
    return Constants.INVALID;
  }

  public getSelectItemDataSourceIndex(item: MediaItem): number {
    return this.indexMap.get(item) ? this.indexMap.get(item) : Constants.INVALID;
  }

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

  public getSelectItems(): Array<MediaItem> {
    let itemArray = new Array<MediaItem>();
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

  public refreshData(): void {
    this.mCallbacks.has('refreshData') && this.mCallbacks.get('refreshData')(true);
  }
}

export class TimelineSelectManager extends SelectManager {
  mGroupData: TimelineData[] = [];
  mSelectionEntryArray: BucketSelectionEntry[] = [];

  constructor() {
    super();
  }

  public selectAll(reverseSelection: boolean): void {
    Log.info(TAG, `selectAll ${reverseSelection}`);
    if (reverseSelection) {
      this.inverseSelection = true;
      this.clearEntryArray();
      this.isAllSelected = true;
    } else {
      this.isAllSelected = true;
    }
    AppStorage.setOrCreate('focusUpdate', true);
    this.mCallbacks.has('updateGroupCount') && this.mCallbacks.get('updateGroupCount')();
    this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')(true);
    this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')(this.getSelectedCount());
  }

  public deSelectAll(): void {
    this.inverseSelection = false;
    this.isAllSelected = false;
    this.clearEntryArray();
    AppStorage.setOrCreate('focusUpdate', true);
    this.mCallbacks.has('updateGroupCount') && this.mCallbacks.get('updateGroupCount')();
    this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')(false);
    this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')(this.getSelectedCount());
  }

  public toggle(targetId: string, isSelected: boolean, targetIndex: number): boolean {
    Log.info(TAG, `toggleTimeline ${targetIndex} id: ${targetId} ${isSelected}`);
    let itemCoordinate = this.getCoordinateFromPosition(targetIndex);
    let entry = this.getGroupEntry(itemCoordinate);
    this.toggleClickSet(entry, targetId, isSelected);
    let entrySelectedCount = entry.getSelectedCount();
    Log.info(TAG, `check all selected ${entrySelectedCount} ${entry.getTotalCount()}`);

    if (entrySelectedCount == entry.getTotalCount()) {
      Log.info(TAG, 'group selectAll');
      entry.selectAll();
    }

    this.mCallbacks.has('updateGroupCount') && this.mCallbacks.get('updateGroupCount')();

    if (this.isAllSelected && (entrySelectedCount < entry.getTotalCount())) {
      this.isAllSelected = false;
      this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')(this.getSelectedCount());
    }

    if (this.getSelectedCount() == this.totalCount) {
      this.isAllSelected = true;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')(true);
      this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')(this.getSelectedCount());
    } else {
      this.isAllSelected = false;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')(false);
      this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')(this.getSelectedCount());
    }
    return true;
  }

  public toggleGroup(itemCoordinate: ItemCoordinate): boolean {
    Log.info(TAG, `check  toggleGroup: ${itemCoordinate.getGroupId()}`);
    if (this.inverseSelection) {
      let entry = this.mSelectionEntryArray[itemCoordinate.getGroupId()];
      if (entry == undefined) {
        entry = this.getGroupEntry(itemCoordinate);
        entry.selectAll();
      } else {
        entry.changeSelectMode(true);
      }
    } else {
      let entry = this.getGroupEntry(itemCoordinate);
      entry.changeSelectMode(false);
    }

    let count = this.getSelectedCount();
    if (count == this.totalCount) {
      this.selectAll(false);
    }
    this.mCallbacks.has('updateGroupCount') && this.mCallbacks.get('updateGroupCount')();
    this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')(this.getSelectedCount());
    if (this.getSelectedCount() == this.totalCount) {
      this.isAllSelected = true;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')(true);
    } else {
      this.isAllSelected = false;
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')(false);
    }
    return true;
  }

  public getTitleCoordinate(position: number): ItemCoordinate {
    return new ItemCoordinate().setGroupId(position).setIndex(-1);
  }

  public getSelectedCount(): number {
    let count = 0;
    this.mSelectionEntryArray.forEach((item) => {
      count += item ? item.getSelectedCount() : 0;
    })
    if (this.inverseSelection) {
      Log.info(TAG, `inverseSelection totalCount: ${this.totalCount - count}`);
      return this.totalCount - count;
    }
    return count;
  }

  public onModeChange(newMode: boolean): void {
    if (newMode) {
      this.mIsSelectedMode = true;
    } else {
      this.mIsSelectedMode = false;
      this.inverseSelection = false;
      this.isAllSelected = false;
      this.clearEntryArray();
      AppStorage.setOrCreate('focusUpdate', true);
      this.mCallbacks.has('updateGroupCount') && this.mCallbacks.get('updateGroupCount')();
      this.mCallbacks.has('allSelect') && this.mCallbacks.get('allSelect')(false);
      this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')(this.getSelectedCount());
    }
  }

  public isItemSelected(targetId: string, index: number): boolean {
    let itemCoordinate = this.getCoordinateFromPosition(index);
    let entry = this.mSelectionEntryArray[itemCoordinate.getGroupId()];
    if (this.inverseSelection) {
      return (entry == undefined) || (!entry.isItemSelected(targetId));
    } else {
      return (entry != undefined) && (entry.isItemSelected(targetId));
    }
  }

  public isGroupSelected(index: number): boolean {
    let entry = this.mSelectionEntryArray[index];
    if (this.inverseSelection) {
      return entry == null || entry.getSelectedCount() == 0;
    } else {
      return (entry != null) && (entry.inSelectAllMode());
    }
  }

  public setGroupData(groupData: TimelineData[]): void {
    if (groupData == undefined) {
      return;
    }
    this.mGroupData = groupData;
  }

  public updateGroupData(groupData: TimelineData[]): void {
    if (groupData == undefined) {
      return;
    }
    this.mGroupData = groupData;
    this.mSelectionEntryArray.forEach((entry: BucketSelectionEntry) => {
      if (entry != undefined && (entry.getGroupId() < this.mGroupData.length)) {
        entry.setTotalCount(this.mGroupData[entry.getGroupId()].count);
      }
    })
    this.mCallbacks.has('updateCount') && this.mCallbacks.get('updateCount')(this.getSelectedCount());
  }

  public async getSelection(callback: AsyncCallback<string[]>): Promise<void> {
    let result = new Array<string>();
    let start = 0;
    let doneCount = 0;
    if (this.inverseSelection) {
      for (let i = 0; i < this.mGroupData.length; i++) {
        if (this.mSelectionEntryArray[i]) {
          //全选模式下用户操作过的日期下的items根据用户选择反选
          await this.getInverseSelectedFromEntry(this.mSelectionEntryArray[i],
            start, this.mGroupData[i].count, (temp: string[]) => {
              result = result.concat(temp);
              Log.info(TAG, `getInverseSelectedFromEntry result ${result.length}`);
              doneCount++;
              this.checkIsGetSelectionFinish(doneCount, result, callback);
            });
        } else {
          //全选模式下用户未操作过的日期下的items全量选中
          await this.getItems(this.photoDataImpl, start, this.mGroupData[i].count, (temp: MediaItem[]) => {
            temp.forEach((item) => {
              result.push(item.uri);
            });
            Log.info(TAG, `getInverseGroupItems result ${result.length}`);
            doneCount++;
            this.checkIsGetSelectionFinish(doneCount, result, callback);
          });
        }
        start += this.mGroupData[i].count;
      }
    } else {
      for (let i = 0; i < this.mGroupData.length; i++) {
        if (this.mSelectionEntryArray[i]) {
          //正选模式下根据遍历日期分组用户选择正常取item
          await this.getSelectedFromEntry(this.mSelectionEntryArray[i],
            start, this.mGroupData[i].count, (temp: string[]) => {
              Log.info(TAG, `getSelectedFromEntry result ${result.length}`);
              result = result.concat(temp);
              doneCount++;
              this.checkIsGetSelectionFinish(doneCount, result, callback);
            });
        } else {
          //正选模式下未操作过的分组直接跳过
          doneCount++;
          this.checkIsGetSelectionFinish(doneCount, result, callback);
        }
        start += this.mGroupData[i].count;
      }
    }
  }

  public async getSelectedItems(callback: Function): Promise<void> {
    Log.info(TAG, 'getSelectedItems');
    let result = new Array<MediaItem>();
    let start = 0;
    let doneCount = 0;
    if (this.inverseSelection) {
      Log.info(TAG, 'getSelectedItems: mode is inverseSelection');
      for (let i = 0; i < this.mGroupData.length; i++) {
        if (this.mSelectionEntryArray[i]) {
          if (this.mSelectionEntryArray[i].getInverseSelection()) {
            await this.getItems(this.photoDataImpl, start, this.mGroupData[i].count, (temp: MediaItem[]) => {
              temp.forEach((item) => {
                if (this.mSelectionEntryArray[i].getClickSet().has(item.uri)) {
                  Log.debug(TAG, 'push one item');
                  result.push(item);
                }
              });
              doneCount++;
              this.checkIsGetSelectionItemFinish(doneCount, result, callback);
            });
          } else {
            await this.getItems(this.photoDataImpl, start, this.mGroupData[i].count, (temp: MediaItem[]) => {
              temp.forEach((item) => {
                if (!this.mSelectionEntryArray[i].getClickSet().has(item.uri)) {
                  Log.debug(TAG, 'push one inverse item');
                  result.push(item);
                }
              });
              doneCount++;
              this.checkIsGetSelectionItemFinish(doneCount, result, callback);
            });
          }
        } else {
          await this.getItems(this.photoDataImpl, start, this.mGroupData[i].count, (temp: MediaItem[]) => {
            temp.forEach((item) => {
              result.push(item);
            });
            doneCount++;
            this.checkIsGetSelectionItemFinish(doneCount, result, callback);
          });
        }
        start += this.mGroupData[i].count;
      }
    } else {
      Log.info(TAG, 'getSelectedItems: mode is not inverseSelection');
      for (let i = 0; i < this.mGroupData.length; i++) {
        if (this.mSelectionEntryArray[i]) {
          await this.getItems(this.photoDataImpl, start, this.mGroupData[i].count, (temp: MediaItem[]) => {
            const entry = this.mSelectionEntryArray[i];
            temp.forEach((item) => {
              if (!entry.getInverseSelection()) {
                if (entry.getClickSet().has(item.uri)) {
                  Log.debug(TAG, 'push one item');
                  result.push(item);
                }
              } else if (!entry.getClickSet().has(item.uri)) {
                Log.debug(TAG, 'push one inverse item');
                result.push(item);
              }
            });
            doneCount++;
            this.checkIsGetSelectionItemFinish(doneCount, result, callback);
          });
        } else {
          doneCount++;
          this.checkIsGetSelectionItemFinish(doneCount, result, callback);
        }
        start += this.mGroupData[i].count;
      }
    }
  }

  private toggleClickSet(entry: BucketSelectionEntry, targetId: string, isSelected: boolean): void {
    Log.info(TAG, `toggleClickSet: ${targetId} + ${isSelected}`);
    if (isSelected == (!this.inverseSelection)) {
      this.toggleEntryItem(entry, targetId, true);
    } else {
      this.toggleEntryItem(entry, targetId, false);
    }
  }

  private toggleEntryItem(entry: BucketSelectionEntry, targetId: string, isSelected: boolean): void {
    Log.info(TAG, `toggleEntryItem ${targetId} ${isSelected}`);
    let clickSet = entry.getClickSet();
    if (isSelected != entry.getInverseSelection()) {
      clickSet.add(targetId);
    } else {
      clickSet.delete(targetId);
    }
  }

  private getCoordinateFromPosition(position: number): ItemCoordinate {
    let index = 0;
    let group = 0;
    let totalSize = this.mGroupData.length;
    for (; group < totalSize; group++) {
      let count = this.mGroupData[group].count;
      index += (count + 1);
      if (index > position) {
        index -= count;
        group = Math.max(0, group);
        break;
      }
    }
    return new ItemCoordinate().setGroupId(group).setIndex(position - index);
  }

  private getGroupEntry(itemCoordinate: ItemCoordinate): BucketSelectionEntry {
    let entry = this.mSelectionEntryArray[itemCoordinate.groupId];
    if (entry == undefined) {
      entry = new BucketSelectionEntry();
      entry.setGroupId(itemCoordinate.groupId);
      if (itemCoordinate.groupId >= 0 && itemCoordinate.groupId < this.mGroupData.length) {
        Log.info(TAG, `entry.setTotalCount ${this.mGroupData[itemCoordinate.groupId].count}`);
        entry.setTotalCount(this.mGroupData[itemCoordinate.groupId].count);
      }
      Log.info(TAG, `getGroupEntry mSelectionEntryArray ${itemCoordinate.groupId} entry: ${entry}`);
      this.mSelectionEntryArray[itemCoordinate.groupId] = entry;
    }
    return entry;
  }

  private clearEntryArray(): void {
    Log.info(TAG, 'clearEntryArray');
    this.mSelectionEntryArray.length = 0;
  }

  private checkIsGetSelectionFinish(doneCount: number, result: string[], callback: AsyncCallback<string[]>): void {
    if (this.mGroupData.length == doneCount) {
      Log.info(TAG, `getSelection result ${result.length}`);
      callback.callback(result);
    }
  }

  private checkIsGetSelectionItemFinish(doneCount: number, result: MediaItem[], callback: Function): void {
    if (this.mGroupData.length == doneCount) {
      Log.info(TAG, `getSelection result ${result.length}`);
      callback(result);
    }
  }

  private async getSelectedFromEntry(entry: BucketSelectionEntry,
                                     start: number, count: number, callback: Function): Promise<void> {
    Log.info(TAG, `getSelectedFromEntry start: ${start}, count: ${count}`);
    let result = new Array<string>();
    if (entry.getInverseSelection()) {
      await this.getItems(this.photoDataImpl, start, count, (temp: MediaItem[]) => {
        temp.forEach((item) => {
          if (!entry.getClickSet().has(item.uri)) {
            result.push(item.uri);
          }
        });
        callback(result);
      });
    } else {
      Log.info(TAG, 'getSelectedFromEntry not inverse');
      result = Array.from(entry.getClickSet());
      callback(result);
    }
  }

  private async getInverseSelectedFromEntry(entry: BucketSelectionEntry,
                                            start: number, count: number, callback: Function): Promise<void> {
    Log.info(TAG, `getInverseSelectedFromEntry start: ${start}, count: ${count}`);
    let result = new Array<string>();
    if (entry.getInverseSelection()) {
      result = Array.from(entry.getClickSet());
      callback(result);
    } else {
      Log.info(TAG, 'getInverseSelectedFromEntry not inverse');
      await this.getItems(this.photoDataImpl, start, count, (temp: MediaItem[]) => {
        Log.info(TAG, `enter callback temp: ${entry.getClickSet().size}`);
        temp.forEach((item) => {
          if (!entry.getClickSet().has(item.uri)) {
            result.push(item.uri);
          }
        });
        Log.info(TAG, `enter callback result ${result.length}`);
        callback(result);
      });
    }
  }
}

export class AlbumSetSelectManager extends SelectManager {
  isDisableRenameClickedSet: Set<string> = new Set();
  isDisableDeleteClickedSet: Set<string> = new Set();

  constructor() {
    super();
  }

  public toolBarStateToggle(targetId: string, isSelected: boolean,
                            isDisableRename: boolean, isDisableDelete: boolean): void {
    Log.info(TAG, `toolBarStateToggle${targetId}/${isSelected}/${isDisableRename}/${isDisableDelete}`);
    if (isSelected == (!this.inverseSelection)) {
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

    let isDisableRenameFlag = !(this.isDisableRenameClickedSet.size == 0);
    let isDisableDeleteFlag = !(this.isDisableDeleteClickedSet.size == 0);
    this.mCallbacks.has('updateToolBarState') &&
    this.mCallbacks.get('updateToolBarState')(isDisableRenameFlag, isDisableDeleteFlag);
  }

  public onModeChange(newMode: boolean): void {
    super.onModeChange(newMode);
    if (!newMode) {
      this.isDisableRenameClickedSet.clear();
      this.isDisableDeleteClickedSet.clear();
    }
  }
}