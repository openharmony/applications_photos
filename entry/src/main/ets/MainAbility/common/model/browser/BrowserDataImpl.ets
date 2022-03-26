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
import {BrowserDataInterface} from './interface/BrowserDataInterface'
import {AlbumDefine} from './AlbumDefine'
import {Logger} from '../../utils/Logger.ets'
import {MediaLibraryAccess} from '../../access/MediaLibraryAccess.ets';

export abstract class BrowserDataImpl implements BrowserDataInterface {
    logger: Logger = new Logger('BrowserDataImpl');

    abstract getData(callback, param): Promise<void>;
    abstract getMediaItemCount(callback, param): void;

    async getAllObject(fetchOpt) {
        this.logger.debug('getAllObject');
        let allObject = await MediaLibraryAccess.getAllObject(fetchOpt);
        return allObject;
    }

    async getCount(fetchOpt) {
        let count = await MediaLibraryAccess.getCount(fetchOpt);
        return count;
    }

    async getFirstObject(fetchOpt) {
        this.logger.debug('getFirstObject');
        let firstObject = await MediaLibraryAccess.getFirstObject(fetchOpt);
        return firstObject;
    }

    async getItems(albumName: string, startIndex?: number, count?:number, deviceId?) {
        let external_order = '';
        if ( startIndex != undefined && count != undefined && startIndex >= 0  && count >= 0) {
            external_order = ` LIMIT ${startIndex},${count}`;
        }

        let fetchOpt = AlbumDefine.getFetchOpt(albumName, deviceId);
        fetchOpt.order += external_order;

        switch (albumName) {
            case AlbumDefine.ALBUM_NAME_ALL:
            case AlbumDefine.ALBUM_NAME_VIDEO:
                return await this.getAllObject(fetchOpt);
            case AlbumDefine.ALBUM_NAME_FAVOR:
                return await MediaLibraryAccess.getFavoriteObject(fetchOpt);
            case AlbumDefine.ALBUM_NAME_RECYCLE:
                return await MediaLibraryAccess.getTrashObject(fetchOpt);
            default:
                let fileFetchOpt = {
                    selections: '',
                    selectionArgs: [],
                    order: AlbumDefine.QUERY_ORDER_BASE + external_order
                }
                if (deviceId != undefined && deviceId != '') {
                    fetchOpt['networkId'] = deviceId
                }
                return await MediaLibraryAccess.getEntityAlbumObject(
                    AlbumDefine.getAlbumFetchOpt(albumName, deviceId), fileFetchOpt);
                break;
        }
    }

    async getItemsCount(albumName, deviceId?) {
        switch (albumName) {
            case AlbumDefine.ALBUM_NAME_ALL:
            case AlbumDefine.ALBUM_NAME_VIDEO:
                let fetchOpt = AlbumDefine.getFetchOpt(albumName, deviceId);
                return await this.getCount(fetchOpt);
            case AlbumDefine.ALBUM_NAME_FAVOR:
                return await MediaLibraryAccess.getFavoriteCount();
            case AlbumDefine.ALBUM_NAME_RECYCLE:
                return await MediaLibraryAccess.getTrashCount();
            default:
                return await MediaLibraryAccess.getEntityAlbumCount(AlbumDefine.getAlbumFetchOpt(albumName, deviceId));
                break;
        }
    }

    async getTrashObjectById(id) {
        this.logger.info('getTrashObjectById');

        try {
            let result = await MediaLibraryAccess.getTrashObject(AlbumDefine.getFileFetchOpt(id));
            if (result == null) {
                this.logger.info('getTrashObjectByUri fail');
                return null;
            }
            return result[0];
        } catch (error) {
            this.logger.error('getTrashObject error');
            return null;
        }
    }

    async getThumbnailSafe(file, opt?) {
        this.logger.debug('getThumbnailSafe');
        try{
            if (opt) {
                return await file.getThumbnail(opt);
            } else {
                return await file.getThumbnail();
            }
        } catch (err) {
            this.logger.warn(`get Thumbnail Failed! msg:${err}`);
            return null;
        }
    }
}