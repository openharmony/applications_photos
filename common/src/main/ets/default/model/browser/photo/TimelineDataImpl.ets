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
/* instrument ignore file*/
import type { AsyncCallback } from '../../common/AsyncCallback';
import lazy { BrowserDataImpl } from '../BrowserDataImpl';
import lazy { Log } from '../../../utils/Log';
import lazy { PhotoAsset, UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { TimelineData } from './TimelineData';
import lazy { TimelineDataManager } from './TimelineDataManager';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy { ImageUtil } from '../../../../default/utils/ImageUtil'

const TAG: string = 'TimelineDataImpl';

export interface Params {
  id: string,
}

export class TimelineDataImpl extends BrowserDataImpl {
  private manager: TimelineDataManager = new TimelineDataManager();

  // 分组查询方案
  public getData(callback: AsyncCallback<TimelineData[]>, param: Params): void {
    if (callback == null) {
      Log.warn(TAG, 'get groupData fail, callback is null');
      return;
    }

    Log.info(TAG, 'get groupData');
    const getGroupsCallback = (groupAssetDataArr: PhotoAsset[]): void => {
      TimelineDataManager.parseGroupAssetData(groupAssetDataArr, groupDataArr);
      callback.callback(groupDataArr);
    };
    let groupDataArr: TimelineData[] = [];
    let isThumbnailReady: boolean = ImageUtil.isThumbnailReady();
    this.getGroupAssetDataArr(isThumbnailReady).then(getGroupsCallback);
  }

  public getDataCount(callback: AsyncCallback<number>, param: Params): void {
    this.getItemsCount(param.id).then((count): void => {
      Log.info(TAG, `getMediaItemCount callback: ${count}`);
      callback.callback(count);
    });
  }

  public getDataById(id: string, deviceId?: string): void {
  }

  public async getDataByUri(uri: string, deviceId?: string): Promise<void> {
  }

  public async getDataByName(name: string, albumUri: string): Promise<void> {
  }

  public getDataIndexByUri(callback: AsyncCallback<number>, param: Params, uri: string): void {
  }

  public getMediaItemByUri(callback: AsyncCallback, uri: string): void {
  }

  /**
   * 获取分组的元数据集
   *
   * @returns 分组的元数据集
   */
  private async getGroupAssetDataArr(isThumbnailReady: boolean): Promise<PhotoAsset[]> {
    TraceControllerUtils.startTrace('TimelineDataImpl getGroupAssetDataArr');
    let fetchOption: photoAccessHelper.FetchOptions = TimelineDataManager.getGroupFetchOption(isThumbnailReady);
    let dataArr: PhotoAsset[] = await UserFileManagerAccess.getInstance().getAllObject(fetchOption, TAG);
    TraceControllerUtils.finishTrace('TimelineDataImpl getGroupAssetDataArr');
    return dataArr;
  }
}