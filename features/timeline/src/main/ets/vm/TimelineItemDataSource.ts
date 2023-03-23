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
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { LazyItem, ItemDataSource } from '@ohos/base/src/main/ets/vm/ItemDataSource';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import { TimelineDataImpl } from '../model/TimelineDataImpl';
import { TimelineDataItem } from '../data/TimelineDataItem';

const TAG = "TimelineItemDataSource"

export class TimelineItemDataSource extends ItemDataSource {
    groupItem: TimelineDataItem[] = [];
    private timelineDataImpl: TimelineDataImpl = new TimelineDataImpl();

    constructor() {
        super()
    }

    totalCount(): number {
        let count = 0
        this.groupItem.forEach((item: TimelineDataItem) => {
            count += 1 + item.groupChild.length;
        })
        return count;
    }

    childCount(): number {
        let count = 0;
        this.groupItem.forEach((item: TimelineDataItem) => {
            count += item.groupChild.length;
        })
        return count;
    }

    getIndexByChildIndex(childIndex: number): number {
        let index = 0;
        for (let i = 0;i < this.groupItem.length; i++) {
            let childCount = this.groupItem[i].groupChild.length
            if (childIndex >= childCount) {
                index += (1 + childCount);
                childIndex -= childCount;
            } else {
                index += (1 + childIndex);
                break;
            }
        }
        return index;
    }

    getIndexByItem(item: MediaDataItem): number {
        let index = 0;
        let length = this.groupItem.length;
        for (let i = 0;i < length; i++) {
            let childLength = this.groupItem[i].groupChild.length;
            let endDate = this.groupItem[i].groupChild[childLength-1].dateAdded // the min of the group
            if (item.dateAdded < endDate) {
                index += (1 + childLength);
                continue;
            }
            let childIndex: number = this.groupItem[i].groupChild.indexOf(item);
            if (childIndex < 0) {
                index = -1;
            } else {
                index += (1 + childIndex);
            }
            break;
        }
        return index
    }

    getDataByIndex(index: number): TimelineDataItem | MediaDataItem {
        let item: TimelineDataItem | MediaDataItem = undefined;
        let count = 0;
        for (let i = 0;i < this.groupItem.length; i++) {
            let groupItem: TimelineDataItem = this.groupItem[i]
            let childLength = groupItem.groupChild.length;
            if (index == 0) {
                item = groupItem;
                break;
            } else if (index <= childLength) {
                item = groupItem.groupChild[index-1];
                item.index = count + index - 1;
                break;
            } else {
                index -= (1 + childLength);
                count += childLength;
            }
        }
        return item;
    }

    getData(index: number): LazyItem<TimelineDataItem> | LazyItem<MediaDataItem> {
        let item: LazyItem<TimelineDataItem> | LazyItem<MediaDataItem> = undefined;
        let count = 0;
        let lazyIndex = index;
        for (let i = 0;i < this.groupItem.length; i++) {
            let groupItem: TimelineDataItem = this.groupItem[i]
            let childLength = groupItem.groupChild.length;
            if (index == 0) {
                item = new LazyItem<TimelineDataItem>(groupItem, lazyIndex, this.onTimelineDataUpdate.bind(this));
                break;
            } else if (index <= childLength) {
                item = new LazyItem<MediaDataItem>(groupItem.groupChild[index-1], lazyIndex, this.onMediaDataUpdate.bind(this));
                groupItem.groupChild[index-1].index = count + index - 1;
                break;
            } else {
                index -= (1 + childLength);
                count += childLength;
            }
        }
        return item;
    }

    async reloadTimelineItemData(): Promise<boolean> {
        Log.info(TAG, "reloadTimelineItemData");
        this.groupItem = await this.timelineDataImpl.getTimelineItemData();
        Log.debug(TAG, "reloadTimelineItemData finish");
        return this.groupItem.length == 0;
    }

    isSelect(): boolean {
        let status = true;
        for (let i = 0; i < this.groupItem.length; i++) {
            if (!this.groupItem[i].isSelect()) {
                status = false;
                break;
            }
        }
        return status;
    }

    setSelect(isSelect: boolean) {
        this.groupItem.forEach((child: TimelineDataItem) => {
            child.setSelect(isSelect);
        })
        Log.info(TAG, "setSelect");
        this.notifyDataReload();
    }

    getSelectedCount(): number {
        let count = 0;
        this.groupItem.forEach((child: TimelineDataItem) => {
            count += child.getSelectedCount();
        })
        return count;
    }

    getItems(): MediaDataItem[] {
        let items: MediaDataItem[] = [];
        this.groupItem.forEach((group: TimelineDataItem) => {
            group.groupChild.forEach((child: MediaDataItem) => {
                items.push(child);
            })
        })
        return items;
    }

    getSelectedItems(): MediaDataItem[] {
        let items: MediaDataItem[] = [];
        this.groupItem.forEach((group: TimelineDataItem) => {
            group.groupChild.forEach((child: MediaDataItem) => {
                if (child.isSelect) {
                    items.push(child);
                }
            })
        })
        return items;
    }

    getSelectedUris(): string[] {
        let uris: string[] = [];
        this.groupItem.forEach((group: TimelineDataItem) => {
            group.groupChild.forEach((child: MediaDataItem) => {
                if (child.isSelect) {
                    uris.push(child.uri);
                }
            })
        })
        return uris;
    }

    onTimelineDataUpdate(index: number, item: TimelineDataItem): void {
        this.notifyDataChange(index);
        Log.info(TAG, `onTimelineDataUpdate ${index}`);
        for (let i = 0; i < item.groupChild.length; i++) {
            this.notifyDataChange(index + 1 + i);
        }
    }

    getIndexByMediaIndex(index:number) : number{
        let TimeLineTitleIndex = 0;
        for (let i = 0;i < this.groupItem.length; i++) {
            let groupItem: TimelineDataItem = this.groupItem[i]
            let childLength = groupItem.groupChild.length;
            if (index == 0) {
                break;
            } else if (index <= childLength) {
                break;
            } else {
                index -= (1 + childLength);
                TimeLineTitleIndex += childLength + 1;
            }
        }
        return TimeLineTitleIndex;
    }

    onMediaDataUpdate(index: number, item: MediaDataItem): void {
        Log.info(TAG, `onMediaDataUpdate ${index}`);
        this.notifyDataChange(index);
        this.notifyDataChange(this.getIndexByMediaIndex(index));
    }

    dataReload(): void {
        this.reloadTimelineItemData().then((isEmpty: boolean) => {
            this.notifyDataReload();
        })
    }

    dataRemove(): void {
        let count: number = this.totalCount();
        for (let i = this.groupItem.length - 1;i >= 0; i--) {
            count -= (this.groupItem[i].groupChild.length + 1);
            let removeList: number[] = this.groupItem[i].dataRemove();
            removeList.forEach((index: number) => {
                super.notifyDataDelete(count + 1 + index);
            })
            if (this.groupItem[i].groupChild.length == 0) {
                this.groupItem.splice(i, 1);
                super.notifyDataDelete(count);
            }
        }
    }
}