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

export default function Multimedia_Gallery_Motion_Picture_002(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('Multimedia_Gallery_Motion_Picture_002', (): void => {
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
    run('Multimedia_Gallery_Motion_picture_010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片通过分享到其他设备] TID: Multimedia_Gallery_Motion_picture_010
      await Multimedia_Gallery_Motion_picture_010(dt);
    });
    run('Multimedia_Gallery_Motion_picture_0100', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [视频HDR显示] TID: Multimedia_Gallery_Motion_picture_0100
      await Multimedia_Gallery_Motion_picture_0100(dt);
    });
    run('Multimedia_Gallery_Motion_picture_011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片通过畅联分享] TID: Multimedia_Gallery_Motion_picture_011
      await Multimedia_Gallery_Motion_picture_011(dt);
    });
    run('Multimedia_Gallery_Motion_picture_012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片克隆] TID: Multimedia_Gallery_Motion_picture_012
      await Multimedia_Gallery_Motion_picture_012(dt);
    });
    run('Multimedia_Gallery_Motion_picture_013', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [不同场景下动态照片长按播放] TID: Multimedia_Gallery_Motion_picture_013
      await Multimedia_Gallery_Motion_picture_013(dt);
    });
    run('Multimedia_Gallery_Motion_picture_014', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片长按播放性能测试] TID: Multimedia_Gallery_Motion_picture_014
      await Multimedia_Gallery_Motion_picture_014(dt);
    });
    run('Multimedia_Gallery_Motion_picture_015', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片长按播放支持松手停止播放] TID: Multimedia_Gallery_Motion_picture_015
      await Multimedia_Gallery_Motion_picture_015(dt);
    });
    run('Multimedia_Gallery_Motion_picture_016', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片大图长按播放压力测试] TID: Multimedia_Gallery_Motion_picture_016
      await Multimedia_Gallery_Motion_picture_016(dt);
    });
    run('Multimedia_Gallery_Motion_picture_017', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片支持长按播放（xxx）] TID: Multimedia_Gallery_Motion_picture_017
      await Multimedia_Gallery_Motion_picture_017(dt);
    });
    run('Multimedia_Gallery_Motion_picture_018', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片支持长按播放（PC）] TID: Multimedia_Gallery_Motion_picture_018
      await Multimedia_Gallery_Motion_picture_018(dt);
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
 * 大图-动态照片: [动态照片通过分享到其他设备]
 * TAG: 58 TID: Multimedia_Gallery_Motion_picture_010
 */
async function Multimedia_Gallery_Motion_picture_010(dt: Dt) {
  dt.log.i('动态照片通过分享到其他设备 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 准备动态照片（可以使用相机拍摄动态照片）');
  dt.log.i('STEP 0.1、启动相机应用');
  await dt.launchCameraApp();
  dt.log.i('STEP 0.2、拍摄动态照片');
  await dt.captureMotionPhoto();
  dt.log.i('STEP 0.3、拍摄第二张动态照片用于多选分享');
  await dt.captureMotionPhoto();
  dt.log.i('STEP 0.4、退出相机并返回图库');
  await dt.exitCameraToGallery();
  dt.log.i('STEP 0.5、断言图库中存在至少两张动态照片');
  await dt.assertComponent('motion_photo_thumbnail_0', true);
  await dt.assertComponent('motion_photo_thumbnail_1', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、xxx将动态照片分享到xxx（单张和多选）');
  dt.log.i('STEP 1.1、选择单张动态照片进行分享');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 1.2、点击分享按钮');
  await dt.assertClick('ShareButton');
  await dt.assertComponent('ShareSheet', true);
  dt.log.i('STEP 1.3、选择分享目标（xxx设备）');
  await dt.assertClick('ShareTarget_SingleFrame'); // 假设分享目标ID
  dt.log.i('请在接收设备上接受并验证分享成功，播放正常，清晰度和声音无异常（当前变成普通照片宫格、大图显示正常，右上角不显示图标）');
  await dt.pressBack(); // 返回大图
  await dt.pressBack(); // 返回宫格

  dt.log.i('STEP 1.4、多选动态照片进行分享');
  await dt.assertLongClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MultiSelectModeToolbar', true);
  await dt.assertClick('motion_photo_thumbnail_1');
  await dt.assertComponent('SelectedCount_2', true);
  dt.log.i('STEP 1.5、点击分享按钮');
  await dt.assertClick('ShareButton');
  await dt.assertComponent('ShareSheet', true);
  dt.log.i('STEP 1.6、选择分享目标（xxx设备）');
  await dt.assertClick('ShareTarget_SingleFrame');
  dt.log.i('请在接收设备上接受并验证分享成功，播放正常，清晰度和声音无异常（当前变成普通照片宫格、大图显示正常，右上角不显示图标）');
  await dt.pressBack(); // 返回多选模式
  await dt.pressBack(); // 退出多选模式

  dt.log.i('预期结果1,2,3、分享成功，能够正常播放动态照片，且播放清晰度正常，声音无异常（当前变成普通照片宫格、大图显示正常，右上角不显示图标）');

  dt.log.i('STEP 2、xxx将动态照片分享到xxx（单张和多选）');
  dt.log.i('STEP 2.1、选择单张动态照片进行分享');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  await dt.assertClick('ShareButton');
  await dt.assertComponent('ShareSheet', true);
  dt.log.i('STEP 2.2、选择分享目标（xxx设备）');
  await dt.assertClick('ShareTarget_DualFrame'); // 假设分享目标ID
  dt.log.i('请在接收设备上接受并验证分享成功，播放正常，清晰度和声音无异常');
  await dt.pressBack();
  await dt.pressBack();

  dt.log.i('STEP 2.3、多选动态照片进行分享');
  await dt.assertLongClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MultiSelectModeToolbar', true);
  await dt.assertClick('motion_photo_thumbnail_1');
  await dt.assertComponent('SelectedCount_2', true);
  await dt.assertClick('ShareButton');
  await dt.assertComponent('ShareSheet', true);
  dt.log.i('STEP 2.4、选择分享目标（xxx设备）');
  await dt.assertClick('ShareTarget_DualFrame');
  dt.log.i('请在接收设备上接受并验证分享成功，播放正常，清晰度和声音无异常');
  await dt.pressBack();
  await dt.pressBack();

  dt.log.i('STEP 3、xxx将动态照片分享到xxx（单张和多选）');
  dt.log.i('STEP 3.1、在xxx设备上选择单张动态照片进行分享');
  dt.log.i('请在xxx设备上执行选择单张动态照片并分享到xxx设备的步骤');
  await dt.assertClick('dual_frame_motion_photo_thumbnail_0'); // 假设xxx设备控制
  await dt.assertClick('ShareButton');
  await dt.assertClick('ShareTarget_SingleFrame');
  dt.log.i('请在本设备上接受并验证分享成功，播放正常，清晰度和声音无异常');

  dt.log.i('STEP 3.2、在xxx设备上多选动态照片进行分享');
  dt.log.i('请在xxx设备上执行多选动态照片并分享到xxx设备的步骤');
  await dt.assertLongClick('dual_frame_motion_photo_thumbnail_0');
  await dt.assertClick('dual_frame_motion_photo_thumbnail_1');
  await dt.assertClick('ShareButton');
  await dt.assertClick('ShareTarget_SingleFrame');
  dt.log.i('请在本设备上接受并验证分享成功，播放正常，清晰度和声音无异常');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片通过分享到其他设备 end');
}


/**
 * 大图-HDR: [视频HDR显示]
 * TAG: 35 TID: Multimedia_Gallery_Motion_picture_0100
 */
async function Multimedia_Gallery_Motion_picture_0100(dt: Dt) {
  dt.log.i('视频HDR显示 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 相机开启HDR拍摄，拍摄视频');
  dt.log.i('STEP 0.1、启动相机应用');
  await dt.launchCameraApp();
  dt.log.i('STEP 0.2、确保相机开启HDR模式（若有此选项）');
  await dt.ensureHDRModeEnabled(); // Placeholder: Assumes a method to ensure HDR mode
  dt.log.i('STEP 0.3、拍摄一段HDR视频');
  await dt.captureHDRVideo(); // Placeholder: Captures HDR video
  dt.log.i('STEP 0.4、退出相机并返回图库');
  await dt.exitCameraToGallery();
  dt.log.i('STEP 0.5、断言图库中存在刚拍摄的视频');
  await dt.assertComponent('video_thumbnail_0', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、图库进入视频大图 ');
  dt.log.i('STEP 1.1、点击视频缩略图进入大图');
  await dt.assertClick('video_thumbnail_0');
  await dt.assertComponent('VideoLargeView', true); // 断言进入视频大图视图

  dt.log.i('预期结果1、大图封面有HDR效果');
  dt.log.i('STEP 1.2、请手动验证大图封面显示HDR效果');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、点击播放视频');
  dt.log.i('STEP 2.1、点击播放按钮');
  await dt.assertClick('VideoPlayButton');
  await dt.assertComponent('VideoPlaying', true); // 断言视频正在播放

  dt.log.i('预期结果2、播放视频有HDR效果');
  dt.log.i('STEP 2.2、请手动验证播放视频有HDR效果');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、视频编辑保存后查看视频');
  dt.log.i('STEP 3.1、停止视频播放并进入编辑模式');
  await dt.assertClick('VideoPlaying'); // 停止播放
  await dt.assertClick('EditButton');
  await dt.assertComponent('VideoEditPage', true); // 断言进入视频编辑页面

  dt.log.i('STEP 3.2、对视频进行简单编辑并保存');
  await dt.assertClick('TrimStartHandle'); // 假设修剪开始把手
  await dt.swipe(100, 500, 200, 500); // 稍微修剪
  await dt.assertClick('SaveButton');
  await dt.assertComponent('VideoSavingDialog', true);
  await dt.assertComponent('VideoLargeView', true); // 断言保存后返回大图

  dt.log.i('预期结果3、编辑保存后播放视频有HDR效果');
  dt.log.i('STEP 3.3、点击播放编辑后的视频');
  await dt.assertClick('VideoPlayButton');
  await dt.assertComponent('VideoPlaying', true);
  dt.log.i('请手动验证编辑保存后播放视频有HDR效果');
  await dt.assertComponent(PageTitle.index, true); // 断言仍在当前页面

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('视频HDR显示 end');
}


/**
 * 大图-动态照片: [动态照片通过畅联分享]
 * TAG: 50 TID: Multimedia_Gallery_Motion_picture_011
 */
async function Multimedia_Gallery_Motion_picture_011(dt: Dt) {
  dt.log.i('动态照片通过畅联分享 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 准备动态照片（可以使用相机拍摄动态照片）');
  dt.log.i('STEP 0.1、启动相机应用');
  await dt.launchCameraApp();
  dt.log.i('STEP 0.2、拍摄动态照片');
  await dt.captureMotionPhoto();
  dt.log.i('STEP 0.3、拍摄第二张动态照片用于多选分享');
  await dt.captureMotionPhoto();
  dt.log.i('STEP 0.4、退出相机并返回图库');
  await dt.exitCameraToGallery();
  dt.log.i('STEP 0.5、断言图库中存在至少两张动态照片');
  await dt.assertComponent('motion_photo_thumbnail_0', true);
  await dt.assertComponent('motion_photo_thumbnail_1', true);
  dt.log.i('STEP 0.6、确保畅联功能已开启并配置完成');
  await dt.ensureCeliaEnabled(); // Placeholder: Assumes a method to ensure Celia is enabled
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、xxx将动态照片通过畅联分享（单张和多选）');
  dt.log.i('STEP 1.1、选择单张动态照片进行分享');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 1.2、点击分享按钮');
  await dt.assertClick('ShareButton');
  await dt.assertComponent('ShareSheet', true);
  dt.log.i('STEP 1.3、选择畅联分享目标');
  await dt.assertClick('CeliaShareTarget'); // 假设畅联分享目标ID
  dt.log.i('预期结果1、分享成功，能够正常播放动态照片，且播放清晰度正常，声音无异常（当前变成普通照片宫格、大图显示正常，右上角不显示图标）');
  dt.log.i('请在接收设备上验证分享成功，播放正常，清晰度和声音无异常');
  await dt.pressBack(); // 返回大图
  await dt.pressBack(); // 返回宫格

  dt.log.i('STEP 1.4、多选动态照片进行分享');
  await dt.assertLongClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MultiSelectModeToolbar', true);
  await dt.assertClick('motion_photo_thumbnail_1');
  await dt.assertComponent('SelectedCount_2', true);
  dt.log.i('STEP 1.5、点击分享按钮');
  await dt.assertClick('ShareButton');
  await dt.assertComponent('ShareSheet', true);
  dt.log.i('STEP 1.6、选择畅联分享目标');
  await dt.assertClick('CeliaShareTarget');
  dt.log.i('请在接收设备上验证分享成功，播放正常，清晰度和声音无异常');
  await dt.pressBack(); // 返回多选模式
  await dt.pressBack(); // 退出多选模式

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片通过畅联分享 end');
}


/**
 * 大图-动态照片: [动态照片克隆]
 * TAG: 64 TID: Multimedia_Gallery_Motion_picture_012
 */
async function Multimedia_Gallery_Motion_picture_012(dt: Dt) {
  dt.log.i('动态照片克隆 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 准备动态照片（可以使用相机拍摄动态照片）');
  dt.log.i('STEP 0.1、启动相机应用');
  await dt.launchCameraApp();
  dt.log.i('STEP 0.2、拍摄动态照片');
  await dt.captureMotionPhoto();
  dt.log.i('STEP 0.3、退出相机并返回图库');
  await dt.exitCameraToGallery();
  dt.log.i('STEP 0.4、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail_0', true);
  dt.log.i('STEP 0.5、确保测试环境支持模拟xxx设备和克隆功能');
  await dt.ensureDualFrameDevice(); // Placeholder: Assumes a method to ensure dual frame device is ready
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、xxx将动态照片克隆到xxx');
  dt.log.i('STEP 1.1、在xxx设备上选择动态照片进行克隆');
  dt.log.i('请在xxx设备上执行选择动态照片并克隆到xxx设备的步骤');
  await dt.assertClick('dual_frame_motion_photo_thumbnail_0'); // 假设xxx设备控制
  await dt.assertClick('MoreOptionsButton');
  await dt.assertClick('CloneOption');
  await dt.assertClick('ConfirmCloneButton');
  dt.log.i('STEP 1.2、在本设备上（xxx）确认接收到克隆的动态照片');
  await dt.sleep(DELAY.long); // 等待克隆完成
  await dt.assertComponent('motion_photo_thumbnail_cloned', true); // 假设克隆的动态照片有特定ID

  dt.log.i('预期结果1，,2、克隆成功，并且xxx显示正常，可以长按播放，且播放清晰度正常，声音无异常（当前变成普通照片宫格、大图显示正常，右上角不显示图标）');
  dt.log.i('STEP 1.3、点击克隆的动态照片进入大图并长按播放');
  await dt.assertClick('motion_photo_thumbnail_cloned');
  await dt.assertComponent('MotionPictureLargeView', true);
  await dt.assertLongClickById('MotionPicturePlaybackArea');
  dt.log.i('请手动验证播放清晰度正常，声音无异常，右上角不显示图标');
  await dt.pressBack();
  await dt.pressBack();

  dt.log.i('STEP 2、xxx将动态照片克隆到xxx');
  dt.log.i('STEP 2.1、选择xxx动态照片进行克隆');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 2.2、点击更多选项按钮');
  await dt.assertClick('MoreOptionsButton');
  await dt.assertComponent('MoreOptionsMenu', true);
  dt.log.i('STEP 2.3、点击克隆选项');
  await dt.assertClick('CloneOption');
  await dt.assertComponent('CloneConfirmationDialog', true);
  dt.log.i('STEP 2.4、确认克隆');
  await dt.assertClick('ConfirmCloneButton');
  await dt.assertComponent('MotionPictureLargeView', true); // 断言仍在当前大图
  dt.log.i('STEP 2.5、返回图库宫格视图，查看克隆后的动态照片');
  await dt.pressBack();
  await dt.assertComponent('motion_photo_thumbnail_new_cloned', true); // 假设新的克隆照片会出现在列表

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片克隆 end');
}


/**
 * 大图-动态照片: [不同场景下动态照片长按播放]
 * TAG: 55 TID: Multimedia_Gallery_Motion_picture_013
 */
async function Multimedia_Gallery_Motion_picture_013(dt: Dt) {
  dt.log.i('不同场景下动态照片长按播放 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 准备动态照片（可以使用相机拍摄动态照片）');
  dt.log.i('STEP 0.1、启动相机应用');
  await dt.launchCameraApp();
  dt.log.i('STEP 0.2、拍摄动态照片');
  await dt.captureMotionPhoto();
  dt.log.i('STEP 0.3、退出相机并返回图库');
  await dt.exitCameraToGallery();
  dt.log.i('STEP 0.4、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail_0', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、在分屏或悬浮窗状态下长按播放动态照片');
  dt.log.i('STEP 1.1、进入分屏模式');
  await dt.enterSplitScreen(); // Placeholder: Assumes a method to enter split screen
  await dt.assertComponent('SplitScreenView', true); // 断言进入分屏视图
  dt.log.i('STEP 1.2、在图库部分点击动态照片进入大图并长按播放');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView_SplitScreen', true); // 断言分屏大图视图
  await dt.assertLongClickById('MotionPicturePlaybackArea_SplitScreen');
  dt.log.i('预期结果1、分屏或悬浮窗状态下长按播放动态照片一切正常');
  dt.log.i('请手动验证分屏状态下播放正常');
  await dt.exitSplitScreen(); // 退出分屏
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 1.3、进入悬浮窗模式');
  await dt.enterFloatingWindow(); // Placeholder: Assumes a method to enter floating window
  await dt.assertComponent('FloatingWindowView', true); // 断言进入悬浮窗视图
  dt.log.i('STEP 1.4、在图库悬浮窗中点击动态照片进入大图并长按播放');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView_FloatingWindow', true); // 断言悬浮窗大图视图
  await dt.assertLongClickById('MotionPicturePlaybackArea_FloatingWindow');
  dt.log.i('请手动验证悬浮窗状态下播放正常');
  await dt.exitFloatingWindow(); // 退出悬浮窗
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2、图库大图动态照片播放过程中进行屏幕旋转或多任务（非智慧多窗场景下）');
  dt.log.i('STEP 2.1、进入动态照片大图并开始长按播放');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  await dt.assertLongClickById('MotionPicturePlaybackArea');
  await dt.assertComponent('PlayingIndicator', true); // 断言正在播放

  dt.log.i('STEP 2.2、在播放过程中进行屏幕旋转');
  await dt.rotateScreen(); // Placeholder: Assumes a method to rotate screen
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2.1、播放过程中进行屏幕旋转停止播放');
  await dt.negateComponent('PlayingIndicator'); // 断言停止播放
  dt.log.i('请手动验证屏幕旋转后播放停止');
  await dt.rotateScreen(); // 旋转回来
  await dt.assertComponent('MotionPictureLargeView', true);

  dt.log.i('STEP 2.3、在播放过程中进行多任务操作');
  await dt.assertLongClickById('MotionPicturePlaybackArea'); // 重新开始播放
  await dt.assertComponent('PlayingIndicator', true);
  await dt.openRecentApps(); // Placeholder: Assumes a method to open recent apps
  await dt.assertComponent('RecentAppsView', true); // 断言进入多任务界面
  dt.log.i('预期结果2.2、播放过程中进行多任务会调出多任务，播放停止');
  await dt.negateComponent('PlayingIndicator_RecentApps'); // 断言多任务界面中没有播放指示器
  dt.log.i('请手动验证进入多任务界面后播放停止');
  await dt.assertClick('GalleryAppCard'); // 返回图库
  await dt.assertComponent('MotionPictureLargeView', true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('不同场景下动态照片长按播放 end');
}


/**
 * 大图-动态照片: [动态照片长按播放性能测试]
 * TAG: 48 TID: Multimedia_Gallery_Motion_picture_014
 */
async function Multimedia_Gallery_Motion_picture_014(dt: Dt) {
  dt.log.i('动态照片长按播放性能测试 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 准备动态照片（可以使用相机拍摄动态照片）');
  dt.log.i('STEP 0.1、启动相机应用');
  await dt.launchCameraApp();
  dt.log.i('STEP 0.2、拍摄动态照片');
  await dt.captureMotionPhoto();
  dt.log.i('STEP 0.3、退出相机并返回图库');
  await dt.exitCameraToGallery();
  dt.log.i('STEP 0.4、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail_0', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、录制xxx动态照片长按播放视频并数帧');
  dt.log.i('STEP 1.1、进入动态照片大图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 1.2、开始录制屏幕并长按播放动态照片');
  await dt.startScreenRecording(); // Placeholder: Starts screen recording
  await dt.assertLongClickById('MotionPicturePlaybackArea');
  await dt.sleep(DELAY.long); // 确保播放完成
  await dt.stopScreenRecording(); // Stops screen recording

  dt.log.i('预期结果1,2、手指按压到开始播放响应时延不超过400ms(5%误差)；动态照片从播放到完成的最长完成时延不超过3.5s，最小不小于1s');
  dt.log.i('STEP 1.3、分析录制视频，计算响应时延和播放时长');
  dt.log.i('请手动分析录制视频，验证响应时延和播放时长是否符合预期');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、查看xxx动态照片长按播放trace');
  dt.log.i('STEP 2.1、收集动态照片长按播放的系统trace日志');
  await dt.startTraceCapture(); // Placeholder: Starts trace capture
  await dt.assertLongClickById('MotionPicturePlaybackArea');
  await dt.sleep(DELAY.long);
  await dt.stopTraceCapture(); // Stops trace capture

  dt.log.i('STEP 2.2、分析trace日志，验证性能指标');
  dt.log.i('请手动分析trace日志，验证性能指标是否符合预期');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片长按播放性能测试 end');
}


/**
 * 大图-动态照片: [动态照片长按播放支持松手停止播放]
 * TAG: 52 TID: Multimedia_Gallery_Motion_picture_015
 */
async function Multimedia_Gallery_Motion_picture_015(dt: Dt) {
  dt.log.i('动态照片长按播放支持松手停止播放 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 准备动态照片（可以使用相机拍摄动态照片）');
  dt.log.i('STEP 0.1、启动相机应用');
  await dt.launchCameraApp();
  dt.log.i('STEP 0.2、拍摄动态照片');
  await dt.captureMotionPhoto();
  dt.log.i('STEP 0.3、退出相机并返回图库');
  await dt.exitCameraToGallery();
  dt.log.i('STEP 0.4、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail_0', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、从图库照片页进入动态照片大图');
  dt.log.i('STEP 1.1、点击动态照片缩略图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true); // 断言进入大图视图

  dt.log.i('STEP 2、长按该动态照片大图播放，并且在播放过程中松手');
  dt.log.i('STEP 2.1、开始长按播放');
  await dt.longPressAndHold('MotionPicturePlaybackArea'); // 长按但不松开
  await dt.assertComponent('PlayingIndicator', true); // 断言正在播放

  dt.log.i('STEP 2.2、在播放过程中松手');
  await dt.releaseFinger(); // 松开手指
  await dt.sleep(DELAY.short); // 等待停止

  dt.log.i('预期结果2、松手停止播放');
  dt.log.i('STEP 2.3、断言播放停止');
  await dt.negateComponent('PlayingIndicator'); // 断言播放指示器消失
  await dt.assertComponent('PlayButton', true); // 断言播放按钮出现
  dt.log.i('请手动验证松手后立即停止播放');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片长按播放支持松手停止播放 end');
}


/**
 * 大图-动态照片: [动态照片大图长按播放压力测试]
 * TAG: 56 TID: Multimedia_Gallery_Motion_picture_016
 */
async function Multimedia_Gallery_Motion_picture_016(dt: Dt) {
  dt.log.i('动态照片大图长按播放压力测试 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 准备动态照片（可以使用相机拍摄动态照片）');
  dt.log.i('STEP 0.1、启动相机应用');
  await dt.launchCameraApp();
  dt.log.i('STEP 0.2、拍摄动态照片');
  await dt.captureMotionPhoto();
  dt.log.i('STEP 0.3、退出相机并返回图库');
  await dt.exitCameraToGallery();
  dt.log.i('STEP 0.4、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail_0', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、重复长按动态照片大图播放操作100次');
  dt.log.i('STEP 1.1、进入动态照片大图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);

  for (let i = 0; i < 100; i++) {
    dt.log.i(`STEP 1.${i + 2}、第 ${i + 1} 次长按播放`);
    await dt.assertLongClickById('MotionPicturePlaybackArea');
    await dt.assertComponent('PlayingIndicator', true); // 断言开始播放
    await dt.sleep(DELAY.short); // 播放一段时间
    await dt.releaseFinger(); // 松手停止
    await dt.negateComponent('PlayingIndicator'); // 断言停止播放
    await dt.assertComponent('PlayButton', true); // 断言播放按钮出现
    await dt.sleep(DELAY.extraShort); // 短暂间隔
  }

  dt.log.i('预期结果1、动态照片播放清晰度正常，声音无异常，图库本身无异常');
  dt.log.i('请手动验证100次播放过程中，清晰度、声音正常，且图库无闪退、卡顿等异常');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片大图长按播放压力测试 end');
}


/**
 * 大图-动态照片: [动态照片支持长按播放（xxx）]
 * TAG: 45 TID: Multimedia_Gallery_Motion_picture_017
 */
async function Multimedia_Gallery_Motion_picture_017(dt: Dt) {
  dt.log.i('动态照片支持长按播放（xxx） start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 准备动态照片（可以使用相机拍摄动态照片）');
  dt.log.i('STEP 0.1、启动相机应用');
  await dt.launchCameraApp();
  dt.log.i('STEP 0.2、拍摄动态照片');
  await dt.captureMotionPhoto();
  dt.log.i('STEP 0.3、退出相机并返回图库');
  await dt.exitCameraToGallery();
  dt.log.i('STEP 0.4、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail_0', true);
  dt.log.i('STEP 0.5、断言当前设备为xxx设备');
  await dt.assertDeviceType('foldable'); // Placeholder: Assumes a method to check device type
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、从图库照片页进入动态照片大图');
  dt.log.i('STEP 1.1、点击动态照片缩略图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true); // 断言进入大图视图

  dt.log.i('预期结果1、动态照片宫格缩略图显示清晰无异常');
  dt.log.i('请手动验证动态照片宫格缩略图显示清晰无异常');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、xxx、xxx长按该动态照片大图');
  dt.log.i('STEP 2.1、在xxx下长按播放');
  await dt.foldDevice(); // Placeholder: Folds the device
  await dt.assertComponent('MotionPictureLargeView_Folded', true); // 断言xxx大图视图
  await dt.assertLongClickById('MotionPicturePlaybackArea_Folded');
  await dt.assertComponent('PlayingIndicator', true);
  dt.log.i('请手动验证xxx下播放正常，清晰度正常，声音无异常');
  await dt.releaseFinger();
  await dt.negateComponent('PlayingIndicator');

  dt.log.i('STEP 2.2、在xxx下长按播放');
  await dt.unfoldDevice(); // Unfolds the device
  await dt.assertComponent('MotionPictureLargeView', true); // 断言xxx大图视图
  await dt.assertLongClickById('MotionPicturePlaybackArea');
  await dt.assertComponent('PlayingIndicator', true);
  dt.log.i('预期结果2、能够正常播放动态照片，且播放清晰度正常，声音无异常');
  dt.log.i('请手动验证xxx下播放正常，清晰度正常，声音无异常');
  await dt.releaseFinger();
  await dt.negateComponent('PlayingIndicator');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、xxx、xxx再次长按该动态照片大图播放，并且在播放过程中松手');
  dt.log.i('STEP 3.1、在xxx下长按播放并松手');
  await dt.foldDevice();
  await dt.assertComponent('MotionPictureLargeView_Folded', true);
  await dt.longPressAndHold('MotionPicturePlaybackArea_Folded');
  await dt.assertComponent('PlayingIndicator', true);
  await dt.releaseFinger();
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3、松手停止播放');
  await dt.negateComponent('PlayingIndicator');
  dt.log.i('请手动验证xxx下松手停止播放');

  dt.log.i('STEP 3.2、在xxx下长按播放并松手');
  await dt.unfoldDevice();
  await dt.assertComponent('MotionPictureLargeView', true);
  await dt.longPressAndHold('MotionPicturePlaybackArea');
  await dt.assertComponent('PlayingIndicator', true);
  await dt.releaseFinger();
  await dt.sleep(DELAY.short);
  dt.log.i('请手动验证xxx下松手停止播放');
  await dt.negateComponent('PlayingIndicator');
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 4、播放过程中xxx、xxx切换');
  dt.log.i('STEP 4.1、在xxx下开始长按播放');
  await dt.assertLongClickById('MotionPicturePlaybackArea');
  await dt.assertComponent('PlayingIndicator', true);

  dt.log.i('STEP 4.2、在播放过程中切换到xxx');
  await dt.foldDevice();
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果4、切换后停止播放');
  await dt.negateComponent('PlayingIndicator_Folded');
  dt.log.i('请手动验证切换到xxx后播放停止');
  await dt.unfoldDevice(); // 切换回xxx
  await dt.assertComponent('MotionPictureLargeView', true);

  dt.log.i('STEP 4.3、在xxx下开始长按播放');
  await dt.assertLongClickById('MotionPicturePlaybackArea');
  await dt.assertComponent('PlayingIndicator', true);

  dt.log.i('STEP 4.4、在播放过程中切换到xxx (从xxx开始)');
  await dt.foldDevice(); // 先xxx
  await dt.sleep(DELAY.short);
  await dt.negateComponent('PlayingIndicator_Folded'); // 确认停止
  await dt.unfoldDevice(); // 展开
  await dt.sleep(DELAY.short);
  dt.log.i('请手动验证从xxx切换到xxx后播放停止');
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片支持长按播放（xxx） end');
}


/**
 * 大图-动态照片: [动态照片支持长按播放（PC）]
 * TAG: 54 TID: Multimedia_Gallery_Motion_picture_018
 */
async function Multimedia_Gallery_Motion_picture_018(dt: Dt) {
  dt.log.i('动态照片支持长按播放（PC） start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 准备动态照片（可以使用相机拍摄动态照片）');
  dt.log.i('STEP 0.1、启动相机应用');
  await dt.launchCameraApp();
  dt.log.i('STEP 0.2、拍摄动态照片');
  await dt.captureMotionPhoto();
  dt.log.i('STEP 0.3、退出相机并返回图库');
  await dt.exitCameraToGallery();
  dt.log.i('STEP 0.4、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail_0', true);
  dt.log.i('STEP 0.5、断言当前设备已连接到PC模式或支持PC模式操作');
  await dt.assertPCModeEnabled(); // Placeholder: Assumes a method to check PC mode
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、从图库照片页进入动态照片大图');
  dt.log.i('STEP 1.1、点击动态照片缩略图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true); // 断言进入大图视图

  dt.log.i('预期结果1、动态照片宫格缩略图显示清晰无异常');
  dt.log.i('请手动验证动态照片宫格缩略图显示清晰无异常');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、鼠标长按该动态照片大图');
  dt.log.i('STEP 2.1、模拟鼠标长按操作');
  await dt.mouseLongPress('MotionPicturePlaybackArea'); // Placeholder: Simulates mouse long press
  await dt.assertComponent('PlayingIndicator', true); // 断言正在播放

  dt.log.i('预期结果2、能够正常播放动态照片，且播放清晰度正常，声音无异常');
  dt.log.i('请手动验证能够正常播放动态照片，且播放清晰度正常，声音无异常');
  await dt.mouseRelease(); // 模拟鼠标松开
  await dt.negateComponent('PlayingIndicator');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、再次长按该动态照片大图播放，并且在播放过程中松手');
  dt.log.i('STEP 3.1、模拟鼠标再次长按操作');
  await dt.mouseLongPress('MotionPicturePlaybackArea');
  await dt.assertComponent('PlayingIndicator', true);

  dt.log.i('STEP 3.2、在播放过程中模拟鼠标松开');
  await dt.mouseRelease();
  await dt.sleep(DELAY.short);

  dt.log.i('预期结果3、松手停止播放');
  dt.log.i('STEP 3.3、断言播放停止');
  await dt.negateComponent('PlayingIndicator');
  await dt.assertComponent('PlayButton', true); // 断言播放按钮出现
  dt.log.i('请手动验证松手停止播放');
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片支持长按播放（PC） end');
}

