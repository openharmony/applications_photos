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

import {Releasable} from '../../common/Releasable'

/**
 * Thumbnail, view layer, data encapsulation
 *
 * @author h00423928
 * @since 2020-08-31
 */
export class Thumbnail implements Releasable {

    /**
     * pixelMap
     */
    pixelMap?: any = undefined;

    /**
     * width
     */
    width?: number = 0;

    /**
     * height
     */
    height?: number = 0;

    constructor(pixelMap: any, width: number, height: number) {
        this.pixelMap = pixelMap;
        this.width = width;
        this.height = height;
    }

    /**
     * release source
     */
    release(): void {
        if (this.pixelMap != null && this.pixelMap != undefined) {
            this.pixelMap.release();
        }
        this.width = 0;
        this.height = 0;
    }
}