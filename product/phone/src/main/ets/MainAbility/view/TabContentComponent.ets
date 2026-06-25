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

import lazy { AlbumSetPage } from '@ohos/common/src/main/ets/default/view/album/AlbumSetPage';
import lazy { ActionBarController } from '@ohos/common/src/main/ets/default/view/ActionBarController';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  ScreenManager
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { TabContentComponentLoaderParams } from './TabContentComponentLoaderParams';
import lazy { PhotoGridViewController, PhotoGridViewConstants } from '@ohos/common/src/main/ets/default/view/grid/GridView';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { PhotoDataImplAsync } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImplAsync';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { AlbumPhotoGirdLoader } from './AlbumPhotoGridLoader'
import lazy { BindSheetController } from '@ohos/timeline/src/main/ets/albumgrid/view/AlbumPhotoGridView';
import { PhotosHmBrowserController } from '@ohos/browserlibrary';

/* instrument ignore file */
const TAG = 'TabContentComponent';

interface ParamAlbumInfo {
  item: string;
  isFromFACard: boolean;
}

@Builder
export function TabContentComponentLoader($$: TabContentComponentLoaderParams) {
  TabContentComponent({
    currentIndex: $$.currentIndex,
    isShowPhotoBrowser: $$.isShowPhotoBrowser,
    isShowSelectPhotoBrowser: $$.isShowSelectPhotoBrowser,
    pageStatus: $$.pageStatus,
    navigationPageInfos: $$.navigationPageInfos,
  })
}

@Component
export struct TabContentComponent {
  @Prop pageStatus: boolean = false;
  @LocalStorageLink(PhotoGridViewConstants.KEY_INDEX_GRID_VIEW_CONTROLLER) gridViewController: PhotoGridViewController =
    new PhotoGridViewController();
  @Prop currentIndex: number = 0;
  @StorageLink('currentBreakpoint') currentBreakpoint: string = Constants.BREAKPOINT_MD;
  @Consume @Watch('onShowStatusChanged') isShow: boolean;
  @Consume isShowTabBar: boolean;
  @Link @Watch('onPhotoBrowserStatusChanged') isShowPhotoBrowser: boolean;
  @Link @Watch('onSelectPhotoBrowserStatusChanged') isShowSelectPhotoBrowser: boolean;
  @Consume browserController: PhotosHmBrowserController;
  @StorageLink('isDoingGeometryTransitionAnimation') isDoingGeometryTransitionAnimation: boolean = false;
  @State actionBarController: ActionBarController = new ActionBarController();
  @Provide isSelectedMode: boolean = false;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @Provide selectHiddenAlbumUri: string = '';
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @Link private navigationPageInfos: NavPathStack;
  @State private bindSheetController: BindSheetController = new BindSheetController();
  private handleShowPhotoGridViewFunc: Function = (photoGridViewController?: PhotoGridViewController) =>
  this.showPhotoGridView(photoGridViewController);

  private showPhotoGridView(photoGridViewController?: PhotoGridViewController): void {
    Log.info(TAG, `showPhotoGrid isShowPhotoGridView: ${photoGridViewController?.isShow}`);
    if (!photoGridViewController) {
      return;
    }
    this.gridViewController = photoGridViewController;
  }

  private onBackPressEventFunc: Function = (): void => {
    if (this.isSelectedMode) {
      this.isSelectedMode = !this.isSelectedMode;
    } else {
      if (!this.isDoingGeometryTransitionAnimation) {
        this.appBroadCast.emit(BroadCastConstants.DO_ANIMATION, []);
      }
      if (this.currentIndex !== Constants.TIMELINE_PAGE_INDEX) {
        ScreenManager.getInstance().setDefaultStatusBarProperties(false);
        if (DeviceInfo.isGRLFoldScreen()) {
          AppStorage.setOrCreate<number>('albumActionBarOpacity', 1);
          AppStorage.setOrCreate<number>('albumOpacity', 1);
          AppStorage.setOrCreate<boolean>('isShowPhotoGridView', false);
          AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_OTHER_SCALE, 1);
          AppStorage.setOrCreate<string>(Constants.KEY_OF_SELECTED_ALBUM_URI, '');
        }
      }
    }
  }

  /* instrument ignore next */
  onShowStatusChanged(): void {
    this.pageStatus = this.isShow;
    Log.error(TAG, 'this.pageStatus = ' + this.pageStatus +
      ', this.isShow = ' + this.isShow + ', this.isInCurrentTab = ' + this.isInCurrentTab()
    );
  }

  onPhotoBrowserStatusChanged(): void {
    if (this.isInCurrentTab()) {
      this.isShowTabBar =
        !this.gridViewController.isShow && !this.isShowPhotoBrowser;
    }
  }

  onSelectPhotoBrowserStatusChanged(): void {
    if (this.isInCurrentTab()) {
      this.isShowTabBar =
        !this.gridViewController.isShow && !this.isShowSelectPhotoBrowser;
    }
  }

  aboutToAppear() {
    getContext()?.eventHub.on(PhotoGridViewConstants.EVENT_KEY_SHOW_GRID_VIEW, this.handleShowPhotoGridViewFunc);
    this.appBroadCast.on(BroadCastConstants.BACK_PRESS_EVENT, this.onBackPressEventFunc);
    this.gridViewController.setIsShow(TAG, 'aboutToAppear', this.gridViewController.isShow, false); // 加载相册页，宫格显示flag置为false
    let isGRLFoldScreen: boolean = DeviceInfo.isGRLFoldScreen();
    if (isGRLFoldScreen && AppStorage.get<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW) &&
      AppStorage.get<ParamAlbumInfo>(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM) !== undefined) {
      this.gridViewController.setIsShow(TAG, 'aboutToAppear album item is thirdFold and albumInfo is not undefined', this.gridViewController.isShow, true);
    }
    Log.info(TAG, `isGRL = ${isGRLFoldScreen}, isShow = ${this.gridViewController.isShow}`);
    if (isGRLFoldScreen && this.gridViewController.isShow) {
      let param = AppStorage.get<ParamAlbumInfo>(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM);
      if (!param) {
        return;
      }
      let targetAlbumInfo: AlbumInfo = JSON.parse(param.item) as AlbumInfo;
      let targetDataSource: MediaDataSource =
        new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE, new PhotoDataImplAsync(TAG));
      targetDataSource = new AlbumDataSource({ context: getContext(), albumInfo: targetAlbumInfo });
      this.gridViewController.dataSource = targetDataSource;
    }
  }

  /* instrument ignore next */
  aboutToDisappear() {
    getContext()?.eventHub.off(PhotoGridViewConstants.EVENT_KEY_SHOW_GRID_VIEW, this.handleShowPhotoGridViewFunc);
    this.appBroadCast.off(BroadCastConstants.BACK_PRESS_EVENT, this.onBackPressEventFunc);
  }

  @Builder
  buildAlbumSetPage() {
    AlbumSetPage({
      isInCurrentTab: this.currentIndex === Constants.ALBUM_PAGE_INDEX,
      currentIndex : this.currentIndex
    })
  }

  /* instrument ignore next */
  build() {
    Stack() {
      if (!DeviceInfo.isGRLFoldScreen() || !this.gridViewController.isShow) {
        this.buildAlbumSetPage();
      }

      if (this.gridViewController.isShow) {
        AlbumPhotoGirdLoader({
          pageStatus: this.pageStatus,
          actionBarController: this.actionBarController,
          isSelectedMode: this.isSelectedMode,
          importDataSource: this.gridViewController.dataSource,
          isShowPhotoBrowser: false,
          currentTabBarHeight: 0,
          isSelectedModeIndex: false,
          tabsPaddingBottom: 0,
          initTabsPaddingBottom: 0,
          isShowHiddenGridView: false,
          isShowSearchPage: false,
          isShowTabAndSegmentButton: false,
          navigationPageInfos: this.navigationPageInfos,
          sideBarWidth: 0,
          isShowSdCardTip: false,
          cardNameUris: [],
          navPathStack: this.navigationPageInfos,
          bindSheetController: this.bindSheetController,
          browserController: this.browserController,
        })
      }
    }
    .height('100%')
  }

  private isInCurrentTab(): boolean {
    return this.currentIndex === Constants.ALBUM_PAGE_INDEX;
  }
}