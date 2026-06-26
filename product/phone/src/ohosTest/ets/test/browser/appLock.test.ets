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

import { afterAll, afterEach, beforeAll, describe, Level } from '@ohos/hypium';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';

const TAG: string = 'VideoTest';

export default function VideoTest(): void {
  describe('AppLockTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAppLockTest').init();
      dt.log.i('beforeAll AppLockTest start');
      dt.log.i('beforeAll AppLockTest finish');
    });
    run('Multimedia_Gallery_SR20250104962101_022', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [其他窗口将图库解锁，则大图组件支持刷新显示全部图片/视频] TID: Multimedia_Gallery_SR20250104962101_022
      await Multimedia_Gallery_SR20250104962101_022(dt);
    });
    run('Multimedia_Gallery_SR20250104962101_023', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [其他窗口将图库锁上锁，大图组件立即进入应用锁状态] TID: Multimedia_Gallery_SR20250104962101_023
      await Multimedia_Gallery_SR20250104962101_023(dt);
    });
    run('Multimedia_Gallery_SR20250104962101_029', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [图库加应用锁相机拍照的动态照片支持视频导出] TID: Multimedia_Gallery_SR20250104962101_029
      await Multimedia_Gallery_SR20250104962101_029(dt);
    });
    run('Multimedia_Gallery_SR20250104962101_027', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [图库添加应用锁支持应用退出后立即锁定] TID: Multimedia_Gallery_SR20250104962101_027
      await Multimedia_Gallery_SR20250104962101_027(dt);
    });
    run('Multimedia_Gallery_SR20250104962101_020', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [图库添加应用锁，支持多任务] TID: Multimedia_Gallery_SR20250104962101_020
      await Multimedia_Gallery_SR20250104962101_020(dt);
    });
    run('Multimedia_Gallery_SR20250104962101_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [图库加应用锁相机拍照的照片支持编辑] TID: Multimedia_Gallery_SR20250104962101_003
      await Multimedia_Gallery_SR20250104962101_003(dt);
    });
    run('Multimedia_Gallery_SR20250104962101_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [图库加应用锁相机拍照的照片预览] TID: Multimedia_Gallery_SR20250104962101_002
      await Multimedia_Gallery_SR20250104962101_002(dt);
    });
    run('Multimedia_Gallery_SR20250104962101_010', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [图库加应用锁多次相机拍照的照片浏览] TID: Multimedia_Gallery_SR20250104962101_010
      await Multimedia_Gallery_SR20250104962101_010(dt);
    });
    run('Multimedia_Gallery_SR20250104962101_004', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [图库加应用锁相机拍照的照片支持分享] TID: Multimedia_Gallery_SR20250104962101_004
      await Multimedia_Gallery_SR20250104962101_004(dt);
    });
    run('Multimedia_Gallery_SR20250104962101_001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [图库加应用锁相机界面] TID: Multimedia_Gallery_SR20250104962101_001
      await Multimedia_Gallery_SR20250104962101_001(dt);
    });
    run('Multimedia_Gallery_SR20250104962101_011', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [应用锁中设置应用退出后立即锁定] TID: Multimedia_Gallery_SR20250104962101_011
      await Multimedia_Gallery_SR20250104962101_011(dt);
    });
    run('Multimedia_Gallery_SR20250104962101_019', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [图库添加应用锁，支持锁屏密码和隐私密码] TID: Multimedia_Gallery_SR20250104962101_019
      await Multimedia_Gallery_SR20250104962101_019(dt);
    });
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachAppLockTest').init();
      dt.log.i('afterEach AppLockTest finish');
    });
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllAppLockTest').init();
      await Exit.browser();
      dt.log.i('afterAll AppLockTest finish');
    });
  });
}

/**
 * 大图-视频: [其他窗口将图库解锁，则大图组件支持刷新显示全部图片/视频]
 * TAG: 666 TID: Multimedia_Gallery_SR20250104962101_022
 * 前置条件
 * 1、图库添加应用锁，设置密码，息屏再亮屏
 */
async function Multimedia_Gallery_SR20250104962101_022(dt: Dt) {
  dt.log.i('其他窗口将图库解锁，则大图组件支持刷新显示全部图片/视频 start');
  dt.log.i('STEP 1、相机进入悬浮窗拍照后大图浏览');
  // CameraAW.cameraEntrance(self.driver, mode=CameraAW.cam_intro_agree)

  // PhotosAW.slideScreen(self.device1, Operate='Float')
  // self.driver.touch(BY.key("SCBFloatMiniCoverStack"), wait_time=1)
  // CameraAW.cam_shutter.execute(self.driver)
  // self.driver.wait(3)
  // CameraAW.cam_thumbnail.execute(self.driver)


  await dt.sleep();
  dt.log.i('预期结果1、只可浏览本次拍照的图片和视频');
  // assert self.driver.check_component_exist(BY.key("browserFocus_")), "左右滑动照片浏览正常"

  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、主页面给图库去除应用锁');

  await dt.sleep();
  dt.log.i('预期结果2、相机刷新显示可浏览全部图片/视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('其他窗口将图库解锁，则大图组件支持刷新显示全部图片/视频 end');
}

/**
 * 大图-应用锁: [其他窗口将图库锁上锁，大图组件立即进入应用锁状态]
 * TAG: 667 TID: Multimedia_Gallery_SR20250104962101_023
 * 前置条件
 * 1、图库未添加应用锁
 */
async function Multimedia_Gallery_SR20250104962101_023(dt: Dt) {
  dt.log.i('其他窗口将图库锁上锁，大图组件立即进入应用锁状态 start');
  dt.log.i('STEP 1、相机进入悬浮窗点击右下角缩略图进行大图浏览');

  await dt.sleep();
  dt.log.i('预期结果1、可以浏览全部的图片和视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、主页面给图库添加应用锁');

  await dt.sleep();
  dt.log.i('预期结果2、立即刷新相机页面，右下角缩略图不显示图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、相机点击右下缩略图');

  await dt.sleep();
  dt.log.i('预期结果3、跳转到解锁界面，提示“图库已上锁，图片或视频无法访问”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('图库已上锁，图片或视频无法访问', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('其他窗口将图库锁上锁，大图组件立即进入应用锁状态 end');
}

/**
 * 大图-应用锁: [图库加应用锁相机拍照的动态照片支持视频导出]
 * TAG: 669 TID: Multimedia_Gallery_SR20250104962101_029
 * 前置条件
 * 1、图库添加应用锁，设置密码，息屏再亮屏
 */
async function Multimedia_Gallery_SR20250104962101_029(dt: Dt) {
  dt.log.i('图库加应用锁相机拍照的动态照片支持视频导出 start');
  dt.log.i('STEP 1、打开相机界面，拍摄动态照片');

  await dt.sleep();
  dt.log.i('预期结果1、拍摄照片之后，相机左下角缩略图显示图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点开缩略图大图浏览');

  await dt.sleep();
  dt.log.i('预期结果2、跳转到大图浏览界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击更多按钮中的导出视频选项');

  await dt.sleep();
  dt.log.i('预期结果3、弹出正在导出的提示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、图库中查看刚刚导出的视频');

  await dt.sleep();
  dt.log.i('预期结果4、相机相册新增导出的视频');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库加应用锁相机拍照的动态照片支持视频导出 end');
}

/**
 * 大图-应用锁: [图库添加应用锁支持应用退出后立即锁定]
 * TAG: 670 TID: Multimedia_Gallery_SR20250104962101_027
 * 前置条件
 * 1、图库添加应用锁，打开退出后立即锁定开关，息屏再亮屏
 */
async function Multimedia_Gallery_SR20250104962101_027(dt: Dt) {
  dt.log.i('图库添加应用锁支持应用退出后立即锁定 start');
  dt.log.i('STEP 1、点击图库进入解锁页面，输入密码');

  await dt.sleep();
  dt.log.i('预期结果1、解锁成功进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、上滑退出图库再点击进入图库');

  await dt.sleep();
  dt.log.i('预期结果2、重新进入应用解锁页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、上滑退出图库，相机拍多张照片，选择照片移动');

  await dt.sleep();
  dt.log.i('预期结果3、弹出解锁页面，解锁后选择相册移动，返回相机时，相机刷新为拍照页面，其他照片不显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库添加应用锁支持应用退出后立即锁定 end');
}

/**
 * 大图-应用锁: [图库添加应用锁，支持多任务]
 * TAG: 674 TID: Multimedia_Gallery_SR20250104962101_020
 * 前置条件
 * 1、图库添加应用锁，设置密码，息屏再亮屏
 */
async function Multimedia_Gallery_SR20250104962101_020(dt: Dt) {
  dt.log.i('图库添加应用锁，支持多任务 start');
  dt.log.i('STEP 1、通过锁屏密码/隐私密码解锁图库页面');

  await dt.sleep();
  dt.log.i('STEP 2、返回主页面后息屏');

  await dt.sleep();
  dt.log.i('STEP 3、点亮解锁屏幕，屏幕下方上滑进入多任务');

  await dt.sleep();
  dt.log.i('预期结果3、多任务页面支持应用锁');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库添加应用锁，支持多任务 end');
}

/**
 * 大图-应用锁: [图库加应用锁相机拍照的照片支持编辑]
 * TAG: 675 TID: Multimedia_Gallery_SR20250104962101_003
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20250104962101_003(dt: Dt) {
  dt.log.i('图库加应用锁相机拍照的照片支持编辑 start');
  dt.log.i('STEP 1、图库添加应用锁');

  await dt.sleep();
  dt.log.i('STEP 2、打开相机界面，拍摄几张照片');

  await dt.sleep();
  dt.log.i('预期结果2、拍摄照片之后，相机左下角缩略图显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点开缩略图大图浏览');

  await dt.sleep();
  dt.log.i('预期结果3、跳转到大图浏览界面5、显示编辑之后的照片6、新增一张另存的照片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击编辑按钮，任意编辑内容');

  await dt.sleep();
  dt.log.i('STEP 5、覆盖保存照片');

  await dt.sleep();
  dt.log.i('预期结果5、显示编辑之后的照片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、重复操作4，另存为照片');

  await dt.sleep();
  dt.log.i('预期结果6、新增一张另存的照片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库加应用锁相机拍照的照片支持编辑 end');
}

/**
 * 大图-应用锁: [图库加应用锁相机拍照的照片预览]
 * TAG: 676 TID: Multimedia_Gallery_SR20250104962101_002
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20250104962101_002(dt: Dt) {
  dt.log.i('图库加应用锁相机拍照的照片预览 start');
  dt.log.i('STEP 1、图库添加应用锁');

  await dt.sleep();
  dt.log.i('STEP 2、打开相机界面，拍摄几张照片');

  await dt.sleep();
  dt.log.i('预期结果2、拍摄照片之后，相机左下角缩略图显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点开缩略图大图浏览');

  await dt.sleep();
  dt.log.i('预期结果3、跳转到大图浏览界面，动效显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、左右滑动照片');

  await dt.sleep();
  dt.log.i('预期结果4、只能浏览刚刚拍摄的照片，左右滑动照片浏览正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库加应用锁相机拍照的照片预览 end');
}

/**
 * 大图-应用锁: [图库加应用锁多次相机拍照的照片浏览]
 * TAG: 678 TID: Multimedia_Gallery_SR20250104962101_010
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20250104962101_010(dt: Dt) {
  dt.log.i('图库加应用锁多次相机拍照的照片浏览 start');
  dt.log.i('STEP 1、图库添加应用锁');

  await dt.sleep();
  dt.log.i('STEP 2、打开相机界面，拍摄几张照片');

  await dt.sleep();
  dt.log.i('预期结果2、拍摄照片之后，相机左下角缩略图显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点开缩略图大图浏览');

  await dt.sleep();
  dt.log.i('预期结果3、跳转到大图浏览界面，左右滑动照片浏览正常5、可以浏览2次拍摄的照片，左右滑动照片浏览正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、退出大图浏览，重新拍摄几张照片');

  await dt.sleep();
  dt.log.i('STEP 5、点击缩略图大图浏览并滑动浏览');

  await dt.sleep();
  dt.log.i('预期结果5、可以浏览2次拍摄的照片，左右滑动照片浏览正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库加应用锁多次相机拍照的照片浏览 end');
}

/**
 * 大图-应用锁: [图库加应用锁相机拍照的照片支持分享]
 * TAG: 679 TID: Multimedia_Gallery_SR20250104962101_004
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20250104962101_004(dt: Dt) {
  dt.log.i('图库加应用锁相机拍照的照片支持分享 start');
  dt.log.i('STEP 1、图库添加应用锁');

  await dt.sleep();
  dt.log.i('STEP 2、打开相机界面，拍摄几张照片');

  await dt.sleep();
  dt.log.i('预期结果2、相机左下角缩略图不显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点开缩略图大图浏览');

  await dt.sleep();
  dt.log.i('预期结果3、跳转到大图浏览界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击分享按钮，分享照片');

  await dt.sleep();
  dt.log.i('预期结果4、成功跳转到分享界面，对端设备可以收到分享的照片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库加应用锁相机拍照的照片支持分享 end');
}

/**
 * 大图-应用锁: [图库加应用锁相机界面]
 * TAG: 680 TID: Multimedia_Gallery_SR20250104962101_001
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20250104962101_001(dt: Dt) {
  dt.log.i('图库加应用锁相机界面 start');
  dt.log.i('STEP 1、图库添加应用锁');

  await dt.sleep();
  dt.log.i('STEP 2、打开相机界面');

  await dt.sleep();
  dt.log.i('预期结果2、相机左下角缩略图不显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击左下角缩略图的位置');

  await dt.sleep();
  dt.log.i('预期结果3、跳转到解锁界面，提示“图库已上锁，图片或视频无法访问”，界面显示正常，无截断等');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('图库已上锁，图片或视频无法访问', true);
  dt.log.i('STEP 4、点击“解锁并访问”蓝色字体');

  await dt.sleep();
  dt.log.i('预期结果4、跳转到输入密码界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、输入密码');

  await dt.sleep();
  dt.log.i('预期结果5、跳转到图库界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库加应用锁相机界面 end');
}

/**
 * 大图-应用锁: [应用锁中设置应用退出后立即锁定]
 * TAG: 686 TID: Multimedia_Gallery_SR20250104962101_011
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20250104962101_011(dt: Dt) {
  dt.log.i('应用锁中设置应用退出后立即锁定 start');
  dt.log.i('STEP 1、图库添加应用锁并应用锁中设置应用退出后立即锁定');

  await dt.sleep();
  dt.log.i('STEP 2、打开相机界面，拍摄几张照片');

  await dt.sleep();
  dt.log.i('预期结果2、拍摄照片之后，相机左下角缩略图显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点开缩略图大图浏览');

  await dt.sleep();
  dt.log.i('预期结果3、跳转到大图浏览界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、相机退后台再次打相机');

  await dt.sleep();
  dt.log.i('预期结果4、缩略图不显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、点击缩略图位置');

  await dt.sleep();
  dt.log.i('预期结果5、跳转到图库上锁界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁中设置应用退出后立即锁定 end');
}

/**
 * 大图-应用锁: [图库添加应用锁，支持锁屏密码和隐私密码]
 * TAG: 691 TID: Multimedia_Gallery_SR20250104962101_019
 * 前置条件
 * 1、图库添加应用锁，分别设置锁屏密码/隐私密码，息屏再亮屏
 */
async function Multimedia_Gallery_SR20250104962101_019(dt: Dt) {
  dt.log.i('图库添加应用锁，支持锁屏密码和隐私密码 start');
  dt.log.i('STEP 1、通过锁屏密码/隐私密码解锁图库页面');

  await dt.sleep();
  dt.log.i('预期结果1、跳转到图库界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、息屏后点亮输入锁屏密码解锁屏幕');

  await dt.sleep();
  dt.log.i('预期结果2、跳转到图库界面/应用解锁界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、输入隐私密码解锁应用');

  await dt.sleep();
  dt.log.i('预期结果3、跳转到图库界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库添加应用锁，支持锁屏密码和隐私密码 end');
}

/*
#====================================================================================
#    @Method:          set_screen_lock_pwd(ad)
#    @Precondition:    设置锁屏密码（密码固定为"111111"）
#    @Func:
#    @PostStatus:
#    @Param:
#    @Example:
#    @ModifyRecord:    无
#====================================================================================
*/
function set_screen_lock_pwd(ad: Dt) {
  // ad.stop_app('com.ohos.settings')
  // ad.start_app('com.ohos.settings')
  // ad.touch(BY.key('biometrics_and_password_settings.title'), scroll_target = BY.type("List"))
  ad.assertClick('biometrics_and_password_settings.title');
  // component = ad.find_component(BY.key('entry_title_close_lock_screen_password_title'))
  ad.assertClick('entry_title_close_lock_screen_password_title')
  // if component is
  // None:
  //   ad.touch(BY.key('entry_title_lock_screen_password_title'))
  // ad.input_text(BY.key('PasswdTextInputKey_six_pin_circle_key'), '111111')
  // ad.touch(BY.key('button_1_cancel_button'))
  // ad.input_text(BY.key('PasswdTextInputKey_six_pin_circle_key'), '111111')
  // ad.wait(5)
  // ad.stop_app('com.ohos.settings')
}