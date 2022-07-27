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
import { MenuContext } from './MenuContext'
import { ProcessMenuOperation, FindSameOperation } from './ProcessMenuOperation'
import { BrowserOperationFactory } from '../../interface/BrowserOperationFactory'
import { MediaOperationType } from '../../model/common/MediaOperationType'
import { SelectManager } from '../../model/browser/SelectManager';
import { BroadCastConstants } from '../../model/common/BroadCastConstants';
import { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import { TraceControllerUtils } from '../../utils/TraceControllerUtils';

export class MoveMenuOperation extends ProcessMenuOperation {
    logger: Logger = new Logger('MoveMenuOperation');
    albumInfo: AlbumInfo;

    constructor(menuContext: MenuContext) {
        super(menuContext);
        this.albumInfo = menuContext.albumInfo;
    }

    doAction(): void {
        this.logger.info('move doAction');
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
            if (mediaItem == null) {
                this.logger.error('mediaItem is null, return');
                return;
            }
            this.onOperationEnd = this.menuContext.onOperationEnd;
            this.callback([mediaItem.uri]);
        }

        this.menuContext.broadCast.emit(
            BroadCastConstants.SHOW_PROGRESS_DIALOG, [$r('app.string.move_progress_message', this.albumInfo.displayName),
        MediaOperationType.Move, this.cancelFunc.bind(this)]);
    }

    callback(uris: string[]): void {
        this.uris = uris;
        this.processOperation();
    }

    // Move a batch of data
    requestOneBatchOperation(): void {
        if (this.isCancelled) {
            return;
        }
        this.currentBatch++;
        let startIndex = (this.currentBatch - 1) * this.BATCH_SIZE;
        let endIndex = this.currentBatch * this.BATCH_SIZE;
        let batchUris: string[] = this.uris.slice(startIndex, Math.min(endIndex, this.uris.length));

        if (batchUris[0] == undefined) {
            this.onOperateContinue();
            return;
        }
        TraceControllerUtils.startTraceWithTaskId('getFileCopyOrMoveInfo', this.currentBatch);
        this.getFileCopyOrMoveInfo(batchUris[0], this.albumInfo).then((assets) => {
            TraceControllerUtils.finishTraceWithTaskId('getFileCopyOrMoveInfo', this.currentBatch);
            if (assets.targetAsset) {
                if (assets.targetAsset.uri == assets.sourceAsset.uri) {
                    this.logger.info('move same fileAsset');
                    this.onOperateContinue();
                    return;
                }
                this.logger.info('show find same file dialog');
                switch (this.findSameOperation) {
                    case FindSameOperation.NONE:
                        this.menuContext.broadCast.emit(BroadCastConstants.FIND_SAME_FILE_DIALOG,
                            [assets, this.count, () => {
                                this.move(assets.sourceAsset, this.albumInfo.relativePath, assets.targetAsset);
                            }, this.onOperateContinue.bind(this), this.onOperateCancelled.bind(this),
                            this.setFindSameOperation.bind(this)]);
                        break;
                    case FindSameOperation.REPLACE:
                        this.move(assets.sourceAsset, this.albumInfo.relativePath, assets.targetAsset);
                        break;
                    case FindSameOperation.SKIP:
                        this.onOperateContinue();
                        break;
                    default:
                        this.logger.error(`findSameOperation is error ${this.findSameOperation}`);
                        break;
                }
            } else {
                this.move(assets.sourceAsset, this.albumInfo.relativePath)
            }
        })
    }

    async move(file, path, targetFile?) {
        TraceControllerUtils.startTraceWithTaskId('move', this.currentBatch);
        let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
        try {
            if (targetFile) {
                await operationImpl.delete(targetFile.uri);
            }
            operationImpl.setRelativePath(file, path)
            await operationImpl.commitChanges(file);
            TraceControllerUtils.finishTraceWithTaskId('move', this.currentBatch);
            this.onCompleted();
        } catch (error) {
            this.logger.error(`move error: ${error}`)
            this.onError();
        }
    }

    cancelFunc(): void {
        this.logger.info(`progress cancel`);
        this.onOperatePause();
        let cancelMessage = $r('app.string.move_cancel_message', this.getExpectProgress().toString());
        this.menuContext.broadCast && this.menuContext.broadCast.emit(BroadCastConstants.CANCEL_OPERATE,
            [cancelMessage, this.onOperateContinue.bind(this), this.onOperateCancelled.bind(this)]);
    }

    // Move cancel callback
    onOperateContinue(): void {
        this.logger.info('Operate Continue');
        this.isPause = false;
        this.cyclicOperation();
    }
}