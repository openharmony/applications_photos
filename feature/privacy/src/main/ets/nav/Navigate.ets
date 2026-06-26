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

import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { Privacy } from '@ohos/tools/src/main/variables/PrivacyGlobal';
import lazy { NavigationBroadCastManager } from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';

/* instrument ignore file */
const TAG = 'Navigate';

export namespace Navigate {
  export function onBackClicked(tag: string, nav?: NavPathStack): () => true {
    return (): true => {
      nav?.pop();
      Log.info(tag, 'navDestination onBackPressed');
      return true;
    }
  }

  export function onBackMenuClicked(tag: string, action: Action, nav?: NavPathStack): void {
    Log.info(TAG, `location album onBackMenuClicked, action: ${ActionID[action.actionID]}`);
    if (action.actionID === Action.BACK.actionID) {
      onBackClicked(tag, nav);
    }
  }

  // export function browseProtocol(navStack: NavPathStack, agreement?: PrivacyAgreement): () => void {
  //   if (!agreement) {
  //     agreement = { type: Privacy.ICP };
  //   }
  //   return (): void => {
  //     // PafRouter.getPafRouter()
  //     //   .pushPath(true, NavigationConstants.NAVIGATION_PRIVACY_VIEWER, agreement);
  //     // Log.info(TAG, `${navStack.getAllPathName()} click privacy_statement event`);
  //   }
  // }

  // export function emitProtocol(navStack: NavPathStack, agreement?: PrivacyAgreement): () => void {
  //   Log.info(TAG, navStack.getAllPathName() + ` click privacy_statement event${agreement}`);
  //   if (!agreement) {
  //     agreement = { type: DeviceInfo.isTv() ? Privacy.PRIVACY_PROTOCOL_TV :
  //       (DeviceInfo.isPc() ? Privacy.PRIVACY_PROTOCOL_PC : Privacy.PRIVACY_PROTOCOL) };
  //   }
  //   return (): void => {
  //     NavigationBroadCastManager.getInstance().getBroadCast().emitAsync(
  //       NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_PRIVACY_VIEWER]).then(() => {
  //       // PafRouter.getPafRouter()
  //       //   .pushPath(true, NavigationConstants.NAVIGATION_PRIVACY_VIEWER, agreement);
  //     });
  //   }
  // }
}