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

/* instrument ignore file */

import lazy { WindowVariables } from '@ohos/tools/src/main/global/HapVariables';
import lazy { ActionBarVar } from '@ohos/tools/src/main/variables/ActionBarVar';
import lazy { BroadCastConstants } from '../model/common/BroadCastConstants';
import lazy { BroadCastManager } from '../model/common/BroadCastManager';
import lazy { Constants } from '../model/common/Constants';
import lazy { updateAlbumPageGridPaddingLeftAndRight } from '../model/common/ScreenManager';
import lazy { Action } from '../view/browserOperation/Action';
import lazy { ActionBarProp } from '../view/browserOperation/ActionBarProp';
import lazy { BroadCast } from './BroadCast';
import lazy { DeviceInfo } from './DeviceInfo';
import lazy { Log } from './Log';

const TAG: string = 'common_MenuListUtil';
const appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

export namespace MenuListUtil {
  export function verifyMenuList(menuList: Action[], actionBarProp: ActionBarProp) {
    if (!DeviceInfo.isPc() || !actionBarProp) {
      return;
    }
    initData(menuList, actionBarProp);
    let menuPanelWidth: number = actionBarProp.getDetailMenuPanelWidth();
    if (!menuPanelWidth) {
      menuPanelWidth = LocalStorage.getShared()?.get<number>('menuPanelWidth') ?? 0;
    }
    if (!menuPanelWidth) {
      actionBarProp.setMenuList(menuList);
      return;
    }
    updateMenuList(menuList, actionBarProp);
  }

  function initData(menuList: Action[], actionBarProp: ActionBarProp): void {
    let menuListMinWidth: number = menuList.length *
      (Constants.ActionBarButtonHotZoneHeight + Constants.ActionBarButtonPadding);
    menuListMinWidth && LocalStorage.getShared()?.setOrCreate<number>('menuListMinWidth', menuListMinWidth);
    appBroadCast.emit(BroadCastConstants.UPDATE_PC_SEARCH_ICON);
    let flexibleMenuList: Action[] = [];
    let isUpdateOriginalLength: boolean = actionBarProp.getIsUpdateOriginalLength();
    let originalMenuListLength: number = actionBarProp.getOriginalMenuListLength();
    if (isUpdateOriginalLength) {
      originalMenuListLength = menuList.length;
    }
    actionBarProp
      .setFlexibleMenuList(flexibleMenuList)
      .setMenuListMinWidth(menuListMinWidth)
      .setOriginalMenuListLength(originalMenuListLength);
  }

  export function updateMenuList(menuList: Action[], actionBarProp: ActionBarProp) {
    if (!DeviceInfo.isPc() || !actionBarProp) {
      return;
    }
    let menuPanelWidth: number = actionBarProp.getDetailMenuPanelWidth();
    if (!menuPanelWidth) {
      menuPanelWidth = LocalStorage.getShared()?.get<number>('menuPanelWidth') ?? 0;
    }
    let menuListMinWidth: number = actionBarProp.getMenuListMinWidth();
    let flexibleMenuList: Action[] = actionBarProp.getFlexibleMenuList();
    let originalMenuListLength: number = actionBarProp.getOriginalMenuListLength();
    Log.info(TAG,
      `updateMenuList, menuPanelWidth: ${menuPanelWidth}, menuListMinWidth: ${menuListMinWidth}, menuList length: ${menuList?.length}`);
    // 至少保留一个更多按钮
    // while (menuPanelWidth < menuListMinWidth && menuList && menuList.length > 1) {
    //   menuListMinWidth = menuListMinWidth - SELECTION_MODE_SIZE;
    //   let removedAction: Action | undefined = menuList.shift();
    //   actionBarProp.setIsUpdateOriginalLength(false);
    //   if (removedAction instanceof Action) {
    //     flexibleMenuList.unshift(removedAction);
    //   }
    //   Log.info(TAG,
    //     `verifyMenuPanelWidth removed ${removedAction?.componentKey}, minListWidth ${menuListMinWidth},
    //     this.menuPanelWidth ${menuPanelWidth}`);
    //   actionBarProp.setIsUpdateOriginalLength(true);
    // }

    // while (menuPanelWidth > menuListMinWidth + SELECTION_MODE_SIZE &&
    //   menuList && menuList.length < originalMenuListLength) {
    //   menuListMinWidth = menuListMinWidth + SELECTION_MODE_SIZE;
    //   let addedAction: Action | undefined = flexibleMenuList.shift();
    //   if (addedAction instanceof Action) {
    //     actionBarProp.setIsUpdateOriginalLength(false);
    //     menuList.unshift(addedAction);
    //   }
    //   Log.info(TAG, `verifyMenuPanelWidth added ${addedAction?.componentKey}, minListWidth ${menuListMinWidth}`);
    //   actionBarProp.setIsUpdateOriginalLength(true);
    // }
    Log.info(TAG,
      `updateMenuList, menuList length: ${menuList?.length}, flexibleMenuList length: ${flexibleMenuList?.length}`);
    actionBarProp
      .setMenuListMinWidth(menuListMinWidth)
      .setFlexibleMenuList(flexibleMenuList)
      .setMenuList(menuList);
  }

  export function updateTopSearchViewWidth(width: number, callback: Function): void {
    let menuPanelWidth: number = LocalStorage.getShared()?.get<number>('menuListMinWidth') ?? 0;
    let leftMenuWidth: number = LocalStorage.getShared()?.get<number>('leftMenuWidth') ?? 0;
    let tempWidth: number = menuPanelWidth + leftMenuWidth + WindowVariables.titleButtonAvoidWidth +
      (ActionBarVar.isShowSideBar ? ActionBarVar.sideBarWidth : 0) + updateAlbumPageGridPaddingLeftAndRight() +
    Constants.SEARCH_VIEW_MARGIN + Constants.ACTION_BUTTON_WIDTH_PC;
    if (!callback) {
      return;
    }
    if (width - tempWidth > Constants.SearchViewWidth) {
      callback(false, Constants.SearchViewWidth);
    } else if (width - tempWidth < Constants.SearchViewWidth &&
      width - tempWidth > Constants.SearchViewMinWidth) {
      callback(false, width - tempWidth);
    } else {
      // callback(true, SELECTION_MODE_SIZE_PC);
    }
  }
}