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

import {AsyncCallback} from '../../common/AsyncCallback'
import {MediaItem} from './MediaItem'
import {MediaDataSource} from './MediaDataSource'
import {Logger} from '../../../utils/Logger'
import {TraceControllerUtils} from '../../../utils/TraceControllerUtils'

// Datasource requests media mediaItem callback
export class GetItemsCallback implements AsyncCallback<MediaItem[]> {
    source: MediaDataSource;
    requestTime: number;
    start: number;
    private logger: Logger = new Logger('GetItemsCallback');

    constructor(source: MediaDataSource, start: number) {
        this.source = source;
        this.requestTime = Date.now();
        this.start = start;
        TraceControllerUtils.startTraceWithTaskId('getMediaItems', this.requestTime);
    }

    callback(assets: MediaItem[]) {
        TraceControllerUtils.finishTraceWithTaskId('getMediaItems', this.requestTime);
        this.logger.info(`took ${Date.now() - this.requestTime} milliseconds to load data: ${assets.length}`);
        this.source.updateMediaData(this.requestTime, this.start, assets);
    }
}