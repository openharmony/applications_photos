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

import lazy Curves from '@ohos.curves';
import lazy Matrix4 from '@ohos.matrix4';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { MediaResult } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaResult';
import lazy { PhotoItem } from '@ohos/browsercommon/src/main/ets/default/view/PhotoItem';
import lazy { getScreen, ScreenManager } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy Swipes, { SwiperDirection } from '@ohos/common/src/main/ets/default/view/Swipes';
import lazy animator, { AnimatorOptions, AnimatorResult } from '@ohos.animator';
import lazy { ShareBrowserCustomDialog } from './dialog/ShareBrowserCustomDialog';
import lazy { AnimationSet } from './AnimationSet';
import lazy { AnimSpecifications } from './AnimSpecifications';
import lazy { BrowserCostReportManager } from '@ohos/browsercommon/src/main/ets/default/utils/BrowserCostReportManager';
import lazy { BrowserStatisticReportManager } from '@ohos/common/src/main/ets/default/utils/StatisticReportUtil';
import lazy { PCImageInfo } from '@ohos/browsercommon/src/main/ets/default/view/PCImageInfo';
import lazy { PhotosHmBrowserController } from '../Index';
import lazy { SubScreenSwiperVM } from '../model/SubScreenSwiperVM';
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import { ThumbDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/ThumbDataSource';

const SCROLL_ANIMATION_DURATION: number = 100;
const SCROLL_MAX_FLING_SPEED: number = 1000;

const MOUSE_LIMIT_MAX: number = 10;
const MOUSE_LIMIT_MIN: number = -10;
const TAG: string = 'SubScreenSwiperView';
const PHOTO_ACTION: string = 'ability.params.backToOtherMissionStack';
const PHOTO_BUNDLE_NAME: string = 'com.ohos.photos';
const PHOTO_ABILITY_NAME: string = 'com.ohos.photos.MainAbility';

/**
 * 大图页组件，供 PC 使用
 */
@Component
export struct SubScreenSwiperView {
  @Provide({ allowOverride: 'navigationPageInfos' }) private navPageInfos: NavPathStack = new NavPathStack();
  @ObjectLink stateMachine: PhotoBrowserStateMachine;
  /**
   * 大图组件控制器
   */
  @Consume browserController: PhotosHmBrowserController;
  /**
   * 大图一镜到底动效绑定 ID
   */
  @LocalStorageLink('geometryTransitionBrowserId') @Watch('onGeometryIdChange') geometryTransitionId: string = '';
  /**
   * 转场动效使用标记ID
   */
  public mTransition: string = '';
  /**
   * 广播，用于保存关键回调
   */
  @State broadCast: BroadCast | undefined = undefined;
  /**
   * Swiper 切图动画时长
   */
  @State mDuration: number = 300;
  /**
   * 图片容器 Swiper 使用的控制器，控制水平切换图片
   */
  public swiperController: SwiperController = new SwiperController();
  /**
   * 标记是否为选择模式
   */
  public isInSelectedMode: boolean = false;
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
   * 标志当前是否正在执行一镜到底动效
   */
  @Link isRunningAnimation: boolean;
  /**
   * 标志当前是否正在支持下拉图片，执行下拉跟手动效
   */
  @Link isPullDownAndDragPhoto: boolean;
  public isLeftSwiper: boolean = false;
  /**
   * 标志是否正在执行删除动画动效
   */
  @Consume isDeleting: boolean;
  /**
   * 标志当前是否支持一镜到底动效
   */
  private geometryTransitionEnable: boolean = false;
  /**
   * 标志当前页面是否是由 FA 卡片拉起
   */
  private isFromFACard: boolean = false;
  /**
   * swiper缓存的item的个数
   */
  private SWIPE_CACHE_COUNT: number = 1;
  @Provide histogramNextItem: MediaItem = new MediaItem();
  /**
   * 标志当前是否正在执行删除动效
   */
  @StorageLink('isDoingDeleteBigPhotoAnim') isDoingDeleteAnim: boolean = false;
  @StorageLink('isBigPhotoLeftToRightAnim') isLeftToRightAnim: boolean = false;
  @State currentDeleteID: string = '';
  private currentDeleteIDFunc: Function = (uniqueId: string): void => this.currentDeleteIDChange(uniqueId);
  /**
   * 当前图片 uri 信息
   */
  private currentUri: string = '';
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
   * Swiper 组件所展示的当前媒体类型
   */
  @State curItemMediaType: number = 0;
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
  @State isSliderBarOnHover: boolean = true;
  private hoverTimer: number = Number.NaN;
  private onDataReloadFunc: Function = (addCount: number): void => this.onDataReload(addCount);
  private onChangeSwiperDurationFunc: Function = (value: number): void => this.onChangeSwiperDuration(value);
  /**
   * 应用级广播，保存关键监听回调
   */
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private thumbSource: ThumbDataSource | undefined = undefined;
  @State private isShowThumbSource: boolean = true;
  @Consume isShowVideo: boolean;
  /**
   * 数据源是否是沙箱数据
   */
  public isShowImageAnalyzer: boolean = true;
  @Link @Watch('onShowChanged') isShowBar: boolean;
  private smallScroller: Scroller = new Scroller();
  @State deviceWidth: number = Constants.DEFAULT_WIDTH;
  private readonly smallImgLow: number = 18;
  private readonly smallImgHeight: number = 36;
  private itemWidth: number = this.smallImgLow + Constants.LIST_ITEM_SPACE;
  private isTouching: boolean = false;
  @State shrinkFactor: number = 1.0;
  private viewModel: SubScreenSwiperVM = new SubScreenSwiperVM(this.stateMachine);
  // 当前index
  @State centerIndex: number = this.viewModel.getCurrentIndex();
  @State curBigOffset: number = 0;
  private startTouchIndex: number = this.viewModel.getCurrentIndex();
  private endTouchIndex: number = this.viewModel.getCurrentIndex();
  private sliderBarDividerWidth: number = 1;
  private widthScale: number = 0.5;
  private isPositiveSliding: boolean = true;
  @State isScrolling: boolean = false;
  @State isImageAnalyzePaused: boolean = false;
  private tempIndex: number = Number.NaN;
  @Prop forceRefresh: number = 0;
  @Prop isEditorShown: boolean = false;
  @State isLeftMouseButtonPress: boolean = false;
  @State mousePositionX: number = Number.NaN;
  @Prop isPhotoScaled: boolean = false;
  // swiper depth
  @State currentImageWidth: number = 0;
  @State windowLayoutWidth: number = getScreen().getWinLayoutWidth();
  @State windowLayoutHeight: number = getScreen().getWinLayoutHeight();
  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();
  @State nextItem?: MediaItem = new MediaItem();
  @State totalCount: number = 0;
  private nextDisplayedWidth: number = 0;
  @State @Watch('onChangeSwiperDirection') swiperDirection: number = SwiperDirection.DEFAULT;
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  private photoChanged: boolean = false;
  private costReportManager: BrowserCostReportManager = BrowserCostReportManager.getInstance();
  private statisticRptMgr: BrowserStatisticReportManager = new BrowserStatisticReportManager();
  @Prop isShowArrowAnimate: boolean = false;
  @State arrowPositionY: number = 0; // 引导箭头偏移量
  private backAnimator: AnimatorResult | undefined = undefined;
  @StorageLink('isShowDelete') isShowDelete: boolean = false;
  @StorageLink('isLemFold') @Watch('onScreenFold') isLemFold: boolean = false;
  @State enterCount: number = 0;
  @State isFirstShow: boolean = false;
  @LocalStorageLink('isDeleteDialogOpen') isDeleteDialogOpen: boolean = false;
  @State iconOpacity: number = 0;
  @State transitionY: number = 0;
  private readonly SLIDE_MOVE_LENGTH = 4;
  private animationSet: AnimationSet = new AnimationSet();
  /**
   * 逐帧播放：展开前展示两帧视频封面；点击扩展的逐帧抽取，未获取时先用首帧占位
   */
  @State videoCoverFrame: PixelMap[] = []
  /**
   * 逐帧播放：是否为xxx标志变量
   */
  @State isFrameExpand: boolean = false;
  @Prop private isQuitPhotoBrowser: boolean;
  @State @Watch('onSwiperAnimationChange') isSwiperOffsetZero: boolean = true;
  // pc用
  @State imageList: PCImageInfo[] = [];

  private onSwiperAnimationChange(): void {
    this.appBroadCast.emit(BroadCastConstants.ON_SWIPER_ANIMATION_CHANGE, [this.isSwiperOffsetZero]);
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
      this.nextDisplayedWidth = px2vp(this.nextItem.getDisplayedWidth());
      this.histogramNextItem = this.nextItem;
    }
  }

  private currentDeleteIDChange(uniqueId: string): void {
    this.currentDeleteID = uniqueId;
  }

  onScreenFold(): void {
    Log.info(TAG, 'onScreenFold');
    this.browserController.routeToPhotoBrowser(this.isShowVideo);
  }

  private smallScrollerOffset(): number {
    return this.smallScroller.currentOffset()?.xOffset || 0;
  }

  private onWinSizeChanged(): void {
    this.windowLayoutWidth = getScreen().getWinLayoutWidth();
    this.windowLayoutHeight = getScreen().getWinLayoutHeight();
  }

  /**
   * 图片 GeometryTransitionId 变化处理回调
   */
  onGeometryIdChange(): void {
    Log.info(TAG, `onGeometryIdChange geometryTransitionId: ${this.geometryTransitionId}`);
    this.browserController.onGeometryIdChange(this.geometryTransitionId);
  }

  /**
   * 更新 currentIndex，并触发图片数据重新加载
   *
   * @param index 图片 index 信息
   */
  onGetItemIndexByUri(index: number): void {
    Log.info(TAG, `onGetItemIndexByUri: this.currentIndex=${this.viewModel.getCurrentIndex()}, index=${index}`);
    if (index !== Constants.NOT_FOUND) {
      this.viewModel.setCurrentIndex(index);
    }
    this.browserController.dataSource.onDataReloaded();
  }

  private onCurrentIndexChange = () => {
    this.jumpStart();
  }

  aboutToAppear() {
    Log.info(TAG, `aboutToAppear Begin enterCount = ${this.enterCount}, isFirstShow = ${this.isFirstShow}`);
    this.aiButtonVisibility = this.isShowBar;
    // 大图浏览初始化时，浏览大图打点数据重置
    this.costReportManager.resetCostInfo();
    this.statisticRptMgr.init();
    this.broadCast?.on(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadFunc);
    this.broadCast?.on(BroadCastConstants.CHANGE_SWIPER_DURATION, this.onChangeSwiperDurationFunc);
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    if (this.isShowThumbSource) {
      this.isShowThumbSource = false;
      setTimeout((): void => {
        this.isShowThumbSource = true;
      }, Swipes.THUMB_SOURCE_DELAY_TIME);
    }
    this.appBroadCast.on(BroadCastConstants.CURRENT_DELETE_UNIQUEID, this.currentDeleteIDFunc);
    this.initAnimation();
    if (this.enterCount > 1 && this.enterCount < 4) {
      this.animationSet.play();
    }
    this.viewModel.onCreate(this.browserController, this.onCurrentIndexChange);
    Log.info(TAG, 'aboutToAppear End');
  }

  aboutToDisappear() {
    this.costReportManager.report();
    // 大图浏览结束时，浏览大图打点数据重置
    this.costReportManager.resetCostInfo();
    this.statisticRptMgr.end();
    this.isLeftToRightAnim = false;
    this.broadCast?.off(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadFunc);
    this.broadCast?.off(BroadCastConstants.CHANGE_SWIPER_DURATION, this.onChangeSwiperDurationFunc);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    this.appBroadCast.off(BroadCastConstants.CURRENT_DELETE_UNIQUEID, this.currentDeleteIDFunc);
    this.isDeleteDialogOpen = false;
    this.viewModel.onDestroy();
  }

  build() {
    Stack() {
      this.buildSwiper();
    }
  }

  @Builder
  animationBuilder() {
    Column() {
      Column() {
        Text(`${this.viewModel.getCurrentIndex() + 1}/${this.browserController.dataSource.realTotalCount()}`)
        // Text(`111111111111111111111`)
          .attributeModifier(this.viewModel.textModifier)
          .fontSize(18)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .width('50%')
      }
      .visibility(this.isQuitPhotoBrowser ? Visibility.Hidden : Visibility.Visible)
      .margin({
        top: '12vp',
        bottom: '12vp',
      })

      Image($r('app.media.handle_up'))
        .width(64)
        .height(32)
        .opacity(this.iconOpacity)
        .translate({ y: this.transitionY })
        .align(Alignment.Top)
        .visibility(this.enterCount < 4 ? Visibility.Visible : Visibility.Hidden)
    }.enabled(false)
    .width('100%')
    .height(vp2px(150))
  }

  @LocalStorageLink('geometryOpacity') geometryOpacity: number = 1;
  @State opacityValue: number = 0.95;

  @Builder
  buildSwiper() {
    Stack({ alignContent: Alignment.Center }) {
      Stack() {
        Swiper(this.swiperController) {
          LazyForEach(this.browserController.dataSource, (result: MediaResult, index?: number): void => {
            if (result) {
              Column() {
                PhotoItem({
                  photoBrowserStateMachine: this.stateMachine,
                  browserAnimController: this.browserController.browserAnimController,
                  mediaResult: result,
                  transitionTag: this.mTransition ? this.mTransition : 'default_id',
                  verifyPhotoScaled: this.verifyPhotoScaledFunc,
                  albumUri: this.browserController.dataSource.getAlbumUri(),
                  canPullingUp: this.canPullingUp,
                  geometryTransitionEnable: this.geometryTransitionEnable,
                  broadCast: $broadCast,
                  isRunningAnimation: $isRunningAnimation,
                  isFromFACard: this.isFromFACard,
                  isInSelectedMode: this.isInSelectedMode,
                  isSwiperOffsetZero: this.isSwiperOffsetZero,
                  dataSource: this.browserController.dataSource,
                  isDoingDeleteAnim: $isDoingDeleteAnim,
                  isLeftToRightAnim: $isLeftToRightAnim,
                  isPreviewListScrolling: $isScrolling,
                  isSubScreen: true,
                  isShowImageAnalyzer: false,

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
                  imageList: this.imageList,
                })
                  .clip(DeviceInfo.isPhonePSD() ? true : new Circle({ width: '100%', height: '100%' }))
              }
              .attributeModifier(this.viewModel.columnModifier)
              .zIndex(result.pos === this.viewModel.getCurrentIndex() ? Swipes.ORDER_2 : Swipes.ORDER_1)
              .transition(!this.viewModel.getCurrentIndex() && this.isDoingDeleteAnim ?
              TransitionEffect.asymmetric(
                TransitionEffect.IDENTITY,
                TransitionEffect.OPACITY
                  .animation({ duration: PhotoItem.DELETE_ALPHA_ANIM_DURATION })
              ) :
              TransitionEffect.IDENTITY
              )
            }
          }, (result: MediaResult, index?: number): string => {
            if (result === null || result === undefined) {
              return JSON.stringify(result) + index;
            }
            if (result.item && index === this.viewModel.getCurrentIndex()) {
              this.curItem = result.item;
              this.curItemMediaType = this.curItem.mediaType;
              this.currentUri = this.curItem.uri;
            }
            return `${result.item?.path}`;
          })
        }
        .attributeModifier(this.viewModel.swiperModifier)
        .visibility(this.isQuitPhotoBrowser ? Visibility.Hidden : Visibility.Visible)
        .cachedCount(this.SWIPE_CACHE_COUNT)
        .duration(Swipes.MAIN_SWIPE_DURATION)
        .curve(Swipes.INTERPOLATING_CURVE)
        .itemSpace(this.swiperItemSpace)
        .index(this.viewModel.getCurrentIndex())
        .indicator(false)
        .loop(false)
        .onAnimationStart((index: number): void => {
          Log.info(TAG, `geometryTransitionId updateCurrent ${index}`);
          this.browserController.dataSource?.updateCurrent(index);
          this.viewModel.setCurrentIndex(index);
          this.browserController.onIndexChange(index);
          this.verifyPhotoScaledFunc?.(undefined);
        })
        .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent): void => {
          this.isSwiperOffsetZero = false;
        })
        .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent): void => {
          if (Math.floor(Math.abs(extraInfo.currentOffset)) === 0) {
            this.isSwiperOffsetZero = true;
          }
        })
        .onChange((index: number): void => {
          Log.info(TAG, `swiper onChange index: ${index}`);
          this.costReportManager.switch();
          this.statisticRptMgr.switch();
          this.appBroadCast.emit(BrowserConstants.REQUEST_QUALITY_IMAGE, [index]);
          if (this.viewModel.isPropertiesShow()) {
            interface Msg {
              uri: string;
              type: string;
            }

            let msg: Msg = {
              uri: this.browserController.dataSource.getDataWithoutCache(index)?.item?.uri ?? '',
              type: BigDataConstants.PHOTO_DETAIL_SWIPER,
            }
            ReportToBigDataUtil.report(BigDataConstants.PHOTO_DETAIL_OPEN_COUNT, msg);
          }
          if (this.viewModel.getCurrentIndex() - index === 1) {
            this.isLeftSwiper = true;
          } else if (this.viewModel.getCurrentIndex() - index === -1) {
            this.isLeftSwiper = false;
          }
          if (this.mDuration !== 0 && !this.isScrolling) {
            Log.info(TAG, `geometryTransitionId updateCurrent ${index}`);
            this.browserController.dataSource?.updateCurrent(index);
            this.browserController.onIndexChange(index);
            this.verifyPhotoScaledFunc?.(undefined);
          }
          let curItemResult: MediaResult | undefined = this.browserController.dataSource
            .getDataWithoutCache(this.viewModel.getCurrentIndex());
          if (curItemResult?.item && curItemResult) {
            this.curItem = curItemResult.item;
            this.curItemMediaType = this.curItem.mediaType;
            Log.info(TAG, `onChange mediaType = ${this.curItem.mediaType}`);
            this.currentUri = this.curItem.uri;
          }
          // swiper index变化时立即触发
          if (!this.isScrolling) {
            this.appBroadCast.emit(BroadCastConstants.SWIPER_INDEX_CHANGED, [index]);
          }
        })
        .disableSwipe(this.isDoingDeleteAnim || this.disableSwipe || this.isShowVideo)
        .overlay(this.animationBuilder(), {
          align: Alignment.Top,
          offset: { x: 0, y: 5 },
        })
        .zIndex(-1)
        .width(Constants.FULL_PERCENT)
        .height(Constants.FULL_PERCENT)

        Button({ type: ButtonType.Circle, stateEffect: true }) {
          SymbolGlyph($r('sys.symbol.trash'))
            .width($r('app.float.immersive_compared_photo_view_icon_size'))
            .height($r('app.float.immersive_compared_photo_view_icon_size'))
            .fontSize($r('app.float.immersive_compared_photo_view_icon_size'))
            .align(Alignment.Center)
            .fontColor([$r('app.color.white')])
        }
        .visibility(this.isQuitPhotoBrowser ? Visibility.Hidden : Visibility.Visible)
        .width(40)
        .height(40)
        .margin({
          top: '168vp',
          bottom: DeviceInfo.isPhonePSD() ? '40vp' : '18vp',
        })
        .backgroundColor($r('app.color.immersive_compared_swiper_left_background_color'))
        .onClick((): void => {
          this.browserController.onMenuClicked(Action.DELETE);
          this.isDeleteDialogOpen = true;
        })

        ShareBrowserCustomDialog({ mediaType: this.curItemMediaType })

        Column() {
          Text($r('app.string.pull_down_back_tips_for_sub_display')) {
          }
          .textAlign(TextAlign.Center)
          .width('100%')
          .fontColor('#FFFFFF')
          .fontSize(12)
          .margin({
            top: '45%',
          })
        }
        .key('PhotoBrowserBg')
        .opacity(0.4)
        .width('100%')
        .height('100%')
        .visibility(this.isFirstShow ? Visibility.Visible : Visibility.Hidden)
        .onClick((): void => {
          this.isFirstShow = false;
          this.animationSet.play();
        })
      }
      .width(Constants.FULL_PERCENT)
      .height(Constants.FULL_PERCENT)
    }
  }

  onShowChanged(): void {
    this.aiButtonVisibility = this.isShowBar;
    Log.info(TAG, `onShowChanged this.isShowBar=${this.isShowBar}, this.aiButtonVisibility=${this.aiButtonVisibility}`);
    animateTo({
      duration: BrowserConstants.IMMERSE_ANIM_DURATION,
      delay: 0,
      curve: this.isShowBar ? Curves.cubicBezier(0.6, 0.0, 0.6, 1.0) : Curves.cubicBezier(0.2, 0.0, 0.2, 1.0),
    }, (): void => {
      if (this.isShowBar) {
        this.opacityValue = 0.95;
      } else {
        this.opacityValue = 0;
      }
    })
  }

  private onVisibilityChange(): void {
    this.analyzerVisibility = !this.isDoingImageSlideAnimation && !this.viewModel.isPropertiesShow() &&
      !this.isRunningAnimation && !this.isPullDownAndDragPhoto && this.canShowImageAnalyzer &&
      !this.isInAnimateToPosition && !this.isInSelectedMode ? Visibility.Visible : Visibility.Hidden;
    Log.info(TAG, 'this.analyzerVisibility = ' + this.analyzerVisibility +
      ', this.currentIndex= ' + this.viewModel.getCurrentIndex() +
      ', this.isRunningAnimation = ' + this.isRunningAnimation +
      ', this.isPullDownAndDragPhoto = ' + this.isPullDownAndDragPhoto +
      ', this.isInAnimateToPosition = ' + this.isInAnimateToPosition +
      ', this.canShowImageAnalyzer = ' + this.canShowImageAnalyzer
    );
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

  /**
   * Swiper 数据重新加载回调
   */

  private onDataReload(addCount: number): void {
    if (addCount > 0) {
      if (this.browserController.dataSource != null) {
        this.onGetItemIndexByUri(this.browserController.dataSource.getDataIndexByUri(this.currentUri));
        this.centerIndex = this.viewModel.getCurrentIndex();
      }
      return;
    }
    Log.debug(TAG, 'animate to data reloaded start');
    animateTo({
      duration: PhotoItem.DELETE_PHOTO_ANIM_DURATION + Swipes.DELETE_OFFSET_DURATION, // 删除动画结束回调时长
      curve: Swipes.DELETE_PHOTO_CURVE, // 减速曲线参数
      onFinish: (): void => {
        Log.info(TAG, `isDoingDeleteAnim: ${this.isDoingDeleteAnim}`);
        this.isLeftToRightAnim = false;
        this.isDoingDeleteAnim = false;
        let totalCount = this.browserController.dataSource.totalCount() - 1;
        if (!this.browserController.isSandboxEnv) {
          this.browserController.dataSource.onDataChanged(this.viewModel.getCurrentIndex());
          // 直接更新后两张图片，保证缓存数量足够
          if (this.viewModel.getCurrentIndex() + 1 < totalCount) {
            this.browserController.dataSource.onDataChanged(this.viewModel.getCurrentIndex() + 1);
          }
          if (this.viewModel.getCurrentIndex() + 2 < totalCount) {
            this.browserController.dataSource.onDataChanged(this.viewModel.getCurrentIndex() + 2);
          }
        }
        this.forceRefresh++;
      }
    }, (): void => this.onDeletingAnimateFinishEvent())
  }

  private onDeletingAnimateFinishEvent(): void {
    if (this.isDeleting) {
      this.viewModel.onDeleteStart();
      this.browserController.dataSource.deleteData(this.viewModel.getCurrentIndex());
      // 往左滑 补位
      if (!this.isPositiveSliding) {
        let currentIndex: number = this.viewModel.getCurrentIndex();
        currentIndex = currentIndex <= 0 ? 0 : currentIndex - 1;
        this.viewModel.setCurrentIndex(currentIndex);
        this.smallScroller?.scrollToIndex(this.viewModel.getCurrentIndex(), false, ScrollAlign.CENTER);
      }
      this.forceRefresh++;
      this.currentUri = '';
    }
    if (this.viewModel.getCurrentIndex() === this.browserController.dataSource.totalCount()) {
      const currentIndex: number = this.viewModel.getCurrentIndex();
      this.viewModel.setCurrentIndex(currentIndex - 1);
      let curItemResult: MediaResult | undefined = this.browserController.dataSource
        .getDataWithoutCache(this.viewModel.getCurrentIndex());
      if (curItemResult?.item && curItemResult) {
        this.curItem = curItemResult.item;
        this.curItemMediaType = this.curItem.mediaType;
        this.currentUri = this.curItem.uri;
      }
    }
    this.isDeleting = false;
  }

  jumpStart(): void {
    Log.info(TAG, `jumpStart this.currentIndex ${this.viewModel.getCurrentIndex()}  this.centerIndex ${this.centerIndex}`);
    if (this.viewModel.getCurrentIndex() !== this.centerIndex) {
      this.smallScroller?.scrollToIndex(this.viewModel.getCurrentIndex(), false, ScrollAlign.CENTER);
      this.centerIndex = this.viewModel.getCurrentIndex();
    }
  }

  private initAnimation() {
    let showAnimator = this.createAnimator(AnimSpecifications.ANIM_DURATION_50, AnimSpecifications.ANIM_DELAY_100,
      AnimSpecifications.ALPHA_COMPLETELY_TRANSPARENT, AnimSpecifications.ALPHA_OPAQUE);
    showAnimator.onFrame = progress => {
      this.iconOpacity = progress;
    };

    let downAnimator = this.createAnimator(AnimSpecifications.ANIM_DURATION_350, AnimSpecifications.ANIM_DELAY_50,
      0, this.SLIDE_MOVE_LENGTH);
    downAnimator.onFrame = progress => {
      this.transitionY = progress;
    };


    let upAnimator = this.createAnimator(AnimSpecifications.ANIM_DURATION_350, AnimSpecifications.ANIM_DELAY_50,
      0, -this.SLIDE_MOVE_LENGTH);
    upAnimator.onFrame = progress => {
      this.transitionY = progress;
    };

    let hideAnimator = this.createAnimator(AnimSpecifications.ANIM_DURATION_150, AnimSpecifications.ANIM_DELAY_550,
      AnimSpecifications.ALPHA_OPAQUE, AnimSpecifications.ALPHA_COMPLETELY_TRANSPARENT);
    hideAnimator.onFrame = progress => {
      this.iconOpacity = progress;
    };

    this.animationSet.addAnimation(showAnimator);
    this.animationSet.addAnimation(downAnimator);
    this.animationSet.addAnimation(upAnimator);
    this.animationSet.addAnimation(downAnimator);
    this.animationSet.addAnimation(upAnimator);
    this.animationSet.addAnimation(hideAnimator);
    this.animationSet.setSequent(true);
  }

  private createAnimator(duration: number, delay: number, begin: number, end: number): AnimatorResult {
    let options: AnimatorOptions = {
      duration: duration,
      easing: 'friction',
      delay: delay,
      fill: 'forwards',
      direction: 'normal',
      iterations: 1,
      begin: begin,
      end: end,
    };
    return animator.create(options);
  }
}