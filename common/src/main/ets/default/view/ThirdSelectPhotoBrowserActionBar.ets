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

import { Action } from './browserOperation/Action';
import { ActionBar } from './actionbar/ActionBar';
import { ActionBarProp } from './browserOperation/ActionBarProp';
import { ActionBarColorMode, ActionBarMode, ActionBarSelectionMode } from './browserOperation/ActionBarMode';
import { ScreenManager } from '../model/common/ScreenManager';
import { Constants } from '../model/common/Constants';

const TAG: string = 'common_ThirdSelectPhotoBrowserActionBar';

@Component
export struct ThirdSelectPhotoBrowserActionBar {
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  @State isMultiPick: boolean = false;
  @Consume @Watch('createActionBar') isSelected: boolean;
  onMenuClicked: Function = (): void => {};
  @StorageLink('isHorizontal') @Watch('createActionBar') isHorizontal: boolean = ScreenManager.getInstance()
    .isHorizontal();
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @Link isShowBar: boolean;
  @Provide('selectedCount') selectedCount: number = 0;
  @Link @Watch('onSelectedCountChanged') totalSelectedCount: number;
  @Provide moreMenuList: Action[] = [];
  @Provide hidePopup: boolean = false;
  private title: string | Resource = '';
  private isThird: boolean = false;
  @Consume canEdit: boolean;

  aboutToAppear() {
    this.createActionBar();
    this.onSelectedCountChanged();
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Image($r('app.media.gradientBasePlate')).width(Constants.PERCENT_100)
        .height(Constants.PERCENT_100).objectFit(ImageFit.Fill)
      ActionBar({
        actionBarProp: $actionBarProp,
        onMenuClicked: this.onMenuClicked,
        isNeedPlaceholder: false
      })
        .padding({
          top: (this.isHorizontal && !ScreenManager.getInstance().isUIExtensionEnv()) ?
            $r('app.float.third_selected_actionbar_padding_top') : px2vp(this.statusBarHeight)
        })
    }
    .height(this.isHorizontal ? Constants.ActionBarHeight * Constants.PHOTO_BAR_MULTIPLES_1_5 :
      Constants.ActionBarHeight * Constants.PHOTO_BAR_MULTIPLES_1_5 +
      px2vp(this.statusBarHeight))
    .markAnchor({ x: Constants.PERCENT_0, y: Constants.PERCENT_0 })
    .position({ x: Constants.PERCENT_0, y: Constants.PERCENT_0 })
    .visibility(this.isShowBar ? Visibility.Visible : Visibility.Hidden)
  }

  private onSelectedCountChanged() {
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
      .setColorMode(ActionBarColorMode.TRANSPARENT)
      .setAlpha(ActionBarProp.PHOTO_BROWSER_ACTIONBAR_ALPHA)

    if (this.isMultiPick && !this.isThird) {
      menuList.push(this.isSelected ? Action.SELECTED : Action.MATERIAL_SELECT);
    }
    actionBarProp.setMenuList(menuList)

    if (this.title) {
      actionBarProp
        .setIsNeedTitle(false);
    }
    this.actionBarProp = actionBarProp;
  }
}