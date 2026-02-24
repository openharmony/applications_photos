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

export default function MultimediaGalleryAlbumStyle(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryAlbumStyleTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryAlbumStyle').init();
      dt.log.i('beforeAll MultimediaGalleryAlbumStyle start');
      dt.log.i('beforeAll MultimediaGalleryAlbumStyle finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryAlbumStyle', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryAlbumsUXcheck0008', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [相机、截图、屏幕录制相册PC布局显示验证] TID: Multimedia_Gallery_Albums_UX_check_0008
      await multimediaGalleryAlbumsUXcheck0008(dt);
    });
    run('MultimediaGalleryAlbumStyle001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-滑动用例: [验证相册页双指捏合切换相册风格] TID: Multimedia_Gallery_AlbumStyle_001
      await multimediaGalleryAlbumStyle001(dt);
    });
    run('MultimediaGalleryAlbumStyle002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [验证相册页双指捏合切换相册风格（包括智慧相册）] TID: Multimedia_Gallery_AlbumStyle_002
      await multimediaGalleryAlbumStyle002(dt);
    });
    run('MultimediaGalleryAlbumStyle003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [验证相册页双指捏合不可切换相册风格（包含来源相册和更多相册）] TID: Multimedia_Gallery_AlbumStyle_003
      await multimediaGalleryAlbumStyle003(dt);
    });
    run('MultimediaGalleryAlbumStyle004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [验证PC端可以切换相册风格] TID: Multimedia_Gallery_AlbumStyle_004
      await multimediaGalleryAlbumStyle004(dt);
    });
    run('MultimediaGalleryAlbumStyle005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [验证PC端不可切换相册风格（包含来源相册和更多相册）] TID: Multimedia_Gallery_AlbumStyle_005
      await multimediaGalleryAlbumStyle005(dt);
    });
    run('MultimediaGalleryAlbumStyle006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [验证相册切换切换时的动效为geometryTransition] TID: Multimedia_Gallery_AlbumStyle_006
      await multimediaGalleryAlbumStyle006(dt);
    });
    run('MultimediaGalleryAlbumStyle007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [验证风格切换后缩略图同时切换] TID: Multimedia_Gallery_AlbumStyle_007
      await multimediaGalleryAlbumStyle007(dt);
    });
    run('MultimediaGalleryAlbumStyle008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [验证大/小宫格风格一行显示正确相册个数] TID: Multimedia_Gallery_AlbumStyle_008
      await multimediaGalleryAlbumStyle008(dt);
    });
    run('MultimediaGalleryAlbumStyle009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [验证切换多次大/小宫格风格切换可持久化] TID: Multimedia_Gallery_AlbumStyle_009
      await multimediaGalleryAlbumStyle009(dt);
    });
    run('MultimediaGalleryAlbumStyle010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [新建相册后大/小宫格风格切换] TID: Multimedia_Gallery_AlbumStyle_010
      await multimediaGalleryAlbumStyle010(dt);
    });
    run('MultimediaGalleryAlbumStyle011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [删除相册后大/小宫格风格切换] TID: Multimedia_Gallery_AlbumStyle_011
      await multimediaGalleryAlbumStyle011(dt);
    });
    run('MultimediaGalleryAlbumStyle012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [验证切换多次大/小宫格风格稳定切换] TID: Multimedia_Gallery_AlbumStyle_012
      await multimediaGalleryAlbumStyle012(dt);
    });
    run('MultimediaGalleryanalysistime001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [智慧分析服务1K模型索引构建完成时长] TID: Multimedia_Gallery_analysis_time_001
      await multimediaGalleryanalysistime001(dt);
    });
    run('MultimediaGalleryanalysistime002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-解析用例: [智慧分析服务1K模型地理解析完成时长] TID: Multimedia_Gallery_analysis_time_002
      await multimediaGalleryanalysistime002(dt);
    });
    run('MultimediaGalleryanalysistime003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [智慧分析服务1K模型时刻分析完成时长] TID: Multimedia_Gallery_analysis_time_003
      await multimediaGalleryanalysistime003(dt);
    });
    run('MultimediaGalleryanalysistime004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [智慧分析服务1K模型CV分析完成时长] TID: Multimedia_Gallery_analysis_time_004
      await multimediaGalleryanalysistime004(dt);
    });
    run('MultimediaGalleryanalysistime005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [智慧分析服务5K模型索引构建完成时长] TID: Multimedia_Gallery_analysis_time_005
      await multimediaGalleryanalysistime005(dt);
    });
    run('MultimediaGalleryanalysistime006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-解析用例: [智慧分析服务5K模型地理解析完成时长] TID: Multimedia_Gallery_analysis_time_006
      await multimediaGalleryanalysistime006(dt);
    });
    run('MultimediaGalleryanalysistime007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [智慧分析服务5K模型时刻分析完成时长] TID: Multimedia_Gallery_analysis_time_007
      await multimediaGalleryanalysistime007(dt);
    });
    run('MultimediaGalleryanalysistime008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [智慧分析服务5K模型CV分析完成时长] TID: Multimedia_Gallery_analysis_time_008
      await multimediaGalleryanalysistime008(dt);
    });
    run('MultimediaGalleryApplicationlock01', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [应用锁下-照片页年月日切换] TID: Multimedia_Gallery_Application_lock_01
      await multimediaGalleryApplicationlock01(dt);
    });
    run('MultimediaGalleryApplicationlock02', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [应用锁下-照片页三宫格切换] TID: Multimedia_Gallery_Application_lock_02
      await multimediaGalleryApplicationlock02(dt);
    });
    run('MultimediaGalleryApplicationlock03', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [应用锁下-相册页基础功能遍历] TID: Multimedia_Gallery_Application_lock_03
      await multimediaGalleryApplicationlock03(dt);
    });
    run('MultimediaGalleryApplicationlock04', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [应用锁下-时刻页基础功能遍历] TID: Multimedia_Gallery_Application_lock_04
      await multimediaGalleryApplicationlock04(dt);
    });
    run('MultimediaGalleryApplicationlock05', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [应用锁下-大图详情页显示] TID: Multimedia_Gallery_Application_lock_05
      await multimediaGalleryApplicationlock05(dt);
    });
    run('MultimediaGalleryApplicationlock06', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [应用锁下-编辑页显示] TID: Multimedia_Gallery_Application_lock_06
      await multimediaGalleryApplicationlock06(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryAlbumStyle').init();
      dt.log.i('afterEach MultimediaGalleryAlbumStyle start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryAlbumStyle finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryAlbumStyle').init();
      dt.log.i('afterAll MultimediaGalleryAlbumStyle start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryAlbumStyle finish');
    });
  });
}

// DT步骤
/**
 * 宫格-收藏: [相机、截图、屏幕录制相册PC布局显示验证]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_UX_check_0008
 * 前置条件
 * 1.xxx测试机图库已预置相机、截图、屏幕录制相册，已预置图片、视频
 注：Harden设备
 */
async function multimediaGalleryAlbumsUXcheck0008(dt: Dt) {
  dt.log.i('相机、截图、屏幕录制相册PC布局显示验证 start');
  dt.log.i('STEP 1.打开图库-检查侧边栏菜单显示');

  await dt.sleep();
  dt.log.i('预期结果1.侧边菜单栏-上侧系统相册区域--按图片、视频、我的收藏、相机、截图、屏幕录制相册顺序展示在列表最前，显示无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机、截图、屏幕录制相册PC布局显示验证 end');
}

/**
 * 宫格-滑动: [验证相册页双指捏合切换相册风格]
 * GROUP: 宫格 MODULE: 滑动TID: Multimedia_Gallery_AlbumStyle_001
 * 前置条件
 * 1、图库中存在不同来源的相册，包括预制相册、用户创建相册、智慧相册等
 */
async function multimediaGalleryAlbumStyle001(dt: Dt) {
  dt.log.i('验证相册页双指捏合切换相册风格 start');
  dt.log.i('STEP 1、打开图库-相册，双指捏合缩放切换界面');

  await dt.sleep();
  dt.log.i('预期结果1、成功切换相册风格（小宫格风格/大宫格风格）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、再次双指捏合缩放切换界面');

  await dt.sleep();
  dt.log.i('预期结果2、再次成功切换相册风格（小宫格风格/大宫格风格）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在相册页最上方进行风格切换');

  await dt.sleep();
  dt.log.i('预期结果3、预制相册、用户创建相册、智慧相册都有风格切换动效，动效切换正常，无闪白');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、滑动到相册页最下方立即风格切换（默认验证手机，xxx，平板）');

  await dt.sleep();
  dt.log.i('预期结果4、预制相册、用户创建相册、智慧相册都有风格切换动效，动效切换正常，无闪白');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('验证相册页双指捏合切换相册风格 end');
}

/**
 * 宫格-: [验证相册页双指捏合切换相册风格（包括智慧相册）]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_AlbumStyle_002
 * 前置条件
 * 1、图库中存在不同来源的相册，包括预制相册、用户创建相册、智慧相册等
 */
async function multimediaGalleryAlbumStyle002(dt: Dt) {
  dt.log.i('验证相册页双指捏合切换相册风格（包括智慧相册） start');
  dt.log.i('STEP 1、打开图库-相册');

  await dt.sleep();
  dt.log.i('STEP 2、双指捏合缩放切换界面（默认验证手机，xxx，平板）');

  await dt.sleep();
  dt.log.i('预期结果2、预制相册、用户创建相册，包括智慧分类相册均可成功切换相册风格（小宫格风格/大宫格风格）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('验证相册页双指捏合切换相册风格（包括智慧相册） end');
}

/**
 * 宫格-删除: [验证相册页双指捏合不可切换相册风格（包含来源相册和更多相册）]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_AlbumStyle_003
 * 前置条件
 * 1、图库中存在不同来源的相册，包括预制相册、用户创建相册、智慧相册\来源相册和更多相册等
 */
async function multimediaGalleryAlbumStyle003(dt: Dt) {
  dt.log.i('验证相册页双指捏合不可切换相册风格（包含来源相册和更多相册） start');
  dt.log.i('STEP 1、打开图库-相册');

  await dt.sleep();
  dt.log.i('STEP 2、双指捏合缩放切换界面（默认验证手机，xxx，平板）');

  await dt.sleep();
  dt.log.i('预期结果2、采用列表形式呈现的相册（包含来自应用的相册，隐藏相册，最近删除相册等）不切换相册风格');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('验证相册页双指捏合不可切换相册风格（包含来源相册和更多相册） end');
}

/**
 * 宫格-: [验证PC端可以切换相册风格]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_AlbumStyle_004
 * 前置条件
 * 1、图库中存在不同来源的相册，包括预制相册、用户创建相册、智慧相册等
 */
async function multimediaGalleryAlbumStyle004(dt: Dt) {
  dt.log.i('验证PC端可以切换相册风格 start');
  dt.log.i('STEP 1、连接PC');

  await dt.sleep();
  dt.log.i('STEP 2、进入图库-相册，按ctlr键+“+/-”键');

  await dt.sleep();
  dt.log.i('预期结果2、成功切换相册风格（小宫格风格/大宫格风格）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入图库-相册，按ctlr键+鼠标滚轮');

  await dt.sleep();
  dt.log.i('预期结果3、成功切换相册风格（小宫格风格/大宫格风格）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、触摸板双指捏合切换界面');

  await dt.sleep();
  dt.log.i('预期结果4、成功切换相册风格（小宫格风格/大宫格风格）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('验证PC端可以切换相册风格 end');
}

/**
 * 宫格-格式: [验证PC端不可切换相册风格（包含来源相册和更多相册）]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_AlbumStyle_005
 * 前置条件
 * 1、图库中存在不同来源的相册，包括预制相册、用户创建相册、智慧相册\来源相册和更多相册等
 2、图库中存在不同格式的照片和视频文件
 3，云图库中存在不同格式的照片和视频文件
 */
async function multimediaGalleryAlbumStyle005(dt: Dt) {
  dt.log.i('验证PC端不可切换相册风格（包含来源相册和更多相册） start');
  dt.log.i('STEP 1、连接PC');

  await dt.sleep();
  dt.log.i('STEP 2、进入图库-相册，按ctlr键+“+/-”键');

  await dt.sleep();
  dt.log.i('预期结果2、采用列表形式呈现的相册（包含来自应用的相册，隐藏相册，最近删除相册等）不切换相册风格');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入图库-相册，按ctlr键+鼠标滚轮');

  await dt.sleep();
  dt.log.i('预期结果3、采用列表形式呈现的相册（包含来自应用的相册，隐藏相册，最近删除相册等）不切换相册风格');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、触摸板双指捏合切换界面');

  await dt.sleep();
  dt.log.i('预期结果4、采用列表形式呈现的相册（包含来自应用的相册，隐藏相册，最近删除相册等）不切换相册风格');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('验证PC端不可切换相册风格（包含来源相册和更多相册） end');
}

/**
 * 宫格-格式: [验证相册切换切换时的动效为geometryTransition]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_AlbumStyle_006
 * 前置条件
 * 1、图库中存在不同来源的相册，包括预制相册、用户创建相册、智慧相册等
 2、图库中存在不同格式的照片和视频文件
 3，云图库中存在不同格式的照片和视频文件
 */
async function multimediaGalleryAlbumStyle006(dt: Dt) {
  dt.log.i('验证相册切换切换时的动效为geometryTransition start');
  dt.log.i('STEP 1、打开图库-相册');

  await dt.sleep();
  dt.log.i('STEP 2、双指捏合缩放切换界面（默认验证手机，xxx，平板，PC）');

  await dt.sleep();
  dt.log.i('预期结果2、相册风格切换时，相册宫格支持共享元素动效（geometryTransition）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('验证相册切换切换时的动效为geometryTransition end');
}

/**
 * 宫格-格式: [验证风格切换后缩略图同时切换]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_AlbumStyle_007
 * 前置条件
 * 1、图库中存在不同来源的相册，包括预制相册、用户创建相册、智慧相册等
 2、图库中存在不同格式的照片和视频文件
 3，云图库中存在不同格式的照片和视频文件
 */
async function multimediaGalleryAlbumStyle007(dt: Dt) {
  dt.log.i('验证风格切换后缩略图同时切换 start');
  dt.log.i('STEP 1、打开图库-相册');

  await dt.sleep();
  dt.log.i('STEP 2、双指捏合缩放切换界面（默认验证手机，xxx，平板，PC）');

  await dt.sleep();
  dt.log.i('预期结果2、切换相册风格后缩略图跟随风格变化');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('验证风格切换后缩略图同时切换 end');
}

/**
 * 宫格-格式: [验证大/小宫格风格一行显示正确相册个数]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_AlbumStyle_008
 * 前置条件
 * 1、图库中存在不同来源的相册，包括预制相册、用户创建相册、智慧相册等
 2、图库中存在不同格式的照片和视频文件
 3，云图库中存在不同格式的照片和视频文件
 */
async function multimediaGalleryAlbumStyle008(dt: Dt) {
  dt.log.i('验证大/小宫格风格一行显示正确相册个数 start');
  dt.log.i('STEP 1、打开图库-相册');

  await dt.sleep();
  dt.log.i('STEP 2、设置相册宫格数为11个（预制相册、用户创建相册，包括智慧分类相册也设置为4个），双指捏合缩放切换界面');

  await dt.sleep();
  dt.log.i('STEP 3、在手机端双指捏合缩放切换界面');

  await dt.sleep();
  dt.log.i('预期结果3、手机端小宫格风格一行可显示相册个数为3个，大宫格风格一行可显示相册个数为2个');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、在xxx端双指捏合缩放切换界面，保持相册宫格风格进行xxx的xxx和xxx的切换');

  await dt.sleep();
  dt.log.i('预期结果4、xxx端xxx小宫格风格一行可显示相册个数为5个，大宫格风格一行可显示相册个数为4个');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、在平板端双指捏合缩放切换界面');

  await dt.sleep();
  dt.log.i('预期结果5、平板端小宫格风格一行可显示相册个数为8个大宫格风格一行可显示相册个数为7个');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、在PC端双指捏合缩放切换界面');

  await dt.sleep();
  dt.log.i('预期结果6、PC端小宫格风格一行可显示相册个数为10个大宫格风格一行可显示相册个数为9个3、4、5、6，手机端，xxx，平板，PC切换风格前后的相册数量、排序顺序不变');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('验证大/小宫格风格一行显示正确相册个数 end');
}

/**
 * 宫格-: [验证切换多次大/小宫格风格切换可持久化]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_AlbumStyle_009
 * 前置条件
 * 1、图库中存在不同来源的相册，包括预制相册、用户创建相册、智慧相册等
 */
async function multimediaGalleryAlbumStyle009(dt: Dt) {
  dt.log.i('验证切换多次大/小宫格风格切换可持久化 start');
  dt.log.i('STEP 1、打开图库-相册');

  await dt.sleep();
  dt.log.i('STEP 2、双指捏合缩放切换界面，后台退出图库app重新进入图库');

  await dt.sleep();
  dt.log.i('预期结果2、后台退出app重新进入图库后，大小风格显示为切换后的风格');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、双指捏合缩放切换界面，重启手机/平板后重新进入图库app');

  await dt.sleep();
  dt.log.i('预期结果3、重启手机/平板后，大小风格显示为切换后的风格');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('验证切换多次大/小宫格风格切换可持久化 end');
}

/**
 * 宫格-: [新建相册后大/小宫格风格切换]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_AlbumStyle_010
 * 前置条件
 * 1、图库中存在不同来源的相册，包括预制相册、智慧相册等
 */
async function multimediaGalleryAlbumStyle010(dt: Dt) {
  dt.log.i('新建相册后大/小宫格风格切换 start');
  dt.log.i('STEP 1、打开图库-相册');

  await dt.sleep();
  dt.log.i('STEP 2、创建2个相册，双指捏合缩放切换界面');

  await dt.sleep();
  dt.log.i('预期结果2、成功切换相册风格（小宫格风格/大宫格风格）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次双指捏合缩放切换界面（默认验证手机，xxx，平板，PC）');

  await dt.sleep();
  dt.log.i('预期结果3、再次成功切换相册风格（小宫格风格/大宫格风格）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('新建相册后大/小宫格风格切换 end');
}

/**
 * 宫格-删除: [删除相册后大/小宫格风格切换]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_AlbumStyle_011
 * 前置条件
 * 1、图库中存在不同来源的相册，包括预制相册、用户创建相册、智慧相册等
 */
async function multimediaGalleryAlbumStyle011(dt: Dt) {
  dt.log.i('删除相册后大/小宫格风格切换 start');
  dt.log.i('STEP 1、打开图库-相册');

  await dt.sleep();
  dt.log.i('STEP 2、删除2个相册，双指捏合缩放切换界面');

  await dt.sleep();
  dt.log.i('预期结果2、成功切换相册风格（小宫格风格/大宫格风格）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次双指捏合缩放切换界面（默认验证手机，xxx，平板，PC）');

  await dt.sleep();
  dt.log.i('预期结果3、再次成功切换相册风格（小宫格风格/大宫格风格）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('删除相册后大/小宫格风格切换 end');
}

/**
 * 宫格-: [验证切换多次大/小宫格风格稳定切换]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_AlbumStyle_012
 * 前置条件
 * 1、图库中存在不同来源的相册，系统相册，三方相册 ，用户手动创建相册等

 */
async function multimediaGalleryAlbumStyle012(dt: Dt) {
  dt.log.i('验证切换多次大/小宫格风格稳定切换 start');
  dt.log.i('STEP 1、打开图库-相册');

  await dt.sleep();
  dt.log.i('STEP 2、双指捏合缩放切换界面');

  await dt.sleep();
  dt.log.i('预期结果2、大/小宫格风格可正常切换风格');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、重复第二步10次（默认验证手机，xxx，平板，PC）');

  await dt.sleep();
  dt.log.i('预期结果3、可稳定正常切换风格');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('验证切换多次大/小宫格风格稳定切换 end');
}

/**
 * 宫格-: [智慧分析服务1K模型索引构建完成时长]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_analysis_time_001
 * 前置条件
 * 1.手机电量大于50%，手机温度小于37℃
 2.图片相册预置1K测试资源：资源取模型数据：1K标准数据集：
 */
async function multimediaGalleryanalysistime001(dt: Dt) {
  dt.log.i('智慧分析服务1K模型索引构建完成时长 start');
  dt.log.i('STEP 1、充电灭屏，待智慧分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、导出日志和拉取数据库；以日志关键字“doIndexOperation”作为起始时间，以“doIndexOperation end.”作为截止时间计算每一次循环的构建时间，所有循环求和后结果作为索引构建基线值');

  await dt.sleep();
  dt.log.i('预期结果2、基线值定义：索引构建完成时长46s');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧分析服务1K模型索引构建完成时长 end');
}

/**
 * 宫格-解析: [智慧分析服务1K模型地理解析完成时长]
 * GROUP: 宫格 MODULE: 解析TID: Multimedia_Gallery_analysis_time_002
 * 前置条件
 * 1.手机电量大于50%，手机温度小于37℃
 2.图片相册预置1K测试资源：资源取模型数据：1K标准数据集：
 */
async function multimediaGalleryanalysistime002(dt: Dt) {
  dt.log.i('智慧分析服务1K模型地理解析完成时长 start');
  dt.log.i('STEP 1、充电灭屏，待智慧分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、导出日志和拉取数据库；以日志关键字“BatchLocationJob begin”作为起始时间，以“LocationJob Stop”作为截止时间计算每一次循环的构建时间，所有循环求和后结果作为地理解析基线值');

  await dt.sleep();
  dt.log.i('预期结果2、基线值定义：地理解析完成时长2分钟');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧分析服务1K模型地理解析完成时长 end');
}

/**
 * 宫格-: [智慧分析服务1K模型时刻分析完成时长]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_analysis_time_003
 * 前置条件
 * 1.手机电量大于50%，手机温度小于37℃
 2.图片相册预置1K测试资源：资源取模型数据：1K标准数据集：
 */
async function multimediaGalleryanalysistime003(dt: Dt) {
  dt.log.i('智慧分析服务1K模型时刻分析完成时长 start');
  dt.log.i('STEP 1、充电灭屏，待智慧分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、导出日志和拉取数据库；以日志关键字：时刻开始，totalAnalysisStatus of photo distribution可作为时刻开始标志，时刻开始时会打印媒体分析状态，allPicCount手机照片数，allPicCanAnaCount表示手机照片生成LCD图数量，allPicCountInCamera相机照片数，totalAnalysisStatus of CvAnalysisProcess各CV算法分析的照片数；时刻结束：看到StartLocationService!打印，则标志着时刻流程已经结束。');

  await dt.sleep();
  dt.log.i('预期结果2、基线值定义：时刻分析完成时长：19分钟');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧分析服务1K模型时刻分析完成时长 end');
}

/**
 * 宫格-: [智慧分析服务1K模型CV分析完成时长]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_analysis_time_004
 * 前置条件
 * 1.手机电量大于50%，手机温度小于37℃
 2.图片相册预置1K测试资源：资源取模型数据：1K标准数据集：
 */
async function multimediaGalleryanalysistime004(dt: Dt) {
  dt.log.i('智慧分析服务1K模型CV分析完成时长 start');
  dt.log.i('STEP 1、充电灭屏，待智慧分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、导出日志和拉取数据库；以日志关键字“ClearDiryData start”作为起始时间，以“[vision_job_executor.cpp(Finish):296] Finish”作为结束时间，以“No data to be analyzed”作为最后一次循环的结束时间，所有循环求和后结果作为CV分析基线值');

  await dt.sleep();
  dt.log.i('预期结果2、基线值定义：CV分析完成时长：36分钟');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧分析服务1K模型CV分析完成时长 end');
}

/**
 * 宫格-: [智慧分析服务5K模型索引构建完成时长]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_analysis_time_005
 * 前置条件
 * 1.手机电量大于50%，手机温度小于37℃
 2.图片相册预置5K测试资源
 */
async function multimediaGalleryanalysistime005(dt: Dt) {
  dt.log.i('智慧分析服务5K模型索引构建完成时长 start');
  dt.log.i('STEP 1、充电灭屏，待智慧分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、导出日志和拉取数据库；以日志关键字“doIndexOperation”作为起始时间，以“doIndexOperation end.”作为截止时间计算每一次循环的构建时间，所有循环求和后结果作为索引构建基线值');

  await dt.sleep();
  dt.log.i('预期结果2、基线值定义：索引构建完成时长230s');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧分析服务5K模型索引构建完成时长 end');
}

/**
 * 宫格-解析: [智慧分析服务5K模型地理解析完成时长]
 * GROUP: 宫格 MODULE: 解析TID: Multimedia_Gallery_analysis_time_006
 * 前置条件
 * 1.手机电量大于50%，手机温度小于37℃
 2.图片相册预置5K测试资源
 */
async function multimediaGalleryanalysistime006(dt: Dt) {
  dt.log.i('智慧分析服务5K模型地理解析完成时长 start');
  dt.log.i('STEP 1、充电灭屏，待智慧分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、导出日志和拉取数据库；以日志关键字“BatchLocationJob begin”作为起始时间，以“LocationJob Stop”作为截止时间计算每一次循环的构建时间，所有循环求和后结果作为地理解析基线值');

  await dt.sleep();
  dt.log.i('预期结果2、基线值定义：地理解析完成时长10分钟');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧分析服务5K模型地理解析完成时长 end');
}

/**
 * 宫格-: [智慧分析服务5K模型时刻分析完成时长]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_analysis_time_007
 * 前置条件
 * 1.手机电量大于50%，手机温度小于37℃
 2.图片相册预置5K测试资源
 */
async function multimediaGalleryanalysistime007(dt: Dt) {
  dt.log.i('智慧分析服务5K模型时刻分析完成时长 start');
  dt.log.i('STEP 1、充电灭屏，待智慧分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、导出日志和拉取数据库；以日志关键字：时刻开始，totalAnalysisStatus of photo distribution可作为时刻开始标志，时刻开始时会打印媒体分析状态，allPicCount手机照片数，allPicCanAnaCount表示手机照片生成LCD图数量，allPicCountInCamera相机照片数，totalAnalysisStatus of CvAnalysisProcess各CV算法分析的照片数；时刻结束：看到StartLocationService!打印，则标志着时刻流程已经结束。');

  await dt.sleep();
  dt.log.i('预期结果2、基线值定义：时刻分析完成时长：95分钟');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧分析服务5K模型时刻分析完成时长 end');
}

/**
 * 宫格-: [智慧分析服务5K模型CV分析完成时长]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_analysis_time_008
 * 前置条件
 * 1.手机电量大于50%，手机温度小于37℃
 2.图片相册预置5K测试资源
 */
async function multimediaGalleryanalysistime008(dt: Dt) {
  dt.log.i('智慧分析服务5K模型CV分析完成时长 start');
  dt.log.i('STEP 1、充电灭屏，待智慧分析完成');

  await dt.sleep();
  dt.log.i('STEP 2、导出日志和拉取数据库；以日志关键字“ClearDiryData start”作为起始时间，以“[vision_job_executor.cpp(Finish):296] Finish”作为结束时间，以“No data to be analyzed”作为最后一次循环的结束时间，所有循环求和后结果作为CV分析基线值');

  await dt.sleep();
  dt.log.i('预期结果2、基线值定义：CV分析完成时长：180分钟');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧分析服务5K模型CV分析完成时长 end');
}

/**
 * 宫格-应用锁: [应用锁下-照片页年月日切换]
 * GROUP: 宫格 MODULE: 应用锁TID: Multimedia_Gallery_Application_lock_01
 * 前置条件
 * 1、手机设置密码
 2、图库添加应用锁
 3、图库存在历史照片和视频
 */
async function multimediaGalleryApplicationlock01(dt: Dt) {
  dt.log.i('应用锁下-照片页年月日切换 start');
  dt.log.i('STEP 1、打开图库，输入应用锁密码切换到照片页');

  await dt.sleep();
  dt.log.i('STEP 2、设备锁屏后输入密码解锁');

  await dt.sleep();
  dt.log.i('预期结果2、解锁后2s内无需输入应用锁密码，直接进入照片页');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、日视图页面，点击月视图、年视图按钮');

  await dt.sleep();
  dt.log.i('预期结果3、4、5添加应用锁下年月日视图的第一张图片保持一致，根据不同的视图，缩略图等比例放大和缩小，切换不卡顿');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、月视图页面，点击年视图、月视图按钮');

  await dt.sleep();
  dt.log.i('STEP 5、年视图页面，点击月视图、日视图按钮');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁下-照片页年月日切换 end');
}

/**
 * 宫格-应用锁: [应用锁下-照片页三宫格切换]
 * GROUP: 宫格 MODULE: 应用锁TID: Multimedia_Gallery_Application_lock_02
 * 前置条件
 * 1、手机设置密码
 2、图库添加应用锁
 3、图库存在历史照片和视频
 */
async function multimediaGalleryApplicationlock02(dt: Dt) {
  dt.log.i('应用锁下-照片页三宫格切换 start');
  dt.log.i('STEP 1、打开图库，输入应用锁密码切换到照片页日视图三宫格页面');

  await dt.sleep();
  dt.log.i('STEP 2、设备锁屏后输入密码解锁');

  await dt.sleep();
  dt.log.i('预期结果2、解锁后2s内无需输入应用锁密码，直接进入照片页日视图三宫格页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、三宫格双指缩小到四宫格');

  await dt.sleep();
  dt.log.i('预期结果3、4添加应用锁下双指捏合三宫格切换到四宫格视图，缩略图等比例放大和缩小，切换不卡顿');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、四宫格双指放大到三宫格');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁下-照片页三宫格切换 end');
}

/**
 * 宫格-应用锁: [应用锁下-相册页基础功能遍历]
 * GROUP: 宫格 MODULE: 应用锁TID: Multimedia_Gallery_Application_lock_03
 * 前置条件
 * 1、手机设置密码
 2、图库添加应用锁
 3、图库存在历史照片和视频
 4、图库生成智慧相册
 */
async function multimediaGalleryApplicationlock03(dt: Dt) {
  dt.log.i('应用锁下-相册页基础功能遍历 start');
  dt.log.i('STEP 1、打开图库，输入应用锁密码切换到相册页');

  await dt.sleep();
  dt.log.i('STEP 2、设备锁屏后输入密码解锁');

  await dt.sleep();
  dt.log.i('预期结果2、解锁后2s内无需输入应用锁密码直接进入相册页，系统相册、用户自定义相册、智慧相册、来源相册、最近删除相册显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击进入相册（覆盖系统相册、用户自定义相册、智慧相册、来源相册、最近删除相册）');

  await dt.sleep();
  dt.log.i('预期结果3、系统相册、用户自定义相册、智慧相册、来源相册、最近删除宫格页显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁下-相册页基础功能遍历 end');
}

/**
 * 宫格-应用锁: [应用锁下-时刻页基础功能遍历]
 * GROUP: 宫格 MODULE: 应用锁TID: Multimedia_Gallery_Application_lock_04
 * 前置条件
 * 1、手机设置密码
 2、图库添加应用锁
 3、图库存在历史照片和视频
 4、已生成不同种类时刻
 */
async function multimediaGalleryApplicationlock04(dt: Dt) {
  dt.log.i('应用锁下-时刻页基础功能遍历 start');
  dt.log.i('STEP 1、打开图库，输入应用锁密码切换到时刻页');

  await dt.sleep();
  dt.log.i('STEP 2、设备锁屏后输入密码解锁');

  await dt.sleep();
  dt.log.i('预期结果2、解锁后2s内无需输入应用锁密码，直接进入时刻页2.1、标题位置整体放置，根据主体/非主体物选择最佳位置横排或竖排2.2标题和主体物遮挡关系，在重叠5%~15%时主体物对标题进行遮挡，规避人脸2.3、标题根据不同时刻类型对应不同字体，字号2.4、.艺术化封面的标题仅涉及中英文，中英文的字体');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入时刻首页查看轮播视频');

  await dt.sleep();
  dt.log.i('预期结果3、轮播中的图片之间有转场动效，涉及13种转场动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、上划查看艺术化宫格界面');

  await dt.sleep();
  dt.log.i('预期结果4.1、上半部分是轮播界面，充满屏幕轮播该时刻中的图片，有音乐，左上右上两边分别是返回和分享按钮 4.2主题日期艺术字显示在中间位置，无缺失重叠等异常，位置正确不影响上下部分的页面展示4.3 下半部分是艺术化布局界面，拼图形式展示4.4、拼图中的图片数量与轮播中的数量一致');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁下-时刻页基础功能遍历 end');
}

/**
 * 宫格-应用锁: [应用锁下-大图详情页显示]
 * GROUP: 宫格 MODULE: 应用锁TID: Multimedia_Gallery_Application_lock_05
 * 前置条件
 * 1、手机设置密码
 2、图库已添加应用锁
 3、图库存在历史照片和视频
 */
async function multimediaGalleryApplicationlock05(dt: Dt) {
  dt.log.i('应用锁下-大图详情页显示 start');
  dt.log.i('STEP 1、进入图片/视频大图，打开详情页');

  await dt.sleep();
  dt.log.i('STEP 2、设备锁屏后输入密码解锁');

  await dt.sleep();
  dt.log.i('预期结果2、解锁后2s内无需输入应用锁密码，直接显示详情页');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、观察详情最上方显示信息');

  await dt.sleep();
  dt.log.i('预期结果3、显示图片/视频名称、云符号、图片视频拍摄时间、一条横线');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、观察横线下方，直方图上方显示信息');

  await dt.sleep();
  dt.log.i('预期结果4、靠左侧显示图片分辨率（a×b）、大小（a.bMB）、图片拍摄模式（人像等），靠右侧显示拍摄设备、图片格式（JPEG等）/视频格式（MP4等）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、观察直方图下方显示信息');

  await dt.sleep();
  dt.log.i('预期结果5、图片：等距显示ISO（例如ISO 200）、曝光时间（例如1/50 s）、曝光补偿（例如0 ev）、光圈（例如F1.8）,之间用|分割开;视频格式（MP4等）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、观察详情最下方显示信息');

  await dt.sleep();
  dt.log.i('预期结果6、图片:靠左侧显示图片焦距，靠右侧显示对焦方式、白平衡、测光方式、闪光灯/视频：靠左侧显示视频时长（时长：01:20），靠右侧显示HDR Vivid图标');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 7、重复1-6横屏模式下查看');

  await dt.sleep();
  dt.log.i('预期结果7、横屏模式下查看正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 8、重复1-6深色模式下查看');

  await dt.sleep();
  dt.log.i('预期结果8、深色模式下查看正常显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁下-大图详情页显示 end');
}

/**
 * 宫格-应用锁: [应用锁下-编辑页显示]
 * GROUP: 宫格 MODULE: 应用锁TID: Multimedia_Gallery_Application_lock_06
 * 前置条件
 * 1、手机设置密码
 2、图库添加应用锁
 3、从图库-图片，点击编辑进入裁剪页面
 */
async function multimediaGalleryApplicationlock06(dt: Dt) {
  dt.log.i('应用锁下-编辑页显示 start');
  dt.log.i('STEP 1、打开图库，进入编辑页');

  await dt.sleep();
  dt.log.i('STEP 2、设备锁屏后输入密码解锁');

  await dt.sleep();
  dt.log.i('预期结果2、解锁后2s内无需输入应用锁密码，直接进入编辑页4.1 保存进度提示：正在储存图片XX%，进度范围【0~100】4.2 保存成功后，跳转到图库，有动画效果（背景有渐显渐隐动画，预览区有位置下移放大动画）4.3 新保存图片的位置为图库/花瓣剪辑4.4 分辨率与原图片保持一致，裁剪后按裁剪区域大小等比例换算4.5 裁剪、滤镜和调节均能正常保存');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.1、切换到裁剪页面，调节三个方向上的校正效果3.2、设置比例3.3、多次进行90度旋转3.4、设置镜像3.5、双指缩放/单指移动预览窗3.6、调节裁剪边框到任意宽高3.7、切换到调节页面，添加调节参数3.8、切换到滤镜页面，添加滤镜效果（非原片）');

  await dt.sleep();
  dt.log.i('STEP 4、点击保存按钮');

  await dt.sleep();
  dt.log.i('预期结果4.1 保存进度提示：正在储存图片XX%，进度范围【0~100】4.2 保存成功后，跳转到图库，有动画效果（背景有渐显渐隐动画，预览区有位置下移放大动画）4.3 新保存图片的位置为图库/花瓣剪辑4.4 分辨率与原图片保持一致，裁剪后按裁剪区域大小等比例换算4.5 裁剪、滤镜和调节均能正常保存');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁下-编辑页显示 end');
}