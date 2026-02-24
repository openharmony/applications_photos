/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import lazy { AsyncCallback } from '@ohos/common/src/main/ets/default/model/common/AsyncCallback';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { TimelineData } from '@ohos/common/src/main/ets/default/model/browser/photo/TimelineData';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { TimelineDataSource } from './TimelineDataSource';

const TAG: string = 'timeline_GetTimelineDataCallback';

// Datasource requests media timeline group data callback
export class GetTimelineDataCallback implements AsyncCallback<TimelineData[]> {
  source: TimelineDataSource;
  requestTime: number;

  constructor(source: TimelineDataSource) {
    this.source = source;
    this.requestTime = Date.now();
    TraceControllerUtils.startTraceWithTaskId('getGroupData', this.requestTime);
  }

  callback(groupDataList: TimelineData[]): void {
    TraceControllerUtils.finishTraceWithTaskId('getGroupData', this.requestTime);
    Log.info(TAG, `took ${Date.now() - this.requestTime} ms to get group data: ${groupDataList.length}`);
    this.source.updateGroupData(this.requestTime, groupDataList);
  }
}