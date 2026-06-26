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

import lazy { PhotoConfig } from '@ohos/common/src/main/ets/default/config/PhotoConfig';
import lazy { BrowserAnimController } from '@ohos/common/src/main/ets/default/model/BrowserAnimController';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy Swipes from '@ohos/common/src/main/ets/default/view/Swipes';
import lazy { SCROLL_ANIMATION_DURATION, SwiperVM } from './SwiperVM';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { MediaResult } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaResult';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { window } from '@kit.ArkUI';
import lazy { BrowserCaller } from './ShowBrowserParam';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';

const TAG: string = 'browser_SwiperThirdVM';

export class SwiperThirdVM extends SwiperVM {
  private isShowOrHideBar: boolean = false;
  /* instrument ignore next */
  private pullDownStartFunc: Function = (event: KeyEvent): void => this.pullDownStart(event);
  /* instrument ignore next */
  private pullDownEndFunc: Function = (): void => this.pullDownEnd();
  private isShowOrHideBarFunc: Function = (isShowOrHideBar: boolean): void => {
    this.isShowOrHideBar = isShowOrHideBar;
  }
  private dataLoadFinishPreviewerFunc: Function = (): void => {
    this.dataLoadFinishPreviewer();
  }

  public onCreate(browserAnimController: BrowserAnimController): void {
    super.onCreate(browserAnimController);
    let geometryTransitionId: string | undefined =
      LocalStorage.getShared()?.get<string | undefined>('geometryTransitionBrowserId')
    if (!geometryTransitionId && PhotoConfig.isFromMeetime) {
      /* instrument ignore next */
      LocalStorage.getShared()?.setOrCreate('geometryTransitionBrowserId',
        this.browserController?.getSingleGeometryId());
    }
    /* instrument ignore next */
    this.getBrowserController().swiperOnFoldChange = () => this.onFoldChanged();

    this.isThumbsourceLoadFinished = true;

    this.statisticRptMgr.init();
    if (this.getBrowserController().pageFrom === BrowserCaller.CAMERA_PAGE) {
      AccessibilityUtil.sendFocusAccessibilityEvent(`photoItem_Column`);
    }
    if (this.isShowThumbSource) {
      this.isShowThumbSource = false;
      setTimeout((): void => {
        this.isShowThumbSource = true;
      }, Swipes.THUMB_SOURCE_DELAY_TIME);
    }
  }

  /* instrument ignore next */
  private onFoldChanged(): void {
    try {
      this.isFoldExpandedEnhancer = DeviceInfo.isFoldable();
      if (!DeviceInfo.isGRLFoldScreen()) {
        this.updateSwiperHeight();
      }
    } catch (err) {
      Log.error(TAG, `foldChange error:${JSON.stringify(err)}`);
    }
  }

  protected registerBroadCast() {
    super.registerBroadCast();
    this.broadCast?.on(BrowserConstants.PULL_DOWN_START, this.pullDownStartFunc);
    this.broadCast?.on(BrowserConstants.PULL_DOWN_END, this.pullDownEndFunc);
    this.broadCast?.on(BrowserConstants.DATA_LOAD_FINISH_PREVIEWER_REFRESH, this.dataLoadFinishPreviewerFunc);
    this.appBroadCast.on(BroadCastConstants.IS_SHOW_OR_HIDE_BAR, this.isShowOrHideBarFunc);
  }

  public isSlideBarVisibility(isVideoPlay?: boolean, isSlideBarHover?: boolean): boolean {
    if (isSlideBarHover) {
      /* instrument ignore next */
      return true;
    }
    if (!this.thumbSource) {
      /* instrument ignore next */
      return false;
    }
    this.totalCount = this.thumbSource.totalCount();
    return this.isShowBar && !this.isEditorShown && !this.isInSelectedMode &&
      (this.totalCount > 1 || this.curItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO);
  }

  public updateSwiperHeight(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
    if (this.getIsHorizontal() && !DeviceInfo.isPc() ||
      (DeviceInfo.isFoldable() && this.getIsFullMode() && !DeviceInfo.isPhoneVde())) {
      this.swiperListHeight = DeviceInfo.isTablet() ?
      $r('app.float.pad_slider_bar_horizon_height') : $r('app.float.slider_bar_horizon_height');
    } else if (DeviceInfo.isPc() || DeviceInfo.isTablet()) {
      /* instrument ignore next */
      this.swiperListHeight = $r('app.float.pc_slider_bar_height');
    } else {
      this.swiperListHeight = $r('app.float.slider_bar_height');
    }
  }

  public updateDataSourceMarginAndWidth(): boolean {
    let updateFinish: boolean = super.updateDataSourceMarginAndWidth();
    if (!updateFinish) {
      this.setTargetOffset(0);
    }
    return true;
  }

  protected jumpStart(): void {
    super.jumpStart();
    Log.info(TAG, `jumpStart, currentIndex: ${this.getCurrentIndex()}, centerIndex: ${this.getCenterIndex()}`);
    if (this.getCurrentIndex() !== this.getCenterIndex()) {
      this.setCenterIndex(this.getCurrentIndex());
      this.browserController?.onDataPrepare(this.getCurrentIndex());
    }
  }

  protected onDeleteUIFirst(): void {
    super.onDeleteUIFirst();
    if ((this.getBrowserController().dataSource?.getAlbumDataSource()?.mediaCount || 0) > 1) {
      this.broadCast?.emit(BroadCastConstants.ON_DATA_RELOADED, [-1]);
    }
  }

  protected onDeleteLast(): void {
    if (this.getCurrentIndex() === this.getBrowserController().dataSource?.totalCount() - 1) {
      this.setIsPositiveSliding(false);
    }
  }

  /**
   * Swiper 数据重新加载回调
   */
  protected onDataReload(addCount: number): void {
    super.onDataReload(addCount);
    if (addCount >= 0) {
      if (this.getBrowserController().dataSource != null) {
        this.onGetItemIndexByUri(this.getBrowserController().dataSource.getDataIndexByUri(this.curItem?.uri));
        this.setCenterIndex(this.getCurrentIndex());
      }
      return;
    }
    Log.info(TAG, 'animate to data reloaded start');
    let uiContext: UIContext = LocalStorage.getShared()?.get<UIContext>('uiContext') as UIContext;
    if (this.getIsDoingDeleteAnim()) {
      this.setAnalyzerVisibility(Visibility.Hidden);
    }
    if (!uiContext || this.getIsDoDeleteAnim()) {
      Log.error(TAG, `onDataReload uiContext: ${uiContext}, isDoDeleteAnim: ${this.getIsDoDeleteAnim()}`);
      return;
    }
    if (!AppStorage.get<boolean>('isWinSizeChanging') ?? true) {
      this.setIsDeleting(true);
    }
    this.doDeletePhotoAnimation(uiContext);
  }

  protected onFinishDeletePhotoAnimation() {
    super.onFinishDeletePhotoAnimation();
    // THUMBDATASOURCE UPDATE
    this.thumbSource?.updateMapAfterDataDelete();
    this.thumbSource?.mapDeleteData(this.deleteItemPath);
  }

  protected onBackPressEvent(): void {
    Log.info(TAG, 'onBackPressEvent start');
    this.setImagePadding({});
    if (!this.isShowThumbSource) {
      /* instrument ignore next */
      return;
    }
    if (!this.isShowOrHideBar) {
      if (!this.isEditorShown) {
        this.isShowFlushImage = false;
      }
      this.setIsLcdComplete(true);
      this.setIsScrolling(false);
      this.getBrowserController().setCurrentIndex(this.getCenterIndex());
      this.smallScroller.scrollToIndex(this.getCenterIndex(), false, ScrollAlign.CENTER);
    }
  }

  public onShowBarChanged(isShowBar: boolean) {
    this.isShowBar = isShowBar;
    this.isSlideBarShow = this.isSlideBarVisibility();
    super.onShowBarChanged(isShowBar);
  }

  public shouldShowPreview(): boolean {
    // 与基础 SwiperVM 保持一致，只要进入大图即允许显示预览条，
    // 不再强依赖 albumDataSource 是否存在，保证 VIEWDATA 与图库入口表现一致
    return super.shouldShowPreview();
  }

  protected onShowBarUpdateCapsuleAndProgress(): void {
    if (this.isShowBar) {
      super.onShowBarUpdateCapsuleAndProgress();
    }
  }

  protected videoProgressScrollToByDuration(duration: number): void {
    let xOffset: number = this.getStartOffset() - this.selectedSmallImgWidth + Constants.PREVIEW_PROGRESS_WIDTH / 2 +
      (this.progressRawTime / this.getCapsuleTotalDurationMs()) *
        (this.selectedSmallImgWidth * this.frameNum - Constants.PREVIEW_PROGRESS_WIDTH);
    if (duration < 0) {
      this.smallScroller?.scrollTo({
        xOffset: xOffset, yOffset: 0,
        animation: { curve: BrowserConstants.CLICK_PLAY_FRAME_EXPAND_LIST_CURVE },
      })
    } else {
      this.smallScroller?.scrollTo({
        xOffset: xOffset, yOffset: 0,
        animation: { duration: duration, curve: Curve.Linear },
      })
    }
    Log.info(TAG, `videoProgressScrollToByDuration xOffset: ${xOffset} progressRawTime: ${
    this.progressRawTime} duration: ${duration}`);
  }

  /* instrument ignore next */
  private pullDownStart(event: KeyEvent): void {
    this.isPullDownStart = true;
  }

  /* instrument ignore next */
  private pullDownEnd(): void {
    this.isPullDownStart = false;
  }

  // 第三方入口进 图库 , 数据加载完成收到广播预览条展示
  private dataLoadFinishPreviewer(): void {
    if (this.isThumbsourceLoadFinished) {
      return;
    }
    Log.info(TAG, 'From ViewData dataLoadFinished isThumbsourceLoadFinish:' + this.isThumbsourceLoadFinished +
      ' thumbsource size:' + this.thumbSource?.totalCount() + ', set isThumbsourceLoadFinished true ');
    this.isThumbsourceLoadFinished = true;
    this.setCurrentDisplayItem(this.getBrowserController().dataSource?.getData(
      this.getBrowserController().getCurrentIndex())?.item ?? new MediaItem());
  }

  public smallImgClickAction(uri?: string): void {
    super.smallImgClickAction(uri);
    if (this.skipReactClickAction(uri)) {
      return;
    }
    /* instrument ignore next */
    if (DeviceInfo.isPc() && this.browserController?.isDetailSelected) {
      this.appBroadCast.emit(BroadCastConstants.PHOTO_PREVIEW_CHANGED_CLOSED_INFO, []);
    }
    let index: number = this.getBrowserController().dataSource.getDataIndexByUri(uri);
    if (!this.isEditorShown) {
      animateTo({ duration: SCROLL_ANIMATION_DURATION, curve: Curve.Linear }, (): void => {
        this.smallScroller.scrollToIndex(index, false, ScrollAlign.CENTER);
      });
    }
  }

  protected handleThumbList(index: number, extraInfo: SwiperAnimationEvent): void {
    // thumbList start
    this.setIsSwiperOffsetZero(false);
    Log.info(TAG, `onGestureSwipe index: ${index} curOffset: ${extraInfo.currentOffset}`);
    this.startTouchIndex = index;
    this.setCurBigOffset(extraInfo.currentOffset);
    let touchOffset = extraInfo.currentOffset / this.deviceWidth * this.smallImgLow;
    if (this.curItem && this.curItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      this.videoFrameOnGesture(extraInfo);
    }
    // 往右划 小于0 往左滑 大于0
    this.setIsPositiveSliding(touchOffset < 0);
    Log.info(TAG, `startItemOffset: ${index * this.itemWidth}, touchOffset: ${touchOffset},
            extraInfo.currentOffset: ${extraInfo.currentOffset},
            this.shrinkFactor ${this.getShrinkFactor()}, this.startOffset ${this.getStartOffset()}`);
    if (!this.getIsFrameExpand()) {
      this.smallScroller.scrollBy(this.diffOffset - touchOffset, 0);
    }
    this.diffOffset = touchOffset;
    // thumbList end
  }

  protected onSwiperAnimationAniStart(index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) {
    if (!this.isOnSwiperAnimation()) {
      let data = this.getBrowserController().dataSource.getDataWithoutCache(targetIndex)?.item;
      if (data) {
        this.setHistogramNextItem(data);
      }
    }
    if (targetIndex !== index) {
      this.photoChanged = true;
      this.getBrowserController().onDataPrepare(targetIndex);
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
    Log.info(TAG, `onAnimationStart index: ${index} targetIndex: ${targetIndex} curOffset:
          ${extraInfo.currentOffset} tarOffset: ${extraInfo.targetOffset} velocity: ${extraInfo.velocity}`)
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
    if (Math.floor(Math.abs(extraInfo.currentOffset)) === 0) {
      this.setIsSwiperOffsetZero(true);
    } else {
      animateTo({
        duration: 0,
      }, () => {
        this.swiperDepthByHand(extraInfo.currentOffset);
      })
    }
  }

  public onDestroy(): void {
    super.onDestroy();
    this.getBrowserController().swiperOnFoldChange = undefined;
    this.statisticRptMgr.end();
  }

  protected unregisterBroadCast() {
    super.unregisterBroadCast();
    this.broadCast?.off(BrowserConstants.PULL_DOWN_START, this.pullDownStartFunc);
    this.broadCast?.off(BrowserConstants.PULL_DOWN_END, this.pullDownEndFunc);
    this.appBroadCast.off(BroadCastConstants.IS_SHOW_OR_HIDE_BAR, this.isShowOrHideBarFunc);
    this.broadCast?.off(BrowserConstants.DATA_LOAD_FINISH_PREVIEWER_REFRESH, this.dataLoadFinishPreviewerFunc);
  }
}
