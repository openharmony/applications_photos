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
import type { BundleVersion } from '@ohos.application.BackupExtensionAbility';
import lazy BackupExtensionAbility from '@ohos.application.BackupExtensionAbility';
import lazy bundleManager from '@ohos.bundle.bundleManager';
import lazy fileIo from '@ohos.file.fs';
import type { BusinessError } from '@ohos.base';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MapDataStore } from '@ohos/common/src/main/ets/default/utils/MapUtil';
import lazy { AlbumGridSortHelper, AlbumGridSortRule } from '@ohos/common/src/main/ets/default/model/AlbumGridSortHelper';
import lazy settings from '@ohos.settings';
import lazy { GridViewMode } from '@ohos/common/src/main/ets/default/view/grid/GridView';
import lazy { AlbumUtils } from '@ohos/common/src/main/ets/default/utils/AlbumUtils';
import lazy fs from '@ohos.file.fs';
import lazy relationalStore from '@ohos.data.relationalStore';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { RdbHelper } from '@ohos/common/src/main/ets/default/utils/RdbHelper';
import lazy { common, contextConstant, ErrorCode } from '@kit.AbilityKit';
import lazy TransferManager from './TransferManager'
import lazy { DataStoreUtil } from '@ohos/common/src/main/ets/default/utils/DataStoreUtil';
import lazy DatabaseOperationHelper from '@ohos/dataprovider/src/main/ets/database/DatabaseOperationHelper';
import lazy DatabaseProxy from '@ohos/dataprovider/src/main/ets/database/DatabaseProxy'
import { cloudSyncManager } from '@kit.CoreFileKit';
import userUtils from '@ohos/thirdselect/src/main/ets/default/utils/UserUtils';
import BackupExtensionContext from '@ohos.file.BackupExtensionContext';
import { RelationStoreUtil } from '@ohos/common/src/main/ets/default/utils/RelationStoreUtil';
import { HashMap } from '@kit.ArkTS';
import { global } from '@ohos/tools/src/main/global/Contexts';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { SyncAlbumUtil } from '@ohos/common/src/main/ets/default/utils/SyncAlbumUtil';
import { ValueType } from '@kit.ArkData';

const TAG: string = 'BackupExtensionCommon';
const BACKUP_ABILITY_PATH: string = 'data/storage/el2/base/files/';
const BACKUP_FILE_NAME: string = 'photoBackup.json';

const ALBUM_SORT_SP_FILE_NAME: string = 'photoSortType_pre.xml';
const ALBUM_SHOW_DATA_SP_FILE_NAME: string = 'albumViewMode_pre.xml';

const SETTINGS_KEY_PATH_MAP: Map<string, string> = new Map([
  ['persist.photos.ce.feature.enable', 'com.xxx.photos_preferences.xml'],
  ['persist.photos.ce.watermark.enable', 'com.xxx.photos_preferences.xml'],
  ['persist.photos.ce.protocol.enable', 'com.xxx.photos_preferences.xml'],
  ['persist.photos.ce.auto.option', 'com.xxx.photos_preferences.xml'],
  ['persist.photos.slideshow.interval', 'com.xxx.photos_preferences.xml'],
  ['photos_hdc_sync_bind_nas', 'com.xxx.photos_preferences.xml'],
  ['photos_hdc_sync_bind_nas_status', 'com.xxx.photos_preferences.xml'],
  ['photos_hdc_sync_bind_cloud_status', 'com.xxx.photos_preferences.xml'],
  ['photos_hdc_sync_bind_nas_user_key', 'com.xxx.photos_preferences.xml'],
  ['photos_hdc_sync_bind_nas_device_key', 'com.xxx.photos_preferences.xml'],
  ['photos_hdc_sync_account_register_status', 'com.xxx.photos_preferences.xml'],
  ['photos_all_album_upload', 'com.xxx.photos_preferences.xml'],
]);

const SETTINGS_KEY_DOUBLE_MAP: Map<string, string> = new Map([
  ['persist.photos.ce.feature.enable', 'key-photo-cloud-enhance'],
  ['persist.photos.ce.watermark.enable', 'key-cloud-enhance-watermark'],
  ['persist.photos.ce.auto.option', 'key-auto-enhance-type'],
  ['persist.photos.slideshow.interval', 'key-slide-show-setting'],
  ['persist.photos.ce.protocol.enable','key-photo-cloud-enhance'],
  ['photos_hdc_sync_bind_nas', 'SMART_STORE_BIND_KEY'],
  ['photos_hdc_sync_bind_nas_status', 'SMART_STORE_SYNC_STATUS_KEY'],
  ['photos_hdc_sync_bind_cloud_status', 'key-cloud-album-state'],
  ['photos_hdc_sync_bind_nas_user_key', 'SMART_STORE_SYNC_USER_KEY'],
  ['photos_hdc_sync_bind_nas_device_key', 'SMART_STORE_SYNC_DEVICE_KEY'],
  ['photos_hdc_sync_account_register_status', 'key-cloud-login-state'],
  ['photos_all_album_upload', 'sync_all'],
]);

const SETTINGS_KEY_DEF_VALUE_MAP: Map<string, string> = new Map([
  ['persist.photos.ce.feature.enable', 'true'],
  ['persist.photos.ce.watermark.enable', 'true'],
  ['persist.photos.ce.protocol.enable', 'close'],
  ['persist.photos.ce.auto.option', 'close'],
  ['persist.photos.slideshow.interval', '3'],
  ['photos_hdc_sync', ''],
  ['photos_sync_options', ''],
  ['photos_hdc_sync_account_register_status', ''],
  ['photos_hdc_sync_bind_nas', ''],
  ['photos_hdc_sync_bind_nas_status', ''],
  ['photos_hdc_sync_bind_cloud_status', ''],
  ['photos_hdc_sync_bind_nas_user_key', ''],
  ['photos_hdc_sync_bind_nas_device_key', ''],
  ['sync_all', '0'],
]);

const GALLERY_DB_NAME: string = 'gallery.db';
const GALLERY_TABLE_NAME: string = 'gallery_album';
const COLUMN_RELATIVE_BUCK_ID: string = 'relativeBucketId';
const COLUMN_LPATH: string = 'lPath';
const SELECT_LPATH: string =
  `SELECT ${COLUMN_RELATIVE_BUCK_ID},${COLUMN_LPATH} from ${GALLERY_TABLE_NAME} where ${COLUMN_RELATIVE_BUCK_ID} =`;
const ALBUM_SUB_TYPE_PHOTOS: number = 1031;
const ALBUM_SUB_TYPE_VIDEO: number = 1026;
const ALBUM_SUB_TYPE_FAVOR: number = 1025;
const ALBUM_SUB_TYPE_CLOUD_ENHANCED: number = 1032;
const OPTIONS_NONE: string = '0';
const OPTIONS_CLOUD: string = '1';
const OPTIONS_HOME: string = '2';

const GALLERY_CONFIG: relationalStore.StoreConfig = {
  name: GALLERY_DB_NAME, // 数据库文件名
  securityLevel: relationalStore.SecurityLevel.S1, // 数据库安全级别
};

interface BackupInfo {
  scale: number,

  //云增强开关
  cloudEnhanced: string,

  //云增强水印开关
  cloudEnhancedWatermark: string,

  //云增强隐私协议同意状态
  cloudEnhancedPrivacyAgreement: string,

  //自动云增强
  autoCloudEnhanced: string,

  //幻灯片播放时间
  slideshowTime: string,

  // 是否在四宫格和分组视图之间切换过
  isChangedView: boolean,

  // 气泡是否关闭
  isClosedGuide: boolean,

  // 最后一次关闭提醒向导的时间
  lastGuideOptTime: number,

  // 已经关闭提醒向导的次数
  showGuideCount: number,

  // 家庭存储同步状态
  photosHdcSync: string,

  // 同步开关状态
  photosOptionsSync: string,

  // 相册全部同步开关
  photosAllAlbumUpload: string,
}

export default class BackupExtensionCommon extends BackupExtensionAbility {
  public async onBackup(): Promise<void> {
    Log.info(TAG, 'onBackup start');
    try {
      let filePath: string = BACKUP_ABILITY_PATH + BACKUP_FILE_NAME;
      let file = await fileIo.open(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      Log.info(TAG, 'onBackup openSync success');
      // 备份视图切换向导参数
      const hasChangedView = await DataStoreUtil.getInstance().getData(Constants.DAY_GROUP_HAS_CHANGED, false);
      const hasClosedGuide = await DataStoreUtil.getInstance().getData(Constants.GUIDE_HAS_CLOSED, false);
      const lastOptTime: number = await DataStoreUtil.getInstance().getData(Constants.GUIDE_LAST_OPT_TIME, 0);
      const showCount: number = await DataStoreUtil.getInstance().getData(Constants.GUIDE_SHOW_COUNT, 1);
      Log.info(TAG, `onBackup DayGuide:${hasChangedView} ${hasClosedGuide} ${lastOptTime} showCount:${showCount}`);
      let scale: number = 1;
      await DataStoreUtil.getInstance().getData('albumStyle', '').then((value: ValueType): void => {
        scale = value as number;
      })
      let msg: BackupInfo = {
        scale: scale,
        cloudEnhanced: this.getSettingsByBackupInfo('persist.photos.ce.feature.enable'),
        cloudEnhancedWatermark: this.getSettingsByBackupInfo('persist.photos.ce.watermark.enable'),
        cloudEnhancedPrivacyAgreement: this.getSettingsByBackupInfo('persist.photos.ce.protocol.enable'),
        autoCloudEnhanced: this.getSettingsByBackupInfo('persist.photos.ce.auto.option'),
        slideshowTime: this.getSettingsByBackupInfo('persist.photos.slideshow.interval'),
        isChangedView: hasChangedView,
        isClosedGuide: hasClosedGuide,
        lastGuideOptTime: lastOptTime,
        showGuideCount: showCount,
        photosHdcSync: this.getSettingsByBackupInfo('photos_hdc_sync'),
        photosOptionsSync: this.getSettingsByBackupInfo('photos_sync_options'),
        photosAllAlbumUpload: SyncAlbumUtil.getValueSync(this.context)
      };
      let str: string = JSON.stringify(msg);
      Log.info(TAG, `onBackup content : ${str}`);
      /* instrument ignore next */
      fileIo.write(file.fd, str, (err: BusinessError, writeLen: number) => {
        if (err) {
          Log.error(TAG, 'write data to file failed with error message : ' + err.message + `, error code: ${err.code}`);
        } else {
          Log.info(TAG, `write data to file succeed and size is : ${writeLen}`);
        }
        Log.info(TAG, `[fd flag] onBackup, closeSync fd: ${file?.fd}`);
        fileIo.closeSync(file);
      });
    } catch (e) {
      Log.error(TAG, `write data to file error : ${JSON.stringify(e)}`);
    } finally {
      Log.info(TAG, 'onBackup ok');
    }
  }

  private getSameAccountInfo(restoreInfo: string): boolean {
    Log.info(TAG, `msg: ${restoreInfo}`);
    if (!restoreInfo.includes('isSameAccountId')) {
      Log.error(TAG, `clone no have SameAccountId`);
      return false;
    }
    let jsonObj: Object = JSON.parse(restoreInfo);
    let commObj = (jsonObj as Record<string, Object>);
    let commRecord = (commObj as Record<string, Object>);
    let keyStr = Object.keys(commRecord);

    let hashMapData: HashMap<string, Object> = new HashMap();
    for (let index: number = 0; index < keyStr.length; index++) {
      let sameAccountInfo: string = JSON.stringify(commRecord[keyStr[index]]);
      Log.info(TAG, `sameAccountInfo: ${sameAccountInfo}`);
      if (!sameAccountInfo.includes('isSameAccountId')) {
        continue;
      }
      let commObj2 = (commRecord[keyStr[index]] as Record<string, Object>);
      let commRecord2 = (commObj2 as Record<string, Object>);
      let keyStr2 = Object.keys(commRecord2);
      for (let index2: number = 0; index2 < keyStr.length; index2++) {
        hashMapData.set(keyStr2[index2], commRecord2[keyStr2[index2]]);
      }
    }
    let detail: boolean = hashMapData.get('detail') as boolean;
    Log.info(TAG, `detail: ${detail}`);
    return detail;
  }

  public async onRestoreEx(bundleVersion: BundleVersion, restoreInfo: string): Promise<string> {
    Log.info(TAG, `onRestoreEx start: ${JSON.stringify(restoreInfo)}`);
    let isSameAccount: boolean = this.getSameAccountInfo(restoreInfo)??false;
    Log.info(TAG, `isSameAccount: ${isSameAccount}`);
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT;
    try {
      let data = bundleManager.getBundleInfoForSelfSync(bundleFlags);
      Log.info(TAG, `restore ok ${JSON.stringify(bundleVersion)} bundleName: ${data.name}`);
      // xxx
      if (bundleVersion.name.startsWith('99.99.99.999')) {
        Log.info(TAG, 'homs2next start');
        await this.doRestoreHomsToNext(isSameAccount);
      } else if (bundleVersion.name.startsWith('0.0.0.0')) {
        let transferManager = new TransferManager(this.context);
        await transferManager.transferData();
        await this.doRestoreSyncOptionNasUpgrade();
      } else {
        // 配置为非覆盖模式后，此处执行手动覆盖. xxx、xxx文件路径在备份时已处理
        await this.recoverManually();
        // xxx恢复
        await this.doRestoreOperation(isSameAccount);
      }
      await this.disconnectDb();
    } catch (e) {
      Log.error(TAG, `restore error: ${JSON.stringify(e)}`);
    }
    return '';
  }

  public async onRestore(bundleVersion: BundleVersion): Promise<void> {
    Log.info(TAG, 'onRestore start');
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT;
    try {
      let data = bundleManager.getBundleInfoForSelfSync(bundleFlags);
      Log.info(TAG, `restore ok ${JSON.stringify(bundleVersion)} bundleName: ${data.name}`);
      // xxx
      if (bundleVersion.name.startsWith('99.99.99.999')) {
        Log.info(TAG, 'homs2next start');
        await this.doRestoreHomsToNext(false);
      } else if (bundleVersion.name.startsWith('0.0.0.0')) {
        let transferManager = new TransferManager(this.context);
        await transferManager.transferData();

        await this.doRestoreSyncOptionNasUpgrade();
      } else {
        // 配置为非覆盖模式后，此处执行手动覆盖. xxx、xxx文件路径在备份时已处理
        await this.recoverManually();
        // xxx恢复
        await this.doRestoreOperation(false);
      }
      await this.disconnectDb();
    } catch (e) {
      Log.error(TAG, `restore error: ${JSON.stringify(e)}`);
    }
  }

  private setUpdateAlbumsBackupInfo(key: String, oldStatus: string): void {
    let localPhotosUpdateStatus = SyncAlbumUtil.getValueSync(this.context);
    let value: string = '0';
    if (oldStatus === 'undefined') {
      value = localPhotosUpdateStatus;
    } else {
      value = ((oldStatus === '1') && (localPhotosUpdateStatus === '1')) ? '1' : '0'
    }
    Log.info(TAG, `value :` + value + ` oldStatus:` + oldStatus +
      ` localPhotosUpdateStatus:` + localPhotosUpdateStatus);
    try {
      settings.setValueSync(this.context, key.toString(), value);
    } catch (err) {
      Log.error(TAG, `Set settings db error: ${err}`);
    }
  }

  /**
   * 图库卡片, onRestore之后，主动断开El2PhotosData.db数据库连接，防止句柄指向错误
   */
  private async disconnectDb(): Promise<void> {
    try {
      Log.info(TAG, 'onRestore disconnectDb start');
      await DatabaseOperationHelper.with().disconnect();
      DatabaseOperationHelper.with().tryInitDatabase();
      Log.info(TAG, 'onRestore disconnectDb end');
    } catch (e) {
      Log.error(TAG, `onRestore disconnectDb error ${JSON.stringify(e)}`);
    }
  }

  /**
   * 拷贝文件或者文件夹（支持文件名过滤）
   * @param srcFolder 源文件夹路径
   * @param destFolder 目标文件夹路径
   * @param filter 文件名过滤函数
   * @param copyFn 文件拷贝函数
   * @returns Promise<boolean>
   */
  async copyByFilter(
    srcFolder: string,
    destFolder: string,
    filter?: (fileName: string) => boolean,
    copyFn?: (fileName: string, srcPath: string, desPath: string) => Promise<void | undefined>
  ): Promise<boolean> {
    let listFileNames: string[] = [];

    try {
      listFileNames = await fs.listFile(srcFolder);
      if (!listFileNames || listFileNames.length === 0) {
        Log.debug(TAG, `${srcFolder} is empty`);
        return false;
      }
    } catch (error) {
      Log.info(TAG, `listFile for ${srcFolder} failed: ${error}`);
      return false;
    }

    for (const fileName of listFileNames) {
      let srcPath = `${srcFolder}/${fileName}`;
      let destPath = `${destFolder}/${fileName}`;

      let isFile: boolean = false;
      try {
        const st = await fs.stat(srcPath);
        isFile = st.isFile();
      } catch (error) {
        Log.info(TAG, `stat for listed ${srcPath} failed: ${error}`);
        return false;
      }

      if (isFile) {
        // 如果是文件，检查过滤条件
        if (!filter || filter(fileName)) {
          try {
            // 拷贝文件
            if (copyFn) {
              await copyFn(fileName, srcPath, destPath);
            } else {
              await fs.copyFile(srcPath, destPath);
            }
          } catch (error) {
            Log.info(TAG, `copyFile for listed ${srcPath} failed: ${error}`);
          }
        }
      } else {
        // 如果是文件夹
        continue;
      }
    }

    return true;
  }

  private async recoverManually() {
    Log.info(TAG, `recoverManually begin...`);
    // 卡片数据库断连
    Log.info(TAG, `------------ disconnect FaCard RdbStore begin ------------`);
    await DatabaseProxy.getInstance().disconnect();
    Log.info(TAG, `------------ disconnect FaCard RdbStore end ------------`);

    let backupDir: string = this.context.backupDir + 'restore';
    let destDir: string = this.context.databaseDir + '/rdb';

    // 备份后删除卡片数据库(旧机, 供后续数据融合)
    let srcDir = backupDir + '/data/storage/el2/database/phone_photos/rdb';
    Log.info(TAG, `recoverManually backup old database ${srcDir}`);
    let res = await this.copyByFilter(
      srcDir,
      destDir,
      (fileName) => fileName.includes('El2PhotosData'),
      async (fileName: string, srcPath: string, desPath: string) => {
        try {
          // 删除历史备份文件
          if (fileName.includes('old-El2PhotosData')) {
            Log.debug(TAG, `unlink history db file: ${srcPath}`);
            await fs.unlink(srcPath);
            return;
          }

          // 拷贝并重命名文件
          const renamed = desPath.replace(fileName, 'old-' + fileName);
          Log.debug(TAG, `copy ${fileName}: ${srcPath} => ${renamed}`);
          await fs.copyFile(srcPath, renamed);

          // 删除旧机卡片数据库
          Log.debug(TAG, `unlink db file of old device: ${srcPath}`);
          await fs.unlink(srcPath);
        } catch (error) {
          Log.info(TAG, `copyFn for ${srcPath} failed: ${error}`);
        }
      }
    );
    if (!res) {
      Log.error(TAG, `recoverManually backup old database failed`);
      return;
    }

    await RelationStoreUtil.getInstance().disconnect();
    this.context.area = contextConstant.AreaMode.EL1;
    destDir = this.context.databaseDir + '/rdb';

    // 迁移相册数据库
    srcDir = backupDir + '/data/storage/el1/database/phone_photos/rdb';
    Log.info(TAG, `recoverManually backup old database ${srcDir} to ${destDir}`);
    res = await this.copyByFilter(
      srcDir,
      destDir,
      (fileName) => fileName.includes('album'),
      async (fileName: string, srcPath: string, desPath: string) => {
        try {
          Log.info(TAG, `copy db file srcPath: ${srcPath}, desPath: ${desPath}`)
          await fs.copyFile(srcPath, desPath);

          // 删除旧机相册数据库
          Log.debug(TAG, `unlink db file of old device: ${srcPath}`);
          await fs.unlink(srcPath);
        } catch (error) {
          Log.info(TAG, `copyFn for ${srcPath} failed: ${error}`);
        }
      }
    );
    if (!res) {
      Log.error(TAG, `recoverManually backup album old database failed`);
      return;
    }

    this.context.area = contextConstant.AreaMode.EL2;

    // 将备份数据中data/storage目录中全量覆盖至/data/storage
    let storage: string = '/data/storage/';
    srcDir = backupDir + storage;
    Log.info(TAG, `recoverManually full recover begin ${srcDir} => ${storage}`);
    try {
      await fs.copyDir(srcDir, storage, 1);
    } catch (error) {
      Log.error(TAG, `recoverManually full recover failed: ${error}`);
    }

    Log.info(TAG, `recoverManually end`);
  }

  private async moveFiles(sourcePath: string, targetPath: string): Promise<boolean> {
    try {
      if (!fs.access(sourcePath)) {
        Log.info(TAG, `not found source path`);
        return false;
      }
      let listFileNames: string[] = fs.listFileSync(sourcePath);
      if (!listFileNames || listFileNames.length === 0) {
        return false;
      }
      if (!fs.access(targetPath)) {
        fs.mkdirSync(targetPath, true);
      }
      listFileNames.forEach((fileName: string) => {
        let srcPath: string = `${sourcePath}/${fileName}`;
        let destPath: string = `${targetPath}/${fileName}`;
        if (!fs.statSync(srcPath).isFile()) {
          Log.info(TAG, `Skip directory: ${fileName}`);
          return;
        }
        if (!fileName.includes('gallery')) {
          Log.info(TAG, `Skip file: ${fileName}`);
          return;
        }
        fs.copyFile(srcPath, destPath);
      });
      Log.info(TAG, `copy succ`);
      return true;
    } catch (error) {
      Log.error(TAG, `copy error, errorCode:${error.code}, errorMessage:${error.message}`);
      return false;
    }
  }

  private async getLpathFormGalleryDB(key: string): Promise<string> {
    //设置context当前级别，以确认当前查询的gallery.db地址正确
    this.context.area = contextConstant.AreaMode.EL2;
    let store: relationalStore.RdbStore | undefined = await RdbHelper.getRdb(this.context, GALLERY_CONFIG);
    if (!store) {
      Log.error(TAG, 'Failed to get rdb');
      return '';
    }
    try {
      const resultSet = await store.querySql(SELECT_LPATH + key);
      try {
        let lPath: string = '';
        while (resultSet.goToNextRow()) {
          const relativeBucketId: string =
            resultSet.getValue(resultSet.getColumnIndex(COLUMN_RELATIVE_BUCK_ID)) as string;
          const lpath: string = resultSet.getValue(resultSet.getColumnIndex(COLUMN_LPATH)) as string;
          if (relativeBucketId === key) {
            lPath = lpath;
          }
        }
        return lPath;
      } finally {
        resultSet.close();
      }
    } catch (error) {
      Log.error(TAG, `Failed to execute query, errorCode:${error.code}, errorMessage:${error.message}`);
      return '';
    }
  }

  private async setSettingValue(value: string, doubleKey: string | undefined, singleKey: string): Promise<string> {
    switch (doubleKey) {
      case 'SMART_STORE_BIND_KEY':
      case 'SMART_STORE_SYNC_STATUS_KEY':
      case 'key-cloud-album-state':
      case 'SMART_STORE_SYNC_USER_KEY':
      case 'SMART_STORE_SYNC_DEVICE_KEY':
      case 'key-photo-cloud-enhance':
      case 'key-cloud-enhance-watermark':
        value = value;
        break;
      case 'key-auto-enhance-type':
        if (value == '0') {
          value = 'close';
          break;
        } else if (value == '1') {
          value = 'WLAN only';
          break;
        } else if (value == '2') {
          value = 'WLAN and networks';
          break;
        }
        break;
      case 'key-slide-show-setting':
        if (value == '0') {
          value = '3';
          break;
        } else if (value == '1') {
          value = '5';
          break;
        } else if (value == '2') {
          value = '10';
          break;
        } else if (value == '3') {
          value = '15';
          break;
        }
        break;
      case 'key-photo-cloud-enhance':
        if (value == '1') {
          value = 'true';
          break;
        } else if (value == '0') {
          value = 'close';
          break;
        }
        break;
      case 'sync_all':
        Log.info(TAG, `value : ${value} , getValueSync : ${SyncAlbumUtil.getValueSync(this.context)}`);
        if (SyncAlbumUtil.getValueSync(this.context) === '1' && value === '1') {
          value = '1'
        } else {
          value = '0'
        }
        break;
      default:
        Log.error(TAG, `${doubleKey} value parse err`);
        break;
    }
    if (value != undefined || value != null) {
      Log.info(TAG, `Set settings key: ${singleKey}, value:${value}`);
      this.setSettingsByBackupInfo(singleKey, value);
      return value;
    }
    return value;
  }

  private setSettingsByBackupInfo(key: String, interval: number | string): void {
    try {
      settings.setValueSync(this.context, key.toString(), interval.toString());
    } catch (err) {
      Log.error(TAG, `Set settings db error: ${err}`);
    }
  }

  private setSortRule(context: Context, albumKey: string, rule: AlbumGridSortRule, sortType: string): void {
    /*
     * 针对截图做定制化设置
     * 双截图相册lapth = /Pictures/Screenshots
     * 单上会解析成截图相册lpath = /Pictures/Screenshots,和屏幕录制相册lpath = Pictures/Screenrecords
     */
    if (albumKey.endsWith('2049/Pictures/Screenshots')) {
      AlbumGridSortHelper.getInstance().setSortRuleEx(context, '2049/Pictures/Screenrecords', rule, sortType);
    }
    AlbumGridSortHelper.getInstance().setSortRuleEx(context, albumKey, rule, sortType);
  }

  private saveViewMode(context: Context, subType: number | undefined, lpath: string | undefined,
    mode: GridViewMode | undefined): void {
    if (lpath?.endsWith('Pictures/Screenshots')) {
      AlbumUtils.saveViewMode(context, subType, '/Pictures/Screenrecords', mode);
    }
    AlbumUtils.saveViewMode(context, subType, lpath, mode);
  }

  public getSettingsByBackupInfo(key: string): string {
    let option: string = '';
    try {
      option = settings.getValueSync(this.context, key.toString(), SETTINGS_KEY_DEF_VALUE_MAP.get(key));
      Log.info(TAG, `Get ${key} is: ${option}`);
    } catch (err) {
      Log.error(TAG, `Get auto AI cloud enhance error: ${err}`);
    }
    return option;
  }

  private async readAndParseSettingFile(filePath: string, key: string): Promise<string> {
    const file = await fileIo.open(filePath, fileIo.OpenMode.READ_ONLY);
    Log.info(TAG, 'open file data succeed');
    const buffer = new ArrayBuffer(64 * 1024);
    const result = new Map<string, string>();
    let totalContent = '';

    return new Promise((resolve, reject) => {
      const readChunk = () => {
        fileIo.read(file.fd, buffer, (err, readLen) => {
          if (err) {
            Log.error(TAG, 'read XML file failed: ' + err.message);
            reject(err);
            return;
          }
          if (readLen === 0) {
            parseContent(totalContent);
            fileIo.closeSync(file);
            resolve(result.get(key) || '');
            return;
          }
          const chunk = String.fromCharCode(...new Uint8Array(buffer.slice(0, readLen)));
          totalContent += chunk;
          readChunk();
        });
      };

      const parseContent = (content: string) => {
        const lines = content.split('\n');
        lines.forEach(line => {
          Log.info(TAG, `read file data succeed = ${line}`);
          if (line.trim().startsWith('<boolean') || line.trim().startsWith('<int')) {
            const nameMatch = line.match(/name="([^"]*)"/);
            const valueMatch = line.match(/value="([^"]*)"/);
            if (nameMatch && valueMatch) {
              const name = nameMatch[1];
              result.set(name, valueMatch[1]);
            }
          } else if (line.trim().startsWith('<string')) {
            const nameMatch = line.match(/name="([^"]*)"/);
            const valueMatch = line.match(/>([^<]*)</);
            if (nameMatch && valueMatch) {
              const name = nameMatch[1];
              result.set(name, valueMatch[1]);
            }
          }
        });
      };
      readChunk();
    });
  }


  private async readAndParseXmlFile(filePath: string): Promise<Map<string, string>> {
    const file = await fileIo.open(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    const result = new Map<string, string>();
    Log.info(TAG, 'file open succeed');

    return new Promise((resolve, reject) => {
      const buffer = new ArrayBuffer(64 * 1024);
      let content = '';

      const readChunk = () => {
        fileIo.read(file.fd, buffer, (err, readLen) => {
          if (err) {
            Log.error(TAG, 'read XML file failed: ' + err.message);
            reject(err);
            return;
          }

          if (readLen === 0) {
            parseContent(content);
            fileIo.closeSync(file);
            resolve(result);
            return;
          }

          const chunk = String.fromCharCode(...new Uint8Array(buffer.slice(0, readLen)));
          content += chunk;
          readChunk();
        });
      };

      const parseContent = (content: string) => {
        const lines = content.split('\n');
        lines.forEach(line => {
          Log.info(TAG, `read file data succeed = ${line}`);
          if (line.trim().startsWith('<int')) {
            const nameMatch = line.match(/name="([^"]*)"/);
            const valueMatch = line.match(/value="([^"]*)"/);

            if (nameMatch && valueMatch) {
              const name = nameMatch[1];
              const value = valueMatch[1];
              result.set(name, value);
            }
          }
        });
      };

      readChunk();
    });
  }

  private async processAndSaveViewMode(mapData: Map<string, string>): Promise<void> {
    for (const entry of mapData) {
      const name = entry[0];
      const value = entry[1];
      const isVirtualAlbum = name.startsWith('/gallery/album/virtual/common/*');
      let subType: number;
      let lpath: string = ''

      if (isVirtualAlbum) {
        const type = parseInt(name.split('/').pop()!);
        switch (type) {
          case 0:
            subType = ALBUM_SUB_TYPE_PHOTOS;
            break;
          case 1:
            subType = ALBUM_SUB_TYPE_VIDEO;
            break;
          case 2:
            subType = ALBUM_SUB_TYPE_FAVOR;
            break;
          case 3:
            subType = ALBUM_SUB_TYPE_CLOUD_ENHANCED;
            break;
          default:
            continue;
        }
      } else if (name.startsWith('/gallery/album/entity')) {
        const hash = name.split('/').pop()!;
        lpath = await this.getLpathFormGalleryDB(hash);
        subType = 2049;
      } else {
        continue;
      }
      let mode: GridViewMode = GridViewMode.GRID;
      if (value == '0') {
        mode = GridViewMode.GRID;
      } else if (value == '1') {
        mode = GridViewMode.GROUP;
      }
      this.context.area = contextConstant.AreaMode.EL1;
      this.saveViewMode(this.context, subType, lpath, mode);
    }
    this.context.area = contextConstant.AreaMode.EL2;
  }

  private async processAndSavePhotoSort(mapData: Map<string, string>): Promise<void> {
    for (const entry of mapData) {
      const name = entry[0];
      const value = entry[1];
      Log.info(TAG, `Processing name: ${name}, value: ${value}`);
      const isVirtualAlbum = name.startsWith('/gallery/album/virtual/common/*');
      let albumKey: string;

      if (isVirtualAlbum) {
        const type = parseInt(name.split('/').pop()!);
        switch (type) {
          case 0:
            albumKey = ALBUM_SUB_TYPE_PHOTOS.toString();
            break;
          case 1:
            albumKey = ALBUM_SUB_TYPE_VIDEO.toString();
            break;
          case 2:
            albumKey = ALBUM_SUB_TYPE_FAVOR.toString();
            break;
          case 3:
            albumKey = ALBUM_SUB_TYPE_CLOUD_ENHANCED.toString();
            break;
          default:
            continue;
        }
      } else if (name.startsWith('/gallery/album/entity')) {
        const hash = name.split('/').pop()!;
        let lpath = await this.getLpathFormGalleryDB(hash);
        albumKey = `2049${lpath}`;
      } else {
        continue;
      }
      let rule: AlbumGridSortRule;
      let sortType: string;
      switch (value) {
        case '0':
          rule = AlbumGridSortRule.SHOOT_TIME;
          sortType = 'DESC';
          break;
        case '1':
          rule = AlbumGridSortRule.SHOOT_TIME;
          sortType = 'ASC';
          break;
        case '2':
          rule = AlbumGridSortRule.CREATE_TIME;
          sortType = 'DESC';
          break;
        case '3':
          rule = AlbumGridSortRule.CREATE_TIME;
          sortType = 'ASC';
          break;
        case '4':
          rule = AlbumGridSortRule.FILE_NAME;
          sortType = 'DESC';
          break;
        case '5':
          rule = AlbumGridSortRule.FILE_NAME;
          sortType = 'ASC';
          break;
        case '6':
          rule = AlbumGridSortRule.FILE_SIZE;
          sortType = 'DESC';
          break;
        case '7':
          rule = AlbumGridSortRule.FILE_SIZE;
          sortType = 'ASC';
          break;
        default:
          Log.warn(TAG, `Unknown value: ${value}`);
          continue;
      }
      Log.info(TAG, `processAndSavePhotoSort albumKey:${albumKey}; rule:${rule}; sortType:${sortType}`);
      this.context.area = contextConstant.AreaMode.EL1;
      this.setSortRule(this.context, albumKey, rule, sortType);
    }
    AlbumGridSortHelper.getInstance().resume(this.context);
    this.context.area = contextConstant.AreaMode.EL2;
  }

  private async setSetings(key: string, value: string | undefined): Promise<string> {
    if (value !== undefined) {
      this.setSettingsByBackupInfo(key, value);
      return value;
    } else {
      let dirPath = this.context.backupDir + 'restore/' + SETTINGS_KEY_PATH_MAP.get(key);
      let doubleKey = SETTINGS_KEY_DOUBLE_MAP.get(key) || '';
      try {
        let value = await this.readAndParseSettingFile(dirPath, doubleKey);
        value = await this.setSettingValue(value, doubleKey, key);
        return value;
      } catch (error) {
        Log.error(TAG, `set setting db error, errorCode:${error.code}, errorMessage:${error.message}`);
        return '';
      }
    }
  }

  private async setSetingsByDoubleKey(key: string): Promise<string> {
    let dirPath = this.context.backupDir + 'restore/' + SETTINGS_KEY_PATH_MAP.get(key);
    let doubleKey = SETTINGS_KEY_DOUBLE_MAP.get(key) || '';
    try {
      let value = await this.readAndParseSettingFile(dirPath, doubleKey);
      Log.info(TAG, `setSetingsByDoubleKey key: ${key}, value: ${value}`);
      value = await this.setSettingValue(value, doubleKey, key);
      return value;
    } catch (error) {
      Log.error(TAG, `set setting db error, errorCode:${error.code}, errorMessage:${error.message}`);
      return '';
    }
  }

  private async doRestoreHomsToNext(isSameAccount: boolean): Promise<void> {
    let sourcePath: string = this.context.backupDir + 'restore/';
    let targetPath: string = this.context.databaseDir + '/rdb';
    await this.moveFiles(sourcePath, targetPath);
    let cloudEnhancementSwitch = await this.setSetings('persist.photos.ce.protocol.enable', undefined);
    let cloudWatermarkSwitch = await this.setSetings('persist.photos.ce.watermark.enable', undefined);
    let slideshowTime = await this.setSetings('persist.photos.slideshow.interval', undefined);
    this.doRestoreSyncOptionNasClone(isSameAccount);
    const sortMap: Map<string, string> =
      await this.readAndParseXmlFile(this.context.backupDir + 'restore/' + ALBUM_SORT_SP_FILE_NAME);
    if (sortMap != undefined && sortMap.size != 0) {
      await this.processAndSavePhotoSort(sortMap);
    }
    const showDateMap: Map<string, string> =
      await this.readAndParseXmlFile(this.context.backupDir + 'restore/' + ALBUM_SHOW_DATA_SP_FILE_NAME);
    if (showDateMap != undefined && showDateMap.size != 0) {
      await this.processAndSaveViewMode(showDateMap);
    }

    const recordMsg: Record<string, number | string> = {
      'OLD_DEVICE_FRAME_WORK': 'double',
      'CLOUD_ENHANCE_SWITCH': cloudEnhancementSwitch,
      'WATERMARK_SWITCH': cloudWatermarkSwitch,
      'SLIDESHOW_TIME': slideshowTime,
      'SORT_COUNT': sortMap.size,
      'SLIDESHOW_COUNT': showDateMap.size,
    };
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_LIBRARY_CLONE, recordMsg);
  }

  private async doRestoreSingleSyncOptionNasClone(isSameAccount: boolean, msg: BackupInfo): Promise<void> {
    Log.info(TAG, `sync option single clone restore`);
    if (!isSameAccount) {
      Log.error(TAG, `single clone option not same account: ${isSameAccount}`);
      return;
    }
    // 还原全部相册同步信息
    this.setUpdateAlbumsBackupInfo(Constants.PHOTO_ALL_ALBUMS_UPLOAD_STATUS, msg.photosAllAlbumUpload ?? 'undefined');
    Log.info(TAG, `restore photosAllAlbumUpload: ${msg.photosAllAlbumUpload}`);
    let photosSyncOptions: string = this.getSettingsByBackupInfo('photos_sync_options');
    Log.info(TAG, `photosSyncOptions: ${photosSyncOptions}`);
    Log.info(TAG, `photosSyncOptions msg: ${msg.photosOptionsSync}`);
    Log.info(TAG, `hdc msg: ${msg.photosHdcSync}`);
    this.setSettingsByBackupInfo('photos_sync_options_restore_status', 'true');
    Log.info(TAG, `photosHdcSync: ${msg.photosHdcSync}`);
    switch (msg.photosOptionsSync) {
      case OPTIONS_NONE:
        Log.info(TAG, `OPTIONS_NONE`);
        break;
      case OPTIONS_CLOUD:
        Log.info(TAG, `OPTIONS_CLOUD`);
        break;
      case OPTIONS_HOME:
        Log.info(TAG, `OPTIONS_HOME`);
        break;
      default:
        break;
    }
  }

  private async doRestoreSyncOptionNasClone(isSameAccount: boolean): Promise<void> {
    Log.info(TAG, `sync option clone restore`);
    if (!isSameAccount) {
      Log.error(TAG, `clone option not same account: ${isSameAccount}`);
      return;
    }
    await this.setSetingsByDoubleKey('photos_all_album_upload');
    this.setSettingsByBackupInfo('photos_sync_options_restore_status', 'true');
    let hdcSyncAccountStatus: string = await this.setSetingsByDoubleKey('photos_hdc_sync_account_register_status');
    let hdcSyncBindNas: string = await this.setSetingsByDoubleKey('photos_hdc_sync_bind_nas');
    let hdcSyncBindNasStatus: string = await this.setSetingsByDoubleKey('photos_hdc_sync_bind_nas_status');
    let hdcSyncBindCloudStatus: string = await this.setSetingsByDoubleKey('photos_hdc_sync_bind_cloud_status');
    let hdcSyncBindNasUserKey: string = await this.setSetingsByDoubleKey('photos_hdc_sync_bind_nas_user_key');
    let hdcSyncBindNasDeviceKey: string = await this.setSetingsByDoubleKey('photos_hdc_sync_bind_nas_device_key');
    Log.info(TAG, `hdcSyncAccountStatus: ${hdcSyncAccountStatus}`);
    Log.info(TAG, `hdcSyncBindNas: ${hdcSyncBindNas}`);
    Log.info(TAG, `hdcSyncBindNasStatus: ${hdcSyncBindNasStatus}`);
    Log.info(TAG, `hdcSyncBindCloudStatus: ${hdcSyncBindCloudStatus}`);
    Log.info(TAG, `hdcSyncBindNasUserKey: ${hdcSyncBindNasUserKey}`);
    Log.info(TAG, `hdcSyncBindNasDeviceKey: ${hdcSyncBindNasDeviceKey}`);
    if (hdcSyncAccountStatus === '1') {
      if (hdcSyncBindNas === 'true') {
        let hdcSyncValue: string = hdcSyncBindNasUserKey + '|' + hdcSyncBindNasDeviceKey + '|false';
        this.setSettingsByBackupInfo('photos_hdc_sync', hdcSyncValue);
      }
      let photosSyncOptions: string = this.getSettingsByBackupInfo('photos_sync_options');
      Log.info(TAG, `photosSyncOptions: ${photosSyncOptions}`);
      let photosSyncOptionsAfter: string = '';
      if (hdcSyncBindCloudStatus === '1' && hdcSyncBindNasStatus === 'true') {
        Log.info(TAG, `double open`);
        this.setSettingsByBackupInfo('photos_sync_options_double_status', '1');
        photosSyncOptionsAfter = OPTIONS_CLOUD;
      } else {
        Log.info(TAG, `single open`);
        if (hdcSyncBindCloudStatus === '1') {
          Log.info(TAG, `cloud open`);
          photosSyncOptionsAfter = OPTIONS_CLOUD;
        } else if (hdcSyncBindNasStatus === 'true') {
          Log.info(TAG, `nas open`);
          photosSyncOptionsAfter = OPTIONS_HOME;
          let hdcSyncValue: string = hdcSyncBindNasUserKey + '|' + hdcSyncBindNasDeviceKey + '|true';
          this.setSettingsByBackupInfo('photos_hdc_sync', hdcSyncValue);
        } else {
          Log.info(TAG, `all not open`);
          photosSyncOptionsAfter = OPTIONS_NONE;
        }
      }
      switch (photosSyncOptionsAfter) {
        case OPTIONS_NONE:
          Log.info(TAG, `OPTIONS_NONE`);
          break;
        case OPTIONS_CLOUD:
          Log.info(TAG, `OPTIONS_CLOUD`);
          break;
        case OPTIONS_HOME:
          Log.info(TAG, `OPTIONS_HOME`);
          break;
        default:
          break;
      }
    }
  }

  private async doRestoreSyncOptionNasUpgrade(): Promise<void> {
    Log.info(TAG, `doRestoreSyncOptionNasUpgrade`);
    this.setSettingsByBackupInfo('photos_sync_options_restore_status', 'true');
    let hdcSyncAccountStatus = this.getSettingsByBackupInfo('photos_hdc_sync_account_register_status');
    let hdcSyncBindNas = this.getSettingsByBackupInfo('photos_hdc_sync_bind_nas');
    let hdcSyncBindNasStatus = this.getSettingsByBackupInfo('photos_hdc_sync_bind_nas_status');
    let hdcSyncBindCloudStatus = this.getSettingsByBackupInfo('photos_hdc_sync_bind_cloud_status');
    let hdcSyncBindNasUserKey = this.getSettingsByBackupInfo('photos_hdc_sync_bind_nas_user_key');
    let hdcSyncBindNasDeviceKey = this.getSettingsByBackupInfo('photos_hdc_sync_bind_nas_device_key');
    Log.info(TAG, `hdcSyncAccountStatus: ${hdcSyncAccountStatus}`);
    Log.info(TAG, `hdcSyncBindNas: ${hdcSyncBindNas}`);
    Log.info(TAG, `hdcSyncBindNasStatus: ${hdcSyncBindNasStatus}`);
    Log.info(TAG, `hdcSyncBindCloudStatus: ${hdcSyncBindCloudStatus}`);
    Log.info(TAG, `hdcSyncBindNasUserKey: ${hdcSyncBindNasUserKey}`);
    Log.info(TAG, `hdcSyncBindNasDeviceKey: ${hdcSyncBindNasDeviceKey}`);
    if (hdcSyncAccountStatus === '1') {
      if (hdcSyncBindNas === 'true') {
        let hdcSyncValue: string = hdcSyncBindNasUserKey + '|' + hdcSyncBindNasDeviceKey + '|false';
        this.setSettingsByBackupInfo('photos_hdc_sync', hdcSyncValue);
      }
      if (hdcSyncBindCloudStatus === '1' && hdcSyncBindNasStatus === 'true') {
        Log.info(TAG, `double open`);
        this.setSettingsByBackupInfo('photos_sync_options_double_status', '1');
      } else {
        Log.info(TAG, `single open`);
        if (hdcSyncBindCloudStatus === '1') {
          Log.info(TAG, `cloud open`);
        } else if (hdcSyncBindNasStatus === 'true') {
          Log.info(TAG, `nas open`);
          let hdcSyncValue: string = hdcSyncBindNasUserKey + '|' + hdcSyncBindNasDeviceKey + '|true';
          this.setSettingsByBackupInfo('photos_hdc_sync', hdcSyncValue);
        } else {
          Log.info(TAG, `all not open`);
        }
      }
    }
  }

  public async retainCloudMediaAsset(context: common.Context, value: number): Promise<void> {
    try {
      let cloudMediaAssetManagerInstance: photoAccessHelper.CloudMediaAssetManager =
        photoAccessHelper.CloudMediaAssetManager.getCloudMediaAssetManagerInstance(context);
      await cloudMediaAssetManagerInstance.retainCloudMediaAsset(value);
      Log.info(TAG, `end retain data to value`);
    } catch (err) {
      Log.error(TAG, `retainCloudMediaAssetDemo failed with error: ${err.code}, ${err.message}`);
    }
  }


  private async doRestoreOperation(isSameAccount: boolean): Promise<void> {
    let filePath: string = BACKUP_ABILITY_PATH + BACKUP_FILE_NAME;
    let file = await fileIo.open(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    let buffer: ArrayBuffer = new ArrayBuffer(4096);
    /* instrument ignore next */
    let readLen = await fileIo.read(file.fd, buffer);
    Log.info(TAG, 'read file data succeed');
    let str: string = String.fromCharCode(...new Uint8Array(buffer.slice(0, readLen)));
    let endIndex = str.indexOf('}') + 1;
    str = str.substring(0, endIndex);
    if (!str) {
      Log.error(TAG, 'str is fail!');
    }
    try {
      Log.info(TAG, `doRestoreOperation json parse str ${str}`);
      let msg: BackupInfo = JSON.parse(str);
      try {
        DataStoreUtil.getInstance().putData('albumStyle', msg.scale);
      } catch (error) {
        Log.error(TAG, `albumShortCutKey End putData error: ${error}, code: ${error?.code}`);
      }
      DataStoreUtil.getInstance().flush();
      AppStorage.setOrCreate<number>(Constants.albumScreenScale, msg.scale);

      this.setSetings('persist.photos.ce.auto.option', msg.autoCloudEnhanced);
      this.setSetings('persist.photos.ce.protocol.enable', msg.cloudEnhancedPrivacyAgreement);
      this.setSetings('persist.photos.ce.feature.enable', msg.cloudEnhanced);
      this.setSetings('persist.photos.ce.watermark.enable', msg.cloudEnhancedWatermark);
      this.setSetings('persist.photos.slideshow.interval', msg.slideshowTime);

      this.doRestoreSingleSyncOptionNasClone(isSameAccount, msg);

      // 还原视图切换向导参数
      this.setSettingsByBackupInfo(Constants.DAY_GROUP_HAS_CHANGED, msg.isChangedView + '');
      this.setSettingsByBackupInfo(Constants.GUIDE_HAS_CLOSED, msg.isClosedGuide + '');
      this.setSettingsByBackupInfo(Constants.GUIDE_LAST_OPT_TIME, msg.lastGuideOptTime);
      this.setSettingsByBackupInfo(Constants.GUIDE_SHOW_COUNT, msg.showGuideCount);
      this.setSettingsByBackupInfo(Constants.IS_NEED_RESTORE_GUIDE, 'true');

      Log.info(TAG, `doRestoreOperation save DayGuide isChangedView:${msg.isChangedView} ${msg.lastGuideOptTime} ` +
        `isClosedGuide:${msg.isClosedGuide} showGuideCount:${msg.showGuideCount}`);
      const recordMsg: Record<string, number | string | boolean> = {
        'OLD_DEVICE_FRAME_WORK': 'single',
        'CLOUD_ENHANCE_SWITCH': msg.cloudEnhanced,
        'AUTO_CLOUD_ENHANCE_SWITCH': msg.autoCloudEnhanced,
        'WATERMARK_SWITCH': msg.cloudEnhancedWatermark,
        'CLOUD_ENHANCE_PRIVACY_AGREEMENT': msg.cloudEnhancedPrivacyAgreement,
        'SLIDESHOW_TIME': msg.slideshowTime,
      };
      ReportToBigDataUtil.report(BigDataConstants.PHOTO_LIBRARY_CLONE, recordMsg);
    } catch (err) {
      Log.error(TAG, `restore with parse err : ${JSON.stringify(err)}`);
    } finally {
      Log.info(TAG, `[fd flag] doRestoreOperation, closeSync fd: ${file?.fd}`);
      fileIo.closeSync(file);
    }
  }
}