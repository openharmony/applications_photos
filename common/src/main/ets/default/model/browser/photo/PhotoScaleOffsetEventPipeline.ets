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
import type { MediaItem } from './MediaItem';
import lazy { Constants } from '../../../model/common/Constants';
import lazy { Scales } from './pipeline/variable';
interface CanvasGestureCallback {
  onTouchEventRespond(scale: number, offsetX: number, offsetY: number): void;

  onAnimationEventRespond(animationOption: AnimationParam, scale: number, offsetX: number, offsetY: number): void;
}

export class AnimationParam {
  duration?: number;
  curve?: Curve;
}

const MAX_SCALE_MAGNIFICATION: number = 4;
const CALC_TRANS_NUM: number = 2;
const DEFAULT_SCALE: number = 1;
const SCALE_CENTER_NUMBER: number = 2;

/* instrument ignore file */
export class PhotoScaleOffsetEventPipeline {
  // 事件总线
  private gestureCallback: CanvasGestureCallback;
  // 组件宽高
  private componentWidth: number = 0;
  private componentHeight: number = 0;
  // 照片宽高
  private imgWidth: number = 0;
  private imgHeight: number = 0;
  private item: MediaItem;
  // 当前的缩放值
  private currScale: number = 1;
  // x\y轴位移
  private transX: number = 0;
  private transY: number = 0;
  // 最大缩放比例，为双边充满的1.5倍和两倍原图的最大值，且以对比时所有图片中最大的放大比例为准；
  private maxScale: number = 1;
  // 上一次的缩放比例
  private lastScale: number = 1;
  // 初始缩放比例
  private primaryLastScale: number = 1;
  private isInAnimation: boolean = false;
  // 上一次的x\y轴位移
  private prePosX: number = 0;
  private prePosY: number = 0;
  // 照片最小缩放比例
  private fitWholeScale: number = 1;
  // 照片刚好铺满容器的缩放比例
  private fitSideScale: number = 1;
  private animationOption: AnimationParam = {
    duration: 500,
    curve: Curve.Friction,
  };

  constructor(item: MediaItem, gestureCallback: CanvasGestureCallback) {
    this.item = item;
    this.imgWidth = px2vp(item.width);
    this.imgHeight = px2vp(item.height);
    this.gestureCallback = gestureCallback;
  }

  public onComponentSizeChanged(componentWidth: number, componentHeight: number): void {
    this.componentWidth = componentWidth;
    this.componentHeight = componentHeight;
    this.initPrams();
  }

  public initPrams(): void {
    let scaleX = this.componentWidth / this.imgWidth;
    let scaleY = this.componentHeight / this.imgHeight;
    this.fitWholeScale = Math.min(scaleX, scaleY);
    this.fitSideScale = Math.max(scaleX, scaleY);
    this.evaluateScales();
    this.currScale = this.fitSideScale;
    this.transX = (this.componentWidth - this.imgWidth * this.currScale) / CALC_TRANS_NUM;
    this.transY = (this.componentHeight - this.imgHeight * this.currScale) / CALC_TRANS_NUM;
    this.handlePinch(this.componentWidth / SCALE_CENTER_NUMBER,
      this.componentHeight / SCALE_CENTER_NUMBER, DEFAULT_SCALE);
    this.gestureCallback.onTouchEventRespond(this.currScale, this.transX, this.transY);
  }

  /**
   * 对比放大倍率计算
   */
  public evaluateScales(): void {
    const mScaleFillLong = this.calcScaleFillLong();
    const mThumbFactor = Math.min(this.imgWidth / this.componentWidth, this.imgHeight / this.componentHeight);
    // 对比捏合放大的最大比例为双边充满的1.5倍和两倍原图的最大值
    this.maxScale = Math.max(Scales.OVER_SCALE_EXTRA_FACTOR * mScaleFillLong,
      Scales.SAME_RATIO_SCALE_FACTOR * mThumbFactor);
    let maxCompareScale: number = AppStorage.get<number>(Constants.IMMERSIVE_COMPARED_MAX_SCALE) as number ?? 0;
    let currCompareScale = this.maxScale / this.primaryLastScale;
    if (currCompareScale < maxCompareScale) {
      this.maxScale = this.primaryLastScale * maxCompareScale;
    } else {
      AppStorage.setOrCreate<number>(Constants.IMMERSIVE_COMPARED_MAX_SCALE, currCompareScale);
    }
  }

  public calcScaleFillLong(): number {
    let filler = this.componentWidth * this.imgHeight / this.imgWidth / this.componentHeight;
    if (filler < 1) {
      filler = 1 / filler;
    }
    return filler;
  }

  public onMoveStart(): void {
    this.prePosX = this.transX;
    this.prePosY = this.transY;
  }

  public onMove(event: GestureEvent): void {
    this.transX = this.prePosX + event.offsetX;
    this.transY = this.prePosY + event.offsetY;
    this.gestureCallback.onTouchEventRespond(this.currScale, this.transX, this.transY);
  }

  public onMoveEnd(): void {
    this.tryReturn();
  }

  public onScaleStart(): void {
    this.lastScale = this.currScale;
    if (this.primaryLastScale === 1) {
      this.primaryLastScale = this.currScale;
    }
  }

  public onScale(pinchCenterX: number, pinchCenterY: number, scale: number): void {
    let newScale = this.lastScale * scale;
    let factor = 1;
    let maxCompareScale: number = AppStorage.get<number>(Constants.IMMERSIVE_COMPARED_MAX_SCALE) as number ?? 0;
    let currCompareScale = this.maxScale / this.primaryLastScale;
    if (currCompareScale < maxCompareScale) {
      this.maxScale = this.primaryLastScale * maxCompareScale;
    }
    if (newScale > this.maxScale) {
      factor = this.maxScale / this.currScale;
    } else {
      factor = newScale / this.currScale;
    }
    this.handlePinch(pinchCenterX, pinchCenterY, factor);
  }

  public onScaleEnd(): void {
    this.tryReturn(true);
  }

  private tryReturn(fitScale?: boolean): void {
    let scaleOver = fitScale && this.currScale < this.fitWholeScale;
    let scale = scaleOver ? this.fitWholeScale : this.currScale;
    let transXAxis = this.componentWidth - this.imgWidth * scale;
    if (transXAxis > 0) {
      transXAxis /= CALC_TRANS_NUM;
    } else {
      transXAxis = 0;
    }
    let transYAxis = this.componentHeight - this.imgHeight * scale;
    if (transYAxis > 0) {
      transYAxis /= CALC_TRANS_NUM;
    } else {
      transYAxis = 0;
    }
    let xOver = this.transX > 0 && this.transX > transXAxis;
    let yOver = this.transY > 0 && this.transY > transYAxis;
    if (!xOver) {
      transXAxis = this.componentWidth - this.imgWidth * scale;
      if (transXAxis > 0) {
        transXAxis /= CALC_TRANS_NUM;
      }
      xOver = this.transX < transXAxis;
    }
    if (!yOver) {
      transYAxis = this.componentHeight - this.imgHeight * scale;
      if (transYAxis > 0) {
        transYAxis /= CALC_TRANS_NUM;
      }
      yOver = this.transY < transYAxis;
    }
    if (xOver) {
      this.transX = transXAxis;
    }
    if (yOver) {
      this.transY = transYAxis;
    }
    if (scaleOver) {
      this.currScale = this.fitWholeScale;
    }
    if (xOver || yOver || scaleOver) {
      this.gestureCallback.onAnimationEventRespond(this.animationOption, this.currScale, this.transX, this.transY);
    } else {
      this.gestureCallback.onTouchEventRespond(this.currScale, this.transX, this.transY);
    }
  }

  private handlePinch(mockCenterX: number, mockCenterY: number, mockFactor: number): void {
    let factor = mockFactor;
    let cx = mockCenterX;
    let cy = mockCenterY;
    this.currScale *= factor;
    let dx = cx - cx * factor;
    let dy = cy - cy * factor;
    this.transX = this.transX * factor + dx;
    this.transY = this.transY * factor + dy;
    this.gestureCallback?.onTouchEventRespond(this.currScale, this.transX, this.transY);
  }
}