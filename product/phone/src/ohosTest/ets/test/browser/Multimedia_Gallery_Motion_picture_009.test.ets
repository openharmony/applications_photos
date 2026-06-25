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

export default function Multimedia_Gallery_Motion_Picture_009(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('Multimedia_Gallery_Motion_Picture_009', (): void => {
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
    run('Multimedia_Gallery_Motion_picture_080', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片内存测试] TID: Multimedia_Gallery_Motion_picture_080
      await Multimedia_Gallery_Motion_picture_080(dt);
    });
    run('Multimedia_Gallery_Motion_picture_081', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片效果切换功耗测试] TID: Multimedia_Gallery_Motion_picture_081
      await Multimedia_Gallery_Motion_picture_081(dt);
    });
    run('Multimedia_Gallery_Motion_picture_082', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片安全相机进大图切换效果] TID: Multimedia_Gallery_Motion_picture_082
      await Multimedia_Gallery_Motion_picture_082(dt);
    });
    run('Multimedia_Gallery_Motion_picture_083', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片云增强编辑后兼容测试] TID: Multimedia_Gallery_Motion_picture_083
      await Multimedia_Gallery_Motion_picture_083(dt);
    });
    run('Multimedia_Gallery_Motion_picture_084', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片清晰度测试] TID: Multimedia_Gallery_Motion_picture_084
      await Multimedia_Gallery_Motion_picture_084(dt);
    });
    run('Multimedia_Gallery_Motion_picture_085', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片智慧多窗效果切换] TID: Multimedia_Gallery_Motion_picture_085
      await Multimedia_Gallery_Motion_picture_085(dt);
    });
    run('Multimedia_Gallery_Motion_picture_086', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片隐私空间效果切换] TID: Multimedia_Gallery_Motion_picture_086
      await Multimedia_Gallery_Motion_picture_086(dt);
    });
    run('Multimedia_Gallery_Motion_picture_087', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片自动播放端云同步测试] TID: Multimedia_Gallery_Motion_picture_087
      await Multimedia_Gallery_Motion_picture_087(dt);
    });
    run('Multimedia_Gallery_Motion_picture_088', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片效果切换并发场景] TID: Multimedia_Gallery_Motion_picture_088
      await Multimedia_Gallery_Motion_picture_088(dt);
    });
    run('Multimedia_Gallery_Motion_picture_089', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片效果切换水印查看] TID: Multimedia_Gallery_Motion_picture_089
      await Multimedia_Gallery_Motion_picture_089(dt);
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
/**
 * 大图-动态照片: [动态照片内存测试]
 * TAG: 274 TID: Multimedia_Gallery_Motion_picture_080
 */
async function Multimedia_Gallery_Motion_picture_080(dt: Dt) {
  dt.log.i('动态照片内存测试 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性');
  dt.log.i('STEP 0.1、相机拍摄动态照片（覆盖普通动态照片、带水印动态照片、云增强动态照片、编辑后的动态照片，各比例动态照片等；可多场景叠加）');
  dt.log.i('STEP 0.1.1、确保图库中存在符合条件的动态照片并进入图库主页');
  await dt.pressKey(KEY.home);
  await dt.sleep(DELAY.short);
  await dt.assertClick(ON.text('图库')); // 进入图库
  await dt.assertComponent('motion_photo_thumbnail', true); // 确认图库有动态照片

  dt.log.i('STEP 0.1.2、点击动态照片进入大图页');
  await dt.assertClick('motion_photo_thumbnail_0'); // 点击第一张动态照片
  await dt.assertComponent('motion_photo_player_page'); // 确认进入动态照片播放页

  dt.log.i('STEP 1、动态照片任意效果切换，长按播放');
  dt.log.i('STEP 1.1、切换至主角时刻效果');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  await dt.assertClick('protagonist_moment_effect_option');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('STEP 1.2、长按播放');
  await dt.assertLongClickById('preview_area');
  await dt.assertComponent('playback_started'); // 断言播放开始

  dt.log.i('预期结果1，2，3、内存逐渐上涨，过程会有升降4、静置后内存逐渐下降');
  // 内存测试需要外部工具或API进行断言，此处仅输出日志
  dt.log.i('请观察内存变化曲线');

  dt.log.i('STEP 2、动态照片大图操作（大图滑动、大图长按播放、菜单操作（如收藏、编辑等））');
  dt.log.i('STEP 2.1、大图滑动');
  await dt.flick('motion_photo_player_page', 'left'); // 向左滑动到下一张
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('STEP 2.2、大图长按播放');
  await dt.assertLongClickById('preview_area');
  await dt.assertComponent('playback_started');

  dt.log.i('STEP 2.3、菜单操作（如收藏、编辑等）');
  await dt.assertClick('more_options_button'); // 更多选项
  await dt.assertComponent('options_menu'); // 确认菜单弹出
  await dt.assertClick('favorite_button'); // 收藏
  await dt.assertComponent('motion_photo_player_page'); // 确认返回大图页

  dt.log.i('STEP 3、动态照片进出编辑，任意编辑操作');
  dt.log.i('STEP 3.1、进入编辑界面');
  await dt.assertClick('edit_button');
  await dt.assertComponent('edit_page');

  dt.log.i('STEP 3.2、进行任意编辑操作（例如调整亮度）');
  await dt.assertClick('adjust_tab');
  await dt.drag(ON.id('brightness_slider'), 0.5, 0.6); // 拖动亮度滑块
  await dt.assertComponent('edit_page');

  dt.log.i('STEP 3.3、保存并退出编辑');
  await dt.assertClick('save_button');
  await dt.assertComponent('motion_photo_player_page'); // 返回大图页

  dt.log.i('STEP 4、静置手机');
  // 自动化无法直接实现静置并观察内存，此处仅标记操作
  dt.log.i('请静置手机，观察内存变化');

  dt.log.i('预期结果4、静置后内存逐渐下降');
  dt.log.i('请观察内存下降情况');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片内存测试 end');
}

/**
 * 大图-动态照片: [动态照片效果切换功耗测试]
 * TAG: 284 TID: Multimedia_Gallery_Motion_picture_081
 */
async function Multimedia_Gallery_Motion_picture_081(dt: Dt) {
  dt.log.i('动态照片效果切换功耗测试 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性');
  dt.log.i('STEP 0.1、相机拍摄动态照片（覆盖普通动态照片、带水印动态照片、云增强动态照片、编辑后的动态照片，各比例动态照片等；可多场景叠加）');
  dt.log.i('STEP 0.1.1、确保图库中存在符合条件的动态照片并进入图库主页');
  await dt.pressKey(KEY.home);
  await dt.sleep(DELAY.short);
  await dt.assertClick(ON.text('图库')); // 进入图库
  await dt.assertComponent('motion_photo_thumbnail', true);

  dt.log.i('STEP 0.1.2、点击动态照片进入大图页');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('STEP 1、动态照片效果切换为循环播放');
  dt.log.i('STEP 1.1、点击动态照片效果切换按钮');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  dt.log.i('STEP 1.2、选择循环播放效果');
  await dt.assertClick('loop_playback_effect_option');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('预期结果1，2，3，4，5，6、功耗优于xxx');
  // 功耗测试需要外部工具或API进行断言，此处仅输出日志

  dt.log.i('STEP 2、动态照片效果切换为主角时刻');
  dt.log.i('STEP 2.1、点击动态照片效果切换按钮');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  dt.log.i('STEP 2.2、选择主角时刻效果');
  await dt.assertClick('protagonist_moment_effect_option');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('STEP 3、动态照片效果切换为运动轨迹');
  dt.log.i('STEP 3.1、点击动态照片效果切换按钮');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  dt.log.i('STEP 3.2、选择运动轨迹效果');
  await dt.assertClick('motion_trail_effect_option');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('STEP 4、动态照片效果切换为微动瞬间');
  dt.log.i('STEP 4.1、点击动态照片效果切换按钮');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  dt.log.i('STEP 4.2、选择微动瞬间效果');
  await dt.assertClick('micro_moment_effect_option');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('STEP 5、动态照片效果切换为动态照片（原始效果）');
  dt.log.i('STEP 5.1、点击动态照片效果切换按钮');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  dt.log.i('STEP 5.2、选择动态照片原始效果（假设有一个明确的按钮或选项）');
  await dt.assertClick('original_motion_photo_effect_option');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('STEP 6、动态照片效果切换为关闭');
  dt.log.i('STEP 6.1、点击动态照片效果切换按钮');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  dt.log.i('STEP 6.2、选择关闭效果');
  await dt.assertClick('close_effect_option');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片效果切换功耗测试 end');
}

/**
 * 大图-动态照片: [动态照片安全相机进大图切换效果]
 * TAG: 280 TID: Multimedia_Gallery_Motion_picture_082
 */
async function Multimedia_Gallery_Motion_picture_082(dt: Dt) {
  dt.log.i('动态照片安全相机进大图切换效果 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性');
  dt.log.i('STEP 0.1、手机已设置密码');
  dt.log.i('STEP 0.1.1、确保手机已设置锁屏密码（此步骤需手动确认或通过预置环境确保）');
  dt.log.i('STEP 0.1.2、确保安全相机可用');
  await dt.pressKey(KEY.power); // 锁屏
  await dt.sleep(DELAY.short);
  await dt.pressKey(KEY.power); // 亮屏
  await dt.assertComponent('lock_screen'); // 确认在锁屏界面

  dt.log.i('STEP 1、手机锁屏进入安全相机，拍摄动态照片');
  dt.log.i('STEP 1.1、从锁屏界面进入安全相机');
  await dt.swipe(200, 800, 200, 200); // 假设从锁屏左下角向上滑进入安全相机
  await dt.assertComponent('secure_camera_mode'); // 确认进入安全相机模式

  dt.log.i('STEP 1.2、拍摄动态照片');
  await dt.assertClick('capture_button'); // 拍摄按钮
  await dt.assertComponent('motion_photo_captured_thumbnail'); // 确认拍摄成功并显示缩略图

  dt.log.i('STEP 2、左下角缩略图进入大图进行动态照片效果切换');
  dt.log.i('STEP 2.1、点击左下角缩略图');
  await dt.assertClick('motion_photo_captured_thumbnail');
  await dt.assertComponent('lock_screen_unlock_prompt'); // 确认弹出解锁界面

  dt.log.i('预期结果2、点击效果后弹出手机解锁界面，解锁后进入该动态照片大图');
  // 自动化无法直接进行密码解锁，此处假设手动解锁后继续操作
  dt.log.i('STEP 2.2、手动解锁手机');  // await dt.unlockDevice('YOUR_PASSWORD'); // 如果有dt.unlockDevice方法
  await dt.sleep(DELAY.medium); // 等待手动解锁完成

  dt.log.i('STEP 2.3、确认进入动态照片大图');
  await dt.assertComponent('motion_photo_player_page'); // 确认进入动态照片大图页

  dt.log.i('STEP 2.4、进行动态照片效果切换');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  await dt.assertClick('protagonist_moment_effect_option'); // 切换到主角时刻
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片安全相机进大图切换效果 end');
}

/**
 * 大图-动态照片: [动态照片云增强编辑后兼容测试]
 * TAG: 273 TID: Multimedia_Gallery_Motion_picture_083
 */
async function Multimedia_Gallery_Motion_picture_083(dt: Dt) {
  dt.log.i('动态照片云增强编辑后兼容测试 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性');
  dt.log.i('STEP 0.1、确保辅助机已完成超级微距动态照片的拍摄和云增强，且测试机已存在该照片的副本');
  await dt.pressKey(KEY.home);
  await dt.sleep(DELAY.short);
  await dt.assertClick(ON.text('图库')); // 进入图库
  await dt.assertComponent('synced_super_macro_motion_photo_thumbnail', true); // 确认存在同步的超级微距动态照片

  dt.log.i('STEP 1、辅助机xxx拍摄超级微距动态照片并进行云增强');
  dt.log.i('STEP 1.1、此步骤为辅助机操作，确保已完成');

  dt.log.i('STEP 2、任意编辑该动态照片后分享、端云同步、克隆至测试机xxx');
  dt.log.i('STEP 2.1、此步骤为辅助机操作，确保已完成，并确认测试机图库已接收到文件');
  await dt.assertComponent('edited_synced_super_macro_motion_photo_thumbnail', true); // 确认接收到编辑并同步的照片

  dt.log.i('STEP 2.2、点击同步后的动态照片进入大图');
  await dt.assertClick('edited_synced_super_macro_motion_photo_thumbnail_0');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('预期结果2、测试机封面显示与底部图标一致，播放效果正常');
  await dt.assertComponent('cover_display_consistent_with_icons', true); // 封面显示与底部图标一致
  await dt.assertComponent('playback_normal', true); // 播放效果正常

  dt.log.i('STEP 3、在测试机上进行效果切换和编辑操作');
  dt.log.i('STEP 3.1、进行效果切换');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  await dt.assertClick('protagonist_moment_effect_option');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('STEP 3.2、进行编辑操作');
  await dt.assertClick('edit_button');
  await dt.assertComponent('edit_page');
  await dt.assertClick('adjust_tab');
  await dt.drag(ON.id('brightness_slider'), 0.5, 0.6);
  await dt.assertClick('save_button');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('预期结果3、支持效果切换和编辑操作，且效果切换后动态照片封面显示正常，播放效果正常5、测试机封面显示与底部图标一致，播放效果正常，支持效果切换和编辑操作，且效果切换后动态照片封面显示正常，播放效果正常');
  await dt.assertComponent('effect_switching_supported', true); // 支持效果切换
  await dt.assertComponent('editing_supported', true); // 支持编辑
  await dt.assertComponent('cover_display_normal_after_switch', true); // 切换后封面显示正常
  await dt.assertComponent('playback_normal_after_switch', true); // 切换后播放正常

  dt.log.i('STEP 4、辅助机xxx拍摄超级微距动态照片并进行云增强');
  dt.log.i('STEP 4.1、此步骤为辅助机操作，确保已完成');

  dt.log.i('STEP 5、重复步骤2，3');
  dt.log.i('STEP 5.1、确认已完成xxx云增强照片的同步，并在图库中找到该照片');
  await dt.pressBack(); // 返回图库主页
  await dt.assertComponent('synced_dual_framework_super_macro_motion_photo_thumbnail', true);

  dt.log.i('STEP 5.2、点击同步后的动态照片进入大图');
  await dt.assertClick('synced_dual_framework_super_macro_motion_photo_thumbnail_0');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('STEP 5.3、进行效果切换');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  await dt.assertClick('motion_trail_effect_option');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('STEP 5.4、进行编辑操作');
  await dt.assertClick('edit_button');
  await dt.assertComponent('edit_page');
  await dt.assertClick('adjust_tab');
  await dt.drag(ON.id('contrast_slider'), 0.5, 0.7); // 调整对比度
  await dt.assertClick('save_button');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('预期结果5、测试机封面显示与底部图标一致，播放效果正常，支持效果切换和编辑操作，且效果切换后动态照片封面显示正常，播放效果正常');
  await dt.assertComponent('cover_display_consistent_with_icons', true);
  await dt.assertComponent('playback_normal', true);
  await dt.assertComponent('effect_switching_supported', true);
  await dt.assertComponent('editing_supported', true);
  await dt.assertComponent('cover_display_normal_after_switch', true);
  await dt.assertComponent('playback_normal_after_switch', true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片云增强编辑后兼容测试 end');
}

/**
 * 大图-动态照片: [动态照片清晰度测试]
 * TAG: 292 TID: Multimedia_Gallery_Motion_picture_084
 */
async function Multimedia_Gallery_Motion_picture_084(dt: Dt) {
  dt.log.i('动态照片清晰度测试 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性');
  dt.log.i('STEP 0.1、相机拍摄动态照片');
  dt.log.i('STEP 0.1.1、确保图库中存在动态照片并进入图库主页');
  await dt.pressKey(KEY.home);
  await dt.sleep(DELAY.short);
  await dt.assertClick(ON.text('图库')); // 进入图库
  await dt.assertComponent('motion_photo_thumbnail', true);

  dt.log.i('STEP 0.1.2、点击动态照片进入大图页');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('STEP 1、动态照片动态效果切换为其他效果后，切换回动态效果，查看前后清晰度对比');
  dt.log.i('STEP 1.1、切换到主角时刻效果');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  await dt.assertClick('protagonist_moment_effect_option');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('STEP 1.2、切换回动态照片原始效果');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  await dt.assertClick('original_motion_photo_effect_option'); // 切换回动态照片原始效果
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('预期结果1，2,3、前后清晰度一致，无明显清晰度差异');
  // 清晰度需要人工肉眼判断，此处仅输出日志
  dt.log.i('请对比切换前后照片清晰度，应无明显差异');

  dt.log.i('STEP 2、将xxx具有动态效果的动态照片通过端云同步、分享、克隆、碰一碰、隔空分享发送到对端xxx，查看两设备清晰度对比');
  dt.log.i('STEP 2.1、此步骤需手动执行端云同步、分享、克隆、碰一碰、隔空分享，并确保对端设备接收到照片');
  dt.log.i('STEP 2.2、在对端设备查看同步后的动态照片清晰度');
  // 自动化无法直接控制对端设备，此处仅输出日志
  dt.log.i('请在对端xxx设备上查看同步后的动态照片清晰度，与本设备对比');

  dt.log.i('STEP 3、将xxx具有动态效果的动态照片通过端云同步、分享、克隆发送到对端xxx，查看两设备清晰度对比');
  dt.log.i('STEP 3.1、此步骤需手动执行xxx动态照片的同步，并确保对端设备接收到照片');
  dt.log.i('STEP 3.2、在对端设备查看同步后的动态照片清晰度');
  // 自动化无法直接控制对端设备，此处仅输出日志
  dt.log.i('请在对端xxx设备上查看同步后的xxx动态照片清晰度，与本设备对比');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片清晰度测试 end');
}

/**
 * 大图-动态照片: [动态照片智慧多窗效果切换]
 * TAG: 293 TID: Multimedia_Gallery_Motion_picture_085
 */
async function Multimedia_Gallery_Motion_picture_085(dt: Dt) {
  dt.log.i('动态照片智慧多窗效果切换 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性');
  dt.log.i('STEP 0.1、相机拍摄动态照片（覆盖普通动态照片、带水印动态照片、云增强动态照片、编辑后的动态照片，各比例动态照片等；可多场景叠加）');
  dt.log.i('STEP 0.1.1、确保图库中存在符合条件的动态照片并进入图库主页');
  await dt.pressKey(KEY.home);
  await dt.sleep(DELAY.short);
  await dt.assertClick(ON.text('图库')); // 进入图库
  await dt.assertComponent('motion_photo_thumbnail', true);

  dt.log.i('STEP 1、图库开启分屏，进行动态照片大图滑动、效果切换');
  dt.log.i('STEP 1.1、开启分屏模式并确保图库在其中一个分屏中');
  await dt.pressKey(KEY.recent_apps); // 进入最近任务
  await dt.sleep(DELAY.short);
  await dt.assertClick(ON.text('图库_split_screen_button')); // 假设图库有分屏按钮
  await dt.assertComponent('split_screen_mode'); // 确认进入分屏模式
  await dt.assertClick('motion_photo_thumbnail_0'); // 点击动态照片进入大图
  await dt.assertComponent('motion_photo_player_page_in_split_screen'); // 确认在大图分屏模式

  dt.log.i('STEP 1.2、大图滑动');
  await dt.flick('motion_photo_player_page_in_split_screen', 'left');
  await dt.assertComponent('motion_photo_player_page_in_split_screen');

  dt.log.i('STEP 1.3、进行效果切换');
  await dt.assertClick('motion_effect_button_in_split_screen');
  await dt.assertComponent('motion_effect_panel_in_split_screen');
  await dt.assertClick('protagonist_moment_effect_option_in_split_screen');
  await dt.assertComponent('motion_photo_player_page_in_split_screen');

  dt.log.i('预期结果1，2、大图滑动至动态效果的动态照片自动播放，效果切换成功');
  await dt.assertComponent('auto_playback_on_slide_split_screen', true); // 滑动自动播放
  await dt.assertComponent('effect_switching_successful_split_screen', true); // 效果切换成功

  dt.log.i('STEP 2、图库开启悬浮窗，进行动态照片大图滑动、效果切换');
  dt.log.i('STEP 2.1、退出分屏模式并开启悬浮窗');
  await dt.pressKey(KEY.home);
  await dt.sleep(DELAY.short);
  await dt.assertClick(ON.text('图库')); // 重新进入图库
  await dt.swipe(200, 200, 800, 200); // 假设通过手势开启悬浮窗
  await dt.assertComponent('floating_window_mode'); // 确认进入悬浮窗模式
  await dt.assertClick('motion_photo_thumbnail_in_floating_window'); // 点击动态照片进入大图
  await dt.assertComponent('motion_photo_player_page_in_floating_window'); // 确认在大图悬浮窗模式

  dt.log.i('STEP 2.2、大图滑动');
  await dt.flick('motion_photo_player_page_in_floating_window', 'left');
  await dt.assertComponent('motion_photo_player_page_in_floating_window');

  dt.log.i('STEP 2.3、进行效果切换');
  await dt.assertClick('motion_effect_button_in_floating_window');
  await dt.assertComponent('motion_effect_panel_in_floating_window');
  await dt.assertClick('motion_trail_effect_option_in_floating_window');
  await dt.assertComponent('motion_photo_player_page_in_floating_window');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片智慧多窗效果切换 end');
}

/**
 * 大图-动态照片: [动态照片隐私空间效果切换]
 * TAG: 294 TID: Multimedia_Gallery_Motion_picture_086
 */
async function Multimedia_Gallery_Motion_picture_086(dt: Dt) {
  dt.log.i('动态照片隐私空间效果切换 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性');
  dt.log.i('STEP 0.1、相机拍摄动态照片（覆盖普通动态照片、带水印动态照片、云增强动态照片、编辑后的动态照片，各比例动态照片等；可多场景叠加）');
  dt.log.i('STEP 0.1.1、确保图库中存在符合条件的动态照片');
  await dt.pressKey(KEY.home);
  await dt.sleep(DELAY.short);
  await dt.assertClick(ON.text('图库')); // 进入图库
  await dt.assertComponent('motion_photo_thumbnail', true);

  dt.log.i('STEP 0.2、将动态照片放入隐私空间');
  dt.log.i('STEP 0.2.1、将动态照片添加到隐私空间（此步骤需手动操作或预置）');
  await dt.assertClick('motion_photo_thumbnail_0'); // 点击照片
  await dt.assertClick('more_options_button');
  await dt.assertClick('move_to_private_space_option'); // 移动到隐私空间
  await dt.assertComponent('private_space_moved_success'); // 确认移动成功
  await dt.pressBack(); // 返回图库主页

  dt.log.i('STEP 0.2.2、进入隐私空间');
  await dt.assertClick('albums_tab');
  await dt.assertClick('private_space_entry'); // 隐私空间入口
  await dt.assertComponent('private_space_gallery'); // 确认进入隐私空间图库

  dt.log.i('STEP 1、在隐私空间大图滑动查看动态照片');
  dt.log.i('STEP 1.1、点击隐私空间内的动态照片进入大图');
  await dt.assertClick('motion_photo_thumbnail_in_private_space_0');
  await dt.assertComponent('motion_photo_player_page_in_private_space');

  dt.log.i('STEP 1.2、大图滑动');
  await dt.flick('motion_photo_player_page_in_private_space', 'left');
  await dt.assertComponent('motion_photo_player_page_in_private_space');

  dt.log.i('预期结果1、大图滑动至动态效果的动态照片自动播放');
  await dt.assertComponent('auto_playback_on_slide_private_space', true); // 自动播放

  dt.log.i('STEP 2、进行动态照片效果切换');
  dt.log.i('STEP 2.1、点击动态照片效果切换按钮');
  await dt.assertClick('motion_effect_button_in_private_space');
  await dt.assertComponent('motion_effect_panel_in_private_space');
  dt.log.i('STEP 2.2、选择主角时刻效果');
  await dt.assertClick('protagonist_moment_effect_option_in_private_space');
  await dt.assertComponent('motion_photo_player_page_in_private_space');

  dt.log.i('预期结果2、效果切换成功');
  await dt.assertComponent('effect_switching_successful_private_space', true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片隐私空间效果切换 end');
}

/**
 * 大图-动态照片: [动态照片自动播放端云同步测试]
 * TAG: 296 TID: Multimedia_Gallery_Motion_picture_087
 */
async function Multimedia_Gallery_Motion_picture_087(dt: Dt) {
  dt.log.i('动态照片自动播放端云同步测试 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性');
  dt.log.i('STEP 0.1、准备一台xxx设备和两台xxx设备，且均可同步上下云，同时各设备图库存在动态照片');
  dt.log.i('STEP 0.1.1、确保测试机图库中存在已从云端同步的动态照片');
  await dt.pressKey(KEY.home);
  await dt.sleep(DELAY.short);
  await dt.assertClick(ON.text('图库')); // 进入图库
  await dt.assertComponent('cloud_synced_motion_photo_thumbnail', true); // 确认存在云同步的动态照片

  dt.log.i('STEP 1、辅助机将动态效果的动态照片同步上云，测试机查看云同步下行动态照片自动播放效果（自动播放需大图滑动至该动态照片才会自动播放；测试包含xxx）');
  dt.log.i('STEP 1.1、在测试机上找到并点击云同步下行的动态照片');
  await dt.assertClick('cloud_synced_motion_photo_thumbnail_0');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('STEP 1.2、大图滑动到该动态照片');
  await dt.flick('motion_photo_player_page', 'left'); // 假设需要滑动才能触发自动播放
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('预期结果1、动态照片自动播放一次（最大600ms）后停止，播放过程无异常，停止后动态照片停留在封面帧，播放画面结尾与封面帧衔接流畅，滑动自动播放无放大效果');
  await dt.assertComponent('auto_playback_once_synced', true); // 自动播放一次
  await dt.assertComponent('playback_no_abnormalities_synced', true); // 播放无异常
  await dt.assertComponent('stops_on_cover_frame_synced', true); // 停止在封面帧
  await dt.assertComponent('smooth_transition_to_cover_synced', true); // 衔接流畅
  await dt.assertComponent('no_zoom_on_slide_playback_synced', true); // 滑动无放大效果

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片自动播放端云同步测试 end');
}

/**
 * 大图-动态照片: [动态照片效果切换并发场景]
 * TAG: 295 TID: Multimedia_Gallery_Motion_picture_088
 */
async function Multimedia_Gallery_Motion_picture_088(dt: Dt) {
  dt.log.i('动态照片效果切换并发场景 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性');
  dt.log.i('STEP 0.1、相机拍摄多张动态照片');
  dt.log.i('STEP 0.1.1、确保图库中存在多张动态照片并进入图库主页');
  await dt.pressKey(KEY.home);
  await dt.sleep(DELAY.short);
  await dt.assertClick(ON.text('图库')); // 进入图库
  await dt.assertComponent('motion_photo_thumbnail', true);
  await dt.assertComponent('motion_photo_thumbnail_1', true); // 至少两张动态照片

  dt.log.i('STEP 0.1.2、点击第一张动态照片进入大图页');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('STEP 1、进图库动态照片大图，动态照片进行效果切换');
  dt.log.i('STEP 1.1、点击动态照片效果切换按钮');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  dt.log.i('STEP 1.2、选择主角时刻效果（不等待切换完成）');
  await dt.assertClick('protagonist_moment_effect_option');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('STEP 2、效果切换时立刻滑动到下一张动态照片，并进行效果切换');
  dt.log.i('STEP 2.1、立刻滑动到下一张动态照片');
  await dt.flick('motion_photo_player_page', 'left');
  await dt.assertComponent('motion_photo_player_page'); // 确认已切换到下一张照片

  dt.log.i('STEP 2.2、尝试点击效果切换按钮');
  await dt.assertClick('motion_effect_button'); // 尝试点击效果切换按钮
  // 此时预期按钮是置灰的，或者点击后无反应
  await dt.assertComponent('motion_effect_button_disabled', true); // 断言效果切换按钮置灰

  dt.log.i('预期结果2、动态照片仅支持同时一个动态照片进行效果切换，第二个动态照片效果切换入口置灰');
  // 已通过 `assertComponent('motion_effect_button_disabled', true)` 断言置灰

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片效果切换并发场景 end');
}

/**
 * 大图-动态照片: [动态照片效果切换水印查看]
 * TAG: 298 TID: Multimedia_Gallery_Motion_picture_089
 */
async function Multimedia_Gallery_Motion_picture_089(dt: Dt) {
  dt.log.i('动态照片效果切换水印查看 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性');
  dt.log.i('STEP 0.1、相机拍摄带水印动态照片');
  dt.log.i('STEP 0.1.1、确保图库中存在带水印的动态照片并进入图库主页');
  await dt.pressKey(KEY.home);
  await dt.sleep(DELAY.short);
  await dt.assertClick(ON.text('图库')); // 进入图库
  await dt.assertComponent('watermarked_motion_photo_thumbnail', true); // 确认存在带水印动态照片

  dt.log.i('STEP 0.1.2、点击带水印动态照片进入大图页');
  await dt.assertClick('watermarked_motion_photo_thumbnail_0');
  await dt.assertComponent('motion_photo_player_page');

  dt.log.i('STEP 1、图库照片页进入动态照片大图进行效果切换（覆盖动态照片、循环播放、主角时刻、运动轨迹、微动瞬间、关闭效果）');
  dt.log.i('STEP 1.1、确认当前是动态效果，并查看水印');
  await dt.assertComponent('watermark_displayed', true); // 确认水印显示

  dt.log.i('STEP 1.2、切换到循环播放效果，查看水印');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  await dt.assertClick('loop_playback_effect_option');
  await dt.assertComponent('motion_photo_player_page');
  await dt.negateComponent('watermark_displayed'); // 断言水印不显示

  dt.log.i('STEP 1.3、切换到主角时刻效果，查看水印');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  await dt.assertClick('protagonist_moment_effect_option');
  await dt.assertComponent('motion_photo_player_page');
  await dt.negateComponent('watermark_displayed');

  dt.log.i('STEP 1.4、切换到运动轨迹效果，查看水印');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  await dt.assertClick('motion_trail_effect_option');
  await dt.assertComponent('motion_photo_player_page');
  await dt.negateComponent('watermark_displayed');

  dt.log.i('STEP 1.5、切换到微动瞬间效果，查看水印');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  await dt.assertClick('micro_moment_effect_option');
  await dt.assertComponent('motion_photo_player_page');
  await dt.negateComponent('watermark_displayed');

  dt.log.i('STEP 1.6、切换到关闭效果，查看水印');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  await dt.assertClick('close_effect_option');
  await dt.assertComponent('motion_photo_player_page');
  await dt.negateComponent('watermark_displayed');

  dt.log.i('STEP 1.7、切换回动态效果，查看水印');
  await dt.assertClick('motion_effect_button');
  await dt.assertComponent('motion_effect_panel');
  await dt.assertClick('original_motion_photo_effect_option');
  await dt.assertComponent('motion_photo_player_page');
  await dt.assertComponent('watermark_displayed', true);

  dt.log.i('预期结果1、仅动态效果的动态照片支持水印显示');
  // 已通过上述步骤中的断言进行验证

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片效果切换水印查看 end');
}

