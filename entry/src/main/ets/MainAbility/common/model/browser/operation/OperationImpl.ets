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
import {BrowserOperationInterface} from '../interface/BrowserOperationInterface'
import {Logger} from '../../../utils/Logger.ets'
import {MediaLibraryAccess} from '../../../access/MediaLibraryAccess.ets';
import fileio from '@ohos.fileio';
import {AlbumDefine} from '../AlbumDefine.ets'

export class OperationImpl implements BrowserOperationInterface {
    logger: Logger = new Logger('OperationImpl');

    async favor(id, isFavor) {
        this.logger.info('favor');
        try {
            let fileAsset = await this.getFileAssetById(id);
            fileAsset.favorite(isFavor);
            return true;
        } catch(e) {
            this.logger.info(`favor error ${e}`);
            return false;
        }
    }

    delete(uri: string, callback): void {
        if (uri == null) {
            this.logger.error('requestDelete with empty uri');
            return;
        }
        this.logger.debug(`requestDelete uri: ${uri}`);
        MediaLibraryAccess.deleteAsset(uri, callback);
    }

    async move(uri: string, albumName: string, callback, isReplace: boolean, replaceUri?: string) {
        this.logger.info('move start');
        let lastIndex = uri.lastIndexOf('/');
        let id = uri.substring(lastIndex + 1, uri.length);
        let fileAsset = await this.getFileAssetById(id);

        if (isReplace) {
            let delCallback = {
                onCompleted: () => {
                    this.logger.info('delete completed');
                    let path = this.getPathByMediaTypeAndAlbumName(AlbumDefine.getAlbumPath(albumName));
                    fileAsset.relativePath = path;
                    this.logger.info(`move commitModify start ${path}`);
                    fileAsset.commitModify().then(() => {
                        this.logger.info('move get result finish');
                        callback && callback.onCompleted();
                    }).catch((err) => {
                        this.logger.error(`move replace error msg: ${err}`);
                    });
                },
                onError: () => {
                    this.logger.error('move replace error');
                    callback && callback.onError();
                },
            };

            MediaLibraryAccess.deleteAsset(replaceUri, delCallback);
        } else {
            let path = this.getPathByMediaTypeAndAlbumName(AlbumDefine.getAlbumPath(albumName));
            fileAsset.relativePath = path;
            this.logger.debug(`move commitModify start ${path}`);
            try {
                await fileAsset.commitModify();
                this.logger.info('move get result');
                callback && callback.onCompleted();
            } catch(err) {
                this.logger.error(`move error msg: ${err}`);
                callback && callback.onError();
            }
        }
    }

    getPathByMediaTypeAndAlbumName(albumName: string): string {
        let path = '';
        let publicPath = '';
        publicPath = `${MediaLibraryAccess.PUBLIC_PATH_IMAGE}`
        if (albumName != '') {
          path = `${publicPath}${albumName}/`
        }
        this.logger.info(`getPathByMediaTypeAndAlbumName path: ${path}`);
        return path;
    }

    async getExistTargetInTargetAlbum(uri: string, albumName: string, deviceId?) {
        this.logger.debug('isExistInTargetAlbum start');
        let numId = this.getIdByUri(uri)
        let fileAsset = await this.getFileAssetById(numId, deviceId);
        let targetAsset = await this.getFileAsset(fileAsset, albumName);
        if (targetAsset == null || targetAsset == undefined) {
            this.logger.debug('targetAsset is null');
            return null;
        }
        this.logger.debug('isExistInTargetAlbum true');
        return {fileAsset: fileAsset, targetAsset: targetAsset};
    }

    async hasSameNameAsset(numId: number, name: string) {
        this.logger.debug('isExistInTargetAlbum start');
        let fileAsset = await this.getFileAssetById(numId);
        let displayName = fileAsset.displayName;
        let index = displayName.lastIndexOf('.');
        displayName = name + displayName.slice(index);
        let targetAsset;
        let fileAssetList = await MediaLibraryAccess.getAllObject(AlbumDefine.getFileFetchOptByName(displayName));
        this.logger.debug(`isExistInTargetAlbum fileAssetList count: ${fileAssetList.length}`);
        for (let item of fileAssetList) {
            if (fileAsset.relativePath == item.relativePath) {
                this.logger.debug(`isExistInTargetAlbum has same name`);
                targetAsset = item;
                break;
            }
        }
        if (targetAsset == null || targetAsset == undefined) {
            this.logger.debug('targetAsset is null');
            return false;
        }
        this.logger.debug('isExistInTargetAlbum true');
        return true;
    }

    async getFileAsset(fileAsset: any, albumName: string)  {
        this.logger.debug('getFileAsset start');

        let dataList = await MediaLibraryAccess.getEntityAlbumObject(AlbumDefine.getAlbumFetchOpt(albumName),
            AlbumDefine.getFileFetchOptByName(fileAsset.displayName));
        if (dataList != null) {
            if (dataList.length > 0) {
                return dataList[0];
            } else {
                this.logger.info('fileAsset is null');
                return null;
            }
        }
        this.logger.debug('getFileAsset end');
        return null;
    }

    async getTargetFileAsset(fileAsset: any, albumName: string, isReplace: boolean, hasSame?: boolean) {
       this.logger.debug(`getTargetFileAsset start isReplace ${isReplace}`);
       if (isReplace) {
            return await this.getFileAsset(fileAsset, albumName);
       } else {
           let showPath = this.getPathByMediaTypeAndAlbumName(AlbumDefine.getAlbumPath(albumName));
           let displayName = fileAsset.displayName;
           let index = displayName.lastIndexOf('.');
           displayName = `${displayName.slice(0, index)}${new Date().getTime()}${displayName.slice(index)}`;
           let targetAsset = await MediaLibraryAccess.createAsset(fileAsset.mediaType,
                   hasSame ? displayName : fileAsset.displayName, showPath);
           this.logger.debug('getTargetFileAsset end');
           return targetAsset;
       }
   }
    async readAndWriteData(srcFd: number, targetFd: number) {
        this.logger.debug('readAndWriteData start!')
        let stat = await fileio.fstat(srcFd);
        this.logger.debug(`readAndWriteData read stat.size ${stat.size}`)
        if (stat.size == 0) {
            return;
        }
        let step = 10000000;
        let last = stat.size % step;
        let count = (stat.size - last)/step;
        if (last > 0) {
            count = count + 1;
        }
        this.logger.debug(`readAndWriteData read count ${count} last ${last}`)

        for (let i = 0; i < count; i++) {
            let rwSize = 0;
            if (i == (count - 1)) {
                rwSize = last;
            } else {
                rwSize = step;
            }
            let buf = new ArrayBuffer(rwSize);
            let readOptions = {
                offset: 0,
                length: rwSize,
                position: i * step
            }
            await fileio.read(srcFd, buf, readOptions);
            let writeOptions = {
                offset: 0,
                length: rwSize,
                position: i * step,
                encoding: 'utf-8'
            }
            await fileio.write(targetFd, buf, writeOptions);
        }
        this.logger.debug('readAndWriteData end!')
    }

    async copy(uri: string, albumName: string, callback: any, isReplace: boolean, deviceId?, hasSame?) {
        this.logger.debug(`copy start ${JSON.stringify(uri)}`);
        if (callback == null || callback == undefined) {
            this.logger.debug('create callback is null or undefined');
            return;
        }

        try {
            let numId = this.getIdByUri(uri);
            let fileAsset = await this.getFileAssetById(numId, deviceId);
            if (fileAsset == null || fileAsset == undefined) {
                this.logger.error('Failed to get fileAsset');
                callback.onError();
                return;
            }

            let fd = await MediaLibraryAccess.openAsset('R', fileAsset);
            if (fd <= 0) {
                this.logger.error('fd is invalid');
                callback.onError();
                return;
            }

            let targetAsset = await this.getTargetFileAsset(fileAsset, albumName, isReplace, hasSame)
            if (targetAsset == null || targetAsset == undefined) {
                this.logger.error('Failed to get targetAsset');
                callback.onError();
                return;
            }

            let targetFd = await MediaLibraryAccess.openAsset('RW', targetAsset);
            if (targetFd <= 0) {
                this.logger.error('targetFd is invalid');
                callback.onError();
                return;
            }

            await this.readAndWriteData(fd, targetFd);
            await fileAsset.close(fd);
            await targetAsset.close(targetFd);
        } catch (error) {
            this.logger.error(`create error: ${error}`);
            callback.onError();
            return;
        }

        callback.onCompleted();

        this.logger.debug('copy end')
    }

    rename(oldName:any, newName:any): void {}

    remark(): void {}

    async trash(uri: string, callback: any) {
        this.logger.debug(`trash start ${JSON.stringify(uri)}`);
        if (callback == null || callback == undefined) {
            this.logger.debug('trash callback is null or undefined');
            return;
        }

        try{
            let numId = this.getIdByUri(uri);
            let fileAsset = await this.getFileAssetById(numId);
            if (fileAsset == null || fileAsset == undefined) {
                this.logger.error('Failed to get fileAsset');
                callback.onError();
                return;
            }

            await MediaLibraryAccess.trashAsset(true, fileAsset);
            this.logger.debug('trash end');
            callback.onCompleted();
        } catch (error) {
            this.logger.error(`trash error: ${error}`);
            callback.onError();
            return;
        }
    }

    async recover(uri: string, callback: any) {
        this.logger.debug(`recover start ${JSON.stringify(uri)}`);
        if (callback == null || callback == undefined) {
            this.logger.debug('recover callback is null or undefined');
            return;
        }

        try{
            let numId = this.getIdByUri(uri);
            let fileAsset = await MediaLibraryAccess.getTrashObject(AlbumDefine.getFileFetchOpt(numId));
            if (fileAsset[0] == null || fileAsset[0] == undefined) {
                this.logger.error('Failed to get fileAsset');
                callback.onError();
                return;
            }

            await MediaLibraryAccess.trashAsset(false, fileAsset[0]);
            this.logger.debug('recover end');
            callback.onCompleted();
        } catch (error) {
            this.logger.error(`create error: ${error}`);
            callback.onError();
            return;
        }
    }

    async renameSinglePhoto(id, name) {
        this.logger.info('renameSinglePhoto start');
        let fileAsset = await this.getFileAssetById(id);
        fileAsset.title = name;
        let displayName = fileAsset.displayName;
        let index = displayName.lastIndexOf('.');
        displayName = name + displayName.slice(index);
        fileAsset.displayName = displayName;
        this.logger.info(`renameSinglePhoto title: ${name}, displayName: ${displayName}`);
        await fileAsset.commitModify();
        fileAsset = await this.getFileAssetById(id);
        return [fileAsset.title, fileAsset.displayName];
    }

    getIdByUri(uri:string): number {
        let srcIndex = uri.lastIndexOf('/');
        let srcEnd = uri.length;
        let srcId = uri.substring(srcIndex + 1, srcEnd);
        let numId = new Number(srcId);
        this.logger.info(`getIdByUri numId: ${numId}`);
        return numId.valueOf();
    }
    async changeOrientation(id, orientation) {
        this.logger.info('changeOrientation start');
        let fileAsset = await this.getFileAssetById(id);
        fileAsset.orientation = orientation;
        this.logger.info('changeOrientation commitModify start');
        await fileAsset.commitModify();
        this.logger.info('changeOrientation finish');
    }

    async getFileAssetById(id, deviceId?) {
        this.logger.info('getFileAssetById');
        try {
            let result = await MediaLibraryAccess.getFirstObject(AlbumDefine.getFileFetchOpt(id, deviceId));
            if (result == null) {
                this.logger.info('getFileAssetByUri fail');
                return null;
            }
            return result.obj;
        } catch (error) {
            this.logger.error('getFileAssetById error');
            return null;
        }
    }
}