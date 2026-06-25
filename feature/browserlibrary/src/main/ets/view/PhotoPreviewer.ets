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

import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { BasePhotoBrowserController } from '../model/BasePhotoBrowserController';
import lazy {
  AvPlayConstants,
  AvplayerStatus,
  PauseReason
} from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { PreviewItem } from '@ohos/browsercommon/src/main/ets/default/view/PreviewItem';
import lazy { PreviewThumbnail } from '@ohos/browsercommon/src/main/ets/default/view/PreviewThumbnail';
import lazy { ThumbDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/ThumbDataSource';
import lazy { MediaResult } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaResult';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy Previewer from '@ohos/common/src/main/ets/default/view/swiper/Previewer';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy { BigDataConstants,
  CountMsg,
  ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy Swipes from '@ohos/common/src/main/ets/default/view/Swipes';
import lazy { MultimodalInputManager } from '@ohos/common/src/main/ets/default/model/common/MultimodalInputManager';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { VideoPlayController } from '@ohos/browsercommon/src/main/ets/default/controller/VideoPlayController';
import lazy { media } from '@kit.MediaKit';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy {
  getScreen,
  isOrientationHorizontal,
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { SwiperPreviewStateListener, SwiperVM } from '../model/SwiperVM';
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import lazy { AnchorDirection, SCROLL_ANIMATION_DURATION } from './SwiperView';
import lazy { ImageFlushItem } from '@ohos/browsercommon/src/main/ets/default/view/ImageFlushItem';

/* instrument ignore file  */
const TAG: string = 'browser_PhotoPreviewer';

const SCROLL_MAX_FLING_SPEED: number = 1000;
/**
 * list缓存的item的个数
 */
const LIST_CACHE_COUNT: number = 7;

const TIME_CAPSULE_MAX_FONT_SIZE: number = 1.5;

// 大图组件图片下面的浏览条
@Component
export struct PhotoPreviewer {
  @Consume isShowVideo: boolean;

  @ObjectLink browserController: BasePhotoBrowserController;
  @ObjectLink stateMachine: PhotoBrowserStateMachine;
  @Link viewModel: SwiperVM;
  @ObjectLink curItem: MediaItem;
  @Link broadCast: BroadCast
  @Link timeCapsuleRawTime: number;
  @Link isFrameExpand: boolean;
  @Link isShowBar: boolean;
  @Link isVideoPlaying: boolean;
  @Link shrinkFactor: number;
  @Link targetOffset: number;
  @Link curBigOffset: number;
  @Link startOffset: number;
  @Link expectedProgressRawTime: number;
  @Link waitingForTimeSync: boolean;
  @Link videoCoverFrame: PixelMap[];
  @Link centerIndex: number;
  @Link startTouchIndex: number;
  @Link forceRefresh: number;
  @Link isFrameOpenAni: boolean;
  @Link isSlideBarShow: boolean;
  @Link scrollSnap: ScrollSnapAlign;
  @Link listEdgeEffect: EdgeEffect;
  @Link isEditorShown: boolean;
  @Link isScrolling: boolean;
  @Link isVideoToEnd: boolean;
  @Link isRunningAnimation: boolean;
  @Link anchorDirection: AnchorDirection;
  @Link centerPreviewOpacity: number;
  @Link previewItemOpacity: number;
  @Link isLcdComplete: boolean;
  @Link isPositiveSliding: boolean;
  @Link isPreviewBarAnimation: boolean;
  @Link opacityValue: number;
  @Link previewProgressOffset: number;

  showEditor: Function = (): void => {
  };
  thumbSource?: ThumbDataSource;
  smallScroller: Scroller = new Scroller();
  @ObjectLink videoPlayController?: VideoPlayController;
  swiperController: SwiperController = new SwiperController();

  @Prop isPrivateHideState: boolean = false;

  @LocalStorageLink('geometryOpacity') private geometryOpacity: number = 1;
  @LocalStorageLink('barGeometryOpacity') barGeometryOpacity: number = 1;
  // 进入和退出连拍时，大图图片的透明度
  @Prop swiperOpacityWithBurstPhotos: number = 1;
  @LocalStorageLink('isDoingImmersiveAnimationPC') isDoingImmersiveAnimationPC: boolean = false;
  @LocalStorageLink('isPcShowingEditor') isPcShowingEditor: boolean = false;
  @LocalStorageLink('previewStackHeight') previewStackHeight: number = 0;
  /**
   * 直方图 仅加载即将进入窗口的下一张图片
   */
  @LocalStorageLink('pcHistogramNextItem') pcHistogramNextItem: MediaItem = new MediaItem();
  @StorageLink('isHorizontal') @Watch('onRotateScreen') private isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('isFullMode') @Watch('isFullModeChanged') private isFullMode: boolean = getScreen().isFullMode();
  @StorageLink('navigationBarHeight') private navigationBarHeight: number = 0;
  @StorageLink('navigationBarBottomHeight') private navigationBarBottomHeight: number = 0;
  // 记录当前系统深浅色模式
  @StorageProp('currentColorMode') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;

  @State private isFullModeEnhancer: boolean = getScreen().isFullMode();

  /**
   * 逐帧播放：是否在触摸展开前的视频预览区域
   */
  @State private isTouchVideoPreview: boolean = false;
  /**
   * 逐帧播放：鼠标点击情况下，标记是否正在拖动list组件；等同于手指搓动情况下的isFingerSlide
   */
  @State private isMouseSlideList: boolean = false;
  @State currentScrollState: number = 0;
  @State stateReported: media.AVPlayerState | undefined = undefined;
  /**
   * 逐帧播放：鼠标点击情况下，拖动list组件的偏移量（list组件不支持鼠标点击情况下的拖拽）
   */
  @State listOffsetByMouse: number = 0;
  @State mousePositionX: number = Number.NaN;
  @LocalStorageLink('isShowSideBar') isShowSideBar: boolean = true;

  /**
   * 逐帧播放：list滑动前，视频是否为播放状态
   */
  private isVideoPlayBeforeSlide: boolean = false;
  /**
   *下拉或侧滑分割线透明度
   */
  private dividerOpacity: number = 0;
  /**
   * 逐帧播放：滑动预览条时是否超出边界
   */
  private selectedSmallImgWidth: number = ImageUtil.getSelectedSmallImgWidth();
  private timeoutId: number = 0;
  /**
   * 逐帧播放：seek发送的时间点
   */
  private seekTime: number = 0;
  private isTouchUpPlaying: boolean = false;
  private targetStatusOnCloudFrame: string | undefined = undefined;
  private scrollTimer: number = Number.NaN;
  private sliderBarDividerWidth: string = '1px';
  private widthScale: number = 0.5;
  private tempIndex: number = Number.NaN;

  /**
   * 应用级广播，保存关键监听回调
   */
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private onSmallImgClickFunc: Function = (uri: string): void => this.viewModel.smallImgClickAction(uri);
  /**
   * 逐帧播放：点击展开方法
   */
  private onVideoFrameClickFunc: Function = (uri: string): void => this.viewModel.videoFrameClickAction(uri);

  private onRotateScreen(): void {
    this.viewModel.updateSwiperHeight();
  }

  private isFullModeChanged(): void {
    this.isFullModeEnhancer = getScreen().isFullMode();
  }

  private swiperStateListener: SwiperPreviewStateListener = {
    onStateReportedChanged: (stateReported: media.AVPlayerState) => {
      if (this.stateReported !== stateReported) {
        this.stateReported = stateReported;
      }
    }
  }

  aboutToDisappear(): void {
    this.viewModel.unRegisterPreviewStateListener();
    this.clearScrollTimer();
  }

  aboutToAppear(): void {
    this.viewModel.registerPreviewStateListener(this.swiperStateListener);
    this.appBroadCast.emit(BroadCastConstants.GET_VIDEO_FRAME_FOR_PREVIEW + this.curItem.uniqueId, []);
  }

  private getPreviewProgressHeight(): number {
    return (DeviceInfo.isPc() || DeviceInfo.isTablet())
      ? Constants.WAVE_PAD_PREVIEW_PROGRESS_HEIGHT :
      (DeviceInfo.isTv() ? Constants.TV_WAVE_PREVIEW_PROGRESS_HEIGHT : Constants.WAVE_PREVIEW_PROGRESS_HEIGHT);
  }

  private getPreviewProgressWidth(): Length {
    return DeviceInfo.isTv() ? Constants.TV_PREVIEW_PROGRESS_WIDTH : Constants.PREVIEW_PROGRESS_WIDTH;
  }

  private getPreviewProgressBorderColor(): ResourceColor | EdgeColors | LocalizedEdgeColors {
    return DeviceInfo.isTv() ? Constants.TV_PREVIEW_PROGRESS_BORDER_COLOR :
    Constants.PREVIEW_PROGRESS_BORDER_COLOR;
  }

  private getPreviewProgressBorderWidth(): Length | EdgeWidths | LocalizedEdgeWidths {
    return DeviceInfo.isTv() ? Constants.TV_PREVIEW_PROGRESS_BORDER_WIDTH :
    Constants.PREVIEW_PROGRESS_BORDER_WIDTH;
  }

  private getPreviewProgressBorderRadius(): Length | BorderRadiuses | LocalizedBorderRadiuses {
    return DeviceInfo.isTv() ? Constants.TV_PREVIEW_PROGRESS_BORDER_RADIUS :
    Constants.PREVIEW_PROGRESS_BORDER_RADIUS;
  }

  private handleKeyEvent(event: KeyEvent): void {
    if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_ESC ||
      event.keyCode === MultimodalInputManager.KEY_CODE_SPACE) {
      this.broadCast?.emit(BrowserConstants.PULL_DOWN_END, []);
    } else if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_ENTER) {
      this.showEditor(this.browserController.dataSource.getItemByUri(this.curItem?.uri));
    }
  }

  /**
   * 视频xxx时，禁掉list的滚动回调
   */
  private disableScrollCallBack(): boolean {
    Log.info(TAG, `${BrowserConstants.TAG_VIDEO_PLAY_BY_FRAME} disableScrollCallBack  ${this.isFrameExpand}`)
    return this.isFrameExpand || this.isTouchVideoPreview;
  }

  /**
   * 起始：视频xxx时拖动预览帧
   */
  private slideVideoFrameBarStart(): void {
    this.isVideoPlayBeforeSlide = !this.isVideoPlaying;
  }

  private slideVideoFrameBarMove(): void {
    let offset: number = this.smallScrollerOffset() -
      (this.startOffset - this.selectedSmallImgWidth + Constants.PREVIEW_PROGRESS_WIDTH / 2);
    let width = this.viewModel.frameNum * this.selectedSmallImgWidth - Constants.PREVIEW_PROGRESS_WIDTH;
    // list组件到达边界时存在边界回弹，hasSeek用于避免首尾的多次seek
    let hasSeek = false;
    if (this.seekTime <= 0) {
      hasSeek = true;
    }
    this.seekTime = Math.floor(this.curItem.duration * offset / width);
    this.seekTime = this.seekTime < 0 ? 0 : this.seekTime > this.curItem.duration ? this.curItem.duration :
    this.seekTime;
    try {
      this.viewModel.setTimeCapsuleRawTime(this.seekTime);
      this.viewModel.setProgressRawTime(this.seekTime);
      let offsetTime = this.curItem.duration - this.seekTime;
      if (offsetTime > Constants.SEEK_ALLOWABLE_OFFSET_TIME ||
        this.videoPlayController?.getAvPlayerState() !== AvplayerStatus.COMPLETED) {
        this.videoPlayController?.updateSeekRawTime(this.seekTime);
      }
      if (this.isTouchUpPlaying || hasSeek) {
        return;
      }
      Log.info(TAG, `${BrowserConstants.TAG_VIDEO_PLAY_BY_FRAME} slideVideoFrameBarMove, \
      width: ${width}, duration: ${this.curItem.duration}  offset: ${offset} seek to time : ${this.seekTime}, \
      isCloud: ${this.curItem.getPosition?.() === photoAccessHelper.PositionType.CLOUD} \
      getAvPlayerState:${this.videoPlayController?.getAvPlayerState()}`);
      if (this.isCloudOrSeekUnSupported()) {
        //云视频或者seekContinuous格式不支持
        this.videoPlayController?.getAvPlayer()?.seek(this.seekTime, media.SeekMode.SEEK_CLOSEST);
      } else {
        // 本地视频且seekContinuous格式支持
        this.videoPlayController?.getAvPlayer()?.seek(this.seekTime, media.SeekMode.SEEK_CONTINUOUS);
      }
    } catch (err) {
      Log.info(TAG, `${BrowserConstants.TAG_VIDEO_PLAY_BY_FRAME}
      slideVideoFrameBarMove seek 3 error ${this.seekTime} ${err}`)
    }
  }

  /**
   * 离手：视频xxx时拖动预览帧
   */
  private slideVideoFrameStop(): void {
    if (this.isFrameExpand && this.viewModel.isFingerSlide) {
      this.slideVideoFrameBarEnd();
    }
    this.viewModel.isFingerSlide = false;
    this.videoPlayController?.updateFingerSlide(false);
  }

  private slideVideoFrameBarEnd(): void {
    let offset: number = this.smallScrollerOffset() -
      (this.startOffset - this.selectedSmallImgWidth + Constants.PREVIEW_PROGRESS_WIDTH / 2);
    let width = this.viewModel.frameNum * this.selectedSmallImgWidth - Constants.PREVIEW_PROGRESS_WIDTH;
    // 是否超出滑动有效范围
    offset = offset < 0 ? 0 : offset > width ? width : offset;
    let endTime: number = Math.floor(this.curItem.duration * offset / width);
    this.expectedProgressRawTime = endTime;
    this.waitingForTimeSync = true;
    // 松手后重新play
    let offsetTime = this.curItem.duration - this.viewModel.progressRawTime;
    Log.info(TAG, `${BrowserConstants.TAG_VIDEO_PLAY_BY_FRAME} slideVideoFrameBarEnd play endTime: ${endTime}\
     viewModel.progressRawTime: ${this.viewModel.progressRawTime} curItem.duration: ${this.curItem.duration} ,offsetTime: ${offsetTime},\
     isTouchUpPlaying: ${this.isTouchUpPlaying} isVideoPlayBeforeSlide: ${this.isVideoPlayBeforeSlide},\
     getAvPlayerState: ${this.videoPlayController?.getAvPlayerState()}`);
    let isVideoPlayCompleted: boolean =
      (this.isVideoPlayBeforeSlide || offsetTime < Constants.SEEK_ALLOWABLE_OFFSET_TIME) &&
        this.videoPlayController?.getAvPlayerState() !== AvplayerStatus.COMPLETED;
    if (isVideoPlayCompleted && !this.isTouchUpPlaying &&
      this.curItem.getPosition?.() !== photoAccessHelper.PositionType.CLOUD &&
      this.videoPlayController?.isSeekContinueSupported()) {
      this.videoPlayController?.setLastReportTime(this.seekTime);
      this.videoPlayController?.play();
      this.isVideoPlaying = false;
    } else if (isVideoPlayCompleted && !this.isTouchUpPlaying && this.isCloudOrSeekUnSupported()) {
      this.cloudVideoFrameScrollEnd();
    } else {
      Log.info(TAG, `ontouch Up isTouchUpPlaying ${this.isTouchUpPlaying},isVideoPlayBeforeSlide \ ${
      this.isVideoPlayBeforeSlide},Position ${this.curItem.getPosition?.()}`);
    }
    this.isTouchUpPlaying = false;
    const msg: Record<string, number | string | boolean> = {
      'url': ReportToBigDataUtil.urlAnonymize(this.curItem.uri),
      'position': this.videoPlayController?.getVideoPlayer()?.getMediaPosition() ?? 'LOCAL',
      'type': BigDataConstants.VIDEO_SLIDE_BY_FRAME_END,
      'startSeek': this.viewModel.progressRawTime,
      'endSeek': endTime,
      'duration': this.curItem.duration,
      'netType': this.videoPlayController?.getVideoPlayer()?.netQuality?.netType() ?? -1,
    };
    ReportToBigDataUtil.report(BigDataConstants.VIDEO_SLIDE_BY_FRAME, msg);
  }

  private cloudVideoFrameScrollStart(): void {
    if (this.videoPlayController?.getAvPlayerState() === AvplayerStatus.PAUSED) {
      return;
    }
    // 不存在表示首次seek，否则是多次seek
    if (!this.targetStatusOnCloudFrame) {
      this.targetStatusOnCloudFrame = this.videoPlayController?.getAvPlayerState();
    } else if (this.targetStatusOnCloudFrame === AvplayerStatus.PLAYING && this.videoPlayController?.getIsPausing()) {
      Log.info(TAG, '[videoPlayer] target status is playing, current is pausing.');
      this.targetStatusOnCloudFrame = AvplayerStatus.PLAYING;
    }
    if (this.videoPlayController?.getAvPlayerState() === AvplayerStatus.PLAYING &&
      !this.videoPlayController?.getIsPausing()) {
      Log.info(TAG, `[videoPlayer] cloud video seek start, state is playing, invoke pause method. targetStatus: ${
      this.targetStatusOnCloudFrame}`);
      this.videoPlayController?.pause(PauseReason.SEEK);
    }
  }

  private cloudVideoFrameScrollEnd(): void {
    Log.info(TAG, `[videoPlayer] cloud video seek end, targetStatus is ${this.targetStatusOnCloudFrame}`);
    if (this.targetStatusOnCloudFrame === AvplayerStatus.PLAYING ||
      this.targetStatusOnCloudFrame === AvplayerStatus.INITIALIZED) {
      this.videoPlayController?.play();
    }
  }

  /**
   * 逐帧播放：滑动预览条时的收起动效
   */
  private videoFrameAniStop(): void {
    animateTo({
      duration: AvPlayConstants.ANI_DURATION,
      curve: Curve.Friction,
    }, () => {
      this.videoCoverFrame = [];
      this.appBroadCast.emit(BroadCastConstants.UPDATE_VIDEO_WIDTH + this.curItem.uniqueId,
        [AvPlayConstants.COVER_FRAME_NUM * this.selectedSmallImgWidth]);
    })
  }

  private smallScrollerOffset(): number {
    return this.smallScroller?.currentOffset()?.xOffset || 0;
  }

  /**
   * 跟手：视频xxx时拖动预览帧
   */
  private slideVideoFrameDidScroll(scrollState: ScrollState): void {
    // false为播放
    if (this.isFrameExpand) {
      if ((scrollState === ScrollState.Scroll || this.isMouseSlideList) && !this.viewModel.isFingerSlide) {
        // 清除滑动前的ai预分析,isVideoPlayBeforeSlide大图组件和图库状态相反
        Log.info(TAG, `slideVideoFrameDidScroll this.isVideoPlayBeforeSlide = ${this.isVideoPlayBeforeSlide}`);
        this.viewModel.isFingerSlide = true;
        const msg: Record<string, number | string | boolean> = {
          'url': ReportToBigDataUtil.urlAnonymize(this.curItem?.uri),
          'type': BigDataConstants.VIDEO_SLIDE_BY_FRAME_START,
          'startSeek': this.viewModel.progressRawTime,
          'duration': this.curItem.duration
        };
        ReportToBigDataUtil.report(BigDataConstants.VIDEO_SLIDE_BY_FRAME, msg);
        this.videoPlayController?.updateFingerSlide(true);
        if (this.isCloudOrSeekUnSupported()) {
          this.cloudVideoFrameScrollStart();
        }
      }
      if (this.viewModel.isFingerSlide) {
        this.slideVideoFrameBarMove();
      }
    }
  }

  /**
   * 视频seekContinuous格式不支持或者为云
   */
  private isCloudOrSeekUnSupported(): boolean {
    return this.videoPlayController ? (this.curItem.getPosition?.() === photoAccessHelper.PositionType.CLOUD ||
      !this.videoPlayController.isSeekContinueSupported()) : false;
    return false
  }

  /**
   * 预览条：手势响应事件是否存在
   */
  private isExistGestureEvent(event: GestureEvent): boolean {
    if (!event) {
      Log.warn(TAG, 'gesture event does not exist');
      return false;
    }
    return true;
  }

  /**
   * 预览条：是否允许响应滑动事件
   */
  private isAllowPan(): boolean {
    return this.isFrameExpand;
  }

  private clearScrollTimer(): void {
    if (!Number.isFinite(this.scrollTimer)) {
      return;
    }
    clearTimeout(this.scrollTimer);
    this.scrollTimer = Number.NaN;
  }

  private stackListMarginBottom(): number {
    return DeviceInfo.isPc() ? Constants.PC_LIST_MARGIN_BOTTOM : Constants.PHONE_LIST_MARGIN_BOTTOM;
  }

  private swiperPaddingBottom(): number | Resource {
    return this.isHorizontal || this.notVerdeExpand() ? $r('app.float.appbar_zero_height') :
      this.isFullMode ? Constants.ToolBarHeight + px2vp(this.navigationBarHeight) :
        Constants.ToolBarHeight + px2vp(this.navigationBarBottomHeight)
  }

  private notVerdeExpand(): boolean {
    return this.viewModel.isFoldExpandedEnhancer && this.isFullModeEnhancer && !DeviceInfo.isPhoneVde();
  }

  /**
   * 下拉使用，用于控制顶部栏、底部栏、预览条等控件动效过程的透明度
   */
  /* instrument ignore next  */
  private calcBarComponentOpacity(): number | undefined {
    if (DeviceInfo.isTv()) {
      return undefined;
    }
    //进入连拍照片，透明度为0
    if (this.swiperOpacityWithBurstPhotos === 0) {
      return 0;
    }
    //在下拉100vp后，顶部bar、底部bar、预览条、一拍多得按钮透明度为0
    if (this.barGeometryOpacity === 0) {
      return 0;
    }
    return this.geometryOpacity;
  }

  @Builder
  PreviewProgressBuilder() {
    Row() {
    }
    .width(this.getPreviewProgressWidth())
    .height(this.getPreviewProgressHeight())
    .borderRadius(this.getPreviewProgressBorderRadius())
    .backgroundColor(Color.White)
    .justifyContent(FlexAlign.Center)
    .borderColor(this.getPreviewProgressBorderColor())
    .borderWidth(this.getPreviewProgressBorderWidth())
    .opacity(this.geometryOpacity)
    .visibility((this.isFrameExpand && !this.viewModel.isFrameShrinkAni) && !this.viewModel.photoChanged &&
      !this.isScrolling ? Visibility.Visible : Visibility.Hidden)
    .transition(TransitionEffect.OPACITY.animation({ duration: AvPlayConstants.ONE_HUNDRED, curve: Curve.Sharp }))
    .margin(DeviceInfo.isTv() ? { top: 12 } : undefined)
  }

  build() {
    Column() {
      if (this.curItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        Column() {
          Column() {
            Row() {
              Text(
                `${this.viewModel.convertTimeToSecond(this.timeCapsuleRawTime)} | ${
                this.viewModel.convertTimeToSecond(this.curItem.duration, true)}`)
                .fontSize(AvPlayConstants.TIME_CAPSULE_FONT_SIZE)
                .fontWeight(FontWeight.Regular)
                .fontColor(this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ?
                Color.Black : Color.White)
                .lineHeight(Constants.TIME_CAPSULE_LINE_HEIGHT)
                .fontFamily('HarmonyHeiTi')
                .textAlign(TextAlign.Center)
                .maxFontScale(TIME_CAPSULE_MAX_FONT_SIZE)
            }
            .constraintSize({
              minWidth: Constants.TIME_CAPSULE_WIDTH,
              minHeight: Constants.TIME_CAPSULE_HEIGHT,
            })
            .padding({
              left: Constants.TIME_CAPSULE_LINE_HEIGHT,
              right: Constants.TIME_CAPSULE_LINE_HEIGHT,
            })
            .borderRadius(Constants.TIME_CAPSULE_RADIUS)
            .backgroundColor(Color.Transparent)
            .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK)
            .justifyContent(FlexAlign.Center)
            .key('TimeCapsule')
            .shadow(ShadowStyle.OUTER_DEFAULT_XS)
          }
          .margin({ bottom: AvPlayConstants.TIME_CAPSULE_MARGIN_BOTTOM })
          .visibility(this.viewModel.isSlideBarVisibility() && this.stateReported &&
            (this.stateReported === AvplayerStatus.PAUSED ||
              this.stateReported === AvplayerStatus.PLAYING) ?
            Visibility.Visible : Visibility.Hidden)
          // 时间胶囊的入场和出场动画
          .transition(
            TransitionEffect.OPACITY.animation({
              duration: AvPlayConstants.TIME_CAPSULE_OPACITY_DURATION,
              curve: Curve.Sharp,
            }).combine(
              TransitionEffect.scale({
                x: AvPlayConstants.TIME_CAPSULE_SCALE_MIN,
                y: AvPlayConstants.TIME_CAPSULE_SCALE_MIN,
                centerX: AvPlayConstants.TIME_CAPSULE_SCALE_CENTER_X,
                centerY: AvPlayConstants.TIME_CAPSULE_SCALE_CENTER_Y,
              })
                .animation({ duration: AvPlayConstants.TIME_CAPSULE_SCALE_DURATION, curve: Curve.Friction }))
              .combine(
                TransitionEffect.translate({ x: 0, y: AvPlayConstants.TIME_CAPSULE_MARGIN_BOTTOM })
                  .animation({ duration: AvPlayConstants.TIME_CAPSULE_SCALE_DURATION, curve: Curve.Friction }))
          )
        }
        .position({ x: Constants.PERCENT_50, y: Constants.PERCENT_0 })
        .markAnchor({
          x: Constants.PERCENT_50,
          y: Constants.PERCENT_100,
        })
        .transition(TransitionEffect.IDENTITY)
      }

      Divider()
        .strokeWidth(this.sliderBarDividerWidth)
        .scale({ y: this.widthScale })
        .color($r('sys.color.comp_divider'))
        .opacity(this.isRunningAnimation ? this.dividerOpacity : this.geometryOpacity)
        .visibility(this.viewModel.isSlideBarVisibility() ? Visibility.Visible : Visibility.Hidden)
        .renderFit(RenderFit.CENTER)

      Stack({ alignContent: Alignment.Top }) {
        List({
          scroller: this.smallScroller,
          space: Swipes.calcPxRoundToInteger(Constants.LIST_ITEM_SPACE),
          initialIndex: this.viewModel.getCurrentIndex(),
        }) {
          LazyForEach(this.thumbSource as ThumbDataSource, (item: MediaResult, index?: number) => {
            if (item) {
              if (item.item?.isThumbnailState() && !DeviceInfo.isTv()) {
                PreviewThumbnail({
                  stateMachine: this.stateMachine,
                  mediaResult: item,
                  centerPreviewOpacity: this.centerPreviewOpacity,
                  previewItemOpacity: this.previewItemOpacity
                })
              } else {
                PreviewItem({
                  stateMachine: this.stateMachine,
                  item: item,
                  onSmallImgClickAction: this.onSmallImgClickFunc,
                  centerIndex: $centerIndex,
                  videoCoverFrame: this.videoCoverFrame,
                  onVideoFrameClickAction: this.onVideoFrameClickFunc,
                  isFrameExpand: $isFrameExpand,
                  anchorDirection: this.anchorDirection,
                  isPreviewBarAnimation: this.isPreviewBarAnimation,
                  isScrolling: this.isScrolling,
                  isFrameOpenAni: this.isFrameOpenAni,
                  previewProgressOffset: this.previewProgressOffset,
                  isTouchVideoPreview: this.isTouchVideoPreview,
                  centerPreviewOpacity: this.centerPreviewOpacity,
                  previewItemOpacity: this.previewItemOpacity,
                  opacityValue: this.opacityValue,
                  targetOffset: this.targetOffset,
                  curBigOffset: this.curBigOffset,
                  shrinkFactor: this.shrinkFactor,
                  forceRefresh: this.forceRefresh,
                  currentScrollState: this.currentScrollState,
                  handleKeyEvent: (event: KeyEvent): void => {
                    this.handleKeyEvent(event);
                  },
                })
              }
            }
          }, (item: MediaResult, index?: number): string => {
            this.viewModel.totalCount = this.thumbSource?.totalCount() ?? Number.NaN;
            if (!item?.item) {
              return JSON.stringify(item) + index;
            }
            return `${item.item.path}_${item.item.orientation}`;
          })
        }
        .gesture(
          PanGesture({ direction: PanDirection.Horizontal })
            .onActionStart((event: GestureEvent) => {
              if (!this.isExistGestureEvent(event) || !this.isAllowPan()) {
                return;
              }
              this.listOffsetByMouse = event.offsetX;
              this.isMouseSlideList = true;
              this.viewModel.isFingerSlide = true;
              this.videoPlayController?.updateFingerSlide(true);
            })
            .onActionUpdate((event: GestureEvent) => {
              if (!this.isExistGestureEvent(event) || !this.isAllowPan()) {
                return;
              }
              Log.info(TAG, `PreviewList Pan Update ${event.velocityX}`);
              this.smallScroller?.scrollBy(this.listOffsetByMouse - event.offsetX, 0);
              this.listOffsetByMouse = event.offsetX;
            })
            .onActionEnd((event: GestureEvent) => {
              if (!this.isExistGestureEvent(event) || !this.isAllowPan()) {
                return;
              }
              Log.info(TAG, 'PreviewList Pan ActionEnd');
              this.isMouseSlideList = false;
              this.smallScroller?.fling(event.velocityX);
            })
        )
        .accessibilityScrollTriggerable(false)
        .onTouch((event: TouchEvent): void => {
          if (event.type === TouchType.Down) {
            Log.info(TAG, `ontouch Down ${this.isVideoPlaying} isFrameExpand: ${this.isFrameExpand}`);
            if (this.isFrameExpand) {
              this.viewModel.showTimeCapsule();
              this.slideVideoFrameBarStart();
              return;
            }
          }
          if (event.type === TouchType.Up) {
            let offsetTime = this.curItem.duration - this.viewModel.progressRawTime;
            Log.info(TAG, `ontouch Up ${this.curItem.getPosition?.()} offsetTime: ${offsetTime}\
             isFrameExpand: ${this.isFrameExpand},CLOUD: ${photoAccessHelper.PositionType.CLOUD}`);
            if (this.isFrameExpand && this.curItem.getPosition?.() !== photoAccessHelper.PositionType.CLOUD &&
              offsetTime < Constants.SEEK_ALLOWABLE_OFFSET_TIME &&
            this.videoPlayController?.isSeekContinueSupported()) {
              this.isTouchUpPlaying = true;
              this.videoPlayController?.getAvPlayer()?.play();
              this.isVideoPlaying = false;
            }
            if (this.isFrameExpand && this.isCloudOrSeekUnSupported() &&
              offsetTime < Constants.SEEK_ALLOWABLE_OFFSET_TIME) {
              this.isTouchUpPlaying = true;
              this.cloudVideoFrameScrollEnd();
            }
          }
        })
        .edgeEffect(this.listEdgeEffect)
        .clip(false)
        .contentStartOffset(this.viewModel.windowLayoutWidth / Constants.DEVICE_WIDTH_HALF - Constants.LIST_ITEM_SPACE)
        .contentEndOffset(this.viewModel.windowLayoutWidth / Constants.DEVICE_WIDTH_HALF - Constants.LIST_ITEM_SPACE)
        .cachedCount(LIST_CACHE_COUNT)
        .alignListItem(ListItemAlign.Start)
        .listDirection(Axis.Horizontal)
        .scrollSnapAlign(this.scrollSnap)
        .flingSpeedLimit(SCROLL_MAX_FLING_SPEED)
        .onScrollIndex((start: number, end: number, center: number): void => {
          if (this.viewModel.isOnSwiperAnimation() || this.viewModel.isTouching() ||
            !this.isShowBar || this.viewModel.isFrameShrinkAni || this.isPrivateHideState) {
            Log.info(TAG, `onscrollIndex return, isOnSwiperAnimation:${this.viewModel.isOnSwiperAnimation()},
            isTouching:${this.viewModel.isTouching()} isFrameShrinkAni:${this.viewModel.isFrameShrinkAni}
            private:${this.isPrivateHideState}`);
            return;
          }
          if (this.centerIndex === center || this.disableScrollCallBack()) {
            Log.info(TAG, `onscrollIndex return, center:${center}`);
            return;
          }
          Log.info(TAG, 'onScrollIndex' + Log.stringify<Object>({ start, end, center }));
          if (start > center || end < center) {
            return;
          }
          // 拦截索引更新
          if (!this.isPositiveSliding) {
            return;
          }
          if (center !== this.centerIndex) {
            this.browserController.onDataPrepare(center);
          }
          this.centerIndex = center;
          if (this.isScrolling) {
            this.isLcdComplete = false;
            this.broadCast?.emit(ImageFlushItem.KEY_UPDATE_FLUSH_ITEM, [this.thumbSource?.getData(center)]);
            TraceControllerUtils.finishTrace('photoSwiper onScrollIndex');
            return;
          }
          this.tempIndex = this.viewModel.getCurrentIndex();
          this.browserController.setCurrentIndex(this.centerIndex);
          TraceControllerUtils.startTrace('photoSwiper updateCurrent');
          this.browserController.dataSource?.updateCurrent(center);
          TraceControllerUtils.finishTrace('photoSwiper updateCurrent');
        })
        .onScrollStart((): void => {
          try {
            /* instrument ignore next */
            if (DeviceInfo.isPc() && !this.isFrameExpand) {
              this.getUIContext().getFocusController().requestFocus('PhotoBrowserPreviewBar');
            }
          } catch (err) {
            Log.error(TAG, `requestFocus fail, errCode: ${err.code}, msg: ${err.message}`);
          }
          if (this.disableScrollCallBack()) {
            return;
          }
          TraceControllerUtils.startTrace(`PreviewItemScroll`);
          this.isLcdComplete = false;
          this.isScrolling = true;
          this.appBroadCast.emit(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, [this.viewModel.getCurrentIndex()]);
          this.appBroadCast.emit(BroadCastConstants.ON_LEAVE_CURRENT_WINDOW, [this.viewModel.getCurrentIndex()]);
          this.isPositiveSliding = true;
          this.viewModel.setPropertiesState(false);
          Log.info(TAG, 'list onDidScroll start');
          this.clearScrollTimer();
          if (this.viewModel.isOnSwiperAnimation()) {
            return;
          }
          animateTo({ duration: SCROLL_ANIMATION_DURATION, curve: Curve.Linear }, (): void => {
            this.smallScroller.scrollToIndex(this.centerIndex, false, ScrollAlign.CENTER);
            this.shrinkFactor = 0;
            this.viewModel.updateDataSourceMarginAndWidth();
            this.appBroadCast.emit(BroadCastConstants.UPDATE_VIDEO_WIDTH + this.curItem.uniqueId,
              [ImageUtil.getSmallImgWidth()]);
          });
        })
        .onWillScroll((scrollOffset: number, scrollState: ScrollState): void | ScrollResult => {
          Log.info(TAG, `onWillScroll, scrollOffset: ${scrollOffset}, scrollState: ${scrollState} dismiss:${this.viewModel.dismissWillScroll}`);
          // 非xxx不涉及
          if (!this.isFrameExpand || this.viewModel.dismissWillScroll) {
            return;
          }
          let offset = this.smallScrollerOffset() -
            (this.startOffset - this.selectedSmallImgWidth + Constants.PREVIEW_PROGRESS_WIDTH / 2) + scrollOffset;
          let msg: string[] = [];
          msg.push('onWillScroll');
          msg.push(`smallScrollerOffset: ${this.smallScrollerOffset()}, startOffset: ${this.startOffset}, selectedSmallImgWidth: ${this.selectedSmallImgWidth}, scrollOffset: ${scrollOffset}, offset: ${offset}`);
          let width = this.selectedSmallImgWidth * this.viewModel.frameNum - Constants.PREVIEW_PROGRESS_WIDTH;
          msg.push(`frameNum: ${this.viewModel.frameNum}, width: ${width}`);
          let outOfRange = offset <= 0 || offset >= width;
          msg.push(`outOfRange: ${outOfRange}`);
          // 达到边界后不允许继续滑动
          if (outOfRange) {
            if (offset <= 0) {
              msg.push(`offsetRemain: ${scrollOffset - offset}`);
              Log.info(TAG, msg.join(', '));
              return { offsetRemain: scrollOffset - offset }
            } else {
              msg.push(`offsetRemain: ${scrollOffset - (offset - width)}`);
              Log.info(TAG, msg.join(', '));
              return { offsetRemain: scrollOffset - (offset - width) };
            }
          } else {
            msg.push(`offsetRemain: ${scrollOffset}`);
            Log.info(TAG, msg.join(', '));
            return;
          }
        })
        .onDidScroll((scrollOffset: number, scrollState: ScrollState): void => {
          this.currentScrollState = scrollState;
          Log.info(TAG, `list onDidScroll ${scrollState} scrollOffset ${scrollOffset}`);
          this.slideVideoFrameDidScroll(scrollState);
          if (this.disableScrollCallBack()) {
            return;
          }
          if (this.viewModel.isOnSwiperAnimation()) {
            return;
          }
          Log.info(TAG, `this.isTouching ${this.viewModel.isTouching()}, this.startTouchIndex ${this.startTouchIndex}`);
        })
        .onScrollStop((): void => {
          Log.info(TAG, 'list onDidScroll stop');
          this.slideVideoFrameStop();
          if (this.disableScrollCallBack()) {
            return;
          }
          TraceControllerUtils.finishTrace(`PreviewItemScroll`);
          /* instrument ignore next */
          if (DeviceInfo.isPc()) {
            let data = this.browserController.dataSource.getMediaItemWithoutCache(this.centerIndex);
            if (data) {
              this.pcHistogramNextItem = data;
            }
          }
          this.browserController.setCurrentIndex(this.centerIndex);
          this.browserController.onIndexChange(this.viewModel.getCurrentIndex());
          if (this.curItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
            AccessibilityUtil.sendFocusAccessibilityEvent(`PreviewBarItemVideo ${this.viewModel.getCurrentIndex()}`);
          } else {
            AccessibilityUtil.sendFocusAccessibilityEvent(`PreviewBarItemImage ${this.viewModel.getCurrentIndex()}`);
          }
          this.scrollTimer = setTimeout((): void => {
            Log.info(TAG, 'scrolling finish');
            this.isScrolling = false;
            animateTo({
              duration: SCROLL_ANIMATION_DURATION,
              curve: Curve.Linear,
            }, (): void => {
              this.shrinkFactor = 1;
              this.viewModel.updateDataSourceMarginAndWidth();
            });
          }, SCROLL_ANIMATION_DURATION);
          if (this.isScrolling) {
            this.appBroadCast.emit(BroadCastConstants.SWIPER_INDEX_CHANGED, [this.centerIndex]);
            Log.info(TAG, `onScrollStop, centerIndex: ${this.centerIndex}`);
          }
          if (this.viewModel.isOnSwiperAnimation()) {
            return;
          }
          this.browserController.setCurrentIndex(this.centerIndex);
          this.startTouchIndex = this.centerIndex;
          Log.info(TAG,
            `thumbnail scroll, startIndex:${this.viewModel.getCurrentIndex()} endIndex:${this.centerIndex}`);
          let msg: CountMsg = {
            type: BigDataConstants.PHOTO_THUMBNAIL,
            count: Math.abs(this.tempIndex - this.viewModel.getCurrentIndex()),
          };
          this.targetOffset = 0;
          animateTo({ curve: Swipes.DELETE_PHOTO_CURVE }, (): void => {
            this.smallScroller.scrollToIndex(this.viewModel.getCurrentIndex(), false, ScrollAlign.CENTER);
            this.centerIndex = this.viewModel.getCurrentIndex();
            this.browserController.onDataPrepare(this.viewModel.getCurrentIndex());
          });
          ReportToBigDataUtil.report(BigDataConstants.THUMBNAIL_SCROLL_COUNT_ID, msg);
          this.videoFrameAniStop();
        })
        .onAppear((): void => {
          Log.info(TAG, 'Preview list appear');
          this.viewModel.initStartOffset();
        })
        .scrollBar(BarState.Off)
        .backgroundColor(Color.Transparent)
        .height(DeviceInfo.isTv() ? $r('app.float.tv_swiper_item_size') : this.viewModel.swiperListHeight)
        .width(Constants.FULL_PERCENT)
        .onScrollFrameBegin((offset: number, state: ScrollState) => {
          if (this.isFrameExpand && state === ScrollState.Fling && (this.seekTime === 0 || this.isVideoToEnd)) {
            Log.info(TAG, `onscrollFrameBegin scrollBy0 offset:${offset} state:${state}`);
            this.smallScroller.scrollBy(0, 0);
            return;
          }
          return Previewer.scrollFrameReducer(offset, state);
        })
        .key('PhotoBrowserPreviewBar')
        .margin({
          top: DeviceInfo.isTv() ? 0 : Constants.WAVE_LIST_MARGIN_TOP,
          bottom: this.stackListMarginBottom(),
        })
        .onKeyEvent((event: KeyEvent): void => {
          Log.info(TAG, `preview handleKeyEvent type= ${event.type}, keyCode= ${event.keyCode}`);
          this.handleKeyEvent(event);

          if (KeyType.Down === event.type) {
            if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_LEFT) {
              this.swiperController?.showPrevious();
            } else if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_RIGHT) {
              this.swiperController?.showNext();
            }
          }
        });

        // 定位条
        this.PreviewProgressBuilder();
      }
      .onAreaChange((oldValue: Area, newValue: Area) => {
        if (!DeviceInfo.isPc()) {
          return;
        }
        if (typeof newValue.height === 'number' && Number.isFinite(newValue.height)) {
          this.previewStackHeight = newValue.height;
        }
      })
      .backgroundColor(DeviceInfo.isTv() ? Color.Transparent : $r('sys.color.ohos_id_color_bottom_tab_sub_bg_blur'))
      .opacity(DeviceInfo.isTv() ? undefined : (this.viewModel.isPullDownStart ?
        this.geometryOpacity : this.opacityValue))
      .visibility(DeviceInfo.isTv() ? undefined :
        (this.viewModel.isSlideBarVisibility() ? Visibility.Visible : Visibility.Hidden))
      .width(Constants.FULL_PERCENT)
      .height(DeviceInfo.isTv() ? Constants.FULL_PERCENT : undefined)
      .transition(this.viewModel.makePreviewBarTransition())
      .padding({
        bottom: this.swiperPaddingBottom(),
      })
      .onMouse((event: MouseEvent): void => {
        const onMouseState: Previewer.MouseState = Previewer.getMouseState(event, this.smallScroller);
        if (onMouseState.isTrigScroll) {
          this.smallScroller.scrollBy(onMouseState.scrollDistance, 0);
          this.mousePositionX = event.windowX;
        }
      })
    }
    .id(TAG)
    .height(DeviceInfo.isTv() ? $r('app.float.tv_swiper_list_height') : undefined)
    .attributeModifier(this.viewModel.listColumnModifier)
    .visibility(this.viewModel.isSlideBarVisibility() ? Visibility.Visible : Visibility.Hidden)
  }
}