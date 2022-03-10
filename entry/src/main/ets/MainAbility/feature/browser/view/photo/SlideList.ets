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

import {SlideImageItem} from './SlideImageItem'
import {Logger} from '../../utils/Logger'

@Component
export struct SlideList {
    scrollController: Scroller = new Scroller();
    index = 0;
    private list
    private logger: Logger = new Logger('SlideList');


    aboutToAppear() {
        this.logger.info(`aboutToAppear begin index: ${this.index}`);
    }
    build() {
        List({ initialIndex: this.index, scroller: this.scrollController }) {
            LazyForEach(this.list, (item) => {
                ListItem(){
                    SlideImageItem({index: this.list.getDataIndex(item.data), startIndex: this.index,
                        totalCount: this.list.totalCount(), scrollController: this.scrollController, src: item.data})
                }
                .height('100%')
                .width('100%')
            }, item => item)
        }.listDirection(Axis.Horizontal)
    }
}