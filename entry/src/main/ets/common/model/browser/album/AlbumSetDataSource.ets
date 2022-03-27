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

import { AlbumSetCallback } from './AlbumSetCallback.ets';
import { TraceControllerUtils } from '../../../utils/TraceControllerUtils.ets';
import { BrowserDataFactory } from '../interface/BrowserDataFactory.ets';
import { BrowserDataInterface } from '../interface/BrowserDataInterface';
import { BroadCast } from '../../../utils/BroadCast.ets';
import { Logger } from '../../../utils/Logger.ets';
import { AlbumInfo } from './AlbumInfo.ets';
import { AbsDataSource } from '../AbsDataSource.ets';
import { Constants } from '../../common/Constants.ets';

export class AlbumSetDataSource extends AbsDataSource {
    logger: Logger = new Logger('AlbumSetDataSource');

    mediaSetList: AlbumInfo[] = [];

    albumBrowserDataImpl: BrowserDataInterface

    private broadCast_: BroadCast;
    private blackList: Array<string> = [];
    private deviceId = ''

    constructor(broadCast: BroadCast, device?) {
        super();

        this.logger.debug(`constructor ${JSON.stringify(device)}`);
        this.broadCast_ = broadCast;
        this.albumBrowserDataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_ALBUM_SET, device);

        if (device != undefined){
            this.deviceId = device.deviceId;
        }
    }

    initData(): void {
        TraceControllerUtils.startTrace('AlbumSetPageInitData');
        this.logger.debug('initData');
        this.loadData();
    }

    loadData(): Promise<void> {
        this.logger.info('load data');
        if (this.albumBrowserDataImpl != null) {
            let callback: AlbumSetCallback = new AlbumSetCallback(this);
            return this.albumBrowserDataImpl.getData(callback, null);
        }
        return new Promise((resolve) => {resolve()})
    }

    totalCount(): number {
        this.logger.info(`totalCount: ${this.mediaSetList.length}`);
        return this.mediaSetList.length;
    }

    getData(index: number): AlbumInfo {
        this.logger.info(`getData index: ${index}, item: ${JSON.stringify(this.mediaSetList[index])}`);
        if (index < 0 || index >= this.mediaSetList.length) {
            this.logger.error(`index out of the total size, index: ${index} total size: ${this.mediaSetList.length}`);
            return undefined;
        }
        return this.mediaSetList[index];
    }

    updateAlbumSetData(requestTime: number, mediaSetList: AlbumInfo[]): void {
        TraceControllerUtils.startTraceWithTaskId('updateAlbumSetData', requestTime);
        this.logger.info(`updateMediaItems size: ${mediaSetList.length}`);
        this.lastUpdateTime = requestTime;
        if (this.lastUpdateTime < this.lastChangeTime && this.isActive) {
            // If there is a new media library change callback,
            // the query continues and the current data is updated without return.
            this.logger.debug('request data expired, request again!');
            this.loadData();
        } else {
            this.hasNewChange = false;
        }
        this.mediaSetList = this.excludeBlackList(mediaSetList);
        this.onDataReloaded();
        TraceControllerUtils.finishTraceWithTaskId('updateAlbumSetData', requestTime);
        this.broadCast_.emit(Constants.ON_LOADING_FINISHED, [this.totalCount()]);
        TraceControllerUtils.finishTrace('AlbumSetPageInitData');
    }

    excludeBlackList(mediaSetList: AlbumInfo[]): Array<AlbumInfo> {
        if (0 == this.blackList.length) {
            this.logger.debug('BlackList: no black list.');
            return mediaSetList;
        }
        this.logger.debug(`BlackList: albums name ${JSON.stringify(this.blackList)}.`);
        let res = mediaSetList.filter((item) => {
            return this.blackList.indexOf(item.name) < 0;
        });
        this.logger.debug(`BlackList: old albums length ${mediaSetList.length}, new albums length ${res.length}.`);
        return res;
    }

    onChange(mediaType: string) {
        if(this.deviceId == '' || this.deviceId == undefined) {
            if (mediaType == 'image' || mediaType == 'video' || mediaType == 'album'){
                super.onChange(mediaType);
            }
        }else{
            if (mediaType == 'remote'){
                super.onChange(mediaType);
            }
        }
    }

    updateAlbumMediaCount() {
        for (let album of this.mediaSetList) {
            this.albumBrowserDataImpl.getMediaItemCount(null, album);
        }
    }

    getNewAlbumDefaultName(prefixName : string) : string {
        let numbers = [];
        for (let album of this.mediaSetList) {
            let res = album.name.match(new RegExp(`${prefixName}[1-9][0-9]*`));
            if (res != null) {
                let number = res[0].match(new RegExp(`[1-9][0-9]*`));
                numbers.push(parseInt(number[0]));
            }
        }

        if (numbers.length <= 0) {
            return `${prefixName}1`;
        } else if (numbers.length == 1) {
            if (numbers[0] - 1 > 0) {
                return `${prefixName}${numbers[0] - 1}`;
            } else {
                return `${prefixName}${numbers[0] + 1}`;
            }
        }

        numbers.sort(function(a, b) { return a - b; });

        for (let i = 1; i < numbers.length; i++) {
            let res = numbers[i - 1] + 1;
            if (res < numbers[i]) {
                return `${prefixName}${res}`;
            }
        }
        return `${prefixName}${numbers[numbers.length - 1] + 1}`;
    }

    isRepeatedName(albumName) {
        for (let album of this.mediaSetList) {
            if (album.name == albumName) {
                return true;
            }
        }
        return false;
    }

    setBlackList(albums: Array<string>) {
        this.blackList = albums;
        this.logger.debug(`BlackList: set blacklist ${JSON.stringify(this.blackList)}.`);
    }
}