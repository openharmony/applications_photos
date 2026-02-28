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
import lazy { ActionBarController } from '@ohos/common/src/main/ets/default/view/ActionBarController';
import lazy { AlbumPhotoViewSub } from './AlbumPhotoViewSub';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { ParamAlbumInfo } from '@ohos/common/src/main/ets/default/interface/Album';
import lazy { SearchSwitchManager } from '@ohos/common/src/main/ets/default/model/SearchSwitchManager';
import lazy { AlbumPhotoViewLoaderParams } from './AlbumPhotoViewLoaderParams';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { BindSheetController } from '@ohos/timeline/src/main/ets/albumgrid/view/AlbumPhotoGridView';
import lazy { TimelineTabletPageLoader } from './TimelineTabletPageLoader';
import lazy { GridInitConfigSyncer } from '@ohos/timeline/src/main/ets/view/adapter/GridInitConfigSyncer';
import { PhotosHmBrowserController } from '@ohos/browserlibrary';

/* instrument ignore file */
const TAG = 'AlbumPhotoView';

@Builder
export function AlbumPhotoViewLoader($$: AlbumPhotoViewLoaderParams) {
  AlbumPhotoView({
    pageStatus: $$.pageStatus,
    isShowPhotoBrowser: $$.isShowPhotoBrowser,
    currentTabBarHeight: $$.currentTabBarHeight,
    isSelectedModeIndex: $$.isSelectedModeIndex,
    tabsPaddingBottom: $$.tabsPaddingBottom,
    initTabsPaddingBottom: $$.initTabsPaddingBottom,
    isShowHiddenGridView: $$.isShowHiddenGridView,
    isShowSearchPage: $$.isShowSearchPage,
    isSelectedMode: $$.isSelectedMode,
    navigationPageInfos: $$.navigationPageInfos,
    sideBarWidth: $$.sideBarWidth,
    isShowTabAndSegmentButton: $$.isShowTabAndSegmentButton,
    isShowSdCardTip: $$.isShowSdCardTip,
    cardNameUris: $$.cardNameUris,
    gridInitConfigSyncer: $$.gridInitConfigSyncer,
    isConfigReady: $$.isConfigReady,
  })
}

@Component
export struct AlbumPhotoView {
  @StorageLink('isShowPhotoGridView') isShowPhotoGridView: boolean = false;
  @Consume private isShowPhotoHiddenView: boolean;
  @Link private isShowHiddenGridView: boolean;
  @Link private isShowSearchPage: boolean;
  @Consume private isShowTimelinePage: boolean;
  @Link private pageStatus: boolean;
  @Consume private browserController: PhotosHmBrowserController;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @Link private isShowPhotoBrowser: boolean;
  @Link private currentTabBarHeight: number;
  @Link private isSelectedModeIndex: boolean;
  @Link private isSelectedMode: boolean;
  @Link private tabsPaddingBottom: number;
  @Link private initTabsPaddingBottom: number;
  @Link private isShowSdCardTip: boolean;
  @Link private cardNameUris: string[];
  @State private isRefreshPhotoGridView: boolean = false;
  private refreshFunc: Function = (): void => this.refreshPhotoGridView();
  @Provide private photoHiddenAlbumItem: ParamAlbumInfo | undefined = undefined;
  @Provide private selectHiddenAlbumUri: string = '';
  @Provide private hiddenGridViewOpacity: number = 0;
  @Provide private hiddenGridActionBarOpacity: number = 0;
  @Provide private hiddenAlbumOtherScale: number = 1;
  @Link private navigationPageInfos: NavPathStack;
  @Link private isShowTabAndSegmentButton: boolean;
  @Prop private isChangeByClickTab: boolean;
  @Prop sideBarWidth: number = Constants.TAB_BAR_WIDTH;
  @Consume private isShowTabBar: boolean;
  @Link private isConfigReady: boolean;
  // 宫格初始配置同步器
  private gridInitConfigSyncer?: GridInitConfigSyncer;

  aboutToAppear(): void {
    this.appBroadCast.on(BroadCastConstants.PHOTO_GRID_REFRESH, this.refreshFunc);
  }

  aboutToDisappear(): void {
    this.appBroadCast.off(BroadCastConstants.PHOTO_GRID_REFRESH, this.refreshFunc);
  }

  build() {
    Stack() {
      if (this.isShowTimelinePage) {
        Column() {
          TimelineTabletPageLoader({
            isShowPhotoBrowser: this.isShowPhotoBrowser,
            isInCurrentTab: this.isShowTimelinePage,
            currentTabBarHeight: this.currentTabBarHeight,
            isSelectedModeIndex: this.isSelectedModeIndex,
            tabsPaddingBottom: this.tabsPaddingBottom,
            initTabsPaddingBottom: this.initTabsPaddingBottom,
            isShowSearchPage: this.isShowSearchPage,
            isShowTabAndSegmentButton: this.isShowTabAndSegmentButton,
            sideBarWidth: this.sideBarWidth,
            isShowSdCardTip: this.isShowSdCardTip,
            cardNameUris: this.cardNameUris,
            pageStatus: this.pageStatus,
            isShowGallerySettingBasePage: false,
            isShowAboutGalleryPage: false,
            navPathStack: this.navigationPageInfos,
            isShowTabBar: this.isShowTabBar,
            gridInitConfigSyncer: this.gridInitConfigSyncer,
            isConfigReady: this.isConfigReady,
          })
        }
        .width('100%')
        .height('100%')
        .transition(TransitionEffect.opacity(0.99))
      }

      if (this.isShowPhotoGridView || this.isShowPhotoHiddenView || this.isShowHiddenGridView) {
        AlbumPhotoViewSub({
          // to align state variable @Provide isSelectedMode
          isShowPhotoGridView: this.isShowPhotoGridView,
          isRefreshPhotoGridView: this.isRefreshPhotoGridView,
          pageStatus: this.pageStatus,
          isSelectedMode: this.isSelectedMode,
          navigationPageInfos: this.navigationPageInfos,
        })
          .transition(TransitionEffect.opacity(0.99))
      }
    }
    .backgroundColor($r('sys.color.background_secondary'))
  }

  private refreshPhotoGridView(): void {
    this.isRefreshPhotoGridView = !this.isRefreshPhotoGridView;
  }
}