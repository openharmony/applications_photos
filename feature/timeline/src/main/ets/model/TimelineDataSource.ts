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

import type { BrowserDataInterface, PendingCondition } from '@ohos/common';
import {
  BroadCast,
  BrowserDataFactory,
  CommonObserverCallback,
  Constants,
  DateUtil,
  Log,
  MediaDataSource,
  MediaItem,
  MediaObserver,
  PendingTask,
  TimelineData,
  TraceControllerUtils,
  ViewData,
  ViewType
} from '@ohos/common';
import { GetTimelineDataCallback } from './GetTimelineDataCallback';

const TITLE_DATA_INDEX = -1;
const TAG: string = 'timeline_TimelineDataSource';

// TimelineDataSource
export class TimelineDataSource extends MediaDataSource {
  initDataTraceName = 'TimeLinePageInitData';
  dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  groups: TimelineData[] = [];

  // layoutIndex to groupIndex
  groupIndexes: number[] = [];
  groupViewIndexes: number[] = [];
  isActive = false;
  pendingEmitCallbacks: PendingTask;
  groupBrowserDataImpl: BrowserDataInterface;

  constructor(windowSize: number, broadCast: BroadCast) {
    super(windowSize);
    this.groupBrowserDataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_GROUP);
    this.broadCast = broadCast;
    this.pendingEmitCallbacks = new PendingTask(<PendingCondition> {
      shouldPending: () => {
        return !this.isActive;
      }
    });
    this.initData();
  }

  initialize(): void {
  }

  getGroupData(): TimelineData[] {
    return this.groups;
  }

  loadData() {
    let callback: GetTimelineDataCallback = new GetTimelineDataCallback(this);
    this.groupBrowserDataImpl.getData(callback, null);
  }

  public registerTimelineObserver(): void {
    MediaObserver.getInstance().registerObserver(this.dataObserver);
  }

  public unregisterTimelineObserver(): void {
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    if (!this.isActive) {
      this.pendingEmitCallbacks.clear();
    }
    this.switchRefreshOn();
    this.onChange(changeType);
  }

  updateGroupData(requestTime: number, groups: TimelineData[]): void {
    TraceControllerUtils.startTraceWithTaskId('updateGroupData', requestTime);
    Log.info(TAG, 'updateGroupData begin');
    this.lastUpdateTime = requestTime;

    this.isPendingUpdateData = true;
    this.pendingEmitCallbacks.execute(() => {
      this.updateGroupSize(requestTime, groups);
    })

    TraceControllerUtils.finishTraceWithTaskId('updateGroupData', requestTime);
    this.isPendingUpdateData = false;
    this.pendingUpdateData.flush();

  }

  /**
   * Update related variables of group count
   *
   * @param requestTime
   * @param groups
   */
  updateGroupSize(requestTime: number, groups: TimelineData[]): void {
    Log.info(TAG, 'updateGroupSize');
    let previousSize: number = this.size;
    let previousMediaCount = this.mediaCount;
    this.groups = groups;
    this.mCallbacks['updateGroupData'] && this.mCallbacks['updateGroupData'](this.groups)
    this.size = 0;
    this.mediaCount = 0;
    this.dataIndexes = [];
    this.layoutIndexes = [];
    this.groupIndexes = [];
    this.groupViewIndexes = [];
    let dataIndex = 0;
    for (let groupIndex = 0; groupIndex < groups.length; groupIndex++) {
      let group = groups[groupIndex];
      this.mediaCount += group.count;

      // title
      this.size++;
      this.dataIndexes.push(TITLE_DATA_INDEX);
      this.groupIndexes.push(groupIndex);
      this.groupViewIndexes.push(TITLE_DATA_INDEX);

      // items
      for (let i = 0; i < group.count; i++) {
        this.dataIndexes.push(dataIndex);
        this.groupIndexes.push(groupIndex);
        this.layoutIndexes.push(this.size);
        this.groupViewIndexes.push(i);
        this.size++;
        dataIndex++;
      }
    }

    Log.info(TAG, `updateGroupSize, old size: ${previousSize} , old mediaCount: ${previousMediaCount},\
            new size: ${this.size}, new mediaCount: ${this.mediaCount}, real size: ${this.realSize}`);

    this.isCountChanged = previousSize != this.size;
    this.isCountReduced = previousSize > this.size;
    if (requestTime !== Constants.NUMBER_0) {
      this.addedCount = (this.realSize > Constants.NUMBER_0) ? (this.size - this.realSize) : Constants.NUMBER_0;
      this.realSize = this.size;
    }
    this.updateCountPostProcess();
  }

  emitCountUpdateCallbacks(): void {
    this.pendingEmitCallbacks.execute(() => {
      super.emitCountUpdateCallbacks();
    })
  }

  updateCountThroughMediaItems(requestTime: number, mediaItems: MediaItem[]): void {
    Log.info(TAG, 'updateCountThroughMediaItems');
    this.updateGroupSize(0, this.getGroupDataThroughMediaItems(mediaItems));
  }

  // Get grouping information through media item
  getGroupDataThroughMediaItems(mediaItems: MediaItem[]): TimelineData[] {
    Log.info(TAG, 'getGroupDataThroughMediaItems');
    let groupDataList: TimelineData[] = [];
    if (mediaItems == null || mediaItems.length == 0) {
      Log.error(TAG, 'getGroupDataThroughMediaItems, mediaItems are empty!');
      return groupDataList;
    }
    let groupCount = 1;
    let startTime = mediaItems[0].getDataTaken();
    let endTime = mediaItems[0].getDataTaken();
    for (let i = 1; i < mediaItems.length; i++) {
      let dateTaken = mediaItems[i].getDataTaken();
      if (DateUtil.isTheSameDay(startTime, dateTaken)) {
        groupCount++;
        endTime = dateTaken;
      } else {
        let groupData = new TimelineData(startTime, endTime, groupCount);
        groupDataList.push(groupData);
        groupCount = 1;
        startTime = dateTaken;
        endTime = dateTaken;
      }
    }
    let groupData = new TimelineData(startTime, endTime, groupCount);
    groupDataList.push(groupData);
    return groupDataList;
  }

  // Packaging data for the view layer
  getWrappedData(index: number): ViewData {
    if (index < 0 || index >= this.dataIndexes.length) {
      Log.error(TAG, `getWrappedData, index out of the total size, index: ${index},
                total size: ${this.dataIndexes.length}`);
      return undefined;
    }
    // title
    if (this.dataIndexes[index] == TITLE_DATA_INDEX) {
      let result: ViewData = {
        viewType: ViewType.GROUP_TITLE,
        viewData: this.groups[this.groupIndexes[index]],
        viewIndex: this.groupIndexes[index],
      };
      Log.debug(TAG, `index: ${index}, type: ${result.viewType},\
        data: ${result.viewData.startDate}, viewIndex: ${result.viewIndex}`);
      return result;
    } else {
      let dataIndexInWindow = this.dataIndexes[index] - this.activeStart;
      let result: ViewData;
      if (dataIndexInWindow > this.items.length || dataIndexInWindow < 0) {
        Log.error(TAG, 'index out of active window');
        return undefined;
      } else {
        result = {
          viewType: ViewType.ITEM,
          mediaItem: this.getMediaItemSafely(dataIndexInWindow),
          viewIndex: index,
          indexInGroup: this.groupViewIndexes[index]
        };
      }
      Log.debug(TAG, `index: ${index}, type: ${result.viewType},\
        data: ${result.mediaItem.uri} indexInGroup: ${result.indexInGroup}`);
      return result;
    }
  }

  getPositionByIndex(index: number): number {
    let pos = (this.dataIndexes || []).findIndex((item) => item === index);
    Log.info(TAG, `pos ${index}, ${this.dataIndexes[pos]} , ${this.groupIndexes[pos]}`);
    return this.dataIndexes[pos] + this.groupIndexes[pos] + 1;
  }

  getMediaItemByPosition(position: number): MediaItem {
    // title
    let index = position
    if (this.dataIndexes[position] == TITLE_DATA_INDEX) {
      index = index + 1
    }
    let dataIndexInWindow = this.dataIndexes[index] - this.activeStart;
    if (dataIndexInWindow > this.items.length || dataIndexInWindow < 0) {
      Log.error(TAG, 'index out of active window');
      return undefined;
    } else {
      return this.getMediaItemSafely(dataIndexInWindow)
    }
  }

  onPhotoBrowserActive(isActive: boolean, transition: string): void {
    Log.debug(TAG, `onPhotoBrowserActive ${isActive}, ${transition}`);
    if (transition == Constants.PHOTO_TRANSITION_TIMELINE) {
      if (isActive) {
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

  onActive(): void {
    super.onActive();
    this.pendingEmitCallbacks.flush();
  }

  getGroupCountBeforeItem(item: MediaItem): number {
    let groupCount = 0;
    if (!item) {
      return groupCount;
    }
    let itemTime: number = item.getDataTaken();
    for (let index = 0; index < this.groups.length; index++) {
      const group: TimelineData = this.groups[index];
      if (DateUtil.isTheSameDay(itemTime, group.startDate)) {
        groupCount = index + 1;
        break;
      }
    }
    return groupCount;
  }
}
