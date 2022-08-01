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
import { MenuOperationCallback } from '../../../common/view/browserOperation/MenuOperationCallback'
import { MenuOperation } from '../../../common/view/browserOperation/MenuOperation'
import { MenuContext } from '../../../common/view/browserOperation/MenuContext'
import { BrowserOperationFactory } from '../../../common/interface/BrowserOperationFactory'
import { Constants } from '../../../common/model/browser/photo/Constants'

export class RecoverMenuOperation implements MenuOperation, MenuOperationCallback {
    private menuContext: MenuContext;
    private logger: Logger = new Logger('RecoverMenuOperation');

    constructor(menuContext: MenuContext) {
        this.menuContext = menuContext;
    }

    doAction(): void {
        if (this.menuContext == null) {
            this.logger.error('menuContext is null, return');
            return;
        }
        this.doRecover();
    }

    private async doRecover() {
        let mediaItem = this.menuContext.mediaItem;
        if (mediaItem == null) {
            this.logger.error('mediaItem is null, return');
            return;
        }
        let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
        try {
            await operationImpl.trash(mediaItem.uri, false);
            this.onCompleted()

        } catch (error) {
            this.logger.error(`recover error: ${error}`);
            this.onError();
        }

        this.menuContext.broadCast.emit(Constants.DELETE, []);
        this.logger.info('Single Recover confirm');
    }

    onCompleted(): void {
        this.logger.info('Recover data succeed!');
    }

    onError(): void {
        this.logger.error('Recover data failed!');
    }
}