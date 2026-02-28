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
import lazy {
  ColumnSize,
  getScreen,
  WindowMode } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { EventPipeline } from '@ohos/common/src/main/ets/default/model/browser/photo/EventPipeline';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy {
  Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { PhotoAsset, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { IStateChangeListener } from '../statemachine/IPhotoBrowserState';
import lazy { PhotoBrowserStateMachine } from '../statemachine/PhotoBrowserStateMachine';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BaseAttributeUpdater } from './BaseAttributeUpdater';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { ItemStackUpdater } from './ItemStackUpdater';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { ImageUpdater } from './ImageUpdater';
import lazy { MovingPhotoUpdater } from './MovingPhotoUpdater';
import lazy { VideoUpdater } from './VideoUpdater';
import lazy { ThumbImageUpdater } from './ThumbImageUpdater';
import lazy { BrowserAnimController,
  BrowserAnimParams
} from '@ohos/common/src/main/ets/default/model/BrowserAnimController';
import lazy { UIContext } from '@ohos.arkui.UIContext';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { PhotoConfig } from '@ohos/common/src/main/ets/default/config/PhotoConfig';
import lazy { FocusCtrlManager } from '@ohos/tools/src/main/variables/FocusCtrlManager';
import lazy { MathUtil } from '@ohos/common/src/main/ets/default/utils/MathUtil';

const TAG = 'PhotoItemVM';

export const HALF_DIVIDER: number = 2;

/**
 * 除以 4 计算常数
 */
export const QUARTER_DIVIDER: number = 4;

/**
 * 最佳呈现中心比分值
 */
const CENTER_PERCENTAGE: number = 0.5;

/**
 * 最佳呈现,浅层交互一键美肤URI匿名化字符个数
 */
const ANONYMIZATION_COUNT: number = 9;

const OPACITY_DOT_99: number = 0.99;
const CENTER_POSITION: string = '50%';

const MEDIA_TYPE_MOVING_PHOTO: number = 3;
 
const ENTER_LARGE_PHOTO_FROM_CAMERA_THUMB_NAIL: number = 5;
 
const SHOOTING_MODE_TAG: string = 'shooting_mode_tag';
 
const FRONT_CAMERA: string = 'front_camera';
 
const ENTER_IMAGE_INNER_PHOTO: string = 'ENTER_IMAGE_INNER_PHOTO';
 
// 相册类型
const ALBUM_TYPE = 'albumType';
 
// 动态图片拍摄模式单独适配
const MOVING_PICTURE_SHOOTING_MODE_TAG = 20;

interface BigPhotoBrowserMsg {
  scenario: number,
  albumType: number,
  mediaType: number,
  selfie: number,
  shootModeTag: number,
}

export interface InitPhotoItemVMParam {
  item: MediaItem;
  isHorizontal: boolean;
  isThird: boolean;
  isInSelectedMode: boolean;
  isShowBar: boolean;
  eventPipeline: EventPipeline;
  uiContext: UIContext;
  onScaleAnimationEnd: (scale: number) => void;
  onPhotoChanged: () => void;
  updateAnalyzerVisibility: () => void;
  onIsOnSwiperAnimation: () => void;
  onEnterStartAnim?: () => void;
  onEnterEndAnim?: () => void;
  onExitStartAnim?: () => void;
  onExitEndAnim?: () => void;
  setIsRunningAnimationFunc: (isRunningAnimation: boolean) => void;
  updateTargetPullHeight: (imageTargetPullHeight: number) => void;
  browserAnimController: BrowserAnimController;
}

interface SaliencyMsg {
  uri: string;
  saliency: boolean
  msg: string;
}

@Observed
export abstract class PhotoItemVM implements IStateChangeListener {
  // 单属性刷新器
  public stackModifier: ItemStackUpdater | undefined = undefined;

  public highlightStackModifier: BaseAttributeUpdater<StackAttribute> = new BaseAttributeUpdater();
  public imageStackModifier: BaseAttributeUpdater<StackAttribute> | undefined = undefined;
  public thumbImageStackModifier: BaseAttributeUpdater<StackAttribute> | undefined = undefined;
  public downloadProgressRingModifier: BaseAttributeUpdater<ColumnAttribute> = new BaseAttributeUpdater();
  // 播放按钮Row动效
  public videoButtonRowModifier: BaseAttributeUpdater<RowAttribute> | undefined = undefined;
  // 小图外层column动效
  public thumbImageColumnModifier: ThumbImageUpdater | undefined = undefined;
  // 小图自身动效
  public thumbImageModifier: ThumbImageUpdater | undefined = undefined;
  // 大图动效
  public oriImageColumnModifier: ThumbImageUpdater | undefined = undefined;
  // 是否仅显示详情
  public uiContext: UIContext | undefined = undefined;
  protected isOnlyShowProperties: boolean = getScreen().getDetailShow();
  public photoPropertiesOpacity: number = 0;
  public isDragFocus: boolean = false;
  public windowLayoutWidth: number = getScreen().getWinLayoutWidth();
  public windowLayoutHeight: number = this.getWindowLayoutHeight();
  public imgHeight: number = 0;
  public imgWidth: number = 0;
  public imageSlideTargetScale: number = 0;
  public ratioOffset: number = 2;
  public propertiesIndex: number = 1;
  public windowColumns: number = getScreen().getScreenColumns();
  public isHorizontal: boolean = false;
  public clipWidthPercentage: number = 1; // 100%
  // Image pull up
  public minWidthOrHeight: number = 0;
  /**
   * 最佳呈现主体中心偏移左上角宽，[0~1]
   */
  public saliencyOffsetXPercent: number = 0;
  /**
   * 最佳呈现主体中心偏移左上角高，[0~1]
   */
  public saliencyOffsetYPercent: number = 0;
  /**
   * 最佳呈现视图视效X轴目标偏移量
   */
  public imageSlideTargetOffsetX: number = 0;
  /**
   * 最佳呈现视图视效Y轴目标偏移量
   */
  public imageSlideTargetOffsetY: number = 0;
  /**
   * 是否支持最佳视图呈现，false则按照默认方式呈现
   */
  public saliencyImageFlag: Boolean = false;
  public imageSlideTargetOffset: number = 0;
  public clipWidthTargetPercentage: number = Math.min(this.windowLayoutWidth, this.windowLayoutHeight) /
  Math.max(this.windowLayoutWidth, this.windowLayoutHeight);
  public clipColumnHeight: number | string = Constants.PERCENT_100;
  public aiBarBottomHeight: number = 0;
  public clipHeightPercentage: number = 1;
  public maxScale: number = 1.0;
  public item: MediaItem = new MediaItem();
  public isCurrent: boolean = false;
  public clipWidthStartPercentage: number = 1;
  public onScaleAnimationEnd: (scale: number) => void = (scale: number) => {
  }
  public eventPipeline: EventPipeline | undefined = undefined;
  protected isThird: boolean = false;
  private focusCtrlManager = FocusCtrlManager.getInstance();
  private mPosition: number = 0;

  private imageSlidePullUpOffset: number = 0;
  public isShowBar: boolean = false;
  protected stateMachine: PhotoBrowserStateMachine;
  public browserAnimController: BrowserAnimController = new BrowserAnimController();
  private onPhotoChanged: () => void = () => {};

  private updateTargetPullHeight: (imageTargetPullHeight: number) => void = (imageTargetPullHeight: number) => {
  }

  private isInSelectedMode: boolean = false;

  private updateAnalyzerVisibility: () => void = () => {};

  /**
   * 视图层方法，业务逻辑移动到VM层可删掉
   */
  private onIsOnSwiperAnimation: () => void = () => {};

  private isDoGestureSwipe: boolean = false;

  private isPullingDown: boolean = false;

  private imageSlideScale: number = 1;

  /**
   * 最佳呈现视图视效X轴当前偏移量
   */
  private geometrySalOffsetX: number = 0;
  /**
   * 最佳呈现视图视效Y轴当前偏移量
   */
  private geometrySalOffsetY: number = 0;
  /**
   * 图片缩放系数，在下拉跟手动效中生效
   */
  private geometryScale: number = 1;
  /**
   * 图片 x 轴方向位移，在下拉跟手动效中生效
   */
  private geometryOffsetX: number = 0;
  /**
   * 图片 y 轴方向位移，在下拉跟手动效中生效
   */
  private geometryOffsetY: number = 0;
  // 缩略图是否已加载完成
  public isThumbnailComplete: boolean = false;
  private onEnterStartAnimFunc: () => void = () => { };
  private onEnterEndAnimFunc: () => void = () => { };
  private onExitStartAnimFunc: () => void = () => { };
  private onExitEndAnimFunc: () => void = () => { };
  private setIsRunningAnimationFunc: (isRunningAnimation: boolean) => void = (isRunningAnimation: boolean) => {
  }

  constructor(stateMachine: PhotoBrowserStateMachine) {
    this.stateMachine = stateMachine;
  }

  public onCreate(param: InitPhotoItemVMParam): void {
    this.item = param.item;
    this.stackModifier = this.createUpdater();
    this.isHorizontal = param.isHorizontal;
    this.isThird = param.isThird;
    this.isShowBar = param.isShowBar;
    this.isInSelectedMode = param.isInSelectedMode;
    this.eventPipeline = param.eventPipeline;
    this.onScaleAnimationEnd = param.onScaleAnimationEnd;
    this.imageSlideTargetOffset = this.slideTargetOffset();
    this.onPhotoChanged = param.onPhotoChanged;
    this.updateTargetPullHeight = param.updateTargetPullHeight;
    this.updateAnalyzerVisibility = param.updateAnalyzerVisibility;
    this.uiContext = param.uiContext;
    this.stateMachine.registerStateChangeListener(this, true);
    this.onIsOnSwiperAnimation = param.onIsOnSwiperAnimation;
    this.setIsRunningAnimationFunc = param.setIsRunningAnimationFunc;
    if (param.onEnterStartAnim) {
      this.onEnterStartAnimFunc = param.onEnterStartAnim;
    }
    if (param.onEnterEndAnim) {
      this.onEnterEndAnimFunc = param.onEnterEndAnim;
    }
    if (param.onExitStartAnim) {
      this.onExitStartAnimFunc = param.onExitStartAnim;
    }
    if (param.onExitEndAnim) {
      this.onExitEndAnimFunc = param.onExitEndAnim;
    }
    this.browserAnimController = param.browserAnimController;
  }

  public onDestroy(): void {
    this.stateMachine.unregisterStateChangeListener(this);
  }

  public updatemPosition(mPosition: number): void {
    this.mPosition = mPosition;
  }

  public setPropertiesState(isPropertiesShow: boolean): void {
    this.stateMachine.setPropertiesState(isPropertiesShow);
    this.eventPipeline?.setIsPullingUp(isPropertiesShow);
  }

  public isPropertiesShow(): boolean {
    return this.stateMachine.isPropertiesShow();
  }

  public getCurrentIndex(): number {
    return this.stateMachine.getCurrentIndex();
  }

  public onGestureStateChange(isEnd: boolean): void {
    Log.info(TAG, `onGestureStateEnter`);
    this.onResetPullingUpState();
    this.setDoGestureSwipe(!isEnd);
  }

  public setImagePixMap = (): void =>  {
  }

  public getTargetIndex(): number {
    return this.stateMachine.getTargetIndex();
  }

  public setCurrentIndex(currentIndex: number) {
    this.stateMachine.setCurrentIndex(currentIndex);
  }

  public onCurrentIndexChange(currentIndex: number): void {
    this.onPhotoChanged();
  }

  public onTargetIndexChange(targetIndex: number): void {
  }

  protected useImageSlideScale(): boolean {
    return true;
  }

  public createAttributeModifier(): void {
    if (this.stackModifier === undefined) {
      this.stackModifier = this.createUpdater();
    }
    if (this.highlightStackModifier === undefined) {
      this.highlightStackModifier = new BaseAttributeUpdater();
    }
    if (this.imageStackModifier === undefined) {
      this.imageStackModifier = new BaseAttributeUpdater();
    }
    if (this.thumbImageStackModifier === undefined) {
      this.thumbImageStackModifier = new BaseAttributeUpdater();
    }
    if (this.thumbImageColumnModifier === undefined) {
      this.thumbImageColumnModifier = new ThumbImageUpdater();
    }
    if (this.thumbImageModifier === undefined) {
      this.thumbImageModifier = new ThumbImageUpdater();
    }
    if (this.oriImageColumnModifier === undefined) {
      this.oriImageColumnModifier = new ThumbImageUpdater();
    }
    if (this.videoButtonRowModifier === undefined) {
      this.videoButtonRowModifier = new BaseAttributeUpdater();
    }
  }

  public onPropertiesStateChange(isPropertiesShow: boolean): void {
    if (!isPropertiesShow) {
      this.resetImageSlideInitState();
    }
    this.updatePipelinePullingUpStatus();
    this.stackModifier?.updateStackScale(isPropertiesShow, this.isOnlyShowProperties, this.useImageSlideScale(),
      this.imageSlideScale, this.geometryScale);
    this.stackModifier?.updateStackOffset(isPropertiesShow, this.isOnlyShowProperties,
      { x: this.geometrySalOffsetX, y: this.geometrySalOffsetY }, { x: this.geometryOffsetX, y: this.geometryOffsetY });
    this.updateHighlightOpacity(isPropertiesShow);
    this.updateHighlightScale(isPropertiesShow);
    this.updateHighlightOffset(isPropertiesShow);
    this.updateImageStackSize(isPropertiesShow);
  }

  public setIsOnlyShowProperties(isOnlyShowProperties: boolean): void {
    if (this.isOnlyShowProperties === isOnlyShowProperties) {
      return;
    }
    this.isOnlyShowProperties = isOnlyShowProperties;
    this.stackModifier?.updateStackScale(this.stateMachine.isPropertiesShow(), this.isOnlyShowProperties,
      this.useImageSlideScale(), this.imageSlideScale, this.geometryScale);
    this.stackModifier?.updateStackOffset(this.stateMachine.isPropertiesShow(), this.isOnlyShowProperties,
      { x: this.geometrySalOffsetX, y: this.geometrySalOffsetY }, { x: this.geometryOffsetX, y: this.geometryOffsetY });
    this.updateHighlightScale(this.stateMachine.isPropertiesShow());
    this.updateHighlightOffset(this.stateMachine.isPropertiesShow());
  }

  public getOnlyShowProperties(): boolean {
    return this.isOnlyShowProperties;
  }

  public getStateMachine(): PhotoBrowserStateMachine {
    return this.stateMachine;
  }

  public onResetPullingUpState(): void {
    if (this.stateMachine.isPropertiesShow()) {
      this.toImageSlideTargetState();
    } else {
      this.initSaliencyImageSlide();
      this.resetImageSlideInitState();
    }
  }

  public updatePipelinePullingUpStatus(): void {
    this.eventPipeline?.setIsPullingUp(this.stateMachine.isPropertiesShow());
    BroadCastManager.getInstance().getBroadCast().emit(BroadCastConstants.IS_PULLING_DOWN, [this.isPullingDown]);
    this.updateAnalyzerVisibility();
    if (AppStorage.get<boolean>('isEditingWallpaper')) {
      Log.info(TAG, 'updatePipelinePullingUpStatus return');
      return;
    }
    this.updateSystemUi();
  }

  public createUpdater(): ItemStackUpdater {
    if (this.isVideo()) {
      return new VideoUpdater(this.stateMachine);
    } else if (this.isMovingPhoto()) {
      return new MovingPhotoUpdater();
    }
    return new ImageUpdater();
  }

  private isMovingPhoto(): boolean {
    if (this.item && this.item.isThumbnailMovingPhoto && !this.item.uri) {
      return true;
    }

    if (this.item && this.item.getIsMovingPhoto?.()) {
      return true;
    }

    return false;
  }

  public updateStackScale(): void {
    let isPropertiesShow = this.stateMachine.isPropertiesShow();
    this.thumbImageColumnModifier?.updateStackScale(isPropertiesShow, this.isOnlyShowProperties,
     this.useImageSlideScale(), this.imageSlideScale, this.geometryScale);
    this.stackModifier?.updateStackScale(isPropertiesShow, this.isOnlyShowProperties, this.useImageSlideScale(),
      this.imageSlideScale, this.geometryScale);
    this.updateHighlightScale(isPropertiesShow);
  }

  public updateStackOffset(): void {
    let isPropertiesShow = this.stateMachine.isPropertiesShow();
    this.thumbImageColumnModifier?.updateStackOffset(isPropertiesShow, this.isOnlyShowProperties,
      { x: this.geometrySalOffsetX, y: this.geometrySalOffsetY }, { x: this.geometryOffsetX, y: this.geometryOffsetY });
    this.stackModifier?.updateStackOffset(isPropertiesShow, this.isOnlyShowProperties,
      { x: this.geometrySalOffsetX, y: this.geometrySalOffsetY }, { x: this.geometryOffsetX, y: this.geometryOffsetY });
    this.updateHighlightOffset(isPropertiesShow);
  }

  public onDeleteStart(): void {
    this.stackModifier?.attribute?.transition(this.makeDeletePhotoTransition());
  }

  public onStable(): void {
    this.stackModifier?.attribute?.transition(this.makeNormalPhotoTransition());
  }

  private setGeometrySalOffset(x: number, y: number): void {
    this.geometrySalOffsetX = x;
    this.geometrySalOffsetY = y;
    this.updateStackOffset();
  }

  public setGeometryOffsetX(x: number): void {
    this.geometryOffsetX = x;
    this.updateStackOffset();
  }

  public setGeometryOffsetY(y: number): void {
    this.geometryOffsetY = y;
    this.updateStackOffset();
  }

  public setGeometryScale(scale: number): void {
    this.geometryScale = scale;
    this.updateStackScale();
  }

  public setImageSlideScale(scale: number): void {
    this.imageSlideScale = scale;
    this.updateStackScale();
  }

  public getImageSlideScale(): number {
    return this.imageSlideScale;
  }

  public setPullingDown(isPullingDown: boolean): void {
    this.isPullingDown = isPullingDown;
    this.updateHighlightOpacity(this.stateMachine.isPropertiesShow());
  }

  public setDoGestureSwipe(isDoGestureSwipe: boolean): void {
    this.isDoGestureSwipe = isDoGestureSwipe;
    this.updateImageStackSize(this.stateMachine.isPropertiesShow());
  }

  private updateHighlightOpacity(isPropertiesShow: boolean): void {
    this.highlightStackModifier.updateOpacity(this.isPullingDown || isPropertiesShow ? 0 : 1);
  }

  public updateHighlightScale(isPropertiesShow: boolean): void {
    if (isPropertiesShow && !this.isOnlyShowProperties) {
      this.highlightStackModifier.updateScale({ x: this.imageSlideScale, y: this.imageSlideScale });
      return;
    }
    this.highlightStackModifier.updateScale({ x: this.geometryScale, y: this.geometryScale });
  }

  public updateHighlightOffset(isPropertiesShow: boolean): void {
    if (isPropertiesShow && !this.isOnlyShowProperties) {
      this.highlightStackModifier.updateOffset({ x: this.geometrySalOffsetX, y: this.geometrySalOffsetY });
      return;
    }
    this.highlightStackModifier.updateOffset({ x: this.geometryOffsetX, y: this.geometryOffsetY });
  }

  private updateImageStackSize(isPropertiesShow: boolean): void {
    this.imageStackModifier?.updateClip(!this.isAllowPinch() ? this.isDoGestureSwipe : false);
    if (!this.isDoGestureSwipe || isPropertiesShow) {
      this.imageStackModifier?.updateWidth(Constants.PERCENT_100);
      this.imageStackModifier?.updateHeight(Constants.PERCENT_100);
      return;
    }
    this.imageStackModifier?.updateWidth('');
    this.imageStackModifier?.updateHeight('');
  }

  public initSaliencyImageSlide(): void {
    this.setGeometrySalOffset(0, 0);
  }

  public calcSaliencyImageSlide(): void {
    if (!this.saliencyImageFlag || this.isOnlyShowProperties ||
      (getScreen().getWinMode() === WindowMode.UNDEFINED)) {
      this.setGeometrySalOffset(LocalStorage.getShared()?.get<number>('geometryOffsetX') ?? 0,
        LocalStorage.getShared()?.get<number>('geometryOffsetY') ?? 0);
      return;
    }
    this.setGeometrySalOffset((Math.abs(this.getImageSlidePullUpOffset()) /
      this.imageSlideTargetOffset) * this.getSaliencyTargetOffsetX(),
      (Math.abs(this.getImageSlidePullUpOffset()) /
        this.imageSlideTargetOffset) * this.getSaliencyTargetOffsetY());
    Log.debug(TAG,
      `calcSaliencyImageSlide geometrySalOffsetX: ${this.geometrySalOffsetX}, geometrySalOffsetY: ${this.geometrySalOffsetY}`);
  }

  public toSaliencyImageSlideTargetState(): void {
    if (!this.saliencyImageFlag || this.isOnlyShowProperties || (getScreen().getWinMode() === WindowMode.UNDEFINED)) {
      this.setGeometrySalOffset(LocalStorage.getShared()?.get<number>('geometryOffsetX') ?? 0,
        LocalStorage.getShared()?.get<number>('geometryOffsetY') ?? 0);
      return;
    }
    this.setGeometrySalOffset(this.getSaliencyTargetOffsetX(), this.getSaliencyTargetOffsetY());
    Log.info(TAG, `current geometrySalOffsetXY {${this.geometrySalOffsetX}, ${this.geometrySalOffsetY}}`);
  }

  public registerBroadCast(broadCast: BroadCast): void {
  }

  public unRegisterBroadCast(broadCast: BroadCast): void {
  }

  public getWindowLayoutHeight(): number {
    return getScreen().getWinHeight();
  }

  protected abstract isDefaultWidth(): boolean;

  public isUpdateSlideTargetOffset(): boolean {
    return this.isDefaultWidth();
  }

  public isVideo(): boolean {
    return this.item && this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO;
  }

  public isReachLowestBound(winLayoutW: number): boolean {
    if (this.isDefaultWidth()) {
      this.clipWidthTargetPercentage = 1 - Constants.PROPERTIES_WIDTH / winLayoutW;
      return this.windowLayoutWidth >= winLayoutW && getScreen().isWinWidthGetToMinBound();
    }
    return false;
  }

  public disableEnterInnerPic(): boolean {
    // 场景屏蔽
    if (this.isThird) {
      Log.info(TAG, 'picker not support innerPic');
      return true;
    }

    // 大图浏览支持画中画开关
    if (!AppStorage.get(Constants.ENABLE_INNERPIC)) {
      Log.info(TAG, `innerPic not support`);
      return true;
    }

    return false;
  }

  /* instrument ignore next */
  public repeatScale(scale: number): void {
  }

  public updateSystemUi(): void {
    if (this.isThird) {
      return;
    }
    if (this.isInSelectedMode) {
      getScreen().setSystemUi(false, true, true);
      return;
    }

    if (this.isUpdateAllSystemUi() && (this.isShowBar || this.stateMachine.isPropertiesShow())) {
        getScreen().setSystemUi(false, true, false);
        return;
    }
    if (this.isShowBar) {
      getScreen().setSystemUi(true);
      return;
    }
    if (this.stateMachine.isPropertiesShow()) {
      getScreen().setSystemUi(false, true);
      return;
    }
    getScreen().setSystemUi(false, false, true);
  }

  protected isUpdateAllSystemUi(): boolean {
    return this.isHorizontal;
  }

  protected handleVideoMenu(firstMenuGroup: Action[], isVideoPlaying: boolean): void {
    firstMenuGroup.unshift(isVideoPlaying ? Action.VIDEO_PAUSE : Action.VIDEO_PLAY);
  }

  public isSmallFloating(): boolean {
    return false;
  }

  public abstract slideTargetOffset(): number;

  public abstract calculatePhotoDetailWidth(): number;

  public updateSlideOffset(): void {
    this.imageSlideTargetOffset = this.slideTargetOffset();
  }

  public initCalcClipWidth() {
    Log.info(TAG, `this.windowLayoutWidth = ${this.windowLayoutWidth},
      this.windowLayoutHeight = ${this.windowLayoutHeight}`);
    if (Math.max(this.windowLayoutWidth, this.windowLayoutHeight) === 0) {
      return;
    }

    this.clipWidthTargetPercentage = this.updateClipWidth();
    this.updateSlideOffset();
  }

  public toImageSlideTargetState(): void {
    if (!this.isOnlyShowProperties) {
      this.updateSlideOffset();
    }
    this.setImageSlidePullUpOffset(this.updateSlidePullUpOffsetState());
    this.setImageSlideScale(this.isVideo() ? 1 : this.imageSlideTargetScale);
    this.updateTargetPullHeight(this.imageSlideTargetOffset * this.ratioOffset);
    this.photoPropertiesOpacity = 1;
    this.clipWidthPercentage = this.clipWidthTargetPercentage;
    this.toSaliencyImageSlideTargetState();
  }

  public resetImageSlideInitState(): void {
    this.setImageSlidePullUpOffset(0);
    this.setImageSlideScale(1);
    this.photoPropertiesOpacity = 0;
    this.clipWidthPercentage = this.clipWidthStartPercentage;
  }

  protected abstract updateClipWidth(): number;

  public setImageSlidePullUpOffset(offset: number): void {
    this.imageSlidePullUpOffset = offset;
    if (this.imageSlidePullUpOffset + this.imageSlideTargetOffset <= 0) {
      this.clipHeightPercentage = 1 - Math.abs(this.windowLayoutWidth - this.windowLayoutHeight) /
      Math.max(this.windowLayoutWidth, this.windowLayoutHeight);
      this.clipColumnHeight = Math.max(this.windowLayoutWidth, this.windowLayoutHeight);
    } else {
      this.clipColumnHeight = Constants.PERCENT_100;
      this.clipHeightPercentage = 1;
    }
  }

  public getImageSlidePullUpOffset(): number {
    return this.imageSlidePullUpOffset;
  }

  /**
   * toImageSlideTargetState调用
   *
   * @returns slidePullUpOffset
   */
  public updateSlidePullUpOffsetState(): number {
    if (this.isOnlyShowProperties) {
      return -this.windowLayoutHeight;
    }
    return -this.imageSlideTargetOffset;
  }

  /**
   * doImageSlideOffHand调用
   *
   * @returns slidePullUpOffset
   */
  public updateImageSlideTargetOffset(): number {
    this.updateSlideOffset();
    return this.updateSlidePullUpOffsetState();
  }

  /**
   * todo imageSlidePullUpOffset的三个方法赋值条件应该一致，需要确认存在差异的原因，而后进一步优化
   * onWinModeChanged调用
   *
   * @returns slidePullUpOffset
   */
  public updateWindowImageSlideTargetOffset(): number {
    if (!this.stateMachine.isPropertiesShow()) {
      return 0;
    }
    return this.updateSlidePullUpOffsetState();
  }

  public calcBarTopHeight(statusBarHeight: number): number {
    return Constants.ActionBarHeight + px2vp(statusBarHeight);
  }

  public calcBarBottomHeight(isSlideBarVisibility: boolean): number {
    if (getScreen().getWinMode() === WindowMode.FULLSCREEN) {
      if (this.isHorizontal) {
        return Constants.PreviewHeightHorizontal;
      }
      return Constants.ToolBarAvoidHeight + Constants.ToolBarHeight + Constants.PreviewHeight;
    }

    if (getScreen().getWinMode() === WindowMode.FLOATING) {
      return Constants.ToolBarHeight + Constants.PreviewHeight;
    }
    return Constants.ToolBarHeight + Constants.PreviewHeight + this.aiBarBottomHeight;
  }

  protected async initSaliencyImageCenterInner(): Promise<void> {
    await this.item.getSaliencyCoordinates();
    this.saliencyOffsetXPercent = this.item.getSaliencyOffsetXPercent();
    this.saliencyOffsetYPercent = this.item.getSaliencyOffsetYPercent();
    if ((MathUtil.equals(this.saliencyOffsetXPercent, 0) && MathUtil.equals(this.saliencyOffsetYPercent, 0)) ||
      (MathUtil.equals(this.saliencyOffsetXPercent, CENTER_PERCENTAGE) &&
      MathUtil.equals(this.saliencyOffsetYPercent, CENTER_PERCENTAGE))) {
      this.saliencyImageFlag = false;
      return;
    } else {
      this.saliencyImageFlag = true;
    }
    this.onSaliencyPullUpPrepare();
  }

  protected isSetTargetW(): boolean {
    return this.windowLayoutWidth > this.windowLayoutHeight;
  }

  public onSaliencyPullUpPrepare(): void {
    if (!this.saliencyImageFlag) {
      return;
    }
    let targetH = this.windowLayoutHeight;
    let targetW = this.windowLayoutWidth;
    if (this.isSetTargetW()) {
      // xxx展开或者横屏，向上滑的时候预览图视窗会往左边滑动缩窄，计算收缩后的目标宽度
      targetW -= (this.imageSlideTargetOffset * HALF_DIVIDER);
    } else {
      // 竖屏，向上滑的时候预览图视窗会往上滑动收窄，计算收缩后的目标高度
      targetH -= (this.imageSlideTargetOffset * HALF_DIVIDER);
    }
    Log.info(TAG,
      `PullUpPrepare target width and height {${targetW}, ${targetH}}, clip center offset ${this.imageSlideTargetOffset}`);

    // 获取目标窗口视图中心位置
    let targetHalfW = targetW / HALF_DIVIDER;
    let targetHalfH = targetH / HALF_DIVIDER;
    let imgWidthVp = px2vp(this.imgWidth * this.imageSlideTargetScale);
    let imgHeightVp = px2vp(this.imgHeight * this.imageSlideTargetScale);
    Log.info(TAG,
      `PullUpPrepare image width and height {${imgWidthVp}, ${imgHeightVp}}, scale ${this.imageSlideTargetScale}`);
    // 获取图片中心位置
    let centX = imgWidthVp / HALF_DIVIDER;
    let centY = imgHeightVp / HALF_DIVIDER;

    let sCenterX = imgWidthVp * this.saliencyOffsetXPercent;
    let sCenterY = imgHeightVp * this.saliencyOffsetYPercent;

    // 基于图片和视图区域尺寸调整主体中心位置
    if (imgWidthVp <= targetW) {
      sCenterX = centX;
    } else {
      if (sCenterX <= centX) {
        sCenterX = sCenterX >= targetHalfW ? sCenterX : targetHalfW;
      } else {
        sCenterX = imgWidthVp - sCenterX >= targetHalfW ? sCenterX : imgWidthVp - targetHalfW;
      }
    }
    if (imgHeightVp <= targetH) {
      sCenterY = centY;
    } else {
      if (sCenterY <= centY) {
        sCenterY = sCenterY >= targetHalfH ? sCenterY : targetHalfH;
      } else {
        sCenterY = imgHeightVp - sCenterY >= targetHalfH ? sCenterY : imgHeightVp - targetHalfH;
      }
    }
    this.imageSlideTargetOffsetX = (centX - sCenterX);
    this.imageSlideTargetOffsetY = (centY - sCenterY);

    Log.info(TAG,
      `PullUpPrepare imageSlideTargetOffsetXY {${this.imageSlideTargetOffsetX}, ${this.imageSlideTargetOffsetY}}`);
  }

  public async initSaliencyImageCenter(): Promise<void> {
    this.initSaliencyImageCenterInner();
  }

  /**
   * 是否允许响应捏合事件
   */
  public isAllowPinch(): boolean {
    // 上滑和下拉过程不允许捏合
    if (this.stateMachine.isPropertiesShow() || this.isPullingDown || this.isDragFocus) {
      Log.warn(TAG, `Not allow to pinch when propertiesState = ${this.stateMachine.isPropertiesShow()} isPullingDown = ${
      this.isPullingDown} isDragFocus = ${this.isDragFocus}`);
      return false;
    }
    return true;
  }

  /**
   * 是否允许响应旋转事件
   */
  public isAllowRotate(): boolean {
    // 上滑\下拉未结束过程不允许捏合
    if (this.stateMachine.isPropertiesShow() || this.isPullingDown || this.isDragFocus) {
      Log.warn(TAG, `Not allow to rotate when propertiesState = ${this.stateMachine.isPropertiesShow()} isPullingDown = ${
      this.isPullingDown} isDragFocus = ${this.isDragFocus}`);
      return false;
    }
    return true;
  }

  public updatePhoneRatioOffset(currentImageWidth: number, currentImageHeight: number): void {
    let screenWidth = vp2px(this.windowLayoutWidth);
    let screenHeight = vp2px(this.windowLayoutHeight);
    let isImageWidthLessThanOrEqualToHeight = this.item.width && this.item.height &&
      this.item.width <= this.item.height;
    // 上滑状态竖屏切换为横屏
    if (this.stateMachine.isPropertiesShow() && this.isHorizontal &&
      ![currentImageWidth, currentImageHeight].includes(0)) {
      let imageSlideTargetScale = isImageWidthLessThanOrEqualToHeight ? Math.max(screenWidth, screenHeight) /
      this.minWidthOrHeight : Math.max(screenWidth / currentImageWidth, screenHeight / currentImageHeight);
      this.imageSlideTargetScale = imageSlideTargetScale;
      this.ratioOffset = this.windowLayoutHeight / Constants.PROPERTIES_WIDTH * HALF_DIVIDER;
      // 上滑状态横屏切换为竖屏
    } else if (this.stateMachine.isPropertiesShow() && !this.isHorizontal && this.minWidthOrHeight !== 0) {
      this.imageSlideTargetScale = Math.min(screenWidth, screenHeight) / this.minWidthOrHeight;
      this.ratioOffset = 2;
      // 非上滑状态横屏切换为竖屏
    } else if (!this.stateMachine.isPropertiesShow() && !this.isHorizontal && this.minWidthOrHeight !== 0) {
      this.imageSlideTargetScale = Math.min(screenWidth, screenHeight) / this.minWidthOrHeight;
      this.ratioOffset = 2;
      // 非上滑状态竖屏切换为横屏
    } else if (!this.stateMachine.isPropertiesShow() && this.isHorizontal &&
      ![currentImageWidth, currentImageHeight].includes(0)) {
      let imageSlideTargetScale = isImageWidthLessThanOrEqualToHeight ? Math.max(screenWidth, screenHeight) /
      this.minWidthOrHeight : Math.max(screenWidth / currentImageWidth, screenHeight / currentImageHeight);
      this.imageSlideTargetScale = imageSlideTargetScale;
      this.ratioOffset = this.windowLayoutHeight / Constants.PROPERTIES_WIDTH * HALF_DIVIDER;
    } else {
      Log.info(TAG, 'no update');
    }
    if (!this.isHorizontal) {
      this.propertiesIndex = 2;
    }
    this.onSaliencyPullUpPrepare();
  }

  /**
   * 降低详情页的层级
   */
  public setPropertiesIndexLower(): void {
    if (getScreen().isSplitMode()) {
      this.propertiesIndex = 1;
    } else {
      this.propertiesIndex = 0;
    }
  }

  public updateImageSlideInfo(currentImageWidth: number, currentImageHeight: number): void {
  }

  protected needClip(screenWidth: number, screenHeight: number): boolean {
    return screenWidth > screenHeight && !this.isDefaultWidth();
  }

  public updatePropertiesIndex(): void {
    let screenWidth = vp2px(this.windowLayoutWidth);
    let screenHeight = vp2px(this.windowLayoutHeight);
    if (this.needClip(screenWidth, screenHeight)) {
      this.setPropertiesIndexLower();
      if (this.imgWidth > screenHeight) {
        this.clipWidthStartPercentage = (this.imgWidth / screenWidth) / HALF_DIVIDER + 1 / HALF_DIVIDER;
      } else {
        this.clipWidthStartPercentage = 1;
      }
      this.ratioOffset = Math.min(this.windowLayoutWidth, this.windowLayoutHeight) / Math.abs(
        this.windowLayoutWidth / HALF_DIVIDER - this.windowLayoutHeight / HALF_DIVIDER);
      return;
    }
    if (this.isDefaultWidth()) {
      this.propertiesIndex = 0;
      this.ratioOffset = this.windowLayoutHeight / Constants.PROPERTIES_WIDTH * HALF_DIVIDER;
      return;
    }
    this.propertiesIndex = 1;
    this.ratioOffset = 2;
  }

  /**
   * 图片是否需要默认撑满
   *
   * @returns
   */
  public checkNeedJustify(): boolean {
    return true;
  }

  protected getColumnsEightListCardWidth(): number {
    return getScreen().getColumnsWidth(ColumnSize.COLUMN_SIX);
  }

  protected getColumnsTwelveListCardWidth(): number {
    return getScreen().getColumnsWidth(ColumnSize.COLUMN_EIGHT);
  }

  /**
   * 计算详情卡片宽度
   *
   * @param listCardWidth 默认情况返回值
   */
  public getListCardWidth(listCardWidth: number): number {
    if (this.isDefaultWidth()) {
      return Constants.PROPERTIES_WIDTH - Constants.SPLIT_LIST_CARD_MARGIN_COUNT * Constants.COLUMN_MARGIN;
    }

    switch (this.windowColumns) {
      case ColumnSize.COLUMN_FOUR:
        return Math.floor(getScreen().getWinWidth() -
          Constants.SPLIT_LIST_CARD_MARGIN_COUNT * Constants.COLUMN_MARGIN);
      case ColumnSize.COLUMN_EIGHT:
        return this.getColumnsEightListCardWidth();
      case ColumnSize.COLUMN_TWELVE:
        return this.getColumnsTwelveListCardWidth();
      default:
        return listCardWidth;
    }
  }

  /* 获取图片x轴偏移量 */
  public abstract getImageTranslateX(isFullMode: boolean): number | string;

  /* 获取图片详情x轴偏移量 */
  public abstract getPropertiesTranslateX(): number | string;

  /* 获取图片详情y轴偏移量 */
  public getPropertiesTranslateY(isFullMode: boolean, isWindowPcmode: boolean): number | string {
    if (isFullMode) {
      return this.ratioOffset * this.getImageSlidePullUpOffset();
    }
    return this.getImageSlidePullUpOffset();
  }

  /* 详情X——position */
  public getPropertiesPositionX(): number | string {
    return Constants.PERCENT_0;
  }

  /*详情Y——position*/
  public getPropertiesPositionY(): number | string {
    return Constants.PERCENT_100;
  }

  /* 获取图片y轴偏移量 */
  public getImageTranslateY(isFullMode: boolean): number | string {
    if (this.isHorizontal && isFullMode) {
      return 0;
    }
    return this.getImageSlidePullUpOffset();
  }

  /* 获取图片布局 */
  public getPhotoColumnAlignItems(isFullMode: boolean, isDoingImageSlideAnimation: boolean): HorizontalAlign {
    if (!this.stateMachine.isPropertiesShow() && !isDoingImageSlideAnimation) {
      return HorizontalAlign.Center;
    }

    if (this.isHorizontal && isFullMode) {
      return HorizontalAlign.Start;
    }
    return HorizontalAlign.Center;
  }

  /* 获取图片详情布局 */
  public getPhotoPropertiesAlignItems(isFullMode: boolean, isDoingImageSlideAnimation: boolean): HorizontalAlign {
    if (!this.stateMachine.isPropertiesShow() && isDoingImageSlideAnimation) {
      return HorizontalAlign.Center;
    }

    if (this.isHorizontal && isFullMode) {
      return HorizontalAlign.End;
    }
    return HorizontalAlign.Center;
  }

  /* 获取图片容器宽度 */
  public abstract getPhotoColumnWidth(isFullMode: boolean, isHalfFold: boolean): number | string;

  public onWinModeChanged(): void {
    this.clipWidthPercentage = this.clipWidthTargetPercentage;
    this.updateSlideOffset();
    this.setImageSlidePullUpOffset(this.updateWindowImageSlideTargetOffset());
  }

  public checkNeedJustifyForVideo(videoRealWidth: number, videoRealHeight: number): boolean {
    return true;
  }

  public getBrowserPosition(): number {
    // 打开大图的位置，0-搜索实时搜索界面，1-搜索“更多”界面，2-照片页，3-相册页，4-时刻页，5-其他界面
    let enterPosition = ReportToBigDataUtil.getEnterPhotoBrowserPosition(
      this.focusCtrlManager.getTabIndex());
    return enterPosition;
  }

  public async reportLargePhotosBrowser(albumUri: string, asset?: PhotoAsset | undefined): Promise<void> {
    let scenarL: number = 0;
    if (PhotoConfig.isLibrary()) {
      // 判断是否为相机进入大图，如果是相机进入大图则返回5
      scenarL = ENTER_LARGE_PHOTO_FROM_CAMERA_THUMB_NAIL;
    } else {
      scenarL = this.getBrowserPosition();
    }

    let albumTypeL: number;
    if (AppStorage.get(ALBUM_TYPE) === undefined) {
      albumTypeL = 0;
    } else {
      albumTypeL = AppStorage.get(ALBUM_TYPE) as number;
    }
    let mediaTypeL = this.item.mediaType;
    if (this.isMovingPhoto()) {
      mediaTypeL = MEDIA_TYPE_MOVING_PHOTO;
    }
    let fileAsset: PhotoAsset;
    if (asset === undefined) {
      if (UserFileManagerAccess.isRecycleBin(albumUri)) {
        /* instrument ignore next  */
        fileAsset = await UserFileManagerAccess.getInstance().getTrashAssetByUri(this.item.uri) as PhotoAsset;
      } else {
        fileAsset = await UserFileManagerAccess.getInstance()
          .getObject(AlbumDefine.getFileFetchOptByUri(this.item.uri)) as PhotoAsset;
      }
    } else {
      fileAsset = asset;
    }
    if (fileAsset) {
      let shootModeTagL = fileAsset.get(SHOOTING_MODE_TAG) as number;
      if (this.isMovingPhoto()) {
        shootModeTagL = MOVING_PICTURE_SHOOTING_MODE_TAG;
      }
      let sefieL = fileAsset.get(FRONT_CAMERA) as number;
      let msgL: BigPhotoBrowserMsg = {
        scenario: scenarL,
        albumType: albumTypeL,
        mediaType: mediaTypeL,
        selfie: sefieL,
        shootModeTag: shootModeTagL,
      };
      ReportToBigDataUtil.report(ENTER_IMAGE_INNER_PHOTO, msgL);
    }
  }

  public printSaliencyStatus(eventId: string): void {
    let index = this.item.uri?.lastIndexOf('\/');
    let imageUri = this.item.uri?.substring(0, index);
    let indexPrev = imageUri?.lastIndexOf('\/');
    if (index - indexPrev > ANONYMIZATION_COUNT) {
      imageUri = this.item.uri?.substring(0, indexPrev + ANONYMIZATION_COUNT);
    } else {
      imageUri = this.item.uri?.substring(0, index);
    }
    imageUri += '***';
    if (this.saliencyImageFlag) {
      Log.info(TAG,
        `uri[${imageUri} will show with saliency (${this.saliencyOffsetXPercent},${this.saliencyOffsetYPercent})`);
      let msg: SaliencyMsg = {
        uri: imageUri,
        saliency: true,
        msg: BigDataConstants.PHOTO_SALIENCY_SHOW,
      }
      ReportToBigDataUtil.report(eventId, msg);
      return;
    }
    let msgType: string = BigDataConstants.PHOTO_SHOW_FOR_FAILED;
    if (!this.item?.getSaliencyFlag()) {
      msgType = BigDataConstants.PHOTO_ERROR_FOR_NO_ANALYSIS;
    } else if (this.saliencyOffsetXPercent === 0 && this.saliencyOffsetYPercent === 0) {
      msgType = BigDataConstants.PHOTO_ERROR_FOR_NOT_SUPPORT;
    }
    let msg: SaliencyMsg = {
      uri: imageUri,
      saliency: false,
      msg: msgType,
    };
    ReportToBigDataUtil.report(eventId, msg);
    Log.info(TAG,
      `uri[${imageUri} will show with center (${this.saliencyOffsetXPercent},${this.saliencyOffsetYPercent})`);
  }

  /**
   * 常规场景下，从大图页返回时，图片上下树 transition 动画
   * @returns 图片上下树动画效果参数表
   */
  private makeNormalPhotoTransition(): TransitionEffect {
    let geometryScale = LocalStorage.getShared()?.get<number>('geometryScale') ?? 1;
    Log.debug(TAG, `makeNormalPhotoTransition geometryScale: ${geometryScale}`);
    return TransitionEffect.asymmetric(TransitionEffect.opacity(OPACITY_DOT_99),
      TransitionEffect.scale({
        x: 1 / geometryScale,
        y: 1 / geometryScale,
        centerX: CENTER_POSITION,
        centerY: CENTER_POSITION,
      })
        .combine(TransitionEffect.opacity(OPACITY_DOT_99)));
  }

  /**
   * 删除图片场景下，从大图页返回时，图片上下树 transition 动画
   * @returns 图片上下树动画效果参数表
   */
  private makeDeletePhotoTransition(): TransitionEffect {
    let isLeftToRightAnim = AppStorage.get<boolean>('isBigPhotoLeftToRightAnim') ?? false;
    Log.info(TAG, `makeDeletePhotoTransition isLeftToRightAnim: ${isLeftToRightAnim}`);
    return TransitionEffect.asymmetric(// 入场
      TransitionEffect.move(
        isLeftToRightAnim ? TransitionEdge.START : TransitionEdge.END
      ).animation({
        delay: AppStorage.get('isDoingRecoverBigPhotoAnim')? 150 : BrowserConstants.DELETE_MOVE_DELAY,
        curve: Curves.interpolatingSpring(1, 1, 250, 25),
      }),
      TransitionEffect.scale({
        x: BrowserConstants.DELETE_SCALE,
        y: BrowserConstants.DELETE_SCALE,
      }).animation({
        duration: BrowserConstants.DELETE_DURATION,
        curve: Curve.Friction,
      })
        .combine(
          TransitionEffect.OPACITY.animation({ duration: BrowserConstants.DELETE_OPACITY })
        )
    );
  }

  private getSaliencyTargetOffsetX(): number {
    if (this.stateMachine.isPropertiesShow()) {
      return this.imageSlideTargetOffsetX;
    }
    return 0;
  }

  private getSaliencyTargetOffsetY(): number {
    if (this.stateMachine.isPropertiesShow()) {
      return this.imageSlideTargetOffsetY;
    }
    return 0;
  }

  /**
   * 标识是否正在滑动
   */
  public isOnSwiperAnimation(): boolean {
    return this.stateMachine.isOnSwiperAnimation();
  }

  /**
   * 隔空分享，使用下载进度圆环
   *
   * @returns
   */
  public useDownloadProgressRing(): boolean {
    Log.info(TAG, 'useDownloadProgressRing: false');
    return false;
  }

  public onExitStartAnim(): void {
    if (this.browserAnimController.isTransitionEnable) {
      return;
    }
    Log.info(TAG, `onExitStartAnim ${this.getTargetIndex()} ${this.mPosition}`);
    this.setIsRunningAnimationFunc(true);
    if (this.getTargetIndex() === this.mPosition) {
      this.browserAnimController.exitOnStart();
      this.exitStartAnimUpdateIsTap();
    }
    this.onExitStartAnimFunc();
  }

  public onExitEndAnim(): void {
    if (this.browserAnimController.isTransitionEnable) {
      return;
    }
    Log.info(TAG, `onExitStartAnim ${this.getTargetIndex()} ${this.mPosition}`);
    if (this.getTargetIndex() === this.mPosition) {
      this.browserAnimController.exitOnfinish();
      this.exitEndAnimUpdateIsTap();
    }
    this.onExitEndAnimFunc();
  }

  public exitStartAnimUpdateIsTap(): void {
  }

  public exitEndAnimUpdateIsTap(): void {
    this.browserAnimController.updatePlaceHolder(this.item?.uniqueId ?? '', false);
  }

  public onEnterStartAnim(): void {
    if (this.browserAnimController.isTransitionEnable) {
      return;
    }
    this.onEnterStartAnimFunc();
  }

  public onEnterEndAnim(): void {
    if (this.browserAnimController.isTransitionEnable) {
      return;
    }
    if (this.getTargetIndex() === this.mPosition) {
      this.browserAnimController.enterOnfinish();
    }
    this.onEnterEndAnimFunc();
  }

  /**
   * 触发进出大图的动效
   */
  public playImageAnimationAsync(params: BrowserAnimParams, index: number, onFinish: (index: number) => void,
    onAnim: () => void, gridToImage: boolean, duration: number = 1000): void {
    // 动效时长传入0，不走animateto逻辑
    if (duration === 0) {
      this.setImageAnimation(params, gridToImage, duration);
      return;
    }
    this.uiContext?.animateToImmediately({
      curve: gridToImage ? params.curveStart : params.curveEnd,
      onFinish: () => {
        onFinish(index);
      },
    }, () => {
      onAnim();
      this.thumbImageColumnModifier?.updateOffset({ x: 0, y: 0 });
      this.stackModifier?.updateOffset({ x: 0, y: 0 });
      this.setImageAnimation(params, gridToImage, duration);
      if (gridToImage) {
        LocalStorage.getShared()?.setOrCreate<number>('geometryOpacity', 1);
      }
    })
  }

  /**
   *
   */
  public setImageAnimation(params: BrowserAnimParams, gridToImage: boolean, duration: number): void {
    Log.info(TAG, `setImageAnimation reason: ${gridToImage} targetWidth: ${params.targetWidth} targetHeight: ${
    params.targetHeight} targetTranslate: ${params.targetTranslate?.x} targetThumbnailOpacity: ${
    params.targetThumbnailOpacity} targetPhotoOpacity: ${params.targetPhotoOpacity} targetAspectRatio: ${
    params.targetAspectRatio} targetRadius: ${params.targetRadius} borderWidth: ${params.targetBorderWidth} targetScale: ${
    params.targetScale?.x} duration: ${duration}`)
    this.thumbImageColumnModifier?.updateWidth(params.targetWidth ?? BrowserConstants.targetWidth);
    this.thumbImageColumnModifier?.updateHeight(params.targetThumbnailHeight ?? BrowserConstants.targetHeight);
    this.thumbImageColumnModifier?.updateTranslate(params.targetThumbnailTranslate ??
    BrowserConstants.targetTranslate);
    this.thumbImageModifier?.updateOpacity(params.targetThumbnailOpacity ?? BrowserConstants.targetPhotoOpacity);
    this.thumbImageColumnModifier?.updateScale(params.targetScale ?? BrowserConstants.targetScale);
    this.thumbImageModifier?.updateAspectRatio(params.targetAspectRatio ??
    BrowserConstants.targetAspectRatio);
    this.thumbImageModifier?.updateBorderRadius(params.targetRadius ?? BrowserConstants.targetRadius);
    this.thumbImageModifier?.updateBorderWidth(params.targetBorderWidth ??
    BrowserConstants.targetBorderWidth);
    this.oriImageColumnModifier?.updateWidth(params.targetWidth ?? BrowserConstants.targetWidth);
    this.oriImageColumnModifier?.updateHeight(params.targetHeight ?? BrowserConstants.targetHeight);
    this.oriImageColumnModifier?.updateTranslate(params.targetTranslate ?? BrowserConstants.targetTranslate);
    this.thumbImageStackModifier?.updateBorderRadius(params.targetRadius ?? BrowserConstants.targetRadius);
    this.thumbImageStackModifier?.updateBorderWidth(params.targetBorderWidth ??
    BrowserConstants.targetBorderWidth);
    this.oriImageColumnModifier?.updateOpacity(params.targetPhotoOpacity ??
    BrowserConstants.targetPhotoOpacity);
    this.stackModifier?.updateAspectRatio(params.targetAspectRatio ?? BrowserConstants.targetAspectRatio);
  }

  public onBackEndAnim(): void {
    Log.info(TAG, `onBackEndAnim ${this.getTargetIndex()} ${this.mPosition}`);
    if (this.getTargetIndex() === this.mPosition) {
      this.stateMachine.processExitAnimationStartEvent();
    }
  }

  public onPhotoitemAppear(): void {
    Log.info(TAG, `onPhotoitemAppear ${this.getTargetIndex()} ${this.mPosition}`);
    if (this.getTargetIndex() === this.mPosition) {
      this.stateMachine.processExitAnimationStartEvent();
    } else {
      this.thumbImageColumnModifier?.updateVisibility(Visibility.Hidden);
    }
  }

  /**
   * 初始化动画，photoitem加载好后，根据当前状态
   */
  public initialAnim(): void {
    Log.info(TAG, `initialAnim`)
    if (this.getTargetIndex() === this.mPosition) {
      this.thumbImageColumnModifier?.updateVisibility(Visibility.Hidden);
      this.thumbImageStackModifier?.updateVisibility(Visibility.Hidden);
      this.videoButtonRowModifier?.updateVisibility(Visibility.Hidden);
    }
  }

  public hideEnterAnimating(): void {
    if (this.browserAnimController.isTransitionEnable) {
      return;
    }
    Log.info(TAG, `hideEnterAnimating`)
    this.thumbImageStackModifier?.updateVisibility(Visibility.Visible);
  }

  // 根据当前状态播放对应动画, init状态会播放进入动画，back状态会播放退出动画
  public readyToPlayAnim(): void {
    Log.info(TAG, `readyToPlayAnim isThumbnailComplete = ${this.isThumbnailComplete} ${
      this.stateMachine.getCurrentState()?.stateName}`);
    if (this.isThumbnailComplete) {
      this.onPhotoitemAppear();
    }
  }

  public hideThumbnailImageFunc: () => void = () => {
    if (this.stateMachine.getTargetIndex() === this.mPosition) {
      this.stateMachine.processHideEnterAnimatingEvent();
    }
  }

  public onSwiperAnimEnd(): void {
    this.setImagePixMap();
  }

  /**
   * 大图显示大小变化
   */
  public onPhotoDisplaySizeChange(): void {
  }
}