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

export default function HDRpictureTest(): void {
  describe('HDRpictureTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    // 确认当前图库app处于启动状态
    beforeAll(async (): Promise<void> => {
      // 进入图库
      await AppStart.photos()
    });
    run('beforeUiDemoTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      // 打开大图
      await dt.browser();
    });

    // DT声明
    run('Multimedia_Gallery_HDRpicture_001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [HDR格式图片显示] TID: Multimedia_Gallery_HDRpicture_001
      await Multimedia_Gallery_HDRpicture_001(dt);
    });
    run('Multimedia_Gallery_HDRpicture_002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [xxxHDR格式图片显示] TID: Multimedia_Gallery_HDRpicture_002
      await Multimedia_Gallery_HDRpicture_002(dt);
    });
    run('Multimedia_Gallery_HDRpicture_003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [xxxSDR格式图显示] TID: Multimedia_Gallery_HDRpicture_003
      await Multimedia_Gallery_HDRpicture_003(dt);
    });
    run('Multimedia_Gallery_HDRpicture_004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [低质量图到高质量图HDR格式图片显示] TID: Multimedia_Gallery_HDRpicture_004
      await Multimedia_Gallery_HDRpicture_004(dt);
    });
    run('Multimedia_Gallery_HDRpicture_005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [操作HDR格式图片显示] TID: Multimedia_Gallery_HDRpicture_005
      await Multimedia_Gallery_HDRpicture_005(dt);
    });
    run('Multimedia_Gallery_HDRpicture_006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [xxxHDR格式图片显示] TID: Multimedia_Gallery_HDRpicture_006
      await Multimedia_Gallery_HDRpicture_006(dt);
    });
    run('Multimedia_Gallery_HDRpicture_007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [云上HDR格式图片显示] TID: Multimedia_Gallery_HDRpicture_007
      await Multimedia_Gallery_HDRpicture_007(dt);
    });
    run('Multimedia_Gallery_HDRpicture_008', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [HDR格式图片显示功耗测试] TID: Multimedia_Gallery_HDRpicture_008
      await Multimedia_Gallery_HDRpicture_008(dt);
    });
    run('Multimedia_Gallery_HDRpicture_009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [三方picker页面查看图片大图] TID: Multimedia_Gallery_HDRpicture_009
      await Multimedia_Gallery_HDRpicture_009(dt);
    });
    run('Multimedia_Gallery_HDRpicture_010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [智慧相册封面显示效果] TID: Multimedia_Gallery_HDRpicture_010
      await Multimedia_Gallery_HDRpicture_010(dt);
    });
    run('Multimedia_Gallery_HDRpicture_011', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [xxxHDR格式图片显示 Copy of (1)] TID: Multimedia_Gallery_HDRpicture_011
      await Multimedia_Gallery_HDRpicture_011(dt);
    });
    run('Multimedia_Gallery_HDRpicture_012', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [xxxSDR格式图片显示] TID: Multimedia_Gallery_HDRpicture_012
      await Multimedia_Gallery_HDRpicture_012(dt);
    });
    run('Multimedia_Gallery_HDRpicture_013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [云上图片显示HDR高亮效果] TID: Multimedia_Gallery_HDRpicture_013
      await Multimedia_Gallery_HDRpicture_013(dt);
    });
    run('Multimedia_Gallery_HDRpicture_014', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [SDR图片显示高亮效果] TID: Multimedia_Gallery_HDRpicture_014
      await Multimedia_Gallery_HDRpicture_014(dt);
    });
    run('Multimedia_Gallery_HDRpicture_015', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [动态照片查看HDR显示效果] TID: Multimedia_Gallery_HDRpicture_015
      await Multimedia_Gallery_HDRpicture_015(dt);
    });
    run('Multimedia_Gallery_HDRpicture_016', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [HDR格式图片显示功耗测试 Copy of (1)] TID: Multimedia_Gallery_HDRpicture_016
      await Multimedia_Gallery_HDRpicture_016(dt);
    });
    run('Multimedia_Gallery_HDRpicture_017', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [连拍照片查看HDR显示效果] TID: Multimedia_Gallery_HDRpicture_017
      await Multimedia_Gallery_HDRpicture_017(dt);
    });
    run('Multimedia_Gallery_HDRpicture_018', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [HDR图片分享预览显示效果] TID: Multimedia_Gallery_HDRpicture_018
      await Multimedia_Gallery_HDRpicture_018(dt);
    });
    run('Multimedia_Gallery_HDRpicture_019', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [HDR开关关闭] TID: Multimedia_Gallery_HDRpicture_019
      await Multimedia_Gallery_HDRpicture_019(dt);
    });
    run('Multimedia_Gallery_HDRpicture_020', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [悬浮窗状态查看HDR图片] TID: Multimedia_Gallery_HDRpicture_020
      await Multimedia_Gallery_HDRpicture_020(dt);
    });
    run('Multimedia_Gallery_HDRpicture_021', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [分屏状态查看HDR图片] TID: Multimedia_Gallery_HDRpicture_021
      await Multimedia_Gallery_HDRpicture_021(dt);
    });
    run('Multimedia_Gallery_HDRpicture_022', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [深色模式状态查看HDR图片] TID: Multimedia_Gallery_HDRpicture_022
      await Multimedia_Gallery_HDRpicture_022(dt);
    });
    run('Multimedia_Gallery_HDRpicture_299', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [有线投屏下，对端的图片和视频的显示HDR效果测试] TID: Multimedia_Gallery_HDRpicture_299
      await Multimedia_Gallery_HDRpicture_299(dt);
    });
    run('Multimedia_Gallery_HDRpicture_399', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [无线投屏下，对端的图片和视频的显示HDR效果测试] TID: Multimedia_Gallery_HDRpicture_399
      await Multimedia_Gallery_HDRpicture_399(dt);
    });


    // 退出大图 回到时间线页面
    afterAll(async (): Promise<void> => await Exit.browser());
    // 确保每次测试完毕回到大图页
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEach DemoUi').init();
      dt.log.i('afterEach DemoUi test');
      dt.log.i('afterEach DemoUi test finish');
    });
  });
}

// DT步骤
/**
 * 大图-HDR: [HDR格式图片显示]
 * TAG: 24 TID: Multimedia_Gallery_HDRpicture_001
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_001(dt: Dt) {
  dt.log.i('HDR格式图片显示 start');
  dt.log.i('STEP 1、xxx相机拍摄一张HDR格式图片（相机拍的图片默认是HDR格式）');

  await dt.sleep();
  dt.log.i('预期结果1、图片亮部有逐渐的提亮效果，过程动效正常无跳变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进大图查看图片显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HDR格式图片显示 end');
}

/**
 * 大图-HDR: [xxxHDR格式图片显示]
 * TAG: 14 TID: Multimedia_Gallery_HDRpicture_002
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_002(dt: Dt) {
  dt.log.i('xxxHDR格式图片显示 start');
  dt.log.i('STEP 1、xxx拍摄一张HDR格式图片');

  await dt.sleep();
  dt.log.i('预期结果1、图片亮部有逐渐的提亮效果，过程动效正常无跳变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进大图查看图片显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxxHDR格式图片显示 end');
}

/**
 * 大图-格式: [xxxSDR格式图显示]
 * TAG: 13 TID: Multimedia_Gallery_HDRpicture_003
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_003(dt: Dt) {
  dt.log.i('xxxSDR格式图显示 start');
  dt.log.i('STEP 1、相机拍摄普通SDR格式图片');

  await dt.sleep();
  dt.log.i('预期结果1、图片亮部有逐渐的提亮效果，过程动效正常无跳变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、用相机拍摄不同拍摄模式的图片');

  await dt.sleep();
  dt.log.i('STEP 3、用相机拍摄各种分辨率的图片');

  await dt.sleep();
  dt.log.i('STEP 4、设置不同水印，拍摄带水印的图片4、进大图查看图片显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxxSDR格式图显示 end');
}

/**
 * 大图-HDR: [低质量图到高质量图HDR格式图片显示]
 * TAG: 18 TID: Multimedia_Gallery_HDRpicture_004
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_004(dt: Dt) {
  dt.log.i('低质量图到高质量图HDR格式图片显示 start');
  dt.log.i('STEP 1、相机连续拍摄十张HDR格式图片');

  await dt.sleep();
  dt.log.i('预期结果1、图片亮部有逐渐的提亮效果，过程动效正常无跳变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进大图查看图片显示情况');

  await dt.sleep();
  dt.log.i('STEP 3、相机连续拍摄十张SDR格式图片');

  await dt.sleep();
  dt.log.i('STEP 4、进大图查看图片显示情况');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('低质量图到高质量图HDR格式图片显示 end');
}

/**
 * 大图-HDR: [操作HDR格式图片显示]
 * TAG: 16 TID: Multimedia_Gallery_HDRpicture_005
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_005(dt: Dt) {
  dt.log.i('操作HDR格式图片显示 start');
  dt.log.i('STEP 1、进大图查看HDR图片');

  await dt.sleep();
  dt.log.i('预期结果1、图片亮部有逐渐的提亮效果，过程动效正常无跳变，不会出现亮度过暗或过曝');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、图片显示过程中上滑查看详情');

  await dt.sleep();
  dt.log.i('预期结果2、图片依然显示提亮效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、下滑返回');

  await dt.sleep();
  dt.log.i('预期结果3、返回大图浏览，图片依然显示提亮效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、对图片进行编辑保存');

  await dt.sleep();
  dt.log.i('预期结果4、图片依然显示提亮效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、退出编辑');

  await dt.sleep();
  dt.log.i('预期结果5、图片依然显示提亮效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('操作HDR格式图片显示 end');
}

/**
 * 大图-HDR: [xxxHDR格式图片显示]
 * TAG: 19 TID: Multimedia_Gallery_HDRpicture_006
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_006(dt: Dt) {
  dt.log.i('xxxHDR格式图片显示 start');
  dt.log.i('STEP 1、xxx拍摄一张HDR格式的图片');

  await dt.sleep();
  dt.log.i('预期结果1、图片亮部有逐渐的提亮效果，过程动效正常无跳变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、通过分享，克隆，云同步到xxx手机上');

  await dt.sleep();
  dt.log.i('STEP 3、xxx上进大图查看图片显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxxHDR格式图片显示 end');
}

/**
 * 大图-HDR: [云上HDR格式图片显示]
 * TAG: 15 TID: Multimedia_Gallery_HDRpicture_007
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_007(dt: Dt) {
  dt.log.i('云上HDR格式图片显示 start');
  dt.log.i('STEP 1、xxx拍摄HDR格式的图片上行');

  await dt.sleep();
  dt.log.i('STEP 2、xxx下行过来查看');

  await dt.sleep();
  dt.log.i('预期结果2、图片亮部有逐渐的提亮效果，过程动效正常无跳变4、图片亮部有逐渐的提亮效果，过程动效正常无跳变6、图片亮部有逐渐的提亮效果，过程动效正常无跳变8、图片亮部有逐渐的提亮效果，过程动效正常无跳变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、xxx拍摄SDR格式的图片上行');

  await dt.sleep();
  dt.log.i('STEP 4、xxx下行过来查看');

  await dt.sleep();
  dt.log.i('预期结果4、图片亮部有逐渐的提亮效果，过程动效正常无跳变6、图片亮部有逐渐的提亮效果，过程动效正常无跳变8、图片亮部有逐渐的提亮效果，过程动效正常无跳变');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、xxx拍摄HDR格式的图片上行');

  await dt.sleep();
  dt.log.i('STEP 6、xxx下行过来查看');

  await dt.sleep();
  dt.log.i('预期结果6、图片亮部有逐渐的提亮效果，过程动效正常无跳变8、图片亮部有逐渐的提亮效果，过程动效正常无跳变');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、xxx拍摄SDR格式的图片上行');

  await dt.sleep();
  dt.log.i('STEP 8、xxx下行过来查看');

  await dt.sleep();
  dt.log.i('预期结果8、图片亮部有逐渐的提亮效果，过程动效正常无跳变');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云上HDR格式图片显示 end');
}

/**
 * 大图-HDR: [HDR格式图片显示功耗测试]
 * TAG: 17 TID: Multimedia_Gallery_HDRpicture_008
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_008(dt: Dt) {
  dt.log.i('HDR格式图片显示功耗测试 start');
  dt.log.i('STEP 1、xxx拍摄一张HDR格式图片');

  await dt.sleep();
  dt.log.i('预期结果1、功耗不高于xxxHDR图片大图浏览');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进大图查看图片显示');

  await dt.sleep();
  dt.log.i('STEP 3、查看过程中功耗');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HDR格式图片显示功耗测试 end');
}

/**
 * 大图-大图: [三方picker页面查看图片大图] DP20·
 * TAG: 20 TID: Multimedia_Gallery_HDRpicture_009
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_009(dt: Dt) {
  dt.log.i('三方picker页面查看图片大图 start');
  dt.log.i('STEP 1、使用三方应用拉起图库picker页面');

  await dt.sleep();
  dt.log.i('预期结果1、picker页面整体显示效果和图库保持一致');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看宫格缩略图显示情况');

  await dt.sleep();
  dt.log.i('预期结果2、缩略图不显示高亮效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点进缩略图进入图片大图查看');

  await dt.sleep();
  dt.log.i('预期结果3、大图页面显示高亮效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('三方picker页面查看图片大图 end');
}

/**
 * 大图-HDR: [智慧相册封面显示效果]
 * TAG: 32 TID: Multimedia_Gallery_HDRpicture_010
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 2、已生成智慧相册和精彩时刻
 */
async function Multimedia_Gallery_HDRpicture_010(dt: Dt) {
  dt.log.i('智慧相册封面显示效果 start');
  dt.log.i('STEP 1、在相册页面浏览');

  await dt.sleep();
  dt.log.i('预期结果1、相册封面显示正常，不显示高亮效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看人像相册、地点相册、分类相册等智慧相册');

  await dt.sleep();
  dt.log.i('预期结果2、智慧相册封面显示正常，不显示高亮效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在精彩时刻页面浏览');

  await dt.sleep();
  dt.log.i('预期结果3、精彩时刻封面显示正常，不显示高亮效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击进入某一时刻');

  await dt.sleep();
  dt.log.i('预期结果4、轮播图片显示正常，不显示高亮效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧相册封面显示效果 end');
}

/**
 * 大图-HDR: [xxxHDR格式图片显示 Copy of (1)]
 * TAG: 29 TID: Multimedia_Gallery_HDRpicture_011
 * 前置条件
 * 1、xxx手机已具备HDR图片显示功能
 2、xxx手机已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_011(dt: Dt) {
  dt.log.i('xxxHDR格式图片显示 Copy of (1) start');
  dt.log.i('STEP 1、xxx拍摄一张HDR格式的图片');

  await dt.sleep();
  dt.log.i('预期结果1、图片显示高亮效果，提亮过程正常无跳变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、通过分享，克隆，云同步到xxx手机上');

  await dt.sleep();
  dt.log.i('STEP 3、xxx上进大图查看图片显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxxHDR格式图片显示 Copy of (1) end');
}

/**
 * 大图-格式: [xxxSDR格式图片显示]
 * TAG: 27 TID: Multimedia_Gallery_HDRpicture_012
 * 前置条件
 * 1、xxx手机已具备HDR图片显示功能
 2、xxx手机不具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_012(dt: Dt) {
  dt.log.i('xxxSDR格式图片显示 start');
  dt.log.i('STEP 1、xxx拍摄一张SDR格式的图片');

  await dt.sleep();
  dt.log.i('预期结果1、图片显示高亮效果，提亮过程正常无跳变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、通过分享，克隆，云同步到xxx手机上');

  await dt.sleep();
  dt.log.i('STEP 3、xxx上进大图查看图片显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxxSDR格式图片显示 end');
}

/**
 * 大图-HDR: [云上图片显示HDR高亮效果]
 * TAG: 21 TID: Multimedia_Gallery_HDRpicture_013
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_013(dt: Dt) {
  dt.log.i('云上图片显示HDR高亮效果 start');
  dt.log.i('STEP 1、xxx拍摄HDR格式的图片上行');

  await dt.sleep();
  dt.log.i('预期结果1、图片显示高亮效果，提亮过程正常无跳变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、xxx下行过来查看');

  await dt.sleep();
  dt.log.i('STEP 3、xxx拍摄SDR格式的图片上行');

  await dt.sleep();
  dt.log.i('STEP 4、xxx下行过来查看');

  await dt.sleep();
  dt.log.i('STEP 5、xxx拍摄HDR格式的图片上行');

  await dt.sleep();
  dt.log.i('STEP 6、xxx下行过来查看');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云上图片显示HDR高亮效果 end');
}

/**
 * 大图-进入大图: [SDR图片显示高亮效果]
 * TAG: 25 TID: Multimedia_Gallery_HDRpicture_014
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_014(dt: Dt) {
  dt.log.i('SDR图片显示高亮效果 start');
  dt.log.i('STEP 1、导入或从网上下载部分SDR图片');

  await dt.sleep();
  dt.log.i('预期结果1、图片走AIHDR路径显示高亮效果，提亮过程正常无跳变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在图库中进入大图查看效果');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('SDR图片显示高亮效果 end');
}

/**
 * 大图-HDR: [动态照片查看HDR显示效果]
 * TAG: 28 TID: Multimedia_Gallery_HDRpicture_015
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_015(dt: Dt) {
  dt.log.i('动态照片查看HDR显示效果 start');
  dt.log.i('STEP 1、从相机拍摄动态图片');

  await dt.sleep();
  dt.log.i('预期结果1、动态图片封面显示高亮效果，播放视频无高亮效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入大图查看动态图片封面显示效果');

  await dt.sleep();
  dt.log.i('STEP 3、点击图片播放动态视频');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片查看HDR显示效果 end');
}

/**
 * 大图-HDR: [HDR格式图片显示功耗测试 Copy of (1)]
 * TAG: 34 TID: Multimedia_Gallery_HDRpicture_016
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_016(dt: Dt) {
  dt.log.i('HDR格式图片显示功耗测试 Copy of (1) start');
  dt.log.i('STEP 1、xxx拍摄一张HDR格式图片');

  await dt.sleep();
  dt.log.i('预期结果1、功耗不高于xxxHDR图片大图浏览');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进大图查看图片显示');

  await dt.sleep();
  dt.log.i('STEP 3、查看过程中功耗');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HDR格式图片显示功耗测试 Copy of (1) end');
}

/**
 * 大图-连拍: [连拍照片查看HDR显示效果]
 * TAG: 33 TID: Multimedia_Gallery_HDRpicture_017
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_017(dt: Dt) {
  dt.log.i('连拍照片查看HDR显示效果 start');
  dt.log.i('STEP 1、在相机页面按住拍摄按钮向左滑动进行连拍');

  await dt.sleep();
  dt.log.i('预期结果1、图片显示高亮效果，提亮过程正常无跳变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在图库中查看连拍图片');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('连拍照片查看HDR显示效果 end');
}

/**
 * 大图-HDR: [HDR图片分享预览显示效果]
 * TAG: 22 TID: Multimedia_Gallery_HDRpicture_018
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_018(dt: Dt) {
  dt.log.i('HDR图片分享预览显示效果 start');
  dt.log.i('STEP 1、在图库中多选选中HDR和SDR图片');

  await dt.sleep();
  dt.log.i('预期结果1、分享预览页面图片正常显示，无变亮变暗情况');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击分享按钮，查看分享预览框');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HDR图片分享预览显示效果 end');
}

/**
 * 大图-HDR: [HDR开关关闭]
 * TAG: 23 TID: Multimedia_Gallery_HDRpicture_019
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_019(dt: Dt) {
  dt.log.i('HDR开关关闭 start');
  dt.log.i('STEP 1、在设置查看HDR显示开关（设置-显示和亮度-高级设置）');

  await dt.sleep();
  dt.log.i('预期结果1、开关默认是开启状态');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入图库查看图片显示效果');

  await dt.sleep();
  dt.log.i('预期结果2、图片显示高亮效果，提亮过程正常无跳变4、图片显示正常效果，没有高亮6、图片显示高亮效果，提亮过程正常无跳变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入设置页面关闭HDR开关');

  await dt.sleep();
  dt.log.i('STEP 4、进入图库中查看图片显示效果');

  await dt.sleep();
  dt.log.i('预期结果4、图片显示正常效果，没有高亮6、图片显示高亮效果，提亮过程正常无跳变');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、进入设置页面打开HDR开关');

  await dt.sleep();
  dt.log.i('STEP 6、进入图库中查看图片显示效果');

  await dt.sleep();
  dt.log.i('预期结果6、图片显示高亮效果，提亮过程正常无跳变');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HDR开关关闭 end');
}

/**
 * 大图-HDR: [悬浮窗状态查看HDR图片]
 * TAG: 31 TID: Multimedia_Gallery_HDRpicture_020
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_020(dt: Dt) {
  dt.log.i('悬浮窗状态查看HDR图片 start');
  dt.log.i('STEP 1、设置图库进入悬浮窗状态');

  await dt.sleep();
  dt.log.i('预期结果1、图片显示高亮效果，提亮过程正常无跳变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入图库查看图片显示效果');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('悬浮窗状态查看HDR图片 end');
}

/**
 * 大图-HDR: [分屏状态查看HDR图片]
 * TAG: 26 TID: Multimedia_Gallery_HDRpicture_021
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_021(dt: Dt) {
  dt.log.i('分屏状态查看HDR图片 start');
  dt.log.i('STEP 1、设置图库进入分屏状态');

  await dt.sleep();
  dt.log.i('预期结果1、图片显示高亮效果，提亮过程正常无跳变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入图库查看图片显示效果');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分屏状态查看HDR图片 end');
}

/**
 * 大图-HDR: [深色模式状态查看HDR图片]
 * TAG: 30 TID: Multimedia_Gallery_HDRpicture_022
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_022(dt: Dt) {
  dt.log.i('深色模式状态查看HDR图片 start');
  dt.log.i('STEP 1、打开系统深色模式');

  await dt.sleep();
  dt.log.i('预期结果1、图片显示高亮效果，提亮过程正常无跳变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入图库查看图片显示效果');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('深色模式状态查看HDR图片 end');
}

/**
 * 大图-HDR: [有线投屏下，对端的图片和视频的显示HDR效果测试]
 * TAG: 36 TID: Multimedia_Gallery_HDRpicture_299
 * 前置条件
 * 1、使用有线OTG线连接手机和电视
 */
async function Multimedia_Gallery_HDRpicture_299(dt: Dt) {
  dt.log.i('有线投屏下，对端的图片和视频的显示HDR效果测试 start');
  dt.log.i('STEP 1、连接手机和电视 ，打开图库');

  await dt.sleep();
  dt.log.i('STEP 2、宫格的显示效果在大屏上展示 ，点击宫格进大图');

  await dt.sleep();
  dt.log.i('预期结果2 3、若大屏本身支持HDR，则保留HDR高显效果；若大屏不支持HDR，则保留SDR显示效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、图片和视频的HDR效果在大屏展示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('有线投屏下，对端的图片和视频的显示HDR效果测试 end');
}

/**
 * 大图-HDR: [无线投屏下，对端的图片和视频的显示HDR效果测试]
 * TAG: 37 TID: Multimedia_Gallery_HDRpicture_399
 * 前置条件
 * 1、控制中心无线镜像投屏
 */
async function Multimedia_Gallery_HDRpicture_399(dt: Dt) {
  dt.log.i('无线投屏下，对端的图片和视频的显示HDR效果测试 start');
  dt.log.i('STEP 1、连接无线投屏 ，打开图库');

  await dt.sleep();
  dt.log.i('STEP 2、宫格的显示效果在大屏上展示 ，点击宫格进大图');

  await dt.sleep();
  dt.log.i('预期结果2 3、若大屏本身支持HDR，则保留HDR高显效果；若大屏不支持HDR，则保留SDR显示效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、图片和视频的HDR效果在大屏展示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无线投屏下，对端的图片和视频的显示HDR效果测试 end');
}

