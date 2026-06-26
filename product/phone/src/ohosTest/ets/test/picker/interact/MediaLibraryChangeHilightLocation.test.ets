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


export default function APPFWKMediaFwkMediaLibraryChangehilightlocationTest(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('APPFWKMediaFwkMediaLibraryChangehilightlocation006Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAPPFWKMediaFwkMediaLibraryChangehilightlocation006').init();
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryChangehilightlocation006 start');
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryChangehilightlocation006 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('APPFWKMediaFwkMediaLibraryChangehilightlocation006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [手机内导入带有遮罩，转场，高光素材的时刻，等待CV分析完成，查看数据库内映射是否正确] TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_006
      await APPFWKMediaFwkMediaLibraryChangehilightlocation006(dt);
    });

    run('APPFWKMediaFwkMediaLibraryChangehilightlocation007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [手机云同步带有遮罩，转场，高光素材的时刻，等待CV分析完成，查看数据库内映射是否正确] TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_007
      await APPFWKMediaFwkMediaLibraryChangehilightlocation007(dt);
    });

    run('APPFWKMediaFwkMediaLibraryChangehilightlocation008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [手机内已经生成的遮罩，高光，转场彻底删除后，观察数据库是否同步删除相关映射] TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_008
      await APPFWKMediaFwkMediaLibraryChangehilightlocation008(dt);
    });

    run('APPFWKMediaFwkMediaLibraryChangehilightlocation009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [手机内已经生成的遮罩，高光，转场删除后，查看时刻轮播画面是否正常，分享导出功能是否正常] TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_009
      await APPFWKMediaFwkMediaLibraryChangehilightlocation009(dt);
    });

    run('APPFWKMediaFwkMediaLibraryChangehilightlocation010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [手机内已经生成的遮罩，高光，转场彻底删除后，查看时刻分享导出功能是否正常，分享导出功能是否正常] TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_010
      await APPFWKMediaFwkMediaLibraryChangehilightlocation010(dt);
    });

    run('APPFWKMediaFwkMediaLibraryChangehilightlocation011', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [手机成长时刻，再导入带有遮罩，高光，转场的时刻资源后，可以正常生成遮罩，高光，转场，并且数据库内映射添加正常] TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_011
      await APPFWKMediaFwkMediaLibraryChangehilightlocation011(dt);
    });

    run('APPFWKMediaFwkMediaLibraryChangehilightlocation012', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-详情用例: [联网状态下，关闭图库网络连接，新增图片后，上划图片后实时地理位置信息正常显示] TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_012
      await APPFWKMediaFwkMediaLibraryChangehilightlocation012(dt);
    });

    run('APPFWKMediaFwkMediaLibraryChangehilightlocation013', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-详情用例: [弱网状态下，新增图片后，查看上划图片后地理位置信息的加载和显示情况] TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_013
      await APPFWKMediaFwkMediaLibraryChangehilightlocation013(dt);
    });

    run('APPFWKMediaFwkMediaLibraryChangehilightlocation014', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-详情用例: [未联网状态下，新增图片后，上划图片后实时显示地理位置经纬度] TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_014
      await APPFWKMediaFwkMediaLibraryChangehilightlocation014(dt);
    });

    run('APPFWKMediaFwkMediaLibraryChangehilightlocation015', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-进入大图用例: [网络恢复后，图片的地理位置信息能够自动刷新] TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_015
      await APPFWKMediaFwkMediaLibraryChangehilightlocation015(dt);
    });

    run('APPFWKMediaFwkMediaLibraryChangehilightlocation016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-详情用例: [检查显示的地理信息是否与图片拍摄地匹配。] TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_016
      await APPFWKMediaFwkMediaLibraryChangehilightlocation016(dt);
    });

    run('APPFWKMediaFwkMediaLibraryChangehilightlocation017', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-详情用例: [测试不同经纬度图片，显示的地理位置信息正确显示] TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_017
      await APPFWKMediaFwkMediaLibraryChangehilightlocation017(dt);
    });

    run('APPFWKMediaFwkMediaLibraryChangehilightlocation018', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-详情用例: [联网状态下，开启云同步后，上划图片后实时地理位置信息正常显示] TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_018
      await APPFWKMediaFwkMediaLibraryChangehilightlocation018(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [云图支持美学构图] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_001
      await APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition001(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore010', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [同一个对象不同亮度美学评分] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_010
      await APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore010(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore013', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [相同背景、拍摄主体突出情况不同的美学评分] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_013
      await APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore013(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore015', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [云图支持美学评分] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_015
      await APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore015(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-解析用例: [出现违法经纬度时，地点解析返回location_key=0] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_010
      await APPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation010(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation011', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图片地点经纬度的精度和xxx对齐] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_011
      await APPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation011(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图片地点经纬度可判断东西经和南北纬] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_012
      await APPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation012(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVMaskVideo001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [支持图片与图片的遮罩转场，数量限制1个] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_001
      await APPFWKMediaFwkMediaLibraryMediaCVMaskVideo001(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVMaskVideo002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [支持图片与视频的遮罩转场] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_002
      await APPFWKMediaFwkMediaLibraryMediaCVMaskVideo002(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVMaskVideo003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [转场视频支持SDR效果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_003
      await APPFWKMediaFwkMediaLibraryMediaCVMaskVideo003(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVMaskVideo004', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [新生成时刻或成长型时刻支持转场效果增加，非成长型时刻不支持] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_004
      await APPFWKMediaFwkMediaLibraryMediaCVMaskVideo004(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVMaskVideo005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [剩余空间小于30G不支持遮罩增强转场] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_005
      await APPFWKMediaFwkMediaLibraryMediaCVMaskVideo005(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVMaskVideo006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [数据库中转场信息字段与轮播效果一致] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_006
      await APPFWKMediaFwkMediaLibraryMediaCVMaskVideo006(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVMaskVideo007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [删除照片/视频后轮播中转场效果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_007
      await APPFWKMediaFwkMediaLibraryMediaCVMaskVideo007(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVMaskVideo008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-端云用例: [端云关闭后轮播中转场效果] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_008
      await APPFWKMediaFwkMediaLibraryMediaCVMaskVideo008(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachAPPFWKMediaFwkMediaLibraryChangehilightlocation006').init();
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryChangehilightlocation006 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryChangehilightlocation006 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllAPPFWKMediaFwkMediaLibraryChangehilightlocation006').init();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryChangehilightlocation006 start');
      await Exit.browser();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryChangehilightlocation006 finish');
    });
  });
}

/**
 * 宫格-: [手机内导入带有遮罩，转场，高光素材的时刻，等待CV分析完成，查看数据库内映射是否正确]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_006
 * 前置条件
 * 1.手机内导入带有遮罩，转场，高光素材
 */
async function APPFWKMediaFwkMediaLibraryChangehilightlocation006(dt: Dt) {
  dt.log.i('手机内导入带有遮罩，转场，高光素材的时刻，等待CV分析完成，查看数据库内映射是否正确 start');
  dt.log.i('STEP 1.充电息屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2.进入时刻轮播，查看生成情况');

  await dt.sleep();
  dt.log.i('预期结果2.遮罩，转场，高光可以正常生成');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.拉取媒体看，查看tab_analysis_album_asset_map与tab_analysis_asset_sd_map字段是否写入，查看/storage/cloud/100/files/highlight下video文件内的数据是否可以正确与上述两个字段映射');

  await dt.sleep();
  dt.log.i('预期结果3.tab_analysis_album_asset_map数据字段与路径下的文件夹可以正确映射');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('手机内导入带有遮罩，转场，高光素材的时刻，等待CV分析完成，查看数据库内映射是否正确 end');
}

/**
 * 宫格-: [手机云同步带有遮罩，转场，高光素材的时刻，等待CV分析完成，查看数据库内映射是否正确]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_007
 * 前置条件
 * 1.手机云端带有遮罩，转场，高光素材
 2.打开手机云同步，等待同步完成
 */
async function APPFWKMediaFwkMediaLibraryChangehilightlocation007(dt: Dt) {
  dt.log.i('手机云同步带有遮罩，转场，高光素材的时刻，等待CV分析完成，查看数据库内映射是否正确 start');
  dt.log.i('STEP 1.充电息屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2.进入时刻轮播，查看生成情况');

  await dt.sleep();
  dt.log.i('预期结果2.遮罩，转场，高光可以正常生成');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.拉取媒体看，查看tab_analysis_album_asset_map与tab_analysis_asset_sd_map字段是否写入，查看/storage/cloud/100/files/highlight下video文件内的数据是否可以正确与上述两个字段映射');

  await dt.sleep();
  dt.log.i('预期结果3.tab_analysis_album_asset_map数据字段与路径下的文件夹可以正确映射');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('手机云同步带有遮罩，转场，高光素材的时刻，等待CV分析完成，查看数据库内映射是否正确 end');
}

/**
 * 宫格-删除: [手机内已经生成的遮罩，高光，转场彻底删除后，观察数据库是否同步删除相关映射]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_008
 * 前置条件
 * 1.手机内存在带有遮罩，转场，高光的时刻
 */
async function APPFWKMediaFwkMediaLibraryChangehilightlocation008(dt: Dt) {
  dt.log.i('手机内已经生成的遮罩，高光，转场彻底删除后，观察数据库是否同步删除相关映射 start');
  dt.log.i('STEP 1.进入精彩时刻宫格界面，删除对应生成遮罩，转场，高光的图片/视频');

  await dt.sleep();
  dt.log.i('STEP 2.进入最近删除，彻底删除相应素材');

  await dt.sleep();
  dt.log.i('STEP 3.拉取媒体看，查看tab_analysis_album_asset_map与tab_analysis_asset_sd_map字段是否写入，查看/storage/cloud/100/files/highlight下video文件内的数据是否可以正确与上述两个字段映射');

  await dt.sleep();
  dt.log.i('预期结果3.素材相关的tab_analysis_album_asset_map与tab_analysis_asset_sd_map字段已经清除，同时/storage/cloud/100/files/highlight下video文件内也不存在相关的转场，高光，遮罩素材');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('手机内已经生成的遮罩，高光，转场彻底删除后，观察数据库是否同步删除相关映射 end');
}

/**
 * 宫格-删除: [手机内已经生成的遮罩，高光，转场删除后，查看时刻轮播画面是否正常，分享导出功能是否正常]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_009
 * 前置条件
 * 1.手机内存在带有遮罩，转场，高光的时刻
 */
async function APPFWKMediaFwkMediaLibraryChangehilightlocation009(dt: Dt) {
  dt.log.i('手机内已经生成的遮罩，高光，转场删除后，查看时刻轮播画面是否正常，分享导出功能是否正常 start');
  dt.log.i('STEP 1.进入精彩时刻宫格界面，删除对应生成遮罩，转场，高光的图片/视频');

  await dt.sleep();
  dt.log.i('STEP 2.进入时刻，查看轮播画面，点击分析按钮');

  await dt.sleep();
  dt.log.i('预期结果2.轮播画面正常，时刻封面可以正常导出，时刻视频可以正常导出，没有异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('手机内已经生成的遮罩，高光，转场删除后，查看时刻轮播画面是否正常，分享导出功能是否正常 end');
}

/**
 * 宫格-删除: [手机内已经生成的遮罩，高光，转场彻底删除后，查看时刻分享导出功能是否正常，分享导出功能是否正常]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_010
 * 前置条件
 * 1.手机内存在带有遮罩，转场，高光的时刻
 */
async function APPFWKMediaFwkMediaLibraryChangehilightlocation010(dt: Dt) {
  dt.log.i('手机内已经生成的遮罩，高光，转场彻底删除后，查看时刻分享导出功能是否正常，分享导出功能是否正常 start');
  dt.log.i('STEP 1.进入精彩时刻宫格界面，删除对应生成遮罩，转场，高光的图片/视频');

  await dt.sleep();
  dt.log.i('STEP 2.进入最近删除，彻底删除相应素材');

  await dt.sleep();
  dt.log.i('STEP 3.进入时刻，查看轮播画面，点击分析按钮');

  await dt.sleep();
  dt.log.i('预期结果3.轮播画面正常，时刻封面可以正常导出，时刻视频可以正常导出，没有异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('手机内已经生成的遮罩，高光，转场彻底删除后，查看时刻分享导出功能是否正常，分享导出功能是否正常 end');
}

/**
 * 宫格-视频: [手机成长时刻，再导入带有遮罩，高光，转场的时刻资源后，可以正常生成遮罩，高光，转场，并且数据库内映射添加正常]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_011
 * 前置条件
 * 1.手机内存在带有遮罩，转场，高光的成长时刻
 */
async function APPFWKMediaFwkMediaLibraryChangehilightlocation011(dt: Dt) {
  dt.log.i('手机成长时刻，再导入带有遮罩，高光，转场的时刻资源后，可以正常生成遮罩，高光，转场，并且数据库内映射添加正常 start');
  dt.log.i('STEP 1.再次导入具有遮罩，转场，高光的相同成长素材');

  await dt.sleep();
  dt.log.i('STEP 2.充电息屏，电量>50%,温度<37°，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 3.查看成长时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 4.拉取媒体看，查看tab_analysis_album_asset_map与tab_analysis_asset_sd_map字段是否写入，查看/storage/cloud/100/files/highlight下video文件内的数据是否可以正确与上述两个字段映射');

  await dt.sleep();
  dt.log.i('预期结果4.轮播画面正常，时刻封面可以正常导出，时刻视频可以正常导出，没有异常');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果5.tab_analysis_album_asset_map数据字段与路径下的文件夹可以正确映射');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('手机成长时刻，再导入带有遮罩，高光，转场的时刻资源后，可以正常生成遮罩，高光，转场，并且数据库内映射添加正常 end');
}

/**
 * 宫格-详情: [联网状态下，关闭图库网络连接，新增图片后，上划图片后实时地理位置信息正常显示]
 * GROUP: 宫格 MODULE: 详情TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_012
 * 前置条件
 * 1、手机新增存在经纬度图片，未进行充电息屏分析
 2、手机联网，图库网络连接开关关闭（在土库中给点击设置可以看到图库连接开关按钮）
 */
async function APPFWKMediaFwkMediaLibraryChangehilightlocation012(dt: Dt) {
  dt.log.i('联网状态下，关闭图库网络连接，新增图片后，上划图片后实时地理位置信息正常显示 start');
  dt.log.i('STEP 1、点进图库大图，上滑大图/点击右上角详情按钮');

  await dt.sleep();
  dt.log.i('预期结果1、大图详情页出现，地图卡片出现经纬度');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、左右滑动切换图片显示');

  await dt.sleep();
  dt.log.i('预期结果2、跟随大图切换，地图卡片显示的经纬度正常切换');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、打开图库网络连接开关，重复步骤1-2');

  await dt.sleep();
  dt.log.i('预期结果3、大图详情页出现，地图卡片出现地址');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('联网状态下，关闭图库网络连接，新增图片后，上划图片后实时地理位置信息正常显示 end');
}

/**
 * 宫格-详情: [弱网状态下，新增图片后，查看上划图片后地理位置信息的加载和显示情况]
 * GROUP: 宫格 MODULE: 详情TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_013
 * 前置条件
 * 1、手机新增存在经纬度图片，未进行充电息屏分析
 2、手机处于弱网状态
 */
async function APPFWKMediaFwkMediaLibraryChangehilightlocation013(dt: Dt) {
  dt.log.i('弱网状态下，新增图片后，查看上划图片后地理位置信息的加载和显示情况 start');
  dt.log.i('STEP 1、点进图库大图，上滑大图/点击右上角详情按钮');

  await dt.sleep();
  dt.log.i('预期结果1、大图详情页出现，地图卡片出现地址');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、左右滑动切换图片显示');

  await dt.sleep();
  dt.log.i('预期结果2、跟随大图切换，地图卡片显示的地址正常切换');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('弱网状态下，新增图片后，查看上划图片后地理位置信息的加载和显示情况 end');
}

/**
 * 宫格-详情: [未联网状态下，新增图片后，上划图片后实时显示地理位置经纬度]
 * GROUP: 宫格 MODULE: 详情TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_014
 * 前置条件
 * 1、手机新增存在经纬度图片，未进行充电息屏分析
 2、手机未联网
 */
async function APPFWKMediaFwkMediaLibraryChangehilightlocation014(dt: Dt) {
  dt.log.i('未联网状态下，新增图片后，上划图片后实时显示地理位置经纬度 start');
  dt.log.i('STEP 1、点进图库大图，上滑大图/点击右上角详情按钮');

  await dt.sleep();
  dt.log.i('预期结果1、大图详情页出现，地图卡片出现经纬度');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、左右滑动切换图片显示');

  await dt.sleep();
  dt.log.i('预期结果2、跟随大图切换，地图卡片显示的经纬度正常切换');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('未联网状态下，新增图片后，上划图片后实时显示地理位置经纬度 end');
}

/**
 * 宫格-进入大图: [网络恢复后，图片的地理位置信息能够自动刷新]
 * GROUP: 宫格 MODULE: 进入大图TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_015
 * 前置条件
 * 1、手机新增存在经纬度图片，未进行充电息屏分析
 2、手机未联网
 */
async function APPFWKMediaFwkMediaLibraryChangehilightlocation015(dt: Dt) {
  dt.log.i('网络恢复后，图片的地理位置信息能够自动刷新 start');
  dt.log.i('STEP 1、点进图库大图，上滑大图/点击右上角详情按钮');

  await dt.sleep();
  dt.log.i('预期结果1、大图详情页出现，地图卡片出现经纬度');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、左右滑动切换图片显示');

  await dt.sleep();
  dt.log.i('预期结果2、跟随大图切换，地图卡片显示的经纬度正常切换');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、恢复手机联网，再次进入大图详情页');

  await dt.sleep();
  dt.log.i('预期结果3、大图详情页出现，地图卡片出现地址');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('网络恢复后，图片的地理位置信息能够自动刷新 end');
}

/**
 * 宫格-详情: [检查显示的地理信息是否与图片拍摄地匹配。]
 * GROUP: 宫格 MODULE: 详情TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_016
 * 前置条件
 * 1、手机联网
 */
async function APPFWKMediaFwkMediaLibraryChangehilightlocation016(dt: Dt) {
  dt.log.i('检查显示的地理信息是否与图片拍摄地匹配。 start');
  dt.log.i('STEP 1、手机新拍摄存在经纬度信息的图片');

  await dt.sleep();
  dt.log.i('STEP 2、点进图库大图，上滑大图/点击右上角详情按钮');

  await dt.sleep();
  dt.log.i('预期结果2、大图详情页出现，地图卡片出现地址，地址对应的是相机拍摄的位置');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('检查显示的地理信息是否与图片拍摄地匹配。 end');
}

/**
 * 宫格-详情: [测试不同经纬度图片，显示的地理位置信息正确显示]
 * GROUP: 宫格 MODULE: 详情TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_017
 * 前置条件
 * 1、手机新增不同经纬度图片，未进行充电息屏分析
 2、手机联网
 */
async function APPFWKMediaFwkMediaLibraryChangehilightlocation017(dt: Dt) {
  dt.log.i('测试不同经纬度图片，显示的地理位置信息正确显示 start');
  dt.log.i('STEP 1、点进图库大图，上滑大图/点击右上角详情按钮');

  await dt.sleep();
  dt.log.i('预期结果1、大图详情页出现，地图卡片出现地址，并且可以与经纬度信息对应');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、左右滑动切换图片显示');

  await dt.sleep();
  dt.log.i('预期结果2、跟随大图切换，地图卡片显示的地址正常切换，并且可以与经纬度信息对应');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('测试不同经纬度图片，显示的地理位置信息正确显示 end');
}

/**
 * 宫格-详情: [联网状态下，开启云同步后，上划图片后实时地理位置信息正常显示]
 * GROUP: 宫格 MODULE: 详情TID: APPFWK_MediaFwk__MediaLibrary_Change_hilight_location_018
 * 前置条件
 * 1、手机新增存在经纬度图片，未进行充电息屏分析
 2、手机联网
 */
async function APPFWKMediaFwkMediaLibraryChangehilightlocation018(dt: Dt) {
  dt.log.i('联网状态下，开启云同步后，上划图片后实时地理位置信息正常显示 start');
  dt.log.i('STEP 1、点进图库大图，上滑大图/点击右上角详情按钮');

  await dt.sleep();
  dt.log.i('预期结果1、大图详情页出现，地图卡片出现地址');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、左右滑动切换图片显示');

  await dt.sleep();
  dt.log.i('预期结果2、跟随大图切换，地图卡片显示的地址正常切换');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('联网状态下，开启云同步后，上划图片后实时地理位置信息正常显示 end');
}

/**
 * 宫格-: [云图支持美学构图]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticComposition_001
 * 前置条件
 * 1、手机登录已云账号，同步云端图片
 2、手机电量大于50%，温度小于37℃
 */
async function APPFWKMediaFwkMediaLibraryMediaCVAestheticComposition001(dt: Dt) {
  dt.log.i('云图支持美学构图 start');
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
  dt.log.i('云图支持美学构图 end');
}

/**
 * 宫格-: [同一个对象不同亮度美学评分]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_010
 * 前置条件
 * 1、准备同一个对象不同亮度的图片
 2、手机电量大于50%，温度小于37℃
 */
async function APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore010(dt: Dt) {
  dt.log.i('同一个对象不同亮度美学评分 start');
  dt.log.i('STEP 1、将准备的图片导入图片相册，充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、拉取数据库查看并记录tab_analysis_aesthetics_score表内aesthetics_score字段');

  await dt.sleep();
  dt.log.i('STEP 3、对比数据库记录的字段');

  await dt.sleep();
  dt.log.i('预期结果3、亮度高的图片评分较高');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('同一个对象不同亮度美学评分 end');
}

/**
 * 宫格-: [相同背景、拍摄主体突出情况不同的美学评分]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_013
 * 前置条件
 * 1、准备相同背景、拍摄主体突出情况不同的图片
 2、手机电量大于50%，温度小于37℃
 */
async function APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore013(dt: Dt) {
  dt.log.i('相同背景、拍摄主体突出情况不同的美学评分 start');
  dt.log.i('STEP 1、将准备的图片导入图片相册，充电息屏分析');

  await dt.sleep();
  dt.log.i('STEP 2、拉取数据库查看并记录tab_analysis_aesthetics_score表内aesthetics_score字段');

  await dt.sleep();
  dt.log.i('STEP 3、对比数据库记录的字段');

  await dt.sleep();
  dt.log.i('预期结果3、主体突出的图片评分较高');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相同背景、拍摄主体突出情况不同的美学评分 end');
}

/**
 * 宫格-: [云图支持美学评分]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_AestheticsScore_015
 * 前置条件
 * 1、手机登录已云账号，同步云端图片
 2、手机电量大于50%，温度小于37℃

 */
async function APPFWKMediaFwkMediaLibraryMediaCVAestheticsScore015(dt: Dt) {
  dt.log.i('云图支持美学评分 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""AestheticProcessor start""');

  await dt.sleep();
  dt.log.i('预期结果2、进行美学评分日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拉取数据库查看tab_analysis_aesthetics_score和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、tab_analysis_aesthetics_score内出现数据、tab_analysis_total表内status=1，aesthetics_score=1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云图支持美学评分 end');
}

/**
 * 宫格-解析: [出现违法经纬度时，地点解析返回location_key=0]
 * GROUP: 宫格 MODULE: 解析TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_010
 * 前置条件
 * 1、手机电量大于50%，手机温度小于37℃
 2、图片相册预置带违法经纬度的图片
 */
async function APPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation010(dt: Dt) {
  dt.log.i('出现违法经纬度时，地点解析返回location_key=0 start');
  dt.log.i('STEP 1、充电，息屏，cmd界面实时查看地理解析处理日志：hdc  shell hilog  | grep  ""LocationJob Stop”');

  await dt.sleep();
  dt.log.i('预期结果1、出现日志打印，地点解析进程关闭');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、待一批完成，拉取数据查看tab_analysis_geo_dictionary、tab_analysis_geo_knowledge');

  await dt.sleep();
  dt.log.i('预期结果2、tab_analysis_geo_knowledge表内违法经纬度解析失败，location_key=-3');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('出现违法经纬度时，地点解析返回location_key=0 end');
}

/**
 * 宫格-: [图片地点经纬度的精度和xxx对齐]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_011
 * 前置条件
 * 准备存在经纬度的图片
 */
async function APPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation011(dt: Dt) {
  dt.log.i('图片地点经纬度的精度和xxx对齐 start');
  dt.log.i('STEP 1、用相机拍照，拉取数据库查看photos表中latitude和longitude字段');

  await dt.sleep();
  dt.log.i('预期结果1、图片经纬度精确到15位');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片地点经纬度的精度和xxx对齐 end');
}

/**
 * 宫格-: [图片地点经纬度可判断东西经和南北纬]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_GeographicalLocation_012
 * 前置条件
 * 1、准备分别存在东西经、南北纬的图片

 */
async function APPFWKMediaFwkMediaLibraryMediaCVGeographicalLocation012(dt: Dt) {
  dt.log.i('图片地点经纬度可判断东西经和南北纬 start');
  dt.log.i('STEP 1、将图片导入手机，查看数据库中photos表latitude和longitude字段');

  await dt.sleep();
  dt.log.i('预期结果1、图片的东经、北纬为正，西经、南纬为负');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片地点经纬度可判断东西经和南北纬 end');
}

/**
 * 宫格-: [支持图片与图片的遮罩转场，数量限制1个]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_001
 * 前置条件
 * 1.图库中存在可生成时刻的图片
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVMaskVideo001(dt: Dt) {
  dt.log.i('支持图片与图片的遮罩转场，数量限制1个 start');
  dt.log.i('STEP 1、点击时刻相册，进入时刻轮播');

  await dt.sleep();
  dt.log.i('预期结果1、轮播存在1个遮罩转场');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持图片与图片的遮罩转场，数量限制1个 end');
}

/**
 * 宫格-视频: [支持图片与视频的遮罩转场]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_002
 * 前置条件
 * 1.图库中存在可生成时刻的图片和视频
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVMaskVideo002(dt: Dt) {
  dt.log.i('支持图片与视频的遮罩转场 start');
  dt.log.i('STEP 1、点击时刻相册，进入时刻轮播');

  await dt.sleep();
  dt.log.i('预期结果1、非成长型视频时刻转场个数最大2个');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2、成长型视频转场个数每个视频最大2个转场，若有2个视频，最大4个遮罩转场');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持图片与视频的遮罩转场 end');
}

/**
 * 宫格-视频: [转场视频支持SDR效果]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_003
 * 前置条件
 * 1.图库中存在可生成时刻的图片和支持SDR效果的视频
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVMaskVideo003(dt: Dt) {
  dt.log.i('转场视频支持SDR效果 start');
  dt.log.i('STEP 1、点击时刻相册，进入时刻轮播');

  await dt.sleep();
  dt.log.i('预期结果1、时刻轮播到转场视频时，显示SDR效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击分享导出时刻轮播视频，查看导出的时刻轮播视频');

  await dt.sleep();
  dt.log.i('预期结果2、时刻轮播视频播放显示SDR效果');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('转场视频支持SDR效果 end');
}

/**
 * 宫格-视频: [新生成时刻或成长型时刻支持转场效果增加，非成长型时刻不支持]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_004
 * 前置条件
 * 1.图库中存在可生成时刻的图片和视频，成长型时刻图片和视频部分存在
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVMaskVideo004(dt: Dt) {
  dt.log.i('新生成时刻或成长型时刻支持转场效果增加，非成长型时刻不支持 start');
  dt.log.i('STEP 1、查看已生成的时刻相册，记录时刻转场个数，导出数据库文件');

  await dt.sleep();
  dt.log.i('STEP 2、新增一批时刻的图片和视频，充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 3、进入时刻相册，查看时刻变化，导出数据库文件与上一次做对比');

  await dt.sleep();
  dt.log.i('预期结果3、有转场效果增加，增加个数、类型符合预期，与数据库差异数据一致');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('新生成时刻或成长型时刻支持转场效果增加，非成长型时刻不支持 end');
}

/**
 * 宫格-视频: [剩余空间小于30G不支持遮罩增强转场]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_005
 * 前置条件
 * 1.图库中存在可生成时刻的图片和视频
 2.手机电量大于50%，充电灭屏分析
 3.预制空间占用剩余小于30G
 4.有时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVMaskVideo005(dt: Dt) {
  dt.log.i('剩余空间小于30G不支持遮罩增强转场 start');
  dt.log.i('STEP 1、点击时刻相册，进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、查看时刻轮播，导出数据库文件，查看tab_highlight_play_info、tab_analysis_asset_sd_map、tab_analysis_album_asset_map等表');

  await dt.sleep();
  dt.log.i('预期结果2.1、无增强转场效果显示2.2、数据库无增强转场相关字段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('剩余空间小于30G不支持遮罩增强转场 end');
}

/**
 * 宫格-视频: [数据库中转场信息字段与轮播效果一致]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_006
 * 前置条件
 * 1.图库中存在可生成时刻的图片和视频
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVMaskVideo006(dt: Dt) {
  dt.log.i('数据库中转场信息字段与轮播效果一致 start');
  dt.log.i('STEP 1、点击时刻相册，进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、查看时刻轮播，导出数据库文件，查看tab_highlight_play_info表');

  await dt.sleep();
  dt.log.i('预期结果2、轮播转场效果遮罩对应mask字段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('数据库中转场信息字段与轮播效果一致 end');
}

/**
 * 宫格-删除: [删除照片/视频后轮播中转场效果]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_007
 * 前置条件
 * 1.图库中存在可生成时刻的图片和视频
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVMaskVideo007(dt: Dt) {
  dt.log.i('删除照片/视频后轮播中转场效果 start');
  dt.log.i('STEP 1、点击时刻相册，进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、查看时刻轮播，导出数据库文件');

  await dt.sleep();
  dt.log.i('STEP 3、删除增强转场前后的照片/视频(移入最近删除相册)');

  await dt.sleep();
  dt.log.i('STEP 4、重新进入时刻，查看时刻轮播，导出数据库文件');

  await dt.sleep();
  dt.log.i('预期结果4、时刻轮播增强转场效果消失，数据库增强转场字段刷新6、与2步骤结果一致');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、恢复删除的增强转场前后的照片/视频(移出最近删除相册)');

  await dt.sleep();
  dt.log.i('STEP 6、重新进入时刻，查看时刻轮播，导出数据库文件');

  await dt.sleep();
  dt.log.i('预期结果6、与2步骤结果一致');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('删除照片/视频后轮播中转场效果 end');
}

/**
 * 宫格-端云: [端云关闭后轮播中转场效果]
 * GROUP: 宫格 MODULE: 端云TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_008
 * 前置条件
 * 1.图库云空间中存在可生成时刻的图片和视频
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVMaskVideo008(dt: Dt) {
  dt.log.i('端云关闭后轮播中转场效果 start');
  dt.log.i('STEP 1、点击时刻相册，进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、查看时刻轮播，导出数据库文件');

  await dt.sleep();
  dt.log.i('STEP 3、关闭云同步');

  await dt.sleep();
  dt.log.i('STEP 4、重新进入时刻，查看时刻轮播，导出数据库文件');

  await dt.sleep();
  dt.log.i('预期结果4.1、时刻相册不存在4.2、数据库增强转场字段刷新为空6、与步骤4结果一致');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、打开云同步');

  await dt.sleep();
  dt.log.i('STEP 6、点击时刻相册，进入时刻轮播');

  await dt.sleep();
  dt.log.i('预期结果6、与步骤4结果一致');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('端云关闭后轮播中转场效果 end');
}
