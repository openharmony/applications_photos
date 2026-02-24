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

import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { AlbumSetDataSource } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumSetDataSource';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { MenuContext } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuContext';
import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { CustomDialogView } from '@ohos/common/src/main/ets/default/view/dialog/CustomDialogView';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal,
  ScreenManager,
  updateSegmentButtonWidth,
  updateAlbumPageGridPaddingLeftAndRight
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Constants as PhotoConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy {
  AlbumSetDataSourceManager
} from '@ohos/common/src/main/ets/default/model/browser/album/AlbumSetDataSourceManager';
import lazy common from '@ohos.app.ability.common';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { VideoCleanUpPageActionBar } from '@ohos/common/src/main/ets/default/view/actionbar/VideoCleanUpPageActionBar';
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy {
  ActionBarMode,
  ActionBarSelectionMode
} from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { ViewData } from '@ohos/common/src/main/ets/default/model/browser/photo/ViewData';
import lazy { SelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy { CleanupDataImplAsync } from '@ohos/common/src/main/ets/default/model/browser/photo/CleanupDataImplAsync';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy { CleanupItemListCard } from '@ohos/common/src/main/ets/default/view/browserOperation/CleanupItemListCard';
import lazy { CommonObserverCallback } from '@ohos/common/src/main/ets/default/model/browser/CommonObserverCallback';
import lazy {
  MediaObserverNfyInfo,
  MediaObserverNfyType
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy { PhotoBrowserLoaderParams } from '@ohos/common/src/main/ets/default/interface/PhotoBrowserLoaderParams';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { NoPhotoComponent } from '@ohos/common/src/main/ets/default/view/NoPhotoComponent';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { UIExtensionContentSession } from '@kit.AbilityKit';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { PageStatus } from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { StatusBarClickEvent } from '@ohos/common/src/main/ets/default/utils/StatusBarClickEvent';

/**
 * Description.
 *
 * @since 2025-01-08
 */
/* instrument ignore file */
const TAG: string = 'VideoCleanupPage';

// 视频专清列表页
@Component
export struct VideoCleanupPage {
  @StorageLink('topRectHeight') topRectHeight: number = 0;
  @StorageLink('bottomRectHeight') bottomRectHeight: number = 0;
  @StorageProp('currentColorMode') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @Provide broadCast: BroadCast = new BroadCast();
  @State dataSourceBroadCast: BroadCast = new BroadCast();
  @State screenHeight: number = getScreen().getWinHeight();
  @State listCardMargin: number = updateAlbumPageGridPaddingLeftAndRight(true);
  @State listCardPaddingBottom: number = 24;
  @State private hoverSelectIndex: number | undefined = undefined;
  public scroller: ListScroller = new ListScroller();
  private scrollerIndex: number = 0;
  public albums: AlbumSetDataSource | null = null;
  public isActive: boolean = false;
  public isAlbumActive: boolean = false;
  public sourceAlbumUri: string = '';
  public currentAlbum: AlbumInfo | null = null;
  private onDataReloadFun: Function = (): void => this.onDataReload();
  private onWindowSizeChangedFun: Function = (): void => this.onWindowSizeChanged();
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @State moreMenuList: Action[] = [];
  private onMenuClickedFunc: Function = (action: Action): void => this.onMenuClicked(action);
  @State private isNeedPlaceholder: boolean = false;
  @State isEmptyAlbum: boolean = false;
  private storage: LocalStorage | undefined;
  @State private dataSource: MediaDataSource | undefined = undefined;
  private mSelectManager: SelectManager = new SelectManager();
  private onSelectFunc: Function =
    (keyIndex: number, selectUri: string, value: boolean, callback?: Function): void => this.onSelect(keyIndex,
      selectUri, value, callback);
  @State @Watch('updateActionBar') private isSelectedMode: boolean = false;
  @State private isBackPressed: boolean = false;
  @State private title: string | Resource = $r('app.string.video_cleanup');
  private albumInfo: AlbumInfo | undefined = undefined;
  readonly imageCenterLength: number = 28;
  @Consume pageInfo: NavPathStack;
  @State @Watch('updateActionBar') private isAllSelected: boolean = false;
  @State private selectedItemsSize: string = '0 KB';
  private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  private isDataFreeze = false;
  // @Provide @Watch('updateBrowserStatus') browserController: PhotosHmBrowserController = new PhotosHmBrowserController(
  //   LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext') ??
  //   global.uiAbilityContext(), global.windowStage(), getContext()
  // )
  @State pageStatus: boolean = false;
  @State isRunningAnimation: boolean = false;
  @State selectedItemsCount: number = 0;
  @State private segmentButtonWidth: Length = updateSegmentButtonWidth();
  @State @Watch('updateActionBar') private isEmpty: boolean = false;
  private dividerMarginStart: number = 0;
  private mediaItem: MediaItem | undefined = undefined;
  pageName = 'VideoCleanupPage';
  deviceName: string = '';
  private onJumpThirdPhotoBrowserFunc: Function =
    (name: string, item: MediaItem, geometryTapIndex: number, geometryTransitionString: string): void =>
    this.onJumpThirdPhotoBrowser(name, item, geometryTapIndex, geometryTransitionString);
  private onSwiperIndexChangeFunc: Function = (index: number): void => this.onIndexChange(index);
  private isFromVideoCleanupEntryPage: boolean = false;
  @State isNeedAnime: boolean = true;
  private topRectPadding: number = px2vp(UiUtil.getResourceNumber($r('sys.float.padding_level4')));
  private deleteVideoSizeByte: number = 0;
  private onBackPressFunc: Function = (): boolean => this.onBackPressed();
  @StorageLink('isCleanupPageShow') @Watch('onPageChanged') isCleanupPageShow: boolean = true;
  private msg: Record<string, number | string | boolean> = {};
  private clickEvent: StatusBarClickEvent = new StatusBarClickEvent();

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear: go to VideoCleanupPage.');
    AppStorage.setOrCreate(Constants.IS_VIDEO_CLEANUP_PAGE, true);
    AppStorage.setOrCreate(Constants.KEY_OF_ALBUM_URI, this.albumInfo?.uri);
    this.initDataSource();
    this.initSelectManager();
    this.updateSelectStatus();
    this.isNeedAnime = !this.isFromVideoCleanupEntryPage;
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.clickEvent.register(TAG, () => {
      this.dataSource?.updateSlidingWindow(0);
      setTimeout(() => {this.scroller?.scrollToIndex(0, false)}, Constants.DELAY_TENTH_SECOND);
    });
    this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.onJumpThirdPhotoBrowserFunc);
    this.broadCast.on(BroadCastConstants.SELECT, this.onSelectFunc);
    this.appBroadCast.on(BroadCastConstants.SWIPER_INDEX_CHANGED, this.onSwiperIndexChangeFunc);
    this.appBroadCast.on(BroadCastConstants.PROCESS_VIDEO_PAGE_BACK, this.onBackPressFunc);
    WindowUtil.prepareWinRouter();
    this.listCardPaddingBottom = px2vp(UiUtil.getResourceNumber($r('sys.float.padding_level8')));
    this.dataSourceBroadCast = AlbumSetDataSourceManager.getInstance().getBroadCast();
    this.dataSourceBroadCast.on(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadFun);
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangedFun);
    this.listCardMargin = updateAlbumPageGridPaddingLeftAndRight(true);
    this.isEmpty = this.albumInfo?.count === 0;
    this.title = this.isFromVideoCleanupEntryPage ? $r('app.string.album_video') : $r('app.string.video_cleanup');
    this.updateActionBar();
    this.dividerMarginStart =
      px2vp(new RscGetter(getContext().resourceManager).getNumber($r('sys.float.corner_radius_level6')) +
      new RscGetter(getContext().resourceManager).getNumber($r('app.float.list_item_left_icon_bg_size')) +
      new RscGetter(getContext().resourceManager).getNumber($r('app.float.list_item_padding')));
    ReportToBigDataUtil.report(BigDataConstants.ENTER_VIDEO_CLEANUP);
    Log.info(TAG, 'aboutToAppear end.');
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    this.clickEvent.unRegister();
    AppStorage.delete(Constants.IS_VIDEO_CLEANUP_PAGE);
    AppStorage.delete(Constants.KEY_OF_ALBUM_URI);
    this.dataSource?.releaseBroadCast();
    this.broadCast.off(BroadCastConstants.SELECT, this.onSelectFunc);
    this.appBroadCast.off(BroadCastConstants.SWIPER_INDEX_CHANGED, this.onSwiperIndexChangeFunc);
    this.appBroadCast.off(BroadCastConstants.PROCESS_VIDEO_PAGE_BACK, this.onBackPressFunc);
    this.dataSourceBroadCast.off(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadFun);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangedFun);
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
  }

  private onSelect(keyIndex: number, selectUri: string, value: boolean, callback?: Function): void {
    if (this.mSelectManager.toggle(selectUri, value, keyIndex)) {
      Log.info(TAG, 'enter event process');
      if (typeof callback === 'function') {
        callback?.();
      }
    }
  }

  private onIndexChange(index: number) {
    Log.info(TAG, `onIndexChange scrollerIndex=${index}`);
    this.scrollerIndex = index;
    this.scroller.scrollToItemInGroup(0, this.scrollerIndex, false, ScrollAlign.AUTO);
  }

  updateBrowserStatus(): void {
    // Log.info(TAG, `this is update browser status, controller: ${this.browserController.isBrowserShow}`);
    // this.isRunningAnimation = this.browserController.isAnimating;
    // if (this.browserController.isStartHide) {
    //   /* instrument ignore next */
    //   if (DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable() && this.isHorizontal) {
    //     ScreenManager.getInstance().setSystemUi(false, true, false, true);
    //   } else {
    //     ScreenManager.getInstance().setSystemUi(true, true, false, true);
    //   }
    // }
  }

  private updateSelectStatus(): void {
    this.selectedItemsCount = this.mSelectManager.getSelectedCount();
    this.isSelectedMode = this.selectedItemsCount >= 1;
    Log.info(TAG,
      `updateSelectStatus: this.isSelectedMode=${this.isSelectedMode}, this.selectedItemsCount=${this.selectedItemsCount}`);
  }

  private updateFocus(action: Action): void {
    if (AccessibilityUtil.isOpenTouchGuideSync()) {
      if (action.actionID === Action.MULTISELECT.actionID) {
        AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_BUTTON_CANCEL);
      } else if (action.actionID === Action.SELECT_ALL.actionID) {
        AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_BUTTON_DESELECT_ALL);
      } else if (action.actionID === Action.DESELECT_ALL.actionID) {
        AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_BUTTON_SELECT_ALL);
      } else if (action.actionID === Action.CANCEL.actionID) {
        AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_BUTTON_MULTI_SELECT);
      }
    }
  }

  private initDataSource(): void {
    if (this.albumInfo && this.storage) {
      Log.info(TAG, 'initDataSource');
      let cleanupDataImpl: CleanupDataImplAsync = new CleanupDataImplAsync(this.storage);
      cleanupDataImpl.setFromPage(Constants.VIDEO_CLEANUP_PAGE);
      let context: common.UIAbilityContext | undefined =
        this.storage.get<common.UIAbilityContext>('photosAbilityContext');
      if (context !== undefined) {
        cleanupDataImpl.setContext(context);
        let newDataSourceTmp: MediaDataSource = new AlbumDataSource({
            context: context,
            albumInfo: this.albumInfo,
            dataImpl: cleanupDataImpl,
            initCount: this.albumInfo.albumLocalAssetCount
          });
        this.dataSource = newDataSourceTmp;
        this.dataSource.setAlbumUri(this.albumInfo.uri);
        this.dataSource.setFilterMediaType(AlbumDefine.FILTER_MEDIA_TYPE_VIDEO);
        this.dataSource.notifyDirty();
        this.mSelectManager.setPhotoDataImpl(cleanupDataImpl);
        this.mSelectManager.setDataSource(this.dataSource);
        this.mSelectManager.setTotalCount(this.albumInfo.count);
        this.dataSource.registerCallback('updateCount', (newCount: number): void => {
          Log.info(TAG, `updateCount: dataSource newCount is ${newCount}!`);
          this.isEmpty = !Boolean(newCount);
          this.dataSource?.onDataReloaded();
          this.mSelectManager.setTotalCount(newCount);
          if (this.isEmpty && this.isAllSelected) {
            Log.info(TAG, `updateCount: inverseSelection = ${this.mSelectManager.inverseSelection}`);
            this.mSelectManager.deSelectAll();
            this.onModeChange();
            this.selectedItemsSize = '0 KB';
          }
        });
      }
    }
  }

  private initSelectManager(): void {
    if (this.albumInfo) {
      Log.info(TAG, 'initSelectManager');
      this.mSelectManager.setAlbumUri(this.albumInfo?.uri);
      this.mSelectManager.setAlbumInfo(this.albumInfo);
      this.mSelectManager.mIsSelectedMode = true;
      this.mSelectManager.registerCallback('allSelect', (newState: boolean): void => {
        if (this.isDataFreeze) {
          return;
        }
        Log.info(TAG, `allSelect: this.isAllSelected=${this.isAllSelected}, newState=${newState}`);
        if (this.isAllSelected !== newState) {
          this.isAllSelected = newState;
        }
      });
      this.mSelectManager.registerCallback('updateCount', (newState: number): void => {
        if (this.isDataFreeze) {
          return;
        }
        this.updateSelectStatus();
        this.reFreshSelectedItemSize();
      });

      this.mSelectManager?.setGetMediaItemFunc((uri: string, itemNotifyCallback: Function): MediaItem | undefined => {
        return this.dataSource?.getMediaItemByUriFromAll(uri, itemNotifyCallback);
      });
    }
  }

  // 懒加载大图组件
  private async setPhotoBrowserLoader(): Promise<void> {
    try {
      let photoBrowserLoader = await import('../../MainAbility/view/PhotoBrowserLoader');
      this.selectPhotoBrowserLoader = photoBrowserLoader.SelectPhotoBrowserLoader;
      Log.info(TAG, 'setPhotoBrowserLoader success');
    } catch (error) {
      Log.error(TAG, `setPhotoBrowserLoader error: ${error}`);
    }
  }

  /**
   * 跳转到预览页
   */
  private onJumpThirdPhotoBrowser(name: string,
    item: MediaItem, geometryTapIndex: number, geometryTransitionString: string): void {
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
      Log.error(TAG, 'jump to selectPhotoBrowser error');
    }
  }

  private jumpToSelectPhotoBrowserGeometryTransition(targetIndex: number, name: string, pageEntryFrom:
    number, geometryTapIndex: number, geometryTransitionString: string): void {
    Log.debug(TAG, 'start jump to select photo browser in geometry transition');

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
    // this.browserController.showSelectBrowser(geometryTapIndex, geometryTransitionString, "VideoCleanupPage", params);
  }

  /**
   * 数据重载回调
   */
  private onDataReload(): void {
    Log.info(TAG, 'onDataReload');
    this.albums?.onDataReloaded();
  }

  /**
   * 窗口变更回调
   */
  private onWindowSizeChanged(): void {
    Log.info(TAG, 'onWindowSizeChanged');
    this.segmentButtonWidth = updateSegmentButtonWidth();
    this.listCardMargin = updateAlbumPageGridPaddingLeftAndRight(true);
  }

  /**
   * 媒体库变更发送通知
   *
   * @param nfyInfo 通知消息
   */
  onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    Log.info(TAG, `onMediaLibDataNfy nfyInfo: ${JSON.stringify(nfyInfo)}`);
    this.dataSource?.onNotify(nfyInfo);
    if (this.isSelectedMode && (nfyInfo.type === MediaObserverNfyType.PHOTO_REMOVE ||
      nfyInfo.type === MediaObserverNfyType.REMOVE_PHOTO_FROM_ALBUM ||
      nfyInfo.type === MediaObserverNfyType.PHOTO_UPDATE)) {
      Log.info(TAG, 'onMediaLibDataNfy nfyType is remove or update!');
      this.updateSelectedItems(nfyInfo.type);
    }
  }

  /**
   * 收到媒体库通知后检查选择项中是否有需要去除的项
   */
  private updateSelectedItems(nfyType: number): void {
    let uris: string[] = Array.from(this.mSelectManager.clickedSet);
    if (uris.length < 1) {
      return;
    }
    Log.info(TAG, `updateSelectedItems: selectedUris=${uris.length}`);
    UserFileManagerAccess.getInstance().getAlbumByUri(this.albumInfo?.uri).then((photoAlbum) => {
      Log.info(TAG, `updateSelectedItems: ${photoAlbum?.albumUri} count ${photoAlbum?.videoCount}`);
      for (let selectedUri of uris) {
        let fileFetchOpt = AlbumDefine.getFileFetchOptByUri(selectedUri);
        // let arr = photoAlbum?.getAssetsSync(fileFetchOpt);
        // if (arr?.length) {
        //   if (nfyType === MediaObserverNfyType.PHOTO_UPDATE) {
        //     this.updateSelectedUri(selectedUri);
        //   }
        // } else {
        //   Log.info(TAG, `updateSelectedItems: mSelectManager delete ${selectedUri}`);
        //   this.mSelectManager.clickedSet.delete(selectedUri);
        //   this.mSelectManager.selectedMap.delete(selectedUri);
        // }
      }
      Log.info(TAG, `updateSelectedItems: clickedSet=${this.mSelectManager.clickedSet.size}`)
      this.updateSelectStatus();
      this.reFreshSelectedItemSize();
    })
  }

  private updateSelectedUri(oldSelectedUri: string): void {
    Log.info(TAG, `updateSelectedUri: oldSelectedUri = ${oldSelectedUri}`);
    let selectItem = this.mSelectManager.selectedMap.get(oldSelectedUri);
    if (!selectItem) {
      return;
    }
    Log.info(TAG, `updateSelectedUri: selectIetm.path=${selectItem.path}`);
    UserFileManagerAccess.getInstance().getPhotoAssetByPath(selectItem.path).then((item): void => {
      if (item) {
        this.mSelectManager.clickedSet.delete(oldSelectedUri);
        this.mSelectManager.clickedSet.add(item.uri);

        // let mediaItem: MediaItem = new MediaItem(item);
        // this.mSelectManager.selectedMap.delete(oldSelectedUri);
        // this.mSelectManager.selectedMap.set(item.uri, mediaItem);
        // Log.info(TAG, `updateSelectedUri: newSelectedUri=${item.uri}`)
      }
    });
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    this.dataSource?.notifyDirty();
  }

  private createActionBar(): ActionBarProp {
    Log.info(TAG, 'createActionBar');
    let menuList: Action[] = [];
    if (!this.isEmpty) {
      menuList.push(this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL);
    }
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setLeftAction(Action.BACK)
      .setTitle(this.title)
      .setMenuList(menuList)
      .setMode(ActionBarMode.STANDARD_MODE)
      .setIsNeedTitle(true);
    if (this.isSelectedMode) {
      actionBarProp.setMode(ActionBarMode.SELECTION_MODE)
        .setSelectionMode(ActionBarSelectionMode.MULTI);
    }
    return actionBarProp;
  }

  private updateActionBar(): void {
    Log.info(TAG, 'updateActionBar');
    this.actionBarProp = this.createActionBar();
  }

  private getSelectIndex(isHover: boolean, index: number | undefined): void {
    if (isHover) {
      this.hoverSelectIndex = index;
    } else {
      this.hoverSelectIndex = undefined;
    }
  }

  build() {
    NavDestination() {
      // if (!this.browserController.isSelectBrowserShow) {
      //   this.buildActionBar();
      // }
      if (this.isEmpty) {
        NoPhotoComponent({
          title: $r('app.string.no_videos_head_title_videoAlbum'),
          isFromEmptyAlbum: true,
        });
      } else {
        Stack({ alignContent: Alignment.End }) {
          this.buildVideoItemList();
          this.buildClearButton();
          ScrollBar({ scroller: this.scroller })
            .margin({
              top: this.getTopHeight(),
              bottom: this.getBottomHeight(),
            });

          CustomDialogView({
            broadCast: $broadCast,
            isFromGalleryCleanupPage: true
          });

          this.buildSelectPhotoBrowser();
        }.onAppear(() => {
          this.setPhotoBrowserLoader();
          this.isNeedAnime = true;
          Log.info(TAG, 'PhotoBrowserLoader finished!');
        })
      }
    }
    .backButtonIcon($r('sys.symbol.chevron_backward'))
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
    .onShown(() => {
      this.pageStatus = true;
      LocalStorage.getShared()?.setOrCreate<PageStatus>(Constants.VIDEO_PAGE_STATUS, PageStatus.SHOW);
    })
    .onHidden(() => {
      this.pageStatus = false;
      LocalStorage.getShared()?.setOrCreate<PageStatus>(Constants.VIDEO_PAGE_STATUS, PageStatus.HIDE);
    })
    .onBackPressed((): boolean => {
      return this.onBackPressed();
    })
  }

  @BuilderParam selectPhotoBrowserLoader: ($$: PhotoBrowserLoaderParams) => void;

  @Builder
  buildSelectPhotoBrowser() {
    // if (this.browserController.isSelectBrowserShow) {
    //   Column() {
    //     this.selectPhotoBrowserLoader({
    //       pageStatus: this.pageStatus,
    //       geometryTransitionEnable: true,
    //       isRunningAnimation: this.isRunningAnimation
    //     });
    //   }
    //   .width('100%')
    //   .height('100%')
    //   .transition(TransitionEffect.asymmetric(TransitionEffect.opacity(0.99), TransitionEffect.opacity(0.99)))
    // }
  }

  @Builder
  buildVideoItemList() {
    Column() {
      List({ scroller: this.scroller }) {
        ListItemGroup() {
          this.buildCleanupItemList();
        }
        .backgroundColor($r('sys.color.comp_background_list_card'))
        .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level8') : $r('sys.float.corner_radius_level10'))
        .padding({
          left: $r('app.float.list_item_left_right_padding'),
          right: $r('app.float.list_item_left_right_padding'),
        })
        .divider({
          strokeWidth: '1px',
          startMargin: this.dividerMarginStart,
          endMargin: $r('app.float.list_item_right_icon1_margin_left'),
          color: $r('sys.color.ohos_id_color_list_separator'),
        })
      }
      // .visibility(this.browserController.isSelectBrowserShow ? Visibility.Hidden : Visibility.Visible)
      .transition(this.isNeedAnime ? PhotoConstants.VIDEO_CLEANUP_LIST_EFFECT : TransitionEffect.IDENTITY)
      .alignListItem(ListItemAlign.Center)
      .scrollBar(BarState.Off)
      .padding({
        top: this.getTopHeight(),
        bottom: this.getBottomHeight(),
      })
      .margin({
        left: this.listCardMargin,
        right: this.listCardMargin
      })
      .height('100%')
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .onScrollStart((): void => {
        this.dataSource?.pause();
        Log.info(TAG, `onScrollStart: this.dataSource?.isActive=${this.dataSource?.isActive}`);
      })
      .onScrollStop((): void => {
        this.dataSource?.resume();
        this.dataSource?.notifyDirty();
        Log.info(TAG, `onScrollStop: this.dataSource?.isActive=${this.dataSource?.isActive}`);
      })
      .onWillScroll((scrollOffset: number, scrollState: ScrollState, source: ScrollSource): void | ScrollResult => {
        if (Math.abs(scrollOffset) <= this.screenHeight && scrollState === ScrollState.Scroll) {
          this.dataSource?.resume();
          this.dataSource?.notifyDirty();
          Log.info(TAG, `onWillScroll: this.dataSource?.isActive=${this.dataSource?.isActive}`);
        }
        // 拖动滚动条离手后停止列表滚动
        if (source === ScrollSource.SCROLL_BAR_FLING) {
          return { offsetRemain: 0 };
        }
      })
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .width('100%')
    .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM])
  }

  private async reFreshSelectedItemSize(): Promise<void> {
    Log.info(TAG,
      `reFreshSelectedItemSize: selectedItemsCount=${this.selectedItemsCount}, this.dataSource.size=${this.dataSource?.size}`);
    if (!this.dataSource?.items) {
      return;
    }
    if (this.isAllSelected) {
      let videoTotalAssetSize =
        this.albumInfo ? (await this.albumInfo.getAlbumAssetInfo(Constants.VIDEO_CLEANUP_PAGE)).albumLocalAssetSize : 0;
      this.selectedItemsSize = ImageUtil.formatFileSize(videoTotalAssetSize);
      this.deleteVideoSizeByte = videoTotalAssetSize;
    } else {
      let totalSize: number = 0;
      const mediaArray: MediaItem[] = Array.from(this.mSelectManager.selectedMap.values());
      for (let mediaItem of mediaArray) {
        totalSize += mediaItem.size;
      }
      if (this.mSelectManager.inverseSelection) {
        let videoTotalAssetSize =
          this.albumInfo ? (await this.albumInfo.getAlbumAssetInfo(Constants.VIDEO_CLEANUP_PAGE)).albumLocalAssetSize :
            0;
        this.deleteVideoSizeByte = videoTotalAssetSize - totalSize;
      } else {
        this.deleteVideoSizeByte = totalSize;
      }
      this.selectedItemsSize = ImageUtil.formatFileSize(this.deleteVideoSizeByte);
    }
  }

  @Builder
  buildClearButton() {
    Column() {
      Column() {
        Button({ type: ButtonType.Normal, stateEffect: true, buttonStyle: ButtonStyleMode.NORMAL }) {
          Text($r('app.string.detele_button', this.selectedItemsSize))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontSize($r('sys.float.Body_L'))
            .maxFontScale(Constants.GALLERY_CLEANUP_PAGE_MAX_FONT_SCALE)
            .fontColor($r('sys.color.multi_color_08'))
            .constraintSize({ minHeight: $r('app.float.details_dialog_button_height') })
        }
        .key('ClearRecycleButton')
        .width(this.segmentButtonWidth)
        .borderRadius($r('sys.float.corner_radius_level10'))
        .onClick((): void => {
          this.onMenuClicked?.(Action.DELETE);
        })
        .enabled(this.selectedItemsCount > 0)
      }
      // .visibility(this.browserController.isSelectBrowserShow ? Visibility.Hidden : Visibility.Visible)
      .transition(this.isNeedAnime ? TransitionEffect.asymmetric(PhotoConstants.VIDEO_CLEANUP_OPEN_EFFECT,
        PhotoConstants.VIDEO_CLEANUP_CLOSE_EFFECT) : TransitionEffect.IDENTITY
      )
      .alignItems(HorizontalAlign.Center)
      .width(this.segmentButtonWidth)
      .height(Constants.ActionBarButtonHotZoneHeight)
      .backgroundColor($r('app.color.transparent'))
    }
    .padding({
      top: $r('app.float.dialog_double_buttons_margin'),
      left: $r('app.float.dialog_double_buttons_margin'),
      right: $r('app.float.dialog_double_buttons_margin'),
      bottom: $r('app.float.action_clear_recycle_large_padding'),
    })
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height(Constants.BOTTOM_ACTION_BAR_HEIGHT)
    .backgroundColor($r('app.color.transparent'))
    .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
    .position({ x: Constants.PERCENT_0, y: Constants.PERCENT_100 })
    .markAnchor({ x: Constants.PERCENT_0, y: Constants.PERCENT_100 })
  }

  onMenuClicked(action: Action): void {
    Log.info(TAG, `onMenuClicked, action: ${ActionID[action?.actionID]}`);
    let menuContext: MenuContext;
    if (action.actionID === Action.BACK.actionID) {
      if (this.isFromVideoCleanupEntryPage) {
        Log.info(TAG, `UIExtensionContentSession terminateSelf`);
        let session: UIExtensionContentSession | undefined =
          this.storage?.get<UIExtensionContentSession>('GalleryCleanupSession');
        session?.terminateSelf();
      } else {
        this.onHandBack();
      }
    } else if (action.actionID === Action.DELETE.actionID) {
      const mediaArray: MediaItem[] = Array.from(this.mSelectManager.selectedMap.values());
      this.mediaItem = mediaArray.length === 1 ? mediaArray[0] : undefined;
      menuContext = new MenuContext();
      this.msg = {
        'deletedVideosCount': this.selectedItemsCount,
        'deletedVideosSize': ImageUtil.formatMBSize(this.deleteVideoSizeByte),
      };
      menuContext
        .withSelectManager(this.mSelectManager)
        .withOperationStartCallback((): void => this.onDeleteStart())
        .withOperationEndCallback((): void => this.onDeleteEnd())
        .withBroadCast(this.broadCast)
        .withAlbumUri(this.albumInfo?.uri)
        .withAlbumInfo(this.albumInfo)
        .withMediaItem(this.mediaItem)
        .withFromPage(Constants.VIDEO_CLEANUP_PAGE)
        .operate(action.actionID);
      // 激活datasource，避免列表不更新
      this.dataSource?.onActive();
    } else if (action.actionID === Action.SELECT_ALL.actionID) {
      this.isSelectedMode = true;
      this.mSelectManager.selectAll(true);
    } else if (action.actionID === Action.DESELECT_ALL.actionID) {
      this.isSelectedMode = false;
      this.mSelectManager.deSelectAll();
    }
    this.updateFocus(action);
  }

  onDeleteStart(): void {
    Log.info(TAG, 'onDeleteStart');
    this.mSelectManager.deSelectAll();
    this.onModeChange();
    this.updateActionBar();
  }

  onDeleteEnd(): void {
    Log.info(TAG, 'onDeleteEnd');
    this.reportVideoDeleteInfo();
  }

  /**
   * 图库清理上报打点
   * @param albumInfo 相册信息
   */
  private reportVideoDeleteInfo(): void {
    ReportToBigDataUtil.report(BigDataConstants.CLEANUP_DELETE_VIDEOS, this.msg);
    Log.info(TAG, `reportVideoDeleteInfo finished! msg=${JSON.stringify(this.msg)}`);
  }

  onModeChange(): void {
    Log.info(TAG, 'onModeChange');
    this.isSelectedMode = false;
    this.isAllSelected = false;
    this.selectedItemsCount = 0;
  }

  private getListItemCode(item: ViewData, index: number | undefined): string {
    if (!item || !item.mediaItem) {
      return (TAG + index) as string;
    }
    return TAG + item.mediaItem.getHashCode() + item.mediaItem.displayName + '-' + item.mediaItem.size;
  }

  @Builder
  buildCleanupItemList() {
    LazyForEach(this.dataSource, (item: ViewData, index: number) => {
      ListItem() {
        if (item?.mediaItem) {
          CleanupItemListCard({
            dataSource: this.dataSource,
            mediaItem: item.mediaItem,
            geometryTransitionString: this.getGeometryTransitionId(item),
            keyIndex: index,
            isAllSelected: this.isAllSelected,
            mSelectManager: this.mSelectManager,
            isBackPressed: this.isBackPressed,
            // refreshState: this.browserController.isSelectBrowserShow,
            isSelected: this.mSelectManager.isItemSelected(item.mediaItem.uri),
          });
        }
      }
      .margin({
        top: index === 0 ? $r('app.float.list_item_top_bottom_padding') : 0,
        bottom: this.dataSource !== undefined && index === this.dataSource.totalCount() - 1 ?
          $r('app.float.list_item_top_bottom_padding') : 0,
      })
      .key(`VideoCleanupPage_${index}`)
      .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level6') : $r('sys.float.corner_radius_level8'))
      .hoverEffect(HoverEffect.Highlight)
      .backgroundColor(this.hoverSelectIndex === index && this.currentMode ===
      ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? $r('sys.color.comp_background_list_card') : undefined)
      .onHover((isHover: boolean, event: HoverEvent): void => {
        this.getSelectIndex(isHover, index);
      })
    }, (item: ViewData, index?: number) => {
      return this.getListItemCode(item, index);
    })
  }

  @Builder
  buildActionBar() {
    Column() {
      VideoCleanUpPageActionBar({
        actionBarProp: this.actionBarProp,
        onMenuClicked: this.onMenuClickedFunc,
        isNeedPlaceholder: this.isNeedPlaceholder,
        actionMoreMenuList: undefined,
        selectItemCount: this.selectedItemsCount,
        selectedCount: this.selectedItemsCount,
      })
        .padding({
          top: px2vp(this.topRectHeight),
        })
    }
    .zIndex(2)
    .position({ y: 0 })
    .backgroundColor($r('app.color.transparent'))
    .transition(this.isNeedAnime ? TransitionEffect.asymmetric(PhotoConstants.VIDEO_CLEANUP_OPEN_EFFECT,
      PhotoConstants.VIDEO_CLEANUP_CLOSE_EFFECT) : TransitionEffect.IDENTITY
    )
  }

  private onBackPressed(): boolean {
    Log.info(TAG, 'navDestination onBackPressed');
    // if (this.browserController.isSelectBrowserShow) {
    //   Log.info(TAG, 'exit SelectBrowser');
    //   this.appBroadCast.emit(BroadCastConstants.SELECT_PHOTO_BROWSER_BACK_PRESS_EVENT,
    //     [this.browserController.browserControllerId]);
    //   // this.browserController.isSelectBrowserShow = false;
    //   return true;
    // }
    if (this.isSelectedMode) {
      this.mSelectManager.deSelectAll();
      this.isSelectedMode = false;
      this.isBackPressed = !this.isBackPressed;
      return true;
    }
    if (this.storage && this.isFromVideoCleanupEntryPage) {
      Log.info(TAG, `UIExtensionContentSession onBackPressed`);
      let session: UIExtensionContentSession | undefined =
        this.storage?.get<UIExtensionContentSession>('GalleryCleanupSession');
      session?.terminateSelf();
      return true;
    }
    ScreenManager.getInstance().setDefaultStatusBarProperties(false);
    this.onHandBack();
    return true;
  }

  /**
   * 获取一镜到底动效id
   */
  getGeometryTransitionId(item: ViewData): string {
    if (!item?.mediaItem) {
      Log.warn(TAG, 'get geometry exception, item undefined');
      return this.pageName;
    }
    return this.pageName + item?.mediaItem?.hashCode;
  }

  private onHandBack(): void {
    Log.info(TAG, 'onHandBack');
    this.pageInfo.pop();
  }

  /**
   * 列表距离顶部的高度
   *
   * @returns 状态栏 + actionbar + 间隔
   */
  private getTopHeight(): number {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      return Constants.WindowDecorHeight;
    }
    Log.info(TAG, `topRectHeight = ${px2vp(this.topRectHeight)}`);
    return Constants.ActionBarHeight + px2vp(this.topRectHeight) + this.topRectPadding;
  }

  /**
   * 列表距离底部的高度
   *
   * @returns 删除按钮高度
   */
  private getBottomHeight(): number {
    return Constants.BOTTOM_ACTION_BAR_HEIGHT;
  }

  private onPageChanged(): void {
    Log.info(TAG, `onPageChanged: this.isCleanupPageShow=${this.isCleanupPageShow}`);
    if (this.isCleanupPageShow) {
      this.dataSource?.resume();
    } else {
      this.dataSource?.pause();
    }
  }
}
