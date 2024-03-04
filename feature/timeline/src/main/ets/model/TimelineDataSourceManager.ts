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

import { TimelineDataSource } from './TimelineDataSource';
import { BroadCast, Constants, Log } from '@ohos/common';
import { Constants as TimeLineConstants } from './Constants';

const TAG: string = 'timeline_TimelineDataSourceManager';

export class TimelineDataSourceManager {
  private broadCast: BroadCast;
  private dataSource: TimelineDataSource;

  private constructor() {
    Log.info(TAG, 'constructor');
    this.broadCast = new BroadCast();
    this.dataSource = new TimelineDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE, this.broadCast);
    this.dataSource.registerTimelineObserver();
  }

  public static getInstance(): TimelineDataSourceManager {
    if (AppStorage.Get(TimeLineConstants.APP_KEY_GROUP_DATA_SOURCE_MANAGER) == null) {
      AppStorage.setOrCreate(TimeLineConstants.APP_KEY_GROUP_DATA_SOURCE_MANAGER, new TimelineDataSourceManager());
    }
    return AppStorage.Get(TimeLineConstants.APP_KEY_GROUP_DATA_SOURCE_MANAGER);
  }

  public getBroadCast(): BroadCast {
    return this.broadCast;
  }

  public getDataSource(): TimelineDataSource {
    return this.dataSource;
  }
}