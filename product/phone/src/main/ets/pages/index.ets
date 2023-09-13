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

import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import app from '@system.app';
import {
  BigDataConstants,
  BreakpointSystem,
  BreakPointType,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  BrowserConstants,
  Constants,
  JumpSourceToMain,
  Log,
  ReportToBigDataUtil,
  ScreenManager,
  TraceControllerUtils
} from '@ohos/common';
import {
  BrowserController,
  DEVICE_TYPE,
  TabBar,
  TabItem
} from '@ohos/common/CommonComponents';
import router from '@ohos.router';
import { PhotoGridView } from '../view/PhotoGridView';
import { TabContentComponent } from '../view/TabContentComponent';
import { TimelineTabContentComponent } from '../view/TimelineContentComponent';

import data_preferences from '@ohos.data.preferences';

export type Preferences = data_preferences.Preferences;

const TAG: string = 'index';
const COMPONENT_KEY_PHOTOS: string = 'Photos';
const COMPONENT_KEY_ALBUMS: string = 'Albums';
const IMAGE_CACHE_COUNT: number = 100;
const IMAGE_CACHE_SIZE: number = 1024 * 1024 * IMAGE_CACHE_COUNT;

// Application entry
@Entry
@Component
struct IndexPage {
  @StorageLink('app_key_tabs_index') preIndex: number = Constants.TIMELINE_PAGE_INDEX;
  @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
  @StorageLink('leftBlank') leftBlank: number[]
    = [
  Constants.NUMBER_0,
  ScreenManager.getInstance().getStatusBarHeight(),
  Constants.NUMBER_0,
  ScreenManager.getInstance().getNaviBarHeight()
  ];
  @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  @Provide isShow: boolean = true;
  @Provide screenHeight: number = 0.0;
  @Provide screenWidth: number = 0.0;
  @Provide isSelectedMode: boolean = false;
  @Provide isAlbumSetSelectedMode: boolean = false;
  @Provide isShowSideBar: boolean = false;
  @State currentIndex: number = this.preIndex;
  @StorageLink('entryFromHap') entryFromHap: number = Constants.ENTRY_FROM_NONE;
  @State controlButtonMarginLeft: number = 16;
  @StorageLink('deviceType') deviceType: string = AppStorage.Get('deviceType');
  @StorageLink('currentBreakpoint') @Watch('updateParameters') currentBreakpoint: string = Constants.BREAKPOINT_MD;
  @StorageLink('isShowPhotoGridView') @Watch('doAnimation') isShowPhotoGridView: boolean = false;
  @State isShowTabBar: boolean = true;
  @State pageStatus: boolean = false;
  @State isShowPhotoBrowser: boolean = false;
  @State isShowSelectPhotoBrowser: boolean = false;
  @State browserController: BrowserController = new BrowserController(true);
  private tabs: TabItem[] = [
    new TabItem($r('app.string.tab_timeline'), $r('app.media.ic_photos'), $r('app.media.ic_photos_actived'), false, $r('sys.color.ohos_id_color_bottom_tab_text_off'), COMPONENT_KEY_PHOTOS),
    new TabItem($r('app.string.tab_albums'), $r('app.media.ic_albums'), $r('app.media.ic_albums_actived'), false, $r('sys.color.ohos_id_color_bottom_tab_text_off'), COMPONENT_KEY_ALBUMS)
  ];
  private tabsController: TabsController = new TabsController();
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private jumpSource: number;
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  private photosPreferences: Preferences;

  doAnimation(): void {
    if (this.isSidebar && this.currentBreakpoint !== Constants.BREAKPOINT_LG) {
      this.isSidebar = this.isShowPhotoGridView ? false : true;
    }
    animateTo({
      duration: this.isShowPhotoGridView ?
      BrowserConstants.PHONE_LINK_IN_TAB_BAR_DURATION : BrowserConstants.PHONE_LINK_OUT_TAB_BAR_DURATION,
      curve: Curve.Sharp
    }, () => {
      this.isShowTabBar = !this.isShowTabBar;
    })
  }

  aboutToDisappear(): void {
    Log.info(TAG, '[aboutToDisappear]');
    this.breakpointSystem.unregister();
  }

  updateParameters(): void {
    this.isSidebar = new BreakPointType({
      sm: false,
      md: false,
      lg: true
    }).getValue(this.currentBreakpoint);
  }

  initPhotosStore() {
    this.photosPreferences = AppStorage.Get(Constants.PHOTOS_STORE_KEY);
    if (this.photosPreferences) {
      this.photosPreferences.get('lastPage', 0).then((data: number) => {
        this.preIndex = data;
        this.currentIndex = this.preIndex;
      }).catch((err) => {
        this.updatePhotosStore('lastPage', 0);
      });
    } else {
      Log.info(TAG, 'photosPreferences is undefined');
    }
  }

  updatePhotosStore(key, value) {
    if (this.photosPreferences) {
      this.photosPreferences.put(key, value).then(() => {
        Log.debug(TAG, `Succeeded in putting the value of '${key}'.`);
        this.photosPreferences.flush();
      }).catch((err) => {
        Log.error(TAG, `Failed to put the value of '${key}'. Cause: ${err}`);
      });
    }
  }

  aboutToAppear(): void {
    TraceControllerUtils.startTrace('indexPageAppearToShow');
    ScreenManager.getInstance().setSystemUi(true);
    this.breakpointSystem.register();
    this.updateParameters();
    let param: any = router.getParams();
    Log.info(TAG, `[aboutToAppear] param: ${JSON.stringify(param)}`);
    this.requestPermissions();
    if (param != null) {
      this.jumpSource = param.jumpSource;
      if (this.jumpSource == JumpSourceToMain.CAMERA) {
        this.entryFromHap = Constants.ENTRY_FROM_NONE;
        this.currentIndex = Constants.TIMELINE_PAGE_INDEX;
        Log.info(TAG, `Camera in, switch to Tab ${this.currentIndex}.`);
        let msg = {
          'Type': BigDataConstants.ENTER_BY_CAMERA
        };
        ReportToBigDataUtil.report(BigDataConstants.ENTER_PHOTOS_ID, msg);
      }
    } else {
      this.initPhotosStore();
    }
  }

  onPageShow(): void {
    Log.info(TAG, `[onPageShow] entryFromHap: ${this.entryFromHap}`);
    if (typeof globalThis.IsSetImageRawDataCacheSize === 'undefined') {
      Log.info(TAG, '[onPageShow] setImageRawDataCacheSize');

      // ImageCacheCount：缓存解码后的图片，默认为0
      app.setImageCacheCount(IMAGE_CACHE_COUNT);
      // ImageRawDataCache：缓存解码前的图片数据和缩略图的数据(datashare thumbnail格式）
      app.setImageRawDataCacheSize(IMAGE_CACHE_SIZE);
      globalThis.IsSetImageRawDataCacheSize = true;
    }
    this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    setTimeout(() => {
      this.isShow = true
    }, 50);
    let param: any = router.getParams();
    if (param != null) {
      this.jumpSource = param.jumpSource;
    }
    Log.info(TAG, `router clear ${this.jumpSource}, routerLength=${router.getLength}`);
    if (this.jumpSource == JumpSourceToMain.CAMERA) {
      router.clear();
    } else if (this.jumpSource == JumpSourceToMain.ALBUM) {
      router.clear();

      // To help AlbumSetPage show copy or move dialog
      if (AppStorage.Get(Constants.IS_SHOW_MOVE_COPY_DIALOG)) {
        this.appBroadCast.emit(BroadCastConstants.SEND_COPY_OR_MOVE_BROADCAST, [this.currentIndex]);
        AppStorage.SetOrCreate(Constants.IS_SHOW_MOVE_COPY_DIALOG, false);
      }
    }
    this.pageStatus = true;
    TraceControllerUtils.finishTrace('indexPageAppearToShow');
  }

  onPageHide(): void {
    Log.info(TAG, '[onPageHide]');
    this.pageStatus = false;
    setTimeout(() => {
      this.isShow = false
    }, 50);
  }

  onBackPress(): boolean {
    if (this.isShowPhotoBrowser) {
      this.doPhotoBrowserViewBack();
      return true;
    }
    if (this.isShowSelectPhotoBrowser) {
      this.doSelectPhotoBrowserViewBack();
      return true;
    }
    if (this.currentIndex === Constants.ALBUM_PAGE_INDEX) {
      if (this.isShowPhotoGridView) {
        if (this.isSelectedMode) {
          this.isSelectedMode = !this.isSelectedMode;
        } else {
          this.appBroadCast.emit(BroadCastConstants.DO_ANIMATION, []);
        }
        return true;
      } else {
        if (this.isAlbumSetSelectedMode) {
          this.isAlbumSetSelectedMode = !this.isAlbumSetSelectedMode;
          return true;
        } else {
          return false;
        }
      }
    }
    let isProcessed = false;
    this.appBroadCast.emit(BroadCastConstants.BACK_PRESS_EVENT, [function(isModeChanged: boolean){
      isProcessed = isModeChanged;
    }.bind(this)]);
    return isProcessed;
  }

  doSelectPhotoBrowserViewBack() {
    this.appBroadCast.emit(BroadCastConstants.SELECT_PHOTO_BROWSER_BACK_PRESS_EVENT, []);
  }

  doPhotoBrowserViewBack() {
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT, []);
  }

  build() {
    Row() {
      if (this.entryFromHap == Constants.ENTRY_FROM_NONE) {
        Stack() {
          Tabs({
            barPosition: BarPosition.Start,
            index: this.currentIndex,
            controller: this.tabsController
          }) {
            TabContent() {
              Column() {
                TimelineTabContentComponent({
                  currentIndex: this.currentIndex,
                  isShowTabBar: $isShowTabBar,
                  isShowPhotoBrowser: $isShowPhotoBrowser,
                  isShowSelectPhotoBrowser: $isShowSelectPhotoBrowser,
                  pageStatus: this.pageStatus
                })
              }
              .width('100%')
              .height('100%')
              .visibility(this.currentIndex === Constants.TIMELINE_PAGE_INDEX ? Visibility.Visible : Visibility.Hidden)
            }

            TabContent() {
              TabContentComponent({
                currentIndex: this.currentIndex,
                isShowTabBar: $isShowTabBar,
                isShowPhotoBrowser: $isShowPhotoBrowser,
                isShowSelectPhotoBrowser: $isShowSelectPhotoBrowser,
                pageStatus: this.pageStatus
              })
                .visibility(this.currentIndex === Constants.ALBUM_PAGE_INDEX ? Visibility.Visible : Visibility.Hidden)
            }
          }
          .animationDuration(Constants.NUMBER_0)
          .vertical(true)
          .scrollable(false)
          .barMode(BarMode.Fixed)
          .barWidth(Constants.NUMBER_0)
          .barHeight(Constants.NUMBER_0)
          .flexGrow(Constants.NUMBER_1)
          .onChange((index: number) => {
            AppStorage.SetOrCreate<string>(Constants.KEY_OF_ALBUM_ID, '');
            AppStorage.SetOrCreate<string>(Constants.KEY_OF_ALBUM_URI, '');
            this.resetTabState(this.currentIndex)
            this.onTabChanged(index);
            Log.info(TAG, `Switch to Tab ${this.currentIndex}.`)
          })
          .padding({ left: this.isSidebar ? $r('app.float.tab_bar_width') : Constants.NUMBER_0 })

          TabBar({
            currentIndex: $currentIndex,
            tabs: this.tabs,
            controller: this.tabsController,
            isSidebar: $isSidebar,
            deviceType: DEVICE_TYPE.PHONE_LIKE
          })
            .visibility(this.isShowTabBar ? Visibility.Visible : Visibility.Hidden)
          if (this.isShowPhotoGridView && this.currentBreakpoint == Constants.BREAKPOINT_LG) {
            PhotoGridView({
              pageStatus: this.pageStatus,
              browserController: this.browserController
            })
              .transition(TransitionEffect.opacity(0.99))
          }
        }
        .alignContent(Alignment.BottomStart)
        .flexGrow(Constants.NUMBER_1)
      }
    }
    .backgroundColor($r('app.color.default_background_color'))
    .padding({
      top: this.leftBlank[1],
      bottom: this.leftBlank[3]
    })

  }

  pageTransition() {
    PageTransitionEnter({ duration: 300 })
      .opacity(1)
    PageTransitionExit({ duration: 300 })
      .opacity(1)
  }

  // Reset the status of the removed tab. It is currently in the selection mode status (index is before switching)
  private resetTabState(index: number): void {
    this.appBroadCast.emit(BroadCastConstants.RESET_STATE_EVENT, [index]);
  }

  // Tab page switching callback (index after switching)
  private onTabChanged(index: number): void {
    this.updatePhotosStore('lastPage', index);
    this.currentIndex = index;
    this.preIndex = this.currentIndex;
    this.appBroadCast.emit(BroadCastConstants.ON_TAB_CHANGED, [index]);
  }

  private async requestPermissions(): Promise<void> {
    this.photosPreferences = AppStorage.Get<Preferences>(Constants.PHOTOS_STORE_KEY);
    let isRequested: boolean = false;
    if (this.photosPreferences) {
      isRequested = await this.photosPreferences.get(Constants.PHOTOS_PERMISSION_FLAG, false) as boolean;
    } else {
      Log.warn(TAG, 'photos preferences is undefined.');
    }
    Log.info(TAG, `Has permission been requested? ${isRequested}`);
    if (!isRequested) {
      let permissionList: Array<string> = [
        "ohos.permission.READ_IMAGEVIDEO",
        "ohos.permission.WRITE_IMAGEVIDEO",
        "ohos.permission.MEDIA_LOCATION"
      ];
      let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      try {
        // @ts-ignore
        atManager.requestPermissionsFromUser(globalThis.photosAbilityContext, permissionList).then((data) => {
          Log.debug(TAG, `permissions: ${JSON.stringify(data.permissions)}`
          + `, authResult: ${JSON.stringify(data.authResults)}`);
          let sum: number = 0;
          for (let i = 0; i < data.authResults.length; i++) {
            sum += data.authResults[i];
          }
          Log.info(TAG, `permissions sum: ${sum}`);
          if (this.photosPreferences) {
            this.photosPreferences.put(Constants.PHOTOS_PERMISSION_FLAG, true).then(() => {
              Log.debug(TAG, `Succeeded in putting the value of '${Constants.PHOTOS_PERMISSION_FLAG}'.`);
              this.photosPreferences.flush();
            }).catch((err) => {
              Log.error(TAG, `Failed to put the value of '${Constants.PHOTOS_PERMISSION_FLAG}'. Cause: ${err}`);
            });
          }
        }, (err) => {
          Log.error(TAG, `Failed to start ability err code: ${err.code}`);
        });
      } catch (error) {
        Log.error(TAG, `catch error: ${JSON.stringify(error)}`);
      }
    }
  }
}