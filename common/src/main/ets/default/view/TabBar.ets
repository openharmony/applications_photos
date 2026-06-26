/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import lazy { Log } from '../utils/Log';
import lazy { TabItem, TabItemWithText } from '../model/common/TabItem';
import lazy { BroadCastManager } from '../model/common/BroadCastManager';
import lazy { BroadCast } from '../utils/BroadCast';
import lazy { Constants } from '../model/common/Constants';
import lazy { DeviceInfo } from '../utils/DeviceInfo';
import lazy { ColumnsWidth } from '../model/common/ColumnsWidth';
import lazy { ColumnSize, getScreen, ScreenManager } from '../model/common/ScreenManager';
import lazy { SearchSwitchManager } from '../manager/SearchSwitchManager';
import lazy { BroadCastConstants } from '../model/common/BroadCastConstants';

/* instrument ignore file */
const TAG: string = 'common_TabBar';

@Component
export struct TabBar {
  @Provide isSelectedMode: boolean = false;
  @Consume isAlbumSetSelectedMode: boolean;
  @Consume isShowSideBar: boolean;
  @Link @Watch('updateCurrentIndex') currentIndex: number;
  @Link isSidebar: boolean;
  @StorageLink('sideBarBoundaryLineOpacity') sideBarBoundaryLineOpacity: number = 1;
  @StorageLink('sideBarOpacity') sideBarOpacity: number = 1;
  private tabs: TabItem[] = [];
  private controller: TabsController | null = null;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private funcOnTabSelected?: Function;
  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();
  @State listCardWidth: number = 0;

  private onWinSizeChanged(): void {
    this.listCardWidth = ColumnsWidth.updateListCardWidth();
  }

  aboutToDisappear() {
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
  }

  aboutToAppear(): void {
    this.funcOnTabSelected = (index: number): void => this.onTabSelected(index);
    if (this.tabs[this.currentIndex]) {
      this.tabs[this.currentIndex].isSelected = true;
    }
    this.tabs.forEach((tab: TabItem) => {
      Log.info(TAG, `${JSON.stringify(tab.name)} , ${tab.iconSelected}`);
    });
    getScreen().setSystemUi(false);
    this.onWinSizeChanged();
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    this.listCardWidth = ColumnsWidth.updateListCardWidth();
  }

  // 更新TabIndex
  updateCurrentIndex(): void {
    this.onTabSelected(this.currentIndex);
  }

  build() {
    if (this.isSidebar) {
      /* instrument ignore next */
      if (DeviceInfo.isPcOrTablet()) {
        Row() {
          Flex({
            direction: FlexDirection.Column,
            alignItems: ItemAlign.Start,
            justifyContent: FlexAlign.Start,
          }) {
            ForEach(this.tabs, (tab: TabItem) => {
              Tab({
                tabItem: tab,
                index: this.tabs.indexOf(tab),
                onTabSelected: this.funcOnTabSelected,
                isSidebar: $isSidebar,
                currentIndex: this.currentIndex,
              })
            }, (tab: TabItem): string => {
              return (tab.name.id).toString();
            })
          }
          .padding({ left: 16, top: SearchSwitchManager.getInstance().isSupportPhotoSearch() ? 0 : 72, right: 16 })
          .flexGrow(1)
          .backgroundColor($r('sys.color.comp_background_gray'))

          // Sidebar boundary line
          if (this.isShowSideBar) {
            Row() {
            }
            .width(0)
            .height(Constants.PERCENT_100)
            .border({ width: 0.5, color: $r('app.color.album_cover_gradient_start_color') })
            .opacity(this.sideBarBoundaryLineOpacity)
          }
        }
      } else {
        Flex({
          direction: FlexDirection.Column,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.Center,
        }) {
          Column() {
            ForEach(this.tabs, (tab: TabItem) => {
              Stack() {
                Tab({
                  tabItem: tab,
                  index: this.tabs.indexOf(tab),
                  onTabSelected: this.funcOnTabSelected,
                  isSidebar: $isSidebar,
                  currentIndex: this.currentIndex,
                })
              }
              .layoutWeight(1)
            }, (tab: TabItem): string => {
              return (tab.name.id).toString();
            })
          }
          .height($r('app.float.horizontal_width'))
        }
        .width($r('app.float.tab_bar_width'))
        .backgroundColor($r('sys.color.comp_background_gray'))
      }

    }
  }

  // tab切换的处理函数
  private onTabSelected(index: number): void {
    Log.debug(TAG, `TabBar this.currentIndex: ${this.currentIndex} index: ${index}`);
    this.currentIndex = index;
    this.controller?.changeIndex(this.currentIndex);
    this.tabs.forEach((tab: TabItem) => {
      tab.isSelected = this.tabs.indexOf(tab) == index;
    })
    Log.info(TAG, `select ${this.currentIndex}`);
  }
}

// single tab
@Component
struct Tab {
  @ObjectLink tabItem: TabItem;
  @Link isSidebar: boolean;
  public index: number = 0;
  public onTabSelected?: Function;
  @Prop currentIndex: number;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  build() {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Start,
      }) {
        Stack() {
          Image(this.tabItem.getIcon(this.tabItem.isSelected))
            .draggable(false)
            .height($r('app.float.icon_size'))
            .width($r('app.float.icon_size'))
            .objectFit(ImageFit.Fill)
            .edgeAntialiasing(DeviceInfo.isHym() ? 0.4 : 0)
        }
        .padding({
          left: $r('app.float.tab_bar_text_padding_left'),
        })

        Text(this.tabItem.name)
          .fontSize($r('sys.float.Subtitle_M'))
          .fontWeight(FontWeight.Medium)
          .fontColor(this.tabItem.getTextColor())
          .padding({
            left: $r('app.float.tab_bar_text_padding_left'),
            top: $r('app.float.tab_bar_text_padding_horizontal'),
            bottom: $r('app.float.tab_bar_text_padding_horizontal'),
          })
          .height($r('app.float.menu_height'))
          .focusable(true)
          .key('tabBarFocusKey')
      }
      .focusable(true)
      .focusOnTouch(true)
      .id(`TimelinePage_Tab${this.index}`)
      .backgroundColor(this.tabItem.isSelected ? '#DAE2F5' : $r('app.color.transparent'))
      .borderRadius($r('app.float.single_tab_margin'))
      .onClick((): void => {
        this.onTabSelected?.(this.index);
        this.tabItem.isSelected = true;
        /* instrument ignore next */
        if (DeviceInfo.isPc() && this.currentIndex === this.index) {
          // 暂时禁用快捷回顶部，暂时不要修改
          return;
          this.appBroadCast.emit(BroadCastConstants.RESET_ZERO, [this.index]);
        }
      })
    } else {
      Flex({
        direction: FlexDirection.Column,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center,
      }) {
        Stack() {
          Image(this.tabItem.getIcon(this.tabItem.isSelected))
            .draggable(false)
            .height($r('app.float.icon_size'))
            .width($r('app.float.icon_size'))
            .objectFit(ImageFit.Fill)
            .edgeAntialiasing(DeviceInfo.isHym() ? 0.4 : 0)
        }
        .padding({
          left: this.isSidebar ? 0 : $r('app.float.tab_bar_text_padding_left'),
        })

        Text(this.tabItem.name)
          .fontSize($r('sys.float.Caption_M'))
          .fontFamily($r('app.string.id_text_font_family_medium'))
          .fontColor(this.tabItem.getTextColor())
          .padding({
            left: $r('app.float.tab_bar_text_padding_horizontal'),
            top: $r('app.float.tab_bar_text_padding_top'),
            right: $r('app.float.tab_bar_text_padding_horizontal'),
          })
      }
      .onClick((): void => {
        this.onTabSelected?.(this.index);
        this.tabItem.isSelected = true;
      })
    }
  }
}


// For Album Set
@Component
export struct TabBarForAlbumSet {
  @Consume isTabBarShow: boolean;
  private currentIndex: number = 0;
  private tabs: TabItemWithText[] = [];
  private controller: TabsController | null = null;
  private funcOnTabSelected?: Function;

  aboutToAppear(): void {
    this.funcOnTabSelected = (index: number): void => this.onTabSelected(index);
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
        alignItems: ItemAlign.Start,
      }) {
        ForEach(this.tabs, (tab: TabItemWithText) => {
          TabWithText({ tabItemWithText: tab, index: this.tabs.indexOf(tab), onTabSelected: this.funcOnTabSelected })
        }, (tab: TabItemWithText): string => {
          return (tab.name.id).toString();
        })
      }
      .width('100%')
      .height($r('app.float.album_set_tab_bar_height'))
      .padding({ left: $r('app.float.max_padding_start'), right: $r('app.float.max_padding_end') })
      .backgroundColor($r('sys.color.comp_background_gray'))
    }
  }

  // tab切换回调处理函数
  private onTabSelected(index: number): void {
    Log.info(TAG, `TabBarForAlbumSet this.currentIndex: ${this.currentIndex} index: ${index}`);
    this.currentIndex = index;
    this.controller?.changeIndex(this.currentIndex);
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
  public index: number = 0;
  onTabSelected?: Function;

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
      alignItems: ItemAlign.Center,
    }) {
      Text(this.tabItemWithText.name)
        .fontSize(this.tabItemWithText.getTextSize())
        .fontWeight(this.tabItemWithText.getTextWeight())
        .fontColor(this.tabItemWithText.getTextColor())
        .maxLines(1)
        .margin({
          top: $r('app.float.tab_bar_line_margin_top'),
          left: $r('app.float.single_tab_margin'),
          right: $r('app.float.single_tab_margin'),
          bottom: $r('app.float.tab_bar_line_margin_top'),
        })
      Column()
        .width(this.TabWidth)
        .height($r('app.float.tab_bar_line_height'))
        .borderRadius($r('app.float.tab_bar_line_radius'))
        .backgroundColor(this.tabItemWithText.getTextColor())
        .visibility(this.tabItemWithText.isSelected ? Visibility.Visible : Visibility.Hidden)
    }
    .height('100%')
    .onClick((): void => {
      if (!this.isAlbumSetSelectedMode) {
        this.onTabSelected?.(this.index);
        this.tabItemWithText.isSelected = true;
      }
    })
  }
}