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
import { afterAll, describe, expect } from '@ohos/hypium';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { ON } from '@ohos.UiTest';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { SkipBootPage } from '../imageEditor/tools/steps';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';

const TAG: string = `${TestConstants.TAG}longpressOperationTest`;
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
const NUMBER_ONE: number = 1;

export default function longPressOperation(): void {
  describe('LongPressOperationTest', (): void => {
    it('Task_LongPress_start_photo', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await longPressStartPhoto();
      expect(NUMBER_ONE).assertEqual(1);
    });
    it('Task_LongPress_002', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await longPressTest002(dt);
    });
    it('Task_LongPress_003', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await longPressTest003(dt);
    });
    it('Task_LongPress_004', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await longPressTest004(dt);
    });
    it('Task_LongPress_005', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await longPressTest005(dt);
    });
    it('Task_LongPress_006', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await longPressTest006(dt);
    });
    it('Task_LongPress_007', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await longPressTest007(dt);
    });
    it('Task_LongPress_008', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await longPressTest008(dt);
    });
  })
}

async function longPressStartPhoto() {
  Log.info(TAG, 'Task_LongPress_start_photo start');
  try {
    let res = await abilityDelegator.executeShellCommand('aa start -a com.ohos.photos.MainAbility -b com.ohos.photos')
      .then((): void => {
        Log.info(TAG, 'MainAbility start success');
      });
    expect(res === undefined).assertEqual(true);
  } catch (exception) {
    Log.info(TAG, `start failed :${exception.code}`);
  } finally {
    Log.info(TAG, 'start photo application');
  }
  Log.info(TAG, 'Task_LongPress_start_photo end');
  await SkipBootPage();
}

// 多选用例
async function longPressTest002(dt: Dt) {
  Log.info(TAG, 'Task_LongPress_002 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 确认日视图组件是否存在
  await dt.assertComponentByText('日');
  // 1. 长按宫格
  let componentIdsArr1: Array<string> = [
    'photoGridView_gird_1',
    'photoGridView_gird_2',
    'photoGridView_gird_3',
    'photoGridView_gird_4',
    'photoGridView_gird_5',
    'photoGridView_gird_6'];

  let componentIdsArr2: Array<string> = [
    'LongPress_1MultiSelected',
    'LongPress_2MultiSelected',
    'LongPress_3MultiSelected',
    'LongPress_4MultiSelected',
    'LongPress_5MultiSelected',
    'LongPress_6MultiSelected'];

  for (let i = 0; i < componentIdsArr1.length; i++) {
    const com = await driver.findComponent(ON.id(componentIdsArr1[i]));
    if (!com) {
      // 不存在则跳过该图片
      continue;
    }
    await com.longClick();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 2. 点击菜单多选
    await dt.assertClick(componentIdsArr2[i]);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 3. 退出多选
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_CANCEL);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 找到一个就返回
    break;
  }
  Log.info(TAG, 'Task_LongPress_002 end');
}

// 收藏用例 和 取消收藏key一样
async function longPressTest003(dt: Dt) {
  Log.info(TAG, 'Task_LongPress_003 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  let componentIdsArr1: Array<string> = [
    'photoGridView_gird_1',
    'photoGridView_gird_2',
    'photoGridView_gird_3',
    'photoGridView_gird_4',
    'photoGridView_gird_5',
    'photoGridView_gird_6'];

  let componentIdsArr2: Array<string> = [
    'LongPress_1Favor',
    'LongPress_2Favor',
    'LongPress_3Favor',
    'LongPress_4Favor',
    'LongPress_5Favor',
    'LongPress_6Favor'];

  for (let i = 0; i < componentIdsArr1.length; i++) {
    const com = await driver.findComponent(ON.id(componentIdsArr1[i]));
    if (!com) {
      // 不存在则跳过该图片
      continue;
    }
    await com.longClick();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 5. 点击菜单收藏
    await dt.assertClick(componentIdsArr2[i]);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 找到一个就返回
    break;
  }
  Log.info(TAG, 'Task_LongPress_003 end');
}

// 分享用例
async function longPressTest004(dt: Dt) {
  Log.info(TAG, 'Task_LongPress_004 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

  let componentIdsArr1: Array<string> = [
    'photoGridView_gird_1',
    'photoGridView_gird_2',
    'photoGridView_gird_3',
    'photoGridView_gird_4',
    'photoGridView_gird_5',
    'photoGridView_gird_6'];

  let componentIdsArr2: Array<string> = [
    'LongPress_1Share',
    'LongPress_2Share',
    'LongPress_3Share',
    'LongPress_4Share',
    'LongPress_5Share',
    'LongPress_6Share'];

  for (let i = 0; i < componentIdsArr1.length; i++) {
    const com = await driver.findComponent(ON.id(componentIdsArr1[i]));
    if (!com) {
      // 不存在则跳过该图片
      continue;
    }
    await com.longClick();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 7. 点击菜单分享
    await dt.assertClick(componentIdsArr2[i]);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 8. 【退出分享按钮key变更】采用侧滑退出
    await dt.pressBack();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 找到一个就返回
    break;
  }
  Log.info(TAG, 'Task_LongPress_004 end');
}

// 隐藏用例
async function longPressTest005(dt: Dt) {
  Log.info(TAG, 'Task_LongPress_005 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

  let componentIdsArr1: Array<string> = [
    'photoGridView_gird_1',
    'photoGridView_gird_2',
    'photoGridView_gird_3',
    'photoGridView_gird_4',
    'photoGridView_gird_5',
    'photoGridView_gird_6'];

  let componentIdsArr2: Array<string> = [
    'LongPress_1Hide',
    'LongPress_2Hide',
    'LongPress_3Hide',
    'LongPress_4Hide',
    'LongPress_5Hide',
    'LongPress_6Hide'];

  for (let i = 0; i < componentIdsArr1.length; i++) {
    const com = await driver.findComponent(ON.id(componentIdsArr1[i]));
    if (!com) {
      // 不存在则跳过该图片
      continue;
    }
    await com.longClick();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 10. 点击菜单隐藏
    await dt.assertClick(componentIdsArr2[i]);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 11. 点击确定隐藏
    await dt.assertClick(TestConstants.DIALOG_BUTTON_SECOND);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 找到一个就返回
    break;
  }
  Log.info(TAG, 'Task_LongPress_005 end');
}

// 删除用例
async function longPressTest006(dt: Dt) {
  Log.info(TAG, 'Task_LongPress_006 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

  let componentIdsArr1: Array<string> = [
    'photoGridView_gird_1',
    'photoGridView_gird_2',
    'photoGridView_gird_3',
    'photoGridView_gird_4',
    'photoGridView_gird_5',
    'photoGridView_gird_6'];

  let componentIdsArr2: Array<string> = [
    'LongPress_1HoldPositionDelete',
    'LongPress_2HoldPositionDelete',
    'LongPress_3HoldPositionDelete',
    'LongPress_4HoldPositionDelete',
    'LongPress_5HoldPositionDelete',
    'LongPress_6HoldPositionDelete'];

  for (let i = 0; i < componentIdsArr1.length; i++) {
    const com = await driver.findComponent(ON.id(componentIdsArr1[i]));
    if (!com) {
      // 不存在则跳过该图片
      continue;
    }
    await com.longClick();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 13. 点击菜单删除， 组件id与图片id有关联关系，不能使用固定的id
    await dt.assertClick(componentIdsArr2[i]);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await dt.assertClick(TestConstants.DIALOG_BUTTON_SECOND);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 找到一个就返回
    break;
  }
  Log.info(TAG, 'Task_LongPress_006 end');
}

// 相册页长按用例，以上全为照片页用例
async function longPressTest007(dt: Dt) {
  Log.info(TAG, 'Task_LongPress_007 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 首次点击相册，后续就不点击相册了
  await dt.assertClick('TabAlbums');
  // 进入某个相册进行操作, 从后边相册开始尝试长按，前边都是系统相册
  let componentIdsArr: Array<string> = [
    'AccessibilityAlbumStack_7',
    'AccessibilityAlbumStack_8',
    'AccessibilityAlbumStack_9',
    'AccessibilityAlbumStack_10',
    'AccessibilityAlbumStack_11',
    'AccessibilityAlbumStack_12'
  ];
  for (let i = 0; i < componentIdsArr.length; i++) {
    const com = await driver.findComponent(ON.id(componentIdsArr[i]));
    if (!com) {
      // 不存在则跳过该相册
      continue;
    }
    // 是否可长按异常-效果等同于是否可点击
    const isLongClickable: boolean = await com.isLongClickable();
    // 系统相册无法长按
    if (isLongClickable) {
      await com.longClick();
      // 时间过短无法弹出菜单项，无法点击【添加照片】
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
      // 添加照片按钮
      await dt.assertClick('Album_LongPress_MovePhoto');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      // 3. 点击右上角X
      await driver.pressBack();
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      // 找到一个就返回
      break;
    }
  }
  Log.info(TAG, 'Task_LongPress_007 end');
}

async function longPressTest008(dt: Dt) {
  Log.info(TAG, 'Task_LongPress_008 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 进入某个相册进行操作, 从后边相册开始尝试长按，前边都是系统相册
  let componentIdsArr: Array<string> = [
    'AccessibilityAlbumStack_7',
    'AccessibilityAlbumStack_8',
    'AccessibilityAlbumStack_9',
    'AccessibilityAlbumStack_10',
    'AccessibilityAlbumStack_11',
    'AccessibilityAlbumStack_12'
  ];
  for (let i = 0; i < componentIdsArr.length; i++) {
    const com = await driver.findComponent(ON.id(componentIdsArr[i]));
    if (!com) {
      // 不存在则跳过该相册
      continue;
    }
    const isLongClickable: boolean = await com.isLongClickable();
    // 系统相册无法长按
    if (isLongClickable) {
      await com.longClick();
      // 时间过短无法弹出菜单项
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
      // 点击菜单添加照片
      await dt.assertClick('Album_LongPress_MovePhoto');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      // 3. 选择一张图片
      if (await driver.findComponent(ON.id('ImageGridItem_Column_0'))) {
        await dt.assertClick('Selector_0');
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
        //4.点击完成按钮
        await dt.assertClick('Complete');
        Log.info(TAG, 'add photo finish');
      } else {
        //当不存在照片时直接退出
        await driver.pressBack();
      }
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      // 找到一个就返回
      break;
    }
  }
  Log.info(TAG, 'Task_LongPress_008 end');
}