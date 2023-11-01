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

import { Log } from '../../utils/Log';
import { ActionBarProp } from '../browserOperation/ActionBarProp';
import { Action } from '../browserOperation/Action';
import { ActionBarButton } from './ActionBarButton';

const TAG: string = 'common_MenuPanel';

// MenuPanel，Right menu button panel
@Component
export struct MenuPanel {
  @Link @Watch('onActionBarPropChanged') actionBarProp: ActionBarProp;
  @State menuList: Action[] = [];
  onMenuClicked: Function = (): void => {};

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear.');
    this.onActionBarPropChanged();
  }

  build() {
    Row() {
      ForEach(this.menuList, (menu: Action) => {
        ActionBarButton({
          res: menu.iconRes,
          action: menu,
          onMenuClicked: this.onMenuClicked,
          isLeft: false,
          isAutoTint: menu.isAutoTint,
          colorMode: this.actionBarProp.getColorMode()
        })
          .margin({ right: $r('app.float.max_padding_end') })
      }, (menu: Action) => String(menu.actionID))
    }
    .alignItems(VerticalAlign.Center)
  }

  private onActionBarPropChanged(): void {
    this.menuList = this.actionBarProp.getMenuList();
    Log.info(TAG, `onActionBarPropChanged, menu's size: ${this.menuList.length}`);
    this.menuList.forEach((menu: Action) => {
      Log.info(TAG, `ActionId: ${menu.actionID}`)
    })
  }

  private onBuildDone(): void {
    Log.info(TAG, `onBuildDone, menu's size: ${this.menuList.length}`);
  }
}