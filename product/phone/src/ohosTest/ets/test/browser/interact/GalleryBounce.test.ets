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
import { abilityDelegator, run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';

export default function GalleryBounceTest(): void {
  describe('GalleryBounceTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    // 确认当前图库app处于启动状态
    beforeAll(async (): Promise<void> => {
      // 进入图库
      await AppStart.photos()
    });
    it('beforeGalleryBounceTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      // 打开大图
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    it('Multimedia_Gallery_Bounce_001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [不同场景动态照片来回播放效果播放方式] TID: Multimedia_Gallery_Bounce_001
      await Multimedia_Gallery_Bounce_001(dt);
    });
    it('Multimedia_Gallery_Bounce_002', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [大图组件动态照片来回播放] TID: Multimedia_Gallery_Bounce_002
      await Multimedia_Gallery_Bounce_002(dt);
    });
    it('Multimedia_Gallery_Bounce_003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [列表相册中动态照片来回播放] TID: Multimedia_Gallery_Bounce_003
      await Multimedia_Gallery_Bounce_003(dt);
    });
    it('Multimedia_Gallery_Bounce_004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [动态照片来回播放大图详情] TID: Multimedia_Gallery_Bounce_004
      await Multimedia_Gallery_Bounce_004(dt);
    });
    it('Multimedia_Gallery_Bounce_005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [来回播放效果隔离] TID: Multimedia_Gallery_Bounce_005
      await Multimedia_Gallery_Bounce_005(dt);
    });
    it('Multimedia_Gallery_Bounce_006', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片不同效果切换至来回播放效果] TID: Multimedia_Gallery_Bounce_006
      await Multimedia_Gallery_Bounce_006(dt);
    });
    it('Multimedia_Gallery_Bounce_007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片来回播放上行下行] TID: Multimedia_Gallery_Bounce_007
      await Multimedia_Gallery_Bounce_007(dt);
    });
    it('Multimedia_Gallery_Bounce_008', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片来回播放效果克隆] TID: Multimedia_Gallery_Bounce_008
      await Multimedia_Gallery_Bounce_008(dt);
    });
    it('Multimedia_Gallery_Bounce_009', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片来回播放分享] TID: Multimedia_Gallery_Bounce_009
      await Multimedia_Gallery_Bounce_009(dt);
    });
    it('Multimedia_Gallery_Bounce_010', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片来回播放分享给三方] TID: Multimedia_Gallery_Bounce_010
      await Multimedia_Gallery_Bounce_010(dt);
    });
    it('Multimedia_Gallery_Bounce_011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片宫格预览后长按播放时拖拽] TID: Multimedia_Gallery_Bounce_011
      await Multimedia_Gallery_Bounce_011(dt);
    });


    // 退出大图 回到时间线页面
    afterAll(async (): Promise<void> => await Exit.browser());
    // 确保每次测试完毕回到大图页
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEach GalleryBounceTest').init();
      dt.log.i('afterEach GalleryBounceTest test');
      dt.log.i('afterEach GalleryBounceTest test finish');
    });
  });
}

// DT步骤
/**
 * 大图-动态照片: [不同场景动态照片来回播放效果播放方式]
 * TAG: 591 TID: Multimedia_Gallery_Bounce_001
 * 前置条件
 * 1、图库存在动态照片（本地拍摄的、xxx克隆的、云同步的动态照片）
 */
async function Multimedia_Gallery_Bounce_001(dt: Dt) {
  dt.log.i('不同场景动态照片来回播放效果播放方式 start');
  dt.log.i('STEP 1、动态照片效果切换为来回播放，旋转开关打开，横屏查看；');


  dt.log.i('预期结果1、动态照片效果切换至来回播放成功，横屏查看来回播放正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、不同入口（照片页、系统相册：例如图片相册、智慧相册：例如地点相册、用户创建的相册、picker：例如备忘录拉起picker和图库内部相册内添加图片拉起picker、宫格长按预览）进入该动态照片大图，查看播放效果；');


  dt.log.i('预期结果2、动态照片自动来回播放，播放效果流畅；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、不同入口（照片页、系统相册：例如图片相册、智慧相册：例如地点相册、用户创建的相册）大图滑动到该动态照片，查看播放效果；');


  dt.log.i('预期结果3、动态照片自动来回播放，播放效果流畅；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同场景动态照片来回播放效果播放方式 end');
}

/**
 * 大图-动态照片: [大图组件动态照片来回播放]
 * TAG: 587 TID: Multimedia_Gallery_Bounce_002
 * 前置条件
 * 1、图库存在动态照片（本地拍摄的、xxx克隆的、云同步的动态照片）
 */
async function Multimedia_Gallery_Bounce_002(dt: Dt) {
  dt.log.i('大图组件动态照片来回播放 start');
  dt.log.i('STEP 1、打开相机，点击相机左下角缩略图，拉起动态照片大图，点击大图下方的动态效果切换按钮，切换至来回播放，查看来回播放效果流畅；');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果1、切换至来回播放效果成功，来回播放效果流畅，无卡顿，画面无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从畅联应用中打开动态照片，点击大图下方的动态效果切换按钮，切换至来回播放，查看来回播放的效果；');


  dt.log.i('预期结果2、切换至来回播放效果成功，来回播放效果流畅，无卡顿，画面无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、多个动态照片切换至来回播放效果，从相机打开动态照片大图，持续快速的滑动浏览来回播放效果的动态照片大图；');


  dt.log.i('预期结果3、来回播放效果流畅，无卡顿，画面无异常，且大图浏览无卡顿；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图组件动态照片来回播放 end');
}

/**
 * 大图-动态照片: [列表相册中动态照片来回播放]
 * TAG: 581 TID: Multimedia_Gallery_Bounce_003
 * 前置条件
 * 1、图库存在动态照片（本地拍摄的、xxx克隆的、云同步的动态照片）
 */
async function Multimedia_Gallery_Bounce_003(dt: Dt) {
  dt.log.i('列表相册中动态照片来回播放 start');
  dt.log.i('STEP 1、打开图库进入相册页，从最近删除相册、隐藏相册、来源相册：例如相机相册 中进入动态照片大图，切换至来回播放效果，查看来回播放效果；');


  dt.log.i('预期结果1、动态照片自动来回播放，播放效果流畅；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、侧滑退出动态照片大图，再点击进动态照片大图，连续重复操作10次，查看动态照片来回播放效果；');


  dt.log.i('预期结果2、动态照片自动来回播放，播放效果流畅；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('列表相册中动态照片来回播放 end');
}

/**
 * 大图-详情: [动态照片来回播放大图详情]
 * TAG: 586 TID: Multimedia_Gallery_Bounce_004
 * 前置条件
 * 1、图库存在动态照片（本地拍摄的、xxx克隆的、云同步的动态照片）
 */
async function Multimedia_Gallery_Bounce_004(dt: Dt) {
  dt.log.i('动态照片来回播放大图详情 start');
  dt.log.i('STEP 1、不同入口（照片页、系统相册：例如图片相册、智慧相册：例如地点相册、用户创建的相册、最近删除相册、隐藏相册、来源相册：例如相机相册）进入动态照片，切换至来回播放效果；');


  dt.log.i('预期结果1、动态照片效果切换至来回播放成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、大图界面上滑，查看大图详情，添加/修改备注，修改名称，');

  await dt.sleep();
  dt.log.i('预期结果2、大图详情中图片大小、直方图展示正常、有地理位置的地图卡片展示正常，添加/修改备注成功，修改文件名成功；');
  await dt.sleep(DELAY.short);

  await dt.swipeScreen?.left();
  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片来回播放大图详情 end');
}

/**
 * 大图-动态照片: [来回播放效果隔离]
 * TAG: 583 TID: Multimedia_Gallery_Bounce_005
 * 前置条件
 * 1、图库存在动态照片（本地拍摄的、xxx克隆的、云同步的动态照片）
 */
async function Multimedia_Gallery_Bounce_005(dt: Dt) {
  dt.log.i('来回播放效果隔离 start');
  dt.log.i('STEP 1、nova M/M+设备，查看动态照片效果类型；');


  dt.log.i('预期结果1、nova M/M+设备，动态照片效果中有来回播放效果；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、非nova M/M+设备 ，查看动态照片效果类型；（增加配置项对来回播放效果隔离，仅支持nova M/M+产品打开，保证该产品首发。）');

  await dt.sleep();
  dt.log.i('预期结果2、非nova M/M+设备 ，动态照片效果中没有来回播放效果；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('来回播放效果隔离 end');
}

/**
 * 大图-动态照片: [动态照片不同效果切换至来回播放效果]
 * TAG: 590 TID: Multimedia_Gallery_Bounce_006
 * 前置条件
 * 1、图库存在动态照片（本地拍摄的、xxx克隆的、云同步的动态照片）
 */
async function Multimedia_Gallery_Bounce_006(dt: Dt) {
  dt.log.i('动态照片不同效果切换至来回播放效果 start');
  dt.log.i('STEP 1、动态照片效果由循环播放切换为来回播放；');


  dt.log.i('预期结果1-7、动态照片由不同效果切换至来回播放效果成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、动态照片效果由来回播放切换为来回播放；');


  dt.log.i('STEP 3、动态照片效果由长曝光切换为来回播放；');


  dt.log.i('STEP 4、动态照片效果由多曝光切换为来回播放；');


  dt.log.i('STEP 5、动态照片效果由微动瞬间切换为来回播放；');


  dt.log.i('STEP 6、动态照片效果由关闭切换为来回播放；');


  dt.log.i('STEP 7、动态照片效果由动态照片切换为来回播放；');

  await dt.sleep();
  await dt.swipeScreen?.left();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片不同效果切换至来回播放效果 end');
}

/**
 * 大图-动态照片: [动态照片来回播放上行下行]
 * TAG: 582 TID: Multimedia_Gallery_Bounce_007
 * 前置条件
 * 1、图库存在动态照片（本地拍摄的、克隆的）
 2、账号云空间存在动态照片
 3、动态照片均切换至来回播放效果
 */
async function Multimedia_Gallery_Bounce_007(dt: Dt) {
  dt.log.i('动态照片来回播放上行下行 start');
  dt.log.i('STEP 1、A机登录有空间的账号，照片页下拉，触发上下行，下行完毕后会上行，等待上行完毕（照片页显示更新时间），点击进大图查看动态照片播放效果；');


  dt.log.i('预期结果1、上行后的动态照片效果保持来回播放效果，动态照片来回播放效果流畅；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、B机登录同个账号，照片页下拉，触发下行，等待下行完毕后，点击进大图查看动态照片播放效果');

  await dt.sleep();
  dt.log.i('预期结果2、下行下来的动态照片效果是来回播放效果，动态照片来回播放效果流畅；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片来回播放上行下行 end');
}

/**
 * 大图-动态照片: [动态照片来回播放效果克隆]
 * TAG: 589 TID: Multimedia_Gallery_Bounce_008
 * 前置条件
 * 1、图库存在动态照片（本地拍摄的)
 2、动态照片均切换至来回播放效果
 */
async function Multimedia_Gallery_Bounce_008(dt: Dt) {
  dt.log.i('动态照片来回播放效果克隆 start');
  dt.log.i('STEP 1、非nova M/M+的xxx设备克隆至nova M/M+设备，查看克隆后的动态照片播放效果；');


  dt.log.i('预期结果1-5、克隆后的动态照片保持来回播放效果，播放效果流畅；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、非nova M/M+的xxx设备克隆至nova M/M+设备，查看克隆后的动态照片播放效果；');


  dt.log.i('STEP 3、nova M/M+设备克隆至nova M/M+设备，查看克隆后的动态照片播放效果；');


  dt.log.i('STEP 4、nova M/M+设备克隆至非nova M/M+的xxx设备，查看克隆后的动态照片播放效果；');


  dt.log.i('STEP 5、nova M/M+设备克隆至非nova M/M+的xxx设备，查看克隆后的动态照片播放效果；');

  await dt.sleep();
  await dt.swipeScreen?.left();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片来回播放效果克隆 end');
}

/**
 * 大图-动态照片: [动态照片来回播放分享]
 * TAG: 588 TID: Multimedia_Gallery_Bounce_009
 * 前置条件
 * 1、图库存在动态照片（本地拍摄的、xxx克隆的、云同步的动态照片）
 2、动态照片均切换至来回播放效果
 */
async function Multimedia_Gallery_Bounce_009(dt: Dt) {
  dt.log.i('动态照片来回播放分享 start');
  dt.log.i('STEP 1、非nova M/M+的xxx设备分享至nova M/M+设备，查看分享后的动态照片播放效果；');


  dt.log.i('预期结果1-5、分享后的动态照片保持来回播放效果，播放效果流畅；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、非nova M/M+的xxx设备分享至nova M/M+设备，查看分享后的动态照片播放效果；');


  dt.log.i('STEP 3、nova M/M+设备分享至nova M/M+设备，查看分享后的动态照片播放效果；');


  dt.log.i('STEP 4、nova M/M+设备分享至非nova M/M+的xxx设备，查看分享后的动态照片播放效果；');


  dt.log.i('STEP 5、nova M/M+设备分享至非nova M/M+的xxx设备，查看分享后的动态照片播放效果；（需覆盖分享按钮分享、隔空分享、碰一碰分享）');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片来回播放分享 end');
}

/**
 * 大图-动态照片: [动态照片来回播放分享给三方]
 * TAG: 584 TID: Multimedia_Gallery_Bounce_010
 * 前置条件
 * 1、图库存在动态照片（本地拍摄的、xxx克隆的、云同步的动态照片）
 2、动态照片均切换至来回播放效果
 */
async function Multimedia_Gallery_Bounce_010(dt: Dt) {
  dt.log.i('动态照片来回播放分享给三方 start');
  dt.log.i('STEP 1、进入动态照片大图，点击分享，分享至三方应用（例如畅联），分享完成后从三方点击进动态大图查看播放效果；');


  dt.log.i('预期结果1、分享至三方应用的动态照片保持来回播放效果；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、宫格多选动态照片，点击分享，分享至三方应用（例如畅联），分享完成后从三方点击进动态大图查看播放效果；');

  await dt.sleep();
  dt.log.i('预期结果2、分享至三方应用的动态照片保持来回播放效果；');
  await dt.sleep(DELAY.short);

  await dt.swipeScreen?.left();
  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片来回播放分享给三方 end');
}

/**
 * 大图-动态照片: [动态照片宫格预览后长按播放时拖拽]
 * TAG: 585 TID: Multimedia_Gallery_Bounce_011
 * 前置条件
 * 1、图库存在动态照片（本地拍摄的、xxx克隆的、云同步的动态照片）
 2、动态照片均切换至来回播放效果
 */
async function Multimedia_Gallery_Bounce_011(dt: Dt) {
  dt.log.i('动态照片宫格预览后长按播放时拖拽 start');
  dt.log.i('STEP 1、宫格长按预览该动态照片');


  dt.log.i('预期结果1、长按预览成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、预览后长按播放时拖拽');

  await dt.sleep();
  dt.log.i('预期结果2、不支持拖拽');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片宫格预览后长按播放时拖拽 end');
}

