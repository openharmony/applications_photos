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
import { DistributedDataImpl } from '../model/DistributedDataImpl'
import { ItemDataSource } from './ItemDataSource'
import { PeerDataItem } from '../data/PeerDataItem'
import { Log } from '../utils/Log';

const TAG = "DistributedDataSource"

export class DistributedDataSource extends ItemDataSource {
    private peerDataItems: PeerDataItem[] = [];
    private distributedDataImpl: DistributedDataImpl = new DistributedDataImpl();

    totalCount(): number {
        return this.peerDataItems.length;
    }

    getData(index: number): any{
        this.peerDataItems[index].index = index;
        return this.peerDataItems[index];
    }

    isSelect(): boolean {
        let isSelect = true;
        for (let i = 0;i < this.peerDataItems.length; i++) {
            if (!this.peerDataItems[i].isSelect) {
                isSelect = false;
                break;
            }
        }
        return isSelect;
    }

    setSelect(isSelect: boolean) {
        this.peerDataItems.forEach((item: PeerDataItem) => {
            item.setSelect(isSelect);
        })
    }

    getSelectedUris(): string[]{
        let uris: string[] = [];
        this.peerDataItems.forEach((item: PeerDataItem) => {
            if (item.isSelect) {
                uris.push(item.uri);
            }
        })
        return uris;
    }

    getSelectedCount(): number {
        let count = 0;
        for (let i = 0;i < this.peerDataItems.length; i++) {
            if (this.peerDataItems[i].isSelect) {
                count++;
            }
        }
        return count;
    }

    getSelectedItems(): any[]{
        return [];
    }

    onDataUpdate(index: number): void {
        Log.info(TAG, `onDataUpdate ${index}`);
        this.notifyDataChange(index);
    }

    dataReload(): void {
        this.reloadAlbumItemData().then((isEmpty: number) => {
            this.notifyDataReload();
        })
    }

    dataRemove(): void {
    }

    async reloadAlbumItemData(): Promise<number> {
        let before = this.peerDataItems.length;
        this.peerDataItems = await this.distributedDataImpl.reloadAlbumItemData();
        return this.peerDataItems.length - before;
    }
}