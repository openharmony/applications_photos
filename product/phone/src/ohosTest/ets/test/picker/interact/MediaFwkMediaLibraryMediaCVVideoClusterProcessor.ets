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


export default function aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor015Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor015Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor015').init();
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor015 start');
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor015 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor015', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [视频人像分析结果的准确率和召回率] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_015
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor015(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [视频人像分析时长不高于视频本身的两倍] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_016
      await aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor016(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVXUniverse001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [媒体库支持tab_analysis_pose表新增pose_type] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_001
      await aPPFWKMediaFwkMediaLibraryMediaCVXUniverse001(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVXUniverse002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [媒体库支持tab_analysis_image_face表新增face_occlusion] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_002
      await aPPFWKMediaFwkMediaLibraryMediaCVXUniverse002(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVXUniverse003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [媒体库支持智慧分析读写遮挡识别结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_003
      await aPPFWKMediaFwkMediaLibraryMediaCVXUniverse003(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVXUniverse004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [媒体库支持智慧分析读写骨骼点识别结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_004
      await aPPFWKMediaFwkMediaLibraryMediaCVXUniverse004(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVXUniverse005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [媒体库支持系统应用读取遮挡识别结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_005
      await aPPFWKMediaFwkMediaLibraryMediaCVXUniverse005(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVXUniverse006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [媒体库支持系统应用读取骨骼点识别结果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_006
      await aPPFWKMediaFwkMediaLibraryMediaCVXUniverse006(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVXUniverse007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [未遮挡人脸数据集质量分析结果face_occlusion=0] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_007
      await aPPFWKMediaFwkMediaLibraryMediaCVXUniverse007(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVXUniverse008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [遮挡人脸数据集质量分析结果face_occlusion=1] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_008
      await aPPFWKMediaFwkMediaLibraryMediaCVXUniverse008(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVXUniverse009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [全身人像数据集骨骼点分析结果pose_type=1] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_009
      await aPPFWKMediaFwkMediaLibraryMediaCVXUniverse009(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVXUniverse010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [半身人像数据集骨骼点分析结果pose_type=2] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_010
      await aPPFWKMediaFwkMediaLibraryMediaCVXUniverse010(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVXUniverse011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [蹲下，跳远，芭蕾舞数据集骨骼点分析结果pose_type=3] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_011
      await aPPFWKMediaFwkMediaLibraryMediaCVXUniverse011(dt);
    });

    run('IMediaAPPGalleryVideodeletion001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置界面新增专项清理入口] TID: IMediaAPP_Gallery_Videodeletion_001
      await iMediaAPPGalleryVideodeletion001(dt);
    });

    run('IMediaAPPGalleryVideodeletion002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [视频清理页面视频按所占内存大小倒序排序] TID: IMediaAPP_Gallery_Videodeletion_002
      await iMediaAPPGalleryVideodeletion002(dt);
    });

    run('IMediaAPPGalleryVideodeletion003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-滑动用例: [视频清理页面可滑动查看] TID: IMediaAPP_Gallery_Videodeletion_003
      await iMediaAPPGalleryVideodeletion003(dt);
    });

    run('IMediaAPPGalleryVideodeletion004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [视频清理页面支持大图浏览] TID: IMediaAPP_Gallery_Videodeletion_004
      await iMediaAPPGalleryVideodeletion004(dt);
    });

    run('IMediaAPPGalleryVideodeletion005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [视频清理界面录屏保存后新增视频界面立即刷新] TID: IMediaAPP_Gallery_Videodeletion_005
      await iMediaAPPGalleryVideodeletion005(dt);
    });

    run('IMediaAPPGalleryVideodeletion006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [视频清理页面删除动效正常] TID: IMediaAPP_Gallery_Videodeletion_006
      await iMediaAPPGalleryVideodeletion006(dt);
    });

    run('IMediaAPPGalleryVideodeletion007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [视频清理页面删除后图库检查] TID: IMediaAPP_Gallery_Videodeletion_007
      await iMediaAPPGalleryVideodeletion007(dt);
    });

    run('IMediaAPPGalleryVideodeletion008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [视频清理界面不显示云端视频和回收站视频] TID: IMediaAPP_Gallery_Videodeletion_008
      await iMediaAPPGalleryVideodeletion008(dt);
    });

    run('IMediaAPPGalleryVideodeletion009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [图库删除后视频清理页面检查] TID: IMediaAPP_Gallery_Videodeletion_009
      await iMediaAPPGalleryVideodeletion009(dt);
    });

    run('IMediaAPPGalleryVideodeletion010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [视频清理页面可全选删除视频] TID: IMediaAPP_Gallery_Videodeletion_010
      await iMediaAPPGalleryVideodeletion010(dt);
    });

    run('IMediaAPPGalleryVideodeletion011', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [专项清理界面显示视频大小和视频列表界面显示大小一致] TID: IMediaAPP_Gallery_Videodeletion_011
      await iMediaAPPGalleryVideodeletion011(dt);
    });

    run('IMediaAPPGalleryVideodeletion012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [专项清理界面显示视频大小和优化存储界面视频删除显示大小一致] TID: IMediaAPP_Gallery_Videodeletion_012
      await iMediaAPPGalleryVideodeletion012(dt);
    });

    run('IMediaAPPGalleryVideodeletion013', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [隐私空间支持专项清理视频清理] TID: IMediaAPP_Gallery_Videodeletion_013
      await iMediaAPPGalleryVideodeletion013(dt);
    });

    run('IMediaAPPGalleryVideodeletion014', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [悬浮窗下视频清理界面功能和界面检查] TID: IMediaAPP_Gallery_Videodeletion_014
      await iMediaAPPGalleryVideodeletion014(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachAPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor015').init();
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor015 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor015 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllAPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor015').init();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor015 start');
      await Exit.browser();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor015 finish');
    });
  });
}

/**
 * 宫格-视频: [视频人像分析结果的准确率和召回率]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_015
 * 前置条件
 * 手机电量大于50%，手机相册预置100张图片+100视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor015(dt: Dt) {
  dt.log.i('视频人像分析结果的准确率和召回率 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""MediaCV""，关键字：""video_cluster_processor""');

  await dt.sleep();
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_video_face内各字段和tab_analysis_total表内face字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_video_label新增数据，视频标签已分析');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、进入图库搜索“人像”，查看视频准确率和召回率');

  await dt.sleep();
  dt.log.i('预期结果4、准确率>95%和召回率>75%');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频人像分析结果的准确率和召回率 end');
}

/**
 * 宫格-视频: [视频人像分析时长不高于视频本身的两倍]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_VideoClusterProcessor_016
 * 前置条件
 * 手机电量大于50%，手机相册预置100张图片+100视频
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVVideoClusterProcessor016(dt: Dt) {
  dt.log.i('视频人像分析时长不高于视频本身的两倍 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""MediaCV""，关键字：""video_cluster_processor""');

  await dt.sleep();
  dt.log.i('预期结果2、视频分析时长不高于视频本身时长的两倍，失败则会重新分析，重复4次后，判断为视频分析失败，tab_analysis_video_face不写入数据，tab_analysis_total.face=-2');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_video_face内各字段和tab_analysis_total表内face字段');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频人像分析时长不高于视频本身的两倍 end');
}

/**
 * 宫格-: [媒体库支持tab_analysis_pose表新增pose_type]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_001
 * 前置条件
 * 1.手机电量大于50%。
 2.手机内置10张人像照片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVXUniverse001(dt: Dt) {
  dt.log.i('媒体库支持tab_analysis_pose表新增pose_type start');
  dt.log.i('STEP 1.充电熄屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2.拉取媒体数据库，查看tab_analysis_pose表');

  await dt.sleep();
  dt.log.i('预期结果2.tab_analysis_pose表内pose_type表段有内容更新');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('媒体库支持tab_analysis_pose表新增pose_type end');
}

/**
 * 宫格-: [媒体库支持tab_analysis_image_face表新增face_occlusion]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_002
 * 前置条件
 * 1.手机电量大于50%。
 2.手机内置10张人像照片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVXUniverse002(dt: Dt) {
  dt.log.i('媒体库支持tab_analysis_image_face表新增face_occlusion start');
  dt.log.i('STEP 1.充电熄屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2.拉取媒体数据库，查看tab_analysis_image_face表');

  await dt.sleep();
  dt.log.i('预期结果2.tab_analysis_image_face表内face_occlusion表段有内容更新，face_occlusion：脸部是否有遮挡（0：无遮挡，1：有遮挡）  ');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('媒体库支持tab_analysis_image_face表新增face_occlusion end');
}

/**
 * 宫格-: [媒体库支持智慧分析读写遮挡识别结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_003
 * 前置条件
 * 1.手机电量大于50%。
 2.手机内置10张人像照片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVXUniverse003(dt: Dt) {
  dt.log.i('媒体库支持智慧分析读写遮挡识别结果 start');
  dt.log.i('STEP 1.充电熄屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2.拉取媒体数据库，查看tab_analysis_image_face表');

  await dt.sleep();
  dt.log.i('预期结果2.tab_analysis_image_face表内字段都有填充');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('媒体库支持智慧分析读写遮挡识别结果 end');
}

/**
 * 宫格-: [媒体库支持智慧分析读写骨骼点识别结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_004
 * 前置条件
 * 1.手机电量大于50%。
 2.手机内置10张人像照片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVXUniverse004(dt: Dt) {
  dt.log.i('媒体库支持智慧分析读写骨骼点识别结果 start');
  dt.log.i('STEP 1.充电熄屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2.拉取媒体数据库，查看tab_analysis_pose表');

  await dt.sleep();
  dt.log.i('预期结果2.tab_analysis_pose表内字段都有填充');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('媒体库支持智慧分析读写骨骼点识别结果 end');
}

/**
 * 宫格-: [媒体库支持系统应用读取遮挡识别结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_005
 * 前置条件
 * 1.手机电量大于50%。
 2.手机内置100张正面人像照片，其中50张为人脸存在遮挡的图片，50张为人脸未遮挡的图片。
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVXUniverse005(dt: Dt) {
  dt.log.i('媒体库支持系统应用读取遮挡识别结果 start');
  dt.log.i('STEP 1.充电熄屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2.安装提供测试的Demo');

  await dt.sleep();
  dt.log.i('STEP 3.查看精品单人像界面');

  await dt.sleep();
  dt.log.i('预期结果3.界面所选图片中不存在有人脸出现遮挡的图片。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('媒体库支持系统应用读取遮挡识别结果 end');
}

/**
 * 宫格-: [媒体库支持系统应用读取骨骼点识别结果]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_006
 * 前置条件
 * 1.手机电量大于50%。
 2.手机内置100张人像照片，其中50张为经典半身正面人像，50张为人像下蹲，起跳的图片。
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVXUniverse006(dt: Dt) {
  dt.log.i('媒体库支持系统应用读取骨骼点识别结果 start');
  dt.log.i('STEP 1.充电熄屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2.安装提供测试的Demo');

  await dt.sleep();
  dt.log.i('STEP 3.查看精品单人像界面');

  await dt.sleep();
  dt.log.i('预期结果3.界面所选图片只存在有经典半身正面人像的图片。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('媒体库支持系统应用读取骨骼点识别结果 end');
}

/**
 * 宫格-: [未遮挡人脸数据集质量分析结果face_occlusion=0]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_007
 * 前置条件
 * 1.手机电量大于50%。
 2.手机插入100张未有遮挡人脸的人像图片。
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVXUniverse007(dt: Dt) {
  dt.log.i('未遮挡人脸数据集质量分析结果face_occlusion=0 start');
  dt.log.i('STEP 1.充电熄屏');

  await dt.sleep();
  dt.log.i('STEP 2.等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 3.拉取媒体数据库，查看tab_analysis_image_face表');

  await dt.sleep();
  dt.log.i('预期结果3.tab_analysis_image_face表内face_occlusion=0');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('未遮挡人脸数据集质量分析结果face_occlusion=0 end');
}

/**
 * 宫格-: [遮挡人脸数据集质量分析结果face_occlusion=1]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_008
 * 前置条件
 * 1.手机电量大于50%。
 2.手机插入100张有遮挡人脸的人像图片。
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVXUniverse008(dt: Dt) {
  dt.log.i('遮挡人脸数据集质量分析结果face_occlusion=1 start');
  dt.log.i('STEP 1.充电熄屏');

  await dt.sleep();
  dt.log.i('STEP 2.等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 3.拉取媒体数据库，查看tab_analysis_image_face表');

  await dt.sleep();
  dt.log.i('预期结果3.tab_analysis_image_face表内face_occlusion=1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('遮挡人脸数据集质量分析结果face_occlusion=1 end');
}

/**
 * 宫格-: [全身人像数据集骨骼点分析结果pose_type=1]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_009
 * 前置条件
 * 1.手机电量大于50%。
 2.手机插入100张经典全身像图片。
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVXUniverse009(dt: Dt) {
  dt.log.i('全身人像数据集骨骼点分析结果pose_type=1 start');
  dt.log.i('STEP 1.充电熄屏');

  await dt.sleep();
  dt.log.i('STEP 2.等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 3.拉取媒体数据库，查看tab_analysis_pose表');

  await dt.sleep();
  dt.log.i('预期结果3.tab_analysis_pose表内pose_type=1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('全身人像数据集骨骼点分析结果pose_type=1 end');
}

/**
 * 宫格-: [半身人像数据集骨骼点分析结果pose_type=2]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_010
 * 前置条件
 * 1.手机电量大于50%。
 2.手机插入100张经典半身人像图片。
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVXUniverse010(dt: Dt) {
  dt.log.i('半身人像数据集骨骼点分析结果pose_type=2 start');
  dt.log.i('STEP 1.充电熄屏');

  await dt.sleep();
  dt.log.i('STEP 2.等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 3.拉取媒体数据库，查看tab_analysis_pose表');

  await dt.sleep();
  dt.log.i('预期结果3.tab_analysis_pose表内pose_type=2');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('半身人像数据集骨骼点分析结果pose_type=2 end');
}

/**
 * 宫格-: [蹲下，跳远，芭蕾舞数据集骨骼点分析结果pose_type=3]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_X_Universe_011
 * 前置条件
 * 1.手机电量大于50%。
 2.手机插入100张有着下蹲，起跳，舞蹈人像图片
 */
async function aPPFWKMediaFwkMediaLibraryMediaCVXUniverse011(dt: Dt) {
  dt.log.i('蹲下，跳远，芭蕾舞数据集骨骼点分析结果pose_type=3 start');
  dt.log.i('STEP 1.充电熄屏');

  await dt.sleep();
  dt.log.i('STEP 2.等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 3.拉取媒体数据库，查看tab_analysis_pose表');

  await dt.sleep();
  dt.log.i('预期结果3.tab_analysis_pose表内pose_type=3');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('蹲下，跳远，芭蕾舞数据集骨骼点分析结果pose_type=3 end');
}

/**
 * 宫格-删除: [设置界面新增专项清理入口]
 * GROUP: 宫格 MODULE: 删除TID: IMediaAPP_Gallery_Videodeletion_001
 * 前置条件
 * 1、图库预制1000+视频资源
 */
async function iMediaAPPGalleryVideodeletion001(dt: Dt) {
  dt.log.i('设置界面新增专项清理入口 start');
  dt.log.i('STEP 1、设置-存储');

  await dt.sleep();
  dt.log.i('预期结果1、存储界面有“专项清理”入口');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('专项清理'));
  dt.log.i('STEP 2、点击专项清理');

  await dt.sleep();
  dt.log.i('预期结果2、跳转到专项清理界面，界面显示“视频”、大文件');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('视频'));
  dt.log.i('STEP 3、点击视频');

  await dt.sleep();
  dt.log.i('预期结果3、跳转到视频列表界面，左上角显示“视频”，右上角显示全选，底部显示“删除(已选 0 KB)”为置灰状态');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('视频'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置界面新增专项清理入口 end');
}

/**
 * 宫格-视频: [视频清理页面视频按所占内存大小倒序排序]
 * GROUP: 宫格 MODULE: 视频TID: IMediaAPP_Gallery_Videodeletion_002
 * 前置条件
 * 1、图库预制1000+视频资源
 */
async function iMediaAPPGalleryVideodeletion002(dt: Dt) {
  dt.log.i('视频清理页面视频按所占内存大小倒序排序 start');
  dt.log.i('STEP 1、从设置--存储-点击专项清理-点击视频');

  await dt.sleep();
  dt.log.i('预期结果1、文件按size从大到小排列显示，同size视频按时间升序，文件名降序排列');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频清理页面视频按所占内存大小倒序排序 end');
}

/**
 * 宫格-滑动: [视频清理页面可滑动查看]
 * GROUP: 宫格 MODULE: 滑动TID: IMediaAPP_Gallery_Videodeletion_003
 * 前置条件
 * 1、图库预制视频资源
 */
async function iMediaAPPGalleryVideodeletion003(dt: Dt) {
  dt.log.i('视频清理页面可滑动查看 start');
  dt.log.i('STEP 1、从设置--存储-点击专项清理-点击视频');

  await dt.sleep();
  dt.log.i('STEP 2、界面手指快速抛滑');

  await dt.sleep();
  dt.log.i('预期结果2、滑动无卡顿，无白块');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拖动滚动条浏览');

  await dt.sleep();
  dt.log.i('预期结果3、拖动浏览无卡顿，无白块');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频清理页面可滑动查看 end');
}

/**
 * 宫格-视频: [视频清理页面支持大图浏览]
 * GROUP: 宫格 MODULE: 视频TID: IMediaAPP_Gallery_Videodeletion_004
 * 前置条件
 * 1、图库预制视频资源
 */
async function iMediaAPPGalleryVideodeletion004(dt: Dt) {
  dt.log.i('视频清理页面支持大图浏览 start');
  dt.log.i('STEP 1、从设置--存储-点击专项清理-点击视频');

  await dt.sleep();
  dt.log.i('STEP 2、点击视频缩略图进入大图预览界面，点击播放按钮，点击右上角勾选');

  await dt.sleep();
  dt.log.i('预期结果2、进入视频大图，点击播放按钮视频开始播放，勾选框变白色');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、下拉返回列表界面');

  await dt.sleep();
  dt.log.i('预期结果3、勾选框变成蓝色高亮已选中状态，左上角显示已选择1箱，底部高亮显示删除（已选 XXMB），和选中的视频大小一致');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频清理页面支持大图浏览 end');
}

/**
 * 宫格-视频: [视频清理界面录屏保存后新增视频界面立即刷新]
 * GROUP: 宫格 MODULE: 视频TID: IMediaAPP_Gallery_Videodeletion_005
 * 前置条件
 * 1、图库预制视频资源
 */
async function iMediaAPPGalleryVideodeletion005(dt: Dt) {
  dt.log.i('视频清理界面录屏保存后新增视频界面立即刷新 start');
  dt.log.i('STEP 1、从设置--存储-点击专项清理-点击视频');

  await dt.sleep();
  dt.log.i('STEP 2、点击全选，左上角显示已选中A项');

  await dt.sleep();
  dt.log.i('STEP 3、当前界面录屏保存');

  await dt.sleep();
  dt.log.i('预期结果3、保存完成后界面立即刷新，新增视频默认已选中，左上角选中数量加一');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频清理界面录屏保存后新增视频界面立即刷新 end');
}

/**
 * 宫格-删除: [视频清理页面删除动效正常]
 * GROUP: 宫格 MODULE: 删除TID: IMediaAPP_Gallery_Videodeletion_006
 * 前置条件
 * 1、图库预制视频资源
 */
async function iMediaAPPGalleryVideodeletion006(dt: Dt) {
  dt.log.i('视频清理页面删除动效正常 start');
  dt.log.i('STEP 1、从设置--存储-点击专项清理-点击视频');

  await dt.sleep();
  dt.log.i('STEP 2、点击视频后选择框');

  await dt.sleep();
  dt.log.i('预期结果2、点击视频时该视频背景框变成灰色，选择框变为蓝色已选中状态');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击下方删除按钮');

  await dt.sleep();
  dt.log.i('预期结果3.1、端云本地都有的视频删除时，弹出提示“是否删除此视频？”“此视频将从本设备、云空间及所有同步设备中永久删除，无法恢复”“取消”“永久删除”3.2纯本地视频删除时，弹出提示“是否删除此视频？”“此视频将被永久删除，无法恢复”“取消”“永久删除”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('是否删除此视频？'));
  dt.log.i('STEP 4、点击永久删除');

  await dt.sleep();
  dt.log.i('预期结果4、删除视频动效正常，无闪屏无闪退');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频清理页面删除动效正常 end');
}

/**
 * 宫格-删除: [视频清理页面删除后图库检查]
 * GROUP: 宫格 MODULE: 删除TID: IMediaAPP_Gallery_Videodeletion_007
 * 前置条件
 * 1、图库预制视频资源
 */
async function iMediaAPPGalleryVideodeletion007(dt: Dt) {
  dt.log.i('视频清理页面删除后图库检查 start');
  dt.log.i('STEP 1、从设置--存储-点击专项清理-点击视频');

  await dt.sleep();
  dt.log.i('STEP 2、点击视频后选择框');

  await dt.sleep();
  dt.log.i('STEP 3、点击下方删除按钮');

  await dt.sleep();
  dt.log.i('STEP 4、点击永久删除');

  await dt.sleep();
  dt.log.i('预期结果4、删除视频动效正常，无闪屏无闪退');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、立即进入图库检查');

  await dt.sleep();
  dt.log.i('预期结果5、图库视频相册和最近删除都无此视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频清理页面删除后图库检查 end');
}

/**
 * 宫格-视频: [视频清理界面不显示云端视频和回收站视频]
 * GROUP: 宫格 MODULE: 视频TID: IMediaAPP_Gallery_Videodeletion_008
 * 前置条件
 * 1、图库无视频，登录云账号，打开同步开关
 */
async function iMediaAPPGalleryVideodeletion008(dt: Dt) {
  dt.log.i('视频清理界面不显示云端视频和回收站视频 start');
  dt.log.i('STEP 1、从设置--存储-点击专项清理-点击视频');

  await dt.sleep();
  dt.log.i('预期结果1、视频清理界面显示空界面，有空界面插画，提示没有视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入图库下载一个视频，返回视频清理界面查看');

  await dt.sleep();
  dt.log.i('预期结果2、视频清理界面显示刚刚下载的视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入图库将刚下载的视频删除到回收站，然后立即进入视频清理界面查看');

  await dt.sleep();
  dt.log.i('预期结果3、视频清理界面显示空界面，有空界面插画，提示没有视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频清理界面不显示云端视频和回收站视频 end');
}

/**
 * 宫格-删除: [图库删除后视频清理页面检查]
 * GROUP: 宫格 MODULE: 删除TID: IMediaAPP_Gallery_Videodeletion_009
 * 前置条件
 * 1、图库预制视频资源
 */
async function iMediaAPPGalleryVideodeletion009(dt: Dt) {
  dt.log.i('图库删除后视频清理页面检查 start');
  dt.log.i('STEP 1、进入图库删除视频进入回收站');

  await dt.sleep();
  dt.log.i('STEP 2、立即进入视频清理界面查看');

  await dt.sleep();
  dt.log.i('预期结果2、视频清理界面不显示该视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库删除后视频清理页面检查 end');
}

/**
 * 宫格-删除: [视频清理页面可全选删除视频]
 * GROUP: 宫格 MODULE: 删除TID: IMediaAPP_Gallery_Videodeletion_010
 * 前置条件
 * 1、图库预制1000+视频资源
 */
async function iMediaAPPGalleryVideodeletion010(dt: Dt) {
  dt.log.i('视频清理页面可全选删除视频 start');
  dt.log.i('STEP 1、从设置--存储-点击专项清理-点击视频');

  await dt.sleep();
  dt.log.i('预期结果1、进入视频删除界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击右上角全选按钮');

  await dt.sleep();
  dt.log.i('预期结果2、选择框变为已选中状态，左上角已选择××项为所有的视频数');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击下方删除按钮，点击永久删除');

  await dt.sleep();
  dt.log.i('预期结果3、出现删除进度条，进度条100%时删除完成，界面显示空界面，提示没有视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、进度条未100%时点击进度条后方的×');

  await dt.sleep();
  dt.log.i('预期结果4、出现已删除××%，是否停止剩余文件永久删除，点击继续，删除继续，点击停止，进度条消失，显示未删除的视频文件。');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、全选删除后返回专项清理界面查看');

  await dt.sleep();
  dt.log.i('预期结果5、专项清理界面显示视频大小0kB');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、全选删除完成后进入图库查看');

  await dt.sleep();
  dt.log.i('预期结果6、图库相册界面无视频相册，最近删除相册无被删除的视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频清理页面可全选删除视频 end');
}

/**
 * 宫格-视频: [专项清理界面显示视频大小和视频列表界面显示大小一致]
 * GROUP: 宫格 MODULE: 视频TID: IMediaAPP_Gallery_Videodeletion_011
 * 前置条件
 * 1、剩余空间 >= 10% && 可删除数据> 2G

 2、图库中有不同格式和不同分辨率的图片和视频资源

 */
async function iMediaAPPGalleryVideodeletion011(dt: Dt) {
  dt.log.i('专项清理界面显示视频大小和视频列表界面显示大小一致 start');
  dt.log.i('STEP 1、设置-存储，点击专项清理');

  await dt.sleep();
  dt.log.i('预期结果1、专项清理界面视频显示大小为A');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击视频跳转视频列表界面，点击全选');

  await dt.sleep();
  dt.log.i('预期结果2、视频列表界面全选后显示视频大小也是A');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、取消全选，点击选中一个视频删除，然后全选');

  await dt.sleep();
  dt.log.i('预期结果3、视频列表全选后显示视频大小为B');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、返回专项清理界面');

  await dt.sleep();
  dt.log.i('预期结果4、视频大小显示为B');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('专项清理界面显示视频大小和视频列表界面显示大小一致 end');
}

/**
 * 宫格-删除: [专项清理界面显示视频大小和优化存储界面视频删除显示大小一致]
 * GROUP: 宫格 MODULE: 删除TID: IMediaAPP_Gallery_Videodeletion_012
 * 前置条件
 * 1、剩余空间 >= 10% && 可删除数据> 2G

 2、图库中有不同格式和不同分辨率的图片和视频资源

 */
async function iMediaAPPGalleryVideodeletion012(dt: Dt) {
  dt.log.i('专项清理界面显示视频大小和优化存储界面视频删除显示大小一致 start');
  dt.log.i('STEP 1、设置-存储，点击优化存储空间，视频删除显示大小为A');

  await dt.sleep();
  dt.log.i('STEP 2、设置-存储，点击专项清理，视频显示大小B');

  await dt.sleep();
  dt.log.i('预期结果2、专项清理界面视频大小和优化存储空间视频删除显示大小一致，A=B');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('专项清理界面显示视频大小和优化存储界面视频删除显示大小一致 end');
}

/**
 * 宫格-视频: [隐私空间支持专项清理视频清理]
 * GROUP: 宫格 MODULE: 视频TID: IMediaAPP_Gallery_Videodeletion_013
 * 前置条件
 * 1、进入隐私空间

 */
async function iMediaAPPGalleryVideodeletion013(dt: Dt) {
  dt.log.i('隐私空间支持专项清理视频清理 start');
  dt.log.i('STEP 1、进入隐私空间设置--存储-点击专项清理-点击视频');

  await dt.sleep();
  dt.log.i('STEP 2、新增一个视频后，进入视频删除，点击选中视频，点击删除，点击永久删除');

  await dt.sleep();
  dt.log.i('预期结果2、隐私空间不显示主空间视频，视频可以正常删除');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入图库查看');

  await dt.sleep();
  dt.log.i('预期结果3、图库不显示该视频，最近删除也无该视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间支持专项清理视频清理 end');
}

/**
 * 宫格-视频: [悬浮窗下视频清理界面功能和界面检查]
 * GROUP: 宫格 MODULE: 视频TID: IMediaAPP_Gallery_Videodeletion_014
 * 前置条件
 * 1、图库预制1000+视频资源
 */
async function iMediaAPPGalleryVideodeletion014(dt: Dt) {
  dt.log.i('悬浮窗下视频清理界面功能和界面检查 start');
  dt.log.i('STEP 1、悬浮窗下遍历视频清理全量场景');

  await dt.sleep();
  dt.log.i('预期结果1、功能正常，界面文字和弹窗显示正常，无截断');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('悬浮窗下视频清理界面功能和界面检查 end');
}
