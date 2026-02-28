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
import { ScreenUtil } from '../../../../../../../../imageEditor/common/src/main/ets/common/util/ScreenUtil';

export default function FormatUtilTest() {
  describe('ScreenUtilTest', () => {
    it('ScreenUtil_getScreenWidth', 0, () => {
      const width = ScreenUtil.getScreenWidth();
      expect(width).assertLarger(0);
    });
    it('ScreenUtil_getRefreshRate', 0, () => {
      const refreshRate = ScreenUtil.getRefreshRate();
      expect(refreshRate).assertLarger(0);
    });
  });
}