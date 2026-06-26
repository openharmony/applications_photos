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

import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { osAccount } from '@kit.BasicServicesKit';

const TAG = 'UserUtils';
const INVALID_ID: number = -1;
const USER_ID_DEFAULT: number = 100;

export class UserUtils {
  private userId: number = INVALID_ID;

  public async getUserId(): Promise<number> {
    if (this.userId > 0) {
      return this.userId;
    }
    try {
      const accountManager: osAccount.AccountManager = osAccount.getAccountManager();
      this.userId = await accountManager.getForegroundOsAccountLocalId();
      return this.userId;
    } catch (e) {
      Log.error(TAG, `getUserId has error: ${e?.message}, code: ${e?.code}`);
      return USER_ID_DEFAULT;
    }
  }

  public resetUserId(): void {
    this.userId = INVALID_ID;
  }
}

const userUtils = new UserUtils();
export default userUtils as UserUtils;