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

import { BrowserConstants, Constants, Log, ScreenManager } from '@ohos/common';
import { ToolBar } from '@ohos/common/CommonComponents';
import Curves from '@ohos.curves';

const TAG: string = 'browser_PhotoBrowserToolBar';
const TOOL_BAR_OPACITY_0: number = 0;
const TOOL_BAR_OPACITY_1: number = 1;

@Component
export struct PhotoBrowserToolBar {
  @Consume @Watch('onShowChanged') isShowBar: boolean;
  @State opacityValue: number = 1;
  @State isVisibility: boolean = true;
  @State currentBackgroundColor: Resource = $r('app.color.default_background_color');
  onMenuClicked: Function = (): void => {};
  @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  noAnimation: boolean = true;
  @Consume hidePopup: boolean;
  private isFromPhotoBrowser = false;

  aboutToAppear(): void {
    Log.debug(TAG, `isShowBar=${this.isShowBar}, isHorizontal=${this.isHorizontal}`);
    if (this.isShowBar && !this.isHorizontal) {
      this.isVisibility = true;
    } else {
      this.isVisibility = false;
    }
    this.opacityValue = this.isShowBar ? TOOL_BAR_OPACITY_1 : TOOL_BAR_OPACITY_0;
  }

  onShowChanged(): void {
    if (this.isShowBar && !this.isHorizontal) {
      this.isVisibility = this.isShowBar;
    }

    animateTo({
      duration: BrowserConstants.IMMERSE_ANIM_DURATION,
      delay: this.isShowBar ? BrowserConstants.IMMERSE_ANIM_DELAY : 0,
      curve: this.isShowBar ? Curves.cubicBezier(0.6, 0.0, 0.6, 1.0) : Curves.cubicBezier(0.2, 0.0, 0.2, 1.0),
      onFinish: () => {
        if (!this.isShowBar && !this.isHorizontal) {
          this.isVisibility = this.isShowBar;
        }
      }
    }, () => {
      this.opacityValue = this.isShowBar ? TOOL_BAR_OPACITY_1 : TOOL_BAR_OPACITY_0;
    })
  }

  build() {
    Stack() {
      ToolBar({
        onMenuClicked: this.onMenuClicked,
        isFromPhotoBrowser: this.isFromPhotoBrowser
      })
    }
    .padding({ bottom: this.leftBlank[3] })
    .width(Constants.PERCENT_100)
    .visibility(this.isVisibility ? Visibility.Visible : Visibility.Hidden)
    .opacity(this.opacityValue)
    .backgroundColor(this.currentBackgroundColor)
  }
}