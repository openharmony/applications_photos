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
import lazy { settings } from '@kit.BasicServicesKit';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';

@Concurrent
export function settingsSetValue(context: Context, name: string, value: string): boolean {
  try {
    let result: boolean = settings.setValueSync(context, name, value);
    return result;
  } catch (err) {
    Log.info('SettingUtil', `set ${name} error ${err}`);
    return false;
  }
}

@Concurrent
export function settingsGetValue(context: Context, name: string, value: string): string {
  try {
    let result: string = settings.getValueSync(context, name, value);
    return result;
  } catch (err) {
    Log.info('SettingUtil', `get ${name} error ${err}`);
    return '';
  }
}
