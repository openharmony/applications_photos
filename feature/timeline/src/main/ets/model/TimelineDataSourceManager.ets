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

import lazy { TimelineDataSource } from './TimelineDataSource';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG: string = 'timeline_TimelineDataSourceManager';

export class TimelineDataSourceManager {
  private broadCast: BroadCast;
  private dataSource: TimelineDataSource;
  // 用于PC热启特性场景，窗口右上角点叉号退图库时，进程未被杀死，再次启动时需要手动触发一次数据刷新
  private static needRefreshFlag: boolean = false;

  private constructor() {
    Log.info(TAG, 'constructor');
    this.broadCast = new BroadCast();
    this.dataSource = new TimelineDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE, this.broadCast);
    this.dataSource.registerTimelineObserver();
  }

  public static onDestroy(): void {
    TimelineDataSourceManager.getInstance().unregisterObserver();
    if (TimelineDataSourceManager.instance) {
      if (TimelineDataSourceManager.instance.dataSource) {
        TimelineDataSourceManager.instance.dataSource.releaseBroadCast();
        TimelineDataSourceManager.instance.dataSource.releasePhotoBroadCast();
        TimelineDataSourceManager.instance.dataSource.broadCast = undefined;
      }
    }
    TimelineDataSourceManager.instance = undefined;
  }

  public static getInstance(): TimelineDataSourceManager {
    if (!TimelineDataSourceManager.instance) {
      TimelineDataSourceManager.instance = new TimelineDataSourceManager();
    }
    return TimelineDataSourceManager.instance;
  }

  public static instance?: TimelineDataSourceManager;

  public getBroadCast(): BroadCast {
    return this.broadCast;
  }

  public getDataSource(): TimelineDataSource {
    return this.dataSource;
  }

  public refreshData(): void {
    this.dataSource?.notifyDirty();
  }

  public static setNeedRefreshFlag(needRefresh: boolean): void {
    TimelineDataSourceManager.needRefreshFlag = needRefresh;
  }

  public static isNeedRefresh(): boolean {
    return TimelineDataSourceManager.needRefreshFlag;
  }

  private unregisterObserver(): void {
    this.dataSource?.unregisterTimelineObserver();
  }
}