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

/* instrument ignore file */
import lazy preferences from '@ohos.data.preferences';
import lazy { global } from '../global/Contexts';
import lazy { assert } from '../model/common/DataTypes';
import lazy { Log } from '../utils/Log';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy contextConstant from '@ohos.app.ability.contextConstant';
import lazy common from '@ohos.app.ability.common';


/**
 * 业务: 隐私合规
 */
const TAG = 'PrivacyGlobal';

export enum Privacy {
  ICP = 0,
  PRIVACY_PROTOCOL = 10671,
  PRIVACY_PROTOCOL_PC = 20000013,
  PRIVACY_PROTOCOL_TV = 20000085,
  CLOUD_ENHANCE_PRIVACY_PROTOCOL = 10742,
  AI_RETOUCH_TERMS = 10000198,
  AI_RETOUCH_PRIVACY_PROTOCOL = 10734,
  AI_WALLPAPER_PRIVACY_PROTOCOL = 20000004,
  AI_WALLPAPER_TERMS = 10000223,
}

export namespace Protocol {
  export let STORAGE: preferences.Preferences | undefined = undefined;

  export const PERMISSION_AGREED = 'PERMISSION_AGREED';

  export const AI_CREATION_TOGGLE_STATUS = 'AI_CREATION_TOGGLE_STATUS';

  export async function initPreferences(context: common.Context = global.uiAbilityContext()): Promise<void> {
    const area: contextConstant.AreaMode = context.area;
    context.area = contextConstant.AreaMode.EL2;
    STORAGE = await preferences.getPreferences(context, {
      name: Privacy.PRIVACY_PROTOCOL.toString(),
    });
    context.area = area;
  }

  export async function getIsAgreedPref(context: common.Context, defValue: boolean = false): Promise<boolean> {
    if (!context) {
      Log.error(TAG, 'getPref context is undefined');
      return defValue;
    }
    if (!STORAGE) {
      await initPreferences(context);
    }
    return get<boolean>(PERMISSION_AGREED, defValue);
  }

  export async function getIsAgreedState(context: common.Context, defValue: boolean = false): Promise<boolean> {
    if (!context) {
      Log.error(TAG, 'getPref context is undefined');
      return defValue;
    }

    // 防止数据不一致
    removeCache(context);

    if (!STORAGE) {
      await initPreferences(context);
    }
    return get<boolean>(AI_CREATION_TOGGLE_STATUS, defValue);
  }

  export function get<T extends preferences.ValueType>(key: string, defValue: T): T {
    if (!STORAGE) {
      Log.error(TAG, 'preferences was not initiated');
      return defValue;
    }
    let v: T = assert.asDefault<T>(STORAGE.getSync(key, defValue), defValue, TAG);
    return v;
  }

  export async function set<T extends preferences.ValueType>(key: string, v: T): Promise<void> {
    if (!STORAGE) {
      await initPreferences();
      Log.error(TAG, 'preferences was not initiated');
    }
    try {
      await STORAGE?.put(key, v)
        .catch((err: BusinessError): void => {
          Log.error(TAG, `Failed to put the value of '${key}'. Cause: ${err}, code: ${err?.code}`);
        });
      STORAGE?.flush();
    } catch (err) {
      Log.error(TAG, `Failed to put the value of '${key}'. Cause: ${err}, code: ${err?.code}`);
    }
  }

  /**
   * 防止数据不一致问题
   */
  export function removeCache(context: common.Context) {
    Log.debug(TAG, 'removeCache start!');
    let area: contextConstant.AreaMode = context.area;
    context.area = contextConstant.AreaMode.EL2;
    try {
      preferences.removePreferencesFromCacheSync(context, Privacy.PRIVACY_PROTOCOL.toString());
      STORAGE = undefined;
      Log.info(TAG, 'removeCache successfully.');
    } catch (err) {
      Log.info(TAG, 'removeCache failed with err: ' + err);
    }
    context.area = area;
  }
}