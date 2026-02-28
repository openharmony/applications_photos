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
    run('Multimedia_Gallery_SR20250104962101_001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [图库加应用锁相机界面] TID: Multimedia_Gallery_SR20250104962101_001
      await Multimedia_Gallery_SR20250104962101_001(dt);
    });
    run('Multimedia_Gallery_SR20250104962101_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [图库加应用锁相机拍照的照片预览] TID: Multimedia_Gallery_SR20250104962101_002
      await Multimedia_Gallery_SR20250104962101_002(dt);
    });
    run('Multimedia_Gallery_SR20250104962101_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [图库加应用锁相机拍照的照片支持编辑] TID: Multimedia_Gallery_SR20250104962101_003
      await Multimedia_Gallery_SR20250104962101_003(dt);
    });
    run('Multimedia_Gallery_SR20250104962101_004', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [图库加应用锁相机拍照的照片支持分享] TID: Multimedia_Gallery_SR20250104962101_004
      await Multimedia_Gallery_SR20250104962101_004(dt);
    });
    run('Multimedia_Gallery_SR20250104962101_005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [图库加应用锁相机拍照的照片支持删除] TID: Multimedia_Gallery_SR20250104962101_005
      await Multimedia_Gallery_SR20250104962101_005(dt);
    });
    run('Multimedia_Gallery_SR20250104962101_006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [图库加应用锁相机拍照的照片支持收藏] TID: Multimedia_Gallery_SR20250104962101_006
      await Multimedia_Gallery_SR20250104962101_006(dt);
    });
    run('Multimedia_Gallery_SR20250104962101_007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [图库加应用锁相机拍照的照片支持隐藏] TID: Multimedia_Gallery_SR20250104962101_007
      await Multimedia_Gallery_SR20250104962101_007(dt);
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
 * 大图-应用锁: [图库加应用锁相机界面]
 * TAG: 680 TID: Multimedia_Gallery_SR20250104962101_001
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20250104962101_001(dt: Dt) {
  dt.log.i('图库加应用锁相机界面 start');
  dt.log.i('STEP 1、图库添加应用锁');

  await dt.sleep();
  dt.log.i('STEP 2、打开相机界面');

  await dt.sleep();
  dt.log.i('预期结果2、相机左下角缩略图不显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击左下角缩略图的位置');

  await dt.sleep();
  dt.log.i('预期结果3、跳转到解锁界面，提示“图库已上锁，图片或视频无法访问”，界面显示正常，无截断等');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('图库已上锁，图片或视频无法访问', true);
  dt.log.i('STEP 4、点击“解锁并访问”蓝色字体');

  await dt.sleep();
  dt.log.i('预期结果4、跳转到输入密码界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、输入密码');

  await dt.sleep();
  dt.log.i('预期结果5、跳转到图库界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库加应用锁相机界面 end');
}

/**
 * 大图-应用锁: [图库加应用锁相机拍照的照片预览]
 * TAG: 676 TID: Multimedia_Gallery_SR20250104962101_002
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20250104962101_002(dt: Dt) {
  dt.log.i('图库加应用锁相机拍照的照片预览 start');
  dt.log.i('STEP 1、图库添加应用锁');

  await dt.sleep();
  dt.log.i('STEP 2、打开相机界面，拍摄几张照片');

  await dt.sleep();
  dt.log.i('预期结果2、拍摄照片之后，相机左下角缩略图显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点开缩略图大图浏览');

  await dt.sleep();
  dt.log.i('预期结果3、跳转到大图浏览界面，动效显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、左右滑动照片');

  await dt.sleep();
  dt.log.i('预期结果4、只能浏览刚刚拍摄的照片，左右滑动照片浏览正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库加应用锁相机拍照的照片预览 end');
}

/**
 * 大图-应用锁: [图库加应用锁相机拍照的照片支持编辑]
 * TAG: 675 TID: Multimedia_Gallery_SR20250104962101_003
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20250104962101_003(dt: Dt) {
  dt.log.i('图库加应用锁相机拍照的照片支持编辑 start');
  dt.log.i('STEP 1、图库添加应用锁');

  await dt.sleep();
  dt.log.i('STEP 2、打开相机界面，拍摄几张照片');

  await dt.sleep();
  dt.log.i('预期结果2、拍摄照片之后，相机左下角缩略图显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点开缩略图大图浏览');

  await dt.sleep();
  dt.log.i('预期结果3、跳转到大图浏览界面5、显示编辑之后的照片6、新增一张另存的照片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击编辑按钮，任意编辑内容');

  await dt.sleep();
  dt.log.i('STEP 5、覆盖保存照片');

  await dt.sleep();
  dt.log.i('预期结果5、显示编辑之后的照片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、重复操作4，另存为照片');

  await dt.sleep();
  dt.log.i('预期结果6、新增一张另存的照片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库加应用锁相机拍照的照片支持编辑 end');
}

/**
 * 大图-应用锁: [图库加应用锁相机拍照的照片支持分享]
 * TAG: 679 TID: Multimedia_Gallery_SR20250104962101_004
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20250104962101_004(dt: Dt) {
  dt.log.i('图库加应用锁相机拍照的照片支持分享 start');
  dt.log.i('STEP 1、图库添加应用锁');

  await dt.sleep();
  dt.log.i('STEP 2、打开相机界面，拍摄几张照片');

  await dt.sleep();
  dt.log.i('预期结果2、相机左下角缩略图不显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点开缩略图大图浏览');

  await dt.sleep();
  dt.log.i('预期结果3、跳转到大图浏览界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击分享按钮，分享照片');

  await dt.sleep();
  dt.log.i('预期结果4、成功跳转到分享界面，对端设备可以收到分享的照片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库加应用锁相机拍照的照片支持分享 end');
}

/**
 * 大图-应用锁: [图库加应用锁相机拍照的照片支持删除]
 * TAG: 682 TID: Multimedia_Gallery_SR20250104962101_005
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20250104962101_005(dt: Dt) {
  dt.log.i('图库加应用锁相机拍照的照片支持删除 start');
  dt.log.i('STEP 1、图库添加应用锁');

  await dt.sleep();
  dt.log.i('STEP 2、打开相机界面，拍摄几张照片');

  await dt.sleep();
  dt.log.i('预期结果2、拍摄照片之后，相机左下角缩略图显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点开缩略图大图浏览，删除1张照片');

  await dt.sleep();
  dt.log.i('预期结果3、跳转到大图浏览界面，正常删除');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、删除刚刚拍的全部照片');

  await dt.sleep();
  dt.log.i('预期结果4、回到相机界面，动效正常，左下角缩略图不显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、图库中查看最近删除相册');

  await dt.sleep();
  dt.log.i('预期结果5、最近删除相册中存在刚刚删除的照片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库加应用锁相机拍照的照片支持删除 end');
}

/**
 * 大图-应用锁: [图库加应用锁相机拍照的照片支持收藏]
 * TAG: 683 TID: Multimedia_Gallery_SR20250104962101_006
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20250104962101_006(dt: Dt) {
  dt.log.i('图库加应用锁相机拍照的照片支持收藏 start');
  dt.log.i('STEP 1、图库添加应用锁');

  await dt.sleep();
  dt.log.i('STEP 2、打开相机界面，拍摄几张照片');

  await dt.sleep();
  dt.log.i('预期结果2、拍摄照片之后，相机左下角缩略图显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点开缩略图大图浏览，收藏照片');

  await dt.sleep();
  dt.log.i('预期结果3、跳转到大图浏览界面，可以收藏');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、图库中查看我的收藏相册');

  await dt.sleep();
  dt.log.i('预期结果4、我的收藏相册新增刚刚收藏的照片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库加应用锁相机拍照的照片支持收藏 end');
}

/**
 * 大图-应用锁: [图库加应用锁相机拍照的照片支持隐藏]
 * TAG: 681 TID: Multimedia_Gallery_SR20250104962101_007
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20250104962101_007(dt: Dt) {
  dt.log.i('图库加应用锁相机拍照的照片支持隐藏 start');
  dt.log.i('STEP 1、图库添加应用锁');

  await dt.sleep();
  dt.log.i('STEP 2、打开相机界面，拍摄几张照片');

  await dt.sleep();
  dt.log.i('预期结果2、拍摄照片之后，相机左下角缩略图显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点开缩略图大图浏览，点击右上角更多按钮-隐藏');

  await dt.sleep();
  dt.log.i('预期结果3、可以正常隐藏');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、隐藏刚刚拍的全部照片');

  await dt.sleep();
  dt.log.i('预期结果4、回到相机界面，动效正常，左下角缩略图不显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、图库中查看隐藏相册');

  await dt.sleep();
  dt.log.i('预期结果5、隐藏相册新增刚刚隐藏的照片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库加应用锁相机拍照的照片支持隐藏 end');
}

