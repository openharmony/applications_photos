/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { AlbumDefine } from '../AlbumDefine';
import { TimelineData } from './TimelineData';
import { DateUtil } from '../../../utils/DateUtil';
import { Log } from '../../../utils/Log';
import { FileAsset, UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import { BrowserDataImpl } from '../BrowserDataImpl';
import userFileManager from '@ohos.filemanagement.userFileManager';

const TAG: string = 'TimelineDataImpl';

export class TimelineDataImpl extends BrowserDataImpl {

  // 分组查询方案
  getData(callback: AsyncCallback<TimelineData[]>, param: unknown): void {
    Log.info(TAG, `get groupData`);
    if (callback == null) {
      Log.info(TAG, 'loadGroupData with empty args');
      return;
    }
    let groupDataList: TimelineData[] = [];
    this.getGroups().then((groupData: Array<FileAsset>) => {
      Log.info(TAG, `get groupData length: ${groupData.length}`);
      if (groupData != null) {
        if (groupData.length === 0) {
          Log.warn(TAG, 'get groups empty');
        }
        groupData.forEach((data: FileAsset) => {
          if (!data) {
            Log.error(TAG, 'group data is null');
            return;
          }
          let groupCount: number = data.get(UserFileManagerAccess.GROUP_BY_KEY) as number;
          let dateAdded = data.get(userFileManager.ImageVideoKey.DATE_ADDED.toString()) as number * DateUtil.MILLISECONDS_PER_SECOND;
          let groupData = new TimelineData(dateAdded, dateAdded, groupCount);
          Log.info(TAG, `groupData count: ${groupCount}`);
          groupDataList.push(groupData);
        })
      }
      callback.callback(groupDataList);
    })
  }

  getDataCount(callback: AsyncCallback<number>, param): void {
    this.getItemsCount(param.id).then((count) => {
      Log.info(TAG, `getMediaItemCount callback: ${count}`);
      callback.callback(count);
    });
  }

  async getGroups(): Promise<Array<FileAsset>> {
    let fetchOpt = AlbumDefine.getTimelineGroupFetchOpt();
    return await this.getAllObject(fetchOpt);
  }

  getDataById(id: unknown, deviceId?: unknown): void {
  }

  getDataByUri(uri: unknown, deviceId?: string): void {

  }

  getDataByName(name: unknown, albumInfo: unknown): void {
  }

  getDataIndexByUri(callback: AsyncCallback<number>, param: unknown, uri: string): void {
  }

  getMediaItemByUri(callback: AsyncCallback<unknown>, uri: string): void {
  }
}