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
import { describe, expect } from '@ohos/hypium';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { Driver, ON } from '@ohos.UiTest';
import { Log } from '@ohos/tools/src/main/utils/Log';
import {
  assertClickById,
  endTask,
  loggedTask,
  ShootStaticPhoto,
  SkipBootPage,
  StartCamera,
  StartPhotos,
  startTask,
  swipeSearch,
} from '../tools/steps';
import { PhotoType } from '../tools/constants';


const TAG: string = `${TestConstants.TAG}ImageStylusGuideTest`;

export default function imageStylusGuideTest(): void {
  // 涂鸦-引导页弹窗
  describe('ImageStylusGuideTest_1', () => {
    it('Task_01_stylus_guide_start_photo', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      const isStartPhotos = await StartPhotos();
      expect(isStartPhotos).assertTrue();
      await SkipBootPage();
    });
    it('Task_01_Stylus_Guide_Test01', TestConstants.TEST_LEVEL_ZERO, startTask(async (driver: Driver) => {
      // 进入涂鸦
      await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
      const component = await swipeSearch(ON.id('petalClip_bottomToolBar_TabsBar'),
        ON.id('petalClip_bottomToolBar_image_7'), 'right');
      expect(component).assertInstanceOf('Object');
    }, PhotoType.StaticImage));

    it('Task_01_Stylus_Guide_Test02', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalClip_bottomToolBar_image_7');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TEN_SECOND);
    }));

    it('Task_01_Stylus_Guide_Test03', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      let confirmBtn = await driver.findComponent(ON.id('advanced_dialog_button_0'));
      if (confirmBtn) {
        // 点击我知道了
        const button = await assertClickById('advanced_dialog_button_0');
        expect(button).assertInstanceOf('Object');
        await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
        Log.info(TAG, 'stylus guide test 01 click button success');
      } else {
        Log.info(TAG, 'stylus guide test 01 click button none');
      }
    }));

    it('Task_01_Stylus_Guide_Test04', TestConstants.TEST_LEVEL_ZERO, endTask(async (driver: Driver) => {
      // 点击X退出涂鸦
      const button = await assertClickById('petalClip_stylus_cancel');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));
  });
}
