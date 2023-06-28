/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import Matrix4 from '@ohos.matrix4';
import { MediaItem } from './MediaItem';
import { Log } from '../../../utils/Log';
import { BroadCast } from '../../../utils/BroadCast';
import { MathUtil } from '../../../utils/MathUtil';
import { Constants as PhotoConstants } from './Constants';
import { ScreenManager } from '../../common/ScreenManager';
import { PhotoItemGestureCallback } from '../../browser/photo/PhotoItemGestureCallback';
import { BigDataConstants, ReportToBigDataUtil } from '../../../utils/ReportToBigDataUtil';
import { UiUtil } from '../../../utils/UiUtil';

const TAG: string = 'common_EventPipeline';

export type AnimationParam = {
  duration: number,
  curve: Curve
};

export class EventPipeline {
  // 上次平移
  private lastOffset: [number, number] = [0, 0];

  // 当前平移
  private offset: [number, number] = [0, 0];

  // 上次缩放值
  private lastScale: number = 1.0;

  // 默认缩放值
  private defaultScale: number = 1.0;

  // 当前缩放值
  private scale: number = 1.0;

  // 缩放中心点，是相对于控件的百分比位置，非绝对位置
  private center: [number, number] = [0.5, 0.5];

  // 最左缩放中心，(1 - leftMost)即为最右缩放中心
  private leftMost: number = 0.0;

  // 最上缩放中心，(1 - topMost)即为最下缩放中心
  private topMost: number = 0.0;

  // 双击缩放比例
  private doubleTapScale: number = 1.0;

  // 最大缩放比例
  private maxScale: number = 1.0;

  // 是否已经到达最左边
  private hasReachLeft: boolean = true;

  // 是否已经到达最右边
  private hasReachRight: boolean = true;

  // 事件总线
  private broadCast: BroadCast;

  // 数据单个条目项
  private item: MediaItem;

  // 事件总线
  private gestureCallback: PhotoItemGestureCallback;

  // 宽度
  private width: number;

  // 高度
  private height: number;

  // 大图显示控件宽度
  private componentWidth: number = vp2px(ScreenManager.getInstance().getWinLayoutWidth());

  // 大图显示控件高度
  private componentHeight: number = vp2px(ScreenManager.getInstance().getWinLayoutHeight());

  // 是否在做动画
  private isInAnimation: boolean = false;

  // 下拉返回flag，防止触发多次
  private isExiting: boolean = false;

  private touchEventStartX: number = 0;

  private touchEventStartY: number = 0;

  private touchEventStartId: number = 0;

  private isPullDownAndDragPhoto: boolean = false;

  constructor(broadCastParam: BroadCast, item: MediaItem, gestureCallback: PhotoItemGestureCallback) {
    this.broadCast = broadCastParam;
    this.item = item;
    this.gestureCallback = gestureCallback;
    this.width = this.item.imgWidth == 0 ? PhotoConstants.DEFAULT_SIZE : this.item.imgWidth;
    this.height = this.item.imgHeight == 0 ? PhotoConstants.DEFAULT_SIZE : this.item.imgHeight;
    this.evaluateScales();
  }

  onDataChanged(item: MediaItem) {
    this.item = item;
    this.width = this.item.imgWidth == 0 ? PhotoConstants.DEFAULT_SIZE : this.item.imgWidth;
    this.height = this.item.imgHeight == 0 ? PhotoConstants.DEFAULT_SIZE : this.item.imgHeight;
    this.evaluateScales();
  }

  setDefaultScale(scale) {
    this.defaultScale = scale;
    this.lastScale = scale;
  }

  onComponentSizeChanged(componentWidth: number, componentHeight: number) {
    Log.info(TAG, `onComponentSizeChanged componentWidth ${componentWidth} componentHeight ${componentHeight}`)
    this.componentWidth = componentWidth;
    this.componentHeight = componentHeight;
    this.evaluateScales();
    let animationEndMatrix: Matrix4.Matrix4Transit = this.evaluateAnimeMatrix(this.lastScale, this.center);
    this.startAnimation(animationEndMatrix);
  }

  public canTouch(): Boolean {
    return !(this.isInAnimation || this.isExiting);
  }

  onTouch(event: TouchEvent) {
    Log.debug(TAG, `onTouch trigger: ${event.type}, ${[this.isInAnimation, this.isExiting]}`);
    if (!this.canTouch()) {
      return;
    }
    if (event.type == TouchType.Down || event.type == TouchType.Up) {
      this.emitDirectionChange();
    }
    this.verifyPullDownAndDragPhotoStatus(event);

    // 普通场景up时记录scale及offset，动画场景动画结束时记录
    if (event.type == TouchType.Up) {
      this.lastOffset = this.evaluateOffset();
      this.lastScale = this.lastScale * this.scale;
      // 必须重置scale及offset，否则多次操作间会串，但是center不用清，因为this.scale为1时center不起作用
      this.scale = 1;
      this.offset = [0, 0];
    }
  }

  verifyPullDownAndDragPhotoStatus(event: TouchEvent): void {
    let scale = this.lastScale * this.scale;
    let isEnlarged = Number(scale.toFixed(PhotoConstants.RESERVED_DIGITS)) > Number(this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS));
    let touchList = event.touches;

    if (touchList.length > 1) {
      return;
    }
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
      if (deltaY - deltaX > PhotoConstants.CAN_PULL_DOWN_DRAG_THRESHOLD && !isEnlarged) {
        this.isPullDownAndDragPhoto = true;
      }
    }

    if (this.isPullDownAndDragPhoto) {
      this.gestureCallback.onDirectionChangeRespond(PanDirection.All);
    }
    Log.debug(TAG, 'canPullDownAndDragPhoto ' + this.isPullDownAndDragPhoto);
  }

  canPullDownAndDragPhoto(): boolean {
    return this.isPullDownAndDragPhoto;
  }

  onMoveStart(offsetX: number, offsetY: number) {
    if (this.isInAnimation || this.isExiting) {
      return;
    }
    // 拖动开始时重置offset，防止跳变
    this.offset = [0, 0];
    this.evaluateBounds();
    let scale = this.lastScale * this.scale;
    if (Number(scale.toFixed(PhotoConstants.RESERVED_DIGITS)) > Number(this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS))) {
      // 有缩放拖动时隐藏bars
      this.broadCast.emit(PhotoConstants.HIDE_BARS, [null]);
    }
    if (scale.toFixed(PhotoConstants.RESERVED_DIGITS) === this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS) && offsetY > 0) {
      // 下拉返回开始先隐藏详情
      this.broadCast.emit(PhotoConstants.PULL_DOWN_START, [null]);
    }
  }

  /**
   * 每次回调回来的是相对于此次手势开始点的位移
   *
   * @param offsetX offsetX
   * @param offsetY offsetY
   */
  onMove(offsetX: number, offsetY: number) {
    if (this.isInAnimation || this.isExiting) {
      return;
    }
    let scale = this.lastScale * this.scale;
    let limits = this.evaluateOffsetRange(scale);
    let measureX = this.lastOffset[0] + (this.center[0] - 0.5) * this.componentWidth * (this.defaultScale - this.scale) * this.lastScale;
    let measureY = this.lastOffset[1] + (this.center[1] - 0.5) * this.componentHeight * ((this.defaultScale - this.scale)) * this.lastScale;
    let moveX = offsetX;
    let moveY = offsetY;
    let offX = measureX + moveX;
    let offY = measureY + moveY;

    if (Number(scale.toFixed(PhotoConstants.RESERVED_DIGITS)) > Number(this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS))) {
      // 非缩小场景，始终限制x方向上的offset
      offX = MathUtil.clamp(offX, limits[0], limits[1]);
      if (Number(scale.toFixed(PhotoConstants.RESERVED_DIGITS)) > Number(this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS))) {
        // 不可下拉返回场景，限制y
        offY = MathUtil.clamp(offY, limits[PhotoConstants.NUMBER_2], limits[PhotoConstants.NUMBER_3]);
      } else {
        // 可下拉返回场景，只限制y向上拖动，即限制下界
        offY = Math.max(limits[PhotoConstants.NUMBER_2], offY);
      }
    }
    let tmpX = offX - measureX;
    let tmpY = offY - measureY;
    this.offset = [tmpX, tmpY];
    this.emitTouchEvent();
  }

  onMoveEnd(offsetX: number, offsetY: number) {
    if (this.isInAnimation || this.isExiting) {
      return;
    }

    let isStartPullDown = false;
    let scale = this.lastScale * this.scale;
    if (scale.toFixed(PhotoConstants.RESERVED_DIGITS) === this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS) &&
    offsetY > PhotoConstants.PULL_DOWN_THRESHOLD) {
      // 触发下拉返回
      this.emitPullDownToBackEvent();
      isStartPullDown = true;
    } else if (scale.toFixed(PhotoConstants.RESERVED_DIGITS) === this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS) &&
    offsetY < -PhotoConstants.PULL_DOWN_THRESHOLD && !this.canPullDownAndDragPhoto()) {
      // 触发上划，但当已处于下拉拖动图片状态时，不触发上滑
      this.emitPullUpToDisplayEvent();
    } else if (scale.toFixed(PhotoConstants.RESERVED_DIGITS) === this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS)) {
      // 未到阈值，触发重置动画
      this.startAnimation(Matrix4.identity().scale({
        x: this.defaultScale,
        y: this.defaultScale
      }).copy());
      this.emitPullDownCancelEvent()
    } else {
      this.emitDirectionChange();
    }

    // 非下拉返回场景，重置拖动相关参数
    if (!isStartPullDown) {
      UiUtil.resetGeometryTransitionParams();
      this.touchEventStartX = 0;
      this.touchEventStartY = 0;
      this.isPullDownAndDragPhoto = false;
    }
  }

  onScaleStart(scale: number, centerX: number, centerY: number) {
    Log.info(TAG, `onScaleStart: ${[this.isInAnimation, this.isExiting]}`);
    if (this.isInAnimation || this.isExiting) {
      return;
    }
    // scale开始时重置this.scale为1
    this.scale = 1;
    this.evaluateBounds();
    // Adjust action bar status
    this.broadCast.emit(PhotoConstants.HIDE_BARS, []);
    this.center = this.evaluateCenter(centerX, centerY);
  }

  onScale(scale: number) {
    Log.info(TAG, `onScale: ${[this.isInAnimation, this.isExiting]}, scale: ${scale}`);
    if (this.isInAnimation || this.isExiting) {
      return;
    }
    this.evaluateBounds();
    this.scale = scale;
    if (this.lastScale * scale <= PhotoConstants.COMPONENT_SCALE_FLOOR) {
      this.scale = PhotoConstants.COMPONENT_SCALE_FLOOR / this.lastScale;
    }
    if (this.lastScale * scale >= this.maxScale * PhotoConstants.OVER_SCALE_EXTRA_FACTOR) {
      this.scale = this.maxScale * PhotoConstants.OVER_SCALE_EXTRA_FACTOR / this.lastScale;
    }
    this.emitTouchEvent();
  }

  onScaleEnd() {
    Log.info(TAG, `onScaleEnd: ${[this.isInAnimation, this.isExiting]}`);
    if (this.isInAnimation || this.isExiting) {
      return;
    }
    this.evaluateBounds();
    let scale = this.lastScale * this.scale;
    if (Number(scale.toFixed(PhotoConstants.RESERVED_DIGITS)) >= Number(this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS)) && scale <= this.maxScale) {
      Log.info(TAG, `does not need to do animation: ${scale}`);
      this.emitDirectionChange();
      return;
    }
    let animationEndMatrix: Matrix4.Matrix4Transit = null;
    if (Number(scale.toFixed(PhotoConstants.RESERVED_DIGITS)) <= Number(this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS))) {
      // 缩小过小，触发恢复的动画
      animationEndMatrix = Matrix4.identity().scale({
        x: this.defaultScale,
        y: this.defaultScale
      }).copy();
    } else {
      // 放大时做缩回maxScale的动画
      animationEndMatrix = this.evaluateAnimeMatrix(this.maxScale, this.center);
    }
    this.startAnimation(animationEndMatrix);
  }

  /**
   * 双击触发缩放，如果当前scale小于等于1，缩放到doubleTapScale；如果当前scale大于1，缩放到1；
   *
   * @param centerX 双击位置
   * @param centerY 双击位置
   */
  onDoubleTap(centerX: number, centerY: number) {
    if (this.isInAnimation || this.isExiting) {
      Log.debug(TAG, `[onDoubleTap] not avaliable: ${[this.isInAnimation, this.isExiting]}`);
      return;
    }
    // Adjust action bar status
    this.broadCast.emit(PhotoConstants.HIDE_BARS, []);
    let matrix: Matrix4.Matrix4Transit = undefined;
    if (Number(this.lastScale.toFixed(PhotoConstants.RESERVED_DIGITS)) * this.scale > Number(this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS))) {
      // scale大于1时缩放到原始状态
      matrix = Matrix4.identity().scale({
        x: this.defaultScale,
        y: this.defaultScale
      }).copy();
      Log.debug(TAG, '[onDoubleTap] matrix scale 1');
    } else {
      // 放大状态根据点击位置计算放大中心
      this.center = this.evaluateCenter(centerX, centerY);
      // 图片宽高比小于控件宽高比时，centerX置为0.5，反之centerY置为0.5，保证双击放大后短边靠边
      if (this.width / this.height < this.componentWidth / this.componentHeight) {
        this.center[0] = PhotoConstants.COMPONENT_SCALE_FLOOR;
      } else {
        this.center[1] = PhotoConstants.COMPONENT_SCALE_FLOOR;
      }
      matrix = this.evaluateAnimeMatrix(this.doubleTapScale * this.defaultScale, this.center);
      Log.debug(TAG, '[onDoubleTap] matrix scale center');
    }
    this.startAnimation(matrix);
  }

  reset() {
    this.lastOffset = [0, 0];
    this.offset = [0, 0];
    this.lastScale = 1.0;
    this.scale = 1;
    this.hasReachLeft = true;
    this.hasReachRight = true;
    this.isInAnimation = false;
    this.isExiting = false;
    this.emitDirectionChange();
  }

  onDisAppear() {
    Log.info(TAG, 'onDisAppear');
    this.reset();
  }

  /**
   * 动画结束，根据结束的变换矩阵刷新当前的各个参数值，保证连续性，防止下次手势操作时发生跳变
   *
   * @param animationEndMatrix 结束时的变换矩阵
   */
  onAnimationEnd(animationEndMatrix: Matrix4.Matrix4Transit): void {
    if (animationEndMatrix) {
      // @ts-ignore
      let matrix = animationEndMatrix.matrix4x4;
      Log.info(TAG, `onAnimationEnd: ${matrix}`);
      this.lastScale = matrix[0];
      this.scale = 1;
      this.lastOffset = [matrix[PhotoConstants.NUMBER_12], matrix[PhotoConstants.NUMBER_13]];
      this.offset = [0, 0];
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
      curve: Curve.Ease
    };
    this.gestureCallback.onAnimationEventRespond(animationOption, animationEndMatrix);
    this.setSwipeStatus(true);
  }

  isDefaultScale(): boolean {
    return Number(this.lastScale.toFixed(PhotoConstants.RESERVED_DIGITS)) ===
    Number(this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS));
  }

  private emitDirectionChange(): void {
    /**
     * reachLeft reachRight scale>1这三个变量，只可能有下面五种情况（scale<=1下reachLeft、reachRight必然为true）：
     * T T T：Vertical
     * T T F：Vertical（大图初始状态）
     * T F T：Vertical | Left
     * F T T：Vertical | Right
     * F F T：All
     */
    let direction: any = undefined;
    let scale = this.lastScale * this.scale;
    let isEnlarged = Number(scale.toFixed(PhotoConstants.RESERVED_DIGITS)) > Number(this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS));
    if (!this.hasReachLeft && !this.hasReachRight && isEnlarged) {
      direction = PanDirection.All;
    } else if (!this.hasReachLeft && this.hasReachRight && isEnlarged) {
      direction = PanDirection.Vertical | PanDirection.Right;
    } else if (this.hasReachLeft && !this.hasReachRight && isEnlarged) {
      direction = PanDirection.Vertical | PanDirection.Left;
    } else {
      direction = PanDirection.Vertical;
    }

    if (this.isExiting) {
      return;
    }
    if (direction == PanDirection.Vertical || direction == (PanDirection.Vertical | PanDirection.Left) ||
    direction == (PanDirection.Vertical | PanDirection.Right)) {
      this.setSwipeStatus(false);
    } else {
      this.setSwipeStatus(true);
    }
    Log.debug(TAG, `emitDirectionChange reaches: ${[this.hasReachLeft, this.hasReachRight]}, scale ${scale}, direction: ${direction}`);
    this.gestureCallback.onDirectionChangeRespond(direction);
  }

  private evaluateOffset(): [number, number] {
    Log.info(TAG, `evaluateOffset lastOffset: ${this.lastOffset}, offset: ${this.offset}`);
    let centerX = (this.center[0] - 0.5) * this.componentWidth * (this.defaultScale - this.scale) * this.lastScale;
    let centerY = (this.center[1] - 0.5) * this.componentHeight * (this.defaultScale - this.scale) * this.lastScale;
    let offsetX = this.lastOffset[0] + this.offset[0] + centerX;
    let offsetY = this.lastOffset[1] + this.offset[1] + centerY;
    Log.info(TAG, `evaluateOffset offsetX: ${offsetX}, offsetY: ${offsetY}`);
    return [offsetX, offsetY];
  }

  private emitTouchEvent(): void {
    let offset: [number, number];
    let scale = this.lastScale * this.scale;
    if (Number(scale.toFixed(PhotoConstants.RESERVED_DIGITS)) > Number(this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS))) {
      let limits = this.evaluateOffsetRange(scale);
      offset = this.evaluateOffset();
      // 非缩小场景，始终限制x方向上的offset
      offset[0] = MathUtil.clamp(offset[0], limits[0], limits[1]);
      if (Number(scale.toFixed(PhotoConstants.RESERVED_DIGITS)) > Number(this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS))) {
        // 不可下拉返回场景，限制y
        offset[1] = MathUtil.clamp(offset[1], limits[PhotoConstants.NUMBER_2], limits[PhotoConstants.NUMBER_3]);
      } else {
        // 可下拉返回场景，只限制y向上拖动，即限制下界
        offset[1] = Math.max(limits[PhotoConstants.NUMBER_2], offset[1]);
      }
    } else {
      // 缩小时调整缩放中心为显示中心点
      offset = [0, 0];
    }
    let moveX = offset[0];
    let moveY = offset[1];
    let matrix = Matrix4.identity().scale({
      x: scale,
      y: scale,
    }).translate({
      x: moveX,
      y: moveY
    }).copy();
    Log.info(TAG, `emitTouchEvent lastOffset: ${this.lastOffset}, offset: ${this.offset}, center: ${this.center}, scale: ${[this.lastScale, this.scale]}`);
    this.gestureCallback.onTouchEventRespond(matrix);
    this.evaluateBounds();
  }

  /**
   * 大图放大倍率计算，主要包含：
   * 1. 最大放大倍率maxScale
   * 最大可放大到 maxScale * PhotoConstants.OVER_SCALE_EXTRA_FACTOR，然后回弹至maxScale；
   * 如果小于doubleTapScale * PhotoConstants.MAX_SCALE_EXTRA_FACTOR，取该值作为放大倍率；
   * 2. 双击放大倍率doubleTapScale
   * 默认使图片长边对齐屏幕边缘，如果小于PhotoConstants.SAME_RATIO_SCALE_FACTOR（4/3）取该值
   */
  private evaluateScales(): void {
    if (this.width * this.componentHeight < this.componentWidth * this.height) {
      // 宽高比小于控件显示宽高比，控件高度与图片高度相等
      this.maxScale = this.height / this.componentHeight;
      // 双击放大的scale保证左右充满边界
      this.doubleTapScale = this.componentWidth * this.height / this.width / this.componentHeight;
      // leftMost = (1 - dspW / compW) / 2 = (1 - compH * imgW / imgH / compW) / 2
      this.leftMost = (1 - this.componentHeight * this.width / this.height / this.componentWidth) / 2;
      this.topMost = 0.0;
    } else if (this.width * this.componentHeight == this.componentWidth * this.height) {
      // 宽高比等于控件显示宽高比
      this.doubleTapScale = PhotoConstants.SAME_RATIO_SCALE_FACTOR;
      this.maxScale = this.doubleTapScale * PhotoConstants.MAX_SCALE_EXTRA_FACTOR;
      this.leftMost = 0;
      this.topMost = 0;
    } else {
      // 宽高比大于控件显示宽高比，控件宽度与图片宽度相等
      this.maxScale = this.width / this.componentWidth;
      // 双击放大的scale保证上下充满边界
      this.doubleTapScale = this.componentHeight * this.width / this.height / this.componentWidth;
      this.leftMost = 0.0;
      // topMost = (1 - dspH / compH) / 2 = (1 - compW * imgH / imgW / compH) / 2
      this.topMost = (1 - this.componentWidth * this.height / this.width / this.componentHeight) / 2;
    }

    this.maxScale = Math.max(this.maxScale, PhotoConstants.COMPONENT_SCALE_CEIL);
    if (this.doubleTapScale > this.maxScale) {
      this.maxScale = this.doubleTapScale * PhotoConstants.MAX_SCALE_EXTRA_FACTOR;
    }
    Log.debug(TAG, `evaluateScales: ${this.width}*${this.height} & ${this.componentWidth}*${this.componentHeight}, max: ${this.maxScale}, most: [${this.leftMost},${this.topMost}], double: ${this.doubleTapScale}`);
  }

  private evaluateCompBounds(): [number, number] {
    let scale = this.lastScale * this.scale;
    let offset = this.evaluateOffset();
    // 组件左上角坐标，因放大带来的偏移是-compW*(scale-1)/2，再加上偏移，得到控件左边界，上边界同理
    let result: [number, number] = [
      offset[0] - this.componentWidth * (Number(scale.toFixed(PhotoConstants.RESERVED_DIGITS)) - Number(this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS))) / 2,
      offset[1] - this.componentHeight * (Number(scale.toFixed(PhotoConstants.RESERVED_DIGITS)) - Number(this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS))) / 2
    ];
    Log.debug(TAG, `evaluateCompBounds: ${result}`);
    return result;
  }

  private evaluateImgDisplaySize(): [number, number] {
    let screenScale = 1;
    let widthScale = this.componentWidth / this.item.imgWidth;
    let heightScale = this.componentHeight / this.item.imgHeight;
    screenScale = widthScale > heightScale ? heightScale : widthScale;
    let scale = this.lastScale * this.scale * screenScale;
    let imgDisplayWidth = 0;
    let imgDisplayHeight = 0;
    imgDisplayWidth = this.width * scale;
    imgDisplayHeight = this.height * scale;
    return [imgDisplayWidth, imgDisplayHeight];
  }

  private evaluateImgDisplayBounds(): [number, number] {
    // 组件左边界，因放大带来的偏移是-compW*(scale-1)/2，再加上手势的偏移，得到控件左边界，上边界同理
    let scale = this.lastScale * this.scale;
    let leftTop = this.evaluateCompBounds();
    let imgDisplaySize: [number, number] = this.evaluateImgDisplaySize();
    let imgDisplayWidth = imgDisplaySize[0];
    let imgDisplayHeight = imgDisplaySize[1];
    let imgLeftBound = 0;
    let imgTopBound = 0;
    if (this.width / this.height > this.componentWidth / this.componentHeight) {
      imgLeftBound = leftTop[0];
      imgTopBound = leftTop[1] + (this.componentHeight * scale - imgDisplayHeight) / 2;
    } else {
      // 控件宽度减掉图片宽度，除以2就能得到图片左边到控件左边的距离，加上offsetX就是就是图片当前显示的左边界
      imgLeftBound = (this.componentWidth * scale - imgDisplayWidth) / 2 + leftTop[0];
      imgTopBound = leftTop[1];
    }
    return [imgLeftBound, imgTopBound];
  }

  // 计算图片显示边界
  private evaluateBounds(): void {
    let imgDisplaySize: [number, number] = this.evaluateImgDisplaySize();
    let imgDisplayWidth = imgDisplaySize[0];

    let imgDisplayBounds = this.evaluateImgDisplayBounds();
    let imgLeftBound = imgDisplayBounds[0];

    // 因底层计算有误差（小数点后6位），不能以0作为精确边界，左右分别容错1像素
    this.hasReachLeft = imgLeftBound > -1;
    this.hasReachRight = imgLeftBound + imgDisplayWidth < this.componentWidth + 1;
    Log.info(TAG, `evaluateBounds scale: ${this.hasReachLeft}, offset: ${this.hasReachRight}`);

  }

  /**
   * 计算当前scale下x及y方向上的offset上下界
   *
   * @param scale 当前控件显示倍率，通常是 this.lastScale * this.scale
   * @returns 0&1 x方向offset下界&上界，2&3 y方向offset下界&上界
   */
  private evaluateOffsetRange(scale: number): [number, number, number, number] {
    let result: [number, number, number, number] = [0, 0, 0, 0];
    let screenScale = 1;
    let widthScale = this.componentWidth / this.item.imgWidth;
    let heightScale = this.componentHeight / this.item.imgHeight;
    screenScale = widthScale > heightScale ? heightScale : widthScale;
    let left = (screenScale * scale * this.width - this.componentWidth) / 2;
    let top = (screenScale * scale * this.height - this.componentHeight) / 2;
    top = Math.max(top, 0);
    left = Math.max(left, 0);
    result = [-left, left, -top, top];
    Log.info(TAG, `evaluateOffsetRange scale: ${scale}, defaultScale: ${this.defaultScale}, result: ${result}`);
    return result;
  }

  private emitPullDownToBackEvent(): void {
    Log.debug(TAG, `emitPullDownToBackEvent`);
    if (this.isExiting) {
      Log.info(TAG, `emitPullDownToBack isExiting: ${this.isExiting}`);
      return;
    }
    this.isExiting = true;
    Log.info(TAG, `emitPullDownToBack change isExiting into: ${this.isExiting}`);
    this.broadCast.emit(PhotoConstants.PULL_DOWN_END, []);
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_PULL_DOWN_ID, null);
  }

  private emitPullUpToDisplayEvent(): void {
    Log.debug(TAG, 'emitPullUpToDisplayEvent');
    if (!this.canTouch()) {
      return;
    }
  }

  private emitPullDownCancelEvent(): void {
    Log.debug(TAG, 'emitPullDownCancelEvent');
    this.broadCast.emit(PhotoConstants.PULL_DOWN_CANCEL, []);
  }

  /**
   * 计算当前缩放中心相对控件的百分比位置
   *
   * @param centerX 触摸点在屏幕上的绝对位置
   * @param centerY 触摸点在屏幕上的绝对位置
   * @returns 当前缩放中心相对控件的百分比位置
   */
  private evaluateCenter(centerX: number, centerY: number): [number, number] {
    // 计算出控件左上角相对于当前显示左上角的坐标
    let scale = this.lastScale * this.scale;
    let leftTop = this.evaluateCompBounds();

    // 得出相对于控件的触摸坐标
    let cxRelativeToComp = MathUtil.clamp((centerX - leftTop[0]) / (this.componentWidth * scale), this.leftMost, 1 - this.leftMost);
    let cyRelativeToComp = MathUtil.clamp((centerY - leftTop[1]) / (this.componentHeight * scale), this.topMost, 1 - this.topMost);

    let imgDisplaySize: [number, number] = this.evaluateImgDisplaySize();
    let imgDisplayWidth = imgDisplaySize[0];
    let imgDisplayHeight = imgDisplaySize[1];

    let imgDisplayBounds = this.evaluateImgDisplayBounds();
    let imgLeftBound = imgDisplayBounds[0];
    let imgTopBound = imgDisplayBounds[1];

    // 触摸中心点在图片显示区域外时，取中点
    if (this.width / this.height > this.componentWidth / this.componentHeight) {
      if (centerY < imgTopBound || centerY > imgTopBound + imgDisplayHeight) {
        cyRelativeToComp = 0.5;
      }
    } else {
      if (centerX < imgLeftBound || centerX > imgLeftBound + imgDisplayWidth) {
        cxRelativeToComp = 0.5;
      }
    }

    // 算出触摸的中心点百分比
    let center: [number, number] = [cxRelativeToComp, cyRelativeToComp];
    Log.info(TAG, `evaluateCenter center: ${center}, ${[centerX, centerY]}, size: ${imgDisplaySize}, bounds: ${imgDisplayBounds}, leftTop: ${leftTop}, compSize: ${[this.componentWidth * scale, this.componentHeight * scale]}`);
    return center;
  }

  private evaluateAnimeMatrix(scale: number, center: [number, number]): Matrix4.Matrix4Transit {
    let offset = [
      this.lastOffset[0] + this.offset[0] + (center[0] - 0.5) * this.componentWidth * (this.defaultScale - scale / this.lastScale) * this.lastScale,
      this.lastOffset[1] + this.offset[1] + (center[1] - 0.5) * this.componentHeight * (this.defaultScale - scale / this.lastScale) * this.lastScale
    ]
    if (Number(scale.toFixed(PhotoConstants.RESERVED_DIGITS)) > Number(this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS))) {
      let limits = this.evaluateOffsetRange(scale);
      offset[0] = MathUtil.clamp(offset[0], limits[0], limits[1]);
      // 非缩小场景，始终限制x方向上的offset
      offset[0] = MathUtil.clamp(offset[0], limits[0], limits[1]);
      if (Number(scale.toFixed(PhotoConstants.RESERVED_DIGITS)) > Number(this.defaultScale.toFixed(PhotoConstants.RESERVED_DIGITS))) {
        // 不可下拉返回场景，限制y
        offset[1] = MathUtil.clamp(offset[1], limits[PhotoConstants.NUMBER_2], limits[PhotoConstants.NUMBER_3]);
      } else {
        // 可下拉返回场景，只限制y向上拖动，即限制下界
        offset[1] = Math.max(limits[PhotoConstants.NUMBER_2], offset[1]);
      }
    } else {
      // 缩小时调整缩放中心为显示中心点
      offset = [0, 0];
    }
    let animationEndMatrix = Matrix4.identity().copy().scale({
      x: scale,
      y: scale,
    }).translate({
      x: offset[0],
      y: offset[1]
    }).copy();
    Log.debug(TAG, `evaluateAnimeMatrix scale: ${scale}, center: ${center}, result: ${animationEndMatrix}`);
    return animationEndMatrix;
  }
}