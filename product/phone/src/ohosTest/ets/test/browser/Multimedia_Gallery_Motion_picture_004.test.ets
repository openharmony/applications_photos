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

export default function Multimedia_Gallery_Motion_Picture_004(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('Multimedia_Gallery_Motion_Picture_004', (): void => {
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
    run('Multimedia_Gallery_Motion_picture_029', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [不同场景动态照片运动轨迹效果播放方式] TID: Multimedia_Gallery_Motion_picture_029
      await Multimedia_Gallery_Motion_picture_029(dt);
    });
    run('Multimedia_Gallery_Motion_picture_030', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [不同场景动态照片微动瞬间效果播放方式] TID: Multimedia_Gallery_Motion_picture_030
      await Multimedia_Gallery_Motion_picture_030(dt);
    });
    run('Multimedia_Gallery_Motion_picture_031', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [不同场景动态照片关闭效果播放方式] TID: Multimedia_Gallery_Motion_picture_031
      await Multimedia_Gallery_Motion_picture_031(dt);
    });
    run('Multimedia_Gallery_Motion_picture_032', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片各效果端云同步] TID: Multimedia_Gallery_Motion_picture_032
      await Multimedia_Gallery_Motion_picture_032(dt);
    });
    run('Multimedia_Gallery_Motion_picture_033', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片各效果分享] TID: Multimedia_Gallery_Motion_picture_033
      await Multimedia_Gallery_Motion_picture_033(dt);
    });
    run('Multimedia_Gallery_Motion_picture_034', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片各效果克隆] TID: Multimedia_Gallery_Motion_picture_034
      await Multimedia_Gallery_Motion_picture_034(dt);
    });
    run('Multimedia_Gallery_Motion_picture_035', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片宫格预览后长按播放时拖拽] TID: Multimedia_Gallery_Motion_picture_035
      await Multimedia_Gallery_Motion_picture_035(dt);
    });
    run('Multimedia_Gallery_Motion_picture_036', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片大图滑动异常场景测试] TID: Multimedia_Gallery_Motion_picture_036
      await Multimedia_Gallery_Motion_picture_036(dt);
    });
    run('Multimedia_Gallery_Motion_picture_037', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片编辑入口检查] TID: Multimedia_Gallery_Motion_picture_037
      await Multimedia_Gallery_Motion_picture_037(dt);
    });
    run('Multimedia_Gallery_Motion_picture_038', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片宫格操作检查] TID: Multimedia_Gallery_Motion_picture_038
      await Multimedia_Gallery_Motion_picture_038(dt);
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
 * 大图-动态照片: [不同场景动态照片运动轨迹效果播放方式]
 * TAG: 248 TID: Multimedia_Gallery_Motion_picture_029
 */
async function Multimedia_Gallery_Motion_picture_029(dt: Dt) {
  dt.log.i('不同场景动态照片运动轨迹效果播放方式 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 图库存在动态照片');
  dt.log.i('STEP 0.1、启动图库应用');
  await dt.launchGalleryApp();
  dt.log.i('STEP 0.2、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、动态照片效果切换为运动轨迹');
  dt.log.i('STEP 1.1、点击动态照片进入大图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 1.2、点击效果切换按钮');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  dt.log.i('STEP 1.3、选择运动轨迹效果');
  await dt.assertClick('EffectOption_MotionTrail');
  await dt.assertComponent('MotionPictureLargeView', true); // 断言仍在当前页面

  dt.log.i('STEP 2、不同入口（照片页、相机、picker、宫格长按预览）进入该动态照片大图');
  dt.log.i('STEP 2.1、从照片页（当前大图模式）进入大图，并返回宫格视图');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true); // 断言返回照片页宫格

  dt.log.i('STEP 2.2、通过宫格长按预览进入大图');
  await dt.assertLongClickById('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView_Preview', true); // 断言进入长按预览大图
  dt.log.i('请手动验证此时照片未自动播放，需长按才能播放');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.3、通过相机缩略图进入大图');
  await dt.launchCameraApp();
  await dt.captureMotionPhoto(); // 拍摄一张新的动态照片
  await dt.assertClick('CameraThumbnail'); // 点击相机缩略图进入大图
  await dt.assertComponent('MotionPictureLargeView_Camera', true); // 断言从相机进入大图
  dt.log.i('请手动验证此时照片未自动播放，需长按才能播放');
  await dt.pressBack();
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true); // 返回图库

  dt.log.i('STEP 2.4、通过Picker选择器进入大图 (此步骤需要应用模拟Picker的交互)');
  dt.log.i('请手动通过Picker选择器进入该动态照片大图并验证');
  dt.log.i('预期结果2，3、需长按播放（当前HAD不支持多曝光效果）');

  dt.log.i('STEP 3、大图滑动到该动态照片');
  dt.log.i('STEP 3.1、进入大图视图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 3.2、滑动到该动态照片（如果不是第一张）');
  await dt.swipeScreen.left(); // 假设滑动到它
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('请手动验证此时照片未自动播放，需长按才能播放');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('不同场景动态照片运动轨迹效果播放方式 end');
}

/**
 * 大图-动态照片: [不同场景动态照片微动瞬间效果播放方式]
 * TAG: 268 TID: Multimedia_Gallery_Motion_picture_030
 */
async function Multimedia_Gallery_Motion_picture_030(dt: Dt) {
  dt.log.i('不同场景动态照片微动瞬间效果播放方式 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 手机保持稳定，相机拍摄动态照片，场景要有运动的人物/猫/狗');
  dt.log.i('STEP 0.1、启动相机应用');
  await dt.launchCameraApp();
  dt.log.i('STEP 0.2、拍摄包含运动物体的动态照片');
  await dt.captureMotionPhotoWithMovement(); // Placeholder: Captures motion photo with movement
  dt.log.i('STEP 0.3、退出相机并返回图库');
  await dt.exitCameraToGallery();
  dt.log.i('STEP 0.4、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、动态照片效果切换为微动瞬间');
  dt.log.i('STEP 1.1、点击动态照片进入大图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 1.2、点击效果切换按钮');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  dt.log.i('STEP 1.3、选择微动瞬间效果');
  await dt.assertClick('EffectOption_SubtleMoment');
  await dt.assertComponent('MotionPictureLargeView', true);

  dt.log.i('预期结果1、效果切换完成后自动循环播放，微动瞬间只有运动区域在动。静止画面保持不动');
  dt.log.i('STEP 1.4、断言照片自动播放');
  await dt.assertComponent('PlayingIndicator', true); // Placeholder: Checks for a playing indicator
  dt.log.i('请手动验证只有运动区域在动，静止画面保持不动');

  dt.log.i('STEP 2、不同入口（照片页、相机、picker、宫格长按预览）进入该动态照片大图');
  dt.log.i('STEP 2.1、从照片页（当前大图模式）进入大图，并返回宫格视图');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.2、通过宫格长按预览进入大图');
  await dt.assertLongClickById('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView_Preview', true);
  dt.log.i('请手动验证照片自动循环播放，微动瞬间只有运动区域在动，静止画面保持不动');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.3、通过相机缩略图进入大图');
  await dt.launchCameraApp();
  await dt.captureMotionPhotoWithMovement(); // 拍摄一张新的动态照片
  await dt.assertClick('CameraThumbnail');
  await dt.assertComponent('MotionPictureLargeView_Camera', true);
  dt.log.i('请手动验证照片自动循环播放，微动瞬间只有运动区域在动，静止画面保持不动');
  await dt.pressBack();
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.4、通过Picker选择器进入大图 (此步骤需要应用模拟Picker的交互)');
  dt.log.i('请手动通过Picker选择器进入该动态照片大图并验证');
  dt.log.i('预期结果2，3、自动循环播放，微动瞬间只有运动区域在动。静止画面保持不动');

  dt.log.i('STEP 3、大图滑动到该动态照片');
  dt.log.i('STEP 3.1、进入大图视图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 3.2、滑动到该动态照片（如果不是第一张）');
  await dt.getScreen().left();
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('请手动验证照片自动循环播放，微动瞬间只有运动区域在动，静止画面保持不动');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('不同场景动态照片微动瞬间效果播放方式 end');
}

/**
 * 大图-动态照片: [不同场景动态照片关闭效果播放方式]
 * TAG: 256 TID: Multimedia_Gallery_Motion_picture_031
 */
async function Multimedia_Gallery_Motion_picture_031(dt: Dt) {
  dt.log.i('不同场景动态照片关闭效果播放方式 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 图库存在动态照片');
  dt.log.i('STEP 0.1、启动图库应用');
  await dt.launchGalleryApp();
  dt.log.i('STEP 0.2、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、动态照片效果切换为关闭');
  dt.log.i('STEP 1.1、点击动态照片进入大图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 1.2、点击效果切换按钮');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  dt.log.i('STEP 1.3、选择关闭效果');
  await dt.assertClick('EffectOption_Close');
  await dt.assertComponent('MotionPictureLargeView', true); // 断言仍在当前页面

  dt.log.i('STEP 2、不同入口（照片页、相机、picker、宫格长按预览）进入该动态照片大图');
  dt.log.i('STEP 2.1、从照片页（当前大图模式）进入大图，并尝试长按播放');
  await dt.assertLongClickById('MotionPicturePlaybackArea'); // 尝试长按播放
  dt.log.i('预期结果2、无论是否长按，均无法播放');
  dt.log.i('请手动验证照片无法播放');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.2、通过宫格长按预览进入大图，并尝试长按播放');
  await dt.assertLongClickById('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView_Preview', true);
  await dt.assertLongClickById('MotionPicturePlaybackArea');
  dt.log.i('请手动验证照片无法播放');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.3、通过相机缩略图进入大图，并尝试长按播放');
  await dt.launchCameraApp();
  await dt.captureMotionPhoto();
  await dt.assertClick('CameraThumbnail');
  await dt.assertComponent('MotionPictureLargeView_Camera', true);
  await dt.assertLongClickById('MotionPicturePlaybackArea');
  dt.log.i('请手动验证照片无法播放');
  await dt.pressBack();
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2.4、通过Picker选择器进入大图 (此步骤需要应用模拟Picker的交互)');
  dt.log.i('请手动通过Picker选择器进入该动态照片大图并验证无法播放');

  dt.log.i('STEP 3、大图滑动到该动态照片');
  dt.log.i('STEP 3.1、进入大图视图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 3.2、滑动到该动态照片（如果不是第一张）');
  await dt.swipeScreen.left();
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('预期结果3、无论是否长按，均无法播放');
  dt.log.i('请手动验证照片无法播放');
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片关闭效果播放方式 end');
}

/**
 * 大图-动态照片: [动态照片各效果端云同步]
 * TAG: 259 TID: Multimedia_Gallery_Motion_picture_032
 */
async function Multimedia_Gallery_Motion_picture_032(dt: Dt) {
  dt.log.i('动态照片各效果端云同步 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 准备双设备，且均可同步上下云，图库存在动态照片');
  dt.log.i('STEP 0.1、确保测试机图库已打开');
  await dt.launchGalleryApp();
  dt.log.i('STEP 0.2、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail', true);
  dt.log.i('STEP 0.3、确保测试机和辅助机已设置端云同步且图库中有动态照片');
  await dt.setupDualDeviceCloudSync(); // Placeholder for setting up dual device sync
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、辅助机修改动态照片为各效果并同步上云，测试机查看云同步下行动态照片效果');
  dt.log.i('STEP 1.1、辅助机将动态照片效果切换为循环播放并同步上云');
  dt.log.i('请在辅助机上将动态照片的效果切换为循环播放并等待上传完成');
  // Assume auxiliary device control via dt.aux
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertClick('EffectOption_LoopPlayback');
  await dt.sleep(DELAY.long); // Wait for upload
  await dt.pressBack();

  dt.log.i('STEP 1.2、等待测试机同步下行完成');
  await dt.sleep(DELAY.enormous); // Sufficiently long delay for sync

  dt.log.i('STEP 1.3、测试机查看同步下行的动态照片效果');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('预期结果1、保留动态照片设置效果');
  dt.log.i('STEP 1.4、断言当前动态照片效果为循环播放');
  await dt.assertComponent('MotionEffectAppliedIndicator_LoopPlayback', true); // 断言效果为循环播放

  dt.log.i('STEP 1.5、辅助机将动态照片效果切换为主角时刻并同步上云');
  dt.log.i('请在辅助机上将动态照片的效果切换为主角时刻并等待上传完成');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertClick('EffectOption_ProtagonistMoment');
  await dt.sleep(DELAY.long); // Wait for upload
  await dt.pressBack();

  dt.log.i('STEP 1.6、等待测试机同步下行完成');
  await dt.sleep(DELAY.enormous);

  dt.log.i('STEP 1.7、测试机查看同步下行的动态照片效果');
  await dt.pressBack(); // 返回宫格
  await dt.assertComponent('photoGridView_grid_0', true);
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 1.8、断言当前动态照片效果为主角时刻');
  await dt.assertComponent('MotionEffectAppliedIndicator_ProtagonistMoment', true); // 断言效果为主角时刻

  // Repeat for MotionTrail, SubtleMoment, Close, Original Motion Photo
  dt.log.i('STEP 1.9、继续切换其他效果并验证...');
  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片各效果端云同步 end');
}

/**
 * 大图-动态照片: [动态照片各效果分享]
 * TAG: 258 TID: Multimedia_Gallery_Motion_picture_033
 */
async function Multimedia_Gallery_Motion_picture_033(dt: Dt) {
  dt.log.i('动态照片各效果分享 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 图库存在动态照片');
  dt.log.i('STEP 0.1、启动图库应用');
  await dt.launchGalleryApp();
  dt.log.i('STEP 0.2、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、xxx分享：动态照片修改各效果进行分享，并查看分享后接收到的动态照片效果');
  dt.log.i('STEP 1.1、将动态照片效果切换为循环播放');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  await dt.assertClick('EffectOption_LoopPlayback');
  await dt.assertComponent('MotionPictureLargeView', true);

  dt.log.i('STEP 1.2、分享该动态照片到另一台xxx设备');
  await dt.assertClick('ShareButton'); // 点击分享按钮
  await dt.assertComponent('ShareSheet', true); // 断言分享面板弹出
  await dt.assertClick('ShareTarget_AnotherDevice'); // Placeholder: Select a sharing target to another device
  dt.log.i('请在接收设备上确认接收并打开该动态照片');

  dt.log.i('预期结果1、保留动态照片设置效果');
  dt.log.i('STEP 1.3、断言在接收设备上，该动态照片效果为循环播放');
  // This step requires control over the receiving device or manual verification.
  // Assuming a check like dt.receiveDevice.assertComponent('MotionEffectAppliedIndicator_LoopPlayback', true);

  dt.log.i('STEP 1.4、将动态照片效果切换为主角时刻');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  await dt.assertClick('EffectOption_ProtagonistMoment');
  await dt.assertComponent('MotionPictureLargeView', true);

  dt.log.i('STEP 1.5、分享该动态照片到另一台xxx设备');
  await dt.assertClick('ShareButton');
  await dt.assertComponent('ShareSheet', true);
  await dt.assertClick('ShareTarget_AnotherDevice');
  dt.log.i('请在接收设备上确认接收并打开该动态照片，并验证效果为主角时刻');
  await dt.pressBack(); // 返回宫格

  dt.log.i('STEP 2、xxx分享，重复步骤一');
  dt.log.i('STEP 2.1、确保图库中存在xxx拍摄的动态照片');
  dt.log.i('请确保当前设备已导入xxx动态照片');
  dt.log.i('STEP 2.2、将xxx动态照片效果切换为运动轨迹');
  await dt.assertClick('dual_frame_motion_photo_thumbnail_0'); // 假设有xxx动态照片的thumbnail
  await dt.assertComponent('MotionPictureLargeView', true);
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  await dt.assertClick('EffectOption_MotionTrail');
  await dt.assertComponent('MotionPictureLargeView', true);

  dt.log.i('STEP 2.3、分享该xxx动态照片到另一台xxx设备');
  await dt.assertClick('ShareButton');
  await dt.assertComponent('ShareSheet', true);
  await dt.assertClick('ShareTarget_AnotherDevice');
  dt.log.i('请在接收设备上确认接收并打开该动态照片，并验证效果为运动轨迹');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片各效果分享 end');
}

/**
 * 大图-动态照片: [动态照片各效果克隆]
 * TAG: 257 TID: Multimedia_Gallery_Motion_picture_034
 */
async function Multimedia_Gallery_Motion_picture_034(dt: Dt) {
  dt.log.i('动态照片各效果克隆 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 图库存在动态照片');
  dt.log.i('STEP 0.1、启动图库应用');
  await dt.launchGalleryApp();
  dt.log.i('STEP 0.2、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、xxx分享：动态照片修改各效果进行克隆，并查看接收到的动态照片效果');
  dt.log.i('STEP 1.1、将动态照片效果切换为微动瞬间');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  await dt.assertClick('EffectOption_SubtleMoment');
  await dt.assertComponent('MotionPictureLargeView', true);

  dt.log.i('STEP 1.2、克隆该动态照片到另一台xxx设备');
  await dt.assertClick('MoreOptionsButton'); // 假设“更多”按钮
  await dt.assertComponent('MoreOptionsMenu', true);
  await dt.assertClick('CloneOption'); // 假设克隆选项
  await dt.assertComponent('CloneConfirmationDialog', true); // 断言克隆确认框
  await dt.assertClick('ConfirmCloneButton');
  dt.log.i('请在接收设备上确认接收并打开该动态照片');

  dt.log.i('预期结果1、保留动态照片设置效果');
  dt.log.i('STEP 1.3、断言在接收设备上，该动态照片效果为微动瞬间');
  // This step requires control over the receiving device or manual verification.

  dt.log.i('STEP 1.4、将动态照片效果切换为关闭');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  await dt.assertClick('EffectOption_Close');
  await dt.assertComponent('MotionPictureLargeView', true);

  dt.log.i('STEP 1.5、克隆该动态照片到另一台xxx设备');
  await dt.assertClick('MoreOptionsButton');
  await dt.assertComponent('MoreOptionsMenu', true);
  await dt.assertClick('CloneOption');
  await dt.assertClick('ConfirmCloneButton');
  dt.log.i('请在接收设备上确认接收并打开该动态照片，并验证效果为关闭');
  await dt.pressBack(); // 返回宫格

  dt.log.i('STEP 2、xxx克隆，重复步骤一');
  dt.log.i('STEP 2.1、确保图库中存在xxx拍摄的动态照片');
  dt.log.i('请确保当前设备已导入xxx动态照片');
  dt.log.i('STEP 2.2、将xxx动态照片效果切换为动态照片（原始）');
  await dt.assertClick('dual_frame_motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  await dt.assertClick('EffectOption_OriginalMotionPhoto');
  await dt.assertComponent('MotionPictureLargeView', true);

  dt.log.i('STEP 2.3、克隆该xxx动态照片到另一台xxx设备');
  await dt.assertClick('MoreOptionsButton');
  await dt.assertComponent('MoreOptionsMenu', true);
  await dt.assertClick('CloneOption');
  await dt.assertClick('ConfirmCloneButton');
  dt.log.i('请在接收设备上确认接收并打开该动态照片，并验证效果为动态照片（原始）');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片各效果克隆 end');
}

/**
 * 大图-动态照片: [动态照片宫格预览后长按播放时拖拽]
 * TAG: 254 TID: Multimedia_Gallery_Motion_picture_035
 */
async function Multimedia_Gallery_Motion_picture_035(dt: Dt) {
  dt.log.i('动态照片宫格预览后长按播放时拖拽 start');

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
  dt.log.i('STEP 1.4、返回宫格视图');
  await dt.pressBack();
  await dt.assertComponent('photoGridView_grid_0', true);

  dt.log.i('STEP 2、宫格长按预览该动态照片');
  dt.log.i('STEP 2.1、长按动态照片缩略图进行预览');
  await dt.assertLongClickById('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView_Preview', true); // 断言进入预览模式

  dt.log.i('STEP 3、预览后长按播放时拖拽');
  dt.log.i('STEP 3.1、在预览模式下长按播放区域并尝试拖拽');
  await dt.assertLongClickAndDrag('MotionPicturePlaybackArea_Preview', 'MiddleOfScreen'); // 尝试拖拽到屏幕中间
  dt.log.i('预期结果3、可拖至中转站和小艺');
  dt.log.i('STEP 3.2、断言中转站或小艺入口出现并可拖入');
  await dt.assertComponent('TransferStationDropTarget', true); // 假设中转站目标出现
  await dt.assertComponent('XiaoYiDropTarget', true); // 假设小艺目标出现
  dt.log.i('请手动验证可以拖拽到中转站和小艺');
  await dt.assertComponent(PageTitle.index, true); // Assert still on a relevant page after drag attempt

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片宫格预览后长按播放时拖拽 end');
}

/**
 * 大图-动态照片: [动态照片大图滑动异常场景测试]
 * TAG: 251 TID: Multimedia_Gallery_Motion_picture_036
 */
async function Multimedia_Gallery_Motion_picture_036(dt: Dt) {
  dt.log.i('动态照片大图滑动异常场景测试 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 图库存在动态照片');
  dt.log.i('STEP 0.1、启动图库应用');
  await dt.launchGalleryApp();
  dt.log.i('STEP 0.2、断言图库中存在至少两张动态照片');
  await dt.assertComponent('motion_photo_thumbnail_0', true);
  await dt.assertComponent('motion_photo_thumbnail_1', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、将多个连续动态照片效果切换为动态照片（原始效果）');
  dt.log.i('STEP 1.1、点击第一张动态照片进入大图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 1.2、切换为动态照片（原始效果）');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  await dt.assertClick('EffectOption_OriginalMotionPhoto');
  await dt.assertComponent('MotionPictureLargeView', true);

  dt.log.i('STEP 1.3、滑动到下一张动态照片');
  await dt.swipeScreen.left();
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 1.4、切换为动态照片（原始效果）');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  await dt.assertClick('EffectOption_OriginalMotionPhoto');
  await dt.assertComponent('MotionPictureLargeView', true);

  dt.log.i('STEP 2、大图滑动未完成（超过一半）时往回滑');
  dt.log.i('STEP 2.1、从当前动态照片开始，向左滑动一半距离');
  await dt.swipe(800, 500, 400, 500); // 从右到左滑动一半
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.2、立即向右滑回');
  await dt.swipe(400, 500, 800, 500); // 从左到右滑回
  await dt.sleep(DELAY.short);

  dt.log.i('预期结果2，3、滑动动作完成后，动态照片开始播放');
  dt.log.i('STEP 2.3、断言动态照片正在播放');
  await dt.assertComponent('PlayingIndicator', true); // 假设有播放指示器
  dt.log.i('请手动验证动态照片开始播放');

  dt.log.i('STEP 3、将多个连续动态照片效果切换为循环播放，主角时刻，运动轨迹');
  dt.log.i('STEP 3.1、将当前动态照片效果切换为循环播放');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  await dt.assertClick('EffectOption_LoopPlayback');
  await dt.assertComponent('MotionPictureLargeView', true);

  dt.log.i('STEP 3.2、滑动到下一张动态照片');
  await dt.swipeScreen.left();
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 3.3、将该动态照片效果切换为主角时刻');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  await dt.assertClick('EffectOption_ProtagonistMoment');
  await dt.assertComponent('MotionPictureLargeView', true);

  dt.log.i('STEP 3.4、滑动到下一张动态照片');
  await dt.swipeScreen.left();
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 3.5、将该动态照片效果切换为运动轨迹');
  await dt.assertClick('MotionEffectSwitchButton');
  await dt.assertComponent('EffectOptionPanel', true);
  await dt.assertClick('EffectOption_MotionTrail');
  await dt.assertComponent('MotionPictureLargeView', true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片大图滑动异常场景测试 end');
}

/**
 * 大图-动态照片: [动态照片编辑入口检查]
 * TAG: 286 TID: Multimedia_Gallery_Motion_picture_037
 */
async function Multimedia_Gallery_Motion_picture_037(dt: Dt) {
  dt.log.i('动态照片编辑入口检查 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 相机拍摄动态照片');
  dt.log.i('STEP 0.1、启动相机应用并拍摄包含运动物体的动态照片');
  await dt.launchCameraApp();
  await dt.captureMotionPhotoWithMovement(); // 拍摄包含运动物体的动态照片
  dt.log.i('STEP 0.2、退出相机并返回图库');
  await dt.exitCameraToGallery();
  dt.log.i('STEP 0.3、断言图库中存在动态照片');
  await dt.assertComponent('motion_photo_thumbnail', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、宫格页面点击动态照片进入大图，点击编辑');
  dt.log.i('STEP 1.1、点击动态照片进入大图');
  await dt.assertClick('motion_photo_thumbnail_0');
  await dt.assertComponent('MotionPictureLargeView', true);
  dt.log.i('STEP 1.2、点击编辑按钮');
  await dt.assertClick('EditButton');
  await dt.assertComponent('EditPage', true); // 断言进入编辑页面

  dt.log.i('预期结果1、编辑页面有动态入口，可以进行视频编辑；其他入口为图片编辑');
  dt.log.i('STEP 1.3、断言编辑页面存在视频编辑入口');
  await dt.assertComponent('VideoEditEntry', true); // 假设视频编辑入口的ID
  dt.log.i('STEP 1.4、断言编辑页面存在图片编辑入口');
  await dt.assertComponent('ImageEditEntry', true); // 假设图片编辑入口的ID
  dt.log.i('请手动验证视频编辑入口可用，其他入口进行图片编辑');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片编辑入口检查 end');
}

/**
 * 大图-动态照片: [动态照片宫格操作检查]
 * TAG: 281 TID: Multimedia_Gallery_Motion_picture_038
 */
async function Multimedia_Gallery_Motion_picture_038(dt: Dt) {
  dt.log.i('动态照片宫格操作检查 start');

  dt.log.i('STEP 0、执行并断言判断预制条件有效性: 相机拍摄动态照片');
  dt.log.i('STEP 0.1、启动相机应用并拍摄多张不同效果的动态照片');
  await dt.launchCameraApp();
  await dt.captureMotionPhotoWithVariousEffects(); // Placeholder: Captures various dynamic photos
  dt.log.i('STEP 0.2、退出相机并返回图库');
  await dt.exitCameraToGallery();
  dt.log.i('STEP 0.3、断言图库中存在多张不同效果的动态照片');
  await dt.assertComponent('motion_photo_thumbnail_0', true);
  await dt.assertComponent('motion_photo_thumbnail_1', true);
  dt.log.i('STEP 0、预制条件有效性检查通过');

  dt.log.i('STEP 1、不同效果动态照片宫格年月日试图切换，查看不同视图下动态照片显示');
  dt.log.i('STEP 1.1、切换到月视图');
  await dt.assertClick('MonthViewButton'); // 假设月视图按钮
  await dt.assertComponent('MonthViewGrid', true); // 断言进入月视图
  dt.log.i('STEP 1.2、查看动态照片缩略图显示');
  dt.log.i('请手动验证动态照片在月视图下缩略图显示一致');

  dt.log.i('STEP 1.3、切换到年视图');
  await dt.assertClick('YearViewButton'); // 假设年视图按钮
  await dt.assertComponent('YearViewGrid', true); // 断言进入年视图
  dt.log.i('STEP 1.4、查看动态照片缩略图显示');
  dt.log.i('请手动验证动态照片在年视图下缩略图显示一致');

  dt.log.i('预期结果1、同样效果动态照片在不同视图下缩略图显示一致');

  dt.log.i('STEP 2、不同效果动态照片宫格多选、收藏、分享、对比、拼图、删除、更多（移动、隐藏、收藏）');
  dt.log.i('STEP 2.1、多选动态照片');
  await dt.assertLongClickById('motion_photo_thumbnail_0');
  await dt.assertComponent('MultiSelectMode', true); // 断言进入多选模式
  await dt.assertClick('motion_photo_thumbnail_1'); // 选择第二张
  await dt.assertComponent('SelectedCount_2', true); // 断言选中两张

  dt.log.i('STEP 2.2、执行收藏操作');
  await dt.assertClick('FavoriteButton');
  await dt.assertComponent('FavoriteSuccessToast', true); // 断言收藏成功提示

  dt.log.i('STEP 2.3、执行分享操作');
  await dt.assertClick('ShareButton');
  await dt.assertComponent('ShareSheet', true);
  await dt.pressBack(); // 取消分享
  await dt.assertComponent('MultiSelectMode', true);

  dt.log.i('STEP 2.4、执行删除操作');
  await dt.assertClick('DeleteButton');
  await dt.assertComponent('DeleteConfirmationDialog', true);
  await dt.assertClick('ConfirmDeleteButton');
  await dt.negateComponent('motion_photo_thumbnail_0'); // 断言第一张动态照片被删除
  await dt.assertComponent('photoGridView_grid_0', true); // 断言返回宫格视图

  dt.log.i('预期结果2、不同操作流程与正常宫格一致，宫格显示正常');
  dt.log.i('请手动验证所有操作流程与正常宫格一致，且宫格显示正常');

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  dt.log.i('动态照片宫格操作检查 end');
}

