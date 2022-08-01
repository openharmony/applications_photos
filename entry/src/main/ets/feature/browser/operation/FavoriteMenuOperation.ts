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
import { MenuOperation } from '../../../common/view/browserOperation/MenuOperation'
import { MenuContext } from '../../../common/view/browserOperation/MenuContext'
import { Constants } from '../../../common/model/browser/photo/Constants'
import { BrowserOperationFactory } from '../../../common/interface/BrowserOperationFactory'

export class FavoriteMenuOperation implements MenuOperation {
    private menuContext: MenuContext;
    private logger: Logger = new Logger('FavoriteMenuOperation');

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

        this.changeFavor(mediaItem.id, mediaItem.isFavor);
        this.logger.info(`progressFavorite: ${mediaItem.isFavor}`);
    }

    private async changeFavor(id, requestState) {
        let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
        let result = await operationImpl.favor(id, requestState);
        this.menuContext.broadCast.emit(Constants.SET_FAVOR, [result]);
    }
}