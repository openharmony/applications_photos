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

const TAG: string = 'browser_AlbumSetPageActionBar';

@Component
export struct AlbumSetPageActionBar {
  @Consume @Watch('updateActionBar') isAlbumSetSelectedMode: boolean;
  @Consume('selectedCount') @Watch('updateActionBar') selectedAlbumsCount: number;
  @Consume isDisableRename: boolean;
  @Consume isDisableDelete: boolean;
  @Consume @Watch('updatePlaceholderStatus') isShowSideBar: boolean;
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @StorageLink('isHorizontal') @Watch('updateActionBar') isHorizontal: boolean =
    ScreenManager.getInstance().isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  onMenuClicked: Function = (): void => {};
  @State isNeedPlaceholder: boolean = true;
  @Provide moreMenuList: Action[] = [];
  @Provide hidePopup: boolean = false;
  private deviceType: string = '';
  private actionBarPaddingTop: number | Resource = 0;

  updatePlaceholderStatus(): void {
    if (this.deviceType !== Constants.PC_DEVICE_TYPE) {
      this.isNeedPlaceholder = false;
    } else {
      this.isNeedPlaceholder = this.isShowSideBar ? false : true;
    }
  }

  updateActionBar(): void {
    if (this.isHorizontal) {
      this.actionBarProp = this.createHorizontalActionBar();
    } else {
      this.actionBarProp = this.createActionBar();
    }
  }

  aboutToAppear(): void {
    this.deviceType = AppStorage.get<string>('deviceType') as string;
    if (this.deviceType === Constants.PC_DEVICE_TYPE) {
      this.actionBarPaddingTop = $r('app.float.album_set_page_action_bar_padding_top');
    } else if (this.deviceType === Constants.PAD_DEVICE_TYPE) {
      this.actionBarPaddingTop = 0;
    } else {
      this.actionBarPaddingTop = px2vp(this.statusBarHeight);
    }
    this.updatePlaceholderStatus();
    this.updateActionBar();
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
    Log.info(TAG, `createHorizontalActionBar, isAlbumSetSelectedMode: ${this.isAlbumSetSelectedMode}`);

    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();

    actionBarProp
      .setHasTabBar(this.isSidebar)
      .setTitle($r('app.string.tab_albums'))
      .setBackgroundColor($r('app.color.transparent'))
      .setIsHeadTitle(true);

    if (this.isAlbumSetSelectedMode) {
      menuList.push(
        ((!this.isDisableRename && this.selectedAlbumsCount == 1) ? Action.RENAME : Action.RENAME_INVALID),
        ((!this.isDisableDelete && this.selectedAlbumsCount > 0) ? Action.DELETE : Action.DELETE_INVALID));
      actionBarProp
        .setLeftAction(Action.CANCEL)
        .setMenuList(menuList)
        .setMode(ActionBarMode.SELECTION_MODE)
        .setSelectionMode(ActionBarSelectionMode.MULTI);
    } else {
      menuList.push(Action.NEW)
      const deviceType: string = AppStorage.get('deviceType') as string;
      if (deviceType === Constants.PC_DEVICE_TYPE) {
        menuList.push(Action.MULTISELECT)
      }
      actionBarProp
        .setMenuList(menuList)
        .setMode(ActionBarMode.STANDARD_MODE);
    }

    return actionBarProp;
  }

  private createActionBar(): ActionBarProp {
    Log.info(TAG, `createActionBar, isAlbumSetSelectedMode: ${this.isAlbumSetSelectedMode}`);

    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();

    menuList.push(Action.NEW);

    actionBarProp
      .setHasTabBar(this.isSidebar)
      .setTitle($r('app.string.tab_albums'))
      .setIsHeadTitle(true);

    if (this.isAlbumSetSelectedMode) {
      actionBarProp
        .setLeftAction(Action.CANCEL)
        .setMode(ActionBarMode.SELECTION_MODE)
        .setSelectionMode(ActionBarSelectionMode.MULTI);
    } else {
      actionBarProp
        .setMenuList(menuList)
        .setMode(ActionBarMode.STANDARD_MODE);
    }

    return actionBarProp;
  }
}