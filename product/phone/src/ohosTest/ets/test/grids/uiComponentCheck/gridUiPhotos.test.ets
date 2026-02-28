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

import { afterAll, beforeAll, describe, expect, Level } from '@ohos/hypium';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { ON } from '@ohos.UiTest';
import { UiComponentId } from '../../utils/UiComponentId';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';

/**
 * 不要使用Log.info, 使用dt.log.i(), 以方便定位当前执行的测试套
 * 每个用例测试完成之后必须回到大图界面
 * 本测试套用来check照片页每个元素是否正常
 */
export default function GridUiPhotosTest(): void {
  describe('GridUiPhotosTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      const dt = new Dt('beforeAllVideoShowTest');
      dt.log.i('beforeAll GridUiPhotosTest start');
      await AppStart.photos();
      await dt.timeline();
      dt.log.i('beforeAll GridUiPhotosTest finish');
    });

    it('Grid_Ui_Photos_001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 底部Bar"照片"是否正常
      await Grid_Ui_Photos_001(dt);
    });
    it('Grid_Ui_Photos_002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 多选
      await Grid_Ui_Photos_002(dt);
    });
    it('Grid_Ui_Photos_003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 搜索
      await Grid_Ui_Photos_003(dt);
    });
    it('Grid_Ui_Photos_004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 更多
      await Grid_Ui_Photos_004(dt);
    });
    it('Grid_Ui_Photos_005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 更多-设置
      await Grid_Ui_Photos_005(dt);
    });
    it('Grid_Ui_Photos_006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 更多-关于
      await Grid_Ui_Photos_006(dt);
    });
    it('Grid_Ui_Photos_007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 照片-左上角
      await Grid_Ui_Photos_007(dt);
    });
    it('Grid_Ui_Photos_008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 年视图
      await Grid_Ui_Photos_008(dt);
    });
    it('Grid_Ui_Photos_009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 月视图
      await Grid_Ui_Photos_009(dt);
    });
    it('Grid_Ui_Photos_010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 日视图
      await Grid_Ui_Photos_010(dt);
    });
    it('Grid_Ui_Photos_011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 年月日视图导航栏
      await Grid_Ui_Photos_011(dt);
    });
    it('Grid_Ui_Photos_012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 宫格元素
      await Grid_Ui_Photos_012(dt);
    });
  });
}

/**
 * 大图首页，
 * TAG:
 * 前置条件
 *
 */
async function Grid_Ui_Photos_001(dt: Dt) {
  dt.log.i('Grid_Ui_Photos_001 检查底部Bar的\'照片\' start');

  dt.log.i('预期结果1、存在照片这个文字');
  await dt.assertComponentByText('照片');

  dt.log.i('预期结果2、存在TabPhotos这个id');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.TAB_PHOTOS));
  expect(comp).not().assertNull();
  const isClickable = await comp.isClickable();
  expect(isClickable).assertTrue();

  dt.log.i('Grid_Ui_Photos_001 end');
}

/**
 * 大图首页，多选按钮
 * TAG:
 * 前置条件
 *
 */
async function Grid_Ui_Photos_002(dt: Dt) {
  dt.log.i('Grid_Ui_Photos_002 检查宫格多选按钮 start');

  dt.log.i('预期结果1、存在AccessibilityComponentMultiSelected这个id');

  dt.log.i('预期结果2、存在\'多选\'文字');
  const text2 = await dt.driver.findComponent(ON.text('多选'));
  expect(text2).not().assertNull();

  dt.log.i('Grid_Ui_Photos_002 end');
}

/**
 * 大图首页，搜索
 * TAG:
 * 前置条件
 *
 */
async function Grid_Ui_Photos_003(dt: Dt) {
  dt.log.i('Grid_Ui_Photos_003 检查宫格搜索按钮 start');

  dt.log.i('预期结果1、存在ActionBarButtonSearch这个id');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_SEARCH));
  expect(comp).not().assertNull();

  dt.log.i('Grid_Ui_Photos_003 end');
}

/**
 * 大图首页，更多对应的四个点
 * TAG:
 * 前置条件
 *
 */
async function Grid_Ui_Photos_004(dt: Dt) {
  dt.log.i('Grid_Ui_Photos_004 检查宫格更多按钮 start');

  dt.log.i('预期结果1、存在ActionButton_More对应的Button');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_MORE));
  expect(comp).not().assertNull();

  dt.log.i('Grid_Ui_Photos_004 end');
}

/**
 * 宫格首页，更多对应的四个点，关于
 * TAG:
 * 前置条件
 *
 */
async function Grid_Ui_Photos_005(dt: Dt) {
  dt.log.i('Grid_Ui_Photos_005 检查宫格更多-设置按钮 start');
  dt.log.i('预期结果1、存在ActionButton_More对应的Button');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_MORE));
  expect(comp).not().assertNull();

  dt.log.i('点击更多按钮')
  await dt.assertClick(UiComponentId.PHOTOS_MORE);

  dt.log.i('预期结果2，存在设置对应的id：ActionBarButton_Text_GallerySettings');
  const settingComp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_MORE_SETTING));
  expect(settingComp).not().assertNull();

  dt.log.i('预期结果3，存在设置对应的文字');
  const settingCompText = await dt.driver.findComponent(ON.text('设置'));
  expect(settingCompText).not().assertNull();

  dt.log.i('恢复环境，再次点击更多按钮')
  await dt.assertClick(UiComponentId.PHOTOS_MORE);

  dt.log.i('Grid_Ui_Photos_005 end');
}

/**
 * 宫格首页，更多对应的四个点，关于
 * TAG:
 * 前置条件
 *
 */
async function Grid_Ui_Photos_006(dt: Dt) {
  dt.log.i('Grid_Ui_Photos_006 检查宫格更多-设置按钮 start');

  dt.log.i('预期结果1、存在ActionButton_More对应的Button');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_MORE));
  expect(comp).not().assertNull();

  dt.log.i('点击更多按钮')
  await dt.assertClick(UiComponentId.PHOTOS_MORE);

  dt.log.i('预期结果2，存在关于对应的id：ActionBarButton_Text_ActionButton_About');
  const aboutComp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_MORE_ABOUT));
  expect(aboutComp).not().assertNull();

  dt.log.i('预期结果3，存在关于对应的文字');
  const aboutCompText = await dt.driver.findComponent(ON.text('关于'));
  expect(aboutCompText).not().assertNull();

  dt.log.i('恢复环境，再次点击更多按钮')
  await dt.assertClick(UiComponentId.PHOTOS_MORE);

  dt.log.i('Grid_Ui_Photos_006 end');
}

/**
 * 宫格首页，左上角时间信息，主标题
 * TAG:
 * 前置条件
 *
 */
async function Grid_Ui_Photos_007(dt: Dt) {
  dt.log.i('Grid_Ui_Photos_007 检查宫格左上角主标题 start');

  dt.log.i('预期结果1、存在MainTitle的控件');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_MAIN_TITLE));
  expect(comp).not().assertNull();

  dt.log.i('Grid_Ui_Photos_007 end');
}

/**
 * 宫格首页，年
 * TAG:
 * 前置条件
 *
 */
async function Grid_Ui_Photos_008(dt: Dt) {
  dt.log.i('Grid_Ui_Photos_008 检查宫格 年 start');

  dt.log.i('预期结果1、存在\'年\'对应的控件');
  const comp = await dt.driver.findComponent(ON.text('年'));
  expect(comp).not().assertNull();

  const compType = await comp.getType();
  dt.log.i('预期结果2 控件类型: ' + compType)
  expect(compType).assertEqual('Text')

  dt.log.i('Grid_Ui_Photos_008 end');
}

/**
 * 宫格首页，月
 * TAG:
 * 前置条件
 *
 */
async function Grid_Ui_Photos_009(dt: Dt) {
  dt.log.i('Grid_Ui_Photos_009 检查宫格 月 start');

  dt.log.i('预期结果1、存在\'月\'对应的控件');
  const comp = await dt.driver.findComponent(ON.text('月'));
  expect(comp).not().assertNull();

  const compType = await comp.getType();
  dt.log.i('预期结果2 控件类型: ' + compType)
  expect(compType).assertEqual('Text')

  dt.log.i('Grid_Ui_Photos_009 end');
}

/**
 * 宫格首页，日
 * TAG:
 * 前置条件
 *
 */
async function Grid_Ui_Photos_010(dt: Dt) {
  dt.log.i('Grid_Ui_Photos_010 检查宫格 日 start');

  dt.log.i('预期结果1、存在\'日\'对应的控件');
  const comp = await dt.driver.findComponent(ON.text('日'));
  expect(comp).not().assertNull();

  const compType = await comp.getType();
  dt.log.i('预期结果2 控件类型: ' + compType)
  expect(compType).assertEqual('Text')

  dt.log.i('Grid_Ui_Photos_010 end');
}

/**
 * 宫格首页，年月日导航栏
 * TAG:
 * 前置条件
 *
 */
async function Grid_Ui_Photos_011(dt: Dt) {
  dt.log.i('Grid_Ui_Photos_011 检查宫格 年月日导航栏 start');

  dt.log.i('预期结果1、存在\'日\'对应的控件');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_SWITCH));
  expect(comp).not().assertNull();

  dt.log.i('Grid_Ui_Photos_011 end');
}

/**
 * 宫格首页，宫格元素，前提是有图片
 * TAG:
 * 前置条件
 *
 */
async function Grid_Ui_Photos_012(dt: Dt) {
  dt.log.i('Grid_Ui_Photos_012 检查宫格 宫格元素 start');

  dt.log.i('预期结果2、存在photoGridView_gird_1对应的控件');
  const item = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_GRID_VIEW_ITEM));
  expect(item).not().assertNull();
  const isClickable = await item.isClickable();
  expect(isClickable).assertTrue();

  dt.log.i('Grid_Ui_Photos_012 end');
}