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
import {MenuOperation} from './MenuOperation'
import {MenuContext} from './MenuContext'
import {AsyncCallback} from '../../model/common/AsyncCallback'
import {SelectManager} from '../../model/browser/SelectManager';

export class ShareMenuOperation implements MenuOperation, AsyncCallback<string[]> {
    private menuContext: MenuContext;
    private logger: Logger = new Logger('ShareMenuOperation');
    private uris: string[];

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
        let count = selectManager.getSelectedCount();
        if (count <= 0) {
            this.logger.error('count <= 0, return');
            return;
        }

        selectManager.getSelection(this);
    }

    callback(uris: string[]): void {
        this.uris = uris;
        this.shareFileAsset();
    }

    shareFileAsset() {
        this.logger.info('shareFileAsset');
        globalThis.photosAbilityContext.startAbility({
            'action': 'com.huawei.intent.action.hwCHOOSER',
            'parameters': {
                'ability.want.params.INTENT': {
                    'action': 'ability.intent.SEND_DATA',
                    'type': '*/*',
                    'parameters': {
                        'ability.params.stream': this.uris
                    }
                }
            }
        }).then(() => {
            this.logger.debug('raul startAbility complete');
        }).catch((error) => {
            this.logger.error(`raul startAbility failed, error: ${JSON.stringify(error)}`);
        });
    }
}