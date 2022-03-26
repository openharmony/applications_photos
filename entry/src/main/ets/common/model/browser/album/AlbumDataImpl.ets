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
import {AlbumDefine} from '../AlbumDefine'
import {AlbumInfo} from './AlbumInfo'
import {AsyncCallback} from '../../common/AsyncCallback'
import {BrowserDataImpl} from '../BrowserDataImpl.ets'
import {MediaLibraryAccess} from '../../../access/MediaLibraryAccess.ets'
import {Logger} from '../../../utils/Logger.ets'

export class AlbumDataImpl extends BrowserDataImpl {
    logger = new Logger('AlbumDataImpl');

    private virtualAlbumList = [
        AlbumDefine.ALBUM_NAME_ALL,
        AlbumDefine.ALBUM_NAME_VIDEO,
    ];
    private entityAlbumList = new Map([
        [AlbumDefine.CAMERA_ALBUM_PATH, AlbumDefine.ALBUM_NAME_CAMERA],
        [AlbumDefine.ALBUM_NAME_REMOTE, AlbumDefine.ALBUM_NAME_REMOTE],
    ]);

    private deviceId:string = '';
    private deviceName:string = '';

    constructor(param) {
        super();
        if (param) {
            this.logger.debug(`Remote networkId: ${param.deviceId}`);
            this.deviceId = param.deviceId;
            this.deviceName = param.deviceName;
        }else{
            this.logger.debug(`Local`);
        }

        this.logger = new Logger(`AlbumDataImpl[${this.deviceId}]`);
    }

    async getData(callback, param) : Promise<void> {
        return new Promise((resolve) => {
            if (param == null) {
                this.buildAlbums(callback);
            } else {
                this.genAlbumsInfo(callback,param);
            }
            resolve();
        });
    }

    private async genAlbumsInfo(cb, uris) {
        this.logger.debug(`genAlbumsInfo uris: ${JSON.stringify(uris)}`);

        let res = {
            uris: [],
            count: 0,
            videoCount: 0,
        };

        for (let name of uris) {
            let objects = await super.getItems(name, -1, -1, this.deviceId);
            this.logger.debug(`get album objects: Name:${name} length: ${objects.length}`);

            res.count += objects.length;
            for (let item of objects) {
                res.uris.push(item.uri);
            }
            let tmpAlbum = new AlbumInfo('', name, '', 0, '');
            await this.updateAlbumVideoCount(tmpAlbum);
            this.logger.debug(`get album objects: vcount: ${tmpAlbum.videoCount}`);
            res.videoCount += tmpAlbum.videoCount;
        }

        this.logger.debug(`genAlbumsInfo done`);
        cb(res);
    }

    private async buildAlbums(callback: AsyncCallback<AlbumInfo[]>) {
        this.logger.debug(`buildAlbums`);
        let sourceData = new Map();

        await this.getVirtualAlbum(sourceData);

        await this.getFavorAlbum(sourceData);

        await this.getEntityAlbumSourceData(sourceData);

        let res = this.genSortedAlbums(sourceData);

        await this.getTrashAlbum(res);

        callback.callback(res);
    }

    private isRemoteDevice(): boolean {
        return (this.deviceId != '' && this.deviceId != undefined);
    }

    private async getVirtualAlbum(albumList) {
        this.logger.debug(`getVirtualAlbum`);

        if (this.isRemoteDevice()) {
            return;
        }

        for (let name of this.virtualAlbumList) {
            let file = await this.getFirstObject(AlbumDefine.getFetchOpt(name, this.deviceId));
            if (file.count > 0) {
                let data = new AlbumInfo(this.getThumbnailSafe(file.obj.uri),
                    name, this.getAlbumDisplayName(name), file.count, this.deviceId);
                data.deviceName = this.deviceName;
                data.isDisableDelete = AlbumDefine.ALBUM_DISABLE_DELETE_LIST.has(name);
                data.isDisableRename = AlbumDefine.ALBUM_DISABLE_RENAME_LIST.has(name);
                albumList.set(data.name, data);
            }
        }

        this.logger.debug('get virtual album done');
    }

    private async getFavorAlbum(albumList) {
        if (this.isRemoteDevice()){
            return;
        }

        let favAlbum = await MediaLibraryAccess.getFavoriteAlbum(AlbumDefine.getFetchOpt(AlbumDefine.ALBUM_NAME_FAVOR));
        if (favAlbum.count > 0) {
                let fav = new AlbumInfo(await this.getThumbnailSafe(favAlbum.file.uri), AlbumDefine.ALBUM_NAME_FAVOR, this.getAlbumDisplayName(AlbumDefine.ALBUM_NAME_FAVOR), favAlbum.count, this.deviceId);
                fav.isDisableDelete = AlbumDefine.ALBUM_DISABLE_DELETE_LIST.has(fav.name);
                fav.isDisableRename = AlbumDefine.ALBUM_DISABLE_RENAME_LIST.has(fav.name);
                albumList.set(fav.name, fav);
        }
    }

    private async getTrashAlbum(albumList) {
        if (this.isRemoteDevice()) {
            return;
        }

        let trashAlbum = await MediaLibraryAccess.getTrashAlbum(AlbumDefine.getFetchOpt(AlbumDefine.ALBUM_NAME_RECYCLE));
        if (trashAlbum.count > 0) {
            let trash = new AlbumInfo(await this.getThumbnailSafe(trashAlbum.file.uri), AlbumDefine.ALBUM_NAME_RECYCLE,
                this.getAlbumDisplayName(AlbumDefine.ALBUM_NAME_RECYCLE), trashAlbum.count, this.deviceId);
            trash.isDisableDelete = AlbumDefine.ALBUM_DISABLE_DELETE_LIST.has(trash.name);
            trash.isDisableRename = AlbumDefine.ALBUM_DISABLE_RENAME_LIST.has(trash.name);

            albumList.push(trash);
        }
        this.logger.debug('get trash album done');
    }

    private async getEntityAlbumSourceData(output) {
        this.logger.debug('getEntityAlbumSourceData');
        let fileFetchOpt = {
            selections: '',
            selectionArgs: [],
            order: AlbumDefine.QUERY_ORDER_BASE
        };

        let albums = await MediaLibraryAccess.getAlbums(AlbumDefine.getAlbumFetchOpt('', this.deviceId));
        if (albums) {
            for (let item of albums) {
                let fileResult = await item.getFileAssets(fileFetchOpt);
                let count = fileResult.getCount();
                if (count <= 0) {
                    this.logger.warn(`Not valid album Name: ${item.albumName} URI: ${item.albumUri}`);
                    continue;
                }
                let obj = await fileResult.getFirstObject();
                this.logger.debug(`albumName: ${item.albumName} file count: ${count} coverUri:${obj.uri}`);

                let album = new AlbumInfo(this.getThumbnailSafe(obj.uri),
                    item.albumName, item.albumName, count, this.deviceId);
                album.uri = item.albumUri;
                album.deviceName = this.deviceName;

                this.fixDefaultEntityAlbum(album, obj);

                album.isDisableDelete = AlbumDefine.ALBUM_DISABLE_DELETE_LIST.has(album.name);
                album.isDisableRename = AlbumDefine.ALBUM_DISABLE_RENAME_LIST.has(album.name);
                await this.updateAlbumVideoCount(album);
                output.set(album.name, album);

                fileResult.close();
            }
        } else {
            this.logger.error('Failed getEntityAlbumSourceData');
        }

        this.logger.debug('get entity album done');
    }

    private getAlbumDisplayName(name) {
        switch (name) {
            case AlbumDefine.ALBUM_NAME_ALL:
                return $r('app.string.album_all');
            case AlbumDefine.ALBUM_NAME_VIDEO:
                return $r('app.string.album_video');
            case AlbumDefine.ALBUM_NAME_RECYCLE:
                return $r('app.string.album_recycle');
            case AlbumDefine.ALBUM_NAME_CAMERA:
                return $r('app.string.album_camera');
            case AlbumDefine.ALBUM_NAME_FAVOR:
                return $r('app.string.album_favor');
            case AlbumDefine.ALBUM_NAME_REMOTE:
                return $r('app.string.album_remote_device');
            default:
                break;
        }
        return null;
    }

    private fixDefaultEntityAlbum(album, src) {
        let value = this.entityAlbumList.get(album.name);
        if (value != undefined && src.relativePath == `${globalThis.__MediaLibraryAccess_PUBLIC_PATH_IMAGE}${album.name}/`) {
            album.displayName = this.getAlbumDisplayName(value);
            album.name = value;
        }
    }

    private genSortedAlbums(src): AlbumInfo[] {
        this.logger.debug('genSortedAlbums');

        let albums = [];

        for (let item of this.getAlbumSortInfo()) {
            let value = src.get(item);
            if (value != undefined) {
                albums.push(value);
                src.delete(item);
            }
        }

        for (let item of src.values()) {
            albums.push(item);
        }

        return albums;
    }

    private getAlbumSortInfo() {
        return AlbumDefine.ALBUM_DEFAULT_SORT_LIST;
    }

    getMediaItemCount(callback, albumInfo) {
        this.updateAlbumVideoCount(albumInfo);
    }

    async updateAlbumVideoCount(albumInfo: AlbumInfo) {
        this.logger.debug(`updateAlbumVideoCount ${albumInfo.name}`);
        switch (albumInfo.name) {
            case AlbumDefine.ALBUM_NAME_ALL:
                albumInfo.videoCount = await super.getCount(AlbumDefine.getFetchOpt(AlbumDefine.ALBUM_NAME_VIDEO));
                break;
            case AlbumDefine.ALBUM_NAME_VIDEO:
                albumInfo.videoCount = albumInfo.count;
                break;
            default:
                albumInfo.videoCount
                    = await MediaLibraryAccess.getEntityAlbumCount(AlbumDefine.getAlbumFetchOpt(albumInfo.name),
                    AlbumDefine.getFetchOpt(AlbumDefine.ALBUM_NAME_VIDEO));
                break;
        }
    }
}