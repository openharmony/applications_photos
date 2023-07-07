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

import { PhotoItem } from './PhotoItem';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { AnimationConstants } from '@ohos/base/src/main/ets/constants/AnimationConstants';
import { GroupItemDataSource } from '@ohos/base/src/main/ets/vm/GroupItemDataSource';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import { Constants } from '../constants/Constants';
import { LazyItem } from '@ohos/base/src/main/ets/vm/ItemDataSource';

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
            Log.debug(TAG, 'animate to data reloaded start');
            animateTo({
                duration: AnimationConstants.DELETE_ANIMATE_DURATION,
                onFinish: () => {
                } }, () => {
                if (this.dataSource != null && this.dataSource != undefined) {
                    this.dataSource.dataRemove();
                    this.broadCast.emit(Constants.DATA_SIZE_CHANGED,[this.dataSource.totalCount()]);
                }
            })
        });

        this.broadCast.on(BroadcastConstants.CHANGE_SWIPER_DURATION, (value) => {
            Log.debug(TAG, `change duration start ${value}`);
            this.duration = value;
        });
    }

    aboutToDisappear(): void {
        this.swiperController = undefined;
    }

    build() {
        Swiper(this.swiperController) {
            LazyForEach(this.dataSource, (item: LazyItem<MediaDataItem>) => {
                if (item && item.get()) {
                    PhotoItem({
                        item: item.get(),
                        pageName: this.photoSwiperTransition
                    })
                    .zIndex(item && item.index == this.currentIndex ? 2 : 1)
                }
            }, (item: LazyItem<MediaDataItem>) => item == null && item.get() ? JSON.stringify(item) : item.getHashCode())
        }
        .itemSpace('8vp')
        .gesture(PanGesture({
            direction: PanDirection.Horizontal
        }))
        .index(this.currentIndex)
        .indicator(false)
        .loop(false)
        .onChange((index: number) => {
            if (AppStorage.Get("isDelete") == 0) {
                if (this.currentIndex - index == 1) {
                    AppStorage.SetOrCreate("isLeftSwiper", 1);
                } else if (this.currentIndex - index == -1) {
                    AppStorage.SetOrCreate("isLeftSwiper", 0);
                }
            }
            if (this.duration != 0) {
                this.onPhotoChanged(index);
            }
        })
        .disableSwipe(this.canSwipe)
    }
}