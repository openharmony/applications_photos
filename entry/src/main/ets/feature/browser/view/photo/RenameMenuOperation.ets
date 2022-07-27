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
import {BroadCastConstants} from '../../../../common/model/common/BroadCastConstants';
import {MenuOperationCallback} from '../../../../common/view/browserOperation/MenuOperationCallback'
import {MenuOperation} from '../../../../common/view/browserOperation/MenuOperation'
import {MenuContext} from '../../../../common/view/browserOperation/MenuContext'
import {BrowserOperationFactory} from '../../../../common/interface/BrowserOperationFactory'
import {BrowserDataFactory} from '../../../../common/interface/BrowserDataFactory'
import {Constants} from '../../../../common/model/browser/photo/Constants'
import {UiUtil} from '../../../../common/utils/UiUtil';

export class RenameMenuOperation implements MenuOperation, MenuOperationCallback {
    private menuContext: MenuContext;
    private logger: Logger = new Logger('RenameMenuOperation');

    constructor(menuContext: MenuContext) {
        this.menuContext = menuContext;
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
        if (mediaItem.title) {
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
        let mediaItem = this.menuContext.mediaItem;
        if (mediaItem == null) {
            this.logger.error('mediaItem is null, return');
            return;
        }
        let id = mediaItem.id;

        let hasSameName = await this.hasSameNameAsset(mediaItem.id, title);
        if (hasSameName) {
            this.logger.info('show find same file dialog');
            UiUtil.showToast($r('app.string.name_already_use'));
            return;
        }
        try{
            let result = await this.rename(id, title);
            this.logger.info(`Rename confirm result: ${result}`);
            this.menuContext.broadCast.emit(Constants.RENAME, [result]);
        } catch(err) {
            this.logger.error(`Rename error: ${err}`);
            UiUtil.showToast($r('app.string.rename_failed'));
        }

    }

    async rename(id:any, name:any) {
        this.logger.info('renameSinglePhoto start');
        let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
        let dataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO);

        let fileAsset = await dataImpl.getDataById(id);
        operationImpl.setName(fileAsset, name);
        await operationImpl.commitChanges(fileAsset);

        return [fileAsset.title, fileAsset.displayName];
    }

    private async hasSameNameAsset(fileId: number, name: string) {
        this.logger.debug('hasSameNameAsset start');
        let dataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO);

        let fileAsset = await dataImpl.getDataById(fileId);
        let displayName = fileAsset.displayName;
        let index = displayName.lastIndexOf('.');
        displayName = name + displayName.slice(index);

        let fileAssetList = await dataImpl.getDataByName(displayName, {relativePath: fileAsset.relativePath});

        if (fileAssetList == null) {
            this.logger.debug('hasSameNameAsset is false');
            return false;
        }

        this.logger.debug('hasSameNameAsset true');
        return true;
    }

    private cancelCallback(): void {
        this.logger.info('Rename cancel');
    }
}