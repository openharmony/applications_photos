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

import { Log } from '../utils/Log';
import { TabItem, TabItemWithText } from '../model/common/TabItem';
import { BroadCastManager } from '../model/common/BroadCastManager';
import { BroadCast } from '../utils/BroadCast';
import { BroadCastConstants } from '../model/common/BroadCastConstants';
import { Constants } from '../model/common/Constants';
import { BigDataConstants, ReportToBigDataUtil } from '../utils/ReportToBigDataUtil';

const TAG: string = 'common_TabBar';

export enum DEVICE_TYPE {
  PHONE_LIKE,
  PC_LIKE
}

const TabMap = {
  0: BigDataConstants.PHOTO_TAB,
  1: BigDataConstants.ALBUM_TAB,
}

@Component
export struct TabBar {
  @Consume isSelectedMode: boolean;
  @Consume isAlbumSetSelectedMode: boolean;
  @Consume isShowSideBar: boolean;
  @Link @Watch('updateCurrentIndex') currentIndex: number;
  @Link isSidebar: boolean;
  @StorageLink('sideBarBoundaryLineOpacity') sideBarBoundaryLineOpacity: number = 1;
  @StorageLink('sideBarOpacity') sideBarOpacity: number = 1;
  private tabs: TabItem[] = [];
  private controller: TabsController;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private deviceType: DEVICE_TYPE = DEVICE_TYPE.PC_LIKE;

  aboutToAppear(): void {
    this.onTabSelected = this.onTabSelected.bind(this);
    this.tabs[this.currentIndex].isSelected = true;
    this.tabs.forEach((tab: TabItem) => {
      Log.info(TAG, `${JSON.stringify(tab.name)} , ${tab.iconSelected}`)
    });
  }

  updateCurrentIndex() {
    this.onTabSelected(this.currentIndex);
  }

  build() {
    if (this.isSidebar) {
      if (this.deviceType == DEVICE_TYPE.PC_LIKE) {
        Row() {
          Flex({
            direction: FlexDirection.Column,
            alignItems: ItemAlign.Start,
            justifyContent: FlexAlign.Start
          }) {
            ForEach(this.tabs, (tab: TabItem) => {
              Tab({
                tabItem: tab,
                index: this.tabs.indexOf(tab),
                onTabSelected: this.onTabSelected,
                isSidebar: $isSidebar,
                deviceType: this.deviceType
              })
            }, tab => tab.name.id)
          }
          .padding({ left: Constants.NUMBER_16, top: Constants.NUMBER_96, right: Constants.NUMBER_16 })
          .flexGrow(Constants.NUMBER_1)
          .backgroundColor($r('app.color.default_background_color'))

          // Sidebar boundary line
          if (this.isShowSideBar) {
            Row() {
            }
            .width(Constants.NUMBER_0)
            .height(Constants.PERCENT_100)
            .border({ width: Constants.NUMBER_0_5, color: $r('app.color.album_cover_gradient_start_color') })
            .opacity(this.sideBarBoundaryLineOpacity)
          }
        }
      } else {
        Flex({
          direction: FlexDirection.Column,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.Center
        }) {
          Column() {
            ForEach(this.tabs, (tab: TabItem) => {
              Stack() {
                Tab({
                  tabItem: tab,
                  index: this.tabs.indexOf(tab),
                  onTabSelected: this.onTabSelected,
                  isSidebar: $isSidebar,
                  deviceType: this.deviceType
                })
              }
              .layoutWeight(Constants.NUMBER_1)
            }, tab => tab.name.id)
          }
          .height($r('app.float.horizontal_width'))
        }
        .width($r('app.float.tab_bar_width'))
        .backgroundColor($r('app.color.default_background_color'))
      }

    } else {
      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center
      }) {
        ForEach(this.tabs, (tab: TabItem) => {
          Stack() {
            TabPhone({ tabItem: tab, index: this.tabs.indexOf(tab), onTabSelected: this.onTabSelected })
          }
          .layoutWeight(1)
          .onClick(() => {
            this.onTabSelected && this.onTabSelected(this.tabs.indexOf(tab));
            tab.isSelected = true;
          })
        }, tab => tab.name.id)
      }
      .visibility((this.isSelectedMode || this.isAlbumSetSelectedMode) ? Visibility.None : Visibility.Visible)
      .height($r('app.float.tab_bar_vertical_height'))
      .backgroundColor($r('app.color.default_background_color'))
      .padding({ left: $r('app.float.max_padding_start'), right: $r('app.float.max_padding_end') })
    }
  }

  private onTabSelected(index: number): void {
    Log.debug(TAG, `this.currentIndex: ${this.currentIndex} index: ${index}`);
    if (this.currentIndex == index) {
      Log.error(TAG, `it is same: ${index}`);
      this.appBroadCast.emit(BroadCastConstants.RESET_ZERO, [index]);
    }
    this.currentIndex = index;
    this.controller.changeIndex(this.currentIndex);
    this.tabs.forEach((tab: TabItem) => {
      if (this.tabs.indexOf(tab) == index) {
        tab.isSelected = true;
      } else {
        tab.isSelected = false;
      }
    })
    let currentTab = TabMap[this.currentIndex] ? TabMap[this.currentIndex] : BigDataConstants.PHOTO_TAB;
    let msg = {
      'SwitchTab': BigDataConstants.CLICK_SWITCH,
      'Current': currentTab,
    }
    ReportToBigDataUtil.report(BigDataConstants.TAB_SWITCH_ID, msg);
    Log.info(TAG, `select ${this.currentIndex}`);
  }
}

// single tab
@Component
struct Tab {
  @ObjectLink tabItem: TabItem;
  @Link isSidebar: boolean;
  index: number;
  onTabSelected: Function;
  private deviceType: number;

  build() {
    if (this.deviceType == DEVICE_TYPE.PC_LIKE) {
      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Start
      }) {
        Stack() {
          Image(this.tabItem.getIcon(this.tabItem.isSelected))
            .height($r('app.float.icon_size'))
            .width($r('app.float.icon_size'))
            .objectFit(ImageFit.Fill)
        }
        .padding({
          left: $r('app.float.tab_bar_text_padding_left'),
        })

        Text(this.tabItem.name)
          .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
          .fontWeight(FontWeight.Medium)
          .fontColor(this.tabItem.getTextColor())
          .padding({
            left: $r('app.float.tab_bar_text_padding_left'),
            top: $r('app.float.tab_bar_text_padding_horizontal'),
            bottom: $r('app.float.tab_bar_text_padding_horizontal')
          })
          .height($r('app.float.menu_height'))
      }
      .backgroundColor(this.tabItem.isSelected ? '#DAE2F5' : $r('app.color.transparent'))
      .borderRadius($r('app.float.single_tab_margin'))
      .onClick(() => {
        this.onTabSelected && this.onTabSelected(this.index);
        this.tabItem.isSelected = true;
      })
    } else {
      Flex({
        direction: FlexDirection.Column,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center,
      }) {
        Stack() {
          Image(this.tabItem.getIcon(this.tabItem.isSelected))
            .height($r('app.float.icon_size'))
            .width($r('app.float.icon_size'))
            .objectFit(ImageFit.Fill)
        }
        .padding({
          left: this.isSidebar ? Constants.NUMBER_0 : $r('app.float.tab_bar_text_padding_left'),
        })

        Text(this.tabItem.name)
          .fontSize($r('sys.float.ohos_id_text_size_caption1'))
          .fontFamily($r('app.string.id_text_font_family_medium'))
          .fontColor(this.tabItem.getTextColor())
          .padding({
            left: $r('app.float.tab_bar_text_padding_horizontal'),
            top: $r('app.float.tab_bar_text_padding_top'),
            right: $r('app.float.tab_bar_text_padding_horizontal')
          })
      }
      .onClick(() => {
        this.onTabSelected && this.onTabSelected(this.index);
        this.tabItem.isSelected = true;
      })
    }
  }
}

// phone bottom tab
@Component
struct TabPhone {
  @ObjectLink tabItem: TabItem;
  index: number;
  onTabSelected: Function;

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Image(this.tabItem.getIcon(this.tabItem.isSelected))
        .height($r('app.float.icon_size'))
        .width($r('app.float.icon_size'))
        .objectFit(ImageFit.Fill)
        .margin({
          bottom: $r('app.float.tab_bar_image_bottom')
        })
      Text(this.tabItem.name)
        .fontSize($r('app.float.tab_bar_text_size'))
        .fontWeight(FontWeight.Medium)
        .fontColor(this.tabItem.getTextColor())
    }
    .key('Tab' + this.tabItem.componentKey)
    .padding({
      top: $r('app.float.tab_bar_padding_top'),
      left: $r('app.float.tab_bar_padding_left'),
      right: $r('app.float.tab_bar_padding_right'),
      bottom: $r('app.float.tab_bar_padding_bottom'),
    })
    .height($r('app.float.tab_bar_vertical_height'))
    .borderRadius($r('app.float.single_tab_margin'))
  }
}

// For Album Set
@Component
export struct TabBarForAlbumSet {
  @Consume isTabBarShow: boolean;
  private currentIndex: number;
  private tabs: TabItemWithText[] = [];
  private controller: TabsController;

  aboutToAppear(): void {
    this.onTabSelected = this.onTabSelected.bind(this);
    this.tabs[this.currentIndex].isSelected = true;
    this.tabs.forEach((tab: TabItemWithText) => {
      Log.info(TAG, `${JSON.stringify(tab.name)}, ${tab.isSelected}`);
    });
  }

  build() {
    if (this.isTabBarShow) {
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
      .height($r('app.float.album_set_tab_bar_height'))
      .padding({ left: $r('app.float.max_padding_start'), right: $r('app.float.max_padding_end') })
      .backgroundColor($r('app.color.default_background_color'))
    }
  }

  private onTabSelected(index: number) {
    Log.info(TAG, `this.currentIndex: ${this.currentIndex} index: ${index}`);
    this.currentIndex = index;
    this.controller.changeIndex(this.currentIndex);
    this.tabs.forEach((tab: TabItemWithText) => {
      tab.isSelected = false;
    })
    Log.info(TAG, `select ${this.currentIndex}`);
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

  aboutToAppear(): void {
    // Determine the length of the underline based on the font length
    if (this.index == 0) {
      this.TabWidth = px2vp(fp2px(Constants.TEXT_SIZE_SUB_TITLE2)) * 2;
    } else {
      this.TabWidth = px2vp(fp2px(Constants.TEXT_SIZE_SUB_TITLE2)) * 4;
    }
    Log.info(TAG, `index is ${this.index} and TabWidth is ${this.TabWidth}`);
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