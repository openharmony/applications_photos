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

export default function MultimediaGalleryFilesmoves(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryFilesmovesTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryFilesmoves').init();
      dt.log.i('beforeAll MultimediaGalleryFilesmoves start');
      dt.log.i('beforeAll MultimediaGalleryFilesmoves finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryFilesmoves', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryFilesmoves005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [相册页视频相册内宫格页移动至目标相册，界面检查] TID: Multimedia_Gallery_Files_moves_005
      await multimediaGalleryFilesmoves005(dt);
    });
    run('MultimediaGalleryFilesmoves006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [相册页视频相册内大图移动至目标相册，界面检查] TID: Multimedia_Gallery_Files_moves_006
      await multimediaGalleryFilesmoves006(dt);
    });
    run('MultimediaGalleryFilesmoves007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [相册页收藏相册内宫格页移动至目标相册，界面检查] TID: Multimedia_Gallery_Files_moves_007
      await multimediaGalleryFilesmoves007(dt);
    });
    run('MultimediaGalleryFilesmoves008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [相册页收藏相册内大图移动至目标相册，界面检查] TID: Multimedia_Gallery_Files_moves_008
      await multimediaGalleryFilesmoves008(dt);
    });
    run('MultimediaGalleryFilesmoves009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-连拍用例: [相册页用户相册内宫格页移动至目标相册，界面检查] TID: Multimedia_Gallery_Files_moves_009
      await multimediaGalleryFilesmoves009(dt);
    });
    run('MultimediaGalleryFilesmoves010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [相册页用户相册内大图移动至目标相册，界面检查] TID: Multimedia_Gallery_Files_moves_010
      await multimediaGalleryFilesmoves010(dt);
    });
    run('MultimediaGalleryFilesmoves011', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-连拍用例: [智慧相册内宫格页移动至目标相册，界面检查] TID: Multimedia_Gallery_Files_moves_011
      await multimediaGalleryFilesmoves011(dt);
    });
    run('MultimediaGalleryFilesmoves012', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [智慧相册内大图移动至目标相册，界面检查] TID: Multimedia_Gallery_Files_moves_012
      await multimediaGalleryFilesmoves012(dt);
    });
    run('MultimediaGalleryFilesmoves013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-连拍用例: [相册页来源相册内宫格页移动至目标相册] TID: Multimedia_Gallery_Files_moves_013
      await multimediaGalleryFilesmoves013(dt);
    });
    run('MultimediaGalleryFilesmoves014', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [相册页来源相册内大图移动至目标相册] TID: Multimedia_Gallery_Files_moves_014
      await multimediaGalleryFilesmoves014(dt);
    });
    run('MultimediaGalleryFilesmoves015', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-连拍用例: [重复文件移动至目标相册，替换后界面检查] TID: Multimedia_Gallery_Files_moves_015
      await multimediaGalleryFilesmoves015(dt);
    });
    run('MultimediaGalleryFilesmoves016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-连拍用例: [重复文件移动至目标相册，跳过后界面检查] TID: Multimedia_Gallery_Files_moves_016
      await multimediaGalleryFilesmoves016(dt);
    });
    run('MultimediaGalleryFilesmoves017', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-连拍用例: [重名文件移动至目标相册界面检查] TID: Multimedia_Gallery_Files_moves_017
      await multimediaGalleryFilesmoves017(dt);
    });
    run('MultimediaGalleryFilesmoves018', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-连拍用例: [取消文件移动至目标相册，界面检查] TID: Multimedia_Gallery_Files_moves_018
      await multimediaGalleryFilesmoves018(dt);
    });
    run('MultimediaGalleryFilesmoves019', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-连拍用例: [对所有重复文件，勾选后续文件执行相应操作后的界面检查] TID: Multimedia_Gallery_Files_moves_019
      await multimediaGalleryFilesmoves019(dt);
    });
    run('MultimediaGalleryFilesmoves020', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-连拍用例: [文件移动至新建空相册，界面检查] TID: Multimedia_Gallery_Files_moves_020
      await multimediaGalleryFilesmoves020(dt);
    });
    run('MultimediaGalleryFilesmoves021', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-连拍用例: [移动时杀死图库进程，移动前后界面检查] TID: Multimedia_Gallery_Files_moves_021
      await multimediaGalleryFilesmoves021(dt);
    });
    run('MultimediaGalleryFilesmoves022', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-连拍用例: [存在重复图片，移动时杀死图库进程，移动前后界面检查] TID: Multimedia_Gallery_Files_moves_022
      await multimediaGalleryFilesmoves022(dt);
    });
    run('MultimediaGalleryFilesmoves023', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-进度条用例: [大数据量文件，移动时进度条显示界面检查] TID: Multimedia_Gallery_Files_moves_023
      await multimediaGalleryFilesmoves023(dt);
    });
    run('MultimediaGalleryFilesmoves024', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-连拍用例: [大数据量文件，取消移动，界面检查] TID: Multimedia_Gallery_Files_moves_024
      await multimediaGalleryFilesmoves024(dt);
    });
    run('MultimediaGalleryFilesmoves025', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [收藏文件移动至目标相册后取消收藏，界面检查] TID: Multimedia_Gallery_Files_moves_025
      await multimediaGalleryFilesmoves025(dt);
    });
    run('MultimediaGalleryFilesmoves026', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [文件移动至目标相册后点击收藏，界面检查] TID: Multimedia_Gallery_Files_moves_026
      await multimediaGalleryFilesmoves026(dt);
    });
    run('MultimediaGalleryFilesmoves027', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [开启多语言后的界面检查] TID: Multimedia_Gallery_Files_moves_027
      await multimediaGalleryFilesmoves027(dt);
    });
    run('MultimediaGalleryFilesmoves028', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-下载用例: [a、b手机均完成云同步后再关闭云同步，a手机将文件c移动至A相册，b手机将相同文件c移动至B相册，a、b手机先后开云，对文件c移动到的相册界面检查] TID: Multimedia_Gallery_Files_moves_028
      await multimediaGalleryFilesmoves028(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryFilesmoves').init();
      dt.log.i('afterEach MultimediaGalleryFilesmoves start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryFilesmoves finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryFilesmoves').init();
      dt.log.i('afterAll MultimediaGalleryFilesmoves start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryFilesmoves finish');
    });
  });
}

// DT步骤
/**
 * 宫格-视频: [相册页视频相册内宫格页移动至目标相册，界面检查]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Files_moves_005
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制目标相册
 */
async function multimediaGalleryFilesmoves005(dt: Dt) {
  dt.log.i('相册页视频相册内宫格页移动至目标相册，界面检查 start');
  dt.log.i('STEP 1.进入图库相册页，进入【视频】相册');

  await dt.sleep();
  dt.log.i('预期结果1.所选文件进入目标相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击【视频】相册页面右上角多选图标，选择视频');

  await dt.sleep();
  dt.log.i('预期结果2.所选文件在【视频】相册数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击页面右下角更多图标，选择移动到选项');

  await dt.sleep();
  dt.log.i('预期结果3.所选文件在图片宫格页数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.进入目标相册选择界面，选择目标相册');

  await dt.sleep();
  dt.log.i('预期结果4.横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页视频相册内宫格页移动至目标相册，界面检查 end');
}

/**
 * 宫格-视频: [相册页视频相册内大图移动至目标相册，界面检查]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Files_moves_006
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制目标相册
 */
async function multimediaGalleryFilesmoves006(dt: Dt) {
  dt.log.i('相册页视频相册内大图移动至目标相册，界面检查 start');
  dt.log.i('STEP 1.进入图库相册页，进入【视频】相册');

  await dt.sleep();
  dt.log.i('预期结果1.所选文件进入目标相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击进入视频后点击视频右上角多选图标，选择移动到选项');

  await dt.sleep();
  dt.log.i('预期结果2.所选文件在【视频】相册数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.进入目标相册选择界面，选择目标相册');

  await dt.sleep();
  dt.log.i('预期结果3.所选文件在图片宫格页数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果4.横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页视频相册内大图移动至目标相册，界面检查 end');
}

/**
 * 宫格-收藏: [相册页收藏相册内宫格页移动至目标相册，界面检查]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Files_moves_007
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等收藏文件
 3.手机内预制目标相册
 */
async function multimediaGalleryFilesmoves007(dt: Dt) {
  dt.log.i('相册页收藏相册内宫格页移动至目标相册，界面检查 start');
  dt.log.i('STEP 1.进入图库相册页，进入【我的收藏】相册 ');

  await dt.sleep();
  dt.log.i('STEP 2.点击【我的收藏】相册页面右上角多选图标，选择文件 ');

  await dt.sleep();
  dt.log.i('预期结果2.页面上显示选择文件数量增加 4.目标相册文件数量增加5.横屏状态下显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击页面右下角更多图标，选择移动到选项 ');

  await dt.sleep();
  dt.log.i('STEP 4.进入目标相册选择界面，选择目标相册 ');

  await dt.sleep();
  dt.log.i('预期结果4.目标相册文件数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果5.横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页收藏相册内宫格页移动至目标相册，界面检查 end');
}

/**
 * 宫格-收藏: [相册页收藏相册内大图移动至目标相册，界面检查]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Files_moves_008
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等收藏文件
 3.手机内预制目标相册
 */
async function multimediaGalleryFilesmoves008(dt: Dt) {
  dt.log.i('相册页收藏相册内大图移动至目标相册，界面检查 start');
  dt.log.i('STEP 1.进入图库相册页，进入【我的收藏】相册 ');

  await dt.sleep();
  dt.log.i('STEP 2.点击【我的收藏】相册页面内任意图片，进入大图模式 ');

  await dt.sleep();
  dt.log.i('STEP 3.点击页面右上角更多图标，选择移动到选项 ');

  await dt.sleep();
  dt.log.i('STEP 4.进入目标相册选择界面，选择目标相册 ');

  await dt.sleep();
  dt.log.i('预期结果4.目标相册文件数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果5.横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页收藏相册内大图移动至目标相册，界面检查 end');
}

/**
 * 宫格-连拍: [相册页用户相册内宫格页移动至目标相册，界面检查]
 * GROUP: 宫格 MODULE: 连拍TID: Multimedia_Gallery_Files_moves_009
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内存在用户自建相册
 4.手机内预制目标相册
 */
async function multimediaGalleryFilesmoves009(dt: Dt) {
  dt.log.i('相册页用户相册内宫格页移动至目标相册，界面检查 start');
  dt.log.i('STEP 1.进入图库相册页，进入用户自建相册');

  await dt.sleep();
  dt.log.i('预期结果1.所选文件进入目标相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击相册页面右上角多选图标，选择文件');

  await dt.sleep();
  dt.log.i('预期结果2.所选文件在用户自建相册数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击页面右下角更多图标，选择移动到选项');

  await dt.sleep();
  dt.log.i('预期结果3.所选文件在图片宫格页数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.进入目标相册选择界面，选择目标相册');

  await dt.sleep();
  dt.log.i('预期结果4.横屏状态下显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.横屏状态下界面检查');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页用户相册内宫格页移动至目标相册，界面检查 end');
}

/**
 * 宫格-大图: [相册页用户相册内大图移动至目标相册，界面检查]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Files_moves_010
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内存在用户自建相册
 4.手机内预制目标相册
 */
async function multimediaGalleryFilesmoves010(dt: Dt) {
  dt.log.i('相册页用户相册内大图移动至目标相册，界面检查 start');
  dt.log.i('STEP 1.进入图库相册页，进入用户自建相册');

  await dt.sleep();
  dt.log.i('预期结果1.所选文件进入目标相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击文件后，点击右上角更多图标，选择移动到选项');

  await dt.sleep();
  dt.log.i('预期结果2.所选文件在用户自建相册数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.进入目标相册选择界面，选择目标相册');

  await dt.sleep();
  dt.log.i('预期结果3.所选文件在图片宫格页数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果4.横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页用户相册内大图移动至目标相册，界面检查 end');
}

/**
 * 宫格-连拍: [智慧相册内宫格页移动至目标相册，界面检查]
 * GROUP: 宫格 MODULE: 连拍TID: Multimedia_Gallery_Files_moves_011
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.文件完成智慧分析且有智慧分析相册
 4.手机内预制目标相册
 */
async function multimediaGalleryFilesmoves011(dt: Dt) {
  dt.log.i('智慧相册内宫格页移动至目标相册，界面检查 start');
  dt.log.i('STEP 1.进入图库相册页，进入智慧分析相册');

  await dt.sleep();
  dt.log.i('STEP 2.点击相册页面右上角多选图标，选择文件');

  await dt.sleep();
  dt.log.i('STEP 3.点击页面右下角更多图标，选择移动到选项');

  await dt.sleep();
  dt.log.i('STEP 4.进入目标相册选择界面，选择目标相册');

  await dt.sleep();
  dt.log.i('预期结果4.所选文件进入目标相册，相册图片数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果5.横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧相册内宫格页移动至目标相册，界面检查 end');
}

/**
 * 宫格-大图: [智慧相册内大图移动至目标相册，界面检查]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Files_moves_012
 * 前置条件
 * 1、准备一台xxx手机
 2、手机内预制图片/视频/动态照片/连拍照片等文件
 3、文件完成智慧分析且有智慧分析相册
 4、手机内预制目标相册
 */
async function multimediaGalleryFilesmoves012(dt: Dt) {
  dt.log.i('智慧相册内大图移动至目标相册，界面检查 start');
  dt.log.i('STEP 1、进入图库相册页，进入智慧分析相册');

  await dt.sleep();
  dt.log.i('STEP 2、点击文件后，点击右上角更多图标，选择移动到选项');

  await dt.sleep();
  dt.log.i('预期结果2、所选文件进入目标相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、移动成功后，观察被选择的文件是否还在原来的智慧相册中');

  await dt.sleep();
  dt.log.i('预期结果3、文件归属的智慧分类未改变，仍显示在原智慧相册中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、观察文件所处的相册位置');

  await dt.sleep();
  dt.log.i('预期结果4、从相册页看，文件从原用户创建相册/来源相册，被移动到目标相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、进入目标相册选择界面，选择目标相册');

  await dt.sleep();
  dt.log.i('预期结果5、所选文件在图片宫格页数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果6、横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧相册内大图移动至目标相册，界面检查 end');
}

/**
 * 宫格-连拍: [相册页来源相册内宫格页移动至目标相册]
 * GROUP: 宫格 MODULE: 连拍TID: Multimedia_Gallery_Files_moves_013
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制目标相册
 */
async function multimediaGalleryFilesmoves013(dt: Dt) {
  dt.log.i('相册页来源相册内宫格页移动至目标相册 start');
  dt.log.i('STEP 1.进入图库相册页，进入来源相册');

  await dt.sleep();
  dt.log.i('STEP 2.点击相册页面右上角多选图标，选择文件');

  await dt.sleep();
  dt.log.i('预期结果2.页面上显示选择文件数量增加 4.目标相册文件数量增加5.横屏状态下显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击页面右下角更多图标，选择移动到选项');

  await dt.sleep();
  dt.log.i('STEP 4.进入目标相册选择界面，选择目标相册');

  await dt.sleep();
  dt.log.i('预期结果4.目标相册文件数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果5.横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页来源相册内宫格页移动至目标相册 end');
}

/**
 * 宫格-大图: [相册页来源相册内大图移动至目标相册]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Files_moves_014
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制目标相册
 */
async function multimediaGalleryFilesmoves014(dt: Dt) {
  dt.log.i('相册页来源相册内大图移动至目标相册 start');
  dt.log.i('STEP 1.进入图库相册页，进入来源相册');

  await dt.sleep();
  dt.log.i('STEP 2.点击文件后，点击右上角更多图标，选择移动到选项');

  await dt.sleep();
  dt.log.i('STEP 3.进入目标相册选择界面，选择目标相册');

  await dt.sleep();
  dt.log.i('预期结果3.目标相册文件数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果4.横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页来源相册内大图移动至目标相册 end');
}

/**
 * 宫格-连拍: [重复文件移动至目标相册，替换后界面检查]
 * GROUP: 宫格 MODULE: 连拍TID: Multimedia_Gallery_Files_moves_015
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制来自从iPhone克隆的照片
 4.手机内预制原相册、目标相册，存在相同文件a

 */
async function multimediaGalleryFilesmoves015(dt: Dt) {
  dt.log.i('重复文件移动至目标相册，替换后界面检查 start');
  dt.log.i('STEP 1、在系统相册（图片、视频、我的收藏）中将图片a移动到目标相册');

  await dt.sleep();
  dt.log.i('STEP 2、出现弹窗，选择“替换为新文件”');

  await dt.sleep();
  dt.log.i('预期结果2、弹窗消失，目标相册中存在文件a，有且仅存在一份，原相册是系统相册的场景，原相册内的文件a不会消失，仍存在');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果3、横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('重复文件移动至目标相册，替换后界面检查 end');
}

/**
 * 宫格-连拍: [重复文件移动至目标相册，跳过后界面检查]
 * GROUP: 宫格 MODULE: 连拍TID: Multimedia_Gallery_Files_moves_016
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制原相册、目标相册，存在相同文件a

 */
async function multimediaGalleryFilesmoves016(dt: Dt) {
  dt.log.i('重复文件移动至目标相册，跳过后界面检查 start');
  dt.log.i('STEP 1、在系统相册（图片、视频、我的收藏）中将图片a移动到目标相册');

  await dt.sleep();
  dt.log.i('STEP 2、出现弹窗，选择“跳过当前文件”');

  await dt.sleep();
  dt.log.i('预期结果2、弹窗消失，取消文件a的移动操作，目标相册中文件a无变化');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果3、横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('重复文件移动至目标相册，跳过后界面检查 end');
}

/**
 * 宫格-连拍: [重名文件移动至目标相册界面检查]
 * GROUP: 宫格 MODULE: 连拍TID: Multimedia_Gallery_Files_moves_017
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制目标相册，存在文件a
 4.相机相册新拍一张图片，重命名为文件a
 */
async function multimediaGalleryFilesmoves017(dt: Dt) {
  dt.log.i('重名文件移动至目标相册界面检查 start');
  dt.log.i('STEP 1、在系统相册（图片、视频、我的收藏）中将文件a移动到目标相册');

  await dt.sleep();
  dt.log.i('预期结果1、没有弹窗提示，图片成功移动，在图片名称的最后添加尾缀【_xxx】(xxx为系统中当前时间戳)3、横屏状态下显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果3、横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('重名文件移动至目标相册界面检查 end');
}

/**
 * 宫格-连拍: [取消文件移动至目标相册，界面检查]
 * GROUP: 宫格 MODULE: 连拍TID: Multimedia_Gallery_Files_moves_018
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制原相册、目标相册，存在相同文件a

 */
async function multimediaGalleryFilesmoves018(dt: Dt) {
  dt.log.i('取消文件移动至目标相册，界面检查 start');
  dt.log.i('STEP 1、在系统相册（图片、视频、我的收藏）中将图片a移动到目标相册');

  await dt.sleep();
  dt.log.i('STEP 2、出现弹窗，选择“跳过当前文件”');

  await dt.sleep();
  dt.log.i('预期结果2、弹窗消失，目标相册中存在文件a。原相册中也存在文件a');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果3、横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('取消文件移动至目标相册，界面检查 end');
}

/**
 * 宫格-连拍: [对所有重复文件，勾选后续文件执行相应操作后的界面检查]
 * GROUP: 宫格 MODULE: 连拍TID: Multimedia_Gallery_Files_moves_019
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制原相册、目标相册，存在相同文件100张

 */
async function multimediaGalleryFilesmoves019(dt: Dt) {
  dt.log.i('对所有重复文件，勾选后续文件执行相应操作后的界面检查 start');
  dt.log.i('STEP 1、在系统相册（图片、视频、我的收藏）中将重复文件移动到目标相册');

  await dt.sleep();
  dt.log.i('STEP 2、出现弹窗，勾选“后续文件执行相应操作”，选择“替换为新文件”');

  await dt.sleep();
  dt.log.i('预期结果2、弹窗消失，出现移动进度条，目标相册中存在对应重复文件，原相册中的重复文件消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果3、横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('对所有重复文件，勾选后续文件执行相应操作后的界面检查 end');
}

/**
 * 宫格-连拍: [文件移动至新建空相册，界面检查]
 * GROUP: 宫格 MODULE: 连拍TID: Multimedia_Gallery_Files_moves_020
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制原相册，存在文件100张

 */
async function multimediaGalleryFilesmoves020(dt: Dt) {
  dt.log.i('文件移动至新建空相册，界面检查 start');
  dt.log.i('STEP 1、手机新建空相册，将原相册中的文件移动到空相册中');

  await dt.sleep();
  dt.log.i('预期结果1、文件成功移动到新建的空相册中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果2、横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('文件移动至新建空相册，界面检查 end');
}

/**
 * 宫格-连拍: [移动时杀死图库进程，移动前后界面检查]
 * GROUP: 宫格 MODULE: 连拍TID: Multimedia_Gallery_Files_moves_021
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制原相册，存在文件10000张

 */
async function multimediaGalleryFilesmoves021(dt: Dt) {
  dt.log.i('移动时杀死图库进程，移动前后界面检查 start');
  dt.log.i('STEP 1、手机新建空相册，将原相册中的文件移动到空相册中');

  await dt.sleep();
  dt.log.i('STEP 2、在移动过程中杀死图库进程，再次进入图库');

  await dt.sleep();
  dt.log.i('预期结果2、文件成功移动到目标相册中');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果3、横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('移动时杀死图库进程，移动前后界面检查 end');
}

/**
 * 宫格-连拍: [存在重复图片，移动时杀死图库进程，移动前后界面检查]
 * GROUP: 宫格 MODULE: 连拍TID: Multimedia_Gallery_Files_moves_022
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制原相册，存在文件10000张，其中2000文件同时存在于目标相册中
 */
async function multimediaGalleryFilesmoves022(dt: Dt) {
  dt.log.i('存在重复图片，移动时杀死图库进程，移动前后界面检查 start');
  dt.log.i('STEP 1、将原相册中的文件移动到目标中');

  await dt.sleep();
  dt.log.i('STEP 2、在弹出【发现重名文件】前杀死图库进程，再次进入图库');

  await dt.sleep();
  dt.log.i('预期结果2、进入图库后，原相册与目标相册中文件总数与移动前原相册中文件数量一致');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次进行移动，出现【发现重名文件】后选择【替换为新文件】，杀死图库进程，再次进入图库');

  await dt.sleep();
  dt.log.i('预期结果3、进入图库后，目标相册中的文件与原相册中文件数量一致');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果4、横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('存在重复图片，移动时杀死图库进程，移动前后界面检查 end');
}

/**
 * 宫格-进度条: [大数据量文件，移动时进度条显示界面检查]
 * GROUP: 宫格 MODULE: 进度条TID: Multimedia_Gallery_Files_moves_023
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制原相册，存在文件10000张

 */
async function multimediaGalleryFilesmoves023(dt: Dt) {
  dt.log.i('大数据量文件，移动时进度条显示界面检查 start');
  dt.log.i('STEP 1、将文件从原相册中移动到目标相册，查看图库界面');

  await dt.sleep();
  dt.log.i('预期结果1、出现移动的进度条，进度条根据移动进度实时显示，显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果2、横屏状态下显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大数据量文件，移动时进度条显示界面检查 end');
}

/**
 * 宫格-连拍: [大数据量文件，取消移动，界面检查]
 * GROUP: 宫格 MODULE: 连拍TID: Multimedia_Gallery_Files_moves_024
 * 前置条件
 * 1.准备一台xxx手机
 2.手机内预制图片/视频/动态照片/连拍照片等文件
 3.手机内预制原相册，存在文件10000张

 */
async function multimediaGalleryFilesmoves024(dt: Dt) {
  dt.log.i('大数据量文件，取消移动，界面检查 start');
  dt.log.i('STEP 1、将文件从原相册中移动到目标相册，查看图库界面');

  await dt.sleep();
  dt.log.i('预期结果1、出现移动的进度条，进度条根据移动进度实时显示，显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、移动过程中，点击【取消移动】');

  await dt.sleep();
  dt.log.i('预期结果2、取消移动后，进度条消失，已经移动的文件显示在目标相册中，未移动的文件显示在原相册中，两个相册内文件数量之和=100002、横屏状态下显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横屏状态下界面检查');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大数据量文件，取消移动，界面检查 end');
}

/**
 * 宫格-收藏: [收藏文件移动至目标相册后取消收藏，界面检查]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Files_moves_025
 * 前置条件
 * 1.准备一台xxx手机
 2.手机相机相册内存在文件a，收藏文件a
 */
async function multimediaGalleryFilesmoves025(dt: Dt) {
  dt.log.i('收藏文件移动至目标相册后取消收藏，界面检查 start');
  dt.log.i('STEP 1、收藏相册中移动文件a到【新建相册 1】');

  await dt.sleep();
  dt.log.i('预期结果1、文件成功移动到【新建相册 1】');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、文件a取消收藏');

  await dt.sleep();
  dt.log.i('预期结果2、收藏相册中文件a消失');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('收藏文件移动至目标相册后取消收藏，界面检查 end');
}

/**
 * 宫格-收藏: [文件移动至目标相册后点击收藏，界面检查]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Files_moves_026
 * 前置条件
 * 1.准备一台xxx手机
 2.手机相机相册内存在文件a
 */
async function multimediaGalleryFilesmoves026(dt: Dt) {
  dt.log.i('文件移动至目标相册后点击收藏，界面检查 start');
  dt.log.i('STEP 1、移动文件a到【新建相册 1】');

  await dt.sleep();
  dt.log.i('预期结果1、文件成功移动到【新建相册 1】');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、文件a添加收藏');

  await dt.sleep();
  dt.log.i('预期结果2、收藏相册中出现文件a');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('文件移动至目标相册后点击收藏，界面检查 end');
}

/**
 * 宫格-: [开启多语言后的界面检查]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_Files_moves_027
 * 前置条件
 * 1.准备一台xxx手机
 2.手机相机相册内存在文件100张
 3.将语言切换至除中文外的其他语言
 */
async function multimediaGalleryFilesmoves027(dt: Dt) {
  dt.log.i('开启多语言后的界面检查 start');
  dt.log.i('STEP 1、移动图库文件到目标相册，存在重复文件时出现弹窗，弹窗中的语言为对应语言');

  await dt.sleep();
  dt.log.i('预期结果1、移动功能正常，图库界面显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('开启多语言后的界面检查 end');
}

/**
 * 宫格-下载: [a、b手机均完成云同步后再关闭云同步，a手机将文件c移动至A相册，b手机将相同文件c移动至B相册，a、b手机先后开云，对文件c移动到的相册界面检查]
 * GROUP: 宫格 MODULE: 下载TID: Multimedia_Gallery_Files_moves_028
 * 前置条件
 * 1.准备两台xxx手机
 2.手机A中图库相机相册存在文件C
 3.手机B中没有图片资源
 */
async function multimediaGalleryFilesmoves028(dt: Dt) {
  dt.log.i('a、b手机均完成云同步后再关闭云同步，a手机将文件c移动至A相册，b手机将相同文件c移动至B相册，a、b手机先后开云，对文件c移动到的相册界面检查 start');
  dt.log.i('STEP 1、手机A云账号上行图片，手机B登录相同账号同步下载完成');

  await dt.sleep();
  dt.log.i('STEP 2、A、B 手机关闭云同步，');

  await dt.sleep();
  dt.log.i('预期结果2、关闭云同步后，B手机中的文件消失4、文件C 移动到【新建相册 2】');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、A手机中将文件C 移动到【新建相册 1】，B 手机将文件C 移动到【新建相册 2】');

  await dt.sleep();
  dt.log.i('STEP 4、打开A手机的云同步，完成后，打开B手机的同步');

  await dt.sleep();
  dt.log.i('预期结果4、文件C 移动到【新建相册 2】');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('a、b手机均完成云同步后再关闭云同步，a手机将文件c移动至A相册，b手机将相同文件c移动至B相册，a、b手机先后开云，对文件c移动到的相册界面检查 end');
}




































