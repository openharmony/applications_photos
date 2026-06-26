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

import lazy { collections } from '@kit.ArkTS';
import lazy common from '@ohos.app.ability.common';
import lazy dataSharePredicates from '@ohos.data.dataSharePredicates';
import lazy { Log } from '../../../utils/Log';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { PhotoAsset, UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import lazy { TimelineData } from './TimelineData';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy { MediaItem } from './MediaItem';
import lazy { DateUtil } from '../../../utils/DateUtil';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { PositionFilter } from '../../PositionFilter';
import lazy { UserFileData } from '../../UserFileData';

/* instrument ignore file */
const TAG: string = 'common_TimelineDataManager';
const BATCH_LOG_SIZE:number = 50;

export declare type CommonContext = common.UIAbilityContext | common.ServiceExtensionContext;

export class TimelineDataManager {
  private context?: CommonContext;

  public constructor(context?: CommonContext) {
    this.context = context;
  }

  /**
   * 获取分组数据集
   * @param groupDataArr 待组装的分组数据集
   * @param isThumbnailReady 是否为ready机制
   * @returns
   */
  public async getTimelineData(groupDataArr: collections.Array<TimelineData>,
    isThumbnailReady: boolean): Promise<void> {
    let groupAssetDataArr = await this.getGroupAssetDataArr(isThumbnailReady);
    TimelineDataManager.parseGroupAssetData(groupAssetDataArr, groupDataArr);
  }

  public async getResult(albumUri: string,
    positionFilter: PositionFilter | undefined): Promise<collections.Array<TimelineData>> {
    let result: collections.Array<TimelineData> = new collections.Array<TimelineData>();
    if (!this.context) {
      Log.warn(TAG, 'getResult invalid context');
      return result;
    }

    const START_TIME: number = Date.now();
    const TRACE_TAG: string = 'TimelineDataManager.getResult';
    TraceControllerUtils.startTraceWithTaskId(TRACE_TAG, START_TIME);

    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.orderByDesc(photoAccessHelper.PhotoKeys.DATE_TAKEN_MS);
    predicates.groupBy([String(photoAccessHelper.PhotoKeys.DATE_DAY)]);
    if (positionFilter !== undefined) {
      UserFileData.convertPosition(predicates, positionFilter);
    }

    let fetchOptions: photoAccessHelper.FetchOptions = {
      predicates: predicates,
      fetchColumns: [String(UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS),
        String(UserFileManagerAccess.FILE_KEY_DATE_DAY), UserFileManagerAccess.GROUP_BY_KEY],
    } as photoAccessHelper.FetchOptions;

    Log.info(TAG, `getResult albumUri: ${albumUri}, filter: ${positionFilter}`);
    if (!albumUri) {
      let dataArr: PhotoAsset[] = await UserFileManagerAccess.getResult(this.context, fetchOptions, TAG);
      TimelineDataManager.parseGroupAssetData(dataArr, result);
      TraceControllerUtils.finishTraceWithTaskId(TRACE_TAG, START_TIME);
      return result;
    }

    let album: photoAccessHelper.Album | undefined = await UserFileManagerAccess.getAlbum(this.context, albumUri);
    if (!album) {
      Log.warn(TAG, `getResult failed to get album: ${albumUri}`);
      return result;
    }
    Log.info(TAG, `getResult succeed to get album: ${albumUri}`);
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      fetchResult = await album.getAssets(fetchOptions);
      let dataArr: PhotoAsset[] = await fetchResult.getAllObjects();
      TimelineDataManager.parseGroupAssetData(dataArr, result);
      return result;
    } catch (e) {
      Log.error(TAG, `getResult failed error: ${(e as BusinessError)?.code}`);
      return new collections.Array<TimelineData>();
    } finally {
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
      TraceControllerUtils.finishTraceWithTaskId(TRACE_TAG, START_TIME);
    }
  }

  /**
   * 获取分组查询选项
   * @param isThumbnailReady 是否为ready机制
   * @returns 分组查询选项
   */
  public static getGroupFetchOption(isThumbnailReady: boolean): photoAccessHelper.FetchOptions {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.orderByDesc(photoAccessHelper.PhotoKeys.DATE_TAKEN_MS);
    predicates.groupBy([String(photoAccessHelper.PhotoKeys.DATE_DAY)]);
    if (isThumbnailReady) {
      predicates.equalTo(UserFileManagerAccess.FILE_KEY_THUMBNAIL_VISIBLE,
        UserFileManagerAccess.THUMBNAIL_VISIBLE_VALUE);
    }
    let fetchOption: photoAccessHelper.FetchOptions = {
      predicates,
      fetchColumns: isThumbnailReady ?
        [UserFileManagerAccess.FILE_KEY_THUMBNAIL_VISIBLE,
          String(UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS), String(UserFileManagerAccess.FILE_KEY_DATE_DAY),
          UserFileManagerAccess.GROUP_BY_KEY] :
        [String(UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS), String(UserFileManagerAccess.FILE_KEY_DATE_DAY),
          UserFileManagerAccess.GROUP_BY_KEY],
    };
    return fetchOption;
  }

  /**
   * 解析分组数据集
   *
   * @param groupAssetDataArr 分组的元数据集
   * @param groupDataArr 待解析注入的分组数据集
   */
  public static parseGroupAssetData(groupAssetDataArr: PhotoAsset[],
    groupDataArr: collections.Array<TimelineData> | TimelineData[]): void {
    if (!groupDataArr || !groupAssetDataArr) {
      return;
    }

    Log.info(TAG, `parseGroupAssetData, group len:${groupAssetDataArr.length}`);
    let msg: string[] = [];
    for (let i: number = 0; i < groupAssetDataArr.length; i++) {
      let data: PhotoAsset = groupAssetDataArr[i];
      if (!data) {
        Log.warn(TAG, 'group data is null');
        continue;
      }
      let groupData: TimelineData | undefined;
      try {
        let groupCount: number = data.get(UserFileManagerAccess.FILE_KEY_GROUP_COUNT) as number;
        let dateTaken = data.get(UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString()) as number;
        let dateDay = data.get(UserFileManagerAccess.FILE_KEY_DATE_DAY.toString()) as string;
        groupData = new TimelineData(dateTaken, dateTaken, groupCount, dateDay);
        groupDataArr.push(groupData);
      } catch (err) {
        if (Number.parseInt(err.code) === UserFileManagerAccess.BUSINESS_ERROR_INVALID_COLUMN) {
          let groupCount: number = data.get(UserFileManagerAccess.GROUP_BY_KEY) as number;
          let dateTaken = data.get(UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString()) as number;
          let dateDay = data.get(UserFileManagerAccess.FILE_KEY_DATE_DAY.toString()) as string;
          groupData = new TimelineData(dateTaken, dateTaken, groupCount, dateDay);
        }
      } finally {
        if (groupData) {
          groupDataArr.push(groupData);
          msg.push(`<${i}, cnt:${groupData.count}, date:${groupData.startDate}, day: ${groupData.dateDay}>`);
        }
        if (msg.length === BATCH_LOG_SIZE) {
          Log.info(TAG, `group data: ${msg.join(', ')}`);
          msg.splice(0, msg.length);
        }
      }
    }
    Log.info(TAG, `group data: ${msg.join(', ')}}`);
    Log.info(TAG, 'parseGroupAssetData end.');
  }

  /**
   * 获取分组的元数据集
   *
   * @returns 分组的元数据集
   */
  private async getGroupAssetDataArr(isThumbnailReady: boolean): Promise<PhotoAsset[]> {
    if (!this.context) {
      Log.warn(TAG, 'getGroupAssetDataArr, context invalid');
      return [];
    }

    const startTime: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('TimelineDataManager getGroupAssetDataArr', startTime);
    let fetchOption: photoAccessHelper.FetchOptions = TimelineDataManager.getGroupFetchOption(isThumbnailReady);
    let dataArr: PhotoAsset[] = await UserFileManagerAccess.getResult(this.context, fetchOption, TAG);
    TraceControllerUtils.finishTraceWithTaskId('TimelineDataManager getGroupAssetDataArr', startTime);
    return dataArr;
  }

  public static parseGroupData(mediaItems: (MediaItem | undefined)[]): TimelineData[] {
    Log.info(TAG, 'parseGroupData');
    let groupDataList: TimelineData[] = [];
    if (mediaItems === null || mediaItems.length === 0) {
      Log.error(TAG, 'parseGroupData mediaItems are empty!');
      return groupDataList;
    }
    let groupCount: number = 1;
    let startTime: number = mediaItems[0]?.getDateTaken() ?? 0;
    let endTime: number = mediaItems[0]?.getDateTaken() ?? 0;
    for (let i: number = 1; i < mediaItems.length; i++) {
      let dateTaken: number = mediaItems[i]?.getDateTaken() ?? 0;
      if (DateUtil.isTheSameDay(startTime, dateTaken)) {
        groupCount++;
        endTime = dateTaken;
      } else {
        let groupData: TimelineData = new TimelineData(startTime, endTime, groupCount);
        groupDataList.push(groupData);
        groupCount = 1;
        startTime = dateTaken;
        endTime = dateTaken;
      }
    }
    let groupData: TimelineData = new TimelineData(startTime, endTime, groupCount);
    groupDataList.push(groupData);
    return groupDataList;
  }
}