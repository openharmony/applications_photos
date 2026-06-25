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

import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { getScreen, isOrientationHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { PhotoBrowserBg } from '@ohos/common/src/main/ets/default/view/PhotoBrowserBg';
import lazy { Constants as PhotoConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { SwiperView } from '../../.../../../../../../../feature/browserlibrary';
import lazy { SelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { SelectUtil } from '@ohos/common/src/main/ets/default/model/browser/photo/SelectUtil';
import lazy {
  ThirdSelectPhotoBrowserActionBar
} from '@ohos/common/src/main/ets/default/view/ThirdSelectPhotoBrowserActionBar';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy common from '@ohos.app.ability.common';
import lazy { Router } from '@ohos.arkui.UIContext';
import lazy ability from '@ohos.ability.ability';
import lazy {
  AvPlayConstants,
  AvplayerStatus,
  PauseReason
} from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy window from '@ohos.window';
import lazy { PhotoBrowserUtils } from '@ohos/common/src/main/ets/default/utils/PhotoBrowserUtils';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { AnimationUtil } from '@ohos/common/src/main/ets/default/utils/AnimationUtil';
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import lazy {
  PhotoBrowserInitState
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserInitState';
import lazy {
  ViewStateChangeListener
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/IPhotoBrowserState';
import { LibraryConstants, PhotosHmBrowserController } from '@ohos/browserlibrary';
import { BlurImageComponent } from '@ohos/common/src/main/ets/default/view/hidden/BlurImageComponent';
import { PhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataSource';
import { VideoPlayController } from '@ohos/browsercommon/src/main/ets/default/controller/VideoPlayController';

/* instrument ignore file */
const TAG: string = 'SelectPhotoBrowserView';
const SEND_ACCESSIBILITY_EVENT_TIMEOUT: number = 600;

interface Params {
  pageFrom: number;
  deviceId: string;
  position: number;
  transition: string;
};

// 录屏文件跳转图库，拉起SelectPhotoBrowserView
// select mode
@Component
export struct SelectPhotoBrowserView {
  @Provide backgroundColorResource: Resource = $r('sys.color.background_secondary');
  @State selectedCount: number = 0;
  // 广播
  @State broadCast: BroadCast = new BroadCast();
  @Provide isSelected: boolean = true;
  @State isShowBar: boolean = true;
  @State isInSwiperAnimation: boolean = false;
  // 下拉
  @Provide isPullingDown: boolean = false;
  @Provide isPullingUp: boolean = false;
  @Provide pageFrom: number = Constants.ENTRY_FROM.NORMAL;
  @Provide viewData: string = '';
  @Provide disableSwipe: boolean = true;
  public selectManager: SelectManager | undefined = undefined;
  public isMultiPick = true;
  public mTransition: string = '';
  public controller: SwiperController = new SwiperController();
  @Provide isDeleting: boolean = false;
  @Provide canEdit: boolean = false;
  @Provide isShowVideo: boolean = false;
  // swiper currentIndex, there may not be onChanged callback during data refresh, so mediaItem cannot be saved
  private onCurrentIndexChange = () => {
    this.onCurrentIndexChanged();
  }
  private onTargetIndexChange = (targetIndex: number) => {
    Log.info(TAG, `onTargetIndexChanged :${targetIndex} ${this.stateMachine.getCurrentIndex()}`);
    let targetItem: MediaItem | undefined = this.getPhotoByIndex(targetIndex) ?? undefined;
    if (targetItem) {
      let currentItem: MediaItem | undefined = this.getPhotoByIndex(this.stateMachine.getCurrentIndex()) ?? undefined;
      AppStorage.setOrCreate<MediaItem>('targetItem', targetItem);
      if (currentItem) {
        if (this.browserController?.browserAnimController.isTransitionEnable) {
          return;
        }
        this.browserController?.browserAnimController.updatePlaceHolder(currentItem.uniqueId ?? '', false);
        this.browserController?.browserAnimController.updatePlaceHolder(targetItem.uniqueId ?? '', true);
      }
    }
  }
  /**
   * currentIndex监听
   */
  private viewStateChangeListener: ViewStateChangeListener =
    new ViewStateChangeListener(this.onCurrentIndexChange, this.onTargetIndexChange);
  @Provide isEnableMouse: boolean = false;
  @Provide fromCardCurrentIndex: number = 0;
  @Provide isFirstInSwiperFromCard: boolean = false;
  // position
  public mPosition: number = 0;
  public timelineIndex: number = -1;
  @Prop @Watch('onPageChanged') pageStatus: boolean = false;
  @LocalStorageLink('geometryOpacity') geometryOpacity: number = 1;
  @StorageLink('isFullMode') private isFullMode: boolean = getScreen().isFullMode();
  @State @Watch('onGeometryChanged') geometryTransitionId: string = '';
  @Link @Watch('onRunningAnimationChanged') isRunningAnimation: boolean;
  private isOpenRunningAnim: boolean = true;
  @Consume browserController: PhotosHmBrowserController;
  @State stateMachine: PhotoBrowserStateMachine = this.browserController.stateMachine;
  // dataSource
  private dataSource: PhotoDataSource = new PhotoDataSource(this.stateMachine);
  // The global BroadCast of the application process. Event registration and destruction should be paired
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private geometryTransitionEnable: boolean = false;
  @State @Watch('onPullDownAndDrag') isPullDownAndDragPhoto: boolean = false;
  private swiperTargetIndex: number = 0;
  @StorageLink('isHorizontal') @Watch('updateSystemUi') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @Provide menuList: Action[] = [];
  @State private moreMenuList: Action[] = [];
  private onPullDownEndFunc: Function = (event: KeyEvent): void => this.onPullDownEnd(event);
  private onDataSizeChangedFunc: Function = (size: number): void => {
    this.onDataSizeChanged(size);
  }
  //videoPlayer start
  @StorageLink('isMute') @Watch('onIsMuteChanged') private isMute: boolean = false;
  private videoPlayListenerFunc: Function = (): void => this.videoPlayListener();
  private videoPlayCompletedFunc: Function = (): void => this.videoPlayCompleted();
  private videoPlaySwiperIndexChangedFunc: Function = (): void => this.videoPlaySwiperIndexChanged();
  private videoPlayController?: VideoPlayController;
  private initVideoPlayFunc: Function = (videoPlayController: VideoPlayController): void => {
    this.initVideoPlay(videoPlayController);
  }
  private onDataContentChangedFunc: Function = (size: number): void => {
    // onContentChanged only the current item is updated
    Log.info(TAG, `DATA_CONTENT_CHANGED : ${size}`);
    this.onPhotoChanged(this.stateMachine.getCurrentIndex());
  }
  private onSetDisableSwipeFunc: Function = (value: boolean): void => this.onSetDisableSwipe(value);
  private onPullDownStartFunc: Function = (event: KeyEvent): void => this.onPullDownStart(event);
  private onPullDownCancelFunc: Function = (): void => this.onPullDownCancel();
  private handlePauseClickFuc: Function = (): void => this.handlePauseClick();
  private onDownloadOriginPhotoFunc: Function =
    (downloadScene: string): void => this.onDownloadOriginPhoto(downloadScene);
  // 判断当前是否在执行大图页删除动效
  @Provide isDoDeleteAnim: boolean = false;
  private onSelectPhotoBrowserBackPressEventFunc: Function = (browserControllerId?: number): void => {
    Log.debug(TAG, 'hook back press from page.');
    this.onBackPress(browserControllerId);
  }
  @State isSlideBarShow: boolean = false;
  @State isDetailSelected: boolean = false;
  @State pcCurItem: MediaItem = new MediaItem();
  @State private isPrivateHideState: boolean = false;
  @StorageLink('navigationBarHeight') private navigationBarHeight: number = 0;
  private isManuallyPaused = false;
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @StorageLink('isOpenTouchGuide') private isOpenTouchGuide: boolean = false;
  @State isScrolling: boolean = false;
  private onIndexChangeFunc: Function = (currentIndex: number): void => this.onIndexChange(currentIndex);
  private onDataPrepareFunc: Function = (currentIndex: number): void => this.onDataPrepare(currentIndex);
  private orientataion: number = 0;

  private onDownloadOriginPhoto(downloadScene: string): void {
    let item: MediaItem | undefined = PhotoBrowserUtils.getCurrentPhoto(this.browserController.dataSource,
      this.stateMachine.getCurrentIndex());
    PhotoBrowserUtils.onDownloadOriginPhoto(downloadScene, item);
  }

  private onPullDownEnd(event: KeyEvent): void {
    Log.info(TAG, `PULL_DOWN_END : ${JSON.stringify(event)}`);
    this.browserController.isDrag = true;
    this.onBackPress(this.browserController.browserControllerId);
  }

  private onSetDisableSwipe(value: boolean): void {
    Log.info(TAG, `set swiper swipe ${value}`);
    this.disableSwipe = value;
  }

  private onPullDownStart(event: KeyEvent): void {
    Log.debug(TAG, `pulling down start : ${JSON.stringify(event)}`);
    this.isPullingDown = true;
  }

  private onPullDownCancel(): void {
    Log.info(TAG, 'pulling down cancel');
    this.isPullingDown = false;
  }

  private handlePauseClick(): void {
    this.videoPlayController?.pause(PauseReason.SELECTED_MODE);
    this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS, [AvplayerStatus.PAUSED]);
  }

  onPageChanged(): void {
    if (this.pageStatus) {
      this.onPageShow();
    } else {
      this.onPageHide();
    }
  }

  onGeometryChanged(): void {
    LocalStorage.getShared()?.setOrCreate<string>('geometryTransitionBrowserId', this.geometryTransitionId);
  }

  onPullDownAndDrag(): void {
    Log.debug(TAG, `onPullDownAndDrag: ${this.isPullDownAndDragPhoto}`);
    this.browserController.isPullDownAndDrag = this.isPullDownAndDragPhoto;
  }

  private setWindowOrientation(): void {
    WindowUtil.getPreferredOrientation().then(result => {
      this.orientataion = result ? result : 0;
      Log.info(TAG, `Before SelectPhotoBrowserView Orientation: ${this.orientataion}`);
    });
  }

  aboutToAppear(): void {
    Log.info(TAG, 'photoBrowser aboutToAppear');
    this.setWindowOrientation();
    this.hideBars();
    WindowUtil.prepareWinRouter();
    this.geometryTransitionId = LocalStorage.getShared()?.get<string>('geometryTransitionBrowserId') ?? '';
    Log.info(TAG, `photoBrowser aboutToAppear  ${this.geometryTransitionId}`);
    this.backgroundColorResource = $r('app.color.black');
    this.selectManager = AppStorage.get<SelectManager>(Constants.PHOTO_GRID_SELECT_MANAGER) as SelectManager;
    let param: Params = this.browserController.selectBrowserParam as Params;
    if (param.pageFrom) {
      this.pageFrom = param.pageFrom;
    }
    this.stateMachine.registerStateChangeListener(this.viewStateChangeListener);
    this.browserController.initSelectPhotoBrowserDatasource(param.pageFrom, param.deviceId, this.broadCast);
    if (this.isMultiPick) {
      this.selectedCount = this.selectManager?.getSelectedCount();
    }
    this.onPhotoChanged(param.position);
    this.mTransition = param.transition;

    this.broadCast.on(PhotoConstants.DOWNLOAD_ORIGIN_PHOTO, this.onDownloadOriginPhotoFunc);

    this.broadCast.on(PhotoConstants.PULL_DOWN_END, this.onPullDownEndFunc);

    this.broadCast.on(PhotoConstants.DATA_SIZE_CHANGED, this.onDataSizeChangedFunc);

    this.broadCast.on(PhotoConstants.DATA_CONTENT_CHANGED, this.onDataContentChangedFunc);

    this.broadCast.on(PhotoConstants.SET_DISABLE_SWIPE, this.onSetDisableSwipeFunc);

    this.appBroadCast.on(BroadCastConstants.SELECT_PHOTO_BROWSER_BACK_PRESS_EVENT,
      this.onSelectPhotoBrowserBackPressEventFunc);

    this.broadCast.on(PhotoConstants.PULL_DOWN_START, this.onPullDownStartFunc);

    this.broadCast.on(PhotoConstants.PULL_DOWN_CANCEL, this.onPullDownCancelFunc);
    this.broadCast.on(BroadCastConstants.CHANGE_IS_PAUSE, this.handlePauseClickFuc);
    this.appBroadCast.on(BroadCastConstants.UPDATE_MENU_BEFORE_PLAY_VIDEO, this.videoPlayListenerFunc);
    this.appBroadCast.on(BroadCastConstants.VIDEO_PLAY_COMPLETED, this.videoPlayCompletedFunc);
    this.appBroadCast.on(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, this.videoPlaySwiperIndexChangedFunc);
    this.appBroadCast.on(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, this.initVideoPlayFunc);
    this.browserController.isBrowserShowContent = true;
    this.browserController.registerCallback(LibraryConstants.UPDATE_CURRENT_INDEX, this.onIndexChangeFunc);
    this.browserController.registerCallback(LibraryConstants.UPDATE_PREPARED_INDEX, this.onDataPrepareFunc);

    if (this.isOpenTouchGuide) {
      AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_BUTTON_BACK);
    }
  }

  aboutToDisappear(): void {
    WindowUtil.setOrientation(this.orientataion);
    this.isMute = false;
    this.showBars();
    this.broadCast.release();
    let browserDataSource: PhotoDataSource = this.browserController.dataSource;
    browserDataSource.release();
    this.appBroadCast.off(BroadCastConstants.SELECT_PHOTO_BROWSER_BACK_PRESS_EVENT,
      this.onSelectPhotoBrowserBackPressEventFunc);
    this.stateMachine.unregisterStateChangeListener(this.viewStateChangeListener);
    this.broadCast.off(PhotoConstants.DOWNLOAD_ORIGIN_PHOTO, this.onDownloadOriginPhotoFunc);
    this.broadCast.off(PhotoConstants.PULL_DOWN_END, this.onPullDownEndFunc);
    this.broadCast.off(PhotoConstants.DATA_SIZE_CHANGED, this.onDataSizeChangedFunc);
    this.broadCast.off(PhotoConstants.DATA_CONTENT_CHANGED, this.onDataContentChangedFunc);
    this.broadCast.off(PhotoConstants.SET_DISABLE_SWIPE, this.onSetDisableSwipeFunc);
    this.broadCast.off(PhotoConstants.PULL_DOWN_START, this.onPullDownStartFunc);
    this.broadCast.off(PhotoConstants.PULL_DOWN_CANCEL, this.onPullDownCancelFunc);
    this.broadCast.off(BroadCastConstants.CHANGE_IS_PAUSE, this.handlePauseClickFuc);
    this.appBroadCast.off(BroadCastConstants.UPDATE_MENU_BEFORE_PLAY_VIDEO, this.videoPlayListenerFunc);
    this.appBroadCast.off(BroadCastConstants.VIDEO_PLAY_COMPLETED, this.videoPlayCompletedFunc);
    this.appBroadCast.off(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, this.videoPlaySwiperIndexChangedFunc);
    this.appBroadCast.off(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, this.initVideoPlayFunc);
    this.browserController.unregisterCallback(LibraryConstants.UPDATE_CURRENT_INDEX, this.onIndexChangeFunc);
    this.browserController.unregisterCallback(LibraryConstants.UPDATE_PREPARED_INDEX, this.onDataPrepareFunc);
    this.browserController.isBrowserShowContent = false;
    this.videoPlayController?.reset();
    // IT4删掉
    this.browserController.stateMachine.setCurrentState(PhotoBrowserInitState.getInstance());
  }

  onCurrentIndexChanged(): void {
    this.broadCast?.emit(PhotoConstants.EVENT_ON_CURRENT_INDEX_CHANGED, [this.stateMachine.getCurrentIndex(), false]);
  }

  updateSystemUi(): void {
    getScreen().setSystemUi(false);
  }

  showBars(): void {
    this.backgroundColorResource = $r('sys.color.comp_background_gray');
    if (this.isHorizontal) {
      getScreen().setSystemUi(false, true, false, true);
    } else {
      getScreen().setSystemUi(true, true, false, true);
    }
  }

  hideBars(): void {
    this.backgroundColorResource = $r('app.color.black');
    getScreen().setSystemUi(false);
  }

  onDataSizeChanged(size: number): void {
    Log.info(TAG, `onDataSizeChanged, size is ${size} ${this.selectManager?.getSelectedCount()}`);
    this.selectedCount = this.selectManager?.getSelectedCount() ?? 0;
    if (size == 0) {
      this.onBackPress(this.browserController.browserControllerId);
    }
  }

  private onRunningAnimationChanged(): void {
    Log.info(TAG, `[enterSelectLibrary] onRunningAnimationChanged ${this.isRunningAnimation}`);
    // 在打开动效结束后，再发起一次解码
    if (this.isOpenRunningAnim) {
      this.browserController.updatePixMapDataSource(false);
      this.isOpenRunningAnim = false;
    }
  }

  onPhotoChanged(index: number): void {
    this.stateMachine.setCurrentIndex(index);
    this.timelineIndex = this.browserController.dataSource.getPositionByIndex(index) as number;
    let currentPhoto = this.getCurrentPhoto();
    if (!currentPhoto) {
      Log.error(TAG, 'onPhotoChanged, item is undefined');
    } else {
      this.swiperTargetIndex = index;
      this.isSelected = this.selectManager?.isItemSelectedForBrowser(currentPhoto.uri, this.timelineIndex) ?? false;
      LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', this.timelineIndex);
      this.geometryTransitionId = this.browserController.pageFrom + currentPhoto.getHashCode?.();
      Log.info(TAG, `onPhotoChanged, index: ${index}, currentPhoto: ${currentPhoto.uri},\
        isSelected: ${this.isSelected}  geometryTransitionId ${this.geometryTransitionId}`);
    }
    this.browserController.updatePixMapDataSource(true);
  }

  onIndexChange(index: number): void {
    Log.info(TAG, `onIndexChange start, index=${index}`);
    this.stateMachine.setCurrentIndex(index);
    this.timelineIndex = this.browserController.dataSource.getPositionByIndex(index) as number;
    let currentPhoto = this.getCurrentPhoto();
    if (!currentPhoto) {
      Log.error(TAG, 'onIndexChange, item is undefined');
    } else {
      LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', this.timelineIndex);
      this.geometryTransitionId = this.browserController.pageFrom + currentPhoto.getHashCode();
      Log.info(TAG, `onIndexChange, index: ${index}, currentPhoto: ${currentPhoto.uri},\
        isSelected: ${this.isSelected}  geometryTransitionId ${this.geometryTransitionId}`);
    }
  }

  onDataPrepare(index: number): void {
    let currentPhoto = this.getPhotoByIndex(index);
    if (!currentPhoto) {
      Log.error(TAG, 'onDataPrepare, item is undefined');
    } else {
      this.swiperTargetIndex = index;
      this.isSelected = this.selectManager?.isItemSelectedForBrowser(currentPhoto.uri, this.timelineIndex) ?? false;
    }
  }

  selectStateChange(): void {
    Log.info(TAG, `change selected, timeline index ${this.timelineIndex}`);
    let currentPhoto = this.getPhotoByIndex(this.swiperTargetIndex);
    if (!currentPhoto) {
      return;
    }
    this.isSelected = !this.isSelected;
    if (this.selectManager?.toggleForSelectBrowser(currentPhoto.uri, this.isSelected, this.swiperTargetIndex)) {
      this.selectedCount = this.selectManager?.getSelectedCount() ?? 0;
    }
    this.geometryTransitionId = this.browserController.pageFrom + currentPhoto.getHashCode?.();
    Log.info(TAG, `selectedCount: ${this.selectedCount} after state change`);
  }

  onPageShow() {
    Log.info(TAG, 'onPageShow');
    this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.mTransition]);
  }

  onPageHide() {
    Log.info(TAG, 'onPageHide');
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.mTransition]);
  }

  onMenuClicked(action: Action): void {
    Log.debug(TAG, `onMenuClicked, action: ${ActionID[action.actionID]}`);
    if (action.actionID === Action.BACK.actionID) {
      this.onBackPress(this.browserController.browserControllerId);
      return;
    } else if (action.actionID === Action.MATERIAL_SELECT.actionID) {
      Log.info(TAG, 'click UN_SELECTED');
      this.selectStateChange();
      this.updateFocus(action);
      return;
    } else if (action.actionID === Action.SELECTED.actionID) {
      Log.info(TAG, 'click SELECTED');
      this.selectStateChange();
      this.updateFocus(action);
      return;
    } else if (action.actionID === Action.OK.actionID) {
      Log.info(TAG, 'click OK');
      this.setPickResult();
    }
  }

  private updateFocus(action: Action): void {
    if (AccessibilityUtil.isOpenTouchGuideSync()) {
      Log.info(TAG, `updateFocus, action is :${action.componentKey}`);
      if (Action.MATERIAL_SELECT.equals(action)) {
        AccessibilityUtil.sendFocusAccessibilityEvent('AccessibilityComponentSelected');
      } else if (Action.SELECTED.equals(action)) {
        AccessibilityUtil.sendFocusAccessibilityEvent('AccessibilityComponentMaterialSelect');
      }
    }
  }

  getCurrentPhoto(): MediaItem | undefined {
    return this.browserController.dataSource.getDataWithoutCache(this.stateMachine.getCurrentIndex())?.item;
    // return undefined
  }

  getPhotoByIndex(index: number): MediaItem | undefined {
    return this.browserController.dataSource.getDataWithoutCache(index)?.item;
    // return undefined
  }

  private updateFocusWhenBackToPhotoGridView(): void {
    if (AccessibilityUtil.isOpenTouchGuideSync()) {
      let index: number = this.stateMachine.getCurrentIndex() ?? 0;
      let targetFocusedElementId: string = `photoGridView_gird_${index.toString()}`;
      AccessibilityUtil.sendFocusAccessibilityEvent(targetFocusedElementId, SEND_ACCESSIBILITY_EVENT_TIMEOUT);
    }
  }

  onBackPress(browserControllerId?: number) {
    Log.info(TAG, `[GeometryLogger] onBackPress, cur_index=${this.stateMachine.getCurrentIndex()}`);
    if (this.browserController.geometryTransitionEnable) {
      let geometryTransitionBrowserId: string =
        LocalStorage.getShared()?.get<string>('geometryTransitionBrowserId') ?? '';
      Log.info(TAG, `onBackPress geometryTransitionBrowserId=${geometryTransitionBrowserId}`);
      if (geometryTransitionBrowserId !== undefined && geometryTransitionBrowserId !== '') {
        this.broadCast.emit(BroadCastConstants.CHANGE_LOADING_STATUS, [true]);
        this.controller.finishAnimation((): void => this.onBackPressInner(browserControllerId));
      } else {
        LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', Constants.INVALID);
        LocalStorage.getShared()?.setOrCreate<string>('geometryTransitionBrowserId', '');
      }}}
  private onBackPressInner(browserControllerId?: number): void {
    this.appBroadCast.emit(BroadCastConstants.PHOTO_VIDEO_BACK_PRESS, []);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_PHOTO_BACK_PRESS, [undefined, undefined, browserControllerId]);
    let timelineIndex =
      this.browserController.dataSource.getPositionByIndex(this.stateMachine.getCurrentIndex()) as number;
    this.browserController.hideSelectBrowser(timelineIndex);
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      PhotoBrowserBg({ isShowBar: $isShowBar })
        .opacity(this.geometryOpacity)
        .transition(AppStorage.get<boolean>(Constants.IS_VIDEO_CLEANUP_PAGE) ?
          PhotoConstants.VIDEO_CLEANUP_MASK_EFFECT : TransitionEffect.asymmetric(PhotoConstants.OPEN_EFFECT,
              this.browserController.isDrag ? TransitionEffect.opacity(0) : PhotoConstants.CLOSE_EFFECT
          ))
        .enabled(!this.isPullDownAndDragPhoto)

      SwiperView({
        stateMachine: this.stateMachine,
        mTransition: this.mTransition,
        swiperController: this.controller,
        geometryTransitionEnable: this.geometryTransitionEnable,
        broadCast: this.broadCast,
        isInSwiperAnimation: this.isInSwiperAnimation,
        isInSelectedMode: true,
        isRunningAnimation: $isRunningAnimation,
        isPullDownAndDragPhoto: $isPullDownAndDragPhoto,
        isShowBar: $isShowBar,
        isSlideBarShow: $isSlideBarShow,
        pcCurItem: this.pcCurItem,
        isScrolling: this.isScrolling,
      })
        .visibility(this.isPrivateHideState ? Visibility.Hidden : Visibility.Visible)

      if (this.isPrivateHideState) {
        BlurImageComponent({
          topMargin: Constants.ActionBarHeight + (this.isHorizontal ? 0 : px2vp(this.statusBarHeight)),
          bottomMargin: Constants.ToolBarAvoidHeight,
          // textMessage: this.getBlurImageComponentText(),
          accessibilityBackElementId: this.isOpenTouchGuide ? this.getAccessibilityBackElementId() : '',
          message: TAG,
        })
          .transition(this.browserController.isAnimating ? null : AnimationUtil.blurImageAnimation())
      }

      ThirdSelectPhotoBrowserActionBar({
        isMultiPick: this.isMultiPick,
        onMenuClicked: (action: Action): void => this.onMenuClicked(action),
        isShowBar: $isShowBar,
        totalSelectedCount: $selectedCount,
        moreMenuList: this.moreMenuList,
        isPrivateHideState: this.isPrivateHideState,
      })
        .opacity(this.geometryOpacity)
        .transition(this.buildActionBarTransition())
        .enabled(!this.isPullDownAndDragPhoto)
    }
  }

  private getAccessibilityBackElementId(): string {
    return Constants.COMPONENT_KEY_BUTTON_BACK;
  }

  private buildActionBarTransition() {
    if (AppStorage.get<boolean>(Constants.IS_VIDEO_CLEANUP_PAGE)) {
      return TransitionEffect.asymmetric(
        PhotoConstants.VIDEO_CLEANUP_OPEN_EFFECT, PhotoConstants.VIDEO_CLEANUP_CLOSE_EFFECT
      )
    } else {
      return TransitionEffect.asymmetric(
        PhotoConstants.OPEN_EFFECT,
          this.browserController.isDrag ? TransitionEffect.opacity(0) : PhotoConstants.CLOSE_EFFECT
      )
    }
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
      .opacity(0)
    PageTransitionExit({ duration: PhotoConstants.PAGE_SHOW_ANIMATION_DURATION })
      .opacity(0)
  }

  private setPickResult(): void {
    let uriArray: string[];
    if (this.isMultiPick) {
      uriArray = SelectUtil.getUriArray((this.selectManager?.clickedSet ?? new Set()) as Set<string>);
      Log.debug(TAG, `uri size: ${uriArray}`);
    } else {
      let currentPhoto = this.getCurrentPhoto();
      if (!currentPhoto) {
        return;
      }
      uriArray = [currentPhoto.uri];
    }
    let abilityResult: ability.AbilityResult = {
      resultCode: 0,
      want: {
        parameters: {
          'select-item-list': uriArray
        }
      }
    };
    global.terminateSelfWithResult(TAG, 'confirm setPickResult', abilityResult);
  }

  /**
   * 点击视频播放回调
   */
  private videoPlayListener() {
    Log.info(TAG, 'VideoPlayListener start ');
    this.isShowVideo = true;
  }

  /**
   * 视频播放完成后的回调
   */
  private videoPlayCompleted() {
    Log.info(TAG, 'VideoPlayCompleted start ');
    this.updateVideoState();
  }

  /**
   * 视频切换的回调
   */
  private videoPlaySwiperIndexChanged() {
    Log.info(TAG, 'VideoPlaySwiperIndexChanged start ');
    this.updateVideoState();
  }

  /**
   * 更新视频状态
   */
  private updateVideoState() {
    this.isShowVideo = false;
  }

  private initVideoPlay(videoPlayController: VideoPlayController): void {
    this.videoPlayController = videoPlayController;
  }

  private onIsMuteChanged(): void {
    Log.info(TAG, `[videoPlayer] onIsMuteChanged, isMute: ${this.isMute}`);
    this.videoPlayController?.setVolume(this.isMute ? AvPlayConstants.AV_PLAY_MUTE : AvPlayConstants.AV_PLAY_VOLUME);
  }

  private refreshPrivateHideState(): void {
    if (this.isPrivateHideState && this.isShowVideo) {
      let success: boolean | undefined = this.videoPlayController?.manuallyPause();
      if (success) {
        this.isManuallyPaused = true;
      }
      this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS,
        [success ? AvplayerStatus.PAUSED : AvplayerStatus.PLAYING]);
    }

    if (!this.isPrivateHideState && this.isManuallyPaused) {
      this.videoPlayController?.play();
      this.appBroadCast.emit(BroadCastConstants.REFRESH_VIDEO_STATUS_FOR_PROGRESS, [AvplayerStatus.PLAYING]);
    }
  }

  private getBlurImageComponentText(): Resource {
    let currentPhoto: MediaItem | undefined = this.getPhotoByIndex(this.stateMachine.getCurrentIndex());
    if (!currentPhoto) {
      return $r('app.string.Private_protection_view_photos');
    }
    return currentPhoto.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO ?
      $r('app.string.show_video') : $r('app.string.Private_protection_view_photos');
  }
}
