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

import {Logger} from '../utils/Logger'
import MediaLib from '@ohos.multimedia.mediaLibrary';
import {Constants} from '../model/common/Constants'
import { TraceControllerUtils } from '../utils/TraceControllerUtils';

export class MediaLibraryAccess {
    private logger: Logger = new Logger('MediaLibraryAccess');

    static readonly MEDIA_TYPE_IMAGE = MediaLib.MediaType.IMAGE;
    static readonly MEDIA_TYPE_VIDEO = MediaLib.MediaType.VIDEO;

    static readonly DIRECTORY_TYPE_IMAGE = MediaLib.DirectoryType.DIR_IMAGE;
    static readonly DIRECTORY_TYPE_CAMERA = MediaLib.DirectoryType.DIR_CAMERA;

    static readonly FILE_KEY_ID = MediaLib.FileKey.ID;
    static readonly FILE_KEY_MEDIA_TYPE = MediaLib.FileKey.MEDIA_TYPE;
    static readonly FILE_KEY_ALBUM_NAME = MediaLib.FileKey.ALBUM_NAME;
    static readonly FILE_KEY_ALBUM_ID = MediaLib.FileKey.ALBUM_ID;
    static readonly FILE_KEY_DISPLAY_NAME = MediaLib.FileKey.DISPLAY_NAME;
    static readonly FILE_KEY_RELATIVE_PATH = MediaLib.FileKey.RELATIVE_PATH;
    static readonly FILE_KEY_DATE_TAKEN = MediaLib.FileKey.DATE_ADDED; // TODO dateTaken is not supported, use dateAdded
    static readonly FILE_KEY_DATE_TRASHED = 'date_trashed'  //TODO dataTrashed is not define in FileKey

    PUBLIC_PATH_IMAGE = '';
    PUBLIC_PATH_CAMERA = '';

    private media = null;
    private requestTime: number;

    public static getInstance(): MediaLibraryAccess {
        if (AppStorage.Get(Constants.APP_KEY_INSTANCE_MEDIA_LIBRARY_ACCESS) == null) {
            AppStorage.SetOrCreate(Constants.APP_KEY_INSTANCE_MEDIA_LIBRARY_ACCESS, new MediaLibraryAccess());
        }
        return AppStorage.Get(Constants.APP_KEY_INSTANCE_MEDIA_LIBRARY_ACCESS);
    }

    constructor() {
        this.requestTime = Date.now();
    }

    onCreate(context) {
        this.logger.debug(`Photos_MediaLibraryAccess onCreate ${context}`);
        if (this.media) {
            this.logger.debug(`Photos_MediaLibraryAccess onCreate already`);
            return;
        }
        this.media = MediaLib.getMediaLibrary(context);
        this.logger.debug('Photos_MediaLibraryAccess onCreate end');
        if (this.media == null || this.media == undefined) {
            this.logger.error('get media library instance failed!');
        }

        this.getPublicDirectory();
        this.logger.info('onCreate done');
    }

    onDestroy() {
        try {
            this.media && this.media.release();
            this.media = null;
            this.logger.info('onDestroy done');
        } catch (e) {
            this.logger.error(`onDestroy error: ${e}`);
        }
    }

    getMediaLibrary() {
        return this.media;
    }


    async getAllObject(fetchOpt) {
        this.logger.info(`getAllObject: ${JSON.stringify(fetchOpt)}`);
        try {
            TraceControllerUtils.startTraceWithTaskId('getAllObject', this.requestTime);
            let dataList = await this.media.getFileAssets(fetchOpt);
            if (dataList == null) {
                this.logger.warn('get all Object Data with empty dataList');
                return [];
            }
            this.logger.debug(`get all Object Data raw data size: ${dataList.getCount()}`);
            if (dataList.getCount() <= 0) {
                return [];
            }

            let result = await dataList.getAllObject();
            dataList.close();
            TraceControllerUtils.finishTraceWithTaskId('getAllObject', this.requestTime);
            return result;
        } catch (error) {
            this.logger.error(`getAllObject error: ${error}`);
            return [];
        }
    }

    async getCount(fetchOpt) {
        this.logger.info(`getCount: ${JSON.stringify(fetchOpt)}`);
        try {
            TraceControllerUtils.startTraceWithTaskId('getCount', this.requestTime);
            let dataList = await this.media.getFileAssets(fetchOpt);
            if (dataList == null) {
                this.logger.warn('get count dataList is 0');
                return 0;
            }
            this.logger.debug(`get count raw data size: ${dataList.getCount()}`);
            let result = dataList.getCount();
            dataList.close();
            TraceControllerUtils.finishTraceWithTaskId('getCount', this.requestTime);
            return result ;
        } catch (error) {
            this.logger.error(`get Count error:  ${error}`);
            return 0;
        }
    }

    async getFirstObject(fetchOpt) {
        let result = {
            count: 0,
            obj: null,
        }
        this.logger.info(`getFirstObject: ${JSON.stringify(fetchOpt)}`);
        try {
            TraceControllerUtils.startTraceWithTaskId('getFirstObject', this.requestTime);
            let fileResult = await this.media.getFileAssets(fetchOpt);
            if (fileResult != undefined) {
                result.count = fileResult.getCount();
                this.logger.error(`getFirstObject count is ${result.count}`);
                if (result.count <= 0) {
                    return result;
                }
                let file = await fileResult.getFirstObject();
                if (file) {
                    result.obj = file;
                    return result;
                } else {
                    this.logger.error('Failed getFirstObject');
                }
                fileResult.close();
            }
            TraceControllerUtils.finishTraceWithTaskId('getFirstObject', this.requestTime);
            return result;
        } catch (error) {
            this.logger.error(`getFirstObject loadData error: ${error}`);
            return result;
        }
    }

    async deleteAsset(uri: string){
        this.logger.debug(`deleteAsset uri: ${uri}`);
        await this.media.deleteAsset(uri);
    }

    async getPublicDirectory() {
        this.PUBLIC_PATH_IMAGE =
            await this.media.getPublicDirectory(MediaLibraryAccess.DIRECTORY_TYPE_IMAGE);
        this.PUBLIC_PATH_CAMERA =
            await this.media.getPublicDirectory(MediaLibraryAccess.DIRECTORY_TYPE_CAMERA);
    }

    async createAsset(mediaType: any, displayName: string, relativePath: string) {
        this.logger.debug('createAsset start');
        if (relativePath == null || relativePath == undefined) {
            this.logger.error('createAsset with empty relativePath');
            return null;
        }
        this.logger.info(`createAsset ${mediaType} ${displayName} ${relativePath}`);
        let fileAsset = await this.media.createAsset(mediaType, displayName, relativePath);
        this.logger.debug(`createAsset end. new fileAsset: ${fileAsset}`);
        if (fileAsset == null || fileAsset == undefined) {
            this.logger.error('createAsset Fail');
            return null;
        }
        return fileAsset;
    }

    async openAsset(mode: string, fileAsset: any) {
        this.logger.debug('openAsset start');
        let fd = await fileAsset.open(mode);
        this.logger.info(`openAsset end. fd: ${fd}`);
        if (fd <= 0) {
            this.logger.error('openAsset Fail');
            return;
        }
        return fd;
    }

    async closeAsset(fd: number, fileAsset: any) {
        this.logger.debug('closeAsset start');
        await fileAsset.close(fd);
    }

    async trashAsset(isTrash: boolean, fileAsset: any) {
        this.logger.debug('trashAsset start');
        await fileAsset.trash(isTrash);
    }

    async getFavoriteObject(fetchOpt) {
        this.logger.info(`Get favorite object: ${JSON.stringify(fetchOpt)}`);
        try {
            let albums = await this.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_FAVORITE);
            this.logger.debug(`[getFavoriteObject] get smart albums length:${albums.length} name:${albums[0].albumName}`);
            let fileResult = await albums[0].getFileAssets(fetchOpt);
            this.logger.debug(`[getFavoriteObject] object count :${fileResult.getCount()}`);
            let objects = await fileResult.getAllObject();
            this.logger.debug(`[getFavoriteObject] objects done`);
            fileResult.close();
            return objects;
        } catch(err) {
            this.logger.error(`Get favorite object exception! msg:  ${err}`);
            return [];
        }
    }

    async getTrashObject(fetchOpt) {
        this.logger.info(`Get trash object: ${JSON.stringify(fetchOpt)}`);
        try {
            let albums = await this.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_TRASH);
            this.logger.debug(`[getTrashObject] get smart albums length:${albums.length} name:${albums[0].albumName}`);
            let fileResult = await albums[0].getFileAssets(fetchOpt);
            this.logger.debug(`[getTrashObject] object count :${fileResult.getCount()}`);
            let objects = await fileResult.getAllObject();
            this.logger.debug(`[getTrashObject] get objects done`);
            fileResult.close();
            return objects;
        } catch(err) {
            this.logger.error(`Get Trash Object exception! msg: ${err}`);
            return [];
        }
    }

    async getEntityAlbumObject(fetchOpt, fileFetchOpt) {
        this.logger.info(`getEntityAlbumObject opt${JSON.stringify(fetchOpt)} fileOpt${JSON.stringify(fileFetchOpt)}`);
        try {
            let albums = await this.media.getAlbums(fetchOpt);
            this.logger.debug(`[getEntityAlbumObject]Get Albums done`);
            this.logger.debug(`[getEntityAlbumObject]Album length:${albums.length}`);
            if (albums.length == 0) {
                return []
            }
            this.logger.debug(`[getEntityAlbumObject]Albums name:${albums[0].albumName}`);
            let fileResult = await albums[0].getFileAssets(fileFetchOpt);
            this.logger.debug(`[getEntityAlbumObject]objects count :${fileResult.getCount()}`);
            if (fileResult.getCount() == 0) {
                return []
            }
            let objects = await fileResult.getAllObject();
            this.logger.debug(`[getEntityAlbumObject]Get objects done`);
            fileResult.close();
            return objects;
        } catch(err) {
            this.logger.error(`Get Entity Album Object exception! msg:  ${err}`);
            return []
        }
    }

    async getFavoriteCount() {
        this.logger.debug(`getFavoriteCount`);
        let fetchOpt = {
            selections: '',
            selectionArgs: [],
            order: ''
        }
        try {
            let albums = await this.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_FAVORITE);
            this.logger.debug(`[getFavoriteCount]Get smart Albums length:${albums.length} name:${albums[0].albumName}`);
            let fileResult = await albums[0].getFileAssets(fetchOpt);
            this.logger.debug(`[getFavoriteCount]Get objects done`);
            let count = fileResult.getCount();
            fileResult.close();
            return count;
        } catch(err) {
            this.logger.error(`Get Favorite count exception! msg:  ${err}`);
            return 0;
        }
    }

    async getTrashCount() {
        this.logger.debug(`getTrashCount`);
        let fetchOpt = {
            selections: '',
            selectionArgs: [],
            order: ''
        }
        try {
              let albums = await this.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_TRASH);
              this.logger.debug(`[getTrashCount]Get smart Albums length:${albums.length} name:${albums[0].albumName}`);
              let fileResult = await albums[0].getFileAssets(fetchOpt);
              this.logger.debug(`[getTrashCount]Get objects done`);
              let count = fileResult.getCount();
              fileResult.close();
              return count;
        } catch(err) {
            this.logger.error(`Get Trash count exception! msg: ${err}`);
            return 0;
        }
    }

    async getEntityAlbumCount(fetchOpt, fileFetchOpt?) {
        this.logger.info(`getEntityAlbumCount opt: ${JSON.stringify(fetchOpt)}`);
        try {
            let albums = await this.media.getAlbums(fetchOpt);
            this.logger.debug(`[getEntityAlbumCount]Get entity Albums length:${albums.length} name:${albums[0].albumName}`);
            let fileFetchOp;
            if (fileFetchOpt == undefined) {
                fileFetchOp = {
                    selections: '',
                    selectionArgs: []
                }
            } else {
                fileFetchOp = fileFetchOpt;
            }
            this.logger.debug(`[getEntityAlbumCount]file opt: ${JSON.stringify(fileFetchOp)}`);
            let fileResult = await albums[0].getFileAssets(fileFetchOp);
            this.logger.debug(`[getEntityAlbumCount]Get objects done`);
            let count = fileResult.getCount();
            fileResult.close();
            return count;
        } catch(err) {
            this.logger.error(`Get Entity Album count exception! msg: ${err}`);
            return 0;
        }
    }

    async getAlbums(fetchOpt) {
        this.logger.info(`getAlbums ${JSON.stringify(fetchOpt)}`);
        try {
            let albums = await this.media.getAlbums(fetchOpt);
            this.logger.debug(`[getAlbums]Get Albums done`);
            this.logger.debug(`[getAlbums]length :${albums.length}`);
            return albums;
        } catch(err) {
            this.logger.error(`Get Album exception! msg:  ${err}`);
            return [];
        }
    }

    async getFavoriteAlbum(fetchOpt) {
        this.logger.debug(`getFavoriteObject`);
        let result = {
            count: 0,
            file: undefined,
        }
        try {
            let albums = await this.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_FAVORITE);
            this.logger.debug(`[getFavoriteAlbum]Get smart Albums done`);
            this.logger.debug(`[getFavoriteAlbum]Albums length:${albums.length}`);
            if (albums.length > 0) {
                let fileResult = await albums[0].getFileAssets(fetchOpt);
                result.count = fileResult.getCount();
                this.logger.debug(`[getFavoriteAlbum]object count: ${result.count}`);
                if (result.count > 0) {
                    result.file = await fileResult.getFirstObject();
                }
                fileResult.close();
            }
            return result;
        } catch(err) {
            this.logger.error(`Get Favorite album exception! msg:  ${err}`);
            return result;
        }
    }

    async getTrashAlbum(fetchOpt) {
        this.logger.debug(`getTrashAlbum`);
        let result = {
            count: 0,
            file: undefined,
        }
        try {
            let albums = await this.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_TRASH);
            this.logger.debug(`[getTrashAlbum]Get smart Albums done`);
            this.logger.debug(`[getTrashAlbum]Albums length:${albums.length}`);
            if (albums.length > 0) {
                let fileResult = await albums[0].getFileAssets(fetchOpt);
                result.count = fileResult.getCount();
                this.logger.debug(`[getTrashAlbum]trash photo count ${result.count}`);
                if (result.count > 0) {
                    result.file = await fileResult.getFirstObject();
                }
                fileResult.close();
            }
            return result;
        } catch(err) {
            this.logger.error(`Get Trash album exception! msg:  ${err}`);
            return result;
        }
    }

    async getConnectedRemoteDevice() {
        this.logger.debug(`getConnectedRemoteDevice`);
        try {
            let result = await this.media.getActivePeers();
            this.logger.debug(`[getConnectedRemoteDevice]device count: ${result.length}`);
            return result;
        } catch(err) {
            this.logger.error(`Get Connected Remote Device exception! msg:  ${err}`);
            return[];
        }
    }
}

export class FetchOptionBuilder {
    private fetchOption = {
        selections: '',
        selectionArgs: [],
        order:''
    }

    constructor(fetchOpt?){
        if (fetchOpt){
            this.fetchOption = fetchOpt;
        }
    }

    build(): any{
        return this.fetchOption;
    }

    media(mediaType: string){
        this.fetchOption.selections = `${this.prefix(this.fetchOption.selections)}${MediaLibraryAccess.FILE_KEY_MEDIA_TYPE} =?`;
        this.fetchOption.selectionArgs.push(mediaType);
        return this;
    }

    order(key:string, isAsc = true){
        let order = isAsc ? '' : ' DESC';
        this.fetchOption.order = `${this.prefix(this.fetchOption.order)}${key}${order}`;
        return this;
    }

    select(start: number, count: number){
        this.fetchOption.order = `${this.prefix(this.fetchOption.order)}LIMIT ${start},${count}`

        return this;
    }

    device(deviceId: string){
        this.fetchOption['networkId'] = deviceId;
        return this;
    }

    fileId(id: string){
        this.fetchOption.selections = `${this.prefix(this.fetchOption.selections)}${MediaLibraryAccess.FILE_KEY_ID} =?`;
        this.fetchOption.selectionArgs.push(id);
        return this;
    }

    albumId(id: string){
        this.fetchOption.selections = `${this.prefix(this.fetchOption.selections)}${MediaLibraryAccess.FILE_KEY_ALBUM_ID} =?`;
        this.fetchOption.selectionArgs.push(id);
        return this;
    }

    relativePath(path: string){
        this.fetchOption.selections = `${this.prefix(this.fetchOption.selections)}${MediaLibraryAccess.FILE_KEY_RELATIVE_PATH} =?`;
        this.fetchOption.selectionArgs.push(path);
        return this;
    }

    albumName(name: string){
        this.fetchOption.selections = `${this.prefix(this.fetchOption.selections)}${MediaLibraryAccess.FILE_KEY_ALBUM_NAME} =?`;
        this.fetchOption.selectionArgs.push(name);
        return this;
    }

    displayName(name: string){
        this.fetchOption.selections = `${this.prefix(this.fetchOption.selections)}${MediaLibraryAccess.FILE_KEY_DISPLAY_NAME} =?`;
        this.fetchOption.selectionArgs.push(name);
        return this;
    }

    logicalAnd(){
        this.fetchOption.selections = `${this.prefix(this.fetchOption.selections)}AND`;
        return this;
    }

    logicalOr(){
        this.fetchOption.selections = `${this.prefix(this.fetchOption.selections)}OR`;
        return this;
    }

    parentheses(){
        this.fetchOption.selections = `(${this.fetchOption.selections})`
        return this;
    }

    private prefix(str: string){
        if (str.length > 0){
            return `${str} `;
        }
        return str;
    }
}