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

import lazy { Action } from './browserOperation/Action';
import lazy { ActionBar } from '../../../../../../browserCommon/src/main/ets/default/view/actionbar/ActionBar';
import lazy { ActionBarProp } from './browserOperation/ActionBarProp';
import lazy { ActionBarColorMode, ActionBarMode, ActionBarSelectionMode } from './browserOperation/ActionBarMode';
import lazy { getScreen, isOrientationHorizontal } from '../model/common/ScreenManager';
import lazy { Constants } from '../model/common/Constants';
import lazy Curves from '@ohos.curves';
import lazy { Constants as BrowserConstants } from '../model/browser/photo/Constants';
import lazy { DeviceInfo } from '../utils/DeviceInfo';
import lazy { Log } from '../utils/Log';
import lazy { display, LengthMetrics } from '@kit.ArkUI';

// instrument ignore file
const TAG: string = 'common_ThirdSelectPhotoBrowserActionBar';

@Component
export struct ThirdSelectPhotoBrowserActionBar {
  @State opacityValue: number = 1;
  @State isVisibility: boolean = true;
  @LocalStorageLink('isSidebarDrawerShown') isSidebarDrawerShown: boolean = true;
  @StorageLink('leftBlank') leftBlank: number[] = getScreen().getLeftBlank();
  @State isMultiPick: boolean = false;
  @Consume @Watch('createActionBar') isSelected: boolean;
  onMenuClicked: Function = (): void => {
  };
  @StorageLink('isHorizontal') @Watch('createActionBar') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldChanged') private foldDisplayMode: display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @State isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @Link @Watch('onShowChanged') isShowBar: boolean;
  @Provide('selectedCount') selectedCount: number = 0;
  @Link @Watch('onSelectedCountChanged') totalSelectedCount: number;
  @Provide hidePopup: boolean = false;
  private title: string | Resource = '';
  private isThird: boolean = false;
  @Provide albumsShow: boolean = false;
  @Consume canEdit: boolean;
  @Consume @Watch('createActionBar') menuList: Action[];
  //标记是否选择模式下PC和phone大图浏览
  @State isThirdSelectPhoto: boolean = true;
  @Prop private moreMenuList: Action[] = [];
  @Prop @Watch('updateActionBarProp') isPrivateHideState: boolean = false;
  private paddingValue: number = 8;

  private updateActionBarProp(): void {
    Log.info(TAG, `ThirdSelectPhotoBrowserActionBar: updateActionBarProp`);
    this.createActionBar();
  }

  aboutToAppear() {
    this.createActionBar();
    this.onSelectedCountChanged();
    Log.info(TAG, `aboutToAppear title: ${this.title}`)
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

  onFoldChanged() {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
  }

  build() {
    if (!DeviceInfo.isPc() || (DeviceInfo.isPc() && this.isVisibility)) {
      Stack({ alignContent: Alignment.TopStart }) {
        if (!DeviceInfo.isPc()) {
          Image($r('app.media.gradientBasePlate'))
            .draggable(false)
            .width(Constants.PERCENT_100)
            .height(Constants.PERCENT_100)
            .objectFit(ImageFit.Fill)
        }
        ActionBar({
          actionBarProp: $actionBarProp,
          onMenuClicked: this.onMenuClicked,
          isNeedPlaceholder: false,
          isThirdSelectPhoto: this.isThirdSelectPhoto,
          moreMenuList: this.moreMenuList,
        })
          .padding(DeviceInfo.isPc() ? {
            start: LengthMetrics.vp((DeviceInfo.isPc() && this.isSidebarDrawerShown) ?
            Constants.DRAWER_BUTTON_WIDTH_PC : 0),
            top: LengthMetrics.vp(this.statusBarHeight)
          } : {
            top: (this.isHorizontal && !DeviceInfo.isFoldable() && DeviceInfo.isPhoneUx()) &&
              !getScreen().isUIExtensionEnv() ? $r('app.float.third_select_actionbar_padding_top') :
              (this.isVerdeFoldable ? 0 : px2vp(this.statusBarHeight))
          })
      }
      .backgroundBlurStyle(DeviceInfo.isPc() ? BlurStyle.COMPONENT_THICK : BlurStyle.NONE)
      .height(this.getStackHeight())
      .markAnchor({ x: Constants.PERCENT_0, y: Constants.PERCENT_0 })
      .position({ x: Constants.PERCENT_0, y: Constants.PERCENT_0 })
      .opacity(this.opacityValue)
      .border(DeviceInfo.isPc() ? {
        width: {
          bottom: Constants.MENU_DIVIDER_STROKE_WIDTH,
        },
        color: { bottom: $r('sys.color.comp_divider') },
      } : {})
    }
  }

  private getStackHeight(): Length {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      return $r('app.float.actionButton_default');
    }
    return this.isHorizontal ? Constants.ActionBarHeight * Constants.PHOTO_BAR_MULTIPLIER :
      Constants.ActionBarHeight * Constants.PHOTO_BAR_MULTIPLIER + px2vp(this.statusBarHeight);
  }

  private onSelectedCountChanged(): void {
    this.selectedCount = this.totalSelectedCount;
  }

  private createActionBar(): void {
    let actionBarProp: ActionBarProp = new ActionBarProp();

    let menuList: Action[] = [];
    if (this.canEdit) {
      menuList.push(Action.EDIT);
    }

    actionBarProp
      .setLeftAction(Action.BACK)
      .setMode(ActionBarMode.SELECTION_MODE)
      .setSelectionMode(this.isMultiPick ? ActionBarSelectionMode.MULTI : ActionBarSelectionMode.SINGLE)
      .setColorMode(DeviceInfo.isPc() ? ActionBarColorMode.NORMAL : ActionBarColorMode.TRANSPARENT)
      .setAlpha(ActionBarProp.PHOTO_BROWSER_ACTIONBAR_ALPHA)

    if (this.isMultiPick && !this.isThird) {
      if (this.isPrivateHideState) {
        menuList.push(this.isSelected ? Action.SELECTED_INVALID : Action.MATERIAL_SELECT_INVALID);
      } else {
        menuList.push(this.isSelected ? Action.SELECTED : Action.MATERIAL_SELECT);
      }
    }
    actionBarProp.setMenuList(menuList);

    if (this.isHorizontal && this.menuList?.length > 0) {
      for (let i = 0; i < this.menuList.length; i++) {
        menuList.push(this.menuList[i]);
      }
    }

    if (this.title) {
      actionBarProp
        .setIsNeedTitle(false);
    }
    this.actionBarProp = actionBarProp;
  }
}