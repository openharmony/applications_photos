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
import { describe, expect, it, MockKit } from '@ohos/hypium';
import ThirdAppLockUtil from '@ohos/common/src/main/ets/default/utils/ThirdAppLockUtil';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import appLock from '@ohos.security.appLock';

export default function ThirdAppLockUtilTest() {
  describe('ThirdAppLockUtilTest', () => {
    const TAG = 'ThirdAppLockUtil';

    //测试init: valid
    it('initTest_when_mock_log', 0, async() => {
      let mocker = new MockKit();
      mocker.mockFunc(Log, Log.info);
      const thirdAppLockUtil = new ThirdAppLockUtil();
      let eventName = 'test_eventName'
      await thirdAppLockUtil.init(eventName);
      mocker.verify('info', [TAG, `Succeeded in creating subscriber.`]);
      mocker.ignoreMock(Log, Log.info);
      mocker.clear(Log);
    });

    //测试getUserId: userid > 0
    it('getUserId_when_userid_bigger_than_zero', 0, async() => {
      const thirdAppLockUtil = new ThirdAppLockUtil();
      Reflect.set(thirdAppLockUtil, 'userId', 1);
      const id: number = await Reflect.get(thirdAppLockUtil, 'getUserId').call(thirdAppLockUtil);
      expect(id).assertEqual(1);
    });

    //userid <= 0
    it('getUserId_when_userid_smaller_than_zero', 0, async() => {
      const thirdAppLockUtil = new ThirdAppLockUtil();
      const id: number = await Reflect.get(thirdAppLockUtil, 'getUserId').call(thirdAppLockUtil);
      expect(id !== undefined).assertTrue();
    });

  });
}