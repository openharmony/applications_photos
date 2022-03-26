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
import {SelectManager} from '../SelectManager'
import {BrowserOperationFactory} from '../interface/BrowserOperationFactory.ets'
import {BrowserOperationInterface} from '../interface/BrowserOperationInterface'

export class AlbumSetRenameMenuOperation implements MenuOperation, MenuOperationCallback {
    private menuContext: MenuContext;
    private logger: Logger = new Logger('AlbumSetRenameMenuOperation');
    private clickedAlbumName: string;
    private onOperationEnd: Function;

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
        this.clickedAlbumName = result[0];
        this.logger.info(`The display name of clicked album is ${this.clickedAlbumName}`);

        this.confirmCallback = this.confirmCallback.bind(this);
        this.cancelCallback = this.cancelCallback.bind(this);

        this.menuContext.broadCast.emit(BroadCastConstants.SHOW_RENAME_PHOTO_DIALOG,
            [this.clickedAlbumName, this.confirmCallback, this.cancelCallback]);
    }

    private async confirmCallback(newName: string) {
        this.logger.info(`AlbumSet rename confirm and the new name is: ${newName}`);

        this.onOperationEnd = this.menuContext.onOperationEnd;
        let onOperationStart: Function = this.menuContext.onOperationStart;
        onOperationStart && onOperationStart();

        let opt: BrowserOperationInterface = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_ALBUM);
        await opt.rename(this.clickedAlbumName, newName);
        this.onCompleted();
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