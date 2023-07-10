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

import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { TabItem, TabItemWithText } from '../model/common/TabItem';
import broadcastManager from '@ohos/base/src/main/ets/manager/BroadcastManager';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import { Constants } from '../model/common/Constants';
import screenManager, { ColumnSize } from '@ohos/base/src/main/ets/manager/ScreenManager';

export enum DEVICE_TYPE {
  DEVICE_PHONE,
  DEVICE_PAD
}

@Component
export struct TabBar {
  private TAG: string = 'TabBar';
  @Consume isSelectedMode: boolean;
  @Consume isAlbumSetSelectedMode: boolean;
  private currentIndex: number;
  @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
  private tabs: TabItem[] = [
    new TabItem($r('app.string.tab_timeline'), $r('app.media.ic_photos'), $r("app.media.ic_photos_active"), false),
    new TabItem($r('app.string.tab_albums'), $r('app.media.ic_albums'), $r("app.media.ic_albums_active"), false)
  ];
  private controller: TabsController;
  private appBroadcast: Broadcast = broadcastManager.getBroadcast();
  deviceType: DEVICE_TYPE = DEVICE_TYPE.DEVICE_PHONE;

  aboutToAppear(): void {
    this.onTabSelected = this.onTabSelected.bind(this);
    this.tabs[this.currentIndex].isSelected = true;
    this.tabs.forEach((tab: TabItem) => {
      Log.info(this.TAG, `${JSON.stringify(tab.name)} , ${tab.iconSelected}`);
    });
  }

  private onTabSelected(index: number) {
    Log.debug(this.TAG, `this.currentIndex: ${this.currentIndex} index: ${index}`);
    if (this.currentIndex == index) {
      Log.error(this.TAG, `it is same: ${index}`);
      this.appBroadcast.emit(BroadcastConstants.RESET_ZERO, [index]);
    }
    this.currentIndex = index;
    this.controller.changeIndex(this.currentIndex);
    this.tabs.forEach((tab: TabItem) => {
      tab.isSelected = false;
    })

    Log.info(this.TAG, `select ${this.currentIndex}`);
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
  tabItem: TabItem;
  @State isSelected: boolean = false;
  index: number;
  onTabSelected: Function;
  appBroadcast: Broadcast = broadcastManager.getBroadcast();

  aboutToAppear() {
    this.isSelected = this.tabItem.isSelected;
    this.appBroadcast.on(BroadcastConstants.RESET_TAB_SELECTED_STATUE, (pageNumber: number) => {
      this.isSelected = this.index == pageNumber;
    })
  }

  aboutToDisappear() {
    this.appBroadcast.off(BroadcastConstants.RESET_TAB_SELECTED_STATUE, null);
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Stack() {
        Image(this.tabItem.getIcon(this.isSelected))
          .height($r('app.float.icon_size'))
          .width($r('app.float.icon_size'))
          .objectFit(ImageFit.Fill)
      }

      Text(this.tabItem.name)
        .fontSize($r('sys.float.ohos_id_text_size_caption1'))
        .fontFamily($r('app.string.id_text_font_family_medium'))
        .fontColor(this.tabItem.getTextColor(this.isSelected))
        .padding({
          top: $r('app.float.tab_bar_text_padding_top'),
          right: $r('app.float.tab_bar_text_padding_horizontal'),
          left: $r('app.float.tab_bar_text_padding_horizontal')
        })
    }
    .onClick(() => {
      this.onTabSelected && this.onTabSelected(this.index);
      this.tabItem.isSelected = true;
      this.appBroadcast.emit(BroadcastConstants.RESET_TAB_SELECTED_STATUE, [this.index]);
    })
  }
}

// For Album Set
@Component
export struct TabBarForAlbumSet {
  private TAG: string = 'TabBarForAlbumSet'
  @Consume isTabBarShow: boolean;
  private currentIndex: number;
  private tabs: TabItemWithText[] = [];
  private controller: TabsController;
  @State tabWidth: string = '100%';
  @State tabCol: Resource = $r('app.float.album_tab_col_4_gap');
  @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();

  aboutToAppear(): void {
    this.onTabSelected = this.onTabSelected.bind(this);
    this.tabs[this.currentIndex].isSelected = true;
    this.tabs.forEach((tab: TabItemWithText) => {
      Log.info(this.TAG, `${JSON.stringify(tab.name)}, ${tab.isSelected}`);
    });
    let col = screenManager.getScreenColumns();
    if (col < ColumnSize.COLUMN_EIGHT) {
      this.tabWidth = '100%';
      this.tabCol = $r('app.float.album_tab_col_4_gap');
    } else {
      let sideWidth = this.isSidebar ? Constants.TAB_BAR_WIDTH : 0;
      this.tabWidth = (screenManager.getWinWidth() - sideWidth) / Constants.NUMBER_2 + 'vp';
      this.tabCol = $r('app.float.album_tab_col_8_gap');
    }
    Log.info(this.TAG, `album tabs item width: ${this.tabWidth}, col: ${col}`);
  }

  private onTabSelected(index: number) {
    Log.info(this.TAG, `this.currentIndex: ${this.currentIndex} index: ${index}`);
    this.currentIndex = index;
    this.controller.changeIndex(this.currentIndex);
    this.tabs.forEach((tab: TabItemWithText) => {
      tab.isSelected = false;
    })
    Log.info(this.TAG, `select ${this.currentIndex}`);
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Start
    }) {
      Grid() {
        ForEach(this.tabs, (tab: TabItemWithText) => {
          GridItem() {
            TabWithText({
              tabItemWithText: tab,
              index: this.tabs.indexOf(tab),
              onTabSelected: this.onTabSelected
            })
          }
        }, tab => tab.name.id)
      }
      .width(this.tabWidth)
      .columnsTemplate('1fr '.repeat(this.tabs.length))
      .columnsGap(this.tabCol)
    }
    .width('100%')
    .height($r('app.float.album_set_tab_bar_height'))
    .padding({ left: $r('app.float.max_padding_start'), right: $r('app.float.max_padding_end') })
    .backgroundColor($r('app.color.default_background_color'))
  }
}

// single tab which only has text
// For Album Set
@Component
struct TabWithText {
  private TAG: string = 'TabWithText'
  @Consume isAlbumSetSelectedMode: boolean;
  tabItemWithText: TabItemWithText;
  @State isSelected: boolean = false;
  @State TabWidth: number = 0;
  index: number;
  onTabSelected: Function;
  appBroadcast: Broadcast = broadcastManager.getBroadcast();

  aboutToAppear(): void {
    // Determine the length of the underline based on the font length
    if (this.index == 0) {
      this.TabWidth = px2vp(fp2px(Constants.TEXT_SIZE_SUB_TITLE2)) * 2;
    } else {
      this.TabWidth = px2vp(fp2px(Constants.TEXT_SIZE_SUB_TITLE2)) * 4;
    }
    Log.info(this.TAG, `index is ${this.index} and TabWidth is ${this.TabWidth}`);
    this.isSelected = this.tabItemWithText.isSelected;
    this.appBroadcast.on(BroadcastConstants.RESET_TAB_SELECTED_TEXT, (pageNumber: number) => {
      this.isSelected = this.index == pageNumber;
    })
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      Text(this.tabItemWithText.name)
        .fontSize(this.tabItemWithText.getTextSize(this.isSelected))
        .fontWeight(this.tabItemWithText.getTextWeight(this.isSelected))
        .fontColor(this.tabItemWithText.getTextColor(this.isSelected))
        .maxLines(1)
        .margin({ top: $r('app.float.tab_bar_line_margin_top'),
          left: $r('app.float.single_tab_margin'),
          right: $r('app.float.single_tab_margin'),
          bottom: $r('app.float.tab_bar_line_margin_top') })
      Column()
        .width(this.TabWidth)
        .height($r('app.float.tab_bar_line_height'))
        .borderRadius($r('app.float.tab_bar_line_radius'))
        .backgroundColor(this.tabItemWithText.getTextColor(this.isSelected))
        .visibility(this.tabItemWithText.isSelected ? Visibility.Visible : Visibility.Hidden)
    }
    .height('100%')
    .width('100%')
    .onClick(() => {
      if (!this.isAlbumSetSelectedMode) {
        this.onTabSelected && this.onTabSelected(this.index)
        this.tabItemWithText.isSelected = true;
        this.appBroadcast.emit(BroadcastConstants.RESET_TAB_SELECTED_TEXT, [this.index]);
      }
    })
  }
}