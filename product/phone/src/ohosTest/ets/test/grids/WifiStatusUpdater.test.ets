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
import { describe, expect, it } from '@ohos/hypium';
import { WifiStatusUpdater } from '@ohos/timeline/src/main/ets/view/WifiStatusUpdater';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';

export default function WifiStatusUpdaterTest() {

  describe('WifiStatusUpdaterTest', () => {

    // 测试isSupport，输入number
    it('should_set_isSupport_number', TestConstants.TEST_LEVEL_ONE, () => {
      let wifiStatusUpdater: WifiStatusUpdater = new WifiStatusUpdater(1, true);
      const param: number = 0;
      const res: boolean = Reflect.get(wifiStatusUpdater, 'isSupport').call(param);
      expect(res).assertTrue();
    });

    // 测试isSupport，输入undefined
    it('should_set_isSupport_undefined', TestConstants.TEST_LEVEL_ONE, () => {
      let wifiStatusUpdater: WifiStatusUpdater = new WifiStatusUpdater(1, true);
      const res: boolean = Reflect.get(wifiStatusUpdater, 'isSupport').call(undefined);
      expect(res).assertTrue();
    });
  });
}