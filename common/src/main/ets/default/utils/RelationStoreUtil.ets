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

import lazy { relationalStore } from '@kit.ArkData';
import lazy { AlbumGridSortRule, SortRuleString } from '../model/AlbumGridSortHelper';
import lazy { Log } from './Log';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { collections } from '@kit.ArkTS';
import lazy { common, contextConstant } from '@kit.AbilityKit';
import lazy { RdbHelper } from './RdbHelper';

const TAG: string = 'common_RelationStoreUtil';
const ALBUM_DB_NAME: string = 'album.db';
const ALBUM_GRID_SORT_TABLE: string = 'tbl_album_grid_sort';
const STORE_CONFIG: relationalStore.StoreConfig = {
  name: ALBUM_DB_NAME,
  securityLevel: relationalStore.SecurityLevel.S1,
};
const CREATE_ALBUM_GRID_SORT_TABLE: string = `CREATE TABLE IF NOT EXISTS ${ALBUM_GRID_SORT_TABLE} (
                          idx INTEGER PRIMARY KEY AUTOINCREMENT,
                          ALBUM_ID TEXT,
                          SORT_RULE TEXT,
                          SORT_TYPE TEXT
                          )`

export class RelationStoreUtil {
  private static instance: RelationStoreUtil;
  // 操作数据库的管理对象
  private store: relationalStore.RdbStore | undefined = undefined;

  public static getInstance(): RelationStoreUtil {
    if (!RelationStoreUtil.instance) {
      RelationStoreUtil.instance = new RelationStoreUtil();
    }
    return RelationStoreUtil.instance;
  }

  public async disconnect(): Promise<void> {
    try {
      await this.store?.close();
    } catch (error) {
      Log.error(TAG, `disconnect close rdbStore error ${error?.message}`)
    }
    this.store = undefined;
    Log.info(TAG, 'disconnect done');
  }

  /**
   * 初始化rdb实例
   * @returns
   */
  private async getRdbStore(): Promise<relationalStore.RdbStore | undefined> {
    if (!this.store) {
      try {
        const context: Context = getContext(this) || global.uiAbilityContext();
        this.store = await relationalStore.getRdbStore(
          context.createAreaModeContext(contextConstant.AreaMode.EL1), STORE_CONFIG);
        /* instrument ignore next */
      } catch (e) {
        Log.error(TAG, `getRdbStore error ${e?.code}, msg: ${e?.message}`);
      }
    }
    return this.store;
  }

  /**
   * 初始化rdb实例 --克隆
   * @returns
   */
  private async getRdbStoreEx(context: Context): Promise<relationalStore.RdbStore | undefined> {
    if (!this.store) {
      try {
        this.store = await relationalStore.getRdbStore(
          context.createAreaModeContext(contextConstant.AreaMode.EL1), STORE_CONFIG);
        /* instrument ignore next */
      } catch (e) {
        Log.error(TAG, `getRdbStore error ${e?.code}, msg: ${e?.message}`);
      }
    }
    return this.store;
  }

  /**
   * 获取所有相册的宫格排序规则列表，并存入到map里
   * @param sortRuleMap 排序规则map缓存
   * @returns
   */
  public async queryAllSortRuleFromDb(context: Context | undefined,
    sortRuleMap: collections.Map<string, SortRuleString>): Promise<void> {
    const rdbStore = await RdbHelper.getRdb(
      context?.createAreaModeContext(contextConstant.AreaMode.EL1), STORE_CONFIG);
    /* instrument ignore if */
    if (!rdbStore) {
      Log.error(TAG, `queryAllSortRuleFromDb rdbStore is undefined`);
      return;
    }

    sortRuleMap.clear();
    try {
      // 查询所有行和列
      Log.info(TAG, `queryAllSortRuleFromDb querySql start`);
      const startTime: number = Date.now();
      let resultSet = await rdbStore.querySql(`SELECT * FROM ${ALBUM_GRID_SORT_TABLE}`, []);
      Log.info(TAG, `queryAllSortRuleFromDb timeCost: ${Date.now() - startTime}ms`);
      Log.info(TAG, `ResultSet column names: ${resultSet.columnNames}, row count: ${resultSet.rowCount}`);
      // 遍历查询结果
      /* instrument ignore next */
      while (resultSet.goToNextRow()) {
        const albumId = resultSet.getString(resultSet.getColumnIndex('ALBUM_ID'));
        const sortRule = resultSet.getString(resultSet.getColumnIndex('SORT_RULE'));
        const sortType = resultSet.getString(resultSet.getColumnIndex('SORT_TYPE'));
        Log.info(TAG, `rowIndex=${resultSet.rowIndex}, albumId=${albumId}, sortRule=${sortRule}, sortType=${sortType}`);
        sortRuleMap?.set(albumId, new SortRuleString(sortRule, sortType));
      }
      resultSet.close();
      // 释放数据集的内存，若不释放可能会引起fd泄露与内存泄露
    } catch (e) {
      Log.error(TAG, `Query failed, code is ${e.code}, message is ${e.message}`);
    }
  }

  /**
   * 获取指定相册的宫格排序规则
   * @param albumUri 相册id
   * @returns
   */
  /* instrument ignore next */
  public async getSortRuleFromDb(albumUri: string): Promise<[AlbumGridSortRule, string]> {
    const rdbStore = await this.getRdbStore();
    if (!rdbStore) {
      Log.error(TAG, `getSortRuleFromDb rdbStore undefined`);
      return [AlbumGridSortRule.CREATE_TIME, 'DESC'];
    }
    try {
      let resultSet =
        await rdbStore.querySql(`SELECT * FROM ${ALBUM_GRID_SORT_TABLE} WHERE ALBUM_ID = '${albumUri}'`,
          []);
      Log.info(TAG, `ResultSet column names: ${resultSet.columnNames}, column count: ${resultSet.columnCount}`);
      resultSet.goToFirstRow();
      const albumId = resultSet.getString(resultSet.getColumnIndex('ALBUM_ID'));
      const sortRule = resultSet.getString(resultSet.getColumnIndex('SORT_RULE'));
      const sortType = resultSet.getString(resultSet.getColumnIndex('SORT_TYPE'));
      Log.info(TAG, `albumId=${albumId}, sortRule=${sortRule}, sortType=${sortType}`);
      resultSet.close();
      return [sortRule, sortType];
      // 释放数据集的内存，若不释放可能会引起fd泄露与内存泄露
    } catch (e) {
      Log.error(TAG, `Query failed, code is ${e.code},message is ${e.message}`);
      return [AlbumGridSortRule.CREATE_TIME, 'DESC'];
    }
  }

  /**
   * 插入单条相册宫格排序规则
   * @param albumUri 相册id
   * @param rule 排序规则
   * @returns
   */
  /* instrument ignore next */
  public async insertSortRule(albumUri: string, rule: string, sortType: string): Promise<void> {
    Log.info(TAG, `insertSortRule ${albumUri}, rule: ${rule}`);
    try {
      const valueBucket: relationalStore.ValuesBucket = {
        'ALBUM_ID': albumUri,
        'SORT_RULE': rule,
        'SORT_TYPE': sortType
      };
      const rdbStore = await this.getRdbStore();
      if (!rdbStore) {
        Log.error(TAG, `insertSortRule rdbStore undefined`);
        return;
      }
      // 开始事务
      rdbStore.beginTransaction();
      // 创建数据库表
      await rdbStore.executeSql(CREATE_ALBUM_GRID_SORT_TABLE);
      // 查询是否已有记录
      let predicates = new relationalStore.RdbPredicates(ALBUM_GRID_SORT_TABLE);
      predicates.equalTo('ALBUM_ID', albumUri);
      let resultSet = await rdbStore.query(predicates);
      if (resultSet.goToNextRow()) {
        // 查询到记录，直接更新
        Log.info(TAG, `albumId exist, update`);
        await rdbStore.update(valueBucket, predicates);
      } else {
        // 无此记录，需要新插入
        Log.info(TAG, `albumId not exist, insert`);
        await rdbStore.insert(ALBUM_GRID_SORT_TABLE, valueBucket,
          relationalStore.ConflictResolution.ON_CONFLICT_NONE);
      }
      // 结束事务
      rdbStore.commit();
      Log.info(TAG, `insertSortRule ${albumUri} successfully`);
      resultSet.close();
    } catch (e) {
      Log.error(TAG, `insertSortRule error: ${e.code}, msg: ${e.message}`);
    }
  }

  /**
   * 插入单条相册宫格排序规则
   * @param albumUri 相册id
   * @param rule 排序规则
   * @returns
   */
  /* instrument ignore next */
  public async insertSortRuleEx(context: Context, albumUri: string, rule: string, sortType: string): Promise<void> {
    Log.info(TAG, `insertSortRule ${albumUri}, rule: ${rule}`);
    try {
      const valueBucket: relationalStore.ValuesBucket = {
        'ALBUM_ID': albumUri,
        'SORT_RULE': rule,
        'SORT_TYPE': sortType
      };
      const rdbStore = await this.getRdbStoreEx(context);
      if (!rdbStore) {
        Log.error(TAG, `insertSortRule rdbStore undefined`);
        return;
      }
      // 开始事务
      rdbStore.beginTransaction();
      // 创建数据库表
      await rdbStore.executeSql(CREATE_ALBUM_GRID_SORT_TABLE);
      // 查询是否已有记录
      let predicates = new relationalStore.RdbPredicates(ALBUM_GRID_SORT_TABLE);
      predicates.equalTo('ALBUM_ID', albumUri);
      let resultSet = await rdbStore.query(predicates);

      if (resultSet.goToNextRow()) {
        // 查询到记录，直接更新
        Log.info(TAG, `albumId exist, update`);
        await rdbStore.update(valueBucket, predicates);
      } else {
        // 无此记录，需要新插入
        Log.info(TAG, `albumId not exist, insert`);
        await rdbStore.insert(ALBUM_GRID_SORT_TABLE, valueBucket,
          relationalStore.ConflictResolution.ON_CONFLICT_NONE);
      }
      // 结束事务
      rdbStore.commit();
      resultSet.close();
      Log.info(TAG, `insertSortRule ${albumUri} successfully`);
    } catch (e) {
      Log.error(TAG, `insertSortRule error: ${e.code}, msg: ${e.message}`);
    }
  }

  public reset(): void {
    this.store = undefined;
  }
}
