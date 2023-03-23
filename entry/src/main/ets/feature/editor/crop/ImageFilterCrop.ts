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
import { RectF } from '../base/Rect';
import { ImageFilterBase } from '../base/ImageFilterBase';
import { PixelMapWrapper } from '../base/PixelMapWrapper';
import { MathUtils } from './MathUtils';

export class ImageFilterCrop extends ImageFilterBase {
    private static readonly FILTER_NAME: string = 'FilterCrop';
    private TAG: string = 'ImageFilterCrop';
    private isFlipHorizontal: boolean = false;
    private isFlipVertically: boolean = false;
    private rotationAngle: number = 0;
    private horizontalAngle: number = 0;
    private cropRect: RectF = undefined;

    constructor() {
        super(ImageFilterCrop.FILTER_NAME);
        this.cropRect = new RectF();
    }

    render(pixelMap: PixelMapWrapper): PixelMapWrapper {
        Log.debug(this.TAG, `render input wrapper: ${JSON.stringify(pixelMap)}`);
        let width = pixelMap.width;
        let height = pixelMap.height;
        let realCropRect = new RectF();
        realCropRect.set(this.cropRect.left, this.cropRect.top, this.cropRect.right, this.cropRect.bottom);
        MathUtils.revertRect(realCropRect, width, height);
        MathUtils.roundRect(realCropRect);
        Log.debug(this.TAG, `realCropRect: ${JSON.stringify(realCropRect)}`);

        let offWidth = realCropRect.getWidth();
        let offHeight = realCropRect.getHeight();
        offWidth = (offWidth > 0) ? offWidth : 1;
        offHeight = (offHeight > 0) ? offHeight : 1;
        let setting = new RenderingContextSettings(true);
        let offCtx = new OffscreenCanvasRenderingContext2D(offWidth, offHeight, setting);
        let tX = this.isFlipHorizontal ? -1 : 1;
        let tY = this.isFlipVertically ? -1 : 1;

        offCtx.save();
        offCtx.translate(this.isFlipHorizontal ? offWidth : 0, this.isFlipVertically ? offHeight : 0);
        offCtx.scale(tX, tY);

        offCtx.translate(offWidth / 2, offHeight / 2);
        offCtx.rotate(MathUtils.formulaAngle(this.rotationAngle * tX * tY + this.horizontalAngle));
        offCtx.translate(-offWidth / 2, -offHeight / 2);
        offCtx.translate(-realCropRect.left, -realCropRect.top);

        offCtx.drawImage(pixelMap.pixelMap, 0, 0, width, height);
        offCtx.restore();
        let outputPixelMap = offCtx.getPixelMap(0, 0, offWidth, offHeight);
        let output = new PixelMapWrapper(outputPixelMap, offWidth, offHeight);
        Log.debug(this.TAG, `render output wrapper: ${JSON.stringify(output)}`);
        return output;
    }

    setFlipHorizontal(isFlip: boolean) {
        this.isFlipHorizontal = isFlip;
    }

    setFlipVertically(isFlip: boolean) {
        this.isFlipVertically = isFlip;
    }

    setRotationAngle(angle: number) {
        this.rotationAngle = angle;
    }

    setHorizontalAngle(angle: number) {
        this.horizontalAngle = angle;
    }

    setCropRect(rect: RectF) {
        this.cropRect.set(rect.left, rect.top, rect.right, rect.bottom);
    }
}