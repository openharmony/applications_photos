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

export default function MultimediaGalleryRemove(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryRemoveTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryRemove').init();
      dt.log.i('beforeAll MultimediaGalleryRemove start');
      dt.log.i('beforeAll MultimediaGalleryRemove finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryRemove', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryRemove15', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [AI消除横竖屏切换] TID: Multimedia_Gallery_Remove_15
      await multimediaGalleryRemove15(dt);
    });
    run('MultimediaGalleryRemove16', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [AI消除多语言适配] TID: Multimedia_Gallery_Remove_16
      await multimediaGalleryRemove16(dt);
    });
    run('MultimediaGalleryRemove18', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-大图用例: [消除风控照片] TID: Multimedia_Gallery_Remove_18
      await multimediaGalleryRemove18(dt);
    });
    run('MultimediaGalleryRemove19', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [弱网状态使用消除] TID: Multimedia_Gallery_Remove_19
      await multimediaGalleryRemove19(dt);
    });
    run('MultimediaGallerySDcard01', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库SD卡提示卡片是否能正常关闭] TID: Multimedia_Gallery_SD_card_01
      await multimediaGallerySDcard01(dt);
    });
    run('MultimediaGallerySDcard02', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库SD卡提示卡片是否能跳转进入文管] TID: Multimedia_Gallery_SD_card_02
      await multimediaGallerySDcard02(dt);
    });
    run('MultimediaGallerySDcard03', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [横竖屏切换，图库SD卡提示卡片显示] TID: Multimedia_Gallery_SD_card_03
      await multimediaGallerySDcard03(dt);
    });
    run('MultimediaGallerySDcard04', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-应用锁用例: [开启应用锁，图库SD卡提示卡片] TID: Multimedia_Gallery_SD_card_04
      await multimediaGallerySDcard04(dt);
    });
    run('MultimediaGallerySDcard05', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [图库SD卡提示卡片位置显示检查] TID: Multimedia_Gallery_SD_card_05
      await multimediaGallerySDcard05(dt);
    });
    run('MultimediaGallerySDcard06', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-深色用例: [深色模式下，图库SD卡提示卡片显示] TID: Multimedia_Gallery_SD_card_06
      await multimediaGallerySDcard06(dt);
    });
    run('MultimediaGallerySDcard07', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [无障碍模式，图库SD卡提示卡片显示] TID: Multimedia_Gallery_SD_card_07
      await multimediaGallerySDcard07(dt);
    });
    run('MultimediaGallerySDcard08', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [二分之一分屏状态时，图库SD卡提示卡片显示] TID: Multimedia_Gallery_SD_card_08
      await multimediaGallerySDcard08(dt);
    });
    run('MultimediaGallerySDcard09', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [三分之一分屏状态时，图库SD卡提示卡片显示] TID: Multimedia_Gallery_SD_card_09
      await multimediaGallerySDcard09(dt);
    });
    run('MultimediaGallerySDcard10', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [智慧小窗时，图库SD卡提示卡片显示] TID: Multimedia_Gallery_SD_card_10
      await multimediaGallerySDcard10(dt);
    });
    run('MultimediaGallerySDcard11', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [适老化，图库SD卡提示卡片显示] TID: Multimedia_Gallery_SD_card_11
      await multimediaGallerySDcard11(dt);
    });
    run('MultimediaGallerySDcard12', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [全球化，图库SD卡提示卡片显示] TID: Multimedia_Gallery_SD_card_12
      await multimediaGallerySDcard12(dt);
    });
    run('MultimediaGallerySDcard13', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [xxx切换为xxx，图库SD卡提示卡片显示] TID: Multimedia_Gallery_SD_card_13
      await multimediaGallerySDcard13(dt);
    });
    run('MultimediaGallerySDcard14', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [pad图库SD卡提示卡片显示] TID: Multimedia_Gallery_SD_card_14
      await multimediaGallerySDcard14(dt);
    });
    run('MultimediaGallerySDCard001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [存储设备卡片展示位置检查] TID: Multimedia_Gallery_SDCard_001
      await multimediaGallerySDCard001(dt);
    });
    run('MultimediaGallerySDCard002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备插入系统通知] TID: Multimedia_Gallery_SDCard_002
      await multimediaGallerySDCard002(dt);
    });
    run('MultimediaGallerySDCard003', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备/NM卡-存储设备卡片标题内容检查] TID: Multimedia_Gallery_SDCard_003
      await multimediaGallerySDCard003(dt);
    });
    run('MultimediaGallerySDCard004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备-存储设备卡片设备标题与通知栏标题对比] TID: Multimedia_Gallery_SDCard_004
      await multimediaGallerySDCard004(dt);
    });
    run('MultimediaGallerySDCard005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备/NM卡-点击”前往查看“按钮] TID: Multimedia_Gallery_SDCard_005
      await multimediaGallerySDCard005(dt);
    });
    run('MultimediaGallerySDCard006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-详情用例: [TypeC外接设备/NM卡-点击”了解详情按钮“按钮] TID: Multimedia_Gallery_SDCard_006
      await multimediaGallerySDCard006(dt);
    });
    run('MultimediaGallerySDCard007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备/NM卡-存储设备卡片正常显示时，冷启动进入图库] TID: Multimedia_Gallery_SDCard_007
      await multimediaGallerySDCard007(dt);
    });
    run('MultimediaGallerySDCard008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备/NM卡-点击存储设备卡片右上角X，卡片消失] TID: Multimedia_Gallery_SDCard_008
      await multimediaGallerySDCard008(dt);
    });
    run('MultimediaGallerySDCard009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备/NM卡-相册页上滑，存储设备卡片跟随移动] TID: Multimedia_Gallery_SDCard_009
      await multimediaGallerySDCard009(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryRemove').init();
      dt.log.i('afterEach MultimediaGalleryRemove start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryRemove finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryRemove').init();
      dt.log.i('afterAll MultimediaGalleryRemove start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryRemove finish');
    });
  });
}

// DT步骤
/**
 * 宫格-竖屏: [AI消除横竖屏切换]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_Remove_15
 * 前置条件
 * 1、手机登录账号
 2、非首次使用
 */
async function multimediaGalleryRemove15(dt: Dt) {
  dt.log.i('AI消除横竖屏切换 start');
  dt.log.i('STEP 1、手机竖屏，点击编辑-AI修图-消除');

  await dt.sleep();
  dt.log.i('STEP 2、选择手动后划线选择图片范围');

  await dt.sleep();
  dt.log.i('STEP 3、切换横屏');

  await dt.sleep();
  dt.log.i('预期结果3、切换横屏后图片选择范围显示正确，画笔粗细调节显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、切换一级二级菜单');

  await dt.sleep();
  dt.log.i('预期结果4、可以正常切换一二级菜单');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、进行消除时，进行打断');

  await dt.sleep();
  dt.log.i('预期结果5、消除中断，返回开始消除');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 6、消除后选择对比、后退前进');

  await dt.sleep();
  dt.log.i('预期结果6、对比显示正常，后退前进显示正确');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 7、消除后选择保存');

  await dt.sleep();
  dt.log.i('预期结果7、保存功能正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('AI消除横竖屏切换 end');
}

/**
 * 宫格-: [AI消除多语言适配]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_Remove_16
 * 前置条件
 * 1、手机登录账号
 2、非首次使用
  */
async function multimediaGalleryRemove16(dt: Dt) {
  dt.log.i('AI消除多语言适配 start');
  dt.log.i('STEP 1、分别切换系统语言到英文、繁体、藏文，使用AI消除功能');

  await dt.sleep();
  dt.log.i('预期结果1、界面跟随系统语言切换显示内容，无重叠、截断；消除功能正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、切换系统语言为维语，使用AI消除功能');

  await dt.sleep();
  dt.log.i('预期结果2、界面镜像符合规范（图标、文字、调节条），无重叠、截断；消除功能正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、切换横屏，重复步骤1-2');

  await dt.sleep();
  dt.log.i('预期结果3、横屏下显示内容无重叠、截断；消除功能正常，界面镜像符合规范（图标、文字、调节条）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('AI消除多语言适配 end');
}

/**
 * 宫格-大图: [消除风控照片]
 * GROUP: 宫格 MODULE: 大图TID: Multimedia_Gallery_Remove_18
 * 前置条件
 * 1、手机登录账号
 2、非首次使用
 */
async function multimediaGalleryRemove18(dt: Dt) {
  dt.log.i('消除风控照片 start');
  dt.log.i('STEP 1、选择敏感信息风控照片（');

  await dt.sleep();
  dt.log.i('STEP 2、大图界面-点击编辑-AI修图-消除');

  await dt.sleep();
  dt.log.i('预期结果2、toast提示”此图不适用消除功能，请更换图片后重试”');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('此图不适用消除功能，请更换图片后重试'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('消除风控照片 end');
}

/**
 * 宫格-: [弱网状态使用消除]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_Remove_19
 * 前置条件
 * 1、手机登录账号
 2、非首次使用
 3、手机网络处于弱网状态（WLAN信号低于两格）
 */
async function multimediaGalleryRemove19(dt: Dt) {
  dt.log.i('弱网状态使用消除 start');
  dt.log.i('STEP 1、点击图片进入AI修图 - 消除，点击任意物体消除');

  await dt.sleep();
  dt.log.i('预期结果1、消除超时，有提示信息：服务器异常/网络异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('弱网状态使用消除 end');
}

/**
 * 宫格-: [图库SD卡提示卡片是否能正常关闭]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_SD_card_01
 * 前置条件
 * 1.设备已插入SD卡
 */
async function multimediaGallerySDcard01(dt: Dt) {
  dt.log.i('图库SD卡提示卡片是否能正常关闭 start');
  dt.log.i('STEP 1.进入图库-相册页；');

  await dt.sleep();
  dt.log.i('预期结果1.相册页显示正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击提示SD卡图片上的“×”；');

  await dt.sleep();
  dt.log.i('预期结果2.提示SD卡图片可以正常关闭；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.拔出，插入SD卡；');

  await dt.sleep();
  dt.log.i('预期结果3.提示SD卡图片不再弹出；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.更换插入不同的SD卡；');

  await dt.sleep();
  dt.log.i('预期结果4.提示SD卡图片不再弹出；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库SD卡提示卡片是否能正常关闭 end');
}

/**
 * 宫格-: [图库SD卡提示卡片是否能跳转进入文管]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_SD_card_02
 * 前置条件
 * 1.设备已插入SD卡
 */
async function multimediaGallerySDcard02(dt: Dt) {
  dt.log.i('图库SD卡提示卡片是否能跳转进入文管 start');
  dt.log.i('STEP 1.进入图库-相册页；');

  await dt.sleep();
  dt.log.i('STEP 2.点击提示SD卡图片上的“前往查看”；');

  await dt.sleep();
  dt.log.i('预期结果2.页面顺利跳转进入文件管理页面；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.使用back手势返回；');

  await dt.sleep();
  dt.log.i('预期结果3.可以顺利返回到图库相册页；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库SD卡提示卡片是否能跳转进入文管 end');
}

/**
 * 宫格-竖屏: [横竖屏切换，图库SD卡提示卡片显示]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SD_card_03
 * 前置条件
 * 1.设备已插入SD卡；
 2.设备“旋转锁定”开关未开启（控制中心中可查看按钮是否开启）；
 */
async function multimediaGallerySDcard03(dt: Dt) {
  dt.log.i('横竖屏切换，图库SD卡提示卡片显示 start');
  dt.log.i('STEP 1.进入图库-相册页；');

  await dt.sleep();
  dt.log.i('STEP 2.横竖屏切换，观察；');

  await dt.sleep();
  dt.log.i('预期结果2.相册页横竖屏均显示无异常（卡片文字无溢出，截断等情况）；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('横竖屏切换，图库SD卡提示卡片显示 end');
}

/**
 * 宫格-应用锁: [开启应用锁，图库SD卡提示卡片]
 * GROUP: 宫格 MODULE: 应用锁TID: Multimedia_Gallery_SD_card_04
 * 前置条件
 * 1.设备已插入SD卡；
 2.开启图库应用锁（设置-隐私和安全-应用锁中，可开启应用锁）；
 */
async function multimediaGallerySDcard04(dt: Dt) {
  dt.log.i('开启应用锁，图库SD卡提示卡片 start');
  dt.log.i('STEP 1.进入图库-相册页；');

  await dt.sleep();
  dt.log.i('STEP 2.灭屏后亮屏解锁，观察图库相册页；');

  await dt.sleep();
  dt.log.i('预期结果2.图库SD卡提示卡片亮灭屏时显示一致；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('开启应用锁，图库SD卡提示卡片 end');
}

/**
 * 宫格-: [图库SD卡提示卡片位置显示检查]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_SD_card_05
 * 前置条件
 * 1.设备已插入SD卡
 */
async function multimediaGallerySDcard05(dt: Dt) {
  dt.log.i('图库SD卡提示卡片位置显示检查 start');
  dt.log.i('STEP 1.进入图库-相册页；');

  await dt.sleep();
  dt.log.i('STEP 2.检查图库SD卡提示卡片显示位置；');

  await dt.sleep();
  dt.log.i('预期结果2.在系统自带相册位置上方，相册页标题栏的下方');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库SD卡提示卡片位置显示检查 end');
}

/**
 * 宫格-深色: [深色模式下，图库SD卡提示卡片显示]
 * GROUP: 宫格 MODULE: 深色TID: Multimedia_Gallery_SD_card_06
 * 前置条件
 * 1.设备已插入SD卡；
 2.开启深色模式；
 */
async function multimediaGallerySDcard06(dt: Dt) {
  dt.log.i('深色模式下，图库SD卡提示卡片显示 start');
  dt.log.i('STEP 1.进入图库-相册页；');

  await dt.sleep();
  dt.log.i('STEP 2.检查图库SD卡提示卡片显示；');

  await dt.sleep();
  dt.log.i('预期结果2.图库SD卡提示卡片显示正常（卡片文字无溢出，截断等情况）；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('深色模式下，图库SD卡提示卡片显示 end');
}

/**
 * 宫格-视频: [无障碍模式，图库SD卡提示卡片显示]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_SD_card_07
 * 前置条件
 * 1.设备已插入SD卡；
 2.已开启屏幕朗读；
 */
async function multimediaGallerySDcard07(dt: Dt) {
  dt.log.i('无障碍模式，图库SD卡提示卡片显示 start');
  dt.log.i('STEP 1.进入图库-相册页；');

  await dt.sleep();
  dt.log.i('STEP 2.点击图库SD卡提示卡片上的“系统数据升级”文本；');

  await dt.sleep();
  dt.log.i('预期结果2.语音播报“系统数据升级”；');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('系统数据升级'));
  dt.log.i('STEP 3.点击图库SD卡提示卡片上的“×”按钮；');

  await dt.sleep();
  dt.log.i('预期结果3.语音播报“关闭，单指双击即可执行”；');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('关闭，单指双击即可执行'));
  dt.log.i('STEP 4.点击图库SD卡提示卡片上的“请前往文件管理>浏览>存储卡，查看SD卡内图片和视频。”文本；');

  await dt.sleep();
  dt.log.i('预期结果4.语音播报“请前往文件管理>浏览>存储卡，查看SD卡内图片和视频。”；');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('请前往文件管理>浏览>存储卡，查看SD卡内图片和视频。'));
  dt.log.i('STEP 5.点击图库SD卡提示卡片上的“前往查看”按钮；');

  await dt.sleep();
  dt.log.i('预期结果5.语音播报“前往查看，单指双击即可执行”；');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('前往查看，单指双击即可执行'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无障碍模式，图库SD卡提示卡片显示 end');
}

/**
 * 宫格-: [二分之一分屏状态时，图库SD卡提示卡片显示]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_SD_card_08
 * 前置条件
 * 1.设备已插入SD卡
 */
async function multimediaGallerySDcard08(dt: Dt) {
  dt.log.i('二分之一分屏状态时，图库SD卡提示卡片显示 start');
  dt.log.i('STEP 1.进入图库-相册页；');

  await dt.sleep();
  dt.log.i('STEP 2.二分之一分屏时，查看图库SD卡提示卡片显示，');

  await dt.sleep();
  dt.log.i('预期结果2.图库SD卡提示卡片显示无异常（卡片文字无溢出，截断等情况）；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击图库SD卡提示卡片上的“前往查看”按钮；');

  await dt.sleep();
  dt.log.i('预期结果3.可以顺利跳转进入文件管理应用中查看SD卡中的文件；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.点击图库SD卡提示卡片上的“×”按钮；');

  await dt.sleep();
  dt.log.i('预期结果4.提示SD卡图片可以正常关闭');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('二分之一分屏状态时，图库SD卡提示卡片显示 end');
}

/**
 * 宫格-: [三分之一分屏状态时，图库SD卡提示卡片显示]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_SD_card_09
 * 前置条件
 * 1.设备已插入SD卡
 */
async function multimediaGallerySDcard09(dt: Dt) {
  dt.log.i('三分之一分屏状态时，图库SD卡提示卡片显示 start');
  dt.log.i('STEP 1.进入图库-相册页；');

  await dt.sleep();
  dt.log.i('STEP 2.三分之一分屏时，查看图库SD卡提示卡片显示，');

  await dt.sleep();
  dt.log.i('预期结果2.图库SD卡提示卡片显示无异常（卡片文字无溢出，截断等情况）；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击图库SD卡提示卡片上的“前往查看”按钮；');

  await dt.sleep();
  dt.log.i('预期结果3.可以顺利跳转进入文件管理应用中查看SD卡中的文件；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.点击图库SD卡提示卡片上的“×”按钮；');

  await dt.sleep();
  dt.log.i('预期结果4.提示SD卡图片可以正常关闭');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('三分之一分屏状态时，图库SD卡提示卡片显示 end');
}

/**
 * 宫格-: [智慧小窗时，图库SD卡提示卡片显示]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_SD_card_10
 * 前置条件
 * 1.设备已插入SD卡
 */
async function multimediaGallerySDcard10(dt: Dt) {
  dt.log.i('智慧小窗时，图库SD卡提示卡片显示 start');
  dt.log.i('STEP 1.进入图库-相册页；');

  await dt.sleep();
  dt.log.i('STEP 2.小窗模式，查看图库SD卡提示卡片显示，');

  await dt.sleep();
  dt.log.i('预期结果2.图库SD卡提示卡片显示无异常（卡片文字无溢出，截断等情况）；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击图库SD卡提示卡片上的“前往查看”按钮；');

  await dt.sleep();
  dt.log.i('预期结果3.可以顺利跳转进入文件管理应用中查看SD卡中的文件；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.点击图库SD卡提示卡片上的“×”按钮；');

  await dt.sleep();
  dt.log.i('预期结果4.提示SD卡图片可以正常关闭');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧小窗时，图库SD卡提示卡片显示 end');
}

/**
 * 宫格-: [适老化，图库SD卡提示卡片显示]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_SD_card_11
 * 前置条件
 * 1.设备已插入SD卡
 */
async function multimediaGallerySDcard11(dt: Dt) {
  dt.log.i('适老化，图库SD卡提示卡片显示 start');
  dt.log.i('STEP 1.设置字体大小为“大/超大/特大”（在设置-显示和亮度-字体大小和界面缩放中设置），观察图库SD卡提示卡片显示；');

  await dt.sleep();
  dt.log.i('STEP 2.开启关怀模式，设置放大显示为“大1挡/大2挡/大3挡/大4挡/大5挡/大6挡”，观察图库SD卡提示卡片显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('适老化，图库SD卡提示卡片显示 end');
}

/**
 * 宫格-: [全球化，图库SD卡提示卡片显示]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_SD_card_12
 * 前置条件
 * 1.设备已插入SD卡
 */
async function multimediaGallerySDcard12(dt: Dt) {
  dt.log.i('全球化，图库SD卡提示卡片显示 start');
  dt.log.i('STEP 1.设置系统语言为英文/藏文/维吾尔文（设置-系统-语言和地区，可切换系统语言），观察图库SD卡提示卡片显示');

  await dt.sleep();
  dt.log.i('预期结果1.图库SD卡提示卡片均显示无异常（卡片文字无溢出，截断等情况）；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('全球化，图库SD卡提示卡片显示 end');
}

/**
 * 宫格-: [xxx切换为xxx，图库SD卡提示卡片显示]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_SD_card_13
 * 前置条件
 * 1.设备已插入SD卡
 */
async function multimediaGallerySDcard13(dt: Dt) {
  dt.log.i('xxx切换为xxx，图库SD卡提示卡片显示 start');
  dt.log.i('STEP 1.设备xxx时，观察图库SD卡提示卡片；');

  await dt.sleep();
  dt.log.i('STEP 2.变为xxx，观察图库SD卡提示卡片显示；');

  await dt.sleep();
  dt.log.i('STEP 3.重复1,2步骤');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxx切换为xxx，图库SD卡提示卡片显示 end');
}

/**
 * 宫格-: [pad图库SD卡提示卡片显示]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_SD_card_14
 * 前置条件
 * 1.设备已插入SD卡
 */
async function multimediaGallerySDcard14(dt: Dt) {
  dt.log.i('pad图库SD卡提示卡片显示 start');
  dt.log.i('STEP 1.进入图库-相册页观察；');

  await dt.sleep();
  dt.log.i('预期结果1.PAD设备不显示图库SD卡提示卡片；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('pad图库SD卡提示卡片显示 end');
}

/**
 * 宫格-: [存储设备卡片展示位置检查]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_SDCard_001
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）/U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard001(dt: Dt) {
  dt.log.i('存储设备卡片展示位置检查 start');
  dt.log.i('STEP 1、点击下方导航栏，切换照片、相册、时刻，检查卡片的显示位置');

  await dt.sleep();
  dt.log.i('预期结果1、存储设备卡片只显示在相册页顶部');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('存储设备卡片展示位置检查 end');
}

/**
 * 宫格-竖屏: [TypeC外接设备插入系统通知]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_002
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）/U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard002(dt: Dt) {
  dt.log.i('TypeC外接设备插入系统通知 start');
  dt.log.i('STEP 1、前置摄像头左边下滑，检查通知弹窗');

  await dt.sleep();
  dt.log.i('预期结果1、出现通知弹窗，一级标题为设备名称，内容是“设备已接入”，同时出现提示音和振动，点击弹窗查看按钮，跳转到存储设备根目录');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('设备已接入'));
  dt.log.i('STEP 2、点击弹窗左下角查看/打开文件管理，检查在文件管理中的位置显示');

  await dt.sleep();
  dt.log.i('预期结果2、NM卡显示在我的手机、我的云盘之间，TypeC外接设备展示在最近删除上一个');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横竖屏、分屏、悬浮窗、大字体，无障碍、多语言、多设备（手机/xxx）、隐私空间、云图上下行，验证 1-2');

  await dt.sleep();
  dt.log.i('预期结果3、通知栏弹窗和设备位置显示均正确');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('TypeC外接设备插入系统通知 end');
}

/**
 * 宫格-竖屏: [TypeC外接设备/NM卡-存储设备卡片标题内容检查]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_003
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）/U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard003(dt: Dt) {
  dt.log.i('TypeC外接设备/NM卡-存储设备卡片标题内容检查 start');
  dt.log.i('STEP 1、检查一级标题和内容的显示');

  await dt.sleep();
  dt.log.i('预期结果1、一级标题：查看存储设备xxx的图片和视频，内容：请前往“文件管理”>”浏览“> ”xxx“，查看和管理存储设备内的图片和视频');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('文件管理'));
  dt.log.i('STEP 2、横竖屏、分屏、悬浮窗、大字体，无障碍、多语言、多设备（手机/xxx）、隐私空间、云图上下行，验证 1');

  await dt.sleep();
  dt.log.i('预期结果2、标题和内容展示均正确');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('TypeC外接设备/NM卡-存储设备卡片标题内容检查 end');
}

/**
 * 宫格-竖屏: [TypeC外接设备-存储设备卡片设备标题与通知栏标题对比]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_004
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）/U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard004(dt: Dt) {
  dt.log.i('TypeC外接设备-存储设备卡片设备标题与通知栏标题对比 start');
  dt.log.i('STEP 1、卡片弹出后，前置摄像头左边下滑，检查通知弹窗中的一级标题与卡片中的设备名称是否一致');

  await dt.sleep();
  dt.log.i('预期结果1、通知栏一级标题与卡片中设备名称一致');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、横竖屏、分屏、悬浮窗、大字体，无障碍、多语言、多设备（手机/xxx）、隐私空间、云图上下行，验证 1');

  await dt.sleep();
  dt.log.i('预期结果2、各类情况下，一级标题与卡片中设备名称均一致');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('TypeC外接设备-存储设备卡片设备标题与通知栏标题对比 end');
}

/**
 * 宫格-竖屏: [TypeC外接设备/NM卡-点击”前往查看“按钮]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_005
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）/U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard005(dt: Dt) {
  dt.log.i('TypeC外接设备/NM卡-点击”前往查看“按钮 start');
  dt.log.i('STEP 1、点击“前往查看按钮”');

  await dt.sleep();
  dt.log.i('STEP 2、观察跳转到的页面');

  await dt.sleep();
  dt.log.i('预期结果2.1、文件管理未启动时，跳转先到文件管理首页，在跳转到设备首页2.2、文件管理启动时，先跳转到文件管理所在页面，在跳转到设备首页');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横竖屏、分屏、悬浮窗、大字体，无障碍、多语言、多设备（手机/xxx）、隐私空间、云图上下行，验证 1-2');

  await dt.sleep();
  dt.log.i('预期结果3、各类情况跳转均正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('TypeC外接设备/NM卡-点击”前往查看“按钮 end');
}

/**
 * 宫格-详情: [TypeC外接设备/NM卡-点击”了解详情按钮“按钮]
 * GROUP: 宫格 MODULE: 详情TID: Multimedia_Gallery_SDCard_006
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）/U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard006(dt: Dt) {
  dt.log.i('TypeC外接设备/NM卡-点击”了解详情按钮“按钮 start');
  dt.log.i('STEP 1、点击“了解详情按钮”');

  await dt.sleep();
  dt.log.i('STEP 2、观察跳转到的页面');

  await dt.sleep();
  dt.log.i('预期结果2、跳转到对应的玩机技巧介绍页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横竖屏、分屏、悬浮窗、大字体，无障碍、多语言、多设备（手机/xxx）、隐私空间、云图上下行，验证 1-2');

  await dt.sleep();
  dt.log.i('预期结果3、各类情况跳转均正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('TypeC外接设备/NM卡-点击”了解详情按钮“按钮 end');
}

/**
 * 宫格-竖屏: [TypeC外接设备/NM卡-存储设备卡片正常显示时，冷启动进入图库]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_007
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）/U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard007(dt: Dt) {
  dt.log.i('TypeC外接设备/NM卡-存储设备卡片正常显示时，冷启动进入图库 start');
  dt.log.i('STEP 1、冷启动进入图库');

  await dt.sleep();
  dt.log.i('预期结果1、冷启动进入图库，卡片仍正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、横竖屏、分屏、悬浮窗、大字体，无障碍、多语言、多设备（手机/xxx）、隐私空间、云图上下行，验证 1');

  await dt.sleep();
  dt.log.i('预期结果2、各类情况卡片均正常展示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('TypeC外接设备/NM卡-存储设备卡片正常显示时，冷启动进入图库 end');
}

/**
 * 宫格-竖屏: [TypeC外接设备/NM卡-点击存储设备卡片右上角X，卡片消失]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_008
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）/U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard008(dt: Dt) {
  dt.log.i('TypeC外接设备/NM卡-点击存储设备卡片右上角X，卡片消失 start');
  dt.log.i('STEP 1、点击卡片右上角X，观察卡片显示');

  await dt.sleep();
  dt.log.i('预期结果1、卡片消失，文件管理中设备正常展示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、冷启动进入图库，观察卡片显示');

  await dt.sleep();
  dt.log.i('预期结果2、卡片复现、文件管理中设备正常展示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、重新插拔设备、观察卡片显示');

  await dt.sleep();
  dt.log.i('预期结果3、卡片在相册页重现');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，无障碍、多语言、多设备（手机/xxx）、隐私空间、云图上下行，验证 1-3');

  await dt.sleep();
  dt.log.i('预期结果4、各类情况现象均正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('TypeC外接设备/NM卡-点击存储设备卡片右上角X，卡片消失 end');
}

/**
 * 宫格-竖屏: [TypeC外接设备/NM卡-相册页上滑，存储设备卡片跟随移动]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_009
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）/U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard009(dt: Dt) {
  dt.log.i('TypeC外接设备/NM卡-相册页上滑，存储设备卡片跟随移动 start');
  dt.log.i('STEP 1、存储卡片弹出后，在相册页上滑，观察卡片是否跟随移动');

  await dt.sleep();
  dt.log.i('预期结果1、卡片非固定，跟随移动');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、横竖屏、分屏、悬浮窗、大字体，无障碍、多语言、多设备（手机/xxx）、隐私空间、云图上下行，验证 1');

  await dt.sleep();
  dt.log.i('预期结果2、各类情况下，上滑屏幕，卡片均跟随移动');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('TypeC外接设备/NM卡-相册页上滑，存储设备卡片跟随移动 end');
}