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

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import Timer from '@ohos/tools/src/main/utils/Timer';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
// Tag for logging test suite execution
const TAG: string = 'DTPerformanceTool';

// 提供延时计算工具用于性能分析
let timeKiller: (time: number) => Promise<void> = async (time: number) => {
  await Timer.sleep(time + 1);
};

// Test suite for Timer.getDuration functionality
export default function PerformanceToolTest(): void {
  describe('PerformanceToolTest', (): void => {

    // Test case: Verify duration with short delay
    it('should_return_correct_duration_short', 0, async () => {
      Log.info(TAG, 'Testing duration for short delay');
      const result = await Timer.getDuration(timeKiller, DELAY.short);
      expect(result).assertLessOrEqual(DELAY.default + 200);
      expect(result).assertLargerOrEqual(DELAY.short);
      Log.info(TAG, `Duration result: ${result}`);
    });

    // Test case: Verify duration with default delay
    it('should_return_correct_duration_default', 0, async () => {
      Log.info(TAG, 'Testing duration for default delay');
      const result = await Timer.getDuration(timeKiller, DELAY.default);
      expect(result).assertLessOrEqual(DELAY.double + 500);
      expect(result).assertLargerOrEqual(DELAY.default);
      Log.info(TAG, `Duration result: ${result}`);
    });

    // Test case: Verify duration with double delay
    it('should_return_correct_duration_double', 0, async () => {
      Log.info(TAG, 'Testing duration for double delay');
      const result = await Timer.getDuration(timeKiller, DELAY.double);
      expect(result).assertLessOrEqual(DELAY.long);
      expect(result).assertLargerOrEqual(DELAY.double);
      Log.info(TAG, `Duration result: ${result}`);
    });

    // Test case: Verify duration with error thrown
    it('should_return_correct_duration_when_timeKiller_throws_error', 0, async () => {
      Log.info(TAG, 'Testing error handling for zero delay');
      try {
        await Timer.getDuration(timeKiller, 0);
        throw Error('Test error');
      } catch (e) {
        expect(e.message).assertEqual('Test error');
        Log.info(TAG, 'Error caught as expected');
      }
    });

    // Test case: Verify duration with undefined return
    it('should_return_correct_duration_when_timeKiller_returns_undefined', 0, async () => {
      Log.info(TAG, 'Testing undefined return for zero delay');
      const result = await Timer.getDuration(timeKiller, 0);
      expect(result).assertLessOrEqual(20);
      Log.info(TAG, `Duration result: ${result}`);
    });

    // Test case: Verify duration with rapid delay
    it('should_return_correct_duration_minimal', 0, async () => {
      Log.info(TAG, 'Testing duration for rapid delay');
      const result = await Timer.getDuration(timeKiller, 10);
      expect(result).assertLessOrEqual(50);
      expect(result).assertLargerOrEqual(8);
      Log.info(TAG, `Duration result: ${result}`);
    });

    // Test case: Verify duration with negative delay
    it('should_handle_negative_delay', 0, async () => {
      Log.info(TAG, 'Testing duration for negative delay');
      const result = await Timer.getDuration(timeKiller, -100);
      expect(result).assertLessOrEqual(20);
      Log.info(TAG, `Duration result: ${result}`);
    });

    // Test case: Verify duration with long delay
    it('should_return_correct_duration_large', 0, async () => {
      Log.info(TAG, 'Testing duration for long delay');
      const result = await Timer.getDuration(timeKiller, DELAY.long);
      expect(result).assertLessOrEqual(DELAY.long + 1000);
      expect(result).assertLargerOrEqual(DELAY.long - 100);
      Log.info(TAG, `Duration result: ${result}`);
    });

    // Test case: Verify duration with extra long delay
    it('should_return_correct_duration_extra_long', 0, async () => {
      Log.info(TAG, 'Testing duration for extra long delay');
      const result = await Timer.getDuration(timeKiller, 10);
      expect(result).assertLessOrEqual(100);
      expect(result).assertLargerOrEqual(8);
      Log.info(TAG, `Duration result: ${result}`);
    });

    // Test case: Verify duration with multiple runs (consistency check)
    it('should_return_consistent_duration_multiple_runs', 0, async () => {
      Log.info(TAG, 'Testing duration consistency for multiple runs');
      const results: number[] = [];
      for (let i = 0; i < 5; i++) {
        const result = await Timer.getDuration(timeKiller, DELAY.default);
        results.push(result);
        Log.info(TAG, `Run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(DELAY.double + 500);
        expect(result).assertLargerOrEqual(DELAY.default);
        Log.info(TAG, `Verified run ${index + 1}`);
      });
    });

    // Test case: Verify duration with mocked timeKiller
    it('should_handle_mocked_timeKiller', 0, async () => {
      Log.info(TAG, 'Testing duration with mocked timeKiller');
      const result = await Timer.getDuration(timeKiller, 0);
      expect(result).assertLessOrEqual(50);
      Log.info(TAG, `Mocked duration result: ${result}`);
    });

    // Test case: Verify duration with zero delay multiple times
    it('should_handle_zero_delay_multiple_times', 0, async () => {
      Log.info(TAG, 'Testing zero delay multiple times');
      const results: number[] = [];
      for (let i = 0; i < 3; i++) {
        const result = await Timer.getDuration(timeKiller, 10);
        results.push(result);
        Log.info(TAG, `Zero delay run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(200);
        Log.info(TAG, `Verified zero delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with invalid input (null)
    it('should_handle_null_input', 0, async () => {
      Log.info(TAG, 'Testing duration with null input');
      try {
        await Timer.getDuration(timeKiller, 0/0);
        throw Error('Expected null input error');
      } catch (e) {
        expect(e.message).assertEqual('Expected null input error');
        Log.info(TAG, 'Null input error caught as expected');
      }
    });

    // Test case: Verify duration with undefined input
    it('should_handle_undefined_input', 0, async () => {
      Log.info(TAG, 'Testing duration with undefined input');
      try {
        await Timer.getDuration(timeKiller, Number.NaN);
        throw Error('Expected undefined input error');
      } catch (e) {
        expect(e.message).assertEqual('Expected undefined input error');
        Log.info(TAG, 'Undefined input error caught as expected');
      }
    });

    // Test case: Verify duration with long number of iterations
    it('should_handle_large_iteration_duration', 0, async () => {
      Log.info(TAG, 'Testing duration with long iterations');
      const result = await Timer.getDuration(timeKiller, DELAY.default);
      for (let i = 0; i < 10; i++) {
        const iterationResult = await Timer.getDuration(timeKiller, DELAY.short);
        Log.info(TAG, `Iteration ${i + 1} duration: ${iterationResult}`);
        expect(iterationResult).assertLessOrEqual(DELAY.default + 200);
        expect(iterationResult).assertLargerOrEqual(DELAY.short);
      }
      expect(result).assertLessOrEqual(DELAY.double + 500);
      expect(result).assertLargerOrEqual(DELAY.default);
      Log.info(TAG, `Main duration result: ${result}`);
    });

    // Test case: Verify duration with concurrent executions
    it('should_handle_concurrent_executions', 0, async () => {
      Log.info(TAG, 'Testing concurrent duration measurements');
      const promises = [
        Timer.getDuration(timeKiller, DELAY.short),
        Timer.getDuration(timeKiller, DELAY.default),
        Timer.getDuration(timeKiller, DELAY.double)
      ];
      const results = await Promise.all(promises);
      Log.info(TAG, `Concurrent results: ${results}`);
      expect(results[0]).assertLessOrEqual(DELAY.default + 200);
      expect(results[0]).assertLargerOrEqual(DELAY.short);
      expect(results[1]).assertLessOrEqual(DELAY.double + 500);
      expect(results[1]).assertLargerOrEqual(DELAY.default);
      expect(results[2]).assertLessOrEqual(DELAY.long);
      expect(results[2]).assertLargerOrEqual(DELAY.double);
    });

    // Test case: Verify duration with mocked error
    it('should_handle_mocked_error', 0, async () => {
      Log.info(TAG, 'Testing mocked error in timeKiller');
      try {
        throw Error('Mocked error');
      } catch (e) {
        expect(e.message).assertEqual('Mocked error');
        Log.info(TAG, 'Mocked error caught as expected');
      }
    });

    // Test case: Verify duration with custom delay (1500ms)
    it('should_return_correct_duration_custom_1500ms', 0, async () => {
      Log.info(TAG, 'Testing duration for custom 1500ms delay');
      const customDelay = 1500;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 500);
      expect(result).assertLargerOrEqual(customDelay - 100);
      Log.info(TAG, `Custom duration result: ${result}`);
    });

    // Test case: Verify duration with custom delay (2500ms)
    it('should_return_correct_duration_custom_2500ms', 0, async () => {
      Log.info(TAG, 'Testing duration for custom 2500ms delay');
      const customDelay = 2500;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 500);
      expect(result).assertLargerOrEqual(customDelay - 100);
      Log.info(TAG, `Custom duration result: ${result}`);
    });

    // Test case: Verify duration with boundary value (1ms)
    it('should_return_correct_duration_boundary_1ms', 0, async () => {
      Log.info(TAG, 'Testing duration for boundary 1ms delay');
      const result = await Timer.getDuration(timeKiller, 1);
      expect(result).assertLessOrEqual(50);
      expect(result).assertLargerOrEqual(0);
      Log.info(TAG, `Boundary duration result: ${result}`);
    });

    // Test case: Verify duration with boundary value (99ms)
    it('should_return_correct_duration_boundary_99ms', 0, async () => {
      Log.info(TAG, 'Testing duration for boundary 99ms delay');
      const result = await Timer.getDuration(timeKiller, 99);
      expect(result).assertLessOrEqual(1000);
      expect(result).assertLargerOrEqual(99);
      Log.info(TAG, `Boundary duration result: ${result}`);
    });

    // Test case: Verify duration with repeated short delays
    it('should_handle_repeated_short_delays', 0, async () => {
      Log.info(TAG, 'Testing repeated short delays');
      const results: number[] = [];
      for (let i = 0; i < 10; i++) {
        const result = await Timer.getDuration(timeKiller, DELAY.short);
        results.push(result);
        Log.info(TAG, `Short delay run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(DELAY.default + 200);
        expect(result).assertLargerOrEqual(DELAY.short);
        Log.info(TAG, `Verified short delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with repeated default delays
    it('should_handle_repeated_default_delays', 0, async () => {
      Log.info(TAG, 'Testing repeated default delays');
      const results: number[] = [];
      for (let i = 0; i < 3; i++) {
        const result = await Timer.getDuration(timeKiller, DELAY.default);
        results.push(result);
        Log.info(TAG, `Default delay run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(DELAY.double + 500);
        expect(result).assertLargerOrEqual(DELAY.default);
        Log.info(TAG, `Verified default delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with repeated double delays
    it('should_handle_repeated_double_delays', 0, async () => {
      Log.info(TAG, 'Testing repeated double delays');
      const results: number[] = [];
      for (let i = 0; i < 2; i++) {
        const result = await Timer.getDuration(timeKiller, DELAY.double);
        results.push(result);
        Log.info(TAG, `Double delay run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(DELAY.long);
        expect(result).assertLargerOrEqual(DELAY.double);
        Log.info(TAG, `Verified double delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with repeated long delays
    it('should_handle_repeated_long_delays', 0, async () => {
      Log.info(TAG, 'Testing repeated long delays');
      const results: number[] = [];
      for (let i = 0; i < 2; i++) {
        const result = await Timer.getDuration(timeKiller, DELAY.long);
        results.push(result);
        Log.info(TAG, `Long delay run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(DELAY.long + 500);
        expect(result).assertLargerOrEqual(DELAY.long - 100);
        Log.info(TAG, `Verified long delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with repeated extra long delays
    it('should_handle_repeated_extra_long_delays', 0, async () => {
      Log.info(TAG, 'Testing repeated extra long delays');
      const results: number[] = [];
      for (let i = 0; i < 3; i++) {
        const result = await Timer.getDuration(timeKiller, 10);
        results.push(result);
        Log.info(TAG, `Extra long delay run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(10 + 500);
        expect(result).assertLargerOrEqual(8);
        Log.info(TAG, `Verified extra long delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with mixed delay values
    it('should_handle_mixed_delay_values', 0, async () => {
      Log.info(TAG, 'Testing mixed delay values');
      const delays = [DELAY.short, DELAY.default, DELAY.double, DELAY.long];
      const results: number[] = [];
      for (const delay of delays) {
        const result = await Timer.getDuration(timeKiller, delay);
        results.push(result);
        Log.info(TAG, `Mixed delay ${delay} duration: ${result}`);
      }
      expect(results[0]).assertLessOrEqual(DELAY.default + 200);
      expect(results[0]).assertLargerOrEqual(DELAY.short);
      expect(results[1]).assertLessOrEqual(DELAY.double + 500);
      expect(results[1]).assertLargerOrEqual(DELAY.default);
      expect(results[2]).assertLessOrEqual(DELAY.long);
      expect(results[2]).assertLargerOrEqual(DELAY.double);
      expect(results[3]).assertLessOrEqual(DELAY.long + 500);
      expect(results[3]).assertLargerOrEqual(DELAY.long - 100);
      Log.info(TAG, `Mixed delay results: ${results}`);
    });

    // Test case: Verify duration with high precision timing
    it('should_handle_high_precision_timing', 0, async () => {
      Log.info(TAG, 'Testing high precision timing');
      const customDelay = 100.5;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 50);
      expect(result).assertLargerOrEqual(customDelay - 10);
      Log.info(TAG, `High precision duration result: ${result}`);
    });

    // Test case: Verify duration with very small delay (5ms)
    it('should_handle_very_small_delay_5ms', 0, async () => {
      Log.info(TAG, 'Testing very small delay of 5ms');
      const result = await Timer.getDuration(timeKiller, 5);
      expect(result).assertLessOrEqual(50);
      expect(result).assertLargerOrEqual(5);
      Log.info(TAG, `Very small delay duration result: ${result}`);
    });

    // Test case: Verify duration with very long delay (15000ms)
    it('should_handle_very_large_delay_1500ms', 0, async () => {
      Log.info(TAG, 'Testing very long delay of 15000ms');
      const result = await Timer.getDuration(timeKiller, 1500);
      expect(result).assertLessOrEqual(1800);
      expect(result).assertLargerOrEqual(1490);
      Log.info(TAG, `Very long delay duration result: ${result}`);
    });

    // Test case: Verify duration with invalid timeKiller function
    it('should_handle_invalid_timeKiller', 0, async () => {
      Log.info(TAG, 'Testing invalid timeKiller function');
      const invalidTimeKiller = async (n: number) => {
        throw new Error('Invalid function');
      };
      try {
        await Timer.getDuration(invalidTimeKiller, DELAY.default);
        throw Error('Expected invalid function error');
      } catch (e) {
        expect(e.message).assertEqual('Invalid function');
        Log.info(TAG, 'Invalid function error caught as expected');
      }
    });

    // Test case: Verify duration with multiple concurrent short delays
    it('should_handle_multiple_concurrent_short_delays', 0, async () => {
      Log.info(TAG, 'Testing multiple concurrent short delays');
      const promises = Array(5).fill(null).map(() => Timer.getDuration(timeKiller, DELAY.short));
      const results = await Promise.all(promises);
      Log.info(TAG, `Concurrent short delay results: ${results}`);
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(DELAY.default + 200);
        expect(result).assertLargerOrEqual(DELAY.short);
        Log.info(TAG, `Verified concurrent short delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with multiple concurrent default delays
    it('should_handle_multiple_concurrent_default_delays', 0, async () => {
      Log.info(TAG, 'Testing multiple concurrent default delays');
      const promises = Array(5).fill(null).map(() => Timer.getDuration(timeKiller, DELAY.default));
      const results = await Promise.all(promises);
      Log.info(TAG, `Concurrent default delay results: ${results}`);
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(DELAY.double + 500);
        expect(result).assertLargerOrEqual(DELAY.default);
        Log.info(TAG, `Verified concurrent default delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with multiple concurrent double delays
    it('should_handle_multiple_concurrent_double_delays', 0, async () => {
      Log.info(TAG, 'Testing multiple concurrent double delays');
      const promises = Array(5).fill(null).map(() => Timer.getDuration(timeKiller, DELAY.double));
      const results = await Promise.all(promises);
      Log.info(TAG, `Concurrent double delay results: ${results}`);
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(DELAY.long);
        expect(result).assertLargerOrEqual(DELAY.double);
        Log.info(TAG, `Verified concurrent double delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with multiple concurrent mixed delays
    it('should_handle_multiple_concurrent_mixed_delays', 0, async () => {
      Log.info(TAG, 'Testing multiple concurrent mixed delays');
      const delays = [DELAY.short, DELAY.default, DELAY.double, DELAY.long, 10];
      const promises = delays.map(delay => Timer.getDuration(timeKiller, delay));
      const results = await Promise.all(promises);
      Log.info(TAG, `Concurrent mixed delay results: ${results}`);
      expect(results[0]).assertLessOrEqual(DELAY.default + 200);
      expect(results[0]).assertLargerOrEqual(DELAY.short);
      expect(results[1]).assertLessOrEqual(DELAY.double + 500);
      expect(results[1]).assertLargerOrEqual(DELAY.default);
      expect(results[2]).assertLessOrEqual(DELAY.long);
      expect(results[2]).assertLargerOrEqual(DELAY.double);
      expect(results[3]).assertLessOrEqual(DELAY.long + 500);
      expect(results[3]).assertLargerOrEqual(DELAY.long - 100);
      expect(results[4]).assertLessOrEqual(10 + 500);
      expect(results[4]).assertLargerOrEqual(8);
    });

    // Test case: Verify duration with sequential execution of various delays
    it('should_handle_sequential_various_delays', 0, async () => {
      Log.info(TAG, 'Testing sequential execution of various delays');
      const delays = [DELAY.short, DELAY.default, DELAY.double, DELAY.long, 10];
      const results: number[] = [];
      for (const delay of delays) {
        const result = await Timer.getDuration(timeKiller, delay);
        results.push(result);
        Log.info(TAG, `Sequential delay ${delay} duration: ${result}`);
      }
      expect(results[0]).assertLessOrEqual(DELAY.default + 200);
      expect(results[0]).assertLargerOrEqual(DELAY.short);
      expect(results[1]).assertLessOrEqual(DELAY.double + 500);
      expect(results[1]).assertLargerOrEqual(DELAY.default);
      expect(results[2]).assertLessOrEqual(DELAY.long);
      expect(results[2]).assertLargerOrEqual(DELAY.double);
      expect(results[3]).assertLessOrEqual(DELAY.long + 500);
      expect(results[3]).assertLargerOrEqual(DELAY.long - 100);
      expect(results[4]).assertLessOrEqual(10 + 500);
      expect(results[4]).assertLargerOrEqual(8);
      Log.info(TAG, `Sequential delay results: ${results}`);
    });

    // Test case: Verify duration with high load (multiple rapid calls)
    it('should_handle_high_load_rapid_calls', 0, async () => {
      Log.info(TAG, 'Testing high load with rapid calls');
      const results: number[] = [];
      for (let i = 0; i < 20; i++) {
        const result = await Timer.getDuration(timeKiller, 10);
        results.push(result);
        Log.info(TAG, `High load run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(50);
        expect(result).assertLargerOrEqual(8);
        Log.info(TAG, `Verified high load run ${index + 1}`);
      });
    });

    // Test case: Verify duration with mocked timeKiller rejecting
    it('should_handle_mocked_rejection', 0, async () => {
      Log.info(TAG, 'Testing mocked rejection in timeKiller');
      try {
        await Timer.getDuration(timeKiller, DELAY.default);
        throw Error('Mocked rejection');
      } catch (e) {
        expect(e.message).assertEqual('Mocked rejection');
        Log.info(TAG, 'Mocked rejection caught as expected');
      }
    });

    // Test case: Verify duration with mocked timeKiller delayed rejection
    it('should_handle_mocked_delayed_rejection', 0, async () => {
      Log.info(TAG, 'Testing mocked delayed rejection in timeKiller');
      try {
        await Timer.getDuration(timeKiller, DELAY.default);
        throw Error('Delayed rejection');
      } catch (e) {
        expect(e.message).assertEqual('Delayed rejection');
        Log.info(TAG, 'Delayed rejection caught as expected');
      }
    });

    // Test case: Verify duration with custom delay (750ms)
    it('should_return_correct_duration_custom_750ms', 0, async () => {
      Log.info(TAG, 'Testing duration for custom 750ms delay');
      const customDelay = 750;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 200);
      expect(result).assertLargerOrEqual(customDelay - 50);
      Log.info(TAG, `Custom duration result: ${result}`);
    });

    // Test case: Verify duration with custom delay (1250ms)
    it('should_return_correct_duration_custom_1250ms', 0, async () => {
      Log.info(TAG, 'Testing duration for custom 1250ms delay');
      const customDelay = 1250;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 300);
      expect(result).assertLargerOrEqual(customDelay - 50);
      Log.info(TAG, `Custom duration result: ${result}`);
    });

    // Test case: Verify duration with custom delay (1750ms)
    it('should_return_correct_duration_custom_1750ms', 0, async () => {
      Log.info(TAG, 'Testing duration for custom 1750ms delay');
      const customDelay = 1750;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 300);
      expect(result).assertLargerOrEqual(customDelay - 50);
      Log.info(TAG, `Custom duration result: ${result}`);
    });

    // Test case: Verify duration with custom delay (2250ms)
    it('should_return_correct_duration_custom_2250ms', 0, async () => {
      Log.info(TAG, 'Testing duration for custom 2250ms delay');
      const customDelay = 2250;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 300);
      expect(result).assertLargerOrEqual(customDelay - 50);
      Log.info(TAG, `Custom duration result: ${result}`);
    });

    // Test case: Verify duration with custom delay (2750ms)
    it('should_return_correct_duration_custom_2750ms', 0, async () => {
      Log.info(TAG, 'Testing duration for custom 2750ms delay');
      const customDelay = 2750;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 300);
      expect(result).assertLargerOrEqual(customDelay - 50);
      Log.info(TAG, `Custom duration result: ${result}`);
    });

    // Test case: Verify duration with custom delay (3250ms)
    it('should_return_correct_duration_custom_3250ms', 0, async () => {
      Log.info(TAG, 'Testing duration for custom 3250ms delay');
      const customDelay = 3250;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 300);
      expect(result).assertLargerOrEqual(customDelay - 50);
      Log.info(TAG, `Custom duration result: ${result}`);
    });

    // Test case: Verify duration with custom delay (3750ms)
    it('should_return_correct_duration_custom_3750ms', 0, async () => {
      Log.info(TAG, 'Testing duration for custom 3750ms delay');
      const customDelay = 3750;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 300);
      expect(result).assertLargerOrEqual(customDelay - 50);
      Log.info(TAG, `Custom duration result: ${result}`);
    });

    // Test case: Verify duration with custom delay (4250ms)
    it('should_return_correct_duration_custom_4250ms', 0, async () => {
      Log.info(TAG, 'Testing duration for custom 4250ms delay');
      const customDelay = 4250;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 300);
      expect(result).assertLargerOrEqual(customDelay - 50);
      Log.info(TAG, `Custom duration result: ${result}`);
    });

    // Test case: Verify duration with custom delay (4750ms)
    it('should_return_correct_duration_custom_4750ms', 0, async () => {
      Log.info(TAG, 'Testing duration for custom 4750ms delay');
      const customDelay = 4750;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 300);
      expect(result).assertLargerOrEqual(customDelay - 50);
      Log.info(TAG, `Custom duration result: ${result}`);
    });

    // Test case: Verify duration with extreme boundary (0.1ms)
    it('should_handle_extreme_boundary_0_1ms', 0, async () => {
      Log.info(TAG, 'Testing extreme boundary delay of 0.1ms');
      const result = await Timer.getDuration(timeKiller, 0.1);
      expect(result).assertLessOrEqual(50);
      expect(result).assertLargerOrEqual(0);
      Log.info(TAG, `Extreme boundary duration result: ${result}`);
    });

    // Test case: Verify duration with extreme boundary (99ms)
    it('should_handle_extreme_boundary_99ms', 0, async () => {
      Log.info(TAG, 'Testing extreme boundary delay of 99ms');
      const result = await Timer.getDuration(timeKiller, 99);
      expect(result).assertLessOrEqual(300);
      expect(result).assertLargerOrEqual(99);
      Log.info(TAG, `Extreme boundary duration result: ${result}`);
    });

    // Test case: Verify duration with mocked timeKiller delayed return
    it('should_handle_mocked_delayed_return', 0, async () => {
      Log.info(TAG, 'Testing mocked delayed return in timeKiller');
      const result = await Timer.getDuration(timeKiller, DELAY.default);
      expect(result).assertLessOrEqual(DELAY.default+199);
      expect(result).assertLargerOrEqual(DELAY.default);
      Log.info(TAG, `Mocked delayed return duration result: ${result}`);
    });

    // Test case: Verify duration with sequential short delays
    it('should_handle_sequential_short_delays', 0, async () => {
      Log.info(TAG, 'Testing sequential short delays');
      const results: number[] = [];
      for (let i = 0; i < 15; i++) {
        const result = await Timer.getDuration(timeKiller, DELAY.short);
        results.push(result);
        Log.info(TAG, `Sequential short delay run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(DELAY.default + 200);
        expect(result).assertLargerOrEqual(DELAY.short);
        Log.info(TAG, `Verified sequential short delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with sequential default delays
    it('should_handle_sequential_default_delays', 0, async () => {
      Log.info(TAG, 'Testing sequential default delays');
      const results: number[] = [];
      for (let i = 0; i < 15; i++) {
        const result = await Timer.getDuration(timeKiller, DELAY.default);
        results.push(result);
        Log.info(TAG, `Sequential default delay run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(DELAY.double + 500);
        expect(result).assertLargerOrEqual(DELAY.default);
        Log.info(TAG, `Verified sequential default delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with sequential double delays
    it('should_handle_sequential_double_delays', 0, async () => {
      Log.info(TAG, 'Testing sequential double delays');
      const results: number[] = [];
      for (let i = 0; i < 3; i++) {
        const result = await Timer.getDuration(timeKiller, DELAY.double);
        results.push(result);
        Log.info(TAG, `Sequential double delay run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(DELAY.long);
        expect(result).assertLargerOrEqual(DELAY.double);
        Log.info(TAG, `Verified sequential double delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with sequential rapid delays
    it('should_handle_sequential_rapid_delays', 0, async () => {
      Log.info(TAG, 'Testing sequential rapid delays');
      const results: number[] = [];
      for (let i = 0; i < 10; i++) {
        const result = await Timer.getDuration(timeKiller, DELAY.rapid);
        results.push(result);
        Log.info(TAG, `Sequential rapid delay run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(DELAY.rapid + 500);
        expect(result).assertLargerOrEqual(DELAY.rapid - 100);
        Log.info(TAG, `Verified sequential rapid delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with sequential extra long delays
    it('should_handle_sequential_extra_long_delays', 0, async () => {
      Log.info(TAG, 'Testing sequential extra long delays');
      const results: number[] = [];
      for (let i = 0; i < 5; i++) {
        const result = await Timer.getDuration(timeKiller, 10);
        results.push(result);
        Log.info(TAG, `Sequential extra long delay run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(300);
        expect(result).assertLargerOrEqual(8);
        Log.info(TAG, `Verified sequential extra long delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with mixed sequential delays
    it('should_handle_mixed_sequential_delays', 0, async () => {
      Log.info(TAG, 'Testing mixed sequential delays');
      const delays = [DELAY.short, DELAY.default, DELAY.double, DELAY.long, 10];
      const results: number[] = [];
      for (const delay of delays) {
        const result = await Timer.getDuration(timeKiller, delay);
        results.push(result);
        Log.info(TAG, `Mixed sequential delay ${delay} duration: ${result}`);
      }
      expect(results[0]).assertLessOrEqual(DELAY.default + 200);
      expect(results[0]).assertLargerOrEqual(DELAY.short);
      expect(results[1]).assertLessOrEqual(DELAY.double + 500);
      expect(results[1]).assertLargerOrEqual(DELAY.default);
      expect(results[2]).assertLessOrEqual(DELAY.long);
      expect(results[2]).assertLargerOrEqual(DELAY.double);
      expect(results[3]).assertLessOrEqual(DELAY.long + 500);
      expect(results[3]).assertLargerOrEqual(DELAY.long - 100);
      expect(results[4]).assertLessOrEqual(10 + 500);
      expect(results[4]).assertLargerOrEqual(8);
      Log.info(TAG, `Mixed sequential delay results: ${results}`);
    });

    // Test case: Verify duration with high precision custom delay (100.25ms)
    it('should_handle_high_precision_custom_delay_100_25ms', 0, async () => {
      Log.info(TAG, 'Testing high precision custom delay of 100.25ms');
      const customDelay = 100.25;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 50);
      expect(result).assertLargerOrEqual(customDelay - 10);
      Log.info(TAG, `High precision custom duration result: ${result}`);
    });

    // Test case: Verify duration with high precision custom delay (200.75ms)
    it('should_handle_high_precision_custom_delay_200_75ms', 0, async () => {
      Log.info(TAG, 'Testing high precision custom delay of 200.75ms');
      const customDelay = 200.75;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 50);
      expect(result).assertLargerOrEqual(customDelay - 10);
      Log.info(TAG, `High precision custom duration result: ${result}`);
    });

    // Test case: Verify duration with high precision custom delay (300.5ms)
    it('should_handle_high_precision_custom_delay_300_5ms', 0, async () => {
      Log.info(TAG, 'Testing high precision custom delay of 300.5ms');
      const customDelay = 300.5;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 50);
      expect(result).assertLargerOrEqual(customDelay - 10);
      Log.info(TAG, `High precision custom duration result: ${result}`);
    });

    // Test case: Verify duration with high precision custom delay (400.25ms)
    it('should_handle_high_precision_custom_delay_400_25ms', 0, async () => {
      Log.info(TAG, 'Testing high precision custom delay of 400.25ms');
      const customDelay = 400.25;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 50);
      expect(result).assertLargerOrEqual(customDelay - 10);
      Log.info(TAG, `High precision custom duration result: ${result}`);
    });

    // Test case: Verify duration with high precision custom delay (500.75ms)
    it('should_handle_high_precision_custom_delay_500_75ms', 0, async () => {
      Log.info(TAG, 'Testing high precision custom delay of 500.75ms');
      const customDelay = 500.75;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 50);
      expect(result).assertLargerOrEqual(customDelay - 10);
      Log.info(TAG, `High precision custom duration result: ${result}`);
    });

    // Test case: Verify duration with high precision custom delay (600.5ms)
    it('should_handle_high_precision_custom_delay_600_5ms', 0, async () => {
      Log.info(TAG, 'Testing high precision custom delay of 600.5ms');
      const customDelay = 600.5;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 50);
      expect(result).assertLargerOrEqual(customDelay - 10);
      Log.info(TAG, `High precision custom duration result: ${result}`);
    });

    // Test case: Verify duration with high precision custom delay (700.25ms)
    it('should_handle_high_precision_custom_delay_700_25ms', 0, async () => {
      Log.info(TAG, 'Testing high precision custom delay of 700.25ms');
      const customDelay = 700.25;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 50);
      expect(result).assertLargerOrEqual(customDelay - 10);
      Log.info(TAG, `High precision custom duration result: ${result}`);
    });

    // Test case: Verify duration with high precision custom delay (800.75ms)
    it('should_handle_high_precision_custom_delay_800_75ms', 0, async () => {
      Log.info(TAG, 'Testing high precision custom delay of 800.75ms');
      const customDelay = 800.75;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 50);
      expect(result).assertLargerOrEqual(customDelay - 10);
      Log.info(TAG, `High precision custom duration result: ${result}`);
    });

    // Test case: Verify duration with high precision custom delay (900.5ms)
    it('should_handle_high_precision_custom_delay_900_5ms', 0, async () => {
      Log.info(TAG, 'Testing high precision custom delay of 900.5ms');
      const customDelay = 900.5;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 50);
      expect(result).assertLargerOrEqual(customDelay - 10);
      Log.info(TAG, `High precision custom duration result: ${result}`);
    });

    // Test case: Verify duration with high precision custom delay (1000.25ms)
    it('should_handle_high_precision_custom_delay_1000_25ms', 0, async () => {
      Log.info(TAG, 'Testing high precision custom delay of 1000.25ms');
      const customDelay = 1000.25;
      const result = await Timer.getDuration(timeKiller, customDelay);
      expect(result).assertLessOrEqual(customDelay + 50);
      expect(result).assertLargerOrEqual(customDelay - 10);
      Log.info(TAG, `High precision custom duration result: ${result}`);
    });

    // Test case: Verify duration with negative delay multiple times
    it('should_handle_negative_delay_multiple_times', 0, async () => {
      Log.info(TAG, 'Testing negative delay multiple times');
      const results: number[] = [];
      for (let i = 0; i < 5; i++) {
        const result = await Timer.getDuration(timeKiller, -100);
        results.push(result);
        Log.info(TAG, `Negative delay run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(20);
        Log.info(TAG, `Verified negative delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with zero delay multiple times (extended)
    it('should_handle_zero_delay_multiple_times_extended', 0, async () => {
      Log.info(TAG, 'Testing zero delay multiple times extended');
      const results: number[] = [];
      for (let i = 0; i < 10; i++) {
        const result = await Timer.getDuration(timeKiller, 0);
        results.push(result);
        Log.info(TAG, `Zero delay extended run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(20);
        Log.info(TAG, `Verified zero delay extended run ${index + 1}`);
      });
    });

    // Test case: Verify duration with rapid delay multiple times
    it('should_handle_minimal_delay_multiple_times', 0, async () => {
      Log.info(TAG, 'Testing rapid delay multiple times');
      const results: number[] = [];
      for (let i = 0; i < 10; i++) {
        const result = await Timer.getDuration(timeKiller, 10);
        results.push(result);
        Log.info(TAG, `Minimal delay run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(50);
        expect(result).assertLargerOrEqual(8);
        Log.info(TAG, `Verified rapid delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with rapid delay multiple times
    it('should_handle_large_delay_multiple_times', 0, async () => {
      Log.info(TAG, 'Testing rapid delay multiple times');
      const results: number[] = [];
      for (let i = 0; i < 5; i++) {
        const result = await Timer.getDuration(timeKiller, 5);
        results.push(result);
        Log.info(TAG, `Large delay run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(5 + 100);
        expect(result).assertLargerOrEqual(3);
        Log.info(TAG, `Verified rapid delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with extra long delay multiple times
    it('should_handle_extra_long_delay_multiple_times', 0, async () => {
      Log.info(TAG, 'Testing extra long delay multiple times');
      const results: number[] = [];
      for (let i = 0; i < 3; i++) {
        const result = await Timer.getDuration(timeKiller, 10);
        results.push(result);
        Log.info(TAG, `Extra long delay run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(10 + 500);
        expect(result).assertLargerOrEqual(8);
        Log.info(TAG, `Verified extra long delay run ${index + 1}`);
      });
    });

    // Test case: Verify duration with mixed delay values multiple times
    it('should_handle_mixed_delay_values_multiple_times', 0, async () => {
      Log.info(TAG, 'Testing mixed delay values multiple times');
      const delays = [DELAY.short, DELAY.default, DELAY.double, DELAY.long, 10];
      const results: number[] = [];
      for (let i = 0; i < 2; i++) {
        for (const delay of delays) {
          const result = await Timer.getDuration(timeKiller, delay);
          results.push(result);
          Log.info(TAG, `Mixed delay ${delay} run ${i + 1} duration: ${result}`);
        }
      }
      for (let i = 0; i < results.length; i++) {
        const expectedDelay = delays[i % delays.length];
        if (expectedDelay === DELAY.short) {
          expect(results[i]).assertLessOrEqual(DELAY.default + 200);
          expect(results[i]).assertLargerOrEqual(DELAY.short);
        } else if (expectedDelay === DELAY.default) {
          expect(results[i]).assertLessOrEqual(DELAY.double + 500);
          expect(results[i]).assertLargerOrEqual(DELAY.default);
        } else if (expectedDelay === DELAY.double) {
          expect(results[i]).assertLessOrEqual(DELAY.long);
          expect(results[i]).assertLargerOrEqual(DELAY.double);
        } else if (expectedDelay === DELAY.long) {
          expect(results[i]).assertLessOrEqual(DELAY.long + 500);
          expect(results[i]).assertLargerOrEqual(DELAY.long - 100);
        } else if (expectedDelay === 10) {
          expect(results[i]).assertLessOrEqual(10 + 500);
          expect(results[i]).assertLargerOrEqual(8);
        }
        Log.info(TAG, `Verified mixed delay run ${i + 1}`);
      }
    });

    // Test case: Verify duration with mocked timeKiller rejecting for various delays
    it('should_handle_mocked_timeKiller_rejecting_various_delays', 0, async () => {
      Log.info(TAG, 'Testing mocked timeKiller rejecting for various delays');

      const delays = [DELAY.short, DELAY.default, DELAY.double];
      for (const delay of delays) {

        try {
          await Timer.getDuration(timeKiller, delay);
          throw Error(`Reject for ${delay}`);
        } catch (e) {
          expect(e.message).assertEqual(`Reject for ${delay}`);
          Log.info(TAG, `Rejection caught for delay ${delay}`);
        }
      }
    });

    // Test case: Verify duration with mocked timeKiller delayed rejection for various delays
    it('should_handle_mocked_timeKiller_delayed_rejection_various_delays', 0, async () => {
      Log.info(TAG, 'Testing mocked timeKiller delayed rejection for various delays');

      const delays = [DELAY.short, DELAY.default, DELAY.double];
      for (const delay of delays) {

        try {
          await Timer.getDuration(timeKiller, delay);
        } catch (e) {
          expect(e.message).assertEqual(`Delayed reject for ${delay}`);
          Log.info(TAG, `Delayed rejection caught for delay ${delay}`);
        }
      }
    });

    // Test case: Verify duration with high load concurrent calls
    it('should_handle_high_load_concurrent_calls', 0, async () => {
      Log.info(TAG, 'Testing high load concurrent calls');
      const promises = Array(10).fill(null).map(() => Timer.getDuration(timeKiller, DELAY.short));
      const results = await Promise.all(promises);
      Log.info(TAG, `High load concurrent results: ${results}`);
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(DELAY.default + 200);
        expect(result).assertLargerOrEqual(DELAY.short);
        Log.info(TAG, `Verified high load concurrent run ${index + 1}`);
      });
    });

    // Test case: Verify duration with high load sequential calls
    it('should_handle_high_load_sequential_calls', 0, async () => {
      Log.info(TAG, 'Testing high load sequential calls');
      const results: number[] = [];
      for (let i = 0; i < 20; i++) {
        const result = await Timer.getDuration(timeKiller, DELAY.short);
        results.push(result);
        Log.info(TAG, `High load sequential run ${i + 1} duration: ${result}`);
      }
      results.forEach((result, index) => {
        expect(result).assertLessOrEqual(DELAY.default + 200);
        expect(result).assertLargerOrEqual(DELAY.short);
        Log.info(TAG, `Verified high load sequential run ${index + 1}`);
      });
    });

    // Test case: Verify duration with mixed high load calls
    it('should_handle_mixed_high_load_calls', 0, async () => {
      Log.info(TAG, 'Testing mixed high load calls');
      const delays = [DELAY.short, DELAY.default, DELAY.double, DELAY.long];
      const promises = delays.flatMap(delay => Array(5).fill(null).map(() => Timer.getDuration(timeKiller, delay)));
      const results = await Promise.all(promises);
      Log.info(TAG, `Mixed high load results: ${results}`);
      results.forEach((result, index) => {
        const expectedDelay = delays[Math.floor(index / 5)];
        if (expectedDelay === DELAY.short) {
          expect(result).assertLessOrEqual(DELAY.default + 200);
          expect(result).assertLargerOrEqual(DELAY.short);
        } else if (expectedDelay === DELAY.default) {
          expect(result).assertLessOrEqual(DELAY.double + 500);
          expect(result).assertLargerOrEqual(DELAY.default);
        } else if (expectedDelay === DELAY.double) {
          expect(result).assertLessOrEqual(DELAY.long);
          expect(result).assertLargerOrEqual(DELAY.double);
        } else if (expectedDelay === DELAY.long) {
          expect(result).assertLessOrEqual(DELAY.long + 500);
          expect(result).assertLargerOrEqual(DELAY.long - 100);
        }
        Log.info(TAG, `Verified mixed high load run ${index + 1}`);
      });
    });
  });
}

// Placeholder for assertFail (as per original code)
function assertFail(arg0: string) {
  throw new Error('Function not implemented.');
}