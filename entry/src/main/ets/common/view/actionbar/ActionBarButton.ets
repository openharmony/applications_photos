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

import {Action} from '../../model/browser/operation/Action.ets'
import {ActionBarColorMode} from '../../model/browser/operation/ActionBarMode.ets'
import {ScreenManager, ColumnSize} from '../../model/common/ScreenManager.ets';
import {Constants} from '../../model/common/Constants.ets';

@Component
export struct ActionBarButton {
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @State res: Resource = undefined;
    action: Action;
    onMenuClicked: Function;
    isLeft = true;
    isFirst = false;
    isAutoTint = true;
    colorMode: ActionBarColorMode;
    @State showPopup: boolean = false
    @Consume moreMenuList: Action[];

    private aboutToAppear(): void {}

    @Builder PopupBuilder() {
        Column() {
            ForEach(this.moreMenuList, (menu: Action) => {
                Text(menu.textRes)
                    .width(ScreenManager.getInstance().getColumnsWidth(ColumnSize.COLUMN_TWO))
                    .height($r('app.float.menu_height'))
                    .fontColor(menu.fillColor)
                    .fontSize($r('sys.float.ohos_id_text_size_body1'))
                    .onClick(() => {
                        this.onMenuClicked && this.onMenuClicked(menu);
                    })
                if (this.moreMenuList.indexOf(menu) != this.moreMenuList.length - 1) {
                    Divider()
                        .width(ScreenManager.getInstance().getColumnsWidth(ColumnSize.COLUMN_TWO))
                        .strokeWidth(Constants.MENU_DIVIDER_STROKE_WIDTH)
                        .color($r('sys.color.ohos_id_color_list_separator'))
                }
            }, menu => (menu.actionType != null ? menu.actionType.id : menu.actionID))
        }
        .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
        .padding({
            top: $r('app.float.menu_padding_vertical'),
            bottom: $r('app.float.menu_padding_vertical'),
            left: $r('app.float.menu_padding_horizontal'),
            right: $r('app.float.menu_padding_horizontal')
        })
            .backgroundColor(Color.White)
            .margin({
                right: this.isHorizontal ? $r('app.float.menu_horizontal_margin_right') : $r('app.float.menu_margin_right'),
                bottom: this.isHorizontal ? 0 : $r('app.float.menu_margin_bottom'),
                top: this.isHorizontal ? $r('app.float.menu_horizontal_margin_top') : 0
            })
    }

    @Builder ActionBarButtonBuilder() {
        Flex({
            direction: FlexDirection.Column,
            justifyContent: FlexAlign.Center,
            alignItems: ItemAlign.Center
        }) {
            if (this.isAutoTint) {
                Image(this.res)
                    .commonButtonStyle()
                    .fillColor(this.colorMode == ActionBarColorMode.TRANSPARENT ?
                        Action.ICON_DEFAULT_COLOR_CONTRARY : this.action.fillColor)
            } else {
                Image(this.res)
                    .commonButtonStyle()
            }
        }
        .height($r('app.float.default_button_size'))
            .width($r('app.float.default_button_size'))
            .margin({ left: (this.action == Action.NAVIGATION) ? $r('app.float.max_padding_start') : 0 })
    }

    build() {
        if (this.action == Action.MORE) {
            Row() {
                this.ActionBarButtonBuilder()
            }
            .onClick(() => {
                this.showPopup = !this.showPopup
            })
                .bindPopup(this.showPopup, {
                    builder: this.PopupBuilder,
                    placement: Placement.Top,
                    maskColor: 0x33000000,
                    popupColor: '#00FFFFFF',
                    enableArrow: false,
                    onStateChange: (e) => {
                        if (!e.isVisible) {
                            this.showPopup = false
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

@Extend(Image) function commonButtonStyle () {
    .height($r('app.float.icon_size'))
        .width($r('app.float.icon_size'))
}