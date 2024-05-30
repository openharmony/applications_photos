/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { ColumnSize, ScreenManager } from '../../model/common/ScreenManager';
import { ToolBarButton } from './ToolBarButton';
import { Constants } from '../../model/common/Constants';
import { ActionBarProp } from '../browserOperation/ActionBarProp';
import { Action } from '../browserOperation/Action';
import { ActionBarMode } from '../browserOperation/ActionBarMode';

export class MenuItem {
  public value?: string;
  public action?: () => void;
}

@Component
export struct ToolBar {
  @Consume isShowBar: boolean;
  @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  @Consume toolMenuList: Action[];
  @Consume moreMenuList: Action[];
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @State showPopup: boolean = false;
  onMenuClicked: Function = (): void => {};
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @Consume @Watch('isNeedHidePopup') hidePopup: boolean;
  private isFromPhotoBrowser = false;

  aboutToAppear(): void {
    this.actionBarProp = this.createActionBar();
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
          .key('ToolBarPopupBuilderTextOf' + menu.componentKey)
          .width(Constants.PERCENT_100)
          .height($r('app.float.menu_height'))
          .fontColor(menu.fillColor)
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontWeight(FontWeight.Regular)
          .onClick(() => {
            this.onMenuClicked && this.onMenuClicked(menu);
          })
        if (this.moreMenuList.indexOf(menu) != this.moreMenuList.length - 1) {
          Divider()
            .width(Constants.PERCENT_100)
            .strokeWidth(Constants.MENU_DIVIDER_STROKE_WIDTH)
            .color($r('sys.color.ohos_id_color_list_separator'))
        }
      }, (menu: Action) => menu.actionID.toString())
    }
    .width(ScreenManager.getInstance().getColumnsWidth(ColumnSize.COLUMN_TWO))
    .borderRadius($r('sys.float.ohos_id_corner_radius_card'))
    .padding({
      top: $r('app.float.menu_padding_vertical'),
      bottom: $r('app.float.menu_padding_vertical'),
      left: $r('app.float.menu_padding_horizontal'),
      right: $r('app.float.menu_padding_horizontal')
    })
    .backgroundColor(Color.White)
  }

  build() {
    Row() {
      Row() {
        ForEach(this.toolMenuList, (menu: Action, index?: number) => {
          if (menu.actionID == Action.MORE.actionID) {
            Column() {
              Row() {
                ToolBarButton({
                  res: menu.iconRes,
                  action: menu,
                  isLeft: true,
                  isAutoTint: menu.isAutoTint,
                  colorMode: this.actionBarProp.getColorMode()
                })
              }.margin({ top: $r('app.float.id_icon_margin_vertical') })

              Row() {
                Text(menu.textRes)
                  .key('ToolBar_Text' + menu.componentKey)
                  .fontSize($r('sys.float.ohos_id_text_size_caption'))
                  .fontFamily($r('app.string.id_text_font_family_regular'))
                  .fontColor(menu.fillColor)
              }.margin({ top: $r('app.float.tab_bar_image_bottom') })
            }
            .key('ToolBarButton' + menu.componentKey)
            .width(`${100 / this.toolMenuList.length}%`)
            .height(Constants.PERCENT_100)
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
            Column() {
              Row() {
                ToolBarButton({
                  res: menu.iconRes,
                  action: menu,
                  isLeft: true,
                  isAutoTint: menu.isAutoTint,
                  colorMode: this.actionBarProp.getColorMode()
                })
              }.margin({ top: $r('app.float.id_icon_margin_vertical') })

              Row() {
                Text(menu.textRes)
                  .fontSize($r('sys.float.ohos_id_text_size_caption'))
                  .fontFamily($r('app.string.id_text_font_family_regular'))
                  .fontColor(menu.fillColor)
              }
              .margin({ top: $r('sys.float.ohos_id_text_margin_vertical') })
            }
            .key('ToolBarButton' + menu.componentKey)
            .onClick(() => {
              this.onMenuClicked && this.onMenuClicked(menu)
            })
            .width(`${100 / this.toolMenuList.length}%`)
            .height(Constants.PERCENT_100)
          }
        }, (menu: Action) => menu.actionID.toString())
      }
      .width(Constants.PERCENT_100)
      .height(Constants.ActionBarHeight)
      .padding(this.toolMenuList.length >= 4 ? {} : { left: $r('app.float.actionbar_margin_horizontal'),
                                                      right: $r('app.float.actionbar_margin_horizontal') })
    }
    .width(Constants.PERCENT_100)
    .backgroundColor(this.isFromPhotoBrowser ? $r('app.color.transparent') : this.actionBarProp.getBackgroundColor())
    .opacity(this.actionBarProp.getAlpha())
    .visibility((this.isShowBar || this.isFromPhotoBrowser) &&
      !this.isHorizontal ? Visibility.Visible : Visibility.Hidden)
    .markAnchor({ x: Constants.PERCENT_0, y: this.isFromPhotoBrowser ? Constants.PERCENT_0 : Constants.PERCENT_100 })
    .position({ x: Constants.PERCENT_0, y: this.isFromPhotoBrowser ? Constants.PERCENT_0 : Constants.PERCENT_100 })
  }

  private createActionBar(): ActionBarProp {
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setMode(ActionBarMode.DETAIL_MODE)
      .setAlpha(ActionBarProp.PHOTO_BROWSER_ACTIONBAR_ALPHA)
    return actionBarProp;
  }
}