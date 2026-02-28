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

export default function MultimediaGalleryFilesDelete(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryFilesDeleteTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryFilesDelete').init();
      dt.log.i('beforeAll MultimediaGalleryFilesDelete start');
      dt.log.i('beforeAll MultimediaGalleryFilesDelete finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryFilesDelete', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryFilesdeleteSR20241202149659022', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置视频清理页删除文件异常操作6] TID: Multimedia_Gallery_Files_delete_SR20241202149659_022
      await multimediaGalleryFilesdeleteSR20241202149659022(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659023', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置视频清理页删除文件异常操作7] TID: Multimedia_Gallery_Files_delete_SR20241202149659_023
      await multimediaGalleryFilesdeleteSR20241202149659023(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659024', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置视频清理页删除文件异常操作8] TID: Multimedia_Gallery_Files_delete_SR20241202149659_024
      await multimediaGalleryFilesdeleteSR20241202149659024(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659025', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置视频清理页删除文件异常操作9] TID: Multimedia_Gallery_Files_delete_SR20241202149659_025
      await multimediaGalleryFilesdeleteSR20241202149659025(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659026', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [最近删除清理页显示] TID: Multimedia_Gallery_Files_delete_SR20241202149659_026
      await multimediaGalleryFilesdeleteSR20241202149659026(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659027', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [最近删除清理页删除文件] TID: Multimedia_Gallery_Files_delete_SR20241202149659_027
      await multimediaGalleryFilesdeleteSR20241202149659027(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659028', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置最近清理页删除文件异常操作1] TID: Multimedia_Gallery_Files_delete_SR20241202149659_028
      await multimediaGalleryFilesdeleteSR20241202149659028(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659029', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置最近清理页删除文件异常操作2] TID: Multimedia_Gallery_Files_delete_SR20241202149659_029
      await multimediaGalleryFilesdeleteSR20241202149659029(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659030', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置最近清理页删除文件异常操作3] TID: Multimedia_Gallery_Files_delete_SR20241202149659_030
      await multimediaGalleryFilesdeleteSR20241202149659030(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659031', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置最近清理页删除文件异常操作4] TID: Multimedia_Gallery_Files_delete_SR20241202149659_031
      await multimediaGalleryFilesdeleteSR20241202149659031(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659032', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置最近清理页删除文件异常操作5] TID: Multimedia_Gallery_Files_delete_SR20241202149659_032
      await multimediaGalleryFilesdeleteSR20241202149659032(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659033', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置最近清理页删除文件异常操作6] TID: Multimedia_Gallery_Files_delete_SR20241202149659_033
      await multimediaGalleryFilesdeleteSR20241202149659033(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659034', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置最近清理页删除文件异常操作7] TID: Multimedia_Gallery_Files_delete_SR20241202149659_034
      await multimediaGalleryFilesdeleteSR20241202149659034(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659035', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [点击前往优化，跳转图库清理页MTBF测试] TID: Multimedia_Gallery_Files_delete_SR20241202149659_035
      await multimediaGalleryFilesdeleteSR20241202149659035(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659036', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [点击视频清理页，跳转视频列表，视频列表加载MTBF测试] TID: Multimedia_Gallery_Files_delete_SR20241202149659_036
      await multimediaGalleryFilesdeleteSR20241202149659036(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659037', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [点击最近删除页，跳转最近删除，视频列表加载MTBF测试] TID: Multimedia_Gallery_Files_delete_SR20241202149659_037
      await multimediaGalleryFilesdeleteSR20241202149659037(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659038', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [视频清理页和最近删除页删除页删除图片MTBF测试] TID: Multimedia_Gallery_Files_delete_SR20241202149659_038
      await multimediaGalleryFilesdeleteSR20241202149659038(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659039', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [删除（**B）MTBF测试] TID: Multimedia_Gallery_Files_delete_SR20241202149659_039
      await multimediaGalleryFilesdeleteSR20241202149659039(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659040', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [大字体场景，图库清理相关字串检查] TID: Multimedia_Gallery_Files_delete_SR20241202149659_040
      await multimediaGalleryFilesdeleteSR20241202149659040(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659041', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [多语言场景，图库清理相关字串检查] TID: Multimedia_Gallery_Files_delete_SR20241202149659_041
      await multimediaGalleryFilesdeleteSR20241202149659041(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659042', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [无障碍场景，图库清理相关字串检查] TID: Multimedia_Gallery_Files_delete_SR20241202149659_042
      await multimediaGalleryFilesdeleteSR20241202149659042(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659043', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-深色用例: [深色模式场景，图库清理相关字串检查] TID: Multimedia_Gallery_Files_delete_SR20241202149659_043
      await multimediaGalleryFilesdeleteSR20241202149659043(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659044', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [隐私空间场景，图库清理相关字串检查] TID: Multimedia_Gallery_Files_delete_SR20241202149659_044
      await multimediaGalleryFilesdeleteSR20241202149659044(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659045', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [横竖屏场景，图库清理相关字串检查] TID: Multimedia_Gallery_Files_delete_SR20241202149659_045
      await multimediaGalleryFilesdeleteSR20241202149659045(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659046', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [悬浮窗场景，图库清理相关字串检查] TID: Multimedia_Gallery_Files_delete_SR20241202149659_046
      await multimediaGalleryFilesdeleteSR20241202149659046(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659047', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [分屏场景，图库清理相关字串检查] TID: Multimedia_Gallery_Files_delete_SR20241202149659_047
      await multimediaGalleryFilesdeleteSR20241202149659047(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659048', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置视频删除页的视频支持预览] TID: Multimedia_Gallery_Files_delete_SR20241202149659_048
      await multimediaGalleryFilesdeleteSR20241202149659048(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659049', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置视频删除页的视频预览后返回] TID: Multimedia_Gallery_Files_delete_SR20241202149659_049
      await multimediaGalleryFilesdeleteSR20241202149659049(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659050', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [列表的勾选态和视频预览界面勾选态一致] TID: Multimedia_Gallery_Files_delete_SR20241202149659_050
      await multimediaGalleryFilesdeleteSR20241202149659050(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659051', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置视频删除页的视频预览时从图库删除该视频] TID: Multimedia_Gallery_Files_delete_SR20241202149659_051
      await multimediaGalleryFilesdeleteSR20241202149659051(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659052', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置视频删除页的视频预览时从文件管理器删除该视频] TID: Multimedia_Gallery_Files_delete_SR20241202149659_052
      await multimediaGalleryFilesdeleteSR20241202149659052(dt);
    });
    run('MultimediaGalleryFilesdeleteSR20241202149659053', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置视频删除页的视频预览时，将该视频从图库中改名] TID: Multimedia_Gallery_Files_delete_SR20241202149659_053
      await multimediaGalleryFilesdeleteSR20241202149659053(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryFilesDelete').init();
      dt.log.i('afterEach MultimediaGalleryFilesDelete start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryFilesDelete finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryFilesDelete').init();
      dt.log.i('afterAll MultimediaGalleryFilesDelete start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryFilesDelete finish');
    });
  });
}

// DT步骤
/**
 * 宫格-删除: [设置视频清理页删除文件异常操作6]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_022
 * 前置条件
 * 1、已弹出图库清理卡片
 2、进入视频清理页
 */
async function multimediaGalleryFilesdeleteSR20241202149659022(dt: Dt) {
  dt.log.i('设置视频清理页删除文件异常操作6 start');
  dt.log.i('STEP 1、勾选视频A，辅助机删除视频A+图库回收站清空，云同步成功');

  await dt.sleep();
  dt.log.i('预期结果1、视频清理页不显示视频A');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置视频清理页删除文件异常操作6 end');
}

/**
 * 宫格-删除: [设置视频清理页删除文件异常操作7]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_023
 * 前置条件
 * 1、已弹出图库清理卡片
 2、进入视频清理页
 */
async function multimediaGalleryFilesdeleteSR20241202149659023(dt: Dt) {
  dt.log.i('设置视频清理页删除文件异常操作7 start');
  dt.log.i('STEP 1、勾选视频A，文件管理器中删除视频A，返回视频清理页');

  await dt.sleep();
  dt.log.i('预期结果1、视频清理页不显示视频A');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置视频清理页删除文件异常操作7 end');
}

/**
 * 宫格-删除: [设置视频清理页删除文件异常操作8]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_024
 * 前置条件
 * 1、已弹出图库清理卡片
 2、进入视频清理页
 */
async function multimediaGalleryFilesdeleteSR20241202149659024(dt: Dt) {
  dt.log.i('设置视频清理页删除文件异常操作8 start');
  dt.log.i('STEP 1、勾选视频A，图库中视频A改名称，返回视频清理页');

  await dt.sleep();
  dt.log.i('预期结果1、视频清理页中视频A名称随之改变，点击删除可正常删除');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置视频清理页删除文件异常操作8 end');
}

/**
 * 宫格-删除: [设置视频清理页删除文件异常操作9]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_025
 * 前置条件
 * 1、已弹出图库清理卡片
 2、进入视频清理页
 */
async function multimediaGalleryFilesdeleteSR20241202149659025(dt: Dt) {
  dt.log.i('设置视频清理页删除文件异常操作9 start');
  dt.log.i('STEP 1、图库中正在播放视频A，在视频清理页中勾选视频A删除后返回图库');

  await dt.sleep();
  dt.log.i('预期结果1、播放中的视频A消失');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置视频清理页删除文件异常操作9 end');
}

/**
 * 宫格-删除: [最近删除清理页显示]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_026
 * 前置条件
 * 1、已弹出图库清理卡片
 */
async function multimediaGalleryFilesdeleteSR20241202149659026(dt: Dt) {
  dt.log.i('最近删除清理页显示 start');
  dt.log.i('STEP 1、进入最近清除清理页，查看界面显示');

  await dt.sleep();
  dt.log.i('预期结果1.1、跳转到最近删除相册页，文件的排序和图库一致1.2、所有文件是待勾选状态，勾选后左上角实时刷新勾选个数1.3、勾选后底部的按钮”删除(已选xxB)”实时刷新，未勾选时不显示删除按钮');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('删除(已选xxB)'));
  dt.log.i('STEP 2、退出多选状态，点击图片');

  await dt.sleep();
  dt.log.i('预期结果2、显示大图，支持进入退出沉浸式');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击视频');

  await dt.sleep();
  dt.log.i('预期结果3、视频支持全屏播放，支持进入退出沉浸式');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除清理页显示 end');
}

/**
 * 宫格-删除: [最近删除清理页删除文件]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_027
 * 前置条件
 * 1、已弹出图库清理卡片
 */
async function multimediaGalleryFilesdeleteSR20241202149659027(dt: Dt) {
  dt.log.i('最近删除清理页删除文件 start');
  dt.log.i('STEP 1、进入最近删除清理页，勾选文件后，点击删除');

  await dt.sleep();
  dt.log.i('预期结果1、二次提醒：未开启云同步，提示：所选x个文件将被永久删除，无法恢复；开启云同步，提示：所选x个文件将从本设备、云空间及所有设备中永久删除，无法恢复底部有”取消”,”永久删除”按钮');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('取消'));
  dt.log.i('STEP 2、延续步骤1，点击取消');

  await dt.sleep();
  dt.log.i('预期结果2、弹框消失，仍在最近删除清理页');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、延续步骤1，点击永久删除');

  await dt.sleep();
  dt.log.i('预期结果3.1、已开启云同步，云端文件不保留，辅助机不显示被删除的文件；3.2、已关闭云同步，云端文件保留，辅助机依然显示被删除的文件');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除清理页删除文件 end');
}

/**
 * 宫格-删除: [设置最近清理页删除文件异常操作1]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_028
 * 前置条件
 * 1、已弹出图库清理卡片
 2、进入最近删除清理页
 */
async function multimediaGalleryFilesdeleteSR20241202149659028(dt: Dt) {
  dt.log.i('设置最近清理页删除文件异常操作1 start');
  dt.log.i('STEP 1、勾选文件后，本地图库直接清空最近删除列表，返回设置的最近删除清理页，查看界面显示');

  await dt.sleep();
  dt.log.i('预期结果1、最近删除清理页不显示已勾选文件，勾选个数同步刷新');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置最近清理页删除文件异常操作1 end');
}

/**
 * 宫格-删除: [设置最近清理页删除文件异常操作2]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_029
 * 前置条件
 * 1、已弹出图库清理卡片
 2、进入视频清理页
 */
async function multimediaGalleryFilesdeleteSR20241202149659029(dt: Dt) {
  dt.log.i('设置最近清理页删除文件异常操作2 start');
  dt.log.i('STEP 1、勾选文件后，辅助机清空部分/全部最近删除列表，云同步成功');

  await dt.sleep();
  dt.log.i('预期结果1、最近删除清理页不显示已勾选文件');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置最近清理页删除文件异常操作2 end');
}

/**
 * 宫格-删除: [设置最近清理页删除文件异常操作3]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_030
 * 前置条件
 * 1、已弹出图库清理卡片
 2、进入视频清理页
 */
async function multimediaGalleryFilesdeleteSR20241202149659030(dt: Dt) {
  dt.log.i('设置最近清理页删除文件异常操作3 start');
  dt.log.i('STEP 1、勾选文件后，本地图库最近删除页恢复部分文件，返回设置的最近清理页，查看界面显示');

  await dt.sleep();
  dt.log.i('预期结果1、恢复的文件直接从设置的最近删除清理页消失，视频清理页需要同步出现刚才恢复的视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置最近清理页删除文件异常操作3 end');
}

/**
 * 宫格-删除: [设置最近清理页删除文件异常操作4]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_031
 * 前置条件
 * 1、已弹出图库清理卡片
 2、进入最近删除页
 */
async function multimediaGalleryFilesdeleteSR20241202149659031(dt: Dt) {
  dt.log.i('设置最近清理页删除文件异常操作4 start');
  dt.log.i('STEP 1、在设置最近删除页勾选文件A，在图库-最近删除相册恢复或删除文件A，查看返回设置最近删除页后的显示');

  await dt.sleep();
  dt.log.i('预期结果1、设置最近删除页不显示文件A，顶部显示“未选择”标题，底部不显示删除按钮');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('未选择'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置最近清理页删除文件异常操作4 end');
}

/**
 * 宫格-删除: [设置最近清理页删除文件异常操作5]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_032
 * 前置条件
 * 1、已弹出图库清理卡片
 2、进入最近删除页
 */
async function multimediaGalleryFilesdeleteSR20241202149659032(dt: Dt) {
  dt.log.i('设置最近清理页删除文件异常操作5 start');
  dt.log.i('STEP 1、在设置最近删除页勾选多个文件，在图库-最近删除相册恢复/删除部分文件，查看返回设置最近删除页后的显示');

  await dt.sleep();
  dt.log.i('预期结果1、在图库中恢复/删除的视频不显示在设置最近删除界面，顶部的已选择x项更新，底部的删除大小更新');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置最近清理页删除文件异常操作5 end');
}

/**
 * 宫格-删除: [设置最近清理页删除文件异常操作6]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_033
 * 前置条件
 * 1、已弹出图库清理卡片
 2、进入最近删除页
 */
async function multimediaGalleryFilesdeleteSR20241202149659033(dt: Dt) {
  dt.log.i('设置最近清理页删除文件异常操作6 start');
  dt.log.i('STEP 1、在设置最近删除页勾选多个文件，在图库-最近删除相册恢复/删除全部所选文件，查看返回设置最近删除页后的显示');

  await dt.sleep();
  dt.log.i('预期结果1、在图库中恢复/删除的视频不显示在设置最近删除界面，顶部显示“未选择”标题，底部不显示删除按钮');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('未选择'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置最近清理页删除文件异常操作6 end');
}

/**
 * 宫格-删除: [设置最近清理页删除文件异常操作7]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_034
 * 前置条件
 * 1、已弹出图库清理卡片
 2、进入最近删除页
 */
async function multimediaGalleryFilesdeleteSR20241202149659034(dt: Dt) {
  dt.log.i('设置最近清理页删除文件异常操作7 start');
  dt.log.i('STEP 1、在设置最近删除界面，全选，在图库-最近删除相册恢复/删除全部文件，再返回设置视频删除界面');

  await dt.sleep();
  dt.log.i('预期结果1、设置的最近删除界面为空，顶部显示“最近删除”标题');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('最近删除'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置最近清理页删除文件异常操作7 end');
}

/**
 * 宫格-: [点击前往优化，跳转图库清理页MTBF测试]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_Files_delete_SR20241202149659_035
 * 前置条件
 * 1、已弹出图库清理卡片
 */
async function multimediaGalleryFilesdeleteSR20241202149659035(dt: Dt) {
  dt.log.i('点击前往优化，跳转图库清理页MTBF测试 start');
  dt.log.i('STEP 1、点击优化图库空间卡片的前往优化按钮（重复100次）');

  await dt.sleep();
  dt.log.i('预期结果1、跳转到图库优化空间页面，图库不会出现报错，冻屏，异常重启');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('点击前往优化，跳转图库清理页MTBF测试 end');
}

/**
 * 宫格-视频: [点击视频清理页，跳转视频列表，视频列表加载MTBF测试]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Files_delete_SR20241202149659_036
 * 前置条件
 * 1、已弹出图库清理卡片
 */
async function multimediaGalleryFilesdeleteSR20241202149659036(dt: Dt) {
  dt.log.i('点击视频清理页，跳转视频列表，视频列表加载MTBF测试 start');
  dt.log.i('STEP 1、点击视频清理按钮（重复100次）');

  await dt.sleep();
  dt.log.i('预期结果1、跳转到视频清理页，视频加载显示正常，无crash、卡死等异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('点击视频清理页，跳转视频列表，视频列表加载MTBF测试 end');
}

/**
 * 宫格-删除: [点击最近删除页，跳转最近删除，视频列表加载MTBF测试]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_037
 * 前置条件
 * 1、已弹出图库清理卡片
 */
async function multimediaGalleryFilesdeleteSR20241202149659037(dt: Dt) {
  dt.log.i('点击最近删除页，跳转最近删除，视频列表加载MTBF测试 start');
  dt.log.i('STEP 1、点击最近删除清理按钮（重复100次）');

  await dt.sleep();
  dt.log.i('预期结果1、跳转到最近删除清理页，列表加载显示正常，无crash、卡死等异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('点击最近删除页，跳转最近删除，视频列表加载MTBF测试 end');
}

/**
 * 宫格-删除: [视频清理页和最近删除页删除页删除图片MTBF测试]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_038
 * 前置条件
 * 1、已弹出图库清理卡片
 */
async function multimediaGalleryFilesdeleteSR20241202149659038(dt: Dt) {
  dt.log.i('视频清理页和最近删除页删除页删除图片MTBF测试 start');
  dt.log.i('STEP 1、点击视频清理按钮，勾选文件后点击删除（重复100次）');

  await dt.sleep();
  dt.log.i('预期结果1、视频清理成功，无crash、卡死等异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击最近清除清理按钮，勾选文件后点击删除（重复100次）');

  await dt.sleep();
  dt.log.i('预期结果2、文件清理成功，无crash、卡死等异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频清理页和最近删除页删除页删除图片MTBF测试 end');
}

/**
 * 宫格-删除: [删除（**B）MTBF测试]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_039
 * 前置条件
 * 1、已弹出图库清理卡片
 */
async function multimediaGalleryFilesdeleteSR20241202149659039(dt: Dt) {
  dt.log.i('删除（**B）MTBF测试 start');
  dt.log.i('STEP 1、点击视频清理按钮，勾选文件后查看底部按钮的删除内存值（重复100次）');

  await dt.sleep();
  dt.log.i('预期结果1-2、删除(已选xxB)实时刷新，无crash，卡死等异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击最近清除清理按钮，勾选文件后查看底部按钮的删除内存值（重复100次）');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('删除（**B）MTBF测试 end');
}

/**
 * 宫格-删除: [大字体场景，图库清理相关字串检查]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_040
 * 前置条件
 * 1、已弹出图库清理卡片
 */
async function multimediaGalleryFilesdeleteSR20241202149659040(dt: Dt) {
  dt.log.i('大字体场景，图库清理相关字串检查 start');
  dt.log.i('STEP 1、将字体大小，字体粗细，显示大小全部调到最大，');

  await dt.sleep();
  dt.log.i('STEP 2、查看图库清理卡片内容和控件显示');

  await dt.sleep();
  dt.log.i('预期结果2-3、大字体下不会出现字体截断、重叠等问题');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看图库清理，视频清理和最近删除清理界面的内容和控件显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大字体场景，图库清理相关字串检查 end');
}

/**
 * 宫格-删除: [多语言场景，图库清理相关字串检查]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_041
 * 前置条件
 * 1、已弹出图库清理卡片
 */
async function multimediaGalleryFilesdeleteSR20241202149659041(dt: Dt) {
  dt.log.i('多语言场景，图库清理相关字串检查 start');
  dt.log.i('STEP 1、遍历不同语言，检查清理卡片、图库清理、视频清理、最近删除清理三个页面所有的文字和控件显示');

  await dt.sleep();
  dt.log.i('预期结果1、文字和控件内容翻译正确，无截断重叠、异常换行等问题');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、镜像语言下，检查清理卡片、图库清理、视频清理、最近删除清理三个页面所有的文字和控件');

  await dt.sleep();
  dt.log.i('预期结果2、符合镜像布局要求');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多语言场景，图库清理相关字串检查 end');
}

/**
 * 宫格-删除: [无障碍场景，图库清理相关字串检查]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_042
 * 前置条件
 * 1、已弹出图库清理卡片
 */
async function multimediaGalleryFilesdeleteSR20241202149659042(dt: Dt) {
  dt.log.i('无障碍场景，图库清理相关字串检查 start');
  dt.log.i('STEP 1、开启无障碍播报，查看图库清理卡片内容和控件播报');

  await dt.sleep();
  dt.log.i('预期结果1-2、所有字符串都能正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看图库清理，视频清理和最近删除清理界面的内容和控件播报');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无障碍场景，图库清理相关字串检查 end');
}

/**
 * 宫格-深色: [深色模式场景，图库清理相关字串检查]
 * GROUP: 宫格 MODULE: 深色TID: Multimedia_Gallery_Files_delete_SR20241202149659_043
 * 前置条件
 * 1、已弹出图库清理卡片
 */
async function multimediaGalleryFilesdeleteSR20241202149659043(dt: Dt) {
  dt.log.i('深色模式场景，图库清理相关字串检查 start');
  dt.log.i('STEP 1、切换深色模式，遍历清理卡片、图库清理、视频清理、最近删除清理三个页面所有的文字和控件');

  await dt.sleep();
  dt.log.i('预期结果1、开启深色模式，图库清理页面的文字和控件显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、关闭深色模式，遍历清理卡片、图库清理、视频清理、最近删除清理三个页面所有的文字和控件');

  await dt.sleep();
  dt.log.i('预期结果2、关闭深色模式，图库清理页面的文字和控件显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('深色模式场景，图库清理相关字串检查 end');
}

/**
 * 宫格-删除: [隐私空间场景，图库清理相关字串检查]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_044
 * 前置条件
 * 1、已弹出图库清理卡片
 */
async function multimediaGalleryFilesdeleteSR20241202149659044(dt: Dt) {
  dt.log.i('隐私空间场景，图库清理相关字串检查 start');
  dt.log.i('STEP 1、进入隐私空间，隐私空间内视频与回收站中本地文件超过500MB');

  await dt.sleep();
  dt.log.i('预期结果1.1、图库清理卡片出现时机互相独立1.2、隐私空间和主空间图库数据互相独立，删除后不影响其他空间的数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间场景，图库清理相关字串检查 end');
}

/**
 * 宫格-竖屏: [横竖屏场景，图库清理相关字串检查]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_Files_delete_SR20241202149659_045
 * 前置条件
 * 1、已弹出图库清理卡片
 */
async function multimediaGalleryFilesdeleteSR20241202149659045(dt: Dt) {
  dt.log.i('横竖屏场景，图库清理相关字串检查 start');
  dt.log.i('STEP 1、横屏，遍历清理卡片、图库清理、视频清理、最近删除清理三个页面');

  await dt.sleep();
  dt.log.i('预期结果1、清理卡片、图库清理、视频清理、最近删除清理界面跟随设置支持横竖屏操作');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、横竖屏旋转，查看上述界面显示');

  await dt.sleep();
  dt.log.i('预期结果2、横竖屏旋转后，界面显示正常，无错乱，突变等异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('横竖屏场景，图库清理相关字串检查 end');
}

/**
 * 宫格-删除: [悬浮窗场景，图库清理相关字串检查]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_046
 * 前置条件
 * 1、已弹出图库清理卡片
 */
async function multimediaGalleryFilesdeleteSR20241202149659046(dt: Dt) {
  dt.log.i('悬浮窗场景，图库清理相关字串检查 start');
  dt.log.i('STEP 1、桌面侧滑，在侧边栏中点击设置');

  await dt.sleep();
  dt.log.i('预期结果1、悬浮窗模式下，图库清理页面的文字和控件显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看图库清理卡片内容和控件显示');

  await dt.sleep();
  dt.log.i('STEP 3、查看图库清理，视频清理和最近删除清理界面的内容和控件显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('悬浮窗场景，图库清理相关字串检查 end');
}

/**
 * 宫格-删除: [分屏场景，图库清理相关字串检查]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_047
 * 前置条件
 * 1、已弹出图库清理卡片
 */
async function multimediaGalleryFilesdeleteSR20241202149659047(dt: Dt) {
  dt.log.i('分屏场景，图库清理相关字串检查 start');
  dt.log.i('STEP 1、进入分屏场景，查看图库清理卡片内容和控件显示');

  await dt.sleep();
  dt.log.i('预期结果1、分屏模式下，图库清理页面的文字和控件显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看图库清理，视频清理和最近删除清理界面的内容和控件显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分屏场景，图库清理相关字串检查 end');
}

/**
 * 宫格-删除: [设置视频删除页的视频支持预览]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_048
 * 前置条件
 * 1、已弹出图库清理卡片
 2、本地图库视频相册中有视频
 3、进入设置视频清理页
 */
async function multimediaGalleryFilesdeleteSR20241202149659048(dt: Dt) {
  dt.log.i('设置视频删除页的视频支持预览 start');
  dt.log.i('STEP 1、进入视频删除界面，点击列表的图像icon区域');

  await dt.sleep();
  dt.log.i('预期结果1、跳转到视频全屏预览界面，支持播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击图像icon外的区域');

  await dt.sleep();
  dt.log.i('预期结果2、响应列表的勾选/去勾选');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置视频删除页的视频支持预览 end');
}

/**
 * 宫格-删除: [设置视频删除页的视频预览后返回]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_049
 * 前置条件
 * 1、已弹出图库清理卡片
 2、本地图库视频相册中有视频
 3、进入设置视频清理页
 */
async function multimediaGalleryFilesdeleteSR20241202149659049(dt: Dt) {
  dt.log.i('设置视频删除页的视频预览后返回 start');
  dt.log.i('STEP 1、进入视频删除界面，点击列表的图像icon区域');

  await dt.sleep();
  dt.log.i('预期结果1、进入视频全屏预览界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、back手势返回');

  await dt.sleep();
  dt.log.i('预期结果2-3：返回视频删除列表页');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击左上角的返回按钮');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置视频删除页的视频预览后返回 end');
}

/**
 * 宫格-视频: [列表的勾选态和视频预览界面勾选态一致]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Files_delete_SR20241202149659_050
 * 前置条件
 * 1、已弹出图库清理卡片
 2、本地图库视频相册中有视频
 3、进入设置视频清理页
 */
async function multimediaGalleryFilesdeleteSR20241202149659050(dt: Dt) {
  dt.log.i('列表的勾选态和视频预览界面勾选态一致 start');
  dt.log.i('STEP 1、勾选列表后点击图像icon，');

  await dt.sleep();
  dt.log.i('预期结果1、进入视频全屏播放界面，顶部的已选择x项显示正确，右侧是已勾选状态');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、不勾选列表后点击图像icon');

  await dt.sleep();
  dt.log.i('预期结果2、进入视频全屏播放界面，顶部的已选择x项显示正确，右侧是未勾选状态');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、延续步骤2，在视频预览界面勾选视频，返回视频列表页');

  await dt.sleep();
  dt.log.i('预期结果3、视频列表页该视频右侧是已勾选状态');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('列表的勾选态和视频预览界面勾选态一致 end');
}

/**
 * 宫格-删除: [设置视频删除页的视频预览时从图库删除该视频]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_051
 * 前置条件
 * 1、已弹出图库清理卡片
 2、本地图库视频相册中有视频
 3、进入设置视频清理页
 */
async function multimediaGalleryFilesdeleteSR20241202149659051(dt: Dt) {
  dt.log.i('设置视频删除页的视频预览时从图库删除该视频 start');
  dt.log.i('STEP 1、勾选视频A，进入预览界面，在图库中删除视频A，返回视频清理页');

  await dt.sleep();
  dt.log.i('预期结果1、视频清理页不显示视频A');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置视频删除页的视频预览时从图库删除该视频 end');
}

/**
 * 宫格-删除: [设置视频删除页的视频预览时从文件管理器删除该视频]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_052
 * 前置条件
 * 1、已弹出图库清理卡片
 2、本地图库视频相册中有视频
 3、进入设置视频清理页
 */
async function multimediaGalleryFilesdeleteSR20241202149659052(dt: Dt) {
  dt.log.i('设置视频删除页的视频预览时从文件管理器删除该视频 start');
  dt.log.i('STEP 1、勾选视频A，进入预览界面，在文件管理器中删除视频A，返回视频清理页');

  await dt.sleep();
  dt.log.i('预期结果1、视频清理页不显示视频A');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置视频删除页的视频预览时从文件管理器删除该视频 end');
}

/**
 * 宫格-删除: [设置视频删除页的视频预览时，将该视频从图库中改名]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_053
 * 前置条件
 * 1、已弹出图库清理卡片
 2、本地图库视频相册中有视频
 3、进入设置视频清理页
 */
async function multimediaGalleryFilesdeleteSR20241202149659053(dt: Dt) {
  dt.log.i('设置视频删除页的视频预览时，将该视频从图库中改名 start');
  dt.log.i('STEP 1、勾选视频A，进入预览界面，在图库中将视频A改名，返回视频清理页');

  await dt.sleep();
  dt.log.i('预期结果1、视频清理页中视频A名称随之改变，点击删除可正常删除');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置视频删除页的视频预览时，将该视频从图库中改名 end');
}
















