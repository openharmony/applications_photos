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
    run('Multimedia_Gallery_Slideshow_041', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片调节悬浮窗大小] TID: Multimedia_Gallery_Slideshow_041
      await Multimedia_Gallery_Slideshow_041(dt);
    });
    run('Multimedia_Gallery_Slideshow_042', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片调节悬浮窗至最小自动回到右上角] TID: Multimedia_Gallery_Slideshow_042
      await Multimedia_Gallery_Slideshow_042(dt);
    });
    run('Multimedia_Gallery_Slideshow_043', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [幻灯片播放多任务] TID: Multimedia_Gallery_Slideshow_043
      await Multimedia_Gallery_Slideshow_043(dt);
    });
    run('Multimedia_Gallery_Slideshow_044', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [大字体播放幻灯片] TID: Multimedia_Gallery_Slideshow_044
      await Multimedia_Gallery_Slideshow_044(dt);
    });
    run('Multimedia_Gallery_Slideshow_045', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [关怀模式播放幻灯片] TID: Multimedia_Gallery_Slideshow_045
      await Multimedia_Gallery_Slideshow_045(dt);
    });
    run('Multimedia_Gallery_Slideshow_046', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [朗读模式播放幻灯片] TID: Multimedia_Gallery_Slideshow_046
      await Multimedia_Gallery_Slideshow_046(dt);
    });
    run('Multimedia_Gallery_Slideshow_047', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [多语言播放幻灯片（藏文）] TID: Multimedia_Gallery_Slideshow_047
      await Multimedia_Gallery_Slideshow_047(dt);
    });
    run('Multimedia_Gallery_Slideshow_048', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [多语言播放幻灯片（英文）] TID: Multimedia_Gallery_Slideshow_048
      await Multimedia_Gallery_Slideshow_048(dt);
    });
    run('Multimedia_Gallery_Slideshow_049', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [多语言播放幻灯片（繁体中文）] TID: Multimedia_Gallery_Slideshow_049
      await Multimedia_Gallery_Slideshow_049(dt);
    });
    run('Multimedia_Gallery_Slideshow_050', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [多语言播放幻灯片（维吾尔文）] TID: Multimedia_Gallery_Slideshow_050
      await Multimedia_Gallery_Slideshow_050(dt);
    });
    run('Multimedia_Gallery_Slideshow_051', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片途中接受分享图片] TID: Multimedia_Gallery_Slideshow_051
      await Multimedia_Gallery_Slideshow_051(dt);
    });
    run('Multimedia_Gallery_Slideshow_052', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片碰传接受方（接受）] TID: Multimedia_Gallery_Slideshow_052
      await Multimedia_Gallery_Slideshow_052(dt);
    });
    run('Multimedia_Gallery_Slideshow_053', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片碰传接受方（拒绝）] TID: Multimedia_Gallery_Slideshow_053
      await Multimedia_Gallery_Slideshow_053(dt);
    });
    run('Multimedia_Gallery_Slideshow_054', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放相册中全部照片] TID: Multimedia_Gallery_Slideshow_054
      await Multimedia_Gallery_Slideshow_054(dt);
    });
    run('Multimedia_Gallery_Slideshow_055', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [隐私空间播放幻灯片] TID: Multimedia_Gallery_Slideshow_055
      await Multimedia_Gallery_Slideshow_055(dt);
    });
    run('Multimedia_Gallery_Slideshow_056', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [播放幻灯片应用锁] TID: Multimedia_Gallery_Slideshow_056
      await Multimedia_Gallery_Slideshow_056(dt);
    });
    run('Multimedia_Gallery_Slideshow_057', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [播放幻灯片应用锁（打开应用退出后立即锁定）] TID: Multimedia_Gallery_Slideshow_057
      await Multimedia_Gallery_Slideshow_057(dt);
    });
    run('Multimedia_Gallery_Slideshow_058', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片过程中常亮] TID: Multimedia_Gallery_Slideshow_058
      await Multimedia_Gallery_Slideshow_058(dt);
    });
    run('Multimedia_Gallery_Slideshow_059', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片克隆（xxx）] TID: Multimedia_Gallery_Slideshow_059
      await Multimedia_Gallery_Slideshow_059(dt);
    });
    run('Multimedia_Gallery_Slideshow_060', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片克隆（xxx）] TID: Multimedia_Gallery_Slideshow_060
      await Multimedia_Gallery_Slideshow_060(dt);
    });
    run('Multimedia_Gallery_Slideshow_061', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [幻灯片播放双屏转单屏（xxx）] TID: Multimedia_Gallery_Slideshow_061
      await Multimedia_Gallery_Slideshow_061(dt);
    });
    run('Multimedia_Gallery_Slideshow_062', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [幻灯片播放单屏转双屏（xxx）] TID: Multimedia_Gallery_Slideshow_062
      await Multimedia_Gallery_Slideshow_062(dt);
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
 * 大图-进入大图: [播放幻灯片调节悬浮窗大小]
 * TAG: 850 TID: Multimedia_Gallery_Slideshow_041
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_041(dt: Dt) {
  dt.log.i('播放幻灯片调节悬浮窗大小 start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保设备为xxx手机且图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1: 在照片页中点击一张图片进入大图预览');
  dt.log.i('1.1、导航至照片页');
  await dt.browser();
  await dt.assertComponent('ImageGalleryComponent', true);
  dt.log.i('1.2、点击一张照片进入大图预览');
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertClick('PhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2: 点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('2.1、验证并点击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('2.2、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果2：成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3: 从底部上滑至右上角悬浮窗');
  dt.log.i('3.1、执行从底部到右上角的滑动操作');
  await dt.driver.swipe(400, 800, 900, 100, 300);
  await dt.sleep();
  dt.log.i('预期结果3：悬浮窗持续播放幻灯片，切换至桌面');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.assertComponent('DesktopComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4: 再次点击右上角悬浮窗');
  dt.log.i('4.1、验证并点击悬浮窗');
  await dt.assertComponentClickable('FloatingWindowComponent', true);
  await dt.assertClick('FloatingWindowComponent', false, DELAY.default);
  await dt.assertComponent('FloatingWindow_Enlarged', true);
  dt.log.i('预期结果4：悬浮窗放大成功');
  await dt.sleep();

  dt.log.i('STEP 5: 手指来回拖动悬浮窗边缘');
  dt.log.i('5.1、按住悬浮窗边缘进行放大拖动');
  await dt.assertComponentClickable('ResizeHandle', true);
  await dt.assertLongClickById('ResizeHandleId', DELAY.default);
  await dt.driver.swipe(400, 400, 600, 400, 300);
  await dt.sleep();
  dt.log.i('5.2、按住悬浮窗边缘进行缩小拖动');
  await dt.assertLongClickById('ResizeHandleId', DELAY.default);
  await dt.driver.swipe(600, 400, 400, 400, 300);
  await dt.sleep();
  dt.log.i('预期结果5：悬浮窗随着手指变大变小，幻灯片持续播放无卡顿');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(500);

  dt.log.i('操作结束，开始验证预期组件：包含是否激活、是否可点击');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle', true);
  dt.log.i('播放幻灯片调节悬浮窗大小 end');
}

/**
 * 大图-进入大图: [播放幻灯片调节悬浮窗至最小自动回到右上角]
 * TAG: 853 TID: Multimedia_Gallery_Slideshow_042
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_042(dt: Dt) {
  dt.log.i('播放幻灯片调节悬浮窗至最小自动回到右上角 start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保设备为xxx手机且图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1: 在照片页面中点击一张图片进入大图预览');
  dt.log.i('1.1、导航至右上角照片页');
  await dt.browser();
  await dt.assertComponent('ImageGalleryComponent', true);
  dt.log.i('1.2、点击一张照片进入大图预览');
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertClick('PhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2: 点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('2.1、验证并点击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('2.2、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果2：成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3: 从底部上滑至右上角悬浮窗');
  dt.log.i('3.1、执行从底部到右上角的滑动操作');
  await dt.driver.swipe(400, 800, 900, 100, 300);
  await dt.sleep();
  dt.log.i('预期结果3：悬浮窗持续播放幻灯片，切换至桌面');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.assertComponent('DesktopComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4: 再次点击右上角悬浮窗');
  dt.log.i('4.1、验证并点击悬浮窗');
  await dt.assertComponentClickable('FloatingWindowComponent', true);
  await dt.assertClick('FloatingWindowComponent', false, DELAY.default);
  await dt.assertComponent('FloatingWindow_Enlarged', true);
  dt.log.i('预期结果4：悬浮窗放大成功');
  await dt.sleep();

  dt.log.i('STEP 5: 手指拖动悬浮窗边缘至悬浮窗最小');
  dt.log.i('5.1、按住右下角边缘拖动至最小尺寸');
  await dt.assertComponentClickable('ResizeHandle', true);
  await dt.assertLongClickById('ResizeHandleId', DELAY.default);
  await dt.driver.swipe(600, 600, 300, 300, 300);
  await dt.sleep();
  dt.log.i('预期结果5：悬浮窗随着手指变小，并跳至右上角，幻灯片持续播放无卡顿');
  await dt.assertComponent('FloatingWindowComponent', true);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(500);

  dt.log.i('操作结束，开始验证预期组件：包含是否激活、是否可点击');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle', true);
  dt.log.i('播放幻灯片调节悬浮窗至最小自动回到右上角 end');
}

/**
 * 大图-进入大图: [幻灯片播放多任务]
 * TAG: 852 TID: Multimedia_Gallery_Slideshow_043
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_043(dt: Dt) {
  dt.log.i('幻灯片播放多任务 start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保设备为xxx手机且图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1: 在照片页面中点击一张图片进入大图预览');
  dt.log.i('1.1、导航至照片页面');
  await dt.browser();
  await dt.assertComponent('ImageGalleryComponent', true);
  dt.log.i('1.2、点击一张照片进入大图预览');
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertClick('PhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2: 点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('2.1、验证并点击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('2.2、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果2：成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3: 从底部上滑至中间位置');
  dt.log.i('3.1、执行从底部到中间的滑动操作以进入多任务界面');
  await dt.driver.swipe(400, 800, 400, 400, 300);
  await dt.sleep();
  dt.log.i('预期结果3：弹出多任务界面，图库幻灯片暂停播放');
  await dt.assertComponent('MultiTaskComponent', true);
  await dt.negateComponent('SlideshowComponent');
  await dt.sleep();

  dt.log.i('操作结束，开始验证预期组件：包含是否激活、是否可点击');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponent('PageTitle', true);
  dt.log.i('幻灯片播放多任务 end');
}

/**
 * 大图-进入大图: [大字体播放幻灯片]
 * TAG: 854 TID: Multimedia_Gallery_Slideshow_044
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_044(dt: Dt) {
  dt.log.i('大字体播放幻灯片 start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保设备为xxx手机且图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1: 进入设置，点击显示和亮度');
  dt.log.i('1.1、打开设置应用');
  await dt.openApp('Settings');
  await dt.assertComponent('SettingsComponent', true);
  dt.log.i('1.2、点击显示和亮度选项');
  await dt.assertComponentClickableText('显示和亮度', true);
  await dt.assertTextClick('显示和亮度', false, DELAY.default);
  await dt.assertComponent('DisplaySettingsComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2: 点击字体大小和界面缩放');
  dt.log.i('2.1、点击字体大小和界面缩放选项');
  await dt.assertComponentClickableText('字体大小和界面缩放', true);
  await dt.assertTextClick('字体大小和界面缩放', false, DELAY.default);
  await dt.assertComponent('FontSettingsComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3: 选择字体大小“特大”，字体粗细“最粗”，显示大小缩放“大”');
  dt.log.i('3.1、选择字体大小为特大');
  await dt.assertComponentClickableText('特大', true);
  await dt.assertTextClick('特大', false, DELAY.default);
  dt.log.i('3.2、选择字体粗细为最粗');
  await dt.assertComponentClickableText('最粗', true);
  await dt.assertTextClick('最粗', false, DELAY.default);
  dt.log.i('3.3、选择显示大小缩放为大');
  await dt.assertComponentClickableText('大', true);
  await dt.assertTextClick('大', false, DELAY.default);
  await dt.assertComponent('FontSettingsComponent', true);
  dt.log.i('预期结果3：字体大小、粗细、显示大小相应变大');
  await dt.sleep();

  dt.log.i('STEP 4: 进入图库，在照片页中点击一张图片进入大图预览');
  dt.log.i('4.1、导航至图库');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  dt.log.i('4.2、点击照片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImageGalleryComponent', true);
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertClick('PhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5: 点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('5.1、验证并点击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('5.2、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果5：幻灯片播放字体变大，变粗，点击后成功播放幻灯片');
  await dt.sleep();

  dt.log.i('操作结束，开始验证预期组件：包含是否激活、是否可点击');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle', true);
  dt.log.i('大字体播放幻灯片 end');
}

/**
 * 大图-进入大图: [关怀模式播放幻灯片]
 * TAG: 855 TID: Multimedia_Gallery_Slideshow_045
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_045(dt: Dt) {
  dt.log.i('关怀模式播放幻灯片 start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保设备为xxx手机且图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1: 进入设置，点击辅助功能');
  dt.log.i('1.1、打开设置应用');
  await dt.openApp('Settings');
  await dt.assertComponent('SettingsComponent', true);
  dt.log.i('1.2、点击辅助功能选项');
  await dt.assertComponentClickableText('辅助功能', true);
  await dt.assertTextClick('辅助功能', false, DELAY.default);
  await dt.assertComponent('AccessibilitySettingsComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2: 点击关怀模式，点击开启');
  dt.log.i('2.1、点击关怀模式选项');
  await dt.assertComponentClickableText('关怀模式', true);
  await dt.assertTextClick('关怀模式', false, DELAY.default);
  await dt.assertComponent('CareModeSettingsComponent', true);
  dt.log.i('2.2、点击开启关怀模式');
  await dt.assertComponentClickableText('开启', true);
  await dt.assertTextClick('开启', false, DELAY.default);
  await dt.assertComponent('CareModeSettingsComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3: 选择标准/(大1/2/3/4/5/6档)');
  dt.log.i('3.1、选择关怀模式为大3档');
  await dt.assertComponentClickableText('大3', true);
  await dt.assertTextClick('大3', false, DELAY.default);
  await dt.assertComponent('CareModeSettingsComponent', true);
  dt.log.i('预期结果3：字体大小、粗细、显示大小相应变大');
  await dt.sleep();

  dt.log.i('STEP 4: 进入图库，在照片页中点击一张图片进入大图预览');
  dt.log.i('4.1、导航至图库');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  dt.log.i('4.2、点击照片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImageGalleryComponent', true);
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertClick('PhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5: 点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('5.1、验证并点击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('5.2、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果5：幻灯片播放字体变大，变粗，点击后成功播放幻灯片');
  await dt.sleep();

  dt.log.i('操作结束，开始验证预期组件：包含是否激活、是否可点击');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle', true);
  dt.log.i('关怀模式播放幻灯片 end');
}

/**
 * 大图-进入大图: [朗读模式播放幻灯片]
 * TAG: 856 TID: Multimedia_Gallery_Slideshow_046
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_046(dt: Dt) {
  dt.log.i('朗读模式播放幻灯片 start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保设备为xxx手机且图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1: 进入设置，点击辅助功能');
  dt.log.i('1.1、打开设置应用');
  await dt.openApp('Settings');
  await dt.assertComponent('SettingsComponent', true);
  dt.log.i('1.2、点击辅助功能选项');
  await dt.assertComponentClickableText('辅助功能', true);
  await dt.assertTextClick('辅助功能', false, DELAY.default);
  await dt.assertComponent('AccessibilitySettingsComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2: 点击屏幕朗读，点击开启');
  dt.log.i('2.1、点击屏幕朗读选项');
  await dt.assertComponentClickableText('屏幕朗读', true);
  await dt.assertTextClick('屏幕朗读', false, DELAY.default);
  await dt.assertComponent('ScreenReaderSettingsComponent', true);
  dt.log.i('2.2、点击开启屏幕朗读');
  await dt.assertComponentClickableText('开启', true);
  await dt.assertTextClick('开启', false, DELAY.default);
  await dt.assertComponent('ScreenReaderSettingsComponent', true);
  dt.log.i('预期结果2：开启朗读模式后手指位置会进行播报');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3: 双指上滑退出设置');
  dt.log.i('3.1、执行双指上滑操作');
  await dt.driver.doubleFingerSwipe(400, 800, 400, 400, 300);
  await dt.assertComponent('DesktopComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4: 双击进入图库，在照片页中双击一张图片进入大图预览');
  dt.log.i('4.1、双击图库图标进入图库');
  await dt.assertComponentClickable('GalleryAppIcon', true);
  await dt.assertDoubleClick('GalleryAppIcon', DELAY.default);
  await dt.assertComponent('AlbumListComponent', true);
  dt.log.i('4.2、导航至照片页');
  await dt.browser();
  await dt.assertComponent('ImageGalleryComponent', true);
  dt.log.i('4.3、双击一张照片进入大图预览');
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertDoubleClick('PhotoItem', DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  dt.log.i('预期结果4：朗读手指位置选中的字段');
  await dt.sleep();

  dt.log.i('STEP 5: 先点击右上角四方菜单，再双击，点击播放幻灯片再双击');
  dt.log.i('5.1、点击并双击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertDoubleClick('MenuButton', DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('5.2、点击并双击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertDoubleClickByText('播放幻灯片', DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果5：朗读手指位置选中的字段，播放幻灯片成功，无卡顿');
  await dt.sleep();

  dt.log.i('操作结束，开始验证预期组件：包含是否激活、是否可点击');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle', true);
  dt.log.i('朗读模式播放幻灯片 end');
}

/**
 * 大图-进入大图: [多语言播放幻灯片（藏文）]
 * TAG: 857 TID: Multimedia_Gallery_Slideshow_047
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_047(dt: Dt) {
  dt.log.i('多语言播放幻灯片（藏文） start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保设备为xxx手机且图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1: 进入设置，点击系统');
  dt.log.i('1.1、打开设置应用');
  await dt.openApp('Settings');
  await dt.assertComponent('SettingsComponent', true);
  dt.log.i('1.2、点击系统选项');
  await dt.assertComponentClickableText('系统', true);
  await dt.assertTextClick('系统', false, DELAY.default);
  await dt.assertComponent('SystemSettingsComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2: 点击语言和地区');
  dt.log.i('2.1、点击语言和地区选项');
  await dt.assertComponentClickableText('语言和地区', true);
  await dt.assertTextClick('语言和地区', false, DELAY.default);
  await dt.assertComponent('LanguageSettingsComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3: 选择藏文');
  dt.log.i('3.1、选择藏文语言');
  await dt.assertComponentClickableText('藏文', true);
  await dt.assertTextClick('藏文', false, DELAY.default);
  await dt.assertComponent('LanguageSettingsComponent', true);
  dt.log.i('预期结果3：界面文字切换为藏文');
  await dt.sleep();

  dt.log.i('STEP 4: 进入图库，在照片页中点击一张图片进入大图预览');
  dt.log.i('4.1、导航至图库');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  dt.log.i('4.2、点击照片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImageGalleryComponent', true);
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertClick('PhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5: 点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('5.1、验证并点击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('5.2、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果5：成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep();

  dt.log.i('操作结束，开始验证预期组件：包含是否激活、是否可点击');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle', true);
  dt.log.i('多语言播放幻灯片（藏文） end');
}

/**
 * 大图-进入大图: [多语言播放幻灯片（英文）]
 * TAG: 858 TID: Multimedia_Gallery_Slideshow_048
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_048(dt: Dt) {
  dt.log.i('多语言播放幻灯片（英文） start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保设备为xxx手机且图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1: 进入设置，点击系统');
  dt.log.i('1.1、打开设置应用');
  await dt.openApp('Settings');
  await dt.assertComponent('SettingsComponent', true);
  dt.log.i('1.2、点击系统选项');
  await dt.assertComponentClickableText('系统', true);
  await dt.assertTextClick('系统', false, DELAY.default);
  await dt.assertComponent('SystemSettingsComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2: 点击语言和地区');
  dt.log.i('2.1、点击语言和地区选项');
  await dt.assertComponentClickableText('语言和地区', true);
  await dt.assertTextClick('语言和地区', false, DELAY.default);
  await dt.assertComponent('LanguageSettingsComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3: 选择英文');
  dt.log.i('3.1、选择英文语言');
  await dt.assertComponentClickableText('英文', true);
  await dt.assertTextClick('英文', false, DELAY.default);
  await dt.assertComponent('LanguageSettingsComponent', true);
  dt.log.i('预期结果3：界面文字切换为英文');
  await dt.sleep();

  dt.log.i('STEP 4: 进入图库，在照片页中点击一张图片进入大图预览');
  dt.log.i('4.1、导航至图库');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  dt.log.i('4.2、点击照片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImageGalleryComponent', true);
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertClick('PhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5: 点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('5.1、验证并点击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('5.2、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果5：成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep();

  dt.log.i('操作结束，开始验证预期组件：包含是否激活、是否可点击');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle', true);
  dt.log.i('多语言播放幻灯片（英文） end');
}

/**
 * 大图-进入大图: [多语言播放幻灯片（繁体中文）]
 * TAG: 859 TID: Multimedia_Gallery_Slideshow_049
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_049(dt: Dt) {
  dt.log.i('多语言播放幻灯片（繁体中文） start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保设备为xxx手机且图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1: 进入设置，点击系统');
  dt.log.i('1.1、打开设置应用');
  await dt.openApp('Settings');
  await dt.assertComponent('SettingsComponent', true);
  dt.log.i('1.2、点击系统选项');
  await dt.assertComponentClickableText('系统', true);
  await dt.assertTextClick('系统', false, DELAY.default);
  await dt.assertComponent('SystemSettingsComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2: 点击语言和地区');
  dt.log.i('2.1、点击语言和地区选项');
  await dt.assertComponentClickableText('语言和地区', true);
  await dt.assertTextClick('语言和地区', false, DELAY.default);
  await dt.assertComponent('LanguageSettingsComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3: 选择繁体中文');
  dt.log.i('3.1、选择繁体中文语言');
  await dt.assertComponentClickableText('繁体中文', true);
  await dt.assertTextClick('繁体中文', false, DELAY.default);
  await dt.assertComponent('LanguageSettingsComponent', true);
  dt.log.i('预期结果3：界面文字切换为繁体中文');
  await dt.sleep();

  dt.log.i('STEP 4: 进入图库，在照片页中点击一张图片进入大图预览');
  dt.log.i('4.1、导航至图库');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  dt.log.i('4.2、点击照片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImageGalleryComponent', true);
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertClick('PhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5: 点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('5.1、验证并点击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('5.2、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果5：成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep();

  dt.log.i('操作结束，开始验证预期组件：包含是否激活、是否可点击');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle', true);
  dt.log.i('多语言播放幻灯片（繁体中文） end');
}

/**
 * 大图-进入大图: [多语言播放幻灯片（维吾尔文）]
 * TAG: 860 TID: Multimedia_Gallery_Slideshow_050
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_050(dt: Dt) {
  dt.log.i('多语言播放幻灯片（维吾尔文） start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保设备为xxx手机且图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1: 进入设置，点击系统');
  dt.log.i('1.1、打开设置应用');
  await dt.openApp('Settings');
  await dt.assertComponent('SettingsComponent', true);
  dt.log.i('1.2、点击系统选项');
  await dt.assertComponentClickableText('系统', true);
  await dt.assertTextClick('系统', false, DELAY.default);
  await dt.assertComponent('SystemSettingsComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2: 点击语言和地区');
  dt.log.i('2.1、点击语言和地区选项');
  await dt.assertComponentClickableText('语言和地区', true);
  await dt.assertTextClick('语言和地区', false, DELAY.default);
  await dt.assertComponent('LanguageSettingsComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3: 选择维吾尔文');
  dt.log.i('3.1、选择维吾尔文语言');
  await dt.assertComponentClickableText('维吾尔文', true);
  await dt.assertTextClick('维吾尔文', false, DELAY.default);
  await dt.assertComponent('LanguageSettingsComponent', true);
  dt.log.i('预期结果3：界面文字切换为维吾尔文');
  await dt.sleep();

  dt.log.i('STEP 4: 进入图库，在照片页中点击一张图片进入大图预览');
  dt.log.i('4.1、导航至图库');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  dt.log.i('4.2、点击照片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImageGalleryComponent', true);
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertClick('PhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5: 点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('5.1、验证并点击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('5.2、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果5：成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep();

  dt.log.i('操作结束，开始验证预期组件：包含是否激活、是否可点击');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle', true);
  dt.log.i('多语言播放幻灯片（维吾尔文） end');
}

/**
 * 大图-进入大图: [播放幻灯片途中接受分享图片]
 * TAG: 822 TID: Multimedia_Gallery_Slideshow_051
 * 前置条件
 * 1、准备一台xxx手机测试机a，辅助机b
 * 2、测试机a内预制图片/视频/动态照片/人像照片等
 * 3、测试机b内有图片
 */
async function Multimedia_Gallery_Slideshow_051(dt: Dt) {
  dt.log.i('播放幻灯片途中接受分享图片 start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保测试机a为xxx手机且图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1: 测试机a在照片页中点击一张图片进入大图预览');
  dt.log.i('1.1、导航至照片页面');
  await dt.browser();
  await dt.assertComponent('ImageGalleryComponent', true);
  dt.log.i('1.2、点击一张照片进入大图预览');
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertClick('PhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2: 点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('2.1、验证并点击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('2.2、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果2：成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3: 辅助机b选择一张照片进行分享到测试机a');
  dt.log.i('3.1、测试机a接收分享通知');
  await dt.assertComponent('NotificationComponent', true);
  dt.log.i('3.2、点击接受分享图片');
  await dt.assertComponentClickableText('接受', true);
  await dt.assertTextClick('接受', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  dt.log.i('预期结果3：幻灯片接收图片成功，跳转到该张照片');
  await dt.sleep();

  dt.log.i('操作结束，开始验证预期组件：包含是否激活、是否可点击');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponent('PageTitle', true);
  dt.log.i('播放幻灯片途中接受分享图片 end');
}

/**
 * 大图-进入大图: [播放幻灯片碰传接受方（接受）]
 * TAG: 823 TID: Multimedia_Gallery_Slideshow_052
 * 前置条件
 * 1、准备一台xxx手机测试机a，辅助机b
 * 2、测试机a内预制图片/视频/动态照片/人像照片等
 * 3、测试机b内有图片
 */
async function Multimedia_Gallery_Slideshow_052(dt: Dt) {
  dt.log.i('播放幻灯片碰传接受方（接受） start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保测试机a为xxx手机且图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1: 测试机a在照片页中点击一张图片进入大图预览');
  dt.log.i('1.1、导航至照片页面');
  await dt.browser();
  await dt.assertComponent('ImageGalleryComponent', true);
  dt.log.i('1.2、点击一张照片进入大图预览');
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertClick('PhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2: 点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('2.1、验证并点击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('2.2、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果2：成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3: 测试机a与辅助机b碰传，测试机a作为接受方同意接收图片');
  dt.log.i('3.1、测试机a接收碰传通知');
  await dt.assertComponent('BumpTransferNotification', true);
  dt.log.i('3.2、点击接受碰传图片');
  await dt.assertComponentClickableText('接受', true);
  await dt.assertTextClick('接受', false, DELAY.default);
  await dt.assertComponent('AlbumListComponent', true);
  dt.log.i('预期结果3：接受成功，重新拉起图库，展示接收的图片');
  await dt.sleep();

  dt.log.i('操作结束，开始验证预期组件：包含是否激活、是否可点击');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponent('PageTitle', true);
  dt.log.i('播放幻灯片碰传接受方（接受） end');
}

/**
 * 大图-进入大图: [播放幻灯片碰传接受方（拒绝）]
 * TAG: 824 TID: Multimedia_Gallery_Slideshow_053
 * 前置条件
 * 1、准备一台xxx手机测试机a，辅助机b
 * 2、测试机a内预制图片/视频/动态照片/人像照片等
 * 3、测试机b内有图片
 */
async function Multimedia_Gallery_Slideshow_053(dt: Dt) {
  dt.log.i('播放幻灯片碰传接受方（拒绝） start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保测试机a为xxx手机且图库中有预制图片/视频/动态照片/人像照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1: 测试机a在照片页中点击一张图片进入大图预览');
  dt.log.i('1.1、导航至照片页面');
  await dt.browser();
  await dt.assertComponent('ImageGalleryComponent', true);
  dt.log.i('1.2、点击一张照片进入大图预览');
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertClick('PhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2: 点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('2.1、验证并点击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('2.2、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果2：成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3: 测试机a与辅助机b碰传，测试机a作为接受方拒绝接收图片');
  dt.log.i('3.1、测试机a接收碰传通知');
  await dt.assertComponent('BumpTransferNotification', true);
  dt.log.i('3.2、点击拒绝碰传图片');
  await dt.assertComponentClickableText('拒绝', true);
  await dt.assertTextClick('拒绝', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  dt.log.i('预期结果3：拒绝碰传后退出幻灯片播放');
  await dt.negateComponent('SlideshowComponent');
  await dt.sleep();

  dt.log.i('操作结束，开始验证预期组件：包含是否激活、是否可点击');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponent('PageTitle', true);
  dt.log.i('播放幻灯片碰传接受方（拒绝） end');
}

/**
 * 大图-进入大图: [播放相册中全部照片]
 * TAG: 818 TID: Multimedia_Gallery_Slideshow_054
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等（单个相册内超过500张照片）
 */
async function Multimedia_Gallery_Slideshow_054(dt: Dt) {
  dt.log.i('播放相册中全部照片 start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保设备为xxx手机且图库中单个相册有超过500张照片');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.assertTextClick('LargeAlbum', false, DELAY.default);
  await dt.assertComponent('AlbumContentComponent', true);
  await dt.sleep();

  dt.log.i('STEP 1: 在相册页中点击一个数量大于500张的相册，点击进入，选择第一张照片进入大图浏览');
  dt.log.i('1.1、导航至相册页面');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  dt.log.i('1.2、点击包含500张以上照片的相册');
  await dt.assertComponentClickableText('LargeAlbum', true);
  await dt.assertTextClick('LargeAlbum', false, DELAY.default);
  await dt.assertComponent('AlbumContentComponent', true);
  dt.log.i('1.3、点击第一张照片进入大图预览');
  await dt.assertComponentClickable('FirstPhotoItem', true);
  await dt.assertClick('FirstPhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2: 点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('2.1、验证并点击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('2.2、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果2：成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面），相册中照片被全部播放');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束，开始验证预期组件');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle', true);
  dt.log.i('播放相册中全部照片 end');
}

/**
 * 大图-进入大图: [隐私空间播放幻灯片]
 * 前置条件
 * TAG: 817 TID: Multimedia_Gallery_Slideshow_055
 * 前置条件
 * 1、准备一台xxx手机，已设定了隐私空间
 * 2、隐私空间内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_055(dt: Dt) {
  dt.log.i('隐私空间播放幻灯片 start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保设备为xxx手机且隐私空间内有预制图片/视频/动态照片');
  await dt.openApp('PrivacySpace');
  await dt.assertComponent('PrivacySpaceLockComponent', true);
  await dt.sleep(500);

  dt.log.i('STEP 1: 输入隐私空间密码解锁隐私空间');
  dt.log.i('1.1、输入隐私空间密码');
  await dt.assertComponentClickable('PasswordInput', true);
  await dt.enterPassword('123456');
  await dt.assertClick('SubmitButton', false, DELAY.default);
  await dt.assertComponent('PrivacySpaceComponent', true);
  dt.log.i('预期结果1：成功进入隐私空间');
  await dt.sleep(500);

  dt.log.i('STEP 2: 在照片页中点击一张图片进入大图预览');
  dt.log.i('2.1、导航至隐私空间的图库页面');
  await dt.albumList('Privacy');
  await dt.assertComponent('PrivacyGalleryListComponent', true);
  dt.log.i('2.2、点击照片进入大图预览');
  await dt.browser();
  await dt.assertComponent('PrivacyImageGallery', true);
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertClick('PhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3: 点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('3.1、验证并点击右上角四方');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('3.2、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果3：成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep(500);

  dt.log.i('操作结束，开始验证预期组件');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle', true);
  dt.log.i('隐私空间播放幻灯片 end');
}

/**
 * 大图-应用锁: [播放幻灯片应用锁]
 * TAG: 815 TID: Multimedia_Gallery_Slideshow_056
 * 前置条件
 * 1、准备一台xxx手机，已设应用锁
 * 2、手机内预制图片/视频/动态照片/人像照片等
 */
async function Multimedia_Gallery_Slideshow_056(dt: Dt) {
  dt.log.i('播放幻灯片应用锁 start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保设备为xxx手机且图库有应用锁且有预制图片/视频');
  await dt.openApp('Gallery');
  await dt.assertComponent('AppLockComponent', true);
  await dt.sleep(500);

  dt.log.i('STEP 1: 输入密码解锁屏幕');
  dt.log.i('1.1、输入屏幕锁密码');
  await dt.assertComponentClickable('ScreenLockInput', true);
  await dt.enterPassword('123456');
  await dt.assertClick('SubmitButton', false, DELAY.default);
  await dt.assertComponent('DesktopComponent', true);
  dt.log.i('预期结果1：输入正确密码后成功解锁屏幕');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2: 点击图库，输入应用锁密码');
  dt.log.i('2.1、点击图库应用');
  await dt.assertComponentClickable('GalleryAppIcon', true);
  await dt.assertClick('GalleryAppIcon', false, DELAY.default);
  await dt.assertComponent('AppLockComponent', true);
  dt.log.i('2.2、输入图库应用锁密码');
  await dt.assertComponentClickable('AppLockInput', true);
  await dt.enterPassword('123456');
  await dt.assertClick('SubmitButton', false, DELAY.default);
  await dt.assertComponent('AlbumListComponent', true);
  dt.log.i('预期结果2：输入正确密码后解锁图库');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3: 在照片页面中点击一张图片进入大图预览');
  dt.log.i('3.1、导航至照片页面');
  await dt.browser();
  await dt.assertComponent('ImageGalleryComponent', true);
  dt.log.i('3.2、点击一张照片进入大图预览');
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertClick('PhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4: 点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('4.1、验证并点击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('4.2、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果4：成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep(500);

  dt.log.i('操作结束，开始验证预期组件');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle', true);
  dt.log.i('播放幻灯片应用锁 end');
}

/**
 * 大图-应用锁: [播放幻灯片应用锁（打开应用退出后立即锁定）]
 * TAG: 816 TID: Multimedia_Gallery_Slideshow_057
 * 前置条件
 * 1、准备一台xxx手机，已设应用锁（打开应用退出后立即锁定）
 * 2、手机内预制图片信息
 */
async function Multimedia_Gallery_Slideshow_057(dt: Dt) {
  dt.log.i('播放幻灯片应用锁（打开应用退出后立即锁定） start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保设备为xxx手机且图库设置了立即锁定应用锁且有预制图片');
  await dt.openApp('Gallery');
  await dt.assertComponent('AppLockComponent', true);
  await dt.sleep(500);

  dt.log.i('STEP 1: 点击图库，输入应用锁密码');
  dt.log.i('1.1、点击图库应用');
  await dt.assertComponentClickable('GalleryAppIcon', true);
  await dt.assertClick('GalleryAppIcon', false, DELAY.default);
  await dt.assertComponent('AppLockComponent', true);
  dt.log.i('1.2、输入图库应用锁密码');
  await dt.assertComponentClickable('AppLockInput', true);
  await dt.enterPassword('123456');
  await dt.assertClick('SubmitButton', false, DELAY.default);
  await dt.assertComponent('AlbumListComponent', true);
  dt.log.i('预期结果1：输入正确密码后解锁图库');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2: 退出图库切换到其他应用，再次切换回图库，输入应用锁密码');
  dt.log.i('2.1、退出图库');
  await dt.back();
  await dt.assertComponent('DesktopComponent', true);
  dt.log.i('2.2、打开其他应用');
  await dt.assertComponentClickable('OtherAppIcon', true);
  await dt.assertClick('OtherAppIcon', false, DELAY.default);
  await dt.assertComponent('OtherAppComponent', true);
  dt.log.i('2.3、切换回图库');
  await dt.openApp('Gallery');
  await dt.assertComponent('AppLockComponent', true);
  dt.log.i('2.4、再次输入图库应用锁密码');
  await dt.assertComponentClickable('AppLockInput', true);
  await dt.enterPassword('123456');
  await dt.assertClick('SubmitButton', false, DELAY.default);
  await dt.assertComponent('AlbumListComponent', true);
  dt.log.i('预期结果2：触发应用锁，输入正确密码后解锁图库');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3: 在照片页面中点击一张图片进入大图预览');
  dt.log.i('3.1、导航至照片页面');
  await dt.browser();
  await dt.assertComponent('ImageGalleryComponent', true);
  dt.log.i('3.2、点击一张照片进入大图预览');
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertClick('PhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4: 点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('4.1、验证并点击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('4.2、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果4：成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep(500);

  dt.log.i('操作结束，开始验证预期组件');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle', true);
  dt.log.i('播放幻灯片应用锁（打开应用退出后立即锁定） end');
}

/**
 * 大图-进入大图: [播放幻灯片过程中常亮]
 * TAG: 827 TID: Multimedia_Gallery_Slideshow_058
 * 前置条件
 * 1、准备一台xxx手机（设置中显示和亮度中关闭了注视屏幕不熄屏，休眠时间为15秒）
 * 2、手机内预制图片/视频/动态照片/人像照片
 */
async function Multimedia_Gallery_Slideshow_058(dt: Dt) {
  dt.log.i('播放幻灯片过程中常亮 start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保设备为xxx手机且休眠时间为15秒且有预制图片/视频');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep(500);

  dt.log.i('STEP 1: 进入图库');
  dt.log.i('1.1、打开图库应用');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2: 进入相册（包含图片和视频）点击图片进入大图，点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('2.1、点击包含图片和视频的相册');
  await dt.assertComponentClickableText('MixedAlbum', true);
  await dt.assertTextClick('MixedAlbum', false, DELAY.default);
  await dt.assertComponent('AlbumContentComponent', true);
  dt.log.i('2.2、点击照片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImageGalleryComponent', true);
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertClick('PhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  dt.log.i('2.3、验证并点击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('2.4、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果2：成功播放幻灯片，超过休眠时间后屏幕依旧持续常亮');
  await dt.sleep(20000); // 等待20秒以超过15秒休眠时间

  dt.log.i('操作结束，开始验证预期组件');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle', true);
  dt.log.i('播放幻灯片过程中常亮 end');
}

/**
 * 大图-进入大图: [播放幻灯片克隆（xxx）]
 * TAG: 819 TID: Multimedia_Gallery_Slideshow_059
 * 前置条件
 * 1、准备两台xxx手机，一台xxx手机测试机a（幻灯片播放时间为3秒），一台xxx手机辅助机b（幻灯片播放时间为15秒））
 * （2、辅助机b内预制图片/视频/动态照片/人像照片
 */
async function Multimedia_Gallery_Slideshow_059(dt: Dt) {
  dt.log.i('播放幻灯片克隆（xxx） start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保测试机a为xxx手机且辅助机b有预制图片/视频');
  await dt.openApp('DataTransfer');
  await dt.assertComponent('DataTransferApp', true);
  await dt.sleep(500);

  dt.log.i('STEP 1: 点击数据克隆应用，辅助机b选择为旧设备，测试机a选择为新设备，选择旧设备为');
  dt.log.i('1.1、打开数据克隆应用');
  await dt.openApp('DataTransfer');
  await dt.assertComponent('DataTransferApp', true);
  dt.log.i('1.2、在测试机a上选择“新设备”');
  await dt.assertComponentClickable('NewDeviceOption', true);
  await dt.assertClick('NewDevice', false, DELAY.default);
  await dt.assertComponent('QRCodeComponent', true);
  dt.log.i('1.3、选择旧设备类型为');
  await dt.assertComponentClickableTextClick('', true);
  await dt.assertTextClick('', false, DELAY.default);
  await dt.assertComponent('QRCodeComponent', true);
  dt.log.i('预期结果1：辅助机b弹出扫码界面，测试机a展示二维码');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2: 辅助机b扫测试机a的二维码，测试机a点击开始迁移');
  dt.log.i('2.1、在测试机a上点击开始迁移按钮');
  await dt.assertComponentClickable('StartMigrationButton', true);
  await dt.assertClick('StartMigrationButton', false, DELAY.default);
  await dt.assertComponent('MigrationProgressComponent', true);
  dt.log.i('预期结果2：测试机a数据开始迁移');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3: 测试机a数据克隆完毕后打开图库');
  dt.log.i('3.1、等待数据迁移完成');
  await dt.assertComponent('MigrationCompleteComponent', true);
  dt.log.i('3.2、打开图库应用');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  dt.log.i('预期结果3：数据迁移完毕');
  await dt.sleep();

  dt.log.i('STEP 4: 在照片页面中点击一张图片进入大图预览');
  dt.log.i('4.1、导航至照片页面');
  await dt.browser();
  await dt.assertComponent('ImageGalleryComponent', true);
  dt.log.i('4.2、点击一张照片进入大图预览');
  await dt.assertComponentClickable('PhotoItem', true);
  await dt.assertClick('PhotoItem', false, DELAY.default);
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5: 点击右上角四方菜单，点击播放幻灯片');
  dt.log.i('5.1、验证并点击右上角四方菜单');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertComponent('MenuOptionsComponent', true);
  dt.log.i('5.2、点击播放幻灯片选项');
  await dt.assertComponentClickableText('播放幻灯片', true);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.assertComponent('SlideshowComponent', true);
  dt.log.i('预期结果5：播放幻灯片时间间隔为15秒，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep(15000); // 验证15秒间隔

  dt.log.i('操作结束，开始验证预期组件');
  await dt.showComponentsWithin('PageTitle');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle', true);
  dt.log.i('播放幻灯片克隆（xxx） end');
}

/**
 * 大图-进入大图: [播放幻灯片克隆（xxx）]
 * TAG: 820 TID: Multimedia_Gallery_Slideshow_060
 * 前置条件
 * 1、准备两台xxx手机，一台xxx手机测试机a（幻灯片播放时间为3秒），一台xxx手机辅助机b（幻灯片播放时间为15秒）
 * 2、辅助机b内预制图片/视频/动态照片/人像照片
 */
async function Multimedia_Gallery_Slideshow_060(dt: Dt) {
  dt.log.i('播放幻灯片克隆（xxx） start');
  dt.log.i('STEP 0: 验证前置条件');
  dt.log.i('0.1、确保测试机a为xxx手机且辅助机b有预制图片/视频');
  await dt.openApp('DataTransfer');
  await dt.assertComponent('DataTransferApp', true);
  await dt.sleep(500);

  dt.log.i('STEP 1: 点击数据克隆应用，辅助机b选择为旧设备，测试机a选择为新设备，选择旧设备为');
  dt.log.i('1.1、打开数据克隆应用');
  await dt.openApp('DataTransfer');
  await dt.assertComponent('DataTransferApp', true);
  dt.log.i('1.2、在测试机a上选择“新设备”');
  await dt.assertComponentClickable('NewDeviceOption', true);
  await dt.assertClick('NewDeviceOption', false, DELAY.default);
  await dt.assertComponent('QRCodeComponent', true);
  dt.log.i('1.3、选择旧设备类型为');
  await dt.assertComponentClickableText('', true);
  await dt.assertTextClick('', false, DELAY.default);
  await dt.assertComponent('QRCodeComponent', true);
  dt.log.i('预期结果1：辅助机b弹出扫码界面，测试机a展示二维码');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2: 辅助机b扫测试机a的二维码，测试机a点击开始迁移');
  dt.log.i('2.1、在测试机a上点击开始迁移按钮');
  await dt.assertComponentClickable('StartMigrationButton', true);
  await dt.assertClick('StartMigrationButton', false, DELAY.default);
  await dt.assertComponent('MigrationProgressComponent', true);
  dt.log.i('预期结果2：测试机a数据开始迁移');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3: 测试机a数据克隆完毕后打开图库');
  dt.log.i('3.1、等待数据迁移完成');
  await dt.assertComponent('MigrationCompleteComponent', true);

  await dt.sleep();
  dt.log.i('预期结果3、数据迁移完毕5、播放幻灯片时间间隔为15秒，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、在照片页中点击一张图片进入大图预览');

  await dt.sleep();
  dt.log.i('STEP 5、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');

  await dt.sleep();
  dt.log.i('预期结果5、播放幻灯片时间间隔为15秒，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('播放幻灯片克隆（xxx） end');
}

/**
 * 大图-进入大图: [幻灯片播放双屏转单屏（xxx）]
 * TAG: 821 TID: Multimedia_Gallery_Slideshow_061
 * 前置条件
 * 1、准备一台xxx手机
 2、手机内预制图片/视频/动态照片/连拍照片等
 */
async function Multimedia_Gallery_Slideshow_061(dt: Dt) {
  dt.log.i('幻灯片播放双屏转单屏（xxx） start');
  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览（双屏）');

  await dt.sleep();
  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');

  await dt.sleep();
  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、切换到单屏');

  await dt.sleep();
  dt.log.i('预期结果3、成功切换到单屏，幻灯片播放未打断');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('幻灯片播放双屏转单屏（xxx） end');
}

/**
 * 大图-进入大图: [幻灯片播放单屏转双屏（xxx）]
 * TAG: 828 TID: Multimedia_Gallery_Slideshow_062
 * 前置条件
 * 1、准备一台xxx手机
 2、手机内预制图片/视频/动态照片/连拍照片等
 */
async function Multimedia_Gallery_Slideshow_062(dt: Dt) {
  dt.log.i('幻灯片播放单屏转双屏（xxx） start');
  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览（单屏）');

  await dt.sleep();
  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');

  await dt.sleep();
  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、切换到双屏');

  await dt.sleep();
  dt.log.i('预期结果3、成功切换到双屏，幻灯片播放未打断');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('幻灯片播放单屏转双屏（xxx） end');
}

