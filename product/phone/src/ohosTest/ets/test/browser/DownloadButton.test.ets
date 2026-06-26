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
    run('Multimedia_Gallery_Application_Downloadbutton_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [取消下载tab] TID: Multimedia_Gallery_Application_Downloadbutton_002
      await Multimedia_Gallery_Application_Downloadbutton_002(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [下载过程中，上划进入多任务界面] TID: Multimedia_Gallery_Application_Downloadbutton_003
      await Multimedia_Gallery_Application_Downloadbutton_003(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_004', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [下载过程中，处于霸屏状态] TID: Multimedia_Gallery_Application_Downloadbutton_004
      await Multimedia_Gallery_Application_Downloadbutton_004(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [正在下载过程中，预览图上居中的环形进度条位置保持不变，页面不会有异常显示状态] TID: Multimedia_Gallery_Application_Downloadbutton_005
      await Multimedia_Gallery_Application_Downloadbutton_005(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [下载过程中，设备锁屏/退出应用后重进] TID: Multimedia_Gallery_Application_Downloadbutton_006
      await Multimedia_Gallery_Application_Downloadbutton_006(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [下载过程中，杀掉应用后台] TID: Multimedia_Gallery_Application_Downloadbutton_007
      await Multimedia_Gallery_Application_Downloadbutton_007(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [下载过程中，关闭网络] TID: Multimedia_Gallery_Application_Downloadbutton_008
      await Multimedia_Gallery_Application_Downloadbutton_008(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_009', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [下载完成后，下载按钮消失] TID: Multimedia_Gallery_Application_Downloadbutton_009
      await Multimedia_Gallery_Application_Downloadbutton_009(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [相机进大图] TID: Multimedia_Gallery_Application_Downloadbutton_010
      await Multimedia_Gallery_Application_Downloadbutton_010(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_011', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [UX字体适配] TID: Multimedia_Gallery_Application_Downloadbutton_011
      await Multimedia_Gallery_Application_Downloadbutton_011(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_012', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [横竖屏适配] TID: Multimedia_Gallery_Application_Downloadbutton_012
      await Multimedia_Gallery_Application_Downloadbutton_012(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [悬浮窗适配] TID: Multimedia_Gallery_Application_Downloadbutton_013
      await Multimedia_Gallery_Application_Downloadbutton_013(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_014', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [分屏适配] TID: Multimedia_Gallery_Application_Downloadbutton_014
      await Multimedia_Gallery_Application_Downloadbutton_014(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_015', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [多语言适配] TID: Multimedia_Gallery_Application_Downloadbutton_015
      await Multimedia_Gallery_Application_Downloadbutton_015(dt);
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
 * 大图-下载: [取消下载tab]
 * TAG: 446 TID: Multimedia_Gallery_Application_Downloadbutton_002
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_002(dt: Dt) {
  dt.log.i('取消下载tab start');
  dt.log.i('STEP 1.点击取消下载按钮');

  await dt.sleep();
  dt.log.i('预期结果1.下载终止，按钮变成下载按钮，取消不需要确认');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.再次点击下载按钮');

  await dt.sleep();
  dt.log.i('预期结果2.再次下载需要重新开始下载');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('取消下载tab end');
}

/**
 * 大图-下载: [下载过程中，上划进入多任务界面]
 * TAG: 441 TID: Multimedia_Gallery_Application_Downloadbutton_003
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_003(dt: Dt) {
  dt.log.i('下载过程中，上划进入多任务界面 start');
  dt.log.i('STEP 1、进入云图浏览界面');

  await dt.sleep();
  dt.log.i('STEP 2、点击下载按钮');

  await dt.sleep();
  dt.log.i('STEP 3、界面上划进入多任务界面');

  await dt.sleep();
  dt.log.i('预期结果3.查看图片下载内容进度正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('下载过程中，上划进入多任务界面 end');
}

/**
 * 大图-下载: [下载过程中，处于霸屏状态]
 * TAG: 450 TID: Multimedia_Gallery_Application_Downloadbutton_004
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_004(dt: Dt) {
  dt.log.i('下载过程中，处于霸屏状态 start');
  dt.log.i('STEP 1.进入云图浏览界面，点击下载按钮');

  await dt.sleep();
  dt.log.i('预期结果1.界面出现下载进度条');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击其他按钮/左右滑动界面');

  await dt.sleep();
  dt.log.i('预期结果2.界面处于霸屏状态，不支持其他按钮及左右滑动');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('下载过程中，处于霸屏状态 end');
}

/**
 * 大图-下载: [正在下载过程中，预览图上居中的环形进度条位置保持不变，页面不会有异常显示状态]
 * TAG: 458 TID: Multimedia_Gallery_Application_Downloadbutton_005
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_005(dt: Dt) {
  dt.log.i('正在下载过程中，预览图上居中的环形进度条位置保持不变，页面不会有异常显示状态 start');
  dt.log.i('STEP 1.进入图片或视频编辑下载过程中');

  await dt.sleep();
  dt.log.i('STEP 2.查看环形下载进度条位置以及显示');

  await dt.sleep();
  dt.log.i('预期结果2.预览图上居中的环形进度条位置保持不变，页面正常显示不会有异常显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('正在下载过程中，预览图上居中的环形进度条位置保持不变，页面不会有异常显示状态 end');
}

/**
 * 大图-下载: [下载过程中，设备锁屏/退出应用后重进]
 * TAG: 443 TID: Multimedia_Gallery_Application_Downloadbutton_006
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_006(dt: Dt) {
  dt.log.i('下载过程中，设备锁屏/退出应用后重进 start');
  dt.log.i('STEP 1.正在下载过程中，设备锁屏/退出应用');

  await dt.sleep();
  dt.log.i('STEP 2.设备解锁/重新进入应用');

  await dt.sleep();
  dt.log.i('预期结果2.设备解锁/重新进入应用，下载进度不会被打断');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('下载过程中，设备锁屏/退出应用后重进 end');
}

/**
 * 大图-下载: [下载过程中，杀掉应用后台]
 * TAG: 439 TID: Multimedia_Gallery_Application_Downloadbutton_007
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_007(dt: Dt) {
  dt.log.i('下载过程中，杀掉应用后台 start');
  dt.log.i('STEP 1.正在下载过程中，杀掉应用，页面回退到桌面');

  await dt.sleep();
  dt.log.i('STEP 2.再次打开应用，观察下载进度状况');

  await dt.sleep();
  dt.log.i('预期结果2.下载进度会被打断，图库进入照片页，返回该张图片下载按钮依然存在');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('下载过程中，杀掉应用后台 end');
}

/**
 * 大图-下载: [下载过程中，关闭网络]
 * TAG: 438 TID: Multimedia_Gallery_Application_Downloadbutton_008
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_008(dt: Dt) {
  dt.log.i('下载过程中，关闭网络 start');
  dt.log.i('STEP 1、进入云图浏览界面');

  await dt.sleep();
  dt.log.i('STEP 2、点击下载按钮');

  await dt.sleep();
  dt.log.i('STEP 3、下拉控制中心，关闭网络');

  await dt.sleep();
  dt.log.i('预期结果3.1、关闭网络，提示 ”网络异常，请稍后重试“3.2下载进度条随后消失');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('网络异常，请稍后重试', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('下载过程中，关闭网络 end');
}

/**
 * 大图-下载: [下载完成后，下载按钮消失]
 * TAG: 440 TID: Multimedia_Gallery_Application_Downloadbutton_009
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_009(dt: Dt) {
  dt.log.i('下载完成后，下载按钮消失 start');
  dt.log.i('STEP 1.图片或视频下载完成，观察下载icon显示');

  await dt.sleep();
  dt.log.i('预期结果1.右上角下载icon消失且页面滑动流畅，无白块，无卡顿，无跳变');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('下载完成后，下载按钮消失 end');
}

/**
 * 大图-大图: [相机进大图]
 * TAG: 459 TID: Multimedia_Gallery_Application_Downloadbutton_010
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_010(dt: Dt) {
  dt.log.i('相机进大图 start');
  dt.log.i('STEP 1.相机进大图查看下载按钮');

  await dt.sleep();
  dt.log.i('预期结果1.当前相机进入大图页面没有下载按钮');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机进大图 end');
}

/**
 * 大图-连拍: [UX字体适配]
 * TAG: 435 TID: Multimedia_Gallery_Application_Downloadbutton_011
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_011(dt: Dt) {
  dt.log.i('UX字体适配 start');
  dt.log.i('STEP 1.进入设置点击字体大小和界面缩放，设置不同字体大小');

  await dt.sleep();
  dt.log.i('STEP 2.返回图库，点击下载按钮，查看进度显示');

  await dt.sleep();
  dt.log.i('预期结果2.下载进度显示正常，不存在位置异常与UX异常情况');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('UX字体适配 end');
}

/**
 * 大图-竖屏: [横竖屏适配]
 * TAG: 455 TID: Multimedia_Gallery_Application_Downloadbutton_012
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_012(dt: Dt) {
  dt.log.i('横竖屏适配 start');
  dt.log.i('STEP 1.设备关掉旋转锁定');

  await dt.sleep();
  dt.log.i('STEP 2.点击下载按钮，进入下载进度页正常');

  await dt.sleep();
  dt.log.i('STEP 3.旋转设备，观察横屏模式下下载进度展示');

  await dt.sleep();
  dt.log.i('预期结果3.横屏模式下载进度显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('横竖屏适配 end');
}

/**
 * 大图-连拍: [悬浮窗适配]
 * TAG: 453 TID: Multimedia_Gallery_Application_Downloadbutton_013
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_013(dt: Dt) {
  dt.log.i('悬浮窗适配 start');
  dt.log.i('STEP 1.进入图库大图页');

  await dt.sleep();
  dt.log.i('STEP 2.图库当前页上滑控制中心，进入悬浮窗模式');

  await dt.sleep();
  dt.log.i('STEP 3.点击下载按钮，观察页面下载进度展示');

  await dt.sleep();
  dt.log.i('预期结果3.悬浮窗下载进度显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('悬浮窗适配 end');
}

/**
 * 大图-连拍: [分屏适配]
 * TAG: 442 TID: Multimedia_Gallery_Application_Downloadbutton_014
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_014(dt: Dt) {
  dt.log.i('分屏适配 start');
  dt.log.i('STEP 1.进入图库大图页，任意打开一个本机应用');

  await dt.sleep();
  dt.log.i('STEP 2.进入分屏模式');

  await dt.sleep();
  dt.log.i('STEP 3.点击下载按钮，观察页面下载进度展示');

  await dt.sleep();
  dt.log.i('预期结果3.分屏模式下页面下载进度显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分屏适配 end');
}

/**
 * 大图-连拍: [多语言适配]
 * TAG: 444 TID: Multimedia_Gallery_Application_Downloadbutton_015
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_015(dt: Dt) {
  dt.log.i('多语言适配 start');
  dt.log.i('STEP 1.进入设置 设置不同种类语言');

  await dt.sleep();
  dt.log.i('STEP 2.进入图库大图，点击下载按钮，观察下载进度页显示');

  await dt.sleep();
  dt.log.i('预期结果2.下载进度页语言显示适配正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多语言适配 end');
}

