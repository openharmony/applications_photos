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

import lazy data_rdb from '@ohos.data.relationalStore';
import lazy DatabaseHelper from './DatabaseUpdateHelper';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { dataSharePredicates, ValuesBucket } from '@kit.ArkData';
import lazy { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
import lazy { RemindersTable } from './databaseconstant/RemindersTable';
import lazy { ImageProxyDataTable } from './databaseconstant/ImageProxyDataTable';
import lazy { FaCardTable } from './databaseconstant/FaCardTable';
import lazy { FormConstants } from '@ohos/common/src/main/ets/default/model/common/FormConstants';
import lazy { DataStoreUtil } from '@ohos/common/src/main/ets/default/utils/DataStoreUtil';
import { TaskUri, Task } from './databaseconstant/TaskInfo';
import { FormControllerManager } from '../controller/FormControllerManager';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';

const TAG: string = 'DatabaseProxy';
const DATA_SHARE_PREFIX: string = 'datashare:///hmos_photodata';
const QUERY_START = '?';
const FACARD_PATH = 'facard';
const REMINDER_PATH = 'reminders';
const IMAGE_PATH = 'image_proxy_data';
const PORTRAIT_FORM_INFO_PATH = 'portrait_form_info';

/**
 * 图库数据库代理类, 执行数据库CRUD业务
 */
export default class DatabaseProxy {
  private static sInstance: DatabaseProxy;
  private rdbStore: data_rdb.RdbStore | undefined;
  private lastFormClearTime: number | undefined = undefined;
  private repeatClear: boolean = false;
  // 借助该单例的成员对象，保证更新ImageBound数据的动作同一周期内只执行一轮
  private updatingImageBound: boolean = false;

  constructor() {
  }

  public static getInstance(): DatabaseProxy {
    Log.info(TAG, 'getInstance');
    if (!DatabaseProxy.sInstance) {
      DatabaseProxy.sInstance = new DatabaseProxy();
    }
    return DatabaseProxy.sInstance;
  }

  public async disconnect() {
    await DatabaseHelper.getInstance().disconnect();
    this.rdbStore = undefined;
  }

  public async init(): Promise<boolean> {
    try {
      this.rdbStore = await DatabaseHelper.getInstance().getDb() as data_rdb.RdbStore;
    } catch (err) {
      Log.error(TAG, 'init err');
      return false;
    }
    Log.info(TAG, 'init end');
    return true;
  }

  public async insert(uri: string, value: ValuesBucket, callback: AsyncCallback<number>): Promise<number> {
    if (!this.rdbStore) {
      Log.info(TAG, 'init not finish');
      this.init();
      return -1;
    }
    const table = getTableByUri(uri);
    const formId = getFormId(uri);
    this.rdbStore.insert(table, value, (err, rowId) => {
      Log.info(TAG, `insert ${table} ${formId} before callback`);
      callback(err, rowId);
      if (!err) {
        Log.info(TAG, `insert ${table} ${formId} after callback: rowId = ` + rowId);
      } else {
        Log.warn(TAG, `insert ${table} ${formId} get err:${err?.code}, ${err?.message}`);
      }
    });
    return 0;
  }

  public async batchInsert(uri: string, values: ValuesBucket[], callback: AsyncCallback<number>) {
    if (!this.rdbStore) {
      Log.info(TAG, 'init not finish');
      this.init();
      return;
    }
    const table = getTableByUri(uri);
    this.rdbStore.batchInsert(table, values, (err, rowId) => {
      Log.info(TAG, `doBatchInsert ${table} before callback`);
      callback(err, rowId);
      if (!err) {
        Log.info(TAG, `doBatchInsert ${table} after callback: rowId = ` + rowId);
      } else {
        Log.warn(TAG, `doBatchInsert get err:${err?.code}, ${err?.message}`);
      }
    });
  }

  public async query(uri: string, predicates: dataSharePredicates.DataSharePredicates, columns: Array<string>,
    callback: AsyncCallback<data_rdb.ResultSet>) {
    if (!this.rdbStore) {
      Log.info(TAG, 'init not finish');
      this.init();
      return;
    }
    const table = getTableByUri(uri);
    Log.info(TAG, `query table: ${table}`);
    let queryInnerFun = (err: BusinessError, resultSet: data_rdb.ResultSet) => {
      Log.info(TAG, `query ${table} before callback`);
      callback(err, resultSet);
      if (err) {
        Log.warn(TAG, `query get err:${err?.code}, ${err?.message}`);
      }
    };
    try {
      this.rdbStore.query(table, predicates, columns, queryInnerFun);
    } catch (error) {
      Log.error(TAG, `query error: ${error?.code}, ${error?.message}`);
    }
  }

  public async queryWithOutCallback(uri: string, predicates: dataSharePredicates.DataSharePredicates,
    columns: Array<string>): Promise<data_rdb.ResultSet | undefined> {
    if (!this.rdbStore) {
      Log.info(TAG, 'init not finish');
      this.init();
      return undefined;
    }
    Log.info(TAG, `queryWithOutCallback uri: ${uri}`);
    const table = getTableByUri(uri);

    let resultSet: data_rdb.ResultSet | undefined = undefined;
    try {
      resultSet = await this.rdbStore.query(table, predicates, columns);
    } catch (error) {
      Log.error(TAG, `queryWithOutCallback error: ${error?.code}, ${error?.message}`);
    }
    return resultSet;
  }

  private async storeLastFormClearTime() {
    const now = Date.now();
    Log.info(TAG, `storeLastFormClearTime: ${now}`);
    this.lastFormClearTime = now;

    try {
      await DataStoreUtil.getInstance().putData('lastFormClearTime', now);
      await DataStoreUtil.getInstance().flush();
    } catch (err) {
      Log.error(TAG, 'preferences storeLastFormClearTime error. code = ' + err?.code + ', message = ' + err?.message);
    }
  }

  private async getLastFormClearTime() {
    if (this.lastFormClearTime) {
      Log.info(TAG, `lastFormClearTime has existed: ${this.lastFormClearTime}`);
      return;
    }

    try {
      const dataStoreUtil = DataStoreUtil.getInstance();
      let lastFormClearTime_: number | undefined = await dataStoreUtil.getData('lastFormClearTime', 0) as number;
      if (lastFormClearTime_) {
        this.lastFormClearTime = lastFormClearTime_;
        Log.info(TAG, `Preferences has lastFormClearTime: ${this.lastFormClearTime}`);
        return;
      }
    } catch (error) {
      Log.error(TAG, 'Failed to get lastFormClearTime code = ' + error?.code + ', message = ' + error?.message);
    }

    Log.info(TAG, `lastFormClearTime not existed: ${this.lastFormClearTime}`);
  }

  async processDeletedForms(): Promise<void> {
    Log.info(TAG, `processDeletedForms begin`);
    await DataStoreUtil.getInstance().init();
    let deletedFormIds: string[] = await DataStoreUtil.getInstance().getData(Constants.DELETED_FORM_IDS, []);
    Log.info(TAG, `processDeletedForms deletedFormIds = ${deletedFormIds}`);

    if (deletedFormIds.length) {
      const ftm = FormControllerManager.getInstanceV2();
      if (!ftm) {
        Log.info(TAG, `processDeletedForms getInstanceV2 failed, ftm is undefined`);
        return;
      }

      for (const formId of deletedFormIds) {
        await ftm.doTask({ formId: formId, taskUri: TaskUri.TASK_DELETE_FACARD_URI});
      }
      await DataStoreUtil.getInstance().putData(Constants.DELETED_FORM_IDS, []);
      await DataStoreUtil.getInstance().flush();
    }
    Log.info(TAG, `processDeletedForms end`);
  }

  public async clear() {
    if (!this.rdbStore) {
      Log.info(TAG, 'init not finish');
      this.init();
      return;
    }

    Log.info(TAG, `repeatClear = ${this.repeatClear}`);
    if (this.repeatClear) {
      return;
    }
    this.repeatClear = true;

    await this.processDeletedForms();
    await this.getLastFormClearTime();

    const now: number = Date.now();
    const needClear: boolean = !this.lastFormClearTime ||
      (now - this.lastFormClearTime > FormConstants.DELTA_CLEAR_TIME);
    Log.info(TAG, `needClear = ${needClear} now = ${now}, last = ${this.lastFormClearTime}`)
    if (!needClear) {
      this.repeatClear = false;
      return;
    }

    await this.storeLastFormClearTime();

    try {
      Log.info(TAG, `clear imageProxyData before`);
      await this.rdbStore.executeSql(FormConstants.SQL_CLEAR_REMINDERS);
      Log.info(TAG, `clear imageProxyData after`);

      Log.info(TAG, `clear reminders before`);
      await this.rdbStore.executeSql(FormConstants.SQL_CLEAR_IMAGE_PROXY_DATA);
      Log.info(TAG, `clear reminders after`);
      await this.rdbStore.executeSql(FormConstants.SQL_CLEAR_HIGHLIGHT_REMINDERS);
      Log.info(TAG, `clear highlight reminders after`);
      await this.rdbStore.executeSql(FormConstants.SQL_CLEAR_HIGHLIGHT_IMAGE_PROXY_DATA);
      Log.info(TAG, `clear highlight imageProxyData after`);
      await this.rdbStore.executeSql(FormConstants.SQL_CLEAR_PORTRAIT_FORM_INFO);
      Log.info(TAG, `clear portraitFormInfo after`);
    } catch (err) {
      Log.error(TAG, 'clear error. code = ' + err?.code + ', message = ' + err?.message);
    } finally {
      this.repeatClear = false;
    }
  }

  public async update(uri: string, predicates: dataSharePredicates.DataSharePredicates, values: ValuesBucket,
    callback: AsyncCallback<number>) {
    if (!this.rdbStore) {
      Log.info(TAG, 'init not finish');
      this.init();
      return;
    }
    const table = getTableByUri(uri);
    Log.info(TAG, `update ${uri}`);
    this.rdbStore.update(table, values, predicates, (err, count) => {
      Log.info(TAG, `update ${table} before callback`);
      callback(err, count);
      if (err) {
        Log.warn(TAG, `update get err:${err?.code}, ${err?.message}`);
      } else {
        Log.info(TAG, `update ${table} after callback`);
      }
    });
  }

  public async updateWithOutCallback(uri: string, predicates: dataSharePredicates.DataSharePredicates,
    values: ValuesBucket): Promise<number> {
    if (!this.rdbStore) {
      Log.info(TAG, 'init not finish');
      this.init();
      return 0;
    }
    Log.info(TAG, `updateWithOutCallback uri = ${uri}`);
    const table = getTableByUri(uri);
    let count: number = 0;
    try {
      count = await this.rdbStore.update(table, values, predicates);
    } catch (error) {
      Log.error(TAG, `updateWithOutCallback error: ${error?.code}, ${error?.message}`);
    }
    return count;
  }

  public async deleteWithOutCallback(uri: string,
    predicates: dataSharePredicates.DataSharePredicates): Promise<number> {
    if (!this.rdbStore) {
      Log.info(TAG, 'init not finish');
      this.init();
      return 0;
    }
    Log.info(TAG, `deleteWithOutCallback uri = ${uri}`);
    const table = getTableByUri(uri);
    let count: number = 0;
    try {
      count = await this.rdbStore.delete(table, predicates);
    } catch (error) {
      Log.error(TAG, `deleteWithOutCallback error: ${error?.code}, ${error?.message}`);
    }
    return count;
  }

  public async delete(
    uri: string,
    predicates: dataSharePredicates.DataSharePredicates,
    callback: AsyncCallback<number>
  ) {
    if (!this.rdbStore) {
      Log.info(TAG, 'init not finish');
      this.init();
      return;
    }
    const table = getTableByUri(uri);
    const formId = getFormId(uri);
    const deletedCount = this.rdbStore.delete(table, predicates, (err, count) => {
      Log.info(TAG, `delete ${table} ${formId} before callback count ${count}`);
      callback(err, count);
      if (err) {
        Log.warn(TAG, `delete ${table} ${formId} get err:${err?.code}, ${err?.message}`);
      }
    });
    Log.info(TAG, `delete ${table} ${formId} after deletedCount ${deletedCount}`);
  }

  public isUpdatingBound(): boolean {
    return this.updatingImageBound;
  }

  public setUpdatingBound(update: boolean) {
    this.updatingImageBound = update;
  }
}

export function getTableByUri(uri: string): string {
  Log.info(TAG, 'getTableByUri uri: ' + uri);
  let path = getPathByUri(uri);
  let tablePathName = getTablePathNameByPath(path);
  return getTableNameByTablePath(tablePathName);
}

/**
 * transfer the table's path to the specific table name
 *
 * @param table's path that is got from user input uri
 * @return the specific table name
 */
function getTableNameByTablePath(tablePathName: string): string {
  switch (tablePathName) {
    case FACARD_PATH:
      return FaCardTable.TABLE_NAME;
    case REMINDER_PATH:
      return RemindersTable.TABLE_NAME;
    case IMAGE_PATH:
      return ImageProxyDataTable.TABLE_NAME;
    default:
      Log.info(TAG, 'getTablePathByTableName run in default case!');
      return '';
  }
}

/**
 * transfer the user input uri to the specific resource path
 *
 * @param table's path that is got from user input uri
 * @return the resource path
 */
function getPathByUri(uri: string): string {
  if (uri.startsWith(DATA_SHARE_PREFIX)) {
    uri = uri.split(DATA_SHARE_PREFIX).join('');
  }

  let endIndex = uri.indexOf(QUERY_START);
  const totalLength = uri.length;
  if (endIndex === -1 && totalLength > 0) {
    return uri;
  }

  // in case of uri containing query condition like Instance's uri
  if (endIndex < 1 || endIndex >= totalLength) {
    return '';
  }
  const path = uri.substring(0, endIndex);
  if (path === null || path === undefined || path.length < 1) {
    return '';
  }
  return path;
}

/**
 * transfer uri without prefix to the table's path
 *
 * @param user input uri without prefix
 * @return the table path name
 */
function getTablePathNameByPath(path: string): string {
  const array = path.split('/');
  if (array === null || array === undefined || array.length < 1) {
    return '';
  }
  return array[1];
}

function getFormId(uri: string): string {
  return uri?.split(QUERY_START)[1] ?? '';
}