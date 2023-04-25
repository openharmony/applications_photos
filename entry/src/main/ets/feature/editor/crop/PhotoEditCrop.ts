/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { PhotoEditBase } from '../base/PhotoEditBase';
import { PhotoEditMode } from '../base/PhotoEditType';
import { ImageFilterBase } from '../base/ImageFilterBase';
import { PixelMapWrapper } from '../base/PixelMapWrapper';
import { Point } from '../base/Point';
import { RectF } from '../base/Rect';
import { CropRatioType, CropTouchState, CropAngle } from './CropType';
import { ImageFilterCrop } from './ImageFilterCrop';
import { CropShow } from './CropShow';
import { MathUtils } from './MathUtils';
import { DrawingUtils } from './DrawingUtils';

export class PhotoEditCrop extends PhotoEditBase {
    private static readonly BASE_SCALE_VALUE: number = 1.0;
    private static readonly DEFAULT_MAX_SCALE_VALUE: number = 3.0;
    private static readonly DEFAULT_IMAGE_RATIO: number = 1.0;
    private static readonly DEFAULT_MIN_SIDE_LENGTH: number = 32;
    private static readonly DEFAULT_MARGIN_LENGTH: number = 20;
    private static readonly DEFAULT_TIMEOUT_MILLISECOND_1000: number = 1000;
    private static readonly DEFAULT_SPLIT_FRACTION: number = 3;
    private TAG: string = 'PhotoEditCrop';
    private filter: ImageFilterCrop = undefined;
    private input: PixelMapWrapper = undefined;
    private isFlipHorizontal: boolean = false;
    private isFlipVertically: boolean = false;
    private rotationAngle: number = 0;
    private sliderAngle: number = 0;
    private cropRatio: CropRatioType = CropRatioType.RATIO_TYPE_FREE;
    private cropShow: CropShow = undefined;
    private isCropShowInitialized: boolean = false;
    private ctx: CanvasRenderingContext2D = undefined;
    private displayWidth: number = 0;
    private displayHeight: number = 0;
    private marginW: number = PhotoEditCrop.DEFAULT_MARGIN_LENGTH;
    private marginH: number = PhotoEditCrop.DEFAULT_MARGIN_LENGTH;
    private imageRatio: number = PhotoEditCrop.DEFAULT_IMAGE_RATIO;
    private scale: number = PhotoEditCrop.BASE_SCALE_VALUE;
    private timeoutId: number = 0;
    private timeout: number = PhotoEditCrop.DEFAULT_TIMEOUT_MILLISECOND_1000;
    private isWaitingRefresh: boolean = false;
    private touchPoint: Point = undefined;
    private pinchPoint: Point = undefined;
    private state: CropTouchState = CropTouchState.NONE;
    private splitFraction: number = PhotoEditCrop.DEFAULT_SPLIT_FRACTION;

    constructor() {
        super(PhotoEditMode.EDIT_MODE_CROP);
        this.cropShow = new CropShow();
        this.touchPoint = new Point(0, 0);
        this.pinchPoint = new Point(0, 0);
    }

    entry(pixelMap: PixelMapWrapper) {
        if (undefined == pixelMap) {
            return;
        }
        Log.info(this.TAG, `entry pixelMap: ${JSON.stringify(pixelMap)}`);
        this.input = pixelMap;
        this.filter = new ImageFilterCrop();
        this.initialize(this.input);
        if (this.isCropShowInitialized) {
            let limit = this.calcNewLimit();
            this.cropShow.init(limit, this.imageRatio);
        }
        this.refresh();
    }

    private initialize(pixelMap: PixelMapWrapper) {
        this.imageRatio = pixelMap.width / pixelMap.height;
        this.determineMaxScaleFactor(pixelMap);
        this.clear();
    }

    private calcNewLimit(): RectF {
        let limit = new RectF();
        limit.set(this.marginW, this.marginH, this.displayWidth - this.marginW, this.displayHeight - this.marginH);
        return limit;
    }

    private determineMaxScaleFactor(pixelMap: PixelMapWrapper) {
        let scaleFactorW = pixelMap.width / px2vp(PhotoEditCrop.DEFAULT_MIN_SIDE_LENGTH);
        let scaleFactorH = pixelMap.height / px2vp(PhotoEditCrop.DEFAULT_MIN_SIDE_LENGTH);
        this.cropShow.setMaxScaleFactor(scaleFactorW, scaleFactorH);
    }

    exit(): ImageFilterBase {
        Log.info(this.TAG, 'exit');
        this.filter && this.saveFinalOperation();
        this.isCropShowInitialized = false;
        this.input = undefined;
        this.clearCanvas();
        if (this.couldReset()) {
            this.clear();
        } else {
            this.filter = undefined;
        }
        return this.filter;
    }

    private saveFinalOperation() {
        let crop = this.cropShow.getCropRect();
        let image = this.cropShow.getImageRect();
        crop.move(-image.left, -image.top);
        MathUtils.normalizeRect(crop, image.getWidth(), image.getHeight());
        this.filter.setCropRect(crop);
        this.filter.setRotationAngle(this.rotationAngle);
        this.filter.setHorizontalAngle(this.sliderAngle);
        this.filter.setFlipHorizontal(this.isFlipHorizontal);
        this.filter.setFlipVertically(this.isFlipVertically);
    }

    private clear() {
        this.cropRatio = CropRatioType.RATIO_TYPE_FREE;
        this.isFlipHorizontal = false;
        this.isFlipVertically = false;
        this.rotationAngle = 0;
        this.sliderAngle = 0;
    }

    setCanvasContext(context: CanvasRenderingContext2D) {
        Log.info(this.TAG, 'setCanvasContext');
        this.ctx = context;
        this.refresh();
    }

    setCanvasSize(width: number, height: number) {
        Log.info(this.TAG, `setCanvasSize: width[${width}], height[${height}]`);
        this.displayWidth = width;
        this.displayHeight = height;
        let limit = this.calcNewLimit();
        if (this.isCropShowInitialized) {
            this.cropShow.syncLimitRect(limit);
            this.input && this.determineMaxScaleFactor(this.input);
        } else {
            this.cropShow.init(limit, this.imageRatio);
            this.isCropShowInitialized = true;
        }
        this.refresh();
    }

    private refresh() {
        if (this.ctx != undefined && this.input != undefined) {
            this.drawImage();
            this.drawCrop();
        }
    }

    private delayRefresh(delay: number) {
        this.isWaitingRefresh = true;
        this.timeoutId = setTimeout(() => {
            this.cropShow.enlargeCropArea();
            this.refresh();
            this.isWaitingRefresh = false;
        }, delay);
    }

    private clearDelayRefresh() {
        clearTimeout(this.timeoutId);
        this.isWaitingRefresh = false;
    }

    private clearCanvas() {
        if (this.ctx != undefined) {
            this.ctx.clearRect(0, 0, this.displayWidth, this.displayHeight);
        }
    }

    private drawImage() {
        this.ctx.save();
        this.clearCanvas();

        let x = this.displayWidth / 2;
        let y = this.displayHeight / 2;
        this.ctx.translate(this.isFlipHorizontal ? 2 * x : 0, this.isFlipVertically ? 2 * y : 0);

        let tX = this.isFlipHorizontal ? -1 : 1;
        let tY = this.isFlipVertically ? -1 : 1;
        this.ctx.scale(tX, tY);

        this.ctx.translate(x, y);
        this.ctx.rotate(MathUtils.formulaAngle(this.rotationAngle * tX * tY + this.sliderAngle));
        this.ctx.translate(-x, -y);

        let image = this.cropShow.getImageRect();
        MathUtils.roundRect(image);
        this.ctx.drawImage(this.input.pixelMap, image.left, image.top, image.getWidth(), image.getHeight());
        this.ctx.restore();
    }

    private drawCrop() {
        let crop = this.cropShow.getCropRect();
        MathUtils.roundRect(crop);
        let display = new RectF();
        display.set(0, 0, this.displayWidth, this.displayHeight);
        DrawingUtils.drawMask(this.ctx, display, crop);
        DrawingUtils.drawSplitLine(this.ctx, crop, this.splitFraction);
        DrawingUtils.drawRect(this.ctx, crop);
        DrawingUtils.drawCropButton(this.ctx, crop);
    }

    onMirrorChange() {
        Log.debug(this.TAG, 'onMirrorChange');
        if (this.isWaitingRefresh) {
            this.clearDelayRefresh();
            this.cropShow.enlargeCropArea();
        } else {
            if (MathUtils.isOddRotation(this.rotationAngle)) {
                this.isFlipVertically = !this.isFlipVertically;
            } else {
                this.isFlipHorizontal = !this.isFlipHorizontal;
            }
            this.cropShow.setFlip(this.isFlipHorizontal, this.isFlipVertically);
        }
        this.refresh();
    }

    onRotationAngleChange() {
        Log.debug(this.TAG, 'onRotationAngleChange');
        if (this.isWaitingRefresh) {
            this.clearDelayRefresh();
            this.cropShow.enlargeCropArea();
        } else {
            this.rotationAngle = (this.rotationAngle - CropAngle.ONE_QUARTER_CIRCLE_ANGLE) % CropAngle.CIRCLE_ANGLE;
            this.cropShow.syncRotationAngle(this.rotationAngle);
        }
        this.refresh();
    }

    onSliderAngleChange(angle: number) {
        Log.debug(this.TAG, `onSliderAngleChange: angle[${angle}]`);
        if (this.isWaitingRefresh) {
            this.clearDelayRefresh();
            this.cropShow.enlargeCropArea();
            this.refresh();
        }
        this.sliderAngle = angle;
        this.cropShow.syncHorizontalAngle(this.sliderAngle);
        this.refresh();
    }

    onFixedRatioChange(ratio: CropRatioType) {
        Log.debug(this.TAG, `onFixedRatioChange: ratio[${ratio}]`);
        if (this.isWaitingRefresh) {
            this.clearDelayRefresh();
            this.cropShow.enlargeCropArea();
        }
        this.cropRatio = ratio;
        this.cropShow.setRatio(ratio);
        this.endImageDrag();
        this.refresh();
    }

    onTouchStart(x: number, y: number) {
        if (this.state != CropTouchState.NONE) {
            Log.debug(this.TAG, `onTouchStart: touch state is not none!`);
            return;
        }

        if (this.isWaitingRefresh) {
            this.clearDelayRefresh();
        }

        Log.debug(this.TAG, `onTouchStart: [x: ${x}, y: ${y}]`);
        if (this.cropShow.isCropRectTouch(x, y)) {
            this.state = CropTouchState.CROP_MOVE;
        } else {
            this.state = CropTouchState.IMAGE_DRAG;
        }
        this.touchPoint.set(x, y);
    }

    onTouchMove(x: number, y: number) {
        Log.debug(this.TAG, `onTouchMove: [state: ${this.state}] [x: ${x}, y: ${y}]`);
        let offsetX = x - this.touchPoint.x;
        let offsetY = y - this.touchPoint.y;
        if (this.state == CropTouchState.CROP_MOVE) {
            this.cropShow.moveCropRect(offsetX, offsetY);
        } else if (this.state == CropTouchState.IMAGE_DRAG) {
            this.onImageDrag(offsetX, offsetY);
        } else {
            return;
        }
        this.refresh();
        this.touchPoint.set(x, y);
    }

    onTouchEnd() {
        Log.debug(this.TAG, `onTouchEnd: [state: ${this.state}]`);
        if (this.state == CropTouchState.CROP_MOVE) {
            this.cropShow.endCropRectMove();
        } else if (this.state == CropTouchState.IMAGE_DRAG) {
            this.endImageDrag();
            this.refresh();
        } else {
            return;
        }
        this.state = CropTouchState.NONE;
        if (this.isWaitingRefresh) {
            this.clearDelayRefresh();
        }
        this.delayRefresh(this.timeout);
    }

    private onImageDrag(offsetX: number, offsetY: number) {
        let tX = this.isFlipHorizontal ? -1 : 1;
        let tY = this.isFlipVertically ? -1 : 1;
        let alpha = MathUtils.formulaAngle(this.rotationAngle * tX * tY + this.sliderAngle);
        let x = Math.cos(alpha) * offsetX * tX + Math.sin(alpha) * offsetY * tY;
        let y = -Math.sin(alpha) * offsetX * tX + Math.cos(alpha) * offsetY * tY;
        let image = this.cropShow.getImageRect();
        image.move(x, y);
        this.cropShow.setImageRect(image);
    }

    private endImageDrag() {
        let crop = this.cropShow.getCropRect();
        let points = MathUtils.rectToPoints(crop);
        let tX = this.isFlipHorizontal ? -1 : 1;
        let tY = this.isFlipVertically ? -1 : 1;
        let angle = -(this.rotationAngle * tX * tY + this.sliderAngle);
        let displayCenter = new Point(this.displayWidth / 2, this.displayHeight / 2);
        let rotated = MathUtils.rotatePoints(points, angle, displayCenter);

        let flipImage = this.cropShow.getCurrentFlipImage();
        let offsets = MathUtils.fixImageMove(rotated, flipImage);
        let image = this.cropShow.getImageRect();
        image.move(offsets[0] * tX, offsets[1] * tY);
        this.cropShow.setImageRect(image);
    }

    onPinchStart(x: number, y: number, scale: number) {
        Log.debug(this.TAG, `onPinchStart: event[x: ${x}, y: ${y}]`);
        this.state = CropTouchState.IMAGE_SCALE;
        this.pinchPoint.set(x, y);
        this.scale = scale;
    }

    onPinchUpdate(scale: number) {
        Log.debug(this.TAG, `onPinchUpdate: scale[${scale}]`);
        if (this.state == CropTouchState.IMAGE_SCALE) {
            let factor = scale / this.scale;
            if (!this.cropShow.couldEnlargeImage()) {
                factor = factor > PhotoEditCrop.BASE_SCALE_VALUE ? PhotoEditCrop.BASE_SCALE_VALUE : factor;
            }
            let image = this.cropShow.getImageRect();
            MathUtils.scaleRectBasedOnPoint(image, this.pinchPoint, factor);
            this.cropShow.setImageRect(image);
            this.refresh();
            this.scale *= factor;
        }
    }

    onPinchEnd() {
        Log.debug(this.TAG, 'onPinchEnd');
        let crop = this.cropShow.getCropRect();
        let points = MathUtils.rectToPoints(crop);
        let tX = this.isFlipHorizontal ? -1 : 1;
        let tY = this.isFlipVertically ? -1 : 1;
        let angle = -(this.rotationAngle * tX * tY + this.sliderAngle);
        let displayCenter = new Point(this.displayWidth / 2, this.displayHeight / 2);
        let rotated = MathUtils.rotatePoints(points, angle, displayCenter);

        let flipImage = this.cropShow.getCurrentFlipImage();
        let origin = new Point(crop.getCenterX(), crop.getCenterY());
        let centerOffsetX = origin.x - flipImage.getCenterX();
        let centerOffsetY = origin.y - flipImage.getCenterY();
        flipImage.move(centerOffsetX, centerOffsetY);
        let scale = MathUtils.findSuitableScale(rotated, flipImage, origin);
        flipImage.move(-centerOffsetX, -centerOffsetY);

        MathUtils.scaleRectBasedOnPoint(flipImage, origin, scale);
        let offsets = MathUtils.fixImageMove(rotated, flipImage);

        let image = this.cropShow.getImageRect();
        MathUtils.scaleRectBasedOnPoint(image, origin, scale);
        image.move(offsets[0] * tX, offsets[1] * tY);
        this.cropShow.setImageRect(image);
        this.refresh();
        this.state = CropTouchState.NONE;
        this.delayRefresh(this.timeout);
        this.scale = PhotoEditCrop.BASE_SCALE_VALUE;
    }

    couldReset(): boolean {
        let crop = this.cropShow.getCropRect();
        MathUtils.roundRect(crop);
        let image = this.cropShow.getImageRect();
        MathUtils.roundRect(image);
        if (this.isFlipHorizontal != false || this.isFlipVertically != false
        || this.rotationAngle != 0 || this.sliderAngle != 0
        || this.cropRatio != CropRatioType.RATIO_TYPE_FREE
        || !MathUtils.areRectSame(crop, image)) {
            return true;
        }
        return false;
    }

    reset() {
        Log.debug(this.TAG, 'reset');
        let limit = this.calcNewLimit();
        this.cropShow.init(limit, this.imageRatio);
        this.initialize(this.input);
        this.refresh();
    }
}