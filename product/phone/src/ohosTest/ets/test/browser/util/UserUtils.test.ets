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
import { describe, beforeEach, afterEach, it, expect, MockKit, when } from '@ohos/hypium';
import { UserUtils } from '@ohos/thirdselect/src/main/ets/default/utils/UserUtils';
import { osAccount } from '@kit.BasicServicesKit';

export default function UserUtilsUT() {
  describe('user_utilsUT', () => {
    interface osAccountManager {
      getAccountManager: () => osAccount.AccountManager,
    }

    let userUtils: UserUtils;
    let mocker: MockKit;

    beforeEach(() => {
      userUtils = new UserUtils();
      mocker = new MockKit();
    });

    afterEach(() => {
      mocker.clearAll();
    });

    it('should_return_existing_user_id', 0, async () => {
      Reflect.set(userUtils, 'userId', 1)
      const result = await userUtils.getUserId();
      expect(result).assertEqual(1);
    });

    it('should_fetch_new_user_id_successfully', 0, async () => {
      userUtils.resetUserId();
      const mockOsAccount: osAccountManager = {
        getAccountManager: osAccount.getAccountManager,
      };
      const mockGetAccountManager = mocker.mockFunc(mockOsAccount, mockOsAccount.getAccountManager);
      const mockManager = {
        getForegroundOsAccountLocalId: osAccount.getAccountManager().getForegroundOsAccountLocalId,
      } as osAccount.AccountManager;
      when(mockGetAccountManager)().afterReturn(mockManager);
      const mockGetForegroundOsAccountLocalId = mocker.mockFunc(mockManager, mockManager.getForegroundOsAccountLocalId);
      when(mockGetForegroundOsAccountLocalId)().afterReturn(456);
      const result = await userUtils.getUserId();
      expect(result).assertEqual(100);
    });

    it('should_return_default_user_id_when_fetching_fails', 0, async () => {
      userUtils.resetUserId();
      const mockOsAccount: osAccountManager = {
        getAccountManager: osAccount.getAccountManager,
      };
      const mockGetAccountManager = mocker.mockFunc(mockOsAccount, mockOsAccount.getAccountManager);
      const mockManager = {
        getForegroundOsAccountLocalId: osAccount.getAccountManager().getForegroundOsAccountLocalId,
      } as osAccount.AccountManager;
      when(mockGetAccountManager)().afterReturn(mockManager);
      const mockGetForegroundOsAccountLocalId = mocker.mockFunc(mockManager, mockManager.getForegroundOsAccountLocalId);
      when(mockGetForegroundOsAccountLocalId)().afterThrow('test error');
      const result = await userUtils.getUserId();
      expect(result).assertEqual(100);
    });
  });
}