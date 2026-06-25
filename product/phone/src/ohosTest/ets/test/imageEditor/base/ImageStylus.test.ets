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
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { Driver, ON, PointerMatrix } from '@ohos.UiTest';
import {
  assertClickById,
  endTask,
  getTask,
  loggedTask,
  ShootStaticPhoto,
  SkipBootPage,
  StartCamera,
  StartPhotos,
  startTask,
  swipeIn,
  swipeSearch,
  swipeTo,
  testClickById,
} from '../tools/steps';
import { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import { window } from '@kit.ArkUI';
import { PhotoType } from '../tools/constants';


const TAG: string = `${TestConstants.TAG}ImageStylusTest`;

export default function imageStylusTest(): void {
  describe('ImageStylusTest_1', () => {
    it('Task_01_Edit_Graffiti_Test03', TestConstants.TEST_LEVEL_ZERO,
      getTask(Task_01_Edit_Graffiti_Test03, PhotoType.StaticImage));
    it('Task_01_Edit_Graffiti_Test04', TestConstants.TEST_LEVEL_ZERO,
      getTask(Task_01_Edit_Graffiti_Test04, PhotoType.StaticImage));
    it('Task_01_Edit_Graffiti_Test05', TestConstants.TEST_LEVEL_ZERO,
      getTask(Task_01_Edit_Graffiti_Test05, PhotoType.StaticImage));
  });

  //涂鸦中的保存
  describe('ImageStylusPaintSaveTest',()=>{
    it('Task_Image_Styles_Save_0', TestConstants.TEST_LEVEL_ZERO,
      startTask(Task_Image_Styles_Save_0, PhotoType.StaticImage));
    it('Task_Image_Styles_Save_1', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_Styles_Save_1));
    it('Task_Image_Styles_Save_2', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_Styles_Save_2));
    it('Task_Image_Styles_Save_3', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_Styles_Save_3));
    it('Task_Image_Styles_Save_4', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_Styles_Save_4));
    it('Task_Image_Styles_Save_5', TestConstants.TEST_LEVEL_ZERO, endTask(Task_Image_Styles_Save_5));
  })

  //拖动裁剪边框各边中点
  describe('ImageScaleSelectionFrostTest',()=>{
    it('Task_Image_ScaleSelection_Frost_0', TestConstants.TEST_LEVEL_ZERO,
      startTask(Task_Image_ScaleSelection_Frost_0, PhotoType.StaticImage));
    it('Task_Image_ScaleSelection_Frost_1', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_Frost_1));
    it('Task_Image_ScaleSelection_Frost_2', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_Frost_2));
    it('Task_Image_ScaleSelection_Frost_3', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_Frost_3));
    it('Task_Image_ScaleSelection_Frost_4', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_Frost_4));
    it('Task_Image_ScaleSelection_Frost_5', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_Frost_5));
    it('Task_Image_ScaleSelection_Frost_6', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_Frost_6));
    it('Task_Image_ScaleSelection_Frost_7', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_Frost_7));
    it('Task_Image_ScaleSelection_Frost_8', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_Frost_8));
    it('Task_Image_ScaleSelection_Frost_9', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_Frost_9));
    it('Task_Image_ScaleSelection_Frost_10', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_Frost_10));
    it('Task_Image_ScaleSelection_Frost_11', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_Frost_11));
    it('Task_Image_ScaleSelection_Frost_12', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_Frost_12));
    it('Task_Image_ScaleSelection_Frost_13', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_Frost_13));
    it('Task_Image_ScaleSelection_Frost_14', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_Frost_14));
    it('Task_Image_ScaleSelection_Frost_15', TestConstants.TEST_LEVEL_ZERO, endTask(Task_Image_ScaleSelection_Frost_15));
  })

  // 拖动裁剪边框各角
  describe('ImageScaleSelectionCornerTest',()=>{
    it('Task_Image_ScaleSelection_corner_0', TestConstants.TEST_LEVEL_ZERO,
      startTask(Task_Image_ScaleSelection_corner_0, PhotoType.StaticImage));
    it('Task_Image_ScaleSelection_corner_1', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_corner_1));
    it('Task_Image_ScaleSelection_corner_2', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_corner_2));
    it('Task_Image_ScaleSelection_corner_3', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_corner_3));
    it('Task_Image_ScaleSelection_corner_4', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_corner_4));
    it('Task_Image_ScaleSelection_corner_5', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_corner_5));
    it('Task_Image_ScaleSelection_corner_6', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_corner_6));
    it('Task_Image_ScaleSelection_corner_7', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_corner_7));
    it('Task_Image_ScaleSelection_corner_8', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_corner_8));
    it('Task_Image_ScaleSelection_corner_9', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_corner_9));
    it('Task_Image_ScaleSelection_corner_10', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_corner_10));
    it('Task_Image_ScaleSelection_corner_11', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_corner_11));
    it('Task_Image_ScaleSelection_corner_12', TestConstants.TEST_LEVEL_ZERO, loggedTask(Task_Image_ScaleSelection_corner_12));
    it('Task_Image_ScaleSelection_corner_13', TestConstants.TEST_LEVEL_ZERO, endTask(Task_Image_ScaleSelection_corner_13));
  })

  describe('ImageStylusPaintTest_2', () => {
    it('Task_01_Edit_Graffiti_Test01_0', TestConstants.TEST_LEVEL_ZERO, startTask(async () => {
      //点击手写笔
      const comment = await swipeSearch(ON.id('petalClip_bottomToolBar_TabsBar'),
        ON.id('petalClip_bottomToolBar_image_7'), 'right');
      expect(comment).assertInstanceOf('Object');
    }, PhotoType.StaticImage));

    it('Task_01_Edit_Graffiti_Test01_1', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
     const button= await assertClickById('petalClip_bottomToolBar_image_7');
      expect(button).assertInstanceOf('Object');
    }));

  it('Task_01_Edit_Graffiti_Test01_2', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver:Driver) => {
    const btn = await driver.findComponent(ON.text('知道了'));
    if (btn) {
      await btn.click();
    }
    await driver.delayMs(TestConstants.DELAY_FOUR_SECOND);
    //点击铅笔
    const button=await assertClickById('noteToolPencil');
    expect(button).assertInstanceOf('Object');
    }));

    it('Task_01_Edit_Graffiti_Test01_3', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //开始手写
      const component=await swipeIn(ON.id('handWriteComp'), 'right');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_01_Edit_Graffiti_Test01_4', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //撤销
      const button = await assertClickById('petalClip_stylus_undo');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_01_Edit_Graffiti_Test01_5', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //复原
      const button =await assertClickById('petalClip_stylus_redo');
      expect(button).assertInstanceOf('Object');
    }));

   it('Task_01_Edit_Graffiti_Test01_6', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
     //点击颜色库
    const button= await assertClickById('noteToolPaintColorButton');
     expect(button).assertInstanceOf('Object');
    }));

  it('Task_01_Edit_Graffiti_Test01_7', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
    //选择颜色
    const button=await assertClickById('noteToolPaintColorPopupBox_5_1');
    expect(button).assertInstanceOf('Object');
    }));

    it('Task_01_Edit_Graffiti_Test01_8', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //点击关闭颜色库
      const button=await assertClickById('noteToolPaintColorButton');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_01_Edit_Graffiti_Test01_9', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //开始手写
      const component = await swipeIn(ON.id('handWriteComp'), 'bottom');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_01_Edit_Graffiti_Test01_10', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //切换颜色
      const button= await assertClickById('noteToolPaintColorList_1');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_01_Edit_Graffiti_Test01_11', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //开始手写
      const component =await swipeIn(ON.id('handWriteComp'), 'top');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_01_Edit_Graffiti_Test01_12', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //撤销
      const button = await assertClickById('petalClip_stylus_undo');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_01_Edit_Graffiti_Test01_13', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //复原
      const button = await assertClickById('petalClip_stylus_redo');
      expect(button).assertInstanceOf('Object');
    }));

     it('Task_01_Edit_Graffiti_Test01_14', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
       // 点击X退出涂鸦
       const button = await assertClickById('petalClip_stylus_cancel');
       expect(button).assertInstanceOf('Object');
    }));

     it('Task_01_Edit_Graffiti_Test01_15', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
       // 点击取消
       const button = await assertClickById('advanced_dialog_button_0');
       expect(button).assertInstanceOf('Object');
    }));

  it('Task_01_Edit_Graffiti_Test01_16', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
       // 点击X退出涂鸦
       const button = await assertClickById('petalClip_stylus_cancel');
       expect(button).assertInstanceOf('Object');
    }));

  it('Task_01_Edit_Graffiti_Test01_17', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
       // 点击放弃更改
       const button = await assertClickById('advanced_dialog_button_1');
       expect(button).assertInstanceOf('Object');
    }));

    it('Task_01_Edit_Graffiti_Test01_18', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //点击手写笔
      const component = await swipeSearch(ON.id('petalClip_bottomToolBar_TabsBar'),
        ON.id('petalClip_bottomToolBar_image_7'), 'right');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_01_Edit_Graffiti_Test01_19', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      const button = await assertClickById('petalClip_bottomToolBar_image_7');
      expect(button).assertInstanceOf('Object');
    }));
    it('Task_01_Edit_Graffiti_Test01_20', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //点击铅笔
      const button=await assertClickById('noteToolPencil');
      expect(button).assertInstanceOf('Object');
    }));
    it('Task_01_Edit_Graffiti_Test01_21', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver:Driver) => {
      //开始手写
      const component = await swipeIn(ON.id('handWriteComp'), 'right');
      expect(component).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));
    it('Task_01_Edit_Graffiti_Test01_22', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver:Driver) => {
      //双指捏合拉至最左边
      let pointers01 = PointerMatrix.create(2, 3);
      pointers01.setPoint(0, 0, {
        x: 1200, y: 1400,
      });
      pointers01.setPoint(0, 1, {
        x: 900, y: 1450,
      });
      pointers01.setPoint(0, 2, {
        x: 600, y: 1500,
      });
      pointers01.setPoint(1, 0, {
        x: 1000, y: 1100,
      });
      pointers01.setPoint(1, 1, {
        x: 700, y: 1150,
      });
      pointers01.setPoint(1, 2, {
        x: 400, y: 1200,
      });
      const result01 = await driver.injectMultiPointerAction(pointers01);
      expect(result01).assertTrue();
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);

      //双指捏合拉至最右边
      let pointers02 = PointerMatrix.create(2, 3);
      pointers02.setPoint(0, 0, {
        x: 100, y: 1400,
      });
      pointers02.setPoint(0, 1, {
        x: 400, y: 1450,
      });
      pointers02.setPoint(0, 2, {
        x: 700, y: 1500,
      });
      pointers02.setPoint(1, 0, {
        x: 300, y: 1100,
      });
      pointers02.setPoint(1, 1, {
        x: 600, y: 1150,
      });
      pointers02.setPoint(1, 2, {
        x: 900, y: 1200,
      });
      const result02 = await driver.injectMultiPointerAction(pointers02);
      expect(result02).assertTrue();
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));
    it('Task_01_Edit_Graffiti_Test01_23', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver:Driver) => {
      // 设为横屏
      WindowUtil.setOrientation(window.Orientation.LANDSCAPE);
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);

      let orientation = await WindowUtil.getPreferredOrientation();
      expect(orientation).assertEqual(window.Orientation.LANDSCAPE);

      // 设为竖屏
      WindowUtil.setOrientation(window.Orientation.PORTRAIT);
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);

      orientation = await WindowUtil.getPreferredOrientation();
      expect(orientation).assertEqual(window.Orientation.PORTRAIT);
    }));
    it('Task_01_Edit_Graffiti_Test01_24', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver:Driver) => {
      //点击对号
      const button=await assertClickById('petalClip_stylus_save');
      expect(button).assertInstanceOf('Object');
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }));
    it('Task_01_Edit_Graffiti_Test01_25', TestConstants.TEST_LEVEL_ZERO, endTask(async (driver:Driver) => {
      // save
      let component = await driver.findComponent(ON.id('petalClip_topToolBar_save').enabled(true));
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

  describe('ImageStylusPaintTest_3', () => {
    it('Task_01_Edit_Graffiti_Test02_1', TestConstants.TEST_LEVEL_ZERO, startTask(async () => {
      //点击手写笔
      const component = await swipeSearch(ON.id('petalClip_bottomToolBar_TabsBar'),
        ON.id('petalClip_bottomToolBar_image_7'), 'right');
      expect(component).assertInstanceOf('Object');
    }, PhotoType.StaticImage));

    it('Task_01_Edit_Graffiti_Test02_2', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver:Driver) => {
      const button =
        await assertClickById('petalClip_bottomToolBar_image_7');
      expect(button).assertInstanceOf('Object');

      const btn = await driver.findComponent(ON.text('知道了'));
      if (btn) {
        await btn.click();
      }
    }));

    it('Task_01_Edit_Graffiti_Test02_3', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //点击设置
      const button = await assertClickById('noteToolSettings');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_01_Edit_Graffiti_Test02_4', TestConstants.TEST_LEVEL_ZERO, loggedTask(async (driver: Driver) => {
      //点击开启抬笔成形
      const toggle = await driver.findComponent(ON.type('Toggle').isAfter(ON.text('抬笔成形')));
      await toggle.click();
      //点击圆珠笔
      const button = await assertClickById('noteToolBallPoint');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_01_Edit_Graffiti_Test02_5', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //开始手写
      const component = await swipeIn(ON.id('handWriteComp'), 'right');
      expect(component).assertInstanceOf('Object');
    }));

    it('Task_01_Edit_Graffiti_Test02_6', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //撤销
      const button =await assertClickById('petalClip_stylus_undo');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_01_Edit_Graffiti_Test02_7', TestConstants.TEST_LEVEL_ZERO, loggedTask(async () => {
      //复原
      const button = await assertClickById('petalClip_stylus_redo');
      expect(button).assertInstanceOf('Object');
    }));

    it('Task_01_Edit_Graffiti_Test02_8', TestConstants.TEST_LEVEL_ZERO, endTask(async (driver: Driver) => {
      //点击设置
      const button = await assertClickById('noteToolSettings');
      expect(button).assertInstanceOf('Object');
      //点击关闭抬笔成形
      const toggle = await driver.findComponent(ON.type('Toggle').isAfter(ON.text('抬笔成形')));
      await toggle.click();
    }));
  });
}

async function Task_Image_Styles_Save_0(driver:Driver){
  //点击手写笔
  const component = await swipeSearch(ON.id('petalClip_bottomToolBar_TabsBar'),
    ON.id('petalClip_bottomToolBar_image_7'), 'right');
  expect(component).assertInstanceOf('Object');
}

async function Task_Image_Styles_Save_1(driver:Driver){
  const button = await assertClickById('petalClip_bottomToolBar_image_7');
  expect(button).assertInstanceOf('Object');
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
}

async function Task_Image_Styles_Save_2(driver:Driver){
  //开始手写
  const component = await swipeIn(ON.id('handWriteComp'));
  expect(component).assertInstanceOf('Object');
}

async function Task_Image_Styles_Save_3(driver:Driver){
  //撤销
  const button = await assertClickById('petalClip_stylus_undo');
  expect(button).assertInstanceOf('Object');
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
}

async function Task_Image_Styles_Save_4(driver:Driver){
  //复原
  const button = await assertClickById('petalClip_stylus_redo');
  expect(button).assertInstanceOf('Object');
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
}
async function Task_Image_Styles_Save_5(driver:Driver){
  //退出
  const button = await assertClickById('petalClip_stylus_cancel');
  expect(button).assertInstanceOf('Object');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
}

async function Task_Image_ScaleSelection_Frost_0(driver:Driver){
  //点击比例
  const button = await assertClickById('cropTab_ratio_off');
  expect(button).assertInstanceOf('Object');
}

async function Task_Image_ScaleSelection_Frost_1(driver:Driver){
  //滑动
  const component =
    await swipeSearch(ON.id('petalclip_ScaleSelection_ScaleSelection'), ON.id('petalclip_ScaleSelection_3'));
  expect(component).assertInstanceOf('Object');
}

async function Task_Image_ScaleSelection_Frost_2(driver:Driver){
  //点击1:1
  const button = await assertClickById('petalclip_ScaleSelection_3');
  expect(button).assertInstanceOf('Object');
}
async function Task_Image_ScaleSelection_Frost_3(driver:Driver){
  const component = await swipeTo(ON.id('petalClip_frostedGlass_rect_topMiddle'), { dx: 0, dy: 100 });
  expect(component).assertInstanceOf('Object');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
}

async function Task_Image_ScaleSelection_Frost_4(driver:Driver){
  const component = await swipeTo(ON.id('petalClip_frostedGlass_rect_topMiddle'), { dx: 0, dy: -100 });
  expect(component).assertInstanceOf('Object');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
}

async function Task_Image_ScaleSelection_Frost_5(driver:Driver){
  const button = await assertClickById('petalClip_topToolBar_undo');
  expect(button).assertInstanceOf('Object');
}

async function Task_Image_ScaleSelection_Frost_6(driver:Driver){
  const component = await swipeTo(ON.id('petalClip_frostedGlass_rect_middleBottom'), { dx: 0, dy: 100 });
  expect(component).assertInstanceOf('Object');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
}

async function Task_Image_ScaleSelection_Frost_7(driver:Driver){
  const component = await swipeTo(ON.id('petalClip_frostedGlass_rect_middleBottom'), { dx: 0, dy: -100 });
  expect(component).assertInstanceOf('Object');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
}
async function Task_Image_ScaleSelection_Frost_8(driver:Driver){
  const button = await assertClickById('petalClip_topToolBar_undo');
  expect(button).assertInstanceOf('Object');
}

async function Task_Image_ScaleSelection_Frost_9(driver:Driver){
  const button = await swipeTo(ON.id('petalClip_frostedGlass_rect_middleBottom'), { dx: 100, dy: 0 });
  expect(button).assertInstanceOf('Object');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
}

async function Task_Image_ScaleSelection_Frost_10(driver:Driver){
  const button = await swipeTo(ON.id('petalClip_frostedGlass_rect_middleBottom'), { dx: -100, dy: 0 });
  expect(button).assertInstanceOf('Object');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
}

async function Task_Image_ScaleSelection_Frost_11(driver:Driver){
  const button = await assertClickById('petalClip_topToolBar_undo');
  expect(button).assertInstanceOf('Object');
}

async function Task_Image_ScaleSelection_Frost_12(driver:Driver){
  const component = await swipeTo(ON.id('petalClip_frostedGlass_rect_rightMiddle'), { dx: -100, dy: 0 });
  expect(component).assertInstanceOf('Object');
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
}

async function Task_Image_ScaleSelection_Frost_13(driver:Driver){
  const button = await assertClickById('petalClip_topToolBar_undo');
  expect(button).assertInstanceOf('Object');
}
async function Task_Image_ScaleSelection_Frost_14(driver:Driver){
  //点击退出编辑
  const button = await assertClickById('petalClip_topToolBar_back');
  expect(button).assertInstanceOf('Object');
}
async function Task_Image_ScaleSelection_Frost_15(driver:Driver){
  //点击放弃更改
  const button = await assertClickById('advanced_dialog_button_1');
  expect(button).assertInstanceOf('Object');
}

async function Task_Image_ScaleSelection_corner_0(driver:Driver){
  //点击比例
  const button = await assertClickById('cropTab_ratio_off');
  expect(button).assertInstanceOf('Object');
}

async function Task_Image_ScaleSelection_corner_1(driver:Driver){
  //滑动
  const component = await swipeSearch(ON.id('petalclip_ScaleSelection_ScaleSelection'), ON.id('petalclip_ScaleSelection_3'));
  expect(component).assertInstanceOf('Object');
}

async function Task_Image_ScaleSelection_corner_2(driver:Driver){
  //点击1:1
  const button = await assertClickById('petalclip_ScaleSelection_3');
  expect(button).assertInstanceOf('Object');
}

async function Task_Image_ScaleSelection_corner_3(driver:Driver){
  // 拖拽裁剪框左上角和右上角控件向下
  const component = await swipeTo(ON.id('petalClip_frostedGlass_rect_leftTop'), { dx: 100, dy: 100 });
  expect(component).assertInstanceOf('Object');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
}

async function Task_Image_ScaleSelection_corner_4(driver:Driver){
  const button = await assertClickById('petalClip_topToolBar_undo');
  expect(button).assertInstanceOf('Object');
}

async function Task_Image_ScaleSelection_corner_5(driver:Driver){
  const component = await swipeTo(ON.id('petalClip_frostedGlass_rect_rightTop'), { dx: -100, dy: 100 });
  expect(component).assertInstanceOf('Object');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
}

async function Task_Image_ScaleSelection_corner_6(driver:Driver){
  const button = await assertClickById('petalClip_topToolBar_undo');
  expect(button).assertInstanceOf('Object');
}

async function Task_Image_ScaleSelection_corner_7(driver:Driver){
  // 拖拽裁剪框左下角和右下角控件向上
  const component = await swipeTo(ON.id('petalClip_frostedGlass_rect_leftBottom'), { dx: 100, dy: -100 });
  expect(component).assertInstanceOf('Object');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
}

async function Task_Image_ScaleSelection_corner_8(driver:Driver){
  const button = await assertClickById('petalClip_topToolBar_undo');
  expect(button).assertInstanceOf('Object');
}

async function Task_Image_ScaleSelection_corner_9(driver:Driver){
  const component = await swipeTo(ON.id('petalClip_frostedGlass_rect_rightBottom'), { dx: -100, dy: -100 });
  expect(component).assertInstanceOf('Object');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
}
async function Task_Image_ScaleSelection_corner_10(driver:Driver){
  const button = await assertClickById('petalClip_topToolBar_undo');
  expect(button).assertInstanceOf('Object');
}

async function Task_Image_ScaleSelection_corner_11(driver:Driver){
  //点击退出编辑
  const button = await assertClickById('petalClip_topToolBar_back');
  expect(button).assertInstanceOf('Object');
}

async function Task_Image_ScaleSelection_corner_12(driver:Driver){
  //点击放弃更改
  const button = await assertClickById('advanced_dialog_button_1');
  expect(button).assertInstanceOf('Object');
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
}

async function Task_Image_ScaleSelection_corner_13(driver:Driver){
  //返回宫格
  const button = await assertClickById('More_Image_Back');
  expect(button).assertInstanceOf('Object');
}

//涂鸦画布拉至最左边和最右边
async function Task_01_Edit_Graffiti_Test03(driver: Driver) {
  //点击手写笔
  await swipeSearch(ON.id('petalClip_bottomToolBar_TabsBar'),
    ON.id('petalClip_bottomToolBar_image_7'), 'right');
  await testClickById(driver, 'petalClip_bottomToolBar_image_7', 'petalClip_bottomToolBar_image_7 clicked');
  //双指捏合拉至最左边
  let pointers01 = PointerMatrix.create(2, 3);
  pointers01.setPoint(0, 0, {
    x: 1200, y: 1400,
  });
  pointers01.setPoint(0, 1, {
    x: 900, y: 1450,
  });
  pointers01.setPoint(0, 2, {
    x: 600, y: 1500,
  });
  pointers01.setPoint(1, 0, {
    x: 1000, y: 1100,
  });
  pointers01.setPoint(1, 1, {
    x: 700, y: 1150,
  });
  pointers01.setPoint(1, 2, {
    x: 400, y: 1200,
  });
  const result01 = await driver.injectMultiPointerAction(pointers01);
  expect(result01).assertTrue();
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  //双指捏合拉至最右边
  let pointers02 = PointerMatrix.create(2, 3);
  pointers02.setPoint(0, 0, {
    x: 100, y: 1400,
  });
  pointers02.setPoint(0, 1, {
    x: 400, y: 1450,
  });
  pointers02.setPoint(0, 2, {
    x: 700, y: 1500,
  });
  pointers02.setPoint(1, 0, {
    x: 300, y: 1100,
  });
  pointers02.setPoint(1, 1, {
    x: 600, y: 1150,
  });
  pointers02.setPoint(1, 2, {
    x: 900, y: 1200,
  });
  const result02 = await driver.injectMultiPointerAction(pointers02);
  expect(result02).assertTrue();
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
}


//涂鸦画布拉至最小
async function Task_01_Edit_Graffiti_Test04(driver: Driver) {
  //点击手写笔
  await swipeSearch(ON.id('petalClip_bottomToolBar_TabsBar'),
    ON.id('petalClip_bottomToolBar_image_7'), 'right');
  await assertClickById('petalClip_bottomToolBar_image_7');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
}
//涂鸦画布拉至最小
async function Task_01_Edit_Graffiti_Test05(driver: Driver) {
  //双指捏合拉至最小
  let pointers01 = PointerMatrix.create(2, 2);
  pointers01.setPoint(0, 0, {
    x: 650, y: 580,
  });
  pointers01.setPoint(0, 1, {
    x: 650, y: 660,
  });
  pointers01.setPoint(1, 0, {
    x: 650, y: 1760,
  });
  pointers01.setPoint(1, 1, {
    x: 650, y: 1680,
  });
  await driver.injectMultiPointerAction(pointers01);
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
}