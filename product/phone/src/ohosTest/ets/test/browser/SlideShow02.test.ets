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

import { afterAll, afterEach, beforeAll, describe, expect, Level } from '@ohos/hypium';
import { Component, Driver, On, ON, Point } from '@ohos.UiTest';
import { abilityDelegator, run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';

export default function DemoUi(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('DemoUiTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllDemoUi').init();
      dt.log.i('beforeAll DemoUi start');
      dt.log.i('beforeAll DemoUi finish');
    });
    /**
     * 打开大图
     */
    run('beforeDemoUi', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('Multimedia_Gallery_Slideshow_021', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [修改播放幻灯片时间间隔不影响时刻相册自己带幻灯片播放时间间隔] TID: Multimedia_Gallery_Slideshow_021
      await Multimedia_Gallery_Slideshow_021(dt);
    });
    run('Multimedia_Gallery_Slideshow_022', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片分屏] TID: Multimedia_Gallery_Slideshow_022
      await Multimedia_Gallery_Slideshow_022(dt);
    });
    run('Multimedia_Gallery_Slideshow_023', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片分屏后上下互换1] TID: Multimedia_Gallery_Slideshow_023
      await Multimedia_Gallery_Slideshow_023(dt);
    });
    run('Multimedia_Gallery_Slideshow_024', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片分屏后上下互换2] TID: Multimedia_Gallery_Slideshow_024
      await Multimedia_Gallery_Slideshow_024(dt);
    });
    run('Multimedia_Gallery_Slideshow_025', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片分屏后左右分屏（xxx）] TID: Multimedia_Gallery_Slideshow_025
      await Multimedia_Gallery_Slideshow_025(dt);
    });
    run('Multimedia_Gallery_Slideshow_026', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片分屏后左右分屏左右互换（xxx）] TID: Multimedia_Gallery_Slideshow_026
      await Multimedia_Gallery_Slideshow_026(dt);
    });
    run('Multimedia_Gallery_Slideshow_027', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片分屏最大化窗口] TID: Multimedia_Gallery_Slideshow_027
      await Multimedia_Gallery_Slideshow_027(dt);
    });
    run('Multimedia_Gallery_Slideshow_028', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片分屏切换悬浮窗] TID: Multimedia_Gallery_Slideshow_028
      await Multimedia_Gallery_Slideshow_028(dt);
    });
    run('Multimedia_Gallery_Slideshow_029', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片分屏切换关闭窗口] TID: Multimedia_Gallery_Slideshow_029
      await Multimedia_Gallery_Slideshow_029(dt);
    });
    run('Multimedia_Gallery_Slideshow_030', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片悬浮窗] TID: Multimedia_Gallery_Slideshow_030
      await Multimedia_Gallery_Slideshow_030(dt);
    });
    run('Multimedia_Gallery_Slideshow_031', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片悬浮窗最小化] TID: Multimedia_Gallery_Slideshow_031
      await Multimedia_Gallery_Slideshow_031(dt);
    });
    run('Multimedia_Gallery_Slideshow_032', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片悬浮窗最大化1] TID: Multimedia_Gallery_Slideshow_032
      await Multimedia_Gallery_Slideshow_032(dt);
    });
    run('Multimedia_Gallery_Slideshow_033', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片悬浮窗最大化2] TID: Multimedia_Gallery_Slideshow_033
      await Multimedia_Gallery_Slideshow_033(dt);
    });
    run('Multimedia_Gallery_Slideshow_034', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片悬浮窗关闭1] TID: Multimedia_Gallery_Slideshow_034
      await Multimedia_Gallery_Slideshow_034(dt);
    });
    run('Multimedia_Gallery_Slideshow_035', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片悬浮窗关闭2] TID: Multimedia_Gallery_Slideshow_035
      await Multimedia_Gallery_Slideshow_035(dt);
    });
    run('Multimedia_Gallery_Slideshow_036', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-拖拽用例: [播放幻灯片悬浮窗拖拽] TID: Multimedia_Gallery_Slideshow_036
      await Multimedia_Gallery_Slideshow_036(dt);
    });
    run('Multimedia_Gallery_Slideshow_037', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-拖拽用例: [播放幻灯片悬浮窗小窗拖拽] TID: Multimedia_Gallery_Slideshow_037
      await Multimedia_Gallery_Slideshow_037(dt);
    });
    run('Multimedia_Gallery_Slideshow_038', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-拖拽用例: [播放幻灯片悬浮窗小窗拖拽关闭] TID: Multimedia_Gallery_Slideshow_038
      await Multimedia_Gallery_Slideshow_038(dt);
    });
    run('Multimedia_Gallery_Slideshow_039', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-拖拽用例: [播放幻灯片悬浮窗小窗拖拽最大化] TID: Multimedia_Gallery_Slideshow_039
      await Multimedia_Gallery_Slideshow_039(dt);
    });
    run('Multimedia_Gallery_Slideshow_040', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片悬浮窗桌面操作] TID: Multimedia_Gallery_Slideshow_040
      await Multimedia_Gallery_Slideshow_040(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachDemoUi').init();
      dt.log.i('afterEach DemoUi start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach DemoUi finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllDemoUi').init();
      dt.log.i('afterAll DemoUi start');
      await Exit.browser();
      dt.log.i('afterAll DemoUi finish');
    });
  });
}

// DT步骤
/**
 * 大图-动态照片: [修改播放幻灯片时间间隔不影响时刻相册自己带幻灯片播放时间间隔]
 * TAG: 832 TID: Multimedia_Gallery_Slideshow_021
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 * 3、手机经过智慧分析，有分析出时刻相册
 */
async function Multimedia_Gallery_Slideshow_021(dt: Dt) {
  dt.log.i('修改播放幻灯片时间间隔不影响时刻相册自己带幻灯片播放时间间隔 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片，且有时刻相册');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.assertTextClick('时刻相册', false, DELAY.default);
  await dt.assertComponent('MomentAlbumComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、进入图库，点击右上角四方菜单，选择设置');
  await dt.albumList();
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('设置', false, DELAY.default);
  await dt.sleep();

  dt.log.i('STEP 2、选择修改时间间隔为3/5/10/15秒(位于本地空间释放下方，图库网络连接上方)');
  await dt.assertComponent('SettingsComponent', true);
  await dt.assertTextClick('幻灯片时间间隔', false, DELAY.default);
  await dt.assertTextClick('15秒', false, DELAY.default);
  await dt.sleep();

  dt.log.i('STEP 3、点击进入时刻相册');
  await dt.assertTextClick('时刻相册', false, DELAY.default);
  await dt.assertComponent('MomentAlbumComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、点击一个进入时刻，观察时刻照片播放幻灯片');
  await dt.assertComponentClickable('MomentItem', true);
  await dt.assertClick('MomentItem', false, DELAY.default);
  await dt.assertComponent('MomentSlideshowComponent', true);
  await dt.sleep(3000);
  await dt.assertComponent('MomentSlideshowComponent', true);
  await dt.sleep();

  dt.log.i('预期结果4、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）播放幻灯片观察每张照片之间的播放长为3秒');
  await dt.assertComponent('MomentSlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('MomentSlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('修改播放幻灯片时间间隔不影响时刻相册自己带幻灯片播放时间间隔 end');
}

/**
 * 大图-进入大图: [播放幻灯片分屏]
 * TAG: 831 TID: Multimedia_Gallery_Slideshow_022
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_022(dt: Dt) {
  dt.log.i('播放幻灯片分屏 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至左上角分屏，再点击桌面设置');
  await dt.driver.swipe(500, 1000, 100, 100, 300);
  await dt.assertComponentClickable('SettingsAppIcon', true);
  await dt.assertClick('SettingsAppIcon', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果3、分屏持续播放幻灯片');
  await dt.assertComponent('SplitScreenComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片分屏 end');
}

/**
 * 大图-进入大图: [播放幻灯片分屏后上下互换1]
 * TAG: 833 TID: Multimedia_Gallery_Slideshow_023
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_023(dt: Dt) {
  dt.log.i('播放幻灯片分屏后上下互换1 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至左上角分屏，再点击桌面设置');
  await dt.driver.swipe(500, 1000, 100, 100, 300);
  await dt.assertComponentClickable('SettingsAppIcon', true);
  await dt.assertClick('SettingsAppIcon', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果3、分屏持续播放幻灯片');
  await dt.assertComponent('SplitScreenComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、点击两个任务中间的三个点，点击上下互换');
  await dt.assertComponentClickable('TaskMenuButton', true);
  await dt.assertClick('TaskMenuButton', false, DELAY.default);
  await dt.assertTextClick('上下互换', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、弹出上下互换，互换成功，持续播放幻灯片');
  await dt.assertComponent('SplitScreenComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片分屏后上下互换1 end');
}

/**
 * 大图-进入大图: [播放幻灯片分屏后上下互换2]
 * TAG: 834 TID: Multimedia_Gallery_Slideshow_024
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_024(dt: Dt) {
  dt.log.i('播放幻灯片分屏后上下互换2 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至左上角分屏，再点击桌面设置');
  await dt.driver.swipe(500, 1000, 100, 100, 300);
  await dt.assertComponentClickable('SettingsAppIcon', true);
  await dt.assertClick('SettingsAppIcon', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果3、分屏持续播放幻灯片');
  await dt.assertComponent('SplitScreenComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、按住图库任务上方的三个点，拖动至另一个任务');
  await dt.assertComponentClickable('TaskMenuButton', true);
  await dt.assertLongClickById('TaskMenuButton', DELAY.default);
  await dt.driver.swipe(500, 500, 500, 800, 300);
  await dt.sleep();

  dt.log.i('预期结果4、上下互换，持续播放幻灯片，互换动效无卡顿');
  await dt.assertComponent('SplitScreenComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片分屏后上下互换2 end');
}

/**
 * 大图-进入大图: [播放幻灯片分屏后左右分屏（xxx）]
 * TAG: 835 TID: Multimedia_Gallery_Slideshow_025
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_025(dt: Dt) {
  dt.log.i('播放幻灯片分屏后左右分屏（xxx） start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至左上角分屏，再点击桌面设置');
  await dt.driver.swipe(500, 1000, 100, 100, 300);
  await dt.assertComponentClickable('SettingsAppIcon', true);
  await dt.assertClick('SettingsAppIcon', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果3、分屏持续播放幻灯片');
  await dt.assertComponent('SplitScreenComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、点击两个任务中间的三个点，点击左右分屏');
  await dt.assertComponentClickable('TaskMenuButton', true);
  await dt.assertClick('TaskMenuButton', false, DELAY.default);
  await dt.assertTextClick('左右分屏', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、弹出左右分屏，左右分屏成功，持续播放幻灯片');
  await dt.assertComponent('SplitScreenComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片分屏后左右分屏（xxx） end');
}

/**
 * 大图-进入大图: [播放幻灯片分屏后左右分屏左右互换（xxx）]
 * TAG: 836 TID: Multimedia_Gallery_Slideshow_026
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_026(dt: Dt) {
  dt.log.i('播放幻灯片分屏后左右分屏左右互换（xxx） start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至左上角分屏，再点击桌面设置');
  await dt.driver.swipe(500, 1000, 100, 100, 300);
  await dt.assertComponentClickable('SettingsAppIcon Grinder', true);
  await dt.assertClick('SettingsAppIcon', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果3、分屏持续播放幻灯片');
  await dt.assertComponent('SplitScreenComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、点击两个任务中间的三个点，点击左右分屏');
  await dt.assertComponentClickable('TaskMenuButton', true);
  await dt.assertClick('TaskMenuButton', false, DELAY.default);
  await dt.assertTextClick('左右分屏', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、弹出左右分屏，左右分屏成功，持续播放幻灯片');
  await dt.assertComponent('SplitScreenComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5、点击两个任务中间的三个点，点击左右互换');
  await dt.assertComponentClickable('TaskMenuButton', true);
  await dt.assertClick('TaskMenuButton', false, DELAY.default);
  await dt.assertTextClick('左右互换', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果5、左右互换成功，幻灯片持续播放');
  await dt.assertComponent('SplitScreenComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片分屏后左右分屏左右互换（xxx） end');
}

/**
 * 大图-进入大图: [播放幻灯片分屏最大化窗口]
 * TAG: 837 TID: Multimedia_Gallery_Slideshow_027
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_027(dt: Dt) {
  dt.log.i('播放幻灯片分屏最大化窗口 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至左上角分屏，再点击桌面设置');
  await dt.driver.swipe(500, 1000, 100, 100, 300);
  await dt.assertComponentClickable('SettingsAppIcon', true);
  await dt.assertClick('SettingsAppIcon', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果3、分屏持续播放幻灯片');
  await dt.assertComponent('SplitScreenComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、点击图库任务上方中间的三个点，点击最大化窗口');
  await dt.assertComponentClickable('TaskMenuButton', true);
  await dt.assertClick('TaskMenuButton', false, DELAY.default);
  await dt.assertTextClick('最大化窗口', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、弹出最大化窗口，最大化成功，持续播放幻灯片');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.negateComponent('SplitScreenComponent');
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片分屏最大化窗口 end');
}

/**
 * 大图-进入大图: [播放幻灯片分屏切换悬浮窗]
 * TAG: 838 TID: Multimedia_Gallery_Slideshow_028
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_028(dt: Dt) {
  dt.log.i('播放幻灯片分屏切换悬浮窗 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至左上角分屏，再点击桌面设置');
  await dt.driver.swipe(500, 1000, 100, 100, 300);
  await dt.assertComponentClickable('SettingsAppIcon', true);
  await dt.assertClick('SettingsAppIcon', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果3、分屏持续播放幻灯片');
  await dt.assertComponent('SplitScreenComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、点击图库任务上方中间的三个点，点击悬浮窗');
  await dt.assertComponentClickable('TaskMenuButton', true);
  await dt.assertClick('TaskMenuButton', false, DELAY.default);
  await dt.assertTextClick('悬浮窗', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、切换到悬浮窗，悬浮窗持续播放幻灯片');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片分屏切换悬浮窗 end');
}

/**
 * 大图-进入大图: [播放幻灯片分屏切换关闭窗口]
 * TAG: 839 TID: Multimedia_Gallery_Slideshow_029
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_029(dt: Dt) {
  dt.log.i('播放幻灯片分屏切换关闭窗口 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至左上角分屏，再点击桌面设置');
  await dt.driver.swipe(500, 1000, 100, 100, 300);
  await dt.assertComponentClickable('SettingsAppIcon', true);
  await dt.assertClick('SettingsAppIcon', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果3、分屏持续播放幻灯片');
  await dt.assertComponent('SplitScreenComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、点击图库任务上方中间的三个点，点击关闭窗口');
  await dt.assertComponentClickable('TaskMenuButton', true);
  await dt.assertClick('TaskMenuButton', false, DELAY.default);
  await dt.assertClick('关闭窗口', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、弹出关闭窗口，窗口关闭成功，幻灯片结束播放切换到另一个任务');
  await dt.negateComponent('SlideshowComponent');
  await dt.assertComponent('SettingsComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5、切换回图库');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('预期结果5、幻灯片结束播放');
  await dt.negateComponent('SlideshowComponent');
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片分屏切换关闭窗口 end');
}

/**
 * 大图-进入大图: [播放幻灯片悬浮窗]
 * TAG: 840 TID: Multimedia_Gallery_Slideshow_030
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_030(dt: Dt) {
  dt.log.i('播放幻灯片悬浮窗 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至右上角悬浮窗');
  await dt.driver.swipe(500, 1000, 900, 100, 300);
  await dt.sleep();

  dt.log.i('预期结果3、悬浮窗持续播放幻灯片，切换至桌面');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.assertComponent('DesktopComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、再点击右上角悬浮窗');
  await dt.assertComponentClickable('FloatingWindowComponent', true);
  await dt.assertClick('FloatingWindowComponent', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、悬浮窗放大');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片悬浮窗 end');
}

/**
 * 大图-进入大图: [播放幻灯片悬浮窗最小化]
 * TAG: 841 TID: Multimedia_Gallery_Slideshow_031
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_031(dt: Dt) {
  dt.log.i('播放幻灯片悬浮窗最小化 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至右上角悬浮窗');
  await dt.driver.swipe(500, 1000, 900, 100, 300);
  await dt.sleep();

  dt.log.i('预期结果3、悬浮窗持续播放幻灯片，切换至桌面');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.assertComponent('DesktopComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、再点击右上角悬浮窗');
  await dt.assertComponentClickable('FloatingWindowComponent', true);
  await dt.assertClick('FloatingWindowComponent', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、悬浮窗放大');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5、点击悬浮窗上方中间的三个点，点击最小化');
  await dt.assertComponentClickable('FloatingWindowMenuButton', true);
  await dt.assertClick('FloatingWindowMenuButton', false, DELAY.default);
  await dt.assertTextClick('最小化', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果5、最小化到右侧');
  await dt.assertComponent('MinimizedFloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('STEP 6、点击右侧最小化任务');
  await dt.assertComponentClickable('MinimizedFloatingWindowComponent', true);
  await dt.assertClick('MinimizedFloatingWindowComponent', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果6、悬浮窗变大，幻灯片停止播放');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.negateComponent('SlideshowComponent');
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片悬浮窗最小化 end');
}

/**
 * 大图-进入大图: [播放幻灯片悬浮窗最大化1]
 * TAG: 842 TID: Multimedia_Gallery_Slideshow_032
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_032(dt: Dt) {
  dt.log.i('播放幻灯片悬浮窗最大化1 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至右上角悬浮窗');
  await dt.driver.swipe(500, 1000, 900, 100, 300);
  await dt.sleep();

  dt.log.i('预期结果3、悬浮窗持续播放幻灯片，切换至桌面');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.assertComponent('DesktopComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、再点击右上角悬浮窗');
  await dt.assertComponentClickable('FloatingWindowComponent', true);
  await dt.assertClick('FloatingWindowComponent', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、悬浮窗放大');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5、点击悬浮窗上方中间的三个点，点击最大化');
  await dt.assertComponentClickable('FloatingWindowMenuButton', true);
  await dt.assertClick('FloatingWindowMenuButton', false, DELAY.default);
  await dt.assertTextClick('最大化', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果5、最大化至全屏，幻灯片持续播放');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.negateComponent('FloatingWindowComponent');
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片悬浮窗最大化1 end');
}

/**
 * 大图-进入大图: [播放幻灯片悬浮窗最大化2]
 * TAG: 843 TID: Multimedia_Gallery_Slideshow_033
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_033(dt: Dt) {
  dt.log.i('播放幻灯片悬浮窗最大化2 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至右上角悬浮窗');
  await dt.driver.swipe(500, 1000, 900, 100, 300);
  await dt.sleep();

  dt.log.i('预期结果3、悬浮窗持续播放幻灯片，切换至桌面');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.assertComponent('DesktopComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、再点击右上角悬浮窗');
  await dt.assertComponentClickable('FloatingWindowComponent', true);
  await dt.assertClick('FloatingWindowComponent', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、悬浮窗放大');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5、点击悬浮窗左上角的放大按钮');
  await dt.assertComponentClickable('FloatingWindowMaximizeButton', true);
  await dt.assertClick('FloatingWindowMaximizeButton', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果5、最大化至全屏，幻灯片持续播放');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.negateComponent('FloatingWindowComponent');
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片悬浮窗最大化2 end');
}

/**
 * 大图-进入大图: [播放幻灯片悬浮窗关闭1]
 * TAG: 844 TID: Multimedia_Gallery_Slideshow_034
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_034(dt: Dt) {
  dt.log.i('播放幻灯片悬浮窗关闭1 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至右上角悬浮窗');
  await dt.driver.swipe(500, 1000, 900, 100, 300);
  await dt.sleep();

  dt.log.i('预期结果3、悬浮窗持续播放幻灯片，切换至桌面');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.assertComponent('DesktopComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、再点击右上角悬浮窗');
  await dt.assertComponentClickable('FloatingWindowComponent', true);
  await dt.assertClick('FloatingWindowComponent', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、悬浮窗放大');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5、点击悬浮窗上方中间的三个点，点击关闭');
  await dt.assertComponentClickable('FloatingWindowMenuButton', true);
  await dt.assertClick('FloatingWindowMenuButton', false, DELAY.default);
  await dt.assertTextClick('关闭', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果5、悬浮窗关闭');
  await dt.negateComponent('FloatingWindowComponent');
  await dt.negateComponent('SlideshowComponent');
  await dt.sleep();

  dt.log.i('STEP 6、再次打开图库');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('预期结果6、幻灯片结束播放');
  await dt.negateComponent('SlideshowComponent');
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片悬浮窗关闭1 end');
}

/**
 * 大图-进入大图: [播放幻灯片悬浮窗关闭2]
 * TAG: 846 TID: Multimedia_Gallery_Slideshow_035
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_035(dt: Dt) {
  dt.log.i('播放幻灯片悬浮窗关闭2 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至右上角悬浮窗');
  await dt.driver.swipe(500, 1000, 900, 100, 300);
  await dt.sleep();

  dt.log.i('预期结果3、悬浮窗持续播放幻灯片，切换至桌面');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.assertComponent('DesktopComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、再点击右上角悬浮窗');
  await dt.assertComponentClickable('FloatingWindowComponent', true);
  await dt.assertClick('FloatingWindowComponent', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、悬浮窗放大');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5、点击悬浮窗右上角关闭按钮，点击关闭');
  await dt.assertComponentClickable('FloatingWindowCloseButton', true);
  await dt.assertClick('FloatingWindowCloseButton', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果5、悬浮窗关闭');
  await dt.negateComponent('FloatingWindowComponent');
  await dt.negateComponent('SlideshowComponent');
  await dt.sleep();

  dt.log.i('STEP 6、再次打开图库');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('预期结果6、幻灯片结束播放');
  await dt.negateComponent('SlideshowComponent');
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片悬浮窗关闭2 end');
}

/**
 * 大图-拖拽: [播放幻灯片悬浮窗拖拽]
 * TAG: 845 TID: Multimedia_Gallery_Slideshow_036
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_036(dt: Dt) {
  dt.log.i('播放幻灯片悬浮窗拖拽 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至右上角悬浮窗');
  await dt.driver.swipe(500, 1000, 900, 100, 300);
  await dt.sleep();

  dt.log.i('预期结果3、悬浮窗持续播放幻灯片，切换至桌面');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.assertComponent('DesktopComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、再点击右上角悬浮窗');
  await dt.assertComponentClickable('FloatingWindowComponent', true);
  await dt.assertClick('FloatingWindowComponent', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、悬浮窗放大');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5、手指按住悬浮窗上方中间的三个点，进行拖拽');
  await dt.assertComponentClickable('FloatingWindowMenuButton', true);
  await dt.assertLongClickById('FloatingWindowMenuButton', DELAY.default);
  await dt.driver.swipe(500, 100, 700, 300, 300);
  await dt.sleep();

  dt.log.i('预期结果5、悬浮窗跟随手指移动，幻灯片持续播放');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片悬浮窗拖拽 end');
}

/**
 * 大图-拖拽: [播放幻灯片悬浮窗小窗拖拽]
 * TAG: 847 TID: Multimedia_Gallery_Slideshow_037
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_037(dt: Dt) {
  dt.log.i('播放幻灯片悬浮窗小窗拖拽 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至右上角悬浮窗');
  await dt.driver.swipe(500, 1000, 900, 100, 300);
  await dt.sleep();

  dt.log.i('预期结果3、悬浮窗持续播放幻灯片，切换至桌面');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.assertComponent('DesktopComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、手指按住右上角悬浮窗，进行拖拽');
  await dt.assertComponentClickable('FloatingWindowComponent', true);
  await dt.assertLongClickById('FloatingWindowComponent', DELAY.default);
  await dt.driver.swipe(900, 100, 700, 300, 300);
  await dt.sleep();

  dt.log.i('预期结果4、窗跟随手指移动，幻灯片持续播放');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片悬浮窗小窗拖拽 end');
}

/**
 * 大图-拖拽: [播放幻灯片悬浮窗小窗拖拽关闭]
 * TAG: 848 TID: Multimedia_Gallery_Slideshow_038
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_038(dt: Dt) {
  dt.log.i('播放幻灯片悬浮窗小窗拖拽关闭 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至右上角悬浮窗');
  await dt.driver.swipe(500, 1000, 900, 100, 300);
  await dt.sleep();

  dt.log.i('预期结果3、悬浮窗持续播放幻灯片，切换至桌面');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.assertComponent('DesktopComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、手指按住右上角悬浮窗，拖拽至下方中间删除图标附近');
  await dt.assertComponentClickable('FloatingWindowComponent', true);
  await dt.assertLongClickById('FloatingWindowComponent', DELAY.default);
  await dt.driver.swipe(900, 100, 500, 1000, 300);
  await dt.sleep();

  dt.log.i('预期结果4、窗跟随手指移动，幻灯片持续播放，悬浮窗关闭');
  await dt.negateComponent('FloatingWindowComponent');
  await dt.negateComponent('SlideshowComponent');
  await dt.sleep();

  dt.log.i('STEP 5、再次打开图库');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('预期结果5、幻灯片停止播放');
  await dt.negateComponent('SlideshowComponent');
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片悬浮窗小窗拖拽关闭 end');
}

/**
 * 大图-拖拽: [播放幻灯片悬浮窗小窗拖拽最大化]
 * TAG: 849 TID: Multimedia_Gallery_Slideshow_039
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_039(dt: Dt) {
  dt.log.i('播放幻灯片悬浮窗小窗拖拽最大化 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至右上角悬浮窗');
  await dt.driver.swipe(500, 1000, 900, 100, 300);
  await dt.sleep();

  dt.log.i('预期结果3、悬浮窗持续播放幻灯片，切换至桌面');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.assertComponent('DesktopComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、手指按住右上角悬浮窗，拖拽至顶部');
  await dt.assertComponentClickable('FloatingWindowComponent', true);
  await dt.assertLongClickById('FloatingWindowComponent', DELAY.default);
  await dt.driver.swipe(900, 100, 900, 50, 300);
  await dt.sleep();

  dt.log.i('预期结果4、窗跟随手指移动，幻灯片持续播放，窗口最大化');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.negateComponent('FloatingWindowComponent');
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片悬浮窗小窗拖拽最大化 end');
}

/**
 * 大图-进入大图: [播放幻灯片悬浮窗桌面操作]
 * TAG: 851 TID: Multimedia_Gallery_Slideshow_040
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_040(dt: Dt) {
  dt.log.i('播放幻灯片悬浮窗桌面操作 start');
  dt.log.i('STEP 0、验证前置条件：确保图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、从底部上滑至右上角悬浮窗');
  await dt.driver.swipe(500, 1000, 900, 100, 300);
  await dt.sleep();

  dt.log.i('预期结果3、悬浮窗持续播放幻灯片，切换至桌面');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.assertComponent('DesktopComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、点击桌面任意应用（除图库）进行操作');
  await dt.assertComponentClickable('NonGalleryAppIcon', true);
  await dt.assertClick('NonGalleryAppIcon', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、桌面操作无影响，持续播放幻灯片');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片悬浮窗桌面操作 end');
}