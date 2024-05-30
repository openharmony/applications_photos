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
import {
  Action,
  ActionBarMode,
  ActionBarProp,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  Constants,
  Log,
  MediaItem,
  BrowserConstants as PhotoConstants,
  ScreenManager,
  UiUtil
} from '@ohos/common';
import {
  ActionBar,
  PhotoItem
} from '@ohos/common/CommonComponents';

const TAG: string = 'DefaultPhotoPage';

// Default Photo Page
@Entry
@Component
export struct DefaultPhotoPage {
  @Provide pageFrom: number = Constants.ENTRY_FROM.NORMAL;
  @State broadCast: BroadCast = new BroadCast();
  @Provide('transitionIndex') currentIndex: number = Constants.NUMBER_0;
  @Provide moreMenuList: Action[] = [];
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  defaultMediaItem: MediaItem | undefined = undefined;
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @State backgroundColorResource: Resource = $r('app.color.default_background_color');
  @State isShowBar: boolean = true;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private readonly FORM_BG_WIDTH = 1152;
  private readonly FORM_BG_HEIGHT = 768;
  @State isRunningAnimation: boolean = false;
  @State isOnSwiperAnimation: boolean = false;
  @Provide hidePopup: boolean = false;
  private onToggleBarsFunc: Function = (): void => this.onToggleBars();
  private hideBarsFunc: Function = (): void => this.hideBars();

  onMenuClicked(action: Action) {
    Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
    if (action.actionID === Action.BACK.actionID) {
      router.replaceUrl({
        url: 'pages/index',
      });
    }
  }

  aboutToAppear(): void {
    if (!this.isShowBar) {
      ScreenManager.getInstance().setSystemUi(true);
    }
    this.defaultMediaItem = this.getDefaultMediaItem();
    this.actionBarProp
      .setLeftAction(Action.BACK)
      .setMode(ActionBarMode.STANDARD_MODE);
    this.broadCast.on(PhotoConstants.TOGGLE_BAR, this.onToggleBarsFunc);
    this.broadCast.on(PhotoConstants.HIDE_BARS, this.hideBarsFunc);
  }

  onPageShow() {
    this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
  }

  onToggleBars() {
    if (this.isShowBar) {
      this.hideBars();
    } else {
      this.showBars();
    }
    Log.info(TAG, `Toggle bars, isShowBar: ${this.isShowBar}`);
  }

  showBars(): void {
    if (!this.isShowBar) {
      this.isShowBar = true;
      this.backgroundColorResource = $r('app.color.default_background_color');
      ScreenManager.getInstance().setSystemUi(true);
    }
  }

  hideBars(): void {
    if (this.isShowBar) {
      this.isShowBar = false;

      this.backgroundColorResource = $r('app.color.black');
      ScreenManager.getInstance().setSystemUi(false);
    }
  }

  aboutToDisappear(): void {
    if (this.broadCast) {
      this.broadCast.off(PhotoConstants.TOGGLE_BAR, this.onToggleBarsFunc);
      this.broadCast.off(PhotoConstants.HIDE_BARS, this.hideBarsFunc);
    }
  }

  getDefaultMediaItem(): MediaItem {
    return new MediaItem()
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      PhotoItem({
        item: this.defaultMediaItem,
        mPosition: 1,
        thumbnail: 'common/pic/form_bg.png',
        transitionTag: 'default_id',
        broadCast: $broadCast,
        isRunningAnimation: $isRunningAnimation,
        isOnSwiperAnimation: $isOnSwiperAnimation,
        isDefaultFA: true
      })
      Column() {
        ActionBar({ actionBarProp: $actionBarProp, onMenuClicked: (action: Action): void =>
        this.onMenuClicked(action), isNeedPlaceholder: false })
      }
      .visibility(this.isShowBar ? Visibility.Visible : Visibility.Hidden)
      .padding({
        top: this.isHorizontal ? Constants.NUMBER_0 : px2vp(this.statusBarHeight)
      })
    }
    .backgroundColor(this.backgroundColorResource)
    .padding({
      top: this.leftBlank[1],
      bottom: this.leftBlank[3]
    })
  }
}
