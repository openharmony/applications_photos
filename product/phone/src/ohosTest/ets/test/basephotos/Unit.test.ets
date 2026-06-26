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
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { BusinessError } from '@ohos.base';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { ON } from '@kit.TestKit';
import { SkipBootPage } from '../imageEditor/tools/steps';

const TAG: string = `${TestConstants.TAG}UnitTest`;
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

export default function unitTest(): void {
  describe('UnitTest', () => {
    /**
     * 打开图库
     */
    it('closeDialogTest', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      let driver = dt.driver;
      Log.info(TAG, 'UT_Test_001 start');
      const callback = (): void => {
        Log.info(TAG, 'MainAbility start success ');
      };
      try {
        await abilityDelegator.executeShellCommand('aa start -a com.ohos.photos.MainAbility -b com.ohos.photos')
          .then(callback);
      } catch (exception) {
        let exp: BusinessError = exception as BusinessError;
        expect(0).assertEqual(exp.code);
        Log.info(TAG, `start failed :${exp.code}`);
      } finally {
        Log.info(TAG, 'start photo application.');
      }
      if (await driver.findComponent(ON.id('advanced_dialog_button_0'))) {
        await dt.assertClick('advanced_dialog_button_0');
      }
      await SkipBootPage();
      await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_SEARCH);
      await dt.clickIfExistByText('同意', TestConstants.DELAY_ONE_SECOND);
      if (await driver.findComponent(ON.text('请选择中文键盘布局'))) {
        await dt.assertTextClick('下一步');
      }
      await dt.assertClick('searchBackButton');
      Log.info(TAG, 'UT_Test_001 end');
    });

    /**
     * Picker 选择单张图片
     */
    it('UT_Test_002', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      Log.info(TAG, 'UT_Test_002 start');
      try {
        await abilityDelegator.executeShellCommand('aa start -a com.ohos.photos.MainAbility -b com.ohos.photos')
          .then((): void => {
            Log.info(TAG, 'MainAbility start success');
          });
      } catch (exception) {
        let exp: BusinessError = exception as BusinessError;
        expect(0).assertEqual(exp.code);
        Log.info(TAG, `start failed :${exp.code}`);
      } finally {
        Log.info(TAG, 'start photo application');
      }
      Log.info(TAG, 'UT_Test_002 end');
    });

    /**
     * 1、pick 选择多张图片
     */
    it('UT_Test_003', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      Log.info(TAG, 'UT_Test_003 start');
      try {
        await abilityDelegator.executeShellCommand('aa start -a com.ohos.photos.MainAbility -b com.ohos.photos')
          .then((): void => {
            Log.info(TAG, 'MainAbility start success');
          });
      } catch (exception) {
        let exp: BusinessError = exception as BusinessError;
        expect(0).assertEqual(exp.code);
        Log.info(TAG, `start failed:${exp.code}`);
      } finally {
        Log.info(TAG, 'start photo application');
      }
      Log.info(TAG, 'UT_Test_003 end');
    });
  });
}


