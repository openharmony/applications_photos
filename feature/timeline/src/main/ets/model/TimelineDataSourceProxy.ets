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

import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { ViewData } from '@ohos/common/src/main/ets/default/model/browser/photo/ViewData';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { TimelineDataSourceManager } from './TimelineDataSourceManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { ViewType } from '@ohos/common/src/main/ets/default/model/browser/photo/ViewType';
import lazy { SimpleGridMediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/SimpleGridMediaItem';
import lazy { TimelineData } from '@ohos/common/src/main/ets/default/model/browser/photo/TimelineData';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { QueryParam } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';

const TAG: string = 'TimelineDataSourceProxy';
const TITLE_DATA_INDEX = -1;

class DataChangeListenerWrapper implements DataChangeListener {
  public readonly listener: DataChangeListener;
  private readonly proxy: TimelineDataSourceProxy;

  public constructor(proxy: TimelineDataSourceProxy, listener: DataChangeListener) {
    this.proxy = proxy;
    this.listener = listener;
  }

  public onDataReloaded(): void {
    this.listener.onDataReloaded();
  }

  /* instrument ignore next */
  public onDataAdded(index: number): void {
    this.onDataAdd(index);
  }

  /* instrument ignore next */
  public onDataAdd(index: number): void {
    this.listener.onDataAdd(this.proxy.dataToLayout(index));
  }

  /* instrument ignore next */
  public onDataMoved(from: number, to: number): void {
    this.onDataMove(from, to);
  }

  /* instrument ignore next */
  public onDataMove(from: number, to: number): void {
    this.listener.onDataMove(this.proxy.dataToLayout(from), this.proxy.dataToLayout(to));
  }

  /* instrument ignore next */
  public onDataDeleted(index: number): void {
    this.onDataDelete(index);
  }

  /* instrument ignore next */
  public onDataDelete(index: number): void {
    this.listener.onDataDelete(this.proxy.dataToLayout(index));
  }

  /* instrument ignore next */
  public onDataChanged(index: number): void {
    this.onDataChange(index);
  }

  /* instrument ignore next */
  public onDataChange(index: number): void {
    this.listener.onDataChange(this.proxy.dataToLayout(index));
  }

  /* instrument ignore next */
  public onDatasetChange(dataOperations: DataOperation[]): void {
    this.listener.onDataReloaded();
  }
}

export class TimelineDataSourceProxy extends AlbumDataSource {
  private dataSource: MediaDataSource = TimelineDataSourceManager.getInstance().getDataSource();
  public groupGlobalOffsets: number[] = [];
  public groupGlobalIndex: number[] = [];
  // 是否更新滑窗标识
  private enableSlideWindow: boolean = true;
  private readonly wrappers: DataChangeListenerWrapper[] = [];

  constructor(dataSource?: MediaDataSource) {
    super({
      context: getContext() || global.uiAbilityContext(),
      albumInfo: dataSource?.albumInfo ?? new AlbumInfo(),
    });
    this.tag = TAG;
    if (dataSource) {
      this.dataSource = dataSource;
    }
  }

  public getDataSource(): MediaDataSource {
    return this.dataSource;
  }

  public override getGroupData(): TimelineData[] {
    return this.dataSource?.getGroupData() ?? [];
  }

  public override layoutToData(index: number): number {
    return index - this.dataSource?.timeGroupIndexes(index) - 1;
  }

  public override dataToLayout(index: number): number {
    if (index < 0) {
      return index;
    }
    return this.dataToLayoutInGroup(index);
  }

  public override getGroupCountBeforeItem(item: MediaItem | undefined): number {
    if (!item) {
      return 0;
    }
    let groupCount = 0;
    let itemTime: number = item.getDateTaken();
    Log.info(TAG, `updateIndex: itemTime ${itemTime}`)
    if (!this.dataSource) {
      return groupCount;
    }
    /* instrument ignore next */
    for (let index = 0; index < this.getGroupData().length; index++) {
      const group: TimelineData = this.getGroupData()[index];
      if (DateUtil.isTheSameDay(itemTime, group.startDate as number)) {
        groupCount = index + 1;
        break;
      }
    }
    return groupCount;
  }

  public findGroupViewIndexes(index: number): number {
    return this.dataSource?.findGroupViewIndexes(index);
  }

  public timeGroupIndexes(index: number): number {
    return this.dataSource?.timeGroupIndexes(index);
  }

  public indexesToGroup(index: number): TimelineData | undefined {
    return this.dataSource?.getGroupData()[index];
  }

  public getDataByDisplayName(displayName: string): MediaItem | undefined {
    let res: MediaItem | undefined;
    if (!this.dataSource || !displayName) {
      return res;
    }
    let targetName: string = displayName.replace('_enhanced', '');
    /* instrument ignore next */
    for (let i = this.dataSource.activeStart; i < this.dataSource.activeEnd; i++) {
      let mediaItem: MediaItem = this.dataSource.getRawData(i) ?? new MediaItem();
      if (mediaItem.displayName === targetName) {
        return mediaItem;
      }
    }
    return res;
  }

  /* instrument ignore next */
  public computeGroupGlobalOffset(imageGridHeight: number, timeTitleHeight: number, gridColCnt: number): void {
    let gutter: number = DeviceInfo.isPc() ? Constants.PC_GRID_GUTTER : Constants.GRID_GUTTER;
    let imageGridItemHeight: number = imageGridHeight + gutter;
    let timelineTitleHeight: number = timeTitleHeight + gutter;
    let groupLength: number = this.dataSource?.getGroupData().length;
    let currentTitleIndex = 1;
    this.groupGlobalOffsets = [];
    this.groupGlobalIndex = [];
    this.groupGlobalOffsets.push(0);
    this.groupGlobalIndex.push(currentTitleIndex);
    for (let groupIndex = 0; groupIndex < groupLength - 1; groupIndex++) {
      let groupCount = this.dataSource?.getGroupData()[groupIndex].count as number;
      currentTitleIndex = currentTitleIndex + this.dataSource?.getGroupData()[groupIndex].count + 1;
      this.groupGlobalIndex.push(currentTitleIndex);
      let groupRow = Math.ceil(groupCount / gridColCnt);
      let groupOffset = groupRow * imageGridItemHeight + timelineTitleHeight;
      let groupGlobalOffset = groupOffset + this.groupGlobalOffsets[groupIndex];
      this.groupGlobalOffsets.push(groupGlobalOffset);
    }
  }

  public computeMaxGridOffset(imageGridHeight: number, timeTitleHeight: number, gridColCnt: number): number {
    let gutter: number = DeviceInfo.isPc() ? Constants.PC_GRID_GUTTER : Constants.GRID_GUTTER;
    let imageGridItemHeight: number = imageGridHeight + gutter;
    let timelineTitleHeight: number = timeTitleHeight + gutter;
    let groupLength: number = this.dataSource?.getGroupData().length;
    let groupGlobalOffsetLength: number = this.groupGlobalOffsets.length;
    let maxOffset: number = 0;
    if (groupLength == 0) {
      return maxOffset;
    }
    /* instrument ignore next */
    let lastGroupCnt = this.dataSource?.getGroupData()[groupLength - 1].count as number;
    let lastGroupOffset = Math.ceil(lastGroupCnt / gridColCnt) * imageGridItemHeight + timelineTitleHeight;
    maxOffset = lastGroupOffset + this.groupGlobalOffsets[groupGlobalOffsetLength - 1] - gutter;
    return maxOffset;
  }

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
    /* instrument ignore if */
    if (currentHeight <= offset) {
      targetIndex++;
      let gapRow: number = Math.floor((offset - currentHeight) / imageGridItemHeight);
      targetIndex += gapRow * gridColCnt;
    }
    /* instrument ignore next */
    return targetIndex;
  }

  public computeStartIndexWithMassage(offset: number, imageGridHeight: number, timeTitleHeight: number,
    gridColCnt: number): number {
    let startIndex = this.computeStartIndex(offset, imageGridHeight, timeTitleHeight, gridColCnt);
    let startIndexWithMassage = startIndex < 0 ? 0 : startIndex;
    return startIndexWithMassage;
  }

  getGroupIndexByDataIndex(dataIndex: number): number {
    return this.dataSource?.getGroupIndexByDataIndex(dataIndex);
  }

  // 获取数据总数
  totalCount(): number {
    return this.dataSource?.totalCount() + this.dataSource?.getGroupData().length;
  }

  /* instrument ignore next */
  getData(layoutIndex: number): ViewData | undefined {
    if (!this.enableGetDataFlag) {
      return ViewData.getEmptyInstance();
    }

    const wrappedData = this.getWrappedData(layoutIndex);
    let isThumbnailInvalid: boolean = !wrappedData?.mediaItem?.thumbnail;
    if (isThumbnailInvalid && wrappedData) {
      let simpleMediaItem = this.getSimpleMediaItem(layoutIndex);
      if (simpleMediaItem) {
        wrappedData.simpleMediaItem = simpleMediaItem;
        wrappedData.mediaItem = new MediaItem();
        wrappedData.mediaItem.thumbnail = simpleMediaItem.getThumbnailUri();
        wrappedData.mediaItem.uri = simpleMediaItem.uri;
        isThumbnailInvalid = !wrappedData.mediaItem.thumbnail;
      }
    }
    if (layoutIndex !== 0 && isThumbnailInvalid) {
      Log.error(TAG, `getData index: ${layoutIndex} thumbnail is null`);
    }
    this.updateSlidingWindow(this.layoutToData(layoutIndex));
    Log.info(TAG, `Group get data index=${layoutIndex}, ${this.enableGroupSlidingWindowFlag} ` +
      `(${this.dataSource.activeStart} to ${this.dataSource.activeEnd}) id=${wrappedData?.mediaItem?.uniqueId},` +
      `, dateDay:${wrappedData?.mediaItem?.getDateDay()}, dateTaken:${wrappedData?.mediaItem?.getDateTaken()}`);
    return wrappedData;
  }

  public getWrappedData(index: number): ViewData | undefined {
    let dataIndexInWindow: number = this.layoutToData(index) - this.dataSource?.activeStart;
    let result: ViewData;
    if (this.findGroupViewIndexes(index) === TITLE_DATA_INDEX) {
      let firstDataIndexInGroup = this.layoutToData(index + 1) - this.dataSource?.activeStart;
      const mediaItem: MediaItem = this.dataSource?.getMediaItemSafely(firstDataIndexInGroup);
      result = new ViewData(undefined);
      result.viewType = ViewType.GROUP_TITLE;
      result.viewData = this.dataSource?.getGroupData()[this.dataSource?.timeGroupIndexes(index)];
      result.viewIndex = this.dataSource?.timeGroupIndexes(index);
      result.mediaItem = mediaItem;
      return result;
    }
    /* instrument ignore if */
    if (dataIndexInWindow > this.dataSource?.items.length + this.dataSource?.getGroupData().length || dataIndexInWindow < 0) {
      Log.error(TAG,
        `index out of active window index=${index}, start:${this.dataSource?.activeStart}, data:${dataIndexInWindow}`);
      return ViewData.getEmptyInstance();
    }
    const mediaItem: MediaItem = this.dataSource?.getMediaItemSafely(dataIndexInWindow);
    const tmp: ViewData | undefined = this.viewDataCache.get(mediaItem.uniqueId);
    if (tmp) {
      result = tmp;
      result.update(mediaItem);
    } else {
      result = new ViewData(mediaItem);
      this.viewDataCache.set(mediaItem.uniqueId, result);
    }
    result.viewType = ViewType.ITEM;
    result.viewIndex = index;
    return result;
  }

  /**
   * 注册监听
   * @param listener
   */
  public registerDataChangeListener(listener: DataChangeListener): void {
    /* instrument ignore if */
    if (!listener) {
      Log.error(TAG, 'register empty DataChangeListener');
      return;
    }

    Log.info(TAG, 'registerDataChangeListener');
    let wrapper: DataChangeListenerWrapper | undefined = this.getWrapper(listener);
    if (!wrapper) {
      wrapper = new DataChangeListenerWrapper(this, listener);
      this.wrappers.push(wrapper);
    }
    this.dataSource?.registerDataChangeListener(wrapper);
  }

  /**
   * 取消监听
   * @param listener
   */
  public unregisterDataChangeListener(listener: DataChangeListener): void {
    /* instrument ignore if */
    if (!listener) {
      Log.error(TAG, 'unregister empty DataChangeListener');
      return;
    }

    Log.info(TAG, 'unregisterDataChangeListener');
    let wrapper: DataChangeListenerWrapper | undefined = this.getWrapper(listener);
    /* instrument ignore if */
    if (!wrapper) {
      Log.info(TAG, 'unregisterDataChangeListener not found');
      this.dataSource?.unregisterDataChangeListener(listener);
      return;
    }
    /* instrument ignore next */
    this.dataSource?.unregisterDataChangeListener(wrapper);
  }

  private getWrapper(listener: DataChangeListener): DataChangeListenerWrapper | undefined {
    let result: DataChangeListenerWrapper | undefined = undefined;
    this.wrappers.forEach((wrapper: DataChangeListenerWrapper) => {
      if (wrapper.listener === listener) {
        result = wrapper;
      }
    });
    return result;
  }

  /**
   * get DataIndex with item
   * @param item
   * @returns
   */
  public getDataIndex(item: MediaItem | undefined): number {
    if (!item || !item.uniqueId) {
      return Constants.NOT_FOUND;
    }
    /* instrument ignore next */
    for (let i = 0; i < this.dataSource?.items.length; i++) {
      if (this.dataSource?.items[i]?.uniqueId === item.uniqueId) {
        return i + this.dataSource?.activeStart;
      }
    }
    /* instrument ignore next */
    return Constants.NOT_FOUND;
  }

  /**
   * 同步结果：在当前结果集中能查到则返回，查不到返回undefined
   * @param uri
   * @param itemNotifyCallback
   * @returns
   */
  public getMediaItemByUri(uri: string, itemNotifyCallback?: Function): MediaItem | undefined {
    return this.dataSource?.getMediaItemByUri(uri, itemNotifyCallback);
  }

  public enableGetData(flag: boolean): void {
    this.enableGetDataFlag = flag;
  }

  /**
   * 重新加载数据
   */
  /* instrument ignore next */
  public onDataReloaded(): void {
    this.dataSource?.onDataReloaded();
  }

  public onDataChange(layoutIndex: number): void {
    this.dataSource?.onDataChange(layoutIndex);
  }

  public onDataAdd(layoutIndex: number): void {
    this.dataSource?.onDataAdd(layoutIndex);
  }

  public onDataDelete(layoutIndex: number): void {
    this.dataSource?.onDataDelete(layoutIndex);
  }

  /* instrument ignore next */
  public setYearMonthDayViewIndex(yearMonthDayViewIndex: number): void {
    if (!this.dataSource || !this.dataSource.enableGetDataFlag) {
      return;
    }
    this.dataSource.yearMonthDayViewIndex = yearMonthDayViewIndex;
  }

  /**
   * get raw MediaItem data
   * @param layoutIndex
   * @returns
   */
  public getRawData(layoutIndex: number): MediaItem | undefined {
    const dataIndex = this.layoutToData(layoutIndex);
    return this.dataSource?.getRawData(dataIndex);
  }

  /**
   * instrument ignore next
   * @param item
   * @returns
   */
  public getIndexByMediaItem(item: MediaItem): number {
    return this.dataSource?.getIndexByMediaItem(item);
  }

  public createSimpleMediaItems(capacity: number): void {
    this.dataSource?.createSimpleMediaItems(capacity);
  }

  /**
   * 获取相册uri
   * @returns
   */
  public getAlbumUri(): string {
    return this.dataSource?.getAlbumUri();
  }

  /* instrument ignore next */
  public enableQueryData(flag: boolean): void {
    this.dataSource?.enableQueryData(flag);
  }

  /* instrument ignore next */
  public onChange(mediaType: string, isForceUpdate?: boolean): void {
    this.dataSource?.onChange(mediaType, isForceUpdate);
  }

  public getValidStartIndex(): number {
    return this.dataSource?.getValidStartIndex();
  }

  /**
   * Search for the index of last valid item in 500 items
   * @returns
   */
  public getValidEndIndex(): number {
    return this.dataSource?.getValidEndIndex();
  }

  public getSimpleMediaItem(index: number): SimpleGridMediaItem | undefined {
    return this.dataSource?.getSimpleMediaItem(index);
  }

  /* instrument ignore next */
  public recordSimpleMediaItem(index: number, item: SimpleGridMediaItem): void {
    this.dataSource?.recordSimpleMediaItem(index, item, true);
  }

  public override getQueryParam(start: number, count: number): QueryParam {
    if (this.dataSource) {
      return this.dataSource.getQueryParam(start, count);
    }
    return super.getQueryParam(start, count);
  }

  /**
   * 更新滑动窗口
   * @param dataIndex
   */
  public updateSlidingWindow(dataIndex: number): void {
    /* instrument ignore if */
    if (this.enableGroupSlidingWindowFlag) {
      this.dataSource?.updateSlidingWindow(dataIndex);
    }
  }
}