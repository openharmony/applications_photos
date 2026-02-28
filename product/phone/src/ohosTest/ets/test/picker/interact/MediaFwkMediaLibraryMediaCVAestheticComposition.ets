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


export default function aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition002Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition002Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition002').init();
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition002 start');
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition002 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [截屏相册支持美学构图] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_002
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition002(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [隐藏相册支持美学构图] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_003
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition003(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [最近删除不支持美学构图] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_004
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition004(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [美学构图支持多种格式静态图片] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_006
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition006(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [美学构图支持分析单人像图片物体框位置] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_007
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition007(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition008', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [美学构图支持分析多人像图片物体框位置，最多返回10张人像位置] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_008
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition008(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition009', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [美学构图支持有主体图片，返回主体的物体框位置] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_009
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition009(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [美学构图不支持分析无人像图片物体框位置，数据库写入默认值] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_010
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition010(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [存在人像的图片构图推荐框，包含人像内容] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_011
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition011(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图片构图推荐框的大小和预期的recommendation_resolution相符] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_012
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition012(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [美学构图识别到图片主体时，会进行像素级抠图，并返回结果到segmentation_area字段] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_013
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition013(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition015', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库编辑-保存的图片，会更新美学构图结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_015
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition015(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库编辑-恢复的图片，会更新美学构图结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_016
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition016(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [截屏相册支持美学评分] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_001
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore001(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [最近删除相册不支持美学评分] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_002
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore002(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [隐藏相册支持美学评分] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_003
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore003(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [支持多种格式图片进行美学评分] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_004
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore004(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore005', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [同一张图片多次美学评分结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_005
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore005(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore006', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [同一个对象不同清晰度美学评分] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_006
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore006(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore007', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [同一个对象黑白和彩色美学评分] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_007
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore007(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore008', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [同一个对象不同对焦美学评分] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_008
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore008(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore009', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [同一个对象不同景深美学评分] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_009
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore009(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore011', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [相同类别构图简洁和构图复杂美学评分] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_011
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore011(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore012', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [相同类别对称和不对称图案的美学评分] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_012
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore012(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore014', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [相同背景、主体处在图片不同位置的美学评分] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_014
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore014(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库编辑-保存的图片，会更新美学评分结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_016
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore016(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachAPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition002').init();
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition002 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition002 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllAPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition002').init();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition002 start');
      await Exit.browser();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition002 finish');
    });
  });
}

/**
 * 宫格-: [截屏相册支持美学构图]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_002
 * 前置条件
 * 1、截屏相册准备50张图片
 2、手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition002(dt: Dt) {
  dt.log.i('截屏相册支持美学构图 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志，关键字：AcObjectProcessor,AcRecommendationProcessor,AcSegmentationProcessor');

  await dt.sleep();
  dt.log.i('预期结果2、美学构图日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_object，tab_analysis_recommendation，tab_analysis_segmentation表内有内容，tab_analysis_total表内object=1，recommendation=1，segmentation=1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('截屏相册支持美学构图 end');
}

/**
 * 宫格-: [隐藏相册支持美学构图]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_003
 * 前置条件
 * 1、手机电量大于50%，温度小于37℃
 2、隐藏相册预置56张图片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition003(dt: Dt) {
  dt.log.i('隐藏相册支持美学构图 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志，关键字：AcObjectProcessor,AcRecommendationProcessor,AcSegmentationProcessor');

  await dt.sleep();
  dt.log.i('预期结果2、美学构图日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_object，tab_analysis_recommendation，tab_analysis_segmentation表内出现内容，tab_analysis_total表内object=1，recommendation=1，segmentation=1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册支持美学构图 end');
}

/**
 * 宫格-删除: [最近删除不支持美学构图]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_004
 * 前置条件
 * 1、最近删除准备50张图片
 2、手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition004(dt: Dt) {
  dt.log.i('最近删除不支持美学构图 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志，关键字：AcObjectProcessor,AcRecommendationProcessor,AcSegmentationProcessor');

  await dt.sleep();
  dt.log.i('预期结果2、美学构图日志打印NO data for vision to analysis!');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_object，tab_analysis_recommendation，tab_analysis_segmentation表内无内容，tab_analysis_total表内status=2，object=0，recommendation=0，segmentation=03、tab_analysis_object，tab_analysis_recommendation，tab_analysis_segmentation表内新增数据，tab_analysis_total表内status=1，object=1，recommendation=1，segmentation=1');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、从最近删除相册恢复删除的图片，充电息屏，拉取数据库');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除不支持美学构图 end');
}

/**
 * 宫格-格式: [美学构图支持多种格式静态图片]
 * GROUP: 宫格 MODULE: 格式TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_006
 * 前置条件
 * 1.预制heic、dng、ARW、wbmp、NEF、CR2、gif等不同类型图片
 2.手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition006(dt: Dt) {
  dt.log.i('美学构图支持多种格式静态图片 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志，关键字：AcObjectProcessor,AcRecommendationProcessor,AcSegmentationProcessor');

  await dt.sleep();
  dt.log.i('预期结果2、美学构图日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_object，tab_analysis_recommendation，tab_analysis_segmentation表内有内容，若不支持的格式在total表中的status=-3');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('美学构图支持多种格式静态图片 end');
}

/**
 * 宫格-: [美学构图支持分析单人像图片物体框位置]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_007
 * 前置条件
 * 1、准备10张单人像图片
 2、手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition007(dt: Dt) {
  dt.log.i('美学构图支持分析单人像图片物体框位置 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、美学构图日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看：tab_analysis_object');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_object表内出现新增数据，object_id=0，object_label=0，object_scale_x，object_scale_y，object_scale_width，object_scale_height新增数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('美学构图支持分析单人像图片物体框位置 end');
}

/**
 * 宫格-: [美学构图支持分析多人像图片物体框位置，最多返回10张人像位置]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_008
 * 前置条件
 * 1、准备10张多人像图片，其中有图片中人像数量大于10
 2、手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition008(dt: Dt) {
  dt.log.i('美学构图支持分析多人像图片物体框位置，最多返回10张人像位置 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、美学构图日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看：tab_analysis_object');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_object表内出现新增数据，object_id，object_label=0，object_scale_x，object_scale_y，object_scale_width，object_scale_height新增数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('美学构图支持分析多人像图片物体框位置，最多返回10张人像位置 end');
}

/**
 * 宫格-: [美学构图支持有主体图片，返回主体的物体框位置]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_009
 * 前置条件
 * 1、准备10张宠物图片
 2、手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition009(dt: Dt) {
  dt.log.i('美学构图支持有主体图片，返回主体的物体框位置 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、美学构图日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看：tab_analysis_object');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_object表内出现新增数据，object_id，object_label，object_scale_x，object_scale_y，object_scale_width，object_scale_height新增数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('美学构图支持有主体图片，返回主体的物体框位置 end');
}

/**
 * 宫格-: [美学构图不支持分析无人像图片物体框位置，数据库写入默认值]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_010
 * 前置条件
 * 1、准备10张风景图片（无人像图片）
 2、手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition010(dt: Dt) {
  dt.log.i('美学构图不支持分析无人像图片物体框位置，数据库写入默认值 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、美学构图日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看：tab_analysis_object');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_object表中不新增该图片数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('美学构图不支持分析无人像图片物体框位置，数据库写入默认值 end');
}

/**
 * 宫格-: [存在人像的图片构图推荐框，包含人像内容]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_011
 * 前置条件
 * 1、准备10张有人像图片
 2、手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition011(dt: Dt) {
  dt.log.i('存在人像的图片构图推荐框，包含人像内容 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、美学构图日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看：tab_analysis_recommendation');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_recommendation表内出现新增数据，recommendation_scale_x，recommendation_scale_y，recommendation_scale_width，recommendation_scale_height内新增的数据包含人像内容');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('存在人像的图片构图推荐框，包含人像内容 end');
}

/**
 * 宫格-: [图片构图推荐框的大小和预期的recommendation_resolution相符]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_012
 * 前置条件
 * 1、准备50张图片
 2、手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition012(dt: Dt) {
  dt.log.i('图片构图推荐框的大小和预期的recommendation_resolution相符 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、美学构图日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看：tab_analysis_recommendation');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_recommendation表内出现新增数据，与recommendation_scale_width，recommendation_scale_height对应，大小相符');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片构图推荐框的大小和预期的recommendation_resolution相符 end');
}

/**
 * 宫格-: [美学构图识别到图片主体时，会进行像素级抠图，并返回结果到segmentation_area字段]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_013
 * 前置条件
 * 1、准备10张有人像图片
 2、手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition013(dt: Dt) {
  dt.log.i('美学构图识别到图片主体时，会进行像素级抠图，并返回结果到segmentation_area字段 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志');

  await dt.sleep();
  dt.log.i('预期结果2、美学构图日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看：tab_analysis_segmentation');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_segmentation表内出现新增数据，segmentation_area字段显示512* 512的单通道灰度图片内容');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('美学构图识别到图片主体时，会进行像素级抠图，并返回结果到segmentation_area字段 end');
}

/**
 * 宫格-: [图库编辑-保存的图片，会更新美学构图结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_015
 * 前置条件
 * 1、手机电量大于50%，温度小于37℃
 2、图片相册有已分析图片10张
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition015(dt: Dt) {
  dt.log.i('图库编辑-保存的图片，会更新美学构图结果 start');
  dt.log.i('STEP 1、图库编辑-保存图片');

  await dt.sleep();
  dt.log.i('STEP 2、充电息屏');

  await dt.sleep();
  dt.log.i('预期结果2、美学构图日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看日志');

  await dt.sleep();
  dt.log.i('预期结果3、编辑-保存的图片在tab_analysis_object，tab_analysis_recommendation，tab_analysis_segmentation表内新增数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、拉取数据库查看：tab_analysis_object，tab_analysis_recommendation，tab_analysis_segmentation');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库编辑-保存的图片，会更新美学构图结果 end');
}

/**
 * 宫格-: [图库编辑-恢复的图片，会更新美学构图结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_016
 * 前置条件
 * 1、手机电量大于50%，温度小于37℃
 2、图片相册有已分析图片10张
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticComposition016(dt: Dt) {
  dt.log.i('图库编辑-恢复的图片，会更新美学构图结果 start');
  dt.log.i('STEP 1、图库编辑-恢复图片');

  await dt.sleep();
  dt.log.i('STEP 2、充电息屏');

  await dt.sleep();
  dt.log.i('预期结果2、美学构图日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看日志');

  await dt.sleep();
  dt.log.i('预期结果3、编辑-恢复的图片在tab_analysis_object，tab_analysis_recommendation，tab_analysis_segmentation表内更新数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、拉取数据库查看：tab_analysis_object，tab_analysis_recommendation，tab_analysis_segmentation');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库编辑-恢复的图片，会更新美学构图结果 end');
}

/**
 * 宫格-: [截屏相册支持美学评分]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_001
 * 前置条件
 * 1、手机电量大于50%，温度小于37℃
 2、截屏相册预置52张图片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore001(dt: Dt) {
  dt.log.i('截屏相册支持美学评分 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""AestheticProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行美学评分日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_aesthetics_score和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_aesthetics_score内出现数据、tab_analysis_total表内aesthetics_score=1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('截屏相册支持美学评分 end');
}

/**
 * 宫格-删除: [最近删除相册不支持美学评分]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_002
 * 前置条件
 * 1、手机电量大于50%，温度小于37℃
 2、最近删除相册预置200张图片+4视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore002(dt: Dt) {
  dt.log.i('最近删除相册不支持美学评分 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""AestheticProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、不进行美学评分日志打印”No data for analysis”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('No data for analysis'));
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_aesthetics_score和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_aesthetics_score内未出现数据、tab_analysis_total表内status=2，aesthetics_score=0');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、从最近删除恢复删除的图片，充电息屏，拉取数据库');

  await dt.sleep();
  dt.log.i('预期结果4、tab_analysis_aesthetics_score未出现数据、tab_analysis_total表内status=1，aesthetics_score=1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除相册不支持美学评分 end');
}

/**
 * 宫格-: [隐藏相册支持美学评分]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_003
 * 前置条件
 * 1、手机电量大于50%，温度小于37℃
 2、隐藏相册预置52张图片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore003(dt: Dt) {
  dt.log.i('隐藏相册支持美学评分 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""AestheticProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行美学评分日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_aesthetics_score和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_aesthetics_score内出现数据、tab_analysis_total表内aesthetics_score=1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册支持美学评分 end');
}

/**
 * 宫格-格式: [支持多种格式图片进行美学评分]
 * GROUP: 宫格 MODULE: 格式TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_004
 * 前置条件
 * 1.预制heic、dng、ARW、wbmp、NEF、CR2、gif等不同类型图片
 2.手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore004(dt: Dt) {
  dt.log.i('支持多种格式图片进行美学评分 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""AestheticProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行美学评分日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看');

  await dt.sleep();
  dt.log.i('预期结果3、aesthetics_score,prob字段出现数据，若不支持的格式在total表中的status=-3');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持多种格式图片进行美学评分 end');
}

/**
 * 宫格-: [同一张图片多次美学评分结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_005
 * 前置条件
 * 1、准备50张图片
 2、手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore005(dt: Dt) {
  dt.log.i('同一张图片多次美学评分结果 start');
  dt.log.i('STEP 1、将准备的图片导入图片相册，充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、拉取数据库查看并记录tab_analysis_aesthetics_score表内aesthetics_score字段');

  await dt.sleep();
  dt.log.i('预期结果2、tab_analysis_aesthetics_score表内aesthetics_score字段有内容4、同一张图片的aesthetics_score分析结果相同');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、重复步骤1、2至少5次');

  await dt.sleep();
  dt.log.i('STEP 4、对比数据库记录的字段');

  await dt.sleep();
  dt.log.i('预期结果4、同一张图片的aesthetics_score分析结果相同');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('同一张图片多次美学评分结果 end');
}

/**
 * 宫格-: [同一个对象不同清晰度美学评分]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_006
 * 前置条件
 * 1、准备同一个对象不同清晰度图片
 2、手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore006(dt: Dt) {
  dt.log.i('同一个对象不同清晰度美学评分 start');
  dt.log.i('STEP 1、将准备的图片导入图片相册，充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、拉取数据库查看并记录tab_analysis_aesthetics_score表内aesthetics_score字段');

  await dt.sleep();
  dt.log.i('STEP 3、对比数据库记录的字段');

  await dt.sleep();
  dt.log.i('预期结果3、清晰度高的图片评分较高');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('同一个对象不同清晰度美学评分 end');
}

/**
 * 宫格-: [同一个对象黑白和彩色美学评分]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_007
 * 前置条件
 * 1、准备同一个对象黑白灰和彩色图片
 2、手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore007(dt: Dt) {
  dt.log.i('同一个对象黑白和彩色美学评分 start');
  dt.log.i('STEP 1、将准备的图片导入图片相册，充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、拉取数据库查看并记录tab_analysis_aesthetics_score表内aesthetics_score字段');

  await dt.sleep();
  dt.log.i('STEP 3、对比数据库记录的字段');

  await dt.sleep();
  dt.log.i('预期结果3、色彩丰富的图片评分较高');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('同一个对象黑白和彩色美学评分 end');
}

/**
 * 宫格-: [同一个对象不同对焦美学评分]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_008
 * 前置条件
 * 1、准备同一个对象不同对焦情况的图片
 2、手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore008(dt: Dt) {
  dt.log.i('同一个对象不同对焦美学评分 start');
  dt.log.i('STEP 1、将准备的图片导入图片相册，充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、拉取数据库查看并记录tab_analysis_aesthetics_score表内aesthetics_score字段');

  await dt.sleep();
  dt.log.i('STEP 3、对比数据库记录的字段');

  await dt.sleep();
  dt.log.i('预期结果3、对焦准确的图片评分较高');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('同一个对象不同对焦美学评分 end');
}

/**
 * 宫格-: [同一个对象不同景深美学评分]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_009
 * 前置条件
 * 1、准备同一个对象不同景深的图片
 2、手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore009(dt: Dt) {
  dt.log.i('同一个对象不同景深美学评分 start');
  dt.log.i('STEP 1、将准备的图片导入图片相册，充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、拉取数据库查看并记录tab_analysis_aesthetics_score表内aesthetics_score字段');

  await dt.sleep();
  dt.log.i('STEP 3、对比数据库记录的字段');

  await dt.sleep();
  dt.log.i('预期结果3、清晰度高的图片评分较高');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('同一个对象不同景深美学评分 end');
}

/**
 * 宫格-: [相同类别构图简洁和构图复杂美学评分]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_011
 * 前置条件
 * 1、准备相同类别构图简洁和构图复杂的图片
 2、手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore011(dt: Dt) {
  dt.log.i('相同类别构图简洁和构图复杂美学评分 start');
  dt.log.i('STEP 1、将准备的图片导入图片相册，充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、拉取数据库查看并记录tab_analysis_aesthetics_score表内aesthetics_score字段');

  await dt.sleep();
  dt.log.i('STEP 3、对比数据库记录的字段');

  await dt.sleep();
  dt.log.i('预期结果3、构图简洁的图片评分较高');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相同类别构图简洁和构图复杂美学评分 end');
}

/**
 * 宫格-: [相同类别对称和不对称图案的美学评分]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_012
 * 前置条件
 * 1、准备相同类别对称和不对称图案的图片
 2、手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore012(dt: Dt) {
  dt.log.i('相同类别对称和不对称图案的美学评分 start');
  dt.log.i('STEP 1、将准备的图片导入图片相册，充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、拉取数据库查看并记录tab_analysis_aesthetics_score表内aesthetics_score字段');

  await dt.sleep();
  dt.log.i('STEP 3、对比数据库记录的字段');

  await dt.sleep();
  dt.log.i('预期结果3、有对称图案的图片评分较高');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相同类别对称和不对称图案的美学评分 end');
}

/**
 * 宫格-: [相同背景、主体处在图片不同位置的美学评分]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_014
 * 前置条件
 * 1、准备相同背景、主体处在图片不同位置的图片
 2、手机电量大于50%，温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore014(dt: Dt) {
  dt.log.i('相同背景、主体处在图片不同位置的美学评分 start');
  dt.log.i('STEP 1、将准备的图片导入图片相册，充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、拉取数据库查看并记录tab_analysis_aesthetics_score表内aesthetics_score字段');

  await dt.sleep();
  dt.log.i('STEP 3、对比数据库记录的字段');

  await dt.sleep();
  dt.log.i('预期结果3、主体处在图片井字格顶点的图片评分较高');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相同背景、主体处在图片不同位置的美学评分 end');
}

/**
 * 宫格-: [图库编辑-保存的图片，会更新美学评分结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_016
 * 前置条件
 * 1、手机电量大于50%，温度小于37℃
 2、图片相册有已分析图片10张
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore016(dt: Dt) {
  dt.log.i('图库编辑-保存的图片，会更新美学评分结果 start');
  dt.log.i('STEP 1、图库编辑后右上角点击保存图片');

  await dt.sleep();
  dt.log.i('STEP 2、充电息屏');

  await dt.sleep();
  dt.log.i('预期结果2、美学评分日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看日志');

  await dt.sleep();
  dt.log.i('预期结果3、编辑-保存的图片在tab_analysis_aesthetics_score表内新增数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、拉取数据库查看：tab_analysis_aesthetics_score，大搜数据库');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库编辑-保存的图片，会更新美学评分结果 end');
}
