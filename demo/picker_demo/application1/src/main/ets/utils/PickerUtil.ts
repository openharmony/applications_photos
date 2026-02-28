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
/* instrument ignore file */
const TAG: string = 'PickerUtil';

export enum AppPresenceStatus {
  EXISTS,
  NOT_EXIST,
  ABNORMALITY
}

export class PickerUtil {
  public static async isAppExist(appName: string, appListKey: string): Promise<AppPresenceStatus> {
    Log.info(TAG, `isAppExist appName: ${appName}`);
    if (StringUtil.isEmpty(appName)) {
      Log.error(TAG, 'checkFirstWarning appName isNull');
      return AppPresenceStatus.ABNORMALITY;
    }
    const photosAbilityContext: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('photosAbilityContext');
    if (!photosAbilityContext) {
      Log.error(TAG, 'isAppExist photosAbilityContext is null');
      return AppPresenceStatus.ABNORMALITY;
    }
    return data_preferences.getPreferences(photosAbilityContext, Constants.PHOTOS_STORE_KEY)
      .then((pref: data_preferences.Preferences): AppPresenceStatus => {
        const appList: string = pref.getSync(appListKey, '') as string;
        Log.info(TAG, `checkFirstWarning appList: ${appList}`);
        if (appList.length !== 0) {
          Log.info(TAG, 'Already completed');
          return AppPresenceStatus.EXISTS;
        }
        return AppPresenceStatus.NOT_EXIST;
      })
      .catch((err: Error): Promise<AppPresenceStatus> => {
        Log.error(TAG, 'Failed to get preferences.' + err);
        return Promise.reject(AppPresenceStatus.ABNORMALITY);
      });
  }

  public static async insertAppList(appName: string, appListKey: string): Promise<void> {
    Log.info(TAG, `insertAppList appName: ${appName}`);
    if (StringUtil.isEmpty(appName)) {
      Log.error(TAG, 'checkFirstWarning appName isNull');
    }
    const photosAbilityContext: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('photosAbilityContext');
    if (!photosAbilityContext) {
      Log.error(TAG, 'isAppExist photosAbilityContext is null');
    }
    await data_preferences.getPreferences(photosAbilityContext, Constants.PHOTOS_STORE_KEY)
      .then((pref: data_preferences.Preferences): void => {
        const appList: string = pref.getSync(appListKey, '') as string;
        Log.info(TAG, `insertAppList sta5 appList: ${appList}`);
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
        Log.error(TAG, 'Failed to get preferences.' + err);
      });
  }

  public static async deleteAppList(context: common.ExtensionContext, appListKey: string): Promise<void> {
    if (!context) {
      Log.error(TAG, 'isAppExist photosAbilityContext is null');
    }
    await data_preferences.getPreferences(context, Constants.PHOTOS_STORE_KEY)
      .then((pref: data_preferences.Preferences): void => {
        pref.deleteSync(appListKey);
        pref.flush((err: BusinessError) => {
          if (err) {
            Log.error(TAG, `Failed to flush. Code:${err.code}, message:${err.message}`);
          }
          Log.info(TAG, 'insertAppList sta7 success');
        });
        const appList: string = pref.getSync(appListKey, '') as string;
        Log.info(TAG, `deleteAppList sta5 appList: ${appList}`);
        if (appList.length !== 0) {
          Log.error(TAG, 'deleteAppList failed');
          return;
        } else {
          Log.info(TAG, 'deleteAppList success');
        }
      })
      .catch((err: Error): void => {
        Log.error(TAG, 'Failed to get preferences.' + err);
      });
  }
}