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

import lazy common from '@ohos.app.ability.common';
import lazy convertxml from '@ohos.convertxml';
import lazy preferences from '@ohos.data.preferences';
import lazy fs from '@ohos.file.fs';
import lazy util from '@ohos.util';
import lazy BackupExtensionContext from '@ohos.file.BackupExtensionContext';
import lazy settings from '@ohos.settings';
import lazy rdb from '@ohos.data.relationalStore';
import lazy { contextConstant } from '@kit.AbilityKit';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { AlbumGridSortHelper, AlbumGridSortRule } from '@ohos/common/src/main/ets/default/model/AlbumGridSortHelper';
import lazy { AlbumUtils } from '@ohos/common/src/main/ets/default/utils/AlbumUtils';
import lazy { GridViewMode } from '@ohos/common/src/main/ets/default/view/grid/GridView';
import lazy { TransferUtils } from './TransferUtils'
import { SyncAlbumUtil } from '@ohos/common/src/main/ets/default/utils/SyncAlbumUtil';

const TAG: string = 'TransferManager';

const RESTORE_DIR: string = '/restore/com.xxx.photos/ce/';
const SP_DIR: string = 'shared_prefs';
const SP_PHOTOS_PREFERENCES: string = 'com.xxx.photos_preferences.xml';
const SP_CLOUD_ENHANCE: string = 'cloud-enhance-feature.xml';
const SP_PHOTOSORT_TYPE: string = 'photoSortType_pre.xml';
const SP_ALBUMVIEW_MODE: string = 'albumViewMode_pre.xml'

const DATABASE_DIR: string = 'databases';
const PAGE_SIZE: number = 10;
const GALLERY_DB: string = 'gallery.db'
const TABLE_ALBUM_TABLE_NAME: string = 'gallery_album';
const RELATIVE_BUCKET_ID: string = 'relativeBucketId';
const LPATH: string = 'lpath';
const ENTITY_ALBUM_TYPE: number = 2049;

// 虚拟相册前缀
const ALBUM_VIRTUAL_PREFIX: string = '/gallery/album/virtual/common/*';
// 实体相册前缀
const ALBUM_ENTITY_PREFIX: string = '/gallery/album/entity';
// 实体相册key前缀
const ALBUM_ENTITY_KEY_PREFIX: string = '2049'

// 设置AI云增强开关
const CLOUD_ENHANCE: string = 'key-photo-cloud-enhance';
const FEATURE_ENABLE: string = 'persist.photos.ce.feature.enable'
// 设置云增强水印开关
const CLOUD_ENHANCE_WATERMARK: string = 'key-cloud-enhance-watermark';
const WATERMARK_ENABLE: string = 'persist.photos.ce.watermark.enable'
// 设置幻灯片播放时间
const SLIDE_SHOW_SETTING: string = 'key-slide-show-setting'
const SLIDESHOW_INTERVAL: string = 'persist.photos.slideshow.interval'
// 设置数据同步开关
const SMART_STORE_BIND_KEY: string = 'SMART_STORE_BIND_KEY';
const SMART_STORE_BIND_KEY2: string = 'photos_hdc_sync_bind_nas';
const SMART_STORE_SYNC_STATUS_KEY: string = 'SMART_STORE_SYNC_STATUS_KEY';
const SMART_STORE_SYNC_STATUS_KEY2: string = 'photos_hdc_sync_bind_nas_status';
const CLOUD_ALBUM_STATE: string = 'key-cloud-album-state';
const CLOUD_ALBUM_STATE2: string = 'photos_hdc_sync_bind_cloud_status';
const SMART_STORE_SYNC_USER_KEY: string = 'SMART_STORE_SYNC_USER_KEY';
const SMART_STORE_SYNC_USER_KEY2: string = 'photos_hdc_sync_bind_nas_user_key';
const SMART_STORE_SYNC_DEVICE_KEY: string = 'SMART_STORE_SYNC_DEVICE_KEY';
const SMART_STORE_SYNC_DEVICE_KEY2: string = 'photos_hdc_sync_bind_nas_device_key';
const CLOUD_LOGIN_STATE: string = 'key-cloud-login-state';
const CLOUD_LOGIN_STATE2: string = 'photos_hdc_sync_account_register_status';
const SYNC_ALL: string = 'sync_all';
const PHOTO_ALL_ALBUMS_UPLOAD_STATUS: string = 'photos_all_album_upload';

// hmos 和 next setting key对应关系
const SETTINGS_KEY_MAP: Map<string, string> = new Map([
  [CLOUD_ENHANCE, FEATURE_ENABLE],
  [CLOUD_ENHANCE_WATERMARK, WATERMARK_ENABLE],
  [SLIDE_SHOW_SETTING, SLIDESHOW_INTERVAL],
  [SMART_STORE_BIND_KEY, SMART_STORE_BIND_KEY2],
  [SMART_STORE_SYNC_STATUS_KEY, SMART_STORE_SYNC_STATUS_KEY2],
  [CLOUD_ALBUM_STATE, CLOUD_ALBUM_STATE2],
  [SMART_STORE_SYNC_USER_KEY, SMART_STORE_SYNC_USER_KEY2],
  [SMART_STORE_SYNC_DEVICE_KEY, SMART_STORE_SYNC_DEVICE_KEY2],
  [CLOUD_LOGIN_STATE, CLOUD_LOGIN_STATE2],
  [SYNC_ALL, PHOTO_ALL_ALBUMS_UPLOAD_STATUS],
]);

// hmos 和 next 幻灯片播放间隔时间对应关系
const slideShowMap: Map<string, string> = new Map([
  ['0', '3'],
  ['1', '5'],
  ['2', '10'],
  ['3', '15']
]);

// hmos 和 next 虚拟相册类型对应关系
const albumTypeMap: Map<string, number> = new Map([
  ['0', 1031],
  ['1', 1026],
  ['3', 1025],
  ['4', 1032],
]);

// hmos 和 next 相册内排序值对应关系
const sortValueMap: Map<string, [string, string]> = new Map([
  ['0', [AlbumGridSortRule.SHOOT_TIME, 'DESC']],
  ['1', [AlbumGridSortRule.SHOOT_TIME, 'ASC']],
  ['2', [AlbumGridSortRule.CREATE_TIME, 'DESC']],
  ['3', [AlbumGridSortRule.CREATE_TIME, 'ASC']],
  ['4', [AlbumGridSortRule.FILE_NAME, 'DESC']],
  ['5', [AlbumGridSortRule.FILE_NAME, 'ASC']],
  ['6', [AlbumGridSortRule.FILE_SIZE, 'DESC']],
  ['7', [AlbumGridSortRule.FILE_SIZE, 'ASC']],
]);

// hmos 和 next 显示日期类型对应关系
const gridViewMode: Map<string, number> = new Map([
  ['0', GridViewMode.GRID],
  ['1', GridViewMode.GROUP],
])

export default class TransferManager {

  private context: BackupExtensionContext;
  private specificHandlerMap = new Map<string, (key: string, value: preferences.ValueType) => void> ();
  private sourceRdbStore?: rdb.RdbStore;

  // 云增强
  private cloudEnhanceHandler = (key: string, value: preferences.ValueType): void => {
    let settingKey = SETTINGS_KEY_MAP.get(key);
    if (settingKey === undefined) {
      Log.error(TAG, `Key: ${key} not found`);
      return;
    }
    let settingValue = value.toString();
    this.setSettings(settingKey, settingValue);
  }

  // 幻灯片播放间隔
  private slideShowHandler = (key: string, value: preferences.ValueType): void => {
    let settingKey = SETTINGS_KEY_MAP.get(key);
    if (settingKey === undefined) {
      Log.error(TAG, `Key: ${key} not found`);
      return;
    }

    let settingValue = slideShowMap.get(value.toString());
    if (settingValue === undefined) {
      Log.error(TAG, `value: ${value.toString()} not found`);
      return;
    }
    this.setSettings(settingKey, settingValue);
  }

  // 设置数据同步开关
  private syncOptionHandler = (key: string, value: preferences.ValueType): void => {
    let settingKey = SETTINGS_KEY_MAP.get(key);
    if (settingKey === undefined) {
      Log.error(TAG, `Key: ${key} not found`);
      return;
    }
    let settingValue = value.toString();
    Log.info(TAG, `syncOptionHandler settingKey: ${settingKey}, settingValue: ${settingValue}`);
    this.setSettings(settingKey, settingValue);
  }

  // 设置相册同步状态的handler
  private syncAlbumUpdateHandler = (key: string, value: preferences.ValueType): void => {
    let settingKey = SETTINGS_KEY_MAP.get(key);
    if (settingKey === undefined) {
      Log.error(TAG, `Key: ${key} not found`);
      return;
    }
    Log.info(TAG, `value : ${value} , getValueSync : ${SyncAlbumUtil.getValueSync(this.context)}`);
    if (SyncAlbumUtil.getValueSync(this.context) === '1' && value === '1') {
      value = '1'
    } else {
      value = '0'
    }
    let settingValue = value.toString();
    Log.info(TAG, `syncAlbumUpdateHandler settingKey: ${settingKey}, settingValue: ${settingValue}`);
    this.setSettings(settingKey, settingValue);
  }

  public constructor(context: BackupExtensionContext) {
    this.context = context;
    this.specificHandlerMap.set(CLOUD_ENHANCE, this.cloudEnhanceHandler);
    this.specificHandlerMap.set(CLOUD_ENHANCE_WATERMARK, this.cloudEnhanceHandler);
    this.specificHandlerMap.set(SLIDE_SHOW_SETTING, this.slideShowHandler);
    this.specificHandlerMap.set(SMART_STORE_BIND_KEY, this.syncOptionHandler);
    this.specificHandlerMap.set(SMART_STORE_SYNC_STATUS_KEY, this.syncOptionHandler);
    this.specificHandlerMap.set(CLOUD_ALBUM_STATE, this.syncOptionHandler);
    this.specificHandlerMap.set(SMART_STORE_SYNC_USER_KEY, this.syncOptionHandler);
    this.specificHandlerMap.set(SMART_STORE_SYNC_DEVICE_KEY, this.syncOptionHandler);
    this.specificHandlerMap.set(CLOUD_LOGIN_STATE, this.syncOptionHandler);
    this.specificHandlerMap.set(SYNC_ALL, this.syncAlbumUpdateHandler);
  }

  public async transferData(): Promise<void> {
    let backupDir = this.context.backupDir + RESTORE_DIR;
    if (!fs.accessSync(backupDir)) {
      Log.error(TAG, `BackupDir not accessible`);
      return;
    }

    await this.processSettingsFromSP(backupDir);
    await this.processSettingsFromSPAndDb(backupDir);
  }

  private async processSettingsFromSP(path: string): Promise<void> {
    const xmlFiles: string[] = [path + `/${SP_DIR}/` + SP_PHOTOS_PREFERENCES, path + `/${SP_DIR}/` + SP_CLOUD_ENHANCE];
    for (let i = 0; i < xmlFiles.length; i++) {
      let xmlStr = await TransferUtils.getXmlStr(xmlFiles[i]);
      let xmlElement = TransferUtils.transferSourceXmlToXmlElement(xmlStr);
      let dataMap = TransferUtils.parseXmlElement(xmlElement);

      dataMap.forEach((value, key) => {
        const handler = this.specificHandlerMap.get(key);
        if (handler !== undefined) {
          handler(key, value);
        }
      });
    }
  }

  // 设置
  private setSettings(settingKey: string, settingValue: string) {
    if (!this.context) {
      Log.error(TAG, `context is invalid`);
      return;
    }
    try {
      settings.setValueSync(this.context, settingKey, settingValue);
    } catch (err) {
      Log.error(TAG, `Set settings error: ${err} settingKey:${settingKey} settingValue: ${settingValue}`);
    }
  }

  private async processSettingsFromSPAndDb(sourcePath: string): Promise<void> {
    let dbDir = sourcePath + `/${DATABASE_DIR}/`;
    let spDir = sourcePath + `/${SP_DIR}/`;

    let context = this.context;
    let result = await this.moveDbFile(context, dbDir);
    if (!result) {
      Log.error(TAG, `moveDbFile failed`);
      return;
    }

    // bucket_id -> lpath
    let bucketResults: Map<string, string> = new Map();
    let count = await this.querySourceCount(context);
    let pages = Math.ceil(count / PAGE_SIZE);
    for (let curPage = 1; curPage <= pages; curPage++) {
      await this.querySourceBucket(context, PAGE_SIZE, PAGE_SIZE * (curPage - 1), bucketResults);
    }

    await this.handlePhotoSortType(spDir + SP_PHOTOSORT_TYPE, bucketResults);
    await this.handleAlbumViewMode(spDir + SP_ALBUMVIEW_MODE, bucketResults);
  }

  // 移动数据库文件
  private async moveDbFile(context: common.Context, sourceDbPath: string): Promise<boolean> {
    try {
      if (!fs.accessSync(sourceDbPath)) {
        Log.error(TAG, `path not accessible`);
        return false;
      }

      let listFileNames: string[] = fs.listFileSync(sourceDbPath);
      if (!listFileNames || listFileNames.length === 0) {
        Log.error(TAG, `path empty`);
        return false;
      }

      // rdb默认路径
      let targetPath: string = context.databaseDir + '/rdb';
      if (!fs.accessSync(targetPath)) {
        fs.mkdirSync(targetPath);
      }

      listFileNames.forEach(async (fileName: string) => {
        let srcPath = `${sourceDbPath}/${fileName}`;
        let destPath = `${targetPath}/${fileName}`;
        if (fs.statSync(srcPath).isFile()) {
          await fs.moveFile(srcPath, destPath);
        } else {
          await fs.moveDir(srcPath, targetPath, 2);
        }
      });
      return true;
    } catch (error) {
      Log.error(TAG, `moveDbFile failed, error code:${error?.code} msg:${error?.message}`);
      return false;
    }
  }

  private async initSourceDb(context: common.Context): Promise<boolean> {
    // 已经初始化后，不必重新初始化
    if (this.sourceRdbStore) {
      return true;
    }
    try {
      const SOURCE_CONFIG: rdb.StoreConfig = {
        name: GALLERY_DB,
        securityLevel: rdb.SecurityLevel.S1
      };
      this.sourceRdbStore = await rdb.getRdbStore(context, SOURCE_CONFIG);
      return true;
    } catch (error) {
      Log.error(TAG, `initSourceDb failed, error code:${error?.code} msg:${error?.message}`);
      return false;
    }
  }

  private async querySourceCount(context: common.Context): Promise<number> {
    let count = 0;
    let resultSet: rdb.ResultSet | undefined = undefined;
    try {
      if (!await this.initSourceDb(context)) {
        Log.error(TAG, `initSourceDb failed`);
        return count;
      }
      let queryColumn = ['count(1)'];
      let predicatesInfo = new rdb.RdbPredicates(TABLE_ALBUM_TABLE_NAME);
      resultSet = await this.sourceRdbStore?.query(predicatesInfo, queryColumn);
      if (!resultSet || !resultSet.goToFirstRow()) {
        return count;
      }
      count = resultSet.getLong(0);
    } catch (error) {
      Log.error(TAG, `querySourceCount failed, error code:${error?.code} msg:${error?.message}`);
    } finally {
      resultSet?.close();
    }
    return count;
  }

  private async querySourceBucket(context: common.Context, pageSize: number, offset: number,
    bucketResults: Map<string, string>): Promise<void> {
    if (!await this.initSourceDb(context)) {
      return;
    }

    let resultSet: rdb.ResultSet | undefined = undefined;
    try {
      let queryColumns = [RELATIVE_BUCKET_ID, LPATH];
      let predicatesInfo = new rdb.RdbPredicates(TABLE_ALBUM_TABLE_NAME)
        .orderByAsc(RELATIVE_BUCKET_ID)
        .limitAs(pageSize)
        .offsetAs(offset);
      resultSet = await this.sourceRdbStore?.query(predicatesInfo, queryColumns);
      if (!resultSet || !resultSet.goToFirstRow()) {
        Log.error(TAG, `query failed`);
        return;
      }

      do {
        let bucketId = resultSet.getString(resultSet.getColumnIndex(RELATIVE_BUCKET_ID));
        let lpath = resultSet.getString(resultSet.getColumnIndex(LPATH));
        bucketResults.set(bucketId, lpath);
      } while (resultSet.goToNextRow());
    } catch (error) {
      Log.error(TAG, `querySourceBucket failed, error code:${error?.code} msg:${error?.message}`);
    } finally {
      resultSet?.close();
    }
    return;
  }

  // 处理相册内排序
  private async handlePhotoSortType(sourceSpPath: string, bucketResults: Map<string, string>): Promise<void> {
    let xmlStr = await TransferUtils.getXmlStr(sourceSpPath);
    let xmlElement = TransferUtils.transferSourceXmlToXmlElement(xmlStr);
    let spDataMap = TransferUtils.parseXmlElement(xmlElement);

    // 相册内排序 [ albumKey, sortRule, sortType ]
    let albumSortValueMap: [ string, AlbumGridSortRule, string ][] = [];

    for (let key of spDataMap.keys()) {
      // 虚拟相册类型
      if (key.startsWith(ALBUM_VIRTUAL_PREFIX)) {
        let value = spDataMap.get(key);
        if (value !== undefined) {
          let type = albumTypeMap.get(key.slice(key.lastIndexOf('/') + 1));
          let sortValue = sortValueMap.get(value.toString());
          if ((type !== undefined) && (sortValue !== undefined)) {
            albumSortValueMap.push([type.toString(), sortValue[0], sortValue[1]]);
          }
        }
      }
      // 实体相册类型
      if (key.startsWith(ALBUM_ENTITY_PREFIX)) {
        let value = spDataMap.get(key);
        if (value !== undefined) {
          let sortValue = sortValueMap.get(value.toString());
          let relativeBucketId = key.slice(key.lastIndexOf('/') + 1);
          let lpath = bucketResults.get(relativeBucketId)
          if ((sortValue !== undefined) && (lpath !== undefined)) {
            let entityAlbumKey = ALBUM_ENTITY_KEY_PREFIX + lpath;
            albumSortValueMap.push([entityAlbumKey, sortValue[0], sortValue[1]]);
          }
        }
      }
    }

    let context = this.context;
    // 设置加密级别 EL1
    context.area = contextConstant.AreaMode.EL1;
    for (let i = 0; i < albumSortValueMap.length; i++) {
      AlbumGridSortHelper.getInstance().setSortRuleEx(context, albumSortValueMap[i][0],
        albumSortValueMap[i][1], albumSortValueMap[i][2]);
    }
    return;
  }

  // 处理相册时间显示
  private async handleAlbumViewMode(sourceSpPath: string, bucketResults: Map<string, string>): Promise<void> {
    let xmlDataStr = await TransferUtils.getXmlStr(sourceSpPath);
    let xmlDataElement = TransferUtils.transferSourceXmlToXmlElement(xmlDataStr);
    let spViewModeMap = TransferUtils.parseXmlElement(xmlDataElement);

    // 相册时间显示 [ albumSubType, lpath, mode ]
    let albumViewModeMap: [ number, string, number ][] = [];

    for (let key of spViewModeMap.keys()) {
      // 虚拟相册类型
      if (key.startsWith(ALBUM_VIRTUAL_PREFIX)) {
        let value = spViewModeMap.get(key);
        if (value !== undefined) {
          let virtualAlbumType = albumTypeMap.get(key.slice(key.lastIndexOf('/') + 1));
          let lpath = '';
          let mode = gridViewMode.get(value.toString());
          if ((mode !== undefined) && (virtualAlbumType !== undefined)) {
            albumViewModeMap.push([virtualAlbumType, lpath, mode]);
          }
        }
      }
      // 实体相册类型
      if (key.startsWith(ALBUM_ENTITY_PREFIX)) {
        let value = spViewModeMap.get(key);
        if (value !== undefined) {
          let mode = gridViewMode.get(value.toString());
          let entityAlbumType: number = ENTITY_ALBUM_TYPE;
          let relativeBucketId = key.slice(key.lastIndexOf('/') + 1);
          let lpath = bucketResults.get(relativeBucketId);
          if ((mode !== undefined) && (lpath !== undefined)) {
            albumViewModeMap.push([entityAlbumType, lpath, mode]);
          }
        }
      }
    }

    // 设置加密级别 EL1
    let context = this.context;
    context.area = contextConstant.AreaMode.EL1;
    for (let i = 0; i < albumViewModeMap.length; i++) {
      AlbumUtils.saveViewMode(context, albumViewModeMap[i][0], albumViewModeMap[i][1], albumViewModeMap[i][2]);
    }
    return;
  }
}