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

import lazy SettingsExtension from '@ohos/extensions/src/main/ets/default/SettingsExtension';
import lazy { dataSharePredicates, ValuesBucket } from '@kit.ArkData';
import lazy Want from '@ohos.app.ability.Want';
import lazy relationalStore from '@ohos.data.relationalStore';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { AsyncCallback } from '@kit.BasicServicesKit';
import lazy { SettingCardAccess } from './SettingCardAccess';
import lazy { common } from '@kit.AbilityKit';
import lazy uri from '@ohos.uri';

/* instrument ignore file */
/**
 *  设置中推荐删除卡片数据库
 */
/* instrument ignore file */
const TAG: string = 'SettingCardDataShareAbility';
const NUM_ONE = 1;

export default class SettingCardDataShareAbility extends SettingsExtension {
  private rdbStorePromise?: Promise<relationalStore.RdbStore>;
  private readonly TABLE_NAME: string = 'RecommendClearingCard';
  private readonly ASSETS_INFO_TABLE: string = 'AssetsInfo';

  onCreate(want: Want, callback: Function) {
    Log.info(TAG, ' onCreate')
  }

  /**
   * 插入卡片信息
   *
   * @param selectedItem 插入对象
   * @param cardInfo 卡片信息
   * @param callback callback回调
   */
  async insert(uriString: string, selectedItem: ValuesBucket, callback: Function): Promise<void> {
    if (!callback) {
      return;
    }
    Log.info(TAG, `insert uri : ${uriString}`);
    // uri 保护：
    let requestType = uriString?.slice(uriString?.lastIndexOf('.') + NUM_ONE);
    if (selectedItem === null || selectedItem === undefined) {
      Log.info(TAG, 'insert invalid selectedItems or tableName is null')
      return
    }
    switch (requestType) {
      case 'insertCardInfo':
        await this.insertTable(this.TABLE_NAME, selectedItem, callback);
        break;
      case 'insertAssetsInfo':
        await this.insertTable(this.ASSETS_INFO_TABLE, selectedItem, callback);
        break;
      default:
        Log.info(TAG, 'insert finish');
        break;
    }
  }

  private async insertTable(tableName: string, selectedItem: ValuesBucket, callback: Function) {
    const rdbStore = await this.getRdbStore();
    await this.checkIsExistAndCreateTab(rdbStore, tableName);
    try {
      rdbStore.insert(tableName, selectedItem, (error, ret) => {
        Log.info(TAG, 'insertTable success insert');
        callback(error, ret);
      });
    } catch (error) {
      Log.error(TAG, ` insertTable error`);
    }
    rdbStore.commit();
  }

  private getCreateTableSql(tableName: string): string {
    let sqlCreate: string = '';
    switch (tableName) {
      case this.TABLE_NAME:
        sqlCreate = `CREATE TABLE IF NOT EXISTS ${this.TABLE_NAME} (
                          cardName TEXT NOT NULL DEFAULT 'RecommendClearingCard',
                          needShow TEXT DEFAULT 'false',
                          cardInfo TEXT
                          )`
        break;
      case this.ASSETS_INFO_TABLE:
        sqlCreate = `CREATE TABLE IF NOT EXISTS ${this.ASSETS_INFO_TABLE} (
                          cardName TEXT NOT NULL DEFAULT 'AssetsInfo',
                          localVideoSize TEXT DEFAULT '0 KB',
                          localImageSize TEXT DEFAULT '0 KB'
                          )`
        break;
      default:
        break
    }
    return sqlCreate;
  }

  /**
   * 删除卡片信息
   *
   * @param predicates 数据库对象
   * @param uriString uri信息
   * @param callback callback回调
   */
  async delete(uriString: string, predicates: dataSharePredicates.DataSharePredicates,
    callback: Function): Promise<void> {
    if (!callback) {
      return;
    }
    // uri 保护：
    let requestType = uriString?.slice(uriString?.lastIndexOf('.') + 1);
    switch (requestType) {
      case 'deleteCardInfo':
        Log.info(TAG, 'delete');
        predicates.isNotNull('needShow');
        await this.deleteTable(this.TABLE_NAME, predicates, callback);
        break;
      case 'deleteAssetsInfo':
        predicates.isNotNull('cardName');
        await this.deleteTable(this.ASSETS_INFO_TABLE, predicates, callback);
        break;
      default:
        Log.info(TAG, 'delete finish');
        break;
    }
  }

  private async deleteTable(tableName: string, predicates: dataSharePredicates.DataSharePredicates,
    callback: Function) {
    const rdbStore = await this.getRdbStore();
    await this.checkIsExistAndCreateTab(rdbStore, tableName);
    try {
      rdbStore.delete(tableName, predicates, (error, ret) => {
        Log.info(TAG, `deleteTable ret: ${ret}`);
        callback(error, ret);
      });
    } catch (error) {
      Log.error(TAG, `deleteTable error`);
    }
    rdbStore.commit();
  }

  /**
   * 查询卡片信息
   *
   * @param uriString uri
   * @param predicates 数据库
   * @param columns 列
   * @param callback callback回调
   */
  async query(uriString: string, predicates: dataSharePredicates.DataSharePredicates, columns: Array<string>,
    callback: Function): Promise<void> {
    if (!callback) {
      return;
    }
    let requestType = uriString?.slice(uriString?.lastIndexOf('.') + 1);
    let queryScene = new uri.URI(uriString).getQueryValue('queryScene');
    requestType = queryScene !== null ? queryScene : requestType;
    Log.info(TAG, `query requestType: ${requestType}`);
    const rdbStore = await this.getRdbStore();
    switch (requestType) {
      case 'queryCardInfo':
        await this.queryTable(this.TABLE_NAME, rdbStore, callback);
        break;
      case 'card':
        SettingCardAccess.getInstance().fetchSettingCardInfo(predicates, callback, this.context);
        Log.info(TAG, 'fetch Card Info');
        break;
      case 'queryLocalVideoSize':
      case 'queryLocalImageSize':
        await this.queryTable(this.ASSETS_INFO_TABLE, rdbStore, callback);
        break;
      case 'queryVideoSize':
      case 'queryImageSize':
        SettingCardAccess.getInstance().fetchAssetsInfo(requestType, predicates, callback, this.context);
        Log.info(TAG, 'fetchAssetsInfo fetchAssetsInfo finished!');
        break;
      default:
        Log.info(TAG, 'query finish');
        break;
    }
  }

  private async queryTable(tableName: string, rdbStore: relationalStore.RdbStore, callback: Function): Promise<void> {
    try {
      await this.checkIsExistAndCreateTab(rdbStore, tableName);
      rdbStore.querySql(
        `SELECT * FROM ${tableName} ;`,
        [],
        (error, resultSet) => {
          if (resultSet !== undefined) {
            Log.info(TAG, `queryTable resultSet.rowCount: ${JSON.stringify(resultSet.rowCount)}`);
          }
          callback(error, resultSet);
        });
    } catch (error) {
      Log.error(TAG, `queryTable error`);
    }
  }

  /**
   * update 更新数据库
   *
   * @param uriString uri
   * @param predicates 数据库对象
   * @param valueBucket 插入对象
   * @param callback callback回调
   */
  async update(uriString: string, predicates: dataSharePredicates.DataSharePredicates, valueBucket: ValuesBucket,
    callback: AsyncCallback<number, void>): Promise<void> {
    let requestType = uriString?.slice(uriString?.lastIndexOf('.') + 1);
    switch (requestType) {
      case 'updateCardInfo':
        await this.updateTable(this.TABLE_NAME, valueBucket, predicates, callback);
        break;
      case 'updateAssetsInfo':
        await this.updateTable(this.ASSETS_INFO_TABLE, valueBucket, predicates, callback);
      default:
        Log.info(TAG, 'update finish');
        break;
    }
  }

  private async updateTable(tableName: string, valueBucket: ValuesBucket,
    predicates: dataSharePredicates.DataSharePredicates, callback: AsyncCallback<number, void>) {
    const rdbStore = await this.getRdbStore();
    try {
      rdbStore.update(tableName, valueBucket, predicates, callback);
    } catch (error) {
      Log.error(TAG, `updateTable error`)
    }
    rdbStore.commit();
  }

  public async queryTableContent(tableName: string, predicates: dataSharePredicates.DataSharePredicates,
    callback: Function): Promise<void> {
    const rdbStore = await this.getRdbStore();
    rdbStore.query(tableName, predicates, (error, resultSet) => {
      Log.info(TAG, `query ret: ${resultSet}`)
      if (resultSet !== undefined) {
        Log.info(TAG, `query resultSet.rowCount: ${JSON.stringify(resultSet.rowCount)}`)
      }
      if (!callback) {
        return;
      }
      callback(error, resultSet);
    });
  }

  private async checkIsExistAndCreateTab(rdbStore: relationalStore.RdbStore, tableName: string): Promise<void> {
    if (rdbStore == undefined || rdbStore == null || tableName == '') {
      return;
    }
    try {
      rdbStore.beginTransaction();
      let sqlCreate: string = this.getCreateTableSql(tableName);
      // 执行创建表的语句 execute 执行
      if (sqlCreate !== '') {
        await rdbStore.executeSql(sqlCreate);
        rdbStore.commit();
        Log.info(TAG, 'checkIsExistAndCreateTab : create dataBase success!');
      } else {
        Log.info(TAG, 'checkIsExistAndCreateTab : create fail because sqlCreate is null');
      }
    } catch (err) {
      Log.error(TAG, `checkIsExistAndCreateTab`);
    }
  }

  private getRdbStore(): Promise<relationalStore.RdbStore> {
    if (this.rdbStorePromise) {
      return this.rdbStorePromise;
    }
    let context: common.AbilityStageContext | undefined =
      AppStorage.get<common.AbilityStageContext>('photosGlobalContext');
    try {
      this.rdbStorePromise = relationalStore.getRdbStore(context, {
        name: 'share.db', // 数据库文件名
        securityLevel: relationalStore.SecurityLevel.S1, // 数据库安全级别
      });
      return this.rdbStorePromise;
    } catch (error) {
      Log.error(TAG, `getRdbStore error`)
      throw error as Error;
    }
  }
}