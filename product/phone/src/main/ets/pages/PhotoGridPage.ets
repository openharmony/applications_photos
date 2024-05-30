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

import {
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  BrowserConstants,
  Constants,
  Log,
  ScreenManager
} from '@ohos/common';
import { BrowserController } from '@ohos/common/CommonComponents';
import { PhotoGridView } from '../view/PhotoGridView';
import { PhotoBrowserComponent } from '../view/PhotoBrowserComponent';
import { SelectPhotoBrowserView } from '../view/SelectPhotoBrowserView';
import { LEFT_BLANK } from '@ohos/thirdselect/src/main/ets/default/utils/ThirdSelectConstants';

const TAG: string = 'PhotoGridPage';
AppStorage.setOrCreate('photoGridPageIndex', Constants.INVALID);

// Album Page
@Entry
@Component
export struct PhotoGridPage {
  @State pageStatus: boolean = false;
  @Provide isSelectedMode: boolean = false;
  @Provide isShow: boolean = true;
  @State isRunningAnimation: boolean = false;
  @StorageLink(LEFT_BLANK) leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  @State @Watch('updateAnimationStatus') browserController: BrowserController = new BrowserController(true);
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  onPageShow(): void {
    this.pageStatus = true;
  }

  onPageHide(): void {
    this.pageStatus = false;
  }

  onBackPress(): boolean {
    if (this.browserController.isBrowserShow) {
      this.doPhotoBrowserViewBack();
      return true;
    }
    if (this.browserController.isSelectBrowserShow) {
      this.doSelectPhotoBrowserViewBack();
      return true;
    }

    if (this.isSelectedMode) {
      this.isSelectedMode = false;
      return true;
    }
    return false;
  }

  doSelectPhotoBrowserViewBack() {
    this.appBroadCast.emit(BroadCastConstants.SELECT_PHOTO_BROWSER_BACK_PRESS_EVENT, []);
  }

  doPhotoBrowserViewBack() {
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT, []);
  }

  build() {
    Stack() {
      Column() {
        PhotoGridView({
          pageStatus: this.pageStatus,
          browserController: this.browserController
        })
      }
      .padding({ bottom: this.leftBlank[3] })

      if (this.browserController.isBrowserShow) {
        Column() {
          PhotoBrowserComponent({
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

      if (this.browserController.isSelectBrowserShow) {
        Column() {
          SelectPhotoBrowserView({
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