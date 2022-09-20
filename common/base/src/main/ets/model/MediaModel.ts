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
import { MediaConstants } from '../constants/MediaConstants'
import createOrGet from '../utils/SingleInstanceUtils';
import { logDebug, logInfo, logWarn, logError } from '../utils/LoggerUtils'
import { startTrace, finishTrace } from '../utils/TraceControllerUtils'

const TAG = "MediaModel"

export class MediaModelItem {
    fileAsset: MediaLib.FileAsset
    counts: number
}

class MediaModel {
    private media: MediaLib.MediaLibrary = undefined
    private imageDir: string = ""
    private cameraDir: string = ""

    constructor() {
    }

    onCreate(context) {
        if (this.media == undefined) {
            this.media = MediaLib.getMediaLibrary(context)
        }
    }

    getMediaLibrary(): MediaLib.MediaLibrary{
        return this.media
    }

    async getPublicDirectory(directoryType: MediaLib.DirectoryType): Promise<string> {
        if (directoryType == MediaLib.DirectoryType.DIR_IMAGE) {
            if (this.imageDir == "" || this.imageDir == undefined) {
                this.imageDir = await this.media.getPublicDirectory(directoryType)
                logDebug(TAG, `imageDir ${this.imageDir}`)
            }
            logDebug(TAG, `return imageDir ${this.imageDir}`)
            return this.imageDir
        } else if (directoryType == MediaLib.DirectoryType.DIR_CAMERA) {
            if (this.cameraDir == "" || this.cameraDir == undefined) {
                this.cameraDir = await this.media.getPublicDirectory(directoryType)
                logDebug(TAG, `cameraDir ${this.cameraDir}`)
            }
            logDebug(TAG, `return cameraDir ${this.cameraDir}`)
            return this.cameraDir
        } else {
            logWarn(TAG, `invaild directoryType: ${directoryType}`)
            return ""
        }
    }

    async createOne(mediaType: MediaLib.MediaType, displayName: string, relativePath: string): Promise<MediaLib.FileAsset> {
        return await this.media.createAsset(mediaType, displayName, relativePath)
    }

    async copyOne(source: MediaLib.FileAsset, target: MediaLib.FileAsset) {
        logInfo(TAG, `copy start: src:${source.uri} target: ${target.uri}`);
        startTrace('openAssetR')
        let fd = await this.openAsset('R', source);
        finishTrace('openAssetR')
        if (fd <= 0) {
            throw 'fd is invalid'
            return;
        }

        startTrace('openAssetRW')
        let targetFd = await this.openAsset('RW', target);
        finishTrace('openAssetRW')
        if (targetFd <= 0) {
            throw 'targetFd is invalid'
            return;
        }

        startTrace('copyFile')
        await fileIO.copyFile(fd, targetFd)
        finishTrace('copyFile')

        startTrace('sourceClose')
        await this.closeAsset(fd, source)
        finishTrace('sourceClose')
        startTrace('targetClose')
        await this.closeAsset(targetFd, target)
        finishTrace('targetClose')

        logDebug(TAG, 'copy end')
    }

    async deleteOne(uri: string) {
        logDebug(TAG, `deleteAsset uri: ${uri}`);
        await this.media.deleteAsset(uri);
    }

    async deleteAll(fetchOption: MediaLib.MediaFetchOptions) {
        logInfo(TAG, 'deleteAll');
        startTrace('deleteAll')
        try {
            let fetchFileResult: MediaLib.FetchFileResult = await this.media.getFileAssets(fetchOption);
            logDebug(TAG, `deleteAll getFileAssets`);
            let fileAssets: MediaLib.FileAsset[] = await fetchFileResult.getAllObject();
            for (let i = 0;i < fileAssets.length; i++) {
                await fileAssets[i].trash(true)
            }
            logDebug(TAG, `deleteAll getFirstObject`);
            fetchFileResult.close()
        } catch (err) {
            logError(TAG, `deleteAll error:${JSON.stringify(err)}`);
        }
        finishTrace('deleteAll')
        logDebug(TAG, 'deleteAll finish');
    }

    async getAllMediaItems(fetchOption: MediaLib.MediaFetchOptions): Promise<Array<MediaLib.FileAsset>> {
        logInfo(TAG, 'getAllMediaItems');
        startTrace('getAllMediaItems')
        let fileAssets: Array<MediaLib.FileAsset> = []
        try {
            let fetchFileResult: MediaLib.FetchFileResult = await this.media.getFileAssets(fetchOption);
            logDebug(TAG, `getAllMediaItems getFileAssets:${fetchFileResult.getCount()}`);
            fileAssets = await fetchFileResult.getAllObject();
            logDebug(TAG, `getAllMediaItems getAllObject:${fileAssets.length}`);
            fetchFileResult.close()
        } catch (err) {
            logError(TAG, `getAllMediaItems error:${JSON.stringify(err)}`);
        }
        finishTrace('getAllMediaItems')
        logDebug(TAG, 'getAllMediaItems finish');
        return fileAssets
    }

    async getAllFavorMediaItems(fetchOption: MediaLib.MediaFetchOptions): Promise<Array<MediaLib.FileAsset>> {
        logInfo(TAG, 'getAllFavorMediaItems');
        startTrace('getAllFavorMediaItems')
        let fileAssets: Array<MediaLib.FileAsset> = []
        try {
            let albums = await this.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_FAVORITE);
            if (albums.length > 0) {
                let fetchFileResult: MediaLib.FetchFileResult = await albums[0].getFileAssets(fetchOption);
                logDebug(TAG, `getAllFavorMediaItems getFileAssets`);
                fileAssets = await fetchFileResult.getAllObject();
                logDebug(TAG, `getAllFavorMediaItems getFirstObject`);
                fetchFileResult.close()
            }
            fetchFileResult.close()
        } catch (err) {
            logError(TAG, `getAllFavorMediaItems error:${JSON.stringify(err)}`);
        }
        finishTrace('getAllFavorMediaItems')
        logDebug(TAG, 'getAllFavorMediaItems finish');
        return fileAssets
    }

    async getAllTrashMediaItems(fetchOption: MediaLib.MediaFetchOptions): Promise<Array<MediaLib.FileAsset>> {
        logInfo(TAG, 'getAllTrashMediaItems');
        startTrace('getAllTrashMediaItems')
        let fileAssets: Array<MediaLib.FileAsset> = []
        try {
            let albums = await this.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_TRASH);
            if (albums.length > 0) {
                let fetchFileResult: MediaLib.FetchFileResult = await albums[0].getFileAssets(fetchOption);
                logDebug(TAG, `getAllTrashMediaItems getFileAssets`);
                fileAssets = await fetchFileResult.getAllObject();
                logDebug(TAG, `getAllTrashMediaItems getFirstObject`);
                fetchFileResult.close()
            }
            fetchFileResult.close()
        } catch (err) {
            logError(TAG, `getAllTrashMediaItems error:${JSON.stringify(err)}`);
        }
        finishTrace('getAllTrashMediaItems')
        logDebug(TAG, 'getAllTrashMediaItems finish');
        return fileAssets
    }

    async getAllMediaItem(albumId: string, fetchOption: MediaLib.MediaFetchOptions, isCountOnly: boolean): Promise<MediaModelItem> {
        if (albumId == MediaConstants.ALBUM_ID_FAVOR) {
            return await this.getAllFavorMediaItem(fetchOption, isCountOnly)
        } else if (albumId == MediaConstants.ALBUM_ID_RECYCLE) {
            return await this.getAllTrashMediaItem(fetchOption, isCountOnly)
        } else {
            return await this.getAllCommonMediaItem(fetchOption, isCountOnly)
        }
    }

    async getAllCommonMediaItem(fetchOption: MediaLib.MediaFetchOptions, isCountOnly: boolean): Promise<MediaModelItem> {
        logInfo(TAG, 'getAllCommonMediaItem');
        startTrace('getAllCommonMediaItem')
        let item: MediaModelItem = new MediaModelItem()
        try {
            let fetchFileResult: MediaLib.FetchFileResult = await this.media.getFileAssets(fetchOption);
            logDebug(TAG, `getAllCommonMediaItem getFileAssets`);
            item.counts = await fetchFileResult.getCount();
            if (!isCountOnly && item.counts > 0) {
                item.fileAsset = await fetchFileResult.getFirstObject()
            }
            logDebug(TAG, `getAllCommonMediaItem getFirstObject`);
            fetchFileResult.close()
        } catch (err) {
            logError(TAG, `getAllCommonMediaItem error:${JSON.stringify(err)}`);
        }
        finishTrace('getAllCommonMediaItem')
        logDebug(TAG, 'getAllCommonMediaItem finish');
        return item
    }

    async getAllFavorMediaItem(fetchOption: MediaLib.MediaFetchOptions, isCountOnly: boolean): Promise<MediaModelItem> {
        logInfo(TAG, 'getAllFavorMediaItem');
        startTrace('getAllFavorMediaItem')
        let item: MediaModelItem = new MediaModelItem()
        try {
            let albums = await this.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_FAVORITE);
            if (albums.length > 0) {
                let fetchFileResult: MediaLib.FetchFileResult = await albums[0].getFileAssets(fetchOption);
                logDebug(TAG, `getAllFavorMediaItem getFileAssets`);
                item.counts = await fetchFileResult.getCount();
                if (!isCountOnly && item.counts > 0) {
                    item.fileAsset = await fetchFileResult.getFirstObject()
                }
                logDebug(TAG, `getAllFavorMediaItem getFirstObject`);
                fetchFileResult.close()
            }
        } catch (err) {
            logError(TAG, `getAllFavorMediaItem error:${JSON.stringify(err)}`);
        }
        finishTrace('getAllFavorMediaItem')
        logDebug(TAG, 'getAllFavorMediaItem finish');
        return item
    }

    async getAllTrashMediaItem(fetchOption: MediaLib.MediaFetchOptions, isCountOnly: boolean): Promise<MediaModelItem> {
        logInfo(TAG, 'getAllTrashMediaItem');
        startTrace('getAllTrashMediaItem')
        let item: MediaModelItem = new MediaModelItem()
        try {
            let albums = await this.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_TRASH);
            if (albums.length > 0) {
                let fetchFileResult: MediaLib.FetchFileResult = await albums[0].getFileAssets(fetchOption);
                logDebug(TAG, `getAllTrashMediaItem getFileAssets`);
                item.counts = await fetchFileResult.getCount();
                if (!isCountOnly && item.counts > 0) {
                    item.fileAsset = await fetchFileResult.getFirstObject()
                }
                logDebug(TAG, `getAllTrashMediaItem getFirstObject`);
                fetchFileResult.close()
            }
        } catch (err) {
            logError(TAG, `getAllTrashMediaItem error:${JSON.stringify(err)}`);
        }
        finishTrace('getAllTrashMediaItem')
        logDebug(TAG, 'getAllTrashMediaItem finish');
        return item
    }

    async getAlbumCount(fetchOption: MediaLib.MediaFetchOptions): Promise<number> {
        logInfo(TAG, 'getAlbumCount');
        startTrace('getAlbumCount')
        let count = 0
        try {
            let albums: Array<MediaLib.Album> = await this.media.getAlbums(fetchOption);
            if (albums.length == 0) {
                return count
            }
            let fetchFileResult: MediaLib.FetchFileResult = await albums[0].getFileAssets()
            count = fetchFileResult.getCount()
            fetchFileResult.close()
        } catch (err) {
            logError(TAG, `getAlbumCount error:${JSON.stringify(err)}`);
        }
        finishTrace('getAlbumCount')
        logDebug(TAG, 'getAlbumCount finish');
        return count
    }

    async getActivePeers(): Promise<Array<MediaLib.PeerInfo>> {
        logInfo(TAG, 'getActivePeers');
        startTrace('getActivePeers')
        let peers: Array<MediaLib.PeerInfo> = undefined
        try {
            peers = await this.media.getActivePeers();
        } catch (err) {
            logError(TAG, `getActivePeers error:${JSON.stringify(err)}`);
        }
        finishTrace('getActivePeers')
        logDebug(TAG, 'getActivePeers finish');
        return peers
    }

    async getAlbums(fetchOption: MediaLib.MediaFetchOptions): Promise<Array<MediaLib.Album>> {
        logInfo(TAG, 'getAlbums');
        startTrace('getAlbums')
        let albums: Array<MediaLib.Album> = undefined
        try {
            albums = await this.media.getAlbums(fetchOption);
            logInfo(TAG, `getAlbums albums ${albums.length}`)
        } catch (err) {
            logError(TAG, `getAlbums error:${JSON.stringify(err)}`);
        }
        finishTrace('getAlbums')
        logDebug(TAG, 'getAlbums finish');
        return albums
    }

    async getTrashMedia(fetchOption: MediaLib.MediaFetchOptions): Promise<MediaLib.FileAsset> {
        logInfo(TAG, 'getTrashMedia');
        startTrace('getTrashMedia')
        let fileAsset: MediaLib.FileAsset = undefined
        try {
            let albums = await this.media.getPrivateAlbum(MediaLib.PrivateAlbumType.TYPE_TRASH);
            if (albums.length > 0) {
                let fetchFileResult: MediaLib.FetchFileResult = await albums[0].getFileAssets(fetchOption);
                logDebug(TAG, `getTrashMedia getFileAssets`);
                if (fetchFileResult.getCount() > 0) {
                    fileAsset = await fetchFileResult.getFirstObject();
                }
                logDebug(TAG, `getTrashMedia getFirstObject`);
                fetchFileResult.close()
            }
        } catch (err) {
            logError(TAG, `getTrashMedia error:${JSON.stringify(err)}`);
        }
        finishTrace('getTrashMedia')
        logDebug(TAG, 'getTrashMedia finish');
        return fileAsset
    }

    async openAsset(mode: string, fileAsset: MediaLib.FileAsset) {
        logDebug(TAG, 'openAsset start');
        let fd: number = await fileAsset.open(mode);
        logInfo(TAG, `openAsset end. fd: ${fd}`);
        if (fd <= 0) {
            logInfo(TAG, 'openAsset Fail');
        }
        return fd;
    }

    async closeAsset(fd: number, fileAsset: MediaLib.FileAsset) {
        logDebug(TAG, 'closeAsset start');
        await fileAsset.close(fd);
    }
}

let mediaModel = createOrGet(MediaModel, TAG);

export default mediaModel as MediaModel;