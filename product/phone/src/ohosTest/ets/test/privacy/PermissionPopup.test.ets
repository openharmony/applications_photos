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

import { afterEach, beforeEach, describe, expect } from '@ohos/hypium';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { PermissionPopup } from '@ohos/privacy/src/main/ets/about/consent/PermissionPopup';
import { common, UIExtensionContentSession } from '@kit.AbilityKit';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { TAG } from '@ohos/common/src/main/ets/default/task/RequestQualityTask';
import { AccountRepository } from '@ohos/privacy/src/main/ets/about/consent/AccountRepository';
import { Privacy } from '@ohos/tools/src/main/variables/PrivacyGlobal';

const protocol: Privacy = Privacy.AI_RETOUCH_PRIVACY_PROTOCOL;

export default function PermissionPopupTest() {
  describe('PermissionPopupTest', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('PermissionPopupTest01', 0, async () => {
      const context: common.UIExtensionContext | null = getContext() as common.UIExtensionContext;
      PermissionPopup.init(undefined, undefined);
      expect(context !== undefined).assertTrue();
    });

    it('PermissionPopupTest001', 0, async () => {
      const context: common.UIExtensionContext | null = getContext() as common.UIExtensionContext;
      PermissionPopup.init();
      expect(context !== undefined).assertTrue();
    });

    it('PermissionPopupTest02', 0, async () => {
      let storage: LocalStorage = LocalStorage.getShared();
      let session: UIExtensionContentSession | undefined =
        storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
      const context: common.UIExtensionContext | null = getContext() as common.UIExtensionContext;
      if (session && context) {
        await PermissionPopup.initExt(session, context, protocol);
      }
      expect(context !== undefined).assertTrue();
    });

    it('PermissionPopupTest03', 0, async () => {
      const context: common.UIExtensionContext | null = getContext() as common.UIExtensionContext;
      PermissionPopup.initPafCustomAsync(getContext(), protocol);
      expect(context !== undefined).assertTrue();
    });

    it('PermissionPopupTest04', 0, async () => {
      try {
        const client = await PermissionPopup.getClient(getContext());
        expect(client).not().assertNull()
      } catch (e) {
        Log.warn(TAG, `PermissionPopupTest04 getClient error.`)
      }
    });

    it('PermissionPopupTest05', 0, async () => {
      const userInfo = await getUserInfo()
      const sign = await PermissionPopup.signAgreementRecord(getContext(), userInfo, protocol);
      expect(sign !== undefined).assertTrue();
    });

    it('PermissionPopupTest06', 0, async () => {
      const userInfo: PermissionPopup.UserInfo = {
        userId: '',
        accessToken: '',
      };
      const sign = await PermissionPopup.signAgreementRecord(getContext(), userInfo, protocol);
      expect(sign !== undefined).assertTrue();
    });

    it('PermissionPopupTest07', 0, async () => {
      const userInfo = await getUserInfo()
      const sign = await PermissionPopup.queryAgreementRecord(getContext(), userInfo, protocol);
      expect(sign !== undefined).assertTrue();
    });

    it('PermissionPopupTest08', 0, async () => {
      const userInfo: PermissionPopup.UserInfo = {
        userId: '',
        accessToken: '',
      };
      const sign = await PermissionPopup.queryAgreementRecord(getContext(), userInfo, protocol);
      expect(sign).assertFalse()
    });

    it('PermissionPopupTest09', 0, async () => {
      const userInfo = await getUserInfo()
      const sign = await PermissionPopup.revokeAgreementRecord(getContext(), userInfo, protocol);
      expect(sign !== undefined).assertTrue();
    });

    it('PermissionPopupTest10', 0, async () => {
      const userInfo: PermissionPopup.UserInfo = {
        userId: '',
        accessToken: '',
      };
      const sign = await PermissionPopup.revokeAgreementRecord(getContext(), userInfo, protocol);
      expect(sign).assertFalse();
    });

    it('PermissionPopupTest11', 0, async () => {
      const userInfo: PermissionPopup.UserInfo = {
        userId: '',
        accessToken: '',
      };
      await PermissionPopup.initPafAsync(getContext());
      expect(getContext() !== undefined).assertTrue();
    });
  });
}

async function getUserInfo(): Promise<PermissionPopup.UserInfo> {
  const userInfo: PermissionPopup.UserInfo = {
    userId: '',
    accessToken: '',
  };
  AccountRepository.getInstance().setAccountContext(getContext());
  try {
    await AccountRepository.getInstance().signIn(true);
    Log.info(TAG, 'getAccountInfo call signIn finish');
    userInfo.accessToken = await AccountRepository.getInstance().getAccessToken(false);
    Log.info(TAG, 'getAccountInfo call getAccessToken finish');
    userInfo.userId = AccountRepository.getInstance().getAccount().userId;
  } catch (err) {
    Log.warn(TAG, `getAccountInfo failed: code: ${err?.code}, data: ${err?.data}, subCode: ${err?.subCode}`);
  }
  return userInfo;
}