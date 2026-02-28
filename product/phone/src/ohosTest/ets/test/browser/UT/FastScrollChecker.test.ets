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

import { FastScrollChecker } from '@ohos/browsercommon/src/main/ets/default/utils/FastScrollChecker';
import { afterEach, ArgumentMatchers, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';

let fastScrollChecker: FastScrollChecker | undefined = undefined;

export default function FastScrollCheckerTest() {
  describe('FastScrollCheckerTest', () => {

    beforeEach(() => {
      fastScrollChecker = new FastScrollChecker();
    });

    afterEach(() => {
      if (!fastScrollChecker) {
        return;
      }
      fastScrollChecker = undefined;
    });

    it('recordScrollAndCheck', 0, () => {
      recordScrollAndCheck();
    });
  })
}

function recordScrollAndCheck() {
  if (!fastScrollChecker) {
    return;
  }
  let fast: boolean = fastScrollChecker.recordScrollAndCheck();
  expect(fast).assertFalse();
  fast = fastScrollChecker.recordScrollAndCheck();
  expect(fast).assertFalse();
  fast = fastScrollChecker.recordScrollAndCheck();
  expect(fast).assertFalse();
  fast = fastScrollChecker.recordScrollAndCheck();
  expect(fast).assertFalse();
  fast = fastScrollChecker.recordScrollAndCheck();
  expect(fast).assertFalse();
  fast = fastScrollChecker.recordScrollAndCheck();
  expect(fast).assertTrue();
  fast = fastScrollChecker.recordScrollAndCheck();
  expect(fast).assertTrue();
}