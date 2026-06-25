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
import Matrix4 from '@ohos.matrix4';
import { Matrix4x4 } from '@ohos/common/src/main/ets/default/utils/Matrix4x4';
import { HiLog } from '../../../common/util/HiLog';
import { RectValue } from '../../EditorSDK';
import { MathUtil } from '@ohos/common/src/main/ets/default/utils/MathUtil';
import { Rectangle } from '../../../common/util/types';

const TAG = 'MosaicGestureController';

export class GestureController {
  public isScaling: boolean = false;
  public imgScale: number = 1;
  private curScale: number = 1;
  private lastScale: number = 1;
  private scaleCenter: [number, number] = [0.5, 0.5];
  private moveOffset: [number, number] = [0, 0];
  private lastOffset: [number, number] = [0, 0]; // 用于偏移量，涉及到scale的比例放缩
  private scaleOffset: [number, number] = [0, 0]; // [vp, vp]
  private isScaleAnimating: boolean = false;
  private scaleMax: number = 1;
  private matrix: Matrix4.Matrix4Transit = Matrix4.identity().copy();
  private operationRect = new RectValue(0, 0, 0, 0);
  private rotateScale: number = 1;
  private previewWidth: number = 0;
  private previewHeight: number = 0;
  private isInited: boolean = false;
  private handleMatrixChange: (matrix: Matrix4.Matrix4Transit) => void = (matrix: Matrix4.Matrix4Transit) => {
  };
  private handleDisplayRectChange: (rect: RectValue) => void = (rect: RectValue) => {
  };

  constructor() {
  }

  public init() {
    this.isInited = true;
  }

  public close() {
    this.isInited = false;
  }

  public setOnViewChange(cb: (matrix: Matrix4.Matrix4Transit) => void) {
    this.handleMatrixChange = cb;
  }

  public setOnDisplayRectChange(cb: (rect: RectValue) => void) {
    this.handleDisplayRectChange = cb;
  }

  public updateOperationRect = (rect: RectValue) => {
    this.operationRect = rect;
  };
  public updatePreviewSize = (rect: RectValue) => {
    this.previewWidth = rect.width;
    this.previewHeight = rect.height;
  };
  public updateMaxScale = (scale: number) => {
    this.scaleMax = scale;
  };
  public pinchStartHandle = (event: GestureEvent) => {
    if (!this.isInited) {
      return;
    }
    this.isScaling = true;
    this.scaleCenter = this.evaluateCenter(event.pinchCenterX, event.pinchCenterY);
  };
  public pinchUpdateHandle = (event: GestureEvent) => {
    if (!this.isInited) {
      return;
    }
    this.curScale = event.scale;
    HiLog.i(TAG, 'event scale: ' + event.scale);
    if (this.lastScale * this.curScale < 1) {
      this.moveOffset = [0, 0];
      this.lastOffset = [0, 0];
      this.scaleOffset = [0, 0];
    }
    let defaultCoordinate: [number, number] = this.calcCoordinate(this.lastScale);
    let coordinate: [number, number] = this.calcCoordinate(this.lastScale * this.curScale);
    HiLog.i(TAG, `handleScaleUpdate, defaultCoordinate = ${JSON.stringify(defaultCoordinate)}, coordinate = ${
    JSON.stringify(coordinate)}`);
    this.scaleOffset = [defaultCoordinate[0] - coordinate[0], defaultCoordinate[1] - coordinate[1]];
    this.updateMatrix();
  };
  public pinchEndHandle = (event: GestureEvent) => {
    if (!this.isInited) {
      return;
    }
    let scale: number = this.curScale * this.lastScale;
    HiLog.i(TAG, `handleScaleEnd, lastScale = ${this.lastScale}, curScale = ${this.curScale}, scale = ${
    scale}`);
    //instrument ignore if
    if (scale < 1) {
      this.resetImageForTooSmall();
    } else if (scale > this.scaleMax) {
      this.resetImageForTooLarge();
    } else {
      this.lastScale = scale;
      this.curScale = 1;
      this.isScaling = false;
      this.endScaleAndMove();
    }
  };
  public panStartHandle = (event: GestureEvent) => {
    if (!this.isInited) {
      return;
    }
    this.isScaling = true;
  };
  public panUpdateHandle = (event: GestureEvent) => {
    if (!this.isInited) {
      return;
    }
    this.moveOffset[0] = event.offsetX;
    this.moveOffset[1] = event.offsetY;
    this.updateMatrix();
  };
  public panEndHandle = (event: GestureEvent) => {
    if (!this.isInited) {
      return;
    }
    this.endScaleAndMove();
  };
  public calcCoordinate = (scale: number): [number, number] => {
    return [(this.operationRect.width - this.previewWidth * scale) / 2 + this.previewWidth *
      scale * this.scaleCenter[0],
      (this.operationRect.height - this.previewHeight * scale) / 2 + this.previewHeight *
        scale * this.scaleCenter[1]];
  };

  private getScaledImageDisplaySize(): Size {
    let scale: number = this.curScale * this.lastScale;
    return {
      width: this.previewWidth * scale,
      height: this.previewHeight * scale,
    };
  }

  private evaluateCenter(centerX: number, centerY: number): [number, number] {
    let imageCurDisplaySize: Size = this.getScaledImageDisplaySize();
    let lastOffset: [number, number] = [this.lastOffset[0], this.lastOffset[1]];
    const imgX = (this.operationRect.width - imageCurDisplaySize.width) / 2 + lastOffset[0];
    const imgY = (this.operationRect.height - imageCurDisplaySize.height) / 2 + lastOffset[1];
    let cX = Math.max((centerX - imgX) / imageCurDisplaySize.width, 0);
    let cY = Math.max((centerY - imgY) / imageCurDisplaySize.height, 0);
    return [cX, cY];
  }

  /* instrument ignore next */
  public cropToRect = (cropRect: Rectangle) => {
    return new RectValue(
      vp2px(cropRect.left),
      vp2px(cropRect.top),
      vp2px(cropRect.width()),
      vp2px(cropRect.height())
    );
  };
  /* instrument ignore next */
  public calcMatrix = (rect: RectValue): Matrix4.Matrix4Transit => {
    let scale: number = px2vp(rect.width) / this.previewWidth;
    let componentDisplaySize: Size = {
      width: this.operationRect.width * scale,
      height: this.operationRect.height * scale,
    } as Size;
    let imageCurDisplaySize: Size = this.getScaledImageDisplaySize();
    let left: number = componentDisplaySize.width / 2 - imageCurDisplaySize.width / 2 +
      (1 - scale) * this.operationRect.width / 2 + this.operationRect.x;
    let top: number = componentDisplaySize.height / 2 - imageCurDisplaySize.height / 2 +
      (1 - scale) * this.operationRect.height / 2 + this.operationRect.y;
    let oldX: number = (left + imageCurDisplaySize.width / 2);
    let oldY: number = (top + imageCurDisplaySize.height / 2);
    let newX: number = px2vp(rect.x + rect.width / 2);
    let newY: number = px2vp(rect.y + rect.height / 2);
    HiLog.i(TAG, `calcMatrix [${oldX}, ${oldY}] => [${newX}, ${newY}]`);
    let offsetX: number = newX - oldX;
    let offsetY: number = newY - oldY;
    HiLog.i(TAG, `calcMatrix rect ${JSON.stringify(rect)}, scale: ${scale}, [${offsetX}, ${offsetY}]`);
    this.matrix = Matrix4.identity()
      .scale({ x: scale, y: scale })
      .translate({ x: vp2px(offsetX), y: vp2px(offsetY) });
    return this.matrix;
  };

  public resetParam(): void {
    this.lastScale = 1;
    this.curScale = 1;
    this.imgScale = 1;
    this.lastOffset = [0, 0];
    this.moveOffset = [0, 0];
    this.scaleOffset = [0, 0];
    this.scaleCenter = [0.5, 0.5];
    this.matrix = Matrix4.identity().copy();
    this.handleMatrixChange(this.matrix);
    HiLog.i(TAG, `resetParam end, this.lastScale = ${this.lastScale}`);
  }

  /* instrument ignore next */
  private resetImageForTooLarge(): void {
    HiLog.i(TAG, `resetImageForTooLarge, lastScale = ${this.lastScale}, curScale = ${this.curScale}`);
    this.isScaleAnimating = true;
    animateTo({
      duration: 500,
      curve: Curve.Ease,
      onFinish: () => {
        this.lastScale = this.scaleMax;
        this.curScale = 1;
        this.isScaling = false;
        this.isScaleAnimating = false;
      }
    }, () => {
      let defaultCoordinate: [number, number] = this.calcCoordinate(this.lastScale);
      let coordinate: [number, number] = this.calcCoordinate(this.scaleMax);
      HiLog.i(TAG, `resetImageForTooLarge, defaultCoordinate = ${JSON.stringify(defaultCoordinate)}, coordinate = ${
      JSON.stringify(coordinate)}`);
      this.scaleOffset = [defaultCoordinate[0] - coordinate[0], defaultCoordinate[1] - coordinate[1]];
      this.lastScale = this.scaleMax;
      this.curScale = 1;
      this.updateMatrix();
      this.endScaleAndMove();
    });
  }

  public updateImageDisplayRect(): void {
    let mat: number[] | undefined = (this.matrix as Matrix4.Matrix4Transit as Matrix4x4).matrix4x4;
    if (mat) {
      let scale: number = mat[0]; // scale
      let offsetX: number = px2vp(mat[12]); // x轴平移值
      let offsetY: number = px2vp(mat[13]); // y轴平移值
      let imageCurDisplaySize: Size = this.getScaledImageDisplaySize();
      let componentDisplaySize: Size = {
        width: this.operationRect.width * scale,
        height: this.operationRect.height * scale,
      } as Size;
      let left = offsetX + componentDisplaySize.width / 2 - imageCurDisplaySize.width / 2 +
        (1 - scale) * this.operationRect.width / 2 + this.operationRect.x;
      let top = offsetY + componentDisplaySize.height / 2 - imageCurDisplaySize.height / 2 +
        (1 - scale) * this.operationRect.height / 2 + this.operationRect.y;
      HiLog.i(TAG, `updateImageDisplayRect left is ${left}, top is ${top}, width is ${
      imageCurDisplaySize.width}, scale is ${scale}, height is ${imageCurDisplaySize.height}, lastScale = ${
      this.lastScale}, curScale = ${this.curScale}`);
      this.handleDisplayRectChange(new RectValue(left, top, imageCurDisplaySize.width, imageCurDisplaySize.height));
    }
    return;
  }

  private endScaleAndMove(): void {
    let scale: number = this.curScale * this.lastScale;
    this.lastOffset = this.evaluateOffset(scale);
    HiLog.i(TAG, `endScaleAndMove, lastOffset = [${this.lastOffset[0]}, ${this.lastOffset[1]}]`);
    this.scaleOffset = [0, 0];
    this.moveOffset = [0, 0];
    this.updateImageDisplayRect();
  }

  private resetImageForTooSmall(): void {
    HiLog.i(TAG, `resetImageForTooSmall, lastScale = ${this.lastScale}, curScale = ${this.curScale}`);
    this.isScaleAnimating = true;
    animateTo({
      duration: 500,
      curve: Curve.Ease,
      onFinish: () => {
        this.resetParam();
        this.isScaling = false;
        // 缩小回弹动效完成后，判断当前缩放比，防止误放开扩图的对比按钮
        this.isScaleAnimating = false;
      }
    }, () => {
      this.resetParam();
      this.endScaleAndMove();
    });
  }

  public updateMatrix(): void {
    let scale: number = this.curScale * this.lastScale;
    let offset: [number, number] = this.evaluateOffset(scale);
    this.imgScale = scale;
    this.matrix = Matrix4.identity()
      .scale({ x: scale, y: scale })
      .translate({ x: vp2px(offset[0]), y: vp2px(offset[1]) });
    HiLog.i(TAG, `updateMatrix ${JSON.stringify(this.matrix)}`);
    this.handleMatrixChange(this.matrix);
  }

  private evaluateOffset(scale: number): [number, number] {
    //instrument ignore if
    if (scale < 1) {
      return [0, 0];
    }
    HiLog.i(TAG, `evaluateOffset, lastOffset = [${this.lastOffset[0]}, ${this.lastOffset[1]}]`);
    HiLog.i(TAG, `evaluateOffset, moveOffset = [${this.moveOffset[0]}, ${this.moveOffset[1]}]`);
    HiLog.i(TAG, `evaluateOffset, scaleOffset = [${this.scaleOffset[0]}, ${this.scaleOffset[1]}]`);
    let offsetX: number = this.lastOffset[0] + this.moveOffset[0] + this.scaleOffset[0];
    let offsetY: number = this.lastOffset[1] + this.moveOffset[1] + this.scaleOffset[1];
    const limits = this.evaluateOffsetRange(scale);
    // 非缩小场景，始终限制x方向上的offset
    // 不可下拉返回场景，限制y
    offsetY = MathUtil.clamp(offsetY, limits[2], limits[3]);
    offsetX = MathUtil.clamp(offsetX, limits[0], limits[1]);
    return [offsetX, offsetY];
  }

  private evaluateOffsetRange(scale: number): [number, number, number, number] {
    let screenScale = this.getScreenScale();
    HiLog.i(TAG, `screenScale: ${screenScale}`);
    let left = (screenScale * scale * this.previewWidth - this.operationRect.width) / 2;
    let top = (screenScale * scale * this.previewHeight - this.operationRect.height) / 2;
    top = Math.max(top, 0);
    left = Math.max(left, 0);
    return [-left, left, -top, top];
  }

  public getScreenScale(): number {
    let widthScale = this.operationRect.width / this.previewWidth;
    let heightScale = this.operationRect.height / this.previewHeight;
    return Math.min(widthScale, heightScale);
  }
}

/**
 * 计算图片适应容器的参数
 * @param {Object} options 配置对象
 * @param {number} options.imgWidth 图片原始宽度
 * @param {number} options.imgHeight 图片原始高度
 * @param {number} options.containerWidth 容器宽度
 * @param {number} options.containerHeight 容器高度
 * @returns {Object} 计算结果 { width, height, x, y, scale }
 */
interface ObjectFitInput {
  imgWidth: number,
  imgHeight: number,
  containerWidth: number,
  containerHeight: number,
}

interface ObjectFitOutput {
  width: number,
  height: number,
  x: number,
  y: number,
  scale: number,
}

export function calculateObjectFit(options: ObjectFitInput): ObjectFitOutput {
  let imgWidth = options.imgWidth;
  let imgHeight = options.imgHeight;
  let containerWidth = options.containerWidth;
  let containerHeight = options.containerHeight;

  // 如果图片或容器尺寸为0，直接返回
  if (imgWidth === 0 || imgHeight === 0 || containerWidth === 0 || containerHeight === 0) {
    return {
      width: 0,
      height: 0,
      x: 0,
      y: 0,
      scale: 1,
    };
  }

  let width: number = 0;
  let height: number = 0;
  let x: number = 0;
  let y: number = 0;
  let scale: number = 1;

  const imgRatio = imgWidth / imgHeight;
  const containerRatio = containerWidth / containerHeight;

  if (imgRatio > containerRatio) {
    // 图片更宽，以宽度为准
    width = containerWidth;
    height = containerWidth / imgRatio;
  } else {
    // 图片更高，以高度为准
    height = containerHeight;
    width = containerHeight * imgRatio;
  }
  scale = width / imgWidth;

  // 计算位置（对齐方式）
  x = (containerWidth - width) / 2;
  y = (containerHeight - height) / 2;

  return {
    width,
    height,
    x,
    y,
    scale
  };
}