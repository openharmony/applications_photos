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
import lazy UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import lazy Want from '@ohos.app.ability.Want';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { ability } from '@kit.AbilityKit';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy Bundles from '@ohos/tools/src/main/utils/Bundle';

const TAG: string = 'CommonDefaultAlbumNameAbility';
const DEFAULT_ALBUM_NAME_RESULT_SUCCESS: number = 0;
const DEFAULT_ALBUM_NAME_RESULT_ERROR: number = 23800301;

export class CommonDefaultAlbumNameAbility extends UIExtensionAbility {
  onSessionCreate(want: Want, session: UIExtensionContentSession) {
    Log.info(TAG, 'onSessionCreate: getDefaultAlbumName');
    try {
      let defaultAlbumName: string =
        new RscGetter(this.context.resourceManager).getString($r('app.string.pictures_and_videos'));
      let abilityResult: ability.AbilityResult = {
        resultCode: DEFAULT_ALBUM_NAME_RESULT_ERROR,
        want: {
          parameters: {
            'defaultAlbumName': ''
          }
        }
      };
      if (defaultAlbumName?.length > 0) {
        abilityResult = {
          resultCode: DEFAULT_ALBUM_NAME_RESULT_SUCCESS,
          want: {
            parameters: {
              'defaultAlbumName': defaultAlbumName
            }
          }
        };
      }
      let wantParam: Record<string, Object> = want.parameters as Record<string, Object>;
      let bundleName: string = wantParam[Bundles.KEY_WANT_PARAMETERS_CALLER_BUNDLE_NAME] as string ?? '';
      const msg: Record<string, number | string | boolean> = {
        'BUNDLENAME': bundleName,
        'ISDEFAULTALBUMNAME': true
      };
      ReportToBigDataUtil.report(BigDataConstants.PHOTO_PICKER_COMP_BROWSE_MODE, msg);
      session?.terminateSelfWithResult(abilityResult).then((result: void) => {
        Log.info(TAG, `session terminateSelfWithResult result: ${result}, abilityResult: ${
        JSON.stringify(abilityResult)}`);
      });
    } catch (err) {
      Log.error(TAG, `data collection failure. err: ${err.code}, ${err.message}`);
      session?.terminateSelf();
    }
  }
}