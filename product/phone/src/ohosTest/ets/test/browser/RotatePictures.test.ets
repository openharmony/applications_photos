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

export default function RotatePicturesTest(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('RotatePicturesTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllRotatePicturesTest').init();
      dt.log.i('beforeAll RotatePicturesTest start');
      dt.log.i('beforeAll RotatePicturesTest finish');
    });
    /**
     * 打开大图
     */
    run('beforeRotatePicturesTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('Multimedia_Gallery_RotatePictures_001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [横屏双指旋转及横竖屏切换] TID: Multimedia_Gallery_RotatePictures_001
      await Multimedia_Gallery_RotatePictures_001(dt);
    });
    run('Multimedia_Gallery_RotatePictures_002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-用例: [双指旋转同时捏合缩放] TID: Multimedia_Gallery_RotatePictures_002
      await Multimedia_Gallery_RotatePictures_002(dt);
    });
    run('Multimedia_Gallery_RotatePictures_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图双指旋转进入编辑后自动复位] TID: Multimedia_Gallery_RotatePictures_003
      await Multimedia_Gallery_RotatePictures_003(dt);
    });
    run('Multimedia_Gallery_RotatePictures_004', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-沉浸用例: [双指多角度、顺时针/逆时针旋转] TID: Multimedia_Gallery_RotatePictures_004
      await Multimedia_Gallery_RotatePictures_004(dt);
    });
    run('Multimedia_Gallery_RotatePictures_005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [悬浮窗模式下大图双指旋转] TID: Multimedia_Gallery_RotatePictures_005
      await Multimedia_Gallery_RotatePictures_005(dt);
    });
    run('Multimedia_Gallery_RotatePictures_006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [分屏模式下大图双指旋转] TID: Multimedia_Gallery_RotatePictures_006
      await Multimedia_Gallery_RotatePictures_006(dt);
    });
    run('Multimedia_Gallery_RotatePictures_007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [深色模式下大图双指旋转] TID: Multimedia_Gallery_RotatePictures_007
      await Multimedia_Gallery_RotatePictures_007(dt);
    });
    run('Multimedia_Gallery_RotatePictures_008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大字体\特大字体模式下大图双指旋转] TID: Multimedia_Gallery_RotatePictures_008
      await Multimedia_Gallery_RotatePictures_008(dt);
    });
    run('Multimedia_Gallery_RotatePictures_009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [无障碍模式下大图双指旋转] TID: Multimedia_Gallery_RotatePictures_009
      await Multimedia_Gallery_RotatePictures_009(dt);
    });
    run('Multimedia_Gallery_RotatePictures_010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图双指旋转后下拉返回] TID: Multimedia_Gallery_RotatePictures_010
      await Multimedia_Gallery_RotatePictures_010(dt);
    });
    run('Multimedia_Gallery_RotatePictures_011', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [大图双指旋转下拉返回后左右滑动浏览] TID: Multimedia_Gallery_RotatePictures_011
      await Multimedia_Gallery_RotatePictures_011(dt);
    });
    run('Multimedia_Gallery_RotatePictures_012', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图编辑后双指旋转浏览自动复位] TID: Multimedia_Gallery_RotatePictures_012
      await Multimedia_Gallery_RotatePictures_012(dt);
    });
    run('Multimedia_Gallery_RotatePictures_013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图双指旋转后分享] TID: Multimedia_Gallery_RotatePictures_013
      await Multimedia_Gallery_RotatePictures_013(dt);
    });
    run('Multimedia_Gallery_RotatePictures_014', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图旋转后隔空分享] TID: Multimedia_Gallery_RotatePictures_014
      await Multimedia_Gallery_RotatePictures_014(dt);
    });
    run('Multimedia_Gallery_RotatePictures_015', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图旋转后碰一碰分享] TID: Multimedia_Gallery_RotatePictures_015
      await Multimedia_Gallery_RotatePictures_015(dt);
    });
    run('Multimedia_Gallery_RotatePictures_016', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图双指旋转后编辑] TID: Multimedia_Gallery_RotatePictures_016
      await Multimedia_Gallery_RotatePictures_016(dt);
    });
    run('Multimedia_Gallery_RotatePictures_017', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [大图双指旋转后收藏] TID: Multimedia_Gallery_RotatePictures_017
      await Multimedia_Gallery_RotatePictures_017(dt);
    });
    run('Multimedia_Gallery_RotatePictures_018', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图双指旋转后移动] TID: Multimedia_Gallery_RotatePictures_018
      await Multimedia_Gallery_RotatePictures_018(dt);
    });
    run('Multimedia_Gallery_RotatePictures_019', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图双指旋转后隐藏] TID: Multimedia_Gallery_RotatePictures_019
      await Multimedia_Gallery_RotatePictures_019(dt);
    });
    run('Multimedia_Gallery_RotatePictures_020', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [大图双指旋转后删除] TID: Multimedia_Gallery_RotatePictures_020
      await Multimedia_Gallery_RotatePictures_020(dt);
    });
    run('Multimedia_Gallery_RotatePictures_021', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [大图双指旋转后通过详情页重命名] TID: Multimedia_Gallery_RotatePictures_021
      await Multimedia_Gallery_RotatePictures_021(dt);
    });
    run('Multimedia_Gallery_RotatePictures_022', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图双指旋转后通过更多菜单重命名] TID: Multimedia_Gallery_RotatePictures_022
      await Multimedia_Gallery_RotatePictures_022(dt);
    });
    run('Multimedia_Gallery_RotatePictures_023', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [大图双指旋转后修改备注] TID: Multimedia_Gallery_RotatePictures_023
      await Multimedia_Gallery_RotatePictures_023(dt);
    });
    run('Multimedia_Gallery_RotatePictures_024', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [自建相册/系统相册/来源相册内大图双指旋转] TID: Multimedia_Gallery_RotatePictures_024
      await Multimedia_Gallery_RotatePictures_024(dt);
    });
    run('Multimedia_Gallery_RotatePictures_025', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [最近删除大图双指旋转] TID: Multimedia_Gallery_RotatePictures_025
      await Multimedia_Gallery_RotatePictures_025(dt);
    });
    run('Multimedia_Gallery_RotatePictures_026', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [人像相册内大图双指旋转] TID: Multimedia_Gallery_RotatePictures_026
      await Multimedia_Gallery_RotatePictures_026(dt);
    });
    run('Multimedia_Gallery_RotatePictures_027', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [地图相册内大图双指旋转] TID: Multimedia_Gallery_RotatePictures_027
      await Multimedia_Gallery_RotatePictures_027(dt);
    });
    run('Multimedia_Gallery_RotatePictures_028', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [城市相册内大图双指旋转] TID: Multimedia_Gallery_RotatePictures_028
      await Multimedia_Gallery_RotatePictures_028(dt);
    });
    run('Multimedia_Gallery_RotatePictures_029', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [时刻 Tab 大图双指旋转] TID: Multimedia_Gallery_RotatePictures_029
      await Multimedia_Gallery_RotatePictures_029(dt);
    });
    run('Multimedia_Gallery_RotatePictures_030', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [时间轴Tab 三宫格/四宫格 大图双指旋转] TID: Multimedia_Gallery_RotatePictures_030
      await Multimedia_Gallery_RotatePictures_030(dt);
    });
    run('Multimedia_Gallery_RotatePictures_031', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [相机照相进入大图双指旋转浏览] TID: Multimedia_Gallery_RotatePictures_031
      await Multimedia_Gallery_RotatePictures_031(dt);
    });
    run('Multimedia_Gallery_RotatePictures_032', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [相册添加图片选择图片Picker 调用图库大图双指旋转浏览] TID: Multimedia_Gallery_RotatePictures_032
      await Multimedia_Gallery_RotatePictures_032(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachRotatePicturesTest').init();
      dt.log.i('afterEach RotatePicturesTest start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach RotatePicturesTest finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllRotatePicturesTest').init();
      dt.log.i('afterAll RotatePicturesTest start');
      await Exit.browser();
      dt.log.i('afterAll RotatePicturesTest finish');
    });
  });
}

// DT步骤
/**
 * 大图-竖屏: [横屏双指旋转及横竖屏切换]
 * TAG: 742 TID: Multimedia_Gallery_RotatePictures_001
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_001(dt: Dt) {
  dt.log.i('横屏双指旋转及横竖屏切换 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横屏/竖屏状态下逆时针\顺时针、大于\小于45°双指旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('横屏双指旋转及横竖屏切换 end');
}

/**
 * 大图-: [双指旋转同时捏合缩放]
 * TAG: 735 TID: Multimedia_Gallery_RotatePictures_002
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_002(dt: Dt) {
  dt.log.i('双指旋转同时捏合缩放 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、双指旋转同时缩合浏览图片');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转的同时大小变化过程流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('双指旋转同时捏合缩放 end');
}

/**
 * 大图-大图: [大图双指旋转进入编辑后自动复位]
 * TAG: 741 TID: Multimedia_Gallery_RotatePictures_003
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_003(dt: Dt) {
  dt.log.i('大图双指旋转进入编辑后自动复位 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、双指旋转分别使最后位置的旋转角度为90度和180度');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转过程流畅无卡顿，大图旋转位置分别保持为90°，180°。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、退出沉浸式，点击编辑按钮');

  await dt.sleep();
  dt.log.i('预期结果4、图片进入编辑模式，且图片旋转角度复原。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图双指旋转进入编辑后自动复位 end');
}

/**
 * 大图-沉浸: [双指多角度、顺时针/逆时针旋转]
 * TAG: 738 TID: Multimedia_Gallery_RotatePictures_004
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_004(dt: Dt) {
  dt.log.i('双指多角度、顺时针/逆时针旋转 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、双指分别调整旋转角度超过45度和小于45度顺时针、逆时针旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果3、图片跟随双指旋转方向旋转进入沉浸界面，旋转中心为屏幕中心点，旋转中和旋转后保持先前的缩放状态，旋转超过45度，离手自动完成90度旋转。小于45度回到原位');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、双指分别调整旋转角度超过90度和小于90度顺时针、逆时针旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果4、旋转角度超过90度时同理');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('双指多角度、顺时针/逆时针旋转 end');
}

/**
 * 大图-大图: [悬浮窗模式下大图双指旋转]
 * TAG: 739 TID: Multimedia_Gallery_RotatePictures_005
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_005(dt: Dt) {
  dt.log.i('悬浮窗模式下大图双指旋转 start');
  dt.log.i('STEP 1、设置当前模式为悬浮窗模式；');

  await dt.sleep();
  dt.log.i('预期结果1、进入悬浮窗模式');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击图库应用；');

  await dt.sleep();
  dt.log.i('预期结果2、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果3、图片被选中');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、逆时针\顺时针、大于\小于45°双指旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果4、图片旋转过程流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('悬浮窗模式下大图双指旋转 end');
}

/**
 * 大图-大图: [分屏模式下大图双指旋转]
 * TAG: 736 TID: Multimedia_Gallery_RotatePictures_006
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_006(dt: Dt) {
  dt.log.i('分屏模式下大图双指旋转 start');
  dt.log.i('STEP 1、设置当前模式为分屏模式；');

  await dt.sleep();
  dt.log.i('预期结果1、进入分屏模式');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击图库应用；');

  await dt.sleep();
  dt.log.i('预期结果2、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果3、图片被选中');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、逆时针\顺时针、大于\小于45°双指旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果4、图片旋转过程流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分屏模式下大图双指旋转 end');
}

/**
 * 大图-大图: [深色模式下大图双指旋转]
 * TAG: 749 TID: Multimedia_Gallery_RotatePictures_007
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_007(dt: Dt) {
  dt.log.i('深色模式下大图双指旋转 start');
  dt.log.i('STEP 1、设置当前模式为深色模式模式；');

  await dt.sleep();
  dt.log.i('预期结果1、进入深色模式');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击图库应用；');

  await dt.sleep();
  dt.log.i('预期结果2、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果3、图片被选中');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、逆时针\顺时针、大于\小于45°双指旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果4、图片旋转过程流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('深色模式下大图双指旋转 end');
}

/**
 * 大图-大图: [大字体\特大字体模式下大图双指旋转]
 * TAG: 737 TID: Multimedia_Gallery_RotatePictures_008
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_008(dt: Dt) {
  dt.log.i('大字体\特大字体模式下大图双指旋转 start');
  dt.log.i('STEP 1、设置当前模式为大字体\特大字体模式；');

  await dt.sleep();
  dt.log.i('预期结果1、进入大字体\特大字体模式');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击图库应用；');

  await dt.sleep();
  dt.log.i('预期结果2、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果3、图片被选中');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、逆时针\顺时针、大于\小于45°双指旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果4、图片旋转过程流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大字体\特大字体模式下大图双指旋转 end');
}

/**
 * 大图-大图: [无障碍模式下大图双指旋转]
 * TAG: 750 TID: Multimedia_Gallery_RotatePictures_009
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_009(dt: Dt) {
  dt.log.i('无障碍模式下大图双指旋转 start');
  dt.log.i('STEP 1、设置当前模式为无障碍模式；');

  await dt.sleep();
  dt.log.i('预期结果1、模式设置完成');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击图库应用；');

  await dt.sleep();
  dt.log.i('预期结果2、进入图库(遍历按钮以及各功能的点击及朗读)');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果3、图片被选中(遍历按钮以及各功能的点击及朗读)');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、逆时针\顺时针、大于\小于45°双指旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果4、图片旋转过程流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无障碍模式下大图双指旋转 end');
}

/**
 * 大图-大图: [大图双指旋转后下拉返回]
 * TAG: 740 TID: Multimedia_Gallery_RotatePictures_010
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_010(dt: Dt) {
  dt.log.i('大图双指旋转后下拉返回 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横屏/竖屏状态下逆时针\顺时针、大于\小于45°双指旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，符合UX设计。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、松开双指，下拉返回');

  await dt.sleep();
  dt.log.i('预期结果4、大图以原始状态复位。旋转操作不改变文件属性，退出大图预览依然保持原先角度');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图双指旋转后下拉返回 end');
}

/**
 * 大图-滑动: [大图双指旋转下拉返回后左右滑动浏览]
 * TAG: 747 TID: Multimedia_Gallery_RotatePictures_011
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_011(dt: Dt) {
  dt.log.i('大图双指旋转下拉返回后左右滑动浏览 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、松开双指，左右滑动浏览');

  await dt.sleep();
  dt.log.i('预期结果4、滑动流畅无卡顿');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图双指旋转下拉返回后左右滑动浏览 end');
}

/**
 * 大图-大图: [大图编辑后双指旋转浏览自动复位]
 * TAG: 746 TID: Multimedia_Gallery_RotatePictures_012
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_012(dt: Dt) {
  dt.log.i('大图编辑后双指旋转浏览自动复位 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击下方编辑按钮，编辑保存图片');

  await dt.sleep();
  dt.log.i('预期结果3、图片编辑保存成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、逆时针\顺时针、大于\小于45°双指旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果4、图片旋转流畅无卡顿，符合UX设计。旋转操作不改变文件属性，退出大图预览依然保持原先角度');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图编辑后双指旋转浏览自动复位 end');
}

/**
 * 大图-大图: [大图双指旋转后分享]
 * TAG: 743 TID: Multimedia_Gallery_RotatePictures_013
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_013(dt: Dt) {
  dt.log.i('大图双指旋转后分享 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片后退出沉浸式');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击下方分享按钮');

  await dt.sleep();
  dt.log.i('预期结果4、图片分享成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图双指旋转后分享 end');
}

/**
 * 大图-大图: [大图旋转后隔空分享]
 * TAG: 748 TID: Multimedia_Gallery_RotatePictures_014
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_014(dt: Dt) {
  dt.log.i('大图旋转后隔空分享 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、双指旋转图片90°');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、发送手机做手掌握拳手势；');

  await dt.sleep();
  dt.log.i('预期结果4、发送端可以识别握拳手势，有隔空传的动效');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、接收手机做手掌松拳张开手势');

  await dt.sleep();
  dt.log.i('预期结果5、接收端可以识别松拳手势，弹出文件接收弹窗，发送端文件下载成功后自动分享完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图旋转后隔空分享 end');
}

/**
 * 大图-大图: [大图旋转后碰一碰分享]
 * TAG: 745 TID: Multimedia_Gallery_RotatePictures_015
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_015(dt: Dt) {
  dt.log.i('大图旋转后碰一碰分享 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、双指旋转图片90°');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、两台手机碰一碰；');

  await dt.sleep();
  dt.log.i('预期结果4、有一碰传的动效，进入上划分享界面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、上划分享的界面');

  await dt.sleep();
  dt.log.i('预期结果5、上划分享，自动进入下载界面，云端的数据下载完成之后自动分享完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图旋转后碰一碰分享 end');
}

/**
 * 大图-大图: [大图双指旋转后编辑]
 * TAG: 744 TID: Multimedia_Gallery_RotatePictures_016
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_016(dt: Dt) {
  dt.log.i('大图双指旋转后编辑 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片后退出沉浸式');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击下方编辑按钮，编辑并保存图片');

  await dt.sleep();
  dt.log.i('预期结果4、图片编辑后保存成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图双指旋转后编辑 end');
}

/**
 * 大图-收藏: [大图双指旋转后收藏]
 * TAG: 757 TID: Multimedia_Gallery_RotatePictures_017
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_017(dt: Dt) {
  dt.log.i('大图双指旋转后收藏 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片后退出沉浸式');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击下方收藏按钮');

  await dt.sleep();
  dt.log.i('预期结果4、图片收藏成功，在我的收藏相册可见');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图双指旋转后收藏 end');
}

/**
 * 大图-大图: [大图双指旋转后移动]
 * TAG: 751 TID: Multimedia_Gallery_RotatePictures_018
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_018(dt: Dt) {
  dt.log.i('大图双指旋转后移动 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片后退出沉浸式');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击右上方更多按钮，选择移动到选择其他相册');

  await dt.sleep();
  dt.log.i('预期结果4、图片移动到其他相册成功，目标相册图片状态返为旋转前状态');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图双指旋转后移动 end');
}

/**
 * 大图-大图: [大图双指旋转后隐藏]
 * TAG: 754 TID: Multimedia_Gallery_RotatePictures_019
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_019(dt: Dt) {
  dt.log.i('大图双指旋转后隐藏 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片后退出沉浸式');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击右上方更多按钮，选择隐藏');

  await dt.sleep();
  dt.log.i('预期结果4、图片移动到隐藏相册成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图双指旋转后隐藏 end');
}

/**
 * 大图-删除: [大图双指旋转后删除]
 * TAG: 753 TID: Multimedia_Gallery_RotatePictures_020
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_020(dt: Dt) {
  dt.log.i('大图双指旋转后删除 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片后退出沉浸式');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击下方删除按钮');

  await dt.sleep();
  dt.log.i('预期结果4、图片删除成功，在最近删除文件夹内可见，图片状态返为旋转前状态');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图双指旋转后删除 end');
}

/**
 * 大图-详情: [大图双指旋转后通过详情页重命名]
 * TAG: 755 TID: Multimedia_Gallery_RotatePictures_021
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_021(dt: Dt) {
  dt.log.i('大图双指旋转后通过详情页重命名 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片后退出沉浸式');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、上划旋转后，点击右上方更多按钮，选择重命名重命名图片。');

  await dt.sleep();
  dt.log.i('预期结果4、图片重命名成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图双指旋转后通过详情页重命名 end');
}

/**
 * 大图-大图: [大图双指旋转后通过更多菜单重命名]
 * TAG: 752 TID: Multimedia_Gallery_RotatePictures_022
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_022(dt: Dt) {
  dt.log.i('大图双指旋转后通过更多菜单重命名 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片后退出沉浸式');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、上划旋转后大图在大图详情页直接重命名');

  await dt.sleep();
  dt.log.i('预期结果4、图片重命名成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图双指旋转后通过更多菜单重命名 end');
}

/**
 * 大图-大图: [大图双指旋转后修改备注]
 * TAG: 759 TID: Multimedia_Gallery_RotatePictures_023
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_023(dt: Dt) {
  dt.log.i('大图双指旋转后修改备注 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片后退出沉浸式');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、上划旋转后大图在大图详情页修改备注。');

  await dt.sleep();
  dt.log.i('预期结果4、图片添加备注成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图双指旋转后修改备注 end');
}

/**
 * 大图-大图: [自建相册/系统相册/来源相册内大图双指旋转]
 * TAG: 756 TID: Multimedia_Gallery_RotatePictures_024
 * 前置条件
 * 1、对应相册内存在照片
 */
async function Multimedia_Gallery_RotatePictures_024(dt: Dt) {
  dt.log.i('自建相册/系统相册/来源相册内大图双指旋转 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、用户自建相册/系统相册/第三方相册页进入图片宫格页面，点击图片，');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('自建相册/系统相册/来源相册内大图双指旋转 end');
}

/**
 * 大图-删除: [最近删除大图双指旋转]
 * TAG: 758 TID: Multimedia_Gallery_RotatePictures_025
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_025(dt: Dt) {
  dt.log.i('最近删除大图双指旋转 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、相册Tab选择最近删除，并点击图片');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除大图双指旋转 end');
}

/**
 * 大图-大图: [人像相册内大图双指旋转]
 * TAG: 760 TID: Multimedia_Gallery_RotatePictures_026
 * 前置条件
 * 1、图库存在照片，智慧分析生成结果
 */
async function Multimedia_Gallery_RotatePictures_026(dt: Dt) {
  dt.log.i('人像相册内大图双指旋转 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在相册Tab选择人像相册内选择并点击图片');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('人像相册内大图双指旋转 end');
}

/**
 * 大图-大图: [地图相册内大图双指旋转]
 * TAG: 763 TID: Multimedia_Gallery_RotatePictures_027
 * 前置条件
 * 1、图库存在照片，智慧分析生成结果
 */
async function Multimedia_Gallery_RotatePictures_027(dt: Dt) {
  dt.log.i('地图相册内大图双指旋转 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在相册Tab选择地点相册->地图相册内选择并点击图片');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地图相册内大图双指旋转 end');
}

/**
 * 大图-大图: [城市相册内大图双指旋转]
 * TAG: 761 TID: Multimedia_Gallery_RotatePictures_028
 * 前置条件
 * 1、图库存在照片，智慧分析生成结果
 */
async function Multimedia_Gallery_RotatePictures_028(dt: Dt) {
  dt.log.i('城市相册内大图双指旋转 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在相册Tab选择人像/地点相册内选择并点击图片');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('城市相册内大图双指旋转 end');
}

/**
 * 大图-大图: [时刻 Tab 大图双指旋转]
 * TAG: 762 TID: Multimedia_Gallery_RotatePictures_029
 * 前置条件
 * 1、图库存在照片，智慧分析生成结果
 */
async function Multimedia_Gallery_RotatePictures_029(dt: Dt) {
  dt.log.i('时刻 Tab 大图双指旋转 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在时刻Tab选择并点击图片');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻 Tab 大图双指旋转 end');
}

/**
 * 大图-大图: [时间轴Tab 三宫格/四宫格 大图双指旋转]
 * TAG: 765 TID: Multimedia_Gallery_RotatePictures_030
 * 前置条件
 * 1、图库存在照片，智慧分析生成结果
 */
async function Multimedia_Gallery_RotatePictures_030(dt: Dt) {
  dt.log.i('时间轴Tab 三宫格/四宫格 大图双指旋转 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在时间轴Tab  三宫格/四宫格模式下选择并点击图片');

  await dt.sleep();
  dt.log.i('预期结果2、图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时间轴Tab 三宫格/四宫格 大图双指旋转 end');
}

/**
 * 大图-进入大图: [相机照相进入大图双指旋转浏览]
 * TAG: 764 TID: Multimedia_Gallery_RotatePictures_031
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_031(dt: Dt) {
  dt.log.i('相机照相进入大图双指旋转浏览 start');
  dt.log.i('STEP 1、打开相机拍照');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在相机左下角点击图片缩略图进入大图');

  await dt.sleep();
  dt.log.i('预期结果2、进入大图预览界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、逆时针\顺时针、大于\小于45°双指旋转浏览图片');

  await dt.sleep();
  dt.log.i('预期结果3、图片旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、松开双指，左右滑动浏览图片');

  await dt.sleep();
  dt.log.i('预期结果4、滑动画面流畅无卡顿。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机照相进入大图双指旋转浏览 end');
}

/**
 * 大图-大图: [相册添加图片选择图片Picker 调用图库大图双指旋转浏览]
 * TAG: 766 TID: Multimedia_Gallery_RotatePictures_032
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_RotatePictures_032(dt: Dt) {
  dt.log.i('相册添加图片选择图片Picker 调用图库大图双指旋转浏览 start');
  dt.log.i('STEP 1、打开图库');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入自建相册点击添加图片按钮');

  await dt.sleep();
  dt.log.i('预期结果2、成功调起图库Picker宫格');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、选择图片并双指旋转浏览');

  await dt.sleep();
  dt.log.i('预期结果3、旋转流畅无卡顿，图片跟随双指旋转方向旋转，符合UX设计');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、松开双指并勾选图片，点击完成。');

  await dt.sleep();
  dt.log.i('预期结果4、图片成功添加到自建相册。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册添加图片选择图片Picker 调用图库大图双指旋转浏览 end');
}

