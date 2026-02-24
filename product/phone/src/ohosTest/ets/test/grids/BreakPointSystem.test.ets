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
import { BreakpointSystem, BreakPointType } from '@ohos/common/src/main/ets/default/utils/BreakPointSystem';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';

export default function BreakPointSystemTest() {

  describe('BreakPointSystemTest', () => {

    it ('setCurrentViewType', 0, () => {
      let breakPointType = new BreakPointType({
        xs: false,
        sm: false,
        md: false,
        lg: true,
      });
      expect(breakPointType.getValue(Constants.BREAKPOINT_XS)).assertFalse();
      expect(breakPointType.getValue(Constants.BREAKPOINT_SM)).assertFalse();
      expect(breakPointType.getValue(Constants.BREAKPOINT_MD)).assertFalse();
      expect(breakPointType.getValue(Constants.BREAKPOINT_LG)).assertTrue();
    })

    it ('register', 0, () => {
      let system = new BreakpointSystem();
      system.register(Constants.BREAKPOINT_LG);
      expect(Reflect.get(system, 'currentBreakpoint')).assertEqual(Constants.BREAKPOINT_LG);
    })

  })
}