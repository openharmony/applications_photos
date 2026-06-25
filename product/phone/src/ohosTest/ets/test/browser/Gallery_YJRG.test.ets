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

export default function GalleryYJRGTest(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('GalleryYJRGTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllGalleryYJRG').init();
      dt.log.i('beforeAll GalleryYJRG start');
      dt.log.i('beforeAll GalleryYJRG finish');
    });
    /**
     * 打开大图
     */
    run('beforeGalleryYJRG', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    run('Multimedia_Gallery_YJRG_001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-视频用例: [本地数据为空、xxx克隆1000图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_001
      await Multimedia_Gallery_YJRG_001(dt);
    });
    run('Multimedia_Gallery_YJRG_002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-视频用例: [本地数据为空、xxx克隆1000图片完成后，图库检查] TID: Multimedia_Gallery_YJRG_002
      await Multimedia_Gallery_YJRG_002(dt);
    });
    run('Multimedia_Gallery_YJRG_003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-视频用例: [本地数据为空、xxx克隆1W图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_003
      await Multimedia_Gallery_YJRG_003(dt);
    });
    run('Multimedia_Gallery_YJRG_004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-视频用例: [本地数据为空、xxx克隆1W图片完成，图库检查] TID: Multimedia_Gallery_YJRG_004
      await Multimedia_Gallery_YJRG_004(dt);
    });
    run('Multimedia_Gallery_YJRG_005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-视频用例: [本地数据为空、xxx克隆3W图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_005
      await Multimedia_Gallery_YJRG_005(dt);
    });
    run('Multimedia_Gallery_YJRG_006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-视频用例: [本地数据为空、xxx克隆3W图片完成，图库检查] TID: Multimedia_Gallery_YJRG_006
      await Multimedia_Gallery_YJRG_006(dt);
    });
    run('Multimedia_Gallery_YJRG_007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-视频用例: [本地数据不为空、xxx克隆1000图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_007
      await Multimedia_Gallery_YJRG_007(dt);
    });
    run('Multimedia_Gallery_YJRG_008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-视频用例: [本地数据不为空、xxx克隆1000图片完成后，图库检查] TID: Multimedia_Gallery_YJRG_008
      await Multimedia_Gallery_YJRG_008(dt);
    });
    run('Multimedia_Gallery_YJRG_009', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-视频用例: [本地数据不为空、xxx克隆1W图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_009
      await Multimedia_Gallery_YJRG_009(dt);
    });
    run('Multimedia_Gallery_YJRG_010', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-视频用例: [本地数据不为空、xxx克隆1W图片完成，图库检查] TID: Multimedia_Gallery_YJRG_010
      await Multimedia_Gallery_YJRG_010(dt);
    });
    run('Multimedia_Gallery_YJRG_011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-视频用例: [本地数据为空时、xxx到xxx克隆3W图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_011
      await Multimedia_Gallery_YJRG_011(dt);
    });
    run('Multimedia_Gallery_YJRG_012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-视频用例: [本地数据为空、xxx克隆3W图片完成后，图库检查] TID: Multimedia_Gallery_YJRG_012
      await Multimedia_Gallery_YJRG_012(dt);
    });
    run('Multimedia_Gallery_YJRG_013', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-用例: [本地数据为空、xxx后图库检查] TID: Multimedia_Gallery_YJRG_013
      await Multimedia_Gallery_YJRG_013(dt);
    });
    run('Multimedia_Gallery_YJRG_014', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-大图用例: [本地数据为100、xxx后图库检查] TID: Multimedia_Gallery_YJRG_014
      await Multimedia_Gallery_YJRG_014(dt);
    });
    run('Multimedia_Gallery_YJRG_015', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-大图用例: [本地数据不为空、xxx后恢复1000张图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_015
      await Multimedia_Gallery_YJRG_015(dt);
    });
    run('Multimedia_Gallery_YJRG_016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-视频用例: [本地数据不为空、xxx后恢复1000张图片完成后，图库检查] TID: Multimedia_Gallery_YJRG_016
      await Multimedia_Gallery_YJRG_016(dt);
    });
    run('Multimedia_Gallery_YJRG_017', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-大图用例: [本地数据不为空、xxx后恢复1w张图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_017
      await Multimedia_Gallery_YJRG_017(dt);
    });
    run('Multimedia_Gallery_YJRG_018', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-视频用例: [本地数据不为空、xxx后恢复1w张图片完成后，图库检查] TID: Multimedia_Gallery_YJRG_018
      await Multimedia_Gallery_YJRG_018(dt);
    });
    run('Multimedia_Gallery_YJRG_019', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-大图用例: [本地数据不为空时、xxxx后后恢复1w张图片的过程中，进入图库检查] TID: Multimedia_Gallery_YJRG_019
      await Multimedia_Gallery_YJRG_019(dt);
    });
    run('Multimedia_Gallery_YJRG_020', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-视频用例: [本地数据不为空、xxx升级到xxx后恢复1w张图片完成后，图库检查] TID: Multimedia_Gallery_YJRG_020
      await Multimedia_Gallery_YJRG_020(dt);
    });
    run('Multimedia_Gallery_YJRG_021', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-大图用例: [本地数据不为空、xxx后恢复3w张图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_021
      await Multimedia_Gallery_YJRG_021(dt);
    });
    run('Multimedia_Gallery_YJRG_022', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-视频用例: [本地数据不为空、xxx后恢复3w张图片完成后，图库检查] TID: Multimedia_Gallery_YJRG_022
      await Multimedia_Gallery_YJRG_022(dt);
    });
    run('Multimedia_Gallery_YJRG_023', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [首次云同步1000张图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_023
      await Multimedia_Gallery_YJRG_023(dt);
    });
    run('Multimedia_Gallery_YJRG_024', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [首次云同步1000张图片完成后，图库检查] TID: Multimedia_Gallery_YJRG_024
      await Multimedia_Gallery_YJRG_024(dt);
    });
    run('Multimedia_Gallery_YJRG_025', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [首次云同步1w张图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_025
      await Multimedia_Gallery_YJRG_025(dt);
    });
    run('Multimedia_Gallery_YJRG_026', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [首次云同步1w张图片完成后，图库检查] TID: Multimedia_Gallery_YJRG_026
      await Multimedia_Gallery_YJRG_026(dt);
    });
    run('Multimedia_Gallery_YJRG_027', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [首次云同步3w张图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_027
      await Multimedia_Gallery_YJRG_027(dt);
    });
    run('Multimedia_Gallery_YJRG_028', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [首次云同步3w张图片完成后，图库检查] TID: Multimedia_Gallery_YJRG_028
      await Multimedia_Gallery_YJRG_028(dt);
    });
    run('Multimedia_Gallery_YJRG_029', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [本地数据为50，增量云同步40张图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_029
      await Multimedia_Gallery_YJRG_029(dt);
    });
    run('Multimedia_Gallery_YJRG_030', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [本地数据为50，增量云同步40张图片完成后，图库检查] TID: Multimedia_Gallery_YJRG_030
      await Multimedia_Gallery_YJRG_030(dt);
    });
    run('Multimedia_Gallery_YJRG_031', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [本地数据为50，增量云同步450张图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_031
      await Multimedia_Gallery_YJRG_031(dt);
    });
    run('Multimedia_Gallery_YJRG_032', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [本地数据为50，增量云同步450张图片完成后，图库检查] TID: Multimedia_Gallery_YJRG_032
      await Multimedia_Gallery_YJRG_032(dt);
    });
    run('Multimedia_Gallery_YJRG_033', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [本地数据为200，增量云同步450张图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_033
      await Multimedia_Gallery_YJRG_033(dt);
    });
    run('Multimedia_Gallery_YJRG_034', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [本地数据为200，增量云同步450张图片完成后，图库检查] TID: Multimedia_Gallery_YJRG_034
      await Multimedia_Gallery_YJRG_034(dt);
    });
    run('Multimedia_Gallery_YJRG_035', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [本地数据为200，增量云同步2000张图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_035
      await Multimedia_Gallery_YJRG_035(dt);
    });
    run('Multimedia_Gallery_YJRG_036', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [本地数据为200，增量云同步2000张图片完成后，图库检查] TID: Multimedia_Gallery_YJRG_036
      await Multimedia_Gallery_YJRG_036(dt);
    });
    run('Multimedia_Gallery_YJRG_037', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [本地数据为3000，增量云同步2000张图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_037
      await Multimedia_Gallery_YJRG_037(dt);
    });
    run('Multimedia_Gallery_YJRG_038', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [本地数据为3000，增量云同步2000张图片完成后，图库检查] TID: Multimedia_Gallery_YJRG_038
      await Multimedia_Gallery_YJRG_038(dt);
    });
    run('Multimedia_Gallery_YJRG_039', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [本地数据为3000，增量云同步2w张图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_039
      await Multimedia_Gallery_YJRG_039(dt);
    });
    run('Multimedia_Gallery_YJRG_040', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [本地数据为3000，增量云同步2w张图片完成后，图库检查] TID: Multimedia_Gallery_YJRG_040
      await Multimedia_Gallery_YJRG_040(dt);
    });
    run('Multimedia_Gallery_YJRG_041', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [本地数据为21000，增量云同步2w张图片过程中，图库检查] TID: Multimedia_Gallery_YJRG_041
      await Multimedia_Gallery_YJRG_041(dt);
    });
    run('Multimedia_Gallery_YJRG_042', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [本地数据为21000，增量云同步2w张图片完成后，图库检查] TID: Multimedia_Gallery_YJRG_042
      await Multimedia_Gallery_YJRG_042(dt);
    });
    run('Multimedia_Gallery_YJRG_043', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-滑动用例: [克隆与云同步交互] TID: Multimedia_Gallery_YJRG_043
      await Multimedia_Gallery_YJRG_043(dt);
    });
    run('Multimedia_Gallery_YJRG_044', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-滑动用例: [缩略图生成时操作图库] TID: Multimedia_Gallery_YJRG_044
      await Multimedia_Gallery_YJRG_044(dt);
    });
    run('Multimedia_Gallery_YJRG_045', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-用例: [多语言专项] TID: Multimedia_Gallery_YJRG_045
      await Multimedia_Gallery_YJRG_045(dt);
    });
    run('Multimedia_Gallery_YJRG_046', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-用例: [适老化专项] TID: Multimedia_Gallery_YJRG_046
      await Multimedia_Gallery_YJRG_046(dt);
    });
    run('Multimedia_Gallery_YJRG_047', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-用例: [无障碍专项] TID: Multimedia_Gallery_YJRG_047
      await Multimedia_Gallery_YJRG_047(dt);
    });
    run('Multimedia_Gallery_YJRG_048', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-大图用例: [杀死媒体进程、再次进入图库可以再次拉起、生成缩略图] TID: Multimedia_Gallery_YJRG_048
      await Multimedia_Gallery_YJRG_048(dt);
    });
    run('Multimedia_Gallery_YJRG_049', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [首次xxx克隆生成2000张缩略图之前打开云同步过程中，图库检查] TID: Multimedia_Gallery_YJRG_049
      await Multimedia_Gallery_YJRG_049(dt);
    });
    run('Multimedia_Gallery_YJRG_050', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  端云-下载用例: [首次xxx克隆生成2000张缩略图之前打开云同步完成后，图库检查] TID: Multimedia_Gallery_YJRG_050
      await Multimedia_Gallery_YJRG_050(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachGalleryYJRG').init();
      dt.log.i('afterEach GalleryYJRG start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach GalleryYJRG finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllGalleryYJRG').init();
      dt.log.i('afterAll GalleryYJRG start');
      await Exit.browser();
      dt.log.i('afterAll GalleryYJRG finish');
    });
  });
}

/**
 * 端云-视频: [本地数据为空、xxx克隆1000图片过程中，图库检查]
 * GROUP: 端云 MODULE: 视频TID: Multimedia_Gallery_YJRG_001
 * 前置条件
 * 1、本地数据为空
 2、新机关闭云同步
 */
async function Multimedia_Gallery_YJRG_001(dt: Dt) {
  dt.log.i('本地数据为空、xxx克隆1000图片过程中，图库检查 start');
  dt.log.i('STEP 1、xxx克隆图片与视频（总数为1000）');

  await dt.sleep();
  dt.log.i('预期结果1、顶端文案中第一行显示**张照片和**个视频、数量为迁移总量');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2、顶部文字第二行显示累计已加载**张照片和**个视频、数量为图库中已显示的图片与视频数量');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3、随克隆进程顶部第一行中数字增加不变、第二行图片与视频总数增加到1000后顶部提示变为一行显示**张照片与**个视频、数量总和为1000');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果4、切换年月日视图、过程流畅无卡顿、无黑白花闪现象');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果5、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为空、xxx克隆1000图片过程中，图库检查 end');
}

/**
 * 端云-视频: [本地数据为空、xxx克隆1000图片完成后，图库检查]
 * GROUP: 端云 MODULE: 视频TID: Multimedia_Gallery_YJRG_002
 * 前置条件
 * 1、本地数据为空
 2、新机关闭云同步
 */
async function Multimedia_Gallery_YJRG_002(dt: Dt) {
  dt.log.i('本地数据为空、xxx克隆1000图片完成后，图库检查 start');
  dt.log.i('STEP 1、xxx克隆图片与视频（总数为1000）');

  await dt.sleep();
  dt.log.i('预期结果1、顶部文字显示**张照片和**个视频。数量与克隆总数相符、与图库中展示数量相符');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2、切换年月日视图、过程流畅无卡顿、无黑白花闪现象');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为空、xxx克隆1000图片完成后，图库检查 end');
}

/**
 * 端云-视频: [本地数据为空、xxx克隆1W图片过程中，图库检查]
 * GROUP: 端云 MODULE: 视频TID: Multimedia_Gallery_YJRG_003
 * 前置条件
 * 1、本地数据为空
 2、新机关闭云同步
 */
async function Multimedia_Gallery_YJRG_003(dt: Dt) {
  dt.log.i('本地数据为空、xxx克隆1W图片过程中，图库检查 start');
  dt.log.i('STEP 1、xxx克隆图片与视频（总数为10000）');

  await dt.sleep();
  dt.log.i('预期结果1、顶端文案中第一行显示**张照片和**个视频、数量为迁移总量');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2、顶部文字第二行显示累计已加载**张照片和**个视频、数量为图库中已显示的图片与视频数量');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3、随克隆进程顶部第一行中数字增加不变、第二行累计已加载图片与视频总数增加到2000后暂停');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果4、克隆完成后第二行累计已加载图片与视频总数继续加载到全部完成、顶部提示变为一行显示**张照片与**个视频、数量总和为100004、切换年月日视图、过程流畅无卡顿、无黑白花闪现象');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果5、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为空、xxx克隆1W图片过程中，图库检查 end');
}

/**
 * 端云-视频: [本地数据为空、xxx克隆1W图片完成，图库检查]
 * GROUP: 端云 MODULE: 视频TID: Multimedia_Gallery_YJRG_004
 * 前置条件
 * 1、本地数据为空
 2、新机关闭云同步
 */
async function Multimedia_Gallery_YJRG_004(dt: Dt) {
  dt.log.i('本地数据为空、xxx克隆1W图片完成，图库检查 start');
  dt.log.i('STEP 1、xxx克隆图片与视频（总数为10000）');

  await dt.sleep();
  dt.log.i('预期结果1、打开图库顶端文案中第一行显示**张照片和**个视频、数量为迁移总量。第二行显示累计已加载**张照片和**个视频、数量总和为2000');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2、克隆完成后第二行累计已加载图片与视频总数继续加载到全部完成、顶部提示变为一行显示**张照片与**个视频、数量总和为10000');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3、切换年月日视图、过程流畅无卡顿、无黑白花闪现象');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果4、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为空、xxx克隆1W图片完成，图库检查 end');
}

/**
 * 端云-视频: [本地数据为空、xxx克隆3W图片过程中，图库检查]
 * GROUP: 端云 MODULE: 视频TID: Multimedia_Gallery_YJRG_005
 * 前置条件
 * 1、本地数据为空
 2、新机关闭云同步
 */
async function Multimedia_Gallery_YJRG_005(dt: Dt) {
  dt.log.i('本地数据为空、xxx克隆3W图片过程中，图库检查 start');
  dt.log.i('STEP 1、xxx克隆图片与视频（总数为30000）');

  await dt.sleep();
  dt.log.i('预期结果1、顶端文案中第一行显示**张照片和**个视频、数量为迁移总量');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2、顶部文字第二行显示累计已加载**张照片和**个视频、数量为图库中已显示的图片与视频数量');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3、随克隆进程顶部第一行中数字增加不变、第二行累计已加载图片与视频总数增加到2000后暂停');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果4、克隆完成后第二行累计已加载图片与视频总数继续加载到总数为20000后顶部提示变为一行显示**张照片与**个视频、数量总和为300004、切换年月日视图、过程流畅无卡顿、无黑白花闪现象');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果5、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为空、xxx克隆3W图片过程中，图库检查 end');
}

/**
 * 端云-视频: [本地数据为空、xxx克隆3W图片完成，图库检查]
 * GROUP: 端云 MODULE: 视频TID: Multimedia_Gallery_YJRG_006
 * 前置条件
 * 1、本地数据为空
 2、新机关闭云同步
 */
async function Multimedia_Gallery_YJRG_006(dt: Dt) {
  dt.log.i('本地数据为空、xxx克隆3W图片完成，图库检查 start');
  dt.log.i('STEP 1、xxx克隆图片与视频（总数为30000）');

  await dt.sleep();
  dt.log.i('预期结果1、打开图库顶端文案中第一行显示**张照片和**个视频、数量为迁移总量。第二行显示累计已加载**张照片和**个视频、数量总和为2000');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2、顶部文字第二行显示累计已加载**张照片和**个视频、数量为图库中已显示的图片与视频数量');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3、随克隆进程顶部第一行中数字增加不变、第二行累计已加载图片与视频总数增加到2000后暂停');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果4、克隆完成后第二行累计已加载图片与视频总数继续加载到总数为20000后顶部提示变为一行显示**张照片与**个视频、数量总和为300004、切换年月日视图、过程流畅无卡顿、无黑白花闪现象');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果5、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为空、xxx克隆3W图片完成，图库检查 end');
}

/**
 * 端云-视频: [本地数据不为空、xxx克隆1000图片过程中，图库检查]
 * GROUP: 端云 MODULE: 视频TID: Multimedia_Gallery_YJRG_007
 * 前置条件
 * 1、本地预置500张图片
 2、新机关闭云同步
 */
async function Multimedia_Gallery_YJRG_007(dt: Dt) {
  dt.log.i('本地数据不为空、xxx克隆1000图片过程中，图库检查 start');
  dt.log.i('STEP 1、xxx克隆图片与视频（总数为1000）');

  await dt.sleep();
  dt.log.i('预期结果1、顶端文案中第一行显示**张照片和**个视频、数量为迁移总量+预置图片总量');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2、顶部文字第二行显示累计已加载**张照片和**个视频、数量为图库中已显示的图片与视频数量');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3、随克隆进程顶部第一行中数字增加不变、第二行图片与视频总数增加到1500后顶部提示变为一行显示**张照片与**个视频、数量总和为1500');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果4、切换年月日视图、过程流畅无卡顿、无黑白花闪现象');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果5、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据不为空、xxx克隆1000图片过程中，图库检查 end');
}

/**
 * 端云-视频: [本地数据不为空、xxx克隆1000图片完成后，图库检查]
 * GROUP: 端云 MODULE: 视频TID: Multimedia_Gallery_YJRG_008
 * 前置条件
 * 1、本地预置500张图片
 2、新机关闭云同步
 */
async function Multimedia_Gallery_YJRG_008(dt: Dt) {
  dt.log.i('本地数据不为空、xxx克隆1000图片完成后，图库检查 start');
  dt.log.i('STEP 1、xxx克隆图片与视频（总数为1000）');

  await dt.sleep();
  dt.log.i('预期结果1、顶部文字显示**张照片和**个视频。数量与克隆总数+预置数据相符、与图库中展示数量相符');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2、切换年月日视图、过程流畅无卡顿、无黑白花闪现象');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据不为空、xxx克隆1000图片完成后，图库检查 end');
}

/**
 * 端云-视频: [本地数据不为空、xxx克隆1W图片过程中，图库检查]
 * GROUP: 端云 MODULE: 视频TID: Multimedia_Gallery_YJRG_009
 * 前置条件
 * 1、本地预置500张图片
 2、新机关闭云同步
 */
async function Multimedia_Gallery_YJRG_009(dt: Dt) {
  dt.log.i('本地数据不为空、xxx克隆1W图片过程中，图库检查 start');
  dt.log.i('STEP 1、xxx克隆图片与视频（总数为10000）');

  await dt.sleep();
  dt.log.i('预期结果1、打开图库顶端文案中第一行显示**张照片和**个视频、数量为迁移总量。第二行显示累计已加载**张照片和**个视频、数量总和为2000');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2、克隆完成后第二行累计已加载图片与视频总数继续加载到全部完成、顶部提示变为一行显示**张照片与**个视频、数量总和为10500');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3、切换年月日视图、过程流畅无卡顿、无黑白花闪现象');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果4、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据不为空、xxx克隆1W图片过程中，图库检查 end');
}

/**
 * 端云-视频: [本地数据不为空、xxx克隆1W图片完成，图库检查]
 * GROUP: 端云 MODULE: 视频TID: Multimedia_Gallery_YJRG_010
 * 前置条件
 * 1、本地预置500张图片
 2、新机关闭云同步
 */
async function Multimedia_Gallery_YJRG_010(dt: Dt) {
  dt.log.i('本地数据不为空、xxx克隆1W图片完成，图库检查 start');
  dt.log.i('STEP 1、xxx克隆图片与视频（总数为10000）');

  await dt.sleep();
  dt.log.i('预期结果1、打开图库顶端文案中第一行显示**张照片和**个视频、数量为迁移总量。第二行显示累计已加载**张照片和**个视频、数量总和为2000');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2、克隆完成后第二行累计已加载图片与视频总数继续加载到全部完成、顶部提示变为一行显示**张照片与**个视频、数量总和为10500');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3、切换年月日视图、过程流畅无卡顿、无黑白花闪现象');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果4、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据不为空、xxx克隆1W图片完成，图库检查 end');
}

/**
 * 端云-视频: [本地数据为空时、xxx到xxx克隆3W图片过程中，图库检查]
 * GROUP: 端云 MODULE: 视频TID: Multimedia_Gallery_YJRG_011
 * 前置条件
 * 1、本地预置500张图片
 */
async function Multimedia_Gallery_YJRG_011(dt: Dt) {
  dt.log.i('本地数据为空时、xxx到xxx克隆3W图片过程中，图库检查 start');
  dt.log.i('STEP 1、xxx克隆图片与视频（总数为30000）');

  await dt.sleep();
  dt.log.i('预期结果1、顶端文字中第一行文案图片总数与已展示图片总数相符');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2、顶部文字第二行显示数量为迁移图片总量加原地本图片减去第一行图片数量');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3、随克隆进程顶部第一行中数字增加、第二行中数字减少、总量不变');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果4、随克隆进程顶部第一行中数字增加、相应的展示图片数量增加');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果5、顶部第一行文字增加到2W后、顶部整体文字变为一行、展示克隆图片总数量');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果6、切换年月日视图、过程流畅无卡顿、无黑白花闪现象');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果7、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果8、相册页下滑到最后、有缩略图生成动效');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为空时、xxx到xxx克隆3W图片过程中，图库检查 end');
}

/**
 * 端云-视频: [本地数据为空、xxx克隆3W图片完成后，图库检查]
 * GROUP: 端云 MODULE: 视频TID: Multimedia_Gallery_YJRG_012
 * 前置条件
 * 1、本地预置500张图片
 */
async function Multimedia_Gallery_YJRG_012(dt: Dt) {
  dt.log.i('本地数据为空、xxx克隆3W图片完成后，图库检查 start');
  dt.log.i('STEP 1、xxx克隆图片与视频（总数为30000）');

  await dt.sleep();
  dt.log.i('预期结果1、顶端文字中第一行文案图片总数与已展示图片总数相符，从2000张开始增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2、顶部文字第二行显示数量为迁移图片总量加原地本图片减去第一行图片数量');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3、随克隆进程顶部第一行中数字增加、第二行中数字减少、总量不变');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果4、随克隆进程顶部第一行中数字增加、相应的展示图片数量增加');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果5、顶部第一行文字增加到2W后、顶部整体文字变为一行、展示克隆图片总数量');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果6、切换年月日视图、过程流畅无卡顿、无黑白花闪现象');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果7、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果8、相册页下滑到最后、有缩略图生成动效');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为空、xxx克隆3W图片完成后，图库检查 end');
}

/**
 * 端云-: [本地数据为空、xxx后图库检查]
 * GROUP: 端云 MODULE: TID: Multimedia_Gallery_YJRG_013
 * 前置条件
 * 本地数据为空
 */
async function Multimedia_Gallery_YJRG_013(dt: Dt) {
  dt.log.i('本地数据为空、xxx后图库检查 start');
  dt.log.i('STEP 1、xxx升级为xxx');

  await dt.sleep();
  dt.log.i('STEP 2、升级后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2、图库页面为空，未显示霸屏页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、相册页为空，未显示霸屏页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为空、xxx后图库检查 end');
}

/**
 * 端云-大图: [本地数据为100、xxx后图库检查]
 * GROUP: 端云 MODULE: 大图TID: Multimedia_Gallery_YJRG_014
 * 前置条件
 * 升级前本地预置100张原图片
 */
async function Multimedia_Gallery_YJRG_014(dt: Dt) {
  dt.log.i('本地数据为100、xxx后图库检查 start');
  dt.log.i('STEP 1、xxx升级为xxx');

  await dt.sleep();
  dt.log.i('STEP 2、升级后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、显示Loading霸屏界面2.2、Loading页面加载完后，顶端文字中第一行文案图片总数与已展示图片总数相符');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为100、xxx后图库检查 end');
}

/**
 * 端云-大图: [本地数据不为空、xxx后恢复1000张图片过程中，图库检查]
 * GROUP: 端云 MODULE: 大图TID: Multimedia_Gallery_YJRG_015
 * 前置条件
 * 升级前本地预置1000张原图片
 */
async function Multimedia_Gallery_YJRG_015(dt: Dt) {
  dt.log.i('本地数据不为空、xxx后恢复1000张图片过程中，图库检查 start');
  dt.log.i('STEP 1、xxx升级为xxx');

  await dt.sleep();
  dt.log.i('STEP 2、升级后恢复过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶端文字中第一行文案图片总数与已展示图片总数相符2.2、顶部文字第二行显示数量为升级前原本地图片数量减去第一行图片数量2.3、随恢复进程顶部第一行中数字增加、相应的展示图片数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据不为空、xxx后恢复1000张图片过程中，图库检查 end');
}

/**
 * 端云-视频: [本地数据不为空、xxx后恢复1000张图片完成后，图库检查]
 * GROUP: 端云 MODULE: 视频TID: Multimedia_Gallery_YJRG_016
 * 前置条件
 * 升级前本地预置1000张原图片
 */
async function Multimedia_Gallery_YJRG_016(dt: Dt) {
  dt.log.i('本地数据不为空、xxx后恢复1000张图片完成后，图库检查 start');
  dt.log.i('STEP 1、xxx升级为xxx');

  await dt.sleep();
  dt.log.i('STEP 2、升级完并恢复完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶部文字变为1行，显示图库中所有视频与图片总数量。数量与原xxx本地图片数量相符2.2、图片正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据不为空、xxx后恢复1000张图片完成后，图库检查 end');
}

/**
 * 端云-大图: [本地数据不为空、xxx后恢复1w张图片过程中，图库检查]
 * GROUP: 端云 MODULE: 大图TID: Multimedia_Gallery_YJRG_017
 * 前置条件
 * 升级前本地预置1w张原图片
 */
async function Multimedia_Gallery_YJRG_017(dt: Dt) {
  dt.log.i('本地数据不为空、xxx后恢复1w张图片过程中，图库检查 start');
  dt.log.i('STEP 1、xxx升级为xxx');

  await dt.sleep();
  dt.log.i('STEP 2、升级后恢复过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶端文字中第一行文案图片总数与已展示图片总数相符，从2000张开始增加2.2、顶部文字第二行显示数量为升级前原本地图片数量减去第一行图片数量2.3、随恢复进程顶部第一行中数字增加、第二行中数字减少、总量不变2.4、随恢复进程顶部第一行中数字增加、相应的展示图片数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据不为空、xxx后恢复1w张图片过程中，图库检查 end');
}

/**
 * 端云-视频: [本地数据不为空、xxx后恢复1w张图片完成后，图库检查]
 * GROUP: 端云 MODULE: 视频TID: Multimedia_Gallery_YJRG_018
 * 前置条件
 * 升级前本地预置1w张原图片
 */
async function Multimedia_Gallery_YJRG_018(dt: Dt) {
  dt.log.i('本地数据不为空、xxx后恢复1w张图片完成后，图库检查 start');
  dt.log.i('STEP 1、xxx升级为xxx');

  await dt.sleep();
  dt.log.i('STEP 2、升级完并恢复完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶部文字变为1行，显示图库中所有视频与图片总数量。数量与原xxx本地图片数量相符2.2、图片正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据不为空、xxx后恢复1w张图片完成后，图库检查 end');
}

/**
 * 端云-大图: [本地数据不为空时、xxxxxx后后恢复1w张图片的过程中，进入图库检查]
 * GROUP: 端云 MODULE: 大图TID: Multimedia_Gallery_YJRG_019
 * 前置条件
 * 升级前本地预置1w张原图片
 */
async function Multimedia_Gallery_YJRG_019(dt: Dt) {
  dt.log.i('本地数据不为空时、xxxxxx后后恢复1w张图片的过程中，进入图库检查 start');
  dt.log.i('STEP 1、xxx升级为xxx');

  await dt.sleep();
  dt.log.i('STEP 2、升级后恢复过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶端文字中第一行文案图片总数与已展示图片总数相符2.2、顶部文字第二行显示数量为升级前原本地图片数量减去第一行图片数量2.3、随恢复进程顶部第一行中数字增加、第二行中数字减少、总量不变2.4、随恢复进程顶部第一行中数字增加、相应的展示图片数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据不为空时、xxxxxx后后恢复1w张图片的过程中，进入图库检查 end');
}

/**
 * 端云-视频: [本地数据不为空、xxx升级到xxx后恢复1w张图片完成后，图库检查]
 * GROUP: 端云 MODULE: 视频TID: Multimedia_Gallery_YJRG_020
 * 前置条件
 * 升级前本地预置1w张原图片
 */
async function Multimedia_Gallery_YJRG_020(dt: Dt) {
  dt.log.i('本地数据不为空、xxx升级到xxx后恢复1w张图片完成后，图库检查 start');
  dt.log.i('STEP 1、xxx升级为xxx');

  await dt.sleep();
  dt.log.i('STEP 2、升级完并恢复完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶部文字变为1行，显示图库中所有视频与图片总数量。数量与原xxx本地图片数量相符2.2、图片正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据不为空、xxx升级到xxx后恢复1w张图片完成后，图库检查 end');
}

/**
 * 端云-大图: [本地数据不为空、xxx后恢复3w张图片过程中，图库检查]
 * GROUP: 端云 MODULE: 大图TID: Multimedia_Gallery_YJRG_021
 * 前置条件
 * 升级前本地预置3w张原图片
 */
async function Multimedia_Gallery_YJRG_021(dt: Dt) {
  dt.log.i('本地数据不为空、xxx后恢复3w张图片过程中，图库检查 start');
  dt.log.i('STEP 1、xxx升级为xxx');

  await dt.sleep();
  dt.log.i('STEP 2、升级后恢复过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶端文字中第一行文案图片总数与已展示图片总数相符2.2、顶部文字第二行显示数量为升级前原本地图片数量减去第一行图片数量2.3、随恢复进程顶部第一行中数字增加、第二行中数字减少、总量不变2.4、随恢复进程顶部第一行中数字增加、相应的展示图片数量增加2.5、顶部第一行文字增加到2w后，顶部整体文字变为一行，展示升级前原本地图片数量');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、照片页下滑到最后，观察是否有缩略图生成动效');

  await dt.sleep();
  dt.log.i('预期结果4、有缩略图生成动效');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据不为空、xxx后恢复3w张图片过程中，图库检查 end');
}

/**
 * 端云-视频: [本地数据不为空、xxx后恢复3w张图片完成后，图库检查]
 * GROUP: 端云 MODULE: 视频TID: Multimedia_Gallery_YJRG_022
 * 前置条件
 * 升级前本地预置3w张原图片
 */
async function Multimedia_Gallery_YJRG_022(dt: Dt) {
  dt.log.i('本地数据不为空、xxx后恢复3w张图片完成后，图库检查 start');
  dt.log.i('STEP 1、xxx升级为xxx');

  await dt.sleep();
  dt.log.i('STEP 2、升级完并恢复完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶部文字变为一行，显示图库中所有视频与图片总数量。数量与原xxx本地图片数量相符2.2、图片正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、照片页下滑到最后，观察是否有缩略图生成动效');

  await dt.sleep();
  dt.log.i('预期结果4、有缩略图生成动效');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据不为空、xxx后恢复3w张图片完成后，图库检查 end');
}

/**
 * 端云-下载: [首次云同步1000张图片过程中，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_023
 * 前置条件
 * 云上预置1000张图片
 */
async function Multimedia_Gallery_YJRG_023(dt: Dt) {
  dt.log.i('首次云同步1000张图片过程中，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载1000张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶端文字中第一行文案显示为“云空间包含XX”，数量为云上图片及视频总数2.2、顶部文字第二行显示为“累计已同步XX”，数量为已展示图片和视频总数2.3、随恢复进程第二行中数字增加，最终等于云上的图片及视频总数2.4、随恢复进程顶部第二行中数字增加、相应的展示图片数量增加，两者数量对应（不算白块的数量）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('云空间包含XX'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('首次云同步1000张图片过程中，图库检查 end');
}

/**
 * 端云-下载: [首次云同步1000张图片完成后，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_024
 * 前置条件
 * 云上预置1000张图片
 */
async function Multimedia_Gallery_YJRG_024(dt: Dt) {
  dt.log.i('首次云同步1000张图片完成后，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载1000张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶部文字变为1行，文案显示为“已同步全部xx”,数量为云上图片及视频总数2.2、图片正常显示，展示图片数量为已同步数量');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('已同步全部xx'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('首次云同步1000张图片完成后，图库检查 end');
}

/**
 * 端云-下载: [首次云同步1w张图片过程中，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_025
 * 前置条件
 * 云上预置1w张图片
 */
async function Multimedia_Gallery_YJRG_025(dt: Dt) {
  dt.log.i('首次云同步1w张图片过程中，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载1w张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶端文字中第一行文案显示为“云空间包含XX”，数量为云上图片及视频总数2.2、顶部文字第二行显示为“累计已同步XX”，数量为已展示图片和视频总数2.3、随恢复进程第二行中数字增加，最终等于云上的图片及视频总数2.4、随恢复进程顶部第二行中数字增加、相应的展示图片数量增加，两者数量对应（不算白块的数量）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('云空间包含XX'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('首次云同步1w张图片过程中，图库检查 end');
}

/**
 * 端云-下载: [首次云同步1w张图片完成后，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_026
 * 前置条件
 * 云上预置1w张图片
 */
async function Multimedia_Gallery_YJRG_026(dt: Dt) {
  dt.log.i('首次云同步1w张图片完成后，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载1w张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶部文字变为1行，文案显示为“已同步全部xx”,数量为云上图片及视频总数2.2、图片正常显示，展示图片数量为已同步数量');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('已同步全部xx'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、年月日照片页下滑到最后，观察是否没有白块，所有图片都已加载出来');

  await dt.sleep();
  dt.log.i('预期结果4.1、没有白块，所有图片都已加载出来4.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('首次云同步1w张图片完成后，图库检查 end');
}

/**
 * 端云-下载: [首次云同步3w张图片过程中，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_027
 * 前置条件
 * 云上预置3w张图片
 */
async function Multimedia_Gallery_YJRG_027(dt: Dt) {
  dt.log.i('首次云同步3w张图片过程中，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载3w张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶端文字中第一行文案显示为“云空间包含XX”，数量为云上图片及视频总数2.2、顶部文字第二行显示为“累计已同步XX”，数量为已展示图片和视频总数2.3、随恢复进程第二行中数字增加，最终等于云上的图片及视频总数2.4、随恢复进程顶部第二行中数字增加、相应的展示图片数量增加，两者数量对应（不算白块的数量）2.5、当顶部第二行中数字达到2w时，图片展示全部数量，未同步完的图片会以白块显示，随着第二行文字增加，白块减少');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('云空间包含XX'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、年月日照片页下滑到最后，观察是否有缩略图生成动效');

  await dt.sleep();
  dt.log.i('预期结果4.1、有缩略图生成动效4.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('首次云同步3w张图片过程中，图库检查 end');
}

/**
 * 端云-下载: [首次云同步3w张图片完成后，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_028
 * 前置条件
 * 云上预置3w张图片
 */
async function Multimedia_Gallery_YJRG_028(dt: Dt) {
  dt.log.i('首次云同步3w张图片完成后，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载3w张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步过程完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶部文字变为1行，文案显示为“已同步全部xx”,数量为云上图片及视频总数2.2、图片正常显示，展示图片数量为已同步数量，且无白块图片');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('已同步全部xx'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、年月日照片页下滑到最后，观察是否没有白块，所有图片都已加载出来');

  await dt.sleep();
  dt.log.i('预期结果4.1、没有白块，所有图片都已加载出来4.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('首次云同步3w张图片完成后，图库检查 end');
}

/**
 * 端云-下载: [本地数据为50，增量云同步40张图片过程中，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_029
 * 前置条件
 * 本地预置50张图片，云上预置40张图片，云图库设置保留原片
 */
async function Multimedia_Gallery_YJRG_029(dt: Dt) {
  dt.log.i('本地数据为50，增量云同步40张图片过程中，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步伀关下载40张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶端文字中图片总数与已展示图片总数相符，为本地预置图片数量+云上预置图片数量2.2、随恢复进程顶部数字增加、相应的展示图片数量增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为50，增量云同步40张图片过程中，图库检查 end');
}

/**
 * 端云-下载: [本地数据为50，增量云同步40张图片完成后，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_030
 * 前置条件
 * 本地预置50张图片，云上预置40张图片，云图库设置保留原片
 */
async function Multimedia_Gallery_YJRG_030(dt: Dt) {
  dt.log.i('本地数据为50，增量云同步40张图片完成后，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载40张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶端文字中图片总数与已展示图片总数相符，为本地预置图片数量+云上预置图片数量2.2、图片正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、关闭云同步功能，观察照片页和照片页是否正常展示图片及图片数量');

  await dt.sleep();
  dt.log.i('预期结果4.1、照片页正常展示本地的50张图片，顶部文字显示50张图片4.2、相册页可以正常打开图片，图片数量显示50');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为50，增量云同步40张图片完成后，图库检查 end');
}

/**
 * 端云-下载: [本地数据为50，增量云同步450张图片过程中，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_031
 * 前置条件
 * 本地预置50张图片，云上预置450张图片，云图库设置保留原片
 */
async function Multimedia_Gallery_YJRG_031(dt: Dt) {
  dt.log.i('本地数据为50，增量云同步450张图片过程中，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载450张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶端文字中第一行文案显示为“云空间包含XX”，数量为云上+本地已上传端云的图片及视频总数2.2、元数据同步完成后，顶部文字第二行显示为“累计已同步XX，xx个本地项目正在上传”，同步数量为已展示图片和视频总数，待上传数量为本地未上云的预置图片数量2.3、随恢复进程第二行中同步数字增加，最终等于云上的图片及视频总数，待上传项目减少最后消失2.4、随恢复进程顶部第二行中数字增加、相应的展示图片数量增加，两者数量对应（不算白块的数量）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('云空间包含XX'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为50，增量云同步450张图片过程中，图库检查 end');
}

/**
 * 端云-下载: [本地数据为50，增量云同步450张图片完成后，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_032
 * 前置条件
 * 本地预置50张图片，云上预置450张图片，云图库设置保留原片
 */
async function Multimedia_Gallery_YJRG_032(dt: Dt) {
  dt.log.i('本地数据为50，增量云同步450张图片完成后，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载450张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶部文字变为1行，文案显示为“已同步全部xx”,数量为云上图片及视频总数2.2、图片正常显示，展示图片数量为已同步数量，且无白块图片');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('已同步全部xx'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、年月日照片页下滑到最后，观察图片样式是否正常');

  await dt.sleep();
  dt.log.i('预期结果4、图片样式正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为50，增量云同步450张图片完成后，图库检查 end');
}

/**
 * 端云-下载: [本地数据为200，增量云同步450张图片过程中，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_033
 * 前置条件
 * 本地预置200张图片，云上预置450张图片，云图库设置保留原片
 */
async function Multimedia_Gallery_YJRG_033(dt: Dt) {
  dt.log.i('本地数据为200，增量云同步450张图片过程中，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载450张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶端文字中第一行文案显示为“云空间包含XX”，数量为云上+本地已上传端云的图片及视频总数2.2、元数据同步完成后，顶部文字第二行显示为“累计已同步XX，xx个本地项目正在上传”，同步数量为已展示图片和视频总数，待上传数量为本地未上云的预置图片数量2.3、随恢复进程第二行中同步数字增加，最终等于云上的图片及视频总数，待上传项目减少最后消失2.4、随恢复进程顶部第二行中数字增加、相应的展示图片数量增加，两者数量对应（不算白块的数量）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('云空间包含XX'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为200，增量云同步450张图片过程中，图库检查 end');
}

/**
 * 端云-下载: [本地数据为200，增量云同步450张图片完成后，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_034
 * 前置条件
 * 本地预置200张图片，云上预置450张图片，云图库设置保留原片
 */
async function Multimedia_Gallery_YJRG_034(dt: Dt) {
  dt.log.i('本地数据为200，增量云同步450张图片完成后，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载450张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶部文字变为1行，文案显示为“已同步全部xx”,数量为云上图片及视频总数2.2、图片正常显示，展示图片数量为已同步数量，且无白块图片');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('已同步全部xx'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、年月日照片页下滑到最后，观察图片样式是否正常');

  await dt.sleep();
  dt.log.i('预期结果4、图片样式正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为200，增量云同步450张图片完成后，图库检查 end');
}

/**
 * 端云-下载: [本地数据为200，增量云同步2000张图片过程中，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_035
 * 前置条件
 * 本地预置200张图片，云上预置2000张图片，云图库设置保留原片
 */
async function Multimedia_Gallery_YJRG_035(dt: Dt) {
  dt.log.i('本地数据为200，增量云同步2000张图片过程中，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载2000张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶端文字中第一行文案显示为“云空间包含XX”，数量为云上+本地已上传端云的图片及视频总数2.2、元数据同步完成后，顶部文字第二行显示为“累计已同步XX，xx个本地项目正在上传”，同步数量为已展示图片和视频总数，待上传数量为本地未上云的预置图片数量2.3、随恢复进程第二行中同步数字增加，最终等于云上的图片及视频总数，待上传项目减少，最后消失2.4、随恢复进程顶部第二行中数字增加、相应的展示图片数量增加，两者数量对应（不算白块的数量）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('云空间包含XX'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为200，增量云同步2000张图片过程中，图库检查 end');
}

/**
 * 端云-下载: [本地数据为200，增量云同步2000张图片完成后，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_036
 * 前置条件
 * 本地预置200张图片，云上预置2000张图片，云图库设置保留原片
 */
async function Multimedia_Gallery_YJRG_036(dt: Dt) {
  dt.log.i('本地数据为200，增量云同步2000张图片完成后，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载2000张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶部文字变为1行，文案显示为“已同步全部xx”,数量为云上图片及视频总数2.2、图片正常显示，展示图片数量为已同步数量，且无白块图片');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('已同步全部xx'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、年月日照片页下滑到最后，观察图片样式是否正常');

  await dt.sleep();
  dt.log.i('预期结果4、图片样式正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为200，增量云同步2000张图片完成后，图库检查 end');
}

/**
 * 端云-下载: [本地数据为3000，增量云同步2000张图片过程中，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_037
 * 前置条件
 * 本地预置3000张图片，云上预置2000张图片，云图库设置保留原片
 */
async function Multimedia_Gallery_YJRG_037(dt: Dt) {
  dt.log.i('本地数据为3000，增量云同步2000张图片过程中，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载2000张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶端文字中第一行文案显示为“云空间包含XX”，数量为云上+本地已上传端云的图片及视频总数2.2、元数据同步完成后，顶部文字第二行显示为“累计已同步XX，xx个本地项目正在上传”，同步数量为已展示图片和视频总数，待上传数量为本地未上云的预置图片数量2.3、随恢复进程第二行中同步数字增加，最终等于云上的图片及视频总数，待上传项目减少最后消失2.4、随恢复进程顶部第二行中数字增加、相应的展示图片数量增加，两者数量对应（不算白块的数量）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('云空间包含XX'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、年月日照片页下滑到最后，观察图片样式是否正常');

  await dt.sleep();
  dt.log.i('预期结果4.1、有缩略图生成动效4.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为3000，增量云同步2000张图片过程中，图库检查 end');
}

/**
 * 端云-下载: [本地数据为3000，增量云同步2000张图片完成后，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_038
 * 前置条件
 * 本地预置3000张图片，云上预置2000张图片，云图库设置保留原片
 */
async function Multimedia_Gallery_YJRG_038(dt: Dt) {
  dt.log.i('本地数据为3000，增量云同步2000张图片完成后，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载2000张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶部文字变为1行，文案显示为“已同步全部xx”,数量为云上图片及视频总数2.2、图片正常显示，展示图片数量为已同步数量，且无白块图片3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('已同步全部xx'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、年月日照片页下滑到最后，观察图片样式是否正常');

  await dt.sleep();
  dt.log.i('预期结果4、图片样式正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为3000，增量云同步2000张图片完成后，图库检查 end');
}

/**
 * 端云-下载: [本地数据为3000，增量云同步2w张图片过程中，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_039
 * 前置条件
 * 本地预置3000张图片，云上预置2w张图片
 */
async function Multimedia_Gallery_YJRG_039(dt: Dt) {
  dt.log.i('本地数据为3000，增量云同步2w张图片过程中，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载2w张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶端文字中第一行文案显示为“云空间包含XX”，数量为云上图片及视频总数2.2、顶部文字第二行显示为“累计已同步XX”，数量为已展示图片和视频总数2.3、随恢复进程第二行中数字增加，最终等于云上的图片及视频总数2.4、随恢复进程顶部第二行中数字增加、相应的展示图片数量增加，两者数量对应（不算白块的数量）2.5、当顶部第二行中数字达到2w时，图片展示全部数量，未同步完的图片会以白块显示，随着第二行文字增加，白块减少');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('云空间包含XX'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、照片页下滑到最后，观察是否有缩略图生成动效');

  await dt.sleep();
  dt.log.i('预期结果4.1、有缩略图生成动效4.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为3000，增量云同步2w张图片过程中，图库检查 end');
}

/**
 * 端云-下载: [本地数据为3000，增量云同步2w张图片完成后，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_040
 * 前置条件
 * 本地预置3000张图片，云上预置2w张图片
 */
async function Multimedia_Gallery_YJRG_040(dt: Dt) {
  dt.log.i('本地数据为3000，增量云同步2w张图片完成后，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载2w张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶部文字变为1行，文案显示为“已同步全部xx”,数量为云上图片及视频总数2.2、图片正常显示，展示图片数量为已同步数量');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('已同步全部xx'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、照片页下滑到最后，观察是否有缩略图生成动效');

  await dt.sleep();
  dt.log.i('预期结果4.1、有缩略图生成动效4.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为3000，增量云同步2w张图片完成后，图库检查 end');
}

/**
 * 端云-下载: [本地数据为21000，增量云同步2w张图片过程中，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_041
 * 前置条件
 * 本地预置21000张图片，云上预置21000张图片
 */
async function Multimedia_Gallery_YJRG_041(dt: Dt) {
  dt.log.i('本地数据为21000，增量云同步2w张图片过程中，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载21000张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶端文字中第一行文案显示为“云空间包含XX”，数量为云上图片及视频总数2.2、顶部文字第二行显示为“累计已同步XX”，数量为已展示图片和视频总数2.3、随恢复进程第二行中数字增加，最终等于云上的图片及视频总数2.4、随恢复进程顶部第二行中数字增加、相应的展示图片数量增加，两者数量对应（不算白块的数量）2.5、当顶部第二行中数字达到2w时，图片展示全部数量，未同步完的图片会以白块显示，随着第二行文字增加，白块减少');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('云空间包含XX'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、照片页下滑到最后，观察是否有缩略图生成动效');

  await dt.sleep();
  dt.log.i('预期结果4.1、有缩略图生成动效4.2、切换大图、可编辑、可以打开更多选项”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为21000，增量云同步2w张图片过程中，图库检查 end');
}

/**
 * 端云-下载: [本地数据为21000，增量云同步2w张图片完成后，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_042
 * 前置条件
 * 本地预置21000张图片，云上预置21000张图片
 */
async function Multimedia_Gallery_YJRG_042(dt: Dt) {
  dt.log.i('本地数据为21000，增量云同步2w张图片完成后，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载21000张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶部文字变为1行，文案显示为“已同步全部xx”,数量为云上图片及视频总数2.2、图片正常显示，展示图片数量为已同步数量');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('已同步全部xx'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、照片页下滑到最后，观察是否有缩略图生成动效');

  await dt.sleep();
  dt.log.i('预期结果4.1、有缩略图生成动效4.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地数据为21000，增量云同步2w张图片完成后，图库检查 end');
}

/**
 * 端云-滑动: [克隆与云同步交互]
 * GROUP: 端云 MODULE: 滑动TID: Multimedia_Gallery_YJRG_043
 * 前置条件
 * 1、本地数据为空
 2、登录账号、账号云端有2W图片、关闭云同步
 3、克隆的图片未上传到云空间
 */
async function Multimedia_Gallery_YJRG_043(dt: Dt) {
  dt.log.i('克隆与云同步交互 start');
  dt.log.i('STEP 1、xxx克隆10000张图片');

  await dt.sleep();
  dt.log.i('预期结果1、顶端文字中第一行文案图片总数与已展示图片总数相符');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2、顶部文字第二行显示数量为迁移图片总量减去第一行图片数量');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、打开云同步');

  await dt.sleep();
  dt.log.i('预期结果3、开启云同步后图片总数增加');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果4、云同步完成后图片数量为云端+克隆图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、照片页下滑到最后，观察是否有缩略图生成动效');

  await dt.sleep();
  dt.log.i('预期结果5、切换年月日视图、过程流畅无卡顿、无黑白花闪现象');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果6、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果7、滑动到底部、单白块生成时间不超过2秒、过程中无闪退、黑白花现象 ');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('克隆与云同步交互 end');
}

/**
 * 端云-滑动: [缩略图生成时操作图库]
 * GROUP: 端云 MODULE: 滑动TID: Multimedia_Gallery_YJRG_044
 * 前置条件
 * 1、本地数据为空
 */
async function Multimedia_Gallery_YJRG_044(dt: Dt) {
  dt.log.i('缩略图生成时操作图库 start');
  dt.log.i('STEP 1、xxx克隆30000张图片');

  await dt.sleep();
  dt.log.i('预期结果1、顶端文字中第一行文案图片总数与已展示图片总数相符');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2、顶部文字第二行显示数量为迁移图片总量减去第一行图片数量');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3、随克隆进程顶部第一行中数字增加、第二行中数字减少、总量不变');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、截屏、录屏');

  await dt.sleep();
  dt.log.i('预期结果4、随克隆进程顶部第一行中数字增加、相应的展示图片数量增加');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、拍摄图片、删除图片');

  await dt.sleep();
  dt.log.i('预期结果5、顶部第一行文字增加到2W后、顶部整体文字变为一行、展示克隆图片总数量');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、滑动浏览相册、图片、大图视图');

  await dt.sleep();
  dt.log.i('预期结果6、切换年月日视图、过程流畅无卡顿、无黑白花闪现象');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、通过三方应用打开相机浏览图库');

  await dt.sleep();
  dt.log.i('预期结果7、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果8、相册页下滑到最后、有缩略图生成动效');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果9、录屏、截屏、拍摄、删除操作完成、生成的截图视频在图库中可以查看浏览、拍摄的视频可以在图库中浏览、删除的图片进入回收站，可以恢复');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果10、大图可操作、可编辑、滑动浏览过程顺畅、无卡顿、黑白花闪现象');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果11、三方应用打开图库，图库中图片数量准确、大图可操作、可编辑、滑动浏览过程顺畅、无卡顿、黑白花闪现象');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('缩略图生成时操作图库 end');
}

/**
 * 端云-: [多语言专项]
 * GROUP: 端云 MODULE: TID: Multimedia_Gallery_YJRG_045
 * 前置条件
 * 1、将语言分别设置为英文、维吾尔语
 */
async function Multimedia_Gallery_YJRG_045(dt: Dt) {
  dt.log.i('多语言专项 start');
  dt.log.i('STEP 1、xxx克隆30000张图片');

  await dt.sleep();
  dt.log.i('预期结果1、测试结果同CASE6、检查英文、维吾尔语模式下文案显示是否正确（维吾尔语为镜像语言）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆完成打开图库、下拉检查顶部文字');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多语言专项 end');
}

/**
 * 端云-: [适老化专项]
 * GROUP: 端云 MODULE: TID: Multimedia_Gallery_YJRG_046
 * 前置条件
 * 1、打开适老化、将字体调为最大
 */
async function Multimedia_Gallery_YJRG_046(dt: Dt) {
  dt.log.i('适老化专项 start');
  dt.log.i('STEP 1、xxx克隆30000张图片');

  await dt.sleep();
  dt.log.i('预期结果1、测试结果同CASE6、文案大小档位正确、显示正确、无截断、部分显示现象');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆完成打开图库、下拉检查顶部文字');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('适老化专项 end');
}

/**
 * 端云-: [无障碍专项]
 * GROUP: 端云 MODULE: TID: Multimedia_Gallery_YJRG_047
 * 前置条件
 * 1、打开无障碍、将字体调为最大
 */
async function Multimedia_Gallery_YJRG_047(dt: Dt) {
  dt.log.i('无障碍专项 start');
  dt.log.i('STEP 1、xxx克隆30000张图片');

  await dt.sleep();
  dt.log.i('预期结果1、测试结果同CASE6、无障碍模式聚焦顶部文字、朗读正确');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆完成打开图库、下拉检查顶部文字');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无障碍专项 end');
}

/**
 * 端云-大图: [杀死媒体进程、再次进入图库可以再次拉起、生成缩略图]
 * GROUP: 端云 MODULE: 大图TID: Multimedia_Gallery_YJRG_048
 * 前置条件
 * 1、本地数据为空
 */
async function Multimedia_Gallery_YJRG_048(dt: Dt) {
  dt.log.i('杀死媒体进程、再次进入图库可以再次拉起、生成缩略图 start');
  dt.log.i('STEP 1、xxx克隆30000张图片');

  await dt.sleep();
  dt.log.i('预期结果1、顶端文字中第一行文案图片总数与已展示图片总数相符，从2000张开始增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、克隆完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2、顶部文字第二行显示数量为迁移图片总量减去第一行图片数量');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3、随克隆进程顶部第一行中数字增加、第二行中数字减少、总量不变');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、杀死媒体库进程');

  await dt.sleep();
  dt.log.i('预期结果4、随克隆进程顶部第一行中数字增加、相应的展示图片数量增加');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、进入图库查看');

  await dt.sleep();
  dt.log.i('预期结果5、顶部第一行文字增加到2W后、顶部整体文字变为一行、展示克隆图片总数量');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果6、切换年月日视图、过程流畅无卡顿、无黑白花闪现象');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果7、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果8、相册页下滑到最后、有缩略图生成动效');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果9、杀死媒体库后再次进入图库、图库现象为1-8，无异常卡主现象');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('杀死媒体进程、再次进入图库可以再次拉起、生成缩略图 end');
}

/**
 * 端云-下载: [首次xxx克隆生成2000张缩略图之前打开云同步过程中，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_049
 * 前置条件
 * 1、xxx手机本地数据为空，xxx手机本地数据为2000
 2、端云上预置2000张图片
 3、目标样机刷机后第一次登录云账号
 4、全程保持目标样机网络通畅
 */
async function Multimedia_Gallery_YJRG_049(dt: Dt) {
  dt.log.i('首次xxx克隆生成2000张缩略图之前打开云同步过程中，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载2000张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶端文字中第一行文案显示为“云空间包含XX”，数量为云上+本地已上传端云的图片及视频总数2.2、元数据同步完成后，顶部文字第二行显示为“累计已同步XX，xx个本地项目正在上传”，同步数量为已展示图片和视频总数，待上传数量为本地未上云的预置图片数量2.3、随恢复进程第二行中同步数字增加，最终等于云上的图片及视频总数2.4、随恢复进程顶部第二行中同步数字增加、相应的展示图片数量增加，两者数量对应（不算白块的数量）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('云空间包含XX'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项5.2、顶部文字第二行文案中待上传项目数量变为克隆的图片总数5.3、随恢复进程顶部第一行中数字增加、相应的展示图片数量增加6.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象6.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、在云同步未结束时，执行xxx克隆2000张图片');

  await dt.sleep();
  dt.log.i('STEP 5、克隆过程进行到导入页面时，打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果5.2、顶部文字第二行文案中待上传项目数量变为克隆的图片总数5.3、随恢复进程顶部第一行中数字增加、相应的展示图片数量增加');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果6.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象6.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('首次xxx克隆生成2000张缩略图之前打开云同步过程中，图库检查 end');
}

/**
 * 端云-下载: [首次xxx克隆生成2000张缩略图之前打开云同步完成后，图库检查]
 * GROUP: 端云 MODULE: 下载TID: Multimedia_Gallery_YJRG_050
 * 前置条件
 * 1、xxx手机本地数据为空，xxx手机本地数据为2000
 2、端云上预置2000张图片
 3、目标样机刷机后第一次登录云账号
 4、全程保持目标样机网络通畅
 */
async function Multimedia_Gallery_YJRG_050(dt: Dt) {
  dt.log.i('首次xxx克隆生成2000张缩略图之前打开云同步完成后，图库检查 start');
  dt.log.i('STEP 1、首次登录账号开启云同步开关下载2000张图片');

  await dt.sleep();
  dt.log.i('STEP 2、云同步过程中打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果2.1、顶端文字中第一行文案显示为“云空间包含XX”，数量为云上+本地已上传端云的图片及视频总数2.2、元数据同步完成后，顶部文字第二行显示为“累计已同步XX，xx个本地项目正在上传”，同步数量为已展示图片和视频总数，待上传数量为本地未上云的预置图片数量2.3、随恢复进程第二行中同步数字增加，最终等于云上的图片及视频总数，待上传项目减少最后消失2.4、随恢复进程顶部第二行中数字增加、相应的展示图片数量增加，两者数量对应（不算白块的数量）');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('云空间包含XX'));
  dt.log.i('STEP 3、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果3.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象3.2、切换大图、可编辑、可以打开更多选项5.1、顶部文字变为1行，文案显示为“已同步全部xx”,数量为云上+本地克隆到的图片及视频总数5.2、图片正常显示，展示图片数量为已同步数量，且无白块图片5.3、图片正常显示6.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象6.2、切换大图、可编辑、可以打开更多选项7、图片样式正常');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已同步全部xx', true);
  dt.log.i('STEP 4、在云同步未结束时，执行xxx克隆2000张图片');

  await dt.sleep();
  dt.log.i('STEP 5、云同步及克隆完成后打开图库、下拉检查顶部文字');

  await dt.sleep();
  dt.log.i('预期结果5.1、顶部文字变为1行，文案显示为“已同步全部xx”,数量为云上+本地克隆到的图片及视频总数5.2、图片正常显示，展示图片数量为已同步数量，且无白块图片5.3、图片正常显示');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已同步全部xx', true);
  dt.log.i('STEP 6、照片页切换年月日视图');

  await dt.sleep();
  dt.log.i('预期结果6.1、切换年月日视图、过程流畅无卡顿、无黑白花闪现象6.2、切换大图、可编辑、可以打开更多选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、年月日照片页下滑到最后，观察图片样式是否正常');

  await dt.sleep();
  dt.log.i('预期结果7、图片样式正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('首次xxx克隆生成2000张缩略图之前打开云同步完成后，图库检查 end');
}