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
import { describe } from '@ohos/hypium';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { Driver, ON } from '@ohos.UiTest';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { SkipBootPage, StartPhotos, testClickById, startTask, loggedTask, endTask, swipeSearch, } from '../tools/steps';
import { PhotoType } from '../tools/constants';

const TAG: string = `${TestConstants.TAG}PhotoXTStyleEditorTest`;

export default function photoXTStyleEditorTest(): void {
  describe('PhotoXTStyleEditorTest', () => {
    it('Task_05_XTStyleEdit_start_photo', TestConstants.TEST_LEVEL_ZERO, async (dt: Dt): Promise<void> => {
      await StartPhotos();
      await SkipBootPage();
    });
    it('Task_05_XTStyleEdit_Test01_1', TestConstants.TEST_LEVEL_ZERO,
      startTask(Task_05_XTStyleEdit_Test01_1, PhotoType.XTStyleEdit));
    it('Task_05_XTStyleEdit_XMAGE', TestConstants.TEST_LEVEL_ZERO,
      startTask(Task_05_XTStyleEdit_XMAGE, PhotoType.XTStyleEdit));
    it('Task_05_XTStyleEdit_Test01_2', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_05_XTStyleEdit_Test01_2));
    it('Task_05_XTStyleEdit_Test01_3', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_05_XTStyleEdit_Test01_3));
    it('Task_05_XTStyleEdit_Test01_4', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_05_XTStyleEdit_Test01_4));
    it('Task_05_XTStyleEdit_Test01_5', TestConstants.TEST_LEVEL_ZERO, endTask(Task_05_XTStyleEdit_Test01_5));
  });
}

/**
 * 1、点击编辑按钮，点击个性风格
 * 2、点击设置关闭个性风格
 * 3、点击设置标准
 * 4、点击设置胶片风
 * 5、点击设置浪漫风
 * 6、点击设置动漫风
 * 7、长按对比查看对比效果
 * 8、点击AI编辑按钮，点击弹窗中取消按钮
 * 9、点击涂鸦编辑按钮，点击弹窗中取消按钮
 * 10、点击保存
 */
async function Task_05_XTStyleEdit_Test01_1(driver: Driver) {
  // 点击个性风格
  const filterBtn = await driver.findComponent(ON.text('个性风格'));
  if (filterBtn) {
    await filterBtn.click();
  }
  // 点击关闭个性风格效果
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await testClickById(driver, 'stylesType_item_noConfig',
    'stylesType_item_noConfig clicked');

  // 点击设置标准
  await testClickById(driver, 'petalClip_imageSelection_item_text_1',
    'petalClip_imageSelection_item_text_1 clicked');

  // 点击胶片风
  await testClickById(driver, 'petalClip_imageSelection_item_text_2',
    'petalClip_imageSelection_item_text_2 clicked');

  // 点击浪漫风
  await testClickById(driver, 'petalClip_imageSelection_item_text_3',
    'petalClip_imageSelection_item_text_3 clicked');

}

/**
 * XMAGE 风格
 * @param driver
 */
async function Task_05_XTStyleEdit_XMAGE(driver: Driver) {
  // 点击个性风格
  const filterBtn = await driver.findComponent(ON.text('XMAGE 风格'));
  if (filterBtn) {
    await filterBtn.click();
  }
  // 点击关闭个性风格效果
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await testClickById(driver, 'stylesType_item_noConfig',
    'stylesType_item_noConfig clicked');

  // 点击设置标准
  await testClickById(driver, 'petalClip_imageSelection_item_text_1',
    'petalClip_imageSelection_item_text_1 clicked');

  // 点击胶片风
  await testClickById(driver, 'petalClip_imageSelection_item_text_2',
    'petalClip_imageSelection_item_text_2 clicked');

  // 点击浪漫风
  await testClickById(driver, 'petalClip_imageSelection_item_text_3',
    'petalClip_imageSelection_item_text_3 clicked');
}

async function Task_05_XTStyleEdit_Test01_2(driver: Driver) {
  // 点击动漫风并进入调色板
  await testClickById(driver, 'petalClip_imageSelection_item_text_4',
    'petalClip_imageSelection_item_text_4 clicked', true);

  // 点击调色盘上的6，5点
  await testClickById(driver, 'SingleMatrixDot_6_5', 'SingleMatrixDot_6_5 clicked', true);

  // 滑动光影bar
  await driver.swipe(1097, 2370, 1097, 2000);

  // 切换模板
  await testClickById(driver, 'XTStyleTemplateDotView_1', 'XTStyleTemplateDotView_1 clicked', true);

  // 点击恢复按钮
  await testClickById(driver, 'ResetButton', 'ResetButton clicked', true);

  // 点击undo/redo
  await xtStyleUndoRedoTest(driver);

}

async function Task_05_XTStyleEdit_Test01_3(driver: Driver) {
  // 展开数字选择器并通过滑动改变参数
  await openAndCloseCustomFilterDashboard(driver);

  // 点击回退按钮
  await testClickById(driver, 'BackButton', 'BackButton clicked', true);

  // 点击缩略展开调色盘
  await testClickById(driver, 'petalClip_imageSelection_item1', 'petalClip_imageSelection_item1 clicked', true);

  await testClickById(driver, 'BackButton', 'BackButton clicked', true);
}

async function Task_05_XTStyleEdit_Test01_4(driver: Driver) {
  // 进入并退出涂鸦
  await enterAndQuitStylus(driver);

  // 点击撤销按钮
  await testClickById(driver, 'petalClip_topToolBar_undo', 'petalClip_topToolBar_undo clicked');

  // 点击恢复按钮
  await testClickById(driver, 'petalClip_topToolBar_redo', 'petalClip_topToolBar_redo clicked');
}

async function Task_05_XTStyleEdit_Test01_5(driver: Driver) {
  // 长按对比
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.assertComponentExist(ON.id('petalClip_VideoTrimTool_compareButton'));
  let compareButtonEdit = await driver.findComponent(ON.id('petalClip_VideoTrimTool_compareButton'));
  await compareButtonEdit.longClick();
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, 'CompareEditButton clicked');

  // 点击AI编辑按钮
  await testClickById(driver, 'petalclip_AiRetouch', 'petalclip_AiRetouch clicked');

  // 点击弹窗中的取消按钮
  await testClickById(driver, 'advanced_dialog_button_0', 'advanced_dialog_button_0 clicked');

  // 点击保存
  await testClickById(driver, 'petalClip_topToolBar_save', 'petalClip_topToolBar_save clicked');
  const saveBtn = await driver.findComponent(ON.text('覆盖原图'));
  if (saveBtn) {
    await saveBtn.click();
  }
  await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
}

async function enterAndQuitStylus(driver: Driver) {
  await swipeSearch(ON.id('petalClip_bottomToolBar_TabsBar'),
    ON.id('petalClip_bottomToolBar_image_7'), 'right');
  await testClickById(driver, 'petalClip_bottomToolBar_image_7', 'petalClip_bottomToolBar_image_7 clicked');
  await testClickById(driver, 'advanced_dialog_button_0', 'advanced_dialog_button_0 clicked');
  await swipeSearch(ON.id('petalClip_bottomToolBar_TabsBar'),
    ON.id('petalClip_bottomToolBar_image_7'), 'right');
  await testClickById(driver, 'petalClip_bottomToolBar_image_7', 'petalClip_bottomToolBar_image_7 clicked');
  await testClickById(driver, 'advanced_dialog_button_1', 'advanced_dialog_button_1 clicked');
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  await testClickById(driver, 'petalClip_stylus_cancel', 'petalClip_stylus_cancel clicked');
}

async function xtStyleUndoRedoTest(driver: Driver) {
  // 点击调色盘上的点
  await testClickById(driver, 'SingleMatrixDot_0_0', 'SingleMatrixDot_0_0 clicked');
  await testClickById(driver, 'SingleMatrixDot_1_1', 'SingleMatrixDot_1_1 clicked');
  await testClickById(driver, 'SingleMatrixDot_2_2', 'SingleMatrixDot_2_2 clicked');
  await testClickById(driver, 'SingleMatrixDot_3_3', 'SingleMatrixDot_3_3 clicked');
  await testClickById(driver, 'SingleMatrixDot_4_4', 'SingleMatrixDot_4_4 clicked');
  await testClickById(driver, 'SingleMatrixDot_5_5', 'SingleMatrixDot_5_5 clicked');
  await testClickById(driver, 'petalClip_topToolBar_undo', 'petalClip_topToolBar_undo clicked');
  await testClickById(driver, 'petalClip_topToolBar_undo', 'petalClip_topToolBar_undo clicked');
  await testClickById(driver, 'petalClip_topToolBar_undo', 'petalClip_topToolBar_undo clicked');
  await testClickById(driver, 'petalClip_topToolBar_redo', 'petalClip_topToolBar_redo clicked');
  await testClickById(driver, 'petalClip_topToolBar_redo', 'petalClip_topToolBar_redo clicked');
  await testClickById(driver, 'petalClip_topToolBar_redo', 'petalClip_topToolBar_redo clicked');
}

async function openAndCloseCustomFilterDashboard(driver: Driver) {
  await testClickById(driver, 'dial', 'click dial button');
  await driver.swipe(350, 2270, 350, 2100);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.swipe(750, 2270, 750, 2100);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.swipe(1100, 2270, 1100, 2100);
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await testClickById(driver, 'XTStyleMatrixControllerView', 'click dial button');
}