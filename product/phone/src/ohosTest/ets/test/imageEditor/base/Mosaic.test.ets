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
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { Driver, ON, PointerMatrix } from '@ohos.UiTest';
import {
  assertClickById,
  endTask,
  loggedTask,
  ShootStaticPhoto,
  SkipBootPage,
  StartCamera,
  StartPhotos,
  startTask,
  swipeIn,
  swipeSearch,
} from '../tools/steps';
import { describe, expect } from '@ohos/hypium';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import window from '@ohos.window';
import { Log } from '@ohos/tools/src/main/utils/Log';
import { PhotoType } from '../tools/constants';


const TAG: string = `${TestConstants.TAG}MosaicTest`;


async function EnterMosaic(driver: Driver) {
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
}

export default function mosaicTest(): void {
  describe('mosaicTest', () => {
    it('Task_07_Mosaic_Test01', TestConstants.TEST_LEVEL_ZERO, startTask(async (driver: Driver) => {
      // 点击马赛克按钮-切到马赛克界面
      await EnterMosaic(driver);
      await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
    }, PhotoType.StaticImage));

    it('Task_07_Mosaic_Test02', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //点击马赛克类型选择经典马赛克
      const component = await swipeSearch(ON.id('petalclip_videoMosaicTool_mosaicType_customScroll'),
        ON.id('petalclip_videoMosaicTool_mosaicType_customScroll'), 'right');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_07_Mosaic_Test03', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 调整画笔
      const component = await swipeIn(ON.id('PenSize_bar_view'));
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_07_Mosaic_Test04', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //开始涂抹
      const component = await swipeIn(ON.id('mosaicView'), 'right');
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
    }));

    it('Task_07_Mosaic_Test05', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //进入涂鸦
      const button =
        await assertClickById('petalClip_bottomToolBar_image_7');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

      const btn = await driver.findComponent(ON.text('知道了'));
      if (btn) {
        await btn.click();
      }
    }));

    it('Task_07_Mosaic_Test06', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 点击X退出涂鸦
      const button = await assertClickById('petalClip_stylus_cancel');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_07_Mosaic_Test07', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //开始涂抹
      const component = await swipeIn(ON.id('mosaicView'), 'right');
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
    }));

    it('Task_07_Mosaic_Test08', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 双指捏合放大
      let pointers01 = PointerMatrix.create(2, 3);
      pointers01.setPoint(0, 0, {
        x: 700, y: 1000,
      });
      pointers01.setPoint(0, 1, {
        x: 700, y: 900,
      });
      pointers01.setPoint(0, 2, {
        x: 700, y: 800,
      });
      pointers01.setPoint(1, 0, {
        x: 700, y: 1250,
      });
      pointers01.setPoint(1, 1, {
        x: 700, y: 1350,
      });
      pointers01.setPoint(1, 2, {
        x: 700, y: 1450,
      });
      const result01 = await driver.injectMultiPointerAction(pointers01);
      expect(result01).assertTrue();
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, 'ImmersiveComparedImage scaled');

      // 平移
      await driver.swipe(135, 904, 618, 884, 600);

      // 双指捏合缩小
      let pointers02 = PointerMatrix.create(2, 3);
      pointers02.setPoint(0, 0, {
        x: 700, y: 800,
      });
      pointers02.setPoint(0, 1, {
        x: 700, y: 900,
      });
      pointers02.setPoint(0, 2, {
        x: 700, y: 1000,
      });
      pointers02.setPoint(1, 0, {
        x: 700, y: 1450,
      });
      pointers02.setPoint(1, 1, {
        x: 700, y: 1350,
      });
      pointers02.setPoint(1, 2, {
        x: 700, y: 1250,
      });
      const result02 = await driver.injectMultiPointerAction(pointers02);
      expect(result02).assertTrue();
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_07_Mosaic_Test09', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //undo
      const button = await assertClickById('petalClip_topToolBar_undo');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_07_Mosaic_Test10', TestConstants.TEST_LEVEL_ZERO, endTask(async (driver: Driver) => {
      //redo
      const button = await assertClickById('petalClip_topToolBar_redo');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);

      //设置为横屏
      WindowUtil.setOrientation(window.Orientation.LANDSCAPE);
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);

      // 设为竖屏
      WindowUtil.setOrientation(window.Orientation.PORTRAIT);
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    }));

    it('Task_07_Mosaic_Test11', TestConstants.TEST_LEVEL_ZERO, startTask(async (driver: Driver) => {
      // 点击马赛克按钮-切到马赛克界面
      await EnterMosaic(driver);
      await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
    }, PhotoType.StaticImage));

    it('Task_07_Mosaic_Test12', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //点击马赛克类型选择3号图片马赛克
      const component = await swipeSearch(ON.id('petalclip_videoMosaicTool_mosaicType_customScroll'),
        ON.id('petalClip_mosaicSelection_item_image_mosaic_5'), 'right');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_07_Mosaic_Test13', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalClip_mosaicSelection_item_image_mosaic_3');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_07_Mosaic_Test14', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //开始涂抹
      Log.info(TAG, 'mosaic draw 1');
      const component = await swipeIn(ON.id('mosaicView'), 'right');
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    }));

    it('Task_07_Mosaic_Test15', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 点击AI编辑按钮-切到AI编辑
      const button = await assertClickById('petalclip_AiRetouch');
      expect(button).assertInstanceOf('Object');
      let confirmBtn = await driver.findComponent(ON.id('advanced_dialog_button_1'));
      if (confirmBtn) {
        await confirmBtn.click();
      }
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_07_Mosaic_Test16', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 点击AI编辑按钮-切回基础编辑
      const button = await assertClickById('petalclip_AiRetouch');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
    }));

    it('Task_07_Mosaic_Test17', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //开始涂抹
      Log.info(TAG, 'mosaic draw 2');
      const component = await swipeIn(ON.id('mosaicView'), 'right');
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
    }));

    it('Task_07_Mosaic_Test18', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //设置为横屏
      WindowUtil.setOrientation(window.Orientation.LANDSCAPE);
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);

      // 设为竖屏
      WindowUtil.setOrientation(window.Orientation.PORTRAIT);
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);

      //undo
      const button = await assertClickById('petalClip_topToolBar_undo');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_07_Mosaic_Test19', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //redo
      const button = await assertClickById('petalClip_topToolBar_redo');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_07_Mosaic_Test20', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //退出编辑
      const button = await assertClickById('petalClip_topToolBar_back');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);

    }));

    it('Task_07_Mosaic_Test21', TestConstants.TEST_LEVEL_ZERO, endTask(async (driver: Driver) => {
      //点击放弃更改
      const button = await assertClickById('advanced_dialog_button_1');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
    }));

    it('Task_07_Mosaic_Test22', TestConstants.TEST_LEVEL_ZERO, startTask(async (driver: Driver) => {
      // 点击马赛克按钮-切到马赛克界面
      await EnterMosaic(driver);
      await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
    }, PhotoType.StaticImage));

    it('Task_07_Mosaic_Test24', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //点击马赛克类型选择经典马赛克
      const component = await swipeSearch(ON.id('petalclip_videoMosaicTool_mosaicType_customScroll'),
        ON.id('petalclip_videoMosaicTool_mosaicType_customScroll'), 'right');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_07_Mosaic_Test25', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalClip_mosaicSelection_item_image_mosaic_1');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_07_Mosaic_Test26', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 调整画笔
      const component = await swipeIn(ON.id('PenSize_bar_view'));
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_07_Mosaic_Test27', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //开始涂抹
      const component = await swipeIn(ON.id('mosaicView'), 'right');
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    }));

    it('Task_07_Mosaic_Test28', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //点击马赛克类型选择橡皮擦
      const component = await swipeSearch(ON.id('petalclip_videoMosaicTool_mosaicType_customScroll'),
        ON.id('petalclip_videoMosaicTool_mosaicType_customScroll'), 'right');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_07_Mosaic_Test29', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalClip_mosaicSelection_item_image_mosaic_0');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_07_Mosaic_Test30', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //开始擦除
      const component = await swipeIn(ON.id('mosaicView'), 'right');
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    }));

    it('Task_07_Mosaic_Test31', TestConstants.TEST_LEVEL_ZERO, endTask(async (driver: Driver) => {
      //点击文本，退出马赛克
      const button = await assertClickById('petalClip_bottomToolBar_image_8');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TEN_SECOND);

      // 设置为横屏
      WindowUtil.setOrientation(window.Orientation.LANDSCAPE);
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);

      // 设为竖屏
      WindowUtil.setOrientation(window.Orientation.PORTRAIT);
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    }));

    it('Task_07_Mosaic_Test32', TestConstants.TEST_LEVEL_ZERO, startTask(async (driver: Driver) => {
      // 点击马赛克按钮-切到马赛克界面
      await EnterMosaic(driver);
      await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
    }, PhotoType.StaticImage));

    it('Task_07_Mosaic_Test33', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //选择图片马赛克
      const component = await swipeSearch(ON.id('petalclip_videoMosaicTool_mosaicType_customScroll'),
        ON.id('petalClip_mosaicSelection_item_image_mosaic_9'), 'right');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_07_Mosaic_Test34', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      const component = await swipeSearch(ON.id('petalclip_videoMosaicTool_mosaicType_customScroll'),
        ON.id('petalClip_mosaicSelection_item_image_mosaic_0'), 'left');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_07_Mosaic_Test35', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      const component = await swipeSearch(ON.id('petalclip_videoMosaicTool_mosaicType_customScroll'),
        ON.id('petalClip_mosaicSelection_item_image_mosaic_7'), 'right');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_07_Mosaic_Test36', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalClip_mosaicSelection_item_image_mosaic_6');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_07_Mosaic_Test37', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalClip_mosaicSelection_item_image_mosaic_5');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_07_Mosaic_Test38', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      // 调整画笔
      const component = await swipeIn(ON.id('PenSize_bar_view'));
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));

    it('Task_07_Mosaic_Test39', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //开始涂抹
      const component = await swipeIn(ON.id('mosaicView'), 'right');
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    }));

    it('Task_07_Mosaic_Test40', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //点击马赛克类型选择橡皮擦
      const component = await swipeSearch(ON.id('petalclip_videoMosaicTool_mosaicType_customScroll'),
        ON.id('petalClip_mosaicSelection_item_image_mosaic_0'), 'left');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_07_Mosaic_Test41', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalClip_mosaicSelection_item_image_mosaic_0');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_07_Mosaic_Test42', TestConstants.TEST_LEVEL_ZERO, endTask(async (driver: Driver) => {
      //开始擦除
      const component = await swipeIn(ON.id('mosaicView'), 'right');
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);

      //设置为横屏
      WindowUtil.setOrientation(window.Orientation.LANDSCAPE);
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);

      // 设为竖屏
      WindowUtil.setOrientation(window.Orientation.PORTRAIT);
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    }));

    it('Task_07_Mosaic_Test43', TestConstants.TEST_LEVEL_ZERO, startTask(async (driver: Driver) => {
      // 点击马赛克按钮-切到马赛克界面
      await EnterMosaic(driver);
      await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
    }, PhotoType.StaticImage));

    it('Task_07_Mosaic_Test44', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //点击马赛克类型选择橡皮擦
      const component = await swipeSearch(ON.id('petalclip_videoMosaicTool_mosaicType_customScroll'),
        ON.id('petalclip_videoMosaicTool_mosaicType_customScroll'), 'right');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_07_Mosaic_Test45', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalClip_mosaicSelection_item_image_mosaic_0');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_07_Mosaic_Test46', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //点击马赛克类型选择经典马赛克
      const button = await assertClickById('petalClip_mosaicSelection_item_image_mosaic_1');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_07_Mosaic_Test47', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //点击马赛克类型选择2号图片马赛克
      const button = await assertClickById('petalClip_mosaicSelection_item_image_mosaic_2');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_07_Mosaic_Test48', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //点击马赛克类型选择6号图片马赛克
      const component = await swipeSearch(ON.id('petalclip_videoMosaicTool_mosaicType_customScroll'),
        ON.id('petalClip_mosaicSelection_item_image_mosaic_5'), 'right');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_07_Mosaic_Test49', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      const component = await swipeSearch(ON.id('petalclip_videoMosaicTool_mosaicType_customScroll'),
        ON.id('petalClip_mosaicSelection_item_image_mosaic_9'), 'right');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_07_Mosaic_Test50', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      const button = await assertClickById('petalClip_mosaicSelection_item_image_mosaic_6');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_07_Mosaic_Test51', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      const component = await swipeSearch(ON.id('petalclip_videoMosaicTool_mosaicType_customScroll'),
        ON.id('petalClip_mosaicSelection_item_image_mosaic_2'), 'left');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_07_Mosaic_Test52', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //点击马赛克类型选择经典马赛克
      const button = await assertClickById('petalClip_mosaicSelection_item_image_mosaic_3');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }));

    it('Task_07_Mosaic_Test53', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //开始涂抹
      const component = await swipeIn(ON.id('mosaicView'), 'right');
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    }));

    it('Task_07_Mosaic_Test54', TestConstants.TEST_LEVEL_ZERO, endTask(async (driver: Driver) => {
      // save
      let component = await driver.findComponent(ON.id('petalClip_topToolBar_save').enabled(true));
      expect(component).assertInstanceOf('Object');
      if (component) {
        await component.click();
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
        const saveBtn = await driver.findComponent(ON.text('覆盖原图'));
        expect(saveBtn).assertInstanceOf('Object');
        if (saveBtn) {
          await saveBtn.click();
          await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
        }
      }
    }));
  });
}
