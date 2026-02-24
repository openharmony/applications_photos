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
import { ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import {
  describe,
  beforeEach,
  afterEach,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { MenuContext } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuContext';

export default function MenuContextTest() {
  describe('MenuContextTest', () => {

    it('should_return_menu_context_when_set_is_called_with_valid_parameters', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let mocker: MockKit = new MockKit();
      let paramsWrapper: ParamsWrapper = new ParamsWrapper();
      let mockFunc: Function = mocker.mockFunc(paramsWrapper, paramsWrapper.set);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(paramsWrapper);
      menuContext.set('testKey', Object);
      let res: MenuContext | undefined = menuContext.get('testKey');
      expect(res != undefined).assertEqual(true);
      mocker.ignoreMock(paramsWrapper, paramsWrapper.set);
    });

    it('should_return_menu_context_when_set_is_called_with_undefined_value', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let mocker: MockKit = new MockKit();
      let paramsWrapper: ParamsWrapper = new ParamsWrapper();
      let mockFunc: Function = mocker.mockFunc(paramsWrapper, paramsWrapper.set);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(paramsWrapper);
      menuContext.set('testKey', undefined);
      let res: MenuContext | undefined = menuContext.get('testKey');
      expect(res).assertEqual(undefined);
      mocker.ignoreMock(paramsWrapper, paramsWrapper.set);
    });

    it('should_set_isCancelled_to_true_when_cancel_is_called', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      menuContext.cancel();
      expect(menuContext.isCancelled).assertEqual(true);
    });
  });
}