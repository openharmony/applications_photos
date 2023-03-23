// @ts-nocheck
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
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { ViewType } from '@ohos/base/src/main/ets/data/ViewType';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import mediaDataItemCache from '@ohos/base/src/main/ets/data/MediaDataItemCache';
import { ItemDataSource } from '@ohos/base/src/main/ets/vm/ItemDataSource';

const TAG = "TimelineDataItem"

export class TimelineDataItem {
    readonly viewType = ViewType.GROUP_TITLE;
    dateAdded: number;
    groupChild: MediaDataItem[] = [];

    constructor(fileAssert: MediaLib.FileAsset, mediaFileAsset: Array<MediaLib.FileAsset>, index: number) {
        Log.info(TAG, `construct ${fileAssert.dateAdded}:${fileAssert.count}`);
        this.dateAdded = fileAssert.dateAdded * 1000;
        this.groupChild = new Array(fileAssert.count);
        let selections: string = MediaLib.FileKey.MEDIA_TYPE + ' = ? or ' + MediaLib.FileKey.MEDIA_TYPE + ' = ?';
        let selectionArgs: Array<string> = [MediaLib.MediaType.IMAGE.toString(), MediaLib.MediaType.VIDEO.toString()];
        for (let i = 0;i < this.groupChild.length; i++) {
            this.groupChild[i] = new MediaDataItem(selections, selectionArgs, "", index + i)
            if (index + i < mediaFileAsset.length) {
                if (mediaDataItemCache.hasKey(mediaFileAsset[index+i].uri)) {
                    this.groupChild[i] = mediaDataItemCache.get(mediaFileAsset[index+i].uri);
                } else {
                    mediaDataItemCache.set(mediaFileAsset[index+i].uri, this.groupChild[i]);
                }
                this.groupChild[i].update(mediaFileAsset[index+i]);
            }
        }
    }

    getHashCode(): string {
        return `${this.dateAdded}` + `${this.isSelect()}` + `${this.groupChild.length}`;
    }

    isSelect(): boolean {
        let status = true;
        for (let i = 0;i < this.groupChild.length; i++) {
            if (!this.groupChild[i].isSelect) {
                status = false;
                break;
            }
        }
        return status;
    }

    setSelect(isSelect: boolean) {
        this.groupChild.forEach((child: MediaDataItem) => {
            child.setSelect(isSelect);
        })
    }

    getSelectedCount(): number{
        let count = 0;
        this.groupChild.forEach((child: MediaDataItem) => {
            if (child.isSelect) {
                count++;
            }
        })
        return count;
    }

    dataRemove(): number[] {
        let removeList: number[] = [];
        for (let i = this.groupChild.length - 1;i >= 0; i--) {
            if (this.groupChild[i].isDeleted()) {
                this.groupChild.splice(i, 1);
                removeList.push(i);
            }
        }
        return removeList;
    }
}