// @ts-nocheck
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
import fileIO from '@ohos.fileio';
import MediaLib from '@ohos.multimedia.mediaLibrary';
import { MediaConstants } from '../constants/MediaConstants';
import createOrGet from '../utils/SingleInstanceUtils';
import { Log } from '../utils/Log';
import { startTrace, finishTrace } from '../utils/TraceControllerUtils';
import { hiSysEventDataQueryTimedOut } from '../utils/hisysEventUtil';

const TAG = "MediaModel"

export class MediaModelItem {
    fileAsset: MediaLib.FileAsset;
    counts: number;
}

class MediaModel {
    private media: MediaLib.MediaLibrary = undefined;
    private imageDir: string = "";
    private cameraDir: string = "";

    constructor() {
    }

    onCreate(context) {
        if (this.media == undefined) {
            this.media = MediaLib.getMediaLibrary(context);
        }
    }

    getMediaLibrary(): MediaLib.MediaLibrary {
        return this.media;
    }

    async getPublicDirectory(directoryType: MediaLib.DirectoryType): Promise<string> {
        if (directoryType == MediaLib.DirectoryType.DIR_IMAGE) {
            if (this.imageDir == "" || this.imageDir == undefined) {
                let getPublicDirectoryImage = hiSysEventDataQueryTimedOut('getPublicDirectoryImage')
                this.imageDir = await this.media.getPublicDirectory(directoryType);
                clearTimeout(getPublicDirectoryImage);
                Log.debug(TAG, `imageDir ${this.imageDir}`);
            }
            Log.debug(TAG, `return imageDir ${this.imageDir}`);
            return this.imageDir;
        } else if (directoryType == MediaLib.DirectoryType.DIR_CAMERA) {
            if (this.cameraDir == "" || this.cameraDir == undefined) {
                let getPublicDirectoryCamera = hiSysEventDataQueryTimedOut('getPublicDirectoryCamera')
                this.cameraDir = await this.media.getPublicDirectory(directoryType);
                clearTimeout(getPublicDirectoryCamera);
                Log.debug(TAG, `cameraDir ${this.cameraDir}`);
            }
            Log.debug(TAG, `return cameraDir ${this.cameraDir}`);
            return this.cameraDir;
        } else {
            Log.warn(TAG, `invaild directoryType: ${directoryType}`);
            return "";
        }
    }

    async createOne(mediaType: MediaLib.MediaType, displayName: string, relativePath: string): Promise<MediaLib.FileAsset> {
        return await this.media.createAsset(mediaType, displayName, relativePath);
    }

    async copyOne(source: MediaLib.FileAsset, target: MediaLib.FileAsset) {
        Log.info(TAG, `copy start: src:${source.uri} target: ${target.uri}`);
        startTrace('openAssetR');
        let fd = await this.openAsset('R', source);
        finishTrace('openAssetR');
        if (fd <= 0) {
            throw 'fd is invalid';
            return;
        }

        startTrace('openAssetRW');
        let targetFd = await this.openAsset('RW', target);
        finishTrace('openAssetRW');
        if (targetFd <= 0) {
            throw 'targetFd is invalid';
            return;
        }

        startTrace('copyFile');
        await fileIO.copyFile(fd, targetFd);
        finishTrace('copyFile');

        startTrace('sourceClose');
        await this.closeAsset(fd, source);
        finishTrace('sourceClose');
        startTrace('targetClose');
        await this.closeAsset(targetFd, target);
        finishTrace('targetClose');

        Log.debug(TAG, 'copy end');
    }

    async deleteOne(uri: string) {
        Log.debug(TAG, `deleteAsset uri: ${uri}`);
        await this.media.deleteAsset(uri);
    }

    async deleteAll(fetchOption: MediaLib.MediaFetchOptions) {
        Log.info(TAG, 'deleteAll');
        startTrace('deleteAll');
        let fetchFileResult: MediaLib.FetchFileResult = undefined;
        try {
            fetchFileResult = await this.media.getFileAssets(fetchOption);
            Log.debug(TAG, `deleteAll getFileAssets`);
            let deleteAllGetAllObject = hiSysEventDataQueryTimedOut('deleteAllGetAllObject')
            let fileAssets: MediaLib.FileAsset[] = await fetchFileResult.getAllObject();
            clearTimeout(deleteAllGetAllObject);
            for (let i = 0;i < fileAssets.length; i++) {
                await fileAssets[i].trash(true);
            }
            Log.debug(TAG, `deleteAll getFirstObject`);
        } catch (err) {
            Log.error(TAG, `deleteAll error:${JSON.stringify(err)}`);
        } finally {
             if (fetchFileResult) {
                fetchFileResult.close();
            }
        }
        finishTrace('deleteAll');
        Log.debug(TAG, 'deleteAll finish');
    }

    async getAllMediaItems(fetchOption: MediaLib.MediaFetchOptions): Promise<Array<MediaLib.FileAsset>> {
        Log.info(TAG, 'getAllMediaItems');
        startTrace('getAllMediaItems');
        let fileAssets: Array<MediaLib.FileAsset> = [];
        let fetchFileResult: MediaLib.FetchFileResult = undefined;
        try {
            fetchFileResult = await this.media.getFileAssets(fetchOption);
            Log.debug(TAG, `getAllMediaItems getFileAssets:${fetchFileResult.getCount()}`);
            let getAllMediaItemsGetAllObject = hiSysEventDataQueryTimedOut('getAllMediaItemsGetAllObject')
            fileAssets = await fetchFileResult.getAllObject();
            clearTimeout(getAllMediaItemsGetAllObject);
            Log.debug(TAG, `getAllMediaItems getAllObject:${fileAssets.length}`);
        } catch (err) {
            Log.error(TAG, `getAllMediaItems error:${JSON.stringify(err)}`);
        }  finally {
            if (fetchFileResult) {
                fetchFileResult.close();
            }
        }
        finishTrace('getAllMediaItems');
        Log.debug(TAG, 'getAllMediaItems finish');
        return fileAssets;
    }

    async getAllFavorMediaItems(fetchOption: MediaLib.MediaFetchOptions): Promise<Array<MediaLib.FileAsset>> {
        Log.info(TAG, 'getAllFavorMediaItems');
        startTrace('getAllFavorMediaItems');
        let fileAssets: Array<MediaLib.FileAsset> = [];
        let fetchFileResult: MediaLib.FetchFileResult = undefined;
        try {
            let getPrivateAlbumGetAllFavors = hiSysEventDataQueryTimedOut('getPrivateAlbumGetAllFavors')
            let albums = await this.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_FAVORITE);
            clearTimeout(getPrivateAlbumGetAllFavors);
            if (albums.length > 0) {
                fetchFileResult = await albums[0].getFileAssets(fetchOption);
                Log.debug(TAG, `getAllFavorMediaItems getFileAssets`);
                let getAllObjectGetAllFavors = hiSysEventDataQueryTimedOut('getAllObjectGetAllFavors')
                fileAssets = await fetchFileResult.getAllObject();
                clearTimeout(getAllObjectGetAllFavors);
                Log.debug(TAG, `getAllFavorMediaItems getFirstObject`);
            }
        } catch (err) {
            Log.error(TAG, `getAllFavorMediaItems error:${JSON.stringify(err)}`);
        } finally {
            if (fetchFileResult) {
                fetchFileResult.close();
            }
        }
        finishTrace('getAllFavorMediaItems');
        Log.debug(TAG, 'getAllFavorMediaItems finish');
        return fileAssets;
    }

    async getAllTrashMediaItems(fetchOption: MediaLib.MediaFetchOptions): Promise<Array<MediaLib.FileAsset>> {
        Log.info(TAG, 'getAllTrashMediaItems');
        startTrace('getAllTrashMediaItems');
        let fileAssets: Array<MediaLib.FileAsset> = [];
        let fetchFileResult: MediaLib.FetchFileResult = undefined;
        try {
            let getPrivateAlbumGetAllTrashItems = hiSysEventDataQueryTimedOut('getPrivateAlbumGetAllTrashItems')
            let albums = await this.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_TRASH);
            clearTimeout(getPrivateAlbumGetAllTrashItems);
            if (albums.length > 0) {
                fetchFileResult = await albums[0].getFileAssets(fetchOption);
                Log.debug(TAG, `getAllTrashMediaItems getFileAssets`);
                let getAllObjectGetAllTrashItems = hiSysEventDataQueryTimedOut('getAllObjectGetAllTrashItems')
                fileAssets = await fetchFileResult.getAllObject();
                clearTimeout(getAllObjectGetAllTrashItems);
                Log.debug(TAG, `getAllTrashMediaItems getFirstObject`);
            }
        } catch (err) {
            Log.error(TAG, `getAllTrashMediaItems error:${JSON.stringify(err)}`);
        } finally {
            if (fetchFileResult) {
                fetchFileResult.close();
            }
        }
        finishTrace('getAllTrashMediaItems');
        Log.debug(TAG, 'getAllTrashMediaItems finish');
        return fileAssets;
    }

    async getAllMediaItem(albumId: string, fetchOption: MediaLib.MediaFetchOptions, isCountOnly: boolean): Promise<MediaModelItem> {
        if (albumId == MediaConstants.ALBUM_ID_FAVOR) {
            return await this.getAllFavorMediaItem(fetchOption, isCountOnly);
        } else if (albumId == MediaConstants.ALBUM_ID_RECYCLE) {
            return await this.getAllTrashMediaItem(fetchOption, isCountOnly);
        } else {
            return await this.getAllCommonMediaItem(fetchOption, isCountOnly);
        }
    }

    async getAllCommonMediaItem(fetchOption: MediaLib.MediaFetchOptions, isCountOnly: boolean): Promise<MediaModelItem> {
        Log.info(TAG, 'getAllCommonMediaItem');
        startTrace('getAllCommonMediaItem');
        let item: MediaModelItem = new MediaModelItem();
        let fetchFileResult: MediaLib.FetchFileResult = undefined;
        try {
            fetchFileResult = await this.media.getFileAssets(fetchOption);
            Log.debug(TAG, `getAllCommonMediaItem getFileAssets`);
            item.counts = await fetchFileResult.getCount();
            if (!isCountOnly && item.counts > 0) {
                let getFirstObjectGetAllCommon = hiSysEventDataQueryTimedOut('getFirstObjectGetAllCommon')
                item.fileAsset = await fetchFileResult.getFirstObject();
                clearTimeout(getFirstObjectGetAllCommon);
            }
            Log.debug(TAG, `getAllCommonMediaItem getFirstObject`);
        } catch (err) {
            Log.error(TAG, `getAllCommonMediaItem error:${JSON.stringify(err)}`);
        } finally {
            if (fetchFileResult) {
                fetchFileResult.close();
            }
        }
        finishTrace('getAllCommonMediaItem');
        Log.debug(TAG, 'getAllCommonMediaItem finish');
        return item;
    }

    async getAllFavorMediaItem(fetchOption: MediaLib.MediaFetchOptions, isCountOnly: boolean): Promise<MediaModelItem> {
        Log.info(TAG, 'getAllFavorMediaItem');
        startTrace('getAllFavorMediaItem');
        let item: MediaModelItem = new MediaModelItem();
        let fetchFileResult: MediaLib.FetchFileResult = undefined;
        try {
            let getPrivateAlbumGetAllFavorItem = hiSysEventDataQueryTimedOut('getPrivateAlbumGetAllFavorItem')
            let albums = await this.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_FAVORITE);
            clearTimeout(getPrivateAlbumGetAllFavorItem);
            if (albums.length > 0) {
                fetchFileResult = await albums[0].getFileAssets(fetchOption);
                Log.debug(TAG, `getAllFavorMediaItem getFileAssets`);
                item.counts = await fetchFileResult.getCount();
                if (!isCountOnly && item.counts > 0) {
                    let getFirstObjectGetAllFavorItem = hiSysEventDataQueryTimedOut('getFirstObjectGetAllFavorItem')
                    item.fileAsset = await fetchFileResult.getFirstObject();
                    clearTimeout(getFirstObjectGetAllFavorItem);
                }
                Log.debug(TAG, `getAllFavorMediaItem getFirstObject`);
            }
        } catch (err) {
            Log.error(TAG, `getAllFavorMediaItem error:${JSON.stringify(err)}`);
        } finally {
            if (fetchFileResult) {
                fetchFileResult.close();
            }
        }
        finishTrace('getAllFavorMediaItem');
        Log.debug(TAG, 'getAllFavorMediaItem finish');
        return item;
    }

    async getAllTrashMediaItem(fetchOption: MediaLib.MediaFetchOptions, isCountOnly: boolean): Promise<MediaModelItem> {
        Log.info(TAG, 'getAllTrashMediaItem');
        startTrace('getAllTrashMediaItem');
        let item: MediaModelItem = new MediaModelItem();
        let fetchFileResult: MediaLib.FetchFileResult = undefined;
        try {
            let getPrivateAlbumGetAllTrashItem = hiSysEventDataQueryTimedOut('getPrivateAlbumGetAllTrashItem')
            let albums = await this.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_TRASH);
            clearTimeout(getPrivateAlbumGetAllTrashItem);
            if (albums.length > 0) {
                fetchFileResult = await albums[0].getFileAssets(fetchOption);
                Log.debug(TAG, `getAllTrashMediaItem getFileAssets`);
                item.counts = await fetchFileResult.getCount();
                if (!isCountOnly && item.counts > 0) {
                    let getFirstObjectGetAllTrashItem = hiSysEventDataQueryTimedOut('getFirstObjectGetAllTrashItem')
                    item.fileAsset = await fetchFileResult.getFirstObject();
                    clearTimeout(getFirstObjectGetAllTrashItem);
                }
                Log.debug(TAG, `getAllTrashMediaItem getFirstObject`);
            }
        } catch (err) {
            Log.error(TAG, `getAllTrashMediaItem error:${JSON.stringify(err)}`);
        } finally {
            if (fetchFileResult) {
                fetchFileResult.close();
            }
        }
        finishTrace('getAllTrashMediaItem');
        Log.debug(TAG, 'getAllTrashMediaItem finish');
        return item
    }

    async getAlbumCount(fetchOption: MediaLib.MediaFetchOptions): Promise<number> {
        Log.info(TAG, 'getAlbumCount');
        startTrace('getAlbumCount');
        let count = 0;
        let fetchFileResult: MediaLib.FetchFileResult = undefined;
        try {
            let getAlbumsGetAlbumCount = hiSysEventDataQueryTimedOut('getAlbumsGetAlbumCount')
            let albums: Array<MediaLib.Album> = await this.media.getAlbums(fetchOption);
            clearTimeout(getAlbumsGetAlbumCount);
            if (albums.length == 0) {
                return count;
            }
            fetchFileResult = await albums[0].getFileAssets();
            count = fetchFileResult.getCount();
        } catch (err) {
            Log.error(TAG, `getAlbumCount error:${JSON.stringify(err)}`);
        } finally {
            if (fetchFileResult) {
                fetchFileResult.close();
            }
        }
        finishTrace('getAlbumCount');
        Log.debug(TAG, 'getAlbumCount finish');
        return count;
    }

    async getActivePeers(): Promise<Array<MediaLib.PeerInfo>> {
        Log.info(TAG, 'getActivePeers');
        startTrace('getActivePeers');
        let peers: Array<MediaLib.PeerInfo> = undefined;
        try {
            let getActivePeers = hiSysEventDataQueryTimedOut('getActivePeers')
            peers = await this.media.getActivePeers();
            clearTimeout(getActivePeers);
        } catch (err) {
            Log.error(TAG, `getActivePeers error:${JSON.stringify(err)}`);
        }
        finishTrace('getActivePeers');
        Log.debug(TAG, 'getActivePeers finish');
        return peers;
    }

    async getAlbums(fetchOption: MediaLib.MediaFetchOptions): Promise<Array<MediaLib.Album>> {
        Log.info(TAG, 'getAlbums');
        startTrace('getAlbums');
        let albums: Array<MediaLib.Album> = undefined;
        try {
            let getAlbums = hiSysEventDataQueryTimedOut('getAlbums')
            albums = await this.media.getAlbums(fetchOption);
            clearTimeout(getAlbums);
            Log.info(TAG, `getAlbums albums ${albums.length}`);
        } catch (err) {
            Log.error(TAG, `getAlbums error:${JSON.stringify(err)}`);
        }
        finishTrace('getAlbums');
        Log.debug(TAG, 'getAlbums finish');
        return albums;
    }

    async getTrashMedia(fetchOption: MediaLib.MediaFetchOptions): Promise<MediaLib.FileAsset> {
        Log.info(TAG, 'getTrashMedia');
        startTrace('getTrashMedia');
        let fileAsset: MediaLib.FileAsset = undefined;
        let fetchFileResult: MediaLib.FetchFileResult = undefined;
        try {
            let getPrivateAlbumGetTrash = hiSysEventDataQueryTimedOut('getPrivateAlbumGetTrash')
            let albums = await this.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_TRASH);
            clearTimeout(getPrivateAlbumGetTrash);
            if (albums.length > 0) {
                fetchFileResult = await albums[0].getFileAssets(fetchOption);
                Log.debug(TAG, `getTrashMedia getFileAssets`);
                if (fetchFileResult.getCount() > 0) {
                    let getFirstObjectGetTrash = hiSysEventDataQueryTimedOut('getFirstObjectGetTrash')
                    fileAsset = await fetchFileResult.getFirstObject();
                    clearTimeout(getFirstObjectGetTrash);
                }
                Log.debug(TAG, `getTrashMedia getFirstObject`);
            }
        } catch (err) {
            Log.error(TAG, `getTrashMedia error:${JSON.stringify(err)}`);
        } finally {
            if (fetchFileResult) {
                fetchFileResult.close();
            }
        }
        finishTrace('getTrashMedia');
        Log.debug(TAG, 'getTrashMedia finish');
        return fileAsset;
    }

    async openAsset(mode: string, fileAsset: MediaLib.FileAsset) {
        Log.debug(TAG, 'openAsset start');
        let fd: number = await fileAsset.open(mode);
        Log.info(TAG, `openAsset end. fd: ${fd}`);
        if (fd <= 0) {
            Log.info(TAG, 'openAsset Fail');
        }
        return fd;
    }

    async closeAsset(fd: number, fileAsset: MediaLib.FileAsset) {
        Log.debug(TAG, 'closeAsset start');
        await fileAsset.close(fd);
    }
}

let mediaModel = createOrGet(MediaModel, TAG);

export default mediaModel as MediaModel;