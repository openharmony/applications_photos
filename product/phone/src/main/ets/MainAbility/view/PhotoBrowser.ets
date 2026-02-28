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

import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaOperationBasePage } from '@ohos/common/src/main/ets/default/view/browserOperation/MediaOperationBasePage';
import lazy { NavigationBroadCastManager } from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { Router } from '@ohos.arkui.UIContext';
import lazy { PageStatus } from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { WallpaperEditorLoaderParams } from '@ohos/common/src/main/ets/default/view/WallpaperEditorComponent';
import lazy { SlideShowLoaderParams } from '@ohos/common/src/main/ets/default/view/SlideShowPage';
import lazy { common } from '@kit.AbilityKit';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { BreakpointSystem } from '@ohos/common/src/main/ets/default/utils/BreakPointSystem';
import lazy { initPhotoBrowserController, unInitPhotoBrowserController,
  PhotosHmBrowserController,
  PhotoBrowserView,
  LibraryConstants
} from '@ohos/browserlibrary';
import lazy window from '@ohos.window';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { ParamBrowser, PhotoBrowserUtils } from '@ohos/common/src/main/ets/default/utils/PhotoBrowserUtils';
import lazy { PhotoGridBasePage } from './PhotoGridBasePage';
import lazy { ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { DataSourceCommonUtil } from '@ohos/common/src/main/ets/default/utils/DataSourceCommonUtil';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { ParamAlbumInfo } from '@ohos/common/src/main/ets/default/interface/Album';

/* instrument ignore file */
const TAG: string = 'PhotoBrowser';

interface BrowserParam {
  pageFrom: number;
}

interface FaBrowserParam {
  isFromFaCard: boolean;
}

// page of large photo
@Entry(LocalStorage.getShared())
@Component
export struct PhotoBrowser {
  @State pageStatus: boolean = false;
  @State isRunningAnimation: boolean = false;
  @State animationFlag: boolean = true;
  @Provide browserController: PhotosHmBrowserController = new PhotosHmBrowserController(
    global.uiAbilityContext(), global.windowStage(), getContext()
  )
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @StorageLink('isShowFinishToast') isShowFinishToast: boolean = false;
  @Provide('navigationPageInfos') navigationPageInfos: NavPathStack = new NavPathStack();
  @Provide isShow: boolean = false;
  @Provide isShowTabBar: boolean = false;
  @Provide isAlbumSetSelectedMode: boolean = false;
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  isFromFaCard: boolean = false;
  private hideBrowserBarsFunc: Function = (): void => {
    this.browserController.emitCallback(LibraryConstants.HIDE_BARS_CALLBACK, []);
  }

  aboutToAppear() {
    try {
      WindowUtil.prepareWinRouter();
      this.browserController.browserParam = AppStorage.get<Router>('router')?.getParams();
      let param: ParamBrowser = this.browserController.browserParam as ParamBrowser;
      if (param?.pageFrom) {
        this.animationFlag = param.pageFrom !== Constants.ENTRY_FROM.PUZZLE;
      }
      Log.info(TAG, `photobrowser params ${JSON.stringify(AppStorage.get<Router>('router')?.getParams())}`);
      const isFromCard: boolean = ((AppStorage.get<Router>('router')?.getParams() as FaBrowserParam)?.isFromFaCard ||
        LocalStorage.getShared().get('isFromFa')) ? true : false;
      // 卡片入口：在 controller.init 阶段传入 mediaUri，让 dataSource 初始化完成后定位到正确索引
      const cardUri: string = isFromCard ? (AppStorage.get<string>('form_currentUri') ?? '') : '';
      initPhotoBrowserController(this.browserController, 'ViewData', false, cardUri);

      if (isFromCard) {
        this.isFromFaCard = true;
        LocalStorage.getShared().delete('isFromFa')
        ReportToBigDataUtil.report(BigDataConstants.CARD_CLICK_NORMAL_CARD);
      }
      this.breakpointSystem.registerOrientationChange();
      Log.debug(TAG, `[aboutToAppear] param: ${JSON.stringify(this.browserController.browserParam)}`);
      this.browserController.onViewShow(param);
    } catch (e) {
      Log.error(TAG, `Router getParams error ${e}`);
    }
    this.setWallpaperEditorLoader();
    this.setSlideShowPageLoader();
    LocalStorage.getShared()?.setOrCreate<boolean>('isBrowserShow', true);
    this.appBroadCast.on(BroadCastConstants.HIDE_BROWSER_BARS, this.hideBrowserBarsFunc)
  }

  aboutToDisappear() {
    Log.debug(TAG, '[aboutToDisappear]');
    unInitPhotoBrowserController(this.browserController);
    this.appBroadCast.off(BroadCastConstants.HIDE_BROWSER_BARS, this.hideBrowserBarsFunc)
    this.animationFlag = true;
  }

  onPageShow() {
    Log.debug(TAG, '[onPageShow]');
    LocalStorage.getShared()?.setOrCreate<PageStatus>(Constants.VIDEO_PAGE_STATUS, PageStatus.SHOW);
    this.pageStatus = true;
    if (this.isShowFinishToast) {
      UiUtil.showToast($r('app.string.Saved_to_Puzzle_Album'),
        undefined, Constants.SAVED_TO_PUZZLE_ALBUM_TOAST_TIME);
      this.isShowFinishToast = false;
    }
    this.getUIContext().getHostContext()?.eventHub.emit(BroadCastConstants.PHOTO_BROWSER_ON_PAGE_SHOW, []);
  }

  onPageHide() {
    Log.debug(TAG, '[onPageHide]');
    if (this.isFromFaCard) {
      this.getUIContext().getHostContext()?.eventHub.emit(BroadCastConstants.ON_PAGE_HIDE, `${TAG} onPageHide()`);
    }
    LocalStorage.getShared()?.setOrCreate<PageStatus>(Constants.VIDEO_PAGE_STATUS, PageStatus.HIDE);
    this.getUIContext().getHostContext()?.eventHub.emit(BroadCastConstants.PHOTO_BROWSER_ON_PAGE_HIDE, []);
    this.pageStatus = false;
  }

  onBackPress(): boolean {
    Log.debug(TAG, '[onBackPress]');
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT, []);
    return true;
  }

  @BuilderParam wallpaperEditorLoader: ($$: WallpaperEditorLoaderParams) => void;
  @BuilderParam slideShowPageLoader: ($$: SlideShowLoaderParams) => void;

  @Builder
  PageMap(name: string, param: Object) {
    if (name === NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION) {
      MediaOperationBasePage()
    } else if (name === NavigationConstants.NAVIGATION_WALLPAPER_EDITOR) {
      this.wallpaperEditorLoader({
        navPageInfos: this.navigationPageInfos,
      })
    } else if (name === NavigationConstants.NAVIGATION_SLIDE_SHOW_PAGE) {
      this.slideShowPageLoader({
        navigationPageInfos: this.navigationPageInfos,
      })
    }
  }

  build() {
    Navigation(this.navigationPageInfos) {
      Column() {
        PhotoBrowserView({
          isShowBar: true,
          pageStatus: false,
          hidePhotoBrowser: (isPlayAni: boolean, index: number): void => {
            let param: ParamBrowser = this.browserController.browserParam as ParamBrowser;
            if (param && param.pageFrom === Constants.ENTRY_FROM.VIEW_DATA) {
              PhotoBrowserUtils.setViewDataResult(true, true, true);
            } else {
              this.browserController.hideBrowser(index)
            }
          },
          isRunningAnimation: this.isRunningAnimation,
          isShowMenu: true,
          canPullingUp: true,
          isShowThumbSource: true,
          isShowImageAnalyzer: true,
          reportStartTime: 0,
          onDeleteAllPhoto: (): void => {
          }
        })
      }
    }
    .navDestination(this.PageMap)
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .onNavBarStateChange((isVisible: boolean) => {
      Log.info(TAG, `onNavBarStateChange = ${isVisible}`);
      if (isVisible) {
        NavigationBroadCastManager.getInstance().targetName = '';
      }
    })
  }

  pageTransition() {
    PageTransitionEnter({
      type: this.animationFlag ? RouteType.Pop : RouteType.None,
      duration: BrowserConstants.PHOTO_GRID_ANIMATION_DURATION,
    })
      .opacity(1)
    PageTransitionExit({
      type: RouteType.Push,
      duration: BrowserConstants.PHOTO_GRID_ANIMATION_DURATION,
    })
      .opacity(1)
  }

  private async setWallpaperEditorLoader(): Promise<void> {
    try {
      let pageObj = await import('@ohos/common/src/main/ets/default/view/WallpaperEditorComponent');
      this.wallpaperEditorLoader = pageObj.WallpaperEditorLoader;
      Log.info(TAG, 'setWallpaperEditorLoader success');
    } catch (error) {
      Log.error(TAG, `setWallpaperEditorLoader error: ${error}`);
    }
  }

  private async setSlideShowPageLoader(): Promise<void> {
    try {
      let pageObj = await import('@ohos/common/src/main/ets/default/view/SlideShowPage');
      this.slideShowPageLoader = pageObj.SlideShowPageLoader;
      Log.info(TAG, 'setSlideShowPageLoader success');
    } catch (error) {
      Log.error(TAG, `setSlideShowPageLoader error: ${error}`);
    }
  }

   private getCurrentNavigationPathName(): string {
    let currentNavigationPathName = this.navigationPageInfos.size() === 0 ? '' :
    this.navigationPageInfos.getAllPathName()[this.navigationPageInfos.size() - 1];
    return currentNavigationPathName;
  }
}