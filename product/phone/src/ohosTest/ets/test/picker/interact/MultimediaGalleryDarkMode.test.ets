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

export default function MultimediaGalleryDarkMode(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryDarkModeTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryDarkMode').init();
      dt.log.i('beforeAll MultimediaGalleryDarkMode start');
      dt.log.i('beforeAll MultimediaGalleryDarkMode finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryDarkMode', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryDarkMode002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-深色用例: [图库相册页深色模式适配] TID: Multimedia_Gallery_DarkMode_002
      await multimediaGalleryDarkMode002(dt);
    });

    run('MultimediaGalleryDarkMode003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [图库大图深色模式适配] TID: Multimedia_Gallery_DarkMode_003
      await multimediaGalleryDarkMode003(dt);
    });
    run('MultimediaGalleryDarkMode004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-深色用例: [图库picker页面深色模式适配] TID: Multimedia_Gallery_DarkMode_004
      await multimediaGalleryDarkMode004(dt);
    });
    run('MultimediaGalleryDarkMode005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-深色用例: [图库多选页面深色模式适配] TID: Multimedia_Gallery_DarkMode_005
      await multimediaGalleryDarkMode005(dt);
    });
    run('MultimediaGalleryDarkMode006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-深色用例: [图库搜索页深色模式适配] TID: Multimedia_Gallery_DarkMode_006
      await multimediaGalleryDarkMode006(dt);
    });
    run('MultimediaGalleryDarkMode007', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-深色用例: [图库设置，关于页深色模式适配] TID: Multimedia_Gallery_DarkMode_007
      await multimediaGalleryDarkMode007(dt);
    });
    run('MultimediaGalleryDarkMode008', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-深色用例: [图库图片异常场景下深色模式适配（裂图，白图，无图）] TID: Multimedia_Gallery_DarkMode_008
      await multimediaGalleryDarkMode008(dt);
    });
    run('MultimediaGallerydragin0001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-拖拽用例: [文字输入框文字拖入] TID: Multimedia_Gallery_drag_in_0001
      await multimediaGallerydragin0001(dt);
    });
    run('MultimediaGalleryDragIn001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [图库支持图片、视频拖入-移动端] TID: Multimedia_Gallery_Drag_In_001
      await multimediaGalleryDragIn001(dt);
    });
    run('MultimediaGalleryDragIn0010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-拖拽用例: [拖拽松手时位于用户的新建相册，图片、视频保存] TID: Multimedia_Gallery_Drag_In_0010
      await multimediaGalleryDragIn0010(dt);
    });
    run('MultimediaGalleryDragIn0011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-拖拽用例: [拖拽到图库后切换页面，不支持拖入的相册需要置灰] TID: Multimedia_Gallery_Drag_In_0011
      await multimediaGalleryDragIn0011(dt);
    });
    run('MultimediaGalleryDragIn002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [图库支持图片、视频拖入范围和提示-移动端] TID: Multimedia_Gallery_Drag_In_002
      await multimediaGalleryDragIn002(dt);
    });
    run('MultimediaGalleryDragIn003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [图库支持图片、视频拖入范围和提示-PC端] TID: Multimedia_Gallery_Drag_In_003
      await multimediaGalleryDragIn003(dt);
    });
    run('MultimediaGalleryDragIn004', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [图库照片页多选态不支持拖入] TID: Multimedia_Gallery_Drag_In_004
      await multimediaGalleryDragIn004(dt);
    });
    run('MultimediaGalleryDragIn005', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [图库拖入照片排序] TID: Multimedia_Gallery_Drag_In_005
      await multimediaGalleryDragIn005(dt);
    });
    run('MultimediaGalleryDragIn006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [图库拖入实际场景测试] TID: Multimedia_Gallery_Drag_In_006
      await multimediaGalleryDragIn006(dt);
    });
    run('MultimediaGalleryDragIn007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [拖入功能异常场景验证] TID: Multimedia_Gallery_Drag_In_007
      await multimediaGalleryDragIn007(dt);
    });
    run('MultimediaGalleryDragIn008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-端云用例: [拖入功能端云场景验证] TID: Multimedia_Gallery_Drag_In_008
      await multimediaGalleryDragIn008(dt);
    });
    run('MultimediaGalleryDragIn009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [拖入功能多屏协调场景验证] TID: Multimedia_Gallery_Drag_In_009
      await multimediaGalleryDragIn009(dt);
    });
    run('MultimediaGalleryExtendNonCameraAlbum001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻生成扩展非相机目录_相机相册(手机-通用)] TID: Multimedia_Gallery_ExtendNonCameraAlbum_001
      await multimediaGalleryExtendNonCameraAlbum001(dt);
    });
    run('MultimediaGalleryExtendNonCameraAlbum002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻生成扩展非相机目录_相机相册&非相机相册(手机-通用)] TID: Multimedia_Gallery_ExtendNonCameraAlbum_002
      await multimediaGalleryExtendNonCameraAlbum002(dt);
    });
    run('MultimediaGalleryExtendNonCameraAlbum003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻生成扩展非相机目录_非相机相册(手机-通用)] TID: Multimedia_Gallery_ExtendNonCameraAlbum_003
      await multimediaGalleryExtendNonCameraAlbum003(dt);
    });
    run('MultimediaGalleryExtendNonCameraAlbum004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻生成扩展非相机目录_三方Top相机相册(手机-通用)] TID: Multimedia_Gallery_ExtendNonCameraAlbum_004
      await multimediaGalleryExtendNonCameraAlbum004(dt);
    });
    run('MultimediaGalleryExtendNonCameraAlbum005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻生成扩展非相机目录_应用相册(手机-通用)] TID: Multimedia_Gallery_ExtendNonCameraAlbum_005
      await multimediaGalleryExtendNonCameraAlbum005(dt);
    });
    run('MultimediaGalleryExtendNonCameraAlbum006', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻生成扩展非相机目录_截图相册(手机-通用)] TID: Multimedia_Gallery_ExtendNonCameraAlbum_006
      await multimediaGalleryExtendNonCameraAlbum006(dt);
    });
    run('MultimediaGalleryFilesmoves001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-连拍用例: [照片页宫格页移动到目标相册，界面检查] TID: Multimedia_Gallery_Files_moves_001
      await multimediaGalleryFilesmoves001(dt);
    });
    run('MultimediaGalleryFilesmoves002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [照片大图页移动到目标相册，界面检查] TID: Multimedia_Gallery_Files_moves_002
      await multimediaGalleryFilesmoves002(dt);
    });
    run('MultimediaGalleryFilesmoves003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-连拍用例: [相册页图片相册内宫格页移动至目标相册，页面检查] TID: Multimedia_Gallery_Files_moves_003
      await multimediaGalleryFilesmoves003(dt);
    });
    run('MultimediaGalleryFilesmoves004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [相册页图片相册内大图移动至目标相册，页面检查] TID: Multimedia_Gallery_Files_moves_004
      await multimediaGalleryFilesmoves004(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryDarkMode').init();
      dt.log.i('afterEach MultimediaGalleryDarkMode start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryDarkMode finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryDarkMode').init();
      dt.log.i('afterAll MultimediaGalleryDarkMode start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryDarkMode finish');
    });
  });
}

// DT步骤

/**
 * 宫格-深色: [图库相册页深色模式适配]
 * GROUP: 宫格 MODULE: 深色TID: Multimedia_Gallery_DarkMode_002
 * 前置条件
 * 1、准备一台手机
 2、本地有超过一屏的相册（系统相册，用户创建相册，来源相册，智慧相册等）
 3、本地有空相册
 4、切换深色模式

 */
async function multimediaGalleryDarkMode002(dt: Dt) {
  dt.log.i('图库相册页深色模式适配 start');
  dt.log.i('STEP 1、进入图库相册宫格页，查看界面深色模式显示是否正常');

  await dt.sleep();
  dt.log.i('预期结果1、界面显示正常，符合ux设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看各个相册深色模式下显示是否正常（图片相册，视频相册，用户创建相册，人像相册，地点相册，分类相册，拍摄模式，来源相册，隐藏相册，最近删除相册等）');

  await dt.sleep();
  dt.log.i('STEP 3、查看空相册深色模式下显示是否正常');

  await dt.sleep();
  dt.log.i('STEP 4、界面操作新建相册，右键四方菜单等看弹窗界面是否显示正常');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库相册页深色模式适配 end');
}

/**
 * 宫格-大图: [图库大图深色模式适配]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_DarkMode_003
 * 前置条件
 * 1、准备一台手机
 2、本地有超过一屏的图片和视频
 3、切换深色模式

 */
async function multimediaGalleryDarkMode003(dt: Dt) {
  dt.log.i('图库大图深色模式适配 start');
  dt.log.i('STEP 1、进入大图页面，查看界面深色模式下显示是否正常');

  await dt.sleep();
  dt.log.i('预期结果1、界面显示正常，符合ux设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、对大图进行分享，收藏，编辑，删除，更多等操作，查看界面深色模式下显示是否正常');

  await dt.sleep();
  dt.log.i('STEP 3、滑动大图底部预览条查看界面深色模式是否正常显示');

  await dt.sleep();
  dt.log.i('STEP 4、大图上滑详情查看界面显示是否正常');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库大图深色模式适配 end');
}

/**
 * 宫格-深色: [图库picker页面深色模式适配]
 * GROUP: 宫格 MODULE: 深色TID: Multimedia_Gallery_DarkMode_004
 * 前置条件
 * 1、准备一台手机
 2、本地有超过一屏的图片和视频
 3、切换深色模式

 */
async function multimediaGalleryDarkMode004(dt: Dt) {
  dt.log.i('图库picker页面深色模式适配 start');
  dt.log.i('STEP 1、进入用户新建相册picker界面，查看界面显示是否正常');

  await dt.sleep();
  dt.log.i('预期结果1、界面显示正常，符合ux设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、切换到所有相册页面，查看界面显示是否正常');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker页面深色模式适配 end');
}

/**
 * 宫格-深色: [图库多选页面深色模式适配]
 * GROUP: 宫格 MODULE: 深色TID: Multimedia_Gallery_DarkMode_005
 * 前置条件
 * 1、准备一台手机
 2、本地有超过一屏的图片和视频
 3、切换深色模式

 */
async function multimediaGalleryDarkMode005(dt: Dt) {
  dt.log.i('图库多选页面深色模式适配 start');
  dt.log.i('STEP 1、进入宫格多选页面，查看多选页面下界面显示是否正常');

  await dt.sleep();
  dt.log.i('预期结果1、界面显示正常，符合ux设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、多选模式下进入对比界面，查看界面显示是否正常');

  await dt.sleep();
  dt.log.i('STEP 3、多选模式下进入拼图界面，查看界面显示是否正常');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库多选页面深色模式适配 end');
}

/**
 * 宫格-深色: [图库搜索页深色模式适配]
 * GROUP: 宫格 MODULE: 深色TID: Multimedia_Gallery_DarkMode_006
 * 前置条件
 * 1、准备一台手机
 2、本地有超过一屏的图片和视频
 3、切换深色模式

 */
async function multimediaGalleryDarkMode006(dt: Dt) {
  dt.log.i('图库搜索页深色模式适配 start');
  dt.log.i('STEP 1、进入图库搜索页，查看界面显示是否正常');

  await dt.sleep();
  dt.log.i('预期结果1、界面显示正常，符合ux设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击搜索推荐标签界面，查看界面显示是否正常');

  await dt.sleep();
  dt.log.i('STEP 3、输入搜索词进行搜索，进入搜索结果界面，查看界面显示是否正常');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库搜索页深色模式适配 end');
}

/**
 * 宫格-深色: [图库设置，关于页深色模式适配]
 * GROUP: 宫格 MODULE: 深色TID: Multimedia_Gallery_DarkMode_007
 * 前置条件
 * 1、准备一台手机
 2、本地有超过一屏的图片和视频
 3、切换深色模式

 */
async function multimediaGalleryDarkMode007(dt: Dt) {
  dt.log.i('图库设置，关于页深色模式适配 start');
  dt.log.i('STEP 1、点击右上角四方菜单，进入设置界面，查看设置界面显示是否正常');

  await dt.sleep();
  dt.log.i('预期结果1、界面显示正常，符合ux设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入图库关于页面，查看关于页面显示是否正常');

  await dt.sleep();
  dt.log.i('STEP 3、点击关于页面的各个超链接，查看界面显示是否正常');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库设置，关于页深色模式适配 end');
}

/**
 * 宫格-深色: [图库图片异常场景下深色模式适配（裂图，白图，无图）]
 * GROUP: 宫格 MODULE: 深色TID: Multimedia_Gallery_DarkMode_008
 * 前置条件
 * 1、准备一台手机
 2、本地有超过一屏的图片，裂图，白图
 3、切换深色模式

 */
async function multimediaGalleryDarkMode008(dt: Dt) {
  dt.log.i('图库图片异常场景下深色模式适配（裂图，白图，无图） start');
  dt.log.i('STEP 1、查看裂图，白图，等异常图片界面是否显示正常');

  await dt.sleep();
  dt.log.i('预期结果1、界面显示正常，符合ux设计');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库图片异常场景下深色模式适配（裂图，白图，无图） end');
}

/**
 * 宫格-拖拽: [文字输入框文字拖入]
 * GROUP: 宫格 MODULE: 拖拽TID: Multimedia_Gallery_drag_in_0001
 * 前置条件
 * 图库准备分类照片（包含猫咪）并构建索引
 */
async function multimediaGallerydragin0001(dt: Dt) {
  dt.log.i('文字输入框文字拖入 start');
  dt.log.i('STEP 1、备忘录输入猫咪，并长按进行拖拽到图库搜索输入框');

  await dt.sleep();
  dt.log.i('预期结果1、与图库正常搜索猫咪结果一致');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('文字输入框文字拖入 end');
}

/**
 * 宫格-视频: [图库支持图片、视频拖入-移动端]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Drag_In_001
 * 前置条件
 * 图库已存在图片相册、视频相册、收藏相册、用户自建相册、智慧相册、来源相册、隐藏相册和最近删除相册
 */
async function multimediaGalleryDragIn001(dt: Dt) {
  dt.log.i('图库支持图片、视频拖入-移动端 start');
  dt.log.i('STEP 1、将文件管理图片、视频拖入图库照片页/相册页');

  await dt.sleep();
  dt.log.i('预期结果1、拖入成功后数量会增加');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库支持图片、视频拖入-移动端 end');
}

/**
 * 宫格-拖拽: [拖拽松手时位于用户的新建相册，图片、视频保存]
 * GROUP: 宫格 MODULE: 拖拽TID: Multimedia_Gallery_Drag_In_0010
 * 前置条件
 * 1、文件管理器中存在不同格式的照片和视频文件
 */
async function multimediaGalleryDragIn0010(dt: Dt) {
  dt.log.i('拖拽松手时位于用户的新建相册，图片、视频保存 start');
  dt.log.i('STEP 1、将文件管理器中的图片、视频拖入图库相册页中新建相册，待文件右上角出现绿色+号图标松手');

  await dt.sleep();
  dt.log.i('预期结果1.1 图片相册中有刚拖拽的图片，视频相册中有刚拖拽的视频1.2 用户新建相册中有刚拖拽的文件。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('拖拽松手时位于用户的新建相册，图片、视频保存 end');
}

/**
 * 宫格-拖拽: [拖拽到图库后切换页面，不支持拖入的相册需要置灰]
 * GROUP: 宫格 MODULE: 拖拽TID: Multimedia_Gallery_Drag_In_0011
 * 前置条件
 * 1、文件管理器中存在不同格式的照片和视频文件
 */
async function multimediaGalleryDragIn0011(dt: Dt) {
  dt.log.i('拖拽到图库后切换页面，不支持拖入的相册需要置灰 start');
  dt.log.i('STEP 1、将文件管理器中的图片或视频拖拽到图库相册页观察界面显示');

  await dt.sleep();
  dt.log.i('预期结果1、相册页内不支持拖入的相册置灰（图片拖入时视频相册置灰，视频拖入时图片相册置灰）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、切换到照片页后松手');

  await dt.sleep();
  dt.log.i('预期结果2、文件拖入成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、切换到相册页');

  await dt.sleep();
  dt.log.i('预期结果3、之前置灰的相册取消置灰');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('拖拽到图库后切换页面，不支持拖入的相册需要置灰 end');
}

/**
 * 宫格-视频: [图库支持图片、视频拖入范围和提示-移动端]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Drag_In_002
 * 前置条件
 * 图库已存在图片相册、视频相册、收藏相册、用户自建相册、智慧相册、来源相册、隐藏相册和最近删除相册
 */
async function multimediaGalleryDragIn002(dt: Dt) {
  dt.log.i('图库支持图片、视频拖入范围和提示-移动端 start');
  dt.log.i('STEP 1、将图片、视频拖入图库照片页照片位置');

  await dt.sleep();
  dt.log.i('预期结果1、照片页支持任何拖入（图片、视频、图片+视频）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、将图片、视频拖入图库相册页相册位置');

  await dt.sleep();
  dt.log.i('预期结果2、相册二级宫格页不支持拖入，收藏相册、智慧相册、来源相册、隐藏相册和最近删除相册在拖入时默认置灰（不支持拖入）  2.1、若拖入图片 或 图片 + 视频至图片相册，则图片视频均拖入成功；不支持仅拖入视频  2.2、若拖入视频 或 图片 + 视频至视频相册，则图片视频均拖入成功；不支持仅拖入图片  2.3、拖入图片+视频至用户新建相册时，新拖入图片添加进图片相册，新拖入视频添加进视频相册；同时拖入文件被添加到用户创建相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、将图片、视频拖入图库照片页/相册页空白区域');

  await dt.sleep();
  dt.log.i('预期结果3、仅照片页空白区域支持任何拖入（图片、视频、图片+视频）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、将图片、视频拖入图库时刻页');

  await dt.sleep();
  dt.log.i('预期结果4、均不支持拖入');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、将图片、视频 + 其他文件（如文件管理表格等）拖入图库用户自建相册');

  await dt.sleep();
  dt.log.i('预期结果5、图片、视频拖入图库，非图片、视频无法拖入图库且提示用户');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库支持图片、视频拖入范围和提示-移动端 end');
}

/**
 * 宫格-视频: [图库支持图片、视频拖入范围和提示-PC端]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Drag_In_003
 * 前置条件
 * 图库已存在图片相册、视频相册、收藏相册、用户自建相册、智慧相册、来源相册、隐藏相册和最近删除相册
 */
async function multimediaGalleryDragIn003(dt: Dt) {
  dt.log.i('图库支持图片、视频拖入范围和提示-PC端 start');
  dt.log.i('STEP 1、将文件管理图片、视频拖入图库‘图片和视频’照片位置');

  await dt.sleep();
  dt.log.i('预期结果1、‘图片和视频’宫格支持任何拖入（图片、视频、图片+视频）（包括空白区域）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、将文件管理图片、视频拖入图库侧边栏或宫格');

  await dt.sleep();
  dt.log.i('预期结果2、相册二级宫格页支持拖入，收藏相册、智慧相册、来源相册、隐藏相册和最近删除相册不支持拖入，侧边栏支持拖入时高亮  2.1、若拖入图片 或 图片 + 视频至图片相册，则图片视频均拖入成功；不支持仅拖入视频  2.2、若拖入视频 或 图片 + 视频至视频相册，则图片视频均拖入成功；不支持仅拖入图片  2.3、用户新建相册支持拖入图片/视频，新拖入图片添加进图片相册，新拖入视频添加进视频相册；同时拖入文件被添加到用户创建相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、将图片、视频 + 其他文件（如文件管理表格等）拖入图库用户自建相册');

  await dt.sleep();
  dt.log.i('预期结果3、图片、视频拖入图库，非图片、视频无法拖入图库且提示用户');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库支持图片、视频拖入范围和提示-PC端 end');
}

/**
 * 宫格-收藏: [图库照片页多选态不支持拖入]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Drag_In_004
 * 前置条件
 * 图库已存在图片相册、视频相册、收藏相册、用户自建相册、智慧相册、来源相册、隐藏相册和最近删除相册
 */
async function multimediaGalleryDragIn004(dt: Dt) {
  dt.log.i('图库照片页多选态不支持拖入 start');
  dt.log.i('STEP 1、图照片页宫格处于多选态时，降图片/视频拖入图照片宫格页');

  await dt.sleep();
  dt.log.i('预期结果1、不支持拖入，无提示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库照片页多选态不支持拖入 end');
}

/**
 * 宫格-收藏: [图库拖入照片排序]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Drag_In_005
 * 前置条件
 * 1、图库存在未来和过去照片
 2、图库已存在图片相册、视频相册、收藏相册、用户自建相册、智慧相册、来源相册、隐藏相册和最近删除相册
 */
async function multimediaGalleryDragIn005(dt: Dt) {
  dt.log.i('图库拖入照片排序 start');
  dt.log.i('STEP 1、图库拖入照片至照片页，观察新拖入照片如何排序');

  await dt.sleep();
  dt.log.i('预期结果1、新拖入照片按照媒体库添加时间排序');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库拖入照片排序 end');
}

/**
 * 宫格-收藏: [图库拖入实际场景测试]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Drag_In_006
 * 前置条件
 * 图库已存在图片相册、视频相册、收藏相册、用户自建相册、智慧相册、来源相册、隐藏相册和最近删除相册
 */
async function multimediaGalleryDragIn006(dt: Dt) {
  dt.log.i('图库拖入实际场景测试 start');
  dt.log.i('STEP 1、将同一张照片拖入图库5次，观察图库产生照片数量');

  await dt.sleep();
  dt.log.i('预期结果1、图库照片数量从n至n+5');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库拖入实际场景测试 end');
}

/**
 * 宫格-收藏: [拖入功能异常场景验证]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Drag_In_007
 * 前置条件
 * 图库已存在图片相册、视频相册、收藏相册、用户自建相册、智慧相册、来源相册、隐藏相册和最近删除相册，文件管理器存在大量图片，视频和其他类型文件
 */
async function multimediaGalleryDragIn007(dt: Dt) {
  dt.log.i('拖入功能异常场景验证 start');
  dt.log.i('STEP 1、将大量图片+视频拖入图库，拖入过程中强制杀死图库进程');

  await dt.sleep();
  dt.log.i('预期结果1、拖入进程中断，已拖入内容显示再图库中，未拖入内容不显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、将大量图片+视频拖入图库，拖入过程中息屏');

  await dt.sleep();
  dt.log.i('预期结果2、拖入进程在后台继续执行');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('拖入功能异常场景验证 end');
}

/**
 * 宫格-端云: [拖入功能端云场景验证]
 * GROUP: 宫格 MODULE: 端云TID: Multimedia_Gallery_Drag_In_008
 * 前置条件
 * 图库已存在图片相册、视频相册、收藏相册、用户自建相册、智慧相册、来源相册、隐藏相册和最近删除相册，登录端云账号开启端云同步
 */
async function multimediaGalleryDragIn008(dt: Dt) {
  dt.log.i('拖入功能端云场景验证 start');
  dt.log.i('STEP 1、无网络场景下将端云图片视频拖入图库');

  await dt.sleep();
  dt.log.i('预期结果1、松手后显示进度条，弹窗提示拖入失败');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、有网络场景下将端云图片视频拖入图库');

  await dt.sleep();
  dt.log.i('预期结果2、松手后显示进度条，拖入内容显示在图库里');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('拖入功能端云场景验证 end');
}

/**
 * 宫格-收藏: [拖入功能多屏协调场景验证]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Drag_In_009
 * 前置条件
 * 图库已存在图片相册、视频相册、收藏相册、用户自建相册、智慧相册、来源相册、隐藏相册和最近删除相册，文件管理器存在大量图片，视频和其他类型文件
 */
async function multimediaGalleryDragIn009(dt: Dt) {
  dt.log.i('拖入功能多屏协调场景验证 start');
  dt.log.i('STEP 1、PC上操作将图片、视频、其他类型文件拖入手机图库');

  await dt.sleep();
  dt.log.i('预期结果1、符合拖入条件情况下拖入内容正常显示在手机图库里，不符合条件内容弹窗提示拖入失败');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、PC上操作将手机图库里的图片、视频、其他类型文件拖入PC图库');

  await dt.sleep();
  dt.log.i('预期结果2、符合拖入条件情况下拖入内容正常显示在PC图库里，不符合条件内容弹窗提示拖入失败');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('拖入功能多屏协调场景验证 end');
}

/**
 * 宫格-: [时刻生成扩展非相机目录_相机相册(手机-通用)]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_ExtendNonCameraAlbum_001
 * 前置条件
 * 1、图库-相机相册预置1k张图片
 2、设备联网
 */
async function multimediaGalleryExtendNonCameraAlbum001(dt: Dt) {
  dt.log.i('时刻生成扩展非相机目录_相机相册(手机-通用) start');
  dt.log.i('STEP 1、手机插电、熄屏(电量不低于50%)等待智慧分析完成全量图集；');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻生成');

  await dt.sleep();
  dt.log.i('预期结果2、精彩时刻生成完成，不存在负向照片且UX显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻生成扩展非相机目录_相机相册(手机-通用) end');
}

/**
 * 宫格-: [时刻生成扩展非相机目录_相机相册&非相机相册(手机-通用)]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_ExtendNonCameraAlbum_002
 * 前置条件
 * 1、图库-相机相册&非相机相册各预置500k张图片
 2、设备联网
 */
async function multimediaGalleryExtendNonCameraAlbum002(dt: Dt) {
  dt.log.i('时刻生成扩展非相机目录_相机相册&非相机相册(手机-通用) start');
  dt.log.i('STEP 1、手机插电、熄屏(电量不低于50%)等待智慧分析完成全量图集；');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻生成');

  await dt.sleep();
  dt.log.i('预期结果2、精彩时刻生成完成，不存在负向照片且UX显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、检索日志打印(isCameraDirPhotosReach80Percent is 1)');

  await dt.sleep();
  dt.log.i('预期结果3、日志打印（isCameraDirPhotosReach80Percent is 1）字段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻生成扩展非相机目录_相机相册&非相机相册(手机-通用) end');
}

/**
 * 宫格-: [时刻生成扩展非相机目录_非相机相册(手机-通用)]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_ExtendNonCameraAlbum_003
 * 前置条件
 * 1、图库-非相机相册预置1k张图片
 2、设备联网
 */
async function multimediaGalleryExtendNonCameraAlbum003(dt: Dt) {
  dt.log.i('时刻生成扩展非相机目录_非相机相册(手机-通用) start');
  dt.log.i('STEP 1、手机插电、熄屏(电量不低于50%)等待智慧分析完成全量图集；');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻生成');

  await dt.sleep();
  dt.log.i('预期结果2、精彩时刻生成完成，不存在负向照片且UX显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、检索日志打印(isCameraDirPhotosReach80Percent is 0)');

  await dt.sleep();
  dt.log.i('预期结果3、日志打印（isCameraDirPhotosReach80Percent is 0）字段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻生成扩展非相机目录_非相机相册(手机-通用) end');
}

/**
 * 宫格-: [时刻生成扩展非相机目录_三方Top相机相册(手机-通用)]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_ExtendNonCameraAlbum_004
 * 前置条件
 * 1、图库-非相机相册预置1k张图片(构造Top全量“时刻选材范围”照片，涉及：微信、QQ、抖音、小红书、美颜相机、轻颜相机、美图秀秀、醒图、剪映拍摄及二次编辑的照片，保存在图库)
 2、设备联网
 */
async function multimediaGalleryExtendNonCameraAlbum004(dt: Dt) {
  dt.log.i('时刻生成扩展非相机目录_三方Top相机相册(手机-通用) start');
  dt.log.i('STEP 1、手机插电、熄屏(电量不低于50%)等待智慧分析完成全量图集；');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻生成');

  await dt.sleep();
  dt.log.i('预期结果2、精彩时刻生成完成，不存在负向照片且UX显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、检索日志打印(isCameraDirPhotosReach80Percent is 0)');

  await dt.sleep();
  dt.log.i('预期结果3、日志打印（isCameraDirPhotosReach80Percent is 0）字段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻生成扩展非相机目录_三方Top相机相册(手机-通用) end');
}

/**
 * 宫格-: [时刻生成扩展非相机目录_应用相册(手机-通用)]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_ExtendNonCameraAlbum_005
 * 前置条件
 * 1、图库-非相机相册预置1k张图片(构造分享、畅连、拍摄、及二次编辑的照片，保存在图库)
 2、设备联网
 */
async function multimediaGalleryExtendNonCameraAlbum005(dt: Dt) {
  dt.log.i('时刻生成扩展非相机目录_应用相册(手机-通用) start');
  dt.log.i('STEP 1、手机插电、熄屏(电量不低于50%)等待智慧分析完成全量图集；');

  await dt.sleep();
  dt.log.i('STEP 2、查看精彩时刻生成');

  await dt.sleep();
  dt.log.i('预期结果2、精彩时刻生成完成，不存在负向照片且UX显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、检索日志打印(isCameraDirPhotosReach80Percent is 0)');

  await dt.sleep();
  dt.log.i('预期结果3、日志打印（isCameraDirPhotosReach80Percent is 0）字段');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻生成扩展非相机目录_应用相册(手机-通用) end');
}

/**
 * 宫格-: [时刻生成扩展非相机目录_截图相册(手机-通用)]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_ExtendNonCameraAlbum_006
 * 前置条件
 * 1、图库-相机相册预置1k张图片
 2、设备联网
 3、精彩时刻页面已存在各类精彩时刻显示
 */
async function multimediaGalleryExtendNonCameraAlbum006(dt: Dt) {
  dt.log.i('时刻生成扩展非相机目录_截图相册(手机-通用) start');
  dt.log.i('STEP 1、选取已经生成过时刻的图片100张，进行二次编辑-截图后再去分析（设备联网插电熄屏）');

  await dt.sleep();
  dt.log.i('STEP 2、手机插电、熄屏(电量不低于50%)等待智慧分析完成全量图集；');

  await dt.sleep();
  dt.log.i('预期结果2、截图照片在精彩时刻不展示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻生成扩展非相机目录_截图相册(手机-通用) end');
}

/**
 * 宫格-连拍: [照片页宫格页移动到目标相册，界面检查]
 * GROUP: 宫格 MODULE: 连拍TID: Multimedia_Gallery_Files_moves_001
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制目标相册
 */
async function multimediaGalleryFilesmoves001(dt: Dt) {
  dt.log.i('照片页宫格页移动到目标相册，界面检查 start');
  dt.log.i('STEP 1.进入图库照片页，点击页面右上角多选图标，选择文件');

  await dt.sleep();
  dt.log.i('预期结果1.所选文件进入目标相册4.横屏状态下显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击页面右下角更多图标，选择移动到选项');

  await dt.sleep();
  dt.log.i('STEP 3.进入目标相册选择界面，选择目标相册');

  await dt.sleep();
  dt.log.i('STEP 4.横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果4.横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页宫格页移动到目标相册，界面检查 end');
}

/**
 * 宫格-大图: [照片大图页移动到目标相册，界面检查]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Files_moves_002
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制目标相册
 */
async function multimediaGalleryFilesmoves002(dt: Dt) {
  dt.log.i('照片大图页移动到目标相册，界面检查 start');
  dt.log.i('STEP 1.进入图库照片页，点击文件进入大图，点击右上角更多图标，选择移动到选项');

  await dt.sleep();
  dt.log.i('预期结果1.所选文件进入目标相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.进入目标相册选择界面，选择目标相册');

  await dt.sleep();
  dt.log.i('预期结果2.所选文件在图片页数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果3.横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片大图页移动到目标相册，界面检查 end');
}

/**
 * 宫格-连拍: [相册页图片相册内宫格页移动至目标相册，页面检查]
 * GROUP: 宫格 MODULE: 连拍TID: Multimedia_Gallery_Files_moves_003
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制目标相册
 */
async function multimediaGalleryFilesmoves003(dt: Dt) {
  dt.log.i('相册页图片相册内宫格页移动至目标相册，页面检查 start');
  dt.log.i('STEP 1.进入图库相册页，进入【图片】相册');

  await dt.sleep();
  dt.log.i('STEP 2.点击【图片】相册页面右上角多选图标，选择图片');

  await dt.sleep();
  dt.log.i('STEP 3.点击页面右下角更多图标，选择移动到选项');

  await dt.sleep();
  dt.log.i('STEP 4.进入目标相册选择界面，选择目标相册');

  await dt.sleep();
  dt.log.i('预期结果4.1所选文件进入目标相册，目标相册图片数量+14.2所选文件在【图片】相册数量不变4.3所选文件在图片宫格页数量不变4.4.图片和视频相册图片数量不变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果5.横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页图片相册内宫格页移动至目标相册，页面检查 end');
}

/**
 * 宫格-大图: [相册页图片相册内大图移动至目标相册，页面检查]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Files_moves_004
 * 前置条件
 * 1、准备一台xxx手机
 2、手机内预制图片/视频/动态照片/连拍照片等文件
 3、手机内预制目标相册
 */
async function multimediaGalleryFilesmoves004(dt: Dt) {
  dt.log.i('相册页图片相册内大图移动至目标相册，页面检查 start');
  dt.log.i('STEP 1、进入图库相册页，进入【图片】相册');

  await dt.sleep();
  dt.log.i('STEP 2、点击图片进入大图，点击图片右上角更多图标，选择移动到选项');

  await dt.sleep();
  dt.log.i('STEP 3、观察移动到界面的显示');

  await dt.sleep();
  dt.log.i('预期结果3、界面显示正常，缩略图内容不为空，相册的照片数和视频数显示正确');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、进入目标相册选择界面，选择目标相册');

  await dt.sleep();
  dt.log.i('预期结果4.1、所选文件进入目标相册4.2、所选文件在【图片】、【视频】相册数量不变4.3、所选文件在目标相册图片宫格页数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果5、横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页图片相册内大图移动至目标相册，页面检查 end');
}






































