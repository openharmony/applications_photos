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

export default function GalleryWatermarkEditing(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('GalleryWatermarkEditingTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllGalleryWatermarkEditing').init();
      dt.log.i('beforeAll GalleryWatermarkEditing start');
      dt.log.i('beforeAll GalleryWatermarkEditing finish');
    });
    /**
     * 打开大图
     */
    run('beforeGalleryWatermarkEditing', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('Multimedia_Gallery_Watermark_Editing_001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  水印-用例: [支持水印图片编辑显示水印页签] TID: Multimedia_Gallery_Watermark_Editing_001
      await Multimedia_Gallery_Watermark_Editing_001(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [不支持水印图片编辑不显示水印页签] TID: Multimedia_Gallery_Watermark_Editing_002
      await Multimedia_Gallery_Watermark_Editing_002(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  水印-HDR用例: [无水印图片增加通用水印] TID: Multimedia_Gallery_Watermark_Editing_003
      await Multimedia_Gallery_Watermark_Editing_003(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_004', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  水印-HDR用例: [无水印图片增加画框水印] TID: Multimedia_Gallery_Watermark_Editing_004
      await Multimedia_Gallery_Watermark_Editing_004(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  水印-HDR用例: [通用水印图片再编辑] TID: Multimedia_Gallery_Watermark_Editing_005
      await Multimedia_Gallery_Watermark_Editing_005(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  水印-HDR用例: [画框水印图片再编辑] TID: Multimedia_Gallery_Watermark_Editing_006
      await Multimedia_Gallery_Watermark_Editing_006(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  水印-用例: [图片编辑水印对比，撤销，恢复按钮显示] TID: Multimedia_Gallery_Watermark_Editing_007
      await Multimedia_Gallery_Watermark_Editing_007(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_008', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  水印-HDR用例: [图片编辑水印后保存] TID: Multimedia_Gallery_Watermark_Editing_008
      await Multimedia_Gallery_Watermark_Editing_008(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-大图用例: [图片编辑水印保存后还原] TID: Multimedia_Gallery_Watermark_Editing_009
      await Multimedia_Gallery_Watermark_Editing_009(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [通用水印图片基础编辑操作] TID: Multimedia_Gallery_Watermark_Editing_010
      await Multimedia_Gallery_Watermark_Editing_010(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [画框水印图片基础编辑操作] TID: Multimedia_Gallery_Watermark_Editing_011
      await Multimedia_Gallery_Watermark_Editing_011(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [水印图片AI修图后保存] TID: Multimedia_Gallery_Watermark_Editing_012
      await Multimedia_Gallery_Watermark_Editing_012(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_013', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [带水印图片涂鸦不显示] TID: Multimedia_Gallery_Watermark_Editing_013
      await Multimedia_Gallery_Watermark_Editing_013(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_014', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  水印-用例: [图片尺寸过小不支持水印调节] TID: Multimedia_Gallery_Watermark_Editing_014
      await Multimedia_Gallery_Watermark_Editing_014(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_015', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [水印图片切换横屏ux显示] TID: Multimedia_Gallery_Watermark_Editing_015
      await Multimedia_Gallery_Watermark_Editing_015(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_016', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  水印-用例: [水印图片切换分屏悬浮窗ux显示] TID: Multimedia_Gallery_Watermark_Editing_016
      await Multimedia_Gallery_Watermark_Editing_016(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_017', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  水印-用例: [相机拍摄不支持水印图片显示（组合）] TID: Multimedia_Gallery_Watermark_Editing_017
      await Multimedia_Gallery_Watermark_Editing_017(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_018', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-HEIF用例: [相机拍摄不同类型支持水印图片显示（组合）] TID: Multimedia_Gallery_Watermark_Editing_018
      await Multimedia_Gallery_Watermark_Editing_018(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_019', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-HEIF用例: [相机拍摄不同类型通用水印图片显示（组合）] TID: Multimedia_Gallery_Watermark_Editing_019
      await Multimedia_Gallery_Watermark_Editing_019(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_020', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  水印-HEIF用例: [相机拍摄不同类型画框水印图片显示（组合）] TID: Multimedia_Gallery_Watermark_Editing_020
      await Multimedia_Gallery_Watermark_Editing_020(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_021', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-云增强用例: [云增强图片水印编辑] TID: Multimedia_Gallery_Watermark_Editing_021
      await Multimedia_Gallery_Watermark_Editing_021(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_022', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  水印-用例: [xxx同步/分享/克隆图片支持原图水印信息] TID: Multimedia_Gallery_Watermark_Editing_022
      await Multimedia_Gallery_Watermark_Editing_022(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_023', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  水印-用例: [xxx拍摄/同步/分享/克隆图片支持增加水印] TID: Multimedia_Gallery_Watermark_Editing_023
      await Multimedia_Gallery_Watermark_Editing_023(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_024', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  水印-用例: [xxx同步/分享/克隆图片不支持水印编辑和增加水印] TID: Multimedia_Gallery_Watermark_Editing_024
      await Multimedia_Gallery_Watermark_Editing_024(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_025', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  水印-用例: [三方应用保存照片不支持不支持水印编辑和增加水印] TID: Multimedia_Gallery_Watermark_Editing_025
      await Multimedia_Gallery_Watermark_Editing_025(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_026', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  水印-用例: [xxx图片不支持水印编辑和增加水印] TID: Multimedia_Gallery_Watermark_Editing_026
      await Multimedia_Gallery_Watermark_Editing_026(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_027', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  水印-用例: [截屏图片不支持不支持水印编辑和增加水印] TID: Multimedia_Gallery_Watermark_Editing_027
      await Multimedia_Gallery_Watermark_Editing_027(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_028', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [带画框水印图片基础编辑] TID: Multimedia_Gallery_Watermark_Editing_028
      await Multimedia_Gallery_Watermark_Editing_028(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_029', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [带画框水印照片进入退出AI编辑、涂鸦] TID: Multimedia_Gallery_Watermark_Editing_029
      await Multimedia_Gallery_Watermark_Editing_029(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_030', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [增加水印] TID: Multimedia_Gallery_Watermark_Editing_030
      await Multimedia_Gallery_Watermark_Editing_030(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_031', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-HDR用例: [去除水印] TID: Multimedia_Gallery_Watermark_Editing_031
      await Multimedia_Gallery_Watermark_Editing_031(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_032', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-竖屏用例: [横屏动效] TID: Multimedia_Gallery_Watermark_Editing_032
      await Multimedia_Gallery_Watermark_Editing_032(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_033', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [水印编辑分屏悬浮窗] TID: Multimedia_Gallery_Watermark_Editing_033
      await Multimedia_Gallery_Watermark_Editing_033(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-深色用例: [水印编辑深色模式] TID: Multimedia_Gallery_Watermark_Editing_034
      await Multimedia_Gallery_Watermark_Editing_034(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_035', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [水印编辑适老化] TID: Multimedia_Gallery_Watermark_Editing_035
      await Multimedia_Gallery_Watermark_Editing_035(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_036', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [水印编辑无障碍] TID: Multimedia_Gallery_Watermark_Editing_036
      await Multimedia_Gallery_Watermark_Editing_036(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_037', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [水印编辑多语言] TID: Multimedia_Gallery_Watermark_Editing_037
      await Multimedia_Gallery_Watermark_Editing_037(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_038', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [水印编辑xxxxxx显示] TID: Multimedia_Gallery_Watermark_Editing_038
      await Multimedia_Gallery_Watermark_Editing_038(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_039', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [水印编辑xxx收起态显示] TID: Multimedia_Gallery_Watermark_Editing_039
      await Multimedia_Gallery_Watermark_Editing_039(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_040', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  水印-用例: [水印编辑xxx展开xxx切换] TID: Multimedia_Gallery_Watermark_Editing_040
      await Multimedia_Gallery_Watermark_Editing_040(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_041', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  水印-大图用例: [水印图片编辑保存图片场景完成时延] TID: Multimedia_Gallery_Watermark_Editing_041
      await Multimedia_Gallery_Watermark_Editing_041(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_043', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  水印-用例: [图片水印编辑内存测试] TID: Multimedia_Gallery_Watermark_Editing_043
      await Multimedia_Gallery_Watermark_Editing_043(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_045', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  水印-用例: [动态图片不支持水印编辑] TID: Multimedia_Gallery_Watermark_Editing_045
      await Multimedia_Gallery_Watermark_Editing_045(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_046', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  水印-视频用例: [视频不支持水印编辑] TID: Multimedia_Gallery_Watermark_Editing_046
      await Multimedia_Gallery_Watermark_Editing_046(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_047', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  水印-大图用例: [照片页入口进行水印编辑操作] TID: Multimedia_Gallery_Watermark_Editing_047
      await Multimedia_Gallery_Watermark_Editing_047(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_048', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  水印-收藏用例: [系统相册页入口进行水印编辑操作] TID: Multimedia_Gallery_Watermark_Editing_048
      await Multimedia_Gallery_Watermark_Editing_048(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_049', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  水印-大图用例: [用户创建相册入口进行水印编辑操作] TID: Multimedia_Gallery_Watermark_Editing_049
      await Multimedia_Gallery_Watermark_Editing_049(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_050', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  水印-大图用例: [来源相册入口进行水印编辑操作] TID: Multimedia_Gallery_Watermark_Editing_050
      await Multimedia_Gallery_Watermark_Editing_050(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_051', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  水印-大图用例: [智慧相册入口进行水印编辑操作] TID: Multimedia_Gallery_Watermark_Editing_051
      await Multimedia_Gallery_Watermark_Editing_051(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_052', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  水印-大图用例: [精彩时刻入口进行水印编辑操作] TID: Multimedia_Gallery_Watermark_Editing_052
      await Multimedia_Gallery_Watermark_Editing_052(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_053', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  水印-大图用例: [搜索入口进行水印编辑操作] TID: Multimedia_Gallery_Watermark_Editing_053
      await Multimedia_Gallery_Watermark_Editing_053(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_054', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  水印-连拍用例: [不同入口连拍照片进行水印编辑] TID: Multimedia_Gallery_Watermark_Editing_054
      await Multimedia_Gallery_Watermark_Editing_054(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_055', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  水印-大图用例: [相机入口打开大图进行水印编辑] TID: Multimedia_Gallery_Watermark_Editing_055
      await Multimedia_Gallery_Watermark_Editing_055(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_060', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [不同型号设备同步带水印照片进编辑页] TID: Multimedia_Gallery_Watermark_Editing_060
      await Multimedia_Gallery_Watermark_Editing_060(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_061', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [不同型号设备同步无水印照片进编辑页] TID: Multimedia_Gallery_Watermark_Editing_061
      await Multimedia_Gallery_Watermark_Editing_061(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_062', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-端云用例: [同型号设备同步带水印照片进编辑页] TID: Multimedia_Gallery_Watermark_Editing_062
      await Multimedia_Gallery_Watermark_Editing_062(dt);
    });
    run('Multimedia_Gallery_Watermark_Editing_063', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  水印-用例: [同型号设备同步添加图片水印照片后进编辑页] TID: Multimedia_Gallery_Watermark_Editing_063
      await Multimedia_Gallery_Watermark_Editing_063(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachGalleryWatermarkEditing').init();
      dt.log.i('afterEach GalleryWatermarkEditing start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach GalleryWatermarkEditing finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllGalleryWatermarkEditing').init();
      dt.log.i('afterAll GalleryWatermarkEditing start');
      await Exit.browser();
      dt.log.i('afterAll GalleryWatermarkEditing finish');
    });
  });
}

// DT步骤
/**
 * 水印-: [支持水印图片编辑显示水印页签]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_001
 * 前置条件
 * 图库存在支持水印编辑的普通图片，通用水印图片，画框水印图片（除流光快门模式、全景模式、所有前置拍照的其它模式均支持两种水印）
 */
async function Multimedia_Gallery_Watermark_Editing_001(dt: Dt) {
  dt.log.i('支持水印图片编辑显示水印页签 start');
  dt.log.i('STEP 1.1、普通图片进编辑1.2、点击水印tab');

  await dt.sleep();
  dt.log.i('预期结果1.1、编辑页面显示水印页签1.2、默认显示在关闭水印类型页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.1、通用水印进编辑2.2、点击水印tab');

  await dt.sleep();
  dt.log.i('预期结果2.1、编辑页面显示水印页签2.2、默认显示在通用水印类型页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.1、画框水印图片进编辑3.2、点击水印tab');

  await dt.sleep();
  dt.log.i('预期结果3.1、编辑页面显示水印页签3.2、默认显示在画框水印类型页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('支持水印图片编辑显示水印页签 end');
}

/**
 * 水印-: [不支持水印图片编辑不显示水印页签]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_002
 * 前置条件
 * 图库存在不支持水印编辑的图片（流光快门模式、全景模式、所有前置拍照）
 */
async function Multimedia_Gallery_Watermark_Editing_002(dt: Dt) {
  dt.log.i('不支持水印图片编辑不显示水印页签 start');
  dt.log.i('STEP 1、点击图片进编辑页面');

  await dt.sleep();
  dt.log.i('预期结果2、编辑页面不显示水印页签');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不支持水印图片编辑不显示水印页签 end');
}

/**
 * 水印-HDR: [无水印图片增加通用水印]
 * GROUP: 水印 MODULE: HDRTID: Multimedia_Gallery_Watermark_Editing_003
 * 前置条件
 * 图库存在支持水印编辑的普通图片（除流光快门模式、全景模式、所有前置拍照的其它模式均支持两种水印），进入编辑页面
 */
async function Multimedia_Gallery_Watermark_Editing_003(dt: Dt) {
  dt.log.i('无水印图片增加通用水印 start');
  dt.log.i('STEP 1、点击水印页签');

  await dt.sleep();
  dt.log.i('预期结果1、默认显示在关闭水印类型页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、勾选通用水印页签，查看默认显示');

  await dt.sleep();
  dt.log.i('预期结果2、默认状态显示为：拍摄机型开（高亮态）；拍摄时间关（非高亮态）；图片预览区显示拍摄机型信息');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、设置水印信息：拍摄机型开，拍摄时间开');

  await dt.sleep();
  dt.log.i('预期结果3、拍摄机型和拍摄时间按钮同时开启（高亮态）；图片预览区两项信息同时显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、设置水印信息：拍摄机型开，拍摄时间关');

  await dt.sleep();
  dt.log.i('预期结果4、拍摄机型开（高亮态），拍摄时间关（非高亮态）；图片预览区显示拍摄机型信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、设置水印信息：拍摄机型关，拍摄时间开');

  await dt.sleep();
  dt.log.i('预期结果5、拍摄机型关（非高亮态），拍摄时间开（高亮态）；图片预览区显示拍摄时间信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、设置水印信息：拍摄机型关，拍摄时间关');

  await dt.sleep();
  dt.log.i('预期结果6、拍摄时间关，拍摄机型联动高亮；图片预览区显示拍摄机型信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、保存图片，查看大图和缩略图显示');

  await dt.sleep();
  dt.log.i('预期结果7、显示为修改后的效果（HDR图片修改保存后变为SDR）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无水印图片增加通用水印 end');
}

/**
 * 水印-HDR: [无水印图片增加画框水印]
 * GROUP: 水印 MODULE: HDRTID: Multimedia_Gallery_Watermark_Editing_004
 * 前置条件
 * 图库存在支持水印编辑的普通图片，（除流光快门模式、全景模式、所有前置拍照的其它模式均支持两种水印）,进入编辑页面
 */
async function Multimedia_Gallery_Watermark_Editing_004(dt: Dt) {
  dt.log.i('无水印图片增加画框水印 start');
  dt.log.i('STEP 1、点击水印页签');

  await dt.sleep();
  dt.log.i('预期结果1、默认显示在关闭水印类型页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、勾选画框水印页签，查看默认显示');

  await dt.sleep();
  dt.log.i('预期结果2、默认状态显示为：拍摄参数开（高亮态）；拍摄时间关（非高亮态）；图片预览区显示对应信息');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、设置水印信息：拍摄参数开，拍摄时间开');

  await dt.sleep();
  dt.log.i('预期结果3、拍摄参数和拍摄时间按钮同时开启（高亮态）；图片预览区显示对应信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、设置水印信息：拍摄参数开，拍摄时间关');

  await dt.sleep();
  dt.log.i('预期结果4、拍摄参数关，拍摄时间开；图片预览区显示对应信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、设置水印信息：拍摄参数关，拍摄时间开');

  await dt.sleep();
  dt.log.i('预期结果5、拍摄参数关，拍摄时间开；图片预览区显示对应信息');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、设置水印信息：拍摄参数关，拍摄时间关');

  await dt.sleep();
  dt.log.i('预期结果6、拍摄参数关，拍摄时间关，图片预览区新增镜头传播名');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、保存图片，查看大图和缩略图显示');

  await dt.sleep();
  dt.log.i('预期结果7、显示为修改后的效果（HDR图片修改保存后变为SDR）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无水印图片增加画框水印 end');
}

/**
 * 水印-HDR: [通用水印图片再编辑]
 * GROUP: 水印 MODULE: HDRTID: Multimedia_Gallery_Watermark_Editing_005
 * 前置条件
 * 图库存在通用水印图片
 */
async function Multimedia_Gallery_Watermark_Editing_005(dt: Dt) {
  dt.log.i('通用水印图片再编辑 start');
  dt.log.i('STEP 1、通用水印图片进编辑页面（拍摄机型，拍摄时间组合）');

  await dt.sleep();
  dt.log.i('预期结果1、默认显示在通用水印类型页面，水印信息显示为原有状态');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、修改水印信息（拍摄机型，拍摄时间）');

  await dt.sleep();
  dt.log.i('预期结果2、水印信息支持修改，图片预览区显示对应信息');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、更换水印样式为画框水印');

  await dt.sleep();
  dt.log.i('预期结果3、图片展示为画框水印效果，动效流畅，无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、去除水印效果');

  await dt.sleep();
  dt.log.i('预期结果4、图片展示为无水印状态');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、图片编辑水印后保存');

  await dt.sleep();
  dt.log.i('预期结果5、保存后展示为修改后的状态（HDR图片修改保存后变为SDR）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('通用水印图片再编辑 end');
}

/**
 * 水印-HDR: [画框水印图片再编辑]
 * GROUP: 水印 MODULE: HDRTID: Multimedia_Gallery_Watermark_Editing_006
 * 前置条件
 * 图库存在画框水印图片
 */
async function Multimedia_Gallery_Watermark_Editing_006(dt: Dt) {
  dt.log.i('画框水印图片再编辑 start');
  dt.log.i('STEP 1、画框水印图片进编辑页面（拍摄参数，拍摄时间组合）');

  await dt.sleep();
  dt.log.i('预期结果1、默认显示在画框水印类型页面，水印信息显示为原有状态');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、修改水印信息（拍摄参数，拍摄时间）');

  await dt.sleep();
  dt.log.i('预期结果2、水印信息支持修改，图片预览区显示对应信息');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、更换水印样式为通用水印');

  await dt.sleep();
  dt.log.i('预期结果3、图片展示为通用水印效果，动效流畅，无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、图片编辑水印后保存');

  await dt.sleep();
  dt.log.i('预期结果4、保存后展示为修改后的状态（HDR图片修改保存后变为SDR）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('画框水印图片再编辑 end');
}

/**
 * 水印-: [图片编辑水印对比，撤销，恢复按钮显示]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_007
 * 前置条件
 * 图库存在无水印图片，通用水印图片，画框水印图片，
 */
async function Multimedia_Gallery_Watermark_Editing_007(dt: Dt) {
  dt.log.i('图片编辑水印对比，撤销，恢复按钮显示 start');
  dt.log.i('STEP 1、图片在水印页签不做操作');

  await dt.sleep();
  dt.log.i('预期结果1、未编辑状态下不显示对比、撤销，恢复按钮');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、图片修改水印信息，更换水印样式等');

  await dt.sleep();
  dt.log.i('预期结果2、不显示对比按钮，显示撤销、恢复按钮');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击撤销按钮');

  await dt.sleep();
  dt.log.i('预期结果3、撤销到上一步操作的状态');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击恢复按钮');

  await dt.sleep();
  dt.log.i('预期结果4、恢复到撤销前的状态');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、修改调节/滤镜后，进入水印页签');

  await dt.sleep();
  dt.log.i('预期结果5、显示对比按钮');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、点击对比按钮');

  await dt.sleep();
  dt.log.i('预期结果6、显示出图片未修改前的状态');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片编辑水印对比，撤销，恢复按钮显示 end');
}

/**
 * 水印-HDR: [图片编辑水印后保存]
 * GROUP: 水印 MODULE: HDRTID: Multimedia_Gallery_Watermark_Editing_008
 * 前置条件
 * 图库存在无水印图片，通用水印图片，画框水印图片，
 */
async function Multimedia_Gallery_Watermark_Editing_008(dt: Dt) {
  dt.log.i('图片编辑水印后保存 start');
  dt.log.i('STEP 1、图片设置通用/画框水印编辑后进行保存');

  await dt.sleep();
  dt.log.i('预期结果1、大图正确刷新为修改后的效果（HDR图片修改保存后变为SDR）');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2、缩略图刷新为修改后的效果');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3、保存动效流畅，耗时合理');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片编辑水印后保存 end');
}

/**
 * 水印-大图: [图片编辑水印保存后还原]
 * GROUP: 水印 MODULE: 大图TID: Multimedia_Gallery_Watermark_Editing_009
 * 前置条件
 * 图库存在已修改的水印图片
 */
async function Multimedia_Gallery_Watermark_Editing_009(dt: Dt) {
  dt.log.i('图片编辑水印保存后还原 start');
  dt.log.i('STEP 1、图片添加通用/画框水印后保存');

  await dt.sleep();
  dt.log.i('STEP 2、再次进入编辑页面，点击还原按钮');

  await dt.sleep();
  dt.log.i('预期结果2、右上角显示复原按钮，弹窗提示，是否复原到原始状态');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击取消');

  await dt.sleep();
  dt.log.i('预期结果3、停留在图片编辑页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击确定');

  await dt.sleep();
  dt.log.i('预期结果4、返回到大图页面，图片还原到最原始状态');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片编辑水印保存后还原 end');
}

/**
 * 水印-: [通用水印图片基础编辑操作]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_010
 * 前置条件
 * 图库存在无水印图片，通用水印图片，画框水印图片，
 */
async function Multimedia_Gallery_Watermark_Editing_010(dt: Dt) {
  dt.log.i('通用水印图片基础编辑操作 start');
  dt.log.i('STEP 1、通用水印图片进入裁剪');

  await dt.sleep();
  dt.log.i('预期结果1、裁剪页操作中不显示水印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、切换到调节页签，进行不同参数调节');

  await dt.sleep();
  dt.log.i('预期结果2、调节时显示水印，水印不跟随编辑');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、切换到滤镜页签，进行不同滤镜切换');

  await dt.sleep();
  dt.log.i('预期结果3、滤镜时显示水印，水印不跟随编辑');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、切换到水印页签');

  await dt.sleep();
  dt.log.i('预期结果4、显示水印，支持替换/编辑');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('通用水印图片基础编辑操作 end');
}

/**
 * 水印-: [画框水印图片基础编辑操作]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_011
 * 前置条件
 * 图库存在无水印图片，通用水印图片，画框水印图片，
 */
async function Multimedia_Gallery_Watermark_Editing_011(dt: Dt) {
  dt.log.i('画框水印图片基础编辑操作 start');
  dt.log.i('STEP 1、画框水印图片进入裁剪，裁剪图片');

  await dt.sleep();
  dt.log.i('预期结果1、裁剪页操作中不显示水印，图片裁剪成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、切换到调节页签，进行不同参数调节');

  await dt.sleep();
  dt.log.i('预期结果2、调解时显示水印，水印不跟随编辑，调节参数时预览图无跳变');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、切换到滤镜页签，进行不同滤镜切换');

  await dt.sleep();
  dt.log.i('预期结果3、调节时显示水印，水印不跟随编辑，切换滤镜时预览图无跳变');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、切换到水印页签');

  await dt.sleep();
  dt.log.i('预期结果4、显示水印，支持调整水印类型和参数显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、保存图片');

  await dt.sleep();
  dt.log.i('预期结果5、图片保存成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('画框水印图片基础编辑操作 end');
}

/**
 * 水印-: [水印图片AI修图后保存]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_012
 * 前置条件
 *
 */
async function Multimedia_Gallery_Watermark_Editing_012(dt: Dt) {
  dt.log.i('水印图片AI修图后保存 start');
  dt.log.i('STEP 1、通用水印图片点击AI修图');

  await dt.sleep();
  dt.log.i('预期结果1、AI修图界面内不显示水印，水印不参与编辑');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进行消除，最佳标签，智能扩图，背景等操作');

  await dt.sleep();
  dt.log.i('预期结果2、修图功能正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、保存图片');

  await dt.sleep();
  dt.log.i('预期结果3、图片保存成功（覆盖/另存为）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、画框水印图片点击AI修图');

  await dt.sleep();
  dt.log.i('预期结果4、AI修图界面内不显示水印，水印不参与编辑');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、进行消除，最佳标签，智能扩图，背景等操作');

  await dt.sleep();
  dt.log.i('预期结果5、修图功能正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、保存图片');

  await dt.sleep();
  dt.log.i('预期结果6、图片保存成功（另存为/覆盖）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('水印图片AI修图后保存 end');
}

/**
 * 水印-: [带水印图片涂鸦不显示]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_013
 * 前置条件
 * 图库存在无水印图片，通用水印图片，画框水印图片，
 */
async function Multimedia_Gallery_Watermark_Editing_013(dt: Dt) {
  dt.log.i('带水印图片涂鸦不显示 start');
  dt.log.i('STEP 1、通用水印/画框水印点击涂鸦');

  await dt.sleep();
  dt.log.i('预期结果1、不显示水印，水印不参与编辑');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进行涂鸦操作');

  await dt.sleep();
  dt.log.i('预期结果2、不显示水印，水印不参与编辑');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('带水印图片涂鸦不显示 end');
}

/**
 * 水印-: [图片尺寸过小不支持水印调节]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_014
 * 前置条件
 * 图库存在无水印图片，通用水印图片，画框水印图片（短边大于400像素）
 */
async function Multimedia_Gallery_Watermark_Editing_014(dt: Dt) {
  dt.log.i('图片尺寸过小不支持水印调节 start');
  dt.log.i('STEP 1、通用水印图片裁剪为短边小于400像素');

  await dt.sleep();
  dt.log.i('预期结果1、toast提示“当前尺寸不支持水印，水印页签置灰');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('当前尺寸不支持水印，水印页签置灰'));
  dt.log.i('STEP 2、画框水印图片裁剪为短边小于400像素');

  await dt.sleep();
  dt.log.i('预期结果2、toast提示“当前尺寸不支持水印，水印页签置灰');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('当前尺寸不支持水印，水印页签置灰'));
  dt.log.i('STEP 3、无水印图片裁剪为短边小于400像素');

  await dt.sleep();
  dt.log.i('预期结果3、水印页签置灰');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击置灰的水印页签');

  await dt.sleep();
  dt.log.i('预期结果4、toast提示“当前尺寸不支持水印');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('当前尺寸不支持水印', true);
  dt.log.i('STEP 5、裁剪短边小于400像素保存图片后，再次进入编辑');

  await dt.sleep();
  dt.log.i('预期结果5、水印标签置灰，点击toast提示“当前尺寸不支持水印');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('当前尺寸不支持水印', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片尺寸过小不支持水印调节 end');
}

/**
 * 水印-: [水印图片切换横屏ux显示]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_015
 * 前置条件
 * 图库存在无水印图片，通用水印图片，画框水印图片（短边大于400像素）
 */
async function Multimedia_Gallery_Watermark_Editing_015(dt: Dt) {
  dt.log.i('水印图片切换横屏ux显示 start');
  dt.log.i('STEP 1、通用/画框水印图片切换横屏');

  await dt.sleep();
  dt.log.i('预期结果1、界面无异常，功能正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、通用/画框水印图片编辑时切换横屏');

  await dt.sleep();
  dt.log.i('预期结果2、界面无异常，功能正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、分别从相机入口、picker入口进入编辑，重复上述步骤');

  await dt.sleep();
  dt.log.i('预期结果3、界面无异常，功能正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('水印图片切换横屏ux显示 end');
}

/**
 * 水印-: [水印图片切换分屏悬浮窗ux显示]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_016
 * 前置条件
 * 图库存在无水印图片，通用水印图片，画框水印图片，
 */
async function Multimedia_Gallery_Watermark_Editing_016(dt: Dt) {
  dt.log.i('水印图片切换分屏悬浮窗ux显示 start');
  dt.log.i('STEP 1、通用/画框水印图片切换到分屏显示');

  await dt.sleep();
  dt.log.i('预期结果1、界面无遮挡，异常，符合ux设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、通用/画框水印图片切换到悬浮窗显示');

  await dt.sleep();
  dt.log.i('预期结果2、界面无遮挡，异常，符合ux设计');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('水印图片切换分屏悬浮窗ux显示 end');
}

/**
 * 水印-: [相机拍摄不支持水印图片显示（组合）]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_017
 * 前置条件
 * 流光快门模式、全景模式、所有前置拍照
 */
async function Multimedia_Gallery_Watermark_Editing_017(dt: Dt) {
  dt.log.i('相机拍摄不支持水印图片显示（组合） start');
  dt.log.i('STEP 1、不同拍摄模式：流光快门模式、全景模式、所有前置拍照进行拍照');

  await dt.sleep();
  dt.log.i('预期结果1、生成无水印普通图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、图片进入编辑页面');

  await dt.sleep();
  dt.log.i('预期结果2、图片不显示水印页签');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机拍摄不支持水印图片显示（组合） end');
}

/**
 * 水印-HEIF: [相机拍摄不同类型支持水印图片显示（组合）]
 * GROUP: 水印 MODULE: HEIFTID: Multimedia_Gallery_Watermark_Editing_018
 * 前置条件
 * 1、不同拍摄模式：夜景，闪拍，人像，拍照，专业，高像素，超级微距，大光圈，延时摄影，全景，高画质模式
 2、照片比例：4：3，1：1，全屏
 3、照片格式：JPG,HEIF,RAW(专业模式下有，会生成两张图片DNG)
 4、以上拍摄模式进行组合
 */
async function Multimedia_Gallery_Watermark_Editing_018(dt: Dt) {
  dt.log.i('相机拍摄不同类型支持水印图片显示（组合） start');
  dt.log.i('STEP 1、查看拍摄的图片');

  await dt.sleep();
  dt.log.i('预期结果1、生成无水印普通图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入编辑页面');

  await dt.sleep();
  dt.log.i('预期结果2、编辑页面显示水印页签，支持水印编辑');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机拍摄不同类型支持水印图片显示（组合） end');
}

/**
 * 水印-HEIF: [相机拍摄不同类型通用水印图片显示（组合）]
 * GROUP: 水印 MODULE: HEIFTID: Multimedia_Gallery_Watermark_Editing_019
 * 前置条件
 * 1、不同拍摄模式：夜景，闪拍，人像，拍照，专业，高像素，超级微距，大光圈，延时摄影，全景，高画质模式
 2、照片比例：4：3，1：1，全屏
 3、照片格式：JPG,HEIF,RAW(专业模式下有，会生成两张图片DNG)
 4、以上拍摄模式进行组合
 */
async function Multimedia_Gallery_Watermark_Editing_019(dt: Dt) {
  dt.log.i('相机拍摄不同类型通用水印图片显示（组合） start');
  dt.log.i('STEP 1、按照前置步骤组合形式依次设置好拍摄机型');

  await dt.sleep();
  dt.log.i('STEP 2、开启通用水印，拍摄机型开，拍摄时间关，查看拍摄图片');

  await dt.sleep();
  dt.log.i('预期结果2、生成通用水印图片（拍摄机型）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入编辑页面');

  await dt.sleep();
  dt.log.i('预期结果3、编辑页面显示水印页签，支持水印编辑修改');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、开启通用水印，拍摄机型开，拍摄时间开，查看拍摄图片');

  await dt.sleep();
  dt.log.i('预期结果4、生成通用水印图片（拍摄机型，拍摄时间）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、进入编辑页面');

  await dt.sleep();
  dt.log.i('预期结果5、编辑页面显示水印页签，支持水印编辑修改');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、开启通用水印，拍摄机型关，拍摄时间开，查看拍摄图片');

  await dt.sleep();
  dt.log.i('预期结果6、生成通用水印图片（拍摄时间）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、进入编辑页面');

  await dt.sleep();
  dt.log.i('预期结果7、编辑页面显示水印页签，支持水印编辑修改');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机拍摄不同类型通用水印图片显示（组合） end');
}

/**
 * 水印-HEIF: [相机拍摄不同类型画框水印图片显示（组合）]
 * GROUP: 水印 MODULE: HEIFTID: Multimedia_Gallery_Watermark_Editing_020
 * 前置条件
 * 1、不同拍摄模式：夜景，闪拍，人像，拍照，专业，高像素，超级微距，大光圈，延时摄影，全景，高画质模式
 2、照片比例：4：3，1：1，全屏
 3、照片格式：JPG,HEIF,RAW(专业模式下有，会生成两张图片DNG)
 4、以上拍摄模式进行组合
 */
async function Multimedia_Gallery_Watermark_Editing_020(dt: Dt) {
  dt.log.i('相机拍摄不同类型画框水印图片显示（组合） start');
  dt.log.i('STEP 1、按照前置步骤组合形式依次设置好拍摄参数');

  await dt.sleep();
  dt.log.i('STEP 2、开启画框水印，拍摄参数开，拍摄时间关，查看拍摄图片');

  await dt.sleep();
  dt.log.i('预期结果2、生成画框水印图片（拍摄参数）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入编辑页面');

  await dt.sleep();
  dt.log.i('预期结果3、编辑页面显示水印页签，支持水印编辑修改');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、开启画框水印，拍摄参数开，拍摄时间开，查看拍摄图片');

  await dt.sleep();
  dt.log.i('预期结果4、生成画框水印图片（拍摄参数，拍摄时间）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、进入编辑页面');

  await dt.sleep();
  dt.log.i('预期结果5、编辑页面显示水印页签，支持水印编辑修改');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、开启画框水印，拍摄参数关，拍摄时间开，查看拍摄图片');

  await dt.sleep();
  dt.log.i('预期结果6、生成画框水印图片（拍摄时间）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、进入编辑页面');

  await dt.sleep();
  dt.log.i('预期结果7、编辑页面显示水印页签，支持水印编辑修改');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 8、开启画框水印，拍摄参数关，拍摄时间关，查看拍摄图片');

  await dt.sleep();
  dt.log.i('预期结果8、生成画框水印图片（镜头传播名）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 9、进入编辑页面');

  await dt.sleep();
  dt.log.i('预期结果9、编辑页面显示水印页签，支持水印编辑修改');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机拍摄不同类型画框水印图片显示（组合） end');
}

/**
 * 水印-云增强: [云增强图片水印编辑]
 * GROUP: 水印 MODULE: 云增强TID: Multimedia_Gallery_Watermark_Editing_021
 * 前置条件
 * 图片预置云增强图片（超级微距）
 */
async function Multimedia_Gallery_Watermark_Editing_021(dt: Dt) {
  dt.log.i('云增强图片水印编辑 start');
  dt.log.i('STEP 1、图片开启云增强');

  await dt.sleep();
  dt.log.i('预期结果1、新增云增强的水印图标');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入编辑页面，进行水印编辑');

  await dt.sleep();
  dt.log.i('预期结果2、可以进行水印编辑');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、保存图片');

  await dt.sleep();
  dt.log.i('预期结果3、保存后，水印和云增强水印无遮挡');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云增强图片水印编辑 end');
}

/**
 * 水印-: [xxx同步/分享/克隆图片支持原图水印信息]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_022
 * 前置条件
 * 目前分享暂不支持水印编辑
 两台xxx手机，测试机和辅助机都刷到支持水印的版本
 */
async function Multimedia_Gallery_Watermark_Editing_022(dt: Dt) {
  dt.log.i('xxx同步/分享/克隆图片支持原图水印信息 start');
  dt.log.i('STEP 1、辅助机拍摄水印图片');

  await dt.sleep();
  dt.log.i('STEP 2、辅助机克隆水印图片到测试机，测试机查看图片');

  await dt.sleep();
  dt.log.i('预期结果2、图片显示水印，和克隆前一致');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、辅助机云同步水印图片到测试机，测试机查看图片');

  await dt.sleep();
  dt.log.i('预期结果3、图片显示水印，和同步前一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxx同步/分享/克隆图片支持原图水印信息 end');
}

/**
 * 水印-: [xxx拍摄/同步/分享/克隆图片支持增加水印]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_023
 * 前置条件
 * 目前分享暂不支持水印编辑
 两台xxx手机，测试机和辅助机都刷到支持水印的版本。
 */
async function Multimedia_Gallery_Watermark_Editing_023(dt: Dt) {
  dt.log.i('xxx拍摄/同步/分享/克隆图片支持增加水印 start');
  dt.log.i('STEP 1、辅助机拍摄无水印图片');

  await dt.sleep();
  dt.log.i('STEP 2、辅助机克隆图片到测试机，测试机查看图片，进行水印编辑');

  await dt.sleep();
  dt.log.i('预期结果2、图片编辑有水印页签，支持水印编辑');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、辅助机云同步图片到测试机，测试机查看图片，进行水印编辑');

  await dt.sleep();
  dt.log.i('预期结果3、图片编辑有水印页签，支持水印编辑');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxx拍摄/同步/分享/克隆图片支持增加水印 end');
}

/**
 * 水印-: [xxx同步/分享/克隆图片不支持水印编辑和增加水印]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_024
 * 前置条件
 * xxx作为辅助机，xxx作为测试机
 */
async function Multimedia_Gallery_Watermark_Editing_024(dt: Dt) {
  dt.log.i('xxx同步/分享/克隆图片不支持水印编辑和增加水印 start');
  dt.log.i('STEP 1、xxx拍摄有水印图片和无水印图片');

  await dt.sleep();
  dt.log.i('STEP 2、xxx克隆、分享、同步水印图片到测试机');

  await dt.sleep();
  dt.log.i('预期结果2、显示有水印原图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、进入编辑页面');

  await dt.sleep();
  dt.log.i('预期结果3、编辑页面无水印页签');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、xxx克隆、分享、同步无水印图片到测试机');

  await dt.sleep();
  dt.log.i('预期结果4、显示无水印原图');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、进入编辑页面');

  await dt.sleep();
  dt.log.i('预期结果5、编辑页面无水印页签');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxx同步/分享/克隆图片不支持水印编辑和增加水印 end');
}

/**
 * 水印-: [三方应用保存照片不支持不支持水印编辑和增加水印]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_025
 * 前置条件
 * 图库三方应用保存图片
 */
async function Multimedia_Gallery_Watermark_Editing_025(dt: Dt) {
  dt.log.i('三方应用保存照片不支持不支持水印编辑和增加水印 start');
  dt.log.i('STEP 1、图片进入编辑页面');

  await dt.sleep();
  dt.log.i('预期结果1、无水印页签');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('三方应用保存照片不支持不支持水印编辑和增加水印 end');
}

/**
 * 水印-: [xxx图片不支持水印编辑和增加水印]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_026
 * 前置条件
 * xxx拍摄图片，升级到xxx
 */
async function Multimedia_Gallery_Watermark_Editing_026(dt: Dt) {
  dt.log.i('xxx图片不支持水印编辑和增加水印 start');
  dt.log.i('STEP 1、图片进入编辑页面');

  await dt.sleep();
  dt.log.i('预期结果1、无水印页签');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxx图片不支持水印编辑和增加水印 end');
}

/**
 * 水印-: [截屏图片不支持不支持水印编辑和增加水印]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_027
 * 前置条件
 * 图库存在截屏图片
 */
async function Multimedia_Gallery_Watermark_Editing_027(dt: Dt) {
  dt.log.i('截屏图片不支持不支持水印编辑和增加水印 start');
  dt.log.i('STEP 1、图片进入编辑页面');

  await dt.sleep();
  dt.log.i('预期结果1、无水印页签');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('截屏图片不支持不支持水印编辑和增加水印 end');
}

/**
 * 水印-: [带画框水印图片基础编辑]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_028
 * 前置条件
 * 图库存在画框水印图片
 */
async function Multimedia_Gallery_Watermark_Editing_028(dt: Dt) {
  dt.log.i('带画框水印图片基础编辑 start');
  dt.log.i('STEP 1、画框水印图片进入编辑页面');

  await dt.sleep();
  dt.log.i('预期结果1、动效流畅，无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、依次切换到调节，滤镜，水印页签');

  await dt.sleep();
  dt.log.i('预期结果2、动效流畅，无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、依次切换到裁剪页签');

  await dt.sleep();
  dt.log.i('预期结果3、动效流畅，无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、退出编辑页面');

  await dt.sleep();
  dt.log.i('预期结果4、动效流畅，无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('带画框水印图片基础编辑 end');
}

/**
 * 水印-: [带画框水印照片进入退出AI编辑、涂鸦]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_029
 * 前置条件
 * 图库存在画框水印图片
 */
async function Multimedia_Gallery_Watermark_Editing_029(dt: Dt) {
  dt.log.i('带画框水印照片进入退出AI编辑、涂鸦 start');
  dt.log.i('STEP 1、画框水印图片进入AI修图页面');

  await dt.sleep();
  dt.log.i('预期结果1、动效流畅，无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、画框水印图片退出AI修图页面');

  await dt.sleep();
  dt.log.i('预期结果2、动效流畅，无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、画框水印图片进入涂鸦页面');

  await dt.sleep();
  dt.log.i('预期结果3、动效流畅，无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、画框水印图片退出涂鸦页面');

  await dt.sleep();
  dt.log.i('预期结果4、动效流畅，无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('带画框水印照片进入退出AI编辑、涂鸦 end');
}

/**
 * 水印-: [增加水印]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_030
 * 前置条件
 * 图库存在无水印图片
 */
async function Multimedia_Gallery_Watermark_Editing_030(dt: Dt) {
  dt.log.i('增加水印 start');
  dt.log.i('STEP 1、无水印图片添加画框水印');

  await dt.sleep();
  dt.log.i('预期结果1、动效流畅，无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、通用水印切换画框水印');

  await dt.sleep();
  dt.log.i('预期结果2、动效流畅，无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、无水印添加通用水印');

  await dt.sleep();
  dt.log.i('预期结果3、动效流畅，无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、画框水印切换通用水印');

  await dt.sleep();
  dt.log.i('预期结果4、动效流畅，无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('增加水印 end');
}

/**
 * 水印-HDR: [去除水印]
 * GROUP: 水印 MODULE: HDRTID: Multimedia_Gallery_Watermark_Editing_031
 * 前置条件
 * 图库存在画框HDR水印图片
 */
async function Multimedia_Gallery_Watermark_Editing_031(dt: Dt) {
  dt.log.i('去除水印 start');
  dt.log.i('STEP 1、画框水印图片进编辑，去水印后保存');

  await dt.sleep();
  dt.log.i('预期结果1、动效流畅，无异常；保存后的图片无HDR效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、通用水印图片进编辑，去水印后保存');

  await dt.sleep();
  dt.log.i('预期结果2、动效流畅，无异常；保存后的图片无HDR效果');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('去除水印 end');
}

/**
 * 水印-竖屏: [横屏动效]
 * GROUP: 水印 MODULE: 竖屏TID: Multimedia_Gallery_Watermark_Editing_032
 * 前置条件
 * 图库存在画框/通用水印图片
 */
async function Multimedia_Gallery_Watermark_Editing_032(dt: Dt) {
  dt.log.i('横屏动效 start');
  dt.log.i('STEP 1、通用/画框水印图片编辑时竖屏切换到横屏');

  await dt.sleep();
  dt.log.i('预期结果1、动效流畅，无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、画框水印图片编辑时横屏切换到竖屏');

  await dt.sleep();
  dt.log.i('预期结果2、动效流畅，无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('横屏动效 end');
}

/**
 * 水印-: [水印编辑分屏悬浮窗]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_033
 * 前置条件
 * 图库存在画框/通用水印图片
 */
async function Multimedia_Gallery_Watermark_Editing_033(dt: Dt) {
  dt.log.i('水印编辑分屏悬浮窗 start');
  dt.log.i('STEP 1、通用/画框水印图片编辑时切换到分屏状态');

  await dt.sleep();
  dt.log.i('预期结果1、动效流畅，无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、通用/画框水印图片编辑时切换到悬浮窗状态');

  await dt.sleep();
  dt.log.i('预期结果2、动效流畅，无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('水印编辑分屏悬浮窗 end');
}

/**
 * 水印-深色: [水印编辑深色模式]
 * GROUP: 水印 MODULE: 深色TID: Multimedia_Gallery_Watermark_Editing_034
 * 前置条件
 * 图库存在画框/通用水印图片
 */
async function Multimedia_Gallery_Watermark_Editing_034(dt: Dt) {
  dt.log.i('水印编辑深色模式 start');
  dt.log.i('STEP 1、切换到深色模式');

  await dt.sleep();
  dt.log.i('预期结果1、显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进行水印编辑操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('水印编辑深色模式 end');
}

/**
 * 水印-: [水印编辑适老化]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_035
 * 前置条件
 * 图库存在画框/通用水印图片
 */
async function Multimedia_Gallery_Watermark_Editing_035(dt: Dt) {
  dt.log.i('水印编辑适老化 start');
  dt.log.i('STEP 1、切换到大字体模式');

  await dt.sleep();
  dt.log.i('预期结果1、显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进行水印编辑操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('水印编辑适老化 end');
}

/**
 * 水印-: [水印编辑无障碍]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_036
 * 前置条件
 * 图库存在画框/通用水印图片
 */
async function Multimedia_Gallery_Watermark_Editing_036(dt: Dt) {
  dt.log.i('水印编辑无障碍 start');
  dt.log.i('STEP 1、切换到无障碍模式');

  await dt.sleep();
  dt.log.i('预期结果1、显示正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进行水印编辑操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('水印编辑无障碍 end');
}

/**
 * 水印-: [水印编辑多语言]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_037
 * 前置条件
 * 图库存在画框/通用水印图片
 */
async function Multimedia_Gallery_Watermark_Editing_037(dt: Dt) {
  dt.log.i('水印编辑多语言 start');
  dt.log.i('STEP 1、切换到多语言模式');

  await dt.sleep();
  dt.log.i('预期结果1、显示正常；镜像语言符合规范');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进行水印编辑操作');

  await dt.sleep();
  dt.log.i('预期结果2、水印编辑功能正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、切换为横屏');

  await dt.sleep();
  dt.log.i('预期结果3、横屏界面显示及功能无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('水印编辑多语言 end');
}

/**
 * 水印-: [水印编辑xxxxxx显示]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_038
 * 前置条件
 * 图库存在画框/通用水印图片
 */
async function Multimedia_Gallery_Watermark_Editing_038(dt: Dt) {
  dt.log.i('水印编辑xxxxxx显示 start');
  dt.log.i('STEP 1、xxxxxx进入水印编辑');

  await dt.sleep();
  dt.log.i('预期结果1、界面符合ux涉及');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、画框水印编辑');

  await dt.sleep();
  dt.log.i('预期结果2、水印编辑正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、通用水印编辑');

  await dt.sleep();
  dt.log.i('预期结果3、水印编辑正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、去水印');

  await dt.sleep();
  dt.log.i('预期结果4、去水印正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('水印编辑xxxxxx显示 end');
}

/**
 * 水印-: [水印编辑xxx收起态显示]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_039
 * 前置条件
 * 图库存在画框/通用水印图片
 */
async function Multimedia_Gallery_Watermark_Editing_039(dt: Dt) {
  dt.log.i('水印编辑xxx收起态显示 start');
  dt.log.i('STEP 1、xxx收起态进入水印编辑');

  await dt.sleep();
  dt.log.i('预期结果1、界面符合ux涉及');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、画框水印编辑');

  await dt.sleep();
  dt.log.i('预期结果2、水印编辑正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、通用水印编辑');

  await dt.sleep();
  dt.log.i('预期结果3、水印编辑正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、去水印');

  await dt.sleep();
  dt.log.i('预期结果4、去水印正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('水印编辑xxx收起态显示 end');
}

/**
 * 水印-: [水印编辑xxx展开xxx切换]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_040
 * 前置条件
 * xxx，图库存在画框/通用水印图片
 */
async function Multimedia_Gallery_Watermark_Editing_040(dt: Dt) {
  dt.log.i('水印编辑xxx展开xxx切换 start');
  dt.log.i('STEP 1、水印编辑页面xxx切换到xxx');

  await dt.sleep();
  dt.log.i('预期结果1、动效流畅，无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、水印编辑页面xxx切换到xxx');

  await dt.sleep();
  dt.log.i('预期结果2、动效流畅无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('水印编辑xxx展开xxx切换 end');
}

/**
 * 水印-大图: [水印图片编辑保存图片场景完成时延]
 * GROUP: 水印 MODULE: 大图TID: Multimedia_Gallery_Watermark_Editing_041
 * 前置条件
 * 1、预置1W张图片
 2、图库预置相机拍摄4K照片：无水印、有水印
 */
async function Multimedia_Gallery_Watermark_Editing_041(dt: Dt) {
  dt.log.i('水印图片编辑保存图片场景完成时延 start');
  dt.log.i('STEP 1、无水印照片进行裁剪/滤镜/调节，保存 - 另存为');

  await dt.sleep();
  dt.log.i('STEP 2、有水印照片进行裁剪/滤镜/调节，保存 - 另存为（保持相同操作）');

  await dt.sleep();
  dt.log.i('STEP 3、计算完成时延：T2-T1，对比无水印和有水印图片编辑保存完成时间T1：点击另存为，手指离开屏幕的第一帧T2：保存成功返回大图，动效结束的第一帧');

  await dt.sleep();
  dt.log.i('预期结果3、有水印图片对比无水印图片额外增加140ms以内');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('水印图片编辑保存图片场景完成时延 end');
}

/**
 * 水印-: [图片水印编辑内存测试]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_043
 * 前置条件
 * 1、预置1W张图片
 2、手机登录账号
 3、非首次使用
 */
async function Multimedia_Gallery_Watermark_Editing_043(dt: Dt) {
  dt.log.i('图片水印编辑内存测试 start');
  dt.log.i('STEP 1、无水印图片添加画框水印，查看内存');

  await dt.sleep();
  dt.log.i('预期结果1~4、不增加额外内存，内存保持原有基线。内存均值不大于1G，峰值不大于1.2G');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、通用水印切换画框水印，查看内存');

  await dt.sleep();
  dt.log.i('STEP 3、无水印添加通用水印，查看内存');

  await dt.sleep();
  dt.log.i('STEP 4、画框水印切换通用水印，查看内存');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片水印编辑内存测试 end');
}

/**
 * 水印-: [动态图片不支持水印编辑]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_045
 * 前置条件
 * xxx手机
 */
async function Multimedia_Gallery_Watermark_Editing_045(dt: Dt) {
  dt.log.i('动态图片不支持水印编辑 start');
  dt.log.i('STEP 1、相机拍摄动态图片');

  await dt.sleep();
  dt.log.i('STEP 2、动态图片进编辑页面');

  await dt.sleep();
  dt.log.i('预期结果2、无水印页签显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态图片不支持水印编辑 end');
}

/**
 * 水印-视频: [视频不支持水印编辑]
 * GROUP: 水印 MODULE: 视频TID: Multimedia_Gallery_Watermark_Editing_046
 * 前置条件
 *
 */
async function Multimedia_Gallery_Watermark_Editing_046(dt: Dt) {
  dt.log.i('视频不支持水印编辑 start');
  dt.log.i('STEP 1、相机拍摄视频');

  await dt.sleep();
  dt.log.i('STEP 2、视频进编辑页面');

  await dt.sleep();
  dt.log.i('预期结果2、无水印页签显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频不支持水印编辑 end');
}

/**
 * 水印-大图: [照片页入口进行水印编辑操作]
 * GROUP: 水印 MODULE: 大图TID: Multimedia_Gallery_Watermark_Editing_047
 * 前置条件
 * 图库存在支持水印编辑的普通图片，通用水印图片，画框水印图片（除流光快门模式、全景模式、所有前置拍照的其它模式均支持两种水印）
 */
async function Multimedia_Gallery_Watermark_Editing_047(dt: Dt) {
  dt.log.i('照片页入口进行水印编辑操作 start');
  dt.log.i('STEP 1、新拍一张普通图片，打开照片宫格页');

  await dt.sleep();
  dt.log.i('STEP 2、打开该大图，点击编辑按钮');

  await dt.sleep();
  dt.log.i('预期结果2、编辑页面有水印页签');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击水印页签编辑操作');

  await dt.sleep();
  dt.log.i('预期结果3、可以正常添加水印或者去水印');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、添加水印后保存');

  await dt.sleep();
  dt.log.i('预期结果4、保存成功，大图已添加水印');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页入口进行水印编辑操作 end');
}

/**
 * 水印-收藏: [系统相册页入口进行水印编辑操作]
 * GROUP: 水印 MODULE: 收藏TID: Multimedia_Gallery_Watermark_Editing_048
 * 前置条件
 * 1、系统相册（图片，视频，收藏，隐藏相册，最近删除相册）存在可以支持水印编辑的图片
 */
async function Multimedia_Gallery_Watermark_Editing_048(dt: Dt) {
  dt.log.i('系统相册页入口进行水印编辑操作 start');
  dt.log.i('STEP 1、打开图片相册，选择大图进行水印编辑操作');

  await dt.sleep();
  dt.log.i('预期结果1、编辑页面有水印页签，支持水印编辑操作');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、打开视频相册，选择大图进行水印编辑操作');

  await dt.sleep();
  dt.log.i('预期结果2、编辑页面有水印页签，支持水印编辑操作');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、打开收藏相册，选择大图进行水印编辑操作');

  await dt.sleep();
  dt.log.i('预期结果3、编辑页面有水印页签，支持水印编辑操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、打开隐藏相册，选择大图进行水印编辑操作');

  await dt.sleep();
  dt.log.i('预期结果4、编辑页面有水印页签，支持水印编辑操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、打开最近删除相册，选择大图进行水印编辑操作');

  await dt.sleep();
  dt.log.i('预期结果5、无法进入编辑页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('系统相册页入口进行水印编辑操作 end');
}

/**
 * 水印-大图: [用户创建相册入口进行水印编辑操作]
 * GROUP: 水印 MODULE: 大图TID: Multimedia_Gallery_Watermark_Editing_049
 * 前置条件
 * 1、用户创建相册存在可以支持水印编辑的图片
 */
async function Multimedia_Gallery_Watermark_Editing_049(dt: Dt) {
  dt.log.i('用户创建相册入口进行水印编辑操作 start');
  dt.log.i('STEP 1、用户创建相册打开大图，点击编辑按钮');

  await dt.sleep();
  dt.log.i('预期结果1、编辑页面有水印页签');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击水印页签编辑操作');

  await dt.sleep();
  dt.log.i('预期结果2、可以正常添加水印或者去水印');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('用户创建相册入口进行水印编辑操作 end');
}

/**
 * 水印-大图: [来源相册入口进行水印编辑操作]
 * GROUP: 水印 MODULE: 大图TID: Multimedia_Gallery_Watermark_Editing_050
 * 前置条件
 * 1、来源相册存在可以支持水印编辑的图片（相机相册）
 */
async function Multimedia_Gallery_Watermark_Editing_050(dt: Dt) {
  dt.log.i('来源相册入口进行水印编辑操作 start');
  dt.log.i('STEP 1、来源创建相册打开大图，点击编辑按钮');

  await dt.sleep();
  dt.log.i('预期结果1、编辑页面有水印页签');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击水印页签编辑操作');

  await dt.sleep();
  dt.log.i('预期结果2、可以正常添加水印或者去水印');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('来源相册入口进行水印编辑操作 end');
}

/**
 * 水印-大图: [智慧相册入口进行水印编辑操作]
 * GROUP: 水印 MODULE: 大图TID: Multimedia_Gallery_Watermark_Editing_051
 * 前置条件
 * 1、智慧相册（人像，地点，分类）存在可以支持水印编辑的图片
 */
async function Multimedia_Gallery_Watermark_Editing_051(dt: Dt) {
  dt.log.i('智慧相册入口进行水印编辑操作 start');
  dt.log.i('STEP 1、打开人像相册，选择大图进行水印编辑操作');

  await dt.sleep();
  dt.log.i('预期结果1、编辑页面有水印页签，支持水印编辑操作');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、打开地点相册，选择大图进行水印编辑操作');

  await dt.sleep();
  dt.log.i('预期结果2、编辑页面有水印页签，支持水印编辑操作');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、打开分类相册，选择大图进行水印编辑操作');

  await dt.sleep();
  dt.log.i('预期结果3、编辑页面有水印页签，支持水印编辑操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('智慧相册入口进行水印编辑操作 end');
}

/**
 * 水印-大图: [精彩时刻入口进行水印编辑操作]
 * GROUP: 水印 MODULE: 大图TID: Multimedia_Gallery_Watermark_Editing_052
 * 前置条件
 * 1、精彩时刻存在可以支持水印编辑的图片
 */
async function Multimedia_Gallery_Watermark_Editing_052(dt: Dt) {
  dt.log.i('精彩时刻入口进行水印编辑操作 start');
  dt.log.i('STEP 1、精彩时刻打开大图，点击编辑按钮');

  await dt.sleep();
  dt.log.i('预期结果1、编辑页面有水印页签');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击水印页签编辑操作');

  await dt.sleep();
  dt.log.i('预期结果2、可以正常添加水印或者去水印');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('精彩时刻入口进行水印编辑操作 end');
}

/**
 * 水印-大图: [搜索入口进行水印编辑操作]
 * GROUP: 水印 MODULE: 大图TID: Multimedia_Gallery_Watermark_Editing_053
 * 前置条件
 * 1、搜索页面存在可以支持水印编辑的图片
 */
async function Multimedia_Gallery_Watermark_Editing_053(dt: Dt) {
  dt.log.i('搜索入口进行水印编辑操作 start');
  dt.log.i('STEP 1、搜索打开大图，点击编辑按钮');

  await dt.sleep();
  dt.log.i('预期结果1、编辑页面有水印页签');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击水印页签编辑操作');

  await dt.sleep();
  dt.log.i('预期结果2、可以正常添加水印或者去水印');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('搜索入口进行水印编辑操作 end');
}

/**
 * 水印-连拍: [不同入口连拍照片进行水印编辑]
 * GROUP: 水印 MODULE: 连拍TID: Multimedia_Gallery_Watermark_Editing_054
 * 前置条件
 * 1、相机拍摄多张连拍照片
 */
async function Multimedia_Gallery_Watermark_Editing_054(dt: Dt) {
  dt.log.i('不同入口连拍照片进行水印编辑 start');
  dt.log.i('STEP 1、相机入口打开连拍照片，编辑页面添加水印');

  await dt.sleep();
  dt.log.i('预期结果1、编辑页面有水印页签，支持水印编辑操作');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、照片宫格页入口打开连拍照片，编辑页面添加水印');

  await dt.sleep();
  dt.log.i('预期结果2、编辑页面有水印页签，支持水印编辑操作');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、相册页打开连拍照片，编辑页面添加水印');

  await dt.sleep();
  dt.log.i('预期结果3、编辑页面有水印页签，支持水印编辑操作');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同入口连拍照片进行水印编辑 end');
}

/**
 * 水印-大图: [相机入口打开大图进行水印编辑]
 * GROUP: 水印 MODULE: 大图TID: Multimedia_Gallery_Watermark_Editing_055
 * 前置条件
 * 图库存在支持水印编辑的普通图片，通用水印图片，画框水印图片（除流光快门模式、全景模式、所有前置拍照的其它模式均支持两种水印）
 */
async function Multimedia_Gallery_Watermark_Editing_055(dt: Dt) {
  dt.log.i('相机入口打开大图进行水印编辑 start');
  dt.log.i('STEP 1、相机拍摄一张图片，左下角打开大图');

  await dt.sleep();
  dt.log.i('STEP 2、点击编辑按钮');

  await dt.sleep();
  dt.log.i('预期结果2、编辑页面有水印页签');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击水印页签编辑操作');

  await dt.sleep();
  dt.log.i('预期结果3、可以正常添加水印或者去水印');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、添加水印后保存');

  await dt.sleep();
  dt.log.i('预期结果4、保存成功，大图已添加水印');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机入口打开大图进行水印编辑 end');
}

/**
 * 水印-: [不同型号设备同步带水印照片进编辑页]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_060
 * 前置条件
 * 1、准备两台不同型号的设备，且登录同一账号开启图库云同步；
 2、辅助机A拍摄带有内嵌、画框，以及春节水印的照片后上行至云端；
 */
async function Multimedia_Gallery_Watermark_Editing_060(dt: Dt) {
  dt.log.i('不同型号设备同步带水印照片进编辑页 start');
  dt.log.i('STEP 1、图片进入编辑页添加内嵌水印后覆盖保存；');

  await dt.sleep();
  dt.log.i('STEP 2、进入保存编辑的照片编辑页；');

  await dt.sleep();
  dt.log.i('预期结果2&4&6&8步骤进入的编辑裁剪页水印都不会消失；进入编辑-调节/滤镜页水印不消失；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、图片进入编辑页添加内嵌水印后另存照片保存；');

  await dt.sleep();
  dt.log.i('STEP 4、进入保存编辑的照片编辑页；');

  await dt.sleep();
  dt.log.i('STEP 5、图片进入编辑页添加画框水印后覆盖保存；');

  await dt.sleep();
  dt.log.i('STEP 6、进入保存编辑的照片编辑页；');

  await dt.sleep();
  dt.log.i('STEP 7、图片进入编辑页添加画框水印后另存照片保存；');

  await dt.sleep();
  dt.log.i('STEP 8、进入保存编辑的照片编辑页；');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同型号设备同步带水印照片进编辑页 end');
}

/**
 * 水印-: [不同型号设备同步无水印照片进编辑页]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_061
 * 前置条件
 * 1、准备两台不同型号的设备，且登录同一账号开启图库云同步；
 2、辅助机A拍摄不带水印照片；
 */
async function Multimedia_Gallery_Watermark_Editing_061(dt: Dt) {
  dt.log.i('不同型号设备同步无水印照片进编辑页 start');
  dt.log.i('STEP 1、使用测试机B同步下行辅助机拍摄的不带水印的照片后进入编辑页；');

  await dt.sleep();
  dt.log.i('预期结果1、不同机型同步下的不带水印照片进入编辑页，编辑页不会出现添加水印选项；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同型号设备同步无水印照片进编辑页 end');
}

/**
 * 水印-端云: [同型号设备同步带水印照片进编辑页]
 * GROUP: 水印 MODULE: 端云TID: Multimedia_Gallery_Watermark_Editing_062
 * 前置条件
 * 1、准备两台型号相同的设备，且登录同一账号开启图库云同步；
 2、辅助机A拍摄带有内嵌、画框，以及春节水印的照片后上行至云端；
 */
async function Multimedia_Gallery_Watermark_Editing_062(dt: Dt) {
  dt.log.i('同型号设备同步带水印照片进编辑页 start');
  dt.log.i('STEP 1、使用测试机B同步下行端云资源完成；');

  await dt.sleep();
  dt.log.i('STEP 2、进入云端带水印图片-编辑页；');

  await dt.sleep();
  dt.log.i('预期结果2、带有内嵌水印-画框水印的照片进入编辑-裁剪页水印消失，进入编辑-调节/滤镜页水印不消失；带有春节水印的照片进入编辑页水印不消失；');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('同型号设备同步带水印照片进编辑页 end');
}

/**
 * 水印-: [同型号设备同步添加图片水印照片后进编辑页]
 * GROUP: 水印 MODULE: TID: Multimedia_Gallery_Watermark_Editing_063
 * 前置条件
 * 1、准备两台型号相同的设备，且登录同一账号开启图库云同步；
 2、辅助机A拍摄不带水印照片；
 */
async function Multimedia_Gallery_Watermark_Editing_063(dt: Dt) {
  dt.log.i('同型号设备同步添加图片水印照片后进编辑页 start');
  dt.log.i('STEP 1、使用测试机B同步下行辅助机拍摄的不带水印的照片后进入编辑页添加内嵌水印后覆盖保存、另存为；');

  await dt.sleep();
  dt.log.i('STEP 2、进入添加内嵌水印的照片编辑页；');

  await dt.sleep();
  dt.log.i('预期结果2&4步骤进入编辑裁剪页水印消失，调节、滤镜页水印出现；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、使用测试机B同步下行辅助机拍摄的不带水印的照片后进入编辑页添加画框水印后覆盖保存、另存为；');

  await dt.sleep();
  dt.log.i('STEP 4、进入添加画框水印的照片编辑页；');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('同型号设备同步添加图片水印照片后进编辑页 end');
}