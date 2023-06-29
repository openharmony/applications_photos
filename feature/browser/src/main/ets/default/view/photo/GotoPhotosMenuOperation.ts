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

import router from '@ohos.router';
import type { MenuContext, MenuOperation } from '@ohos/common';
import { Constants, JumpSourceToMain, Log, ScreenManager } from '@ohos/common';

const TAG: string = 'browser_GotoPhotosMenuOperation';

export class GotoPhotosMenuOperation implements MenuOperation {
  private menuContext: MenuContext;

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  doAction(): void {
    if (this.menuContext == null) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    let jumpSourceToMain = this.menuContext.jumpSourceToMain;
    Log.info(TAG, `router to pages/index, jumpSource: ${jumpSourceToMain}`);
    let leftPos = ScreenManager.getInstance().isSidebar();
    let pageFrom = Constants.ENTRY_FROM.NORMAL;
    if (jumpSourceToMain == JumpSourceToMain.CAMERA) {
      pageFrom = Constants.ENTRY_FROM_CAMERA;
    }
    router.replaceUrl({
      url: 'pages/index',
      params: {
        jumpSource: jumpSourceToMain,
        pageFrom: pageFrom
      }
    });
  }
}