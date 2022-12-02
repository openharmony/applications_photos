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
import MediaLib from '@ohos.multimedia.mediaLibrary';
import { Log } from '../utils/Log';
import selectManager from '../manager/SelectManager';

const TAG = "PeerDataItem"

export class PeerDataItem {
    index: number;
    uri: string;
    orientation: number;
    deviceName: string;
    count: number;
    networkId: string;
    isSelect: boolean;

    constructor(count: number, peer: MediaLib.PeerInfo, fileAsset: MediaLib.FileAsset) {
        this.uri = fileAsset.uri;
        this.orientation = fileAsset.orientation;
        this.deviceName = peer.deviceName;
        this.count = count;
        this.networkId = peer.networkId;
    }

    getHashCode() {
        return `${this.networkId} ${this.orientation} ${this.isSelect}`;
    }

    getThumbnail(): string {
        Log.debug(TAG, `this.uri ${this.uri}`);
        return this.uri + `/thumbnail/256/256`;
    }

    setSelect(isSelect: boolean) {
        this.isSelect = isSelect;
        selectManager.setSelect(this.uri, this.isSelect);
    }
}