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
import { convertToMViewType, MViewType } from '@ohos/timeline/src/main/ets/model/Constants';
import { FormIndex } from '@ohos/timeline/src/main/ets/photogrid/statemanager/constants/GridDefine';

export default function ConstantsTest() {
  describe('ConstantsTest', () => {

    it('convertToMViewType', 0, () => {
      let res1 = convertToMViewType(FormIndex.YEAR);
      expect(res1).assertEqual(MViewType.YEAR);

      let res2 = convertToMViewType(FormIndex.MONTH);
      expect(res2).assertEqual(MViewType.MONTH);

      let res3 = convertToMViewType(FormIndex.DAY);
      expect(res3).assertEqual(MViewType.DAY);

      let res4 = convertToMViewType(FormIndex.GROUP_DAY);
      expect(res4).assertEqual(MViewType.GROUP_DAY);

      let res5 = convertToMViewType(FormIndex.INVALID);
      expect(res5).assertEqual(MViewType.DAY);

    })

  })
}