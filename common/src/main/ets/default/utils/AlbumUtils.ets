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

import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { AlbumInfo } from '../model/browser/album/AlbumInfo';
import lazy { AlbumDefine } from '../model/browser/AlbumDefine';
import lazy { Log } from './Log';
import lazy { GridViewMode } from '../view/grid/GridView';
import lazy { SystemPropertiesManager } from './SystemPropertiesManager';
import lazy { relationalStore } from '@kit.ArkData';
import lazy { RdbHelper } from './RdbHelper';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { DeviceInfo } from './DeviceInfo';
import lazy { Constants } from '../model/common/Constants';
import lazy { contextConstant } from '@kit.AbilityKit';

const TAG: string = 'common_AlbumUtils';

/**
 * 配置项开关，通过以下命令开启
 * hdc shell param set persist.photos.album_view_mode.enabled true
 */
const PERSIST_KEY_ALBUM_VIEW_MODE: string = 'persist.photos.album_view_mode.enabled';
/**
 * 是否使用新宫格
 * hdc shell param set persist.photos.new_photo_grid_view.enabled true
 */
const PERSIST_NEW_PHOTO_GRID_VIEW: string = 'persist.photos.new_photo_grid_view.enabled';
/**
 * 是否使用新PC宫格
 * hdc shell param set persist.photos.new_pc_photo_grid_view.enabled true
 */
const PERSIST_NEW_PC_PHOTO_GRID_VIEW: string = 'persist.photos.new_pc_photo_grid_view.enabled';
/**
 * 是否使用新精准通知
 * hdc shell param set persist.photos.new_accurate_notify.enabled true
 */
const PERSIST_NEW_ACCURATE_NOTIFY: string = 'persist.photos.new_accurate_notify.enabled';

const COLUMN_SUB_TYPE: string = 'sub_type';
const COLUMN_LPATH: string = 'lpath';
const COLUMN_MODE: string = 'mode';
const PRIMARY_KEY: string = `PRIMARY KEY(${COLUMN_SUB_TYPE}, ${COLUMN_LPATH})`;
const COLUMNS: ReadonlyArray<string> =
  [`${COLUMN_SUB_TYPE} INTEGER`, `${COLUMN_LPATH} VARCHAR`, `${COLUMN_MODE} INTEGER`, PRIMARY_KEY];
const DB_NAME: string = 'album.db';
const TABLE_NAME: string = 'tbl_album_view_mode';
const SQL_CREATE: string = `CREATE TABLE IF NOT EXISTS ${TABLE_NAME} ( ${COLUMNS.join(', ')})`;
export const STORE_CONFIG: relationalStore.StoreConfig = {
  name: DB_NAME, // 数据库文件名
  securityLevel: relationalStore.SecurityLevel.S1, // 数据库安全级别
};
/**
 * 是否使用日视图节点主动回收
 * hdc shell param set persist.photos.release_day_grid.enabled true
 */
const PERSIST_USE_RELEASE_DAY_GRID: string = 'persist.photos.release_day_grid.enabled';

interface ViewModeSaveKey {
  subType: number;
  lpath: string;
}

export class AlbumUtils {
  private static albumViewModes: Map<string, number> = new Map();
  private static initPromise: Promise<void> | undefined = undefined;
  private static isInitialized: boolean = false;
  private static store: relationalStore.RdbStore | undefined = undefined;

  /* instrument ignore next */
  private constructor() {
  }

  public static isAlbumGroupModeSupported(): boolean {
    return SystemPropertiesManager.getInstance().get(PERSIST_KEY_ALBUM_VIEW_MODE, 'true') === 'true';
  }

  public static useNewPhotoGrid(): boolean {
    // 模拟器统一走新框架
    if (DeviceInfo.isEmulator()) {
      return true;
    }
    // xxx除了Grl均放开
    if (DeviceInfo.isFoldDevice() && !DeviceInfo.isGRLFoldScreen()) {
      return SystemPropertiesManager.getInstance().get(PERSIST_NEW_PHOTO_GRID_VIEW, 'true') === 'true';
    }
    return (DeviceInfo.isPhoneUx() || DeviceInfo.isTablet()) && !DeviceInfo.isFoldDevice() &&
      SystemPropertiesManager.getInstance().get(PERSIST_NEW_PHOTO_GRID_VIEW, 'true') === 'true';
  }

  public static useAccurateNotify(): boolean {
    return SystemPropertiesManager.getInstance().get(PERSIST_NEW_ACCURATE_NOTIFY, 'true') === 'true';
  }

  /**
   * 日视图切换到月视图时候释放ImageGridItemComponent节点进复用池
   */
  public static useReleaseDayGrid(): boolean {
    return SystemPropertiesManager.getInstance().get(PERSIST_USE_RELEASE_DAY_GRID, 'true') === 'true';
  }

  public static useNewPCPhotoGrid(): boolean {
    return SystemPropertiesManager.getInstance().get(PERSIST_NEW_PC_PHOTO_GRID_VIEW, 'true') === 'true';
  }

  public static isAlbumSupported(subType: number): boolean {
    switch (subType) {
      case Number(photoAccessHelper.AlbumSubtype.USER_GENERIC):
      case Number(photoAccessHelper.AlbumSubtype.IMAGE):
      case Number(photoAccessHelper.AlbumSubtype.VIDEO):
      case Number(photoAccessHelper.AlbumSubtype.FAVORITE):
      case Number(photoAccessHelper.AlbumSubtype.SCREENSHOT):
      case Number(photoAccessHelper.AlbumSubtype.CAMERA):
      case Number(photoAccessHelper.AlbumSubtype.CLOUD_ENHANCEMENT):
      case Number(photoAccessHelper.AlbumSubtype.SOURCE_GENERIC):
      case Number(photoAccessHelper.AlbumSubtype.SHOOTING_MODE):
        return AlbumUtils.isAlbumGroupModeSupported();
      default:
        return false;
    }
  }

  public static async init(context: Context): Promise<void> {
    if (AlbumUtils.isInitialized) {
      return;
    }
    /* instrument ignore if */
    if (!context) {
      Log.error(TAG, 'Invalid context');
      return;
    }

    Log.info(TAG, 'Start to init');
    if (AlbumUtils.initPromise) {
      return AlbumUtils.initPromise;
    }
    AlbumUtils.initPromise = AlbumUtils.initInner(context);
    return AlbumUtils.initPromise;
  }

  private static async initInner(context: Context): Promise<void> {
    let startTime: number = Date.now();
    let store: relationalStore.RdbStore | undefined = await RdbHelper.getRdb(
      context.createAreaModeContext(contextConstant.AreaMode.EL1), STORE_CONFIG);
    /* instrument ignore if */
    if (!store) {
      Log.error(TAG, 'Failed to get rdb');
      AlbumUtils.initPromise = undefined;
      return;
    }
    Log.info(TAG, `Finished to get rdb, cost: ${Date.now() - startTime}`);
    let resultSet: relationalStore.ResultSet | undefined = undefined;
    try {
      await store.executeSql(SQL_CREATE);
      resultSet =
        await store.query(new relationalStore.RdbPredicates(TABLE_NAME), [COLUMN_SUB_TYPE, COLUMN_LPATH, COLUMN_MODE]);
      while (resultSet.goToNextRow()) {
        let subType: number = resultSet.getValue(resultSet.getColumnIndex(COLUMN_SUB_TYPE)) as number;
        let lpath: string = resultSet.getValue(resultSet.getColumnIndex(COLUMN_LPATH)) as string;
        let mode: number = resultSet.getValue(resultSet.getColumnIndex(COLUMN_MODE)) as number;
        let key: string = AlbumUtils.genSaveKey(subType, lpath);
        AlbumUtils.albumViewModes.set(key, mode);
      }
      AlbumUtils.store = store;
      AlbumUtils.isInitialized = true;
      AlbumUtils.initPromise = undefined;
      Log.info(TAG, `Finished to init, cost: ${Date.now() - startTime}, records: ${AlbumUtils.albumViewModes.size}`);
    } catch (e) {
      /* instrument ignore next */
      Log.info(TAG, `Failed to init: ${(e as BusinessError)?.code}`);
    } finally {
      resultSet?.close();
    }
  }

  public static async setViewMode(context: Context, albumInfo: AlbumInfo): Promise<void> {
    /* instrument ignore if */
    if (!AlbumUtils.isAlbumGroupModeSupported() || !albumInfo) {
      return;
    }
    const startTime: number = Date.now();
    await AlbumUtils.init(context);
    let key: string = AlbumUtils.genSaveKey(albumInfo.subType, albumInfo.lpath);
    let mode: number = AlbumUtils.albumViewModes.get(key) ?? Number(GridViewMode.GRID);
    if (mode === Number(GridViewMode.GROUP)) {
      albumInfo.viewMode = GridViewMode.GROUP;
    } else {
      albumInfo.viewMode = GridViewMode.GRID;
    }
    if (DeviceInfo.isGRLFoldScreen()) {
      LocalStorage.getShared()?.setOrCreate(Constants.APP_KEY_GRL_PHOTO_GRID_VIEW_MODE, albumInfo.viewMode);
    }
    Log.info(TAG, `SetViewMode status: ${albumInfo.viewMode}, cost: ${Date.now() - startTime}`);
  }

  private static genSaveKey(subType: number | undefined, lpath: string | undefined): string {
    let json: ViewModeSaveKey = {
      subType: Number(subType ?? 0),
      lpath: lpath ?? '',
    };

    return JSON.stringify(json);
  }

  /* instrument ignore next */
  public static async saveViewMode(context: Context, subType: number | undefined, lpath: string | undefined,
    mode: GridViewMode | undefined): Promise<void> {
    if (!AlbumUtils.isAlbumGroupModeSupported()) {
      return;
    }
    if (AppStorage.get<boolean>(Constants.APP_IS_PHOTO_CLONE)) {
      AlbumUtils.isInitialized = false;
      AppStorage.setOrCreate<boolean>(Constants.APP_IS_PHOTO_CLONE, false);
    }
    const startTime: number = Date.now();
    await AlbumUtils.init(context);
    let key: string = AlbumUtils.genSaveKey(subType, lpath);
    AlbumUtils.albumViewModes.set(key, Number(mode));
    let ret: number | undefined = undefined;
    if (mode === GridViewMode.GRID) {
      let predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COLUMN_SUB_TYPE, subType ?? 0).and().equalTo(COLUMN_LPATH, lpath ?? '');
      ret = await AlbumUtils.store?.delete(predicates);
    } else {
      let valueBucket: relationalStore.ValuesBucket = {
        'sub_type': subType ?? 0,
        'lpath': lpath ?? '',
        'mode': Number(GridViewMode.GROUP),
      }
      ret =
        await AlbumUtils.store?.insert(TABLE_NAME, valueBucket,
          relationalStore.ConflictResolution.ON_CONFLICT_REPLACE);
    }
    Log.info(TAG,
      `SaveViewMode album: ${subType}_${AlbumDefine.getAnonymizeAlbumName(lpath ?? '')}, cost: ${Date.now() -
        startTime}, mode: ${mode}, ret: ${ret}`);
  }

  public static reset(): void {
    AlbumUtils.isInitialized = false;
  }
}