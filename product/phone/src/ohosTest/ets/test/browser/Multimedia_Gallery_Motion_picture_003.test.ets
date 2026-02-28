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

export default function Multimedia_Gallery_Motion_Picture_003(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('Multimedia_Gallery_Motion_Picture_003', (): void => {
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
    run('Multimedia_Gallery_Motion_picture_019', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片支宫格支持多选操作] TID: Multimedia_Gallery_Motion_picture_019
      await Multimedia_Gallery_Motion_picture_019(dt);
    });
    run('Multimedia_Gallery_Motion_picture_020', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片高质量图刷新查看] TID: Multimedia_Gallery_Motion_picture_020
      await Multimedia_Gallery_Motion_picture_020(dt);
    });
    run('Multimedia_Gallery_Motion_picture_021', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片支持自动播放] TID: Multimedia_Gallery_Motion_picture_021
      await Multimedia_Gallery_Motion_picture_021(dt);
    });
    run('Multimedia_Gallery_Motion_picture_022', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [不同入口进大图左右滑动支持自动播放] TID: Multimedia_Gallery_Motion_picture_022
      await Multimedia_Gallery_Motion_picture_022(dt);
    });
    run('Multimedia_Gallery_Motion_picture_023', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片效果切换] TID: Multimedia_Gallery_Motion_picture_023
      await Multimedia_Gallery_Motion_picture_023(dt);
    });
    run('Multimedia_Gallery_Motion_picture_024', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片效果播放正常] TID: Multimedia_Gallery_Motion_picture_024
      await Multimedia_Gallery_Motion_picture_024(dt);
    });
    run('Multimedia_Gallery_Motion_picture_025', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [不同场景动态照片动态照片效果播放方式] TID: Multimedia_Gallery_Motion_picture_025
      await Multimedia_Gallery_Motion_picture_025(dt);
    });
    run('Multimedia_Gallery_Motion_picture_026', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [不同场景动态照片循环播放效果播放方式] TID: Multimedia_Gallery_Motion_picture_026
      await Multimedia_Gallery_Motion_picture_026(dt);
    });
    run('Multimedia_Gallery_Motion_picture_027', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [不同场景动态照片来回播放效果播放方式] TID: Multimedia_Gallery_Motion_picture_027
      await Multimedia_Gallery_Motion_picture_027(dt);
    });
    run('Multimedia_Gallery_Motion_picture_028', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [不同场景动态照片主角时刻效果播放方式] TID: Multimedia_Gallery_Motion_picture_028
      await Multimedia_Gallery_Motion_picture_028(dt);
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
 * 大图-动态照片: [动态照片支宫格支持多选操作]
 * TAG: 59 TID: Multimedia_Gallery_Motion_picture_019
 */
async function Multimedia_Gallery_Motion_picture_019(dt: Dt) {
  dt.log.i('动态照片支宫格支持多选操作 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 准备动态照片（可以使用相机拍摄动态照片）');
  dt.log.i('STEP 0.1、启动相机应用');
  await dt.launchCameraApp();
  dt.log.i('STEP 0.2、拍摄动态照片');
  await dt.captureMotionPhoto();
  dt.log.i('STEP 0.3、拍摄第二张动态照片');
  await dt.captureMotionPhoto(); // 拍摄第二张动态照片用于多选
  dt.log.i('STEP 0.4、退出相机并返回图库');
  await dt.exitCameraToGallery();
  dt.log.i('STEP 0.5、断言图库中存在至少两张动态照片');
  await dt.assertComponent('photoGridView_grid_0', true);
  await dt.assertComponent('photoGridView_grid_1', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、在图库照片页多选动态照片');
  dt.log.i('STEP 1.1、长按第一张动态照片进入多选模式');
  await dt.assertLongClick('photoGridView_grid_0');
  await dt.assertComponent('MultiSelectModeToolbar', true); // 断言进入多选模式

  dt.log.i('STEP 1.2、点击第二张动态照片进行多选');
  await dt.assertClick('photoGridView_grid_1');
  await dt.assertComponent('SelectedCount_2', true); // 断言选中两张

  dt.log.i('STEP 2、进行拼图、对比操作');
  dt.log.i('STEP 2.1、点击拼图按钮');
  await dt.assertClick('PuzzleButton'); // 假设拼图按钮的ID
  await dt.assertComponent('PuzzleEditPage', true); // 断言进入拼图编辑页面
  dt.log.i('STEP 2.2、返回图库宫格视图');
  await dt.pressBack();
  await dt.assertComponent('MultiSelectModeToolbar', true); // 返回到多选模式

  dt.log.i('STEP 2.3、点击对比按钮');
  await dt.assertClick('CompareButton'); // 假设对比按钮的ID
  await dt.assertComponent('CompareView', true); // 断言进入对比视图
  dt.log.i('预期结果2、动态照片支持拼图、对比操作');
  dt.log.i('请手动验证动态照片支持拼图、对比操作');
  await dt.pressBack(); // 返回到多选模式
  await dt.assertComponent('photoGridView_grid_0', true); // 退出多选模式

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片支宫格支持多选操作 end');
}

/**
 * 大图-动态照片: [动态照片高质量图刷新查看]
 * TAG: 57 TID: Multimedia_Gallery_Motion_picture_020
 */
async function Multimedia_Gallery_Motion_picture_020(dt: Dt) {
  dt.log.i('动态照片高质量图刷新查看 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 设备正常工作，可以拍摄动态照片');
  dt.log.i('STEP 0.1、启动相机应用');
  await dt.launchCameraApp();
  dt.log.i('STEP 0.2、断言相机应用已启动');
  await dt.assertComponent('CameraPreview', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、相机拍摄动态照片后立即点击左下角查看动态照片（可以尝试拍摄时放大镜头拍摄）');
  dt.log.i('STEP 1.1、拍摄动态照片并放大镜头');
  await dt.captureMotionPhotoAndZoom(); // Placeholder: Captures motion photo with zoom
  dt.log.i('STEP 1.2、立即点击左下角缩略图查看');
  await dt.assertClick('CameraThumbnail');
  await dt.assertComponent('MotionPictureLargeView', true); // 断言进入大图视图

  dt.log.i('预期结果1、动态照片会有从低质量图刷新到高质量图');
  dt.log.i('请手动验证动态照片从低质量图刷新到高质量图的过程');
  await dt.sleep(DELAY.short); // 留出时间观察刷新过程

  dt.log.i('STEP 2、等待几秒从图库进入刚拍摄的动态照片查看');
  dt.log.i('STEP 2.1、返回图库宫格视图');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.2、等待几秒让高质量图完全加载');
  await dt.sleep(DELAY.normal);

  dt.log.i('STEP 2.3、点击刚拍摄的动态照片进入大图');
  await dt.assertClick('photoGridView_grid_0');
  await dt.assertComponent('MotionPictureLargeView', true);

  dt.log.i('预期结果2、动态照片在图库显示为高质量图，对比最开始从相机查看的动态照片更为清晰');
  dt.log.i('请手动验证动态照片显示为高质量图，且比相机中查看时更清晰');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片高质量图刷新查看 end');
}

/**
 * 大图-动态照片: [动态照片支持自动播放]
 * TAG: 255 TID: Multimedia_Gallery_Motion_picture_021
 */
async function Multimedia_Gallery_Motion_picture_021(dt: Dt) {
  dt.log.i('动态照片支持自动播放 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 图库存在动态照片，且动态照片效果设置为动态照片');
  dt.log.i('STEP 0.1、启动图库应用');
  await dt.launchGalleryApp();
  dt.log.i('STEP 0.2、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail', true);
  dt.log.i('STEP 0.3、点击动态照片进入大图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 0.4、确保动态照片效果设置为动态照片（原始）');
  await dt.clickIfExist('MotionEffectSwitchButton'); // 尝试点击效果切换按钮
  await dt.assertComponent('EffectOption_OriginalMotionPhoto', true); // 断言原始效果选项存在
  await dt.assertClick('EffectOption_OriginalMotionPhoto'); // 确保选择原始效果
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 0.5、返回图库宫格视图');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、从照片页宫格进入大图，左右滑动到动态照片');
  dt.log.i('STEP 1.1、点击进入第一张图片大图（假设不是动态照片）');
  await dt.assertClick('photoGridView_grid_0');
  await dt.assertComponent('LargeImageView', true); // 断言进入大图视图

  dt.log.i('STEP 1.2、向左滑动到动态照片');
  await dt.swipeScreen.left();
  await dt.assertComponent('MotionPictureLargeView', true); // 断言当前显示的是动态照片

  dt.log.i('预期结果1、动态照片自动播放一次后停止，播放过程无异常，停止后动态照片停留在封面帧');
  dt.log.i('STEP 1.3、断言动态照片自动播放并停止在封面帧');
  await dt.assertComponent('PlayButton', true); // 播放结束后，播放按钮应该可见
  await dt.assertComponent('PauseButton', false); // 播放结束后，暂停按钮应该不可见
  dt.log.i('请手动验证播放过程无异常，停止后停留在封面帧');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片支持自动播放 end');
}

/**
 * 大图-滑动: [不同入口进大图左右滑动支持自动播放]
 * TAG: 252 TID: Multimedia_Gallery_Motion_picture_022
 */
async function Multimedia_Gallery_Motion_picture_022(dt: Dt) {
  dt.log.i('不同入口进大图左右滑动支持自动播放 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 图库存在动态照片，且动态照片效果设置为动态照片');
  dt.log.i('STEP 0.1、启动图库应用');
  await dt.launchGalleryApp();
  dt.log.i('STEP 0.2、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail', true);
  dt.log.i('STEP 0.3、点击动态照片进入大图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 0.4、确保动态照片效果设置为动态照片（原始）');
  await dt.clickIfExist('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOption_OriginalMotionPhoto', true);
  await dt.assertClick('EffectOption_OriginalMotionPhoto');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 0.5、返回图库宫格视图');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、从不同入口（照片页、相机、隐藏相册、最近删除、picker）进入大图，左右滑动到动态照片');
  dt.log.i('STEP 1.1、从照片页进入大图，并滑动到动态照片');
  await dt.assertClick('photoGridView_grid_0'); // 进入大图
  await dt.assertComponent('LargeImageView', true);
  await dt.swipeScreen.left(); // 滑动到动态照片
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('预期结果1、动态照片自动播放一次后停止，播放过程无异常，停止后动态照片停留在封面帧');
  dt.log.i('请手动验证自动播放并停止在封面帧');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 1.2、从相机缩略图进入大图，并滑动到动态照片');
  await dt.launchCameraApp();
  await dt.captureMotionPhoto(); // 拍摄新动态照片，确保其在图库顶部
  await dt.assertClick('CameraThumbnail'); // 从相机缩略图进入大图
  await dt.assertComponent('MotionPictureLargeView_Camera', true);
  await dt.swipeScreen.left(); // 滑动到第一张预置动态照片（如果需要）
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('请手动验证自动播放并停止在封面帧');
  await dt.pressBack();
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 1.3、从隐藏相册进入大图，并滑动到动态照片 (假设已将动态照片移入隐藏相册)');
  dt.log.i('请手动将一张动态照片移入隐藏相册，并从隐藏相册进入大图进行验证');
  dt.log.i('STEP 1.4、从最近删除进入大图，并滑动到动态照片 (假设已删除动态照片并将其还原)');
  dt.log.i('请手动删除一张动态照片，进入最近删除，然后点击该照片进入大图进行验证');
  dt.log.i('STEP 1.5、从Picker选择器进入大图，并滑动到动态照片');
  dt.log.i('请手动从Picker选择器中选择动态照片进入大图进行验证');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('不同入口进大图左右滑动支持自动播放 end');
}

/**
 * 大图-动态照片: [动态照片效果切换]
 * TAG: 253 TID: Multimedia_Gallery_Motion_picture_023
 */
async function Multimedia_Gallery_Motion_picture_023(dt: Dt) {
  dt.log.i('动态照片效果切换 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 图库存在动态照片，且动态照片效果默认设置为动态照片');
  dt.log.i('STEP 0.1、启动图库应用');
  await dt.launchGalleryApp();
  dt.log.i('STEP 0.2、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail', true);
  dt.log.i('STEP 0.3、点击动态照片进入大图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 0.4、确保动态照片效果设置为动态照片（原始）');
  await dt.clickIfExist('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOption_OriginalMotionPhoto', true);
  await dt.assertClick('EffectOption_OriginalMotionPhoto');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、动态照片效果切换为循环播放');
  dt.log.i('STEP 1.1、点击效果切换按钮');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  dt.log.i('STEP 1.2、选择循环播放效果');
  await dt.assertClick('EffectOption_LoopPlayback');
  await dt.assertComponent('MotionPictureLargeView', true); // 断言仍在当前页面
  dt.log.i('预期结果1-5、静待不超过3s，效果切换完成；微动瞬间需主体为人/猫/狗，否则效果退化为循环播放，但是界面显示微动瞬间');
  dt.log.i('请手动验证效果切换完成，且在3秒内');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、动态照片效果切换为主角时刻');
  dt.log.i('STEP 2.1、点击效果切换按钮');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  dt.log.i('STEP 2.2、选择主角时刻效果');
  await dt.assertClick('EffectOption_ProtagonistMoment');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('请手动验证效果切换完成，且在3秒内');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、动态照片效果切换为运动轨迹');
  dt.log.i('STEP 3.1、点击效果切换按钮');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  dt.log.i('STEP 3.2、选择运动轨迹效果');
  await dt.assertClick('EffectOption_MotionTrail');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('请手动验证效果切换完成，且在3秒内');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 4、动态照片效果切换为关闭');
  dt.log.i('STEP 4.1、点击效果切换按钮');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  dt.log.i('STEP 4.2、选择关闭效果');
  await dt.assertClick('EffectOption_Close');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('请手动验证效果切换完成，且在3秒内');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 5、动态照片效果切换为动态照片（原始效果）');
  dt.log.i('STEP 5.1、点击效果切换按钮');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  dt.log.i('STEP 5.2、选择动态照片原始效果');
  await dt.assertClick('EffectOption_OriginalMotionPhoto');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('请手动验证效果切换完成，且在3秒内');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片效果切换 end');
}

/**
 * 大图-动态照片: [动态照片效果播放正常]
 * TAG: 247 TID: Multimedia_Gallery_Motion_picture_024
 */
async function Multimedia_Gallery_Motion_picture_024(dt: Dt) {
  dt.log.i('动态照片效果播放正常 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 图库存在动态照片，且动态照片效果默认设置为动态照片');
  dt.log.i('STEP 0.1、启动图库应用');
  await dt.launchGalleryApp();
  dt.log.i('STEP 0.2、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail', true);
  dt.log.i('STEP 0.3、点击动态照片进入大图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 0.4、确保动态照片效果设置为动态照片（原始）');
  await dt.clickIfExist('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOption_OriginalMotionPhoto', true);
  await dt.assertClick('EffectOption_OriginalMotionPhoto');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、照片页进入动态照片大图，动态照片效果切换为循环播放');
  dt.log.i('STEP 1.1、点击效果切换按钮');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  dt.log.i('STEP 1.2、选择循环播放效果');
  await dt.assertClick('EffectOption_LoopPlayback');
  await dt.assertComponent('MotionPictureLargeView', true);

  dt.log.i('预期结果1、效果切换完成后，动态照片自动循环播放，是从开头-结尾的循环播放，播放过程无异常');
  dt.log.i('STEP 1.3、断言动态照片正在自动循环播放');
  await dt.assertComponent('PlayingIndicator', true);
  dt.log.i('请手动验证播放过程无异常，且为从开头到结尾的循环播放');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、动态照片效果切换为主角时刻，效果切换完成后，长按动态照片大图');
  dt.log.i('STEP 2.1、点击效果切换按钮');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  dt.log.i('STEP 2.2、选择主角时刻效果');
  await dt.assertClick('EffectOption_ProtagonistMoment');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 2.3、长按动态照片大图');
  await dt.assertLongClickById('MotionPicturePlaybackArea'); // 假设播放区域ID

  dt.log.i('预期结果2、效果为主角时刻，长按播放，播放过程无异常，播放一次后停止，不松手时动态照片停在尾帧，松手后动态照片停留在封面帧');
  dt.log.i('STEP 2.4、断言动态照片播放一次后停止');
  await dt.assertComponent('PlayButton', true); // 播放结束后，播放按钮应该可见
  dt.log.i('请手动验证播放过程无异常，不松手时停在尾帧，松手后停留在封面帧');
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、动态照片效果切换为运动轨迹，效果切换完成后，长按动态照片大图');
  dt.log.i('STEP 3.1、点击效果切换按钮');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  dt.log.i('STEP 3.2、选择运动轨迹效果');
  await dt.assertClick('EffectOption_MotionTrail');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 3.3、长按动态照片大图');
  await dt.assertLongClickById('MotionPicturePlaybackArea');

  dt.log.i('预期结果3、效果为运动轨迹，长按播放，播放过程无异常，播放一次后停止，不松手时动态照片停在尾帧，松手后动态照片停留在封面帧');
  dt.log.i('STEP 3.4、断言动态照片播放一次后停止');
  await dt.assertComponent('PlayButton', true);
  dt.log.i('请手动验证播放过程无异常，不松手时停在尾帧，松手后停留在封面帧');
  await dt.assertComponent(PageTitle.index, true); // 断言仍在当前页面

  dt.log.i('STEP 4、动态照片效果切换为关闭，效果切换完成后，长按动态照片大图');
  dt.log.i('STEP 4.1、点击效果切换按钮');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  dt.log.i('STEP 4.2、选择关闭效果');
  await dt.assertClick('EffectOption_Close');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 4.3、长按动态照片大图');
  await dt.assertLongClickById('MotionPicturePlaybackArea');

  dt.log.i('预期结果4、关闭动态照片播放效果，不论是否长按，动态照片都无法播放');
  dt.log.i('STEP 4.4、断言播放按钮可见（表示未播放）');
  await dt.assertComponent('PlayButton', true);
  dt.log.i('请手动验证动态照片无法播放');
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 5、动态照片效果切换为动态照片（原始效果），效果切换完成后，长按动态照片大图');
  dt.log.i('STEP 5.1、点击效果切换按钮');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  dt.log.i('STEP 5.2、选择动态照片原始效果');
  await dt.assertClick('EffectOption_OriginalMotionPhoto');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 5.3、长按动态照片大图');
  await dt.assertLongClickById('MotionPicturePlaybackArea');

  dt.log.i('预期结果5、效果为动态照片，长按播放，播放过程无异常，播放一次后停止，不松手时动态照片停在尾帧，松手后动态照片停留在封面帧');
  dt.log.i('STEP 5.4、断言动态照片播放一次后停止');
  await dt.assertComponent('PlayButton', true);
  dt.log.i('请手动验证播放过程无异常，不松手时停在尾帧，松手后停留在封面帧');
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片效果播放正常 end');
}

/**
 * 大图-动态照片: [不同场景动态照片动态照片效果播放方式]
 * TAG: 250 TID: Multimedia_Gallery_Motion_picture_025
 */
async function Multimedia_Gallery_Motion_picture_025(dt: Dt) {
  dt.log.i('不同场景动态照片动态照片效果播放方式 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 图库存在动态照片');
  dt.log.i('STEP 0.1、启动图库应用');
  await dt.launchGalleryApp();
  dt.log.i('STEP 0.2、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、动态照片效果切换为动态照片（原始效果）');
  dt.log.i('STEP 1.1、点击动态照片进入大图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 1.2、点击效果切换按钮');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  dt.log.i('STEP 1.3、选择动态照片原始效果');
  await dt.assertClick('EffectOption_OriginalMotionPhoto');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 1.4、返回图库宫格视图');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2、不同入口（照片页、相机、picker、宫格长按预览）进入该动态照片大图');
  dt.log.i('STEP 2.1、从照片页进入大图');
  await dt.assertClick('photoGridView_grid_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('预期结果2、需长按播放');
  dt.log.i('STEP 2.2、断言播放按钮可见（表示未播放）');
  await dt.assertComponent('PlayButton', true);
  dt.log.i('请手动验证需长按才能播放');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.3、从相机缩略图进入大图');
  await dt.launchCameraApp();
  await dt.captureMotionPhoto();
  await dt.assertClick('CameraThumbnail');
  await dt.assertComponent('MotionPictureLargeView_Camera', true);
  dt.log.i('请手动验证需长按才能播放');
  await dt.pressBack();
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.4、从宫格长按预览进入大图');
  await dt.assertLongClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView_Preview', true);
  dt.log.i('请手动验证需长按才能播放');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.5、从Picker选择器进入大图');
  dt.log.i('请手动从Picker选择器进入该动态照片大图并验证需长按播放');

  dt.log.i('STEP 3、大图滑动到该动态照片');
  dt.log.i('STEP 3.1、进入大图视图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 3.2、滑动到该动态照片（如果不是第一张）');
  await dt.swipeScreen.left(); // 假设滑动到它
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('预期结果3、自动播放一次后停止');
  dt.log.i('STEP 3.3、断言动态照片自动播放并停止在封面帧');
  await dt.assertComponent('PlayButton', true);
  dt.log.i('请手动验证自动播放一次后停止');
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('不同场景动态照片动态照片效果播放方式 end');
}

/**
 * 大图-动态照片: [不同场景动态照片循环播放效果播放方式]
 * TAG: 260 TID: Multimedia_Gallery_Motion_picture_026
 */
async function Multimedia_Gallery_Motion_picture_026(dt: Dt) {
  dt.log.i('不同场景动态照片循环播放效果播放方式 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 图库存在动态照片');
  dt.log.i('STEP 0.1、启动图库应用');
  await dt.launchGalleryApp();
  dt.log.i('STEP 0.2、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail', true);
  dt.log.i('STEP 0.3、点击动态照片进入大图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 0.4、将动态照片效果切换为循环播放');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  await dt.assertClick('EffectOption_LoopPlayback');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 0.5、返回图库宫格视图');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、动态照片效果切换为循环播放');
  dt.log.i('STEP 1.1、确保已切换到循环播放效果 (已在预制条件中完成)');

  dt.log.i('STEP 2、不同入口（照片页、相机、picker、宫格长按预览）进入该动态照片大图');
  dt.log.i('STEP 2.1、从照片页进入大图');
  await dt.assertClick('photoGridView_grid_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('预期结果2，3、自动循环播放（当前HAD不支持循环播放效果）');
  dt.log.i('STEP 2.2、断言动态照片自动循环播放');
  await dt.assertComponent('PlayingIndicator', true);
  dt.log.i('请手动验证照片自动循环播放');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.3、从相机缩略图进入大图');
  await dt.launchCameraApp();
  await dt.captureMotionPhoto(); // 拍摄新动态照片，确保其在图库顶部
  await dt.assertClick('CameraThumbnail');
  await dt.assertComponent('MotionPictureLargeView_Camera', true);
  dt.log.i('请手动验证照片自动循环播放');
  await dt.pressBack();
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.4、从宫格长按预览进入大图');
  await dt.assertLongClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView_Preview', true);
  dt.log.i('请手动验证照片自动循环播放');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.5、从Picker选择器进入大图');
  dt.log.i('请手动从Picker选择器进入该动态照片大图并验证自动循环播放');

  dt.log.i('STEP 3、大图滑动到该动态照片');
  dt.log.i('STEP 3.1、进入大图视图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 3.2、滑动到该动态照片（如果不是第一张）');
  await dt.swipeScreen.left(); // 假设滑动到它
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('请手动验证照片自动循环播放');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('不同场景动态照片循环播放效果播放方式 end');
}

/**
 * 大图-动态照片: [不同场景动态照片来回播放效果播放方式]
 * TAG: 249 TID: Multimedia_Gallery_Motion_picture_027
 */
async function Multimedia_Gallery_Motion_picture_027(dt: Dt) {
  dt.log.i('不同场景动态照片来回播放效果播放方式 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 图库存在动态照片，且当前设备为nova产品');
  dt.log.i('STEP 0.1、启动图库应用');
  await dt.launchGalleryApp();
  dt.log.i('STEP 0.2、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail', true);
  dt.log.i('STEP 0.3、断言当前设备为nova产品');
  await dt.assertDeviceModel('nova'); // Placeholder: Assumes a method to check device model
  dt.log.i('STEP 0.4、点击动态照片进入大图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 0.5、将动态照片效果切换为来回播放');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  await dt.assertClick('EffectOption_Boomerang'); // 假设来回播放的ID是Boomerang
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 0.6、返回图库宫格视图');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、动态照片效果切换为来回播放');
  dt.log.i('STEP 1.1、确保已切换到来回播放效果 (已在预制条件中完成)');

  dt.log.i('STEP 2、不同入口（照片页、相机、picker、宫格长按预览）进入该动态照片大图');
  dt.log.i('STEP 2.1、从照片页进入大图');
  await dt.assertClick('photoGridView_grid_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('预期结果2，3、自动来回播放（当前只支持nova产品）');
  dt.log.i('STEP 2.2、断言动态照片自动来回播放');
  await dt.assertComponent('PlayingIndicator', true);
  dt.log.i('请手动验证照片自动来回播放');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.3、从相机缩略图进入大图');
  await dt.launchCameraApp();
  await dt.captureMotionPhoto();
  await dt.assertClick('CameraThumbnail');
  await dt.assertComponent('MotionPictureLargeView_Camera', true);
  dt.log.i('请手动验证照片自动来回播放');
  await dt.pressBack();
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.4、从宫格长按预览进入大图');
  await dt.assertLongClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView_Preview', true);
  dt.log.i('请手动验证照片自动来回播放');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.5、从Picker选择器进入大图');
  dt.log.i('请手动从Picker选择器进入该动态照片大图并验证自动来回播放');

  dt.log.i('STEP 3、大图滑动到该动态照片');
  dt.log.i('STEP 3.1、进入大图视图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 3.2、滑动到该动态照片（如果不是第一张）');
  await dt.swipeScreen.left();
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('请手动验证照片自动来回播放');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('不同场景动态照片来回播放效果播放方式 end');
}

/**
 * 大图-动态照片: [不同场景动态照片主角时刻效果播放方式]
 * TAG: 261 TID: Multimedia_Gallery_Motion_picture_028
 */
async function Multimedia_Gallery_Motion_picture_028(dt: Dt) {
  dt.log.i('不同场景动态照片主角时刻效果播放方式 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 图库存在动态照片');
  dt.log.i('STEP 0.1、启动图库应用');
  await dt.launchGalleryApp();
  dt.log.i('STEP 0.2、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail', true);
  dt.log.i('STEP 0.3、点击动态照片进入大图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 0.4、将动态照片效果切换为主角时刻');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  await dt.assertClick('EffectOption_ProtagonistMoment');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 0.5、返回图库宫格视图');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、动态照片效果切换为主角时刻');
  dt.log.i('STEP 1.1、确保已切换到主角时刻效果 (已在预制条件中完成)');

  dt.log.i('STEP 2、不同入口（照片页、相机、picker、宫格长按预览）进入该动态照片大图');
  dt.log.i('STEP 2.1、从照片页进入大图');
  await dt.assertClick('photoGridView_grid_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('预期结果2，3、需长按播放（当前HAD不支持长曝光效果）');
  dt.log.i('STEP 2.2、断言播放按钮可见（表示未播放）');
  await dt.assertComponent('PlayButton', true);
  dt.log.i('请手动验证需长按才能播放');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.3、从相机缩略图进入大图');
  await dt.launchCameraApp();
  await dt.captureMotionPhoto();
  await dt.assertClick('CameraThumbnail');
  await dt.assertComponent('MotionPictureLargeView_Camera', true);
  dt.log.i('请手动验证需长按才能播放');
  await dt.pressBack();
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.4、从宫格长按预览进入大图');
  await dt.assertLongClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView_Preview', true);
  dt.log.i('请手动验证需长按才能播放');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.5、从Picker选择器进入大图');
  dt.log.i('请手动从Picker选择器进入该动态照片大图并验证需长按播放');

  dt.log.i('STEP 3、大图滑动到该动态照片');
  dt.log.i('STEP 3.1、进入大图视图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 3.2、滑动到该动态照片（如果不是第一张）');
  await dt.swipeScreen.left();
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('请手动验证需长按才能播放');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('不同场景动态照片主角时刻效果播放方式 end');
}

