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
import lazy { ActionBarMode } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy { isOrientationHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { ActionBar } from '../../../../../../browserCommon/src/main/ets/default/view/actionbar/ActionBar';

/* instrument ignore file */
@Component
export struct GallerySettingsActionBar {
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  public title?: Resource = undefined;
  onMenuClicked: (action: Action) => void = (action: Action): void => {
  };
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  public isNavDestinationPageActionBar: boolean = false;
  @State private moreMenuList: Action[] = [];

  aboutToAppear(): void {
    this.actionBarProp = this.createActionBar();
  }

  build() {
    Column() {
      ActionBar({
        actionBarProp: $actionBarProp,
        onMenuClicked: this.onMenuClicked,
        isNeedPlaceholder: false,
        isNavDestinationPageActionBar: this.isNavDestinationPageActionBar,
        moreMenuList: this.moreMenuList,
      })
    }
  }

  private createActionBar(): ActionBarProp {
    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setBackgroundColor($r('app.color.transparent'))
      .setTitle(this.title ?? '')
      .setMenuList(menuList)
      .setMode(ActionBarMode.STANDARD_MODE)
      .setIsNavTitle(true);
    return actionBarProp;
  }
}