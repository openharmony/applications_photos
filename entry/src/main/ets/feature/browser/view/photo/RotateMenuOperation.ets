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
import {Constants} from '../../../../common/model/browser/photo/Constants'
import {MenuOperation} from '../../../../common/view/browserOperation/MenuOperation'
import {MenuContext} from '../../../../common/view/browserOperation/MenuContext'
import {BrowserOperationFactory} from '../../../../common/interface/BrowserOperationFactory'
import {BrowserDataFactory} from '../../../../common/interface/BrowserDataFactory'

export class RotateMenuOperation implements MenuOperation {
    private menuContext: MenuContext;
    private logger: Logger = new Logger('RotateMenuOperation');

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
        let orientation = mediaItem.orientation;
        this.changeOrientation(mediaItem.id, orientation);
        this.logger.info(`changeOrientation: id: ${mediaItem.id} orientation: ${orientation}`);
    }

    private async changeOrientation(id, orientation) {
        this.logger.info('changeOrientation start');

        let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
        let dataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO);

        let fileAsset = await dataImpl.getDataById(id);
        operationImpl.setOrientation(fileAsset, orientation);
        await operationImpl.commitChanges(fileAsset);
        this.menuContext.broadCast.emit(Constants.ROTATE, [orientation]);
    }
}