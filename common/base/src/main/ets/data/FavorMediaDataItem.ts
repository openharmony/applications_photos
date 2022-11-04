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
import mediaModel from '../model/MediaModel';
import { MediaConstants } from '../constants/MediaConstants';
import { MediaDataItem } from './MediaDataItem';

export class FavorMediaDataItem extends MediaDataItem {
    constructor(selections: string, selectionArgs: Array<string>, index: number) {
        super(selections, selectionArgs, "", index)
    }

    async loadFileAsset(): Promise<MediaLib.FileAsset> {
        let fetchOption: MediaLib.MediaFetchOptions;
        if (this.status == MediaConstants.UNDEFINED) {
            fetchOption = {
                selections: this.selections,
                selectionArgs: this.selectionArgs,
                order: `date_added DESC LIMIT ${this.index},1`
            };
        } else {
            fetchOption = {
                selections: `${MediaLib.FileKey.ID} = ?`,
                selectionArgs: [this.id.toString()],
                order: `date_added DESC`
            }
        }
        return (await mediaModel.getAllFavorMediaItem(fetchOption, false)).fileAsset;
    }

    async setFavor(): Promise<boolean> {
        let isSuccess: boolean = await super.setFavor();
        let isFavor: boolean = await super.isFavor();
        this.status = isFavor ? this.status : MediaConstants.TRASHED;
        return isSuccess;
    }
}