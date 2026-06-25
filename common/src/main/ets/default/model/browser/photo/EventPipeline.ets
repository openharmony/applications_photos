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
import type { MediaItem } from './MediaItem';
import lazy { Log } from '../../../utils/Log';
import type { BroadCast } from '../../../utils/BroadCast';
import lazy { MathUtil } from '../../../utils/MathUtil';
import lazy { Constants as PhotoConstants } from './Constants';
import lazy { getScreen } from '../../common/ScreenManager';
import type { PhotoItemGestureCallback } from './PhotoItemGestureCallback';
import lazy { BigDataConstants, ReportToBigDataUtil, PhotoInfo } from '../../../utils/ReportToBigDataUtil';
import lazy { UiUtil } from '../../../utils/UiUtil';
import lazy { DateUtil } from '../../../utils/DateUtil';
import lazy { DeviceInfo } from '../../../utils/DeviceInfo';
import lazy display from '@ohos.display';
import lazy { Scales } from './pipeline/variable';
import lazy { ImageToolConstants } from '../../common/ImageToolConstants';
import lazy { ImageToolInnerState } from '../../../../../../../../browserCommon/src/main/ets/default/view/ImageToolInnerState';
import lazy { Constants } from '../../../model/common/Constants';

const TAG: string = 'EventPipeline';

export interface AnimationParam {
  duration: number,
  curve: Curve,
}

interface OffsetStatus {
  x: number,
  y: number,
  speedX: number,
  speedY: number,
  timestamp: number,
};

export class EventPipeline {
  // 上次平移
  public lastOffset: [number, number] = [0, 0];
  // 当前平移
  public offset: [number, number] = [0, 0];
  // 平移的详细状态
  public offsetStatus: OffsetStatus = {
    x: 0,
    y: 0,
    speedX: 0,
    speedY: 0,
    timestamp: 0,
  };
  // 滑动的定时器管理
  public interval: number | null = null;
  // 上次缩放值
  public lastScale: number = 1.0;
  // 默认缩放值
  public defaultScale: number = 1.0;
  // 当前缩放值
  public scale: number = 1.0;
  // 缩放中心点，是相对于控件的百分比位置，非绝对位置
  public center: [number, number] = [0.5, 0.5];
  // 最左缩放中心，(1 - leftMost)即为最右缩放中心
  public leftMost: number = 0.0;
  // 最上缩放中心，(1 - topMost)即为最下缩放中心
  public topMost: number = 0.0;
  // 双击缩放比例
  public doubleTapScale: number = 1.0;
  // 最大缩放比例
  public maxScale: number = 1.0;
  // 是否已经到达最左边
  public hasReachLeft: boolean = true;
  // 是否已经到达最右边
  public hasReachRight: boolean = true;
  // 事件总线
  public broadCast: BroadCast;
  // // 数据单个条目项
  public item: MediaItem;
  // // 事件总线
  public gestureCallback: PhotoItemGestureCallback;
  // 宽度
  public width: number = 0;
  // 高度
  public height: number = 0;
  // 大图显示控件宽度
  public componentWidth: number = vp2px(getScreen().getWinLayoutWidth());
  // 大图显示控件高度
  public phoneComponentHeight: number = DeviceInfo.isHalfFoldState() ?
    vp2px(getScreen().getWinLayoutHeight()) / 2 : vp2px(getScreen().getWinLayoutHeight());
  public componentHeight = DeviceInfo.isPc() ? vp2px(getScreen().getWinHeight()) : this.phoneComponentHeight;
  // 连拍完整显示高度（去除底部缩略图及顶部工具栏）
  public burstComponentHeight: number = this.componentHeight;
  // 连拍照片完整显示的缩放比例(非沉浸态)
  public burstDefaultScale: number = 1.0;
  // 连拍照片完整显示的Y轴偏移量(非沉浸态)
  public burstDefaultTranslateY: number = 0;
  // 是否在做动画
  public isInAnimation: boolean = false;
  // 下拉返回flag，防止触发多次
  public isExiting: boolean = false;
  // 动画期间是否允许拖动手势
  public canPanInAnimation: boolean = false;
  // 画中画变量
  public imageToolState: ImageToolInnerState;
  public isPullingUp: boolean = false;
  public canPullingUp: boolean = false;
  public touchEventStartX: number = 0;
  public touchEventStartY: number = 0;
  public touchEventStartId: number = 0;
  public isPullDownAndDragPhoto: boolean = false;
  public isFirstDownLoadOrigin: boolean = true;
  private castFixWidth = 0;
  private castFixHeight = 0;
  private isCastConnect = false;
  public currentScale: number = 1;
  private isSubScreen = false;
  private isVideo: boolean = false;
  private isBurstPhotos: boolean = false;
  private pinchOffset: number[] = [0, 0];
  private matrix: Matrix4.Matrix4Transit = Matrix4.identity().copy();
  // 触发的单次旋转是否角度变化
  private isRotationAngleChange: boolean = false;
  // 大图旋转角度
  private rotationAngle: number = 0;
  // 图片默认一边撑满宽高
  private imageScaleInitWidth: number = 0;
  private imageScaleInitHeight: number = 0;
  // 图片显示宽高displaysize是否大于屏幕宽高component size
  private isDisPlayLargerCompoSize: boolean = false;

  constructor(broadCastParam: BroadCast, item: MediaItem, gestureCallback:
    PhotoItemGestureCallback, isSubScreen: boolean = false, imagetoolState?: ImageToolInnerState) {
    this.broadCast = broadCastParam;
    this.item = item;
    this.gestureCallback = gestureCallback;
    this.isSubScreen = isSubScreen;
    this.imageToolState = imagetoolState ?? new ImageToolInnerState();
    this.rotationAngle = 0;
    this.calculateImgSize();
    this.evaluateScales();
    this.calculateCastFix(item);
    this.calculateImageScaleInfo();
  }

  /**
   * 实时判断图片是否放大
   */
  public isPhotoScaled(): boolean {
    if (this.lastScale * this.scale <= this.defaultScale) {
      Log.debug(TAG, `photo current scale less than defaultScale`);
      return false;
    }
    return true;
  }

  /**
   * 返回isDisPlayLargerCompoSize
   */
  public getDisPlayCompaCompo(): boolean {
    return this.isDisPlayLargerCompoSize;
  }

  /**
   * 画中画 大图捏合松手动效 画中画跟随动效放大缩小
   */
  public innerPicPinchAnimationEnd(): void {
    this.updateInnerSmaPicInfo(this.lastScale, [this.lastOffset[0], this.lastOffset[1]]);
  }

  public innerPicPanAnimationEnd(): void {
    const scale = this.scale * this.lastScale;
    const offset = this.evaluateOffset();
    this.updateInnerSmaPicInfo(scale, offset);
  }

  /**
   * 画中画拖拽手势
   */
  public imageToolOnActionStart(event: GestureEvent): void {
    if (event) {
      Log.info(TAG, `imageTool pangesture start!`);
      this.imageToolState._panOffsetX = this.imageToolState._scrollX;
      this.imageToolState._panOffsetY = this.imageToolState._scrollY;
    }
  }

  public imageToolOnActionUpdate(event: GestureEvent): void {
    if (event) {
      // 横纵坐标限制
      if (this.imageToolState._panOffsetX + event.offsetX + this.imageToolState._scrollWidth >
      this.imageToolState._stackWidth) {
        this.imageToolState._scrollX = this.imageToolState._stackWidth - this.imageToolState._scrollWidth;
      } else if (this.imageToolState._panOffsetX + event.offsetX < 0) {
        this.imageToolState._scrollX = 0;
      } else {
        this.imageToolState._scrollX = this.imageToolState._panOffsetX + event.offsetX;
      }

      if (this.imageToolState._panOffsetY + event.offsetY + this.imageToolState._scrollHeight >
      this.imageToolState._stackHeight) {
        this.imageToolState._scrollY = this.imageToolState._stackHeight - this.imageToolState._scrollHeight;
      } else if (this.imageToolState._panOffsetY + event.offsetY < 0) {
        this.imageToolState._scrollY = 0;
      } else {
        this.imageToolState._scrollY = this.imageToolState._panOffsetY + event.offsetY;
      }

      // 画中画移动大图跟随偏移
      this.mainPhotoOnMove(event);
    }
  }

  public imageToolOnActionEnd(event: GestureEvent): void {
    // 防止大图捏合后，移动画中画，在移动大图出现闪跳
    this.lastOffset = this.evaluateOffset();
    this.offset = [0, 0];
    Log.info(TAG, `imageTool pangesture End!`);
  }

  public imageToolOnActionCancel(): void {
    Log.info(TAG, `imageTool pangesture Cancel!`);
  }

  /**
   * 画中画移动大图跟随移动
   */
  private mainPhotoOnMove(event: GestureEvent) {
    // offset转换
    let disPlayWidth: number = this.width * this.lastScale;
    let disPlayHeight: number = this.height * this.lastScale;
    let ratio = this.imageToolState._isRight ? ImageToolConstants.IMAGE_TOOL_SINGLE_LEN / disPlayWidth :
      ImageToolConstants.IMAGE_TOOL_SINGLE_LEN / disPlayHeight;
    const offsetX = -event.offsetX / this.imageToolState._stackRatio / ratio;
    const offsetY = -event.offsetY / this.imageToolState._stackRatio / ratio;

    Log.info(TAG, `onMove with imageToolComponent offsetX=${offsetX},offsetY=${offsetY}`);
    this.offset = [offsetX, offsetY];
    const offset = this.evaluateOffset();
    const scale = this.lastScale * this.scale;
    const matrix = Matrix4.identity().scale({
      x: scale,
      y: scale,
    }).translate({
      x: offset[0],
      y: offset[1],
    }).copy();
    this.gestureCallback.onTouchEventRespond(matrix, false);
    this.evaluateBounds();
  }

  private updateInnerSmaPicInfo(curScale: number, curOffset: [number, number]): void {
    let disPlayWidth: number = this.width * curScale;
    let disPlayHeight: number = this.height * curScale;
    let ratio = this.imageToolState._isRight ? ImageToolConstants.IMAGE_TOOL_SINGLE_LEN / disPlayWidth :
      ImageToolConstants.IMAGE_TOOL_SINGLE_LEN / disPlayHeight;

    // 手机屏幕左上角  相对于  放大后图片左上角（原点） 的坐标
    const imgX = -((this.componentWidth - disPlayWidth) / 2 + curOffset[0]);
    const imgY = -((this.componentHeight - disPlayHeight) / 2 + curOffset[1]);

    this.imageToolState._scrollWidth = ratio * this.componentWidth * this.imageToolState._stackRatio >
    this.imageToolState._stackWidth ? this.imageToolState._stackWidth :
      ratio * this.componentWidth * this.imageToolState._stackRatio;
    this.imageToolState._scrollHeight = ratio * this.componentHeight * this.imageToolState._stackRatio >
    this.imageToolState._stackHeight ? this.imageToolState._stackHeight :
      ratio * this.componentHeight * this.imageToolState._stackRatio;
    this.imageToolState._scrollX = imgX * ratio * this.imageToolState._stackRatio < 0 ?
      0 : imgX * ratio * this.imageToolState._stackRatio;
    this.imageToolState._scrollY = imgY * ratio * this.imageToolState._stackRatio < 0 ?
      0 : imgY * ratio * this.imageToolState._stackRatio;
    Log.debug(TAG, `updateInner disPlay:${disPlayWidth}-${disPlayHeight} ImgPos:${imgX}-${imgY}
      scrollInfo:[${this.imageToolState._scrollWidth}-${this.imageToolState._scrollHeight}] [${this.imageToolState._scrollX},${this.imageToolState._scrollY}] `);
  }

  /**
   * 画中画 比例获取画中画小图距离Stack坐标和大小
   * @returns 坐标和大小
   */
  public getInnerSmaPicInfo(): void {
    let disPlayWidth: number = this.width * this.lastScale;
    let disPlayHeight: number = this.height * this.lastScale;
    let ratio = this.imageToolState._isRight ? ImageToolConstants.IMAGE_TOOL_SINGLE_LEN / disPlayWidth :
      ImageToolConstants.IMAGE_TOOL_SINGLE_LEN / disPlayHeight;

    // // 手机屏幕左上角  相对于  放大后图片左上角（原点） 的坐标
    const imgX = -((this.componentWidth - disPlayWidth) / 2 + this.lastOffset[0]);
    const imgY = -((this.componentHeight - disPlayHeight) / 2 + this.lastOffset[1]);

    this.imageToolState._scrollWidth = ratio * this.componentWidth * this.imageToolState._stackRatio;
    this.imageToolState._scrollHeight = ratio * this.componentHeight * this.imageToolState._stackRatio;
    this.imageToolState._scrollX = imgX * ratio * this.imageToolState._stackRatio;
    this.imageToolState._scrollY = imgY * ratio * this.imageToolState._stackRatio;
    Log.info(TAG, `getInner disPlay:${disPlayWidth}-${disPlayHeight} ImgPos:${imgX}-${imgY}
      scrollInfo:[${this.imageToolState._scrollWidth}-${this.imageToolState._scrollHeight}] [${this.imageToolState._scrollX},${this.imageToolState._scrollY}] `);
  }

  // 画中画：根据画中画规格计算ImageTool宽或者高
  public getImageToolLenByRatio(): number {
    if (!this.imageToolState._isRight) {
      return ImageToolConstants.IMAGE_TOOL_SINGLE_LEN / this.imageScaleInitHeight * this.imageScaleInitWidth;
    }
    return ImageToolConstants.IMAGE_TOOL_SINGLE_LEN / this.imageScaleInitWidth * this.imageScaleInitHeight;
  }

  // 画中画: 图片一边与窗口对齐，另一边等比放大超出屏幕，图片的宽高值
  public calculateImageScaleInfo(): void {
    Log.info(TAG, `calculateImageInfo width:${this.width} height:${this.height} ratio:${this.width / this.height}
      conponentWidth:${this.componentWidth} componentHeight:${this.componentHeight}`);
    /* instrument ignore else */
    if (this.width >= this.height) {
      this.imageScaleInitHeight = this.componentHeight;
      this.imageScaleInitWidth = this.width * (this.imageScaleInitHeight / this.height);
    } else if (this.width < this.height) {
      this.imageScaleInitWidth = this.componentWidth;
      this.imageScaleInitHeight = this.height * this.imageScaleInitWidth / this.width;
    }
    Log.info(TAG,
      `calculateImageScaleInfo initWidth:${this.imageScaleInitWidth} initHeight:${this.imageScaleInitHeight}`);
  }

  private calculateCastFix(item: MediaItem) {
    try {
      let dp = display.getDefaultDisplaySync();
      let ratio = this.getRatio();
      /* instrument ignore if */
      if (item.width > 0 && item.height > 0) {
        if (ratio > 1) {
          this.castFixHeight = (dp.height - dp.width / this.item.width * this.item.height) / 2;
          this.castFixWidth = 0;
        } else if (ratio < 1) {
          this.castFixWidth = (dp.width - dp.height / this.item.height * this.item.width) / 2;
          this.castFixHeight = 0;
        }
      }
    } catch (e) {
      Log.error(TAG, `getDefaultDisplaySync error, code ${e?.code}, stack ${e?.stack}`)
    }
    this.isCastConnect = AppStorage.get('isCastConnect') || false;
  }

  setCastConnect(isCastConnect: boolean): void {
    this.isCastConnect = isCastConnect;
  }

  setIsPullingUp(isPullingUp: boolean): void {
    this.isPullingUp = isPullingUp;
  }

  setCanPullingUp(canPullingUp: boolean): void {
    this.canPullingUp = canPullingUp;
  }

  setIsAngleChange(isAngleChange: boolean): void {
    this.isRotationAngleChange = isAngleChange;
  }

  setAngle(angle: number) {
    this.rotationAngle = angle;
  }

  setCanPanInAnimation(canPanInAnimation: boolean) {
    this.canPanInAnimation = canPanInAnimation;
  }

  /**
   * 手势旋转后
   * @param angle:
   */
  onRotateEnd(angle: number) {
    this.rotationAngle = angle;
    // 宽高重新计算
    this.calculateImgSize();

    // 画中画适配
    // 最大放大比例修改
    this.evaluateScales();
    // 双击放大后初始宽高重新计算
    this.calculateImageScaleInfo();
    Log.info(TAG, `onRotateEnd width:${this.width} height:${this.height}
      componentWidth:${this.componentWidth} componentHeight:${this.componentHeight}`);
  }

  onDataChanged(item: MediaItem): void {
    this.item = item;
    // 数据刷新会导致视图重载，此处刷新一下过渡态的数据
    this.calculateImgSize();
    this.evaluateScales();
  }

  recalculateImgSizeAndScales(): void {
    this.calculateImgSize();
    this.evaluateScales();
  }

  setDefaultScale(scale: number): void {
    this.defaultScale = scale;
    this.lastScale = scale;
  }

  setIsVideo(isVideo: boolean): void {
    this.isVideo = isVideo;
  }

  setIsBurstPhotos(isBurstPhotos: boolean): void {
    this.isBurstPhotos = isBurstPhotos;
  }

  // 重置过渡的数据
  resetTransitionStatus(): void {
    this.lastOffset = [0, 0];
    this.offset = [0, 0];
    this.lastScale = 1.0;
    this.scale = 1;
    this.hasReachLeft = true;
    this.hasReachRight = true;
    this.isInAnimation = false;
    this.isExiting = false;
  }

  onComponentSizeChanged(componentWidth: number, componentHeight: number): void {
    this.componentWidth = componentWidth;
    this.componentHeight = componentHeight;
    this.calculateImgSize();
    this.evaluateScales();
    this.emitTouchEvent();
  }

  public canTouch(): Boolean {
    return !(this.isInAnimation || this.isExiting);
  }

  public canPan(): Boolean {
    return (!this.isInAnimation || this.canPanInAnimation) && !this.isExiting;
  }

  /* instrument ignore next */
  onTouch(event: TouchEvent): void {
    if (!this.canPan()) {
      return;
    }
    if (event.type === TouchType.Down || event.type === TouchType.Up) {
      this.emitDirectionChange();
    }
    this.verifyPullDownAndDragPhotoStatus(event);
  }

  /**
   * 将矩形按一定比例放大至屏幕中心
   *
   * @param centerX 矩形中心点x
   * @param centerY 矩形中心点y
   * @param multiple 放大倍数
   */
  /* instrument ignore next */
  movePosToCenter(centerX: number, centerY: number, multiple: number): void {
    // 进入沉浸模式
    let matrix: Matrix4.Matrix4Transit;
    // 按照原始图片大小位置进行缩放和偏移
    this.lastScale = 1;
    this.lastOffset = [0, 0];
    // 根据人脸位置计算放大中心
    const center = this.evaluateCenter(centerX, centerY);
    // 放大比例
    const scale = multiple * this.defaultScale;
    const scaleRatio = (scale - this.defaultScale) * this.lastScale;
    const scaleOffset: number[] = [
      (center[0] - 0.5) * this.componentWidth * scaleRatio,
      (center[1] - 0.5) * this.componentHeight * scaleRatio
    ];
    this.offset = [
      0.5 * this.componentWidth - centerX - scaleOffset[0],
      0.5 * this.componentHeight - centerY - scaleOffset[1]
    ];
    matrix = this.evaluateAnimeMatrix(scale);
    this.startAnimation(matrix);
  }

  verifyPullDownAndDragPhotoStatus(event: TouchEvent): void {
    let scale = this.lastScale * this.scale;
    let isEnlarged = scale > this.defaultScale;
    let touchList = event.touches;

    if (event.type === TouchType.Down) {
      // 重置拖动图片场景参数
      if (this.canPullDownAndDragPhoto()) {
        this.touchEventStartX = 0;
        this.touchEventStartY = 0;
        this.isPullDownAndDragPhoto = false;
      }
      this.touchEventStartX = touchList[0].screenX;
      this.touchEventStartY = touchList[0].screenY;
      this.touchEventStartId = touchList[0].id;
    } else if (event.type === TouchType.Move && this.touchEventStartId === touchList[0].id) {
      let touchX = touchList[0].screenX;
      let touchY = touchList[0].screenY;
      let deltaX = Math.abs(touchX - this.touchEventStartX);
      let deltaY = touchY - this.touchEventStartY;
      if (deltaY - deltaX > PhotoConstants.CAN_PULL_DOWN_DRAG_THRESHOLD && !this.isPullingUp && !isEnlarged) {
        this.isPullDownAndDragPhoto = true;
      }
    }

    if (this.isPullDownAndDragPhoto) {
      this.gestureCallback.onDirectionChangeRespond(PanDirection.All);
    }
    Log.debug(TAG, `canPullDownAndDragPhoto ${this.isPullDownAndDragPhoto}`);
  }

  canPullDownAndDragPhoto(): boolean {
    return this.isPullDownAndDragPhoto;
  }

  /* instrument ignore next */
  onMoveStart(event: GestureEvent): void {
    Log.info(TAG, 'onMoveStart');
    if (!this.canPan()) {
      return;
    }
    // 初始拖动移除定时器
    if (this.interval) {
      clearInterval(this.interval);
      this.interval = null;
      this.lastOffset = this.evaluateOffset();
    }
    const offsetX = vp2px(event.offsetX);
    const offsetY = vp2px(event.offsetY);
    this.offsetStatus = {
      x: offsetX,
      y: offsetY,
      speedX: 0,
      speedY: 0,
      timestamp: event.timestamp,
    };
    // 拖动开始时重置offset，防止跳变
    this.offset = [0, 0];
    this.evaluateBounds();
    let scale = this.lastScale * this.scale;
    if (MathUtil.equals(scale, this.defaultScale) && offsetY > 0) {
      // 下拉返回开始先隐藏详情
      this.broadCast.emit(PhotoConstants.PULL_DOWN_START, [null]);
    }
    this.onMoveBigDataMsg({
      eventType: 'move_start',
      scale: scale,
      hasReachLeft: this.hasReachLeft,
      hasReachRight: this.hasReachRight,
    });
  }

  /**
   * 每次回调回来的是相对于此次手势开始点的位移
   */
  /* instrument ignore next */
  onMove(event: GestureEvent): void {
    const scale = this.lastScale * this.scale;
    if (!this.canPan() || scale <= this.defaultScale) {
      return;
    }
    const offsetX = vp2px(event.offsetX);
    const offsetY = vp2px(event.offsetY);
    const timestamp = (event.timestamp - this.offsetStatus.timestamp) / DateUtil.NANOSECONDS_PER_SECOND;
    if (timestamp > 0) {
      this.offsetStatus.speedX = (offsetX - this.offsetStatus.x) / timestamp;
      this.offsetStatus.speedY = (offsetY - this.offsetStatus.y) / timestamp;
      this.offsetStatus.x = offsetX;
      this.offsetStatus.y = offsetY;
      this.offsetStatus.timestamp = event.timestamp;
    }
    Log.debug(TAG, `onMove offsetX=${offsetX},offsetY=${offsetY}`);
    this.moveAction(offsetX, offsetY);
  }

  /**
   * 考虑到离手后处于惯性仍继续运行，将运行的计算剥离出来
   */
  /* instrument ignore next */
  moveAction(offsetX: number, offsetY: number): void {
    this.offset = [offsetX, offsetY];
    this.emitTouchEvent();
  }

  lastMoveAction(offsetX: number, offsetY: number): void {
    this.offset = [offsetX, offsetY];
    const offset = this.evaluateOffset();
    const scale = this.lastScale * this.scale;
    const matrix = Matrix4.identity().scale({
      x: scale,
      y: scale,
    }).translate({
      x: offset[0],
      y: offset[1],
    }).copy();
    this.gestureCallback.onTouchEventRespond(matrix, false);
    this.evaluateBounds();
  }

  /**
   * 不跟手阶段平移使用动画曲线：计算最终位置进行动画过渡
   */
  moveWishAnimation(timesMax: number, scale: number, callback: () => void, isPcPullDown?: boolean): void {
    // 拖动开始时重置offset，防止跳变
    this.lastOffset = this.evaluateOffset();
    this.offset = [0, 0];
    let transitionX = 0;
    let transitionY = 0;
    let times = 0;
    do {
      times = times + PhotoConstants.GESTURE_INTERVAL / DateUtil.MILLISECONDS_PER_SECOND;
      const ratio = (Math.pow(Math.E, Scales.COEFFICIENT_OF_FRICTION *
        times) - 1) / Scales.COEFFICIENT_OF_FRICTION;
      transitionX = this.offsetStatus.speedX * ratio;
      transitionY = this.offsetStatus.speedY * ratio;
    } while (times < timesMax)
    this.offset = [transitionX, transitionY];
    this.lastMoveAction(transitionX, transitionY);
    const msg: Scales.BigData = {
      eventType: 'after_move_end',
      scale: scale,
      offset: this.offset,
      hasReachLeft: this.hasReachLeft,
      hasReachRight: this.hasReachRight,
    };
    this.onMoveBigDataMsg(msg);
    // 非下拉返回场景，重置拖动相关参数
    this.moveEndAction(transitionX, transitionY, isPcPullDown);
    callback();
  }

  /* instrument ignore next */
  onMoveEnd(event: GestureEvent, callback: () => void, isPcPullDown?: boolean, isPcVirKbShown?: boolean): void {
    const offsetX = vp2px(event.offsetX);
    const offsetY = vp2px(event.offsetY);
    const threshold = vp2px(PhotoConstants.THRESHOLD); // 停止阈值，当速度小于threshold，即认为运动停止
    const speed = MathUtil.pythagorean(this.offsetStatus.speedX, this.offsetStatus.speedY);
    const scale = this.lastScale * this.scale;
    this.onMoveBigDataMsg({
      eventType: 'before_move_end',
      scale: scale,
      speed: speed,
      offset: this.offset,
      hasReachLeft: this.hasReachLeft,
      hasReachRight: this.hasReachRight,
    });
    Log.info(TAG, `onMoveEnd isPcVirShown ${isPcVirKbShown}`);
    if ((speed <= threshold && scale <= this.defaultScale) || isPcVirKbShown) {
      this.moveEndAction(offsetX, offsetY, isPcPullDown);
      callback();
      return;
    }
    const timesMax = Math.log(threshold / speed) / Scales.COEFFICIENT_OF_FRICTION;
    this.moveWishAnimation(timesMax, scale, callback, isPcPullDown);
    Log.info(TAG, 'onMoveEnd onAnimationEnd');
  }

  /* instrument ignore next */
  onScaleStart(scale: number, centerX: number, centerY: number): void {
    Log.info(TAG, `onScaleStart: isInAnimation ${this.isInAnimation}, isExiting ${this.isExiting}`);
    if (!this.canTouch()) {
      return;
    }
    if (this.interval) {
      clearInterval(this.interval);
      this.lastOffset = this.evaluateOffset();
      this.interval = null;
    }
    // scale开始时重置this.scale为1
    this.scale = 1;
    this.evaluateBounds();
    // Adjust action bar status
    this.center = this.evaluateCenter(vp2px(centerX), vp2px(centerY));
    const msg: Scales.BigData = {
      eventType: 'scale_start',
      center: this.center,
      lastScale: this.lastScale,
    };
    this.onMoveBigDataMsg(msg);
  }

  /* instrument ignore next */
  onScale(scale: number): void {
    if (!this.canTouch()) {
      return;
    }
    this.evaluateBounds();
    this.scale = scale;
    if (this.lastScale * scale <= Scales.COMPONENT_SCALE_FLOOR) {
      this.scale = Scales.COMPONENT_SCALE_FLOOR / this.lastScale;
    }
    if (this.lastScale * scale >= this.maxScale * Scales.OVER_SCALE_EXTRA_FACTOR) {
      this.scale = this.maxScale * Scales.OVER_SCALE_EXTRA_FACTOR / this.lastScale;
    }
    if (this.lastScale * this.scale <= this.defaultScale) {
      this.offset = [0, 0];
    } else {
      const defaultCoordinate = this.calcCoordinate(this.lastScale);
      const coordinate = this.calcCoordinate(this.lastScale * this.scale);
      this.offset = [defaultCoordinate[0] - coordinate[0], defaultCoordinate[1] - coordinate[1]];
    }
    this.emitTouchEvent();
  }

  /* instrument ignore next */
  onPinchScale(scale: number): void {
    if (this.isExiting) {
      return;
    }
    this.scale = scale;
    if (this.lastScale * scale <= Scales.COMPONENT_SCALE_FLOOR) {
      this.scale = Scales.COMPONENT_SCALE_FLOOR / this.lastScale;
    } else if (this.lastScale * scale >= this.maxScale * Scales.OVER_SCALE_EXTRA_FACTOR) {
      this.scale = this.maxScale * Scales.OVER_SCALE_EXTRA_FACTOR / this.lastScale;
    }
    if (this.lastScale * this.scale <= this.defaultScale) {
      this.offset = [0, 0];
    } else {
      const defaultCoordinate = this.calcCoordinate(this.lastScale);
      const coordinate = this.calcCoordinate(this.lastScale * this.scale);
      this.offset = [defaultCoordinate[0] - coordinate[0], defaultCoordinate[1] - coordinate[1]];
    }
    this.pinchOffset = this.evaluateOffset();
    scale = this.lastScale * this.scale;
    this.updateInnerSmaPicInfo(scale, [this.pinchOffset[0], this.pinchOffset[1]]);
    this.matrix = Matrix4.identity().scale({
      x: scale,
      y: scale,
    }).translate({
      x: this.pinchOffset[0],
      y: this.pinchOffset[1],
    }).copy();
    this.gestureCallback.onTouchEventRespond(this.matrix, true);
  }

  /* instrument ignore next */
  public onScaleInAnimation(scale: number): void {
    if (!this.canTouch()) {
      return;
    }
    this.evaluateBounds();
    Log.info(TAG, `onScaleInAnimation lastScale:${this.lastScale}`);
    this.scale = scale;
    let endScale: number = this.lastScale * this.scale;
    if (this.lastScale * scale <= Scales.COMPONENT_SCALE_FLOOR) {
      this.scale = Scales.COMPONENT_SCALE_FLOOR / this.lastScale;
      endScale = Scales.COMPONENT_SCALE_FLOOR;
    }
    if (this.lastScale * scale >= this.maxScale * Scales.OVER_SCALE_EXTRA_FACTOR) {
      this.scale = this.maxScale * Scales.OVER_SCALE_EXTRA_FACTOR / this.lastScale;
      endScale = this.maxScale * Scales.OVER_SCALE_EXTRA_FACTOR;
    }
    if (endScale <= this.defaultScale) {
      this.offset = [0, 0];
      this.lastOffset = [0, 0];
    } else {
      const defaultCoordinate = this.calcCoordinate(this.lastScale);
      const coordinate = this.calcCoordinate(this.lastScale * this.scale);
      this.offset = [defaultCoordinate[0] - coordinate[0], defaultCoordinate[1] - coordinate[1]];
    }
    Log.info(TAG, `onScaleInAnimation:${endScale}`);
    const matrix = Matrix4.identity().scale({
      x: endScale,
      y: endScale,
    }).copy();
    this.startAnimation(matrix);
    this.lastScale = endScale;
  }

  /* instrument ignore next */
  onResetIsFirstDownLoadOrigin(): void {
    this.isFirstDownLoadOrigin = true;
  }

  /* instrument ignore next */
  downloadForScaleIfNeeded(scale: number): void {
    if (this.isFirstDownLoadOrigin && scale > this.defaultScale) {
      Log.debug(TAG, `trigger download for scale, scale=${scale}`);
      this.isFirstDownLoadOrigin = false;
    }
  }

  /* instrument ignore next */
  onScaleEnd(): void {
    if (!this.canTouch()) {
      return;
    }
    this.evaluateBounds();
    let scale = this.lastScale * this.scale;
    this.lastScale = scale;
    const msg: Scales.BigData = {
      eventType: 'scale_end',
      center: this.center,
      scale: scale,
      maxScale: this.maxScale,
      lastOffset: this.evaluateOffset(),
    }
    this.onMoveBigDataMsg(msg);
    // 非旋转场景共存的捏合，保持原有捏合逻辑
    if (scale >= this.defaultScale && scale <= this.maxScale && !this.isRotationAngleChange) {
      Log.info(TAG, `onscaleEnd scale: ${scale} without animation`);
      this.currentScale = scale;
      this.emitDirectionChange();
      this.lastOffset = this.evaluateOffset(this.lastScale);
      this.lastScale = scale;
      this.offset = [0, 0];
      this.scale = 1;
      return;
    }
    let animationEndMatrix: Matrix4.Matrix4Transit;
    if (this.isBurstPhotos && scale <= this.burstDefaultScale) {
      animationEndMatrix = this.onBurstScaleEnd();
    } else if (this.isRotationAngleChange &&
      scale >= this.defaultScale && scale <= this.maxScale) {
      Log.info(TAG, `onScaleEnd rotationAngle Changed, scale to one`)
      this.currentScale = this.defaultScale;
      animationEndMatrix = Matrix4.identity().scale({
        x: this.defaultScale,
        y: this.defaultScale,
      }).copy();
      this.lastOffset = [0, 0];
      this.offset = [0, 0];
      this.lastScale = this.defaultScale;
      this.scale = 1;
    } else if (scale <= this.defaultScale) {
      this.currentScale = this.defaultScale;
      // 缩小过小，触发恢复的动画
      animationEndMatrix = Matrix4.identity().scale({
        x: this.defaultScale,
        y: this.defaultScale,
      }).copy();
      this.lastOffset = [0, 0];
      this.offset = [0, 0];
      this.lastScale = this.defaultScale;
      this.scale = 1;
    } else {
      // 放大时做缩回maxScale的动画
      this.currentScale = this.maxScale;
      this.lastOffset = this.evaluateOffset();
      const defaultCoordinate = this.calcCoordinate(this.lastScale);
      const coordinate = this.calcCoordinate(this.maxScale);
      this.offset = [defaultCoordinate[0] - coordinate[0], defaultCoordinate[1] - coordinate[1]];
      animationEndMatrix = this.evaluateAnimeMatrix(this.maxScale);
    }
    this.startAnimation(animationEndMatrix);
  }

  // 大图回到defaultScale
  public photoToDefaultScale(): void {
    let matrix: Matrix4.Matrix4Transit;
    this.currentScale = this.defaultScale;
    matrix = Matrix4.identity().scale({
      x: this.defaultScale,
      y: this.defaultScale,
    }).copy();
    this.offset = [0, 0];
    this.lastOffset = [0, 0];
    this.scale = 1;
    this.lastScale = this.defaultScale;
    this.startAnimation(matrix);
  }

  private onBurstScaleEnd(): Matrix4.Matrix4Transit {
    let animationEndMatrix: Matrix4.Matrix4Transit;
    this.currentScale = this.burstDefaultScale;
    // 缩小过小，触发恢复的动画
    animationEndMatrix = Matrix4.identity().scale({
      x: this.burstDefaultScale,
      y: this.burstDefaultScale,
    }).translate({
      x: 0,
      y: this.burstDefaultTranslateY,
    }).copy();
    this.lastOffset = [0, this.burstDefaultTranslateY];
    this.offset = [0, 0];
    this.lastScale = this.burstDefaultScale;
    this.scale = 1;
    return animationEndMatrix;
  }

  /* instrument ignore next */
  getZoomFlag(): boolean {
    return this.lastScale * this.scale > this.defaultScale;
  }

  /**
   * 双击触发缩放，如果当前scale小于等于1，缩放到doubleTapScale；如果当前scale大于1，缩放到1；
   *
   * @param centerX 双击位置
   * @param centerY 双击位置
   */
  /* instrument ignore next */
  onDoubleTap(centerX: number, centerY: number, componentWidth?: number, componentHeight?: number): void {
    if (this.isExiting) {
      return;
    }
    Log.info(TAG, `onDoubleTap, centerX: ${centerX}, centerY: ${centerY}`);
    // Adjust action bar status
    let matrix: Matrix4.Matrix4Transit;
    if (this.lastScale * this.scale > this.defaultScale || this.isBurstPhotos) {
      this.currentScale = this.defaultScale;
      // scale大于1时缩放到原始状态
      matrix = Matrix4.identity().scale({
        x: this.defaultScale,
        y: this.defaultScale,
      }).copy();
      this.offset = [0, 0];
      this.lastOffset = [0, 0];
      this.scale = 1;
      this.lastScale = this.defaultScale;
      this.evaluateBounds();
      this.onMoveBigDataMsg({
        eventType: 'dblClick',
        center: [0.5, 0.5],
        scale: this.defaultScale,
      });
      this.startAnimation(matrix);
    } else {
      // 放大状态根据点击位置计算放大中心
      const center = this.evaluateCenter(vp2px(centerX), vp2px(centerY), componentWidth, componentHeight);
      const scale = this.doubleTapScale * this.defaultScale;
      Log.info(TAG, `onDoubleTap-center:${center}-doubleTapScale:${this.doubleTapScale}-lastScale:${this.lastScale}`);
      let currentComponentWidth: number = this.getCurrentComponentWidth(componentWidth);
      let currentComponentHeight: number = this.getCurrentComponentHeight(componentHeight);
      this.offset = [
        (center[0] - 0.5) * currentComponentWidth * (-this.doubleTapScale),
        (center[1] - 0.5) * currentComponentHeight * (-this.doubleTapScale)
      ];
      Log.info(TAG, `onDoubleTap-offset:${this.offset}`);
      this.currentScale = scale;
      matrix = this.evaluateAnimeMatrix(scale, componentWidth, componentHeight);
      this.evaluateBounds();
      this.onMoveBigDataMsg({
        eventType: 'dblClick',
        center: center,
        scale: scale,
      });
      this.startAnimation(matrix);
    }
  }

  /* instrument ignore next */
  reset(): void {
    this.resetTransitionStatus();
    this.emitDirectionChange();
    // 画中画变量reset
    this.calculateImageScaleInfo();
  }

  public resetBurstPhotos(scale: number, x: number, y: number): void {
    this.reset();
    this.onScale(scale);
    this.onScaleEnd();
    this.offset = [x, y];
    this.emitTouchEvent();
    this.lastOffset = this.evaluateOffset();
    this.offset = [0, 0];
  }

  /* instrument ignore next */
  onDisAppear(): void {
    this.reset();
  }

  /**
   * 动画结束，根据结束的变换矩阵刷新当前的各个参数值，保证连续性，防止下次手势操作时发生跳变
   *
   * @param animationEndMatrix 结束时的变换矩阵
   */
  /* instrument ignore next */
  onAnimationEnd(animationEndMatrix: Matrix4.Matrix4Transit): void {
    if (animationEndMatrix) {
      this.evaluateBounds();
      this.isInAnimation = false;
      this.emitDirectionChange();
    }
  }

  public setSwipeStatus(disable: Boolean): void {
    this.broadCast.emit(PhotoConstants.SET_DISABLE_SWIPE, [disable]);
  }

  startAnimation(animationEndMatrix: Matrix4.Matrix4Transit): void {
    this.isInAnimation = true;
    let animationOption: AnimationParam = {
      duration: PhotoConstants.OVER_SCALE_ANIME_DURATION,
      curve: Curve.Ease,
    };
    this.gestureCallback.onAnimationEventRespond(animationOption, animationEndMatrix);
    this.setSwipeStatus(true);
  }

  /* instrument ignore next */
  isDefaultScale(): boolean {
    return MathUtil.equals(this.lastScale, this.defaultScale);
  }

  /**
   * 将move结束后的事件包装一下
   */
  public moveEndAction(offsetX: number, offsetY: number, isPcPullUp?: boolean): void {
    Log.info(TAG, `moveEndAction isPcPullUp:${isPcPullUp} canTouch:${this.canTouch()} Y:${offsetY}` +
      `burstPhotos:${this.isBurstPhotos} lastScale:${this.lastScale} scale:${this.scale}`)
    if (!this.canTouch()) {
      return;
    }
    let isStartPullDown = false;
    let isResetPullingDown = false;
    let scale = this.lastScale * this.scale;
    if (MathUtil.equals(scale, this.defaultScale) &&
      offsetY > PhotoConstants.PULL_DOWN_THRESHOLD && !this.isBurstPhotos && !isPcPullUp) {
      // 触发下拉返回
      this.emitPullDownToBackEvent();
      isStartPullDown = true;
    } else if (MathUtil.equals(scale, this.defaultScale) &&
      offsetY < -PhotoConstants.PULL_DOWN_THRESHOLD && this.canPullingUp &&
      !this.canPullDownAndDragPhoto() && !isPcPullUp) {
      // 触发上划，但当已处于下拉拖动图片状态时，不触发上滑
      this.emitPullUpToDisplayEvent();
    } else if (MathUtil.equals(scale, this.defaultScale)) {
      // 未到阈值，触发重置动画
      isResetPullingDown = true;
      this.startAnimation(Matrix4.identity().scale({
        x: this.defaultScale,
        y: this.defaultScale,
      }).copy());
      this.emitPullDownCancelEvent();
    } else {
      this.emitDirectionChange();
    }

    // 非下拉返回场景，重置拖动相关参数
    if (isStartPullDown) {
      this.isPullDownAndDragPhoto = false;
      this.isExiting = false;
      return;
    }
    if (!isResetPullingDown) {
      UiUtil.resetGeometryTransitionParams();
    }
    this.lastOffset = this.evaluateOffset();
    this.offset = [0, 0];
    this.touchEventStartX = 0;
    this.touchEventStartY = 0;
    this.isPullDownAndDragPhoto = false;
  }

  // 图片宽高比与视窗宽高比的比例
  public getRatio(): number {
    if (this.item.width * this.item.height * this.componentWidth * this.componentHeight === 0) {
      return 1;
    }
    if (this.rotationAngle / PhotoConstants.ROTATION_NINETY % 2 !== 0) {
      return this.item.height / this.item.width / (this.componentWidth / this.componentHeight);
    }
    return this.item.width / this.item.height / (this.componentWidth / this.componentHeight);
  };

  // 计算缩略图的宽高
  public calculateImgSize(): void {
    Log.info(TAG, `calculateImgSize begin: ${this.width}-${this.height}, item:${this.item.width}-${this.item.height}`);
    if (this.item.width && this.item.height) {
      // 缩略图的宽高未重新计算，这里计算一下
      /* instrument ignore if */
      if (this.isPcResourceSmaller()) {
        this.width = this.item.width;
        this.height = this.item.height;
        return;
      }
      if (this.rotationAngle / PhotoConstants.ROTATION_NINETY % 2 === 0) {
        /* instrument ignore if */
        if (this.getRatio() > 1) {
          this.width = this.componentWidth;
          this.height = this.item.height * (this.width / this.item.width);
          return;
        }
        this.height = this.componentHeight;
        this.width = this.item.width * (this.height / this.item.height);
        return;
      } else {
        if (this.getRatio() > 1) {
          this.width = this.componentWidth;
          this.height = this.item.width * (this.width / this.item.height);
          return;
        }
        this.height = this.componentHeight;
        this.width = this.item.height * (this.height / this.item.width);
        return;
      }
    }
    this.width = PhotoConstants.DEFAULT_SIZE;
    this.height = PhotoConstants.DEFAULT_SIZE;
    Log.info(TAG, `calculateImgSize end: ${this.width}-${this.height}, item:${this.item.width}-${this.item.height}`);
  }

  /**
   * 双击放大的位移计算
   * @param center：点击位置相较于图片左上角的距离占图片的百分比
   * @param scale：放大比例
   */
  public calcCoordinate(scale: number): [number, number] {
    const scaleX = Math.max(scale, this.componentWidth / this.width);
    const scaleY = Math.max(scale, this.componentHeight / this.height);
    return [
      (this.componentWidth - this.width * scaleX) / 2 + this.width * scaleX * this.center[0],
      (this.componentHeight - this.height * scaleY) / 2 + this.height * scaleY * this.center[1]
    ];
  }

  public emitDirectionChange(): void {
    /**
     * reachLeft reachRight scale>1这三个变量，只可能有下面五种情况（scale<=1下reachLeft、reachRight必然为true）：
     * T T T：Vertical
     * T T F：Vertical（大图初始状态）
     * T F T：Vertical | Left
     * F T T：Vertical | Right
     * F F T：All
     */
    let direction: PanDirection = PanDirection.Vertical;
    let scale = this.lastScale * this.scale;
    let isEnlarged = scale > this.defaultScale;
    if (!this.hasReachLeft && !this.hasReachRight && isEnlarged) {
      direction = PanDirection.All;
    } else if (!this.hasReachLeft && this.hasReachRight && isEnlarged) {
      direction = PanDirection.Vertical | PanDirection.Right;
    } else if (this.hasReachLeft && !this.hasReachRight && isEnlarged) {
      direction = PanDirection.Vertical | PanDirection.Left;
    } else {
      direction = PanDirection.Vertical;
    }

    Log.info(TAG, `direction is ${direction}`);
    if (this.isExiting || this.isPullingUp) {
      return;
    }
    let flag = direction === PanDirection.Vertical || direction === (PanDirection.Vertical | PanDirection.Left) ||
      direction === (PanDirection.Vertical | PanDirection.Right);
    Log.info(TAG, `flag is ${flag}`);
    this.setSwipeStatus(!flag);
    this.gestureCallback.onDirectionChangeRespond(direction);
  }

  public evaluateOffset(scale: number = this.lastScale * this.scale, isEvaluateAnime?: boolean,
    componentWidth?: number, componentHeight?: number): [number, number] {
    // 连拍照片缩小按照缩小至完全展示进行y轴方向的位移
    if (this.isBurstPhotos && scale <= this.defaultScale) {
      let offsetY = 0;
      const currentScale = this.lastScale * this.scale;
      if (this.burstDefaultScale !== 1) {
        const calcParam = this.burstDefaultTranslateY / (1 - this.burstDefaultScale);
        offsetY = calcParam - calcParam * currentScale;
      }
      return [0, offsetY];
    } else if (scale < this.defaultScale) {
      return [0, 0];
    }
    let offsetX = this.lastOffset[0] + this.offset[0];
    let offsetY = this.lastOffset[1] + this.offset[1];
    const limits = this.evaluateOffsetRange(scale, isEvaluateAnime, componentWidth, componentHeight);
    // 非缩小场景，始终限制x方向上的offset
    // 不可下拉返回场景，限制y
    offsetY = MathUtil.clamp(offsetY, limits[2], limits[3]);
    offsetX = MathUtil.clamp(offsetX, limits[0], limits[1]);
    return [offsetX, offsetY];
  }

  public emitTouchEvent(): void {
    const offset = this.evaluateOffset();
    const scale = this.lastScale * this.scale;
    Log.debug(TAG, `emitTouchEvent offset0: ${offset[0]}, offset1: ${offset[1]}, scale: ${scale}`);
    this.updateInnerSmaPicInfo(scale, offset);
    const matrix = Matrix4.identity().scale({
      x: scale,
      y: scale,
    }).translate({
      x: offset[0],
      y: offset[1],
    }).copy();
    this.gestureCallback.onTouchEventRespond(matrix, false);
    this.evaluateBounds();
  }

  /**
   * 大图放大倍率计算
   */
  public evaluateScales(): void {
    const mScaleFillLong = this.calcScaleFillLong();
    const mThumbFactor = Math.min(this.item.width / this.width, this.item.height / this.height);
    Log.info(TAG, `getRatio:${this.getRatio()}`);
    if (Math.abs(this.getRatio() - 1) < 0.1 || this.isSubScreen) {
      // 宽高比等于控件显示宽高比，按照两倍放大
      this.doubleTapScale = Scales.SAME_RATIO_SCALE_FACTOR;
      this.leftMost = 0;
      this.topMost = 0;
    } else {
      // 双边充满 顶天立地
      this.doubleTapScale = mScaleFillLong;
    
      if (this.doubleTapScale < Scales.SAME_RATIO_SCALE_FACTOR) {
        Log.info(TAG, `doubleTapScale ${this.doubleTapScale} is too small, set to minimum ${Scales.SAME_RATIO_SCALE_FACTOR}`);
        this.doubleTapScale = Scales.SAME_RATIO_SCALE_FACTOR;
      }
      this.leftMost = 0.0;
      this.topMost = (1 - this.componentWidth * this.height / this.width / this.componentHeight) / 2;
    }
    // // 需求要求捏合放大的最大比例为双边充满的1.5倍和两倍原图的最大值
    this.maxScale = Math.max(Scales.OVER_SCALE_EXTRA_FACTOR * mScaleFillLong,
      Scales.SAME_RATIO_SCALE_FACTOR * mThumbFactor);
    Log.info(TAG, `doubleTapScale: ${this.doubleTapScale} maxScale: ${this.maxScale}`);
  }

  public getBurstDefaultScale(): number {
    if (this.item.width * this.item.height * this.componentWidth * this.burstComponentHeight === 0) {
      return 1;
    }
    const defaultRatio = Math.min(this.componentWidth / this.item.width, this.componentHeight / this.item.height);
    const newRatio = Math.min(this.componentWidth / this.item.width, this.burstComponentHeight / this.item.height);
    return newRatio / defaultRatio;
    return 0
  }

  public setBurstComponentHeight(actionBarHeight: number, previewListHeight: number): void {
    this.burstComponentHeight = this.componentHeight - vp2px(actionBarHeight) - vp2px(previewListHeight);
    this.burstDefaultScale = this.getBurstDefaultScale();
    this.burstDefaultTranslateY = this.burstDefaultScale === 1 ? 0 : vp2px(actionBarHeight - previewListHeight) / 2;
  }

  public calcScaleFillLong(): number {
    let filler = this.componentWidth * this.height / this.width / this.componentHeight;
    if (filler < 1) {
      filler = 1 / filler;
    }
    return filler;
  }

  /* instrument ignore next */
  public calculateScale(mThumbFactor: number): number {
    const minScreenLength = Math.min(this.componentHeight, this.componentWidth);
    const minLength = Math.min(this.item.width, this.item.height);
    let scale = 0;
    if (minLength <= minScreenLength / Scales.MAGNIFICATION) {
      scale = Scales.MAGNIFICATION;
    } else if (minLength < minScreenLength * Scales.MAGNIFICATION) {
      scale = Scales.FACTOR.A + Scales.FACTOR.B * minScreenLength / minLength;
    } else {
      scale = Scales.THRESHOLD * (1 + minScreenLength / minLength);
    }
    return scale * mThumbFactor;
  }

  public calculateCorre(mScaleCustom: number): number {
    if (this.getRatio() > Scales.CORRE.RANGE.MAX) {
      return mScaleCustom * Scales.CORRE.FACTOR.MIN;
    } else if (this.getRatio() < Scales.CORRE.RANGE.MIN) {
      return mScaleCustom;
    }
    return mScaleCustom * Scales.CORRE.FACTOR.MAX;
  }

  public evaluateCompBounds(): [number, number] {
    let scale = this.lastScale * this.scale;
    let offset = this.evaluateOffset();
    // 组件左上角坐标，因放大带来的偏移是-compW*(scale-1)/2，再加上偏移，得到控件左边界，上边界同理
    let result: [number, number] = [
      offset[0] - this.componentWidth * (scale - this.defaultScale) / 2,
      offset[1] - this.componentHeight * (scale - this.defaultScale) / 2
    ];
    return result;
  }

  public getScreenScale(componentWidth?: number, componentHeight?: number): number {
    let currentComponentWidth: number = this.getCurrentComponentWidth(componentWidth);
    let currentComponentHeight: number = this.getCurrentComponentHeight(componentHeight);
    let widthScale = this.width === 0 ? 0 : (currentComponentWidth / this.width);
    let heightScale = this.height === 0 ? 0 : (currentComponentHeight / this.height);
    return Math.min(widthScale, heightScale);
  }

  public evaluateImgDisplaySize(): [number, number] {
    let scale = this.lastScale * this.scale * this.getScreenScale();
    return [this.width * scale, this.height * scale];
  }

  public evaluateImgDisplayBounds(): [number, number] {
    // 组件左边界，因放大带来的偏移是-compW*(scale-1)/2，再加上手势的偏移，得到控件左边界，上边界同理
    let scale = this.lastScale * this.scale;
    let leftTop = this.evaluateCompBounds();
    let imgDisplaySize: [number, number] = this.evaluateImgDisplaySize();
    if (this.width / this.height > this.componentWidth / this.componentHeight) {
      leftTop[1] += (this.componentHeight * scale - imgDisplaySize[1]) / 2;
    } else {
      // 控件宽度减掉图片宽度，除以2就能得到图片左边到控件左边的距离，加上offsetX就是就是图片当前显示的左边界
      leftTop[0] += (this.componentWidth * scale - imgDisplaySize[0]) / 2;
    }
    return leftTop;
  }

  // 计算图片显示边界
  public evaluateBounds(): void {
    let imgDisplaySize: [number, number] = this.evaluateImgDisplaySize();
    let imgDisplayWidth = imgDisplaySize[0];

    let imgDisplayBounds = this.evaluateImgDisplayBounds();
    let imgLeftBound = imgDisplayBounds[0];

    // 因底层计算有误差（小数点后6位），不能以0作为精确边界，左右分别容错1像素
    this.hasReachLeft = imgLeftBound > -1;
    this.hasReachRight = imgLeftBound + imgDisplayWidth < this.componentWidth + 1;
  }

  /**
   * 计算当前scale下x及y方向上的offset上下界
   *
   * @param scale 当前控件显示倍率，通常是 this.lastScale * this.scale
   * @returns 0&1 x方向offset下界&上界，2&3 y方向offset下界&上界
   */
  public evaluateOffsetRange(scale: number, isEvaluateAnime?: boolean,
    componentWidth?: number, componentHeight?: number): [number, number, number, number] {
    let screenScale = this.getScreenScale(componentWidth, componentHeight);
    let currentComponentWidth: number = this.getCurrentComponentWidth(componentWidth);
    let currentComponentHeight: number = this.getCurrentComponentHeight(componentHeight);
    let left = (screenScale * scale * this.width - currentComponentWidth) / 2;
    let top = (screenScale * scale * this.height - currentComponentHeight) / 2;
    top = Math.max(top, 0);
    left = Math.max(left, 0);
    if (this.isCastConnect && !isEvaluateAnime) {
      this.calculateCastFix(this.item);
      if (top !== 0) {
        top += Math.max(Math.min(this.castFixHeight, (screenScale * scale - 1) * this.height / 2), 0);
      }
      if (left !== 0) {
        left += Math.max(Math.min(this.castFixWidth, (screenScale * scale - 1) * this.height / 2), 0);
      }
    }
    return [-left, left, -top, top];
  }

  /* instrument ignore next */
  public emitPullDownToBackEvent(): void {
    Log.info(TAG, `emitPullDownToBack :${this.isPullingUp} ${this.isExiting}`);
    if (this.isPullingUp) {
      this.broadCast.emit(PhotoConstants.TOGGLE_BAR, [null]);
      this.isPullingUp = !this.isPullingUp;
      this.gestureCallback.onEventPullUpRespond(this.isPullingUp);
      return;
    }
    if (this.isExiting) {
      return;
    }
    this.isExiting = true;
    this.broadCast.emit(PhotoConstants.PULL_DOWN_END, []);

    let localStorage: LocalStorage = LocalStorage.getShared();
    let mediaType = localStorage.get<number>(Constants.OPEN_MEDIA_TYPE);
    let scenario =
      ReportToBigDataUtil.getPhotoBrowserScenario(localStorage.get<number>(Constants.SCENARIO_INDEX) ?? -1);
    const msg: Record<string, number | string | undefined> = {
      'scenario': scenario,
      'mediaType': mediaType,
    };
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_PULL_DOWN_ID, msg);
  }

  /* instrument ignore next */
  public emitPullUpToDisplayEvent(): void {
    Log.debug(TAG, 'emitPullUpToDisplayEvent');
    if (this.isPullingUp || !this.canTouch() || DeviceInfo.isPc()) {
      return;
    }
    this.isPullingUp = true;
    this.gestureCallback.onEventPullUpRespond(this.isPullingUp);
  }

  /* instrument ignore next */
  public emitPullDownCancelEvent(): void {
    Log.debug(TAG, 'emitPullDownCancelEvent');
    this.broadCast.emit(PhotoConstants.PULL_DOWN_CANCEL, []);
  }

  private getCurrentComponentWidth(componentWidth?: number): number {
    let currentComponentWidth: number = 0;
    if (componentWidth) {
      currentComponentWidth = componentWidth;
      this.componentWidth = componentWidth;
    } else {
      currentComponentWidth = this.componentWidth;
    }
    return currentComponentWidth;
  }

  private getCurrentComponentHeight(componentHeight?: number): number {
    let currentComponentHeight: number = 0;
    if (componentHeight !== null && componentHeight !== undefined) {
      currentComponentHeight = componentHeight;
      this.componentHeight = componentHeight;
    } else {
      currentComponentHeight = this.componentHeight;
    }
    return currentComponentHeight;
  }

  /**
   * 计算当前缩放中心相对图片的百分比位置
   *
   * @param centerX 触摸点在屏幕上的绝对位置
   * @param centerY 触摸点在屏幕上的绝对位置
   * @returns 当前缩放中心相对控件的百分比位置
   */
  public evaluateCenter(centerX: number, centerY: number, componentWidth?: number,
    componentHeight?: number): [number, number] {
    let currentComponentWidth: number = this.getCurrentComponentWidth(componentWidth);
    let currentComponentHeight: number = this.getCurrentComponentHeight(componentHeight);
    // 计算出控件左上角相对于当前显示左上角的坐标
    const imgDisplayWidth = this.width * this.lastScale;
    const imgDisplayHeight = this.height * this.lastScale;
    // 图片左上角坐标
    const imgX = (currentComponentWidth - imgDisplayWidth) / 2 + this.lastOffset[0];
    const imgY = (currentComponentHeight - imgDisplayHeight) / 2 + this.lastOffset[1];
    let cX = currentComponentWidth > imgDisplayWidth ?
      centerX / currentComponentWidth : (centerX - imgX) / imgDisplayWidth;
    let cY = currentComponentHeight > imgDisplayHeight ?
      centerY / currentComponentHeight : (centerY - imgY) / imgDisplayHeight;
    return [cX, cY];
  }

  public evaluateAnimeMatrix(scale: number, componentWidth?: number, componentHeight?: number): Matrix4.Matrix4Transit {
    const offset = this.evaluateOffset(scale, true, componentWidth, componentHeight);
    let animationEndMatrix = Matrix4.identity()
      .copy()
      .scale({
        x: scale,
        y: scale,
      })
      .translate({
        x: offset[0],
        y: offset[1],
      })
      .copy();
    this.lastOffset = offset;
    this.offset = [0, 0];
    this.lastScale = scale;
    this.scale = 1;
    return animationEndMatrix;
  }

  /**
   * 打点参数
   * @params width: 原始图片宽
   * @params height: 原始图片高
   * @params screenHeight: 屏幕高
   * @params screenWidth: 屏幕宽
   * @params eventType: 事件
   * @params center: 放大中心
   * @params scale: 放大倍率
   * @params offset: 位移
   */
  public onMoveBigDataMsg(status: Scales.BigData): void {
    let msg: Scales.BigData = {};
    msg.width = this.item.width;
    msg.height = this.item.height;
    msg.screenHeight = this.componentHeight;
    msg.screenWidth = this.componentWidth;
    msg.lastOffset = this.lastOffset;
    msg = Scales.overwrite(msg, status);
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_GESTURE_ACTION_ID, msg);
    Log.info('PHOTO_GESTURE_ACTION',
      `screenHeight:${msg.screenHeight}, screenWidth:${msg.screenWidth}, speed:${msg.speed}, offset:${msg.offset},
      eventType:${msg.eventType}, lastScale:${msg.lastScale}, defaultScale:${msg.defaultScale},
      scale:${msg.scale}, center:${msg.center}, lastOffset:${msg.lastOffset}, maxScale:${msg.maxScale},
      hasReachLeft:${msg.hasReachLeft}, hasReachRight:${msg.hasReachRight}, height:${msg.height}, width:${msg.width}`);
  }

  public isPcResourceSmaller(): boolean {
    return false
  }
}