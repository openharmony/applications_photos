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
    run('Multimedia_Gallery_SR20240305625869_001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [jpeg格式4.5K以内图片直接解码原图] TID: Multimedia_Gallery_SR20240305625869_001
      await Multimedia_Gallery_SR20240305625869_001(dt);
    });
    run('Multimedia_Gallery_SR20240305625869_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [jpeg格式4.5K以外图片先解码LCD图再显示] TID: Multimedia_Gallery_SR20240305625869_002
      await Multimedia_Gallery_SR20240305625869_002(dt);
    });
    run('Multimedia_Gallery_SR20240305625869_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-heif用例: [heif格式4.5K以内图片直接解码原图] TID: Multimedia_Gallery_SR20240305625869_003
      await Multimedia_Gallery_SR20240305625869_003(dt);
    });
    run('Multimedia_Gallery_SR20240305625869_004', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-heif用例: [heif格式4.5K以外图片先解码LCD图再显示] TID: Multimedia_Gallery_SR20240305625869_004
      await Multimedia_Gallery_SR20240305625869_004(dt);
    });
    run('Multimedia_Gallery_SR20240305625869_005', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [jpeg格式4.5K以内图片预解码] TID: Multimedia_Gallery_SR20240305625869_005
      await Multimedia_Gallery_SR20240305625869_005(dt);
    });
    run('Multimedia_Gallery_SR20240305625869_006', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片不走yuv解码] TID: Multimedia_Gallery_SR20240305625869_006
      await Multimedia_Gallery_SR20240305625869_006(dt);
    });
    run('Multimedia_Gallery_SR20240305625869_007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [其他格式照片大图浏览] TID: Multimedia_Gallery_SR20240305625869_007
      await Multimedia_Gallery_SR20240305625869_007(dt);
    });
    run('Multimedia_Gallery_SR20240305625869_008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [jpeg格式4.5K以内的云端照片] TID: Multimedia_Gallery_SR20240305625869_008
      await Multimedia_Gallery_SR20240305625869_008(dt);
    });
    run('Multimedia_Gallery_SR20240305625869_009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-heif用例: [heif格式4.5K以内的云端照片] TID: Multimedia_Gallery_SR20240305625869_009
      await Multimedia_Gallery_SR20240305625869_009(dt);
    });
    run('Multimedia_Gallery_SR20240305625869_010', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-heif用例: [支持yuv解码打点] TID: Multimedia_Gallery_SR20240305625869_010
      await Multimedia_Gallery_SR20240305625869_010(dt);
    });
    run('Multimedia_Gallery_SR20240305625869_011', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [支持yuv解码内存测试] TID: Multimedia_Gallery_SR20240305625869_011
      await Multimedia_Gallery_SR20240305625869_011(dt);
    });
    run('Multimedia_Gallery_SR20240305625869_012', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-heif用例: [支持yuv解码内存性能测试] TID: Multimedia_Gallery_SR20240305625869_012
      await Multimedia_Gallery_SR20240305625869_012(dt);
    });
    run('Multimedia_Gallery_SR20240305625869_013', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [支持yuv解码功耗测试] TID: Multimedia_Gallery_SR20240305625869_013
      await Multimedia_Gallery_SR20240305625869_013(dt);
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
 * 大图-格式: [jpeg格式4.5K以内图片直接解码原图]
 * TAG: 702 TID: Multimedia_Gallery_SR20240305625869_001
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20240305625869_001(dt: Dt) {
  dt.log.i('jpeg格式4.5K以内图片直接解码原图 start');
  dt.log.i('STEP 1、图库中任意jpeg格式4.5K以内的照片大图浏览；');

  await dt.sleep();
  dt.log.i('预期结果1、大图浏览加载正常，无卡顿、刷新等场景');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、通过日志查看直接解码原图，不再解码LCD图，日志打印picture decode mime, pixelmapFormat 11和No need LcdDocode');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('jpeg格式4.5K以内图片直接解码原图 end');
}

/**
 * 大图-格式: [jpeg格式4.5K以外图片先解码LCD图再显示]
 * TAG: 705 TID: Multimedia_Gallery_SR20240305625869_002
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20240305625869_002(dt: Dt) {
  dt.log.i('jpeg格式4.5K以外图片先解码LCD图再显示 start');
  dt.log.i('STEP 1、图库中任意jpeg格式4.5K以外的照片大图浏览；');

  await dt.sleep();
  dt.log.i('预期结果1、大图浏览加载正常，无卡顿、刷新等场景');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、通过日志查看先解码LCD图再显示，日志打印picture decode mime, pixelmapFormat 3');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('jpeg格式4.5K以外图片先解码LCD图再显示 end');
}

/**
 * 大图-heif: [heif格式4.5K以内图片直接解码原图]
 * TAG: 698 TID: Multimedia_Gallery_SR20240305625869_003
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20240305625869_003(dt: Dt) {
  dt.log.i('heif格式4.5K以内图片直接解码原图 start');
  dt.log.i('STEP 1、图库中任意heif格式4.5K以内的照片大图浏览；');

  await dt.sleep();
  dt.log.i('预期结果1、大图浏览加载正常，无卡顿、刷新等场景');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、通过日志查看直接解码原图，日志只打印picture decode mime, pixelmapFormat 11');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('heif格式4.5K以内图片直接解码原图 end');
}

/**
 * 大图-heif: [heif格式4.5K以外图片先解码LCD图再显示]
 * TAG: 700 TID: Multimedia_Gallery_SR20240305625869_004
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20240305625869_004(dt: Dt) {
  dt.log.i('heif格式4.5K以外图片先解码LCD图再显示 start');
  dt.log.i('STEP 1、图库中任意jpeg格式4.5K以外的照片大图浏览；');

  await dt.sleep();
  dt.log.i('预期结果1、大图浏览加载正常，无卡顿、刷新等场景');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、通过日志查看先解码LCD图再显示，日志只打印picture decode mime, pixelmapFormat 3');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('heif格式4.5K以外图片先解码LCD图再显示 end');
}

/**
 * 大图-格式: [jpeg格式4.5K以内图片预解码]
 * TAG: 703 TID: Multimedia_Gallery_SR20240305625869_005
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20240305625869_005(dt: Dt) {
  dt.log.i('jpeg格式4.5K以内图片预解码 start');
  dt.log.i('STEP 1、大图浏览加载正常，无卡顿、刷新等场景');

  await dt.sleep();
  dt.log.i('预期结果1、大图浏览加载正常，无卡顿、刷新等场景');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、通过日志查看直接解码原图，不再解码LCD图，日志打印3次+:K8picture decode mime, pixelmapFormat 11和No need LcdDocode');

  await dt.sleep();
  dt.log.i('预期结果2、通过日志查看直接解码原图，不再解码LCD图，日志打印picture decode mime, pixelmapFormat 11和No need LcdDocode');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('jpeg格式4.5K以内图片预解码 end');
}

/**
 * 大图-动态照片: [动态照片不走yuv解码]
 * TAG: 704 TID: Multimedia_Gallery_SR20240305625869_006
 * 前置条件
 * 1、图库存在动态照片
 */
async function Multimedia_Gallery_SR20240305625869_006(dt: Dt) {
  dt.log.i('动态照片不走yuv解码 start');
  dt.log.i('STEP 1、大图浏览动态照片');

  await dt.sleep();
  dt.log.i('预期结果1、大图浏览加载正常，无卡顿、刷新等场景');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、不打印picture decode mime, pixelmapFormat 11和No need LcdDocode');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片不走yuv解码 end');
}

/**
 * 大图-格式: [其他格式照片大图浏览]
 * TAG: 701 TID: Multimedia_Gallery_SR20240305625869_007
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20240305625869_007(dt: Dt) {
  dt.log.i('其他格式照片大图浏览 start');
  dt.log.i('STEP 1、大图浏览其他格式照片（bmp、png、raw、svg等）；');

  await dt.sleep();
  dt.log.i('预期结果1、大图浏览加载正常，无卡顿、刷新等场景');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、通过日志查看不走yuv解码，日志不打印picture decode mime, pixelmapFormat 11');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('其他格式照片大图浏览 end');
}

/**
 * 大图-格式: [jpeg格式4.5K以内的云端照片]
 * TAG: 697 TID: Multimedia_Gallery_SR20240305625869_008
 * 前置条件
 * 1、图库存在云端照片
 */
async function Multimedia_Gallery_SR20240305625869_008(dt: Dt) {
  dt.log.i('jpeg格式4.5K以内的云端照片 start');
  dt.log.i('STEP 1、云端照片大图浏览，查看日志');

  await dt.sleep();
  dt.log.i('预期结果1、大图浏览加载正常，日志不打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、下载云端照片之后大图浏览，查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、通过日志查看直接解码原图，不再解码LCD图，日志打印picture decode mime, pixelmapFormat 11和No need LcdDocode');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('jpeg格式4.5K以内的云端照片 end');
}

/**
 * 大图-heif: [heif格式4.5K以内的云端照片]
 * TAG: 699 TID: Multimedia_Gallery_SR20240305625869_009
 * 前置条件
 * 1、图库存在云端照片
 */
async function Multimedia_Gallery_SR20240305625869_009(dt: Dt) {
  dt.log.i('heif格式4.5K以内的云端照片 start');
  dt.log.i('STEP 1、云端照片大图浏览，查看日志');

  await dt.sleep();
  dt.log.i('预期结果1、大图浏览加载正常，日志不打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、下载云端照片之后大图浏览，查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、通过日志查看先解码LCD图再显示，日志打印picture decode mime, pixelmapFormat 3');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('heif格式4.5K以内的云端照片 end');
}

/**
 * 大图-heif: [支持yuv解码打点]
 * TAG: 696 TID: Multimedia_Gallery_SR20240305625869_010
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20240305625869_010(dt: Dt) {
  dt.log.i('支持yuv解码打点 start');
  dt.log.i('STEP 1、大图浏览jpeg格式4.5K以内图片');

  await dt.sleep();
  dt.log.i('STEP 2、大图浏览jpeg格式4.5K以外图片');

  await dt.sleep();
  dt.log.i('STEP 3、大图浏览heif格式图片');

  await dt.sleep();
  dt.log.i('STEP 4、大图浏览其他格式照片（bmp、png、raw、svg等）');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持yuv解码打点 end');
}

/**
 * 大图-格式: [支持yuv解码内存测试]
 * TAG: 708 TID: Multimedia_Gallery_SR20240305625869_011
 * 前置条件
 * 1、图库中存在5张jpeg格式4.5K以内的照片
 */
async function Multimedia_Gallery_SR20240305625869_011(dt: Dt) {
  dt.log.i('支持yuv解码内存测试 start');
  dt.log.i('STEP 1、4.5K以下分辨率jpeg图，打开大图');

  await dt.sleep();
  dt.log.i('STEP 2、滑动浏览5张，查看内存');

  await dt.sleep();
  dt.log.i('预期结果2、内存增量低于之前；内存增量减少20%');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持yuv解码内存测试 end');
}

/**
 * 大图-heif: [支持yuv解码内存性能测试]
 * TAG: 707 TID: Multimedia_Gallery_SR20240305625869_012
 * 前置条件
 * 1、图库中存在5张jpeg格式4.5K以内的照片
 */
async function Multimedia_Gallery_SR20240305625869_012(dt: Dt) {
  dt.log.i('支持yuv解码内存性能测试 start');
  dt.log.i('STEP 1、4.5K以下分辨率jpeg图，性能测试打开大图、大图滑动切换帧率和时延');

  await dt.sleep();
  dt.log.i('预期结果1、帧率和时延对比之前不下降');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、4.5K以下分辨率heif图，性能测试打开大图，大图滑动切换帧率和时延');

  await dt.sleep();
  dt.log.i('预期结果2、帧率和时延不差于同分辨率jpeg图');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持yuv解码内存性能测试 end');
}

/**
 * 大图-格式: [支持yuv解码功耗测试]
 * TAG: 706 TID: Multimedia_Gallery_SR20240305625869_013
 * 前置条件
 * 1、图库中存在5张jpeg格式4.5K以内的照片
 */
async function Multimedia_Gallery_SR20240305625869_013(dt: Dt) {
  dt.log.i('支持yuv解码功耗测试 start');
  dt.log.i('STEP 1、大图浏览同一照片，查看功耗');

  await dt.sleep();
  dt.log.i('预期结果1、功耗对比之前不增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、向右滑动5张照片，查看功耗');

  await dt.sleep();
  dt.log.i('预期结果2、功耗对比之前不增加');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持yuv解码功耗测试 end');
}

