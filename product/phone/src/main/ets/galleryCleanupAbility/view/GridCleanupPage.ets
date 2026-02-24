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
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { ActionBarController } from '@ohos/common/src/main/ets/default/view/ActionBarController';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { PhotoBrowserLoaderParams } from '@ohos/common/src/main/ets/default/interface/PhotoBrowserLoaderParams';
import lazy { ScreenManager } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { SelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { AlbumGrid } from '@ohos/common/src/main/ets/default/model/AlbumGrid';
import lazy { PhotoDataImpl } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImpl';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { CleanupDataImplAsync } from '@ohos/common/src/main/ets/default/model/browser/photo/CleanupDataImplAsync';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { common } from '@kit.AbilityKit';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { PhotoBrowserViewLoaderParams } from '@ohos/common/src/main/ets/default/interface/PhotoBrowserViewLoaderParams';
import { PhotosHmBrowserController, initPhotoBrowserController } from '@ohos/browserlibrary';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { BindSheetController } from '@ohos/timeline/src/main/ets/albumgrid/view/AlbumPhotoGridView';


/* instrument ignore file */
const TAG = 'GridCleanupPage';

// 图库清理宫格页
@Component
export struct GridCleanupPage {
  @State pageStatus: boolean = false;
  @State isRunningAnimation: boolean = false;
  @Provide isSelectedMode: boolean = false;
  @State actionBarController: ActionBarController = new ActionBarController();
  private dataSource: MediaDataSource | undefined = undefined;
  // 广播
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @Provide broadCast: BroadCast = new BroadCast();
  private mSelectManager: SelectManager = new SelectManager();
  private onHandBackFunc: Function = (): void => this.onHandBack();
  private onJumpThirdPhotoBrowserFunc: Function =
    (name: string, item: MediaItem, geometryTapIndex: number, geometryTransitionString: string): void => {
      this.onJumpThirdPhotoBrowser(name, item, geometryTapIndex, geometryTransitionString);
    };
  @Provide isShow: boolean = true;
  @Provide isShowTabBar: boolean = false;
  private albumInfo: AlbumInfo | undefined = undefined;
  @Consume pageInfo: NavPathStack;
  private storage: LocalStorage | undefined;
  @Provide('navigationPageInfos') private navigationPageInfos: NavPathStack = new NavPathStack();
  @Provide @Watch('updateBrowserStatus') browserController: PhotosHmBrowserController = new PhotosHmBrowserController(
    LocalStorage.getShared().get<common.UIAbilityContext>('photosAbilityContext') ??
    global.uiAbilityContext(), global.windowStage(), getContext()
  );
  private isPullingUp: boolean = false;
  private setIsPullingUpFunc: Function = (isPullingUp: boolean): void => this.setIsPullingUp(isPullingUp);

  aboutToAppear() {
    Log.info(TAG, 'aboutToAppear: go to GridCleanupPage.');
    initPhotoBrowserController(this.browserController, this.albumInfo?.isTrashAlbum ? 'RecentlyDeletedCleanupPage' : 'GridCleanupPage', false);
    this.browserController.isFromGalleryCleanupPage = true;
    this.appBroadCast.on(BroadCastConstants.PROCESS_RECENTLY_DELETED_PAGE_BACK, this.onHandBackFunc);
    this.appBroadCast.on(BroadCastConstants.IS_PULLING_UP_CHANGE, this.setIsPullingUpFunc);
    this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.onJumpThirdPhotoBrowserFunc);
    // AlbumGrid.firstItem = this.albumInfo?.mediaItem?.data;

    AppStorage.setOrCreate<string>(Constants.KEY_OF_ALBUM_URI, this.albumInfo?.uri);
    AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 1);
    AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_ACTIONBAR_OPACITY, 1);
    this.initDataSource();
    this.setPhotoBrowserLoader();
    this.initActionBarController();
    if (this.albumInfo?.isTrashAlbum) {
      Log.info(TAG, 'Go to the recently deleted page.');
      ReportToBigDataUtil.report(BigDataConstants.ENTER_RECENTLY_DELETED);
    } else if (this.albumInfo?.isScreenShotAlbum) {
      Log.info(TAG, 'Go to the screenshot album deletion page.');
      ReportToBigDataUtil.report(BigDataConstants.CLEANUP_ENTER_SCREENSHOTS);
    } else if (this.albumInfo?.isPhotoAlbum) {
      // 后续可添加其他相册来识别清理页面
      let cleanupPage: string = NavigationConstants.NAVIGATION_ALL_PHOTOS_PAGE;
      const msg: Record<string, number | string | boolean> = {
        'cleanupPage': cleanupPage
      };
      ReportToBigDataUtil.report(BigDataConstants.ENTER_IMAGE_CLEANUP, msg);
    }
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    this.appBroadCast.off(BroadCastConstants.PROCESS_RECENTLY_DELETED_PAGE_BACK, this.onHandBackFunc);
    this.appBroadCast.off(BroadCastConstants.IS_PULLING_UP_CHANGE, this.setIsPullingUpFunc);
    this.broadCast.off(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.onJumpThirdPhotoBrowserFunc);
    this.dataSource?.releaseBroadCast();
  }

  private initDataSource() {
    if (!this.storage) {
      return;
    }
    let context: common.UIAbilityContext | undefined =
      this.storage.get<common.UIAbilityContext>('photosAbilityContext');
    if (context !== undefined) {
      let cleanupDataImpl: CleanupDataImplAsync = new CleanupDataImplAsync(this.storage);
      cleanupDataImpl.setFromPage(this.albumInfo?.isTrashAlbum ? Constants.GRID_CLEANUP_PAGE :
        Constants.IMAGE_CLEANUP_PAGE);
      cleanupDataImpl.setImageOrderByName(this.albumInfo?.isPhotoAlbum ? UserFileManagerAccess.FILE_KEY_DATE_ADDED :
        UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS);
      this.dataSource = new AlbumDataSource({
        context: context,
        albumInfo: this.albumInfo ?? new AlbumInfo(),
        dataImpl: cleanupDataImpl,
      });
      if (!this.albumInfo?.isTrashAlbum) {
        this.dataSource.setFilterMediaType(AlbumDefine.FILTER_MEDIA_TYPE_IMAGE);
      }
      this.dataSource.setAlbumUri(this.albumInfo?.uri ?? '');
      this.dataSource.notifyDirty();
      this.mSelectManager.setPhotoDataImpl(this.dataSource.photoDataImpl as PhotoDataImpl);
      this.mSelectManager.setTotalCount(this.albumInfo?.albumLocalAssetCount ?? 0);
      this.mSelectManager.setDataSource(this.dataSource);
    }
  }

  private initActionBarController() {
    this.actionBarController.isAllSelected = true;
    this.actionBarController.isEmpty =
      this.albumInfo?.albumLocalAssetCount ? this.albumInfo.albumLocalAssetCount > 0 : false;
    this.actionBarController.moreMenuList = [];
    this.actionBarController.totalSelectedCount =
      this.albumInfo?.albumLocalAssetCount ? this.albumInfo.albumLocalAssetCount : 0;
    this.actionBarController.title = '';
    this.actionBarController.actionMoreMenuList = [];
  }

  /* instrument ignore next */
  updateBrowserStatus(): void {
    Log.info(TAG, `updateBrowserStatus: isBrowserShow=${this.browserController?.isBrowserShow}, isSelectBrowserShow=${this.browserController?.isSelectBrowserShow}, isAnimating=${this.browserController?.isAnimating}`);
    this.isRunningAnimation = this.browserController?.isAnimating ?? false;
  }

  /* instrument ignore next */
  onBackPressFunc(): boolean {
    Log.info(TAG, `navDestination onBackPressed isSelectBrowserShow: ${this.browserController?.isSelectBrowserShow}, isBrowserShow: ${this.browserController?.isBrowserShow}, isSelectedMode: ${this.isSelectedMode}`);
    if (this.browserController?.isSelectBrowserShow) {
      this.appBroadCast.emit(BroadCastConstants.SELECT_PHOTO_BROWSER_BACK_PRESS_EVENT,
        [this.browserController.browserControllerId]);
      return true;
    }
    if (this.browserController?.isBrowserShow) {
      let isPullingUp = this.isPullingUp;
      this.browserController.onBackPress();
      this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT, []);
      if (!isPullingUp) {
        this.browserController.isBrowserShow = false;
      }
      return true;
    }
    ScreenManager.getInstance().setDefaultStatusBarProperties(false);
    this.pageInfo.pop();
    return true;
  }

  @BuilderParam photoBrowserViewLoader: ($$: PhotoBrowserViewLoaderParams) => void;

  @Builder
  buildBrowser() {
    // if (this.browserController.isBrowserShow) {
    //   Column() {
    //     this.photoBrowserViewLoader({
    //       isShowBar: true,
    //       pageStatus: false,
    //       hidePhotoBrowser: (isPlayAni: boolean, index: number): void => {
    //         // todo lishang 接口需要更新，index改为返回实际index
    //         this.browserController.hideBrowser(index)
    //       },
    //       isRunningAnimation: this.isRunningAnimation,
    //       isShowMenu: true,
    //       canPullingUp: true,
    //       isShowThumbSource: true,
    //       isShowImageAnalyzer: true,
    //       reportStartTime: 0,
    //       onDeleteAllPhoto: (): void => {
    //       }
    //     })
    //   }
    //   .width('100%')
    //   .height('100%')
    //   .transition(TransitionEffect.asymmetric(TransitionEffect.opacity(0.99), TransitionEffect.opacity(0.99)))
    // }
  }

  @BuilderParam selectPhotoBrowserLoader: ($$: PhotoBrowserLoaderParams) => void;

  @Builder
  buildSelectPhotoBrowser() {
    if (this.browserController?.isSelectBrowserShow && this.selectPhotoBrowserLoader) {
      Column() {
        this.selectPhotoBrowserLoader({
          pageStatus: this.pageStatus,
          geometryTransitionEnable: true,
          isRunningAnimation: this.isRunningAnimation,
          selectManager: this.mSelectManager
        });
      }
      .width('100%')
      .height('100%')
      .transition(TransitionEffect.asymmetric(TransitionEffect.opacity(0.99), TransitionEffect.opacity(0.99)))
    }
  }

  private onHandBack(): void {
    Log.info(TAG, `onHandBack, pageInfo=${this.pageInfo.getAllPathName()}`)
    this.pageInfo.pop();
  }

  private setIsPullingUp(isPullingUp: boolean): void {
    Log.info(TAG, `setIsPullingUp, isPullingUp: ${isPullingUp}`)
    this.isPullingUp = isPullingUp;
  }

  @State bindSheetController: BindSheetController = new BindSheetController();

  build() {
    NavDestination() {
      Stack() {
        Column() {
        }
        // .enabled(!this.browserController.isAnimating)

        this.buildBrowser();
        this.buildSelectPhotoBrowser();
      }
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
    .onBackPressed((): boolean => {
      return this.onBackPressFunc();
    })
    .onShown(() => {
      Log.info(TAG, 'NavDestination onShown');
      this.pageStatus = true;
    })
    .onHidden(() => {
      Log.info(TAG, 'NavDestination onHidden')
      this.pageStatus = false;
    })
  }

  private async setPhotoBrowserLoader(): Promise<void> {
    try {
      let photoBrowserLoader = await import('../../MainAbility/view/PhotoBrowserLoader');
      // this.photoBrowserViewLoader = photoBrowserLoader.PhotoBrowserViewLoader;
      this.selectPhotoBrowserLoader = photoBrowserLoader.SelectPhotoBrowserLoader;
      Log.info(TAG, 'setPhotoBrowserLoader success');
    } catch (error) {
      Log.error(TAG, `setPhotoBrowserLoader error: ${error}`);
    }
  }

  onMenuClicked(action: Action): void {
    Log.info(TAG, `onMenuClicked, action: ${ActionID[action?.actionID]}`);
    if (action.actionID === Action.BACK.actionID) {
      this.onHandBack();
    }
  }

  private async onJumpThirdPhotoBrowser(name: string,
    item: MediaItem, geometryTapIndex: number, geometryTransitionString: string): Promise<void> {
    // 确保 selectPhotoBrowserLoader 已加载
    if (!this.selectPhotoBrowserLoader) {
      Log.warn(TAG, 'selectPhotoBrowserLoader not loaded yet, loading now...');
      await this.setPhotoBrowserLoader();
    }
    
    let targetIndex = this.dataSource?.getDataIndex(item) ?? 0;
    if (targetIndex === Constants.NOT_FOUND) {
      Log.error(TAG, 'targetIndex is not found');
      return;
    }
    Log.info(TAG, `jump to photo browser at index: ${targetIndex} ${name}`);
    let pageEntryFrom = Constants.ENTRY_FROM.NORMAL;

    AppStorage.setOrCreate(Constants.PHOTO_GRID_SELECT_MANAGER, this.mSelectManager);
    AppStorage.setOrCreate(Constants.APP_KEY_PHOTO_BROWSER, this.dataSource);
    if (geometryTapIndex !== undefined && geometryTransitionString !== undefined) {
      this.jumpToSelectPhotoBrowserGeometryTransition(
        targetIndex, name, pageEntryFrom, geometryTapIndex, geometryTransitionString);
    } else {
      Log.error(TAG, 'jump to selectPhotoBrowser error: geometryTapIndex or geometryTransitionString is undefined');
    }
  }

  private jumpToSelectPhotoBrowserGeometryTransition(targetIndex: number, name: string, pageEntryFrom:
    number, geometryTapIndex: number, geometryTransitionString: string): void {
    Log.info(TAG, `jumpToSelectPhotoBrowserGeometryTransition: targetIndex=${targetIndex}, name=${name}, geometryTapIndex=${geometryTapIndex}, geometryTransitionString=${geometryTransitionString}`);
    Log.info(TAG, `browserController exists: ${!!this.browserController}, selectPhotoBrowserLoader exists: ${!!this.selectPhotoBrowserLoader}`);

    interface Params {
      position: number;
      transition: string;
      pageFrom: number;
    }

    const params: Params = {
      position: targetIndex,
      transition: name,
      pageFrom: pageEntryFrom,
    };
    
    if (this.browserController) {
      Log.info(TAG, `Calling browserController.showSelectBrowser`);
      this.browserController.showSelectBrowser(geometryTapIndex, geometryTransitionString, 
        this.albumInfo?.isTrashAlbum ? 'RecentlyDeletedCleanupPage' : 'GridCleanupPage', params);
      Log.info(TAG, `After showSelectBrowser: isSelectBrowserShow=${this.browserController.isSelectBrowserShow}`);
    } else {
      Log.error(TAG, 'browserController is undefined, cannot show select browser');
    }
  }
}

