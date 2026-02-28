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

export default function OneClickSkinBeauty(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('OneClickSkinBeautyTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllOneClickSkinBeauty').init();
      dt.log.i('beforeAll OneClickSkinBeauty start');
      dt.log.i('beforeAll OneClickSkinBeauty finish');
    });
    /**
     * 打开大图
     */
    run('beforeOneClickSkinBeauty', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('Oneclick_Skin_beauty_001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [人像图片有一键美肤功能] TID: Oneclick_Skin_beauty_001
      await Oneclick_Skin_beauty_001(dt);
    });
    run('Oneclick_Skin_beauty_002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [非人像图片无一键美肤功能] TID: Oneclick_Skin_beauty_002
      await Oneclick_Skin_beauty_002(dt);
    });
    run('Oneclick_Skin_beauty_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [一键美肤功能验证] TID: Oneclick_Skin_beauty_003
      await Oneclick_Skin_beauty_003(dt);
    });
    run('Oneclick_Skin_beauty_004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [编辑后一键美肤功能验证] TID: Oneclick_Skin_beauty_004
      await Oneclick_Skin_beauty_004(dt);
    });
    run('Oneclick_Skin_beauty_005', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [一键美肤后编辑功能验证] TID: Oneclick_Skin_beauty_005
      await Oneclick_Skin_beauty_005(dt);
    });
    run('Oneclick_Skin_beauty_006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [取消一键美肤功能验证] TID: Oneclick_Skin_beauty_006
      await Oneclick_Skin_beauty_006(dt);
    });
    run('Oneclick_Skin_beauty_007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [美肤且编辑后一键还原功能验证] TID: Oneclick_Skin_beauty_007
      await Oneclick_Skin_beauty_007(dt);
    });
    run('Oneclick_Skin_beauty_008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [LCD人像图一键美肤功能验证] TID: Oneclick_Skin_beauty_008
      await Oneclick_Skin_beauty_008(dt);
    });
    run('Oneclick_Skin_beauty_009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [相机入口一键美肤功能验证] TID: Oneclick_Skin_beauty_009
      await Oneclick_Skin_beauty_009(dt);
    });
    run('Oneclick_Skin_beauty_010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-用例: [一键美肤后分享功能验证] TID: Oneclick_Skin_beauty_010
      await Oneclick_Skin_beauty_010(dt);
    });
    run('Oneclick_Skin_beauty_011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [云端下载人像图一键美肤功能验证] TID: Oneclick_Skin_beauty_011
      await Oneclick_Skin_beauty_011(dt);
    });
    run('Oneclick_Skin_beauty_014', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [一键美肤切换横竖屏xxxxxx功能验证] TID: Oneclick_Skin_beauty_014
      await Oneclick_Skin_beauty_014(dt);
    });
    run('Oneclick_Skin_beauty_015', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [多语言一键美肤功能验证] TID: Oneclick_Skin_beauty_015
      await Oneclick_Skin_beauty_015(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachOneClickSkinBeauty').init();
      dt.log.i('afterEach OneClickSkinBeauty start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach OneClickSkinBeauty finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllOneClickSkinBeauty').init();
      dt.log.i('afterAll OneClickSkinBeauty start');
      await Exit.browser();
      dt.log.i('afterAll OneClickSkinBeauty finish');
    });
  });
}

// DT步骤
/**
 * 大图-下载: [人像图片有一键美肤功能]
 * GROUP: 大图 MODULE: 下载TID: Oneclick_Skin_beauty_001
 * 前置条件
 *
 */
async function Oneclick_Skin_beauty_001(dt: Dt) {
  dt.log.i('人像图片有一键美肤功能 start');
  dt.log.i('STEP 1、图库预置人像图（遍历前置，后置，夜景，人像，拍照，下载的方式获取）');

  await dt.sleep();
  dt.log.i('STEP 2、进入图库，大图预览人像图');

  await dt.sleep();
  dt.log.i('STEP 3、长按图片人像区域后松开');

  await dt.sleep();
  dt.log.i('预期结果3、弹出智慧菜单，智慧菜单中有一键美肤功能');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('人像图片有一键美肤功能 end');
}

/**
 * 大图-下载: [非人像图片无一键美肤功能]
 * GROUP: 大图 MODULE: 下载TID: Oneclick_Skin_beauty_002
 * 前置条件
 *
 */
async function Oneclick_Skin_beauty_002(dt: Dt) {
  dt.log.i('非人像图片无一键美肤功能 start');
  dt.log.i('STEP 1、图库预置不含人像的风景图（遍历前置，后置，夜景，人像，拍照，下载的方式获取）');

  await dt.sleep();
  dt.log.i('STEP 2、进入图库，大图预览风景图');

  await dt.sleep();
  dt.log.i('STEP 3、长按图片后松开');

  await dt.sleep();
  dt.log.i('预期结果3、弹出智慧菜单，智慧菜单中无一键美肤功能');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('非人像图片无一键美肤功能 end');
}

/**
 * 大图-大图: [一键美肤功能验证]
 * GROUP: 大图 MODULE: 大图TID: Oneclick_Skin_beauty_003
 * 前置条件
 * 图库预置人像图
 */
async function Oneclick_Skin_beauty_003(dt: Dt) {
  dt.log.i('一键美肤功能验证 start');
  dt.log.i('STEP 1、进入图库，大图预览人像图');

  await dt.sleep();
  dt.log.i('STEP 2、长按图片人像区域后松开');

  await dt.sleep();
  dt.log.i('预期结果2、弹出智慧菜单，智慧菜单中包括一键美肤功能；人像主体边缘界限变明显；人像背景变暗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击智慧菜单中的一键美肤');

  await dt.sleep();
  dt.log.i('预期结果3、人像主体放大；人像有美肤效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('一键美肤功能验证 end');
}

/**
 * 大图-大图: [编辑后一键美肤功能验证]
 * GROUP: 大图 MODULE: 大图TID: Oneclick_Skin_beauty_004
 * 前置条件
 * 图库预置人像图
 */
async function Oneclick_Skin_beauty_004(dt: Dt) {
  dt.log.i('编辑后一键美肤功能验证 start');
  dt.log.i('STEP 1、进入图库，大图预览人像图');

  await dt.sleep();
  dt.log.i('STEP 2、点击大图下方的编辑图标，对图片进行编辑后保存（修改裁剪&调节&滤镜）');

  await dt.sleep();
  dt.log.i('预期结果2、图片无美肤效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、长按图片人像区域后松开');

  await dt.sleep();
  dt.log.i('预期结果3、弹出智慧菜单，智慧菜单中包括一键美肤功能；人像主体边缘界限变明显；人像背景变暗');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击智慧菜单中的一键美肤');

  await dt.sleep();
  dt.log.i('预期结果4、人像主体放大；人像有美肤效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑后一键美肤功能验证 end');
}

/**
 * 大图-大图: [一键美肤后编辑功能验证]
 * GROUP: 大图 MODULE: 大图TID: Oneclick_Skin_beauty_005
 * 前置条件
 * 图库预置人像图
 */
async function Oneclick_Skin_beauty_005(dt: Dt) {
  dt.log.i('一键美肤后编辑功能验证 start');
  dt.log.i('STEP 1、进入图库，大图预览人像图');

  await dt.sleep();
  dt.log.i('STEP 2、长按图片人像区域后松开');

  await dt.sleep();
  dt.log.i('预期结果2、弹出智慧菜单，智慧菜单中包括一键美肤功能；人像主体边缘界限变明显；人像背景变暗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击智慧菜单中的一键美肤');

  await dt.sleep();
  dt.log.i('预期结果3、人像主体放大；人像有美肤效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击大图下方的编辑图标，对美肤后的图片进行编辑后覆盖原图');

  await dt.sleep();
  dt.log.i('预期结果4、图片被编辑，且美肤效果不受影响');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、点击大图下方的编辑图标，对美肤后的图片进行编辑后另存');

  await dt.sleep();
  dt.log.i('预期结果5、原图无编辑效果，且美肤效果不受影响；新生成的图片被编辑，且美肤效果不受影响');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('一键美肤后编辑功能验证 end');
}

/**
 * 大图-大图: [取消一键美肤功能验证]
 * GROUP: 大图 MODULE: 大图TID: Oneclick_Skin_beauty_006
 * 前置条件
 * 图库预置人像图
 */
async function Oneclick_Skin_beauty_006(dt: Dt) {
  dt.log.i('取消一键美肤功能验证 start');
  dt.log.i('STEP 1、进入图库，大图预览美肤后的人像图');

  await dt.sleep();
  dt.log.i('STEP 2、长按图片人像区域后松开');

  await dt.sleep();
  dt.log.i('预期结果2、弹出智慧菜单，智慧菜单中包括取消美肤功能；人像主体边缘界限变明显；人像背景变暗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击取消美肤');

  await dt.sleep();
  dt.log.i('预期结果3、人像美肤效果被取消');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('取消一键美肤功能验证 end');
}

/**
 * 大图-大图: [美肤且编辑后一键还原功能验证]
 * GROUP: 大图 MODULE: 大图TID: Oneclick_Skin_beauty_007
 * 前置条件
 * 图库预置人像图
 */
async function Oneclick_Skin_beauty_007(dt: Dt) {
  dt.log.i('美肤且编辑后一键还原功能验证 start');
  dt.log.i('STEP 1、进入图库，大图预览人像图');

  await dt.sleep();
  dt.log.i('STEP 2、一键美肤');

  await dt.sleep();
  dt.log.i('预期结果2、图片有美肤效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、编辑美肤后的图片（编辑后另存和覆盖都可以）');

  await dt.sleep();
  dt.log.i('预期结果3、图片被编辑且美肤效果没有改变');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、一键还原一张已美肤且已编辑的图片');

  await dt.sleep();
  dt.log.i('预期结果4、图片被还原到最初状态（无美肤效果也无编辑效果）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('美肤且编辑后一键还原功能验证 end');
}

/**
 * 大图-下载: [LCD人像图一键美肤功能验证]
 * GROUP: 大图 MODULE: 下载TID: Oneclick_Skin_beauty_008
 * 前置条件
 * 图库登录云空间
 */
async function Oneclick_Skin_beauty_008(dt: Dt) {
  dt.log.i('LCD人像图一键美肤功能验证 start');
  dt.log.i('STEP 1、图库大图预览云空间的人像图');

  await dt.sleep();
  dt.log.i('STEP 2、长按图片人像区域后松开');

  await dt.sleep();
  dt.log.i('预期结果2、弹出智慧菜单，智慧菜单中包括一键美肤功能；后台同步开始自动下载原图，图片右下角出现加载状态；加载完成后加载状态消失，图片右上角的下载按钮消失');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('LCD人像图一键美肤功能验证 end');
}

/**
 * 大图-进入大图: [相机入口一键美肤功能验证]
 * GROUP: 大图 MODULE: 进入大图TID: Oneclick_Skin_beauty_009
 * 前置条件
 *
 */
async function Oneclick_Skin_beauty_009(dt: Dt) {
  dt.log.i('相机入口一键美肤功能验证 start');
  dt.log.i('STEP 1、相机拍摄一张人像图（遍历前置，后置，夜景，人像，拍照的方式获取）');

  await dt.sleep();
  dt.log.i('STEP 2、点击相机缩略图进入大图预览');

  await dt.sleep();
  dt.log.i('STEP 3、长按图片人像区域后拉起智慧菜单');

  await dt.sleep();
  dt.log.i('预期结果3、智慧菜单中包括一键美肤功能 ');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击智慧菜单中的一键美肤');

  await dt.sleep();
  dt.log.i('预期结果4、图片人像有美肤效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、对美肤后的图片再次长按后拉起智慧菜单');

  await dt.sleep();
  dt.log.i('预期结果5、智慧菜单中包括取消美肤功能');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、点击取消美肤');

  await dt.sleep();
  dt.log.i('预期结果6、图片人像取消美肤效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机入口一键美肤功能验证 end');
}

/**
 * 大图-: [一键美肤后分享功能验证]
 * GROUP: 大图 MODULE: TID: Oneclick_Skin_beauty_010
 * 前置条件
 * 图库预置人像图
 */
async function Oneclick_Skin_beauty_010(dt: Dt) {
  dt.log.i('一键美肤后分享功能验证 start');
  dt.log.i('STEP 1、对人像图片进行一键美肤');

  await dt.sleep();
  dt.log.i('STEP 2、分享美肤后的图片给辅助机');

  await dt.sleep();
  dt.log.i('预期结果2、辅助机接收到的图片为有美肤效果的图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、辅助机接收到图片之后长按人像区域后拉起智慧菜单');

  await dt.sleep();
  dt.log.i('预期结果3、智慧菜单中包括一键美肤功能 ');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击一键美肤');

  await dt.sleep();
  dt.log.i('预期结果4、图片人像被再次美肤');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、对美肤后的图片再次长按人像区域后拉起智慧菜单');

  await dt.sleep();
  dt.log.i('预期结果5、智慧菜单中包括取消美肤功能');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、点击取消美肤');

  await dt.sleep();
  dt.log.i('预期结果6、图片恢复到辅助机接收到的图片状态');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('一键美肤后分享功能验证 end');
}

/**
 * 大图-下载: [云端下载人像图一键美肤功能验证]
 * GROUP: 大图 MODULE: 下载TID: Oneclick_Skin_beauty_011
 * 前置条件
 * 图库登录云空间，并且云上有一张已经美肤过的图片
 */
async function Oneclick_Skin_beauty_011(dt: Dt) {
  dt.log.i('云端下载人像图一键美肤功能验证 start');
  dt.log.i('STEP 1、云端下载美肤后的人像图片');

  await dt.sleep();
  dt.log.i('STEP 2、长按图片人像区域后拉起智慧菜单');

  await dt.sleep();
  dt.log.i('预期结果2、智慧菜单中包括取消美肤功能');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击智慧菜单中的取消美肤');

  await dt.sleep();
  dt.log.i('预期结果3、图片人像美肤效果被取消');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、再次长按图片人像区域后拉起智慧菜单');

  await dt.sleep();
  dt.log.i('预期结果4、智慧菜单中包括一键美肤功能');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、点击智慧菜单中的一键美肤');

  await dt.sleep();
  dt.log.i('预期结果5、图片人像被再次美肤');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云端下载人像图一键美肤功能验证 end');
}

/**
 * 大图-竖屏: [一键美肤切换横竖屏xxxxxx功能验证]
 * GROUP: 大图 MODULE: 竖屏TID: Oneclick_Skin_beauty_014
 * 前置条件
 * 图库预置人像图
 */
async function Oneclick_Skin_beauty_014(dt: Dt) {
  dt.log.i('一键美肤切换横竖屏xxxxxx功能验证 start');
  dt.log.i('STEP 1、进入图库，大图预览人像图');

  await dt.sleep();
  dt.log.i('STEP 2、长按图片人像区域后松开，点击智慧菜单中的一键美肤');

  await dt.sleep();
  dt.log.i('预期结果2、图片人像有美肤效果4、图片人像美肤效果被取消');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、切换横竖屏或者xxxxxx');

  await dt.sleep();
  dt.log.i('STEP 4、长按图片人像区域后松开，点击智慧菜单中的取消美肤');

  await dt.sleep();
  dt.log.i('预期结果4、图片人像美肤效果被取消');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('一键美肤切换横竖屏xxxxxx功能验证 end');
}

/**
 * 大图-大图: [多语言一键美肤功能验证]
 * GROUP: 大图 MODULE: 大图TID: Oneclick_Skin_beauty_015
 * 前置条件
 * 图库预置人像图
 */
async function Oneclick_Skin_beauty_015(dt: Dt) {
  dt.log.i('多语言一键美肤功能验证 start');
  dt.log.i('STEP 1、设置-通用-语言和地区-切换语言');

  await dt.sleep();
  dt.log.i('STEP 2、进入图库，大图预览人像图');

  await dt.sleep();
  dt.log.i('STEP 3、长按图片人像区域后松开');

  await dt.sleep();
  dt.log.i('预期结果3、弹出智慧菜单，智慧菜单中包括一键美肤功能，智慧弹窗中语言跟随系统语言变化；人像主体边缘界限变明显；人像背景变暗');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击智慧菜单中的一键美肤');

  await dt.sleep();
  dt.log.i('预期结果4、人像主体放大；人像有美肤效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、长按图片人像区域后松开');

  await dt.sleep();
  dt.log.i('预期结果5、弹出智慧菜单，智慧菜单中包括取消美肤功能，智慧弹窗中语言跟随系统语言变化；人像主体边缘界限变明显；人像背景变暗');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、点击智慧菜单中的取消美肤');

  await dt.sleep();
  dt.log.i('预期结果6、人像美肤效果被取消');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多语言一键美肤功能验证 end');
}

