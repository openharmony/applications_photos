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
import { AccessibilityManager } from '../../../../../../../../imageEditor/common/src/main/ets/common/util/AccessibilityManager';

export default function AccessibilityManagerTest() {
  describe('AccessibilityManager', () => {
    it('AccessibilityManager_01', 0, () => {
      let instance1 = AccessibilityManager.getInstance();
      expect(instance1).not().assertNull();
    });

    it('AccessibilityManager_02', 0, () => {
      let instance1 = AccessibilityManager.getInstance();
      let instance2 = AccessibilityManager.getInstance();
      expect(instance1).not().assertNull();
      expect(instance2).not().assertNull();
      expect(instance1 == instance2).assertTrue();
    });
  });
}