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
import { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import deviceInfo from '@ohos.deviceInfo';

export default function DeviceInfoTest() {

  describe('DeviceInfoTest', () => {
    it('isPcFold', 0, () => {
      let res = DeviceInfo.isPcFold();
      expect(res).assertEqual(false);
    })

    it('isPcHalfFoldState', 0, () => {
      let res = DeviceInfo.isPcHalfFoldState();
      expect(res).assertEqual(false);
    })

    it('isGRLMStatus', 0, () => {
      let res = DeviceInfo.isGRLMStatus();
      expect(res).assertEqual(false);
    })

    it('isGRLFoldExpanded', 0, () => {
      let res = DeviceInfo.isGRLFoldExpanded();
      expect(res).assertEqual(false);
    })

    it('getODID', 0, () => {
      let res = DeviceInfo.getODID();
      expect(res).assertEqual('00000000-0000-0000-0000-000000000000');
    })

    it('isSupportBouncePlay', 0, () => {
      let res = DeviceInfo.isSupportBouncePlay();
      expect(res).assertEqual(false);
    })

    it('isSupportLiteVisualEffect', 0, () => {
      let res = DeviceInfo.isSupportLiteVisualEffect();
      expect(res != null).assertEqual(true);
    })

    it('isPhonePSD', 0, () => {
      let res = DeviceInfo.isPhonePSD();
      if (deviceInfo.productModel === 'PSD-AL00') {
        expect(res).assertTrue();
      } else {
        expect(res).assertFalse();
      }
    })
  })
}