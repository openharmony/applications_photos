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

export default function MultimediaGalleryPcCommercialization(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryPcCommercializationTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryPcCommercialization').init();
      dt.log.i('beforeAll MultimediaGalleryPcCommercialization start');
      dt.log.i('beforeAll MultimediaGalleryPcCommercialization finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryPcCommercialization', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('Multimedia_Gallery_PC_Commercialization_001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [PC侧边栏显示规则] TID: Multimedia_Gallery_PC_Commercialization_001
      await Multimedia_Gallery_PC_Commercialization_001(dt);
    });
    run('Multimedia_Gallery_PC_Commercialization_002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [内容区一级标题显示规则] TID: Multimedia_Gallery_PC_Commercialization_002
      await Multimedia_Gallery_PC_Commercialization_002(dt);
    });
    run('Multimedia_Gallery_PC_Commercialization_003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [内容区二级标题显示规则] TID: Multimedia_Gallery_PC_Commercialization_003
      await Multimedia_Gallery_PC_Commercialization_003(dt);
    });
    run('Multimedia_Gallery_PC_Commercialization_004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [窗口缩小操作按钮收起] TID: Multimedia_Gallery_PC_Commercialization_004
      await Multimedia_Gallery_PC_Commercialization_004(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-用例: [PC宫格页面显示大小缩放] TID: Multimedia_Gallery_PC_PAD_Differentiation_001
      await Multimedia_Gallery_PC_PAD_Differentiation_001(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [PC宫格页面hover收藏图片] TID: Multimedia_Gallery_PC_PAD_Differentiation_002
      await Multimedia_Gallery_PC_PAD_Differentiation_002(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [PC宫格页面滑动浏览] TID: Multimedia_Gallery_PC_PAD_Differentiation_003
      await Multimedia_Gallery_PC_PAD_Differentiation_003(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-深色用例: [PC宫格页面框选图片] TID: Multimedia_Gallery_PC_PAD_Differentiation_004
      await Multimedia_Gallery_PC_PAD_Differentiation_004(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [PC宫格页面多选图片] TID: Multimedia_Gallery_PC_PAD_Differentiation_005
      await Multimedia_Gallery_PC_PAD_Differentiation_005(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC宫格页面选中图片] TID: Multimedia_Gallery_PC_PAD_Differentiation_006
      await Multimedia_Gallery_PC_PAD_Differentiation_006(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC大图页面缩放图片] TID: Multimedia_Gallery_PC_PAD_Differentiation_007
      await Multimedia_Gallery_PC_PAD_Differentiation_007(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC大图页面缩放图片相机入口] TID: Multimedia_Gallery_PC_PAD_Differentiation_008
      await Multimedia_Gallery_PC_PAD_Differentiation_008(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC大图页面缩放图片三方入口] TID: Multimedia_Gallery_PC_PAD_Differentiation_009
      await Multimedia_Gallery_PC_PAD_Differentiation_009(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC大图页面切换图片] TID: Multimedia_Gallery_PC_PAD_Differentiation_010
      await Multimedia_Gallery_PC_PAD_Differentiation_010(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC大图页面预览2s] TID: Multimedia_Gallery_PC_PAD_Differentiation_011
      await Multimedia_Gallery_PC_PAD_Differentiation_011(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-拖拽用例: [PC大图拖拽] TID: Multimedia_Gallery_PC_PAD_Differentiation_012
      await Multimedia_Gallery_PC_PAD_Differentiation_012(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_013', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-拖拽用例: [PC宫格页面多选拖拽] TID: Multimedia_Gallery_PC_PAD_Differentiation_013
      await Multimedia_Gallery_PC_PAD_Differentiation_013(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_014', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [空格键进入大图] TID: Multimedia_Gallery_PC_PAD_Differentiation_014
      await Multimedia_Gallery_PC_PAD_Differentiation_014(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_015', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [Enter键进入大图] TID: Multimedia_Gallery_PC_PAD_Differentiation_015
      await Multimedia_Gallery_PC_PAD_Differentiation_015(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [图库窗口最大化] TID: Multimedia_Gallery_PC_PAD_Differentiation_016
      await Multimedia_Gallery_PC_PAD_Differentiation_016(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_017', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [Esc返回上级界面] TID: Multimedia_Gallery_PC_PAD_Differentiation_017
      await Multimedia_Gallery_PC_PAD_Differentiation_017(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_018', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [图库窗口移动] TID: Multimedia_Gallery_PC_PAD_Differentiation_018
      await Multimedia_Gallery_PC_PAD_Differentiation_018(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_019', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [系统相册宫格右键菜单] TID: Multimedia_Gallery_PC_PAD_Differentiation_019
      await Multimedia_Gallery_PC_PAD_Differentiation_019(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_020', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [用户创建相册宫格右键菜单] TID: Multimedia_Gallery_PC_PAD_Differentiation_020
      await Multimedia_Gallery_PC_PAD_Differentiation_020(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_021', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [隐藏相册宫格右键菜单] TID: Multimedia_Gallery_PC_PAD_Differentiation_021
      await Multimedia_Gallery_PC_PAD_Differentiation_021(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_022', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [最近删除相册宫格右键菜单] TID: Multimedia_Gallery_PC_PAD_Differentiation_022
      await Multimedia_Gallery_PC_PAD_Differentiation_022(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_023', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [智慧相册宫格右键菜单] TID: Multimedia_Gallery_PC_PAD_Differentiation_023
      await Multimedia_Gallery_PC_PAD_Differentiation_023(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_024', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [系统相册大图页面右键菜单] TID: Multimedia_Gallery_PC_PAD_Differentiation_024
      await Multimedia_Gallery_PC_PAD_Differentiation_024(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_025', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [隐藏删除相册大图页面右键菜单] TID: Multimedia_Gallery_PC_PAD_Differentiation_025
      await Multimedia_Gallery_PC_PAD_Differentiation_025(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_026', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [智慧相册大图页面右键菜单] TID: Multimedia_Gallery_PC_PAD_Differentiation_026
      await Multimedia_Gallery_PC_PAD_Differentiation_026(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_027', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [用户创建相册右键菜单] TID: Multimedia_Gallery_PC_PAD_Differentiation_027
      await Multimedia_Gallery_PC_PAD_Differentiation_027(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_028', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [PC/PAD侧边栏适配] TID: Multimedia_Gallery_PC_PAD_Differentiation_028
      await Multimedia_Gallery_PC_PAD_Differentiation_028(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_029', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [创建新相册] TID: Multimedia_Gallery_PC_PAD_Differentiation_029
      await Multimedia_Gallery_PC_PAD_Differentiation_029(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_030', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-拖拽用例: [相册宫格拖拽图片] TID: Multimedia_Gallery_PC_PAD_Differentiation_030
      await Multimedia_Gallery_PC_PAD_Differentiation_030(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_031', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-拖拽用例: [用户创建相册拖拽排序] TID: Multimedia_Gallery_PC_PAD_Differentiation_031
      await Multimedia_Gallery_PC_PAD_Differentiation_031(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_032', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-拖拽用例: [PC宫格多选拖拽到用户创建相册] TID: Multimedia_Gallery_PC_PAD_Differentiation_032
      await Multimedia_Gallery_PC_PAD_Differentiation_032(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_033', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-拖拽用例: [PC单张图片拖拽] TID: Multimedia_Gallery_PC_PAD_Differentiation_033
      await Multimedia_Gallery_PC_PAD_Differentiation_033(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_035', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [删除图片侧边栏数量刷新] TID: Multimedia_Gallery_PC_PAD_Differentiation_035
      await Multimedia_Gallery_PC_PAD_Differentiation_035(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_036', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [隐藏图片侧边栏数量刷新] TID: Multimedia_Gallery_PC_PAD_Differentiation_036
      await Multimedia_Gallery_PC_PAD_Differentiation_036(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_037', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-深色用例: [图库适配深色模式] TID: Multimedia_Gallery_PC_PAD_Differentiation_037
      await Multimedia_Gallery_PC_PAD_Differentiation_037(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_038', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [图库适配多语言] TID: Multimedia_Gallery_PC_PAD_Differentiation_038
      await Multimedia_Gallery_PC_PAD_Differentiation_038(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_039', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [tap键走焦] TID: Multimedia_Gallery_PC_PAD_Differentiation_039
      await Multimedia_Gallery_PC_PAD_Differentiation_039(dt);
    });
    run('Multimedia_Gallery_PC_PAD_Differentiation_040', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [PC宫格走焦] TID: Multimedia_Gallery_PC_PAD_Differentiation_040
      await Multimedia_Gallery_PC_PAD_Differentiation_040(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryPcCommercialization').init();
      dt.log.i('afterEach MultimediaGalleryPcCommercialization start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryPcCommercialization finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryPcCommercialization').init();
      dt.log.i('afterAll MultimediaGalleryPcCommercialization start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryPcCommercialization finish');
    });
  });
}

// DT步骤
/**
 * 大图-视频: [PC侧边栏显示规则]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_Commercialization_001
 * 前置条件
 * 1、图库中存在图片视频文件
 */
async function Multimedia_Gallery_PC_Commercialization_001(dt: Dt) {
  dt.log.i('PC侧边栏显示规则 start');
  dt.log.i('STEP 1、打开图库调节窗口大小');

  await dt.sleep();
  dt.log.i('预期结果1、图库侧边栏自动收起');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、当窗口宽度缩小至840vp时');

  await dt.sleep();
  dt.log.i('预期结果2、图库侧边栏自动展开');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、放大窗口宽度大于840vp时');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC侧边栏显示规则 end');
}

/**
 * 大图-收藏: [内容区一级标题显示规则]
 * GROUP: 大图 MODULE: 收藏TID: Multimedia_Gallery_PC_Commercialization_002
 * 前置条件
 * 1、图库中存在图片视频文件
 2、内容区（宫格页）一级标题，例如图片、视频、我的收藏、已隐藏等
 */
async function Multimedia_Gallery_PC_Commercialization_002(dt: Dt) {
  dt.log.i('内容区一级标题显示规则 start');
  dt.log.i('STEP 1、打开图库，侧边栏正常显示时');

  await dt.sleep();
  dt.log.i('STEP 2、查看内容区标题栏');

  await dt.sleep();
  dt.log.i('预期结果2、内容区一级标题不显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、调节窗口大小，侧边栏收起时');

  await dt.sleep();
  dt.log.i('预期结果3、内容区一级标题正常显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看内容区标题栏ps：“图片与视频”页，一级标题在侧边栏展开和收起时，都默认显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('内容区一级标题显示规则 end');
}

/**
 * 大图-视频: [内容区二级标题显示规则]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_Commercialization_003
 * 前置条件
 * 1、图库中存在图片视频文件
 2、隐藏相册和分类相册显示二级标题
 */
async function Multimedia_Gallery_PC_Commercialization_003(dt: Dt) {
  dt.log.i('内容区二级标题显示规则 start');
  dt.log.i('STEP 1、打开图库，侧边栏正常显示时');

  await dt.sleep();
  dt.log.i('STEP 2、进入隐藏相册，切换相册视图');

  await dt.sleep();
  dt.log.i('预期结果2、内容区一级标题“已隐藏”不显示');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('已隐藏'));
  dt.log.i('STEP 3、然后进入其中某一相册，例如“新建相册一”');

  await dt.sleep();
  dt.log.i('预期结果3、内容区二级标题“新建相册一”正常显示');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('新建相册一', true);
  dt.log.i('STEP 4、在分类相册重复上述操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('内容区二级标题显示规则 end');
}

/**
 * 大图-视频: [窗口缩小操作按钮收起]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_Commercialization_004
 * 前置条件
 * 1、图库中存在图片视频文件
 */
async function Multimedia_Gallery_PC_Commercialization_004(dt: Dt) {
  dt.log.i('窗口缩小操作按钮收起 start');
  dt.log.i('STEP 1、打开图库，宫格页面进入多选');

  await dt.sleep();
  dt.log.i('STEP 2、缩小窗口，查看查看宫格上方操作按钮');

  await dt.sleep();
  dt.log.i('预期结果2、搜索框收起，显示搜索图标');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、持续缩小窗口');

  await dt.sleep();
  dt.log.i('预期结果3、宫格上方的操作按钮收入到更多里边显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('窗口缩小操作按钮收起 end');
}

/**
 * 大图-: [PC宫格页面显示大小缩放]
 * GROUP: 大图 MODULE: TID: Multimedia_Gallery_PC_PAD_Differentiation_001
 * 前置条件
 * 1、宫格页面有超过五屏的图片
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_001(dt: Dt) {
  dt.log.i('PC宫格页面显示大小缩放 start');
  dt.log.i('STEP 1、点击侧边栏选中某一相册查看宫格图片');

  await dt.sleep();
  dt.log.i('预期结果1、宫格显示默认大小，一行七个缩略图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、使用ctry+鼠标滚动调节宫格大小');

  await dt.sleep();
  dt.log.i('预期结果2、宫格缩略图正常放大缩小，一共有四个档位');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、使用ctry和+/-按钮调节宫格大小');

  await dt.sleep();
  dt.log.i('STEP 4、在触控板双指捏合放大缩小宫格大小');

  await dt.sleep();
  dt.log.i('STEP 5、在各个相册中（系统相册-重点关注隐藏相册、用户创建相册、智慧相册、来源相册）中重复上述操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC宫格页面显示大小缩放 end');
}

/**
 * 大图-收藏: [PC宫格页面hover收藏图片]
 * GROUP: 大图 MODULE: 收藏TID: Multimedia_Gallery_PC_PAD_Differentiation_002
 * 前置条件
 * 1、图库中存在图片文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_002(dt: Dt) {
  dt.log.i('PC宫格页面hover收藏图片 start');
  dt.log.i('STEP 1、图片宫格缩略图上显示收藏图标');

  await dt.sleep();
  dt.log.i('预期结果1、未被收藏的显示空心的收藏图标，已经收藏的显示实心的收藏图标');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击缩略图上的空心收藏图标');

  await dt.sleep();
  dt.log.i('预期结果2、图片正常被收藏，收藏图标变为实心图标，收藏相册图片数量加1');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击缩略图上的实心收藏图标');

  await dt.sleep();
  dt.log.i('预期结果3、图片被取消收藏，收藏图标变为空心图标，收藏相册图片数量减1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、开启深色模式查看图标是否正常显示');

  await dt.sleep();
  dt.log.i('STEP 5、在各个相册中（系统相册-重点关注隐藏相册、用户创建相册、智慧相册、来源相册）中重复上述操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC宫格页面hover收藏图片 end');
}

/**
 * 大图-滑动: [PC宫格页面滑动浏览]
 * GROUP: 大图 MODULE: 滑动TID: Multimedia_Gallery_PC_PAD_Differentiation_003
 * 前置条件
 * 1、宫格页面有超过五屏的图片
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_003(dt: Dt) {
  dt.log.i('PC宫格页面滑动浏览 start');
  dt.log.i('STEP 1、图片宫格缩略图上下互动浏览图片');

  await dt.sleep();
  dt.log.i('预期结果1、浏览过程中页面上方正常显示按钮和日期，没有沉浸式浏览效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在各个相册中（系统相册-重点关注隐藏相册、用户创建相册、智慧相册、来源相册）中重复上述操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC宫格页面滑动浏览 end');
}

/**
 * 大图-深色: [PC宫格页面框选图片]
 * GROUP: 大图 MODULE: 深色TID: Multimedia_Gallery_PC_PAD_Differentiation_004
 * 前置条件
 * 1、宫格页面有超过五屏的图片
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_004(dt: Dt) {
  dt.log.i('PC宫格页面框选图片 start');
  dt.log.i('STEP 1、在宫格中鼠标左键按下拖动框选图片');

  await dt.sleep();
  dt.log.i('预期结果1、鼠标框住的选择框中的图片被正常选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在宫格中触控板按下拖动框选图片');

  await dt.sleep();
  dt.log.i('STEP 3、开启深色模式查看选中状态显示是否正常');

  await dt.sleep();
  dt.log.i('STEP 4、在各个相册中（系统相册-重点关注隐藏相册、用户创建相册、智慧相册、来源相册）中重复上述操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC宫格页面框选图片 end');
}

/**
 * 大图-视频: [PC宫格页面多选图片]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_PAD_Differentiation_005
 * 前置条件
 * 1、宫格页面有超过五屏的图片
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_005(dt: Dt) {
  dt.log.i('PC宫格页面多选图片 start');
  dt.log.i('STEP 1、在宫格中单击选中图片');

  await dt.sleep();
  dt.log.i('STEP 2.1、按住Ctrl键，鼠标点击选中不同位置的图片视频文件2.2、按住shift键，鼠标点击其他位置的另一图片');

  await dt.sleep();
  dt.log.i('预期结果2.1、鼠标点击过的图片全部被选中2.2、两个图片位置中间的所有图片被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、按住Ctrl键和shift键组合使用选中图片');

  await dt.sleep();
  dt.log.i('预期结果3、查看选中图片是否正确');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、在各个相册中（系统相册-重点关注隐藏相册、用户创建相册、智慧相册、来源相册）中重复上述操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC宫格页面多选图片 end');
}

/**
 * 大图-大图: [PC宫格页面选中图片]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_PAD_Differentiation_006
 * 前置条件
 * 1、宫格页面有超过五屏的图片
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_006(dt: Dt) {
  dt.log.i('PC宫格页面选中图片 start');
  dt.log.i('STEP 1、在宫格点击图片缩略图');

  await dt.sleep();
  dt.log.i('预期结果1、图片缩略图被获焦选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在宫格中双击图片缩略图');

  await dt.sleep();
  dt.log.i('预期结果2、成功打开图片大图浏览');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在各个相册中（系统相册-重点关注隐藏相册、用户创建相册、智慧相册、来源相册）中重复上述操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC宫格页面选中图片 end');
}

/**
 * 大图-大图: [PC大图页面缩放图片]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_PAD_Differentiation_007
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_007(dt: Dt) {
  dt.log.i('PC大图页面缩放图片 start');
  dt.log.i('STEP 1、在图库宫格中双击图片进入大图页面');

  await dt.sleep();
  dt.log.i('预期结果1、图片被正常放大缩小');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、使用ctry+鼠标滚动调节图片大小');

  await dt.sleep();
  dt.log.i('STEP 3、在大图页面双击鼠标放大缩小图片');

  await dt.sleep();
  dt.log.i('STEP 4、在触控板双指捏合放大缩小图片');

  await dt.sleep();
  dt.log.i('STEP 5、在触控板双击放大缩小图片');

  await dt.sleep();
  dt.log.i('STEP 6、从相机入口点击缩略图进入大图，重复上述操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图页面缩放图片 end');
}

/**
 * 大图-大图: [PC大图页面缩放图片相机入口]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_PAD_Differentiation_008
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_008(dt: Dt) {
  dt.log.i('PC大图页面缩放图片相机入口 start');
  dt.log.i('STEP 1、从相机入口点击缩略图进入大图页面');

  await dt.sleep();
  dt.log.i('预期结果1、图片被正常放大缩小');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、使用ctry+鼠标滚动调节图片大小');

  await dt.sleep();
  dt.log.i('STEP 3、在大图页面双击鼠标放大缩小图片');

  await dt.sleep();
  dt.log.i('STEP 4、在触控板双指捏合放大缩小图片');

  await dt.sleep();
  dt.log.i('STEP 5、在触控板双击放大缩小图片');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图页面缩放图片相机入口 end');
}

/**
 * 大图-大图: [PC大图页面缩放图片三方入口]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_PAD_Differentiation_009
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_009(dt: Dt) {
  dt.log.i('PC大图页面缩放图片三方入口 start');
  dt.log.i('STEP 1、使用picker打开大图');

  await dt.sleep();
  dt.log.i('预期结果1、图片被正常放大缩小');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、使用ctry+鼠标滚动调节图片大小');

  await dt.sleep();
  dt.log.i('STEP 3、在大图页面双击鼠标放大缩小图片');

  await dt.sleep();
  dt.log.i('STEP 4、在触控板双指捏合放大缩小图片');

  await dt.sleep();
  dt.log.i('STEP 5、在触控板双击放大缩小图片');

  await dt.sleep();
  dt.log.i('STEP 6、截图录屏后点击缩略图进入大图页面（目前截图不支持图库打开大图，录屏支持）重复上述操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图页面缩放图片三方入口 end');
}

/**
 * 大图-大图: [PC大图页面切换图片]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_PAD_Differentiation_010
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_010(dt: Dt) {
  dt.log.i('PC大图页面切换图片 start');
  dt.log.i('STEP 1、在宫格中双击图片进入大图页面');

  await dt.sleep();
  dt.log.i('预期结果1、图片正常左右切换浏览');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击左右方向键');

  await dt.sleep();
  dt.log.i('STEP 3、触控板双指左右滑动');

  await dt.sleep();
  dt.log.i('STEP 4、从相机入口进入大图，重复上述操作');

  await dt.sleep();
  dt.log.i('STEP 5、截图后点击缩略图进入大图，重复上述操作（暂不支持此操作）');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图页面切换图片 end');
}

/**
 * 大图-大图: [PC大图页面预览2s]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_PAD_Differentiation_011
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_011(dt: Dt) {
  dt.log.i('PC大图页面预览2s start');
  dt.log.i('STEP 1、在宫格中双击图片进入大图页面');

  await dt.sleep();
  dt.log.i('预期结果1、图片底部快速预览条和左右切换按钮正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在大图页面等待2s');

  await dt.sleep();
  dt.log.i('预期结果2、图片底部快速预览条正常显示，左右切换按钮消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、将鼠标移动到图片底部快速预览条或者左右切换按钮附近');

  await dt.sleep();
  dt.log.i('预期结果3、图片底部快速预览条保持显示状态，左右切换按钮自动显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、从相机入口进入大图，重复上述操作');

  await dt.sleep();
  dt.log.i('预期结果4、相机入口进大图和上述现象一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、截图录屏后点击缩略图进入大图，重复上述操作（目前截图不支持使用图库打开，录屏支持使用图库打开）');

  await dt.sleep();
  dt.log.i('预期结果5、截图后点击缩略图进大图，不显示图片底部快读预览条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图页面预览2s end');
}

/**
 * 大图-拖拽: [PC大图拖拽]
 * GROUP: 大图 MODULE: 拖拽TID: Multimedia_Gallery_PC_PAD_Differentiation_012
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_012(dt: Dt) {
  dt.log.i('PC大图拖拽 start');
  dt.log.i('STEP 1、在图库中打开大图浏览图片');

  await dt.sleep();
  dt.log.i('预期结果1、图库无法被拖拽移动，图库大图不支持拖拽');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击图片拖拽移动');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图拖拽 end');
}

/**
 * 大图-拖拽: [PC宫格页面多选拖拽]
 * GROUP: 大图 MODULE: 拖拽TID: Multimedia_Gallery_PC_PAD_Differentiation_013
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_013(dt: Dt) {
  dt.log.i('PC宫格页面多选拖拽 start');
  dt.log.i('STEP 1、在宫格页面点击多选，选中几张图片');

  await dt.sleep();
  dt.log.i('STEP 2、点击图片进行拖拽');

  await dt.sleep();
  dt.log.i('预期结果2、选中图片聚合在一起跟随鼠标移动');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拖拽到其他应用，例如文件管理');

  await dt.sleep();
  dt.log.i('预期结果3、图片可以正常被拖拽到文件管理中5、图片可以正常聚合拖拽7、图片可以正常聚合拖拽');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、在宫格页面使用鼠标框选，选中几张图片');

  await dt.sleep();
  dt.log.i('STEP 5、重复上述操作');

  await dt.sleep();
  dt.log.i('预期结果5、图片可以正常聚合拖拽7、图片可以正常聚合拖拽');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、在宫格页面使用shit和ctry键组合多选，选中几张图片');

  await dt.sleep();
  dt.log.i('STEP 7、重复上述操作');

  await dt.sleep();
  dt.log.i('预期结果7、图片可以正常聚合拖拽');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC宫格页面多选拖拽 end');
}

/**
 * 大图-进入大图: [空格键进入大图]
 * GROUP: 大图 MODULE: 进入大图TID: Multimedia_Gallery_PC_PAD_Differentiation_014
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_014(dt: Dt) {
  dt.log.i('空格键进入大图 start');
  dt.log.i('STEP 1、在宫格页面点击选中图片');

  await dt.sleep();
  dt.log.i('STEP 2、点击空格键');

  await dt.sleep();
  dt.log.i('预期结果2、正常进入大图页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次点击空格键');

  await dt.sleep();
  dt.log.i('预期结果3、返回到宫格页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、或者点击esc键');

  await dt.sleep();
  dt.log.i('预期结果4、返回到宫格页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、在智慧相册，搜索页面重复上述操作');

  await dt.sleep();
  dt.log.i('预期结果5、图片可以正常进入退出大图');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('空格键进入大图 end');
}

/**
 * 大图-进入大图: [Enter键进入大图]
 * GROUP: 大图 MODULE: 进入大图TID: Multimedia_Gallery_PC_PAD_Differentiation_015
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_015(dt: Dt) {
  dt.log.i('Enter键进入大图 start');
  dt.log.i('STEP 1、在宫格页面点击选中图片');

  await dt.sleep();
  dt.log.i('STEP 2、第一次点击Enter键');

  await dt.sleep();
  dt.log.i('预期结果2、正常进入大图页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、第二次点击Enter键');

  await dt.sleep();
  dt.log.i('预期结果3、进入编辑页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、第三次点击Enter键');

  await dt.sleep();
  dt.log.i('预期结果4、页面无反应');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、第一次点击esc键');

  await dt.sleep();
  dt.log.i('预期结果5、从编辑返回到大大图页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、返回大图后再次点击esc键');

  await dt.sleep();
  dt.log.i('预期结果6、返回到宫格页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、在智慧相册，搜索页面重复上述操作');

  await dt.sleep();
  dt.log.i('预期结果7、图片可以正常进入退出大图');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('Enter键进入大图 end');
}

/**
 * 大图-进入大图: [图库窗口最大化]
 * GROUP: 大图 MODULE: 进入大图TID: Multimedia_Gallery_PC_PAD_Differentiation_016
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_016(dt: Dt) {
  dt.log.i('图库窗口最大化 start');
  dt.log.i('STEP 1、打开图库应用');

  await dt.sleep();
  dt.log.i('STEP 2、点击放大按钮');

  await dt.sleep();
  dt.log.i('预期结果2、图库窗口正常进入最大化');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、双击图库应用窗口上侧');

  await dt.sleep();
  dt.log.i('预期结果3、图库窗口正常进入最大化');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、再次双击图库应用窗口上侧');

  await dt.sleep();
  dt.log.i('预期结果4、图库窗口恢复到正常大小');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、宫格中点击图片进入大图页面重复上述操作');

  await dt.sleep();
  dt.log.i('预期结果5、6、图片可以正常进入退出大图');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、从相机入口进入大图页面重复上述操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库窗口最大化 end');
}

/**
 * 大图-进入大图: [Esc返回上级界面]
 * GROUP: 大图 MODULE: 进入大图TID: Multimedia_Gallery_PC_PAD_Differentiation_017
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_017(dt: Dt) {
  dt.log.i('Esc返回上级界面 start');
  dt.log.i('STEP 1、图库窗口放大到最大化');

  await dt.sleep();
  dt.log.i('STEP 2、点击esc按钮');

  await dt.sleep();
  dt.log.i('预期结果2、图库窗口恢复到正常大小4、返回到宫格页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在图库中进入大图浏览');

  await dt.sleep();
  dt.log.i('STEP 4、点击esc按钮');

  await dt.sleep();
  dt.log.i('预期结果4、返回到宫格页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('Esc返回上级界面 end');
}

/**
 * 大图-进入大图: [图库窗口移动]
 * GROUP: 大图 MODULE: 进入大图TID: Multimedia_Gallery_PC_PAD_Differentiation_018
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_018(dt: Dt) {
  dt.log.i('图库窗口移动 start');
  dt.log.i('STEP 1、打开图库应用');

  await dt.sleep();
  dt.log.i('STEP 2、点击窗口上侧不松手移动鼠标');

  await dt.sleep();
  dt.log.i('预期结果2、图库窗口跟随鼠标进行移动4、图库窗口跟随鼠标进行移动5、图库窗口跟随鼠标进行移动');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在图库中进入大图浏览');

  await dt.sleep();
  dt.log.i('STEP 4、点击窗口上侧不松手移动鼠标');

  await dt.sleep();
  dt.log.i('预期结果4、图库窗口跟随鼠标进行移动');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、从相机入口进入大图重复上述操作');

  await dt.sleep();
  dt.log.i('预期结果5、图库窗口跟随鼠标进行移动');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库窗口移动 end');
}

/**
 * 大图-收藏: [系统相册宫格右键菜单]
 * GROUP: 大图 MODULE: 收藏TID: Multimedia_Gallery_PC_PAD_Differentiation_019
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_019(dt: Dt) {
  dt.log.i('系统相册宫格右键菜单 start');
  dt.log.i('STEP 1、在预制相册、来源相册宫格页面缩略图点击右键');

  await dt.sleep();
  dt.log.i('预期结果1、菜单显示多选、分享1项、添加1项到相册、复制1项、收藏/取消收藏1项、隐藏1项、打印1项、删除1项');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在预制相册、来源相册宫格页面多选后点击右键');

  await dt.sleep();
  dt.log.i('预期结果2、菜单显示多选、分享n项、对比n项、使用n项拼图、添加n项到相册、复制n项、收藏/取消收藏n项、隐藏n项、打印n项、删除n项');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在预制相册、来源相册宫格页面多选后右上角的更多按钮');

  await dt.sleep();
  dt.log.i('预期结果3、菜单显示添加到、复制、收藏、隐藏、打印ps：视频相册不含有对比，拼图，打印');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('系统相册宫格右键菜单 end');
}

/**
 * 大图-收藏: [用户创建相册宫格右键菜单]
 * GROUP: 大图 MODULE: 收藏TID: Multimedia_Gallery_PC_PAD_Differentiation_020
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_020(dt: Dt) {
  dt.log.i('用户创建相册宫格右键菜单 start');
  dt.log.i('STEP 1、在用户创建相册宫格页面缩略图点击右键');

  await dt.sleep();
  dt.log.i('预期结果1、菜单显示多选、分享1项、添加1项到相册、复制1项、收藏/取消收藏1项、隐藏1项、打印1项、移出相册、删除1项');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在用户创建相册宫格页面直接多选后点击右键');

  await dt.sleep();
  dt.log.i('预期结果2、菜单显示多选、分享n项、对比n项、使用n项拼图、添加n项到相册、复制n项、收藏/取消收藏n项、隐藏n项、打印n项、从相册移出n项、删除n项');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在用户创建相册宫格页面进入多选后，选中几张图片，点击右上角的更多按钮');

  await dt.sleep();
  dt.log.i('预期结果3、菜单显示添加到、复制、收藏、隐藏、移出相册、打印ps：含有视频时不显示打印');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户创建相册宫格右键菜单 end');
}

/**
 * 大图-收藏: [隐藏相册宫格右键菜单]
 * GROUP: 大图 MODULE: 收藏TID: Multimedia_Gallery_PC_PAD_Differentiation_021
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_021(dt: Dt) {
  dt.log.i('隐藏相册宫格右键菜单 start');
  dt.log.i('STEP 1、在隐藏相册图片宫格页面缩略图点击右键');

  await dt.sleep();
  dt.log.i('预期结果1、菜单显示多选、复制1项、收藏/取消收藏1项、取消隐藏1项、打印1项、删除1项');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在隐藏相册图片宫格页面直接多选后点击右键');

  await dt.sleep();
  dt.log.i('预期结果2、菜单显示多选、对比n项、使用n项拼图、复制n项、收藏/取消收藏n项、取消隐藏n项、打印n项、删除n项');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在隐藏相册图片宫格页面进入多选后，选中几张图片，点击右上角的更多按钮');

  await dt.sleep();
  dt.log.i('预期结果3、菜单显示复制、收藏、取消隐藏');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、在隐藏相册相册宫格页面相册缩略图点击右键');

  await dt.sleep();
  dt.log.i('预期结果4、菜单显示多选、取消隐藏、删除');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、在隐藏相册相册宫格页面相册直接多选后点击右键');

  await dt.sleep();
  dt.log.i('预期结果5、菜单显示取消隐藏、删除ps：含有视频时不显示打印');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册宫格右键菜单 end');
}

/**
 * 大图-删除: [最近删除相册宫格右键菜单]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_PAD_Differentiation_022
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_022(dt: Dt) {
  dt.log.i('最近删除相册宫格右键菜单 start');
  dt.log.i('STEP 1、在最近删除相册宫格页面缩略图点击右键');

  await dt.sleep();
  dt.log.i('预期结果1、菜单显示多选、恢复1项、删除1项');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在最近删除相册宫格页面直接多选后点击右键');

  await dt.sleep();
  dt.log.i('预期结果2、菜单显示多选、恢复n项、删除n项');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除相册宫格右键菜单 end');
}

/**
 * 大图-收藏: [智慧相册宫格右键菜单]
 * GROUP: 大图 MODULE: 收藏TID: Multimedia_Gallery_PC_PAD_Differentiation_023
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_023(dt: Dt) {
  dt.log.i('智慧相册宫格右键菜单 start');
  dt.log.i('STEP 1、在人像、分类相册宫格页面缩略图点击右键');

  await dt.sleep();
  dt.log.i('预期结果1、菜单显示多选、分享1项、添加1项到相册、复制1项、收藏/取消收藏1项、隐藏1项、打印1项、移出相册、删除1项');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在人像、分类相册宫格页面直接多选后点击右键');

  await dt.sleep();
  dt.log.i('预期结果2、菜单显示多选、分享n项、对比n项、使用n项拼图、添加n项到相册、复制n项、收藏/取消收藏n项、隐藏n项、打印n项、从相册移出n项、删除n项');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在人像、分类相册宫格页面进入多选后，选中几张图片，点击右上角的更多按钮');

  await dt.sleep();
  dt.log.i('预期结果3、菜单显示添加到、复制、收藏、隐藏、移出相册、打印');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧相册宫格右键菜单 end');
}

/**
 * 大图-大图: [系统相册大图页面右键菜单]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_PAD_Differentiation_024
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_024(dt: Dt) {
  dt.log.i('系统相册大图页面右键菜单 start');
  dt.log.i('STEP 1、在预制相册、来源相册进入图片大图点击右键');

  await dt.sleep();
  dt.log.i('预期结果1、菜单显示分享、添加到、收藏/取消收藏、复制、编辑、删除、隐藏、打印、重命名、播放/暂停（视频大图特有）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在预制相册、来源相册进入图片大图查看，点击更多按钮');

  await dt.sleep();
  dt.log.i('预期结果2、菜单显示分享、收藏、编辑、删除、更多（添加到、复制、隐藏、打印、重命名）、详情');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在用户创建相册进入图片大图点击右键');

  await dt.sleep();
  dt.log.i('预期结果3、菜单显示分享、添加到、收藏/取消收藏、复制、编辑、删除、隐藏、打印、重命名、移出相册、播放/暂停（视频大图特有）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、在用户创建相册进入图片大图查看，点击更多按钮');

  await dt.sleep();
  dt.log.i('预期结果4、菜单显示分享、收藏、编辑、删除、更多（添加到、复制、隐藏、移出相册、打印、重命名）、详情');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('系统相册大图页面右键菜单 end');
}

/**
 * 大图-删除: [隐藏删除相册大图页面右键菜单]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_PAD_Differentiation_025
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_025(dt: Dt) {
  dt.log.i('隐藏删除相册大图页面右键菜单 start');
  dt.log.i('STEP 1、在隐藏相册进入图片大图点击右键');

  await dt.sleep();
  dt.log.i('预期结果1、菜单显示收藏/取消收藏、复制、编辑、删除、取消隐藏、播放/暂停（视频大图特有）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在隐藏相册进入图片大图查看，点击更多按钮');

  await dt.sleep();
  dt.log.i('预期结果2、菜单显示收藏、编辑、更多（复制、取消隐藏）、详情');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在最近删除相册进入图片大图点击右键');

  await dt.sleep();
  dt.log.i('预期结果3、菜单显示恢复、删除、播放/暂停（视频大图特有）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、在最近删除相册进入图片大图查看');

  await dt.sleep();
  dt.log.i('预期结果4、菜单显示恢复、删除、详情');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏删除相册大图页面右键菜单 end');
}

/**
 * 大图-大图: [智慧相册大图页面右键菜单]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_PAD_Differentiation_026
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_026(dt: Dt) {
  dt.log.i('智慧相册大图页面右键菜单 start');
  dt.log.i('STEP 1、在人像相册进入图片大图点击右键');

  await dt.sleep();
  dt.log.i('预期结果1、菜单显示分享、添加到、收藏/取消收藏、复制、编辑、删除、隐藏、打印、移出相册、重命名、设置为封面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在人像相册进入图片大图查看，点击更多按钮');

  await dt.sleep();
  dt.log.i('预期结果2、菜单显示分享、收藏、编辑、删除、更多（添加到、复制、隐藏、打印、移出相册、 重命名、设置为封面）、详情');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在分类相册进入图片大图点击右键');

  await dt.sleep();
  dt.log.i('预期结果3、菜单显示分享、添加到、收藏/取消收藏、复制、编辑、删除、隐藏、打印、移出相册、重命名');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、在分类相册进入图片大图查看，点击点击更多按钮');

  await dt.sleep();
  dt.log.i('预期结果4、菜单显示分享、收藏、编辑、删除、更多（添加到、复制、隐藏、打印、移出相册、重命名）、详情');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧相册大图页面右键菜单 end');
}

/**
 * 大图-删除: [用户创建相册右键菜单]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_PAD_Differentiation_027
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_027(dt: Dt) {
  dt.log.i('用户创建相册右键菜单 start');
  dt.log.i('STEP 1、在侧边栏用户创建相册点击右键');

  await dt.sleep();
  dt.log.i('预期结果1、菜单显示重命名相册、删除相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击重命相册');

  await dt.sleep();
  dt.log.i('预期结果2、可以正常修改相册名称');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击删除相册');

  await dt.sleep();
  dt.log.i('预期结果3、可以正常删除相册');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户创建相册右键菜单 end');
}

/**
 * 大图-视频: [PC/PAD侧边栏适配]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_PAD_Differentiation_028
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_028(dt: Dt) {
  dt.log.i('PC/PAD侧边栏适配 start');
  dt.log.i('STEP 1、图库中相册显示在侧边栏');

  await dt.sleep();
  dt.log.i('STEP 2、点击想要查看的相册');

  await dt.sleep();
  dt.log.i('预期结果2、右侧展开该相册的图片宫格页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、频繁切换左侧相册');

  await dt.sleep();
  dt.log.i('预期结果3、右侧宫格内容正常切换5、右侧宫格内容正常切换');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、切换到空白相册');

  await dt.sleep();
  dt.log.i('STEP 5、再次点击其他有图片的相册');

  await dt.sleep();
  dt.log.i('预期结果5、右侧宫格内容正常切换');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC/PAD侧边栏适配 end');
}

/**
 * 大图-视频: [创建新相册]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_PAD_Differentiation_029
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_029(dt: Dt) {
  dt.log.i('创建新相册 start');
  dt.log.i('STEP 1、点击图库侧边栏的“新建相册”按钮');

  await dt.sleep();
  dt.log.i('预期结果1、成功完成相册的创建，显示刚创建的空相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、输入想要设置的相册名称');

  await dt.sleep();
  dt.log.i('STEP 3、点击键盘的enter键');

  await dt.sleep();
  dt.log.i('STEP 4、鼠标点击其他空白位置');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('创建新相册 end');
}

/**
 * 大图-拖拽: [相册宫格拖拽图片]
 * GROUP: 大图 MODULE: 拖拽TID: Multimedia_Gallery_PC_PAD_Differentiation_030
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_030(dt: Dt) {
  dt.log.i('相册宫格拖拽图片 start');
  dt.log.i('STEP 1、在图库左侧点击选中某一相册');

  await dt.sleep();
  dt.log.i('预期结果1、可正常拖拽图片到新相册中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、选中相册中的图片');

  await dt.sleep();
  dt.log.i('STEP 3、拖拽到左侧其他用户创建相册中');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册宫格拖拽图片 end');
}

/**
 * 大图-拖拽: [用户创建相册拖拽排序]
 * GROUP: 大图 MODULE: 拖拽TID: Multimedia_Gallery_PC_PAD_Differentiation_031
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_031(dt: Dt) {
  dt.log.i('用户创建相册拖拽排序 start');
  dt.log.i('STEP 1、在图库左侧点击选中某一相册');

  await dt.sleep();
  dt.log.i('预期结果1、可正常拖拽相册到想要的位置，将相册重新排序');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、拖拽移动相册到想要的位置');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户创建相册拖拽排序 end');
}

/**
 * 大图-拖拽: [PC宫格多选拖拽到用户创建相册]
 * GROUP: 大图 MODULE: 拖拽TID: Multimedia_Gallery_PC_PAD_Differentiation_032
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_032(dt: Dt) {
  dt.log.i('PC宫格多选拖拽到用户创建相册 start');
  dt.log.i('STEP 1、在宫格页选中多张图片（可通过框选、ctry加shit组合多选）');

  await dt.sleep();
  dt.log.i('预期结果1、图片正常被选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、按住图片拖拽，选中的图片可以聚合在一起');

  await dt.sleep();
  dt.log.i('预期结果2、过程动效顺畅无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、聚合图片跟随鼠标移动至用户创建相册');

  await dt.sleep();
  dt.log.i('预期结果3、选中图片被添加到用户创建相册中，侧边栏相册中的图片数量正常刷新');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC宫格多选拖拽到用户创建相册 end');
}

/**
 * 大图-拖拽: [PC单张图片拖拽]
 * GROUP: 大图 MODULE: 拖拽TID: Multimedia_Gallery_PC_PAD_Differentiation_033
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_033(dt: Dt) {
  dt.log.i('PC单张图片拖拽 start');
  dt.log.i('STEP 1、在宫格选中一张图片');

  await dt.sleep();
  dt.log.i('预期结果1、图片被正常选中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、鼠标点击按住图片进行拖拽');

  await dt.sleep();
  dt.log.i('预期结果2、图片跟随鼠标进行移动');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、将图片拖拽至用户创建相册');

  await dt.sleep();
  dt.log.i('预期结果3、选中图片被添加到用户创建相册中，侧边栏相册中的图片数量正常刷新');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC单张图片拖拽 end');
}

/**
 * 大图-删除: [删除图片侧边栏数量刷新]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_PAD_Differentiation_035
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_035(dt: Dt) {
  dt.log.i('删除图片侧边栏数量刷新 start');
  dt.log.i('STEP 1、在图片与视频相册宫格页面选中多张（例如四张）图片进行删除');

  await dt.sleep();
  dt.log.i('预期结果1、图片与视频相册侧边栏图片数量减去相应的数值（例如4），最近删除图片数量加上相应的数值（例如4）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在最近删除相册中清空删除图片');

  await dt.sleep();
  dt.log.i('预期结果2、侧边栏最近删除相册图片数量刷新为0');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、重复操作10次');

  await dt.sleep();
  dt.log.i('预期结果3、重复操作过程中图片数量正常刷新');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('删除图片侧边栏数量刷新 end');
}

/**
 * 大图-视频: [隐藏图片侧边栏数量刷新]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_PAD_Differentiation_036
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_036(dt: Dt) {
  dt.log.i('隐藏图片侧边栏数量刷新 start');
  dt.log.i('STEP 1、在图片与视频相册宫格页面选中多张（例如四张）图片进行隐藏');

  await dt.sleep();
  dt.log.i('预期结果1、图片与视频相册侧边栏图片数量减去相应的数值（例如4），隐藏相册中图片数量加上相应的数值（例如4）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、重复操作10次');

  await dt.sleep();
  dt.log.i('预期结果2、重复操作过程中图片数量正常刷新');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏图片侧边栏数量刷新 end');
}

/**
 * 大图-深色: [图库适配深色模式]
 * GROUP: 大图 MODULE: 深色TID: Multimedia_Gallery_PC_PAD_Differentiation_037
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_037(dt: Dt) {
  dt.log.i('图库适配深色模式 start');
  dt.log.i('STEP 1、设置/显示和亮度/深色模式，把深色模式开关打开');

  await dt.sleep();
  dt.log.i('预期结果1、图库页面正常切换到深色模式');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、打开图库查看');

  await dt.sleep();
  dt.log.i('STEP 3、保持图库打开状态，在设置页面切换深色模式');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库适配深色模式 end');
}

/**
 * 大图-视频: [图库适配多语言]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_PAD_Differentiation_038
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_038(dt: Dt) {
  dt.log.i('图库适配多语言 start');
  dt.log.i('STEP 1、在设置/系统/语言和地区页面设置不同的语言，例如简体中文、繁体中午、英文、维吾尔文、藏文');

  await dt.sleep();
  dt.log.i('预期结果1、图库页面语言正常刷新（其中维吾尔文镜像显示）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、打开图库查看');

  await dt.sleep();
  dt.log.i('STEP 3、保持图库打开状态，在设置页面切换语言');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库适配多语言 end');
}

/**
 * 大图-视频: [tap键走焦]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_PAD_Differentiation_039
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_039(dt: Dt) {
  dt.log.i('tap键走焦 start');
  dt.log.i('STEP 1、打开图库应用，点击tap键入焦');

  await dt.sleep();
  dt.log.i('预期结果1、焦点首先显示在侧边栏，可点击方向键走焦');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、继续点击tap键走焦');

  await dt.sleep();
  dt.log.i('预期结果2、焦点切换到宫格上方按钮，可点击方向键走焦');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、继续点击tap键走焦');

  await dt.sleep();
  dt.log.i('预期结果3、焦点切换到宫格上，可点击方向键走焦');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('tap键走焦 end');
}

/**
 * 大图-视频: [PC宫格走焦]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_PAD_Differentiation_040
 * 前置条件
 * 1、图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_PAD_Differentiation_040(dt: Dt) {
  dt.log.i('PC宫格走焦 start');
  dt.log.i('STEP 1、宫格图片点击选中');

  await dt.sleep();
  dt.log.i('预期结果1、选中图片获得焦点');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击方向键走焦');

  await dt.sleep();
  dt.log.i('预期结果2、宫格页面正常走焦');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、走焦到最右侧图片后，再次点击方向右键走焦');

  await dt.sleep();
  dt.log.i('预期结果3、焦点切换到下一行的最左侧第一个图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC宫格走焦 end');
}



