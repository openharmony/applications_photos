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
import MediaLib from '@ohos.multimedia.mediaLibrary';
import { Log } from '../utils/Log';
import { AlbumDataItem } from '../data/AlbumDataItem';
import { MediaConstants } from '../constants/MediaConstants';
import mediaModel from '../model/MediaModel';
import { getAlbumDisplayName, getFetchOptions } from '../helper/MediaDataHelper';
import { QueryConstants } from '../constants/QueryConstants';

const TAG = "AlbumDataImpl"

export class AlbumDataImpl {
    private blackList: string[] = [];
    private selectType: number = MediaConstants.SELECT_TYPE_ALL;
    private deviceId: string = '';

    setBlackList(blackList: string[]) {
        this.blackList = blackList;
    }

    setSelectType(selectType: number) {
        this.selectType = selectType;
    }

    setDeviceId(deviceId: string) {
        this.deviceId = deviceId;
    }

    async reloadAlbumItemData(): Promise<AlbumDataItem[]> {
        let albumDataItems = [];
        for (let i = 0;i < MediaConstants.ALBUM_DEFAULT_SORT_LIST.length; i++) {
            await this.getAlbumItem(MediaConstants.ALBUM_DEFAULT_SORT_LIST[i], albumDataItems);
        }
        await this.getCommonAlbumItem(albumDataItems);
        await this.getAlbumItem(MediaConstants.ALBUM_ID_RECYCLE, albumDataItems);
        return albumDataItems;
    }

    private async getCommonAlbumItem(albumDataItems: AlbumDataItem[]): Promise<void> {
        let fetchOption: MediaLib.MediaFetchOptions = await getFetchOptions(this.selectType, "", this.deviceId);
        if (fetchOption == undefined) {
            return;
        }
        fetchOption.selections = `(${fetchOption.selections}) and (${MediaLib.FileKey.ALBUM_NAME} <> ? and ${MediaLib.FileKey.ALBUM_NAME} <> ?)`;
        fetchOption.selectionArgs.push('Camera', 'Screenshots');
        let albums: MediaLib.Album[] = await mediaModel.getAlbums(fetchOption);
        for (let i = 0;i < albums.length; i++) {
            let album: MediaLib.Album = albums[i];
            if (this.blackList.indexOf(album.albumId.toString()) >= 0) {
                continue;
            }
            let fetchFileResult: MediaLib.FetchFileResult = await album.getFileAssets();
            try {
                let count = fetchFileResult.getCount();
                if (count == 0) {
                    continue;
                }
                let item = new AlbumDataItem(album.albumId.toString(), count, album.albumName, this.selectType, this.deviceId);
                item.update(await fetchFileResult.getFirstObject());
                albumDataItems.push(item);
            } catch (err) {
                Log.error(TAG, `on err: ${JSON.stringify(err)}`);
            } finally {
                fetchFileResult.close();
            }
        }
    }

    private async getAlbumItem(id: string, albumDataItems: AlbumDataItem[]): Promise<void> {
        if (this.blackList.indexOf(id) >= 0) {
            Log.debug(TAG, `no need as in black list`);
            return;
        }
        if (this.deviceId.length > 0 && (id != MediaConstants.ALBUM_ID_SNAPSHOT && id != MediaConstants.ALBUM_ID_CAMERA)) {
            Log.debug(TAG, `no need`);
            return;
        }
        let fetchOption: MediaLib.MediaFetchOptions = await getFetchOptions(this.selectType, id, this.deviceId);
        if (fetchOption == undefined) {
            Log.warn(TAG, `${id} fetchOption is undefined`);
            return;
        }
        let item = await mediaModel.getAllMediaItem(id, fetchOption, false);
        if (item.counts == 0) {
            Log.warn(TAG, `${id} is empty`);
            return;
        }

        let displayName = await getAlbumDisplayName(id);
        let albumItem: AlbumDataItem = new AlbumDataItem(id, item.counts, displayName, this.selectType, this.deviceId);
        albumItem.update(item.fileAsset);
        albumDataItems.push(albumItem);
        return;
    }

    async reloadAlbumListItemData(): Promise<AlbumDataItem[]> {
        Log.info(TAG, 'reloadAlbumListItemData start');
        let albumDataItems = [];
        for (let i = 0;i < MediaConstants.ALBUM_DEFAULT_SORT_LIST.length; i++) {
            await this.getAlbumItem(MediaConstants.ALBUM_DEFAULT_SORT_LIST[i], albumDataItems);
        }
        await this.getCommonListAlbumItem(albumDataItems, 0, QueryConstants.ALBUM_COPY_FIRST_PAGE_QUERY_LENGTH);
        return albumDataItems;
    }

    async reloadResetAlbumItemData(): Promise<AlbumDataItem[]> {
        Log.info(TAG, 'reloadResetAlbumItemData start');
        let albumResetDataItems = [];
        await this.loadAlbumReset(albumResetDataItems, QueryConstants.ALBUM_COPY_FIRST_PAGE_QUERY_LENGTH);
        await this.getAlbumItem(MediaConstants.ALBUM_ID_RECYCLE, albumResetDataItems);
        return albumResetDataItems;
    }

    private async getCommonListAlbumItem(albumDataItems: AlbumDataItem[], start: number, count: number): Promise<void> {
        let fetchOption: MediaLib.MediaFetchOptions = await this.getLimitCountFetchOption(start, count);
        if (fetchOption == undefined) {
            return;
        }
        let albums: MediaLib.Album[] = await mediaModel.getAlbums(fetchOption);
        await this.addAlbumDataItem(albumDataItems, albums);
    }

    private async addAlbumDataItem(albumDataItems: AlbumDataItem[], albums: MediaLib.Album[]) {
        for (let i = 0;i < albums.length; i++) {
            let album: MediaLib.Album = albums[i];
            if (this.blackList.indexOf(album.albumId.toString()) >= 0) {
                continue;
            }
            let fetchFileResult: MediaLib.FetchFileResult = await album.getFileAssets();
            try {
                let count = fetchFileResult.getCount();
                if (count == 0) {
                    continue;
                }
                let item = new AlbumDataItem(album.albumId.toString(), count, album.albumName, this.selectType, this.deviceId);
                item.update(await fetchFileResult.getFirstObject());
                albumDataItems.push(item);
            } catch (err) {
                Log.error(TAG, `on err: ${JSON.stringify(err)}`);
            } finally {
                fetchFileResult.close();
            }
        }
    }

    private async getLimitCountFetchOption(start: number, count: number): Promise<MediaLib.MediaFetchOptions> {
        let fetchOption: MediaLib.MediaFetchOptions = await getFetchOptions(this.selectType, "", this.deviceId);
        if (fetchOption == undefined) {
            return;
        }
        fetchOption.selections = `(${fetchOption.selections}) and (${MediaLib.FileKey.ALBUM_NAME} <> ? and ${MediaLib.FileKey.ALBUM_NAME} <> ?)`;
        fetchOption.selectionArgs.push('Camera', 'Screenshots');
        fetchOption.order = `bucket_id DESC LIMIT ${start},${count}`;
        return fetchOption;
    }

    private async loadAlbumReset(albumDataItems: AlbumDataItem[], count) {
        Log.info(TAG, `loadReset satrt`);
        for (let i = 1;; i++) {
            let fetchOption: MediaLib.MediaFetchOptions = await this.getLimitCountFetchOption(i * count, count);
            if (fetchOption == undefined) {
                return;
            }
            let albums: MediaLib.Album[] = await mediaModel.getAlbums(fetchOption);
            await this.addAlbumDataItem(albumDataItems, albums);
            //last page
            if (albums.length < count) {
                Log.info(TAG, `loadReset last ROUND : ${i}}`);
                break;
            }
        }
        Log.info(TAG, 'loadAlbumReset end');
    }
}