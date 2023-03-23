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
import Want from '@ohos.application.Want';
import { Log } from '../utils/Log';
import { startAbility } from '../utils/AbilityUtils';
import type { MenuOperation } from './MenuOperation';
import { MenuContext } from './MenuContext';
import { ItemDataSource } from '../vm/ItemDataSource';

const TAG = "ShareMenuOperation"

export class ShareMenuOperation implements MenuOperation {
    private menuContext: MenuContext;
    private uris: string[];

    constructor(menuContext: MenuContext) {
        this.menuContext = menuContext;
    }

    doAction(): void {
        if (this.menuContext == null) {
            Log.warn(TAG, 'menuContext is null, return');
            return;
        }
        let dataSource: ItemDataSource = this.menuContext.dataSource;
        if (dataSource == null) {
            return;
        }
        this.uris = dataSource.getSelectedUris();
        this.shareFileAsset();
    }

    shareFileAsset() {
        Log.info(TAG, 'shareFileAsset');
        let want: Want = {
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
        }
        startAbility(want);
    }
}