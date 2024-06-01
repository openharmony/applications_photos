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

const TAG: string = 'browser_AlbumSelectActionBar';

@Component
export struct AlbumSelectActionBar {
  @StorageLink('isHorizontal') @Watch('createActionBar') isHorizontal: boolean =
    ScreenManager.getInstance().isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @Link @Watch('createActionBar') totalSelectedCount: number;
  @Provide selectedCount: number = 0;
  onMenuClicked: Function = (): void => {};
  @Link @Watch('updateMenu') menuList: Action[];
  @Provide moreMenuList: Action[] = [];
  @Provide hidePopup: boolean = false;

  aboutToAppear(): void {
    this.createActionBar();
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
      top: this.isHorizontal ? Constants.NUMBER_0 : $r('app.float.album_set_page_action_bar_padding_top')
    })
  }

  private updateMenu() {
    this.moreMenuList = this.menuList;
  }

  private createActionBar(): void {
    this.selectedCount = this.totalSelectedCount;
    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();
    menuList.push(Boolean(this.totalSelectedCount) ? Action.OK : Action.OK_DISABLE);
    actionBarProp
      .setLeftAction(Action.CANCEL)
      .setMode(ActionBarMode.SELECTION_MODE)
      .setSelectionMode(ActionBarSelectionMode.MULTI)
      .setMenuList(menuList);
    this.actionBarProp = actionBarProp;
  }
}