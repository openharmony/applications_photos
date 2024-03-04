/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { Log } from './Log';
import { Constants } from '../model/common/Constants';
import data_preferences from '@ohos.data.preferences';
import contextConstant from '@ohos.app.ability.contextConstant';
import common from '@ohos.app.ability.common';

const TAG: string = 'common_DataStoreUtil';

export class DataStoreUtil {
  private static readonly PREFERENCES_KEY_MY_FORM_STORE = 'myformstore';
  private preferences: data_preferences.Preferences = undefined;

  private constructor() {
    Log.info(TAG, 'new DataStoreUtil');
  }

  public static getInstance(): DataStoreUtil {
    if (AppStorage.get(Constants.FROM_DATA_STORE_UTIL) == null) {
      AppStorage.setOrCreate(Constants.FROM_DATA_STORE_UTIL, new DataStoreUtil());
    }
    return AppStorage.get(Constants.FROM_DATA_STORE_UTIL);
  }

  public async init(): Promise<void> {
    Log.debug(TAG, 'init start!');
    if (this.preferences) {
      Log.debug(TAG, 'init already!');
      return;
    }
    let context: common.AbilityStageContext = AppStorage.get<common.AbilityStageContext>('photosGlobalContext');
    let area: contextConstant.AreaMode = context.area;
    context.area = contextConstant.AreaMode.EL1;
    try {
      this.preferences = await data_preferences.getPreferences(context, DataStoreUtil.PREFERENCES_KEY_MY_FORM_STORE);
      Log.info(TAG, `init preferences ${this.preferences}`);
    } catch (err) {
      Log.error(TAG, `init err ${err}`);
    }
    context.area = area;
    Log.debug(TAG, 'init end!');
    return;
  }

  public async getData(key: string, defValue) {
    Log.debug(TAG, 'getData start!');
    if (!this.preferences) {
      Log.error(TAG, `getData preferences is undefined`);
      await this.init();
    }
    let temValue = defValue;
    await this.preferences.get(key, defValue).then((value) => {
      Log.debug(TAG, 'The value of startup is ' + value)
      temValue = value;
    }).catch((err) => {
      Log.error(TAG, `Get the value failed with err: ${err}`)
    })
    return temValue;
  }

  public async putData(key: string, value) {
    Log.debug(TAG, 'putData start!');
    if (value === null || value === undefined) {
      return;
    }

    if (!this.preferences) {
      Log.error(TAG, 'putData preferences is undefined');
      await this.init();
    }

    await this.preferences.put(key, value).then(() => {
      Log.debug(TAG, 'Put the value successfully.');
    }).catch((err) => {
      Log.error(TAG, `Put the value failed with err: ${err}`);
    })
  }

  public async delData(key: string) {
    Log.debug(TAG, 'delData start!');
    if (!this.preferences) {
      Log.error(TAG, `delData preferences is undefined`);
      await this.init();
    }
    await this.preferences.delete(key).then(() => {
      Log.debug(TAG, 'Delete the value successfully.');
    }).catch((err) => {
      Log.error(TAG, `Delete the value failed with err: ${err}`);
    })
  }

  public async flush() {
    Log.debug(TAG, 'flush start!');
    if (!this.preferences) {
      Log.error(TAG, `flush preferences is undefined`);
      await this.init();
    }
    await this.preferences.flush();
  }

  public async hasData(key: string) {
    Log.debug(TAG, `hasData start! preferences ${this.preferences}`);
    let ret = false;
    if (!this.preferences) {
      Log.error(TAG, `hasData preferences is undefined`);
      await this.init();
    }

    await this.preferences.has(key).then((value) => {
      Log.debug(TAG, `hasData the value successfully. ${value}}`);
      ret = value;
    }).catch((err) => {
      Log.error(TAG, `hasData the value failed with err: ${err}`);
      ret = false;
    })
    return ret;
  }

  public async removeCache() {
    Log.debug(TAG, 'removeCache start!');
    let context: common.AbilityStageContext = AppStorage.get<common.AbilityStageContext>('photosGlobalContext');
    let area: contextConstant.AreaMode = context.area;
    context.area = contextConstant.AreaMode.EL1;
    try {
      await data_preferences.removePreferencesFromCache(context, DataStoreUtil.PREFERENCES_KEY_MY_FORM_STORE);
      this.preferences = undefined;
      Log.info(TAG, 'removeCache successfully.')
    } catch (err) {
      Log.info(TAG, 'removeCache failed with err: ' + err)
    }
    context.area = area;
  }
}
