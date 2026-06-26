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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, Level } from '@ohos/hypium';
import { Component, Driver, On, ON, Point } from '@ohos.UiTest';
import { abilityDelegator, run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';


export default function aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification018Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('APPFWKMediaFwkMediaLibraryMediaCVVideoClassification018Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAPPFWKMediaFwkMediaLibraryMediaCVVideoClassification018').init();
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVVideoClassification018 start');
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVVideoClassification018 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClassification018', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [含有280类标签的视频识别准确以及召回率] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_018
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification018(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClassification020', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [支持分析手机录制的视频：分辨率[16:9]4k(30fps) 1min1S] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_020
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification020(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClassification021', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [支持分析手机录制的视频：分辨率[16:9]4k(60fps) 1min1S] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_021
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification021(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClassification022', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [支持分析手机录制的视频：分辨率【全屏】1080p(30fps) 1min1S] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_022
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification022(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClassification023', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [支持分析手机录制的视频：分辨率【全屏】1080p(60fps) 1min4S] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_023
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification023(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClassification024', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [支持分析手机录制的视频：分辨率【16:9】1080p(30fps) 1min1S] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_024
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification024(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClassification025', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [支持分析手机录制的视频：分辨率【16:9】1080p(60fps) 1min1S] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_025
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification025(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClassification026', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [支持最新手机拍摄的视频分辨率【21:9】1080p(30fps) 1min1S] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_026
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification026(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClassification027', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [支持分析手机录制的视频：分辨率【21:9】1080p(60fps) 1min4S] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_027
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification027(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClassification028', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [支持分析手机录制的视频：分辨率【16:9】720p(30fps) 1min1S] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_028
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification028(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClassification029', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [支持分析手机录制的视频：分辨率【16:9】720p(60fps) 1min2S] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_029
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification029(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClassification030', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [支持分析手机录制的视频：帧率【16:9】1080p（120fps） 1min3S] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_030
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification030(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClassification031', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [支持分析手机录制的视频：帧率【16:9】1080p（240fps） 1min1S] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_031
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification031(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClassification032', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [支持分析手机录制的视频：帧率【16:9】1080p（960fps） 17S] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_032
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification032(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClassification033', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [支持分析手机录制的视频：帧率【16:9】720p（1920fps） 34S] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_033
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification033(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClassification034', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [支持分析手机录制的视频：帧率【16:9】720p（7680fps） 33S] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_034
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification034(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [手机中除了最近删除相册中存在的视频都会进行智慧分析] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_001
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor001(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [存在分析结果视频进入最近删除相册，分析结果保留] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_002
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor002(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [最近删除中的视频恢复后，分析结果保留] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_003
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor003(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [本地存在人像的视频支持分析，并支持用户搜索] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_004
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor004(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor005', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [纯云端存在人像的视频不支持分析] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_005
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor005(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [云端+本地存在人像的视频支持人像视频分析，并支持用户搜索] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_006
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor006(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [视频场景连续出现2秒钟及以上才能分析出] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_007
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor007(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [大于10min以上的视频不会进行人像视频分析] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_008
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor008(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [小于等于10min以上的视频会进行人像视频分析] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_009
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor009(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-HDR用例: [支持分析格式为HDRVIVID、SDR的MP4视频] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_010
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor010(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor011', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [视频分析需要等待90%图片分析完后开始进行] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_011
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor011(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor012', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [存在人像的视频分析中断可接续] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_012
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor012(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor013', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [编辑视频后覆盖保存，更新视频人像分析结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_013
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor013(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor014', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [裁剪视频后另存，新增视频人像分析结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_014
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor014(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachAPPFWKMediaFwkMediaLibraryMediaCVVideoClassification018').init();
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVVideoClassification018 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVVideoClassification018 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllAPPFWKMediaFwkMediaLibraryMediaCVVideoClassification018').init();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVVideoClassification018 start');
      await Exit.browser();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVVideoClassification018 finish');
    });
  });
}

/**
 * 宫格-视频: [含有280类标签的视频识别准确以及召回率]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_018
 * 前置条件
 * 1、手机电量大于50%，分别预制280类视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification018(dt: Dt) {
  dt.log.i('含有280类标签的视频识别准确以及召回率 start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、准确率平均为90%，召回率平均为70%');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('含有280类标签的视频识别准确以及召回率 end');
}

/**
 * 宫格-视频: [支持分析手机录制的视频：分辨率[16:9]4k(30fps) 1min1S]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_020
 * 前置条件
 * 1.手机电量大于50%，预制[16:9]4k(30fps)的视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification020(dt: Dt) {
  dt.log.i('支持分析手机录制的视频：分辨率[16:9]4k(30fps) 1min1S start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志视频分析时长');

  await dt.sleep();
  dt.log.i('预期结果2.1、支持该格式视频2.2、分析时长满足性能基线（1:1）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持分析手机录制的视频：分辨率[16:9]4k(30fps) 1min1S end');
}

/**
 * 宫格-视频: [支持分析手机录制的视频：分辨率[16:9]4k(60fps) 1min1S]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_021
 * 前置条件
 * 1.手机电量大于50%，预制[16:9]4k(60fps)的视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification021(dt: Dt) {
  dt.log.i('支持分析手机录制的视频：分辨率[16:9]4k(60fps) 1min1S start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志视频分析时长');

  await dt.sleep();
  dt.log.i('预期结果2.1、支持该格式视频2.2、分析时长满足性能基线（1:1）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持分析手机录制的视频：分辨率[16:9]4k(60fps) 1min1S end');
}

/**
 * 宫格-视频: [支持分析手机录制的视频：分辨率【全屏】1080p(30fps) 1min1S]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_022
 * 前置条件
 * 1.手机电量大于50%，预制【全屏】1080p(30fps)的视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification022(dt: Dt) {
  dt.log.i('支持分析手机录制的视频：分辨率【全屏】1080p(30fps) 1min1S start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志视频分析时长');

  await dt.sleep();
  dt.log.i('预期结果2.1、支持该格式视频2.2、分析时长满足性能基线（1:1）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持分析手机录制的视频：分辨率【全屏】1080p(30fps) 1min1S end');
}

/**
 * 宫格-视频: [支持分析手机录制的视频：分辨率【全屏】1080p(60fps) 1min4S]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_023
 * 前置条件
 * 1.手机电量大于50%，预制【全屏】1080p(60fps)的视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification023(dt: Dt) {
  dt.log.i('支持分析手机录制的视频：分辨率【全屏】1080p(60fps) 1min4S start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志视频分析时长');

  await dt.sleep();
  dt.log.i('预期结果2.1、支持该格式视频2.2、分析时长满足性能基线（1:1）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持分析手机录制的视频：分辨率【全屏】1080p(60fps) 1min4S end');
}

/**
 * 宫格-视频: [支持分析手机录制的视频：分辨率【16:9】1080p(30fps) 1min1S]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_024
 * 前置条件
 * 1.手机电量大于50%，预制[16:9]1080p(30fps)的视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification024(dt: Dt) {
  dt.log.i('支持分析手机录制的视频：分辨率【16:9】1080p(30fps) 1min1S start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志视频分析时长');

  await dt.sleep();
  dt.log.i('预期结果2.1、支持该格式视频2.2、分析时长满足性能基线（1:1）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持分析手机录制的视频：分辨率【16:9】1080p(30fps) 1min1S end');
}

/**
 * 宫格-视频: [支持分析手机录制的视频：分辨率【16:9】1080p(60fps) 1min1S]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_025
 * 前置条件
 * 1.手机电量大于50%，预制[16:9]1080p(60fps)的视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification025(dt: Dt) {
  dt.log.i('支持分析手机录制的视频：分辨率【16:9】1080p(60fps) 1min1S start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志视频分析时长');

  await dt.sleep();
  dt.log.i('预期结果2.1、支持该格式视频2.2、分析时长满足性能基线（1:1）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持分析手机录制的视频：分辨率【16:9】1080p(60fps) 1min1S end');
}

/**
 * 宫格-视频: [支持最新手机拍摄的视频分辨率【21:9】1080p(30fps) 1min1S]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_026
 * 前置条件
 * 1.手机电量大于50%，预制【21:9】1080p(30fps)的视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification026(dt: Dt) {
  dt.log.i('支持最新手机拍摄的视频分辨率【21:9】1080p(30fps) 1min1S start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志视频分析时长');

  await dt.sleep();
  dt.log.i('预期结果2.1、支持该格式视频2.2、分析时长满足性能基线（1:1）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持最新手机拍摄的视频分辨率【21:9】1080p(30fps) 1min1S end');
}

/**
 * 宫格-视频: [支持分析手机录制的视频：分辨率【21:9】1080p(60fps) 1min4S]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_027
 * 前置条件
 * 1.手机电量大于50%，预制【21:9】1080p(60fps)的视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification027(dt: Dt) {
  dt.log.i('支持分析手机录制的视频：分辨率【21:9】1080p(60fps) 1min4S start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志视频分析时长');

  await dt.sleep();
  dt.log.i('预期结果2.1、支持该格式视频2.2、分析时长满足性能基线（1:1）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持分析手机录制的视频：分辨率【21:9】1080p(60fps) 1min4S end');
}

/**
 * 宫格-视频: [支持分析手机录制的视频：分辨率【16:9】720p(30fps) 1min1S]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_028
 * 前置条件
 * 1.手机电量大于50%，预制[16:9]720p(30fps)的视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification028(dt: Dt) {
  dt.log.i('支持分析手机录制的视频：分辨率【16:9】720p(30fps) 1min1S start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志视频分析时长');

  await dt.sleep();
  dt.log.i('预期结果2.1、支持该格式视频2.2、分析时长满足性能基线（1:1）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持分析手机录制的视频：分辨率【16:9】720p(30fps) 1min1S end');
}

/**
 * 宫格-视频: [支持分析手机录制的视频：分辨率【16:9】720p(60fps) 1min2S]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_029
 * 前置条件
 * 1.手机电量大于50%，预制[16:9]720p(60fps)的视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification029(dt: Dt) {
  dt.log.i('支持分析手机录制的视频：分辨率【16:9】720p(60fps) 1min2S start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志视频分析时长');

  await dt.sleep();
  dt.log.i('预期结果2.1、支持该格式视频2.2、分析时长满足性能基线（1:1）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持分析手机录制的视频：分辨率【16:9】720p(60fps) 1min2S end');
}

/**
 * 宫格-视频: [支持分析手机录制的视频：帧率【16:9】1080p（120fps） 1min3S]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_030
 * 前置条件
 * 1.手机电量大于50%，预制[16:9]1080p（120fps）的视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification030(dt: Dt) {
  dt.log.i('支持分析手机录制的视频：帧率【16:9】1080p（120fps） 1min3S start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志视频分析时长');

  await dt.sleep();
  dt.log.i('预期结果2.1、支持该格式视频2.2、分析时长满足性能基线（1:1）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持分析手机录制的视频：帧率【16:9】1080p（120fps） 1min3S end');
}

/**
 * 宫格-视频: [支持分析手机录制的视频：帧率【16:9】1080p（240fps） 1min1S]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_031
 * 前置条件
 * 1.手机电量大于50%，预制[16:9]1080p（240fps）的视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification031(dt: Dt) {
  dt.log.i('支持分析手机录制的视频：帧率【16:9】1080p（240fps） 1min1S start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志视频分析时长');

  await dt.sleep();
  dt.log.i('预期结果2.1、支持该格式视频2.2、分析时长满足性能基线（1:1）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持分析手机录制的视频：帧率【16:9】1080p（240fps） 1min1S end');
}

/**
 * 宫格-视频: [支持分析手机录制的视频：帧率【16:9】1080p（960fps） 17S]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_032
 * 前置条件
 * 1.手机电量大于50%，预制[16:9]1080p（960fps）的视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification032(dt: Dt) {
  dt.log.i('支持分析手机录制的视频：帧率【16:9】1080p（960fps） 17S start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志视频分析时长');

  await dt.sleep();
  dt.log.i('预期结果2.1、支持该格式视频2.2、分析时长满足性能基线（1:1）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持分析手机录制的视频：帧率【16:9】1080p（960fps） 17S end');
}

/**
 * 宫格-视频: [支持分析手机录制的视频：帧率【16:9】720p（1920fps） 34S]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_033
 * 前置条件
 * 1.手机电量大于50%，预制[16:9]720p（1920fps）的视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification033(dt: Dt) {
  dt.log.i('支持分析手机录制的视频：帧率【16:9】720p（1920fps） 34S start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志视频分析时长');

  await dt.sleep();
  dt.log.i('预期结果2.1、支持该格式视频2.2、分析时长满足性能基线（1:1）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持分析手机录制的视频：帧率【16:9】720p（1920fps） 34S end');
}

/**
 * 宫格-视频: [支持分析手机录制的视频：帧率【16:9】720p（7680fps） 33S]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClassification_034
 * 前置条件
 * 1.手机电量大于50%，预制720p（7680fps）的视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClassification034(dt: Dt) {
  dt.log.i('支持分析手机录制的视频：帧率【16:9】720p（7680fps） 33S start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志视频分析时长');

  await dt.sleep();
  dt.log.i('预期结果2.1、支持该格式视频2.2、分析时长满足性能基线（1:1）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持分析手机录制的视频：帧率【16:9】720p（7680fps） 33S end');
}

/**
 * 宫格-删除: [手机中除了最近删除相册中存在的视频都会进行智慧分析]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_001
 * 前置条件
 * 手机电量大于50%，最近删除相册预置200张图片+4人像视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor001(dt: Dt) {
  dt.log.i('手机中除了最近删除相册中存在的视频都会进行智慧分析 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""MediaCV""，关键字：video_cluster_processor');

  await dt.sleep();
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_video_face内各字段和tab_analysis_total表内face字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total内status=2，tab_analysis_video_face未新增数据，视频标签未分析');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、在手机其他相册：隐藏相册、图片相册、截屏相册中预置200图片+4视频，重复步骤1-3');

  await dt.sleep();
  dt.log.i('预期结果4、tab_analysis_video_label新增数据，视频标签已分析');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('手机中除了最近删除相册中存在的视频都会进行智慧分析 end');
}

/**
 * 宫格-删除: [存在分析结果视频进入最近删除相册，分析结果保留]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_002
 * 前置条件
 * 1、手机图片相册内有分析完成的人像视频
 2、手机电量大于50%
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor002(dt: Dt) {
  dt.log.i('存在分析结果视频进入最近删除相册，分析结果保留 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""MediaCV""，关键字：video_cluster_processor');

  await dt.sleep();
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_video_face内各字段和tab_analysis_total表内face字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total内status=2，tab_analysis_video_face数据存在，未被删除');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('存在分析结果视频进入最近删除相册，分析结果保留 end');
}

/**
 * 宫格-删除: [最近删除中的视频恢复后，分析结果保留]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_003
 * 前置条件
 * 1、最近删除内有分析完成的人像视频
 2、手机电量大于50%
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor003(dt: Dt) {
  dt.log.i('最近删除中的视频恢复后，分析结果保留 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""MediaCV""，关键字：video_cluster_processor');

  await dt.sleep();
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_video_face内各字段和tab_analysis_total表内face字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total内status不为2，tab_analysis_video_face数据存在，未被删除或修改');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除中的视频恢复后，分析结果保留 end');
}

/**
 * 宫格-视频: [本地存在人像的视频支持分析，并支持用户搜索]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_004
 * 前置条件
 * 1、手机电量大于50%，预制本地人像视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor004(dt: Dt) {
  dt.log.i('本地存在人像的视频支持分析，并支持用户搜索 start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、启动后台人像视频分析');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分析完成后构建索引，进入图库搜索');

  await dt.sleep();
  dt.log.i('预期结果3、可以搜索到“人像”视频');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('人像'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地存在人像的视频支持分析，并支持用户搜索 end');
}

/**
 * 宫格-视频: [纯云端存在人像的视频不支持分析]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_005
 * 前置条件
 * 1、手机电量大于50%，登陆云账号打开云图库开关，云端有视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor005(dt: Dt) {
  dt.log.i('纯云端存在人像的视频不支持分析 start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、不支持云端人像视频分析');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('纯云端存在人像的视频不支持分析 end');
}

/**
 * 宫格-视频: [云端+本地存在人像的视频支持人像视频分析，并支持用户搜索]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_006
 * 前置条件
 * 1、手机电量大于50%，登陆云账号打开云图库开关，存在端云视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor006(dt: Dt) {
  dt.log.i('云端+本地存在人像的视频支持人像视频分析，并支持用户搜索 start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、启动后台人像视频分析');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分析完成后构建索引，进入图库搜索');

  await dt.sleep();
  dt.log.i('预期结果3、可以搜索到视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云端+本地存在人像的视频支持人像视频分析，并支持用户搜索 end');
}

/**
 * 宫格-视频: [视频场景连续出现2秒钟及以上才能分析出]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_007
 * 前置条件
 * 1、手机电量大于50%，预制场景出现1S、2S和10S的视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor007(dt: Dt) {
  dt.log.i('视频场景连续出现2秒钟及以上才能分析出 start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、1S的视频不支持后台人像视频分析，2S和10S的视频支持后台人像视频分析');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频场景连续出现2秒钟及以上才能分析出 end');
}

/**
 * 宫格-视频: [大于10min以上的视频不会进行人像视频分析]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_008
 * 前置条件
 * 1、手机电量大于50%，充电，预制大于10min以上的人像视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor008(dt: Dt) {
  dt.log.i('大于10min以上的视频不会进行人像视频分析 start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、不启动后台人像视频分析');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大于10min以上的视频不会进行人像视频分析 end');
}

/**
 * 宫格-视频: [小于等于10min以上的视频会进行人像视频分析]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_009
 * 前置条件
 * 1、手机电量大于50%，预制10min、小于10min的人像视频各一
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor009(dt: Dt) {
  dt.log.i('小于等于10min以上的视频会进行人像视频分析 start');
  dt.log.i('STEP 1、充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、启动后台视频语义分析');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分析完成后构建索引，进入图库搜索“人像”');

  await dt.sleep();
  dt.log.i('预期结果3、可以搜索到2个人像视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('小于等于10min以上的视频会进行人像视频分析 end');
}

/**
 * 宫格-HDR: [支持分析格式为HDRVIVID、SDR的MP4视频]
 * GROUP: 宫格 MODULE: HDRTID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_010
 * 前置条件
 * 手机电量大于50%，手机相册视频格式分别为HDRVIVID、SDR、HDR各4个
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor010(dt: Dt) {
  dt.log.i('支持分析格式为HDRVIVID、SDR的MP4视频 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""MediaCV""，关键字：video_cluster_processor');

  await dt.sleep();
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_video_face内各字段和tab_analysis_total表内face字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_video_face新增数据，人像视频标签已分析；HDR格式人像视频无分析结果，tab_analysis_total.face=-2');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持分析格式为HDRVIVID、SDR的MP4视频 end');
}

/**
 * 宫格-视频: [视频分析需要等待90%图片分析完后开始进行]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_011
 * 前置条件
 * 手机电量大于50%，图库预置200张图片+4人像视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor011(dt: Dt) {
  dt.log.i('视频分析需要等待90%图片分析完后开始进行 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""MediaCV""，关键字：""video_cluster_processor""、""analysis status"" ');

  await dt.sleep();
  dt.log.i('预期结果2、人像视频分析需要等待图片分析到90%以上：“analysis status”中已分析图片超过180张后，开始人像视频分析');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('analysis status'));
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_video_face内各字段和tab_analysis_total表内face字段');

  await dt.sleep();
  dt.log.i('预期结果3、数据库表中正常新增数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频分析需要等待90%图片分析完后开始进行 end');
}

/**
 * 宫格-视频: [存在人像的视频分析中断可接续]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_012
 * 前置条件
 * 手机电量大于50%，手机相册预置200张图片+4视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor012(dt: Dt) {
  dt.log.i('存在人像的视频分析中断可接续 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""MediaCV""，关键字：""video_cluster_processor""');

  await dt.sleep();
  dt.log.i('STEP 3、在分析视频的时候 亮屏或设置手机温度高于37℃，查看日志');

  await dt.sleep();
  dt.log.i('预期结果3、日志停止打印，后台智慧分析暂停');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、继续充电息屏分析，查看日志');

  await dt.sleep();
  dt.log.i('预期结果4、日志重新开始打印，继续分析前一次中断时正在分析的视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('存在人像的视频分析中断可接续 end');
}

/**
 * 宫格-视频: [编辑视频后覆盖保存，更新视频人像分析结果]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_013
 * 前置条件
 * 手机电量大于50%，手机相册预置200张图片+4视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor013(dt: Dt) {
  dt.log.i('编辑视频后覆盖保存，更新视频人像分析结果 start');
  dt.log.i('STEP 1、编辑视频后覆盖保存');

  await dt.sleep();
  dt.log.i('预期结果1、原视频结果在数据库中刷新为无数据4、tab_analysis_video_label新增数据，视频标签已分析');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 3、查看日志hdc  shell hilog  | grep  ""MediaCV""，关键字：""video_cluster_processor""');

  await dt.sleep();
  dt.log.i('STEP 4、拉取数据库查看tab_analysis_video_face内各字段和tab_analysis_total表内face字段');

  await dt.sleep();
  dt.log.i('预期结果4、tab_analysis_video_label新增数据，视频标签已分析');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑视频后覆盖保存，更新视频人像分析结果 end');
}

/**
 * 宫格-视频: [裁剪视频后另存，新增视频人像分析结果]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_014
 * 前置条件
 * 手机电量大于50%，手机相册预置200张图片+4视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor014(dt: Dt) {
  dt.log.i('裁剪视频后另存，新增视频人像分析结果 start');
  dt.log.i('STEP 1、编辑视频后另存');

  await dt.sleep();
  dt.log.i('预期结果1、新增一条视频记录，无智慧数据4、tab_analysis_video_label新增数据，视频标签已分析');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 3、查看日志hdc  shell hilog  | grep  ""MediaCV""，关键字：""video_cluster_processor""');

  await dt.sleep();
  dt.log.i('STEP 4、拉取数据库查看tab_analysis_video_face内各字段和tab_analysis_total表内face字段');

  await dt.sleep();
  dt.log.i('预期结果4、tab_analysis_video_label新增数据，视频标签已分析');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('裁剪视频后另存，新增视频人像分析结果 end');
}
