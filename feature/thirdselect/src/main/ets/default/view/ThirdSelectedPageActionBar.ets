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

import { Action, ActionBarMode, ActionBarProp, Constants, ScreenManager } from '@ohos/common';
import { ActionBar } from '@ohos/common/CommonComponents';
import { IS_HORIZONTAL, SelectParams } from '../utils/ThirdSelectConstants';

@Component
export struct ThirdSelectedPageActionBar {
  @StorageLink(IS_HORIZONTAL) @Watch('createActionBar') isHorizontal: boolean = ScreenManager.getInstance()
    .isHorizontal();
  @State menuList: Action[] = [];
  selectParams: SelectParams = SelectParams.defaultParam();
  @Provide selectedCount: number = 0;
  @Link @Watch('onSelectedCountChanged') totalSelectedCount: number;
  isSelectPhotoGrid: boolean = false;
  onMenuClicked: Function = (): void => {};
  leftAction: Action = Action.BACK;
  @Link @Watch('onSelectedCountChanged') title: string;
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  isFirstEnter: boolean = true;
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @Provide hidePopup: boolean = false;

  aboutToAppear(): void {
    this.onSelectedCountChanged();
    this.createActionBar();
  }

  onSelectedCountChanged() {
    this.selectedCount = this.totalSelectedCount;
    if (this.isSelectPhotoGrid == true) {
      if (!this.selectParams.isFromFa || this.isFirstEnter) {
        this.menuList = [Action.NAVIGATION_ALBUMS];
      } else {
        this.menuList = [];
      }
    } else {
      this.menuList = [];
    }
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
      top: (this.isHorizontal && !ScreenManager.getInstance().isUIExtensionEnv()) ?
        $r('app.float.third_selected_actionbar_padding_top') :
        (this.statusBarHeight === 0) ? $r('app.float.third_selected_actionbar_padding_top') : px2vp(this.statusBarHeight)
    })
  }

  private createActionBar(): void {
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setLeftAction(this.leftAction)
      .setTitle(this.title)
      .setMenuList(this.menuList)
      .setMode(ActionBarMode.STANDARD_MODE)
      .setBackgroundColor($r('sys.color.ohos_id_color_sub_background'))
      .setMaxSelectCount(this.selectParams.maxSelectCount);
    this.actionBarProp = actionBarProp;
  }
}