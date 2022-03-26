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

import {TimelineData} from '../../../common/model/browser/photo/TimelineData.ets'
import {AsyncCallback} from '../../../common/model/common/AsyncCallback'
import {Logger} from '../utils/Logger.ets'
import {TimelineDataSource} from './TimelineDataSource'
import {TraceControllerUtils} from '../../../common/utils/TraceControllerUtils.ets'

// Datasource requests media timeline group data callback
export class GetTimelineDataCallback implements AsyncCallback<TimelineData[]> {
    source: TimelineDataSource;
    requestTime: number;
    private logger: Logger = new Logger('GetTimelineDataCallback');

    constructor(source: TimelineDataSource) {
        this.source = source;
        this.requestTime = Date.now();
        TraceControllerUtils.startTraceWithTaskId('getGroupData', this.requestTime);
    }

    callback(groupDataList: TimelineData[]) {
        TraceControllerUtils.finishTraceWithTaskId('getGroupData', this.requestTime);
        this.logger.info(`took ${Date.now() - this.requestTime} ms to get group data: ${groupDataList.length}`);
        this.source.updateGroupData(this.requestTime, groupDataList);
    }
}