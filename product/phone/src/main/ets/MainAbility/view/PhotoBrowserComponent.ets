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

import lazy { power } from '@kit.BasicServicesKit';
import lazy window from '@ohos.window';
import lazy sensor from '@ohos.sensor';
import lazy settings from '@ohos.settings';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy { AddMenuOperation } from '@ohos/common/src/main/ets/default/view/browserOperation/AddMenuOperation';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy {
  AlbumSetNewMenuOperation
} from '@ohos/common/src/main/ets/default/view/browserOperation/AlbumSetNewMenuOperation';
import lazy {
  BigDataConstants,
  ReportToBigDataUtil
} from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy { CommonObserverCallback } from '@ohos/common/src/main/ets/default/model/browser/CommonObserverCallback';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { CustomDialogView } from '@ohos/common/src/main/ets/default/view/dialog/CustomDialogView';
import lazy { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { UserConstraintUtil } from '@ohos/common/src/main/ets/default/utils/UserConstraintUtil';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal,
  ScreenManager,
  WindowMode,
  setHorizontal
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { PhotoAsset, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { JumpSourceToMain } from '@ohos/common/src/main/ets/default/model/browser/photo/JumpSourceToMain';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy {
  MediaObserverNfyInfo,
  MediaObserverNfyType
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy {
  MediaOperationBasePage
} from '@ohos/common/src/main/ets/default/view/browserOperation/MediaOperationBasePage';
import lazy { MediaOperationType } from '@ohos/common/src/main/ets/default/model/common/MediaOperationType';
import lazy { MenuContext } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuContext';
import type { MenuOperation } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuOperation';
import lazy { MenuOperationFactory } from '@ohos/common/src/main/ets/default/interface/MenuOperationFactory';
import lazy { menuOption } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuOption';
import lazy { MenuOptionOtherParams } from '@ohos/common/src/main/ets/default/view/browserOperation/interfaces';
import lazy {
  NavigationBroadCastManager
} from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { PhotoBrowserComponentBg } from '@ohos/common/src/main/ets/default/view/PhotoBrowserComponentBg';
import lazy { PhotoBrowserHolder } from '@ohos/common/src/main/ets/default/view/PhotoBrowserHolder';
import lazy {
  Constants as BrowserConstants,
  EditType,
  Constants as PhotoConstants
} from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { PhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataSource';
import lazy { PhotoSwiper } from '@ohos/browsercommon/src/main/ets/default/view/PhotoSwiper';
import lazy { PrintUtil } from '@ohos/common/src/main/ets/default/utils/PrintUtil';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { UriDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/UriDataSource';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';
import lazy { isSublist } from '@ohos/common/src/main/ets/default/utils/ArrayUtil';
import lazy {
  EditorController,
  ImageEditorMain,
  ImageEditorMsg
} from 'browsercommonphone';
import lazy {
  GotoPhotosMenuOperation
} from '@ohos/common/src/main/ets/default/view/browserOperation/GotoPhotosMenuOperation';
import lazy { PhotoBrowserActionBar } from '@ohos/common/src/main/ets/default/view/actionbar/PhotoBrowserActionBar';
import lazy { PhotoBrowserToolBar } from '@ohos/common/src/main/ets/default/view/actionbar/PhotoBrowserToolBar';
import lazy common from '@ohos.app.ability.common';
import lazy { Router } from '@ohos.arkui.UIContext';
import lazy { VideoPlayController } from '@ohos/browsercommon/src/main/ets/default/controller/VideoPlayController';
import lazy { AvPlayConstants, AvplayerStatus, } from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { ThumbDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/ThumbDataSource';
import lazy lockedScreenMgr from '@ohos/common/src/main/ets/default/utils/LockedScreen';
import lazy { ActionBar } from '@ohos/browsercommon/src/main/ets/default/view/actionbar/ActionBar';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { Context } from '@ohos.abilityAccessCtrl';
import lazy { BrowserStatisticReportManager } from '@ohos/common/src/main/ets/default/utils/StatisticReportUtil';
import lazy {
  EnterInfoFace,
  ParamBrowser,
  PhotoBrowserUtils,
  TitleName
} from '@ohos/common/src/main/ets/default/utils/PhotoBrowserUtils';
import lazy display from '@ohos.display';
import lazy { harmonyShare, systemShare } from '@kit.ShareKit';
import lazy utd from '@ohos.data.uniformTypeDescriptor';
import lazy { StartOptions } from '@kit.AbilityKit';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { MediaLibraryData } from '@ohos/common/src/main/ets/default/model/browser/photo/data/MediaData';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy Global from '@ohos/common/src/main/ets/default/utils/GlobalContext';

import lazy { LoadingDialog } from '@ohos.arkui.advanced.Dialog';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy {
  CommonEventManagerAccess,
  Subscriber
} from '@ohos/common/src/main/ets/default/access/CommonEventManagerAccess';
import lazy { FoldUtil, FoldData } from '@ohos/common/src/main/ets/default/utils/FoldUtil';
import lazy { SlideShowParams } from '@ohos/common/src/main/ets/default/view/SlideShowPage';
import lazy { SwingServiceController } from '@ohos/browsercommon/src/main/ets/default/utils/SwingServiceHelper';
import lazy { EditorPhotoContext } from '@ohos/common/src/main/ets/default/utils/EditorPhotoContext';
import lazy { uriPermissionManager, wantConstant } from '@kit.AbilityKit';
import lazy { BlurImageComponent } from '@ohos/common/src/main/ets/default/view/hidden/BlurImageComponent';
import lazy { AnimationUtil } from '@ohos/common/src/main/ets/default/utils/AnimationUtil';
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import lazy { Throttle } from '@ohos/common/src/main/ets/default/utils/Throttle';
import lazy { Heic2JPGManagerAccess } from '@ohos/common/src/main/ets/default/access/Heic2JPGManagerAccess';
import lazy { ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { FormControllerManager } from '@ohos/dataprovider/src/main/ets/controller/FormControllerManager';
import lazy { TaskUri } from '@ohos/dataprovider/src/main/ets/database/databaseconstant/TaskInfo';
import lazy { WallpaperEditorComponent } from '@ohos/common/src/main/ets/default/view/WallpaperEditorComponent';
import lazy { LoadingPanel } from '@ohos/browsercommon/src/main/ets/default/view/LoadingPanel';
import { EffectToggleComponent } from '@ohos/browsercommon/src/main/ets/default/view/EffectToggleComponent';
import { EffectPhotoContext, ShotForMoreContext } from '@ohos/browsercommon/src/main/ets/default/utils/EffectPhotoContext';
import lazy { EffectToggleHelper } from '@ohos/browsercommon/src/main/ets/default/utils/EffectToggleHelper';
import lazy { router } from '@kit.ArkUI';
import lazy { ParamAlbumInfo } from '@ohos/common/src/main/ets/default/interface/Album';
import lazy { AccessUtil } from '@ohos/dataprovider/src/main/ets/AccessUtil';

export type PhotoAlbum = photoAccessHelper.Album;

/* instrument ignore file */
const TAG: string = 'PhotoBrowserComponent';
const MEDIA_TYPE_LIVE: string = 'LIVE_PHOTO';
const DELAY_TIME: number = 100;
const DELAY_TIME_CONVERT: number = 200;
const FOCUS_DELAY: number = 350;

const COMMON_EVENT_SHUTDOWN = 'usual.event.SHUTDOWN';

@Builder
export function PhotoBrowserComponentLoader($$: PhotoBrowserComponentLoaderParams) {
  PhotoBrowserComponent({
    pageStatus: $$.pageStatus,
    geometryTransitionEnable: $$.geometryTransitionEnable,
    isRunningAnimation: $$.isRunningAnimation,
    browserController: $$.browserController,
    isFromFACard: $$.isFromFACard,
    isFromFormPortrait: $$.isFromFormPortrait,
  })
}

export interface PhotoBrowserComponentLoaderParams {
  pageStatus: boolean;
  geometryTransitionEnable: boolean,
  isRunningAnimation: boolean,
  browserController: BrowserController,
  isFromFACard: boolean,
  isFromFormPortrait: boolean,
}

// export type Action = Action;

// page of large photo
@Component
export struct PhotoBrowserComponent {
  private readonly rsc: RscGetter = new RscGetter(getContext().resourceManager);
  @Provide backgroundColorResource: Resource = $r('app.color.transparent');
  @Provide('dateTitle') photoDate: string = '';
  @Provide('timeLocationTitle') timeAndLocation: string = '';
  @Provide menuList: Action[] = [];
  @Provide toolMenuList: Action[] = [];
  @Provide topMenuList: Action[] = [];
  @State stateMachine: PhotoBrowserStateMachine = new PhotoBrowserStateMachine();
  @State private moreMenuList: Action[] = [];
  @State private showMovingPhotoCloseEffect: boolean = false;
  @State broadCast: BroadCast = new BroadCast();
  @State actionPortraitBarProp: ActionBarProp = new ActionBarProp();
  @State isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @Provide isShowBar: boolean = true;
  @Prop isShowSideBar: boolean = false;
  @Prop isShowSearchPage: boolean = false;
  @Prop isFromFACard: boolean = false;
  @Provide onlyChangeBgColor: boolean = false;
  @Provide disableSwipe: boolean = true;
  @Provide isPullingDown: boolean = false;
  @Provide @Watch('notifyIsPullingUp') isPullingUp: boolean = false;
  @Provide pageFrom: number = Constants.ENTRY_FROM.NORMAL;
  @Provide viewData: string = '';
  @Provide initPageFromCard: number = Constants.ENTRY_FROM.NORMAL;
  @Provide isShowVideo: boolean = false;
  @Provide isEnableMouse: boolean = false;
  @State @Watch('updateMoreMenu') currentShow: boolean = true;
  @StorageLink('isHorizontal') @Watch('updateIsHorizontal') isHorizontal:
    boolean = isOrientationHorizontal();
  @StorageLink('TimelinePageIndex') TimelinePageIndex: number = Constants.INVALID;
  @StorageLink('PhotoGridPageIndex') PhotoGridPageIndex: number = Constants.INVALID;
  @StorageLink('isSplitMode') isSplitMode: boolean = getScreen().isSplitMode();
  @StorageLink('leftBlank') leftBlank: number[] = getScreen().getLeftBlank();
  @StorageLink('entryFromHap') entryFromHap: number = Constants.ENTRY_FROM_NONE;
  mTransition: string = '';
  albumUri = '';
  private photoAlbum: PhotoAlbum | undefined;
  private highlightBroadCast: BroadCast | undefined;
  // swiper currentIndex, there may not be onChanged callback during data refresh, so mediaItem cannot be saved
  @Provide('transitionIndex') @Watch('onCurrentIndexChanged') currentIndex: number = 0;
  @State currentUri: string = '';
  // 如果在swiper动画过程中，targetIndex是swiper动画的目标位置。其他场景与currentIndex含义一致
  @State @Watch('onTargetIndexChanged') targetIndex: number = 0;
  @StorageLink('targetItem') targetItem: MediaItem | undefined = undefined;
  @State private actionBarPaddingTop: number | Resource = 0;
  controller: SwiperController = new SwiperController();
  @Prop @Watch('onPageChanged') pageStatus: boolean = false;
  @LocalStorageLink('geometryOpacity') @Watch('onGeometryOpacityChange') geometryOpacity: number = 1;
  @LocalStorageLink('isBrowserShow') isBrowserShow: boolean = false;
  @State geometryTransitionId: string = '';
  @Link isRunningAnimation: boolean;
  @ObjectLink browserController: BrowserController;
  @Provide isDeleting: boolean = false;
  @Provide hidePopup: boolean = false;
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @State editorController: EditorController = new EditorController();
  @State forceRefresh: number = 0;
  @State private isRequestOriginLoading: boolean = false;
  @Provide isShowMovingPhoto: boolean | undefined = false;
  @State private movingPhotoEffectMode?: number = 0;
  private dataReloadCompleteFun: Function = (albumInfoList: AlbumInfo[], isFromCache: boolean):
    void => this.dataReloadComplete(albumInfoList, isFromCache);
  private isMovingPhotoDownloading: boolean = false;
  @State isMovingPhotoSwitching: boolean = false;
  private comparable: boolean = false;
  private comparedMediaItem: MediaItem | undefined = undefined;
  private setIsSwitchingFunc: Function = (isSwitching: boolean): void => {
    this.setIsSwitching(isSwitching);
  }
  private setIsDownloadingFunc: (isDownloading: boolean, uri: string) => void =
    (isDownloading: boolean, uri: string): void => {
      this.setIsMovingPhotoDownloading(isDownloading, uri);
    }
  /**
   * 一拍多得特效切换按钮
   */
  @State private effectAction: Action[] = [];
  @Provide isButtonClicked: boolean = false;
  @Provide isEnhanceTriggered: boolean = false;
  private isShowWatermark: boolean = true;
  private isPlayFromInitialAnimation: boolean = false;
  @StorageLink('networkConnectionStatus') networkConnectionStatus: boolean = false;
  private isFirstLoad: boolean = true;
  @StorageLink('isVideoDownloading') isVideoDownloading: boolean = false;
  @StorageLink('isDownloadingInterrupt') isDownloadingInterrupt: boolean = false;
  // 进入和退出连拍界面大图的透明度控制
  @State private toolBarOpacityWithBurstPhotos: number = 1;
  @State private swiperOpacityWithBurstPhotos: number = 1;
  @State private centerPreviewOpacityWithBurst: number = 1;
  @State private openBurstPreviewBlurStyle: boolean = false;
  // DataSource
  @State @Watch('onDataSourceChange') dataSource: PhotoDataSource = new PhotoDataSource(this.stateMachine);
  private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  // The global BroadCast of the application process. Event registration and destruction should be paired
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private isFromCamera = false;
  private isPhotoActive = false;
  private isFromViewDataWithMediaUri = false;
  private isFromViewDataWithThirdUri = false;
  private isForceShowBar = false;
  private isFromPetalClip = false;
  private isPullDown = false;
  private isFromViewData: boolean = false;
  // the source of jump to the index page
  private jumpSourceToMain: number = JumpSourceToMain.NONE;
  // time when clicks the thumbnail from the camera
  private clickThumbnailTime = 0;
  // time to view the current picture
  private checkedTransition: string = '';
  private viewTime = 0;
  // When clicking quickly, only run aboutToAppear for the first time
  private hasAppeared: boolean = false;
  // albumInfo should be undefined by default (as for Timeline page), valid value should be only for album page
  private albumInfo?: AlbumInfo;
  private deviceName = '';
  private backFromCopy = false;
  private uriFromThirdPartyApp: string = '';
  private editNewUri: string = '';
  private favorCacheItemsMap = new Map<String, MediaItem>();
  private theDeleteItem: MediaItem | null = null;
  private geometryTransitionEnable: boolean = false;
  private isShowMenuFromThirdView: boolean = true;
  private videoPlayController?: VideoPlayController;
  private showLoadingTimerId?: number;
  private isFromGalleryCleanupPage: boolean = false;
  @State private isVideoPlaying: boolean = true;
  @StorageLink('isMute') @Watch('onIsMuteChanged') private isMute: boolean = false;
  @StorageLink('networkAvailable') @Watch('onNetworkAvailableChanged') networkAvailable: boolean = false;
  @State @Watch('onPullDownAndDrag') isPullDownAndDragPhoto: boolean = false;
  private pageType: string = '';
  @Consume('navigationPageInfos') navigationPageInfos: NavPathStack;
  private navigationBroadCast = NavigationBroadCastManager.getInstance().getBroadCast();
  private funcOnMediaOperationBack: Function =
    (pageType: string, mediaOperationAlbumName: string, mediaOperationAlbumUri: string, navigationPageFunc?: Function):
      Promise<void> => this.onMediaOperationBack(pageType, mediaOperationAlbumName, mediaOperationAlbumUri,
      navigationPageFunc);
  private updateMenuBeforePlayFunc: Function = (): void => this.updateMenuBeforePlay();
  private videoPlayCompletedFunc: Function = (): void => this.videoPlayCompleted();
  private videoPlaySwiperIndexChangedFunc: Function = (): void => this.videoPlaySwiperIndexChanged();
  private videoInterruptByOtherAppFunc: Function = (isPaused: boolean): void => {
    this.videoInterruptByOtherApp(isPaused);
  }
  private changePlayButtonStatusFunc: Function = (isVideoPlaying: boolean): void => {
    this.changePlayButtonStatus(isVideoPlaying);
  }
  private onToggleBarsFunc: Function = (backgroundColorResource?: Resource):
    void => this.onToggleBars(backgroundColorResource);
  private showToggleBarsFunc: Function = (backgroundColorResource?: Resource):
    void => this.showBars(backgroundColorResource);
  private pullDownEndFunc: Function = (): void => this.pullDownEnd();
  private pullDownStartFunc: Function = (): void => this.pullDownStart();
  private pullDownStartWithEventFunc: Function = (event: KeyEvent): void => this.pullDownStartWithEvent(event);
  private pullDownCancelFunc: Function = (): void => this.pullDownCancel();
  private onPhotoBrowserDeleteConfirmFunc: Function = (): void => this.onPhotoBrowserDeleteConfirm();
  private onPhotoBrowserRemoveConfirmFunc: Function = (): void => this.onPhotoBrowserRemoveConfirm();
  private doDeleteFunc: Function = (): void => this.doDelete();
  private onPhotoShowStateChangedFunc: Function = (state: boolean): void => this.onPhotoShowStateChanged(state);
  private setSwiperDisableFunc: Function = (value: boolean): void => this.setSwiperDisable(value);
  private onDataReloadWithEditFunc: Function = (): void => this.onDataReloadWithEdit();
  private doMediaOperationFunc: Function = (displayName: string, albumUri: string, completedFunc?: Function):
    Promise<void> => this.doMediaOperation(displayName, albumUri, completedFunc);
  private slideShowChangeIndexFunc: Function = (index: number): void => this.slideShowChangeIndex(index);
  private routeToSettingsPageFunc: Function = (componentId: string): void => this.routeToSettingsPage(componentId);
  private showBarsFunc: Function = (backgroundColorResource?: Resource):
    void => this.showBars(backgroundColorResource);
  private hideBarsFunc: Function = (backgroundColorResource?: Resource):
    void => this.hideBars(backgroundColorResource);
  private setFavorFunc: Function = (isFavor: boolean): void => this.setFavor(isFavor);
  private onDataContentChangedFunc: Function = (): void => this.onDataContentChanged();
  private onDataSizeChangedFunc: Function = (size: number): void => this.onDataSizeChanged(size);
  private doRotateFunc: Function = (result: number): void => this.doRotate(result);
  private doRenameFunc: Function = (result: TitleName, uniqueId: string): void => this.doRename(result, uniqueId);
  private initVideoPlayFunc: Function = (videoPlayController: VideoPlayController):
    void => this.initVideoPlay(videoPlayController);
  private downloadFinishCallback: Function | undefined = undefined;
  private updateCurrentByFormCurrentUriFunc: Function = (currentUri: string, currentAlbumUri: string):
    void => this.updateCurrentByFormCurrentUri(currentUri, currentAlbumUri);
  // ThumbDataSource
  private thumbSource: ThumbDataSource = new ThumbDataSource(this.stateMachine);
  @Provide isFirstInSwiperFromCard: boolean = false;
  @Provide fromCardCurrentIndex: number = 0;
  iconsNum: number = 5;
  @State pageDeleteNum: number = getScreen().getWinWidth() / this.iconsNum;
  deleteDialogIndex: number = 2;
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldChanged') private foldDisplayMode: display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @StorageLink('getFoldStatus') @Watch('onFoldChanged') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @State private isFoldExpandedEnhancer: boolean = DeviceInfo.isFoldable() && !DeviceInfo.isPhoneVde();
  @StorageLink('isFullMode') @Watch('isFullModeChanged') private isFullMode: boolean = getScreen().isFullMode();
  @State private isFullModeEnhancer: boolean = getScreen().isFullMode();
  private onPhotoBrowserBackPressEventFunc: Function = (): boolean | void => this.onBackPress();
  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();
  private operationPosition: number = BigDataConstants.OPERATION_IN_INVALID_POSITION;
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  @State needUnlock: boolean = false;
  isFromPortraitCoverSet: boolean = false;
  isFromPortrait: boolean = false;
  portraitIndex: number = 99;
  @Provide @Watch('onListeningStatus') vanishingState: boolean = true;
  private currentPage: string = Constants.MEDIA_OPERATION_FROM_PHOTO_BROWSER;
  private isHorizontalChangedByMenu: boolean = false;
  private isHorizontalAtAppear: boolean = false;
  private originOrientation: number = 0;
  private rotateChangeCount: number = 0;
  private rotateChangeCountMax: number = 5;
  // 判断当前是否在执行大图页删除动效
  @Provide isDoDeleteAnim: boolean = false;
  // 判断当前是否再执行横竖屏旋转动效
  private isDoRotateAnim: boolean = false;
  private doRotateAnimTimer: number = Number.NaN;
  private statisticRptMgr: BrowserStatisticReportManager = new BrowserStatisticReportManager();
  private loadingSize: number = 32;
  @LocalStorageLink('isEditorShown') @Watch('onEditorShown') isEditorShown: boolean = false;
  @StorageLink('isHalfFold') @Watch('foldStatusChange') isHalfFold: boolean = DeviceInfo.isHalfFoldState();
  @StorageLink('currentLanguage') @Watch('updateCurrentLanguage') currentLanguage: string | undefined = undefined;
  @State actionBarPositionY: Length = this.isHalfFold && !this.isHorizontal ? Constants.PERCENT_50 : Constants.PERCENT_0;
  @State isSlideBarShow: boolean = false;
  @LocalStorageLink('isShowBrowserAni') @Watch('showBrowserAniChange') isShowBrowserAni: boolean = false;
  private isWaitingOnUpdateMenu: boolean = false;
  private isAutoTask: boolean = false;
  @State enableDisplayDefaultImage: boolean = false;
  @State pcCurItem: MediaItem = new MediaItem();
  @StorageLink(Constants.APP_STORAGE_KEY_DOWNLOAD_PROGRESS) downloadProgress: number = 0;
  private subscriber: Subscriber | undefined = undefined;
  private exportPosition: number = -1;
  private isCloud: boolean = false;
  private isLoadLCD: boolean = false;
  private mposition: number = -1;
  private isStopCastSuccess = true;
  private readonly clickThrottle: Throttle<void> = new Throttle<void>(BrowserConstants.CLICK_DELETE_INTERVAL, TAG);
  private sharableTargets: harmonyShare.SharableTarget[] = [];
  private exportDialogController: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({
      content: $r('app.string.moving_photo_exporting'),
    }),
    autoCancel: false,
  });
  @State isShowOverlay: boolean = false;
  private showOverlayFunc: Function = (show: boolean): void => {
    this.isShowOverlay = show;
  }
  @State isShowLoading: boolean = false;
  private convertJpgTimeoutFunc: Function = (show: boolean): void => {
    this.isShowLoading = show;
  }
  private enableSlideshow: boolean | undefined = AppStorage.get<boolean>(Constants.ENABLE_SLIDESHOW);
  private waitingDoneCallback: () => void = (): void => {

  };
  private setWaitingDoneCallbackFunc: (callback: () => void) => void = (callback: () => void): void => {
    this.setWaitingDoneCallback(callback);
  }
  @State curFoldStatus: number = FoldUtil.getInstance().getCurFoldStatus();
  private foldDataChangeListener: (foldData: FoldData) => void = this.onFoldDataChange.bind(this);
  @StorageLink('isOpenTouchGuide') private isOpenTouchGuide: boolean = false;
  private QRCodeUpdateFunc: Function = (): void => this.QRCodeUpdate();
  private QRCodeGetItemFunc: Function = (callback: Function): void => this.QRCodeGetItem(callback);

  private QRCodeUpdate(): void {
    this.updateMenu(this.targetIndex);
  }

  private QRCodeGetItem(callback: Function): void {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.targetIndex);
    callback(currentPhoto);
  }

  public onEffectModeSwitchClicked: (isMovingPhoto?: boolean) => void = (isMovingPhoto: boolean = true): void => {
    if(!isMovingPhoto) {
      this.setIsPhotoSwitching(true);
      return;
    }
    Log.info(TAG, '[switchEffectMode:] onEffectModeSwitchClicked update menu.');
    this.setIsSwitching(true);
    this.waitingDoneCallback();
    this.waitingDoneCallback = (): void => {
    };
    this.isWaitingOnUpdateMenu = false;
  }
  @Provide({ allowOverride: 'albumInfoForMe' }) albumInfoForMe: AlbumInfo | undefined = undefined;
  private albumBroadCast: BroadCast = new BroadCast();
  private loadFinishedFun: Function = (totalCount: number, options: string, albumInfoList: AlbumInfo[]): void =>
  this.loadFinished(totalCount, options, albumInfoList);
  @Prop isFromFormPortrait: boolean = false;

  loadFinished(totalCount: number, options: string, albumInfoList: AlbumInfo[]): void {
    Log.info(TAG, `loadFinished totalCount: ${totalCount}, options:${options}`);
    if (options === 'setMe') {
      if (totalCount > 0) {
        this.albumInfoForMe = albumInfoList[0];
      } else {
        this.albumInfoForMe = undefined;
      }
    }
  }

  private onFoldDataChange(foldData: FoldData) {
    this.curFoldStatus = foldData.curFoldStatus;
  }

  private showBrowserAniChange(): void {
    if (this.browserController.isBrowserShow && !this.isShowBrowserAni) {
      this.updatePixMapDataSource();
    }
  }

  public setIsPhotoSwitching(isSwitching: boolean): void {
    this.isMovingPhotoSwitching = isSwitching;
    this.updateMenu(this.targetIndex);
  }

  private setWaitingDoneCallback(callback: () => void): void {
    if (this.isWaitingOnUpdateMenu) {
      this.waitingDoneCallback = callback;
    } else {
      callback();
    }
  }

  private editorDownloadCompletedCallbackFunc: () => void = (): void => {
  }

  private movingPhotoDownloadCompletedCallback(uri: string): void {
    this.appBroadCast.emit(BroadCastConstants.MOVING_PHOTO_DOWNLOAD_CALLBACK, [uri]);
  }

  private videoDownloadCompletedCallback(uri: string): void {
    this.appBroadCast.emit(BroadCastConstants.ON_VIDEO_DOWNLOAD_COMPLETED, [uri]);
  }

  private onFoldChanged(): void {
    this.isFoldExpandedEnhancer = DeviceInfo.isFoldable() && !DeviceInfo.isPhoneVde();
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
    if (this.isVerdeFoldable) {
      WindowUtil.setOrientation(window.Orientation.PORTRAIT);
      setTimeout((): void => {
        setHorizontal(false);
      }, BrowserConstants.DELAY_FOR_ROTATE_START);
    }
    this.updateActionBar(this.currentIndex);
  }

  private updateCurrentLanguage(): void {
    Log.info(TAG, `updateCurrentLanguage: ${this.currentLanguage}`);
    this.updateActionBar(this.currentIndex);
  }

  //【视频】是否是支持的视频格式
  private isSupportedVideoType: boolean = true;
  //【视频】广播回调
  private setIsSupportedVideoTypeFunc: Function = (isSupportedVideoType: boolean, src: string):
    void => this.setIsSupportedVideoType(isSupportedVideoType, src);

  private isFullModeChanged(): void {
    this.isFullModeEnhancer = getScreen().isFullMode();
    this.updateActionBar(this.currentIndex);
  }

  private onEditorShown(): void {
    if (this.isEditorShown === false) {
      Log.info(TAG, 'hide Editor startCastAbility');
      this.isPhotoActive = true;
      let currentPhoto: MediaItem = PhotoBrowserUtils.getCurrentPhoto(this.dataSource, this.currentIndex) as MediaItem;
    }
    animateTo({
      duration: PhotoConstants.EDITOR_SWITCH_IN_DURATION,
    }, () => {
      if (this.isEditorShown) {
        this.geometryOpacity = 0;
      } else {
        this.geometryOpacity = 1;
      }
    })
  }

  /**
   * 是否是支持的视频格式
   * @param isSupportedVideoType
   * @param src
   */
  /* instrument ignore next */
  private setIsSupportedVideoType(isSupportedVideoType: boolean, src: string): void {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.targetIndex);
    if (!currentPhoto) {
      return;
    }
    if (currentPhoto.uri === src) {
      this.isSupportedVideoType = isSupportedVideoType;
    }
  }

  private onDataSourceChange(): void {
    AppStorage.setOrCreate<PhotoDataSource>('dataSource', this.dataSource);
  }

  onGeometryOpacityChange(): void {
    Log.info(TAG, `actionbar onGeometryOpacityChange ${this.geometryOpacity}`);
  }

  async onMediaOperationBack(pageType: string, mediaOperationAlbumName: string, mediaOperationAlbumUri: string,
    navigationPageFunc?: Function):
    Promise<void> {
    Log.info(TAG, `onMediaOperationBack, pageType=${pageType}, mediaOperationAlbumUri=${mediaOperationAlbumUri}`);
    this.onPageShow();
    let currentPhoto: MediaItem | undefined = PhotoBrowserUtils.getCurrentPhoto(this.dataSource, this.currentIndex);
    let menuContext = new MenuContext();
    let menuOperation: MenuOperation | null = null;
    if (!currentPhoto) {
      Log.error(TAG, 'MediaOperation currentPhoto is undefined');
      return;
    }
    Log.info(TAG, 'MediaOperation back');
    menuContext.withFromPage(Constants.MEDIA_OPERATION_FROM_PHOTO_BROWSER);
    switch (pageType) {
      case MediaOperationType.ADD: // '添加到'不需要设置源相册
        menuContext.withMediaItem(currentPhoto)
          .withBroadCast(this.broadCast)
          .withTargetAlbumName(mediaOperationAlbumName)
          .withAlbumUri(mediaOperationAlbumUri)
          .withOperationEndCallback((err: Error, count: number, total: number): void => {
            this.onCopyEnd(err as Object, count, total);
          });
        if (currentPhoto?.getIsBurstPhotos()) {
          // 连拍照片需要批量处理
          const assets: MediaItem[] = await this.dataSource.getMediaItemsByBurstKey(currentPhoto?.burstKey);
          menuContext.withBurstPhotos(assets);
        }
        menuOperation = MenuOperationFactory.getInstance().createMenuOperation(AddMenuOperation, menuContext);
        this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.checkedTransition]);
        break;
      case MediaOperationType.MOVE:
        menuContext.withOperationEndCallback((err: Object, count: number, total: number): void => {
          this.onCopyEnd(err, count, total);
        })
          .withMediaItem(currentPhoto)
          .withBroadCast(this.broadCast)
          .withTargetAlbumName(mediaOperationAlbumName)
          .withAlbumInfo(this.albumInfo)
          .withAlbumUri(mediaOperationAlbumUri)
          .withOriginalAlbumUri(this.albumInfo?.uri)
          .withNavigationPageFunc(navigationPageFunc)
          .operate(Action.MOVE.actionID);
        break;
      default:
        break;
    }
    menuOperation?.doAction();
  }

  /**
   * 绑定ON_DATA_RELOADED广播的处理函数：当数据重新加载完成时
   *
   * @param albumInfoList 相册信息列表
   */
  dataReloadComplete(albumInfoList: AlbumInfo[], isFromCache: boolean): void {
    Log.info(TAG, `dataReloadComplete albumInfoList: ${albumInfoList.length} isFromCache:${isFromCache}`)
  }

  onPageChanged(): void {
    Log.info(TAG, 'call page status changed' + Log.stringify<Object>({
      pageStatus: this.pageStatus,
      isFromLockedScreen: lockedScreenMgr().isFromLockedScreen,
    }));
    if (this.pageStatus) {
      this.onPageShow();
    } else if (lockedScreenMgr().isFromLockedScreen) {
      lockedScreenMgr().onExit(true, true, TAG, 'onPageChanged call page status changed');
    } else {
      this.onPageHide();
    }
    Log.info(TAG, `onPageChanged networkAvailable value: ${this.networkAvailable}`);
  }

  onNetworkAvailableChanged(): void {
    Log.info(TAG, `networkAvailable Changed: ${this.networkAvailable}`);
  }

  onPullDownAndDrag(): void {
    Log.debug(TAG, `onPullDownAndDrag: ${this.isPullDownAndDragPhoto}`);
    this.browserController.isPullDownAndDrag = this.isPullDownAndDragPhoto;
  }

  discardCallback(): void {
    Log.debug(TAG, 'discardCallback called');
  }

  getBgPadding(): Padding {
    let backgroundPadding: Padding = {
      top: Constants.ActionBarHeight + (this.isHorizontal ? 0 : px2vp(this.statusBarHeight)),
      bottom: this.isHorizontal ? 0 : (Constants.ToolBarAvoidHeight + Constants.ToolBarHeight + getScreen()
        .getNaviBarHeight())
    }
    Log.info(TAG, `getBgPadding ${JSON.stringify(backgroundPadding)}`);
    return backgroundPadding;
  }

  onDeviceRotateChanged(data: sensor.OrientationResponse): void {
    Log.debug(TAG, `The device rotates z:${data.alpha}, x:${data.beta}, y:${data.gamma}`);
    // 关闭后再次打开监听时，开始几个数据不准。
    if (this.rotateChangeCount > this.rotateChangeCountMax) {
      this.rotateChangeCount = 0;
      if (((this.isHorizontal && Math.abs(data.gamma) > PhotoConstants.ROTATE_DEVICE_60_DEG_Y) ||
        (!this.isHorizontal && Math.abs(data.gamma) < PhotoConstants.ROTATE_DEVICE_30_DEG_Y)) &&
        (Math.abs(data.beta) > PhotoConstants.ROTATE_DEVICE_30_DEG_X &&
          Math.abs(data.beta) < PhotoConstants.ROTATE_DEVICE_150_DEG_X)) {
        PhotoBrowserUtils.offSensorOrientation(this.rotateChangeCount);
        PhotoBrowserUtils.setOrientationAuto();
      }
    } else {
      this.rotateChangeCount++;
    }
  }

  orientationSensor(rotationStatus: string): void {
    Log.info(TAG, `rotationStatus: ${rotationStatus}.`);
    if (this.isHorizontalChangedByMenu && rotationStatus === PhotoConstants.ROTATION_STATUS_ON) {
      Log.info(TAG, 'orientation sensor on success, call offSensorOrientation');
      this.isHorizontalChangedByMenu = false;
      PhotoBrowserUtils.offSensorOrientation(this.rotateChangeCount);
      try {
        sensor.on(sensor.SensorId.ORIENTATION, (data: sensor.OrientationResponse): void => {
          this.onDeviceRotateChanged(data);
        });
      } catch (err) {
        Log.error(TAG, `orientation sensor on fail, errCode: ${err.code}, msg: ${err.message}`);
      }
    }
  }

  updateIsHorizontal(): void {
    LocalStorage.getShared()?.setOrCreate<boolean>('isPullingUpSwiper', this.isPullingUp);
    if (!this.isFirstLoad) {
      this.updateMenu(this.currentIndex);
      clearTimeout(this.doRotateAnimTimer);
      this.isDoRotateAnim = true;
      this.doRotateAnimTimer = setTimeout((): void => {
        this.isDoRotateAnim = false;
      }, PhotoConstants.DELAY_FOR_WINDOW_ROTATE_ANIMATION)
    } else {
      this.isFirstLoad = false;
    }
  }

  onMenuClicked(action: Action): void {
    let actionID: number = action.actionID;
    Log.info(TAG, `onMenuClicked, actionID: ${ActionID[actionID]}, isPullingDown: ${this.isPullingDown}`);
    // 拦截取消隐藏多次点击
    if ((this.isDoDeleteAnim && (actionID === Action.DELETE.actionID)) ||
      !this.clickThrottle.isPassable()) {
      Log.info(TAG, 'Deleting animation, cannot delete');
      return;
    }
    let menuOperation: MenuOperation | null = null;
    let menuContext: MenuContext = new MenuContext();
    this.handleClickCases(actionID, menuOperation, menuContext);
  }

  private handleBackToAlbumOrPhotoGridPage(isAlbumPage = true): void {
    const isNotSourceAlbumAndEmpty =
      !this.dataSource.realTotalCount() &&
      this.albumInfo && !this.albumInfo?.isSourceAlbum;
    Log.info(TAG, `handleBackToAlbumOrPhotoGridPage : ${isAlbumPage} ${isNotSourceAlbumAndEmpty}`);
    if (isAlbumPage || isNotSourceAlbumAndEmpty) {
      // Reset the value to false, if we go to album page or photo grid page.
      this.enableDisplayDefaultImage = false;
      this.jumpSourceToMain = JumpSourceToMain.FORM_ABILITY_PHOTO_BROWSER;
      const menuContext: MenuContext = new MenuContext();
      const menuOperation: MenuOperation | null = this.handleGoToPhotosEvent(new MediaItem(), menuContext, null);
      menuOperation?.doAction();
    }
  }

  private handleClickCases(actionID: number, menuOperation: MenuOperation | null, menuContext: MenuContext): void {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.targetIndex);
    Log.info(TAG, `onMenuClicked, actionID: ${ActionID[actionID]}, isPullingDown: ${this.isPullingDown}, ` +
      `targetIndex: ${this.targetIndex}, uri: ${currentPhoto?.uri}`);
    if (actionID === Action.SLIDE_SHOW.actionID) {
      this.jumpSlideShowPage();
    } else if (actionID === Action.BACK.actionID) {
      let msg: Record<string, number | string | boolean> = {
        'from': BigDataConstants.BY_CLICK
      };
      ReportToBigDataUtil.report(BigDataConstants.ESC_PHOTO_BROWSER_WAY, msg);
      if (this.isFromFormPortrait) {
        this.appBroadCast.emit(BroadCastConstants.IS_SHOW_PHOTO_BROWSER_SNAPSHOT_OFF);
        return;
      }
      if (DeviceInfo.isSmallFoldScreen() && LocalStorage.getShared()?.get<boolean>('is_from_sub_screen')) {
        this.jumpToCamera();
        return;
      }
      if (this.isFromFACard) {
        this.handleBackToAlbumOrPhotoGridPage();
        return;
      }
      this.handleBackEvent();
      return;
    } else if (actionID === Action.INFO.actionID) {
      this.handleInfoEvent(currentPhoto);
      return;
    } else if (actionID === Action.NOT_FAVORITE.actionID || actionID === Action.FAVORITE.actionID) {
      this.handleFavorEvent(currentPhoto, menuContext, actionID);
      return;
    } else if (actionID === Action.GOTO_PHOTOS.actionID && this.isFromFACard) {
      this.jumpSourceToMain = JumpSourceToMain.FORM_ABILITY_PHOTO_BROWSER_PHOTO_ICON;
      menuOperation = this.handleGoToPhotosEvent(currentPhoto, menuContext, menuOperation);
    } else if (actionID === Action.GOTO_PHOTOS.actionID) {
      menuOperation = this.handleGoToPhotosEvent(currentPhoto, menuContext, menuOperation);
    } else if (actionID === Action.EDIT.actionID) {
      this.onEditClicked();
      return;
    } else if (actionID === Action.EDIT_INVALID.actionID) {
      UiUtil.showToast($r('app.string.file_can_not_edited'));
      return;
    } else if (actionID === Action.MOVE.actionID) {
      this.handleMoveEvent(currentPhoto);
    } else if (actionID === Action.SOUND_FILLED.actionID || actionID === Action.SOUND_OFF_FILLED.actionID) {
      this.isMute = !this.isMute;
      return;
    } else if (actionID === Action.VIDEO_PAUSE.actionID || actionID === Action.VIDEO_PLAY.actionID) {
      this.onVideoPlayOrPauseClicked();
      return;
    } else if (actionID === Action.PHONE_ROTATE.actionID) {
      this.handlePhoneRotate(currentPhoto);
      return;
    } else if (actionID === Action.OK.actionID) {
      this.handleConfirmEvent();
    } else if (actionID === Action.SET_WALLPAPER.actionID) {
      this.setWallpaper(currentPhoto);
    } else if (actionID === Action.FLASH_CAPTURE.actionID || actionID === Action.CLOSE_FLASH_CAPTURE.actionID ||
      actionID === Action.VIRTUAL_APERTURE.actionID || actionID === Action.CLOSE_VIRTUAL_APERTURE.actionID ||
      actionID === Action.DYNAMIC_PANNING.actionID) {
      this.handleEffectToggleChange(actionID, currentPhoto);
    } else {
      this.handleOtherCase(currentPhoto, actionID);
      return;
    }
    menuOperation?.doAction();
  }

  /*
   * 大图幻灯片播放
   */
  private jumpSlideShowPage(): void {
    let dataSource = this.dataSource.getAlbumDataSource();
    if (!dataSource) {
      Log.error(TAG, 'jumpSlideShowPage dataSource is undefined');
      return;
    }
    let params: SlideShowParams = {
      items: this.dataSource,
      broadCast: this.broadCast,
      currentIndex: this.currentIndex
    }
  }

  private slideShowChangeIndex(index: number): void {
    Log.info(TAG, `slideShowChangeIndex: ${index}`);
    this.currentIndex = index;
  }

  private goToPhotosFromFACard(): void {
    let param: Want = {
      bundleName: 'com.ohos.photos',
      abilityName: 'com.ohos.photos.MainAbility',
    };
    Log.debug(TAG, `routeToTimelinePage parm: ${JSON.stringify(param)}`);
    this.videoPlayController?.reset();
    let context: common.UIAbilityContext =
      LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
    context.startAbility(param)
      .then((): void => {
        Log.info(TAG, 'start Photos complete');
        context.terminateSelf();
      }).catch((error: BusinessError) => {
      Log.error(TAG, `start Photos failed, error: ${error}, code: ${error?.code}`);
      context.terminateSelf();
    });
  }

  private handleEffectToggleChange(actionID: number, currentPhoto?: MediaItem): void {
    // 抓拍走动图链路
    if (!currentPhoto) {
      Log.info(TAG, `handleEffectToggleChange return`);
      return;
    }
    const effectMode: number =
      Number(currentPhoto.data?.get(photoAccessHelper.PhotoKeys.MOVING_PHOTO_EFFECT_MODE));
    let isMoving = (currentPhoto.data?.get('subtype') === photoAccessHelper.PhotoSubtype.MOVING_PHOTO ||
      effectMode === photoAccessHelper.MovingPhotoEffectMode.IMAGE_ONLY);
    ShotForMoreContext.getInstance()
      .setUrl(currentPhoto.uri)
      .setPhotoType(isMoving ? 1 : 0)
      .setSwitchStartTime();
    if (isMoving) {
      const callback: Function = (success: boolean) => {
        this.isMovingPhotoSwitching = false;
        ShotForMoreContext.getInstance()
          .setSwitchEndTime()
          .setResult(success);
        ShotForMoreContext.getInstance().reportSwitch();
        ShotForMoreContext.getInstance().clear();
      }
    } else {
      const callback: Function = (success: boolean) => {
        this.isMovingPhotoSwitching = false;
        this.setIsSwitchingFunc(false);
        ShotForMoreContext.getInstance()
          .setSwitchEndTime()
          .setResult(success);
        ShotForMoreContext.getInstance().reportSwitch();
        ShotForMoreContext.getInstance().clear();
      }
      let imageUpdateCallback: Function = () => {
        this.updatePixMapDataSource();
        this.dataSource.resetPhotoRequest(currentPhoto.uri);
      }
      this.onEffectModeSwitchClicked(false);
      EffectPhotoContext.getInstance()
        .setUri(currentPhoto?.uri)
        .setImageUpdateCallback(imageUpdateCallback);
      this.dataSource.resetPhotoRequest(currentPhoto.uri);
      this.appBroadCast.emit(BroadCastConstants.CHANGE_IMAGE_LOADING, [true]);
    }
  }

  private handleInfoEvent(currentPhoto: MediaItem | undefined): void {
    if (!currentPhoto) {
      Log.warn(TAG, 'currentPhoto is undefined');
      return;
    }
    this.broadCast.emit(PhotoConstants.RESET_DEFAULT_SCALE + currentPhoto.uri, []);
    this.broadCast.emit(PhotoConstants.OPEN_CLICK_DETAIL_PULLING_UP + currentPhoto.uniqueId, [currentPhoto.uniqueId]);
    if (AccessibilityUtil.isOpenTouchGuideSync()) {
      AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_TEXT_INPUT, FOCUS_DELAY);
    }
  }

  // display的朝向和window的朝向值不同，通过display朝向得到对应的window朝向枚举值
  private getWindowOrientationValue(orientation: number): number {
    let result: number = 0;
    switch (orientation) {
      case display.Orientation.PORTRAIT:
        result = window.Orientation.USER_ROTATION_PORTRAIT;
        break;
      case display.Orientation.LANDSCAPE:
        result = DeviceInfo.isTablet() ? window.Orientation.USER_ROTATION_LANDSCAPE :
          window.Orientation.USER_ROTATION_LANDSCAPE_INVERTED;
        break;
      case display.Orientation.PORTRAIT_INVERTED:
        result = window.Orientation.USER_ROTATION_PORTRAIT_INVERTED;
        break;
      case display.Orientation.LANDSCAPE_INVERTED:
        result = DeviceInfo.isTablet() ? window.Orientation.USER_ROTATION_LANDSCAPE_INVERTED :
          window.Orientation.USER_ROTATION_LANDSCAPE;
        break;
      default:
        result = window.Orientation.AUTO_ROTATION_UNSPECIFIED;
        break;
    }
    return result;
  }

  // 通过当前当前页面名称
  private getCurrentNavigationPathName(): string {
    let currentNavigationPathName = this.navigationPageInfos.size() === 0 ? '' :
      this.navigationPageInfos.getAllPathName()[this.navigationPageInfos.size() - 1];
    return currentNavigationPathName;
  }

  private handlePhoneRotate(currentPhoto: MediaItem | undefined): void {
    if (!currentPhoto) {
      Log.warn(TAG, 'currentPhoto is undefined');
      return;
    }
    this.isHorizontalChangedByMenu = true;
    Log.info(TAG, `isHorizontalChangedByMenu: ${this.isHorizontalChangedByMenu}, change orientation by menu`);
    const isRotationLocked: boolean = settings.getValueSync(getContext(this),
      settings.general.ACCELEROMETER_ROTATION_STATUS, '1') === '0';
    // 如果设备锁定且方向与进入大图时方向不同，恢复至进入大图时方向
    if (this.isHorizontal !== this.isHorizontalAtAppear && isRotationLocked) {
      WindowUtil.setOrientation(this.getWindowOrientationValue(this.originOrientation));
    } else {
      if (this.isHorizontal) {
        WindowUtil.setOrientation(window.Orientation.USER_ROTATION_PORTRAIT);
      } else {
        WindowUtil.setOrientation(window.Orientation.USER_ROTATION_LANDSCAPE);
      }
    }
    // 用户打点
    Log.info(TAG, `pra ${currentPhoto.uri}`);
    const msg: Record<string, number | string | boolean> = {
      'url': ReportToBigDataUtil.urlAnonymize(currentPhoto.uri),
    };
    ReportToBigDataUtil.report(BigDataConstants.PHONE_ROTATE_ACTION, msg);
  }


  private handleMoveEvent(currentPhoto: MediaItem | undefined): void {
    this.hidePopup = true;
    if (!currentPhoto) {
      Log.warn(TAG, 'currentPhoto is undefined when onMenuClicked Action.MOVE.');
      return;
    }
    this.backFromCopy = true;
    this.pageType = MediaOperationType.MOVE;
    currentPhoto.mediaType && MediaOperationBasePage.judgeIsEmptyAlbumsAndCallbackByMediaType(this.albumInfo?.uri,
      (): void => this.showPromptNewAlbumDialog(),
      (): void => this.routeToSelectAlbumPage(this.pageType, currentPhoto?.mediaType ?? Number.NaN),
      currentPhoto?.mediaType ?? Number.NaN
    );
  }

  private handleBackEvent(): void {
    if (this.isFromPortraitCoverSet) {
      getScreen().setDefaultStatusBarProperties();
    }
    if (!this.isDoRotateAnim) {
      this.onBackPress();
    }
  }

  private handleOtherCase(currentPhoto: MediaItem | undefined, actionID: number): void {
    Log.info(TAG, `handleOtherCase actionID:${ActionID[actionID]}`);
    AppStorage.setOrCreate<string>(Constants.KEY_OF_HIDDEN_POSITION, TAG);
    AppStorage.setOrCreate<string>(Constants.KEY_OF_UNHIDDEN_POSITION, TAG);
    // 连拍照片的删除/隐藏/回收站恢复/从相册移除等单独处理
    const batchHandleActions = [
      Action.DELETE.actionID,
      Action.REMOVE_FROM.actionID,
    ]
    let albumUri: string | undefined =
      this.albumInfo?.uri ? this.albumInfo?.uri : this.photoAlbum?.albumUri;
    let otherParams: MenuOptionOtherParams = {
      albumUri: albumUri,
      uri: currentPhoto?.uri,
      isFromPortrait: this.isFromPortrait,
      currentIndex: this.currentIndex,
      mediaCount: this.dataSource.totalCount(),
      album: this.photoAlbum,
    };
    let broadCast: BroadCast = this.broadCast;
    menuOption(actionID, currentPhoto, broadCast, this.albumInfo,
      this.operationPosition, this.currentPage, otherParams);
  }

  private handleGoToPhotosEvent(currentPhoto: MediaItem | undefined, menuContext: MenuContext, menuOperation:
  MenuOperation | null): MenuOperation | null {
    if (!currentPhoto) {
      Log.warn(TAG, 'currentPhoto is undefined.');
      return null;
    }
    AppStorage.setOrCreate<string>('form_currentUri', '');
    menuContext.withJumpSourceToMain(this.jumpSourceToMain);
    this.videoPlayController?.reset();
    return MenuOperationFactory.getInstance()
      .createMenuOperation(GotoPhotosMenuOperation, menuContext);
  }

  private handleFavorEvent(currentPhoto: MediaItem | undefined, menuContext: MenuContext, actionID: number): void {
    if (!currentPhoto) {
      Log.warn(TAG, 'currentPhoto is undefined.');
      return;
    }
    Log.info(TAG, `handleFavorEvent currentPhoto favor state before: ${currentPhoto.isFavor}`);
    ReportToBigDataUtil.report(BigDataConstants.FAVOR_MENU_RESPONSE, { 'from': 'FULL_IMAGE_PAGE' });
    currentPhoto.isFavor = !currentPhoto.isFavor;
    this.appBroadCast.emit(BroadCastConstants.UPDATE_IS_FAVOR, [currentPhoto]);

    let handleMediaItem: Function = () => {
    };
    if (!UserFileManagerAccess.isFavoriteAlbumSubType(this.albumUri, this.albumInfo)) {
      handleMediaItem = (mediaItem: MediaItem) => {
        menuContext.withMediaItem(mediaItem)
          .withBroadCast(this.broadCast)
          .withTargetFavorStatus(currentPhoto.isFavor)
          .operate(actionID);
      };
    } else {
      handleMediaItem = (mediaItem: MediaItem) => {
        if (currentPhoto.isFavor) {
          if (this.favorCacheItemsMap.has(mediaItem.uri)) {
            this.favorCacheItemsMap.delete(mediaItem.uri);
          } else {
            Log.error(TAG, `not fount item uri ${mediaItem.uri}`);
          }
        } else {
          this.favorCacheItemsMap.set(mediaItem.uri, mediaItem);
        }
      }
    }
    handleMediaItem(currentPhoto);

    this.updateMenuFavor(this.targetIndex);
  }

  private setWallpaper(currentPhoto: MediaItem | undefined): void {
    if (!currentPhoto) {
      Log.warn(TAG, 'currentPhoto is undefined.');
      return;
    }
    if (WallpaperEditorComponent.shouldBlockWallpaperEdit()) {
      UiUtil.showToast($r('app.string.not_support_wallpaper_edit'));
      return;
    }
    // 如果是云图弹toast 提示下载
    if (currentPhoto.getPosition() === photoAccessHelper.PositionType.CLOUD) {
      UiUtil.showToast($r('app.string.current_picture_not_download_please_download_and_try_again'));
      return;
    }
    let mode = power.getPowerMode();
    if (mode === power.DevicePowerMode.MODE_CUSTOM_POWER_SAVE) {
      Log.info(TAG, 'MODE_CUSTOM_POWER_SAVE');
      UiUtil.showToast($r('app.string.not_support_wallpaper_change'));
      return;
    }

    interface SetWallpaperParams {
      imageUri: string,
      lcdUri: string,
    }

    let params: SetWallpaperParams = {
      imageUri: currentPhoto.uri,
      lcdUri: ImageUtil.getLCDUri(currentPhoto.uri, currentPhoto.path, currentPhoto.getDateModified()),
    }
    this.navigationBroadCast.emitAsync(
      NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_WALLPAPER_EDITOR]).then(() => {
      this.navigationPageInfos.pushPath(
        new NavPathInfo(NavigationConstants.NAVIGATION_WALLPAPER_EDITOR, params));
    });
    ReportToBigDataUtil.report(BigDataConstants.SET_WALLPAPER, {
      'url': ReportToBigDataUtil.urlAnonymize(currentPhoto.uri)
    });
  }

  private handleConfirmEvent(): void {
  }

  async onEditClicked(): Promise<void> {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.targetIndex);
    if (!currentPhoto || currentPhoto.size === 0) {
      Log.warn(TAG, 'currentPhoto is undefined or size is 0.');
      return;
    }
    // 上报编辑的资源类型
    let editType: EditType = currentPhoto.getIsMovingPhoto() ? EditType.MOVING_PHOTO : (currentPhoto.mediaType ===
    photoAccessHelper.PhotoType.IMAGE ? EditType.IMAGE : EditType.VIDEO);
    const msg: Record<string, number | string | boolean> = {
      'url': currentPhoto.uri,
      'type': editType
    };
    ReportToBigDataUtil.report(BigDataConstants.ENTER_EDIT_FROM, msg);
    // 文件位置信息，目前不支持position字段变更通知，需要实时查询
    TraceControllerUtils.startTrace('onEditClick isRemoteResource');
    let isRemoteResource: boolean = false;
    TraceControllerUtils.finishTrace('onEditClick isRemoteResource');
    Log.info(TAG, `${currentPhoto.uri} isRemoteResource: ${isRemoteResource}`);
    if (currentPhoto?.mediaType === photoAccessHelper.PhotoType.VIDEO) {
      this.appBroadCast.emit(BroadCastConstants.RESET_VIDEO_BEFORE_EDIT, [currentPhoto?.uri]);
      this.updateMenu(this.currentIndex);
    }
    if (isRemoteResource) {
      this.downloadFile(currentPhoto);
    } else {
      // 图片在本地，直接跳转编辑
      this.jumpToEditPage(currentPhoto, false);
    }
  }

  private downloadFile(currentPhoto: MediaItem): void {
    // 原图只在云端，需要先下载
    if (!this.networkAvailable) {
      Log.info(TAG, 'download file no network');
      // 网络不可用，提示无法下载
      UiUtil.showToast($r('app.string.no_network'));
      return;
    }
    if (this.isVideoDownloading) {
      Log.warn(TAG, 'repeated download is prohibited.');
      return;
    }
    if (currentPhoto?.getIsMovingPhoto()) {
      this.appBroadCast.emit(BroadCastConstants.MOVING_PHOTO_STOP_DOWNLOAD, [currentPhoto?.uri]);
    }
    this.editorController.imageEditorParams.position = UserFileManagerAccess.FILE_LOCATION_CLOUD;
    this.jumpToEditPage(currentPhoto, true);
  }

  jumpToEditPage(item: MediaItem, isRemoteSource: boolean): void {
    Log.info(TAG, `isRemoteResource value: ${isRemoteSource}`);
    this.isPhotoActive = false;
    let isVirtualAlbum =
      this.isFromPortrait ||
      this.isShowSearchPage || this.browserController.isFromSearch ||
        this.pageFrom === Constants.ENTRY_FROM.HIGHLIGHT ||
        this.albumInfo?.subType === photoAccessHelper.AlbumSubtype.GEOGRAPHY_CITY ||
        ((this.albumInfo?.isShootingAlbum ?? false) && this.albumInfo?.albumId === BrowserConstants.SHOOT_BURST_PHOTOS);
    Log.info(TAG, `isVirtualAlbum: ${isVirtualAlbum}`);
    EditorPhotoContext.getInstance().setIsVirtualAlbum(isVirtualAlbum);
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.targetIndex);
    this.controller.finishAnimation((): void => {
      this.editorController.showEditor(this.albumUri, item);
    })
  }

  onToggleBars(backgroundColorResource?: Resource): void {
    if (this.isShowBar) {
      this.hideBars(backgroundColorResource);
      this.appBroadCast.emit(BroadCastConstants.IS_SHOW_OR_HIDE_BAR, [true]);
    } else {
      this.showBars(backgroundColorResource);
      this.appBroadCast.emit(BroadCastConstants.IS_SHOW_OR_HIDE_BAR, [false]);
    }
    Log.info(TAG, `Toggle bars, isShowBar: ${this.isShowBar}`);
  }

  showBars(backgroundColorResource?: Resource): void {
    this.backgroundColorResource = backgroundColorResource ?
      backgroundColorResource : $r('sys.color.background_secondary');
    if (!this.isShowBar) {
      this.isShowBar = !this.isShowBar;
      if (!this.isHorizontal && !this.isHalfFold) {
        getScreen().setSystemUi(true);
      }
      if (this.isFoldExpanded || (DeviceInfo.isTablet() || FoldUtil.isTriExpand(this.curFoldStatus))) {
        getScreen().setSystemUi(true);
      }
    } else {
      this.onlyChangeBgColor = !this.onlyChangeBgColor;
    }
  }

  hideBars(backgroundColorResource?: Resource): void {
    this.backgroundColorResource = backgroundColorResource ?
      backgroundColorResource : $r('app.color.black');
    if (this.isShowBar) {
      this.isShowBar = !this.isShowBar;
    } else {
      this.onlyChangeBgColor = !this.onlyChangeBgColor;
    }
  }

  private routeToSettingsPage(componentId: string): void {
    Log.info(TAG, 'routeToSettingsPage, componentId=' + componentId);
    NavigationBroadCastManager.getInstance()
      .targetName = NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS;
    this.navigationBroadCast.emitAsync(
      NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS]).then(() => {
      this.navigationPageInfos?.pushPath(
        new NavPathInfo(NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS, componentId));
    });
  }

  routeToSelectAlbumPage(pageType: string, mediaType: number, blackUris?: string[]): void {
    Log.info(TAG, 'routeToSelectAlbumPage');
    NavigationBroadCastManager.getInstance().targetName = NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION;

    interface ParamsNavigation {
      pageFrom: string;
      pageType: string;
      albumInfo?: AlbumInfo;
      mediaType: number;
      blackUriList?: string[];
    }

    let params: ParamsNavigation = {
      pageFrom: Constants.MEDIA_OPERATION_FROM_PHOTO_BROWSER,
      pageType: pageType,
      albumInfo: this.albumInfo,
      mediaType: mediaType,
      blackUriList: blackUris,
    }
    this.navigationBroadCast.emitAsync(
      NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION]).then(() => {
      this.navigationPageInfos.pushPath(
        new NavPathInfo(NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION, params));
    });
  }

  private showPromptNewAlbumDialog(): void {
    this.hidePopup = true;
    this.broadCast.emit(BroadCastConstants.PROMPT_NEW_ALBUMS_DIALOG, [
      (): void => {
        Log.info(TAG, 'new albums cancel');
      },
      () => {
        Log.info(TAG, 'createNewAlbum');
        let menuContext = new MenuContext();
        menuContext
          .withOperationStartCallback((): void => {
          })
          .withOperationEndCallback((): void => {
          })
          .withAlbumInfo(this.albumInfo)
          .withBroadCast(this.broadCast)
          .withJumpSourceToMain(JumpSourceToMain.ALBUM);
        let menuOperation =
          MenuOperationFactory.getInstance().createMenuOperation(AlbumSetNewMenuOperation, menuContext);
        menuOperation.doAction();
      }
    ]);
  }

  onPhotoChanged(index: number): void {
    Log.info(TAG, `onPhotoChanged start, index=${index}`);

    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(index);

    this.reportToBigDataForPhotoSlide(index);
    this.currentIndex = index;
    this.updateActionBar(index);
    if (this.pageFrom !== Constants.ENTRY_FROM.PUZZLE) {
      this.updateId(index);
    }
    this.updatePixMapDataSource();
  }

  onIndexChange(index: number, updateSource: boolean = true): void {
    Log.info(TAG, `onIndexChange start, index=${index}`);
    this.statisticRptMgr.switch();
    this.reportToBigDataForPhotoSlide(index);
    this.currentIndex = index;
    this.stateMachine.setCurrentIndex(index);
    LocalStorage.getShared()?.setOrCreate<string>('geometryReuseId', `geometryReuseId_${this.currentIndex}`);
    this.updateId(index);
    if (updateSource) {
      this.updatePixMapDataSource();
    }
    if (this.isFromFACard) {
      this.updateActionBar(index);
    }
    this.isSupportedVideoType = true;
  }

  onCurrentIndexChanged(): void {
    this.targetIndex = this.currentIndex;
    this.stateMachine.setCurrentIndex(this.currentIndex);
    this.stateMachine.setTargetIndex(this.currentIndex);
    AppStorage.setOrCreate('currentIndex', this.currentIndex);
    this.appBroadCast.emit(BroadCastConstants.CAST_INDEX_CHANGED, [this.currentIndex, false, false]);
    this.isButtonClicked = false;
    this.isEnhanceTriggered = false;
    this.isPlayFromInitialAnimation = false;
    this.isSupportImageEditorReport();
  }

  onTargetIndexChanged(): void {
    Log.info(TAG, `onTargetIndexChanged  :${this.targetIndex}`);
    this.targetItem = this.getPhotoByIndex(this.targetIndex);
  }

  public isSupportImageEditorReport() {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.targetIndex);
    if (currentPhoto?.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE) {
      const msg: Record<string, string | boolean | undefined> = UiUtil.isImageEditedEnable(currentPhoto);
      ReportToBigDataUtil.report(BigDataConstants.SUPPORT_IMAGE_EDITOR, msg);
    }
  }

  onDataPrepare(index: number): void {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(index);
    Log.info(TAG, `onDataPrepare ${index} ${currentPhoto?.uri}`);
    Heic2JPGManagerAccess.getInstance().verifyJumpSuccess(index);

    this.targetIndex = index;
    this.updateActionBar(index);
  }

  updateId(index: number): void {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(index);
    if (!currentPhoto) {
      Log.error(TAG, 'updateId, item is undefined');
    } else {
      const timelineIndex: number = this.dataSource.getPositionByIndex(index) ?? Number.NaN;
      LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', timelineIndex as number);
      this.geometryTransitionId = this.browserController.pageFrom + currentPhoto.hashCode;
      LocalStorage.getShared()?.setOrCreate<string>('geometryTransitionBrowserId', this.geometryTransitionId);
      Log.debug(TAG, `updateId, index: ${index}, currentPhoto: ${currentPhoto.uri}, \
        placeholderIndex ${LocalStorage.getShared()?.get<number>('placeholderIndex')},\
        geometryTransitionBrowserId ${this.geometryTransitionId}, this.mTransition ${this.mTransition}, \
        pageFrom = ${this.pageFrom}`);
    }
  }

  onDataSizeChanged(size: number): void {
    Log.info(TAG,
      `onDataSizeChanged, size is ${size},isFromFACard ${this.isFromFACard} ${this.uriFromThirdPartyApp} ${this.isDeleting}`);
    if (this.isFromFACard) {
      if (size === 0) {
        // Fa卡片进入大图, 加载数据为空时，显示默认图和重置，菜单栏，操作栏和title
        this.enableDisplayDefaultImage = true;
        this.menuList = [];
        this.toolMenuList = [];
        this.photoDate = Constants.NULL_STRING;
        this.timeAndLocation = Constants.NULL_STRING;
        this.appBroadCast.emit(BroadCastConstants.COMP_LOAD_COMPLETED, []);
        Log.info(TAG,
          `enableDisplayDefaultImage  ${this.enableDisplayDefaultImage} ${this.dataSource?.realTotalCount()}`);
        if (this.uriFromThirdPartyApp) {
          return;
        }
        if (this.isDeleting) {
          // 点击删除按钮，允许调用onBackPress
          this.onBackPress();
        }
        return;
      } else {
        this.enableDisplayDefaultImage = false;
      }
    }
    if (size !== 0 || this.uriFromThirdPartyApp) {
      return;
    }
    this.onBackPress();
  }

  resetAlbum(albumUri: string | undefined): void {
    if (!albumUri) {
      return;
    }
    this.currentIndex = 0;
    Log.info(TAG, `not found in album[${this.albumUri}], so use ${albumUri} instead`);
    this.albumUri = albumUri;
    this.dataSource.resetAlbumUri(this.albumUri);
    return;
  }

  updatePixMapDataSource(): void {
    this.dataSource.updatePixMapDataSource(this.currentIndex, this.browserController.isAnimating);
    this.stateMachine.setCurrentIndex(this.currentIndex);
    this.stateMachine.setTargetIndex(this.currentIndex);
  }

  updateActionBar(index: number): void {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex?.(index);
    if (!currentPhoto?.uri) {
      Log.error(TAG, 'updateActionBar currentPhoto is invalid');
      return;
    }
    const detailTime: number | undefined = currentPhoto?.getDetailTime?.();
    if ((detailTime === undefined || this.isFromViewDataWithThirdUri) && !this.isForceShowBar) {
      Log.error(TAG, 'updateActionBar detailTime wrong');
      return;
    }
    this.photoDate = DateUtil.getLocalizedDate(detailTime);
    const time: string = DateUtil.getLocalizedTime(detailTime);
    if (this.pageFrom == Constants.ENTRY_FROM.NORMAL) {
      this.appBroadCast.emit(BroadCastConstants.IS_ENTER_BIG_IMAGE, [true]);
    }

    let uri = currentPhoto?.uri;

    this.updateMenu(index);
  }

  async updateMenu(index: number): Promise<void> {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(index);
    if (!currentPhoto) {
      return;
    }
    let isEdit = false;
    try {
      isEdit = await currentPhoto?.isEditable?.();
    } catch (error) {
      Log.error(TAG, `get isEditable failed: ${error}, code: ${error?.code}`);
    }
    let isVideo = currentPhoto.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO;
    this.isCloud = currentPhoto.getPosition() === photoAccessHelper.PositionType.CLOUD;
    if (UserFileManagerAccess.isFavoriteAlbumSubType(this.albumUri, this.albumInfo)) {
      let key = currentPhoto.uri;
      if (this.favorCacheItemsMap.has(key)) {
        let tempPhotoItem: MediaItem | undefined = this.favorCacheItemsMap.get(key);
        if (tempPhotoItem) {
          currentPhoto.isFavor = tempPhotoItem.isFavor;
        }
        this.favorCacheItemsMap.set(key, currentPhoto);
      }
    }

    let pageFrom: number = this.pageFrom;
    if (UserFileManagerAccess.isRecycleBin(this.albumUri)) {
      pageFrom = Constants.ENTRY_FROM.RECYCLE;
    }

    let menuTemp: Action[] = [];
    if (lockedScreenMgr().isFromLockedScreen) {
      menuTemp = [];
    } else if ((this.pageFrom === Constants.ENTRY_FROM.CARD &&
      !LocalStorage.getShared()?.get<boolean>('is_from_sub_screen')) ||
      (this.isFromViewDataWithMediaUri && !UserFileManagerAccess.isRecycleBin(this.albumUri))) {
      menuTemp = [Action.GOTO_PHOTOS];
    }

    this.menuList = [];
    Log.info(TAG, `updateMenu album[${this.albumUri}]  isFromLockedScreen:${lockedScreenMgr()
      .isFromLockedScreen} menus: ${this.menuList.length}`);

    let list: Action[] = [];
    // 一拍多得、动态照片特效切换按钮
    let effectAction: Action[] = [];
    Log.info(TAG, `updateMenu ${pageFrom}`);
    switch (pageFrom) {
      case Constants.ENTRY_FROM.NORMAL:
      case Constants.ENTRY_FROM.CAMERA:
      case Constants.ENTRY_FROM.PETALCLIP_VIDEO:
      case Constants.ENTRY_FROM.VIEW_DATA:
      case Constants.ENTRY_FROM.CARD:
      case Constants.ENTRY_FROM.PUZZLE:
        Log.warn(TAG, 'Entry from PUZZLE');
        list.push(currentPhoto.isFavor ? Action.FAVORITE : Action.NOT_FAVORITE);
        if (Global.getBoolean('autoPlayEnable') ? isVideo : this.isShowVideo) {
          this.setVideoPlayingActions(list);
        } else {
          Log.info(TAG, '[normal picture]')
        }
        if (!this.isVerdeFoldable) {
          list.push(!isEdit || this.isMovingPhotoSwitching ? Action.EDIT_INVALID : Action.EDIT);
        }
        list.push(Action.DELETE);
        this.menuList.push(Action.MORE);
        break;
      case Constants.ENTRY_FROM.RECYCLE:
        if (Global.getBoolean('autoPlayEnable') ? isVideo : this.isShowVideo) {
          this.setVideoPlayingActions(list);
        } else {
          Log.info(TAG, '[normal picture]')
        }
        list.push(Action.DELETE);
        this.menuList.push(Action.MORE);
        break;
      case Constants.ENTRY_FROM.HIGHLIGHT:
        Log.warn(TAG, 'Entry from HIGHLIGHT');
        list.push( currentPhoto.isFavor ? Action.FAVORITE : Action.NOT_FAVORITE);
        if (Global.getBoolean('autoPlayEnable') ? isVideo : this.isShowVideo) {
          this.setVideoPlayingActions(list);
        }
        if (!this.isVerdeFoldable) {
          list.push(Action.EDIT);
        }
        list.push(Action.DELETE);
        this.menuList.push(Action.MORE)
        break;
      default:
        Log.warn(TAG, 'ENTRY  case default');
        list.push(currentPhoto.isFavor ? Action.FAVORITE : Action.NOT_FAVORITE);
        if (Global.getBoolean('autoPlayEnable') ? isVideo : this.isShowVideo) {
          this.setVideoPlayingActions(list);
        } else {
          Log.info(TAG, '[normal picture]')
        }
        if (!this.isVerdeFoldable) {
          list.push(Action.EDIT);
        }
        list.push(Action.DELETE);
        this.menuList.push(Action.MORE)
        break;
    }

    if (this.isHorizontal) {
      if (this.isShowMenuFromThirdView) {
        this.menuList = list.concat(this.menuList);
      }
      this.toolMenuList = [];
    } else if (this.isShowMenuFromThirdView) {
      if (!UiUtil.isActionArrayEqual(this.toolMenuList, list)) {
        this.toolMenuList = list;
      }
    } else {
      this.toolMenuList = [];
    }
    if ((DeviceInfo.isFoldable() && !DeviceInfo.isPhoneVde()) &&
    this.isFullMode && !lockedScreenMgr().isFromLockedScreen) {
      if (this.isShowMenuFromThirdView && !isSublist(this.menuList, list)) {
        this.menuList = list.concat(this.menuList);
      }
      this.toolMenuList = [];
    }
    if (!UiUtil.isActionArrayEqual(this.menuList, menuTemp)) {
      this.menuList = menuTemp.concat(this.menuList);
    }
    // 刷新一拍多得按钮
    this.effectAction = effectAction;
    let menuTempList: Action[] = [];
    Log.info(TAG, `curIndex: ${index}  isMoving: ${currentPhoto?.getIsMovingPhoto()},
    mediaType: ${currentPhoto?.mediaType}`);
    let isExportVideo: boolean = currentPhoto.isExportVideo();
    if (!this.albumInfo && this.pageFrom !== Constants.ENTRY_FROM.HIGHLIGHT) {
      // 照片页
      menuTempList = [Action.MOVE];
    } else {
      // 指定相册
      if (this.isFromPortrait) {
        menuTempList = [Action.MOVE, Action.REMOVE_FROM];
      } else if (this.albumInfo?.isTrashAlbum) {
      } else {
        menuTempList = [Action.MOVE];
      }
    }
    if (PrintUtil.suffix(currentPhoto) && !this.albumInfo?.isTrashAlbum) {
      menuTempList.push(Action.PRINT);
    }
    if (!this.albumInfo?.isTrashAlbum) {
      menuTempList.push(Action.RENAME);
    }
    if ((DeviceInfo.isPhoneUx() || DeviceInfo.isTablet()) && !isVideo && this.isSupportSlideShow()) {
      menuTempList.push(Action.SLIDE_SHOW);
    }
    menuTempList.push(Action.INFO);
    // 三级界面设置菜单
    if (!DeviceInfo.isEmulator() && !this.albumInfo?.isTrashAlbum &&
      currentPhoto.mediaType === photoAccessHelper.PhotoType.IMAGE && !DeviceInfo.isVerdeFoldable() &&
      !UserConstraintUtil.isConstraintUserModifyWallpaper()) {
      menuTempList.unshift(this.getWallpaperMenu());
    }
    if (!UiUtil.isActionArrayEqual(this.moreMenuList, menuTempList)) {
      this.moreMenuList = menuTempList;
    }
    this.updateMenuForMovingPhoto();
    Log.info(TAG, 'phone update menu complete' + currentPhoto?.mimeType);
  }

  private isSupportSlideShow(): boolean {
    // false
    return !(this.albumInfo?.isTrashAlbum ||
      this.pageFrom === Constants.ENTRY_FROM.HIGHLIGHT);
  }

  private updateMenuForMovingPhoto(): void {
    if (!this.isInvalidMovingPhotoMenu()) {
      this.showMovingPhotoCloseEffect = this.isCloud;
    }
    if (this.albumInfo && (this.albumInfo.isTrashAlbum)) {
      this.showMovingPhotoCloseEffect = false;
    }
  }

  private isInvalidMovingPhotoMenu(): boolean {
    if (this.isCloud) {
      return false;
    }
    if (this.albumInfo && (this.albumInfo.isTrashAlbum)) {
      return true;
    }
    return this.isMovingPhotoSwitching || this.isMovingPhotoDownloading;
  }

  private getWallpaperMenu(): Action {
    return this.isMovingPhotoSwitching ? Action.SET_WALLPAPER_INVALID : Action.SET_WALLPAPER
  }

  async updateMenuFavor(index: number): Promise<void> {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(index);
    if (!currentPhoto) {
      return;
    }
    //大图在相册判断--收藏相册逻辑更新
    this.SetFavorCacheItemsMap(currentPhoto);
    //更新三个menuList---this.menuList  this.toolMenuList  this.moreMenuList
    let pageFrom: number = this.pageFrom;
    pageFrom = this.updateMenuList(pageFrom, currentPhoto);
    let list: Action[] = [];
    try {
      list = await this.getList(pageFrom, currentPhoto);
    } catch (error) {
      Log.error(TAG, `get isEditable failed: ${error}, code: ${error?.code}`);
    }

    if (this.isHorizontal) {
      if (this.isShowMenuFromThirdView) {
        const goToPhotosIndex = this.menuList?.findIndex((item: Action) => item === Action.GOTO_PHOTOS);
        const listItemsIndex = goToPhotosIndex > Constants.NOT_FOUND ? (goToPhotosIndex + 1) : 0;
        this.menuList?.splice(listItemsIndex, 0, ...list);
      }
      this.toolMenuList = [];
    } else if (this.isShowMenuFromThirdView) {
      if (!UiUtil.isActionArrayEqual(this.toolMenuList, list)) {
        this.toolMenuList = list;
      }
    } else {
      this.toolMenuList = [];
    }
    if ((DeviceInfo.isFoldable() && !DeviceInfo.isPhoneVde()) &&
    this.isFullMode && !lockedScreenMgr().isFromLockedScreen) {
      if (this.isShowMenuFromThirdView && !isSublist(this.menuList, list)) {
        const goToPhotosIndex = this.menuList?.findIndex((item: Action) => item === Action.GOTO_PHOTOS);
        const listItemsIndex = goToPhotosIndex > Constants.NOT_FOUND ? (goToPhotosIndex + 1) : 0;
        this.menuList?.splice(listItemsIndex, 0, ...list);
      }
      this.toolMenuList = [];
    }

    //菜单栏中的更多菜单项
    let menuTempList: Action[] = [];
    menuTempList = this.setMenuTempList(menuTempList);
    if (!DeviceInfo.isEmulator() && !this.albumInfo?.isTrashAlbum &&
      currentPhoto.mediaType === photoAccessHelper.PhotoType.IMAGE && !DeviceInfo.isVerdeFoldable()) {
      menuTempList.unshift(this.getWallpaperMenu());
    }
    if (!UiUtil.isActionArrayEqual(this.moreMenuList, menuTempList)) {
      this.moreMenuList = menuTempList;
    }
    Log.info(TAG, 'update MenuFavor complete');
  }

  private setMenuTempList(menuTempList: Action[]) {
    if (!this.albumInfo) {
      // 照片页
      menuTempList = [Action.ADD, Action.INFO];
    } else {
      // 指定相册
      if (this.pageFrom === Constants.ENTRY_FROM.HIGHLIGHT) {
        menuTempList =
          [Action.MOVE, Action.INFO];
        let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.currentIndex);
      } else if (this.isFromPortrait) {
        menuTempList = [Action.MOVE, Action.REMOVE_FROM, Action.INFO];
      } else if (this.albumInfo.isTrashAlbum) {
        menuTempList = [Action.INFO];
      } else {
        menuTempList = [Action.MOVE, Action.INFO];
      }
    }
    return menuTempList;
  }

  private async getList(pageFrom: number, currentPhoto: MediaItem) {
    let list: Action[] = [];
    let isVideo = currentPhoto.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO;
    switch (pageFrom) {
      case Constants.ENTRY_FROM.NORMAL:
      case Constants.ENTRY_FROM.CAMERA:
      case Constants.ENTRY_FROM.HIGHLIGHT:
      case Constants.ENTRY_FROM.PETALCLIP_VIDEO:
      case Constants.ENTRY_FROM.VIEW_DATA:
      case Constants.ENTRY_FROM.CARD:
      case Constants.ENTRY_FROM.PUZZLE:
        list.push(currentPhoto.isFavor ? Action.FAVORITE : Action.NOT_FAVORITE);
        this.setList(list, currentPhoto);
        if (!DeviceInfo.isVerdeFoldable()) {
          try {
            list.push(!await currentPhoto?.isEditable?.() || this.isMovingPhotoSwitching ?
              Action.EDIT_INVALID : Action.EDIT);
          } catch (error) {
            Log.error(TAG, `get isEditable failed: ${error}, code: ${error?.code}`);
            list.push(Action.EDIT_INVALID);
          }
        }
        list.push(Action.DELETE);
        this.menuList.push(Action.MORE);
        break;
      case Constants.ENTRY_FROM.HIDDEN:
        list.push(currentPhoto.isFavor ? Action.FAVORITE : Action.NOT_FAVORITE);
        this.setList(list, currentPhoto);
        if (!this.isVerdeFoldable) {
          list.push(Action.EDIT);
        }
        list.push(Action.DELETE);
        this.menuList.push(Action.MORE);
        break;
      case Constants.ENTRY_FROM.RECYCLE:
        list.push(this.isVideoPlaying ? Action.VIDEO_PAUSE : Action.VIDEO_PLAY,
            this.isMute ? Action.SOUND_OFF_FILLED : Action.SOUND_FILLED);
        list.push(Action.DELETE);
        break;
      default:
        this.setList(list, currentPhoto);
        break;
    }
    return list;
  }

  private setVideoPlayingActions(list: Action[]) {
    list.push(this.isVideoPlaying ? Action.VIDEO_PAUSE : Action.VIDEO_PLAY,
        this.isMute ? Action.SOUND_OFF_FILLED : Action.SOUND_FILLED);
  }

  private setList(list: Action[], currentPhoto: MediaItem) {
    Log.warn(TAG, 'SET_LIST');
    let isVideo = currentPhoto.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO;
    if (Global.getBoolean('autoPlayEnable') ? isVideo : this.isShowVideo) {
      this.setVideoPlayingActions(list);
    } else {
      Log.info(TAG, '[normal picture]');
    }
  }

  private updateMenuList(pageFrom: number, currentPhoto: MediaItem) {
    if (UserFileManagerAccess.isRecycleBin(this.albumUri)) {
      pageFrom = Constants.ENTRY_FROM.RECYCLE;
    }

    let menuTemp: Action[] = [];
    if (lockedScreenMgr().isFromLockedScreen) {
      menuTemp = [];
    } else if (this.pageFrom === Constants.ENTRY_FROM.CARD ||
      (this.isFromViewDataWithMediaUri && !UserFileManagerAccess.isRecycleBin(this.albumUri))) {
      menuTemp = [Action.GOTO_PHOTOS];
    }
    if (!UiUtil.isActionArrayEqual(this.menuList, menuTemp)) {
      this.menuList = menuTemp;
    }
    Log.info(TAG, `updateMenuList album[${this.albumUri}]  isFromLockedScreen:${lockedScreenMgr()
      .isFromLockedScreen} menus: ${this.menuList.length}`);
    Log.info(TAG, `updateMenuList ${pageFrom}`);
    Log.info(TAG, `updateMenuList isFavor: ${currentPhoto.isFavor}`);
    this.appBroadCast.emit(BroadCastConstants.UPDATE_TRIGGER_VALUE, []);
    this.appBroadCast.emit(BroadCastConstants.UPDATE_TRIGGER_VALUE_ACTION_BAR, []);
    return pageFrom;
  }

  private SetFavorCacheItemsMap(currentPhoto: MediaItem) {
    if (UserFileManagerAccess.isFavoriteAlbumSubType(this.albumUri, this.albumInfo)) {
      let key = currentPhoto.uri;
      if (this.favorCacheItemsMap.has(key)) {
        let tempPhotoItem: MediaItem | undefined = this.favorCacheItemsMap.get(key);
        if (tempPhotoItem) {
          currentPhoto.isFavor = tempPhotoItem.isFavor;
        }
        this.favorCacheItemsMap.set(key, currentPhoto);
      }
    }
  }

  isShowMenuBigData(isShowMenuFromThirdView: boolean): void {
    this.isShowMenuFromThirdView = isShowMenuFromThirdView ?? true;
    this.updateMenu(this.currentIndex);
    Log.debug(TAG, 'isShowMenuFromThirdView input = ' + isShowMenuFromThirdView +
      ', isShowMenuFromThirdView present = ' + this.isShowMenuFromThirdView);
    this.updateMenu(this.currentIndex);
    const msg: Record<string, number | string | boolean> = {
      'isShowMenuFromThirdView': isShowMenuFromThirdView
    };
    ReportToBigDataUtil.report(BigDataConstants.IS_SHOW_MENU_ID, msg);
  }

  updateMoreMenu(): void {
    this.moreMenuList = [];
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.currentIndex);
    Log.info(TAG, `updateMoreMenu curIndex: ${this.currentIndex}  isMoving: ${currentPhoto?.getIsMovingPhoto()}`);
    if (this.pageFrom === Constants.ENTRY_FROM.HIGHLIGHT) {
      this.moreMenuList = [Action.MOVE];
    } else if (!this.albumInfo) {
      this.moreMenuList = [Action.MOVE];
    } else if (this.albumInfo.isTrashAlbum) {
    } else {
      this.moreMenuList = [Action.MOVE];
    }
    if (PrintUtil.suffix(currentPhoto as MediaItem) && !this.albumInfo?.isTrashAlbum) {
      this.moreMenuList.push(Action.PRINT);
    }
    if (!this.albumInfo?.isTrashAlbum) {
      this.moreMenuList.push(Action.RENAME);
    }
    if ((DeviceInfo.isPhoneUx() || DeviceInfo.isTablet()) &&
      currentPhoto?.mediaType !== UserFileManagerAccess.MEDIA_TYPE_VIDEO && this.isSupportSlideShow()) {
      this.moreMenuList.push(Action.SLIDE_SHOW);
    }
    this.moreMenuList.push(Action.INFO);
    if (!DeviceInfo.isEmulator() && !this.albumInfo?.isTrashAlbum &&
      this.getPhotoByIndex(this.currentIndex)?.mediaType === photoAccessHelper.PhotoType.IMAGE &&
      !DeviceInfo.isVerdeFoldable()) {
      this.moreMenuList.unshift(this.getWallpaperMenu());
    }
  }

  notifyIsPullingUp(): void {
    this.appBroadCast.emit(BroadCastConstants.IS_PULLING_UP_CHANGE, [this.isPullingUp]);
  }

  getPhotoByIndex(index: number): MediaItem | undefined {
    return (this.dataSource.getRawData(index).data);
  }

  onCopyEnd(err: Object, count: number, total: number): void {
    Log.debug(TAG, `onCopyEnd count: ${count}, total: ${total}`);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.checkedTransition]);
    if (err) {
      UiUtil.showToast($r('app.string.copy_failed_single'));
    }
  }

  async onDownloadEnd(err: Object, count: number, total: number): Promise<void> {
    Log.debug(TAG, `onDownloadEnd count: ${count}, total: ${total}`);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.checkedTransition]);
    if (err) {
      UiUtil.showToast($r('app.string.download_failed_single'));
    } else {
      UiUtil.showToast($r('app.string.download_progress_done'));
    }
  }

  private jumpToCamera(): void {
    AppStorage.setOrCreate<string>('form_currentUri', '');
    LocalStorage.getShared()?.setOrCreate<boolean>('is_from_sub_screen', false);
    let context: common.UIAbilityContext =
      LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
    const cameraShotKey = AppStorage.get<string>('cameraShotKey');
    if (cameraShotKey && cameraShotKey !== '') {
      let options: StartOptions = {
        displayId: 0
      };
      context.startAbility({
        bundleName: 'com.ohos.camera',
        abilityName: 'com.ohos.camera.MainAbility',
      }, options).then((): void => {
        Log.info(TAG, 'start Camera complete');
        context.terminateSelf();
      }).catch((error: BusinessError) => {
        Log.error(TAG, `start Camera failed, error: ${error}, code: ${error?.code}`);
        context.terminateSelf();
      });
    } else {
      context.terminateSelf();
    }
  }

  onBackPress(isPullDownBack?: boolean): boolean | void {
    Log.info(TAG,
      `[GeometryLogger] onBackPress, cur_index=${this.currentIndex},isDoDeleteAnim:${this.isDoDeleteAnim}, isFromFACard ${this.isFromFACard},checkedTransition ${this.checkedTransition}`);
    if (this.isDoDeleteAnim && this.currentIndex !== 0) {
      return;
    }
    this.appBroadCast.emit(BroadCastConstants.CLICK_BACK_PRESS, []);
    if (this.isFromPortraitCoverSet) {
      getScreen().setDefaultStatusBarProperties();
    }
    // 恢复原始朝向策略
    PhotoBrowserUtils.offSensorOrientation(this.rotateChangeCount);
    PhotoBrowserUtils.setOrientationAuto();
    this.resetOrientation();
    if (DeviceInfo.isSmallFoldScreen() && LocalStorage.getShared()?.get<boolean>('is_from_sub_screen')) {
      this.jumpToCamera();
      return;
    }
    if (this.isPullingUp) {
      let item: MediaItem | undefined = PhotoBrowserUtils.getCurrentPhoto(this.dataSource, this.targetIndex);
      this.broadCast.emit(PhotoConstants.CLOSE_CLICK_DETAIL_BY_BACK_PRESS + item?.path, []);
    } else if (this.editorController.onBackPress()) {
    } else if (this.needUnlock) {
      this.onBackPressInner();
    } else {
      this.broadCast.emit(BroadCastConstants.CHANGE_LOADING_STATUS, [true]);
      this.isPhotoActive = false;
      this.controller.finishAnimation((): void => this.onBackPressInner());
    }
    this.updateFocusWhenBackToPhotoGridView();
    return true;
  }

  private updateFocusWhenBackToPhotoGridView(): void {
    if (!AccessibilityUtil.isOpenTouchGuideSync()) {
      return;
    }
    let index: number = this.currentIndex ?? 0;
    let targetFocusedElementId: string;
    targetFocusedElementId = `photoGridView_gird_${index.toString()}`;
    Log.info(TAG, `targetFocusedElementId is ${targetFocusedElementId}`);
    AccessibilityUtil.sendFocusAccessibilityEvent(targetFocusedElementId);
  }

  // 根据旋转开关控制窗口旋转
  async resetOrientation(): Promise<void> {
    WindowUtil.setOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
  }

  /**
   * 点击视频播放回调
   * @param playVideoModel  AVPlay 的控制器
   */
  private updateMenuBeforePlay() {
    Log.info(TAG, `[videoPlayer] updateMenuBeforePlay current isShowVideo: ${this.isShowVideo},make it true.`);
    this.isShowVideo = true;
    this.updateMenu(this.targetIndex);
  }

  /**
   * 视频播放完成后的回调
   */
  private videoPlayCompleted() {
    Log.info(TAG, 'VideoPlayCompleted start ');
    this.isVideoPlaying = true;
    this.isShowVideo = false;
    this.updateVideoState();
  }

  /**
   * 视频切换的回调
   */
  private videoPlaySwiperIndexChanged() {
    Log.info(TAG, 'VideoPlaySwiperIndexChanged start ');
    this.isVideoPlaying = true;
    this.updateVideoState();
  }

  /**
   * 更新视频状态
   */
  private updateVideoState() {
    Log.info(TAG, `[videoPlayer] updateVideoState isShowVideo : ${this.isShowVideo},make it false, isVideoPlaying : ${
    this.isVideoPlaying}`);
    this.isShowVideo = false;
    this.updateMenu(this.targetIndex);
    PhotoBrowserUtils.offSensorOrientation(this.rotateChangeCount);
  }

  onBackPressInner(): void {
    Log.info(TAG, `onBackPressInner: To page: ${this.checkedTransition}.`);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_VIDEO_BACK_PRESS, []);
    switch (this.checkedTransition) {
      case Constants.PHOTO_TRANSITION_TIMELINE_GROUP:
        this.TimelinePageIndex = this.currentIndex; // call scrollTo
        this.TimelinePageIndex = Constants.INVALID;
        break;
      case Constants.PHOTO_TRANSITION_TIMELINE:
        this.TimelinePageIndex = this.currentIndex; // call scrollTo
        this.TimelinePageIndex = Constants.INVALID;
        break;
      case Constants.PORTRAIT_PHOTO_GRID_PAGE:
      case Constants.PHOTO_TRANSITION_ALBUM:
        this.PhotoGridPageIndex = this.currentIndex; // call scrollTo
        this.PhotoGridPageIndex = Constants.INVALID;

        if (this.isFromFACard) {
          const markNewWantIsNotFromFaCard =
            LocalStorage.getShared().get<boolean>(Constants.KEY_OF_MARK_NEW_WANT_IS_NOT_FROM_FA_CARD);
          Log.warn(TAG,
            `onBackPressInner: is from FA card, minimize or back albumsetpage. newWantIsNotFromFaCard: ${markNewWantIsNotFromFaCard}`);
          if (markNewWantIsNotFromFaCard) {
            this.handleBackToAlbumOrPhotoGridPage();
          } else {
            this.winMinimize();
          }
          return;
        }
        break;
      case Constants.PHOTO_TRANSITION_CAMERA:
        // Entering from the camera does not need to return to close directly
        let context: common.UIAbilityContext =
          LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
        context.terminateSelf();
        return;
      case Constants.PHOTO_TRANSITION_THIRD_APP:
        PhotoBrowserUtils.setViewDataResult(true, this.isFromViewDataWithMediaUri, this.isFromViewDataWithThirdUri);
        return;
      default:
        break;
    }

    // 控制侧边栏是否冻结
    LocalStorage.getShared()?.setOrCreate<boolean>('isOpenBrowser', false);
    if (this.geometryTransitionEnable) {
      let timelineIndex = this.dataSource.getPositionByIndex(this.currentIndex);
      this.onPhotoChanged(this.currentIndex);
      if (this.pageFrom == Constants.ENTRY_FROM.HIGHLIGHT) {
        this.appBroadCast.emit(BroadCastConstants.PHOTO_PHOTO_BACK_PRESS, [this.isLoadLCD, this.mposition]);
      } else {
        this.appBroadCast.emit(BroadCastConstants.PHOTO_PHOTO_BACK_PRESS, []);
      }
      if (this.isVerdeFoldable) {
        // 防止快速进出大图底部菜单栏错误
        this.hideBars();
      } else {
        this.showBars();
      }
      this.browserController.hideBrowser(timelineIndex as number);

      let param: ParamBrowser = this.browserController.browserParam as ParamBrowser;
    } else {
      LocalStorage.getShared()?.setOrCreate<string>('geometryTransitionBrowserId', '');
      LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', -(this.currentIndex + 1));
      this.appBroadCast.emit(BroadCastConstants.PUZZLE_IMAGE_ON_BACK, []);
      AppStorage.get<Router>('router')?.back({
        url: '',
        params: {
          index: this.currentIndex,
        }
      });
    }
  }

  private winMinimize(): void {
    LocalStorage.getShared()?.get<window.Window>('mainWindow')?.minimize().then(() => {
      console.info('Succeeded in minimizing the window.');
    }).catch((err: BusinessError) => {
      console.error(`Failed to minimize the window. Cause code: ${err.code}, message: ${err.message}`);
    });
  }

  updatePhotoName(result: TitleName, uniqueId?: string): void {
    let currentPhoto: MediaItem | undefined = PhotoBrowserUtils.getCurrentPhoto(this.dataSource, this.currentIndex);
    if (currentPhoto) {
      Log.info(TAG, `updatePhotoName result:${
      StringUtil.garbleFileName(result?.title)}, currentPhoto.uniqueId: ${currentPhoto.uniqueId}, uniqueId: ${
      uniqueId}`);
      if (currentPhoto.uniqueId === uniqueId) {
        currentPhoto.setTitle(result.title);
        currentPhoto.displayName = result.displayName;
      }
    }
    this.appBroadCast.emit(BroadCastConstants.UPDATE_IS_FAVOR, [currentPhoto]);
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'photoBrowser aboutToDisappear');
    if (DeviceInfo.isGRLFoldScreen()) {
      FoldUtil.getInstance().unSubscribe(this.foldDataChangeListener);
    }
    AppStorage.delete(Constants.PHOTO_BROWSER_COMPONENT_APPEAR);
    this.isMute = false;
    this.broadCast.emit(BroadCastConstants.HIDE_DELETE_DIALOG, []);
    this.broadCast.emit(BroadCastConstants.HIDE_RENAME_PHOTO_DIALOG, []);
    Log.info(TAG, `aboutToDisappear networkAvailable value: ${this.networkAvailable}`);
    this.statisticRptMgr.end();
    this.favorCacheItemsMap.forEach((item: MediaItem): void => {
      if (item.data) {
        let data: PhotoAsset = item.data as PhotoAsset;
        data.setFavorite(item.isFavor);
      } else {
        Log.error(TAG, 'item.data is not a valid PhotoAsset.');
      }
    });
    this.favorCacheItemsMap.clear();
    lockedScreenMgr().onExit(false, true, TAG);
    if (!this.isShowBar && !this.isHorizontal && !this.isHalfFold) {
      getScreen().setSystemUi(true);
    }
    // Click the thumbnail quickly, hasAppeared is false if it is not the first click. Return directly
    if (!this.hasAppeared) {
      return;
    }
    if (this.subscriber !== undefined) {
      CommonEventManagerAccess.unsubscribe(this.subscriber);
    }
    PhotoBrowserUtils.offSensorOrientation(this.rotateChangeCount);
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.albumBroadCast.off(Constants.ON_LOADING_FINISHED, this.loadFinishedFun);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    this.broadCast.off(PhotoConstants.TOGGLE_BAR, this.onToggleBarsFunc);
    this.broadCast.off(PhotoConstants.SHOW_TOGGLE_BAR, this.showToggleBarsFunc);
    this.broadCast.off(PhotoConstants.HIDE_BARS, this.hideBarsFunc);
    this.broadCast.off(PhotoConstants.SHOW_BARS, this.showBarsFunc);
    this.broadCast.off(PhotoConstants.PULL_DOWN_START, this.pullDownStartFunc);
    this.broadCast.off(PhotoConstants.PULL_DOWN_END, this.pullDownEndFunc);
    this.broadCast.off(PhotoConstants.DATA_SIZE_CHANGED, this.onDataSizeChangedFunc);
    this.broadCast.off(PhotoConstants.DATA_CONTENT_CHANGED, this.onDataContentChangedFunc);
    this.broadCast.off(PhotoConstants.SET_FAVOR, this.setFavorFunc);
    this.broadCast.off(PhotoConstants.RENAME, this.doRenameFunc);
    this.broadCast.off(PhotoConstants.ROTATE, this.doRotateFunc);
    this.broadCast.off(PhotoConstants.PULL_DOWN_START, this.pullDownStartWithEventFunc);
    this.broadCast.off(PhotoConstants.PULL_DOWN_CANCEL, this.pullDownCancelFunc);
    this.broadCast.off(PhotoConstants.PHOTO_BROWSER_DELETE_CONFIRM, this.onPhotoBrowserDeleteConfirmFunc);
    this.broadCast.off(PhotoConstants.PHOTO_BROWSER_REMOVE_CONFIRM, this.onPhotoBrowserRemoveConfirmFunc);
    this.broadCast.off(PhotoConstants.DELETE, this.doDeleteFunc);
    this.broadCast.off(PhotoConstants.PHOTO_SHOW_STATE, this.onPhotoShowStateChangedFunc);
    this.broadCast.off(PhotoConstants.SET_DISABLE_SWIPE, this.setSwiperDisableFunc);
    this.broadCast.off(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, this.onDataReloadWithEditFunc);
    this.broadCast.off(BroadCastConstants.SLIDESHOW_CHANGE_INDEX, this.slideShowChangeIndexFunc);
    this.broadCast.off(BroadCastConstants.MEDIA_OPERATION, this.doMediaOperationFunc);

    this.appBroadCast.off(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT, this.onPhotoBrowserBackPressEventFunc);
    this.navigationBroadCast.off(NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION_BACK,
      this.funcOnMediaOperationBack);
    this.appBroadCast.off(BroadCastConstants.UPDATE_MENU_BEFORE_PLAY_VIDEO, this.updateMenuBeforePlayFunc);
    this.appBroadCast.off(BroadCastConstants.VIDEO_PLAY_COMPLETED, this.videoPlayCompletedFunc);
    this.appBroadCast.off(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, this.videoPlaySwiperIndexChangedFunc);
    this.appBroadCast.off(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, this.initVideoPlayFunc);
    this.appBroadCast.off(BroadCastConstants.UPDATE_MENU_ON_AUDIO_INTERRUPT, this.videoInterruptByOtherAppFunc);
    this.appBroadCast.off(BroadCastConstants.CHANGE_PLAY_BUTTON_STATUS, this.changePlayButtonStatusFunc);
    this.editorController.release();
    this.appBroadCast.off(BrowserConstants.SET_IS_SUPPORTED_VIDEO_TYPE, this.setIsSupportedVideoTypeFunc);
    this.appBroadCast.off(BroadCastConstants.SET_IS_SWITCHING, this.setIsSwitchingFunc);
    this.appBroadCast.off(BroadCastConstants.SET_IS_DOWNLOADING, this.setIsDownloadingFunc);
    this.appBroadCast.off(BroadCastConstants.SET_WAITING_DONE_CALLBACK, this.setWaitingDoneCallbackFunc);
    this.appBroadCast.off(BroadCastConstants.ROUTE_TO_SETTINGS_PAGE, this.routeToSettingsPageFunc);
    this.appBroadCast.off(BroadCastConstants.SHOW_FAST_PLAY_LABEL, this.showOverlayFunc);
    this.appBroadCast.off(BroadCastConstants.EFFECT_MODE_SWITCH_CLICKED, this.onEffectModeSwitchClicked);
    this.appBroadCast.off(BroadCastConstants.QRCODE_UPDATE, this.QRCodeUpdateFunc);
    this.appBroadCast.off(BroadCastConstants.QRCODE_GET_ITEM, this.QRCodeGetItemFunc);
    this.appBroadCast.off(BroadCastConstants.SHOW_CONVERT_LOADING_PANEL, this.convertJpgTimeoutFunc);
    this.dataSource.release();
    this.thumbSource.release();
    this.broadCast.release();
    if (this.subscriber !== undefined) {
      CommonEventManagerAccess.unsubscribe(this.subscriber);
    }

    if (this.isFromFACard) {
      Log.info(TAG, `appBroadCast.off(BroadCastConstants.UPDATE_FA_CARD_URI)`)
      this.appBroadCast.off(BroadCastConstants.UPDATE_FA_CARD_URI, this.updateCurrentByFormCurrentUriFunc);
      LocalStorage.getShared()?.delete('key_image_editor_project');
    }
    LocalStorage.getShared()?.delete('is_from_sub_screen');
  }

  getAlbumUriByUri(albumUri: string): string {
    if (albumUri?.length > 0) {
      return albumUri;
    }
    return '';
  }

  private initialFromFaCard(): void {
    if (!this.isFromFACard) {
      return;
    }
    if (this.isFromFormPortrait) {
      AppStorage.setOrCreate<string>(Constants.PHOTO_BROWSER_COMPONENT_APPEAR, AppStorage.get<string>(Constants.KEY_OF_REFRESH_FA_CARD_ID));
    }
    LocalStorage.getShared()?.delete('key_image_editor_project');
    const albumUri: string | undefined = AppStorage.get<string>('form_albumUri');
    this.dataSource = new PhotoDataSource(this.stateMachine);
    this.dataSource.enableGetData(false);
    if (albumUri) {
      this.dataSource.setAlbumUri(albumUri);
    }
    this.dataSource.initData();
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.uriFromThirdPartyApp = AppStorage.get<string>('form_currentUri') ?? Constants.NULL_STRING;
    Log.info(TAG, `isFromFACard : ${this.isFromFACard} ${this.currentIndex},` +
      ` isFromFormPortrait ${this.isFromFormPortrait}`);
    this.dataSource.getItemIndexByUri(
      this.uriFromThirdPartyApp,
      (index: number): void => this.onGetItemIndexByUri(index), true);
    this.thumbSource.setPhotoDataSource(this.dataSource);
    if (albumUri) {
      this.initialAlbumInfoByUri(albumUri);
    }
    this.albumUri = albumUri || UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);
    this.pageFrom = Constants.ENTRY_FROM.CARD;
    this.isFromCamera = true;
    this.jumpSourceToMain = JumpSourceToMain.CAMERA;
    this.geometryTransitionEnable = true;
    this.isFirstInSwiperFromCard = true;
    this.mTransition = Constants.PHOTO_TRANSITION_ALBUM;
    // 防止打开为空自定义相册时,先显示actionBar再跳转到相册宫格页产生。
    LocalStorage.getShared()?.setOrCreate(Constants.KEY_OF_IS_BLACK_BG, false);
    // 进入大图浏览页面重新设置相册页面不显示.
    AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_OPACITY, 0);
    AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_ACTIONBAR_OPACITY, 0);
    Log.info(TAG, `appBroadCast.on(BroadCastConstants.UPDATE_FA_CARD_URI)`);
    this.appBroadCast.on(BroadCastConstants.UPDATE_FA_CARD_URI, this.updateCurrentByFormCurrentUriFunc);
    let albumDataSource = this.dataSource.getAlbumDataSource();
    if (albumDataSource) {
      AppStorage.setOrCreate(Constants.APP_KEY_PHOTO_BROWSER, albumDataSource);
    }
  }

  aboutToAppear(): void {
    Log.info(TAG, 'photoBrowser aboutToAppear');
    this.initialFromFaCard();
    this.targetIndex = this.currentIndex;
    this.stateMachine.setCurrentIndex(this.currentIndex);
    this.downloadProgress = 0;
    this.enableDisplayDefaultImage = false;
    TraceControllerUtils.startTrace('PhotoBrowserAboutToAppear');
    // 获取进入大图页时是否为横屏，以及确切的屏幕朝向
    this.isHorizontalAtAppear = this.isHorizontal;
    this.originOrientation = 0;
    if (!DeviceInfo.isVerdeFoldable()) {
      try {
        this.originOrientation = display.getDefaultDisplaySync().orientation;
      } catch (error) {
        Log.error(TAG, `getDefaultDisplaySync failed, error: ${error}, code: ${error?.code}`);
      }
    }
    Log.info(TAG, `display orientation: ${this.originOrientation}`);
    AppStorage.setOrCreate<number>('originOrientation', this.originOrientation);
    /* instrument ignore next */
    if (DeviceInfo.isGRLFoldScreen()) {
      FoldUtil.getInstance().subscribe(this.foldDataChangeListener);
    }
    this.statisticRptMgr.init();
    this.needUnlock = false;
    this.appBroadCast.on(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, this.initVideoPlayFunc);
    this.albumBroadCast.on(Constants.ON_LOADING_FINISHED, this.loadFinishedFun);
    AppStorage.setOrCreate<boolean>('isDoingDeleteBigPhotoAnim', false);
    getScreen().updateSize();
    Log.info(TAG, `aboutToAppear networkAvailable value: ${this.networkAvailable}`);
    // 非通过showbrowser的animateto拉起方式
    if (!this.browserController.isAnimating) {
      this.browserController.isBrowserShowContent = true;
      Log.info(TAG, 'call show browser non-image content');
    }
    WindowUtil.prepareWinRouter();
    this.geometryTransitionId = LocalStorage.getShared()?.get<string>('geometryTransitionBrowserId') ?? '';
    this.hasAppeared = true;
    this.updateIsHorizontal();
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
    if (this.isVerdeFoldable) {
      setHorizontal(false);
    }
    /* instrument ignore next */
    if (DeviceInfo.isSmallFoldScreen()) {
      this.foldStatusChange();
    }
    this.editorController.init(this.broadCast, window.Orientation.AUTO_ROTATION_UNSPECIFIED);
    if (!this.isFromFACard) {
      this.browserComponentParseParams();
    }
    this.checkedTransition = this.mTransition;
    if (this.mTransition && this.mTransition?.endsWith('ERROR')) {
      this.checkedTransition = this.mTransition.substr(0, this.mTransition.length - 5);
    }
    LocalStorage.getShared()?.setOrCreate<number>('geometryOpacity', 1);
    this.dataSource.setBroadCast(this.broadCast);
    this.dataSource.setBroadCastToAlbum(this.broadCast);
    this.targetItem = this.getPhotoByIndex(this.targetIndex);
    // register event handling
    this.navigationBroadCast.on(NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION_BACK,
      this.funcOnMediaOperationBack);
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    this.broadCast.on(PhotoConstants.TOGGLE_BAR, this.onToggleBarsFunc);
    this.broadCast.on(PhotoConstants.SHOW_TOGGLE_BAR, this.showToggleBarsFunc);
    this.broadCast.on(PhotoConstants.HIDE_BARS, this.hideBarsFunc);
    this.broadCast.on(PhotoConstants.SHOW_BARS, this.showBarsFunc);
    this.broadCast.on(PhotoConstants.PULL_DOWN_START, this.pullDownStartFunc);
    this.broadCast.on(PhotoConstants.PULL_DOWN_END, this.pullDownEndFunc);
    this.broadCast.on(PhotoConstants.DATA_SIZE_CHANGED, this.onDataSizeChangedFunc);
    this.broadCast.on(PhotoConstants.DATA_CONTENT_CHANGED, this.onDataContentChangedFunc);
    this.broadCast.on(PhotoConstants.SET_FAVOR, this.setFavorFunc);
    this.broadCast.on(PhotoConstants.RENAME, this.doRenameFunc);
    this.broadCast.on(PhotoConstants.ROTATE, this.doRotateFunc);
    this.broadCast.on(PhotoConstants.PULL_DOWN_START, this.pullDownStartWithEventFunc);
    this.broadCast.on(PhotoConstants.PULL_DOWN_CANCEL, this.pullDownCancelFunc);
    this.broadCast.on(PhotoConstants.PHOTO_BROWSER_DELETE_CONFIRM, this.onPhotoBrowserDeleteConfirmFunc);
    this.broadCast.on(PhotoConstants.PHOTO_BROWSER_REMOVE_CONFIRM, this.onPhotoBrowserRemoveConfirmFunc);
    this.broadCast.on(PhotoConstants.DELETE, this.doDeleteFunc);
    this.broadCast.on(PhotoConstants.PHOTO_SHOW_STATE, this.onPhotoShowStateChangedFunc);
    this.broadCast.on(PhotoConstants.SET_DISABLE_SWIPE, this.setSwiperDisableFunc);
    this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, this.onDataReloadWithEditFunc);
    this.broadCast.on(BroadCastConstants.MEDIA_OPERATION, this.doMediaOperationFunc);
    this.broadCast.on(BroadCastConstants.SLIDESHOW_CHANGE_INDEX, this.slideShowChangeIndexFunc);
    this.appBroadCast.on(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT, this.onPhotoBrowserBackPressEventFunc);
    this.appBroadCast.on(BroadCastConstants.UPDATE_MENU_BEFORE_PLAY_VIDEO, this.updateMenuBeforePlayFunc);
    this.appBroadCast.on(BroadCastConstants.VIDEO_PLAY_COMPLETED, this.videoPlayCompletedFunc);
    this.appBroadCast.on(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, this.videoPlaySwiperIndexChangedFunc);
    this.appBroadCast.on(BroadCastConstants.UPDATE_MENU_ON_AUDIO_INTERRUPT, this.videoInterruptByOtherAppFunc);
    this.appBroadCast.on(BroadCastConstants.CHANGE_PLAY_BUTTON_STATUS, this.changePlayButtonStatusFunc);
    this.appBroadCast.on(BrowserConstants.SET_IS_SUPPORTED_VIDEO_TYPE, this.setIsSupportedVideoTypeFunc);
    this.appBroadCast.on(BroadCastConstants.SET_IS_SWITCHING, this.setIsSwitchingFunc);
    this.appBroadCast.on(BroadCastConstants.SET_IS_DOWNLOADING, this.setIsDownloadingFunc);
    this.appBroadCast.on(BroadCastConstants.SET_WAITING_DONE_CALLBACK, this.setWaitingDoneCallbackFunc);
    this.appBroadCast.on(BroadCastConstants.ROUTE_TO_SETTINGS_PAGE, this.routeToSettingsPageFunc);
    this.appBroadCast.on(BroadCastConstants.SHOW_FAST_PLAY_LABEL, this.showOverlayFunc);
    this.appBroadCast.on(BroadCastConstants.EFFECT_MODE_SWITCH_CLICKED, this.onEffectModeSwitchClicked);
    this.appBroadCast.on(BroadCastConstants.QRCODE_UPDATE, this.QRCodeUpdateFunc);
    this.appBroadCast.on(BroadCastConstants.QRCODE_GET_ITEM, this.QRCodeGetItemFunc);
    this.appBroadCast.on(BroadCastConstants.SHOW_CONVERT_LOADING_PANEL, this.convertJpgTimeoutFunc);

    interface MsgNavigation {
      from: string;
      fovMode: number;
    }

    let msg: MsgNavigation = {
      from: BigDataConstants.LOCAL_MEDIA,
      fovMode: 0,
    }
    ReportToBigDataUtil.report(BigDataConstants.ENTER_PHOTO_BROWSER_ID, msg);
    TraceControllerUtils.finishTrace('PhotoBrowserAboutToAppear');
    this.actionPortraitBarProp = PhotoBrowserUtils.createActionBar();
    if (this.isFromPortraitCoverSet) {
      getScreen().setImmersiveStatusBarProperties();
    }
    if (!DeviceInfo.isPcOrTablet()) {
      this.actionBarPaddingTop = px2vp(this.statusBarHeight);
    } else {
      this.actionBarPaddingTop = $r('app.float.album_set_page_action_bar_padding_top');
    }

    /* instrument ignore next */
    if (DeviceInfo.isSmallFoldScreen()) {
      let isDeleted = AppStorage.get<boolean>('is_deleting');
      Log.info(TAG, `isDeleted = ${isDeleted}`);
      if (isDeleted) {
        AppStorage.setOrCreate<boolean>('is_deleting', false);
        const photoBrowserTimer = setTimeout(async () => {
          this.onMenuClicked(Action.DELETE);
          clearTimeout(photoBrowserTimer);
        }, Constants.DELAY_HALF_SECOND);
      }
      let videoPlayProgress = AppStorage.get<number>('video_play_progress');
      Log.info(TAG, `videoPlayProgress = ${videoPlayProgress}`);
      if (videoPlayProgress && videoPlayProgress != 0) {
        AppStorage.setOrCreate<number>('video_play_progress', 0);
        const videoPlayTimer = setTimeout(async () => {
          this.appBroadCast.emit(BrowserConstants.CONTINUE_PLAY_FROM_SUB_SCREEN, [videoPlayProgress]);
          clearTimeout(videoPlayTimer);
        }, Constants.DELAY_HALF_SECOND);
      }
    }

    if (this.currentIndex === 0) {
      this.isSupportImageEditorReport();
    }
    //从门店体验、演示app跳转过来需直接进入AI修图(为了统一处理大图均认为来自VIEW_DATA)
    const isEntryAiEdit: boolean = AppStorage.get<boolean>(Constants.PHOTO_DIRECTLY_ENTER_AI_EDITING) ?? false;
    const isEntryXTStyle: boolean = AppStorage.get<boolean>(Constants.PHOTO_DIRECTLY_ENTER_XTSTYLE) ?? false;
    Log.info(TAG,
      `aboutToAppear: isEntryAiEdit: ${isEntryAiEdit} ,isEntryXTStyle:${isEntryXTStyle} pageFrom: ${this.pageFrom}`);
    if ((isEntryAiEdit || isEntryXTStyle) && this.pageFrom === Constants.ENTRY_FROM.VIEW_DATA) {
      setTimeout((): void => {
        Log.info(TAG, 'page from ENTRY_FROM_PROTOTYPE_EXPERIENCE_APP, cast Delay 300ms');
        this.onEditClicked();
      }, Constants.DELAY_THREE_HUNDRED_MILLISECOND);
    }
    if (this.isVerdeFoldable) {
      this.onToggleBars();
    }
    this.isPhotoActive = true;
    // photoBrwoserComponet加载时，强制状态机到Stable状态
    this.stateMachine.processEnterAnimationStartEvent();
    this.stateMachine.processEnterAnimationEndEvent();
    Log.info(TAG, 'photoBrowser aboutToAppear end');
  }

  initialAlbumInfoByUri(albumUri?: string): void {
    Log.info(TAG, `initialAlbumInfoByUri`);
    this.albumInfo = undefined;
    UserFileManagerAccess.getInstance().getAlbumByUri(albumUri).then((photoAlbum?: PhotoAlbum) => {
      if (photoAlbum) {
        this.albumInfo = new AlbumInfo(photoAlbum);
      }
      Log.info(TAG, `initialAlbumInfoByUri albumUri ${albumUri} isSourceAlbum ${this.albumInfo?.isSourceAlbum}`);
    })
  }

  browserComponentParseParams() {
    let param: ParamBrowser = this.browserController.browserParam as ParamBrowser;
    if (param) {
      Log.debug(TAG, `param: ${JSON.stringify(param)}`);
      if (param.pageFrom) {
        this.pageFrom = param.pageFrom;
      }
      this.isLoadLCD = param.isLoadLCD;
      this.mposition = param.position;
      if (param.albumInfo) {
        this.albumInfo = param.albumInfo;
        this.albumUri = param.albumInfo.uri;
        this.deviceName = param.deviceName;
      }
      if (param.album) {
        this.photoAlbum = param.album;
      }
      if (param.broadCast) {
        this.highlightBroadCast = param.broadCast;
      }
      if (this.pageFrom === Constants.ENTRY_FROM.HIDDEN) {
        this.dataSource.setAlbumUri(this.albumUri);
      }
      Log.info(TAG, `photoBrowser start with param : ${this.pageFrom}`);
      if (this.pageFrom == Constants.ENTRY_FROM.CAMERA) {
        this.dataSource = new PhotoDataSource(this.stateMachine);
        this.dataSource.initData();
        this.isFromCamera = true;
        this.clickThumbnailTime = param.clickThumbnailTime ? param.clickThumbnailTime : 0;
        this.albumUri = '';
        this.jumpSourceToMain = JumpSourceToMain.CAMERA;
        MediaObserver.getInstance().registerObserver(this.dataObserver);
        AppStorage.setOrCreate('entryFromHap', Constants.ENTRY_FROM_NONE);
      } else if (this.pageFrom == Constants.ENTRY_FROM.RECYCLE) {
        this.dataSource.setAlbumUri(this.albumUri);
        this.dataSource.setAlbumDataSource(AppStorage.get<MediaDataSource>(Constants.APP_KEY_PHOTO_BROWSER));
        this.thumbSource.setPhotoDataSource(this.dataSource);
      } else if (this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED) {
        this.dataSource.setDeviceId(param.deviceId);
        this.dataSource.setAlbumDataSource(AppStorage.get<MediaDataSource>(Constants.APP_KEY_PHOTO_BROWSER));
      } else if (this.pageFrom == Constants.ENTRY_FROM.VIEW_DATA) {
        this.dealViewDataAction(param);
        this.thumbSource.setPhotoDataSource(this.dataSource);
      } else if (this.pageFrom == Constants.ENTRY_FROM.PETALCLIP_VIDEO) {
        this.albumUri = UserFileManagerAccess.getInstance()
          .getSystemAlbumUri(UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE);
        this.dataSource = new PhotoDataSource(this.stateMachine, this.albumUri);
        this.dataSource.initData();
        this.isFromPetalClip = true;
        this.jumpSourceToMain = JumpSourceToMain.PETALCLIP_VIDEO;
        MediaObserver.getInstance().registerObserver(this.dataObserver);

        // Set entryFromHap into Constants.ENTRY_FROM_NONE, avoiding router twice
        AppStorage.setOrCreate('entryFromHap', Constants.ENTRY_FROM_NONE);
      } else if (this.pageFrom === Constants.ENTRY_FROM.PUZZLE) {
        this.dataSource = new PhotoDataSource(this.stateMachine);
        this.dataSource.initData();
        this.thumbSource.setPhotoDataSource(this.dataSource);
        MediaObserver.getInstance().registerObserver(this.dataObserver);
      } else {
        MediaObserver.getInstance().registerObserver(this.dataObserver);
        this.dataSource.setAlbumDataSource(AppStorage.get<MediaDataSource>(Constants.APP_KEY_PHOTO_BROWSER));
        this.thumbSource.setPhotoDataSource(this.dataSource);
      }
      this.dataSource.setBroadCast(this.broadCast);
      this.currentUri = param.uri;
      Log.info(TAG, `set this.currentUri: ${this.currentUri}`);
      this.onPhotoChanged(param.position || 0);
      if (this.isFromCamera) {
        this.mTransition = Constants.PHOTO_TRANSITION_CAMERA;
      } else if (this.isFromViewDataWithMediaUri || this.isFromViewDataWithThirdUri) {
        this.mTransition = Constants.PHOTO_TRANSITION_THIRD_APP;
      } else if (this.isFromPetalClip) {
        this.mTransition = Constants.PHOTO_TRANSITION_PETALCLIP;
      } else {
        this.mTransition = param.transition;
      }
    } else {
      Log.info(TAG, 'photoBrowser start without param');
      this.pageFrom = Constants.ENTRY_FROM.CAMERA;
      this.albumUri = UserFileManagerAccess.getInstance()
        .getSystemAlbumUri(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);
      AppStorage.setOrCreate('entryFromHap', Constants.ENTRY_FROM_NONE);
      let albumDataSource: MediaDataSource | undefined =
        AppStorage.get<MediaDataSource>(Constants.APP_KEY_PHOTO_BROWSER);
      if (albumDataSource) {
        this.dataSource.setAlbumDataSource(albumDataSource);
        this.thumbSource.setPhotoDataSource(this.dataSource);
      } else {
        Log.error(TAG, 'Constants.APP_KEY_PHOTO_BROWSER is null, so use all album instead');
        this.dataSource.initData();
        this.thumbSource.setPhotoDataSource(this.dataSource);
      }
      this.isFromCamera = true;
      this.jumpSourceToMain = JumpSourceToMain.CAMERA;
      MediaObserver.getInstance().registerObserver(this.dataObserver);
      this.onPhotoChanged(AppStorage.get('form_currentIndex') || 0);
      this.mTransition = Constants.PHOTO_TRANSITION_CAMERA;
    }
  }

  private dealViewDataAction(param: ParamBrowser): void {
    if (String(param.viewData).length === 0) {
      Log.error(TAG, 'Invalid uri');
      PhotoBrowserUtils.setViewDataResult(false, this.isFromViewDataWithMediaUri, this.isFromViewDataWithThirdUri);
      return;
    }
    Log.info(TAG, `Found viewIndex: ${String(param.viewDataIndex).length}`);
    let isAllMediaData: boolean = param.isAllMediaData;
    if (String(param.viewDataIndex).length > 0 || isAllMediaData) {
      Log.info(TAG, 'Found viewIndex');
      this.dataSource = new UriDataSource(this.stateMachine, String(param.viewData)
        .split('?'), UserFileManagerAccess.MEDIA_TYPE_IMAGE, undefined, undefined, isAllMediaData);
      let viewIndex = Number.parseInt(param.viewDataIndex);
      if (Number.isNaN(viewIndex) || viewIndex <= 0 || viewIndex > String(param.viewData).split('?').length) {
        viewIndex = 0;
      } else {
        viewIndex -= 1;
      }
      if (isAllMediaData) {
        MediaObserver.getInstance().registerObserver(this.dataObserver);
      }
      this.isFromViewDataWithThirdUri = true;
      this.isForceShowBar = isAllMediaData;
      this.currentIndex = viewIndex;
      param.position = viewIndex;
    } else {
      if (!param.viewData || String(param.viewData).length === 0) {
        return;
      }
      if (MediaLibraryData.isMediaLibraryUri(String(param.viewData))) {
        this.dealSingleMediaUri(param);
      } else {
        Log.info(TAG, 'Not found media library uri');
        this.dataSource = new UriDataSource(this.stateMachine, [String(param.viewData)],
          param.viewDataType,
          param.imageArea ? param.imageArea.width : 0,
          param.imageArea ? param.imageArea.height : 0);
        this.isFromViewDataWithThirdUri = true;
      }
    }
  }

  private dealSingleMediaUri(param: ParamBrowser): void {
    Log.debug(TAG, 'Found media library uri');
    this.dataSource = new PhotoDataSource(this.stateMachine, this.albumUri);
    this.albumUri = this.getAlbumUriByUri(param.viewDataAlbum);
    Log.info(TAG, `album id: ${this.albumUri}`);
    this.dataSource.enableGetData(false);
    this.isFromViewDataWithMediaUri = true;
    this.clickThumbnailTime = 0;
    this.isFromViewData = true;
    this.jumpSourceToMain = JumpSourceToMain.CAMERA;
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.uriFromThirdPartyApp = String(param.viewData);
    this.currentIndex = 0;
    let callerBundleName: string = AppStorage.get<string>('callerBundleName') ?? '';
    if (!this.albumUri && callerBundleName === 'com.ohos.camera') {
      UserFileManagerAccess.getInstance().getSourceAlbumByCamera()
        .then((albumInfo: AlbumInfo | undefined) => {
          this.albumUri = albumInfo?.uri ?? '';
          if (!this.albumUri) {
            this.albumUri = UserFileManagerAccess.getInstance()
              .getSystemAlbumUri(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);
          }
          this.dataSource.setAlbumUri(this.albumUri);
          this.dataSource.initData();
          this.thumbSource.setPhotoDataSource(this.dataSource);
          this.dataSource.getItemIndexByUri(
            this.uriFromThirdPartyApp,
            (index: number): void => this.onGetItemIndexByUri(index));
        });
    } else {
      this.dataSource.setAlbumUri(this.albumUri);
      this.dataSource.initData();
      this.thumbSource.setPhotoDataSource(this.dataSource);
      this.dataSource.getItemIndexByUri(
        this.uriFromThirdPartyApp,
        (index: number): void => this.onGetItemIndexByUri(index));
    }
    // 是否显示菜单栏并且处理大数据打点
    this.isShowMenuBigData(param.isShowMenuFromThirdView);
  }

  onGetItemIndexByUri(index: number, inLoopCount = 3): void {
    Log.info(TAG, `onGetItemIndexByUri: index=${index} this.currentIndex = ${this.currentIndex}` +
      ` this.uriFromThirdPartyApp = ${this.uriFromThirdPartyApp}`);
    if (this.isFromFACard) {
      if (inLoopCount < 1) {
        if (!this.dataSource.totalCount() || index < 0) {
          // 相册没有图片时,此处重置为0,防止 -1 无限循环导致白屏
          // 如果相册存在图片,但是当前index 找不到,重置为0
          index = 0;
          Log.info(TAG,
            'Uri from FA is invalid and the query exceeds the limit 3. Reset to default picture. dataSource count:' +
            this.dataSource.realTotalCount());
          if (this.dataSource.realTotalCount() > 0) {
            UiUtil.showToast($r('app.string.photo_invalid_uri_from_faCard'));
          }
          this.appBroadCast.emit(BroadCastConstants.COMP_LOAD_COMPLETED, []);
          const context: common.UIAbilityContext =
            LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
          const formId = AppStorage.get<string>(Constants.KEY_OF_REFRESH_FA_CARD_ID);
          if (context && formId) {
            FormControllerManager.getInstance(context).doTask({ formId, taskUri: TaskUri.TASK_REFRESH_FACARD });
          }
        }
      }
    }
    this.fromCardCurrentIndex = index;
    if (this.uriFromThirdPartyApp) {
      if (index != Constants.NOT_FOUND) {
        this.currentIndex = index;
        this.uriFromThirdPartyApp = '';
        this.dataSource.enableGetData(true);
        this.dataSource.getData(this.currentIndex);
        this.dataSource.onDataReloaded();
        Log.info(TAG, `Found: ${this.currentIndex}, ${this.albumUri}`);
      } else {
        if (UserFileManagerAccess.isRecycleBin(this.albumUri)) {
          if (this.isFromViewDataWithMediaUri || this.isFromViewDataWithThirdUri) {
            Log.error(TAG, 'Uri from third party app is invalid');
          } else if (this.isFromFACard) {
            Log.error(TAG, 'Uri from FA is invalid');
          } else {
            Log.error(TAG, 'Uri from others is invalid');
          }
          this.uriFromThirdPartyApp = '';
          this.dataSource.enableGetData(true);
          PhotoBrowserUtils.setViewDataResult(false, this.isFromViewDataWithMediaUri, this.isFromViewDataWithThirdUri);
        } else if (this.albumUri === '') {
          this.resetAlbum(UserFileManagerAccess.getRecycleBinUri());
          this.dataSource.getItemIndexByUri(
            this.uriFromThirdPartyApp,
            (index: number): void => this.onGetItemIndexByUri(index, --inLoopCount));
        } else {
          this.resetAlbum('');
          this.dataSource.getItemIndexByUri(
            this.uriFromThirdPartyApp,
            (index: number): void => this.onGetItemIndexByUri(index, --inLoopCount));
        }
      }
      this.onPhotoChanged(this.currentIndex);
    }
  }

  onGetItemIndexByNewEditUri(index: number): void {
    Log.info(TAG, `onGetItemIndexByNewEditUri: index=${index}`);
    if (this.editNewUri.length > 0) {
      if (index != Constants.NOT_FOUND) {
        Log.info(TAG, `data reloaded move to ${index}`);
        this.currentIndex = index;
        if (this.checkedTransition == Constants.PHOTO_TRANSITION_TIMELINE) {
          this.TimelinePageIndex = this.currentIndex; // call scrollTo
          this.TimelinePageIndex = Constants.INVALID;
        } else if (this.checkedTransition == Constants.PHOTO_TRANSITION_ALBUM) {
          this.PhotoGridPageIndex = this.currentIndex; // call scrollTo
          this.PhotoGridPageIndex = Constants.INVALID;
        }
        this.dataSource.enableGetData(true);
        this.dataSource.getData(this.currentIndex);
        this.dataSource.onDataReloaded();
        this.editNewUri = '';
      } else {
        Log.error(TAG, `edit new uri ${this.editNewUri} is invalid`);
        this.editNewUri = '';
        this.currentIndex = 0;
        this.dataSource.enableGetData(true);
        this.dataSource.getData(this.currentIndex);
        this.dataSource.onDataReloaded();
        this.broadCast.emit(BroadCastConstants.EDIT_PHOTO_LOAD_FAILED, []);
      }
      this.onPhotoChanged(this.currentIndex);
    }
  }

  onPageShow(): void {
    /* instrument ignore next */
    if (DeviceInfo.isSmallFoldScreen() && !this.isHalfFold) {
      this.actionBarPositionY = Constants.PERCENT_0;
    }
    if (!this.editorController.isEditorShown) {
      this.isPhotoActive = true;
    }
    TraceControllerUtils.startTrace('PhotoBrowser onPageShow');
    Log.info(TAG, 'photoBrowser page show isFromLockedScreen:' + lockedScreenMgr().isFromLockedScreen);
    if ((DeviceInfo.isPhoneUx() && !FoldUtil.isTriExpand(this.curFoldStatus))) {
      Log.info(TAG, 'update card detail width');
      this.appBroadCast.emit(PhotoConstants.UPDATE_CARD_WIDTH, []);
    }
    if (!this.editorController.isEditorShown && !AppStorage.get<boolean>('isEditingWallpaper')) {
      let orientation = window.Orientation.AUTO_ROTATION_UNSPECIFIED;
      if (lockedScreenMgr().isFromLockedScreen) {
        orientation = window.Orientation.UNSPECIFIED;
      }
      WindowUtil.setOrientation(orientation);
    }
    if (this.isPullingUp) {
      this.hideBars($r('sys.color.background_secondary'));
    } else if (!this.isHorizontal && this.isShowBar && !this.isHalfFold &&
      !AppStorage.get<boolean>('isEditingWallpaper')) {
      getScreen().setSystemUi(true);
    }
    let currentPhoto: MediaItem | undefined = PhotoBrowserUtils.getCurrentPhoto(this.dataSource, this.currentIndex);
    if (currentPhoto) {
      this.syncPhotoName(currentPhoto).then((result: TitleName) => {
        if (result) {
          this.updatePhotoName(result);
          this.broadCast.emit(PhotoConstants.UPDATE_PHOTO_NAME + currentPhoto?.path, [result?.title]);
        }
      });
    }
    this.updateActionBar(this.currentIndex);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.checkedTransition]);
    this.broadCast.emit(BroadCastConstants.CHANGE_SWIPER_DURATION, [400]);
    this.broadCast.emit(Constants.ON_PAGE_SHOW, []);
    this.viewTime = Date.now();
    this.backFromCopy = false;
    TraceControllerUtils.finishTrace('PhotoBrowser onPageShow');
    if (this.pageFrom === Constants.ENTRY_FROM.HIDDEN) {
      this.needUnlock = true;
      this.vanishingState = true;
    }
  }

  onListeningStatus() {
    Log.info(TAG, `vanishingState${JSON.stringify(this.vanishingState)}`);
    this.needUnlock = this.vanishingState;
  }

  onPageHide(): void {
    this.isPhotoActive = false;
    /* instrument ignore next */
    if (DeviceInfo.isVerdeFoldable() && AppStorage.get<boolean>('isEditingWallpaper')) {
      Log.info(TAG, 'verde fold exit wallPaper');
      this.navigationPageInfos.pop();
    }
    Log.info(TAG, 'call onPageHide' + lockedScreenMgr().isFromLockedScreen);
    lockedScreenMgr().onExit(true, true, TAG, 'onPageHide');
    if (!this.isFromFACard) {
      this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.checkedTransition]);
    }
    LocalStorage.getShared()?.setOrCreate<boolean>('isPullingUpSwiper', this.isPullingUp); // 退出大图页时，将状态复位
  }

  onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    Log.info(TAG, `onMediaLibDataNfy nfyInfo: ${JSON.stringify(nfyInfo)}`);
    this.dataSource.onNotify(nfyInfo);
    if (nfyInfo.type === MediaObserverNfyType.PHOTO_ADD) {
      Log.debug(TAG, `new photo is added, uri is ${nfyInfo.uris.toString()}`);
      if (nfyInfo.uris[0] === Heic2JPGManagerAccess.addedResUri) {
        this.onHeic2JPGCompleted(nfyInfo);
      }
    } else if (nfyInfo.type === MediaObserverNfyType.PHOTO_UPDATE) {
      this.updatePixMapDataSource();
    }
  }

  private async onHeic2JPGCompleted(nfyInfo: MediaObserverNfyInfo): Promise<void> {
    let addedResUri = nfyInfo.uris[0];
    let displayName = nfyInfo.uris[0].toString().split('/').pop()?.toString();
    Log.info(TAG, `onHeic2JPGCompleted ${displayName} ${addedResUri}`);
    if (this.showLoadingTimerId) {
      clearTimeout(this.showLoadingTimerId);
      this.showLoadingTimerId = undefined;
    }
    this.appBroadCast.emit(BroadCastConstants.SHOW_CONVERT_LOADING_PANEL, [false]);
    let currentPhoto = this.getPhotoByIndex(this.currentIndex);
    if (!currentPhoto) {
      Log.info(TAG, `onHeic2JPGCompleted null ${displayName} ${addedResUri}`);
      return;
    }
    let waitCount = 0;
    let targetItem = await this.dataSource.getDataByUri(addedResUri);
    Log.info(TAG, `onHeic2JPGCompleted targetItem ${targetItem.uri}`);
    Heic2JPGManagerAccess.isDirtyToJPG = false;
    setTimeout((): void => {
      this.jump2JPG(addedResUri, displayName || '', waitCount);
    }, DELAY_TIME)
  }

  private async jump2JPG(addedResUri: string, displayName: string, waitedCount: number): Promise<void> {
    let newIndex = this.dataSource.getDataIndexByUri(addedResUri);
    Log.info(TAG, `jump2JPG ${displayName} ${addedResUri} ${newIndex}`);
    if (waitedCount === Heic2JPGManagerAccess.MAX_WAIT_TIME) {
      return;
    }
    if (newIndex === Constants.NOT_FOUND) {
      setTimeout((): void => {
        Log.debug(TAG, `wait count ${++waitedCount}`)
        this.jump2JPG(addedResUri, displayName, waitedCount);
      }, DELAY_TIME_CONVERT);
    } else {
      let currentPhoto = this.getPhotoByIndex(this.currentIndex);
      if (!currentPhoto) {
        Log.info(TAG, `jump2JPG currentPhoto ${currentPhoto} ${this.currentIndex}`);
        return;
      }
      this.stateMachine.processHeic2JPGEvent(newIndex, Math.abs(this.currentIndex - newIndex) < 10, this.controller);
    }
  }

  private getBrowserMarginBottom(): number {
    Log.info(TAG, `bottom: ${this.diggingHoleCameraArea.bottom}`);
    return (!DeviceInfo.isFoldablePhone() && !DeviceInfo.isGRLFoldScreen()) ?
      (this.diggingHoleCameraArea.bottom ?? 0) : 0;
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    this.dataSource.onChange(changeType);
  }

  @Builder
  buildImageEditorMain() {
    ImageEditorMain({
      params: this.editorController.imageEditorParams,
      status: this.editorController.imageEditorStatus,
      onMessageCallback: (msg: ImageEditorMsg) => {
        Log.info(TAG, 'onMessageCallback ImageEditorMain');
        return this.editorController.onEditorMessageCallback(msg);
      }
    })
  }

  @Builder
  buildPhotoBrowserComponent() {
    Stack({ alignContent: Alignment.TopStart }) {
      PhotoBrowserComponentBg({
        isShowBar: $isShowBar,
        isFromPhotoBrowser: true,
        avoidOverdrawPadding: this.editorController.isInSwitchAnimation ? this.getBgPadding() : null,
        isFromPortraitCoverSet: this.isFromPortraitCoverSet,
      })
        .opacity(this.geometryOpacity)
        .transition(TransitionEffect.asymmetric(
          PhotoConstants.OPEN_EFFECT,
            this.browserController.isDrag ? TransitionEffect.opacity(0) : PhotoConstants.CLOSE_EFFECT
        ))
        .enabled(!this.isPullDownAndDragPhoto && !this.browserController.isAnimating)

      if (this.enableDisplayDefaultImage) {
        Image('resources/pic/album_card_default_pic.png')
          .objectFit(ImageFit.Contain)
          .autoResize(false)
          .alt($r('app.media.form_default_bg'))
      }

      PhotoSwiper({
        stateMachine: this.stateMachine,
        dataSource: this.dataSource,
        mTransition: this.mTransition,
        swiperController: this.controller,
        onPhotoChanged: (index: number): void => this.onPhotoChanged(index),
        onDataPrepare: (index: number): void => this.onDataPrepare(index),
        onIndexChanged: (index: number, updateSource: boolean = true): void => this.onIndexChange(index, updateSource),
        updatePixMapDataSource: (): void => this.updatePixMapDataSource(),
        canPullingUp: true,
        geometryTransitionEnable: this.geometryTransitionEnable,
        broadCast: $broadCast,
        isRunningAnimation: $isRunningAnimation,
        isFromFACard: this.isFromFACard,
        isPullDownAndDragPhoto: $isPullDownAndDragPhoto,
        thumbSource: this.thumbSource,
        isShowBar: $isShowBar,
        forceRefresh: this.forceRefresh,
        isEditorShown: this.editorController.isEditorShown,
        isFromPortraitCoverSet: this.isFromPortraitCoverSet,
        browserController: this.browserController,
        isSlideBarShow: $isSlideBarShow,
        isVideoPlaying: this.isVideoPlaying,
        swiperOpacityWithBurstPhotos: this.swiperOpacityWithBurstPhotos,
        previewItemOpacity: this.toolBarOpacityWithBurstPhotos,
        centerPreviewOpacity: this.centerPreviewOpacityWithBurst,
        isFromViewData: this.isFromViewData,
        albumInfo: this.albumInfo,
        pcCurItem: this.pcCurItem,
        currentUri: this.currentUri,
      })
        .margin({ bottom: this.getBrowserMarginBottom() })
        .visibility(Visibility.Visible)

      Column() {
        Progress({ value: this.downloadProgress, total: 100, type: ProgressType.Ring })
          .color($r('sys.color.white'))
          .backgroundColor('rgba(0,0,0,0.3)')
          .width(this.loadingSize)
          .height(this.loadingSize)
          .style({ strokeWidth: 4, enableScanEffect: true })
          .shadow({
            radius: 100,
            color: 'rgba(0,0,0,0.2)',
            fill: true,
            type: ShadowType.BLUR,
          })
          .foregroundColor(ColoringStrategy.INVERT)
      }
      .width(Constants.PERCENT_100)
      .height(Constants.PERCENT_100)
      .justifyContent(FlexAlign.Center)
      .visibility(Visibility.Hidden)

      if (this.browserController.isBrowserShowContent) {
        if (this.isFromPortraitCoverSet) {
          ActionBar({
            actionBarProp: $actionPortraitBarProp,
            onMenuClicked: (action: Action): void => this.onMenuClicked(action),
            isNeedPlaceholder: false,
            moreMenuList: this.moreMenuList,
            showMovingPhotoCloseEffect: this.showMovingPhotoCloseEffect,
            movingPhotoEffectMode: this.movingPhotoEffectMode,
          })
            .backgroundColor('rgba(0,0,0,0.4)')
            .zIndex(this.portraitIndex)
            .padding({
              left: this.diggingHoleCameraArea.left,
              right: this.diggingHoleCameraArea.right,
              top: (this.isHorizontal && !DeviceInfo.isFoldable()) || this.isVerdeFoldable
                ? 0 : this.actionBarPaddingTop,
            })
            .transition(TransitionEffect.asymmetric(
              PhotoConstants.OPEN_EFFECT,
                this.browserController.isDrag ? TransitionEffect.opacity(0) : PhotoConstants.CLOSE_EFFECT
            ))
        }
        if (this.isForceShowBar || (!this.isFromViewDataWithThirdUri && !this.isFromPortraitCoverSet)) {
          if (!this.isPullingUp) {
            PhotoBrowserActionBar({
              onMenuClicked: (action: Action): void => this.onMenuClicked(action),
              moreMenuList: this.moreMenuList,
              isShowSideBar: this.isShowSideBar,
              isShowSearchBrowser: this.isShowSearchPage,
              showMovingPhotoCloseEffect: this.showMovingPhotoCloseEffect,
              movingPhotoEffectMode: this.movingPhotoEffectMode,
            })
              .position({ x: Constants.PERCENT_0, y: this.actionBarPositionY })
              .opacity(this.geometryOpacity)
              .transition(TransitionEffect.asymmetric(
                PhotoConstants.OPEN_EFFECT_ACTIONBAR,
                  this.browserController.isDrag ? TransitionEffect.opacity(0) : PhotoConstants.CLOSE_EFFECT
              ))
              .enabled(!this.isPullDownAndDragPhoto)
          }

          if (!lockedScreenMgr().isFromLockedScreen && !this.isHorizontal &&
            !this.needUnlock && !(this.isFoldExpandedEnhancer && this.isFullModeEnhancer) &&
          this.isShowBar) {
            PhotoBrowserToolBar({
              onMenuClicked: (action: Action): void => this.onMenuClicked(action),
              isFromPhotoBrowser: true,
              isVisibilityText: false,
              moreMenuList: this.moreMenuList,
              showMovingPhotoCloseEffect: this.showMovingPhotoCloseEffect,
              movingPhotoEffectMode: this.movingPhotoEffectMode,
            })
              .visibility(this.isShowBar && !this.isHorizontal ?
                Visibility.Visible : Visibility.Hidden)
              .backgroundColor(!this.isSlideBarShow ?
                $r('sys.color.ohos_id_color_bottom_tab_sub_bg_blur') : Color.Transparent)
              .opacity(this.geometryOpacity * this.toolBarOpacityWithBurstPhotos)
              .markAnchor({ x: Constants.PERCENT_0, y: Constants.PERCENT_100 })
              .position({ x: Constants.PERCENT_0, y: Constants.PERCENT_100 })
              .transition(TransitionEffect.asymmetric(
                PhotoConstants.OPEN_EFFECT,
                  this.browserController.isDrag ? TransitionEffect.opacity(0) : PhotoConstants.CLOSE_EFFECT
              ))
              .enabled(!this.isPullDownAndDragPhoto && this.toolBarOpacityWithBurstPhotos !== 0)
          }

          PhotoBrowserHolder()
            .opacity(this.geometryOpacity)
            .transition(TransitionEffect.asymmetric(
              PhotoConstants.OPEN_EFFECT,
                this.browserController.isDrag ? TransitionEffect.opacity(0) : PhotoConstants.CLOSE_EFFECT
            ))
            .enabled(!this.isPullDownAndDragPhoto && !this.browserController.isAnimating)
          CustomDialogView({
            broadCast: $broadCast,
            deleteDialogIndex: this.deleteDialogIndex,
            isRecycle: UserFileManagerAccess.isRecycleBin(this.albumUri),
          })
            .opacity(this.geometryOpacity)
            .transition(TransitionEffect.asymmetric(
              PhotoConstants.OPEN_EFFECT,
                this.browserController.isDrag ? TransitionEffect.opacity(0) : PhotoConstants.CLOSE_EFFECT
            ))
            .enabled(!this.isPullDownAndDragPhoto && !this.browserController.isAnimating)
        } else if (!this.isPullingUp && !this.isFromPortraitCoverSet) {
          PhotoBrowserActionBar({
            onMenuClicked: (action: Action): void => this.onMenuClicked(action),
            moreMenuList: this.moreMenuList,
            isShowSideBar: this.isShowSideBar,
            showMovingPhotoCloseEffect: this.showMovingPhotoCloseEffect,
            movingPhotoEffectMode: this.movingPhotoEffectMode,
          })
            .opacity(this.geometryOpacity)
            .transition(TransitionEffect.asymmetric(
              PhotoConstants.OPEN_EFFECT_ACTIONBAR,
                this.browserController.isDrag ? TransitionEffect.opacity(0) : PhotoConstants.CLOSE_EFFECT
            ))
            .enabled(!this.isPullDownAndDragPhoto && !this.browserController.isAnimating)
        }
      }

      if (this.isShowOverlay) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor(Color.Transparent)
      }
      if (this.isShowLoading) {
        LoadingPanel();
      }
      EffectToggleComponent({
        dataSource: this.dataSource,
        onMenuClicked: (action: Action): void => this.onMenuClicked(action),
        stateMachine: this.stateMachine,
        isEffectSwitching: this.isMovingPhotoSwitching,
      })
        .position({ x: Constants.PERCENT_0, y: this.getEffectToggleViewYPosition()})
        .opacity(this.geometryOpacity)
        .visibility(this.isShowBar ? Visibility.Visible : Visibility.None)
    }
    .visibility(this.editorController.isBrowserShown &&
      !(this.needUnlock && this.pageFrom === Constants.ENTRY_FROM.HIDDEN) ? Visibility.Visible : Visibility.Hidden)
  }

  private getEffectToggleViewYPosition() {
    // xxx展开横屏
    if (this.isFoldExpanded) {
      return px2vp(this.statusBarHeight) + Constants.MULTIPLE_GAINS_BUTTON_HORIZONTAL_Y_POSITION;
    }
    // 横屏平板设备
    if (this.isHorizontal && DeviceInfo.isTabletDevice()) {
      return px2vp(this.statusBarHeight) + Constants.MULTIPLE_GAINS_BUTTON_Y_POSITION;
    }
    // 横屏模式
    if (this.isHorizontal && DeviceInfo.isPhone()) {
      return Constants.MULTIPLE_GAINS_BUTTON_HORIZONTAL_Y_POSITION;
    }

    return px2vp(this.statusBarHeight) + Constants.MULTIPLE_GAINS_BUTTON_Y_POSITION;
  }

  private getAccessibilityBackElementId(): string {
    return Constants.COMPONENT_KEY_BUTTON_BROWSER_BACK;
  }

  private getBlurImageComponentText(): Resource {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.currentIndex);
    if (!currentPhoto) {
      return $r('app.string.Private_protection_view_photos');
    }
    return currentPhoto.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO ?
      $r('app.string.show_video') : $r('app.string.Private_protection_view_photos');
  }

  build() {
    Stack() {
      if (this.editorController.isImageEditorShown) {
        // 图片编辑组件
        this.buildImageEditorMain();
      }

      this.buildPhotoBrowserComponent();
    }
    .expandSafeArea(this.isPullingUp ? [] : [SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM])
    .hitTestBehavior(this.editorController.isInSwitchAnimation ? HitTestMode.Block : HitTestMode.Default)
  }

  private reportToBigDataForPhotoSlide(index: number): void {
    let currentPhoto: MediaItem | undefined = PhotoBrowserUtils.getCurrentPhoto(this.dataSource, this.currentIndex);
    if (currentPhoto && index != this.currentIndex && this.viewTime != 0) {
      let currentTime = Date.now();

      interface Msg {
        type: string;
        duration: number;
      }

      let msg: Msg = {
        type: currentPhoto.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO ?
          BigDataConstants.VIDEO : BigDataConstants.NORMAL_PHOTO,
        duration: (currentTime - this.viewTime),
      }
      ReportToBigDataUtil.report(BigDataConstants.PHOTO_BROWSER_SLIDE_ID, msg);
      this.viewTime = Date.now();
    }
  }

  private reportToBigDataForCameraIn(): void {
    if (this.clickThumbnailTime == 0 || !this.isFromCamera || !this.isFromPetalClip) {
      return;
    }

    let msg: Record<string, number | string> = {
      'clickThumbnailTime': this.clickThumbnailTime,
      'ShowSinglePhoto': Date.now()
    }
    let fileName = ReportToBigDataUtil.getFileNameOfPhotoTakenByCamera(this.getPhotoByIndex(0));
    if (fileName) {
      msg['FileName'] = fileName;
    }
    ReportToBigDataUtil.setFileNameProperty(msg, fileName);
    ReportToBigDataUtil.report(BigDataConstants.BROWSE_PHOTO_FROM_CAMERA_ID, msg);
    this.clickThumbnailTime = 0;
  }

  private async syncPhotoName(currentPhoto: MediaItem): Promise<TitleName> {
    Log.debug(TAG, 'syncPhotoName start');
    let renameResult: TitleName = { title: '', displayName: '' };
    let fileAsset = await this.dataSource.getDataByUri(currentPhoto.uri);
    if (fileAsset) {
      renameResult = {
        title: fileAsset.get(UserFileManagerAccess.FILE_KEY_TITLE.toString()).toString(),
        displayName: fileAsset.displayName,
      };
    } else {
      const key: string = `renameResult${currentPhoto.uri}`;
      renameResult = AppStorage.get<TitleName>(key) as TitleName;
      AppStorage.delete(key);
    }
    Log.debug(TAG, `syncPhotoName end, renameResult : ${JSON.stringify(renameResult)}`);
    return renameResult;
  }

  private pullDownEnd(): void {
    Log.info(TAG, 'pulling down end');
    if (this.isFromFACard) {
      this.isPullDown = true;
    }
    this.browserController.isDrag = true;
    this.onBackPress(true);
  }

  private pullDownStart(): void {
    Log.info(TAG, 'pulling down start');
  }

  private pullDownStartWithEvent(event: KeyEvent): void {
    Log.debug(TAG, `pulling down start : ${JSON.stringify(event)}`);
    if (this.isFromViewDataWithThirdUri) {
      return;
    }
    this.isPullingDown = true;
  }

  private pullDownCancel(): void {
    Log.info(TAG, 'pulling down cancel');
    this.isPullingDown = false;
  }

  private onPhotoBrowserDeleteConfirm(): void {
    this.isDeleting = true;
    AppStorage.setOrCreate<boolean>('isDoingDeleteBigPhotoAnim', true);
    if (this.currentIndex === this.dataSource.totalCount() - 1) {
      AppStorage.setOrCreate<boolean>('isBigPhotoLeftToRightAnim', true);
    }
    // clear temp not favorite items
    if (UserFileManagerAccess.isFavoriteAlbumSubType(this.albumUri, this.albumInfo)) {
      let key = this.theDeleteItem?.uri ?? '';
      if (this.favorCacheItemsMap.has(key)) {
        let item = this.favorCacheItemsMap.get(key);
        new MenuContext().withMediaItem(item).withBroadCast(this.broadCast).operate(Action.FAVORITE.actionID);
        this.favorCacheItemsMap.delete(key);
      }
    }
  }

  private onPhotoBrowserRemoveConfirm(): void {
    this.isDeleting = true;
  }

  private doDelete(): void {
    Log.info(TAG, `delete finish now update data currentIndex:${this.currentIndex}`);
    this.isDeleting = true;
    if (AppStorage.get('isBigPhotoLeftToRightAnim') && this.currentIndex === 0) {
      AppStorage.setOrCreate<boolean>('isBigPhotoLeftToRightAnim', false);
    }
    if (this.currentIndex === this.dataSource.totalCount() - 1) {
      AppStorage.setOrCreate<boolean>('isBigPhotoLeftToRightAnim', true);
    }
    this.dataSource.getAlbumDataSource()?.setDeleteIndex(this.currentIndex);
  }

  private onPhotoShowStateChanged(state: boolean): void {
    Log.debug(TAG, 'current photo show state change');
    this.currentShow = state;
  }

  private setSwiperDisable(value: boolean): void {
    Log.info(TAG, `set swiper swipe ${value}`);
    this.disableSwipe = value;
  }

  private onDataReloadWithEdit(): void {
    Log.debug(TAG, 'animate to data reloaded start with edit');
    try {
      let uri: string | undefined = LocalStorage.getShared()?.get<string>(BroadCastConstants.PHOTO_EDIT_SAVE_URI);
      Log.debug(TAG, `data reloaded start with edit by uri ${uri}`);
      if (uri) {
        this.forceRefresh++;
        let newIndex = this.dataSource.getDataIndexByUri(uri);
        let oldIndex = this.currentIndex;
        if (newIndex !== Constants.NOT_FOUND) {
          // Search for the position of new image/video after edit in current 500 items succeed
          Log.debug(TAG, `data reloaded from ${oldIndex} move to ${newIndex}`);
          this.dataSource.resetPhotoRequest(uri);
          this.onPhotoChanged(newIndex);
        }
      }
    } catch (e) {
      Log.error(TAG, `ON_DATA_RELOADED_WITH_EDIT error ${e}`);
    }
  }

  private async doMediaOperation(displayName: string, albumUri: string, completedFunc?: Function): Promise<void> {
    Log.info(TAG, `broadCast on mediaOperation, albumUri: ${albumUri}`);
    ReportToBigDataUtil.report(BigDataConstants.COPY_MENU_RESPONSE, undefined);
    let currentPhoto: MediaItem | undefined = PhotoBrowserUtils.getCurrentPhoto(this.dataSource, this.currentIndex);
    if (!currentPhoto) {
      Log.error(TAG, 'MediaOperation currentPhoto is undefined');
      return;
    }
    let menuOperation: MenuOperation | null = null;
    let menuContext = new MenuContext();
    switch (this.pageType) {
      case MediaOperationType.ADD:
        menuContext.withMediaItem(currentPhoto)
          .withBroadCast(this.broadCast)
          .withTargetAlbumName(displayName)
          .withAlbumUri(albumUri)
          .withOperationEndCallback((err: Object, count: number, total: number): void => {
            this.onCopyEnd(err, count, total);
          });
        if (currentPhoto?.getIsBurstPhotos()) {
          const assets: MediaItem[] = await this.dataSource.getMediaItemsByBurstKey(currentPhoto?.burstKey);
          menuContext.withBurstPhotos(assets)
        }
        menuOperation = MenuOperationFactory.getInstance().createMenuOperation(AddMenuOperation, menuContext);
        this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.checkedTransition]);
        break;
      case MediaOperationType.MOVE:
        menuContext.withOperationEndCallback((err: Object, count: number, total: number): void => {
          this.onCopyEnd(err, count, total);
        })
          .withMediaItem(currentPhoto)
          .withBroadCast(this.broadCast)
          .withTargetAlbumName(displayName)
          .withAlbumInfo(this.albumInfo)
          .withAlbumUri(albumUri)
          .withOriginalAlbumUri(this.albumInfo?.uri)
          .operate(Action.MOVE.actionID);
        break;
      default:
        Log.warn(TAG, `invalid MediaOperationType = ${this.pageType}`);
        break;
    }
    menuOperation?.doAction();
    completedFunc?.();
  }

  private setFavor(isFavor: boolean): void {
    Log.debug(TAG, 'set favor !');
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.targetIndex);
    if (currentPhoto && !isFavor) {
      currentPhoto.isFavor = isFavor;
      this.updateMenu(this.targetIndex);
    } else {
      Log.debug(TAG, 'update favor !');
    }
  }

  private onDataContentChanged(): void {
    this.reportToBigDataForCameraIn();
    Log.debug(TAG, 'PhotoConstants.DATA_CONTENT_CHANGED');
    if (this.isFromFACard && this.isDataLoadFinishedFromViewData(this.currentIndex)) {
      this.broadCast.emit(PhotoConstants.DATA_LOAD_FINISH_PREVIEWER_REFRESH, []);
    }
    if (this.isFromViewData && this.isDataLoadFinishedFromViewData(this.currentIndex)) {
      Log.info(TAG, 'pc from view data index mediaItem load finished');
      this.broadCast.emit(PhotoConstants.DATA_LOAD_FINISH_PREVIEWER_REFRESH, []);
    }
    if (this.targetIndex === this.currentIndex) {
      this.onPhotoChanged(this.targetIndex);
    } else {
      Log.debug(TAG, 'ignore DATA_CONTENT_CHANGED event in swipe animation');
    }
  }

  private isDataLoadFinishedFromViewData(index: number): boolean {
    let albumDataSource: MediaDataSource | undefined = this.dataSource.getAlbumDataSource();
    if (!albumDataSource) {
      return false;
    }
    let indexMediaItem: MediaItem | undefined = albumDataSource.getRawData(index);
    if (!indexMediaItem) {
      return false;
    }
    Log.info(TAG, 'photoBrowser from viewdata index albumDatasource mediaItem exist');
    return true;
  }

  /**
   * 窗口大小变化回调
   */
  private onWinSizeChanged(): void {
    /* instrument ignore next */
    if (DeviceInfo.isSmallFoldScreen() && !this.isHorizontal) {
      setTimeout((): void => {
        this.actionBarPositionY = Constants.PERCENT_0;
      }, Constants.BROWSER_VIEW_ENTRY_ANIME_DELAY);
      Log.info(TAG, `onWinSizeChanged actionBarPositionY:${this.actionBarPositionY}`);
    }
    this.updateMenu(this.currentIndex);
    if (this.isFromViewData) {
      AppStorage.setOrCreate(Constants.FOLD_DISPLAY_MODE, display.getFoldDisplayMode());
    }
    AppStorage.setOrCreate('getFoldStatus', DeviceInfo.isFoldable());
  }

  private doRotate(result: number): void {
    Log.debug(TAG, `rotate finish: ${result}`);
    let currentPhoto: MediaItem | undefined = PhotoBrowserUtils.getCurrentPhoto(this.dataSource, this.currentIndex);
    if (currentPhoto) {
      currentPhoto.orientation = result;
      let temp = currentPhoto.height;
      currentPhoto.height = currentPhoto.width;
      currentPhoto.width = temp;
    }
    this.dataSource.onDataChanged(this.currentIndex);
    this.appBroadCast.emit(BroadCastConstants.UPDATE_IS_FAVOR, [currentPhoto]);
  }

  private doRename(result: TitleName, uniqueId: string): void {
    Log.info(TAG, 'rename refresh');
    this.updatePhotoName(result, uniqueId);
  }

  private initVideoPlay(vpc: VideoPlayController): void {
    Log.info(TAG, `[videoPlayer] bind controller:${vpc.getLabel()} to ${this.currentUri}`);
    this.videoPlayController = vpc;
  }

  private updateCurrentByFormCurrentUri(currentUri: string, currentAlbumUri: string): void {
    Log.info(TAG, `update index: ${currentUri}, isShowBar: ${this.isShowBar}, albumUri: ${currentAlbumUri}`);
    this.broadCast.emit(BrowserConstants.RESET_VIDEO_FRAME, []);
    this.editorController.onBackPress();
    this.uriFromThirdPartyApp = currentUri;
    if (currentAlbumUri) {
      this.initialAlbumInfoByUri(currentAlbumUri);
      this.dataSource.setAlbumUri(currentAlbumUri);
    }
    this.albumUri = currentAlbumUri || UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);
    this.isShowVideo = false;
    this.isPullingDown = false;
    this.dataSource.getItemIndexByUri(
      this.uriFromThirdPartyApp,
      (index: number): void => this.onGetItemIndexByUri(index), true);
    // 退出沉浸态
    if (!this.isShowBar) {
      this.broadCast.emit(PhotoConstants.SHOW_BARS, []);
    }
  }

  private videoInterruptByOtherApp(isPaused: boolean): void {
    this.changePlayButtonStatus(isPaused);
  }

  private changePlayButtonStatus(isVideoPlaying: boolean): void {
    this.isVideoPlaying = isVideoPlaying;
    this.updateMenu(this.targetIndex);
  }

  private onVideoPlayOrPauseClicked(): void {
    if (!this.isSupportedVideoType) {
      UiUtil.showToast($r('app.string.unsupported_video_type'));
      return;
    }
    if (!this.isNetworkAvailable()) {
      return;
    }
    this.isVideoPlaying = !this.isVideoPlaying;
    this.updateMenu(this.targetIndex);
    if (!this.isVideoPlaying) {
      Log.info(TAG, '[videoPlayer] click menu, action is play');
      let success: boolean | undefined = this.videoPlayController?.manuallyPlay();
      this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS,
        [success ? AvplayerStatus.PLAYING : AvplayerStatus.PAUSED]);
      this.appBroadCast.emit(BroadCastConstants.UPDATE_SHOW_VIDEO, []);
      this.isShowVideo = true;
    } else {
      Log.info(TAG, '[videoPlayer] click menu, action is pause');
      let success: boolean | undefined = this.videoPlayController?.manuallyPause();
      this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS,
        [success ? AvplayerStatus.PAUSED : AvplayerStatus.PLAYING]);
    }
  }

  private isNetworkAvailable(): boolean {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.targetIndex);
    if (!currentPhoto) {
      return false;
    }
    let fileAsset: PhotoAsset | undefined = currentPhoto.data;
    if (fileAsset) {
      let filePosition: photoAccessHelper.PositionType =
        fileAsset.get(photoAccessHelper.PhotoKeys.POSITION.toString()) as photoAccessHelper.PositionType;
      if (filePosition === UserFileManagerAccess.FILE_LOCATION_CLOUD) {
        if (!this.networkAvailable) {
          // 网络不可用
          UiUtil.showToast($r('app.string.no_network'));
          return false;
        }
      }
    }
    return true;
  }

  private getMenuOnShowVideo(list: Action[]): void {
    list.push(this.isMute ? Action.SOUND_OFF_FILLED : Action.SOUND_FILLED,
        this.isVideoPlaying ? Action.VIDEO_PAUSE : Action.VIDEO_PLAY);
    list.push(getScreen().getWinMode() === WindowMode.FULLSCREEN ?
      Action.PHONE_ROTATE : Action.PHONE_ROTATE_INVALID);
  }

  private onIsMuteChanged(): void {
    Log.info(TAG, `[videoPlayer] onIsMuteChanged, isMute: ${this.isMute}`);
    this.videoPlayController?.setVolume(this.isMute ? AvPlayConstants.AV_PLAY_MUTE : AvPlayConstants.AV_PLAY_VOLUME);
    this.updateMenu(this.targetIndex);
  }

  private foldStatusChange(): void {
    try {
      display.on('foldStatusChange', async (status: display.FoldStatus) => {
        if (status === display.FoldStatus.FOLD_STATUS_HALF_FOLDED) {
          this.isHalfFold = true;
          getScreen().setSystemUi(!this.isHalfFold);
          this.actionBarPositionY = Constants.PERCENT_50;
          Log.info(TAG, `halfFolded actionBarPositionY:${this.actionBarPositionY}`);
        } else if (status === display.FoldStatus.FOLD_STATUS_EXPANDED) {
          this.isHalfFold = false;
          getScreen().setSystemUi(!this.isHalfFold);
          this.actionBarPositionY = Constants.PERCENT_0;
          Log.info(TAG, `statusExpanded actionBarPositionY:${this.actionBarPositionY}`);
        }
      });
    } catch (err) {
      Log.error(TAG, `Failed to foldStatusChange !`);
    }
  }

  private setIsSwitching(isSwitching: boolean): void {
    this.isMovingPhotoSwitching = isSwitching;
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex?.(this.targetIndex);
    this.updateMenu(this.targetIndex);
  }

  private setIsMovingPhotoDownloading(isDownloading: boolean, uri: string): void {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex?.(this.targetIndex);
    Log.info(TAG, `[movingPhoto] setIsDownloading ${uri} currentPhoto:${currentPhoto?.uri}`);
    if (currentPhoto?.uri === uri) {
      this.isMovingPhotoDownloading = isDownloading;
    }
    this.updateMenu(this.targetIndex);
  }
}
