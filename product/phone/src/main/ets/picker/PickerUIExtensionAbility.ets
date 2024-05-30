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

import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import { Constants, Log, UserFileManagerAccess } from '@ohos/common';
import { ScreenManager } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import Want from '@ohos.app.ability.Want';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { SelectParams } from '@ohos/thirdselect/src/main/ets/default/utils/ThirdSelectConstants';
import uiExtensionHost from '@ohos.uiExtensionHost';

const TAG = '[PickerUIExtensionAbility]'

export default class PickerUIExtensionAbility extends UIExtensionAbility {
  onCreate(): void {
    Log.info(TAG, 'onCreate');
  }

  onDestroy(): void {
    Log.info(TAG, 'onDestroy');
  }

  onForeground(): void {
    Log.info(TAG, 'onForeground');
  }

  onBackground(): void {
    Log.info(TAG, 'onBackground');
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    let extensionWindow: uiExtensionHost.UIExtensionHostWindowProxy | undefined =
      session.getUIExtensionHostWindowProxy();
    AppStorage.setOrCreate('photosAbilityContext',this.context);
    AppStorage.setOrCreate(Constants.PHOTO_PICKER_EXTENSION_WINDOW, extensionWindow);
    let storage: LocalStorage = new LocalStorage();
    let params: SelectParams = this.parseWant(want);
    storage.setOrCreate(Constants.PHOTO_PICKER_SESSION_KEY, session);
    storage.setOrCreate(Constants.PHOTO_PICKER_PARAMS_KEY, params);
    storage.setOrCreate(Constants.PHOTO_PICKER_EXTENSION_WINDOW, extensionWindow);
    UserFileManagerAccess.getInstance().onCreate(this.context);
    ScreenManager.getInstance().initializationSize(undefined).then((): void => {
      ScreenManager.getInstance().getAvoidArea();
      ScreenManager.getInstance().setMainWindow();
      session.loadContent('pages/ThirdSelectPhotoGridPage', storage);
      Log.info(TAG, 'onSessionCreate');
    });
  }

  onSessionDestroy(session: UIExtensionContentSession) {
    Log.info(TAG, 'onSessionDestroy');
    UserFileManagerAccess.getInstance().onDestroy();
    ScreenManager.getInstance().destroyMainWindow();
    AppStorage.delete(Constants.PHOTO_PICKER_EXTENSION_WINDOW);
  }

  private parseWant(want: Want): SelectParams {
    let wantParam: Record<string, Object> = want.parameters as Record<string, Object>;
    let params: SelectParams = SelectParams.defaultParam();
    let selectType: string = wantParam?.uri as string;
    if (selectType) {
      params.isMultiPick = selectType === Constants.WANT_PARAM_URI_SELECT_MULTIPLE;
      params.maxSelectCount = params.isMultiPick ? wantParam?.maxSelectCount as number : 1;
      params.bundleName = wantParam[Constants.KEY_WANT_PARAMETERS_CALLER_BUNDLE_NAME] as string;
      params.filterMediaType = wantParam?.filterMediaType as string;
      params.cameraAble = (wantParam?.isPhotoTakingSupported as boolean) === undefined ?
        true : (wantParam?.isPhotoTakingSupported as boolean);
      params.editAble = (wantParam?.isEditSupported as boolean) === undefined ?
        true : (wantParam?.isEditSupported as boolean);
      params.isFirstEnter = true;
    } else {
      Log.error(TAG, `invalid selectType: ${JSON.stringify(selectType)}`);
    }
    Log.info(TAG, `parseWant: ${JSON.stringify(wantParam)}, params: ${JSON.stringify(params)}`);
    return params;
  }
}