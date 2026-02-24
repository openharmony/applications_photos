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

import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy settings from '@ohos.settings';
import lazy { Constants } from '../model/common/Constants';

const TAG: string = 'SyncAlbumUtil';

export class SyncAlbumUtil {
  public static setValueSync(context: Context, value: number): boolean {
    let result: boolean = false;
    try {
      result = settings.setValueSync(context, Constants.PHOTO_ALL_ALBUMS_UPLOAD_STATUS, String(value));
      Log.info(TAG,
        `settings setValueSync, result: ${result}, name: ${Constants.PHOTO_ALL_ALBUMS_UPLOAD_STATUS}, value: ${value}`);
    } catch (err) {
      Log.error(TAG, `settings setValueSync error, message: ${err?.message}, code: ${err?.code}`);
    }
    return result;
  }

  public static getValueSync(context: Context): string {
    let result: string = '';
    try {
      result = settings.getValueSync(context, Constants.PHOTO_ALL_ALBUMS_UPLOAD_STATUS, String(Constants.ZERO));
      Log.info(TAG,
        `gettings setValueSync, result: ${result}, name: ${Constants.PHOTO_ALL_ALBUMS_UPLOAD_STATUS}`);
    } catch (err) {
      Log.error(TAG, `settings setValueSync error, message: ${err?.message}, code: ${err?.code}`);
    }
    return result;
  }
}