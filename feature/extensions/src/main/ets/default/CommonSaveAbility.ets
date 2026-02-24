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
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { PickerUtil } from '@ohos/common/src/main/ets/default/utils/PickerUtil';
import lazy { UserFileManagerAccess, toString } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';

const IMAGE: number = 0;
const VIDEO: number = 1;
const MIXED: number = 2;
const TAG: string = 'CommonSaveAbility';

export class CommonSaveAbility extends UIExtensionAbility {
  onForeground() {
    Log.info(TAG, 'onForeground');
  }

  onBackground() {
    Log.info(TAG, 'onBackground');
  }

  onDestroy() {
    Log.info(TAG, 'onDestroy');
  }

  /* instrument ignore next */
  public onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    let storage: LocalStorage = new LocalStorage();
    try {
      Log.info(TAG, `onSessionCreate, want is: ${toString(want)}`);
      let uris: string[] = want.parameters?.['ability.params.stream'] as string[];
      let photoTypeArray: photoAccessHelper.PhotoType[] =
        want.parameters?.photoTypeArray as photoAccessHelper.PhotoType[];
      let imageArray: photoAccessHelper.PhotoType[] =
        photoTypeArray.filter(type => type === photoAccessHelper.PhotoType.IMAGE);
      let fileType: number = MIXED;
      if (photoTypeArray.length === imageArray.length) {
        fileType = IMAGE;
      }
      if (imageArray.length === 0) {
        fileType = VIDEO;
      }
      let shortTerm: boolean = want.parameters?.shortTerm as boolean ?? false;
      if (!shortTerm && (!PickerUtil.isArrayValid(uris) || !PickerUtil.isArrayValid(photoTypeArray))) {
        Log.info(TAG, 'uris or photoTypeArray parameter is invalid.')
        return;
      }
      if (!shortTerm) {
        Log.info(TAG, `uris length is: ${uris.length}, uris is:${toString(uris)}`);
      }
      Log.info(TAG, `photoTypeArray length is: ${photoTypeArray.length},
          photoTypeArray is: ${toString(photoTypeArray)}`);
      const msg: Record<string, number | Object | undefined> = {
        'bundleName': want.parameters?.bundleName,
        'fileType': fileType,
        'fileNumber': uris?.length,
      };
      ReportToBigDataUtil.report(BigDataConstants.SAVE_DIALOG_INFO, msg);
    } catch (error) {
      Log.error(TAG, `ReportToBigDataUtil failure. err: ${error.code}, ${error.message}`);
    }
    storage?.setOrCreate(Constants.APP_KEY_SESSION, session);
    storage?.setOrCreate(Constants.APP_KEY_WANT_PARAM, want.parameters);
    UserFileManagerAccess.getInstance(storage).onCreate(this.context);
    session.loadContent('SaveAbility/view/SaveUIExtensionPage', storage);
  }

  onSessionDestroy(session: UIExtensionContentSession) {
    Log.info(TAG, 'onSessionDestroy');
  }
}