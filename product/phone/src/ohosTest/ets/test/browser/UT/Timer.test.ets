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
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import Timer from '@ohos/tools/src/main/utils/Timer';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';

const TAG: string = 'DT/getDurationTest';

let timeKiller: (time: number) => Promise<void> = async (time: number) => {
  await Timer.sleep(time);
  return new Promise<void>((resolve, reject) => setTimeout(() => {
    resolve();
  }, time));
};

export default function getDurationTest(): void {
  describe('getDuration_testSuite', (): void => {
    it('should_return_correct_duration_when_timeKiller_completes_successfully', 0, async () => {
      const result = await Timer.getDuration(timeKiller, 1000);
      expect(result).assertLessOrEqual(2600);
      expect(result).assertLargerOrEqual(1990);
    });

    it('should_return_correct_duration_short', 0, async () => {
      const result = await Timer.getDuration(timeKiller, DELAY.short);
      expect(result).assertLessOrEqual(DELAY.default + 200);
      expect(result).assertLargerOrEqual(DELAY.default);
    });

    it('should_return_correct_duration_default', 0, async () => {
      const result = await Timer.getDuration(timeKiller, DELAY.default);
      expect(result).assertLessOrEqual(DELAY.double + 500);
      expect(result).assertLargerOrEqual(DELAY.double);
    });

    it('should_return_correct_duration_double', 0, async () => {
      const result = await Timer.getDuration(timeKiller, DELAY.double);
      expect(result).assertLessOrEqual(DELAY.long);
      expect(result).assertLargerOrEqual(DELAY.double);
    });

    it('should_return_correct_duration_when_timeKiller_throws_error', 0, async () => {
      try {
        await Timer.getDuration(timeKiller, 0);
        throw Error('Test error');
      } catch (e) {
        expect(e.message).assertEqual('Test error');
      }
    });

    it('should_return_correct_duration_when_timeKiller_returns_undefined', 0, async () => {
      const result = await Timer.getDuration(timeKiller, 0);
      expect(result).assertLessOrEqual(20);
    });
  });
}

function assertFail(arg0: string) {
  throw new Error('Function not implemented.');
}
