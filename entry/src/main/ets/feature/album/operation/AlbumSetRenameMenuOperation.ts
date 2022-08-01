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

import { Logger } from '../../../common/utils/Logger';
import { BroadCastConstants } from '../../../common/model/common/BroadCastConstants';
import { MenuOperationCallback } from '../../../common/view/browserOperation/MenuOperationCallback'
import { MenuOperation } from '../../../common/view/browserOperation/MenuOperation'
import { MenuContext } from '../../../common/view/browserOperation/MenuContext'
import { SelectManager } from '../../../common/model/browser/SelectManager'
import { BrowserOperationFactory } from '../../../common/interface/BrowserOperationFactory'
import { BrowserDataFactory } from '../../../common/interface/BrowserDataFactory'
import { UiUtil } from '../../../common/utils/UiUtil'

export class AlbumSetRenameMenuOperation implements MenuOperation, MenuOperationCallback {
    private menuContext: MenuContext;
    private logger: Logger = new Logger('AlbumSetRenameMenuOperation');
    private sourceAlbum;
    private onOperationEnd: Function;
    private dataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_ALBUM);

    constructor(menuContext: MenuContext) {
        this.menuContext = menuContext;
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
        let count = this.menuContext.selectManager.clickedSet.size;
        if (count != 1) {
            this.logger.error('count != 1, return');
            return;
        }

        let result = [];
        result = Array.from(this.menuContext.selectManager.clickedSet);

        this.confirmCallback = this.confirmCallback.bind(this);
        this.cancelCallback = this.cancelCallback.bind(this);

        this.dataImpl.getDataById(result[0]).then((album) => {
            this.sourceAlbum = album;
            this.logger.info(`The name of clicked album is ${this.sourceAlbum.albumName}`);

            this.menuContext.broadCast.emit(BroadCastConstants.SHOW_RENAME_PHOTO_DIALOG,
                [this.sourceAlbum.albumName, this.confirmCallback, this.cancelCallback]);
        });
    }

    private async confirmCallback(newName: string) {
        this.logger.info(`AlbumSet rename confirm and the new name is: ${newName}`);

        this.onOperationEnd = this.menuContext.onOperationEnd;
        let onOperationStart: Function = this.menuContext.onOperationStart;
        onOperationStart && onOperationStart();

        this.rename(newName);
    }

    private async rename(name) {
        let optImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_ALBUM);
        try {
            let targetAlbum = await this.dataImpl.getDataByName(name, this.sourceAlbum);
            if (targetAlbum) {
                UiUtil.showToast($r('app.string.name_already_use'));
                this.onError();
                return;
            }

            await optImpl.setName(this.sourceAlbum, name);
            await optImpl.commitChanges(this.sourceAlbum);

            this.onCompleted();
        } catch (error) {
            this.logger.error(`AlbumSet rename failed: ${error}`);
            this.onError();
        }
    }

    private cancelCallback(): void {
        this.logger.info('AlbumSet rename cancel');
    }

    onCompleted(): void{
        this.logger.info('Rename data succeed!');
        this.onOperationEnd && this.onOperationEnd();
    }

    onError(): void{
        this.logger.error('Rename data failed!');
        this.onOperationEnd && this.onOperationEnd();
    }
}