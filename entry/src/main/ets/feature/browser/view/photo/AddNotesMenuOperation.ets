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
import {BroadCastConstants} from '../../../../common/model/common/BroadCastConstants'
import {MenuOperationCallback} from '../../../../common/view/browserOperation/MenuOperationCallback'
import {MenuOperation} from '../../../../common/view/browserOperation/MenuOperation'
import {MenuContext} from '../../../../common/view/browserOperation/MenuContext'
import {BrowserOperationFactory} from '../../../../common/interface/BrowserOperationFactory'

export class AddNotesMenuOperation implements MenuOperation, MenuOperationCallback {
    private menuContext: MenuContext;
    private logger: Logger = new Logger('AddNotesMenuOperation');

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

        this.confirmCallback = this.confirmCallback.bind(this);
        this.cancelCallback = this.cancelCallback.bind(this);

        this.menuContext.broadCast.emit(BroadCastConstants.SHOW_ADD_NOTES_PHOTO_DIALOG,
            [this.confirmCallback, this.cancelCallback]);
    }

    onCompleted(): void {
        this.logger.info('Add notes data succeed!');
    }
    
    onError(): void {
        this.logger.error('Add notes data failed!');
    }

    private async confirmCallback(text: string) {
        this.logger.info(`Add notes confirm new name: ${text}`);
        let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
        let mediaItem = this.menuContext.mediaItem
        if (mediaItem == null) {
            this.logger.error('Add notes is null, return');
            return;
        }
    }

    private cancelCallback(): void {
        this.logger.info('Add notes cancel');
    }
}