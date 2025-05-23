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

import { LineSegment } from '../base/Line';
import { Point } from '../base/Point';
import { RectF } from '../base/Rect';
import { Ratio } from '../base/Ratio';
import { Constants, Log, ScreenManager } from '@ohos/common';
import { CropAngle, CropRatioType } from './CropType';
import { MathUtils } from './MathUtils';

const TAG: string = 'editor_CropShow';

export class CropShow {
  private static readonly DEFAULT_MIN_SIDE_LENGTH: number = 90;
  private static readonly DEFAULT_TOUCH_BOUND: number = 20;
  private static readonly BASE_SCALE_VALUE: number = 1.0;
  private limitRect: RectF = undefined;
  private cropRect: RectF = undefined;
  private imageRect: RectF = undefined;
  private ratio: Ratio = undefined;
  private screenMaxSide: number = 0;
  private screenMinSide: number = 0;
  private minSideLength: number = CropShow.DEFAULT_MIN_SIDE_LENGTH;
  private touchBound: number = CropShow.DEFAULT_TOUCH_BOUND;
  private rotationAngle: number = 0;
  private horizontalAngle: number = 0;
  private maxScaleFactorW: number = CropShow.BASE_SCALE_VALUE;
  private maxScaleFactorH: number = CropShow.BASE_SCALE_VALUE;
  private isFlipHorizontal: boolean = false;
  private isFlipVertically: boolean = false;
  private isLeft: boolean = false;
  private isRight: boolean = false;
  private isTop: boolean = false;
  private isBottom: boolean = false;
  private isHorizontalSide: boolean = false;
  private isVerticalSide: boolean = false;

  constructor() {
    this.limitRect = new RectF();
    this.imageRect = new RectF();
    this.cropRect = new RectF();
    this.ratio = new Ratio(-1, -1);

    let screenWidth = Math.ceil(ScreenManager.getInstance().getWinWidth());
    let screenHeight = Math.ceil(ScreenManager.getInstance().getWinHeight());
    this.screenMaxSide = Math.max(screenWidth, screenHeight);
    this.screenMinSide = Math.min(screenWidth, screenHeight);
  }

  init(limit: RectF, imageRatio: number): void {
    this.limitRect.set(limit.left, limit.top, limit.right, limit.bottom);
    MathUtils.computeMaxRectWithinLimit(this.imageRect, limit, imageRatio);
    this.cropRect.set(this.imageRect.left, this.imageRect.top, this.imageRect.right, this.imageRect.bottom);
    this.ratio.set(-1, -1);
    this.rotationAngle = 0;
    this.horizontalAngle = 0;
    this.isFlipHorizontal = false;
    this.isFlipVertically = false;
  }

  syncLimitRect(limit: RectF): void {
    this.limitRect.set(limit.left, limit.top, limit.right, limit.bottom);
    this.recalculateCropArea();
  }

  getCropRect(): RectF {
    let crop = new RectF();
    crop.set(this.cropRect.left, this.cropRect.top, this.cropRect.right, this.cropRect.bottom);
    return crop;
  }

  getImageRect(): RectF {
    let image = new RectF();
    image.set(this.imageRect.left, this.imageRect.top, this.imageRect.right, this.imageRect.bottom);
    return image;
  }

  setImageRect(image: RectF): void {
    this.imageRect.set(image.left, image.top, image.right, image.bottom);
  }

  syncRotationAngle(angle: number): void {
    this.rotationAngle = angle;
    MathUtils.swapWidthHeight(this.cropRect);
    this.swapCurrentRatio();
    this.enlargeCropArea();
  }

  syncHorizontalAngle(angle: number): void {
    this.horizontalAngle = angle;

    let points = MathUtils.rectToPoints(this.cropRect);
    let origin = this.getDisplayCenter();
    let totalAngle = -(this.rotationAngle + this.horizontalAngle);
    let rotated = MathUtils.rotatePoints(points, totalAngle, origin);
    let scale = MathUtils.findSuitableScale(rotated, this.imageRect, origin);
    MathUtils.scaleRectBasedOnPoint(this.imageRect, origin, scale);
  }

  setFlip(isFlipHorizontal: boolean, isFlipVertically: boolean): void {
    this.isFlipHorizontal = isFlipHorizontal;
    this.isFlipVertically = isFlipVertically;
  }

  setRatio(ratio: CropRatioType): void {
    switch (ratio) {
      case CropRatioType.RATIO_TYPE_FREE:
        this.ratio.set(-1, -1);
        break;
      case CropRatioType.RATIO_TYPE_HORIZONTAL:
        this.ratio.set(this.screenMaxSide, this.screenMinSide);
        break;
      case CropRatioType.RATIO_TYPE_VERTICAL:
        this.ratio.set(this.screenMinSide, this.screenMaxSide);
        break;
      case CropRatioType.RATIO_TYPE_1_1:
        this.ratio.set(1, 1);
        break;
      case CropRatioType.RATIO_TYPE_16_9:
        this.ratio.set(16, 9);
        break;
      case CropRatioType.RATIO_TYPE_9_16:
        this.ratio.set(9, 16);
        break;
      case CropRatioType.RATIO_TYPE_4_3:
        this.ratio.set(4, 3);
        break;
      case CropRatioType.RATIO_TYPE_3_4:
        this.ratio.set(3, 4);
        break;
      case CropRatioType.RATIO_TYPE_3_2:
        this.ratio.set(3, 2);
        break;
      case CropRatioType.RATIO_TYPE_2_3:
        this.ratio.set(2, 3);
        break;
      default:
        Log.warn(TAG, 'setRatio: unknown ratio');
        break;
    }
    if (this.ratio.isValid()) {
      MathUtils.computeMaxRectWithinLimit(this.cropRect, this.limitRect, this.ratio.getRate());
      let imageLines = this.getCurrentImageLines();
      MathUtils.limitRectInRotated(this.cropRect, imageLines);
      this.imageCropCompare();
      this.enlargeCropArea();
    }
  }

  setMaxScaleFactor(factorW: number, factorH: number): void {
    this.maxScaleFactorW = factorW;
    this.maxScaleFactorH = factorH;
  }

  couldEnlargeImage(): boolean {
    return (this.couldEnlargeImageW() && this.couldEnlargeImageH());
  }

  enlargeCropArea(): void {
    let newCrop: RectF = new RectF();
    let cropRatio: number = this.cropRect.getWidth() / this.cropRect.getHeight();
    // Recalculate crop Rect.
    MathUtils.computeMaxRectWithinLimit(newCrop, this.limitRect, cropRatio);
    let scale: number = newCrop.getWidth() / this.cropRect.getWidth();

    // Scale Image based on the midpoint of the last crop.
    let tX: number = this.isFlipHorizontal ? -1 : 1;
    let tY: number = this.isFlipVertically ? -1 : 1;
    let origin: Point = this.getDisplayCenter();
    let preCenterX: number = this.cropRect.getCenterX() * tX + (
      this.isFlipHorizontal ? Constants.NUMBER_2 * origin.x : 0
    );
    let preCenterY: number = this.cropRect.getCenterY() * tY + (
      this.isFlipVertically ? Constants.NUMBER_2 * origin.y : 0
    );
    let preCenter: Point = new Point(preCenterX, preCenterY);
    let angle: number = this.rotationAngle * tX * tY + this.horizontalAngle;
    let rotated: Array<Point> = MathUtils.rotatePoints([preCenter], -angle, origin);

    MathUtils.scaleRectBasedOnPoint(this.imageRect, rotated[0], scale);

    // Rotate based on the new midpoint.
    let offsetX: number = newCrop.getCenterX() - preCenter.x;
    let offsetY: number = newCrop.getCenterY() - preCenter.y;
    let alpha: number = MathUtils.formulaAngle(angle);
    let x: number = Math.cos(alpha) * offsetX + Math.sin(alpha) * offsetY;
    let y: number = -Math.sin(alpha) * offsetX + Math.cos(alpha) * offsetY;
    this.imageRect.move(x, y);

    this.cropRect.set(newCrop.left, newCrop.top, newCrop.right, newCrop.bottom);
  }

  recalculateCropArea(): void {
    let newCrop: RectF = new RectF();
    let cropRatio: number = this.cropRect.getWidth() / this.cropRect.getHeight();
    // Recalculate cropRect scale.
    MathUtils.computeMaxRectWithinLimit(newCrop, this.limitRect, cropRatio);
    let scale: number = newCrop.getWidth() / this.cropRect.getWidth();
    let originalCropCenter: Point = new Point(this.cropRect.getCenterX(), this.cropRect.getCenterY());
    // Scales the imageRect using the scale of cropRect.
    MathUtils.scaleRectBasedOnPoint(this.imageRect, originalCropCenter, scale);

    // offset the imageRect using the offset of cropRect.
    let imageOffsetX: number = newCrop.getCenterX() - this.cropRect.getCenterX();
    let imageOffsetY: number = newCrop.getCenterY() - this.cropRect.getCenterY();
    this.imageRect.move(imageOffsetX, imageOffsetY);

    this.cropRect.set(newCrop.left, newCrop.top, newCrop.right, newCrop.bottom);
  }

  imageCropCompare(): void {
    let imageRect = this.getImageRect();
    let cropRect = this.getCropRect();
    let imageRectWidth = imageRect.getWidth();
    let imageRectHeight = imageRect.getHeight();
    let cropRectWidth = cropRect.getWidth();
    let cropRectHeight = cropRect.getHeight();
    if (imageRectWidth < cropRectWidth) {
      let scaleRatio = cropRectWidth / imageRectWidth;
      this.imageRect.scale(scaleRatio);
    }
    if (imageRectHeight < cropRectHeight) {
      let scaleRatio = cropRectHeight / imageRectHeight;
      this.imageRect.scale(scaleRatio);
    }

  }

  isCropRectTouch(x: number, y: number): boolean {
    let w = this.touchBound;
    let h = this.touchBound;
    let crop = { ...this.cropRect };
    let outer = new RectF();
    outer.set(crop.left - w, crop.top - h, crop.right + w, crop.bottom + h);
    let inner = new RectF();
    inner.set(crop.left + w, crop.top + h, crop.right - w, crop.bottom - h);
    if (outer.isInRect(x, y) && !inner.isInRect(x, y)) {
      if (x <= inner.left) {
        this.isLeft = true;
      } else if (x >= inner.right) {
        this.isRight = true;
      }

      if (y <= inner.top) {
        this.isTop = true;
      } else if (y >= inner.bottom) {
        this.isBottom = true;
      }

      // convert side to conner, when fixed crop ratio
      if (this.ratio.isValid()) {
        this.fixSideToConner(x, y);
      }
      Log.debug(TAG, `isCropTouch: l[${this.isLeft}] r[${this.isRight}] t[${this.isTop}] b[${this.isBottom}]`);
    }
    return this.isLeft || this.isRight || this.isTop || this.isBottom;
  }

  getCurrentFlipImage(): RectF {
    let center = this.getDisplayCenter();
    let image = { ...this.imageRect };
    let flipImage = new RectF();
    flipImage.left = this.isFlipHorizontal ? (2 * center.x - image.right) : image.left;
    flipImage.top = this.isFlipVertically ? (2 * center.y - image.bottom) : image.top;
    flipImage.right = this.isFlipHorizontal ? (2 * center.x - image.left) : image.right;
    flipImage.bottom = this.isFlipVertically ? (2 * center.y - image.top) : image.bottom;
    return flipImage;
  }

  moveCropRect(offsetX: number, offsetY: number): void {
    // crop rect in fixed mode
    if (this.ratio.isValid()) {
      this.moveInFixedMode(offsetX, offsetY);
    } else {
      this.moveInFreeMode(offsetX, offsetY);
    }
  }

  endCropRectMove(): void {
    this.isLeft = false;
    this.isRight = false;
    this.isTop = false;
    this.isBottom = false;
    this.isHorizontalSide = false;
    this.isVerticalSide = false;
  }

  private swapCurrentRatio(): void {
    let W = this.ratio.getW();
    let H = this.ratio.getH();
    this.ratio.set(H, W);
  }

  private getDisplayCenter(): Point {
    return new Point(this.limitRect.getCenterX(), this.limitRect.getCenterY());
  }

  private couldEnlargeImageW(): boolean {
    let scaleFactorW = this.imageRect.getWidth() / this.cropRect.getWidth();
    return (scaleFactorW >= this.maxScaleFactorW ? false : true);
  }

  private couldEnlargeImageH(): boolean {
    let scaleFactorH = this.imageRect.getHeight() / this.cropRect.getHeight();
    return (scaleFactorH >= this.maxScaleFactorH ? false : true);
  }

  private fixSideToConner(x: number, y: number): void {
    if ((this.isLeft || this.isRight) && !this.isTop && !this.isBottom) {
      if (y < this.cropRect.getCenterY()) {
        this.isTop = true;
      } else {
        this.isBottom = true;
      }
      this.isVerticalSide = true;
    } else if ((this.isTop || this.isBottom) && !this.isLeft && !this.isRight) {
      if (x < this.cropRect.getCenterX()) {
        this.isLeft = true;
      } else {
        this.isRight = true;
      }
      this.isHorizontalSide = true;
    }
  }

  private getCurrentRotatedImage(): RectF {
    let flipImage = this.getCurrentFlipImage();
    let points = MathUtils.rectToPoints(flipImage);
    let origin = this.getDisplayCenter();
    let rotated = MathUtils.rotatePoints(points, this.rotationAngle, origin);
    let i = Math.abs(this.rotationAngle / CropAngle.ONE_QUARTER_CIRCLE_ANGLE);
    let j = (i + 2) % rotated.length;
    let image = new RectF();
    image.set(rotated[i].x, rotated[i].y, rotated[j].x, rotated[j].y);
    return image;
  }

  private getCurrentImageLines(): Array<LineSegment> {
    let flipImage = this.getCurrentFlipImage();
    let imagePoints = MathUtils.rectToPoints(flipImage);
    let origin = this.getDisplayCenter();
    let tX = this.isFlipHorizontal ? -1 : 1;
    let tY = this.isFlipVertically ? -1 : 1;
    let angle = this.rotationAngle * tX * tY + this.horizontalAngle;
    let rotated = MathUtils.rotatePoints(imagePoints, angle, origin);

    let imageLines = [];
    for (let i = 0; i < rotated.length; i++) {
      let j = (i + 1) % rotated.length;
      imageLines.push(
        new LineSegment(new Point(rotated[i].x, rotated[i].y), new Point(rotated[j].x, rotated[j].y)));
    }
    return imageLines;
  }

  private moveInFixedMode(offsetX: number, offsetY: number): void {
    let x = offsetX;
    let y = offsetY;
    if (this.isHorizontalSide) {
      x = 0;
    } else if (this.isVerticalSide) {
      y = 0;
    }
    let offsetHypot = Math.hypot(x, y);

    if (this.isLeft && this.isTop) {
      // left top conner move
      let isEnlarge = offsetX < 0 || offsetY < 0;
      if (isEnlarge || this.couldEnlargeImage()) {
        this.fixLeftTopInFixedMode(offsetHypot, isEnlarge);
      }
    } else if (this.isLeft && this.isBottom) {
      // left bottom conner move
      let isEnlarge = offsetX < 0 || offsetY > 0;
      if (isEnlarge || this.couldEnlargeImage()) {
        this.fixLeftBottomInFixedMode(offsetHypot, isEnlarge);
      }
    } else if (this.isRight && this.isTop) {
      // right top conner move
      let isEnlarge = offsetX > 0 || offsetY < 0;
      if (isEnlarge || this.couldEnlargeImage()) {
        this.fixRightTopInFixedMode(offsetHypot, isEnlarge);
      }
    } else if (this.isRight && this.isBottom) {
      // right bottom conner move
      let isEnlarge = offsetX > 0 || offsetY > 0;
      if (isEnlarge || this.couldEnlargeImage()) {
        this.fixRightBottomInFixedMode(offsetHypot, isEnlarge);
      }
    }
  }

  private fixLeftTopInFixedMode(offsetHypot: number, isEnlarge: boolean): void {
    let crop = this.getCropRect();
    let rate = this.ratio.getRate();
    let rect = new RectF();
    if (isEnlarge) {
      let limit = { ...this.limitRect };
      let size = MathUtils.getMaxFixedRectSize(rate, crop.right - limit.left, crop.bottom - limit.top);
      rect.set(crop.right - size[0], crop.bottom - size[1], crop.right, crop.bottom);
      let imageLines = this.getCurrentImageLines();
      MathUtils.limitRectInRotatedBasedOnPoint(2, rect, imageLines);
    } else {
      let size = MathUtils.getMinFixedRectSize(rate, this.minSideLength);
      rect.set(crop.right - size[0], crop.bottom - size[1], crop.right, crop.bottom);
    }
    let rectHypot = Math.hypot(rect.getWidth(), rect.getHeight());
    let cropHypot = Math.hypot(crop.getWidth(), crop.getHeight());
    let limitHypot = (rectHypot - cropHypot) * (isEnlarge ? 1 : -1);
    let finalOffsetHypot = Math.min(offsetHypot, Math.max(limitHypot, 0));
    let tX = isEnlarge ? -1 : 1;
    let tY = isEnlarge ? -1 : 1;
    let ratioHypot = Math.hypot(this.ratio.getW(), this.ratio.getH());
    this.cropRect.left += finalOffsetHypot * tX * this.ratio.getW() / ratioHypot;
    this.cropRect.top += finalOffsetHypot * tY * this.ratio.getH() / ratioHypot;
  }

  private fixLeftBottomInFixedMode(offsetHypot: number, isEnlarge: boolean): void {
    let crop = this.getCropRect();
    let rate = this.ratio.getRate();
    let rect = new RectF();
    if (isEnlarge) {
      let limit = { ...this.limitRect };
      let size = MathUtils.getMaxFixedRectSize(rate, crop.right - limit.left, limit.bottom - crop.top);
      rect.set(crop.right - size[0], crop.top, crop.right, crop.top + size[1]);
      let imageLines = this.getCurrentImageLines();
      MathUtils.limitRectInRotatedBasedOnPoint(1, rect, imageLines);
    } else {
      let size = MathUtils.getMinFixedRectSize(rate, this.minSideLength);
      rect.set(crop.right - size[0], crop.top, crop.right, crop.top + size[1]);
    }
    let rectHypot = Math.hypot(rect.getWidth(), rect.getHeight());
    let cropHypot = Math.hypot(crop.getWidth(), crop.getHeight());
    let limitHypot = (rectHypot - cropHypot) * (isEnlarge ? 1 : -1);
    let finalOffsetHypot = Math.min(offsetHypot, Math.max(limitHypot, 0));
    let tX = isEnlarge ? -1 : 1;
    let tY = isEnlarge ? 1 : -1;
    let ratioHypot = Math.hypot(this.ratio.getW(), this.ratio.getH());
    this.cropRect.left += finalOffsetHypot * tX * this.ratio.getW() / ratioHypot;
    this.cropRect.bottom += finalOffsetHypot * tY * this.ratio.getH() / ratioHypot;
  }

  private fixRightTopInFixedMode(offsetHypot: number, isEnlarge: boolean): void {
    let crop = this.getCropRect();
    let rate = this.ratio.getRate();
    let rect = new RectF();
    if (isEnlarge) {
      let limit = { ...this.limitRect };
      let size = MathUtils.getMaxFixedRectSize(rate, limit.right - crop.left, crop.bottom - limit.top);
      rect.set(crop.left, crop.bottom - size[1], crop.left + size[0], crop.bottom);
      let imageLines = this.getCurrentImageLines();
      MathUtils.limitRectInRotatedBasedOnPoint(3, rect, imageLines);
    } else {
      let size = MathUtils.getMinFixedRectSize(rate, this.minSideLength);
      rect.set(crop.left, crop.bottom - size[1], crop.left + size[0], crop.bottom);
    }
    let rectHypot = Math.hypot(rect.getWidth(), rect.getHeight());
    let cropHypot = Math.hypot(crop.getWidth(), crop.getHeight());
    let limitHypot = (rectHypot - cropHypot) * (isEnlarge ? 1 : -1);
    let finalOffsetHypot = Math.min(offsetHypot, Math.max(limitHypot, 0));
    let tX = isEnlarge ? 1 : -1;
    let tY = isEnlarge ? -1 : 1;
    let ratioHypot = Math.hypot(this.ratio.getW(), this.ratio.getH());
    this.cropRect.right += finalOffsetHypot * tX * this.ratio.getW() / ratioHypot;
    this.cropRect.top += finalOffsetHypot * tY * this.ratio.getH() / ratioHypot;
  }

  private fixRightBottomInFixedMode(offsetHypot: number, isEnlarge: boolean): void {
    let crop = this.getCropRect();
    let rate = this.ratio.getRate();
    let rect = new RectF();
    if (isEnlarge) {
      let limit = { ...this.limitRect };
      let size = MathUtils.getMaxFixedRectSize(rate, limit.right - crop.left, limit.bottom - crop.top);
      rect.set(crop.left, crop.top, crop.left + size[0], crop.top + size[1]);
      let imageLines = this.getCurrentImageLines();
      MathUtils.limitRectInRotatedBasedOnPoint(0, rect, imageLines);
    } else {
      let size = MathUtils.getMinFixedRectSize(rate, this.minSideLength);
      rect.set(crop.left, crop.top, crop.left + size[0], crop.top + size[1]);
    }
    let rectHypot = Math.hypot(rect.getWidth(), rect.getHeight());
    let cropHypot = Math.hypot(crop.getWidth(), crop.getHeight());
    let limitHypot = (rectHypot - cropHypot) * (isEnlarge ? 1 : -1);
    let finalOffsetHypot = Math.min(offsetHypot, Math.max(limitHypot, 0));
    let tX = isEnlarge ? 1 : -1;
    let tY = isEnlarge ? 1 : -1;
    let ratioHypot = Math.hypot(this.ratio.getW(), this.ratio.getH());
    this.cropRect.right += finalOffsetHypot * tX * this.ratio.getW() / ratioHypot;
    this.cropRect.bottom += finalOffsetHypot * tY * this.ratio.getH() / ratioHypot;
  }

  private moveInFreeMode(offsetX: number, offsetY: number): void {
    let crop = this.getCropRect();
    let limit = { ...this.limitRect };
    let image = this.getCurrentRotatedImage();
    let minLength = this.minSideLength;
    let imageLines = this.getCurrentImageLines();
    if (this.isLeft) {
      if (offsetX < 0 || this.couldEnlargeImageW()) {
        let left = Math.min(crop.left + offsetX, crop.right - minLength);
        left = Math.max(left, image.left, limit.left);
        this.cropRect.left = this.fixLeftInFreeMode(left, crop, imageLines);
        crop.left = this.cropRect.left;
      }
    } else if (this.isRight) {
      if (offsetX > 0 || this.couldEnlargeImageW()) {
        let right = Math.max(crop.right + offsetX, crop.left + minLength);
        right = Math.min(right, image.right, limit.right);
        this.cropRect.right = this.fixRightInFreeMode(right, crop, imageLines);
        crop.right = this.cropRect.right;
      }
    }
    if (this.isTop) {
      if (offsetY < 0 || this.couldEnlargeImageH()) {
        let top = Math.min(crop.top + offsetY, crop.bottom - minLength);
        top = Math.max(top, image.top, limit.top);
        this.cropRect.top = this.fixTopInFreeMode(top, crop, imageLines);
      }
    } else if (this.isBottom) {
      if (offsetY > 0 || this.couldEnlargeImageH()) {
        let bottom = Math.max(crop.bottom + offsetY, crop.top + minLength);
        bottom = Math.min(bottom, image.bottom, limit.bottom);
        this.cropRect.bottom = this.fixBottomInFreeMode(bottom, crop, imageLines);
      }
    }
  }

  private fixLeftInFreeMode(left: number, crop: RectF, imageLines: Array<LineSegment>): number {
    let leftLine = new LineSegment(new Point(left, crop.top), new Point(left, crop.bottom));
    let adjacentLines = [];
    adjacentLines.push(new LineSegment(new Point(left, crop.top), new Point(crop.right, crop.top)));
    adjacentLines.push(new LineSegment(new Point(left, crop.bottom), new Point(crop.right, crop.bottom)));
    let fixedLeft = left;
    for (let imageLine of imageLines) {
      if (MathUtils.hasIntersection(imageLine, leftLine)) {
        let result = this.tryToFindFixedSide(adjacentLines, imageLine, left, true, true);
        fixedLeft = Math.max(fixedLeft, result);
      }
    }
    return fixedLeft;
  }

  private fixRightInFreeMode(right: number, crop: RectF, imageLines: Array<LineSegment>): number {
    let rightLine = new LineSegment(new Point(right, crop.top), new Point(right, crop.bottom));
    let adjacentLines = [];
    adjacentLines.push(new LineSegment(new Point(crop.left, crop.top), new Point(right, crop.top)));
    adjacentLines.push(new LineSegment(new Point(crop.left, crop.bottom), new Point(right, crop.bottom)));
    let fixedRight = right;
    for (let imageLine of imageLines) {
      if (MathUtils.hasIntersection(imageLine, rightLine)) {
        let result = this.tryToFindFixedSide(adjacentLines, imageLine, right, true, false);
        fixedRight = Math.min(fixedRight, result);
      }
    }
    return fixedRight;
  }

  private fixTopInFreeMode(top: number, crop: RectF, imageLines: Array<LineSegment>): number {
    let topLine = new LineSegment(new Point(crop.left, top), new Point(crop.right, top));
    let adjacentLines = [];
    adjacentLines.push(new LineSegment(new Point(crop.left, top), new Point(crop.left, crop.bottom)));
    adjacentLines.push(new LineSegment(new Point(crop.right, top), new Point(crop.right, crop.bottom)));
    let fixedTop = top;
    for (let imageLine of imageLines) {
      if (MathUtils.hasIntersection(imageLine, topLine)) {
        let result = this.tryToFindFixedSide(adjacentLines, imageLine, top, false, true);
        fixedTop = Math.max(fixedTop, result);
      }
    }
    return fixedTop;
  }

  private fixBottomInFreeMode(bottom: number, crop: RectF, imageLines: Array<LineSegment>): number {
    let bottomLine = new LineSegment(new Point(crop.left, bottom), new Point(crop.right, bottom));
    let adjacentLines = [];
    adjacentLines.push(new LineSegment(new Point(crop.left, crop.top), new Point(crop.left, bottom)));
    adjacentLines.push(new LineSegment(new Point(crop.right, crop.top), new Point(crop.right, bottom)));
    let fixedBottom = bottom;
    for (let imageLine of imageLines) {
      if (MathUtils.hasIntersection(imageLine, bottomLine)) {
        let result = this.tryToFindFixedSide(adjacentLines, imageLine, bottom, false, false);
        fixedBottom = Math.min(fixedBottom, result);
      }
    }
    return fixedBottom;
  }

  private tryToFindFixedSide(adjacentLines: Array<LineSegment>, imageLine: LineSegment,
                             side: number, isCompareX: boolean, isCompareMax: boolean): number {
    let fixedSide = side;
    let compareFunc = isCompareMax ? Math.max : Math.min;
    for (let adjacentLine of adjacentLines) {
      if (MathUtils.hasIntersection(imageLine, adjacentLine)) {
        let intersection = MathUtils.getIntersection(imageLine, adjacentLine);
        if (intersection == undefined) {
          continue;
        }
        let compare = isCompareX ? intersection.x : intersection.y;
        fixedSide = compareFunc(side, compare);
      }
    }
    return fixedSide;
  }
}