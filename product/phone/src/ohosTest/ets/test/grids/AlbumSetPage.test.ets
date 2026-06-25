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
import { MatchPattern, ON, Point, Rect } from '@ohos.UiTest';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { deletNewAlbums, SkipBootPage } from '../imageEditor/tools/steps';

const TAG: string = `${TestConstants.TAG}albumSetPageTest`;
const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
const NUMBER_ONE: number = 1;

export default function albumSetPageTest(): void {
  describe('AlbumSetPageTest', (): void => {
    it('Task_004_Album_Test00', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test00(dt);
      expect(NUMBER_ONE).assertEqual(1);
    });
    it('Task_004_Album_Test01', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test01(dt);
    });
    it('Task_004_Album_Test02', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test02(dt);
    });
    it('Task_004_Album_Test03', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test03(dt);
    });
    it('Task_004_Album_Test04', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test04(dt);
    });
    it('Task_004_Album_Test05', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test05(dt);
    });
    it('Task_004_Album_Test06', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test06(dt);
    });
    it('Task_004_Album_Test07', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test07(dt);
    });
    it('Task_004_Album_Test08', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test08(dt);
    });
    it('Task_004_Album_Test09', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test09(dt);
    });
    it('Task_004_Album_Test10', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test10(dt);
    });
    it('Task_004_Album_Test11', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test11(dt);
    });
    it('Task_004_Album_Test12', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test12(dt);
    });
    it('Task_004_Album_Test13', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test13(dt);
    });
    it('Task_004_Album_Test14', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test14(dt);
    });
    it("Task_004_Album_Test15", TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test15(dt);
    });
    it('Task_004_Album_Test16', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test16(dt);
    });
    it('Task_004_Album_Test17', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test17(dt);
    });
    it('Task_004_Album_Test18', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test18(dt);
    });
    it('Task_004_Album_Test19', TestConstants.TEST_LEVEL_ONE, async (dt: Dt): Promise<void> => {
      await Task_004_Album_Test19(dt);
    });
  })
}

/**
 * 点击打开图库
 */
async function Task_004_Album_Test00(dt: Dt) {
  Log.info(TAG, 'Task_001_StartPhoto_Test01 start');
  const callback = (): void => {
    Log.info(TAG, 'MainAbility start success');
  };
  try {
    let res =
      await abilityDelegator.executeShellCommand('aa start -a com.ohos.photos.MainAbility -b com.ohos.photos')
        .then(callback);
    expect(res === undefined).assertEqual(true);
  } catch (exception) {
    Log.info(TAG, `start ability failed :${exception.code}`);
  } finally {
    Log.info(TAG, 'start photo application');
  }
  await SkipBootPage();
}

/**
 * 进入相册页
 * 1、点击新建相册
 * 2、点击确认 NewAlbumDialogConfirmButton
 * 3、点击取消ActionBarButtonCancel
 * 起点：相册页、终点：相册页
 */
async function Task_004_Album_Test01(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test01 start');
  let driver = dt.driver;
  // 进入相册页
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick('TabAlbums');
  Log.info(TAG, 'TabAlbums clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 点击新建相册
  await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE_NEW_ALBUM);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 点击确认
  await dt.assertClick(TestConstants.DIALOG_BUTTON_SECOND);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.pressBack();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 相册页右上角四个点按钮
  await dt.assertClick(TestConstants.ALBUMS_ACTION_BUTTON_MORE);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 多选
  await dt.assertTextClick('多选');
  // 返回
  await driver.pressBack();
  Log.info(TAG, 'Task_004_Album_Test01 end');
}

/**
 * 测试多选及新建相册功能
 * 1、点击进入相册
 * 2、点击多选
 * 3、点击取消 ActionBarButtonCancel
 * 4、点击新建相册
 * 5、点击取消
 * 起点：相册页、终点：相册页
 */
async function Task_004_Album_Test02(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test02 start');
  let driver = dt.driver;
  // 相册页右上角四个点按钮
  await dt.assertClick(TestConstants.ALBUMS_ACTION_BUTTON_MORE);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 多选
  await dt.assertClick(TestConstants.ALBUMS_ACTION_BUTTON_MORE_MULTI_SELECTED);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 左上角×号
  await dt.assertClick('ActionBarButtonCancel');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 加号 新建相册
  await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE_NEW_ALBUM);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 取消
  await dt.assertClick(TestConstants.DIALOG_BUTTON_FIRST);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'Task_004_Album_Test02 end');
}

/**
 * 测试长按删除相册功能
 * 1、预制新建相册
 * 2、长按 某个相册
 * 3、点击 删除相册
 * 4、点击取消
 * 起点：相册页、终点：相册页
 */
async function Task_004_Album_Test03(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test03 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 点击新建相册
  await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE_NEW_ALBUM);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 确认新建相册
  await dt.assertClick(TestConstants.DIALOG_BUTTON_SECOND);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.pressBack();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 进入某个相册进行操作, 从后边相册开始尝试长按，前边都是系统相册
  let componentIdsArr: Array<string> = [
    'AccessibilityAlbumStack_7',
    'AccessibilityAlbumStack_8',
    'AccessibilityAlbumStack_9',
    'AccessibilityAlbumStack_10',
    'AccessibilityAlbumStack_11',
    'AccessibilityAlbumStack_12']

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
      // 时间过短无法弹出菜单项
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
      if (await driver.findComponent(ON.id('Album_LongPress_DeleteAlbum'))) {
        await dt.assertClick('Album_LongPress_DeleteAlbum');
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
        // 取消删除
        await dt.assertClick(TestConstants.DIALOG_BUTTON_FIRST);
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      }
      break;
    }
  }
  Log.info(TAG, 'Task_004_Album_Test03 end');
}

/**
 * 相册页大图预览模式测试
 * 1、点击第四个相册
 * 2、点击右上角多选模式进入选择模式
 * 3、选择第一张图片
 * 4、点击第一张图片的预览按钮，进入预览模式
 * 5、点击右侧按钮取消选择
 * 6、双击放大图片
 * 7、点击返回键返回相册选择模式
 * 起点：相册页，终点：相册页
 */
async function Task_004_Album_Test04(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test04 start');
  let driver = dt.driver;
  // 进入某个相册进行操作
  let componentIdsArr: Array<string> = [
    'AccessibilityAlbumStack_4',
    'AccessibilityAlbumStack_5',
    'AccessibilityAlbumStack_6',
    'AccessibilityAlbumStack_7',
    'AccessibilityAlbumStack_8',
    'AccessibilityAlbumStack_9'];
  for (let i = 0; i < componentIdsArr.length; i++) {
    const button1 = await driver.findComponent(ON.id(componentIdsArr[i]));
    if (!button1) {
      // 不存在则跳过该相册
      continue;
    }
    await button1.click();
    // 【多选按钮】用于确认是否有图片存在
    const button2 = await driver.findComponent(ON.text('多选'));
    if (!button2) {
      // 不存在则跳过该相册 -> 没图片
      continue;
    }
    await button2.click();

    Log.info(TAG, `${componentIdsArr[i]} multiSelectedBtn click`);
    // 多选模式下大图预览->点击第一张图片进行大图预览
    const picture = await driver.findComponent(ON.id('photoGridView_gird_0'));
    if (!picture) {
      return;
    }
    let rect: Rect = await picture.getBounds();
    let point: Point = await picture.getBoundsCenter();

    // 点击图片左上角区域可进入大图预览
    await driver.click(Math.round(point.x - (rect.right - rect.left) / 4), Math.round(point.y + (rect.top - rect.bottom) / 4));
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

    if (await driver.findComponent(ON.id('AccessibilityComponentMaterialSelect'))) {
      Log.info(TAG, 'AccessibilityComponentMaterialSelect click');
      // 预览页右上角的√
      await dt.assertClick('ActionBarButtonMaterialSelect');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, 'actionBarButtonSelected clicked');
      // 双击图片
      await driver.doubleClick(point.x, point.y);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      // 左上角返回按钮
      await driver.pressBack();
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, 'actionBarButtonBack clicked');
      // 左上角×按钮
      await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_CANCEL);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, 'ActionBarButtonCancel clicked');
      // 左上角返回按钮，退出该相册，进入到相册页
      await driver.pressBack();
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, 'actionBarButtonBack clicked');
    }
    break;
  }
  Log.info(TAG, 'Task_004_Album_Test04 end');
}

/**
 * 相册页选择操作测试
 * 1、点击全选
 * 2、再次点击取消全选
 * 3、点击更多
 * 4、点击空白处关闭更多弹窗
 * 5、点击第一张图片，选中
 * 起点：相册页，终点：相册页
 */
async function Task_004_Album_Test05(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test05 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 进入某个相册进行操作
  let componentIdsArr: Array<string> = [
    'AccessibilityAlbumStack_4',
    'AccessibilityAlbumStack_5',
    'AccessibilityAlbumStack_6',
    'AccessibilityAlbumStack_7',
    'AccessibilityAlbumStack_8',
    'AccessibilityAlbumStack_9'];
  for (let i = 0; i < componentIdsArr.length; i++) {
    const button1 = await driver.findComponent(ON.id(componentIdsArr[i]));
    if (!button1) {
      // 不存在则跳过该相册
      continue;
    }
    await button1.click();
    // 【多选按钮】用于确认是否有图片存在
    const button2 = await driver.findComponent(ON.text('多选'));
    if (!button2) {
      // 不存在则跳过该相册
      continue;
    }
    await button2.click();
    Log.info(TAG, 'multiSelectedBtn click');

    // 全选
    await dt.assertTextClick('全选');
    Log.info(TAG, 'toolBarButtonSelectAll clicked');
    // 反全选
    await dt.assertTextClick('取消全选');
    Log.info(TAG, 'toolBarButtonSelectAll1 clicked');
    // 点击第一张图片
    await dt.assertClick('Selector_0');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击右下角更多按钮
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'toolBarButtonMore clicked');
    // 点击返回 关闭ToolBarButtonMore
    await driver.pressBack();
    Log.info(TAG, 'toolBarButtonMore closed');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 左上角×按钮
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_CANCEL);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'ActionBarButtonCancel clicked');
    // 左上角返回按钮，退出该相册，进入到相册页
    await driver.pressBack();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'actionBarButtonBack clicked');
    break;
  }
  Log.info(TAG, 'Task_004_Album_Test05 end');
}

/**
 * 相册页测试移动功能
 * 1、点击更多
 * 2、点击从当前相册移除
 * 3、点击取消
 * 4、再次点击更多
 * 5、点击从当前相册移除
 * 6、点击移除
 * 起点：相册页， 终点：相册页
 */
async function Task_004_Album_Test06(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test06 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 进入某个相册进行操作
  let componentIdsArr: Array<string> = [
    'AccessibilityAlbumStack_4',
    'AccessibilityAlbumStack_5',
    'AccessibilityAlbumStack_6',
    'AccessibilityAlbumStack_7',
    'AccessibilityAlbumStack_8',
    'AccessibilityAlbumStack_9'];
  for (let i = 0; i < componentIdsArr.length; i++) {
    const button1 = await driver.findComponent(ON.id(componentIdsArr[i]));
    if (!button1) {
      // 不存在则跳过该相册
      continue;
    }
    await button1.click();
    // 【多选按钮】用于确认是否有图片存在
    const button2 = await driver.findComponent(ON.text('多选'));
    if (!button2) {
      // 不存在则跳过该相册
      continue;
    }
    await button2.click();
    Log.info(TAG, 'multiSelectedBtn click');

    // 点击第一张图片
    await dt.assertClick('Selector_0');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'gesture_0 clicked');
    // 点击更多
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'toolBarButtonMore clicked');
    // 移动到
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE_MOVE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 侧滑返回
    await driver.pressBack();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'removeDialogCancelButton clicked');
    // 点击更多
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 移动到
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE_MOVE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 移动到第一个相册
    await dt.assertClick('MediaOperationPageAlbum0');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await dt.clickIfExistByText('替换为新文件', TestConstants.DELAY_ONE_SECOND);
    // 左上角返回按钮，退出该相册，进入到相册页
    await driver.pressBack();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'actionBarButtonBack clicked');
    break;
  }
  Log.info(TAG, 'Task_004_Album_Test06 end');
}

/**
 * 图片相册测试多选->移动到->新建相册功能
 * 1、点击返回，退出相册大图浏览界面
 * 2、点击第四个相册
 * 3、点击右上角多选模式进入选择模式
 * 4、选中第一张图片
 * 5、点击更多
 * 6、点击添加到相册
 * 7、点击新建相册
 * 8、点击确认
 * 起点：相册页图片相册， 终点：相册页
 */
async function Task_004_Album_Test07(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test07 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 多次下拉寻找图片相册
  await dt.swipeUp();
  // 点击图片相册
  await dt.assertTextClick(TestConstants.ALBUM_NAME_TU_PIAN_NAME);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, '图片 clicked');
  // 进入图片后点击多选
  if (await driver.findComponent(ON.text('多选'))) {
    await dt.assertTextClick('多选');
    Log.info(TAG, 'multiSelectedBtn click');
    // 默认至少有两张图片
    await dt.assertClick('Selector_0');
    await dt.assertClick('Selector_1');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'gesture_0 clicked');
    // 点击右下角更多按钮
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'toolBarButtonMore clicked');
    // 移动到
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE_MOVE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'toolBarPopupBuilderTextOfAdd clicked');
    // 点击右上角＋新建相册
    await dt.assertClick('ActionBarButtonNewAlbum');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'actionBarButtonNew clicked');
    // 确认新建相册
    await dt.assertClick(TestConstants.DIALOG_BUTTON_SECOND);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'newAlbumDialogConfirmButton clicked');
    // 左上角返回按钮，退出该相册，进入到相册页
    await driver.pressBack();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'actionBarButtonBack clicked');
  }
  Log.info(TAG, 'Task_004_Album_Test07 end');
}

/**
 * 【图片】相册点击图片测试移动到功能
 * 1、点击右上角多选模式进入选择模式
 * 2、选中第一张图片
 * 3、点击更多
 * 4、点击添加到相册
 * 5、点击已有的第一个相册
 * 起点：相册页图片相册， 终点：相册页
 */
async function Task_004_Album_Test08(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test08 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 多次下拉寻找图片相册
  await dt.swipeUp();
  // 点击图片相册
  await dt.assertTextClick(TestConstants.ALBUM_NAME_TU_PIAN_NAME);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, '图片 clicked');
  // 进入图片后点击多选
  if (await driver.findComponent(ON.text('多选'))) {
    // 点击多选
    await dt.assertTextClick('多选');
    Log.info(TAG, 'multiSelectedBtn click');
    // 点击第一个图片
    await dt.assertClick('Selector_0');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'gesture_0 clicked');
    // 更多
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'toolBarButtonMore clicked');
    // 移动到
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE_MOVE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'toolBarPopupBuilderTextOfAdd clicked');
    // 移动到第一个相册
    await dt.assertClick('MediaOperationPageAlbum0');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await dt.clickIfExistByText('替换为新文件', TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'mediaOperationPageAlbum0 clicked');
    // 从该相册返回
    await driver.pressBack();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  }
  Log.info(TAG, 'Task_004_Album_Test08 end');
}

/**
 * 图片相册->多选->删除功能测试
 * 1、点击返回
 * 2、点击第四个相册
 * 3、点击右上角多选模式进入选择模式
 * 4、选择第一张图片
 * 4、点击删除
 * 5、点击取消
 * 6、点击删除
 * 7、点击删除，图片删除
 * 8、点击返回
 * 起点：相册页，终点：相册页
 */
async function Task_004_Album_Test09(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test09 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 多次下拉寻找图片相册
  await dt.swipeUp();
  // 点击图片相册
  await dt.assertTextClick(TestConstants.ALBUM_NAME_TU_PIAN_NAME);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, '图片 clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 进入图片后点击多选
  if (await driver.findComponent(ON.text('多选'))) {
    // 点击多选
    await dt.assertTextClick('多选');
    // 点击第一个图片
    await dt.assertClick('Selector_0');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击右下角删除按钮
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_DELETE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 取消删除
    await dt.assertClick(TestConstants.DIALOG_BUTTON_FIRST);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击右下角删除按钮
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_DELETE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 确认删除按钮
    await dt.assertClick(TestConstants.DIALOG_BUTTON_SECOND);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击左上角返回按钮退出图片相册
    await driver.pressBack();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  }
  Log.info(TAG, 'Task_004_Album_Test09 end');
}

/**
 * 相册页 -> 多选 -> 删除相册 功能测试
 * 1、长按新建相册，进入相册选择模式(点击菜单--》点击多选)
 * 3、点击删除
 * 4、点击取消
 * 取消之后不再删除相册
 * 起点：相册页，终点：相册页
 */
async function Task_004_Album_Test10(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test10 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick('TabAlbums');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 下拉
  await dt.swipeUp();
  // 右上角四个点按钮
  await dt.assertClick(TestConstants.ALBUMS_ACTION_BUTTON_MORE);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 多选
  await dt.assertTextClick('多选');
  let album = await driver.findComponent(ON.text('新建相册', MatchPattern.CONTAINS));
  // 选中某个相册进行测试
  if (album) {
    await album.click();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击删除相册
    await dt.assertTextClick('删除相册');
    // 点击取消按钮
    await dt.assertClick(TestConstants.DIALOG_BUTTON_FIRST);
    Log.info(TAG, 'toolBarButtonDelete1 clicked');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  }
  // 点击左上角×号返回按钮
  await dt.assertClick('ActionBarButtonCancel');
  Log.info(TAG, 'ActionBarButtonCancel clicked');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'Task_004_Album_Test10 end');
}

/**
 * 视频操作：播放、暂停播放、收藏、取消收藏功能测试
 * 起点：相册页， 终点：相册页
 */
async function Task_004_Album_Test11(dt: Dt) {
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 下拉
  await dt.swipeUp();
  // 如果视频相册存在则进行如下操作
  if (await driver.findComponent(ON.text('视频'))) {
    await dt.assertTextClick('视频');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击第一个视频
    await dt.assertClick('photoGridView_gird_0');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'gesture_0 clicked');
    try {
      // 如果视频太短则会立马播放完成，则没有下述操作
      if (await driver.findComponent(ON.id('VideoPlayButton'))) {
        await dt.assertClick('VideoPlayButton');
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND / 2);
        Log.info(TAG, 'VideoPlayButton clicked');
        // 点击收藏按钮
        await dt.assertClick('ToolBarButtonFavor');
        Log.info(TAG, 'ToolBarButtonFavor clicked');
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      }
      // 如果视频太短则会立马播放完成，则没有下述操作
      if (await driver.findComponent(ON.id('ToolBarButtonFavor'))) {
        // 点击取消收藏按钮
        await dt.assertClick('ToolBarButtonFavor');
        Log.info(TAG, 'ToolBarButtonFavor clicked');
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      }
    } catch (e) {
      Log.error(TAG, `video time too short, stack ${e?.stack}`);
    }
    // 点击左上角返回按钮退出该视频播放编辑页
    await dt.assertClick('More_Image_Back');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击左上角返回按钮退出视频相册
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_BACK);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  }
  Log.info(TAG, 'Task_004_Album_Test11 end');
}

/**
 * 视频操作：播放、暂停播放、静音、取消静音功能测试
 * 起点：相册页， 终点：相册页
 */
async function Task_004_Album_Test12(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test12 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 下拉
  await dt.swipeUp();
  // 如果视频相册存在则进行如下操作
  if (await driver.findComponent(ON.text('视频'))) {
    await dt.assertTextClick('视频');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击第一个视频
    await dt.assertClick('photoGridView_gird_0');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'gesture_0 clicked');
    // 点击视频播放按钮, 后不再判断是否有静音按钮，存在时间差导致判断时有，点击时无
    if (await driver.findComponent(ON.id('VideoPlayButton'))) {
      await dt.assertClick('VideoPlayButton');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, 'VideoPlayButton clicked');
    }
    try {
      // 如果视频太短则会立马播放完成，则没有下述操作
      if (await driver.findComponent(ON.id('ToolBarButtonsoundFilled'))) {
        // 点击静音按钮
        await dt.assertClick('ToolBarButtonsoundFilled');
        Log.info(TAG, 'ToolBarButtonsoundFilled clicked');
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      }
      // 如果视频太短则会立马播放完成，则没有下述操作
      if (await driver.findComponent(ON.id('ToolBarButtonsound_off_filled'))) {
        // 静音后点击开启音量按钮
        await dt.assertClick('ToolBarButtonsound_off_filled');
        Log.info(TAG, 'ToolBarButtonsound_off_filled clicked');
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      }
    } catch (e) {
      Log.error(TAG, `video time too short, stack ${e?.stack}`);
    }
    // 点击左上角返回按钮退出该视频播放编辑页
    await dt.assertClick('More_Image_Back');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击左上角返回按钮退出视频相册
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_BACK);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'Task_004_Album_Test12 end');
  }
}

/**
 * 针对视频进行操作: 移动到新建相册，视频双击、单击操作测试
 * 起点：相册页，终点：相册页
 */
async function Task_004_Album_Test13(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test13 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  // 下拉
  await dt.swipeUp();
  // 如果视频相册存在则进行如下操作
  if (await driver.findComponent(ON.text('视频'))) {
    await dt.assertTextClick('视频');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击第一个视频
    const video = await driver.findComponent(ON.id('photoGridView_gird_0'));
    await video.click();
    let point: Point = await video.getBoundsCenter();

    Log.info(TAG, 'video_0 clicked');
    // 视频相册右上角四个点更多按钮
    await dt.assertClick('More_Image_More');
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    // 存在更多按钮点击失败问题，故作此判断
    if (await driver.findComponent(ON.id('ActionBarButton_Text_Move'))) {
      // 移动到
      await dt.assertClick('ActionBarButton_Text_Move');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
      // 新建相册
      await dt.assertClick('ActionBarButtonNewAlbum');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
      // 确认移动到新建相册
      await dt.assertClick('advanced_dialog_button_1');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }
    // 视频相册右上角更多按钮
    await dt.assertClick('More_Image_More');
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    // 点击详细信息
    await dt.assertClick('ActionBarButton_Text_Info');
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    // 点击返回
    await driver.pressBack();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 双击视频
    await driver.doubleClick(point.x, point.y);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 双击视频
    await driver.doubleClick(point.x, point.y);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 单击视频
    await driver.click(point.x, point.y);
    await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
    // 点击左上角返回按钮退出当前视频
    await dt.assertClick('More_Image_Back');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'pressBack clicked');
    // 点击左上角返回按钮退出视频相册
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_BACK);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'pressBack clicked');
  }
  Log.info(TAG, 'Task_004_Album_Test13 end');
}

/**
 * 视频编辑、分享功能测试
 * 起点：相册页，终点：相册页
 */
async function Task_004_Album_Test14(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test14 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  // 下拉
  await dt.swipeUp();
  // 如果视频相册存在则进行如下操作
  if (await driver.findComponent(ON.text('视频'))) {
    await dt.assertTextClick('视频');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击第一个视频
    await dt.assertClick('photoGridView_gird_0');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'gesture_0 clicked');
    await dt.assertClick('ToolBarButtonShare');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 侧滑取消分享-【取消按钮key缺失】
    await driver.pressBack();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击编辑按钮
    await dt.assertClick('ToolBarButtonEdit');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击左上角返回按钮退出编辑
    await dt.assertClick('videoEditor_topToolBar_back');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击左上角返回按钮退出当前视频
    await dt.assertClick('More_Image_Back');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'pressBack clicked');
    // 点击左上角返回按钮退出视频相册
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_BACK);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'pressBack clicked');
  }
  Log.info(TAG, 'Task_004_Album_Test14 end');
}

/**
 * 1.承接上例，判断新建相册里面有一个视频还是有一个照片加一个视频(当前直接删除相册会把里面内容删掉，重新创建同名又会将内容恢复)
 * 2.将视频返回到屏幕录制
 * 3.删除相册
 * 起点：相册页，终点：相册页
 */
async function Task_004_Album_Test15(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test15 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 下拉
  await dt.swipeUp();
  let components = await driver.findComponents(ON.text('新建相册', MatchPattern.CONTAINS));
  if (!components || !components.length) {
    dt.log.i('no new albums');
    return;
  }
  // 选择第一个新建相册测试删除功能
  await components[0].click();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 如果第二个视频或者图片存在
  if (await driver.findComponent(ON.id('photoGridView_gird_1'))) {
    // 多选
    await dt.assertTextClick('多选');
    // 选中该视频或者图片
    await dt.assertClick('Selector_1');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 右下角更多
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 移动到
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE_MOVE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 移动到第三个相册
    await dt.assertClick('MediaOperationPageAlbum2');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 兼容重复图片
    await dt.clickIfExistByText('替换为新文件', TestConstants.DELAY_ONE_SECOND);
    // 如果第一个视频或者图片存在
  } else if (await driver.findComponent(ON.id('photoGridView_gird_0'))) {
    // 多选
    await dt.assertTextClick('多选');
    // 选中该视频或者图片
    await dt.assertClick('Selector_0');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 右下角更多
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 移动到
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE_MOVE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 移动到第三个相册
    await dt.assertClick('MediaOperationPageAlbum2');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 兼容重复图片
    await dt.clickIfExistByText('替换为新文件', TestConstants.DELAY_ONE_SECOND);
  }
  // 点击返回按钮
  await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_BACK);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 点击照片按钮
  await dt.assertClick('TabPhotos');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 点击相册按钮
  await dt.assertClick('TabAlbums');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'Task_004_Album_Test15 end');
}

/**
 * Task_004_Album_Test12 删除过图片
 * 1、点击最近删除
 * 2、点击右上角多选模式进入选择模式
 * 3、点击全选
 * 4、点击取消全选
 * 5、点击第一张图片
 * 6、点击恢复
 * 起点：相册页，终点：相册页
 */
async function Task_004_Album_Test16(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test16 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.swipeDown();
  // 点击最近删除相册
  let album = await driver.findComponent(ON.text('最近删除', MatchPattern.CONTAINS));
  await album.click();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'deleteAlbum clicked');
  // 如果多选按钮存在，则进行如下操作，不存在则没有最近删除的视频或图片
  if (await driver.findComponent(ON.text('多选'))) {
    // 多选
    await dt.assertTextClick('多选');
    Log.info(TAG, 'multiSelectedBtn click');
    // 全选
    await dt.assertTextClick('全选');
    Log.info(TAG, 'toolBarButtonSelectAll clicked');
    // 反全选
    await dt.assertTextClick('取消全选');
    Log.info(TAG, 'toolBarButtonSelectAll clicked');
    // 点击第一个被删除项
    await dt.assertClick('Selector_0');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'gesture_01 clicked');
    // 点击恢复
    await dt.assertClick('ToolBarButtonRecover');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'toolBarButtonRecover clicked');
  }
  // 退出最近删除相册
  await driver.pressBack();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'actionBarButtonBack clicked');
  Log.info(TAG, 'Task_004_Album_Test16 end');
}

/**
 * 测试用例
 * 1、点击右上角多选模式进入选择模式
 * 2、选中第一张图片
 * 3、点击删除
 * 4、点击取消
 * 5、点击删除
 * 6、点击永久删除
 * 起点：相册页，终点：相册页
 */
async function Task_004_Album_Test17(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test17 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.swipeDown();
  // 点击最近删除相册
  let album = await driver.findComponent(ON.text('最近删除', MatchPattern.CONTAINS));
  await album.click();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'deleteAlbum clicked');
  // 右上角多选按钮存在则还有被删除的图片或者视频
  if (await driver.findComponent(ON.text('多选'))) {
    // 点击多选
    await dt.assertTextClick('多选');
    Log.info(TAG, 'multiSelectedBtn click');
    // 选择第一项
    await dt.assertClick('Selector_0');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'ImageGesture_0 clicked');
    // 点击删除
    await dt.assertClick('ToolBarButtonDelete');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'toolBarButtonDelete clicked');
    // 取消
    await dt.assertClick(TestConstants.DIALOG_BUTTON_FIRST);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'deleteDialogCancelButton clicked');
    // 点击删除
    await dt.assertClick('ToolBarButtonDelete');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'toolBarButtonDelete1 clicked');
    // 点击永久删除
    await dt.assertClick(TestConstants.DIALOG_BUTTON_SECOND);
    await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    Log.info(TAG, 'deleteDialogConfirmButton clicked');
  }
  // 退出最近删除相册
  await driver.pressBack();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'actionBarButtonBack clicked');
  Log.info(TAG, 'Task_004_Album_Test17 end');
}

/**
 * 测试用例
 * 1、点击清空最近删除 ClearRecycleButton
 * 2、点击取消 DeleteDialogCancelButton
 * 3、点击清空最近删除
 * 4、点击清空 DeleteDialogConfirmButton
 * 5、点击返回
 * 起点：相册页，终点：相册页
 */
async function Task_004_Album_Test18(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test18 start');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.swipeDown();
  // 点击最近删除相册
  let album = await driver.findComponent(ON.text('最近删除', MatchPattern.CONTAINS));
  await album.click();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'deleteAlbum clicked');
  // 清空最近删除按钮存在则还有视频或者图片
  if (await driver.findComponent(ON.id('ClearRecycleButton'))) {
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 点击清空最近删除
    await dt.assertClick('ClearRecycleButton');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'clearRecycleButton clicked');
    // 取消
    await dt.assertClick(TestConstants.DIALOG_BUTTON_FIRST);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'deleteDialogCancelButton clicked');
    // 点击清空最近删除
    await dt.assertClick('ClearRecycleButton');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'clearRecycleButton1 clicked');
    // 永久删除
    await dt.assertClick(TestConstants.DIALOG_BUTTON_SECOND);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    Log.info(TAG, 'deleteDialogConfirmButton clicked');
  }
  // 退出最近删除相册
  await driver.pressBack();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'actionBarButtonBack clicked');
  Log.info(TAG, 'Task_004_Album_Test18 end');
}

// 删除本次下拉可见的所有新建相册
async function Task_004_Album_Test19(dt: Dt) {
  Log.info(TAG, 'Task_004_Album_Test19 start');
  await dt.swipeUp();
  let driver = dt.driver;
  let components = await driver.findComponents(ON.text('新建相册', MatchPattern.CONTAINS));
  if (!components || !components.length) {
    dt.log.i('no new albums');
    return;
  }
  Log.info(TAG, 'Task_004_Album_Test20 001');
  // 选择第一个新建相册测试删除功能
  await components[0].click();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 相册里有图片或者视频
  if (await driver.findComponent(ON.text('多选'))) {
    // 多选
    await dt.assertTextClick('多选');
    // 选中第一个
    await dt.assertClick('Selector_0');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 右下角更多按钮
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 移动到
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE_MOVE);
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    // 移动到第一个相册
    await dt.assertClick('MediaOperationPageAlbum0');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await dt.clickIfExistByText('替换为新文件', TestConstants.DELAY_ONE_SECOND)
    Log.info(TAG, 'exit PhotoGridPage_GridItem0');
  }
  // 退出该相册
  await driver.pressBack();
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  Log.info(TAG, 'Task_004_Album_Test19 002');
  await deletNewAlbums();
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  Log.info(TAG, 'Task_004_Album_Test19 end');
}
