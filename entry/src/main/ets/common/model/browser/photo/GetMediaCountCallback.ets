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
import {MediaDataSource} from './MediaDataSource'
import {Logger} from '../../../utils/Logger'
import {TraceControllerUtils} from '../../../utils/TraceControllerUtils'

// DataSource request media photo quantity callback
export class GetMediaCountCallback implements AsyncCallback<number> {
    logger: Logger = new Logger('GetMediaCountCallback');
    source: MediaDataSource;
    requestTime: number;

    // source: MediaDataSource
    constructor(source: MediaDataSource) {
        this.source = source;
        this.requestTime = Date.now();
        TraceControllerUtils.startTraceWithTaskId('getMediaCount', this.requestTime);
    }

    // Data callback
    callback(count: number) {
        TraceControllerUtils.finishTraceWithTaskId('getMediaCount', this.requestTime);
        this.source.updateMediaCount(this.requestTime, count);
    }
}