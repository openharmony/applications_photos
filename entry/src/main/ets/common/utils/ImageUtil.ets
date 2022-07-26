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

import {Logger} from './Logger'

export class ImageUtil {
    static logger: Logger = new Logger('ImageUtil');
    private static readonly MAX_BIT = 30;
    private static readonly BIT_SIXTEEN = 16;
    private static readonly BIT_EIGHT = 8;
    private static readonly BIT_FOUR = 4;
    private static readonly BIT_TWO = 2;
    private static readonly BIT_ONE = 1;
    private static readonly ROTATE_TWICE = 180; //TODO MAGIC

    static computeSampleSize(width: number, height: number, minSideLength: number, maxNumOfPixels: number): number {
        if (width == 0 || height == 0 || minSideLength == 0 || maxNumOfPixels == 0) {
            return 2;
        }
        let initialSize = ImageUtil.computeInitialSampleSize(width, height, minSideLength, maxNumOfPixels);
        this.logger.error(`initialSize:  ${initialSize}`);
        return initialSize <= 8 ? ImageUtil.nextPowerOf2(initialSize) : Math.floor((initialSize + 8 - 1) / 8) * 8;
    }

    private static computeInitialSampleSize(width: number, height: number,
                                            minSideLength: number, maxNumOfPixels: number): number {
        if ((maxNumOfPixels == -1) && (minSideLength == -1)) {
            return 1;
        }

        let lowerBound: number = (maxNumOfPixels == -1) ? 1 : Math.ceil(Math.sqrt((width * height) / maxNumOfPixels));
        this.logger.error(`lowerBound: ${lowerBound}`);
        if (minSideLength == -1) {
            return lowerBound;
        } else {
            let sampleSize = Math.min(width / minSideLength, height / minSideLength);
            return Math.max(sampleSize, lowerBound);
        }
    }

    static nextPowerOf2(value: number): number {
        let useValue = value;
        if (useValue <= 0 || useValue > (1 << ImageUtil.MAX_BIT)) {
        }
        useValue -= 1;
        useValue |= useValue >> ImageUtil.BIT_SIXTEEN;
        useValue |= useValue >> ImageUtil.BIT_EIGHT;
        useValue |= useValue >> ImageUtil.BIT_FOUR;
        useValue |= useValue >> ImageUtil.BIT_TWO;
        useValue |= useValue >> ImageUtil.BIT_ONE;
        this.logger.error(`nextPowerOf2:${useValue}`);
        return useValue + 1;
    }

    /**
     * Calculate the aspect ratio, considering the direction of rotation
     *
     * @param info include orientation width height
     * @return the aspect ratio
     */
    static calcRatio(info: any): number {
        if (info == null || info == undefined) {
            return 1;
        }
        if (info.width == 0 || info.height == 0) {
            return 1;
        }
        let orientation = info.orientation || 0;
        return orientation == 0 || orientation == ImageUtil.ROTATE_TWICE ? info.width / info.height : info.height / info.width;
    }
}