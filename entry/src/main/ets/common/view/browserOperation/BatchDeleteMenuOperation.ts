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

import { Logger } from '../../utils/Logger'
import { SelectManager } from '../../model/browser/SelectManager'
import { MenuContext } from './MenuContext'
import { BrowserOperationFactory } from '../../interface/BrowserOperationFactory'
import { BroadCastConstants } from '../../model/common/BroadCastConstants';
import { AlbumDefine } from '../../model/browser/AlbumDefine'
import { ProcessMenuOperation } from './ProcessMenuOperation';
import { TraceControllerUtils } from '../../utils/TraceControllerUtils';

export class BatchDeleteMenuOperation extends ProcessMenuOperation {
    logger: Logger = new Logger('BatchDeleteMenuOperation');

    constructor(menuContext: MenuContext) {
        super(menuContext);
    }

    doAction(): void{
        if (this.menuContext == null) {
            this.logger.error('menuContext is null, return');
            return;
        }
        let selectManager: SelectManager = this.menuContext.selectManager;
        if (selectManager == null) {
            this.logger.error('selectManager is null, return');
            return;
        }
        this.count = selectManager.getSelectedCount();
        if (this.count <= 0) {
            this.logger.error('count <= 0, return');
            return;
        }

        this.confirmCallback = this.confirmCallback.bind(this);
        this.cancelCallback = this.cancelCallback.bind(this);

        if (this.menuContext.albumId == AlbumDefine.ALBUM_ID_RECYCLE) {
            this.menuContext.broadCast.emit(BroadCastConstants.SHOW_DELETE_DIALOG,
                [$r('app.plural.recycleAlbum_delete_message', this.count), this.confirmCallback, this.cancelCallback]);
        } else {
            this.menuContext.broadCast.emit(BroadCastConstants.SHOW_DELETE_DIALOG,
                [selectManager.isAllSelected ? $r('app.string.recycle_all_files_tips') :
                     (this.count == 1 ? $r('app.string.recycle_single_file_tips') :
                     $r('app.string.recycle_files_tips', this.count)), this.confirmCallback, this.cancelCallback]);
        }
    }

    // Asynchronous callback for getSelection
    callback(uris: string[]): void {
        if (this.isCancelled) {
            return;
        }
        this.uris = uris;
        TraceControllerUtils.finishTrace('Batch delete confirm')
        this.processOperation();
    }

    // Delete a batch of data
    requestOneBatchOperation(): void {
        this.logger.info(`requestOneBatchOperation`);
        if (this.isCancelled) {
            return;
        }
        this.currentBatch++;
        let startIndex = (this.currentBatch - 1) * this.BATCH_SIZE;
        let endIndex = this.currentBatch * this.BATCH_SIZE;
        let batchUris: string[] = this.uris.slice(startIndex, Math.min(endIndex, this.uris.length));

        let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
        if (this.menuContext.albumId == AlbumDefine.ALBUM_ID_RECYCLE) {
            TraceControllerUtils.startTraceWithTaskId('delete', this.currentBatch)
            operationImpl.delete(batchUris[0]).then(() => {
                TraceControllerUtils.finishTraceWithTaskId('delete', this.currentBatch)
                this.onCompleted()
            }).catch((error) => {
                this.logger.error(`delete error: ${error}`);
                TraceControllerUtils.finishTraceWithTaskId('delete', this.currentBatch)
                this.onError();
            })
        } else {
            TraceControllerUtils.startTraceWithTaskId('trash', this.currentBatch)
            operationImpl.trash(batchUris[0], true).then(() => {
                TraceControllerUtils.finishTraceWithTaskId('trash', this.currentBatch)
                this.onCompleted()
            }).catch((error) => {
                this.logger.error(`delete error: ${error}`);
                TraceControllerUtils.finishTraceWithTaskId('trash', this.currentBatch)
                this.onError();
            })
        }
    }

    confirmCallback(): void {
        this.logger.info('Batch delete confirm');
        TraceControllerUtils.startTrace('Batch delete confirm')
        // 1. Variable initialization
        this.onOperationEnd = this.menuContext.onOperationEnd;
        // 2. selectManager gets the URI of the data and starts processing deletion in the callback
        if (this.menuContext.albumId == AlbumDefine.ALBUM_ID_RECYCLE) {
            this.menuContext.selectManager.getDeleteSelection(this);
        } else {
            this.menuContext.selectManager.getSelection(this);
        }

        // 3. onDeleteStart exit selection mode
        let onOperationStart: Function = this.menuContext.onOperationStart;
        onOperationStart && onOperationStart();

        this.menuContext.broadCast.emit(BroadCastConstants.DELETE_PROGRESS_DIALOG,
            [$r('app.string.action_delete'), this.count]);
    }

    cancelCallback(): void {
        this.logger.info('Batch delete cancel');
    }
}