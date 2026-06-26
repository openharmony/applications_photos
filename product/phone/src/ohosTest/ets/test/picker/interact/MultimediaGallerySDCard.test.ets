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

export default function MultimediaGallerySDCard(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGallerySDCardTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGallerySDCard').init();
      dt.log.i('beforeAll MultimediaGallerySDCard start');
      dt.log.i('beforeAll MultimediaGallerySDCard finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGallerySDCard', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGallerySDCard010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备/NM卡-相册页-双指缩放-观察存储设备卡片显示动效] TID: Multimedia_Gallery_SDCard_010
      await multimediaGallerySDCard010(dt);
    });
    run('MultimediaGallerySDCard011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备/NM卡-存储设备拔出] TID: Multimedia_Gallery_SDCard_011
      await multimediaGallerySDCard011(dt);
    });
    run('MultimediaGallerySDCard012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备、NM卡-存储设备插入系统通知] TID: Multimedia_Gallery_SDCard_012
      await multimediaGallerySDCard012(dt);
    });
    run('MultimediaGallerySDCard013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备、NM卡-存储卡片标题内容检查] TID: Multimedia_Gallery_SDCard_013
      await multimediaGallerySDCard013(dt);
    });
    run('MultimediaGallerySDCard014', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备、NM卡-点击”前往查看“按钮] TID: Multimedia_Gallery_SDCard_014
      await multimediaGallerySDCard014(dt);
    });
    run('MultimediaGallerySDCard015', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-详情用例: [TypeC外接设备、NM卡-点击”了解详情按钮“按钮] TID: Multimedia_Gallery_SDCard_015
      await multimediaGallerySDCard015(dt);
    });
    run('MultimediaGallerySDCard016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备、NM卡-存储卡片正常显示时，冷启动进入图库] TID: Multimedia_Gallery_SDCard_016
      await multimediaGallerySDCard016(dt);
    });
    run('MultimediaGallerySDCard017', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备、NM卡-点击存储卡片右上角X，卡片消失] TID: Multimedia_Gallery_SDCard_017
      await multimediaGallerySDCard017(dt);
    });
    run('MultimediaGallerySDCard018', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备、NM卡-相册页上滑，存储卡片跟随移动] TID: Multimedia_Gallery_SDCard_018
      await multimediaGallerySDCard018(dt);
    });
    run('MultimediaGallerySDCard019', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备、NM卡-相册页-双指缩放-观察存储卡片显示动效] TID: Multimedia_Gallery_SDCard_019
      await multimediaGallerySDCard019(dt);
    });
    run('MultimediaGallerySDCard020', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备、NM卡-设备拔出] TID: Multimedia_Gallery_SDCard_020
      await multimediaGallerySDCard020(dt);
    });
    run('MultimediaGallerySDCard021', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [TypeC外接设备插入时，存储卡片出现的时间与系统通知栏出现时间对比] TID: Multimedia_Gallery_SDCard_021
      await multimediaGallerySDCard021(dt);
    });
    run('MultimediaGallerySDCard022', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [存储卡片和云空间卡片共存时，检查页面的展示] TID: Multimedia_Gallery_SDCard_022
      await multimediaGallerySDCard022(dt);
    });
    run('MultimediaGallerySDCard023', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [空图库时-插入TypeC外接设备/NM卡，检查照片页展示] TID: Multimedia_Gallery_SDCard_023
      await multimediaGallerySDCard023(dt);
    });
    run('MultimediaGallerySDCard024', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [图库资源从有到无-存储卡片消失] TID: Multimedia_Gallery_SDCard_024
      await multimediaGallerySDCard024(dt);
    });
    run('MultimediaPhotosSecuPrivacyChooseAndConsent0100', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [收集个人信息获取用户同意或存在合法基础的检查] TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_0100
      await multimediaPhotosSecuPrivacyChooseAndConsent0100(dt);
    });
    run('MultimediaPhotosSecuPrivacyChooseAndConsent0200', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [收集图片信息和位置信息满足最小必要规范要求的检查] TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_0200
      await multimediaPhotosSecuPrivacyChooseAndConsent0200(dt);
    });
    run('MultimediaPhotosSecuPrivacyChooseAndConsent0300', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [收集个人信息满足最小化原则的测试] TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_0300
      await multimediaPhotosSecuPrivacyChooseAndConsent0300(dt);
    });
    run('MultimediaPhotosSecuPrivacyChooseAndConsent0900', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [应用修改系统或其他应用的配置需用户的同意] TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_0900
      await multimediaPhotosSecuPrivacyChooseAndConsent0900(dt);
    });
    run('MultimediaPhotosSecuPrivacyChooseAndConsent1000', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [撤销修改用户个人空间行为的用户同意的检查] TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_1000
      await multimediaPhotosSecuPrivacyChooseAndConsent1000(dt);
    });
    run('MultimediaPhotosSecuPrivacyChooseAndConsent1200', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [拒绝采集个人信息或权限的检查] TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_1200
      await multimediaPhotosSecuPrivacyChooseAndConsent1200(dt);
    });
    run('MultimediaPhotosSecuPrivacyChooseAndConsent1400', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-下载用例: [应用频繁和过度申请权限检查] TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_1400
      await multimediaPhotosSecuPrivacyChooseAndConsent1400(dt);
    });
    run('MultimediaPhotosSecuPrivacyChooseAndConsent2100', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [隐私相关开关选项的检查] TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_2100
      await multimediaPhotosSecuPrivacyChooseAndConsent2100(dt);
    });
    run('MultimediaPhotosSecuPrivacyChooseAndConsent3800', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [用户撤销同意，停止收集和使用用户数据的检查] TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_3800
      await multimediaPhotosSecuPrivacyChooseAndConsent3800(dt);
    });
    run('MultimediaPhotosSecuPrivacyChooseAndConsent3900', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [用户拒绝使用个人数据后不能频繁弹框提示用户授权的检查] TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_3900
      await multimediaPhotosSecuPrivacyChooseAndConsent3900(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGallerySDCard').init();
      dt.log.i('afterEach MultimediaGallerySDCard start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGallerySDCard finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGallerySDCard').init();
      dt.log.i('afterAll MultimediaGallerySDCard start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGallerySDCard finish');
    });
  });
}

// DT步骤
/**
 * 宫格-竖屏: [TypeC外接设备/NM卡-相册页-双指缩放-观察存储设备卡片显示动效]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_010
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）/U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard010(dt: Dt) {
  dt.log.i('TypeC外接设备/NM卡-相册页-双指缩放-观察存储设备卡片显示动效 start');
  dt.log.i('STEP 1、相册页-双指缩放-观察卡片显示动效');

  await dt.sleep();
  dt.log.i('预期结果1、双指缩放时，卡片动效正常展示（缩放过程中卡片消失，缩放完成，卡片复现）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、横竖屏、分屏、悬浮窗、大字体，无障碍、多语言、多设备（手机/xxx）、隐私空间、云图上下行，验证 1');

  await dt.sleep();
  dt.log.i('预期结果2、各类情况下，卡片动效均正常展示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('TypeC外接设备/NM卡-相册页-双指缩放-观察存储设备卡片显示动效 end');
}

/**
 * 宫格-竖屏: [TypeC外接设备/NM卡-存储设备拔出]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_011
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）/U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard011(dt: Dt) {
  dt.log.i('TypeC外接设备/NM卡-存储设备拔出 start');
  dt.log.i('STEP 1、将设备拔出，观察卡片显示、系统通知、文件管理设备');

  await dt.sleep();
  dt.log.i('预期结果1.1、拔出时，卡片消失1.2、系统通知弹窗，“外接设备已移除”，手机振动（TypeC外接设备独有）1.3、文件管理设备消失');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('外接设备已移除'));
  dt.log.i('STEP 2、横竖屏、分屏、悬浮窗、大字体，无障碍、多语言、多设备（手机/xxx）、隐私空间、云图上下行，验证 1');

  await dt.sleep();
  dt.log.i('预期结果2、各类情况下，均正常展示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('TypeC外接设备/NM卡-存储设备拔出 end');
}

/**
 * 宫格-竖屏: [TypeC外接设备、NM卡-存储设备插入系统通知]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_012
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）、U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard012(dt: Dt) {
  dt.log.i('TypeC外接设备、NM卡-存储设备插入系统通知 start');
  dt.log.i('STEP 1、前置摄像头左边下滑，检查通知弹窗');

  await dt.sleep();
  dt.log.i('预期结果1、出现通知弹窗，一级标题为设备名称，内容是“设备已接入”，同时出现提示音和振动，击弹窗查看按钮，跳转到TypeC外接设备根目录');
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
  dt.log.i('TypeC外接设备、NM卡-存储设备插入系统通知 end');
}

/**
 * 宫格-竖屏: [TypeC外接设备、NM卡-存储卡片标题内容检查]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_013
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）、U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard013(dt: Dt) {
  dt.log.i('TypeC外接设备、NM卡-存储卡片标题内容检查 start');
  dt.log.i('STEP 1、检查一级标题和内容的显示');

  await dt.sleep();
  dt.log.i('预期结果1、一级标题：查看存储设备的图片和视频，内容：请前往“文件管理”>”浏览“，查看和管理存储设备内的图片和视频');
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
  dt.log.i('TypeC外接设备、NM卡-存储卡片标题内容检查 end');
}

/**
 * 宫格-竖屏: [TypeC外接设备、NM卡-点击”前往查看“按钮]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_014
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）、U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard014(dt: Dt) {
  dt.log.i('TypeC外接设备、NM卡-点击”前往查看“按钮 start');
  dt.log.i('STEP 1、点击“前往查看按钮”');

  await dt.sleep();
  dt.log.i('STEP 2、观察跳转到的页面');

  await dt.sleep();
  dt.log.i('预期结果2.1、文件管理未启动时，跳转先到文件管理首页2.2、文件管理启动时，先跳转到文件管理所在页面，在跳转到文件管理首页');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横竖屏、分屏、悬浮窗、大字体，无障碍、多语言、多设备（手机/xxx）、隐私空间、云图上下行，验证 1-2');

  await dt.sleep();
  dt.log.i('预期结果3、各类情况跳转均正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('TypeC外接设备、NM卡-点击”前往查看“按钮 end');
}

/**
 * 宫格-详情: [TypeC外接设备、NM卡-点击”了解详情按钮“按钮]
 * GROUP: 宫格 MODULE: 详情TID: Multimedia_Gallery_SDCard_015
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）、U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard015(dt: Dt) {
  dt.log.i('TypeC外接设备、NM卡-点击”了解详情按钮“按钮 start');
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
  dt.log.i('TypeC外接设备、NM卡-点击”了解详情按钮“按钮 end');
}

/**
 * 宫格-竖屏: [TypeC外接设备、NM卡-存储卡片正常显示时，冷启动进入图库]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_016
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）、U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard016(dt: Dt) {
  dt.log.i('TypeC外接设备、NM卡-存储卡片正常显示时，冷启动进入图库 start');
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
  dt.log.i('TypeC外接设备、NM卡-存储卡片正常显示时，冷启动进入图库 end');
}

/**
 * 宫格-竖屏: [TypeC外接设备、NM卡-点击存储卡片右上角X，卡片消失]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_017
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）、U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard017(dt: Dt) {
  dt.log.i('TypeC外接设备、NM卡-点击存储卡片右上角X，卡片消失 start');
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
  dt.log.i('TypeC外接设备、NM卡-点击存储卡片右上角X，卡片消失 end');
}

/**
 * 宫格-竖屏: [TypeC外接设备、NM卡-相册页上滑，存储卡片跟随移动]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_018
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）、U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard018(dt: Dt) {
  dt.log.i('TypeC外接设备、NM卡-相册页上滑，存储卡片跟随移动 start');
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
  dt.log.i('TypeC外接设备、NM卡-相册页上滑，存储卡片跟随移动 end');
}

/**
 * 宫格-竖屏: [TypeC外接设备、NM卡-相册页-双指缩放-观察存储卡片显示动效]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_019
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）、U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard019(dt: Dt) {
  dt.log.i('TypeC外接设备、NM卡-相册页-双指缩放-观察存储卡片显示动效 start');
  dt.log.i('STEP 1、相册页-双指缩放-观察卡片显示动效');

  await dt.sleep();
  dt.log.i('预期结果1、双指缩放时，卡片动效正常展示（缩放过程中卡片消失，缩放完成，卡片复现）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、横竖屏、分屏、悬浮窗、大字体，无障碍、多语言、多设备（手机/xxx）、隐私空间、云图上下行，验证 1');

  await dt.sleep();
  dt.log.i('预期结果2、各类情况下，卡片动效均正常展示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('TypeC外接设备、NM卡-相册页-双指缩放-观察存储卡片显示动效 end');
}

/**
 * 宫格-竖屏: [TypeC外接设备、NM卡-设备拔出]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_020
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）、U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard020(dt: Dt) {
  dt.log.i('TypeC外接设备、NM卡-设备拔出 start');
  dt.log.i('STEP 1、将设备拔出，观察卡片显示、系统通知、文件管理设备');

  await dt.sleep();
  dt.log.i('预期结果1.1、拔出卡设备时，卡片一级标题展示外接设备的名称/拔出TypeC外接设备时，卡片一级标题展示卡设备名称，全部拔出时，卡片消失1.2、系统通知弹窗，“外接设备已移除”，手机振动1.3、文件管理设备消失');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('外接设备已移除'));
  dt.log.i('STEP 2、横竖屏、分屏、悬浮窗、大字体，无障碍、多语言、多设备（手机/xxx）、隐私空间、云图上下行，验证 1');

  await dt.sleep();
  dt.log.i('预期结果2、各类情况下，均正常展示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('TypeC外接设备、NM卡-设备拔出 end');
}

/**
 * 宫格-竖屏: [TypeC外接设备插入时，存储卡片出现的时间与系统通知栏出现时间对比]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_021
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）/U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard021(dt: Dt) {
  dt.log.i('TypeC外接设备插入时，存储卡片出现的时间与系统通知栏出现时间对比 start');
  dt.log.i('STEP 1、TypeC外接设备插入后，检查存储卡片和系统通知栏出现的时间');

  await dt.sleep();
  dt.log.i('预期结果1、存储卡片出现的时间比系统通知栏提示晚不超过1秒');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、横竖屏、分屏、悬浮窗、大字体，无障碍、多语言、多设备（手机/xxx）、隐私空间、云图上下行，验证 1');

  await dt.sleep();
  dt.log.i('预期结果2、各种情况下，出现时间均符合1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('TypeC外接设备插入时，存储卡片出现的时间与系统通知栏出现时间对比 end');
}

/**
 * 宫格-竖屏: [存储卡片和云空间卡片共存时，检查页面的展示]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_022
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）/U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard022(dt: Dt) {
  dt.log.i('存储卡片和云空间卡片共存时，检查页面的展示 start');
  dt.log.i('STEP 1、存储卡片与云空间卡片共存时，检查页面展示');

  await dt.sleep();
  dt.log.i('预期结果1、云空间卡片与存储卡片正常展示，且整个相册页中各个模块均正常展示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、横竖屏、分屏、悬浮窗、大字体，无障碍、多语言、多设备（手机/xxx）、隐私空间、云图上下行，验证 1');

  await dt.sleep();
  dt.log.i('预期结果2、各种情况下，均正常展示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('存储卡片和云空间卡片共存时，检查页面的展示 end');
}

/**
 * 宫格-竖屏: [空图库时-插入TypeC外接设备/NM卡，检查照片页展示]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_023
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）/U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard023(dt: Dt) {
  dt.log.i('空图库时-插入TypeC外接设备/NM卡，检查照片页展示 start');
  dt.log.i('STEP 1、空图库时，TypeC外接设备插入后，检查存储卡片是否出现');

  await dt.sleep();
  dt.log.i('预期结果1.1、空图库时，插入TypeC外接设备，存储卡片不出现，只出现通知栏弹窗 振动1.2、在相册页敲击屏幕截图（使用任意方式新增图库资源），卡片复现');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、横竖屏、分屏、悬浮窗、大字体，无障碍、多语言、多设备（手机/xxx）、隐私空间、云图上下行，验证 1');

  await dt.sleep();
  dt.log.i('预期结果2、各种情况下，均正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('空图库时-插入TypeC外接设备/NM卡，检查照片页展示 end');
}

/**
 * 宫格-竖屏: [图库资源从有到无-存储卡片消失]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_SDCard_024
 * 前置条件
 * 1、手机打开图库
 2、手机插入存储设备（NM卡）/U盘
 3、HL设备不支持NM卡，AB设备支持（ALN手机/ALTxxx），mate60之后的不支持NM卡
 */
async function multimediaGallerySDCard024(dt: Dt) {
  dt.log.i('图库资源从有到无-存储卡片消失 start');
  dt.log.i('STEP 1、TypeC外接设备/NM卡存在时，删除图库的所有资源包括用户新建相册及最近删除，观察存储卡片显示');

  await dt.sleep();
  dt.log.i('预期结果1、图库所有资源消失时，存储卡片由显示到消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、横竖屏、分屏、悬浮窗、大字体，无障碍、多语言、多设备（手机/xxx）、隐私空间、云图上下行，验证 1');

  await dt.sleep();
  dt.log.i('预期结果2、各种情况下，均正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库资源从有到无-存储卡片消失 end');
}

/**
 * 宫格-删除: [收集个人信息获取用户同意或存在合法基础的检查]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_0100
 * 前置条件
 * 1、应用收集个人信息
 */
async function multimediaPhotosSecuPrivacyChooseAndConsent0100(dt: Dt) {
  dt.log.i('收集个人信息获取用户同意或存在合法基础的检查 start');
  dt.log.i('STEP 1、获取应用PIA报告，梳理PIA中“梳理个人信息清单”章节的“个人信息清单”中各项个人数的“收集个人数据的法律依据”；');

  await dt.sleep();
  dt.log.i('STEP 2、检查应用隐私声明的收集个人信息章节中，收集个人信息是否描述基于的合法性基础，合法性基础按照上线区域不同要求请见备注。');

  await dt.sleep();
  dt.log.i('预期结果2、隐私声明的收集个人信息章节中，描述了各项收集个人信息行为的合法性基础；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、应用隐私声明的收集个人信息章节中，收集个人信息是否描述基于的合法性基础，与步骤1中个人数据的“收集个人数据的法律依据”一致；');

  await dt.sleep();
  dt.log.i('预期结果3、隐私声明中个人数据收集行为的合法性基础与PIA中“收集个人数据的法律依据”一致；6、中国区上线业务，如果集成第三方SDK，并且第三方SDK收集个人信息，应用隐私声明中存在“第三方SDK列表”，并且“第三方SDK列表”包括应用集成第三方SDK名称、主体名称、处理个人信息种类及目的、个人信息处理规则等信息；落地方案参考“工信部26号文隐私合规方案--第三方共享清单隐私合规方案”：、中国区上线业务，如果集成同一公司名下SDK嵌套了第三方SDK且第三方SDK收集了个人信息，检查应用隐私声明存在“第三方SDK列表”，并且“第三方SDK列表”包括集成的同一公司名下SDK嵌套的第三方SDK名称、主体名称、处理个人信息种类及目的、个人信息处理规则；落地方案参考“工信部26号文隐私合规方案--第三方共享清单隐私合规方案”：8.1、德国上线业务，雇主在完成雇佣所必要的目的（如做出雇佣决策，雇佣后执行和终止雇佣合同等），才能够处理雇员数据;8.2、如果是基于同意处理员工数据，需要以书面或电子的形式获取用户自主做出的同意决策。9、欧洲上线，出于以下目的才能在公共场所安装监控（1）用于决定允许谁或者拒绝谁进入其场所；（2）出于特定目的保护其合法利益。同时，该等视频监控并未超出数据主体的合法利益。企业同时需要在数据主体可见的区域披露数据控制者的名称及联系方式。德国：CCTV不得与录音同时使用西班牙：只有出于安全目的，才能在公共场所安装CCTV，并且（1）数据在满足目的后及时删除（原则上1个月内，除非为了保留证据）；（2）向用户进行了明确的告知。10、欧洲上线业务，征求用户同意或收集个人信息页面，不存在通过情绪化的文字描述诱导用户提供个人信息情况，类似“您将永远失去一切”或“您的朋友将忘记您”“残忍拒绝”等；11.1、默认拍照有声音（产品必须得到法务部门评估与认可后，才可以提供拍照静音功能）；11.2、如果产品允许提供拍照静音功能，必须提供拍照静音选项，默认不勾选。');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('收集个人数据的法律依据'));
  dt.log.i('STEP 4、中国区上线，确认应用是否集成第三方SDK（第三方SDK定义见备注）以及第三方SDK收集的个人信息；');

  await dt.sleep();
  dt.log.i('STEP 5、中国区上线，确认应用集成的同一公司名下SDK，是否嵌套了第三方SDK，以及第三方SDK收集的个人信息；');

  await dt.sleep();
  dt.log.i('STEP 6、中国区上线业务，如果集成第三方SDK且第三方SDK收集了个人信息，检查应用隐私声明中是否存在“第三方SDK列表”，并检查“第三方SDK列表”是否包括应用集成的第三方SDK名称、主体名称、处理个人信息种类及目的、个人信息处理规则；落地方案参考“工信部26号文隐私合规方案--第三方共享清单隐私合规方案”：');

  await dt.sleep();
  dt.log.i('预期结果6、中国区上线业务，如果集成第三方SDK，并且第三方SDK收集个人信息，应用隐私声明中存在“第三方SDK列表”，并且“第三方SDK列表”包括应用集成第三方SDK名称、主体名称、处理个人信息种类及目的、个人信息处理规则等信息；落地方案参考“工信部26号文隐私合规方案--第三方共享清单隐私合规方案”：');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('第三方SDK列表'));
  dt.log.i('STEP 7、中国区上线业务，如果应用集成的同一公司名下SDK嵌套了第三方SDK，且第三方SDK收集个人信息，检查应用隐私声明中是否存在“第三方SDK列表”，并检查“第三方SDK列表”是否包括集成的同一公司名下SDK嵌套的第三方SDK名称、主体名称、处理个人信息种类及目的、个人信息处理规则；落地方案参考“工信部26号文隐私合规方案--第三方共享清单隐私合规方案”：');

  await dt.sleep();
  dt.log.i('预期结果7、中国区上线业务，如果集成同一公司名下SDK嵌套了第三方SDK且第三方SDK收集了个人信息，检查应用隐私声明存在“第三方SDK列表”，并且“第三方SDK列表”包括集成的同一公司名下SDK嵌套的第三方SDK名称、主体名称、处理个人信息种类及目的、个人信息处理规则；落地方案参考“工信部26号文隐私合规方案--第三方共享清单隐私合规方案”：');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('第三方SDK列表'));
  dt.log.i('STEP 8、德国上线业务，如果涉及雇主处理员工数据的场景，确认处理员工数据的目的以及合法性基础；');

  await dt.sleep();
  dt.log.i('预期结果8.1、德国上线业务，雇主在完成雇佣所必要的目的（如做出雇佣决策，雇佣后执行和终止雇佣合同等），才能够处理雇员数据;8.2、如果是基于同意处理员工数据，需要以书面或电子的形式获取用户自主做出的同意决策。');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 9、欧洲上线业务，如果涉及安装监控，检查安装监控的目的；');

  await dt.sleep();
  dt.log.i('预期结果9、欧洲上线，出于以下目的才能在公共场所安装监控（1）用于决定允许谁或者拒绝谁进入其场所；（2）出于特定目的保护其合法利益。同时，该等视频监控并未超出数据主体的合法利益。企业同时需要在数据主体可见的区域披露数据控制者的名称及联系方式。德国：CCTV不得与录音同时使用西班牙：只有出于安全目的，才能在公共场所安装CCTV，并且（1）数据在满足目的后及时删除（原则上1个月内，除非为了保留证据）；（2）向用户进行了明确的告知。');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 10、欧洲上线业务，检查应用征求用户同意或收集个人信息页面展示方式，是否存在情绪化的文字描述诱导用户提供个人信息情况，类似“您将永远失去一切”或“您的朋友将忘记您”“残忍拒绝”等；');

  await dt.sleep();
  dt.log.i('预期结果10、欧洲上线业务，征求用户同意或收集个人信息页面，不存在通过情绪化的文字描述诱导用户提供个人信息情况，类似“您将永远失去一切”或“您的朋友将忘记您”“残忍拒绝”等；');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('您将永远失去一切'));
  dt.log.i('STEP 11、日本、韩国业务，并且存在拍照场景（包括：远程或遥控手机拍照），检查拍照功能，在非静音模式下进行一次拍照（包含所有替代拍照的行为，例如：扫一扫通过拍照实现，需要满足）');

  await dt.sleep();
  dt.log.i('预期结果11.1、默认拍照有声音（产品必须得到法务部门评估与认可后，才可以提供拍照静音功能）；11.2、如果产品允许提供拍照静音功能，必须提供拍照静音选项，默认不勾选。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('收集个人信息获取用户同意或存在合法基础的检查 end');
}

/**
 * 宫格-视频: [收集图片信息和位置信息满足最小必要规范要求的检查]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_0200
 * 前置条件
 * 1、应用涉及收集位置信息或图片信息或视频信息（确认PIA中“梳理个人数据清单”中是否包括位置信息、图片/图像数据）
 */
async function multimediaPhotosSecuPrivacyChooseAndConsent0200(dt: Dt) {
  dt.log.i('收集图片信息和位置信息满足最小必要规范要求的检查 start');
  dt.log.i('STEP 1、检查PIA中“梳理个人数据清单”中，收集位置信息、精确位置信息的“使用个人数据的目的”列、“业务流程”列、“个人数据收集方式”列，确认收集的目的、场景、收集方式；');

  await dt.sleep();
  dt.log.i('STEP 2、如果收集图片信息、视频信息的场景涉及广告服务、调度服务、资产管理服务、搜索服务、推荐服务、画像服务、风控服务场景，则触发对应功能场景，检查是否存在获取用户单独同意过程。单独同意的实现方式，请见备注。');

  await dt.sleep();
  dt.log.i('预期结果2、在广告服务、调度服务、资产管理服务、搜索服务、推荐服务、画像服务、风控服务场景，收集图片和视频数据中的位置信息时，需要用户单独同意（单独同意实现方式见备注）；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、如果收集位置信息的场是风控服务场景，则触发对应功能场景，检查应用获取用户同意情况；');

  await dt.sleep();
  dt.log.i('预期结果3、仅基于风控服务场景，收集用户填写的位置信息时，需要用户单独同意（单独同意实现方式见备注）；如果前期已经基于其他目的收集了位置信息，当前需要基于第二目的风控服务进行使用，需要在隐私声明中进行告知，并获得用户同意；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、如果收集精确位置信息的场景仅包括广告服务、画像服务、风控服务场景，并且PIA“梳理个人数据清单”中“个人数据存储位置”属于云端， 则触发对应场景，检查获取用户同意的情况。');

  await dt.sleep();
  dt.log.i('预期结果4、广告服务、画像服务、风控服务场景，如果仅基于以上服务收集精确位置信息在云端处理，需要获得用户的单独同意（单独同意实现方式见备注）。');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、如果PIA中“梳理个人数据清单”中的“图片信息”的对应的“使用个人数据的目的”是身份标识或身份识别，则触发对应功能场景，检查获取用户同意的情况。');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('收集图片信息和位置信息满足最小必要规范要求的检查 end');
}

/**
 * 宫格-: [收集个人信息满足最小化原则的测试]
 * GROUP: 宫格 MODULE: TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_0300
 * 前置条件
 * 1、应用收集个人信息
 */
async function multimediaPhotosSecuPrivacyChooseAndConsent0300(dt: Dt) {
  dt.log.i('收集个人信息满足最小化原则的测试 start');
  dt.log.i('STEP 1、获取应用个人信息清单，确认应用收集位置信息、图片信息、终端通讯录、设备信息、应用软件列表、人脸、录像信息、短信、通话记录、身份信息、剪切板等个人信息项，以及对应的场景；');

  await dt.sleep();
  dt.log.i('STEP 2、检查应用收集位置信息、设备信息，是否满足《CBG APP收集使用个人信息最小必要使用规范》（见备注）');

  await dt.sleep();
  dt.log.i('预期结果2、应用位置信息、图片信息、终端通讯录、设备信息、应用软件列表、人脸、录像信息、短信、通话记录、身份信息、剪切板信，满足《CBG APP收集使用个人信息最小必要使用规范》要求4、应用收集和处理位置信息、图片信息、终端通讯录、设备信息、应用软件列表、人脸、录像信息、短信、通话记录、身份信息、剪切板满足《CBG APP收集使用个人信息最小必要使用规范》要求');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、创建sechunter安全测试服务-隐私安全-敏感行为监控任务，敏感行为模板选择自定义配置，并选择“全选”；');

  await dt.sleep();
  dt.log.i('STEP 4、遍历应用功能，并检查敏感行为监控实时状态中，应用收集收集位置信息、图片信息、终端通讯录、设备信息、应用软件列表、人脸、录像信息、短信、通话记录、身份信息、剪切板个人信息行为的功能场景，是否满足《CBG APP收集使用个人信息最小必要使用规范》（见备注）');

  await dt.sleep();
  dt.log.i('预期结果4、应用收集和处理位置信息、图片信息、终端通讯录、设备信息、应用软件列表、人脸、录像信息、短信、通话记录、身份信息、剪切板满足《CBG APP收集使用个人信息最小必要使用规范》要求');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('收集个人信息满足最小化原则的测试 end');
}

/**
 * 宫格-: [应用修改系统或其他应用的配置需用户的同意]
 * GROUP: 宫格 MODULE: TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_0900
 * 前置条件
 * 1、应用运行时会修改其他应用或系统的配置
 2、应用可以设置隐私相关设置开关，比如开启GPS、BT、打开自动备份等
 */
async function multimediaPhotosSecuPrivacyChooseAndConsent0900(dt: Dt) {
  dt.log.i('应用修改系统或其他应用的配置需用户的同意 start');
  dt.log.i('STEP 1、打开应用或应用更新后，查看应用是否会私自修改其他应用配置或修改隐私相关设置开关（含收集个人信息权限状态）');

  await dt.sleep();
  dt.log.i('预期结果1、应用不允许私自修改其他应用配置和隐私相关的设置，必须给用户提示，并提供给用户同意和取消的选项，');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、如果应用弹出提示框，选择“拒绝”');

  await dt.sleep();
  dt.log.i('预期结果2、拒绝后，不会修改配置');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、选择“同意”注：收集个人信息权限状态指用于控制收集个人数据功能的开关值；系统隐私相关设置开关包括：GPS、BT、Wifi Hotspot、BT Tethering（蓝牙网络共享）、USB Tethering（USB网络共享）、NFC、云服务自动同步、自动备份、用户体验改进计划等');

  await dt.sleep();
  dt.log.i('预期结果3、同意后才能修改。【示例】：1）恢复出厂设置时，提示用户所有的系统配置会恢复成出厂时的默认状态，用户同意后才可启动恢复流程。2）应用A需要打开GPS才可进行相关业务行为。如果用户在启动应用A时GPS为关闭状态，应用须提示用户打开GPS开关（可提供用户快捷进入设置菜单的提示框）。如果用户不主动打开，则应用A不能私自开启GPS开关并启用相关业务。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用修改系统或其他应用的配置需用户的同意 end');
}

/**
 * 宫格-: [撤销修改用户个人空间行为的用户同意的检查]
 * GROUP: 宫格 MODULE: TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_1000
 * 前置条件
 * 无
 */
async function multimediaPhotosSecuPrivacyChooseAndConsent1000(dt: Dt) {
  dt.log.i('撤销修改用户个人空间行为的用户同意的检查 start');
  dt.log.i('STEP 1、检查应用是否提供撤销同意的功能');

  await dt.sleep();
  dt.log.i('预期结果1、应用针对用户单独授权的功能、基于个人同意处理个人信息行为、敏感权限申请、直销、个性化广告、个性化推荐（参照各国法律要求），提供对应的撤销机制；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、检查应用是否有告知用户撤销同意的方式');

  await dt.sleep();
  dt.log.i('预期结果2.1、应用告知用户撤销同意的方式，且方式正确，路径在进入APP后4层以内。（例如开机向导增强服务同意时也要提供用户关闭选项的方法）如果撤销同意的方法足够明了，则不需要在用户同意界面告知。备注：隐私声明&用户协议签署是提供服务的前提必要条件，针对隐私声明以及用户协议文档本身可以不提供撤销同意机制。2.2、新加坡要求：数据主体撤销同意，数据控制者需要告知撤销同意的后果2.3、泰国要求：如果撤回同意将影响数据主体，数据控制者应将撤回同意的后果告知数据主体');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、若业务为运动健康类，检查撤销同意的机制');

  await dt.sleep();
  dt.log.i('预期结果3.1、针对运动健康：需按照类别撤销，不能打包撤销，用户可以随时关闭将数据上传至运动健康云。3.2、应当明确按照运动健康数据分类（个人信息、运动数据、健康数据）提供用户数据上传运动健康云的开关设置，并在隐私通知中明确指引用户关闭设置的路径。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('撤销修改用户个人空间行为的用户同意的检查 end');
}

/**
 * 宫格-: [拒绝采集个人信息或权限的检查]
 * GROUP: 宫格 MODULE: TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_1200
 * 前置条件
 * 1. 应用收集个人信息
 */
async function multimediaPhotosSecuPrivacyChooseAndConsent1200(dt: Dt) {
  dt.log.i('拒绝采集个人信息或权限的检查 start');
  dt.log.i('STEP 1、进入“设置”-“应用和服务”-“应用管理”，搜索被测应用，进入应用信息页面，拒绝所有权限');

  await dt.sleep();
  dt.log.i('STEP 2、进入应用，触发应用申请收集个人信息场景（通过遍历应用，或通过PIA中“梳理个人数据清单”，确认涉及收集个人数据的场景，并触发）');

  await dt.sleep();
  dt.log.i('STEP 3、若应用存在向用户申请环节（包括权限申请，以及其他获取同意的环节），拒绝申请；');

  await dt.sleep();
  dt.log.i('STEP 4、检查应用运行状态；');

  await dt.sleep();
  dt.log.i('预期结果4.1、应用能够正常运行，若应用无法运行，则应用申请的权限或功能是应用提供核心功能所必须，即非必要权限关闭，不影响基本功能使用；判断标准参考备注。例如地图类App不同意打开短信权限，则拒绝提供所有业务功能；应用市场评论头像编辑需访问照片信息申请存储权限，用户拒绝不能影响应用市场基本功能使用。4.2、针对敏感权限（见备注）申请应满足，用户不给权限，APP要能正常启动（例外场景需经过各业务隐私TMG评审）：（1）敏感权限拒绝后，有可用功能（例如存在与权限无关的附加或者设置功能），APP应该可以启动。（2）敏感权限拒绝后，无可用功能（需要根据各业务功能判断），APP可不启动，但是需要提示用户影响。4.3、如果应用支持注册和登录功能（例如注册和登陆账号），则用户拒绝敏感权限申请之后，应能够注册和登陆；4.4、不得仅以服务体验、产品研发、算法推荐、风险控制等为由，强制要求用户同意超范围或者与服务场景无关的个人信息处理行为。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('拒绝采集个人信息或权限的检查 end');
}

/**
 * 宫格-下载: [应用频繁和过度申请权限检查]
 * GROUP: 宫格 MODULE: 下载TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_1400
 * 前置条件
 * 1、应用涉及申请敏感权限（见备注）
 */
async function multimediaPhotosSecuPrivacyChooseAndConsent1400(dt: Dt) {
  dt.log.i('应用频繁和过度申请权限检查 start');
  dt.log.i('STEP 1、梳理PIA的“权限管理”章节，动态申请权限对应的功能场景；');

  await dt.sleep();
  dt.log.i('STEP 2、启动应用，触发步骤1中确认的场景，分析权限申请场景中包括的功能，并检查权限申请过程；');

  await dt.sleep();
  dt.log.i('预期结果2.1、敏感权限申请应告知用户权限使用目的，并且应满足《CBG APP收集使用个人信息最小必要使用规范》（见备注）中告知同意最小必要、收集信息频率/时机最小化、使用最小化、权限使用最小化的要求；2.2、应用一启动，未见直接相关功能、服务，不提前弹框申请相关权限备注：PCAC评估豁免业务除外2.3、应用存在多个“业务功能”情况下，不存在要求个人信息主体一次性接受并授权同意其未申请或使用的业务功能收集个人信息的请求；“业务功能”：是指给用户提供不同的服务类型。例如：如地图导航、网络约车、即时通讯、 网络社区 、网络支付、新闻资讯、网上购物、快递配送、交通票务等都为不同服务类型。对CBG现有业务的解读情况：1）生活服务集成了很多第三方的业务，用户点击后呈现第三方的隐私政策，等同于用户的明示同意2）运动健康集成了第三方服务，由用户主动授权进行分享，等同于用户的明示同意');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('业务功能'));
  dt.log.i('STEP 3、拒绝敏感权限申请，且之后不做任何操作');

  await dt.sleep();
  dt.log.i('预期结果3）Pay：门禁和卡、pass等管理均需要用户自主输入，等同于用户的明示同意');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、应用切换到后台运行，并再次进入应用，并触发步骤1中的场景；');

  await dt.sleep();
  dt.log.i('预期结果4）智慧视觉由用户双指按压进入，用户知晓使用该业务将获得什么类型的服务。');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、退出应用（删除应用任务），并再次进入应用，并触发步骤1中的场景；');

  await dt.sleep();
  dt.log.i('预期结果5）浏览器，教育中心、搜索业务、负一屏建议参考业界执行方式，并做进一步的执法案例跟踪');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果6）为用户提供网上购买商品或服务的服务类型，包括商品展示、搜索、下单、交付、客服售后等功能，该网上购物为交付货物给用户进行一些列的操作不作为捆绑的解读。2.4、应用存在多功能页签（每个页签未细分子功能），未见功能页签直接相关功能和服务，不能提前弹框申请相关权限2.5、应用存在多功能页签，每个功能页签又细分多个业务子功能，用户必须点击相关子功能时才能弹框申请相关权限，不能提前弹框申请相关权限2.6 、对于图片信息、应用列表、图片信息、剪切板信息的获取，应满足以下要求：（1）图片信息：优先采用非申请存储权限方式读写媒体库：读取媒体库时优先使用Action_pick，写入媒体库（存储照片），优先下载到Download目录，而不申请存储权限（2）应用列表，为敏感权限需要遵从敏感权限所有合规要求，同时：监管实施标准暂未明确定义管控接口范围，以HM3.0举例，暂定应用软件列表权限管控接口如下（视后续执法动态调整）1）getInstalledApplications；2）getInstalledApplicationsAsUser；3）getInstalledPackages；4）getInstalledPackagesAsUser；备注：应优先使用以上4个接口获取应用软件列表，禁止使用其他接口或者方式获取应用软件列表绕过操作系统层面管控的恶意行为。（3）剪切板：若移动终端支持管控读取剪切板权限，则APP应向移动终端请求剪切板权限，并获得个人信息主体明确的授权同意3.1、拒绝权限之后，应用不存在循环弹窗申请权限，使用户无法继续使用的情况。3.2、中国区，拒绝授权之后，不存在频繁弹框申请权限情况；频繁弹框申请定义（来源《CBG隐私合规基线 5.3》）：     a）应用触发：用户拒绝授权之后，在非用户主动触发权限所涉及的业务场景的情况下，再次弹出权限弹窗即为频繁     b）用户触发：此功能必要权限，用户拒绝之后，用户短时间内自行多次触发，可以多次弹框3.3、欧洲区，拒绝授权之后，不存在频繁弹框申请权限情况，并满足欧洲区频繁弹窗管控要求；欧洲区，频繁弹窗管控要求（来源《CBG隐私合规基线 5.3》）： 1）在用户明确拒绝后，APP运行期间或APP退出重新运行时，均不应向用户频繁弹窗申请与当前服务场景无关的功能启动请求，影响用户正常使用。2）用户明确作出选择后，引导弹窗申请频度建议每月1次，特殊情况最多不超过3次。具体可由欧洲子公司业务团队决策。4 .1、 5.1、中国区，不存在向用户频繁弹窗申请权限的情况。频繁弹框申请定义（来源《CBG隐私合规基线 5.3》）：     a）应用触发：用户拒绝授权之后，在非用户主动触发权限所涉及的业务场景的情况下，再次弹出权限弹窗即为频繁     b）用户触发：此功能必要权限，用户拒绝之后，用户短时间内自行多次触发，可以多次弹框4 .2、 5.2、欧洲区，不存在向用户频繁弹窗申请权限的情况，并满足欧洲区频繁弹窗管控要求。欧洲区，频繁弹窗管控要求： 1）在用户明确拒绝后，APP运行期间或APP退出重新运行时，均不应向用户频繁弹窗申请与当前服务场景无关的功能启动请求，影响用户正常使用。2）用户明确作出选择后，引导弹窗申请频度建议每月1次，特殊情况最多不超过3次。具体可由欧洲子公司业务团队决策。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用频繁和过度申请权限检查 end');
}

/**
 * 宫格-: [隐私相关开关选项的检查]
 * GROUP: 宫格 MODULE: TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_2100
 * 前置条件
 * 应用存在隐私相关功能开关
 */
async function multimediaPhotosSecuPrivacyChooseAndConsent2100(dt: Dt) {
  dt.log.i('隐私相关开关选项的检查 start');
  dt.log.i('STEP 1、进入应用界面，检查所有涉及隐私相关的选项的位置，如：数据收集开关、设置开关、隐私声明。');

  await dt.sleep();
  dt.log.i('预期结果1、隐私相关的选项的位置不能被xxx、隐藏、字体太小；用户点击次数应该在4层及以内。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私相关开关选项的检查 end');
}

/**
 * 宫格-删除: [用户撤销同意，停止收集和使用用户数据的检查]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_3800
 * 前置条件
 * 1、涉及获取用户同意的场景
 2、用户已选择同意
 */
async function multimediaPhotosSecuPrivacyChooseAndConsent3800(dt: Dt) {
  dt.log.i('用户撤销同意，停止收集和使用用户数据的检查 start');
  dt.log.i('STEP 1、使用sechunter监控手机，创建“敏感行为监控”任务（任务名称，需记录至测试用例的result_DetailInfo中）， 选择“个人数据隐私测试”模板。');

  await dt.sleep();
  dt.log.i('STEP 2、用户根据撤销方式，选择撤销同意，静置5分钟。如果撤销同意仍可以使用应用（应用存在本地版本不同意也可以用），尽量遍历足够多的功能，再静置5分钟。检查sechunter敏感行为监控报告。');

  await dt.sleep();
  dt.log.i('预期结果2、撤销同意后，立刻停止对个人数据的处理、收集和使用，sechunter敏感行为监控内容中无任何行为；4、撤销同意后，立刻停止对个人数据的处理、收集和使用，sechunter联网行为分析报告中无个人数据；5、国内：用户撤销同意后，及时删除或者匿名化个人信息，删除个人信息从技术上难以实现的，个人信息处理者应当停止除存储和采取必要的安全保护措施之外的处理。      海外：撤销同意后，应该立刻停止收集用户的数据。并确保历史数据要被删除或者做匿名化（优秀实践是1个月内），法律法规有特别要求的除外。注：按测试用例执行在SecHunter工具上所创建的测试任务，任务中所检测出的问题，均需要做确认清零处理，如果有非测试任务所涉及的问题，可以批量确认为“测试任务为**特性，不涉及此部分”注意：UUID属于个人数据，撤销同意后，同样不能收集');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('测试任务为**特性，不涉及此部分'));
  dt.log.i('STEP 3、结束sechunter敏感行为监控任务，将应用恢复到用例初始状态，再创建“联网行为分析”任务（任务名称，需记录至测试用例的result_DetailInfo中）。');

  await dt.sleep();
  dt.log.i('STEP 4、用户根据撤销方式，选择撤销同意，静置5分钟。如果撤销同意仍可以使用应用（应用存在本地版本不同意也可以用），尽量遍历足够多的功能，再静置5分钟。检查sechunter联网行为分析报告。');

  await dt.sleep();
  dt.log.i('预期结果4、撤销同意后，立刻停止对个人数据的处理、收集和使用，sechunter联网行为分析报告中无个人数据；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、步骤2和4撤销后，检查已收集的个人数据');

  await dt.sleep();
  dt.log.i('预期结果5、国内：用户撤销同意后，及时删除或者匿名化个人信息，删除个人信息从技术上难以实现的，个人信息处理者应当停止除存储和采取必要的安全保护措施之外的处理。      海外：撤销同意后，应该立刻停止收集用户的数据。并确保历史数据要被删除或者做匿名化（优秀实践是1个月内），法律法规有特别要求的除外。注：按测试用例执行在SecHunter工具上所创建的测试任务，任务中所检测出的问题，均需要做确认清零处理，如果有非测试任务所涉及的问题，可以批量确认为“测试任务为**特性，不涉及此部分”注意：UUID属于个人数据，撤销同意后，同样不能收集');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('测试任务为**特性，不涉及此部分'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户撤销同意，停止收集和使用用户数据的检查 end');
}

/**
 * 宫格-: [用户拒绝使用个人数据后不能频繁弹框提示用户授权的检查]
 * GROUP: 宫格 MODULE: TID: Multimedia_Photos_Secu_Privacy_ChooseAndConsent_3900
 * 前置条件
 * 1、应用涉及使用个人数据提供服务
 */
async function multimediaPhotosSecuPrivacyChooseAndConsent3900(dt: Dt) {
  dt.log.i('用户拒绝使用个人数据后不能频繁弹框提示用户授权的检查 start');
  dt.log.i('STEP 1、启动应用；');

  await dt.sleep();
  dt.log.i('预期结果1、进入应用界面，提示用户需要获得个人数据的权限；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、用户拒绝权限授权，且不做任何的操作；');

  await dt.sleep();
  dt.log.i('预期结果2、应用软件不能再次弹框提示授权；用户没有进行任何操作的情况下，不能频繁弹框提示用户授权；在48小时内向用户征求同意的次数不得超过一次；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、退出应用后再次打开该应用');

  await dt.sleep();
  dt.log.i('预期结果3、应用不能每次打开都提醒（核心功能除外，如进入应用首界面就会需要使用的权限）。（核心功能的解读：满足个人信息主体选择使用本应用的最主要需求和根本期待的业务或功能）例外情况：1、针对影响核心功能正常使用，例如云空间满了，担心影响用户的使用做出的提示，不落入过度频繁和干扰用户的范畴。2、用户主动触发场景除外，例如查询附近美食要求提供位置权限，用户首次拒绝后，后续用户频繁请求服务时可以弹框申请位置权限，不落入过度频繁和干扰用户的范畴。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户拒绝使用个人数据后不能频繁弹框提示用户授权的检查 end');
}