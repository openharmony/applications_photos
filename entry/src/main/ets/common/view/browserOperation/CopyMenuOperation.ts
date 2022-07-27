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
import { BroadCastConstants } from '../../model/common/BroadCastConstants';
import { SelectManager } from '../../model/browser/SelectManager'
import { BrowserOperationFactory } from '../../interface/BrowserOperationFactory'
import { MediaOperationType } from '../../model/common/MediaOperationType'
import { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import { AlbumDefine } from '../../model/browser/AlbumDefine'
import { TraceControllerUtils } from '../../utils/TraceControllerUtils';

export class CopyMenuOperation extends ProcessMenuOperation {
    logger: Logger = new Logger('CopyMenuOperation');
    albumInfo: AlbumInfo;
    operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);

    constructor(menuContext: MenuContext) {
        super(menuContext);
        this.albumInfo = menuContext.albumInfo;
        if (this.menuContext.deviceId) {
            this.albumInfo = new AlbumInfo('', '', '', '', 0, '', AlbumDefine.genAlbumRelativePath(AlbumDefine.REMOTE_ALBUM_PATH))
        }
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

        if (this.menuContext.deviceId) {
            this.menuContext.broadCast.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
                [$r('app.string.download_progress_message'),
                MediaOperationType.Copy, this.cancelFunc.bind(this)]);
        } else {
            this.menuContext.broadCast.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
                [$r('app.string.copy_progress_message', this.albumInfo.displayName),
                MediaOperationType.Copy, this.cancelFunc.bind(this)]);
        }
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
        this.logger.info(`requestOneBatchOperation ${JSON.stringify(this.albumInfo)}`);

        TraceControllerUtils.startTraceWithTaskId('getFileCopyOrMoveInfo', this.currentBatch);
        this.getFileCopyOrMoveInfo(batchUris[0], this.albumInfo, this.menuContext.deviceId).then((assets) => {
            TraceControllerUtils.finishTraceWithTaskId('getFileCopyOrMoveInfo', this.currentBatch);
            if (this.menuContext.deviceId) {
                let displayName = assets.sourceAsset.displayName;
                let index = displayName.lastIndexOf('.');
                displayName = `${displayName.slice(0, index)}${new Date().getTime()}${displayName.slice(index)}`;
                this.copy(assets.sourceAsset, null, {
                    mediaType: assets.sourceAsset.mediaType,
                    name: displayName,
                    path: this.albumInfo.relativePath
                });
                return;
            }

            if (assets.targetAsset) {
                if (assets.targetAsset.uri == assets.sourceAsset.uri) {
                    this.logger.info('copy same fileAsset');
                    this.onOperateContinue();
                    return;
                }
                this.logger.info('show find same file dialog');
                switch (this.findSameOperation) {
                    case FindSameOperation.NONE:
                        this.menuContext.broadCast.emit(BroadCastConstants.FIND_SAME_FILE_DIALOG,
                            [assets, this.count, () => {
                                this.copy(assets.sourceAsset, assets.targetAsset);
                            }, this.onOperateContinue.bind(this), this.onOperateCancelled.bind(this),
                            this.setFindSameOperation.bind(this)]);
                        break;
                    case FindSameOperation.REPLACE:
                        this.copy(assets.sourceAsset, assets.targetAsset);
                        break;
                    case FindSameOperation.SKIP:
                        this.onOperateContinue();
                        break;
                    default:
                        this.logger.error(`findSameOperation is error ${this.findSameOperation}`);
                        break;
                }
            } else {
                this.copy(assets.sourceAsset, null, {
                    mediaType: assets.sourceAsset.mediaType,
                    name: assets.sourceAsset.displayName,
                    path: this.albumInfo.relativePath
                });
            }
        });
    }

    async copy(source, target, param?) {
        try {
            if (!target) {
                TraceControllerUtils.startTraceWithTaskId('create', this.currentBatch)
                target = await this.operationImpl.create(param);
                if (target == null) {
                    this.logger.error(`Target file creat failed when copyFile!`);
                    this.onError();
                    return;
                }
                TraceControllerUtils.finishTraceWithTaskId('create', this.currentBatch);
            }
            TraceControllerUtils.startTraceWithTaskId('openWriteClose', this.currentBatch)
            await this.operationImpl.copy(source, target);
            TraceControllerUtils.finishTraceWithTaskId('openWriteClose', this.currentBatch)
            this.onCompleted();
        } catch (error) {
            this.logger.error(`copyFile is error ${error}`);
            this.onError();
        }
    }

    cancelFunc(): void {
        this.logger.info(`progress cancel`);
        this.onOperatePause();
        let cancelMessage = $r('app.string.copy_cancel_message', this.getExpectProgress().toString());

        if (this.albumInfo.deviceId) {
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
        this.cyclicOperation();
    }
}