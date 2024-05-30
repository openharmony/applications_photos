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
  ActionBarMode,
  ActionBarProp,
  ActionBarSelectionMode,
  Constants,
  Log,
  ScreenManager
} from '@ohos/common';
import { ActionBar } from '@ohos/common/CommonComponents';

const TAG: string = 'timeline_TimelinePageActionBar';

@Component
export struct TimelinePageActionBar {
  @Consume isEmpty: boolean;
  @Consume @Watch('updateActionBarProp') isSelectedMode: boolean;
  @Consume @Watch('updateActionBarProp') isAllSelected: boolean;
  @Link @Watch('updateActionBarProp') totalSelectedCount: number;
  @Provide selectedCount: number = 0;
  @Consume @Watch('updatePlaceholderStatus') isShowSideBar: boolean;
  onMenuClicked: Function = (): void => {};
  @StorageLink('isHorizontal') @Watch('updateActionBarProp') isHorizontal: boolean =
    ScreenManager.getInstance().isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @State isNeedPlaceholder: boolean = true;
  @Consume moreMenuList: Action[];
  @StorageLink('deviceType') deviceType: string | undefined = AppStorage.get<string>('deviceType');
  private actionBarPaddingTop: number | Resource = 0;

  aboutToAppear(): void {
    if (this.deviceType === Constants.PC_DEVICE_TYPE) {
      this.actionBarPaddingTop = $r('app.float.album_set_page_action_bar_padding_top');
    } else if (this.deviceType === Constants.PAD_DEVICE_TYPE) {
      this.actionBarPaddingTop = 0
    } else {
      this.actionBarPaddingTop = px2vp(this.statusBarHeight)
    }
    this.updateActionBarProp();
    this.updatePlaceholderStatus();
  }

  updatePlaceholderStatus(): void {
    if (this.deviceType !== Constants.PC_DEVICE_TYPE) {
      this.isNeedPlaceholder = false;
    } else {
      this.isNeedPlaceholder = this.isShowSideBar ? false : true
    }
  }

  updateActionBarProp(): void {
    this.selectedCount = this.totalSelectedCount;
    if (this.isHorizontal) {
      this.actionBarProp = this.createHorizontalActionBar();
    } else {
      this.actionBarProp = this.createActionBar();
    }
  }

  build() {
    Column() {
      ActionBar({
        actionBarProp: $actionBarProp,
        onMenuClicked: this.onMenuClicked,
        isNeedPlaceholder: this.isNeedPlaceholder
      })
    }
    .padding({
      top: this.deviceType === Constants.DEFAULT_DEVICE_TYPE ? px2vp(this.statusBarHeight) : this.actionBarPaddingTop
    })
  }

  private createHorizontalActionBar(): ActionBarProp {
    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();
    if (!this.isEmpty && this.deviceType === Constants.PC_DEVICE_TYPE) {
      menuList.push(Action.MULTISELECT);
    }
    actionBarProp
      .setHasTabBar(true)
      .setTitle($r('app.string.tab_timeline'))
      .setIsHeadTitle(true)
      .setMenuList(menuList)
      .setBackgroundColor($r('app.color.transparent'))
      .setMode(ActionBarMode.STANDARD_MODE);
    Log.info(TAG, `createActionBar, isSelectedMode: ${this.isSelectedMode}`);
    if (this.isSelectedMode) {
      menuList = [];
      menuList.push((this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL),
        Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID, Action.MORE);
      actionBarProp
        .setLeftAction(Action.CANCEL)
        .setMenuList(menuList)
        .setMode(ActionBarMode.SELECTION_MODE)
        .setSelectionMode(ActionBarSelectionMode.MULTI);
    }
    return actionBarProp;
  }

  private createActionBar(): ActionBarProp {
    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setHasTabBar(this.isSidebar)
      .setTitle($r('app.string.tab_timeline'))
      .setIsHeadTitle(true)
      .setMode(ActionBarMode.STANDARD_MODE);
    Log.info(TAG, `createActionBar, isSelectedMode: ${this.isSelectedMode}`);
    if (this.isSelectedMode) {
      actionBarProp
        .setLeftAction(Action.CANCEL)
        .setMenuList(menuList)
        .setMode(ActionBarMode.SELECTION_MODE)
        .setSelectionMode(ActionBarSelectionMode.MULTI);
    }
    return actionBarProp;
  }
}