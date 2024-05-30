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
import { ActionBarMode } from '../browserOperation/ActionBarMode';
import { SingleTitle } from './SingleTitle';
import { DetailTitle } from './DetailTitle';
import { SelectionTitle } from './SelectionTitle';
import { MenuPanel } from './MenuPanel';
import { DetailMenuPanel } from './DetailMenuPanel';
import { Constants } from '../../model/common/Constants';
import { ActionBarButton } from './ActionBarButton';
import { ScreenManager } from '../../model/common/ScreenManager';

const TAG: string = 'common_ActionBar';

// ActionBar，It consists of action on the left, title in the middle and menupanel on the right
@Component
export struct ActionBar {
  @Link actionBarProp: ActionBarProp;
  onMenuClicked: Function = (): void => {};
  isVideoPage: boolean = false;
  isFromPhotoBrowser: boolean = false;
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @Prop isNeedPlaceholder: boolean = false;

  createArray(): ActionBarProp[] {
    let actionBarProps: ActionBarProp[] = [];
    actionBarProps.push(this.actionBarProp);
    return actionBarProps;
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center
    }) {
      if (this.isNeedPlaceholder && !(this.actionBarProp.getMode() === ActionBarMode.SELECTION_MODE)) {
        Column() {
        }
        .padding({ left: Constants.NUMBER_40, top: Constants.NUMBER_48 })
        .width(Constants.NUMBER_32)
        .height(Constants.NUMBER_32)
      }
      if (!this.actionBarProp.getLeftAction().equals(Action.NONE)) {
        ForEach(this.createArray(), (item: ActionBarProp) => {
          ActionBarButton({
            res: item.getLeftAction().iconRes,
            action: item.getLeftAction(),
            onMenuClicked: this.onMenuClicked,
            isAutoTint: item.getLeftAction().isAutoTint,
            colorMode: item.getColorMode(),
            isFirst: true
          })
            .margin({
              right: $r('app.float.actionbar_first_icon_margin')
            })
        }, (item: ActionBarProp) => {
          return item.getLeftAction().actionID.toString()
        })
      }
      if (this.actionBarProp.getMode() === ActionBarMode.DETAIL_MODE) {
        DetailMenuPanel({ actionBarProp: this.actionBarProp, onMenuClicked: this.onMenuClicked, isLeft: true })
      } else if (this.actionBarProp.getMode() === ActionBarMode.SELECTION_MODE) {
        Stack({ alignContent: Alignment.Start }) {
          SelectionTitle({ actionBarProp: $actionBarProp })
        }.flexGrow(Constants.NUMBER_1)

        MenuPanel({ actionBarProp: $actionBarProp, onMenuClicked: this.onMenuClicked })
      } else if (this.actionBarProp.getMode() === ActionBarMode.TOP_MODE) {
        Stack({ alignContent: Alignment.Start }) {
          DetailTitle({ isVideoPage: this.isVideoPage })
        }.flexGrow(Constants.NUMBER_1)

        DetailMenuPanel({ actionBarProp: this.actionBarProp, onMenuClicked: this.onMenuClicked, isLeft: false })
      } else {
        Stack({ alignContent: Alignment.Start }) {
          SingleTitle({ actionBarProp: $actionBarProp })
        }.flexGrow(Constants.NUMBER_1)

        MenuPanel({ actionBarProp: $actionBarProp, onMenuClicked: this.onMenuClicked })
      }
    }
    .height(Constants.ActionBarHeight)
    .zIndex(Constants.NUMBER_3)
    .width(Constants.PERCENT_100)
    .backgroundColor(this.isFromPhotoBrowser ? $r('app.color.transparent') : this.actionBarProp.getBackgroundColor())
    .opacity(this.actionBarProp.getAlpha())
    .padding({ left: $r('app.float.max_padding_start') })
    .margin({
      left: this.actionBarProp.getMode() === ActionBarMode.DETAIL_MODE && !this.isHorizontal
        ? $r('app.float.album_set_page_action_bar_padding_left') : Constants.NUMBER_0
    })
  }
}