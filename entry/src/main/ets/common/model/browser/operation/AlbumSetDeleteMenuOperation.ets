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

import {BroadCastConstants} from '../../common/BroadCastConstants.ets';
import {BrowserOperationFactory} from '../interface/BrowserOperationFactory.ets'
import {BrowserDataFactory} from '../interface/BrowserDataFactory.ets'
import {Logger} from '../../../utils/Logger.ets'
import {MenuContext} from './MenuContext'
import {MediaOperationType} from '../../common/MediaOperationType'
import {ProcessMenuOperation} from './ProcessMenuOperation.ets';
import {SelectManager} from '../SelectManager'
import { BrowserDataInterface } from '../interface/BrowserDataInterface';

export class AlbumSetDeleteMenuOperation extends ProcessMenuOperation {

    logger: Logger = new Logger('AlbumSetDeleteMenuOperation');

    videoCount: number;

    photoCount: number;

    dialogTitle: Resource;

    clickSetCount: number;

    constructor(menuContext: MenuContext) {
        super(menuContext);
    }

    doAction(): void {
        if (this.menuContext == null) {
            this.logger.error('menuContext is null, return');
            return;
        }
        let selectManager: SelectManager = this.menuContext.selectManager;
        if (selectManager == null) {
            this.logger.error('selectManager is null, return');
            return;
        }
        this.clickSetCount = selectManager.clickedSet.size;
        if (this.clickSetCount <= 0) {
            this.logger.error('clickSetCount <= 0, return');
            return;
        }

        let result = [];
        result = Array.from(selectManager.clickedSet);
        this.uris = result;

        this.confirmCallback = this.confirmCallback.bind(this);
        this.cancelCallback = this.cancelCallback.bind(this);
        this.dataCallback = this.dataCallback.bind(this);

        let albumDataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_ALBUM_SET);
        albumDataImpl.getData(this.dataCallback, this.uris);
    }

    private dataCallback(object) {
        this.logger.debug(`album delete callback coming`);
        this.uris = object.uris;
        this.videoCount = object.videoCount;
        this.photoCount = object.count - object.videoCount;
        this.count = this.uris.length

        this.logger.debug(`album delete uris: ${JSON.stringify(this.uris)} count:${this.count}`);

        if (this.clickSetCount == 1) {
            if (this.videoCount > 0 && this.photoCount > 0) {
                this.dialogTitle = $r('app.string.recycle_single_album_tips', this.photoCount, this.videoCount);
            }
            if (this.videoCount > 0 && this.photoCount <= 0) {
                this.dialogTitle = $r('app.string.recycle_single_album_with_videos_tips', this.videoCount);
            }
            if (this.videoCount <= 0 && this.photoCount > 0) {
                this.dialogTitle = $r('app.string.recycle_single_album_with_photos_tips', this.photoCount);
            }
        } else {
            if (this.videoCount > 0 && this.photoCount > 0) {
                this.dialogTitle = $r('app.string.recycle_albums_tips', this.clickSetCount, this.photoCount, this.videoCount);
            }
            if (this.videoCount > 0 && this.photoCount <= 0) {
                this.dialogTitle = $r('app.string.recycle_albums_with_videos_tips', this.clickSetCount, this.videoCount);
            }
            if (this.videoCount <= 0 && this.photoCount > 0) {
                this.dialogTitle = $r('app.string.recycle_albums_with_photos_tips', this.clickSetCount, this.photoCount);
            }
        }

        this.menuContext.broadCast.emit(BroadCastConstants.SHOW_DELETE_DIALOG,
            [this.dialogTitle, this.confirmCallback, this.cancelCallback]);
    }

    // Asynchronous callback for getSelection
    callback(): void {
        if (this.isCancelled) {
            return;
        }
        if (this.uris == null) {
            this.logger.error('Invalid callback data, uris is null!');
            return;
        }

        this.processOperation()
    }

    // Delete a batch of data
    requestOneBatchOperation(): void {
        if (this.isCancelled) {
            return;
        }
        this.currentBatch ++;
        let startIndex = (this.currentBatch - 1) * this.BATCH_SIZE;
        let endIndex = this.currentBatch * this.BATCH_SIZE;
        let batchUris: string[] = this.uris.slice(startIndex, Math.min(endIndex, this.uris.length));
        let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
        operationImpl.trash(batchUris[0], this);
    }

    private confirmCallback(): void {
        this.logger.info('AlbumSet delete confirm')
        // 1. Variable initialization
        this.onOperationEnd = this.menuContext.onOperationEnd;
        // 2. selectManager gets the URI of the data and starts processing deletion in the callback
        this.menuContext.selectManager.getSelection(this);
        // 3. onDeleteStart exit selection mode
        let onOperationStart: Function = this.menuContext.onOperationStart;
        onOperationStart && onOperationStart();

        this.menuContext.broadCast.emit(BroadCastConstants.DELETE_PROGRESS_DIALOG,
            [$r('app.string.action_delete'), this.count]);
    }

    private cancelCallback(): void {
        this.logger.info('AlbumSet delete cancel');
    }
}