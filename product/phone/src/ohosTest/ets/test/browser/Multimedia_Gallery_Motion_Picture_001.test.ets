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

export default function Multimedia_Gallery_Motion_Picture_001(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('Multimedia_Gallery_Motion_Picture_001', (): void => {
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
    run('Multimedia_Gallery_Motion_picture_00021', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片水印显示] TID: Multimedia_Gallery_Motion_picture_00021
      await Multimedia_Gallery_Motion_picture_00021(dt);
    });
    run('Multimedia_Gallery_Motion_picture_001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [不同入口图库大图页面结构优化图标检查] TID: Multimedia_Gallery_Motion_picture_001
      await Multimedia_Gallery_Motion_picture_001(dt);
    });
    run('Multimedia_Gallery_Motion_picture_002', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片滑动图标检查] TID: Multimedia_Gallery_Motion_picture_002
      await Multimedia_Gallery_Motion_picture_002(dt);
    });
    run('Multimedia_Gallery_Motion_picture_003', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片支持长按播放] TID: Multimedia_Gallery_Motion_picture_003
      await Multimedia_Gallery_Motion_picture_003(dt);
    });
    run('Multimedia_Gallery_Motion_picture_004', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [不同入口长按播放动态照片] TID: Multimedia_Gallery_Motion_picture_004
      await Multimedia_Gallery_Motion_picture_004(dt);
    });
    run('Multimedia_Gallery_Motion_picture_005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片菜单操作] TID: Multimedia_Gallery_Motion_picture_005
      await Multimedia_Gallery_Motion_picture_005(dt);
    });
    run('Multimedia_Gallery_Motion_picture_006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片编辑] TID: Multimedia_Gallery_Motion_picture_006
      await Multimedia_Gallery_Motion_picture_006(dt);
    });
    run('Multimedia_Gallery_Motion_picture_007', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [存在主体或文字的动态照片长按播放] TID: Multimedia_Gallery_Motion_picture_007
      await Multimedia_Gallery_Motion_picture_007(dt);
    });
    run('Multimedia_Gallery_Motion_picture_008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片端云同步] TID: Multimedia_Gallery_Motion_picture_008
      await Multimedia_Gallery_Motion_picture_008(dt);
    });
    run('Multimedia_Gallery_Motion_picture_009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片在线长按播放] TID: Multimedia_Gallery_Motion_picture_009
      await Multimedia_Gallery_Motion_picture_009(dt);
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
 * 大图-动态照片: [动态照片水印显示]
 * TAG: 65 TID: Multimedia_Gallery_Motion_picture_00021
 * 前置条件
 * 1、图库有有带水印的动态照片（可以使用相机拍摄动态照片）
 */
async function Multimedia_Gallery_Motion_picture_00021(dt: Dt) {
  dt.log.i('动态照片水印显示 start');
  dt.log.i('STEP 1、从图库照片页进入动态照片大图');

  await dt.sleep();
  dt.log.i('STEP 2、长按动态照片播放，检查水印的显示');

  await dt.sleep();
  dt.log.i('预期结果2-4、动态照片播放动效过程中，水印显示完整');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、左右滑动动态照片，检查水印的显示 ');

  await dt.sleep();
  dt.log.i('STEP 4、切换不同的动态照片效果，检查水印的显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片水印显示 end');
}

/**
 * 大图-大图: [不同入口图库大图页面结构优化图标检查]
 * TAG: 62 TID: Multimedia_Gallery_Motion_picture_001
 * 前置条件
 * 1、准备动态照片（可以使用相机拍摄动态照片）
 */
async function Multimedia_Gallery_Motion_picture_001(dt: Dt) {
  dt.log.i('不同入口图库大图页面结构优化图标检查 start');
  dt.log.i('STEP 1、从图库照片页进入动态照片大图查看图标');

  await dt.sleep();
  dt.log.i('预期结果1-8、动态照片显示图标，普通大图不显示动态照片图标');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从图片相册进入动态照片大图查看图标');

  await dt.sleep();
  dt.log.i('STEP 3、从智慧相册（人像相册、地点相册、分类相册、拍摄模式）进入动态照片大图查看图标');

  await dt.sleep();
  dt.log.i('STEP 4、从隐藏相册进入动态照片大图查看图标');

  await dt.sleep();
  dt.log.i('STEP 5、从最近删除进入动态照片大图查看图标');

  await dt.sleep();
  dt.log.i('STEP 6、从相机缩略图进入动态照片大图查看图标');

  await dt.sleep();
  dt.log.i('STEP 7、从搜索进入动态照片大图查看图标');

  await dt.sleep();
  dt.log.i('STEP 8、从FA卡片进入动态照片大图查看图标');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同入口图库大图页面结构优化图标检查 end');
}

/**
 * 大图-动态照片: [动态照片滑动图标检查]
 * TAG: 51 TID: Multimedia_Gallery_Motion_picture_002
 * 前置条件
 * 1、准备动态照片（可以使用相机拍摄动态照片）
 */
async function Multimedia_Gallery_Motion_picture_002(dt: Dt) {
  dt.log.i('动态照片滑动图标检查 start');
  dt.log.i('STEP 1、从图库照片页进入动态照片大图查看图标 ');

  await dt.sleep();
  dt.log.i('STEP 2、在大图照片大图页滑动查看屏幕下方动态照片图标');

  await dt.sleep();
  dt.log.i('预期结果2、动态照片显示图标，普通大图不显示动态照片图标');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片滑动图标检查 end');
}

/**
 * 大图-动态照片: [动态照片支持长按播放]
 * TAG: 60 TID: Multimedia_Gallery_Motion_picture_003
 * 前置条件
 * 1、准备动态照片（可以使用相机拍摄动态照片）
 */
async function Multimedia_Gallery_Motion_picture_003(dt: Dt) {
  dt.log.i('动态照片支持长按播放 start');
  dt.log.i('STEP 1、从图库照片页进入动态照片大图');

  await dt.sleep();
  dt.log.i('预期结果1、动态照片宫格缩略图显示清晰无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、长按该动态照片大图');

  await dt.sleep();
  dt.log.i('预期结果2、能够正常播放动态照片，且播放清晰度正常，声音无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片支持长按播放 end');
}

/**
 * 大图-动态照片: [不同入口长按播放动态照片]
 * TAG: 61 TID: Multimedia_Gallery_Motion_picture_004
 * 前置条件
 * 1、准备动态照片（可以使用相机拍摄动态照片）
 */
async function Multimedia_Gallery_Motion_picture_004(dt: Dt) {
  dt.log.i('不同入口长按播放动态照片 start');
  dt.log.i('STEP 1、从图库照片页进入动态照片大图长按播放');

  await dt.sleep();
  dt.log.i('预期结果1-10、支持长按播放动态照片，且播放清晰度正常，声音无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从图片相册进入动态照片大图长按播放');

  await dt.sleep();
  dt.log.i('STEP 3、从智慧相册（人像相册、地点相册、分类相册、拍摄模式）进入动态照片大图长按播放');

  await dt.sleep();
  dt.log.i('STEP 4、从搜索入口进入动态照片大图长按播放');

  await dt.sleep();
  dt.log.i('STEP 5、从隐藏相册进入动态照片大图长按播放');

  await dt.sleep();
  dt.log.i('STEP 6、从最近删除进入动态照片大图长按播放');

  await dt.sleep();
  dt.log.i('STEP 7、从相机缩略图进入动态照片大图长按播放');

  await dt.sleep();
  dt.log.i('STEP 8、从三方进入动态照片大图长按播放');

  await dt.sleep();
  dt.log.i('STEP 9、从FA卡片进入动态照片大图长按播放');

  await dt.sleep();
  dt.log.i('STEP 10、照片页多选后进入动态照片大图长按播放');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同入口长按播放动态照片 end');
}

/**
 * 大图-动态照片: [动态照片菜单操作]
 * TAG: 46 TID: Multimedia_Gallery_Motion_picture_005
 * 前置条件
 * 1、准备动态照片（可以使用相机拍摄动态照片）
 */
async function Multimedia_Gallery_Motion_picture_005(dt: Dt) {
  dt.log.i('动态照片菜单操作 start');
  dt.log.i('STEP 1、动态照片删除和恢复、收藏和取消收藏、隐藏和取消隐藏、添加到和移除、复制和粘贴、查看详情（上滑查看、点击详情按钮查看、编辑备注、重命名）（覆盖单张和多张场景）');

  await dt.sleep();
  dt.log.i('预期结果1、成功进行删除和恢复、收藏和取消收藏、隐藏和取消隐藏、添加到和移除、复制和粘贴、查看详情（上滑查看、点击详情按钮查看、编辑备注、重命名）（详情展示与图片保持一致）等操作');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片菜单操作 end');
}

/**
 * 大图-动态照片: [动态照片编辑]
 * TAG: 63 TID: Multimedia_Gallery_Motion_picture_006
 * 前置条件
 * 1、准备动态照片（可以使用相机拍摄动态照片）
 */
async function Multimedia_Gallery_Motion_picture_006(dt: Dt) {
  dt.log.i('动态照片编辑 start');
  dt.log.i('STEP 1、动态照片大图编辑查看入口');

  await dt.sleep();
  dt.log.i('预期结果1、能够正常进入编辑界面（视频编辑界面）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看编辑保存后动态照片大图显示、大图长按播放及宫格显示');

  await dt.sleep();
  dt.log.i('预期结果2.1、编辑后动态照片大图显示清晰无异常2.2、编辑后动态照片大图长按播放显示清晰无异常，声音无异常2.3、编辑后动态照片宫格缩略图显示清晰无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片编辑 end');
}

/**
 * 大图-动态照片: [存在主体或文字的动态照片长按播放]
 * TAG: 49 TID: Multimedia_Gallery_Motion_picture_007
 * 前置条件
 * 1、准备动态照片（可以使用相机拍摄动态照片）
 */
async function Multimedia_Gallery_Motion_picture_007(dt: Dt) {
  dt.log.i('存在主体或文字的动态照片长按播放 start');
  dt.log.i('STEP 1、长按动态照片大图非主体、非文字区域进行播放');

  await dt.sleep();
  dt.log.i('预期结果1、能够正常播放清晰无异常，声音无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、长按动态照片大图主体');

  await dt.sleep();
  dt.log.i('预期结果2、触发AI抠图（当前不支持）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、长按动态照片大图文字');

  await dt.sleep();
  dt.log.i('预期结果3、触发AI识字（当前不支持）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('存在主体或文字的动态照片长按播放 end');
}

/**
 * 大图-动态照片: [动态照片端云同步]
 * TAG: 53 TID: Multimedia_Gallery_Motion_picture_008
 * 前置条件
 * 1、准备动态照片（可以使用相机拍摄动态照片）
 */
async function Multimedia_Gallery_Motion_picture_008(dt: Dt) {
  dt.log.i('动态照片端云同步 start');
  dt.log.i('STEP 1、xxx动态图片云端同步到xxx手机');

  await dt.sleep();
  dt.log.i('预期结果1，2，3、动态照片能够成功端云同步，并且同步后显示清晰无异常，播放清晰无异常，声音无异常（当前变成普通照片宫格、大图显示正常，右上角不显示图标）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、xxx动态图片云端同步到xxx手机');

  await dt.sleep();
  dt.log.i('STEP 3、xxx动态图片云端同步到xxx手机');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片端云同步 end');
}

/**
 * 大图-动态照片: [动态照片在线长按播放]
 * TAG: 47 TID: Multimedia_Gallery_Motion_picture_009
 * 前置条件
 * 1、准备动态照片（可以使用相机拍摄动态照片）
 */
async function Multimedia_Gallery_Motion_picture_009(dt: Dt) {
  dt.log.i('动态照片在线长按播放 start');
  dt.log.i('STEP 1、辅助机动态照片同步上云，测试机同步云上动态照片并且长按播放');

  await dt.sleep();
  dt.log.i('预期结果1.1、先触发下载，下载完成变成普通照片时照片内容不会出现闪烁1.2、下载完成后再进行播放，且播放清晰度正常，声音无异常（当前变成普通照片宫格、大图显示正常，右上角不显示图标）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片在线长按播放 end');
}


