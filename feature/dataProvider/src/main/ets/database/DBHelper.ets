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
import lazy dataShare from '@ohos.data.dataShare';
import lazy { dataSharePredicates, DataShareResultSet, ValuesBucket } from '@kit.ArkData';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG: string = 'DBHelper';

export default class DBHelper {
  private static sInstance: DBHelper;
  /**
   * isHasInit
   */
  protected mIsHasInit: boolean = false;
  /**
   * isInitting
   */
  protected isInitializing: boolean = false;
  private dsHelper: dataShare.DataShareHelper | null = null;
  private readonly dseUri: string = 'datashare:///hmos_photodata';

  private constructor(context: Context) {
    this.init(context);
  }

  public static getInstance(context: Context): DBHelper {
    if (!DBHelper.sInstance) {
      DBHelper.sInstance = new DBHelper(context);
    }
    return DBHelper.sInstance;
  }


  async init(context: Context): Promise<boolean> {
    this.beforeInit();
    const initResult: boolean = await this.doInit(context);
    Log.info(TAG, `DBHelper initResult: ${initResult}`)
    this.afterInit(initResult);
    return initResult;
  }

  async close(context: Context): Promise<void> {
    await this.dsHelper?.close();
  }

  private beforeInit() {
    this.isInitializing = true;
  }

  private afterInit(initResult: boolean) {
    this.isInitializing = false;
    this.mIsHasInit = initResult;
  }

  async doInit(context: Context): Promise<boolean> {
    this.dsHelper = await this.initDsHelper(context);
    return this.dsHelper ? true : false;
  };

  private async initDsHelper(context: Context): Promise<dataShare.DataShareHelper | null> {
    Log.info(TAG, `initDsHelper`);
    if (this.dsHelper) {
      return this.dsHelper;
    }
    if (!context) {
      Log.info(TAG, `initDsHelper context empty`);
      return this.dsHelper;
    }
    try {
      this.dsHelper = await dataShare.createDataShareHelper(context, this.dseUri);
    } catch (err) {
      Log.error(TAG, `initDsHelper error msg is ${JSON.stringify(err)}`);
    }
    Log.info(TAG, 'initDsHelper dshelper is ' + this.dsHelper);
    return this.dsHelper;
  }

  private async checkInit(context?: Context): Promise<boolean> {
    if (!this.dsHelper || !this.mIsHasInit) {
      if (context) {
        await this.init(context);
        return this.mIsHasInit;
      } else {
        return false;
      }
    }
    return true;
  }

  public async doBatchInsert(uri: string, values: ValuesBucket[], context?: Context): Promise<number | undefined> {
    try {
      const isInit: boolean = await this.checkInit(context);
      if (!isInit) {
        Log.info(TAG, `doBatchInsert isInit false`);
        return undefined;
      }
      const insertNO = await this.dsHelper?.batchInsert(uri, values);
      return insertNO;
    } catch (error) {
      Log.error(TAG, `doBatchInsert error: ${JSON.stringify(error)}`);
      return undefined;
    }
  }

  public async doInsert(uri: string, value: ValuesBucket, context?: Context): Promise<number | undefined> {
    try {
      const isInit: boolean = await this.checkInit(context);
      if (!isInit) {
        Log.info(TAG, `doInsert isInit false`);
        return undefined;
      }
      const insertNO = await this.dsHelper?.insert(uri, value);
      return insertNO;
    } catch (error) {
      Log.error(TAG, `doInsert error: ${JSON.stringify(error)}`);
      return undefined;
    }
  }

  public async doUpdate(uri: string, predicates: dataSharePredicates.DataSharePredicates, value: ValuesBucket,
    context?: Context): Promise<number | undefined> {
    try {
      const isInit: boolean = await this.checkInit(context);
      if (!isInit) {
        Log.info(TAG, `doUpdate isInit false`);
        return undefined;
      }
      const updatedN0 = await this.dsHelper?.update(uri, predicates, value);
      return updatedN0;
    } catch (error) {
      Log.error(TAG, `doUpdate error: ${JSON.stringify(error)}`);
      return undefined;
    }
  }

  public async doQuery(uri: string, predicates: dataSharePredicates.DataSharePredicates, columns: Array<string>,
    context?: Context): Promise<DataShareResultSet | undefined> {
    try {
      const isInit: boolean = await this.checkInit(context);
      if (!isInit) {
        Log.info(TAG, `doQuery isInit false`);
        return undefined;
      }
      const queryData = await this.dsHelper?.query(uri, predicates, columns);
      return queryData;
    } catch (error) {
      Log.error(TAG, `doQuery error: ${JSON.stringify(error)}`);
      return undefined;
    }
  }

  public async doDelete(uri: string, predicates: dataSharePredicates.DataSharePredicates,
    context?: Context): Promise<number | undefined> {
    try {
      const isInit: boolean = await this.checkInit(context);
      if (!isInit) {
        Log.info(TAG, `doDelete isInit false`);
        return undefined;
      }
      const deleteNO = await this.dsHelper?.delete(uri, predicates);
      return deleteNO;
    } catch (error) {
      Log.error(TAG, `doDelete error: ${JSON.stringify(error)}`);
      return undefined;
    }
  }
}
