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

import { PhotoItem } from './PhotoItem'
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import { logDebug } from '@ohos/base/src/main/ets/utils/LoggerUtils'
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { AnimationConstants } from '@ohos/base/src/main/ets/constants/AnimationConstants';
import { GroupItemDataSource } from '@ohos/base/src/main/ets/vm/GroupItemDataSource'
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import { Constants } from '../constants/Constants'

const TAG = "PhotoSwiper"

@Component
export struct PhotoSwiper {
    photoSwiperTransition: string
    private dataSource: GroupItemDataSource;
    @Consume currentIndex: number;
    @Consume broadCast: Broadcast;
    @Consume canSwipe: boolean;
    @State duration: number = 400;
    onPhotoChanged: Function;
    private swiperController: SwiperController;

    aboutToAppear() {
        this.broadCast.on(BroadcastConstants.ON_DATA_RELOADED, () => {
            logDebug(TAG, 'animate to data reloaded start');
            animateTo({
                duration: AnimationConstants.DELETE_ANIMATE_DURATION,
                onFinish: () => {
                } }, () => {
                this.dataSource.dataRemove();
                this.broadCast.emit(Constants.DATA_SIZE_CHANGED,[this.dataSource.totalCount()]);
            })
        });

        this.broadCast.on(BroadcastConstants.CHANGE_SWIPER_DURATION, (value) => {
            logDebug(TAG, `change duration start ${value}`);
            this.duration = value;
        });
    }

    build() {
        Swiper(this.swiperController) {
            LazyForEach(this.dataSource, (item: MediaDataItem) => {
                if (item) {
                    Column() {
                        PhotoItem({
                            item: item,
                            pageName: this.photoSwiperTransition
                        })
                    }.zIndex(item && item.index == this.currentIndex ? 2 : 1)
                }
            }, (item: MediaDataItem) => item ? item.getHashCode() : JSON.stringify(item))
        }
        .gesture(PanGesture({
            direction: PanDirection.Horizontal
        }))
        .index(this.currentIndex)
        .indicator(false)
        .loop(false)
        .onChange((index: number) => {
            if (this.duration != 0) {
                this.onPhotoChanged(index);
            }
        })
        .disableSwipe(this.canSwipe)
    }
}