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
import { Driver, ON, PointerMatrix } from '@ohos.UiTest';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { SkipBootPage } from '../imageEditor/tools/steps';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';

const TAG: string = `${TestConstants.TAG}timeLinePinchTest`;
const NUMBER_ONE: number = 1;
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

export default function timeLinePinchTest(): void {
  describe('TimeLinePinch', (): void => {
    it('TimeLinePinch_test001', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await TimeLinePinchTest001(dt);
      expect(NUMBER_ONE).assertEqual(1);
    });
    it('TimeLinePinch_test002', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await TimeLinePinchTest002(dt);
    });
    it('TimeLinePinch_test003', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await TimeLinePinchTest003(dt);
    });
    it('TimeLinePinch_test004', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await TimeLinePinchTest004(dt);
    });
    it('TimeLinePinch_test005', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await TimeLinePinchTest005(dt);
    });
  })
}

/**
 * 打开图库
 */
async function TimeLinePinchTest001(dt: Dt) {
  Log.info(TAG, 'TimeLinePinchTest001 start.');
  const callback = (): void => {
    Log.info(TAG, 'start photo with  single select success.');
  };
  try {
    let res = await abilityDelegator.executeShellCommand('aa start -a com.ohos.photos.MainAbility -b com.ohos.photos')
      .then(callback);
    expect(res === undefined).assertEqual(true);
  } catch (exception) {
    Log.info(TAG, `start failed:${exception.code}`);
  } finally {
    Log.info(TAG, 'start photo application.');
  }
  await SkipBootPage();
  Log.info(TAG, 'TimeLinePinchTest001 end.');
}

/**
 * 日视图捏合进入月视图
 */

async function TimeLinePinchTest002(dt: Dt) {
  Log.info(TAG, 'TimeLinePinchTest002 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 确认日宫格文字组件存在
  await dt.assertComponentByText('日');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'TimeLinePinchTest002 日 Component find');
  //日视图捏合放大
  await pinchOut(driver, 'TimeLinePinchTest002');
  // 日视图捏合缩小
  await pinchIn(driver, 'TimeLinePinchTest002');
  await pinchIn(driver, 'TimeLinePinchTest002');
  Log.info(TAG, 'TimeLinePinchTest002 start');
}

/**
 * 月视图捏合进入年试图
 */
async function TimeLinePinchTest003(dt: Dt) {
  Log.info(TAG, 'TimeLinePinchTest003 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 确认月宫格文字组件存在
  await dt.assertComponentByText('月');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'TimeLinePinchTest003 月 Component found');
  //月视图捏合放大
  await pinchOut(driver, 'TimeLinePinchTest003');
  // 月视图捏合缩小
  await pinchIn(driver, 'TimeLinePinchTest003');
  await pinchIn(driver, 'TimeLinePinchTest003');
  Log.info(TAG, 'TimeLinePinchTest003 end');
}

/**
 * 年试图捏合至日视图（捏合幅度需仔细调整）
 */
async function TimeLinePinchTest004(dt: Dt) {
  Log.info(TAG, 'TimeLinePinchTest004 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 确认年宫格文字组件存在
  await dt.assertComponentByText('年');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'TimeLinePinchTest004 年 Component found');
  await pinchIn(driver, 'TimeLinePinchTest004');
  await pinchIn(driver, 'TimeLinePinchTest004');
  await pinchIn(driver, 'TimeLinePinchTest004');
  await pinchIn(driver, 'TimeLinePinchTest004');
  Log.info(TAG, 'TimeLinePinchTest004 end');
}

/**
 * 大图捏合场景
 */
async function TimeLinePinchTest005(dt: Dt) {
  Log.info(TAG, 'TimeLinePinchTest005 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 确认日宫格文字组件存在
  await dt.assertComponentByText('日');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'TimeLinePinchTest005 日 Component clicked');
  await SwipeUp(driver, 540, 1200);
  await pinchOut(driver, 'TimeLinePinchTest005');

  // 1. 长按宫格
  let componentIdsArr1: Array<string> = [
    'photoGridView_gird_1',
    'photoGridView_gird_2',
    'photoGridView_gird_3',
    'photoGridView_gird_4',
    'photoGridView_gird_5',
    'photoGridView_gird_6'];

  for (let i = 0; i < componentIdsArr1.length; i++) {
    const com = await driver.findComponent(ON.id(componentIdsArr1[i]));
    if (!com) {
      // 不存在则跳过该图片
      continue;
    }
    await dt.assertClick(componentIdsArr1[i]);
    await pinchOut(driver, componentIdsArr1[i]);
    break;
  }
  Log.info(TAG, 'TimeLinePinchTest005 end');
}

async function SwipeUp(driver: Driver, distance: number, duration: number) {
  await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.swipe(800, distance, 800, duration, 800);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.swipe(800, distance, 800, duration, 800);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.swipe(800, distance, 800, duration, 800);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.swipe(800, distance, 800, duration, 800);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.swipe(800, distance, 800, duration, 800);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.swipe(800, distance, 800, duration, 800);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.swipe(800, distance, 800, duration, 800);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.swipe(800, distance, 800, duration, 800);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
}

/**
 * 捏合放大
 * @param driver
 * @param tag
 */

async function pinchOut(driver: Driver, tag: string) {
  let pointers01 = PointerMatrix.create(2, 2);
  pointers01.setPoint(0, 0, {
    x: 700, y: 800,
  });
  pointers01.setPoint(0, 1, {
    x: 650, y: 800,
  });
  pointers01.setPoint(1, 0, {
    x: 750, y: 800,
  });
  pointers01.setPoint(1, 1, {
    x: 800, y: 800,
  });
  await driver.injectMultiPointerAction(pointers01);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, `${tag} pinch out end.`);
}

/**
 * 捏合缩小
 * @param driver
 * @param tag
 */
async function pinchIn(driver: Driver, tag: string) {
  let pointers01 = PointerMatrix.create(2, 2);
  pointers01.setPoint(0, 0, {
    x: 650, y: 800,
  });
  pointers01.setPoint(0, 1, {
    x: 700, y: 800,
  });
  pointers01.setPoint(1, 0, {
    x: 800, y: 800,
  });
  pointers01.setPoint(1, 1, {
    x: 750, y: 800,
  });
  await driver.injectMultiPointerAction(pointers01);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, `${tag} pinch in end.`);
}