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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, Level } from '@ohos/hypium';
import { Component, Driver, On, ON, Point } from '@ohos.UiTest';
import { abilityDelegator, run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';


export default function multimediaGalleryAlbumsPresetAlbums001Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryAlbumsPresetAlbums001Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryAlbumsPresetAlbums001').init();
      dt.log.i('beforeAll MultimediaGalleryAlbumsPresetAlbums001 start');
      dt.log.i('beforeAll MultimediaGalleryAlbumsPresetAlbums001 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('MultimediaGalleryAlbumsPresetAlbums001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [相册页预制相册显示UX检视] TID: Multimedia_Gallery_Albums_PresetAlbums_001
      await multimediaGalleryAlbumsPresetAlbums001(dt);
    });

    run('MultimediaGalleryAlbumsPresetAlbums002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [覆盖不同格式图片/视频，预制相册显示] TID: Multimedia_Gallery_Albums_PresetAlbums_002
      await multimediaGalleryAlbumsPresetAlbums002(dt);
    });

    run('MultimediaGalleryAlbumsPresetAlbums003', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [截屏录屏的内容（图片、视频）显示在预制相册中，有截屏录屏相册] TID: Multimedia_Gallery_Albums_PresetAlbums_003
      await multimediaGalleryAlbumsPresetAlbums003(dt);
    });

    run('MultimediaGalleryAlbumsPresetAlbums004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [相机拍摄的内容（图片、视频）显示在预制相册中，有相机相册] TID: Multimedia_Gallery_Albums_PresetAlbums_004
      await multimediaGalleryAlbumsPresetAlbums004(dt);
    });

    run('MultimediaGalleryAlbumsPresetAlbums007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [收藏的内容（图片、视频）显示在我的收藏相册中] TID: Multimedia_Gallery_Albums_PresetAlbums_007
      await multimediaGalleryAlbumsPresetAlbums007(dt);
    });

    run('MultimediaGalleryAlbumsPresetAlbums008', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [预置相册不支持重命名、不支持删除相册操作] TID: Multimedia_Gallery_Albums_PresetAlbums_008
      await multimediaGalleryAlbumsPresetAlbums008(dt);
    });

    run('MultimediaGalleryAlbumsPresetAlbums009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库有1个图片时，图片相册自动刷新显示] TID: Multimedia_Gallery_Albums_PresetAlbums_009
      await multimediaGalleryAlbumsPresetAlbums009(dt);
    });

    run('MultimediaGalleryAlbumsPresetAlbums010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [图库有1个视频时，视频相册自动刷新显示] TID: Multimedia_Gallery_Albums_PresetAlbums_010
      await multimediaGalleryAlbumsPresetAlbums010(dt);
    });

    run('MultimediaGalleryAlbumsPresetAlbums011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [收藏1个图片/视频时，收藏相册自动刷新显示] TID: Multimedia_Gallery_Albums_PresetAlbums_011
      await multimediaGalleryAlbumsPresetAlbums011(dt);
    });

    run('MultimediaGalleryAlbumsPresetAlbums012', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [图片相册内容全部删除，图片相册自动消失] TID: Multimedia_Gallery_Albums_PresetAlbums_012
      await multimediaGalleryAlbumsPresetAlbums012(dt);
    });

    run('MultimediaGalleryAlbumsPresetAlbums013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [视频相册内容全部删除，视频相册自动消失] TID: Multimedia_Gallery_Albums_PresetAlbums_013
      await multimediaGalleryAlbumsPresetAlbums013(dt);
    });

    run('MultimediaGalleryAlbumsPresetAlbums014', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [内容全部删除/全部取消收藏，我的收藏相册自动消失] TID: Multimedia_Gallery_Albums_PresetAlbums_014
      await multimediaGalleryAlbumsPresetAlbums014(dt);
    });

    run('MultimediaGalleryAlbumsPresetAlbums015', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [从最近删除相册恢复1个图片、1个视频时，预制相册恢复显示] TID: Multimedia_Gallery_Albums_PresetAlbums_015
      await multimediaGalleryAlbumsPresetAlbums015(dt);
    });

    run('MultimediaGalleryAlbumsPresetAlbums016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [小语种下预制相册显示] TID: Multimedia_Gallery_Albums_PresetAlbums_016
      await multimediaGalleryAlbumsPresetAlbums016(dt);
    });

    run('MultimediaGalleryAlbumsPresetAlbums017', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-深色用例: [深色模式下预制相册显示] TID: Multimedia_Gallery_Albums_PresetAlbums_017
      await multimediaGalleryAlbumsPresetAlbums017(dt);
    });

    run('MultimediaGalleryAlbumsPresetAlbums018', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [预置相册用户行为打点测试] TID: Multimedia_Gallery_Albums_PresetAlbums_018
      await multimediaGalleryAlbumsPresetAlbums018(dt);
    });

    run('MultimediaGalleryAlbumsPresetAlbums019', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [预制相册内容全部删除再全部恢复，操作100次正常] TID: Multimedia_Gallery_Albums_PresetAlbums_019
      await multimediaGalleryAlbumsPresetAlbums019(dt);
    });

    run('MultimediaGalleryAlbumsrename001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [创建相册时支持重命名] TID: Multimedia_Gallery_Albums_rename_001
      await multimediaGalleryAlbumsrename001(dt);
    });

    run('MultimediaGalleryAlbumsrename002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [用户创建相册勾选1个支持重命名，勾选多个或勾选了非用户创建相册时不支持重命名] TID: Multimedia_Gallery_Albums_rename_002
      await multimediaGalleryAlbumsrename002(dt);
    });

    run('MultimediaGalleryAlbumsrename004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [用户创建相册之间，禁止同名] TID: Multimedia_Gallery_Albums_rename_004
      await multimediaGalleryAlbumsrename004(dt);
    })

    run('MultimediaGalleryAlbumsrename005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
        //  宫格-收藏用例: [用户创建相册与预制相册（图片、视频、我的收藏）之间，支持同名（有且仅有1个）] TID: Multimedia_Gallery_Albums_rename_005
        await multimediaGalleryAlbumsrename005(dt);
      });

    run('MultimediaGalleryAlbumsUXcheck0001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [相机、截图、屏幕录制相册UX检查] TID: Multimedia_Gallery_Albums_UX_check_0001
      await multimediaGalleryAlbumsUXcheck0001(dt);
    });

    run('MultimediaGalleryAlbumsUXcheck0002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [xxxxxx，相机、截图、屏幕录制相册布局显示验证] TID: Multimedia_Gallery_Albums_UX_check_0002
      await multimediaGalleryAlbumsUXcheck0002(dt);
    });

    run('MultimediaGalleryAlbumsUXcheck0003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [xxx，相机、截图、屏幕录制相册布局显示验证] TID: Multimedia_Gallery_Albums_UX_check_0003
      await multimediaGalleryAlbumsUXcheck0003(dt);
    });

    run('MultimediaGalleryAlbumsUXcheck0004', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [xxx横屏xxx，相机、截图、屏幕录制相册布局显示验证] TID: Multimedia_Gallery_Albums_UX_check_0004
      await multimediaGalleryAlbumsUXcheck0004(dt);
    });

    run('MultimediaGalleryAlbumsUXcheck0005', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [verde设备xxx相机、截图、屏幕录制相册布局显示验证] TID: Multimedia_Gallery_Albums_UX_check_0005
      await multimediaGalleryAlbumsUXcheck0005(dt);
    });

    run('MultimediaGalleryAlbumsUXcheck0006', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [verde设备xxx相机、截图、屏幕录制相册布局显示验证] TID: Multimedia_Gallery_Albums_UX_check_0006
      await multimediaGalleryAlbumsUXcheck0006(dt);
    });

    run('MultimediaGalleryAlbumsUXcheck0007', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [相机、截图、屏幕录制相册PAD布局显示验证] TID: Multimedia_Gallery_Albums_UX_check_0007
      await multimediaGalleryAlbumsUXcheck0007(dt);
    });

    /**
      * 确保每次测试完毕回到大图页
      */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachMultimediaGalleryAlbumsPresetAlbums001').init();
      dt.log.i('afterEach MultimediaGalleryAlbumsPresetAlbums001 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryAlbumsPresetAlbums001 finish');
    });

    /**
      * 退出大图 回到时间线页面
      */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllMultimediaGalleryAlbumsPresetAlbums001').init();
      dt.log.i('afterAll MultimediaGalleryAlbumsPresetAlbums001 start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryAlbumsPresetAlbums001 finish');
    });
  });
}

/**
 * 宫格-收藏: [相册页预制相册显示UX检视]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_PresetAlbums_001
 * 前置条件
 * 1、图库中存在预置相册（图片、视频、我的收藏）
 */
async function multimediaGalleryAlbumsPresetAlbums001(dt: Dt) {
  dt.log.i('相册页预制相册显示UX检视 start');
  dt.log.i('STEP 1、相册页预制相册（图片、视频、我的收藏相册）显示查看');

  await dt.sleep();
  dt.log.i('预期结果1、三个相册默认显示在相册页顶部，默认顺序是图片、视频、我的收藏；显示符合UX设计；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入预制相册（图片、视频、我的收藏），查看显示');

  await dt.sleep();
  dt.log.i('预期结果2、预置相册宫格页显示符合UX设计；所有相册中的照片和视频全部按照文件创建时间排序；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、创建1个新相册、删除1个图片，查看相册页显示');

  await dt.sleep();
  dt.log.i('预期结果3、新建相册、最近删除相册显示在预制相册后面');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页预制相册显示UX检视 end');
}

/**
 * 宫格-格式: [覆盖不同格式图片/视频，预制相册显示]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Albums_PresetAlbums_002
 * 前置条件
 * 1、图库中预置覆盖不同格式图片、视频
 */
async function multimediaGalleryAlbumsPresetAlbums002(dt: Dt) {
  dt.log.i('覆盖不同格式图片/视频，预制相册显示 start');
  dt.log.i('STEP 1、预置不同格式图片，查看图片相册显示（大图、宫格页）');

  await dt.sleep();
  dt.log.i('预期结果1 2 3、显示所有支持的不同格式的图片和视频，宫格页显示正常，大图显示正常，视频播放正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、预置不同格式视频，查看视频相册显示（大图、宫格页、播放）');

  await dt.sleep();
  dt.log.i('STEP 3、从照片页/图片相册/视频相册中，收藏不同格式图片视频，查看收藏视频显示（大图、宫格页）');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('覆盖不同格式图片/视频，预制相册显示 end');
}

/**
 * 宫格-视频: [截屏录屏的内容（图片、视频）显示在预制相册中，有截屏录屏相册]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Albums_PresetAlbums_003
 * 前置条件
 * 1、图库中存在预置相册（图片、视频、我的收藏）
 */
async function multimediaGalleryAlbumsPresetAlbums003(dt: Dt) {
  dt.log.i('截屏录屏的内容（图片、视频）显示在预制相册中，有截屏录屏相册 start');
  dt.log.i('STEP 1、进行截屏、录屏，操作1次/多次');

  await dt.sleep();
  dt.log.i('STEP 2、查看相册页显示、预制相册（图片、视频）显示');

  await dt.sleep();
  dt.log.i('预期结果2、截屏显示在图片相册中，录屏显示在视频相册中；截图相册和录屏相册图片数量对应增加');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('截屏录屏的内容（图片、视频）显示在预制相册中，有截屏录屏相册 end');
}

/**
 * 宫格-视频: [相机拍摄的内容（图片、视频）显示在预制相册中，有相机相册]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Albums_PresetAlbums_004
 * 前置条件
 * 1、图库中存在预置相册（图片、视频、我的收藏）
 */
async function multimediaGalleryAlbumsPresetAlbums004(dt: Dt) {
  dt.log.i('相机拍摄的内容（图片、视频）显示在预制相册中，有相机相册 start');
  dt.log.i('STEP 1、打开相机拍摄照片和视频（不同分辨率、不同比例、不同模式等）（单个+多个）');

  await dt.sleep();
  dt.log.i('STEP 2、查看相册页显示、预制相册（图片、视频）显示');

  await dt.sleep();
  dt.log.i('预期结果2、相机照片显示在图片相册中，相机视频显示在视频相册中；相机相册图片数量对应增加');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机拍摄的内容（图片、视频）显示在预制相册中，有相机相册 end');
}

/**
 * 宫格-收藏: [收藏的内容（图片、视频）显示在我的收藏相册中]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_PresetAlbums_007
 * 前置条件
 * 1、图库中预置覆盖不同格式图片、视频
 */
async function multimediaGalleryAlbumsPresetAlbums007(dt: Dt) {
  dt.log.i('收藏的内容（图片、视频）显示在我的收藏相册中 start');
  dt.log.i('STEP 1、从图片相册中，打开不同格式的图片大图，点击收藏');

  await dt.sleep();
  dt.log.i('预期结果1、显示已收藏的所有格式图片类型，其他未收藏图片不显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从视频相册中，打开不同格式的视频大图，点击收藏');

  await dt.sleep();
  dt.log.i('预期结果2、显示已收藏的所有格式视频类型，其他未收藏视频不显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、从照片页，收藏不同格式图片和视频');

  await dt.sleep();
  dt.log.i('预期结果3、照片页图片、视频收藏后，在收藏相册中显示，收藏相册个数增加；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、操作1/2/3后，查看收藏相册显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('收藏的内容（图片、视频）显示在我的收藏相册中 end');
}

/**
 * 宫格-删除: [预置相册不支持重命名、不支持删除相册操作]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Albums_PresetAlbums_008
 * 前置条件
 * 1、图库中存在预置相册（图片、视频、我的收藏）、用户新建相册
 */
async function multimediaGalleryAlbumsPresetAlbums008(dt: Dt) {
  dt.log.i('预置相册不支持重命名、不支持删除相册操作 start');
  dt.log.i('STEP 1、相册页点击更多多选，勾选/去勾选，查看预置相册（图片、视频、我的收藏）是否可以勾选');

  await dt.sleep();
  dt.log.i('预期结果1、预制相册无法勾选，底部菜单中重命名、删除按钮置灰，不可点击；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、相册页点击更多多选，勾选用户创建相册，查看');

  await dt.sleep();
  dt.log.i('预期结果2、底部菜单中重命名、删除按钮不置灰，可点击');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('预置相册不支持重命名、不支持删除相册操作 end');
}

/**
 * 宫格-: [图库有1个图片时，图片相册自动刷新显示]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_Albums_PresetAlbums_009
 * 前置条件
 * 1、图库没有图片文件
 */
async function multimediaGalleryAlbumsPresetAlbums009(dt: Dt) {
  dt.log.i('图库有1个图片时，图片相册自动刷新显示 start');
  dt.log.i('STEP 1、相机拍摄/截屏录屏/三方应用保存/分享接收1张图片');

  await dt.sleep();
  dt.log.i('STEP 2、查看相册页；');

  await dt.sleep();
  dt.log.i('预期结果2、相册页图片相册自动刷新显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、继续操作1、2，查看图片相册');

  await dt.sleep();
  dt.log.i('预期结果3、图片相册个数增加，宫格页图片按创建时间排序显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库有1个图片时，图片相册自动刷新显示 end');
}

/**
 * 宫格-视频: [图库有1个视频时，视频相册自动刷新显示]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Albums_PresetAlbums_010
 * 前置条件
 * 1、图库没有视频文件
 */
async function multimediaGalleryAlbumsPresetAlbums010(dt: Dt) {
  dt.log.i('图库有1个视频时，视频相册自动刷新显示 start');
  dt.log.i('STEP 1、相机拍摄/截屏录屏/三方应用保存/分享接收1张视频');

  await dt.sleep();
  dt.log.i('STEP 2、查看相册页；');

  await dt.sleep();
  dt.log.i('预期结果2、相册页视频相册自动刷新显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、继续操作1、2，查看视频相册');

  await dt.sleep();
  dt.log.i('预期结果3、视频相册个数增加，宫格页视频按创建时间排序显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库有1个视频时，视频相册自动刷新显示 end');
}

/**
 * 宫格-收藏: [收藏1个图片/视频时，收藏相册自动刷新显示]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_PresetAlbums_011
 * 前置条件
 * 1、图库中存在预置相册（图片、视频）、用户新建相册
 */
async function multimediaGalleryAlbumsPresetAlbums011(dt: Dt) {
  dt.log.i('收藏1个图片/视频时，收藏相册自动刷新显示 start');
  dt.log.i('STEP 1、进入图片相册，收藏1个图片');

  await dt.sleep();
  dt.log.i('STEP 2、或进入视频相册，收藏1个视频');

  await dt.sleep();
  dt.log.i('STEP 3、或进入新建相册，收藏1个图片/视频');

  await dt.sleep();
  dt.log.i('STEP 4、操作1/2/3后，返回相册页查看');

  await dt.sleep();
  dt.log.i('预期结果4、相册页我的收藏相册自动刷新显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、继续操作，查看收藏相册');

  await dt.sleep();
  dt.log.i('预期结果5、收藏相册个数增加，宫格页图片/视频按创建时间排序显示，收藏标记显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('收藏1个图片/视频时，收藏相册自动刷新显示 end');
}

/**
 * 宫格-删除: [图片相册内容全部删除，图片相册自动消失]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Albums_PresetAlbums_012
 * 前置条件
 * 1、图库中存在图片相册
 */
async function multimediaGalleryAlbumsPresetAlbums012(dt: Dt) {
  dt.log.i('图片相册内容全部删除，图片相册自动消失 start');
  dt.log.i('STEP 1、进入图片相册，首张图片进入大图-点击删除，逐个遍历操作，直到所有图片删除');

  await dt.sleep();
  dt.log.i('STEP 2、或进入图片相册，点击更多多选，进入多选模式，全选删除2、操作步骤1/2后，返回相册页查看');

  await dt.sleep();
  dt.log.i('预期结果3、相册页图片相册自动消失，不显示空相册');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片相册内容全部删除，图片相册自动消失 end');
}

/**
 * 宫格-删除: [视频相册内容全部删除，视频相册自动消失]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Albums_PresetAlbums_013
 * 前置条件
 * 1、图库中存在视频相册
 */
async function multimediaGalleryAlbumsPresetAlbums013(dt: Dt) {
  dt.log.i('视频相册内容全部删除，视频相册自动消失 start');
  dt.log.i('STEP 1、进入视频相册，首张图片进入大图-点击删除，逐个遍历操作，直到所有视频删除');

  await dt.sleep();
  dt.log.i('STEP 2、或进入视频相册，点击更多多选，进多选模式，全选删除2、操作步骤1/2后，返回相册页查看');

  await dt.sleep();
  dt.log.i('预期结果3、相册页视频相册自动消失，不显示空相册');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频相册内容全部删除，视频相册自动消失 end');
}

/**
 * 宫格-收藏: [内容全部删除/全部取消收藏，我的收藏相册自动消失]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_PresetAlbums_014
 * 前置条件
 * 1、图库中存在收藏相册
 */
async function multimediaGalleryAlbumsPresetAlbums014(dt: Dt) {
  dt.log.i('内容全部删除/全部取消收藏，我的收藏相册自动消失 start');
  dt.log.i('STEP 1、进入我的收藏相册，首张照片进入大图-点击删除/取消收藏，逐个遍历操作，直到所有图片、视频删除/取消收藏');

  await dt.sleep();
  dt.log.i('STEP 2、或进入我的收藏相册，点击更多多选，进多选模式，全选删除');

  await dt.sleep();
  dt.log.i('STEP 3、或进入图片、视频相册中，将已收藏的图片、视频全部删除');

  await dt.sleep();
  dt.log.i('STEP 4、操作步骤1/2/3后，返回相册页查看');

  await dt.sleep();
  dt.log.i('预期结果4、相册页我的收藏相册自动消失，不显示空相册');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('内容全部删除/全部取消收藏，我的收藏相册自动消失 end');
}

/**
 * 宫格-删除: [从最近删除相册恢复1个图片、1个视频时，预制相册恢复显示]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Albums_PresetAlbums_015
 * 前置条件
 * 1、图库预置相册（图片、视频、我的收藏）内容已全部删除
 */
async function multimediaGalleryAlbumsPresetAlbums015(dt: Dt) {
  dt.log.i('从最近删除相册恢复1个图片、1个视频时，预制相册恢复显示 start');
  dt.log.i('STEP 1、进入最近删除相册，大图恢复1张图片、1个视频（未收藏）');

  await dt.sleep();
  dt.log.i('STEP 2、再恢复1张图片/视频（已收藏）');

  await dt.sleep();
  dt.log.i('STEP 3、操作1、2后，返回相册页查看');

  await dt.sleep();
  dt.log.i('预期结果3、相册页预置相册（图片、视频、我的收藏）恢复显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('从最近删除相册恢复1个图片、1个视频时，预制相册恢复显示 end');
}

/**
 * 宫格-收藏: [小语种下预制相册显示]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_PresetAlbums_016
 * 前置条件
 * 1、图库中存在预置相册（图片、视频、我的收藏）
 */
async function multimediaGalleryAlbumsPresetAlbums016(dt: Dt) {
  dt.log.i('小语种下预制相册显示 start');
  dt.log.i('STEP 1、进入相册页查看，确认当前预置相册照片数量');

  await dt.sleep();
  dt.log.i('预期结果1 3、预置相册名称为简体中文、照片数量无变化，用户创建相册名称保持不变，显示符合UX设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、图库退到后台，设置系统语言为英文，再次进入相册页查看');

  await dt.sleep();
  dt.log.i('预期结果2、预置相册名称变为英文、照片数量无变化，用户创建相册名称保持不变，显示符合UX设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、设置系统语言为中文，再次进入相册页查看');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('小语种下预制相册显示 end');
}

/**
 * 宫格-深色: [深色模式下预制相册显示]
 * GROUP: 宫格 MODULE: 深色TID: Multimedia_Gallery_Albums_PresetAlbums_017
 * 前置条件
 * 1、图库中存在预置相册（图片、视频、我的收藏）
 */
async function multimediaGalleryAlbumsPresetAlbums017(dt: Dt) {
  dt.log.i('深色模式下预制相册显示 start');
  dt.log.i('STEP 1、下拉控制中心，切换深色模式');

  await dt.sleep();
  dt.log.i('预期结果1、预制相册深色模式显示正常，显示符合UX设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入相册页查看');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('深色模式下预制相册显示 end');
}

/**
 * 宫格-收藏: [预置相册用户行为打点测试]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_PresetAlbums_018
 * 前置条件
 * 1、图库中存在预置相册（图片、视频、我的收藏）
 */
async function multimediaGalleryAlbumsPresetAlbums018(dt: Dt) {
  dt.log.i('预置相册用户行为打点测试 start');
  dt.log.i('STEP 1）打开图片、视频、收藏预制相册次数，按天上报1.1、第一天：从相册页打开预置相册（图片、视频、我的收藏）多次（分别是3次、4次、5次）；1.2、重新设置系统时间到第二天/隔好几天：从相册页再打开预置相册触发上报，使用命令查看，预制相册打开次数打点信息1.3、操作步骤1.1、1.2，重复测试3次');

  await dt.sleep();
  dt.log.i('预期结果1.3、上报预制相册打点次数，且次数正确，符合开发打点设计信息；非频繁上报打点，每次只上报最新的预制相册打开次数，不累加上一次；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2）预制相册出现、消失事件打点上报2.1、空图库，预置相册（图片、视频、我的收藏）有内容时刷新显示后，查看打点2.2、预置相册（图片、视频、我的收藏）内容全部删除/全部取消后，查看打点2.3、再从最近删除相册恢复图片、视频（已收藏、未收藏）时，查看打点2.4、操作步骤2.1、2.2、2.3，重复测试3次');

  await dt.sleep();
  dt.log.i('预期结果2.1 2.2 2.3、三个预制相册每次出现时次数+1，每次消失时次数+1；测试3次，打点次数累加；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('预置相册用户行为打点测试 end');
}

/**
 * 宫格-删除: [预制相册内容全部删除再全部恢复，操作100次正常]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Albums_PresetAlbums_019
 * 前置条件
 * 1、图库中存在预置相册（图片、视频、我的收藏）
 2、预制相册中各预置10个文件
 */
async function multimediaGalleryAlbumsPresetAlbums019(dt: Dt) {
  dt.log.i('预制相册内容全部删除再全部恢复，操作100次正常 start');
  dt.log.i('STEP 1、打开预置相册（图片、视频、我的收藏），内容全部删除');

  await dt.sleep();
  dt.log.i('预期结果1、预制相册自动刷新不显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入最近删除相册，全部恢复');

  await dt.sleep();
  dt.log.i('预期结果2、预制相册自动刷新重新显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、反复操作100次');

  await dt.sleep();
  dt.log.i('预期结果3、反复操作，相册页显示正常，无异常crash');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('预制相册内容全部删除再全部恢复，操作100次正常 end');
}

/**
 * 宫格-收藏: [创建相册时支持重命名]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_rename_001
 * 前置条件
 * 1、图库有预制相册（图片、视频、我的收藏）
 */
async function multimediaGalleryAlbumsrename001(dt: Dt) {
  dt.log.i('创建相册时支持重命名 start');
  dt.log.i('STEP 1、相册页点击“+”新建相册，对相册命名（同名、不同名），点击确认；拉起Picker（所有照片）界面-勾选图片/视频-点击“完成”');

  await dt.sleep();
  dt.log.i('预期结果1、与已存在用户创建相册，同名时，命名失败，提示“此名称已被使用”，可继续修改名称；不同名时，直接创建，进入添加照片的引导界面（Picker界面），显示符合UX设计；点击”完成”，拉起新创建的相册界面，相册名显示修改后的名称；');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('此名称已被使用'));
  dt.log.i('STEP 2、不同入口（如照片页、预制相册等）操作移动/添加文件时创建相册，对相册命名，点击确认；');

  await dt.sleep();
  dt.log.i('预期结果2、同名时，修改名称失败，提示“此名称已被使用”；不同名时，直接进行添加/移动');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('此名称已被使用'));
  dt.log.i('STEP 3、返回相册页查看');

  await dt.sleep();
  dt.log.i('预期结果3、相册创建成功，相册名显示修改后的名称；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('创建相册时支持重命名 end');
}

/**
 * 宫格-收藏: [用户创建相册勾选1个支持重命名，勾选多个或勾选了非用户创建相册时不支持重命名]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_rename_002
 * 前置条件
 * 1、图库有预制相册（图片、视频、我的收藏）
 2、图库有1个/多个用户创建相册（图片+视频）
 */
async function multimediaGalleryAlbumsrename002(dt: Dt) {
  dt.log.i('用户创建相册勾选1个支持重命名，勾选多个或勾选了非用户创建相册时不支持重命名 start');
  dt.log.i('STEP 1、相册页-点击更多多选，进入多选');

  await dt.sleep();
  dt.log.i('STEP 2、只勾选1个用户创建相册，点击重命名，查看；修改名称后-点击确认，查看结果');

  await dt.sleep();
  dt.log.i('预期结果2、底部菜单中，重命名高亮显示，点击重命名-可弹出重命名弹框，显示符合UX设计；修改名称点击确认后，返回相册页，只刷新相册名称，相册封面保持不动；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、勾选2个用户创建相册时，点击重命名');

  await dt.sleep();
  dt.log.i('预期结果3 4、重命名icon置灰显示，不可点击5、重命名恢复高亮显示，点击重命名-可弹出重命名弹框，显示符合UX设计；修改名称点击确认后，返回相册页，只刷新相册名称，相册封面保持不动；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、勾选1个用户创建相册，又勾选了预置相册/最近删除相册时，点击重命名');

  await dt.sleep();
  dt.log.i('STEP 5、去掉多余勾选时，点击重命名，查看；修改名称后-点击确认，查看结果');

  await dt.sleep();
  dt.log.i('预期结果5、重命名恢复高亮显示，点击重命名-可弹出重命名弹框，显示符合UX设计；修改名称点击确认后，返回相册页，只刷新相册名称，相册封面保持不动；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户创建相册勾选1个支持重命名，勾选多个或勾选了非用户创建相册时不支持重命名 end');
}

/**
 * 宫格-收藏: [用户创建相册之间，禁止同名]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_rename_004
 * 前置条件
 * 1、图库有预制相册（图片、视频、我的收藏）
 2、图库有1个/多个用户创建相册（图片+视频）
 */
async function multimediaGalleryAlbumsrename004(dt: Dt) {
  dt.log.i('用户创建相册之间，禁止同名 start');
  dt.log.i('STEP 1、新建1个相册（默认名称“新建相册1”）');

  await dt.sleep();
  dt.log.i('预期结果1、新建相册成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、再新建1个，修改命名为“新建相册1”，点击确认');

  await dt.sleep();
  dt.log.i('预期结果2 3、重命名失败，提示“此名称已被使用”，符合UX设计');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('此名称已被使用'));
  dt.log.i('STEP 3、选择1个相册重命名，修改命名为“新建相册1”，点击确认');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户创建相册之间，禁止同名 end');
}

/**
 * 宫格-收藏: [用户创建相册与预制相册（图片、视频、我的收藏）之间，支持同名（有且仅有1个）]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_rename_005
 * 前置条件
 * 1、图库预制相册，没有新建相册
 */
async function multimediaGalleryAlbumsrename005(dt: Dt) {
  dt.log.i('用户创建相册与预制相册（图片、视频、我的收藏）之间，支持同名（有且仅有1个） start');
  dt.log.i('STEP 1、进入相册页，点击“+”创建相册，修改输入框默认名称，首次命名为“图片/视频/我的收藏/最近删除”时，点击确认');

  await dt.sleep();
  dt.log.i('预期结果1、重命名成功，拉起添加照片引导界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、第二次创建相册，再命名为“图片/视频/我的收藏/最近删除”时，点击确认');

  await dt.sleep();
  dt.log.i('预期结果2、命名失败，提示“此名称已被使用”，符合UX设计');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('此名称已被使用'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户创建相册与预制相册（图片、视频、我的收藏）之间，支持同名（有且仅有1个） end');
}

/**
 * 宫格-收藏: [相机、截图、屏幕录制相册UX检查]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_UX_check_0001
 * 前置条件
 * 1.图库相册页已存在图片、视频、我的收藏、相机、截图、屏幕录制相册
 */
async function multimediaGalleryAlbumsUXcheck0001(dt: Dt) {
  dt.log.i('相机、截图、屏幕录制相册UX检查 start');
  dt.log.i('STEP 1.打开图库-相册页，检查相机、截图、屏幕录制相册；');

  await dt.sleep();
  dt.log.i('预期结果1&2&3&4&5.相册页--系统相册区域--按图片、视频、我的收藏、相机、截图、屏幕录制相册顺序展示在相册页最前，显示符合UX设计；来源相册区域不显示系统生成的相机、截图、屏幕录制相册；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.双指手势放大相册页，检查显示；');

  await dt.sleep();
  dt.log.i('STEP 3.双指手势缩小相册页，检查显示；');

  await dt.sleep();
  dt.log.i('STEP 4.旋转屏幕，检查显示；');

  await dt.sleep();
  dt.log.i('STEP 5.图库分别切换到悬浮窗、1/2屏、1/3屏，横屏左右分屏检查显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机、截图、屏幕录制相册UX检查 end');
}

/**
 * 宫格-收藏: [xxxxxx，相机、截图、屏幕录制相册布局显示验证]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_UX_check_0002
 * 前置条件
 * 1.xxx测试机图库已预置相机、截图、屏幕录制相册，已预置图片、视频
 2.xxx为xxx
 */
async function multimediaGalleryAlbumsUXcheck0002(dt: Dt) {
  dt.log.i('xxxxxx，相机、截图、屏幕录制相册布局显示验证 start');
  dt.log.i('STEP 1.打开图库-相册页，检查布局显示');

  await dt.sleep();
  dt.log.i('预期结果1.系统相册区域--按图片、视频、我的收藏、相机、截图、屏幕录制相册顺序展示在相册页最前，显示无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxxxxx，相机、截图、屏幕录制相册布局显示验证 end');
}

/**
 * 宫格-收藏: [xxx，相机、截图、屏幕录制相册布局显示验证]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_UX_check_0003
 * 前置条件
 * 1.xxx测试机图库已预置相机、截图、屏幕录制相册，已预置图片、视频
 2.xxx为xxx
 */
async function multimediaGalleryAlbumsUXcheck0003(dt: Dt) {
  dt.log.i('xxx，相机、截图、屏幕录制相册布局显示验证 start');
  dt.log.i('STEP 1.打开图库-相册页，检查布局显示');

  await dt.sleep();
  dt.log.i('预期结果1.系统相册区域--按图片、视频、我的收藏、相机、截图、屏幕录制相册顺序展示在相册页最前，显示无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxx，相机、截图、屏幕录制相册布局显示验证 end');
}

/**
 * 宫格-收藏: [xxx横屏xxx，相机、截图、屏幕录制相册布局显示验证]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_UX_check_0004
 * 前置条件
 * 1.xxx测试机图库已预置相机、截图、屏幕录制相册，已预置图片、视频
 2.xxx为横屏xxx
 3.旋转锁定按钮已关闭
 */
async function multimediaGalleryAlbumsUXcheck0004(dt: Dt) {
  dt.log.i('xxx横屏xxx，相机、截图、屏幕录制相册布局显示验证 start');
  dt.log.i('STEP 1.打开图库-相册页，检查布局显示');

  await dt.sleep();
  dt.log.i('预期结果1.系统相册区域--按图片、视频、我的收藏、相机、截图、屏幕录制相册顺序展示在相册页最前，显示无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxx横屏xxx，相机、截图、屏幕录制相册布局显示验证 end');
}

/**
 * 宫格-收藏: [verde设备xxx相机、截图、屏幕录制相册布局显示验证]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_UX_check_0005
 * 前置条件
 * 1.xxx测试机图库已预置相机、截图、屏幕录制相册，已预置图片、视频
 2.verde设备为xxx
 */
async function multimediaGalleryAlbumsUXcheck0005(dt: Dt) {
  dt.log.i('verde设备xxx相机、截图、屏幕录制相册布局显示验证 start');
  dt.log.i('STEP 1.打开图库-相册页，检查布局显示');

  await dt.sleep();
  dt.log.i('预期结果1.系统相册区域--按图片、视频、我的收藏、相机、截图、屏幕录制相册顺序展示在相册页最前，显示无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('verde设备xxx相机、截图、屏幕录制相册布局显示验证 end');
}

/**
 * 宫格-收藏: [verde设备xxx相机、截图、屏幕录制相册布局显示验证]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_UX_check_0006
 * 前置条件
 * 1.xxx测试机图库已预置相机、截图、屏幕录制相册，已预置图片、视频
 2.verde设备为xxx
 */
async function multimediaGalleryAlbumsUXcheck0006(dt: Dt) {
  dt.log.i('verde设备xxx相机、截图、屏幕录制相册布局显示验证 start');
  dt.log.i('STEP 1.打开图库-相册页，检查布局显示');

  await dt.sleep();
  dt.log.i('预期结果1.系统相册区域--按图片、视频、我的收藏、相机、截图、屏幕录制相册顺序展示在相册页最前，显示无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('verde设备xxx相机、截图、屏幕录制相册布局显示验证 end');
}

/**
 * 宫格-收藏: [相机、截图、屏幕录制相册PAD布局显示验证]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Albums_UX_check_0007
 * 前置条件
 * 1.xxx测试机图库已预置相机、截图、屏幕录制相册，已预置图片、视频
 注：XYAO设备
 */
async function multimediaGalleryAlbumsUXcheck0007(dt: Dt) {
  dt.log.i('相机、截图、屏幕录制相册PAD布局显示验证 start');
  dt.log.i('STEP 1.打开图库-检查侧边栏菜单显示，');

  await dt.sleep();
  dt.log.i('预期结果1&2.侧边菜单栏-上侧系统相册区域--按图片、视频、我的收藏、相机、截图、屏幕录制相册顺序展示在列表最前，显示无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.关闭旋转锁定按钮，90度旋转设备，侧边栏菜单显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机、截图、屏幕录制相册PAD布局显示验证 end');
}