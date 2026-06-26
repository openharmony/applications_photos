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
import type common from '@ohos.app.ability.common';
import lazy { Log } from './Log';
import lazy data_preferences from '@ohos.data.preferences';
import lazy { Constants } from '../model/common/Constants';
import lazy { StringUtil } from './StringUtil';
import type { BusinessError } from '@ohos.base';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { privacyManager } from '@kit.AbilityKit';
import lazy bundleManager from '@ohos.bundle.bundleManager';
import lazy { ThirdSelectManager } from '../model/browser/SelectManager';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import type { SelectParams } from '../model/common/SelectParams';
import lazy { MaxCountType } from '@kit.MediaLibraryKit';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { UserFileManagerAccess } from '../access/UserFileManagerAccess';

/* instrument ignore file */
const TAG: string = 'PickerUtil';

export enum AppPresenceStatus {
  EXISTS,
  NOT_EXIST,
  ABNORMALITY
}

export class PickerUtil {
  public static async isAppExist(appName: string, appListKey: string): Promise<AppPresenceStatus> {
    if (!appName) {
      Log.error(TAG, 'checkFirstWarning appName isNull');
      return AppPresenceStatus.ABNORMALITY;
    }
    const photosAbilityContext: common.UIExtensionContext | undefined =
      LocalStorage.getShared()?.get('photosAbilityContext');
    if (!photosAbilityContext) {
      Log.error(TAG, 'isAppExist photosAbilityContext is null');
      return AppPresenceStatus.ABNORMALITY;
    }
    try {
      return data_preferences.getPreferences(photosAbilityContext, Constants.PHOTOS_STORE_KEY)
        .then((pref: data_preferences.Preferences): AppPresenceStatus => {
          const appList: string = pref.getSync(appListKey, '') as string;
          Log.info(TAG, `checkFirstWarning size: ${appList.length}`);
          if (appList.length !== 0) {
            Log.info(TAG, 'Already completed');
            return AppPresenceStatus.EXISTS;
          }
          return AppPresenceStatus.NOT_EXIST;
        })
        .catch((err: Error): Promise<AppPresenceStatus> => {
          Log.error(TAG, `Failed to get preferences.${err}`);
          return Promise.reject(AppPresenceStatus.ABNORMALITY);
        });
    } catch (e) {
      Log.error(TAG, `getPreferences error.${e}`);
      return AppPresenceStatus.ABNORMALITY;
    }
  }

  public static async insertAppList(appName: string, appListKey: string): Promise<void> {
    Log.info(TAG, `insertAppList appName: ${appName}`);
    if (!appName) {
      Log.error(TAG, 'checkFirstWarning appName isNull');
    }
    const photosAbilityContext: common.UIExtensionContext | undefined =
      LocalStorage.getShared()?.get('photosAbilityContext');
    if (!photosAbilityContext) {
      Log.error(TAG, 'isAppExist photosAbilityContext is null');
    }
    try {
      await data_preferences.getPreferences(photosAbilityContext, Constants.PHOTOS_STORE_KEY)
        .then((pref: data_preferences.Preferences): void => {
          const appList: string = pref.getSync(appListKey, '') as string;
          Log.info(TAG, `insertAppList sta5 size: ${appList.length}`);
          if (appList.length !== 0) {
            Log.info(TAG, 'Already completed');
            return;
          }
          pref.putSync(appListKey,
            appList ? `${appList},${appName}` : appName);
          pref.flush((err: BusinessError) => {
            if (err) {
              Log.error(TAG, `Failed to flush. Code:${err.code}, message:${err.message}`);
            }
            Log.info(TAG, 'insertAppList sta7 success');
          });
        })
        .catch((err: Error): void => {
          Log.error(TAG, `Failed to get preferences.${err}`);
        });
    } catch (e) {
      Log.error(TAG, `getPreferences error, code ${e?.code}, stack ${e?.stack}`);
    }
  }

  public static addPermissionUsedWrite(tokenID: number): void {
    try {
      Log.info(TAG, `addPermissionUsedWrite tokenID is ${tokenID}`);
      let options: privacyManager.AddPermissionUsedRecordOptions = {
        usedType: privacyManager?.PermissionUsedType.PICKER_TYPE,
      };
      privacyManager?.addPermissionUsedRecord(tokenID, 'ohos.permission.WRITE_IMAGEVIDEO', 1, 0, options);
    } catch (err) {
      Log.info(TAG, `addPermissionUsedWrite error ${err}`);
    }
  }

  public static exceedMaxSelectedSendData(mediaItem: MediaItem | undefined,
    selectManager: ThirdSelectManager | undefined,
    selectParam: SelectParams | undefined,
    storage: LocalStorage | undefined): void {
    Log.info(TAG, 'exceedMaxSelectedSendData enter.');
    let maxCountType: number | undefined = undefined;
    if (mediaItem === undefined || selectManager === undefined || selectParam === undefined || storage === undefined) {
      Log.info(TAG, 'parameters may be undefined.');
      return;
    }
    if (selectManager?.getSelectedCount() >= selectParam?.maxSelectCount) {
      maxCountType = MaxCountType.TOTAL_MAX_COUNT;
    } else if (mediaItem?.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE &&
      selectManager?.getSelectMediaCountByType(UserFileManagerAccess.MEDIA_TYPE_IMAGE) >=
      selectParam.maxPhotoSelectNumber) {
      maxCountType = MaxCountType.PHOTO_MAX_COUNT;
    } else if (mediaItem?.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO &&
      selectManager?.getSelectMediaCountByType(UserFileManagerAccess.MEDIA_TYPE_VIDEO) >=
      selectParam.maxVideoSelectNumber) {
      maxCountType = MaxCountType.VIDEO_MAX_COUNT;
    }
    if (storage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
      let session: UIExtensionContentSession | undefined =
        storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
      session?.sendData({ 'dataType': 'exceedMaxSelected', 'maxCountType': maxCountType, });
      Log.info(TAG, `maxCountType: ${maxCountType}`);
    }

  }

  public static getHash(title: string): string {
    if (!title) {
      return '';
    }
    let hash: number = 0;
    for (let i = 0; i < title.length; i++) {
      hash = (hash * 13 + title.charCodeAt(i)) % 9999991; // 进制13为质数, 模99999991为质数
    }
    Log.info(TAG, `getHash hash=: ${hash}`);
    return hash.toString();
  }

  public static isArrayValid(obj: Object[] | undefined): boolean {
    if (!obj) {
      return false;
    }
    if (obj.length === 0) {
      return false;
    }
    return true;
  }
}