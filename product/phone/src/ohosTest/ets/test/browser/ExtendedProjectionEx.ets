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

    run('IMediaAPP_Gallery_Extendedprojection_001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [图库大图界面支持扩展投屏] TID: IMediaAPP_Gallery_Extendedprojection_001
      await IMediaAPP_Gallery_Extendedprojection_001(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [大图左右滑动，投屏界面同步显示内容切换] TID: IMediaAPP_Gallery_Extendedprojection_002
      await IMediaAPP_Gallery_Extendedprojection_002(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [大图删除切换图片时，投屏界面同步显示切换内容] TID: IMediaAPP_Gallery_Extendedprojection_003
      await IMediaAPP_Gallery_Extendedprojection_003(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图编辑保存后，投屏界面同步显示编辑后的图片] TID: IMediaAPP_Gallery_Extendedprojection_004
      await IMediaAPP_Gallery_Extendedprojection_004(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [拼图保存后，投屏界面从镜像投屏切换到扩展投屏，并显示保存后的图片] TID: IMediaAPP_Gallery_Extendedprojection_005
      await IMediaAPP_Gallery_Extendedprojection_005(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-预览条用例: [滑动底部或者切换预览条时，投屏屏界面同步显示内容切换] TID: IMediaAPP_Gallery_Extendedprojection_006
      await IMediaAPP_Gallery_Extendedprojection_006(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图进行缩放、平移时，投屏界面同步显示缩放、平移后的内容] TID: IMediaAPP_Gallery_Extendedprojection_007
      await IMediaAPP_Gallery_Extendedprojection_007(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频播放时，手机屏幕不显示播放内容，紧显示投屏提示] TID: IMediaAPP_Gallery_Extendedprojection_008
      await IMediaAPP_Gallery_Extendedprojection_008(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频播放时，投屏界面同步显示播放内容] TID: IMediaAPP_Gallery_Extendedprojection_009
      await IMediaAPP_Gallery_Extendedprojection_009(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_010', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图下拉返回宫格，投屏界面退出扩展投屏，显示镜像投屏] TID: IMediaAPP_Gallery_Extendedprojection_010
      await IMediaAPP_Gallery_Extendedprojection_010(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_011', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图上滑，投屏界面不退出扩展投屏] TID: IMediaAPP_Gallery_Extendedprojection_011
      await IMediaAPP_Gallery_Extendedprojection_011(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_012', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图投屏时，图库进入后台，投屏界面退出扩展投屏，显示镜像投屏] TID: IMediaAPP_Gallery_Extendedprojection_012
      await IMediaAPP_Gallery_Extendedprojection_012(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_013', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-锁屏用例: [视频播放时，手机锁屏，投屏界面正常播放，不会退出扩展投屏，不会切换镜像投屏] TID: IMediaAPP_Gallery_Extendedprojection_013
      await IMediaAPP_Gallery_Extendedprojection_013(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_014', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频播放时，图库进入后台，投屏界面正常播放，不会退出扩展投屏，不会切换镜像投屏] TID: IMediaAPP_Gallery_Extendedprojection_014
      await IMediaAPP_Gallery_Extendedprojection_014(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_015', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [投屏时杀图库进程，投屏界面退出扩展投屏，显示镜像投屏] TID: IMediaAPP_Gallery_Extendedprojection_015
      await IMediaAPP_Gallery_Extendedprojection_015(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_016', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [大图左右滑动投屏界面同步显示内容切换响应时延和完成时延] TID: IMediaAPP_Gallery_Extendedprojection_016
      await IMediaAPP_Gallery_Extendedprojection_016(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_017', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [图库大图扩展投屏功耗不超xxx同等场景] TID: IMediaAPP_Gallery_Extendedprojection_017
      await IMediaAPP_Gallery_Extendedprojection_017(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_020', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [从视频-本地路径进入图库播放视频] TID: IMediaAPP_Gallery_Extendedprojection_020
      await IMediaAPP_Gallery_Extendedprojection_020(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_021', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [无线投屏成功后打开图库播放视频过程中重命名等操作] TID: IMediaAPP_Gallery_Extendedprojection_021
      await IMediaAPP_Gallery_Extendedprojection_021(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_022', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [图库播放视频再进行无线投屏] TID: IMediaAPP_Gallery_Extendedprojection_022
      await IMediaAPP_Gallery_Extendedprojection_022(dt);
    });

    run('IMediaAPP_Gallery_Extendedprojection_023', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [无线投屏成功后打开图库扩展模式播放视频，上滑退到后台，再回到应用前台] TID: IMediaAPP_Gallery_Extendedprojection_023
      await IMediaAPP_Gallery_Extendedprojection_023(dt);
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
 * 大图-大图: [图库大图界面支持扩展投屏]
 * TAG: 313 TID: IMediaAPP_Gallery_Extendedprojection_001
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_001(dt: Dt) {
  dt.log.i('图库大图界面支持扩展投屏 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击缩略图进入大图（验证不同格式和不同分辨率的图片和视频资源）');

  await dt.sleep();
  dt.log.i('预期结果2、智慧屏实时显示大图界面，最大化显示（即图片的一边与屏幕等宽或者等高，另一边小于屏幕高度或宽度），沉浸式显示，不显示预览条和菜单');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库大图界面支持扩展投屏 end');
}

/**
 * 大图-滑动: [大图左右滑动，投屏界面同步显示内容切换]
 * TAG: 303 TID: IMediaAPP_Gallery_Extendedprojection_002
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_002(dt: Dt) {
  dt.log.i('大图左右滑动，投屏界面同步显示内容切换 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击缩略图进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、大图左右滑动切换图片');

  await dt.sleep();
  dt.log.i('预期结果3、投屏界面同步显示切换内容，界面显示流畅，无卡顿、花屏、闪屏');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图左右滑动，投屏界面同步显示内容切换 end');
}

/**
 * 大图-删除: [大图删除切换图片时，投屏界面同步显示切换内容]
 * TAG: 305 TID: IMediaAPP_Gallery_Extendedprojection_003
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_003(dt: Dt) {
  dt.log.i('大图删除切换图片时，投屏界面同步显示切换内容 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击缩略图进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、点击删除图片');

  await dt.sleep();
  dt.log.i('预期结果3、投屏界面不显示删除弹窗？？？，同步显示下一张图片大图，界面显示流畅，无卡顿、花屏、闪屏');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图删除切换图片时，投屏界面同步显示切换内容 end');
}

/**
 * 大图-大图: [大图编辑保存后，投屏界面同步显示编辑后的图片]
 * TAG: 307 TID: IMediaAPP_Gallery_Extendedprojection_004
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_004(dt: Dt) {
  dt.log.i('大图编辑保存后，投屏界面同步显示编辑后的图片 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击缩略图进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、点击编辑图片并保存');

  await dt.sleep();
  dt.log.i('预期结果3.1、投屏界面退出扩展投屏，进入镜像投屏3.2、投屏界面同步显示编辑后的图片大图，界面显示流畅，无卡顿、花屏、闪屏');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图编辑保存后，投屏界面同步显示编辑后的图片 end');
}

/**
 * 大图-格式: [拼图保存后，投屏界面从镜像投屏切换到扩展投屏，并显示保存后的图片]
 * TAG: 315 TID: IMediaAPP_Gallery_Extendedprojection_005
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_005(dt: Dt) {
  dt.log.i('拼图保存后，投屏界面从镜像投屏切换到扩展投屏，并显示保存后的图片 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，宫格多选，选择几张照片拼图并保存');

  await dt.sleep();
  dt.log.i('预期结果2.1、投屏界面从镜像投屏切换到扩展投屏2.2、投屏界面同步显示保存后的拼图大图，界面显示流畅，无卡顿、花屏、闪屏');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('拼图保存后，投屏界面从镜像投屏切换到扩展投屏，并显示保存后的图片 end');
}

/**
 * 大图-预览条: [滑动底部或者切换预览条时，投屏屏界面同步显示内容切换]
 * TAG: 306 TID: IMediaAPP_Gallery_Extendedprojection_006
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_006(dt: Dt) {
  dt.log.i('滑动底部或者切换预览条时，投屏屏界面同步显示内容切换 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击缩略图进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、滑动底部预览条或者点击切换图片');

  await dt.sleep();
  dt.log.i('预期结果3、投屏界面同步显示切换内容，界面显示流畅，无卡顿、花屏、闪屏');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('滑动底部或者切换预览条时，投屏屏界面同步显示内容切换 end');
}

/**
 * 大图-大图: [大图进行缩放、平移时，投屏界面同步显示缩放、平移后的内容]
 * TAG: 309 TID: IMediaAPP_Gallery_Extendedprojection_007
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_007(dt: Dt) {
  dt.log.i('大图进行缩放、平移时，投屏界面同步显示缩放、平移后的内容 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击缩略图进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、大图界面缩放、平移');

  await dt.sleep();
  dt.log.i('预期结果3、投屏界面同步显示缩放、平移后的内容，界面显示流畅，无卡顿、花屏、闪屏');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图进行缩放、平移时，投屏界面同步显示缩放、平移后的内容 end');
}

/**
 * 大图-视频: [视频播放时，手机屏幕不显示播放内容，紧显示投屏提示]
 * TAG: 310 TID: IMediaAPP_Gallery_Extendedprojection_008
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_008(dt: Dt) {
  dt.log.i('视频播放时，手机屏幕不显示播放内容，紧显示投屏提示 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击视频缩略图进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、点击播放按钮');

  await dt.sleep();
  dt.log.i('预期结果3、手机显示视频播放提示，提示语待UX提供，不显示播放内容，界面符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放时，手机屏幕不显示播放内容，紧显示投屏提示 end');
}

/**
 * 大图-视频: [视频播放时，投屏界面同步显示播放内容]
 * TAG: 314 TID: IMediaAPP_Gallery_Extendedprojection_009
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_009(dt: Dt) {
  dt.log.i('视频播放时，投屏界面同步显示播放内容 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击视频缩略图进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、点击播放按钮');

  await dt.sleep();
  dt.log.i('预期结果3、投屏界面同步显示视频播放内容，界面显示流畅，无卡顿、花屏、闪屏');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放时，投屏界面同步显示播放内容 end');
}

/**
 * 大图-大图: [大图下拉返回宫格，投屏界面退出扩展投屏，显示镜像投屏]
 * TAG: 304 TID: IMediaAPP_Gallery_Extendedprojection_010
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_010(dt: Dt) {
  dt.log.i('大图下拉返回宫格，投屏界面退出扩展投屏，显示镜像投屏 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击缩略图进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、大图下拉返回');

  await dt.sleep();
  dt.log.i('预期结果3、投屏界面从扩展投屏切换到镜像投屏');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图下拉返回宫格，投屏界面退出扩展投屏，显示镜像投屏 end');
}

/**
 * 大图-大图: [大图上滑，投屏界面不退出扩展投屏]
 * TAG: 316 TID: IMediaAPP_Gallery_Extendedprojection_011
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_011(dt: Dt) {
  dt.log.i('大图上滑，投屏界面不退出扩展投屏 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击缩略图进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、大图上滑');

  await dt.sleep();
  dt.log.i('预期结果3、投屏界面显示扩展投屏界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图上滑，投屏界面不退出扩展投屏 end');
}

/**
 * 大图-大图: [大图投屏时，图库进入后台，投屏界面退出扩展投屏，显示镜像投屏]
 * TAG: 319 TID: IMediaAPP_Gallery_Extendedprojection_012
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_012(dt: Dt) {
  dt.log.i('大图投屏时，图库进入后台，投屏界面退出扩展投屏，显示镜像投屏 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击视频缩略图进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、上滑返回桌面面，图库进入后台');

  await dt.sleep();
  dt.log.i('预期结果3、投屏界面从扩展投屏切换到镜像投屏');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图投屏时，图库进入后台，投屏界面退出扩展投屏，显示镜像投屏 end');
}

/**
 * 大图-锁屏: [视频播放时，手机锁屏，投屏界面正常播放，不会退出扩展投屏，不会切换镜像投屏]
 * TAG: 312 TID: IMediaAPP_Gallery_Extendedprojection_013
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_013(dt: Dt) {
  dt.log.i('视频播放时，手机锁屏，投屏界面正常播放，不会退出扩展投屏，不会切换镜像投屏 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击视频缩略图进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、手机锁屏');

  await dt.sleep();
  dt.log.i('预期结果3、投屏界面视频播放正常，不会切换到镜像投屏');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放时，手机锁屏，投屏界面正常播放，不会退出扩展投屏，不会切换镜像投屏 end');
}

/**
 * 大图-视频: [视频播放时，图库进入后台，投屏界面正常播放，不会退出扩展投屏，不会切换镜像投屏]
 * TAG: 318 TID: IMediaAPP_Gallery_Extendedprojection_014
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_014(dt: Dt) {
  dt.log.i('视频播放时，图库进入后台，投屏界面正常播放，不会退出扩展投屏，不会切换镜像投屏 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击视频缩略图进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、上滑返回桌面面，图库进入后台');

  await dt.sleep();
  dt.log.i('预期结果3、投屏界面视频播放正常，不会切换到镜像投屏');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放时，图库进入后台，投屏界面正常播放，不会退出扩展投屏，不会切换镜像投屏 end');
}


/**
 * 大图-进入大图: [投屏时杀图库进程，投屏界面退出扩展投屏，显示镜像投屏]
 * TAG: 308 TID: IMediaAPP_Gallery_Extendedprojection_015
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_015(dt: Dt) {
  dt.log.i('投屏时杀图库进程，投屏界面退出扩展投屏，显示镜像投屏 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击缩略图进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、进入多任务或者侧滑杀图库进程');

  await dt.sleep();
  dt.log.i('预期结果3、投屏界面从扩展投屏切换到镜像投屏');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('投屏时杀图库进程，投屏界面退出扩展投屏，显示镜像投屏 end');
}

/**
 * 大图-滑动: [大图左右滑动投屏界面同步显示内容切换响应时延和完成时延]
 * TAG: 317 TID: IMediaAPP_Gallery_Extendedprojection_016
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_016(dt: Dt) {
  dt.log.i('大图左右滑动投屏界面同步显示内容切换响应时延和完成时延 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击视频缩略图进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、手机界面滑动大图开始，投屏UIAbility完成处理结束即投屏界面开始变化的第一帧结束');

  await dt.sleep();
  dt.log.i('预期结果3、响应时延200ms');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、投屏界面开始变化的第一帧开始，到图片切换显示完全');

  await dt.sleep();
  dt.log.i('预期结果4、完成时延不影响使用体验，参考人因数据不超过1S（投屏框架看护）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图左右滑动投屏界面同步显示内容切换响应时延和完成时延 end');
}


/**
 * 大图-大图: [图库大图扩展投屏功耗不超xxx同等场景]
 * TAG: 311 TID: IMediaAPP_Gallery_Extendedprojection_017
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_017(dt: Dt) {
  dt.log.i('图库大图扩展投屏功耗不超xxx同等场景 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击视频缩略图进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、手机界面滑动大图，2s滑动一张图片，测试300s，使用watt测试，功耗T2');

  await dt.sleep();
  dt.log.i('STEP 4、相同操作测试大图滑动功耗T1');

  await dt.sleep();
  dt.log.i('STEP 5、投屏功耗T3 = T2 - T1');

  await dt.sleep();
  dt.log.i('STEP 6、相同操作测试xxx大图投屏功耗T4');

  await dt.sleep();
  dt.log.i('预期结果6、T3 <= T4');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库大图扩展投屏功耗不超xxx同等场景 end');
}


/**
 * 大图-视频: [从视频-本地路径进入图库播放视频]
 * TAG: 334 TID: IMediaAPP_Gallery_Extendedprojection_020
 * 前置条件
 * 1、准备视频，且可投屏
 */
async function IMediaAPP_Gallery_Extendedprojection_020(dt: Dt) {
  dt.log.i('从视频-本地路径进入图库播放视频 start');
  dt.log.i('STEP 1、手机和大屏进行无线投屏');

  await dt.sleep();
  dt.log.i('预期结果1、投屏成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从视频-本地路径进入图库播放视频');

  await dt.sleep();
  dt.log.i('预期结果2、手机和大屏扩展模式播放视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('从视频-本地路径进入图库播放视频 end');
}

/**
 * 大图-视频: [无线投屏成功后打开图库播放视频过程中重命名等操作]
 * TAG: 322 TID: IMediaAPP_Gallery_Extendedprojection_021
 * 前置条件
 * 可投屏
 */
async function IMediaAPP_Gallery_Extendedprojection_021(dt: Dt) {
  dt.log.i('无线投屏成功后打开图库播放视频过程中重命名等操作 start');
  dt.log.i('STEP 1、手机和大屏进行无线投屏');

  await dt.sleep();
  dt.log.i('预期结果1、投屏成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、手机打开图库播放视频');

  await dt.sleep();
  dt.log.i('预期结果2、手机和大屏扩展模式播放视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、给视频重命名或其他操作');

  await dt.sleep();
  dt.log.i('预期结果3、正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无线投屏成功后打开图库播放视频过程中重命名等操作 end');
}

/**
 * 大图-视频: [图库播放视频再进行无线投屏]
 * TAG: 323 TID: IMediaAPP_Gallery_Extendedprojection_022
 * 前置条件
 * 1、已准备视频，可投屏
 */
async function IMediaAPP_Gallery_Extendedprojection_022(dt: Dt) {
  dt.log.i('图库播放视频再进行无线投屏 start');
  dt.log.i('STEP 1、手机打开图库播放视频，再进行无线投屏');

  await dt.sleep();
  dt.log.i('预期结果1、大屏镜像显示视频内容');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库播放视频再进行无线投屏 end');
}

/**
 * 大图-视频: [无线投屏成功后打开图库扩展模式播放视频，上滑退到后台，再回到应用前台]
 * TAG: 320 TID: IMediaAPP_Gallery_Extendedprojection_023
 * 前置条件
 * 1、已准备视频，可投屏
 */
async function IMediaAPP_Gallery_Extendedprojection_023(dt: Dt) {
  dt.log.i('无线投屏成功后打开图库扩展模式播放视频，上滑退到后台，再回到应用前台 start');
  dt.log.i('STEP 1、手机和大屏进行无线投屏');

  await dt.sleep();
  dt.log.i('预期结果1、投屏成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、手机打开图库播放视频，上滑退到后台，再回到应用前台');

  await dt.sleep();
  dt.log.i('预期结果2、手机和大屏扩展模式播放视频，上滑退到后台，再回到应用前台视频继续播放');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无线投屏成功后打开图库扩展模式播放视频，上滑退到后台，再回到应用前台 end');
}
