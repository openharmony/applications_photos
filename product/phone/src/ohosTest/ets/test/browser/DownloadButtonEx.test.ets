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
    run('Multimedia_Gallery_Application_Downloadbutton_016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [连拍照片下载] TID: Multimedia_Gallery_Application_Downloadbutton_016
      await Multimedia_Gallery_Application_Downloadbutton_016(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_017', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片下载] TID: Multimedia_Gallery_Application_Downloadbutton_017
      await Multimedia_Gallery_Application_Downloadbutton_017(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_018', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-壁纸用例: [设为动态壁纸] TID: Multimedia_Gallery_Application_Downloadbutton_018
      await Multimedia_Gallery_Application_Downloadbutton_018(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_019', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [将动图导出为视频] TID: Multimedia_Gallery_Application_Downloadbutton_019
      await Multimedia_Gallery_Application_Downloadbutton_019(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_020', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [收藏图片后对比] TID: Multimedia_Gallery_Application_Downloadbutton_020
      await Multimedia_Gallery_Application_Downloadbutton_020(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_021', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [未下载图片点击收藏按钮，下载按钮无异常显示] TID: Multimedia_Gallery_Application_Downloadbutton_021
      await Multimedia_Gallery_Application_Downloadbutton_021(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_022', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [双指进入图库大图，查看是否自动进行图片原图下载] TID: Multimedia_Gallery_Application_Downloadbutton_022
      await Multimedia_Gallery_Application_Downloadbutton_022(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_023', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [连续向左或向右滑动图片，检查下载按钮] TID: Multimedia_Gallery_Application_Downloadbutton_023
      await Multimedia_Gallery_Application_Downloadbutton_023(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_024', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [大图页，进行分享/编辑/收藏/删除/移动/隐藏操作] TID: Multimedia_Gallery_Application_Downloadbutton_024
      await Multimedia_Gallery_Application_Downloadbutton_024(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_025', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [大图界面断网，点击下载按钮] TID: Multimedia_Gallery_Application_Downloadbutton_025
      await Multimedia_Gallery_Application_Downloadbutton_025(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_026', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [切换为深色模式，检查下载按钮] TID: Multimedia_Gallery_Application_Downloadbutton_026
      await Multimedia_Gallery_Application_Downloadbutton_026(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_027', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [时刻界面进入大图，检查下载按钮] TID: Multimedia_Gallery_Application_Downloadbutton_027
      await Multimedia_Gallery_Application_Downloadbutton_027(dt);
    });
    run('Multimedia_Gallery_Application_Downloadbutton_028', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [时刻界面进入大图，进行分享/编辑/收藏/删除/移动/隐藏操作] TID: Multimedia_Gallery_Application_Downloadbutton_028
      await Multimedia_Gallery_Application_Downloadbutton_028(dt);
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
 * 大图-连拍: [连拍照片下载]
 * TAG: 462 TID: Multimedia_Gallery_Application_Downloadbutton_016
 * 前置条件
 * 1、备用机拍摄连拍照片上传至云空间
 2、测试机登录账号，开启云空间
 */
async function Multimedia_Gallery_Application_Downloadbutton_016(dt: Dt) {
  dt.log.i('连拍照片下载 start');
  dt.log.i('STEP 1、进入连拍云图浏览界面');

  await dt.sleep();
  dt.log.i('STEP 2、点击连拍照片icon');

  await dt.sleep();
  dt.log.i('预期结果2.toast提示“当前图片未下载，请下载后重试”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('当前图片未下载，请下载后重试'));
  dt.log.i('STEP 3、点击下载按钮');

  await dt.sleep();
  dt.log.i('预期结果3.出现下载进度条，连拍照片成功下载');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('连拍照片下载 end');
}

/**
 * 大图-动态照片: [动态照片下载]
 * TAG: 437 TID: Multimedia_Gallery_Application_Downloadbutton_017
 * 前置条件
 * 1、备用机拍摄动态照片上传至云空间
 2、测试机登录账号，开启云空间（覆盖普通动态照片、带水印动态照片、云增强动态照片、编辑后的动态照片，各比例动态照片等；可多场景叠加）
 */
async function Multimedia_Gallery_Application_Downloadbutton_017(dt: Dt) {
  dt.log.i('动态照片下载 start');
  dt.log.i('STEP 1、进入云端动态照片大图浏览界面');

  await dt.sleep();
  dt.log.i('STEP 2、点击动态照片图标');

  await dt.sleep();
  dt.log.i('预期结果2.toast提示“当前图片未下载，请下载后重试”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('当前图片未下载，请下载后重试'));
  dt.log.i('STEP 3、点击下载按钮');

  await dt.sleep();
  dt.log.i('预期结果3.出现下载进度条，动态照片成功下载');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片下载 end');
}

/**
 * 大图-壁纸: [设为动态壁纸]
 * TAG: 460 TID: Multimedia_Gallery_Application_Downloadbutton_018
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖普通动态照片、带水印动态照片、云增强动态照片、编辑后的动态照片，各比例动态照片等；可多场景叠加）
 */
async function Multimedia_Gallery_Application_Downloadbutton_018(dt: Dt) {
  dt.log.i('设为动态壁纸 start');
  dt.log.i('STEP 1.进入云图浏览界面');

  await dt.sleep();
  dt.log.i('STEP 2.点击更多将未下载的云图（动图，普通图片）设为壁纸');

  await dt.sleep();
  dt.log.i('预期结果2.出现“当前图片未下载，请下载后重试”提示语');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('当前图片未下载，请下载后重试'));
  dt.log.i('STEP 3.下载后重新进行设为壁纸操作');

  await dt.sleep();
  dt.log.i('预期结果3.重新进入，进入到设置页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.进入“显示 虚化 动态 锁屏” 调节icon');

  await dt.sleep();
  dt.log.i('预期结果4.调节icon正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.点击“应用”');

  await dt.sleep();
  dt.log.i('预期结果5.点击“应用”应用壁纸正常  观察设置为动态锁屏模式下 锁屏设备后 动图动效正常');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('应用', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设为动态壁纸 end');
}

/**
 * 大图-视频: [将动图导出为视频]
 * TAG: 447 TID: Multimedia_Gallery_Application_Downloadbutton_019
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖普通动态照片、带水印动态照片、云增强动态照片、编辑后的动态照片，各比例动态照片等；可多场景叠加）
 */
async function Multimedia_Gallery_Application_Downloadbutton_019(dt: Dt) {
  dt.log.i('将动图导出为视频 start');
  dt.log.i('STEP 1.进入云图浏览界面');

  await dt.sleep();
  dt.log.i('STEP 2.点击更多将未下载的云图（动图）导出为视频');

  await dt.sleep();
  dt.log.i('预期结果2.出现“当前图片未下载，请下载后重试”提示语');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('当前图片未下载，请下载后重试'));
  dt.log.i('STEP 3.下载后重新进行导出为视频操作');

  await dt.sleep();
  dt.log.i('预期结果3、视频导出成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('将动图导出为视频 end');
}

/**
 * 大图-收藏: [收藏图片后对比]
 * TAG: 451 TID: Multimedia_Gallery_Application_Downloadbutton_020
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_020(dt: Dt) {
  dt.log.i('收藏图片后对比 start');
  dt.log.i('STEP 1.点击收藏相册中的云图下载按钮，下载图片');

  await dt.sleep();
  dt.log.i('预期结果1.下载进度条正常显示，下载完成下载按钮消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.返回图片页查看与本张相同照片，观察下载按钮是否正常消失');

  await dt.sleep();
  dt.log.i('预期结果2.回到图片页查看相同图片，下载按钮消失');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('收藏图片后对比 end');
}

/**
 * 大图-下载: [未下载图片点击收藏按钮，下载按钮无异常显示]
 * TAG: 457 TID: Multimedia_Gallery_Application_Downloadbutton_021
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_021(dt: Dt) {
  dt.log.i('未下载图片点击收藏按钮，下载按钮无异常显示 start');
  dt.log.i('STEP 1.未点击下载按钮前，点击编辑、收藏等按钮');

  await dt.sleep();
  dt.log.i('预期结果1.编辑收藏按钮点击正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.观察下载按钮是否有异常反应（闪动，图标UX显示异常）');

  await dt.sleep();
  dt.log.i('预期结果2.下载按钮无异常反应（闪动，图标UX显示异常）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('未下载图片点击收藏按钮，下载按钮无异常显示 end');
}

/**
 * 大图-下载: [双指进入图库大图，查看是否自动进行图片原图下载]
 * TAG: 445 TID: Multimedia_Gallery_Application_Downloadbutton_022
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_022(dt: Dt) {
  dt.log.i('双指进入图库大图，查看是否自动进行图片原图下载 start');
  dt.log.i('STEP 1、进入云图浏览界面');

  await dt.sleep();
  dt.log.i('STEP 2、双击/双指放大图片');

  await dt.sleep();
  dt.log.i('预期结果2、不会触发云图自动下载');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('双指进入图库大图，查看是否自动进行图片原图下载 end');
}

/**
 * 大图-下载: [连续向左或向右滑动图片，检查下载按钮]
 * TAG: 461 TID: Multimedia_Gallery_Application_Downloadbutton_023
 * 前置条件
 * 1、打开设备云空间，云图库开启
 2、设备中存在本地照片
 */
async function Multimedia_Gallery_Application_Downloadbutton_023(dt: Dt) {
  dt.log.i('连续向左或向右滑动图片，检查下载按钮 start');
  dt.log.i('STEP 1、点击进入图库大图浏览页');

  await dt.sleep();
  dt.log.i('STEP 2、连续向左或向右滑动图片，查看右上角下载按钮显示');

  await dt.sleep();
  dt.log.i('预期结果2.1、本地照片，右上角无下载按钮显示2.2、云图，右上角显示下载按钮');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('连续向左或向右滑动图片，检查下载按钮 end');
}

/**
 * 大图-收藏: [大图页，进行分享/编辑/收藏/删除/移动/隐藏操作]
 * TAG: 449 TID: Multimedia_Gallery_Application_Downloadbutton_024
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_024(dt: Dt) {
  dt.log.i('大图页，进行分享/编辑/收藏/删除/移动/隐藏操作 start');
  dt.log.i('STEP 1、点击云图进入大图浏览页');

  await dt.sleep();
  dt.log.i('STEP 2、进行分享/编辑/收藏/删除/移动/隐藏操作');

  await dt.sleep();
  dt.log.i('STEP 3、返回大图界面，查看右上角下载按钮刷新情况');

  await dt.sleep();
  dt.log.i('预期结果3.1、进行分享操作，云图下载完成后，大图界面不显示下载按钮3.2、进行编辑操作，云图下载完成后，大图界面不显示下载按钮3.3、进行收藏操作，大图界面下载按钮显示正常，收藏相册界面下载按钮显示正常3.4、进行删除操作，最近删除相册大图界面下载按不显示3.5、进行移动操作，相册大图界面下载按钮显示正常3.6、进行隐藏操作，隐藏相册大图界面下载按钮显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图页，进行分享/编辑/收藏/删除/移动/隐藏操作 end');
}

/**
 * 大图-下载: [大图界面断网，点击下载按钮]
 * TAG: 448 TID: Multimedia_Gallery_Application_Downloadbutton_025
 * 前置条件
 * 打开设备云空间，云图库开启
 （覆盖照片、连拍照片、动态照片、视频）
 */
async function Multimedia_Gallery_Application_Downloadbutton_025(dt: Dt) {
  dt.log.i('大图界面断网，点击下载按钮 start');
  dt.log.i('STEP 1、点击云图进入大图浏览页');

  await dt.sleep();
  dt.log.i('STEP 2、关闭网络，点击下载按钮');

  await dt.sleep();
  dt.log.i('预期结果2、toast提示”无网络可用”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('无网络可用'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图界面断网，点击下载按钮 end');
}

/**
 * 大图-下载: [切换为深色模式，检查下载按钮]
 * TAG: 436 TID: Multimedia_Gallery_Application_Downloadbutton_026
 * 前置条件
 * 打开设备云空间，云图库开启

 */
async function Multimedia_Gallery_Application_Downloadbutton_026(dt: Dt) {
  dt.log.i('切换为深色模式，检查下载按钮 start');
  dt.log.i('STEP 1、点击云图进入大图浏览页');

  await dt.sleep();
  dt.log.i('STEP 2、下拉控制中心，切换为深色模式');

  await dt.sleep();
  dt.log.i('预期结果2、深色模式下，下载按钮显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('切换为深色模式，检查下载按钮 end');
}

/**
 * 大图-进入大图: [时刻界面进入大图，检查下载按钮]
 * TAG: 452 TID: Multimedia_Gallery_Application_Downloadbutton_027
 * 前置条件
 * 1、打开设备云空间，云图库开启
 2、云图和本地图片均生成时刻
 */
async function Multimedia_Gallery_Application_Downloadbutton_027(dt: Dt) {
  dt.log.i('时刻界面进入大图，检查下载按钮 start');
  dt.log.i('STEP 1、点击进入相册_时刻页面');

  await dt.sleep();
  dt.log.i('STEP 2、点击进入时刻，上划界面');

  await dt.sleep();
  dt.log.i('STEP 3、点击图片进入大图，查看右上角下载按钮');

  await dt.sleep();
  dt.log.i('预期结果3.1、本地照片生成的时刻无下载按钮3.2、云图生成的时刻照片，右上角显示下载按钮');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻界面进入大图，检查下载按钮 end');
}

/**
 * 大图-进入大图: [时刻界面进入大图，进行分享/编辑/收藏/删除/移动/隐藏操作]
 * TAG: 454 TID: Multimedia_Gallery_Application_Downloadbutton_028
 * 前置条件
 * 1、打开设备云空间，云图库开启
 2、时刻页有时刻生成
 */
async function Multimedia_Gallery_Application_Downloadbutton_028(dt: Dt) {
  dt.log.i('时刻界面进入大图，进行分享/编辑/收藏/删除/移动/隐藏操作 start');
  dt.log.i('STEP 1、点击进入相册_时刻页面');

  await dt.sleep();
  dt.log.i('STEP 2、点击进入时刻，上划界面');

  await dt.sleep();
  dt.log.i('STEP 3、点击图片进入大图');

  await dt.sleep();
  dt.log.i('STEP 4、进行分享/编辑/收藏/删除/移动/隐藏操作');

  await dt.sleep();
  dt.log.i('STEP 5、返回大图界面，查看右上角下载按钮刷新情况');

  await dt.sleep();
  dt.log.i('预期结果5.1、进行分享操作，云图下载完成后，大图界面不显示下载按钮5.2、进行编辑操作，云图下载完成后，大图界面不显示下载按钮5.3、进行收藏操作，大图界面下载按钮显示正常，收藏相册界面下载按钮显示正常5.4、进行删除操作，最近删除相册大图界面下载按钮不显示5.5、进行移动操作，相册大图界面下载按钮显示正常5.6、进行隐藏操作，隐藏相册大图界面下载按钮显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻界面进入大图，进行分享/编辑/收藏/删除/移动/隐藏操作 end');
}
