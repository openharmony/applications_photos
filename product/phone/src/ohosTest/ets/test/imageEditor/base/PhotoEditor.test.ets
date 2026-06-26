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
import { describe, expect} from '@ohos/hypium';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { Driver, ON } from '@ohos.UiTest';
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

const TAG: string = `${TestConstants.TAG}PhotoEditorTest`;

export default function photoEditorTest(): void {
  describe('PhotoEditorFiler', () => {
    it('Task_02_Filer_Test01', TestConstants.TEST_LEVEL_ZERO, startTask(async (driver: Driver) => {
      // 点击滤镜
      const button = await assertClickById('petalClip_bottomToolBar_image_4');
      expect(button).assertInstanceOf('Object');

      // 判断是否有对比，如果有长按
      let compareButton = await driver.findComponent(ON.id('petalClip_VideoTrimTool_compareButton'));
      if (compareButton) {
        await compareButton.longClick();
        expect(compareButton).assertInstanceOf('Object');
      }
    }, PhotoType.StaticImage));

    it('Task_02_Filer_Test02', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 点击自然滤镜效果
      const button = await assertClickById('petalClip_imageSelection_item_text_Natural');
      expect(button).assertInstanceOf('Object');

      // 判断是否有对比，如果有长按
      let compareButton = await driver.findComponent(ON.id('petalClip_VideoTrimTool_compareButton'));
      if (compareButton) {
        await compareButton.longClick();
        expect(compareButton).assertInstanceOf('Object');
      }
    }));

    it('Task_02_Filer_Test03', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 点击原图效果
      const button = await assertClickById('petalClip_imageSelection_item_text_000000000000000000');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Filer_Test04', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 点击经典滤镜效果，设置效果强度
      const button = await assertClickById('petalClip_imageSelection_item_text_Classic');
      expect(button).assertInstanceOf('Object');

      // 判断是否有对比，如果有长按
      let compareButton = await driver.findComponent(ON.id('petalClip_VideoTrimTool_compareButton'));
      if (compareButton) {
        await compareButton.longClick();
        expect(compareButton).assertInstanceOf('Object');
      }
    }));

    it('Task_02_Filer_Test05', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //撤销
      const button = await assertClickById('petalClip_topToolBar_undo');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Filer_Test06', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //撤销
      const button = await assertClickById('petalClip_topToolBar_undo');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, 'Filter 经典 clicked and set strength');
    }));

    it('Task_02_Filer_Test07', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 滑动滤镜栏，点击粉调滤镜效果，设置效果强度
      const component =
        await swipeSearch(ON.id('petalclip_scroll'), ON.id('petalClip_imageSelection_item_text_Pink'), 'right');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_02_Filer_Test08', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalClip_imageSelection_item_text_Pink');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, 'Filter 粉调 clicked and set strength');

      // 旋转屏幕
      await UpdateOrientation();
    }));

    it('Task_02_Filer_Test09', TestConstants.TEST_LEVEL_ZERO, endTask(async (driver: Driver) => {
      // 长按对比
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      await driver.assertComponentExist(ON.id('petalClip_VideoTrimTool_compareButton'));
      let compareButtonEdit = await driver.findComponent(ON.id('petalClip_VideoTrimTool_compareButton'));
      expect(compareButtonEdit).assertInstanceOf('Object');
      await compareButtonEdit.longClick();
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));
  });

  describe('PhotoEditorCrop', () => {
    it('Task_02_Edit_Crop_Test01', TestConstants.TEST_LEVEL_ZERO, startTask(async (driver: Driver) => {
      // 图片旋转
      const button = await assertClickById('petalclip_CropTool_rotateBtn');
      expect(button).assertInstanceOf('Object');

      // 判断是否有对比，如果有长按
      let compareButton = await driver.findComponent(ON.id('petalClip_VideoTrimTool_compareButton'));
      if (compareButton) {
        await compareButton.longClick();
        expect(compareButton).assertInstanceOf('Object');
      }
    }, PhotoType.StaticImage));

    it('Task_02_Edit_Crop_Test02', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const component = await simulateOut(driver, ON.id('petalClip_frostedGlass_rect_rightTop'), 20);
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Crop_Test03', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const component = await simulateIn(driver, ON.id('petalClip_frostedGlass_rect_rightTop'), 20);
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));


    it('Task_02_Edit_Crop_Test04', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //滑动刻度条
      const component = await swipeIn(ON.id('petalclip_CropTool_rulerScroller'));
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    }));

    it('Task_02_Edit_Crop_Test05', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 图片镜像
      const button = await assertClickById('petalclip_CropTool_mirrorBtn');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Crop_Test06', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const component=  await simulateOut(driver, ON.id('petalClip_frostedGlass_rect_rightTop'), 20);
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Crop_Test07', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const component = await simulateIn(driver, ON.id('petalClip_frostedGlass_rect_rightTop'), 20);
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_02_Edit_Crop_Test08', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //滑动刻度条
      const component = await swipeIn(ON.id('petalclip_CropTool_rulerScroller'));
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    }));

    it('Task_02_Edit_Crop_Test09', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 图片镜像
      const button = await assertClickById('petalclip_CropTool_mirrorBtn');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Crop_Test10', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 图片水平校正
      const button = await assertClickById('cropTab_horizontalCorrection_off');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Crop_Test11', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //滑动刻度条
      const component = await swipeIn(ON.id('petalclip_CropTool_rulerScroller'));
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    }));

    it('Task_02_Edit_Crop_Test12', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 图片智能校正
      const button = await assertClickById('cropTab_intelligentCorrection_off');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    }));

    it('Task_02_Edit_Crop_Test13', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 二次选中图片智能校正
      const button = await assertClickById('cropTab_intelligentCorrection_on');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    }));

    it('Task_02_Edit_Crop_Test14', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
        // 图片垂直校正
      const button = await assertClickById('cropTab_verticalCorrection_off');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Crop_Test15', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //滑动刻度条
      const component = await swipeIn(ON.id('petalclip_CropTool_rulerScroller'));
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    }));

    it('Task_02_Edit_Crop_Test16', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 点击调节
      const button = await assertClickById('petalClip_bottomToolBar_image_2');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_02_Edit_Crop_Test17', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 点击裁剪
      const button = await assertClickById('petalClip_bottomToolBar_image_1');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_02_Edit_Crop_Test18', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 点击比例，切换成全屏
      const button = await assertClickById('cropTab_ratio_off');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Crop_Test19', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalclip_ScaleSelection_2');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_02_Edit_Crop_Test20', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const component = await swipeSearch(ON.id('petalclip_CropTool_cropRatio'),
        ON.id('petalclip_ScaleSelection_0'), 'left');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Crop_Test21', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 点击原始
      const button = await assertClickById('petalclip_ScaleSelection_0');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_02_Edit_Crop_Test22', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 再次点击原始
      const button = await assertClickById('petalclip_ScaleSelection_0');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_02_Edit_Crop_Test23', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 滑动调节栏，点击1:1
      const button = await assertClickById('petalclip_ScaleSelection_3');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_02_Edit_Crop_Test23_1', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 滑动调节栏，滑动到3:2
      const component = await swipeSearch(ON.id('petalclip_CropTool_cropRatio'),
        ON.id('petalclip_ScaleSelection_4'), 'right');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Crop_Test24', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 点击3:2
      const button = await assertClickById('petalclip_ScaleSelection_4');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));


    it('Task_02_Edit_Crop_Test25', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 滑动调节栏，点击4:3
      const component = await swipeSearch(ON.id('petalclip_CropTool_cropRatio'),
        ON.id('petalclip_ScaleSelection_6'), 'right');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Crop_Test26', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalclip_ScaleSelection_6');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_02_Edit_Crop_Test26_1', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 滑动调节栏，点击16:9
      const component = await swipeSearch(ON.id('petalclip_CropTool_cropRatio'),
        ON.id('petalclip_ScaleSelection_9'), 'right');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Crop_Test27', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 滑动调节栏，点击16:9
      const button = await assertClickById('petalclip_ScaleSelection_9');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_02_Edit_Crop_Test28', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 滑动调节栏，点击1:1
      const component = await swipeSearch(ON.id('petalclip_CropTool_cropRatio'),
        ON.id('petalclip_ScaleSelection_2'), 'left');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Crop_Test29', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalclip_ScaleSelection_3');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_02_Edit_Crop_Test30', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // undo
      let button = await driver.findComponent(ON.id('petalClip_topToolBar_undo').enabled(true));
      if (button) {
        Log.info(TAG, 'petalClip_topToolBar_undo button exist');
        const button = await assertClickById('petalClip_topToolBar_undo');
        expect(button).assertInstanceOf('Object');
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      }
    }));

    it('Task_02_Edit_Crop_Test31', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // redo
       let button = await driver.findComponent(ON.id('petalClip_topToolBar_redo').enabled(true));
      if (button) {
        Log.info(TAG, 'petalClip_topToolBar_redo button exist');
        const button = await assertClickById('petalClip_topToolBar_redo');
        expect(button).assertInstanceOf('Object');
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      }
    }));

    it('Task_02_Edit_Crop_Test32', TestConstants.TEST_LEVEL_ZERO, endTask(async (driver: Driver) => {
      // 保存
      let button = await driver.findComponent(ON.id('petalClip_topToolBar_save').enabled(true));
      if (button) {
        Log.info(TAG, 'petalClip_topToolBar_save button exist');
        await button.click();
        expect(button).assertInstanceOf('Object');
        const saveBtn = await driver.findComponent(ON.text('覆盖原图'));
        if (saveBtn) {
          await saveBtn.click();
        }
        await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
      }
    }));


  });
  describe('PhotoEditorAdjust', () => {
    it('Task_02_Edit_Test02_1', TestConstants.TEST_LEVEL_ZERO, startTask(async (driver: Driver) => {
      // 点击调节
      const button = await assertClickById('petalClip_bottomToolBar_image_2');
      expect(button).assertInstanceOf('Object');

      // 判断是否有对比，如果有长按
      let compareButton = await driver.findComponent(ON.id('petalClip_VideoTrimTool_compareButton'));
      if (compareButton) {
        await compareButton.longClick();
        expect(compareButton).assertInstanceOf('Object');
      }
    }, PhotoType.StaticImage));

    it('Task_02_Edit_Test02_2', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 调节一键调节强度
      const button = await assertClickById('petalClip_AdjustItem_auto_false');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test02_3', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const component = await swipeIn(ON.id('petalClip_strengthBar_strengthBar'));
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test02_4', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 调节曝光强度
      const button = await assertClickById('petalClip_AdjustItem_exposure_false');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test02_5', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const component = await swipeIn(ON.id('petalClip_strengthBar_strengthBar'));
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test02_6', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 点击亮度，调节亮度
      const component = await swipeSearch(ON.id('petalclip_scroll'), ON.id('petalClip_AdjustItem_brightness_false'));
      expect(component).assertInstanceOf('Object');
      // 判断是否有对比，如果有长按
      let compareButton = await driver.findComponent(ON.id('petalClip_VideoTrimTool_compareButton'));
      if (compareButton) {
        await compareButton.longClick();
        expect(compareButton).assertInstanceOf('Object');
      }
    }));

    it('Task_02_Edit_Test02_7', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalClip_AdjustItem_brightness_false');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test02_8', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const component = await swipeIn(ON.id('petalClip_strengthBar_strengthBar'));
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_02_Edit_Test02_9', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 点击对比度，调节对比度
      const component = await swipeSearch(ON.id('petalclip_scroll'), ON.id('petalClip_AdjustItem_contrast_false'));
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test02_10', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalClip_AdjustItem_contrast_false');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test02_11', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const component = await swipeIn(ON.id('petalClip_strengthBar_strengthBar'));
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test02_12', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //点击亮部并进行调节
      const component = await swipeSearch(ON.id('petalclip_scroll'), ON.id('petalClip_AdjustItem_brightzone_false'));
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test02_13', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalClip_AdjustItem_brightzone_false');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test02_14', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const component = await swipeIn(ON.id('petalClip_strengthBar_strengthBar'));
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_02_Edit_Test02_15', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //点击褪色并进行调节
      const component = await swipeSearch(ON.id('petalclip_scroll'), ON.id('petalClip_AdjustItem_fade_false'));
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test02_16', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalClip_AdjustItem_fade_false');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test02_17', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const component = await swipeIn(ON.id('petalClip_strengthBar_strengthBar'));
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_02_Edit_Test02_18', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const component = await swipeIn(ON.id('petalClip_strengthBar_strengthBar'), 'left');
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_02_Edit_Test02_19', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //点击颗粒并进行调节
      const component = await swipeSearch(ON.id('petalclip_scroll'), ON.id('petalClip_AdjustItem_grain_false'));
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test02_20', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalClip_AdjustItem_grain_false');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test02_21', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const component = await swipeIn(ON.id('petalClip_strengthBar_strengthBar'));
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_02_Edit_Test02_22', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //点击颗粒取消颗粒调节,之后恢复颗粒调节
      const button = await assertClickById('petalClip_AdjustItem_grain_true');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test02_23', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalClip_AdjustItem_grain_false');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test02_24', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 点击保存按钮
      const button = await assertClickById('petalClip_topToolBar_save');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test02_25', TestConstants.TEST_LEVEL_ZERO, endTask(async (driver: Driver) => {
      const saveBtn = await driver.findComponent(ON.text('覆盖原图'));
      if (saveBtn) {
        await saveBtn.click();
        expect(saveBtn).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
    }));

  });
  describe('PhotoEditorText', () => {
    it('Task_02_Edit_Test07_1', TestConstants.TEST_LEVEL_ZERO, startTask(async (driver: Driver) => {
      // 点击文字
      const button = await assertClickById('petalClip_bottomToolBar_image_8');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

      // 判断是否有对比，如果有长按
      let compareButton = await driver.findComponent(ON.id('petalClip_VideoTrimTool_compareButton'));
      if (compareButton) {
        await compareButton.longClick();
        expect(compareButton).assertInstanceOf('Object');
      }
    }, PhotoType.StaticImage));

    it('Task_02_Edit_Test07_2', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 点击添加文本，拉起输入框
      const button = await assertClickById('textTab_default_on');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
      // 判断是否有对比，如果有长按
      let compareButton = await driver.findComponent(ON.id('petalClip_VideoTrimTool_compareButton'));
      if (compareButton) {
        await compareButton.longClick();
        expect(compareButton).assertInstanceOf('Object');
      }
    }));

    it('Task_02_Edit_Test07_3', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 输入文本
      let input = await driver.findComponent(ON.id('text_edit_input_tab'));
      if(input){
        const text = 'test input text';
        await input.inputText(text);
        expect(input).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_4', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 完成輸入
      const button = await assertClickById('edit_box_check_mark');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_5', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 双指捏合放大
      const component = await simulateIn(driver, ON.id('text_edit_lower_right_corner'), 8);
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_6', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 双指捏合缩小
      const component = await simulateOut(driver, ON.id('text_edit_lower_right_corner'), 8);
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_7', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 平移
      await driver.swipe(600, 1200, 800, 1400, 600);
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
      let component = await driver.findComponent(ON.id('petalClip_bottomToolBar_image_8').enabled(true));
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test07_8', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //点击样式
      const button = await assertClickById('textTab_style_off');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test07_9', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //修改字体颜色
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
      const button = await assertClickById('styles_font_color_4');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test07_10', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //字体加粗、斜体、下划线
      const button = await assertClickById('text_editor_font_bold');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test07_11', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('text_editor_font_italic');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test07_12', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('text_editor_font_underline');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_13', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //阴影和背景
      const button = await assertClickById('text_editor_font_style');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_14', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('text_editor_font_style_background');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
      // 判断是否有对比，如果有长按
      let compareButton = await driver.findComponent(ON.id('petalClip_VideoTrimTool_compareButton'));
      if (compareButton) {
        await compareButton.longClick();
        expect(compareButton).assertInstanceOf('Object');
      }
    }));

    it('Task_02_Edit_Test07_15', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //对齐方式
      const button = await assertClickById('text_editor_align');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_16', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('text_editor_align_left');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_17', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 点击蒙层，关闭样式弹窗
      const button = await assertClickById('textedit_ClickImage');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_18', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 点击添加文本，拉起输入框
      const button = await assertClickById('textTab_default_on');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_19', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 输入文本
      let input = await driver.findComponent(ON.id('text_edit_input_tab'));
      expect(input).not().assertNull();
      const text = 'test input text';
      await input.inputText(text);
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_20', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 完成輸入
      const button = await assertClickById('edit_box_check_mark');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_21', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //点击复制、编辑
      const button = await assertClickById('edit_image_copy');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_22', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('edit_image_edit');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_23', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 输入文本
      let copyInput = await driver.findComponent(ON.id('text_edit_input_tab'));
      expect(copyInput).not().assertNull();
      const copyText = 'test copy input text';
      await copyInput.inputText(copyText);
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_24', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 完成輸入
      const button = await assertClickById('edit_box_check_mark');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_25', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //删除
      const button = await assertClickById('edit_image_delete');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_26', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //undo
      const button = await assertClickById('petalClip_topToolBar_undo');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test07_27', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //redo
      const button = await assertClickById('petalClip_topToolBar_redo');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test07_28', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //点击添加文本，拉起输入框
      const button = await assertClickById('textTab_default_on');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_29', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //输入文本
      let input = await driver.findComponent(ON.id('text_edit_input_tab'));
      if(input){
        const text = 'test input text';
        await input.inputText(text);
        expect(input).assertInstanceOf('Object');
      }
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_30', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //点击空白处关闭
      const button = await assertClickById('textedit_textEditPage');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_31', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //点击退出编辑
      const button = await assertClickById('petalClip_topToolBar_back');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_02_Edit_Test07_32', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //点击取消
      const button = await assertClickById('advanced_dialog_button_0');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_33', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //点击保存
      const button = await assertClickById('petalClip_topToolBar_save');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_02_Edit_Test07_34', TestConstants.TEST_LEVEL_ZERO, endTask(async (driver: Driver) => {
      let save = await driver.findComponent(ON.text('覆盖原图'));
      await save.click();
      expect(save).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));
  });
}


