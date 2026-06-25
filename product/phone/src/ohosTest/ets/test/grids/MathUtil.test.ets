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
import { MathUtil } from '@ohos/common/src/main/ets/default/utils/MathUtil';

export default function MathUtilTest() {

  describe('MathUtilTest', () => {
    it('MathUtil_distance', 0, () => {
      let distance = MathUtil.distance(3, 0, 4, 0);
      expect(distance).assertEqual(1);
      distance = MathUtil.distance(3, 0, 6, 4);
      expect(distance).assertEqual(5);
    })

    it('MathUtil_multiple', 0, () => {
      let result = MathUtil.multiple([1], [2], 1, 1, 1);
      expect(result.length).assertEqual(1);
      expect(result[0]).assertEqual(2);
    })
  })
}