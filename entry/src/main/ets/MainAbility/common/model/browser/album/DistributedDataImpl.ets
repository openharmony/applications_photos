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
import {BrowserDataImpl} from '../BrowserDataImpl.ets'
import {PeerInfo} from "./PeerInfo"
import {MediaLibraryAccess} from '../../../access/MediaLibraryAccess.ets';
import {AlbumDefine} from '../AlbumDefine'
import {Logger} from '../../../utils/Logger.ets'

export class DistributedDataImpl extends BrowserDataImpl {
    constructor() {
        super();
        this.logger = new Logger('DistributedDataImpl');
    }

    async getData(callback:any, param:any): Promise<void> {
        let result : PeerInfo[] = [];

        let devices = await MediaLibraryAccess.getConnectedRemoteDevice();
        for (let dev of devices) {
            this.logger.debug(`Remote Device Name:${dev.deviceName} networkID: ${dev.networkId}`);
            let peerInfo = new PeerInfo(null, dev.deviceName, 0, dev.networkId);
            let file = await this.getFirstObject(AlbumDefine.getFetchOpt(AlbumDefine.ALBUM_NAME_ALL, dev.networkId));

            if (file.count > 0) {
                peerInfo.coverUri = await this.getThumbnailSafe(file.obj);
                peerInfo.count = file.count;
            }

            result.push(peerInfo);
        }

        callback(result);

        return new Promise((resolve) => { resolve(); });
    }

    getMediaItemCount(callback:any, param:any): void {}
}