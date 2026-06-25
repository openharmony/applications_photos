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

import { relationalStore } from '@kit.ArkData';
import { AlbumInfo } from '../model/browser/album/AlbumInfo';
import { AlbumDefine } from '../model/browser/AlbumDefine';
import { Log } from './Log';
import { RdbHelper } from './RdbHelper';
import { Constants } from '../model/common/Constants';
import { contextConstant } from '@kit.AbilityKit';

const TAG: string = 'common_AlbumRatioUtils';

const COLUMN_SUB_TYPE: string = 'sub_type';
const COLUMN_LPATH: string = 'lpath';
const COLUMN_ISFULLRATIO: string = 'isFullRatio';
const PRIMARY_KEY: string = `PRIMARY KEY(${COLUMN_SUB_TYPE}, ${COLUMN_LPATH})`;
const COLUMNS: ReadonlyArray<string> =
  [`${COLUMN_SUB_TYPE} INTEGER`, `${COLUMN_LPATH} VARCHAR`, `${COLUMN_ISFULLRATIO} INTEGER`, PRIMARY_KEY];
const DB_NAME: string = 'album.db';
const TABLE_NAME: string = 'tbl_album_isFullRatio';
const SQL_CREATE: string = `CREATE TABLE IF NOT EXISTS ${TABLE_NAME} ( ${COLUMNS.join(', ')})`;

export const STORE_CONFIG: relationalStore.StoreConfig = {
  name: DB_NAME, // 数据库文件名
  securityLevel: relationalStore.SecurityLevel.S1, // 数据库安全级别
};

interface IsFullRatioSaveKey {
  subType: number;
  lpath: string;
}

export class AlbumRatioUtils {
  private static albumIsFullRatios: Map<string, number> = new Map();
  private static initPromise: Promise<void> | undefined = undefined;
  private static isInitialized: boolean = false;
  private static store: relationalStore.RdbStore | undefined = undefined;

  /* instrument ignore next */
  private constructor() {
  }

  public static async init(context: Context): Promise<void> {
    if (AlbumRatioUtils.isInitialized) {
      Log.info(TAG, 'IsInitialized');
      return;
    }
    /* instrument ignore if */
    if (!context) {
      Log.error(TAG, 'Invalid context');
      return;
    }

    Log.info(TAG, 'Start to init');
    if (AlbumRatioUtils.initPromise) {
      return AlbumRatioUtils.initPromise;
    }
    AlbumRatioUtils.initPromise = AlbumRatioUtils.initInner(context);
    return AlbumRatioUtils.initPromise;
  }

  private static async initInner(context: Context): Promise<void> {
    let startTime: number = Date.now();
    let store: relationalStore.RdbStore | undefined = await RdbHelper.getRdb(
      context.createAreaModeContext(contextConstant.AreaMode.EL1), STORE_CONFIG);
    /* instrument ignore if */
    if (!store) {
      Log.error(TAG, 'Failed to get rdb');
      AlbumRatioUtils.initPromise = undefined;
      return;
    }
    Log.info(TAG, `Finished to get rdb, cost: ${Date.now() - startTime}`);
    let resultSet: relationalStore.ResultSet | undefined = undefined;
    try {
      await store.executeSql(SQL_CREATE);
      resultSet =
        await store.query(new relationalStore.RdbPredicates(TABLE_NAME),
          [COLUMN_SUB_TYPE, COLUMN_LPATH, COLUMN_ISFULLRATIO]);
      while (resultSet.goToNextRow()) {
        let subType: number = resultSet.getValue(resultSet.getColumnIndex(COLUMN_SUB_TYPE)) as number;
        let lpath: string = resultSet.getValue(resultSet.getColumnIndex(COLUMN_LPATH)) as string;
        let isFullRatio: number = resultSet.getValue(resultSet.getColumnIndex(COLUMN_ISFULLRATIO)) as number;
        let key: string = AlbumRatioUtils.genSaveKey(subType, lpath);
        AlbumRatioUtils.albumIsFullRatios.set(key, isFullRatio);
      }
      AlbumRatioUtils.store = store;
      AlbumRatioUtils.isInitialized = true;
      AlbumRatioUtils.initPromise = undefined;
      Log.info(TAG, `Finished to init, cost: ${Date.now() - startTime}, records: ${AlbumRatioUtils.albumIsFullRatios.size}`);
    } catch (e) {
      /* instrument ignore next */
      Log.info(TAG, `Failed to init. message:${e?.message}, code:${e?.code}`);
    } finally {
      resultSet?.close();
    }
  }

  public static async getIsFullRatio(context: Context, subType: number | undefined,
    lpath: string | undefined): Promise<boolean> {
    if (AppStorage.get<boolean>(Constants.APP_IS_PHOTO_CLONE)) {
      AlbumRatioUtils.isInitialized = false;
      AppStorage.setOrCreate<boolean>(Constants.APP_IS_PHOTO_CLONE, false);
    }
    const startTime: number = Date.now();
    await AlbumRatioUtils.init(context);
    let key: string = AlbumRatioUtils.genSaveKey(subType, lpath);
    // IsFullRatio 默认值为true
    let isFullRatio = Boolean(AlbumRatioUtils.albumIsFullRatios.get(key) ?? 1);
    Log.info(TAG, `getIsFullRatio status: ${isFullRatio}, cost: ${Date.now() - startTime}`);
    return isFullRatio;
  }

  private static genSaveKey(subType: number | undefined, lpath: string | undefined): string {
    let saveKey: IsFullRatioSaveKey = {
      subType: Number(subType ?? 0),
      lpath: lpath ?? '',
    };

    return JSON.stringify(saveKey);
  }

  /* instrument ignore next */
  public static async saveIsFullRatio(context: Context, subType: number | undefined, lpath: string | undefined,
    isFullRatio: boolean): Promise<void> {
    const startTime: number = Date.now();
    await AlbumRatioUtils.init(context);
    let key: string = AlbumRatioUtils.genSaveKey(subType, lpath);
    // 数据库保持IsFullRatio类型为number
    AlbumRatioUtils.albumIsFullRatios.set(key, Number(isFullRatio));
    let ret: number | undefined = undefined;
    if (isFullRatio) {
      let predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COLUMN_SUB_TYPE, subType ?? 0).and().equalTo(COLUMN_LPATH, lpath ?? '');
      ret = await AlbumRatioUtils.store?.delete(predicates);
    } else {
      let valueBucket: relationalStore.ValuesBucket = {
        'sub_type': subType ?? 0,
        'lpath': lpath ?? '',
        'isFullRatio': Number(isFullRatio),
      }
      ret =
        await AlbumRatioUtils.store?.insert(TABLE_NAME, valueBucket,
          relationalStore.ConflictResolution.ON_CONFLICT_REPLACE);
    }
    Log.info(TAG,
      `saveIsFullRatio album: ${subType}_${AlbumDefine.getAnonymizeAlbumName(lpath ?? '')}, cost: ${Date.now() -
        startTime}, isFullRatio: ${isFullRatio}, ret: ${ret}`);
  }

  public static reset(): void {
    AlbumRatioUtils.albumIsFullRatios.clear();
    AlbumRatioUtils.isInitialized = false;
  }
}