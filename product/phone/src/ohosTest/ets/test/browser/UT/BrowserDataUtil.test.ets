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

export default function BrowserDateUtilTest() {
  describe('BrowserDateUtilTest', () => {
    it('BrowserDateUtilTest_format_nullParam', 0, () => {
      let stringDate = DateUtil.format(new Date(1709986466274), undefined);
      expect(stringDate).assertEqual('1709986466274');
    })
    it('BrowserDateUtilTest_getLocalizedYearAndMonth', 0, () => {
      let yearAndMonth = DateUtil.getLocalizedYearAndMonth(1709986466274);
      expect(yearAndMonth).assertEqual('2024年3月');
    })
    it('BrowserDateUtilTest_getLocalizedMonthAndDay', 0, () => {
      let monthAndDay = DateUtil.getLocalizedMonthAndDay(1709986466274);
      expect(monthAndDay).assertEqual('3月9日');
    })
    it('BrowserDateUtilTest_getLocalizedMonth', 0, () => {
      let month = DateUtil.getLocalizedMonth(1709986466274);
      expect(month).assertEqual('3月');
    })

    it('BrowserDateUtilTest_getLocalizedDate', 0, () => {
      let date1 = DateUtil.getLocalizedDate(1709986466274, true);
      expect(date1).assertEqual('2024年3月9日');

      let date2 = DateUtil.getLocalizedDate(1709986466274, false);
      expect(date2).assertEqual('3月9日');
    })

    it('BrowserDateUtilTest_getLocalizedYearString', 0, () => {
      let res1 = DateUtil.getLocalizedYearString(1709986466274);
      expect(res1).assertEqual('2024年');
    })

    it('BrowserDateUtilTest_getLocalizedYear', 0, () => {
      let res1 = DateUtil.getLocalizedYear(1709986466274);
      expect(res1).assertEqual('2024年');
    })

    it('BrowserDateUtilTest_isTimeIntervalOver24Hours', 0, () => {
      let res1 = DateUtil.isTimeIntervalOver24Hours(1709986466274, 1709986466374);
      expect(res1).assertEqual(false);
    })

    it('BrowserDateUtilTest_getLocalizedDay', 0, () => {
      let res1 = DateUtil.getLocalizedDay(1709986466274);
      expect(res1).assertEqual('9日');
    })

    it('BrowserDateUtilTest_getFormattedDuration1', 0, () => {
      let res1 = DateUtil.getFormattedDuration(1709986466274);
      expect(res1).assertEqual('474996:14:26');
    })

    it('BrowserDateUtilTest_getFormattedDuration2', 0, () => {
      let res2 = DateUtil.getFormattedDuration(0);
      expect(res2).assertEqual('00:00');
    })

    it('BrowserDateUtilTest_getFormattedDuration3', 0, () => {
      let res3 = DateUtil.getFormattedDuration(999);
      expect(res3).assertEqual('00:01');
    })

    it('BrowserDateUtilTest_getFormattedDuration4', 0, () => {
      let res4 = DateUtil.getFormattedDuration(3599 * 3600);
      expect(res4).assertEqual('3:35:56');
    })

    it('BrowserDateUtilTest_getFormattedDuration5', 0, () => {
      let res5 = DateUtil.getFormattedDuration(3599);
      expect(res5).assertEqual('00:03');
    })

    it('BrowserDateUtilTest_getFormattedDurationForScreenReader1', 0, () => {
      let res1 = DateUtil.getFormattedDurationForScreenReader(1709986466274);
      expect(res1).assertEqual('474996:14:26');
    })

    it('BrowserDateUtilTest_getFormattedDurationForScreenReader2', 0, () => {
      let res2 = DateUtil.getFormattedDurationForScreenReader(0);
      expect(res2).assertEqual('00:00:00');
    })

    it('BrowserDateUtilTest_getFormattedDurationForScreenReader3', 0, () => {
      let res3 = DateUtil.getFormattedDurationForScreenReader(999);
      expect(res3).assertEqual('00:00:01');
    })

    it('BrowserDateUtilTest_getFormattedDurationForScreenReader4', 0, () => {
      let res4 = DateUtil.getFormattedDurationForScreenReader(3599);
      expect(res4).assertEqual('00:00:03');
    })

    it('BrowserDateUtilTest_getFormattedDurationForScreenReader5', 0, () => {
      let res5 = DateUtil.getFormattedDurationForScreenReader(3599 * 3600);
      expect(res5).assertEqual('3:35:56');
    })

    it('BrowserDateUtilTest_isTheSameDay1', 0, () => {
      let res1 = DateUtil.isTheSameDay(1709986466274, 1709986466274);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_isTheSameDay2', 0, () => {
      let res2 = DateUtil.isTheSameDay(1709986466274, 1719986466274);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameDay3', 0, () => {
      let res1 = DateUtil.isTheSameDay(1709986466273, 1709986466273);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_isTheSameDay4', 0, () => {
      let res2 = DateUtil.isTheSameDay(1709986466273, 1719986466273);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameDay5', 0, () => {
      let res1 = DateUtil.isTheSameDay(1709986466275, 1709986466275);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_isTheSameDay6', 0, () => {
      let res2 = DateUtil.isTheSameDay(1709986466276, 1719986466276);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameDay7', 0, () => {
      let res2 = DateUtil.isTheSameDay(1709986436275, 1719986466275);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameDay8', 0, () => {
      let res2 = DateUtil.isTheSameDay(1709986466275, 1719986426275);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameDay9', 0, () => {
      let res2 = DateUtil.isTheSameDay(17086466275, 1719986266275);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameDay10', 0, () => {
      let res2 = DateUtil.isTheSameDay(0, 1719986466275);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameDay12', 0, () => {
      let res2 = DateUtil.isTheSameDay(17096275, 1719986466275);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameDay13', 0, () => {
      let res2 = DateUtil.isTheSameDay(1709627, 1719986466275);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameDay14', 0, () => {
      let res2 = DateUtil.isTheSameDay(170962, 1719986466275);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameDay15', 0, () => {
      let res2 = DateUtil.isTheSameDay(17096, 1719986466275);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameDay16', 0, () => {
      let res2 = DateUtil.isTheSameDay(1709, 1719986466275);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameDay17', 0, () => {
      let res2 = DateUtil.isTheSameDay(170, 1719986466275);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameDay18', 0, () => {
      let res2 = DateUtil.isTheSameDay(17, 1719986466275);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameDay19', 0, () => {
      let res2 = DateUtil.isTheSameDay(1, 1719986466275);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameDay20', 0, () => {
      let res2 = DateUtil.isTheSameDay(7, 1719986466275);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameMonth1', 0, () => {
      let res1 = DateUtil.isTheSameMonth(1709986466274, 1709986466274);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_isTheSameMonth2', 0, () => {
      let res2 = DateUtil.isTheSameMonth(1709986466274, 1719986466274);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameMonth3', 0, () => {
      let res2 = DateUtil.isTheSameMonth(170998646627, 1719986466274);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameMonth4', 0, () => {
      let res2 = DateUtil.isTheSameMonth(170964662, 1719986466274);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameMonth5', 0, () => {
      let res2 = DateUtil.isTheSameMonth(1709986466, 1719986466274);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameMonth6', 0, () => {
      let res2 = DateUtil.isTheSameMonth(170998646, 1719986466274);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameMonth7', 0, () => {
      let res2 = DateUtil.isTheSameMonth(17099864, 1719986466274);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameMonth8', 0, () => {
      let res2 = DateUtil.isTheSameMonth(1709986, 1719986466274);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameMonth9', 0, () => {
      let res2 = DateUtil.isTheSameMonth(170998, 1719986466274);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameMonth10', 0, () => {
      let res2 = DateUtil.isTheSameMonth(17099, 1719986466274);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameMonth11', 0, () => {
      let res2 = DateUtil.isTheSameMonth(1709, 1719986466274);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameMonth12', 0, () => {
      let res2 = DateUtil.isTheSameMonth(170, 1719986466274);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameMonth13', 0, () => {
      let res2 = DateUtil.isTheSameMonth(17, 1719986466274);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameMonth14', 0, () => {
      let res2 = DateUtil.isTheSameMonth(1, 1719986466274);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameMonth15', 0, () => {
      let res2 = DateUtil.isTheSameMonth(0, 1719986466274);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameMonth16', 0, () => {
      let res1 = DateUtil.isTheSameMonth(0, 0);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_isTheSameMonth17', 0, () => {
      let res1 = DateUtil.isTheSameMonth(17, 17);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_isTheSameMonth18', 0, () => {
      let res1 = DateUtil.isTheSameMonth(1709, 1709);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_isTheSameMonth19', 0, () => {
      let res1 = DateUtil.isTheSameMonth(1709986, 1709986);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_isTheSameMonth20', 0, () => {
      let res1 = DateUtil.isTheSameMonth(17099, 17099);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_isTheSameYear1', 0, () => {
      let res1 = DateUtil.isTheSameYear(1709986466274, 1709986466274);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_isTheSameYear2', 0, () => {
      let res1 = DateUtil.isTheSameYear(1709986466272, 1709986466274);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_isTheSameYear3', 0, () => {
      let res1 = DateUtil.isTheSameYear(1709986466000, 1709986466274);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_isTheSameYear4', 0, () => {
      let res1 = DateUtil.isTheSameYear(709986466274, 1709986466274);
      expect(res1).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameYear5', 0, () => {
      let res1 = DateUtil.isTheSameYear(9986466274, 1709986466274);
      expect(res1).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameYear6', 0, () => {
      let res1 = DateUtil.isTheSameYear(986466274, 1709986466274);
      expect(res1).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameYear7', 0, () => {
      let res1 = DateUtil.isTheSameYear(86466274, 1709986466274);
      expect(res1).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameYear8', 0, () => {
      let res1 = DateUtil.isTheSameYear(6466274, 1709986466274);
      expect(res1).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameYear9', 0, () => {
      let res1 = DateUtil.isTheSameYear(466274, 1709986466274);
      expect(res1).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameYear10', 0, () => {
      let res1 = DateUtil.isTheSameYear(66274, 1709986466274);
      expect(res1).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameYear11', 0, () => {
      let res1 = DateUtil.isTheSameYear(6274, 1709986466274);
      expect(res1).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameYear12', 0, () => {
      let res1 = DateUtil.isTheSameYear(274, 1709986466274);
      expect(res1).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameYear13', 0, () => {
      let res1 = DateUtil.isTheSameYear(74, 1709986466274);
      expect(res1).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameYear14', 0, () => {
      let res1 = DateUtil.isTheSameYear(0, 1709986466274);
      expect(res1).assertEqual(false);
    })

    it('BrowserDateUtilTest_isTheSameYear15', 0, () => {
      let res1 = DateUtil.isTheSameYear(1709986466174, 1709986466274);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_isTheSameYear16', 0, () => {
      let res1 = DateUtil.isTheSameYear(1709986466374, 1709986466274);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_isTheSameYear17', 0, () => {
      let res1 = DateUtil.isTheSameYear(1709986461274, 1709986466274);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_isTheSameYear18', 0, () => {
      let res1 = DateUtil.isTheSameYear(1709986416274, 1709986466274);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_isTheSameYear19', 0, () => {
      let res1 = DateUtil.isTheSameYear(1709986466974, 1709986466274);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_isTheSameYear20', 0, () => {
      let res1 = DateUtil.isTheSameYear(1709986466774, 1709986466274);
      expect(res1).assertEqual(true);
    })

    it('BrowserDateUtilTest_convertSecondsToDays1', 0, () => {
      let res1 = DateUtil.convertSecondsToDays(1709986466274);
      expect(res1).assertEqual(19792);
    })

    it('BrowserDateUtilTest_convertSecondsToDays2', 0, () => {
      let res2 = DateUtil.convertSecondsToDays(1);
      expect(res2).assertEqual(2);
    })

    it('BrowserDateUtilTest_convertSecondsToDays3', 0, () => {
      let res3 = DateUtil.convertSecondsToDays(0);
      expect(res3).assertEqual(0);
    })

    // 当前时间戳无法精确断言，仅判断长度是否大于0
    it('BrowserDateUtilTest_getFullTime', 0, () => {
      let res = DateUtil.getFullTime();
      expect(res.length > 0).assertTrue();
    })

    it('BrowserDateUtilTest_isSameDay1', 0, () => {
      let res1 = DateUtil.isSameDay(1709986466274);
      expect(res1).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay2', 0, () => {
      let res2 = DateUtil.isSameDay(1);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay3', 0, () => {
      let res2 = DateUtil.isSameDay(17);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay4', 0, () => {
      let res2 = DateUtil.isSameDay(171);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay5', 0, () => {
      let res2 = DateUtil.isSameDay(1712);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay6', 0, () => {
      let res2 = DateUtil.isSameDay(17123);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay7', 0, () => {
      let res2 = DateUtil.isSameDay(171256);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay8', 0, () => {
      let res2 = DateUtil.isSameDay(1759866);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay9', 0, () => {
      let res2 = DateUtil.isSameDay(17156216);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay10', 0, () => {
      let res2 = DateUtil.isSameDay(174545699);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay11', 0, () => {
      let res2 = DateUtil.isSameDay(17569985269);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay12', 0, () => {
      let res2 = DateUtil.isSameDay(1000000000);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay13', 0, () => {
      let res2 = DateUtil.isSameDay(100000000000);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay14', 0, () => {
      let res2 = DateUtil.isSameDay(100000000000);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay15', 0, () => {
      let res2 = DateUtil.isSameDay(10);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay16', 0, () => {
      let res2 = DateUtil.isSameDay(100);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay17', 0, () => {
      let res2 = DateUtil.isSameDay(1000);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay18', 0, () => {
      let res2 = DateUtil.isSameDay(1000);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay19', 0, () => {
      let res2 = DateUtil.isSameDay(10000);
      expect(res2).assertEqual(false);
    })

    it('BrowserDateUtilTest_isSameDay20', 0, () => {
      let res2 = DateUtil.isSameDay(100000);
      expect(res2).assertEqual(false);
    })
  })
}