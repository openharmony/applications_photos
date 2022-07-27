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
import {SelectManager} from '../../../../common/model/browser/SelectManager'
import {MenuContext} from '../../../../common/view/browserOperation/MenuContext'
import {BroadCastConstants} from '../../../../common/model/common/BroadCastConstants';
import {BatchDeleteMenuOperation} from '../../../../common/view/browserOperation/BatchDeleteMenuOperation';

export class ClearRecycleMenuOperation extends BatchDeleteMenuOperation {

    logger: Logger = new Logger('ClearRecycleMenuOperation');

    constructor(menuContext: MenuContext) {
        super(menuContext);
    }

    doAction(): void{
        if (this.menuContext == null) {
            this.logger.error('menuContext is null, return');
            return;
        }
        let selectManager: SelectManager = this.menuContext.selectManager;
        if (selectManager == null) {
            this.logger.error('selectManager is null, return');
            return;
        }
        selectManager.selectAll(true);
        this.count = selectManager.getSelectedCount();
        if (this.count <= 0) {
            this.logger.error('count <= 0, return');
            return;
        }

        this.confirmCallback = this.confirmCallback.bind(this);
        this.cancelCallback = this.cancelCallback.bind(this);


        this.menuContext.broadCast.emit(BroadCastConstants.SHOW_DELETE_DIALOG,
            [$r('app.string.recycleAlbum_clear_message'), this.confirmCallback, this.cancelCallback]);
    }

    cancelCallback(): void {
        this.logger.info('Batch delete cancel');
        this.menuContext.selectManager.unselectAll();
    }
}