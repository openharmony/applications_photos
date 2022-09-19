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
import mediaModel from '../model/MediaModel'
import { logDebug, logError } from '../utils/LoggerUtils'
import selectManager from '../manager/SelectManager'
import { MediaConstants } from '../constants/MediaConstants'
import { getFetchOptions } from '../helper/MediaDataHelper';

const TAG = "AlbumDataItem"

export class AlbumDataItem {
    index: number;
    id: string;
    uri: string;
    orientation: number;
    displayName: string;
    count: number;
    isDisableRename: boolean;
    isDisableDelete: boolean;
    relativePath: string;
    innerId: number;
    selectType: number = MediaConstants.SELECT_TYPE_ALL
    deviceId: string = ""
    isSelect: boolean = false
    status: number = MediaConstants.UNDEFINED

    constructor(id: string, count: number, displayName: string, selectType: number, deviceId: string) {
        this.id = id
        this.displayName = displayName
        this.count = count
        this.isDisableRename = MediaConstants.ALBUM_DISABLE_RENAME_LIST.has(id)
        this.isDisableDelete = MediaConstants.ALBUM_DISABLE_DELETE_LIST.has(id)
        this.selectType = selectType
        this.deviceId = deviceId
    }

    getHashCode(): string {
        return `${this.id} ${this.orientation}`
    }

    async load(): Promise<void> {
        if (this.status >= MediaConstants.LOADED) {
            return
        }
        let fetchOption: MediaLib.MediaFetchOptions = await getFetchOptions(this.selectType, this.id, this.deviceId)
        let fileAsset = (await mediaModel.getAllMediaItem(this.id, fetchOption, false)).fileAsset
        this.update(fileAsset)
    }

    update(fileAsset: MediaLib.FileAsset) {
        this.uri = fileAsset.uri
        this.orientation = fileAsset.orientation
        this.relativePath = fileAsset.relativePath

        this.status = MediaConstants.LOADED
    }

    async getRelativePath(): Promise<string> {
        await this.load()
        return this.relativePath
    }

    getThumbnail(): string{
        logDebug(TAG, `this.uri ${this.uri}`)
        return this.uri + `/thumbnail/256/256`
    }

    async getVideoCount(): Promise<number> {
        if (this.selectType == MediaConstants.SELECT_TYPE_IMAGE) {
            return 0
        }
        let videoFetchOption: MediaLib.MediaFetchOptions = await getFetchOptions(MediaConstants.SELECT_TYPE_VIDEO, this.id, this.deviceId)
        return (await mediaModel.getAllMediaItem(this.id, videoFetchOption, true)).counts
    }

    setSelect(isSelect: boolean) {
        this.isSelect = isSelect
        selectManager.setSelect(this.uri, this.isSelect)
    }

    async onDelete(): Promise<boolean> {
        try {
            let fetchOption: MediaLib.MediaFetchOptions = await getFetchOptions(this.selectType, this.id, "")
            await mediaModel.deleteAll(fetchOption)
            selectManager.deleteSelect(this.uri)
            this.status = MediaConstants.TRASHED
            return true
        } catch (err) {
            logError(TAG, `onDelete error: ${JSON.stringify(err)}`)
            return false
        }
    }

    isDeleted(): boolean {
        return this.status == MediaConstants.TRASHED
    }
}