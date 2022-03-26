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

import {AlbumDefine} from '../AlbumDefine.ets'
import {BrowserDataImpl} from '../BrowserDataImpl.ets'
import {Logger} from '../../../utils/Logger.ets'
import {AsyncCallback} from '../../common/AsyncCallback'
import {MediaItem} from './MediaItem.ets'

export class PhotoDataImpl extends BrowserDataImpl {
    logger: Logger = new Logger('PhotoDataImpl');
    name: Resource;

    constructor() {
        super()
    }

    getData(callback: AsyncCallback<MediaItem[]>, param): Promise<void>{
        this.logger.info(`getMediaItem start ${JSON.stringify(param)}`);
        if (callback == null) {
            this.logger.error('getMediaItem, param or callback is null, return!');
            return;
        }

        // Querying MediaLibrary data
        let mediaItemList: MediaItem[] = [];
        this.getItems(param.name, param.start, param.count, param.deviceId).then(async (dataList) => {
            this.logger.info(`getMediaItem coming`);
            if (dataList != null) {
                let promiseStatus: Array<Promise<boolean>> = []
                for (let item of dataList) {
                    try {
                        promiseStatus.push(item.isFavorite())
                    }
                    catch(err) {
                        this.logger.error(`getItems error: ${err}`);
                    }
                }
                Promise.all(this.handlePromise(promiseStatus)).then((favor: any) => {
                    for (let i = 0; i < promiseStatus.length; i++) {
                        try {
                            let item = dataList[i];
                            let mediaItem: MediaItem = new MediaItem(item);
                            if(favor[i].status = 'success'){
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
                })

            }
        });
    }

    handlePromise(promiseList) {
        return promiseList.map(promise => promise.then((res) => ({status: 'success', res}),
            (err) => ({status: 'failed', err})))
    }

    getMediaItemCount(callback: AsyncCallback<number>, param: any): void {
        this.logger.debug(`getMediaItemCount: ${JSON.stringify(param)}`);
        this.getItemsCount(param.name, param.deviceId).then((count) => {
            this.logger.debug(`getMediaItemCount callback: ${count}`);
            callback.callback(count);
        });
    }

    async getObjectById(id, deviceId, isTrash: boolean = false) {
        this.logger.debug(`getObjectById: ${id} deviceID: ${deviceId} isTrash: ${isTrash}`);
        if (isTrash) {
            return await this.getTrashObjectById(id);
        } else {
            let obj = await this.getFirstObject(AlbumDefine.getFileFetchOpt(id, deviceId));
            if (obj == null) {
                this.logger.error('getFirstObject fail!');
                return null;
            }
            return obj.obj;
        }
    }

    getThumbnail(sourceUri: string, size?) {
        return this.getThumbnailSafe(sourceUri, size);
    }
}