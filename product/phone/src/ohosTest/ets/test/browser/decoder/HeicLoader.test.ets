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

import { afterAll, afterEach, beforeAll, describe, Level } from '@ohos/hypium';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
// 补充完成后修改为 run as it
import { run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';
import { Component, Driver, MatchPattern, On, ON } from '@ohos.UiTest';

/**
 * 不要使用Log.info, 使用dt.log.i(), 以方便定位当前执行的测试套
 * 每个用例测试完成之后必须回到大图界面
 */
export default function HeifTest(): void {
  describe('HeicLoaderTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    // 确认当前图库app处于启动状态
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllHeicLoaderTest').init();
      dt.log.i('beforeAll HeicLoaderTest start');
      dt.log.i('beforeAll HeicLoaderTest finish');
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_055', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片手机分享到Verde] TID: Multimedia_Gallery_PhotoBrowser_HEIC_055
      await Multimedia_Gallery_PhotoBrowser_HEIC_055(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_019', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-大图向左滑动-不预加载左边图片] TID: Multimedia_Gallery_PhotoBrowser_HEIC_019
      await Multimedia_Gallery_PhotoBrowser_HEIC_019(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_020', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-大图向右滑动-预加载左边图片] TID: Multimedia_Gallery_PhotoBrowser_HEIC_020
      await Multimedia_Gallery_PhotoBrowser_HEIC_020(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_021', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-大图向右滑动-不预加载左边图片] TID: Multimedia_Gallery_PhotoBrowser_HEIC_021
      await Multimedia_Gallery_PhotoBrowser_HEIC_021(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_022', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-相机进大图-预加载左右图片各一张] TID: Multimedia_Gallery_PhotoBrowser_HEIC_022
      await Multimedia_Gallery_PhotoBrowser_HEIC_022(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_023', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-相机进大图-不预加载左右图片] TID: Multimedia_Gallery_PhotoBrowser_HEIC_023
      await Multimedia_Gallery_PhotoBrowser_HEIC_023(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_024', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-相机进大图-预加载左边图片] TID: Multimedia_Gallery_PhotoBrowser_HEIC_024
      await Multimedia_Gallery_PhotoBrowser_HEIC_024(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_025', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-相机进大图-预加载右边图片] TID: Multimedia_Gallery_PhotoBrowser_HEIC_025
      await Multimedia_Gallery_PhotoBrowser_HEIC_025(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_026', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-picker进大图-预加载左右图片各一张] TID: Multimedia_Gallery_PhotoBrowser_HEIC_026
      await Multimedia_Gallery_PhotoBrowser_HEIC_026(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_027', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-picker进大图-不预加载左右图片] TID: Multimedia_Gallery_PhotoBrowser_HEIC_027
      await Multimedia_Gallery_PhotoBrowser_HEIC_027(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_028', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-picker进大图-预加载左边图片] TID: Multimedia_Gallery_PhotoBrowser_HEIC_028
      await Multimedia_Gallery_PhotoBrowser_HEIC_028(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_029', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-picker进大图-预加载右边图片] TID: Multimedia_Gallery_PhotoBrowser_HEIC_029
      await Multimedia_Gallery_PhotoBrowser_HEIC_029(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_030', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-动态照片滑动到静态照片-预加载左右图片] TID: Multimedia_Gallery_PhotoBrowser_HEIC_030
      await Multimedia_Gallery_PhotoBrowser_HEIC_030(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_031', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF图片-静态照片滑动到动态照片-预加载左右图片] TID: Multimedia_Gallery_PhotoBrowser_HEIC_031
      await Multimedia_Gallery_PhotoBrowser_HEIC_031(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_032', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [端云hefi格式图片校验] TID: Multimedia_Gallery_PhotoBrowser_HEIC_032
      await Multimedia_Gallery_PhotoBrowser_HEIC_032(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_035', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片编辑后显示] TID: Multimedia_Gallery_PhotoBrowser_HEIC_035
      await Multimedia_Gallery_PhotoBrowser_HEIC_035(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_037', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片xxx同步（5.0和5.1)] TID: Multimedia_Gallery_PhotoBrowser_HEIC_037
      await Multimedia_Gallery_PhotoBrowser_HEIC_037(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_036', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [HEIF格式图片抠图后保存] TID: Multimedia_Gallery_PhotoBrowser_HEIC_036
      await Multimedia_Gallery_PhotoBrowser_HEIC_036(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_039', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片xxx同步] TID: Multimedia_Gallery_PhotoBrowser_HEIC_039
      await Multimedia_Gallery_PhotoBrowser_HEIC_039(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_040', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片xxx克隆（5.0和5.1）] TID: Multimedia_Gallery_PhotoBrowser_HEIC_040
      await Multimedia_Gallery_PhotoBrowser_HEIC_040(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_041', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片xxx克隆（5.1和5.1）] TID: Multimedia_Gallery_PhotoBrowser_HEIC_041
      await Multimedia_Gallery_PhotoBrowser_HEIC_041(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_044', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片xxxxxx手机克隆] TID: Multimedia_Gallery_PhotoBrowser_HEIC_044
      await Multimedia_Gallery_PhotoBrowser_HEIC_044(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_043', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片xxx手机克隆] TID: Multimedia_Gallery_PhotoBrowser_HEIC_043
      await Multimedia_Gallery_PhotoBrowser_HEIC_043(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_042', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片xxx克隆] TID: Multimedia_Gallery_PhotoBrowser_HEIC_042
      await Multimedia_Gallery_PhotoBrowser_HEIC_042(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_047', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片xxx系统分享(5.0和5.1）] TID: Multimedia_Gallery_PhotoBrowser_HEIC_047
      await Multimedia_Gallery_PhotoBrowser_HEIC_047(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_048', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片xxx系统分享(5.1和5.1）] TID: Multimedia_Gallery_PhotoBrowser_HEIC_048
      await Multimedia_Gallery_PhotoBrowser_HEIC_048(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_049', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片xxx系统分享] TID: Multimedia_Gallery_PhotoBrowser_HEIC_049
      await Multimedia_Gallery_PhotoBrowser_HEIC_049(dt);
    });
    run('Multimedia_Gallery_PhotoBrowser_HEIC_050', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片xxx一碰传] TID: Multimedia_Gallery_PhotoBrowser_HEIC_050
      await Multimedia_Gallery_PhotoBrowser_HEIC_050(dt);
    });

    // 退出大图 回到时间线页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllHeicLoaderTest').init();
      await Exit.browser();
      dt.log.i('afterAll HeicLoaderTest finish');
    });
    // 确保每次测试完毕回到大图页
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachHeicLoaderTest').init();
      dt.log.i('afterEach HeicLoaderTest finish');
    });
  });
}

/**
 * 大图-格式: [hefi格式图片手机分享到Verde]
 * TAG: 635 TID: Multimedia_Gallery_PhotoBrowser_HEIC_055
 * 前置条件
 * 1、准备一部xxx手机A和Verde-B
 2、覆盖不同格式的图片（相机拍摄多张照片（依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像），各种不用分辨率的图片，16k以下，16k以上的
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_055(dt: Dt) {
  dt.log.i('hefi格式图片手机分享到Verde start');
  dt.log.i('STEP 1、A上hefi格式，分享到B上');

  await dt.sleep();
  dt.log.i('预期结果1、图片分享成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、B上heif格式图片，分享到A上');

  await dt.sleep();
  dt.log.i('预期结果2、图片分享成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分别在A、B上大图浏览，宫格浏览，大图操作（收藏,，删除，隐藏，添加，分享等），宫格操作（多选删除，隐藏，添加等）');

  await dt.sleep();
  dt.log.i('预期结果3、图片操作无异常，能够正常浏览的操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片手机分享到Verde end');
}

/**
 * 大图-HEIF: [HEIF图片-大图向左滑动-不预加载左边图片]
 * TAG: 636 TID: Multimedia_Gallery_PhotoBrowser_HEIC_019
 * 前置条件
 * 当前停留在图片为HEIC格式的图片
 左边的左边图片为HEIC格式且>=4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_019(dt: Dt) {
  dt.log.i('HEIF图片-大图向左滑动-不预加载左边图片 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep ""submit high request""');

  await dt.sleep();
  dt.log.i('STEP 3、当前大图向左滑动一张');

  await dt.sleep();
  dt.log.i('预期结果3、大图显示清晰,');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、无日志打印：submit high request，{');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-大图向左滑动-不预加载左边图片 end');
}

/**
 * 大图-HEIF: [HEIF图片-大图向右滑动-预加载左边图片]
 * TAG: 637 TID: Multimedia_Gallery_PhotoBrowser_HEIC_020
 * 前置条件
 * 当前停留在图片为HEIC格式的图片
 右边的右边图片为HEIC格式且<4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_020(dt: Dt) {
  dt.log.i('HEIF图片-大图向右滑动-预加载左边图片 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep ""submit high request""');

  await dt.sleep();
  dt.log.i('STEP 3、当前大图向右滑动一张');

  await dt.sleep();
  dt.log.i('预期结果3、图片显示清晰，无长时间加载');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、”3、大图显示清晰,4、有1条日志打印：submit high request，{””desiredSize””:{””width””: c,””height””:d }，显示当前图片右边图片的分辨率”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('3、大图显示清晰,4、有1条日志打印：submit high request，{', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-大图向右滑动-预加载左边图片 end');
}

/**
 * 大图-HEIF: [HEIF图片-大图向右滑动-不预加载左边图片]
 * TAG: 638 TID: Multimedia_Gallery_PhotoBrowser_HEIC_021
 * 前置条件
 * 当前停留在图片为HEIC格式的图片
 右边的右边图片为HEIC格式且>=4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_021(dt: Dt) {
  dt.log.i('HEIF图片-大图向右滑动-不预加载左边图片 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep ""submit high request""');

  await dt.sleep();
  dt.log.i('STEP 3、当前大图向右滑动一张');

  await dt.sleep();
  dt.log.i('预期结果3、大图显示清晰,');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、无日志打印：submit high request，{');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-大图向右滑动-不预加载左边图片 end');
}

/**
 * 大图-HEIF: [HEIF图片-相机进大图-预加载左右图片各一张]
 * TAG: 639 TID: Multimedia_Gallery_PhotoBrowser_HEIC_022
 * 前置条件
 * 当前图片为HEIC格式的图片a
 左右图片为HEIC格式且分辨率<4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_022(dt: Dt) {
  dt.log.i('HEIF图片-相机进大图-预加载左右图片各一张 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep ""submit high request""');

  await dt.sleep();
  dt.log.i('STEP 3、相机打开大图a');

  await dt.sleep();
  dt.log.i('预期结果3、大图显示清晰,');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、有3条日志打印：submit high request，{”desiredSize”:{”width”: c,”height”:d }，分别显示当前图片以及左右图片的分辨率');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-相机进大图-预加载左右图片各一张 end');
}

/**
 * 大图-HEIF: [HEIF图片-相机进大图-不预加载左右图片]
 * TAG: 640 TID: Multimedia_Gallery_PhotoBrowser_HEIC_023
 * 前置条件
 * 当前图片为HEIC格式的图片a
 左右图片为HEIC格式且分辨率>=4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_023(dt: Dt) {
  dt.log.i('HEIF图片-相机进大图-不预加载左右图片 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep ""submit high request""');

  await dt.sleep();
  dt.log.i('STEP 3、相机打开大图a');

  await dt.sleep();
  dt.log.i('预期结果3、大图显示清晰,');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、无日志打印：submit high request，{');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-相机进大图-不预加载左右图片 end');
}

/**
 * 大图-HEIF: [HEIF图片-相机进大图-预加载左边图片]
 * TAG: 641 TID: Multimedia_Gallery_PhotoBrowser_HEIC_024
 * 前置条件
 * 当前图片为HEIC格式的图片a
 左边图片b为HEIC格式且<4.5k*4.5k(乘积），右边图片c为HEIC格式且>4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_024(dt: Dt) {
  dt.log.i('HEIF图片-相机进大图-预加载左边图片 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep ""submit high request""');

  await dt.sleep();
  dt.log.i('STEP 3、相机打开大图a');

  await dt.sleep();
  dt.log.i('预期结果3、大图显示清晰,');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、有2条日志打印：submit high request，{”desiredSize”:{”width”: c,”height”:d }，分别显示当前图片以及左边图片的分辨率');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-相机进大图-预加载左边图片 end');
}

/**
 * 大图-HEIF: [HEIF图片-相机进大图-预加载右边图片]
 * TAG: 642 TID: Multimedia_Gallery_PhotoBrowser_HEIC_025
 * 前置条件
 * 当前图片为HEIC格式的图片a
 左边图片为HEIC格式且>4.5k*4.5k(乘积），右边图片为HEIC格式且<4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_025(dt: Dt) {
  dt.log.i('HEIF图片-相机进大图-预加载右边图片 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep ""submit high request""');

  await dt.sleep();
  dt.log.i('STEP 3、相机打开大图a');

  await dt.sleep();
  dt.log.i('预期结果3、大图显示清晰,');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、有2条日志打印：submit high request，{”desiredSize”:{”width”: c,”height”:d }，分别显示当前图片以及右边图片的分辨率');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-相机进大图-预加载右边图片 end');
}

/**
 * 大图-HEIF: [HEIF图片-picker进大图-预加载左右图片各一张]
 * TAG: 643 TID: Multimedia_Gallery_PhotoBrowser_HEIC_026
 * 前置条件
 * 当前图片为HEIC格式的图片a
 左右图片为HEIC格式且分辨率<4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_026(dt: Dt) {
  dt.log.i('HEIF图片-picker进大图-预加载左右图片各一张 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep ""submit high request""');

  await dt.sleep();
  dt.log.i('STEP 3、picker打开大图a');

  await dt.sleep();
  dt.log.i('预期结果3、大图显示清晰,');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、有3条日志打印：submit high request，{”desiredSize”:{”width”: c,”height”:d }，分别显示当前图片以及左右图片的分辨率');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-picker进大图-预加载左右图片各一张 end');
}

/**
 * 大图-HEIF: [HEIF图片-picker进大图-不预加载左右图片]
 * TAG: 644 TID: Multimedia_Gallery_PhotoBrowser_HEIC_027
 * 前置条件
 * 当前图片为HEIC格式的图片a
 左右图片为HEIC格式且分辨率>=4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_027(dt: Dt) {
  dt.log.i('HEIF图片-picker进大图-不预加载左右图片 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep ""submit high request""');

  await dt.sleep();
  dt.log.i('STEP 3、picker打开大图a');

  await dt.sleep();
  dt.log.i('预期结果3、大图显示清晰,');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、无日志打印：submit high request，');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-picker进大图-不预加载左右图片 end');
}

/**
 * 大图-HEIF: [HEIF图片-picker进大图-预加载左边图片]
 * TAG: 645 TID: Multimedia_Gallery_PhotoBrowser_HEIC_028
 * 前置条件
 * 当前图片为HEIC格式的图片a
 左边图片b为HEIC格式且<4.5k*4.5k(乘积），右边图片c为HEIC格式且>4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_028(dt: Dt) {
  dt.log.i('HEIF图片-picker进大图-预加载左边图片 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep ""submit high request""');

  await dt.sleep();
  dt.log.i('STEP 3、picker打开大图a');

  await dt.sleep();
  dt.log.i('预期结果3、大图显示清晰,');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、有2条日志打印：submit high request，{”desiredSize”:{”width”: c,”height”:d }，分别显示当前图片以及左边图片的分辨率');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-picker进大图-预加载左边图片 end');
}

/**
 * 大图-HEIF: [HEIF图片-picker进大图-预加载右边图片]
 * TAG: 646 TID: Multimedia_Gallery_PhotoBrowser_HEIC_029
 * 前置条件
 * 当前图片为HEIC格式的图片a
 左边图片为HEIC格式且>4.5k*4.5k(乘积），右边图片为HEIC格式且<4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_029(dt: Dt) {
  dt.log.i('HEIF图片-picker进大图-预加载右边图片 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep ""submit high request""');

  await dt.sleep();
  dt.log.i('STEP 3、picker打开大图a');

  await dt.sleep();
  dt.log.i('预期结果3、大图显示清晰,');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、有2条日志打印：submit high request，{”desiredSize”:{”width”: c,”height”:d }，分别显示当前图片以及右边图片的分辨率');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('desiredSize', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-picker进大图-预加载右边图片 end');
}

/**
 * 大图-HEIF: [HEIF图片-动态照片滑动到静态照片-预加载左右图片]
 * TAG: 647 TID: Multimedia_Gallery_PhotoBrowser_HEIC_030
 * 前置条件
 * 当前停留在图片为HEIC格式的动态图片
 左边的左边图片为静态HEIC格式且<4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_030(dt: Dt) {
  dt.log.i('HEIF图片-动态照片滑动到静态照片-预加载左右图片 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep ""submit high request""');

  await dt.sleep();
  dt.log.i('STEP 3、当前大图向左滑动一张');

  await dt.sleep();
  dt.log.i('预期结果3、图片显示清晰，无长时间加载');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、”3、大图显示清晰,4、有1条日志打印：submit high request，{””desiredSize””:{””width””: c,””height””:d }，显示当前图片左边图片的分辨率”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('3、大图显示清晰,4、有1条日志打印：submit high request，{', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-动态照片滑动到静态照片-预加载左右图片 end');
}

/**
 * 大图-HEIF: [HEIF图片-静态照片滑动到动态照片-预加载左右图片]
 * TAG: 648 TID: Multimedia_Gallery_PhotoBrowser_HEIC_031
 * 前置条件
 * 当前停留在图片为HEIC格式的静态图片，左边为动态照片
 左边的左边图片为静态HEIC格式且<4.5k*4.5k(乘积）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_031(dt: Dt) {
  dt.log.i('HEIF图片-静态照片滑动到动态照片-预加载左右图片 start');
  dt.log.i('STEP 1、cmd进入日志查看界面 输入：hdc shell');

  await dt.sleep();
  dt.log.i('STEP 2、过滤日志：hilog | grep ""submit high request""');

  await dt.sleep();
  dt.log.i('STEP 3、当前大图向左滑动一张');

  await dt.sleep();
  dt.log.i('预期结果3、图片显示清晰，无长时间加载');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看日志显示');

  await dt.sleep();
  dt.log.i('预期结果4、”3、大图显示清晰,4、有1条日志打印：submit high request，{””desiredSize””:{””width””: c,””height””:d }，显示当前图片左边图片的分辨率”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('3、大图显示清晰,4、有1条日志打印：submit high request，{', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF图片-静态照片滑动到动态照片-预加载左右图片 end');
}

/**
 * 大图-格式: [端云hefi格式图片校验]
 * TAG: 649 TID: Multimedia_Gallery_PhotoBrowser_HEIC_032
 * 前置条件
 * 预制端云账号，存在heif格式的图片（普通图片，动态照片，云增强后的图片）
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_032(dt: Dt) {
  dt.log.i('端云hefi格式图片校验 start');
  dt.log.i('STEP 1、开启端云同步，端云图片下行成功');

  await dt.sleep();
  dt.log.i('STEP 2、端云hefi格式图片浏览，收藏，删除，分享，隐藏等');

  await dt.sleep();
  dt.log.i('预期结果2、端云hefi格式图片可以正常浏览，大图操作');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击右上角下载按钮');

  await dt.sleep();
  dt.log.i('预期结果3、图片正常下载显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('端云hefi格式图片校验 end');
}

/**
 * 大图-格式: [hefi格式图片编辑后显示]
 * TAG: 652 TID: Multimedia_Gallery_PhotoBrowser_HEIC_035
 * 前置条件
 * 1、相机设置拍摄格式为HEIF，拍摄hefi格式图片
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_035(dt: Dt) {
  dt.log.i('hefi格式图片编辑后显示 start');
  dt.log.i('STEP 1、图片点击编辑');

  await dt.sleep();
  dt.log.i('预期结果1、图片可以正常编辑');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击覆盖原图/另存为');

  await dt.sleep();
  dt.log.i('预期结果2、图片保存成功，新保存图片显示正常，清晰');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片编辑后显示 end');
}

/**
 * 大图-格式: [hefi格式图片xxx同步（5.0和5.1)]
 * TAG: 654 TID: Multimedia_Gallery_PhotoBrowser_HEIC_037
 * 前置条件
 * 1、准备端云账号，有不同的hefi格式图片
 2、准备两台xxx手机,5.1版本手机A，5.0版本手机B
 3、分别登陆云账号
  4、覆盖不同格式的图片（相机拍摄多张照片（依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像），各种不用分辨率的图片，16k以下，16k以上的
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_037(dt: Dt) {
  dt.log.i('hefi格式图片xxx同步（5.0和5.1) start');
  dt.log.i('STEP 1、A手机上hefi格式，通过端云同步到B手机上');

  await dt.sleep();
  dt.log.i('预期结果1、图片同步成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、B手机上heif格式图片，通过端云同步到A手机上');

  await dt.sleep();
  dt.log.i('预期结果2、图片同步成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分别在A、B手机上大图浏览，宫格浏览，大图操作（收藏,，删除，隐藏，添加，分享等），宫格操作（多选删除，隐藏，添加等）');

  await dt.sleep();
  dt.log.i('预期结果3、图片操作无异常，能够正常浏览的操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片xxx同步（5.0和5.1) end');
}

/**
 * 大图-HEIF: [HEIF格式图片抠图后保存]
 * TAG: 655 TID: Multimedia_Gallery_PhotoBrowser_HEIC_036
 * 前置条件
 * 1、相机设置拍摄格式为HEIF，拍摄带主体的hefi格式图片
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_036(dt: Dt) {
  dt.log.i('HEIF格式图片抠图后保存 start');
  dt.log.i('STEP 1、图片长按触发抠图');

  await dt.sleep();
  dt.log.i('预期结果1、成功触发抠图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击分享保存到图库');

  await dt.sleep();
  dt.log.i('预期结果2、图片保存成功，显示png格式，显示清晰');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('HEIF格式图片抠图后保存 end');
}

/**
 * 大图-格式: [hefi格式图片xxx同步]
 * TAG: 656 TID: Multimedia_Gallery_PhotoBrowser_HEIC_039
 * 前置条件
 * 1、准备端云账号，有不同的hefi格式图片
 2、准备两台手机,xxxA，xxx手机B
 3、分别登陆云账号
  4、覆盖不同格式的图片（相机拍摄多张照片（依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像），各种不用分辨率的图片，16k以下，16k以上的
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_039(dt: Dt) {
  dt.log.i('hefi格式图片xxx同步 start');
  dt.log.i('STEP 1、A手机上hefi格式，通过端云同步到B手机上');

  await dt.sleep();
  dt.log.i('预期结果1、图片同步成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、B手机上heif格式图片，通过端云同步到A手机上');

  await dt.sleep();
  dt.log.i('预期结果2、图片同步成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分别在A、B手机上大图浏览，宫格浏览，大图操作（收藏,，删除，隐藏，添加，分享等），宫格操作（多选删除，隐藏，添加等）');

  await dt.sleep();
  dt.log.i('预期结果3、图片操作无异常，能够正常浏览的操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片xxx同步 end');
}

/**
 * 大图-格式: [hefi格式图片xxx克隆（5.0和5.1）]
 * TAG: 657 TID: Multimedia_Gallery_PhotoBrowser_HEIC_040
 * 前置条件
 *
 1、准备两台xxx手机,5.1版本手机A，5.0版本手机B
 2、覆盖不同格式的图片（相机拍摄多张照片（依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像），各种不用分辨率的图片，16k以下，16k以上的

 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_040(dt: Dt) {
  dt.log.i('hefi格式图片xxx克隆（5.0和5.1） start');
  dt.log.i('STEP 1、A手机上hefi格式，克隆到B手机上');

  await dt.sleep();
  dt.log.i('预期结果1、图片克隆成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、B手机上heif格式图片，克隆到A手机上');

  await dt.sleep();
  dt.log.i('预期结果2、图片克隆成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分别在A、B手机上大图浏览，宫格浏览，大图操作（收藏,，删除，隐藏，添加，分享等），宫格操作（多选删除，隐藏，添加等）');

  await dt.sleep();
  dt.log.i('预期结果3、图片操作无异常，能够正常浏览的操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片xxx克隆（5.0和5.1） end');
}

/**
 * 大图-格式: [hefi格式图片xxx克隆（5.1和5.1）]
 * TAG: 658 TID: Multimedia_Gallery_PhotoBrowser_HEIC_041
 * 前置条件
 *
 1、准备两台手机，,xxx手机A，B
 2、覆盖不同格式的图片（相机拍摄多张照片（依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像），各种不用分辨率的图片，16k以下，16k以上的

 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_041(dt: Dt) {
  dt.log.i('hefi格式图片xxx克隆（5.1和5.1） start');
  dt.log.i('STEP 1、A手机上hefi格式，克隆到B手机上');

  await dt.sleep();
  dt.log.i('预期结果1、图片克隆成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、B手机上heif格式图片，克隆到A手机上');

  await dt.sleep();
  dt.log.i('预期结果2、图片克隆成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分别在A、B手机上大图浏览，宫格浏览，大图操作（收藏,，删除，隐藏，添加，分享等），宫格操作（多选删除，隐藏，添加等）');

  await dt.sleep();
  dt.log.i('预期结果3、图片操作无异常，能够正常浏览的操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片xxx克隆（5.1和5.1） end');
}

/**
 * 大图-格式: [hefi格式图片xxxxxx手机克隆]
 * TAG: 659 TID: Multimedia_Gallery_PhotoBrowser_HEIC_044
 * 前置条件
 * 1、准备两台手机,xxxA，xxx手机B
 2、覆盖不同格式的图片（相机拍摄多张照片（依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像），各种不用分辨率的图片，16k以下，16k以上的
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_044(dt: Dt) {
  dt.log.i('hefi格式图片xxxxxx手机克隆 start');
  dt.log.i('STEP 1、A手机上hefi格式图片，克隆到B手机上');

  await dt.sleep();
  dt.log.i('预期结果1、图片克隆成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、B手机上heif格式图片，克隆到A手机上');

  await dt.sleep();
  dt.log.i('预期结果2、图片克隆成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分别在A、B手机上大图浏览，宫格浏览，大图操作（收藏,，删除，隐藏，添加，分享等），宫格操作（多选删除，隐藏，添加等）');

  await dt.sleep();
  dt.log.i('预期结果3、图片操作无异常，能够正常浏览的操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片xxxxxx手机克隆 end');
}

/**
 * 大图-格式: [hefi格式图片xxx手机克隆]
 * TAG: 660 TID: Multimedia_Gallery_PhotoBrowser_HEIC_043
 * 前置条件
 * 1、准备两台手机,xxxA，手机B
 2、覆盖不同格式的图片（相机拍摄多张照片（依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像），各种不用分辨率的图片，16k以下，16k以上的
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_043(dt: Dt) {
  dt.log.i('hefi格式图片xxx手机克隆 start');
  dt.log.i('STEP 1、A手机上hefi格式图片，克隆到B手机上');

  await dt.sleep();
  dt.log.i('预期结果1、图片克隆成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、B手机上heif格式图片，克隆到A手机上');

  await dt.sleep();
  dt.log.i('预期结果2、图片克隆成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分别在A、B手机上大图浏览，宫格浏览，大图操作（收藏,，删除，隐藏，添加，分享等），宫格操作（多选删除，隐藏，添加等）');

  await dt.sleep();
  dt.log.i('预期结果3、图片操作无异常，能够正常浏览的操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片xxx手机克隆 end');
}

/**
 * 大图-格式: [hefi格式图片xxx克隆]
 * TAG: 661 TID: Multimedia_Gallery_PhotoBrowser_HEIC_042
 * 前置条件
 *
 1、准备两台手机,xxxA，xxx手机B
 2、覆盖不同格式的图片（相机拍摄多张照片（依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像），各种不用分辨率的图片，16k以下，16k以上的
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_042(dt: Dt) {
  dt.log.i('hefi格式图片xxx克隆 start');
  dt.log.i('STEP 1、A手机上hefi格式，克隆到B手机上');

  await dt.sleep();
  dt.log.i('预期结果1、图片克隆成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、B手机上heif格式图片，克隆到A手机上');

  await dt.sleep();
  dt.log.i('预期结果2、图片克隆成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分别在A、B手机上大图浏览，宫格浏览，大图操作（收藏,，删除，隐藏，添加，分享等），宫格操作（多选删除，隐藏，添加等）');

  await dt.sleep();
  dt.log.i('预期结果3、图片操作无异常，能够正常浏览的操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片xxx克隆 end');
}

/**
 * 大图-格式: [hefi格式图片xxx系统分享(5.0和5.1）]
 * TAG: 662 TID: Multimedia_Gallery_PhotoBrowser_HEIC_047
 * 前置条件
 *
 1、准备两台xxx架手机,5.1版本手机A，5.0版本手机B
 2、覆盖不同格式的图片（相机拍摄多张照片（依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像），各种不用分辨率的图片，16k以下，16k以上的

 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_047(dt: Dt) {
  dt.log.i('hefi格式图片xxx系统分享(5.0和5.1） start');
  dt.log.i('STEP 1、A手机上hefi格式，分享到B手机上');

  await dt.sleep();
  dt.log.i('预期结果1、图片分享成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、B手机上heif格式图片，分享到A手机上');

  await dt.sleep();
  dt.log.i('预期结果2、图片分享成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分别在A、B手机上大图浏览，宫格浏览，大图操作（收藏,，删除，隐藏，添加，分享等），宫格操作（多选删除，隐藏，添加等）');

  await dt.sleep();
  dt.log.i('预期结果3、图片操作无异常，能够正常浏览的操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片xxx系统分享(5.0和5.1） end');
}

/**
 * 大图-格式: [hefi格式图片xxx系统分享(5.1和5.1）]
 * TAG: 663 TID: Multimedia_Gallery_PhotoBrowser_HEIC_048
 * 前置条件
 *
 1、准备两台手机，,xxx手机A，B
 2、覆盖不同格式的图片（相机拍摄多张照片（依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像），各种不用分辨率的图片，16k以下，16k以上的

 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_048(dt: Dt) {
  dt.log.i('hefi格式图片xxx系统分享(5.1和5.1） start');
  dt.log.i('STEP 1、A手机上hefi格式，分享到B手机上');

  await dt.sleep();
  dt.log.i('预期结果1、图片分享成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、B手机上heif格式图片，分享到A手机上');

  await dt.sleep();
  dt.log.i('预期结果2、图片分享成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分别在A、B手机上大图浏览，宫格浏览，大图操作（收藏,，删除，隐藏，添加，分享等），宫格操作（多选删除，隐藏，添加等）');

  await dt.sleep();
  dt.log.i('预期结果3、图片操作无异常，能够正常浏览的操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片xxx系统分享(5.1和5.1） end');
}

/**
 * 大图-格式: [hefi格式图片xxx系统分享]
 * TAG: 664 TID: Multimedia_Gallery_PhotoBrowser_HEIC_049
 * 前置条件
 *
 1、准备两台手机,xxxA，xxx手机B
 2、覆盖不同格式的图片（相机拍摄多张照片（依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像），各种不用分辨率的图片，16k以下，16k以上的

 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_049(dt: Dt) {
  dt.log.i('hefi格式图片xxx系统分享 start');
  dt.log.i('STEP 1、A手机上hefi格式，分享到B手机上');

  await dt.sleep();
  dt.log.i('预期结果1、图片分享成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、B手机上heif格式图片，分享到A手机上');

  await dt.sleep();
  dt.log.i('预期结果2、图片分享成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分别在A、B手机上大图浏览，宫格浏览，大图操作（收藏,，删除，隐藏，添加，分享等），宫格操作（多选删除，隐藏，添加等）');

  await dt.sleep();
  dt.log.i('预期结果3、图片操作无异常，能够正常浏览的操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片xxx系统分享 end');
}

/**
 * 大图-格式: [hefi格式图片xxx一碰传]
 * TAG: 665 TID: Multimedia_Gallery_PhotoBrowser_HEIC_050
 * 前置条件
 *
 1、准备两台手机，,xxx手机A，B
 2、覆盖不同格式的图片（相机拍摄多张照片（依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像），各种不用分辨率的图片，16k以下，16k以上的

 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_050(dt: Dt) {
  dt.log.i('hefi格式图片xxx一碰传 start');
  dt.log.i('STEP 1、A手机上hefi格式，分享到B手机上');

  await dt.sleep();
  dt.log.i('预期结果1、图片分享成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、B手机上heif格式图片，分享到A手机上');

  await dt.sleep();
  dt.log.i('预期结果2、图片分享成功，图片和格式显示正常，清晰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分别在A、B手机上大图浏览，宫格浏览，大图操作（收藏,，删除，隐藏，添加，分享等），宫格操作（多选删除，隐藏，添加等）');

  await dt.sleep();
  dt.log.i('预期结果3、图片操作无异常，能够正常浏览的操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('hefi格式图片xxx一碰传 end');
}

