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
import { Log } from '../utils/Log';
import MediaLib from '@ohos.multimedia.mediaLibrary';
import { ViewType } from '../data/ViewType';
import mediaModel from '../model/MediaModel';
import { MediaConstants } from '../constants/MediaConstants';
import { setOrientation } from '../helper/MediaDataHelper';
import selectManager from '../manager/SelectManager';
import { ItemDataSource } from '../vm/ItemDataSource'
const TAG = "MediaDataItem"

const STATUS_UNDEFINED = -1
const STATUS_FALSE = 0
const STATUS_TRUE = 1

export class MediaDataItem {
    readonly viewType = ViewType.ITEM
    readonly hashIndex: number
    index: number
    dateAdded: number
    dateModified: number
    dateTaken: number
    status: number = MediaConstants.UNDEFINED
    isSelect: boolean = false
    id: number
    uri: string
    orientation: number
    duration: number
    size: number
    width: number; // width changed by orientation
    height: number; // height changed by orientation
    imgWidth: number; // may be smaller than width, as width is too large
    imgHeight: number; // may be smaller than height, as height is too large
    path: string
    title: string
    displayName: string
    mediaType: MediaLib.MediaType
    favouriteStatus: number = STATUS_UNDEFINED
    canRotate: number = STATUS_UNDEFINED
    selections: string = ""
    selectionArgs: Array<string> = new Array()
    deviceId: string = ''

    constructor(selections: string, selectionArgs: Array<string>, deviceId: string, index: number) {
        this.selections = selections
        this.selectionArgs = selectionArgs
        this.deviceId = deviceId
        this.hashIndex = index
        this.index = index
    }

    getHashCode(): string {
        //时间线界面角度，收藏状态变更，都需要刷新界面；大图浏览界面角度变更，需要刷新界面
        return this.status == MediaConstants.UNDEFINED ?
                `${this.hashIndex}` :
                `${this.uri}${this.favouriteStatus} ${this.orientation} ${this.isSelect}`
    }

    async loadFileAsset(): Promise<MediaLib.FileAsset> {
        let fetchOption: MediaLib.MediaFetchOptions
        if (this.status == MediaConstants.UNDEFINED) {
            fetchOption = {
                selections: this.selections,
                selectionArgs: this.selectionArgs,
                order: `date_added DESC LIMIT ${this.index},1`
            };
        } else {
            fetchOption = {
                selections: `${MediaLib.FileKey.ID} = ?`,
                selectionArgs: [this.id.toString()],
                order: `date_added DESC`
            }
        }
        if (this.deviceId.length > 0) {
            fetchOption['networkId'] = this.deviceId
        }
        return (await mediaModel.getAllCommonMediaItem(fetchOption, false)).fileAsset
    }

    isLoad():boolean {
        if (this.status > MediaConstants.UNDEFINED) {
            return true
        }
        return false
    }

    async load(isForce: boolean): Promise<void> {
        Log.info(TAG, `load ${this.status}`)
        if (this.status > (isForce ? MediaConstants.PART_LOADED : MediaConstants.UNDEFINED)) {
            return
        }
        let fileAsset = await this.loadFileAsset()
        if (fileAsset) {
            this.update(fileAsset)
        }
        return
    }

    update(fileAsset: MediaLib.FileAsset) {
        this.id = fileAsset.id;
        this.uri = fileAsset.uri;
        this.orientation = fileAsset.orientation;
        this.mediaType = fileAsset.mediaType;
        this.duration = fileAsset.duration;
        this.size = fileAsset.size;
        if (this.orientation == MediaConstants.ROTATE_ONCE || this.orientation == MediaConstants.ROTATE_THIRD) {
            this.width = fileAsset.height;
            this.height = fileAsset.width;
        } else {
            this.width = fileAsset.width;
            this.height = fileAsset.height;
        }
        this.imgWidth = this.width;
        this.imgHeight = this.height;
        this.path = fileAsset.relativePath;
        this.title = fileAsset.title;
        this.displayName = fileAsset.displayName;
        this.dateAdded = fileAsset.dateAdded * 1000;
        this.dateModified = fileAsset.dateModified * 1000;
        this.dateTaken = fileAsset.dateTaken * 1000;
        this.isSelect = selectManager.isSelect(this.uri, this.isSelect);

        // may change
        fileAsset.isFavorite().then((isFavor: boolean) => this.favouriteStatus = (isFavor) ? STATUS_TRUE : STATUS_FALSE);

        if (this.width > 0 && this.height > 0) {
            this.status = MediaConstants.LOADED;
        } else {
            this.status = MediaConstants.PART_LOADED;
        }
    }

    getThumbnail(width: number, height: number): string {
        Log.debug(TAG, `getThumbnail ${this.status}`);
        if (this.status != MediaConstants.LOADED && this.status != MediaConstants.PART_LOADED) {
            Log.warn(TAG, `getThumbnail fail as status: ${this.status}`);
            return "";
        }
        Log.debug(TAG, `this.uri ${this.uri}`);
        return this.uri + `/thumbnail/${width}/${height}`;
    }

    getAlt(): Resource {
        if (this.mediaType == MediaLib.MediaType.VIDEO) {
            return $r('app.media.alt_video_placeholder');
        } else {
            return $r('app.media.alt_placeholder');
        }
    }

    setSelect(isSelect: boolean) {
        this.isSelect = isSelect;
        selectManager.setSelect(this.uri, this.isSelect);
    }

    async onDelete(): Promise<boolean> {
        try {
            let fileAsset = await this.loadFileAsset();
            await fileAsset.trash(true);
            selectManager.deleteSelect(this.uri);
            this.status = MediaConstants.TRASHED;
            return true;
        } catch (err) {
            Log.error(TAG, `onDelete ${this.index} error: ${JSON.stringify(err)}`);
            return false;
        }
    }

    isDeleted(): boolean {
        return this.status == MediaConstants.TRASHED;
    }

    async isFavor(): Promise<boolean> {
        if (this.favouriteStatus == STATUS_UNDEFINED) {
            let fileAsset = await this.loadFileAsset();
            this.favouriteStatus = (await fileAsset.isFavorite()) ? STATUS_TRUE : STATUS_FALSE;
        }
        return this.favouriteStatus == STATUS_TRUE;
    }

    async setFavor(): Promise<boolean> {
        let status = !(await this.isFavor());
        try {
            let fileAsset = await this.loadFileAsset();
            await fileAsset.favorite(status);
            await fileAsset.commitModify();
            this.favouriteStatus = status ? STATUS_TRUE : STATUS_FALSE;
            return true;
        } catch (err) {
            return false;
        }
    }

    async setOrientation(): Promise<void> {
        let fileAsset = await this.loadFileAsset();
        this.orientation = (this.orientation + MediaConstants.ROTATE_ONCE) % MediaConstants.ROTATE_AROUND;
        await setOrientation(fileAsset, this.orientation);
        let tmp = this.width;
        this.width = this.height;
        this.height = tmp;
    }

    async setName(name: string): Promise<void> {
        let fileAsset = await this.loadFileAsset();
        let displayName = fileAsset.displayName;
        let index = displayName.lastIndexOf('.');
        displayName = name + displayName.slice(index);

        this.displayName = displayName;
        fileAsset.displayName = displayName;

        this.title = name;
        fileAsset.title = name;;
        await fileAsset.commitModify();
    }
}