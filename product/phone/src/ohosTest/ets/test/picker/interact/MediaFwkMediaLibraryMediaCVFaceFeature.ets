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


export default function aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature005Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('APPFWKMediaFwkMediaLibraryMediaCVFaceFeature005Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAPPFWKMediaFwkMediaLibraryMediaCVFaceFeature005').init();
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVFaceFeature005 start');
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVFaceFeature005 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('APPFWKMediaFwkMediaLibraryMediaCVFaceFeature005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [截屏相册支持人像特征提取] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_005
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature005(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceFeature006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [最近删除相册不支持人像特征提取] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_006
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature006(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceFeature007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [隐藏相册支持人像特征提取] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_007
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature007(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceFeature009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库编辑-保存的图片，会更新人像特征提取结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_009
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature009(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceFeature010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库编辑-恢复的图片，会更新人像特征提取结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_010
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature010(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceRecognition001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [新导入有单个人像的图片，进行人像检测，结果写入数据库] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_001
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition001(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceRecognition002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [新导入有多个人像的图片，进行人像检测，结果写入数据库] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_002
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition002(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceRecognition003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [新导入无人像的图片，进行人像检测，结果写入数据库] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_003
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition003(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceRecognition004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [云图支持人像检测] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_004
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition004(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceRecognition005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [截屏相册支持人像检测] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_005
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition005(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceRecognition006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [最近删除相册不支持人像检测] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_006
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition006(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceRecognition007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [隐藏相册支持人像检测] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_007
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition007(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceRecognition009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库编辑-保存的图片，会更新人像检测结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_009
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition009(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVFaceRecognition010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库编辑-恢复的图片，会更新人像检测结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_010
      await aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition010(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-解析用例: [云图支持地理位置解析] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_001
      await aPPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation001(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-解析用例: [隐藏相册支持地理位置解析，但不显示] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_003
      await aPPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation003(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-解析用例: [最近删除支持地理位置解析，但不显示] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_004
      await aPPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation004(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-解析用例: [图片编辑-保存/编辑-恢复后，保留原始地理位置信息] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_007
      await aPPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation007(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation008', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-解析用例: [导入带经纬度的图片，可以正确解析出地理位置信息] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_008
      await aPPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation008(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-解析用例: [地点解析完成，无数据待分析，分析服务停止，结果返回数据库] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_009
      await aPPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation009(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-解析用例: [大数据量下，图片地点解析分批进行，2000图片一批次] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_013
      await aPPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation013(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHead001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库编辑保存的图片，会更新人头、宠物头检测结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Head_001
      await aPPFWKMediaFwkMediaLibraryMediaCVHead001(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHead002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [云图支持人头、宠物头检测] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Head_002
      await aPPFWKMediaFwkMediaLibraryMediaCVHead002(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHead003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [截屏相册支持人头、宠物头检测] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Head_003
      await aPPFWKMediaFwkMediaLibraryMediaCVHead003(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHead004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [隐藏相册支持人头、宠物头检测] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Head_004
      await aPPFWKMediaFwkMediaLibraryMediaCVHead004(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHead005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [最近删除不支持人头、宠物头检测] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Head_005
      await aPPFWKMediaFwkMediaLibraryMediaCVHead005(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachAPPFWKMediaFwkMediaLibraryMediaCVFaceFeature005').init();
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVFaceFeature005 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVFaceFeature005 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllAPPFWKMediaFwkMediaLibraryMediaCVFaceFeature005').init();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVFaceFeature005 start');
      await Exit.browser();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVFaceFeature005 finish');
    });
  });
}

/**
 * 宫格-: [截屏相册支持人像特征提取]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_005
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、截屏相册预置55张图片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature005(dt: Dt) {
  dt.log.i('截屏相册支持人像特征提取 start');
  dt.log.i('STEP 1、充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep ""FaceFeatureProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行人像特征提取日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_image_face和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total表内face=2，tab_analysis_image_face新增数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('截屏相册支持人像特征提取 end');
}

/**
 * 宫格-删除: [最近删除相册不支持人像特征提取]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_006
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、最近删除相册预置50张图片+1视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature006(dt: Dt) {
  dt.log.i('最近删除相册不支持人像特征提取 start');
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep """"FaceFeatureProcessor start""""');

  await dt.sleep();
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_image_face和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total表内status=2，face=0，tab_analysis_image_face无新增数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、从最近删除相册恢复删除的图片，充电息屏，拉取数据库""');

  await dt.sleep();
  dt.log.i('预期结果4、tab_analysis_total表内status=1，face=1，tab_analysis_image_face新增数据”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text(''));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除相册不支持人像特征提取 end');
}

/**
 * 宫格-: [隐藏相册支持人像特征提取]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_007
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、隐藏相册预置55张图片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature007(dt: Dt) {
  dt.log.i('隐藏相册支持人像特征提取 start');
  dt.log.i('STEP 1、充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep ""FaceFeatureProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行人像特征提取日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_image_face和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total表内face=2，tab_analysis_image_face新增数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册支持人像特征提取 end');
}

/**
 * 宫格-: [图库编辑-保存的图片，会更新人像特征提取结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_009
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、图片相册有已分析图片10张
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature009(dt: Dt) {
  dt.log.i('图库编辑-保存的图片，会更新人像特征提取结果 start');
  dt.log.i('STEP 1、图库编辑后右上角点击保存图片');

  await dt.sleep();
  dt.log.i('STEP 2、充电息屏');

  await dt.sleep();
  dt.log.i('预期结果2、人像特征提取日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看日志');

  await dt.sleep();
  dt.log.i('预期结果3、编辑-保存的图片在tab_analysis_image_face表内新增数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、拉取数据库查看：tab_analysis_image_face，大搜数据库');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库编辑-保存的图片，会更新人像特征提取结果 end');
}

/**
 * 宫格-: [图库编辑-恢复的图片，会更新人像特征提取结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceFeature_010
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、图片相册有已分析图片10张
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceFeature010(dt: Dt) {
  dt.log.i('图库编辑-恢复的图片，会更新人像特征提取结果 start');
  dt.log.i('STEP 1、图库编辑-恢复图片');

  await dt.sleep();
  dt.log.i('STEP 2、充电息屏');

  await dt.sleep();
  dt.log.i('预期结果2、人像特征提取日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看日志');

  await dt.sleep();
  dt.log.i('预期结果3、编辑-恢复的图片在tab_analysis_image_face表内更新数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、拉取数据库查看：tab_analysis_image_face，大搜数据库');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库编辑-恢复的图片，会更新人像特征提取结果 end');
}

/**
 * 宫格-: [新导入有单个人像的图片，进行人像检测，结果写入数据库]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_001
 * 前置条件
 * 1、准备10张可生成人像的单人照片；
 2、手机电量大于50%，手机温度小于37℃；
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition001(dt: Dt) {
  dt.log.i('新导入有单个人像的图片，进行人像检测，结果写入数据库 start');
  dt.log.i('STEP 1、充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、拉取数据库查看tab_analysis_image_face和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果2、tab_analysis_image_face的file_id、face_id、scale_x、scale_y、scale_width、scale_height、landmarks、pitchyaw、roll、probface_version出现数据total_faces=1、tag_id=-1，tab_analysis_total表内status=1，face=1看表注意事项：1、最终状态是face=3，tag_id回填的值，face=1是中间状态比较难捕捉到，经过1、2后最终到32、tag_id不一定是-1，一般有唯一的一串数字：如  tag_id=ser 173891652241079100）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('新导入有单个人像的图片，进行人像检测，结果写入数据库 end');
}

/**
 * 宫格-: [新导入有多个人像的图片，进行人像检测，结果写入数据库]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_002
 * 前置条件
 * 1、准备10张可生成人像的多人照片；
 2、手机电量大于50%，手机温度小于37℃；
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition002(dt: Dt) {
  dt.log.i('新导入有多个人像的图片，进行人像检测，结果写入数据库 start');
  dt.log.i('STEP 1、充电息屏分析3、拉取数据库查看tab_analysis_image_face和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果2、tab_analysis_image_face内出现数据total_faces大于1、tag_id=-1，tab_analysis_total表内status=1，face=1看表注意事项：1、最终状态是face=3，tag_id回填的值，face=1是中间状态比较难捕捉到，经过1、2后最终到32、tag_id不一定是-1，一般有唯一的一串数字：如  tag_id=ser 173891652241079100）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_image_face和tab_analysis_total表内各字段');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('新导入有多个人像的图片，进行人像检测，结果写入数据库 end');
}

/**
 * 宫格-: [新导入无人像的图片，进行人像检测，结果写入数据库]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_003
 * 前置条件
 * 1、准备10张无人像的照片；
 2、手机电量大于50%，手机温度小于37℃；
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition003(dt: Dt) {
  dt.log.i('新导入无人像的图片，进行人像检测，结果写入数据库 start');
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
  dt.log.i('新导入无人像的图片，进行人像检测，结果写入数据库 end');
}

/**
 * 宫格-: [云图支持人像检测]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_004
 * 前置条件
 * 1、手机登录已云账号，同步云端图片
 2、手机电量大于50%，手机温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition004(dt: Dt) {
  dt.log.i('云图支持人像检测 start');
  dt.log.i('STEP 1、充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep ""FaceRecognitionProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行人像检测日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_image_face和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total表内status=1，已检测face=1，有人像的图片检测后会在tab_analysis_image_face新增数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云图支持人像检测 end');
}

/**
 * 宫格-: [截屏相册支持人像检测]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_005
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、截屏相册预置54张图片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition005(dt: Dt) {
  dt.log.i('截屏相册支持人像检测 start');
  dt.log.i('STEP 1、充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep ""FaceRecognitionProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行人像检测日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_image_face和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total表内face=1，tab_analysis_image_face新增数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('截屏相册支持人像检测 end');
}

/**
 * 宫格-删除: [最近删除相册不支持人像检测]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_006
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、最近删除相册预置50张图片+1视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition006(dt: Dt) {
  dt.log.i('最近删除相册不支持人像检测 start');
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep """"FaceRecognitionProcessor start""""');

  await dt.sleep();
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_image_face和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total表内status=2，face=0，tab_analysis_image_face无新增数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、从最近删除相册恢复删除的图片，充电息屏，拉取数据库""');

  await dt.sleep();
  dt.log.i('预期结果4、tab_analysis_total表内status=1，face=1tab_analysis_image_face新增数据”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text(''));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除相册不支持人像检测 end');
}

/**
 * 宫格-: [隐藏相册支持人像检测]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_007
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、隐藏相册预置54张图片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition007(dt: Dt) {
  dt.log.i('隐藏相册支持人像检测 start');
  dt.log.i('STEP 1、充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep ""FaceRecognitionProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行人像检测日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_image_face和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_total表内face=1，tab_analysis_image_face新增数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册支持人像检测 end');
}

/**
 * 宫格-: [图库编辑-保存的图片，会更新人像检测结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_009
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、图片相册有已分析图片10张
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition009(dt: Dt) {
  dt.log.i('图库编辑-保存的图片，会更新人像检测结果 start');
  dt.log.i('STEP 1、图库编辑后右上角点击保存图片');

  await dt.sleep();
  dt.log.i('STEP 2、充电息屏');

  await dt.sleep();
  dt.log.i('预期结果2、人像检测日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看日志');

  await dt.sleep();
  dt.log.i('预期结果3、编辑-保存的图片在tab_analysis_image_face表内新增数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、拉取数据库查看：tab_analysis_image_face，大搜数据库');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库编辑-保存的图片，会更新人像检测结果 end');
}

/**
 * 宫格-: [图库编辑-恢复的图片，会更新人像检测结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_FaceRecognition_010
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、图片相册有已分析图片10张
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVFaceRecognition010(dt: Dt) {
  dt.log.i('图库编辑-恢复的图片，会更新人像检测结果 start');
  dt.log.i('STEP 1、图库编辑-恢复图片');

  await dt.sleep();
  dt.log.i('STEP 2、充电息屏');

  await dt.sleep();
  dt.log.i('预期结果2、人像检测日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看日志');

  await dt.sleep();
  dt.log.i('预期结果3、编辑-恢复的图片在tab_analysis_image_face表内更新数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、拉取数据库查看：tab_analysis_image_face，大搜数据库');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库编辑-恢复的图片，会更新人像检测结果 end');
}

/**
 * 宫格-解析: [云图支持地理位置解析]
 * GROUP: 宫格 MODULE: 解析TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_001
 * 前置条件
 * 1、手机登录已云账号，同步云端图片
 2、手机电量大于50%，手机温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation001(dt: Dt) {
  dt.log.i('云图支持地理位置解析 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志，关键字：location，geo');

  await dt.sleep();
  dt.log.i('预期结果2、地理位置解析日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_geo_dictionary、tab_analysis_geo_knowledge表内有内容，一对经纬度，生成一条中文地点数据。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云图支持地理位置解析 end');
}

/**
 * 宫格-解析: [隐藏相册支持地理位置解析，但不显示]
 * GROUP: 宫格 MODULE: 解析TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_003
 * 前置条件
 * 1、隐藏相册准备50张图片
 2、手机电量大于50%，手机温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation003(dt: Dt) {
  dt.log.i('隐藏相册支持地理位置解析，但不显示 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志，关键字：location，geo');

  await dt.sleep();
  dt.log.i('预期结果2、地理位置解析日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_geo_dictionary、tab_analysis_geo_knowledge表内有内容，生成一条中文地点数据。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册支持地理位置解析，但不显示 end');
}

/**
 * 宫格-解析: [最近删除支持地理位置解析，但不显示]
 * GROUP: 宫格 MODULE: 解析TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_004
 * 前置条件
 * 1、最近删除准备50张图片
 2、手机电量大于50%，手机温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation004(dt: Dt) {
  dt.log.i('最近删除支持地理位置解析，但不显示 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志，关键字：location，geo');

  await dt.sleep();
  dt.log.i('预期结果2、地理位置解析日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_geo_dictionary、tab_analysis_geo_knowledge表内有内容，生成一条中文地点数据。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除支持地理位置解析，但不显示 end');
}

/**
 * 宫格-解析: [图片编辑-保存/编辑-恢复后，保留原始地理位置信息]
 * GROUP: 宫格 MODULE: 解析TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_007
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、图片相册有已分析图片10张
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation007(dt: Dt) {
  dt.log.i('图片编辑-保存/编辑-恢复后，保留原始地理位置信息 start');
  dt.log.i('STEP 1、图库编辑-恢复/编辑-保存图片');

  await dt.sleep();
  dt.log.i('STEP 2、充电息屏');

  await dt.sleep();
  dt.log.i('预期结果2、地理位置解析日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看日志');

  await dt.sleep();
  dt.log.i('预期结果3、图片编辑-恢复/编辑-保存后，tab_analysis_geo_dictionary、tab_analysis_geo_knowledge表内地点信息未发生改变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、拉取数据库查看：tab_analysis_geo_dictionary、tab_analysis_geo_knowledge');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片编辑-保存/编辑-恢复后，保留原始地理位置信息 end');
}

/**
 * 宫格-解析: [导入带经纬度的图片，可以正确解析出地理位置信息]
 * GROUP: 宫格 MODULE: 解析TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_008
 * 前置条件
 * 1、准备50张带地理位置的图片，包含敏感地址
 2、手机电量大于50%，手机温度小于37℃
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation008(dt: Dt) {
  dt.log.i('导入带经纬度的图片，可以正确解析出地理位置信息 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志，关键字：location，geo');

  await dt.sleep();
  dt.log.i('预期结果2、地理位置解析日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_geo_dictionary、tab_analysis_geo_knowledge表内地点数据显示的信息内容正确');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('导入带经纬度的图片，可以正确解析出地理位置信息 end');
}

/**
 * 宫格-解析: [地点解析完成，无数据待分析，分析服务停止，结果返回数据库]
 * GROUP: 宫格 MODULE: 解析TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_009
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、图片相册预置200张带地理位置的图片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation009(dt: Dt) {
  dt.log.i('地点解析完成，无数据待分析，分析服务停止，结果返回数据库 start');
  dt.log.i('STEP 1、充电，息屏，cmd界面实时查看地理解析处理日志：hdc  shell hilog  | grep  ""LocationJob Stop”');

  await dt.sleep();
  dt.log.i('预期结果1、出现日志打印，地点解析进程关闭');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、待一批完成，拉取数据查看tab_analysis_geo_dictionary、tab_analysis_geo_knowledge');

  await dt.sleep();
  dt.log.i('预期结果2、数据库内字段正确写入完成');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点解析完成，无数据待分析，分析服务停止，结果返回数据库 end');
}

/**
 * 宫格-解析: [大数据量下，图片地点解析分批进行，2000图片一批次]
 * GROUP: 宫格 MODULE: 解析TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_013
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、图片相册预置10000张带地理位置的图片

 */
async function aPPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation013(dt: Dt) {
  dt.log.i('大数据量下，图片地点解析分批进行，2000图片一批次 start');
  dt.log.i('STEP 1、充电，息屏，cmd界面实时查看日志：hdc  shell hilog  | grep  ""MediaCV”');

  await dt.sleep();
  dt.log.i('预期结果1、出现日志打印：”Reached the upper limit of the number of parsed data in this round”，地点解析进程关闭,等待下次智慧分析拉起进入地点解析');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('Reached the upper limit of the number of parsed data in this round'));
  dt.log.i('STEP 2、待一批完成，拉取数据查看tab_analysis_geo_dictionary、tab_analysis_geo_knowledge');

  await dt.sleep();
  dt.log.i('预期结果2、数据库内字段正确写入完成');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大数据量下，图片地点解析分批进行，2000图片一批次 end');
}

/**
 * 宫格-: [图库编辑保存的图片，会更新人头、宠物头检测结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Head_001
 * 前置条件
 * 1、手机电量大于50%
 2、图片相册有已分析图片10张
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVHead001(dt: Dt) {
  dt.log.i('图库编辑保存的图片，会更新人头、宠物头检测结果 start');
  dt.log.i('STEP 1、图库编辑覆盖图片');

  await dt.sleep();
  dt.log.i('STEP 2、充电息屏');

  await dt.sleep();
  dt.log.i('预期结果2、人头、宠物头检测日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看日志');

  await dt.sleep();
  dt.log.i('预期结果3、编辑覆盖的图片在tab_analysis_head表内更新数据');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、拉取数据库查看：tab_analysis_head');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库编辑保存的图片，会更新人头、宠物头检测结果 end');
}

/**
 * 宫格-: [云图支持人头、宠物头检测]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Head_002
 * 前置条件
 * 1、手机登录已云账号，同步云端图片
 2、手机电量大于50%
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVHead002(dt: Dt) {
  dt.log.i('云图支持人头、宠物头检测 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志，关键字：HeadDetect');

  await dt.sleep();
  dt.log.i('预期结果2、人头、宠物头检测日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_head表内有内容，tab_analysis_total表内head=1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云图支持人头、宠物头检测 end');
}

/**
 * 宫格-: [截屏相册支持人头、宠物头检测]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Head_003
 * 前置条件
 * 1、截屏相册准备50张图片
 2、手机电量大于50%
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVHead003(dt: Dt) {
  dt.log.i('截屏相册支持人头、宠物头检测 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志，关键字：HeadDetect');

  await dt.sleep();
  dt.log.i('预期结果2、人头、宠物头检测日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_head表内有内容，tab_analysis_total表内head=1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('截屏相册支持人头、宠物头检测 end');
}

/**
 * 宫格-: [隐藏相册支持人头、宠物头检测]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Head_004
 * 前置条件
 * 1、隐藏相册准备50张图片
 2、手机电量大于50%
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVHead004(dt: Dt) {
  dt.log.i('隐藏相册支持人头、宠物头检测 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志，关键字：HeadDetect');

  await dt.sleep();
  dt.log.i('预期结果2、人头、宠物头检测日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_head表内出现内容，tab_analysis_total表内head=1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册支持人头、宠物头检测 end');
}

/**
 * 宫格-删除: [最近删除不支持人头、宠物头检测]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Head_005
 * 前置条件
 * 1、最近删除准备50张图片
 2、手机电量大于50%
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVHead005(dt: Dt) {
  dt.log.i('最近删除不支持人头、宠物头检测 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志，关键字：HeadDetect');

  await dt.sleep();
  dt.log.i('预期结果2、人头、宠物头检测日志打印NO data for vision to analysis!');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_head表内无内容，tab_analysis_total表内status=2，head=03、tab_analysis_head表内新增数据，tab_analysis_total表内head=1');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、从最近删除相册恢复删除的图片，充电息屏，拉取数据库');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除不支持人头、宠物头检测 end');
}
