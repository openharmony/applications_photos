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

import {MediaLibraryAccess} from '../../../access/MediaLibraryAccess.ets';
import {Logger} from '../../../utils/Logger.ets'
import {MenuOperationCallback} from './MenuOperationCallback'
import {MenuOperation} from './MenuOperation'
import {MenuContext} from './MenuContext'
import {BrowserOperationFactory} from '../interface/BrowserOperationFactory.ets'
import {BroadCastConstants} from '../../common/BroadCastConstants.ets';
import {AlbumDefine} from '../../browser/AlbumDefine.ets'
import {Constants} from '../photo/Constants'

export class DeleteMenuOperation implements MenuOperation, MenuOperationCallback {
    private menuContext: MenuContext;
    private logger: Logger = new Logger('DeleteMenuOperation');
    private isTrash = true;

    constructor(menuContext: MenuContext) {
        this.menuContext = menuContext;
    }

    doAction(): void {
        if (this.menuContext == null) {
            this.logger.error('menuContext is null, return');
            return;
        }
        let mediaItem = this.menuContext.mediaItem;
        if (mediaItem == null) {
            this.logger.error('mediaItem is null, return');
            return;
        }
        if (this.menuContext.albumName && this.menuContext.albumName == AlbumDefine.ALBUM_NAME_RECYCLE) {
            this.isTrash = false;
        }
        this.confirmCallback = this.confirmCallback.bind(this);
        this.cancelCallback = this.cancelCallback.bind(this);
        let message = mediaItem.mediaType == MediaLibraryAccess.MEDIA_TYPE_VIDEO
            ? $r('app.string.recycle_video_tips') : $r('app.string.recycle_picture_tips');
        if (!this.isTrash) {
            message = $r('app.string.recycleAlbum_delete_message');
        }
        this.menuContext.broadCast.emit(BroadCastConstants.SHOW_DELETE_DIALOG,
            [message, this.confirmCallback, this.cancelCallback]);
    }

    onCompleted(): void {
        this.logger.info('Delete data succeed!');
        this.menuContext.broadCast.emit(Constants.DELETE, []);
    }

    onError(): void {
        this.logger.error('Delete data failed!');
    }

    private async confirmCallback() {
        this.logger.info('Delete confirm');
        let mediaItem = this.menuContext.mediaItem;
        if (mediaItem == null) {
            this.logger.error('mediaItem is null, return');
            return;
        }
        let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
        if (this.isTrash) {
            await operationImpl.trash(mediaItem.uri, this);
        } else {
            await operationImpl.delete(mediaItem.uri, this);
        }
        this.logger.info('Single delete confirm');
    }

    private cancelCallback(): void {
        this.logger.info('Delete cancel');

    }
}