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

import lazy Matrix4 from '@ohos.matrix4';
import lazy { PhotoItem } from '../../../../../../browserCommon/src/main/ets/default/view/PhotoItem';
import lazy { BrowserCostReportManager } from '../../../../../../browserCommon/src/main/ets/default/utils/BrowserCostReportManager';
import lazy { BroadCastConstants } from '../model/common/BroadCastConstants';
import lazy { Log } from '../utils/Log';
import lazy { ReplaceUriManager } from '../model/ReplaceUriManager';
import lazy { BroadCast } from '../utils/BroadCast';
import lazy { Constants } from '../model/common/Constants';
import lazy { Constants as BrowserConstants } from '../model/browser/photo/Constants';
import lazy { PhotoDataSource } from '../model/browser/photo/PhotoDataSource';
import lazy { MediaResult } from '../model/browser/photo/MediaResult';
import lazy { BroadCastManager } from '../model/common/BroadCastManager';
import lazy { getScreen, ScreenManager } from '../model/common/ScreenManager';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy Swipes, { SwiperDirection } from '../view/Swipes';
import lazy { PCImageInfo } from '../../../../../../browserCommon/src/main/ets/default/view/PCImageInfo';
import lazy {
  PhotoBrowserStateMachine
} from '../../../../../../browserCommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';

/* instrument ignore file */
const TAG: string = 'common_PhotoSelectedSwiper';

@Component
export struct PhotoSelectedSwiper {
  @ObjectLink stateMachine: PhotoBrowserStateMachine;
  @State imageList: PCImageInfo[] = [];
  replaceUriManager: ReplaceUriManager | undefined = undefined;
  @Link isShowBar: boolean;
  public mTransition: string = '';
  @Consume @Watch('onIndexChange') currentIndex: number;
  @Link broadCast: BroadCast;
  @State mDuration: number = 300;
  onPhotoChanged: Function = (): void => {
  };
  onPressEnter: Function = (): void => {
  };
  public swiperController?: SwiperController;
  public isInSelectedMode: boolean = false;
  @Consume disableSwipe: boolean;
  public swiperItemSpace: number = 8;
  verifyPhotoScaledFunc: (matrix?: Matrix4.Matrix4Transit) => void = (matrix?: Matrix4.Matrix4Transit): void => {
  }
  public canPullingUp: boolean = false;
  @Link isRunningAnimation: boolean;
  public isLeftSwiper: boolean = false;
  @Consume isDeleting: boolean;
  private dataSource: PhotoDataSource | undefined = undefined;
  @Link geometryTransitionEnable: boolean;
  private isFromFACard: boolean = false;
  private SWIPE_CACHE_COUNT: number = 1;
  @Link isPullDownAndDragPhoto: boolean;
  @StorageLink('isDoingDeleteBigPhotoAnim') isDoingDeleteAnim: boolean = false;
  @StorageLink('isBigPhotoLeftToRightAnim') isLeftToRightAnim: boolean = false;
  // For AI text
  @State isDoingImageSlideAnimation: boolean = false;
  @State canRespondPanGesture: boolean = true;
  @State analyzerVisibility: Visibility = Visibility.Visible;
  @State canShowImageAnalyzer: boolean = false;
  @State isTappingAiButton: boolean = false;
  @State isTappingAiButtonChange: boolean = false;
  @State isMenuShow: boolean = false;
  @State isMenuShowStatusChange: boolean = false;
  @State hasSelectedText: boolean = false;
  @State isSelectedTextChange: boolean = false;
  @State isOnDragText: boolean = false;
  @State isInAnimateToPosition: boolean = false;
  @State isScrolling: boolean = false;
  private onDataReloadFun: Function = (addCount: number) => this.onDataReload(addCount);
  private onSwiperDurationChangeFun: Function = (value: number) => this.onSwiperDurationChange(value);
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  // swiper depth
  @State currentImageWidth: number = 0;
  @State windowLayoutWidth: number = getScreen().getWinLayoutWidth();
  @State windowLayoutHeight: number = getScreen().getWinLayoutHeight();
  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();
  @State nextItem?: MediaItem = new MediaItem();
  private nextDisplayedWidth: number = 0;
  @State @Watch('onChangeSwiperDirection') swiperDirection: number = SwiperDirection.DEFAULT;
  private costReportManager: BrowserCostReportManager = BrowserCostReportManager.getInstance();
  // delete
  @State currentDeleteID: string = '';
  @State videoCoverFrame: PixelMap[] = [];
  @Prop private pageStatus: boolean = false;
  private isFromPickerView: boolean = false;
  private isMultiPick: boolean = false;
  private currentMediaUri: string = '';
  geometryTransitionPre: string = '';

  onIndexChange(): void {
    Log.debug(TAG, `onIndexChange ${this.currentIndex}`);
    let currentPhoto: MediaItem | undefined = this.dataSource?.getRawData(this.currentIndex).data;
    if (currentPhoto) {
      this.currentMediaUri = currentPhoto.uri;
    }
    this.stateMachine.setTargetIndex(this.currentIndex);
    this.stateMachine.setCurrentIndex(this.currentIndex);
  }

  // 判断即将运动到窗口内的图片方向
  onChangeSwiperDirection(): void {
    Log.info(TAG, `onChangeSwiperDirection ${this.swiperDirection}`);
    if (this.swiperDirection === SwiperDirection.DEFAULT) {
      return;
    } else if (this.swiperDirection === SwiperDirection.LEFT) {
      this.nextItem = this.dataSource?.getDataWithoutCache(this.currentIndex + 1)?.item;
    } else {
      this.nextItem = this.dataSource?.getDataWithoutCache(this.currentIndex - 1)?.item;
    }
    if (this.nextItem) {
      this.nextDisplayedWidth = px2vp(this.nextItem.getDisplayedWidth());
    }
  }

  // size 修正
  private onWinSizeChanged(): void {
    this.windowLayoutWidth = getScreen().getWinLayoutWidth();
    this.windowLayoutHeight = getScreen().getWinLayoutHeight();
  }

  aboutToAppear() {
    // 大图浏览初始化时，浏览大图打点数据重置
    this.onIndexChange();
    this.costReportManager.resetCostInfo();
    this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadFun);
    this.broadCast.on(BroadCastConstants.CHANGE_SWIPER_DURATION, this.onSwiperDurationChangeFun);
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
  }

  aboutToDisappear() {
    this.costReportManager.report();
    // // 大图浏览结束时，浏览大图打点数据重置
    this.costReportManager.resetCostInfo();
    this.broadCast.off(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadFun);
    this.broadCast.off(BroadCastConstants.CHANGE_SWIPER_DURATION, this.onSwiperDurationChangeFun);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
  }

  @Builder
  buildColumn(result: MediaResult) {
    if (result) {
      Column() {
        PhotoItem({
          photoBrowserStateMachine: this.stateMachine,
          replaceUriManager: this.replaceUriManager,
          mediaResult: result,
          transitionTag: this.mTransition ? this.mTransition : 'default_id',
          verifyPhotoScaled: this.verifyPhotoScaledFunc,
          albumUri: this.dataSource?.getAlbumUri() ?? '',
          canPullingUp: this.canPullingUp,
          geometryTransitionEnable: this.geometryTransitionEnable,
          geometryId: this.geometryTransitionPre + result.item?.uri,
          broadCast: $broadCast,
          isRunningAnimation: $isRunningAnimation,
          isFromFACard: this.isFromFACard,
          isInSelectedMode: this.isInSelectedMode,
          dataSource: this.dataSource,
          isPullDownAndDragPhoto: $isPullDownAndDragPhoto,
          isDoingDeleteAnim: $isDoingDeleteAnim,
          isLeftToRightAnim: $isLeftToRightAnim,
          isPreviewListScrolling: $isScrolling,
          isShowImageAnalyzer: false,
          onPressEnter: (): void => this.onPressEnter(),

          // Some state for image analyzer behaviors
          isDoingImageSlideAnimation: $isDoingImageSlideAnimation,
          canRespondPanGesture: $canRespondPanGesture,
          isTappingAiButton: $isTappingAiButton,
          isTappingAiButtonChange: $isTappingAiButtonChange,
          isMenuShow: $isMenuShow,
          isMenuShowStatusChange: $isMenuShowStatusChange,
          hasSelectedText: $hasSelectedText,
          isSelectedTextChange: $isSelectedTextChange,
          isOnDragText: $isOnDragText,
          isInAnimateToPosition: $isInAnimateToPosition,
          currentImageWidth: $currentImageWidth,
          currentDeleteID: $currentDeleteID,
          isShowBar: $isShowBar,
          isThird: true,
          pageStatus: this.pageStatus,
          isFromPickerView: this.isFromPickerView,
          isMultiPick: this.isMultiPick,
          imageList: this.imageList,
          videoCoverFrame: this.videoCoverFrame,
        })
      }.zIndex(result.pos == this.currentIndex ? 2 : 1)
    }
  }

  build() {
    Swiper(this.swiperController) {
      LazyForEach(this.dataSource as PhotoDataSource, (result: MediaResult, index?: number) => {
        this.buildColumn(result);
      }, (result: MediaResult, index?: number) => {
        if (result === null || result === undefined) {
          return JSON.stringify(result) + index;
        }
        return `${result.item?.path}_${this.geometryTransitionEnable}`;
      })
    }
    .cachedCount(this.SWIPE_CACHE_COUNT)
    .duration(Swipes.MAIN_SWIPE_DURATION)
    .curve(Swipes.INTERPOLATING_CURVE)
    .itemSpace(this.swiperItemSpace)
    .index(this.currentIndex)
    .clip(false)
    .indicator(false)
    .loop(false)
    .onChange((index: number) => {
      this.onChange(index);
    })
    .disableSwipe(this.disableSwipe)
    .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
      this.handleGestureSwipe(index, extraInfo);
    })
    .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent): void => {
      this.broadCast?.emit(BroadCastConstants.UPDATE_SWIPER_ANIMATION, [true]);
      this.handleAnimationStart(index, targetIndex, extraInfo);
    })
    .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent): void => {
      this.handleAnimationEnd(index, extraInfo);
      this.broadCast?.emit(BroadCastConstants.UPDATE_SWIPER_ANIMATION, [false]);
    })
  }

  private handleGestureSwipe(index: number, extraInfo: SwiperAnimationEvent): void {
    this.swiperDepthByHand(extraInfo.currentOffset);
    if (!this.stateMachine.isOnSwiperAnimation()) {
      this.stateMachine.processSwiperGestureEvent(index, extraInfo);
      this.broadCast?.emit(BroadCastConstants.UPDATE_SWIPER_ANIMATION_STATE, [true]);
    }
  }

  private handleAnimationStart(index: number, targetIndex: number, extraInfo: SwiperAnimationEvent): void {
    this.swiperDirection = SwiperDirection.DEFAULT;
    //滑动动效开始时异步触发
    if (targetIndex !== index) {
      this.stateMachine.processSwiperAnimationStartEvent(index, index, extraInfo);
      this.appBroadCast.emit(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, [index]);
      this.appBroadCast.emit(BroadCastConstants.PHOTO_SWIPER_SELECT_CHANGED, [targetIndex]);
      this.appBroadCast.emit(BroadCastConstants.ON_LEAVE_CURRENT_WINDOW, [index]);
    }
  }

  private handleAnimationEnd(index: number, extraInfo: SwiperAnimationEvent): void {
    this.stateMachine.processSwiperAnimationEndEvent(index, extraInfo);
    this.broadCast?.emit(BroadCastConstants.UPDATE_SWIPER_ANIMATION_STATE, [false]);
    if (extraInfo.currentOffset !== 0) {
      animateTo({
        duration: 0,
      }, () => {
        this.swiperDepthByHand(extraInfo.currentOffset);
      })
    }
  }

  private onChange(index: number): void {
    this.costReportManager.switch();
    this.appBroadCast.emit(BrowserConstants.REQUEST_QUALITY_IMAGE, [index]);
    if (this.currentIndex - index === 1) {
      this.isLeftSwiper = true;
    } else if (this.currentIndex - index === -1) {
      this.isLeftSwiper = false;
    }
    if (this.mDuration != 0) {
      this.onPhotoChanged(index);
      this.broadCast.emit(BroadCastConstants.UPDATE_EDIT_ITEM, []);

      this.verifyPhotoScaledFunc?.(undefined);
    }
    //swiper index变化时立即触发
    this.appBroadCast.emit(BroadCastConstants.SWIPER_INDEX_CHANGED, [index]);
  }

  private onDataReload(addCount: number): void {
    if (addCount > 0) {
      this.dataSource?.onDataReloaded();
      if (!this.currentMediaUri) {
        return;
      }
      let currentDataIndex: number = this.dataSource?.getDataIndexByUri(this.currentMediaUri) ?? Constants.INVALID;
      Log.info(TAG, `onDataReload currentDataIndex : ${currentDataIndex}`);
      if (currentDataIndex !== Constants.INVALID) {
        this.currentIndex = currentDataIndex;
      }
      Log.info(TAG, `ON_DATA_RELOADED: ${this.currentIndex}, ${addCount}`);
      return;
    } else {
      Log.info(TAG, `photoSelectedSwiper reloaded addCount is: ${addCount}`);
    }
  }

  private onSwiperDurationChange(value: number): void {
    Log.debug(TAG, `change duration start ${value}`);
    this.mDuration = value;
  }

  private swiperDepthByHand(currentOffset: number): void {
    this.swiperDirection = currentOffset > 0 ? SwiperDirection.RIGHT : SwiperDirection.LEFT;
  }
}