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

import { Log } from '../utils/Log';
import { ItemDataSource } from '../vm/ItemDataSource';
import { MenuContext } from './MenuContext';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { ProcessMenuOperation } from './ProcessMenuOperation';
import { MediaDataItem } from '../data/MediaDataItem';
import { MediaConstants } from '../constants/MediaConstants';

const TAG = "BatchDeleteMenuOperation"

export class BatchDeleteMenuOperation extends ProcessMenuOperation {
    constructor(menuContext: MenuContext) {
        super(menuContext);
    }

    doAction(): void {
        Log.info(TAG, 'delete doAction');
        if (this.menuContext == null) {
            Log.warn(TAG, 'menuContext is null, return');
            return;
        }

        let dataSource: ItemDataSource = this.menuContext.dataSource;
        if (dataSource == null) {
            this.count = this.menuContext.items.length;
        } else {
            this.count = dataSource.getSelectedCount();
        }
        if (this.count <= 0) {
            Log.warn(TAG, 'count <= 0, return');
            return;
        }

        this.confirmCallback = this.confirmCallback.bind(this);
        this.cancelCallback = this.cancelCallback.bind(this);

        let resource: Resource = this.getDeleteMessageResource(dataSource);
        let deleteResource: Resource = this.menuContext.albumId == MediaConstants.ALBUM_ID_RECYCLE ? $r('app.string.dialog_recycle') : $r('app.string.dialog_delete');
        this.menuContext.broadCast.emit(BroadcastConstants.SHOW_DELETE_DIALOG, [resource, deleteResource, this.confirmCallback, this.cancelCallback]);
    }

    getResourceFromBrowser(): Resource {
        return this.menuContext.albumId == MediaConstants.ALBUM_ID_RECYCLE ? $r('app.string.recycle_single_file_tips') : $r('app.string.delete_single_file_tips')
    }

    getResourceFromGrid(dataSource: ItemDataSource): Resource {
        if (dataSource && dataSource.isSelect()) {
            return this.menuContext.albumId == MediaConstants.ALBUM_ID_RECYCLE ? $r('app.string.recycle_all_files_tips') : $r('app.string.delete_all_files_tips');
        } else if (this.count == 1) {
            return this.menuContext.albumId == MediaConstants.ALBUM_ID_RECYCLE ? $r('app.string.recycle_single_file_tips') : $r('app.string.delete_single_file_tips');
        } else {
            return this.menuContext.albumId == MediaConstants.ALBUM_ID_RECYCLE ? $r('app.string.recycle_files_tips', this.count) : $r('app.string.delete_files_tips', this.count);
        }
    }

    getDeleteMessageResource(dataSource: ItemDataSource): Resource {
        let resource: Resource;
        if (this.menuContext.deletePageFromType == BroadcastConstants.DELETE_FROM_BROWSER) {
            resource = this.getResourceFromBrowser();
        } else {
            resource = this.getResourceFromGrid(dataSource);
        }
        return resource;
    }

    confirmCallback(): void {
        Log.info(TAG, 'Batch delete confirm');
        AppStorage.SetOrCreate("isDelete", 1);

        // 1. Variable initialization
        this.onOperationEnd = this.menuContext.onOperationEnd;

        // 2. onDeleteStart exit selection mode
        let onOperationStart: Function = this.menuContext.onOperationStart;
        onOperationStart && onOperationStart();

        this.menuContext.broadCast.emit(BroadcastConstants.DELETE_PROGRESS_DIALOG,
            [$r('app.string.action_delete'), this.count]);

        // 3. selectManager gets the URI of the data and starts processing deletion in the callback
        let dataSource: ItemDataSource = this.menuContext.dataSource;
        if (dataSource == null) {
            this.items = this.menuContext.items;
        } else {
            this.items = dataSource.getSelectedItems();
        }
        this.processOperation();
    }

    requestOneBatchOperation() {
        let item = this.items[this.currentBatch] as MediaDataItem;
        if (item) {
            item.onDelete().then(() => {
                this.currentBatch++;
                this.menuContext.broadCast.emit(BroadcastConstants.UPDATE_PROGRESS, [this.getExpectProgress(), this.currentBatch]);
                this.cyclicOperation();
            })
        }
    }

    cancelCallback(): void {
        Log.info(TAG, 'Batch delete cancel');
    }
}