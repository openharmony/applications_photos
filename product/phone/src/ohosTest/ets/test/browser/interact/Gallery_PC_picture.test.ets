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
import { abilityDelegator, run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';

export default function GalleryPCpicture(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('Gallery_PC_pictureTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllGallery_PC_picture').init();
      dt.log.i('beforeAll Gallery_PC_picture start');
      dt.log.i('beforeAll Gallery_PC_picture finish');
    });
    /**
     * 打开大图
     */
    it('beforeGallery_PC_picture', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    // DT声明
    it('Multimedia_Gallery_PC_picture_001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC大图保留侧边栏] TID: Multimedia_Gallery_PC_picture_001
      await Multimedia_Gallery_PC_picture_001(dt);
    });
    it('Multimedia_Gallery_PC_picture_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-沉浸用例: [PC大图不支持沉浸式] TID: Multimedia_Gallery_PC_picture_002
      await Multimedia_Gallery_PC_picture_002(dt);
    });
    it('Multimedia_Gallery_PC_picture_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [PC窗口最大化] TID: Multimedia_Gallery_PC_picture_003
      await Multimedia_Gallery_PC_picture_003(dt);
    });
    it('Multimedia_Gallery_PC_picture_004', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC退出大图] TID: Multimedia_Gallery_PC_picture_004
      await Multimedia_Gallery_PC_picture_004(dt);
    });
    it('Multimedia_Gallery_PC_picture_005', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC大图页面侧边栏切换] TID: Multimedia_Gallery_PC_picture_005
      await Multimedia_Gallery_PC_picture_005(dt);
    });
    it('Multimedia_Gallery_PC_picture_006', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC大图页面显示比例] TID: Multimedia_Gallery_PC_picture_006
      await Multimedia_Gallery_PC_picture_006(dt);
    });
    it('Multimedia_Gallery_PC_picture_007', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-预览条用例: [PC大图页面预览条显示] TID: Multimedia_Gallery_PC_picture_007
      await Multimedia_Gallery_PC_picture_007(dt);
    });
    it('Multimedia_Gallery_PC_picture_008', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC侧边栏与大图焦点切换] TID: Multimedia_Gallery_PC_picture_008
      await Multimedia_Gallery_PC_picture_008(dt);
    });
    it('Multimedia_Gallery_PC_picture_009', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC相机入口查看大图] TID: Multimedia_Gallery_PC_picture_009
      await Multimedia_Gallery_PC_picture_009(dt);
    });
    it('Multimedia_Gallery_PC_picture_010', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PCpicker入口查看大图] TID: Multimedia_Gallery_PC_picture_010
      await Multimedia_Gallery_PC_picture_010(dt);
    });
    it('Multimedia_Gallery_PC_picture_011', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC大图页面适配深色模式] TID: Multimedia_Gallery_PC_picture_011
      await Multimedia_Gallery_PC_picture_011(dt);
    });
    it('Multimedia_Gallery_PC_picture_012', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC大图页面适配适老化] TID: Multimedia_Gallery_PC_picture_012
      await Multimedia_Gallery_PC_picture_012(dt);
    });
    it('Multimedia_Gallery_PC_picture_013', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC大图页面适配多语言] TID: Multimedia_Gallery_PC_picture_013
      await Multimedia_Gallery_PC_picture_013(dt);
    });
    it('Multimedia_Gallery_PC_picture_014', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC全屏大图显示ESC回退] TID: Multimedia_Gallery_PC_picture_014
      await Multimedia_Gallery_PC_picture_014(dt);
    });
    it('Multimedia_Gallery_PC_picture_015', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [PC全屏宫格多选ESC回退] TID: Multimedia_Gallery_PC_picture_015
      await Multimedia_Gallery_PC_picture_015(dt);
    });
    it('Multimedia_Gallery_PC_picture_016', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC大图页面分享] TID: Multimedia_Gallery_PC_picture_016
      await Multimedia_Gallery_PC_picture_016(dt);
    });
    it('Multimedia_Gallery_PC_picture_017', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [PC大图页面收藏] TID: Multimedia_Gallery_PC_picture_017
      await Multimedia_Gallery_PC_picture_017(dt);
    });
    it('Multimedia_Gallery_PC_picture_018', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC大图页面编辑] TID: Multimedia_Gallery_PC_picture_018
      await Multimedia_Gallery_PC_picture_018(dt);
    });
    it('Multimedia_Gallery_PC_picture_019', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [PC大图页面删除隐藏] TID: Multimedia_Gallery_PC_picture_019
      await Multimedia_Gallery_PC_picture_019(dt);
    });
    it('Multimedia_Gallery_PC_picture_020', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [PC大图页面打开详情] TID: Multimedia_Gallery_PC_picture_020
      await Multimedia_Gallery_PC_picture_020(dt);
    });
    it('Multimedia_Gallery_PC_picture_021', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [PC视频大图页面] TID: Multimedia_Gallery_PC_picture_021
      await Multimedia_Gallery_PC_picture_021(dt);
    });
    it('Multimedia_Gallery_PC_picture_022', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [PC最近删除相册大图页面] TID: Multimedia_Gallery_PC_picture_022
      await Multimedia_Gallery_PC_picture_022(dt);
    });
    it('Multimedia_Gallery_PC_picture_023', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC隐藏相册大图页面] TID: Multimedia_Gallery_PC_picture_023
      await Multimedia_Gallery_PC_picture_023(dt);
    });
    it('Multimedia_Gallery_PC_picture_024', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC搜索页面进大图] TID: Multimedia_Gallery_PC_picture_024
      await Multimedia_Gallery_PC_picture_024(dt);
    });
    it('Multimedia_Gallery_PC_picture_025', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [PC进大图点击侧边栏切换] TID: Multimedia_Gallery_PC_picture_025
      await Multimedia_Gallery_PC_picture_025(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachGallery_PC_picture').init();
      dt.log.i('afterEach Gallery_PC_picture start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach Gallery_PC_picture finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllGallery_PC_picture').init();
      dt.log.i('afterAll Gallery_PC_picture start');
      await Exit.browser();
      dt.log.i('afterAll Gallery_PC_picture finish');
    });
  });
}

// DT步骤
/**
 * 大图-大图: [PC大图保留侧边栏]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_001
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_001(dt: Dt) {
  dt.log.i('PC大图保留侧边栏 start');
  dt.log.i('STEP 1、PC宫格页面打开大图');


  dt.log.i('预期结果1、大图页面保留侧边栏显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、拖动窗口大小');


  dt.log.i('预期结果2、图片和侧边栏跟随窗口大小调整，过程顺畅，无跳变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、缩小窗口宽度至840dp');


  dt.log.i('预期结果3、侧边栏自动xxx');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、放大窗口超过840dp后');


  dt.log.i('预期结果4、侧边栏自动展开');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图保留侧边栏 end');
}

/**
 * 大图-沉浸: [PC大图不支持沉浸式]
 * GROUP: 大图 MODULE: 沉浸TID: Multimedia_Gallery_PC_picture_002
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_002(dt: Dt) {
  dt.log.i('PC大图不支持沉浸式 start');
  dt.log.i('STEP 1、PC宫格页面打开大图');


  dt.log.i('预期结果1、大图页面保留侧边栏显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、大图页面单击图片位置');

  await dt.sleep();
  dt.log.i('预期结果2.1、图片不会进入沉浸式显示2.2、背景色保持白色2.3、标题栏和底部缩略图预览图保留显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图不支持沉浸式 end');
}

/**
 * 大图-视频: [PC窗口最大化]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_picture_003
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_003(dt: Dt) {
  dt.log.i('PC窗口最大化 start');
  dt.log.i('STEP 1、PC宫格页面窗口最大化显示');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果1.1、桌面底部dock栏、顶部状态栏跟随系统能力自动隐藏。1.2、鼠标移动到状态栏。Dock栏位置时支持呼出显示（系统能力暂时不支持，dock栏和顶部状态栏常驻）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、PC大图页面窗口最大化显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC窗口最大化 end');
}

/**
 * 大图-大图: [PC退出大图]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_004
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_004(dt: Dt) {
  dt.log.i('PC退出大图 start');
  dt.log.i('STEP 1、PC宫格页面打开大图');


  dt.log.i('预期结果1、图片正常返回到宫格页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.1、点击标题栏左侧返回按钮2.2、点击ESC键2.3、点击空格键');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC退出大图 end');
}

/**
 * 大图-大图: [PC大图页面侧边栏切换]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_005
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_005(dt: Dt) {
  dt.log.i('PC大图页面侧边栏切换 start');
  dt.log.i('STEP 1、PC相册A宫格页面打开大图');


  dt.log.i('STEP 2、点击侧边栏切换到其他相册B');


  dt.log.i('预期结果2、切换至相册B的宫格页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次切换回相册A');


  dt.log.i('预期结果3、切换回相册A的宫格页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图页面侧边栏切换 end');
}

/**
 * 大图-大图: [PC大图页面显示比例]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_006
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_006(dt: Dt) {
  dt.log.i('PC大图页面显示比例 start');
  dt.log.i('STEP 1、PC宫格页面打开大图');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果1、图片正常显示，不被标题栏和预览条遮挡');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、双指捏合调整图片大小');


  dt.log.i('预期结果2、图片正常响应缩放缩小，过程流畅跟手，标题栏和预览条正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、双击放大和缩小图片');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图页面显示比例 end');
}

/**
 * 大图-预览条: [PC大图页面预览条显示]
 * GROUP: 大图 MODULE: 预览条TID: Multimedia_Gallery_PC_picture_007
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_007(dt: Dt) {
  dt.log.i('PC大图页面预览条显示 start');
  dt.log.i('STEP 1、相册宫格中只有一张图片时');


  dt.log.i('预期结果1、图片底部保持显示预览条');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、打开大图查看');


  dt.log.i('STEP 3、相册宫格中有多张图片时2、打开大图查看');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图页面预览条显示 end');
}

/**
 * 大图-大图: [PC侧边栏与大图焦点切换]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_008
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_008(dt: Dt) {
  dt.log.i('PC侧边栏与大图焦点切换 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC侧边栏与大图焦点切换 end');
}

/**
 * 大图-大图: [PC相机入口查看大图]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_009
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_009(dt: Dt) {
  dt.log.i('PC相机入口查看大图 start');
  dt.log.i('STEP 1、从相机入口点击缩略图进入大图');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果1、大图页面正常显示图片，顶部操作栏和预览条常驻，和图库中打开的效果一致');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击tab键入焦');


  dt.log.i('预期结果2、焦点切换到大图页面标题栏上的操作按钮');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击上下左右键');


  dt.log.i('预期结果3、焦点在操作按钮上进行切换，右键和上键相同，左键和下键相同');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC相机入口查看大图 end');
}

/**
 * 大图-大图: [PCpicker入口查看大图]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_010
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_010(dt: Dt) {
  dt.log.i('PCpicker入口查看大图 start');
  dt.log.i('STEP 1、使用三方picker拉起图库');


  dt.log.i('预期结果1、大图页面正常显示图片，无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击图片进入大图');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PCpicker入口查看大图 end');
}

/**
 * 大图-大图: [PC大图页面适配深色模式]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_011
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_011(dt: Dt) {
  dt.log.i('PC大图页面适配深色模式 start');
  dt.log.i('STEP 1、系统打开深色模式');


  dt.log.i('预期结果1、大图页面正常显示，适配深色模式');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在图库页面打开大图查看');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图页面适配深色模式 end');
}

/**
 * 大图-大图: [PC大图页面适配适老化]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_012
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_012(dt: Dt) {
  dt.log.i('PC大图页面适配适老化 start');
  dt.log.i('STEP 1、在设置页面设置不同字体显示大小');
  await dt.swipeScreen?.left();

  dt.log.i('STEP 2、在图库页面打开大图查看');


  dt.log.i('预期结果2、5、大图页面字体显示大小跟随系统，正常适配');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、保持图库窗口大图页面打开状态');


  dt.log.i('STEP 4、在设置页面调整字体显示大小');


  dt.log.i('STEP 5、查看图库大图页面');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图页面适配适老化 end');
}

/**
 * 大图-大图: [PC大图页面适配多语言]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_013
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_013(dt: Dt) {
  dt.log.i('PC大图页面适配多语言 start');
  dt.log.i('STEP 1、在设置页面设置不同语言模式（英文、维吾尔文（镜像显示）、藏文、繁体中文、简体中文）');


  dt.log.i('STEP 2、在图库页面打开大图查看');


  dt.log.i('预期结果2、5、大图页面语言显示跟随系统，正常适配');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、保持图库窗口大图页面打开状态');


  dt.log.i('STEP 4、在设置页面不同语言模式');


  dt.log.i('STEP 5、查看图库大图页面');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图页面适配多语言 end');
}

/**
 * 大图-大图: [PC全屏大图显示ESC回退]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_014
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_014(dt: Dt) {
  dt.log.i('PC全屏大图显示ESC回退 start');
  dt.log.i('STEP 1、图片设置全屏显示');


  dt.log.i('STEP 2、打开大图查看');


  dt.log.i('STEP 3、点击esc键');


  dt.log.i('预期结果3、退回到宫格页面');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、再次点击esc键');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果4、图库退回到小屏显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC全屏大图显示ESC回退 end');
}

/**
 * 宫格-视频: [PC全屏宫格多选ESC回退]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_PC_picture_015
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_015(dt: Dt) {
  dt.log.i('PC全屏宫格多选ESC回退 start');
  dt.log.i('STEP 1、图片设置全屏显示');


  dt.log.i('STEP 2、在宫格页面多选选中几张图片');


  dt.log.i('STEP 3、点击esc键');


  dt.log.i('预期结果3、退回到未选中状态');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、再次点击esc键');


  dt.log.i('预期结果4、图库退回到小屏显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC全屏宫格多选ESC回退 end');
}

/**
 * 大图-大图: [PC大图页面分享]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_016
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_016(dt: Dt) {
  dt.log.i('PC大图页面分享 start');
  dt.log.i('STEP 1、在图库页面打开大图');


  dt.log.i('预期结果1、成功拉起分享框');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在大图页面点击分享按钮');


  dt.log.i('STEP 3、在系统相册、用户创建相册、智慧相册、来源相册分别重复上述操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图页面分享 end');
}

/**
 * 大图-收藏: [PC大图页面收藏]
 * GROUP: 大图 MODULE: 收藏TID: Multimedia_Gallery_PC_picture_017
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_017(dt: Dt) {
  dt.log.i('PC大图页面收藏 start');
  dt.log.i('STEP 1、在图库页面打开大图');


  dt.log.i('STEP 2、在大图页面点击收藏按钮');


  dt.log.i('预期结果2、收藏图标正常切换为收藏实心状态');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、左右滑动到下一张图片');


  dt.log.i('预期结果3、收藏图标切换为空心状态');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、在系统相册、用户创建相册、智慧相册、来源相册分别重复上述操作');
  await dt.swipeScreen?.left();
  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图页面收藏 end');
}

/**
 * 大图-大图: [PC大图页面编辑]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_018
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_018(dt: Dt) {
  dt.log.i('PC大图页面编辑 start');
  dt.log.i('STEP 1、在图库页面打开大图');


  dt.log.i('预期结果1、图片正常跳转到编辑页面，编辑页面不显示侧边栏');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在大图页面点击编辑按钮');


  dt.log.i('预期结果2、图片正常跳转回大图页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.1、编辑后进行保存（另存为、覆盖原图）3.2、编辑后进行返回');


  dt.log.i('STEP 4、在系统相册、用户创建相册、智慧相册、来源相册分别重复上述操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图页面编辑 end');
}

/**
 * 大图-删除: [PC大图页面删除隐藏]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_picture_019
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_019(dt: Dt) {
  dt.log.i('PC大图页面删除隐藏 start');
  dt.log.i('STEP 1、在图库页面打开大图');


  dt.log.i('STEP 2、在大图页面点击删除按钮，删除图片');


  dt.log.i('预期结果2、图片正常被删除，切换到下一张图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在大图页面点击隐藏按钮，隐藏图片 ');


  dt.log.i('预期结果3、图片正常被删除，切换到下一张图片');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、在系统相册、用户创建相册、智慧相册、来源相册分别重复上述操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图页面删除隐藏 end');
}

/**
 * 大图-详情: [PC大图页面打开详情]
 * GROUP: 大图 MODULE: 详情TID: Multimedia_Gallery_PC_picture_020
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_020(dt: Dt) {
  dt.log.i('PC大图页面打开详情 start');
  dt.log.i('STEP 1、在图库页面打开大图');


  dt.log.i('STEP 2、触控板双指上划打开详情');


  dt.log.i('预期结果2、3、图片不响应4、图片正常打开详情5、6、7、图片保持打开详情状态，不响应8、图片正常关闭详情');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、触摸屏手指上划打开详情');


  dt.log.i('STEP 4、点击详情按钮（小i图标）打开详情');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果4、图片正常打开详情');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、触控板双指下滑关闭详情');


  dt.log.i('预期结果5、6、7、图片保持打开详情状态，不响应8、图片正常关闭详情');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、触摸屏手指下划关闭详情');


  dt.log.i('STEP 7、单机图片位置关闭详情');


  dt.log.i('STEP 8、点击详情按钮关闭详情');


  dt.log.i('预期结果8、图片正常关闭详情');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 9、在系统相册、用户创建相册、智慧相册、来源相册分别重复上述操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC大图页面打开详情 end');
}

/**
 * 大图-视频: [PC视频大图页面]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_picture_021
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_021(dt: Dt) {
  dt.log.i('PC视频大图页面 start');
  dt.log.i('STEP 1、在图库页面打开视频大图');


  dt.log.i('STEP 2、点击播放按钮');


  dt.log.i('预期结果2、视频正常播放，上方操作栏显示播放和声音按钮');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击播放按钮，关闭视频播放');


  dt.log.i('预期结果3、视频停止播放');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击声音按钮，开启或关闭静音');


  dt.log.i('预期结果4、视频静音播放');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、在系统相册、用户创建相册、智慧相册、来源相册分别重复上述操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC视频大图页面 end');
}

/**
 * 大图-删除: [PC最近删除相册大图页面]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_picture_022
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_022(dt: Dt) {
  dt.log.i('PC最近删除相册大图页面 start');
  dt.log.i('STEP 1、在图库最近删除相册打开大图');


  dt.log.i('STEP 2、点击恢复按钮');


  dt.log.i('预期结果2、图片正常被恢复，切换到下一张图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击删除按钮');


  dt.log.i('预期结果3、图片正常被删除，切换到下一张图片');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击详情按钮');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果4、图片正常打开详情');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、再次点击详情按钮');


  dt.log.i('预期结果5、图片正常关闭详情');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC最近删除相册大图页面 end');
}

/**
 * 大图-大图: [PC隐藏相册大图页面]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_023
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_023(dt: Dt) {
  dt.log.i('PC隐藏相册大图页面 start');
  dt.log.i('STEP 1、在图库隐藏相册打开大图');


  dt.log.i('STEP 2、点击取消隐藏按钮');


  dt.log.i('预期结果2、图片正常被取消隐藏，切换到下一张图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击删除按钮');


  dt.log.i('预期结果3、图片正常被删除，切换到下一张图片');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击详情按钮');


  dt.log.i('预期结果4、图片正常打开详情');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、再次点击详情按钮');


  dt.log.i('预期结果5、图片正常关闭详情');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC隐藏相册大图页面 end');
}

/**
 * 大图-大图: [PC搜索页面进大图]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_024
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_024(dt: Dt) {
  dt.log.i('PC搜索页面进大图 start');
  dt.log.i('STEP 1、在搜索页面打开大图');


  dt.log.i('预期结果1、页面正常响应');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、对图片进行分享的操作');


  dt.log.i('STEP 3、对图片进行收藏的操作');


  dt.log.i('STEP 4、对图片进行编辑的操作');


  dt.log.i('STEP 5、对图片进行删除的操作');


  dt.log.i('STEP 6、对图片进行移动到的操作');


  dt.log.i('STEP 7、对图片进行隐藏的操作');


  dt.log.i('STEP 8、对图片进行打印的操作');
  await dt.swipeScreen?.left();

  dt.log.i('STEP 9、对图片进行重命名的操作');


  dt.log.i('STEP 10、对图片进行点击详情的操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC搜索页面进大图 end');
}

/**
 * 大图-大图: [PC进大图点击侧边栏切换]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_picture_025
 * 前置条件
 * 1、图库存在图片和视频文件
 */
async function Multimedia_Gallery_PC_picture_025(dt: Dt) {
  dt.log.i('PC进大图点击侧边栏切换 start');
  dt.log.i('STEP 1、在图库页面打开大图');


  dt.log.i('预期结果1、正常切换到相册宫格，过程流畅顺滑');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击返回按钮返回到宫格2、点击侧边栏切换到其他相册宫格');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC进大图点击侧边栏切换 end');
}
