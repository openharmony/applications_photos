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
import { afterEach, ArgumentMatchers, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import {
  ActionBarVar,
  SideBarStatusListener,
  SideBarVarClass,
  SideBarViewModel
} from '@ohos/tools/src/main/variables/ActionBarVar';

export default function ActionBarVarTest() {
  describe('ActionBarVarTest', () => {

    beforeEach(() => {
    });

    afterEach(() => {
    });

    it('getInstance', 0, () => {
      getInstance();
    });
    it('register', 0, () => {
      register();
    });
    it('unregister', 0, () => {
      unregister();
    });
  })
}

function getInstance() {
  SideBarVarClass.getInstance();
  (SideBarVarClass as ESObject).sideBarVarClass = null as ESObject;
  SideBarVarClass.getInstance();
}

function register() {
  let sideBarViewModel: SideBarViewModel = new SideBarViewModel();
  let listener: SideBarStatusListener = {
    onStatusChanged: (status: boolean): void => {
    },
  } as SideBarStatusListener;
  sideBarViewModel.register(listener);
  expect((sideBarViewModel as ESObject).listeners.length).assertEqual(1);
  sideBarViewModel.register(listener);
}

function unregister() {
  let sideBarViewModel: SideBarViewModel = new SideBarViewModel();
  let listener: SideBarStatusListener = {
    onStatusChanged: (status: boolean): void => {
    },
  } as SideBarStatusListener;
  sideBarViewModel.unregister(listener);
  (sideBarViewModel as ESObject).listeners.push(listener);
  sideBarViewModel.unregister(listener);
  expect((sideBarViewModel as ESObject).listeners.length).assertEqual(0);
}