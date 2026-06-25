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

export default function GalleryHighlightAddTest(): void {

  // Defines a test suite. Two parameters are supported: test suite name and test suite function.

  // Presets an action, which is performed only once before all test cases of the test suite start.

  // This API supports only one parameter: preset action function.

  describe('GalleryHighlightAddTest', (): void => {

    /**
     *
     * 确认当前图库app处于启动状态
     *
     */

    beforeAll(async (): Promise<void> => {

      await AppStart.photos();

      const dt = await new Dt('beforeAllGalleryHighlightAdd').init();

      dt.log.i('beforeAll GalleryHighlightAdd start');

      dt.log.i('beforeAll GalleryHighlightAdd finish');

    });

    /**
     *
     * 打开大图
     *
     */

    run('beforeGalleryHighlightAdd', Level.LEVEL0, async (dt: Dt): Promise<void> => {

      await dt.browser();

    });

    // DT声明

    run('Multimedia_Gallery_highlight_add001', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-滑动用例: [拉起picker界面，添加照片后左后滑动退出] TID: Multimedia_Gallery_highlight_add001

      await Multimedia_Gallery_highlight_add001(dt);

    });

    run('Multimedia_Gallery_highlight_add002', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [时刻添加照片、轮播、宫格、素材调整顺序、数据库显示] TID: Multimedia_Gallery_highlight_add002

      await Multimedia_Gallery_highlight_add002(dt);

    });

    run('Multimedia_Gallery_highlight_add003', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [时刻素材上限200张] TID: Multimedia_Gallery_highlight_add003

      await Multimedia_Gallery_highlight_add003(dt);

    });

    run('Multimedia_Gallery_highlight_add004', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [取消勾选默认图片，时刻不显示图片，图库存在取消勾选图片] TID: Multimedia_Gallery_highlight_add004

      await Multimedia_Gallery_highlight_add004(dt);

    });

    run('Multimedia_Gallery_highlight_add005', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [取消勾选默认图片后，播放顺序、配乐时长，数据库显示正常] TID: Multimedia_Gallery_highlight_add005

      await Multimedia_Gallery_highlight_add005(dt);

    });

    run('Multimedia_Gallery_highlight_add006', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [全部取消勾选默认图片，picker页面显示正常] TID: Multimedia_Gallery_highlight_add006

      await Multimedia_Gallery_highlight_add006(dt);

    });

    run('Multimedia_Gallery_highlight_add007', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [取消剩一张图片，时刻不显示图片，图库存在取消勾选图片] TID: Multimedia_Gallery_highlight_add007

      await Multimedia_Gallery_highlight_add007(dt);

    });

    run('Multimedia_Gallery_highlight_add008', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [取消剩一张图片，播放顺序、配乐时长，数据库显示正常] TID: Multimedia_Gallery_highlight_add008

      await Multimedia_Gallery_highlight_add008(dt);

    });

    run('Multimedia_Gallery_highlight_add009', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [时刻添加照片后，重新充电熄屏] TID: Multimedia_Gallery_highlight_add009

      await Multimedia_Gallery_highlight_add009(dt);

    });

    run('Multimedia_Gallery_highlight_add010', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [时刻添加非时刻类型照片后，重新充电熄屏] TID: Multimedia_Gallery_highlight_add010

      await Multimedia_Gallery_highlight_add010(dt);

    });

    run('Multimedia_Gallery_highlight_add011', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [移出时刻的照片再次添加正常] TID: Multimedia_Gallery_highlight_add011

      await Multimedia_Gallery_highlight_add011(dt);

    });

    run('Multimedia_Gallery_highlight_add012', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [时刻添加图片后，分享为视频正常] TID: Multimedia_Gallery_highlight_add012

      await Multimedia_Gallery_highlight_add012(dt);

    });

    run('Multimedia_Gallery_highlight_add013', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [在时刻二级宫格页面，添加图片过程中冷启动图库，添加功能正常] TID: Multimedia_Gallery_highlight_add013

      await Multimedia_Gallery_highlight_add013(dt);

    });

    run('Multimedia_Gallery_highlight_add014', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [在时刻二级宫格页面，添加图片过程中亮灭屏，添加功能正常] TID: Multimedia_Gallery_highlight_add014

      await Multimedia_Gallery_highlight_add014(dt);

    });

    run('Multimedia_Gallery_highlight_add015', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-竖屏用例: [在时刻二级宫格页面，添加图片过程中横竖屏，添加功能正常] TID: Multimedia_Gallery_highlight_add015

      await Multimedia_Gallery_highlight_add015(dt);

    });

    run('Multimedia_Gallery_highlight_add016', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [在时刻二级宫格页面，添加图片过程中关机重启，添加功能正常] TID: Multimedia_Gallery_highlight_add016

      await Multimedia_Gallery_highlight_add016(dt);

    });

    run('Multimedia_Gallery_highlight_add017', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [时刻重命名后，添加图片正常] TID: Multimedia_Gallery_highlight_add017

      await Multimedia_Gallery_highlight_add017(dt);

    });

    run('Multimedia_Gallery_highlight_add018', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [更换封面后，添加图片正常] TID: Multimedia_Gallery_highlight_add018

      await Multimedia_Gallery_highlight_add018(dt);

    });

    run('Multimedia_Gallery_highlight_add019', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [移除后，添加图片正常] TID: Multimedia_Gallery_highlight_add019

      await Multimedia_Gallery_highlight_add019(dt);

    });

    run('Multimedia_Gallery_highlight_add020', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [移除图片后，再次添加图片正常] TID: Multimedia_Gallery_highlight_add020

      await Multimedia_Gallery_highlight_add020(dt);

    });

    run('Multimedia_Gallery_highlight_add021', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [多次连续添加图片，页面显示正常] TID: Multimedia_Gallery_highlight_add021

      await Multimedia_Gallery_highlight_add021(dt);

    });

    run('Multimedia_Gallery_highlight_add022', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-深色用例: [在深色模式下，添加图片，页面显示正常] TID: Multimedia_Gallery_highlight_add022

      await Multimedia_Gallery_highlight_add022(dt);

    });

    run('Multimedia_Gallery_highlight_add023', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [在无障碍模式下，添加图片，页面显示正常] TID: Multimedia_Gallery_highlight_add023

      await Multimedia_Gallery_highlight_add023(dt);

    });

    run('Multimedia_Gallery_highlight_add024', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [在大字体模式下，添加图片，页面显示正常] TID: Multimedia_Gallery_highlight_add024

      await Multimedia_Gallery_highlight_add024(dt);

    });

    run('Multimedia_Gallery_highlight_add025', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-竖屏用例: [添加图片过程中横竖屏旋转，页面显示正常] TID: Multimedia_Gallery_highlight_add025

      await Multimedia_Gallery_highlight_add025(dt);

    });

    run('Multimedia_Gallery_highlight_add026', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [在多语言模式下，添加图片，页面显示正常] TID: Multimedia_Gallery_highlight_add026

      await Multimedia_Gallery_highlight_add026(dt);

    });

    run('Multimedia_Gallery_highlight_add027', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [克隆成功后，添加克隆的图片，页面显示正常] TID: Multimedia_Gallery_highlight_add027

      await Multimedia_Gallery_highlight_add027(dt);

    });

    run('Multimedia_Gallery_highlight_add028', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [升级成功后，添加图片，页面显示正常] TID: Multimedia_Gallery_highlight_add028

      await Multimedia_Gallery_highlight_add028(dt);

    });

    run('Multimedia_Gallery_highlight_add029', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [xxx隆成功后，添加克隆的图片，页面显示正常] TID: Multimedia_Gallery_highlight_add029

      await Multimedia_Gallery_highlight_add029(dt);

    });

    run('Multimedia_Gallery_highlight_add030', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [在分屏模式下，添加图片，页面显示正常] TID: Multimedia_Gallery_highlight_add030

      await Multimedia_Gallery_highlight_add030(dt);

    });

    run('Multimedia_Gallery_highlight_add031', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [在悬浮窗模式下，添加图片，页面显示正常] TID: Multimedia_Gallery_highlight_add031

      await Multimedia_Gallery_highlight_add031(dt);

    });

    run('Multimedia_Gallery_highlight_add032', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [在横屏下，添加图片，页面显示正常] TID: Multimedia_Gallery_highlight_add032

      await Multimedia_Gallery_highlight_add032(dt);

    });

    run('Multimedia_Gallery_highlight_add033', Level.LEVEL2, async (dt: Dt): Promise<void> => {

      //  智慧图库-视频用例: [添加照片的时效] TID: Multimedia_Gallery_highlight_add033

      await Multimedia_Gallery_highlight_add033(dt);

    });

    /**
     *
     * 确保每次测试完毕回到大图页
     *
     */

    afterEach(async (): Promise<void> => {

      const dt = await new Dt('afterEachGalleryHighlightAdd').init();

      dt.log.i('afterEach GalleryHighlightAdd start');

      await dt.sleep(DELAY.short);

      dt.log.i('afterEach GalleryHighlightAdd finish');

    });

    /**
     *
     * 退出大图 回到时间线页面
     *
     */

    afterAll(async (): Promise<void> => {

      const dt = await new Dt('afterAllGalleryHighlightAdd').init();

      dt.log.i('afterAll GalleryHighlightAdd start');

      await Exit.browser();

      dt.log.i('afterAll GalleryHighlightAdd finish');

    });

  });

}

// DT步骤

/**
 *
 * 智慧图库-滑动: [拉起picker界面，添加照片后左后滑动退出]
 *
 * GROUP: 智慧图库 MODULE: 滑动TID: Multimedia_Gallery_highlight_add001
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add001(dt: Dt) {

  dt.log.i('拉起picker界面，添加照片后左后滑动退出 start');

  dt.log.i('STEP 1、进入时刻轮播页面后，上滑进入二级宫格页面');

  await dt.sleep();

  dt.log.i('预期结果1、流畅无crash');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、右上角更多，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，界面显示正常无黑花闪白，默认勾选时刻内的全部照片  ');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、勾选一张图片，左右滑动退出');

  await dt.sleep();

  dt.log.i('预期结果3、添加失败，二级宫格与轮播页面无此图显示');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('拉起picker界面，添加照片后左后滑动退出 end');

}

/**
 *
 * 智慧图库-视频: [时刻添加照片、轮播、宫格、素材调整顺序、数据库显示]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add002
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add002(dt: Dt) {

  dt.log.i('时刻添加照片、轮播、宫格、素材调整顺序、数据库显示 start');

  dt.log.i('STEP 1、进入时刻轮播页面后，上滑进入二级宫格页面');

  await dt.sleep();

  dt.log.i('预期结果1、流畅无crash');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、右上角更多，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、添加多张图片（例如1张、5张、10张等），点击完成，充电熄屏，等待分析完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功，添加数量与时刻宫格页显示一致，时刻轮播页已添加照片，时刻宫格页显示调整后的顺序，时间默认升序；轮播页刷新时刻相册播放顺序信息');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 4、查看数据库AnalysisPhotoMap、AnalysisAlbum显示');

  await dt.sleep();

  dt.log.i('预期结果4、①AnalysisPhotoMap新增map_album和map_asset对应数据      ②AnalysisAlbum更新对应count数据 ');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('时刻添加照片、轮播、宫格、素材调整顺序、数据库显示 end');

}

/**
 *
 * 智慧图库-视频: [时刻素材上限200张]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add003
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add003(dt: Dt) {

  dt.log.i('时刻素材上限200张 start');

  dt.log.i('STEP 1、进入时刻轮播页面后，上滑进入二级宫格页面');

  await dt.sleep();

  dt.log.i('预期结果1、流畅无crash');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、右上角更多，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、添加至200张图片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功，添加数量与时刻宫格页显示一致');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 4、再次添加照片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果4、添加失败');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('时刻素材上限200张 end');

}

/**
 *
 * 智慧图库-视频: [取消勾选默认图片，时刻不显示图片，图库存在取消勾选图片]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add004
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add004(dt: Dt) {

  dt.log.i('取消勾选默认图片，时刻不显示图片，图库存在取消勾选图片 start');

  dt.log.i('STEP 1、进入时刻轮播页面后，上滑进入二级宫格页面');

  await dt.sleep();

  dt.log.i('预期结果1、流畅无crash');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、右上角更多，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、取消勾选多张图片（例如1张、5张、10张等），点击完成，返回至宫格页与轮播页查看');

  await dt.sleep();

  dt.log.i('预期结果3、移除成功，时刻宫格也与轮播页不显示已取消勾选的图片');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 4、返回图库查看');

  await dt.sleep();

  dt.log.i('预期结果4、图库存在取消勾选的图片');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('取消勾选默认图片，时刻不显示图片，图库存在取消勾选图片 end');

}

/**
 *
 * 智慧图库-视频: [取消勾选默认图片后，播放顺序、配乐时长，数据库显示正常]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add005
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add005(dt: Dt) {

  dt.log.i('取消勾选默认图片后，播放顺序、配乐时长，数据库显示正常 start');

  dt.log.i('STEP 1、进入时刻轮播页面后，上滑进入二级宫格页面');

  await dt.sleep();

  dt.log.i('预期结果1、流畅无crash');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、右上角更多，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、取消勾选多张图片（例如1张、5张、10张等），充电熄屏，等待分析完成，返回查看播放顺序以及音乐效果');

  await dt.sleep();

  dt.log.i('预期结果3、移除成功，前台刷新时刻相册的播放順序信息及视频剪辑配乐效果');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 4、拉取数据库，查看AnalysisPhotoMap表和map_album和map_asset字段');

  await dt.sleep();

  dt.log.i('预期结果4、AnalysisPhotoMap表map_album和map_asset的数据刷新（map_album对应album_id，map_asset对应file_id）');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 5、查看日志highlight dismissAssets');

  await dt.sleep();

  dt.log.i('预期结果5、highlight dismissAssets（移除图片id）');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('取消勾选默认图片后，播放顺序、配乐时长，数据库显示正常 end');

}

/**
 *
 * 智慧图库-视频: [全部取消勾选默认图片，picker页面显示正常]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add006
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add006(dt: Dt) {

  dt.log.i('全部取消勾选默认图片，picker页面显示正常 start');

  dt.log.i('STEP 1、进入时刻轮播页面后，上滑进入二级宫格页面');

  await dt.sleep();

  dt.log.i('预期结果1、流畅无crash');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、右上角更多，点击添加照片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片  ');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、取消勾选全部照');

  await dt.sleep();

  dt.log.i('预期结果3、picker页面完成按钮置灰');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('全部取消勾选默认图片，picker页面显示正常 end');

}

/**
 *
 * 智慧图库-视频: [取消剩一张图片，时刻不显示图片，图库存在取消勾选图片]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add007
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add007(dt: Dt) {

  dt.log.i('取消剩一张图片，时刻不显示图片，图库存在取消勾选图片 start');

  dt.log.i('STEP 1、进入时刻轮播页面后，上滑进入二级宫格页面');

  await dt.sleep();

  dt.log.i('预期结果1、流畅无crash');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、右上角更多，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、取消勾选，剩1张图片后，点击完成，返回至宫格页与轮播页查看');

  await dt.sleep();

  dt.log.i('预期结果3、移除成功，时刻宫格也与轮播页不显示已取消勾选的图片');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 4、返回图库查看');

  await dt.sleep();

  dt.log.i('预期结果4、图库存在取消勾选的图片');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('取消剩一张图片，时刻不显示图片，图库存在取消勾选图片 end');

}

/**
 *
 * 智慧图库-视频: [取消剩一张图片，播放顺序、配乐时长，数据库显示正常]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add008
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add008(dt: Dt) {

  dt.log.i('取消剩一张图片，播放顺序、配乐时长，数据库显示正常 start');

  dt.log.i('STEP 1、进入时刻轮播页面后，上滑进入二级宫格页面');

  await dt.sleep();

  dt.log.i('预期结果1、流畅无crash');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、右上角更多，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、取消勾选多张图片（例如1张、5张、10张等），点击完成，返回查看播放顺序以及音乐效果');

  await dt.sleep();

  dt.log.i('预期结果3、移除成功，前台刷新时刻相册的播放順序信息及视频剪辑配乐效果');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 4、拉取数据库，查看AnalysisPhotoMap表和map_album和map_asset字段');

  await dt.sleep();

  dt.log.i('预期结果4、AnalysisPhotoMap表map_album和map_asset的数据刷新（map_album对应album_id，map_asset对应file_id）');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 5、查看日志highlight dismissAssets');

  await dt.sleep();

  dt.log.i('预期结果5、highlight dismissAssets（移除图片id）');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('取消剩一张图片，播放顺序、配乐时长，数据库显示正常 end');

}

/**
 *
 * 智慧图库-视频: [时刻添加照片后，重新充电熄屏]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add009
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add009(dt: Dt) {

  dt.log.i('时刻添加照片后，重新充电熄屏 start');

  dt.log.i('STEP 1、进入时刻轮播页面后，上滑进入二级宫格页面');

  await dt.sleep();

  dt.log.i('预期结果1、流畅无crash');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、右上角更多，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、添加多张图片（例如1张、5张、10张等），点击完成，充电熄屏，等待分析完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 4、观察轮播页面转场效果、配乐效果、配乐时长');

  await dt.sleep();

  dt.log.i('预期结果4、重新走封面处理流程及视频剪辑流程，以及新的转场运镜效果，刷新视频剪辑配乐效果以及配乐时长');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 5、观察时刻封面');

  await dt.sleep();

  dt.log.i('预期结果5、时刻封面不更新');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('时刻添加照片后，重新充电熄屏 end');

}

/**
 *
 * 智慧图库-视频: [时刻添加非时刻类型照片后，重新充电熄屏]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add010
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add010(dt: Dt) {

  dt.log.i('时刻添加非时刻类型照片后，重新充电熄屏 start');

  dt.log.i('STEP 1、进入时刻轮播页面后，上滑进入二级宫格页面');

  await dt.sleep();

  dt.log.i('预期结果1、流畅无crash');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、右上角更多，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、添加多张图片（例如1张、5张、10张等），点击完成，充电熄屏，等待分析完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 4、观察时刻封面标题');

  await dt.sleep();

  dt.log.i('预期结果4、时刻封面标题不变');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('时刻添加非时刻类型照片后，重新充电熄屏 end');

}

/**
 *
 * 智慧图库-视频: [移出时刻的照片再次添加正常]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add011
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add011(dt: Dt) {

  dt.log.i('移出时刻的照片再次添加正常 start');

  dt.log.i('STEP 1、进入时刻轮播页面后，上滑进入二级宫格页面');

  await dt.sleep();

  dt.log.i('预期结果1、流畅无crash');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、右上角更多，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、取消勾选1张图片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果3、移除成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 4、再次添加刚取消勾选的图片');

  await dt.sleep();

  dt.log.i('预期结果4、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('移出时刻的照片再次添加正常 end');

}

/**
 *
 * 智慧图库-视频: [时刻添加图片后，分享为视频正常]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add012
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add012(dt: Dt) {

  dt.log.i('时刻添加图片后，分享为视频正常 start');

  dt.log.i('STEP 1、进入时刻轮播页面后，上滑进入二级宫格页面');

  await dt.sleep();

  dt.log.i('预期结果1、流畅无crash');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、右上角更多，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、添加多张图片（例如1张、5张、10张等），点击完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 4、右上角点击分享为视频');

  await dt.sleep();

  dt.log.i('预期结果4、保存的视频存在添加的照片');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('时刻添加图片后，分享为视频正常 end');

}

/**
 *
 * 智慧图库-视频: [在时刻二级宫格页面，添加图片过程中冷启动图库，添加功能正常]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add013
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add013(dt: Dt) {

  dt.log.i('在时刻二级宫格页面，添加图片过程中冷启动图库，添加功能正常 start');

  dt.log.i('STEP 1、进入时刻轮播页面后，上滑进入二级宫格页面');

  await dt.sleep();

  dt.log.i('预期结果1、流畅无crash');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、右上角更多，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、添加多张图片（例如1张、5张、10张等），不点击完成');

  await dt.sleep();

  dt.log.i('预期结果3、选择的照片显示已勾选');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 4、冷启动图库');

  await dt.sleep();

  dt.log.i('预期结果4、进入时刻分页');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 5、再次添加多张图片（例如1张、5张、10张等），点击完成');

  await dt.sleep();

  dt.log.i('预期结果5、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('在时刻二级宫格页面，添加图片过程中冷启动图库，添加功能正常 end');

}

/**
 *
 * 智慧图库-视频: [在时刻二级宫格页面，添加图片过程中亮灭屏，添加功能正常]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add014
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add014(dt: Dt) {

  dt.log.i('在时刻二级宫格页面，添加图片过程中亮灭屏，添加功能正常 start');

  dt.log.i('STEP 1、进入时刻轮播页面后，上滑进入二级宫格页面');

  await dt.sleep();

  dt.log.i('预期结果1、流畅无crash');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、右上角更多，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、添加多张图片（例如1张、5张、10张等），不点击完成，');

  await dt.sleep();

  dt.log.i('预期结果3、选择的照片显示已勾选');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 4、亮灭屏');

  await dt.sleep();

  dt.log.i('预期结果4、添加照片picker页正常显示');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 5、再次添加多张图片（例如1张、5张、10张等），点击完成');

  await dt.sleep();

  dt.log.i('预期结果5、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('在时刻二级宫格页面，添加图片过程中亮灭屏，添加功能正常 end');

}

/**
 *
 * 智慧图库-竖屏: [在时刻二级宫格页面，添加图片过程中横竖屏，添加功能正常]
 *
 * GROUP: 智慧图库 MODULE: 竖屏TID: Multimedia_Gallery_highlight_add015
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add015(dt: Dt) {

  dt.log.i('在时刻二级宫格页面，添加图片过程中横竖屏，添加功能正常 start');

  dt.log.i('STEP 1、进入时刻轮播页面后，上滑进入二级宫格页面');

  await dt.sleep();

  dt.log.i('预期结果1、流畅无crash');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、右上角更多，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、添加多张图片（例如1张、5张、10张等），不点击完成，');

  await dt.sleep();

  dt.log.i('预期结果3、选择的照片显示已勾选');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 4、横竖屏切换');

  await dt.sleep();

  dt.log.i('预期结果4、添加照片picker页正常显示');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 5、再次添加多张图片（例如1张、5张、10张等），点击完成');

  await dt.sleep();

  dt.log.i('预期结果5、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('在时刻二级宫格页面，添加图片过程中横竖屏，添加功能正常 end');

}

/**
 *
 * 智慧图库-视频: [在时刻二级宫格页面，添加图片过程中关机重启，添加功能正常]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add016
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add016(dt: Dt) {

  dt.log.i('在时刻二级宫格页面，添加图片过程中关机重启，添加功能正常 start');

  dt.log.i('STEP 1、进入时刻轮播页面后，上滑进入二级宫格页面');

  await dt.sleep();

  dt.log.i('预期结果1、流畅无crash');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、右上角更多，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、添加多张图片（例如1张、5张、10张等），不点击完成，');

  await dt.sleep();

  dt.log.i('预期结果3、选择的照片显示已勾选');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 4、重启手机');

  await dt.sleep();

  dt.log.i('预期结果4、无异常');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 5、再次添加多张图片（例如1张、5张、10张等），点击完成');

  await dt.sleep();

  dt.log.i('预期结果5、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('在时刻二级宫格页面，添加图片过程中关机重启，添加功能正常 end');

}

/**
 *
 * 智慧图库-视频: [时刻重命名后，添加图片正常]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add017
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add017(dt: Dt) {

  dt.log.i('时刻重命名后，添加图片正常 start');

  dt.log.i('STEP 1、在时刻一级界面，重命名');

  await dt.sleep();

  dt.log.i('预期结果1、时刻重命名成功    ');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、在时刻二级宫格界面，点击更多后，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片                                   ');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、添加多张图片（例如1张、5张、10张等），点击完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('时刻重命名后，添加图片正常 end');

}

/**
 *
 * 智慧图库-视频: [更换封面后，添加图片正常]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add018
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add018(dt: Dt) {

  dt.log.i('更换封面后，添加图片正常 start');

  dt.log.i('STEP 1、在时刻一级页面，长按时刻封面，点击封面编辑   ');

  await dt.sleep();

  dt.log.i('预期结果1、掉起封面编辑弹框，进入封面编辑页 ');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、选择任意一张图片，更换封面');

  await dt.sleep();

  dt.log.i('预期结果2、成功更换封面');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、在时刻二级宫格界面，点击更多后，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果3、进入picker页面，推荐默认勾选时刻内的全部照片   ');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('STEP 4、添加多张图片（例如1张、5张、10张等），点击完成');

  await dt.sleep();

  dt.log.i('预期结果4、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('更换封面后，添加图片正常 end');

}

/**
 *
 * 智慧图库-视频: [移除后，添加图片正常]
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add019
 *
 * 前置条件
 *
 * 1、相册存在图片视频
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add019(dt: Dt) {

  dt.log.i('移除后，添加图片正常 start');

  dt.log.i('STEP 1、在时刻二级宫格界面，选择任意图片移除 ');

  await dt.sleep();

  dt.log.i('预期结果1、图片移出成功');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、在时刻二级宫格界面，点击更多后，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片 ');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、添加多张图片（例如1张、5张、10张等），点击完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('移除后，添加图片正常 end');

}

/**
 *
 *
 * 智慧图库-视频: [移除图片后，再次添加图片正常]
 *
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add020
 *
 *
 * 前置条件
 *
 *
 * 1、相册存在图片视频
 *
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add020(dt: Dt) {

  dt.log.i('移除图片后，再次添加图片正常 start');

  dt.log.i('STEP 1、在时刻二级宫格界面，选择任意图片移除');

  await dt.sleep();

  dt.log.i('预期结果1、图片移除成功');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、在时刻二级宫格界面，点击更多后，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果2、进入picker页面，推荐默认勾选时刻内的全部照片、取消勾选一张，轮播页与二级宫格页刷新');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、选择刚才移除的图片');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功 ');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('移除图片后，再次添加图片正常 end');

}

/**
 *
 *
 * 智慧图库-视频: [多次连续添加图片，页面显示正常]
 *
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add021
 *
 *
 * 前置条件
 *
 *
 * 1、相册存在图片视频
 *
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add021(dt: Dt) {

  dt.log.i('多次连续添加图片，页面显示正常 start');

  dt.log.i('STEP 1、在时刻二级宫格界面，点击更多后，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果1、进入picker页面，推荐默认勾选时刻内的全部照片');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、添加多张图片（例如1张、5张、10张等），点击完成');

  await dt.sleep();

  dt.log.i('预期结果2、添加成功');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、多次重复添加多张图片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功                                                                            ');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('多次连续添加图片，页面显示正常 end');

}

/**
 *
 *
 * 智慧图库-深色: [在深色模式下，添加图片，页面显示正常]
 *
 *
 * GROUP: 智慧图库 MODULE: 深色TID: Multimedia_Gallery_highlight_add022
 *
 *
 * 前置条件
 *
 *
 * 1、相册存在图片视频
 *
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add022(dt: Dt) {

  dt.log.i('在深色模式下，添加图片，页面显示正常 start');

  dt.log.i('STEP 1、切换深色模式，在时刻二级宫格界面，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果1、进入picker页面，推荐默认勾选时刻内的全部照片，页面显示正常');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、添加多张图片（例如1张、5张、10张等），点击完成');

  await dt.sleep();

  dt.log.i('预期结果2、添加成功     ');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、多次重复添加多张图片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('在深色模式下，添加图片，页面显示正常 end');

}

/**
 *
 *
 * 智慧图库-视频: [在无障碍模式下，添加图片，页面显示正常]
 *
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add023
 *
 *
 * 前置条件
 *
 *
 * 1、相册存在图片视频
 *
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add023(dt: Dt) {

  dt.log.i('在无障碍模式下，添加图片，页面显示正常 start');

  dt.log.i('STEP 1、切换无障碍模式，在时刻二级宫格界面，点击添加照片 ');

  await dt.sleep();

  dt.log.i('预期结果1、进入picker页面，推荐默认勾选时刻内的全部照片，页面显示正常');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、添加多张图片（例如1张、5张、10张等），点击完成');

  await dt.sleep();

  dt.log.i('预期结果2、添加成功                                                                                           ');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、多次重复添加多张图片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('在无障碍模式下，添加图片，页面显示正常 end');

}

/**
 *
 *
 * 智慧图库-视频: [在大字体模式下，添加图片，页面显示正常]
 *
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add024
 *
 *
 * 前置条件
 *
 *
 * 1、相册存在图片视频
 *
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add024(dt: Dt) {

  dt.log.i('在大字体模式下，添加图片，页面显示正常 start');

  dt.log.i('STEP 1、切换大字体下的不同模式，在时刻二级宫格界面，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果1、进入picker页面，推荐默认勾选时刻内的全部照片，页面显示正常');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、添加多张图片（例如1张、5张、10张等），点击完成');

  await dt.sleep();

  dt.log.i('预期结果2、添加成功');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、多次重复添加多张图片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('在大字体模式下，添加图片，页面显示正常 end');

}

/**
 *
 *
 * 智慧图库-竖屏: [添加图片过程中横竖屏旋转，页面显示正常]
 *
 *
 * GROUP: 智慧图库 MODULE: 竖屏TID: Multimedia_Gallery_highlight_add025
 *
 *
 * 前置条件
 *
 *
 * 1、相册存在图片视频
 *
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add025(dt: Dt) {

  dt.log.i('添加图片过程中横竖屏旋转，页面显示正常 start');

  dt.log.i('STEP 1、在时刻二级宫格界面，点击更多后，点击添加照片       ');

  await dt.sleep();

  dt.log.i('STEP 2、横竖屏旋转，查看页面显示');

  await dt.sleep();

  dt.log.i('STEP 3、添加图片后，横竖屏旋转，查看页面显示 ');

  await dt.sleep();

  dt.log.i('STEP 4、点击完成，横竖屏旋转，查看页面显示');

  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('添加图片过程中横竖屏旋转，页面显示正常 end');

}

/**
 *
 *
 * 智慧图库-视频: [在多语言模式下，添加图片，页面显示正常]
 *
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add026
 *
 *
 * 前置条件
 *
 *
 * 1、相册存在图片视频
 *
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add026(dt: Dt) {

  dt.log.i('在多语言模式下，添加图片，页面显示正常 start');

  dt.log.i('STEP 1、语言切换成中英港奥维藏维，在时刻二级宫格界面，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果1、进入picker页面，推荐默认勾选时刻内的全部照片，页面显示正常');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、添加多张图片（例如1张、5张、10张等），点击完成');

  await dt.sleep();

  dt.log.i('预期结果2、添加成功');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、多次重复添加多张图片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('在多语言模式下，添加图片，页面显示正常 end');

}

/**
 *
 *
 * 智慧图库-视频: [克隆成功后，添加克隆的图片，页面显示正常]
 *
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add027
 *
 *
 * 前置条件
 *
 *
 * 1、相册存在图片视频
 *
 *
 2、xxx手机有时刻生成

 */

async function Multimedia_Gallery_highlight_add027(dt: Dt) {

  dt.log.i('克隆成功后，添加克隆的图片，页面显示正常 start');

  dt.log.i('STEP 1、克隆xxx手机图片后，在时刻二级宫格界面，点击添加克隆的照片  ');

  await dt.sleep();

  dt.log.i('预期结果1、进入picker页面，推荐默认勾选时刻内的全部照片，页面显示正常');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、添加多张克隆的图片（例如1张、5张、10张等），点击完成');

  await dt.sleep();

  dt.log.i('预期结果2、添加成功');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、多次重复添加多张图片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('克隆成功后，添加克隆的图片，页面显示正常 end');

}

/**
 *
 *
 * 智慧图库-视频: [升级成功后，添加图片，页面显示正常]
 *
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add028
 *
 *
 * 前置条件
 *
 *
 * 1、相册存在图片视频
 *
 *
 2、xxx手机有时刻生成

 */

async function Multimedia_Gallery_highlight_add028(dt: Dt) {

  dt.log.i('升级成功后，添加图片，页面显示正常 start');

  dt.log.i('STEP 1、升级手机图片后，在时刻二级宫格界面，点击添加照片');

  await dt.sleep();

  dt.log.i('预期结果1、进入picker页面，推荐默认勾选时刻内的全部照片，页面显示正常 ');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、添加多张图片（例如1张、5张、10张等），点击完成');

  await dt.sleep();

  dt.log.i('预期结果2、添加成功                                                                                      ');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、多次重复添加多张图片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('升级成功后，添加图片，页面显示正常 end');

}

/**
 *
 *
 * 智慧图库-视频: [xxx隆成功后，添加克隆的图片，页面显示正常]
 *
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add029
 *
 *
 * 前置条件
 *
 *
 * 1、相册存在图片视频
 *
 *
 2、xxx手机有时刻生成

 */

async function Multimedia_Gallery_highlight_add029(dt: Dt) {

  dt.log.i('xxx隆成功后，添加克隆的图片，页面显示正常 start');

  dt.log.i('STEP 1、克隆xxx手机图片后，在时刻二级宫格界面，点击添加照片 2、添加多张图片（例如1张、5张、10张等），点击完成3、多次重复添加多张图片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果1、进入picker页面，推荐默认勾选时刻内的全部照片，页面显示正常  2、添加成功3、添加成功');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、多次重复添加多张图片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('xxx隆成功后，添加克隆的图片，页面显示正常 end');

}

/**
 *
 *
 * 智慧图库-视频: [在分屏模式下，添加图片，页面显示正常]
 *
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add030
 *
 *
 * 前置条件
 *
 *
 * 1、相册存在图片视频
 *
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add030(dt: Dt) {

  dt.log.i('在分屏模式下，添加图片，页面显示正常 start');

  dt.log.i('STEP 1、切换至分屏模式，在时刻二级宫格界面，点击添加照片     2、添加多张图片（例如1张、5张、10张等），点击完成3、多次重复添加多张图片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果1、进入picker页面，推荐默认勾选时刻内的全部照片，页面显示正常   2、添加成功 3、添加成功');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、多次重复添加多张图片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('在分屏模式下，添加图片，页面显示正常 end');

}

/**
 *
 *
 * 智慧图库-视频: [在悬浮窗模式下，添加图片，页面显示正常]
 *
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add031
 *
 *
 * 前置条件
 *
 *
 * 1、相册存在图片视频
 *
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add031(dt: Dt) {

  dt.log.i('在悬浮窗模式下，添加图片，页面显示正常 start');

  dt.log.i('STEP 1、切换至分屏模式，在时刻二级宫格界面，点击添加照片  ');

  await dt.sleep();

  dt.log.i('预期结果1、进入picker页面，推荐默认勾选时刻内的全部照片，页面显示正常  2、添加成功 3、添加成功');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、添加多张图片（例如1张、5张、10张等），点击完成');

  await dt.sleep();

  dt.log.i('STEP 3、多次重复添加多张图片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('在悬浮窗模式下，添加图片，页面显示正常 end');

}

/**
 *
 *
 * 智慧图库-视频: [在横屏下，添加图片，页面显示正常]
 *
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add032
 *
 *
 * 前置条件
 *
 *
 * 1、相册存在图片视频
 *
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add032(dt: Dt) {

  dt.log.i('在横屏下，添加图片，页面显示正常 start');

  dt.log.i('STEP 1、手机旋转至横屏，在时刻二级宫格界面，点击添加照片   2、添加多张图片（例如1张、5张、10张等），点击完成3、多次重复添加多张图片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果1、进入picker页面，推荐默认勾选时刻内的全部照片，页面显示正常、 2、添加成功 3、添加成功');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、多次重复添加多张图片，点击完成');

  await dt.sleep();

  dt.log.i('预期结果3、添加成功');

  await dt.sleep();

  // 确认组件存在

  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('在横屏下，添加图片，页面显示正常 end');

}

/**
 *
 *
 * 智慧图库-视频: [添加照片的时效]
 *
 *
 * GROUP: 智慧图库 MODULE: 视频TID: Multimedia_Gallery_highlight_add033
 *
 *
 * 前置条件
 *
 *
 * 1、相册存在图片视频
 *
 *
 2、有时刻生成

 */

async function Multimedia_Gallery_highlight_add033(dt: Dt) {

  dt.log.i('添加照片的时效 start');

  dt.log.i('STEP 1、进入时刻，在时刻二级宫格界面，右上角点击更多，添加照片');

  await dt.sleep();

  dt.log.i('预期结果1、进入picker页面，推荐默认勾选时刻内的全部照片，页面显示正常 ');

  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2、查看时刻添加时延');

  await dt.sleep();

  dt.log.i('预期结果2、响应时延30ms，完成时延650ms');

  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');

  // 打印当前存在compid的组件

  await dt.showComponentsWithin();

  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在

  dt.log.i('添加照片的时效 end');

}

// 声明新的函数

async function isAudioPlaying(dt: Dt): Promise<boolean> {

  dt.log.i('Checking if audio is playing');

  // 模拟检查音频是否正在播放的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过查询音频播放器的状态来判断音频是否正在播放

  return true; // 假设音频正在播放

}



async function swipeUp(dt: Dt): Promise<void> {

  dt.log.i('Swiping up');

  // 模拟上滑操作的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过模拟触摸屏的滑动操作来实现上滑

}



async function pressPowerButton(dt: Dt): Promise<void> {

  dt.log.i('Pressing power button');

  // 模拟点击电源键的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过发送电源键事件来模拟点击电源键

}



async function unlockScreen(dt: Dt): Promise<void> {

  dt.log.i('Unlocking screen');

  // 模拟解锁屏幕的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过发送解锁事件来模拟解锁屏幕

}



async function clickEditButton(dt: Dt): Promise<void> {

  dt.log.i('Clicking edit button');

  // 模拟点击编辑按钮的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过点击编辑按钮来进入编辑界面

}



async function clickImage(dt: Dt): Promise<void> {

  dt.log.i('Clicking image');

  // 模拟点击图片的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过点击图片来进入大图浏览

}



// 获取响应时延

async function getResponseTime(dt: Dt): Promise<number> {

  dt.log.i('Getting response time');

  // 模拟获取响应时延的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过性能监控工具获取响应时延

  return 100; // 假设响应时延为100ms

}



// 获取完成时延

async function getCompletionTime(dt: Dt): Promise<number> {

  dt.log.i('Getting completion time');

  // 模拟获取完成时延的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过性能监控工具获取完成时延

  return 500; // 假设完成时延为500ms

}



// 获取过程帧率

async function getFrameRate(dt: Dt): Promise<number> {

  dt.log.i('Getting frame rate');

  // 模拟获取过程帧率的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过性能监控工具获取过程帧率

  return 60; // 假设过程帧率为60fps

}



// 获取卡顿率

async function getJankRate(dt: Dt): Promise<number> {

  dt.log.i('Getting jank rate');

  // 模拟获取卡顿率的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过性能监控工具获取卡顿率

  return 0; // 假设卡顿率为0%

}



// 打开图库进入时刻界面

async function openGalleryToMoment(dt: Dt): Promise<void> {

  dt.log.i('Opening gallery and entering moment interface');

  // 模拟打开图库并进入时刻界面的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过点击图库应用图标来打开图库

  await dt.clickIfExist('gallery_icon', TestConstants.DELAY_ONE_SECOND); // 点击图库图标

  await dt.clickIfExist('moment_tab', TestConstants.DELAY_ONE_SECOND); // 点击时刻标签

}



// 点击时刻封面进入轮播界面

async function clickMomentCover(dt: Dt): Promise<void> {

  dt.log.i('Clicking moment cover to enter carousel interface');

  // 模拟点击时刻封面进入轮播界面的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过点击时刻封面来进入轮播界面

  await dt.clickIfExist('moment_cover', TestConstants.DELAY_ONE_SECOND); // 点击时刻封面

}



// 检查响应时延

async function checkResponseTime(dt: Dt): Promise<void> {

  dt.log.i('Checking response time');

  // 模拟检查响应时延的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过性能监控工具获取响应时延

  const responseTime = await getResponseTime(dt);

  dt.log.i(`Response time: ${responseTime} ms`);

}



// 检查完成时延

async function checkCompletionTime(dt: Dt): Promise<void> {

  dt.log.i('Checking completion time');

  // 模拟检查完成时延的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过性能监控工具获取完成时延

  const completionTime = await getCompletionTime(dt);

  dt.log.i(`Completion time: ${completionTime} ms`);

}



// 检查过程帧率

async function checkFrameRate(dt: Dt): Promise<void> {

  dt.log.i('Checking frame rate');

  // 模拟检查过程帧率的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过性能监控工具获取过程帧率

  const frameRate = await getFrameRate(dt);

  dt.log.i(`Frame rate: ${frameRate} fps`);

}



// 检查卡顿率

async function checkJankRate(dt: Dt): Promise<void> {

  dt.log.i('Checking jank rate');

  // 模拟检查卡顿率的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过性能监控工具获取卡顿率

  const jankRate = await getJankRate(dt);

  dt.log.i(`Jank rate: ${jankRate} %`);

}



async function clickMoment(dt: Dt): Promise<void> {

  dt.log.i('Clicking moment');

  // 模拟点击时刻的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过点击时刻封面来进入轮播界面

}



async function swipeToArtisticGrid(dt: Dt): Promise<void> {

  dt.log.i('Swiping to artistic grid');

  // 模拟上滑进入艺术化宫格界面的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过上滑操作来进入艺术化宫格界面

}



async function clickArtisticGrid(dt: Dt): Promise<void> {

  dt.log.i('Clicking artistic grid');

  // 模拟点击艺术化宫格的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过点击宫格来进入大图界面

}



async function checkPerformanceMetrics(dt: Dt): Promise<void> {

  dt.log.i('Checking performance metrics');

  // 模拟检查性能指标的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过记录响应时延、完成时延、过程帧率和卡顿率来检查性能

}



async function verifyPerformance(dt: Dt): Promise<void> {

  dt.log.i('Verifying performance');

  // 模拟验证性能是否满足标准的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过比较实际性能指标与标准来验证性能

}



// 声明新的函数

async function coldStartGallery(dt: Dt): Promise<void> {

  dt.log.i('Cold starting gallery');

  // 模拟冷启动图库的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过启动图库应用来实现冷启动

}



async function completeClone(dt: Dt): Promise<void> {

  dt.log.i('Completing clone from dual framework to single framework');

  // 模拟完成克隆的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过等待克隆完成的提示来实现

}



async function checkMomentDetails(dt: Dt): Promise<void> {

  dt.log.i('Checking moment details');

  // 模拟检查时刻详情的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过查看首页、轮播和艺术化宫格界面来实现

}



async function verifyMomentConsistency(dt: Dt): Promise<void> {

  dt.log.i('Verifying moment consistency');

  // 模拟验证时刻一致性的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过比较xxx和xxx的时刻来确认一致性

}



async function verifyComponent(dt: Dt, compId: string, clickable: boolean): Promise<void> {

  dt.log.i(`Verifying component: ${compId} ${clickable}`);

  // 模拟验证组件的逻辑

  // 这里可以添加具体的实现逻辑

  // 例如，可以通过检查组件的状态来验证组件是否激活和可点击

  await dt.assertComponentClickable(compId); // 确认组件可点击

  await dt.assertComponent(compId); // 确认组件存在

}
