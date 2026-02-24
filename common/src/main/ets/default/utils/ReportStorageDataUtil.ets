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
import lazy { storageStatistics } from '@kit.CoreFileKit';
import lazy { hiSysEvent } from '@kit.PerformanceAnalysisKit';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { Constants } from '../model/common/Constants';
import lazy { DataStoreUtil } from './DataStoreUtil';

/* instrument ignore file */
const TAG: string = 'ReportStorageDataUtil';

const FILE_OR_FOLDER_PATH_LIST = [
  '/data/storage/el1/bundle',
  '/data/storage/el1/base',
  '/data/storage/el2/base',
  '/data/storage/el1/database',
  '/data/storage/el2/database'
];
const ONE_DAY = 24 * 60 * 60 * 1000;

/**
 * 存储空间健壮性打点
 */
export class ReportStorageDataUtil {
  public static async reportDataSize(): Promise<void> {
    let isTimeout = await ReportStorageDataUtil.isLastReportMoreThan24Hour();
    if (!isTimeout) {
      return;
    }
    Log.info(TAG, `start reportDataSize`);
    storageStatistics.getCurrentBundleStats().then((bundleStats: storageStatistics.BundleStats) => {
      let dataSizeArray: number[] = [0, 0, 0, 0, 0]; //目录占用大小和FILE_OR_FOLDER_PATH数组对应
      dataSizeArray[0] = bundleStats.appSize;
      dataSizeArray[4] = bundleStats.dataSize;

      let dataObj: Record<string, Object> = {};
      dataObj['COMPONENT_NAME'] = 'photo_override'; //应用部件名
      dataObj['PARTITION_NAME'] = '/data'; //固定传/data
      dataObj['FILE_OR_FOLDER_PATH'] = FILE_OR_FOLDER_PATH_LIST;
      dataObj['FILE_OR_FOLDER_SIZE'] = dataSizeArray;
      try {
        hiSysEvent.write({
          domain: 'FILEMANAGEMENT',
          name: 'USER_DATA_SIZE',
          eventType: hiSysEvent.EventType.STATISTIC,
          params: dataObj,
        }, (err: BusinessError) => {
          if (err) {
            Log.error(TAG, `ReportStorageDataUtil hiSysEvent report err ${err.code}`);
          } else {
            ReportStorageDataUtil.saveTimestamp();
            Log.info(TAG, `end reportDataSize`);
          }
        })
      } catch (error) {
        Log.error(TAG, `ReportStorageDataUtil hiSysEvent report err`);
      }
    }).catch((err: BusinessError) => {
      Log.error(TAG, `ReportStorageDataUtil getCurrentBundleStats err`);
    });
  }

  private static async saveTimestamp(): Promise<void> {
    // 应用自己实现，保存当前时间戳到本地preference
    try {
      let instance =  DataStoreUtil.getInstance();
      await instance.putData(Constants.LAST_REPORT_DATE, new Date().getTime());
      instance.flush();
    } catch (e) {
      Log.error(TAG, `ReportStorageDataUtil saveTimestamp error`)
    }
  }

  private static async isLastReportMoreThan24Hour(): Promise<boolean> {
    // 应用自己实现，可以根据上一次打点时间戳判断是否经过了24小时
    let lastReportDate: number = await DataStoreUtil.getInstance().getData(Constants.LAST_REPORT_DATE, 0);
    Log.info(TAG, `lastReportDate=${lastReportDate}`);
    let curDate = new Date().getTime();
    return curDate - lastReportDate > ONE_DAY;
  }
}