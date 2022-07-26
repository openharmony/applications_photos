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
import {BrowserDataImpl} from '../BrowserDataImpl'
import {MediaLibraryAccess} from '../../../access/MediaLibraryAccess'
import {Logger} from '../../../utils/Logger'
import {UiUtil} from '../../../utils/UiUtil'

export class AlbumDataImpl extends BrowserDataImpl {
    logger = new Logger('AlbumDataImpl');

    private virtualAlbumList = [
        AlbumDefine.ALBUM_ID_ALL,
        AlbumDefine.ALBUM_ID_VIDEO,
    ];
    private entityAlbumList = new Map([
        [`${MediaLibraryAccess.getInstance().PUBLIC_PATH_CAMERA}`, AlbumDefine.ALBUM_ID_CAMERA],
        [`${MediaLibraryAccess.getInstance().PUBLIC_PATH_CAMERA}${AlbumDefine.REMOTE_ALBUM_PATH}/`, AlbumDefine.ALBUM_ID_REMOTE],
        [`${MediaLibraryAccess.getInstance().PUBLIC_PATH_IMAGE}${AlbumDefine.SNAPSHOT_ALBUM_PATH}/`, AlbumDefine.ALBUM_ID_SNAPSHOT],
    ]);

    private deviceId:string = '';
    private deviceName:string = '';
    private moreInfo: boolean = false;

    constructor(param) {
        super();
        if (param && param.deviceId) {
            this.logger.debug(`Remote networkId: ${param.deviceId}`);
            this.deviceId = param.deviceId;
            this.deviceName = param.deviceName;
        }else{
            this.logger.debug(`Local`);
        }

        if (param && param.moreInfo){
            this.moreInfo = param.moreInfo
        }

        this.logger = new Logger(`AlbumDataImpl[${this.deviceId}]`);
    }

    getData(callback, param) : void {
        if (param == null) {
            this.buildAlbums(callback);
        } else {
            this.genAlbumsInfo(callback,param);
        }
    }

    async getDataById(id: any, deviceId? :any) {
        let albums = await MediaLibraryAccess.getInstance().getAlbums(AlbumDefine.getAlbumFetchOpt(id, deviceId));
        if (albums && albums.length > 0){
            return albums[0];
        }else{
            return null;
        }
    }

    async getDataByName(name: string, albumInfo: any) {
        let albums = await MediaLibraryAccess.getInstance().getAlbums(AlbumDefine.getAlbumFetchOptByName(name, albumInfo.relativePath));
        if (albums && albums.length > 0){
            let fileResult = await albums[0].getFileAssets(AlbumDefine.getFileFetchOpt(''));
            let count = fileResult.getCount();
            if (count <= 0) {
                this.logger.warn(`Not valid album Name: ${albums[0].albumName} URI: ${albums[0].albumUri} relativePath: ${albums[0].relativePath} id: ${albums[0].albumId}`);
                return null;
            }
            return albums[0];
        }else{
            return null;
        }
    }

    private async genAlbumsInfo(cb, ids) {
        this.logger.debug(`genAlbumsInfo ids: ${JSON.stringify(ids)}`);

        let res = {
            uris: [],
            count: 0,
            videoCount: 0,
        };

        for (let id of ids) {
            let objects = await super.getItems(id, -1, -1, this.deviceId);
            this.logger.debug(`get album objects: id:${id} length: ${objects.length}`);

            res.count += objects.length;
            for (let item of objects) {
                res.uris.push(item.uri);
            }
            let tmpAlbum = new AlbumInfo(id, '', '', '', 0, '', '');
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

        for (let id of this.virtualAlbumList) {
            let file = await this.getFirstObject(AlbumDefine.getFileFetchOpt(id, this.deviceId));
            if (file.count > 0) {
                let data = new AlbumInfo(id, this.getThumbnailSafe(file.obj.uri),
                    id, await this.getAlbumDisplayName(id), file.count, this.deviceId, '');
                data.coverOrientation = file.obj.orientation;
                data.deviceName = this.deviceName;
                data.innerId = id;
                data.isDisableDelete = AlbumDefine.ALBUM_DISABLE_DELETE_LIST.has(data.innerId);
                data.isDisableRename = AlbumDefine.ALBUM_DISABLE_RENAME_LIST.has(data.innerId);
                albumList.set(data.innerId, data);
            }
        }

        this.logger.debug('get virtual album done');
    }

    private async getFavorAlbum(albumList) {
        if (this.isRemoteDevice()){
            return;
        }

        let favAlbum = await MediaLibraryAccess.getInstance().getFavoriteAlbum(AlbumDefine.getFileFetchOpt(AlbumDefine.ALBUM_ID_FAVOR));
        if (favAlbum.count > 0) {
                let fav = new AlbumInfo(AlbumDefine.ALBUM_ID_FAVOR, this.getThumbnailSafe(favAlbum.file.uri), AlbumDefine.ALBUM_ID_FAVOR,
                    await this.getAlbumDisplayName(AlbumDefine.ALBUM_ID_FAVOR), favAlbum.count, this.deviceId, '');
                fav.coverOrientation = favAlbum.file.orientation;
                fav.innerId = fav.id;
                fav.isDisableDelete = AlbumDefine.ALBUM_DISABLE_DELETE_LIST.has(fav.innerId);
                fav.isDisableRename = AlbumDefine.ALBUM_DISABLE_RENAME_LIST.has(fav.innerId);
                albumList.set(fav.innerId, fav);
        }
    }

    private async getTrashAlbum(albumList) {
        if (this.isRemoteDevice()) {
            return;
        }

        let trashAlbum = await MediaLibraryAccess.getInstance().getTrashAlbum(AlbumDefine.getFileFetchOpt(AlbumDefine.ALBUM_ID_RECYCLE));
        if (trashAlbum.count > 0) {
            let trash = new AlbumInfo(AlbumDefine.ALBUM_ID_RECYCLE, this.getThumbnailSafe(trashAlbum.file.uri), AlbumDefine.ALBUM_ID_RECYCLE,
                await this.getAlbumDisplayName(AlbumDefine.ALBUM_ID_RECYCLE), trashAlbum.count, this.deviceId, '');
            trash.coverOrientation = trashAlbum.file.orientation;
            trash.innerId = trash.id;
            trash.isDisableDelete = AlbumDefine.ALBUM_DISABLE_DELETE_LIST.has(trash.innerId);
            trash.isDisableRename = AlbumDefine.ALBUM_DISABLE_RENAME_LIST.has(trash.innerId);

            albumList.push(trash);
        }
        this.logger.debug('get trash album done');
    }

    private async getEntityAlbumSourceData(output) {
        this.logger.debug('getEntityAlbumSourceData');

        let albums = await MediaLibraryAccess.getInstance().getAlbums(AlbumDefine.getAlbumFetchOpt('', this.deviceId));
        if (albums) {
            for (let item of albums) {
                let fileResult = await item.getFileAssets(AlbumDefine.getFileFetchOpt(''));
                let count = fileResult.getCount();
                if (count <= 0) {
                    this.logger.warn(`Not valid album Name: ${item.albumName} URI: ${item.albumUri} relativePath: ${item.relativePath} id: ${item.albumId}`);
                    continue;
                }
                let obj = await fileResult.getFirstObject();
                this.logger.debug(`albumName: ${item.albumName} file count: ${count} coverUri:${obj.uri} relativePath: ${item.relativePath} id: ${item.albumId}`);

                let album = new AlbumInfo(`${item.albumId}`, this.getThumbnailSafe(obj.uri),
                    item.albumName, item.albumName, count, this.deviceId, obj.relativePath);
                album.coverOrientation = obj.orientation;
                album.uri = item.albumUri;
                album.deviceName = this.deviceName;
                album.innerId = album.id;

                await this.fixDefaultEntityAlbum(album);

                album.isDisableDelete = AlbumDefine.ALBUM_DISABLE_DELETE_LIST.has(album.innerId);
                album.isDisableRename = AlbumDefine.ALBUM_DISABLE_RENAME_LIST.has(album.innerId);
                if (this.moreInfo){
                    await this.updateAlbumVideoCount(album);
                }
                output.set(album.innerId, album);

                fileResult.close();
            }
        } else {
            this.logger.error('Failed getEntityAlbumSourceData');
        }

        this.logger.debug('get entity album done');
    }

    private async getAlbumDisplayName(name) {
        switch (name) {
            case AlbumDefine.ALBUM_ID_ALL:
                return await UiUtil.getResourceString($r('app.string.album_all'));
            case AlbumDefine.ALBUM_ID_VIDEO:
                return await UiUtil.getResourceString($r('app.string.album_video'));
            case AlbumDefine.ALBUM_ID_RECYCLE:
                return await UiUtil.getResourceString($r('app.string.album_recycle'));
            case AlbumDefine.ALBUM_ID_CAMERA:
                return await UiUtil.getResourceString($r('app.string.album_camera'));
            case AlbumDefine.ALBUM_ID_FAVOR:
                return await UiUtil.getResourceString($r('app.string.album_favor'));
            case AlbumDefine.ALBUM_ID_REMOTE:
                return await UiUtil.getResourceString($r('app.string.album_remote_device'));
            case AlbumDefine.ALBUM_ID_SNAPSHOT:
                return await UiUtil.getResourceString($r('app.string.album_screen_shot'));
            default:
                break;
        }
        return null;
    }

    private async fixDefaultEntityAlbum(album: AlbumInfo) {
        let value = this.entityAlbumList.get(album.relativePath);
        if (value != undefined) {
            album.displayName = await this.getAlbumDisplayName(value);
            album.innerId = value;
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

    getDataCount(callback, albumInfo) {
        this.updateAlbumVideoCount(albumInfo);
    }

    async updateAlbumVideoCount(albumInfo: AlbumInfo) {
        this.logger.debug(`updateAlbumVideoCount ${albumInfo.id}`);
        switch (albumInfo.id) {
            case AlbumDefine.ALBUM_ID_ALL:
                albumInfo.videoCount = await super.getCount(AlbumDefine.getFileFetchOpt(AlbumDefine.ALBUM_ID_VIDEO));
                break;
            case AlbumDefine.ALBUM_ID_VIDEO:
                albumInfo.videoCount = albumInfo.count;
                break;
            default:
                albumInfo.videoCount
                    = await MediaLibraryAccess.getInstance().getEntityAlbumCount(AlbumDefine.getAlbumFetchOpt(albumInfo.id),
                    AlbumDefine.getFileFetchOpt(AlbumDefine.ALBUM_ID_VIDEO));
                break;
        }
    }
}