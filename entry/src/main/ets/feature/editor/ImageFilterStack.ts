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

import { EditStack } from './utils/EditStack';
import { ImageFilterBase } from './base/ImageFilterBase';
import { PixelMapWrapper } from './base/PixelMapWrapper';

enum CacheDirection {
    BACKWARD,
    FORWARD
}

export class ImageFilterStack extends EditStack<ImageFilterBase> {
    private static readonly CACHE_MAX: number = 20;
    private cacheStart: number = 0;
    private cacheEnd: number = 0;
    private origin: PixelMapWrapper = undefined;

    apply(pixelMap: PixelMapWrapper): PixelMapWrapper {
        super.executeEach((filter: ImageFilterBase) => {
            pixelMap = filter.render(pixelMap);
        }, super.getLength());
        return pixelMap;
    }

    push(filter: ImageFilterBase) {
        super.push(filter);
        this.updateCache(CacheDirection.FORWARD);
    }

    releaseAll() {
        super.executeEach((filter: ImageFilterBase) => {
            filter && filter.release();
        }, super.getLength());
        super.reset();
        this.cacheStart = 0;
        this.cacheEnd = 0;
    }

    setOriginPixelMap(origin: PixelMapWrapper) {
        this.origin = origin;
    }

    doRedo(): PixelMapWrapper {
        let position: number = super.redo();
        this.updateCache(CacheDirection.FORWARD);
        return super.at(position).getCache();
    }

    doUndo(): PixelMapWrapper {
        let position: number = super.undo();
        this.updateCache(CacheDirection.BACKWARD);
        return super.at(position).getCache();
    }

    private shouldReleaseCache(): boolean {
        return (this.cacheEnd - this.cacheStart >= ImageFilterStack.CACHE_MAX);
    }

    private updateCache(direction: CacheDirection) {
        let position = super.getPosition();
        let filter = super.at(position);
        if (direction == CacheDirection.BACKWARD) {
            if (!filter.isCached()) {
                let pixelMap = this.origin;
                filter.setCache(this.apply(pixelMap));
                this.cacheStart--;
            }

            if (this.shouldReleaseCache()) {
                super.at(this.cacheEnd).release();
                this.cacheEnd--;
            }
        } else if (direction == CacheDirection.FORWARD) {
            if (!filter.isCached()) {
                let pixelMap = (position > 0) ? super.at(position - 1).getCache() : this.origin;
                filter.setCache(filter.render(pixelMap));
                this.cacheEnd++;
            }

            if (this.shouldReleaseCache()) {
                super.at(this.cacheStart).release();
                this.cacheStart++;
            }
        }
    }
}