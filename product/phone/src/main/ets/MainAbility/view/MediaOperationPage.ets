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

import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaOperationBasePage } from '@ohos/common/src/main/ets/default/view/browserOperation/MediaOperationBasePage';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy common from '@ohos.app.ability.common';
import lazy { NavigationBroadCastManager } from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';

/* instrument ignore file */
const TAG: string = 'MediaOperationPage';

@Entry(LocalStorage.getShared())
@Component
struct MediaOperationPage {
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @Provide('navigationPageInfos') navigationPageInfos: NavPathStack = new NavPathStack();
  @Provide isShow: boolean = false;

  onBackPress() {
    Log.info(TAG, 'onBackPress');
    (LocalStorage.getShared()
      .get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext).terminateSelf();
  }

  onPageShow() {
    Log.info(TAG, 'MediaOperationPage onPageShow');
    this.isShow = true;
  }

  onPageHide(): void {
    Log.info(TAG, 'MediaOperationPage onPageHide');
    this.isShow = false;
  }

  aboutToAppear(): void {
    NavigationBroadCastManager.getInstance().getBroadCast().emitAsync(
      NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION]).then(() => {
      this.navigationPageInfos.pushPath(
        new NavPathInfo(NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION, []), false);
    });
  }

  @Builder
  PageMap(name: string, param: Object) {
    if (name === NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION) {
      MediaOperationBasePage()
    }
  }

  build() {
    Navigation(this.navigationPageInfos) {
      Column() {
      }
    }
    .hideTitleBar(true)
    .navDestination(this.PageMap)
    .mode(NavigationMode.Stack)
  }

  pageTransition() {
    PageTransitionExit({ duration: BrowserConstants.OPERATION_EXIT_ANIMATION_DURATION })
      .opacity(0)
      .slide(SlideEffect.Right)
  }
}