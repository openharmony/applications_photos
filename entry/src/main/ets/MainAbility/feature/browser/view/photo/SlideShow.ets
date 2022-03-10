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
import {Constants} from '../../../../common/model/common/Constants.ets'
import {PhotoDataSource} from '../../../../common/model/browser/photo/PhotoDataSource.ets'
import {SlideList} from './SlideList'
import {Logger} from '../../utils/Logger'

@Entry
@Component
struct SlideShow {
    @Provide broadCast: BroadCast = new BroadCast();
    private logger: Logger = new Logger("SlideShow");
    @Provide list: PhotoDataSource = new PhotoDataSource();
    index: number = 0;
    totalCount: number = 0;
    aboutToAppear() {
        this.logger.info('aboutToAppear begin');
        let param = router.getParams();
        this.list = AppStorage.Get(Constants.APP_KEY_SLIDE_SHOW);
        this.index = param.index;
        this.totalCount = this.list.totalCount();
        this.logger.info(`aboutToAppear index is ${this.index} totalCount is ${this.totalCount}`);
    }
    build() {
        Stack({ alignContent: Alignment.TopStart }) {
            SlideList({index: this.index, list: this.list})
        }
        .backgroundColor(Color.Black)
        .onTouch(() => {
            router.back();
        })
        .onClick(() => {
            router.back();
        })
        .gesture(
        PanGesture()
            .onActionStart(() => {
                router.back();
            })
        )
    }
}