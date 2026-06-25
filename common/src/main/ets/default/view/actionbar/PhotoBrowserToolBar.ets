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

import lazy { ActionBarProp } from '../../../default/view/browserOperation/ActionBarProp';
import lazy { Constants as BrowserConstants } from '../../../default/model/browser/photo/Constants';
import lazy { Constants } from '../../../default/model/common/Constants';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal,
} from '../../../default/model/common/ScreenManager';
import lazy { Log } from '../../../default/utils/Log';
import lazy { ToolBar } from '@ohos/browsercommon/src/main/ets/default/view/actionbar/ToolBar';
import lazy Curves from '@ohos.curves';
import lazy { DeviceInfo } from '../../../default/utils/DeviceInfo';
import lazy { Action } from '../../../default/view/browserOperation/Action';
import lazy { display } from '@kit.ArkUI';
import lazy performanceMonitor from '@ohos.arkui.performanceMonitor';

const TAG: string = 'browser_PhotoBrowserToolBar';


@Component
export struct PhotoBrowserToolBar {
  @Consume @Watch('onShowChanged') isShowBar: boolean;
  @State @Watch('opacityValueChanged') opacityValue: number = 1;
  @State isVisibility: boolean = true;
  @State currentBackgroundColor: Resource = ActionBarProp.PHOTO_BROWSER_ACTIONBAR_BACKGROUND_COLOR;
  @State isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  onMenuClicked: Function = (): void => {
  };
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldDisplayModeChanged') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink('isSplitMode') isSplitMode: boolean = getScreen().isSplitMode();
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('leftBlank') leftBlank: number[] = getScreen().getLeftBlank();
  public noAnimation: boolean = true;
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  @Consume hidePopup: boolean;
  private isFromPhotoBrowser = false;
  private isVisibilityText = false;
  @Prop private moreMenuList: Action[] = [];
  @Prop private showMovingPhotoCloseEffect: boolean = false;
  @Prop private movingPhotoEffectMode?: number = 0;

  opacityValueChanged(): void {
    Log.info(TAG, `opacityValueChanged ${this.opacityValue}`);
  }

  onFoldDisplayModeChanged() {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
  }

  aboutToAppear(): void {
    Log.debug(TAG, `isShowBar=${this.isShowBar}, isHorizontal=${this.isHorizontal}`);
    if (this.isShowBar && !this.isHorizontal) {
      this.isVisibility = true;
    } else {
      this.isVisibility = false;
    }
    this.opacityValue = this.isShowBar ? 1 : 0;
  }

  onShowChanged(): void {
    performanceMonitor.begin('CUSTOM_ANIMATOR onShowChanged', performanceMonitor?.ActionType.LAST_UP);
    if (this.isShowBar && !this.isHorizontal) {
      this.isVisibility = this.isShowBar;
    }

    animateTo({
      duration: BrowserConstants.IMMERSE_ANIM_DURATION,
      delay: this.isShowBar ? BrowserConstants.IMMERSE_ANIM_DELAY : 0,
      curve: this.isShowBar ? Curves.cubicBezier(0.6, 0.0, 0.6, 1.0) : Curves.cubicBezier(0.2, 0.0, 0.2, 1.0),
      onFinish: () => {
        performanceMonitor.end('CUSTOM_ANIMATOR onShowChanged');
        if (!this.isShowBar && !this.isHorizontal) {
          this.isVisibility = this.isShowBar;
        }
      }
    }, (): void => {
      this.opacityValue = this.isShowBar ? 1 : 0;
    })
  }

  build() {
    Stack() {
      ToolBar({
        onMenuClicked: this.onMenuClicked,
        isFromPhotoBrowser: this.isFromPhotoBrowser,
        isVisibilityText: this.isVisibilityText,
        moreMenuList: this.moreMenuList,
        showMovingPhotoCloseEffect: this.showMovingPhotoCloseEffect,
        movingPhotoEffectMode: this.movingPhotoEffectMode,
      })
    }
    .margin({
      bottom: this.isFromPhotoBrowser ? this.leftBlank[3] : 0,
    })
    .width(Constants.PERCENT_100)
    .backgroundColor(Color.Transparent)
    .padding({
      bottom: (!this.isHorizontal && DeviceInfo.isFoldablePhone()) ||
      this.isVerdeFoldable ? 0 : this.diggingHoleCameraArea.bottom,
    })
  }
}