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

import { describe, expect, Level } from '@ohos/hypium';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Driver, ON } from '@ohos.UiTest';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';

const TAG: string = `${TestConstants.TAG}pickerTest`;
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

async function testClickByText(driver: Driver, id: string, logInfo: string): Promise<void> {
  await driver.assertComponentExist(ON.text(id));
  const button = await driver.findComponent(ON.text(id));
  await button.click();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, logInfo);
}

export default function pickerTest(): void {
  describe('PickerTest', (): void => {
    /**
     * Pick 选择单张图片
     */
    it('Task_005_Pick_Test01', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      const res = await AppStart.application(TestConstants.SINGLE_PICK_WANT, 'photo_with_single_select');
      expect(res !== null).assertTrue()
    });

    /**
     * 1、点击 从相机拍照 PickerCamera
     * 2、点击 拍照 COMPONENT_ID_SHUTTER_PHOTO_1
     * 3、点击 确认 COMPONENT_ID_THIRDPARTYCALL_CONFIRM_1
     * 4、再次 拉起 Pick 单选图片
     */
    it('Task_005_Pick_Test02', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      Log.info(TAG, 'Task_005_Pick_Test02 start');
      let driver = dt.driver;
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
      if (await driver.findComponent(ON.text('同意'))) {
        await testClickByText(driver, '同意', 'agree clicked');
      }
      if (await driver.findComponent(ON.text('跳过'))) {
        await testClickByText(driver, '跳过', 'skip_action clicked');
      }

      if (await driver.findComponent(ON.text('立即体验'))) {
        await testClickByText(driver, '立即体验', 'experienc_tips clicked');
      }
    });

    /**
     * 1、选择第一张图片 ThirdSelectPhotoGridBase0
     * 2、点击取消ActionBarButtonCancel
     * 3、选择第一张图片
     * 4、点击完成
     * 5、再次打开选择单张图片
     */
    it('Task_005_Pick_Test03', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      Log.info(TAG, 'Task_005_Pick_Test03 start');
      // 再次打开选择单张图片
      try {
        await abilityDelegator.startAbility(TestConstants.SINGLE_PICK_WANT).then(() => {
          Log.info(TAG, 'start photo with single select success');
        });
      } catch (exception) {
        expect(0).assertEqual(exception.code);
        Log.info(TAG, `start failed :${exception.code}`);
      } finally {
        Log.info(TAG, 'start photo application');
      }

      Log.info(TAG, 'Task_005_Pick_Test03 end');
    });

    /**
     * 1、滑动到底部，再滑动到顶部
     * 2、选择第一张图片 Gesture_0
     * 3、选择第二张图片 Gesture_1
     * 4、点击原图
     * 5、点击完成
     */
    it('Task_005_Pick_Test08', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      Log.info(TAG, 'Task_005_Pick_Test08 start');
      let driver = dt.driver;
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      await driver.swipe(800, 1200, 800, 540, 800);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, 'swipe up');
      await driver.swipe(800, 1200, 800, 540, 800);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, 'swipe up');
      await driver.swipe(800, 540, 800, 1200, 800);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, 'swipe down');
      await driver.swipe(800, 540, 800, 1200, 800);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, 'swipe down');
      await driver.click(500, 509);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, 'gesture_0 clicked');
      await driver.click(821, 500);
      const res = await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      expect(res !== null).assertFalse()
      Log.info(TAG, 'gesture_2 clicked');
      Log.info(TAG, 'Task_005_Pick_Test08 end');
    });

    /**
     * 1、pick选择多张图片
     */
    it('Task_005_Pick_Test09', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      Log.info(TAG, 'Task_005_Pick_Test09 start');
      try {
        await abilityDelegator.startAbility(TestConstants.MULTIPLE_PICK_WANT).then(() => {
          Log.info(TAG, 'start photo with single select success');
        });
      } catch (exception) {
        expect(0).assertEqual(exception.code);
        Log.info(TAG, `start failed :${exception.code}`);
      } finally {
        Log.info(TAG, 'start photo application');
      }
      Log.info(TAG, 'Task_005_Pick_Test09 end');
    });

    /**
     * 1、pick选择多张图片
     */
    it('Task_005_Pick_Test11', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      Log.info(TAG, 'Task_005_Pick_Test11 start');
      try {
        await abilityDelegator.startAbility(TestConstants.MULTIPLE_PICK_WANT).then(() => {
          Log.info(TAG, 'start photo with single select success');
        });
      } catch (exception) {
        expect(0).assertEqual(exception.code);
        Log.info(TAG, `start failed :${exception.code}`);
      } finally {
        Log.info(TAG, 'start photo application');
      }
      Log.info(TAG, 'Task_005_Pick_Test11 end');
    });

  })
}
