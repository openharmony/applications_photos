
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

import {Logger} from '../../../utils/Logger.ets'
import {MenuContext} from './MenuContext'
import {ProcessMenuOperation, FindSameOperation} from './ProcessMenuOperation'
import {BroadCastConstants} from '../../common/BroadCastConstants.ets';
import {SelectManager} from '../SelectManager.ets';
import {BrowserOperationFactory} from '../../browser/interface/BrowserOperationFactory.ets'
import {MediaOperationType} from '../../common/MediaOperationType'

export class CopyMenuOperation extends ProcessMenuOperation {
    logger: Logger = new Logger('CopyMenuOperation');
    albumName: string;

    constructor(menuContext: MenuContext) {
        super(menuContext);
        this.albumName = menuContext.albumName;
    }

    doAction(): void {
        this.logger.info('doAction');
        if (this.menuContext == null) {
            this.logger.error('menuContext is null, return');
            return;
        }

        if (this.menuContext.selectManager) {
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

            selectManager.getSelection(this);

            let onOperationStart: Function = this.menuContext.onOperationStart;
            onOperationStart && onOperationStart();
        } else {
            this.count = 1;
            let mediaItem = this.menuContext.mediaItem;
            this.onOperationEnd = this.menuContext.onOperationEnd;
            if (mediaItem == null) {
                this.logger.error('mediaItem is null, return');
                return;
            }
            this.callback([mediaItem.uri]);
        }

        this.logger.info(`this.albumName.displayName, ${this.albumName}`);

        if(this.menuContext.deviceId){
            this.menuContext.broadCast.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
                [$r('app.string.download_progress_message', this.albumName),
                MediaOperationType.Copy, this.cancelFunc.bind(this)]);
        } else {
            this.menuContext.broadCast.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
                [$r('app.string.copy_progress_message', this.albumName),
                MediaOperationType.Copy, this.cancelFunc.bind(this)]);
        }
    }

    callback(uris: string[]): void {
        this.uris = uris;
        this.albumName = this.menuContext.albumName;
        this.processOperation();
    }

    // Move a batch of data
    requestOneBatchOperation(): void {
        if (this.isCancelled) {
            return;
        }
        this.currentBatch ++;
        let startIndex = (this.currentBatch - 1) * this.BATCH_SIZE;
        let endIndex = this.currentBatch * this.BATCH_SIZE;
        let batchUris: string[] = this.uris.slice(startIndex, Math.min(endIndex, this.uris.length));
        let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);

        operationImpl.getExistTargetInTargetAlbum(batchUris[0], this.albumName, this.menuContext.deviceId).then((assets) => {
            if(assets) {
                if (this.menuContext.deviceId) {
                    operationImpl.copy(batchUris[0], this.albumName, this, false, this.menuContext.deviceId, true);
                    return;
                }
                if(assets.targetAsset.uri == assets.fileAsset.uri) {
                    this.logger.info('copy same fileAsset');
                    this.onOperateContinue();
                    return ;
                }
                this.logger.info('show find same file dialog');
                switch(this.findSameOperation) {
                    case FindSameOperation.NONE:
                        this.menuContext.broadCast.emit(BroadCastConstants.FIND_SAME_FILE_DIALOG,
                            [assets, this.count, () => {
                                operationImpl.copy(batchUris[0], this.albumName, this, true, this.menuContext.deviceId);
                            }, this.onOperateContinue.bind(this), this.onOperateCancelled.bind(this),
                            this.setFindSameOperation.bind(this)]);
                        break;
                    case FindSameOperation.REPLACE:
                        operationImpl.copy(batchUris[0], this.albumName, this, true, this.menuContext.deviceId);
                        break;
                    case FindSameOperation.SKIP:
                        this.onOperateContinue();
                        break;
                    default:
                        this.logger.error(`findSameOperation is error ${this.findSameOperation}`);
                        break;
                }
            } else {
                operationImpl.copy(batchUris[0], this.albumName, this, false, this.menuContext.deviceId);
            }
        });
    }

    cancelFunc(): void {
        this.logger.info(`progress cancel`);
        this.onOperatePause();
        let cancelMessage = $r('app.string.copy_cancel_message', this.getExpectProgress().toString());

        if(this.menuContext.deviceId){
            this.menuContext.broadCast && this.menuContext.broadCast.emit(BroadCastConstants.DOWNLOAD_CANCEL_OPERATE,
                [cancelMessage, this.onOperateContinue.bind(this), this.onOperateCancelled.bind(this)]);
        } else {
            this.menuContext.broadCast && this.menuContext.broadCast.emit(BroadCastConstants.CANCEL_OPERATE,
                [cancelMessage, this.onOperateContinue.bind(this), this.onOperateCancelled.bind(this)]);
        }
    }

    // Copy cancel callback
    onOperateContinue(): void {
        this.logger.info('Operate Continue');
        this.isPause = false;
        if(this.menuContext.deviceId){
            this.menuContext.broadCast.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
                [$r('app.string.download_progress_message', this.albumName),
                    MediaOperationType.Copy, this.cancelFunc.bind(this)]);
        } else {
            this.menuContext.broadCast.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
                [$r('app.string.copy_progress_message', this.albumName),
                    MediaOperationType.Copy, this.cancelFunc.bind(this)]);
        }
        this.cyclicOperation();
    }
}