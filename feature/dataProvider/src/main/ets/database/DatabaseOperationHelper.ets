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

import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy DatabaseProxy from './DatabaseProxy';
import lazy data_rdb from '@ohos.data.relationalStore';
import lazy { dataSharePredicates, ValuesBucket } from '@kit.ArkData';
import lazy { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
import lazy { getFormId, isTaskUri, Task, TaskUri } from './databaseconstant/TaskInfo';
import lazy { FormControllerManager } from '../controller/FormControllerManager';

const RETRY_TIME_DELAY: number = 50;

const TAG: string = 'DatabaseOperationHelper';
const QUERY_START = '?';

/**
 * 数据库操作单例
 */
export default class DatabaseOperationHelper {
  private static sInstance: DatabaseOperationHelper;
  private isDatabaseInitializing: boolean = false;
  private isDatabaseInitComplete: boolean = false;
  private formControllerManager: FormControllerManager | undefined = undefined;

  private constructor() {
  }

  public static with(): DatabaseOperationHelper {
    if (!DatabaseOperationHelper.sInstance) {
      DatabaseOperationHelper.sInstance = new DatabaseOperationHelper();
    }
    return DatabaseOperationHelper.sInstance;
  }

  private async initDatabase() {
    try {
      this.isDatabaseInitComplete = await DatabaseProxy.getInstance().init();
      Log.info(TAG, `context: ${AppStorage.get<Context>('dataProviderContext') as Context}`);
      this.formControllerManager =
        FormControllerManager.getInstance(AppStorage.get<Context>('dataProviderContext') as Context);
    } finally {
      this.isDatabaseInitializing = false;
    }
  }

  public async disconnect() {
    await DatabaseProxy.getInstance().disconnect();
  }

  tryInitDatabase() {
    if (this.isDatabaseInitializing || this.isDatabaseInitComplete) {
      Log.info(TAG, `tryInitDatabase is initializing ${this.isDatabaseInitializing} or completed ${this.isDatabaseInitComplete}`);
      return;
    }
    this.isDatabaseInitializing = true;
    this.initDatabase();
  }

  private waitDbToRun(runnable: Function) {
    if (this.isDatabaseInitComplete) {
      runnable();
    } else {
      this.tryInitDatabase();
      setTimeout(() => {
        this.waitDbToRun(runnable);
      }, RETRY_TIME_DELAY);
    }
  }

  doInsert(uri: string, value: ValuesBucket, callback: AsyncCallback<number>,
    isForce: boolean = false) {
    this.waitDbToRun(() => {
      Log.info(TAG, '[insert] enter');
      try {
        const taskUri = getTaskUri(uri);
        Log.info(TAG, `[insert] uri: ${taskUri}`);
        if (isTaskUri(taskUri)) {
          const newTask: Task = {
            formId: getFormId(uri),
            taskUri: taskUri as TaskUri,
            values: value,
          }
          this.formControllerManager?.doTask(newTask);
          callback(undefined, -1);
          return;
        }
        DatabaseProxy.getInstance().insert(uri, value, (err: BusinessError, id: number) => {
          callback(err, id);
        });
      } catch (err) {
        Log.error(TAG, `err=${err?.message}`);
      }
      Log.info(TAG, '[insert] leave');
    });
  }

  doBatchInsert(uri: string, value: ValuesBucket[], callback: AsyncCallback<number>) {
    this.waitDbToRun(() => {
      Log.info(TAG, '[batch insert] enter');
      try {
        DatabaseProxy.getInstance().batchInsert(uri, value, (err: BusinessError, count: number) => {
          callback(err, count);
        });
      } catch (err) {
        Log.error(TAG, `err=${err?.message}`);
      }
      Log.info(TAG, '[batch insert] leave');
    });
  }

  doUpdate(uri: string, predicates: dataSharePredicates.DataSharePredicates, value: ValuesBucket,
    callback: AsyncCallback<number>) {
    this.waitDbToRun(() => {
      Log.info(TAG, '[update] enter');
      try {
        DatabaseProxy.getInstance().update(uri, predicates, value, (err: BusinessError, count: number) => {
          callback(err, count);
        });
      } catch (err) {
        Log.error(TAG, `err=${err?.message}`);
      }
    });
  }

  doQuery(uri: string, columns: Array<string>,
    predicates: dataSharePredicates.DataSharePredicates, callback: AsyncCallback<data_rdb.ResultSet>) {
    this.waitDbToRun(() => {
      Log.info(TAG, '[query] enter');
      try {
        DatabaseProxy.getInstance().query(uri, predicates, columns, (err: BusinessError, res: data_rdb.ResultSet) => {
          callback(err, res);
        });
      } catch (err) {
        Log.error(TAG, `err=${err?.message}`);
      }
      Log.info(TAG, '[query] leave');
    });
  }

  doDelete(uri: string, predicates: dataSharePredicates.DataSharePredicates, callback: AsyncCallback<number>) {
    this.waitDbToRun(() => {
      Log.info(TAG, '[delete] enter');
      try {
        DatabaseProxy.getInstance().delete(uri, predicates, (err: BusinessError, id: number) => {
          callback(err, id);
        });
      } catch (err) {
        Log.error(TAG, `err=${err?.message}`);
      }
      Log.info(TAG, '[delete] leave');
    });
  }
}

function getTaskUri(uri: string): string {
  return uri?.split(QUERY_START)[0] ?? '';
}