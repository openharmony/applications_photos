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
import {
  Priority,
  YearMonthQueryParam } from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthQueryParam';

export default function YearMonthQueryParamTest() {
  describe('YearMonthQueryParamTest', () => {

    it('should_initialize_correctly_when_all_parameters_are_provided', 0, () => {
      let start: number = 1;
      let count: number = 2;
      let priority: Priority = Priority.LOW;
      let isPreQuery: boolean = true;
      let isForceSyncQuery: boolean = true;
      let param: YearMonthQueryParam = new YearMonthQueryParam(start, count, priority, isPreQuery, isForceSyncQuery);
      expect(param.start).assertEqual(start);
      expect(param.count).assertEqual(count);
      expect(param.priority).assertEqual(priority);
      expect(param.isPreQuery).assertEqual(isPreQuery);
      expect(param.isForceSyncQuery).assertEqual(isForceSyncQuery);
    });

    it('should_initialize_correctly_when_isPreQuery_is_not_provided', 0, () => {
      let start: number = 1;
      let count: number = 2;
      let priority: Priority = Priority.LOW;
      let isForceSyncQuery: boolean = true;
      let param: YearMonthQueryParam = new YearMonthQueryParam(start, count, priority, undefined, isForceSyncQuery);
      expect(param.start).assertEqual(start);
      expect(param.count).assertEqual(count);
      expect(param.priority).assertEqual(priority);
      expect(param.isPreQuery).assertEqual(false); // Default value should be false
      expect(param.isForceSyncQuery).assertEqual(isForceSyncQuery);
    });

    it('should_initialize_correctly_when_isForceSyncQuery_is_not_provided', 0, () => {
      let start: number = 1;
      let count: number = 2;
      let priority: Priority = Priority.LOW;
      let isPreQuery: boolean = true;
      let param: YearMonthQueryParam = new YearMonthQueryParam(start, count, priority, isPreQuery);
      expect(param.start).assertEqual(start);
      expect(param.count).assertEqual(count);
      expect(param.priority).assertEqual(priority);
      expect(param.isPreQuery).assertEqual(isPreQuery);
      expect(param.isForceSyncQuery).assertEqual(false); // Default value should be false
    });

    it('should_initialize_correctly_when_all_parameters_are_not_provided', 0, () => {
      let start: number = 1;
      let count: number = 2;
      let priority: Priority = Priority.LOW;
      let param: YearMonthQueryParam = new YearMonthQueryParam(start, count, priority);
      expect(param.start).assertEqual(start);
      expect(param.count).assertEqual(count);
      expect(param.priority).assertEqual(priority);
      expect(param.isPreQuery).assertEqual(false); // Default value should be false
      expect(param.isForceSyncQuery).assertEqual(false); // Default value should be false
    });


    it('should_return_true_when_start_is_0_and_count_is_greater_than_0', 0, () => {
      let param: YearMonthQueryParam = new YearMonthQueryParam(0, 1, Priority.HIGH);
      expect(param.isValid()).assertTrue();
    });

    it('should_return_true_when_start_is_greater_than_0_and_count_is_greater_than_0', 0, () => {
      let param: YearMonthQueryParam = new YearMonthQueryParam(1, 1, Priority.HIGH);
      expect(param.isValid()).assertTrue();
    });

    it('should_return_false_when_start_is_less_than_0_and_count_is_greater_than_0', 0, () => {
      let param: YearMonthQueryParam = new YearMonthQueryParam(-1, 1, Priority.HIGH);
      expect(param.isValid()).assertFalse();
    });

    it('should_return_false_when_start_is_0_and_count_is_0', 0, () => {
      let param: YearMonthQueryParam = new YearMonthQueryParam(0, 0, Priority.HIGH);
      expect(param.isValid()).assertFalse();
    });

    it('should_return_false_when_start_is_greater_than_0_and_count_is_0', 0, () => {
      let param: YearMonthQueryParam = new YearMonthQueryParam(1, 0, Priority.HIGH);
      expect(param.isValid()).assertFalse();
    });

    it('should_return_correct_string_when_all_params_are_provided', 0, () => {
      let param: YearMonthQueryParam = new YearMonthQueryParam(1, 10, Priority.HIGH, true, true);
      const result = param.toString();
      expect(result).assertEqual('queryParam:[prio:1, start:1, cnt:10]');
    });

    it('should_return_correct_string_when_isPreQuery_is_false', 0, () => {
      let param: YearMonthQueryParam = new YearMonthQueryParam(1, 10, Priority.HIGH, false, true);
      const result = param.toString();
      expect(result).assertEqual('queryParam:[prio:1, start:1, cnt:10]');
    });

    it('should_return_correct_string_when_isForceSyncQuery_is_false', 0, () => {
      let param: YearMonthQueryParam = new YearMonthQueryParam(1, 10, Priority.HIGH, true, false);
      const result = param.toString();
      expect(result).assertEqual('queryParam:[prio:1, start:1, cnt:10]');
    });

    it('should_return_correct_string_when_all_params_are_false', 0, () => {
      let param: YearMonthQueryParam = new YearMonthQueryParam(1, 10, Priority.HIGH, false, false);
      const result = param.toString();
      expect(result).assertEqual('queryParam:[prio:1, start:1, cnt:10]');
    });

    it('should_return_true_when_start_is_0_and_count_is_greater_than_0', 0, () => {
      let param: YearMonthQueryParam = new YearMonthQueryParam(0, 1, Priority.HIGH);
      expect(param.isValid()).assertTrue();
    });

    it('should_return_true_when_start_is_greater_than_0_and_count_is_greater_than_0', 0, () => {
      let param: YearMonthQueryParam = new YearMonthQueryParam(1, 1, Priority.HIGH);
      expect(param.isValid()).assertTrue();
    });

    it('should_return_false_when_start_is_less_than_0_and_count_is_greater_than_0', 0, () => {
      let param: YearMonthQueryParam = new YearMonthQueryParam(-1, 1, Priority.HIGH);
      expect(param.isValid()).assertFalse();
    });

    it('should_return_false_when_start_is_0_and_count_is_0', 0, () => {
      let param: YearMonthQueryParam = new YearMonthQueryParam(0, 0, Priority.HIGH);
      expect(param.isValid()).assertFalse();
    });

    it('should_return_false_when_start_is_greater_than_0_and_count_is_0', 0, () => {
      let param: YearMonthQueryParam = new YearMonthQueryParam(1, 0, Priority.HIGH);
      expect(param.isValid()).assertFalse();
    });

  });
}