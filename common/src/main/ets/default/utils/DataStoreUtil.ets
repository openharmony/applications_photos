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
import lazy data_preferences from '@ohos.data.preferences';
import lazy contextConstant from '@ohos.app.ability.contextConstant';
import type common from '@ohos.app.ability.common';
import lazy { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'DataStoreUtil';

export class DataStoreUtil {
  private static readonly PREFERENCES_KEY_MY_FORM_STORE = 'myformstore';
  private preferences?: data_preferences.Preferences;

  private constructor() {
    Log.info(TAG, 'new DataStoreUtil');
  }

  public static getInstance(): DataStoreUtil {
    if (!DataStoreUtil.instance) {
      DataStoreUtil.instance = new DataStoreUtil();
    }
    return DataStoreUtil.instance;
  }

  public static instance: DataStoreUtil | undefined = undefined;

  public async init(): Promise<void> {
    if (this.preferences) {
      Log.debug(TAG, 'init already!');
      return;
    }
    Log.debug(TAG, 'init start!');
    let context: common.AbilityStageContext | undefined =
      AppStorage.get<common.AbilityStageContext>('photosGlobalContext');
    if (!context) {
      Log.error(TAG, '[getAssets] context is null!');
      return;
    }
    let area: contextConstant.AreaMode = context.area;
    context.area = contextConstant.AreaMode.EL1;
    try {
      this.preferences =
        await data_preferences.getPreferences(context,
          DataStoreUtil.PREFERENCES_KEY_MY_FORM_STORE) as data_preferences.Preferences;
      Log.info(TAG, 'init preferences');
    } catch (err) {
      Log.error(TAG, `init err ${err}, code: ${err?.code}`);
    }
    context.area = area;
    Log.debug(TAG, 'init end!');
    return;
  }

  public async getData<T extends data_preferences.ValueType>(key: string, defValue: T): Promise<T> {
    Log.debug(TAG, 'getData start!');
    if (!this.preferences) {
      Log.error(TAG, 'getData preferences is undefined');
      await this.init();
      if (!this.preferences) {
        return defValue;
      }
    }
    let temValue: data_preferences.ValueType = defValue;
    await this.preferences.get(key, defValue)
      .then((value: data_preferences.ValueType): void => {
        Log.debug(TAG, `The value of startup is ${value}`);
        temValue = value;
      }).catch((err: BusinessError): void => {
        Log.error(TAG, `Get the value failed with err: ${err}, code: ${err?.code}`);
      });
    return temValue as T;
  }

  public async putData<T extends data_preferences.ValueType>(key: string, value: T): Promise<void> {
    Log.debug(TAG, 'putData start!');
    // instrument ignore if
    if (value === null || value === undefined) {
      return;
    }
    // instrument ignore if
    if (!this.preferences) {
      Log.error(TAG, 'putData preferences is undefined');
      await this.init();
    }

    await (this.preferences as data_preferences.Preferences).put(key, value).then((): void => {
      Log.debug(TAG, `Put the value successfully. key： ${key} value： ${value} `);
    }).catch((err: BusinessError): void => {
      Log.error(TAG, `Put the value failed with err: ${err}, code: ${err?.code}`);
    });
  }

  public async delData(key: string): Promise<void> {
    Log.debug(TAG, 'delData start!');
    // instrument ignore if
    if (!this.preferences) {
      Log.error(TAG, 'delData preferences is undefined');
      await this.init();
    }
    await (this.preferences as data_preferences.Preferences).delete(key).then((): void => {
      Log.debug(TAG, 'Delete the value successfully.');
    }).catch((err: BusinessError): void => {
      Log.error(TAG, `Delete the value failed with err: ${err}, code: ${err?.code}`);
    });
  }

  public async flush(): Promise<void> {
    Log.debug(TAG, 'flush start!');
    // instrument ignore if
    if (!this.preferences) {
      Log.error(TAG, 'flush preferences is undefined');
      await this.init();
    }
    await (this.preferences as data_preferences.Preferences).flush();
  }

  public async hasData(key: string): Promise<boolean> {
    Log.debug(TAG, `hasData start! preferences ${this.preferences}`);
    let ret = false;
    // instrument ignore if
    if (!this.preferences) {
      Log.error(TAG, 'hasData preferences is undefined');
      await this.init();
    }

    await (this.preferences as data_preferences.Preferences).has(key).then((value): void => {
      Log.debug(TAG, `hasData the value successfully. key: ${key}  value: ${value}}`);
      ret = value;
    }).catch((err: BusinessError): void => {
      Log.error(TAG, `hasData the value failed with err: ${err}, code: ${err?.code}`);
      ret = false;
    });
    return ret;
  }

  public async removeCache(): Promise<void> {
    Log.debug(TAG, 'removeCache start!');
    let context: common.AbilityStageContext | undefined =
      AppStorage.get<common.AbilityStageContext>('photosGlobalContext');
    if (!context) {
      Log.error(TAG, '[getAssets] context is null!');
      return;
    }
    let area: contextConstant.AreaMode = context.area;
    context.area = contextConstant.AreaMode.EL1;
    try {
      await data_preferences.removePreferencesFromCache(context, DataStoreUtil.PREFERENCES_KEY_MY_FORM_STORE);
      this.preferences = undefined;
      Log.info(TAG, 'removeCache successfully.');
    } catch (err) {
      Log.info(TAG, `removeCache failed with err: ${err}`);
    }
    context.area = area;
  }
}
