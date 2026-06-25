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

import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { ToolBar } from '@ohos/browsercommon/src/main/ets/default/view/actionbar/ToolBar';
import lazy Curves from '@ohos.curves';
import lazy { BasePhotoBrowserController } from '../model/BasePhotoBrowserController';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { PhotoConfig } from '@ohos/common/src/main/ets/default/config/PhotoConfig';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { display } from '@kit.ArkUI';

const TAG: string = 'browser_ToolBarView';

const BLANK_BOTTOM_INDEX: number = 3;

/**
 * 大图页底部工具栏组件，包含收藏、删除、分享等按钮
 */
@Component
export struct ToolBarView {
  @Consume browserController: BasePhotoBrowserController;
  @Consume @Watch('onShowChanged') isShowBar: boolean;
  @State @Watch('opacityValueChanged') opacityValue: number = 1;
  @State isVisibility: boolean = true;
  @State currentBackgroundColor: Resource = ActionBarProp.PHOTO_BROWSER_ACTIONBAR_BACKGROUND_COLOR;
  @StorageLink('isSplitMode') isSplitMode: boolean = getScreen().isSplitMode();
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('leftBlank') leftBlank: number[] = [0, getScreen()
    .getStatusBarHeight(), 0, getScreen().getNaviBarHeight()];
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldDisplayModeChanged') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @State private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  public noAnimation: boolean = true;
  @Consume hidePopup: boolean;
  private isFromPhotoBrowser: boolean = false;
  @Prop private moreMenuList: Action[] = [];
  @Prop private showMovingPhotoCloseEffect: boolean = false;
  @Prop private movingPhotoEffectMode?: number = 0;
  @Link isSlideBarShow: boolean;

  aboutToAppear(): void {
    Log.debug(TAG, `isShowBar=${this.isShowBar}, isHorizontal=${this.isHorizontal}`);
    this.isVisibility = this.isShowBar && !this.isHorizontal;
    this.opacityValue = this.isShowBar ? 1 : 0;
    // verde外屏遮挡问题维测
    /* instrument ignore next */
    if (DeviceInfo.isPhoneVde()) {
      Log.info(TAG, `toolBar stack isVerdeFold: ${this.isVerdeFoldable} bottom margin: ${this.leftBlank[BLANK_BOTTOM_INDEX]}
          padding: ${this.diggingHoleCameraArea.bottom}`);
    }
  }

  opacityValueChanged(): void {
    Log.info(TAG, `opacityValueChanged ${this.opacityValue}`);
  }

  private onFoldDisplayModeChanged(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
  }

  onShowChanged(): void {
    Log.info(TAG, `onShowChanged isShowBar = ${this.isShowBar}`);
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
    }, (): void => {
      this.opacityValue = this.isShowBar ? 1 : 0;
    })
  }

  build() {
    if (this.isVisibility) {
      Stack() {
        ToolBar({
          onMenuClicked: (action: Action): void => this.browserController.onMenuClicked(action),
          isFromPhotoBrowser: this.isFromPhotoBrowser,
          moreMenuList: this.moreMenuList,
          showMovingPhotoCloseEffect: this.showMovingPhotoCloseEffect,
          movingPhotoEffectMode: this.movingPhotoEffectMode,
        })
      }
      .margin({
        // bottom: 0,
        bottom: this.isFromPhotoBrowser ? 30 : 0,
      })
      .opacity(this.opacityValue)
      .width(Constants.PERCENT_100)
      .visibility(this.isVisibility ? Visibility.Visible : Visibility.Hidden)
      .backgroundColor(!this.isSlideBarShow ? this.currentBackgroundColor : Color.Transparent)
      .padding({
        bottom: this.isVerdeFoldable ? 0 : this.diggingHoleCameraArea.bottom,
      })
    } else {
      //PC适配畅联播放和声音按钮，5.1日落
      if (this.isHorizontal && PhotoConfig.isFromMeetime) {
        Stack() {
          ToolBar({
            onMenuClicked: (action: Action): void => this.browserController.onMenuClicked(action),
            isFromPhotoBrowser: this.isFromPhotoBrowser,
            moreMenuList: this.moreMenuList,
            showMovingPhotoCloseEffect: this.showMovingPhotoCloseEffect,
            movingPhotoEffectMode: this.movingPhotoEffectMode,
          })
        }
        .margin({
          bottom: this.isFromPhotoBrowser ? this.leftBlank[BLANK_BOTTOM_INDEX] : 0,
        })
        .opacity(this.opacityValue)
        .width(Constants.PERCENT_100)
        .backgroundColor(DeviceInfo.isPc() ? Color.Transparent : this.currentBackgroundColor)
        .padding({
          bottom: this.isVerdeFoldable ? 0 : this.diggingHoleCameraArea.bottom,
        })
      }
    }
  }
}