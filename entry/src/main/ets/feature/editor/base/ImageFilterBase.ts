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

import type { Releasable } from '../../../common/model/common/Releasable'
import { PixelMapWrapper } from './PixelMapWrapper'

export abstract class ImageFilterBase implements Releasable {
    private filterName: string;
    private cache: PixelMapWrapper = undefined;

    constructor(name: string) {
        this.filterName = name;
    }

    abstract render(pixelMap: PixelMapWrapper): PixelMapWrapper;

    setCache(pixelMap: PixelMapWrapper) {
        this.release();
        this.cache = pixelMap;
    }

    getCache(): PixelMapWrapper {
        return this.cache;
    }

    release(): void {
        if (this.isCached()) {
            this.cache.release();
            this.cache = undefined;
        }
    }

    isCached(): boolean {
        return (this.cache != null && this.cache != undefined);
    }

    name(): string {
        return this.filterName;
    }
}