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
import lazy { Constants } from '../model/common/Constants';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { common, uriPermissionManager, wantConstant } from '@kit.AbilityKit';
import lazy { BigDataConstants, ReportToBigDataUtil } from './ReportToBigDataUtil';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { display } from '@kit.ArkUI';

const TAG: string = 'WallpaperUtils';

export class WallpaperUtils {
  public static async setWallpaper(itemUri: string): Promise<void> {
    const flags = wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION;
    try {
      await uriPermissionManager.grantUriPermission(itemUri, flags, Constants.SCENEBOARD_BUNDLE_NAME);
    } catch (error) {
      Log.info(TAG, `grantPhotoUriPermission error: ${error}, code: ${error?.code}`);
    }

    let context: common.UIAbilityContext | undefined =
      LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext');
    if (!context) {
      Log.warn(TAG, 'context undefined');
      return;
    }

    let targetDisplayId: number | undefined = undefined;
    try {
      targetDisplayId = display.getDefaultDisplaySync()?.id;
      const currentDisplayId: number | undefined = context.config?.displayId;
      if (typeof (currentDisplayId) === 'number' && currentDisplayId >= 0) {
        targetDisplayId = currentDisplayId;
      }
    } catch (err) {
      Log.error(TAG, `getDisplaySyncById error: ${err?.code}, ${err?.message}`);
    }
    const want: Want = {
      bundleName: Constants.SCENEBOARD_BUNDLE_NAME,
      abilityName: Constants.SET_WALLPAPER_ABILITY,
      parameters: {
        router: itemUri,
        displayId: targetDisplayId ?? 0
      }
    }
    context?.startServiceExtensionAbility(want).then(() => {
      Log.info(TAG, 'startServiceExtensionAbility succeed');
    }).catch((error: BusinessError) => {
      Log.error(TAG, 'startServiceExtensionAbility failed ' + error.code + error.message);
    })

    ReportToBigDataUtil.report(BigDataConstants.SET_WALLPAPER, {
      'url': ReportToBigDataUtil.urlAnonymize(itemUri)
    });
  }
}