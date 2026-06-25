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

import lazy { PhotoBrowserController } from '../model/PhotoBrowserController';
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
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal,
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { LibraryConstants } from '../model/LibraryConstants';
import lazy { BackgroundView } from '../view/BackgroundView';
import lazy { SubScreenSwiperView } from '../view/SubScreenSwiperView';
import lazy Curves from '@ohos.curves';
import lazy window from '@ohos.window';
import lazy { VideoPlayController } from '@ohos/browsercommon/src/main/ets/default/controller/VideoPlayController';
import lazy { AvplayerStatus, PauseReason } from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { PhotosHmBrowserController } from '../Index';
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import lazy {
  ViewStateChangeListener
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/IPhotoBrowserState';
import lazy { PhotoBrowserVM } from '../model/PhotoBrowserVM';
import { EditorController } from 'browsercommonphone';
import { ThumbDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/ThumbDataSource';

const TAG: string = 'SubScreenPhotoBrowserView';

/**
 * 大图页组件相关内容
 * 供手机使用
 */
@Component
export struct SubScreenPhotoBrowserView {
  /**
   * 大图组件控制器
   */
  @Consume browserController: PhotosHmBrowserController;
  @State stateMachine: PhotoBrowserStateMachine = this.browserController?.stateMachine;
  /**
   * 大图组件dialog广播
   */
  @Provide dialogBroadCast: BroadCast = new BroadCast();

  @State broadCast: BroadCast = new BroadCast();
  /**
   * 隐藏大图组件回调
   */
  hidePhotoBrowser: Function = (): void => {
  };
  /**
   * 大图组件滑动后下标变动回调
   */
  changeCurrentItem: Function = (currentIndex: number): void => {
  }
  // 背景资源
  @Provide backgroundColorResource: Resource = $r('app.color.sub_screen_video_background');
  @Provide('dateTitle') photoDate: string = '';
  @Provide('timeLocationTitle') timeAndLocation: string = '';
  @Prop isShowMenu: boolean = true;
  @Prop canPullingUp: boolean = true;
  @Prop isShowThumbSource: boolean = true;
  @Prop isShowImageAnalyzer: boolean = true;
  /**
   * 大图组件被相机拉起的时间点,用于大数据打点
   */
  @Prop private reportStartTime: number = 0;
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
  @Provide private moreMenuList: Action[] = [];
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
  @StorageLink('isSplitMode') isSplitMode: boolean = false;
  /**
   * 记录当前屏幕状态下，需要避让的区域信息（屏幕挖空等）
   */
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  public swiperController: SwiperController = new SwiperController();
  /**
   * 标识当前页面是否展示
   */
  @Prop @Watch('onPageChanged') pageStatus: boolean = false;
  /**
   * 一镜到底动效使用，用于控制顶部栏、底部栏、背景等控件动效过程的透明度
   */
  @LocalStorageLink('geometryOpacity') geometryOpacity: number = 0;
  /**
   * 标记当前是否正在执行一镜到底动效
   */
  @Link isRunningAnimation: boolean;
  /**
   * 标记当前正在执行删除动画
   */
  @Provide isDeleting: boolean = false;
  @Provide isHiding: boolean = false;
  @Provide hidePopup: boolean = false;
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @State editorController: EditorController = new EditorController();
  @StorageLink('networkAvailable') @Watch('onNetworkAvailableChanged') networkAvailable: boolean = false;
  /**
   * 是否执行跟手下拉动效
   */
  @State isPullDownAndDragPhoto: boolean = false;
  /**
   * 强制触发下方缩略图刷新
   */
  @State forceRefresh: number = 0;
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Vertical });
  private isTouchingPullDown: boolean = false;
  private viewModel: PhotoBrowserVM = new PhotoBrowserVM(this.stateMachine);
  @Provide isShowVideo: boolean = false;
  @Provide isEnableMouse: boolean = false;
  private videoPlayController?: VideoPlayController;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private videoPlayListenerFunc: Function = (): void => this.videoPlayListener();
  private videoPlayCompletedFunc: Function = (): void => this.videoPlayCompleted();
  private videoPlaySwiperIndexChangedFunc: Function = (): void => this.videoPlaySwiperIndexChanged();
  private videoInterruptByOtherAppFunc: Function = (isPaused: boolean): void => {
    this.videoInterruptByOtherApp(isPaused);
  }
  private initVideoPlayFunc: Function = (videoPlayController: VideoPlayController):
    void => this.initVideoPlay(videoPlayController);
  @State @Watch('changeIsMute') isMute: boolean = false;
  @State @Watch('changeIsVideoPlaying') isVideoPlaying: boolean = false;
  private thumbSource: ThumbDataSource = new ThumbDataSource(this.stateMachine);
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  public enterCount: number = 0;
  @State private isQuitPhotoBrowser: boolean = false;
  private isSwiperOffsetZero: boolean = true;
  private getSwiperAnimationStateFunc: Function =
    (isSwiperOffsetZero: boolean): void => this.getSwiperAnimationState(isSwiperOffsetZero);

  private getSwiperAnimationState(isSwiperOffsetZero: boolean): void {
    this.isSwiperOffsetZero = isSwiperOffsetZero
  }

  private onCurrentIndexChange = () => {
    this.onCurrentIndexChanged();
  }

  private onTargetIndexChange = () => {

  }

  private viewStateChangeListener: ViewStateChangeListener =
    new ViewStateChangeListener(this.onCurrentIndexChange, this.onTargetIndexChange);

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear geometryOpacity=${this.geometryOpacity}`);
    if (!isOrientationHorizontal() && DeviceInfo.isTablet()) {
      this.isHorizontal = true;
    }
    const msg: Record<string, number | string | boolean> = {
      'status': BigDataConstants.PHOTO_BROWSER_VIEW_ABOUT_TO_APPEAR,
      'viewAppearCount': ++this.browserController.viewAppearCount
    };
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_BROWSER_VIEW_ABOUT, msg);
    this.browserController.setIsMute(this.isMute);
    this.browserController.setIsBrowserFullShow(true);
    this.browserController.setVideoPlaying(this.isVideoPlaying);
    this.browserController.oldPhotoSize = this.browserController.dataSource?.realTotalCount();
    AlbumSetDataSourceManager.getInstance();
    setTimeout((): void => {
      this.updateIsHorizontal();
    }, Constants.BROWSER_VIEW_ENTRY_ANIME_DELAY);
    this.registerAllCallback(); // 注册控制器回调
    this.browserController.onPhotoChanged(this.stateMachine.getCurrentIndex());
    this.appBroadCast.on(BroadCastConstants.UPDATE_MENU_BEFORE_PLAY_VIDEO, this.videoPlayListenerFunc);
    this.appBroadCast.on(BroadCastConstants.VIDEO_PLAY_COMPLETED, this.videoPlayCompletedFunc);
    this.appBroadCast.on(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, this.videoPlaySwiperIndexChangedFunc);
    this.appBroadCast.on(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, this.initVideoPlayFunc);
    this.appBroadCast.on(BroadCastConstants.UPDATE_MENU_ON_AUDIO_INTERRUPT, this.videoInterruptByOtherAppFunc);
    this.appBroadCast.on(BroadCastConstants.ON_SWIPER_ANIMATION_CHANGE, this.getSwiperAnimationStateFunc);
    if (!this.isHorizontal) {
      setTimeout((): void => {
        this.browserController.setSystemUi(false);
      }, Constants.BROWSER_VIEW_ENTRY_ANIME_DELAY);
    }
    setTimeout((): void => {
      this.browserController.setDefaultStatusBarProperties();
    }, Constants.BROWSER_VIEW_ENTRY_ANIME_DELAY);

    interface Msg {
      SHOW_MENU: boolean,
      SHOW_AI: boolean,
      CAN_PULLUP: boolean,
    }

    const msgShow: Msg = {
      SHOW_MENU: this.isShowMenu,
      SHOW_AI: this.isShowImageAnalyzer,
      CAN_PULLUP: this.canPullingUp,
    }
    this.stateMachine.registerStateChangeListener(this.viewStateChangeListener);
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_BROWSER_COMPONENT_ID, msgShow);
  }

  private registerAllCallback(): void {
    this.browserController.registerBroadCast(this.broadCast);
    this.editorController.init(this.browserController.broadCast, window.Orientation.AUTO_ROTATION_UNSPECIFIED);
    Log.info(TAG, `thumbSource.setPhotoDataSource size = ${this.browserController.dataSource.totalCount()}`);
    this.browserController.registerCallback(LibraryConstants.MENU_KEY_UPDATE_CALLBACK,
      (menuList: Action[], toolMenuList: Action[], moreMenuList: Action[]): void =>
      this.updateMenu(menuList, toolMenuList, moreMenuList));
    this.browserController.registerCallback(LibraryConstants.KEY_UPDATE_ACTION_BAR_TITLE,
      (photoDate: string, timeAndLocation: string): void => this.onUpdateActionBarTitle(photoDate, timeAndLocation));
    this.browserController.registerCallback(LibraryConstants.MENU_KEY_BACK_CALLBACK,
      (): void => this.onMenuClickedForBack());
    this.browserController.registerCallback(LibraryConstants.MENU_KEY_INFO_CALLBACK,
      (isPullingUp: boolean, isPullingDown: boolean, disableSwipe: boolean): void =>
      this.onMenuClickedForInfo(isPullingUp, isPullingDown, disableSwipe));
    this.browserController.registerCallback(LibraryConstants.UPDATE_CURRENT_INDEX,
      (currentIndex: number): void => this.updateCurrentIndex(currentIndex));
    this.browserController.registerCallback(LibraryConstants.UPDATE_HIDE_POPUP,
      (hidePopup: boolean): void => this.updateHidePopup(hidePopup));
    this.browserController.registerCallback(LibraryConstants.UPDATE_DELETING,
      (isDeleting: boolean): void => this.updateDeleting(isDeleting));
    this.browserController.registerCallback(LibraryConstants.UPDATE_HIDING,
      (isHiding: boolean): void => this.updateHiding(isHiding));
    this.browserController.registerCallback(LibraryConstants.GET_IS_PULLING_DOWN,
      (callback: Function): void => this.getIsPullingDown(callback)); // 返回下拉参数
    this.browserController.registerCallback(LibraryConstants.CONTROLLER_BACK_EVENT,
      (callback: Function): void => this.controllerBackEvent(callback)); // 返回上划参数
    this.browserController.registerCallback(LibraryConstants.JUMP_TO_EDIT_PAGE,
      (item: MediaItem): void => this.jumpToEditPage(item));
    this.browserController.registerCallback(LibraryConstants.UPDATE_SYSTEM_UI, (): void => this.updateSystemUi());
    this.browserController.registerCallback(LibraryConstants.DELETE, (): void => this.doDelete());
    this.browserController.registerCallback(LibraryConstants.VIDEO_IS_MUTE, (callback: Function):
      void => this.updateSoundFilledState(callback)); // 声音的状态
    this.browserController.registerCallback(LibraryConstants.VIDEO_SOUND_FILLED, (volume: number):
      void => this.updateSoundFilled(volume)); // 设置声音数值
    this.browserController.registerCallback(LibraryConstants.VIDEO_PLAYING_STATE, (callback: Function):
      void => this.updateVideoPlayingState(callback));
    this.browserController.registerCallback(LibraryConstants.VIDEO_IS_PLAYING, (): void => this.updateVideoPlaying());
    this.browserController.registerCallback(LibraryConstants.UPDATE_VIDEO_STATE, (): void => this.updateVideoState());
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    const msg: Record<string, number | string | boolean> = {
      'status': BigDataConstants.PHOTO_BROWSER_VIEW_ABOUT_TO_DISAPPEAR
    };
    this.stateMachine.unregisterStateChangeListener(this.viewStateChangeListener);
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_BROWSER_VIEW_ABOUT, msg);
    this.browserController.setIsBrowserFullShow(false);
    this.browserController.unregisterBroadCast(this.broadCast);
    this.browserController.unregisterCallback(LibraryConstants.MENU_KEY_UPDATE_CALLBACK);
    this.browserController.unregisterCallback(LibraryConstants.KEY_UPDATE_ACTION_BAR_TITLE);
    this.browserController.unregisterCallback(LibraryConstants.MENU_KEY_BACK_CALLBACK);
    this.browserController.unregisterCallback(LibraryConstants.MENU_KEY_INFO_CALLBACK);
    this.browserController.unregisterCallback(LibraryConstants.UPDATE_CURRENT_INDEX);
    this.browserController.unregisterCallback(LibraryConstants.UPDATE_HIDE_POPUP);
    this.browserController.unregisterCallback(LibraryConstants.ON_TOGGLE_BARS_CALLBACK);
    this.browserController.unregisterCallback(LibraryConstants.UPDATE_DELETING);
    this.browserController.unregisterCallback(LibraryConstants.GET_IS_PULLING_DOWN);
    this.browserController.unregisterCallback(LibraryConstants.CONTROLLER_BACK_EVENT);
    this.browserController.unregisterCallback(LibraryConstants.JUMP_TO_EDIT_PAGE);
    this.browserController.unregisterCallback(LibraryConstants.UPDATE_SYSTEM_UI);
    this.browserController.unregisterCallback(LibraryConstants.DELETE);
    this.browserController.unregisterCallback(LibraryConstants.VIDEO_IS_MUTE);
    this.browserController.unregisterCallback(LibraryConstants.VIDEO_SOUND_FILLED);
    this.browserController.unregisterCallback(LibraryConstants.VIDEO_PLAYING_STATE);
    this.browserController.unregisterCallback(LibraryConstants.VIDEO_IS_PLAYING);
    this.browserController.unregisterCallback(LibraryConstants.UPDATE_VIDEO_STATE);
    this.appBroadCast.off(BroadCastConstants.VIDEO_PLAY_COMPLETED, this.videoPlayCompletedFunc);
    this.appBroadCast.off(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, this.videoPlaySwiperIndexChangedFunc);
    this.appBroadCast.off(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, this.initVideoPlayFunc);
    this.appBroadCast.off(BroadCastConstants.UPDATE_MENU_ON_AUDIO_INTERRUPT, this.videoInterruptByOtherAppFunc);
    this.appBroadCast.off(BroadCastConstants.ON_SWIPER_ANIMATION_CHANGE, this.getSwiperAnimationStateFunc);
    this.browserController.setRotationCapability(false);
    this.browserController.browserAnimController.release();
    this.editorController.release();
  }

  /**
   * 静音状态改变回调
   */
  changeIsMute(): void {
    this.browserController.setIsMute(this.isMute);
  }

  /**
   * 视频播放状态变化回调
   */
  changeIsVideoPlaying(): void {
    this.browserController.setVideoPlaying(this.isVideoPlaying);
  }

  /**
   * 视频点击播放的回调
   */
  private videoPlayListener(): void {
    this.isShowVideo = true;
  }

  /**
   * 视频点击完成回调
   */
  private videoPlayCompleted(): void {
    this.updateVideoState();
  }

  /**
   * 视频设置声音回调
   *
   * @param volume 音量值
   */
  updateSoundFilled(volume: number): void {
    Log.info(TAG, 'updateSoundFilled ');
    this.videoPlayController?.setVolume(volume);
    this.isMute = !this.isMute;
    this.browserController.updateMenu(this.stateMachine.getCurrentIndex(), true);
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
    if (!this.isVideoPlaying && currentPlayerState === AvplayerStatus.PLAYING) {
      this.videoPlayController?.pause(PauseReason.OTHERS);
      this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS, [AvplayerStatus.PAUSED]);
    }
    this.isVideoPlaying = !this.isVideoPlaying;
    this.browserController.updateMenu(this.stateMachine.getCurrentIndex(), true);
  }

  /**
   * 视频切换的回调
   */
  private videoPlaySwiperIndexChanged(): void {
    Log.info(TAG, 'VideoPlaySwiperIndexChanged start ');
    this.updateVideoState();
  }

  /**
   * 更新视频状态信息
   */
  private updateVideoState(): void {
    Log.info(TAG, 'updateVideoState start ');
    this.isShowVideo = false;
    this.isMute = false;
    this.isVideoPlaying = false;
    this.browserController.updateMenu(this.stateMachine.getTargetIndex(), this.isShowVideo);
  }

  private initVideoPlay(videoPlayController: VideoPlayController): void {
    this.videoPlayController = videoPlayController;
  }

  /**
   * 注册回调函数Begin
   *
   * @param menuList 菜单支持用户 Action 列表
   * @param toolMenuList 工具栏菜单支持用户 Action 列表
   * @param moreMenuList 更多菜单支持用户 Action 列表
   */
  updateMenu(menuList: Action[], toolMenuList: Action[], moreMenuList: Action[]): void {
    Log.info(TAG, `menuList.Len = ${menuList?.length}, toolMenuList.Len = ${
    toolMenuList?.length}, moreMenuList.Len = ${moreMenuList?.length}`);
    if (menuList) {
      this.menuList = menuList;
    }
    if (toolMenuList) {
      this.toolMenuList = toolMenuList;
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

  /**
   * 菜单栏点击返回 Back
   */
  onMenuClickedForBack(): void {
    Log.info(TAG, 'onMenuClickedForBack');
    this.swiperController.finishAnimation((): void => this.onBackPressInner());
    this.isShowVideo = false;
    this.isVideoPlaying = false;
    this.videoPlayController?.reset();
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
    if (isPullingUp !== undefined && isPullingUp !== null) {
      this.stateMachine.setPropertiesState(isPullingUp);
    }
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
    this.stateMachine.setCurrentIndex(currentIndex);
    this.forceRefresh++;
    this.changeCurrentItem(currentIndex);
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
    if (this.isShowBar) {
      this.hideBars(backgroundColorResource);
    } else {
      this.showBars(backgroundColorResource);
    }
  }

  /**
   * 展示大图页顶部栏、底部栏回调
   *
   * @param backgroundColorResource 大图背景 resource
   */
  showBars(backgroundColorResource?: Resource): void {
    this.backgroundColorResource =
      backgroundColorResource ? backgroundColorResource : $r('app.color.default_background_color');
    Log.info(TAG, `[showBars] isShowBar: ${this.isShowBar}`);
    if (!this.isShowBar) {
      this.isShowBar = true;
      if (!this.isHorizontal) {
        this.browserController.setSystemUi(true);
      }
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
    if (this.isShowBar) {
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
    callback(this.stateMachine.isPropertiesShow(),
      this.editorController.onBackPress(), this.isShowVideo,
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
    if (this.pageFrom === Constants.ENTRY_FROM.CAMERA) {
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
    if (this.isHorizontal) {
      this.browserController.setSystemUi(false);
      return;
    }
    this.browserController.setSystemUi(this.isShowBar);
  }

  /**
   * 读取背景边距信息
   *
   * @returns 背景边距信息
   */
  getBgPadding(): Padding {
    let backgroundPadding: Padding = {
      top: Constants.ActionBarHeight + (this.isHorizontal ? 0 : px2vp(this.statusBarHeight)),
      bottom: this.isHorizontal ? 0 : (Constants.ToolBarAvoidHeight +
      Constants.ActionBarHeight + this.browserController.getNaviBarHeight())
    }
    Log.info(TAG, `getBgPadding ${JSON.stringify(backgroundPadding)}`);
    return backgroundPadding;
  }

  /**
   * 更行横竖屏状态
   */
  updateIsHorizontal(): void {
    this.updateSystemUi();
    this.browserController.updateMenu(this.stateMachine.getCurrentIndex(), this.isShowVideo);
  }

  /**
   * 当前照片 index 更新回调
   */
  onCurrentIndexChanged(): void {
    this.stateMachine.setTargetIndex(this.stateMachine.getCurrentIndex());
  }

  /**
   * 大图组件展示回调，同所在页面 onPageShow 生命周期配合调用
   */
  onPageShow(): void {
    Log.info(TAG, 'onPageShow');
    if (this.stateMachine.isPropertiesShow()) {
      this.hideBars($r('app.color.default_background_color'));
    } else if (!this.isHorizontal && this.isShowBar) {
      this.browserController.setSystemUi(true);
    }
    this.browserController.onPageShowEnd(false);
  }

  /**
   * 大图组件隐藏回调，同所在页面 onPageHide 生命周期配合调用
   */
  onPageHide(): void {
    Log.info(TAG, 'onPageHide');
    if (!this.stateMachine.isPropertiesShow()) {
      this.showBars();
    }

    // 打开弹窗时，切后台，需要关闭弹窗
    this.dialogBroadCast.emit(BroadCastConstants.HIDE_DELETE_DIALOG, []);
    this.dialogBroadCast.emit(BroadCastConstants.HIDE_HIDDEN_DIALOG, []);
    this.dialogBroadCast.emit(BroadCastConstants.HIDE_RENAME_PHOTO_DIALOG, []);
    this.dialogBroadCast.emit(BroadCastConstants.HIDE_PROMPT_DIALOG, []);

    this.browserController.onPageHideEnd();
    // 当视频正在播放的时候，从前台变成后台的时候，需要暂停播放
    if (this.videoPlayController && this.isShowVideo &&
      this.videoPlayController?.getAvPlayerState() === AvplayerStatus.PLAYING) {
      this.videoPlayController?.pause(PauseReason.OTHERS);
      this.videoPlayController?.reset();
    }
  }

  /**
   * 大图页 Back 键响应回调
   */
  onBackPressInner(): void {
    Log.info(TAG, 'onBackPressInner');
    this.appBroadCast.emit(BroadCastConstants.PHOTO_VIDEO_BACK_PRESS, []);
    this.isQuitPhotoBrowser = true;
    this.browserController.isPhotoBrowserViewShow = false;
    if (this.browserController.getIsBrowserFullShow()) {
      this.broadCast.emit(BroadCastConstants.CHANGE_LOADING_STATUS, [true]);
      this.browserController.emitCallback(LibraryConstants.BROWSER_FULL_SHOW, [false]);
    }
    this.hidePhotoBrowser();
  }

  /**
   * 跳转编辑页面回调
   *
   * @param item
   */
  jumpToEditPage(item: MediaItem): void {
    this.swiperController.finishAnimation((): void => {
      Log.info(TAG, `showEditor item: ${JSON.stringify(item)}`);
      let dataSource: MediaDataSource | undefined = this.browserController.dataSource.getAlbumDataSource();
      let albumUri: string = dataSource ? dataSource.albumUri : '';
      this.editorController.showEditor(albumUri, item);
    })
  }

  onNetworkAvailableChanged(): void {
    Log.info(TAG, `networkAvailable Changed: ${this.networkAvailable}`);
  }

  build() {
    Stack() {
      // 大图组件
      Stack({ alignContent: Alignment.TopStart }) {
        BackgroundView({
          isShowBar: $isShowBar, isFromPhotoBrowser: true,
          avoidOverdrawPadding: this.editorController.isInSwitchAnimation ? this.getBgPadding() : null,
        })
          .opacity(1)
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

        SubScreenSwiperView({
          stateMachine: this.stateMachine,
          swiperController: this.swiperController,
          canPullingUp: this.canPullingUp,
          geometryTransitionEnable: true,
          broadCast: this.browserController.broadCast,
          isRunningAnimation: $isRunningAnimation,
          isPullDownAndDragPhoto: $isPullDownAndDragPhoto,
          thumbSource: this.thumbSource,
          isShowThumbSource: this.isShowThumbSource,
          isShowImageAnalyzer: this.isShowImageAnalyzer,
          isShowBar: $isShowBar,
          forceRefresh: this.forceRefresh,
          isEditorShown: this.editorController.isEditorShown,
          enterCount: this.enterCount,
          isFirstShow: this.enterCount <= 1,
          isQuitPhotoBrowser: this.isQuitPhotoBrowser,
        })
          .margin({ bottom: this.diggingHoleCameraArea.bottom ? this.diggingHoleCameraArea.bottom : 0 })
          .clip(DeviceInfo.isPhonePSD() ? true : new Circle({ width: '100%', height: '100%' }))
          .parallelGesture(
            GestureGroup(GestureMode.Exclusive,
              PanGesture(this.panOption)
                .onActionStart((event: GestureEvent): void => {
                    this.isTouchingPullDown = true;
                    this.onMenuClickedForInfo(undefined, true, undefined);
                })
                .onActionEnd((event: GestureEvent): void => {
                  if (!this.isTouchingPullDown || event.offsetY < 0) {
                    return;
                  }
                  this.browserController.isDrag = false;
                  this.isTouchingPullDown = false;
                  this.browserController.onBackPress();
                })
            )
          )
      }
      .visibility(this.editorController.isBrowserShown ? Visibility.Visible : Visibility.Hidden)
    }
    .expandSafeArea(this.stateMachine.isPropertiesShow() ?
      [] : [SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM])
    .hitTestBehavior(this.editorController.isInSwitchAnimation ? HitTestMode.Block : HitTestMode.Default)
  }

  /**
   * 删除图片回调
   */
  doDelete(): void {
    Log.info(TAG, 'delete finish now update data');
    this.isDeleting = true;
    if (this.stateMachine.getCurrentIndex() === this.browserController.dataSource.totalCount() - 1) {
      AppStorage.setOrCreate<boolean>('isBigPhotoLeftToRightAnim', true);
    }
    this.browserController.dataSource.onChange('image');
  }

  private videoInterruptByOtherApp(isPaused: boolean): void {
    this.isVideoPlaying = isPaused;
    this.browserController.updateMenu(this.stateMachine.getCurrentIndex(), true);
  }
}