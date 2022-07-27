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

import {PeerInfo} from './PeerInfo'
import {Logger} from '../../../utils/Logger'
import {AbsDataSource} from '../AbsDataSource'
import { BroadCast } from '../../../utils/BroadCast';
import { BrowserDataFactory } from '../../../interface/BrowserDataFactory';
import { BrowserDataInterface } from '../../../interface/BrowserDataInterface';

import {BroadCastConstants} from '../../common/BroadCastConstants'
import {BroadCastManager} from '../../common/BroadCastManager'
import {Constants} from '../../common/Constants';

export class DistributedDataSource extends AbsDataSource {
    logger: Logger = new Logger('DistributedDataSource');
    broadCast: BroadCast;
    peerInfoList: PeerInfo[] = [];

    constructor(broadCast: BroadCast) {
        super();
        this.broadCast = broadCast;
    }

    initData(): void {
        this.logger.info('initData');
        this.loadData();
    }

    loadData(): void {
        this.logger.info('load data');
        this.updateData = this.updateData.bind(this);
        let dataImpl: BrowserDataInterface = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_DISTRIBUTED);
        dataImpl.getData(this.updateData, null);
    }

    totalCount(): number {
        this.logger.info(`totalCount: ${this.peerInfoList.length}`);
        return this.peerInfoList.length;
    }

    getData(index: number): any {
        this.logger.info(`getData index: ${index} item: ${JSON.stringify(this.peerInfoList[index])}`);
        if (index < 0 || index >= this.peerInfoList.length) {
            this.logger.error(`index out of the total size, index: ${index} total size: ${this.peerInfoList.length}`);
            return undefined;
        }
        return this.peerInfoList[index];
    }

    private updateData(devices: PeerInfo[]) {
        this.logger.debug(`updateData size: ${devices.length}`);
        this.lastUpdateTime = Date.now();
        let sendParams = [];
        this.getDevicesStatus(devices, sendParams);

        this.peerInfoList = devices;
        sendParams.push(this.peerInfoList.length);
        BroadCastManager.getInstance().getBroadCast().emit(BroadCastConstants.ON_REMOTE_CHANGED, sendParams);

        if (this.isActive) {
            this.onDataReloaded();
        }
    }

    onChange(mediaType: string) {
        if (mediaType == Constants.MEDIA_TYPE_DEVICE|| mediaType == Constants.MEDIA_TYPE_REMOTE) {
            this.logger.info(`onChange: ${mediaType}`);
            this.lastChangeTime = Date.now();
            this.loadData();
        }
    }

    onActive(): void {
        this.logger.info('onActive');
        this.isActive = true;
        this.onDataReloaded();
    }

    private getDevicesStatus(devices, params) {
        if (this.peerInfoList.length <= 0) {
            params.push(Constants.DEVICE_STATE_ONLINE);
            params.push('');
        }

        for (let device of this.peerInfoList) {
            if (!this.hasDevice(device.networkId, devices)) {
                this.logger.debug(`offline: ${device.networkId}`);
                params.push(Constants.DEVICE_STATE_OFFLINE);
            }else{
                params.push(Constants.DEVICE_STATE_CHANGE);
            }
            params.push(device.networkId);
        }
    }

    private hasDevice(deviceId, devices) {
        for (let device of devices) {
            if (device.networkId == deviceId) {
                return true;
            }
        }

        return false;
    }
}