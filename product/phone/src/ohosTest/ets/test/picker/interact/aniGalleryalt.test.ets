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

export default function AniGalleryAlt(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('AniGalleryAltTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAniGalleryAlt').init();
      dt.log.i('beforeAll AniGalleryAlt start');
      dt.log.i('beforeAll AniGalleryAlt finish');
    });
    /**
     * 打开大图
     */
    run('beforeAniGalleryAlt', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('aniGalleryalt071025', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [altxxx和xxx切换动效查看] TID: ani_Gallery_alt_071025
      await aniGalleryalt071025(dt);
    });
    run('aniGalleryalt071026', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [altxxx动效查看] TID: ani_Gallery_alt_071026
      await aniGalleryalt071026(dt);
    });
    run('aniGalleryalt071027', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [alt悬停态动效查看] TID: ani_Gallery_alt_071027
      await aniGalleryalt071027(dt);
    });
    run('aniGalleryalt071028', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [altxxx悬停态-横竖屏切换] TID: ani_Gallery_alt_071028
      await aniGalleryalt071028(dt);
    });
    run('aniGallerycontrasts020', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-沉浸用例: [图库沉浸式对比动效检查] TID: ani_Gallery_contrasts_020
      await aniGallerycontrasts020(dt);
    });
    run('aniGalleryAlbumsDragSorting100', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-拖拽用例: [相册拖拽排序动效检查] TID: ani_GalleryAlbumsDragSorting_100
      await aniGalleryAlbumsDragSorting100(dt);
    });
    run('aniGalleryAlbumsMirror002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [不同窗口大小相册动效查看] TID: ani_GalleryAlbumsMirror_002
      await aniGalleryAlbumsMirror002(dt);
    });
    run('aniGalleryAlbumStyle100', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [验证相册风格切换切换时的动效为geometryTransition] TID: ani_GalleryAlbumStyle_100
      await aniGalleryAlbumStyle100(dt);
    });
    run('aniGalleryCommondataUX001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-进入大图用例: [图库不同入口进入大图动效] TID: ani_GalleryCommondataUX_001
      await aniGalleryCommondataUX001(dt);
    });
    run('aniGalleryCommondataUX002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [图库不同入口侧滑退出、下拉退出、back键退出大图动效] TID: ani_GalleryCommondataUX_002
      await aniGalleryCommondataUX002(dt);
    });
    run('aniGalleryCommondataUX003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [图库应用启动和退出，和桌面之间的动效] TID: ani_GalleryCommondataUX_003
      await aniGalleryCommondataUX003(dt);
    });
    run('aniGalleryEditorEffectAI001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [智慧编辑图片智慧扩图完成] TID: ani_GalleryEditorEffect_AI_001
      await aniGalleryEditorEffectAI001(dt);
    });
    run('aniGalleryEditorEffectAI002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [智慧编辑背景编辑] TID: ani_GalleryEditorEffect_AI_002
      await aniGalleryEditorEffectAI002(dt);
    });
    run('aniGalleryEditorEffectAI003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [智慧编辑对象消除] TID: ani_GalleryEditorEffect_AI_003
      await aniGalleryEditorEffectAI003(dt);
    });
    run('aniGalleryFilesrecover004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [图片相册内容删除后，可恢复到图片相册] TID: ani_GalleryFilesrecover_004
      await aniGalleryFilesrecover004(dt);
    });
    run('aniGalleryFloatingwindow001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库进入悬浮窗动效] TID: ani_GalleryFloatingwindow_001
      await aniGalleryFloatingwindow001(dt);
    });
    run('aniGalleryPalaceGridadd001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [宫格新增动效] TID: ani_GalleryPalaceGridadd_001
      await aniGalleryPalaceGridadd001(dt);
    });
    run('aniGalleryPalaceGriddelete001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [宫格删除动效] TID: ani_GalleryPalaceGriddelete_001
      await aniGalleryPalaceGriddelete001(dt);
    });
    run('aniGalleryPalaceGridPress001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-拖拽用例: [宫格界面长按动效检查] TID: ani_GalleryPalaceGridPress_001
      await aniGalleryPalaceGridPress001(dt);
    });
    run('aniGalleryPalaceGridPress002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-拖拽用例: [多选状态长按动效检查] TID: ani_GalleryPalaceGridPress_002
      await aniGalleryPalaceGridPress002(dt);
    });
    run('aniGalleryPalaceGridSelection001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-滑动用例: [宫格滑动多选动效] TID: ani_GalleryPalaceGridSelection_001
      await aniGalleryPalaceGridSelection001(dt);
    });
    run('aniGalleryPhotoAlbumTransitions01', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [相册页打开相册动效（一镜到底）] TID: ani_GalleryPhotoAlbumTransitions_01
      await aniGalleryPhotoAlbumTransitions01(dt);
    });
    run('aniGalleryPhotoAlbumTransitions02', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [相册页打开相册动效（父子转场）] TID: ani_GalleryPhotoAlbumTransitions_02
      await aniGalleryPhotoAlbumTransitions02(dt);
    });
    run('aniGalleryPhotoCollage001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [拼图位置调换动效检查] TID: ani_GalleryPhotoCollage_001
      await aniGalleryPhotoCollage001(dt);
    });
    run('aniGalleryPhotosYearMonthDay015', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [年视图捏合放大到月日视图] TID: ani_GalleryPhotosYearMonthDay_015
      await aniGalleryPhotosYearMonthDay015(dt);
    });
    run('aniGalleryPhotosYearMonthDay016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [分屏和悬浮窗模式下缩放年月日视图] TID: ani_GalleryPhotosYearMonthDay_016
      await aniGalleryPhotosYearMonthDay016(dt);
    });
    run('aniGalleryPhotosYearMonthDay017', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [年月日视图捏合过程中横竖屏] TID: ani_GalleryPhotosYearMonthDay_017
      await aniGalleryPhotosYearMonthDay017(dt);
    });
    run('aniGalleryPhotosYearMonthDay018', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [年月日视图捏合过程中切换tab] TID: ani_GalleryPhotosYearMonthDay_018
      await aniGalleryPhotosYearMonthDay018(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachAniGalleryAlt').init();
      dt.log.i('afterEach AniGalleryAlt start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach AniGalleryAlt finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllAniGalleryAlt').init();
      dt.log.i('afterAll AniGalleryAlt start');
      await Exit.browser();
      dt.log.i('afterAll AniGalleryAlt finish');
    });
  });
}

// DT步骤

/**
 * 宫格-: [altxxx和xxx切换动效查看]
 * GROUP: 宫格 MODULE: TID: ani_Gallery_alt_071025
 * 前置条件
 * 1、手机上存在照片
 */
async function aniGalleryalt071025(dt: Dt) {
  dt.log.i('altxxx和xxx切换动效查看 start');
  dt.log.i('STEP 1、杀掉图库进程，照片页、相册页、宫格页、picker页、编辑页、设置页，从xxx切换到xxx，查看动效');

  await dt.sleep();
  dt.log.i('预期结果1、动效流畅，无视觉异常，符合ux设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、杀掉图库进程，照片页、相册页、宫格页、picker页、编辑页、设置页，从xxx切换到xxx，查看动效');

  await dt.sleep();
  dt.log.i('预期结果2、动效流畅，无视觉异常，符合ux设计');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('altxxx和xxx切换动效查看 end');
}

/**
 * 宫格-竖屏: [altxxx动效查看]
 * GROUP: 宫格 MODULE: 竖屏TID: ani_Gallery_alt_071026
 * 前置条件
 * 1、手机上存在照片
 */
async function aniGalleryalt071026(dt: Dt) {
  dt.log.i('altxxx动效查看 start');
  dt.log.i('STEP 1、杀掉图库进程，照片页、相册页、宫格页、picker页、编辑页、设置页，xxx横竖屏切换，查看动效');

  await dt.sleep();
  dt.log.i('预期结果1、动效流畅，无视觉异常，符合ux设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、杀掉图库进程，照片页、相册页、宫格页、picker页、编辑页、设置页，xxx横竖屏切换，查看动效');

  await dt.sleep();
  dt.log.i('预期结果2、动效流畅，无视觉异常，符合ux设计');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('altxxx动效查看 end');
}

/**
 * 宫格-: [alt悬停态动效查看]
 * GROUP: 宫格 MODULE: TID: ani_Gallery_alt_071027
 * 前置条件
 * 1、手机上存在照片
 */
async function aniGalleryalt071027(dt: Dt) {
  dt.log.i('alt悬停态动效查看 start');
  dt.log.i('STEP 1、杀掉图库进程，照片页、相册页、宫格页、picker页、编辑页、设置页，切换成悬停态，查看动效');

  await dt.sleep();
  dt.log.i('预期结果1、动效流畅，无视觉异常，符合ux设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、杀掉图库进程，照片页、相册页、宫格页、picker页、编辑页、设置页，切换成悬停态，查看动效');

  await dt.sleep();
  dt.log.i('预期结果2、动效流畅，无视觉异常，符合ux设计');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('alt悬停态动效查看 end');
}

/**
 * 宫格-竖屏: [altxxx悬停态-横竖屏切换]
 * GROUP: 宫格 MODULE: 竖屏TID: ani_Gallery_alt_071028
 * 前置条件
 * 1、手机上存在图片
 */
async function aniGalleryalt071028(dt: Dt) {
  dt.log.i('altxxx悬停态-横竖屏切换 start');
  dt.log.i('STEP 1、进入照片大图，xxx手机进入半xxx');

  await dt.sleep();
  dt.log.i('STEP 2、横竖屏切换');

  await dt.sleep();
  dt.log.i('预期结果2、动效显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('altxxx悬停态-横竖屏切换 end');
}

/**
 * 宫格-沉浸: [图库沉浸式对比动效检查]
 * GROUP: 宫格 MODULE: 沉浸TID: ani_Gallery_contrasts_020
 * 前置条件
 *
 1.图库中存在多张图片视频文件，
 图片满足格式要求
 */
async function aniGallerycontrasts020(dt: Dt) {
  dt.log.i('图库沉浸式对比动效检查 start');
  dt.log.i('STEP 1、重复进入退出图片比较模式，观察动效');

  await dt.sleep();
  dt.log.i('预期结果1、动效符合预期，无异常变化');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、比图界面数量增加减少、2图3图4图删除增加操作，观察动效');

  await dt.sleep();
  dt.log.i('STEP 3、缩略图左右滑动观察动效 ');

  await dt.sleep();
  dt.log.i('STEP 4、缩略图删减，依次从满屏删减到0张，观察动效');

  await dt.sleep();
  dt.log.i('STEP 5、点击联动图标，查看微动效""');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库沉浸式对比动效检查 end');
}

/**
 * 宫格-拖拽: [相册拖拽排序动效检查]
 * GROUP: 宫格 MODULE: 拖拽TID: ani_GalleryAlbumsDragSorting_100
 * 前置条件
 * 1、图库中存在不同格式的图片和视频
 2、图库相册页tab有多个不同相册
 */
async function aniGalleryAlbumsDragSorting100(dt: Dt) {
  dt.log.i('相册拖拽排序动效检查 start');
  dt.log.i('STEP 1.进入图库首页宫格页面');

  await dt.sleep();
  dt.log.i('STEP 2.长按拖拽单个用户创建的相册进行重新排序，动效查看');

  await dt.sleep();
  dt.log.i('预期结果2、松手后，根据松手位置，插入松手处，相册重新排序正常，拖拽过程图库动效流畅');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册拖拽排序动效检查 end');
}

/**
 * 宫格-格式: [不同窗口大小相册动效查看]
 * GROUP: 宫格 MODULE: 格式TID: ani_GalleryAlbumsMirror_002
 * 前置条件
 * 1、图库中存在不同相册
 2、图库中存在不同格式的照片和视频文件
 */
async function aniGalleryAlbumsMirror002(dt: Dt) {
  dt.log.i('不同窗口大小相册动效查看 start');
  dt.log.i('STEP 1、调整图库窗口大小（全屏、宽度调到最小、高度调到最小等）');

  await dt.sleep();
  dt.log.i('STEP 2、点击相册进入');

  await dt.sleep();
  dt.log.i('预期结果2、进入宫格显示界面有一镜到底入场效果，无卡顿');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再返回到上一级');

  await dt.sleep();
  dt.log.i('预期结果3、返回到相册页有一镜到底退场动效，无卡顿');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同窗口大小相册动效查看 end');
}

/**
 * 宫格-格式: [验证相册风格切换切换时的动效为geometryTransition]
 * GROUP: 宫格 MODULE: 格式TID: ani_GalleryAlbumStyle_100
 * 前置条件
 * 1、图库中存在不同来源的相册，包括预制相册、用户创建相册、智慧相册等
 2、图库中存在不同格式的照片和视频文件
 3，云图库中存在不同格式的照片和视频文件
 */
async function aniGalleryAlbumStyle100(dt: Dt) {
  dt.log.i('验证相册风格切换切换时的动效为geometryTransition start');
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
  dt.log.i('验证相册风格切换切换时的动效为geometryTransition end');
}

/**
 * 宫格-进入大图: [图库不同入口进入大图动效]
 * GROUP: 宫格 MODULE: 进入大图TID: ani_GalleryCommondataUX_001
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function aniGalleryCommondataUX001(dt: Dt) {
  dt.log.i('图库不同入口进入大图动效 start');
  dt.log.i('STEP 1.点击缩略图查看大图');

  await dt.sleep();
  dt.log.i('预期结果1- 2、大图从宫格所在位置开始放大，直到大图完全打开；其他title和actionbar出现无动效，过程中动效流畅，无卡顿情况');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从不同入口（FA卡片、相机、时间轴界面、相册界面）进入大图');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库不同入口进入大图动效 end');
}

/**
 * 宫格-大图: [图库不同入口侧滑退出、下拉退出、back键退出大图动效]
 * GROUP: 宫格 MODULE: 大图TID: ani_GalleryCommondataUX_002
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function aniGalleryCommondataUX002(dt: Dt) {
  dt.log.i('图库不同入口侧滑退出、下拉退出、back键退出大图动效 start');
  dt.log.i('STEP 1、不同入口（picker/照片页/相册页）点击进入大图浏览页面');

  await dt.sleep();
  dt.log.i('STEP 2、横屏时下拉退出，侧滑退出，back键退出大图');

  await dt.sleep();
  dt.log.i('预期结果2、3 、4退出大图界面，动效流畅符合ux设计，没有卡顿、丢帧等情况');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、沉浸式时下拉退出，侧滑退出大图');

  await dt.sleep();
  dt.log.i('STEP 4、Picker/照片页/相册页界面下拉退出、侧滑退出，back键退出大图');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库不同入口侧滑退出、下拉退出、back键退出大图动效 end');
}

/**
 * 宫格-格式: [图库应用启动和退出，和桌面之间的动效]
 * GROUP: 宫格 MODULE: 格式TID: ani_GalleryCommondataUX_003
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function aniGalleryCommondataUX003(dt: Dt) {
  dt.log.i('图库应用启动和退出，和桌面之间的动效 start');
  dt.log.i('STEP 1、桌面点击图库');

  await dt.sleep();
  dt.log.i('预期结果1 2、动效正常，关注图库图标展开及收起时的动效不存在卡顿、跳变、丢失问题');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、图库界面退出到桌面');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库应用启动和退出，和桌面之间的动效 end');
}

/**
 * 宫格-删除: [智慧编辑图片智慧扩图完成]
 * GROUP: 宫格 MODULE: 删除TID: ani_GalleryEditorEffect_AI_001
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通不同图片
 */
async function aniGalleryEditorEffectAI001(dt: Dt) {
  dt.log.i('智慧编辑图片智慧扩图完成 start');
  dt.log.i('STEP 1.选择普通图片进入图片编辑页面，选择AI修图-点击智能扩图-长按图片');

  await dt.sleep();
  dt.log.i('预期结果1、图片上有点阵loading动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.AI 分析完毕后，点击一键扩图，观察界面动效');

  await dt.sleep();
  dt.log.i('预期结果2、图片上有点阵loading动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.生成完毕之后点击保存，查看界面动效');

  await dt.sleep();
  dt.log.i('预期结果3、动效正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧编辑图片智慧扩图完成 end');
}

/**
 * 宫格-删除: [智慧编辑背景编辑]
 * GROUP: 宫格 MODULE: 删除TID: ani_GalleryEditorEffect_AI_002
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通不同图片
 */
async function aniGalleryEditorEffectAI002(dt: Dt) {
  dt.log.i('智慧编辑背景编辑 start');
  dt.log.i('STEP 1、选择普通图片进入图片编辑页面，选择AI修图-点击背景');

  await dt.sleep();
  dt.log.i('STEP 2、点击背景虚化，查看动效');

  await dt.sleep();
  dt.log.i('预期结果2、背景虚化动效正常，不卡顿');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击背景去色，查看动效');

  await dt.sleep();
  dt.log.i('预期结果3、背景去色动效正常，不卡顿');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧编辑背景编辑 end');
}

/**
 * 宫格-删除: [智慧编辑对象消除]
 * GROUP: 宫格 MODULE: 删除TID: ani_GalleryEditorEffect_AI_003
 * 前置条件
 * ""1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通不同图片""
 */
async function aniGalleryEditorEffectAI003(dt: Dt) {
  dt.log.i('智慧编辑对象消除 start');
  dt.log.i('STEP 1.选择普通图片进入图片编辑页面，选择AI修图-点击消除');

  await dt.sleep();
  dt.log.i('STEP 2、在照片上滑区域，智能消除生效，查看动效');

  await dt.sleep();
  dt.log.i('预期结果2、智能消除动效正常，不卡顿');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击手动消除，在照片上滑区域，智能消除生效，查看动效');

  await dt.sleep();
  dt.log.i('预期结果3、手动消除动效正常，不卡顿');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧编辑对象消除 end');
}

/**
 * 宫格-删除: [图片相册内容删除后，可恢复到图片相册]
 * GROUP: 宫格 MODULE: 删除TID: ani_GalleryFilesrecover_004
 * 前置条件
 * 1、图库最近删除相册有图片、视频
 */
async function aniGalleryFilesrecover004(dt: Dt) {
  dt.log.i('图片相册内容删除后，可恢复到图片相册 start');
  dt.log.i('STEP 1、最近删除相册，打开图片大图，点击恢复');

  await dt.sleep();
  dt.log.i('预期结果1、图片从大图页消失，刷新到下一张；恢复后的图片显示在图片相册，图片相册数量增加3、图片从宫格页消失，有消失动画；恢复后的图片显示在图片相册，图片相册数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、或宫格页多选图片，点击恢复');

  await dt.sleep();
  dt.log.i('预期结果3、图片从宫格页消失，有消失动画；恢复后的图片显示在图片相册，图片相册数量增加');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片相册内容删除后，可恢复到图片相册 end');
}

/**
 * 宫格-: [图库进入悬浮窗动效]
 * GROUP: 宫格 MODULE: TID: ani_GalleryFloatingwindow_001
 * 前置条件
 * 1、使用最新版本的图库
 */
async function aniGalleryFloatingwindow001(dt: Dt) {
  dt.log.i('图库进入悬浮窗动效 start');
  dt.log.i('STEP 1、打开图库');

  await dt.sleep();
  dt.log.i('预期结果1、2、3、4、5操作流畅，界面无异常，界面正常显示，符合UX设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、不同界面（照片页、相册页、编辑页）上滑应用不松手进入多任务2、拖动应用进入多窗进入悬浮模式');

  await dt.sleep();
  dt.log.i('STEP 3、点击应用');

  await dt.sleep();
  dt.log.i('STEP 4、点击窗口边缘，出现蓝框，拖动窗口');

  await dt.sleep();
  dt.log.i('STEP 5、点击悬浮窗口上方的三个点，出现操作按钮，改变窗口大小');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库进入悬浮窗动效 end');
}

/**
 * 宫格-格式: [宫格新增动效]
 * GROUP: 宫格 MODULE: 格式TID: ani_GalleryPalaceGridadd_001
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件

 */
async function aniGalleryPalaceGridadd001(dt: Dt) {
  dt.log.i('宫格新增动效 start');
  dt.log.i('STEP 2、进入相册页，添加图片');

  await dt.sleep();
  dt.log.i('预期结果2、照片成功添加至相册，存在新增动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、相机拍照，返回桌面点击图库图标进入图库');

  await dt.sleep();
  dt.log.i('预期结果3、宫格存在新增动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、从其它应用保存图片""');

  await dt.sleep();
  dt.log.i('预期结果4、热启动图库场景下，图库存在新增动效”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text(''));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格新增动效 end');
}

/**
 * 宫格-删除: [宫格删除动效]
 * GROUP: 宫格 MODULE: 删除TID: ani_GalleryPalaceGriddelete_001
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function aniGalleryPalaceGriddelete001(dt: Dt) {
  dt.log.i('宫格删除动效 start');
  dt.log.i('STEP 1. 进入照片页或相册页，单张+批量删除照片');

  await dt.sleep();
  dt.log.i('预期结果1.删除成功，宫格删除存在动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.进入收藏相册页，取消收藏');

  await dt.sleep();
  dt.log.i('预期结果2、宫格存在删除动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入回收站相册，恢复照片');

  await dt.sleep();
  dt.log.i('预期结果3、宫格存在删除动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、其它应用删除照片');

  await dt.sleep();
  dt.log.i('预期结果4、热启动图库场景下，图库存在删除动效');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果5、关注宫格补位动效正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格删除动效 end');
}

/**
 * 宫格-拖拽: [宫格界面长按动效检查]
 * GROUP: 宫格 MODULE: 拖拽TID: ani_GalleryPalaceGridPress_001
 * 前置条件
 * 1、手机上存在照片
 */
async function aniGalleryPalaceGridPress001(dt: Dt) {
  dt.log.i('宫格界面长按动效检查 start');
  dt.log.i('STEP 1、进入照片页、相册内照片宫格，进行长按拖拽');

  await dt.sleep();
  dt.log.i('预期结果1、动效流畅，无视觉异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格界面长按动效检查 end');
}

/**
 * 宫格-拖拽: [多选状态长按动效检查]
 * GROUP: 宫格 MODULE: 拖拽TID: ani_GalleryPalaceGridPress_002
 * 前置条件
 * 1、手机上存在照片
 */
async function aniGalleryPalaceGridPress002(dt: Dt) {
  dt.log.i('多选状态长按动效检查 start');
  dt.log.i('STEP 1、进入照片页、相册内照片宫格，点击更多，点击多选，选择单张或多张照片长按拖拽');

  await dt.sleep();
  dt.log.i('预期结果1、动效流畅，无视觉异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多选状态长按动效检查 end');
}

/**
 * 宫格-滑动: [宫格滑动多选动效]
 * GROUP: 宫格 MODULE: 滑动TID: ani_GalleryPalaceGridSelection_001
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function aniGalleryPalaceGridSelection001(dt: Dt) {
  dt.log.i('宫格滑动多选动效 start');
  dt.log.i('STEP 1、从照片页/相册页（普通相册、智慧相册、隐藏相册、视频相册、最近删除相册）/PhotoPicker进入图片缩略图宫格页面，点击右上角更多，点击多选，进入选择模式；');

  await dt.sleep();
  dt.log.i('STEP 2、操作滑动选择，手指滑动到屏幕上下边缘时，驱动宫格向上、向下滚动，并继续滑动选择屏幕之外的宫格');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格滑动多选动效 end');
}

/**
 * 宫格-视频: [相册页打开相册动效（一镜到底）]
 * GROUP: 宫格 MODULE: 视频TID: ani_GalleryPhotoAlbumTransitions_01
 * 前置条件
 * 1、已登录云账号，图库本地和云账号存在图片和视频资源，资源数量超过500个；
 */
async function aniGalleryPhotoAlbumTransitions01(dt: Dt) {
  dt.log.i('相册页打开相册动效（一镜到底） start');
  dt.log.i('STEP 1.从相册页点击（系统预置、用户创建、智能分类里的拍摄模式、分类相册、人像相册二级界面相册、地点相册二级界面里标注在地图上的相册、隐藏相册二级界面相册、相册一级界面人像相册、拍摄模式、分类相册）；');

  await dt.sleep();
  dt.log.i('预期结果1.点击进入相册成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.查看打开相册的动效；');

  await dt.sleep();
  dt.log.i('预期结果2.打开相册一镜到底动效正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.手机、xxx、平板横屏，重复步骤1、2，PC不涉及横屏；');

  await dt.sleep();
  dt.log.i('预期结果3.横屏状态下，打开相册动效正常。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页打开相册动效（一镜到底） end');
}

/**
 * 宫格-删除: [相册页打开相册动效（父子转场）]
 * GROUP: 宫格 MODULE: 删除TID: ani_GalleryPhotoAlbumTransitions_02
 * 前置条件
 * 1、已登录云账号，图库本地和云账号存在图片和视频资源，资源数量超过500个；
 */
async function aniGalleryPhotoAlbumTransitions02(dt: Dt) {
  dt.log.i('相册页打开相册动效（父子转场） start');
  dt.log.i('STEP 1.从相册页点击（所有list相册：来源相册、隐藏相册、最近删除相册；相册一级界面里的地点相册）；');

  await dt.sleep();
  dt.log.i('预期结果1.点击进入相册成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.查看打开相册的动效；');

  await dt.sleep();
  dt.log.i('预期结果2.打开相册父子转场动效正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.手机、xxx、平板横屏，重复步骤1、2，PC不涉及横屏；');

  await dt.sleep();
  dt.log.i('预期结果3.横屏状态下，打开相册动效正常。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页打开相册动效（父子转场） end');
}

/**
 * 宫格-格式: [拼图位置调换动效检查]
 * GROUP: 宫格 MODULE: 格式TID: ani_GalleryPhotoCollage_001
 * 前置条件
 * 1.图库中存在不同来源的相册
 2.图库相册中存在不同格式的相片和视频
 */
async function aniGalleryPhotoCollage001(dt: Dt) {
  dt.log.i('拼图位置调换动效检查 start');
  dt.log.i('STEP 1、进入云图库，点击照片');

  await dt.sleep();
  dt.log.i('STEP 2、照片页，点击多选');

  await dt.sleep();
  dt.log.i('STEP 3、选择云图库中5张照片');

  await dt.sleep();
  dt.log.i('STEP 4、点击拼图按钮');

  await dt.sleep();
  dt.log.i('STEP 5、拼图界面，点击某个图片，长按');

  await dt.sleep();
  dt.log.i('预期结果5、图片虚影显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、手指上下左右中拖动，调换不同位置');

  await dt.sleep();
  dt.log.i('预期结果6、拖动过程中，未出现异常，图片位置调换成功，界面动效正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('拼图位置调换动效检查 end');
}

/**
 * 宫格-格式: [年视图捏合放大到月日视图]
 * GROUP: 宫格 MODULE: 格式TID: ani_GalleryPhotosYearMonthDay_015
 * 前置条件
 * 图库中存在不同格式的图片及视频
 */
async function aniGalleryPhotosYearMonthDay015(dt: Dt) {
  dt.log.i('年视图捏合放大到月日视图 start');
  dt.log.i('STEP 1.1、打开图库，切换到照片页年视图，双指缩小操作后离手1.2、年视图双指捏合小距离放大');

  await dt.sleep();
  dt.log.i('预期结果1.1、视图无切换1.2、手指位置的图片在当前屏幕对应的位置展示，等比例放大到月视图，缩放动效正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、月视图双指捏合小距离放大');

  await dt.sleep();
  dt.log.i('预期结果2、手指位置的图片在当前屏幕对应的位置展示，等比例放大到日视图，缩放动效正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、年视图双指距离大一点放大操作');

  await dt.sleep();
  dt.log.i('预期结果3、手指位置的图片在当前屏幕对应的位置展示，等比例缩放到日视图，缩放动效正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、切换到横屏，重复步骤1、2、3');

  await dt.sleep();
  dt.log.i('预期结果4、结果同步骤1、2、3');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('年视图捏合放大到月日视图 end');
}

/**
 * 宫格-格式: [分屏和悬浮窗模式下缩放年月日视图]
 * GROUP: 宫格 MODULE: 格式TID: ani_GalleryPhotosYearMonthDay_016
 * 前置条件
 * 图库中存在不同格式的图片及视频
 */
async function aniGalleryPhotosYearMonthDay016(dt: Dt) {
  dt.log.i('分屏和悬浮窗模式下缩放年月日视图 start');
  dt.log.i('STEP 1、图库切换到分屏模式，缩放年月日视图');

  await dt.sleep();
  dt.log.i('预期结果1、2、手指位置的图片在当前屏幕对应的位置展示，等比例缩放到对应的视图，缩放动效正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、图库切换到悬浮窗模式，缩放年月日视图');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分屏和悬浮窗模式下缩放年月日视图 end');
}

/**
 * 宫格-竖屏: [年月日视图捏合过程中横竖屏]
 * GROUP: 宫格 MODULE: 竖屏TID: ani_GalleryPhotosYearMonthDay_017
 * 前置条件
 * 图库中存在不同格式的图片及视频
 */
async function aniGalleryPhotosYearMonthDay017(dt: Dt) {
  dt.log.i('年月日视图捏合过程中横竖屏 start');
  dt.log.i('STEP 1、年月日视图捏合过程中切换横竖屏');

  await dt.sleep();
  dt.log.i('预期结果1、捏合过程中不允许切换横竖屏');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('年月日视图捏合过程中横竖屏 end');
}

/**
 * 宫格-格式: [年月日视图捏合过程中切换tab]
 * GROUP: 宫格 MODULE: 格式TID: ani_GalleryPhotosYearMonthDay_018
 * 前置条件
 * 图库中存在不同格式的图片及视频
 */
async function aniGalleryPhotosYearMonthDay018(dt: Dt) {
  dt.log.i('年月日视图捏合过程中切换tab start');
  dt.log.i('STEP 1、年月日视图捏合过程中，滑动宫格');

  await dt.sleep();
  dt.log.i('预期结果1、禁止宫格滑动');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、年月日视图捏合过程中，点击顶部按钮和年月日按钮');

  await dt.sleep();
  dt.log.i('预期结果2、禁止切换顶部按钮和年月日按钮');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、年月日视图捏合过程中，切换照片和相册tab');

  await dt.sleep();
  dt.log.i('预期结果3、离手动效');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('年月日视图捏合过程中切换tab end');
}

































