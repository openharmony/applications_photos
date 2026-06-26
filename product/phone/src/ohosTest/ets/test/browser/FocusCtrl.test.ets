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
import { MultimodalInputManager } from '@ohos/common/src/main/ets/default/model/common/MultimodalInputManager';
import { afterEach, ArgumentMatchers, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { FocusCtrl } from '@ohos/tools/src/main/variables/FocusCtrl';

export default function FocusCtrlTest() {
  describe('FocusCtrlTest', () => {

    beforeEach(() => {
    });

    afterEach(() => {
    });

    it('handleSideBarKeyEvent', 0, () => {
      handleSideBarKeyEvent();
    });
  })
}

function handleSideBarKeyEvent() {
  let object: ESObject = new Object();
  object.keyCode = 'test';
  FocusCtrl.handleSideBarKeyEvent(object);
  object.keyCode = MultimodalInputManager.KEY_CODE_KEYBOARD_LEFT;
  object.stopPropagation = () => {
  };
  FocusCtrl.handleSideBarKeyEvent(object);
}