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
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { TraceControllerUtils } from './TraceControllerUtils';
import lazy { DataStoreUtil } from './DataStoreUtil';
import lazy { Log } from './Log';
import lazy { ReportToBigDataUtil } from './ReportToBigDataUtil';
import lazy { Obj } from '@ohos/tools/tsIgnore/standardLibrary/Obj.e';

const TAG = 'StatisticReportUtil';

export interface Params {
  stayTime: number,
  viewCount: number,
  less1s: number,
  less3s: number,
  less5s: number,
  less10s: number,
  more10s: number,
}

export interface TmpKVPairs {
  openPhotoAlbumCount: photoAccessHelper.AlbumSubtype;
  openVideoAlbumCount: photoAccessHelper.AlbumSubtype;
  openFavorAlbumCount: photoAccessHelper.AlbumSubtype;
}

/**
 * @param reportKey
 * @param period
 * @param imposeMsg
 * @param asyncMsg
 * @returns
 *
 * 周期打点数据类型:
 * 1. 叠加后打印. 如果打点周期未到, 则叠加至本地; 如果打点周期已到, 则叠加后打印, 并将本地清零
 * 2. 异步获取后直接打印. 如果打点周期未到, 则不获取
 *
 * 返回上次打点时间，让调用方自行判断，不至于短时间高频调用文件访问
 */
export async function basePeriodReport(
  reportKey: string,
  period: number,
  imposeMsg: Params | [] | TmpKVPairs = [],
  asyncMsg: Promise<object> = Promise.resolve([])
): Promise<string> {
  const traceKey = `statisticReport_${reportKey}`;
  TraceControllerUtils.startTrace(traceKey);
  const dataStore = DataStoreUtil.getInstance();
  await dataStore.init();

  const keys = Object.keys(imposeMsg);
  const values = Object.values(imposeMsg) as number[];
  const storeKeys = keys.map((x) => reportKey + x);
  const reportTime = new Date().toISOString();
  const lastTimeKey = `${reportKey}_time`;
  let lastReportTime = (await dataStore.getData(lastTimeKey, '')) as string;
  const oldValues = (await Promise.all(storeKeys.map((x) => dataStore.getData(x, 0)))) as number[];

  if (lastReportTime === '' || new Date(reportTime).getTime() - new Date(lastReportTime).getTime() >= period) {
    const msg = await asyncMsg;
    const imposeObj: object = Obj.reduce(keys, values, oldValues);

    interface EventMsg {
      msg: object;
      lastReportTime: string;
      reportTime: string;
    }

    const eventMsg: EventMsg = {
      msg: msg,
      lastReportTime,
      reportTime
    };
    let finalMsg = Obj.assign({}, eventMsg, imposeObj);
    Log.info(TAG, `${reportKey} eventMsg: ` + JSON.stringify(finalMsg));
    ReportToBigDataUtil.statisticReport(reportKey, finalMsg);

    await Promise.all([...storeKeys.map((x) => dataStore.putData(x, 0)), dataStore.putData(lastTimeKey, reportTime)]);
    lastReportTime = reportTime;
  } else {
    await Promise.all(storeKeys.map((x, i) => dataStore.putData(x, values[i] + oldValues[i])));
  }
  await dataStore.flush();
  TraceControllerUtils.finishTrace(traceKey);
  return lastReportTime;
}