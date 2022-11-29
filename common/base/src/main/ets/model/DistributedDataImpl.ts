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
import mediaModel from '../model/MediaModel';
import { PeerDataItem } from '../data/PeerDataItem';

const TAG = "DistributedDataImpl"

export class DistributedDataImpl {
    async reloadAlbumItemData(): Promise<PeerDataItem[]> {
        let peerDataItems = [];
        let peers: MediaLib.PeerInfo[] = await mediaModel.getActivePeers();
        Log.info(TAG, `peers： ${JSON.stringify(peers)}`);
        for (let i = 0;i < peers.length; i++) {
            let selections: string = `${MediaLib.FileKey.MEDIA_TYPE} = ? or ${MediaLib.FileKey.MEDIA_TYPE} = ?`;
            let selectionArgs: string[] = [MediaLib.MediaType.IMAGE.toString(), MediaLib.MediaType.VIDEO.toString()];
            let fetchOption: MediaLib.MediaFetchOptions = {
                selections: selections,
                selectionArgs: selectionArgs,
                networkId: peers[i].networkId,
                order: `date_added DESC`
            };
            let item = await mediaModel.getAllCommonMediaItem(fetchOption, false);
            if (item.counts == 0) {
                continue;
            }
            peerDataItems.push(new PeerDataItem(item.counts, peers[i], item.fileAsset));
        }

        return peerDataItems;
    }
}