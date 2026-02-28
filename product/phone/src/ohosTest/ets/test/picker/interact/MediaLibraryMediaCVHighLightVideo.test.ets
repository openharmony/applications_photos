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


export default function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideoTest(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo001Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAPPFWKMediaFwkMediaLibraryMediaCVHighLightVideo001').init();
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo001 start');
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo001 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [精彩时刻支持相机相册内SDR高光视频入选时刻，高光总时长不超过5秒，且只有一个慢放镜头] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_001
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo001(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo002', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [精彩时刻不支持非相机相册内SDR高光视频入选时刻] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_002
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo002(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-HDR用例: [精彩时刻不支持HDR视频入选时刻] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_003
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo003(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [精彩时刻不支持2s以下，10min中以上视频入选时刻] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_004
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo004(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [精彩时刻不支持纯云端视频入选时刻] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_005
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo005(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-端云用例: [精彩时刻支持端云（本地+云）视频入选时刻] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_006
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo006(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [已生成的非成长型时刻不再扩充增加视频素材] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_007
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo007(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [每次新增的成长时刻视频片段不超过2个] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_008
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo008(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [非成长时刻视频片段总数不超过2个] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_009
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo009(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [规格支持不同类型的高光时刻都可以进入精彩时刻] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_010
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo010(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo011', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [删除/隐藏对应高光视频后精彩时刻内部去除该视频片段] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_011
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo011(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo012', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [精彩时刻视频支持美学去重] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_012
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo012(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo013', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [精彩时刻视频支持时间去重] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_013
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo013(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo014', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [精彩时刻视频支持地点去重] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_014
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo014(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo015', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [单人时刻支持高光片段] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_015
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo015(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [宠物猫时刻支持高光片段] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_016
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo016(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo017', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [宠物狗时刻支持高光片段] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_017
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo017(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo018', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [地域美食时刻支持高光片段] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_018
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo018(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo019', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [生日时刻支持高光片段] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_019
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo019(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo020', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [毕业时刻支持高光片段] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_020
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo020(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo021', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [成长型时刻支持高光效果叠加，非成长型时刻不支持] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_021
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo021(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo022', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [高光规格-总时长小于5s，一个时刻仅有一个慢放] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_022
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo022(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo023', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-HDR用例: [高光规格-支持SDR，不支持HDR] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_023
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo023(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo024', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [时刻相册与时刻生成文件、源文件在数据库中的映射关联字段] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_024
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo024(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo025', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [删除高光视频] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_025
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo025(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo026', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [高光处理日志打点] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_026
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo026(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo027', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [剩余存储空间小于30G时不支持高光处理] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_027
      await APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo027(dt);
    });

    run('APPFWKMediaFwkMediaLibraryMediaCVMaskVideo009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [增强转场日志打点信息] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_009
      await APPFWKMediaFwkMediaLibraryMediaCVMaskVideo009(dt);
    });

    run('MultimediaGalleryPhotoPickerMarginComponent0145', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-动态照片用例: [克隆，半模态picker（如：备忘录）,动态照片不关闭动态，角标验证] TID: Multimedia_Gallery_PhotoPickerMarginComponent_0145
      await MultimediaGalleryPhotoPickerMarginComponent0145(dt);
    });

    run('MultimediaGalleryPhotoPickerMarginComponent0146', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-动态照片用例: [本地，嵌入式picker（如：小红书）,动态照片角标验证] TID: Multimedia_Gallery_PhotoPickerMarginComponent_0146
      await MultimediaGalleryPhotoPickerMarginComponent0146(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachAPPFWKMediaFwkMediaLibraryMediaCVHighLightVideo001').init();
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo001 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo001 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllAPPFWKMediaFwkMediaLibraryMediaCVHighLightVideo001').init();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo001 start');
      await Exit.browser();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo001 finish');
    });
  });
}

/**
 * 宫格-视频: [精彩时刻支持相机相册内SDR高光视频入选时刻，高光总时长不超过5秒，且只有一个慢放镜头]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_001
 * 前置条件
 * 1、手机电量大于50%
 2、相机相册内预置200张图片+4个10s的SDR视频（符合高光时刻生成的素材）
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo001(dt: Dt) {
  dt.log.i('精彩时刻支持相机相册内SDR高光视频入选时刻，高光总时长不超过5秒，且只有一个慢放镜头 start');
  dt.log.i('STEP 1、充电，息屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻界面，进入轮播界面');

  await dt.sleep();
  dt.log.i('预期结果2.存在高光视频入选，视频时长少于5秒，存在慢放镜头');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('精彩时刻支持相机相册内SDR高光视频入选时刻，高光总时长不超过5秒，且只有一个慢放镜头 end');
}

/**
 * 宫格-视频: [精彩时刻不支持非相机相册内SDR高光视频入选时刻]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_002
 * 前置条件
 * 1、手机电量大于50%
 2、相机相册内预置200张图片+非相机相册4个10s的SDR视频（符合高光时刻生成的素材）
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo002(dt: Dt) {
  dt.log.i('精彩时刻不支持非相机相册内SDR高光视频入选时刻 start');
  dt.log.i('STEP 1、充电，息屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻界面，进入轮播界面');

  await dt.sleep();
  dt.log.i('预期结果2、精彩时刻内没有高光片段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('精彩时刻不支持非相机相册内SDR高光视频入选时刻 end');
}

/**
 * 宫格-HDR: [精彩时刻不支持HDR视频入选时刻]
 * GROUP: 宫格 MODULE: HDRTID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_003
 * 前置条件
 * 1、手机电量大于50%
 2、相机相册内预置200张图片+非相机相册4个10s的HDR视频（符合高光时刻生成的素材）
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo003(dt: Dt) {
  dt.log.i('精彩时刻不支持HDR视频入选时刻 start');
  dt.log.i('STEP 1、充电，息屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻界面');

  await dt.sleep();
  dt.log.i('预期结果2、精彩时刻内没有高光片段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('精彩时刻不支持HDR视频入选时刻 end');
}

/**
 * 宫格-视频: [精彩时刻不支持2s以下，10min中以上视频入选时刻]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_004
 * 前置条件
 * 1、手机电量大于50%
 2、相机相册内预置200张图片+相机相册2个2s的SDR视频,2个11min的SDR视频（符合高光时刻生成的素材）
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo004(dt: Dt) {
  dt.log.i('精彩时刻不支持2s以下，10min中以上视频入选时刻 start');
  dt.log.i('STEP 1、充电，息屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻界面');

  await dt.sleep();
  dt.log.i('预期结果2、精彩时刻内没有高光片段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('精彩时刻不支持2s以下，10min中以上视频入选时刻 end');
}

/**
 * 宫格-视频: [精彩时刻不支持纯云端视频入选时刻]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_005
 * 前置条件
 * 1、手机电量大于50%
 2、打开云同步开关，同步4个10s的SDR视频（符合高光时刻生成的素材）
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo005(dt: Dt) {
  dt.log.i('精彩时刻不支持纯云端视频入选时刻 start');
  dt.log.i('STEP 1、充电，息屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻界面');

  await dt.sleep();
  dt.log.i('预期结果2、精彩时刻内没有高光片段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('精彩时刻不支持纯云端视频入选时刻 end');
}

/**
 * 宫格-端云: [精彩时刻支持端云（本地+云）视频入选时刻]
 * GROUP: 宫格 MODULE: 端云TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_006
 * 前置条件
 * 1、手机电量大于50%
 2、打开云同步开关，同步个4个10s的SDR视频（符合高光时刻生成的素材）并且点击播放下载
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo006(dt: Dt) {
  dt.log.i('精彩时刻支持端云（本地+云）视频入选时刻 start');
  dt.log.i('STEP 1、充电，息屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻界面');

  await dt.sleep();
  dt.log.i('预期结果2.存在高光视频入选，视频时长少于5秒，存在慢放镜头');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('精彩时刻支持端云（本地+云）视频入选时刻 end');
}

/**
 * 宫格-视频: [已生成的非成长型时刻不再扩充增加视频素材]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_007
 * 前置条件
 * 1、手机内预存景区时刻
 2、插入该景区地址的高光视频
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo007(dt: Dt) {
  dt.log.i('已生成的非成长型时刻不再扩充增加视频素材 start');
  dt.log.i('STEP 1、充电，息屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻界面');

  await dt.sleep();
  dt.log.i('预期结果2、预存的景区时刻内没有新增高光片段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('已生成的非成长型时刻不再扩充增加视频素材 end');
}

/**
 * 宫格-视频: [每次新增的成长时刻视频片段不超过2个]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_008
 * 前置条件
 * 1、手机电量大于50%，并且存在一个带有高光的美食时刻
 2、相机相册内新增该地域的200张图片+4个10s的SDR视频（符合高光时刻生成的美食素材）
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo008(dt: Dt) {
  dt.log.i('每次新增的成长时刻视频片段不超过2个 start');
  dt.log.i('STEP 1、充电，息屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻界面');

  await dt.sleep();
  dt.log.i('预期结果2、预存的美食时刻内新增1~2个高光片段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('每次新增的成长时刻视频片段不超过2个 end');
}

/**
 * 宫格-视频: [非成长时刻视频片段总数不超过2个]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_009
 * 前置条件
 * 1、手机电量大于50%
 2、相机相册内预置200张景区图片+10个10s的SDR视频（符合高光时刻生成的景区素材）
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo009(dt: Dt) {
  dt.log.i('非成长时刻视频片段总数不超过2个 start');
  dt.log.i('STEP 1、充电，息屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻界面');

  await dt.sleep();
  dt.log.i('预期结果2、景区时刻内有1~2个高光片段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('非成长时刻视频片段总数不超过2个 end');
}

/**
 * 宫格-视频: [规格支持不同类型的高光时刻都可以进入精彩时刻]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_010
 * 前置条件
 * 1、手机电量大于50%
 2、各类型的高光视频和图片集成后，统一打包插入进手机
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo010(dt: Dt) {
  dt.log.i('规格支持不同类型的高光时刻都可以进入精彩时刻 start');
  dt.log.i('STEP 1、充电，息屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻界面');

  await dt.sleep();
  dt.log.i('预期结果2、生成人像，毕业、生日、美食、宠物的高光片段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('规格支持不同类型的高光时刻都可以进入精彩时刻 end');
}

/**
 * 宫格-删除: [删除/隐藏对应高光视频后精彩时刻内部去除该视频片段]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_011
 * 前置条件
 * 1、手机内存在高光时刻
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo011(dt: Dt) {
  dt.log.i('删除/隐藏对应高光视频后精彩时刻内部去除该视频片段 start');
  dt.log.i('STEP 1、删除\隐藏手机高光时刻中的高光片段');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻界面');

  await dt.sleep();
  dt.log.i('预期结果2、时刻内的高光片段消失');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('删除/隐藏对应高光视频后精彩时刻内部去除该视频片段 end');
}

/**
 * 宫格-视频: [精彩时刻视频支持美学去重]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_012
 * 前置条件
 * 1.手机电量大于50%,相机相册内预置200张图片
 2.插入的存在垃圾、马桶、纸屑的5个10s的SDR视频（符合高光时刻生成的素材） 和5个正常的10s的SDR高光视频

 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo012(dt: Dt) {
  dt.log.i('精彩时刻视频支持美学去重 start');
  dt.log.i('STEP 1、充电，息屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻界面');

  await dt.sleep();
  dt.log.i('预期结果2、没有负面的时刻视频入选');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('精彩时刻视频支持美学去重 end');
}

/**
 * 宫格-视频: [精彩时刻视频支持时间去重]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_013
 * 前置条件
 * 1.手机电量大于50%,相机相册内预置200张图片
 2.插入10个10s的SDR视频（符合高光时刻生成的素材）视频之间的拍摄时间间隔<15s

 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo013(dt: Dt) {
  dt.log.i('精彩时刻视频支持时间去重 start');
  dt.log.i('STEP 1、充电，息屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻界面');

  await dt.sleep();
  dt.log.i('预期结果2、插入视频中仅有一个视频入选');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('精彩时刻视频支持时间去重 end');
}

/**
 * 宫格-视频: [精彩时刻视频支持地点去重]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_014
 * 前置条件
 * 1.手机电量大于50%,相机相册内预置200张图片
 2.插入10个10s的SDR视频（符合高光时刻生成的素材）之间的地理位置经纬度间隔<15m

 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo014(dt: Dt) {
  dt.log.i('精彩时刻视频支持地点去重 start');
  dt.log.i('STEP 1、充电，息屏，等待CV分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻界面');

  await dt.sleep();
  dt.log.i('预期结果2、插入视频中仅有一个视频入选');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('精彩时刻视频支持地点去重 end');
}

/**
 * 宫格-视频: [单人时刻支持高光片段]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_015
 * 前置条件
 * 1.图库中存在可生成单人时刻的高光场景图片和视频
 2.手机电量大于50%，充电灭屏分析
 3.有单人时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo015(dt: Dt) {
  dt.log.i('单人时刻支持高光片段 start');
  dt.log.i('STEP 1、打开图库进入时刻');

  await dt.sleep();
  dt.log.i('STEP 2、查看对应单人时刻轮播');

  await dt.sleep();
  dt.log.i('预期结果2、时刻轮播存在人物高光片段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('单人时刻支持高光片段 end');
}

/**
 * 宫格-视频: [宠物猫时刻支持高光片段]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_016
 * 前置条件
 * 1.图库中存在可生成宠物猫时刻的高光场景图片和视频
 2.手机电量大于50%，充电灭屏分析
 3.有宠物猫时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo016(dt: Dt) {
  dt.log.i('宠物猫时刻支持高光片段 start');
  dt.log.i('STEP 1、打开图库进入时刻');

  await dt.sleep();
  dt.log.i('STEP 2、查看对应宠物猫时刻轮播');

  await dt.sleep();
  dt.log.i('预期结果2、时刻轮播存在宠物猫高光片段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宠物猫时刻支持高光片段 end');
}

/**
 * 宫格-视频: [宠物狗时刻支持高光片段]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_017
 * 前置条件
 * 1.图库中存在可生成宠物狗时刻的高光场景图片和视频
 2.手机电量大于50%，充电灭屏分析
 3.有宠物狗时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo017(dt: Dt) {
  dt.log.i('宠物狗时刻支持高光片段 start');
  dt.log.i('STEP 1、打开图库进入时刻');

  await dt.sleep();
  dt.log.i('STEP 2、查看对应宠物狗时刻轮播');

  await dt.sleep();
  dt.log.i('预期结果2、时刻轮播存在宠物狗高光片段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宠物狗时刻支持高光片段 end');
}

/**
 * 宫格-视频: [地域美食时刻支持高光片段]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_018
 * 前置条件
 * 1.图库中存在可生成美食时刻的高光场景图片和视频
 2.手机电量大于50%，充电灭屏分析
 3.有美食时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo018(dt: Dt) {
  dt.log.i('地域美食时刻支持高光片段 start');
  dt.log.i('STEP 1、打开图库进入时刻');

  await dt.sleep();
  dt.log.i('STEP 2、查看对应美食时刻轮播');

  await dt.sleep();
  dt.log.i('预期结果2、时刻轮播存在地域美食高光片段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地域美食时刻支持高光片段 end');
}

/**
 * 宫格-视频: [生日时刻支持高光片段]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_019
 * 前置条件
 * 1.图库中存在可生成生日时刻的高光场景图片和视频
 2.手机电量大于50%，充电灭屏分析
 3.有生日时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo019(dt: Dt) {
  dt.log.i('生日时刻支持高光片段 start');
  dt.log.i('STEP 1、打开图库进入时刻');

  await dt.sleep();
  dt.log.i('STEP 2、查看对应生日时刻轮播');

  await dt.sleep();
  dt.log.i('预期结果2、时刻轮播存在生日高光片段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('生日时刻支持高光片段 end');
}

/**
 * 宫格-视频: [毕业时刻支持高光片段]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_020
 * 前置条件
 * 1.图库中存在可生成毕业时刻的高光场景图片和视频
 2.手机电量大于50%，充电灭屏分析
 3.有毕业时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo020(dt: Dt) {
  dt.log.i('毕业时刻支持高光片段 start');
  dt.log.i('STEP 1、打开图库进入时刻');

  await dt.sleep();
  dt.log.i('STEP 2、查看对应毕业时刻轮播');

  await dt.sleep();
  dt.log.i('预期结果2、时刻轮播存在毕业高光片段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('毕业时刻支持高光片段 end');
}

/**
 * 宫格-视频: [成长型时刻支持高光效果叠加，非成长型时刻不支持]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_021
 * 前置条件
 * 1.有成长性时刻相册和有非成长性时刻相册生成
 2.有新的可生成成长性时刻的高光场景图片和视频
 3.有新的可生成非成长性时刻的高光场景图片和视频
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo021(dt: Dt) {
  dt.log.i('成长型时刻支持高光效果叠加，非成长型时刻不支持 start');
  dt.log.i('STEP 1、打开图库进入时刻，查看当前已存在的时刻，导出数据库');

  await dt.sleep();
  dt.log.i('STEP 2、导入新的可生成时刻的高光场景图片和视频，充电灭屏，待后台分析完成');

  await dt.sleep();
  dt.log.i('STEP 3、打开图库进入时刻，查看时刻变化，与之前的时刻差异');

  await dt.sleep();
  dt.log.i('预期结果3.1、成长型时刻有新增的高光片段3.2、非成长型时刻无变化');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('成长型时刻支持高光效果叠加，非成长型时刻不支持 end');
}

/**
 * 宫格-视频: [高光规格-总时长小于5s，一个时刻仅有一个慢放]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_022
 * 前置条件
 * 1.图库中存在可生成高光时刻的图片和视频
 2.手机电量大于50%，充电灭屏分析
 3.有存在高光片段时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo022(dt: Dt) {
  dt.log.i('高光规格-总时长小于5s，一个时刻仅有一个慢放 start');
  dt.log.i('STEP 1、打开图库进入时刻');

  await dt.sleep();
  dt.log.i('STEP 2、查看时刻轮播');

  await dt.sleep();
  dt.log.i('预期结果2.1、若时刻只有1个高光片段，高光片段慢放时长小于5s2.2、若有多个高光片段，高光片段总时长小于5s，且仅有1个高光片段慢放');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('高光规格-总时长小于5s，一个时刻仅有一个慢放 end');
}

async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo023(dt: Dt) {
  dt.log.i('高光规格-支持SDR，不支持HDR start');
  dt.log.i('STEP 1、打开图库进入时刻');

  await dt.sleep();
  dt.log.i('STEP 2、查看时刻轮播');

  await dt.sleep();
  dt.log.i('预期结果2.1、轮播高光片段时有SDR效果');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('高光规格-支持SDR，不支持HDR end');
}

/**
 * 宫格-视频: [时刻相册与时刻生成文件、源文件在数据库中的映射关联字段]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_024
 * 前置条件
 * 1.图库中存在可生成高光时刻的图片和视频
 2.手机电量大于50%，充电灭屏分析
 3.有存在高光片段时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo024(dt: Dt) {
  dt.log.i('时刻相册与时刻生成文件、源文件在数据库中的映射关联字段 start');
  dt.log.i('STEP 1、打开图库进入时刻');

  await dt.sleep();
  dt.log.i('STEP 2、查看时刻轮播');

  await dt.sleep();
  dt.log.i('预期结果2、时刻轮播存在高光片段，无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、抓取数据库文件，查看tab_hightlight_play_info表对应时刻行的play_info列，搜索关键字""TYPE_HILIGHT_SLOW""');

  await dt.sleep();
  dt.log.i('预期结果3.1、一个时刻中，TYPE_HILIGHT_SLOW字段数量小于等于23.2、effectvideoTrack字段有值不为空，与album_Id、file_Id对应说明：effectvideoTrack为源视频文件片段，album_Id为时刻相册，file_Id为源文件');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻相册与时刻生成文件、源文件在数据库中的映射关联字段 end');
}

/**
 * 宫格-删除: [删除高光视频]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_025
 * 前置条件
 * 1.图库中存在可生成高光时刻的图片和视频
 2.手机电量大于50%，充电灭屏分析
 3.有存在高光片段时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo025(dt: Dt) {
  dt.log.i('删除高光视频 start');
  dt.log.i('STEP 1、打开图库进入时刻，点击时刻封面，查看时刻轮播，导出数据库文件');

  await dt.sleep();
  dt.log.i('STEP 2、上滑进入二级宫格界面，删除高光视频，进入最近删除相册彻底删除');

  await dt.sleep();
  dt.log.i('STEP 3、回到时刻tab页，查看时刻轮播，导出数据库文件');

  await dt.sleep();
  dt.log.i('预期结果3.1、时刻轮播没有高光片段3.2、对比步骤1数据库文件，TYPE_HILIGHT_SLOW字段刷新');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('删除高光视频 end');
}

/**
 * 宫格-视频: [高光处理日志打点]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_026
 * 前置条件
 * 1.图库中存在可生成高光时刻的图片和视频
 2.手机电量大于50%，充电灭屏分析
 3.有存在高光片段时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo026(dt: Dt) {
  dt.log.i('高光处理日志打点 start');
  dt.log.i('STEP 1、点击时刻相册，进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、查看时刻轮播，导出日志文件，查看');

  await dt.sleep();
  dt.log.i('预期结果2.1、源视频文件ID及片段帧，生成高光视频结果（执行结果、执行次数、取消次数）、一个视频素材高光整体处理时长、高光检测时长、插帧时长，生成视频大小与时长，高光检测到的最佳帧，及最佳帧对应的分数2.2、信息符合设计要求');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('高光处理日志打点 end');
}

/**
 * 宫格-视频: [剩余存储空间小于30G时不支持高光处理]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_HighLight_Video_027
 * 前置条件
 * 1.图库中存在可生成时刻的图片和视频
 2.手机电量大于50%，充电灭屏分析
 3.预制空间占用剩余小于30G
 4.有时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVHighLightVideo027(dt: Dt) {
  dt.log.i('剩余存储空间小于30G时不支持高光处理 start');
  dt.log.i('STEP 1、点击时刻相册，进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、查看时刻轮播，导出数据库文件，查看tab_highlight_play_info、tab_analysis_asset_sd_map、tab_analysis_album_asset_map等表');

  await dt.sleep();
  dt.log.i('预期结果2.1、时刻轮播无高光片段播放2.2、数据库”TYPE_HILIGHT_SLOW”相关字段为空');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('TYPE_HILIGHT_SLOW'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('剩余存储空间小于30G时不支持高光处理 end');
}

/**
 * 宫格-视频: [增强转场日志打点信息]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_Mask_Video_009
 * 前置条件
 * 1.图库中存在可生成时刻的图片和视频
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function APPFWKMediaFwkMediaLibraryMediaCVMaskVideo009(dt: Dt) {
  dt.log.i('增强转场日志打点信息 start');
  dt.log.i('STEP 1、点击时刻相册，进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、查看时刻轮播，导出日志文件，查看');

  await dt.sleep();
  dt.log.i('预期结果2.1、打点信息包含原图片/视频ID、label、执行结果、执行次数、取消次数、一个转场处理总时长、生成视频大小、时长2.2、信息符合设计要求');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('增强转场日志打点信息 end');
}

/**
 * picker-动态照片: [克隆，半模态picker（如：备忘录）,动态照片不关闭动态，角标验证]
 * GROUP: picker MODULE: 动态照片TID: Multimedia_Gallery_PhotoPickerMarginComponent_0145
 * 前置条件
 * 1.已克隆多张动态照片资源

 */
async function MultimediaGalleryPhotoPickerMarginComponent0145(dt: Dt) {
  dt.log.i('克隆，半模态picker（如：备忘录）,动态照片不关闭动态，角标验证 start');
  dt.log.i('STEP 1.进入图库，关闭一张动态照片的动态效果');

  await dt.sleep();
  dt.log.i('STEP 2.备忘录调起picker');

  await dt.sleep();
  dt.log.i('预期结果2.关闭动态效果的动态图片没有动态照片的角标，没有关闭动态效果的动态图片有动态照片的角标');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('克隆，半模态picker（如：备忘录）,动态照片不关闭动态，角标验证 end');
}

/**
 * picker-动态照片: [本地，嵌入式picker（如：小红书）,动态照片角标验证]
 * GROUP: picker MODULE: 动态照片TID: Multimedia_Gallery_PhotoPickerMarginComponent_0146
 * 前置条件
 * 1.本地系统相机拍摄多张动态照片（如拍摄五张动态照片，其中一张拍摄时关闭动态）
 */
async function MultimediaGalleryPhotoPickerMarginComponent0146(dt: Dt) {
  dt.log.i('本地，嵌入式picker（如：小红书）,动态照片角标验证 start');
  dt.log.i('STEP 1.小红书调起picker进入宫格');

  await dt.sleep();
  dt.log.i('预期结果1.关闭动态效果的动态图片没有动态照片的角标，没有关闭动态效果的动态图片有动态照片的角标');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地，嵌入式picker（如：小红书）,动态照片角标验证 end');
}
