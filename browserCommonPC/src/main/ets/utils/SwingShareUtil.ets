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

import lazy {
  Constants as PhotoConstants,
  LargePictureBrowsingStatus,
  ItemAirShareSwitchStatus
} from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy common from '@ohos.app.ability.common';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy settings from '@ohos.settings';
import { harmonyShare } from '@kit.ShareKit';


const TAG: string = 'SwingShareUtil';

export class SwingShareUtil {
  private static settingsSetValueSync(context: Context, name: string, value: string): boolean {
    let result: boolean = false;
    try {
      result = settings.setValueSync(context, name, value);
      Log.info(TAG, `settings setValueSync, result: ${result}, name: ${name}, value: ${value}`);
    } catch (err) {
      Log.error(TAG, `settings setValueSync error, message: ${err?.message}, code: ${err?.code}`);
    }
    return result;
  }

  public static registerSwingShareListenEvent(context: common.Context,
    swingShareCallback?: Callback<harmonyShare.SharableTarget>): void {
    let isSuccess: boolean = SwingShareUtil.settingsSetValueSync(context, PhotoConstants.LARGE_PICTURE_BROWSING_STATUS,
      LargePictureBrowsingStatus.ONE);

    Log.info(TAG, `registerSwingShareListenEvent, set large_picture_browsing_status: 1, isSuccess: ${isSuccess}`);
    try {
      (harmonyShare.on as Function)(PhotoConstants.SWING_SHARE, swingShareCallback);
    } catch (err) {
      Log.error(TAG, `registerSwingShareListenEvent, error, message: ${err?.message}, code: ${err?.code}`);
    }
  }

  public static cancelSwingShareListenEvent(context: common.Context): void {
    try {
      let isSuccess: boolean = SwingShareUtil.settingsSetValueSync(context,
        PhotoConstants.LARGE_PICTURE_BROWSING_STATUS, LargePictureBrowsingStatus.ZERO);
      Log.info(TAG, `cancelSwingShareListenEvent, set large_picture_browsing_status: 0, isSuccess: ${isSuccess}`);
      (harmonyShare.off as Function)(PhotoConstants.SWING_SHARE);
    } catch (err) {
      Log.error(TAG, `cancelSwingShareListenEvent, error, message: ${err?.message}, code: ${err?.code}`);
    }
  }
}