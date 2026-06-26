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

export default function MultimediaGalleryFilesmoves002(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryFilesmoves002Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryFilesmoves002').init();
      dt.log.i('beforeAll MultimediaGalleryFilesmoves002 start');
      dt.log.i('beforeAll MultimediaGalleryFilesmoves002 finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryFilesmoves002', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryFilesmoves029', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [PC端【更多】中【复制】选项变为【复制到剪切板】] TID: Multimedia_Gallery_Files_moves_029
      await multimediaGalleryFilesmoves029(dt);
    });
    run('MultimediaGalleryFilesmoves030', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [隐藏相册和最近删除相册不支持移动] TID: Multimedia_Gallery_Files_moves_030
      await multimediaGalleryFilesmoves030(dt);
    });
    run('MultimediaGalleryFilesmoves031', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [重名文件移动至目标相册A弹窗提示] TID: Multimedia_Gallery_Files_moves_031
      await multimediaGalleryFilesmoves031(dt);
    });
    run('MultimediaGalleryFilesmoves032', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [重名文件移动至目标相册A，弹窗选择取消] TID: Multimedia_Gallery_Files_moves_032
      await multimediaGalleryFilesmoves032(dt);
    });
    run('MultimediaGalleryFilesmoves032', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [重名文件移动至目标相册A，弹窗选择取消] TID: Multimedia_Gallery_Files_moves_032
      await multimediaGalleryFilesmoves032(dt);
    });
    run('MultimediaGalleryFilesMTBFirregular002', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [图片、视频相册，文件全部删除再恢复压力测试] TID: Multimedia_Gallery_Files_MTBF_irregular_002
      await multimediaGalleryFilesMTBFirregular002(dt);
    });
    run('MultimediaGalleryFilesMTBFirregular003', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [反复添加文件压力测试] TID: Multimedia_Gallery_Files_MTBF_irregular_003
      await multimediaGalleryFilesMTBFirregular003(dt);
    });
    run('MultimediaGalleryFilesUXMenucheck001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [删除、移除菜单入口检查（用户创建相册：大图+宫格）] TID: Multimedia_Gallery_Files_UX_Menu_check_001
      await multimediaGalleryFilesUXMenucheck001(dt);
    });
    run('MultimediaGalleryFilesUXMenucheck002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [删除菜单入口检查（照片页、非用户创建相册：大图+宫格）] TID: Multimedia_Gallery_Files_UX_Menu_check_002
      await multimediaGalleryFilesUXMenucheck002(dt);
    });
    run('MultimediaGalleryFilesUXMenucheck003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [恢复菜单入口检查（最近删除相册 大图+宫格）] TID: Multimedia_Gallery_Files_UX_Menu_check_003
      await multimediaGalleryFilesUXMenucheck003(dt);
    });
    run('MultimediaGalleryFilesUXMenucheck005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [移动到菜单入口检查（照片页、非用户新建相册：大图+宫格）] TID: Multimedia_Gallery_Files_UX_Menu_check_005
      await multimediaGalleryFilesUXMenucheck005(dt);
    });
    run('MultimediaGalleryFilesUXMenucheck006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [添加菜单入口检查（用户新建相册：大图+宫格）] TID: Multimedia_Gallery_Files_UX_Menu_check_006
      await multimediaGalleryFilesUXMenucheck006(dt);
    });
    run('MultimediaGalleryFilesUXMenucheck007', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [移动菜单入口去除检查（用户新建相册：大图+宫格）] TID: Multimedia_Gallery_Files_UX_Menu_check_007
      await multimediaGalleryFilesUXMenucheck007(dt);
    });
    run('MultimediaGalleryFloatingwindow001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-进入大图用例: [照片页悬浮窗操作] TID: Multimedia_Gallery_Floatingwindow_001
      await multimediaGalleryFloatingwindow001(dt);
    });
    run('MultimediaGalleryFloatingwindow002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [相册页悬浮窗操作] TID: Multimedia_Gallery_Floatingwindow_002
      await multimediaGalleryFloatingwindow002(dt);
    });
    run('MultimediaGalleryFloatingwindow003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [大图页悬浮窗操作] TID: Multimedia_Gallery_Floatingwindow_003
      await multimediaGalleryFloatingwindow003(dt);
    });
    run('MultimediaGalleryFloatingwindow004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [三方picker页面悬浮窗操作] TID: Multimedia_Gallery_Floatingwindow_004
      await multimediaGalleryFloatingwindow004(dt);
    });
    run('MultimediaGalleryFloatingwindow005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [智慧相册悬浮窗操作] TID: Multimedia_Gallery_Floatingwindow_005
      await multimediaGalleryFloatingwindow005(dt);
    });
    run('MultimediaGalleryFloatingwindow006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [搜索页面悬浮窗操作] TID: Multimedia_Gallery_Floatingwindow_006
      await multimediaGalleryFloatingwindow006(dt);
    });
    run('MultimediaGalleryFloatingwindow008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-进入大图用例: [相册宫格页悬浮窗操作] TID: Multimedia_Gallery_Floatingwindow_008
      await multimediaGalleryFloatingwindow008(dt);
    });
    run('MultimediaGallerylighlightFD018', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [智慧分析过程中，多次在时刻前台查询进度，进度提示语实时更新] TID: Multimedia_Gallery_lighlight_FD_018
      await multimediaGallerylighlightFD018(dt);
    });
    run('MultimediaGallerylighlightFD104', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-沉浸用例: [时刻轮播界面检查] TID: Multimedia_Gallery_lighlight_FD_104
      await multimediaGallerylighlightFD104(dt);
    });
    run('MultimediaGallerylighlightFD106', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻轮播界面切后台/灭屏后亮屏时的播放状态检查] TID: Multimedia_Gallery_lighlight_FD_106
      await multimediaGallerylighlightFD106(dt);
    });
    run('MultimediaGallerylighlightFD108', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-端云用例: [时刻轮播云端图片展示效果] TID: Multimedia_Gallery_lighlight_FD_108
      await multimediaGallerylighlightFD108(dt);
    });
    run('MultimediaGallerylighlightFD109', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻轮播界面稳定性测试（多张图片播放时间长）] TID: Multimedia_Gallery_lighlight_FD_109
      await multimediaGallerylighlightFD109(dt);
    });
    run('MultimediaGallerylighlightFD111', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻一级界面冷热启动持久化检查] TID: Multimedia_Gallery_lighlight_FD_111
      await multimediaGallerylighlightFD111(dt);
    });
    run('MultimediaGallerylighlightFD113', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻一级界面空界面展示] TID: Multimedia_Gallery_lighlight_FD_113
      await multimediaGallerylighlightFD113(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryFilesmoves002').init();
      dt.log.i('afterEach MultimediaGalleryFilesmoves002 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryFilesmoves002 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryFilesmoves002').init();
      dt.log.i('afterAll MultimediaGalleryFilesmoves002 start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryFilesmoves002 finish');
    });
  });
}

// DT步骤
/**
 * 宫格-大图: [PC端【更多】中【复制】选项变为【复制到剪切板】]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Files_moves_029
 * 前置条件
 * pc图库中存在图片
 */
async function multimediaGalleryFilesmoves029(dt: Dt) {
  dt.log.i('PC端【更多】中【复制】选项变为【复制到剪切板】 start');
  dt.log.i('STEP 1、点进大图，图片右上角点击【: :】，选择【复制到剪贴板】');

  await dt.sleep();
  dt.log.i('STEP 2、进入到文件系统中，鼠标右键选择粘贴');

  await dt.sleep();
  dt.log.i('预期结果2、图片可以正常复制到文件系统4、图片可以正常复制到文件系统');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点进图库宫格界面，选择图片，选择【: :】后，点击【复制到剪贴板】');

  await dt.sleep();
  dt.log.i('STEP 4、进入到文件系统中，鼠标右键选择粘贴');

  await dt.sleep();
  dt.log.i('预期结果4、图片可以正常复制到文件系统');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端【更多】中【复制】选项变为【复制到剪切板】 end');
}

/**
 * 宫格-删除: [隐藏相册和最近删除相册不支持移动]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_moves_030
 * 前置条件
 * 1.手机内预制不同图片资源
 2.手机内预制目标相册
 */
async function multimediaGalleryFilesmoves030(dt: Dt) {
  dt.log.i('隐藏相册和最近删除相册不支持移动 start');
  dt.log.i('STEP 1、进入隐藏相册、最近删除相册，点击宫格进入大图，点击更多观察是否有""移动到""选项');

  await dt.sleep();
  dt.log.i('预期结果1&2、隐藏相册和最近删除相册无”移动到“选项');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('移动到'));
  dt.log.i('STEP 2、进入隐藏相册、最近删除相册，进入多选界面未选择/已选择，检查是否有""移动到""选项');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册和最近删除相册不支持移动 end');
}

/**
 * 宫格-收藏: [重名文件移动至目标相册A弹窗提示]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Files_moves_031
 * 前置条件
 * 1.手机内预制不同图片资源
 2.手机有多个相册，如相册A中存在文件a

 */
async function multimediaGalleryFilesmoves031(dt: Dt) {
  dt.log.i('重名文件移动至目标相册A弹窗提示 start');
  dt.log.i('STEP 1、在系统相册（图片、视频、我的收藏）中将文件a（文件名，文件大小，角度都相同）移动到相册A');

  await dt.sleep();
  dt.log.i('预期结果1、弹框“发现重名文件”，提示用户是否“替换”、“跳过”、“取消”，且有后续文件执行相应操作勾选框，默认非勾选状态。');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('发现重名文件'));
  dt.log.i('STEP 2、横屏状态下界面检查');

  await dt.sleep();
  dt.log.i('预期结果2、横屏状态弹框显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('重名文件移动至目标相册A弹窗提示 end');
}

/**
 * 宫格-收藏: [重名文件移动至目标相册A，弹窗选择取消]
 * GROUP: 宫格 MODULE: 收藏TID: Multimedia_Gallery_Files_moves_032
 * 前置条件
 * 1.手机内预制不同图片资源
 2.手机有多个相册，如相册A中存在文件a

 */
async function multimediaGalleryFilesmoves032(dt: Dt) {
  dt.log.i('重名文件移动至目标相册A，弹窗选择取消 start');
  dt.log.i('STEP 1、在系统相册（图片、视频、我的收藏）中将文件a（文件名，文件大小，角度都相同）移动到相册A');

  await dt.sleep();
  dt.log.i('预期结果1、弹框“发现重名文件”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('发现重名文件'));
  dt.log.i('STEP 2、选择取消');

  await dt.sleep();
  dt.log.i('预期结果2、取消文件a的移动操作');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在系统相册（图片、视频、我的收藏）中将多个文件包含文件a（文件名，文件大小，角度都相同）移动到相册A');

  await dt.sleep();
  dt.log.i('预期结果3、弹框“发现重名文件”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('发现重名文件'));
  dt.log.i('STEP 4、选择取消');

  await dt.sleep();
  dt.log.i('预期结果4、取消所有重名文件的移动操作，未重名文件移动到目标相册中');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('重名文件移动至目标相册A，弹窗选择取消 end');
}


/**
 * 宫格-删除: [图片、视频相册，文件全部删除再恢复压力测试]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_MTBF_irregular_002
 * 前置条件
 * 1、图库有图片1000个、视频100个
 */
async function multimediaGalleryFilesMTBFirregular002(dt: Dt) {
  dt.log.i('图片、视频相册，文件全部删除再恢复压力测试 start');
  dt.log.i('STEP 1、图片相册-全选，点击删除');

  await dt.sleep();
  dt.log.i('预期结果1、移除、恢复压力测试正常，无异常crash');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、视频相册-全选，点击删除');

  await dt.sleep();
  dt.log.i('STEP 3、再从最近删除-全选，点击恢复3、步骤1、2，反复操作100次');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片、视频相册，文件全部删除再恢复压力测试 end');
}

/**
 * 宫格-视频: [反复添加文件压力测试]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_Files_MTBF_irregular_003
 * 前置条件
 * 1、图库有图片10000个、视频100个
 */
async function multimediaGalleryFilesMTBFirregular003(dt: Dt) {
  dt.log.i('反复添加文件压力测试 start');
  dt.log.i('STEP 1、从照片页大图-移动到新建相册，反复操作100次');

  await dt.sleep();
  dt.log.i('预期结果1 2、反复操作正常，无异常crash');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从预制相册宫格-多选2个，移动到新建相册，反复操作100次');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('反复添加文件压力测试 end');
}

/**
 * 宫格-删除: [删除、移除菜单入口检查（用户创建相册：大图+宫格）]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_UX_Menu_check_001
 * 前置条件
 * 1、图库有预置相册（图片、视频、收藏）、新建相册、智慧相册、三方应用等
 */
async function multimediaGalleryFilesUXMenucheck001(dt: Dt) {
  dt.log.i('删除、移除菜单入口检查（用户创建相册：大图+宫格） start');
  dt.log.i('STEP 1、进入新建相册，点击任意缩略图，打开大图时，查看底部菜单');

  await dt.sleep();
  dt.log.i('预期结果1、大图底部删除入口显示正常，可点击；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入新建相册，点击多选-进入多选，有勾选/无勾选时，查看底部菜单、更多菜单');

  await dt.sleep();
  dt.log.i('预期结果2、多选底部删除入口、更多-菜单显示正常；有勾选时删除入口、菜单入口高亮，分享入口高亮，点击有响应；无勾选时，更多菜单全部置灰，不可点击；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('删除、移除菜单入口检查（用户创建相册：大图+宫格） end');
}

/**
 * 宫格-删除: [删除菜单入口检查（照片页、非用户创建相册：大图+宫格）]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_UX_Menu_check_002
 * 前置条件
 * 1、图库有预置相册（图片、视频、收藏）、新建相册、智慧相册、三方应用等
 */
async function multimediaGalleryFilesUXMenucheck002(dt: Dt) {
  dt.log.i('删除菜单入口检查（照片页、非用户创建相册：大图+宫格） start');
  dt.log.i('STEP 1、照片页，点击任意缩略图，打开大图时，查看底部菜单');

  await dt.sleep();
  dt.log.i('预期结果1 3、大图底部恢复入口显示删除，点击可删除');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、照片页，点击更多多选-进入多选，有勾选/无勾选时，查看底部菜单');

  await dt.sleep();
  dt.log.i('预期结果2 4、多选底部删除入口显示正常；有勾选时删除入口高亮，点击可删除；无勾选时，删除入口置灰，不可点击；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、非用户创建相册（如图片、视频、收藏等相册）宫格，点击缩略图打开大图时，查看底部菜单');

  await dt.sleep();
  dt.log.i('STEP 4、非用户创建相册（如图片、视频、收藏等相册）宫格，长按缩略图-进入多选，有勾选/无勾选时，查看底部菜单');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('删除菜单入口检查（照片页、非用户创建相册：大图+宫格） end');
}

/**
 * 宫格-删除: [恢复菜单入口检查（最近删除相册 大图+宫格）]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_UX_Menu_check_003
 * 前置条件
 * 1、图库有最近删除相册
 */
async function multimediaGalleryFilesUXMenucheck003(dt: Dt) {
  dt.log.i('恢复菜单入口检查（最近删除相册 大图+宫格） start');
  dt.log.i('STEP 1、最近删除相册，点击任意缩略图，打开大图时，查看底部菜单');

  await dt.sleep();
  dt.log.i('预期结果1、大图底部恢复入口显示正常，点击可恢复');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击更多多选-进入多选，有勾选/无勾选时，查看底部菜单');

  await dt.sleep();
  dt.log.i('预期结果2、多选底部恢复入口显示正常；有勾选时恢复入口高亮，点击可恢复；无勾选时，恢复入口置灰，不可点击');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('恢复菜单入口检查（最近删除相册 大图+宫格） end');
}

/**
 * 宫格-大图: [移动到菜单入口检查（照片页、非用户新建相册：大图+宫格）]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Files_UX_Menu_check_005
 * 前置条件
 * 1、图库有预制相册（图片、视频、收藏）、新建相册、智慧相册、三方应用等
 */
async function multimediaGalleryFilesUXMenucheck005(dt: Dt) {
  dt.log.i('移动到菜单入口检查（照片页、非用户新建相册：大图+宫格） start');
  dt.log.i('STEP 1、照片页，点击任意缩略图，打开大图时，查看右上角菜单 ');

  await dt.sleep();
  dt.log.i('预期结果1 2 3 4、菜单显示”移动到”，显示符合UX设计； ');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('移动到'));
  dt.log.i('STEP 2、照片页，点击多选-进入多选，有勾选/无勾选时，查看更多菜单 ');

  await dt.sleep();
  dt.log.i('预期结果2 4、有勾选时更多菜单高亮，可点击；无勾选时，更多菜单全部置灰，不可点击');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、非用户创建相册（如预制相册）宫格，点击缩略图打开大图时，查看右上角菜单 ');

  await dt.sleep();
  dt.log.i('STEP 4、非用户创建相册（如预制相册）宫格，点击多选-进入多选，有勾选/无勾选时，查看更多菜单');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('移动到菜单入口检查（照片页、非用户新建相册：大图+宫格） end');
}

/**
 * 宫格-大图: [添加菜单入口检查（用户新建相册：大图+宫格）]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Files_UX_Menu_check_006
 * 前置条件
 * 1、图库有预制相册（图片、视频、收藏）、新建相册、智慧相册、三方应用等
 */
async function multimediaGalleryFilesUXMenucheck006(dt: Dt) {
  dt.log.i('添加菜单入口检查（用户新建相册：大图+宫格） start');
  dt.log.i('STEP 1、进入新建相册，点击任意缩略图，打开大图时，查看右上角更多菜单');

  await dt.sleep();
  dt.log.i('预期结果1、更多菜单-按顺序显示”重命名相册、删除相册”等，符合UX设计');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('重命名相册、删除相册'));
  dt.log.i('STEP 2、进入新建相册，点击多选-进入多选，有勾选/无勾选时，查看更多菜单');

  await dt.sleep();
  dt.log.i('预期结果2、更多菜单-按顺序显示”移动到、收藏（取消收藏）、隐藏”等，符合UX设计2、有勾选时更多按钮入口高亮，点击有响应；无勾选时，更多菜单全部置灰，不可点击；');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('移动到、收藏（取消收藏）、隐藏'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('添加菜单入口检查（用户新建相册：大图+宫格） end');
}

/**
 * 宫格-大图: [移动菜单入口去除检查（用户新建相册：大图+宫格）]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Files_UX_Menu_check_007
 * 前置条件
 * 1、图库有预制相册（图片、视频、收藏）、新建相册、智慧相册、三方应用等

 */
async function multimediaGalleryFilesUXMenucheck007(dt: Dt) {
  dt.log.i('移动菜单入口去除检查（用户新建相册：大图+宫格） start');
  dt.log.i('STEP 1、进入新建相册，点击任意缩略图，打开大图时，查看更多菜单');

  await dt.sleep();
  dt.log.i('预期结果1、更多菜单-按顺序显示””添加到相册、从当前相册移除、重命名””，无””移动到相册””，符合UX设计；');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text(''));
  dt.log.i('STEP 2、进入新建相册，点击更多多选-进入多选，查看更多菜单');

  await dt.sleep();
  dt.log.i('预期结果2、更多菜单-按顺序显示””添加到相册、从当前相册移除、详细信息””等，无””移动到相册””，符合UX设计');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text(''));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('移动菜单入口去除检查（用户新建相册：大图+宫格） end');
}

/**
 * 宫格-进入大图: [照片页悬浮窗操作]
 * GROUP: 宫格 MODULE: 进入大图TID: Multimedia_Gallery_Floatingwindow_001
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function multimediaGalleryFloatingwindow001(dt: Dt) {
  dt.log.i('照片页悬浮窗操作 start');
  dt.log.i('STEP 1、在照片页上滑应用进入多任务，出现分屏和多窗入口，拖动应用进入多窗进入悬浮模式，点击应用，应用放大悬浮显示在页面中间');

  await dt.sleep();
  dt.log.i('预期结果1、2、3、4、5、6、7、8操作流畅，界面无异常，界面正常显示，符合UX设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在照片页点击“年月日”切换显示模式，上下滑动浏览查看图片');

  await dt.sleep();
  dt.log.i('STEP 3、点击切换照片页和相册页，点击图片缩略图进入大图模式');

  await dt.sleep();
  dt.log.i('STEP 4、在照片页点击多选进入多选模式，选择图片');

  await dt.sleep();
  dt.log.i('STEP 5、进行分享、对比，拼图、删除、添加到相册、复制和隐藏等操作');

  await dt.sleep();
  dt.log.i('STEP 6、进入设置和关于页面');

  await dt.sleep();
  dt.log.i('STEP 7、操作过程中拖动窗口，改变窗口大小，查看窗口内容显示');

  await dt.sleep();
  dt.log.i('STEP 8、点击悬浮窗口上方的三个点，可操作悬浮窗放大、缩小或者关闭');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页悬浮窗操作 end');
}

/**
 * 宫格-格式: [相册页悬浮窗操作]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Floatingwindow_002
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function multimediaGalleryFloatingwindow002(dt: Dt) {
  dt.log.i('相册页悬浮窗操作 start');
  dt.log.i('STEP 1、在相册页上滑应用进入多任务，出现分屏和多窗入口，拖动应用进入多窗进入悬浮模式，点击应用，应用放大悬浮显示在页面中间');

  await dt.sleep();
  dt.log.i('预期结果1、2、3、4、5、6、7操作流畅，界面无异常，界面正常显示，符合UX设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在相册页上下滑动浏览相册');

  await dt.sleep();
  dt.log.i('STEP 3、点击用户创建相册/非用户创建相册进入相册宫格页');

  await dt.sleep();
  dt.log.i('STEP 4、点击右上角的加号添加相册，给相册添加图片');

  await dt.sleep();
  dt.log.i('STEP 5、删除、重命名相册，多选相册进行操作');

  await dt.sleep();
  dt.log.i('STEP 6、操作过程中拖动窗口，改变窗口大小，查看窗口内容显示');

  await dt.sleep();
  dt.log.i('STEP 7、点击悬浮窗口上方的三个点，可操作悬浮窗放大、缩小或者关闭');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页悬浮窗操作 end');
}

/**
 * 宫格-大图: [大图页悬浮窗操作]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Floatingwindow_003
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function multimediaGalleryFloatingwindow003(dt: Dt) {
  dt.log.i('大图页悬浮窗操作 start');
  dt.log.i('STEP 1、在大图页面上滑应用进入多任务，出现分屏和多窗入口，拖动应用进入多窗进入悬浮模式，点击应用，应用放大悬浮显示在页面中间');

  await dt.sleep();
  dt.log.i('预期结果1、2、4、5、6操作流畅，界面无异常，界面正常显示，符合UX设计3、和正常情况不同，悬浮模式下详情页只显示详情部分，不显示图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在大图页面进行分享、收藏、编辑、删除、添加到相册、复制、隐藏、重命名、AI识字、AI分割等操作（不包含编辑页面）');

  await dt.sleep();
  dt.log.i('STEP 3、在大图页面上滑打开详情页');

  await dt.sleep();
  dt.log.i('预期结果3、和正常情况不同，悬浮模式下详情页只显示详情部分，不显示图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、双击缩放图片，双指捏合缩放图片');

  await dt.sleep();
  dt.log.i('STEP 5、操作过程中拖动窗口，改变窗口大小，查看窗口内容显示');

  await dt.sleep();
  dt.log.i('STEP 6、点击悬浮窗口上方的三个点，可操作悬浮窗放大、缩小或者关闭');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图页悬浮窗操作 end');
}

/**
 * 宫格-格式: [三方picker页面悬浮窗操作]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Floatingwindow_004
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function multimediaGalleryFloatingwindow004(dt: Dt) {
  dt.log.i('三方picker页面悬浮窗操作 start');
  dt.log.i('STEP 1、用备忘录等三方软件进入悬浮窗模式，拉起图库picker页面');

  await dt.sleep();
  dt.log.i('预期结果1、2、3、4、5、6操作流畅，界面无异常，界面正常显示，符合UX设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在picker页面选择图片');

  await dt.sleep();
  dt.log.i('STEP 3、点击图片左上角的小标放大图片');

  await dt.sleep();
  dt.log.i('STEP 4、点击编辑按钮跳转编辑页面');

  await dt.sleep();
  dt.log.i('STEP 5、操作过程中拖动窗口，改变窗口大小，查看窗口内容显示');

  await dt.sleep();
  dt.log.i('STEP 6、点击悬浮窗口上方的三个点，可操作悬浮窗放大、缩小或者关闭');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('三方picker页面悬浮窗操作 end');
}

/**
 * 宫格-格式: [智慧相册悬浮窗操作]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Floatingwindow_005
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 2、图库中存在智慧相册
 */
async function multimediaGalleryFloatingwindow005(dt: Dt) {
  dt.log.i('智慧相册悬浮窗操作 start');
  dt.log.i('STEP 1、在相册页上滑应用进入多任务，出现分屏和多窗入口，拖动应用进入多窗进入悬浮模式，点击应用，应用放大悬浮显示在页面中间');

  await dt.sleep();
  dt.log.i('预期结果1、2、3、4、5、6、7、8、9操作流畅，界面无异常，界面正常显示，符合UX设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、查看人像相册，并进行各种操作');

  await dt.sleep();
  dt.log.i('STEP 3、查看地点相册，并进行各种操作');

  await dt.sleep();
  dt.log.i('STEP 4、查看分类相册，并进行各种操作');

  await dt.sleep();
  dt.log.i('STEP 5、查看拍摄模式相册，并进行各种操作');

  await dt.sleep();
  dt.log.i('STEP 6、查看来自应用相册，并进行各种操作');

  await dt.sleep();
  dt.log.i('STEP 7、查看隐藏相册，最近删除相册，，并进行各种操作');

  await dt.sleep();
  dt.log.i('STEP 8、操作过程中拖动窗口，改变窗口大小，查看窗口内容显示');

  await dt.sleep();
  dt.log.i('STEP 9、点击悬浮窗口上方的三个点，可操作悬浮窗放大、缩小或者关闭');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧相册悬浮窗操作 end');
}

/**
 * 宫格-格式: [搜索页面悬浮窗操作]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_Floatingwindow_006
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 2、图库已经充电灭屏支持搜索
 */
async function multimediaGalleryFloatingwindow006(dt: Dt) {
  dt.log.i('搜索页面悬浮窗操作 start');
  dt.log.i('STEP 1、打开图库上滑应用进入多任务，出现分屏和多窗入口，拖动应用进入多窗进入悬浮模式，点击应用，应用放大悬浮显示在页面中间');

  await dt.sleep();
  dt.log.i('预期结果1、2、3、4、5操作流畅，界面无异常，界面正常显示，符合UX设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入搜索页面，查看页面显示是否正常');

  await dt.sleep();
  dt.log.i('STEP 3、输入搜索内容，进行搜索操作');

  await dt.sleep();
  dt.log.i('STEP 4、操作过程中拖动窗口，改变窗口大小，查看窗口内容显示');

  await dt.sleep();
  dt.log.i('STEP 5、点击悬浮窗口上方的三个点，可操作悬浮窗放大、缩小或者关闭');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('搜索页面悬浮窗操作 end');
}

/**
 * 宫格-进入大图: [相册宫格页悬浮窗操作]
 * GROUP: 宫格 MODULE: 进入大图TID: Multimedia_Gallery_Floatingwindow_008
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件

 */
async function multimediaGalleryFloatingwindow008(dt: Dt) {
  dt.log.i('相册宫格页悬浮窗操作 start');
  dt.log.i('STEP 1、在相册宫格页上滑应用进入多任务，出现分屏和多窗入口，拖动应用进入多窗进入悬浮模式，点击应用，应用放大悬浮显示在页面中间');

  await dt.sleep();
  dt.log.i('预期结果1、2、3、4、5、6、7、8操作流畅，界面无异常，界面正常显示，符合UX设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、上下滑动浏览查看图片');

  await dt.sleep();
  dt.log.i('STEP 3、点击图片缩略图进入大图模式');

  await dt.sleep();
  dt.log.i('STEP 4、在照片页点击多选进入多选模式，选择图片');

  await dt.sleep();
  dt.log.i('STEP 5、进行分享、对比，拼图、删除、添加到相册、复制、隐藏、从当前相册移除等操作');

  await dt.sleep();
  dt.log.i('STEP 6、点击加号按钮，往相册中添加图片');

  await dt.sleep();
  dt.log.i('STEP 7、操作过程中拖动窗口，改变窗口大小，查看窗口内容显示');

  await dt.sleep();
  dt.log.i('STEP 8、点击悬浮窗口上方的三个点，可操作悬浮窗放大、缩小或者关闭');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册宫格页悬浮窗操作 end');
}

/**
 * 宫格-: [智慧分析过程中，多次在时刻前台查询进度，进度提示语实时更新]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_018
 * 前置条件
 * 1.图库中存在未进行智慧分析的照片
 2.手机电量大于50%，充电灭屏分析
 */
async function multimediaGallerylighlightFD018(dt: Dt) {
  dt.log.i('智慧分析过程中，多次在时刻前台查询进度，进度提示语实时更新 start');
  dt.log.i('STEP 1.多次查看时刻一级界面查看图片分析进度');

  await dt.sleep();
  dt.log.i('预期结果1.1进度提示语实时更新1.2后台实时查询日志正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧分析过程中，多次在时刻前台查询进度，进度提示语实时更新 end');
}

/**
 * 宫格-沉浸: [时刻轮播界面检查]
 * GROUP: 宫格 MODULE: 沉浸TID: Multimedia_Gallery_lighlight_FD_104
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD104(dt: Dt) {
  dt.log.i('时刻轮播界面检查 start');
  dt.log.i('STEP 1.点击已经生成的时刻封面，进入二级剪辑播放界面');

  await dt.sleep();
  dt.log.i('预期结果1.直接进入沉浸式轮播界面，状态栏不显示，时刻界面按钮显示约2s后消失');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2、播放的素材为该时刻里的所有图片,最少有8张图片2、每个图片的播放时长（2秒）固定，播放过程没有转场，滤镜，以及音乐，图片之间以硬切的形式来转换覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播界面检查 end');
}

/**
 * 宫格-: [时刻轮播界面切后台/灭屏后亮屏时的播放状态检查]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_106
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD106(dt: Dt) {
  dt.log.i('时刻轮播界面切后台/灭屏后亮屏时的播放状态检查 start');
  dt.log.i('STEP 1.点击已经生成的时刻封面，进入二级剪辑播放界面');

  await dt.sleep();
  dt.log.i('预期结果1.切后台/灭屏后，时刻轮播暂停，回到图库/亮屏时轮播继续覆盖手机、xxx');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.切图库至后台/灭屏后亮屏');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播界面切后台/灭屏后亮屏时的播放状态检查 end');
}

/**
 * 宫格-端云: [时刻轮播云端图片展示效果]
 * GROUP: 宫格 MODULE: 端云TID: Multimedia_Gallery_lighlight_FD_108
 * 前置条件
 * 1.图库中存在可生成时刻的端云图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD108(dt: Dt) {
  dt.log.i('时刻轮播云端图片展示效果 start');
  dt.log.i('STEP 1.点击已经生成的时刻封面，进入二级剪辑播放界面');

  await dt.sleep();
  dt.log.i('预期结果1.轮播正常，动效流畅，无异常crash覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播云端图片展示效果 end');
}

/**
 * 宫格-: [时刻轮播界面稳定性测试（多张图片播放时间长）]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_109
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD109(dt: Dt) {
  dt.log.i('时刻轮播界面稳定性测试（多张图片播放时间长） start');
  dt.log.i('STEP 1.点击已经生成的时刻封面，进入二级剪辑播放界面');

  await dt.sleep();
  dt.log.i('预期结果1.轮播正常，播放过程中无灭屏覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播界面稳定性测试（多张图片播放时间长） end');
}

/**
 * 宫格-: [时刻一级界面冷热启动持久化检查]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_111
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD111(dt: Dt) {
  dt.log.i('时刻一级界面冷热启动持久化检查 start');
  dt.log.i('STEP 1.点击tabbar上的时刻tab进入时刻界面');

  await dt.sleep();
  dt.log.i('预期结果1.进入图库时直接展示时刻界面覆盖手机、xxx');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.杀掉图库进程，重新进入图库');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻一级界面冷热启动持久化检查 end');
}
/**
 * 宫格-: [时刻一级界面空界面展示]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_113
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD113(dt: Dt) {
  dt.log.i('时刻一级界面空界面展示 start');
  dt.log.i('STEP 1.点击tabbar上的时刻tab进入时刻界面');

  await dt.sleep();
  dt.log.i('预期结果1.界面无时刻相册展示，空界面展示默认图片，提示：熄屏并接入电源，完成智能分析覆盖手机、xxx');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻一级界面空界面展示 end');
}













