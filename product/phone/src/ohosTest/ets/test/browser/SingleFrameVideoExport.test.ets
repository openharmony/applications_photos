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
    run('Multimedia_Gallery_SR20240327153237_001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [相机录像不同视频分辨率视频截图] TID: Multimedia_Gallery_SR20240327153237_001
      await Multimedia_Gallery_SR20240327153237_001(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [相机录像不同视频帧率视频截图] TID: Multimedia_Gallery_SR20240327153237_002
      await Multimedia_Gallery_SR20240327153237_002(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [相机录像HDR Vivid录制视频截图] TID: Multimedia_Gallery_SR20240327153237_003
      await Multimedia_Gallery_SR20240327153237_003(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [常见视频格式截图] TID: Multimedia_Gallery_SR20240327153237_004
      await Multimedia_Gallery_SR20240327153237_004(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频编辑保存后视频截图] TID: Multimedia_Gallery_SR20240327153237_005
      await Multimedia_Gallery_SR20240327153237_005(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_006', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [云端下载视频截图] TID: Multimedia_Gallery_SR20240327153237_006
      await Multimedia_Gallery_SR20240327153237_006(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [隐藏相册视频截图] TID: Multimedia_Gallery_SR20240327153237_007
      await Multimedia_Gallery_SR20240327153237_007(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频截图失败] TID: Multimedia_Gallery_SR20240327153237_008
      await Multimedia_Gallery_SR20240327153237_008(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_014', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [深色模式视频截图] TID: Multimedia_Gallery_SR20240327153237_014
      await Multimedia_Gallery_SR20240327153237_014(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_015', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [多用户视频截图] TID: Multimedia_Gallery_SR20240327153237_015
      await Multimedia_Gallery_SR20240327153237_015(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [多语言视频截图] TID: Multimedia_Gallery_SR20240327153237_016
      await Multimedia_Gallery_SR20240327153237_016(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_017', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [压力测试视频截图] TID: Multimedia_Gallery_SR20240327153237_017
      await Multimedia_Gallery_SR20240327153237_017(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_018', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [大字体视频截图] TID: Multimedia_Gallery_SR20240327153237_018
      await Multimedia_Gallery_SR20240327153237_018(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_019', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [无障碍模式视频截图] TID: Multimedia_Gallery_SR20240327153237_019
      await Multimedia_Gallery_SR20240327153237_019(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_020', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [分屏视频截图] TID: Multimedia_Gallery_SR20240327153237_020
      await Multimedia_Gallery_SR20240327153237_020(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_021', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [悬浮窗视频截图] TID: Multimedia_Gallery_SR20240327153237_021
      await Multimedia_Gallery_SR20240327153237_021(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_022', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [横屏视频截图] TID: Multimedia_Gallery_SR20240327153237_022
      await Multimedia_Gallery_SR20240327153237_022(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_023', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [最近删除相册视频截图] TID: Multimedia_Gallery_SR20240327153237_023
      await Multimedia_Gallery_SR20240327153237_023(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_025', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-锁屏用例: [锁屏相机录屏截图] TID: Multimedia_Gallery_SR20240327153237_025
      await Multimedia_Gallery_SR20240327153237_025(dt);
    });
    run('Multimedia_Gallery_SR20240327153237_026', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [文件分辨率和显示分辨率不一致的视频支持单帧导出] TID: Multimedia_Gallery_SR20240327153237_026
      await Multimedia_Gallery_SR20240327153237_026(dt);
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
 * 大图-视频: [相机录像不同视频分辨率视频截图]
 * TAG: 866 TID: Multimedia_Gallery_SR20240327153237_001
 * 前置条件
 * 1、相机录像拍摄视频分辨率为（16:9）4k/1080P/720P和全屏1080P的视频
 */
async function Multimedia_Gallery_SR20240327153237_001(dt: Dt) {
  dt.log.i('相机录像不同视频分辨率视频截图 start');
  dt.log.i('STEP 1、点击相机左下角的缩略图');

  await dt.sleep();
  dt.log.i('STEP 2、点击视频播放');

  await dt.sleep();
  dt.log.i('STEP 3、点击截图按钮');

  await dt.sleep();
  dt.log.i('预期结果3、提示“已保存至截图相册”，截图当前图片保存至截图相册，图片比例与视频一致');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已保存至截图相册', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机录像不同视频分辨率视频截图 end');
}

/**
 * 大图-视频: [相机录像不同视频帧率视频截图]
 * TAG: 870 TID: Multimedia_Gallery_SR20240327153237_002
 * 前置条件
 * 1、相机录像拍摄视频帧率为30fps/60fps的视频
 */
async function Multimedia_Gallery_SR20240327153237_002(dt: Dt) {
  dt.log.i('相机录像不同视频帧率视频截图 start');
  dt.log.i('STEP 1、点击相机左下角的缩略图');

  await dt.sleep();
  dt.log.i('STEP 2、点击视频播放');

  await dt.sleep();
  dt.log.i('STEP 3、点击截图按钮');

  await dt.sleep();
  dt.log.i('预期结果3、提示“已保存至截图相册”，截图当前图片保存至截图相册，图片比例与视频一致');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已保存至截图相册', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机录像不同视频帧率视频截图 end');
}

/**
 * 大图-HDR: [相机录像HDR Vivid录制视频截图]
 * TAG: 863 TID: Multimedia_Gallery_SR20240327153237_003
 * 前置条件
 * 1、相机录像拍摄HDR Vivid录制打开/关闭的视频
 */
async function Multimedia_Gallery_SR20240327153237_003(dt: Dt) {
  dt.log.i('相机录像HDR Vivid录制视频截图 start');
  dt.log.i('STEP 1、点击相机左下角的缩略图');

  await dt.sleep();
  dt.log.i('STEP 2、点击视频播放');

  await dt.sleep();
  dt.log.i('STEP 3、点击截图按钮');

  await dt.sleep();
  dt.log.i('预期结果3、提示“已保存至截图相册”，截图当前图片保存至截图相册，图片展示存在/不存在HDR效果');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已保存至截图相册', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机录像HDR Vivid录制视频截图 end');
}

/**
 * 大图-格式: [常见视频格式截图]
 * TAG: 864 TID: Multimedia_Gallery_SR20240327153237_004
 * 前置条件
 * 1、图库存在视频格式为flv/webm/mov/wmv/aiv/mpg/div/mkv/rmvb的视频
 */
async function Multimedia_Gallery_SR20240327153237_004(dt: Dt) {
  dt.log.i('常见视频格式截图 start');
  dt.log.i('STEP 1、视频大图浏览');

  await dt.sleep();
  dt.log.i('STEP 2、点击视频播放（遍历flv/webm/mov/wmv/aiv/mpg/div/mkv/rmvb格式视频）');

  await dt.sleep();
  dt.log.i('STEP 3、点击截图按钮');

  await dt.sleep();
  dt.log.i('预期结果3、提示“已保存至截图相册”，截图当前图片保存至截图相册，无法播放或播放黑屏的视频提示“截图失败，请稍后”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已保存至截图相册', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('常见视频格式截图 end');
}

/**
 * 大图-视频: [视频编辑保存后视频截图]
 * TAG: 862 TID: Multimedia_Gallery_SR20240327153237_005
 * 前置条件
 * 1、图库存在编辑后（覆盖/另存为）的视频
 */
async function Multimedia_Gallery_SR20240327153237_005(dt: Dt) {
  dt.log.i('视频编辑保存后视频截图 start');
  dt.log.i('STEP 1、编辑之后的视频');

  await dt.sleep();
  dt.log.i('STEP 2、大图浏览视频');

  await dt.sleep();
  dt.log.i('STEP 3、点击截图按钮（遍历未播放、暂停、播放状态）');

  await dt.sleep();
  dt.log.i('预期结果3、提示“已保存至截图相册”，截图封面/当前图片/暂停图片保存至截图相册，图片比例与视频一致');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已保存至截图相册', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频编辑保存后视频截图 end');
}

/**
 * 大图-下载: [云端下载视频截图]
 * TAG: 867 TID: Multimedia_Gallery_SR20240327153237_006
 * 前置条件
 * 1、存在云端视频
 */
async function Multimedia_Gallery_SR20240327153237_006(dt: Dt) {
  dt.log.i('云端下载视频截图 start');
  dt.log.i('STEP 1、云端的视频大图浏览');

  await dt.sleep();
  dt.log.i('STEP 2、点击截图按钮（遍历未播放、暂停、播放状态）');

  await dt.sleep();
  dt.log.i('预期结果2、提示“已保存至截图相册”，截图封面/当前图片/暂停图片保存至截图相册，图片比例与视频一致');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('已保存至截图相册'));
  dt.log.i('STEP 3、关闭云同步开关再打开，选择视频点击截屏按钮');

  await dt.sleep();
  dt.log.i('预期结果3、4s内截图成功，提示“已保存至截图相册”，否则4s后提示“截图失败，请稍候”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已保存至截图相册', true);
  dt.log.i('STEP 4、短时间重复点击云端视频截屏按钮');

  await dt.sleep();
  dt.log.i('预期结果4、重复结果3，弹出多次提示，不会导致卡死，闪退');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云端下载视频截图 end');
}

/**
 * 大图-视频: [隐藏相册视频截图]
 * TAG: 861 TID: Multimedia_Gallery_SR20240327153237_007
 * 前置条件
 * 1、隐藏相册存在视频
 */
async function Multimedia_Gallery_SR20240327153237_007(dt: Dt) {
  dt.log.i('隐藏相册视频截图 start');
  dt.log.i('STEP 1、进入隐藏相册');

  await dt.sleep();
  dt.log.i('STEP 2、视频大图浏览');

  await dt.sleep();
  dt.log.i('STEP 3、点击截图按钮（遍历未播放、暂停、播放状态）');

  await dt.sleep();
  dt.log.i('预期结果3、提示“已保存至截图相册”，截图封面/当前图片/暂停图片保存至截图相册，图片比例与视频一致');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已保存至截图相册', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册视频截图 end');
}

/**
 * 大图-视频: [视频截图失败]
 * TAG: 865 TID: Multimedia_Gallery_SR20240327153237_008
 * 前置条件
 * 1、图库存在导致截图失败的视频
 */
async function Multimedia_Gallery_SR20240327153237_008(dt: Dt) {
  dt.log.i('视频截图失败 start');
  dt.log.i('STEP 1、视频大图浏览');

  await dt.sleep();
  dt.log.i('STEP 2、点击截图按钮');

  await dt.sleep();
  dt.log.i('预期结果2、提示错误信息，无闪退/无响应/崩溃和页面异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频截图失败 end');
}

/**
 * 大图-视频: [深色模式视频截图]
 * TAG: 874 TID: Multimedia_Gallery_SR20240327153237_014
 * 前置条件
 * 1、图库存在多个可播放的视频
 */
async function Multimedia_Gallery_SR20240327153237_014(dt: Dt) {
  dt.log.i('深色模式视频截图 start');
  dt.log.i('STEP 1、切换深色模式');

  await dt.sleep();
  dt.log.i('STEP 2、视频大图浏览');

  await dt.sleep();
  dt.log.i('STEP 3、点击截图按钮');

  await dt.sleep();
  dt.log.i('预期结果3、提示“已保存至截图相册” ');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已保存至截图相册', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('深色模式视频截图 end');
}

/**
 * 大图-视频: [多用户视频截图]
 * TAG: 876 TID: Multimedia_Gallery_SR20240327153237_015
 * 前置条件
 * 1、图库存在多个可播放的视频
 */
async function Multimedia_Gallery_SR20240327153237_015(dt: Dt) {
  dt.log.i('多用户视频截图 start');
  dt.log.i('STEP 1、进入隐私空间');

  await dt.sleep();
  dt.log.i('STEP 2、视频大图浏览');

  await dt.sleep();
  dt.log.i('STEP 3、点击截图按钮');

  await dt.sleep();
  dt.log.i('预期结果3、提示“已保存至截图相册”，截图封面/当前图片/暂停图片保存至截图相册，图片比例与视频一致');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已保存至截图相册', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多用户视频截图 end');
}

/**
 * 大图-视频: [多语言视频截图]
 * TAG: 875 TID: Multimedia_Gallery_SR20240327153237_016
 * 前置条件
 * 1、图库存在多个可播放的视频
 */
async function Multimedia_Gallery_SR20240327153237_016(dt: Dt) {
  dt.log.i('多语言视频截图 start');
  dt.log.i('STEP 1、视频大图浏览');

  await dt.sleep();
  dt.log.i('STEP 2、点击宫格选择视频播放');

  await dt.sleep();
  dt.log.i('STEP 3、点击截图按钮');

  await dt.sleep();
  dt.log.i('预期结果3、提示信息显示为对应的多语言，截图封面图片保存至截图相册，图片比例与视频一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、遍历英文，镜像语音等操作操作1-3');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多语言视频截图 end');
}

/**
 * 大图-视频: [压力测试视频截图]
 * TAG: 877 TID: Multimedia_Gallery_SR20240327153237_017
 * 前置条件
 * 1、图库存在多个可播放的视频
 */
async function Multimedia_Gallery_SR20240327153237_017(dt: Dt) {
  dt.log.i('压力测试视频截图 start');
  dt.log.i('STEP 1、视频大图浏览');

  await dt.sleep();
  dt.log.i('STEP 2、连续点击截图按钮1000次');

  await dt.sleep();
  dt.log.i('预期结果2、提示“已保存至截图相册” ，截图相册照片数量正常，无闪退/无响应/崩溃和页面异常');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('已保存至截图相册'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('压力测试视频截图 end');
}

/**
 * 大图-视频: [大字体视频截图]
 * TAG: 878 TID: Multimedia_Gallery_SR20240327153237_018
 * 前置条件
 * 1、图库存在多个可播放的视频
 */
async function Multimedia_Gallery_SR20240327153237_018(dt: Dt) {
  dt.log.i('大字体视频截图 start');
  dt.log.i('STEP 1、大字体模式/关怀模式');

  await dt.sleep();
  dt.log.i('STEP 2、视频大图浏览');

  await dt.sleep();
  dt.log.i('STEP 3、点击截图按钮');

  await dt.sleep();
  dt.log.i('预期结果3、提示“已保存至截图相册” ，字体大小为对应字号');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已保存至截图相册', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大字体视频截图 end');
}

/**
 * 大图-视频: [无障碍模式视频截图]
 * TAG: 879 TID: Multimedia_Gallery_SR20240327153237_019
 * 前置条件
 * 1、图库存在多个可播放的视频
 */
async function Multimedia_Gallery_SR20240327153237_019(dt: Dt) {
  dt.log.i('无障碍模式视频截图 start');
  dt.log.i('STEP 1、无障碍模式');

  await dt.sleep();
  dt.log.i('STEP 2、视频大图浏览');

  await dt.sleep();
  dt.log.i('STEP 3、点击截图按钮');

  await dt.sleep();
  dt.log.i('预期结果3、无障碍语音播报正常，提示“已保存至截图相册”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已保存至截图相册', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无障碍模式视频截图 end');
}

/**
 * 大图-视频: [分屏视频截图]
 * TAG: 880 TID: Multimedia_Gallery_SR20240327153237_020
 * 前置条件
 * 1、图库存在多个可播放的视频
 */
async function Multimedia_Gallery_SR20240327153237_020(dt: Dt) {
  dt.log.i('分屏视频截图 start');
  dt.log.i('STEP 1、分屏下视频大图浏览');

  await dt.sleep();
  dt.log.i('STEP 2、点击截图按钮');

  await dt.sleep();
  dt.log.i('预期结果2、提示“已保存至截图相册” ，界面显示正常，无截断等');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('已保存至截图相册'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分屏视频截图 end');
}

/**
 * 大图-视频: [悬浮窗视频截图]
 * TAG: 881 TID: Multimedia_Gallery_SR20240327153237_021
 * 前置条件
 * 1、图库存在多个可播放的视频
 */
async function Multimedia_Gallery_SR20240327153237_021(dt: Dt) {
  dt.log.i('悬浮窗视频截图 start');
  dt.log.i('STEP 1、悬浮窗下视频大图浏览');

  await dt.sleep();
  dt.log.i('STEP 2、点击截图按钮');

  await dt.sleep();
  dt.log.i('预期结果2、提示“已保存至截图相册” ，界面显示正常，无截断等');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('已保存至截图相册'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('悬浮窗视频截图 end');
}

/**
 * 大图-视频: [横屏视频截图]
 * TAG: 882 TID: Multimedia_Gallery_SR20240327153237_022
 * 前置条件
 * 1、图库存在多个可播放的视频
 */
async function Multimedia_Gallery_SR20240327153237_022(dt: Dt) {
  dt.log.i('横屏视频截图 start');
  dt.log.i('STEP 1、视频大图浏览');

  await dt.sleep();
  dt.log.i('STEP 2、点击截图按钮');

  await dt.sleep();
  dt.log.i('预期结果2、提示“已保存至截图相册”，截图已保存至截图相册');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('已保存至截图相册'));
  dt.log.i('STEP 3、横竖屏切换之后再次点击截图按钮');

  await dt.sleep();
  dt.log.i('预期结果3、提示“已保存至截图相册” ，截图已保存至截图相册，界面显示正常，无截断等');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已保存至截图相册', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('横屏视频截图 end');
}

/**
 * 大图-删除: [最近删除相册视频截图]
 * TAG: 884 TID: Multimedia_Gallery_SR20240327153237_023
 * 前置条件
 * 1、最近删除相册存在多个可播放的视频
 */
async function Multimedia_Gallery_SR20240327153237_023(dt: Dt) {
  dt.log.i('最近删除相册视频截图 start');
  dt.log.i('STEP 1、进入最近删除相册的视频大图浏览');

  await dt.sleep();
  dt.log.i('预期结果1、最近删除相册不支持视频截图功能');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除相册视频截图 end');
}

/**
 * 大图-锁屏: [锁屏相机录屏截图]
 * TAG: 885 TID: Multimedia_Gallery_SR20240327153237_025
 * 前置条件
 * 1、手机锁屏
 */
async function Multimedia_Gallery_SR20240327153237_025(dt: Dt) {
  dt.log.i('锁屏相机录屏截图 start');
  dt.log.i('STEP 1、锁屏页面右下相机按钮往屏中心滑动');

  await dt.sleep();
  dt.log.i('STEP 2、进入相机开始录屏');

  await dt.sleep();
  dt.log.i('STEP 3、录屏结束点击左下缩略图');

  await dt.sleep();
  dt.log.i('STEP 4、进入视频大图，点击截图按钮');

  await dt.sleep();
  dt.log.i('预期结果4、提示“已保存至截图相册”，确认截图保存至截图相册');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已保存至截图相册', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('锁屏相机录屏截图 end');
}

/**
 * 大图-视频: [文件分辨率和显示分辨率不一致的视频支持单帧导出]
 * TAG: 886 TID: Multimedia_Gallery_SR20240327153237_026
 * 前置条件
 * <p>图库存在文件分辨率和显示分辨率不一致的视频</p>
 */
async function Multimedia_Gallery_SR20240327153237_026(dt: Dt) {
  dt.log.i('文件分辨率和显示分辨率不一致的视频支持单帧导出 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('文件分辨率和显示分辨率不一致的视频支持单帧导出 end');
}

