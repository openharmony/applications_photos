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

import { Logger } from '../utils/Logger'
import { TabItem, TabItemWithText } from '../model/common/TabItem'
import { BroadCastManager } from '../model/common/BroadCastManager'
import { BroadCast } from '../utils/BroadCast'
import { BroadCastConstants } from '../model/common/BroadCastConstants'
import { Constants } from '../model/common/Constants'
import { ScreenManager } from '../model/common/ScreenManager';

export enum DEVICE_TYPE {
    DEVICE_PHONE,
    DEVICE_PAD
}

@Component
export struct TabBar {
    @Consume isSelectedMode: boolean;
    @Consume isAlbumSetSelectedMode: boolean;
    private currentIndex: number;
    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
    private tabs: TabItem[] = [];
    private controller: TabsController;
    private logger: Logger = new Logger('TabBar');
    private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
    deviceType: DEVICE_TYPE = DEVICE_TYPE.DEVICE_PHONE;

    aboutToAppear(): void {
        this.onTabSelected = this.onTabSelected.bind(this);
        this.tabs[this.currentIndex].isSelected = true;
        this.tabs.forEach((tab: TabItem) => {
            this.logger.info(`${JSON.stringify(tab.name)} , ${tab.iconSelected}`)
        });
    }

    private onTabSelected(index: number) {
        this.logger.debug(`this.currentIndex: ${this.currentIndex} index: ${index}`);
        if (this.currentIndex == index) {
            this.logger.error(`it is same: ${index}`);
            this.appBroadCast.emit(BroadCastConstants.RESET_ZERO, [index]);
        }
        this.currentIndex = index;
        this.controller.changeIndex(this.currentIndex);
        this.tabs.forEach((tab: TabItem) => {
            tab.isSelected = false;
        })

        this.logger.info(`select ${this.currentIndex}`);
    }

    build() {
        if (this.isSidebar) {
            Flex({
                direction: FlexDirection.Column,
                alignItems: ItemAlign.Center,
                justifyContent: FlexAlign.Center
            }) {
                Column() {
                    ForEach(this.tabs, (tab: TabItem) => {
                        Stack() {
                            Tab({ tabItem: tab, index: this.tabs.indexOf(tab), onTabSelected: this.onTabSelected })
                        }.layoutWeight(1)
                    }, tab => tab.name.id)
                }
                .height(DEVICE_TYPE.DEVICE_PAD == this.deviceType ? $r('app.float.horizontal_width') : '100%')
            }
            .markAnchor({ x: '0%', y: '0%' })
            .position({ x: '0%', y: '0%' })
            .width($r('app.float.tab_bar_width'))
            .backgroundColor($r('app.color.default_background_color'))
        } else {
            Flex({
                direction: FlexDirection.Row,
                alignItems: ItemAlign.Center,
                justifyContent: FlexAlign.Center
            }) {
                ForEach(this.tabs, (tab: TabItem) => {
                    Stack() {
                        Tab({ tabItem: tab, index: this.tabs.indexOf(tab), onTabSelected: this.onTabSelected })
                    }.layoutWeight(1)
                }, tab => tab.name.id)
            }
            .markAnchor({ x: '0%', y: '100%' })
            .position({ x: '0%', y: '100%' })
            .visibility((this.isSelectedMode || this.isAlbumSetSelectedMode) ? Visibility.None : Visibility.Visible)
            .height('56vp')
            .backgroundColor($r('app.color.default_background_color'))
        }
    }
}

// single tab
@Component
struct Tab {
    @ObjectLink tabItem: TabItem;
    index: number;
    onTabSelected: Function;

    build() {
        Flex({
            direction: FlexDirection.Column,
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.Center
        }) {
            Stack() {
                Image(this.tabItem.getIcon(this.tabItem.isSelected))
                    .height($r('app.float.icon_size'))
                    .width($r('app.float.icon_size'))
                    .objectFit(ImageFit.Fill)
            }

            Text(this.tabItem.name)
                .fontSize($r('sys.float.ohos_id_text_size_caption1'))
                .fontFamily($r('app.string.id_text_font_family_medium'))
                .fontColor(this.tabItem.getTextColor())
                .padding({
                    top: $r('app.float.tab_bar_text_padding_top'),
                    right: $r('app.float.tab_bar_text_padding_horizontal'),
                    left: $r('app.float.tab_bar_text_padding_horizontal')
                })
        }
        .onClick(() => {
            this.onTabSelected && this.onTabSelected(this.index);
            this.tabItem.isSelected = true;
        })
    }
}

// For Album Set
@Component
export struct TabBarForAlbumSet {
    @Consume isTabBarShow: boolean;
    private currentIndex: number;
    private tabs: TabItemWithText[] = [];
    private controller: TabsController;
    private logger: Logger = new Logger('TabBarForAlbumSet');

    aboutToAppear(): void {
        this.onTabSelected = this.onTabSelected.bind(this);
        this.tabs[this.currentIndex].isSelected = true;
        this.tabs.forEach((tab: TabItemWithText) => {
            this.logger.info(`${JSON.stringify(tab.name)}, ${tab.isSelected}`);
        });
    }

    private onTabSelected(index: number) {
        this.logger.info(`this.currentIndex: ${this.currentIndex} index: ${index}`);
        this.currentIndex = index;
        this.controller.changeIndex(this.currentIndex);
        this.tabs.forEach((tab: TabItemWithText) => {
            tab.isSelected = false;
        })
        this.logger.info(`select ${this.currentIndex}`);
    }

    build() {
        Flex({
            direction: FlexDirection.Row,
            justifyContent: FlexAlign.Center,
            alignItems: ItemAlign.Start
        }) {
            ForEach(this.tabs, (tab: TabItemWithText) => {
                TabWithText({ tabItemWithText: tab, index: this.tabs.indexOf(tab), onTabSelected: this.onTabSelected })
            }, tab => tab.name.id)
        }
        .width('100%')
        .visibility(this.isTabBarShow ? Visibility.Visible : Visibility.None)
        .height($r('app.float.album_set_tab_bar_height'))
        .padding({ left: $r('app.float.max_padding_start'), right: $r('app.float.max_padding_end') })
        .backgroundColor($r('app.color.default_background_color'))
    }
}

// single tab which only has text
// For Album Set
@Component
struct TabWithText {
    @Consume isAlbumSetSelectedMode: boolean;
    @ObjectLink tabItemWithText: TabItemWithText;
    @State TabWidth: number = 0;
    index: number;
    onTabSelected: Function;
    private logger: Logger = new Logger('TabWithText');

    aboutToAppear(): void {
        // Determine the length of the underline based on the font length
        if (this.index == 0) {
            this.TabWidth = px2vp(fp2px(Constants.TEXT_SIZE_SUB_TITLE2)) * 2;
        } else {
            this.TabWidth = px2vp(fp2px(Constants.TEXT_SIZE_SUB_TITLE2)) * 4;
        }
        this.logger.info(`index is ${this.index} and TabWidth is ${this.TabWidth}`);
    }

    build() {
        Flex({
            direction: FlexDirection.Column,
            justifyContent: FlexAlign.Center,
            alignItems: ItemAlign.Center
        }) {
            Text(this.tabItemWithText.name)
                .fontSize(this.tabItemWithText.getTextSize())
                .fontWeight(this.tabItemWithText.getTextWeight())
                .fontColor(this.tabItemWithText.getTextColor())
                .maxLines(1)
                .margin({ top: $r('app.float.tab_bar_line_margin_top'),
                    left: $r('app.float.single_tab_margin'),
                    right: $r('app.float.single_tab_margin'),
                    bottom: $r('app.float.tab_bar_line_margin_top') })
            Column()
                .width(this.TabWidth)
                .height($r('app.float.tab_bar_line_height'))
                .borderRadius($r('app.float.tab_bar_line_radius'))
                .backgroundColor(this.tabItemWithText.getTextColor())
                .visibility(this.tabItemWithText.isSelected ? Visibility.Visible : Visibility.Hidden)
        }
        .height('100%')
        .onClick(() => {
            if (!this.isAlbumSetSelectedMode) {
                this.onTabSelected && this.onTabSelected(this.index)
                this.tabItemWithText.isSelected = true
            }
        })
    }
}