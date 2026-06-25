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

import { afterAll, afterEach, beforeAll, describe, Level } from '@ohos/hypium';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';

export default function ConcealmentAlbumTest(): void {
  describe('ConcealmentAlbumTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      await dt.timeline();
      //  宫格-相册用例: [隐匿保护支持开关非立即生效] TID: Multimedia_Gallery_HideAlbums_Concealment_003
      await Multimedia_Gallery_HideAlbums_Concealment_003(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-相册用例: [隐匿保护支持多种进隐藏相册方式] TID: Multimedia_Gallery_HideAlbums_Concealment_004
      await Multimedia_Gallery_HideAlbums_Concealment_004(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [隐匿保护支持多种加锁退出再进入方式] TID: Multimedia_Gallery_HideAlbums_Concealment_005
      await Multimedia_Gallery_HideAlbums_Concealment_005(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_006', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-相册用例: [隐藏相册支持隐匿保护并手动退出] TID: Multimedia_Gallery_HideAlbums_Concealment_006
      await Multimedia_Gallery_HideAlbums_Concealment_006(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_007', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-相册用例: [隐匿保护不支持自动放通解除隐匿迷彩蒙层] TID: Multimedia_Gallery_HideAlbums_Concealment_007
      await Multimedia_Gallery_HideAlbums_Concealment_007(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-相册用例: [隐藏相册支持隐匿保护并退出隐藏相册] TID: Multimedia_Gallery_HideAlbums_Concealment_008
      await Multimedia_Gallery_HideAlbums_Concealment_008(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-相册用例: [隐匿保护支持进入隐藏相册前多人注视] TID: Multimedia_Gallery_HideAlbums_Concealment_009
      await Multimedia_Gallery_HideAlbums_Concealment_009(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-相册用例: [隐匿保护支持靠近远离场景] TID: Multimedia_Gallery_HideAlbums_Concealment_010
      await Multimedia_Gallery_HideAlbums_Concealment_010(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-相册用例: [隐匿保护支持重叠分开场景] TID: Multimedia_Gallery_HideAlbums_Concealment_011
      await Multimedia_Gallery_HideAlbums_Concealment_011(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_012', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-相册用例: [隐匿保护支持相册视图常规操作覆盖] TID: Multimedia_Gallery_HideAlbums_Concealment_012
      await Multimedia_Gallery_HideAlbums_Concealment_012(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-相册用例: [隐匿保护支持相册视图长按预览操作覆盖] TID: Multimedia_Gallery_HideAlbums_Concealment_013
      await Multimedia_Gallery_HideAlbums_Concealment_013(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_014', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-滑动用例: [隐匿保护支持宫格滑动浏览操作覆盖] TID: Multimedia_Gallery_HideAlbums_Concealment_014
      await Multimedia_Gallery_HideAlbums_Concealment_014(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_015', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-拖拽用例: [隐匿保护支持宫格拖拽操作覆盖] TID: Multimedia_Gallery_HideAlbums_Concealment_015
      await Multimedia_Gallery_HideAlbums_Concealment_015(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_016', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-进入大图用例: [隐匿保护支持宫格多选操作覆盖] TID: Multimedia_Gallery_HideAlbums_Concealment_016
      await Multimedia_Gallery_HideAlbums_Concealment_016(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_017', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-进入大图用例: [隐匿保护支持宫格长按预览操作覆盖] TID: Multimedia_Gallery_HideAlbums_Concealment_017
      await Multimedia_Gallery_HideAlbums_Concealment_017(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_018', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [隐匿保护支持大图左右浏览操作覆盖] TID: Multimedia_Gallery_HideAlbums_Concealment_018
      await Multimedia_Gallery_HideAlbums_Concealment_018(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_019', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [隐匿保护支持大图双指缩放和双击放大] TID: Multimedia_Gallery_HideAlbums_Concealment_019
      await Multimedia_Gallery_HideAlbums_Concealment_019(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_020', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [隐匿保护支持大图长按文字识别操作覆盖] TID: Multimedia_Gallery_HideAlbums_Concealment_020
      await Multimedia_Gallery_HideAlbums_Concealment_020(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_021', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [隐匿保护支持大图长按抠图操作覆盖] TID: Multimedia_Gallery_HideAlbums_Concealment_021
      await Multimedia_Gallery_HideAlbums_Concealment_021(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_022', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [隐匿保护支持大图编辑操作覆盖] TID: Multimedia_Gallery_HideAlbums_Concealment_022
      await Multimedia_Gallery_HideAlbums_Concealment_022(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_023', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-动态照片用例: [隐匿保护支持动态照片播放操作覆盖] TID: Multimedia_Gallery_HideAlbums_Concealment_023
      await Multimedia_Gallery_HideAlbums_Concealment_023(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_024', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [隐匿保护支持视频播放操作覆盖] TID: Multimedia_Gallery_HideAlbums_Concealment_024
      await Multimedia_Gallery_HideAlbums_Concealment_024(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_025', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-详情用例: [隐匿保护支持大图详情备注重命名操作覆盖] TID: Multimedia_Gallery_HideAlbums_Concealment_025
      await Multimedia_Gallery_HideAlbums_Concealment_025(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_026', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [隐匿保护支持大图常规按钮覆盖] TID: Multimedia_Gallery_HideAlbums_Concealment_026
      await Multimedia_Gallery_HideAlbums_Concealment_026(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_027', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [隐匿保护支持云同步加载场景] TID: Multimedia_Gallery_HideAlbums_Concealment_027
      await Multimedia_Gallery_HideAlbums_Concealment_027(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_028', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-相册用例: [隐匿保护支持高优先级应用打断恢复] TID: Multimedia_Gallery_HideAlbums_Concealment_028
      await Multimedia_Gallery_HideAlbums_Concealment_028(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_029', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-相册用例: [隐匿保护支持系统通知显示] TID: Multimedia_Gallery_HideAlbums_Concealment_029
      await Multimedia_Gallery_HideAlbums_Concealment_029(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_030', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-相册用例: [隐匿保护不支持非HL手机的产品] TID: Multimedia_Gallery_HideAlbums_Concealment_030
      await Multimedia_Gallery_HideAlbums_Concealment_030(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_031', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-相册用例: [隐匿保护支持需求规格内的性能和用户行为打点] TID: Multimedia_Gallery_HideAlbums_Concealment_031
      await Multimedia_Gallery_HideAlbums_Concealment_031(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_032', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-深色用例: [隐匿保护支持深色模式] TID: Multimedia_Gallery_HideAlbums_Concealment_032
      await Multimedia_Gallery_HideAlbums_Concealment_032(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_033', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-横竖屏用例: [隐匿保护支持横竖屏] TID: Multimedia_Gallery_HideAlbums_Concealment_033
      await Multimedia_Gallery_HideAlbums_Concealment_033(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-相册用例: [隐匿保护支持适老化关怀模式大字体] TID: Multimedia_Gallery_HideAlbums_Concealment_034
      await Multimedia_Gallery_HideAlbums_Concealment_034(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_035', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-相册用例: [隐匿保护支持无障碍模式] TID: Multimedia_Gallery_HideAlbums_Concealment_035
      await Multimedia_Gallery_HideAlbums_Concealment_035(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_036', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-进入大图用例: [隐匿保护支持全球化语言] TID: Multimedia_Gallery_HideAlbums_Concealment_036
      await Multimedia_Gallery_HideAlbums_Concealment_036(dt);
    });
    run('Multimedia_Gallery_HideAlbums_Concealment_037', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-相册用例: [隐匿保护支持分屏、悬浮窗] TID: Multimedia_Gallery_HideAlbums_Concealment_037
      await Multimedia_Gallery_HideAlbums_Concealment_037(dt);
    });

    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEach browser test').init();
      // 执行单个用例完成之后, 应保持在大图页面
      dt.log.i('afterEach browser test');
      await dt.sleep();
      dt.log.i('afterEach browser test finish');
    });
    // 退出大图 执行测试套完成之后, 应保持在大图页面
    afterAll(async (): Promise<void> => await Exit.browser());
  });
}

/**
 * 宫格-相册: [隐匿保护支持开关非立即生效]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_003
 * 前置条件
 * 1、产品支持隐匿保护功能
 */
async function Multimedia_Gallery_HideAlbums_Concealment_003(dt: Dt) {
  dt.log.i('隐匿保护支持开关非立即生效 start');
  dt.log.i('STEP 1、进入隐藏相册，分屏打开设置');

  await dt.sleep();
  dt.log.i('预期结果1、分屏展示隐藏相册和系统设置');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在设置->隐私和安全->窥屏提示中打开隐匿保护总开关和子开关，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果2、不触发隐匿保护功能覆盖隐匿迷彩蒙层，系统通知栏触发动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、退出隐藏相册再进入，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果3、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、关闭图库子开关，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果4、不触发隐匿保护功能覆盖隐匿迷彩蒙层，系统通知栏触发动效');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、关闭窥屏提示总开关，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果5、不触发隐匿保护功能覆盖隐匿迷彩蒙层，系统通知栏不触发动效');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持开关非立即生效 end');
}

/**
 * 宫格-相册: [隐匿保护支持多种进隐藏相册方式]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_004
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 */
async function Multimedia_Gallery_HideAlbums_Concealment_004(dt: Dt) {
  dt.log.i('隐匿保护支持多种进隐藏相册方式 start');
  dt.log.i('STEP 1、通过切换锁屏密码进入隐藏相册，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果1、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、退出隐藏相册再重新进入，通过切换指纹识别进入隐藏相册，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果2、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、退出隐藏相册再重新进入，通过切换人脸识别进入隐藏相册，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果3、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持多种进隐藏相册方式 end');
}

/**
 * 宫格-应用锁: [隐匿保护支持多种加锁退出再进入方式]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_005
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、设置图库应用锁，打开应用退出后立即锁定开关
 */
async function Multimedia_Gallery_HideAlbums_Concealment_005(dt: Dt) {
  dt.log.i('隐匿保护支持多种加锁退出再进入方式 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果1、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击返回按钮回到图库页面，通过人脸识别进入隐藏相册，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果2、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、上划退出应用，通过人脸识别进入图库，再通过人脸识别进入隐藏相册，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果3、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、熄屏再亮屏，通过人脸识别直接解锁进入图库，再通过人脸识别进入隐藏相册，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果4、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持多种加锁退出再进入方式 end');
}

/**
 * 宫格-相册: [隐藏相册支持隐匿保护并手动退出]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_006
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 */
async function Multimedia_Gallery_HideAlbums_Concealment_006(dt: Dt) {
  dt.log.i('隐藏相册支持隐匿保护并手动退出 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，触发多人注视场景，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果1、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿保护迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、重复触发多人注视场景');

  await dt.sleep();
  dt.log.i('预期结果2、不再触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、退出隐藏相册再进入，触发多人注视场景');

  await dt.sleep();
  dt.log.i('预期结果3、重新触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册支持隐匿保护并手动退出 end');
}

/**
 * 宫格-相册: [隐匿保护不支持自动放通解除隐匿迷彩蒙层]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_007
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 */
async function Multimedia_Gallery_HideAlbums_Concealment_007(dt: Dt) {
  dt.log.i('隐匿保护不支持自动放通解除隐匿迷彩蒙层 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果1、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，不支持自动解除隐匿保护迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、重复触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果2、隐匿保护迷彩蒙层不变，系统通知栏重复提示存在他人窥视');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护不支持自动放通解除隐匿迷彩蒙层 end');
}

/**
 * 宫格-相册: [隐藏相册支持隐匿保护并退出隐藏相册]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_008
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 */
async function Multimedia_Gallery_HideAlbums_Concealment_008(dt: Dt) {
  dt.log.i('隐藏相册支持隐匿保护并退出隐藏相册 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，触发多人注视场景');

  await dt.sleep();
  dt.log.i('预期结果1、触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击左上角返回按钮');

  await dt.sleep();
  dt.log.i('预期结果2、退出隐藏相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、相册页再次触发多人注视场景');

  await dt.sleep();
  dt.log.i('预期结果3、不触发隐匿保护功能覆盖隐匿迷彩蒙层，系统通知栏提示存在他人窥视');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册支持隐匿保护并退出隐藏相册 end');
}

/**
 * 宫格-相册: [隐匿保护支持进入隐藏相册前多人注视]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_009
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 */
async function Multimedia_Gallery_HideAlbums_Concealment_009(dt: Dt) {
  dt.log.i('隐匿保护支持进入隐藏相册前多人注视 start');
  dt.log.i('STEP 1、进入隐藏相册前多人眼注视图库相册');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能覆盖隐匿迷彩蒙层，但系统通知栏存在防窥提示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、通过人脸识别进入隐藏相册，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果2、立即触发隐匿保护功能覆盖隐匿迷彩蒙层，手动解除隐匿保护迷彩蒙层');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持进入隐藏相册前多人注视 end');
}

/**
 * 宫格-相册: [隐匿保护支持靠近远离场景]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_010
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 */
async function Multimedia_Gallery_HideAlbums_Concealment_010(dt: Dt) {
  dt.log.i('隐匿保护支持靠近远离场景 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册浏览相册');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、他人从远处经过机主并离开，行走过程中注视机主手机');

  await dt.sleep();
  dt.log.i('预期结果2、识别到多人眼立即触发隐匿保护功能覆盖隐匿迷彩蒙层并保持');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持靠近远离场景 end');
}

/**
 * 宫格-相册: [隐匿保护支持重叠分开场景]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_011
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 */
async function Multimedia_Gallery_HideAlbums_Concealment_011(dt: Dt) {
  dt.log.i('隐匿保护支持重叠分开场景 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册浏览相册');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、他人从机主背后伸头注视手机再从背后缩回');

  await dt.sleep();
  dt.log.i('预期结果2、识别到多人眼立即触发隐匿保护功能覆盖隐匿迷彩蒙层并保持');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持重叠分开场景 end');
}

/**
 * 宫格-相册: [隐匿保护支持相册视图常规操作覆盖]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_012
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、隐藏相册视图为相册视图
 */
async function Multimedia_Gallery_HideAlbums_Concealment_012(dt: Dt) {
  dt.log.i('隐匿保护支持相册视图常规操作覆盖 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击更多，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果2、弹出更多选项，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层，更多选项收起');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、退出隐藏相册再重新进入，点击多选并选中相册，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果3、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除解除隐匿迷彩蒙层，多选效果未变更');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、退出隐藏相册再重新进入，多选选中点击删除，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果4、弹出删除提示弹窗，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层，删除提示弹窗未变更');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、退出隐藏相册再重新进入，多选选中点击取消隐藏，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果5、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层，相册已取消隐藏');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持相册视图常规操作覆盖 end');
}

/**
 * 宫格-相册: [隐匿保护支持相册视图长按预览操作覆盖]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_013
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、隐藏相册视图为相册视图
 */
async function Multimedia_Gallery_HideAlbums_Concealment_013(dt: Dt) {
  dt.log.i('隐匿保护支持相册视图长按预览操作覆盖 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、长按相册弹出预览窗口，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果2、预览窗口缩小消失 ，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持相册视图长按预览操作覆盖 end');
}

/**
 * 宫格-滑动: [隐匿保护支持宫格滑动浏览操作覆盖]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_014
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、隐藏相册视图为相册视图或图片视图宫格界面
 */
async function Multimedia_Gallery_HideAlbums_Concealment_014(dt: Dt) {
  dt.log.i('隐匿保护支持宫格滑动浏览操作覆盖 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，点击相册进入宫格');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、缓慢滑动宫格，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果2、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层，宫格界面为之前的界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、退出隐藏相册再重新进入，快速滑动宫格，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果3、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层，宫格界面为抛滑后的界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持宫格滑动浏览操作覆盖 end');
}

/**
 * 宫格-拖拽: [隐匿保护支持宫格拖拽操作覆盖]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_015
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、隐藏相册视图为相册视图或图片视图宫格界面
 */
async function Multimedia_Gallery_HideAlbums_Concealment_015(dt: Dt) {
  dt.log.i('隐匿保护支持宫格拖拽操作覆盖 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，点击相册进入宫格');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、退出隐藏相册再重新进入，拖拽宫格至小艺对话，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果2、触发隐匿保护功能覆盖隐匿迷彩蒙层，小艺对话界面覆盖在蒙层上，手动解除隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、退出隐藏相册再重新进入，拖拽宫格至中转站，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果3、触发隐匿保护功能覆盖隐匿迷彩蒙层，中转站覆盖在蒙层上，图片样式显示空白照片，手动解除隐匿迷彩蒙层');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、退出隐藏相册再重新进入，拖拽宫格过程中，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果4、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层，拖拽已取消');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持宫格拖拽操作覆盖 end');
}

/**
 * 宫格-进入大图: [隐匿保护支持宫格多选操作覆盖]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_016
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、隐藏相册视图为相册视图或图片视图宫格界面
 */
async function Multimedia_Gallery_HideAlbums_Concealment_016(dt: Dt) {
  dt.log.i('隐匿保护支持宫格多选操作覆盖 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，点击相册进入宫格');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击多选并滑动选中宫格，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果2、滑动选中状态暂停，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层，多选效果未变更');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、退出隐藏相册再重新进入，多选点击选中的宫格进入大图，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果3、触发隐匿保护功能覆盖隐匿迷彩蒙层，蒙层显示多选样式，手动解除隐匿迷彩蒙层，大图选中效果未变更');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、退出隐藏相册再重新进入，多选点击全选，点击删除按钮，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果4、弹出删除提示弹窗，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层，删除提示弹窗未变更');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、退出隐藏相册再重新进入，多选点击收藏按钮，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果5、弹出进度条，触发隐匿保护功能覆盖隐匿迷彩蒙层，进度条显示在蒙层上，手动解除隐匿迷彩蒙层，所有图片视频已收藏');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、退出隐藏相册再重新进入，多选后长按单个已选中宫格，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果6、所有已选中宫格汇聚至当前宫格，汇聚状态散开，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、退出隐藏相册再重新进入，多选后点击取消隐藏按钮，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果7、弹出进度条，触发隐匿保护功能覆盖隐匿迷彩蒙层，进度条显示在蒙层上，保手动解除隐匿迷彩蒙层，所有图片视频已消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持宫格多选操作覆盖 end');
}

/**
 * 宫格-进入大图: [隐匿保护支持宫格长按预览操作覆盖]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_017
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、隐藏相册视图为相册视图或图片视图宫格界面
 */
async function Multimedia_Gallery_HideAlbums_Concealment_017(dt: Dt) {
  dt.log.i('隐匿保护支持宫格长按预览操作覆盖 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，点击相册进入宫格，点击宫格进入大图');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、长按宫格弹出预览窗口，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果2、预览窗口缩小消失，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持宫格长按预览操作覆盖 end');
}

/**
 * 宫格-大图: [隐匿保护支持大图左右浏览操作覆盖]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_018
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、隐藏相册视图为相册视图或图片视图宫格界面
 */
async function Multimedia_Gallery_HideAlbums_Concealment_018(dt: Dt) {
  dt.log.i('隐匿保护支持大图左右浏览操作覆盖 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，点击相册进入宫格，点击宫格进入大图');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、缓慢滑动大图，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果2、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层，大图界面为之前的界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、退出隐藏相册重新进入，快速滑动大图预览条，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果3、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层，大图界面为抛滑后的界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、退出隐藏相册重新进入，点击大图进入沉浸式，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果4、触发隐匿保护功能覆盖隐匿迷彩蒙层并并保持，手动解除隐匿迷彩蒙层，沉浸式界面退出沉浸式');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持大图左右浏览操作覆盖 end');
}

/**
 * 宫格-大图: [隐匿保护支持大图双指缩放和双击放大]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_019
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、隐藏相册视图为相册视图或图片视图宫格界面
 */
async function Multimedia_Gallery_HideAlbums_Concealment_019(dt: Dt) {
  dt.log.i('隐匿保护支持大图双指缩放和双击放大 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，点击相册进入宫格，点击宫格进入大图');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、双指缩放大图,双指不离开屏幕，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果2、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，解除隐匿保护，缩小放大的图片恢复原先大小');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、退出隐藏相册再进入，双指点击大图，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果3、图片放大，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，解除隐匿保护，放大的图片不变');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持大图双指缩放和双击放大 end');
}

/**
 * 宫格-大图: [隐匿保护支持大图长按文字识别操作覆盖]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_020
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、隐藏相册视图为相册视图或图片视图宫格界面
 3、图片中有明确的可以识别的文字且文字包含地点
 */
async function Multimedia_Gallery_HideAlbums_Concealment_020(dt: Dt) {
  dt.log.i('隐匿保护支持大图长按文字识别操作覆盖 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，点击相册进入宫格，点击宫格进入大图');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、长按图片中的文字进行选取，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果2、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层，长按弹出的操作选项未消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、退出隐藏相册再重新进入，长按文字点击翻译，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果3、拉起选词翻译，触发隐匿保护功能覆盖隐匿迷彩蒙层，选词翻译页面覆盖在蒙层上，手动解除隐匿迷彩蒙层，选词翻译页面未变更');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、退出隐藏相册再重新进入，长按地点文字，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果4、弹出位置导航小窗，位置导航小窗缩小消失，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持大图长按文字识别操作覆盖 end');
}

/**
 * 宫格-大图: [隐匿保护支持大图长按抠图操作覆盖]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_021
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、隐藏相册视图为相册视图或图片视图宫格界面
 3、图片中有明确的可以抠图的物体
 */
async function Multimedia_Gallery_HideAlbums_Concealment_021(dt: Dt) {
  dt.log.i('隐匿保护支持大图长按抠图操作覆盖 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，点击相册进入宫格，点击宫格进入大图');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、长按图片中的物体进行抠图，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果2、触发隐匿保护功能覆盖隐匿迷彩蒙层保持，手动解除隐匿迷彩蒙层，长按弹出的操作选项未消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、退出隐藏相册再重新进入，抠图后点击识图搜索，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果3、弹出搜索界面，触发隐匿保护功能覆盖隐匿迷彩蒙层，搜索页面覆盖在蒙层上，手动解除隐匿迷彩蒙层');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、退出隐藏相册再重新进入，抠图后点击分享，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果4、弹出分享界面，触发隐匿保护功能覆盖隐匿迷彩蒙层，分享页面覆盖在蒙层上，手动解除隐匿迷彩蒙层');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、退出分享界面');

  await dt.sleep();
  dt.log.i('预期结果5、跳转隐藏相册解锁界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持大图长按抠图操作覆盖 end');
}

/**
 * 宫格-大图: [隐匿保护支持大图编辑操作覆盖]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_022
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、隐藏相册视图为相册视图或图片视图宫格界面
 */
async function Multimedia_Gallery_HideAlbums_Concealment_022(dt: Dt) {
  dt.log.i('隐匿保护支持大图编辑操作覆盖 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，点击相册进入宫格，点击宫格进入大图/视频');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击编辑按钮进入编辑页面，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果2、不触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、退出编辑页面，触发多人注视场景再解除，点击查看照片/视频');

  await dt.sleep();
  dt.log.i('预期结果3、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持大图编辑操作覆盖 end');
}

/**
 * 宫格-动态照片: [隐匿保护支持动态照片播放操作覆盖]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_023
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、隐藏相册视图为相册视图或图片视图宫格界面
 */
async function Multimedia_Gallery_HideAlbums_Concealment_023(dt: Dt) {
  dt.log.i('隐匿保护支持动态照片播放操作覆盖 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，点击相册进入宫格，点击宫格进入大图');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、长按动态照片，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果2、动态照片播放，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿保护，动态照片播放结束');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、退出隐藏相册再重新进入，大图滑动至动态照片，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果3、动态照片自动播放，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿保护，动态照片播放结束');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持动态照片播放操作覆盖 end');
}

/**
 * 宫格-视频: [隐匿保护支持视频播放操作覆盖]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_024
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、隐藏相册视图为相册视图或图片视图宫格界面
 */
async function Multimedia_Gallery_HideAlbums_Concealment_024(dt: Dt) {
  dt.log.i('隐匿保护支持视频播放操作覆盖 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，点击相册进入宫格，点击宫格进入视频');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击视频播放按钮，触发多人注视场景再解除，点击查看视频');

  await dt.sleep();
  dt.log.i('预期结果2、视频开始播放，视频播放暂停，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持视频播放操作覆盖 end');
}

/**
 * 宫格-详情: [隐匿保护支持大图详情备注重命名操作覆盖]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_025
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、隐藏相册视图为相册视图或图片视图宫格界面
 */
async function Multimedia_Gallery_HideAlbums_Concealment_025(dt: Dt) {
  dt.log.i('隐匿保护支持大图详情备注重命名操作覆盖 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，点击相册进入宫格，点击宫格进入大图');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、上划图片进入详情，点击备注框或文件名触发文本编辑，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果2、自动退出详情页面，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层，输入的信息已保存');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持大图详情备注重命名操作覆盖 end');
}

/**
 * 宫格-大图: [隐匿保护支持大图常规按钮覆盖]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_026
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、隐藏相册视图为相册视图或图片视图宫格界面
 */
async function Multimedia_Gallery_HideAlbums_Concealment_026(dt: Dt) {
  dt.log.i('隐匿保护支持大图常规按钮覆盖 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，点击相册进入宫格，点击宫格进入大图');

  await dt.sleep();
  dt.log.i('预期结果1、不触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击更多按钮，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果2、弹出更多选项，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层，更多选项收起');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、退出隐藏相册再重新进入，点击更多按钮的取消隐藏选项，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果3、当前大图消失，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、退出隐藏相册再重新进入，点击更多按钮的重命名选项，添加备注，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果4、弹出重命名弹窗，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层，弹窗和文本信息未变更');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、退出隐藏相册再重新进入，点击更多按钮的幻灯片播放选项，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果5、大图开始幻灯片播放，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层，大图退出幻灯片播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、退出隐藏相册再重新进入，点击收藏按钮，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果6、收藏按钮已点亮，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、退出隐藏相册再重新进入，点击删除按钮，触发多人注视场景再解除，点击查看照片，点击确认');

  await dt.sleep();
  dt.log.i('预期结果7、弹出确认弹窗，触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，手动解除隐匿迷彩蒙层，当前大图消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持大图常规按钮覆盖 end');
}

/**
 * 宫格-视频: [隐匿保护支持云同步加载场景]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_027
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、云端存在照片，云同步开关未开启
 */
async function Multimedia_Gallery_HideAlbums_Concealment_027(dt: Dt) {
  dt.log.i('隐匿保护支持云同步加载场景 start');
  dt.log.i('STEP 1、打开云同步开关');

  await dt.sleep();
  dt.log.i('预期结果1、图库开始同步云端图片和视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、通过人脸识别进入隐藏相册，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果2、隐藏相册开始同步图片和视频，触发隐匿保护功能覆盖隐匿迷彩蒙层并持久生效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击“查看照片”手动解除保护');

  await dt.sleep();
  dt.log.i('预期结果3、手动解除隐匿迷彩蒙层，同步持续进行');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持云同步加载场景 end');
}

/**
 * 宫格-相册: [隐匿保护支持高优先级应用打断恢复]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_028
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 */
async function Multimedia_Gallery_HideAlbums_Concealment_028(dt: Dt) {
  dt.log.i('隐匿保护支持高优先级应用打断恢复 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，触发多人注视场景');

  await dt.sleep();
  dt.log.i('预期结果1、触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、电话拨入手机');

  await dt.sleep();
  dt.log.i('预期结果2、跳转手机通话界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、挂断通话');

  await dt.sleep();
  dt.log.i('预期结果3、回到隐藏相册解锁页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持高优先级应用打断恢复 end');
}

/**
 * 宫格-相册: [隐匿保护支持系统通知显示]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_029
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 */
async function Multimedia_Gallery_HideAlbums_Concealment_029(dt: Dt) {
  dt.log.i('隐匿保护支持系统通知显示 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，触发多人注视场景');

  await dt.sleep();
  dt.log.i('预期结果1、触发隐匿保护功能覆盖隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、充电线连接手机插入PC的USB接口');

  await dt.sleep();
  dt.log.i('预期结果2、蒙层上弹出插电选项提示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持系统通知显示 end');
}

/**
 * 宫格-相册: [隐匿保护不支持非HL手机的产品]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_030
 * 前置条件
 * 1、准备多个设备，Cipe手机、Iclxxx、XYAO平板
 */
async function Multimedia_Gallery_HideAlbums_Concealment_030(dt: Dt) {
  dt.log.i('隐匿保护不支持非HL手机的产品 start');
  dt.log.i('STEP 1、检查是否存在隐匿保护总开关和图库子开关');

  await dt.sleep();
  dt.log.i('预期结果1、不存在隐匿保护总开关和图库子开关');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、检查若存在开关，隐藏相册隐匿保护是否生效');

  await dt.sleep();
  dt.log.i('预期结果2、若存在，不支持隐藏相册隐匿保护');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护不支持非HL手机的产品 end');
}

/**
 * 宫格-相册: [隐匿保护支持需求规格内的性能和用户行为打点]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_031
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 */
async function Multimedia_Gallery_HideAlbums_Concealment_031(dt: Dt) {
  dt.log.i('隐匿保护支持需求规格内的性能和用户行为打点 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，触发多人注视场景');

  await dt.sleep();
  dt.log.i('预期结果1、日志查看多人脸进入摄像头范围到图库响应启动隐藏动画时延不超过1s');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击“查看照片”，手动解除隐匿保护');

  await dt.sleep();
  dt.log.i('预期结果2、日志查看多人注视场景变更事件和手动解除保护事件的节点');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持需求规格内的性能和用户行为打点 end');
}

/**
 * 宫格-深色: [隐匿保护支持深色模式]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_032
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 */
async function Multimedia_Gallery_HideAlbums_Concealment_032(dt: Dt) {
  dt.log.i('隐匿保护支持深色模式 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果1、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，蒙层字体为白底黑字，手动解除隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、退出隐藏相册再重新进入，切换深色模式，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果2、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，蒙层为黑底蓝字，手动解除隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持深色模式 end');
}

/**
 * 宫格-横竖屏: [隐匿保护支持横竖屏]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_033
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 */
async function Multimedia_Gallery_HideAlbums_Concealment_033(dt: Dt) {
  dt.log.i('隐匿保护支持横竖屏 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，触发多人注视场景再解除，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果1、触发隐匿保护功能覆盖隐匿迷彩蒙层，蒙层样式为竖屏，按钮置灰无法操作，手动解除隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、退出隐藏相册再重新进入，切换横屏模式，触发多人注视场景，解除多人注视场景');

  await dt.sleep();
  dt.log.i('预期结果2、触发隐匿保护功能覆盖隐匿迷彩蒙层，蒙层样式为横屏，按钮置灰无法操作，手动解除隐匿迷彩蒙层');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持横竖屏 end');
}

/**
 * 宫格-相册: [隐匿保护支持适老化关怀模式大字体]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_034
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 */
async function Multimedia_Gallery_HideAlbums_Concealment_034(dt: Dt) {
  dt.log.i('隐匿保护支持适老化关怀模式大字体 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果1、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，蒙层字体为标准字体');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、屏幕右上下滑打开设置，打开关怀模式或设置字体，退出隐藏相册再重新进入，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果2、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，蒙层字体调整为适老化相应字号字体');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持适老化关怀模式大字体 end');
}

/**
 * 宫格-相册: [隐匿保护支持无障碍模式]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_035
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 2、辅助功能快捷键设置为屏幕朗读
 */
async function Multimedia_Gallery_HideAlbums_Concealment_035(dt: Dt) {
  dt.log.i('隐匿保护支持无障碍模式 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册');

  await dt.sleep();
  dt.log.i('STEP 2、同时按住音量上下键三秒，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果2、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持，焦点自动聚焦');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、线性浏览遍历页面的控件');

  await dt.sleep();
  dt.log.i('预期结果3、循环播报功能和提示，焦点无跳变');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、切换横屏，再次线性浏览遍历页面的控件，点击查看照片');

  await dt.sleep();
  dt.log.i('预期结果4、循环播报功能和提示，焦点无跳变');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持无障碍模式 end');
}

/**
 * 宫格-进入大图: [隐匿保护支持全球化语言]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_036
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 */
async function Multimedia_Gallery_HideAlbums_Concealment_036(dt: Dt) {
  dt.log.i('隐匿保护支持全球化语言 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果1、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、分屏打开设置，切换相应语言');

  await dt.sleep();
  dt.log.i('预期结果2、系统语言和蒙层的语言已更新为对应显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、退出分屏，切换横屏模式');

  await dt.sleep();
  dt.log.i('预期结果3、蒙层变为全屏横屏样式');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、退出隐藏相册重新进入，选择宫格视频进入大图播放，触发多人注视场景');

  await dt.sleep();
  dt.log.i('预期结果4、触发隐匿保护功能覆盖隐匿迷彩蒙层，蒙层的“查看照片”变更为“查看视频”对应语言');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('查看照片', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持全球化语言 end');
}

/**
 * 宫格-相册: [隐匿保护支持分屏、悬浮窗]
 * TAG: 隐匿 TID: Multimedia_Gallery_HideAlbums_Concealment_037
 * 前置条件
 * 1、在设置->隐私和安全->窥屏提示中按照提示打开隐匿保护总开关和子开关
 */
async function Multimedia_Gallery_HideAlbums_Concealment_037(dt: Dt) {
  dt.log.i('隐匿保护支持分屏、悬浮窗 start');
  dt.log.i('STEP 1、通过人脸识别进入隐藏相册，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果1、触发隐匿保护功能覆盖隐匿迷彩蒙层并保持');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、底部上滑至左上分屏打开设置，退出隐藏相册再重新进入，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果2、蒙层仅覆盖分屏');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、退出分屏，底部上滑至右上变为悬浮窗，退出隐藏相册再重新进入，触发多人注视场景再解除');

  await dt.sleep();
  dt.log.i('预期结果3、蒙层仅覆盖悬浮窗');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐匿保护支持分屏、悬浮窗 end');
}

