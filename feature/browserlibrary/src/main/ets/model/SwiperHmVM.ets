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

import lazy { BrowserAnimController } from '@ohos/common/src/main/ets/default/model/BrowserAnimController';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { SCROLL_ANIMATION_DURATION, SwiperVM } from './SwiperVM';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Constants as BrowserConstants, Constants as PhotoConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { PhotoAsset, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { PhotoItem } from '@ohos/browsercommon/src/main/ets/default/view/PhotoItem';
import lazy Swipes from '@ohos/common/src/main/ets/default/view/Swipes';
import lazy Curves from '@ohos.curves';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy window from '@ohos.window';

/* instrument ignore file  */

const TAG: string = 'browser_SwiperHmVM';

interface HistoryOperation {
  action: number;
  photoUri: string[];
  photoAsset: PhotoAsset[];
  dataCount: number;
};

export class SwiperHmVM extends SwiperVM {
  @Track public isPullDownStart: boolean = true;
  @Track public preCount: number = 0;
  @Track public changeByKeyBoard: boolean = false;
  @Track public stackCount: number = 0;
  @Track public isTriggeredByPause: boolean = false;

  private isShowSideBarBeforePC: boolean = false;
  // 三方入口进图库大图 标志位
  private isFromViewData: boolean = false;
  /**
   * 逐帧播放：点击预览条list的滚动动效
   */
  private clickToScrollAni: boolean = false;
  /**
   * 转场动效使用标记ID
   */
  private mTransition: string = '';

  private resetVideoFrameFunc: () => void = (): void => {
    this.resetVideoFrame();
  }
  /**
   * 显示结束swiper左右切换动效
   */
  private finishSwiperAnimationFunc: Function = (): void => this.finishSwiperAnimation();
  private dataLoadFinishPreviewerFunc: Function = (): void => {
    this.dataLoadFinishPreviewer();
  }
  private handleUndoFunc: Function = (): void => this.undo();
  private handleRedoFunc: Function = (): void => this.redo();

  private get isFoldExpanded(): boolean {
    return AppStorage.get<boolean>('getFoldStatus') ?? DeviceInfo.isFoldable();
  }

  private get zOperationList(): HistoryOperation[] {
    return AppStorage.get<HistoryOperation[]>('zOperationList') ?? [];
  }

  private set zOperationList(value: HistoryOperation[]) {
    AppStorage.setOrCreate<HistoryOperation[]>('zOperationList', value);
  }

  private get yOperationList(): HistoryOperation[] {
    return AppStorage.get<HistoryOperation[]>('yOperationList') ?? [];
  }

  private set yOperationList(value: HistoryOperation[]) {
    AppStorage.setOrCreate<HistoryOperation[]>('yOperationList', value);
  }

  private get isShowSideBar(): boolean {
    return LocalStorage.getShared()?.get<boolean>('isShowSideBar') ?? true;
  }

  private set isShowSideBar(value: boolean) {
    LocalStorage.getShared()?.setOrCreate<boolean>('isShowSideBar', value);
  }

  public onCreate(browserAnimController: BrowserAnimController): void {
    super.onCreate(browserAnimController);
    this.initBrowserState();
    // 三方入口进图库的大图，等待数据加载完成后加载预览条
    if ((this.isFromViewData || this.isFromFACard) && !this.isCurrentMediaItemLoaded()) {
      Log.info(TAG, 'aboutToAppear, set isThumbsourceLoadFinished false');
      this.isThumbsourceLoadFinished = false;
    }
    this.preCount = this.totalCount;
  }

  private isCurrentMediaItemLoaded(): boolean {
    const currentMediaItem: MediaItem | undefined =
      this.getBrowserController().dataSource?.getAlbumDataSource()?.getRawData?.(this.getCurrentIndex());
    Log.info(TAG, `currentIndex:${this.getCurrentIndex()}, typeof currentMediaItem:${typeof currentMediaItem}`);
    if (currentMediaItem) {
      return true;
    }
    return false;
  }

  protected registerBroadCast() {
    super.registerBroadCast();
    this.broadCast?.on(PhotoConstants.PULL_DOWN_START, this.finishSwiperAnimationFunc);
    this.broadCast?.on(BrowserConstants.DATA_LOAD_FINISH_PREVIEWER_REFRESH, this.dataLoadFinishPreviewerFunc);
    this.broadCast?.on(BrowserConstants.RESET_VIDEO_FRAME, this.resetVideoFrameFunc);

    this.appBroadCast.on(BroadCastConstants.EDIT_UNDO, this.handleUndoFunc);
    this.appBroadCast.on(BroadCastConstants.EDIT_REDO, this.handleRedoFunc);
  }

  public isSlideBarVisibility(isFromViewData?: boolean, isVideoPlay?: boolean, isSlideBarHover?: boolean): boolean {
    let methodName: string = 'isSlideBarVisibility';
    Log.debug(TAG, `${methodName}, isSlideBarHover: ${isSlideBarHover}`);
    if (isSlideBarHover) {
      return true;
    }
    this.totalCount = this.thumbSource?.totalCount() ?? 0;
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      Log.debug(TAG,
        `${methodName}, isShowBar: ${this.isShowBar}, isEditorShown: ${this.isEditorShown},
         isInSelectedMode: ${this.isInSelectedMode}, isFromViewData: ${isFromViewData}`);
      return this.isShowBar && !this.isEditorShown && !this.isInSelectedMode && !isFromViewData;
    }
    Log.debug(TAG,
      `${methodName}, isShowBar: ${this.isShowBar}, isEditorShown: ${this.isEditorShown},
       isInSelectedMode: ${this.isInSelectedMode}, isFromViewData: ${isFromViewData},
        totalCount: ${this.totalCount}, curItem mediaType: ${this.curItem.mediaType}`);
    return this.isShowBar && !this.isEditorShown && !this.isInSelectedMode && !isFromViewData &&
      (this.totalCount > 1 || this.curItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO);
  }

  public updateSwiperHeight(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
    if (this.getIsHorizontal() && !DeviceInfo.isPc() || this.notVerdeExpand()) {
      this.swiperListHeight = DeviceInfo.isTablet() ?
      $r('app.float.pad_slider_bar_horizon_height') : $r('app.float.slider_bar_horizon_height');
    } else if (DeviceInfo.isPc() || DeviceInfo.isTablet()) {
      this.swiperListHeight = $r('app.float.pc_slider_bar_height');
    } else {
      this.swiperListHeight = $r('app.float.slider_bar_height');
    }
  }

  private notVerdeExpand(): boolean {
    return this.isFoldExpanded && this.getIsFullMode() && !DeviceInfo.isPhoneVde();
  }

  private initBrowserState() {
    this.curItem = this.getBrowserController().dataSource?.getData(this.getCurrentIndex())?.item ?? new MediaItem();
    if (!this.currentUri && this.curItem.uri) {
      this.currentUri = this.curItem.uri;
    }
    Log.info(TAG, `initBrowserState currentIndex: ${this.getCurrentIndex()}, currenturi ${this.currentUri},
      curItem: ${this.curItem.uri}`);
  }

  protected jumpStart(): void {
    super.jumpStart();
    Log.info(TAG, `jumpStart, currentIndex: ${this.getCurrentIndex()}, centerIndex: ${this.getCenterIndex()}`);
    if (this.getCurrentIndex() !== this.getCenterIndex()) {
      this.setCenterIndex(this.getCurrentIndex());
      this.onDataPrepare(this.getCurrentIndex());
    }
    this.curItem = this.getBrowserController().dataSource?.getRawData(this.getCurrentIndex())?.data ?? new MediaItem();
    this.currentUri = this.curItem.uri;
    if (!DeviceInfo.isPc() || !this.getIsInSwiperAnimation()) {
      this.swiperController?.changeIndex(this.getCurrentIndex());
    }
  }

  protected onDeleteUIFirst(): void {
    super.onDeleteUIFirst();
    if ((this.getBrowserController().dataSource?.totalCount() || 0) > 0) {
      this.broadCast?.emit(BroadCastConstants.ON_DATA_RELOADED, [true]);
    }
  }

  protected onDataReload(addCount?: number): void {
    super.onDataReload(addCount);
    // 当前元素仍然能找到
    const index: number | undefined = this.getBrowserController().dataSource?.getDataIndexByPrefix(this.currentUri);
    const inInvalidUris: boolean =
      this.getBrowserController().dataSource?.getAlbumDataSource()?.invalidUris.includes(this.currentUri) ?? false;
    Log.info(TAG, `ondatareload uiContext, inInvalidUris: ${inInvalidUris}, index: ${index}`);
    if (!this.changeByKeyBoard) {
      if (this.preCount !== this.totalCount) {
        this.countChange();
      }
    }
    this.changeByKeyBoard = false;
    this.preCount = this.totalCount;
    this.stackCount = this.zOperationList.length;

    if (!inInvalidUris && index !== undefined && index !== Constants.NOT_FOUND &&
      this.getBrowserController().dataSource !== undefined &&
      index < this.getBrowserController().dataSource.totalCount()) {
      this.onGetItemIndexByUri(index);
      return;
    }

    let uiContext: UIContext = LocalStorage.getShared()?.get<UIContext>('uiContext') as UIContext;
    Log.info(TAG, `animateTo data reloaded start uiContext: ${uiContext}\
     isDoingDeleteAnim:${this.getIsDoingDeleteAnim()}\
     isDeleting: ${this.getIsDeleting()} currentIndex: ${this.getCurrentIndex()} centerIndex: ${this.getCenterIndex()}\
     isPositiveSliding:${this.getIsPositiveSliding()}`);
    if (!uiContext || this.getIsDoDeleteAnim()) {
      Log.error(TAG, `onDataReload uiContext: ${uiContext}, isDoDeleteAnim: ${this.getIsDoDeleteAnim()}`);
      return;
    }
    this.setIsDeleting(true);
    this.setAnalyzerVisibility(Visibility.Hidden);
    LocalStorage.getShared()?.setOrCreate<boolean>('isPullingUpSwiper', false);

    this.doDeletePhotoAnimation(uiContext);
  }

  // 大图界面数量变化，需要存储ctrl+z的信息;粘贴场景不处理，否则会重复；
  private countChange(): void {
    Log.info(TAG, `countChange: preCount:${this.preCount}, currentCount:${this.totalCount}`);
    let photoUri: string[] = [];
    let photoAsset: photoAccessHelper.PhotoAsset[] = [];
    photoUri.push(this.currentUri);
    if (this.curItem?.data !== undefined) {
      photoAsset.push(this.curItem?.data);
    }
    let nowCount: number = 1;
    if (this.zOperationList.length > 0) {
      nowCount = this.zOperationList[this.zOperationList.length - 1].dataCount + 1;
    }
    if (nowCount > Constants.UNDO_LIMIT) {
      Log.info(TAG, 'undo count beyond limit');
      return;
    }
    if (this.preCount > this.totalCount) {
      this.zOperationList.push({
        action: Action.DELETE.actionID,
        photoUri: photoUri,
        photoAsset: photoAsset,
        dataCount: nowCount,
      })
    }
    Log.info(TAG, `PhotoSwiper Zoperation length is ${this.zOperationList.length}`);
  }

  protected notifyDeletePhoto(): void {
    super.notifyDeletePhoto();
    this.appBroadCast.emit(BroadCastConstants.IS_CLICK_REMOVE_OR_HIDDEN_DIALOG, [true]);
    this.appBroadCast.emit(BroadCastConstants.ON_LEAVE_CURRENT_WINDOW, [this.getCurrentIndex()]);
  }

  protected onFinishDeletePhotoAnimation() {
    super.onFinishDeletePhotoAnimation();
    this.appBroadCast.emit(BroadCastConstants.IS_CLICK_REMOVE_OR_HIDDEN_DIALOG, [false]);
    // THUMBDATASOURCE UPDATE
    if (this.mTransition !== Constants.PHOTO_TRANSITION_TIMELINE_GROUP) {
      this.thumbSource?.updateMapAfterDataDelete();
      this.thumbSource?.mapDeleteData(this.deleteItemPath);
    } else {
      this.getBrowserController().dataSource?.getAlbumDataSource()?.forceUpdate();
    }
  }

  protected onBackPressEvent(): void {
    if (!this.isEditorShown) {
      this.isShowFlushImage = false;
    }
    this.setIsLcdComplete(true);
    this.setIsScrolling(false);
    this.setCurrentIndex(this.getCenterIndex());
    Log.info(TAG, `backPressEventFunc update currentIndex ${this.getCurrentIndex()}`);
    this.smallScroller.scrollToIndex(this.getCenterIndex(), false, ScrollAlign.CENTER);
    this.getBrowserController().dataSource?.updateCurrent(this.getCenterIndex());
  }

  public onShowBarChanged(isShowBar: boolean) {
    if (!DeviceInfo.isPc() && isShowBar && this.getCurrentIndex() !== this.getCenterIndex()) {
      Log.debug(TAG, `onShowChanged this.getCurrentIndex() ${this.getCurrentIndex()}
       this.centerIndex ${this.getCenterIndex()}`);
      this.smallScroller.scrollToIndex(this.getCurrentIndex(), false, ScrollAlign.CENTER);
      this.setCenterIndex(this.getCurrentIndex());
    }
    super.onShowBarChanged(isShowBar);
  }

  protected onShowBarUpdateCapsuleAndProgress(): void {
    if (this.isShowBar && LocalStorage.getShared()?.get('isOpenBrowser')) {
      super.onShowBarUpdateCapsuleAndProgress();
    }
  }

  protected handleSideBarUpdate(): void {
    if (this.isShowBar) {
      this.isShowSideBar = this.isShowSideBarBeforePC;
    } else {
      this.isShowSideBarBeforePC = this.isShowSideBar;
      this.isShowSideBar = false;
    }
  }

  protected videoProgressScrollToByDuration(duration: number): void {
    let xOffset: number = this.getStartOffset() - this.selectedSmallImgWidth + Constants.PREVIEW_PROGRESS_WIDTH / 2 +
      (this.progressRawTime / this.curItem.duration) *
        (this.selectedSmallImgWidth * this.frameNum - Constants.PREVIEW_PROGRESS_WIDTH);
    this.smallScroller?.scrollTo({
      xOffset: xOffset, yOffset: 0,
      animation: { duration: duration, curve: Curve.Linear },
    })
    Log.info(TAG, `videoProgressScrollToByDuration xOffset: ${xOffset} progressRawTime: ${this.progressRawTime}`)
  }

  private finishSwiperAnimation(): void {
    this.swiperController?.finishAnimation((): void => {
      Log.info(TAG, 'finish swiper animation by hand');
    });
  }

  // 第三方入口进 图库 , 数据加载完成收到广播预览条展示
  private dataLoadFinishPreviewer(): void {
    Log.info(TAG, 'From ViewData dataLoadFinished isThumbsourceLoadFinish:' + this.isThumbsourceLoadFinished +
      ' thumbsource size:' + this.thumbSource?.totalCount() + ', set isThumbsourceLoadFinished true ');
    this.isThumbsourceLoadFinished = true;
    this.curItem = this.getBrowserController().dataSource?.getData(this.getCurrentIndex())?.item ?? new MediaItem();
    this.currentUri = this.curItem.uri;
    if (this.isFromFACard) {
      // 再次打开大图浏览页面,预览条偏移量计算出错导致不显示预览条,由于index超出activeEndIndex,导致JumpStart中滚动失败.
      // 在数据完成加载后,再次滚动预览条到指定index,防止偏移量计算出错.
      this.smallScroller.scrollToIndex(this.getCurrentIndex(), false, ScrollAlign.CENTER);
    }
  }

  //stackCount避免直接空按ctrl+z的场景
  private undo(): void {
    Log.info(TAG, `zOperationList's length is ${this.zOperationList.length}`);
    if (this.stackCount !== 0) {
      this.changeByKeyBoard = true;
    }
  }

  private redo(): void {
    this.changeByKeyBoard = true;
    this.zOperationList = [];
    this.yOperationList = [];
  }

  public onEditorShownChange(): void {
    if (!this.isEditorShown) {
      focusControl.requestFocus('PhotoBrowserPreviewBar');
    }
  }

  public smallImgClickAction(uri?: string): void {
    super.smallImgClickAction(uri);
    if (this.skipReactClickAction(uri)) {
      return;
    }
    this.clickToScrollAni = true;
    this.setPreviewProgressOffset(0);
    LocalStorage.getShared()?.setOrCreate<boolean>('isPullingUpSwiper', false);
    /* instrument ignore next */
    if (DeviceInfo.isPc() && this.browserController?.isDetailSelected) {
      this.appBroadCast.emit(BroadCastConstants.PHOTO_PREVIEW_CHANGED_CLOSED_INFO, []);
    }
    if (!this.isEditorShown) {
      let index: number = this.getBrowserController().dataSource.getDataIndexByUri(uri);
      animateTo({
        duration: SCROLL_ANIMATION_DURATION,
        curve: Curves.interpolatingSpring(0, 1, Constants.IMAGE_ITEM_PRESS_CURVE_STIFFNESS,
          Constants.IMAGE_ITEM_PRESS_CURVE_DAMPING),
        onFinish: () => {
          this.clickToScrollAni = false;
        }
      }, (): void => {
        this.smallScroller.scrollToIndex(index, false, ScrollAlign.CENTER);
      });
    }
  }

  protected skipReactClickAction(uri?: string): boolean {
    if (this.stateMachine.isOnSwiperAnimation()) {
      return true;
    }
    return super.skipReactClickAction(uri);
  }

  public makePreviewBarTransition(): TransitionEffect {
    return TransitionEffect.scale({
      // 缩放比例
      x: 1,
      y: 1,
    }).animation({
      duration: DeviceInfo.isPc() ? 300 : PhotoItem.PULL_DOWN_ITEM_ANIM_DURATION,
      curve: DeviceInfo.isPc() ? Curves.interpolatingSpring(0, 1, 228, 30) : Swipes.DELETE_PHOTO_CURVE,
      delay: 0,
      playMode: PlayMode.Normal,
    })
      .combine(
        TransitionEffect.OPACITY.animation({
          duration: DeviceInfo.isPc() ?
            300 : PhotoItem.PULL_DOWN_ITEM_ANIM_DURATION
        })
      )
  }

  protected handleThumbList(index: number, extraInfo: SwiperAnimationEvent): void {
    LocalStorage.getShared()?.setOrCreate<boolean>('isPullingUpSwiper', this.getIsPullingUp());
    // thumbList start
    if (!DeviceInfo.isPc() && !this.isShowBar) {
      return;
    }
    this.stateMachine.processSwiperGestureEvent(index, extraInfo);
    Log.info(TAG, `onGestureSwipe index: ${index} curOffset: ${extraInfo.currentOffset}`);
    this.startTouchIndex = index;
    this.setCurBigOffset(extraInfo.currentOffset);
    let touchOffset = extraInfo.currentOffset / this.deviceWidth * this.smallImgLow;
    if (this.curItem && this.curItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      this.videoFrameOnGesture(extraInfo);
    }
    // 往右划 小于0 true  往左滑 大于0 false
    this.setIsPositiveSliding(touchOffset < 0);
    Log.info(TAG, `startItemOffset: ${index * this.itemWidth} touchOffset: ${touchOffset} extraInfo.currentOffset:
          ${extraInfo.currentOffset} this.shrinkFactor ${this.getShrinkFactor()} this.startOffset ${
    this.getStartOffset()},this.isPositiveSliding ${this.getIsPositiveSliding()}`);
    if (!this.getIsFrameExpand()) {
      this.smallScroller.scrollBy(this.diffOffset - touchOffset, 0);
    }
    this.diffOffset = touchOffset;
    // thumbList end
  }

  protected onSwiperAnimationAniStart(index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) {
    if (!this.stateMachine.isOnSwiperAnimation()) {
      let data = this.getBrowserController().dataSource?.getMediaItemWithoutCache(targetIndex);
      if (data) {
        this.setHistogramNextItem(data);
      }
      LocalStorage.getShared()?.setOrCreate<boolean>('isPullingUpSwiper', this.getIsPullingUp());
      if (this.getIsRunningAnimation()) {
        return;
      }
      if (this.isTriggeredByPause) {
        Log.debug(TAG, 'call swiperDepthOffHand here as manual paused swiper is triggered.');
        this.isTriggeredByPause = false;
      }
    }
    if (targetIndex !== index) {
      this.photoChanged = true;
      this.onDataPrepare(targetIndex);
      this.setIsPreviewBarAnimation(true);
      this.setScrollSnap(ScrollSnapAlign.CENTER);
      this.setListEdgeEffect(EdgeEffect.Spring);
      this.setPreviewProgressOffset(0);
    } else {
      this.photoChanged = false;
    }
  }

  protected handleThumbListAniStart(index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) {
    // thumbList start
    if (!DeviceInfo.isPc() && !this.isShowBar) {
      return;
    }
    Log.info(TAG, `onAnimationStart index: ${index} targetIndex: ${targetIndex}
          curOffset: ${extraInfo.currentOffset} tarOffset: ${extraInfo.targetOffset} velocity: ${extraInfo.velocity}`)
    this.endTouchIndex = targetIndex;
    // 需要check一下这条曲线是否与平台曲线一致
    animateTo({
      curve: Swipes.INTERPOLATING_CURVE, onFinish: () => {
        this.setIsPreviewBarAnimation(false);
      }
    }, (): void => {
      this.setCurBigOffset(0);
      this.setCenterIndex(targetIndex);
      this.videoFrameAniStart(index, targetIndex);
    });
    this.diffOffset = 0;
    // thumbList end
  }

  protected handleSwiperDepthAniEnd(extraInfo: SwiperAnimationEvent) {
    if (!(extraInfo.currentOffset === 0 || AppStorage.get<boolean>(Constants.IS_VIDEO_CLEANUP_PAGE))) {
      animateTo({
        duration: 0,
      }, () => {
        this.swiperDepthByHand(extraInfo.currentOffset);
        this.isTriggeredByPause = true;
      })
    }
  }

  protected handleFinishAnimationEnd(): void {
    let isOpenTouchGuide: boolean = AppStorage.get<boolean>('isOpenTouchGuide') ?? false;
    if (isOpenTouchGuide && this.getIsPullingUp()) {
      Log.info(TAG, 'Photo properties swiper onAnimationEnd,focus to detail component');
      AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_TEXT_INPUT,
        Constants.DELAY_HALF_SECOND);
    }
  }

  protected unregisterBroadCast() {
    super.unregisterBroadCast();
    this.broadCast?.off(PhotoConstants.PULL_DOWN_START, this.finishSwiperAnimationFunc);
    this.broadCast?.off(BrowserConstants.DATA_LOAD_FINISH_PREVIEWER_REFRESH, this.dataLoadFinishPreviewerFunc);
    this.broadCast?.off(BrowserConstants.RESET_VIDEO_FRAME, this.resetVideoFrameFunc);

    this.appBroadCast.off(BroadCastConstants.EDIT_UNDO, this.handleUndoFunc);
    this.appBroadCast.off(BroadCastConstants.EDIT_REDO, this.handleRedoFunc);
  }
}
