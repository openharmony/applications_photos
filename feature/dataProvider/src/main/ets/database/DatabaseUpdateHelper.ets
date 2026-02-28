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

import lazy ohosDataRdb from '@ohos.data.relationalStore';
import lazy data_rdb from '@ohos.data.relationalStore';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { DataStoreUtil } from '@ohos/common/src/main/ets/default/utils/DataStoreUtil';
import lazy { common, contextConstant } from '@kit.AbilityKit';
import lazy { FaCardTable } from './databaseconstant/FaCardTable';
import lazy { RemindersTable } from './databaseconstant/RemindersTable';
import lazy { ImageProxyDataTable } from './databaseconstant/ImageProxyDataTable';
import lazy { dataSharePredicates, relationalStore, ValuesBucket } from '@kit.ArkData';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { HashSet } from '@kit.ArkTS';
import lazy { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';

const TAG: string = 'DatabaseHelper';

const OLD_DB_NAME: string = 'photosData.db';

const oldConfig: ohosDataRdb.StoreConfig = {
  name: OLD_DB_NAME,
  securityLevel: ohosDataRdb.SecurityLevel.S1,
  isSearchable: true,
  autoCleanDirtyData: false
};

const DB_NAME: string = 'El2PhotosData.db';

const config: ohosDataRdb.StoreConfig = {
  name: DB_NAME,
  securityLevel: ohosDataRdb.SecurityLevel.S1,
  isSearchable: true,
  autoCleanDirtyData: false // 需要配置为false，才能使用增量同步接口感知到云端删除的日程
};

const DEFAULT_DATABASE_VERSION: number = -1;

const NOT_FOUND: number = -1;
/**
 * 最新数据库版本，更新数据库时需要更新此字段
 */
const DB_LATEST_VERSION: number = 15;

const DB_MIGRATE_VERSION: number = 9;

const DB_REFRESH_VERSION: number = 11;

const DB_UPDATE_HIGHLIGHT_VERSION: number = 12;

enum DbVersion {
  ADD_LIGHT_GLIMPSE_TABLE = 13,
  ADD_PORTRAIT_TABLE = 14,
  UPDATE_FA_CARD_TABLE_FOR_IS_SHOW_ALBUM_NAME = 15,
};

/**
 * 默认版本号
 */
const DB_BASE_VERSION: number = 8;

const DATABASE_VERSION_KEY: string = 'database_version';

const CORRUPTED = 14800011;
/**
 * 数据库管理者,负责数据库初始化、数据库升级、数据库版本管理
 */
export default class DatabaseHelper {
  protected rdbStore: ohosDataRdb.RdbStore | null = null;
  //是否已经初始化成功
  protected isInisSuccess: boolean = false;
  //数据库名称
  protected dbName: string = '';
  private isInitializing: boolean = false;
  //异步等待初始化的Resolve,初始化完毕后,通知唤醒
  private waitInitOverResolves: Function[] = [];
  private config: ohosDataRdb.StoreConfig;
  private static instance: DatabaseHelper;
  private faCardBuckets: ValuesBucket[] = [];

  constructor(config: ohosDataRdb.StoreConfig) {
    this.config = config;
    this.dbName = config.name;
    this.initParas();
  }

  protected initParas() {
  }

  /**
   * get the instance of CalendarDataHelper class
   */
  public static getInstance(): DatabaseHelper {
    if (!DatabaseHelper.instance) {
      DatabaseHelper.instance = new DatabaseHelper(config);
    }
    return DatabaseHelper.instance;
  }

  public async disconnect(): Promise<void> {
    try {
      await this.rdbStore?.close();
    } catch (error) {
      Log.error(TAG, `disconnect close rdbStore error ${error?.message}`)
    }
    this.rdbStore = null;
    this.isInisSuccess = false;
    this.isInitializing = false;
    this.faCardBuckets = [];
    Log.info(TAG, 'disconnect done');
  }

  /**
   * 取消所有form的监听
   *
   * @returns
   */
  public async unregisterAllForm(): Promise<void> {
    try {
      if (!this.rdbStore) {
        Log.error(TAG, 'unregisterAllForm rdbStore is null!');
        return;
      }
      let formIdSet: HashSet<string> = new HashSet();
      await this.queryAllFormIds(formIdSet);
      Log.info(TAG, `unregisterAllForm, formIdSet len: ${formIdSet.length}`);
      let baseContext: common.AbilityStageContext | undefined =
        AppStorage.get<common.AbilityStageContext>('photosGlobalContext');
      if (!baseContext) {
        Log.error(TAG, 'unregisterAllForm baseContext is null!');
        return;
      }
      UserFileManagerAccess.getInstance().onCreate(baseContext);
      let photoAccessHelper: photoAccessHelper.PhotoAccessHelper =
        UserFileManagerAccess.getInstance().getMediaLibrary();
      if (!photoAccessHelper) {
        Log.error(TAG, 'unregisterAllForm photoAccessHelper is null!');
        return;
      }
      for (let formId of formIdSet) {
        Log.info(TAG, `unregisterAllForm removeGalleryFormInfo ${formId}`);
        await photoAccessHelper.removeGalleryFormInfo({
          formId: formId,
          assetUris: [],
        });
      }
    } catch (err) {
      Log.error(TAG, `unregisterAllForm failed, error message: ${err?.code}, ${err?.msg}`);
    }
  }

  /**
   * Obtains the database version number in the cache
   * @returns database version
   */
  async getDb(): Promise<ohosDataRdb.RdbStore | null> {
    if (this.isInisSuccess) {
      return this.rdbStore;
    }
    try {
      await this.getInnerDb();
    } catch (err) {
      Log.error(TAG, `getDb failed, error message: ${err?.code}, ${err?.msg}`);
    }
    return this.rdbStore;
  }

  private async getInnerDb() {
    Log.info(TAG, `getInnerDb getCallingTokenId`);
    if (this.isInitializing) {
      Log.info(TAG, 'getInnerDb isInitializing please wait');
      return new Promise<void>((resolve) => {
        this.waitInitOverResolves.push(resolve);
      });
    }
    this.isInitializing = true;
    let baseContext: common.AbilityStageContext | undefined =
      AppStorage.get<common.AbilityStageContext>('photosGlobalContext');

    if (!baseContext) {
      Log.error(TAG, 'getInnerDb baseContext is null');
      this.initOver(false);
      return;
    }

    // 备份数据
    await this.backup(baseContext);

    let oldArea = baseContext.area;
    baseContext.area = contextConstant.AreaMode.EL2;
    Log.info(TAG, `getRdbStore databaseDir = ${baseContext.databaseDir} area = ${baseContext.area}`)
    try {
      Log.info(TAG, 'getInnerDb getRdbStore Start');
      TraceControllerUtils.startTraceWithTaskId('getRdbStore', 0);
      this.rdbStore = await ohosDataRdb.getRdbStore(baseContext, this.config);
      TraceControllerUtils.finishTraceWithTaskId('getRdbStore', 0);
      Log.info(TAG, 'getInnerDb getRdbStore End');
    } catch (error) {
      Log.error(TAG, `getInnerDb getRdbStore error ${error?.code} ${error?.message} dBName is ${this.dbName}`)
      if (error?.code === CORRUPTED) {
        await this.rebuild(baseContext);
        this.initOver(false);
        return;
      }
    } finally {
      baseContext.area = oldArea;
    }
    if (!this.rdbStore) {
      Log.error(TAG, `getInnerDb getRdbStore result is rdb is null`);
      this.initOver(false);
      return;
    }
    const rdbOK: boolean = await this.checkRdbOK();
    if (!rdbOK) {
      await this.rebuild(baseContext);
      this.initOver(false);
      return;
    }

    const recoveryOK: boolean = await this.recoveryRdb();
    if (!recoveryOK) {
      await this.release();
      this.initOver(false);
      return;
    }

    const initOrUpdateOK: boolean = await this.initOrUpdateRdbStore();
    if (!initOrUpdateOK) {
      await this.release();
      this.initOver(false);
      return;
    }
    this.initOver(true);
  }

  async backUpFaCardBuckets(oldRdbStore: ohosDataRdb.RdbStore): Promise<void> {
    let faCardResultSet: data_rdb.ResultSet | undefined = undefined;
    this.faCardBuckets = [];
    try {
      let predicates = new dataSharePredicates.DataSharePredicates();
      faCardResultSet = await oldRdbStore.query(FaCardTable.TABLE_NAME, predicates);

      const formIdIndex: number = faCardResultSet.getColumnIndex(FaCardTable.FORM_ID);
      const albumUriIndex: number = faCardResultSet.getColumnIndex(FaCardTable.ALBUM_URI);
      const coverUriIndex: number = faCardResultSet.getColumnIndex(FaCardTable.COVER_URI);
      const albumTypeIndex: number = faCardResultSet.getColumnIndex(FaCardTable.ALBUM_TYPE);
      const playbackIntervalIndex: number = faCardResultSet.getColumnIndex(FaCardTable.PLAYBACK_INTERVAL);
      while (faCardResultSet.goToNextRow()) {
        const formId = faCardResultSet.getString(formIdIndex);
        Log.info(TAG, `getFaCardBuckets formId = ${formId}`);
        this.faCardBuckets.push({
          form_id: formId,
          album_uri: faCardResultSet.getString(albumUriIndex),
          cover_uri: faCardResultSet.getString(coverUriIndex),
          album_type: faCardResultSet.getString(albumTypeIndex),
          playback_interval: faCardResultSet.getString(playbackIntervalIndex),
        });
      }
      Log.info(TAG, `getFaCardBuckets faCards = ${JSON.stringify(this.faCardBuckets)}`);
    } catch (error) {
      Log.error(TAG, `getFaCardBuckets error, ${error?.code} ${error?.message}`);
    } finally {
      faCardResultSet?.close();
    }
  }

  async backup(baseContext: common.AbilityStageContext): Promise<void> {
    const dataBaseVersion: number = await this.loadDataBaseVersion();
    // 卡片db未初始化或者版本大于9时不需要备份迁移
    if (dataBaseVersion < DB_BASE_VERSION || dataBaseVersion > DB_MIGRATE_VERSION) {
      Log.info(TAG, `backup dataBaseVersion = ${dataBaseVersion}`);
      return;
    }

    let oldArea = baseContext.area;
    let oldRdbStore: ohosDataRdb.RdbStore | undefined = undefined;
    try {
      baseContext.area = contextConstant.AreaMode.EL1;
      oldRdbStore = await ohosDataRdb.getRdbStore(baseContext, oldConfig);
      await this.backUpFaCardBuckets(oldRdbStore);
    } catch (error) {
      Log.error(TAG, `backup error ${error?.message} dBName is ${this.dbName}`);
      return;
    } finally {
      baseContext.area = oldArea;
      await oldRdbStore?.close();
    }
  }

  async restore(): Promise<void> {
    if (!this.rdbStore) {
      Log.error(TAG, `restore this.rdbStore is null`);
      return;
    }

    if (!this.faCardBuckets.length) {
      Log.info(TAG, `restore faCardBuckets is empty`);
      return;
    }

    try {
      Log.info(TAG,
        `restore batchInsert table = ${FaCardTable.TABLE_NAME}, faCardBuckets = ${JSON.stringify(this.faCardBuckets)}`);
      const insertNum = await this.rdbStore.batchInsert(FaCardTable.TABLE_NAME, this.faCardBuckets);
      Log.info(TAG, `restore batchInsert success, insertNum = ${insertNum}`);
    } catch (error) {
      Log.info(TAG, `restore error, ${error?.code} ${error?.message}`);
    }
  }

  protected initOver(isInisSuccess: boolean) {
    this.isInisSuccess = isInisSuccess;
    this.isInitializing = false;
    this.notifyAll();
  }

  /**
   * 通知等待数据库初始化的异步callBack
   */
  private notifyAll() {
    Log.info(TAG, `notifyAll waitInitOverResolve count is ${this.waitInitOverResolves.length}`);
    for (let waitInitOverResolve of this.waitInitOverResolves) {
      waitInitOverResolve();
    }
  }

  private async release(): Promise<void> {
    try {
      await this.rdbStore?.close();
      this.rdbStore = null;
    } catch (err) {
      Log.error(TAG, `release failed ${err?.message}`);
    }
  }

  private async initOrUpdateRdbStore(): Promise<boolean> {
    if (!this.rdbStore) {
      return false;
    }

    let isUpdateSuccess: boolean = true;
    try {
      // 1、获取rdbStore version
      const dataBaseVersion = await this.rdbStore.version;
      // 2、如果当前version小于 latest，则走升级逻辑
      if (dataBaseVersion < DbVersion.UPDATE_FA_CARD_TABLE_FOR_IS_SHOW_ALBUM_NAME) {
        let updateResult: boolean = await this.updateFaCardTableForAlbumName();
        isUpdateSuccess &&= updateResult;
      }
      // 3、设置rdbStore version为DB_LATEST_VERSION
      if (isUpdateSuccess) {
        this.rdbStore.version = DB_LATEST_VERSION;
      }
    } catch (err) {
      Log.error(TAG, `initOrUpdateRdbStore failed ${err?.message}`);
      return false;
    }
    Log.info(TAG, `initOrUpdateRdbStore res: ${isUpdateSuccess}`)
    return isUpdateSuccess;
  }

  private async recoveryRdb(): Promise<boolean> {
    if (!this.rdbStore) {
      return false;
    }

    try {
      const rdbSelfVersion = this.rdbStore.version;
      Log.info(TAG, `recoveryRdb rdbSelfVersion = ${rdbSelfVersion}`);
      if (rdbSelfVersion !== 0) {
        return true;
      }

      // 相册卡片
      Log.info(TAG, `recoveryRdb albumCard start`);
      await this.rdbStore.executeSql(CREATE_FACARD_TABLE_SQL, []);
      await this.rdbStore.executeSql(CREATE_LOOP_TABLE_SQL, []);
      await this.rdbStore.executeSql(CREATE_IMAGE_TABLE_SQL, []);

      Log.info(TAG, `recoveryRdb setVersion ${DbVersion.ADD_LIGHT_GLIMPSE_TABLE}`);
      this.rdbStore.version = DbVersion.ADD_LIGHT_GLIMPSE_TABLE;
    } catch (err) {
      Log.error(TAG, `recoveryRdb failed ${err?.message}`);
      return false;
    }
    return true;
  }

  /**
   * 根据tableName获取表字段
   * @param rdbStore
   * @param tableName
   * @returns
   * @throws resultSet is undefined
   */
  private async queryColumnsByTableName(rdbStore: ohosDataRdb.RdbStore, tableName: string): Promise<string[]> {
    Log.info(TAG, `queryColumnsByTableName tableName = ${StringUtil.getAnonymizeString(tableName)}`);
    let columns: string[] = [];

    try {
      const resultSet = await rdbStore.querySql(`PRAGMA table_info(${tableName})`);
      if (!resultSet) {
        throw new Error('queryColumnsByTableName resultSet is undefined');
      }

      const nameIndex = resultSet.getColumnIndex('name');
      while (resultSet.goToNextRow()) {
        columns.push(resultSet.getString(nameIndex));
      }
    } catch (err) {
      throw err as Error;
    }

    Log.info(TAG, `queryColumnsByTableName columns = ${columns}`);
    return columns;
  }

  private async checkRdbOK(): Promise<boolean> {
    if (!this.rdbStore) {
      Log.error(TAG, 'checkRdbOK rdbStore is null');
      return false;
    }

    let isRdbOk: boolean = true;
    try {
      Log.info(TAG, `checkRdbOK begin`);
      const resultSet = await this.rdbStore.querySql('pragma quick_check;');
      if (!resultSet) {
        return isRdbOk;
      }

      resultSet.goToNextRow();
      const resultIndex: number = resultSet.getColumnIndex('quick_check');
      const resultStr: string = resultSet.getString(resultIndex);
      isRdbOk = resultStr === 'ok';
      Log.info(TAG, `checkRdbOK end isRdbOk = ${isRdbOk}`);
    } catch (err) {
      Log.error(TAG, `checkRdbOK error, ${err?.code}`);
    }
    return isRdbOk;
  }

  private async rebuild(baseContext: common.AbilityStageContext) {
    try {
      Log.info(TAG, `rebuild close begin`);
      await this.rdbStore?.close();
      Log.info(TAG, `rebuild close end, storeDataBaseVersion begin`);
      this.rdbStore = null;
      this.storeDataBaseVersion(DEFAULT_DATABASE_VERSION);
      Log.info(TAG, `rebuild finish`);
    } catch (error) {
      Log.error(TAG, `rebuild error, code = ${error?.code}`);
    }
  }

  protected async doOnFirstGetDb(rdbStore: ohosDataRdb.RdbStore): Promise<void> {
    const dataBaseVersion: number = await this.loadDataBaseVersion();
    await this.initOrUpdateRdbStoreMatch(dataBaseVersion);
    this.storeDataBaseVersion(DB_LATEST_VERSION);
  }

  /**
   * Obtains the database version number in the cache
   * @returns database version
   */
  protected async loadDataBaseVersion(): Promise<number> {
    let dataBaseVersion: number = DEFAULT_DATABASE_VERSION;
    try {
      const dataStoreUtil = DataStoreUtil.getInstance();
      dataBaseVersion = await dataStoreUtil.getData(DATABASE_VERSION_KEY, DEFAULT_DATABASE_VERSION) as number;
      Log.info(TAG, 'DataBase version in Store = ' + dataBaseVersion);
    } catch (error) {
      Log.error(TAG, 'Failed to get db version code = ' + error?.code + ', message = ' + error?.message);
    }
    return dataBaseVersion;
  }

  /**
   * Stores the database version number
   *
   * @param databaseVersion new version of database
   */
  private storeDataBaseVersion(databaseVersion: number) {
    Log.info(TAG, 'Put dataBase version = ' + databaseVersion + ' in store');
    try {
      DataStoreUtil.getInstance().putData(DATABASE_VERSION_KEY, databaseVersion);
    } catch (err) {
      Log.error(TAG, 'Failed to get preferences. code = ' + err?.code + ', message = ' + err?.message);
    }
  }

  private async initOrUpdateRdbStoreMatch(dataBaseVersion: number) {
    Log.info(TAG, `current version is ${dataBaseVersion} dbLatestVersion is ${DB_LATEST_VERSION}`);
    if (dataBaseVersion === DB_LATEST_VERSION) {
      Log.info(TAG, `The local database has already been initialized.`);
      return;
    }
    if (dataBaseVersion < DB_BASE_VERSION) {
      Log.info(TAG, 'db need init');
      await this.onInitDataBase();
    } else if (dataBaseVersion <= DB_MIGRATE_VERSION) {
      Log.info(TAG, `db is ready to be updated to ${DB_LATEST_VERSION}`);
      await this.onInitDataBase();
      await this.restore();
      Log.info(TAG, 'db init and restore successful');
    } else if (dataBaseVersion < DB_REFRESH_VERSION) {
      /* 版本号低于11的情况下，需要在DB里创建新的table */
      Log.info(TAG, `db is ready to be updated to ${DB_LATEST_VERSION} for refresh DB`);
      await this.onInitDataBase();
      Log.info(TAG, 'db init and restore successful');
    }

    if (dataBaseVersion < DB_UPDATE_HIGHLIGHT_VERSION) {
      dataBaseVersion = DB_UPDATE_HIGHLIGHT_VERSION;
    }
  }

  private async queryAllFormIds(formIdSet: HashSet<string>) {
    const faCardFormIds = await this.queryDistinctColumnByTable(FaCardTable.TABLE_NAME, FaCardTable.FORM_ID);
    const remindersFormIds = await this.queryDistinctColumnByTable(RemindersTable.TABLE_NAME, RemindersTable.FORM_ID);
    faCardFormIds.forEach(formId => {
      formIdSet.add(formId);
    });
    remindersFormIds.forEach(formId => {
      formIdSet.add(formId);
    });
  }

  /**
   * 查询表中某字段的所有唯一值
   *
   * @param tableName 表名
   * @param columnName 字段名
   * @returns 对应值数组
   */
  private async queryDistinctColumnByTable(tableName: string, columnName: string): Promise<string[]> {
    if (!this.rdbStore) {
      return [];
    }
    let res: string[] = [];
    try {
      let predicates = new dataSharePredicates.DataSharePredicates();
      predicates.groupBy([columnName]);
      let queryResultFromReminders: data_rdb.ResultSet | undefined =
        await this.rdbStore.query(tableName, predicates, [columnName]);
      if (queryResultFromReminders && queryResultFromReminders.rowCount > 0) {
        queryResultFromReminders.goToFirstRow();
        const formIdIndex: number = queryResultFromReminders.getColumnIndex(FaCardTable.FORM_ID);
        for (let i = 0; i < queryResultFromReminders.rowCount; i++) {
          const tmpFormId: string = String(queryResultFromReminders.getString(formIdIndex));
          res.push(tmpFormId);
          queryResultFromReminders.goToNextRow();
        }
      }
      Log.info(TAG,
        `queryDistinctColumnByTable: ${StringUtil.getAnonymizeString(tableName)}, ${StringUtil.getAnonymizeString(columnName)}, ${JSON.stringify(res)}`);
    } catch (error) {
      Log.error(TAG, `queryDistinctColumnByTable error, ${error?.code} ${error?.message}`);
    }
    return res;
  }

  /**
   * DataBase 初始化后需要插入默认日历账户
   */
  protected async onInitDataBase() {
    Log.info(TAG, 'onInitDataBase need init');
    TraceControllerUtils.startTrace('initDataBase');
    await this.initRdbStore(this.rdbStore);
    TraceControllerUtils.finishTrace('initDataBase');
  }

  private async initRdbStore(rdbStore: ohosDataRdb.RdbStore | null) {
    if (!this.rdbStore) {
      Log.error(TAG, 'initRdbStore rdbStore is null');
      return;
    }
    await this.createBasicTables(this.rdbStore);

  }

  //13版本后不做更改
  private async createBasicTables(rdbStore: ohosDataRdb.RdbStore | null) {
    if (!this.rdbStore) {
      Log.error(TAG, 'initRdbStoreMatch rdbStore is null');
      return;
    }
    try {
      Log.info(TAG, `createBasicTables start`)
      await this.rdbStore?.executeSql(CREATE_FACARD_TABLE_SQL, []);
      await this.rdbStore?.executeSql(CREATE_LOOP_TABLE_SQL, []);
      await this.rdbStore?.executeSql(CREATE_IMAGE_TABLE_SQL, []);
      Log.info(TAG, `createBasicTables finished`)
    } catch (err) {
      Log.info(TAG, `createBasicTables err: ${err}`)
    }
  }

  private async updateFaCardTableForAlbumName() : Promise<boolean>{
    if (!this.rdbStore) {
      Log.error(TAG, 'updateFaCardTableForAlbumName rdbStore is null');
      return false;
    }
    try {
      Log.info(TAG, 'updateFaCardTableForAlbumName start');
      await this.rdbStore?.executeSql(UPDATE_FA_CARD_TABLE_FOR_ALBUM_NAME_SQL, []);
      await this.rdbStore?.executeSql(UPDATE_FA_CARD_TABLE_FOR_IS_SHOW_ALBUM_NAME_SQL, []);
      Log.info(TAG, 'updateFaCardTableForAlbumName finish');
      return true;
    } catch (err) {
      Log.error(TAG, `updateFaCardTableForAlbumName err: ${err}`);
      return false;
    }
  }

  private async dropBasicTables() {
    if (!this.rdbStore) {
      Log.error(TAG, 'dropBasicTables rdbStore is null');
      return;
    }
    try {
      Log.info(TAG, `dropBasicTables start drop ${RemindersTable.TABLE_NAME}`);
      await this.rdbStore?.executeSql(DROP_LOOP_TABLE_SQL, []);
      Log.info(TAG, `dropBasicTables start drop ${ImageProxyDataTable.TABLE_NAME}`)
      await this.rdbStore?.executeSql(DROP_IMAGE_TABLE_SQL, []);
      Log.info(TAG, `dropBasicTables finished`)
    } catch (err) {
      Log.error(TAG, `dropBasicTables err: ${err?.code}, ${err?.msg}`)
    }
  }
}

const CREATE_FACARD_TABLE_SQL = `CREATE TABLE IF NOT EXISTS ${FaCardTable.TABLE_NAME} (` +
  `${FaCardTable.FORM_ID} INTEGER PRIMARY KEY AUTOINCREMENT, ` +
  `${FaCardTable.ALBUM_URI} TEXT, ` +
  `${FaCardTable.COVER_URI} TEXT, ` +
  `${FaCardTable.ALBUM_TYPE} INTEGER, ` +
  `${FaCardTable.PLAYBACK_INTERVAL} INTEGER` +
  `)`;

const CREATE_LOOP_TABLE_SQL = `CREATE TABLE IF NOT EXISTS ${RemindersTable.TABLE_NAME} (` +
  `${RemindersTable.ID} INTEGER PRIMARY KEY, ` +
  `${RemindersTable.FORM_ID} INTEGER, ` +
  `${RemindersTable.IMAGE_URI} TEXT, ` +
  `${RemindersTable.SHOW_TIME} INTEGER, ` +
  `${RemindersTable.ALBUM_URI} TEXT, ` +
  `${RemindersTable.IS_HIDDEN} INTEGER, ` +
  `${RemindersTable.DATE_TAKEN} INTEGER, ` +
  `${RemindersTable.DATE_ADDED} INTEGER,` +
  `${RemindersTable.IMAGE_URI_ID} TEXT` +
  `)`;

const CREATE_IMAGE_TABLE_SQL = `CREATE TABLE IF NOT EXISTS ${ImageProxyDataTable.TABLE_NAME} (` +
  `${ImageProxyDataTable.ID} INTEGER PRIMARY KEY AUTOINCREMENT, ` +
  `${ImageProxyDataTable.URI} TEXT UNIQUE, ` +
  `${ImageProxyDataTable.BLOB} TEXT, ` +
  `${ImageProxyDataTable.BOUND} TEXT` +
  `)`;

const UPDATE_FA_CARD_TABLE_FOR_ALBUM_NAME_SQL = `ALTER TABLE ${FaCardTable.TABLE_NAME} ADD COLUMN ${FaCardTable.ALBUM_NAME} TEXT DEFAULT ''`;
const UPDATE_FA_CARD_TABLE_FOR_IS_SHOW_ALBUM_NAME_SQL = `ALTER TABLE ${FaCardTable.TABLE_NAME} ADD COLUMN ${FaCardTable.IS_SHOW_ALBUM_NAME} INTEGER DEFAULT 0`;

const DROP_LOOP_TABLE_SQL = `DROP TABLE IF EXISTS  ${RemindersTable.TABLE_NAME};`


const DROP_IMAGE_TABLE_SQL = `DROP TABLE IF EXISTS  ${ImageProxyDataTable.TABLE_NAME};`


