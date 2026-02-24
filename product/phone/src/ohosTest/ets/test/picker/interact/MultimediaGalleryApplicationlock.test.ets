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

export default function MultimediaGalleryApplicationlock(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryApplicationlockTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryApplicationlock').init();
      dt.log.i('beforeAll MultimediaGalleryApplicationlock start');
      dt.log.i('beforeAll MultimediaGalleryApplicationlock finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryApplicationlock', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryApplicationlock07', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [应用锁下-不同入口大图页显示] TID: Multimedia_Gallery_Application_lock_07
      await multimediaGalleryApplicationlock07(dt);
    });
    run('MultimediaGalleryApplicationlock08', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [应用锁下-缩放铺满全屏显示] TID: Multimedia_Gallery_Application_lock_08
      await multimediaGalleryApplicationlock08(dt);
    });
    run('MultimediaGalleryApplicationlock09', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [应用锁下-播放视频] TID: Multimedia_Gallery_Application_lock_09
      await multimediaGalleryApplicationlock09(dt);
    });
    run('MultimediaGalleryApplicationlock10', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [应用锁下-照片移动到] TID: Multimedia_Gallery_Application_lock_10
      await multimediaGalleryApplicationlock10(dt);
    });
    run('MultimediaGalleryApplicationlock11', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [应用锁下-端云同步下行同步中] TID: Multimedia_Gallery_Application_lock_11
      await multimediaGalleryApplicationlock11(dt);
    });
    run('MultimediaGalleryApplicationlock12', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-进入大图用例: [应用锁下-相机进入大图组件] TID: Multimedia_Gallery_Application_lock_12
      await multimediaGalleryApplicationlock12(dt);
    });
    run('MultimediaGalleryApplicationlock13', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-进入大图用例: [应用锁下-锁屏相机进入大图组件] TID: Multimedia_Gallery_Application_lock_13
      await multimediaGalleryApplicationlock13(dt);
    });
    run('MultimediaGalleryApplicationlock14', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [图库应用锁适配悬浮窗] TID: Multimedia_Gallery_Application_lock_14
      await multimediaGalleryApplicationlock14(dt);
    });
    run('MultimediaGalleryApplicationlock15', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [图库应用锁适配分屏] TID: Multimedia_Gallery_Application_lock_15
      await multimediaGalleryApplicationlock15(dt);
    });
    run('MultimediaGalleryApplicationlock16', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [图库应用锁适配多任务] TID: Multimedia_Gallery_Application_lock_16
      await multimediaGalleryApplicationlock16(dt);
    });
    run('MultimediaGalleryApplicationlock17', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [应用锁下-云端资源下载] TID: Multimedia_Gallery_Application_lock_17
      await multimediaGalleryApplicationlock17(dt);
    });
    run('MultimediaGalleryApplicationlock18', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [应用锁下-解锁后超2s打开图库] TID: Multimedia_Gallery_Application_lock_18
      await multimediaGalleryApplicationlock18(dt);
    });
    run('MultimediaGalleryArrows001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [PC打开大图] TID: Multimedia_Gallery_Arrows_001
      await multimediaGalleryArrows001(dt);
    });
    run('MultimediaGalleryArrows002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [PC端左右箭头显示测试] TID: Multimedia_Gallery_Arrows_002
      await multimediaGalleryArrows002(dt);
    });
    run('MultimediaGalleryArrows003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [PC端点击左右箭头测试] TID: Multimedia_Gallery_Arrows_003
      await multimediaGalleryArrows003(dt);
    });
    run('MultimediaGalleryArrows004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [PC端左右箭头消失测试] TID: Multimedia_Gallery_Arrows_004
      await multimediaGalleryArrows004(dt);
    });
    run('MultimediaGalleryArrows005', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-解析用例: [PC端左右箭头可靠性性能测试] TID: Multimedia_Gallery_Arrows_005
      await multimediaGalleryArrows005(dt);
    });
    run('MultimediaGalleryCategorize001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [入口封面-图片视频封面验证（仅1类、仅2类、仅3类、仅4类、超4类、云图）] TID: Multimedia_Gallery_Categorize_001
      await multimediaGalleryCategorize001(dt);
    });
    run('MultimediaGalleryCategorize002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [大图移除验证（共识别、重编辑、重云同步）] TID: Multimedia_Gallery_Categorize_002
      await multimediaGalleryCategorize002(dt);
    });
    run('MultimediaGalleryCategorize003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [入口封面-降序封面自适应验证（仅1类、仅2类、仅3类、仅4类、超4类）（新增图片、删除图片、云同步）] TID: Multimedia_Gallery_Categorize_003
      await multimediaGalleryCategorize003(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryApplicationlock').init();
      dt.log.i('afterEach MultimediaGalleryApplicationlock start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryApplicationlock finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryApplicationlock').init();
      dt.log.i('afterAll MultimediaGalleryApplicationlock start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryApplicationlock finish');
    });
  });
}

// DT步骤
/**
 * 宫格-应用锁: [应用锁下-不同入口大图页显示]
 * GROUP: 宫格 MODULE: 应用锁TID: Multimedia_Gallery_Application_lock_07
 * 前置条件
 * 1、手机设置密码
 2、图库已添加应用锁
 3、图库存在历史照片和视频
 */
async function multimediaGalleryApplicationlock07(dt: Dt) {
  dt.log.i('应用锁下-不同入口大图页显示 start');
  dt.log.i('STEP 1、从不同的入口（时间轴入口、相册宫格入口、FA卡片（某些机型没有FA卡片），相机左下角缩略图入口）进入大图浏览界面');

  await dt.sleep();
  dt.log.i('STEP 2、设备锁屏后输入密码解锁');

  await dt.sleep();
  dt.log.i('预期结果2.1解锁后2s内在图库应用无需输入应用锁密码，直接进入大图页;相机左下角缩略进入，解锁后直接进入相机页面，点击左下角缩略图，需输入应用锁密码');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁下-不同入口大图页显示 end');
}

/**
 * 宫格-应用锁: [应用锁下-缩放铺满全屏显示]
 * GROUP: 宫格 MODULE: 应用锁TID: Multimedia_Gallery_Application_lock_08
 * 前置条件
 * 1、手机设置密码
 2、图库已添加应用锁
 3、图库存在历史照片和视频
 */
async function multimediaGalleryApplicationlock08(dt: Dt) {
  dt.log.i('应用锁下-缩放铺满全屏显示 start');
  dt.log.i('STEP 1、打开图库点击缩略图进入大图页面');

  await dt.sleep();
  dt.log.i('STEP 2、双击/双指捏合放大缩小');

  await dt.sleep();
  dt.log.i('预期结果2、可以正常放大缩小');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、设备锁屏后输入密码解锁');

  await dt.sleep();
  dt.log.i('预期结果3、解锁后2s内无需输入应用锁密码，大图仍显示锁屏前的状态');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁下-缩放铺满全屏显示 end');
}

/**
 * 宫格-应用锁: [应用锁下-播放视频]
 * GROUP: 宫格 MODULE: 应用锁TID: Multimedia_Gallery_Application_lock_09
 * 前置条件
 * 1、手机设置密码
 2、图库已添加应用锁
 3、图库存在历史照片和视频
 */
async function multimediaGalleryApplicationlock09(dt: Dt) {
  dt.log.i('应用锁下-播放视频 start');
  dt.log.i('STEP 1、打开图库播放视频');

  await dt.sleep();
  dt.log.i('预期结果1、解锁后2s内无需输入应用锁密码，视频正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、设备锁屏后输入密码解锁');

  await dt.sleep();
  dt.log.i('预期结果2、视频接着锁屏前继续播放');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁下-播放视频 end');
}

/**
 * 宫格-应用锁: [应用锁下-照片移动到]
 * GROUP: 宫格 MODULE: 应用锁TID: Multimedia_Gallery_Application_lock_10
 * 前置条件
 * 1、手机设置密码
 2、图库已添加应用锁
 3、图库存在10000张照片和视频
 */
async function multimediaGalleryApplicationlock10(dt: Dt) {
  dt.log.i('应用锁下-照片移动到 start');
  dt.log.i('STEP 1、照片页多选/全选照片');

  await dt.sleep();
  dt.log.i('STEP 2、点击左下角更多按钮移动到');

  await dt.sleep();
  dt.log.i('STEP 3、移动过程中设备锁屏后输入密码解锁');

  await dt.sleep();
  dt.log.i('预期结果3、解锁后2s内无需输入应用锁密码；出现移动的进度条，进度条根据移动进度实时显示，显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁下-照片移动到 end');
}

/**
 * 宫格-应用锁: [应用锁下-端云同步下行同步中]
 * GROUP: 宫格 MODULE: 应用锁TID: Multimedia_Gallery_Application_lock_11
 * 前置条件
 * 1、手机设置密码
 2、图库已添加应用锁
 3、图库存在历史照片和视频
 4、手机设置密码测试机登陆云账号，测试机开启图库云同步（测试机为xxx手机）
 5、手机已连接WLAN
 6、云空间内有未下载到本地的照片和视频

 */
async function multimediaGalleryApplicationlock11(dt: Dt) {
  dt.log.i('应用锁下-端云同步下行同步中 start');
  dt.log.i('STEP 1、打开图库进入照片页');

  await dt.sleep();
  dt.log.i('STEP 2、云端同步过程中显示xxx张照片和xxx个视频，当前已同步xx照片和xx个视频');

  await dt.sleep();
  dt.log.i('STEP 3、同步过程中设备锁屏后输入密码解锁');

  await dt.sleep();
  dt.log.i('预期结果3、解锁后2s内无需输入应用锁密码；缩略图正常显示加载，云同步数据实时显示，显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁下-端云同步下行同步中 end');
}

/**
 * 宫格-进入大图: [应用锁下-相机进入大图组件]
 * GROUP: 宫格 MODULE: 进入大图TID: Multimedia_Gallery_Application_lock_12
 * 前置条件
 * 1、手机设置密码
 2、图库已添加应用锁
 3、图库存在历史照片和视频
 */
async function multimediaGalleryApplicationlock12(dt: Dt) {
  dt.log.i('应用锁下-相机进入大图组件 start');
  dt.log.i('STEP 1、手机解锁后2s内不打开图库');

  await dt.sleep();
  dt.log.i('STEP 2、从相机入口进入大图组件');

  await dt.sleep();
  dt.log.i('预期结果2、需要输入应用锁密码');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、输入应用锁密码');

  await dt.sleep();
  dt.log.i('预期结果3、大图组件显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁下-相机进入大图组件 end');
}

/**
 * 宫格-进入大图: [应用锁下-锁屏相机进入大图组件]
 * GROUP: 宫格 MODULE: 进入大图TID: Multimedia_Gallery_Application_lock_13
 * 前置条件
 * 1、手机设置密码
 2、图库已添加应用锁
 3、图库存在历史照片和视频
 */
async function multimediaGalleryApplicationlock13(dt: Dt) {
  dt.log.i('应用锁下-锁屏相机进入大图组件 start');
  dt.log.i('STEP 1、锁屏相机拍摄图片后进入大图组件');

  await dt.sleep();
  dt.log.i('STEP 2、点击分享/编辑等操作');

  await dt.sleep();
  dt.log.i('STEP 3、输入锁屏密码');

  await dt.sleep();
  dt.log.i('预期结果3、需要输入应用锁密码；大图组件显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁下-锁屏相机进入大图组件 end');
}

/**
 * 宫格-应用锁: [图库应用锁适配悬浮窗]
 * GROUP: 宫格 MODULE: 应用锁TID: Multimedia_Gallery_Application_lock_14
 * 前置条件
 * 1、手机设置密码
 2、图库已添加应用锁
 3、图库存在历史照片和视频
 */
async function multimediaGalleryApplicationlock14(dt: Dt) {
  dt.log.i('图库应用锁适配悬浮窗 start');
  dt.log.i('STEP 1、手机解锁后2s内不打开图库');

  await dt.sleep();
  dt.log.i('STEP 2、悬浮窗下查看图库界面显示');

  await dt.sleep();
  dt.log.i('预期结果2、提示输入应用锁密码，悬浮窗界面隐私保护');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、输入应用锁密码');

  await dt.sleep();
  dt.log.i('预期结果3、图库界面显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库应用锁适配悬浮窗 end');
}

/**
 * 宫格-应用锁: [图库应用锁适配分屏]
 * GROUP: 宫格 MODULE: 应用锁TID: Multimedia_Gallery_Application_lock_15
 * 前置条件
 * 1、手机设置密码
 2、图库已添加应用锁
 3、图库存在历史照片和视频
 */
async function multimediaGalleryApplicationlock15(dt: Dt) {
  dt.log.i('图库应用锁适配分屏 start');
  dt.log.i('STEP 1、手机解锁后2s内不打开图库');

  await dt.sleep();
  dt.log.i('STEP 2、分屏下查看图库界面显示');

  await dt.sleep();
  dt.log.i('预期结果2、提示输入应用锁密码，分屏界面隐私保护');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、输入应用锁密码');

  await dt.sleep();
  dt.log.i('预期结果3、图库界面显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库应用锁适配分屏 end');
}

/**
 * 宫格-应用锁: [图库应用锁适配多任务]
 * GROUP: 宫格 MODULE: 应用锁TID: Multimedia_Gallery_Application_lock_16
 * 前置条件
 * 1、手机设置密码
 2、图库已添加应用锁
 3、图库存在历史照片和视频
 */
async function multimediaGalleryApplicationlock16(dt: Dt) {
  dt.log.i('图库应用锁适配多任务 start');
  dt.log.i('STEP 1、手机解锁后2s内不打开图库');

  await dt.sleep();
  dt.log.i('STEP 2、桌面上划多任务下查看图库界面显示');

  await dt.sleep();
  dt.log.i('预期结果2、图库界面隐私保护');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库应用锁适配多任务 end');
}

/**
 * 宫格-应用锁: [应用锁下-云端资源下载]
 * GROUP: 宫格 MODULE: 应用锁TID: Multimedia_Gallery_Application_lock_17
 * 前置条件
 * 1、手机设置密码
 2、图库已添加应用锁
 3、测试机登陆云账号，并开启图库云同步
 4、云端有未下载到测试机本地的云文件a
 5、手机已连接WLAN
 */
async function multimediaGalleryApplicationlock17(dt: Dt) {
  dt.log.i('应用锁下-云端资源下载 start');
  dt.log.i('STEP 1、测试机进入图库点击缩略图进入大图浏览界面');

  await dt.sleep();
  dt.log.i('STEP 2、点击图片/视频大图');

  await dt.sleep();
  dt.log.i('STEP 3、编辑按钮');

  await dt.sleep();
  dt.log.i('预期结果3、进入编辑页，下载过程显示loading进度条');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、设备锁屏后解锁');

  await dt.sleep();
  dt.log.i('预期结果4、解锁后2s内无需输入应用锁密码，图片/视频继续下载，下载过程显示loading进度条，下载完成后loading进度条消失');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁下-云端资源下载 end');
}

/**
 * 宫格-应用锁: [应用锁下-解锁后超2s打开图库]
 * GROUP: 宫格 MODULE: 应用锁TID: Multimedia_Gallery_Application_lock_18
 * 前置条件
 * 1、手机设置密码
 2、图库已添加应用锁
 3、图库存在历史照片和视频
 */
async function multimediaGalleryApplicationlock18(dt: Dt) {
  dt.log.i('应用锁下-解锁后超2s打开图库 start');
  dt.log.i('STEP 1、设备在非图库页面锁屏');

  await dt.sleep();
  dt.log.i('STEP 2、设备锁屏后输入密码解锁');

  await dt.sleep();
  dt.log.i('STEP 3、解锁2s后打开图库');

  await dt.sleep();
  dt.log.i('预期结果3、需要输入应用锁密码、图库界面显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁下-解锁后超2s打开图库 end');
}

/**
 * 宫格-大图: [PC打开大图]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Arrows_001
 * 前置条件
 * 1、图库中存在不同格式、不同版式的照片和视频文件
 */
async function multimediaGalleryArrows001(dt: Dt) {
  dt.log.i('PC打开大图 start');
  dt.log.i('STEP 1、PC图库宫格，鼠标点击不同版式图片，鼠标单击打开大图');

  await dt.sleep();
  dt.log.i('预期结果1、进入一般模式查看大图，非全屏图片空余部分为白色');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、PC图库宫格，长按不同版式图片点击左上角icon，打开大图');

  await dt.sleep();
  dt.log.i('预期结果2、进入沉浸模式查看大图，非全屏图片空余部分为黑色');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、图库FA卡片，鼠标点击不同版式图片，打开大图');

  await dt.sleep();
  dt.log.i('预期结果3、进入一般模式查看大图，非全屏图片空余部分为白色');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、图库FA卡片，长按不同版式图片点击左上角icon，打开大图');

  await dt.sleep();
  dt.log.i('预期结果4、进入沉浸模式查看大图，非全屏图片空余部分为黑色');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、相机进入相册，鼠标点击不同版式图片，打开大图');

  await dt.sleep();
  dt.log.i('预期结果5、进入一般模式查看大图，非全屏图片空余部分为白色');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、相机进入相册，长按不同版式图片点击左上角icon，打开大图');

  await dt.sleep();
  dt.log.i('预期结果6、进入沉浸模式查看大图，非全屏图片空余部分为黑色');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 7、Picker图库，鼠标点击不同版式图片，打开大图');

  await dt.sleep();
  dt.log.i('预期结果7、进入一般模式查看大图，非全屏图片空余部分为白色');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 8、Picker图库，长按不同版式图片点击左上角icon，打开大图');

  await dt.sleep();
  dt.log.i('预期结果8、进入沉浸模式查看大图，非全屏图片空余部分为黑色');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC打开大图 end');
}

/**
 * 宫格-格式: [PC端左右箭头显示测试]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Arrows_002
 * 前置条件
 * 1、图库中存在不同格式、不同版式的照片和视频文件
 */
async function multimediaGalleryArrows002(dt: Dt) {
  dt.log.i('PC端左右箭头显示测试 start');
  dt.log.i('STEP 1、一般模式打开大图，观察左右箭头显示');

  await dt.sleep();
  dt.log.i('预期结果1、显示左右切换箭头，箭头底板黑色，箭头白色');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、沉浸模式打开大图，观察左右箭头显示');

  await dt.sleep();
  dt.log.i('预期结果2、显示左右切换箭头，箭头底板白色，箭头黑色');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、鼠标移动到左侧边框响应热区范围内');

  await dt.sleep();
  dt.log.i('预期结果3、显示左侧切换箭头');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、鼠标移动到左侧边框非响应热区范围内');

  await dt.sleep();
  dt.log.i('预期结果4、不显示左侧切换箭头');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、鼠标移动到右侧边框响应热区范围内');

  await dt.sleep();
  dt.log.i('预期结果5、显示右侧切换箭头');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、鼠标移动到右侧边框非响应热区范围内');

  await dt.sleep();
  dt.log.i('预期结果6、不显示右侧切换箭头');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 7、鼠标移动到左侧边框响应热区范围内');

  await dt.sleep();
  dt.log.i('预期结果7、显示左侧切换箭头');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 8、鼠标移动到左侧边框非响应热区范围内');

  await dt.sleep();
  dt.log.i('预期结果8、不显示左侧切换箭头');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 9、鼠标移动到右侧边框响应热区范围内');

  await dt.sleep();
  dt.log.i('预期结果9、显示右侧切换箭头');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 10、鼠标移动到右侧边框非响应热区范围内');

  await dt.sleep();
  dt.log.i('预期结果10、不显示右侧切换箭头');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 11、大图页，鼠标双击图片，放大图片，鼠标移动到左右边框响应热区');

  await dt.sleep();
  dt.log.i('预期结果11、左右箭头不显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 12、一般模式，图库一张图打开大图');

  await dt.sleep();
  dt.log.i('预期结果12、不显示左右箭头');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 13、一般模式，图库第一张图打开大图');

  await dt.sleep();
  dt.log.i('预期结果13、只显示右侧箭头');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端左右箭头显示测试 end');
}

/**
 * 宫格-格式: [PC端点击左右箭头测试]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Arrows_003
 * 前置条件
 * 1、图库中存在不同格式、不同版式的照片和视频文件
 */
async function multimediaGalleryArrows003(dt: Dt) {
  dt.log.i('PC端点击左右箭头测试 start');
  dt.log.i('STEP 1、一般模式，多张第一张图打开大图，点击右侧箭头');

  await dt.sleep();
  dt.log.i('预期结果1、切换到下一张');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、一般模式，多张图非首尾图打开大图，点击左右箭头');

  await dt.sleep();
  dt.log.i('预期结果2、切换到上一张或下一张');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、一般模式，多张最后一张打开大图，点击左侧箭头');

  await dt.sleep();
  dt.log.i('预期结果3、切换到上一张');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、沉浸模式，多张第一张图打开大图，点击右侧箭头');

  await dt.sleep();
  dt.log.i('预期结果4、切换到下一张');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、沉浸模式，多张图非首尾图打开大图，点击左右箭头');

  await dt.sleep();
  dt.log.i('预期结果5、切换到上一张或下一张');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、沉浸模式，多张最后一张打开大图，点击左侧箭头');

  await dt.sleep();
  dt.log.i('预期结果6、切换到上一张');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 7、一般模式，多张第一张图，鼠标移动到右侧热区显示箭头，点击右侧箭头');

  await dt.sleep();
  dt.log.i('预期结果7、切换到下一张');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 8、一般模式，多张图非首尾图，鼠标移动到左右侧热区显示箭头，分别点击左右箭头');

  await dt.sleep();
  dt.log.i('预期结果8、切换到上一张或下一张');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 9、一般模式，多张最后一张，鼠标移动到左侧热区显示箭头，点击左侧箭头');

  await dt.sleep();
  dt.log.i('预期结果9、切换到上一张');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 10、沉浸模式，多张第一张图，鼠标移动到右侧热区显示箭头，点击右侧箭头');

  await dt.sleep();
  dt.log.i('预期结果10、切换到下一张');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 11、沉浸模式，多张图非首尾图，鼠标移动到左右侧热区显示箭头，分别点击左右箭头');

  await dt.sleep();
  dt.log.i('预期结果11、切换到上一张或下一张');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 12、沉浸模式，多张最后一张，鼠标移动到左侧热区显示箭头，点击左侧箭头');

  await dt.sleep();
  dt.log.i('预期结果12、切换到上一张');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端点击左右箭头测试 end');
}

/**
 * 宫格-格式: [PC端左右箭头消失测试]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Arrows_004
 * 前置条件
 * 1、图库中存在不同格式、不同版式的照片和视频文件
 */
async function multimediaGalleryArrows004(dt: Dt) {
  dt.log.i('PC端左右箭头消失测试 start');
  dt.log.i('STEP 1、一般模式，多张第一张图，箭头显示后，鼠标再悬停超过2秒');

  await dt.sleep();
  dt.log.i('预期结果1、右侧箭头消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、一般模式，多张非首尾图，箭头显示后，鼠标再悬停超过2秒');

  await dt.sleep();
  dt.log.i('预期结果2、左右箭头均消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、一般模式，多张最后一张图，箭头显示后，鼠标再悬停超过2秒');

  await dt.sleep();
  dt.log.i('预期结果3、左侧箭头消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、沉浸模式，多张第一张图，箭头显示后，鼠标再悬停超过2秒');

  await dt.sleep();
  dt.log.i('预期结果4、右侧箭头消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、沉浸模式，多张非首尾图，箭头显示后，鼠标再悬停超过2秒');

  await dt.sleep();
  dt.log.i('预期结果5、左右箭头均消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、沉浸模式，多张最后一张图，箭头显示后，鼠标再悬停超过2秒');

  await dt.sleep();
  dt.log.i('预期结果6、左侧箭头消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 7、一般模式，多张第一张图，鼠标移入右侧热区箭头显示后，鼠标再移出热区');

  await dt.sleep();
  dt.log.i('预期结果7、右侧箭头消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 8、一般模式，多张非首尾图，鼠标移入左右侧热区箭头显示后，鼠标再移出热区');

  await dt.sleep();
  dt.log.i('预期结果8、左右箭头均消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 9、一般模式，多张最后一张图，鼠标移入左侧热区箭头显示后，鼠标再移出热区');

  await dt.sleep();
  dt.log.i('预期结果9、左侧箭头消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 10、沉浸模式，多张第一张图，鼠标移入右侧热区箭头显示后，鼠标再移出热区');

  await dt.sleep();
  dt.log.i('预期结果10、右侧箭头消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 11、沉浸模式，多张非首尾图，鼠标移入左右侧热区箭头显示后，鼠标再移出热区');

  await dt.sleep();
  dt.log.i('预期结果11、左右箭头均消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 12、沉浸模式，多张最后一张图，鼠标移入左侧热区箭头显示后，鼠标再移出热区');

  await dt.sleep();
  dt.log.i('预期结果12、左侧箭头消失');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端左右箭头消失测试 end');
}

/**
 * 宫格-解析: [PC端左右箭头可靠性性能测试]
 * GROUP: 宫格 MODULE: 解析TID: Multimedia_Gallery_Arrows_005
 * 前置条件
 * 1、图库中存在不同格式、不同版式的照片和视频文件
 */
async function multimediaGalleryArrows005(dt: Dt) {
  dt.log.i('PC端左右箭头可靠性性能测试 start');
  dt.log.i('STEP 1、一般模式下，反复构造100次打开大图');

  await dt.sleep();
  dt.log.i('预期结果1、箭头显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、沉浸模式下，反复构造100次大图页箭头显示后再悬停超过2秒');

  await dt.sleep();
  dt.log.i('预期结果2、箭头消失正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、一般模式下，反复构造100次鼠标移入边框热区');

  await dt.sleep();
  dt.log.i('预期结果3、箭头显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、沉浸模式下，反复构造100次鼠标移出边框热区');

  await dt.sleep();
  dt.log.i('预期结果4、箭头消失正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、一般模式下，反复构造100次大图页鼠标悬停超过1秒，箭头显示后反复点击箭头切换');

  await dt.sleep();
  dt.log.i('预期结果5、反复切换图片正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、一般模式下，反复构造100次鼠标移入边框热区，箭头显示后反复点击箭头切换');

  await dt.sleep();
  dt.log.i('预期结果6、反复切换图片正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 7、一般模式下大图页，240fps慢动作录制箭头显示后鼠标继续悬停到箭头消失过程，解析箭头出现到箭头消失时延');

  await dt.sleep();
  dt.log.i('预期结果7、中间悬停2秒箭头消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 8、一般模式下多张图非首尾张，鼠标移动到左侧热区，240fps慢动作录制鼠标光标进入热区到箭头显示过程，解析鼠标进入开始到箭头显示的响应时延');

  await dt.sleep();
  dt.log.i('预期结果8、摸底响应时延');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 9、一般模式下多张图非首尾张，鼠标移动到右侧热区，240fps慢动作录制鼠标光标进入热区到箭头显示过程，解析鼠标进入开始到箭头显示的响应时延');

  await dt.sleep();
  dt.log.i('预期结果9、摸底响应时延');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端左右箭头可靠性性能测试 end');
}

/**
 * 宫格-视频: [入口封面-图片视频封面验证（仅1类、仅2类、仅3类、仅4类、超4类、云图）]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Categorize_001
 * 前置条件
 * 1、终端已刷新IT14以上版本
 2、已准备5大类23小类图片视频
 3、终端息屏电量大于50%等待分类完成
 */
async function multimediaGalleryCategorize001(dt: Dt) {
  dt.log.i('入口封面-图片视频封面验证（仅1类、仅2类、仅3类、仅4类、超4类、云图） start');
  dt.log.i('STEP 1、导入图片视频仅1类观察分类相册封面');

  await dt.sleep();
  dt.log.i('预期结果1、封面1图，大图标显示，照片视频均显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、导入图片视频仅2类观察分类相册封面');

  await dt.sleep();
  dt.log.i('预期结果2、封面有2图，居上显示，其余留白');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、导入图片视频仅3类观察分类相册封面');

  await dt.sleep();
  dt.log.i('预期结果3、封面有3图，左右左下显示，其余留白');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、导入图片视频仅4类观察分类相册封面');

  await dt.sleep();
  dt.log.i('预期结果4、封面4图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、导入图片视频超4类观察分类相册封面');

  await dt.sleep();
  dt.log.i('预期结果5、封面4图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、云同步触发图片视频更新1-4类，观察分类相册封面');

  await dt.sleep();
  dt.log.i('预期结果6、封面4位置均可刷新云图数据');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('入口封面-图片视频封面验证（仅1类、仅2类、仅3类、仅4类、超4类、云图） end');
}

/**
 * 宫格-大图: [大图移除验证（共识别、重编辑、重云同步）]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Categorize_002
 * 前置条件
 * 1、终端已刷新IT14以上版本
 2、已准备5大类23小类图片视频
 3、终端息屏电量大于50%等待分类完成
 */
async function multimediaGalleryCategorize002(dt: Dt) {
  dt.log.i('大图移除验证（共识别、重编辑、重云同步） start');
  dt.log.i('STEP 1、进入分类相册某大图移除操作，观察相册变化');

  await dt.sleep();
  dt.log.i('预期结果1、移除后相册数量更新，其他常规相册可显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入其他相册对刚刚大图进行编辑操作，无任何编辑退出，进入分类相册观察相册变化');

  await dt.sleep();
  dt.log.i('预期结果2、分类相册无变化');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入其他相册对刚刚大图进行编辑操作编辑后覆盖保存，另存为，进入分类相册观察相册变化');

  await dt.sleep();
  dt.log.i('预期结果3、分类继承原来');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、移除大图后重新云同步，进入分类相册观察相册变化，移除后删除再云同步，进入分类相册观察相册变化');

  await dt.sleep();
  dt.log.i('预期结果4、移除后云同步分类无此照片，移除后删除再云同步分类无此照片');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图移除验证（共识别、重编辑、重云同步） end');
}

/**
 * 宫格-删除: [入口封面-降序封面自适应验证（仅1类、仅2类、仅3类、仅4类、超4类）（新增图片、删除图片、云同步）]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Categorize_003
 * 前置条件
 * 1、终端已刷新IT14以上版本
 2、已准备5大类23小类图片视频
 3、终端息屏电量大于50%等待分类完成
 */
async function multimediaGalleryCategorize003(dt: Dt) {
  dt.log.i('入口封面-降序封面自适应验证（仅1类、仅2类、仅3类、仅4类、超4类）（新增图片、删除图片、云同步） start');
  dt.log.i('STEP 1、仅1类场景      新增图片、删除图片、云同步新增触发数量变化，观察封面');

  await dt.sleep();
  dt.log.i('预期结果1、封面取最新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、仅2类场景      新增图片、删除图片、云同步新增触发12位置数量变化，观察封面');

  await dt.sleep();
  dt.log.i('预期结果2、封面顺序符合降序排序，缩略图取各类最新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、仅3类场景      新增图片、删除图片、云同步新增触发123位置数量变化，观察封面');

  await dt.sleep();
  dt.log.i('预期结果3、封面顺序符合降序排序，缩略图取各类最新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、仅4类场景      新增图片、删除图片、云同步新增触发1234数量变化，观察封面');

  await dt.sleep();
  dt.log.i('预期结果4、封面顺序符合降序排序，缩略图取各类最新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、超4类场景      新增图片、删除图片、云同步新增触发前4、前4后数量变化，观察封面');

  await dt.sleep();
  dt.log.i('预期结果5、封面顺序符合降序排序，前4后数量变化不影响封面，，缩略图取各类最新');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('入口封面-降序封面自适应验证（仅1类、仅2类、仅3类、仅4类、超4类）（新增图片、删除图片、云同步） end');
}










