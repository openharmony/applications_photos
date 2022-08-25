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

import { AlbumDefine } from '../AlbumDefine'
import { BrowserDataImpl } from '../BrowserDataImpl'
import { Logger } from '../../../utils/Logger'
import { AsyncCallback } from '../../common/AsyncCallback'
import { MediaItem } from './MediaItem'
import { MediaLibraryAccess } from '../../../access/MediaLibraryAccess'
import { TraceControllerUtils } from '../../../utils/TraceControllerUtils';

export class PhotoDataImpl extends BrowserDataImpl {
    logger: Logger = new Logger('PhotoDataImpl');
    name: Resource;

    constructor() {
        super()
    }

    getData(callback: AsyncCallback<MediaItem[]>, param): void{
        this.logger.info(`getMediaItem start ${JSON.stringify(param)}`);
        if (callback == null) {
            this.logger.error('getMediaItem, param or callback is null, return!');
            return;
        }

        // Querying MediaLibrary data
        this.getItems(param.id, param.start, param.count, param.deviceId).then((dataList) => {
            this.logger.info(`getMediaItem coming`);
            if (dataList != null) {
                let promiseStatus: Array<Promise<boolean>> = []
                for (let item of dataList) {
                    try {
                        promiseStatus.push(item.isFavorite())
                    }
                    catch (err) {
                        this.logger.error(`getItems error: ${err}`);
                    }
                }
                TraceControllerUtils.startTraceWithTaskId('getFavorInfo', dataList.length);
                Promise.all(this.handlePromise(promiseStatus)).then((favor: any) => {
                    TraceControllerUtils.finishTraceWithTaskId('getFavorInfo', dataList.length);
                    this.getMediaItemList(dataList, promiseStatus, favor, callback)
                })

            }
        });
    }

    private async getMediaItemList(dataList, promiseStatus: Array<Promise<boolean>>, favor: any, callback: AsyncCallback<MediaItem[]>) {
        let mediaItemList: MediaItem[] = [];
        for (let i = 0; i < promiseStatus.length; i++) {
            try {
                let item = dataList[i];
                let mediaItem: MediaItem = new MediaItem(item);
                if (favor[i].status = 'success') {
                    mediaItem.setFavorite(favor[i].res);
                } else {
                    this.logger.error(`getFavorite error: ${favor[i].err}`);
                }
                mediaItem.setThumbnail(this.getThumbnailSafe(item.uri));
                mediaItemList.push(mediaItem);
            }
            catch (err) {
                this.logger.error(`getItems error: ${err}`);
            }
        }
        this.logger.info(`getMediaItem item size: ${mediaItemList.length}`);
        callback.callback(mediaItemList);
    }

    handlePromise(promiseList) {
        return promiseList.map(promise => promise.then((res) => ({ status: 'success', res }),
            (err) => ({ status: 'failed', err })))
    }

    getDataCount(callback: AsyncCallback<number>, param: any): void {
        this.logger.debug(`getMediaItemCount: ${JSON.stringify(param)}`);
        this.getItemsCount(param.id, param.deviceId).then((count) => {
            this.logger.debug(`getMediaItemCount callback: ${count}`);
            callback.callback(count);
        });
    }

    getThumbnail(sourceUri: string, size?) {
        return this.getThumbnailSafe(sourceUri, size);
    }

    async getDataById(id: any, deviceId?: any) {
        this.logger.debug('getFileAssetById');
        try {
            let result = await MediaLibraryAccess.getInstance().getFirstObject(AlbumDefine.getFileFetchOptById(id, deviceId));
            this.logger.debug(`result: ${JSON.stringify(result)}`)
            return result.obj;
        } catch (error) {
            this.logger.error('getFileAssetById error');
            return null;
        }
    }

    async getDataByName(name: string, albumInfo: any) {
        this.logger.debug('getFileByName');

        let dataList;
        if (albumInfo.id) {
            dataList = await MediaLibraryAccess.getInstance().getEntityAlbumObject(AlbumDefine.getAlbumFetchOpt(albumInfo.id),
            AlbumDefine.getFileFetchOptByName(name))
        } else {
            dataList = await MediaLibraryAccess.getInstance().getAllObject(AlbumDefine.getFileFetchOptByName(name, albumInfo.relativePath))
        }

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
}