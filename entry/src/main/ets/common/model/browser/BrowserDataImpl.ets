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
import {BrowserDataInterface} from '../../interface/BrowserDataInterface'
import {AlbumDefine} from './AlbumDefine'
import {Logger} from '../../utils/Logger'
import {MediaLibraryAccess} from '../../access/MediaLibraryAccess';

export abstract class BrowserDataImpl implements BrowserDataInterface {
    logger: Logger = new Logger('BrowserDataImpl');
    static readonly THUMBNAIL_WIDTH = 256;

    abstract getData(callback, param): void;
    abstract getDataCount(callback, param): void;
    abstract getDataById(id: any, deviceId? :any): any;
    abstract getDataByName(name: string, albumInfo: any): any;

    async getAllObject(fetchOpt) {
        this.logger.debug('getAllObject');
        let allObject = await MediaLibraryAccess.getInstance().getAllObject(fetchOpt);
        return allObject;
    }

    async getCount(fetchOpt) {
        let count = await MediaLibraryAccess.getInstance().getCount(fetchOpt);
        return count;
    }

    async getFirstObject(fetchOpt) {
        this.logger.debug('getFirstObject');
        let firstObject = await MediaLibraryAccess.getInstance().getFirstObject(fetchOpt);
        return firstObject;
    }

    async getItems(albumId: string, startIndex?: number, count?:number, deviceId?) {
        let fetchOpt = AlbumDefine.getFileFetchOpt(albumId, deviceId, startIndex, count);
        switch (albumId) {
            case AlbumDefine.ALBUM_ID_ALL:
            case AlbumDefine.ALBUM_ID_VIDEO:
                return await this.getAllObject(fetchOpt);
            case AlbumDefine.ALBUM_ID_FAVOR:
                return await MediaLibraryAccess.getInstance().getFavoriteObject(fetchOpt);
            case AlbumDefine.ALBUM_ID_RECYCLE:
                return await MediaLibraryAccess.getInstance().getTrashObject(fetchOpt);
            default:
                return await MediaLibraryAccess.getInstance().getEntityAlbumObject(
                    AlbumDefine.getAlbumFetchOpt(albumId, deviceId), fetchOpt);
                break;
        }
    }

    async getItemsCount(albumId, deviceId?) {
        switch (albumId) {
            case AlbumDefine.ALBUM_ID_ALL:
            case AlbumDefine.ALBUM_ID_VIDEO:
                let fetchOpt = AlbumDefine.getFileFetchOpt(albumId, deviceId);
                return await this.getCount(fetchOpt);
            case AlbumDefine.ALBUM_ID_FAVOR:
                return await MediaLibraryAccess.getInstance().getFavoriteCount();
            case AlbumDefine.ALBUM_ID_RECYCLE:
                return await MediaLibraryAccess.getInstance().getTrashCount();
            default:
                return await MediaLibraryAccess.getInstance().getEntityAlbumCount(AlbumDefine.getAlbumFetchOpt(albumId, deviceId), AlbumDefine.getFileFetchOpt(''));
                break;
        }
    }

    getThumbnailSafe(sourceUri: string, size?) {
        this.logger.debug('getThumbnailSafe');

        try{
            if (size) {
                return `${sourceUri}/thumbnail/${size.width}/${size.height}`;
            } else {
                return `${sourceUri}/thumbnail/${BrowserDataImpl.THUMBNAIL_WIDTH}/${BrowserDataImpl.THUMBNAIL_WIDTH}`;
            }
        } catch (err) {
            this.logger.error(`get Thumbnail Failed! msg:${err}`);
            return null;
        }
    }
}