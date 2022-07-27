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

import {Logger} from '../../utils/Logger'
import {SelectManager} from '../../../../common/model/browser/SelectManager'
import {MenuContext} from '../../../../common/view/browserOperation/MenuContext'
import {BrowserOperationFactory} from '../../../../common/interface/BrowserOperationFactory'
import {ProcessMenuOperation} from '../../../../common/view/browserOperation/ProcessMenuOperation';
import {AlbumDefine} from '../../../../common/model/browser/AlbumDefine'
import {BroadCastConstants} from '../../../../common/model/common/BroadCastConstants';

export class BatchRecoverMenuOperation extends ProcessMenuOperation {
    logger: Logger = new Logger('BatchRecoverMenuOperation');

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

        this.onOperationEnd = this.menuContext.onOperationEnd;
        if (this.menuContext.albumId == AlbumDefine.ALBUM_ID_RECYCLE) {
            this.menuContext.selectManager.getDeleteSelection(this);
        } else {
            this.menuContext.selectManager.getSelection(this);
        }
        let onOperationStart: Function = this.menuContext.onOperationStart;
        onOperationStart && onOperationStart();

        this.menuContext.broadCast.emit(BroadCastConstants.DELETE_PROGRESS_DIALOG,
            [$r('app.string.action_recover'), this.count]);

    }

    // Asynchronous callback for getSelection
    callback(uris: string[]): void {
        if (this.isCancelled) {
            return;
        }
        this.uris = uris;
        this.processOperation();
    }

    // Delete a batch of data
    requestOneBatchOperation(): void {
        if (this.isCancelled) {
            return;
        }
        this.currentBatch++;
        let startIndex = (this.currentBatch - 1) * this.BATCH_SIZE;
        let endIndex = this.currentBatch * this.BATCH_SIZE;
        let batchUris: string[] = this.uris.slice(startIndex, Math.min(endIndex, this.uris.length));
        let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);

        operationImpl.trash(batchUris[0], false).then(()=>{
            this.onCompleted()
        }).catch((error)=>{
            this.logger.error(`recover error: ${error}`);
            this.onError();})
    }
}