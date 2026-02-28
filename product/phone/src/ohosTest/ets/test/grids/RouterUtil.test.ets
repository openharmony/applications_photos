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
import { describe, expect, it, MockKit, when } from '@ohos/hypium';
import { tryGetRouterParam } from '@ohos/common/src/main/ets/default/utils/RouterUtil';

export default function RouterUtilTest() {
  describe('RouterUtilTest', () => {
    it('RouterUtilTest_tryGetRouterParam_err', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc)('router').afterReturn(undefined);
      let errorRes = tryGetRouterParam();
      expect(errorRes).assertUndefined();
      mocker.ignoreMock(AppStorage, AppStorage.get);
    })
    it('RouterUtilTest_tryGetRouterParam_err1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc)('router').afterThrow('err');
      let errorRes = tryGetRouterParam();
      expect(errorRes).assertNull();
      mocker.ignoreMock(AppStorage, AppStorage.get);
    })
  })
}