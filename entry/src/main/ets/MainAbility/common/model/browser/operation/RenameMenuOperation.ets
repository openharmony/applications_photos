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
import {BroadCastConstants} from '../../common/BroadCastConstants.ets';
import {MenuOperationCallback} from './MenuOperationCallback'
import {MenuOperation} from './MenuOperation'
import {MenuContext} from './MenuContext'
import {BrowserOperationFactory} from "../interface/BrowserOperationFactory.ets"
import {Constants} from '../photo/Constants'
import {UiUtil} from '../../../utils/UiUtil.ets';

export class RenameMenuOperation implements MenuOperation, MenuOperationCallback {
    private menuContext: MenuContext;
    private albumName: string;
    private logger: Logger = new Logger('RenameMenuOperation');

    constructor(menuContext: MenuContext) {
        this.menuContext = menuContext;
        this.albumName = this.menuContext.albumName;
    }

    doAction(): void{
        if (this.menuContext == null) {
            this.logger.error('menuContext is null, return');
            return;
        }
        let mediaItem = this.menuContext.mediaItem;
        if (mediaItem == null) {
            this.logger.error('mediaItem is null, return');
            return;
        }

        this.confirmCallback = this.confirmCallback.bind(this);
        this.cancelCallback = this.cancelCallback.bind(this);
        let fileName = '';
        if (mediaItem.title){
            fileName = mediaItem.title;
        } else {
            let index = mediaItem.displayName.lastIndexOf('.');
            fileName = mediaItem.displayName.substr(0, index)
        }

        this.menuContext.broadCast.emit(BroadCastConstants.SHOW_RENAME_PHOTO_DIALOG,
            [fileName, this.confirmCallback, this.cancelCallback]);
    }

    onCompleted(): void {
        this.logger.info('Rename data succeed!');
    }
    
    onError(): void {
        this.logger.error('Rename data failed!');
    }

    private async confirmCallback(title: string) {
        this.logger.info(`Rename confirm new name: ${title}`);
        let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
        let mediaItem = this.menuContext.mediaItem;
        if (mediaItem == null) {
            this.logger.error('mediaItem is null, return');
            return;
        }
        let id = mediaItem.id;

        let hasSameName = await operationImpl.hasSameNameAsset(mediaItem.id, title);
        if (hasSameName) {
            this.logger.info('show find same file dialog');
            UiUtil.showToast($r('app.string.name_already_use'));
            return;
        }
        let result = await operationImpl.renameSinglePhoto(id, title);
        this.logger.info(`Rename confirm result: ${result}`);
        this.menuContext.broadCast.emit(Constants.RENAME, [result]);
    }

    private cancelCallback(): void {
        this.logger.info('Rename cancel');
    }
}