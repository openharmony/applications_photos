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
  Action,
  ActionBarColorMode,
  ActionBarMode,
  ActionBarProp,
  BrowserConstants,
  Constants,
  Log,
  ScreenManager
} from '@ohos/common';
import { ActionBar } from '@ohos/common/CommonComponents';
import Curves from '@ohos.curves';

const TAG: string = 'browser_PhotoBrowserActionBar';

@Component
export struct PhotoBrowserActionBar {
  @Consume @Watch('onShowChanged') isShowBar: boolean;
  @State opacityValue: number = 1;
  @State isVisibility: boolean = true;
  @State currentBackgroundColor: Resource = ActionBarProp.NORMAL_BACKGROUND_COLOR;
  @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  onMenuClicked: Function = (): void => {};
  isVideoPage: boolean = false;
  @StorageLink('isHorizontal') isHorizontal: boolean =
    ScreenManager.getInstance().isHorizontal();
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @Consume @Watch('updateActionBarProp') menuList: Action[];
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;

  updateActionBarProp(): void {
    this.actionBarProp = this.createActionBar();
  }

  aboutToAppear(): void {
    this.actionBarProp = this.createActionBar();
  }

  onShowChanged(): void {
    if (this.isShowBar) {
      this.isVisibility = this.isShowBar;
    }

    animateTo({
      duration: BrowserConstants.IMMERSE_ANIM_DURATION,
      delay: this.isShowBar ? BrowserConstants.IMMERSE_ANIM_DELAY : 0,
      curve: this.isShowBar ? Curves.cubicBezier(0.6, 0.0, 0.6, 1.0) : Curves.cubicBezier(0.2, 0.0, 0.2, 1.0),
      onFinish: () => {
        if (!this.isShowBar) {
          this.isVisibility = this.isShowBar;
        }
      }
    }, () => {
      if (this.isShowBar) {
        this.opacityValue = 1;
      } else {
        this.opacityValue = 0;
      }
    })
  }

  build() {
    if (this.isVideoPage) {
      Stack() {
        if (this.isVideoPage) {
          Image($r('app.media.play_video_title_bar_mask'))
            .height($r('app.float.photo_browser_action_bar_cover_height'))
            .width('100%')
        }
        ActionBar({
          actionBarProp: $actionBarProp,
          onMenuClicked: this.onMenuClicked,
          isVideoPage: this.isVideoPage,
          isNeedPlaceholder: false
        })
      }
      .markAnchor({ x: Constants.PERCENT_0, y: Constants.PERCENT_0 })
      .position({ x: Constants.PERCENT_0, y: Constants.PERCENT_0 })
      .padding({
        top: this.isHorizontal ? Constants.NUMBER_0 : px2vp(this.statusBarHeight)
      })
      .visibility(this.isShowBar ? Visibility.Visible : Visibility.Hidden)
      .sharedTransition('PhotoBrowserActionBar', {
        zIndex: 1,
        type: SharedTransitionEffectType.Static,
        duration: BrowserConstants.SHARE_TRANSITION_DURATION, //  大图进出时间
        curve: BrowserConstants.PHOTO_TRANSITION_CURVE // 大图进出阻尼曲线参数
      })
    } else {
      Stack() {
        ActionBar({
          actionBarProp: $actionBarProp,
          onMenuClicked: this.onMenuClicked,
          isVideoPage: this.isVideoPage,
          isNeedPlaceholder: false,
          isFromPhotoBrowser: true
        })
      }
      .markAnchor({ x: Constants.PERCENT_0, y: Constants.PERCENT_0 })
      .position({ x: Constants.PERCENT_0, y: Constants.PERCENT_0 })
      .padding({
        top: this.isHorizontal ? Constants.NUMBER_0 : px2vp(this.statusBarHeight)
      })
      .visibility(this.isVisibility ? Visibility.Visible : Visibility.Hidden)
      .opacity(this.opacityValue)
      .backgroundColor(this.currentBackgroundColor)
      .sharedTransition('PhotoBrowserActionBar', {
        zIndex: 1,
        type: SharedTransitionEffectType.Static,
        duration: BrowserConstants.SHARE_TRANSITION_DURATION, //  大图进出时间
        curve: BrowserConstants.PHOTO_TRANSITION_CURVE // 大图进出阻尼曲线参数
      })
    }
  }

  private createActionBar(): ActionBarProp {
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setHasTabBar(false)
      .setLeftAction(Action.BACK)
      .setAlpha(ActionBarProp.PHOTO_BROWSER_ACTIONBAR_ALPHA)
      .setMode(ActionBarMode.TOP_MODE)
      .setColorMode(this.isVideoPage ? ActionBarColorMode.TRANSPARENT : ActionBarColorMode.NORMAL)
      .setMenuList(this.menuList);
    return actionBarProp;
  }
}