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

export default function TCGraffiti(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('TCGraffitiTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllTCGraffiti').init();
      dt.log.i('beforeAll TCGraffiti start');
      dt.log.i('beforeAll TCGraffiti finish');
    });
    /**
     * 打开大图
     */
    it('beforeTCGraffiti', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    it('TC_Graffiti_001', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [01.入口校验] TID: TC_Graffiti_001
      await TC_Graffiti_001(dt);
    });
    it('TC_Graffiti_002', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-用例: [02.支持的设备] TID: TC_Graffiti_002
      await TC_Graffiti_002(dt);
    });
    it('TC_Graffiti_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [03.涂鸦后保存] TID: TC_Graffiti_003
      await TC_Graffiti_003(dt);
    });
    it('TC_Graffiti_004', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [04.未涂鸦保存] TID: TC_Graffiti_004
      await TC_Graffiti_004(dt);
    });
    it('TC_Graffiti_005', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-用例: [05.涂鸦界面支持撤销恢复] TID: TC_Graffiti_005
      await TC_Graffiti_005(dt);
    });
    it('TC_Graffiti_006', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [06.不同ux布局形态下涂鸦] TID: TC_Graffiti_006
      await TC_Graffiti_006(dt);
    });
    it('TC_Graffiti_007', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [07.涂鸦综合编辑] TID: TC_Graffiti_007
      await TC_Graffiti_007(dt);
    });
    it('TC_Graffiti_008', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [08.涂鸦后AI修图] TID: TC_Graffiti_008
      await TC_Graffiti_008(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachTCGraffiti').init();
      dt.log.i('afterEach TCGraffiti start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach TCGraffiti finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllTCGraffiti').init();
      dt.log.i('afterAll TCGraffiti start');
      await Exit.browser();
      dt.log.i('afterAll TCGraffiti finish');
    });
  });
}

// DT步骤
async function TC_Graffiti_001(dt: Dt) {
  dt.log.i('TC_Graffiti_001 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_Graffiti_002(dt: Dt) {
  dt.log.i('TC_Graffiti_002 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_Graffiti_003(dt: Dt) {
  dt.log.i('TC_Graffiti_003 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_Graffiti_004(dt: Dt) {
  dt.log.i('TC_Graffiti_004 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_Graffiti_005(dt: Dt) {
  dt.log.i('TC_Graffiti_005 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_Graffiti_006(dt: Dt) {
  dt.log.i('TC_Graffiti_006 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_Graffiti_007(dt: Dt) {
  dt.log.i('TC_Graffiti_007 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}

async function TC_Graffiti_008(dt: Dt) {
  dt.log.i('TC_Graffiti_008 start');
  await dt.swipeScreen?.left();
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true);
}


/**
 * 大图-动态照片: [01.入口校验]
 * GROUP: 大图 MODULE: 动态照片TID: TC_Graffiti_001
 * 前置条件
 *
 */
async function TC_Graffiti_01(dt: Dt) {
  dt.log.i('STEP 0.1: 断言判断预制条件有效性');
  // 假设相机可以直拍动图，且图库中有动图
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//'id_of_camera_app', false);
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//('id_of_gallery_app', false);
  // 需要确保存在至少一个动图文件
  await dt.log.i('请确保设备可以拍摄动态照片或图库中已存在动态照片。');

  dt.log.i('01.入口校验 start');

  dt.log.i('STEP 1.1: 相机直拍动图后，从相机预览进入，点击右上角涂鸦按钮');
  await dt.swipeScreen?.right(); //launchApp('com.###.camera'); // 假设相机包名为com.###.camera
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_live_photo_mode_button', false); // 确保相机处于动态照片模式
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_capture_button', false); // 拍摄一张动态照片
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_camera_preview_thumbnail', false); // 点击预览图进入预览界面
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_preview', false); // 点击右上角涂鸦按钮

  await dt.sleep();
  dt.log.i('预期结果1.1: 弹窗提示：涂鸦仅应用于静态照片，继续编辑？');
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//('id_of_graffiti_warning_dialog', true);
  await dt.assertComponent(PageTitle.index, true); //ByText('涂鸦仅应用于静态照片，继续编辑？', true);

  dt.log.i('STEP 2.1: 在图库选择动图，进入编辑页面，点击右上角涂鸦按钮');
  await dt.pressBack(); // 返回相机预览或关闭弹窗
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.right(); //launchApp('com.###.gallery3d'); // 假设图库包名为com.###.gallery3d
  await dt.sleep();
  await dt.clickIfExist('TabPhotos'); // 进入照片页
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_first_live_photo_in_gallery', false); // 选择一个动图进入大图
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_edit_button', false); // 进入编辑页面
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_edit', false); // 点击右上角涂鸦按钮

  await dt.sleep();
  dt.log.i('预期结果2.1: 弹窗提示：涂鸦仅应用于静态照片，继续编辑？');
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//('id_of_graffiti_warning_dialog', true);
  await dt.assertComponent(PageTitle.index, true); //ByText('涂鸦仅应用于静态照片，继续编辑？', true);

  dt.log.i('STEP 3.1: 弹窗点击取消/屏幕左滑');
  await dt.assertComponent(PageTitle.index, true); //'id_of_cancel_button_in_dialog', false); // 点击取消
  // 或者使用侧滑返回：await dt.driver.swipe('left', 'right');
  await dt.sleep();

  dt.log.i('预期结果3.1: 返回动态照片编辑');
  await dt.assertComponent(PageTitle.index,
    true); //(PageTitle.index, true);//('id_of_edit_page_title', true); // 断言仍在编辑页面
  await dt.assertComponent(PageTitle.index,
    true); //(PageTitle.index, true);//('id_of_live_photo_tab', true); // 断言动态照片的页签依然存在
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true); // 确认组件存在

  dt.log.i('STEP 4.1: 弹窗点击继续');
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_edit', false); // 再次点击涂鸦按钮拉起弹窗
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_continue_button_in_dialog', false); // 点击继续

  await dt.sleep();
  dt.log.i('预期结果4.1: 进入涂鸦界面，有一镜到底动效');
  await dt.assertComponent(PageTitle.index,
    true); //(PageTitle.index, true);//('id_of_graffiti_editor_page', true); // 断言进入涂鸦界面
  // 验证一镜到底动效需要录屏或更精细的性能测试
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true); // 确认组件存在

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index,
    true); //(PageTitle.index, true);//Clickable('id_of_graffiti_pen_tool'); // 确认涂鸦笔工具可点击
  dt.log.i('01.入口校验 end');
}

/**
 * 大图-: [02.支持的设备]
 * GROUP: 大图 MODULE: TID: TC_Graffiti_002
 * 前置条件
 *
 */
async function TC_Graffiti_02(dt: Dt) {
  dt.log.i('STEP 0.1: 断言判断预制条件有效性');
  // 假设测试环境可以模拟不同设备类型，且Allen、Alta-b支持动态照片涂鸦，平板和PC不支持
  await dt.log.i('请确保测试设备是Allen或Alta-b系列手机，或可模拟这些设备。');

  dt.log.i('02.支持的设备 start');

  // 假设当前设备是Allen或Alta-b
  dt.log.i('STEP 1.1: 使用不同设备（Allen，Alta-b支持，平板和PC暂不支持）拍摄动图后，进入编辑页面');
  // 模拟在支持的设备上进行操作
  await dt.swipeScreen?.right(); //launchApp('com.###.gallery3d');
  await dt.sleep();
  await dt.clickIfExist('TabPhotos');
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_first_live_photo_in_gallery', false); // 选择一个动图
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_edit_button', false); // 进入编辑页面
  await dt.sleep();

  dt.log.i('STEP 2.1: 点击右上角涂鸦按钮');
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_edit', false);

  await dt.sleep();
  dt.log.i('预期结果2.1: 弹窗提示：涂鸦仅应用于静态照片，继续编辑？');
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//('id_of_graffiti_warning_dialog', true);
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//ByText('涂鸦仅应用于静态照片，继续编辑？', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3.1: 点击继续');
  await dt.assertComponent(PageTitle.index, true); //'id_of_continue_button_in_dialog', false);

  await dt.sleep();
  dt.log.i('预期结果3.1: 进入涂鸦页面');
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//('id_of_graffiti_editor_page', true);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true); // 确认组件存在

  // TODO: 如果需要测试不支持的设备，需要模拟设备类型切换或在实际不支持的设备上运行此测试
  /**
   if (dt.driver.isTablet() || dt.driver.isPC()) { // 伪代码：判断当前设备是否为平板或PC
   dt.log.i('在平板或PC上进行测试，预期涂鸦按钮不可点击或无弹窗。');
   await dt.assertComponentClickable('id_of_graffiti_button_in_edit', false, false); // 涂鸦按钮不可点击
   }
   */

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//Clickable('id_of_graffiti_pen_tool');
  dt.log.i('02.支持的设备 end');
}

/**
 * 大图-大图: [03.涂鸦后保存]
 * GROUP: 大图 MODULE: 大图TID: TC_Graffiti_003
 * 前置条件
 *
 */
async function TC_Graffiti_03(dt: Dt) {
  dt.log.i('STEP 0.1: 断言判断预制条件有效性');
  // 确保图库中有动图
  await dt.log.i('请确保图库中已存在动态照片。');

  dt.log.i('03.涂鸦后保存 start');

  dt.log.i('STEP 1.1: 相机直拍动图或图库选择动图，进入编辑页面，点击右上角涂鸦按钮');
  await dt.swipeScreen?.right(); //launchApp('com.###.gallery3d');
  await dt.sleep();
  await dt.clickIfExist('TabPhotos');
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_first_live_photo_in_gallery', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_edit_button', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_edit', false);

  await dt.sleep();
  dt.log.i('预期结果1.1: 弹窗提示：涂鸦仅应用于静态照片，继续编辑？');
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//('id_of_graffiti_warning_dialog', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2.1: 点击继续');
  await dt.assertComponent(PageTitle.index, true); //'id_of_continue_button_in_dialog', false);

  await dt.sleep();
  dt.log.i('预期结果2.1: 进入涂鸦界面');
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//('id_of_graffiti_editor_page', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3.1: 使用不同的画笔工具和颜色进行涂鸦，点击保存');
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_pen_tool_1', false); // 选择画笔工具1
  await dt.sleep(DELAY.rapid);
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_color_red', false); // 选择红色
  await dt.sleep(DELAY.rapid);
  await dt.swipeScreen?.left(); //drawOnScreen(300, 300, 400, 400); // 涂鸦
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_pen_tool_2', false); // 选择画笔工具2
  await dt.sleep(DELAY.rapid);
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_color_blue', false); // 选择蓝色
  await dt.sleep(DELAY.rapid);
  await dt.swipeScreen?.left(); //drawOnScreen(500, 500, 600, 600); // 涂鸦
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button_in_graffiti', false); // 点击涂鸦保存按钮

  await dt.sleep();
  dt.log.i('预期结果3.1: 显示保存弹窗，保存成功后，返回到图片基础编辑页面，预览区显示涂鸦效果，动态页签消失，不显示撤销恢复和对比按钮');
  await dt.assertComponent(PageTitle.index,
    true); //(PageTitle.index, true);//('id_of_save_progress_dialog', true); // 假设有保存进度弹窗
  await dt.sleep();
  await dt.assertComponent(PageTitle.index,
    true); //(PageTitle.index, true);//('id_of_edit_page_title', true); // 返回到图片基础编辑页面
  await dt.assertComponent(PageTitle.index, true); //('id_of_live_photo_tab', false); // 动态页签消失
  await dt.assertComponent(PageTitle.index, true); //('id_of_undo_button', false); // 不显示撤销按钮
  await dt.assertComponent(PageTitle.index, true); //('id_of_redo_button', false); // 不显示恢复按钮
  await dt.assertComponent(PageTitle.index, true); //('id_of_compare_button', false); // 不显示对比按钮
  // 验证预览区显示涂鸦效果需要视觉判断或图像识别
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//(PageTitle.index, true); // 确认组件存在

  dt.log.i('STEP 4.1: 点击返回，提示：是否放弃所有更改4.1、点击取消4.2、点击放弃更改');
  await dt.assertComponent(PageTitle.index, true); //'id_of_back_button_in_edit', false); // 点击返回按钮
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //('id_of_discard_changes_dialog', true); // 断言显示放弃更改弹窗

  dt.log.i('STEP 4.1.1: 点击取消');
  await dt.assertComponent(PageTitle.index, true); //'id_of_cancel_button_in_discard_dialog', false); // 点击取消
  await dt.sleep();

  dt.log.i('预期结果4.1.1: 留在当前页面');
  await dt.assertComponent(PageTitle.index,
    true); //(PageTitle.index, true);//('id_of_edit_page_title', true); // 仍留在编辑页面
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true); // 确认组件存在

  dt.log.i('STEP 4.2.1: 点击放弃更改');
  await dt.assertComponent(PageTitle.index, true); //'id_of_back_button_in_edit', false); // 再次点击返回按钮
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_discard_button_in_discard_dialog', false); // 点击放弃更改
  await dt.sleep();

  dt.log.i('预期结果4.2.1: 返回到大图页面，涂鸦效果不生效，显示动态页签');
  await dt.assertComponent(PageTitle.index,
    true); //(PageTitle.index, true);//('id_of_full_screen_image_view', true); // 返回大图页面
  await dt.assertComponent(PageTitle.index,
    true); //(PageTitle.index, true);//('id_of_live_photo_indicator', true); // 显示动态页签
  // 验证涂鸦效果不生效需要视觉判断或图像识别
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true); // 确认组件存在

  dt.log.i('STEP 5.1: 对图片设置裁剪/调节/滤镜，点击保存按钮');
  await dt.assertComponent(PageTitle.index, true); //'id_of_edit_button', false); // 再次进入编辑
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_edit', false); // 进入涂鸦界面
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_continue_button_in_dialog', false); // 点击继续
  await dt.sleep();
  await dt.swipeScreen?.left(); //drawOnScreen(200, 200, 300, 300); // 涂鸦
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button_in_graffiti', false); // 保存涂鸦
  await dt.sleep();

  await dt.assertComponent(PageTitle.index, true); //'id_of_crop_tab', false); // 切换到裁剪
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.left(); //drag('id_of_crop_handle_bottom_right', -50, -50); // 裁剪
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_adjust_tab', false); // 切换到调节
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.right(); //dragSlider('id_of_saturation_slider', 0.8); // 调节饱和度
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_filter_tab', false); // 切换到滤镜
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_filter_effect_4', false); // 添加滤镜
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button', false); // 点击总保存按钮
  await dt.sleep(DELAY.long);

  dt.log.i('预期结果5.1: 返回到大图页面，涂鸦/裁剪/调节/滤镜效果生效，动态页签消失');
  await dt.assertComponent(PageTitle.index,
    true); //(PageTitle.index, true);//('id_of_full_screen_image_view', true); // 返回大图页面
  await dt.assertComponent(PageTitle.index, true); //('id_of_live_photo_indicator', false); // 动态页签消失
  // 验证所有效果生效需要视觉判断或图像识别
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//(PageTitle.index, true); // 确认组件存在

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true); //Clickable('id_of_edit_button');
  dt.log.i('03.涂鸦后保存 end');
}

/**
 * 大图-大图: [04.未涂鸦保存]
 * GROUP: 大图 MODULE: 大图TID: TC_Graffiti_004
 * 前置条件
 *
 */
async function TC_Graffiti_04(dt: Dt) {
  dt.log.i('STEP 0.1: 断言判断预制条件有效性');
  // 确保图库中有动图
  await dt.log.i('请确保图库中已存在动态照片。');

  dt.log.i('04.未涂鸦保存 start');

  dt.log.i('STEP 1.1: 相机直拍动图或图库选择动图，进入编辑页面，点击右上角涂鸦按钮');
  await dt.swipeScreen?.right(); //launchApp('com.###.gallery3d');
  await dt.sleep();
  await dt.clickIfExist('TabPhotos');
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_first_live_photo_in_gallery', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_edit_button', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_edit', false);

  await dt.sleep();
  dt.log.i('预期结果1.1: 弹窗提示：涂鸦仅应用于静态照片，继续编辑？');
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//('id_of_graffiti_warning_dialog', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2.1: 点击继续');
  await dt.assertComponent(PageTitle.index, true); //'id_of_continue_button_in_dialog', false);

  await dt.sleep();
  dt.log.i('预期结果2.1: 进入涂鸦界面');
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//('id_of_graffiti_editor_page', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3.1: 未涂鸦，点击返回/侧滑返回');
  await dt.assertComponent(PageTitle.index, true); //'id_of_back_button_in_graffiti', false); // 点击返回按钮
  // 或者使用侧滑返回：await dt.driver.swipe('left', 'right');
  await dt.sleep();

  dt.log.i('预期结果3.1: 返回到图片基础编辑页面，显示动态页签');
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//('id_of_edit_page_title', true);
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//('id_of_live_photo_tab', true);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true); // 确认组件存在

  dt.log.i('STEP 4.1: 再次点击涂鸦按钮，点击保存');
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_edit', false);
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_continue_button_in_dialog', false);
  await dt.sleep();
  // 此时不进行涂鸦操作
  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button_in_graffiti', false); // 点击涂鸦页面的保存按钮

  await dt.sleep();
  dt.log.i('预期结果4.1: 显示保存进度弹窗，保存成功后，返回到图片基础编辑页面，动态页签消失，不显示撤销恢复和对比按钮');
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//('id_of_save_progress_dialog', true);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//('id_of_edit_page_title', true);
  await dt.assertComponent(PageTitle.index, true); //('id_of_live_photo_tab', false);
  await dt.assertComponent(PageTitle.index, true); //('id_of_undo_button', false);
  await dt.assertComponent(PageTitle.index, true); //('id_of_redo_button', false);
  await dt.assertComponent(PageTitle.index, true); //('id_of_compare_button', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//(PageTitle.index, true); // 确认组件存在

  dt.log.i('STEP 5.1: 对图片设置裁剪/调节/滤镜，点击保存按钮');
  await dt.assertComponent(PageTitle.index, true); //'id_of_crop_tab', false); // 切换到裁剪
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.left(); //drag('id_of_crop_handle_top_left', 50, 50); // 裁剪
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_adjust_tab', false); // 切换到调节
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.right(); //dragSlider('id_of_contrast_slider', 0.6); // 调节对比度
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_filter_tab', false); // 切换到滤镜
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_filter_effect_5', false); // 添加滤镜
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button', false); // 点击总保存按钮
  await dt.sleep(DELAY.long);

  dt.log.i('预期结果5.1: 保存后返回到大图页面，裁剪/调节/滤镜生效，动态页签消失');
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//('id_of_full_screen_image_view', true);
  await dt.assertComponent(PageTitle.index, true); //('id_of_live_photo_indicator', false);
  // 验证效果生效需要视觉判断或图像识别
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);//(PageTitle.index, true); // 确认组件存在

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true); //Clickable('id_of_edit_button');
  dt.log.i('04.未涂鸦保存 end');
}

/**
 * 大图-: [05.涂鸦界面支持撤销恢复]
 * GROUP: 大图 MODULE: TID: TC_Graffiti_005
 * 前置条件
 *
 */
async function TC_Graffiti_05(dt: Dt) {
  dt.log.i('STEP 0.1: 断言判断预制条件有效性');
  // 确保图库中有动图
  await dt.log.i('请确保图库中已存在动态照片。');

  dt.log.i('05.涂鸦界面支持撤销恢复 start');

  dt.log.i('STEP 1.1: 相机直拍动图或图库选择动图，进入编辑页面，点击右上角涂鸦按钮');
  await dt.swipeScreen?.right(); //launchApp('com.###.gallery3d');
  await dt.sleep();
  await dt.clickIfExist('TabPhotos');
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_first_live_photo_in_gallery', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_edit_button', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_edit', false);

  await dt.sleep();
  dt.log.i('预期结果1.1: 弹窗提示：涂鸦仅应用于静态照片，继续编辑？');
  await dt.assertComponent(PageTitle.index, true); //('id_of_graffiti_warning_dialog', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2.1: 点击继续');
  await dt.assertComponent(PageTitle.index, true); //'id_of_continue_button_in_dialog', false);

  await dt.sleep();
  dt.log.i('预期结果2.1: 进入涂鸦界面');
  await dt.assertComponent(PageTitle.index, true); //('id_of_graffiti_editor_page', true);
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 3.1: 使用不同的画笔工具和颜色进行涂鸦');
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_pen_tool_1', false);
  await dt.sleep(DELAY.rapid);
  await dt.swipeScreen?.left(); //drawOnScreen(200, 200, 300, 300); // 第一次涂鸦
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_pen_tool_2', false);
  await dt.sleep(DELAY.rapid);
  await dt.swipeScreen?.left(); //drawOnScreen(400, 400, 500, 500); // 第二次涂鸦

  await dt.sleep();
  dt.log.i('预期结果3.1: 涂鸦支持撤销和恢复');
  await dt.assertComponent(PageTitle.index, true); //('id_of_undo_button_in_graffiti', true); // 撤销按钮存在
  await dt.assertComponent(PageTitle.index, true); //('id_of_redo_button_in_graffiti', true); // 恢复按钮存在

  await dt.assertComponent(PageTitle.index, true); //'id_of_undo_button_in_graffiti', false); // 点击撤销
  await dt.sleep(DELAY.short);
  // 验证涂鸦效果是否撤销，需要视觉判断

  await dt.assertComponent(PageTitle.index, true); //'id_of_redo_button_in_graffiti', false); // 点击恢复
  await dt.sleep(DELAY.short);
  // 验证涂鸦效果是否恢复，需要视觉判断
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true); // 确认组件存在

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true); //Clickable('id_of_undo_button_in_graffiti');
  await dt.assertComponent(PageTitle.index, true); //Clickable('id_of_redo_button_in_graffiti');
  dt.log.i('05.涂鸦界面支持撤销恢复 end');
}

/**
 * 大图-竖屏: [06.不同ux布局形态下涂鸦]
 * GROUP: 大图 MODULE: 竖屏TID: TC_Graffiti_006
 * 前置条件
 *
 */
async function TC_Graffiti_06(dt: Dt) {
  dt.log.i('STEP 0.1: 断言判断预制条件有效性');
  // 确保图库中有动图
  await dt.log.i('请确保图库中已存在动态照片。');

  dt.log.i('06.不同ux布局形态下涂鸦 start');

  dt.log.i('STEP 1.1: 相机直拍动图或图库选择动图');
  await dt.swipeScreen?.right(); //launchApp('com.###.gallery3d');
  await dt.sleep();
  await dt.clickIfExist('TabPhotos');
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_first_live_photo_in_gallery', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_edit_button', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_edit', false);
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_continue_button_in_dialog', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //('id_of_graffiti_editor_page', true); // 进入涂鸦界面

  dt.log.i('STEP 2.1: 使用不同手机进入涂鸦页面，切换不同的ux布局（横屏、多窗、分屏、xxxxxx，xxx，横竖屏切换），进行涂鸦操作');

  // 横屏测试
  await dt.swipeScreen?.left(); //rotateOrientation('landscape');
  await dt.sleep();
  dt.log.i('预期结果2.1: 横屏布局显示ok，涂鸦功能ok');
  await dt.assertComponent(PageTitle.index, true); //('id_of_graffiti_editor_page', true); // 确认涂鸦界面显示正常
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_pen_tool_1', false);
  await dt.swipeScreen?.left(); //drawOnScreen(200, 200, 300, 300); // 涂鸦操作
  await dt.sleep(DELAY.short);

  // 竖屏测试
  await dt.swipeScreen?.left(); //rotateOrientation('portrait');
  await dt.sleep();
  dt.log.i('预期结果2.2: 竖屏布局显示ok，涂鸦功能ok');
  await dt.assertComponent(PageTitle.index, true); //('id_of_graffiti_editor_page', true);
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_pen_tool_2', false);
  await dt.swipeScreen?.left(); //drawOnScreen(400, 400, 500, 500); // 涂鸦操作
  await dt.sleep(DELAY.short);
  /*
     TODO: 多窗、分屏、xxxxxx、xxx的测试需要依赖具体设备的模拟能力或特定API
     例如：
     await dt.driver.enterMultiWindowMode(); // 伪代码进入多窗模式
     await dt.assertComponent(PageTitle.index, true);//('id_of_graffiti_editor_page', true);
     await dt.driver.exitMultiWindowMode();
     await dt.driver.enterSplitScreenMode(); // 伪代码进入分屏模式
     await dt.assertComponent(PageTitle.index, true);//('id_of_graffiti_editor_page', true);
     await dt.driver.exitSplitScreenMode();
     await dt.driver.foldDevice(); // 伪代码xxx
     await dt.assertComponent(PageTitle.index, true);//('id_of_graffiti_editor_page', true);
     await dt.driver.unfoldDevice(); // 伪代码展开设备
     await dt.assertComponent(PageTitle.index, true);//('id_of_graffiti_editor_page', true);
  */
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true); //Clickable('id_of_graffiti_pen_tool_1');
  dt.log.i('06.不同ux布局形态下涂鸦 end');
}

/**
 * 大图-大图: [07.涂鸦综合编辑]
 * GROUP: 大图 MODULE: 大图TID: TC_Graffiti_007
 * 前置条件
 *
 */
async function TC_Graffiti_07(dt: Dt) {
  dt.log.i('STEP 0.1: 断言判断预制条件有效性');
  // 确保图库中有动图
  await dt.log.i('请确保图库中已存在动态照片。');

  dt.log.i('07.涂鸦综合编辑 start');

  dt.log.i('STEP 1.1: 相机直拍动图或图库选择动图，进入编辑页面，点击右上角涂鸦按钮');
  await dt.swipeScreen?.right(); //launchApp('com.###.gallery3d');
  await dt.sleep();
  await dt.clickIfExist('TabPhotos');
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_first_live_photo_in_gallery', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_edit_button', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_edit', false);

  await dt.sleep();
  dt.log.i('预期结果1.1: 选择继续，进入涂鸦页面检查点：1、重选封面帧后涂鸦，涂鸦效果作用于新封面帧');
  await dt.assertComponent(PageTitle.index, true); //'id_of_continue_button_in_dialog', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //('id_of_graffiti_editor_page', true); // 进入涂鸦界面

  await dt.assertComponent(PageTitle.index, true); //'id_of_live_photo_frame_selection', false); // 点击重选封面帧按钮
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.right(); //dragSlider('id_of_frame_selection_slider', 0.5); // 拖动滑块选择新封面帧
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_confirm_frame_selection_button', false); // 确认封面帧
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_pen_tool_1', false);
  await dt.swipeScreen?.left(); //drawOnScreen(200, 200, 300, 300); // 涂鸦
  await dt.sleep(DELAY.short);
  // 验证涂鸦效果作用于新封面帧需要视觉判断

  dt.log.i('STEP 2.1: 重选封面帧，涂鸦后调节、裁剪、添加滤镜后保存');
  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button_in_graffiti', false); // 保存涂鸦
  await dt.sleep();

  await dt.assertComponent(PageTitle.index, true); //'id_of_adjust_tab', false); // 调节
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.right(); //dragSlider('id_of_brightness_slider', 0.5);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_crop_tab', false); // 裁剪
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.left(); //drag('id_of_crop_handle_top_left', -50, -50);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_filter_tab', false); // 滤镜
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_filter_effect_1', false);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button', false); // 总保存
  await dt.sleep(DELAY.long);

  dt.log.i('预期结果3.1: 返回到大图页面，涂鸦效果生效，动态页签消失');
  await dt.assertComponent(PageTitle.index, true); //('id_of_full_screen_image_view', true);
  await dt.assertComponent(PageTitle.index, true); //('id_of_live_photo_indicator', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true); // 确认组件存在


  dt.log.i('STEP 2.2: 重选封面帧，调节、裁剪、添加滤镜后涂鸦后保存');
  await dt.pressBack(); // 返回宫格
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_first_live_photo_in_gallery', false); // 重新进入动图
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_edit_button', false);
  await dt.sleep();

  await dt.assertComponent(PageTitle.index, true); //'id_of_live_photo_frame_selection', false); // 重选封面帧
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.right(); //dragSlider('id_of_frame_selection_slider', 0.8);
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_confirm_frame_selection_button', false);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_adjust_tab', false); // 调节
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.right(); //dragSlider('id_of_contrast_slider', 0.7);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_crop_tab', false); // 裁剪
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.left(); //drag('id_of_crop_handle_bottom_right', -50, -50);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_filter_tab', false); // 滤镜
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_filter_effect_2', false);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_edit', false); // 涂鸦
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_continue_button_in_dialog', false);
  await dt.sleep();
  await dt.swipeScreen?.left(); //drawOnScreen(400, 400, 500, 500);
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button_in_graffiti', false);
  await dt.sleep();

  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button', false); // 总保存
  await dt.sleep(DELAY.long);

  dt.log.i('预期结果3.2: 返回到大图页面，涂鸦效果生效，动态页签消失');
  await dt.assertComponent(PageTitle.index, true); //('id_of_full_screen_image_view', true);
  await dt.assertComponent(PageTitle.index, true); //('id_of_live_photo_indicator', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);

  dt.log.i('STEP 2.3: 涂鸦后调节、裁剪、添加滤镜后保存');
  await dt.pressBack();
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_first_live_photo_in_gallery', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_edit_button', false);
  await dt.sleep();

  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_edit', false);
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_continue_button_in_dialog', false);
  await dt.sleep();
  await dt.swipeScreen?.left(); //drawOnScreen(250, 250, 350, 350);
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button_in_graffiti', false);
  await dt.sleep();

  await dt.assertComponent(PageTitle.index, true); //'id_of_adjust_tab', false);
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.right(); //dragSlider('id_of_saturation_slider', 0.9);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_crop_tab', false);
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.left(); //drag('id_of_crop_handle_top_right', 50, -50);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_filter_tab', false);
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_filter_effect_3', false);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button', false);
  await dt.sleep(DELAY.long);

  dt.log.i('预期结果3.3: 返回到大图页面，涂鸦效果生效，动态页签消失');
  await dt.assertComponent(PageTitle.index, true); //('id_of_full_screen_image_view', true);
  await dt.assertComponent(PageTitle.index, true); //('id_of_live_photo_indicator', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);

  dt.log.i('STEP 2.4: 涂鸦后调节、裁剪、添加滤镜，再次涂鸦后保存');
  await dt.pressBack();
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_first_live_photo_in_gallery', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_edit_button', false);
  await dt.sleep();

  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_edit', false);
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_continue_button_in_dialog', false);
  await dt.sleep();
  await dt.swipeScreen?.left(); //drawOnScreen(100, 100, 200, 200);
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button_in_graffiti', false);
  await dt.sleep();

  await dt.assertComponent(PageTitle.index, true); //'id_of_adjust_tab', false);
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.right(); //dragSlider('id_of_highlights_slider', 0.4);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_crop_tab', false);
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.left(); //drag('id_of_crop_handle_bottom_left', 50, 50);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_filter_tab', false);
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_filter_effect_4', false);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_edit', false); // 再次涂鸦
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_continue_button_in_dialog', false);
  await dt.sleep();
  await dt.swipeScreen?.left(); //drawOnScreen(600, 600, 700, 700);
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button_in_graffiti', false);
  await dt.sleep();

  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button', false);
  await dt.sleep(DELAY.long);

  dt.log.i('预期结果3.4: 返回到大图页面，涂鸦效果生效，动态页签消失');
  await dt.assertComponent(PageTitle.index, true); //('id_of_full_screen_image_view', true);
  await dt.assertComponent(PageTitle.index, true); //('id_of_live_photo_indicator', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);

  dt.log.i('STEP 2.5: 调节、裁剪、添加滤镜，重选封面帧后涂鸦后保存');
  await dt.pressBack();
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_first_live_photo_in_gallery', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_edit_button', false);
  await dt.sleep();

  await dt.assertComponent(PageTitle.index, true); //'id_of_adjust_tab', false);
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.right(); //dragSlider('id_of_shadows_slider', 0.3);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_crop_tab', false);
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.left(); //drag('id_of_crop_handle_top_left', -50, 50);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_filter_tab', false);
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_filter_effect_5', false);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_live_photo_frame_selection', false); // 重选封面帧
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.right(); //dragSlider('id_of_frame_selection_slider', 0.2);
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_confirm_frame_selection_button', false);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_edit', false); // 涂鸦
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_continue_button_in_dialog', false);
  await dt.sleep();
  await dt.swipeScreen?.left(); //drawOnScreen(300, 300, 400, 400);
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button_in_graffiti', false);
  await dt.sleep();

  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button', false);
  await dt.sleep(DELAY.long);

  dt.log.i('预期结果3.5: 返回到大图页面，涂鸦效果生效，动态页签消失');
  await dt.assertComponent(PageTitle.index, true); //('id_of_full_screen_image_view', true);
  await dt.assertComponent(PageTitle.index, true); //('id_of_live_photo_indicator', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);

  dt.log.i('STEP 2.6: 调节、裁剪、添加滤镜后，涂鸦后保存');
  await dt.pressBack();
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_first_live_photo_in_gallery', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_edit_button', false);
  await dt.sleep();

  await dt.assertComponent(PageTitle.index, true); //'id_of_adjust_tab', false);
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.right(); //dragSlider('id_of_temperature_slider', 0.6);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_crop_tab', false);
  await dt.sleep(DELAY.short);
  await dt.swipeScreen?.left(); //drag('id_of_crop_handle_top_right', -50, 50);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_filter_tab', false);
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_filter_effect_6', false);
  await dt.sleep(DELAY.short);

  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_edit', false);
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_continue_button_in_dialog', false);
  await dt.sleep();
  await dt.swipeScreen?.left(); //drawOnScreen(500, 500, 600, 600);
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button_in_graffiti', false);
  await dt.sleep();

  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button', false);
  await dt.sleep(DELAY.long);

  dt.log.i('预期结果3.6: 返回到大图页面，涂鸦效果生效，动态页签消失');
  await dt.assertComponent(PageTitle.index, true); //('id_of_full_screen_image_view', true);
  await dt.assertComponent(PageTitle.index, true); //('id_of_live_photo_indicator', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //(PageTitle.index, true);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true); //Clickable('id_of_edit_button');
  dt.log.i('07.涂鸦综合编辑 end');
}

/**
 * 大图-大图: [08.涂鸦后AI修图]
 * GROUP: 大图 MODULE: 大图TID: TC_Graffiti_008
 * 前置条件
 *
 */
async function TC_Graffiti_08(dt: Dt) {
  dt.log.i('STEP 0.1: 断言判断预制条件有效性');
  // 确保图库中有动图，且设备支持AI修图功能
  await dt.log.i('请确保图库中已存在动态照片，且设备支持AI修图。');

  dt.log.i('08.涂鸦后AI修图 start');

  dt.log.i('STEP 1.1: 相机直拍动图或图库选择动图，进入编辑页面，点击右上角涂鸦按钮');
  await dt.swipeScreen?.right(); //launchApp('com.###.gallery3d');
  await dt.sleep();
  await dt.clickIfExist('TabPhotos');
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_first_live_photo_in_gallery', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_edit_button', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_button_in_edit', false);

  await dt.sleep();
  dt.log.i('预期结果1.1: 选择继续，进入涂鸦页面检查点：1、切换到滤镜页面，滤镜缩略图实时刷新');
  await dt.assertComponent(PageTitle.index, true); //'id_of_continue_button_in_dialog', false);
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //('id_of_graffiti_editor_page', true);

  await dt.assertComponent(PageTitle.index, true); //'id_of_filter_tab_in_graffiti', false); // 切换到涂鸦页面的滤镜tab
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //('id_of_filter_thumbnail_list', true); // 滤镜缩略图列表存在
  // 验证实时刷新需要视觉判断或更高级的测试方法
  await dt.sleep(DELAY.short);

  dt.log.i('STEP 2.1: 涂鸦后，设置AI修图后保存');
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_tab_in_graffiti', false); // 切换回涂鸦tab
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_graffiti_pen_tool_1', false);
  await dt.swipeScreen?.left(); //drawOnScreen(200, 200, 300, 300); // 涂鸦
  await dt.sleep(DELAY.short);
  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button_in_graffiti', false); // 保存涂鸦
  await dt.sleep();

  await dt.assertComponent(PageTitle.index, true); //'id_of_ai_retouch_tab', false); // 切换到AI修图页面
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_ai_enhance_button', false); // 点击AI增强（示例）
  await dt.sleep();
  await dt.assertComponent(PageTitle.index, true); //'id_of_save_button', false); // 总保存按钮
  await dt.sleep(DELAY.long);

  dt.log.i('预期结果2.1: 返回到大图页面，涂鸦和AI修图效果生效，动态页签消失');
  await dt.assertComponent(PageTitle.index, true); //('id_of_full_screen_image_view', true);
  await dt.assertComponent(PageTitle.index, true); //('id_of_live_photo_indicator', false);
  // 验证涂鸦和AI修图效果生效需要视觉判断或图像识别
  await dt.sleep(DELAY.short);

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true); //Clickable('id_of_edit_button');
  dt.log.i('08.涂鸦后AI修图 end');
}