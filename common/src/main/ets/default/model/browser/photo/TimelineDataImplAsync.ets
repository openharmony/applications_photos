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

import type { AsyncCallback } from '../../common/AsyncCallback';
import lazy { collections } from '@kit.ArkTS';
import lazy { CommonContext, TimelineDataManager } from './TimelineDataManager';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { Log } from '../../../utils/Log';
import lazy { Params, TimelineDataImpl } from './TimelineDataImpl';
import lazy taskpool from '@ohos.taskpool';
import lazy { TimelineData } from './TimelineData';
import lazy { ImageUtil } from '../../../../default/utils/ImageUtil'
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { PositionFilter } from '../../PositionFilter';

const TAG: string = 'TimelineDataImplAsync';

/* instrument ignore next */
@Concurrent
async function getTimelineDataTask(context: CommonContext,
  result: collections.Array<TimelineData>, isThumbnailReady: boolean): Promise<void> {
  let manager = new TimelineDataManager(context);

  // 直接操作共享实例
  await manager.getTimelineData(result, isThumbnailReady);
}

/* instrument ignore next */
@Concurrent
export async function getTimelineDataFunc(context: CommonContext,
  albumUri: string, positionFilter: PositionFilter | undefined): Promise<collections.Array<TimelineData>> {
  let manager: TimelineDataManager = new TimelineDataManager(context);

  let result: collections.Array<TimelineData> = await manager.getResult(albumUri, positionFilter);
  Log.info('TimelineDataImplAsync', `getTimelineDataFunc ${result.length}`);
  return result;
}

export class TimelineDataImplAsync extends TimelineDataImpl {
  // 分组查询方案
  public getData(callback: AsyncCallback<TimelineData[]>, param: Params): void {
    if (callback == null) {
      Log.warn(TAG, 'get groupData fail, callback is null');
      return;
    }

    let context = (getContext(this) as CommonContext) || global.uiAbilityContext();

    // taskpool支持传递的context是页面的context，第一次getData处于onWindowStageCreate前，无法获取页面context
    if (this.isAsyncParamValid(context)) {
      this.getDataAsync(context).then((timelineDataList: TimelineData[]) => {
        callback.callback(timelineDataList);
      });
    } else {
      super.getData(callback, param);
    }
  }

  public async getDataAsync(context: CommonContext): Promise<TimelineData[]> {
    Log.info(TAG, 'get groupData async');
    if (this.isAsyncParamValid(context)) {
      let array: collections.Array<TimelineData> = new collections.Array<TimelineData>();
      let isThumbnailReady: boolean = ImageUtil.isThumbnailReady();
      await taskpool.execute(getTimelineDataTask, context, array, isThumbnailReady);
      return TimelineData.convertTimelineData(array);
    }

    return new Promise((resolve): void => {
      let array: TimelineData[] = [];
      resolve(array);
    });
  }

  private isAsyncParamValid(context: CommonContext): boolean {
    if (!context) {
      Log.warn(TAG, 'isAsyncParamValid, context invalid');
      return false;
    }
    return true;
  }
}