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

import lazy { AsyncCallback } from '../../common/AsyncCallback';
import lazy { common } from '@kit.AbilityKit';
import lazy { Constants } from '../../common/Constants';
import lazy { ImageUtil } from '../../../../default/utils/ImageUtil';
import lazy sendablePhotoAccessHelper from '@ohos.file.sendablePhotoAccessHelper';
import lazy taskpool from '@ohos.taskpool';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy { YearMonthDataInterface } from '../../../interface/BrowserDataInterface';
import lazy { YearMonthMediaItem } from './YearMonthMediaItem';
import lazy { YearMonthQueryParam } from './YearMonthQueryParam';
import lazy { YearMonthUtil } from './YearMonthUtil';

export declare type CommonContext = common.UIAbilityContext | common.ServiceExtensionContext;

/* instrument ignore next */
// @Concurrent
// function getMediaItemTask(context: CommonContext, start: number,
//   count: number, priority: number, isThumbnailReady: boolean): YearMonthMediaItem[] {
//   if (context === undefined || context === null) {
//     return [];
//   }
//   if (start < 0 || count <= 0) {
//     return [];
//   }
//   let helper: sendablePhotoAccessHelper.PhotoAccessHelper =
//     sendablePhotoAccessHelper.getPhotoAccessHelper(context);
//   if (!helper) {
//     return [];
//   }
//
//   TraceControllerUtils.startTrace(`getMediaItemTask-${priority}`);
//   let ret: YearMonthMediaItem[] = [];
//   let groupNum: number = Math.floor(count / Constants.YEAR_ITEM_COUNT_PER_GROUP);
//   for (let i: number = 0; i < groupNum; i++) {
//     let items: YearMonthMediaItem[] = YearMonthUtil.queryMediaItem(helper,
//       start + i * Constants.YEAR_ITEM_COUNT_PER_GROUP, Constants.YEAR_ITEM_COUNT_PER_GROUP, priority, isThumbnailReady);
//     if (items.length !== 0) {
//       ret.push(...items);
//     }
//   }
//   let lastGroupCnt: number = count - groupNum * Constants.YEAR_ITEM_COUNT_PER_GROUP;
//   if (lastGroupCnt > 0) {
//     let items: YearMonthMediaItem[] = YearMonthUtil.queryMediaItem(helper,
//       start + groupNum * Constants.YEAR_ITEM_COUNT_PER_GROUP, lastGroupCnt, priority, isThumbnailReady);
//     if (items.length !== 0) {
//       ret.push(...items);
//     }
//   }
//   TraceControllerUtils.finishTrace(`getMediaItemTask-${priority}`);
//   return ret;
// }

export class YearMonthDataImpl implements YearMonthDataInterface {
  /**
   * 查询年月视图元数据
   *
   * @param callback 回调函数
   * @param param 查询参数
   */
  public getMediaData(callback: AsyncCallback<YearMonthMediaItem[]>, param: YearMonthQueryParam): void {
    if (callback === undefined || callback === null) {
      return;
    }
    if (param === undefined || param === null || !param.isValid()) {
      return;
    }

    let context: CommonContext = getContext(this) as CommonContext;
    // this.getMetaDataAsync(context, param.start, param.count, param.priority).then((ret: YearMonthMediaItem[]) => {
    //   callback.callback(ret);
    // });
  }

  // private async getMetaDataAsync(context: CommonContext, start: number,
  //   count: number, priority: number): Promise<YearMonthMediaItem[]> {
  //   let mediaData: YearMonthMediaItem[] = await taskpool.execute(
  //     getMediaItemTask, context, start, count, priority, ImageUtil.isThumbnailReady()) as YearMonthMediaItem[];
  //   return mediaData;
  // }
}