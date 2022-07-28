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

import { ImageFilterBase } from './ImageFilterBase'
import { PhotoEditMode } from './PhotoEditType'
import { PixelMapWrapper } from './PixelMapWrapper'

export abstract class PhotoEditBase {
    private editMode: PhotoEditMode;

    constructor(mode: PhotoEditMode) {
        this.editMode = mode;
    }

    abstract entry(pixelMap: PixelMapWrapper): void;

    abstract exit(): ImageFilterBase;

    abstract setCanvasContext(context: CanvasRenderingContext2D): void;

    abstract setCanvasSize(width: number, height: number): void;

    mode(): PhotoEditMode {
        return this.editMode;
    }

    name(): string {
        return this.toString();
    }

    private toString(): string {
        switch (this.editMode) {
            case PhotoEditMode.EDIT_MODE_CROP:
                return 'crop';
            default:
                return 'unknown';
        }
    }
}