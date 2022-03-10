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

import {PhotoItem} from './PhotoItem.ets'
import {BroadCastConstants} from '../model/common/BroadCastConstants.ets';
import {Logger} from '../../feature/browser/utils/Logger.ets';
import {BroadCast} from '../utils/BroadCast.ets';

@Component
export struct PhotoSwiper {
    private dataSource;
    private logger: Logger = new Logger('PhotoSwiper');
    transition: string;
    @Consume currentIndex: number;
    @Consume broadCast: BroadCast;
    @Link isInPageTransition: boolean;
    onPhotoChanged: Function;
    onReleasePixmap: Function;
    swiperController: SwiperController;

    aboutToAppear() {
        this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED, () => {
            this.logger.info('animate to data reloaded start');
            animateTo({
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
                }}, () => {
                this.dataSource.deleteData(this.currentIndex);
            })
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
                            ? (this.transition + item.data.uri) : 'null',
                        transitionTag: this.transition ? this.transition : 'null',
                        releasePixmap: this.onReleasePixmap
                    })
                }
            }, (item) => item.data.uri)
        }
        .index(this.currentIndex)
            .indicator(false)
            .loop(false)
            .onChange((index: number) => {
                this.onPhotoChanged(index);
            })
            .visibility(this.isInPageTransition ? Visibility.Hidden : Visibility.Visible)
    }
}