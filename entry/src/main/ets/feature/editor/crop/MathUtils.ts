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

import {LineSegment} from '../base/Line';
import {Point} from '../base/Point';
import {RectF} from '../base/Rect';
import {CropAngle} from './CropType';

export abstract class MathUtils {
    private static readonly EQUALITY_THRESHOLD = 0.0001;

    static roundRect(rect: RectF) {
        let copy = { ...rect };
        rect.set(Math.round(copy.left), Math.round(copy.top), Math.round(copy.right), Math.round(copy.bottom));
    }

    static normalizeRect(rect: RectF, width: number, height: number) {
        rect.left /= width;
        rect.right /= width;
        rect.top /= height;
        rect.bottom /= height;
    }

    static revertRect(rect: RectF, width: number, height: number) {
        rect.left *= width;
        rect.right *= width;
        rect.top *= height;
        rect.bottom *= height;
    }

    static rectToPoints(rect: RectF): Array<Point> {
        let points = [];
        points.push(new Point(rect.left, rect.top));
        points.push(new Point(rect.right, rect.top));
        points.push(new Point(rect.right, rect.bottom));
        points.push(new Point(rect.left, rect.bottom));
        return points;
    }

    static swapWidthHeight(rect: RectF) {
        let centerX = rect.getCenterX();
        let centerY = rect.getCenterY();
        let halfWidth = rect.getWidth() / 2;
        let halfHeight = rect.getHeight() / 2;
        rect.left = centerX - halfHeight;
        rect.right = centerX + halfHeight;
        rect.top = centerY - halfWidth;
        rect.bottom = centerY + halfWidth;
    }

    static rotatePoints(inputs: Array<Point>, angle: number, origin: Point): Array<Point> {
        let alpha = MathUtils.formulaAngle(-angle);
        let outputs = [];
        for (let input of inputs) {
            let dx = input.x - origin.x;
            let dy = input.y - origin.y;
            let output = new Point(origin.x, origin.y);
            output.x += Math.cos(alpha) * dx + Math.sin(alpha) * dy;
            output.y += -Math.sin(alpha) * dx + Math.cos(alpha) * dy;
            outputs.push(output);
        }
        return outputs;
    }

    static computeMaxRectWithinLimit(rect: RectF, limit: RectF, rate: number) {
        let limitWidth = limit.getWidth();
        let limitHeight = limit.getHeight();
        let width = limitWidth;
        let height = limitHeight;
        if (rate > (limitWidth / limitHeight)) {
            height = width / rate;
            rect.left = limit.left;
            rect.top = limit.top + (limitHeight - height) / 2;
        } else {
            width = height * rate;
            rect.left = limit.left + (limitWidth - width) / 2;
            rect.top = limit.top;
        }
        rect.right = rect.left + width;
        rect.bottom = rect.top + height;
    }

    static scaleRectBasedOnPoint(rect: RectF, p: Point, scale: number) {
        let operate = { ...rect };
        operate.left = (rect.left - p.x) * scale + p.x;
        operate.right = (rect.right - p.x) * scale + p.x;
        operate.top = (rect.top - p.y) * scale + p.y;
        operate.bottom = (rect.bottom - p.y) * scale + p.y;
        rect.set(operate.left, operate.top, operate.right, operate.bottom);
    }

    static hasIntersection(line1: LineSegment, line2: LineSegment): boolean {
        let p1 = line1.start;
        let p2 = line1.end;
        let p3 = line2.start;
        let p4 = line2.end;
        if (Math.max(p1.x, p2.x) < Math.min(p3.x, p4.x) || Math.max(p1.y, p2.y) < Math.min(p3.y, p4.y)
        || Math.max(p3.x, p4.x) < Math.min(p1.x, p2.x) || Math.max(p3.y, p4.y) < Math.min(p1.y, p2.y)) {
            return false;
        }

        if ((((p1.x - p3.x) * (p4.y - p3.y) - (p1.y - p3.y) * (p4.x - p3.x))
        * ((p2.x - p3.x) * (p4.y - p3.y) - (p2.y - p3.y) * (p4.x - p3.x))) >= 0
        || (((p3.x - p1.x) * (p2.y - p1.y) - (p3.y - p1.y) * (p2.x - p1.x))
        * ((p4.x - p1.x) * (p2.y - p1.y) - (p4.y - p1.y) * (p2.x - p1.x))) >= 0) {
            return false;
        }
        return true;
    }

    static getIntersection(line1: LineSegment, line2: LineSegment): Point {
        let A1 = line1.start.y - line1.end.y;
        let B1 = line1.end.x - line1.start.x;
        let C1 = A1 * line1.start.x + B1 * line1.start.y;

        let A2 = line2.start.y - line2.end.y;
        let B2 = line2.end.x - line2.start.x;
        let C2 = A2 * line2.start.x + B2 * line2.start.y;

        let k = A1 * B2 - A2 * B1;
        if (Math.abs(k) < MathUtils.EQUALITY_THRESHOLD) {
            return undefined;
        }

        let a = B2 / k;
        let b = -B1 / k;
        let c = -A2 / k;
        let d = A1 / k;

        let x = a * C1 + b * C2;
        let y = c * C1 + d * C2;
        return new Point(x, y);
    }

    static findSuitableScale(points: Array<Point>, rect: RectF, origin: Point): number {
        let scale = 1;
        let temp = 1;
        for (let point of points) {
            if (point.x < rect.left) {
                temp = (origin.x - point.x) / (origin.x - rect.left);
                scale = Math.max(scale, temp);
            }
            if (point.x > rect.right) {
                temp = (point.x - origin.x) / (rect.right - origin.x);
                scale = Math.max(scale, temp);
            }
            if (point.y < rect.top) {
                temp = (origin.y - point.y) / (origin.y - rect.top);
                scale = Math.max(scale, temp);
            }
            if (point.y > rect.bottom) {
                temp = (point.y - origin.y) / (rect.bottom - origin.y);
                scale = Math.max(scale, temp);
            }
        }
        return scale;
    }

    static fixImageMove(rotated: Array<Point>, flipImage: RectF): Array<number> {
        let offsetX = 0;
        let offsetY = 0;
        for (let point of rotated) {
            if (point.x < flipImage.left) {
                offsetX = Math.min(offsetX, point.x - flipImage.left);
            } else if (point.x > flipImage.right) {
                offsetX = Math.max(offsetX, point.x - flipImage.right);
            }
            if (point.y < flipImage.top) {
                offsetY = Math.min(offsetY, point.y - flipImage.top);
            } else if (point.y > flipImage.bottom) {
                offsetY = Math.max(offsetY, point.y - flipImage.bottom);
            }
        }
        return [offsetX, offsetY];
    }

    static isOddRotation(angle: number): boolean {
        if (angle == -CropAngle.ONE_QUARTER_CIRCLE_ANGLE || angle == -CropAngle.THREE_QUARTER_CIRCLE_ANGLE) {
            return true;
        }
        return false;
    }

    static limitCornerIfLineIntersect(outerLine, diagonal, rect) {
        let origin = new Point(rect.getCenterX(), rect.getCenterY());
        if (MathUtils.hasIntersection(outerLine, diagonal)) {
            let intersection = MathUtils.getIntersection(outerLine, diagonal);
            if (intersection == undefined) {
                return;
            }
            if (intersection.x < origin.x) {
                rect.left = intersection.x;
            } else {
                rect.right = intersection.x;
            }
            if (intersection.y < origin.y) {
                rect.top = intersection.y;
            } else {
                rect.bottom = intersection.y;
            }
        }
    }

    static limitRectInRotated(rect: RectF, outerLines: Array<LineSegment>) {
        let copy = new RectF();
        copy.set(rect.left, rect.top, rect.right, rect.bottom);
        let diagonal1 = new LineSegment(new Point(copy.left, copy.top), new Point(copy.right, copy.bottom));
        for (let line of outerLines) {
            MathUtils.limitCornerIfLineIntersect(line, diagonal1, copy);
        }

        let diagonal2 = new LineSegment(new Point(copy.left, copy.bottom), new Point(copy.right, copy.top));
        for (let line of outerLines) {
            MathUtils.limitCornerIfLineIntersect(line, diagonal2, copy);
        }
        rect.set(copy.left, copy.top, copy.right, copy.bottom);
    }

    static limitRectInRotatedBasedOnPoint(baseIndex: number, rect: RectF, rotatedLines: Array<LineSegment>) {
        let points = MathUtils.rectToPoints(rect);
        let base = points[baseIndex];
        points.splice(baseIndex, 1);
        let scale = 1;
        for (let point of points) {
            let line = new LineSegment(base, point);
            for (let rotatedLine of rotatedLines) {
                if (MathUtils.hasIntersection(line, rotatedLine)) {
                    let p = MathUtils.getIntersection(line, rotatedLine);
                    if (p == undefined) {
                        continue;
                    }
                    let tempScale
                        = Math.hypot(p.x - base.x, p.y - base.y) / Math.hypot(point.x - base.x, point.y - base.y);
                    scale = Math.min(scale, (tempScale > MathUtils.EQUALITY_THRESHOLD) ? tempScale : 1);
                }
            }
        }
        MathUtils.scaleRectBasedOnPoint(rect, base, scale);
    }

    static getMaxFixedRectSize(rate: number, maxWidth: number, maxHeight: number): Array<number> {
        let width = 0;
        let height = 0;
        if (rate > (maxWidth / maxHeight)) {
            width = maxWidth;
            height = width / rate;
        } else {
            height = maxHeight;
            width = height * rate;
        }
        return [width, height];
    }

    static getMinFixedRectSize(rate: number, minLength: number): Array<number> {
        let width = minLength;
        let height = minLength;
        if (rate > 1) {
            width = height * rate;
        } else {
            height = width / rate;
        }
        return [width, height];
    }

    static areRectSame(rect1: RectF, rect2: RectF): boolean {
        if (rect1.left == rect2.left && rect1.top == rect2.top
        && rect1.right == rect2.right && rect1.bottom == rect2.bottom) {
            return true;
        }
        return false;
    }

    static formulaAngle(angle: number): number {
        return angle * Math.PI / CropAngle.HALF_CIRCLE_ANGLE;
    }
}