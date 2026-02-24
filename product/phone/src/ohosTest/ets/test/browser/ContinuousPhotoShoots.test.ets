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

export default function DemoUi(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('DemoUiTest', (): void => {
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

    run('Multimedia_Gallery_Continuousphotoshoots_004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [最近删除相册浏览连拍照片] TID: Multimedia_Gallery_Continuousphotoshoots_004
      await Multimedia_Gallery_Continuousphotoshoots_004(dt);
    });
    run('Multimedia_Gallery_Continuousphotoshoots_005', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [连拍照片长按预览] TID: Multimedia_Gallery_Continuousphotoshoots_005
      await Multimedia_Gallery_Continuousphotoshoots_005(dt);
    });
    run('Multimedia_Gallery_Continuousphotoshoots_006', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [图库分屏、悬浮窗下浏览连拍照片] TID: Multimedia_Gallery_Continuousphotoshoots_006
      await Multimedia_Gallery_Continuousphotoshoots_006(dt);
    });
    run('Multimedia_Gallery_Continuousphotoshoots_007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [连拍照片的分享] TID: Multimedia_Gallery_Continuousphotoshoots_007
      await Multimedia_Gallery_Continuousphotoshoots_007(dt);
    });
    run('Multimedia_Gallery_Continuousphotoshoots_012', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [连拍照片抠图] TID: Multimedia_Gallery_Continuousphotoshoots_012
      await Multimedia_Gallery_Continuousphotoshoots_012(dt);
    });
    run('Multimedia_Gallery_Continuousphotoshoots_013', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [连拍照片AI文字识别] TID: Multimedia_Gallery_Continuousphotoshoots_013
      await Multimedia_Gallery_Continuousphotoshoots_013(dt);
    });
    run('Multimedia_Gallery_Continuousphotoshoots_014', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [连拍照片一键美肤] TID: Multimedia_Gallery_Continuousphotoshoots_014
      await Multimedia_Gallery_Continuousphotoshoots_014(dt);
    });
    run('Multimedia_Gallery_Continuousphotoshoots_015', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [连拍照片拼图对比] TID: Multimedia_Gallery_Continuousphotoshoots_015
      await Multimedia_Gallery_Continuousphotoshoots_015(dt);
    });
    run('Multimedia_Gallery_Continuousphotoshoots_016', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [连拍照片克隆] TID: Multimedia_Gallery_Continuousphotoshoots_016
      await Multimedia_Gallery_Continuousphotoshoots_016(dt);
    });
    run('Multimedia_Gallery_Continuousphotoshoots_018', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [连拍照片端云上下行] TID: Multimedia_Gallery_Continuousphotoshoots_018
      await Multimedia_Gallery_Continuousphotoshoots_018(dt);
    });
    run('Multimedia_Gallery_Continuousphotoshoots_019', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [连拍照片选择后侧滑退出] TID: Multimedia_Gallery_Continuousphotoshoots_019
      await Multimedia_Gallery_Continuousphotoshoots_019(dt);
    });
    run('Multimedia_Gallery_Continuousphotoshoots_020', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [进入退出连拍照片的动效] TID: Multimedia_Gallery_Continuousphotoshoots_020
      await Multimedia_Gallery_Continuousphotoshoots_020(dt);
    });
    run('Multimedia_Gallery_Continuousphotoshoots_021', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [连拍照片子界面浏览动效] TID: Multimedia_Gallery_Continuousphotoshoots_021
      await Multimedia_Gallery_Continuousphotoshoots_021(dt);
    });
    run('Multimedia_Gallery_Continuousphotoshoots_022', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [连拍照片选择保存动效] TID: Multimedia_Gallery_Continuousphotoshoots_022
      await Multimedia_Gallery_Continuousphotoshoots_022(dt);
    });
    run('Multimedia_Gallery_Continuousphotoshoots_023', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [连拍照片子界面大图缩放动效] TID: Multimedia_Gallery_Continuousphotoshoots_023
      await Multimedia_Gallery_Continuousphotoshoots_023(dt);
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
 * 大图-连拍: [最近删除相册浏览连拍照片]
 * TAG: 236 TID: Multimedia_Gallery_Continuousphotoshoots_004
 * 前置条件
 * 1、图库存在连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_004(dt: Dt) {
  dt.log.i('最近删除相册浏览连拍照片 start');
  dt.log.i('STEP 1.打开图库进入相册页，点击进入最近删除相册；');

  await dt.sleep();
  dt.log.i('预期结果1.正常进入相册；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.查看连拍照片的宫格；');

  await dt.sleep();
  dt.log.i('预期结果2.连拍照片宫格不展示连拍标识；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击连拍照片进入大图，查看大图；');

  await dt.sleep();
  dt.log.i('预期结果3.连拍照片大图不展示连拍标识;');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.连拍照片宫格多选连拍照片，点击恢复、永久删除；');

  await dt.sleep();
  dt.log.i('预期结果4.宫格:恢复成功，永久删除成功；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.连拍照片大图，点击恢复、永久删除；');

  await dt.sleep();
  dt.log.i('预期结果5.大图:恢复成功，永久删除成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6.手机横屏，重复步骤1、2、3、4、5');

  await dt.sleep();
  dt.log.i('预期结果6.手机横屏，展示正常。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除相册浏览连拍照片 end');
}

/**
 * 大图-连拍: [连拍照片长按预览]
 * TAG: 231 TID: Multimedia_Gallery_Continuousphotoshoots_005
 * 前置条件
 * 1、图库存在连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_005(dt: Dt) {
  dt.log.i('连拍照片长按预览 start');
  dt.log.i('STEP 1.打开图库进入照片页/系统相册/来源相册/用户创建相册/智慧相册；');

  await dt.sleep();
  dt.log.i('预期结果1.正常进入照片页/相册；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.长按预览连拍照片的宫格；');

  await dt.sleep();
  dt.log.i('预期结果2.长按预览连拍照片正常，展示连拍照片的封面；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.手机横屏，重复步骤1、2；');

  await dt.sleep();
  dt.log.i('预期结果3.手机横屏，展示正常。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('连拍照片长按预览 end');
}

/**
 * 大图-连拍: [图库分屏、悬浮窗下浏览连拍照片]
 * TAG: 237 TID: Multimedia_Gallery_Continuousphotoshoots_006
 * 前置条件
 * 1、图库存在连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_006(dt: Dt) {
  dt.log.i('图库分屏、悬浮窗下浏览连拍照片 start');
  dt.log.i('STEP 1.图库进入分屏、悬浮窗模式，打开图库进入照片页/系统相册/来源相册/用户创建相册/智慧相册；');

  await dt.sleep();
  dt.log.i('预期结果1.正常进入照片页/相册；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.查看连拍照片的宫格；');

  await dt.sleep();
  dt.log.i('预期结果2.连拍照片宫格不展示连拍标识；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击连拍照片进入大图，查看大图；');

  await dt.sleep();
  dt.log.i('预期结果3.连拍照片大图下方中间展示连拍标识;');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.手机横屏，重复步骤1、2；');

  await dt.sleep();
  dt.log.i('预期结果4.手机横屏，展示正常。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库分屏、悬浮窗下浏览连拍照片 end');
}

/**
 * 大图-连拍: [连拍照片的分享]
 * TAG: 233 TID: Multimedia_Gallery_Continuousphotoshoots_007
 * 前置条件
 * 1、图库存在连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_007(dt: Dt) {
  dt.log.i('连拍照片的分享 start');
  dt.log.i('STEP 1.宫格多选连拍照片；');

  await dt.sleep();
  dt.log.i('预期结果1.多选成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.1xxx分享给xxx；2.2xxx分享给xxx；2.3xxx分享给xxx；');

  await dt.sleep();
  dt.log.i('预期结果2.1连拍照片封面分享成功2.2连拍照片封面分享成功2.3连拍照片封面分享成功');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('连拍照片的分享 end');
}

/**
 * 大图-连拍: [连拍照片抠图]
 * TAG: 221 TID: Multimedia_Gallery_Continuousphotoshoots_012
 * 前置条件
 * 1、图库存在可以进行抠图的连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_012(dt: Dt) {
  dt.log.i('连拍照片抠图 start');
  dt.log.i('STEP 1.长按连拍照片封面物体进行抠图；');

  await dt.sleep();
  dt.log.i('预期结果1.抠图成功，可以放入中转站；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.手机横屏，重复步骤1;');

  await dt.sleep();
  dt.log.i('预期结果2.手机横屏，操作成功；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('连拍照片抠图 end');
}

/**
 * 大图-连拍: [连拍照片AI文字识别]
 * TAG: 229 TID: Multimedia_Gallery_Continuousphotoshoots_013
 * 前置条件
 * 1、图库存在可以文字识别的连拍照片
 2.连接wifi
 */
async function Multimedia_Gallery_Continuousphotoshoots_013(dt: Dt) {
  dt.log.i('连拍照片AI文字识别 start');
  dt.log.i('STEP 1.点击进入连拍照片大图封面，查看右下角AI控件；');

  await dt.sleep();
  dt.log.i('预期结果1.AI控件正常展示；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击AI控件按钮，截取文本选择；');

  await dt.sleep();
  dt.log.i('预期结果2.成功选取文本；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.手机横屏，重复步骤1、2;');

  await dt.sleep();
  dt.log.i('预期结果3.手机横屏，操作成功；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('连拍照片AI文字识别 end');
}

/**
 * 大图-连拍: [连拍照片一键美肤]
 * TAG: 238 TID: Multimedia_Gallery_Continuousphotoshoots_014
 * 前置条件
 * 1、图库存在人像的连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_014(dt: Dt) {
  dt.log.i('连拍照片一键美肤 start');
  dt.log.i('STEP 1.点击进入连拍照片大图封面，长按人像弹出一键美肤；');

  await dt.sleep();
  dt.log.i('预期结果1.一键美肤正常弹出；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击一键美肤、取消一键美肤；');

  await dt.sleep();
  dt.log.i('预期结果2.一键美肤成功，取消一键美肤成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.手机横屏，重复步骤1、2;');

  await dt.sleep();
  dt.log.i('预期结果3.手机横屏，操作成功；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('连拍照片一键美肤 end');
}

/**
 * 大图-连拍: [连拍照片拼图对比]
 * TAG: 240 TID: Multimedia_Gallery_Continuousphotoshoots_015
 * 前置条件
 * 1、图库存在连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_015(dt: Dt) {
  dt.log.i('连拍照片拼图对比 start');
  dt.log.i('STEP 1.宫格多选2-9张连拍照片，点击拼图，点击保存；');

  await dt.sleep();
  dt.log.i('预期结果1.拼图保存成功，界面清晰；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.宫格多选2-20张连拍照片，点击对比，对比界面点击删除；');

  await dt.sleep();
  dt.log.i('预期结果2.对比成功，对比界面删除成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.拼图对比不支持手机横屏，支持xxx、平板；');

  await dt.sleep();
  dt.log.i('预期结果3.横屏下，操作成功；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('连拍照片拼图对比 end');
}

/**
 * 大图-连拍: [连拍照片克隆]
 * TAG: 232 TID: Multimedia_Gallery_Continuousphotoshoots_016
 * 前置条件
 * 1、图库存在连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_016(dt: Dt) {
  dt.log.i('连拍照片克隆 start');
  dt.log.i('STEP 1.连拍照片单克隆单；');

  await dt.sleep();
  dt.log.i('预期结果1.克隆成功，连拍照片整组展示；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.连拍照片双克隆单；');

  await dt.sleep();
  dt.log.i('预期结果2.克隆成功，连拍照片整组展示；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.连拍照片xxx；');

  await dt.sleep();
  dt.log.i('预期结果3.克隆成功，连拍照片整组展示；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.存量数据的连拍照片查看；');

  await dt.sleep();
  dt.log.i('预期结果4.连拍照片整组展示；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('连拍照片克隆 end');
}

/**
 * 大图-连拍: [连拍照片端云上下行]
 * TAG: 223 TID: Multimedia_Gallery_Continuousphotoshoots_018
 * 前置条件
 * 1、图库存在连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_018(dt: Dt) {
  dt.log.i('连拍照片端云上下行 start');
  dt.log.i('STEP 1.xxx连拍照片上行，xxx登录端云查看；');

  await dt.sleep();
  dt.log.i('预期结果1.上行成功，xxx、xxx查看连拍照片整组展示，数量正确；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.xxx连拍照片上行，xxx登录端云查看并下载；');

  await dt.sleep();
  dt.log.i('预期结果2.xxx查看连拍照片正常韩式，数量正确，下载成功，数量正确；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('连拍照片端云上下行 end');
}

/**
 * 大图-连拍: [连拍照片选择后侧滑退出]
 * TAG: 219 TID: Multimedia_Gallery_Continuousphotoshoots_019
 * 前置条件
 * 1、图库存在连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_019(dt: Dt) {
  dt.log.i('连拍照片选择后侧滑退出 start');
  dt.log.i('STEP 1.进入连拍照片选择界面，默认选择第一张，不操作其他选择，侧滑退出；');

  await dt.sleep();
  dt.log.i('预期结果1.侧滑退出成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.进入连拍照片选择界面，取消选择的第一张图片，侧滑退出；');

  await dt.sleep();
  dt.log.i('预期结果2.侧滑退出成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.进入连拍照片选择界面，选择部分图片，侧滑退出；');

  await dt.sleep();
  dt.log.i('预期结果3.侧滑退出成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.进入连拍照片选择界面，选择全部图片，侧滑退出；');

  await dt.sleep();
  dt.log.i('预期结果4.侧滑退出成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('连拍照片选择后侧滑退出 end');
}

/**
 * 大图-连拍: [进入退出连拍照片的动效]
 * TAG: 225 TID: Multimedia_Gallery_Continuousphotoshoots_020
 * 前置条件
 * 1、图库存在连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_020(dt: Dt) {
  dt.log.i('进入退出连拍照片的动效 start');
  dt.log.i('STEP 1.点击连拍照片大图封面下方的连拍标识按钮，进入连拍照片子界面，查看动效；');

  await dt.sleep();
  dt.log.i('预期结果1.动效展示正确，流畅不卡顿；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.不选择、选择图片后侧滑退出、点击返回按钮退出连拍照片子界面，查看动效；');

  await dt.sleep();
  dt.log.i('预期结果2.动效展示正确，流畅不卡顿；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('进入退出连拍照片的动效 end');
}

/**
 * 大图-连拍: [连拍照片子界面浏览动效]
 * TAG: 218 TID: Multimedia_Gallery_Continuousphotoshoots_021
 * 前置条件
 * 1、图库存在连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_021(dt: Dt) {
  dt.log.i('连拍照片子界面浏览动效 start');
  dt.log.i('STEP 1.连拍照片子界面，滑动浏览大图，查看动效；');

  await dt.sleep();
  dt.log.i('预期结果1.动效展示正确，流畅不卡顿；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.连拍照片子界面，滑动浏览大图下方的缩略图，查看动效；');

  await dt.sleep();
  dt.log.i('预期结果2.动效展示正确，流畅不卡顿；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('连拍照片子界面浏览动效 end');
}

/**
 * 大图-连拍: [连拍照片选择保存动效]
 * TAG: 227 TID: Multimedia_Gallery_Continuousphotoshoots_022
 * 前置条件
 * 1、图库存在连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_022(dt: Dt) {
  dt.log.i('连拍照片选择保存动效 start');
  dt.log.i('STEP 1.连拍照片子界面，选择图片保存、删除后，跳转至大图界面，查看动效；');

  await dt.sleep();
  dt.log.i('预期结果1.动效展示正确，流畅不卡顿；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('连拍照片选择保存动效 end');
}

/**
 * 大图-连拍: [连拍照片子界面大图缩放动效]
 * TAG: 222 TID: Multimedia_Gallery_Continuousphotoshoots_023
 * 前置条件
 * 1、图库存在连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_023(dt: Dt) {
  dt.log.i('连拍照片子界面大图缩放动效 start');
  dt.log.i('STEP 1.连拍照片子界面，大图可以缩小至查看整张大图，查看缩小动效；');

  await dt.sleep();
  dt.log.i('预期结果1.动效展示正确，流畅不卡顿；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.大图放大查看，放至最大后松手有回弹效果；');

  await dt.sleep();
  dt.log.i('预期结果2.动效展示正确，流畅不卡顿；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('连拍照片子界面大图缩放动效 end');
}

