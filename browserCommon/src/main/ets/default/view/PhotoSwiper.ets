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
import lazy { MultimodalInputManager } from '@ohos/common/src/main/ets/default/model/common/MultimodalInputManager';
import lazy { PhotoItem } from '../view/PhotoItem';
import lazy { PreviewItem } from '../view/PreviewItem';
import lazy { ImageFlushItem } from '../view/ImageFlushItem';
import lazy { BrowserCostReportManager } from '../utils/BrowserCostReportManager';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { Constants as BrowserConstants, Constants as PhotoConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { Log, reportEmpty } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy Curves from '@ohos.curves';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { PhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataSource';
import lazy { ThumbDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/ThumbDataSource';
import lazy { BigDataConstants, CountMsg, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { UIContext } from '@ohos.arkui.UIContext';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { getScreen, isOrientationHorizontal, ScreenManager, WindowMode } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { ImageSizeUtil } from '@ohos/common/src/main/ets/default/model/browser/photo/ImageSizeUtil';
import lazy Swipes, { SwiperDirection } from '@ohos/common/src/main/ets/default/view/Swipes';
import lazy { MediaResult } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaResult';
import lazy lockedScreenMgr from '@ohos/common/src/main/ets/default/utils/LockedScreen';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy performanceMonitor from '@ohos.arkui.performanceMonitor';
import lazy Previewer from '@ohos/common/src/main/ets/default/view/swiper/Previewer';
import lazy { VideoPlayController } from '../controller/VideoPlayController';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { AvPlayConstants, AvplayerStatus, PauseReason } from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy media from '@ohos.multimedia.media';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy Global from '@ohos/common/src/main/ets/default/utils/GlobalContext';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { PCImageInfo } from './PCImageInfo';
import lazy display from '@ohos.display';
import lazy { LengthMetrics } from '@kit.ArkUI';
import lazy { i18n } from '@kit.LocalizationKit';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { PhotoAsset } from '@ohos/common/src/main/ets/default/view/dialog/MoveDialog';
import lazy { KeyCode } from '@kit.InputKit';
import lazy {
  PhotoBrowserStateMachine
} from '../viewModel/statemachine/PhotoBrowserStateMachine';
import lazy { Heic2JPGManagerAccess } from '@ohos/common/src/main/ets/default/access/Heic2JPGManagerAccess';
import lazy {
  ShortcutController, ShortcutManager,
} from '../controller/ShortcutController';

const SCROLL_ANIMATION_DURATION: number = 100;
const SCROLL_MAX_FLING_SPEED: number = 1000;
const EXPECTED_FRAME_RATE_RANGE: ExpectedFrameRateRange = {
  expected: 120,
  min: 90,
  max: 120,
};
/* instrument ignore file */
const TAG: string = 'common_PhotoSwiper';
const TABLET_PREVIEWER_DELAY_TIME: number = 80;
const MAX_ALLOWED_DELAY_TIME: number = 100;
const SEND_FOCUS_DEFAULT_DELAY: number = 100;
const TV_MAX_FRAME_NUM: number = 12;
const POPUP_TIME_TIPS_WIDTH: number = 128;
/**
 * 除以 2 计算常数
 */
const HALF_DIVIDER: number = 2;
const PRELOAD_MAX_SIZE: number = 6000;

export enum AnchorDirection {
  HEADER,
  FOOTER
}

interface HistoryOperation {
  action: number;
  photoUri: string[];
  photoAsset: PhotoAsset[];
  dataCount: number;
};

@Component
export struct PhotoSwiper {
  // pc用
  @LocalStorageLink('isDoingImmersiveAnimationPC') isDoingImmersiveAnimationPC: boolean = false;
  private isWinSizeChanged: boolean = false;
  @LocalStorageLink('virtualKbKey') virtualKbKeyPC: string = '';
  private isShowSideBarBeforePC: boolean = false;
  @State imagePadding: Padding | Length | LocalizedPadding = {};
  @LocalStorageLink('photoSwiperOpacity') photoSwiperOpacity: number = 1;
  @LocalStorageLink('isPcShowingEditor') @Watch('isPcShowingEditorChanged') isPcShowingEditor: boolean = false;
  private isFromPhotoBrowserModule: boolean = false;
  @LocalStorageLink('previewStackHeight') previewStackHeight: number = 0;
  @State imageList: PCImageInfo[] = [];
  @LocalStorageLink('pcImageCompleteWidth') pcImageCompleteWidth: number | undefined = 0;
  @LocalStorageLink('pcImageCompleteHeight') pcImageCompleteHeight: number | undefined = 0;
  /**
   * Swiper 组件所展示的当前图片信息
   *
   */
  @Link pcCurItem: MediaItem | undefined;
  /**
   * 直方图 仅加载即将进入窗口的下一张图片
   */
  @LocalStorageLink('pcHistogramNextItem') pcHistogramNextItem: MediaItem = new MediaItem();
  @Prop isPcPictureScene: boolean;
  private albumInfo?: AlbumInfo;
  private isUserCreatedAlbum: boolean = false;
  // 进入和退出连拍时，大图图片的透明度
  @Prop swiperOpacityWithBurstPhotos: number = 1;
  // 进入和退出连拍时，两侧缩略图的透明度
  @Prop previewItemOpacity: number = 1;
  // 进入和退出连拍时，当前缩略图的透明度
  @Prop centerPreviewOpacity: number = 1;
  /**
   * 转场动效使用标记ID
   */
  mTransition: string = '';
  /**
   * 当前图片 index 信息
   */
  @Consume @Watch('jumpStart') currentIndex: number;
  /**
   * 广播，用于保存关键回调
   */
  @Link broadCast: BroadCast;
  /**
   * 多选态选择
   */
  private isSelected: Function = (): boolean => {
    return false;
  };
  private selectStateChange: Function = (): void => {
  };
  /**
   * Swiper 切图动画时长
   */
  @State mDuration: number = 300;
  @Consume isShowVideo: boolean;
  onPhotoChanged: Function = (): void => {
  };
  onDataPrepare: Function = (): void => {
  };
  onIndexChanged: Function = (): void => {
  };
  updatePixMapDataSource: Function = (): void => {
  };
  private handleUndoFunc: Function = (): void => this.undo();
  private handleRedoFunc: Function = (): void => this.redo();
  swiperController?: SwiperController;
  /**
   * 标记是否为选择模式
   */
  isInSelectedMode: boolean = false;
  /**
   * 标记是否禁止 Swiper 滑动切图
   */
  @Consume disableSwipe: boolean;
  /**
   * swiper组件的间距，常量
   */
  swiperItemSpace: number = 12;
  /**
   * 确认图片缩放信息回调
   */
  verifyPhotoScaledFunc?: (matrix?: Matrix4.Matrix4Transit) => void;
  /**
   * 标志当前是否支持上滑，唤出图片详情信息
   */
  canPullingUp: boolean = false;
  /**
   * 标志当前是否正在执行一镜到底动效
   */
  @Link isRunningAnimation: boolean;
  /**
   * 标志当前是否正在支持下拉图片，执行下拉跟手动效
   */
  @Link isPullDownAndDragPhoto: boolean;
  isLeftSwiper: boolean = false;
  /**
   * 标志是否正在执行删除动画动效
   */
  @Consume isDeleting: boolean;
  //数据条数是否有变化
  @Consume pageFrom: number;
  /**
   * 大图数据源
   */
  private dataSource?: PhotoDataSource;
  /**
   * 缩略图预览条数据源
   */
  private thumbSource?: ThumbDataSource;
  @Link @Watch('onShowChanged') isShowBar: boolean;
  @ObjectLink browserController: BrowserController;
  /**
   * 标志当前是否支持一镜到底动效
   */
  private geometryTransitionEnable: boolean = false;
  /**
   * 标志当前页面是否是由 FA 卡片拉起
   */
  private isFromFACard: boolean = false;
  /**
   * 标志thumbSource是否为空, 三方入口进图库 预览条数据加载完成标志位
   */
  @State private isThumbsourceLoadFinished: boolean = true;
  /**
   * swiper缓存的item的个数
   */
  private readonly SWIPE_CACHE_COUNT: number = 1;
  /**
   * list缓存的item的个数
   */
  private readonly LIST_CACHE_COUNT: number = 7;
  @Consume isFirstInSwiperFromCard: boolean;
  @Consume fromCardCurrentIndex: number;
  /**
   * 标志当前是否支持上滑唤出图片详情
   */
  @Consume isPullingUp: boolean;
  /**
   * 缓存节点的上滑态 当前图片频繁上滑/下拉时，缓存节点不跟随当前图片变化
   */
  @LocalStorageLink('isPullingUpSwiper') isPullingUpSwiper: boolean = false;
  /**
   * 直方图 仅加载即将进入窗口的下一张图片
   */
  @Provide histogramNextItem: MediaItem = new MediaItem();
  /**
   * 标志当前是否正在执行删除动效
   */
  @StorageLink('isDoingDeleteBigPhotoAnim') isDoingDeleteAnim: boolean = false;
  /**
   * 标志当前删除动效的方向
   */
  @StorageLink('isBigPhotoLeftToRightAnim') isLeftToRightAnim: boolean = false;
  @StorageLink('isFullMode') @Watch('getSwiperHeight') private isFullMode: boolean = getScreen().isFullMode();
  @State private swiperListHeight: Length = 0;
  /**
   * 横竖屏状态 横屏为true
   */
  @StorageLink('isHorizontal') @Watch('onRotateScreen') isHorizontal:
    boolean = isOrientationHorizontal();
  @StorageLink('navigationBarHeight') private navigationBarHeight: number = 0;
  @StorageLink('navigationBarBottomHeight') private navigationBarBottomHeight: number = 0;
  @State itemList: MediaResult[] = [];
  @State isScrolling: boolean = false;
  @State isImageAnalyzePaused: boolean = false;
  /**
   * 当前图片 uri 信息
   */
  @State currentUri: string = '';
  // For AI text
  /**
   * AI 组件相关变量，控制 AI 组件是否可见
   */
  @State analyzerVisibility: Visibility = Visibility.Visible;
  /**
   * AI 组件相关变量，控制 AI Button 是否可见
   */
  @State aiButtonVisibility: boolean = true;
  /**
   * AI 组件相关变量，控制 AI 组件是否上组件树
   */
  @State canShowImageAnalyzer: boolean = false;
  /**
   * 标志 Swiper 组件是否正在执行切图动画
   */
  @State isDoingImageSlideAnimation: boolean = false;
  /**
   * AI 组件相关变量，控制此时是否支持响应平移手势
   */
  @State canRespondPanGesture: boolean = true;
  /**
   * Swiper 组件所展示的当前图片信息
   */
  @State curItem: MediaItem = new MediaItem();
  /**
   * AI 组件相关变量，标志当前是否点击了 AI 组件气泡
   */
  @State isTappingAiButton: boolean = false;
  /**
   * AI 组件相关变量，标志当前 isTappingAiButton 状态是否改变
   */
  @State isTappingAiButtonChange: boolean = false;
  /**
   * AI 组件相关变量，标志当前是否显示了 AI Menu
   */
  @State isMenuShow: boolean = false;
  /**
   * AI 组件相关变量，标志当前 isMenuShow 状态是否改变
   */
  @State isMenuShowStatusChange: boolean = false;
  /**
   * AI 组件相关变量，标志当前是否在 AI 组件中选择文本
   */
  @State hasSelectedText: boolean = false;
  /**
   * AI 组件相关变量，标志当前是否在 AI 组件中选择的文本是否有变化
   */
  @State isSelectedTextChange: boolean = false;
  /**
   * AI 组件相关变量，标志当前拖动，多选文本
   */
  @State isOnDragText: boolean = false;
  /**
   * AI 组件相关变量，点击响应模式
   */
  @State hitMode: HitTestMode = HitTestMode.Transparent;
  @State isInAnimateToPosition: boolean = false;
  /**
   * 应用级广播，保存关键监听回调
   */
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private onDeleteUIFirstFunc: Function = (): void => this.onDeleteUIFirst();
  private onDataReloadFunc: Function = (): void => this.onDataReload();
  private onChangeSwiperDurationFunc: Function = (value: number): void => this.onChangeSwiperDuration(value);
  @Consume isEnableMouse: boolean;
  // use for big data report
  private tempIndex: number = Number.NaN;
  @State isLeftMouseButtonPress: boolean = false;
  @State mousePositionX: number = Number.NaN;
  @Prop isPhotoScaled: boolean = false;
  // use for first photo edit and save as
  @Prop @Watch('updateDataSourceMarginAndWidth') forceRefresh: number = 1;
  @Prop @Watch('onIsEditorShownChange') isEditorShown: boolean = false;
  private showEditor: Function = (): void => {
  };
  /**
   * 波浪预览条相关变量
   */
  @State @Watch('updateDataSourceMarginAndWidth') shrinkFactor: number = 1.0;
  @State @Watch('updateDataSourceMarginAndWidth') targetOffset: number = 0;
  @State @Watch('updateDataSourceMarginAndWidth') curBigOffset: number = 0;
  @State currentScrollState: number = 0;
  /**
   * 大图左右跟手滑动景深效果相关变量
   */
  @State currentImageWidth: number = 0;
  @State windowLayoutWidth: number = 0;
  @State windowLayoutHeight: number = 0;
  @State nextItem?: MediaItem = new MediaItem();
  @State totalCount: number = 0;
  @State preCount: number = 0;
  private nextDisplayedWidth: number = 0;
  /**
   * swiper左右滑动方向
   */
  @State @Watch('onChangeSwiperDirection') swiperDirection: number = SwiperDirection.DEFAULT;
  /**
   *下拉或侧滑分割线透明度
   */
  private dividerOpacity: number = 0;
  @State isTriggeredByPause: boolean = false;
  /**
   * 大图删除动效相关变量，标志位
   */
  @Consume isDoDeleteAnim: boolean;
  private isFromPortraitCoverSet: boolean = false;
  private isFromPortrait: boolean = false;
  // 三方入口进图库大图 标志位
  private isFromViewData: boolean = false;
  private lastResult: TempResult = new TempResult();
  private onSmallImgClickFunc: Function = (uri: string): void => this.smallImgClickAction(uri);
  @State private photoChanged: boolean = false;
  /**
   * 大图删除动效相关变量，正在被删除的图片ID
   */
  @State currentDeleteID: string = '';
  private currentDeleteIDFunc: Function = (uniqueId: string): void => this.currentDeleteIDChange(uniqueId);
  /**
   * 大图浏览耗时打点
   */
  private costReportManager: BrowserCostReportManager = BrowserCostReportManager.getInstance();
  /**
   * 显示结束swiper左右切换动效
   */
  private finishSwiperAnimationFunc: Function = (): void => this.finishSwiperAnimation();
  private scrollTimer: number = Number.NaN;
  @Link isSlideBarShow: boolean;
  /**
   * 大图跟手相对位移
   */
  private diffOffset: number = 0;
  /**
   * 无障碍
   */
  @StorageLink('isOpenTouchGuide') private isOpenTouchGuide: boolean = false;
  /**
   * 缩略图预览条中心图索引
   */
  @State @Watch('updateDataSourceMarginAndWidth') private centerIndex: number = this.currentIndex;

  private isItemChange: boolean = false;
  /**
   * 逐帧播放：鼠标点击情况下，拖动list组件的偏移量（list组件不支持鼠标点击情况下的拖拽）
   */
  @State listOffsetByMouse: number = 0;
  /**
   * 逐帧播放：鼠标点击情况下，标记是否正在拖动list组件；等同于手指搓动情况下的isFingerSlide
   */
  @State private isMouseSlideList: boolean = false;
  /**
   * 逐帧播放：展开前展示两帧视频封面；点击扩展的逐帧抽取，未获取时先用首帧占位
   */
  @State private videoCoverFrame: PixelMap[] = [];
  /**
   * 逐帧播放：点击展开方法
   */
  private onVideoFrameClickFunc: Function = (uri: string): void => this.videoFrameClickAction(uri);

  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();

  /**
   * 逐帧播放：是否为xxx标志变量
   */
  @State @Watch('isFrameExpandChanged') private isFrameExpand: boolean = false;
  private targetStatusOnCloudFrame: string | undefined = undefined;
  /**
   * 逐帧播放：进度条上报时间
   */
  @State @Watch('onChangeProgressRawTime') private progressRawTime: number = 0;
  private isExpandFinish: boolean = false;
  private waitingForTimeSync: boolean = false;
  private expectedProgressRawTime: number = 0;
  private progressRawTimeDuration: number = 0;
  @StorageLink('zOperationList') zOperationList: HistoryOperation[] = [];
  @StorageLink('yOperationList') yOperationList: HistoryOperation[] = [];
  private updateProgressRawTimeFunc: Function = (rawTime: number):
    void => this.updateProgressRawTime(rawTime);
  private backPressEventFunc: Function = (): void => {
    if (!this.isEditorShown) {
      this.isShowFlushImage = false;
    }
    this.isLcdComplete = true;
    this.isScrolling = false;
    this.currentIndex = this.centerIndex;
    Log.info(TAG, `backPressEventFunc update currentIndex ${this.currentIndex}`);
    this.smallScroller.scrollToIndex(this.centerIndex, false, ScrollAlign.CENTER);
    this.dataSource?.updateCurrent(this.centerIndex);
  }
  private videoScrollToStartFunc: Function = (): void => {
    this.videoScrollToStart();
  }
  private dataLoadFinishPreviewerFunc: Function = (): void => {
    this.dataLoadFinishPreviewer();
  }
  private changeMoreMenuList: Function = () => {
  };
  /**
   * 逐帧播放：时间胶囊展示时间；是否展示时间胶囊
   */
  @State private timeCapsuleRawTime: number = 0;
  @State private isShowTimeCapsule: boolean = false;
  private timeCapsuleTimeoutID: number = 0;
  /**
   * 逐帧播放：video控制器
   */
  private videoPlayController?: VideoPlayController;
  private initVideoPlayFunc: Function = (videoPlayController: VideoPlayController):
    void => this.initVideoPlay(videoPlayController);

  private initVideoPlay(videoPlayController: VideoPlayController): void {
    this.videoPlayController = videoPlayController;
  }

  /**
   * 逐帧播放：xxx所抽取帧的个数
   */
  private frameNum: number = 0;
  private isTouchUpPlaying: boolean = false;
  @Prop @Watch('onVideoPlayChange') private isVideoPlaying: boolean;
  /**
   * 逐帧播放：list滑动前，视频是否为播放状态
   */
  @State private isVideoPlayBeforeSlide: boolean = false;
  @State private isVideoToEnd: boolean = false;
  /**
   * 逐帧播放：翻页动效时的锚点
   */
  @State private anchorDirection: AnchorDirection = AnchorDirection.HEADER;
  /**
   * 逐帧播放：seek发送的时间点
   */
  private seekTime: number = 0;
  @State private isPreviewBarAnimation: boolean = false;
  @Prop isDetailSelected: boolean;
  /**
   * 逐帧播放：滑动预览条时是否超出边界
   */
  private selectedSmallImgWidth: number = ImageUtil.getSelectedSmallImgWidth();
  @State private startOffset: number = 0;
  @State private scrollSnap: ScrollSnapAlign = ScrollSnapAlign.CENTER;
  @State private listEdgeEffect: EdgeEffect = EdgeEffect.Spring;
  @State private isFingerSlide: boolean = false;
  /**
   * 逐帧播放：是否在滑动xxx视频帧的边界开始滑动
   */
  @State private isFrameShrinkAni: boolean = false;
  @State private isFrameOpenAni: boolean = false;
  @State private isFrameShrinkIndex: number = 0;
  @State private previewProgressOffset: number = 0;
  /**
   * 逐帧播放：是否在触摸展开前的视频预览区域
   */
  @State private isTouchVideoPreview: boolean = false;
  /**
   * 逐帧播放：点击预览条list的滚动动效
   */
  private clickToScrollAni: boolean = false;
  @LocalStorageLink('sideBarWidth') sideBarWidth: number = 0;
  @LocalStorageLink('isShowSideBar') isShowSideBar: boolean = true;
  /**
   * 逐帧播放：框架侧上报的视频播放状态
   */
  @State stateReported: media.AVPlayerState | undefined = undefined;
  private swiperTimer: number | undefined = undefined;
  // 记录当前系统深浅色模式
  @StorageProp('currentColorMode') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  private timeoutId: number = 0;
  @State @Watch('showPreviewer') private tabletShowPreviewer: boolean = false;
  @State isShowFlushImage: boolean = true;
  @State isLcdComplete: boolean = false;
  @State changeByKeyBoard: boolean = false;
  @State stackCount: number = 0;
  // 预览条缓存更新：记录删除图片的path
  private deleteItemPath: string = '';
  @State isShowTimeCapsulePopup: boolean = true;
  @Prop isPrivateHideState: boolean = false;
  private shortcutController: ShortcutController = ShortcutManager.getInstance();
  @ObjectLink stateMachine: PhotoBrowserStateMachine;

  private onIsEditorShownChange(): void {
    if (!this.isEditorShown) {
      focusControl.requestFocus('PhotoBrowserPreviewBar');
    }
  }

  private clickPlayVideoFrameExpandFunc: Function =
    (uri?: string, clickedPlay?: boolean): void => this.videoFrameClickAction(uri, clickedPlay);
  private resetVideoFrameBeforeEditFunc: () => void = (): void => {
    this.resetVideoFrameBeforeEdit();
  }
  private videoStatusReportedFunc: Function = (state: media.AVPlayerState): void => {
    this.videoStatusReported(state);
  }

  private resetVideoFrameBeforeEdit(): void {
    this.resetVideoFrame();
    this.smallScroller?.scrollToIndex(this.currentIndex, false, ScrollAlign.CENTER);
    this.appBroadCast.emit(BroadCastConstants.UPDATE_VIDEO_WIDTH + this.curItem.uniqueId,
      [AvPlayConstants.COVER_FRAME_NUM * this.selectedSmallImgWidth]);
  }

  private resetVideoFrameFunc: () => void = (): void => {
    this.resetVideoFrame();
  }

  private resetVideoFrame(): void {
    this.isFrameExpand = false;
    this.scrollSnap = ScrollSnapAlign.CENTER;
  }

  private isFrameExpandChanged(): void {
    if (!this.isFrameExpand && !this.targetStatusOnCloudFrame) {
      this.targetStatusOnCloudFrame = undefined;
    }
  }

  private updateProgressRawTime(rawTime: number): void {
    Log.debug(TAG, `${BrowserConstants.TAG_VIDEO_PLAY_BY_FRAME}, progressRawTime: ${this.progressRawTime}, ` +
      `rawTime is ${rawTime}, expectedProgressRawTime: ${this.expectedProgressRawTime}`);
    if ((this.expectedProgressRawTime - rawTime < MAX_ALLOWED_DELAY_TIME ||
      (rawTime === 0 && this.expectedProgressRawTime !== 0)) && this.waitingForTimeSync) {
      Log.debug(TAG, `${BrowserConstants.TAG_VIDEO_PLAY_BY_FRAME} , set waitingForTimeSync as false`);
      this.waitingForTimeSync = false;
    }
    if (this.isFingerSlide || this.waitingForTimeSync) {
      return;
    }
    if (this.isShowBar && this.curItem.duration) {
      this.previewProgressOffset = (this.selectedSmallImgWidth * 2 - Constants.PREVIEW_PROGRESS_WIDTH) *
        rawTime / this.curItem.duration;
    }
    this.progressRawTimeDuration = rawTime - this.progressRawTime;
    this.progressRawTime = rawTime;
    Log.info(TAG, `${BrowserConstants.TAG_VIDEO_PLAY_BY_FRAME}, progressRawTimeDuration: ` +
      `${this.progressRawTimeDuration}, duration: ${this.curItem.duration}, video: ${this.curItem.uri}`);
  }

  private initStartOffset(): void {
    this.startOffset = this.getCurrentOffset();
    try {
      Log.info(TAG, `initStartOffset start startOffset :${this.startOffset} isFrameExpand :${this.isFrameExpand}
        smallScrollerOffset: ${this.smallScrollerOffset()} smallScrollerRectX: ${
      this.smallScroller?.getItemRect(this.currentIndex)?.x}, currentUri:${this.currentUri}`);
    } catch (e) {
      Log.error(TAG, `print startOffset log info err ${e}`);
    }
  }

  private getCurrentOffset(): number {
    let offset: number = 0;
    try {
      if (i18n.isRTL(i18n.System.getSystemLanguage())) {
        offset = this.smallScrollerOffset() + this.windowLayoutWidth -
          (this.smallScroller?.getItemRect(this.currentIndex)?.x || 0) - this.selectedSmallImgWidth * this.frameNum +
        this.selectedSmallImgWidth - this.windowLayoutWidth / 2;
      } else {
        offset = this.smallScrollerOffset() + (this.smallScroller?.getItemRect(this.currentIndex)?.x || 0) +
        this.selectedSmallImgWidth - this.windowLayoutWidth / 2;
      }
    } catch (e) {
      Log.info(TAG, ` getCurrentOffset err ${e}`);
    }
    return offset;
  }

  private onVideoPlayChange(): void {
    if (!this.isFrameExpand) {
      return;
    }
    if (!this.isVideoPlaying) {
      Log.info(TAG, `onVideoPlayChange progressRawTime: ${this.progressRawTime} isFingerSlide: ${this.isFingerSlide}`)
      if (this.progressRawTime == 0) {
        this.isFingerSlide = false;
        this.videoPlayController?.updateFingerSlide(false);
      }
      if (this.progressRawTime == this.curItem.duration) {
        Log.info(TAG, `onVideoPlayChange startOffset: ${this.startOffset}`)
      }
      return;
    }
  }

  onDidBuild(): void {
    Log.info(TAG,
      `photo Swiper OndidBuild-thumbdatasource size: ${this.thumbSource?.realTotalCount()}, currentIndex: ${this.currentIndex},
      isThumbsourceLoadFinished: ${this.isThumbsourceLoadFinished}`);
  }

  /**
   * 逐帧播放：展开后根据进度上报回调控制list的移动
   */
  onChangeProgressRawTime(): void {
    this.timeCapsuleRawTime = this.progressRawTime;
    if (this.isFrameExpand && this.isShowBar) {
      if (!this.isVideoPlaying && !this.isFingerSlide && this.isExpandFinish) {
        this.videoProgressScrollTo();
      }
      if (this.curItem.duration - this.progressRawTime < Constants.SEEK_ALLOWABLE_OFFSET_TIME) {
        this.isVideoToEnd = true;
      } else {
        this.isVideoToEnd = false;
      }
    }
  }

  private videoStatusReported(state: media.AVPlayerState): void {
    this.stateReported = state;
  }

  // 第三方入口进 图库 , 数据加载完成收到广播预览条展示
  private dataLoadFinishPreviewer(): void {
    Log.info(TAG, 'From ViewData dataLoadFinished isThumbsourceLoadFinish:' + this.isThumbsourceLoadFinished +
      ' thumbsource size:' + this.thumbSource?.totalCount() + ', set isThumbsourceLoadFinished true ');
    this.isThumbsourceLoadFinished = true;
    this.curItem = this.dataSource?.getData(this.currentIndex)?.item ?? new MediaItem();
    const previousUri: string = this.currentUri;
    this.currentUri = this.curItem.uri;
    if (this.isFromFACard && previousUri !== this.currentUri) {
      // 再次打开大图浏览页面,预览条偏移量计算出错导致不显示预览条,由于index超出activeEndIndex,导致JumpStart中滚动失败.
      // 在数据完成加载后,再次滚动预览条到指定index,防止偏移量计算出错.
      this.smallScroller.scrollToIndex(this.currentIndex, false, ScrollAlign.CENTER);
    }
  }

  private videoScrollToStart(): void {
    let startOffset: number = this.startOffset - this.selectedSmallImgWidth + Constants.PREVIEW_PROGRESS_WIDTH / 2;
    this.smallScroller?.scrollTo({ xOffset: startOffset, yOffset: 0 })
    this.isVideoToEnd = false;
    Log.info(TAG, `videoScrollToStart xOffset: ${startOffset} progressRawTime: ${this.progressRawTime}`)
  }

  // 视频播放进度条移动
  private videoProgressScrollTo(): void {
    this.videoProgressScrollToByDuration(this.progressRawTimeDuration);
  }

  private videoProgressScrollToByDuration(duration: number): void {
    let xOffset: number = this.startOffset - this.selectedSmallImgWidth + Constants.PREVIEW_PROGRESS_WIDTH / 2 +
      (this.progressRawTime / this.curItem.duration) *
        (this.selectedSmallImgWidth * this.frameNum - Constants.PREVIEW_PROGRESS_WIDTH);
    this.smallScroller?.scrollTo({
      xOffset: xOffset, yOffset: 0,
      animation: { duration: duration, curve: Curve.Linear },
    })
    Log.info(TAG, `videoProgressScrollToByDuration xOffset: ${xOffset} progressRawTime: ${this.progressRawTime}`)
  }

  private convertTimeToSecond(milliseconds: number, isDuration: boolean = false): string {
    if (milliseconds <= AvPlayConstants.A_THOUSAND && isDuration) {
      return '00:01';
    }
    let second: number = Math.floor(milliseconds / AvPlayConstants.A_THOUSAND % AvPlayConstants.VIDEO_FPS_60);
    let minute: number = Math.floor(milliseconds / AvPlayConstants.A_THOUSAND / AvPlayConstants.VIDEO_FPS_60);
    return this.fillZero(minute) + `:${this.fillZero(second)}`;
  }

  private fillZero(time: number): string {
    if (time < AvPlayConstants.TEN) {
      return `0${time}`;
    } else {
      return time.toString();
    }
  }

  private frameExpandListScroll(): void {
    animateTo({
      curve: BrowserConstants.CLICK_PLAY_FRAME_EXPAND_LIST_CURVE,
    }, () => {
      this.smallScroller?.scrollBy(-this.selectedSmallImgWidth + Constants.PREVIEW_PROGRESS_WIDTH / 2, 0);
    })
  }

  /**
   * 逐帧播放：点击展开时，调整list的位移到对应时间点
   */
  private videoFrameClickAction(uri?: string, clickedPlay?: boolean): void {
    // 若视频未播放，点击展开后开始自动播放
    if (!this.isShowVideo) {
      this.isVideoPlaying = false;
      this.frameExpandListScroll();
    }
    // 点击播放按钮同步展开
    if (clickedPlay) {
      this.frameExpandListScroll();
    }
    // 根据视频时长，决定取帧数量。拟合曲线：count = 2.8958ln(x) + 0.5016; x为视频时长，单位秒。
    this.frameNum = Math.floor(AvPlayConstants.CON1 * Math.log(
      this.curItem.duration / AvPlayConstants.A_THOUSAND) + AvPlayConstants.CON2);
    this.frameNum = this.frameNum < AvPlayConstants.MIN_FRAME_NUM ? AvPlayConstants.MIN_FRAME_NUM : this.frameNum;
    /* instrument ignore next */
    if (DeviceInfo.isTv()) {
      this.frameNum = Math.min(this.frameNum, TV_MAX_FRAME_NUM);
    }
    if (!this.frameNum) {
      this.frameNum = AvPlayConstants.MIN_FRAME_NUM;
    }
    Log.info(TAG, `[videoPlayer] click cover frame to expand and fetch all frames progressRawTime:${
    this.progressRawTime}`);
    this.isFrameExpand = true;
    this.timeCapsuleRawTime = this.progressRawTime;
    this.showTimeCapsule();
    this.scrollSnap = ScrollSnapAlign.NONE;
    this.listEdgeEffect = EdgeEffect.None;
    this.videoCoverFrame = new Array(this.frameNum).fill(this.videoCoverFrame[0]);
    this.isExpandFinish = false;
    // 点击扩展动效
    animateToImmediately({
      duration: AvPlayConstants.ANI_DURATION,
      curve: Curve.Friction,
      onFinish: () => {
        this.initStartOffset();
        this.scrollForList();
        this.isExpandFinish = true;
      }
    }, () => {
      this.appBroadCast.emit(BroadCastConstants.UPDATE_VIDEO_WIDTH + this.curItem.uniqueId,
        [this.frameNum * this.selectedSmallImgWidth]);
    })
    this.appBroadCast.emit(BroadCastConstants.GET_VIDEO_FRAME_FOR_PREVIEW + this.curItem.uniqueId, []);
  }

  /**
   * 逐帧播放：展示时间胶囊
   */
  private showTimeCapsule(): void {
    Log.info(TAG, `[videoPlayer] showTimeCapsule isVideoPlaying: ${this.isVideoPlaying} isFingerSlide: ${
    this.isFingerSlide}, timeCapsuleTimeoutID: ${this.timeCapsuleTimeoutID} `)
    this.isShowTimeCapsule = true;
    /* instrument ignore next */
    if (DeviceInfo.isTv()) {
      return;
    }
    if (this.timeCapsuleTimeoutID !== 0) {
      clearTimeout(this.timeCapsuleTimeoutID)
      this.timeCapsuleTimeoutID = 0;
    }
    this.timeCapsuleTimeoutID = setTimeout((): void => {
      this.isShowTimeCapsule = false;
    }, AvPlayConstants.TIME_CAPSULE_DURATION)
  }

  /**
   * 调整list的滚动
   */
  private scrollForList(): void {
    if (this.isVideoPlaying) {
      let xOffset: number = this.startOffset - this.selectedSmallImgWidth + Constants.PREVIEW_PROGRESS_WIDTH / 2 +
        (this.progressRawTime / this.curItem.duration) *
          (this.selectedSmallImgWidth * this.frameNum - Constants.PREVIEW_PROGRESS_WIDTH);
      Log.info(TAG, `animatorForList onFrame callback begin: ${xOffset}`);
      this.smallScroller?.scrollTo({ xOffset: xOffset, yOffset: 0 });
    }
  }

  onChangeSwiperDirection() {
    Log.info(TAG, `onChangeSwiperDirection, current swiper direction is: ${this.swiperDirection}`);
    if (this.swiperDirection === SwiperDirection.DEFAULT) {
      return;
    } else if (this.swiperDirection === SwiperDirection.LEFT) {
      this.nextItem = this.dataSource?.getDataWithoutCache(this.currentIndex + 1)?.item;
    } else {
      this.nextItem = this.dataSource?.getDataWithoutCache(this.currentIndex - 1)?.item;
    }
    if (!this.canPullingUp) {
      this.broadCast?.emit(BroadCastConstants.RESET_IMAGE_SLIDE_INIT_STATE, []);
    }
    if (this.nextItem) {
      this.nextDisplayedWidth = px2vp(this.nextItem.getDisplayedWidth());
      this.histogramNextItem = this.nextItem;
    }
  }

  private currentDeleteIDChange(uniqueId: string): void {
    Log.info(TAG, `Change currentDeleteID: ${uniqueId}`);
    this.currentDeleteID = uniqueId;
  }

  private smallScrollerOffset(): number {
    return this.smallScroller?.currentOffset()?.xOffset || 0;
  }

  private onRotateScreen(): void {
    this.getSwiperHeight();
  }

  private isCurrentMediaItemLoaded(): boolean {
    const currentMediaItem: MediaItem | undefined =
      this.dataSource?.getAlbumDataSource()?.getRawData?.(this.currentIndex);
    Log.info(TAG, `currentIndex:${this.currentIndex}, typeof currentMediaItem:${typeof currentMediaItem}`);
    if (currentMediaItem) {
      return true;
    }
    return false;
  }

  private isPcShowingEditorChanged(): void {
    this.imagePadding = (!this.isPcShowingEditor && this.isShowBar && DeviceInfo.isPc()) ? {
      top: getScreen().calcBarTopHeight() + PhotoConstants.DIVIDER_WIDTH,
      bottom: this.previewStackHeight + PhotoConstants.DIVIDER_WIDTH
    } : {};
  }

  /**
   * 更新 currentIndex，并触发图片数据重新加载
   *
   * @param index 图片 index 信息
   */
  onGetItemIndexByUri(index: number): void {
    Log.info(TAG, `onGetItemIndexByUri: this.currentIndex=${this.currentIndex}, index=${index}`);
    if (index !== Constants.NOT_FOUND) {
      this.thumbSource?.getData(this.currentIndex);
      this.thumbSource?.getData(index);
      this.thumbSource?.thumbSourcePartGetData(this.currentIndex, index);
      this.currentIndex = index;
      this.curItem = this.dataSource?.getRawData(this.currentIndex)?.data ?? new MediaItem();
      this.currentUri = this.curItem.uri;
    }
    this.dataSource?.onDataReloaded();
  }

  private setCurrentImageUriFunc = (): void => {
    Log.info(TAG, `setCurrentImageUri uri: ${this.currentUri}, index: ${this.currentIndex}`);
    if (this.currentUri.length) {
      AppStorage.setOrCreate<string>('current_image_uri_from_card', this.currentUri);
    }
  }

  private initFromFaCard(): void {
    if (!this.isFromFACard) {
      return;
    }
    this.appBroadCast.on(BroadCastConstants.SET_CURRENT_IMAGE_URI, this.setCurrentImageUriFunc);
  }

  private unInitFromFaCard(): void {
    if (!this.isFromFACard) {
      return;
    }
    this.appBroadCast.off(BroadCastConstants.SET_CURRENT_IMAGE_URI, this.setCurrentImageUriFunc);
  }

  aboutToAppear() {
    this.initFromFaCard();
    this.aiButtonVisibility = this.isShowBar;
    this.initBrowserState();
    this.getSwiperHeight();
    // 三方入口进图库的大图，等待数据加载完成后加载预览条
    if ((this.isFromViewData || this.isFromFACard) && !this.isCurrentMediaItemLoaded()) {
      Log.info(TAG, 'aboutToAppear, set isThumbsourceLoadFinished false');
      this.isThumbsourceLoadFinished = false;
    }
    // 大图浏览初始化时，浏览大图打点数据重置
    this.costReportManager.resetCostInfo();
    this.broadCast.on(BroadCastConstants.ON_DELETE_UI_FIRST, this.onDeleteUIFirstFunc);
    this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadFunc);
    this.broadCast.on(BroadCastConstants.CHANGE_SWIPER_DURATION, this.onChangeSwiperDurationFunc);
    this.broadCast.on(PhotoConstants.PULL_DOWN_START, this.finishSwiperAnimationFunc);
    this.appBroadCast.on(BroadCastConstants.CURRENT_DELETE_UNIQUEID, this.currentDeleteIDFunc);
    this.isSlideBarShow = this.isSlideBarVisibility();
    this.appBroadCast.on(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, this.initVideoPlayFunc);
    this.appBroadCast.on(BroadCastConstants.UPDATE_PROGRESS_RAW_TIME, this.updateProgressRawTimeFunc);
    this.appBroadCast.on(BroadCastConstants.BACK_PRESS_CENTER, this.backPressEventFunc);
    this.broadCast?.on(BrowserConstants.VIDEO_SCROLL_TO_START, this.videoScrollToStartFunc);
    this.broadCast?.on(BrowserConstants.DATA_LOAD_FINISH_PREVIEWER_REFRESH, this.dataLoadFinishPreviewerFunc);
    this.broadCast?.on(BrowserConstants.RESET_VIDEO_FRAME_BEFORE_EDIT, this.resetVideoFrameBeforeEditFunc);
    this.broadCast?.on(BrowserConstants.RESET_VIDEO_FRAME, this.resetVideoFrameFunc);
    this.broadCast.on(BroadCastConstants.PLAY_ICON_CLICK_FRAME_EXPAND, this.clickPlayVideoFrameExpandFunc);
    this.appBroadCast.on(BroadCastConstants.EDIT_UNDO, this.handleUndoFunc);
    this.appBroadCast.on(BroadCastConstants.EDIT_REDO, this.handleRedoFunc);
    this.preCount = this.totalCount;
    this.appBroadCast.on(BroadCastConstants.VIDEO_STATUS_REPORTED, this.videoStatusReportedFunc);
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    // pc场景使用，算上分割线需要+1
    this.imagePadding = (!this.isPcShowingEditor && this.isShowBar && DeviceInfo.isPc()) ? {
      top: getScreen().calcBarTopHeight() + PhotoConstants.DIVIDER_WIDTH,
      bottom: Constants.PC_PREVIEW_STACK_HEIGHT + PhotoConstants.DIVIDER_WIDTH
    } : {};
  }

  initBrowserState() {
    this.curItem = this.dataSource?.getData(this.currentIndex)?.item ?? new MediaItem();
    if (!this.currentUri && this.curItem.uri) {
      this.currentUri = this.curItem.uri;
    }
    Log.info(TAG, `initBrowserState currentIndex: ${this.currentIndex}, currenturi ${this.currentUri},
      curItem: ${this.curItem.uri}`);
  }

  aboutToDisappear() {
    this.unInitFromFaCard();
    this.costReportManager.report();
    // 大图浏览结束时，浏览大图打点数据重置
    this.costReportManager.resetCostInfo();
    this.clearScrollTimer();
    this.isLeftToRightAnim = false;
    this.broadCast.off(BroadCastConstants.ON_DELETE_UI_FIRST, this.onDeleteUIFirstFunc);
    this.broadCast.off(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadFunc);
    this.broadCast.off(BroadCastConstants.CHANGE_SWIPER_DURATION, this.onChangeSwiperDurationFunc);
    this.broadCast.off(PhotoConstants.PULL_DOWN_START, this.finishSwiperAnimationFunc);
    this.appBroadCast.off(BroadCastConstants.CURRENT_DELETE_UNIQUEID, this.currentDeleteIDFunc);
    this.appBroadCast.off(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, this.initVideoPlayFunc);
    this.appBroadCast.off(BroadCastConstants.UPDATE_PROGRESS_RAW_TIME, this.updateProgressRawTimeFunc);
    this.appBroadCast.off(BroadCastConstants.BACK_PRESS_CENTER, this.backPressEventFunc);
    this.broadCast?.off(BrowserConstants.VIDEO_SCROLL_TO_START, this.videoScrollToStartFunc);
    this.broadCast?.off(BrowserConstants.DATA_LOAD_FINISH_PREVIEWER_REFRESH, this.dataLoadFinishPreviewerFunc);
    this.broadCast?.off(BrowserConstants.RESET_VIDEO_FRAME_BEFORE_EDIT, this.resetVideoFrameBeforeEditFunc);
    this.broadCast?.off(BrowserConstants.RESET_VIDEO_FRAME, this.resetVideoFrameFunc);
    this.broadCast.off(BroadCastConstants.PLAY_ICON_CLICK_FRAME_EXPAND, this.clickPlayVideoFrameExpandFunc);
    this.appBroadCast.off(BroadCastConstants.EDIT_UNDO, this.handleUndoFunc);
    this.appBroadCast.off(BroadCastConstants.EDIT_REDO, this.handleRedoFunc);
    this.appBroadCast.off(BroadCastConstants.VIDEO_STATUS_REPORTED, this.videoStatusReportedFunc);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
  }

  build() {
    Stack() {
      this.buildSwiper();
    }
    .key(TAG)
    .onAreaChange((oldValue: Area, newValue: Area) => {
      if (typeof newValue.width === 'number' && typeof newValue.height === 'number' &&
      Number.isFinite(newValue.width) && Number.isFinite(newValue.height)) {
        this.windowLayoutWidth = newValue.width;
        this.windowLayoutHeight = newValue.height;
        Log.debug(TAG,
          `onAreaChange windowLayoutWidth：${vp2px(this.windowLayoutWidth)} windowLayoutHeight:${vp2px(this.windowLayoutHeight)}`)
        this.initStartOffset();
        if (this.isFrameExpand) {
          this.videoProgressScrollTo();
        }
      }
    })
  }

  @LocalStorageLink('geometryOpacity') @Watch('onGeometryOpacityChange') geometryOpacity: number = 1;
  @State @Watch('opacityValueChanged') opacityValue: number = 1;

  onGeometryOpacityChange(): void {
    Log.info(TAG, `list preview onGeometryOpacityChange ${this.geometryOpacity}`);
  }

  opacityValueChanged(): void {
    Log.info(TAG, `opacityValueChanged ${this.opacityValue}`);
  }

  // 预览条动效
  private makePreviewBarTransition(): TransitionEffect {
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

  /**
   * 逐帧播放：大图onchange，翻完之后主缩略图逐渐展开动效
   */
  private videoFrameOnchange(): void {
    this.isPreviewBarAnimation = false;
    // 非xxx翻完之后起一个动效，逐渐改变centerVideoPreviewWidth
    this.isFrameOpenAni = true;
    animateTo({
      duration: AvPlayConstants.ANI_DURATION,
      curve: Curve.Friction,
      onFinish: () => {
        this.initStartOffset();
        this.isFrameOpenAni = false;
      }
    }, () => {
      this.appBroadCast.emit(BroadCastConstants.UPDATE_VIDEO_WIDTH + this.curItem.uniqueId,
        [AvPlayConstants.COVER_FRAME_NUM *
          (DeviceInfo.isTv() ? LengthMetrics.resource($r('app.float.tv_swiper_item_size')).value :
          this.selectedSmallImgWidth)]);
    })
    this.anchorDirection = AnchorDirection.HEADER;
  }

  /**
   * 逐帧播放：大图跟手时动效锚点设置
   */
  private videoFrameOnGesture(extraInfo: SwiperAnimationEvent): void {
    // 左滑：负值；右滑：正值
    if (extraInfo.currentOffset <= 0) {
      // 左滑，锚点在左
      this.anchorDirection = AnchorDirection.HEADER;
    } else {
      // 右滑，锚点在右
      this.anchorDirection = AnchorDirection.FOOTER;
    }
  }

  /**
   * 逐帧播放：大图离手时的回弹动效、及翻页成功后的收起动效
   */
  private videoFrameAniStart(index: number, targetIndex: number): void {
    if (!this.isFrameExpand) {
      this.appBroadCast.emit(BroadCastConstants.UPDATE_VIDEO_WIDTH + this.curItem.uniqueId,
        [targetIndex === index ? 2 * this.selectedSmallImgWidth : this.smallImgLow]);
    } else {
      this.appBroadCast.emit(BroadCastConstants.UPDATE_VIDEO_WIDTH + this.curItem.uniqueId,
        [targetIndex === index ? this.frameNum * this.selectedSmallImgWidth : this.smallImgLow]);
    }
    if (this.photoChanged || !this.isFrameExpand) {
      this.smallScroller.scrollToIndex(targetIndex, false, ScrollAlign.CENTER);
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

  /**
   * 跟手：视频xxx时拖动预览帧
   */
  private slideVideoFrameDidScroll(scrollState: ScrollState): void {
    // false为播放
    if (this.isFrameExpand) {
      if ((scrollState === ScrollState.Scroll || this.isMouseSlideList) && !this.isFingerSlide) {
        // 清除滑动前的ai预分析
        this.isFingerSlide = true;
        const msg: Record<string, number | string | boolean> = {
          'url': ReportToBigDataUtil.urlAnonymize(this.curItem.uri),
          'type': BigDataConstants.VIDEO_SLIDE_BY_FRAME_START,
          'startSeek': this.progressRawTime,
          'duration': this.curItem.duration
        };
        ReportToBigDataUtil.report(BigDataConstants.VIDEO_SLIDE_BY_FRAME, msg);
        this.videoPlayController?.updateFingerSlide(true);
        if (this.isCloudOrSeekUnSupported()) {
          this.cloudVideoFrameScrollStart();
        }
      }
      if (this.isFingerSlide) {
        this.slideVideoFrameBarMove();
      }
    }
  }

  private slideVideoFrameBarMove(): void {
    let offset: number = this.smallScrollerOffset() -
      (this.startOffset - this.selectedSmallImgWidth + Constants.PREVIEW_PROGRESS_WIDTH / 2);
    let width = this.frameNum * this.selectedSmallImgWidth - Constants.PREVIEW_PROGRESS_WIDTH;
    // list组件到达边界时存在边界回弹，hasSeek用于避免首尾的多次seek
    let hasSeek = false;
    if (this.seekTime <= 0) {
      hasSeek = true;
    }
    this.seekTime = Math.floor(this.curItem.duration * offset / width);
    this.seekTime = this.seekTime < 0 ? 0 : this.seekTime > this.curItem.duration ? this.curItem.duration :
    this.seekTime;
    try {
      this.timeCapsuleRawTime = this.seekTime;
      this.progressRawTime = this.seekTime;
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
      Log.info(TAG, `${BrowserConstants.TAG_VIDEO_PLAY_BY_FRAME} slideVideoFrameBarMove seek 3 error ${this.seekTime}
      ${err}`);
    }
  }

  /**
   * 视频seekContinuous格式不支持或者为云
   */
  private isCloudOrSeekUnSupported(): boolean {
    return this.videoPlayController ? (this.curItem.getPosition?.() === photoAccessHelper.PositionType.CLOUD ||
      !this.videoPlayController.isSeekContinueSupported()) : false;
  }

  /**
   * 离手：视频xxx时拖动预览帧
   */
  private slideVideoFrameStop(): void {
    if (this.isFrameExpand && this.isFingerSlide) {
      this.slideVideoFrameBarEnd();
    }
    this.isFingerSlide = false;
    this.videoPlayController?.updateFingerSlide(false);
  }

  private slideVideoFrameBarEnd(): void {
    let offset: number = this.smallScrollerOffset() -
      (this.startOffset - this.selectedSmallImgWidth + Constants.PREVIEW_PROGRESS_WIDTH / 2);
    let width = this.frameNum * this.selectedSmallImgWidth - Constants.PREVIEW_PROGRESS_WIDTH;
    // 是否超出滑动有效范围
    offset = offset < 0 ? 0 : offset > width ? width : offset;
    let endTime: number = Math.floor(this.curItem.duration * offset / width);
    this.expectedProgressRawTime = endTime;
    this.waitingForTimeSync = true;
    // 松手后重新play
    let offsetTime = this.curItem.duration - this.progressRawTime;
    Log.info(TAG, `${BrowserConstants.TAG_VIDEO_PLAY_BY_FRAME} slideVideoFrameBarEnd play endTime: ${endTime}\
     progressRawTime: ${this.progressRawTime} curItem.duration: ${this.curItem.duration} ,offsetTime: ${offsetTime},\
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
      'startSeek': this.progressRawTime,
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

  /**
   * 逐帧播放：点击预览条时的收起动效
   */
  private smallImgAni(): void {
    this.isFrameShrinkIndex = this.currentIndex;
    this.isFrameShrinkAni = true;
    animateTo({
      duration: AvPlayConstants.ANI_DURATION,
      curve: Curve.Friction,
      onFinish: () => {
        this.isFrameShrinkAni = false
        this.isFrameExpand = false;
      }
    }, () => {
      this.appBroadCast.emit(BroadCastConstants.UPDATE_VIDEO_WIDTH + this.curItem.uniqueId,
        [ImageUtil.getSmallImgWidth()]);
    })
  }

  private stackListMarginBottom(): number {
    return DeviceInfo.isTv() ? Constants.TV_SWIPER_PADDING_BOTTOM :
      (DeviceInfo.isPc() ? Constants.PC_LIST_MARGIN_BOTTOM : Constants.PHONE_LIST_MARGIN_BOTTOM);
  }

  @Builder
  buildSwiper() {
    Stack({ alignContent: Alignment.Bottom }) {
      Stack() {
        Swiper(this.swiperController) {
          LazyForEach(this.dataSource as PhotoDataSource, (result: MediaResult, index?: number): void => {
            if (result) {
              PhotoItem({
                photoBrowserStateMachine: this.stateMachine,
                mediaResult: result,
                transitionTag: this.mTransition ? this.mTransition : 'default_id',
                verifyPhotoScaled: this.verifyPhotoScaledFunc,
                albumUri: (this.dataSource?.getAlbumUri()) ?? '',
                canPullingUp: this.canPullingUp,
                geometryTransitionEnable: this.geometryTransitionEnable,
                broadCast: $broadCast,
                isRunningAnimation: $isRunningAnimation,
                isFromFACard: this.isFromFACard,
                isInSelectedMode: this.isInSelectedMode,
                dataSource: this.dataSource,
                isDoingDeleteAnim: $isDoingDeleteAnim,
                isLeftToRightAnim: $isLeftToRightAnim,
                isPreviewListScrolling: $isScrolling,
                swiperController: this.swiperController,
                imageIndex: index,
                currentIndex: this.currentIndex,
                imageList: this.imageList,
                isPcPictureScene: this.isPcPictureScene,
                isDetailSelected: this.isDetailSelected,
                isPrivateHideState: this.isPrivateHideState,
                isSelected: (): boolean => this.isSelected(),
                selectStateChange: (): void => this.selectStateChange(),
                changeMoreMenuList: (array: Action[], index: number): void => this.changeMoreMenuList(array, index),

                // Some state for image analyzer behaviors
                isPullDownAndDragPhoto: $isPullDownAndDragPhoto,
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
                videoCoverFrame: this.videoCoverFrame,
                isFrameExpand: this.isFrameExpand,
                isVideoToEnd: this.isVideoToEnd,
                isNeedRightMenu: true,
                isUserCreatedAlbum: this.isUserCreatedAlbum,
                albumInfo: this.albumInfo,
                isVideoPlaying: this.isVideoPlaying,
                isFromPCPhotoBrowserModule: this.isFromPhotoBrowserModule,
              })
                .opacity(this.swiperOpacityWithBurstPhotos)
                .zIndex((result.item?.uniqueId === this.currentDeleteID) ?
                BrowserConstants.DELETE_LOW_INDEX : BrowserConstants.DELETE_HIGH_INDEX)
                .onAppear(() => {
                  Log.info(TAG, `photoItem, onAppear, index:${index}, uri:${this.currentUri}},` +
                    ` currentIndex:${this.currentIndex}`);
                })
            }
          }, (result?: MediaResult, index?: number): string => {
            if (!result) {
              Log.error(TAG, `photo swiper lazyForEach result undefined; index: ${index}`);
              return JSON.stringify(result) + index;
            }
            if (index === this.currentIndex && result.item) {
              /* instrument ignore next */
              if (DeviceInfo.isPc()) {
                this.getPCImageCompleteValue(result.item);
              }
              this.isSlideBarShow = this.isSlideBarVisibility();
            }
            Log.info(TAG, `photo swiper lazyForEach result is: ${result.item?.path}`);
            return `${result.item?.path}`;
          })
        }
        .onAppear((): void => {
          Log.info(TAG, `photo swiper onAppear, index:${this.currentIndex}, uri:${this.currentUri}`);
        })
        .onKeyPreIme((event: KeyEvent) => {
          if (DeviceInfo.isPc() && event.type === KeyType.Down) {
            if (event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT || event.keyCode === KeyCode.KEYCODE_DPAD_LEFT) {
              Log.info(TAG, 'photoSwiper onPageChange');
              this.shortcutController.listen(event);
              return true;
            }
          }
          return false;
        })
        .cachedCount(this.SWIPE_CACHE_COUNT)
        .itemSpace(this.swiperItemSpace)
        .index(this.currentIndex)
        .indicator(false)
        .loop(false)
        .onChange((index: number): void => {
          // 删除右补位不会走onchange，删除左补位会走
          Log.info(TAG, `[GeometryLogger] swiper onChange index: ${index} isScrolling: ${this.isScrolling}
          currentIndex ${this.currentIndex}`);
          if (this.isItemChange) {
            this.isItemChange = false;
            return;
          }
          this.videoCoverFrame = [];
          if (index != this.currentIndex && this.isFrameExpand) {
            this.isFrameExpand = false;
          }
          Log.info(TAG, `[GeometryLogger] swiper onChange index: ${index} isScrolling: ${this.isScrolling}
          currentIndex ${this.currentIndex}`);
          this.costReportManager.switch();
          this.broadCast?.emit(BrowserConstants.PHOTO_RESET_ROTATION + this.curItem.uniqueId, []);
          this.appBroadCast.emit(BrowserConstants.REQUEST_QUALITY_IMAGE, [index]);
          TraceControllerUtils.startTrace('photoswiperOnchange');
          if (this.isPullingUp) {
            interface Msg {
              uri: string;
              type: string;
            }

            let msg: Msg = {
              uri: this.dataSource == null ? '' : this.dataSource?.getMediaItemWithoutCache(index)?.uri ?? '',
              type: BigDataConstants.PHOTO_DETAIL_SWIPER,
            }
            ReportToBigDataUtil.report(BigDataConstants.PHOTO_DETAIL_OPEN_COUNT, msg);
          }
          if (this.currentIndex - index === 1) {
            // 往左侧滑动
            this.isLeftToRightAnim = true;
          } else if (this.currentIndex - index === -1) {
            // 往右侧滑动
            this.isLeftToRightAnim = false;
          }
          Log.info(TAG, `isLeftToRightAnim: ${this.isLeftToRightAnim}`);
          if (this.mDuration !== 0 && !this.isScrolling) {
            const imageSize: number = this.curItem.width * this.curItem.height;
            Log.info(TAG, `geometryTransitionId updateCurrent ${index}, imageSize ${imageSize}`);
            this.dataSource?.updateCurrent(index);
            clearTimeout(this.swiperTimer);
            if (imageSize >= PRELOAD_MAX_SIZE * PRELOAD_MAX_SIZE) {
              this.onIndexChanged(index, false);
              this.swiperTimer = setTimeout(() => {
                this.updatePixMapDataSource();
              }, 200);
            } else {
              this.onIndexChanged(index, true);
            }
            this.verifyPhotoScaledFunc?.(undefined);
          }
          let curItemResult: MediaItem | undefined = this.dataSource?.getMediaItemWithoutCache(this.currentIndex);
          if (curItemResult) {
            this.curItem = curItemResult;
            /* instrument ignore next */
            if (DeviceInfo.isPc()) {
              this.getPCImageCompleteValue();
            }
            this.currentUri = this.curItem.uri;
          }
          // onChange事件释放超大图
          this.dataSource?.photoDataAdapter?.clearCache(this.currentUri);
          //swiper index变化时立即触发
          this.appBroadCast.emit(BroadCastConstants.SWIPER_INDEX_CHANGED, [index]);
          TraceControllerUtils.finishTrace('photoswiperOnchange');
          if (this.curItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
            this.videoFrameOnchange();
          }
        })
        .disableSwipe(this.isDoDeleteAnim || this.disableSwipe ||
          (this.isRunningAnimation && (this.dataSource?.totalCount() ?? 0) > 1))
        .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent): void => {
          // 只要手势滑动图片，就保存图片备注信息
          /* instrument ignore next */
          if (DeviceInfo.isPc() && this.isDetailSelected) {
            this.appBroadCast?.emit(BroadCastConstants.TURN_LEFT_OR_RIGHT_ITEM_CLICKED, []);
          }
          if (this.isFromPortraitCoverSet) {
            return;
          }
          Log.debug(TAG, `swiper onGestureSwipe index: ${index}, currentIndex: ${this.currentIndex},
          isDoGestureSwipe: ${this.stateMachine.isOnSwiperAnimation()}`);
          this.appBroadCast.emit(BroadCastConstants.CAST_UPDATE_GESTURE, [index, extraInfo]);
          this.swiperDepthByHand(extraInfo.currentOffset);
          this.isTriggeredByPause = false;
          if (!this.stateMachine.isOnSwiperAnimation()) {
            this.stateMachine.processSwiperGestureEvent(index, extraInfo);
          }
          this.analyzerVisibility = Visibility.Hidden;
          this.isImageAnalyzePaused = true;
          LocalStorage.getShared()?.setOrCreate<boolean>('isPullingUpSwiper', this.isPullingUp);
          // thumbList start
          if (!DeviceInfo.isPc() && !this.isShowBar) {
            return;
          }
          this.stateMachine.processSwiperGestureEvent(index, extraInfo);
          Log.debug(TAG, `onGestureSwipe index: ${index} curOffset: ${extraInfo.currentOffset}`);
          this.startTouchIndex = index;
          this.curBigOffset = extraInfo.currentOffset;
          let touchOffset = extraInfo.currentOffset / this.deviceWidth * this.smallImgLow;
          if (this.curItem && this.curItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
            this.videoFrameOnGesture(extraInfo);
          }
          // 往右划 小于0 true  往左滑 大于0 false
          this.isPositiveSliding = touchOffset < 0;
          Log.debug(TAG, `startItemOffset: ${index * this.itemWidth} touchOffset: ${touchOffset} extraInfo.currentOffset:
          ${extraInfo.currentOffset} this.shrinkFactor ${this.shrinkFactor} this.startOffset ${
          this.startOffset},this.isPositiveSliding ${this.isPositiveSliding}`);
          if (!this.isFrameExpand) {
            this.smallScroller.scrollBy(this.diffOffset - touchOffset, 0);
          }
          this.diffOffset = touchOffset;
          // thumbList end
        })
        .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent): void => {
          this.appBroadCast.emit(BroadCastConstants.CAST_INDEX_CHANGED, [targetIndex]);
          Log.info(TAG, 'onAnimationStart ' + index + ` ${targetIndex}` + ' isDoGestureSwipe ' + this.stateMachine.isOnSwiperAnimation());
          performanceMonitor.begin(BigDataConstants.BROWSER_SWIPE, performanceMonitor.ActionType.FIRST_MOVE);
          this.isScrolling = false;
          this.swiperDirection = SwiperDirection.DEFAULT;
          this.stateMachine.processSwiperAnimationStartEvent(index, targetIndex, extraInfo);
          clearTimeout(this.swiperTimer);
          this.analyzerVisibility = Visibility.Hidden;
          this.isImageAnalyzePaused = true;
          if (!this.stateMachine.isOnSwiperAnimation()) {
            let data = this.dataSource?.getMediaItemWithoutCache(targetIndex);
            if (data) {
              this.histogramNextItem = data;
            }
            LocalStorage.getShared()?.setOrCreate<boolean>('isPullingUpSwiper', this.isPullingUp);
            if (this.isRunningAnimation) {
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
            this.isPreviewBarAnimation = true;
            this.scrollSnap = ScrollSnapAlign.CENTER;
            this.listEdgeEffect = EdgeEffect.Spring;
            this.previewProgressOffset = 0;
          } else {
            this.photoChanged = false;
          }
          /* instrument ignore next */
          if (DeviceInfo.isPc() && this.photoChanged) {
            let data = this.dataSource?.getMediaItemWithoutCache(targetIndex);
            if (data) {
              this.pcHistogramNextItem = data;
              this.imageList.forEach(ele => {
                if (ele.index === targetIndex) {
                  this.pcImageCompleteWidth = ele.imageCompleteWidth;
                  this.pcImageCompleteHeight = ele.imageCompleteHeight;
                }
              });
            }
          }
          //滑动动效开始时异步触发,其他模块会监听滑动动效开始进行处理
          if (targetIndex !== index) {
            this.appBroadCast.emit(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, [index]);
            this.appBroadCast.emit(BroadCastConstants.ON_LEAVE_CURRENT_WINDOW, [index]);
            this.broadCast.emit(BroadCastConstants.UPDATE_CLOUD_ENHANCE_ANIMATION_STAGE, []);
            this.broadCast.emit(BroadCastConstants.PRIORITIZE_CLOUD_ENHANCEMENT_TASK, []);
          }
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
              this.isPreviewBarAnimation = false;
            }
          }, (): void => {
            this.curBigOffset = 0;
            this.centerIndex = targetIndex;
            this.videoFrameAniStart(index, targetIndex);
          });
          this.diffOffset = 0;
          // thumbList end
        })
        .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent): void => {
          Log.info(TAG, 'swiper onAnimationEnd');
          if (this.isSlideBarVisibility()) {
            if (this.curItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
              AccessibilityUtil.sendFocusAccessibilityEvent(`PreviewBarItemVideo ${this.currentIndex}`);
            } else {
              AccessibilityUtil.sendFocusAccessibilityEvent(`PreviewBarItemImage ${this.currentIndex}`,
                Heic2JPGManagerAccess.isToastShowing ? Heic2JPGManagerAccess.AFTER_TOAST_DELAY :
                  SEND_FOCUS_DEFAULT_DELAY);
            }
          }
          performanceMonitor.end?.(BigDataConstants.BROWSER_SWIPE);
          this.stateMachine.processSwiperAnimationEndEvent(index, extraInfo);
          if (!this.photoChanged) {
            this.onVisibilityChange();
            this.isImageAnalyzePaused = false;
          }
          if (!(extraInfo.currentOffset === 0 || AppStorage.get<boolean>(Constants.IS_VIDEO_CLEANUP_PAGE))) {
            animateTo({
              duration: 0,
            }, () => {
              this.swiperDepthByHand(extraInfo.currentOffset);
              this.isTriggeredByPause = true;
            })
          }
          // thumbList start
          this.diffOffset = 0;
          this.photoChanged = false;
          if (this.isOpenTouchGuide && this.isPullingUp) {
            Log.info(TAG, 'Photo properties swiper onAnimationEnd,focus to detail component');
            AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_TEXT_INPUT,
              Constants.DELAY_HALF_SECOND);
          }
          Log.info(TAG, `onAnimationEnd index: ${index} curOffset: ${extraInfo.currentOffset}`)
          // thumbList end
        })
        .onKeyEvent((event: KeyEvent): void => {
          Log.info(TAG, `photoSwiper onKeyEvent:${event.keyCode}`);
          // space没有up
          if (KeyType.Down === event.type) {
            if (event.keyCode === MultimodalInputManager.KEY_CODE_PAGE_UP) {
              this.swiperController?.showPrevious();
            } else if (event.keyCode === MultimodalInputManager.KEY_CODE_PAGE_DOWN) {
              this.swiperController?.showNext();
            }
          }
        })

        ImageFlushItem({
          broadCast: $broadCast,
          isScrolling: $isScrolling,
          isLcdComplete: $isLcdComplete,
        })
          .hitTestBehavior(HitTestMode.Transparent)
          .visibility(this.isShowFlushImage ? Visibility.Visible : Visibility.None)
          .onTouch(event => {
            if (event.type == TouchType.Down) {
              this.isScrolling = false;
              this.currentIndex = this.centerIndex;
              Log.info(TAG, `ImageFlushItem update currentIndex：${this.currentIndex}`);
              this.smallScroller.scrollToIndex(this.centerIndex, false, ScrollAlign.CENTER);
            }
          })
      }
      .padding(this.imagePadding)
      .opacity(this.photoSwiperOpacity)

      if (this.browserController.isBrowserShowContent && !this.isFromPortraitCoverSet &&
        !lockedScreenMgr().isFromLockedScreen && this.showPreviewer() &&
        (this.isThumbsourceLoadFinished || this.noNeedWaitLoad())) {
        this.previewer();
      }
    }
    .width(Constants.FULL_PERCENT)
    .height(Constants.FULL_PERCENT)
    .transition(this.makebuildSwiperTransition())
  }

  private noNeedWaitLoad(): boolean {
    // tv三方入口和卡片暂时不需要等待
    return (this.isFromViewData || this.isFromFACard) && DeviceInfo.isTv();
  }

  /**
   * photoItem动效
   * @returns
   */
  private makebuildSwiperTransition(): TransitionEffect | undefined {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      return TransitionEffect.asymmetric(
        TransitionEffect.OPACITY
          .animation({ duration: Constants.PC_PICTURE_TO_SIDEBAR_ANIMATION_DURATION,
            curve: 'standard' }),
        TransitionEffect.OPACITY
          .animation({ duration: Constants.PC_PICTURE_TO_SIDEBAR_ANIMATION_DURATION,
            curve: 'standard' })
      )
    } else {
      return undefined;
    }
  }

  /**
   *  低端机型加载过多预览条节点会导致GPU满负载，影响LCD解码完成后上屏，导致闪白，延迟加载保序
   * @returns
   */
  private showPreviewer(): boolean {
    if (!DeviceInfo.isTablet()) {
      return true;
    } else {
      if (!this.tabletShowPreviewer) {
        setTimeout((): void => {
          this.tabletShowPreviewer = true;
        }, TABLET_PREVIEWER_DELAY_TIME);
      }
      return this.tabletShowPreviewer;
    }
  }

  private swiperPaddingBottom(): number | Resource {
    if (this.isVerdeFoldable) {
      return Constants.VERDE_SWIPER_PADDING_BOTTOM;
    }
    return this.isHorizontal || this.notVerdeExpand() ? $r('app.float.appbar_zero_height') :
      this.isFullMode ? Constants.ToolBarHeight + px2vp(this.navigationBarHeight) :
        Constants.ToolBarHeight + px2vp(this.navigationBarBottomHeight)
  }

  private notVerdeExpand(): boolean {
    return this.isFoldExpanded && this.isFullMode && !DeviceInfo.isPhoneVde();
  }

  @Builder
  timeCapsuleBuilder() {
    Column() {
      Row() {
        Text(`${this.convertTimeToSecond(this.timeCapsuleRawTime)} | ${
        this.convertTimeToSecond(this.curItem.duration, true)}`)
          .fontSize(AvPlayConstants.TIME_CAPSULE_FONT_SIZE)
          .fontWeight(FontWeight.Regular)
          .fontColor(this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ?
          Color.Black : Color.White)
          .lineHeight(Constants.TIME_CAPSULE_LINE_HEIGHT)
          .fontFamily('HarmonyHeiTi')
          .textAlign(TextAlign.Center)
          .maxFontScale(Constants.FONT_SCALE_HEAVY_SIZE)
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
    .position({ x: Constants.PERCENT_50, y: Constants.PERCENT_0 })
    .markAnchor({
      x: Constants.PERCENT_50,
      y: Constants.PERCENT_100,
    })
    .margin({ bottom: AvPlayConstants.TIME_CAPSULE_MARGIN_BOTTOM })
    .visibility(this.isSlideBarVisibility() && this.stateReported && (this.stateReported ===
    AvplayerStatus.PAUSED || this.stateReported === AvplayerStatus.PLAYING) ?
    Visibility.Visible : Visibility.None)
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
          .animation({ duration: AvPlayConstants.TIME_CAPSULE_SCALE_DURATION, curve: Curve.Friction })).combine(
        TransitionEffect.translate({ x: 0, y: AvPlayConstants.TIME_CAPSULE_MARGIN_BOTTOM })
          .animation({ duration: AvPlayConstants.TIME_CAPSULE_SCALE_DURATION, curve: Curve.Friction }))
    )
    .transition(TransitionEffect.IDENTITY)
  }

  @Builder
  timeCapsuleBuilderForTV() {
    Column() {
    }
    .bindPopup(this.isSlideBarVisibility() && this.isFrameExpand && this.isShowTimeCapsulePopup,
      {
        message: `${this.convertTimeToSecond(this.timeCapsuleRawTime)} | ${
        this.convertTimeToSecond(this.curItem.duration, true)}`,
        popupColor: Color.White,
        backgroundBlurStyle: BlurStyle.NONE,
        messageOptions: {
          textColor: Color.Black,
          font: {
            size: Constants.TEXT_SIZE_BODY2,
            style: FontStyle.Normal,
            weight: FontWeight.Regular,
            family: 'HarmonyHeiTi',
          }
        },
        width: POPUP_TIME_TIPS_WIDTH,
        arrowPointPosition: ArrowPointPosition.CENTER,
        placement: Placement.Top,
        mask: false,
        autoCancel: false,
        shadow: {
          radius: 60,
          color: '#26000000',
          offsetX: 0,
          offsetY: 20,
        },
        onWillDismiss: (
          (dismissPopupAction: DismissPopupAction) => {
            if (dismissPopupAction.reason == DismissReason.PRESS_BACK) {
              Log.debug(TAG, `timeCapsule PRESS_BACK`);
              this.isShowTimeCapsulePopup = false;
            }
          }
        )
      })
  }

  @Builder
  previewer() {
    Column() {
      if (this.curItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        /* instrument ignore next */
        if (DeviceInfo.isTv()) {
          this.timeCapsuleBuilderForTV();
        } else {
          this.timeCapsuleBuilder();
        }
      }

      Divider()
        .strokeWidth(this.sliderBarDividerWidth)
        .scale({ y: this.widthScale })
        .color($r('sys.color.comp_divider'))
        .opacity(this.isRunningAnimation ? this.dividerOpacity : this.geometryOpacity)
        .visibility(this.isSlideBarVisibility() ? Visibility.Visible : Visibility.Hidden)
        .renderFit(RenderFit.CENTER)

      Stack({ alignContent: Alignment.Top }) {
        List({
          scroller: this.smallScroller,
          space: DeviceInfo.isTv() ? 0 : Swipes.calcPxRoundToInteger(Constants.LIST_ITEM_SPACE),
          initialIndex: this.currentIndex,
        }) {
          LazyForEach(this.thumbSource, (item: MediaResult, index?: number): void => {
            if (item) {
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
              })
            }
          }, (item: MediaResult, index?: number): string => {
            Log.debug(TAG, 'previewer LazyForEach keyGenerator trigger');
            this.totalCount = this.thumbSource?.totalCount() ?? 0;
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
              this.isFingerSlide = true;
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
              Log.info(TAG, `PreviewList Pan ActionEnd, velocityX: ${event.velocityX}`);
              this.isMouseSlideList = false;
              // fling的velocity参数传-0.001到0.001之间的值,会判定为0,从而不会触发onScrollStart、onScrollStop
              if (event.velocityX <= 0.001 && event.velocityX >= -0.001) {
                this.slideVideoFrameStop();
              } else {
                Log.info(TAG, 'PreviewList Pan ActionEnd, fling');
                this.smallScroller?.fling(event.velocityX);
              }
            })
        )
        .accessibilityScrollTriggerable(false)
        .onTouch((event: TouchEvent): void => {
          if (event.type === TouchType.Down) {
            Log.info(TAG, `ontouch Down ${this.isVideoPlaying} isFrameExpand: ${this.isFrameExpand}`);
            if (this.isFrameExpand) {
              this.showTimeCapsule();
              this.slideVideoFrameBarStart();
              return;
            }
          }
          if (event.type === TouchType.Up) {
            let offsetTime = this.curItem.duration - this.progressRawTime;
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
        .onAppear((): void => {
          Log.info(TAG, 'Preview list appear');
        })
        .contentStartOffset(this.windowLayoutWidth / Constants.DEVICE_WIDTH_HALF - Constants.LIST_ITEM_SPACE)
        .contentEndOffset(this.windowLayoutWidth / Constants.DEVICE_WIDTH_HALF - Constants.LIST_ITEM_SPACE)
        .cachedCount(this.LIST_CACHE_COUNT)
        .alignListItem(ListItemAlign.Start)
        .listDirection(Axis.Horizontal)
        .scrollSnapAlign(this.scrollSnap)
        .flingSpeedLimit(SCROLL_MAX_FLING_SPEED)
        .onScrollFrameBegin((offset: number, state: ScrollState) => {
          if (this.isFrameExpand && state === ScrollState.Fling && (this.seekTime === 0 || this.isVideoToEnd)) {
            Log.info(TAG, `onscrollFrameBegin scrollBy0 offset:${offset} state:${state}`);
            this.smallScroller.scrollBy(0, 0);
            return;
          }
          return Previewer.scrollFrameReducer(offset, state);
        })
        .onScrollIndex((start: number, end: number, center: number): void => {
          Log.info(TAG, `onScrollIndex start ${start} end ${end} center ${center} currentIndex ${this.currentIndex}
             centerIndex ${this.centerIndex}`);
          Log.info(TAG, `isOnSwiperAnimation ${this.stateMachine.isOnSwiperAnimation()} isTouching ${
            this.stateMachine.isTouching()} isShowBar ${this.isShowBar} isFrameShrinkAni ${this.isFrameShrinkAni}
            isPositiveSliding ${this.isPositiveSliding} thumbsourceSize ${this.thumbSource?.totalCount()}`);
          if (this.stateMachine.isOnSwiperAnimation() || this.stateMachine.isTouching() || !this.isShowBar ||
            this.isFrameShrinkAni || this.isPrivateHideState) {
            return;
          }
          TraceControllerUtils.startTrace('photoSwiper onScrollIndex');
          if (this.centerIndex === center || this.disableScrollCallBack()) {
            Log.info(TAG, 'onScrollIndex centerIndex === center, run return');
            return;
          }
          if (start > center || end < center) {
            return;
          }
          Log.info(TAG, `onScrollIndex start ${start} end ${end} center ${center}`);

          // 拦截索引更新
          if (!this.isPositiveSliding) {
            TraceControllerUtils.finishTrace('photoSwiper onScrollIndex');
            return;
          }
          if (this.isFirstInSwiperFromCard) {
            this.currentIndex = this.fromCardCurrentIndex;
            Log.info(TAG, `onScrollIndex update currentIndex：${this.currentIndex}`)
            this.centerIndex = this.fromCardCurrentIndex;
            this.smallScroller.scrollToIndex(this.centerIndex, false, ScrollAlign.CENTER);
            this.isFirstInSwiperFromCard = false;
            TraceControllerUtils.finishTrace('photoSwiper onScrollIndex');
            Log.info(TAG, `currentIndex changed by fromCardCurrentIndex, currentIndex:${this.currentIndex}`);
            return;
          }
          if (center !== this.centerIndex) {
            this.onDataPrepare(center);
          }
          this.centerIndex = center;
          if (this.isScrolling) {
            this.isLcdComplete = false;
            this.broadCast.emit(ImageFlushItem.KEY_UPDATE_FLUSH_ITEM, [this.thumbSource?.getData(center)]);
            TraceControllerUtils.finishTrace('photoSwiper onScrollIndex');
            return;
          }
          this.tempIndex = this.currentIndex;
          if (this.isFromFACard) {
            Log.info(TAG, `onScrollIndex isFromFACard`);
            this.smallScroller.scrollToIndex(this.currentIndex, false, ScrollAlign.CENTER);
          } else {
            this.currentIndex = this.centerIndex;
            Log.info(TAG, `currentIndex changed by centerIndex, currentIndex:${this.currentIndex}`);
          }
          Log.info(TAG, `onScrollIndex update currentIndex: ${this.currentIndex}`)
          TraceControllerUtils.startTrace('photoSwiper updateCurrent');
          this.dataSource?.updateCurrent(center);
          TraceControllerUtils.finishTrace('photoSwiper updateCurrent');
          TraceControllerUtils.finishTrace('photoSwiper onScrollIndex');
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
          this.isLcdComplete = false;
          this.isScrolling = true;
          this.appBroadCast.emit(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, [this.currentIndex]);
          this.appBroadCast.emit(BroadCastConstants.ON_LEAVE_CURRENT_WINDOW, [this.currentIndex]);
          this.isPositiveSliding = true;
          LocalStorage.getShared()?.setOrCreate<boolean>('isPullingUpSwiper', false);
          Log.info(TAG, 'list onDidScroll start');
          this.clearScrollTimer();
          if (this.stateMachine.isOnSwiperAnimation()) {
            return;
          }
          animateTo({
            duration: this.isFirstInSwiperFromCard ? 0 : SCROLL_ANIMATION_DURATION,
            curve: Curve.Linear,
          }, (): void => {
            this.smallScroller.scrollToIndex(this.centerIndex, false, ScrollAlign.CENTER);
            this.shrinkFactor = 0;
            this.updateDataSourceMarginAndWidth();
            this.appBroadCast.emit(BroadCastConstants.UPDATE_VIDEO_WIDTH + this.curItem.uniqueId,
              [ImageUtil.getSmallImgWidth()]);
          });
        })
        .onWillScroll((scrollOffset: number, scrollState: ScrollState): void | ScrollResult => {
          // 非xxx不涉及
          Log.info(TAG, `onWillScroll, isFrameExpand:${this.isFrameExpand}, scrollOffset:${scrollOffset},
            scrollState:${scrollState}`);
          if (!this.isFrameExpand) {
            return;
          }
          let offset = this.smallScrollerOffset() -
            (this.startOffset - this.selectedSmallImgWidth + Constants.PREVIEW_PROGRESS_WIDTH / 2) + scrollOffset;
          let width = this.selectedSmallImgWidth * this.frameNum - Constants.PREVIEW_PROGRESS_WIDTH;
          let outOfRange = offset <= 0 || offset >= width;
          // 达到边界后不允许继续滑动
          if (outOfRange) {
            if (offset <= 0) {
              return { offsetRemain: scrollOffset - offset }
            } else {
              return { offsetRemain: scrollOffset - (offset - width) };
            }
          } else {
            return;
          }
        })
        .onDidScroll((scrollOffset: number, scrollState: ScrollState): void => {
          Log.info(TAG, `list onDidScroll ${scrollState} scrollOffset ${scrollOffset}`);
          this.slideVideoFrameDidScroll(scrollState);
          if (this.disableScrollCallBack()) {
            return;
          }

          if (this.stateMachine.isOnSwiperAnimation()) {
            return;
          }
          if (this.isFirstInSwiperFromCard) {
            this.isFirstInSwiperFromCard = false;
          }
        })
        .onScrollStop((): void => {
          Log.info(TAG,
            `list onScrollStop, isFrameExpand: ${this.isFrameExpand}, isFingerSlide: ${this.isFingerSlide}, isMouseSlideList: ${this.isMouseSlideList}`);
          this.slideVideoFrameStop();
          if (this.disableScrollCallBack()) {
            return;
          }
          /* instrument ignore next */
          if (DeviceInfo.isPc()) {
            let data = this.dataSource?.getMediaItemWithoutCache(this.centerIndex);
            if (data) {
              this.pcHistogramNextItem = data;
            }
          }
          Log.info(TAG, `list onDidScroll stop, startIndex:${this.currentIndex} endIndex:${
          this.centerIndex} isClickToScroll:${this.clickToScrollAni}`);
          // 滑动预览条收起后又回到当前视频；此时不会触发onchange重新播放
          if (this.centerIndex === this.currentIndex && !this.clickToScrollAni) {
            this.appBroadCast.emit(BroadCastConstants.SWIPER_INDEX_CHANGED, [this.currentIndex]);
          }
          Log.info(TAG, `onScrollStop update currentIndex: ${this.currentIndex} -> ${this.centerIndex}`);
          this.currentIndex = this.centerIndex;
          this.dataSource?.updateCurrent(this.currentIndex);
          this.onIndexChanged(this.currentIndex);
          if (this.curItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
            AccessibilityUtil.sendFocusAccessibilityEvent(`PreviewBarItemVideo ${this.currentIndex}`);
          } else {
            AccessibilityUtil.sendFocusAccessibilityEvent(`PreviewBarItemImage ${this.currentIndex}`);
          }
          this.scrollTimer = setTimeout((): void => {
            Log.info(TAG, 'scrolling finish');
            this.isScrolling = false;
            animateTo({
              duration: SCROLL_ANIMATION_DURATION,
              curve: Curve.Linear,
            }, (): void => {
              this.shrinkFactor = 1;
              this.updateDataSourceMarginAndWidth();
            });
          }, SCROLL_ANIMATION_DURATION);

          if (this.stateMachine.isOnSwiperAnimation()) {
            return;
          }
          this.startTouchIndex = this.centerIndex;
          this.endTouchIndex = this.centerIndex;
          Log.info(TAG, `thumbnail scroll, startIndex:${this.currentIndex} endIndex:${this.centerIndex}`);
          const msg: CountMsg = {
            type: BigDataConstants.PHOTO_THUMBNAIL,
            count: Math.abs(this.tempIndex - this.currentIndex),
          }
          ReportToBigDataUtil.report(BigDataConstants.THUMBNAIL_SCROLL_COUNT_ID, msg);
          this.targetOffset = 0;
          animateTo({ curve: Swipes.DELETE_PHOTO_CURVE }, (): void => {
            this.smallScroller.scrollToIndex(this.currentIndex, false, ScrollAlign.CENTER);
            this.centerIndex = this.currentIndex;
            this.onDataPrepare(this.currentIndex);
          });
          this.videoFrameAniStop();

        })
        .onAppear((): void => {
          this.initStartOffset();
        })
        .scrollBar(BarState.Off)
        .height(DeviceInfo.isTv() ? $r('app.float.tv_swiper_item_size') : this.swiperListHeight)
        .width(Constants.FULL_PERCENT)
        .key('PhotoBrowserPreviewBar')
        .margin({
          top: DeviceInfo.isTv() ? 0 : Constants.WAVE_LIST_MARGIN_TOP,
          bottom: this.stackListMarginBottom(),
        })
        .opacity(this.opacityValue)

        // 定位条
        this.PreviewProgressBuilder();
      }
      .onAreaChange((oldValue: Area, newValue: Area) => {
        if (!DeviceInfo.isPc()) {
          return;
        }
        if (typeof newValue.height === 'number' && Number.isFinite(newValue.height)) {
          this.previewStackHeight = newValue.height;
          Log.info(TAG, `previewStackHeight ${this.previewStackHeight}`);
        }
      })
      .renderFit(RenderFit.CENTER)
      .opacity(this.geometryOpacity)
      .clip(DeviceInfo.isPc())
      .backgroundColor(DeviceInfo.isPc() || DeviceInfo.isTv() ? Color.Transparent : (this.isSlideBarVisibility() ?
      $r('sys.color.ohos_id_color_bottom_tab_sub_bg_blur') : Color.Transparent))
      .backgroundBlurStyle(DeviceInfo.isPc() ? BlurStyle.COMPONENT_THICK : BlurStyle.NONE)
      .visibility(this.isSlideBarVisibility()
        ? Visibility.Visible
        : Visibility.Hidden)
      .width(Constants.FULL_PERCENT)
      .height(DeviceInfo.isTv() ? Constants.FULL_PERCENT : undefined)
      .padding({
        bottom: this.swiperPaddingBottom(),
      })
    }
    .height(DeviceInfo.isTv() ? $r('app.float.tv_swiper_list_height') : undefined)
    .visibility(this.isSlideBarVisibility() ? Visibility.Visible : Visibility.Hidden)
    .transition(this.makePreviewBarTransition())
    .onMouse((event: MouseEvent): void => {
      const onMouseState: Previewer.MouseState = Previewer.getMouseState(event, this.smallScroller);
      if (onMouseState.isTrigScroll) {
        this.smallScroller.scrollBy(onMouseState.scrollDistance, 0);
        this.mousePositionX = event.windowX;
      }
    })
  }

  /**
   * 获取预览条水平方向偏移量
   * @returns
   */
  private getPreviewTranslateX(): number {
    if (this.isPullingUp && DeviceInfo.isPc()) {
      return -(Constants.SPLIT_LIST_CARD_WIDTH) / HALF_DIVIDER - px2vp(1);
    } else {
      return 0;
    }
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
    .opacity(this.opacityValue)
    .visibility(this.isSlideBarVisibility() && (this.isFrameExpand &&
      !this.isFrameShrinkAni) && !this.photoChanged && !this.isScrolling
      ? Visibility.Visible : Visibility.Hidden)
    .transition(TransitionEffect.OPACITY.animation({ duration: AvPlayConstants.ONE_HUNDRED, curve: Curve.Sharp }))
    .margin(DeviceInfo.isTv() ? { top: 16 } : undefined)
  }

  private handleKeyEvent(event: KeyEvent): void {
    if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_ESC ||
      event.keyCode === MultimodalInputManager.KEY_CODE_SPACE) {
      this.broadCast.emit(BrowserConstants.PULL_DOWN_END, []);
    } else if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_ENTER) {
      this.showEditor();
    }
  }

  private getSwiperHeight(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
    if (this.isHorizontal && !DeviceInfo.isPc() || this.notVerdeExpand()) {
      this.swiperListHeight = DeviceInfo.isTablet() ?
      $r('app.float.pad_slider_bar_horizon_height') : $r('app.float.slider_bar_horizon_height');
    } else if (DeviceInfo.isPc() || DeviceInfo.isTablet()) {
      this.swiperListHeight = $r('app.float.pc_slider_bar_height');
    } else {
      this.swiperListHeight = $r('app.float.slider_bar_height');
    }
  }

  private checkImmersive(): boolean {
    let winMode = getScreen().getWinMode();
    if (winMode === WindowMode.FULLSCREEN || winMode === WindowMode.PRIMARY) {
      return getScreen().isLayoutFullScreen();
    }
    return false;
  }

  /**
   * 1、必须是PC且是沉浸式操作，包含进入和退出沉浸式
   * 2、与handleImmersiveModeAnimation不能同时执行，isWinSizeChanged以示区分
   */
  private handleWinSizeChangeImmersiveAnimation() {
    let immersive: boolean = this.checkImmersive();
    let isHandleImmersive: boolean = AppStorage.get<boolean>('isHandleImmersive') || false;
    Log.info(TAG, `isHandleImmersive:${isHandleImmersive}, immersive:${immersive}, mode:${getScreen().getWinMode()},
      isLayoutFullScreen:${getScreen().isLayoutFullScreen()}`);
    if (isHandleImmersive && (immersive || (getScreen().isPrimaryMode() && !getScreen().isLayoutFullScreen()))) {
      this.isWinSizeChanged = true;
      Log.info(TAG, `doImmersiveModeAnimation, isWinSizeChanged:${this.isWinSizeChanged}`);
      this.doImmersiveModeAnimation();
    } else {
      this.isWinSizeChanged = false;
      Log.info(TAG, `isWinSizeChanged:${this.isWinSizeChanged}`);
    }
  }

  /**
   * 1、非沉浸式操作跳过
   * 2、进入沉浸式时，winMod为PRIMARY模式，表示有dock栏，会触发winSizeChange，跳过此次动效；其它场景不跳过
   * 3、分屏场景进入沉浸式需触发动效
   * 4、退出沉浸式时，需进入触发退场动效; isWinSizeChanged，窗口变化过则跳过，其它不跳过
   */
  private handleImmersiveModeAnimation() {
    let isHandleImmersive: boolean = AppStorage.get<boolean>('isHandleImmersive') || false;
    let isLayoutFullScreen: boolean = getScreen().isLayoutFullScreen();
    if (!isHandleImmersive || (isLayoutFullScreen && (getScreen().isDisplayInLowerHalfScreen() ||
      this.virtualKbKeyPC === Constants.PC_VIRTUAL_KB_SHOWN))) {
      Log.info(TAG, 'not handle onShowChange immersive, skip.');
      return;
    }
    Log.info(TAG, `photoSwiper onShowChanged: ${this.isShowBar}, winMode:${getScreen().getWinMode()},
      isLayoutFullScreen:${isLayoutFullScreen}, isFullScreen:${getScreen().getIsFullScreen()}`);
    if (this.isWinSizeChanged) {
      this.isWinSizeChanged = false;
      Log.info(TAG, 'win size changed, skip current animation.');
      return;
    }
    // IsFullScreen为窗口右上角全屏/窗口化状态, isFullMode为窗口尺寸全屏(xxx半屏待docker栏场景)
    let withOutDockEnterImmersiveScene: boolean = !getScreen().getIsFullScreen() || getScreen().isFullMode();
    if (withOutDockEnterImmersiveScene) {
      Log.info(TAG, 'doImmersiveModeAnimation');
      this.isWinSizeChanged = false;
      this.doImmersiveModeAnimation();
    }
  }

  private doImmersiveModeAnimation(): void {
    this.isDoingImmersiveAnimationPC = true;
    if (this.isShowBar) {
      this.isShowSideBar = this.isShowSideBarBeforePC;
    } else {
      this.isShowSideBarBeforePC = this.isShowSideBar;
      this.isShowSideBar = false;
    }
    let padding: Padding | Length | LocalizedPadding =
      (!this.isPcShowingEditor && this.isShowBar && DeviceInfo.isPc()) ? {
        top: getScreen().calcBarTopHeight() + PhotoConstants.DIVIDER_WIDTH,
        bottom: this.previewStackHeight + PhotoConstants.DIVIDER_WIDTH
      } : {};
    animateTo({
      duration: BrowserConstants.PC_BROWSER_IMMERSE_ANIM_DURATION,
      curve: Curves.cubicBezier(0.2, 0.0, 0.2, 1.0),
      onFinish: (): void => {
        AppStorage.setOrCreate<boolean>('isHandleImmersive', false);
        this.isDoingImmersiveAnimationPC = false;
      }
    }, (): void => {
      this.imagePadding = padding;
      if (this.isShowBar) {
        this.opacityValue = 1;
      } else {
        this.opacityValue = 0;
      }
    })
  }

  onShowChanged(): void {
    if (!DeviceInfo.isPc() && this.isShowBar && this.currentIndex !== this.centerIndex) {
      Log.debug(TAG, `onShowChanged this.currentIndex ${this.currentIndex}  this.centerIndex ${this.centerIndex}`);
      this.smallScroller.scrollToIndex(this.currentIndex, false, ScrollAlign.CENTER);
      this.centerIndex = this.currentIndex;
    }
    this.aiButtonVisibility = this.isShowBar;
    // 逐帧播放退出沉浸态时显示时间胶囊，且做进度条同步
    if (this.isShowBar && LocalStorage.getShared()?.get('isOpenBrowser')) {
      this.showTimeCapsule();
      if (this.isFrameExpand) {
        this.timeCapsuleRawTime = this.progressRawTime;
        this.videoProgressScrollTo();
      } else {
        this.previewProgressOffset = (this.selectedSmallImgWidth * 2 - Constants.PREVIEW_PROGRESS_WIDTH) *
        this.progressRawTime / this.curItem.duration;
      }
    }
    Log.info(TAG, `onShowChanged this.isShowBar=${this.isShowBar}, this.aiButtonVisibility=${this.aiButtonVisibility}`);
    if (DeviceInfo.isPc()) {
      this.handleImmersiveModeAnimation();
    } else {
      animateTo({
        duration: BrowserConstants.IMMERSE_ANIM_DURATION,
        delay: BrowserConstants.IMMERSE_ANIM_DELAY,
        curve: this.isShowBar ? Curves.cubicBezier(0.6, 0.0, 0.6, 1.0) : Curves.cubicBezier(0.2, 0.0, 0.2, 1.0)
      }, (): void => {
        if (this.isShowBar) {
          this.opacityValue = 1;
        } else {
          this.opacityValue = 0;
        }
      })
    }
  }

  private onWinSizeChanged(): void {
    if (DeviceInfo.isPc()) {
      Log.info(TAG, 'onWinSizeChanged method start');
      this.handleWinSizeChangeImmersiveAnimation();
    }
  }

  /**
   * scrollTo() 左边界移动的距离，正值向左，负值向右
   * scrollBy() 左边界移动的相对距离，正值向左，负值向右
   * scrollToIndex() 聚焦点（左边第一个位置）移动到某个index位置；会触发 onScrollStop() 回调
   */
  private smallScroller: Scroller = new Scroller();
  @State deviceWidth: number = Constants.DEFAULT_WIDTH;
  private readonly smallImgLow: number = 18;
  private readonly smallImgHeight: number = 36;
  private itemWidth: number = this.smallImgLow + Constants.LIST_ITEM_SPACE;
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('getSwiperHeight') private foldDisplayMode: display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @StorageLink('getFoldStatus') @Watch('getSwiperHeight') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @State isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  private startTouchIndex: number = this.currentIndex;
  private endTouchIndex: number = this.currentIndex;
  private sliderBarDividerWidth: string = '1px';
  private widthScale: number = 0.5;
  // 往右划 小于0 true  往左滑 大于0 false 默认向右滑动
  private isPositiveSliding: boolean = true;

  private genMargin(uri: string, percent: number, shrinkFactor: number, centerIndex: number, src?: PhotoDataSource):
    Margin {
    let index: number = this.getIndexByUri(src, uri);
    if (!Number.isFinite(index)) {
      return {};
    }
    let ret: number = 0;
    if (this.stateMachine.isTouching()) {
      if (this.startTouchIndex === index + 1) { // 右侧item
        ret = Constants.LIST_MID_ITEM_MARGIN * Math.max(0, percent);
      } else if (this.startTouchIndex === index - 1) { // 左侧item
        ret = Constants.LIST_MID_ITEM_MARGIN * Math.max(0, 0 - percent);
      } else if (this.startTouchIndex === index) {
        ret = Constants.LIST_MID_ITEM_MARGIN * this.shrinkFactor * (1 - Math.abs(percent)); // 1 -> 0
      }
    } else if (shrinkFactor === 1 && centerIndex === index) { // shrinkFactor等于1为停止态，当前图片需设置margin
      ret = Constants.LIST_MID_ITEM_MARGIN;
    }
    return {
      left: ret,
      right: ret,
      top: Constants.SMALL_IMAGE_MARGIN_TOP,
      bottom: 0,
    };
  }

  getIndexByUri(src: PhotoDataSource | undefined, uri: string): number {
    let index: number = src?.getDataIndexByUri(uri) ?? Number.NaN;
    if (!Number.isFinite(index) && index === Constants.NOT_FOUND) {
      index = Number.NaN;
    }
    return index;
  }

  private genWidth(uri: string, percent: number, shrinkFactor: number, centerIndex: number, src?: PhotoDataSource):
    number {
    let index: number = this.getIndexByUri(src, uri);
    if (!Number.isFinite(index)) {
      return Number.NaN;
    }
    const ratio = ImageSizeUtil.getImageHeightWidthRatio(src?.getItemByUri(uri));
    if (!this.stateMachine.isTouching()) {
      if (shrinkFactor === 1 && centerIndex === index) { // shrinkFactor等于1为停止态，当前图片需放大
        // 36 ~ 72 dynamic change
        Log.info(TAG, `stop width ${this.smallImgHeight * ratio}`);
        return this.smallImgHeight * ratio;
      }
      return this.smallImgLow;
    }
    if (this.startTouchIndex === index + 1) { // 左侧item
      const mediaItem = src?.getRawData(index + 1).data;
      // 1 -> 2  y = kx + b    x = 1 y = 18 x = 2 y = 36r
      const leftRight = ImageSizeUtil.getImageHeightWidthRatio(mediaItem);
      const k = this.smallImgHeight * leftRight - this.smallImgLow;
      const b = this.smallImgHeight - this.smallImgHeight * leftRight;
      // judge current width whether or not bigger than source size
      const threshold = k * Math.max(1, 1 + percent) + b;
      if (threshold > this.smallImgHeight * ratio) {
        return this.smallImgHeight * ratio;
      }
      return threshold;
    }
    if (this.startTouchIndex === index - 1) { // 右侧item
      const mediaItem = src?.getRawData(index - 1).data;
      const leftRight = ImageSizeUtil.getImageHeightWidthRatio(mediaItem);
      const k = this.smallImgHeight * leftRight - this.smallImgLow;
      const b = this.smallImgHeight - this.smallImgHeight * leftRight;
      const threshold = k * Math.max(1, 1 - percent) + b;
      // judge current width whether or not bigger than source size
      if (threshold > this.smallImgHeight * ratio) {
        return this.smallImgHeight * ratio;
      }
      return threshold;
    }
    if (this.startTouchIndex === index) {
      let k = this.smallImgHeight * ratio - this.smallImgLow;
      let b = this.smallImgHeight - this.smallImgHeight * ratio;
      Log.info(TAG, `current image width ${k * Math.max(1, 1 + percent) + b} precent ${percent}`);
      return k * (2 - Math.abs(percent)) + b;
    }
    return this.smallImgLow;
  }

  private getListItemWidth(uri: string): number {
    const percent: number = this.curBigOffset / this.deviceWidth; // 大图滑动比例
    return this.genWidth(reportEmpty(uri), percent, this.shrinkFactor, this.centerIndex, this.dataSource);
  }

  private getListItemMargin(uri: string): Margin | undefined {
    const percent: number = this.curBigOffset / this.deviceWidth; // 大图滑动比例
    return this.genMargin(reportEmpty(uri), percent, this.shrinkFactor, this.centerIndex, this.dataSource);
  }

  private isSlideBarVisibility(isFromViewData?: boolean, isVideoPlay?: boolean, isSlideBarHover?: boolean): boolean {
    let methodName: string = 'isSlideBarVisibility';
    Log.debug(TAG, `${methodName}, isSlideBarHover: ${isSlideBarHover}`);
    if (isSlideBarHover) {
      return true;
    }
    this.totalCount = this.thumbSource?.totalCount() ?? 0;
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      Log.debug(TAG,
        `${methodName}, isShowBar: ${this.isShowBar}, isEditorShown: ${this.isEditorShown}, isInSelectedMode: ${this.isInSelectedMode}, isFromViewData: ${isFromViewData}`);
      return this.isShowBar && !this.isEditorShown && !this.isInSelectedMode && !isFromViewData;
    }
    Log.debug(TAG,
      `${methodName}, isShowBar: ${this.isShowBar}, isEditorShown: ${this.isEditorShown}, isInSelectedMode: ${this.isInSelectedMode}, isFromViewData: ${isFromViewData}, totalCount: ${this.totalCount}, curItem mediaType: ${this.curItem.mediaType}`);
    return this.isShowBar && !this.isEditorShown && !this.isInSelectedMode && !isFromViewData &&
      (this.totalCount > 1 || this.curItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO);
  }

  /**
   * 点击缩略图预览条跳转至大图
   *
   * @param uri 跳转到的大图uri
   */
  private smallImgClickAction(uri?: string): void {
    if (this.stateMachine.isOnSwiperAnimation()) {
      return;
    }
    let src = this.dataSource;
    if (!uri || !src) {
      return;
    }
    const index: number = src.getDataIndexByUri(uri);
    if (!Number.isFinite(index) && index === Constants.NOT_FOUND) {
      return;
    }
    Log.info(TAG, `thumbnail click, uri:${uri}`);
    this.progressRawTime = 0;
    this.isFingerSlide = false;
    this.videoPlayController?.updateFingerSlide(false);
    this.isPullingUp = false;
    this.stateMachine.setPropertiesState(false);
    this.isFrameExpand = false;
    this.clickToScrollAni = true;
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      this.appBroadCast.emit(BroadCastConstants.PHOTO_SWIPER_PREVIEW_CHANGED, [false]);
    }
    this.scrollSnap = ScrollSnapAlign.CENTER;
    this.listEdgeEffect = EdgeEffect.Spring;
    this.previewProgressOffset = 0;
    LocalStorage.getShared()?.setOrCreate<boolean>('isPullingUpSwiper', false);
    Log.info(TAG, `thumbnail click, startIndex:${this.currentIndex} endIndex:${index}`);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, [this.currentIndex]);
    this.appBroadCast.emit(BroadCastConstants.ON_LEAVE_CURRENT_WINDOW, [this.currentIndex]);
    const msg: CountMsg = {
      type: BigDataConstants.PHOTO_THUMBNAIL,
      count: Math.abs(index - this.tempIndex),
    }
    ReportToBigDataUtil.report(BigDataConstants.THUMBNAIL_CLICK_COUNT_ID, msg);
    if (this.curItem && this.curItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      this.smallImgAni();
    }
    Log.info(TAG, `thumbnail click, isEditorShown:${this.isEditorShown}`);
    if (!this.isEditorShown) {
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
    let mediaItem: MediaItem | undefined = this.dataSource?.getItemByUri(uri);
    if (mediaItem?.getIsMovingPhoto()) {
      Global.setString('previewClickMovingPhoto', uri);
    }
    Log.info(TAG, `smallImgClickAction currentIndex update currentIndex: ${this.currentIndex} -> ${index}`);
    this.currentIndex = index;
    this.tempIndex = index;
  }

  private onVisibilityChange(): void {
    this.analyzerVisibility = !this.isDoingImageSlideAnimation && !this.isPullingUp && !this.isRunningAnimation &&
      !this.isPullDownAndDragPhoto && this.canShowImageAnalyzer && !lockedScreenMgr().isFromLockedScreen &&
      !this.isInAnimateToPosition && !this.isInSelectedMode && !this.isFromPortraitCoverSet &&
      !this.stateMachine.isOnSwiperAnimation() ? Visibility.Visible : Visibility.Hidden;
    Log.info(TAG, `this.analyzerVisibility = ${this.analyzerVisibility}, this.currentIndex= ${
    this.currentIndex}, this.isDoingImageSlideAnimation = ${this.isDoingImageSlideAnimation}, this.isPullingUp = ${
    this.isPullingUp}, this.isRunningAnimation = ${this.isRunningAnimation}, this.isPullDownAndDragPhoto = ${
    this.isPullDownAndDragPhoto}, lockedScreenMgr().isFromLockedScreen = ${
    lockedScreenMgr().isFromLockedScreen}, this.isInAnimateToPosition = ${
    this.isInAnimateToPosition}, this.isInSelectedMode = ${this.isInSelectedMode}, this.isFromPortraitCoverSet = ${
    this.isFromPortraitCoverSet}, this.isOnSwiperAnimation = ${this.stateMachine.isOnSwiperAnimation()}`);
  }

  private onDeleteUIFirst(): void {
    Log.info(TAG, `onDeleteUIFirst uri: ${this.currentUri}`);
    this.stateMachine.processDeleteStartEvent();
    this.dataSource?.getAlbumDataSource()?.invalidUris.push(this.currentUri);
    try {
      let dataSourceLength = this.dataSource?.getAlbumDataSource()?.items.length ?? 0 - 1;
      for (let i = dataSourceLength; i >= 0; i--) {
        const item = this.dataSource?.getAlbumDataSource()?.items[i];
        if (this.currentUri && item?.uri === this.currentUri) {
          this.dataSource?.getAlbumDataSource()?.items.splice(i, 1);
        }
      }
    } catch (e) {
      Log.error(TAG, `print onDeleteUIFirst log info err ${e}`);
    }
    this.dataSource?.getAlbumDataSource()?.emitCountUpdateCallbacks();
    if ((this.dataSource?.totalCount() || 0) > 0) {
      this.broadCast?.emit(BroadCastConstants.ON_DATA_RELOADED, [true]);
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

  private onDataReload(): void {
    this.isSlideBarShow = this.isSlideBarVisibility();
    // 当前元素仍然能找到
    const index: number | undefined = this.dataSource?.getDataIndexByPrefix(this.currentUri);
    const inInvalidUris: boolean =
      this.dataSource?.getAlbumDataSource()?.invalidUris.includes(this.currentUri) ?? false;
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
      this.dataSource !== undefined && index < this.dataSource.totalCount()) {
      this.onGetItemIndexByUri(index);
      return;
    }

    let uiContext: UIContext = LocalStorage.getShared()?.get<UIContext>('uiContext') as UIContext;
    Log.info(TAG, `animateTo data reloaded start uiContext: ${uiContext} isDoingDeleteAnim:${this.isDoingDeleteAnim}\
     isDeleting: ${this.isDeleting} currentIndex: ${this.currentIndex} centerIndex: ${this.centerIndex}\
     isPositiveSliding:${this.isPositiveSliding}`);
    if (!uiContext || this.isDoDeleteAnim) {
      Log.error(TAG, `onDataReload uiContext: ${uiContext}, isDoDeleteAnim: ${this.isDoDeleteAnim}`);
      return;
    }
    this.isDeleting = true;
    this.analyzerVisibility = Visibility.Hidden;
    LocalStorage.getShared()?.setOrCreate<boolean>('isPullingUpSwiper', false);
    TraceControllerUtils.startTrace('CUSTOM_ANIMATOR_deletePhotoAnimate');
    this.appBroadCast.emit(BrowserConstants.ITEM_BLUR_CHANGE, []);
    this.broadCast.emit(BroadCastConstants.RESET_TO_IMAGE_SLIDE_INIT_STATE, []);
    this.deleteItemPath = this.curItem.path;
    uiContext.animateTo({
      delay: PhotoConstants.DELETE_ANIM_DELAY,
      duration: PhotoItem.DELETE_PHOTO_ANIM_DURATION + Swipes.DELETE_OFFSET_DURATION, // 删除动画结束回调时长
      curve: Swipes.DELETE_PHOTO_CURVE, // 减速曲线参数
      onFinish: (): void => {
        TraceControllerUtils.finishTrace('CUSTOM_ANIMATOR_deletePhotoAnimate');
        Log.info(TAG,
          `animateTo onFinish isDoingDeleteAnim: ${this.isDoingDeleteAnim}, mTransition: ${this.mTransition}`);
        this.broadCast.emit(BroadCastConstants.RESET_CLOUD_ENHANCE_ANIMATION_STAGE, []);
        this.stateMachine.processDeleteEndEvent();
        this.isDoingDeleteAnim = false;
        this.isDoDeleteAnim = false;
        let totalCount = this.dataSource?.totalCount() ?? 0;
        this.dataSource?.onDataChanged(this.currentIndex);
        // UPDATE NEXT TWO DATA FOR AVOID NOT LOADING DATA
        if (this.currentIndex + 1 < totalCount) {
          this.dataSource?.onDataChanged(this.currentIndex + 1);
        }
        if (this.currentIndex + 2 < totalCount) {
          this.dataSource?.onDataChanged(this.currentIndex + 2);
        }
        this.forceRefresh++;
        this.appBroadCast.emit(BroadCastConstants.IS_CLICK_REMOVE_OR_HIDDEN_DIALOG, [false]);
        // THUMBDATASOURCE UPDATE
        if (this.mTransition !== Constants.PHOTO_TRANSITION_TIMELINE_GROUP) {
          this.thumbSource?.updateMapAfterDataDelete();
          this.thumbSource?.mapDeleteData(this.deleteItemPath);
        } else {
          this.dataSource?.getAlbumDataSource()?.forceUpdate();
        }
      }
    }, (): void => {
      Log.info(TAG, 'animateTo closure');
      this.isDoDeleteAnim = true;
      const oldIndex: number = this.currentIndex;
      this.appBroadCast.emit(BroadCastConstants.IS_CLICK_REMOVE_OR_HIDDEN_DIALOG, [true]);
      this.isFrameExpand = false;
      this.appBroadCast.emit(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, [this.currentIndex, true]);
      this.appBroadCast.emit(BroadCastConstants.ON_LEAVE_CURRENT_WINDOW, [this.currentIndex]);

      this.dataSource?.deleteData(this.currentIndex);
      // 往左滑 补位
      if (!this.isPositiveSliding && this.centerIndex !== 0) {
        // 左侧图片补位
        this.thumbSource?.getData(this.currentIndex - 1);
        this.centerIndex = this.centerIndex <= 0 ? 0 : this.centerIndex - 1;
        let nextIndex: number = this.currentIndex <= 0 ? 0 : this.currentIndex - 1;
        Log.info(TAG, `animateTo closure cur: ${this.currentIndex}->${nextIndex}`);
        this.currentIndex = nextIndex;
        this.smallScroller.scrollToIndex(this.currentIndex, false, ScrollAlign.CENTER);
      } else {
        Log.info(TAG, 'current index');
        if (this.currentIndex === this.dataSource?.totalCount()) {
          Log.info(TAG, 'last item currentIndex = currentIndex - 1');
          this.currentIndex--;
        }
        // 右侧图片补位 currentIndex不发生改变，仅更新数据
        let data = this.thumbSource?.getData(this.currentIndex);
        // item在同时收起和展开，有时会存在scroll有滚动，导致选中项非下一个
        this.smallScroller.scrollToIndex(this.currentIndex, false, ScrollAlign.CENTER);
        this.appBroadCast.emit(BroadCastConstants.UPDATE_VIDEO_WIDTH + data?.item?.uniqueId,
          [AvPlayConstants.COVER_FRAME_NUM * this.selectedSmallImgWidth]);
      }
      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        // 删除完成之前拿到对应方向的下一张图片
        let picNextItem: MediaItem | undefined = this.thumbSource?.getData(this.currentIndex)?.item;
        if (picNextItem) {
          this.pcHistogramNextItem = picNextItem;
        }
      }
      this.forceRefresh++;
      this.scrollSnap = ScrollSnapAlign.CENTER;
      this.listEdgeEffect = EdgeEffect.Spring;

      if (this.currentIndex >= 0 && this.currentIndex < (this.dataSource?.totalCount() ?? 0)) {
        const curItemResult: MediaItem | undefined = this.dataSource?.getMediaItemWithoutCache(this.currentIndex);
        if (curItemResult) {
          this.curItem = curItemResult;
          Log.info(TAG, `animateTo closure ${oldIndex}->${this.currentIndex} ${this.currentUri}->${this.curItem.uri}`);
          /* instrument ignore next */
          if (DeviceInfo.isPc()) {
            this.getPCImageCompleteValue();
          }
          this.currentUri = this.curItem.uri;
        }
      }
      this.isDeleting = false;
    })
  }

  private getPCImageCompleteValue(item?: MediaItem): void {
    this.pcCurItem = this.curItem.uri !== '' ? this.curItem : item;
    this.imageList.forEach(ele => {
      if (ele.index === this.currentIndex) {
        this.pcImageCompleteWidth = ele.imageCompleteWidth;
        this.pcImageCompleteHeight = ele.imageCompleteHeight;
      }
    });
  }

  /**
   * 修改 Swiper 切图动效执行时长
   *
   * @param value 更新后 Swiper 动效执行时长
   */
  private onChangeSwiperDuration(value: number): void {
    Log.debug(TAG, `change duration start ${value}`);
    this.mDuration = value;
  }

  private clearScrollTimer(): void {
    if (!Number.isFinite(this.scrollTimer)) {
      return;
    }
    clearTimeout(this.scrollTimer);
    this.scrollTimer = Number.NaN;
  }

  jumpStart(): void {
    Log.info(TAG, `jumpStart this.currentIndex ${this.currentIndex}  this.centerIndex ${this.centerIndex}`);
    if (this.currentIndex !== this.centerIndex) {
      if (this.isFrameExpand) {
        this.startOffset += (ImageUtil.getSmallImgWidth() + Constants.LIST_ITEM_SPACE) *
          (this.currentIndex - this.centerIndex)
        this.videoProgressScrollToByDuration(0);
        this.isItemChange = true;
      } else {
        Log.info(TAG, 'jumpStart smallScroller scrollToIndex');
        this.smallScroller.scrollToIndex(this.currentIndex, false, ScrollAlign.CENTER);
      }
      if (!DeviceInfo.isPc()) {
        this.centerIndex = this.currentIndex;
      }
      this.onDataPrepare(this.currentIndex);
    }
    this.curItem = this.dataSource?.getRawData(this.currentIndex)?.data ?? new MediaItem();
    this.currentUri = this.curItem.uri;
    this.swiperController?.changeIndex(this.currentIndex);
  }

  /**
   * swiper左右滑动景深错层效果跟手动效
   *
   * @param currentOffset 跟手滑动位移
   */
  private swiperDepthByHand(currentOffset: number): void {
    Log.debug(TAG, 'swiperDepthByHand');
    this.swiperDirection = currentOffset > 0 ? SwiperDirection.RIGHT : SwiperDirection.LEFT;
  }

  private finishSwiperAnimation(): void {
    this.swiperController?.finishAnimation((): void => {
      Log.info(TAG, 'finish swiper animation by hand');
    });
  }

  // 底部缩略图宽度和间距更新
  private updateDataSourceMarginAndWidth() {
    TraceControllerUtils.startTrace('updateDataSourceMarginAndWidth');
    let index = this.centerIndex;
    let shrinkFactor = this.shrinkFactor;
    let isTouching = this.stateMachine.isTouching();
    let startIndex = this.startTouchIndex ?? 0;
    // 跟手的位移占屏幕宽度的比
    let winWidth = ScreenManager.getInstance().getWinWidth();
    let percent = this.curBigOffset / winWidth;
    let forceRefresh = this.forceRefresh;
    if (this.lastResult.index !== index || this.lastResult.shrinkFactor !== shrinkFactor
      || this.lastResult.isTouching !== isTouching || this.lastResult.startIndex !== startIndex
      || this.lastResult.percent !== percent || this.lastResult.forceRefresh !== forceRefresh) {
      this.lastResult.index = index;
      this.lastResult.shrinkFactor = shrinkFactor;
      this.lastResult.isTouching = isTouching;
      this.lastResult.startIndex = startIndex;
      this.lastResult.percent = percent;
      this.lastResult.forceRefresh = forceRefresh;
    } else {
      TraceControllerUtils.finishTrace('updateDataSourceMarginAndWidth');
      return;
    }
    Log.info(TAG, `updateDataSourceMarginAndWidth index:${index},shrinkFactor:${shrinkFactor},\
      isTouching:${isTouching},startIndex:${startIndex},percent:${percent}`);
    this.thumbSource?.updateIndexWidthMargin(index, shrinkFactor, isTouching, startIndex, percent);
    TraceControllerUtils.finishTrace('updateDataSourceMarginAndWidth');
  }

  private getPreviewProgressWidth(): Length {
    return DeviceInfo.isTv() ? Constants.TV_PREVIEW_PROGRESS_WIDTH : Constants.PREVIEW_PROGRESS_WIDTH;
  }

  private getPreviewProgressHeight(): number {
    return (DeviceInfo.isPc() || DeviceInfo.isTablet())
      ? Constants.WAVE_PAD_PREVIEW_PROGRESS_HEIGHT :
      (DeviceInfo.isTv() ? Constants.TV_WAVE_PREVIEW_PROGRESS_HEIGHT : Constants.WAVE_PREVIEW_PROGRESS_HEIGHT);
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
}

class TempResult {
  index: number = 0;
  shrinkFactor: number = 0;
  isTouching: boolean = true;
  startIndex: number = 0;
  percent: number = 0;
  forceRefresh: number = 0;
}