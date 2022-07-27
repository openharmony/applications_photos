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
import { BroadCastConstants } from '../model/common/BroadCastConstants';
import { Logger } from '../../feature/browser/utils/Logger';
import { BroadCast } from '../utils/BroadCast';
import { Constants } from '../model/common/Constants';
import { Constants as PhotoConstants } from '../../common/model/browser/photo/Constants'

@Component
export struct PhotoSwiper {
    private dataSource;
    private logger: Logger = new Logger('PhotoSwiper');
    transition: string;
    @Consume currentIndex: number;
    @Consume broadCast: BroadCast;
    @Consume canSwipe: boolean;
    @State duration: number = 400;
    onPhotoChanged: Function;
    swiperController: SwiperController;

    aboutToAppear() {
        this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED, () => {
            this.logger.debug('animate to data reloaded start');
            animateTo({
                duration: Constants.DELETE_ANIMATE_DURATION,
                onFinish: () => {
                    let totalCount = this.dataSource.totalCount();
                    this.dataSource.onDataChanged(this.currentIndex);
                    // UPDATE NEXT TWO DATA FOR AVOID NOT LOADING DATA
                    if (this.currentIndex + 1 < totalCount) {
                        this.dataSource.onDataChanged(this.currentIndex + 1);
                    }
                    if (this.currentIndex + 2 < totalCount) {
                        this.dataSource.onDataChanged(this.currentIndex + 2);
                    }
                    this.dataSource.onDataReloaded();
                } }, () => {
                this.dataSource.deleteData(this.currentIndex);
            })
        });

        this.broadCast.on(BroadCastConstants.CHANGE_SWIPER_DURATION, (value) => {
            this.logger.debug(`change duration start ${value}`);
            this.duration = value;
        });
    }

    build() {
        Swiper(this.swiperController) {
            LazyForEach(this.dataSource, (item) => {
                Column() {
                    PhotoItem({
                        item: item.data,
                        position: item.pos,
                        thumbnail: item.thumbnail,
                        transitionId: (item.pos == this.currentIndex && this.transition != undefined)
                            ? (this.transition + item.data.uri) : PhotoConstants.DEFAULT_TRANSITION_ID,
                        transitionTag: this.transition ? this.transition : PhotoConstants.DEFAULT_TRANSITION_ID,
                    })
                }.zIndex(item.pos == this.currentIndex ? 2 : 1)
            }, (item) => item.data.uri)
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