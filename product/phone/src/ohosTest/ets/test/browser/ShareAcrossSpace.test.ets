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
    run('Multimedia_Gallery_SR20241231894420_001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [大图界面云端照片视频一碰传分享] TID: Multimedia_Gallery_SR20241231894420_001
      await Multimedia_Gallery_SR20241231894420_001(dt);
    });
    run('Multimedia_Gallery_SR20241231894420_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [大图界面本地照片视频一碰传分享] TID: Multimedia_Gallery_SR20241231894420_002
      await Multimedia_Gallery_SR20241231894420_002(dt);
    });
    run('Multimedia_Gallery_SR20241231894420_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [多选云端照片视频一碰传分享] TID: Multimedia_Gallery_SR20241231894420_003
      await Multimedia_Gallery_SR20241231894420_003(dt);
    });
    run('Multimedia_Gallery_SR20241231894420_004', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [单选云端照片视频一碰传分享] TID: Multimedia_Gallery_SR20241231894420_004
      await Multimedia_Gallery_SR20241231894420_004(dt);
    });
    run('Multimedia_Gallery_SR20241231894420_005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [分屏云端照片视频一碰传分享] TID: Multimedia_Gallery_SR20241231894420_005
      await Multimedia_Gallery_SR20241231894420_005(dt);
    });
    run('Multimedia_Gallery_SR20241231894420_006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [悬浮窗云端照片视频一碰传分享] TID: Multimedia_Gallery_SR20241231894420_006
      await Multimedia_Gallery_SR20241231894420_006(dt);
    });
    run('Multimedia_Gallery_SR20241231894420_007', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [云端照片视频一碰传分享日志] TID: Multimedia_Gallery_SR20241231894420_007
      await Multimedia_Gallery_SR20241231894420_007(dt);
    });
    run('Multimedia_Gallery_SR20241231894420_008', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [大图界面云端照片视频隔空传分享] TID: Multimedia_Gallery_SR20241231894420_008
      await Multimedia_Gallery_SR20241231894420_008(dt);
    });
    run('Multimedia_Gallery_SR20241231894420_009', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [大图界面本地照片视频隔空传分享] TID: Multimedia_Gallery_SR20241231894420_009
      await Multimedia_Gallery_SR20241231894420_009(dt);
    });
    run('Multimedia_Gallery_SR20241231894420_010', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [隐私相册本地云端大图界面照片视频隔空传分享] TID: Multimedia_Gallery_SR20241231894420_010
      await Multimedia_Gallery_SR20241231894420_010(dt);
    });
    run('Multimedia_Gallery_SR20241231894420_011', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [xxxx，不同版本支持本地云端大图界面照片视频隔空传分享] TID: Multimedia_Gallery_SR20241231894420_011
      await Multimedia_Gallery_SR20241231894420_011(dt);
    });
    run('Multimedia_Gallery_SR20241231894420_012', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [关怀模式、无障碍模式、深色模式、横屏本地云端大图界面照片视频隔空传分享] TID: Multimedia_Gallery_SR20241231894420_012
      await Multimedia_Gallery_SR20241231894420_012(dt);
    });
    run('Multimedia_Gallery_SR20241231894420_013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [多用户本地云端照片视频隔空传分享] TID: Multimedia_Gallery_SR20241231894420_013
      await Multimedia_Gallery_SR20241231894420_013(dt);
    });
    run('Multimedia_Gallery_SR20241231894420_014', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [多语言本地云端照片视频隔空传分享] TID: Multimedia_Gallery_SR20241231894420_014
      await Multimedia_Gallery_SR20241231894420_014(dt);
    });
    run('Multimedia_Gallery_SR20241231894420_015', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [分屏云端照片视频隔空传分享] TID: Multimedia_Gallery_SR20241231894420_015
      await Multimedia_Gallery_SR20241231894420_015(dt);
    });
    run('Multimedia_Gallery_SR20241231894420_016', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [悬浮窗云端照片视频隔空传分享] TID: Multimedia_Gallery_SR20241231894420_016
      await Multimedia_Gallery_SR20241231894420_016(dt);
    });
    run('Multimedia_Gallery_SR20241231894420_017', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [照片视频隔空传分享日志] TID: Multimedia_Gallery_SR20241231894420_017
      await Multimedia_Gallery_SR20241231894420_017(dt);
    });
    run('Multimedia_Gallery_SR20241231894420_018', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [一碰传分享上限为400] TID: Multimedia_Gallery_SR20241231894420_018
      await Multimedia_Gallery_SR20241231894420_018(dt);
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
 * 大图-视频: [大图界面云端照片视频一碰传分享]
 * TAG: 479 TID: Multimedia_Gallery_SR20241231894420_001
 * 前置条件
 * 1、图库存在云端照片视频
 */
async function Multimedia_Gallery_SR20241231894420_001(dt: Dt) {
  dt.log.i('大图界面云端照片视频一碰传分享 start');
  dt.log.i('STEP 1、选择云端的照片、视频，进入大图浏览；');

  await dt.sleep();
  dt.log.i('STEP 2、两台手机碰一碰；');

  await dt.sleep();
  dt.log.i('预期结果2、有一碰传的动效，进入上划分享界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、上划分享的界面');

  await dt.sleep();
  dt.log.i('预期结果3、上划分享，自动进入下载界面，云端的数据下载完成之后自动分享完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图界面云端照片视频一碰传分享 end');
}

/**
 * 大图-视频: [大图界面本地照片视频一碰传分享]
 * TAG: 474 TID: Multimedia_Gallery_SR20241231894420_002
 * 前置条件
 * 1、图库存在云端照片视频
 */
async function Multimedia_Gallery_SR20241231894420_002(dt: Dt) {
  dt.log.i('大图界面本地照片视频一碰传分享 start');
  dt.log.i('STEP 1、选择云端的照片、视频，进入大图浏览；');

  await dt.sleep();
  dt.log.i('STEP 2、两台手机碰一碰；');

  await dt.sleep();
  dt.log.i('预期结果2、有一碰传的动效，进入上划分享界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、上划分享的界面');

  await dt.sleep();
  dt.log.i('预期结果3、上划分享，自动进入下载界面，云端的数据下载完成之后自动分享完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图界面本地照片视频一碰传分享 end');
}

/**
 * 大图-视频: [多选云端照片视频一碰传分享]
 * TAG: 475 TID: Multimedia_Gallery_SR20241231894420_003
 * 前置条件
 * 2、图库存在云端照片视频
 */
async function Multimedia_Gallery_SR20241231894420_003(dt: Dt) {
  dt.log.i('多选云端照片视频一碰传分享 start');
  dt.log.i('STEP 1、多选云端的照片、视频；');

  await dt.sleep();
  dt.log.i('STEP 2、两台手机碰一碰；');

  await dt.sleep();
  dt.log.i('预期结果2、有一碰传的动效，进入上划分享界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、上划分享的界面');

  await dt.sleep();
  dt.log.i('预期结果3、上划分享，自动进入下载界面，云端的数据下载完成之后自动分享完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多选云端照片视频一碰传分享 end');
}

/**
 * 大图-视频: [单选云端照片视频一碰传分享]
 * TAG: 480 TID: Multimedia_Gallery_SR20241231894420_004
 * 前置条件
 * 3、图库存在云端照片视频
 */
async function Multimedia_Gallery_SR20241231894420_004(dt: Dt) {
  dt.log.i('单选云端照片视频一碰传分享 start');
  dt.log.i('STEP 1、单选云端照片或视频；');

  await dt.sleep();
  dt.log.i('STEP 2、两台手机碰一碰；');

  await dt.sleep();
  dt.log.i('预期结果2、有一碰传的动效，进入上划分享界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、上划分享的界面');

  await dt.sleep();
  dt.log.i('预期结果3、上划分享，自动进入下载界面，云端的数据下载完成之后自动分享完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('单选云端照片视频一碰传分享 end');
}

/**
 * 大图-视频: [分屏云端照片视频一碰传分享]
 * TAG: 476 TID: Multimedia_Gallery_SR20241231894420_005
 * 前置条件
 * 3、图库存在云端照片视频
 */
async function Multimedia_Gallery_SR20241231894420_005(dt: Dt) {
  dt.log.i('分屏云端照片视频一碰传分享 start');
  dt.log.i('STEP 1、手机进入分屏模式');

  await dt.sleep();
  dt.log.i('STEP 2、选云端照片或视频；');

  await dt.sleep();
  dt.log.i('STEP 3、两台手机碰一碰；');

  await dt.sleep();
  dt.log.i('预期结果3、有一碰传的动效，进入上划分享界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、上划分享的界面');

  await dt.sleep();
  dt.log.i('预期结果4、上划分享，自动进入下载界面，云端的数据下载完成之后自动分享完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分屏云端照片视频一碰传分享 end');
}

/**
 * 大图-视频: [悬浮窗云端照片视频一碰传分享]
 * TAG: 478 TID: Multimedia_Gallery_SR20241231894420_006
 * 前置条件
 * 3、图库存在云端照片视频
 */
async function Multimedia_Gallery_SR20241231894420_006(dt: Dt) {
  dt.log.i('悬浮窗云端照片视频一碰传分享 start');
  dt.log.i('STEP 1、手机进入悬浮窗模式');

  await dt.sleep();
  dt.log.i('STEP 2、选云端照片或视频；');

  await dt.sleep();
  dt.log.i('STEP 3、两台手机碰一碰；');

  await dt.sleep();
  dt.log.i('预期结果3、有一碰传的动效，进入上划分享界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、上划分享的界面');

  await dt.sleep();
  dt.log.i('预期结果4、上划分享，自动进入下载界面，云端的数据下载完成之后自动分享完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('悬浮窗云端照片视频一碰传分享 end');
}

/**
 * 大图-视频: [云端照片视频一碰传分享日志]
 * TAG: 477 TID: Multimedia_Gallery_SR20241231894420_007
 * 前置条件
 * 5、图库存在云端照片视频
 */
async function Multimedia_Gallery_SR20241231894420_007(dt: Dt) {
  dt.log.i('云端照片视频一碰传分享日志 start');
  dt.log.i('STEP 1、单选云端照片或视频；');

  await dt.sleep();
  dt.log.i('STEP 2、两台手机碰一碰；');

  await dt.sleep();
  dt.log.i('STEP 3、上划分享的界面');

  await dt.sleep();
  dt.log.i('STEP 4、查看日志');

  await dt.sleep();
  dt.log.i('预期结果4、a) 下载失败日志关键字：” send DOWNLOAD_FAIL notifyInfo done”  b) 下载成功日志关键字：“send DOWNLOAD_SUCC notifyInfo done”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText(' send DOWNLOAD_FAIL notifyInfo done', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云端照片视频一碰传分享日志 end');
}

/**
 * 大图-视频: [大图界面云端照片视频隔空传分享]
 * TAG: 473 TID: Multimedia_Gallery_SR20241231894420_008
 * 前置条件
 * 1、图库存在云端照片视频
 */
async function Multimedia_Gallery_SR20241231894420_008(dt: Dt) {
  dt.log.i('大图界面云端照片视频隔空传分享 start');
  dt.log.i('STEP 1、选择云端的照片、视频，进入大图浏览；');

  await dt.sleep();
  dt.log.i('STEP 2、发送手机做手掌握拳手势；');

  await dt.sleep();
  dt.log.i('预期结果2、发送端可以识别握拳手势，有隔空传的动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、接收手机做手掌松拳张开手势');

  await dt.sleep();
  dt.log.i('预期结果3、接收端可以识别松拳手势，弹出文件接收弹窗，发送端文件下载成功后自动分享完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图界面云端照片视频隔空传分享 end');
}

/**
 * 大图-视频: [大图界面本地照片视频隔空传分享]
 * TAG: 463 TID: Multimedia_Gallery_SR20241231894420_009
 * 前置条件
 * 1、图库存在云端照片视频
 */
async function Multimedia_Gallery_SR20241231894420_009(dt: Dt) {
  dt.log.i('大图界面本地照片视频隔空传分享 start');
  dt.log.i('STEP 1、选择本地的照片、视频，进入大图浏览；');

  await dt.sleep();
  dt.log.i('STEP 2、发送手机做手掌握拳手势；');

  await dt.sleep();
  dt.log.i('预期结果2、发送端可以识别握拳手势，有隔空传的动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、接收手机做手掌松拳张开手势');

  await dt.sleep();
  dt.log.i('预期结果3、接收端可以识别松拳手势，弹出文件接收弹窗，自动分享完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图界面本地照片视频隔空传分享 end');
}

/**
 * 大图-视频: [隐私相册本地云端大图界面照片视频隔空传分享]
 * TAG: 467 TID: Multimedia_Gallery_SR20241231894420_010
 * 前置条件
 * 1、图库存在云端照片视频
 */
async function Multimedia_Gallery_SR20241231894420_010(dt: Dt) {
  dt.log.i('隐私相册本地云端大图界面照片视频隔空传分享 start');
  dt.log.i('STEP 1、选择隐私相册本地云端的照片、视频，进入大图浏览；');

  await dt.sleep();
  dt.log.i('STEP 2、发送手机做手掌握拳手势；');

  await dt.sleep();
  dt.log.i('预期结果2、发送端可以识别握拳手势，有隔空传的动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、接收手机做手掌松拳张开手势');

  await dt.sleep();
  dt.log.i('预期结果3、接收端可以识别松拳手势，弹出文件接收弹窗');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果4、只有动效，实际结果分享失败，隐私相册不支持隔空传送');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私相册本地云端大图界面照片视频隔空传分享 end');
}

/**
 * 大图-视频: [xxx，不同版本支持本地云端大图界面照片视频隔空传分享]
 * TAG: 469 TID: Multimedia_Gallery_SR20241231894420_011
 * 前置条件
 * 1、图库存在云端照片视频
 */
async function Multimedia_Gallery_SR20241231894420_011(dt: Dt) {
  dt.log.i('xxx，不同版本支持本地云端大图界面照片视频隔空传分享 start');
  dt.log.i('STEP 1、选择本地云端的照片、视频，进入大图浏览；');

  await dt.sleep();
  dt.log.i('预期结果1、隔空传支持xxx和不同版本之间分享');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、发送手机做手掌握拳手势；');

  await dt.sleep();
  dt.log.i('预期结果2、发送端可以识别握拳手势，有隔空传的动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、接收手机做手掌松拳张开手势');

  await dt.sleep();
  dt.log.i('预期结果3、接收端可以识别松拳手势，弹出文件接收弹窗，发送端文件下载成功后自动分享完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxx，不同版本支持本地云端大图界面照片视频隔空传分享 end');
}

/**
 * 大图-视频: [关怀模式、无障碍模式、深色模式、横屏本地云端大图界面照片视频隔空传分享]
 * TAG: 471 TID: Multimedia_Gallery_SR20241231894420_012
 * 前置条件
 * 1、图库存在云端照片视频
 */
async function Multimedia_Gallery_SR20241231894420_012(dt: Dt) {
  dt.log.i('关怀模式、无障碍模式、深色模式、横屏本地云端大图界面照片视频隔空传分享 start');
  dt.log.i('STEP 1、手机进入关怀模式、无障碍模式、深色模式、横屏；');

  await dt.sleep();
  dt.log.i('预期结果1、隔空传过程中关怀模式、无障碍模式、深色模式、横屏显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、选本地云端照片或视频；');

  await dt.sleep();
  dt.log.i('预期结果2、发送端可以识别握拳手势，有隔空传的动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、发送手机做手掌握拳手势；');

  await dt.sleep();
  dt.log.i('预期结果3、接收端可以识别松拳手势，弹出文件接收弹窗，发送端文件下载成功后自动分享完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、接收手机做手掌松拳张开手势');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('关怀模式、无障碍模式、深色模式、横屏本地云端大图界面照片视频隔空传分享 end');
}

/**
 * 大图-视频: [多用户本地云端照片视频隔空传分享]
 * TAG: 470 TID: Multimedia_Gallery_SR20241231894420_013
 * 前置条件
 * 1、图库存在本地照片视频
 */
async function Multimedia_Gallery_SR20241231894420_013(dt: Dt) {
  dt.log.i('多用户本地云端照片视频隔空传分享 start');
  dt.log.i('STEP 1、手机进入隐私空间；');

  await dt.sleep();
  dt.log.i('预期结果1、隐私空间支持隔空传');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、选本地云端照片或视频；');

  await dt.sleep();
  dt.log.i('预期结果2、发送端可以识别握拳手势，有隔空传的动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、发送手机做手掌握拳手势；');

  await dt.sleep();
  dt.log.i('预期结果3、接收端可以识别松拳手势，弹出文件接收弹窗，发送端文件下载成功后自动分享完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、接收手机做手掌松拳张开手势');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多用户本地云端照片视频隔空传分享 end');
}

/**
 * 大图-视频: [多语言本地云端照片视频隔空传分享]
 * TAG: 464 TID: Multimedia_Gallery_SR20241231894420_014
 * 前置条件
 * 1、图库存在云端照片视频
 */
async function Multimedia_Gallery_SR20241231894420_014(dt: Dt) {
  dt.log.i('多语言本地云端照片视频隔空传分享 start');
  dt.log.i('STEP 1、手机切换语言；');

  await dt.sleep();
  dt.log.i('预期结果1、隔空传过程中切换语言显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、选云端照片或视频；');

  await dt.sleep();
  dt.log.i('预期结果2、发送端可以识别握拳手势，有隔空传的动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、发送手机做手掌握拳手势；');

  await dt.sleep();
  dt.log.i('预期结果3、接收端可以识别松拳手势，弹出文件接收弹窗，发送端文件下载成功后自动分享完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、接收手机做手掌松拳张开手势');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多语言本地云端照片视频隔空传分享 end');
}

/**
 * 大图-视频: [分屏云端照片视频隔空传分享]
 * TAG: 466 TID: Multimedia_Gallery_SR20241231894420_015
 * 前置条件
 * 3、图库存在云端照片视频
 */
async function Multimedia_Gallery_SR20241231894420_015(dt: Dt) {
  dt.log.i('分屏云端照片视频隔空传分享 start');
  dt.log.i('STEP 1、手机进入分屏模式');

  await dt.sleep();
  dt.log.i('预期结果1、分屏支持隔空传');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、选云端照片或视频；');

  await dt.sleep();
  dt.log.i('预期结果2、发送端可以识别握拳手势，有隔空传的动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、发送手机做手掌握拳手势；');

  await dt.sleep();
  dt.log.i('预期结果3、接收端可以识别松拳手势，弹出文件接收弹窗，发送端文件下载成功后自动分享完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、接收手机做手掌松拳张开手势');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分屏云端照片视频隔空传分享 end');
}

/**
 * 大图-视频: [悬浮窗云端照片视频隔空传分享]
 * TAG: 468 TID: Multimedia_Gallery_SR20241231894420_016
 * 前置条件
 * 3、图库存在云端照片视频
 */
async function Multimedia_Gallery_SR20241231894420_016(dt: Dt) {
  dt.log.i('悬浮窗云端照片视频隔空传分享 start');
  dt.log.i('STEP 1、手机进入悬浮窗模式');

  await dt.sleep();
  dt.log.i('预期结果1、悬浮窗支持隔空传');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、选云端照片或视频；');

  await dt.sleep();
  dt.log.i('预期结果2、发送端可以识别握拳手势，有隔空传的动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、发送手机做手掌握拳手势；');

  await dt.sleep();
  dt.log.i('预期结果3、接收端可以识别松拳手势，弹出文件接收弹窗，发送端文件下载成功后自动分享完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、接收手机做手掌松拳张开手势');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('悬浮窗云端照片视频隔空传分享 end');
}

/**
 * 大图-视频: [照片视频隔空传分享日志]
 * TAG: 472 TID: Multimedia_Gallery_SR20241231894420_017
 * 前置条件
 * 5、图库存在云端照片视频
 */
async function Multimedia_Gallery_SR20241231894420_017(dt: Dt) {
  dt.log.i('照片视频隔空传分享日志 start');
  dt.log.i('STEP 1、单选云端照片或视频；');

  await dt.sleep();
  dt.log.i('STEP 2、两台手机碰一碰；');

  await dt.sleep();
  dt.log.i('STEP 3、发送手机做手掌握拳手势；');

  await dt.sleep();
  dt.log.i('STEP 4、接收手机做手掌松拳张开手势');

  await dt.sleep();
  dt.log.i('预期结果4、a) 下载失败日志关键字：” send DOWNLOAD_FAIL notifyInfo done”  b) 下载成功日志关键字：“send DOWNLOAD_SUCC notifyInfo done”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText(' send DOWNLOAD_FAIL notifyInfo done', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片视频隔空传分享日志 end');
}

/**
 * 大图-视频: [一碰传分享上限为400]
 * TAG: 465 TID: Multimedia_Gallery_SR20241231894420_018
 * 前置条件
 * 1、图库存在云端照片视频
 */
async function Multimedia_Gallery_SR20241231894420_018(dt: Dt) {
  dt.log.i('一碰传分享上限为400 start');
  dt.log.i('STEP 1、多选400+图片或视频；');

  await dt.sleep();
  dt.log.i('STEP 2、两台手机碰一碰；');

  await dt.sleep();
  dt.log.i('STEP 3、上划分享的界面；');

  await dt.sleep();
  dt.log.i('预期结果3、有一碰传的动效，不会进入分享界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、大于400项文件分享失败，有相关提示');

  await dt.sleep();
  dt.log.i('预期结果4、直接有相关提示，无法分享大于400项文件');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('一碰传分享上限为400 end');
}
