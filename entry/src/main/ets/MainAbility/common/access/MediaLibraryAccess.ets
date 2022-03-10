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
import {AlbumInfo} from '../model/browser/album/AlbumInfo.ets';

export class MediaLibraryAccess {
    static logger: Logger = new Logger('MediaLibraryAccess');

    static readonly MEDIA_TYPE_IMAGE = MediaLib.MediaType.IMAGE;
    static readonly MEDIA_TYPE_VIDEO = MediaLib.MediaType.VIDEO;

    static readonly DIRECTORY_TYPE_IMAGE = MediaLib.DirectoryType.DIR_IMAGE;
    static readonly DIRECTORY_TYPE_VIDEO = MediaLib.DirectoryType.DIR_VIDEO;

    static readonly FILE_KEY_ID = MediaLib.FileKey.ID;
    static readonly FILE_KEY_MEDIA_TYPE = MediaLib.FileKey.MEDIA_TYPE;
    static readonly FILE_KEY_ALBUM_NAME = MediaLib.FileKey.ALBUM_NAME;

    private static media = null;

    static onCreate() {
        this.logger.debug(`Photos_MediaLibraryAccess onCreate ${globalThis.photosAbilityContext}`);
        MediaLibraryAccess.media = MediaLib.getMediaLibrary(globalThis.photosAbilityContext);
        this.logger.debug('Photos_MediaLibraryAccess onCreate end');
        if (MediaLibraryAccess.media == null || MediaLibraryAccess.media == undefined) {
            this.logger.error('get media library instance failed!');
        }
        this.logger.info('onCreate done');
    }

    static onDestroy(){
        MediaLibraryAccess.media.release();
        this.logger.info('onDestroy done');
    }

    static getMediaLibrary() {
        return MediaLibraryAccess.media;
    }

    static PUBLIC_PATH_IMAGE = '';
    static PUBLIC_PATH_VIDEO = '';

    static async getAllObject(fetchOpt) {
        this.logger.debug(`getAllObject: ${JSON.stringify(fetchOpt)}`);
        try {
            let dataList = await MediaLibraryAccess.media.getFileAssets(fetchOpt);
            if (dataList == null) {
                this.logger.warn('get all Object Data with empty dataList');
                return [];
            }
            this.logger.debug(`get all Object Data raw data size: ${dataList.getCount()}`);
            if (dataList.getCount() <= 0) {
                return [];
            }
            return await dataList.getAllObject();
        } catch (error) {
            this.logger.error(`getAllObject error: ${error}`);
            return null;
        }
    }

    static async getCount(fetchOpt) {
        this.logger.debug(`getCount: ${JSON.stringify(fetchOpt)}`);
        try {
            let dataList = await MediaLibraryAccess.media.getFileAssets(fetchOpt);
            if (dataList == null) {
                this.logger.warn('get count dataList is 0');
                return 0;
            }
            this.logger.debug(`get count raw data size: ${dataList.getCount()}`);
            return dataList.getCount();
        } catch (error) {
            this.logger.error(`get Count error:  ${error}`);
            return 0;
        }
    }

    static async getFirstObject(fetchOpt) {
        let result = {
            count: 0,
            obj: null,
        }
        this.logger.debug(`getFirstObject: ${JSON.stringify(fetchOpt)}`);
        try {
            let fileResult = await MediaLibraryAccess.media.getFileAssets(fetchOpt);
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
            }
            return result;
        } catch (error) {
            this.logger.error(`getFirstObject loadData error: ${error}`);
            return result;
        }
    }

    static deleteAsset(uri: string, callback): void {
        if (uri == null) {
            this.logger.error('deleteAsset with empty uris');
            return;
        }
        this.logger.debug(`deleteAsset uri: ${uri}`);
        MediaLibraryAccess.media.deleteAsset(uri, (err) => {
            this.logger.debug('deleteAsset end');
            if (err) {
                this.logger.error(`deleteAsset error: ${err}`);
                if (callback != null) {
                    callback.onError();
                }
                return;
            }
            this.logger.debug(`deleteAsset end`);
            if (callback != null) {
                callback.onCompleted();
            }
        });
    }

    static async getPublicDirectory() {
        MediaLibraryAccess.PUBLIC_PATH_IMAGE =
            await MediaLibraryAccess.media.getPublicDirectory(MediaLibraryAccess.DIRECTORY_TYPE_IMAGE);
        MediaLibraryAccess.PUBLIC_PATH_VIDEO =
            await MediaLibraryAccess.media.getPublicDirectory(MediaLibraryAccess.DIRECTORY_TYPE_VIDEO);
    }

    static async createAsset(mediaType: any, displayName: string, relativePath: string) {
        this.logger.info('createAsset start');
        if (relativePath == null || relativePath == undefined) {
            this.logger.error('createAsset with empty relativePath');
            return null;
        }
        this.logger.info(`createAsset start ${mediaType} ${displayName} ${relativePath}`);
        let fileAsset = await MediaLibraryAccess.media.createAsset(mediaType, displayName, relativePath);
        this.logger.info(`createAsset end. new fileAsset: ${fileAsset}`);
        if (fileAsset == null || fileAsset == undefined) {
            this.logger.error('createAsset Fail');
            return null;
        }
        return fileAsset;
    }

    static async openAsset(mode: string, fileAsset: any) {
        this.logger.info('openAsset start');
        let fd = await fileAsset.open(mode);
        this.logger.info(`openAsset end. fd: ${fd}`);
        if (fd <= 0) {
            this.logger.error('openAsset Fail');
            return;
        }
        return fd;
    }

    static async closeAsset(fd: number, fileAsset: any) {
        this.logger.info('closeAsset start');
        if (fd <= 0) {
            this.logger.error('closeAsset fd is invalid');
            return;
        }
        try {
            await fileAsset.close(fd);
            this.logger.info('closeAsset end');
        } catch(error) {
            this.logger.info(`closeAsset fail mag: ${error}, code: ${JSON.stringify(error)}`);
        }
    }

    static async trashAsset(isTrash: boolean, fileAsset: any) {
        this.logger.info('trashAsset start');
        try {
            await fileAsset.trash(isTrash);
            this.logger.info('trashAsset end');
        } catch(error) {
            this.logger.info(`trashAsset fail ${error}`);
        }
    }

    static async getFavoriteObject(fetchOpt) {
        this.logger.debug(`getFavoriteObject: ${JSON.stringify(fetchOpt)}`);
        try {
            let albums = await MediaLibraryAccess.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_FAVORITE);
            this.logger.debug(`Get smart Albums length:${albums.length} name:${albums[0].albumName}`);
            let fileResult = await albums[0].getFileAssets(fetchOpt);
            this.logger.debug(`object count :${fileResult.getCount()}`);
            let objects = await fileResult.getAllObject();
            this.logger.debug(`Get objects done`);
            return objects;
        } catch(err) {
            this.logger.error(`Get Favorite Object exception! msg:  ${err}`);
            return [];
        }
    }

    static async getTrashObject(fetchOpt) {
        this.logger.debug(`getTrashObject: ${JSON.stringify(fetchOpt)}`);
        try {
            let albums = await MediaLibraryAccess.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_TRASH);
            this.logger.debug(`Get smart Albums length:${albums.length} name:${albums[0].albumName}`);
            let fileResult = await albums[0].getFileAssets(fetchOpt);
            this.logger.debug(`object count :${fileResult.getCount()}`);
            let objects = await fileResult.getAllObject();
            this.logger.debug(`Get objects done`);
            return objects;
        } catch(err) {
            this.logger.error(`Get Trash Object exception! msg: ${err}`);
            return [];
        }
    }

    static async getEntityAlbumObject(fetchOpt, fileFetchOpt) {
        this.logger.debug(`getEntityAlbumObject opt${JSON.stringify(fetchOpt)} fileOpt${JSON.stringify(fileFetchOpt)}`);
        try {
            let albums = await MediaLibraryAccess.media.getAlbums(fetchOpt);
            this.logger.debug(`Get Albums done`);
            this.logger.debug(`Album length:${albums.length}`);
            if (albums.length == 0) {
                return null;
            }
            this.logger.debug(`Albums name:${albums[0].albumName}`);
            let fileResult = await albums[0].getFileAssets(fileFetchOpt);
            this.logger.debug(`objects count :${fileResult.getCount()}`);
            if (fileResult.getCount() == 0) {
                return null
            }
            let objects = await fileResult.getAllObject();
            this.logger.debug(`Get objects done`);
            return objects;
        } catch(err) {
            this.logger.error(`Get Entity Album Object exception! msg:  ${err}`);
            return []
        }
    }

    static async getFavoriteCount() {
        this.logger.debug(`getFavoriteCount`);
        let fetchOpt = {
            selections: '',
            selectionArgs: [],
            order: ''
        }
        try {
            let albums = await MediaLibraryAccess.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_FAVORITE);
            this.logger.debug(`Get smart Albums length:${albums.length} name:${albums[0].albumName}`);
            let fileResult = await albums[0].getFileAssets(fetchOpt);
            this.logger.debug(`Get objects done`);
            let count = fileResult.getCount();
            return count;
        } catch(err) {
            this.logger.error(`Get Favorite count exception! msg:  ${err}`);
            return 0;
        }
    }

    static async getTrashCount() {
        this.logger.debug(`getTrashCount`);
        let fetchOpt = {
            selections: '',
            selectionArgs: [],
            order: ''
        }
        try {
              let albums = await MediaLibraryAccess.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_TRASH);
              this.logger.debug(`Get smart Albums length:${albums.length} name:${albums[0].albumName}`);
              let fileResult = await albums[0].getFileAssets(fetchOpt);
              this.logger.debug(`Get objects done`);
              let count = fileResult.getCount();
              return count;
        } catch(err) {
            this.logger.error(`Get Trash count exception! msg: ${err}`);
            return 0;
        }
    }

    static async getEntityAlbumCount(fetchOpt, fileFetchOpt?) {
        this.logger.debug(`getEntityAlbumCount opt: ${JSON.stringify(fetchOpt)}`);
        try {
            let albums = await MediaLibraryAccess.media.getAlbums(fetchOpt);
            this.logger.debug(`Get smart Albums length:${albums.length} name:${albums[0].albumName}`);
            let fileFetchOp;
            if (fileFetchOpt == undefined) {
                fileFetchOp = {
                    selections: '',
                    selectionArgs: []
                }
            } else {
                fileFetchOp = fileFetchOpt;
            }
            this.logger.debug(`file opt: ${JSON.stringify(fileFetchOp)}`);
            let fileResult = await albums[0].getFileAssets(fileFetchOp);
            this.logger.debug(`Get objects done`);
            let count = fileResult.getCount();
            return count;
        } catch(err) {
            this.logger.error(`Get Entity Album count exception! msg: ${err}`);
            return 0;
        }
    }

    static async getAlbums(fetchOpt) {
        this.logger.debug(`getAlbums ${JSON.stringify(fetchOpt)}`);
        try {
            let albums = await MediaLibraryAccess.media.getAlbums(fetchOpt);
            this.logger.debug(`Get Albums done`);
            this.logger.debug(`length :${albums.length}`);
            return albums;
        } catch(err) {
            this.logger.error(`Get Album exception! msg:  ${err}`);
            return [];
        }
    }

    static async getFavoriteAlbum() {
        this.logger.debug(`getFavoriteObject`);
        try {
            let albums = await MediaLibraryAccess.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_FAVORITE);
            this.logger.debug(`Get smart Albums done`);
            this.logger.debug(`Albums length:${albums.length}`);
            return albums.length == 0 ? undefined : albums[0];
        } catch(err) {
            this.logger.error(`Get Favorite album exception! msg:  ${err}`);
            return null;
        }
    }

    static async getTrashAlbum() {
        this.logger.debug(`getTrashAlbum`);
        try {
            let albums = await MediaLibraryAccess.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_TRASH);
            this.logger.debug(`Get smart Albums done`);
            this.logger.debug(`Albums length:${albums.length}`);
            return albums[0];
        } catch(err) {
            this.logger.error(`Get Trash album exception! msg:  ${err}`);
            return null;
        }
    }

    static async getConnectedRemoteDevice() {
        this.logger.debug(`getConnectedRemoteDevice`);
        try {
            let result = await MediaLibraryAccess.media.getActivePeers();
            this.logger.debug(`device count: ${result.length}`);
            return result;
        } catch(err) {
            this.logger.error(`Get Connected Remote Device exception! msg:  ${err}`);
            return[];
        }
    }
}