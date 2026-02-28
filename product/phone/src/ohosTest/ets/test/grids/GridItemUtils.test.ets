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
import { GridItemUtils } from '@ohos/common/src/main/ets/default/utils/GridItemUtils';

export default function GridItemUtilsTest() {
  describe('GridItemUtilsTest', () => {

    //测试useGridTrace : GridItemUtils.gridTraceSwitch = true;false分支已覆盖
    it('useGridTraceTest_when_gridTraceSwitch_is_true', 0, () => {
      GridItemUtils.gridTraceSwitch = true;
      const result = GridItemUtils.useGridTrace();
      expect(result).assertEqual(GridItemUtils.gridTraceSwitch);
    });

    //测试useGridReport : GridItemUtils.gridReportSwitch = true;false分支已覆盖
    it('useGridReportTest_when_gridReportSwitch_is_true', 0, () => {
      GridItemUtils.gridReportSwitch = true;
      const result = GridItemUtils.useGridReport();
      expect(result).assertEqual(GridItemUtils.gridReportSwitch);
    });

  });
}