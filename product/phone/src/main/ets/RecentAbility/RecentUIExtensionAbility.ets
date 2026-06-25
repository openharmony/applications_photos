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
import lazy { UserFileManagerAccess, } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy Want from '@ohos.app.ability.Want';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { BundleInfoUtils } from '@ohos/common/src/main/ets/default/utils/BundleInfoUtils';
import lazy Bundles from '@ohos/tools/src/main/utils/Bundle';
import lazy uiExtensionHost from '@ohos.uiExtensionHost';
import type { BusinessError } from '@ohos.base';
import lazy { PickerUtil } from '@ohos/common/src/main/ets/default/utils/PickerUtil';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy { CommonRecentPhotoInfoUtil } from '@ohos/extensions/src/main/ets/default/CommonRecentPhotoInfoStub';

/* instrument ignore file */
const TAG: string = 'RecentUIExtensionAbility';

export default class RecentUIExtensionAbility extends UIExtensionAbility {
  private storage: LocalStorage = new LocalStorage();

  onCreate() {
    Log.info(TAG, 'onCreate');
    try {
      this.context.getApplicationContext().setSupportedProcessCache(true);
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      Log.info(TAG, `RecentUIExtensionAbility setSupported returns code ${code}, returns msg ${message}`)
    }
  }

  onForeground() {
    Log.info(TAG, 'onForeground');
  }

  onBackground() {
    Log.info(TAG, 'onBackground');
  }

  onDestroy() {
    Log.info(TAG, 'onDestroy');
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession) {
    Log.info(TAG, 'RecentPhotoComponent onSessionCreate');
    let startTime: number = Date.now();

    let extensionWindow: uiExtensionHost.UIExtensionHostWindowProxy | undefined =
      session.getUIExtensionHostWindowProxy();
    extensionWindow?.hidePrivacyContentForHost(true);
    UserFileManagerAccess.getInstance().onCreate(this.context);
    MediaObserver.getInstance().subscribe(this.context, TAG);
    let wantParam: Record<string, Object> = want.parameters as Record<string, Object>;
    let bundleName: string = wantParam[Bundles.KEY_WANT_PARAMETERS_CALLER_BUNDLE_NAME] as string ?? '';
    BundleInfoUtils.getAppIdByBundleName(bundleName).then((appId) => {
      this.storage?.setOrCreate(Constants.PHOTO_PICKER_APP_ID_KEY, appId);
    });
    const tokenId = wantParam[Bundles.KEY_WANT_PARAMETERS_CALLER_TOKEN] as number ?? 0;
    let isRecentPhotoCheckResultSet: boolean = wantParam['isRecentPhotoCheckResultSet'] as boolean ?? false;
    this.storage?.setOrCreate(Constants.RECENT_PHOTO_APP_BUNDLE_NAME_KEY, bundleName);
    this.storage?.setOrCreate(Constants.RECENT_PHOTO_SESSION_KEY, session);
    this.storage?.setOrCreate(Constants.PHOTO_PICKER_TOKEN_ID_KEY, tokenId);
    this.storage?.setOrCreate(Constants.RECENT_PHOTO_MEDIA_WANT_KEY, wantParam);
    let queryUtil: CommonRecentPhotoInfoUtil = new CommonRecentPhotoInfoUtil();
    queryUtil.queryRecentPhoto(wantParam).then((result: MediaItem | undefined) => {
      if (isRecentPhotoCheckResultSet) {
        session.sendData({
          'dataType': 'checkResult', 'isExist': result ? true : false
        });
        session.sendData({
          'dataType': 'checkInfo',
          'isExist': result ? true : false,
          'identifier': result ? PickerUtil.getHash(result.getTitle()) : '',
          'dateTaken': result ? result.getDateTaken() : 0
        });
        Log.info(TAG, `sendData title=: ${result?.getTitle()}, datetaken= ${result?.getDateTaken()}`);
      }
      if (result) {
        Log.info(TAG, `queryRecentPhoto result: ${result.uri}`);
        this.storage?.setOrCreate(Constants.RECENT_PHOTO_MEDIA_ITEM_KEY, result);
      } else {
        Log.info(TAG, 'queryRecentPhoto finished, result is empty.');
      }
      this.storage?.setOrCreate(Constants.RECENT_PHOTO_SESSION_KEY, session);
      session.loadContent('RecentAbility/view/ThirdSelectRecentPhotoPage', this.storage);
      session.setWindowBackgroundColor('#00000000');
      Log.info(TAG, 'RecentUIExtensionAbility onSessionCreate');
      Log.info(TAG, `onSessionCreate cost time: ${Date.now() - startTime}`);
    }).catch((error: BusinessError) => {
      Log.info(TAG, `queryRecentPhoto has error, ${error}`);
      this.sessionTerminate(session);
    });
  }

  onSessionDestroy(session: UIExtensionContentSession) {
    Log.info(TAG, 'onSessionDestroy');
    UserFileManagerAccess.getInstance().onDestroy();
    this.storage?.delete(Constants.PHOTO_PICKER_TOKEN_ID_KEY);
    this.storage?.delete(Constants.PHOTO_PICKER_APP_ID_KEY);
    this.storage?.delete(Constants.RECENT_PHOTO_APP_BUNDLE_NAME_KEY);
    this.storage?.delete(Constants.RECENT_PHOTO_SESSION_KEY);
    this.storage?.delete(Constants.RECENT_PHOTO_MEDIA_ITEM_KEY);
    this.storage?.clear();
    MediaObserver.getInstance().clearCallbacks();
  }

  private sessionTerminate(session: UIExtensionContentSession): void {
    session.terminateSelf(() => {
      Log.info(TAG, 'session to terminateSelf');
    });
  }
}
