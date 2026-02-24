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
import { SystemUtil } from '@ohos/common/src/main/ets/default/utils/SystemUtil';
import { TimeUtils } from '@ohos/common/src/main/ets/default/utils/TimeUtils';

export default function SystemAndTimeUtilsTest() {
  describe('SystemUtilTest', () => {
    it('SystemUtil_format', 0, () => {
      let language = SystemUtil.getSystemLanguage();
      expect(language).assertEqual('zh');
    })

    // 根据测试机具体设置不同无法准确断言
    it('SystemUtil_is24HourClock', 0, () => {
      let is24HourClock = SystemUtil.is24HourClock();
      expect(is24HourClock).not().assertNull();
    })

    it('TimeUtils_isOutTime_yes', 0, () => {
      let is24HourClock = TimeUtils.isOutTime(1709986466274, 500);
      expect(is24HourClock).assertEqual(true);
    })
    it('TimeUtils_isOutTime_no', 0, () => {
      // 有效期设置一年
      let is24HourClock = TimeUtils.isOutTime(1745483821001, 31536000000);
      expect(is24HourClock).assertEqual(false);
    })
  })
}