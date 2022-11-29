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
import selectManager from '../manager/SelectManager';
import mediaModel from '../model/MediaModel';
import { Log } from '../utils/Log';
import { MediaConstants } from '../constants/MediaConstants';
import { MediaDataItem } from './MediaDataItem';

const TAG = "TrashMediaDataItem"

export class TrashMediaDataItem extends MediaDataItem {
    constructor(selections: string, selectionArgs: Array<string>, index: number) {
        super(selections, selectionArgs, "", index);
        this.setSelect(false);
    }

    async loadFileAsset(): Promise<MediaLib.FileAsset> {
        let fetchOption: MediaLib.MediaFetchOptions;
        if (this.status == MediaConstants.UNDEFINED) {
            fetchOption = {
                selections: this.selections,
                selectionArgs: this.selectionArgs,
                order: `date_added DESC LIMIT ${this.index},1`
            }
        } else {
            fetchOption = {
                selections: `${MediaLib.FileKey.ID} = ?`,
                selectionArgs: [this.id.toString()],
                order: `date_added DESC`
            }
        }
        return (await mediaModel.getAllTrashMediaItem(fetchOption, false)).fileAsset;
    }

    async onRecover(): Promise<boolean> {
        try {
            let fileAsset = await this.loadFileAsset();

            await fileAsset.trash(false);
            selectManager.deleteSelect(this.uri);
            this.status = MediaConstants.TRASHED;
            return true;
        } catch (err) {
            Log.error(TAG, `onRecover error: ${JSON.stringify(err)}`);
            return false;
        }
    }

    async onDelete(): Promise<boolean> {
        try {
            await mediaModel.deleteOne(this.uri);
            selectManager.deleteSelect(this.uri);
            this.status = MediaConstants.TRASHED;
            return true;
        } catch (err) {
            Log.error(TAG, `onDelete error: ${JSON.stringify(err)}`);
            return false;
        }
    }
}