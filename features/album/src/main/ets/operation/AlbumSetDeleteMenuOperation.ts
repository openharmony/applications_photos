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

import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import { ItemDataSource } from '@ohos/base/src/main/ets/vm/ItemDataSource';
import { AlbumDataItem } from '@ohos/base/src/main/ets/data/AlbumDataItem';
import { MenuContext } from '@ohos/base/src/main/ets/operation/MenuContext';
import { ProcessMenuOperation } from '@ohos/base/src/main/ets/operation/ProcessMenuOperation';

const TAG = "AlbumSetDeleteMenuOperation"

export class AlbumSetDeleteMenuOperation extends ProcessMenuOperation {
    constructor(menuContext: MenuContext) {
        super(menuContext);
    }

    doAction(): void {
        if (this.menuContext == null) {
            Log.warn(TAG, 'menuContext is null, return');
            return;
        }
        let dataSource: ItemDataSource = this.menuContext.dataSource;
        if (dataSource == null) {
            this.count = this.menuContext.items.length;
            this.items = this.menuContext.items;
        } else {
            this.count = dataSource.getSelectedCount();
            this.items = dataSource.getSelectedItems();
        }
        if (this.count <= 0) {
            Log.warn(TAG, 'count <= 0, return');
            return;
        }

        this.confirmCallback = this.confirmCallback.bind(this);
        this.cancelCallback = this.cancelCallback.bind(this);

        let deleteResource: Resource = $r('app.string.dialog_delete');
        this.getDialogTitle().then(dialogTitle => {
            this.menuContext.broadCast.emit(BroadcastConstants.SHOW_DELETE_DIALOG, [dialogTitle, deleteResource, this.confirmCallback, this.cancelCallback]);
        })
    }

    private async getDialogTitle(): Promise<Resource> {
        let videoCount = 0;
        let photoCount = 0;
        for (let i = 0; i < this.items.length; i++) {
            let itemVideoCount = await  (this.items[i] as AlbumDataItem).getVideoCount();
            videoCount += itemVideoCount;
            photoCount += (this.items[i].count - itemVideoCount);
        }

        if (this.count == 1) {
            if (videoCount > 0 && photoCount > 0) {
                return $r('app.string.recycle_single_album_tips', photoCount, videoCount);
            }
            if (videoCount > 0 && photoCount <= 0) {
                return $r('app.string.recycle_single_album_with_videos_tips', videoCount);
            }
            if (videoCount <= 0 && photoCount > 0) {
                return $r('app.string.recycle_single_album_with_photos_tips', photoCount);
            }
        } else {
            if (videoCount > 0 && photoCount > 0) {
                return $r('app.string.recycle_albums_tips', this.count, photoCount, videoCount);
            }
            if (videoCount > 0 && photoCount <= 0) {
                return $r('app.string.recycle_albums_with_videos_tips', this.count, videoCount);
            }
            if (videoCount <= 0 && photoCount > 0) {
                return $r('app.string.recycle_albums_with_photos_tips', this.count, photoCount);
            }
        }
    }

    // Delete a batch of data
    requestOneBatchOperation(): void {
        let item = this.items[this.currentBatch] as AlbumDataItem;
        item.onDelete().then(() => {
            this.currentBatch++
            this.menuContext.broadCast.emit(BroadcastConstants.UPDATE_PROGRESS, [this.getExpectProgress(), this.currentBatch]);
            this.cyclicOperation();
        }).catch(() => {
            this.onError();
        })
    }

    private confirmCallback(): void {
        Log.info(TAG, 'AlbumSet delete confirm');
        // 1. Variable initialization
        this.onOperationEnd = this.menuContext.onOperationEnd;
        let onOperationStart: Function = this.menuContext.onOperationStart;

        onOperationStart && onOperationStart();

        this.menuContext.broadCast.emit(BroadcastConstants.DELETE_PROGRESS_DIALOG, [$r('app.string.action_delete'), this.count]);
        this.processOperation();
    }

    private cancelCallback(): void {
        Log.info(TAG, 'AlbumSet delete cancel');
    }
}