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

export default function DemoUi(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('DemoUiTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllDemoUi').init();
      dt.log.i('beforeAll DemoUi start');
      dt.log.i('beforeAll DemoUi finish');
    });
    /**
     * 打开大图
     */
    run('beforeDemoUi', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('Multimedia_Gallery_Slideshow_001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [照片页图片幻灯片播放] TID: Multimedia_Gallery_Slideshow_001
      await Multimedia_Gallery_Slideshow_001(dt);
    });
    run('Multimedia_Gallery_Slideshow_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [照片页视频无幻灯片播放入口] TID: Multimedia_Gallery_Slideshow_002
      await Multimedia_Gallery_Slideshow_002(dt);
    });
    run('Multimedia_Gallery_Slideshow_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [幻灯片播放系统相册内的照片] TID: Multimedia_Gallery_Slideshow_003
      await Multimedia_Gallery_Slideshow_003(dt);
    });
    run('Multimedia_Gallery_Slideshow_004', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [最近删除相册无幻灯片播放入口] TID: Multimedia_Gallery_Slideshow_004
      await Multimedia_Gallery_Slideshow_004(dt);
    });
    run('Multimedia_Gallery_Slideshow_005', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [隐藏相册无幻灯片播放入口] TID: Multimedia_Gallery_Slideshow_005
      await Multimedia_Gallery_Slideshow_005(dt);
    });
    run('Multimedia_Gallery_Slideshow_006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [用户自建相册播放幻灯片] TID: Multimedia_Gallery_Slideshow_006
      await Multimedia_Gallery_Slideshow_006(dt);
    });
    run('Multimedia_Gallery_Slideshow_007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [人像相册播放幻灯片] TID: Multimedia_Gallery_Slideshow_007
      await Multimedia_Gallery_Slideshow_007(dt);
    });
    run('Multimedia_Gallery_Slideshow_008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [地点相册播放幻灯片] TID: Multimedia_Gallery_Slideshow_008
      await Multimedia_Gallery_Slideshow_008(dt);
    });
    run('Multimedia_Gallery_Slideshow_009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [分类相册播放幻灯片] TID: Multimedia_Gallery_Slideshow_009
      await Multimedia_Gallery_Slideshow_009(dt);
    });
    run('Multimedia_Gallery_Slideshow_010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [搜索结果播放幻灯片] TID: Multimedia_Gallery_Slideshow_010
      await Multimedia_Gallery_Slideshow_010(dt);
    });
    run('Multimedia_Gallery_Slideshow_011', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [相机浏览图片播放幻灯片] TID: Multimedia_Gallery_Slideshow_011
      await Multimedia_Gallery_Slideshow_011(dt);
    });
    run('Multimedia_Gallery_Slideshow_012', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [相机进入图库播放幻灯片] TID: Multimedia_Gallery_Slideshow_012
      await Multimedia_Gallery_Slideshow_012(dt);
    });
    run('Multimedia_Gallery_Slideshow_013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片途中截图] TID: Multimedia_Gallery_Slideshow_013
      await Multimedia_Gallery_Slideshow_013(dt);
    });
    run('Multimedia_Gallery_Slideshow_014', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [录屏后播放幻灯片] TID: Multimedia_Gallery_Slideshow_014
      await Multimedia_Gallery_Slideshow_014(dt);
    });
    run('Multimedia_Gallery_Slideshow_015', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [播放幻灯片打断] TID: Multimedia_Gallery_Slideshow_015
      await Multimedia_Gallery_Slideshow_015(dt);
    });
    run('Multimedia_Gallery_Slideshow_016', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [修改播放幻灯片时间间隔为3秒] TID: Multimedia_Gallery_Slideshow_016
      await Multimedia_Gallery_Slideshow_016(dt);
    });
    run('Multimedia_Gallery_Slideshow_017', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [修改播放幻灯片时间间隔为5秒] TID: Multimedia_Gallery_Slideshow_017
      await Multimedia_Gallery_Slideshow_017(dt);
    });
    run('Multimedia_Gallery_Slideshow_018', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [修改播放幻灯片时间间隔为10秒] TID: Multimedia_Gallery_Slideshow_018
      await Multimedia_Gallery_Slideshow_018(dt);
    });
    run('Multimedia_Gallery_Slideshow_019', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [修改播放幻灯片时间间隔为15秒] TID: Multimedia_Gallery_Slideshow_019
      await Multimedia_Gallery_Slideshow_019(dt);
    });
    run('Multimedia_Gallery_Slideshow_020', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [修改播放幻灯片时间间隔不影响人像相册自己带幻灯片播放时间间隔] TID: Multimedia_Gallery_Slideshow_020
      await Multimedia_Gallery_Slideshow_020(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachDemoUi').init();
      dt.log.i('afterEach DemoUi start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach DemoUi finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllDemoUi').init();
      dt.log.i('afterAll DemoUi start');
      await Exit.browser();
      dt.log.i('afterAll DemoUi finish');
    });
  });
}

// DT步骤
/**
 * 大图-进入大图: [照片页图片幻灯片播放]
 * TAG: 804 TID: Multimedia_Gallery_Slideshow_001
 * 前置条件
 * 1、准备一台xxx手机
 2、手机内预制图片/视频/动态照片/连拍照片等
 */
async function Multimedia_Gallery_Slideshow_001(dt: Dt) {
  dt.log.i('照片页图片幻灯片播放 start');

  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.clickIfExistByText('图片', DELAY.default);

  await dt.sleep();
  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.clickIfExistByText('播放幻灯片', DELAY.default);

  await dt.sleep();
  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  await dt.assertComponentClickable('播放幻灯片', true);
  dt.log.i('照片页图片幻灯片播放 end');
}

/**
 * 大图-视频: [照片页视频无幻灯片播放入口]
 * TAG: 800 TID: Multimedia_Gallery_Slideshow_002
 * 前置条件
 * 1、准备一台xxx手机
 2、手机内预制图片/视频/动态照片/连拍照片等
 */
async function Multimedia_Gallery_Slideshow_002(dt: Dt) {
  dt.log.i('照片页视频无幻灯片播放入口 start');

  dt.log.i('STEP 1、在照片页中点击一个视频进入大图预览');
  await dt.clickIfExistByText('视频', DELAY.default);

  await dt.sleep();
  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.clickIfExistByText('播放幻灯片', DELAY.default);

  await dt.sleep();
  dt.log.i('预期结果2、点击右上角四方菜单无幻灯片播放');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  await dt.negateComponent('播放幻灯片', true);
  dt.log.i('照片页视频无幻灯片播放入口 end');
}

/**
 * 大图-进入大图: [幻灯片播放系统相册内的照片]
 * TAG: 809 TID: Multimedia_Gallery_Slideshow_003
 * 前置条件
 * 1、准备一台xxx手机
 2、手机内预制图片/视频/动态照片/连拍照片等
 3、手机内有图片，我的收藏，相机，截图，等系统相册（相册内有图片）
 */
async function Multimedia_Gallery_Slideshow_003(dt: Dt) {
  dt.log.i('幻灯片播放系统相册内的照片 start');

  dt.log.i('STEP 1、点击相册页内的一个系统相册（视频，录制屏幕除外）');
  await dt.clickIfExistByText('系统相册', DELAY.default);

  await dt.sleep();
  dt.log.i('STEP 2、点击一张图片进入大图浏览');
  await dt.clickIfExistByText('图片', DELAY.default);

  await dt.sleep();
  dt.log.i('STEP 3、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.clickIfExistByText('播放幻灯片', DELAY.default);

  dt.log.i('预期结果3、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）（视频，录屏无幻灯片播放入口）');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  await dt.assertComponentClickable('播放幻灯片', true);
  dt.log.i('幻灯片播放系统相册内的照片 end');
}

/**
 * 大图-删除: [最近删除相册无幻灯片播放入口]
 * TAG: 801 TID: Multimedia_Gallery_Slideshow_004
 * 前置条件
 * 1、准备一台xxx手机
 2、手机内预制图片/视频/动态照片/连拍照片等
 3、最近删除相册内有照片
 */
async function Multimedia_Gallery_Slideshow_004(dt: Dt) {
  dt.log.i('最近删除相册无幻灯片播放入口 start');

  dt.log.i('STEP 1、点击进入相册页');
  await dt.clickIfExistByText('相册', DELAY.default);

  dt.log.i('STEP 2、进入最近删除相册');
  await dt.clickIfExistByText('最近删除', DELAY.default);

  dt.log.i('STEP 3、点击一张图片进入大图预览，点击右上角四方菜单');
  await dt.clickIfExistByText('图片', DELAY.default);
  await dt.clickIfExistByText('播放幻灯片', DELAY.default);

  dt.log.i('预期结果3、点击右上角四方菜单无幻灯片播放');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  await dt.negateComponent('播放幻灯片', true);
  dt.log.i('最近删除相册无幻灯片播放入口 end');
}

/**
 * 大图-进入大图: [隐藏相册无幻灯片播放入口]
 * TAG: 802 TID: Multimedia_Gallery_Slideshow_005
 * 前置条件
 * 1、准备一台xxx手机
 2、手机内预制图片/视频/动态照片/连拍照片等
 3、手机内有隐藏相册，且隐私相册内有图片
 */
async function Multimedia_Gallery_Slideshow_005(dt: Dt) {
  dt.log.i('隐藏相册无幻灯片播放入口 start');

  dt.log.i('STEP 1、点击进入相册页');
  await dt.clickIfExistByText('相册', DELAY.default);

  dt.log.i('STEP 2、点击右上方四方菜单，选择隐藏相册（位于多选下方，位于设置上方）');
  await dt.clickIfExistByText('隐藏相册', DELAY.default);

  dt.log.i('STEP 3、点击一张图片进入大图预览，点击右上角四方菜单');
  await dt.clickIfExistByText('图片', DELAY.default);
  await dt.clickIfExistByText('播放幻灯片', DELAY.default);

  dt.log.i('预期结果3、点击右上角四方菜单无幻灯片播放');
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  await dt.negateComponent('播放幻灯片', true);
  dt.log.i('隐藏相册无幻灯片播放入口 end');
}


/**
 * 大图-进入大图: [用户自建相册播放幻灯片]
 * TAG: 806 TID: Multimedia_Gallery_Slideshow_006
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/连拍照片等
 * 3、手机内有用户自建相册，且用户自建相册内有图片/视频
 */
async function Multimedia_Gallery_Slideshow_006(dt: Dt) {
  dt.log.i('用户自建相册播放幻灯片 start');
  dt.log.i('STEP 1、点击进入相册页');

  await dt.sleep();
  await dt.albumList(); // 进入相册页宫格
  dt.log.i('进入相册页宫格');

  dt.log.i('STEP 2、点击进入用户自建相册');

  await dt.sleep();
  await dt.clickUserDefinedAlbum(); // 点击进入用户自建相册
  dt.log.i('点击进入用户自建相册');

  dt.log.i('STEP 3、点击一张图片进入大图预览，点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');

  await dt.sleep();
  await dt.enterImageDetail(); // 点击一张图片进入大图预览
  dt.log.i('点击一张图片进入大图预览');
  await dt.openMenu(); // 点击右上角四方菜单
  dt.log.i('点击右上角四方菜单');
  await dt.startSlideshow(); // 点击播放幻灯片
  dt.log.i('点击播放幻灯片');

  dt.log.i('预期结果3、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  dt.showComponentsWithin();
  // 使用 dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户自建相册播放幻灯片 end');
}

/**
 * 大图-进入大图: [人像相册播放幻灯片]
 * TAG: 805 TID: Multimedia_Gallery_Slideshow_007
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 * 3、手机经过智慧分析，有分析出人像相册
 */
async function Multimedia_Gallery_Slideshow_007(dt: Dt) {
  dt.log.i('人像相册播放幻灯片 start');
  dt.log.i('STEP 1、点击进入相册页');

  await dt.sleep();
  await dt.albumList(); // 进入相册页宫格
  dt.log.i('进入相册页宫格');

  dt.log.i('STEP 2、点击进入人像相册');

  await dt.sleep();
  await dt.clickPortraitAlbum(); // 点击进入人像相册
  dt.log.i('点击进入人像相册');

  dt.log.i('STEP 3、点击一个人像进入个人人像相册，点击一张图片进入大图预览，点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');

  await dt.sleep();
  await dt.enterPortraitDetail(); // 点击一个人像进入个人人像相册
  dt.log.i('点击一个人像进入个人人像相册');
  await dt.enterImageDetail(); // 点击一张图片进入大图预览
  dt.log.i('点击一张图片进入大图预览');
  await dt.openMenu(); // 点击右上角四方菜单
  dt.log.i('点击右上角四方菜单');
  await dt.startSlideshow(); // 点击播放幻灯片
  dt.log.i('点击播放幻灯片');

  dt.log.i('预期结果3、成功播放幻灯片，播放无卡顿');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  dt.showComponentsWithin();
  // 使用 dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('人像相册播放幻灯片 end');
}

/**
 * 大图-进入大图: [地点相册播放幻灯片]
 * TAG: 811 TID: Multimedia_Gallery_Slideshow_008
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 * 3、手机经过智慧分析，有分析出地点相册
 */
async function Multimedia_Gallery_Slideshow_008(dt: Dt) {
  dt.log.i('地点相册播放幻灯片 start');
  dt.log.i('STEP 1、点击进入相册页');

  await dt.sleep();
  await dt.albumList(); // 进入相册页宫格
  dt.log.i('进入相册页宫格');

  dt.log.i('STEP 2、点击进入地点相册，选择进入地图/城市');

  await dt.sleep();
  await dt.clickLocationAlbum(); // 点击进入地点相册
  dt.log.i('点击进入地点相册');
  await dt.selectCity(); // 选择进入某个城市
  dt.log.i('选择进入某个城市');

  dt.log.i('STEP 3、点击一个城市，选择一张图片进入大图预览，点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');

  await dt.sleep();
  await dt.enterLocationDetail(); // 点击一个城市，选择一张图片进入大图预览
  dt.log.i('点击一个城市，选择一张图片进入大图预览');
  await dt.openMenu(); // 点击右上角四方菜单
  dt.log.i('点击右上角四方菜单');
  await dt.startSlideshow(); // 点击播放幻灯片
  dt.log.i('点击播放幻灯片');

  dt.log.i('预期结果3、成功播放幻灯片，播放无卡顿');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  dt.showComponentsWithin();
  // 使用 dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('地点相册播放幻灯片 end');
}/**
 * 大图-进入大图: [分类相册播放幻灯片]
 * TAG: 803 TID: Multimedia_Gallery_Slideshow_009
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 * 3、手机经过智慧分析，有分析出分类相册
 */
async function Multimedia_Gallery_Slideshow_009(dt: Dt) {
  dt.log.i('分类相册播放幻灯片 start');
  dt.log.i('STEP 1、点击进入相册页');
  await dt.albumList();
  await dt.assertComponent('AlbumListComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击进入分类相册');
  await dt.assertTextClick('分类相册', false, DELAY.default);
  await dt.assertComponent('CategoryAlbumComponent', true);
  await dt.sleep();

  dt.log.i('STEP 3、点击一个类别的相册，选择一张图片进入大图预览，点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertTextClick('类别相册', false, DELAY.default);
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果3、成功播放幻灯片，播放无卡顿');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('分类相册播放幻灯片 end');
}

/**
 * 大图-详情: [搜索结果播放幻灯片]
 * TAG: 799 TID: Multimedia_Gallery_Slideshow_010
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片等
 * 3、手机经过智慧分析，能够进行智慧搜索
 */
async function Multimedia_Gallery_Slideshow_010(dt: Dt) {
  dt.log.i('搜索结果播放幻灯片 start');
  dt.log.i('STEP 1、点击右上角搜索按钮（位于四方菜单的左侧）');
  await dt.albumList();
  await dt.assertComponentClickable('SearchButton', true);
  await dt.assertClick('SearchButton', false, DELAY.default);
  await dt.sleep();

  dt.log.i('STEP 2、输入框中输入“中国”');
  await dt.assertComponent('SearchInput', true);
  await dt.driver.inputText('中国');
  await dt.sleep();

  dt.log.i('预期结果2、搜索出与中国相关的照片和视频');
  await dt.assertComponent('SearchResultsComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、点击查看全部，点击一张照片');
  await dt.assertTextClick('查看全部', false, DELAY.default);
  await dt.browser();
  await dt.sleep();

  dt.log.i('STEP 4、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('搜索结果播放幻灯片 end');
}

/**
 * 大图-详情: [相机浏览图片播放幻灯片]
 * TAG: 808 TID: Multimedia_Gallery_Slideshow_011
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片等
 * 3、手机有最近拍摄照片/视频
 */
async function Multimedia_Gallery_Slideshow_011(dt: Dt) {
  dt.log.i('相机浏览图片播放幻灯片 start');
  dt.log.i('STEP 1、点击进入相册');
  await dt.timeline();
  await dt.assertComponent('TimelineComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击左下角最近拍摄的照片/视频');
  await dt.assertComponentClickable('RecentMediaItem', true);
  await dt.assertClick('RecentMediaItem', false, DELAY.default);
  await dt.sleep();

  dt.log.i('STEP 3、滑到一张照片，轻触屏幕退出沉浸模式');
  await dt.browser();
  await dt.driver.swipe(500, 1000, 500, 500, 300);
  await dt.driver.tap(500, 500);
  await dt.sleep();

  dt.log.i('STEP 4、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('相机浏览图片播放幻灯片 end');
}

/**
 * 大图-进入大图: [相机进入图库播放幻灯片]
 * TAG: 810 TID: Multimedia_Gallery_Slideshow_012
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片等
 * 3、手机有最近拍摄照片/视频
 */
async function Multimedia_Gallery_Slideshow_012(dt: Dt) {
  dt.log.i('相机进入图库播放幻灯片 start');
  dt.log.i('STEP 1、点击进入相册');
  await dt.timeline();
  await dt.assertComponent('TimelineComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击左下角最近拍摄的照片/视频');
  await dt.assertComponentClickable('RecentMediaItem', true);
  await dt.assertClick('RecentMediaItem', false, DELAY.default);
  await dt.sleep();

  dt.log.i('STEP 3、轻触屏幕退出沉浸模式，点击右上角图片按钮进入图库');
  await dt.browser();
  await dt.driver.tap(500, 500);
  await dt.assertComponentClickable('GalleryButton', true);
  await dt.assertClick('GalleryButton', false, DELAY.default);
  await dt.sleep();

  dt.log.i('STEP 4、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('预期结果4、成功进入图库');
  await dt.assertComponent('GalleryComponent', true);
  await dt.sleep();

  dt.log.i('STEP 5、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果5、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('相机进入图库播放幻灯片 end');
}

/**
 * 大图-进入大图: [播放幻灯片途中截图]
 * TAG: 814 TID: Multimedia_Gallery_Slideshow_013
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/连拍照片等
 */
async function Multimedia_Gallery_Slideshow_013(dt: Dt) {
  dt.log.i('播放幻灯片途中截图 start');
  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、在幻灯片播放的途中进行截图（音量上键/下键+锁屏键）');
  await dt.driver.triggerKey([KeyCode.KEYCODE_VOLUME_DOWN, KeyCode.KEYCODE_POWER]);
  await dt.sleep();

  dt.log.i('预期结果3、截图成功，左下角显示截图');
  await dt.assertComponent('ScreenshotThumbnail', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片途中截图 end');
}

/**
 * 大图-进入大图: [录屏后播放幻灯片]
 * TAG: 807 TID: Multimedia_Gallery_Slideshow_014
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/连拍照片等
 */
async function Multimedia_Gallery_Slideshow_014(dt: Dt) {
  dt.log.i('录屏后播放幻灯片 start');
  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、从右上角顶部下拉菜单，点击录制屏幕');
  await dt.videoRecordStart();
  await dt.assertComponent('RecordingIndicator', true);
  await dt.sleep();

  dt.log.i('STEP 3、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果3、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面），录制途中左上角红光闪烁');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.assertComponent('RecordingIndicator', true);
  await dt.sleep();

  dt.log.i('STEP 4、轻触退出幻灯片播放，点击结束录制');
  await dt.driver.tap(500, 500);
  await dt.videoRecordEnd();
  await dt.sleep();

  dt.log.i('预期结果4、退出幻灯片播放，录制视频显示在左下角');
  await dt.assertComponent('VideoThumbnail', true);
  await dt.sleep();

  dt.log.i('STEP 5、点击左下角录制视频进行播放');
  await dt.assertComponentClickable('VideoThumbnail', true);
  await dt.assertClick('VideoThumbnail', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果5、录屏正常，无卡顿');
  await dt.assertComponent('VideoPlaybackComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('VideoPlaybackComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('录屏后播放幻灯片 end');
}

/**
 * 大图-进入大图: [播放幻灯片打断]
 * TAG: 813 TID: Multimedia_Gallery_Slideshow_015
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/连拍照片等
 */
async function Multimedia_Gallery_Slideshow_015(dt: Dt) {
  dt.log.i('播放幻灯片打断 start');
  dt.log.i('STEP 1、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 2、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果2、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3、在幻灯片播放的途中轻触/上、下滑/侧滑/锁屏');
  await dt.driver.tap(500, 500);
  await dt.sleep();

  dt.log.i('预期结果3、幻灯片播放退出，返回到播放的当前照片');
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('ImagePreviewComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('播放幻灯片打断 end');
}

/**
 * 大图-进入大图: [修改播放幻灯片时间间隔为3秒]
 * TAG: 812 TID: Multimedia_Gallery_Slideshow_016
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/连拍照片等
 */
async function Multimedia_Gallery_Slideshow_016(dt: Dt) {
  dt.log.i('修改播放幻灯片时间间隔为3秒 start');
  dt.log.i('STEP 1、进入图库，点击右上角四方菜单，选择设置');
  await dt.albumList();
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('设置', false, DELAY.default);
  await dt.sleep();

  dt.log.i('STEP 2、选择修改时间间隔为3秒(位于本地空间释放下方，图库网络连接上方)');
  await dt.assertComponent('SettingsComponent', true);
  await dt.assertTextClick('幻灯片时间间隔', false, DELAY.default);
  await dt.assertTextClick('3秒', false, DELAY.default);
  await dt.sleep();

  dt.log.i('STEP 3、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）播放幻灯片观察每张照片之间的播放长为3秒');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(3000);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('修改播放幻灯片时间间隔为3秒 end');
}

/**
 * 大图-进入大图: [修改播放幻灯片时间间隔为5秒]
 * TAG: 825 TID: Multimedia_Gallery_Slideshow_017
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/连拍照片等
 */
async function Multimedia_Gallery_Slideshow_017(dt: Dt) {
  dt.log.i('修改播放幻灯片时间间隔为5秒 start');
  dt.log.i('STEP 1、进入图库，点击右上角四方菜单，选择设置');
  await dt.albumList();
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('设置', false, DELAY.default);
  await dt.sleep();

  dt.log.i('STEP 2、选择修改时间间隔为5秒(位于本地空间释放下方，图库网络连接上方)');
  await dt.assertComponent('SettingsComponent', true);
  await dt.assertTextClick('幻灯片时间间隔', false, DELAY.default);
  await dt.assertTextClick('5秒', false, DELAY.default);
  await dt.sleep();

  dt.log.i('STEP 3、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）播放幻灯片观察每张照片之间的播放长为5秒');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(5000);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('修改播放幻灯片时间间隔为5秒 end');
}

/**
 * 大图-进入大图: [修改播放幻灯片时间间隔为10秒]
 * TAG: 826 TID: Multimedia_Gallery_Slideshow_018
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/连拍照片等
 */
async function Multimedia_Gallery_Slideshow_018(dt: Dt) {
  dt.log.i('修改播放幻灯片时间间隔为10秒 start');
  dt.log.i('STEP 1、进入图库，点击右上角四方菜单，选择设置');
  await dt.albumList();
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('设置', false, DELAY.default);
  await dt.sleep();

  dt.log.i('STEP 2、选择修改时间间隔为10秒(位于本地空间释放下方，图库网络连接上方)');
  await dt.assertComponent('SettingsComponent', true);
  await dt.assertTextClick('幻灯片时间间隔', false, DELAY.default);
  await dt.assertTextClick('10秒', false, DELAY.default);
  await dt.sleep();

  dt.log.i('STEP 3、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）播放幻灯片观察每张照片之间的播放长为10秒');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(10000);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('修改播放幻灯片时间间隔为10秒 end');
}

/**
 * 大图-进入大图: [修改播放幻灯片时间间隔为15秒]
 * TAG: 829 TID: Multimedia_Gallery_Slideshow_019
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/连拍照片等
 */
async function Multimedia_Gallery_Slideshow_019(dt: Dt) {
  dt.log.i('修改播放幻灯片时间间隔为15秒 start');
  dt.log.i('STEP 1、进入图库，点击右上角四方菜单，选择设置');
  await dt.albumList();
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('设置', false, DELAY.default);
  await dt.sleep();

  dt.log.i('STEP 2、选择修改时间间隔为15秒(位于本地空间释放下方，图库网络连接上方)');
  await dt.assertComponent('SettingsComponent', true);
  await dt.assertTextClick('幻灯片时间间隔', false, DELAY.default);
  await dt.assertTextClick('15秒', false, DELAY.default);
  await dt.sleep();

  dt.log.i('STEP 3、在照片页中点击一张图片进入大图预览');
  await dt.browser();
  await dt.assertComponent('ImagePreviewComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、点击右上角四方菜单，点击播放幻灯片（位于重命名下方，详情信息上方）');
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('播放幻灯片', false, DELAY.default);
  await dt.sleep();

  dt.log.i('预期结果4、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）播放幻灯片观察每张照片之间的播放长为15秒');
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep(15000);
  await dt.assertComponent('SlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('SlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('修改播放幻灯片时间间隔为15秒 end');
}

/**
 * 大图-动态照片: [修改播放幻灯片时间间隔不影响人像相册自己带幻灯片播放时间间隔]
 * TAG: 830 TID: Multimedia_Gallery_Slideshow_020
 * 前置条件
 * 1、准备一台xxx手机
 * 2、手机内预制图片/视频/动态照片/人像照片等
 * 3、手机经过智慧分析，有分析出人像相册
 */
async function Multimedia_Gallery_Slideshow_020(dt: Dt) {
  dt.log.i('修改播放幻灯片时间间隔不影响人像相册自己带幻灯片播放时间间隔 start');
  dt.log.i('STEP 1、进入图库，点击右上角四方菜单，选择设置');
  await dt.albumList();
  await dt.assertComponentClickable('MenuButton', true);
  await dt.assertClick('MenuButton', false, DELAY.default);
  await dt.assertTextClick('设置', false, DELAY.default);
  await dt.sleep();

  dt.log.i('STEP 2、选择修改时间间隔为3/5/10/15秒(位于本地空间释放下方，图库网络连接上方)');
  await dt.assertComponent('SettingsComponent', true);
  await dt.assertTextClick('幻灯片时间间隔', false, DELAY.default);
  await dt.assertTextClick('15秒', false, DELAY.default);
  await dt.sleep();

  dt.log.i('STEP 3、点击进入人像相册');
  await dt.assertTextClick('人像相册', false, DELAY.default);
  await dt.assertComponent('PortraitAlbumComponent', true);
  await dt.sleep();

  dt.log.i('STEP 4、点击一个人像进入个人人像相册，观察上方人像照片播放幻灯片');
  await dt.assertComponentClickable('PortraitItem', true);
  await dt.assertClick('PortraitItem', false, DELAY.default);
  await dt.assertComponent('PortraitSlideshowComponent', true);
  await dt.sleep(3000);
  await dt.assertComponent('PortraitSlideshowComponent', true);
  await dt.sleep();

  dt.log.i('预期结果4、成功播放幻灯片，播放无卡顿（播放到视频时显示为视频封面）播放幻灯片观察每张照片之间的播放长为3秒');
  await dt.assertComponent('PortraitSlideshowComponent', true);
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin('PageTitle.index');
  await dt.assertComponentClickable('PortraitSlideshowComponent', true);
  await dt.assertComponent('PageTitle.index', true);
  dt.log.i('修改播放幻灯片时间间隔不影响人像相册自己带幻灯片播放时间间隔 end');
}