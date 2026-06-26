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
import lazy { BigDataConstants } from './ReportToBigDataUtil';
import lazy { DateUtil } from './DateUtil';
import lazy { UserFileManagerAccess } from '../access/UserFileManagerAccess';
import lazy { basePeriodReport, Params, TmpKVPairs } from './BasePeriodReport';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';

const TAG = 'StatisticReportUtil';

export function nowOverOneWeek(lastReportTime: string): boolean {
  const period = DateUtil.DAYS_OF_THE_WEEK * DateUtil.MILLISECONDS_OF_ONE_DAY;
  return lastReportTime === '' || Date.now() - new Date(lastReportTime).getTime() >= period;
}

export function nowOverOneDay(lastReportTime: string): boolean {
  const period = DateUtil.MILLISECONDS_OF_ONE_DAY;
  return lastReportTime === '' || Date.now() - new Date(lastReportTime).getTime() >= period;
}

export async function openAlbumReportFn(albumSubType: photoAccessHelper.AlbumSubtype): Promise<void> {
  const tmpKVPairs: TmpKVPairs = {
    openPhotoAlbumCount: UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE,
    openVideoAlbumCount: UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE,
    openFavorAlbumCount: UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE,
  };
  let params: TmpKVPairs = {
    openPhotoAlbumCount: 0,
    openVideoAlbumCount: 0,
    openFavorAlbumCount: 0,
  };
  if (albumSubType === tmpKVPairs.openPhotoAlbumCount) {
    params.openPhotoAlbumCount++;
  }
  if (albumSubType === tmpKVPairs.openVideoAlbumCount) {
    params.openVideoAlbumCount++;
  }
  if (albumSubType === tmpKVPairs.openFavorAlbumCount) {
    params.openFavorAlbumCount++;
  }
  const reportKey = BigDataConstants.OPEN_SYSTEM_ALBUM_TIMES_ID;
  const period = DateUtil.MILLISECONDS_OF_ONE_DAY;
  await basePeriodReport(reportKey, period, params);
}

/*************************** 设置页统计打点 *****************************/

export async function settingsPageStatusReport(
  cloudDriveStatus: boolean | undefined,
  galleryNetworkStatus: boolean | undefined,
  unlimitedNetworkStatus: boolean | undefined,
  cloudDriveStorageStatus: string | undefined
): Promise<void> {
  const reportKey = BigDataConstants.SETTINGS_PAGE_STATUS;
  const msg = [
    cloudDriveStatus,
    galleryNetworkStatus,
    unlimitedNetworkStatus,
    cloudDriveStorageStatus,
  ];

  const period = DateUtil.DAYS_OF_THE_WEEK * DateUtil.MILLISECONDS_OF_ONE_DAY;
  await basePeriodReport(reportKey, period, [], Promise.resolve(msg));
}

/*************************** 基础相册统计打点 *****************************/

export async function commonAlbumStatusBaseReport(reportKey: string, count: number): Promise<string> {
  const period = DateUtil.DAYS_OF_THE_WEEK * DateUtil.MILLISECONDS_OF_ONE_DAY;
  const lastReportTime = await basePeriodReport(reportKey, period, [], Promise.resolve([count]));
  return lastReportTime;
}

export async function fileCountReport(count: number): Promise<string> {
  const reportKey = BigDataConstants.FILE_COUNT;
  const lastReportTime = await commonAlbumStatusBaseReport(reportKey, count);
  return lastReportTime;
}

export async function userAlbumsCountReport(count: number): Promise<string> {
  const reportKey = BigDataConstants.USER_ALBUMS_COUNT;
  const lastReportTime = await commonAlbumStatusBaseReport(reportKey, count);
  return lastReportTime;
}

export async function photoAlbumFileCountReport(count: number): Promise<string> {
  const reportKey = BigDataConstants.PHOTO_ALBUM_FILE_COUNT;
  const lastReportTime = await commonAlbumStatusBaseReport(reportKey, count);
  return lastReportTime;
}

export async function cloudEnhanceAlbumFileCountReport(count: number): Promise<string> {
  const reportKey = BigDataConstants.CLOUD_ENHANCE_ALBUM_FILE_COUNT;
  const lastReportTime = await commonAlbumStatusBaseReport(reportKey, count);
  return lastReportTime;
}

export async function videoAlbumFileCountReport(count: number): Promise<string> {
  const reportKey = BigDataConstants.VIDEO_ALBUM_FILE_COUNT;
  const lastReportTime = await commonAlbumStatusBaseReport(reportKey, count);
  return lastReportTime;
}

export async function favorAlbumFileCountReport(count: number): Promise<string> {
  const reportKey = BigDataConstants.FAVOR_ALBUM_FILE_COUNT;
  const lastReportTime = await commonAlbumStatusBaseReport(reportKey, count);
  return lastReportTime;
}

export async function hiddenAlbumsCountReport(count: number): Promise<string> {
  const reportKey = BigDataConstants.HIDDEN_ALBUMS_COUNT;
  const lastReportTime = await commonAlbumStatusBaseReport(reportKey, count);
  return lastReportTime;
}

export async function sourceAlbumCountReport(count: number): Promise<string> {
  const reportKey = BigDataConstants.SOURCE_ALBUMS_COUNT;
  const lastReportTime = await commonAlbumStatusBaseReport(reportKey, count);
  return lastReportTime;
}

export async function moreAlbumsFileCountReport(hiddenFileCount: number, trashFileCount: number): Promise<string> {
  const reportKey = BigDataConstants.MORE_ALBUMS_FILE_COUNT;
  const period = DateUtil.DAYS_OF_THE_WEEK * DateUtil.MILLISECONDS_OF_ONE_DAY;
  const msg = [hiddenFileCount, trashFileCount];
  const lastReportTime = await basePeriodReport(reportKey, period, [], Promise.resolve(msg));
  return lastReportTime;
}

export async function externalStorageStatusBaseReport(reportKey: string, count: number): Promise<string> {
  const period = DateUtil.MILLISECONDS_OF_ONE_DAY;
  const lastReportTime = await basePeriodReport(reportKey, period, [], Promise.resolve([count]));
  return lastReportTime;
}

/*************************** 大图页统计打点 *****************************/

async function photoBrowserStatisticReport(appearDiff: number, browserArr: number[]): Promise<void> {
  const reportKey = BigDataConstants.PHOTO_BROWSER_STATISTIC;
  const params: Params = {
    stayTime: appearDiff,
    viewCount: browserArr.reduce((p, c) => p + c),
    less1s: browserArr[0],
    less3s: browserArr[1],
    less5s: browserArr[2],
    less10s: browserArr[3],
    more10s: browserArr[4],
  };
  const period = DateUtil.MILLISECONDS_OF_ONE_DAY;
  await basePeriodReport(reportKey, period, params);
}

export class BrowserStatisticReportManager {
  constructor() {
  };

  public appearTimestamp = Number.NaN;
  public indexChangeTimestamp = Number.NaN;
  //  < 1s, 1s ~ 3s, 3s ~ 5s, 5s ~ 10s, 10s <
  public statisticReportArr = [0, 0, 0, 0, 0];

  public init(): void {
    const now = Date.now();
    this.appearTimestamp = now;
    this.indexChangeTimestamp = now;
  }

  public switch(): void {
    const now = Date.now();
    this.changeStatisticReportArr(now - this.indexChangeTimestamp);
    this.indexChangeTimestamp = now;
  }

  public end(): void {
    const now = Date.now();
    this.changeStatisticReportArr(now - this.indexChangeTimestamp);
    photoBrowserStatisticReport(now - this.appearTimestamp, this.statisticReportArr);
    this.appearTimestamp = Number.NaN;
    this.indexChangeTimestamp = Number.NaN;
  }

  private changeStatisticReportArr(diff: number): void {
    if (diff < 1000) {
      this.statisticReportArr[0]++;
    } else if (diff < 3000) {
      this.statisticReportArr[1]++;
    } else if (diff < 5000) {
      this.statisticReportArr[2]++;
    } else if (diff < 10000) {
      this.statisticReportArr[3]++;
    } else {
      this.statisticReportArr[4]++;
    }
  }
}
