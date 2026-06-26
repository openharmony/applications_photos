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
import { KeyCode } from '@kit.InputKit';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { Driver, ON, Component } from '@ohos.UiTest';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import {
  swipeSearch,
  swipeIn,
  startTask,
  endTask,
  loggedTask,
  UpdateOrientation,
  assertClickById,
  simulateIn,
  simulateOut
} from '../tools/steps';
import { PhotoType } from '../tools/constants';

const TAG: string = `${TestConstants.TAG}PhotoEditorKeyBoardTest`;
const maxTab: number = 50; //最大tab数

/**
 * tab至指定控件
 * @param driver
 * @param id
 */
async function tabToComponent(driver: Driver, id: string): Promise<boolean> {
  let compareButton = await driver.findComponent(ON.id(id));
  if (compareButton) {
    let tabCount: number = 0; //tab次数
    //tab键循环两轮
    while (!await compareButton.isFocused()) {
      tabCount++;
      await driver.triggerKey(KeyCode.KEYCODE_TAB);
      await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
      if (tabCount > maxTab) {
        Log.error(TAG, 'tabToComponent Tab key Cycle exception');
        return false;
      }
    }
    return true;
  }
  Log.error(TAG, `tabToComponent error, findEmpty:${id}`);
  return false;
}

/**
 * shift Tab至指定控件
 * @param driver
 * @param id
 */
async function shiftTabToComponent(driver: Driver, id: string): Promise<boolean> {
  let compareButton = await driver.findComponent(ON.id(id));
  if (compareButton) {
    let tabCount: number = 0; //tab次数
    //tab键循环两轮
    while (!await compareButton.isFocused()) {
      tabCount++;
      await driver.triggerCombineKeys(KeyCode.KEYCODE_SHIFT_LEFT, KeyCode.KEYCODE_TAB);
      await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
      if (tabCount > maxTab) {
        Log.error(TAG, 'tabToComponent Tab key Cycle exception');
        return false;
      }
    }
    return true;
  }
  Log.error(TAG, `tabToComponent error, findEmpty:${id}`);
  return false;
}

export default function photoEditorKeyBoardTest(): void {

  describe('PhotoEditorKeyBoard_TabAndEsc', () => {
    it('PhotoEditorKeyBoard_TabCycle', TestConstants.TEST_LEVEL_ZERO, startTask(async (driver: Driver) => {
      // tab
      let focusComponent = await driver.findComponent(ON.id('imageEditor_topToolBar_back'));
      if (focusComponent) {
        let focusCount: number = 0; //back 获焦次数
        let tabCount: number = 0; //tab次数
        //tab键循环两轮
        while (focusCount < 2) {
          tabCount++;
          await driver.triggerKey(KeyCode.KEYCODE_TAB);
          await focusComponent.isFocused() && focusCount++; //back 获焦次数+1
          await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
          if (tabCount > maxTab) {
            break;
          }
        }
        Log.error(TAG, `Tab key Cycle : ${tabCount}`);
        expect(await focusComponent.isFocused()).assertTrue();
      } else {
        expect(focusComponent).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }, PhotoType.StaticImage));

    it('PhotoEditorKeyBoard_Esc', TestConstants.TEST_LEVEL_ZERO, endTask(async (driver: Driver) => {
      //esc
      await driver.triggerKey(KeyCode.KEYCODE_ESCAPE);
      //判断返回大图 10s
      let button: Component | null = null;
      for (let index = 0; index < 10; index++) {
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
        button = await driver.findComponent(ON.id('ToolBarButtonEdit'));
        if (button) {
          break;
        }
      }
      expect(button).assertInstanceOf('Object');
    }));
  });

  describe('PhotoEditorKeyBoard_Crop', () => {
    it('PhotoEditorKeyBoard_Rotate', TestConstants.TEST_LEVEL_ZERO, startTask(async (driver: Driver) => {
      //旋转
      if (await tabToComponent(driver, 'petalclip_CropTool_rotateBtn')) {
        await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
        await driver.triggerKey(KeyCode.KEYCODE_ENTER);
        await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
      }
      let focusComponent = await driver.findComponent(ON.id('petalclip_CropTool_rotateBtn'));
      if (focusComponent) {
        expect(await focusComponent.isFocused()).assertTrue();
      } else {
        expect(focusComponent).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }, PhotoType.StaticImage));

    it('PhotoEditorKeyBoard_undoRotate', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //撤销
      const button = await assertClickById('petalClip_topToolBar_undo');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('PhotoEditorKeyBoard_mirrorBtn', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //镜像
      if (await tabToComponent(driver, 'petalclip_CropTool_mirrorBtn')) {
        await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
        await driver.triggerKey(KeyCode.KEYCODE_ENTER);
        await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
      }
      let focusComponent = await driver.findComponent(ON.id('petalclip_CropTool_mirrorBtn'));
      if (focusComponent) {
        expect(await focusComponent.isFocused()).assertTrue();
      } else {
        expect(focusComponent).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('PhotoEditorKeyBoard_undoMirror', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //撤销
      const button = await assertClickById('petalClip_topToolBar_undo');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('PhotoEditorKeyBoard_RulerBar', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //调整角度10次
      if (await shiftTabToComponent(driver, 'petalclip_RulerBar_RulerBar')) {
        await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
        for (let index = 0; index < 10; index++) {
          await driver.triggerKey(KeyCode.KEYCODE_DPAD_UP);
          await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
        }
      }
      let focusComponent = await driver.findComponent(ON.id('petalclip_RulerBar_RulerBar'));
      if (focusComponent) {
        expect(await focusComponent.isFocused()).assertTrue();
      } else {
        expect(focusComponent).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('PhotoEditorKeyBoard_RulerBarSuccess', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // undo
      let button = await driver.findComponent(ON.id('petalClip_topToolBar_undo'));
      if (button) {
        expect(await button.isEnabled()).assertTrue();
      } else {
        expect(button).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));


    it('PhotoEditorKeyBoard_CTRL_Z', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //CTRL Z 撤销
      await driver.triggerCombineKeys(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_Z);
      let button = await driver.findComponent(ON.id('petalClip_topToolBar_redo'));
      if (button) {
        expect(await button.isEnabled()).assertTrue();
      } else {
        expect(button).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('PhotoEditorKeyBoard_CTRL_Y', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //CTRL Y 还原
      await driver.triggerCombineKeys(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_Y);
      let button = await driver.findComponent(ON.id('petalClip_topToolBar_redo'));
      if (button) {
        expect(await button.isEnabled()).assertFalse();
      } else {
        expect(button).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('PhotoEditorKeyBoard_CTRL_S', TestConstants.TEST_LEVEL_ZERO, endTask(async (driver: Driver) => {
      //CTRL S 保存
      await driver.triggerCombineKeys(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_S);
      //判断返回大图 10s
      let button: Component | null = null;
      for (let index = 0; index < 10; index++) {
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
        button = await driver.findComponent(ON.id('ToolBarButtonEdit'));
        if (button) {
          break;
        }
      }
      expect(button).assertInstanceOf('Object');
    }));
  });

  describe('PhotoEditorKeyBoard_Adjust', () => {
    it('PhotoEditorKeyBoard_EnterAdjust', TestConstants.TEST_LEVEL_ZERO, startTask(async (driver: Driver) => {
      //调节
      if (await tabToComponent(driver, 'petalClip_bottomToolBar_2')) {
        await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
        await driver.triggerKey(KeyCode.KEYCODE_ENTER);
        await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
      }
      let focusComponent = await driver.findComponent(ON.id('petalClip_bottomToolBar_2'));
      if (focusComponent) {
        expect(await focusComponent.isFocused()).assertTrue();
      } else {
        expect(focusComponent).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }, PhotoType.StaticImage));

    it('PhotoEditorKeyBoard_EnterAdjustItem_Exposure', TestConstants.TEST_LEVEL_ZERO,
      loggedTask(async (driver: Driver) => {
        // 调节一键调节强度
        if (await tabToComponent(driver, 'petalClip_AdjustItem_exposure')) {
          await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
          await driver.triggerKey(KeyCode.KEYCODE_ENTER);
          await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
        }
        let focusComponent = await driver.findComponent(ON.id('petalClip_AdjustItem_exposure'));
        if (focusComponent) {
          expect(await focusComponent.isFocused()).assertTrue();
        } else {
          expect(focusComponent).assertInstanceOf('Object');
        }
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      }));

    it('PhotoEditorKeyBoard_AdjustStrengthBar', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //一键调节强度10次
      if (await shiftTabToComponent(driver, 'petalClip_strengthBar_strengthBar')) {
        for (let index = 0; index < 10; index++) {
          await driver.triggerKey(KeyCode.KEYCODE_DPAD_UP);
          await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
        }
      }
      let focusComponent = await driver.findComponent(ON.id('petalClip_strengthBar_strengthBar'));
      if (focusComponent) {
        expect(await focusComponent.isFocused()).assertTrue();
      } else {
        expect(focusComponent).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('PhotoEditorKeyBoard_RulerBarSuccess', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // undo
      let button = await driver.findComponent(ON.id('petalClip_topToolBar_undo'));
      if (button) {
        expect(await button.isEnabled()).assertTrue();
      } else {
        expect(button).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));


    it('PhotoEditorKeyBoard_CTRL_Z', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //CTRL Z 撤销
      await driver.triggerCombineKeys(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_Z);
      let button = await driver.findComponent(ON.id('petalClip_topToolBar_redo'));
      if (button) {
        expect(await button.isEnabled()).assertTrue();
      } else {
        expect(button).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('PhotoEditorKeyBoard_CTRL_Y', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //CTRL Y 还原
      await driver.triggerCombineKeys(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_Y);
      let button = await driver.findComponent(ON.id('petalClip_topToolBar_redo'));
      if (button) {
        expect(await button.isEnabled()).assertFalse();
      } else {
        expect(button).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('PhotoEditorKeyBoard_CTRL_Shift_S', TestConstants.TEST_LEVEL_ZERO, endTask(async (driver: Driver) => {
      //CTRL SHIFT S 另存为（另存为会产生新的图片，可能会影响后续用例，暂时注释）
      //await driver.triggerCombineKeys(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_SHIFT_LEFT, KeyCode.KEYCODE_S);
      await driver.triggerCombineKeys(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_S);
      //判断返回大图 10s
      let button: Component | null = null;
      for (let index = 0; index < 10; index++) {
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
        button = await driver.findComponent(ON.id('ToolBarButtonEdit'));
        if (button) {
          break;
        }
      }
      expect(button).assertInstanceOf('Object');
    }));
  });

  describe('PhotoEditorKeyBoard_Mosaic', () => {
    it('PhotoEditorKeyBoard_EnterMosaic', TestConstants.TEST_LEVEL_ZERO, startTask(async (driver: Driver) => {
      // 点击马赛克按钮-切到马赛克界面
      const component = await swipeSearch(ON.id('petalClip_bottomToolBar_TabsBar'),
        ON.id('petalClip_bottomToolBar_image_9'), 'right');
      expect(component).assertInstanceOf('Object');
      const button = await assertClickById('petalClip_bottomToolBar_image_9');
      expect(button).assertInstanceOf('Object');
      let confirmBtn = await driver.findComponent(ON.id('advanced_dialog_button_1'));
      if (confirmBtn) {
        await confirmBtn.click();
      }
    }, PhotoType.StaticImage));

    it('PhotoEditorKeyBoard_SelectMosaicItem', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 回车选中马赛克笔刷
      if (await tabToComponent(driver, 'petalClip_mosaicSelection_item_mosaic_2')) {
        await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
        await driver.triggerKey(KeyCode.KEYCODE_ENTER);
        await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
      }
      let focusComponent = await driver.findComponent(ON.id('petalClip_mosaicSelection_item_mosaic_2'));
      if (focusComponent) {
        expect(await focusComponent.isFocused()).assertTrue();
      } else {
        expect(focusComponent).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('PhotoEditorKeyBoard_AdjustStrengthBar', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 笔刷大小
      if (await shiftTabToComponent(driver, 'PenSize_bar_focusColumn')) {
        await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
        await driver.triggerKey(KeyCode.KEYCODE_DPAD_UP);
        await driver.delayMs(TestConstants.DELAY_HALF_SECOND);
      }
      let focusComponent = await driver.findComponent(ON.id('PenSize_bar_focusColumn'));
      if (focusComponent) {
        expect(await focusComponent.isFocused()).assertTrue();
      } else {
        expect(focusComponent).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('PhotoEditorKeyBoard_SwipeMosaic', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //开始涂抹
      const component = await swipeIn(ON.id('mosaicView'), 'right');
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
    }));

    it('PhotoEditorKeyBoard_UndoEnabled', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // undo
      let button = await driver.findComponent(ON.id('petalClip_topToolBar_undo'));
      expect(await button.isEnabled()).assertTrue();
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));


    it('PhotoEditorKeyBoard_CTRL_Z', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //CTRL Z 撤销
      await driver.triggerCombineKeys(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_Z);
      let button = await driver.findComponent(ON.id('petalClip_topToolBar_redo'));
      if (button) {
        expect(await button.isEnabled()).assertTrue();
      } else {
        expect(button).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('PhotoEditorKeyBoard_CTRL_Y', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //CTRL Y 还原
      await driver.triggerCombineKeys(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_Y);
      let button = await driver.findComponent(ON.id('petalClip_topToolBar_redo'));
      if (button) {
        expect(await button.isEnabled()).assertFalse();
      } else {
        expect(button).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('PhotoEditorKeyBoard_CTRL_S', TestConstants.TEST_LEVEL_ZERO, endTask(async (driver: Driver) => {
      //CTRL S 保存
      await driver.triggerCombineKeys(KeyCode.KEYCODE_CTRL_LEFT, KeyCode.KEYCODE_S);
      //判断返回大图 10s
      let button: Component | null = null;
      for (let index = 0; index < 10; index++) {
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
        button = await driver.findComponent(ON.id('ToolBarButtonEdit'));
        if (button) {
          break;
        }
      }
      expect(button).assertInstanceOf('Object');
    }));
  });
}
