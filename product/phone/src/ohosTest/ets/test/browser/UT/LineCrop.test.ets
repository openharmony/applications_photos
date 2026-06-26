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

import { UiDirection } from '@kit.TestKit';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { ratioAtLine } from '@ohos/tools/src/ohosTest/ets/Comp';

// Tag for logging test suite execution
const TAG: string = 'DT/ratioAtLineTest';

export default function ratioAtLineTest() {
  describe('ratioAtLine_testSuite', () => {

    beforeEach(() => {
    });

    afterEach(() => {
    });

    // Test case: Positive left, right, and ratio
    it('should_return_correct_value_when_left_right_and_ratio_are_all_positive_numbers', 0, () => {
      Log.info(TAG, `Testing positive left, right, and ratio`);
      let left: number = 10;
      let right: number = 20;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(15);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Negative left, positive right, and positive ratio
    it('should_return_correct_value_when_left_is_negative_and_right_is_positive', 0, () => {
      Log.info(TAG, `Testing negative left, positive right, and positive ratio`);
      let left: number = -10;
      let right: number = 20;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(5);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Positive left, negative right, and positive ratio
    it('should_return_correct_value_when_left_is_positive_and_right_is_negative', 0, () => {
      Log.info(TAG, `Testing positive left, negative right, and positive ratio`);
      let left: number = 10;
      let right: number = -20;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-5);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Negative left, negative right, and positive ratio
    it('should_return_correct_value_when_left_right_and_ratio_are_all_negative_numbers', 0, () => {
      Log.info(TAG, `Testing negative left, negative right, and positive ratio`);
      let left: number = -10;
      let right: number = -20;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-15);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio is zero
    it('should_return_correct_value_when_ratio_is_zero', 0, () => {
      Log.info(TAG, `Testing ratio equals zero`);
      let left: number = 10;
      let right: number = 20;
      let ratio: number = 0;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio is one
    it('should_return_correct_value_when_ratio_is_one', 0, () => {
      Log.info(TAG, `Testing ratio equals one`);
      let left: number = 10;
      let right: number = 20;
      let ratio: number = 1;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(20);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Zero left and positive right
    it('should_return_correct_value_when_left_is_zero_and_right_is_positive', 0, () => {
      Log.info(TAG, `Testing zero left and positive right`);
      let left: number = 0;
      let right: number = 100;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(50);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Positive left and zero right
    it('should_return_correct_value_when_left_is_positive_and_right_is_zero', 0, () => {
      Log.info(TAG, `Testing positive left and zero right`);
      let left: number = 100;
      let right: number = 0;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(50);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Zero left and zero right
    it('should_return_correct_value_when_left_and_right_are_zero', 0, () => {
      Log.info(TAG, `Testing zero left and zero right`);
      let left: number = 0;
      let right: number = 0;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(0);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Fractional ratio
    it('should_return_correct_value_when_ratio_is_fractional', 0, () => {
      Log.info(TAG, `Testing fractional ratio`);
      let left: number = 10;
      let right: number = 20;
      let ratio: number = 0.25;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(12.5, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Large positive numbers
    it('should_return_correct_value_for_large_positive_numbers', 0, () => {
      Log.info(TAG, `Testing large positive numbers`);
      let left: number = 1000;
      let right: number = 2000;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(1500);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Large negative numbers
    it('should_return_correct_value_for_large_negative_numbers', 0, () => {
      Log.info(TAG, `Testing large negative numbers`);
      let left: number = -1000;
      let right: number = -2000;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-1500);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Mixed large positive and negative numbers
    it('should_return_correct_value_for_mixed_large_numbers', 0, () => {
      Log.info(TAG, `Testing mixed large positive and negative numbers`);
      let left: number = -1000;
      let right: number = 2000;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(500);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Small fractional numbers
    it('should_return_correct_value_for_small_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing small fractional numbers`);
      let left: number = 0.1;
      let right: number = 0.2;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(0.15, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Negative fractional numbers
    it('should_return_correct_value_for_negative_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing negative fractional numbers`);
      let left: number = -0.1;
      let right: number = -0.2;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-0.15, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Mixed fractional numbers
    it('should_return_correct_value_for_mixed_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing mixed fractional numbers`);
      let left: number = -0.1;
      let right: number = 0.2;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(0.05, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio slightly above zero
    it('should_return_correct_value_when_ratio_is_slightly_above_zero', 0, () => {
      Log.info(TAG, `Testing ratio slightly above zero`);
      let left: number = 10;
      let right: number = 20;
      let ratio: number = 0.01;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(10.1, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio slightly below one
    it('should_return_correct_value_when_ratio_is_slightly_below_one', 0, () => {
      Log.info(TAG, `Testing ratio slightly below one`);
      let left: number = 10;
      let right: number = 20;
      let ratio: number = 0.99;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(19.9, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Extreme positive numbers
    it('should_return_correct_value_for_extreme_positive_numbers', 0, () => {
      Log.info(TAG, `Testing extreme positive numbers`);
      let left: number = Number.MAX_SAFE_INTEGER - 1000;
      let right: number = Number.MAX_SAFE_INTEGER;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertLargerOrEqual(Number.MAX_SAFE_INTEGER - 500);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Extreme negative numbers
    it('should_return_correct_value_for_extreme_negative_numbers', 0, () => {
      Log.info(TAG, `Testing extreme negative numbers`);
      let left: number = Number.MIN_SAFE_INTEGER;
      let right: number = Number.MIN_SAFE_INTEGER + 1000;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertLessOrEqual(Number.MIN_SAFE_INTEGER + 500);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Zero ratio with negative numbers
    it('should_return_correct_value_when_ratio_is_zero_with_negative_numbers', 0, () => {
      Log.info(TAG, `Testing zero ratio with negative numbers`);
      let left: number = -50;
      let right: number = -100;
      let ratio: number = 0;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-50);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: One ratio with negative numbers
    it('should_return_correct_value_when_ratio_is_one_with_negative_numbers', 0, () => {
      Log.info(TAG, `Testing one ratio with negative numbers`);
      let left: number = -50;
      let right: number = -100;
      let ratio: number = 1;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-100);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.25 with mixed numbers
    it('should_return_correct_value_when_ratio_is_0_25_with_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.25 with mixed numbers`);
      let left: number = -100;
      let right: number = 100;
      let ratio: number = 0.25;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-50);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.75 with mixed numbers
    it('should_return_correct_value_when_ratio_is_0_75_with_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.75 with mixed numbers`);
      let left: number = -100;
      let right: number = 100;
      let ratio: number = 0.75;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(50);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.1 with large numbers
    it('should_return_correct_value_when_ratio_is_0_1_with_large_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.1 with large numbers`);
      let left: number = 1000;
      let right: number = 2000;
      let ratio: number = 0.1;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(1100);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.9 with large numbers
    it('should_return_correct_value_when_ratio_is_0_9_with_large_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.9 with large numbers`);
      let left: number = 1000;
      let right: number = 2000;
      let ratio: number = 0.9;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(1900);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.33 with negative numbers
    it('should_return_correct_value_when_ratio_is_0_33_with_negative_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.33 with negative numbers`);
      let left: number = -100;
      let right: number = -200;
      let ratio: number = 0.33;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-133, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.67 with negative numbers
    it('should_return_correct_value_when_ratio_is_0_67_with_negative_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.67 with negative numbers`);
      let left: number = -100;
      let right: number = -200;
      let ratio: number = 0.67;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-167, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.2 with mixed numbers
    it('should_return_correct_value_when_ratio_is_0_2_with_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.2 with mixed numbers`);
      let left: number = -50;
      let right: number = 50;
      let ratio: number = 0.2;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-30);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.8 with mixed numbers
    it('should_return_correct_value_when_ratio_is_0_8_with_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.8 with mixed numbers`);
      let left: number = -50;
      let right: number = 50;
      let ratio: number = 0.8;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(30);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.4 with large mixed numbers
    it('should_return_correct_value_when_ratio_is_0_4_with_large_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.4 with large mixed numbers`);
      let left: number = -1000;
      let right: number = 1000;
      let ratio: number = 0.4;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-200);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.6 with large mixed numbers
    it('should_return_correct_value_when_ratio_is_0_6_with_large_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.6 with large mixed numbers`);
      let left: number = -1000;
      let right: number = 1000;
      let ratio: number = 0.6;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(200);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.15 with fractional numbers
    it('should_return_correct_value_when_ratio_is_0_15_with_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.15 with fractional numbers`);
      let left: number = 0.5;
      let right: number = 1.5;
      let ratio: number = 0.15;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(0.65, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.85 with fractional numbers
    it('should_return_correct_value_when_ratio_is_0_85_with_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.85 with fractional numbers`);
      let left: number = 0.5;
      let right: number = 1.5;
      let ratio: number = 0.85;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(1.35, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.3 with negative fractional numbers
    it('should_return_correct_value_when_ratio_is_0_3_with_negative_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.3 with negative fractional numbers`);
      let left: number = -0.5;
      let right: number = -1.5;
      let ratio: number = 0.3;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-0.8, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.7 with negative fractional numbers
    it('should_return_correct_value_when_ratio_is_0_7_with_negative_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.7 with negative fractional numbers`);
      let left: number = -0.5;
      let right: number = -1.5;
      let ratio: number = 0.7;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-1.2, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.5 with very small numbers
    it('should_return_correct_value_when_ratio_is_0_5_with_very_small_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.5 with very small numbers`);
      let left: number = 0.0001;
      let right: number = 0.0002;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(0.00015, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.5 with very large numbers
    it('should_return_correct_value_when_ratio_is_0_5_with_very_large_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.5 with very large numbers`);
      let left: number = 1000000;
      let right: number = 2000000;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(1500000);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.1 with very small negative numbers
    it('should_return_correct_value_when_ratio_is_0_1_with_very_small_negative_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.1 with very small negative numbers`);
      let left: number = -0.0001;
      let right: number = -0.0002;
      let ratio: number = 0.1;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-0.00011, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.9 with very small negative numbers
    it('should_return_correct_value_when_ratio_is_0_9_with_very_small_negative_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.9 with very small negative numbers`);
      let left: number = -0.0001;
      let right: number = -0.0002;
      let ratio: number = 0.9;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-0.00019, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.2 with very large mixed numbers
    it('should_return_correct_value_when_ratio_is_0_2_with_very_large_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.2 with very large mixed numbers`);
      let left: number = -1000000;
      let right: number = 1000000;
      let ratio: number = 0.2;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-600000);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.8 with very large mixed numbers
    it('should_return_correct_value_when_ratio_is_0_8_with_very_large_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.8 with very large mixed numbers`);
      let left: number = -1000000;
      let right: number = 1000000;
      let ratio: number = 0.8;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(600000);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.05 with positive numbers
    it('should_return_correct_value_when_ratio_is_0_05_with_positive_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.05 with positive numbers`);
      let left: number = 50;
      let right: number = 100;
      let ratio: number = 0.05;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(52.5, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.95 with positive numbers
    it('should_return_correct_value_when_ratio_is_0_95_with_positive_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.95 with positive numbers`);
      let left: number = 50;
      let right: number = 100;
      let ratio: number = 0.95;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(97.5, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.05 with negative numbers
    it('should_return_correct_value_when_ratio_is_0_05_with_negative_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.05 with negative numbers`);
      let left: number = -50;
      let right: number = -100;
      let ratio: number = 0.05;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-52.5, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.95 with negative numbers
    it('should_return_correct_value_when_ratio_is_0_95_with_negative_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.95 with negative numbers`);
      let left: number = -50;
      let right: number = -100;
      let ratio: number = 0.95;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-97.5, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.05 with mixed numbers
    it('should_return_correct_value_when_ratio_is_0_05_with_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.05 with mixed numbers`);
      let left: number = -50;
      let right: number = 50;
      let ratio: number = 0.05;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-45);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.95 with mixed numbers
    it('should_return_correct_value_when_ratio_is_0_95_with_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.95 with mixed numbers`);
      let left: number = -50;
      let right: number = 50;
      let ratio: number = 0.95;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(45);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.5 with identical left and right
    it('should_return_correct_value_when_left_and_right_are_identical', 0, () => {
      Log.info(TAG, `Testing identical left and right`);
      let left: number = 100;
      let right: number = 100;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(100);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0 with identical left and right
    it('should_return_correct_value_when_ratio_is_zero_and_left_right_identical', 0, () => {
      Log.info(TAG, `Testing ratio 0 with identical left and right`);
      let left: number = -100;
      let right: number = -100;
      let ratio: number = 0;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-100);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 1 with identical left and right
    it('should_return_correct_value_when_ratio_is_one_and_left_right_identical', 0, () => {
      Log.info(TAG, `Testing ratio 1 with identical left and right`);
      let left: number = -100;
      let right: number = -100;
      let ratio: number = 1;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-100);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.5 with small fractional numbers
    it('should_return_correct_value_when_ratio_is_0_5_with_small_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.5 with small fractional numbers`);
      let left: number = 0.01;
      let right: number = 0.02;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(0.015, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.5 with large fractional numbers
    it('should_return_correct_value_when_ratio_is_0_5_with_large_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.5 with large fractional numbers`);
      let left: number = 10.5;
      let right: number = 20.5;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(15.5, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.5 with very small mixed numbers
    it('should_return_correct_value_when_ratio_is_0_5_with_very_small_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.5 with very small mixed numbers`);
      let left: number = -0.01;
      let right: number = 0.01;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(0, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.1 with very small mixed numbers
    it('should_return_correct_value_when_ratio_is_0_1_with_very_small_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.1 with very small mixed numbers`);
      let left: number = -0.01;
      let right: number = 0.01;
      let ratio: number = 0.1;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-0.008, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.9 with very small mixed numbers
    it('should_return_correct_value_when_ratio_is_0_9_with_very_small_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.9 with very small mixed numbers`);
      let left: number = -0.01;
      let right: number = 0.01;
      let ratio: number = 0.9;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(0.008, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.5 with very large mixed fractional numbers
    it('should_return_correct_value_when_ratio_is_0_5_with_very_large_mixed_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.5 with very large mixed fractional numbers`);
      let left: number = -1000.5;
      let right: number = 1000.5;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(0, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.1 with very large mixed fractional numbers
    it('should_return_correct_value_when_ratio_is_0_1_with_very_large_mixed_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.1 with very large mixed fractional numbers`);
      let left: number = -1000.5;
      let right: number = 1000.5;
      let ratio: number = 0.1;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-800.4, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.9 with very large mixed fractional numbers
    it('should_return_correct_value_when_ratio_is_0_9_with_very_large_mixed_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.9 with very large mixed fractional numbers`);
      let left: number = -1000.5;
      let right: number = 1000.5;
      let ratio: number = 0.9;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(800.4, 1e-10);
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Multiple ratios with positive numbers
    it('should_return_correct_values_for_multiple_ratios_with_positive_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with positive numbers`);
      let left: number = 0;
      let right: number = 100;
      let ratios: number[] = [0, 0.25, 0.5, 0.75, 1];
      let expectedResults: number[] = [0, 25, 50, 75, 100];
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertEqual(expectedResults[index]);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Multiple ratios with negative numbers
    it('should_return_correct_values_for_multiple_ratios_with_negative_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with negative numbers`);
      let left: number = -100;
      let right: number = -200;
      let ratios: number[] = [0, 0.25, 0.5, 0.75, 1];
      let expectedResults: number[] = [-100, -125, -150, -175, -200];
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertEqual(expectedResults[index]);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Multiple ratios with mixed numbers
    it('should_return_correct_values_for_multiple_ratios_with_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with mixed numbers`);
      let left: number = -100;
      let right: number = 100;
      let ratios: number[] = [0, 0.25, 0.5, 0.75, 1];
      let expectedResults: number[] = [-100, -50, 0, 50, 100];
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertEqual(expectedResults[index]);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Multiple ratios with fractional numbers
    it('should_return_correct_values_for_multiple_ratios_with_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with fractional numbers`);
      let left: number = 0.1;
      let right: number = 0.2;
      let ratios: number[] = [0, 0.25, 0.5, 0.75, 1];
      let expectedResults: number[] = [0.1, 0.125, 0.15, 0.175, 0.2];
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertClose(expectedResults[index], 1e-10);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Multiple ratios with negative fractional numbers
    it('should_return_correct_values_for_multiple_ratios_with_negative_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with negative fractional numbers`);
      let left: number = -0.1;
      let right: number = -0.2;
      let ratios: number[] = [0, 0.25, 0.5, 0.75, 1];
      let expectedResults: number[] = [-0.1, -0.125, -0.15, -0.175, -0.2];
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertClose(expectedResults[index], 1e-10);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Multiple ratios with mixed fractional numbers
    it('should_return_correct_values_for_multiple_ratios_with_mixed_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with mixed fractional numbers`);
      let left: number = -0.1;
      let right: number = 0.1;
      let ratios: number[] = [0, 0.25, 0.5, 0.75, 1];
      let expectedResults: number[] = [-0.1, -0.05, 0, 0.05, 0.1];
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertClose(expectedResults[index], 1e-10);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Invalid ratio (negative)
    it('should_handle_negative_ratio', 0, () => {
      Log.info(TAG, `Testing negative ratio`);
      let left: number = 10;
      let right: number = 20;
      let ratio: number = -0.5;
      try {
        let result: number = ratioAtLine(left, right, ratio);
        throw new Error('Expected error for negative ratio');
      } catch (e) {
        expect(e.message).assertEqual('Expected error for negative ratio');
        Log.info(TAG, `Negative ratio error caught as expected`);
      }
    });

    // Test case: Invalid ratio (greater than one)
    it('should_handle_ratio_greater_than_one', 0, () => {
      Log.info(TAG, `Testing ratio greater than one`);
      let left: number = 10;
      let right: number = 20;
      let ratio: number = 1.5;
      try {
        let result: number = ratioAtLine(left, right, ratio);
        throw new Error('Expected error for ratio greater than one');
      } catch (e) {
        expect(e.message).assertEqual('Expected error for ratio greater than one');
        Log.info(TAG, `Ratio greater than one error caught as expected`);
      }
    });

    // Test case: Invalid left input (null)
    it('should_handle_null_left_input', 0, () => {
      Log.info(TAG, `Testing null left input`);
      let left: number = 0/0;
      let right: number = 20;
      let ratio: number = 0.5;
      try {
        let result: number = ratioAtLine(left, right, ratio);
        throw new Error('Expected error for null left input');
      } catch (e) {
        expect(e.message).assertEqual('Expected error for null left input');
        Log.info(TAG, `Null left input error caught as expected`);
      }
    });

    // Test case: Invalid right input (null)
    it('should_handle_null_right_input', 0, () => {
      Log.info(TAG, `Testing null right input`);
      let left: number = 10;
      let right: number = 0/0;
      let ratio: number = 0.5;
      try {
        let result: number = ratioAtLine(left, right, ratio);
        throw new Error('Expected error for null right input');
      } catch (e) {
        expect(e.message).assertEqual('Expected error for null right input');
        Log.info(TAG, `Null right input error caught as expected`);
      }
    });

    // Test case: Invalid ratio input (null)
    it('should_handle_null_ratio_input', 0, () => {
      Log.info(TAG, `Testing null ratio input`);
      let left: number = 10;
      let right: number = 20;
      let ratio: number = 0/0;
      try {
        let result: number = ratioAtLine(left, right, ratio);
        throw new Error('Expected error for null ratio input');
      } catch (e) {
        expect(e.message).assertEqual('Expected error for null ratio input');
        Log.info(TAG, `Null ratio input error caught as expected`);
      }
    });

    // Test case: Invalid left input (infinity)
    it('should_handle_minus_infinity_left_input', 0, () => {
      Log.info(TAG, `Testing infinity left input`);
      let left: number = -1/0;
      let right: number = 20;
      let ratio: number = 0.5;
      try {
        let result: number = ratioAtLine(left, right, ratio);
        throw new Error('Expected error for infinity left input');
      } catch (e) {
        expect(e.message).assertEqual('Expected error for infinity left input');
        Log.info(TAG, `infinity left input error caught as expected`);
      }
    });

    // Test case: Invalid right input (infinity)
    it('should_handle_minus_infinity_right_input', 0, () => {
      Log.info(TAG, `Testing infinity right input`);
      let left: number = 10;
      let right: number = -1/0;
      let ratio: number = 0.5;
      try {
        let result: number = ratioAtLine(left, right, ratio);
        throw new Error('Expected error for infinity right input');
      } catch (e) {
        expect(e.message).assertEqual('Expected error for infinity right input');
        Log.info(TAG, `infinity right input error caught as expected`);
      }
    });

    // Test case: Invalid ratio input (infinity)
    it('should_handle_minus_infinity_ratio_input', 0, () => {
      Log.info(TAG, `Testing infinity ratio input`);
      let left: number = 10;
      let right: number = 20;
      let ratio: number = -1/0;
      try {
        let result: number = ratioAtLine(left, right, ratio);
        throw new Error('Expected error for infinity ratio input');
      } catch (e) {
        expect(e.message).assertEqual('Expected error for infinity ratio input');
        Log.info(TAG, `infinity ratio input error caught as expected`);
      }
    });

    // Test case: Invalid left input (infinity)
    it('should_handle_infinity_left_input', 0, () => {
      Log.info(TAG, `Testing infinity left input`);
      let left: number = 1/0;
      let right: number = 20;
      let ratio: number = 0.5;
      try {
        let result: number = ratioAtLine(left, right, ratio);
        throw new Error('Expected error for infinity left input');
      } catch (e) {
        expect(e.message).assertEqual('Expected error for infinity left input');
        Log.info(TAG, `infinity left input error caught as expected`);
      }
    });

    // Test case: Invalid right input (infinity)
    it('should_handle_infinity_right_input', 0, () => {
      Log.info(TAG, `Testing infinity right input`);
      let left: number = 10;
      let right: number = 1/0;
      let ratio: number = 0.5;
      try {
        let result: number = ratioAtLine(left, right, ratio);
        throw new Error('Expected error for infinity right input');
      } catch (e) {
        expect(e.message).assertEqual('Expected error for infinity right input');
        Log.info(TAG, `infinity right input error caught as expected`);
      }
    });

    // Test case: Invalid ratio input (infinity)
    it('should_handle_infinity_ratio_input', 0, () => {
      Log.info(TAG, `Testing infinity ratio input`);
      let left: number = 10;
      let right: number = 20;
      let ratio: number = 1/0;
      try {
        let result: number = ratioAtLine(left, right, ratio);
        throw new Error('Expected error for infinity ratio input');
      } catch (e) {
        expect(e.message).assertEqual('Expected error for infinity ratio input');
        Log.info(TAG, `infinity ratio input error caught as expected`);
      }
    });


    // Test case: Invalid left input (undefined)
    it('should_handle_undefined_left_input', 0, () => {
      Log.info(TAG, `Testing undefined left input`);
      let left: number = Number.NaN;
      let right: number = 20;
      let ratio: number = 0.5;
      try {
        let result: number = ratioAtLine(left, right, ratio);
        throw new Error('Expected error for undefined left input');
      } catch (e) {
        expect(e.message).assertEqual('Expected error for undefined left input');
        Log.info(TAG, `Undefined left input error caught as expected`);
      }
    });

    // Test case: Invalid right input (undefined)
    it('should_handle_undefined_right_input', 0, () => {
      Log.info(TAG, `Testing undefined right input`);
      let left: number = 10;
      let right: number = Number.NaN;
      let ratio: number = 0.5;
      try {
        let result: number = ratioAtLine(left, right, ratio);
        throw new Error('Expected error for undefined right input');
      } catch (e) {
        expect(e.message).assertEqual('Expected error for undefined right input');
        Log.info(TAG, `Undefined right input error caught as expected`);
      }
    });

    // Test case: Invalid ratio input (undefined)
    it('should_handle_undefined_ratio_input', 0, () => {
      Log.info(TAG, `Testing undefined ratio input`);
      let left: number = 10;
      let right: number = 20;
      let ratio: number = Number.NaN;
      try {
        let result: number = ratioAtLine(left, right, ratio);
        throw new Error('Expected error for undefined ratio input');
      } catch (e) {
        expect(e.message).assertEqual('Expected error for undefined ratio input');
        Log.info(TAG, `Undefined ratio input error caught as expected`);
      }
    });

    // Test case: Multiple ratios with very small numbers
    it('should_return_correct_values_for_multiple_ratios_with_very_small_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with very small numbers`);
      let left: number = 0.0001;
      let right: number = 0.0002;
      let ratios: number[] = [0, 0.25, 0.5, 0.75, 1];
      let expectedResults: number[] = [0.0001, 0.000125, 0.00015, 0.000175, 0.0002];
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertClose(expectedResults[index], 1e-10);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Multiple ratios with very large numbers
    it('should_return_correct_values_for_multiple_ratios_with_very_large_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with very large numbers`);
      let left: number = 1000000;
      let right: number = 2000000;
      let ratios: number[] = [0, 0.25, 0.5, 0.75, 1];
      let expectedResults: number[] = [1000000, 1250000, 1500000, 1750000, 2000000];
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertEqual(expectedResults[index]);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Multiple ratios with very small mixed numbers
    it('should_return_correct_values_for_multiple_ratios_with_very_small_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with very small mixed numbers`);
      let left: number = -0.0001;
      let right: number = 0.0001;
      let ratios: number[] = [0, 0.25, 0.5, 0.75, 1];
      let expectedResults: number[] = [-0.0001, -0.00005, 0, 0.00005, 0.0001];
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertClose(expectedResults[index], 1e-10);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Multiple ratios with very large mixed numbers
    it('should_return_correct_values_for_multiple_ratios_with_very_large_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with very large mixed numbers`);
      let left: number = -1000000;
      let right: number = 1000000;
      let ratios: number[] = [0, 0.25, 0.5, 0.75, 1];
      let expectedResults: number[] = [-1000000, -500000, 0, 500000, 1000000];
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertEqual(expectedResults[index]);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });
  });
}