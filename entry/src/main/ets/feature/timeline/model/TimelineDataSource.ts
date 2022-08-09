/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { TimelineData } from '../../../common/model/browser/photo/TimelineData'
import { DateUtil } from '../../../common/utils/DateUtil';
import { MediaDataSource } from '../../../common/model/browser/photo/MediaDataSource'
import { GetTimelineDataCallback } from './GetTimelineDataCallback'
import { ViewType } from '../../../common/model/browser/photo/ViewType'
import { ViewData } from '../../../common/model/browser/photo/ViewData'
import { MediaItem } from '../../../common/model/browser/photo/MediaItem'
import { Logger } from '../utils/Logger'
import { BroadCast } from '../../../common/utils/BroadCast';
import { Constants } from '../../../common/model/common/Constants'
import { PendingTask } from '../../../common/model/browser/photo/PendingTask'
import { PendingCondition } from '../../../common/model/browser/photo/PendingCondition'
import { TraceControllerUtils } from '../../../common/utils/TraceControllerUtils'
import { BrowserDataFactory } from '../../../common/interface/BrowserDataFactory'
import { BrowserDataInterface } from '../../../common/interface/BrowserDataInterface'

const TITLE_DATA_INDEX = -1;

// TimelineDataSource
export class TimelineDataSource extends MediaDataSource {
    logger: Logger = new Logger('TimelineDataSource');
    initDataTraceName = 'TimeLinePageInitData';
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
                return!this.isActive;
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

    updateGroupData(requestTime: number, groups: TimelineData[]): void {
        TraceControllerUtils.startTraceWithTaskId('updateGroupData', requestTime);
        this.logger.info('updateGroupData begin');
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
        this.logger.info('updateGroupSize');
        let previousSize = this.size;
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

        this.logger.info(`updateGroupSize, old size: ${previousSize} , old mediaCount: ${previousMediaCount},\
            new size: ${this.size}, new mediaCount: ${this.mediaCount}`);

        this.isCountChanged = previousMediaCount != this.mediaCount;
        this.isCountReduced = previousMediaCount > this.mediaCount;
        this.updateCountPostProcess();
    }

    deleteDataUpdateSize(indexes: number[]) {
        this.logger.info(`deleteDataUpdateSize ${indexes}`);
        let count = 0;
        let isGroup = true
        for (let index of indexes) {
            let newIndex = index - count;
            if (this.dataIndexes[newIndex] == TITLE_DATA_INDEX) {
                for (let i = newIndex + 1; i < this.dataIndexes.length; i++) {
                    this.layoutIndexes[i] = this.layoutIndexes[i] - 1;
                    this.groupIndexes[i] = this.groupIndexes[i] - 1;
                }
            } else {
                for (let i = newIndex + 1; i < this.dataIndexes.length; i++) {
                    if (this.dataIndexes[i] == TITLE_DATA_INDEX) {
                        isGroup = false;
                    } else {
                        this.dataIndexes[i] = this.dataIndexes[i] - 1;
                        if (isGroup) {
                            this.groupViewIndexes[i] = this.groupViewIndexes[i] - 1;
                        }
                    }

                    this.layoutIndexes[i] = this.layoutIndexes[i] - 1;
                }
                isGroup = true
                this.layoutIndexes.splice(newIndex, 1);
            }

            this.dataIndexes.splice(newIndex, 1);
            this.groupIndexes.splice(newIndex, 1);
            this.groupViewIndexes.splice(newIndex, 1);
            count++;
        }

        this.size = this.size - indexes.length;
    }

    getDataIndexes(indexes: number[]) {
        let newDataIndexes = []
        for (let index of indexes) {
            if (this.dataIndexes[index] != TITLE_DATA_INDEX) {
                newDataIndexes.push(this.dataIndexes[index]);
            }
        }

        return newDataIndexes
    }

    emitCountUpdateCallbacks(): void {
        this.pendingEmitCallbacks.execute(() => {
            super.emitCountUpdateCallbacks();
        })
    }

    updateCountThroughMediaItems(requestTime: number, mediaItems: MediaItem[]): void {
        this.logger.info('updateCountThroughMediaItems');
        this.updateGroupSize(0, this.getGroupDataThroughMediaItems(mediaItems));
    }

    // Get grouping information through media item
    getGroupDataThroughMediaItems(mediaItems: MediaItem[]): TimelineData[] {
        this.logger.info('getGroupDataThroughMediaItems');
        let groupDataList: TimelineData[] = [];
        if (mediaItems == null || mediaItems.length == 0) {
            this.logger.error('getGroupDataThroughMediaItems, mediaItems are empty!');
            return groupDataList;
        }
        let groupCount = 1;
        let startTime = mediaItems[0].dateTaken;
        let endTime = mediaItems[0].dateTaken;
        for (let i = 1; i < mediaItems.length; i++) {
            let dateTaken = mediaItems[i].dateTaken;
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
    getWrappedData(index: number): any {
        if (index < 0 || index >= this.dataIndexes.length) {
            this.logger.error(`getWrappedData, index out of the total size, index: ${index},
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
            this.logger.debug(`index: ${index}, type: ${result.viewType},\
                data: ${result.viewData.startDate}, viewIndex: ${result.viewIndex}`);
            return result;
        } else {
            let dataIndexInWindow = this.dataIndexes[index] - this.activeStart;
            let result: ViewData;
            if (dataIndexInWindow > this.items.length || dataIndexInWindow < 0) {
                this.logger.error('index out of active window');
                return undefined;
            } else {
                result = {
                    viewType: ViewType.ITEM,
                    mediaItem: this.getMediaItemSafely(dataIndexInWindow),
                    viewData: {
                        mediaItem: this.getMediaItemSafely(dataIndexInWindow)
                    },
                    viewIndex: index,
                    indexInGroup: this.groupViewIndexes[index]
                };
            }
            this.logger.debug(`index: ${index}, type: ${result.viewType},\
                data: ${result.viewData.mediaItem.uri} indexInGroup: ${result.indexInGroup}`);
            return result;
        }
    }

    getPositionByIndex(index: number): number {
        let pos = (this.dataIndexes || []).findIndex((item) => item === index);
        this.logger.info(`pos ${index}, ${this.dataIndexes[pos]} , ${this.groupIndexes[pos]}`);
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
            this.logger.error('index out of active window');
            return undefined;
        } else {
            return this.getMediaItemSafely(dataIndexInWindow)
        }
    }

    onPhotoBrowserActive(isActive: boolean, transition: string): void {
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
}
