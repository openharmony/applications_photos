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

import router from '@system.router';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import type { MenuOperation } from '@ohos/base/src/main/ets/operation/MenuOperation';
import { MenuContext } from '@ohos/base/src/main/ets/operation/MenuContext';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import { JumpSourceToMain } from '@ohos/base/src/main/ets/data/JumpSourceToMain';
import { RouterConstants } from '@ohos/base/src/main/ets/constants/RouterConstants';

const TAG = "GotoPhotosMenuOperation"

export class GotoPhotosMenuOperation implements MenuOperation {
    private menuContext: MenuContext;

    constructor(menuContext: MenuContext) {
        this.menuContext = menuContext;
    }

    doAction(): void {
        if (this.menuContext == null) {
            Log.warn(TAG, 'menuContext is null, return');
            return;
        }
        let jumpSourceToMain = this.menuContext.jumpSourceToMain;
        Log.info(TAG, `router to pages/index, jumpSource: ${jumpSourceToMain}`);
        let leftPos = screenManager.isSidebar();
        let pageFrom = RouterConstants.ENTRY_FROM.NORMAL;
        if (jumpSourceToMain == JumpSourceToMain.CAMERA) {
            pageFrom = RouterConstants.ENTRY_FROM_CAMERA;
        }
        router.replace({
            uri: leftPos === true ? 'product/pad/view/index' : 'product/phone/view/index',
            params: {
                jumpSource: jumpSourceToMain,
                pageFrom: pageFrom
            }
        });
    }
}