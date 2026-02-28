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
    run('IMediaAPP_Gallery_Extendedprojection_0010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [无线投屏时picker页拉起图库的图片浏览] TID: IMediaAPP_Gallery_Extendedprojection_0010
      await IMediaAPP_Gallery_Extendedprojection_0010(dt);
    });
    run('IMediaAPP_Gallery_Extendedprojection_0011', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [无线投屏时picker页拉起图库的视频播放] TID: IMediaAPP_Gallery_Extendedprojection_0011
      await IMediaAPP_Gallery_Extendedprojection_0011(dt);
    });
    run('IMediaAPP_Gallery_Extendedprojection_0012', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [无线投屏时退出图库后台从任务管理重新进入图库] TID: IMediaAPP_Gallery_Extendedprojection_0012
      await IMediaAPP_Gallery_Extendedprojection_0012(dt);
    });
    run('IMediaAPP_Gallery_Extendedprojection_0013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-锁屏用例: [无线投屏锁屏之后再解锁查看大屏大图和视频的显示] TID: IMediaAPP_Gallery_Extendedprojection_0013
      await IMediaAPP_Gallery_Extendedprojection_0013(dt);
    });
    run('IMediaAPP_Gallery_Extendedprojection_0014', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [无线投屏连续浏览图片查看普通图片和动态图片的显示] TID: IMediaAPP_Gallery_Extendedprojection_0014
      await IMediaAPP_Gallery_Extendedprojection_0014(dt);
    });
    run('IMediaAPP_Gallery_Extendedprojection_0015', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [无线投屏连续删除图片查看普通图片和动态图片的显示] TID: IMediaAPP_Gallery_Extendedprojection_0015
      await IMediaAPP_Gallery_Extendedprojection_0015(dt);
    });
    run('IMediaAPP_Gallery_Extendedprojection_0016', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [无线投屏过程中大图侧滑返回] TID: IMediaAPP_Gallery_Extendedprojection_0016
      await IMediaAPP_Gallery_Extendedprojection_0016(dt);
    });
    run('IMediaAPP_Gallery_Extendedprojection_0017', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-heif用例: [heif格式的普通图片和动态图片在大屏的显示] TID: IMediaAPP_Gallery_Extendedprojection_0017
      await IMediaAPP_Gallery_Extendedprojection_0017(dt);
    });
    run('IMediaAPP_Gallery_Extendedprojection_0018', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-应用锁用例: [图库加应用锁之后进行无线投屏查看图片和视频的显示] TID: IMediaAPP_Gallery_Extendedprojection_0018
      await IMediaAPP_Gallery_Extendedprojection_0018(dt);
    });
    run('IMediaAPP_Gallery_Extendedprojection_0019', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [无线投屏中相机左下角进入大图] TID: IMediaAPP_Gallery_Extendedprojection_0019
      await IMediaAPP_Gallery_Extendedprojection_0019(dt);
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
 * 大图-进入大图: [无线投屏时picker页拉起图库的图片浏览]
 * TAG: 325 TID: IMediaAPP_Gallery_Extendedprojection_0010
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_0010(dt: Dt) {
  dt.log.i('无线投屏时picker页拉起图库的图片浏览 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、picker拉起图库');

  await dt.sleep();
  dt.log.i('STEP 3、点击缩略图进入大图');

  await dt.sleep();
  dt.log.i('预期结果3，图片显示正常，无白块');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无线投屏时picker页拉起图库的图片浏览 end');
}

/**
 * 大图-视频: [无线投屏时picker页拉起图库的视频播放]
 * TAG: 331 TID: IMediaAPP_Gallery_Extendedprojection_0011
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源

 */
async function IMediaAPP_Gallery_Extendedprojection_0011(dt: Dt) {
  dt.log.i('无线投屏时picker页拉起图库的视频播放 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、picker拉起图库');

  await dt.sleep();
  dt.log.i('STEP 3、点击缩略图进入视频播放页面');

  await dt.sleep();
  dt.log.i('STEP 4，点击播放按钮');

  await dt.sleep();
  dt.log.i('预期结果4，视频正常播放，无卡顿');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无线投屏时picker页拉起图库的视频播放 end');
}

/**
 * 大图-进入大图: [无线投屏时退出图库后台从任务管理重新进入图库]
 * TAG: 328 TID: IMediaAPP_Gallery_Extendedprojection_0012
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源

 */
async function IMediaAPP_Gallery_Extendedprojection_0012(dt: Dt) {
  dt.log.i('无线投屏时退出图库后台从任务管理重新进入图库 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击缩略图进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、上滑返回桌面，图库进入后台');

  await dt.sleep();
  dt.log.i('STEP 4，从后台任务管理再次进入图库');

  await dt.sleep();
  dt.log.i('预期结果4，图片和视频正常显示和播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无线投屏时退出图库后台从任务管理重新进入图库 end');
}

/**
 * 大图-锁屏: [无线投屏锁屏之后再解锁查看大屏大图和视频的显示]
 * TAG: 324 TID: IMediaAPP_Gallery_Extendedprojection_0013
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源

 */
async function IMediaAPP_Gallery_Extendedprojection_0013(dt: Dt) {
  dt.log.i('无线投屏锁屏之后再解锁查看大屏大图和视频的显示 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，点击缩略图进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、手机锁屏后重新解锁');

  await dt.sleep();
  dt.log.i('预期结果3，图片和视频正常显示和播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无线投屏锁屏之后再解锁查看大屏大图和视频的显示 end');
}

/**
 * 大图-动态照片: [无线投屏连续浏览图片查看普通图片和动态图片的显示]
 * TAG: 332 TID: IMediaAPP_Gallery_Extendedprojection_0014
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_0014(dt: Dt) {
  dt.log.i('无线投屏连续浏览图片查看普通图片和动态图片的显示 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，进入照片页');

  await dt.sleep();
  dt.log.i('STEP 3、左右滑动查看大图（需要涉及慢滑、快滑、抛滑等场景）');

  await dt.sleep();
  dt.log.i('预期结果3，滑动流畅，无卡顿，无正在加载，照片浏览正常，动态照片播放正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无线投屏连续浏览图片查看普通图片和动态图片的显示 end');
}

/**
 * 大图-删除: [无线投屏连续删除图片查看普通图片和动态图片的显示]
 * TAG: 330 TID: IMediaAPP_Gallery_Extendedprojection_0015
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_0015(dt: Dt) {
  dt.log.i('无线投屏连续删除图片查看普通图片和动态图片的显示 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，进入照片页');

  await dt.sleep();
  dt.log.i('STEP 3、连续删除图片后查看大图');

  await dt.sleep();
  dt.log.i('预期结果3，同步显示下一张图片大图，图片浏览正常，动态照片播放正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无线投屏连续删除图片查看普通图片和动态图片的显示 end');
}

/**
 * 大图-大图: [无线投屏过程中大图侧滑返回]
 * TAG: 327 TID: IMediaAPP_Gallery_Extendedprojection_0016
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 */
async function IMediaAPP_Gallery_Extendedprojection_0016(dt: Dt) {
  dt.log.i('无线投屏过程中大图侧滑返回 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，进入照片页');

  await dt.sleep();
  dt.log.i('STEP 3、点击一张照片或视频进入大图，然后侧滑返回');

  await dt.sleep();
  dt.log.i('预期结果3、侧滑返回丝滑，无卡顿');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无线投屏过程中大图侧滑返回 end');
}

/**
 * 大图-heif: [heif格式的普通图片和动态图片在大屏的显示]
 * TAG: 326 TID: IMediaAPP_Gallery_Extendedprojection_0017
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中存在heif格式的图片

 */
async function IMediaAPP_Gallery_Extendedprojection_0017(dt: Dt) {
  dt.log.i('heif格式的普通图片和动态图片在大屏的显示 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标进入图库，进入照片页');

  await dt.sleep();
  dt.log.i('STEP 3、点击heif格式的图片');

  await dt.sleep();
  dt.log.i('预期结果3，heic格式的图片显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('heif格式的普通图片和动态图片在大屏的显示 end');
}

/**
 * 大图-应用锁: [图库加应用锁之后进行无线投屏查看图片和视频的显示]
 * TAG: 333 TID: IMediaAPP_Gallery_Extendedprojection_0018
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源
 3、给图库加应用锁

 */
async function IMediaAPP_Gallery_Extendedprojection_0018(dt: Dt) {
  dt.log.i('图库加应用锁之后进行无线投屏查看图片和视频的显示 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、手机界面点击桌面图库图标输入密码解锁后进入图库，进入照片页');

  await dt.sleep();
  dt.log.i('预期结果2，3图库界面显示正常4，需要重新输入应用锁密码，图库界面显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3，退出图库重新点桌面图库图标进入图库');

  await dt.sleep();
  dt.log.i('STEP 4，相机左下角进入大图');

  await dt.sleep();
  dt.log.i('预期结果4，需要重新输入应用锁密码，图库界面显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库加应用锁之后进行无线投屏查看图片和视频的显示 end');
}

/**
 * 大图-进入大图: [无线投屏中相机左下角进入大图]
 * TAG: 329 TID: IMediaAPP_Gallery_Extendedprojection_0019
 * 前置条件
 * 1、准备一台手机和一个智慧屏
 2、图库中有不同格式和不同分辨率的图片和视频资源

 */
async function IMediaAPP_Gallery_Extendedprojection_0019(dt: Dt) {
  dt.log.i('无线投屏中相机左下角进入大图 start');
  dt.log.i('STEP 1、手机界面顶部下拉，点击无线投屏功能');

  await dt.sleep();
  dt.log.i('STEP 2、点相机左下角缩略图进入大图页面');

  await dt.sleep();
  dt.log.i('预期结果2，图片和视频正常显示和播放');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无线投屏中相机左下角进入大图 end');
}
