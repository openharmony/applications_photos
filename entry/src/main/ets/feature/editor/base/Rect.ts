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

export class RectF {
    left: number;
    top: number;
    right: number;
    bottom: number;

    constructor() {
        this.left = 0;
        this.top = 0;
        this.right = 0;
        this.bottom = 0;
    }

    set(left: number, top: number, right: number, bottom: number) {
        this.left = left;
        this.top = top;
        this.right = right;
        this.bottom = bottom;
    }

    getWidth(): number {
        return (this.right - this.left);
    }

    getHeight(): number {
        return (this.bottom - this.top);
    }

    getDiagonal(): number {
        return Math.hypot(this.getWidth(), this.getHeight());
    }

    getCenterX(): number {
        return (this.left + this.getWidth() / 2);
    }

    getCenterY(): number {
        return (this.top + this.getHeight() / 2);
    }

    isInRect(x: number, y: number): boolean {
        return (x >= this.left && x <= this.right && y >= this.top && y <= this.bottom);
    }

    scale(scale: number) {
        this.left *= scale;
        this.right *= scale;
        this.top *= scale;
        this.bottom *= scale;
    }

    move(offsetX: number, offsetY: number) {
        this.left += offsetX;
        this.right += offsetX;
        this.top += offsetY;
        this.bottom += offsetY;
    }
}