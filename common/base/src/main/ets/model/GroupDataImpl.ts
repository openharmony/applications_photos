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
import MediaLib from '@ohos.multimedia.mediaLibrary';
import { Log } from '../utils/Log';
import { WindowConstants } from '../constants/WindowConstants';
import mediaModel from '../model/MediaModel';
import screenManager from '../manager/ScreenManager';
import { MediaConstants } from '../constants/MediaConstants';
import { getFetchOptions } from '../helper/MediaDataHelper';
import { MediaDataItem } from '../data/MediaDataItem';
import { FavorMediaDataItem } from '../data/FavorMediaDataItem';
import { TrashMediaDataItem } from '../data/TrashMediaDataItem';
import mediaDataItemCache from '../data/MediaDataItemCache';
import trashMediaDataItemCache from '../data/TrashMediaDataItemCache';


const TAG = "GroupDataImpl"

export class GroupDataImpl {
    private selectType: number = MediaConstants.SELECT_TYPE_ALL;
    private albumId: string = "";
    private deviceId: string = "";

    setSelectType(selectType: number) {
        this.selectType = selectType;
    }

    setAlbumId(id: string) {
        Log.info(TAG, `setAlbumId: ${id}`);
        this.albumId = id;
    }

    setDeviceId(id: string) {
        Log.info(TAG, `setDeviceId: ${id}`);
        this.deviceId = id;
    }

    async reloadGroupItemData(isGrid: boolean): Promise<MediaDataItem[]> {
        if (isGrid) {
            return this.reloadGridGroupItemData();
        } else {
            return this.reloadBrowserGroupItemData();
        }
    }

    async reloadBrowserGroupItemData(): Promise<MediaDataItem[]> {
        Log.debug(TAG, `reloadBrowserGroupItemData`);
        let groupDataItem = [];
        let fetchOption = await getFetchOptions(this.selectType, this.albumId, this.deviceId);
        if (fetchOption == undefined) {
            return [];
        }
        let count: number = 0;
        let groupCount: number = this.getCount();
        let mediaFileAssets = await this.getMediaItemFileAssets(fetchOption, 0, groupCount);
        if (this.albumId == MediaConstants.ALBUM_ID_FAVOR) {
            count = (await mediaModel.getAllFavorMediaItem(fetchOption, true)).counts;
            for (let i = 0;i < count; i++) {
                let favorMediaItem = new FavorMediaDataItem(fetchOption.selections, fetchOption.selectionArgs, i);
                if (i < mediaFileAssets.length) {
                    if (mediaDataItemCache.hasKey(mediaFileAssets[i].uri)) {
                        favorMediaItem.favouriteStatus = mediaDataItemCache.get(mediaFileAssets[i].uri).favouriteStatus;
                        favorMediaItem.orientation = mediaDataItemCache.get(mediaFileAssets[i].uri).orientation;
                    }
                    favorMediaItem.update(mediaFileAssets[i]);
                }
                groupDataItem.push(favorMediaItem);
            }
        } else if (this.albumId == MediaConstants.ALBUM_ID_RECYCLE) {
            count = (await mediaModel.getAllTrashMediaItem(fetchOption, true)).counts;
            for (let i = 0;i < count; i++) {
                let trashMediaItem = new TrashMediaDataItem(fetchOption.selections, fetchOption.selectionArgs, i);
                if (i < mediaFileAssets.length) {
                    if (mediaDataItemCache.hasKey(mediaFileAssets[i].uri)) {
                        trashMediaItem.favouriteStatus = mediaDataItemCache.get(mediaFileAssets[i].uri).favouriteStatus;
                        trashMediaItem.orientation = mediaDataItemCache.get(mediaFileAssets[i].uri).orientation;
                    }
                    trashMediaItem.update(mediaFileAssets[i]);
                }
                groupDataItem.push(trashMediaItem);
            }
        } else {
            count = (await mediaModel.getAllCommonMediaItem(fetchOption, true)).counts;
            for (let i = 0;i < count; i++) {
                let mediaItem: MediaDataItem = new MediaDataItem(fetchOption.selections, fetchOption.selectionArgs, this.deviceId, i);
                if (i < mediaFileAssets.length) {
                    if (mediaDataItemCache.hasKey(mediaFileAssets[i].uri)) {
                        mediaItem = mediaDataItemCache.get(mediaFileAssets[i].uri);
                    } else {
		        mediaDataItemCache.set(mediaFileAssets[i].uri, mediaItem);
                    }
                    mediaItem.update(mediaFileAssets[i]);
                }
                groupDataItem.push(mediaItem);
            }
        }

        Log.debug(TAG, `reload finish count:${count}`);
        return groupDataItem;
    }

    async reloadGridGroupItemData(): Promise<MediaDataItem[]> {
        Log.debug(TAG, `reloadGridGroupItemData`);
        let groupDataItem = [];
        let fetchOption = await getFetchOptions(this.selectType, this.albumId, this.deviceId);
        if (fetchOption == undefined) {
            return [];
        }
        let groupCount: number = this.getCount();
        let mediaFileAssets = await this.getMediaItemFileAssets(fetchOption, 0, groupCount);
        if (this.albumId == MediaConstants.ALBUM_ID_FAVOR) {
            let count: number = (await mediaModel.getAllFavorMediaItem(fetchOption, true)).counts;
            for (let i = 0;i < count; i++) {
                let item = new FavorMediaDataItem(fetchOption.selections, fetchOption.selectionArgs, i);
                if (i < mediaFileAssets.length) {
                    if (mediaDataItemCache.hasKey(mediaFileAssets[i].uri)) {
                        item = mediaDataItemCache.get(mediaFileAssets[i].uri);
                    }
                    else {
                        mediaDataItemCache.set(mediaFileAssets[i].uri, item);
                    }
                    item.update(mediaFileAssets[i]);
                }
                groupDataItem.push(item);
            }
        } else if (this.albumId == MediaConstants.ALBUM_ID_RECYCLE) {
            let count: number = (await mediaModel.getAllTrashMediaItem(fetchOption, true)).counts;
            for (let i = 0;i < count; i++) {
                let item = new TrashMediaDataItem(fetchOption.selections, fetchOption.selectionArgs, i);
                if (i < mediaFileAssets.length) {
                    if (trashMediaDataItemCache.hasKey(mediaFileAssets[i].uri)) {
                        item = trashMediaDataItemCache.get(mediaFileAssets[i].uri);
                    }
                    else
                    {
                        trashMediaDataItemCache.set(mediaFileAssets[i].uri, item);
                    }
                    item.update(mediaFileAssets[i]);
                }
                groupDataItem.push(item);
            }
        } else {
            let count: number = (await mediaModel.getAllCommonMediaItem(fetchOption, true)).counts;
            for (let i = 0;i < count; i++) {
                let item = new MediaDataItem(fetchOption.selections, fetchOption.selectionArgs, this.deviceId, i);
                if (i < mediaFileAssets.length) {
                    if (mediaDataItemCache.hasKey(mediaFileAssets[i].uri)) {
                        item = mediaDataItemCache.get(mediaFileAssets[i].uri);
                    } else {
                        mediaDataItemCache.set(mediaFileAssets[i].uri, item);
                    }
                    item.update(mediaFileAssets[i]);
                }
                groupDataItem.push(item);
            }
        }
        // do not use await to avoid load cost too much time
        this.loadReset(fetchOption, groupDataItem, groupCount);

        Log.debug(TAG, `reload finish`);
        return groupDataItem;
    }

    private async getMediaItemFileAssets(baseFetchOption: MediaLib.MediaFetchOptions, start: number, count: number): Promise<MediaLib.FileAsset[]> {
        let fetchOption: MediaLib.MediaFetchOptions = {
            selections: baseFetchOption.selections,
            selectionArgs: baseFetchOption.selectionArgs,
            order: `date_added DESC LIMIT ${start},${count}`
        }
        if (this.deviceId.length > 0) {
            fetchOption['networkId'] = this.deviceId;
        }
        if (this.albumId == MediaConstants.ALBUM_ID_FAVOR) {
            return await mediaModel.getAllFavorMediaItems(fetchOption);
        } else if (this.albumId == MediaConstants.ALBUM_ID_RECYCLE) {
            return await mediaModel.getAllTrashMediaItems(fetchOption);
        } else {
            return await mediaModel.getAllMediaItems(fetchOption);
        }
    }

    private getCount(): number {
        let contentWidth = screenManager.getWinWidth();
        let maxThumbWidth = px2vp(WindowConstants.GRID_IMAGE_SIZE) * WindowConstants.GRID_MAX_SIZE_RATIO;
        let columns = Math.max(WindowConstants.GRID_MIN_COUNT, Math.ceil((contentWidth + WindowConstants.GRID_GUTTER) / (maxThumbWidth + WindowConstants.GRID_GUTTER)));
        let contentHeight = screenManager.getWinHeight() - WindowConstants.ACTION_BAR_HEIGHT - screenManager.getNaviBarHeight();
        let rows = Math.ceil((contentHeight + WindowConstants.GRID_GUTTER) / (maxThumbWidth + WindowConstants.GRID_GUTTER)) + 4;
        return columns * rows;
    }

    private async loadReset(fetchOption: MediaLib.MediaFetchOptions, items: MediaDataItem[], count) {
        let itemLen = items.length;
        let countLen = Math.ceil(itemLen / count);
        for (let i = 1;i < countLen; i++) {
            let mediaFileAsset: Array<MediaLib.FileAsset> = await this.getMediaItemFileAssets(fetchOption, i * count, count);
            for (let j = 0;j < count; j++) {
                if (i * count + j >= itemLen) {
                    return;
                }
                items[i * count+j].update(mediaFileAsset[j]);
            }
        }
    }
}