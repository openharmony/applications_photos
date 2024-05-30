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

import { Constants, Log } from '@ohos/common';
import { BrowserController } from '@ohos/common/CommonComponents';
import { TimelinePage } from '@ohos/timeline/TimelineComponents';
import { PhotoBrowserComponent } from './PhotoBrowserComponent';
import { SelectPhotoBrowserView } from './SelectPhotoBrowserView';

const TAG = 'TimelineTabContentComponent';

@Component
export struct TimelineTabContentComponent {
  @State pageStatus: boolean = false;
  @Prop currentIndex: number = 0;
  @Link isShowTabBar: boolean;
  @State @Watch('updateIndexStatus') browserController: BrowserController = new BrowserController(true);
  @State isRunningAnimation: boolean = false;
  @Link @Watch('onPhotoBrowserStatusChanged') isShowPhotoBrowser: boolean;
  @Link @Watch('onSelectPhotoBrowserStatusChanged') isShowSelectPhotoBrowser: boolean;
  @Consume @Watch('onShowStatusChanged') isShow: boolean;

  onShowStatusChanged() {
    this.pageStatus = this.isShow
    Log.error(TAG, 'this.pageStatus = ' + this.pageStatus +
      ', this.isShow = ' + this.isShow + ', this.isInCurrentTab() = ' + this.isInCurrentTab()
    );
  }

  onPhotoBrowserStatusChanged() {
    if (this.isInCurrentTab()) {
      this.isShowTabBar = !this.isShowPhotoBrowser;
    }
  }

  onSelectPhotoBrowserStatusChanged() {
    if (this.isInCurrentTab()) {
      this.isShowTabBar = !this.isShowSelectPhotoBrowser;
    }
  }

  build() {
    Stack() {
      TimelinePage({
        isInCurrentTab: this.isInCurrentTab(),
        browserController: this.browserController
      }).transition({ type: TransitionType.All, opacity: 1 })

      if (this.isInCurrentTab() && this.browserController.isBrowserShow) {
        Column() {
          PhotoBrowserComponent({
            pageStatus: this.pageStatus,
            geometryTransitionEnable: this.browserController.geometryTransitionEnable,
            isRunningAnimation: $isRunningAnimation,
            browserController: this.browserController
          })
        }
        .width('100%')
        .height('100%')

        // Opacity must change for TransitionEffect taking effect
        .transition(TransitionEffect.asymmetric(TransitionEffect.opacity(0.99), TransitionEffect.opacity(0.99)))
      }

      if (this.isInCurrentTab() && this.browserController.isSelectBrowserShow) {
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
    return this.currentIndex === Constants.TIMELINE_PAGE_INDEX;
  }
}