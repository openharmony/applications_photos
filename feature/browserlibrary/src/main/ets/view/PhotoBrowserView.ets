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

import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy {
  AlbumSetDataSourceManager
} from '@ohos/common/src/main/ets/default/model/browser/album/AlbumSetDataSourceManager';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { UserConstraintUtil } from '@ohos/common/src/main/ets/default/utils/UserConstraintUtil';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  ScreenManager
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { LibraryConstants } from '../model/LibraryConstants';
import lazy { ShareBrowserCustomDialog } from '../view/dialog/ShareBrowserCustomDialog';
import lazy { BackgroundView } from '../view/BackgroundView';
import lazy { SwiperView } from './SwiperView';
import lazy { ActionBarView } from '../view/ActionBarView';
import lazy { ToolBarView } from '../view/ToolBarView';
import lazy Curves from '@ohos.curves';
import lazy {
  ImageEditorMain,
  ImageEditorMsg,
} from 'browsercommonphone';
import lazy { EditorController } from 'browsercommonphone/src/main/ets/controller/EditorController';
import lazy window from '@ohos.window';
import lazy { VideoPlayController } from '@ohos/browsercommon/src/main/ets/default/controller/VideoPlayController';
import lazy {
  AvPlayConstants,
  AvplayerStatus,
  PauseReason
} from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { ThumbDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/ThumbDataSource';
import lazy display from '@ohos.display';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { image } from '@kit.ImageKit';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { WallpaperEditorLoader } from '@ohos/common/src/main/ets/default/view/WallpaperEditorComponent';
import lazy { SlideShowPageLoader, SlideShowParams } from '@ohos/common/src/main/ets/default/view/SlideShowPage';
import lazy {
  MediaOperationBasePageLoader
} from '@ohos/common/src/main/ets/default/view/browserOperation/MediaOperationBasePage'
import lazy common from '@ohos.app.ability.common';
import lazy { LockedScreen } from '@ohos/common/src/main/ets/default/utils/LockedScreen';
import lazy { LoadingDialog } from '@ohos.arkui.advanced.Dialog';
import lazy { PhotoConfig } from '@ohos/common/src/main/ets/default/config/PhotoConfig';
import lazy { osAccount, systemParameterEnhance } from '@kit.BasicServicesKit';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { PhotoBrowserUtils } from '@ohos/common/src/main/ets/default/utils/PhotoBrowserUtils';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { NavigationBroadCastManager } from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import lazy { BasePhotoBrowserController } from '../model/BasePhotoBrowserController';
import lazy { BrowserCaller, browserCallerMap } from '../model/ShowBrowserParam';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { PhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataSource';
import lazy { PhotoBrowserVM } from '../model/PhotoBrowserVM';
import lazy { LoadingPanel } from '@ohos/browsercommon/src/main/ets/default/view/LoadingPanel';
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import lazy {
  PhotoBrowserInitState
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserInitState';
import lazy { FoldData, FoldUtil } from '@ohos/common/src/main/ets/default/utils/FoldUtil';
import lazy { KeyCode } from '@kit.InputKit';
import lazy { SwiperViewModifier } from '@ohos/browsercommon/src/main/ets/default/viewModel/base/SwiperGestureUpdater';
import lazy { AnimationUtil } from '@ohos/common/src/main/ets/default/utils/AnimationUtil';
import lazy { BlurImageComponent } from '@ohos/common/src/main/ets/default/view/hidden/BlurImageComponent';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import { ThumbnailView } from './ThumbnailView';
import lazy { userAuth } from '@kit.UserAuthenticationKit';
import lazy { LockResult } from '@ohos/common/src/main/ets/default/utils/LockAuthenticCation';
import { accessibility } from '@kit.AccessibilityKit';
import { EffectToggleView } from './EffectToggleView';

export type UIAbilityContext = common.UIAbilityContext;

const TAG: string = 'PhotoBrowserView';

const NO_PHOTOS_TRANSITION_DURATION: number = 300;
const MEDIA_TYPE_VIDEO: string = 'VIDEO';
const MEDIA_TYPE_LIVE: string = 'LIVE_PHOTO';
const USER_ID_DEFAULT: number = 100;

/**
 * 大图页组件，供手机使用
 */
@Component
export struct PhotoBrowserView {
  private userId: number = 0;
  // 应用锁是否展示
  private isAppLockShow = false;
  @State pcCurItem: MediaItem = new MediaItem();
  /**
   * 大图组件控制器
   */
  @Consume browserController: BasePhotoBrowserController;
  @State stateMachine: PhotoBrowserStateMachine = this.browserController.stateMachine;
  /**
   * 大图组件dialog广播
   */
  @Provide dialogBroadCast: BroadCast = new BroadCast();
  /**
   * 隐藏大图组件回调
   */
  public hidePhotoBrowser: Function = (isPlayAni: boolean, index: number = 0): void => {
  };
  /**
   * 删除所有照片后回调
   */
  public onDeleteAllPhoto: Function = (): void => {
  };
  /**
   * 大图组件滑动后下标变动回调
   */
  changeCurrentItem: Function = (currentIndex: number): void => {
  }
  /**
   *  视频起播后的回调
   */
  private onVideoPlayingCallback: Function = (): void => {
  };
  /**
   *  视频暂停后的回调
   */
  private onVideoPausedCallback: Function = (): void => {
  };
  /**
   *  视频播放完成后的回调
   */
  private onVideoCompletedCallback: Function = (): void => {
  };
  /**
   * 预览时单击回调
   */
  private onPhotoSingleClick: Function = (): void => {
  };
  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();
  @StorageLink('isBrowserShow') isBrowserShow: boolean = false;
  @StorageLink('windowStatus') @Watch('windowStatusChange') windowStatus: number | undefined = undefined;
  @StorageLink('windowStageType') @Watch('windowStatusChange') windowType: window.WindowStageEventType | undefined =
    undefined;
  @Provide backgroundColorResource: Resource =
    this.browserController.pageFrom === BrowserCaller.CAMERA_PAGE ? $r('app.color.black') : $r('app.color.transparent');
  @Provide('dateTitle') photoDate: string = '';
  @Provide('timeLocationTitle') timeAndLocation: string = '';
  @Prop isShowMenu: boolean = true;
  @Prop private notShowDate: boolean = false;
  @Prop canPullingUp: boolean = true;
  @Prop isShowThumbSource: boolean = true;
  @Prop isShowImageAnalyzer: boolean = true;
  @State isShowBottomToolBar: boolean = false;
  @State isForceShowBar: boolean = this.browserController.isForceShowBar;
  @Prop private isShowPhoneRotate: boolean = true;
  @State isShowLoading: boolean = false;
  @State isLazyLoading: boolean = false;
  /**
   * 大图组件被相机拉起的时间点,用于大数据打点
   */
  @Prop private reportStartTime: number = 0;
  @Prop private curHiSearchWords: string = '';
  /**
   * 菜单支持操作 action 列表
   */
  @Provide menuList: Action[] = [];
  /**
   * 工具栏菜单支持操作 action 列表
   */
  @Provide toolMenuList: Action[] = [];
  /**
   * 更多栏支持操作 action 列表
   */
  @State private moreMenuList: Action[] = [];
  /**
   * 是否展示大图页顶部 actionBar 和底部 toolBar
   */
  @Provide isShowBar: boolean = false;
  @Provide onlyChangeBgColor: boolean = false;
  /**
   * 是否禁止 swiper 水平滑动标志位
   */
  @Provide disableSwipe: boolean = false;
  /**
   * 是否下拉拖动图片
   */
  @Provide isPullingDown: boolean = false;
  /**
   * 标记拉起大图页的页面来源
   */
  @Provide pageFrom: number = 0;
  @Provide viewData: string = '';
  /**
   * 标识当前屏幕是否为横屏状态
   */
  @StorageLink('isHorizontal') @Watch('updateIsHorizontal') isHorizontal: boolean = false;
  /**
   * 标识当前屏幕是否为分屏状态
   */
  @StorageLink('isSplitMode') private isSplitMode: boolean = false;
  /**
   * 标识当前屏幕是否为全屏状态
   */
  @StorageLink('isFullMode') @Watch('isFullModeChanged') private isFullMode: boolean = getScreen().isFullMode();
  @State private isFullModeEnhancer: boolean = getScreen().isFullMode();
  /**
   * 记录当前屏幕状态下，需要避让的区域信息（屏幕挖空等）
   */
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  /**
   * 当前图片 index 信息
   */
  public swiperController: SwiperController = new SwiperController();
  /**
   * 标识当前页面是否展示
   */
  @Prop @Watch('onPageChanged') pageStatus: boolean = false;
  /**
   * 一镜到底动效使用，用于控制顶部栏、底部栏、背景等控件动效过程的透明度
   */
  @LocalStorageLink('geometryOpacity') @Watch('onGeometryOpacityChange') geometryOpacity: number = 1;
  /**
   * 下拉使用，用于控制顶部栏、底部栏、预览条等控件动效过程的透明度
   */
  @LocalStorageLink('barGeometryOpacity') @Watch('onBarGeometryOpacityChange') barGeometryOpacity: number = 1;
  /**
   * 标记当前是否正在执行一镜到底动效
   */
  @Link @Watch('onRunningAnimationChanged') isRunningAnimation: boolean;
  /**
   * 标记当前是否正在执行打开的一镜到底动效
   */
  private isOpenRunningAnim: boolean = true;
  /**
   * 标记当前正在执行删除动画
   */
  @Provide isDeleting: boolean = false;
  @Provide isHiding: boolean = false;
  @Provide hidePopup: boolean = false;
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @State editorController: undefined | EditorController = undefined;
  @StorageLink('networkAvailable') @Watch('onNetworkAvailableChanged') networkAvailable: boolean = false;
  @LocalStorageLink('fastPixmap') fastPixmap: image.PixelMap | undefined = undefined;
  @LocalStorageLink('isEditorShown') @Watch('onEditorShown') isEditorShown: boolean = false;
  /**
   * 是否执行跟手下拉动效
   */
  @State @Watch('onPullDownAndDrag') isPullDownAndDragPhoto: boolean = false;
  /**
   * 强制触发下方缩略图刷新
   */
  @State forceRefresh: number = 0;
  @Provide isShowVideo: boolean = false;
  @Provide isEnableMouse: boolean = false;
  @Provide isFromPortrait: boolean = this.browserController.isFromPortrait;
  @Provide({allowOverride: 'albumInfoForMe'}) albumInfoForMe: AlbumInfo | undefined = undefined;
  @Provide isFromCamera: boolean = false;
  @Provide @Watch('changeIsDoDeleteAnim') isDoDeleteAnim: boolean = false;
  @State @Watch('changeThumbnailViewShow') isThumbnailViewShow: boolean = true;
  @State thumbnailShow: boolean = true;
  @State isScrolling: boolean = false;
  private viewModel: PhotoBrowserVM = new PhotoBrowserVM(this.stateMachine);
  private videoPlayController?: VideoPlayController;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private updateMenuBeforePlayFunc: Function = (): void => this.updateMenuBeforePlay();
  private videoPlayCompletedFunc: Function = (): void => this.videoPlayCompleted();
  private videoPlaySwiperIndexChangedFunc: Function = (): void => this.videoPlaySwiperIndexChanged();
  private videoInterruptByOtherAppFunc: Function = (isPaused: boolean): void => {
    this.videoInterruptByOtherApp(isPaused);
  }
  private changePlayButtonStatusFunc: Function = (isVideoPlaying: boolean): void => {
    this.changePlayButtonStatus(isVideoPlaying);
  }
  private updateShowMovingPhotoStatusFunc: Function = (isShowMovingPhoto: boolean): void => {
    this.updateShowMovingPhotoStatus(isShowMovingPhoto);
  }
  private updateCloudEnhanceClickedStatusFunc: Function = (clickedStatus: boolean): void => {
    this.updateCloudEnhanceClickedStatus(clickedStatus);
  }
  private updateCloudEnhanceTriggerStatusFunc: Function = (triggerStatus: boolean): void => {
    this.updateCloudEnhanceTriggerStatus(triggerStatus);
  }
  private showPhotoByIndexFunc: Function = (index: number): void => {
    this.showPhotoByIndex(index);
  }
  private jumpToJPGFunc: Function = (index: number, hasAnimation: boolean): void => {
    this.jumpToJPG(index, hasAnimation);
  }
  private downloadOriginPhotoResultFunc: Function =
    (result: String, uri: string): void => this.downloadOriginPhotoResult(result, uri);
  private initVideoPlayFunc: Function = (videoPlayController: VideoPlayController): void => this.initVideoPlay(videoPlayController);
  private updateIsLastCaptureMediaUriUpdateFunc: Function =
    (isLastCaptureMediaUriUpdate: boolean): void => this.updateIsLastCaptureMediaUriUpdate(isLastCaptureMediaUriUpdate);
  private updateMenuFunc: Function =
    (menuList: Action[], toolMenuList: Action[],
      moreMenuList: Action[]): void =>
    this.updateMenu(menuList, toolMenuList, moreMenuList);
  private onUpdateActionBarTitleFunc: Function =
    (photoDate: string, timeAndLocation: string): void => this.onUpdateActionBarTitle(photoDate, timeAndLocation);
  private jumpToSlideShowPageFunc: Function =
    (): void => this.jumpToSlideShowPage();
  private onMenuClickedForBackFunc: Function =
    (isNoPhotos: boolean): void => this.onMenuClickedForBack(isNoPhotos);
  private setPhotoScaledFunc: Function =
    (isPhotoScaled: boolean): void => {
      this.isPhotoScaled = isPhotoScaled;
    };
  private onMenuClickedForInfoFunc: Function =
    (isPullingUp: boolean, isPullingDown: boolean, disableSwipe: boolean): void =>
    this.onMenuClickedForInfo(isPullingUp, isPullingDown, disableSwipe);
  private updateCurrentIndexFunc: Function =
    (currentIndex: number): void => this.updateCurrentIndex(currentIndex);
  private updatePreparedIndexFunc: Function =
    (currentIndex: number): void => this.updatePreparedIndex(currentIndex);
  private updateHidePopupFunc: Function =
    (hidePopup: boolean): void => this.updateHidePopup(hidePopup);
  private onToggleBarsFunc: Function =
    (backgroundColorResource?: Resource): void => this.onToggleBars(backgroundColorResource);
  private showBarsFunc: Function =
    (backgroundColorResource?: Resource): void => this.showBars(backgroundColorResource);
  private hideBarsFunc: Function =
    (backgroundColorResource?: Resource): void => this.hideBars(backgroundColorResource);
  private updateDeletingFunc: Function =
    (isDeleting: boolean): void => this.updateDeleting(isDeleting);
  private updateHidingFunc: Function =
    (isHiding: boolean): void => this.updateHiding(isHiding);
  private getIsPullingDownFunc: Function =
    (callback: Function): void => this.getIsPullingDown(callback);
  private controllerBackEventFunc: Function =
    (callback: Function): void => this.controllerBackEvent(callback);
  private photosHmcontrollerBackEventFunc: Function =
    (callback: Function): void => this.photosHmControllerBackEvent(callback);
  private jumpToEditPageFunc: Function =
    (item: MediaItem, isRemoteSource: boolean): void => this.jumpToEditPage(item, isRemoteSource);
  private jumpToWallpaperEditorFunc: Function =
    (mediaUri: string, lcdUri: string): void => this.jumpToWallpaperEditor(mediaUri, lcdUri);

  private jumpToMoveToAlbumFunc: Function =
    (pageFrom: string, pageType: string, mediaType: number, albumInfo?: AlbumInfo, blackUris?: string[], browserControllerId?: number):
      void => this.jumpToMoveToAlbum(pageFrom, pageType, mediaType, albumInfo, blackUris, browserControllerId);

  private funcOnMediaOperationBack: Function =
    (pageType: string, mediaOperationAlbumName: string, mediaOperationAlbumUri: string, navigationPageFunc?: Function,
      browserControllerId?: number):
      Promise<void> => this.onMediaOperationBack(pageType, mediaOperationAlbumName, mediaOperationAlbumUri,
      navigationPageFunc, browserControllerId);

  // navigation切换页面回调
  private loadNavigationPageFun: Function = (name: string): Promise<void> => this.loadNavigationPage(name);
  private updateSystemUiFunc: Function =
    (): void => this.updateSystemUi();
  private doDeleteFunc: Function =
    (): void => this.doDelete();
  // 声音的状态
  private updateSoundFilledStateFunc: Function =
    (callback: Function): void => this.updateSoundFilledState(callback);
  // 设置声音数值
  private updateSoundFilledFunc: Function =
    (volume: number): void => this.updateSoundFilled(volume);
  private updateVideoPlayingStateFunc: Function =
    (callback: Function): void => this.updateVideoPlayingState(callback);
  private updateVideoPlayingFunc: Function =
    (isVideoPlaying: boolean): void => this.setIsVideoPlaying(isVideoPlaying);
  private updateVideoStateFunc: Function =
    (): void => this.updateVideoState();
  private videoPlayFunc: Function =
    (): void => this.videoPlay();
  private videoPauseFunc: Function =
    (): void => this.videoPause();
  private getVideoStatusFunc: Function =
    (callback: Function): void => this.getVideoStatus(callback);
  private updateActionBarPositionFunc: Function =
    (actionBarPosition: string): void => this.updateActionBarPosition(actionBarPosition);
  private setThumbnailViewShow: Function = (isThumbnailViewShow: boolean) => {
    this.isThumbnailViewShow = isThumbnailViewShow;
  }

  private navigationBroadCast = NavigationBroadCastManager.getInstance().getBroadCast();
  @StorageLink('isMute') @Watch('onIsMuteChanged') private isMute: boolean = false;
  @State @Watch('changeIsVideoPlaying') isVideoPlaying: boolean = false;
  private thumbSource: ThumbDataSource = new ThumbDataSource(this.stateMachine);
  @State isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @State isInSwiperAnimation: boolean = false;
  @StorageLink('getFoldStatus') @Watch('onFoldChanged') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink('currentLanguage') @Watch('updateCurrentLanguage') currentLanguage: string | undefined = undefined;
  @State private isFoldExpandedEnhancer: boolean = DeviceInfo.isFoldable() && !DeviceInfo.isPhoneVde();
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  @StorageLink('isHalfFold') @Watch('foldStatusChange') isHalfFold: boolean = DeviceInfo.isHalfFoldState();
  @StorageLink(Constants.APP_STORAGE_KEY_DOWNLOAD_PROGRESS) downloadProgress: number = 0;
  @StorageLink('isOpenTouchGuide') private isOpenTouchGuide: boolean = false;

  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Vertical });
  private isTouchingPullDown: boolean = false;
  private isPhotoScaled: boolean = false;
  private loadingSize: number = 32;
  @State isEffectSwitching: boolean = false;
  @State isShowOverlay: boolean = false;
  private showOverlayFunc: Function = (show: boolean): void => {
    this.isShowOverlay = show;
  }
  private convertJpgTimeoutFunc: Function = (show: boolean): void => {
    this.isShowLoading = show;
  }
  private foldStatusChangeFunc: Callback<display.FoldStatus> = async (status: display.FoldStatus) => {
    if (this.isHorizontal) {
      return;
    }
    if (status === display.FoldStatus.FOLD_STATUS_HALF_FOLDED) {
      this.isHalfFold = true;
      this.browserController.setSystemUi(!this.isHalfFold);
      this.actionBarPositionY = Constants.PERCENT_50;
      Log.info(TAG, `halfFolded actionBarPositionY:${this.actionBarPositionY}`);
    } else if (status === display.FoldStatus.FOLD_STATUS_EXPANDED) {
      this.isHalfFold = false;
      this.browserController.setSystemUi(!this.isHalfFold);
      this.actionBarPositionY = Constants.PERCENT_0;
      Log.info(TAG, `statusExpanded actionBarPositionY:${this.actionBarPositionY}`);
    }
  }
  @Provide isShowMovingPhoto: boolean = false;
  @Provide isButtonClicked: boolean = false;
  @Provide isEnhanceTriggered: boolean = false;
  @State isCloudEnhanceShowPrevious: boolean = false;
  @Provide @Watch('onCEProtocolStatusChanged') agreedCloudEnhanceProtocol: boolean = false;
  @State broadCast: BroadCast = new BroadCast();
  // 进入和退出连拍界面大图的透明度控制
  @State private swiperOpacityWithBurstPhotos: number = 1;
  @State private centerPreviewOpacityWithBurst: number = 1;
  @State private openBurstPreviewBlurStyle: boolean = false;
  private imageInfo: image.ImageInfo | undefined = undefined;
  // 隐藏相册变量
  @State needUnlock: boolean = false;
  @Provide @Watch('onListeningStatus') vanishingState: boolean = true;
  @State actionBarPositionY: Length = this.isHalfFold && !this.isHorizontal ? Constants.PERCENT_50 : Constants.PERCENT_0;
  private readonly onIndexPageShowFunc: Function = (): void => this.onIndexPageShow();
  private onIndexPageShow(): void {
    if (this.browserController.pageFrom === BrowserCaller.HIDDEN_ALBUM) {
      Log.info(TAG, `hiddenAlbum set lock param`);
      this.vanishingState = true;
      this.updateNeedUnlockState();
    }
  }
  @State private isShowFadeOutAnim: boolean = false;
  @State private isLastCaptureMediaUriUpdate: boolean = false;
  @State isSlideBarShow: boolean = false;
  @Provide({ allowOverride: 'navigationPageInfos' }) private navPageInfos: NavPathStack = new NavPathStack();
  private exportDialogController: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({
      content: $r('app.string.moving_photo_exporting'),
    }),
    autoCancel: false,
  });
  @State exportPosition: number = -1;
  private isHidden: boolean = false;
  private slideShowChangeIndexFunc: Function = (index: number): void => this.slideShowChangeIndex(index);
  private editorInitFunc: Function =  (): void => this.editorInit();
  private reportTimerId: number = 0;
  private pullUnlockDialog: boolean = true;

  @State curFoldStatus: number = FoldUtil.getInstance().getCurFoldStatus();
  private foldDataChangeListener: (foldData: FoldData) => void = this.onFoldDataChange.bind(this);

  /**
   * 更新是否拉起隐藏相册解锁页状态
   */
  private updateNeedUnlockState(): void {
    try {
      const enrolledState = userAuth.getEnrolledState(userAuth.UserAuthType.PIN);
      this.needUnlock = enrolledState?.credentialCount > 0;
      Log.info(TAG, `get PIN enrolled state success, needUnlock: ${this.needUnlock}`);
    } catch (error) {
      if (error?.code === LockResult.NOT_ENROLLED) {
        this.needUnlock = false;
      }
      Log.error(TAG, `get PIN enrolled state failed, Code is ${error?.code}, message is ${error?.message}`);
    }
  }

  private onFoldDataChange(foldData: FoldData) {
    this.curFoldStatus = foldData.curFoldStatus;
  }

  onListeningStatus() {
    Log.info(TAG, `vanishingState=${this.vanishingState}`);
    this.needUnlock = this.vanishingState;
    if (!this.needUnlock) {
      this.pullUnlockDialog = true;
    }
  }
  private portraitAlbumDetailBroadCast: BroadCast = new BroadCast();
  private albumBroadCast: BroadCast = new BroadCast();
  private loadFinishedFun: Function = (totalCount: number, options: string, albumInfoList: AlbumInfo[]): void =>
  this.loadFinished(totalCount, options, albumInfoList);
  private swiperViewGesture: GestureGroupHandler = new GestureGroupHandler({
    mode: GestureMode.Exclusive,
    gestures: [
      new PinchGestureHandler({
        fingers: 2,
      }),
      new PanGestureHandler({
        direction: PanDirection.Vertical })
        .onActionStart((event: GestureEvent): void => {
          if (this.isPullDownOnHorizontal(event)) {
            // 大图组件横屏下拉不做跟手处理,离手后直接返回
            this.isTouchingPullDown = true;
            this.onMenuClickedForInfo(this.viewModel.isPullingUp, true, this.disableSwipe);
          }
        })
        .onActionEnd((event: GestureEvent): void => {
          if (this.isPullDownOnHorizontal(event) && this.isTouchingPullDown) {
            this.browserController.isDrag = false;
            this.isTouchingPullDown = false;
            this.browserController.onBackPress();
          }
        })
    ]
  })
  @State swiperViewModifier: SwiperViewModifier =
    new SwiperViewModifier(this.browserController.pageFrom === BrowserCaller.CAMERA_PAGE, this.swiperViewGesture);

  private initEditor(): void {
    if (this.editorController) {
      return;
    }
    this.editorController = new EditorController();
    this.editorController.init(this.broadCast, window.Orientation.AUTO_ROTATION);
    this.editorController.init(this.broadCast, window.Orientation.AUTO_ROTATION_UNSPECIFIED);
    // if (DeviceInfo.isPhone() && !DeviceInfo.isFoldDevice() &&
    //   this.browserController.photosRotateType == PhotosRotateType.TYPE_ALWAYS) {
    //   Log.info(TAG, `Set Edit Orientation:${window.Orientation.AUTO_ROTATION}`);
    //   this.editorController.init(this.broadCast, window.Orientation.AUTO_ROTATION);
    // } else {
    //   Log.info(TAG, `Set Edit Orientation:${window.Orientation.AUTO_ROTATION_UNSPECIFIED}`);
    //   this.editorController.init(this.broadCast, window.Orientation.AUTO_ROTATION_UNSPECIFIED);
    // }
  }

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

  private dataReloadCompleteFun: Function = (albumInfoList: AlbumInfo[], isFromCache: boolean):
    void => this.dataReloadComplete(albumInfoList, isFromCache);
  /**
   * 绑定ON_DATA_RELOADED广播的处理函数：当数据重新加载完成时
   *
   * @param albumInfoList 相册信息列表
   */
  dataReloadComplete(albumInfoList: AlbumInfo[], isFromCache: boolean): void {
    Log.info(TAG, `dataReloadComplete albumInfoList: ${albumInfoList.length} isFromCache:${isFromCache}`)
  }

  private animationDoneCallback: () => void = (): void => {
  };
  private onPageShowFunc: Function = (msg: string): void => this.onPageShow();
  private onPageHideFunc: Function = (msg: string): void => this.onPageHide();

  private refreshPrivateHideState(): void {
    if (this.browserController.isPrivateHideState) {
      this.broadCast.emit(BrowserConstants.SHOW_BARS, []);
      if (this.viewModel.isPullingUp) {
        let item: MediaItem | undefined = PhotoBrowserUtils.getCurrentPhoto(this.browserController.dataSource,
          this.viewModel.getTargetIndex());
        this.broadCast.emit(BrowserConstants.CLOSE_CLICK_DETAIL_BY_BACK_PRESS + item?.path, []);
      }
    }
    if (this.browserController.isPrivateHideState && this.isShowVideo) {
      Log.info(TAG, '[videoPlayer] enter risk state, video pause');
      let success: boolean | undefined = this.videoPlayController?.manuallyPause();
      this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS,
        [success ? AvplayerStatus.PAUSED : AvplayerStatus.PLAYING]);
    }
    this.browserController.updateActionBar(this.viewModel.getCurrentIndex());
  }
  private onEffectModeSwitchClicked: (isMovingPhoto: boolean) => void = (isMovingPhoto): void => {
    this.browserController.onEffectModeSwitchClicked(isMovingPhoto);
  }

  private onRunningAnimationChanged(): void {
    Log.info(TAG, `[enterLibrary] onRunningAnimationChanged ${this.isRunningAnimation}`);
    if (this.isRunningAnimation) {
      this.viewModel.processEnterAnimationStartEvent();
      return;
    }
    if (this.browserController.browserAnimController.isTransitionEnable) {
      this.viewModel.processEnterAnimationEndEvent();
    }

    this.animationDoneCallback();
    this.animationDoneCallback = (): void => {
    };
    // 在打开动效结束后，再发起一次解码
    if (this.isOpenRunningAnim) {
      this.browserController.updatePixMapDataSource(false);
      this.isOpenRunningAnim = false;
    }
  }

  private changeIsDoDeleteAnim(): void {
    this.browserController.isDoDeleteAnim = this.isDoDeleteAnim;
  }

  private updateIsLastCaptureMediaUriUpdate(isLastCaptureMediaUriUpdate: boolean): void {
    if (isLastCaptureMediaUriUpdate) {
      this.isLastCaptureMediaUriUpdate = isLastCaptureMediaUriUpdate;
      if (!this.isRunningAnimation) {
        this.browserController.releasePixelMap();
        this.imageInfo = undefined;
      }
    }
  }

  private changeThumbnailViewShow(): void {
    Log.info(TAG, `update ThumbnailViewShow:${this.isThumbnailViewShow}`);
  }

  private onFoldChanged(): void {
    this.isFoldExpandedEnhancer = DeviceInfo.isFoldable() && !DeviceInfo.isPhoneVde();
    this.browserController.isFoldExpanded = DeviceInfo.isFoldable();
  }

  private updateCurrentLanguage(): void {
    Log.info(TAG, `updateCurrentLanguage:${this.currentLanguage}`);
    this.browserController.updateCurrentLanguage();
  }

  private isSwiperOffsetZero: boolean = true;
  private getSwiperAnimationStateFunc: Function =
    (isSwiperOffsetZero: boolean): void => this.getSwiperAnimationState(isSwiperOffsetZero);

  private getSwiperAnimationState(isSwiperOffsetZero: boolean): void {
    this.isSwiperOffsetZero = isSwiperOffsetZero
  }

  onGeometryOpacityChange(): void {
    Log.info(TAG, `actionbar onGeometryOpacityChange ${this.geometryOpacity}`);
  }

  onBarGeometryOpacityChange(): void {
    Log.info(TAG, `actionbar onBarGeometryOpacityChange ${this.barGeometryOpacity}`);
  }

  onPullDownAndDrag(): void {
    Log.info(TAG, `onPullDownAndDrag: ${this.isPullDownAndDragPhoto}`);
    this.browserController.isPullDownAndDrag = this.isPullDownAndDragPhoto;
    this.barGeometryOpacity = 1;
  }

  private onEditorShown(): void {
    if (this.isEditorShown === false) {
      Log.info(TAG, 'hide Editor startCastAbility');
      this.browserController.isPhotoActive = true;
    }
    animateTo({
      duration: 0,
    }, () => {
      if (this.isEditorShown) {
        this.geometryOpacity = 0;
      } else {
        this.geometryOpacity = 1;
      }
    })
  }

  async onMediaOperationBack(pageType: string, mediaOperationAlbumName: string, mediaOperationAlbumUri: string,
    navigationPageFunc?: Function, browserControllerId?: number):
    Promise<void> {
    Log.info(TAG, `photoBrowserView onMediaOperationBack, pageType=${pageType}, mediaOperationAlbumUri=${mediaOperationAlbumUri
      } this.browserControllerId = ${this.browserController.browserControllerId}, browserControllerId = ${browserControllerId}`);
    if (this.browserController.browserControllerId !== browserControllerId && browserControllerId !== undefined) {
      return;
    }
    this.onPageShow();
    this.browserController.mediaOperationBack(pageType, mediaOperationAlbumName, mediaOperationAlbumUri,
      navigationPageFunc);
  }

  @BuilderParam navigationPageLoader: () => void;

  private async loadNavigationPage(name: string): Promise<void> {
    try {
      Log.info(TAG, `loadNavigationPage name: ${name}`);
      if (name === NavigationConstants.NAVIGATION_PRIVACY_VIEWER) {
        let pageObj = await import('@ohos/privacy/src/main/ets/components/mainpage/PrivacyViewerFullScreen');
        this.navigationPageLoader = pageObj.PrivacyViewerFullScreenLoader;
      }
    } catch (error) {
      Log.error(TAG, `loadNavigationPage error: ${error}`)
    }
  }

  private report(): void {
    if (this.reportStartTime !== 0) {
      const msg: Record<string, number | string | boolean> = {
        'delay': Date.now() - this.reportStartTime
      };
      ReportToBigDataUtil.statisticReport(BigDataConstants.PULL_UP_PHOTO_BROWSER_VIEW_DELAY, msg);
    }
    const aboutMsg: Record<string, number | string | boolean> = {
      'status': BigDataConstants.PHOTO_BROWSER_VIEW_ABOUT_TO_APPEAR,
      'viewAppearCount': ++this.browserController.viewAppearCount
    };
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_BROWSER_VIEW_ABOUT, aboutMsg);
    const idMsg: Record<string, number | string | boolean> = {
      'isShowMenuFromThirdView': !this.geometryOpacity
    };
    ReportToBigDataUtil.report(BigDataConstants.IS_SHOW_MENU_ID, idMsg);
    let cameraShotKey = AppStorage.get<string>('cameraShotKey');
    let screenLockState: boolean = getScreen()?.screenIsLock();
    Log.info(TAG, `CameraShotKey: ${cameraShotKey}, isScreenLock: ${screenLockState}`);
    const isFromAppLockMsg: Record<string, string | boolean | undefined> = {
      'cameraShotKey': cameraShotKey,
      'screenLockState': screenLockState
    }
    ReportToBigDataUtil.report(BigDataConstants.BROWSE_PHOTO_FROM_APP_LOCK, isFromAppLockMsg);
    interface Msg {
      SHOW_MENU: boolean,
      SHOW_AI: boolean,
      CAN_PULLUP: boolean,
    }

    let msg: Msg = {
      SHOW_MENU: this.isShowMenu,
      SHOW_AI: this.isShowImageAnalyzer,
      CAN_PULLUP: this.canPullingUp,
    }
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_BROWSER_COMPONENT_ID, msg);
    if (this.viewModel.getCurrentIndex() === 0) {
      this.browserController.isSupportImageEditorReport();
    }
  }

  aboutToAppear(): void {
    Log.info(TAG, `PhotoBrowserView appear`);
    this.pageFrom = browserCallerMap.get(this.browserController.pageFrom) ?? 0;
    getScreen()?.updateSize();
    if (DeviceInfo.isGRLFoldScreen()) {
      FoldUtil.getInstance().subscribe(this.foldDataChangeListener);
    }
    Log.info(TAG, `PhotoBrowserView appear isFromPortraitCard: ${this.browserController.isFromPortraitCard}`);

    this.albumBroadCast.on(Constants.ON_LOADING_FINISHED, this.loadFinishedFun);
    this.portraitAlbumDetailBroadCast.on(BroadCastConstants.ON_DATA_RELOADED, this.dataReloadCompleteFun)

    // todo 首次进入大图isRunningAnimation监听概率不回调，属性动画修改完成后，需要改为在动画触发处执行，此处删除
    this.browserController.uiContext = this.getUIContext();
    this.browserController.setCameraAnimController();
    this.viewModel.onCreate(this.browserController)
    this.viewModel.setThumbnailViewShow = this.setThumbnailViewShow;
    this.viewModel.processEnterAnimationStartEvent();
    this.browserController.isPhotoBrowserViewShow = true;
    this.browserController.isDoDeleteAnim = false;
    this.geometryOpacity = this.browserController?.browserAnimController?.isTransitionEnable ? 1 : 0;
    // 分帧加载，其他组件等待动画完成后加载
    this.thumbnailShow = this.browserController.browserAnimController.isTransitionEnable;
    this.needUnlock = false;
    if (!this.browserController.isAnimating) {
      this.browserController.isBrowserShowContent = true;
      Log.info(TAG, 'call show browser non-image content');
    }
    // 注册currenIndex改变 的回调事件
    AppStorage.setOrCreate('getFoldStatus', DeviceInfo.isFoldable());
    AppStorage.setOrCreate(Constants.FOLD_DISPLAY_MODE, display.getFoldDisplayMode());
    this.downloadProgress = 0;
    this.browserController.setIsSupportedVideoTypeFun(true);
    this.browserController.oldPhotoSize = Math.max(this.browserController.dataSource.totalCount(), 0);
    this.browserController.initLastAutoMediaItem();
    this.browserController.updateHorizontal();
    this.browserController?.setHidePhotoBrowser(this.hidePhotoBrowser);
    Log.info(TAG, `aboutToAppear foldStatus = ${
      DeviceInfo.isFoldable()}, geometryOpacity = ${this.geometryOpacity},isHorizontal = ${
      this.isHorizontal}, browserController.hashCode: ${this.browserController.hashCode}`);
    this.browserController.onAppearSwing();
    /* instrument ignore next */
    if (DeviceInfo.isSmallFoldScreen()) {
      this.foldStatusChange();
      this.browserController.setSystemUi(!this.isHalfFold);
    }
    if (this.isVerdeFoldable) {
      this.hideBars();
    }
    if (LockedScreen.isSecurityCameraUnlocked()) {
      this.isShowImageAnalyzer = false;
    }
    this.reportTimerId = setTimeout(() => {
      this.reportTimerId = 0;
      UserConstraintUtil.initConstraints();
      this.report();
    }, Constants.DELAY_HALF_SECOND);
    AppStorage.setOrCreate<boolean>('isDoingDeleteBigPhotoAnim', false);
    AppStorage.setOrCreate<boolean>('isDoingRecoverBigPhotoAnim', false);
    this.browserController.setNetworkAvailable(this.networkAvailable);
    this.browserController.setIsMute(this.isMute);
    this.browserController.setIsBrowserFullShow(true);
    this.browserController.setVideoPlaying(this.isVideoPlaying);
    this.browserController.setIsEnhanceTriggered(this.isEnhanceTriggered);
    // TODO：直接在stateMacheine里写updateCurrentIndex的方法
    this.viewModel.setCurrentIndex(this.viewModel.getTargetIndex());
    AlbumSetDataSourceManager.getInstance();
    setTimeout((): void => {
      this.updateIsHorizontal();
    }, Constants.BROWSER_VIEW_ENTRY_ANIME_DELAY);
    this.browserController.registerBroadCast(this.broadCast);
    this.getUIContext()?.getHostContext()?.eventHub.on(BroadCastConstants.ON_PAGE_SHOW, this.onIndexPageShowFunc);
    this.navigationBroadCast.on(NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION_BACK,
      this.funcOnMediaOperationBack);
    this.navigationBroadCast.on(NavigationConstants.LOAD_PAGE, this.loadNavigationPageFun);
    this.broadCast.on(BroadCastConstants.SLIDESHOW_CHANGE_INDEX, this.slideShowChangeIndexFunc);
    this.thumbSource.setPhotoDataSource(this.browserController.dataSource);
    this.browserController.registerCallback(LibraryConstants.LAST_CAPTURE_MEDIAURI_UPDATE,
      this.updateIsLastCaptureMediaUriUpdateFunc);
    this.browserController.registerCallback(LibraryConstants.EDITOR_INIT, this.editorInitFunc);
    this.browserController.registerCallback(LibraryConstants.MENU_KEY_UPDATE_CALLBACK, this.updateMenuFunc);
    this.browserController.registerCallback(LibraryConstants.KEY_UPDATE_ACTION_BAR_TITLE,
      this.onUpdateActionBarTitleFunc);
    this.browserController.registerCallback(LibraryConstants.JUMP_TO_SLIDE_SHOW, this.jumpToSlideShowPageFunc);
    this.browserController.registerCallback(LibraryConstants.MENU_KEY_BACK_CALLBACK, this.onMenuClickedForBackFunc);
    this.browserController.registerCallback(LibraryConstants.PHOTO_SCALED, this.setPhotoScaledFunc);
    this.browserController.registerCallback(LibraryConstants.MENU_KEY_INFO_CALLBACK, this.onMenuClickedForInfoFunc);
    this.browserController.registerCallback(LibraryConstants.UPDATE_CURRENT_INDEX, this.updateCurrentIndexFunc);
    this.browserController.registerCallback(LibraryConstants.UPDATE_PREPARED_INDEX, this.updatePreparedIndexFunc);
    this.browserController.registerCallback(LibraryConstants.UPDATE_HIDE_POPUP, this.updateHidePopupFunc);
    this.browserController.registerCallback(LibraryConstants.ON_TOGGLE_BARS_CALLBACK, this.onToggleBarsFunc);
    // 退出沉浸式
    this.browserController.registerCallback(LibraryConstants.SHOW_BARS_CALLBACK, this.showBarsFunc);
    // 进入沉浸式
    this.browserController.registerCallback(LibraryConstants.HIDE_BARS_CALLBACK, this.hideBarsFunc);
    this.browserController.registerCallback(LibraryConstants.UPDATE_DELETING, this.updateDeletingFunc);
    this.browserController.registerCallback(LibraryConstants.UPDATE_HIDING, this.updateHidingFunc);
    // 返回下拉参数
    this.browserController.registerCallback(LibraryConstants.GET_IS_PULLING_DOWN, this.getIsPullingDownFunc);
    // 返回上划参数
    this.browserController.registerCallback(LibraryConstants.CONTROLLER_BACK_EVENT, this.controllerBackEventFunc);
    this.browserController.registerCallback(LibraryConstants.PHOTOSHM_CONTROLLER_BACK_EVENT,
      this.photosHmcontrollerBackEventFunc);
    this.browserController.registerCallback(LibraryConstants.JUMP_TO_EDIT_PAGE, this.jumpToEditPageFunc);
    this.browserController.registerCallback(LibraryConstants.JUMP_TO_WALLPAPER_EDITOR, this.jumpToWallpaperEditorFunc);
    this.browserController.registerCallback(LibraryConstants.JUMP_TO_MOVE_TO_ALBUM, this.jumpToMoveToAlbumFunc);
    this.browserController.registerCallback(LibraryConstants.UPDATE_SYSTEM_UI, this.updateSystemUiFunc);
    this.browserController.registerCallback(LibraryConstants.DELETE, this.doDeleteFunc);
    this.browserController.registerCallback(LibraryConstants.VIDEO_IS_MUTE, this.updateSoundFilledStateFunc);
    this.browserController.registerCallback(LibraryConstants.VIDEO_SOUND_FILLED, this.updateSoundFilledFunc);
    this.browserController.registerCallback(LibraryConstants.VIDEO_PLAYING_STATE, this.updateVideoPlayingStateFunc);
    this.browserController.registerCallback(LibraryConstants.VIDEO_IS_PLAYING, this.updateVideoPlayingFunc);
    this.browserController.registerCallback(LibraryConstants.UPDATE_VIDEO_STATE, this.updateVideoStateFunc);
    this.browserController.registerCallback(LibraryConstants.VIDEO_PLAY, this.videoPlayFunc);
    this.browserController.registerCallback(LibraryConstants.VIDEO_PAUSE, this.videoPauseFunc);
    this.browserController.registerCallback(LibraryConstants.GET_VIDEO_STATUS, this.getVideoStatusFunc);
    this.browserController.registerCallback(LibraryConstants.UPDATE_ACTIONBAR_POSITION, this.updateActionBarPositionFunc);

    this.browserController.onPhotoChanged(this.viewModel.getCurrentIndex(), this.isOpenRunningAnim);
    setTimeout((): void => {
      this.browserController.setRotationCapability(true);
    }, Constants.BROWSER_VIEW_ENTRY_ANIME_DELAY);
    if (DeviceInfo.isSmallFoldScreen()) {
      getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    }
    if (accessibility.isOpenTouchGuideSync()) {
      this.isOpenTouchGuide = true;
    }
    this.appBroadCast.on(BroadCastConstants.UPDATE_MENU_BEFORE_PLAY_VIDEO, this.updateMenuBeforePlayFunc);
    this.appBroadCast.on(BroadCastConstants.VIDEO_PLAY_COMPLETED, this.videoPlayCompletedFunc);
    this.appBroadCast.on(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, this.videoPlaySwiperIndexChangedFunc);
    this.appBroadCast.on(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, this.initVideoPlayFunc);
    this.appBroadCast.on(BroadCastConstants.UPDATE_MENU_ON_AUDIO_INTERRUPT, this.videoInterruptByOtherAppFunc);
    this.appBroadCast.on(BroadCastConstants.UPDATE_SHOW_MOVING_PHOTO_STATUS, this.updateShowMovingPhotoStatusFunc);
    this.appBroadCast.on(BroadCastConstants.UPDATE_CLOUD_ENHANCE_CLICKED_STATUS,
      this.updateCloudEnhanceClickedStatusFunc);
    this.appBroadCast.on(BroadCastConstants.UPDATE_CLOUD_ENHANCE_TRIGGER_STATUS,
      this.updateCloudEnhanceTriggerStatusFunc);
    this.appBroadCast.on(BroadCastConstants.SHOW_PHOTO_BY_INDEX,
      this.showPhotoByIndexFunc);
    this.appBroadCast.on(BroadCastConstants.SWIPER_CHANGE_AFTER_CONVERT,
      this.jumpToJPGFunc);
    this.appBroadCast.on(BroadCastConstants.CHANGE_PLAY_BUTTON_STATUS, this.changePlayButtonStatusFunc);
    this.appBroadCast.on(BroadCastConstants.SET_WAITING_DONE_CALLBACK, this.setWaitingDoneCallbackFunc);
    this.appBroadCast.on(BroadCastConstants.ON_SWIPER_ANIMATION_CHANGE, this.getSwiperAnimationStateFunc);
    this.appBroadCast.on(BroadCastConstants.SHOW_CONVERT_LOADING_PANEL, this.convertJpgTimeoutFunc);
    this.appBroadCast.on(BroadCastConstants.SHOW_FAST_PLAY_LABEL, this.showOverlayFunc);
    this.appBroadCast.on(BroadCastConstants.EFFECT_MODE_SWITCH_CLICKED, this.onEffectModeSwitchClicked);
    this.appBroadCast.on(BroadCastConstants.DOWNLOAD_ORIGIN_PHOTO_RESULT,
      this.downloadOriginPhotoResultFunc);
    this.appBroadCast.on(BroadCastConstants.SHOW_WALLPAPER, this.setShowWallpaper);
    this.getUIContext().getHostContext()?.eventHub.on(BroadCastConstants.PHOTO_BROWSER_ON_PAGE_SHOW,
      this.onPageShowFunc);
    this.getUIContext().getHostContext()?.eventHub.on(BroadCastConstants.PHOTO_BROWSER_ON_PAGE_HIDE,
      this.onPageHideFunc);
    this.browserController.initSystemUi(this.isHorizontal);
    // 判断是否需要同步参数到setting
    this.browserController.lockThumbnail();
    AppStorage.setOrCreate<MediaItem | undefined>('targetItem', this.getPhotoByIndex(this.viewModel.getCurrentIndex()));
    this.viewModel.saveTargetItem(this.viewModel.getTargetIndex());
    if (this.browserController.pageFrom === BrowserCaller.VIEWDATA_PAGE) {
      setTimeout((): void => {
        Log.info(TAG, 'page from VIEW_DATA, cast Delay 600ms');
        AppStorage.setOrCreate<PhotoDataSource>('dataSource', this.browserController.dataSource);
        this.hideBars()
      }, 600);
      AppStorage.setOrCreate(Constants.APP_KEY_PHOTO_BROWSER, this.browserController.dataSource.getAlbumDataSource());
    } else {
    }
    this.browserController.isPhotoActive = true;
    Log.info(TAG, `photoBrowserView abouttoappear end index:${this.viewModel.getCurrentIndex()}}`);
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'PhotoBowserView aboutToDisappear');
    if (this.reportTimerId > 0) {
      clearTimeout(this.reportTimerId);
      this.reportTimerId = 0;
    }
    if (!PhotoConfig.isLibrary() && !this.isHorizontal) {
      getScreen().setSystemUi(true);
    }
    this.viewModel.onDestroy();
    if (DeviceInfo.isGRLFoldScreen()) {
      FoldUtil.getInstance().unSubscribe(this.foldDataChangeListener);
    }
    this.isHidden = true;
    this.browserController.unlockThumbnail();
    this.fastPixmap?.release();
    this.fastPixmap = undefined;
    // 收藏相册 状态更新
    this.browserController.updateAssetFavorState();
    this.isMute = false;
    this.isShowVideo = false;
    this.browserController.setIsShowVideo(this.isShowVideo);
    this.browserController.onDisappearSwing();
    const msg: Record<string, number | string | boolean> = {
      'status': BigDataConstants.PHOTO_BROWSER_VIEW_ABOUT_TO_DISAPPEAR
    };
    /* instrument ignore next */
    if (DeviceInfo.isSmallFoldScreen()) {
      try {
        display.off('foldStatusChange', this.foldStatusChangeFunc);
      } catch (err) {
        Log.error(TAG, `foldStatusChange display.off, error code : ${err.code}`)
      }
    }
    this.portraitAlbumDetailBroadCast.off(BroadCastConstants.ON_DATA_RELOADED, this.dataReloadCompleteFun)
    this.albumBroadCast.off(Constants.ON_LOADING_FINISHED, this.loadFinishedFun);
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_BROWSER_VIEW_ABOUT, msg);
    this.navigationBroadCast.off(NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION_BACK,
      this.funcOnMediaOperationBack);
    this.navigationBroadCast.off(NavigationConstants.LOAD_PAGE, this.loadNavigationPageFun);
    this.browserController.setIsBrowserFullShow(false);
    this.browserController.unregisterBroadCast(this.broadCast);
    this.getUIContext()?.getHostContext()?.eventHub.off(BroadCastConstants.ON_PAGE_SHOW, this.onIndexPageShowFunc);
    this.broadCast.off(BroadCastConstants.SLIDESHOW_CHANGE_INDEX, this.slideShowChangeIndexFunc);
    this.browserController.unregisterCallback(LibraryConstants.EDITOR_INIT, this.editorInitFunc);
    this.browserController.unregisterCallback(LibraryConstants.LAST_CAPTURE_MEDIAURI_UPDATE,
      this.updateIsLastCaptureMediaUriUpdateFunc);
    this.browserController.unregisterCallback(LibraryConstants.MENU_KEY_UPDATE_CALLBACK, this.updateMenuFunc);
    this.browserController.unregisterCallback(LibraryConstants.KEY_UPDATE_ACTION_BAR_TITLE,
      this.onUpdateActionBarTitleFunc);
    this.browserController.unregisterCallback(LibraryConstants.JUMP_TO_SLIDE_SHOW, this.jumpToSlideShowPageFunc);
    this.browserController.unregisterCallback(LibraryConstants.MENU_KEY_BACK_CALLBACK, this.onMenuClickedForBackFunc);
    this.browserController.unregisterCallback(LibraryConstants.PHOTO_SCALED, this.setPhotoScaledFunc);
    this.browserController.unregisterCallback(LibraryConstants.MENU_KEY_INFO_CALLBACK, this.onMenuClickedForInfoFunc);
    this.browserController.unregisterCallback(LibraryConstants.UPDATE_CURRENT_INDEX, this.updateCurrentIndexFunc);
    this.browserController.unregisterCallback(LibraryConstants.UPDATE_PREPARED_INDEX, this.updatePreparedIndexFunc);
    this.browserController.unregisterCallback(LibraryConstants.UPDATE_HIDE_POPUP, this.updateHidePopupFunc);
    this.browserController.unregisterCallback(LibraryConstants.ON_TOGGLE_BARS_CALLBACK, this.onToggleBarsFunc);
    // 退出沉浸式
    this.browserController.unregisterCallback(LibraryConstants.SHOW_BARS_CALLBACK, this.showBarsFunc);
    // 进入沉浸式
    this.browserController.unregisterCallback(LibraryConstants.HIDE_BARS_CALLBACK, this.hideBarsFunc);
    this.browserController.unregisterCallback(LibraryConstants.UPDATE_DELETING, this.updateDeletingFunc);
    this.browserController.unregisterCallback(LibraryConstants.UPDATE_HIDING, this.updateHidingFunc);
    // 返回下拉参数
    this.browserController.unregisterCallback(LibraryConstants.GET_IS_PULLING_DOWN, this.getIsPullingDownFunc);
    // 返回上划参数
    this.browserController.unregisterCallback(LibraryConstants.CONTROLLER_BACK_EVENT, this.controllerBackEventFunc);
    this.browserController.unregisterCallback(LibraryConstants.PHOTOSHM_CONTROLLER_BACK_EVENT,
      this.photosHmcontrollerBackEventFunc);
    this.browserController.unregisterCallback(LibraryConstants.JUMP_TO_EDIT_PAGE, this.jumpToEditPageFunc);
    this.browserController.unregisterCallback(LibraryConstants.JUMP_TO_WALLPAPER_EDITOR,
      this.jumpToWallpaperEditorFunc);
    this.browserController.unregisterCallback(LibraryConstants.JUMP_TO_MOVE_TO_ALBUM, this.jumpToMoveToAlbumFunc);
    this.browserController.unregisterCallback(LibraryConstants.UPDATE_SYSTEM_UI, this.updateSystemUiFunc);
    this.browserController.unregisterCallback(LibraryConstants.DELETE, this.doDeleteFunc);
    this.browserController.unregisterCallback(LibraryConstants.VIDEO_IS_MUTE, this.updateSoundFilledStateFunc);
    this.browserController.unregisterCallback(LibraryConstants.VIDEO_SOUND_FILLED, this.updateSoundFilledFunc);
    this.browserController.unregisterCallback(LibraryConstants.VIDEO_PLAYING_STATE, this.updateVideoPlayingStateFunc);
    this.browserController.unregisterCallback(LibraryConstants.VIDEO_IS_PLAYING, this.updateVideoPlayingFunc);
    this.browserController.unregisterCallback(LibraryConstants.UPDATE_VIDEO_STATE, this.updateVideoStateFunc);
    this.browserController.unregisterCallback(LibraryConstants.VIDEO_PLAY, this.videoPlayFunc);
    this.browserController.unregisterCallback(LibraryConstants.VIDEO_PAUSE, this.videoPauseFunc);
    this.browserController.unregisterCallback(LibraryConstants.GET_VIDEO_STATUS, this.getVideoStatusFunc);
    this.browserController.unregisterCallback(LibraryConstants.UPDATE_ACTIONBAR_POSITION);
    if (DeviceInfo.isSmallFoldScreen()) {
      getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    }
    this.appBroadCast.off(BroadCastConstants.UPDATE_MENU_BEFORE_PLAY_VIDEO, this.updateMenuBeforePlayFunc);
    this.appBroadCast.off(BroadCastConstants.VIDEO_PLAY_COMPLETED, this.videoPlayCompletedFunc);
    this.appBroadCast.off(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, this.videoPlaySwiperIndexChangedFunc);
    this.appBroadCast.off(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, this.initVideoPlayFunc);
    this.appBroadCast.off(BroadCastConstants.UPDATE_MENU_ON_AUDIO_INTERRUPT, this.videoInterruptByOtherAppFunc);
    this.appBroadCast.off(BroadCastConstants.SET_WAITING_DONE_CALLBACK, this.setWaitingDoneCallbackFunc);
    this.appBroadCast.off(BroadCastConstants.CHANGE_PLAY_BUTTON_STATUS, this.changePlayButtonStatusFunc);
    this.appBroadCast.off(BroadCastConstants.UPDATE_SHOW_MOVING_PHOTO_STATUS, this.updateShowMovingPhotoStatusFunc);
    this.appBroadCast.off(BroadCastConstants.UPDATE_CLOUD_ENHANCE_CLICKED_STATUS,
      this.updateCloudEnhanceClickedStatusFunc);
    this.appBroadCast.off(BroadCastConstants.ON_SWIPER_ANIMATION_CHANGE, this.getSwiperAnimationStateFunc);
    this.appBroadCast.off(BroadCastConstants.UPDATE_CLOUD_ENHANCE_TRIGGER_STATUS,
      this.updateCloudEnhanceTriggerStatusFunc);
    this.appBroadCast.off(BroadCastConstants.SHOW_PHOTO_BY_INDEX,
      this.showPhotoByIndexFunc);
    this.appBroadCast.off(BroadCastConstants.SWIPER_CHANGE_AFTER_CONVERT,
      this.jumpToJPGFunc);
    this.appBroadCast.off(BroadCastConstants.SHOW_CONVERT_LOADING_PANEL, this.convertJpgTimeoutFunc);
    this.appBroadCast.off(BroadCastConstants.SHOW_FAST_PLAY_LABEL, this.showOverlayFunc);
    this.appBroadCast.off(BroadCastConstants.EFFECT_MODE_SWITCH_CLICKED, this.onEffectModeSwitchClicked);
    this.appBroadCast.off(BroadCastConstants.DOWNLOAD_ORIGIN_PHOTO_RESULT,
      this.downloadOriginPhotoResultFunc);
    // this.editorController?.release();
    this.appBroadCast.off(BroadCastConstants.SHOW_WALLPAPER, this.setShowWallpaper);
    this.getUIContext().getHostContext()?.eventHub.off(BroadCastConstants.PHOTO_BROWSER_ON_PAGE_SHOW,
      this.onPageShowFunc);
    this.getUIContext().getHostContext()?.eventHub.off(BroadCastConstants.PHOTO_BROWSER_ON_PAGE_HIDE,
      this.onPageHideFunc);
    // this.browserController.dataSource?.releaseTempData();
    if (this.browserController.pixmap) {
      this.browserController.releasePixelMap();
      this.imageInfo = undefined;
    }
    if (this.videoPlayController) {
       VideoPlayController.release();
    }
    this.browserController.browserAnimController.release();
    if (!PhotoConfig.isLibrary()) {
      this.browserController.dataSource?.release();
    }
    this.broadCast.release();
    this.browserController.isPhotoBrowserViewShow = false;
    this.isEditorShown = false;
    // IT4删掉
    this.browserController.stateMachine.setCurrentState(PhotoBrowserInitState.getInstance());
  }

  private async updateAppLockShow() {
    try {
      this.userId = await this.getUserId();
      // this.isAppLockShow = await appLock.isAppProtected(Constants.PHOTO_BUNDLE_NAME, { userId: this.userId });
      Log.info(TAG, `updateAppLockShow isAppLockShow = ${this.isAppLockShow}`);
    } catch (e) {
      Log.error(TAG, `updateAppLockShow has error: ${e?.message}, code: ${e?.code}`);
    }
  }

  private async getUserId(): Promise<number> {
    if (this.userId > 0) {
      return this.userId;
    }
    try {
      const accountManager: osAccount.AccountManager = osAccount.getAccountManager();
      this.userId = await accountManager.getForegroundOsAccountLocalId();
      return this.userId;
    } catch (e) {
      Log.error(TAG, `getUserId has error: ${e?.message}, code: ${e?.code}`);
      return USER_ID_DEFAULT;
    }
  }

  private async windowStatusChange(): Promise<void> {
    await this.updateAppLockShow();
    this.browserController.onWindowStatusShareListen(this.windowType, this.windowStatus);
  }

  setShowWallpaper = (isShowWallpaper: boolean): void => {
    if (isShowWallpaper) {
      this.browserController.isShowWallPaper = true;
      this.browserController.isPhotoActive = false;
    } else {
      this.browserController.isShowWallPaper = false;
      this.browserController.isPhotoActive = true;
    }
  }

  getPhotoByIndex(index: number): MediaItem | undefined {
    return (this.browserController.dataSource?.getRawData(index).data);
  }

  private downloadOriginPhotoResult(result: String, uri: string): void {
    let item: MediaItem | undefined = PhotoBrowserUtils.getCurrentPhoto(
      this.browserController.dataSource, this.viewModel.getTargetIndex());
    Log.info(TAG, `download Origin Photo process: ${result}, currentUri: ${item?.uri} ${item?.getPosition()}`);
    if (uri === item?.uri) {
      if (result === 'completed') {
        this.browserController.updateMenu(this.viewModel.getCurrentIndex());
        this.browserController.updatePixMapDataSource();
        this.movingPhotoDownloadCompletedCallback(uri);
        this.videoDownloadCompletedCallback(uri);
      }
    }
  }

  private updateShowMovingPhotoStatus(isShowMovingPhoto: boolean): void {
    Log.info(TAG, `updateCloudEnhanceTriggerStatus to: ${isShowMovingPhoto}`)
    this.isShowMovingPhoto = isShowMovingPhoto;
  }

  private updateCloudEnhanceClickedStatus(clickedStatus: boolean): void {
    Log.info(TAG, `updateCloudEnhanceClickedStatus to: ${clickedStatus}`)
    this.isButtonClicked = clickedStatus;
  }

  private updateCloudEnhanceTriggerStatus(triggerStatus: boolean): void {
    Log.info(TAG, `updateCloudEnhanceTriggerStatus to: ${triggerStatus}`)
    this.isEnhanceTriggered = triggerStatus;
  }

  private showPhotoByIndex(index: number): void {
    Log.debug(TAG, `show photo by index:${index}`);
    this.swiperController.changeIndex(index, true);
  }

  private jumpToJPG(index: number, hasAnimation: boolean): void {
    Log.info(TAG, `jumpToJPG ${index} ${hasAnimation}`);
    this.swiperController.changeIndex(index, hasAnimation);
  }

  private onIsMuteChanged(): void {
    Log.info(TAG, `[videoPlayer] onIsMuteChanged, isMute: ${this.isMute}`);
    this.browserController.setIsMute(this.isMute);
    this.videoPlayController?.setVolume(this.isMute ? AvPlayConstants.AV_PLAY_MUTE : AvPlayConstants.AV_PLAY_VOLUME);
    this.browserController.updateMenu(this.viewModel.getCurrentIndex());
  }

  /**
   * 视频播放状态变化回调
   */
  changeIsVideoPlaying(): void {
    this.browserController.setVideoPlaying(this.isVideoPlaying);
  }

  onCEProtocolStatusChanged(): void {
    this.broadCast.emit(BroadCastConstants.UPDATE_CLOUD_ENHANCE_PROTOCOL_STATUS, [this.agreedCloudEnhanceProtocol]);
  }

  private isFullModeChanged(): void {
    this.isFullModeEnhancer = getScreen().isFullMode();
  }

  /**
   * 视频点击播放的回调
   */
  private updateMenuBeforePlay(): void {
    Log.info(TAG, `[videoPlayer] updateMenuBeforePlay current isShowVideo: ${this.isShowVideo},make it true.`);
    this.isShowBottomToolBar = true;
    this.isShowVideo = true;
    this.browserController.setIsShowVideo(this.isShowVideo);
    // 底部Menu 发生变化
    this.browserController.updateMenu(this.viewModel.getCurrentIndex(), true);
  }

  /**
   * 视频点击完成回调
   */
  private videoPlayCompleted(): void {
    this.isVideoPlaying = true;
    this.updateVideoState();
  }

  /**
   * 执行图库大图返回回调
   *
   * @param callback 回调具体实现
   */
  photosHmControllerBackEvent(callback: Function): void {
    callback(this.viewModel.isPullingUp, this.editorController?.onBackPress(),
      this.swiperController, this.needUnlock, () => { this.browserController.isBrowserShow = false;});
  }

  /**
   * 视频设置声音回调
   *
   * @param volume 音量值
   */
  updateSoundFilled(volume: number): void {
    Log.info(TAG, `[videoPlayer] updateSoundFilled, volume: ${volume}`);
    // this.videoPlayController?.setVolume(volume);
    this.isMute = !this.isMute;
    this.browserController.updateMenu(this.viewModel.getCurrentIndex(), true);
  }

  /**
   * 更新视频播放/暂停信息
   */
  updateVideoPlaying(): void {
    Log.info(TAG, 'updateVideoPlaying ');
    let currentPlayerState: string | undefined = this.videoPlayController?.getAvPlayerState();
    if (this.isVideoPlaying && currentPlayerState === AvplayerStatus.PAUSED) {
      this.videoPlayController?.play();
      this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS, [AvplayerStatus.PLAYING]);
    }
    if (this.isVideoPlaying && currentPlayerState === AvplayerStatus.COMPLETED) {
      this.videoPlayController?.play();
    }
    if (!this.isVideoPlaying && currentPlayerState === AvplayerStatus.PLAYING) {
      this.videoPlayController?.pause(PauseReason.OTHERS);
      this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS, [AvplayerStatus.PAUSED]);
    }
    this.isVideoPlaying = !this.isVideoPlaying;
    this.browserController.updateMenu(this.viewModel.getCurrentIndex(), true);
  }

  /**
   * 更新isVideoPlaying
   */
  setIsVideoPlaying(isVideoPlaying: boolean): void {
    this.isVideoPlaying = isVideoPlaying
  }

  /**
   * 视频切换的回调
   */
  private videoPlaySwiperIndexChanged(): void {
    Log.info(TAG, 'VideoPlaySwiperIndexChanged start ');
    this.isVideoPlaying = true;
    this.updateVideoState();
  }

  /**
   * 更新视频状态信息
   */
  private updateVideoState(): void {
    Log.info(TAG, `[videoPlayer] updateVideoState isShowVideo : ${this.isShowVideo},make it false, isVideoPlaying : ${
    this.isVideoPlaying}`);
    this.isShowVideo = false;
    this.isShowBottomToolBar = false;
    this.browserController.setIsShowVideo(this.isShowVideo);
    this.browserController.updateMenu(this.viewModel.getTargetIndex(), this.isShowVideo);
  }

  private initVideoPlay(vpc: VideoPlayController): void {
    Log.info(TAG, `[videoPlayer] bind controller:${vpc.getLabel()} to ${this.pcCurItem?.uri}`);
    this.videoPlayController = vpc;
    this.videoPlayController?.setPlayingEnhancer(this.onVideoPlayingCallback);
    this.videoPlayController?.setPauseEnhancer(this.onVideoPausedCallback);
    this.videoPlayController?.setCompletedEnhancer(this.onVideoCompletedCallback);
  }

  /**
   * 注册回调函数Begin
   *
   * @param menuList 菜单支持用户 Action 列表
   * @param toolMenuList 工具栏菜单支持用户 Action 列表
   * @param moreMenuList 更多菜单支持用户 Action 列表
   */
  updateMenu(menuList: Action[], toolMenuList: Action[],
    moreMenuList: Action[]): void {
    Log.info(TAG, `menuList.Len: ${menuList?.length}, toolMenuList.Len: ${toolMenuList?.length
    }, moreMenuList.Len: ${moreMenuList?.length}`);
    if (menuList) {
      this.menuList = menuList;
    }
    if (toolMenuList) {
      if (!this.isShowPhoneRotate) {
        // 畅连场景临时方案：仅显示暂停/播放按钮、声音按钮；后续畅连接入预览框架
        this.toolMenuList = toolMenuList.slice(2, 4);
      } else {
        this.toolMenuList = toolMenuList;
      }
    }
    if (moreMenuList) {
      this.moreMenuList = moreMenuList;
    }
  }

  /**
   * 更新顶部 ActionBar 日期信息
   *
   * @param photoDate 图片日期信息
   * @param timeAndLocation 图片时间、地点信息
   */
  onUpdateActionBarTitle(photoDate: string, timeAndLocation: string): void {
    Log.info(TAG, 'onUpdateActionBarTitle');
    this.photoDate = photoDate;
    this.timeAndLocation = timeAndLocation;
  }

  private jumpToSlideShowPage(): void {
    let dataSource = this.browserController.dataSource.getAlbumDataSource();
    if (!dataSource) {
      Log.error(TAG, 'jumpSlideShowPage dataSource is undefined');
      return;
    }
    let params: SlideShowParams = {
      items: this.browserController.dataSource,
      broadCast: this.broadCast,
      currentIndex: this.viewModel.getCurrentIndex(),
    }
    this.navPageInfos.pushPath(
      new NavPathInfo(NavigationConstants.NAVIGATION_SLIDE_SHOW_PAGE, params));
  }

  private slideShowChangeIndex(index: number): void {
    Log.info(TAG, `slideShowChangeIndex: ${index}`);
    this.viewModel.setCurrentIndex(index);
  }

  /**
   * 菜单栏点击返回 Back
   */
  onMenuClickedForBack(isNoPhotos: boolean): void {
    Log.info(TAG, 'onMenuClickedForBack');
    if (isNoPhotos) {
      this.showNoPhotosAnimation();
    } else {
      this.resetStateAndBack();
    }
  }

  /**
   * 重置视频播放相关状态并返回
   */
  private resetStateAndBack(isPlayAni: boolean = true): void {
    if (this.browserController.pixmap && (this.isRunningAnimation || !this.isLastCaptureMediaUriUpdate)) {
      this.onBackPressInner(isPlayAni);
    } else {
      this.swiperController.finishAnimation((): void => this.onBackPressInner(isPlayAni));
    }
    this.isShowVideo = false;
    this.isVideoPlaying = false;
    this.videoPlayController?.reset();
    this.browserController.setIsShowVideo(this.isShowVideo);
  }

  /**
   * 删除最后一张图片的淡出返回动效
   */
  private showNoPhotosAnimation(): void {
    this.isShowFadeOutAnim = true;
    if (this.browserController.pageFrom === BrowserCaller.CAMERA_PAGE && this.browserController.getIsBrowserFullShow()) {
      this.broadCast.emit(BroadCastConstants.CHANGE_LOADING_STATUS, [true]);
      this.browserController.emitCallback(LibraryConstants.BROWSER_FULL_SHOW, [false]);
    }
    this.onDeleteAllPhoto();
    Log.info(TAG, 'delete All Photo callback end');
    if (this.browserController.pageFrom === BrowserCaller.CAMERA_PAGE) {
      animateTo({
        duration: NO_PHOTOS_TRANSITION_DURATION,
        onFinish: () => {
          this.resetStateAndBack(false);
        }
      }, () => {
        this.geometryOpacity = 0;
      })
    } else {
      this.resetStateAndBack(false);
    }
  }

  /**
   * 点击唤出详情回调
   *
   * @param isPullingUp 是否上滑标志位
   * @param isPullingDown 是否下拉标志位
   * @param disableSwipe 是否禁止 Swiper 水平滑动
   */
  onMenuClickedForInfo(isPullingUp: boolean, isPullingDown: boolean, disableSwipe: boolean): void {
    Log.info(TAG, `onMenuClickedForInfo isPullingUp: ${isPullingUp}, isPullingDown: ${
    isPullingDown}, disableSwipe: ${disableSwipe}`);
    // 下拉
    if (isPullingDown !== undefined && isPullingDown !== null) {
      this.isPullingDown = isPullingDown;
    }
    if (disableSwipe !== undefined && disableSwipe !== null) {
      this.disableSwipe = disableSwipe;
    }
  }

  /**
   * 更新图片 index 信息
   *
   * @param currentIndex 当前图片 index 信息
   */
  updateCurrentIndex(currentIndex: number): void {
    Log.info(TAG, `updateCurrentIndex, currentIndex: ${currentIndex}`);
    this.viewModel.setCurrentIndex(currentIndex);
    this.forceRefresh++;
    this.updatePreparedIndex(currentIndex);
    this.appBroadCast.emit(BroadCastConstants.CAST_INDEX_CHANGED, [currentIndex, false, false]);
  }

  private updatePreparedIndex(targetIndex: number): void {
    this.changeCurrentItem(targetIndex);
  }

  updateHidePopup(hidePopup: boolean): void {
    Log.info(TAG, `updateHidePopup, hidePopup: ${hidePopup}`);
    this.hidePopup = hidePopup;
  }

  /**
   * 修改顶部栏、底部栏显示/消失状态，和进入/退出沉浸式效果相匹配
   *
   * @param backgroundColorResource
   */
  onToggleBars(backgroundColorResource?: Resource): void {
    if (this.isShowBar && !DeviceInfo.isPc()) {
      this.hideBars(backgroundColorResource);
      this.appBroadCast.emit(BroadCastConstants.IS_SHOW_OR_HIDE_BAR, [true]);
    } else {
      this.showBars(backgroundColorResource);
      this.appBroadCast.emit(BroadCastConstants.IS_SHOW_OR_HIDE_BAR, [false]);
    }
  }

  /**
   * 展示大图页顶部栏、底部栏回调
   *
   * @param backgroundColorResource 大图背景 resource
   */
  showBars(backgroundColorResource?: Resource): void {
    this.backgroundColorResource = backgroundColorResource ?
      backgroundColorResource : $r('sys.color.background_secondary');
    Log.info(TAG, `[showBars] isShowBar: ${this.isShowBar}`);
    if (!this.isShowBar) {
      this.isShowBar = true;
      if (!this.isHorizontal && !this.isHalfFold) {
        this.browserController.setSystemUi(true);
      }
      this.browserController.setIsShowBar(this.isShowBar);
      let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.viewModel.getTargetIndex());
      this.browserController.getActionBarSubtitle(currentPhoto);
    } else {
      this.onlyChangeBgColor = !this.onlyChangeBgColor;
    }
  }

  /**
   * 隐藏大图页顶部栏、底部栏回调
   *
   * @param backgroundColorResource 大图背景 resource
   */
  hideBars(backgroundColorResource?: Resource): void {
    this.backgroundColorResource = backgroundColorResource ? backgroundColorResource : $r('app.color.black');
    Log.info(TAG, `[hideBars] isShowBar: ${this.isShowBar}`);
    if (this.isShowBar || this.isHalfFold) {
      this.isShowBar = false;
      this.browserController.setSystemUi(false);
    } else {
      this.onlyChangeBgColor = !this.onlyChangeBgColor;
    }
  }

  /**
   * 更新是否执行删除动效标志位
   *
   * @param isDeleting 是否正在执行删除东西哦啊标志位
   */
  updateDeleting(isDeleting: boolean): void {
    this.isDeleting = isDeleting;
  }

  updateHiding(isHiding: boolean): void {
    this.isHiding = isHiding;
  }

  /**
   * 执行大图下拉回调
   *
   * @param callback 回调具体实现
   */
  getIsPullingDown(callback: Function): void {
    callback(this.isPullingDown);
  }

  /**
   * 执行大图上滑回调
   *
   * @param callback 回调具体实现
   */
  controllerBackEvent(callback: Function): void {
    callback(this.viewModel.isPullingUp, this.editorController?.onBackPress(), this.isShowVideo,
      this.videoPlayController?.getAvPlayerState() === AvplayerStatus.PLAYING, this.isSwiperOffsetZero);
  }

  /**
   * 执行更新声音状态回调
   *
   * @param callback 回调具体实现
   */
  updateSoundFilledState(callback: Function): void {
    callback(this.isMute);
  }

  /**
   * 执行更新视频播放状态回调
   *
   * @param callback 回调具体实现
   */
  updateVideoPlayingState(callback: Function): void {
    callback(this.isVideoPlaying);
  } // 注册回调函数End

  /**
   * 页面状态更新
   */
  onPageChanged(): void {
    Log.info(TAG, `call page status changed ${this.pageStatus}`);
    if (this.browserController.pageFrom === BrowserCaller.CAMERA_PAGE) {
      return;
    } else {
      if (this.pageStatus) {
        this.onPageShow();
        return;
      }
      this.onPageHide();
    }
  }

  /**
   * 设置系统 UI 风格
   */
  updateSystemUi(): void {
    if (PhotoConfig.isLibrary() && (this.isHorizontal || this.isHalfFold)) {
      this.browserController.setSystemUi(false);
      return;
    }
    if (!this.isHorizontal) {
      this.browserController.setSystemUi(this.isShowBar);
    }
  }

  /**
   * 读取背景边距信息
   *
   * @returns 背景边距信息
   */
  getBgPadding(): Padding {
    let backgroundPadding: Padding = {
      top: Constants.ActionBarHeight + (this.isHorizontal ? 0 : px2vp(this.statusBarHeight)),
    };
    Log.info(TAG, `getBgPadding ${JSON.stringify(backgroundPadding)}`);
    return backgroundPadding;
  }

  /**
   * 更行横竖屏状态
   */
  updateIsHorizontal(): void {
    this.updateSystemUi();
    this.browserController.updateMenu(this.viewModel.getCurrentIndex(), this.isShowVideo);
  }

  /**
   * 大图组件展示回调，同所在页面 onPageShow 生命周期配合调用
   */
  onPageShow(): void {
    Log.info(TAG, 'onPageShow');
    /* instrument ignore next */
    if (DeviceInfo.isSmallFoldScreen() && !this.isHalfFold) {
      this.actionBarPositionY = Constants.PERCENT_0;
    }
    if (!this.editorController?.isEditorShown &&
      !this.browserController.isShowWallPaper) {
      this.browserController.isPhotoActive = true;
    }
    this.browserController.onPageShowSwing();
    if ((DeviceInfo.isPhoneUx() && !FoldUtil.isTriExpand(this.curFoldStatus))) {
      Log.info(TAG, 'update card detail width');
      this.appBroadCast.emit(BrowserConstants.UPDATE_CARD_WIDTH, []);
    }
    if (this.viewModel.isPullingUp) {
      this.hideBars($r('sys.color.comp_background_gray'));
    } else if (!this.isHorizontal && this.isShowBar && !this.isHalfFold) {
      this.browserController.setSystemUi(true);
    }
    this.browserController.onPageShowEnd(this.editorController?.isEditorShown ?? false);
    if (this.browserController.browserAnimController.isTransitionEnable &&
      this.browserController.pageFrom === BrowserCaller.VIEWDATA_PAGE) {
      this.viewModel.processEnterAnimationEndEvent();
    }
    if (accessibility.isOpenTouchGuideSync()) {
      this.isOpenTouchGuide = true;
    }
  }

  /**
   * 大图组件隐藏回调，同所在页面 onPageHide 生命周期配合调用
   */
  onPageHide(): void {
    Log.info(TAG, 'onPageHide');
    this.browserController.isPhotoActive = false;
    this.browserController.onPageHideSwing();
    this.isCloudEnhanceShowPrevious = false;
    // 大图组件隐藏，设置状态栏隐藏
    if (this.viewModel.isPullingUp) {
      this.hideBars();
    }

    // 打开弹窗时，切后台，需要关闭弹窗
    if (this.browserController.pageFrom === BrowserCaller.CAMERA_PAGE ||
      this.browserController.pageFrom === BrowserCaller.HIDDEN_ALBUM ||
      this.browserController.pageFrom === BrowserCaller.HIDDEN_GRID_ALBUM) {
      this.dialogBroadCast.emit(BroadCastConstants.HIDE_DELETE_DIALOG, []);
      this.dialogBroadCast.emit(BroadCastConstants.HIDE_HIDDEN_DIALOG, []);
      this.dialogBroadCast.emit(BroadCastConstants.HIDE_RENAME_PHOTO_DIALOG, []);
      this.dialogBroadCast.emit(BroadCastConstants.HIDE_PROMPT_DIALOG, []);
      this.dialogBroadCast.emit(BroadCastConstants.HIDE_NEW_ALBUM_PHOTO_DIALOG, []);
    }

    this.browserController.onPageHideEnd();
    // 当视频正在播放的时候，从前台变成后台的时候，需要暂停播放
    if (this.videoPlayController && this.browserController.pageFrom === BrowserCaller.CAMERA_PAGE &&
    this.isShowVideo && this.videoPlayController?.getAvPlayerState() === AvplayerStatus.PLAYING) {
      this.videoPlayController?.pause(PauseReason.OTHERS);
      this.videoPlayController?.reset();
    }
    if (this.browserController.pageFrom === BrowserCaller.HIDDEN_ALBUM && !this.needUnlock) {
      this.updateNeedUnlockState();
      this.pullUnlockDialog = !this.needUnlock;
    }
  }

  /**
   * 大图页 Back 键响应回调
   */
  onBackPressInner(isPlayAni: boolean): void {
    this.isShowLoading = false;
    Log.info(TAG, `onBackPressInner, isDoDeleteAnim: ${this.isDoDeleteAnim} isHidden = ${this.isHidden}`);
    this.appBroadCast.emit(BroadCastConstants.CLICK_BACK_PRESS, []);
    if (this.isDoDeleteAnim || this.isHidden) {
      return;
    }
    Log.info(TAG, `onBackPressInner next`)
    this.browserController.onPhotoChanged(this.viewModel.getCurrentIndex());
    this.appBroadCast.emit(BroadCastConstants.PHOTO_PHOTO_BACK_PRESS, []);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_VIDEO_BACK_PRESS, []);
    this.browserController.isPhotoBrowserViewShow = false;
    if (this.browserController.getIsBrowserFullShow()) {
      this.broadCast.emit(BroadCastConstants.CHANGE_LOADING_STATUS, [true]);
      this.browserController.emitCallback(LibraryConstants.BROWSER_FULL_SHOW, [false]);
    }
    this.hidePhotoBrowser(isPlayAni, this.viewModel.getCurrentIndex());
    this.browserController.dataSource?.releaseTempData();
  }

  /**
   * 跳转编辑页面回调
   *
   * @param item
   */
  jumpToEditPage(item: MediaItem, isRemoteSource: boolean): void {
    if (this.isScrolling) {
      Log.info(TAG, `jumpToEditPage return, isScrolling:: ${this.isScrolling}`);
      return;
    }
    Log.info(TAG, `isRemoteResource value: ${isRemoteSource}`);
    TraceControllerUtils.startTrace('PhotoBrowserView.initEditor');
    this.initEditor();
    TraceControllerUtils.finishTrace('PhotoBrowserView.initEditor');
    if (!this.editorController) {
      Log.error(TAG, 'editorController is undefined');
      return;
    }
    this.browserController.isPhotoActive = false;
    if (isRemoteSource) {
      this.editorController.imageEditorParams.position = UserFileManagerAccess.FILE_LOCATION_CLOUD;
    }
    this.browserController.setEditorContext();
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.viewModel.getTargetIndex());
    this.swiperController.finishAnimation((): void => {
      Log.info(TAG, `showEditor item: ${JSON.stringify(item)}`);
      let dataSource: MediaDataSource | undefined = this.browserController.dataSource.getAlbumDataSource();
      let albumUri: string = dataSource ? dataSource.albumUri : '';
      this.editorController?.showEditor(albumUri, item);
    })
  }

  onNetworkAvailableChanged(): void {
    Log.info(TAG, `networkAvailable Changed: ${this.networkAvailable}`);
    this.browserController.setNetworkAvailable(this.networkAvailable);
  }

  jumpToMoveToAlbum(pageFrom: string, pageType: string, mediaType: number, albumInfo?: AlbumInfo,
    blackUris?: string[], browserControllerId?: number): void {
    interface ParamsNavigation {
      pageFrom: string;
      pageType: string;
      mediaType: number;
      albumInfo?: AlbumInfo;
      blackUriList?: string[];
      browserControllerId?: number;
    }

    let params: ParamsNavigation = {
      pageFrom: pageFrom,
      pageType: pageType,
      mediaType: mediaType,
      albumInfo: albumInfo,
      blackUriList: blackUris,
      browserControllerId: browserControllerId,
    }
    Log.info(TAG, `jumpToMoveToAlbum params: ${JSON.stringify(params)}`);
    this.navPageInfos.pushPath(
      new NavPathInfo(NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION, params));
  }

  jumpToWallpaperEditor(mediaUri: string, lcdUri: string): void {
    interface SetWallpaperParams {
      imageUri: string,
      lcdUri: string,
      pixelMap: PixelMap| undefined,
    }

    let result = this.browserController.dataSource?.getData(this.stateMachine.getCurrentIndex())
    let pixelMap = result?.thumbnail?.pixelMap as PixelMap ?? result?.thumbnail?.yuvPixelMap;
    Log.info(TAG, `jumpToWallpaperEditor: ${pixelMap}`);

    let params: SetWallpaperParams = {
      imageUri: mediaUri,
      lcdUri: lcdUri,
      pixelMap: pixelMap,
    }

    this.navPageInfos.pushPath(
      new NavPathInfo(NavigationConstants.NAVIGATION_WALLPAPER_EDITOR, params, (result) => {
        if (result.result) {
          // 设置壁纸后返回大图，尝试重新连接扩展屏
          Log.info(TAG, `wallpaper back try start cast ${result.result}`);
          this.browserController.isPhotoActive = true;
          this.browserController.isShowWallPaper = false;
        }
      }));
    this.browserController.isPhotoActive = false;
    this.browserController.isShowWallPaper = true;
  }

  @Builder
  PageMap(name: string, param: Object) {
    if (name === NavigationConstants.NAVIGATION_WALLPAPER_EDITOR) {
      WallpaperEditorLoader({
        navPageInfos: this.navPageInfos,
      })
    } else if (name === NavigationConstants.NAVIGATION_SLIDE_SHOW_PAGE) {
      SlideShowPageLoader({
        navigationPageInfos: this.navPageInfos,
      })
    } else if (name === NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION) {
      MediaOperationBasePageLoader()
    } else if (name === NavigationConstants.NAVIGATION_PRIVACY_VIEWER) {
      this.navigationPageLoader();
    }
  }

  private isShowPhoto(): boolean {
    if (!PhotoConfig.isLibrary()) {
      return true;
    }
    if (!this.browserController.dataSource.getAlbumDataSource()) {
      return false;
    }
    if (this.thumbSource.totalCount() <= 0) {
      this.thumbSource.setPhotoDataSource(this.browserController.dataSource);
    }
    return true;
  }

  build() {
    Navigation(this.navPageInfos) {
      Stack() {
        if (this.thumbnailShow) {
          this.buildEditorMain();
        }
        if (this.isShowPhoto() && !this.isLazyLoading) {
          this.buildPhotoBrowserComponent();
        }
      }
      .expandSafeArea(this.stateMachine.isPropertiesShow() ? [] : [SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM])
      .hitTestBehavior(this.editorController?.isInSwitchAnimation ? HitTestMode.Block : HitTestMode.Default)
    }
    .navDestination(this.PageMap)
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
    .onKeyEvent((event: KeyEvent) => {
      Log.info(TAG, `onKeyEvent keyCode:${event.keyCode}, type: ${event.type}`);
      if (event.type === KeyType.Down) {
        return false;
      }
      if (event.keyCode === KeyCode.KEYCODE_ESCAPE) {
        if (this.editorController?.isImageEditorShown || this.editorController?.isMovingPhotoEditorShown) {
          Log.info(TAG, `emit edit page press esc`);
          this.appBroadCast.emit(BroadCastConstants.PHONE_EDIT_PAGE_PRESS_ESC);
          return true;
        }
      }
      return false;
    })
  }

  // 编辑组件
  @Builder
  buildEditorMain() {
    if (this.editorController?.isImageEditorShown) {
      // 图片编辑组件
      ImageEditorMain({
        params: this.editorController?.imageEditorParams,
        status: this.editorController?.imageEditorStatus,
        onMessageCallback: (msg: ImageEditorMsg) => {
          Log.info(TAG, 'onMessageCallback ImageEditorMain');
          return this.editorController?.onEditorMessageCallback(msg);
        }
      })
    }
  }

  private editorInit(): void {
  }

  // 大图组件
  @Builder
  buildPhotoBrowserComponent() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {
        BackgroundView({
          isShowBar: $isShowBar, isFromPhotoBrowser: true,
          avoidOverdrawPadding: this.editorController?.isInSwitchAnimation ? this.getBgPadding() : null,
        })
          .opacity(this.geometryOpacity)
          .transition(TransitionEffect.asymmetric(
            BrowserConstants.OPEN_EFFECT,
              this.browserController.isDrag ? TransitionEffect.opacity(0) : BrowserConstants.CLOSE_EFFECT
          ))
          .enabled(!this.isPullDownAndDragPhoto)
      }
      .attributeModifier(this.viewModel.bgViewColumnModifier)
      .width(Constants.PERCENT_100)
      .height(Constants.PERCENT_100)
      .visibility(this.viewModel.bgViewVisible)

      if (this.isThumbnailViewShow) {
        ThumbnailView({
          stateMachine: this.stateMachine,
          thumbnailShow: this.thumbnailShow,
          isRunningAnimation: this.isRunningAnimation
        })
      }

      if (this.thumbnailShow) {
        this.buildSwiperView();
        this.buildPhotoBrowserBarComponent();
        this.buildBlurImageComponent();
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
    }
    .opacity(this.calcPhotoBrowserComponentOpacity())
    .visibility((!this.editorController || this.editorController.isBrowserShown) &&
      !(this.needUnlock && this.browserController.pageFrom === BrowserCaller.HIDDEN_ALBUM) ?
      Visibility.Visible : Visibility.Hidden)
  }

  private calcPhotoBrowserComponentOpacity() {
    return this.editorController === undefined ? 1 : this.editorController.opacity;
  }

  private getBrowserMarginBottom(): number {
    Log.info(TAG, `bottom: ${this.diggingHoleCameraArea.bottom}`);
    return (!DeviceInfo.isFoldablePhone() && !DeviceInfo.isGRLFoldScreen()) ?
      (this.diggingHoleCameraArea.bottom ?? 0) : 0;
  }

  /**
   * 下拉使用，用于控制顶部栏、底部栏、预览条等控件动效过程的透明度
   */
  /* instrument ignore next  */
  private calcBarComponentOpacity(): number {
    //在下拉100vp后，顶部bar、底部bar、预览条、一拍多得按钮透明度为0
    if (this.barGeometryOpacity === 0) {
      return 0;
    }
    return this.geometryOpacity;
  }

  @Builder
  buildSwiperView() {
    // 里面包含pc和phone的预览条
    SwiperView({
      stateMachine: this.stateMachine,
      swiperController: this.swiperController,
      canPullingUp: this.canPullingUp,
      geometryTransitionEnable: true,
      isThumbnailViewReAdapt: false,
      broadCast: this.broadCast,
      isRunningAnimation: $isRunningAnimation,
      isPullDownAndDragPhoto: $isPullDownAndDragPhoto,
      thumbSource: this.thumbSource,
      isShowThumbSource: this.isShowThumbSource,
      isInSwiperAnimation : this.isInSwiperAnimation,
      isShowImageAnalyzer: this.isShowImageAnalyzer,
      isShowBar: $isShowBar,
      forceRefresh: this.forceRefresh,
      isEditorShown: this.editorController?.isEditorShown,
      curHiSearchWords: this.curHiSearchWords,
      swiperOpacityWithBurstPhotos: this.swiperOpacityWithBurstPhotos,
      centerPreviewOpacity: this.centerPreviewOpacityWithBurst,
      isSlideBarShow: $isSlideBarShow,
      onPhotoSingleClick: this.onPhotoSingleClick,
      isVideoPlaying: this.isVideoPlaying,
      pcCurItem: this.pcCurItem,
      isPrivateHideState: this.browserController.isPrivateHideState,
      isScrolling: this.isScrolling
    })
      .onAppear(() => {
        if (this.browserController.pageFrom === BrowserCaller.VIEWDATA_PAGE) {
          this.broadCast.emit(BrowserConstants.DATA_LOAD_FINISH_PREVIEWER_REFRESH, []);
        }
      })
      .margin({ bottom: this.getBrowserMarginBottom() })
      .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
        if (gestureInfo.type === GestureControl.GestureType.PAN_GESTURE &&
          this.browserController.pageFrom !== BrowserCaller.CAMERA_PAGE) {
          /* instrument ignore next */
          Log.info(TAG, 'photosHm SwiperView PANGESTURE reject!');
          /* instrument ignore next */
          return GestureJudgeResult.REJECT;
        }
        return GestureJudgeResult.CONTINUE;
      })
      .opacity(this.isShowFadeOutAnim ? this.geometryOpacity : 1)
      .gestureModifier(this.swiperViewModifier)
      .accessibilityLevel('yes')
  }

  // 大图标题栏与操作栏
  @Builder
  buildPhotoBrowserBarComponent() {
    if ((this.isShowMenu || this.notShowDate || this.isForceShowBar) && this.isShowBar) {
        // 大图顶部bar
        Column() {
          ActionBarView({
            notShowDate: this.notShowDate,
            moreMenuList: this.moreMenuList,
            onMenuClicked: (action: Action): void => this.browserController.onMenuClicked(action),
          })
            .opacity(this.geometryOpacity)
            .transition(TransitionEffect.asymmetric(
              BrowserConstants.OPEN_EFFECT_ACTIONBAR,
                this.browserController.isDrag ? TransitionEffect.opacity(0) : BrowserConstants.CLOSE_EFFECT
            ))
            .enabled(!this.isPullDownAndDragPhoto)
        }
        .position({ x: Constants.PERCENT_0, y: this.actionBarPositionY })
        .attributeModifier(this.viewModel.barModifier)
    }
    if ((this.isShowMenu || this.isShowBottomToolBar) && this.isShowBar) {
      if (!this.isHorizontal) {
        Column() {
          // 大图底部bar
          ToolBarView({
            isFromPhotoBrowser: true,
            moreMenuList: this.moreMenuList,
            isSlideBarShow: $isSlideBarShow,
          })
            .visibility((PhotoConfig.isFromMeetime &&
              (this.isFoldExpandedEnhancer && this.isFullModeEnhancer)) ?
              Visibility.Visible : !(this.isFoldExpandedEnhancer && this.isFullModeEnhancer) ?
                Visibility.Visible : Visibility.Hidden)
            .transition(TransitionEffect.asymmetric(
              BrowserConstants.OPEN_EFFECT_ACTIONBAR,
                this.browserController.isDrag ? TransitionEffect.opacity(0) : BrowserConstants.CLOSE_EFFECT
            ))
        }
        .hitTestBehavior(HitTestMode.Transparent)
        .markAnchor({ x: Constants.PERCENT_0, y: Constants.PERCENT_100 })
        .position({ x: Constants.PERCENT_0, y: Constants.PERCENT_100 })
        .attributeModifier(this.viewModel.barModifier)
        .enabled(!this.isPullDownAndDragPhoto && !this.isRunningAnimation)
      } else {
        if (PhotoConfig.isFromMeetime &&
          (this.isFoldExpandedEnhancer && this.isFullModeEnhancer)) {
          // 大图底部bar
          ToolBarView({
            isFromPhotoBrowser: true,
            moreMenuList: this.moreMenuList,
            isSlideBarShow: $isSlideBarShow,
          })
            .markAnchor({ x: Constants.PERCENT_0, y: Constants.PERCENT_100 })
            .position({ x: Constants.PERCENT_0, y: Constants.PERCENT_100 })
            .transition(TransitionEffect.asymmetric(
              BrowserConstants.OPEN_EFFECT_ACTIONBAR,
              this.browserController.isDrag ? TransitionEffect.opacity(0) : BrowserConstants.CLOSE_EFFECT
            ))
            .attributeModifier(this.viewModel.barModifier)
            .enabled(!this.isPullDownAndDragPhoto)
        }
      }
    }
    if (this.isShowMenu) {
      ShareBrowserCustomDialog()
        .opacity(this.geometryOpacity)
        .transition(TransitionEffect.asymmetric(
          TransitionEffect.OPACITY.animation({
            curve: Curves.cubicBezier(0.2, 0.0, 0.2, 1.0),
            duration: 200,
          }),
          this.browserController.isDrag ? TransitionEffect.opacity(0) : TransitionEffect.OPACITY.animation({
            curve: Curves.cubicBezier(0.2, 0.0, 0.2, 1.0),
            duration: 100,
          })
        ))
        .enabled(!this.isPullDownAndDragPhoto)
    }
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

  @Builder
  buildBlurImageComponent() {
    if (this.browserController.isPrivateHideState) {
      BlurImageComponent({
        topMargin: Constants.ActionBarHeight + (this.isHorizontal ? 0 : px2vp(this.statusBarHeight)),
        bottomMargin: Constants.ToolBarAvoidHeight,
        textMessage: this.getBlurImageComponentText(),
        accessibilityBackElementId: this.isOpenTouchGuide ? this.getAccessibilityBackElementId() : '',
        message: TAG,
      })
        .transition(this.browserController.isAnimating ? null : AnimationUtil.blurImageAnimation())
    }
  }

  private getAccessibilityBackElementId(): string {
    return Constants.COMPONENT_KEY_BUTTON_BROWSER_BACK;
  }

  private getBlurImageComponentText(): Resource {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.viewModel.getTargetIndex());
    if (!currentPhoto) {
      return $r('app.string.Private_protection_view_photos');
    }
    return currentPhoto.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO ?
      $r('app.string.show_video') : $r('app.string.Private_protection_view_photos');
  }

  // 将大图的缩放位移还原后进入连拍
  private resetBrowserTransform(currentPhoto: MediaItem | undefined): void {
    if (currentPhoto) {
      this.broadCast.emit(BroadCastConstants.JUMP_TO_BURST + currentPhoto?.uri, [() => {
      }]);
    }
  }

  /**
   * 删除图片回调
   */
  doDelete(): void {
    Log.info(TAG, `delete finish now update data currentIndex:${this.viewModel.getCurrentIndex()}`);
    this.isDeleting = true;
    if (AppStorage.get('isBigPhotoLeftToRightAnim') && this.viewModel.getCurrentIndex() === 0) {
      AppStorage.setOrCreate<boolean>('isBigPhotoLeftToRightAnim', false);
    }
    if (this.viewModel.getCurrentIndex() === this.browserController.dataSource.totalCount() - 1) {
      AppStorage.setOrCreate<boolean>('isBigPhotoLeftToRightAnim', true);
    }
    if (this.browserController.isSandboxEnv) {
      this.browserController.dataSource.onChange('image');
    }
  }

  private videoInterruptByOtherApp(isPaused: boolean): void {
    this.changePlayButtonStatus(isPaused);
  }

  private changePlayButtonStatus(isVideoPlaying: boolean): void {
    this.isVideoPlaying = isVideoPlaying;
    this.browserController.setVideoPlaying(isVideoPlaying);
    this.browserController.updateMenu(this.viewModel.getCurrentIndex());
  }

  private foldStatusChange(): void {
    try {
      display.on('foldStatusChange', this.foldStatusChangeFunc);
    } catch (err) {
      Log.error(TAG, `foldStatusChange display.on, error code : ${err.code}`)
    }
  }

  private videoPlay(): void {
    Log.info(TAG, 'video will playback by photoBrowser controller');
    if (this.videoPlayController) {
      this.videoPlayController?.play();
      this.isVideoPlaying = false;
      this.browserController.updateMenu(this.viewModel.getCurrentIndex(), true);
    }
  }

  private videoPause(): void {
    Log.info(TAG, 'video will pause by photoBrowser controller');
    if (this.videoPlayController) {
      this.videoPlayController?.pause(PauseReason.OTHERS);
      this.isVideoPlaying = true;
      this.browserController.updateMenu(this.viewModel.getCurrentIndex(), true);
    }
  }

  private getVideoStatus(callback: Function): void {
    callback(this.videoPlayController?.getAvPlayerState());
  }

  /**
   * 是否是横屏下拉返回
   *
   * @param event 手势事件
   * @returns 是否是横屏下拉返回
   */
  private isPullDownOnHorizontal(event: GestureEvent): boolean {
    return this.isHorizontal && !this.viewModel.isPullingUp && event.offsetY > 0 && !this.isPhotoScaled;
  }

  /**
   * 窗口大小变化回调
   */
  private onWinSizeChanged(): void {
    /* instrument ignore next */
    if (!this.isHorizontal) {
      setTimeout((): void => {
        this.actionBarPositionY = Constants.PERCENT_0;
      }, Constants.BROWSER_VIEW_ENTRY_ANIME_DELAY);
      Log.info(TAG, `onWinSizeChanged actionBarPositionY:${this.actionBarPositionY}`);
    }
  }

  private setWaitingDoneCallbackFunc: (callback: () => void) => void = (callback: () => void): void => {
    this.browserController.setWaitingDoneCallback(callback);
  }

  private isHalfFoldInner(): boolean {
    return this.isHalfFold && !(display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_SUB);
  }

  private editorDownloadCompletedCallbackFunc: () => void = (): void => {
  }
  private editorDownloadStopCallbackFunc: () => void = (): void => {
  }

  private movingPhotoDownloadCompletedCallback(uri: string): void {
    this.appBroadCast.emit(BroadCastConstants.MOVING_PHOTO_DOWNLOAD_CALLBACK, [uri]);
  }

  private videoDownloadCompletedCallback(uri: string): void {
    this.appBroadCast.emit(BroadCastConstants.ON_VIDEO_DOWNLOAD_COMPLETED, [uri]);
  }

  private movingPhotoDownloadStopCallback(uri: string): void {
    this.appBroadCast.emit(BroadCastConstants.MOVING_PHOTO_START_DOWNLOAD, [uri]);
  }

  private updateActionBarPosition(actionBarPosition: string): void {
    this.actionBarPositionY = actionBarPosition;
  }
}