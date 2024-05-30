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

const TAG: string = 'browser_NewAlbumPageActionBar';

@Component
export struct NewAlbumPageActionBar {
  onMenuClicked: Function = (): void => {};
  @StorageLink('isHorizontal') @Watch('createActionBar') isHorizontal: boolean = ScreenManager.getInstance()
    .isHorizontal();
  @State actionBarProp: ActionBarProp = new ActionBarProp();
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

  private createActionBar(): void {
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setLeftAction(Action.CANCEL)
      .setMode(ActionBarMode.STANDARD_MODE)
      .setSelectionMode(ActionBarSelectionMode.SINGLE)
      .setTitle($r('app.string.title_select_photos'));

    this.actionBarProp = actionBarProp;
  }
}