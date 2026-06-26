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

import lazy common from '@ohos.app.ability.common';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy settings from '@ohos.settings';
import lazy { taskpool } from '@kit.ArkTS';

/* instrument ignore file  */
const TAG: string = 'SwingServiceHelper';
const SWING_SHARE: string = 'swingShare';
const LARGE_PICTURE_BROWSING_STATUS: string = 'large_picture_browsing_status';
const STR_STATUS_ZERO: string = '0';
const STR_STATUS_FIRST: string = '1';
const ITEM_AIR_SHARE_SWITCH: string = 'item_air_share_switch';

export class SwingServiceController {
  private static getItemAirShareSwitch(context: common.Context): string {
    let result: string = STR_STATUS_ZERO;
    try {
      result = settings.getValueSync(context, ITEM_AIR_SHARE_SWITCH, '0', settings.domainName.USER_SECURITY);
      Log.info(TAG, `get item air share switch: ${result}`);
    } catch (err) {
      Log.error(TAG, `get item air share switch error: ${err}`);
    }
    return result
  }

  private static setLargePictureBrowsingStatus(context: common.Context, statusVal: string): void {
    try {
      let result: boolean = settings.setValueSync(context, LARGE_PICTURE_BROWSING_STATUS, statusVal);
      Log.info(TAG, `large picture browsing status is set as ${statusVal} ${result ? 'successfully' : 'failed'}`);
    } catch (err) {
      Log.error(TAG, `Set large picture browsing status error: ${err}`);
    }
  }

  // public static swingShareListenEvent(context: common.Context,
  //   swingShareCallback?: Callback<harmonyShare.SharableTarget>): void {
  //   try {
  //     SwingServiceController.setLargePictureBrowsingStatus(context, STR_STATUS_FIRST)
  //     Log.info(TAG, 'set swing share event');
  //     (harmonyShare.on as Function)(SWING_SHARE, swingShareCallback);
  //   } catch (err) {
  //     Log.error(TAG, `swing share listen event is set error: ${err}`);
  //   }
  // }

  // public static async swingShareListenEventAsync(context: common.Context,
  //   swingShareCallback?: Callback<harmonyShare.SharableTarget>): Promise<void> {
  //   try {
  //     await taskpool.execute(settingsSetValue, context, LARGE_PICTURE_BROWSING_STATUS, STR_STATUS_FIRST);
  //     Log.info(TAG, 'set swing share event async');
  //     (harmonyShare.on as Function)(SWING_SHARE, swingShareCallback);
  //   } catch (err) {
  //     Log.error(TAG, `swing share listen event is set error: ${err}`);
  //   }
  // }

  // public static swingUnShareListenEvent(context: common.Context,
  //   swingShareCallback?: Callback<harmonyShare.SharableTarget>): void {
  //   try {
  //     SwingServiceController.setLargePictureBrowsingStatus(context, STR_STATUS_ZERO)
  //     let isOpen = SwingServiceController.getItemAirShareSwitch(context)
  //     if (STR_STATUS_FIRST === isOpen) {
  //       Log.info(TAG, 'unset swing share event');
  //       (harmonyShare.off as Function)(SWING_SHARE, swingShareCallback);
  //     }
  //   } catch (err) {
  //     Log.error(TAG, `swing share listen event is unset error: ${err}`);
  //   }
  // }

//   public static async swingUnShareListenEventAsync(context: common.Context,
//     swingShareCallback?: Callback<harmonyShare.SharableTarget>): Promise<void> {
//     try {
//       await taskpool.execute(settingsSetValue, context, LARGE_PICTURE_BROWSING_STATUS, STR_STATUS_ZERO);
//       Log.info(TAG, 'unset swing share event async');
//       (harmonyShare.off as Function)(SWING_SHARE, swingShareCallback);
//     } catch (err) {
//       Log.error(TAG, `swing share listen event is set error: ${err}`);
//     }
//   }
}

@Concurrent
function settingsSetValue(context: Context, name: string, value: string): boolean {
  try {
    let result: boolean = settings.setValueSync(context, name, value);
    Log.info('SwingServiceHelper',
      `large picture browsing status is set as ${name} ${result ? 'successfully' : 'failed'}`);
    return result;
  } catch (err) {
    Log.error('SwingServiceHelper', `Set large picture browsing status error: ${err}`);
  }
  return false;
}