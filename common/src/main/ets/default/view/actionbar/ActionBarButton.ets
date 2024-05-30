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

import { Action } from '../browserOperation/Action';
import { ActionBarColorMode } from '../browserOperation/ActionBarMode';
import { ColumnSize, ScreenManager } from '../../model/common/ScreenManager';
import { Constants } from '../../model/common/Constants';

@Component
export struct ActionBarButton {
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @State res: Resource | undefined = undefined;
  action: Action = Action.NONE;
  onMenuClicked: Function = (): void => {};
  isLeft = true;
  isFirst = false;
  isAutoTint = true;
  colorMode: ActionBarColorMode = ActionBarColorMode.NORMAL;
  @State showPopup: boolean = false;
  @Consume moreMenuList: Action[];
  @Consume @Watch('isNeedHidePopup') hidePopup: boolean;
  private isPadDeviceType: boolean = false;

  aboutToAppear(): void {
    this.isPadDeviceType = AppStorage.get<string>('deviceType') !== Constants.DEFAULT_DEVICE_TYPE;
  }

  isNeedHidePopup(): void {
    if (this.hidePopup) {
      this.showPopup = false;
    }
  }

  @Builder
  PopupBuilder() {
    Column() {
      ForEach(this.moreMenuList, (menu: Action, index?: number) => {
        Text(menu.textRes)
          .width('100%')
          .height($r('app.float.menu_height'))
          .fontColor(menu.fillColor)
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .onClick(() => {
            this.onMenuClicked && this.onMenuClicked(menu);
          })
          .key('ActionBarButton_Text_' + menu.componentKey)
        if (this.moreMenuList.indexOf(menu) != this.moreMenuList.length - 1) {
          Divider()
            .width('100%')
            .strokeWidth(Constants.MENU_DIVIDER_STROKE_WIDTH)
            .color($r('sys.color.ohos_id_color_list_separator'))
            .key('ActionBarButton_Divider_' + menu.componentKey)
        }
      }, (menu: Action) => menu.actionID.toString())
    }
    .width(ScreenManager.getInstance().getColumnsWidth(ColumnSize.COLUMN_TWO))
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
    .padding({
      top: $r('app.float.menu_padding_vertical'),
      bottom: $r('app.float.menu_padding_vertical'),
      left: $r('app.float.menu_padding_horizontal'),
      right: $r('app.float.menu_padding_horizontal')
    })
    .backgroundColor(Color.White)
    .margin({
      right: this.isHorizontal ? $r('sys.float.ohos_id_max_padding_end') : $r('app.float.menu_margin_right'),
      bottom: this.isHorizontal ? 0 : $r('app.float.menu_margin_bottom')
    })
  }

  @Builder
  ActionBarButtonBuilder() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      if (this.isAutoTint) {
        Image(this.res)
          .height($r('app.float.icon_size'))
          .width($r('app.float.icon_size'))
          .fillColor(this.colorMode == ActionBarColorMode.TRANSPARENT ?
          Action.ICON_DEFAULT_COLOR_CONTRARY : this.action.fillColor)
      } else {
        Image(this.res)
          .height($r('app.float.icon_size'))
          .width($r('app.float.icon_size'))
      }
    }
    .key('ActionBarButton' + this.action.componentKey)
  }

  build() {
    if (this.action.actionID == Action.MORE.actionID) {
      Row() {
        this.ActionBarButtonBuilder()
      }
      .onClick(() => {
        this.showPopup = !this.showPopup
      })
      .bindPopup(this.showPopup, {
        builder: this.PopupBuilder,
        placement: Placement.Top,
        popupColor: '#00FFFFFF',
        enableArrow: false,
        onStateChange: (e) => {
          if (!e.isVisible) {
            this.showPopup = false;
          } else {
            this.hidePopup = false;
          }
        }
      })
    } else {
      Row() {
        this.ActionBarButtonBuilder()
      }
      .onClick(() => {
        this.onMenuClicked && this.onMenuClicked(this.action)
      })
    }
  }
}