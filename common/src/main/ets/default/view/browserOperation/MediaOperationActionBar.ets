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
import { Action } from './Action';
import { ActionBar } from '../actionbar/ActionBar';
import { ActionBarProp } from './ActionBarProp';
import { ActionBarMode } from './ActionBarMode';
import { ScreenManager } from '../../model/common/ScreenManager';
import { MediaOperationType } from '../../model/common/MediaOperationType';
import { Constants } from '../../model/common/Constants';

const TAG: string = 'common_MediaOperationActionBar';

@Component
export struct MediaOperationActionBar {
  @Consume pageType: string;
  @Consume @Watch('createActionBar') loadingFinish: boolean;
  onMenuClicked: Function = (): void => {};
  @StorageLink('isHorizontal') @Watch('createActionBar') isHorizontal: boolean =
    ScreenManager.getInstance().isHorizontal();
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
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
      top: this.isHorizontal ? Constants.NUMBER_0 : px2vp(this.statusBarHeight)
    })
  }

  private createActionBar(): void {
    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();
    if (this.loadingFinish) {
      menuList.push(Action.NEW);
    }
    actionBarProp
      .setHasTabBar(false)
      .setTitle((this.pageType == MediaOperationType.Move) ? $r('app.string.move_to') : $r('app.string.add_to'))
      .setMode(ActionBarMode.STANDARD_MODE)
      .setMenuList(menuList)
      .setBackgroundColor($r('app.color.transparent'))
      .setLeftAction(Action.CANCEL);
    this.actionBarProp = actionBarProp;
  }
}