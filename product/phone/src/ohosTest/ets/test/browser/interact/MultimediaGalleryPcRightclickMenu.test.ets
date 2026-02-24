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

export default function MultimediaGalleryPcRightclickMenu(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryPcRightclickMenuTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryPcRightclickMenu').init();
      dt.log.i('beforeAll MultimediaGalleryPcRightclickMenu start');
      dt.log.i('beforeAll MultimediaGalleryPcRightclickMenu finish');
    });
    /**
     * 打开大图
     */
    it('beforeMultimediaGalleryPcRightclickMenu', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    // DT声明
    it('Multimedia_Gallery_PC_Rightclick_menu_01', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [智慧相册人像界面右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_01
      await Multimedia_Gallery_PC_Rightclick_menu_01(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_02', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [智慧相册人像界面多选后右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_02
      await Multimedia_Gallery_PC_Rightclick_menu_02(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_03', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [智慧相册人像相册大图页面右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_03
      await Multimedia_Gallery_PC_Rightclick_menu_03(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_04', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [智慧相册人像相册宫格缩略图右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_04
      await Multimedia_Gallery_PC_Rightclick_menu_04(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_05', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [智慧相册人像相册宫格缩略图多选后右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_05
      await Multimedia_Gallery_PC_Rightclick_menu_05(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_06', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [智慧相册分类相册大图页面右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_06
      await Multimedia_Gallery_PC_Rightclick_menu_06(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_07', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [智慧相册分类相册宫格右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_07
      await Multimedia_Gallery_PC_Rightclick_menu_07(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_08', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [智慧相册分类相册宫格多选后右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_08
      await Multimedia_Gallery_PC_Rightclick_menu_08(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_09', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [隐藏相册宫格右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_09
      await Multimedia_Gallery_PC_Rightclick_menu_09(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_10', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [隐藏相册宫格多选右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_10
      await Multimedia_Gallery_PC_Rightclick_menu_10(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_11', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [隐藏相册大图右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_11
      await Multimedia_Gallery_PC_Rightclick_menu_11(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_12', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [隐藏相册的相册宫格右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_12
      await Multimedia_Gallery_PC_Rightclick_menu_12(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_13', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [隐藏相册的相册宫格多选后右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_13
      await Multimedia_Gallery_PC_Rightclick_menu_13(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_14', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [最近删除相册宫格右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_14
      await Multimedia_Gallery_PC_Rightclick_menu_14(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_15', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [最近删除相册宫格多选后右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_15
      await Multimedia_Gallery_PC_Rightclick_menu_15(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_16', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [最近删除相册图标右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_16
      await Multimedia_Gallery_PC_Rightclick_menu_16(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_17', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [用户创建相册呼出右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_17
      await Multimedia_Gallery_PC_Rightclick_menu_17(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_18', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [用户创建相册右键菜单重命名相册] TID: Multimedia_Gallery_PC_Rightclick_menu_18
      await Multimedia_Gallery_PC_Rightclick_menu_18(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_19', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [用户创建相册右键菜单删除相册] TID: Multimedia_Gallery_PC_Rightclick_menu_19
      await Multimedia_Gallery_PC_Rightclick_menu_19(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_20', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [用户创建相册宫格右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_20
      await Multimedia_Gallery_PC_Rightclick_menu_20(dt);
    });
    it('Multimedia_Gallery_PC_Rightclick_menu_21', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [用户创建相册宫格多选后右键菜单] TID: Multimedia_Gallery_PC_Rightclick_menu_21
      await Multimedia_Gallery_PC_Rightclick_menu_21(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryPcRightclickMenu').init();
      dt.log.i('afterEach MultimediaGalleryPcRightclickMenu start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryPcRightclickMenu finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryPcRightclickMenu').init();
      dt.log.i('afterAll MultimediaGalleryPcRightclickMenu start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryPcRightclickMenu finish');
    });
  });
}

// DT步骤
/**
 * 大图-视频: [智慧相册人像界面右键菜单]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_Rightclick_menu_01
 * 前置条件
 * 1、图库中存在图片和视频文件
 2、充电息屏生成智慧相册
 */
async function Multimedia_Gallery_PC_Rightclick_menu_01(dt: Dt) {
  dt.log.i('智慧相册人像界面右键菜单 start');
  dt.log.i('STEP 1、展开智慧相册进入人像相册界面');

  
  dt.log.i('预期结果1、菜单显示移出');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、左键选择一个相册然后点击右键');

  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧相册人像界面右键菜单 end');
}

/**
 * 大图-视频: [智慧相册人像界面多选后右键菜单]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_PC_Rightclick_menu_02
 * 前置条件
 * 1、图库中存在图片和视频文件
 2、充电息屏生成智慧相册且人像相册大于两个
 */
async function Multimedia_Gallery_PC_Rightclick_menu_02(dt: Dt) {
  dt.log.i('智慧相册人像界面多选后右键菜单 start');
  dt.log.i('STEP 1、展开智慧相册进入人像相册界面');

  
  dt.log.i('预期结果1、菜单显示合并、移出');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、多选相册(ctrl或shift)然后点击右键');

  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧相册人像界面多选后右键菜单 end');
}

/**
 * 大图-大图: [智慧相册人像相册大图页面右键菜单]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_Rightclick_menu_03
 * 前置条件
 * 1、图库中存在图片和视频文件
 2、充电息屏生成智慧相册
 */
async function Multimedia_Gallery_PC_Rightclick_menu_03(dt: Dt) {
  dt.log.i('智慧相册人像相册大图页面右键菜单 start');
  dt.log.i('STEP 1、在人像相册进入图片大图点击右键');

  
  dt.log.i('预期结果1、菜单显示分享、收藏/取消收藏、编辑、删除、提取主体物、隐藏、移动到、复制到剪切板、打印、重命名');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在人像相册进入图片大图查看，点击更多按钮');

  
  dt.log.i('预期结果2、菜单显示提取主体物、设置为封面、隐藏、移动到、复制到剪切板、移出相册、打印，重命名');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧相册人像相册大图页面右键菜单 end');
}

/**
 * 大图-收藏: [智慧相册人像相册宫格缩略图右键菜单]
 * GROUP: 大图 MODULE: 收藏TID: Multimedia_Gallery_PC_Rightclick_menu_04
 * 前置条件
 * 1、图库中存在图片和视频文件
 2、充电息屏生成智慧相册
 */
async function Multimedia_Gallery_PC_Rightclick_menu_04(dt: Dt) {
  dt.log.i('智慧相册人像相册宫格缩略图右键菜单 start');
  dt.log.i('STEP 1、在人像相册宫格页面缩略图点击右键');

  
  dt.log.i('预期结果1、菜单显示分享、收藏/取消收藏、删除、隐藏、移动到、复制到剪切板、打印、重命名');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在人像相册宫格页面，点击右上角的更多按钮');

  
  dt.log.i('预期结果2、菜单显示更换封面、从人像相册移出、多选、设置为我（仅在相册为非“我”相册）');
  await dt.sleep(DELAY.double);
  await dt.assertComponent(PageTitle.index, true);//ON.text('我'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧相册人像相册宫格缩略图右键菜单 end');
}

/**
 * 大图-收藏: [智慧相册人像相册宫格缩略图多选后右键菜单]
 * GROUP: 大图 MODULE: 收藏TID: Multimedia_Gallery_PC_Rightclick_menu_05
 * 前置条件
 * 1、图库中存在图片和视频文件
 2、充电息屏生成智慧相册
 */
async function Multimedia_Gallery_PC_Rightclick_menu_05(dt: Dt) {
  dt.log.i('智慧相册人像相册宫格缩略图多选后右键菜单 start');
  dt.log.i('STEP 1、在人像相册宫格页面多选(2-9张)张照片后点击右键');

  
  dt.log.i('预期结果1、菜单显示分享、收藏/取消收藏（仅在全部被收藏的情况下有取消收藏）、删除、对比、拼图、隐藏、移动到、复制到剪切板、打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在人像相册宫格页面选中几张图片，点击右上角的更多按钮');

  
  dt.log.i('预期结果2、菜单显示收藏、更换封面、从人像相册移出、隐藏、移动到、复制到剪切板、打印');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧相册人像相册宫格缩略图多选后右键菜单 end');
}

/**
 * 大图-大图: [智慧相册分类相册大图页面右键菜单]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_Rightclick_menu_06
 * 前置条件
 * 1、图库中存在图片和视频文件
 2、充电息屏生成智慧相册
 */
async function Multimedia_Gallery_PC_Rightclick_menu_06(dt: Dt) {
  dt.log.i('智慧相册分类相册大图页面右键菜单 start');
  dt.log.i('STEP 1、在分类相册进入图片大图点击右键');

  
  dt.log.i('预期结果1、菜单显示分享、收藏/取消收藏、编辑、删除、提取主体物、隐藏、移动到、复制到剪切板、打印、重命名');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在分类相册进入图片大图查看，点击点击更多按钮');

  
  dt.log.i('预期结果2、菜单显示提取主体物、隐藏、移动到、复制到剪切板、打印，重命名');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧相册分类相册大图页面右键菜单 end');
}

/**
 * 大图-收藏: [智慧相册分类相册宫格右键菜单]
 * GROUP: 大图 MODULE: 收藏TID: Multimedia_Gallery_PC_Rightclick_menu_07
 * 前置条件
 * 1、图库中存在图片和视频文件
 2、充电息屏生成智慧相册
 */
async function Multimedia_Gallery_PC_Rightclick_menu_07(dt: Dt) {
  dt.log.i('智慧相册分类相册宫格右键菜单 start');
  dt.log.i('STEP 1、在分类相册宫格页面缩略图点击右键');

  
  dt.log.i('预期结果1、菜单显示分享、收藏/取消收藏、删除、隐藏、移动到、复制到剪切板、打印、重命名');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在分类相册宫格页面，点击右上角的更多按钮');

  
  dt.log.i('预期结果2、菜单显示多选');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧相册分类相册宫格右键菜单 end');
}

/**
 * 大图-收藏: [智慧相册分类相册宫格多选后右键菜单]
 * GROUP: 大图 MODULE: 收藏TID: Multimedia_Gallery_PC_Rightclick_menu_08
 * 前置条件
 * 1、图库中存在图片和视频文件
 2、充电息屏生成智慧相册
 */
async function Multimedia_Gallery_PC_Rightclick_menu_08(dt: Dt) {
  dt.log.i('智慧相册分类相册宫格多选后右键菜单 start');
  dt.log.i('STEP 1、在分类相册宫格页面多选(2-9张)张照片后点击右键');

  
  dt.log.i('预期结果1、菜单显示分享、收藏/取消收藏（仅在全部被收藏的情况下有取消收藏）、删除、对比、拼图、隐藏、移动到、复制到剪切板、打印、移出');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在分类相册宫格页面选中几张图片，点击右上角的更多按钮');

  
  dt.log.i('预期结果2、菜单显示收藏、隐藏、移动到、复制到剪切板、打印');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧相册分类相册宫格多选后右键菜单 end');
}

/**
 * 大图-收藏: [隐藏相册宫格右键菜单]
 * GROUP: 大图 MODULE: 收藏TID: Multimedia_Gallery_PC_Rightclick_menu_09
 * 前置条件
 * 1、隐藏相册中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_Rightclick_menu_09(dt: Dt) {
  dt.log.i('隐藏相册宫格右键菜单 start');
  dt.log.i('STEP 1、在最近删除相册宫格页面缩略图点击右键');

  
  dt.log.i('预期结果1、菜单显示收藏、删除、取消隐藏、复制到剪切板');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在最近删除相册宫格页面，点击右上角的更多按钮');

  
  dt.log.i('预期结果2、菜单显示复制到剪切板、多选，切换相册视图');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册宫格右键菜单 end');
}

/**
 * 大图-收藏: [隐藏相册宫格多选右键菜单]
 * GROUP: 大图 MODULE: 收藏TID: Multimedia_Gallery_PC_Rightclick_menu_10
 * 前置条件
 * 1、隐藏相册中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_Rightclick_menu_10(dt: Dt) {
  dt.log.i('隐藏相册宫格多选右键菜单 start');
  dt.log.i('STEP 1、在最近删除相册宫格页面多选缩略图点击右键');

  
  dt.log.i('预期结果1、菜单显示收藏/取消收藏（仅在全部被收藏的情况下有取消收藏）、删除、取消隐藏、复制到剪切板');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在最近删除相册宫格页面，点击右上角的更多按钮');

  
  dt.log.i('预期结果2、菜单显示复制到剪切板');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册宫格多选右键菜单 end');
}

/**
 * 大图-大图: [隐藏相册大图右键菜单]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_PC_Rightclick_menu_11
 * 前置条件
 * 1、隐藏相册中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_Rightclick_menu_11(dt: Dt) {
  dt.log.i('隐藏相册大图右键菜单 start');
  dt.log.i('STEP 1、在最近删除相册大图页面点击右键');

  
  dt.log.i('预期结果1、菜单显示收藏/取消收藏、编辑、删除、提取主体物、取消隐藏、复制到剪切板');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在最近删除相册宫格页面，点击右上角的更多按钮');

  
  dt.log.i('预期结果2、菜单显示提取主体物、复制到剪切板');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册大图右键菜单 end');
}

/**
 * 大图-删除: [隐藏相册的相册宫格右键菜单]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_Rightclick_menu_12
 * 前置条件
 * 1、隐藏相册中存在来源相册
 */
async function Multimedia_Gallery_PC_Rightclick_menu_12(dt: Dt) {
  dt.log.i('隐藏相册的相册宫格右键菜单 start');
  dt.log.i('STEP 1、在最近删除相册的相册宫格页面选择一个相册点击右键');

  
  dt.log.i('预期结果1、菜单显示取消隐藏、删除');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在最近删除相册的相册宫格页面，点击右上角的更多按钮');

  
  dt.log.i('预期结果2、此单显示多选、切换图片视图');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册的相册宫格右键菜单 end');
}

/**
 * 大图-删除: [隐藏相册的相册宫格多选后右键菜单]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_Rightclick_menu_13
 * 前置条件
 * 1、隐藏相册中存在多个来源相册
 */
async function Multimedia_Gallery_PC_Rightclick_menu_13(dt: Dt) {
  dt.log.i('隐藏相册的相册宫格多选后右键菜单 start');
  dt.log.i('STEP 1、在最近删除相册的相册宫格页面多选相册点击右键');

  
  dt.log.i('预期结果1、菜单显示取消隐藏、删除');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册的相册宫格多选后右键菜单 end');
}

/**
 * 大图-删除: [最近删除相册宫格右键菜单]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_Rightclick_menu_14
 * 前置条件
 * 1、最近删除图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_Rightclick_menu_14(dt: Dt) {
  dt.log.i('最近删除相册宫格右键菜单 start');
  dt.log.i('STEP 1、在最近删除相册宫格页面缩略图点击右键');

  
  dt.log.i('预期结果1、菜单显示多选、恢复、删除');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在最近删除相册宫格页面，点击右上角的更多按钮');

  
  dt.log.i('预期结果2、菜单显示多选、清空最近删除、设置、关于');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除相册宫格右键菜单 end');
}

/**
 * 大图-删除: [最近删除相册宫格多选后右键菜单]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_Rightclick_menu_15
 * 前置条件
 * 1、最近删除图库中存在图片和视频文件
 */
async function Multimedia_Gallery_PC_Rightclick_menu_15(dt: Dt) {
  dt.log.i('最近删除相册宫格多选后右键菜单 start');
  dt.log.i('STEP 1、在最近删除相册宫格页面多选选中几个图片，然后点击右键');

  
  dt.log.i('预期结果1、菜单显示恢复、删除');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除相册宫格多选后右键菜单 end');
}

/**
 * 大图-删除: [最近删除相册图标右键菜单]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_Rightclick_menu_16
 * 前置条件
 * 1、存在最近删除图库
 */
async function Multimedia_Gallery_PC_Rightclick_menu_16(dt: Dt) {
  dt.log.i('最近删除相册图标右键菜单 start');
  dt.log.i('STEP 1、在最近删除相册图标点击右键');

  
  dt.log.i('预期结果1、菜单显示恢复最近删除');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除相册图标右键菜单 end');
}

/**
 * 大图-删除: [用户创建相册呼出右键菜单]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_Rightclick_menu_17
 * 前置条件
 * 1、图库中存在用户自建相册
 */
async function Multimedia_Gallery_PC_Rightclick_menu_17(dt: Dt) {
  dt.log.i('用户创建相册呼出右键菜单 start');
  dt.log.i('STEP 1、在侧边栏用户创建相册点击右键');

  
  dt.log.i('预期结果1、菜单显示重命名相册、删除相册');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户创建相册呼出右键菜单 end');
}

/**
 * 大图-删除: [用户创建相册右键菜单重命名相册]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_Rightclick_menu_18
 * 前置条件
 * 1、图库中存在用户自建相册
 */
async function Multimedia_Gallery_PC_Rightclick_menu_18(dt: Dt) {
  dt.log.i('用户创建相册右键菜单重命名相册 start');
  dt.log.i('STEP 1、在侧边栏用户创建相册点击右键');

  
  dt.log.i('预期结果1、菜单显示重命名相册、删除相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击重命名相册');

  
  dt.log.i('预期结果2、可以正常修改相册名称');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户创建相册右键菜单重命名相册 end');
}

/**
 * 大图-删除: [用户创建相册右键菜单删除相册]
 * GROUP: 大图 MODULE: 删除TID: Multimedia_Gallery_PC_Rightclick_menu_19
 * 前置条件
 * 1、图库中存在用户自建相册
 */
async function Multimedia_Gallery_PC_Rightclick_menu_19(dt: Dt) {
  dt.log.i('用户创建相册右键菜单删除相册 start');
  dt.log.i('STEP 1、在侧边栏用户创建相册点击右键');

  
  dt.log.i('预期结果1、菜单显示重命名相册、删除相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击删除相册');

  
  dt.log.i('预期结果2、可以正常删除相册');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户创建相册右键菜单删除相册 end');
}

/**
 * 大图-收藏: [用户创建相册宫格右键菜单]
 * GROUP: 大图 MODULE: 收藏TID: Multimedia_Gallery_PC_Rightclick_menu_20
 * 前置条件
 * 1、图库中用户创建相册存在图片、视频文件
 */
async function Multimedia_Gallery_PC_Rightclick_menu_20(dt: Dt) {
  dt.log.i('用户创建相册宫格右键菜单 start');
  dt.log.i('STEP 1、在用户创建相册宫格页面缩略图点击右键');

  
  dt.log.i('预期结果1、菜单显示分享、收藏/取消收藏、删除、隐藏、移动到、复制到剪贴板、打印、重命名');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在用户创建相册宫格页面，点击右上角的更多按钮');

  
  dt.log.i('预期结果2、菜单显示多选、重命名相册、删除相册、设置、关于ps：含有视频时不显示打印');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户创建相册宫格右键菜单 end');
}

/**
 * 大图-收藏: [用户创建相册宫格多选后右键菜单]
 * GROUP: 大图 MODULE: 收藏TID: Multimedia_Gallery_PC_Rightclick_menu_21
 * 前置条件
 * 1、图库中用户创建相册存在图片、视频文件
 */
async function Multimedia_Gallery_PC_Rightclick_menu_21(dt: Dt) {
  dt.log.i('用户创建相册宫格多选后右键菜单 start');
  dt.log.i('STEP 1、在用户创建相册宫格页面进入多选后，选中几张图片，点击右键');

  
  dt.log.i('预期结果1、菜单显示分享、收藏/取消收藏（仅在全部被收藏的情况下有取消收藏））、删除、对比、拼图、隐藏、移动到、复制到剪贴板、打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在用户创建相册宫格页面，点击右上角的更多按钮');

  
  dt.log.i('预期结果2、菜单显示收藏、隐藏、移动到、复制到剪切板ps：含有视频时不显示打印');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户创建相册宫格多选后右键菜单 end');
}

