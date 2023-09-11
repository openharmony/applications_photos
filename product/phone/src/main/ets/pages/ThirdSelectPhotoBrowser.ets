/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { BrowserConstants } from '@ohos/common';
import { BrowserController } from '@ohos/common/CommonComponents';
import { ThirdSelectPhotoBrowserBase } from '@ohos/thirdselect';

// third selection photoBrowser
@Entry
@Component
struct ThirdSelectPhotoBrowser {
  @State pageStatus: boolean = false;
  @State isRunningAnimation: boolean = false;
  @State browserController: BrowserController = new BrowserController(false);

  aboutToAppear() {
    this.browserController.browserParam = router.getParams();
  }

  onPageShow() {
    this.pageStatus = true;
  }

  onPageHide() {
    this.pageStatus = false;
  }

  build() {
    Column() {
      ThirdSelectPhotoBrowserBase({
        pageStatus: this.pageStatus,
        geometryTransitionEnable: false,
        isRunningAnimation: $isRunningAnimation,
        browserController: this.browserController
      })
    }
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: BrowserConstants.PAGE_SHOW_ANIMATION_DURATION })
      .opacity(0)
    PageTransitionExit({ duration: BrowserConstants.PAGE_SHOW_ANIMATION_DURATION })
      .opacity(0)
  }
}
