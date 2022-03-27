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

import {TimelineData} from './photo/TimelineData.ets'
import {Logger} from '../../utils/Logger.ets'
import {MediaItem} from './photo/MediaItem.ets'
import {AsyncCallback} from '../common/AsyncCallback'
import {AlbumDefine} from './AlbumDefine'
import {BrowserDataFactory} from './interface/BrowserDataFactory.ets'
import {BrowserDataInterface} from './interface/BrowserDataInterface'

export class BucketSelectionEntry {
    private groupId = -1;
    private clickedSet: Set<string> = new Set();
    private totalCount = 0;
    private inverseSelection = false;
    private groupSelect = false;

    public setGroupId(groupId: number) {
        this.groupId = groupId;
    }

    public getGroupId() {
        return this.groupId;
    }

    public setTotalCount(TotalCount) {
        this.totalCount = TotalCount;
    }

    public getTotalCount() {
        return this.totalCount;
    }

    public setGroupSelect(SelectMode) {
        this.groupSelect = SelectMode;
    }

    public getGroupSelect() {
        return this.groupSelect;
    }

    public getClickSet() {
        return this.clickedSet;
    }

    public getSelectedCount() {
        if (this.inverseSelection) {
            return this.totalCount - this.clickedSet.size;
        }
        return this.clickedSet.size;
    }

    public selectAll() {
        this.inverseSelection = true;
        this.groupSelect = true;
        this.clickedSet.clear();
    }

    public deSelectAll() {
        this.inverseSelection = false;
        this.groupSelect = false;
        this.clickedSet.clear();
    }

    public isItemSelected(targetId) {
        return (this.inverseSelection != this.clickedSet.has(targetId));
    }

    public inSelectAllMode() {
        return this.inverseSelection && (this.clickedSet.size == 0);
    }

    /**
     * Change the select all status of the entry, depending on the total deselection status of the timeline
     *
     * @param isInverseMode The total inverse selection status of the timeline. If it is true,
     * it is global inverse selection and requires reverse operation
     */
    public changeSelectMode(isInverseMode: boolean) {
        isInverseMode
            ? (this.getSelectedCount() == 0 ? this.selectAll() : this.deSelectAll())
            : (this.inSelectAllMode() ? this.deSelectAll() : this.selectAll())
    }

    public getInverseSelection() {
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
    logger: Logger = new Logger('SelectManager');
    mIsSelectedMode = false;
    clickedSet: Set<string> = new Set();
    totalCount = 0;
    inverseSelection = false;
    inSingleMode = false;
    isAllSelected = false;
    mCallbacks = {};
    photoDataImpl: BrowserDataInterface;
    selectManagerCallback;
    albumName = undefined;
    deviceId = undefined;

    constructor() {
        this.selectManagerCallback = new SelectManagerCallback(this);
    }

    public setTotalCount(count: number) {
        this.totalCount = count;
        this.mCallbacks['updateCount'] && this.mCallbacks['updateCount'](this.getSelectedCount());
    }

    public setPhotoDataImpl() {
        this.photoDataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_ALBUM);
    }

    public setAlbumName(albumName) {
         this.albumName = albumName;
    }

    public setDeviceId(deviceId) {
        this.deviceId = deviceId;
    }

    public registerCallback(name: string, cb: Function) {
        this.mCallbacks[name] = cb;
    }

    public unregisterCallback(name: string) {
        this.mCallbacks[name] = undefined;
    }

    public emitCallback(name: string, argument: any[]) {
        this.mCallbacks[name] && this.mCallbacks[name].apply(this, argument);
    }

    public toggle(targetId: string, isSelected: boolean, targetIndex?: number): boolean {
        this.logger.info(`toggle ${targetId} ${isSelected} ${targetIndex}`);
        if (targetId == undefined) {
            return true;
        }
        if (isSelected == (!this.inverseSelection)) {
            this.clickedSet.add(targetId);
            this.logger.info(`add targetID ${targetId}`);
        } else {
            this.clickedSet.delete(targetId);
        }
        if (this.isAllSelected) {
            this.isAllSelected = false;
            this.mCallbacks['allSelect'] && this.mCallbacks['allSelect'](false);
        }
        if (this.totalCount == this.getSelectedCount()) {
            this.isAllSelected = true;
            this.mCallbacks['allSelect'] && this.mCallbacks['allSelect'](true);
        }
        this.mCallbacks['updateCount'] && this.mCallbacks['updateCount'](this.getSelectedCount());
        return true;
    }

    public selectAll(reverseSelection: boolean) {
        if (reverseSelection) {
            this.inverseSelection = true;
            this.clickedSet.clear();
            this.isAllSelected = true;
        } else {
            this.isAllSelected = true;
        }
        this.mCallbacks['allSelect'] && this.mCallbacks['allSelect'](true);
        this.mCallbacks['updateCount'] && this.mCallbacks['updateCount'](this.getSelectedCount());
    }

    public deSelectAll() {
        this.inverseSelection = false;
        this.isAllSelected = false;
        this.clickedSet.clear();
        this.mCallbacks['allSelect'] && this.mCallbacks['allSelect'](false);
        this.mCallbacks['updateCount'] && this.mCallbacks['updateCount'](this.getSelectedCount());
    }

    public isItemSelected(targetId: string, index?: number) {
        this.logger.info(`isItemSelected ${targetId}, ${index}`);
        return (this.inverseSelection != this.clickedSet.has(targetId));
    }

    public getSelectedCount() {
        return (this.inverseSelection) ? this.totalCount - this.clickedSet.size : this.clickedSet.size;
    }

    public onModeChange(newMode: boolean) {
        if (newMode) {
            this.mIsSelectedMode = true;
        } else {
            this.mIsSelectedMode = false;
            this.inverseSelection = false;
            this.isAllSelected = false;
            this.clickedSet.clear();
            this.mCallbacks[`allSelect`] && this.mCallbacks[`allSelect`](false);
        }
    }

    public getSelection(callback: AsyncCallback<string[]>) {
        if (this.inverseSelection) {
            this.selectManagerCallback.setSubCallback(callback);
            this.photoDataImpl.getData(this.selectManagerCallback, {
                name: this.albumName,
                deviceId: this.deviceId
            });
        } else {
            let result = [];
            result = Array.from(this.clickedSet);
            callback.callback(result);
        }
    }

    public getDeleteSelection(callback: AsyncCallback<string[]>) {
        if (this.inverseSelection) {
            this.selectManagerCallback.setSubCallback(callback);
            this.photoDataImpl.getData(this.selectManagerCallback, {
                name: AlbumDefine.ALBUM_NAME_RECYCLE
            });
        } else {
            let result = [];
            result = Array.from(this.clickedSet);
            callback.callback(result);
        }
    }

    public async getSelectedItems(callback: Function): Promise<void> {
        let result = new Array<MediaItem>();
        this.logger.info('getSelectedItems');
        await this.getItems(this.photoDataImpl, 0, this.totalCount, (temp: MediaItem[]) => {
            temp.forEach((item) => {
                if (this.inverseSelection) {
                    this.logger.info('getSelectedItems inverseSelection');
                    if (item && !this.clickedSet.has(item.uri)) {
                        result.push(item);
                    }
                } else {
                    if (this.clickedSet.has(item.uri)) {
                        result.push(item);
                    }
                }
            })
            this.logger.info(`enter callback result ${result.length}`);
            callback(result);
        })
    }

    public handleSelection(mediaItems: MediaItem[], callback: AsyncCallback<string[]>) {
        let result = [];
        mediaItems.forEach((mediaItem) => {
            if (mediaItem && !this.clickedSet.has(mediaItem.uri)) {
                result.push(mediaItem.uri);
            }
        })
        callback.callback(result);
    }

    public async getItems(photoDataImpl: BrowserDataInterface,
                          start: number, count: number, callback: Function): Promise<void> {
        this.logger.info(`getItems start: ${start} count: ${count}`);
        let cb: AsyncCallback<MediaItem[]> = {
            callback(t: MediaItem[]) {
                callback(t);
            }
        }


        if (this.albumName) {
            await photoDataImpl.getData(cb,
                {name: this.albumName, start: start, count: count, deviceId: this.deviceId});
        } else {
            await photoDataImpl.getData(cb,
                {name: AlbumDefine.ALBUM_NAME_ALL, start: start, count: count, deviceId: this.deviceId});
        }
    }
}

class SelectManagerCallback implements AsyncCallback<MediaItem[]> {
    source: SelectManager;
    subCallback: AsyncCallback<string[]>;

    constructor(source: SelectManager) {
        this.source = source;
    }

    public setSubCallback(cb) {
        this.subCallback = cb;
    }

    public callback(mediaSetList: MediaItem[]) {
        this.source.handleSelection(mediaSetList, this.subCallback);
    }
}

export class ThirdSelectManager extends SelectManager {
    logger: Logger = new Logger('ThirdSelectManager');
    type: string;
    isMultiPick: boolean;

    constructor() {
        super();
    }

    public setType(type: string) {
        this.type = type;
    }

    public getType(): string {
        return this.type;
    }

    public setIsMultiPick(isMultiPick: boolean) {
        this.isMultiPick = isMultiPick;
    }

    public getIsMultiPick(): boolean {
        return this.isMultiPick;
    }

    public getSelectedSet(): Set<string> {
        return super.clickedSet;
    }
}

export class TimelineSelectManager extends SelectManager {
    logger: Logger = new Logger('TimelineSelectManager');
    mGroupData: TimelineData[] = [];
    mSelectionEntryArray: BucketSelectionEntry[] = [];

    constructor() {
        super();
    }

    public selectAll(reverseSelection: boolean) {
        this.logger.info(`selectAll ${reverseSelection}`);
        if (reverseSelection) {
            this.inverseSelection = true;
            this.clearEntryArray();
            this.isAllSelected = true;
        } else {
            this.isAllSelected = true;
        }
        this.mCallbacks['updateGroupCount'] && this.mCallbacks['updateGroupCount']();
        this.mCallbacks['allSelect'] && this.mCallbacks['allSelect'](true);
        this.mCallbacks['updateCount'] && this.mCallbacks['updateCount'](this.getSelectedCount());
    }

    public deSelectAll() {
        this.inverseSelection = false;
        this.isAllSelected = false;
        this.clearEntryArray();
        this.mCallbacks['updateGroupCount'] && this.mCallbacks['updateGroupCount']();
        this.mCallbacks['allSelect'] && this.mCallbacks['allSelect'](false);
        this.mCallbacks['updateCount'] && this.mCallbacks['updateCount'](this.getSelectedCount());
    }

    private toggleClickSet(entry: BucketSelectionEntry, targetId: string, isSelected: boolean) {
        this.logger.info(`toggleClickSet: ${targetId} + ${isSelected}`);
        if (isSelected == (!this.inverseSelection)) {
            this.toggleEntryItem(entry, targetId, true);
        } else {
            this.toggleEntryItem(entry, targetId, false);
        }
    }

    private toggleEntryItem(entry: BucketSelectionEntry, targetId: string, isSelected: boolean) {
        this.logger.info(`toggleEntryItem ${targetId} ${isSelected}`);
        let clickSet = entry.getClickSet();
        if (isSelected != entry.getInverseSelection()) {
            clickSet.add(targetId);
        } else {
            clickSet.delete(targetId);
        }
    }

    public toggle(targetId: string, isSelected: boolean, targetIndex: number): boolean {
        this.logger.info(`toggleTimeline ${targetIndex} id: ${targetId} ${isSelected}`);
        let itemCoordinate = this.getCoordinateFromPosition(targetIndex);
        let entry = this.getGroupEntry(itemCoordinate);
        this.toggleClickSet(entry, targetId, isSelected);
        let entrySelectedCount = entry.getSelectedCount();
        this.logger.info(`check all selected ${entrySelectedCount} ${entry.getTotalCount()}`);

        if (entrySelectedCount == entry.getTotalCount()) {
            this.logger.info('group selectAll');
            entry.selectAll();
        }

        this.mCallbacks['updateGroupCount'] && this.mCallbacks['updateGroupCount']();

        if (this.isAllSelected && (entrySelectedCount < entry.getTotalCount())) {
            this.isAllSelected = false;
            this.mCallbacks['updateCount'] && this.mCallbacks['updateCount'](this.getSelectedCount());
        }

        if (this.getSelectedCount() == this.totalCount) {
            this.isAllSelected = true;
            this.mCallbacks['allSelect'] && this.mCallbacks['allSelect'](true);
            this.mCallbacks['updateCount'] && this.mCallbacks['updateCount'](this.getSelectedCount());
        } else {
            this.isAllSelected = false;
            this.mCallbacks['allSelect'] && this.mCallbacks['allSelect'](false);
            this.mCallbacks['updateCount'] && this.mCallbacks['updateCount'](this.getSelectedCount());
        }
        return true;
    }

    public toggleGroup(itemCoordinate: ItemCoordinate): boolean {
        this.logger.info(`check  toggleGroup: ${itemCoordinate.getGroupId()}`);
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
        this.mCallbacks['updateGroupCount'] && this.mCallbacks['updateGroupCount']();
        this.mCallbacks['updateCount'] && this.mCallbacks['updateCount'](this.getSelectedCount());
        if (this.getSelectedCount() == this.totalCount) {
            this.isAllSelected = true;
            this.mCallbacks['allSelect'] && this.mCallbacks['allSelect'](true);
        } else {
            this.isAllSelected = false;
            this.mCallbacks['allSelect'] && this.mCallbacks['allSelect'](false);
        }
        return true;
    }

    private getCoordinateFromPosition(position: number) {
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

    public getTitleCoordinate(position: number) {
        return new ItemCoordinate().setGroupId(position).setIndex(-1);
    }

    private getGroupEntry(itemCoordinate: ItemCoordinate): BucketSelectionEntry {
        let entry = this.mSelectionEntryArray[itemCoordinate.groupId];
        if (entry == undefined) {
            entry = new BucketSelectionEntry();
            entry.setGroupId(itemCoordinate.groupId);
            if (itemCoordinate.groupId >= 0 && itemCoordinate.groupId < this.mGroupData.length) {
                this.logger.info(`entry.setTotalCount ${this.mGroupData[itemCoordinate.groupId].count}`);
                entry.setTotalCount(this.mGroupData[itemCoordinate.groupId].count);
            }
            this.logger.info(`getGroupEntry mSelectionEntryArray ${itemCoordinate.groupId} entry: ${entry}`);
            this.mSelectionEntryArray[itemCoordinate.groupId] = entry;
        }
        return entry;
    }

    public getSelectedCount() {
        let count = 0;
        this.mSelectionEntryArray.forEach((item) => {
            count += item ? item.getSelectedCount() : 0;
        })
        if (this.inverseSelection) {
            this.logger.info(`inverseSelection totalCount: ${this.totalCount - count}`);
            return this.totalCount - count;
        }
        return count;
    }

    public onModeChange(newMode: boolean) {
        if (newMode) {
            this.mIsSelectedMode = true;
        } else {
            this.mIsSelectedMode = false;
            this.inverseSelection = false;
            this.isAllSelected = false;
            this.clearEntryArray();
        }
    }

    private clearEntryArray() {
        this.logger.info('clearEntryArray');
        this.mSelectionEntryArray.length = 0;
    }

    public isItemSelected(targetId: string, index: number) {
        let itemCoordinate = this.getCoordinateFromPosition(index);
        let entry = this.mSelectionEntryArray[itemCoordinate.getGroupId()];
        if (this.inverseSelection) {
            return (entry == undefined) || (!entry.isItemSelected(targetId));
        } else {
            return (entry != undefined) && (entry.isItemSelected(targetId));
        }
    }

    public IsGroupSelected(index: number) {
        let entry = this.mSelectionEntryArray[index];
        if (this.inverseSelection) {
            return entry == null || entry.getSelectedCount() == 0;
        } else {
            return (entry != null) && (entry.inSelectAllMode());
        }
    }

    public setGroupData(groupData: TimelineData[]) {
        if (groupData == undefined) {
            return;
        }
        this.mGroupData = groupData;
    }

    public updateGroupData(groupData: TimelineData[]) {
        if (groupData == undefined) {
            return;
        }
        this.mGroupData = groupData;
        this.mSelectionEntryArray.forEach((entry: BucketSelectionEntry) => {
            if (entry != undefined && (entry.getGroupId() < this.mGroupData.length)) {
                entry.setTotalCount(this.mGroupData[entry.getGroupId()].count);
            }
        })
        this.mCallbacks['updateCount'] && this.mCallbacks['updateCount'](this.getSelectedCount());
    }

    public async getSelection(callback: AsyncCallback<string[]>) {
        let result = new Array<string>();
        let start = 0;
        let doneCount = 0;
        if (this.inverseSelection) {
            for (let i = 0; i < this.mGroupData.length; i++) {
                if (this.mSelectionEntryArray[i]) {
                    await this.getInverseSelectedFromEntry(this.mSelectionEntryArray[i],
                        start, this.mGroupData[i].count, (temp: string[]) => {
                            result = result.concat(temp);
                            this.logger.info(`getInverseSelectedFromEntry result ${result.length}`);
                            doneCount++;
                            this.checkIsGetSelectionFinish(doneCount, result, callback);
                        });
                } else {
                    await this.getItems(this.photoDataImpl, start, this.mGroupData[i].count, (temp: MediaItem[]) => {
                        temp.forEach((item) =>{
                            result.push(item.uri);
                        });
                        this.logger.info(`getInverseGroupItems result ${result.length}`);
                        doneCount++;
                        this.checkIsGetSelectionFinish(doneCount, result, callback);
                    });
                }
                start += this.mGroupData[i].count;
            }
        } else {
            for (let i = 0; i < this.mGroupData.length; i++) {
                if (this.mSelectionEntryArray[i]) {
                    await this.getSelectedFromEntry(this.mSelectionEntryArray[i],
                        start, this.mGroupData[i].count, (temp: string[]) => {
                            this.logger.info(`getSelectedFromEntry result ${result.length}`);
                            result = result.concat(temp);
                            doneCount++;
                            this.checkIsGetSelectionFinish(doneCount, result, callback);
                        });
                }
                else {
                    doneCount++;
                    this.checkIsGetSelectionFinish(doneCount, result, callback);
                }
                start += this.mGroupData[i].count;
            }
        }
    }

    public async getSelectedItems(callback: Function): Promise<void> {
        this.logger.info('getSelectedItems');
        let result = new Array<MediaItem>();
        let start = 0;
        let doneCount = 0;
        if (this.inverseSelection) {
            this.logger.info('getSelectedItems: mode is inverseSelection');
            for (let i = 0; i < this.mGroupData.length; i++) {
                let entry = this.mSelectionEntryArray[i];
                if(entry) {
                    if (entry.getInverseSelection()) {
                        await this.getItems(this.photoDataImpl, start, this.mGroupData[i].count, (temp: MediaItem[]) => {
                            temp.forEach((item) => {
                                if (entry.getClickSet().has(item.uri)) {
                                    this.logger.debug('push one item');
                                    result.push(item);
                                }
                            });
                            doneCount++;
                            this.checkIsGetSelectionItemFinish(doneCount, result, callback);
                        });
                    } else {
                        await this.getItems(this.photoDataImpl, start, this.mGroupData[i].count, (temp: MediaItem[]) => {
                            temp.forEach((item) => {
                                if (!entry.getClickSet().has(item.uri)) {
                                    this.logger.debug('push one inverse item');
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
            this.logger.info('getSelectedItems: mode is not inverseSelection');
            for (let i = 0; i < this.mGroupData.length; i++) {
                let entry = this.mSelectionEntryArray[i];
                if (entry) {
                    await this.getItems(this.photoDataImpl, start, this.mGroupData[i].count, (temp: MediaItem[]) =>{
                        temp.forEach((item) => {
                            if (!entry.getInverseSelection()) {
                                if (entry.getClickSet().has(item.uri)) {
                                    this.logger.debug('push one item');
                                    result.push(item);
                                }
                            } else if (!entry.getClickSet().has(item.uri)) {
                                this.logger.debug('push one inverse item');
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


    private checkIsGetSelectionFinish(doneCount: number, result: string[], callback: AsyncCallback<string[]>): void {
        if (this.mGroupData.length == doneCount) {
            this.logger.info(`getSelection result ${result.length}`);
            callback.callback(result);
        }
    }

    private checkIsGetSelectionItemFinish(doneCount: number, result: MediaItem[], callback: Function): void {
        if (this.mGroupData.length == doneCount) {
            this.logger.info(`getSelection result ${result.length}`);
            callback(result);
        }
    }

    private async getSelectedFromEntry(entry: BucketSelectionEntry,
                                       start: number, count: number, callback: Function): Promise<void> {
        this.logger.info(`getSelectedFromEntry start: ${start}, count: ${count}`);
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
            this.logger.info('getSelectedFromEntry not inverse');
            result = Array.from(entry.getClickSet());
            callback(result);
        }
    }

    private async getInverseSelectedFromEntry(entry: BucketSelectionEntry,
                                              start: number, count: number, callback: Function): Promise<void> {
        this.logger.info(`getInverseSelectedFromEntry start: ${start}, count: ${count}`);
        let result = new Array<string>();
        if (entry.getInverseSelection()) {
            result = Array.from(entry.getClickSet());
            callback(result);
        } else {
            this.logger.info('getInverseSelectedFromEntry not inverse');
            await this.getItems(this.photoDataImpl, start, count, (temp: MediaItem[]) => {
                this.logger.info(`enter callback temp: ${entry.getClickSet().size}`);
                temp.forEach((item) => {
                    if (!entry.getClickSet().has(item.uri)) {
                        result.push(item.uri);
                    }
                });
                this.logger.info(`enter callback result ${result.length}`);
                callback(result);
            });
        }
    }
}

export class AlbumSetSelectManager extends SelectManager {
    logger: Logger = new Logger('AlbumSetSelectManager');
    isDisableRenameClickedSet: Set<string> = new Set();
    isDisableDeleteClickedSet: Set<string> = new Set();

    constructor() {
        super();
    }

    public toolBarStateToggle(targetId: string, isSelected: boolean,
                              isDisableRename: boolean, isDisableDelete: boolean) {
        this.logger.info(`toolBarStateToggle${targetId}/${isSelected}/${isDisableRename}/${isDisableDelete}`);
        if (isSelected == (!this.inverseSelection)) {
            if (isDisableRename) {
                this.logger.info(`add isDisableRename targetID ${targetId}`);
                this.isDisableRenameClickedSet.add(targetId);
            }
            if (isDisableDelete) {
                this.logger.info(`add isDisableDelete targetID ${targetId}`);
                this.isDisableDeleteClickedSet.add(targetId);
            }
        } else {
            if (isDisableRename) {
                this.logger.info(`delete isDisableRename targetID ${targetId}`);
                this.isDisableRenameClickedSet.delete(targetId);
            }
            if (isDisableDelete) {
                this.logger.info(`delete isDisableDelete targetID ${targetId}`);
                this.isDisableDeleteClickedSet.delete(targetId);
            }
        }

        let isDisableRenameFlag = !(this.isDisableRenameClickedSet.size == 0);
        let isDisableDeleteFlag = !(this.isDisableDeleteClickedSet.size == 0);
        this.mCallbacks['updateToolBarState']
            && this.mCallbacks['updateToolBarState'](isDisableRenameFlag, isDisableDeleteFlag);
    }

    public onModeChange(newMode: boolean) {
        super.onModeChange(newMode);
        if (!newMode) {
            this.isDisableRenameClickedSet.clear();
            this.isDisableDeleteClickedSet.clear();
        }
    }
}