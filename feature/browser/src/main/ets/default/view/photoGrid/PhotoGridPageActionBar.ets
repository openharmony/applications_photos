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
  AlbumInfo,
  Constants,
  Log,
  ScreenManager,
  UiUtil
} from '@ohos/common';
import { ActionBar } from '@ohos/common/CommonComponents';

const TAG: string = 'browser_PhotoGridPageActionBar';

@Component
export struct PhotoGridPageActionBar {
  @Consume @Watch('updateActionBarProp') isSelectedMode: boolean;
  @Consume @Watch('updateActionBarProp') isAllSelected: boolean;
  @StorageLink('isHorizontal') @Watch('updateActionBarProp') isHorizontal: boolean =
    ScreenManager.getInstance().isHorizontal();
  @Provide selectedCount: number = 0;
  @Link @Watch('updateActionBarProp') totalSelectedCount: number;
  @Consume isEmpty: boolean;
  title: string = '';
  albumInfo: AlbumInfo | null = null;
  isSystemAlbum: boolean = true;
  isRecycle: boolean = false;
  onMenuClicked: Function = (): void => {};
  isDistributedAlbum: boolean = false;
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;

  aboutToAppear(): void {
    this.updateActionBarProp();
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
        isNeedPlaceholder: false
      })
    }
    .padding({
      top: this.isHorizontal ? Constants.NUMBER_0 : px2vp(this.statusBarHeight)
    })
  }

  private createHorizontalActionBar(): ActionBarProp {
    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();

    actionBarProp
      .setLeftAction(Action.BACK)
      .setTitle(this.getTitle(this.albumInfo))
      .setMode(ActionBarMode.STANDARD_MODE);
    if (this.isSelectedMode) {
      if (this.isRecycle) {
        menuList.push(
          Boolean(this.selectedCount) ? Action.RECOVER : Action.RECOVER_INVALID,
          Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID,
          this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL);
      } else if (this.isDistributedAlbum) {
        menuList.push(
          (this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL),
          (Boolean(this.selectedCount) ? Action.DOWNLOAD : Action.DOWNLOAD_INVALID));
      } else {
        menuList.push(
          (this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL),
          Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID, Action.MORE);
      }
      actionBarProp
        .setLeftAction(Action.CANCEL)
        .setMode(ActionBarMode.SELECTION_MODE)
        .setSelectionMode(ActionBarSelectionMode.MULTI);
    } else {
      if (!this.isSystemAlbum && this.isDistributedAlbum == false) {
        menuList.push(Action.NEW);
      }
      if (this.isRecycle && !this.isEmpty) {
        menuList.push(Action.CLEAR_RECYCLE);
        menuList.push(Action.MULTISELECT);
      }
      if (!this.isRecycle) {
        menuList.push(this.isEmpty ? Action.MULTISELECT_INVALID : Action.MULTISELECT);
      }
    }
    actionBarProp.setMenuList(menuList);
    return actionBarProp;
  }

  private createActionBar(): ActionBarProp {
    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();

    if (!this.isSystemAlbum && this.isDistributedAlbum == false) {
      menuList.push(Action.NEW);
    }

    actionBarProp
      .setLeftAction(Action.BACK)
      .setTitle(this.getTitle(this.albumInfo))
      .setMenuList(menuList)
      .setMode(ActionBarMode.STANDARD_MODE);
    Log.info(TAG, `createActionBar, isSelectedMode: ${this.isSelectedMode}`);
    if (this.isSelectedMode) {
      menuList = [];
      actionBarProp
        .setLeftAction(Action.CANCEL)
        .setMenuList(menuList)
        .setMode(ActionBarMode.SELECTION_MODE)
        .setSelectionMode(ActionBarSelectionMode.MULTI);
    }

    return actionBarProp;
  }

  private getTitle(albumInfo: AlbumInfo | null): Resource | string {
    if (albumInfo) {
      let res = UiUtil.getDisplayNameResourceByAlbumInfo(albumInfo);
      if (res != null) {
        return res;
      }
    }
    return this.title;
  }
}