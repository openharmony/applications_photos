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

import { BreakpointSystem, BrowserConstants, Constants } from '@ohos/common';
import { BrowserController } from '@ohos/common/CommonComponents';
import { ThirdSelectPhotoBrowserBase, ThirdSelectPhotoGridBase } from '@ohos/thirdselect';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';

let localStorage = LocalStorage.getShared();

// Third Select Album Page
@Entry(localStorage)
@Component
export struct ThirdSelectPhotoGridPage {
  @State pageStatus: boolean = false;
  @Provide albumId: string = '';
  @State @Watch('updateAnimationStatus') browserController: BrowserController = new BrowserController(true);
  @State isRunningAnimation: boolean = false;
  private onBackFunc: Function = (): void => {};
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();

  aboutToAppear() {
    if (localStorage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
      this.breakpointSystem.registerOrientationChange();
    }
  }

  aboutToDisappear() {
    if (localStorage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
      this.breakpointSystem.unregisterOrientationChange();
    }
  }

  onPageShow() {
    this.pageStatus = true;
  }

  onPageHide() {
    this.pageStatus = false;
  }

  onBackPress() {
    if (this.browserController.isBrowserShow) {
      this.browserController.browserBackFunc && this.browserController.browserBackFunc();
      return true;
    }
    if (this.onBackFunc) {
      this.onBackFunc();
      if (localStorage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
        let session = localStorage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
        session?.terminateSelf();
      }
      return true;
    }
    return false;
  }

  bindBackFunc(backFunc: Function): void {
    this.onBackFunc = backFunc;
  }

  build() {
    Stack() {
      Column() {
        ThirdSelectPhotoGridBase({
          pageStatus: this.pageStatus,
          backFuncBinder: (backFunc: Function): void => this.bindBackFunc(backFunc),
          browserController: this.browserController
        })
          .transition({ type: TransitionType.All, opacity: 0 })
      }

      if (this.browserController.isBrowserShow) {
        Column() {
          ThirdSelectPhotoBrowserBase({
            pageStatus: this.pageStatus,
            geometryTransitionEnable: true,
            isRunningAnimation: $isRunningAnimation,
            browserController: this.browserController
          })
        }
        .width('100%')
        .height('100%')

        // Opacity must change for TransitionEffect taking effect
        .transition(TransitionEffect.asymmetric(TransitionEffect.opacity(0.99), TransitionEffect.opacity(0.99)))
      }
    }
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.Pop, duration: BrowserConstants.PHOTO_GRID_ANIMATION_DURATION })
      .opacity(1)
    PageTransitionExit({ type: RouteType.Push, duration: BrowserConstants.PHOTO_GRID_ANIMATION_DURATION })
      .opacity(1)
  }

  private updateAnimationStatus() {
    this.isRunningAnimation = this.browserController.isAnimating;
  }
}
