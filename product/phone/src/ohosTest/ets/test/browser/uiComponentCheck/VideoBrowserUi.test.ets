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
import { UiComponentId } from '../../utils/UiComponentId';

/**
 * 不要使用Log.info, 使用dt.log.i(), 以方便定位当前执行的测试套
 * 每个用例测试完成之后必须回到大图界面
 * 本测试套用来check照片页每个元素是否正常
 */
export default function VideoBrowserUiTest(): void {
  describe('VideoBrowserUiTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('VideoBrowserUiTest').init();
      dt.log.i('beforeAll VideoBrowserUiTest start');
      await AppStart.photos();
      dt.log.i('beforeAll VideoBrowserUiTest finish');
    });
    it('beforeVideoBrowserUiTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.videoBrowser();
    });
    it('Browser_Ui_Video_001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-返回
      await Browser_Ui_Video_001(dt);
    });
    it('Browser_Ui_Video_002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-返回
      await Browser_Ui_Video_002(dt);
    });
    it('Browser_Ui_Video_003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-返回
      await Browser_Ui_Video_003(dt);
    });
    it('Browser_Ui_Video_004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-返回
      await Browser_Ui_Video_004(dt);
    });
    it('Browser_Ui_Video_005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-返回
      await Browser_Ui_Video_005(dt);
    });
    it('Browser_Ui_Video_006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-返回
      await Browser_Ui_Video_006(dt);
    });
    it('Browser_Ui_Video_007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-返回
      await Browser_Ui_Video_007(dt);
    });
    it('Browser_Ui_Video_008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-返回
      await Browser_Ui_Video_008(dt);
    });
    it('Browser_Ui_Video_009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-返回
      await Browser_Ui_Video_009(dt);
    });
    it('Browser_Ui_Video_010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-返回
      await Browser_Ui_Video_010(dt);
    });
    it('Browser_Ui_Video_011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-返回
      await Browser_Ui_Video_011(dt);
    });
    it('Browser_Ui_Video_012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-返回
      await Browser_Ui_Video_012(dt);
    });
    it('Browser_Ui_Video_013', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-返回
      await Browser_Ui_Video_013(dt);
    });
    it('Browser_Ui_Video_014', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-返回
      await Browser_Ui_Video_014(dt);
    });
    it('Browser_Ui_Video_015', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-返回
      await Browser_Ui_Video_015(dt);
    });
    it('Browser_Ui_Video_016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      // 大图-返回
      await Browser_Ui_Video_016(dt);
    });
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllVideoBrowserUiTest').init();
      await dt.clickIfExist(UiComponentId.PHOTOS_BROWSER_BACK);
      dt.log.i('返回当前相册');
      await dt.clickIfExist(UiComponentId.GRID_BACK_ALBUMS);
      dt.log.i('返回相册页');
      dt.log.i('afterAll VideoBrowserUiTest finish');
    });
  });
}

/**
 * 大图-ActionBar
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Video_001(dt: Dt) {
  dt.log.i('Browser_Ui_Video_001 视频大图-ActionBar start');
  dt.log.i('预期结果1、存在browser_ActionBarView这个id');
  await dt.assertComponent(UiComponentId.PHOTOS_BROWSER_ACTIONBARVIEW);
  dt.log.i('Browser_Ui_Video_001 end');
}

/**
 * 大图-返回
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Video_002(dt: Dt) {
  dt.log.i('Browser_Ui_Video_002 视频大图-返回 start');
  dt.log.i('预期结果1、存在More_Image_Back这个id');
  await dt.assertComponent(UiComponentId.PHOTOS_BROWSER_BACK);
  dt.log.i('预期结果2、存在AccessibilityComponent_BrowserBack这个id');
  await dt.assertComponentClickable(UiComponentId.PHOTOS_BROWSER_BACK_BUTTON);
  dt.log.i('Browser_Ui_Video_002 end');
}

/**
 * 大图-日期
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Video_003(dt: Dt) {
  dt.log.i('Browser_Ui_Video_003 视频大图-日期标题 start');
  dt.log.i('预期结果1、存在PhotoBrowserDateTitle这个id');
  await dt.assertComponent(UiComponentId.PHOTOS_BROWSER_DATE_TITLE);
  dt.log.i('Browser_Ui_Video_003 end');
}

/**
 * 大图-时间
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Video_004(dt: Dt) {
  dt.log.i('Browser_Ui_Video_004 大图-时间 start');
  dt.log.i('预期结果1、存在PhotoBrowserTimeLocationTitle这个id');
  await dt.assertComponent(UiComponentId.PHOTOS_BROWSER_TIME_LOCATION);
  dt.log.i('Browser_Ui_Video_004 end');
}

/**
 * 大图-截图
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Video_005(dt: Dt) {
  dt.log.i('Browser_Ui_Video_005 大图-截图 start');
  dt.log.i('预期结果1、存在PhotoBrowserActionBarButtonvideoScreenshot这个id');
  await dt.assertComponentClickable(UiComponentId.PHOTOS_BROWSER_VIDEOSCREENSHOT_BUTTON);
  dt.log.i('预期结果2、存在More_Image_videoScreenshot这个id');
  await dt.assertComponent(UiComponentId.PHOTOS_BROWSER_VIDEOSCREENSHOT);
  dt.log.i('Browser_Ui_Video_005 end');
}

/**
 * 大图-更多
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Video_006(dt: Dt) {
  dt.log.i('Browser_Ui_Video_006 大图-更多 start');
  dt.log.i('预期结果1、存在PhotoBrowserActionBarButtonMore这个id');
  await dt.assertComponentClickable(UiComponentId.PHOTOS_BROWSER_BACK_BUTTON);
  dt.log.i('预期结果2、存在More_Image_More这个id');
  await dt.assertComponent(UiComponentId.PHOTOS_BROWSER_MORE);
  dt.log.i('Browser_Ui_Video_006 end');
}

/**
 * 大图-视频播放按钮
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Video_007(dt: Dt) {
  dt.log.i('Browser_Ui_Video_007 大图-更多 start');
  dt.log.i('预期结果1、存在VideoPlayButton这个id');
  await dt.assertComponentClickable(UiComponentId.PHOTOS_BROWSER_VIDEOPLAY_BUTTON);
  dt.log.i('Browser_Ui_Video_007 end');
}

/**
 * 大图-缩略图预览
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Video_008(dt: Dt) {
  dt.log.i('Browser_Ui_Video_008 大图-缩略图预览 start');
  dt.log.i('预期结果1、存在PhotoBrowserPreviewBar对应的Button');
  await dt.assertComponent(UiComponentId.PHOTOS_BROWSER_PREVIEW_BAR);
  dt.log.i('Browser_Ui_Video_008 end');
}

/**
 * 大图-分享
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Video_009(dt: Dt) {
  dt.log.i('Browser_Ui_Video_009 大图-分享 start');
  dt.log.i('预期结果1、存在ToolBarButtonShare对应的Button');
  await dt.assertComponentClickable(UiComponentId.PHOTOS_BROWSER_TOOL_BAR_SHARE);
  dt.log.i('Browser_Ui_Video_009 end');
}

/**
 * 大图-收藏
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Video_010(dt: Dt) {
  dt.log.i('Browser_Ui_Video_010 大图-收藏 start');
  dt.log.i('预期结果1、存在ToolBarButtonFavor的控件');
  await dt.assertComponentClickable(UiComponentId.PHOTOS_BROWSER_TOOL_BAR_FAVORITE);
  dt.log.i('Browser_Ui_Video_010 end');
}

/**
 * 大图-编辑
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Video_011(dt: Dt) {
  dt.log.i('Browser_Ui_Video_011 大图-编辑 start');
  dt.log.i('预期结果1、存在ToolBarButtonEdit对应的控件');
  await dt.assertComponentClickable(UiComponentId.PHOTOS_BROWSER_TOOL_BAR_EDIT);
  dt.log.i('Browser_Ui_Video_011 end');
}

/**
 * 大图-删除
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Video_012(dt: Dt) {
  dt.log.i('Browser_Ui_Video_012 大图-删除 start');
  dt.log.i('预期结果1、存在ToolBarButtonDelete对应的控件');
  await dt.assertComponentClickable(UiComponentId.PHOTOS_BROWSER_TOOL_BAR_DELETE);
  dt.log.i('Browser_Ui_Video_012 end');
}

/**
 * 视频播放大图-暂停按钮
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Video_013(dt: Dt) {
  dt.log.i('Browser_Ui_Video_013 视频播放大图-暂停按钮 start');
  dt.log.i('步骤1、点击播放按钮');
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_VIDEOPLAY_BUTTON,true, 20);
  dt.log.i('预期结果1、存在ToolBarButtonvideoPlay对应的控件');
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_TOOLBAR_PAUSE);
  dt.log.i('Browser_Ui_Video_013 end');
}

/**
 * 视频播放大图-播放按钮
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Video_014(dt: Dt) {
  dt.log.i('Browser_Ui_Video_014 视频播放大图-播放按钮 start');
  dt.log.i('预期结果1、存在ToolBarButtonvideoPause对应的控件');
  await dt.assertComponentClickable(UiComponentId.PHOTOS_BROWSER_TOOLBAR_PLAY);
  dt.log.i('Browser_Ui_Video_014 end');
}

/**
 * 视频播放大图-静音按钮
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Video_015(dt: Dt) {
  dt.log.i('Browser_Ui_Video_015 视频播放大图-静音按钮 start');
  dt.log.i('预期结果1、存在ToolBarButtonsoundFilled对应的控件');
  await dt.assertComponentClickable(UiComponentId.PHOTOS_BROWSER_TOOLBAR_SOUND_FILLED);
  dt.log.i('Browser_Ui_Video_015 end');
}

/**
 * 视频播放大图-取消静音按钮
 * TAG:
 * 前置条件
 *
 */
async function Browser_Ui_Video_016(dt: Dt) {
  dt.log.i('Browser_Ui_Video_016 视频播放大图-静音按钮 start');
  dt.log.i('预期结果1、存在ToolBarButtonsound_off_filled对应的控件');
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_TOOLBAR_SOUND_FILLED)
  await dt.assertComponentClickable(UiComponentId.PHOTOS_BROWSER_TOOLBAR_SOUND_OFFFILLED);
  dt.log.i('Browser_Ui_Video_016 end');
}