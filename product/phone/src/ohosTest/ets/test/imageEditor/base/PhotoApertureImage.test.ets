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

import { afterAll, afterEach, beforeAll, describe, expect, Level } from '@ohos/hypium';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { Driver, ON, PointerMatrix } from '@ohos.UiTest';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import window from '@ohos.window';
import { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import { SkipBootPage,StartPhotos, testClickById, swipeSearch, startTask, loggedTask,
  assertClickById,
  endTask} from '../tools/steps';
import { PhotoType } from '../tools/constants';

const TAG: string = `${TestConstants.TAG}PhotoApertureImage`;

export default function PhotoApertureImageTest(): void {
  describe('PhotoApertureImageTest', () => {
    it('Task_06_ApertureImage_photo', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      const isStartPhotos = await StartPhotos();await StartPhotos();
      expect(isStartPhotos).assertTrue();
      await SkipBootPage();
    });

    it('Task_06_ApertureImage_Test01', TestConstants.TEST_LEVEL_ZERO,
      startTask(async (driver:Driver)=>{
        // 点击光圈
        const apertureButton = await driver.findComponent(ON.text('光圈'));
        if (apertureButton) {
          await apertureButton.click();
          expect(apertureButton).assertInstanceOf('Object');
        }
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      }, PhotoType.ApertureImage));

    it('Task_06_ApertureImage_Test02', TestConstants.TEST_LEVEL_ZERO,
      loggedTask(async (driver: Driver) => {
        // 滑动设置光圈大小
        expect(async() => {
          await driver.swipe(756, 2333, 315, 2333);
        }).not().assertThrowError('BusinessError');
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      }));

    it('Task_06_ApertureImage_Test03', TestConstants.TEST_LEVEL_ZERO,
      loggedTask(async (driver:Driver)=>{
        // 点击设置焦点位置
        expect(async() => {
          await driver.click(532, 1008);
        }).not().assertThrowError('BusinessError');
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      }));

    it('Task_06_ApertureImage_Test04', TestConstants.TEST_LEVEL_ZERO,
      loggedTask(async (driver:Driver)=>{
        // 长按对比
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
        await driver.assertComponentExist(ON.id('petalClip_VideoTrimTool_compareButton'));
        let compareButtonEdit = await driver.findComponent(ON.id('petalClip_VideoTrimTool_compareButton'));
        if (compareButtonEdit) {
          await compareButtonEdit.longClick();
          expect(compareButtonEdit).assertInstanceOf('Object');
        }
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      }));

    it('Task_06_ApertureImage_Test05', TestConstants.TEST_LEVEL_ZERO,
      loggedTask(async (driver:Driver)=>{
        // 设为横屏
        WindowUtil.setOrientation(window.Orientation.LANDSCAPE);
        await driver.delayMs(TestConstants.DELAY_THREE_SECOND);

        let orientation = await WindowUtil.getPreferredOrientation();
        expect(orientation).assertEqual(window.Orientation.LANDSCAPE);

        // 设为竖屏
        WindowUtil.setOrientation(window.Orientation.PORTRAIT);
        await driver.delayMs(TestConstants.DELAY_THREE_SECOND);

        orientation = await WindowUtil.getPreferredOrientation();
        expect(orientation).assertEqual(window.Orientation.PORTRAIT);
      }));

    it('Task_06_ApertureImage_Test06', TestConstants.TEST_LEVEL_ZERO,
      loggedTask(async (driver:Driver)=>{
        // 进出涂鸦
        await enterAndQuitStylus(driver);
      }));

    it('Task_06_ApertureImage_Test08', TestConstants.TEST_LEVEL_ZERO,
      loggedTask(async (driver:Driver)=>{
        // 进出AI修图
        await enterAndQuitAI(driver);
      }));

    it('Task_06_ApertureImage_Test09', TestConstants.TEST_LEVEL_ZERO,
      loggedTask(async (driver:Driver)=>{
        // 保存
        const saveButton = await driver.findComponent(ON.id('petalClip_topToolBar_save').enabled(true));
        if (saveButton) {
          Log.info(TAG, 'petalClip_topToolBar_save button exist');
          await saveButton.click();
          const overrideSaveBtn = await driver.findComponent(ON.text('覆盖原图'));
          if (overrideSaveBtn) {
            await overrideSaveBtn.click();
            expect(overrideSaveBtn).assertInstanceOf('Object');
          }
          await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
        }
      }));

    it('Task_06_ApertureImage_Test10', TestConstants.TEST_LEVEL_ZERO,
      endTask(async (driver: Driver) => {
        // 点击Revert按钮
        let button = await driver.findComponent(ON.id('petalClip_topToolBar_topTool_recover').enabled(true));
        if (button) {
          await assertClickById('petalClip_topToolBar_topTool_recover');
          await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
          // 确定
          const button = assertClickById('advanced_dialog_button_1');
          expect(button).assertInstanceOf('Object');
        }
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      }));
  });
}

async function enterAndQuitStylus(driver: Driver) {
  const component= await swipeSearch(ON.id('petalClip_bottomToolBar_TabsBar'),
    ON.id('petalClip_bottomToolBar_image_7'), 'right');
  expect(component).assertInstanceOf('Object');
  const button = await assertClickById('petalClip_bottomToolBar_image_7');
  expect(button).assertInstanceOf('Object');
  await testClickById(driver, 'advanced_dialog_button_0', 'advanced_dialog_button_0 clicked');
  await swipeSearch(ON.id('petalClip_bottomToolBar_TabsBar'),
    ON.id('petalClip_bottomToolBar_image_7'), 'right');
  await testClickById(driver, 'petalClip_bottomToolBar_image_7', 'petalClip_bottomToolBar_image_7 clicked');
  await testClickById(driver, 'advanced_dialog_button_1', 'advanced_dialog_button_1 clicked');
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  await testClickById(driver, 'petalClip_stylus_cancel', 'petalClip_stylus_cancel clicked');
}

async function enterAndQuitAI(driver: Driver) {
  const button = await assertClickById('petalclip_AiRetouch');
  expect(button).assertInstanceOf('Object');
  await testClickById(driver, 'advanced_dialog_button_0', 'advanced_dialog_button_0 clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await testClickById(driver, 'petalclip_AiRetouch', 'petalclip_AiRetouch clicked');
  await testClickById(driver, 'advanced_dialog_button_1', 'advanced_dialog_button_1 clicked');
  await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
  await testClickById(driver, 'petalclip_AiRetouch', 'petalclip_AiRetouch clicked');
}
