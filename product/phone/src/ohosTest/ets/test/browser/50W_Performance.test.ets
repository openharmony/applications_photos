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

export default function Performance50WTest(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('Performance50WTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllPerformance50W').init();
      dt.log.i('beforeAll Performance50W start');
      dt.log.i('beforeAll Performance50W finish');
    });
    /**
     * 打开大图
     */
    run('beforePerformance50W', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    run('Multimedia_Photos_50W_Performance_Case001', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  性能-端云用例: [冷启动进入照片页] TID: Multimedia_Photos_50W_Performance_Case001
      await Multimedia_Photos_50W_Performance_Case001(dt);
    });
    run('Multimedia_Photos_50W_Performance_Case002', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  性能-端云用例: [保活启动进入照片页] TID: Multimedia_Photos_50W_Performance_Case002
      await Multimedia_Photos_50W_Performance_Case002(dt);
    });
    run('Multimedia_Photos_50W_Performance_Case003', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  性能-端云用例: [热启动进入图库任意界面] TID: Multimedia_Photos_50W_Performance_Case003
      await Multimedia_Photos_50W_Performance_Case003(dt);
    });
    run('Multimedia_Photos_50W_Performance_Case004', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  性能-端云用例: [冷启动进入相册页] TID: Multimedia_Photos_50W_Performance_Case004
      await Multimedia_Photos_50W_Performance_Case004(dt);
    });
    run('Multimedia_Photos_50W_Performance_Case005', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  性能-端云用例: [图库在前台，截屏端端时延] TID: Multimedia_Photos_50W_Performance_Case005
      await Multimedia_Photos_50W_Performance_Case005(dt);
    });
    run('Multimedia_Photos_50W_Performance_Case006', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  性能-端云用例: [图库在前台，录屏端端时延] TID: Multimedia_Photos_50W_Performance_Case006
      await Multimedia_Photos_50W_Performance_Case006(dt);
    });
    run('Multimedia_Photos_50W_Performance_Case007', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  性能-端云用例: [图库在后台录屏，截屏] TID: Multimedia_Photos_50W_Performance_Case007
      await Multimedia_Photos_50W_Performance_Case007(dt);
    });
    run('Multimedia_Photos_50W_Performance_Case008', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  性能-大图用例: [宫格缩略图进大图] TID: Multimedia_Photos_50W_Performance_Case008
      await Multimedia_Photos_50W_Performance_Case008(dt);
    });
    run('Multimedia_Photos_50W_Performance_Case009', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  性能-滑动用例: [大图左右滑动浏览] TID: Multimedia_Photos_50W_Performance_Case009
      await Multimedia_Photos_50W_Performance_Case009(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachPerformance50W').init();
      dt.log.i('afterEach Performance50W start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach Performance50W finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllPerformance50W').init();
      dt.log.i('afterAll Performance50W start');
      await Exit.browser();
      dt.log.i('afterAll Performance50W finish');
    });
  });
}

/**
 * 性能-端云: [冷启动进入照片页]
 * GROUP: 性能 MODULE: 端云TID: Multimedia_Photos_50W_Performance_Case001
 * 前置条件
 * 手机登录50W数据的账号，正常的开启端云下行同步
 */
async function Multimedia_Photos_50W_Performance_Case001(dt: Dt) {
  dt.log.i('冷启动进入照片页 start');
  dt.log.i('STEP 1、点击图库手抬起来作为起始帧');

  await dt.sleep();
  dt.log.i('STEP 2、图库界面完全展开无白屏作为结束帧');

  await dt.sleep();
  dt.log.i('STEP 3、计算结束帧的时间减去起始帧的时间');

  await dt.sleep();
  dt.log.i('预期结果3、性能数据优于xxx（xxx冷启动进入照片页大约0.5S，相册页大约2S）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('冷启动进入照片页 end');
}

/**
 * 性能-端云: [保活启动进入照片页]
 * GROUP: 性能 MODULE: 端云TID: Multimedia_Photos_50W_Performance_Case002
 * 前置条件
 * 手机登录50W数据的账号，正常的开启端云下行同步
 确保图库处于保活周期内（强杀图库10秒内再次点击） ，再次点击图库走保活
 */
async function Multimedia_Photos_50W_Performance_Case002(dt: Dt) {
  dt.log.i('保活启动进入照片页 start');
  dt.log.i('STEP 1、点击图库手抬起来作为起始帧');

  await dt.sleep();
  dt.log.i('STEP 2、图库界面完全展开无白屏作为结束帧');

  await dt.sleep();
  dt.log.i('STEP 3、计算结束帧的时间减去起始帧的时间');

  await dt.sleep();
  dt.log.i('预期结果3、性能数据优于xxx（xxx冷启动进入照片页大约0.5S，相册页大约2S）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('保活启动进入照片页 end');
}

/**
 * 性能-端云: [热启动进入图库任意界面]
 * GROUP: 性能 MODULE: 端云TID: Multimedia_Photos_50W_Performance_Case003
 * 前置条件
 * 手机登录50W数据的账号，正常的开启端云下行同步
 打开图库后退后台 ，再次点击图库走热启动
 */
async function Multimedia_Photos_50W_Performance_Case003(dt: Dt) {
  dt.log.i('热启动进入图库任意界面 start');
  dt.log.i('STEP 1、点击图库手抬起来作为起始帧');

  await dt.sleep();
  dt.log.i('STEP 2、图库界面完全展开无白屏作为结束帧');

  await dt.sleep();
  dt.log.i('STEP 3、计算结束帧的时间减去起始帧的时间');

  await dt.sleep();
  dt.log.i('预期结果3、性能数据优于xxx（xxx热启动进入照片页以及相册页无白屏）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('热启动进入图库任意界面 end');
}

/**
 * 性能-端云: [冷启动进入相册页]
 * GROUP: 性能 MODULE: 端云TID: Multimedia_Photos_50W_Performance_Case004
 * 前置条件
 * 手机登录50W数据的账号，正常的开启端云下行同步 ；确保图库停留在相册页 ，然后杀进程 ；等待1分钟以上 ，确保不走保活流程，再次从桌面点击图库

 */
async function Multimedia_Photos_50W_Performance_Case004(dt: Dt) {
  dt.log.i('冷启动进入相册页 start');
  dt.log.i('STEP 1、点击图库手抬起来作为起始帧');

  await dt.sleep();
  dt.log.i('STEP 2、图库界面完全展开无白屏作为结束帧');

  await dt.sleep();
  dt.log.i('STEP 3、计算结束帧的时间减去起始帧的时间');

  await dt.sleep();
  dt.log.i('预期结果3、性能数据优于xxx（xxx冷启动进入照片页大约0.5S，相册页大约2S）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('冷启动进入相册页 end');
}

/**
 * 性能-端云: [图库在前台，截屏端端时延]
 * GROUP: 性能 MODULE: 端云TID: Multimedia_Photos_50W_Performance_Case005
 * 前置条件
 * 手机登录50W数据的账号，正常的开启端云下行同步
 确保图库处于前台相册相册主页面
 */
async function Multimedia_Photos_50W_Performance_Case005(dt: Dt) {
  dt.log.i('图库在前台，截屏端端时延 start');
  dt.log.i('STEP 1、打开图库，截图一张照片，截图结束作为起始帧');

  await dt.sleep();
  dt.log.i('STEP 2、查看所有图片相册，截图完全显示无白屏时作为结束帧');

  await dt.sleep();
  dt.log.i('STEP 3、计算结束帧的时间减去起始帧的时间');

  await dt.sleep();
  dt.log.i('预期结果3、截图的照片生成在图库时间优于xxx图库');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库在前台，截屏端端时延 end');
}

/**
 * 性能-端云: [图库在前台，录屏端端时延]
 * GROUP: 性能 MODULE: 端云TID: Multimedia_Photos_50W_Performance_Case006
 * 前置条件
 * 手机登录50W数据的账号，正常的开启端云下行同步
 确保图库处于前台相册相册主页面
 */
async function Multimedia_Photos_50W_Performance_Case006(dt: Dt) {
  dt.log.i('图库在前台，录屏端端时延 start');
  dt.log.i('STEP 1、打开图库，录屏一个视频，录屏结束作为起始帧');

  await dt.sleep();
  dt.log.i('STEP 2、查看所有照片相册，录屏完全显示无白屏时作为结束帧');

  await dt.sleep();
  dt.log.i('STEP 3、计算结束帧的时间减去起始帧的时间');

  await dt.sleep();
  dt.log.i('预期结果3、录屏的视频生成在图库时间优于xxx图库');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库在前台，录屏端端时延 end');
}

/**
 * 性能-端云: [图库在后台录屏，截屏]
 * GROUP: 性能 MODULE: 端云TID: Multimedia_Photos_50W_Performance_Case007
 * 前置条件
 * 手机登录50W数据的账号，正常的开启端云下行同步
 确保图库处于前台相册相册主页面
 */
async function Multimedia_Photos_50W_Performance_Case007(dt: Dt) {
  dt.log.i('图库在后台录屏，截屏 start');
  dt.log.i('STEP 1、退出图库在后台截图一张照片，截图结束作为起始帧');

  await dt.sleep();
  dt.log.i('STEP 2、查看所有照片相册，截图完全显示无白屏时作为结束帧');

  await dt.sleep();
  dt.log.i('STEP 3、计算结束帧的时间减去起始帧的时间');

  await dt.sleep();
  dt.log.i('预期结果3、截图生成在图库时间优于xxx图库');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、录制视频操作1-3');

  await dt.sleep();
  dt.log.i('预期结果4、录屏生成在图库时间优于xxx图库');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库在后台录屏，截屏 end');
}

/**
 * 性能-大图: [宫格缩略图进大图]
 * GROUP: 性能 MODULE: 大图TID: Multimedia_Photos_50W_Performance_Case008
 * 前置条件
 * 手机登录50W数据的账号，正常的开启端云下行同步
 确保图库处于前台照片主页面
 */
async function Multimedia_Photos_50W_Performance_Case008(dt: Dt) {
  dt.log.i('宫格缩略图进大图 start');
  dt.log.i('STEP 1、点击宫格中的缩略图，手抬起来作为起始帧');

  await dt.sleep();
  dt.log.i('STEP 2、大图完全显示作为结束帧');

  await dt.sleep();
  dt.log.i('STEP 3、计算结束帧的时间减去起始帧的时间');

  await dt.sleep();
  dt.log.i('预期结果3、性能数据优于xxx（xxx无白屏）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格缩略图进大图 end');
}

/**
 * 性能-滑动: [大图左右滑动浏览]
 * GROUP: 性能 MODULE: 滑动TID: Multimedia_Photos_50W_Performance_Case009
 * 前置条件
 * 手机登录50W数据的账号，正常的开启端云下行同步
 确保图库处于前台照片主页面，点击任意大图开始
 */
async function Multimedia_Photos_50W_Performance_Case009(dt: Dt) {
  dt.log.i('大图左右滑动浏览 start');
  dt.log.i('STEP 1、大图浏览时，左右滑动照片，手抬起来作为起始帧');

  await dt.sleep();
  dt.log.i('STEP 2、大图完全显示作为结束帧');

  await dt.sleep();
  dt.log.i('STEP 3、计算结束帧的时间减去起始帧的时间');

  await dt.sleep();
  dt.log.i('预期结果3、性能数据优于xxx（xxx无白屏）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图左右滑动浏览 end');
}

