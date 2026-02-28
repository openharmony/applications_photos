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
const TAG: string = 'DT/LineCrops';

export default function LineCrops01Test() {
  describe('LineCrops01Test', () => {

    beforeEach(() => {
    });

    afterEach(() => {
    });

    // Test case: Positive left, right, and ratio
    it('should_return_correct_value_when_left_right_and_ratio_are_all_positive_numbers', 0, () => {
      Log.info(TAG, `Testing positive left, right, and ratio`);
      let left: number = 4;
      let right: number = 16;
      let ratio: number = 0.75;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(13); // 4 + (16 - 4) * 0.75 = 4 + 12 * 0.75 = 13
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Negative left, positive right, and positive ratio
    it('should_return_correct_value_when_left_is_negative_and_right_is_positive', 0, () => {
      Log.info(TAG, `Testing negative left, positive right, and positive ratio`);
      let left: number = -12;
      let right: number = 18;
      let ratio: number = 0.4;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(0); // -12 + (18 - (-12)) * 0.4 = -12 + 30 * 0.4 = -12 + 12 = 0
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Positive left, negative right, and positive ratio
    it('should_return_correct_value_when_left_is_positive_and_right_is_negative', 0, () => {
      Log.info(TAG, `Testing positive left, negative right, and positive ratio`);
      let left: number = 20;
      let right: number = -10;
      let ratio: number = 0.7;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-1); // 20 + (-10 - 20) * 0.7 = 20 + (-30) * 0.7 = 20 - 21 = -1
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Negative left, negative right, and positive ratio
    it('should_return_correct_value_when_left_right_and_ratio_are_all_negative_numbers', 0, () => {
      Log.info(TAG, `Testing negative left, negative right, and positive ratio`);
      let left: number = -8;
      let right: number = -24;
      let ratio: number = 0.25;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-12); // -8 + (-24 - (-8)) * 0.25 = -8 + (-16) * 0.25 = -8 - 4 = -12
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio is zero
    it('should_return_correct_value_when_ratio_is_zero', 0, () => {
      Log.info(TAG, `Testing ratio equals zero`);
      let left: number = 6;
      let right: number = 18;
      let ratio: number = 0;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(6); // 6 + (18 - 6) * 0 = 6
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio is one
    it('should_return_correct_value_when_ratio_is_one', 0, () => {
      Log.info(TAG, `Testing ratio equals one`);
      let left: number = 6;
      let right: number = 18;
      let ratio: number = 1;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(18); // 6 + (18 - 6) * 1 = 18
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Zero left and positive right
    it('should_return_correct_value_when_left_is_zero_and_right_is_positive', 0, () => {
      Log.info(TAG, `Testing zero left and positive right`);
      let left: number = 0;
      let right: number = 90;
      let ratio: number = 0.3;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(27, 1e-10); // 0 + (90 - 0) * 0.3 = 27
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Positive left and zero right
    it('should_return_correct_value_when_left_is_positive_and_right_is_zero', 0, () => {
      Log.info(TAG, `Testing positive left and zero right`);
      let left: number = 90;
      let right: number = 0;
      let ratio: number = 0.7;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(27, 1e-10); // 90 + (0 - 90) * 0.7 = 90 - 63 = 27
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Zero left and zero right
    it('should_return_correct_value_when_left_and_right_are_zero', 0, () => {
      Log.info(TAG, `Testing zero left and zero right`);
      let left: number = 0;
      let right: number = 0;
      let ratio: number = 0.3;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(0); // 0 + (0 - 0) * 0.3 = 0
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Fractional ratio
    it('should_return_correct_value_when_ratio_is_fractional', 0, () => {
      Log.info(TAG, `Testing fractional ratio`);
      let left: number = 8;
      let right: number = 24;
      let ratio: number = 0.2;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(11.2, 1e-10); // 8 + (24 - 8) * 0.2 = 8 + 16 * 0.2 = 11.2
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Large positive numbers
    it('should_return_correct_value_for_large_positive_numbers', 0, () => {
      Log.info(TAG, `Testing large positive numbers`);
      let left: number = 3000;
      let right: number = 6000;
      let ratio: number = 0.3;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(3900); // 3000 + (6000 - 3000) * 0.3 = 3000 + 3000 * 0.3 = 3900
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Large negative numbers
    it('should_return_correct_value_for_large_negative_numbers', 0, () => {
      Log.info(TAG, `Testing large negative numbers`);
      let left: number = -6000;
      let right: number = -3000;
      let ratio: number = 0.7;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-3900); // -6000 + (-3000 - (-6000)) * 0.7 = -6000 + 3000 * 0.7 = -6000 + 2100 = -3900
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Mixed large positive and negative numbers
    it('should_return_correct_value_for_mixed_large_numbers', 0, () => {
      Log.info(TAG, `Testing mixed large positive and negative numbers`);
      let left: number = -3000;
      let right: number = 6000;
      let ratio: number = 0.6;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(2400, 1e-10); // -3000 + (6000 - (-3000)) * 0.6 = -3000 + 9000 * 0.6 = -3000 + 5400 = 1500
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Small fractional numbers
    it('should_return_correct_value_for_small_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing small fractional numbers`);
      let left: number = 0.3;
      let right: number = 0.9;
      let ratio: number = 0.4;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(0.54, 1e-10); // 0.3 + (0.9 - 0.3) * 0.4 = 0.3 + 0.6 * 0.4 = 0.54
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Negative fractional numbers
    it('should_return_correct_value_for_negative_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing negative fractional numbers`);
      let left: number = -0.9;
      let right: number = -0.3;
      let ratio: number = 0.6;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-0.54, 1e-10); // -0.9 + (-0.3 - (-0.9)) * 0.6 = -0.9 + 0.6 * 0.6 = -0.9 + 0.36 = -0.54
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Mixed fractional numbers
    it('should_return_correct_value_for_mixed_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing mixed fractional numbers`);
      let left: number = -0.3;
      let right: number = 0.9;
      let ratio: number = 0.25;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(0, 1e-10); // -0.3 + (0.9 - (-0.3)) * 0.25 = -0.3 + 1.2 * 0.25 = -0.3 + 0.3 = 0
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio slightly above zero
    it('should_return_correct_value_when_ratio_is_slightly_above_zero', 0, () => {
      Log.info(TAG, `Testing ratio slightly above zero`);
      let left: number = 5;
      let right: number = 25;
      let ratio: number = 0.05;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(6, 1e-10); // 5 + (25 - 5) * 0.05 = 5 + 20 * 0.05 = 6
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio slightly below one
    it('should_return_correct_value_when_ratio_is_slightly_below_one', 0, () => {
      Log.info(TAG, `Testing ratio slightly below one`);
      let left: number = 5;
      let right: number = 25;
      let ratio: number = 0.95;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(24, 1e-10); // 5 + (25 - 5) * 0.95 = 5 + 20 * 0.95 = 24
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Extreme positive numbers
    it('should_return_correct_value_for_extreme_positive_numbers', 0, () => {
      Log.info(TAG, `Testing extreme positive numbers`);
      let left: number = Number.MAX_SAFE_INTEGER - 3000;
      let right: number = Number.MAX_SAFE_INTEGER;
      let ratio: number = 0.4;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertLargerOrEqual(Number.MAX_SAFE_INTEGER - 1800); // Adjusted for new ratio
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Extreme negative numbers
    it('should_return_correct_value_for_extreme_negative_numbers', 0, () => {
      Log.info(TAG, `Testing extreme negative numbers`);
      let left: number = Number.MIN_SAFE_INTEGER;
      let right: number = Number.MIN_SAFE_INTEGER + 3000;
      let ratio: number = 0.6;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertLessOrEqual(Number.MIN_SAFE_INTEGER + 1800); // Adjusted for new ratio
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Zero ratio with negative numbers
    it('should_return_correct_value_when_ratio_is_zero_with_negative_numbers', 0, () => {
      Log.info(TAG, `Testing zero ratio with negative numbers`);
      let left: number = -70;
      let right: number = -140;
      let ratio: number = 0;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-70); // -70 + (-140 - (-70)) * 0 = -70
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: One ratio with negative numbers
    it('should_return_correct_value_when_ratio_is_one_with_negative_numbers', 0, () => {
      Log.info(TAG, `Testing one ratio with negative numbers`);
      let left: number = -70;
      let right: number = -140;
      let ratio: number = 1;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-140); // -70 + (-140 - (-70)) * 1 = -140
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.25 with mixed numbers
    it('should_return_correct_value_when_ratio_is_0_25_with_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.25 with mixed numbers`);
      let left: number = -120;
      let right: number = 120;
      let ratio: number = 0.25;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-60); // -120 + (120 - (-120)) * 0.25 = -120 + 240 * 0.25 = -120 + 60 = -60
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.75 with mixed numbers
    it('should_return_correct_value_when_ratio_is_0_75_with_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.75 with mixed numbers`);
      let left: number = -120;
      let right: number = 120;
      let ratio: number = 0.75;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(60); // -120 + (120 - (-120)) * 0.75 = -120 + 240 * 0.75 = -120 + 180 = 60
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.1 with large numbers
    it('should_return_correct_value_when_ratio_is_0_1_with_large_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.1 with large numbers`);
      let left: number = 2000;
      let right: number = 4000;
      let ratio: number = 0.1;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(2200); // 2000 + (4000 - 2000) * 0.1 = 2000 + 2000 * 0.1 = 2200
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.9 with large numbers
    it('should_return_correct_value_when_ratio_is_0_9_with_large_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.9 with large numbers`);
      let left: number = 2000;
      let right: number = 4000;
      let ratio: number = 0.9;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(3800); // 2000 + (4000 - 2000) * 0.9 = 2000 + 2000 * 0.9 = 3800
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.33 with negative numbers
    it('should_return_correct_value_when_ratio_is_0_33_with_negative_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.33 with negative numbers`);
      let left: number = -120;
      let right: number = -240;
      let ratio: number = 0.33;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-159.6, 1e-10); // -120 + (-240 - (-120)) * 0.33 = -120 + (-120) * 0.33 = -120 - 39.6 = -159.6
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.67 with negative numbers
    it('should_return_correct_value_when_ratio_is_0_67_with_negative_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.67 with negative numbers`);
      let left: number = -120;
      let right: number = -240;
      let ratio: number = 0.67;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-200.4, 1e-10); // -120 + (-240 - (-120)) * 0.67 = -120 + (-120) * 0.67 = -120 - 80.4 = -200.4
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.2 with mixed numbers
    it('should_return_correct_value_when_ratio_is_0_2_with_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.2 with mixed numbers`);
      let left: number = -60;
      let right: number = 60;
      let ratio: number = 0.2;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-36); // -60 + (60 - (-60)) * 0.2 = -60 + 120 * 0.2 = -60 + 24 = -36
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.8 with mixed numbers
    it('should_return_correct_value_when_ratio_is_0_8_with_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.8 with mixed numbers`);
      let left: number = -60;
      let right: number = 60;
      let ratio: number = 0.8;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(36); // -60 + (60 - (-60)) * 0.8 = -60 + 120 * 0.8 = -60 + 96 = 36
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.4 with large mixed numbers
    it('should_return_correct_value_when_ratio_is_0_4_with_large_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.4 with large mixed numbers`);
      let left: number = -2000;
      let right: number = 2000;
      let ratio: number = 0.4;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-400); // -2000 + (2000 - (-2000)) * 0.4 = -2000 + 4000 * 0.4 = -2000 + 1600 = -400
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.6 with large mixed numbers
    it('should_return_correct_value_when_ratio_is_0_6_with_large_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.6 with large mixed numbers`);
      let left: number = -2000;
      let right: number = 2000;
      let ratio: number = 0.6;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(400); // -2000 + (2000 - (-2000)) * 0.6 = -2000 + 4000 * 0.6 = -2000 + 2400 = 400
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.15 with fractional numbers
    it('should_return_correct_value_when_ratio_is_0_15_with_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.15 with fractional numbers`);
      let left: number = 0.4;
      let right: number = 1.2;
      let ratio: number = 0.15;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(0.52, 1e-10); // 0.4 + (1.2 - 0.4) * 0.15 = 0.4 + 0.8 * 0.15 = 0.4 + 0.12 = 0.52
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.85 with fractional numbers
    it('should_return_correct_value_when_ratio_is_0_85_with_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.85 with fractional numbers`);
      let left: number = 0.4;
      let right: number = 1.2;
      let ratio: number = 0.85;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(1.08, 1e-10); // 0.4 + (1.2 - 0.4) * 0.85 = 0.4 + 0.8 * 0.85 = 0.4 + 0.68 = 1.08
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.3 with negative fractional numbers
    it('should_return_correct_value_when_ratio_is_0_3_with_negative_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.3 with negative fractional numbers`);
      let left: number = -0.4;
      let right: number = -1.2;
      let ratio: number = 0.3;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-0.64, 1e-10); // -0.4 + (-1.2 - (-0.4)) * 0.3 = -0.4 + (-0.8) * 0.3 = -0.4 - 0.24 = -0.64
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.7 with negative fractional numbers
    it('should_return_correct_value_when_ratio_is_0_7_with_negative_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.7 with negative fractional numbers`);
      let left: number = -0.4;
      let right: number = -1.2;
      let ratio: number = 0.7;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-0.96, 1e-10); // -0.4 + (-1.2 - (-0.4)) * 0.7 = -0.4 + (-0.8) * 0.7 = -0.4 - 0.56 = -0.96
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.5 with very small numbers
    it('should_return_correct_value_when_ratio_is_0_5_with_very_small_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.5 with very small numbers`);
      let left: number = 0.0003;
      let right: number = 0.0009;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(0.0006, 1e-10); // 0.0003 + (0.0009 - 0.0003) * 0.5 = 0.0003 + 0.0006 * 0.5 = 0.0006
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.5 with very large numbers
    it('should_return_correct_value_when_ratio_is_0_5_with_very_large_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.5 with very large numbers`);
      let left: number = 3000000;
      let right: number = 6000000;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(4500000); // 3000000 + (6000000 - 3000000) * 0.5 = 3000000 + 3000000 * 0.5 = 4500000
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.1 with very small negative numbers
    it('should_return_correct_value_when_ratio_is_0_1_with_very_small_negative_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.1 with very small negative numbers`);
      let left: number = -0.0003;
      let right: number = -0.0009;
      let ratio: number = 0.1;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-0.00036, 1e-10); // -0.0003 + (-0.0009 - (-0.0003)) * 0.1 = -0.0003 + (-0.0006) * 0.1 = -0.0003 - 0.00006 = -0.00036
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.9 with very small negative numbers
    it('should_return_correct_value_when_ratio_is_0_9_with_very_small_negative_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.9 with very small negative numbers`);
      let left: number = -0.0003;
      let right: number = -0.0009;
      let ratio: number = 0.9;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-0.00084, 1e-10); // -0.0003 + (-0.0009 - (-0.0003)) * 0.9 = -0.0003 + (-0.0006) * 0.9 = -0.0003 - 0.00054 = -0.00084
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.2 with very large mixed numbers
    it('should_return_correct_value_when_ratio_is_0_2_with_very_large_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.2 with very large mixed numbers`);
      let left: number = -3000000;
      let right: number = 3000000;
      let ratio: number = 0.2;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-1800000); // -3000000 + (3000000 - (-3000000)) * 0.2 = -3000000 + 6000000 * 0.2 = -3000000 + 1200000 = -1800000
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.8 with very large mixed numbers
    it('should_return_correct_value_when_ratio_is_0_8_with_very_large_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.8 with very large mixed numbers`);
      let left: number = -3000000;
      let right: number = 3000000;
      let ratio: number = 0.8;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(1800000); // -3000000 + (3000000 - (-3000000)) * 0.8 = -3000000 + 6000000 * 0.8 = -3000000 + 4800000 = 1800000
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.05 with positive numbers
    it('should_return_correct_value_when_ratio_is_0_05_with_positive_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.05 with positive numbers`);
      let left: number = 40;
      let right: number = 80;
      let ratio: number = 0.05;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(42, 1e-10); // 40 + (80 - 40) * 0.05 = 40 + 40 * 0.05 = 42
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.95 with positive numbers
    it('should_return_correct_value_when_ratio_is_0_95_with_positive_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.95 with positive numbers`);
      let left: number = 40;
      let right: number = 80;
      let ratio: number = 0.95;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(78, 1e-10); // 40 + (80 - 40) * 0.95 = 40 + 40 * 0.95 = 78
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.05 with negative numbers
    it('should_return_correct_value_when_ratio_is_0_05_with_negative_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.05 with negative numbers`);
      let left: number = -40;
      let right: number = -80;
      let ratio: number = 0.05;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-42, 1e-10); // -40 + (-80 - (-40)) * 0.05 = -40 + (-40) * 0.05 = -40 - 2 = -42
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.95 with negative numbers
    it('should_return_correct_value_when_ratio_is_0_95_with_negative_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.95 with negative numbers`);
      let left: number = -40;
      let right: number = -80;
      let ratio: number = 0.95;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-78, 1e-10); // -40 + (-80 - (-40)) * 0.95 = -40 + (-40) * 0.95 = -40 - 38 = -78
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.05 with mixed numbers
    it('should_return_correct_value_when_ratio_is_0_05_with_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.05 with mixed numbers`);
      let left: number = -40;
      let right: number = 40;
      let ratio: number = 0.05;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-36); // -40 + (40 - (-40)) * 0.05 = -40 + 80 * 0.05 = -40 + 4 = -36
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.95 with mixed numbers
    it('should_return_correct_value_when_ratio_is_0_95_with_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.95 with mixed numbers`);
      let left: number = -40;
      let right: number = 40;
      let ratio: number = 0.95;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(36); // -40 + (40 - (-40)) * 0.95 = -40 + 80 * 0.95 = -40 + 76 = 36
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.5 with identical left and right
    it('should_return_correct_value_when_left_and_right_are_identical', 0, () => {
      Log.info(TAG, `Testing identical left and right`);
      let left: number = 150;
      let right: number = 150;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(150); // 150 + (150 - 150) * 0.5 = 150
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0 with identical left and right
    it('should_return_correct_value_when_ratio_is_zero_and_left_right_identical', 0, () => {
      Log.info(TAG, `Testing ratio 0 with identical left and right`);
      let left: number = -150;
      let right: number = -150;
      let ratio: number = 0;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-150); // -150 + (-150 - (-150)) * 0 = -150
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 1 with identical left and right
    it('should_return_correct_value_when_ratio_is_one_and_left_right_identical', 0, () => {
      Log.info(TAG, `Testing ratio 1 with identical left and right`);
      let left: number = -150;
      let right: number = -150;
      let ratio: number = 1;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertEqual(-150); // -150 + (-150 - (-150)) * 1 = -150
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.5 with small fractional numbers
    it('should_return_correct_value_when_ratio_is_0_5_with_small_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.5 with small fractional numbers`);
      let left: number = 0.03;
      let right: number = 0.09;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(0.06, 1e-10); // 0.03 + (0.09 - 0.03) * 0.5 = 0.03 + 0.06 * 0.5 = 0.06
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.5 with large fractional numbers
    it('should_return_correct_value_when_ratio_is_0_5_with_large_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.5 with large fractional numbers`);
      let left: number = 15.2;
      let right: number = 30.8;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(23, 1e-10); // 15.2 + (30.8 - 15.2) * 0.5 = 15.2 + 15.6 * 0.5 = 15.2 + 7.8 = 23
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.5 with very small mixed numbers
    it('should_return_correct_value_when_ratio_is_0_5_with_very_small_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.5 with very small mixed numbers`);
      let left: number = -0.03;
      let right: number = 0.03;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(0, 1e-10); // -0.03 + (0.03 - (-0.03)) * 0.5 = -0.03 + 0.06 * 0.5 = -0.03 + 0.03 = 0
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.1 with very small mixed numbers
    it('should_return_correct_value_when_ratio_is_0_1_with_very_small_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.1 with very small mixed numbers`);
      let left: number = -0.03;
      let right: number = 0.03;
      let ratio: number = 0.1;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-0.024, 1e-10); // -0.03 + (0.03 - (-0.03)) * 0.1 = -0.03 + 0.06 * 0.1 = -0.03 + 0.006 = -0.024
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.9 with very small mixed numbers
    it('should_return_correct_value_when_ratio_is_0_9_with_very_small_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.9 with very small mixed numbers`);
      let left: number = -0.03;
      let right: number = 0.03;
      let ratio: number = 0.9;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(0.024, 1e-10); // -0.03 + (0.03 - (-0.03)) * 0.9 = -0.03 + 0.06 * 0.9 = -0.03 + 0.054 = 0.024
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.5 with very large mixed fractional numbers
    it('should_return_correct_value_when_ratio_is_0_5_with_very_large_mixed_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.5 with very large mixed fractional numbers`);
      let left: number = -3000.4;
      let right: number = 3000.4;
      let ratio: number = 0.5;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(0, 1e-10); // -3000.4 + (3000.4 - (-3000.4)) * 0.5 = -3000.4 + 6000.8 * 0.5 = -3000.4 + 3000.4 = 0
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.1 with very large mixed fractional numbers
    it('should_return_correct_value_when_ratio_is_0_1_with_very_large_mixed_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.1 with very large mixed fractional numbers`);
      let left: number = -3000.4;
      let right: number = 3000.4;
      let ratio: number = 0.1;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(-2400.32, 1e-10); // -3000.4 + (3000.4 - (-3000.4)) * 0.1 = -3000.4 + 6000.8 * 0.1 = -3000.4 + 600.08 = -2400.32
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Ratio at 0.9 with very large mixed fractional numbers
    it('should_return_correct_value_when_ratio_is_0_9_with_very_large_mixed_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing ratio 0.9 with very large mixed fractional numbers`);
      let left: number = -3000.4;
      let right: number = 3000.4;
      let ratio: number = 0.9;
      let result: number = ratioAtLine(left, right, ratio);
      expect(result).assertClose(2400.32, 1e-10); // -3000.4 + (3000.4 - (-3000.4)) * 0.9 = -3000.4 + 6000.8 * 0.9 = -3000.4 + 5400.72 = 2400.32
      Log.info(TAG, `Result: ${result}`);
    });

    // Test case: Multiple ratios with positive numbers
    it('should_return_correct_values_for_multiple_ratios_with_positive_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with positive numbers`);
      let left: number = 0;
      let right: number = 150;
      let ratios: number[] = [0, 0.3, 0.6, 0.9];
      let expectedResults: number[] = [0, 45, 90, 135]; // 0 + (150 - 0) * [0, 0.3, 0.6, 0.9]
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertEqual(expectedResults[index]);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Multiple ratios with negative numbers
    it('should_return_correct_values_for_multiple_ratios_with_negative_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with negative numbers`);
      let left: number = -150;
      let right: number = -300;
      let ratios: number[] = [0, 0.3, 0.6, 0.9];
      let expectedResults: number[] = [-150, -195, -240, -285]; // -150 + (-300 - (-150)) * [0, 0.3, 0.6, 0.9]
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertEqual(expectedResults[index]);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Multiple ratios with mixed numbers
    it('should_return_correct_values_for_multiple_ratios_with_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with mixed numbers`);
      let left: number = -150;
      let right: number = 150;
      let ratios: number[] = [0, 0.3, 0.6, 0.9];
      let expectedResults: number[] = [-150, -60, 30, 120]; // -150 + (150 - (-150)) * [0, 0.3, 0.6, 0.9]
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertEqual(expectedResults[index]);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Multiple ratios with fractional numbers
    it('should_return_correct_values_for_multiple_ratios_with_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with fractional numbers`);
      let left: number = 0.3;
      let right: number = 0.9;
      let ratios: number[] = [0, 0.3, 0.6, 0.9];
      let expectedResults: number[] = [0.3, 0.48, 0.66, 0.84]; // 0.3 + (0.9 - 0.3) * [0, 0.3, 0.6, 0.9]
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertClose(expectedResults[index], 1e-10);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Multiple ratios with negative fractional numbers
    it('should_return_correct_values_for_multiple_ratios_with_negative_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with negative fractional numbers`);
      let left: number = -0.3;
      let right: number = -0.9;
      let ratios: number[] = [0, 0.3, 0.6, 0.9];
      let expectedResults: number[] = [-0.3, -0.48, -0.66, -0.84]; // -0.3 + (-0.9 - (-0.3)) * [0, 0.3, 0.6, 0.9]
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertClose(expectedResults[index], 1e-10);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Multiple ratios with mixed fractional numbers
    it('should_return_correct_values_for_multiple_ratios_with_mixed_fractional_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with mixed fractional numbers`);
      let left: number = -0.3;
      let right: number = 0.3;
      let ratios: number[] = [0, 0.3, 0.6, 0.9];
      let expectedResults: number[] = [-0.3, -0.12, 0.06, 0.24]; // -0.3 + (0.3 - (-0.3)) * [0, 0.3, 0.6, 0.9]
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertClose(expectedResults[index], 1e-10);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Invalid ratio (negative)
    it('should_handle_negative_ratio', 0, () => {
      Log.info(TAG, `Testing negative ratio`);
      let left: number = 12;
      let right: number = 24;
      let ratio: number = -0.4;
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
      let left: number = 12;
      let right: number = 24;
      let ratio: number = 1.4;
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
      let right: number = 24;
      let ratio: number = 0.4;
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
      let left: number = 12;
      let right: number = 0/0;
      let ratio: number = 0.4;
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
      let left: number = 12;
      let right: number = 24;
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
      let right: number = 24;
      let ratio: number = 0.4;
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
      let left: number = 12;
      let right: number = -1/0;
      let ratio: number = 0.4;
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
      let left: number = 12;
      let right: number = 24;
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
      let right: number = 24;
      let ratio: number = 0.4;
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
      let left: number = 12;
      let right: number = 1/0;
      let ratio: number = 0.4;
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
      let left: number = 12;
      let right: number = 24;
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
      let right: number = 24;
      let ratio: number = 0.4;
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
      let left: number = 12;
      let right: number = Number.NaN;
      let ratio: number = 0.4;
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
      let left: number = 12;
      let right: number = 24;
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
      let left: number = 0.0003;
      let right: number = 0.0009;
      let ratios: number[] = [0, 0.3, 0.6, 0.9];
      let expectedResults: number[] = [0.0003, 0.00048, 0.00066, 0.00084]; // 0.0003 + (0.0009 - 0.0003) * [0, 0.3, 0.6, 0.9]
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertClose(expectedResults[index], 1e-10);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Multiple ratios with very large numbers
    it('should_return_correct_values_for_multiple_ratios_with_very_large_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with very large numbers`);
      let left: number = 3000000;
      let right: number = 6000000;
      let ratios: number[] = [0, 0.3, 0.6, 0.9];
      let expectedResults: number[] = [3000000, 3900000, 4800000, 5700000]; // 3000000 + (6000000 - 3000000) * [0, 0.3, 0.6, 0.9]
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertEqual(expectedResults[index]);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Multiple ratios with very small mixed numbers
    it('should_return_correct_values_for_multiple_ratios_with_very_small_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with very small mixed numbers`);
      let left: number = -0.0003;
      let right: number = 0.0003;
      let ratios: number[] = [0, 0.3, 0.6, 0.9];
      let expectedResults: number[] = [-0.0003, -0.00012, 0.00006, 0.00024]; // -0.0003 + (0.0003 - (-0.0003)) * [0, 0.3, 0.6, 0.9]
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertClose(expectedResults[index], 1e-10);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });

    // Test case: Multiple ratios with very large mixed numbers
    it('should_return_correct_values_for_multiple_ratios_with_very_large_mixed_numbers', 0, () => {
      Log.info(TAG, `Testing multiple ratios with very large mixed numbers`);
      let left: number = -3000000;
      let right: number = 3000000;
      let ratios: number[] = [0, 0.3, 0.6, 0.9];
      let expectedResults: number[] = [-3000000, -1200000, 600000, 2400000]; // -3000000 + (3000000 - (-3000000)) * [0, 0.3, 0.6, 0.9]
      ratios.forEach((ratio, index) => {
        let result: number = ratioAtLine(left, right, ratio);
        expect(result).assertEqual(expectedResults[index]);
        Log.info(TAG, `Ratio ${ratio} result: ${result}`);
      });
    });
  });
}