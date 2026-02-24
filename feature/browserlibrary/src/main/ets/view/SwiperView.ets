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
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { MediaResult } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaResult';
import lazy { PhotoItem } from '@ohos/browsercommon/src/main/ets/default/view/PhotoItem';
import lazy GeometryIdManager from '@ohos/browsercommon/src/main/ets/default/view/GeometryIdManager';
import lazy { ImageFlushItem } from '@ohos/browsercommon/src/main/ets/default/view/ImageFlushItem';
import lazy { ThumbDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/ThumbDataSource';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy Swipes, { SwiperDirection } from '@ohos/common/src/main/ets/default/view/Swipes';
import lazy { PCImageInfo } from '@ohos/browsercommon/src/main/ets/default/view/PCImageInfo';
import lazy { BasePhotoBrowserController } from '../model/BasePhotoBrowserController';
import lazy { SwiperStateListener, SwiperVM } from '../model/SwiperVM';
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import lazy { PhotoPreviewer } from './PhotoPreviewer';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { ShortcutController,
  ShortcutManager } from '@ohos/browsercommon/src/main/ets/default/controller/ShortcutController';
import lazy { KeyCode } from '@kit.InputKit';
import lazy { SwiperThirdVM } from '../model/SwiperThirdVM';
import lazy { SwiperHmVM } from '../model/SwiperHmVM';
import lazy { FastScrollChecker } from '@ohos/browsercommon/src/main/ets/default/utils/FastScrollChecker';
import { ThumbnailView } from './ThumbnailView';

export const SCROLL_ANIMATION_DURATION: number = 100;

const TAG: string = 'browser_SwiperView';
const TABLET_PREVIEWER_DELAY_TIME: number = 80;

export enum AnchorDirection {
  HEADER,
  FOOTER
}

/**
 * list缓存的item的个数
 */
export const LIST_CACHE_COUNT: number = 7;

/**
 * 大图页组件，供 PC 使用
 */
@Component
export struct SwiperView {
  @ObjectLink stateMachine: PhotoBrowserStateMachine;
  @State imageList: PCImageInfo[] = [];
  /**
   * Swiper 组件所展示的当前图片信息
   *
   */
  @Link pcCurItem: MediaItem;
  @Prop isPcPictureScene: boolean;
  /**
   * 大图组件控制器
   */
  @Consume browserController: BasePhotoBrowserController;
  onPhotoChanged: Function = (index: number): void => {
  };
  onDataPrepare: Function = (index: number): void => {
  };
  onIndexChanged: Function = (index: number): void => {
  };
  /**
   * 转场动效使用标记ID
   */
  public mTransition: string = '';
  /**
   * 广播，用于保存关键回调
   */
  @State broadCast: BroadCast | undefined = undefined;
  /**
   * 图片容器 Swiper 使用的控制器，控制水平切换图片
   */
  public swiperController: SwiperController = new SwiperController();
  /**
   * 判断是否在快速滑动中
   */
  private fastScrollChecker: FastScrollChecker = new FastScrollChecker();
  /**
   * 标记是否禁止 Swiper 滑动切图
   */
  @Consume disableSwipe: boolean;
  public swiperItemSpace: number = 8;
  /**
   * 确认图片缩放信息回调
   */
  public verifyPhotoScaledFunc?: (matrix?: Matrix4.Matrix4Transit) => void;
  /**
   * 标志当前是否支持上滑，唤出图片详情信息
   */
  public canPullingUp: boolean = false;
  /**
   * 标志当前是否正在执行切图
   */
  @State @Watch('onSwiperAnimationChange') isSwiperOffsetZero: boolean = true;
  /**
   * 标志当前是否支持一镜到底动效
   */
  private geometryTransitionEnable: boolean = false;
  /**
   * swiper缓存的item的个数
   */
  private SWIPE_CACHE_COUNT: number = 5;
  @Prop private curHiSearchWords: string = '';

  /**
   * AI 组件相关变量，控制此时是否支持响应平移手势
   */
  @State canRespondPanGesture: boolean = true;
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
  @Consume isEnableMouse: boolean;
  /**
   * 应用级广播，保存关键监听回调
   */
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private thumbSource: ThumbDataSource | undefined = undefined;
  /**
   * 数据源是否是沙箱数据
   */
  public isShowImageAnalyzer: boolean = true;
  private smallScroller: Scroller = new Scroller();

  @State isLeftMouseButtonPress: boolean = false;
  @Prop isPhotoScaled: boolean = false;
  // swiper depth
  @State currentImageWidth: number = 0;
  @State nextItem?: MediaItem = new MediaItem();
  /**
   * 是否是pc相机场景拉起的大图
   */
  private isPcCameraPull: boolean = false;

  // 进入和退出连拍时，大图图片的透明度
  @Prop swiperOpacityWithBurstPhotos: number = 1;
  // 进入和退出连拍时，两侧缩略图的透明度
  @Prop previewItemOpacity: number = 1;
  // 进入和退出连拍时，当前缩略图的透明度
  @Prop centerPreviewOpacity: number = 1;
  private showEditor: Function = (media: MediaItem): void => {
  };
  private showEditorFunc: Function = (): void => {
    this.showEditor(this.browserController.dataSource.getItemByUri(this.viewModel.curItem?.uri));
  };

  @Prop isPrivateHideState: boolean = false;
  private isFromPortraitCoverSet: boolean = false;
  private isFromPortrait: boolean = false;
  private isUserCreatedAlbum: boolean = false;
  /**
   * 多选态选择
   */
  private isSelected: Function = (): boolean => {
    return false;
  };
  private selectStateChange: Function = (): void => {
  };
  private changeMoreMenuList: Function = () => {
  };

  private shortcutController: ShortcutController = ShortcutManager.getInstance();

  private isThirdScene: boolean = true;
  /**
   * 标志当前页面是否是由 FA 卡片拉起
   */
  private isFromFACard: boolean = false;

  private isInSelectedMode: boolean = false;

  private isShowThumbSource: boolean = true;
  @State viewModel: SwiperVM = new SwiperThirdVM(this.stateMachine);
  @State startTouchIndex: number = this.stateMachine.getCurrentIndex();
  @Prop @Watch('updateDataSourceMarginAndWidth') forceRefresh: number = 0;
  @Prop @Watch('onVideoPlayChange') private isVideoPlaying: boolean;
  @Prop @Watch('onIsEditorShownChange') isEditorShown: boolean = false;
  /**
   * 缩略图预览条中心图索引
   */
  @State @Watch('updateDataSourceMarginAndWidth') private centerIndex: number = this.stateMachine.getCurrentIndex();
  /**
   * 波浪预览条相关变量
   */
  @State @Watch('updateDataSourceMarginAndWidth') shrinkFactor: number = 1.0;
  @State @Watch('updateDataSourceMarginAndWidth') targetOffset: number = 0;
  @State @Watch('updateDataSourceMarginAndWidth') curBigOffset: number = 0;
  /**
   * 逐帧播放：时间胶囊展示时间；是否展示时间胶囊
   */
  @State timeCapsuleRawTime: number = 0;
  /**
   * 逐帧播放：是否为xxx标志变量
   */
  @State @Watch('onFrameExpand') isFrameExpand: boolean = false;
  @State @Watch('onStartOffset') startOffset: number = 0;
  @State @Watch('opacityValueChanged') opacityValue: number = 1;
  @State @Watch('onPreviewProgressOffsetChanged') previewProgressOffset: number = 0;
  @State @Watch('onScrollSnapChanged') scrollSnap: ScrollSnapAlign = ScrollSnapAlign.CENTER;
  @State @Watch('onListEdgeEffectChanged') listEdgeEffect: EdgeEffect = EdgeEffect.Spring;
  @State @Watch('onIsPositiveSlidingChanged') isPositiveSliding: boolean = true;
  @State @Watch('onIsVideoToEndChanged') isVideoToEnd: boolean = false;
  @State @Watch('onCurrentDeleteIDChanged') currentDeleteID: string = '';
  /**
   * AI 组件相关变量，控制 AI 组件是否可见
   */
  @State @Watch('onAnalyzerVisibilityChanged') analyzerVisibility: Visibility = Visibility.Visible;
  @State @Watch('onIsLcdCompleteChanged') isLcdComplete: boolean = false;
  @Link @Watch('onIsScrollingChanged') isScrolling: boolean;
  @State @Watch('onPreviewBarAnimationChanged') isPreviewBarAnimation: boolean = false;
  /**
   * 逐帧播放：翻页动效时的锚点
   */
  @State @Watch('onAnchorDirectionChanged') anchorDirection: AnchorDirection = AnchorDirection.HEADER;
  @State @Watch('onFrameOpenAniChanged') isFrameOpenAni: boolean = false;

  @State @Watch('onChangeSwiperDirection') swiperDirection: number = SwiperDirection.DEFAULT;
  @State @Watch('showPreviewer') private tabletShowPreviewer: boolean = false;
  /**
   * 标志 Swiper 组件是否正在执行切图动画
   */
  @State @Watch('onDoingImageSlideAnimation') isDoingImageSlideAnimation: boolean = false;
  @State @Watch('onInAnimateToPosition') isInAnimateToPosition: boolean = false;
  /**
   * 标志当前是否支持上滑唤出图片详情
   */
  @State @Watch('onIsPullingUpChanged') isPullingUp: boolean = false;
  /**
   * 逐帧播放：展开前展示两帧视频封面；点击扩展的逐帧抽取，未获取时先用首帧占位
   */
  @State private videoCoverFrame: PixelMap[] = [];
  @State waitingForTimeSync: boolean = false;
  @State expectedProgressRawTime: number = 0;
  /**
   * 标志当前是否正在支持下拉图片，执行下拉跟手动效
   */
  @Link @Watch('onPullDownAndDragPhoto') isPullDownAndDragPhoto: boolean;
  @Link @Watch('onShowChanged') isShowBar: boolean;
  @Link @Watch('onSlideBarShowChanged') isSlideBarShow: boolean;
  /**
   * 标志当前是否正在执行一镜到底动效
   */
  @Link @Watch('onRunningAnimationChanged') isRunningAnimation: boolean;

  /**
   * 是否在左右键快切动效
   */
  @Link @Watch('onInSwiperAnimationChanged') isInSwiperAnimation: boolean;

  @LocalStorageLink('isPcShowingEditor') @Watch('onPcShowingEditorChanged') isPcShowingEditor: boolean = false;
  /**
   * 大图一镜到底动效绑定 ID
   */
  @LocalStorageLink('geometryTransitionBrowserId') @Watch('onGeometryIdChange') geometryTransitionId: string = '';
  /**
   * 标志当前是否正在执行删除动效
   */
  @StorageLink('isDoingDeleteBigPhotoAnim') isDoingDeleteAnim: boolean = false;
  @StorageLink('isBigPhotoLeftToRightAnim') isLeftToRightAnim: boolean = false;
  @State imagePadding: Padding | Length | LocalizedPadding = {};
  /* instrument ignore next */
  @LocalStorageLink('photoSwiperOpacity') photoSwiperOpacity: number = 1;
  /**
   * 标志是否正在执行删除动画动效
   */
  @Consume @Watch('onIsDeletingChanged') isDeleting: boolean;
  @Consume @Watch('onDoDeleteAnimChanged') isDoDeleteAnim: boolean;
  /* instrument ignore next */
  @Consume @Watch('onIsShowVideoChanged') isShowVideo: boolean;

  @Provide @Watch('onHistogramNextItemChanged') histogramNextItem: MediaItem = new MediaItem();
  @State isThumbnailViewShow: boolean = true;
  @State thumbnailShow: boolean = true;

  public isThumbnailViewReAdapt: boolean = true;

  private setThumbnailViewShow: Function = (isThumbnailViewShow: boolean) => {
    this.isThumbnailViewShow = isThumbnailViewShow;
  }

  private swiperStateListener: SwiperStateListener = {
    onCenterIndex: (centerIndex: number) => {
      if (this.centerIndex !== centerIndex) {
        this.centerIndex = centerIndex;
      }
    },
    onTimeCapsuleRawTimeChange: (timeCapsuleRawTime: number) => {
      if (this.timeCapsuleRawTime !== timeCapsuleRawTime) {
        this.timeCapsuleRawTime = timeCapsuleRawTime;
      }
    },
    onShrinkFactor: (shrinkFactor: number) => {
      if (this.shrinkFactor !== shrinkFactor) {
        this.shrinkFactor = shrinkFactor;
      }
    },
    onTargetOffset: (targetOffset: number) => {
      if (this.targetOffset !== targetOffset) {
        this.targetOffset = targetOffset;
      }
    },
    onCurBigOffset: (curBigOffset: number) => {
      if (this.curBigOffset !== curBigOffset) {
        this.curBigOffset = curBigOffset;
      }
    },
    onIsFrameExpand: (isFrameExpand: boolean) => {
      if (this.isFrameExpand !== isFrameExpand) {
        this.isFrameExpand = isFrameExpand;
      }
    },
    onStartOffset: (startOffset: number) => {
      if (this.startOffset !== startOffset) {
        this.startOffset = startOffset;
      }
    },
    onForceRefresh: (forceRefresh: number) => {
      if (this.forceRefresh !== forceRefresh) {
        this.forceRefresh = forceRefresh;
      }
    },
    onOpacityValue: (opacityValue: number) => {
      if (this.opacityValue !== opacityValue) {
        this.opacityValue = opacityValue;
      }
    },
    onPreviewProgressOffsetChanged: (previewProgressOffset: number) => {
      if (this.previewProgressOffset !== previewProgressOffset) {
        this.previewProgressOffset = previewProgressOffset;
      }
    },
    onDoDeleteAnimChanged: (isDoDeleteAnim: boolean) => {
      if (this.isDoDeleteAnim !== isDoDeleteAnim) {
        this.isDoDeleteAnim = isDoDeleteAnim;
      }
    },
    onIsDeletingChanged: (isDeleting: boolean) => {
      if (this.isDeleting !== isDeleting) {
        this.isDeleting = isDeleting;
      }
    },
    onScrollSnapChanged: (scrollSnap: ScrollSnapAlign) => {
      if (this.scrollSnap !== scrollSnap) {
        this.scrollSnap = scrollSnap;
      }
    },
    onListEdgeEffectChanged: (listEdgeEffect: EdgeEffect) => {
      if (this.listEdgeEffect !== listEdgeEffect) {
        this.listEdgeEffect = listEdgeEffect;
      }
    },
    onIsPositiveSlidingChanged:(isPositiveSliding: boolean) => {
      if (this.isPositiveSliding !== isPositiveSliding) {
        this.isPositiveSliding = isPositiveSliding;
      }
    },
    onIsVideoToEndChanged:(isVideoToEnd: boolean) => {
      if (this.isVideoToEnd !== isVideoToEnd) {
        this.isVideoToEnd = isVideoToEnd;
      }
    },
    onIsShowVideoChanged:(isShowVideo: boolean) => {
      if (this.isShowVideo !== isShowVideo) {
        this.isShowVideo = isShowVideo;
      }
    },
    onVideoPlayChanged:(isVideoPlaying: boolean) => {
      if (this.isVideoPlaying !== isVideoPlaying) {
        this.isVideoPlaying = isVideoPlaying;
      }
    },
    onCurrentDeleteIDChanged:(currentDeleteID: string) => {
      if (this.currentDeleteID !== currentDeleteID) {
        this.currentDeleteID = currentDeleteID;
      }
    },
    onAnalyzerVisibilityChanged:(analyzerVisibility: Visibility) => {
      if (this.analyzerVisibility !== analyzerVisibility) {
        this.analyzerVisibility = analyzerVisibility;
      }
    },
    onIsLcdCompleteChanged:(isLcdComplete: boolean) => {
      if (this.isLcdComplete !== isLcdComplete) {
        this.isLcdComplete = isLcdComplete;
      }
    },
    onIsScrollingChanged:(isScrolling: boolean) => {
      if (this.isScrolling !== isScrolling) {
        this.isScrolling = isScrolling;
      }
    },
    onPreviewBarAnimationChanged:(isPreviewBarAnimation: boolean) => {
      if (this.isPreviewBarAnimation !== isPreviewBarAnimation) {
        this.isPreviewBarAnimation = isPreviewBarAnimation;
      }
    },
    onRunningAnimationChanged:(isRunningAnimation: boolean) => {
      if (this.isRunningAnimation !== isRunningAnimation) {
        this.isRunningAnimation = isRunningAnimation;
      }
    },
    onInSwiperAnimationChanged:(isInSwiperAnimation: boolean) => {
      if (this.isInSwiperAnimation !== isInSwiperAnimation) {
        this.isInSwiperAnimation = isInSwiperAnimation;
      }
    },
    onAnchorDirectionChanged:(anchorDirection: AnchorDirection) => {
      if (this.anchorDirection !== anchorDirection) {
        this.anchorDirection = anchorDirection;
      }
    },
    onFrameOpenAniChanged:(isFrameOpenAni: boolean) => {
      if (this.isFrameOpenAni !== isFrameOpenAni) {
        this.isFrameOpenAni = isFrameOpenAni;
      }
    },
    onSwiperAnimationChange:(isSwiperOffsetZero: boolean) => {
      if (this.isSwiperOffsetZero !== isSwiperOffsetZero) {
        this.isSwiperOffsetZero = isSwiperOffsetZero;
      }
    },
    onChangeSwiperDirection:(swiperDirection: number) => {
      if (this.swiperDirection !== swiperDirection) {
        this.swiperDirection = swiperDirection;
      }
    },
    onDoingImageSlideAnimation:(isDoingImageSlideAnimation: boolean) => {
      if (this.isDoingImageSlideAnimation !== isDoingImageSlideAnimation) {
        this.isDoingImageSlideAnimation = isDoingImageSlideAnimation;
      }
    },
    onPullDownAndDragPhoto:(isPullDownAndDragPhoto: boolean) => {
      if (this.isPullDownAndDragPhoto !== isPullDownAndDragPhoto) {
        this.isPullDownAndDragPhoto = isPullDownAndDragPhoto;
      }
    },
    onInAnimateToPosition:(isInAnimateToPosition: boolean) => {
      if (this.isInAnimateToPosition !== isInAnimateToPosition) {
        this.isInAnimateToPosition = isInAnimateToPosition;
      }
    },
    onHistogramNextItemChanged:(histogramNextItem: MediaItem) => {
      if (this.histogramNextItem !== histogramNextItem) {
        this.histogramNextItem = histogramNextItem;
      }
    },
    onIsPullingUpChanged:(isPullingUp: boolean) => {
      if (this.isPullingUp !== isPullingUp) {
        this.isPullingUp = isPullingUp;
      }
    },
    onPcCurItemChanged: (pcCurItem: MediaItem) => {
      if (this.pcCurItem !== pcCurItem) {
        this.pcCurItem = pcCurItem;
      }
    },
    onImagePaddingChanged: (imagePadding: Padding | Length | LocalizedPadding) => {
      if (this.imagePadding !== imagePadding) {
        this.imagePadding = imagePadding;
      }
    },
    onVideoCoverFrameChanged: (videoCoverFrame: PixelMap[]) => {
      if (this.videoCoverFrame !== videoCoverFrame) {
        this.videoCoverFrame = videoCoverFrame;
      }
    },
  }

  updateDataSourceMarginAndWidth() {
    this.viewModel.updateAttribute('centerIndex', this.centerIndex);
    this.viewModel.updateAttribute('shrinkFactor', this.shrinkFactor);
    this.viewModel.updateAttribute('targetOffset', this.targetOffset);
    this.viewModel.updateAttribute('curBigOffset', this.curBigOffset);
    this.viewModel.updateAttribute('forceRefresh', this.forceRefresh);
    this.viewModel.updateDataSourceMarginAndWidth();
  }

  onFrameExpand(): void {
    this.viewModel.updateAttribute('isFrameExpand', this.isFrameExpand);
    this.viewModel.isFrameExpandChanged();
  }

  onStartOffset(): void {
    this.viewModel.updateAttribute('startOffset', this.startOffset);
  }

  opacityValueChanged(): void {
    Log.info(TAG, `opacityValueChanged ${this.opacityValue}`);
    this.viewModel.updateAttribute('opacityValue', this.opacityValue);
  }

  onPreviewProgressOffsetChanged(): void {
    this.viewModel.updateAttribute('previewProgressOffset', this.previewProgressOffset);
  }

  onDoDeleteAnimChanged(): void {
    this.viewModel.updateAttribute('isDoDeleteAnim', this.isDoDeleteAnim);
  }

  onIsDeletingChanged(): void {
    this.viewModel.updateAttribute('isDeleting', this.isDeleting);
  }

  onScrollSnapChanged(): void {
    this.viewModel.updateAttribute('scrollSnap', this.scrollSnap);
  }

  onListEdgeEffectChanged(): void {
    this.viewModel.updateAttribute('listEdgeEffect', this.listEdgeEffect);
  }

  onIsPositiveSlidingChanged(): void {
    this.viewModel.updateAttribute('isPositiveSliding', this.isPositiveSliding);
  }

  onIsVideoToEndChanged(): void {
    this.viewModel.updateAttribute('isVideoToEnd', this.isVideoToEnd);
  }

  onIsShowVideoChanged(): void {
    this.viewModel.updateAttribute('isShowVideo', this.isShowVideo);
  }

  onShowChanged(): void {
    this.viewModel.onShowBarChanged(this.isShowBar);
  }

  onSlideBarShowChanged(): void {
    this.viewModel.isSlideBarShow = this.isSlideBarShow;
  }

  onPcShowingEditorChanged(): void {
    this.viewModel.onPcShowingEditorChanged(this.isPcShowingEditor);
  }

  onVideoPlayChange(): void {
    this.viewModel.updateAttribute('isVideoPlaying', this.isVideoPlaying);
    this.viewModel.updateVideoPlayState();
  }

  onCurrentDeleteIDChanged(): void {
    this.viewModel.updateAttribute('currentDeleteID', this.currentDeleteID);
  }

  onIsEditorShownChange(): void {
    this.viewModel.isEditorShown = this.isEditorShown;
    this.viewModel.onEditorShownChange();
  }

  onAnalyzerVisibilityChanged(): void {
    this.viewModel.updateAttribute('analyzerVisibility', this.analyzerVisibility);
  }

  onIsLcdCompleteChanged(): void {
    this.viewModel.updateAttribute('isLcdComplete', this.isLcdComplete);
  }

  onIsScrollingChanged(): void {
    this.viewModel.updateAttribute('isScrolling', this.isScrolling);
  }

  onSwiperAnimationChange(): void {
    this.appBroadCast.emit(BroadCastConstants.ON_SWIPER_ANIMATION_CHANGE, [this.isSwiperOffsetZero]);
    this.viewModel.updateAttribute('isSwiperOffsetZero', this.isSwiperOffsetZero);
  }

  onPreviewBarAnimationChanged(): void {
    this.viewModel.updateAttribute('isPreviewBarAnimation', this.isPreviewBarAnimation);
  }

  onRunningAnimationChanged(): void {
    this.viewModel.updateAttribute('isRunningAnimation', this.isRunningAnimation);
  }

  onInSwiperAnimationChanged(): void {
    this.viewModel.updateAttribute('isInSwiperAnimation', this.isInSwiperAnimation);
  }

  onAnchorDirectionChanged(): void {
    this.viewModel.updateAttribute('anchorDirection', this.anchorDirection);
  }

  onFrameOpenAniChanged(): void {
    this.viewModel.updateAttribute('isFrameOpenAni', this.isFrameOpenAni);
  }


  onChangeSwiperDirection(): void {
    Log.info(TAG, `onChangeSwiperDirection ${this.swiperDirection}`);
    if (this.swiperDirection === SwiperDirection.DEFAULT) {
      return;
    } else if (this.swiperDirection === SwiperDirection.LEFT) {
      this.nextItem =
        this.browserController.dataSource?.getDataWithoutCache(this.viewModel.getCurrentIndex() + 1)?.item;
    } else {
      this.nextItem =
        this.browserController.dataSource?.getDataWithoutCache(this.viewModel.getCurrentIndex() - 1)?.item;
    }
    if (this.nextItem) {
      this.histogramNextItem = this.nextItem;
    }
    this.viewModel.updateAttribute('swiperDirection', this.swiperDirection);
  }

  onDoingImageSlideAnimation(): void {
    this.viewModel.updateAttribute('isDoingImageSlideAnimation', this.isDoingImageSlideAnimation);
  }

  onPullDownAndDragPhoto(): void {
    this.viewModel.updateAttribute('isPullDownAndDragPhoto', this.isPullDownAndDragPhoto);
  }

  onInAnimateToPosition(): void {
    this.viewModel.updateAttribute('isInAnimateToPosition', this.isInAnimateToPosition);
  }

  onHistogramNextItemChanged(): void {
    this.viewModel.updateAttribute('histogramNextItem', this.histogramNextItem);
  }

  onIsPullingUpChanged(): void {
    this.viewModel.updateAttribute('isPullingUp', this.isPullingUp);
  }

  private onPhotoSingleClick: Function = (): void => {
  };
  private geoIdMgr: GeometryIdManager = {
    canSetNewId: () => {
      return true;
    }
  }

  /**
   * 图片 GeometryTransitionId 变化处理回调
   */
  onGeometryIdChange(): void {
    Log.info(TAG, `onGeometryIdChange geometryTransitionId: ${this.geometryTransitionId}`);
    this.browserController.onGeometryIdChange(this.geometryTransitionId);
  }

  private shouldDisableSwipe(): boolean {
    return !this.stateMachine.processSwiperGestureAllowanceEvent() || this.isDoDeleteAnim ||
    this.disableSwipe || (this.browserController.browserAnimController.isTransitionEnable && this.isRunningAnimation)
  }

  aboutToAppear() {
    if (!this.isThirdScene && DeviceInfo.isPc()) {
      this.viewModel = new SwiperHmVM(this.stateMachine);
    }
    if (this.browserController.uiContext === undefined) {
      this.browserController.uiContext = this.getUIContext();
    }
    this.viewModel.setThumbnailViewShow = this.setThumbnailViewShow;
    this.thumbnailShow = this.browserController.browserAnimController.isTransitionEnable;
    this.viewModel.browserController = this.browserController;
    this.viewModel.uiContext = this.getUIContext();
    this.viewModel.broadCast = this.broadCast;
    this.viewModel.smallScroller = this.smallScroller;
    this.viewModel.isShowBar = this.isShowBar;
    this.viewModel.isSlideBarShow = this.isSlideBarShow;
    this.viewModel.isPcShowingEditor = this.isPcShowingEditor;
    this.viewModel.setForceRefresh(this.forceRefresh);
    this.viewModel.onPhotoChanged = this.onPhotoChanged;
    this.viewModel.onDataPrepare = this.onDataPrepare;
    this.viewModel.onIndexChanged = this.onIndexChanged;
    this.viewModel.thumbSource = this.thumbSource;
    this.viewModel.setIsDeleting(this.isDeleting);
    this.viewModel.setIsDoDeleteAnim(this.isDoDeleteAnim);
    this.viewModel.isFromFACard = this.isFromFACard;
    this.viewModel.setIsShowVideo(this.isShowVideo);
    this.viewModel.setIsVideoPlaying(this.isVideoPlaying);
    this.viewModel.videoCoverFrame = this.videoCoverFrame;
    this.viewModel.isShowThumbSource = this.isShowThumbSource;
    this.viewModel.isInSelectedMode = this.isInSelectedMode;
    this.viewModel.isFromPortraitCoverSet = this.isFromPortraitCoverSet;
    this.viewModel.swiperController = this.swiperController;
    this.viewModel.pcCurItem = this.pcCurItem;
    this.viewModel.imageList = this.imageList;
    this.viewModel.registerStateListener(this.swiperStateListener);
    this.viewModel.onCreate(this.browserController.browserAnimController);
  }

  aboutToDisappear() {
    this.viewModel.unRegisterStateListener();
    this.viewModel.onDestroy();
  }

  private getFlushVisibility(): Visibility {
    if (!this.viewModel.isShowFlushImage) {
      return Visibility.None;
    }
    if (this.isEditorShown) {
      return Visibility.None;
    }
    return Visibility.Visible;
  }

  build() {
    Stack() {
      if (this.isThumbnailViewShow && this.isThumbnailViewReAdapt) {
        ThumbnailView({
          stateMachine: this.stateMachine,
          thumbnailShow: this.thumbnailShow,
          isRunningAnimation: this.isRunningAnimation
        })
      }
      this.buildSwiper();
    }
    .onAreaChange((oldValue: Area, newValue: Area) => {
      if (typeof newValue.width === 'number' && typeof newValue.height === 'number' &&
      Number.isFinite(newValue.width) && Number.isFinite(newValue.height) &&
        typeof oldValue.width === 'number' && Number.isFinite(oldValue.width)) {
        this.viewModel.windowLayoutWidth = newValue.width;
        this.viewModel.windowLayoutHeight = newValue.height;
        Log.info(TAG, `onAreaChange, windowLayoutWidth：${vp2px(this.viewModel.windowLayoutWidth)}
         windowLayoutHeight:${vp2px(this.viewModel.windowLayoutHeight)}`)
        this.viewModel.listScrollSwiperAreaChange(oldValue.width, newValue.width);

        setTimeout(()=>{
          this.viewModel.videoProgressCalibration();
        },BrowserConstants.PROGRESS_CALIBRATION_DELAY);
      } else {
        Log.error(TAG, `onAreaChange, newValue width type: ${typeof newValue.width}, newValue height type: ${typeof newValue.height}`);
      }
    })
  }

  @Builder
  buildSwiper() {
    Stack({ alignContent: Alignment.Bottom }) {
      Stack() {
        Swiper(this.swiperController) {
          LazyForEach(this.browserController.dataSource, (result: MediaResult, index?: number): void => {
            if (result) {
              PhotoItem({
                photoBrowserStateMachine: this.stateMachine,
                browserAnimController: this.browserController.browserAnimController,
                mediaResult: result,
                transitionTag: this.mTransition ? this.mTransition : 'default_id',
                verifyPhotoScaled: this.verifyPhotoScaledFunc,
                albumUri: this.browserController.getAlbumUri(),
                albumInfo: this.browserController.getAlbumInfo(),
                canPullingUp: this.canPullingUp,
                geometryTransitionEnable: this.geometryTransitionEnable,
                broadCast: this.broadCast,
                isRunningAnimation: $isRunningAnimation,
                isFromFACard: this.viewModel.isFromFACard,
                isInSelectedMode: this.viewModel.isInSelectedMode,
                dataSource: this.browserController.dataSource,
                isDoingDeleteAnim: $isDoingDeleteAnim,
                isLeftToRightAnim: $isLeftToRightAnim,
                isPreviewListScrolling: $isScrolling,
                isShowImageAnalyzer: this.isShowImageAnalyzer,
                isPcCameraPull: this.isPcCameraPull,
                swiperController: this.swiperController,
                imageIndex: index,
                imageList: this.imageList,
                isPcPictureScene: this.isPcPictureScene,
                isDetailSelected: this.browserController.isDetailSelected,
                isPrivateHideState: this.isPrivateHideState,
                onLargePhotoComplete: () => {
                  if (index !== undefined && index === this.viewModel.getCurrentIndex() && result.isShowThumbnail) {
                    this.browserController.updateActionBar(index)
                  }
                  this.browserController.removeCachedThumbnail(result.item);
                },

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
                isVideoToEnd: this.isVideoToEnd,
                videoCoverFrame: this.videoCoverFrame,
                isFrameExpand: this.isFrameExpand,
                isNeedRightMenu: true,
                isVideoPlaying: this.isVideoPlaying,
                geoIdMgr: this.geoIdMgr,
                onPhotoSingleClick: this.onPhotoSingleClick,
                curHiSearchWords: this.curHiSearchWords,
                isUserCreatedAlbum: this.isUserCreatedAlbum,
                isSelected: (): boolean => this.isSelected(),
                selectStateChange: (): void => this.selectStateChange(),
                changeMoreMenuList: (array: Action[], index: number): void => this.changeMoreMenuList(array, index),
                isThirdScene: this.isThirdScene,
              })
                .opacity(this.swiperOpacityWithBurstPhotos)
                .zIndex((result.item?.uniqueId === this.currentDeleteID) ?
                BrowserConstants.DELETE_LOW_INDEX : BrowserConstants.DELETE_HIGH_INDEX)
            }
          }, (result: MediaResult, index?: number): string => {
            if (result === null || result === undefined) {
              return JSON.stringify(result) + index;
            }
            if (result.item && index === this.viewModel.getCurrentIndex()) {
              this.viewModel.curItem = result.item;
              this.isSlideBarShow = this.viewModel.isSlideBarVisibility();

              if (DeviceInfo.isPc()) {
                this.viewModel.getPCImageCompleteValue();
              }
            }
            if (result.captureId) {
              return result.captureId;
            } else {
              return `${result.item?.path}`;
            }
          })
        }
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
        .attributeModifier(this.viewModel.swiperModifier)
        .cachedCount(this.SWIPE_CACHE_COUNT)
        .duration(Swipes.MAIN_SWIPE_DURATION)
        .curve(Swipes.INTERPOLATING_CURVE)
        .itemSpace(this.swiperItemSpace)
        .index(this.viewModel.getCurrentIndex())
        .indicator(false)
        .loop(false)
        .onChange((index: number): void => {
          const isInFastScrollMode: boolean = this.fastScrollChecker.recordScrollAndCheck();
          Log.info(TAG, `isInFastScrollMode:${isInFastScrollMode}`);
          AppStorage.setOrCreate(Constants.APP_STORAGE_KEY_IS_IN_FAST_MODE, isInFastScrollMode);
          this.viewModel.onSwiperChange(index, this.isInSwiperAnimation, this.verifyPhotoScaledFunc);
        })
        .disableSwipe(this.shouldDisableSwipe())
        .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent): void => {
          Log.info(TAG, 'swiper onGestureSwipe index: ' + index + `currentIndex : ${this.viewModel.getCurrentIndex()}`);
          // 只要手势滑动图片，就保存图片备注信息
          this.viewModel.onGestureSwipe(index, extraInfo);
        })
        .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent): void => {
          Log.info(TAG, 'onAnimationStart ' + index + ` ${targetIndex}`);
          this.viewModel.onAnimationStart(index, targetIndex, extraInfo);
        })
        .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent): void => {
          Log.info(TAG, 'swiper onAnimationEnd');
          this.viewModel.onAnimationEnd(index, extraInfo);
        })
        .onKeyEvent((event: KeyEvent): void => {
          Log.info(TAG, `photoSwiper onKeyEvent:${event.keyCode}`);
          if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_ENTER) {
            this.showEditor(this.viewModel.curItem);
          }

          if (KeyType.Down === event.type) {
            if (event.keyCode === MultimodalInputManager.KEY_CODE_PAGE_UP) {
              this.swiperController?.showPrevious();
            } else if (event.keyCode === MultimodalInputManager.KEY_CODE_PAGE_DOWN) {
              this.swiperController?.showNext();
            }
          }
        })

        ImageFlushItem({
          broadCast: this.broadCast,
          isScrolling: $isScrolling,
          isLcdComplete: $isLcdComplete,
        })
          .hitTestBehavior(HitTestMode.Transparent)
          .visibility(this.getFlushVisibility())
          .onTouch(event => {
            if (event.type == TouchType.Down) {
              this.isScrolling = false;
              this.browserController.setCurrentIndex(this.centerIndex);
              this.smallScroller.scrollToIndex(this.centerIndex, false, ScrollAlign.CENTER);
            }
          })
      }
      .padding(this.imagePadding)
      .opacity(this.photoSwiperOpacity)
      .id('Swiper-PhotoItem')

      // 大图组件的pc和手机的图片下面的浏览条
      if (this.browserController.isBrowserShowContent && !this.isFromPortraitCoverSet &&
        this.viewModel.shouldShowPreview() &&
        this.viewModel.isShowThumbSource && this.showPreviewer() && this.viewModel.isThumbsourceLoadFinished) {
        PhotoPreviewer({
          browserController: this.browserController,
          stateMachine: this.stateMachine,
          viewModel: this.viewModel,
          curItem: this.viewModel.curItem,
          broadCast: this.broadCast,
          timeCapsuleRawTime: this.timeCapsuleRawTime,
          isFrameExpand: this.isFrameExpand,
          isShowBar: this.isShowBar,
          isVideoPlaying: this.isVideoPlaying,
          shrinkFactor: this.shrinkFactor,
          targetOffset: this.targetOffset,
          curBigOffset: this.curBigOffset,
          startOffset: this.startOffset,
          expectedProgressRawTime: this.expectedProgressRawTime,
          waitingForTimeSync: this.waitingForTimeSync,
          videoCoverFrame: this.videoCoverFrame,
          centerIndex: this.centerIndex,
          startTouchIndex: this.startTouchIndex,
          forceRefresh: this.forceRefresh,
          isFrameOpenAni: this.isFrameOpenAni,
          isSlideBarShow: this.isSlideBarShow,
          scrollSnap: this.scrollSnap,
          listEdgeEffect: this.listEdgeEffect,
          isEditorShown: this.isEditorShown,
          isScrolling: this.isScrolling,
          isVideoToEnd: this.isVideoToEnd,
          isRunningAnimation: this.isRunningAnimation,
          anchorDirection: this.anchorDirection,
          centerPreviewOpacity: this.centerPreviewOpacity,
          previewItemOpacity: this.previewItemOpacity,
          isLcdComplete: this.isLcdComplete,
          isPositiveSliding: this.isPositiveSliding,
          isPreviewBarAnimation: this.isPreviewBarAnimation,
          showEditor: this.showEditorFunc,
          thumbSource: this.thumbSource,
          smallScroller: this.smallScroller,
          videoPlayController: this.viewModel.videoPlayController,
          swiperController: this.swiperController,
          opacityValue: this.opacityValue,
          previewProgressOffset: this.previewProgressOffset
        })
      }
    }
    .id(TAG)
    .padding({bottom:30})
    .width(Constants.FULL_PERCENT)
    .height(Constants.FULL_PERCENT)
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
        }, DeviceInfo.isGRLFullExpanded() ? TABLET_PREVIEWER_DELAY_TIME * 2 : TABLET_PREVIEWER_DELAY_TIME);
      }
      return this.tabletShowPreviewer;
    }
  }
}
