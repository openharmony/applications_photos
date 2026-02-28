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

import lazy { Log } from './Log';
import lazy { Constants } from '../model/common/Constants';
import type { Context } from '@ohos.abilityAccessCtrl';
import lazy { UserFileManagerAccess } from '../access/UserFileManagerAccess';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { BusinessError, settings, systemParameterEnhance } from '@kit.BasicServicesKit';
import lazy Global from './GlobalContext';
import lazy { PhotoConfig } from '../../default/config/PhotoConfig';

const TAG: string = 'common_CommonUtil';

export class CommonUtil {
  private static uuidInner: number = 0;

  public static isPhotoApp(bundleName: string): boolean {
    if (!bundleName) {
      Log.debug(TAG, 'isPhotoApp - invalid bundleName');
      return false;
    }

    return bundleName === Constants.PHOTO_BUNDLE_NAME;
  }

  public static isContextSupport(context?: Context): boolean {
    let storage = LocalStorage.getShared();
    if (storage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
      return false;
    }
    return true;
  }

  public static isAllPhotoAlbum(albumUri: string): boolean {
    if (!albumUri) {
      return true;
    }
    if (albumUri === '') {
      return true;
    }
    if (PhotoConfig.isLibrary()) {
      return true;
    }
    if (albumUri === UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE)) {
      return true;
    }
    if (albumUri === UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE)) {
      return true;
    }
    if (albumUri === UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE)) {
      return true;
    }
    if (albumUri === Constants.ALL_DUPLICATE_ASSETS) {
      return true;
    }
    return false;
  }

  public static isSystemAlbum(albumUri: string): boolean {
    if (albumUri === UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE)) {
      return true;
    }
    if (albumUri === UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE)) {
      return true;
    }
    if (albumUri === UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE)) {
      return true;
    }
    if (albumUri === UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE)) {
      return true;
    }
    if (albumUri === UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.CAMERA_ALBUM_SUB_TYPE)) {
      return true;
    }
    return false;
  }

  public static isFavoriteAlbum(albumUri: string): boolean {
    if (albumUri === UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE)) {
      return true;
    }
    return false;
  }

  public static isValidObject(input: Object | null | undefined): boolean {
    return input !== null && input !== undefined;
  }

  public static isVideoFile(fileName: string): boolean {
    // 常见视频文件扩展名
    const videoExtensions = /\.(mp4|mkv|avi|mov|flv|wmv|webm|ogg|ogv|3gp|mpg|mpeg|mts)$/i;

    return videoExtensions.test(fileName);
  }

  public static get uuid(): number {
    this.uuidInner++;
    return this.uuidInner;
  }

  /**
   * 查询 设置-显示和亮度-高级设置-图片渐进显示 开关
   * @param inContext
   */
  public static queryProgDispSwitchStatus(inContext?: Context): void {
    try {
      let context: Context;
      if (inContext) {
        context = inContext;
      } else {
        context = PhotoConfig.isLibrary() ? global.browserUiAbilityContext() : global.uiAbilityContext();
      }

      if (!context) {
        Log.error(TAG, 'queryProgDispSwitchStatus context is null');
        return;
      }
      let isBionicVisionSupport: boolean = false;
      try {
        isBionicVisionSupport =
          (systemParameterEnhance.getSync('const.photos.enable_pixelmap_readapt', 'false') === 'true');
      } catch (err) {
        Log.error(TAG, `get enable_pixelmap_readapt failed. error msg: ${(err as BusinessError).message}`);
      }
      let defaultSwitchStatus: boolean = false;
      try {
        defaultSwitchStatus = (systemParameterEnhance.getSync('const.photos.pixelmap_readapt_default_state',
          'false') === 'true') ? true : false;
      } catch (err) {
        Log.error(TAG, `get readapt_default_state failed. error msg: ${(err as BusinessError).message}`);
      }
      let defaultVal: boolean = isBionicVisionSupport && defaultSwitchStatus;
      let value =
        settings.getValueSync(context, 'settings.display.prog_disp_switch', defaultVal ? '1' : '0',
          settings.domainName.DEVICE_SHARED);
      Log.info(TAG, `queryProgDispSwitchStatus value=${value}`);
      AppStorage.setOrCreate<boolean>('prog_disp_switch', value === '1');
      Log.info(TAG, `queryProgDispSwitchStatus Global.getBoolean${AppStorage.get<boolean>('prog_disp_switch')}`);
    } catch (error) {
      Log.error(TAG, `queryProgDispSwitchStatus error: ${error}, defual true.`);
      AppStorage.setOrCreate<boolean>('prog_disp_switch', true);
    }
  }

  /**
   * 注册 设置-显示和亮度-高级设置-图片HDR显示 开关监听
   */
  public static registerProgDispSwitchObserver(inContext?: Context): void {
    Log.info(TAG, 'registerProgDispSwitchObserver.');
    try {
      let context: Context;
      if (inContext) {
        context = inContext;
      } else {
        context = PhotoConfig.isLibrary() ? global.browserUiAbilityContext() : global.uiAbilityContext();
      }

      if (!context) {
        Log.error(TAG, `registerProgDispSwitchObserver context is null ${context}`);
        return;
      }
      settings.registerKeyObserver(context, 'settings.display.prog_disp_switch', settings.domainName.DEVICE_SHARED,
        (err, val) => {
          if (err) {
            Log.info(TAG, `ProgDispSwitchObserver Failed to get the setting. ${JSON.stringify(err)} `);
          }
          Log.info(TAG, 'registerProgDispSwitchObserver callback.');
          CommonUtil.queryProgDispSwitchStatus(inContext);
        });
    } catch (err) {
      Log.error(TAG, `registerProgDispSwitchObserver fail: ${JSON.stringify(err)}`);
    }

    // 初始化hdr开关设置
    CommonUtil.queryProgDispSwitchStatus(inContext);
  }

  /**
   * 注销 设置-显示和亮度-高级设置-图片HDR显示 开关监听
   */
  public static unregisterProgDispSwitchObserver(inContext?: Context): void {
    Log.info(TAG, 'unregisterProgDispSwitchObserver.');
    let context: Context;
    if (inContext) {
      context = inContext;
    } else {
      context = PhotoConfig.isLibrary() ? global.browserUiAbilityContext() : global.uiAbilityContext();
    }

    if (!context) {
      Log.error(TAG, `unregisterProgDispSwitchObserver context is null ${context}`);
      return;
    }
    let ret = settings.unregisterKeyObserver(context, 'settings.display.prog_disp_switch',
      settings.domainName.DEVICE_SHARED);
    Log.info(TAG, `unregisterProgDispSwitchObserver ret: ${ret}`);
  }
}

export enum LockResult {
  SUCCESS = 12500000, // 执行成功。
  FAIL = 12500001, // 认证失败。
  GENERAL_ERROR = 12500002, // 操作通用错误。
  CANCELED = 12500003, // 操作取消。
  TIMEOUT = 12500004, // 操作超时。
  TYPE_NOT_SUPPORT = 12500005, // 不支持的认证类型。
  TRUST_LEVEL_NOT_SUPPORT = 12500006, // 不支持的认证等级。
  BUSY = 12500007, // 忙碌状态。
  LOCKED = 12500009, // 认证器已锁定。
  NOT_ENROLLED = 12500010, // 用户未录入认证信息
}