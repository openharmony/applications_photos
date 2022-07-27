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

import { RectF } from '../base/Rect'
import { MathUtils } from './MathUtils'

export abstract class DrawingUtils {
    private static readonly DEFAULT_LINE_WIDTH: number = 0.5;
    private static readonly DEFAULT_BUTTON_WIDTH: number = 3;
    private static readonly DEFAULT_BUTTON_PADDING: number = 1;
    private static readonly DEFAULT_BUTTON_LENGTH: number = 20;
    private static readonly DEFAULT_LINE_COLOR: string = '#80FFFFFF';
    private static readonly DEFAULT_BUTTON_COLOR: string = 'white';
    private static readonly DEFAULT_MASK_STYLE: string = 'rgba(0, 0, 0, 0.3)';

    static drawMask(ctx: CanvasRenderingContext2D, outer: RectF, inner: RectF) {
        ctx.fillStyle = DrawingUtils.DEFAULT_MASK_STYLE;
        ctx.fillRect(outer.left, outer.top, outer.getWidth(), inner.top - outer.top);
        ctx.fillRect(outer.left, inner.top, inner.left - outer.left, inner.getHeight());
        ctx.fillRect(inner.right, inner.top, outer.right - inner.right, inner.getHeight());
        ctx.fillRect(outer.left, inner.bottom, outer.getWidth(), outer.bottom - inner.bottom);
    }

    static drawCropButton(ctx: CanvasRenderingContext2D, crop: RectF) {
        let vp3 = DrawingUtils.DEFAULT_BUTTON_WIDTH;
        let padding = DrawingUtils.DEFAULT_BUTTON_PADDING;
        ctx.lineWidth = vp3;
        ctx.strokeStyle = DrawingUtils.DEFAULT_BUTTON_COLOR;
        let cornerLength = DrawingUtils.DEFAULT_BUTTON_LENGTH;
        DrawingUtils.drawCornerButton(ctx, crop, vp3, padding, cornerLength);
        DrawingUtils.drawLineButton(ctx, crop, vp3, padding, cornerLength);
    }

    private static drawCornerButton(ctx: CanvasRenderingContext2D, crop: RectF,
                                    vp3: number, padding: number, cornerLength: number) {
        // left top conner button
        let startX = crop.left - vp3 - padding;
        let startY = crop.top - vp3;
        let stopX = startX + cornerLength;
        let stopY = startY;
        DrawingUtils.drawLine(ctx, startX, startY, stopX, stopY);
        startX = crop.left - vp3;
        startY = crop.top - vp3 - padding;
        stopX = startX;
        stopY = startY + cornerLength;
        DrawingUtils.drawLine(ctx, startX, startY, stopX, stopY);

        // right top conner button
        startX = crop.right + vp3 + padding;
        startY = crop.top - vp3;
        stopX = startX - cornerLength;
        stopY = startY;
        DrawingUtils.drawLine(ctx, startX, startY, stopX, stopY);
        startX = crop.right + vp3;
        startY = crop.top - vp3 - padding;
        stopX = startX;
        stopY = startY + cornerLength;
        DrawingUtils.drawLine(ctx, startX, startY, stopX, stopY);

        // left bottom conner button
        startX = crop.left - vp3;
        startY = crop.bottom + vp3 + padding;
        stopX = startX;
        stopY = startY - cornerLength;
        DrawingUtils.drawLine(ctx, startX, startY, stopX, stopY);
        startX = crop.left - vp3 - padding;
        startY = crop.bottom + vp3;
        stopX = startX + cornerLength;
        stopY = startY;
        DrawingUtils.drawLine(ctx, startX, startY, stopX, stopY);

        // right bottom conner button
        startX = crop.right + vp3 + padding;
        startY = crop.bottom + vp3;
        stopX = startX - cornerLength;
        stopY = startY;
        DrawingUtils.drawLine(ctx, startX, startY, stopX, stopY);
        startX = crop.right + vp3;
        startY = crop.bottom + vp3 + padding;
        stopX = startX;
        stopY = startY - cornerLength;
        DrawingUtils.drawLine(ctx, startX, startY, stopX, stopY);
    }

    private static drawLineButton(ctx: CanvasRenderingContext2D, crop: RectF,
                                  vp3: number, padding: number, cornerLength: number) {
        // top button
        let startX = crop.getCenterX() - cornerLength / 2;
        let startY = crop.top - vp3;
        let stopX = startX + cornerLength;
        let stopY = startY;
        DrawingUtils.drawLine(ctx, startX, startY, stopX, stopY);

        // bottom button
        startX = crop.getCenterX() - cornerLength / 2;
        startY = crop.bottom + vp3;
        stopX = startX + cornerLength;
        stopY = startY;
        DrawingUtils.drawLine(ctx, startX, startY, stopX, stopY);

        // left button
        startX = crop.left - vp3;
        startY = crop.getCenterY() - cornerLength / 2;
        stopX = startX;
        stopY = startY + cornerLength;
        DrawingUtils.drawLine(ctx, startX, startY, stopX, stopY);

        // right button
        startX = crop.right + vp3;
        startY = crop.getCenterY() - cornerLength / 2;
        stopX = startX;
        stopY = startY + cornerLength;
        DrawingUtils.drawLine(ctx, startX, startY, stopX, stopY);
    }

    static drawRect(ctx: CanvasRenderingContext2D, crop: RectF) {
        ctx.lineWidth = DrawingUtils.DEFAULT_LINE_WIDTH;
        ctx.strokeStyle = DrawingUtils.DEFAULT_LINE_COLOR;
        let points = MathUtils.rectToPoints(crop);
        for (let i = 0; i < points.length; i++) {
            let j = (i + 1) % points.length;
            DrawingUtils.drawLine(ctx, points[i].x, points[i].y, points[j].x, points[j].y);
        }
    }

    static drawSplitLine(ctx: CanvasRenderingContext2D, crop: RectF, split) {
        ctx.lineWidth = DrawingUtils.DEFAULT_LINE_WIDTH;
        ctx.strokeStyle = DrawingUtils.DEFAULT_LINE_COLOR;
        let w = Math.ceil(crop.getWidth() / split);
        let h = Math.ceil(crop.getHeight() / split);
        for (let i = 1; i < split; i++) {
            let x = crop.left + w * i;
            let y = crop.top + h * i;
            DrawingUtils.drawLine(ctx, x, crop.top, x, crop.bottom);
            DrawingUtils.drawLine(ctx, crop.left, y, crop.right, y);
        }
    }

    static drawLine(ctx: CanvasRenderingContext2D, srcX: number, srcY: number, dstX: number, dstY: number) {
        ctx.beginPath();
        ctx.moveTo(srcX, srcY);
        ctx.lineTo(dstX, dstY);
        ctx.stroke();
    }
}