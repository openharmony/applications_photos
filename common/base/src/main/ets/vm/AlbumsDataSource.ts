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
import { logDebug, logWarn, logError } from '../utils/LoggerUtils';
import { AlbumDataImpl } from '../model/AlbumDataImpl'
import { ItemDataSource } from './ItemDataSource'
import { AlbumDataItem } from '../data/AlbumDataItem'

const TAG = "AlbumsDataSource"

export class AlbumsDataSource extends ItemDataSource {
    private albumDataItems: AlbumDataItem[] = []
    private albumDataImpl: AlbumDataImpl = new AlbumDataImpl()

    setBlackList(blackList: string[]) {
        this.albumDataImpl.setBlackList(blackList)
    }

    setSelectType(selectType: number) {
        this.albumDataImpl.setSelectType(selectType)
    }

    setDeviceId(deviceId: string) {
        this.albumDataImpl.setDeviceId(deviceId)
    }

    totalCount(): number {
        return this.albumDataItems.length
    }

    getData(index: number): any{
        if (index < 0 || index >= this.albumDataItems.length) {
            logWarn(TAG, `${index}/${this.albumDataItems.length}`)
            return undefined
        }
        this.albumDataItems[index].index = index
        return this.albumDataItems[index]
    }

    isSelect(): boolean {
        let isSelect = true
        for (let i = 0;i < this.albumDataItems.length; i++) {
            if (!this.albumDataItems[i].isSelect) {
                isSelect = false
                break
            }
        }
        return isSelect
    }

    getSelectedUris(): string[]{
        let uris: string[] = []
        this.albumDataItems.forEach((item: AlbumDataItem) => {
            if (item.isSelect) {
                uris.push(item.uri)
            }
        })
        return uris
    }

    isDisableRename(): boolean {
        let isDisableRename = false
        for (let i = 0;i < this.albumDataItems.length; i++) {
            if (this.albumDataItems[i].isSelect && this.albumDataItems[i].isDisableRename) {
                isDisableRename = true
                break
            }
        }
        return isDisableRename
    }

    isDisableDelete(): boolean {
        let isDisableDelete = false
        for (let i = 0;i < this.albumDataItems.length; i++) {
            if (this.albumDataItems[i].isSelect && this.albumDataItems[i].isDisableDelete) {
                isDisableDelete = true
                break
            }
        }
        return isDisableDelete
    }

    setSelect(isSelect: boolean) {
        this.albumDataItems.forEach((item: AlbumDataItem) => {
            item.setSelect(isSelect)
        })
    }

    getSelectedCount(): number {
        let count = 0
        for (let i = 0;i < this.albumDataItems.length; i++) {
            if (this.albumDataItems[i].isSelect) {
                count++
            }
        }
        return count
    }

    getSelectedItems(): AlbumDataItem[]{
        let items: AlbumDataItem[] = []
        this.albumDataItems.forEach((item: AlbumDataItem) => {
            if (item.isSelect) {
                items.push(item)
            }
        })
        return items
    }

    dataReload() {
        this.reloadAlbumItemData().then((isEmpty: boolean) => {
            this.notifyDataReload()
        })
    }

    dataRemove() {
        for (let i = this.albumDataItems.length - 1;i >= 0; i--) {
            if (this.albumDataItems[i].isDeleted()) {
                this.albumDataItems.splice(i, 1)
                super.notifyDataDelete(i)
            }
        }
    }

    async reloadAlbumItemData(): Promise<boolean> {
        this.albumDataItems = await this.albumDataImpl.reloadAlbumItemData()
        return this.albumDataItems.length == 0
    }
}