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

import lazy { Action } from '../../../default/view/browserOperation/Action';
import lazy { ActionBarMode, ActionBarSelectionMode } from '../../../default/view/browserOperation/ActionBarMode';
import lazy { ActionBarProp } from '../../../default/view/browserOperation/ActionBarProp';
import lazy { DeviceInfo } from '../../../default/utils/DeviceInfo';
import lazy { Log } from '../../../default/utils/Log';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal,
  ScreenManager,
} from '../../../default/model/common/ScreenManager';
import lazy { ActionBar } from '../../../../../../../browserCommon/src/main/ets/default/view/actionbar/ActionBar';
import lazy { SearchSwitchManager } from '../../model/SearchSwitchManager';
import lazy { display } from '@kit.ArkUI';
import lazy { Constants } from '../../../default/model/common/Constants';
import lazy { MenuListUtil } from '../../../default/utils/MenuListUtil';
import lazy { RightClickMenuGroup } from '../../view/menu/MenuController';

/* instrument ignore file */
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
    isOrientationHorizontal();
  @State private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldDisplayModeChanged') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink('isSidebar') isSidebar: boolean = getScreen().isSidebar();
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  onMenuClicked: Function = (): void => {
  };
  @State private isNeedPlaceholder: boolean = true;
  @State moreMenuList: Action[] = [];
  @Prop private moreMenuListPC: RightClickMenuGroup[] = [];
  @Link actionMoreMenuList: Action[];
  @Provide hidePopup: boolean = false;
  @State private actionBarPaddingTop: number | Resource = 0;
  @StorageLink('IsCloudDriveInstalled') @Watch('updateActionBar') isCloudDriveInstalled: boolean = false;
  private onAreaHeightChangedFunc: Function = (data: number): void => this.onAreaHeightChanged(data);
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();

  updatePlaceholderStatus(): void {
    if (!DeviceInfo.isPc()) {
      this.isNeedPlaceholder = false;
    } else {
      this.isNeedPlaceholder = !this.isShowSideBar;
    }
  }

  updateActionBar(): void {
    if (this.isHorizontal || DeviceInfo.isGRLMStatus()) {
      this.actionBarProp = this.createHorizontalActionBar();
    } else {
      this.actionBarProp = this.createActionBar();
    }
  }

  aboutToAppear(): void {
    if (!DeviceInfo.isPcOrTablet()) {
      this.actionBarPaddingTop = px2vp(this.statusBarHeight);
    } else {
      this.actionBarPaddingTop = $r('app.float.album_set_page_action_bar_padding_top');
    }
    getScreen().on(ScreenManager.ON_AREA_HEIGHT_CHANGED, this.onAreaHeightChangedFunc);
    Log.info(TAG, `action bar padding top: ${this.actionBarPaddingTop}`);
    this.updatePlaceholderStatus();
    this.updateActionBar();
  }

  aboutToDisappear(): void {
    getScreen().off(ScreenManager.ON_AREA_HEIGHT_CHANGED, this.onAreaHeightChangedFunc);
  }

  private onAreaHeightChanged(data: number): void {
    if (!DeviceInfo.isPcOrTablet()) {
      this.actionBarPaddingTop = px2vp(data);
    }
  }

  build() {
    Column() {
      ActionBar({
        actionBarProp: $actionBarProp,
        onMenuClicked: this.onMenuClicked,
        isNeedPlaceholder: this.isNeedPlaceholder,
        actionMoreMenuList: this.actionMoreMenuList,
        isAlbumSetPageActionBar: true,
        isShowSideBar: this.isShowSideBar,
        isSelected: this.isAlbumSetSelectedMode,
        moreMenuList: this.moreMenuList,
        moreMenuListPC: this.moreMenuListPC,
      })
    }
    .padding({
      top: this.isHorizontal && (!this.isFoldExpanded && !DeviceInfo.isTablet()) || this.isVerdeFoldable ? 0 :
      this.actionBarPaddingTop,
      left: this.isFoldExpanded ? 0 : this.diggingHoleCameraArea.left,
      right: this.isFoldExpanded ? 0 : this.diggingHoleCameraArea.right,
    })
  }

  private createHorizontalActionBar(): ActionBarProp {
    Log.info(TAG, `createHorizontalActionBar, isAlbumSetSelectedMode: ${this.isAlbumSetSelectedMode}`);

    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();

    actionBarProp
      .setHasTabBar(this.isSidebar)
      .setTitle($r('app.string.tab_albums'))
      .setIsLevelOneHeadTitle(true)
      .setIsHeadTitle(true)
      .setTitleFontSize(DeviceInfo.isPc() ?
      ActionBarProp.HEAD_TITLE_TEXT_SIZE : ActionBarProp.HEAD_TITLE_ONE_LINE_TEXT_SIZE)

    if (this.isAlbumSetSelectedMode) {
      menuList.push(
        !this.isDisableRename && this.selectedAlbumsCount === 1 ? Action.RENAME_ALBUM : Action.RENAME_ALBUM_INVALID,
        !this.isDisableDelete && this.selectedAlbumsCount > 0 ? Action.DELETE_ALBUM : Action.DELETE_ALBUM_INVALID);
      MenuListUtil.verifyMenuList(menuList, actionBarProp);
      actionBarProp
        .setLeftAction(Action.CANCEL)
        .setMenuList(menuList)
        .setMode(ActionBarMode.SELECTION_MODE)
        .setSelectionMode(ActionBarSelectionMode.MULTI);
    } else {
      menuList.push(Action.NEW_ALBUM);
      if (this.actionMoreMenuList.length) {
        menuList.push(Action.ACTION_MORE);
      }
      MenuListUtil.verifyMenuList(menuList, actionBarProp);
      actionBarProp
        .setMenuList(menuList)
        .setMode(ActionBarMode.STANDARD_MODE);
    }

    return actionBarProp;
  }

  private onFoldDisplayModeChanged(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
  }

  private createActionBar(): ActionBarProp {
    Log.info(TAG, `createActionBar, isAlbumSetSelectedMode: ${this.isAlbumSetSelectedMode}`);

    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();

    if (!this.isVerdeFoldable) {
      menuList.push(Action.NEW_ALBUM);
    }

    actionBarProp
      .setHasTabBar(this.isSidebar)
      .setTitle($r('app.string.tab_albums'))
      .setIsLevelOneHeadTitle(true)
      .setTitleFontSize(
        DeviceInfo.isPc() ? ActionBarProp.HEAD_TITLE_TEXT_SIZE : ActionBarProp.HEAD_TITLE_ONE_LINE_TEXT_SIZE)
      .setIsHeadTitle(true);

    if (this.isAlbumSetSelectedMode) {
      actionBarProp
        .setLeftAction(Action.CANCEL)
        .setMode(ActionBarMode.SELECTION_MODE)
        .setSelectionMode(ActionBarSelectionMode.MULTI);
    } else {
      if (this.actionMoreMenuList.length) {
        menuList.push(Action.ACTION_MORE);
      }
      actionBarProp
        .setMenuList(menuList)
        .setMode(ActionBarMode.STANDARD_MODE);
    }
    return actionBarProp;
  }
}