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

import lazy {
  IStateChangeListener
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/IPhotoBrowserState';
import lazy {
  BaseAttributeUpdater
} from '@ohos/browsercommon/src/main/ets/default/viewModel/base/BaseAttributeUpdater';
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import lazy Matrix4 from '@ohos.matrix4';
import lazy { AttributeUpdater } from '@kit.ArkUI';
import lazy window from '@ohos.window';
import lazy { BrowserAnimController } from '@ohos/common/src/main/ets/default/model/BrowserAnimController';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { BasePhotoBrowserController } from './BasePhotoBrowserController';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BrowserCostReportManager } from '@ohos/browsercommon/src/main/ets/default/utils/BrowserCostReportManager';
import lazy { getScreen,
  isOrientationHorizontal,
  ScreenManager } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { ThumbDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/ThumbDataSource';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { AttributeStateManager } from '@ohos/common/src/main/ets/default/model/AttributeStateManager';
import lazy { AvPlayConstants } from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { PhotoItem } from '@ohos/browsercommon/src/main/ets/default/view/PhotoItem';
import lazy Swipes, { SwiperDirection } from '@ohos/common/src/main/ets/default/view/Swipes';
import lazy { VideoPlayController } from '@ohos/browsercommon/src/main/ets/default/controller/VideoPlayController';
import lazy { media } from '@kit.MediaKit';
import lazy { WindowMode } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy Curves from '@ohos.curves';
import lazy { i18n } from '@kit.LocalizationKit';
import lazy Global from '@ohos/common/src/main/ets/default/utils/GlobalContext';
import lazy { Heic2JPGManagerAccess } from '@ohos/common/src/main/ets/default/access/Heic2JPGManagerAccess';
import lazy { BigDataConstants, CountMsg,
  ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { BrowserStatisticReportManager } from '@ohos/common/src/main/ets/default/utils/StatisticReportUtil';
import lazy { MediaResult } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaResult';
import lazy { AnchorDirection } from '../view/SwiperView';
import lazy { PCImageInfo } from '@ohos/browsercommon/src/main/ets/default/view/PCImageInfo';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy { FAST_SCROLL_INTERVAL_MS } from '@ohos/browsercommon/src/main/ets/default/utils/FastScrollChecker';

/**
 * 翻页组件状态控制器
 */
export interface SwiperStateListener {
  onCenterIndex?: (centerIndex: number) => void;
  onTimeCapsuleRawTimeChange?: (timeCapsuleRawTime: number) => void;
  onShrinkFactor?: (shrinkFactor: number) => void;
  onTargetOffset?: (targetOffset: number) => void;
  onCurBigOffset?: (curBigOffset: number) => void;
  onIsFrameExpand?: (isFrameExpand: boolean) => void;
  onStartOffset?: (startOffset: number) => void;
  onForceRefresh?: (forceRefresh: number) => void;
  onOpacityValue?: (opacityValue: number) => void;
  onPreviewProgressOffsetChanged?: (opacityValue: number) => void;
  onDoDeleteAnimChanged?: (isDoDeleteAnim: boolean) => void;
  onIsDeletingChanged?: (isDeleting: boolean) => void;
  onScrollSnapChanged?: (scrollSnap: ScrollSnapAlign) => void;
  onListEdgeEffectChanged?: (listEdgeEffect: EdgeEffect) => void;
  onIsPositiveSlidingChanged?: (isPositiveSliding: boolean) => void;
  onIsVideoToEndChanged?: (isVideoToEnd: boolean) => void;
  onIsShowVideoChanged?: (isShowVideo: boolean) => void;
  onVideoPlayChanged?: (isVideoPlaying: boolean) => void;
  onCurrentDeleteIDChanged?: (currentDeleteID: string) => void;
  onAnalyzerVisibilityChanged?: (analyzerVisibility: Visibility) => void;
  onIsLcdCompleteChanged?: (isLcdComplete: boolean) => void;
  onIsScrollingChanged?: (isScrolling: boolean) => void;
  onPreviewBarAnimationChanged?: (isPreviewBarAnimation: boolean) => void;
  onRunningAnimationChanged?: (isRunningAnimation: boolean) => void;
  onInSwiperAnimationChanged?: (isInSwiperAnimation: boolean) => void;
  onAnchorDirectionChanged?: (anchorDirection: AnchorDirection) => void;
  onFrameOpenAniChanged?: (isFrameOpenAni: boolean) => void;
  onSwiperAnimationChange?: (isSwiperOffsetZero: boolean) => void;
  onChangeSwiperDirection?: (swiperDirection: number) => void;
  onDoingImageSlideAnimation?: (isDoingImageSlideAnimation: boolean) => void;
  onPullDownAndDragPhoto?: (isPullDownAndDragPhoto: boolean) => void;
  onInAnimateToPosition?: (isInAnimateToPosition: boolean) => void;
  onHistogramNextItemChanged?: (histogramNextItem: MediaItem) => void;
  onIsPullingUpChanged?: (isPullingUp: boolean) => void;
  onPcCurItemChanged?: (pcCurItem: MediaItem) => void;
  onImagePaddingChanged?: (imagePadding: Padding | Length | LocalizedPadding) => void;
  onVideoCoverFrameChanged: (videoCoverFrame: PixelMap[]) => void;
}

/**
 * 预览条组件状态控制器
 */
export interface SwiperPreviewStateListener {
  onStateReportedChanged?: (stateReported: media.AVPlayerState) => void;
}

class TempResult {
  public index: number = 0;
  public shrinkFactor: number = 0;
  public isTouching: boolean = true;
  public startIndex: number = 0;
  public percent: number = 0;
  public forceRefresh: number = 0;
}

export const SCROLL_ANIMATION_DURATION: number = 100;

const TAG: string = 'common_SwiperVM';
const DEFAULT_PERSIST_ID: number = 0;
const MAX_ALLOWED_DELAY_TIME: number = 100;
const SEND_FOCUS_DEFAULT_DELAY: number = 100;
const PRELOAD_MAX_SIZE: number = 6000;

// 属性同步支持的类型
type AttrType = boolean | number | string | ScrollSnapAlign | EdgeEffect | Visibility | AnchorDirection | MediaItem;

export class SwiperVM implements IStateChangeListener {
  @Track public stateMachine: PhotoBrowserStateMachine;

  @Track public timeCapsuleRawTime: number = 0;
  /**
   * 逐帧播放：进度条上报时间
   */
  @Track public progressRawTime: number = 0;
  @Track public swiperListHeight: Length = 0;
  /**
   * Swiper 组件所展示的当前图片信息
   */
  @Track public curItem: MediaItem = new MediaItem();
  /**
   * 外部分享等：MediaItem.duration 无效时由播放器广播写入，驱动时间胶囊等 UI（@Prop curItem 不会随字段突变刷新）
   */
  @Track public resolvedVideoDurationCapsuleMs: number = 0;
  @Track public pcCurItem: MediaItem = new MediaItem();
  /**
   * Swiper 切图动画时长
   */
  @Track public mDuration: number = 300;
  @Track public isShowTimeCapsule: boolean = false;
  /* instrument ignore next */
  @Track public isFingerSlide: boolean = false;
  @Track public windowLayoutWidth: number = 0;
  @Track public windowLayoutHeight: number = 0;
  @Track public isShowThumbSource: boolean = true;
  @Track public totalCount: number = 0;
  @Track public isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  // 标志当前是否正在支持下拉图片
  /* instrument ignore next */
  @Track public isPullDownStart: boolean = false;
  @Track public isShowFlushImage: boolean = true;
  /**
   * 当前图片 uri 信息
   */
  @Track public currentUri: string = '';
  /**
   * 标志thumbSource是否为空, 三方入口进图库 预览条数据加载完成标志位
   */
  @Track public isThumbsourceLoadFinished: boolean = true;
  /**
   * 逐帧播放：是否在滑动xxx视频帧的边界开始滑动
   */
  @Track public isFrameShrinkAni: boolean = false;
  /**
   * SwiperView单属性刷新控制器
   */
  @Track public swiperModifier: SwiperModifier = new SwiperModifier();
  /**
   * List单属性刷新控制器
   */
  @Track public listColumnModifier: BaseAttributeUpdater<ColumnAttribute> = new BaseAttributeUpdater();
  /**
   * 预览条显示
   */
  public uiContext: UIContext | undefined = undefined;
  @Track public listVisible: Visibility = Visibility.Visible;
  /**
   * 标记是否为选择模式
   */
  @Track public isInSelectedMode: boolean = false;
  @Track public isFromPortraitCoverSet: boolean = false;
  /**
   * 标志当前页面是否是由 FA 卡片拉起
   */
  @Track public isFromFACard: boolean = false;
  @Track public isSlideBarShow: boolean = false;
  @Track public isPcShowingEditor: boolean = false;
  @Track public thumbSource?: ThumbDataSource;
  @Track public isShowBar: boolean = false;
  /**
   * 逐帧播放：xxx所抽取帧的个数
   */
  @Track public frameNum: number = 0;
  /**
   * 逐帧播放：滑动预览条时是否超出边界
   */
  @Track public selectedSmallImgWidth: number = ImageUtil.getSelectedSmallImgWidth();
  @Track public isEditorShown: boolean = false;
  @Track public imageList: PCImageInfo[] = [];
  @Track public photoChanged: boolean = false;
  @Track public isImageAnalyzePaused: boolean = false;
  @Track public deviceWidth: number = Constants.DEFAULT_WIDTH;
  @Track public dismissWillScroll: boolean = false;
  /**
   * AI 组件相关变量，控制 AI 组件是否上组件树
   */
  @Track public canShowImageAnalyzer: boolean = false;
  @Track private attributeMap: Map<string, AttributeStateManager<AttrType>> = new Map();
  @Track private swiperStateListener?: SwiperStateListener;
  @Track private swiperPreviewStateListener?: SwiperPreviewStateListener;
  @Track public videoPlayController?: VideoPlayController;

  /**
   * xxx设备形态转换，状态变量
   */
  @Track public isFoldExpandedEnhancer: boolean = DeviceInfo.isFoldable();

  public videoCoverFrame: PixelMap[] = [];
  public broadCast: BroadCast | undefined;
  public costReportManager: BrowserCostReportManager = BrowserCostReportManager.getInstance();
  protected statisticRptMgr: BrowserStatisticReportManager = new BrowserStatisticReportManager();
  /**
   * 图片容器 Swiper 使用的控制器，控制水平切换图片
   */
  public swiperController: SwiperController = new SwiperController();
  private isWinSizeChanged: boolean = false;
  private isItemChange: boolean = false;
  // 预览条缓存更新：记录删除图片的path
  /* instrument ignore next */
  protected deleteItemPath: string = '';
  private progressRawTimeDuration: number = 0;
  private isExpandFinish: boolean = false;
  private waitingForTimeSync: boolean = false;
  /**
   * 逐帧播放：video控制器
   */
  private timeCapsuleTimeoutID: number = 0;
  private expectedProgressRawTime: number = 0;
  private tempIndex: number = Number.NaN;
  private swiperTimer: number | undefined = undefined;
  /**
   * 大图跟手相对位移
   */
  protected diffOffset: number = 0;
  protected readonly smallImgLow: number = 18;
  private readonly smallImgHeight: number = 36;
  protected itemWidth: number = this.smallImgLow + Constants.LIST_ITEM_SPACE;

  /**
   * 注册属性变化监听
   *
   * @param listener 监听对象
   */
  public registerStateListener(listener: SwiperStateListener) {
    this.swiperStateListener = listener;
  }

  public setThumbnailViewShow: Function = (isThumbnailViewShow: boolean) => {
  }

  /**
   * 取消注册属性变化监听
   */
  public unRegisterStateListener() {
    this.swiperStateListener = undefined;
  }

  public registerPreviewStateListener(previewListener: SwiperPreviewStateListener) {
    this.swiperPreviewStateListener = previewListener;
  }

  public unRegisterPreviewStateListener() {
    this.swiperPreviewStateListener = undefined;
  }

  public setCenterIndex(centerIndex: number): void {
    this.updateAttribute('centerIndex', centerIndex);
    this.swiperStateListener?.onCenterIndex?.(centerIndex);
  }

  public getCenterIndex(): number {
    let centerIndex: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('centerIndex');
    if (centerIndex !== undefined) {
      return centerIndex.currentState as number;
    }
    return this.getCurrentIndex();
  }

  public setTimeCapsuleRawTime(timeCapsuleRawTime: number): void {
    this.timeCapsuleRawTime = timeCapsuleRawTime;
    this.swiperStateListener?.onTimeCapsuleRawTimeChange?.(timeCapsuleRawTime);
  }

  public setShrinkFactor(shrinkFactor: number): void {
    this.updateAttribute('shrinkFactor', shrinkFactor);
    this.swiperStateListener?.onShrinkFactor?.(shrinkFactor);
  }

  public getShrinkFactor(): number {
    let shrinkFactor: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('shrinkFactor');
    if (shrinkFactor !== undefined) {
      return shrinkFactor.currentState as number;
    }
    return 0;
  }

  public setTargetOffset(targetOffset: number): void {
    this.updateAttribute('targetOffset', targetOffset);
    this.swiperStateListener?.onTargetOffset?.(targetOffset);
  }

  public getTargetOffset(): number {
    let targetOffset: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('targetOffset');
    if (targetOffset !== undefined) {
      return targetOffset.currentState as number;
    }
    return 0;
  }

  public setCurBigOffset(curBigOffset: number): void {
    this.updateAttribute('curBigOffset', curBigOffset);
    this.swiperStateListener?.onCurBigOffset?.(curBigOffset);
  }

  public getCurBigOffset(): number {
    let targetOffset: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('targetOffset');
    if (targetOffset !== undefined) {
      return targetOffset.currentState as number;
    }
    return 0;
  }

  private getPreviewStackHeight() : number {
    return LocalStorage.getShared()?.get<number>('previewStackHeight') ?? 0;
  }

  public setIsFrameExpand(isFrameExpand: boolean) {
    this.updateAttribute('isFrameExpand', isFrameExpand);
    this.swiperStateListener?.onIsFrameExpand?.(isFrameExpand);
  }

  public getIsFrameExpand(): boolean {
    let isFrameExpand: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isFrameExpand');
    if (isFrameExpand !== undefined) {
      return isFrameExpand.currentState as boolean;
    }
    return false;
  }

  public setStateReported(stateReported: media.AVPlayerState) {
    this.swiperPreviewStateListener?.onStateReportedChanged?.(stateReported);
  }

  public setStartOffset(startOffset: number): void {
    this.updateAttribute('startOffset', startOffset);
    this.swiperStateListener?.onStartOffset?.(startOffset);
  }

  public getStartOffset(): number {
    let startOffset: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('startOffset');
    if (startOffset !== undefined) {
      return startOffset.currentState as number;
    }
    return 0;
  }

  public setForceRefresh(forceRefresh: number): void {
    this.updateAttribute('forceRefresh', forceRefresh);
    this.swiperStateListener?.onForceRefresh?.(forceRefresh);
  }

  public getForceRefresh(): number {
    let forceRefresh: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('forceRefresh');
    if (forceRefresh !== undefined) {
      return forceRefresh.currentState as number;
    }
    return 0;
  }

  public setOpacityValue(opacityValue: number): void {
    this.updateAttribute('opacityValue', opacityValue);
    this.swiperStateListener?.onOpacityValue?.(opacityValue);
  }

  public getOpacityValue(): number {
    let opacityValue: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('opacityValue');
    if (opacityValue !== undefined) {
      return opacityValue.currentState as number;
    }
    return 0;
  }

  public setPreviewProgressOffset(previewProgressOffset: number): void {
    this.updateAttribute('previewProgressOffset', previewProgressOffset);
    this.swiperStateListener?.onPreviewProgressOffsetChanged?.(previewProgressOffset);
  }

  public getPreviewProgressOffset(): number {
    let previewProgressOffset: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('previewProgressOffset');
    if (previewProgressOffset !== undefined) {
      return previewProgressOffset.currentState as number;
    }
    return 0;
  }

  public setIsDoDeleteAnim(isDoDeleteAnim: boolean): void {
    this.updateAttribute('isDoDeleteAnim', isDoDeleteAnim);
    this.swiperStateListener?.onDoDeleteAnimChanged?.(isDoDeleteAnim);
  }

  public getIsDoDeleteAnim(): boolean {
    let isDoDeleteAnim: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isDoDeleteAnim');
    if (isDoDeleteAnim !== undefined) {
      return isDoDeleteAnim.currentState as boolean;
    }
    return false;
  }

  public setIsDeleting(isDeleting: boolean): void {
    this.updateAttribute('isDeleting', isDeleting);
    this.swiperStateListener?.onIsDeletingChanged?.(isDeleting);
  }

  public getIsDeleting(): boolean {
    let isDeleting: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isDeleting');
    if (isDeleting !== undefined) {
      return isDeleting.currentState as boolean;
    }
    return false;
  }

  public setScrollSnap(scrollSnap: ScrollSnapAlign): void {
    this.updateAttribute('scrollSnap', scrollSnap);
    this.swiperStateListener?.onScrollSnapChanged?.(scrollSnap);
  }

  public getScrollSnap(): ScrollSnapAlign {
    let scrollSnap: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('scrollSnap');
    if (scrollSnap !== undefined) {
      return scrollSnap.currentState as ScrollSnapAlign;
    }
    return ScrollSnapAlign.CENTER;
  }

  public setListEdgeEffect(listEdgeEffect: EdgeEffect): void {
    this.updateAttribute('listEdgeEffect', listEdgeEffect);
    this.swiperStateListener?.onListEdgeEffectChanged?.(listEdgeEffect);
  }

  public getListEdgeEffect(): EdgeEffect {
    let listEdgeEffect: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('listEdgeEffect');
    if (listEdgeEffect !== undefined) {
      return listEdgeEffect.currentState as EdgeEffect;
    }
    return EdgeEffect.Spring;
  }

  public setProgressRawTime(value: number): void {
    this.progressRawTime = value;
    this.onChangeProgressRawTime();
  }

  public getProgressRawTime(): number {
    return this.progressRawTime;
  }

  public setIsDoingDeleteAnim(value: boolean): void {
    AppStorage.setOrCreate<boolean>('isDoingDeleteBigPhotoAnim', value);
  }

  public getIsDoingDeleteAnim(): boolean {
    return AppStorage.get<boolean>('isDoingDeleteBigPhotoAnim') ?? false;
  }

  public setIsPositiveSliding(isPositiveSliding: boolean): void {
    this.updateAttribute('isPositiveSliding', isPositiveSliding);
    this.swiperStateListener?.onIsPositiveSlidingChanged?.(isPositiveSliding);
  }

  public getIsPositiveSliding(): boolean {
    let isPositiveSliding: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isPositiveSliding');
    if (isPositiveSliding !== undefined) {
      return isPositiveSliding.currentState as boolean;
    }
    return true;
  }

  public setIsVideoToEnd(isVideoToEnd: boolean): void {
    this.updateAttribute('isVideoToEnd', isVideoToEnd);
    this.swiperStateListener?.onIsVideoToEndChanged?.(isVideoToEnd);
  }

  public getIsVideoToEnd(): boolean {
    let isVideoToEnd: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isVideoToEnd');
    if (isVideoToEnd !== undefined) {
      return isVideoToEnd.currentState as boolean;
    }
    return false;
  }

  public setIsShowVideo(isShowVideo: boolean): void {
    this.updateAttribute('isShowVideo', isShowVideo);
    this.swiperStateListener?.onIsShowVideoChanged?.(isShowVideo);
  }

  public getIsShowVideo(): boolean {
    let isShowVideo: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isShowVideo');
    if (isShowVideo !== undefined) {
      return isShowVideo.currentState as boolean;
    }
    return false;
  }

  public setIsVideoPlaying(isVideoPlaying: boolean): void {
    Log.info(TAG, `setIsVideoPlaying, isVideoPlaying: ${isVideoPlaying}`);
    this.updateAttribute('isVideoPlaying', isVideoPlaying);
    this.swiperStateListener?.onVideoPlayChanged?.(isVideoPlaying);
  }

  public getIsVideoPlaying(): boolean {
    let isVideoPlaying: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isVideoPlaying');
    if (isVideoPlaying !== undefined) {
      Log.info(TAG, `getIsVideoPlaying, isVideoPlaying: ${isVideoPlaying.currentState as boolean}`);
      return isVideoPlaying.currentState as boolean;
    }
    Log.info(TAG, 'getIsVideoPlaying, default isVideoPlaying: true');
    return true;
  }

  public setCurrentDeleteID(currentDeleteID: string): void {
    this.updateAttribute('currentDeleteID', currentDeleteID);
    this.swiperStateListener?.onCurrentDeleteIDChanged?.(currentDeleteID);
  }

  public getCurrentDeleteID(): string {
    let currentDeleteID: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('currentDeleteID');
    if (currentDeleteID !== undefined) {
      return currentDeleteID.currentState as string;
    }
    return '';
  }

  public setAnalyzerVisibility(analyzerVisibility: Visibility): void {
    this.updateAttribute('analyzerVisibility', analyzerVisibility);
    this.swiperStateListener?.onAnalyzerVisibilityChanged?.(analyzerVisibility);
  }

  public getAnalyzerVisibility(): Visibility {
    let analyzerVisibility: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('analyzerVisibility');
    if (analyzerVisibility !== undefined) {
      return analyzerVisibility.currentState as Visibility;
    }
    return Visibility.Visible;
  }

  public setIsLcdComplete(isLcdComplete: boolean): void {
    this.updateAttribute('isLcdComplete', isLcdComplete);
    this.swiperStateListener?.onIsLcdCompleteChanged?.(isLcdComplete);
  }

  public getIsLcdComplete(): boolean {
    let isLcdComplete: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isLcdComplete');
    if (isLcdComplete !== undefined) {
      return isLcdComplete.currentState as boolean;
    }
    return false;
  }

  public setIsScrolling(isScrolling: boolean): void {
    this.updateAttribute('isScrolling', isScrolling);
    this.swiperStateListener?.onIsScrollingChanged?.(isScrolling);
  }

  public getIsScrolling(): boolean {
    let isScrolling: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isScrolling');
    if (isScrolling !== undefined) {
      return isScrolling.currentState as boolean;
    }
    return false;
  }

  public setIsPreviewBarAnimation(isPreviewBarAnimation: boolean): void {
    this.updateAttribute('isPreviewBarAnimation', isPreviewBarAnimation);
    this.swiperStateListener?.onPreviewBarAnimationChanged?.(isPreviewBarAnimation);
  }

  public getIsPreviewBarAnimation(): boolean {
    let isPreviewBarAnimation: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isPreviewBarAnimation');
    if (isPreviewBarAnimation !== undefined) {
      return isPreviewBarAnimation.currentState as boolean;
    }
    return false;
  }

  public setIsRunningAnimation(isRunningAnimation: boolean): void {
    this.updateAttribute('isRunningAnimation', isRunningAnimation);
    this.swiperStateListener?.onRunningAnimationChanged?.(isRunningAnimation);
  }

  public getIsRunningAnimation(): boolean {
    let isRunningAnimation: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isRunningAnimation');
    if (isRunningAnimation !== undefined) {
      return isRunningAnimation.currentState as boolean;
    }
    return false;
  }

  public getIsInSwiperAnimation(): boolean {
    let isInSwiperAnimation: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isInSwiperAnimation');
    if (isInSwiperAnimation !== undefined) {
      return isInSwiperAnimation.currentState as boolean;
    }
    return false;
  }

  public setAnchorDirection(anchorDirection: AnchorDirection): void {
    this.updateAttribute('anchorDirection', anchorDirection);
    this.swiperStateListener?.onAnchorDirectionChanged?.(anchorDirection);
  }

  public getAnchorDirection(): AnchorDirection {
    let anchorDirection: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('anchorDirection');
    if (anchorDirection !== undefined) {
      return anchorDirection.currentState as AnchorDirection;
    }
    return AnchorDirection.HEADER;
  }

  public setIsFrameOpenAni(isFrameOpenAni: boolean): void {
    this.updateAttribute('isFrameOpenAni', isFrameOpenAni);
    this.swiperStateListener?.onFrameOpenAniChanged?.(isFrameOpenAni);
  }

  public getIsFrameOpenAni(): boolean {
    let isFrameOpenAni: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isFrameOpenAni');
    if (isFrameOpenAni !== undefined) {
      return isFrameOpenAni.currentState as boolean;
    }
    return false;
  }

  public setIsSwiperOffsetZero(isSwiperOffsetZero: boolean): void {
    this.updateAttribute('isSwiperOffsetZero', isSwiperOffsetZero);
    this.swiperStateListener?.onSwiperAnimationChange?.(isSwiperOffsetZero);
  }

  public getIsSwiperOffsetZero(): boolean {
    let isSwiperOffsetZero: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isSwiperOffsetZero');
    if (isSwiperOffsetZero !== undefined) {
      return isSwiperOffsetZero.currentState as boolean;
    }
    return false;
  }

  public setSwiperDirection(swiperDirection: number): void {
    this.updateAttribute('swiperDirection', swiperDirection);
    this.swiperStateListener?.onChangeSwiperDirection?.(swiperDirection);
  }

  public getSwiperDirection(): number {
    let swiperDirection: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('swiperDirection');
    if (swiperDirection !== undefined) {
      return swiperDirection.currentState as number;
    }
    return SwiperDirection.DEFAULT;
  }

  public setIsDoingImageSlideAnimation(isDoingImageSlideAnimation: boolean): void {
    this.updateAttribute('isDoingImageSlideAnimation', isDoingImageSlideAnimation);
    this.swiperStateListener?.onDoingImageSlideAnimation?.(isDoingImageSlideAnimation);
  }

  public getIsDoingImageSlideAnimation(): boolean {
    let isDoingImageSlideAnimation: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isDoingImageSlideAnimation');
    if (isDoingImageSlideAnimation !== undefined) {
      return isDoingImageSlideAnimation.currentState as boolean;
    }
    return false;
  }

  public setIsPullDownAndDragPhoto(isPullDownAndDragPhoto: boolean): void {
    this.updateAttribute('isPullDownAndDragPhoto', isPullDownAndDragPhoto);
    this.swiperStateListener?.onPullDownAndDragPhoto?.(isPullDownAndDragPhoto);
  }

  public getIsPullDownAndDragPhoto(): boolean {
    let isPullDownAndDragPhoto: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isPullDownAndDragPhoto');
    if (isPullDownAndDragPhoto !== undefined) {
      return isPullDownAndDragPhoto.currentState as boolean;
    }
    return false;
  }

  public setIsInAnimateToPosition(isInAnimateToPosition: boolean): void {
    this.updateAttribute('isInAnimateToPosition', isInAnimateToPosition);
    this.swiperStateListener?.onInAnimateToPosition?.(isInAnimateToPosition);
  }

  public getIsInAnimateToPosition(): boolean {
    let isInAnimateToPosition: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isInAnimateToPosition');
    if (isInAnimateToPosition !== undefined) {
      return isInAnimateToPosition.currentState as boolean;
    }
    return false;
  }

  public setHistogramNextItem(histogramNextItem: MediaItem): void {
    this.updateAttribute('histogramNextItem', histogramNextItem);
    this.swiperStateListener?.onHistogramNextItemChanged?.(histogramNextItem);
  }

  public getHistogramNextItem(): MediaItem {
    let histogramNextItem: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('histogramNextItem');
    if (histogramNextItem !== undefined) {
      return histogramNextItem.currentState as MediaItem;
    }
    return new MediaItem();
  }

  public setIsPullingUp(isPullingUp: boolean): void {
    this.updateAttribute('isPullingUp', isPullingUp);
    this.swiperStateListener?.onIsPullingUpChanged?.(isPullingUp);
  }

  public getIsPullingUp(): boolean {
    let isPullingUp: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('isPullingUp');
    if (isPullingUp !== undefined) {
      return isPullingUp.currentState as boolean;
    }
    return false;
  }

  public setPcCurItem(pcCurItem: MediaItem) {
    this.updateAttribute('pcCurItem', pcCurItem);
    this.swiperStateListener?.onPcCurItemChanged?.(pcCurItem);
  }

  public getPcCurItem(): MediaItem {
    let pcCurItem: AttributeStateManager<AttrType> | undefined =
      this.attributeMap.get('pcCurItem');
    if (pcCurItem) {
      return pcCurItem.currentState as MediaItem;
    }
    return new MediaItem();
  }

  public getIsHorizontal(): boolean {
    return AppStorage.get<boolean>('isHorizontal') ?? isOrientationHorizontal();
  }

  public getIsFullMode(): boolean {
    return AppStorage.get<boolean>('isFullMode') ?? getScreen().isFullMode();
  }

  public setImagePadding(imagePadding: Padding | Length | LocalizedPadding) {
    this.swiperStateListener?.onImagePaddingChanged?.(imagePadding);
  }

  public setVideoCoverFrame(videoCoverFrame: PixelMap[]) {
    this.swiperStateListener?.onVideoCoverFrameChanged?.(videoCoverFrame);
  }

  public browserController?: BasePhotoBrowserController;
  public onPhotoChanged: Function = (index: number): void => {
  };
  public onDataPrepare: Function = (index: number): void => {
  };
  public onIndexChanged: Function = (index: number): void => {
  };
  public browserAnimController: BrowserAnimController = new BrowserAnimController();
  /**
   * scrollTo() 左边界移动的距离，正值向左，负值向右
   * scrollBy() 左边界移动的相对距离，正值向左，负值向右
   * scrollToIndex() 聚焦点（左边第一个位置）移动到某个index位置；会触发 onScrollStop() 回调
   */
  public smallScroller: Scroller = new Scroller();
  /**
   * 逐帧播放：点击展开方法
   */
  public onVideoFrameClickFunc: Function = (uri: string): void => this.videoFrameClickAction(uri);

  protected startTouchIndex: number;
  protected endTouchIndex: number;
  private lastResult: TempResult = new TempResult();
  private targetStatusOnCloudFrame: string | undefined = undefined;
  /**
   * 应用级广播，保存关键监听回调
   */
  protected appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();
  private onDeleteUIFirstFunc: Function = (): void => this.onDeleteUIFirst();
  private onDataReloadFunc: Function = (addCount?: number): void => this.onDataReload(addCount);
  private onChangeSwiperDurationFunc: Function = (value: number): void => this.onChangeSwiperDuration(value);
  /* instrument ignore next */
  private videoScrollToStartFunc: Function = (): void => {
    this.videoScrollToStart();
  }
  /* instrument ignore next */
  private resetVideoFrameBeforeEditFunc: () => void = (): void => {
    this.resetVideoFrameBeforeEdit();
  }
  private clickPlayVideoFrameExpandFunc: Function =
    (uri?: string, clickedPlay?: boolean): void => this.videoFrameClickAction(uri, clickedPlay);
  private currentDeleteIDFunc: Function = (uniqueId: string): void => this.currentDeleteIDChange(uniqueId);
  private initVideoPlayFunc: Function = (videoPlayController: VideoPlayController):
    void => this.initVideoPlay(videoPlayController);
  private updateProgressRawTimeFunc: Function = (rawTime: number):
    void => this.updateProgressRawTime(rawTime);
  private onVideoDurationResolvedFunc: Function = (args: Object[]): void => {
    this.onVideoDurationResolved(args);
  };
  private backPressEventFunc: Function = (): void => {
    this.onBackPressEvent();
  };
  private videoStatusReportedFunc: Function = (state: media.AVPlayerState): void => {
    this.videoStatusReported(state);
  }

  constructor(stateMachine: PhotoBrowserStateMachine) {
    this.stateMachine = stateMachine;
    this.setCenterIndex(this.getCurrentIndex());
    this.startTouchIndex = this.getCurrentIndex();
    this.endTouchIndex = this.getCurrentIndex();
  }

  /**
   * 更新view 里使用的属性变量
   *
   * @param tag 属性名
   * @param value 属性值, 当前支持简单数据类型：boolean、number、Resource
   */
  public updateAttribute(tag: string, value: AttrType) {
    let asm: AttributeStateManager<AttrType> | undefined = this.attributeMap.get(tag);
    if (!asm) {
      asm = new AttributeStateManager(DEFAULT_PERSIST_ID, value, tag);
      this.attributeMap.set(tag, asm);
    }
    asm.updateState(value);
  }

  protected getBrowserController(): BasePhotoBrowserController {
    return this.browserController as BasePhotoBrowserController;
  }

  public onCreate(browserAnimController: BrowserAnimController): void {
    this.stateMachine.registerStateChangeListener(this);
    this.browserAnimController = browserAnimController;
    this.isSlideBarShow = this.isSlideBarVisibility();
    this.updateSwiperHeight();
    // 大图浏览初始化时，浏览大图打点数据重置
    this.costReportManager.resetCostInfo();
    this.registerBroadCast();
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    // pc场景使用，算上分割线需要+1
    let imagePadding: Padding | Length | LocalizedPadding =
      (!this.isPcShowingEditor && this.isShowBar && DeviceInfo.isPc()) ? {
        top: getScreen().calcBarTopHeight() + BrowserConstants.DIVIDER_WIDTH,
        bottom: Constants.PC_PREVIEW_STACK_HEIGHT + BrowserConstants.DIVIDER_WIDTH
      } : {};
    this.setImagePadding(imagePadding);
  }

  /**
   * 侧边面板是否显示
   *
   * @returns false 不显示
   */
  public isSlideBarVisibility(): boolean {
    return false;
  }

  /**
   * 更新大图显示高度
   */
  public updateSwiperHeight(): void {
  }

  /**
   * 是否需要显示预览条
   */
  public shouldShowPreview(): boolean {
    return true;
  }

  /**
   * 注册事件监听
   */
  protected registerBroadCast() {
    this.broadCast?.on(BroadCastConstants.ON_DELETE_UI_FIRST, this.onDeleteUIFirstFunc);
    this.broadCast?.on(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadFunc);
    this.broadCast?.on(BroadCastConstants.CHANGE_SWIPER_DURATION, this.onChangeSwiperDurationFunc);
    this.broadCast?.on(BrowserConstants.VIDEO_SCROLL_TO_START, this.videoScrollToStartFunc);
    this.broadCast?.on(BrowserConstants.RESET_VIDEO_FRAME_BEFORE_EDIT, this.resetVideoFrameBeforeEditFunc);
    this.broadCast?.on(BroadCastConstants.PLAY_ICON_CLICK_FRAME_EXPAND, this.clickPlayVideoFrameExpandFunc);

    this.appBroadCast.on(BroadCastConstants.CURRENT_DELETE_UNIQUEID, this.currentDeleteIDFunc);
    this.appBroadCast.on(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, this.initVideoPlayFunc);
    this.appBroadCast.on(BroadCastConstants.UPDATE_PROGRESS_RAW_TIME, this.updateProgressRawTimeFunc);
    this.appBroadCast.on(BroadCastConstants.BACK_PRESS_CENTER, this.backPressEventFunc);
    this.appBroadCast.on(BroadCastConstants.VIDEO_DURATION_RESOLVED, this.onVideoDurationResolvedFunc);
    this.appBroadCast.on(BroadCastConstants.VIDEO_STATUS_REPORTED, this.videoStatusReportedFunc);
  }

  private onWinSizeChanged(): void {
    if (DeviceInfo.isPc()) {
      /* instrument ignore next */
      Log.info(TAG, 'onWinSizeChanged method start');
      /* instrument ignore next */
      this.handleWinSizeChangeImmersiveAnimation();
    }
  }

  /**
   * 侧边显示状态变化
   *
   * @param isShowBar 是否显示
   */
  public onShowBarChanged(isShowBar: boolean) {
    this.isShowBar = isShowBar;
    this.onShowBarUpdateCapsuleAndProgress();
    Log.info(TAG, `onShowChanged this.isShowBar=${this.isShowBar}`);
    /* instrument ignore else */
    if (DeviceInfo.isPc()) {
      this.handleImmersiveModeAnimation();
    } else {
      animateTo({
        duration: BrowserConstants.IMMERSE_ANIM_DURATION,
        delay: this.isShowBar ? BrowserConstants.IMMERSE_ANIM_DELAY : 0,
        curve: this.isShowBar ? Curves.cubicBezier(0.6, 0.0, 0.6, 1.0) : Curves.cubicBezier(0.2, 0.0, 0.2, 1.0),
      }, (): void => {
        if (this.isShowBar) {
          this.setOpacityValue(1);
        } else {
          this.setOpacityValue(0);
        }
      })
    }
  }

  /**
   * 1、非沉浸式操作跳过
   * 2、进入沉浸式时，winMod为PRIMARY模式，表示有dock栏，会触发winSizeChange，跳过此次动效；其它场景不跳过
   * 3、分屏场景进入沉浸式需触发动效
   * 4、退出沉浸式时，需进入触发退场动效; isWinSizeChanged，窗口变化过则跳过，其它不跳过
   */
  /* instrument ignore next */
  private handleImmersiveModeAnimation() {
    if (this.needSkipImmersiveModeAnimation()) {
      Log.info(TAG, 'not handle onShowChange immersive, skip.');
      return;
    }

    Log.info(TAG, `photoSwiper onShowChanged: ${this.isShowBar}, winMode:${getScreen()
      .getWinMode()}`);
    if (this.isWinSizeChanged) {
      this.isWinSizeChanged = false;
      Log.info(TAG, 'win size changed, skip current animation.');
      return;
    }

    Log.info(TAG, 'onShowChanged, enter doImmersiveModeAnimation');
    this.isWinSizeChanged = false;
    this.doImmersiveModeAnimation();
  }

  private get virtualKbKeyPC(): string {
    return LocalStorage.getShared()?.get<string>('virtualKbKey') ?? '';
  }

  /**
   * 全屏场景下，以下场景需跳过：
   * 1、不是处理沉浸式场景需跳过
   * 2、非全屏不跳过
   * 3、分屏不跳过
   * 4、开启了‘窗口最大化或分屏时隐藏快捷栏’时不跳过
   * 5、存在dock栏时跳过
   *
   * @returns boolean
   */
  protected needSkipImmersiveModeAnimation(): boolean {
    let isHandleImmersive: boolean = AppStorage.get<boolean>('isHandleImmersive') || false;
    let isMaximize: boolean = this.checkImmersive();
    if (!isHandleImmersive) {
      return true;
    }
    if (!isMaximize) {
      return false;
    }
    if (getScreen().getWindowStatusType() === window.WindowStatusType.SPLIT_SCREEN) {
      return false;
    }
    if (getScreen().isDockAutoHideStyleOn()) {
      return false;
    }
    return getScreen().isExistDock();
  }

  /* instrument ignore next */
  private doImmersiveModeAnimation(): void {
    LocalStorage.getShared()?.setOrCreate<boolean>('isDoingImmersiveAnimationPC', true);
    this.handleSideBarUpdate();
    let padding: Padding | Length | LocalizedPadding =
      (!this.isPcShowingEditor && this.isShowBar && DeviceInfo.isPc()) ? {
        top: getScreen().calcBarTopHeight() + BrowserConstants.DIVIDER_WIDTH,
        bottom: this.getPreviewStackHeight() + BrowserConstants.DIVIDER_WIDTH
      } : {};
    animateTo({
      duration: BrowserConstants.PC_BROWSER_IMMERSE_ANIM_DURATION,
      curve: Curves.cubicBezier(0.2, 0.0, 0.2, 1.0),
      onFinish: (): void => {
        AppStorage.setOrCreate<boolean>('isHandleImmersive', false);
        LocalStorage.getShared()?.setOrCreate<boolean>('isDoingImmersiveAnimationPC', false);
      }
    }, (): void => {
      this.setImagePadding(padding);
      if (this.isShowBar) {
        this.setOpacityValue(1);
      } else {
        this.setOpacityValue(0);
      }
    })
  }

  /**
   * 更新侧边栏状态
   */
  protected handleSideBarUpdate(): void {
  }

  /**
   * 逐帧播放退出沉浸态时显示时间胶囊，且做进度条同步
   */
  protected onShowBarUpdateCapsuleAndProgress(): void {
    this.showTimeCapsule();
    if (this.getIsFrameExpand()) {
      this.setTimeCapsuleRawTime(this.progressRawTime);
      this.videoProgressScrollTo();
    } else {
      this.setPreviewProgressOffset((this.selectedSmallImgWidth * 2 - Constants.PREVIEW_PROGRESS_WIDTH) *
      this.progressRawTime / this.getCapsuleTotalDurationMs());
    }
  }

  /**
   * 逐帧播放：视频进度条切换
   */
  /* instrument ignore next */
  public videoProgressScrollTo(): void {
    this.videoProgressScrollToByDuration(this.progressRawTimeDuration);
  }

  /**
   * 调整视频播放进度条到目标位置
   *
   * @param duration 时长
   */
  protected videoProgressScrollToByDuration(duration: number): void {
  }

  public onPcShowingEditorChanged(isPcShowingEditor: boolean) {
    this.isPcShowingEditor = isPcShowingEditor;
    let imagePadding: Padding | Length | LocalizedPadding =
      (!this.isPcShowingEditor && this.isShowBar && DeviceInfo.isPc()) ? {
        top: getScreen().calcBarTopHeight() + BrowserConstants.DIVIDER_WIDTH,
        bottom: this.getPreviewStackHeight() + BrowserConstants.DIVIDER_WIDTH
      } : {};
    this.setImagePadding(imagePadding);
  }

  /**
   * 1、必须是PC且是沉浸式操作，包含进入和退出沉浸式
   * 2、与handleImmersiveModeAnimation不能同时执行，isWinSizeChanged以示区分
   */
  /* instrument ignore next */
  private handleWinSizeChangeImmersiveAnimation() {
    let immersive: boolean = this.checkImmersive();
    let isHandleImmersive: boolean = AppStorage.get<boolean>('isHandleImmersive') || false;
    Log.info(TAG, `immersive:${immersive}, ${getScreen().isPrimaryMode()}, ${getScreen().isLayoutFullScreen()}`);
    if (isHandleImmersive && (immersive || (getScreen().isPrimaryMode() && !getScreen().isLayoutFullScreen()))) {
      Log.info(TAG, `onWinSizeChangedInner, enter doImmersiveModeAnimation, immersive:${immersive}, mode:${getScreen()
        .getWinMode()}, isLayoutFullScreen:${getScreen()
        .isLayoutFullScreen()}, isHandleImmersive:${isHandleImmersive}`);
      this.isWinSizeChanged = true;
      this.doImmersiveModeAnimation();
    } else {
      Log.info(TAG, `handleWinSizeChangeImmersiveAnimation:${this.isWinSizeChanged}`);
      this.isWinSizeChanged = false;
    }
  }

  /* instrument ignore next */
  private checkImmersive(): boolean {
    let winMode: WindowStatusType = getScreen().getWindowStatusType();
    return winMode === window.WindowStatusType.FULL_SCREEN || winMode === window.WindowStatusType.MAXIMIZE;
  }

  protected onDeleteUIFirst(): void {
    Log.info(TAG, `onDeleteUIFirst uri: ${this.curItem?.uri}`);
    this.processDeleteStartEvent();
    this.onDeleteLast();
    this.getBrowserController().dataSource?.getAlbumDataSource()?.invalidUris.push(this.curItem?.uri);
    try {
      let dataSourceLength = this.getBrowserController().dataSource?.getAlbumDataSource()?.items.length ?? 0 - 1;
      for (let i = dataSourceLength; i >= 0; i--) {
        const item = this.getBrowserController().dataSource?.getAlbumDataSource()?.items[i];
        if (item && item.uri === this.curItem?.uri) {
          this.getBrowserController().dataSource?.getAlbumDataSource()?.items.splice(i, 1);
        }
      }
    } catch (e) {
      Log.error(TAG, `print onDeleteUIFirst log info err ${e}`);
    }
    this.getBrowserController().dataSource?.getAlbumDataSource()?.emitCountUpdateCallbacks();
  }

  /**
   * 删除最后一张图回调
   */
  protected onDeleteLast(): void {
  }

  /**
   * Swiper 数据重新加载回调
   * @returns 是否打断子类后续逻辑
   */
  protected onDataReload(addCount?: number): void {
    this.isSlideBarShow = this.isSlideBarVisibility();
    this.listColumnModifier.updateVisibility(this.isSlideBarShow ? Visibility.Visible : Visibility.Hidden);
  }

  /**
   * 执行移除动画
   */
  protected doDeletePhotoAnimation(uiContext: UIContext): void {
    TraceControllerUtils.startTrace('CUSTOM_ANIMATOR_deletePhotoAnimate');
    this.appBroadCast.emit(BrowserConstants.ITEM_BLUR_CHANGE, []);
    if (!this.stateMachine.isPropertiesShow()) {
      this.broadCast?.emit(BroadCastConstants.RESET_TO_IMAGE_SLIDE_INIT_STATE, []);
    }
    this.deleteItemPath = this.curItem.path;
    uiContext.animateTo({
      delay: AppStorage.get('isDoingRecoverBigPhotoAnim') ? 150 : BrowserConstants.DELETE_ANIM_DELAY,
      duration: PhotoItem.DELETE_PHOTO_ANIM_DURATION + Swipes.DELETE_OFFSET_DURATION, // 删除动画结束回调时长
      curve: Swipes.DELETE_PHOTO_CURVE, // 减速曲线参数
      onFinish: (): void => {
        TraceControllerUtils.finishTrace('CUSTOM_ANIMATOR_deletePhotoAnimate');
        this.onFinishDeletePhotoAnimation();
      }
    }, (): void => {
      this.onUpdateDeletePhotoAnimation();
    });
  }

  /**
   * 刷新移除动画参数
   */
  protected onUpdateDeletePhotoAnimation(): void {
    Log.info(TAG, `onUpdateDeletePhotoAnimation, isDeleting: ${this.getIsDeleting()}`);
    this.setIsDoDeleteAnim(true);
    if (this.getIsDeleting()) {
      this.setIsFrameExpand(false);
      this.getBrowserController().dataSource.deleteData(this.getCurrentIndex());
      this.handleSlideLeft();
      if (DeviceInfo.isPc()) {
        // 删除完成之前拿到对应方向的下一张图片
        /* instrument ignore next */
        let picNextItem: MediaItem | undefined = this.thumbSource?.getData(this.getCurrentIndex())?.item;
        /* instrument ignore if */
        if (picNextItem) {
          LocalStorage.getShared()?.setOrCreate<MediaItem>('pcHistogramNextItem', picNextItem);
        }
      }
      this.setForceRefresh(this.getForceRefresh() + 1);
      this.setScrollSnap(ScrollSnapAlign.CENTER);
      this.setListEdgeEffect(EdgeEffect.Spring);
    }
    this.handleWithLastItem();
    this.setIsDeleting(false);
  }

  protected notifyDeletePhoto(): void {
    this.appBroadCast.emit(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, [this.getCurrentIndex(), true]);
  }

  protected handleSlideLeft(): void {
    // 往左滑 补位
    if (!this.getIsPositiveSliding() && this.getCenterIndex() !== 0) {
      // 左侧图片补位
      this.thumbSource?.getData(this.getCurrentIndex() - 1);
      this.setCenterIndex(this.getCenterIndex() <= 0 ? 0 : this.getCenterIndex() - 1);
      let currentIndex: number = this.getCurrentIndex();
      currentIndex = currentIndex <= 0 ? 0 : currentIndex - 1;
      this.getBrowserController().setCurrentIndex(currentIndex);
      this.smallScroller?.scrollToIndex(this.getCurrentIndex(), false, ScrollAlign.CENTER);
    } else {
      // 右侧图片补位 currentIndex不发生改变，仅更新数据
      let data = this.thumbSource?.getData(this.getCurrentIndex());
      this.setVideoCoverFrame([]);
      // item在同时收起和展开，有时会存在scroll有滚动，导致选中项非下一个
      this.smallScroller.scrollToIndex(this.getCurrentIndex(), false, ScrollAlign.CENTER);
      this.appBroadCast.emit(BroadCastConstants.UPDATE_VIDEO_WIDTH + data?.item?.uniqueId,
        [AvPlayConstants.COVER_FRAME_NUM * this.selectedSmallImgWidth]);
    }
  }

  protected handleWithLastItem(): void {
    if (this.getCurrentIndex() === this.getBrowserController().dataSource.totalCount()) {
      const currentIndex: number = this.getCurrentIndex() - 1;
      this.getBrowserController().setCurrentIndex(currentIndex);
      Log.info(TAG, `last item currentIndex = currentIndex - 1, currentIndex:${currentIndex}`);
    }

    if (this.getCurrentIndex() >= 0 &&
      this.getCurrentIndex() < (this.getBrowserController().dataSource.totalCount() ?? 0)) {
      const curItemResult: MediaItem | undefined =
        this.getBrowserController().dataSource?.getMediaItemWithoutCache(this.getCurrentIndex());
      if (curItemResult) {
        this.setCurrentDisplayItem(curItemResult);
        Log.info(TAG, `animateTo closure ->${this.getCurrentIndex()} ${this.currentUri}->${this.curItem.uri}`);
        this.currentUri = this.curItem.uri;
      }
    }
  }

  /**
   * 完成移除动画参数
   */
  protected onFinishDeletePhotoAnimation(): void {
    this.notifyDeletePhoto();
    Log.info(TAG, `isDoingDeleteAnim: ${this.getIsDoingDeleteAnim()}`);
    this.processDeleteEndEvent();
    AppStorage.setOrCreate<boolean>('isDoingRecoverBigPhotoAnim', false);
    this.setIsDoingDeleteAnim(false);
    let totalCount = this.getBrowserController().dataSource.totalCount();
    this.setIsDoDeleteAnim(false);

    if (!this.getBrowserController().isSandboxEnv) {
      this.getBrowserController().dataSource.onDataChanged(this.getCurrentIndex());

      // 直接更新后两张图片，保证缓存数量足够
      if (this.getCurrentIndex() + 1 < totalCount) {
        this.getBrowserController().dataSource.onDataChanged(this.getCurrentIndex() + 1);
      }
      if (this.getCurrentIndex() + 2 < totalCount) {
        this.getBrowserController().dataSource.onDataChanged(this.getCurrentIndex() + 2);
      }
    }
    this.setForceRefresh(this.getForceRefresh() + 1);
  }

  /**
   * 更新数据宽度和边距
   */
  public updateDataSourceMarginAndWidth(): boolean {
    TraceControllerUtils.startTrace('updateDataSourceMarginAndWidth');
    let index = this.getCenterIndex();
    let shrinkFactor = this.getShrinkFactor();
    let isTouching = this.stateMachine.isTouching();
    let startIndex = this.startTouchIndex ?? 0;
    // 跟手的位移占屏幕宽度的比
    let winWidth = ScreenManager.getInstance().getWinWidth();
    let percent = this.getCurBigOffset() / winWidth;
    let forceRefresh = this.getForceRefresh();
    if (this.lastResult.index !== index || this.lastResult.shrinkFactor !== shrinkFactor ||
      this.lastResult.isTouching !== isTouching || this.lastResult.startIndex !== startIndex ||
      this.lastResult.percent !== percent || this.lastResult.forceRefresh !== forceRefresh) {
      this.lastResult.index = index;
      this.lastResult.shrinkFactor = shrinkFactor;
      this.lastResult.isTouching = isTouching;
      this.lastResult.startIndex = startIndex;
      this.lastResult.percent = percent;
      this.lastResult.forceRefresh = forceRefresh;
    } else {
      TraceControllerUtils.finishTrace('updateDataSourceMarginAndWidth');
      return true;
    }
    Log.info(TAG, `updateDataSourceMarginAndWidth index:${index},shrinkFactor:${shrinkFactor},\
      isTouching:${isTouching},startIndex:${startIndex},percent:${percent}`);
    this.thumbSource?.updateIndexWidthMargin(index, shrinkFactor, isTouching, startIndex, percent);
    TraceControllerUtils.finishTrace('updateDataSourceMarginAndWidth');
    return false;
  }

  /**
   * 修改 Swiper 切图动效执行时长
   *
   * @param value 更新后 Swiper 动效执行时长
   */
  /* instrument ignore next */
  private onChangeSwiperDuration(value: number): void {
    Log.debug(TAG, `change duration start ${value}`);
    this.mDuration = value;
  }

  /* instrument ignore next */
  private videoScrollToStart(): void {
    let startOffset: number = this.getStartOffset() - this.selectedSmallImgWidth + Constants.PREVIEW_PROGRESS_WIDTH / 2;
    this.smallScroller?.scrollTo({ xOffset: startOffset, yOffset: 0 })
    this.setIsVideoToEnd(false);
    Log.info(TAG, `videoScrollToStart xOffset: ${startOffset} progressRawTime: ${this.progressRawTime}`)
  }

  private resetVideoFrameBeforeEdit(): void {
    this.resetVideoFrame();
    this.smallScroller?.scrollToIndex(this.getCurrentIndex(), false, ScrollAlign.CENTER);
    this.setPreviewProgressOffset(0);
    this.appBroadCast.emit(BroadCastConstants.UPDATE_VIDEO_WIDTH + this.curItem.uniqueId,
      [AvPlayConstants.COVER_FRAME_NUM * this.selectedSmallImgWidth]);
  }

  /**
   * 重置视频播放状态
   */
  protected resetVideoFrame(): void {
    this.setIsFrameExpand(false);
    this.setScrollSnap(ScrollSnapAlign.CENTER);
  }

  /**
   * 重置播放状态
   */
  protected jumpStart(): void {
    Log.info(TAG, `jumpStart this.currentIndex ${this.getCurrentIndex()}  this.centerIndex ${this.getCenterIndex()}`);
    if (this.getCurrentIndex() !== this.getCenterIndex()) {
      if (this.getIsFrameExpand()) {
        /* instrument ignore next */
        this.setStartOffset(this.getStartOffset() + (ImageUtil.getSmallImgWidth() + Constants.LIST_ITEM_SPACE) *
          (this.getCurrentIndex() - this.getCenterIndex()));
        /* instrument ignore next */
        this.videoProgressScrollToByDuration(0);
        /* instrument ignore next */
        this.isItemChange = true;
      } else {
        this.smallScroller.scrollToIndex(this.getCurrentIndex(), false, ScrollAlign.CENTER);
      }
    }
  }

  /**
   * 初始化起始偏移值
   */
  public initStartOffset(): void {
    this.setStartOffset(this.getCurrentOffset());
    try {
      Log.info(TAG, `initStartOffset start startOffset :${this.getStartOffset()}
        isFrameExpand :${this.getIsFrameExpand()}
        smallScrollerOffset: ${this.smallScrollerOffset()}
        smallScrollerRectX: ${this.smallScroller?.getItemRect(this.getCurrentIndex())?.x}`);
    } catch (e) {
      Log.error(TAG, `print startOffset log info err ${e}`);
    }
  }

  /**
   * 获取初始偏移值
   *
   * @returns 初始偏移值
   */
  protected getCurrentOffset(): number {
    let offset: number = 0;
    try {
      if (i18n.isRTL(i18n.System.getSystemLanguage())) {
        /* instrument ignore next */
        offset = this.smallScrollerOffset() + this.windowLayoutWidth -
          (this.smallScroller?.getItemRect(this.getCurrentIndex())?.x || 0) -
          this.selectedSmallImgWidth * this.frameNum + this.selectedSmallImgWidth - this.windowLayoutWidth / 2
      } else {
        offset = this.smallScrollerOffset() + this.selectedSmallImgWidth - this.windowLayoutWidth / 2 +
          (this.smallScroller?.getItemRect(this.getCurrentIndex())?.x || 0);
      }
    } catch (e) {
      Log.info(TAG, ` getCurrentOffset err ${e}`);
    }
    return offset;
  }

  private smallScrollerOffset(): number {
    return this.smallScroller?.currentOffset()?.xOffset || 0;
  }

  /* instrument ignore next */
  public videoFrameClickAction(uri?: string, clickedPlay?: boolean): void {
    if (!this.getIsShowVideo()) {
      this.setIsVideoPlaying(false);
      this.frameExpandListScroll();
    }
    // 点击播放按钮同步展开
    if (clickedPlay) {
      this.frameExpandListScroll();
    }
    // 根据视频时长，决定取帧数量。拟合曲线：count = 2.8958ln(x) + 0.5016; x为视频时长，单位秒。
    this.frameNum = Math.floor(AvPlayConstants.CON1 * Math.log(this.getCapsuleTotalDurationMs() /
    AvPlayConstants.A_THOUSAND) + AvPlayConstants.CON2);
    this.frameNum = this.frameNum < AvPlayConstants.MIN_FRAME_NUM ? AvPlayConstants.MIN_FRAME_NUM : this.frameNum;
    if (!this.frameNum) {
      this.frameNum = AvPlayConstants.MIN_FRAME_NUM;
    }
    Log.info(TAG, ` click cover frame to expand and fetch all frames progressRawTime : ${this.progressRawTime}`);
    this.setIsFrameExpand(true);
    this.setTimeCapsuleRawTime(this.progressRawTime);
    this.showTimeCapsule();
    this.setScrollSnap(ScrollSnapAlign.NONE);
    this.setListEdgeEffect(EdgeEffect.None);
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
   * 调整list的滚动
   */
  /* instrument ignore next */
  private scrollForList(): void {
    if (this.getIsVideoPlaying()) {
      let xOffset: number = this.getStartOffset() - this.selectedSmallImgWidth + Constants.PREVIEW_PROGRESS_WIDTH / 2 +
        (this.progressRawTime / this.getCapsuleTotalDurationMs()) *
          (this.selectedSmallImgWidth * this.frameNum - Constants.PREVIEW_PROGRESS_WIDTH);
      Log.info(TAG, `animatorForList onFrame callback begin: ${xOffset}`);
      this.smallScroller?.scrollTo({ xOffset: xOffset, yOffset: 0 });
    }
  }

  private frameExpandListScroll(): void {
    animateTo({
      curve: BrowserConstants.CLICK_PLAY_FRAME_EXPAND_LIST_CURVE,
    }, () => {
      this.smallScroller?.scrollBy(-this.selectedSmallImgWidth + Constants.PREVIEW_PROGRESS_WIDTH / 2, 0);
    })
  }

  private currentDeleteIDChange(uniqueId: string): void {
    Log.info(TAG, `Change currentDeleteID: ${uniqueId}`);
    this.setCurrentDeleteID(uniqueId);
  }

  private initVideoPlay(videoPlayController: VideoPlayController): void {
    this.videoPlayController = videoPlayController;
  }

  private updateProgressRawTime(rawTime: number): void {
    Log.debug(TAG, `${BrowserConstants.TAG_VIDEO_PLAY_BY_FRAME}, progressRawTime: ${this.progressRawTime}, ` +
      `rawTime is ${rawTime}, expectedProgressRawTime: ${this.expectedProgressRawTime}`);
    if ((this.expectedProgressRawTime - rawTime < MAX_ALLOWED_DELAY_TIME ||
      (rawTime === 0 && this.expectedProgressRawTime !== 0)) && this.waitingForTimeSync) {
      /* instrument ignore next */
      Log.debug(TAG, `${BrowserConstants.TAG_VIDEO_PLAY_BY_FRAME} , set waitingForTimeSync as false`);
      /* instrument ignore next */
      this.waitingForTimeSync = false;
    }
    if (this.isFingerSlide || this.waitingForTimeSync) {
      /* instrument ignore next */
      return;
    }
    if (this.isShowBar && this.getCapsuleTotalDurationMs()) {
      this.setPreviewProgressOffset((this.selectedSmallImgWidth * 2 - Constants.PREVIEW_PROGRESS_WIDTH) *
        rawTime / this.getCapsuleTotalDurationMs());
    }
    this.progressRawTimeDuration = rawTime - this.progressRawTime;
    this.setProgressRawTime(rawTime);
    Log.info(TAG, `${BrowserConstants.TAG_VIDEO_PLAY_BY_FRAME}, progressRawTimeDuration: ` +
      `${this.progressRawTimeDuration}, duration: ${this.getCapsuleTotalDurationMs()}, video: ${this.curItem?.uri}`);
  }

  /**
   * back事件处理
   */
  protected onBackPressEvent(): void {
  }

  private videoStatusReported(state: media.AVPlayerState): void {
    this.setStateReported(state);
  }

  public onDestroy(): void {
    this.costReportManager.report();
    // 大图浏览结束时，浏览大图打点数据重置
    this.costReportManager.resetCostInfo();
    this.stateMachine.unregisterStateChangeListener(this);
    this.unregisterBroadCast();
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    AppStorage.setOrCreate<boolean>('isBigPhotoLeftToRightAnim', false);
  }

  /**
   * 逐帧播放：展示时间胶囊
   */
  public showTimeCapsule(): void {
    Log.info(TAG, `showTimeCapsule isVideoPlaying: ${this.getIsVideoPlaying()}, isFingerSlide: ${this.isFingerSlide},
     timeCapsuleTimeoutID: ${this.timeCapsuleTimeoutID} `)
    this.isShowTimeCapsule = true;
    if (this.timeCapsuleTimeoutID !== 0) {
      clearTimeout(this.timeCapsuleTimeoutID)
      this.timeCapsuleTimeoutID = 0;
    }
    this.timeCapsuleTimeoutID = setTimeout((): void => {
      this.isShowTimeCapsule = false;
    }, AvPlayConstants.TIME_CAPSULE_DURATION)
  }

  /**
   * 逐帧播放：展开后根据进度上报回调控制list的移动
   */
  /* instrument ignore next */
  private onChangeProgressRawTime(): void {
    this.setTimeCapsuleRawTime(this.progressRawTime);
    if (this.getIsFrameExpand() && this.isShowBar) {
      if (!this.getIsVideoPlaying() && !this.isFingerSlide && this.isExpandFinish) {
        this.videoProgressScrollTo();
      }
      if (this.getCapsuleTotalDurationMs() - this.progressRawTime < Constants.SEEK_ALLOWABLE_OFFSET_TIME) {
        this.setIsVideoToEnd(true);
      } else {
        this.setIsVideoToEnd(false);
      }
    }
  }

  public updateVideoPlayState(): void {
    if (!this.getIsFrameExpand()) {
      return;
    }
    if (!this.getIsVideoPlaying()) {
      Log.info(TAG, `onVideoPlayChange progressRawTime: ${this.progressRawTime} isFingerSlide: ${this.isFingerSlide}`)
      if (this.progressRawTime == 0) {
        this.isFingerSlide = false;
        this.videoPlayController?.updateFingerSlide(false);
      }
      if (this.progressRawTime == this.getCapsuleTotalDurationMs()) {
        Log.info(TAG, `onVideoPlayChange startOffset: ${this.getStartOffset()}`)
      }
      return;
    }
  }

  /**
   * 编辑状态改变
   */
  public onEditorShownChange(): void {
  }

  /**
   * 更新 currentIndex，并触发图片数据重新加载
   *
   * @param index 图片 index 信息
   */
  protected onGetItemIndexByUri(index: number): void {
    Log.info(TAG, `onGetItemIndexByUri: this.currentIndex = ${this.getCurrentIndex()}, index = ${index}`);
    if (index !== Constants.NOT_FOUND) {
      this.thumbSource?.getData(this.getCurrentIndex());
      this.thumbSource?.getData(index);
      this.thumbSource?.thumbSourcePartGetData(this.getCurrentIndex(), index);
      this.getBrowserController().setCurrentIndex(index);
    }
    this.getBrowserController().dataSource.onDataReloaded();
  }

  /**
   * 预览条动效参数
   *
   * @returns 动效参数
   */
  public makePreviewBarTransition(): TransitionEffect {
    return TransitionEffect.scale({
      // 缩放比例
      x: 1,
      y: 1,
    }).animation({
      duration: PhotoItem.PULL_DOWN_ITEM_ANIM_DURATION,
      curve: Swipes.DELETE_PHOTO_CURVE,
      delay: 0,
      playMode: PlayMode.Normal,
    }).combine(
      TransitionEffect.OPACITY.animation({ duration: PhotoItem.PULL_DOWN_ITEM_ANIM_DURATION })
    )
  }

  public convertTimeToSecond(milliseconds: number, isDuration: boolean = false): string {
    if (!Number.isFinite(milliseconds) || Number.isNaN(milliseconds) || milliseconds < 0) {
      return '00:00';
    }
    if (isDuration) {
      if (milliseconds <= 0) {
        return '00:00';
      }
      if (milliseconds <= AvPlayConstants.A_THOUSAND) {
        /* instrument ignore next */
        return '00:01';
      }
    }
    let second: number = Math.floor(milliseconds / AvPlayConstants.A_THOUSAND % AvPlayConstants.VIDEO_FPS_60);
    let minute: number = Math.floor(milliseconds / AvPlayConstants.A_THOUSAND / AvPlayConstants.VIDEO_FPS_60);
    return this.fillZero(minute) + `:${this.fillZero(second)}`;
  }

  private fillZero(time: number): string {
    if (time < AvPlayConstants.TEN) {
      return `0${time}`;
    } else {
      return time.toString()
    }
  }

  /**
   * 时间胶囊/逐帧条使用的总时长（外部分享等场景下 curItem.duration 可能为 NaN）
   */
  public getCapsuleTotalDurationMs(): number {
    if (this.resolvedVideoDurationCapsuleMs > 0) {
      return this.resolvedVideoDurationCapsuleMs;
    }
    const item: MediaItem = this.curItem;
    const d: number = item.duration;
    return Number.isFinite(d) && !Number.isNaN(d) ? d : 0;
  }

  private onVideoDurationResolved(args: Object[]): void {
    if (!args || args.length < 2) {
      return;
    }
    const uniqueId = args[0] as string;
    const durationMs = args[1] as number;
    if (!uniqueId || durationMs <= 0 || this.curItem.uniqueId !== uniqueId) {
      return;
    }
    this.resolvedVideoDurationCapsuleMs = durationMs;
  }

  public setCurrentDisplayItem(item: MediaItem): void {
    this.resolvedVideoDurationCapsuleMs = 0;
    this.curItem = item;
  }

  // 图片点击事件
  public smallImgClickAction(uri?: string): void {
    if (this.skipReactClickAction(uri)) {
      return;
    }
    let index: number = this.getBrowserController().dataSource.getDataIndexByUri(uri);
    this.setProgressRawTime(0);
    this.isFingerSlide = false;
    this.videoPlayController?.updateFingerSlide(false);
    this.setIsFrameExpand(false);
    this.setScrollSnap(ScrollSnapAlign.CENTER);
    this.setListEdgeEffect(EdgeEffect.Spring);
    Log.info(TAG, `thumbnail click, startIndex:${this.getCurrentIndex()} endIndex:${index}`);

    this.setPropertiesState(false);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, [this.getCurrentIndex()]);
    this.appBroadCast.emit(BroadCastConstants.ON_LEAVE_CURRENT_WINDOW, [this.getCurrentIndex()]);
    let msg: CountMsg = {
      type: BigDataConstants.PHOTO_THUMBNAIL,
      count: Math.abs(index - this.tempIndex),
    };
    ReportToBigDataUtil.report(BigDataConstants.THUMBNAIL_CLICK_COUNT_ID, msg);
    if (this.curItem && this.curItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      this.smallImgAni();
    }
    let mediaItem: MediaItem | undefined = this.getBrowserController().dataSource?.getItemByUri(uri);
    if (mediaItem?.getIsMovingPhoto()) {
      Global.setString('previewClickMovingPhoto', uri);
    }
    this.getBrowserController().setCurrentIndex(index);
    this.tempIndex = index;
  }

  /**
   * 逐帧播放：点击预览条时的收起动效
   */
  private smallImgAni(): void {
    this.isFrameShrinkAni = true;
    animateTo({
      duration: AvPlayConstants.ANI_DURATION,
      curve: Curve.Friction,
      onFinish: () => {
        this.isFrameShrinkAni = false
        this.setIsFrameExpand(false);
      }
    }, () => {
      this.appBroadCast.emit(BroadCastConstants.UPDATE_VIDEO_WIDTH + this.curItem.uniqueId,
        [ImageUtil.getSmallImgWidth()]);
    })
  }

  /**
   * 是否跳过响应点击事件
   *
   * @param uri 点击目标
   * @returns true 跳过
   */
  protected skipReactClickAction(uri?: string): boolean {
    // return uri === undefined || uri === '' || this.getBrowserController().dataSource === undefined;
    return false
  }

  /**
   * 解除注册事件监听
   */
  protected unregisterBroadCast() {
    this.broadCast?.off(BroadCastConstants.ON_DELETE_UI_FIRST, this.onDeleteUIFirstFunc);
    this.broadCast?.off(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadFunc);
    this.broadCast?.off(BroadCastConstants.CHANGE_SWIPER_DURATION, this.onChangeSwiperDurationFunc);
    this.broadCast?.off(BrowserConstants.VIDEO_SCROLL_TO_START, this.videoScrollToStartFunc);
    this.broadCast?.off(BrowserConstants.RESET_VIDEO_FRAME_BEFORE_EDIT, this.resetVideoFrameBeforeEditFunc);
    this.broadCast?.off(BroadCastConstants.PLAY_ICON_CLICK_FRAME_EXPAND, this.clickPlayVideoFrameExpandFunc);

    this.appBroadCast.off(BroadCastConstants.CURRENT_DELETE_UNIQUEID, this.currentDeleteIDFunc);
    this.appBroadCast.off(BroadCastConstants.INIT_VIDEO_PLAY_CONTROLLER, this.initVideoPlayFunc);
    this.appBroadCast.off(BroadCastConstants.UPDATE_PROGRESS_RAW_TIME, this.updateProgressRawTimeFunc);
    this.appBroadCast.off(BroadCastConstants.BACK_PRESS_CENTER, this.backPressEventFunc);
    this.appBroadCast.off(BroadCastConstants.VIDEO_DURATION_RESOLVED, this.onVideoDurationResolvedFunc);
    this.appBroadCast.off(BroadCastConstants.VIDEO_STATUS_REPORTED, this.videoStatusReportedFunc);
  }

  /* instrument ignore next */
  public isFrameExpandChanged(): void {
    if (!this.getIsFrameExpand() && !this.targetStatusOnCloudFrame) {
      this.targetStatusOnCloudFrame = undefined;
    }
  }

  /**
   * 翻页执行
   *
   * @param index 当前页面
   */
  public onSwiperChange(index: number, isInSwiperAnimation: boolean,
    verifyPhotoScaledFunc?: (matrix?: Matrix4.Matrix4Transit) => void) {
    if (this.isItemChange) {
      this.isItemChange = false;
      return;
    }
    this.setVideoCoverFrame([]);
    if (index != this.getCurrentIndex() && this.getIsFrameExpand()) {
      this.setIsFrameExpand(false);
    }
    Log.info(TAG, `swiper onChange index: ${index} isDoGestureSwipe: ${this.isOnSwiperAnimation()}`);
    this.costReportManager.switch();
    this.statisticRptMgr.switch();
    this.appBroadCast.emit(BrowserConstants.REQUEST_QUALITY_IMAGE, [index]);
    this.broadCast?.emit(BrowserConstants.PHOTO_RESET_ROTATION + this.curItem.uniqueId, []);
    if (this.isPropertiesShow()) {
      interface Msg {
        uri: string;
        type: string;
      }

      // let msg: Msg = {
      //   uri: this.getBrowserController().dataSource.getDataWithoutCache(index)?.item?.uri ?? '',
      //   type: BigDataConstants.PHOTO_DETAIL_SWIPER,
      // }
      // ReportToBigDataUtil.report(BigDataConstants.PHOTO_DETAIL_OPEN_COUNT, msg);
    }
    if (this.getCurrentIndex() - index === 1) {
      AppStorage.setOrCreate<boolean>('isBigPhotoLeftToRightAnim', true);
    } else if (this.getCurrentIndex() - index === -1) {
      AppStorage.setOrCreate<boolean>('isBigPhotoLeftToRightAnim', false);
    }
    if (DeviceInfo.isPc()) {
      this.setIsPositiveSliding(this.getCurrentIndex() - index === -1);
    }

    if (this.mDuration !== 0 && !this.getIsScrolling()) {
      const imageSize: number = this.curItem.width * this.curItem.height;
      Log.info(TAG, `geometryTransitionId updateCurrent ${index}, imageSize ${imageSize}`);
      this.getBrowserController().dataSource?.updateCurrent(index);
      clearTimeout(this.swiperTimer);
      let isInFastScrollMode: boolean | undefined = AppStorage.get<boolean>(Constants.APP_STORAGE_KEY_IS_IN_FAST_MODE);
      //如果是连续快速滑动场景，原图时间加载延迟500ms，否则维持原始的
      if (imageSize >= PRELOAD_MAX_SIZE * PRELOAD_MAX_SIZE || isInFastScrollMode) {
        const swiperTimerDelay = isInFastScrollMode ? FAST_SCROLL_INTERVAL_MS : 200;
        if (!DeviceInfo.isPc() || !isInSwiperAnimation) {
          this.getBrowserController().onIndexChange(index, false);
        }
        this.swiperTimer = setTimeout(() => {
          this.getBrowserController().updatePixMapDataSource();
        }, swiperTimerDelay);
      } else if (!DeviceInfo.isPc() || !isInSwiperAnimation) {
        this.getBrowserController().onIndexChange(index, true);
      }
      verifyPhotoScaledFunc?.(undefined);
    }
    let curItemResult: MediaResult | undefined =
      this.getBrowserController().dataSource.getDataWithoutCache(this.getCurrentIndex());
    if (curItemResult?.item && curItemResult) {
      this.setCurrentDisplayItem(curItemResult.item);
      // if (DeviceInfo.isPc()) {
      //   this.getPCImageCompleteValue();
      // }
    }
    // onChange事件释放超大图
    this.getBrowserController().dataSource?.photoDataAdapter?.clearCache(this.curItem?.uri);
    //swiper index变化时立即触发
    this.appBroadCast.emit(BroadCastConstants.SWIPER_INDEX_CHANGED, [index]);
    if (this.curItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      this.videoFrameOnchange();
    }
  }

  public getPCImageCompleteValue(): void {
    this.setPcCurItem(this.curItem);
    this.imageList.forEach(ele => {
      if (ele.index === this.getCurrentIndex()) {
        LocalStorage.getShared()?.setOrCreate<number>('pcImageCompleteWidth', ele.imageCompleteWidth);
        LocalStorage.getShared()?.setOrCreate<number>('pcImageCompleteHeight', ele.imageCompleteHeight);
      }
    });
  }

  /**
   * 逐帧播放：大图onchange，翻完之后主缩略图逐渐展开动效
   */
  private videoFrameOnchange(): void {
    this.setIsPreviewBarAnimation(false);
    // 非xxx翻完之后起一个动效，逐渐改变centerVideoPreviewWidth
    this.setIsFrameOpenAni(true);
    animateTo({
      duration: AvPlayConstants.ANI_DURATION,
      curve: Curve.Friction,
      onFinish: () => {
        this.initStartOffset();
        this.setIsFrameOpenAni(false);
      }
    }, () => {
      this.appBroadCast.emit(BroadCastConstants.UPDATE_VIDEO_WIDTH + this.curItem.uniqueId,
        [AvPlayConstants.COVER_FRAME_NUM * this.selectedSmallImgWidth]);
    })
    this.setAnchorDirection(AnchorDirection.HEADER);
  }

  public onGestureSwipe(index: number, extraInfo: SwiperAnimationEvent) {
    if (DeviceInfo.isPc() && this.getBrowserController().isDetailSelected) {
      this.appBroadCast?.emit(BroadCastConstants.TURN_LEFT_OR_RIGHT_ITEM_CLICKED, []);
    }
    if (this.isFromPortraitCoverSet) {
      return;
    }
    this.appBroadCast.emit(BroadCastConstants.CAST_UPDATE_GESTURE, [index, extraInfo]);
    this.swiperDepthByHand(extraInfo.currentOffset);
    this.processSwiperGestureEvent(index, extraInfo);
    this.setAnalyzerVisibility(Visibility.Hidden);
    this.isImageAnalyzePaused = true;

    this.handleThumbList(index, extraInfo);
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

  protected swiperDepthByHand(currentOffset: number): void {
    this.setSwiperDirection(currentOffset > 0 ? SwiperDirection.RIGHT : SwiperDirection.LEFT);
  }

  /**
   * 逐帧播放：大图跟手时动效锚点设置
   */
  protected videoFrameOnGesture(extraInfo: SwiperAnimationEvent): void {
    // 左滑：负值；右滑：正值
    if (extraInfo.currentOffset <= 0) {
      // 左滑，锚点在左
      this.setAnchorDirection(AnchorDirection.HEADER);
    } else {
      // 右滑，锚点在右
      this.setAnchorDirection(AnchorDirection.FOOTER);
    }
  }

  /**
   * 逐帧播放：大图离手时的回弹动效、及翻页成功后的收起动效
   */
  protected videoFrameAniStart(index: number, targetIndex: number): void {
    if (!this.getIsFrameExpand()) {
      this.appBroadCast.emit(BroadCastConstants.UPDATE_VIDEO_WIDTH + this.curItem.uniqueId, [targetIndex === index ?
        2 * this.selectedSmallImgWidth : this.smallImgLow]);
    } else {
      this.appBroadCast.emit(BroadCastConstants.UPDATE_VIDEO_WIDTH + this.curItem.uniqueId, [targetIndex === index ?
        this.frameNum * this.selectedSmallImgWidth : this.smallImgLow]);
    }
    if (this.photoChanged || !this.getIsFrameExpand()) {
      this.smallScroller.scrollToIndex(targetIndex, false, ScrollAlign.CENTER);
    }
  }

  public onAnimationStart(index: number, targetIndex: number, extraInfo: SwiperAnimationEvent): void {
    this.appBroadCast.emit(BroadCastConstants.CAST_INDEX_CHANGED, [targetIndex]);
    this.setIsScrolling(false);
    this.setSwiperDirection(SwiperDirection.DEFAULT);
    clearTimeout(this.swiperTimer);
    this.setAnalyzerVisibility(Visibility.Hidden);
    this.isImageAnalyzePaused = true;
    this.processSwiperAnimationStartEvent(index, targetIndex, extraInfo);
    this.onSwiperAnimationAniStart(index, targetIndex, extraInfo);
    // if (DeviceInfo.isPc() && this.photoChanged) {
    //   let data = this.getBrowserController().dataSource.getMediaItemWithoutCache(targetIndex);
    //   if (data) {
    //     LocalStorage.getShared()?.setOrCreate<MediaItem>('pcHistogramNextItem', data);
    //     this.imageList.forEach(ele => {
    //       if (ele.index === targetIndex) {
    //         LocalStorage.getShared()?.setOrCreate<number>('pcImageCompleteWidth', ele.imageCompleteWidth);
    //         LocalStorage.getShared()?.setOrCreate<number>('pcImageCompleteHeight', ele.imageCompleteHeight);
    //       }
    //     });
    //   }
    // }
    // 滑动动效开始时异步触发
    if (targetIndex !== index) {
      this.appBroadCast.emit(BroadCastConstants.PHOTO_SWIPER_INDEX_CHANGED, [index]);
      this.appBroadCast.emit(BroadCastConstants.ON_LEAVE_CURRENT_WINDOW, [index]);
    }
    this.handleThumbListAniStart(index, targetIndex, extraInfo);
  }

  protected onSwiperAnimationAniStart(index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) {
  }

  protected handleThumbListAniStart(index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) {
  }

  public onAnimationEnd(index: number, extraInfo: SwiperAnimationEvent) {
    if (this.isSlideBarVisibility()) {
      if (this.curItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        AccessibilityUtil.sendFocusAccessibilityEvent(`PreviewBarItemVideo ${this.getCurrentIndex()}`);
      } else {
        AccessibilityUtil.sendFocusAccessibilityEvent(`PreviewBarItemImage ${this.getCurrentIndex()}`,
            Heic2JPGManagerAccess.isToastShowing ? Heic2JPGManagerAccess.AFTER_TOAST_DELAY : SEND_FOCUS_DEFAULT_DELAY);
      }
    }
    this.processSwiperAnimationEndEvent(index, extraInfo);
    if (!this.photoChanged) {
      this.onVisibilityChange();
      this.isImageAnalyzePaused = false;
    }
    this.handleSwiperDepthAniEnd(extraInfo);
    // thumbList start
    Log.info(TAG, `onAnimationEnd index: ${index}`);
    Log.info(TAG, `onAnimationEnd current offset: ${extraInfo.currentOffset}`);
    this.diffOffset = 0;
    this.photoChanged = false;
    // thumbList end
    this.handleFinishAnimationEnd();
  }

  private onVisibilityChange(): void {
    this.setAnalyzerVisibility(!this.getIsDoingImageSlideAnimation() && !this.isPropertiesShow() &&
      !this.getIsRunningAnimation() && !this.getIsPullDownAndDragPhoto() &&
      this.canShowImageAnalyzer && !this.getIsInAnimateToPosition() && !this.isInSelectedMode &&
      !this.isOnSwiperAnimation() ? Visibility.Visible : Visibility.Hidden);
    Log.info(TAG, `this.analyzerVisibility = ${this.getAnalyzerVisibility()}, this.currentIndex= ${
    this.getCurrentIndex()}, this.isRunningAnimation = ${
    this.getIsRunningAnimation()}, this.isPullDownAndDragPhoto = ${
    this.getIsPullDownAndDragPhoto()}, this.isInAnimateToPosition = ${
    this.getIsInAnimateToPosition()}, this.canShowImageAnalyzer = ${
    this.canShowImageAnalyzer}, this.isOnSwiperAnimation = ${this.isOnSwiperAnimation()}`);
  }

  protected handleSwiperDepthAniEnd(extraInfo: SwiperAnimationEvent) {
  }

  protected handleFinishAnimationEnd() {
  }

  public getCurrentIndex(): number {
    return this.stateMachine.getCurrentIndex();
  }

  public setCurrentIndex(index: number): void {
    this.stateMachine.setCurrentIndex(index);
  }

  public onCurrentIndexChange(currentIndex: number): void {
    Log.info(TAG, `onCurrentIndexChange ${this.stateMachine.getCurrentIndex()}`);
    this.swiperModifier.updateIndex(this.stateMachine.getCurrentIndex());
    this.jumpStart();
  }

  public onTargetIndexChange(targetIndex: number): void {
  }

  public onPropertiesStateChange(isShowProperties: boolean): void {
  }

  public onDeleteStart(): void {
  }

  public onStable(): void {
  }

  public isOnSwiperAnimation(): boolean {
    return this.stateMachine.isOnSwiperAnimation();
  }

  public setPropertiesState(isShowProperties: boolean): void {
    this.stateMachine.setPropertiesState(isShowProperties);
  }

  public isPropertiesShow(): boolean {
    return this.stateMachine.isPropertiesShow();
  }

  public isTouching(): boolean {
    return this.stateMachine.isTouching();
  }

  public processDeleteStartEvent(): void {
    this.stateMachine.processDeleteStartEvent();
  }

  public processDeleteEndEvent(): void {
    this.stateMachine.processDeleteEndEvent();
  }

  public onExitStartAnim(): void {
    if (this.browserAnimController.isTransitionEnable) {
      return;
    }
    this.swiperModifier.attribute?.disableSwipe(true);
    this.listVisible = Visibility.Hidden;
    this.playExitAnimation();
  }

  public onEnterStartAnim(): void {
    if (this.browserAnimController.isTransitionEnable) {
      return;
    }
    this.swiperModifier.attribute?.disableSwipe(false);
    this.listVisible = Visibility.Visible;
    this.playEnterAnimation();
  }

  private playExitAnimation(): void {
    Log.info(TAG, `playExitAnimation`);
    this.playAnimation(BrowserConstants.OPEN_PHOTO_CURVE, () => {
      this.listColumnModifier.updateVisibility(this.listVisible);
    });
  }

  private playEnterAnimation(): void {
    Log.info(TAG, `playEnterAnimation`);
    this.playAnimation(BrowserConstants.CLOSE_PHOTO_CURVE, () => {
      this.listColumnModifier.updateVisibility(this.listVisible);
    });
  }

  private playAnimation(curve: ICurve, callback: () => void): void {
    animateToImmediately({
      curve: curve,
    }, callback);
  }


  /**
   * 大图手指触摸滑动事件状态
   * @param index
   * @param targetIndex
   * @param extraInfo
   */
  public processSwiperGestureEvent(index: number, extraInfo: SwiperAnimationEvent): void {
    this.stateMachine.processSwiperGestureEvent(index, extraInfo);
  }

  /**
   * 大图左右滑动开始执行动效事件
   * @param index
   * @param targetIndex
   * @param extraInfo
   */
  public processSwiperAnimationStartEvent(index: number, targetIndex: number, extraInfo: SwiperAnimationEvent): void {
    this.stateMachine.processSwiperAnimationStartEvent(index, targetIndex, extraInfo);
  }

  /**
   * 大图左右滑动结束执行动效事件
   * @param index
   * @param extraInfo
   */
  public processSwiperAnimationEndEvent(index: number, extraInfo: SwiperAnimationEvent): void {
    this.stateMachine.processSwiperAnimationEndEvent(index, extraInfo);
  }

  /**
   * video expand playing, swiper areaChange List need to scroll
   */
  public listScrollSwiperAreaChange(oldWidth: number, newWidth: number) {
    if (this.curItem.mediaType !== UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      return;
    }
    if (!this.getIsFrameExpand()) {
      return
    }
    this.dismissWillScroll = true;
    Log.info(TAG, `listScroll under AreaChange, newWidth=${newWidth} oldWidth=${oldWidth}`);
    this.smallScroller.scrollBy((oldWidth - newWidth) / 2, 0);
    this.dismissWillScroll = false;
  }

  /**
   * videoProgress Calibration
   */
  public videoProgressCalibration() {
    this.initStartOffset();
    if (this.getIsFrameExpand()) {
      this.videoProgressScrollTo();
    }
  }

  public onEnterEndAnim(): void {
    this.setThumbnailViewShow(false);
  }

  public onThumbnailViewShow(): void {
    this.setThumbnailViewShow(true);
  }


}

class SwiperModifier extends AttributeUpdater<SwiperAttribute> {
  /**
   * 所在下标位置
   */
  protected index?: number;

  /**
   * 更新所在下标位置
   *
   * @param index 偏移
   */
  public updateIndex(index: number): void {
    this.index = index;
    this.attribute?.index(this.index);
  }

  applyNormalAttribute(instance: SwiperAttribute) {
  }
}