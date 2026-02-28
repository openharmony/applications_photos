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

export default function Multimedia_Gallery_Motion_Picture_005(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('Multimedia_Gallery_Motion_Picture_005', (): void => {
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
    run('Multimedia_Gallery_Motion_picture_039', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片大图操作检查] TID: Multimedia_Gallery_Motion_picture_039
      await Multimedia_Gallery_Motion_picture_039(dt);
    });
    run('Multimedia_Gallery_Motion_picture_040', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片大屏投屏] TID: Multimedia_Gallery_Motion_picture_040
      await Multimedia_Gallery_Motion_picture_040(dt);
    });
    run('Multimedia_Gallery_Motion_picture_041', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片隔空分享] TID: Multimedia_Gallery_Motion_picture_041
      await Multimedia_Gallery_Motion_picture_041(dt);
    });
    run('Multimedia_Gallery_Motion_picture_042', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片碰一碰] TID: Multimedia_Gallery_Motion_picture_042
      await Multimedia_Gallery_Motion_picture_042(dt);
    });
    run('Multimedia_Gallery_Motion_picture_043', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片xxx场景验证] TID: Multimedia_Gallery_Motion_picture_043
      await Multimedia_Gallery_Motion_picture_043(dt);
    });
    run('Multimedia_Gallery_Motion_picture_044', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片云增强后效果切换] TID: Multimedia_Gallery_Motion_picture_044
      await Multimedia_Gallery_Motion_picture_044(dt);
    });
    run('Multimedia_Gallery_Motion_picture_045', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-heif用例: [heif格式动态照片效果切换] TID: Multimedia_Gallery_Motion_picture_045
      await Multimedia_Gallery_Motion_picture_045(dt);
    });
    run('Multimedia_Gallery_Motion_picture_046', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片多语言、无障碍和大字体检查] TID: Multimedia_Gallery_Motion_picture_046
      await Multimedia_Gallery_Motion_picture_046(dt);
    });
    run('Multimedia_Gallery_Motion_picture_047', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片各效果编辑后大图查看] TID: Multimedia_Gallery_Motion_picture_047
      await Multimedia_Gallery_Motion_picture_047(dt);
    });
    run('Multimedia_Gallery_Motion_picture_049', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片非动态效果扣图] TID: Multimedia_Gallery_Motion_picture_049
      await Multimedia_Gallery_Motion_picture_049(dt);
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
 * 大图-动态照片: [动态照片大图操作检查]
 * TAG: 278 TID: Multimedia_Gallery_Motion_picture_039
 * 前置条件
 * 1、相机拍摄动态照片（覆盖普通动态照片、带水印动态照片、云增强动态照片、编辑后的动态照片，各比例动态照片等；可多场景叠加）
 */
async function Multimedia_Gallery_Motion_picture_039(dt: Dt) {
  dt.log.i('动态照片大图操作检查 start');
  dt.log.i('STEP 1、动态照片大图上滑查看详情，下会退出详情，左右滑动查看动态照片，双击/双指捏合放大缩小照片');

  await dt.sleep();
  dt.log.i('预期结果1，2、不同操作流程与正常大图一致，大图显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、不同效果动态照片大图收藏、分享删除、更多（移动、隐藏、设置壁纸）');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片大图操作检查 end');
}

/**
 * 大图-动态照片: [动态照片大屏投屏]
 * TAG: 279 TID: Multimedia_Gallery_Motion_picture_040
 * 前置条件
 * 1、相机拍摄动态照片（覆盖普通动态照片、带水印动态照片、云增强动态照片、编辑后的动态照片，各比例动态照片等；可多场景叠加）
 */
async function Multimedia_Gallery_Motion_picture_040(dt: Dt) {
  dt.log.i('动态照片大屏投屏 start');
  dt.log.i('STEP 1、动态照片大屏投屏，投屏过程中进行动态照片效果长按播放并其他效果播放');

  await dt.sleep();
  dt.log.i('预期结果1、大屏跟随投屏设备播放，效果跟随切换');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片大屏投屏 end');
}

/**
 * 大图-动态照片: [动态照片隔空分享]
 * TAG: 290 TID: Multimedia_Gallery_Motion_picture_041
 * 前置条件
 * 1、相机拍摄动态照片（覆盖普通动态照片、带水印动态照片、云增强动态照片、编辑后的动态照片，各比例动态照片等；可多场景叠加），双设备开启隔空分享
 */
async function Multimedia_Gallery_Motion_picture_041(dt: Dt) {
  dt.log.i('动态照片隔空分享 start');
  dt.log.i('STEP 1、进入动态照片大图，进行动态照片隔空分享');

  await dt.sleep();
  dt.log.i('预期结果1、接收方接收动态照片，效果保留，封面显示一致，播放效果一致，图标一致，且可进行效果切换');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片隔空分享 end');
}

/**
 * 大图-动态照片: [动态照片碰一碰]
 * TAG: 288 TID: Multimedia_Gallery_Motion_picture_042
 * 前置条件
 * 1、相机拍摄动态照片（覆盖普通动态照片、带水印动态照片、云增强动态照片、编辑后的动态照片，各比例动态照片等；可多场景叠加）
 */
async function Multimedia_Gallery_Motion_picture_042(dt: Dt) {
  dt.log.i('动态照片碰一碰 start');
  dt.log.i('STEP 1、进入动态照片大图，双手机顶部碰一碰，将不同效果动态照片分享到接收方');

  await dt.sleep();
  dt.log.i('预期结果1、接收方接收动态照片，效果保留，封面显示一致，播放效果一致，图标一致，且可进行效果切换');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片碰一碰 end');
}

/**
 * 大图-动态照片: [动态照片xxx场景验证]
 * TAG: 275 TID: Multimedia_Gallery_Motion_picture_043
 * 前置条件
 * 1、准备一台可xxx的xxx设备，且图库存在动态照片（覆盖普通动态照片、带水印动态照片、云增强动态照片、编辑后的动态照片，各比例动态照片等；可多场景叠加）
 */
async function Multimedia_Gallery_Motion_picture_043(dt: Dt) {
  dt.log.i('动态照片xxx场景验证 start');
  dt.log.i('STEP 1、设备xxx');

  await dt.sleep();
  dt.log.i('预期结果1、保留动态照片已设置效果，且支持切换效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、xxx进行动态照片效果切换和播放');

  await dt.sleep();
  dt.log.i('预期结果2、切换效果后封面显示正常，播放效果正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片xxx场景验证 end');
}

/**
 * 大图-动态照片: [动态照片云增强后效果切换]
 * TAG: 271 TID: Multimedia_Gallery_Motion_picture_044
 * 前置条件
 * 1、相机开启动态照片拍摄，拍摄超级微距动态照片
 */
async function Multimedia_Gallery_Motion_picture_044(dt: Dt) {
  dt.log.i('动态照片云增强后效果切换 start');
  dt.log.i('STEP 1、动态照片大图进行云增强，云增强后的动态照片进行效果切换');

  await dt.sleep();
  dt.log.i('预期结果1、动态照片效果能够成功切换，且切换后各效果封面显示正常，播放效果正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片云增强后效果切换 end');
}

/**
 * 大图-heif: [heif格式动态照片效果切换]
 * TAG: 263 TID: Multimedia_Gallery_Motion_picture_045
 * 前置条件
 * 1、相机拍摄heif格式动态照片（覆盖普通动态照片、带水印动态照片、云增强动态照片、编辑后的动态照片，各比例动态照片等；可多场景叠加）
 */
async function Multimedia_Gallery_Motion_picture_045(dt: Dt) {
  dt.log.i('heif格式动态照片效果切换 start');
  dt.log.i('STEP 1、heif格式动态照片各效果切换，并进行播放');

  await dt.sleep();
  dt.log.i('预期结果1、heif格式动态照片效果播放无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、heif格式动态照片宫格操作、大图操作');

  await dt.sleep();
  dt.log.i('预期结果2、heif格式动态照片非效果切换操作与图片一致，编辑为视频编辑');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('heif格式动态照片效果切换 end');
}

/**
 * 大图-动态照片: [动态照片多语言、无障碍和大字体检查]
 * TAG: 277 TID: Multimedia_Gallery_Motion_picture_046
 * 前置条件
 * 1、相机拍摄动态照片（覆盖普通动态照片、带水印动态照片、云增强动态照片、编辑后的动态照片，各比例动态照片等；可多场景叠加）
 */
async function Multimedia_Gallery_Motion_picture_046(dt: Dt) {
  dt.log.i('动态照片多语言、无障碍和大字体检查 start');
  dt.log.i('STEP 1、设备切换多语言、检查多语言条件下动态照片各效果入口文字显示');

  await dt.sleep();
  dt.log.i('预期结果1，3、显示无异常，无截断');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、设置开启无障碍、检查无障碍条件下动态照片入口及各效果播报');

  await dt.sleep();
  dt.log.i('预期结果2、语音播报正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、设置更改切换大字体，检查大字体条件下动态照片各效果入口显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片多语言、无障碍和大字体检查 end');
}

/**
 * 大图-动态照片: [动态照片各效果编辑后大图查看]
 * TAG: 276 TID: Multimedia_Gallery_Motion_picture_047
 * 前置条件
 * 1、相机拍摄动态照片（覆盖普通动态照片、带水印动态照片、云增强动态照片、编辑后的动态照片，各比例动态照片等；可多场景叠加）
 */
async function Multimedia_Gallery_Motion_picture_047(dt: Dt) {
  dt.log.i('动态照片各效果编辑后大图查看 start');
  dt.log.i('STEP 1、进行不同效果动态照片编辑，编辑另存后查看大图显示并进行播放');

  await dt.sleep();
  dt.log.i('预期结果1、大图显示为编辑后的动态照片，封面显示正常且播放效果无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、编辑后大图动态照片进行效果切换，并进行播放');

  await dt.sleep();
  dt.log.i('预期结果2、大图显示为效果切换后的动态照片，封面显示正常且播放无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片各效果编辑后大图查看 end');
}

/**
 * 大图-动态照片: [动态照片非动态效果扣图]
 * TAG: 557 TID: Multimedia_Gallery_Motion_picture_049
 * 前置条件
 * 1、相机拍摄带主体动态照片（尽量保持主体一直在画面内）
 */
async function Multimedia_Gallery_Motion_picture_049(dt: Dt) {
  dt.log.i('动态照片非动态效果扣图 start');
  dt.log.i('STEP 1、设置动态照片效果为循环播放/来回播放/主角时刻/运动轨迹/微动瞬间效果');

  await dt.sleep();
  dt.log.i('STEP 2、长按主体抠图');

  await dt.sleep();
  dt.log.i('预期结果2、不支持抠图');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片非动态效果扣图 end');
}

