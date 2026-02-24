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
  ActionBarMode,
  ActionBarSelectionMode
} from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy { isOrientationHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { ActionBar } from '@ohos/browsercommon/src/main/ets/default/view/actionbar/ActionBar';

/* instrument ignore file */
const TAG: string = 'browser_NewAlbumPageActionBar';

@Component
export struct NewAlbumPageActionBar {
  onMenuClicked: Function = (): void => {
  };
  @StorageLink('isHorizontal') @Watch('createActionBar') isHorizontal: boolean = isOrientationHorizontal();
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @State private moreMenuList: Action[] = [];
  @Provide hidePopup: boolean = false;
  @Provide albumsShow: boolean = false;

  aboutToAppear(): void {
    this.createActionBar();
  }

  build() {
    Column() {
      ActionBar({
        actionBarProp: $actionBarProp,
        onMenuClicked: this.onMenuClicked,
        isNeedPlaceholder: false,
        moreMenuList: this.moreMenuList,
      })
    }
    .padding({
      top: this.isHorizontal ? 0 : $r('app.float.album_set_page_action_bar_padding_top')
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