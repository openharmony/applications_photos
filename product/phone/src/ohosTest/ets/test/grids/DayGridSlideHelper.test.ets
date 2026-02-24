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
import { describe,  it, expect } from '@ohos/hypium';
import { DayGridSlideHelper } from '@ohos/common/src/main/ets/default/utils/DayGridSlideHelper';
import { RegularGridScrollInfo } from '@ohos/common/src/main/ets/default/utils/GridScrollBaseHelper';

export default function DayGridSlideHelperTest() {
  describe('DayGridSlideHelperTest', () => {

    //测试handleScrollStop
    it('handleScrollStopTest_needClearSimpleMediaItems_is_true', 0, () => {
      let dayGridSlideHelperInstance: DayGridSlideHelper = new DayGridSlideHelper();
      dayGridSlideHelperInstance.handleScrollStop();
      expect(Reflect.get(dayGridSlideHelperInstance, 'needClearSimpleMediaItems')).assertTrue();
    });

    //测试handleWillScroll
    it('handleWillScrollTest_when_offset_is_zero', 0, () => {
      let dayGridSlideHelperInstance: DayGridSlideHelper = new DayGridSlideHelper();
      const res = dayGridSlideHelperInstance.handleWillScroll(0, ScrollSource.DRAG);
      expect(res).assertEqual(0);
    });

    it('handleWillScrollTest_when_scrollInfo_is_null_or_undefined', 0, () => {
      let dayGridSlideHelperInstance: DayGridSlideHelper = new DayGridSlideHelper();
      const res = dayGridSlideHelperInstance.handleWillScroll(1, ScrollSource.DRAG);
      expect(res).assertEqual(1);
    });

    it('handleWillScrollTest_when_scrollInfo_is_not_null', 0, () => {
      let dayGridSlideHelperInstance: DayGridSlideHelper = new DayGridSlideHelper();
      let RegularGridScroll = new RegularGridScrollInfo();
      RegularGridScroll.gridRowCount = 1;
      dayGridSlideHelperInstance.recordScrollInfo(RegularGridScroll);
      const res = dayGridSlideHelperInstance.handleWillScroll(1, ScrollSource.DRAG);
      expect(res).assertEqual(1);
    });

    //测试isSupportedPreload()
    it('isSupportedPreloadTest_isSupportPreload_is_true', 0, () => {
      let dayGridSlideHelperInstance: DayGridSlideHelper = new DayGridSlideHelper();
      const res: boolean = Reflect.get(dayGridSlideHelperInstance, 'isSupportPreload').call();
      expect(res).assertTrue();
    });

  });
}