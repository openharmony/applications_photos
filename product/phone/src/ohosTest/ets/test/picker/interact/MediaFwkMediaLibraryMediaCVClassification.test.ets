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


export default function aPPFWKMediaFwkMediaLibraryMediaCVClassification002Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('APPFWKMediaFwkMediaLibraryMediaCVClassification002Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAPPFWKMediaFwkMediaLibraryMediaCVClassification002').init();
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVClassification002 start');
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVClassification002 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('APPFWKMediaFwkMediaLibraryMediaCVClassification002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [最近删除相册不生成事物分类] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_002
      await aPPFWKMediaFwkMediaLibraryMediaCVClassification002(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore017', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库编辑-恢复的图片，会更新美学评分结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_017
      await aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore017(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVClassification001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [截图照片支持事物分类] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_001
      await aPPFWKMediaFwkMediaLibraryMediaCVClassification001(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVClassification003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [隐藏相册支持事物分类] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_003
      await aPPFWKMediaFwkMediaLibraryMediaCVClassification003(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVClassification004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [支持多种格式图片进行事物分类] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_004
      await aPPFWKMediaFwkMediaLibraryMediaCVClassification004(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVClassification005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [导入风景图片，查看分类标签] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_005
      await aPPFWKMediaFwkMediaLibraryMediaCVClassification005(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVClassification006', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [导入有“汽车”的图片，查看分类标签（大类+小类）] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_006
      await aPPFWKMediaFwkMediaLibraryMediaCVClassification006(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVClassification007', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [导入各100张不同类别的图片，查看分类的召回率] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_007
      await aPPFWKMediaFwkMediaLibraryMediaCVClassification007(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVClassification008', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [导入各100张不同类别的图片，查看分类的准确率] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_008
      await aPPFWKMediaFwkMediaLibraryMediaCVClassification008(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVClassification009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [支持多种格式图片进行自然语义分析] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_009
      await aPPFWKMediaFwkMediaLibraryMediaCVClassification009(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVClassification010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [云图支持分类标签] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_010
      await aPPFWKMediaFwkMediaLibraryMediaCVClassification010(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVClassification011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库编辑-保存的图片，会更新分类标签结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_011
      await aPPFWKMediaFwkMediaLibraryMediaCVClassification011(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVClassification012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库编辑-恢复的图片，会更新分类标签结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_012
      await aPPFWKMediaFwkMediaLibraryMediaCVClassification012(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceCluster003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [特征提取的人像出现结果，可以拉起人像聚类，进行人像聚类] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_003
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster003(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceCluster005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [云图支持人像聚类] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_005
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster005(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceCluster006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [截屏相册支持人像聚类] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_006
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster006(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceCluster007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [最近删除相册不支持人像聚类] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_007
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster007(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceCluster008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [隐藏相册支持人像聚类] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_008
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster008(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceCluster010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [大于等于三张同一人像的人脸形成一个聚类] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_010
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster010(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceCluster011', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [两张及以下的同一人像的人脸无法形成聚类] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_011
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster011(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceCluster012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库编辑-保存的图片，会更新人像聚类结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_012
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster012(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceCluster013', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库编辑-恢复的图片，会更新人像聚类结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_013
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster013(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceFeature001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [新导入有单个人像的图片，进行人像特征提取，结果写入数据库] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_001
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature001(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceFeature002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [新导入有多个人像的图片，进行人像特征提取，结果写入数据库] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_002
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature002(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceFeature003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [新导入无人像的图片，图片不进行人像特征提取，结果写入数据库] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_003
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature003(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceFeature004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [云图支持人像特征提取] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_004
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature004(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachAPPFWKMediaFwkMediaLibraryMediaCVClassification002').init();
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVClassification002 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVClassification002 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllAPPFWKMediaFwkMediaLibraryMediaCVClassification002').init();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVClassification002 start');
      await Exit.browser();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVClassification002 finish');
    });
  });
}

/**
 * 宫格-删除: [最近删除相册不生成事物分类]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_002
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、最近删除相册预置200张图片+4视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVClassification002(dt: Dt) {
  dt.log.i('最近删除相册不生成事物分类 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""LabelDetectProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行事物分类日志打印”No data for analysis”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('No data for analysis'));
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_label和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_label内未出现数据、tab_analysis_total表内status=2，label=0');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、从最近删除恢复删除的图片，充电息屏，拉取数据库');

  await dt.sleep();
  dt.log.i('预期结果4、tab_analysis_label未出现数据、tab_analysis_total表内status=1，label=1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除相册不生成事物分类 end');
}

/**
 * 宫格-: [图库编辑-恢复的图片，会更新美学评分结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_017
 * 前置条件
 * 1、手机电量大于50%，温度小于37℃
 2、图片相册有已分析图片10张
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVAestheticsScore017(dt: Dt) {
  dt.log.i('图库编辑-恢复的图片，会更新美学评分结果 start');
  dt.log.i('STEP 1、图库编辑-恢复图片');

  await dt.sleep();
  dt.log.i('STEP 2、充电息屏');

  await dt.sleep();
  dt.log.i('预期结果2、美学评分日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看日志');

  await dt.sleep();
  dt.log.i('预期结果3、编辑-恢复的图片在tab_analysis_aesthetics_score表内更新数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、拉取数据库查看：tab_analysis_aesthetics_score，大搜数据库');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库编辑-恢复的图片，会更新美学评分结果 end');
}

/**
 * 宫格-: [截图照片支持事物分类]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_001
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、截屏相册预置50张图片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVClassification001(dt: Dt) {
  dt.log.i('截图照片支持事物分类 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""LabelDetectProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行事物分类日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_label和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_label内出现数据、tab_analysis_total表内label=1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('截图照片支持事物分类 end');
}

/**
 * 宫格-: [隐藏相册支持事物分类]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_003
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、隐藏相册预置50张图片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVClassification003(dt: Dt) {
  dt.log.i('隐藏相册支持事物分类 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""LabelDetectProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行事物分类日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_label和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_label内出现数据、tab_analysis_total表内label=1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册支持事物分类 end');
}

/**
 * 宫格-格式: [支持多种格式图片进行事物分类]
 * GROUP: 宫格 MODULE: 格式TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_004
 * 前置条件
 * 1.预制heic、dng、ARW、wbmp、NEF、CR2、gif等不同类型图片
 2.手机电量大于50%，手机温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVClassification004(dt: Dt) {
  dt.log.i('支持多种格式图片进行事物分类 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""LabelDetectProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行事物分类日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_label表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、category_id,sub_label,prob字段出现数据，若不支持的格式在total表中的status=-3');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持多种格式图片进行事物分类 end');
}

/**
 * 宫格-: [导入风景图片，查看分类标签]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_005
 * 前置条件
 * 1、准备200张风景图片
 2、手机电量大于50%，手机温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVClassification005(dt: Dt) {
  dt.log.i('导入风景图片，查看分类标签 start');
  dt.log.i('STEP 1、将准备的图片导入图片相册，充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、拉取数据库查看tab_analysis_label表内category_id字段内容');

  await dt.sleep();
  dt.log.i('预期结果2、category_id=2');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('导入风景图片，查看分类标签 end');
}

/**
 * 宫格-: [导入有“汽车”的图片，查看分类标签（大类+小类）]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_006
 * 前置条件
 * 1、准备50张有“汽车”的图片
 2、手机电量大于50%，手机温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVClassification006(dt: Dt) {
  dt.log.i('导入有“汽车”的图片，查看分类标签（大类+小类） start');
  dt.log.i('STEP 1、将准备的图片导入图片相册，充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、拉取数据库查看tab_analysis_label表内category_id,sub_label字段内容');

  await dt.sleep();
  dt.log.i('预期结果2、category_id=8，sub_label=[8,12]数据库关注如下参数，有一个命中就表示标签分类已命中category==8 || sublabel has 8 || sublabel has 12');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('导入有“汽车”的图片，查看分类标签（大类+小类） end');
}

/**
 * 宫格-: [导入各100张不同类别的图片，查看分类的召回率]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_007
 * 前置条件
 * 1、准备不同类别图片各100张，如美食，风景，文档，运动，交通工具，生日蛋糕，高山，花朵，夜景，建筑，聚餐，猫咪，大熊猫，飞机
 2、手机电量大于50%，手机温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVClassification007(dt: Dt) {
  dt.log.i('导入各100张不同类别的图片，查看分类的召回率 start');
  dt.log.i('STEP 1、将准备的图片导入图片相册，充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、拉取数据库查看并记录tab_analysis_label表内sub_label字段');

  await dt.sleep();
  dt.log.i('STEP 3、对比数据库记录的字段');

  await dt.sleep();
  dt.log.i('预期结果3、统计sub_label字段返回为对应类别ID的图片数量，计算召回率（sub_label字段返回为对应类别ID的图片数量/图片的总数）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、重复步骤1、2、3至少3次');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('导入各100张不同类别的图片，查看分类的召回率 end');
}

/**
 * 宫格-: [导入各100张不同类别的图片，查看分类的准确率]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_008
 * 前置条件
 * 1、准备不同类别图片各100张有的图片，如美食，风景，文档，运动，交通工具，生日蛋糕，高山，花朵，夜景，建筑，聚餐，猫咪，大熊猫，飞机
 2、手机电量大于50%，手机温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVClassification008(dt: Dt) {
  dt.log.i('导入各100张不同类别的图片，查看分类的准确率 start');
  dt.log.i('STEP 1、将准备的图片导入图片相册，充电息屏分析');

  await dt.sleep();
  dt.log.i('预期结果1）sub_label字段返回为对应类别ID的图片数量2）在1）图片的内容中是真正是相对应的类别的图片，计算准确率（文字信息显示正确的图片/显示文字信息的图片）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、拉取数据库查看并记录tab_analysis_label表内sub_label字段');

  await dt.sleep();
  dt.log.i('STEP 3、对比数据库记录的字段');

  await dt.sleep();
  dt.log.i('预期结果3、统计1）sub_label字段返回为对应类别ID的图片数量2）在1）图片的内容中是真正是相对应的类别的图片，计算准确率（文字信息显示正确的图片/显示文字信息的图片）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、重复步骤1、2、3至少3次');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('导入各100张不同类别的图片，查看分类的准确率 end');
}

/**
 * 宫格-格式: [支持多种格式图片进行自然语义分析]
 * GROUP: 宫格 MODULE: 格式TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_009
 * 前置条件
 * 1.预制heic、dng、ARW、wbmp、NEF、CR2、gif等不同类型图片
 2.手机电量大于50%，手机温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVClassification009(dt: Dt) {
  dt.log.i('支持多种格式图片进行自然语义分析 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""LabelDetectProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行事物分类日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看');

  await dt.sleep();
  dt.log.i('预期结果3、feature,sim_result字段出现数据，若不支持的格式在total表中的status=-3');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持多种格式图片进行自然语义分析 end');
}

/**
 * 宫格-: [云图支持分类标签]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_010
 * 前置条件
 * 1、手机登录已云账号，同步云端图片
 2、手机电量大于50%，手机温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVClassification010(dt: Dt) {
  dt.log.i('云图支持分类标签 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""LabelDetectProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行事物分类日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_label和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_label内出现数据、tab_analysis_total表内status=1，label=1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云图支持分类标签 end');
}

/**
 * 宫格-: [图库编辑-保存的图片，会更新分类标签结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_011
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、图片相册有已分析图片10张
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVClassification011(dt: Dt) {
  dt.log.i('图库编辑-保存的图片，会更新分类标签结果 start');
  dt.log.i('STEP 1、图库编辑后右上角点击保存图片');

  await dt.sleep();
  dt.log.i('STEP 2、充电息屏');

  await dt.sleep();
  dt.log.i('预期结果2、分类标签日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看日志');

  await dt.sleep();
  dt.log.i('预期结果3、编辑-保存的图片在tab_analysis_label表内新增数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、拉取数据库查看：tab_analysis_label，大搜数据库');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库编辑-保存的图片，会更新分类标签结果 end');
}

/**
 * 宫格-: [图库编辑-恢复的图片，会更新分类标签结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Classification_012
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、图片相册有已分析图片10张
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVClassification012(dt: Dt) {
  dt.log.i('图库编辑-恢复的图片，会更新分类标签结果 start');
  dt.log.i('STEP 1、图库编辑-恢复图片');

  await dt.sleep();
  dt.log.i('STEP 2、充电息屏');

  await dt.sleep();
  dt.log.i('预期结果2、分类标签日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看日志');

  await dt.sleep();
  dt.log.i('预期结果3、编辑-恢复的图片在tab_analysis_label表内更新数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、拉取数据库查看：tab_analysis_label，大搜数据库');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库编辑-恢复的图片，会更新分类标签结果 end');
}

/**
 * 宫格-: [特征提取的人像出现结果，可以拉起人像聚类，进行人像聚类]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_003
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、图片相册预置存在人像的若干图片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster003(dt: Dt) {
  dt.log.i('特征提取的人像出现结果，可以拉起人像聚类，进行人像聚类 start');
  dt.log.i('STEP 1、充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep ""FaceClusterProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行人像聚类日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_image_face、tab_analysis_face_tag和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total表内字段，聚类成功face=3，tab_analysis_image_face中更新tag_id，tab_analysis_face_tag表更新center_features、tag_version和count');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('特征提取的人像出现结果，可以拉起人像聚类，进行人像聚类 end');
}

/**
 * 宫格-: [云图支持人像聚类]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_005
 * 前置条件
 * 1、手机登录已云账号，同步云端图片
 2、手机电量大于50%，手机温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster005(dt: Dt) {
  dt.log.i('云图支持人像聚类 start');
  dt.log.i('STEP 1、充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep ""FaceClusterProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行人像聚类日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_image_face、tab_analysis_face_tag和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total表内字段，聚类成功face=3，tab_analysis_image_face中更新tag_id，tab_analysis_face_tag表更新center_features、tag_version和count');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云图支持人像聚类 end');
}

/**
 * 宫格-: [截屏相册支持人像聚类]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_006
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、截屏相册预置56张图片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster006(dt: Dt) {
  dt.log.i('截屏相册支持人像聚类 start');
  dt.log.i('STEP 1、充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep ""FaceClusterProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行人像聚类日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_image_face、tab_analysis_face_tag和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total表内face=3，tab_analysis_image_face新增数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('截屏相册支持人像聚类 end');
}

/**
 * 宫格-删除: [最近删除相册不支持人像聚类]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_007
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、最近删除相册预置50张图片+1视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster007(dt: Dt) {
  dt.log.i('最近删除相册不支持人像聚类 start');
  dt.log.i('STEP 1、充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep ""FaceClusterProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行人像聚类日志打印NO data for vision to analysis!');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_image_face、tab_analysis_face_tag和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total表内status=2，face=0，tab_analysis_image_face无新增数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、从最近删除相册恢复删除的图片，充电息屏，拉取数据库');

  await dt.sleep();
  dt.log.i('预期结果4、tab_analysis_total表内status=1，face=1，tab_analysis_image_face新增数据”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text(''));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除相册不支持人像聚类 end');
}

/**
 * 宫格-: [隐藏相册支持人像聚类]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_008
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、隐藏相册预置56张图片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster008(dt: Dt) {
  dt.log.i('隐藏相册支持人像聚类 start');
  dt.log.i('STEP 1、充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep ""FaceClusterProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行人像聚类日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_image_face、tab_analysis_face_tag和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total表内face=3，tab_analysis_image_face新增数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册支持人像聚类 end');
}

/**
 * 宫格-: [大于等于三张同一人像的人脸形成一个聚类]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_010
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、图片相册预置若干图片，人像总数在200张以上，其中同一人像的图片为三张
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster010(dt: Dt) {
  dt.log.i('大于等于三张同一人像的人脸形成一个聚类 start');
  dt.log.i('STEP 1、充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep ""FaceClusterProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行人像聚类日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_image_face、tab_analysis_face_tag和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total表内字段，聚类成功face=3，tab_analysis_image_face中更新tag_id，tab_analysis_face_tag表更新center_features、tag_version和count');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大于等于三张同一人像的人脸形成一个聚类 end');
}

/**
 * 宫格-: [两张及以下的同一人像的人脸无法形成聚类]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_011
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、图片相册预置若干图片，人像总数在200张以上，其中同一人像的图片为两张
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster011(dt: Dt) {
  dt.log.i('两张及以下的同一人像的人脸无法形成聚类 start');
  dt.log.i('STEP 1、充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep ""FaceClusterProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行人像聚类日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_image_face、tab_analysis_face_tag和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total表内字段，未聚类成功face=2正常零散人脸没有聚类成功 face=4 是正常的');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('两张及以下的同一人像的人脸无法形成聚类 end');
}

/**
 * 宫格-: [图库编辑-保存的图片，会更新人像聚类结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_012
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、图片相册有已分析图片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster012(dt: Dt) {
  dt.log.i('图库编辑-保存的图片，会更新人像聚类结果 start');
  dt.log.i('STEP 1、图库编辑后右上角点击保存图片');

  await dt.sleep();
  dt.log.i('STEP 2、充电息屏');

  await dt.sleep();
  dt.log.i('预期结果2、人像聚类日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看日志');

  await dt.sleep();
  dt.log.i('预期结果3、编辑-保存的图片在tab_analysis_image_face、tab_analysis_face_tag表内新增数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、拉取数据库查看：tab_analysis_image_face、tab_analysis_face_tag，大搜数据库');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库编辑-保存的图片，会更新人像聚类结果 end');
}

/**
 * 宫格-: [图库编辑-恢复的图片，会更新人像聚类结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceCluster_013
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、图片相册有已分析图片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceCluster013(dt: Dt) {
  dt.log.i('图库编辑-恢复的图片，会更新人像聚类结果 start');
  dt.log.i('STEP 1、图库编辑-恢复图片');

  await dt.sleep();
  dt.log.i('STEP 2、充电息屏');

  await dt.sleep();
  dt.log.i('预期结果2、人像聚类日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看日志');

  await dt.sleep();
  dt.log.i('预期结果3、编辑-恢复的图片在tab_analysis_image_face、tab_analysis_face_tag表内更新数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、拉取数据库查看：tab_analysis_image_face、tab_analysis_face_tag，大搜数据库');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库编辑-恢复的图片，会更新人像聚类结果 end');
}

/**
 * 宫格-: [新导入有单个人像的图片，进行人像特征提取，结果写入数据库]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_001
 * 前置条件
 * 1、准备10张可生成人像的单人照片；
 2、手机电量大于50%，手机温度小于37℃；
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature001(dt: Dt) {
  dt.log.i('新导入有单个人像的图片，进行人像特征提取，结果写入数据库 start');
  dt.log.i('STEP 1、充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、拉取数据库查看tab_analysis_image_face和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果2、tab_analysis_image_face的features、features_version出现数据total_faces=1、tag_id字段为ser字符串显示，tab_analysis_total表内status=1，face=3或4');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('新导入有单个人像的图片，进行人像特征提取，结果写入数据库 end');
}

/**
 * 宫格-: [新导入有多个人像的图片，进行人像特征提取，结果写入数据库]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_002
 * 前置条件
 * 1、准备10张可生成人像的多人照片；
 2、手机电量大于50%，手机温度小于37℃；
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature002(dt: Dt) {
  dt.log.i('新导入有多个人像的图片，进行人像特征提取，结果写入数据库 start');
  dt.log.i('STEP 1、充电息屏分析3、拉取数据库查看tab_analysis_image_face和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果2、tab_analysis_image_face的features、features_version出现数据total_faces=1、tag_id字段为ser字符串显示，tab_analysis_total表内status=1，face=3或4');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_image_face和tab_analysis_total表内各字段');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('新导入有多个人像的图片，进行人像特征提取，结果写入数据库 end');
}

/**
 * 宫格-: [新导入无人像的图片，图片不进行人像特征提取，结果写入数据库]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_003
 * 前置条件
 * 1、准备10张无人像的照片；
 2、手机电量大于50%，手机温度小于37℃；
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature003(dt: Dt) {
  dt.log.i('新导入无人像的图片，图片不进行人像特征提取，结果写入数据库 start');
  dt.log.i('STEP 1、充电息屏分析4、拉取数据库查看tab_analysis_image_face和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果2、tab_analysis_image_face没有新增的数据，tab_analysis_total表内status=1，face=-2');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、拉取数据库查看tab_analysis_image_face和tab_analysis_total表内各字段');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('新导入无人像的图片，图片不进行人像特征提取，结果写入数据库 end');
}

/**
 * 宫格-: [云图支持人像特征提取]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_004
 * 前置条件
 * 1、手机登录已云账号，同步云端图片
 2、手机电量大于50%，手机温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature004(dt: Dt) {
  dt.log.i('云图支持人像特征提取 start');
  dt.log.i('STEP 1、充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep ""FaceFeatureProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行人像特征提取日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_image_face和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total表内status=1，已提取face=2，有人像的图片在特征提取后会在tab_analysis_image_face的features、features_version字段新增数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云图支持人像特征提取 end');
}
