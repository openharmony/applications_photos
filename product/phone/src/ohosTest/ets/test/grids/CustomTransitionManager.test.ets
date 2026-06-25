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

import { describe, it, expect } from '@ohos/hypium';
import { AnimateCallback, CustomTransitionManager } from '@ohos/common/src/main/ets/default/model/CustomTransitionManager';

export default function CustomTransitionManagerTest() {
  describe('CustomTransitionManagerTest', () => {

    it('should_register_new_animate_then_get', 0, () => {
      let customTransitionManager: CustomTransitionManager = CustomTransitionManager.getInstance();
      let name: string = 'testParam';
      let callback: (operation: boolean) => void = (operation: boolean) => {};
      let timeout: number = 1000;
      customTransitionManager.registerNavParam(name, callback, timeout);
      let params: AnimateCallback | undefined = customTransitionManager.getAnimateParam(name);
      expect(params?.callback).assertEqual(callback);
      expect(params?.timeout).assertEqual(timeout);
    });

    it('should_register_new_animate_then_delete_then_get', 0, () => {
      let customTransitionManager: CustomTransitionManager = CustomTransitionManager.getInstance();
      let name: string = 'testParam';
      let callback: (operation: boolean) => void = (operation: boolean) => {};
      let timeout: number = 1000;
      customTransitionManager.registerNavParam(name, callback, timeout);
      customTransitionManager.unRegisterNavParam(name);
      let params: AnimateCallback | undefined = customTransitionManager.getAnimateParam(name);
      expect(params).assertEqual(undefined);
    });

  });
}