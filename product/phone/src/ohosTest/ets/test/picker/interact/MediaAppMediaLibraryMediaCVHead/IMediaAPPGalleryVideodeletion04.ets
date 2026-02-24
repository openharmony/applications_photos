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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, Level } from '@ohos/hypium';
import { Component, Driver, On, ON, Point } from '@ohos.UiTest';
import { abilityDelegator, run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';


export default function iMediaAPPGalleryVideodeletionFour_Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('IMediaAPPGalleryVideodeletion015Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllIMediaAPPGalleryVideodeletion015').init();
      dt.log.i('beforeAll IMediaAPPGalleryVideodeletion015 start');
      dt.log.i('beforeAll IMediaAPPGalleryVideodeletion015 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('IMediaAPPGalleryVideodeletionFour_01', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [分屏下视频清理界面功能和界面检查] TID: IMediaAPP_Gallery_Videodeletion_015
      await iMediaAPPGalleryVideodeletionFour_01(dt);
    });

    run('IMediaAPPGalleryVideodeletionFour_02', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [大字体下视频清理界面功能和界面检查] TID: IMediaAPP_Gallery_Videodeletion_016
      await iMediaAPPGalleryVideodeletionFour_02(dt);
    });

    run('IMediaAPPGalleryVideodeletionFour_03', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [深色模式下视频清理界面功能和界面检查] TID: IMediaAPP_Gallery_Videodeletion_017
      await iMediaAPPGalleryVideodeletionFour_03(dt);
    });

    run('IMediaAPPGalleryVideodeletionFour_04', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [多语言下视频清理界面功能和界面检查] TID: IMediaAPP_Gallery_Videodeletion_018
      await iMediaAPPGalleryVideodeletionFour_04(dt);
    });

    run('IMediaAPPGalleryVideodeletionFour_05', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [无障碍下视频清理界面功能和界面检查] TID: IMediaAPP_Gallery_Videodeletion_019
      await iMediaAPPGalleryVideodeletionFour_05(dt);
    });

    run('IMediaAPPGalleryVideodeletionFour_06', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [专项清理点击视频跳转视频清理列表界面完成时延不超过600ms] TID: IMediaAPP_Gallery_Videodeletion_020
      await iMediaAPPGalleryVideodeletionFour_06(dt);
    });

    run('IMediaAPPGalleryVideodeletionFour_07', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [设置_图库清理_删除视频打点测试] TID: IMediaAPP_Gallery_Videodeletion_021
      await iMediaAPPGalleryVideodeletionFour_07(dt);
    });

    run('IMediaAPPGalleryVideodeletionFour_08', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [设置_专项清理_获取可清理视频大小打点测试] TID: IMediaAPP_Gallery_Videodeletion_022
      await iMediaAPPGalleryVideodeletionFour_08(dt);
    });

    run('IMediaAPPGalleryVideodeletionFour_09', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [设置_视频专清_进入视频清理页面打点测试] TID: IMediaAPP_Gallery_Videodeletion_023
      await iMediaAPPGalleryVideodeletionFour_09(dt);
    });

    run('MultimediaGalleryAlbumsCloneFour_01', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [相机、截图、屏幕录制相册xxx克隆验证] TID: Multimedia_Gallery__Albums_Clone_0001
      await multimediaGalleryAlbumsCloneFour_01(dt);
    });

    run('MultimediaGalleryAlbumsCloneFour_02', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [预置自定义相册，相机、截图、屏幕录制相册xxx克隆验证] TID: Multimedia_Gallery__Albums_Clone_0002
      await multimediaGalleryAlbumsCloneFour_02(dt);
    });

    run('MultimediaGalleryAlbumsCloneFour_03', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [相机、截图、屏幕录制相册xxx克隆验证] TID: Multimedia_Gallery__Albums_Clone_0003
      await multimediaGalleryAlbumsCloneFour_03(dt);
    });

    run('MultimediaGalleryAlbumsLayoutFour_01', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [图库相册页无相机、截图、屏幕录制相册时，拍照、截屏、录屏后，检查相册页布局] TID: Multimedia_Gallery__Albums_Layout_0001
      await multimediaGalleryAlbumsLayoutFour_01(dt);
    });

    run('MultimediaGalleryAlbumsLayoutFour_02', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [拍照、截屏、录屏后，检查相册页-相机、截图、屏幕录制相册布局] TID: Multimedia_Gallery__Albums_Layout_0002
      await multimediaGalleryAlbumsLayoutFour_02(dt);
    });

    run('MultimediaGalleryAlbumsLayoutFour_03', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [相机、截图、屏幕录制相册无添加功能] TID: Multimedia_Gallery__Albums_Layout_0003
      await multimediaGalleryAlbumsLayoutFour_03(dt);
    });

    run('MultimediaGalleryAlbumsLayoutFour_04', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-锁屏用例: [相机、截图、屏幕录制相册布局显示验证] TID: Multimedia_Gallery__Albums_Layout_0004
      await multimediaGalleryAlbumsLayoutFour_04(dt);
    });

    run('MultimediaGalleryAlbumsLayoutFour_05', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [相机、截图、屏幕录制相册清空后恢复] TID: Multimedia_Gallery__Albums_Layout_0005
      await multimediaGalleryAlbumsLayoutFour_05(dt);
    });

    run('MultimediaGalleryAlbumsOtherFour_01', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [相机、截图、屏幕录制相册多语言适配验证] TID: Multimedia_Gallery__Albums_Other_0001
      await multimediaGalleryAlbumsOtherFour_01(dt);
    });

    run('MultimediaGalleryAlbumsOtherFour_02', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-深色用例: [相机、截图、屏幕录制相册深色模式适配] TID: Multimedia_Gallery__Albums_Other_0002
      await multimediaGalleryAlbumsOtherFour_02(dt);
    });

    run('MultimediaGalleryAlbumsOtherFour_03', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [相机、截图、屏幕录制相册大字体、关怀模式适配] TID: Multimedia_Gallery__Albums_Other_0003
      await multimediaGalleryAlbumsOtherFour_03(dt);
    });

    run('MultimediaGalleryAlbumsOtherFour_04', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [相机、截图、屏幕录制相册无障碍模式验证] TID: Multimedia_Gallery__Albums_Other_0004
      await multimediaGalleryAlbumsOtherFour_04(dt);
    });

    run('MultimediaGalleryAlbumsUpgradeFour_01', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [相机、截图、屏幕录制相册xxx验证] TID: Multimedia_Gallery__Albums_Upgrade_0001
      await multimediaGalleryAlbumsUpgradeFour_01(dt);
    });

    run('MultimediaGalleryAlbumsUpgradeFour_02', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [预置自定义相册，相机、截图、屏幕录制相册xxx验证] TID: Multimedia_Gallery__Albums_Upgrade_0002
      await multimediaGalleryAlbumsUpgradeFour_02(dt);
    });

    run('MultimediaGalleryAlbumsUpgradeFour_03', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [预置自定义相册，相机、截图、屏幕录制相册xxx验证] TID: Multimedia_Gallery__Albums_Upgrade_0002
      await multimediaGalleryAlbumsUpgradeFour_03(dt);
    });

    run('MultimediaGallery50WPerfermanceFour_01', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [大图进编辑] TID: Multimedia_Gallery_50WPerfermance_012
      await multimediaGallery50WPerfermanceFour_01(dt);
    });

    run('MultimediaGallery50WPerfermanceFour_02', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [编辑页面切换底部标签页响应时延/完成时延] TID: Multimedia_Gallery_50WPerfermance_013
      await multimediaGallery50WPerfermanceFour_02(dt);
    });

    run('MultimediaGallery50WPerfermanceFour_03', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [编辑的图片还原响应时延/完成时延] TID: Multimedia_Gallery_50WPerfermance_014
      await multimediaGallery50WPerfermanceFour_03(dt);
    });

    run('MultimediaGallery50WPerfermanceFour_04', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [编辑保存，退出] TID: Multimedia_Gallery_50WPerfermance_015
      await multimediaGallery50WPerfermanceFour_04(dt);
    });

    run('MultimediaGallery50WPerfermanceFour_05', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [照片页切换到相册页] TID: Multimedia_Gallery_50WPerfermance_030
      await multimediaGallery50WPerfermanceFour_05(dt);
    });

    run('MultimediaGallery50WPerfermanceFour_06', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [相册页切换到照片页] TID: Multimedia_Gallery_50WPerfermance_031
      await multimediaGallery50WPerfermanceFour_06(dt);
    });

    run('MultimediaGallery50WPerfermanceFour_07', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [照片页切换到时刻页] TID: Multimedia_Gallery_50WPerfermance_032
      await multimediaGallery50WPerfermanceFour_07(dt);
    });

    run('MultimediaGallery50WPerfermanceFour_08', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [相册页切换到时刻页] TID: Multimedia_Gallery_50WPerfermance_033
      await multimediaGallery50WPerfermanceFour_08(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachIMediaAPPGalleryVideodeletion015').init();
      dt.log.i('afterEach IMediaAPPGalleryVideodeletion015 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach IMediaAPPGalleryVideodeletion015 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllIMediaAPPGalleryVideodeletion015').init();
      dt.log.i('afterAll IMediaAPPGalleryVideodeletion015 start');
      await Exit.browser();
      dt.log.i('afterAll IMediaAPPGalleryVideodeletion015 finish');
    });
  });
}

/**
 * 宫格-视频: [分屏下视频清理界面功能和界面检查]
 * GROUP: 宫格 MODULE: 视频TID: IMediaAPP_Gallery_Videodeletion_015
 * 前置条件
 * 1、图库预制1000+视频资源
 */
async function iMediaAPPGalleryVideodeletionFour_01(dt: Dt) {
  dt.log.i('分屏下视频清理界面功能和界面检查 start');
  dt.log.i('STEP 1、分屏下遍历视频清理全量场景');

  await dt.sleep();
  dt.log.i('预期结果1、功能正常，界面文字和弹窗显示正常，无截断');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分屏下视频清理界面功能和界面检查 end');
}

/**
 * 宫格-视频: [大字体下视频清理界面功能和界面检查]
 * GROUP: 宫格 MODULE: 视频TID: IMediaAPP_Gallery_Videodeletion_016
 * 前置条件
 * 1、图库预制1000+视频资源
 */
async function iMediaAPPGalleryVideodeletionFour_02(dt: Dt) {
  dt.log.i('大字体下视频清理界面功能和界面检查 start');
  dt.log.i('STEP 1、大字体下遍历视频清理全量场景');

  await dt.sleep();
  dt.log.i('预期结果1、功能正常，界面文字和弹窗显示正常，无截断');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大字体下视频清理界面功能和界面检查 end');
}

/**
 * 宫格-视频: [深色模式下视频清理界面功能和界面检查]
 * GROUP: 宫格 MODULE: 视频TID: IMediaAPP_Gallery_Videodeletion_017
 * 前置条件
 * 1、图库预制1000+视频资源
 */
async function iMediaAPPGalleryVideodeletionFour_03(dt: Dt) {
  dt.log.i('深色模式下视频清理界面功能和界面检查 start');
  dt.log.i('STEP 1、深色模式下遍历视频清理全量场景');

  await dt.sleep();
  dt.log.i('预期结果1、功能正常，界面文字和弹窗显示正常，无截断');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('深色模式下视频清理界面功能和界面检查 end');
}

/**
 * 宫格-视频: [多语言下视频清理界面功能和界面检查]
 * GROUP: 宫格 MODULE: 视频TID: IMediaAPP_Gallery_Videodeletion_018
 * 前置条件
 * 1、图库预制视频资源
 */
async function iMediaAPPGalleryVideodeletionFour_04(dt: Dt) {
  dt.log.i('多语言下视频清理界面功能和界面检查 start');
  dt.log.i('STEP 1、多语言下遍历视频清理全量场景');

  await dt.sleep();
  dt.log.i('预期结果1、功能正常，界面文字和弹窗显示正常，有对应语言翻译，无截断');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多语言下视频清理界面功能和界面检查 end');
}

/**
 * 宫格-视频: [无障碍下视频清理界面功能和界面检查]
 * GROUP: 宫格 MODULE: 视频TID: IMediaAPP_Gallery_Videodeletion_019
 * 前置条件
 * 1、图库预制视频资源
 */
async function iMediaAPPGalleryVideodeletionFour_05(dt: Dt) {
  dt.log.i('无障碍下视频清理界面功能和界面检查 start');
  dt.log.i('STEP 1、无障碍下遍历视频清理全量场景');

  await dt.sleep();
  dt.log.i('预期结果1、功能正常，界面文字和弹窗显示正常，播报正常，无截断');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无障碍下视频清理界面功能和界面检查 end');
}

/**
 * 宫格-视频: [专项清理点击视频跳转视频清理列表界面完成时延不超过600ms]
 * GROUP: 宫格 MODULE: 视频TID: IMediaAPP_Gallery_Videodeletion_020
 * 前置条件
 * 1、图库预制10000+视频资源
 */
async function iMediaAPPGalleryVideodeletionFour_06(dt: Dt) {
  dt.log.i('专项清理点击视频跳转视频清理列表界面完成时延不超过600ms start');
  dt.log.i('STEP 1、设置存储点击专项清理');

  await dt.sleep();
  dt.log.i('STEP 2、点击视频跳转视频清理列表界面，慢动作录屏数帧，统计从点击到界面完全加载的完成时延');

  await dt.sleep();
  dt.log.i('预期结果2、完成时延不超过600ms');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('专项清理点击视频跳转视频清理列表界面完成时延不超过600ms end');
}

/**
 * 宫格-删除: [设置_图库清理_删除视频打点测试]
 * GROUP: 宫格 MODULE: 删除TID: IMediaAPP_Gallery_Videodeletion_021
 * 前置条件
 * 1、图库预制1000+视频资源
 */
async function iMediaAPPGalleryVideodeletionFour_07(dt: Dt) {
  dt.log.i('设置_图库清理_删除视频打点测试 start');
  dt.log.i('STEP 1、设置存储视频清理界面，选择视频点击删除');

  await dt.sleep();
  dt.log.i('STEP 2、命令窗口，hdc shell ,输入hisysevent -r -o PHOTOS_UE -n CLEANUP_DELETE_VIDEOS查看');

  await dt.sleep();
  dt.log.i('STEP 3、点击永久删除');

  await dt.sleep();
  dt.log.i('预期结果3、日志打印deletedVideosCount”:XX,”deletedVideosSize”:XX，和选中的视频个数与大小一致');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text(':XX,'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置_图库清理_删除视频打点测试 end');
}

/**
 * 宫格-视频: [设置_专项清理_获取可清理视频大小打点测试]
 * GROUP: 宫格 MODULE: 视频TID: IMediaAPP_Gallery_Videodeletion_022
 * 前置条件
 * 1、图库预制1000+视频资源
 */
async function iMediaAPPGalleryVideodeletionFour_08(dt: Dt) {
  dt.log.i('设置_专项清理_获取可清理视频大小打点测试 start');
  dt.log.i('STEP 1、命令窗口，hdc shell ,输入hisysevent -r -o PHOTOS_UE -n GET_VIDEO_CLEANUP_SIZE查看');

  await dt.sleep();
  dt.log.i('STEP 2、设置存储，点击专项清理');

  await dt.sleep();
  dt.log.i('预期结果2、日志打印cleanupVideosSize”:XXX和专项清理界面视频显示大小一致单位默认是MB');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text(':XXX和专项清理界面视频显示大小一致单位默认是MB'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置_专项清理_获取可清理视频大小打点测试 end');
}

/**
 * 宫格-视频: [设置_视频专清_进入视频清理页面打点测试]
 * GROUP: 宫格 MODULE: 视频TID: IMediaAPP_Gallery_Videodeletion_023
 * 前置条件
 * 1、图库预制1000+视频资源
 */
async function iMediaAPPGalleryVideodeletionFour_09(dt: Dt) {
  dt.log.i('设置_视频专清_进入视频清理页面打点测试 start');
  dt.log.i('STEP 1、命令窗口，hdc shell ,输入hisysevent -r -o PHOTOS_UE -n ENTER_VIDEO_CLEANUP_ENTRY查看');

  await dt.sleep();
  dt.log.i('STEP 2、设置存储，点击专项清理，点击视频');

  await dt.sleep();
  dt.log.i('预期结果2、查看日志打印');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('设置_视频专清_进入视频清理页面打点测试 end');
}

/**
 * 宫格-收藏: [相机、截图、屏幕录制相册xxx克隆验证]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery__Albums_Clone_0001
 * 前置条件
 * 1.xxx辅助机、测试机已存在图片、视频、我的收藏、相机、截屏、屏幕录制相册，已预置图片、视频
 2.xxx升级版本已支持来源相册（相机、截图、屏幕录制）挪到顶部系统相册
 3.xxx辅助机版本相机、截图、屏幕录制相册显示在底部来源相册区域（122SP2之前的版本）
 */
async function multimediaGalleryAlbumsCloneFour_01(dt: Dt) {
  dt.log.i('相机、截图、屏幕录制相册xxx克隆验证 start');
  dt.log.i('STEP 1.xxx辅助机克隆图库至xxx测试机，打开图库-相册页，检查相机、截图、屏幕录制相册；');

  await dt.sleep();
  dt.log.i('预期结果1.底部来源相册不显示相机、截图、屏幕录制相册，系统相册区域--按图片、视频、我的收藏、相机、截图、屏幕录制相册顺序展示在相册页最前，');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.拍照、截图、录屏后，打开图库-相册页，检查相机、截图、屏幕录制相册');

  await dt.sleep();
  dt.log.i('预期结果2.系统相册区域的相机、截图、屏幕录制相册显示新增的图片、视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机、截图、屏幕录制相册xxx克隆验证 end');
}

/**
 * 宫格-收藏: [预置自定义相册，相机、截图、屏幕录制相册xxx克隆验证]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery__Albums_Clone_0002
 * 前置条件
 * 1.xxx辅助机已有用户自定义的相机、截屏、屏幕录制相册，已预置图片、视频
 2.xxx当前版本已支持来源相册（相机、截图、屏幕录制）挪到顶部系统相册
 3.xxx测试机已存在图片、视频、我的收藏、相机、截屏、屏幕录制相册，已预置图片、视频
 */
async function multimediaGalleryAlbumsCloneFour_02(dt: Dt) {
  dt.log.i('预置自定义相册，相机、截图、屏幕录制相册xxx克隆验证 start');
  dt.log.i('STEP 1.xxx辅助机克隆图库至xxx测试机，打开图库-相册页，检查相机、截图、屏幕录制相册；');

  await dt.sleep();
  dt.log.i('预期结果1.xxx自定义的相机、截图、屏幕录制相册显示在来源相册区域');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.拍照、截图、录屏后，打开图库-相册页，检查相机、截图、屏幕录制相册');

  await dt.sleep();
  dt.log.i('预期结果2.系统相册区域的相机、截图、屏幕录制相册显示新增的图片、视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('预置自定义相册，相机、截图、屏幕录制相册xxx克隆验证 end');
}

/**
 * 宫格-收藏: [相机、截图、屏幕录制相册xxx克隆验证]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery__Albums_Clone_0003
 * 前置条件
 * 1.xxx辅助机已存在相机、截屏录屏相册，已预置图片、视频
 2.xxx当前版本已支持来源相册（相机、截图、屏幕录制）挪到顶部系统相册
 */
async function multimediaGalleryAlbumsCloneFour_03(dt: Dt) {
  dt.log.i('相机、截图、屏幕录制相册xxx克隆验证 start');
  dt.log.i('STEP 1.xxx辅助机克隆图库至xxx测试机，打开图库-相册页，检查相机、截图、屏幕录制相册；');

  await dt.sleep();
  dt.log.i('预期结果1.系统相册区域--按图片、视频、我的收藏、相机、截图、屏幕录制相册顺序展示在相册页最前，');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.拍照、截图、录屏后，打开图库-相册页，检查相机、截图、屏幕录制相册');

  await dt.sleep();
  dt.log.i('预期结果2.系统相册区域的相机、截图、屏幕录制相册显示新增的图片、视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机、截图、屏幕录制相册xxx克隆验证 end');
}

/**
 * 宫格-收藏: [图库相册页无相机、截图、屏幕录制相册时，拍照、截屏、录屏后，检查相册页布局]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery__Albums_Layout_0001
 * 前置条件
 * 1.图库相册页已预置图片、视频、我的收藏相册，无相机、截图、屏幕录制相册
 */
async function multimediaGalleryAlbumsLayoutFour_01(dt: Dt) {
  dt.log.i('图库相册页无相机、截图、屏幕录制相册时，拍照、截屏、录屏后，检查相册页布局 start');
  dt.log.i('STEP 1.拍照、截屏、录屏后，检查图库-相册页显示');

  await dt.sleep();
  dt.log.i('预期结果1.1.相册页实时显示相机、截图、屏幕录制相册，数量正确，无异常；1.2.系统相册区域--按图片、视频、我的收藏、相机、截图、屏幕录制相册顺序展示在相册页最前，1.3.底部来源相册区域不会生成相机、截图、屏幕录制相册');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库相册页无相机、截图、屏幕录制相册时，拍照、截屏、录屏后，检查相册页布局 end');
}

/**
 * 宫格-收藏: [拍照、截屏、录屏后，检查相册页-相机、截图、屏幕录制相册布局]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery__Albums_Layout_0002
 * 前置条件
 * 1.图库相册页已预置图片、视频、我的收藏、相机、截图、屏幕录制相册，已预置图片、视频
 */
async function multimediaGalleryAlbumsLayoutFour_02(dt: Dt) {
  dt.log.i('拍照、截屏、录屏后，检查相册页-相机、截图、屏幕录制相册布局 start');
  dt.log.i('STEP 1.拍照、截屏、录屏后，图库-相册页检查显示');

  await dt.sleep();
  dt.log.i('预期结果1.相册页实时更新数量，相机、截图、屏幕录制相册位置无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('拍照、截屏、录屏后，检查相册页-相机、截图、屏幕录制相册布局 end');
}

/**
 * 宫格-: [相机、截图、屏幕录制相册无添加功能]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery__Albums_Layout_0003
 * 前置条件
 * 1.图库相册页已存在相机、截图、屏幕录制相册
 */
async function multimediaGalleryAlbumsLayoutFour_03(dt: Dt) {
  dt.log.i('相机、截图、屏幕录制相册无添加功能 start');
  dt.log.i('STEP 1.分别进入相机、截图、屏幕录制相册，检查标题区右上角');

  await dt.sleep();
  dt.log.i('预期结果1.无添加按钮');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机、截图、屏幕录制相册无添加功能 end');
}

/**
 * 宫格-锁屏: [相机、截图、屏幕录制相册布局显示验证]
 * GROUP: 宫格 MODULE: 锁屏TID: Multimedia_Gallery__Albums_Layout_0004
 * 前置条件
 * 1.图库相册页已预置相机、截图、屏幕录制相册，已预置图片、视频
 */
async function multimediaGalleryAlbumsLayoutFour_04(dt: Dt) {
  dt.log.i('相机、截图、屏幕录制相册布局显示验证 start');
  dt.log.i('STEP 1.相机、截图、屏幕录制相册新增/删除图片、视频后，冷启动图库-相册页，');

  await dt.sleep();
  dt.log.i('预期结果1-5.相册页实时更新数量，相机、截图、屏幕录制相册位置无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.相机、截图、屏幕录制相册新增/删除图片、视频后，热启动图库-相册页，');

  await dt.sleep();
  dt.log.i('STEP 3.来回切换照片页、相册页、时刻页，');

  await dt.sleep();
  dt.log.i('STEP 4.相册页锁屏后解锁，');

  await dt.sleep();
  dt.log.i('STEP 5.上下滑动相册页，');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机、截图、屏幕录制相册布局显示验证 end');
}

/**
 * 宫格-收藏: [相机、截图、屏幕录制相册清空后恢复]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery__Albums_Layout_0005
 * 前置条件
 * 1.图库相册页已预置图片、视频、我的收藏、相机、截图、屏幕录制相册，已预置图片、视频
 */
async function multimediaGalleryAlbumsLayoutFour_05(dt: Dt) {
  dt.log.i('相机、截图、屏幕录制相册清空后恢复 start');
  dt.log.i('STEP 1.打开图库-相册页，分别进入相机、截图、屏幕录制相册，清空（删除/隐藏）所有图片视频，返回相册页检查');

  await dt.sleep();
  dt.log.i('预期结果1.1.分别清空相册后，相册页系统相册区域相册顺序正确（按图片、视频、我的收藏、相机、截图、屏幕录制相册顺序）1.2相册页不显示系统生成的相机、截图、屏幕录制相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.最近删除/隐藏相册恢复/取消隐藏所有图片视频，返回相册页检查');

  await dt.sleep();
  dt.log.i('预期结果2.恢复/取消隐藏后，相册页系统相册区域相册顺序正确（按图片、视频、我的收藏、相机、截图、屏幕录制相册顺序）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机、截图、屏幕录制相册清空后恢复 end');
}

/**
 * 宫格-视频: [相机、截图、屏幕录制相册多语言适配验证]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery__Albums_Other_0001
 * 前置条件
 * 1.图库相册页已预置相机、截图、屏幕录制相册，已预置图片、视频
 */
async function multimediaGalleryAlbumsOtherFour_01(dt: Dt) {
  dt.log.i('相机、截图、屏幕录制相册多语言适配验证 start');
  dt.log.i('STEP 1.切换系统语言，返回图库-相册页，检查相机、截图、屏幕录制相册名称，');

  await dt.sleep();
  dt.log.i('预期结果1&2&3.匹配对应语言，镜像语言无异常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.分别进入相机、截图、屏幕录制相册，检查相册标题，');

  await dt.sleep();
  dt.log.i('STEP 3.打开图库picker，检查所有相册页相机、截图、屏幕录制相册名称');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机、截图、屏幕录制相册多语言适配验证 end');
}

/**
 * 宫格-深色: [相机、截图、屏幕录制相册深色模式适配]
 * GROUP: 宫格 MODULE: 深色TID: Multimedia_Gallery__Albums_Other_0002
 * 前置条件
 * 1.图库相册页已存在相机、截图、屏幕录制相册
 2.已开启深色模式
 */
async function multimediaGalleryAlbumsOtherFour_02(dt: Dt) {
  dt.log.i('相机、截图、屏幕录制相册深色模式适配 start');
  dt.log.i('STEP 1.开启系统设置深色模式开关，打开图库-相册页，检查显示');

  await dt.sleep();
  dt.log.i('预期结果1.深色模式已适配');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机、截图、屏幕录制相册深色模式适配 end');
}

/**
 * 宫格-: [相机、截图、屏幕录制相册大字体、关怀模式适配]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery__Albums_Other_0003
 * 前置条件
 * 1.图库相册页已存在相机、截图、屏幕录制相册
 */
async function multimediaGalleryAlbumsOtherFour_03(dt: Dt) {
  dt.log.i('相机、截图、屏幕录制相册大字体、关怀模式适配 start');
  dt.log.i('STEP 1.打开系统设置，分别调整字体大小，打开图库-相册页，检查布局显示');

  await dt.sleep();
  dt.log.i('预期结果1.大字体、关怀模式已适配');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.打开系统设置关怀模式，打开图库-相册页，检查布局显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机、截图、屏幕录制相册大字体、关怀模式适配 end');
}

/**
 * 宫格-: [相机、截图、屏幕录制相册无障碍模式验证]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery__Albums_Other_0004
 * 前置条件
 * 1.图库相册页已存在相机、截图、屏幕录制相册
 2.已开启屏幕朗读
 */
async function multimediaGalleryAlbumsOtherFour_04(dt: Dt) {
  dt.log.i('相机、截图、屏幕录制相册无障碍模式验证 start');
  dt.log.i('STEP 1.打开图库-相册页，分别点击相机、截图、屏幕录制相册');

  await dt.sleep();
  dt.log.i('预期结果1.相册页显示无异常，框选正确，可以正常朗读，');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.分别进入相机、截图、屏幕录制相册');

  await dt.sleep();
  dt.log.i('预期结果2.正确跳转进相机、截图、屏幕录制相册');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机、截图、屏幕录制相册无障碍模式验证 end');
}

/**
 * 宫格-收藏: [相机、截图、屏幕录制相册xxx验证]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery__Albums_Upgrade_0001
 * 前置条件
 * 1.xxx测试机已存在相机、截屏录屏相册，已预置图片、视频；
 2.xxx升级版本（123及以后版本）已支持来源相册（相机、截图、屏幕录制）挪到顶部系统相册
 注：刷xxx版本需要4.1的协议，xxx版本刷机参考文档：
 */
async function multimediaGalleryAlbumsUpgradeFour_01(dt: Dt) {
  dt.log.i('相机、截图、屏幕录制相册xxx验证 start');
  dt.log.i('STEP 1.xxx测试机升级系统至xxx后，打开图库-相册页，检查相机、截图、屏幕录制相册；');

  await dt.sleep();
  dt.log.i('预期结果1.1系统相册区域--按图片、视频、我的收藏、相机、截图、屏幕录制相册顺序展示在相册页最前，');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.拍照、截图、录屏后，打开图库-相册页，检查相机、截图、屏幕录制相册');

  await dt.sleep();
  dt.log.i('预期结果2.系统相册区域的相机、截图、屏幕录制相册显示新增的图片、视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机、截图、屏幕录制相册xxx验证 end');
}

/**
 * 宫格-视频: [预置自定义相册，相机、截图、屏幕录制相册xxx验证]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery__Albums_Upgrade_0002
 * 前置条件
 * 1.xxx测试机已存在用户自定义的相机、截屏、屏幕录制相册，已预置图片、视频；
 2.xxx升级版本（123及以后版本）已支持来源相册（相机、截图、屏幕录制）挪到顶部系统相册
 */
async function multimediaGalleryAlbumsUpgradeFour_02(dt: Dt) {
  dt.log.i('预置自定义相册，相机、截图、屏幕录制相册xxx验证 start');
  dt.log.i('STEP 1.xxx测试机升级系统至xxx后，打开图库-相册页，检查相机、截图、屏幕录制相册，');

  await dt.sleep();
  dt.log.i('预期结果1.xxx自定义的相机、截图、屏幕录制相册显示在来源相册区域');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.拍照、截图、录屏后，打开图库-相册页，检查相机、截图、屏幕录制相册');

  await dt.sleep();
  dt.log.i('预期结果2.系统相册区域的相机、截图、屏幕录制相册显示新增的图片、视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('预置自定义相册，相机、截图、屏幕录制相册xxx验证 end');
}

/**
 * 宫格-视频: [预置自定义相册，相机、截图、屏幕录制相册xxx验证]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery__Albums_Upgrade_0002
 * 前置条件
 * 1.xxx测试机已存在用户自定义的相机、截屏、屏幕录制相册，已预置图片、视频；
2.xxx升级版本（123及以后版本）已支持来源相册（相机、截图、屏幕录制）挪到顶部系统相册
 */
async function multimediaGalleryAlbumsUpgradeFour_03(dt: Dt) {
  dt.log.i('预置自定义相册，相机、截图、屏幕录制相册xxx验证 start');
  dt.log.i('STEP 1.xxx测试机升级系统至xxx后，打开图库-相册页，检查相机、截图、屏幕录制相册，');

  await dt.sleep();
  dt.log.i('预期结果1.xxx自定义的相机、截图、屏幕录制相册显示在来源相册区域');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.拍照、截图、录屏后，打开图库-相册页，检查相机、截图、屏幕录制相册');

  await dt.sleep();
  dt.log.i('预期结果2.系统相册区域的相机、截图、屏幕录制相册显示新增的图片、视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('预置自定义相册，相机、截图、屏幕录制相册xxx验证 end');
}

/**
 * 宫格-大图: [大图进编辑]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_50WPerfermance_012
 * 前置条件
 * 1、登录图库大数据测试模型（50W图片），正常完成数据同步
 */
async function multimediaGallery50WPerfermanceFour_01(dt: Dt) {
  dt.log.i('大图进编辑 start');
  dt.log.i('STEP 1、大图浏览，点击编辑手抬起来作为起始帧');

  await dt.sleep();
  dt.log.i('STEP 2、编辑界面完全显示时作为结束帧');

  await dt.sleep();
  dt.log.i('STEP 3、计算结束帧的时间减去起始帧的时间');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图进编辑 end');
}

/**
 * 宫格-: [编辑页面切换底部标签页响应时延/完成时延]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_50WPerfermance_013
 * 前置条件
 * 1、登录图库大数据测试模型（50W图片），正常完成数据同步
 */
async function multimediaGallery50WPerfermanceFour_02(dt: Dt) {
  dt.log.i('编辑页面切换底部标签页响应时延/完成时延 start');
  dt.log.i('STEP 1、编辑中点击裁剪按钮手抬起来作为起始帧');

  await dt.sleep();
  dt.log.i('STEP 2、裁剪界面完全显示时作为结束帧');

  await dt.sleep();
  dt.log.i('STEP 3、计算结束帧的时间减去起始帧的时间');

  await dt.sleep();
  dt.log.i('STEP 4、操作调节、滤镜重复1-3');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑页面切换底部标签页响应时延/完成时延 end');
}

/**
 * 宫格-大图: [编辑的图片还原响应时延/完成时延]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_50WPerfermance_014
 * 前置条件
 * 1、登录图库大数据测试模型（50W图片），正常完成数据同步
 */
async function multimediaGallery50WPerfermanceFour_03(dt: Dt) {
  dt.log.i('编辑的图片还原响应时延/完成时延 start');
  dt.log.i('STEP 1、选择已编辑图片进入编辑');

  await dt.sleep();
  dt.log.i('STEP 2、点击复原按钮T1:点击保存按钮，手指离开屏幕的第一帧T2:界面开始变化的第一帧T3:大图完全显示的第一帧');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑的图片还原响应时延/完成时延 end');
}

/**
 * 宫格-: [编辑保存，退出]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_50WPerfermance_015
 * 前置条件
 * 1、登录图库大数据测试模型（50W图片），正常完成数据同步
 */
async function multimediaGallery50WPerfermanceFour_04(dt: Dt) {
  dt.log.i('编辑保存，退出 start');
  dt.log.i('STEP 1、编辑任意操作，之后点击保存—覆盖保存（另存为）手抬起来作为起始帧');

  await dt.sleep();
  dt.log.i('STEP 2、保存完成，界面完全显示作为结束帧');

  await dt.sleep();
  dt.log.i('STEP 3、计算结束帧的时间减去起始帧的时间');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑保存，退出 end');
}

/**
 * 宫格-: [照片页切换到相册页]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_50WPerfermance_030
 * 前置条件
 * 1、登录图库大数据测试模型（50W图片），正常完成数据同步
 */
async function multimediaGallery50WPerfermanceFour_05(dt: Dt) {
  dt.log.i('照片页切换到相册页 start');
  dt.log.i('STEP 1、照片页界面，点击相册页按钮手抬起来作为起始帧');

  await dt.sleep();
  dt.log.i('STEP 2、相册页完全显示作为结束帧');

  await dt.sleep();
  dt.log.i('STEP 3、计算结束帧的时间减去起始帧的时间');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页切换到相册页 end');
}

/**
 * 宫格-: [相册页切换到照片页]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_50WPerfermance_031
 * 前置条件
 * 1、登录图库大数据测试模型（50W图片），正常完成数据同步
 */
async function multimediaGallery50WPerfermanceFour_06(dt: Dt) {
  dt.log.i('相册页切换到照片页 start');
  dt.log.i('STEP 1、相册页界面，点击照片页按钮手抬起来作为起始帧');

  await dt.sleep();
  dt.log.i('STEP 2、照片页完全显示作为结束帧');

  await dt.sleep();
  dt.log.i('STEP 3、计算结束帧的时间减去起始帧的时间');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页切换到照片页 end');
}

/**
 * 宫格-: [照片页切换到时刻页]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_50WPerfermance_032
 * 前置条件
 * 1、登录图库大数据测试模型（50W图片），正常完成数据同步
 */
async function multimediaGallery50WPerfermanceFour_07(dt: Dt) {
  dt.log.i('照片页切换到时刻页 start');
  dt.log.i('STEP 1、照片页界面，点击时刻页按钮手抬起来作为起始帧');

  await dt.sleep();
  dt.log.i('STEP 2、时刻页完全显示作为结束帧');

  await dt.sleep();
  dt.log.i('STEP 3、计算结束帧的时间减去起始帧的时间');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页切换到时刻页 end');
}

/**
 * 宫格-: [相册页切换到时刻页]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_50WPerfermance_033
 * 前置条件
 * 1、登录图库大数据测试模型（50W图片），正常完成数据同步
 */
async function multimediaGallery50WPerfermanceFour_08(dt: Dt) {
  dt.log.i('相册页切换到时刻页 start');
  dt.log.i('STEP 1、相册页界面，点击时刻页按钮手抬起来作为起始帧');

  await dt.sleep();
  dt.log.i('STEP 2、时刻页完全显示作为结束帧');

  await dt.sleep();
  dt.log.i('STEP 3、计算结束帧的时间减去起始帧的时间');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页切换到时刻页 end');
}
