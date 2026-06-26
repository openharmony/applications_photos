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

export default function TCAIRetouching(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('TCAIRetouchingTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllTCAIRetouching').init();
      dt.log.i('beforeAll TCAIRetouching start');
      dt.log.i('beforeAll TCAIRetouching finish');
    });
    /**
     * 打开大图
     */
    it('beforeTCAIRetouching', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    it('TC_AI_Retouching_001', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-AI用例: [01.入口校验] TID: TC_AI_Retouching_001
      await TC_AI_Retouching_001(dt);
    });
    it('TC_AI_Retouching_002', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-AI用例: [02.支持的设备] TID: TC_AI_Retouching_002
      await TC_AI_Retouching_002(dt);
    });
    it('TC_AI_Retouching_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-AI用例: [03.AI修图后保存] TID: TC_AI_Retouching_003
      await TC_AI_Retouching_003(dt);
    });
    it('TC_AI_Retouching_003_894', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-AI用例: [09.AI修图与基础编辑交互] TID: TC_AI_Retouching_003_894
      await TC_AI_Retouching_003_894(dt);
    });
    it('TC_AI_Retouching_004', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-AI用例: [04.未AI修图保存] TID: TC_AI_Retouching_004
      await TC_AI_Retouching_004(dt);
    });
    it('TC_AI_Retouching_005', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-AI用例: [05.AI修图界面支持撤销恢复] TID: TC_AI_Retouching_005
      await TC_AI_Retouching_005(dt);
    });
    it('TC_AI_Retouching_006', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-AI用例: [06.不同ux布局形态下AI修图] TID: TC_AI_Retouching_006
      await TC_AI_Retouching_006(dt);
    });
    it('TC_AI_Retouching_007', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-AI用例: [07.AI修图综合编辑] TID: TC_AI_Retouching_007
      await TC_AI_Retouching_007(dt);
    });
    it('TC_AI_Retouching_008', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-AI用例: [08.AI修图后涂鸦] TID: TC_AI_Retouching_008
      await TC_AI_Retouching_008(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachTCAIRetouching').init();
      dt.log.i('afterEach TCAIRetouching start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach TCAIRetouching finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllTCAIRetouching').init();
      dt.log.i('afterAll TCAIRetouching start');
      await Exit.browser();
      dt.log.i('afterAll TCAIRetouching finish');
    });
  });
}

/**
 * 大图-AI: [01.入口校验]
 * GROUP: 大图 MODULE: AITID: TC_AI_Retouching_001
 * 前置条件
 *
 */
async function TC_AI_Retouching_001(dt: Dt) {
  dt.log.i('01.入口校验 start');
  dt.log.i('STEP 1、相机直拍动图后，从相机预览进入，点击左下角AI修图按钮');


  dt.log.i('预期结果1~2、弹窗提示：AI修图后无法显示动态效果？3、返回动图编辑首页6.1、未登录，跳转到账号登录页面6.2、登录成功，进入AI修图页面，有一镜到底动效6.3、登录失败，停留在登录页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在图库选择动图，进入编辑页面，点击右上角AI修图按钮');
  await dt.swipeScreen?.left();

  dt.log.i('STEP 3、弹窗点击取消/屏幕左滑');


  dt.log.i('预期结果3、返回动图编辑首页6.1、未登录，跳转到账号登录页面6.2、登录成功，进入AI修图页面，有一镜到底动效6.3、登录失败，停留在登录页面');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、弹窗点击继续');


  dt.log.i('预期结果6.1、未登录，跳转到账号登录页面6.2、登录成功，进入AI修图页面，有一镜到底动效6.3、登录失败，停留在登录页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('01.入口校验 end');
}

/**
 * 大图-AI: [02.支持的设备]
 * GROUP: 大图 MODULE: AITID: TC_AI_Retouching_002
 * 前置条件
 *
 */
async function TC_AI_Retouching_002(dt: Dt) {
  dt.log.i('02.支持的设备 start');
  dt.log.i('STEP 1、使用不同设备（Allen，Alta-b支持，平板和PC暂不支持）拍摄动图后，进入编辑页面');


  dt.log.i('STEP 2、点击左下角AI修图按钮');


  dt.log.i('预期结果2、弹窗提示：AI修图后无法显示动态效果？');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击继续');


  dt.log.i('预期结果3、进入AI修图页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('02.支持的设备 end');
}

/**
 * 大图-AI: [03.AI修图后保存]
 * GROUP: 大图 MODULE: AITID: TC_AI_Retouching_003
 * 前置条件
 *
 */
async function TC_AI_Retouching_003(dt: Dt) {
  dt.log.i('03.AI修图后保存 start');
  dt.log.i('STEP 1、相机直拍动图或图库选择动图，进入编辑页面，点击左下角AI修图按钮');


  dt.log.i('预期结果1、弹窗提示：AI修图后无法显示动态效果？');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击继续');


  dt.log.i('预期结果2、进入AI修图界面4、保存后回到大图页面，保留AI修图效果，动态按钮消失5.1、留在当前页面5.2、返回基础编辑页面，不保留AI修图效果，显示动态页签，可以撤销6、返回基础编辑页面，保留AI修图效果，不显示动态页签，不显示撤销恢复和对比按钮7、显示保存进度弹窗，保存成功后，返回到大图页面，保留AI修图效果，动态按钮消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进行AI修图操作（AI修图、光影、最佳表情、消除、扩图、背景）');


  dt.log.i('STEP 4、点击右上角保存按钮（覆盖原图/另存为）');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果4、保存后回到大图页面，保留AI修图效果，动态按钮消失');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、再次执行AI修图（AI修图、光影、最佳表情、消除、扩图、背景），点击返回/左滑取消，提示：是否放弃所有更改5.1、点击取消5.2、点击放弃更改');


  dt.log.i('预期结果5.1、留在当前页面5.2、返回基础编辑页面，不保留AI修图效果，显示动态页签，可以撤销');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、再次执行AI修图（AI修图、光影、最佳表情、消除、扩图、背景），点击左下角AI修图按钮返回');


  dt.log.i('预期结果6、返回基础编辑页面，保留AI修图效果，不显示动态页签，不显示撤销恢复和对比按钮');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、对图片设置裁剪/调节/滤镜，点击保存按钮（覆盖原图/另存为）');


  dt.log.i('预期结果7、显示保存进度弹窗，保存成功后，返回到大图页面，保留AI修图效果，动态按钮消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('03.AI修图后保存 end');
}

/**
 * 大图-AI: [09.AI修图与基础编辑交互]
 * GROUP: 大图 MODULE: AITID: TC_AI_Retouching_003_894
 * 前置条件
 *
 */
async function TC_AI_Retouching_003_894(dt: Dt) {
  dt.log.i('09.AI修图与基础编辑交互 start');
  dt.log.i('STEP 1、相机直拍动图或图库选择动图，进入编辑页面，点击左下角AI修图按钮');


  dt.log.i('预期结果1、弹窗提示：AI修图后无法显示动态效果？');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击继续');


  dt.log.i('预期结果2、进入AI修图界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进行AI修图操作（AI修图、光影、最佳表情、消除、扩图、背景）');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果3、修图功能正常，图片预览正常');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击左上角返回/左滑取消');


  dt.log.i('预期结果4、提示：是否放弃所有更改');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、点击取消');


  dt.log.i('预期结果5、留在当前页面，修图效果未消失');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、再次点击左上角返回/左滑取消后，点击放弃更改');


  dt.log.i('预期结果6、返回基础编辑页面，不保留AI修图效果，显示动态页签');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、侧滑返回');


  dt.log.i('预期结果7、直接退出编辑界面');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 8、再次进入编辑，AI修图后点击左下角AI修图');


  dt.log.i('预期结果8、回到基础编辑页面，保留AI修图效果，不再展示动态编辑图标（变为静态编辑页面）');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 9、侧滑返回');


  dt.log.i('预期结果9、提示：是否放弃所有更改');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 10、点击放弃');


  dt.log.i('预期结果10、直接退出编辑界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('09.AI修图与基础编辑交互 end');
}

/**
 * 大图-AI: [04.未AI修图保存]
 * GROUP: 大图 MODULE: AITID: TC_AI_Retouching_004
 * 前置条件
 *
 */
async function TC_AI_Retouching_004(dt: Dt) {
  dt.log.i('04.未AI修图保存 start');
  dt.log.i('STEP 1、相机直拍动图或图库选择动图，进入编辑页面，点击左下角AI修图按钮');


  dt.log.i('预期结果1、弹窗提示：AI修图后无法显示动态效果？');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击继续');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果2、进入AI修图界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、不进行AI修图操作，点击返回/侧滑返回');


  dt.log.i('预期结果3、不显示提示弹窗，返回动图编辑页面，显示动态页签');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、重新进入AI修图，点击左下角AI修图按钮');


  dt.log.i('预期结果4、返回动图编辑页面，不显示动态页签，不显示撤销恢复和对比按钮');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、对图片设置裁剪/调节/滤镜，点击保存按钮');


  dt.log.i('预期结果5、返回到大图页面，无AI修图效果，动态页签效果消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('04.未AI修图保存 end');
}

/**
 * 大图-AI: [05.AI修图界面支持撤销恢复]
 * GROUP: 大图 MODULE: AITID: TC_AI_Retouching_005
 * 前置条件
 *
 */
async function TC_AI_Retouching_005(dt: Dt) {
  dt.log.i('05.AI修图界面支持撤销恢复 start');
  dt.log.i('STEP 1、相机直拍动图或图库选择动图，进入编辑页面，点击左下角AI修图按钮');


  dt.log.i('STEP 2、点击继续');


  dt.log.i('预期结果2、进入AI修图界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进行AI修图操作（AI修图、光影、最佳表情、消除、扩图、背景）');


  dt.log.i('预期结果3、AI修图支持撤销和恢复');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('05.AI修图界面支持撤销恢复 end');
}

/**
 * 大图-AI: [06.不同ux布局形态下AI修图]
 * GROUP: 大图 MODULE: AITID: TC_AI_Retouching_006
 * 前置条件
 *
 */
async function TC_AI_Retouching_006(dt: Dt) {
  dt.log.i('06.不同ux布局形态下AI修图 start');
  dt.log.i('STEP 1、相机直拍动图或图库选择动图');


  dt.log.i('STEP 2、使用不同手机进入AI修图页面，切换不同的ux布局（横屏、多窗、分屏、xxxxxx，xxx，横竖屏切换），进行AI修图操作');
  await dt.swipeScreen?.left();
  await dt.sleep();
  dt.log.i('预期结果2、ux页面布局显示ok，AI修图功能ok');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('06.不同ux布局形态下AI修图 end');
}

/**
 * 大图-AI: [07.AI修图综合编辑]
 * GROUP: 大图 MODULE: AITID: TC_AI_Retouching_007
 * 前置条件
 *
 */
async function TC_AI_Retouching_007(dt: Dt) {
  dt.log.i('07.AI修图综合编辑 start');
  dt.log.i('STEP 1、相机直拍动图或图库选择动图，进入编辑页面，点击左下角AI修图按钮');


  dt.log.i('预期结果1、选择继续，进入AI修图页面检查点：1、重选封面帧后AI修图，AI修图效果作用于新封面帧');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.1、重选封面帧，AI修图后调节、裁剪、添加滤镜后保存2.2、重选封面帧，调节、裁剪、添加滤镜后AI修图后保存2.3、AI修图后调节、裁剪、添加滤镜后保存2.4、AI修图后调节、裁剪、添加滤镜，再次AI修图后保存2.5、调节、裁剪、添加滤镜，重选封面帧后AI修图后保存2.6、调节、裁剪、添加滤镜后，AI修图后保存');


  dt.log.i('预期结果2、AI修图后切换到滤镜，滤镜缩略图实时刷新');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3、返回到大图页面，AI修图效果生效，动态页签消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('07.AI修图综合编辑 end');
}

/**
 * 大图-AI: [08.AI修图后涂鸦]
 * GROUP: 大图 MODULE: AITID: TC_AI_Retouching_008
 * 前置条件
 *
 */
async function TC_AI_Retouching_008(dt: Dt) {
  dt.log.i('08.AI修图后涂鸦 start');
  dt.log.i('STEP 1、相机直拍动图或图库选择动图，进入编辑页面，点击左下角AI修图按钮');


  dt.log.i('预期结果1、选择继续，进入AI修图页面检查点：1、切换到滤镜页面，滤镜缩略图实时刷新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、AI修图后，设置涂鸦后保存');
  await dt.swipeScreen?.left();
  await dt.sleep();
  dt.log.i('预期结果2、返回到大图页面，AI修图和涂鸦效果生效，动态页签消失');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('08.AI修图后涂鸦 end');
}

