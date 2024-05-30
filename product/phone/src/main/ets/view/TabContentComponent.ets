/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { AlbumSetPage } from '@ohos/browser/BrowserComponents';
import { PhotoGridView } from './PhotoGridView';
import { Constants, Log } from '@ohos/common';
import { BrowserController } from '@ohos/common/CommonComponents';
import { PhotoBrowserComponent } from './PhotoBrowserComponent';
import { SelectPhotoBrowserView } from './SelectPhotoBrowserView';

const TAG = 'TabContentComponent';

@Component
export struct TabContentComponent {
  @Prop pageStatus: boolean = false;
  @StorageLink('isShowPhotoGridView') isShowPhotoGridView: boolean = false;
  @Prop currentIndex: number = 0;
  @StorageLink('currentBreakpoint') currentBreakpoint: string = Constants.BREAKPOINT_MD;
  @Consume @Watch('onShowStatusChanged') isShow: boolean;
  @State @Watch('updateIndexStatus') browserController: BrowserController = new BrowserController(true);
  @Link isShowTabBar: boolean;
  @Link @Watch('onPhotoBrowserStatusChanged') isShowPhotoBrowser: boolean;
  @Link @Watch('onSelectPhotoBrowserStatusChanged') isShowSelectPhotoBrowser: boolean;
  @State isRunningAnimation: boolean = false;

  onShowStatusChanged() {
    this.pageStatus = this.isShow /*&& this.isInCurrentTab();*/
    Log.error(TAG, 'this.pageStatus = ' + this.pageStatus +
      ', this.isShow = ' + this.isShow + ', this.isInCurrentTab() = ' + this.isInCurrentTab()
    );
  }

  onPhotoBrowserStatusChanged() {
    if (this.isInCurrentTab()) {
      this.isShowTabBar = !this.isShowPhotoGridView && !this.isShowPhotoBrowser;
    }
  }

  onSelectPhotoBrowserStatusChanged() {
    if (this.isInCurrentTab()) {
      this.isShowTabBar = !this.isShowPhotoGridView && !this.isShowSelectPhotoBrowser;
    }
  }

  build() {
    Stack() {
      AlbumSetPage({
        isInCurrentTab: this.currentIndex === Constants.ALBUM_PAGE_INDEX
      })

      if (this.isShowPhotoGridView && this.currentBreakpoint != Constants.BREAKPOINT_LG) {
        PhotoGridView({
          pageStatus: this.pageStatus,
          browserController: this.browserController
        })
          .transition(TransitionEffect.opacity(0.99))
      }

      if (this.isInCurrentTab() && this.isShowPhotoBrowser) {
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

      if (this.isInCurrentTab() && this.isShowSelectPhotoBrowser) {
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

  private updateIndexStatus() {
    this.isShowPhotoBrowser = this.browserController.isBrowserShow;
    this.isShowSelectPhotoBrowser = this.browserController.isSelectBrowserShow;
    this.isRunningAnimation = this.browserController.isAnimating;
  }

  private isInCurrentTab(): boolean {
    return this.currentIndex === Constants.ALBUM_PAGE_INDEX;
  }
}