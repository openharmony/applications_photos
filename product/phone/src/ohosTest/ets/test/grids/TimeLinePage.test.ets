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
import { ON, Point, Rect } from '@ohos.UiTest';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { SkipBootPage } from '../imageEditor/tools/steps';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';

const TAG: string = `${TestConstants.TAG}timeLinePageTest`;
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
const NUMBER_ONE: number = 1;

export default function timeLinePageTest(): void {
  describe('TimeLinePageTest', (): void => {
    it('Task_003_start_photo', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await Task_003_start_photo();
      expect(NUMBER_ONE).assertEqual(1);
    });
    it('Task_003_Select_Test00', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await Task_003_Select_Test00(dt);
    });
    it('Task_003_Select_Test01', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await Task_003_Select_Test01(dt);
    });
    it('Task_003_Select_Test02', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_003_Select_Test02(dt);
    });
    it('Task_003_Select_Test03', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_003_Select_Test03(dt);
    });
    it('Task_003_Select_Test04', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_003_Select_Test04(dt);
    });
    it('Task_003_Select_Test05', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_003_Select_Test05(dt);
    });
  })
}

/**
 * 打开图库
 */
async function Task_003_start_photo() {
  Log.info(TAG, 'Task_003_start_photo start.');
  const callback = (): void => {
    Log.info(TAG, 'MainAbility start success');
  };
  try {
    let res = await abilityDelegator.executeShellCommand('aa start -a com.ohos.photos.MainAbility -b com.ohos.photos')
      .then(callback);
    expect(res === undefined).assertEqual(true);
  } catch (exception) {
    Log.info(TAG, `start failed :${exception.code}`);
  } finally {
    Log.info(TAG, 'start photo application.');
  }
  Log.info(TAG, 'Task_003_start_photo end.');
  await SkipBootPage();
}

/**
 * 1、打开宫格页第二张图片
 * 2、退出大图浏览
 * 因组件复用，上下滑动后会出现gridItemKey复用情况，导致找不到应有的key
 * 故取消滑动操作
 */
async function Task_003_Select_Test00(dt: Dt) {
  Log.info(TAG, 'Task_003_Select_Test00 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

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
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, `${componentIdsArr1[i]} clicked`);
    await dt.assertClick('More_Image_Back');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'More_Image_Back clicked');
    break;
  }
  Log.info(TAG, 'Task_003_Select_Test00 end');
}

/**
 * 照片页多选选中图片操作
 */
async function Task_003_Select_Test01(dt: Dt) {
  Log.info(TAG, 'Task_003_Select_Test01 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertTextClick('多选');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'multiSelectedBtn click');

  // 1. 长按宫格
  let componentIdsArr1: Array<string> = [
    'Selector_1',
    'Selector_2',
    'Selector_3',
    'Selector_4'];

  for (let i = 0; i < componentIdsArr1.length; i++) {
    const com = await driver.findComponent(ON.id(componentIdsArr1[i]));
    if (!com) {
      // 不存在则跳过该图片
      continue;
    }
    await dt.assertClick(componentIdsArr1[i]);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    break;
  }
  // 使用返回键取消多选
  await dt.pressBack();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'Task_003_Select_Test01 end');
}

/**
 * 1、点击右上角多选按钮进入选择模式，并点击第一张图片
 * 2、点击右上角全选
 * 3、点击右上角取消全选
 * 4、点击取消，退出选择模式
 *
 */
async function Task_003_Select_Test02(dt: Dt) {
  Log.info(TAG, 'Task_003_Select_Test02 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertTextClick('多选');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertTextClick('全选');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'selectAll clicked');
  await dt.assertTextClick('取消全选');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'deSelectAll clicked');
  await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_CANCEL);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'actionBarButtonCancel clicked');
  Log.info(TAG, 'Task_003_Select_Test02 end');
}

/**
 * 多选模式下大图预览测试
 * 1、点击右上角多选按钮进入选择模式
 * 2、点击图片左上角预览按钮， 进入预览模式
 * 3、点击右上角选择框取消选择
 * 4、双击图片放大
 * 5、双击图片恢复
 * 6、点击返回键退出预览模式
 */
async function Task_003_Select_Test03(dt: Dt) {
  Log.info(TAG, 'Task_003_Select_Test03 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertTextClick('多选');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'multiSelectedBtn click');

  let componentIdsArr1: Array<string> = [
    'photoGridView_gird_1',
    'photoGridView_gird_2',
    'photoGridView_gird_3',
    'photoGridView_gird_4',
    'photoGridView_gird_5',
    'photoGridView_gird_6'];

  for (let i = 0; i < componentIdsArr1.length; i++) {
    const picture = await driver.findComponent(ON.id(componentIdsArr1[i]));
    if (!picture) {
      // 不存在则跳过该图片
      continue;
    }
    let rect: Rect = await picture.getBounds();
    let point: Point = await picture.getBoundsCenter();

    // 点击图片左上角区域可进入大图预览
    await driver.click(Math.round(point.x - (rect.right - rect.left) / 4), Math.round(point.y + (rect.top - rect.bottom) / 4));
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

    // button级别 勾选key: AccessibilityComponentMaterialSelect
    const button = await driver.findComponent(ON.id('AccessibilityComponentMaterialSelect'));
    if (button) {
      // 右上角勾选按钮
      await button.click();
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, 'AccessibilityComponentMaterialSelect clicked');
      // button级别按钮key 取消勾选按钮
      await dt.assertClick('AccessibilityComponentSelected');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, 'actionBarButtonSelected clicked');
      await driver.doubleClick(point.x, point.y);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, 'image double clicked 1');
      await driver.doubleClick(point.x, point.y);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, 'image double clicked 2');
    }
    // button级别 返回按钮 AccessibilityComponentBack
    // SymbolGlyph组件 返回按钮 More_Image_Back
    // 当前问题：照片页图片预览 和相册页图片预览返回按钮不一致
    await dt.assertClick('More_Image_Back');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

    // 叉号按钮【使用pressBack可能会导致测试进程退出】，ActionButton_Cancel可能存在点击无效情况
    await dt.assertClick('ActionButton_Cancel');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'More_Image_Cancel clicked');
    break;
  }
  Log.info(TAG, 'Task_003_Select_Test03 end');
}

/**
 * 照片页多选选中图片 移动到新建相册测试
 * 1、点击ToolBarButtonSelectAll 取消全选
 * 2、点击第三张图片，选择第三张图片
 * 3、点击更多
 * 4、点击添加到相册
 * 5、点击新建相册
 * 6、点击确认
 */
async function Task_003_Select_Test04(dt: Dt) {
  Log.info(TAG, 'Task_003_Select_Test04 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertTextClick('多选');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'ActionBarButtonMultiSelected start');

  let componentIdsArr1: Array<string> = [
    'Selector_1',
    'Selector_2',
    'Selector_3',
    'Selector_4'];

  for (let i = 0; i < componentIdsArr1.length; i++) {
    const picture = await driver.findComponent(ON.id(componentIdsArr1[i]));
    if (!picture) {
      // 不存在则跳过该图片
      continue;
    }
    await dt.assertClick(componentIdsArr1[i]);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, `${componentIdsArr1[i]} clicked`);
    // 更多
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'ActionButton_More clicked');
    // 移动到
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE_MOVE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'toolBarPopupBuilderTextOfAdd clicked');
    // 移动到 -> 新建相册
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE_NEW_ALBUM);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'actionBarButtonNew clicked');
    // 确认'新建'
    await dt.assertClick(TestConstants.DIALOG_BUTTON_SECOND);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'newAlbumDialogConfirmButton clicked');
    break;
  }
  Log.info(TAG, 'Task_003_Select_Test04 end');
}

/**
 * 年月日控件切换
 */
async function Task_003_Select_Test05(dt: Dt) {
  Log.info(TAG, 'Task_003_Select_Test05 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertTextClick('月');
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
  await driver.swipe(800, 540, 800, 1200, 800);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'swipe down');
  await dt.assertTextClick('年');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.swipe(800, 1200, 800, 540, 800);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'swipe up');
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
  await driver.swipe(800, 540, 800, 1200, 800);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'swipe down');
  await dt.assertTextClick('月');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertTextClick('日');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertTextClick('年');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertTextClick('日');
  Log.info(TAG, 'Task_003_Select_Test05 end');
}
