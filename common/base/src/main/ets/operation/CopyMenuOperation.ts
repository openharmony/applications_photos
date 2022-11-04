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
import { MediaConstants } from '../constants/MediaConstants';
import { Log } from '../utils/Log';
import { MenuContext } from './MenuContext';
import { ProcessMenuOperation, FindSameOperation } from './ProcessMenuOperation';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import mediaModel from '../model/MediaModel';
import { MediaOperationType } from '../data/MediaOperationType';
import { startTraceWithTaskId, finishTraceWithTaskId } from '../utils/TraceControllerUtils';
import { ItemDataSource } from '../vm/ItemDataSource';
import { MediaDataItem } from '../data/MediaDataItem';
import { SimpleAlbumDataItem } from '../data/SimpleAlbumDataItem';

const TAG = "CopyMenuOperation"

export class CopyMenuOperation extends ProcessMenuOperation {
    private albumInfo: SimpleAlbumDataItem;

    constructor(menuContext: MenuContext) {
        super(menuContext);
        this.albumInfo = menuContext.albumInfo;
    }

    doAction(): void {
        Log.info(TAG, 'copy doAction');
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

        this.onOperationEnd = this.menuContext.onOperationEnd;
        let onOperationStart = this.menuContext.onOperationStart;

        onOperationStart && onOperationStart();

        if (this.menuContext.deviceId) {
            this.menuContext.broadCast.emit(BroadcastConstants.SHOW_PROGRESS_DIALOG,
                [$r('app.string.download_progress_message'),
                MediaOperationType.Copy, this.cancelFunc.bind(this)]);
        } else {
            this.menuContext.broadCast.emit(BroadcastConstants.SHOW_PROGRESS_DIALOG,
                [$r('app.string.copy_progress_message', this.albumInfo.displayName),
                MediaOperationType.Copy, this.cancelFunc.bind(this)]);
        }

        if (dataSource == null) {
            this.items = this.menuContext.items;
        } else {
            this.items = dataSource.getSelectedItems();
        }
        this.processOperation();
    }

    requestOneBatchOperation() {
        let item = this.items[this.currentBatch++] as MediaDataItem;
        this.copyOne(item);
    }

    private async copyOne(item: MediaDataItem) {
        if (this.menuContext.deviceId) {
            let path = await mediaModel.getPublicDirectory(MediaLib.DirectoryType.DIR_CAMERA) + MediaConstants.REMOTE_ALBUM_PATH + "/";
            this.albumInfo = new SimpleAlbumDataItem("", "", path, "", "");

        }
        let fileAsset = await item.loadFileAsset();
        let assets = await this.getFileCopyOrMoveInfo(fileAsset, this.albumInfo);
        if (this.menuContext.deviceId) {
            let displayName = assets.sourceAsset.displayName;
            let index = displayName.lastIndexOf('.');
            let start = displayName.lastIndexOf('_');
            displayName = `${displayName.slice(0, start)}_${new Date().getTime()}${displayName.slice(index)}`;
            this.copy(assets.sourceAsset, null, {
                mediaType: assets.sourceAsset.mediaType,
                name: displayName,
                path: this.albumInfo.relativePath
            });
            return;
        }
        if (assets.targetAsset) {
            if (assets.targetAsset.uri == assets.sourceAsset.uri) {
                Log.info(TAG, 'copy same fileAsset');
                this.onOperateContinue();
                return;
            }
            Log.info(TAG, 'show find same file dialog');
            switch (this.findSameOperation) {
                case FindSameOperation.NONE:
                    this.menuContext.broadCast.emit(BroadcastConstants.FIND_SAME_FILE_DIALOG,
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
                    Log.warn(TAG, `findSameOperation is error ${this.findSameOperation}`);
                    break;
            }
        } else {
            this.copy(assets.sourceAsset, null, {
                mediaType: assets.sourceAsset.mediaType,
                name: assets.sourceAsset.displayName,
                path: this.albumInfo.relativePath
            });
        }
    }

    async copy(source, target, param?) {
        try {
            if (!target) {
                startTraceWithTaskId('create', this.currentBatch);
                target = await mediaModel.createOne(param.mediaType, param.name, param.path);
                finishTraceWithTaskId('create', this.currentBatch);
                if (target == null) {
                    Log.warn(TAG, `Target file creat failed when copyFile!`);
                    this.onError();
                    return;
                }
            }
            startTraceWithTaskId('openWriteClose', this.currentBatch);
            await mediaModel.copyOne(source, target);
            finishTraceWithTaskId('openWriteClose', this.currentBatch);
            this.onCompleted();
        } catch (error) {
            finishTraceWithTaskId('create', this.currentBatch);
            Log.error(TAG, `copyFile is error ${error}`);
            this.onError();
        }
    }

    cancelFunc(): void {
        Log.info(TAG, `progress cancel`);
        this.onOperatePause();
        let cancelMessage = $r('app.string.copy_cancel_message', this.getExpectProgress().toString());

        if (this.menuContext.deviceId) {
            this.menuContext.broadCast && this.menuContext.broadCast.emit(BroadcastConstants.DOWNLOAD_CANCEL_OPERATE,
                [cancelMessage, this.onOperateContinue.bind(this), this.onOperateCancelled.bind(this)]);
        } else {
            this.menuContext.broadCast && this.menuContext.broadCast.emit(BroadcastConstants.CANCEL_OPERATE,
                [cancelMessage, this.onOperateContinue.bind(this), this.onOperateCancelled.bind(this)]);
        }
    }

    // Copy cancel callback
    onOperateContinue(): void {
        Log.info(TAG, 'Operate Continue');
        this.isPause = false;
        this.cyclicOperation();
    }
}