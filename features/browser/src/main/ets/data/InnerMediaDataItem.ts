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
import MediaLib from '@ohos.multimedia.mediaLibrary';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';

export class InnerMediaDataItem extends MediaDataItem {
    constructor(uri: string, index: number) {
        super("", [], "", index)
        this.mediaType = MediaLib.MediaType.IMAGE
        this.uri = uri
        this.size = 256
        this.orientation = 0
    }

    async load(isForce: boolean): Promise<void> {
        if (this.status > (isForce ? MediaConstants.PART_LOADED : MediaConstants.UNDEFINED)) {
            return
        }
        this.width = vp2px(screenManager.getWinWidth())
        this.height = vp2px(screenManager.getWinHeight())
        if (this.width == 0 || this.height == 0) {
            this.status = MediaConstants.PART_LOADED
        } else {
            this.status = MediaConstants.LOADED
        }
    }

    async isFavor(): Promise<boolean> {
        return false
    }
}