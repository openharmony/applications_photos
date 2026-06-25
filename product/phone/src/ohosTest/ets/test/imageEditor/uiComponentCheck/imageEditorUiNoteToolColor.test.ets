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
} from '../tools/steps';
import { UiComponentIdOfEditor } from '../util/UiComponentIdOfEditor';
import { PhotoType } from '../tools/constants';

const TAG: string = `${TestConstants.TAG}ImageEditorUiCheckTest`;

/*
 * 本测试套，用来保证编辑场景下，每个component都有key，并且key不缺失，以及clickable/enable状态正确
 * 如果代码中修改component key id，则需要同步更新对应的用例
 */
export default function ImageEditorUiNoteToolColorButtonTest(): void {
  describe('ImageEditorUiNoteToolColorButtonTest', () => {
    it('ImageEditorUiNoteToolColorButtonTest_000', TestConstants.TEST_LEVEL_TWO, startTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑
      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_7 对应的控件');
      const button= await assertClickById('petalClip_bottomToolBar_7');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

      // 跳过引导页
      let confirmBtn = await driver.findComponent(ON.id('advanced_dialog_button_0'));
      if (confirmBtn) {
        // 点击我知道了
        await assertClickById('advanced_dialog_button_0');
        Log.info(TAG, 'stylus guide test 01 click button success');
      } else {
        Log.info(TAG, 'stylus guide test 01 click button none');
      }

      const ColorButton= await assertClickById('noteToolPaintColorButton');
      expect(ColorButton).assertInstanceOf('Object');

      Log.info(TAG, 'NoteToolColorButtonTest_000 end');
    }, PhotoType.StaticImage));

    it('ImageEditorUiNoteToolColorButtonTest_0', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_0 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_0_0 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_0_0"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_0 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_1', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_1 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_0_1 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_0_1"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_1 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_2', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_2 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_0_2 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_0_2"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_2 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_3', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_3 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_0_3 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_0_3"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_3 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_4', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_4 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_0_4 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_0_4"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_4 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_5', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_5 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_0_5 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_0_5"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_5 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_6', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_6 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_0_6 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_0_6"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_6 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_7', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_7 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_0_7 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_0_7"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_7 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_8', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_8 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_0_8 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_0_8"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_8 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_9', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_9 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_0_9 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_0_9"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_9 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_10', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_10 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_0_10 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_0_10"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_10 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_11', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_11 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_0_11 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_0_11"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();
      await comp.click();

      Log.info(TAG, 'NoteToolColorButtonTest_11 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_12', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_12 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_0_12 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_0_12"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_12 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_13', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_13 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_1_0 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_1_0"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_13 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_14', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_14 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_1_1 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_1_1"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_14 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_15', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_15 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_1_2 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_1_2"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_15 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_16', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_16 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_1_3 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_1_3"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_16 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_17', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_17 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_1_4 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_1_4"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_17 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_18', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_18 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_1_5 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_1_5"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_18 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_19', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_19 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_1_6 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_1_6"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_19 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_20', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_20 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_1_7 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_1_7"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();
      await comp.click();

      Log.info(TAG, 'NoteToolColorButtonTest_20 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_21', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_21 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_1_8 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_1_8"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_21 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_22', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_22 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_1_9 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_1_9"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_22 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_23', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_23 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_1_10 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_1_10"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_23 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_24', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_24 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_1_11 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_1_11"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_24 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_25', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_25 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_1_12 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_1_12"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_25 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_26', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_26 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_2_0 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_2_0"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_26 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_27', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_27 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_2_1 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_2_1"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_27 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_28', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_28 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_2_2 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_2_2"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_28 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_29', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_29 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_2_3 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_2_3"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_29 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_30', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_30 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_2_4 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_2_4"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_30 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_31', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_31 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_2_5 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_2_5"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();
      await comp.click();

      Log.info(TAG, 'NoteToolColorButtonTest_31 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_32', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_32 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_2_6 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_2_6"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_32 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_33', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_33 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_2_7 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_2_7"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_33 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_34', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_34 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_2_8 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_2_8"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_34 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_35', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_35 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_2_9 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_2_9"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_35 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_36', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_36 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_2_10 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_2_10"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_36 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_37', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_37 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_2_11 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_2_11"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_37 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_38', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_38 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_2_12 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_2_12"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_38 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_39', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_39 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_3_0 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_3_0"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_39 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_40', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_40 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_3_1 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_3_1"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_40 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_41', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_41 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_3_2 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_3_2"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();
      await comp.click();

      Log.info(TAG, 'NoteToolColorButtonTest_41 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_42', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_42 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_3_3 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_3_3"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_42 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_43', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_43 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_3_4 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_3_4"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_43 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_44', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_44 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_3_5 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_3_5"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_44 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_45', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_45 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_3_6 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_3_6"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_45 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_46', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_46 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_3_7 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_3_7"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_46 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_47', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_47 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_3_8 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_3_8"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_47 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_48', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_48 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_3_9 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_3_9"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_48 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_49', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_49 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_3_10 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_3_10"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_49 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_50', TestConstants.TEST_LEVEL_TWO, endTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_50 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_3_11 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_3_11"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_50 end');
    }));
  });

  describe('ImageEditorUiNoteToolColorButtonTest2', () => {
    it('ImageEditorUiNoteToolColorButtonTest001', TestConstants.TEST_LEVEL_TWO, startTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑
      Log.info(TAG, '预期结果1、存在 petalClip_bottomToolBar_7 对应的控件');
      const button= await assertClickById('petalClip_bottomToolBar_7');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

      let confirmBtn = await driver.findComponent(ON.id('advanced_dialog_button_0'));
      if (confirmBtn) {
        // 点击我知道了
        await assertClickById('advanced_dialog_button_0');
        Log.info(TAG, 'stylus guide test 01 click button success');
      } else {
        Log.info(TAG, 'stylus guide test 01 click button none');
      }

      const ColorButton= await assertClickById('noteToolPaintColorButton');
      expect(ColorButton).assertInstanceOf('Object');

      Log.info(TAG, 'ImageEditorUiNoteToolColorButtonTest001 end');
    }, PhotoType.StaticImage));

    it('ImageEditorUiNoteToolColorButtonTest_51', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_51 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_3_12 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_3_12"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();
      await comp.click();

      Log.info(TAG, 'NoteToolColorButtonTest_51 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_52', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_52 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_4_0 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_4_0"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_52 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_53', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_53 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_4_1 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_4_1"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_53 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_54', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_54 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_4_2 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_4_2"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_54 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_55', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_55 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_4_3 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_4_3"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_55 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_56', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_56 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_4_4 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_4_4"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_56 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_57', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_57 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_4_5 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_4_5"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_57 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_58', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_58 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_4_6 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_4_6"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_58 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_59', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_59 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_4_7 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_4_7"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_59 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_60', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_60 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_4_8 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_4_8"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_60 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_61', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_61 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_4_9 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_4_9"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();
      await comp.click();

      Log.info(TAG, 'NoteToolColorButtonTest_61 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_62', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_62 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_4_10 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_4_10"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_62 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_63', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_63 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_4_11 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_4_11"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_63 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_64', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_64 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_4_12 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_4_12"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_64 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_65', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_65 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_5_0 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_5_0"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_65 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_66', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_66 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_5_1 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_5_1"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_66 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_67', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_67 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_5_2 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_5_2"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_67 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_68', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_68 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_5_3 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_5_3"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_68 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_69', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_69 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_5_4 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_5_4"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_69 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_70', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_70 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_5_5 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_5_5"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_70 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_71', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_71 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_5_6 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_5_6"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();
      await comp.click();

      Log.info(TAG, 'NoteToolColorButtonTest_71 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_72', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_72 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_5_7 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_5_7"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_72 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_73', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_73 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_5_8 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_5_8"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_73 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_74', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_74 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_5_9 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_5_9"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_74 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_75', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_75 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_5_10 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_5_10"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_75 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_76', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_76 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_5_11 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_5_11"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_76 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_77', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_77 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_5_12 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_5_12"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_77 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_78', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_78 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_6_0 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_6_0"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_78 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_79', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_79 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_6_1 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_6_1"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_79 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_80', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_80 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_6_2 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_6_2"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_80 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_81', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_81 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_6_3 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_6_3"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();
      await comp.click();

      Log.info(TAG, 'NoteToolColorButtonTest_81 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_82', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_82 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_6_4 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_6_4"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_82 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_83', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_83 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_6_5 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_6_5"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_83 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_84', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_84 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_6_6 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_6_6"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_84 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_85', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_85 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_6_7 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_6_7"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_85 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_86', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_86 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_6_8 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_6_8"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_86 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_87', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_87 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_6_9 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_6_9"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_87 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_88', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_88 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_6_10 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_6_10"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_88 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_89', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_89 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_6_11 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_6_11"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_89 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_90', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_90 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_6_12 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_6_12"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_90 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_91', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_91 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_7_0 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_7_0"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();
      await comp.click();

      Log.info(TAG, 'NoteToolColorButtonTest_91 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_92', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_92 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_7_1 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_7_1"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_92 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_93', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_93 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_7_2 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_7_2"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_93 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_94', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_94 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_7_3 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_7_3"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_94 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_95', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_95 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_7_4 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_7_4"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_95 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_96', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_96 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_7_5 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_7_5"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_96 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_97', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_97 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_7_6 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_7_6"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_97 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_98', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_98 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_7_7 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_7_7"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_98 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_99', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_99 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_7_8 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_7_8"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_99 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_100', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_100 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_7_9 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_7_9"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_100 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_101', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_101 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_7_10 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_7_10"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();
      await comp.click();

      Log.info(TAG, 'NoteToolColorButtonTest_101 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_102', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_102 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_7_11 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_7_11"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_102 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_103', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_103 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_7_12 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_7_12"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_103 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_104', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_104 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_8_0 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_8_0"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_104 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_105', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_105 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_8_1 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_8_1"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_105 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_106', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_106 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_8_2 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_8_2"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_106 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_107', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_107 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_8_3 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_8_3"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_107 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_108', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_108 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_8_4 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_8_4"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_108 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_109', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_109 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_8_5 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_8_5"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_109 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_110', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_110 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_8_6 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_8_6"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_110 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_111', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_111 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_8_7 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_8_7"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();
      await comp.click();

      Log.info(TAG, 'NoteToolColorButtonTest_111 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_112', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_112 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_8_8 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_8_8"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_112 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_113', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_113 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_8_9 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_8_9"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_113 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_114', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_114 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_8_10 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_8_10"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_114 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_115', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_115 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_8_11 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_8_11"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_115 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_116', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_116 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_8_12 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_8_12"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_116 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_117', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_117 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_9_0 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_9_0"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_117 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_118', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_118 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_9_1 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_9_1"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_118 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_119', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_119 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_9_2 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_9_2"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_119 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_120', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_120 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_9_3 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_9_3"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_120 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_121', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_121 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_9_4 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_9_4"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();
      await comp.click();

      Log.info(TAG, 'NoteToolColorButtonTest_121 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_122', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_122 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_9_5 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_9_5"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_122 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_123', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_123 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_9_6 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_9_6"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_123 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_124', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_124 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_9_7 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_9_7"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_124 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_125', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_125 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_9_8 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_9_8"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_125 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_126', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_126 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_9_9 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_9_9"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_126 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_127', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_127 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_9_10 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_9_10"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_127 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_128', TestConstants.TEST_LEVEL_TWO, loggedTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_128 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_9_11 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_9_11"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_128 end');
    }));

    it('ImageEditorUiNoteToolColorButtonTest_129', TestConstants.TEST_LEVEL_TWO, endTask(async (driver: Driver) => {
      // 涂鸦-颜色编辑器
      Log.info(TAG, 'NoteToolColorButtonTest_129 start');

      Log.info(TAG, '预期结果1、存在 noteToolPaintColorPopupBox_9_12 对应的控件');
      const comp = await driver.findComponent(ON.id("noteToolPaintColorPopupBox_9_12"));
      expect(comp).not().assertNull();

      const isClickable = await comp.isClickable();
      expect(isClickable).assertTrue();
      const isEnable = await comp.isEnabled();
      expect(isEnable).assertTrue();

      Log.info(TAG, 'NoteToolColorButtonTest_129 end');
    }));
  });
}