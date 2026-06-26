/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import lazy { Log } from '../../../default/utils/Log';
import type { MenuOperation } from '../../../default/view/browserOperation/MenuOperation';
import type { MenuContext } from '../../../default/view/browserOperation/MenuContext';
import type { Router } from '@ohos.arkui.UIContext';
import lazy { getScreen } from '../../../default/model/common/ScreenManager';
import lazy { JumpSourceToMain } from '../../../default/model/browser/photo/JumpSourceToMain';
import lazy { Constants } from '../../../default/model/common/Constants';

/* instrument ignore file */
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
    let leftPos = getScreen().isSidebar();
    let pageFrom = Constants.ENTRY_FROM.NORMAL;
    let isFromFACard = false;
    if (jumpSourceToMain === JumpSourceToMain.CAMERA) {
      pageFrom = Constants.ENTRY_FROM_CAMERA;
    } else if (jumpSourceToMain === JumpSourceToMain.PETALCLIP_VIDEO) {
      pageFrom = Constants.ENTRY_FROM_PETALCLIP;
    } else if (jumpSourceToMain === JumpSourceToMain.FORM_ABILITY_PHOTO_BROWSER) {
      pageFrom = Constants.ENTRY_FROM_FORM_ABILITY;
      isFromFACard = true;
    }
    Log.info(TAG, `router to pages/index, jumpSource: ${this.menuContext.albumInfo}`);
    (AppStorage.get<Router>('router'))?.replaceUrl({
      url: 'MainAbility/view/index',
      params: {
        jumpSource: jumpSourceToMain,
        pageFrom: pageFrom,
        isFromFACard: isFromFACard,
      }
    });
  }
}