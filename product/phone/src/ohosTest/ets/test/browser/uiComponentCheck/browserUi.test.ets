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

import { beforeAll, describe, Level, expect, afterAll } from '@ohos/hypium';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { ON } from '@ohos.UiTest';
import { UiComponentId } from '../../utils/UiComponentId';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';

/**
 * 不要使用Log.info, 使用dt.log.i(), 以方便定位当前执行的测试套
 * 每个用例测试完成之后必须回到大图界面
 * 本测试套用来check照片页每个元素是否正常
 */
export default function BrowserUiTest(): void {
  describe('BrowserUiTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('BrowserUiTest').init();
      dt.log.i('beforeAll BrowserUiTest start');
      await AppStart.photos();
      // await dt.browser();
      dt.log.i('beforeAll BrowserUiTest finish');
    });
    it('beforeBrowserUiTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });
    it('Browser_Ui_Image_001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-返回
      await Browser_Ui_Image_001(dt);
    });
    it('Browser_Ui_Image_002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-日期
      await Browser_Ui_Image_002(dt);
    });
    it('Browser_Ui_Image_003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-时间
      await Browser_Ui_Image_003(dt);
    });
    it('Browser_Ui_Image_004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-更多
      await Browser_Ui_Image_004(dt);
    });
    it('Browser_Ui_Image_005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-缩略图预览条
      await Browser_Ui_Image_005(dt);
    });
    it('Browser_Ui_Image_006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-分享
      await Browser_Ui_Image_006(dt);
    });
    it('Browser_Ui_Image_007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-收藏
      await Browser_Ui_Image_007(dt);
    });
    it('Browser_Ui_Image_008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-编辑
      await Browser_Ui_Image_008(dt);
    });
    it('Browser_Ui_Image_009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-删除
      await Browser_Ui_Image_009(dt);
    });
    // 退出大图 执行测试套完成之后, 应保持在大图页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllPhotoPropertiesTest').init();
      await Exit.browser();
      dt.log.i('afterAll PhotoProperties finish');
    });
  });
}

/**
 * 大图-返回
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Image_001(dt: Dt) {
  dt.log.i('Browser_Ui_Image_001 大图-返回 start');

  dt.log.i('预期结果1、存在More_Image_Back这个id');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_BACK));
  expect(comp).not().assertNull();

  dt.log.i('预期结果2、存在AccessibilityComponent_BrowserBack这个id');
  const compBtn = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_BACK_BUTTON));
  expect(compBtn).not().assertNull();
  const isClickable = await compBtn.isClickable();
  expect(isClickable).assertTrue();
  const isEnabled = await compBtn.isEnabled();
  expect(isEnabled).assertTrue();

  dt.log.i('Browser_Ui_Image_001 end');
}

/**
 * 大图-日期
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Image_002(dt: Dt) {
  dt.log.i('Browser_Ui_Image_002 大图-日期 start');

  dt.log.i('预期结果1、存在PhotoBrowserDateTitle这个id');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_DATE_TITLE));
  expect(comp).not().assertNull();

  dt.log.i('Browser_Ui_Image_002 end');
}

/**
 * 大图-时间
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Image_003(dt: Dt) {
  dt.log.i('Browser_Ui_Image_003 大图-时间 start');

  dt.log.i('预期结果1、存在PhotoBrowserTimeLocationTitle这个id');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_TIME_LOCATION));
  expect(comp).not().assertNull();

  dt.log.i('Browser_Ui_Image_003 end');
}

/**
 * 大图首页，更多对应的四个点
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Image_004(dt: Dt) {
  dt.log.i('Browser_Ui_Image_004 大图-更多 start');

  dt.log.i('预期结果1、存在More_Image_More对应的Button');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_MORE));
  expect(comp).not().assertNull();

  dt.log.i('Browser_Ui_Image_004 end');
}

/**
 * 大图-缩略图预览
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Image_005(dt: Dt) {
  dt.log.i('Browser_Ui_Image_005 大图-缩略图预览 start');

  dt.log.i('预期结果1、存在PhotoBrowserPreviewBar对应的Button');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_PREVIEW_BAR));
  expect(comp).not().assertNull();

  dt.log.i('Browser_Ui_Image_005 end');
}

/**
 * 大图-分享
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Image_006(dt: Dt) {
  dt.log.i('Browser_Ui_Image_006 大图-分享 start');

  dt.log.i('预期结果1、存在ToolBarButtonShare对应的Button');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_TOOL_BAR_SHARE));
  expect(comp).not().assertNull();
  const isClickable = await comp.isClickable();
  expect(isClickable).assertTrue();
  const isEnabled = await comp.isEnabled();
  expect(isEnabled).assertTrue();

  dt.log.i('Browser_Ui_Image_006 end');
}

/**
 * 大图-收藏
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Image_007(dt: Dt) {
  dt.log.i('Browser_Ui_Image_007 大图-收藏 start');

  dt.log.i('预期结果1、存在ToolBarButtonFavor的控件');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_TOOL_BAR_FAVORITE));
  expect(comp).not().assertNull();
  const isClickable = await comp.isClickable();
  expect(isClickable).assertTrue();
  const isEnabled = await comp.isEnabled();
  expect(isEnabled).assertTrue();

  dt.log.i('Browser_Ui_Image_007 end');
}

/**
 * 大图-编辑
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Image_008(dt: Dt) {
  dt.log.i('Browser_Ui_Image_008 大图-编辑 start');

  dt.log.i('预期结果1、存在ToolBarButtonEdit对应的控件');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_TOOL_BAR_EDIT));
  expect(comp).not().assertNull();
  const isClickable = await comp.isClickable();
  expect(isClickable).assertTrue();
  const isEnabled = await comp.isEnabled();
  expect(isEnabled).assertTrue();

  dt.log.i('Browser_Ui_Image_008 end');
}

/**
 * 大图-删除
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Image_009(dt: Dt) {
  dt.log.i('Browser_Ui_Image_009 大图-删除 start');

  dt.log.i('预期结果1、存在ToolBarButtonDelete对应的控件');
  const comp = await dt.driver.findComponent(ON.id(UiComponentId.PHOTOS_BROWSER_TOOL_BAR_DELETE));
  expect(comp).not().assertNull();
  const isClickable = await comp.isClickable();
  expect(isClickable).assertTrue();
  const isEnabled = await comp.isEnabled();
  expect(isEnabled).assertTrue();

  dt.log.i('Browser_Ui_Image_009 end');
}
