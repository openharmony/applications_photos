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
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { Driver, ON } from '@ohos.UiTest';
import {
  assertClickById,
  endTask,
  loggedTask,
  startTask,
  testClickById
} from '../tools/steps';
import { UiComponentIdOfEditor } from '../util/UiComponentIdOfEditor';
import { PhotoType } from '../tools/constants';

const TAG: string = `${TestConstants.TAG}ImageEditorUiBaseTest`;

async function EnterAIEditor(driver: Driver) {
  // 点击AI编辑按钮-切到AI编辑
  await testClickById(driver, 'petalclip_AiRetouch', 'petalclip_AiRetouch clicked');
  let confirmBtn = await driver.findComponent(ON.id('advanced_dialog_button_1'));
  if (confirmBtn) {
    await confirmBtn.click();
    expect(confirmBtn).assertInstanceOf('Object');
  }
}

/*
 * 本测试套，用来保证编辑场景下，每个component都有key，并且key不缺失，以及clickable/enable状态正确
 * 如果代码中修改component key id，则需要同步更新对应的用例
 */
export default function ImageEditorUiBaseTest(): void {
  describe('ImageEditorUiBaseTest', () => {
    it('ImageEditorUiBaseTest_001', TestConstants.TEST_LEVEL_TWO, startTask(async (driver: Driver) => {
      // 编辑-返回
      Log.info(TAG, 'ImageEditorUiBaseTest_001 编辑-返回 start');

      Log.info(TAG, '预期结果1、存在petalClip_topToolBar_back对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.TOP_BACK));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_001 end');
    }, PhotoType.StaticImage));

    it('ImageEditorUiBaseTest_002', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-右上角'编辑'的文字提示
      Log.info(TAG, 'ImageEditorUiBaseTest_002 start');

      Log.info(TAG, '预期结果1、存在petalClip_topToolBar_edit对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.TOP_EDIT));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      Log.info(TAG, 'ImageEditorUiBaseTest_002 end');
    }));

    it('ImageEditorUiBaseTest_003', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-保存
      Log.info(TAG, 'ImageEditorUiBaseTest_003 start');

      Log.info(TAG, '预期结果1、存在petalClip_topToolBar_save对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.TOP_SAVE));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertFalse();

      Log.info(TAG, 'ImageEditorUiBaseTest_003 end');
    }));

    it('ImageEditorUiBaseTest_004', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-裁剪-旋转
      Log.info(TAG, 'ImageEditorUiBaseTest_004 start');

      Log.info(TAG, '预期结果1、存在petalclip_CropTool_rotateBtn对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.CROP_TOOL_ROTATE_BTN));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_004 end');
    }));

    it('ImageEditorUiBaseTest_005', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-裁剪-旋转角度拖拽条
      Log.info(TAG, 'ImageEditorUiBaseTest_005 start');

      Log.info(TAG, '预期结果1、存在petalclip_CropTool_rulerScroller对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.CROP_TOOL_RULER_SCROLLER));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_005 end');
    }));

    it('ImageEditorUiBaseTest_006', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-裁剪-旋转角度拖拽条
      Log.info(TAG, 'ImageEditorUiBaseTest_006 start');

      Log.info(TAG, '预期结果1、存在petalclip_RulerBar_rulerScroller对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.RULER_BAR_RULER_SCROLLER));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      const isScrollable = await comp.isScrollable();
      expect(isScrollable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_006 end');
    }));

    it('ImageEditorUiBaseTest_007', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-裁剪-镜像
      Log.info(TAG, 'ImageEditorUiBaseTest_007 start');

      Log.info(TAG, '预期结果1、存在petalclip_CropTool_mirrorBtn对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.CROP_TOOL_MIRROR_BTN));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_007 end');
    }));

    it('ImageEditorUiBaseTest_008', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-裁剪-智能校正
      Log.info(TAG, 'ImageEditorUiBaseTest_008 start');

      Log.info(TAG, '预期结果1、存在cropTab_intelligentCorrection_off对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.CROP_TAB_INTELLIGENT_CORRECTION_OFF));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_008 end');
    }));

    it('ImageEditorUiBaseTest_009', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-裁剪-旋转
      Log.info(TAG, 'ImageEditorUiBaseTest_009 start');

      Log.info(TAG, '预期结果1、存在 cropTab_rotation_on 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.CROP_TAB_ROTATION_ON));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_009 end');
    }));

    it('ImageEditorUiBaseTest_010', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-裁剪-水平校正
      Log.info(TAG, 'ImageEditorUiBaseTest_010 start');

      Log.info(TAG, '预期结果1、存在 cropTab_rotation_on 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.CROP_TAB_HORIZONTAL_CORRECTION_OFF));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_010 end');
    }));

    it('ImageEditorUiBaseTest_011', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-裁剪-垂直校正
      Log.info(TAG, 'ImageEditorUiBaseTest_011 start');

      Log.info(TAG, '预期结果1、存在 cropTab_horizontalCorrection_off 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.CROP_TAB_VERTICAL_CORRECTION_OFF));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_011 end');
    }));

    it('ImageEditorUiBaseTest_012', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-裁剪-比例
      Log.info(TAG, 'ImageEditorUiBaseTest_012 start');

      Log.info(TAG, '预期结果1、存在 cropTab_ratio_off 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.CROP_TAB_RATIO_OFF));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_012 end');
    }));

    it('ImageEditorUiBaseTest_013', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-裁剪-AI修图
      Log.info(TAG, 'ImageEditorUiBaseTest_013 start');

      Log.info(TAG, '预期结果1、存在 petalclip_AiRetouch 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.AI_RETOUCH));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_013 end');
    }));

    it('ImageEditorUiBaseTest_014', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-裁剪-图标
      Log.info(TAG, 'ImageEditorUiBaseTest_014 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_image_1 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_CROP_IMG));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_014 end');
    }));

    it('ImageEditorUiBaseTest_015', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-裁剪-文字
      Log.info(TAG, 'ImageEditorUiBaseTest_015 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_text_1 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_CROP_TEXT));
      expect(comp).not().assertNull();

      const text = await comp.getText();
      expect(text).assertEqual('裁剪');

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_015 end');
    }));

    it('ImageEditorUiBaseTest_016', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-调节-图标
      Log.info(TAG, 'ImageEditorUiBaseTest_016 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_image_2 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_REGULATE_IMG));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_016 end');
    }));

    it('ImageEditorUiBaseTest_017', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-调节-文字
      Log.info(TAG, 'ImageEditorUiBaseTest_017 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_text_2 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_REGULATE_TEXT));
      expect(comp).not().assertNull();

      const text = await comp.getText();
      expect(text).assertEqual('调节');

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_017 end');
    }));

    it('ImageEditorUiBaseTest_018', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-滤镜-图标
      Log.info(TAG, 'ImageEditorUiBaseTest_018 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_image_4 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_FILTER_IMG));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_018 end');
    }));

    it('ImageEditorUiBaseTest_019', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-滤镜-文字
      Log.info(TAG, 'ImageEditorUiBaseTest_019 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_text_4 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_FILTER_TEXT));
      expect(comp).not().assertNull();

      const text = await comp.getText();
      expect(text).assertEqual('滤镜');

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_019 end');
    }));

    it('ImageEditorUiBaseTest_020', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-涂鸦-图标
      Log.info(TAG, 'ImageEditorUiBaseTest_020 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_image_7 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_GRAFFITI_IMG));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_020 end');
    }));

    it('ImageEditorUiBaseTest_021', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-涂鸦-文字
      Log.info(TAG, 'ImageEditorUiBaseTest_021 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_text_7 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_GRAFFITI_TEXT));
      expect(comp).not().assertNull();

      const text = await comp.getText();
      expect(text).assertEqual('涂鸦');

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_021 end');
    }));

    it('ImageEditorUiBaseTest_022', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-文字-图标
      Log.info(TAG, 'ImageEditorUiBaseTest_022 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_image_8 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_TEXT_IMG));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_022 end');
    }));

    it('ImageEditorUiBaseTest_023', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 编辑-文字-文字
      Log.info(TAG, 'ImageEditorUiBaseTest_023 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_text_8 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_TEXT_TEXT));
      expect(comp).not().assertNull();

      const text = await comp.getText();
      expect(text).assertEqual('文字');

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_023 end');
    }));

    it('ImageEditorUiBaseTest_024', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 裁剪整体
      Log.info(TAG, 'ImageEditorUiBaseTest_024 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_1 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_CROP));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_024 end');
    }));

    it('ImageEditorUiBaseTest_025', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 调节整体
      Log.info(TAG, 'ImageEditorUiBaseTest_025 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_2 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_REGULATE));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_025 end');
    }));

    it('ImageEditorUiBaseTest_026', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 滤镜整体
      Log.info(TAG, 'ImageEditorUiBaseTest_026 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_4 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_FILTER));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_026 end');
    }));

    it('ImageEditorUiBaseTest_027', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦整体
      Log.info(TAG, 'ImageEditorUiBaseTest_027 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_7 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_GRAFFITI));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_027 end');
    }));

    it('ImageEditorUiBaseTest_028', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 文字整体
      Log.info(TAG, 'ImageEditorUiBaseTest_028 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_8 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_TEXT));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_028 end');
    }));

    it('ImageEditorUiBaseTest_029', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-整体
      Log.info(TAG, 'ImageEditorUiBaseTest_029 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_9 对应的控件');
      await driver.swipe(957, 2562, 557, 2548);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_MOSAIC));

      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_029 end');
    }));

    it('ImageEditorUiBaseTest_030', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-图标
      Log.info(TAG, 'ImageEditorUiBaseTest_030 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_image_9 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_MOSAIC_IMG));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_030 end');
    }));

    it('ImageEditorUiBaseTest_031', TestConstants.TEST_LEVEL_TWO, endTask(async (driver: Driver) => {
      // 马赛克-文字
      Log.info(TAG, 'ImageEditorUiBaseTest_031 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_text_9 对应的控件');
      const comp = await driver.findComponent(ON.id(UiComponentIdOfEditor.BOTTOM_TOOL_BAR_MOSAIC_TEXT));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'ImageEditorUiBaseTest_031 end');
    }));
  });

  describe('ImageEditorUiBaseTest_Regulate_Test', () => {
    it('ImageEditorUiBaseTest_Regulate_001', TestConstants.TEST_LEVEL_TWO, startTask(async (driver: Driver) => {
      // 调节-一键调节
      Log.info(TAG, 'Regulate_001 start');

      Log.info(TAG, '预期结果1、存在 petalClip_AdjustItem_auto_false 对应的控件');
      await driver.swipe(557, 2562, 957, 2548);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      const button= await assertClickById('petalClip_bottomToolBar_2');
      expect(button).assertInstanceOf('Object');

      const comp = await driver.findComponent(ON.id('petalClip_AdjustItem_auto_false'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Regulate_001 end');
    }, PhotoType.StaticImage));

    it('ImageEditorUiBaseTest_Regulate_002', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 调节-曝光
      Log.info(TAG, 'Regulate_002 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_image_9 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_AdjustItem_exposure_false'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Regulate_002 end');
    }));

    it('ImageEditorUiBaseTest_Regulate_003', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 调节-高光
      Log.info(TAG, 'Regulate_003 start');

      Log.info(TAG, '预期结果1、存在 petalClip_AdjustItem_highlight_false 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_AdjustItem_highlight_false'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Regulate_003 end');
    }));

    it('ImageEditorUiBaseTest_Regulate_004', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 调节-阴影
      Log.info(TAG, 'Regulate_004 start');

      Log.info(TAG, '预期结果1、存在 petalClip_AdjustItem_shadow_false 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_AdjustItem_shadow_false'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Regulate_004 end');
    }));

    it('ImageEditorUiBaseTest_Regulate_005', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 调节-亮度
      Log.info(TAG, 'Regulate_005 start');

      Log.info(TAG, '预期结果1、存在 petalClip_AdjustItem_brightness_false 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_AdjustItem_brightness_false'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Regulate_005 end');
    }));

    it('ImageEditorUiBaseTest_Regulate_006', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 调节-对比度
      Log.info(TAG, 'Regulate_006 start');

      Log.info(TAG, '预期结果1、存在 petalClip_AdjustItem_contrast_false 对应的控件');
      await driver.swipe(1130, 2259, 55, 2250);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      const comp = await driver.findComponent(ON.id('petalClip_AdjustItem_contrast_false'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Regulate_006 end');
    }));

    it('ImageEditorUiBaseTest_Regulate_007', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 调节-亮部
      Log.info(TAG, 'Regulate_007 start');

      Log.info(TAG, '预期结果1、存在 petalClip_AdjustItem_brightzone_false 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_AdjustItem_brightzone_false'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Regulate_007 end');
    }));

    it('ImageEditorUiBaseTest_Regulate_008', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 调节-暗部
      Log.info(TAG, 'Regulate_008 start');

      Log.info(TAG, '预期结果1、存在 petalClip_AdjustItem_darkzone_false 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_AdjustItem_darkzone_false'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Regulate_008 end');
    }));

    it('ImageEditorUiBaseTest_Regulate_009', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 调节-饱和度
      Log.info(TAG, 'Regulate_009 start');

      Log.info(TAG, '预期结果1、存在 petalClip_AdjustItem_saturation_false 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_AdjustItem_saturation_false'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Regulate_009 end');
    }));

    it('ImageEditorUiBaseTest_Regulate_010', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 调节-自然饱和度
      Log.info(TAG, 'Regulate_010 start');

      Log.info(TAG, '预期结果1、存在 petalClip_AdjustItem_vibrance_false 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_AdjustItem_vibrance_false'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Regulate_010 end');
    }));

    it('ImageEditorUiBaseTest_Regulate_011', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 调节-色温
      Log.info(TAG, 'Regulate_011 start');

      Log.info(TAG, '预期结果1、存在 petalClip_AdjustItem_temperature_false 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_AdjustItem_temperature_false'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Regulate_011 end');
    }));

    it('ImageEditorUiBaseTest_Regulate_012', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 调节-色调
      Log.info(TAG, 'Regulate_012 start');

      Log.info(TAG, '预期结果1、存在 petalClip_AdjustItem_hue_false 对应的控件');
      await driver.swipe(1130, 2259, 55, 2250);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      const comp = await driver.findComponent(ON.id('petalClip_AdjustItem_hue_false'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Regulate_012 end');
    }));

    it('ImageEditorUiBaseTest_Regulate_013', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 调节-锐度
      Log.info(TAG, 'Regulate_013 start');

      Log.info(TAG, '预期结果1、存在 petalClip_AdjustItem_sharpness_false 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_AdjustItem_sharpness_false'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Regulate_013 end');
    }));

    it('ImageEditorUiBaseTest_Regulate_014', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 调节-暗角
      Log.info(TAG, 'Regulate_014 start');

      Log.info(TAG, '预期结果1、存在 petalClip_AdjustItem_vignette_false 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_AdjustItem_vignette_false'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Regulate_014 end');
    }));

    it('ImageEditorUiBaseTest_Regulate_015', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 调节-褪色
      Log.info(TAG, 'Regulate_015 start');

      Log.info(TAG, '预期结果1、存在 petalClip_AdjustItem_fade_false 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_AdjustItem_fade_false'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Regulate_015 end');
    }));

    it('ImageEditorUiBaseTest_Regulate_016', TestConstants.TEST_LEVEL_TWO, endTask(async (driver: Driver) => {
      // 调节-颗粒
      Log.info(TAG, 'Regulate_016 start');

      Log.info(TAG, '预期结果1、存在 petalClip_AdjustItem_grain_false 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_AdjustItem_grain_false'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Regulate_016 end');
    }));
  });


  describe('ImageEditorUiBaseTest_Filter_Test', () => {
    it('ImageEditorUiBaseTest_Filter_001', TestConstants.TEST_LEVEL_TWO, startTask(async (driver: Driver) => {
      // 滤镜-原图
      Log.info(TAG, 'Regulate_001 start');

      Log.info(TAG, '预期结果1、存在 petalClip_imageSelection_item000000000000000000 对应的控件');
      await driver.swipe(957, 2562, 557, 2548);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      const button= await assertClickById('petalClip_bottomToolBar_image_4');
      expect(button).assertInstanceOf('Object');

      const comp = await driver.findComponent(ON.id('petalClip_imageSelection_item000000000000000000'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Filter_001 end');
    }, PhotoType.StaticImage));

    it('ImageEditorUiBaseTest_Filter_002', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 滤镜-原图文本
      Log.info(TAG, 'Filter_002 start');

      Log.info(TAG, '预期结果1、存在 petalClip_imageSelection_item_text_000000000000000000 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_imageSelection_item_text_000000000000000000'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Filter_002 end');
    }));

    it('ImageEditorUiBaseTest_Filter_003', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 滤镜-经典
      Log.info(TAG, 'Filter_003 start');

      Log.info(TAG, '预期结果1、存在 petalClip_imageSelection_itemClassic 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_imageSelection_itemClassic'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Filter_003 end');
    }));

    it('ImageEditorUiBaseTest_Filter_004', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 滤镜-今典文本
      Log.info(TAG, 'Filter_004 start');

      Log.info(TAG, '预期结果1、存在 petalClip_imageSelection_item_text_Classic 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_imageSelection_item_text_Classic'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Filter_004 end');
    }));

    it('ImageEditorUiBaseTest_Filter_005', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 滤镜-灰调
      Log.info(TAG, 'Filter_005 start');

      Log.info(TAG, '预期结果1、存在 petalClip_imageSelection_itemMoody 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_imageSelection_itemMoody'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Filter_005 end');
    }));

    it('ImageEditorUiBaseTest_Filter_006', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 滤镜-灰调文本
      Log.info(TAG, 'Filter_006 start');

      Log.info(TAG, '预期结果1、存在 petalClip_imageSelection_item_text_Moody 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_imageSelection_item_text_Moody'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Filter_006 end');
    }));

    it('ImageEditorUiBaseTest_Filter_007', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 滤镜-自然
      Log.info(TAG, 'Filter_007 start');

      Log.info(TAG, '预期结果1、存在 petalClip_imageSelection_itemNatural 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_imageSelection_itemNatural'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Filter_007 end');
    }));

    it('ImageEditorUiBaseTest_Filter_008', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 滤镜-自然文本
      Log.info(TAG, 'Filter_008 start');

      Log.info(TAG, '预期结果1、存在 petalClip_imageSelection_itemNatural 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_imageSelection_item_text_Natural'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Filter_008 end');
    }));

    it('ImageEditorUiBaseTest_Filter_009', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 滤镜-森系
      Log.info(TAG, 'Filter_009 start');

      Log.info(TAG, '预期结果1、存在 petalClip_imageSelection_itemBlossom 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_imageSelection_itemBlossom'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Filter_009 end');
    }));

    it('ImageEditorUiBaseTest_Filter_010', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 滤镜-森系文本
      Log.info(TAG, 'Filter_010 start');

      Log.info(TAG, '预期结果1、存在 petalClip_imageSelection_item_text_Blossom 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_imageSelection_item_text_Blossom'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Filter_010 end');
    }));

    it('ImageEditorUiBaseTest_Filter_011', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 滤镜-白皙
      Log.info(TAG, 'Filter_011 start');

      Log.info(TAG, '预期结果1、存在 petalClip_imageSelection_itemFair 对应的控件');
      await driver.swipe(1100, 2259, 100, 2250);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      const comp = await driver.findComponent(ON.id('petalClip_imageSelection_itemFair'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Filter_011 end');
    }));

    it('ImageEditorUiBaseTest_Filter_012', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 滤镜-白皙文本
      Log.info(TAG, 'Filter_012 start');

      Log.info(TAG, '预期结果1、存在 petalClip_imageSelection_item_text_Fair 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_imageSelection_item_text_Fair'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Filter_012 end');
    }));

    it('ImageEditorUiBaseTest_Filter_013', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 滤镜-粉调
      Log.info(TAG, 'Filter_013 start');

      Log.info(TAG, '预期结果1、存在 petalClip_imageSelection_itemPink 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_imageSelection_itemPink'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Filter_013 end');
    }));

    it('ImageEditorUiBaseTest_Filter_014', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 滤镜-粉调文本
      Log.info(TAG, 'Filter_014 start');

      Log.info(TAG, '预期结果1、存在 petalClip_imageSelection_item_text_Pink 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_imageSelection_item_text_Pink'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Filter_014 end');
    }));

    it('ImageEditorUiBaseTest_Filter_015', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 滤镜-除雾
      Log.info(TAG, 'Filter_015 start');

      Log.info(TAG, '预期结果1、存在 petalClip_imageSelection_itemHaze_Removal 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_imageSelection_itemHaze_Removal'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Filter_015 end');
    }));

    it('ImageEditorUiBaseTest_Filter_016', TestConstants.TEST_LEVEL_TWO, endTask(async (driver: Driver) => {
      // 滤镜-除雾文本
      Log.info(TAG, 'Filter_016 start');

      Log.info(TAG, '预期结果1、存在 petalClip_imageSelection_item_text_Haze_Removal 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_imageSelection_item_text_Haze_Removal'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Filter_016 end');
    }));
  });


  describe('ImageEditorUiBaseTest_TextTab_Test', () => {
    it('ImageEditorUiBaseTest_TextTab_001', TestConstants.TEST_LEVEL_TWO, startTask(async (driver: Driver) => {
      // 文字-添加文本
      Log.info(TAG, 'Regulate_001 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_8 对应的控件');
      await driver.swipe(957, 2562, 557, 2548);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      const button= await assertClickById('petalClip_bottomToolBar_8');
      expect(button).assertInstanceOf('Object');

      const comp = await driver.findComponent(ON.id('textTab_default_on'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Filter_001 end');
    }, PhotoType.StaticImage));

    it('ImageEditorUiBaseTest_TextTab_002', TestConstants.TEST_LEVEL_TWO, endTask(async (driver: Driver) => {
      // 文字-样式
      Log.info(TAG, 'TextTab_002 start');

      Log.info(TAG, '预期结果1、存在 textTab_style_off 对应的控件');
      const comp = await driver.findComponent(ON.id('textTab_style_off'));
      expect(comp).not().assertNull();

      Log.info(TAG, 'TextTab_002 end');
    }));
  });


  describe('ImageEditorUiBaseTest_Mosaic_Test', () => {
    it('ImageEditorUiBaseTest_Mosaic_001', TestConstants.TEST_LEVEL_TWO, startTask(async (driver: Driver) => {
      // 马赛克-橡皮擦
      Log.info(TAG, 'Mosaic_001 start');

      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_9 对应的控件');
      await driver.swipe(957, 2562, 557, 2548);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      const button= await assertClickById('petalClip_bottomToolBar_9');
      expect(button).assertInstanceOf('Object');

      Log.info(TAG, '预期结果2、存在 mosaicTab_mosaic_0_off 对应的控件');
      const comp = await driver.findComponent(ON.id('mosaicTab_mosaic_0_off'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_001 end');
    }, PhotoType.StaticImage));

    it('ImageEditorUiBaseTest_Mosaic_002', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-橡皮擦图标
      Log.info(TAG, 'Mosaic_002 start');

      Log.info(TAG, '预期结果1、存在 petalClip_mosaicSelection_item_image_mosaic_0 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_mosaicSelection_item_image_mosaic_0'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_002 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_003', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-1
      Log.info(TAG, 'Mosaic_003 start');

      Log.info(TAG, '预期结果1、存在 mosaicTab_mosaic_1_on 对应的控件');
      const comp = await driver.findComponent(ON.id('mosaicTab_mosaic_1_on'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_003 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_004', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-1图标
      Log.info(TAG, 'Mosaic_004 start');

      Log.info(TAG, '预期结果1、存在 petalClip_mosaicSelection_item_image_mosaic_1 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_mosaicSelection_item_image_mosaic_1'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_004 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_005', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-2
      Log.info(TAG, 'Mosaic_005 start');

      Log.info(TAG, '预期结果1、存在 mosaicTab_mosaic_2_off 对应的控件');
      const comp = await driver.findComponent(ON.id('mosaicTab_mosaic_2_off'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_005 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_006', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-2图标
      Log.info(TAG, 'Mosaic_006 start');

      Log.info(TAG, '预期结果1、存在 petalClip_mosaicSelection_item_image_mosaic_2 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_mosaicSelection_item_image_mosaic_2'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_006 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_007', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-3
      Log.info(TAG, 'Mosaic_007 start');

      Log.info(TAG, '预期结果1、存在 mosaicTab_mosaic_3_off 对应的控件');
      const comp = await driver.findComponent(ON.id('mosaicTab_mosaic_3_off'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_007 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_008', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-3图标
      Log.info(TAG, 'Mosaic_008 start');

      Log.info(TAG, '预期结果1、存在 petalClip_mosaicSelection_item_image_mosaic_3 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_mosaicSelection_item_image_mosaic_3'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_008 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_009', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-4
      Log.info(TAG, 'Mosaic_009 start');

      Log.info(TAG, '预期结果1、存在 mosaicTab_mosaic_4_off 对应的控件');
      const comp = await driver.findComponent(ON.id('mosaicTab_mosaic_4_off'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_009 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_010', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-4图标
      Log.info(TAG, 'Mosaic_010 start');

      Log.info(TAG, '预期结果1、存在 petalClip_mosaicSelection_item_image_mosaic_4 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_mosaicSelection_item_image_mosaic_4'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_010 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_011', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-5
      Log.info(TAG, 'Mosaic_011 start');

      Log.info(TAG, '预期结果1、存在 mosaicTab_mosaic_5_off 对应的控件');
      await driver.swipe(1150, 2259, 70, 2250);
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      const comp = await driver.findComponent(ON.id('mosaicTab_mosaic_5_off'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_011 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_012', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-5图标
      Log.info(TAG, 'Mosaic_012 start');

      Log.info(TAG, '预期结果1、存在 petalClip_mosaicSelection_item_image_mosaic_5 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_mosaicSelection_item_image_mosaic_5'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_012 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_013', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-6
      Log.info(TAG, 'Mosaic_013 start');

      Log.info(TAG, '预期结果1、存在 mosaicTab_mosaic_6_off 对应的控件');
      const comp = await driver.findComponent(ON.id('mosaicTab_mosaic_6_off'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_013 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_014', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-6图标
      Log.info(TAG, 'Mosaic_014 start');

      Log.info(TAG, '预期结果1、存在 petalClip_mosaicSelection_item_image_mosaic_6 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_mosaicSelection_item_image_mosaic_6'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_014 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_015', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-7
      Log.info(TAG, 'Mosaic_015 start');

      Log.info(TAG, '预期结果1、存在 mosaicTab_mosaic_7_off 对应的控件');
      const comp = await driver.findComponent(ON.id('mosaicTab_mosaic_7_off'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_015 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_016', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-7图标
      Log.info(TAG, 'Mosaic_016 start');

      Log.info(TAG, '预期结果1、存在 petalClip_mosaicSelection_item_image_mosaic_7 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_mosaicSelection_item_image_mosaic_7'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_016 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_017', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-8
      Log.info(TAG, 'Mosaic_017 start');

      Log.info(TAG, '预期结果1、存在 mosaicTab_mosaic_8_off 对应的控件');
      const comp = await driver.findComponent(ON.id('mosaicTab_mosaic_8_off'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_017 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_018', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-8图标
      Log.info(TAG, 'Mosaic_018 start');

      Log.info(TAG, '预期结果1、存在 petalClip_mosaicSelection_item_image_mosaic_8 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_mosaicSelection_item_image_mosaic_8'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_018 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_019', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 马赛克-9
      Log.info(TAG, 'Mosaic_019 start');

      Log.info(TAG, '预期结果1、存在 mosaicTab_mosaic_9_off 对应的控件');
      const comp = await driver.findComponent(ON.id('mosaicTab_mosaic_9_off'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_019 end');
    }));

    it('ImageEditorUiBaseTest_Mosaic_020', TestConstants.TEST_LEVEL_TWO, endTask(async (driver: Driver) => {
      // 马赛克-9图标
      Log.info(TAG, 'Mosaic_020 start');

      Log.info(TAG, '预期结果1、存在 petalClip_mosaicSelection_item_image_mosaic_9 对应的控件');
      const comp = await driver.findComponent(ON.id('petalClip_mosaicSelection_item_image_mosaic_9'));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertFalse();

      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'Mosaic_020 end');
    }));
  });
}