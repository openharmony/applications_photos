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

import router from '@system.router'
import {BroadCast} from '../../../../common/utils/BroadCast.ets'
import {Constants as PhotoConstants} from '../../../../common/model/browser/photo/Constants'
import {MediaItem} from '../../../../common/model/browser/photo/MediaItem.ets'
import {Logger} from '../../utils/Logger'

@Component
export struct SlideImageItem {
    @Consume broadCast: BroadCast;
    @State scale: number = 1.0;
    @State opacity: number = 1;
    private logger: Logger = new Logger("SlideImageItem");
    scrollController: Scroller = new Scroller();
    isFirst = true;
    startIndex = 0;
    index = 0;
    isEven = false;
    totalCount = 0;
    src: MediaItem;
    isSkip = false;
    aboutToAppear() {
        this.logger.info(`aboutToAppear ${this.index}`);
        this.isFirst = this.index === this.startIndex;
        this.isEven = ((this.index - this.startIndex) % 2) === 0;
        this.broadCast.on(PhotoConstants.ANIMATION_EVENT + String(this.index), () => {
            this.logger.info(`animate on ${this.index} + ${this.isEven}`);
            if (this.isSkip) {
                this.logger.info(`${this.index} can not read show next`);
                if (this.index === this.totalCount - 1) {
                    this.logger.info('all play end, go back');
                    router.back();
                    return;
                } else {
                    this.opacity = 0;
                    this.scrollController.scrollToIndex(this.index + 1);
                    this.broadCast.emit(PhotoConstants.ANIMATION_EVENT + String(this.index + 1), []);
                }
            }
            this.scale = this.isEven ? 1 : 1.5;
            animateTo({
                duration: 3000,
                delay: 0,
                iterations: 1,
                onFinish: () => {
                    this.logger.info(`play end with ${this.index} totalCount is ${this.totalCount}`)
                    if (this.index === this.totalCount - 1) {
                        this.logger.info('all play end, go back')
                        router.back();
                        return;
                    } else {
                        this.opacity = 0;
                        this.scrollController.scrollToIndex(this.index + 1)
                        this.broadCast.emit(PhotoConstants.ANIMATION_EVENT + String(this.index + 1), []);
                    }
                }
            }, () => {
                this.scale = this.scale == 1.5 ? 1 : 1.5;
                this.opacity = 0;
            })
        })
    }
    build() {
        Image(this.src.uri)
            .height('100%')
            .width('100%')
            .scale({ x: this.scale, y: this.scale})
            .opacity(this.opacity)
            .objectFit(ImageFit.Contain)
            .onError(() => {
                this.isSkip = true;
                if (this.isFirst) {
                    this.logger.info(`${this.index} can not read show next`);
                    if (this.index === this.totalCount - 1) {
                        this.logger.info('all play end, go back');
                        router.back();
                        return;
                    } else {
                        this.scrollController.scrollToIndex(this.index + 1);
                        this.broadCast.emit(PhotoConstants.ANIMATION_EVENT + String(this.index + 1), []);
                    }
                }
            })
            .onComplete(() => {
                if (this.isFirst && !this.isSkip) {
                    animateTo({
                        duration: 3000,
                        delay: 0,
                        iterations: 1,
                        onFinish: () => {
                            this.logger.info('first play end');
                            this.opacity = 0;
                            if (this.index === this.totalCount - 1) {
                                this.logger.info('all play end, go back');
                                router.back();
                                return;
                            } else {
                                this.scrollController.scrollToIndex(this.index + 1);
                                this.broadCast.emit(PhotoConstants.ANIMATION_EVENT + String(this.index + 1), []);
                            }
                        }
                    }, () => {
                        this.scale = 1.5
                        this.opacity = 0
                    })
                }
            })
    }
}