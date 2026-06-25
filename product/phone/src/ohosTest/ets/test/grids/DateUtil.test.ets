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
import { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';

export default function DateUtilTest() {
  describe('DateUtilTest', () => {
    it('DateUtilTest_format_nullParam', 0, () => {
      let stringDate = DateUtil.format(new Date(1709986466274), undefined);
      expect(stringDate).assertEqual('1709986466274');
    })
    it('DateUtilTest_getLocalizedYearAndMonth', 0, () => {
      let yearAndMonth = DateUtil.getLocalizedYearAndMonth(1709986466274);
      expect(yearAndMonth).assertEqual('2024年3月');
    })
    it('DateUtilTest_getLocalizedMonthAndDay', 0, () => {
      let monthAndDay = DateUtil.getLocalizedMonthAndDay(1709986466274);
      expect(monthAndDay).assertEqual('3月9日');
    })
    it('DateUtilTest_getLocalizedMonth', 0, () => {
      let month = DateUtil.getLocalizedMonth(1709986466274);
      expect(month).assertEqual('3月');
    })

    it('DateUtilTest_getLocalizedDate', 0, () => {
      let date1 = DateUtil.getLocalizedDate(1709986466274, true);
      expect(date1).assertEqual('2024年3月9日');

      let date2 = DateUtil.getLocalizedDate(1709986466274, false);
      expect(date2).assertEqual('3月9日');
    })

    it('DateUtilTest_getLocalizedYearString', 0, () => {
      let res1 = DateUtil.getLocalizedYearString(1709986466274);
      expect(res1).assertEqual('2024年');
    })

    it('DateUtilTest_getLocalizedYear', 0, () => {
      let res1 = DateUtil.getLocalizedYear(1709986466274);
      expect(res1).assertEqual('2024年');
    })

    it('DateUtilTest_isTimeIntervalOver24Hours', 0, () => {
      let res1 = DateUtil.isTimeIntervalOver24Hours(1709986466274, 1709986466374);
      expect(res1).assertEqual(false);
    })

    it('DateUtilTest_getLocalizedDay', 0, () => {
      let res1 = DateUtil.getLocalizedDay(1709986466274);
      expect(res1).assertEqual('9日');
    })

    it('DateUtilTest_getFormattedDuration', 0, () => {
      let res1 = DateUtil.getFormattedDuration(1709986466274);
      expect(res1).assertEqual('474996:14:26');

      let res2 = DateUtil.getFormattedDuration(0);
      expect(res2).assertEqual('00:00');

      let res3 = DateUtil.getFormattedDuration(999);
      expect(res3).assertEqual('00:01');

      let res4 = DateUtil.getFormattedDuration(3599 * 3600);
      expect(res4).assertEqual('3:35:56');

      let res5 = DateUtil.getFormattedDuration(3599);
      expect(res5).assertEqual('00:03');

    })

    it('DateUtilTest_getFormattedDurationForScreenReader', 0, () => {
      let res1 = DateUtil.getFormattedDurationForScreenReader(1709986466274);
      expect(res1).assertEqual('474996:14:26');

      let res2 = DateUtil.getFormattedDurationForScreenReader(0);
      expect(res2).assertEqual('00:00:00');

      let res3 = DateUtil.getFormattedDurationForScreenReader(999);
      expect(res3).assertEqual('00:00:01');

      let res4 = DateUtil.getFormattedDurationForScreenReader(3599);
      expect(res4).assertEqual('00:00:03');

      let res5 = DateUtil.getFormattedDurationForScreenReader(3599 * 3600);
      expect(res5).assertEqual('3:35:56');

    })

    it('DateUtilTest_isTheSameDay', 0, () => {
      let res1 = DateUtil.isTheSameDay(1709986466274, 1709986466274);
      expect(res1).assertEqual(true);
      let res2 = DateUtil.isTheSameDay(1709986466274, 1719986466274);
      expect(res2).assertEqual(false);
    })

    it('DateUtilTest_isTheSameMonth', 0, () => {
      let res1 = DateUtil.isTheSameMonth(1709986466274, 1709986466274);
      expect(res1).assertEqual(true);
      let res2 = DateUtil.isTheSameMonth(1709986466274, 1719986466274);
      expect(res2).assertEqual(false);
    })

    it('DateUtilTest_isTheSameYear', 0, () => {
      let res1 = DateUtil.isTheSameYear(1709986466274, 1709986466274);
      expect(res1).assertEqual(true);
    })

    it('DateUtilTest_convertSecondsToDays', 0, () => {
      let res1 = DateUtil.convertSecondsToDays(1709986466274);
      expect(res1).assertEqual(19792);
      let res2 = DateUtil.convertSecondsToDays(1);
      expect(res2).assertEqual(2);
      let res3 = DateUtil.convertSecondsToDays(0);
      expect(res3).assertEqual(0);
    })

    // 当前时间戳无法精确断言，仅判断长度是否大于0
    it('DateUtilTest_getFullTime', 0, () => {
      let res = DateUtil.getFullTime();
      expect(res.length > 0).assertTrue();
    })

    it('DateUtilTest_isSameDay', 0, () => {
      let res1 = DateUtil.isSameDay(1709986466274);
      expect(res1).assertEqual(false);

      let res2 = DateUtil.isSameDay(Date.now());
      expect(res2).assertEqual(true);

    })

  })
}