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

import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy {
  ActionBarColorMode,
  ActionBarMode
} from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { ActionBar } from '@ohos/browsercommon/src/main/ets/default/view/actionbar/ActionBar';
import lazy Curves from '@ohos.curves';
import lazy { LibraryConstants } from '../model/LibraryConstants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { RightClickMenuGroup } from '@ohos/common/src/main/ets/default/view/menu/MenuGroup';
import lazy { display } from '@kit.ArkUI';

const TAG: string = 'browser_ActionBarView';

/**
 * 大图页顶部 ActionBar 组件
 * 用于显示拍照时间，详情唤出按钮等
 */
@Component
export struct ActionBarView {
  @Consume @Watch('onShowChanged') isShowBar: boolean;
  @State @Watch('opacityValueChanged') opacityValue: number = 1;
  @State isVisibility: boolean = true;
  @State currentBackgroundColor: Resource = ActionBarProp.PHOTO_BROWSER_ACTIONBAR_BACKGROUND_COLOR;
  @StorageLink('getFoldStatus') @Watch('onFoldChanged') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldChanged') private foldDisplayMode: display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @State isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @StorageLink('isSplitMode') isSplitMode: boolean = getScreen().isSplitMode();
  /*
 * 是否是自由多窗
 * */
  /* instrument ignore next */
  @StorageLink('windowPcmodeSwitchStatus') windowPcmodeSwitchStatus: boolean = false;
  @StorageLink('leftBlank') leftBlank: number [] = [0, getScreen()
    .getStatusBarHeight(), 0, getScreen().getNaviBarHeight()];
  // 是否横屏
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('isFullMode') private isFullMode: boolean = getScreen().isFullMode();
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @Consume @Watch('updateActionBarProp') menuList: Action[];
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  private isShowPhotoDate: boolean = true;
  @Prop private moreMenuList: Action[] = [];
  @Prop private moreMenuListPC: RightClickMenuGroup[] = [];
  @Prop private notShowDate: boolean = false;
  public isCameraActionBar: boolean = false;
  onMenuClicked: Function = (): void => {
  };

  updateActionBarProp(): void {
    Log.debug(TAG, 'update actionbar prop');
    this.actionBarProp = this.createActionBar();
  }

  onFoldChanged(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
    Log.info(TAG, `onfoldChanged isVerdeFoldable ${this.isVerdeFoldable} `);
  }

  opacityValueChanged(): void {
    Log.info(TAG, `opacityValueChanged ${this.opacityValue}`);
  }

  aboutToAppear(): void {
    Log.debug(TAG, '[aboutToAppear] start');
    this.isVisibility = this.isShowBar;
    this.actionBarProp = this.createActionBar();
  }

  onShowChanged(): void {
    Log.debug(TAG, `[onShowChanged] isShowBar: ${this.isShowBar}`);
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

  onActionBarPaddingTop(): number {
    if (this.isVerdeFoldable || this.windowPcmodeSwitchStatus) {
      return 0;
    } else {
      return ((!this.isHorizontal && DeviceInfo.isPhoneUx()) ||
        (DeviceInfo.isFoldable() && this.isFullMode || DeviceInfo.isTablet())) ?
      px2vp(this.statusBarHeight > 0 ? this.statusBarHeight : LibraryConstants.ACTION_BAR_VIEW_TOP_PADDING) : 0
    }
  }

  build() {
    if (this.isVisibility) {
      Stack() {
        ActionBar({
          actionBarProp: $actionBarProp,
          onMenuClicked: this.onMenuClicked,
          isNeedPlaceholder: false,
          isFromPhotoBrowser: true,
          moreMenuList: this.moreMenuList,
          moreMenuListPC: this.moreMenuListPC,
          notShowDate: this.notShowDate,
          isCameraActionBar: this.isCameraActionBar,
        })
      }
      .markAnchor({ x: Constants.PERCENT_0, y: Constants.PERCENT_0 })
      .position({ x: Constants.PERCENT_0, y: Constants.PERCENT_0 })
      .padding({
        top: this.onActionBarPaddingTop(),
        bottom: this.diggingHoleCameraArea.bottom,
        left: this.diggingHoleCameraArea.left,
        right: this.diggingHoleCameraArea.right,
      })
      .opacity(this.opacityValue)
      .backgroundColor(DeviceInfo.isPc() ? Color.Transparent : this.currentBackgroundColor)
      .backgroundBlurStyle(DeviceInfo.isPc() ? BlurStyle.COMPONENT_THICK : BlurStyle.NONE)
      .key(TAG)
    }
  }

  private createActionBar(): ActionBarProp {
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setHasTabBar(false)
      .setLeftAction(Action.BACK)
      .setAlpha(ActionBarProp.PHOTO_BROWSER_ACTIONBAR_ALPHA)
      .setMode(ActionBarMode.TOP_MODE)
      .setColorMode(ActionBarColorMode.NORMAL)
      .setMenuList(this.menuList)
      .setIsShowPhotoDate(this.isShowPhotoDate);
    return actionBarProp;
  }
}