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
import { describe, expect, it, MockKit } from '@ohos/hypium';
import { ImmersiveController, MViewType } from '@ohos/common/src/main/ets/default/utils/ImmersiveController';
import { ConfigurationConstant } from '@kit.AbilityKit';

export default function ImmersiveControllerTest() {

  describe('ImmersiveControllerTest', () => {

    it('setCurrentViewType', 0, () => {
      let mode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
      let controller = new ImmersiveController(mode, false)
      controller.setCurrentViewType(MViewType.DAY);
      let res: MViewType.DAY = Reflect.get(controller, 'currentViewType');
      expect(res).assertEqual(MViewType.DAY);
    })

    it('should_set_immersive_threshold_correctly', 0, () => {
      let mode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
      let controller = new ImmersiveController(mode, false);
      controller.setThreshold(40);
      expect(controller.immersiveThreshold).assertEqual(40);
    });

    //测试setCurrentViewType
    it('should_set_currentViewType_to_DIGITAL', 0, () => {
      let mode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
      let controller = new ImmersiveController(mode, false);
      controller.setCurrentViewType(MViewType.YEAR);
      expect(Reflect.get(controller, 'currentViewType')).assertEqual(MViewType.YEAR);
    });

    //测试setStatusColor
    it('setStatusColor_when_nextScrollYOffset_bigger_than_immersiveThreshold', 0, () => {
      let mode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
      let controller = new ImmersiveController(mode, false);
      // 显式指定immersiveThreshold = 20;
      controller.setThreshold(20);
      let currentMode = ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
      let isSideBar = true;
      let mocker: MockKit = new MockKit();
      let func: Function = Reflect.get(controller, 'setImmersiveStatusColor');
      mocker.mockFunc(controller, func);
      controller.setStatusColor(21, currentMode, isSideBar);
      mocker.verify('setImmersiveStatusColor', [currentMode, isSideBar]).once();
      mocker.ignoreMock(controller, func);
      mocker.clear(controller);
    });

    it('setStatusColor_when_nextScrollYOffset_bigger_not_than_immersiveThreshold', 0, () => {
      let mode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
      let controller = new ImmersiveController(mode, false);
      // 显式指定immersiveThreshold = 20;
      controller.setThreshold(20)
      let currentMode = ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
      let isSideBar = true;
      let mocker: MockKit = new MockKit();
      let func: Function = Reflect.get(controller, 'setNormalStatusColor');
      mocker.mockFunc(controller, func);
      controller.setStatusColor(19, currentMode, isSideBar);
      mocker.verify('setNormalStatusColor', [currentMode]).once();
      mocker.ignoreMock(controller, func);
      mocker.clear(controller);
    });

  })
}