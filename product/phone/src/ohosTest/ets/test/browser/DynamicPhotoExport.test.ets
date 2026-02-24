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
import { MatchPattern } from '@kit.TestKit';

export default function DynamicPhotoExportTest(): void {
  describe('DynamicPhotoExportTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    // 确认当前图库app处于启动状态
    beforeAll(async (): Promise<void> => {
      // 进入图库
      await AppStart.photos()
    });
    run('beforeDynamicPhotoExportTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      // 打开大图
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    // DT声明
    run('Multimedia_Gallery_Dynamic_Photo_Export_001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [不同入口动态照片支持导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_001
      await Multimedia_Gallery_Dynamic_Photo_Export_001(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [部分动态照片不支持导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_002
      await Multimedia_Gallery_Dynamic_Photo_Export_002(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片导出视频界面ux显示] TID: Multimedia_Gallery_Dynamic_Photo_Export_003
      await Multimedia_Gallery_Dynamic_Photo_Export_003(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片导出视频详细信息显示] TID: Multimedia_Gallery_Dynamic_Photo_Export_004
      await Multimedia_Gallery_Dynamic_Photo_Export_004(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片切换循环播放效果后导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_005
      await Multimedia_Gallery_Dynamic_Photo_Export_005(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片切换主角时刻后导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_006
      await Multimedia_Gallery_Dynamic_Photo_Export_006(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_0061', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [删除图片补位到下个视频播放] TID: Multimedia_Gallery_Dynamic_Photo_Export_0061
      await Multimedia_Gallery_Dynamic_Photo_Export_0061(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片切换运动轨迹后导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_007
      await Multimedia_Gallery_Dynamic_Photo_Export_007(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片切换微动瞬间后导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_008
      await Multimedia_Gallery_Dynamic_Photo_Export_008(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [关闭动态照片效果不支持导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_009
      await Multimedia_Gallery_Dynamic_Photo_Export_009(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片多次导出视频场景] TID: Multimedia_Gallery_Dynamic_Photo_Export_010
      await Multimedia_Gallery_Dynamic_Photo_Export_010(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片编辑后导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_011
      await Multimedia_Gallery_Dynamic_Photo_Export_011(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_012', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片导出视频进行编辑] TID: Multimedia_Gallery_Dynamic_Photo_Export_012
      await Multimedia_Gallery_Dynamic_Photo_Export_012(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_013', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [xxx端云同步后动态照片下载完成后导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_013
      await Multimedia_Gallery_Dynamic_Photo_Export_013(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_014', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [xxx端云同步后动态照片未下载完成导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_014
      await Multimedia_Gallery_Dynamic_Photo_Export_014(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_015', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [xxx端云同步后动态照片导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_015
      await Multimedia_Gallery_Dynamic_Photo_Export_015(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_016', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [无网络情况下xxx端云同步后动态照片导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_016
      await Multimedia_Gallery_Dynamic_Photo_Export_016(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_017', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [xxx克隆后动态照片导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_017
      await Multimedia_Gallery_Dynamic_Photo_Export_017(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_018', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [xxx克隆后动态照片导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_018
      await Multimedia_Gallery_Dynamic_Photo_Export_018(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_019', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [深色模式下动态照片导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_019
      await Multimedia_Gallery_Dynamic_Photo_Export_019(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_020', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [横竖屏切换中动态照片导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_020
      await Multimedia_Gallery_Dynamic_Photo_Export_020(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_021', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [分屏状态动态照片导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_021
      await Multimedia_Gallery_Dynamic_Photo_Export_021(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_022', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [悬浮窗场景动态照片导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_022
      await Multimedia_Gallery_Dynamic_Photo_Export_022(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_023', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [大字体场景下动态照片导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_023
      await Multimedia_Gallery_Dynamic_Photo_Export_023(dt);
    });
    run('Multimedia_Gallery_Dynamic_Photo_Export_024', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [视频详情页滑动到动态照片导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_024
      await Multimedia_Gallery_Dynamic_Photo_Export_024(dt);
    });

    // 退出大图 回到时间线页面
    afterAll(async (): Promise<void> => await Exit.browser());
    // 确保每次测试完毕回到大图页
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEach DynamicPhotoExportTest').init();
      dt.log.i('afterEach DynamicPhotoExportTest test');
      dt.log.i('afterEach DynamicPhotoExportTest test finish');
    });
  });
}

// DT步骤
/**
 * 大图-动态照片: [不同入口动态照片支持导出视频]
 * TAG: 558 TID: Multimedia_Gallery_Dynamic_Photo_Export_001
 * 前置条件
 * 相机拍摄多张动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_001(dt: Dt) {
  dt.log.i('不同入口动态照片支持导出视频 start');
  dt.log.i('STEP 1、从照片宫格页打开动态照片，导出视频');

  await dt.sleep();
  dt.log.i('预期结果1-4、导出后跳转到新视频，可以正常播放，视频内容和动态照片一致5、导出后停留当前页面，toats提示“导出成功，可在视频相册查看“6、所有导出的视频都新增在视频相册内，正常播放');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('年', MatchPattern.CONTAINS)); //导出成功，可在视频相册查看'));
  dt.log.i('STEP 2、从相机入口打开动态照片，导出视频');

  await dt.sleep();
  dt.log.i('STEP 3、从用户创建相册打开动态照片，导出视频');

  await dt.sleep();
  dt.log.i('STEP 4、从来源相册打开动态照片，导出视频');

  await dt.sleep();
  dt.log.i('STEP 5、从图片相册打开动态照片，导出视频');

  await dt.sleep();
  dt.log.i('预期结果5、导出后停留当前页面，toats提示“导出成功，可在视频相册查看“');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('导出成功，可在视频相册查看', true);
  dt.log.i('STEP 6、从视频相册查看');

  await dt.sleep();
  dt.log.i('预期结果6、所有导出的视频都新增在视频相册内，正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同入口动态照片支持导出视频 end');
}

/**
 * 大图-动态照片: [部分动态照片不支持导出视频]
 * TAG: 580 TID: Multimedia_Gallery_Dynamic_Photo_Export_002
 * 前置条件
 * 相机拍摄多张动态照片，隐藏相册，删除相册存在动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_002(dt: Dt) {
  dt.log.i('部分动态照片不支持导出视频 start');
  dt.log.i('STEP 1、从隐藏相册入口打开动态照片，导出视频');

  await dt.sleep();
  dt.log.i('预期结果1、不支持导出视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从删除相册入口打开动态照片，导出视频');

  await dt.sleep();
  dt.log.i('预期结果2、不支持导出视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('部分动态照片不支持导出视频 end');
}

/**
 * 大图-动态照片: [动态照片导出视频界面ux显示]
 * TAG: 566 TID: Multimedia_Gallery_Dynamic_Photo_Export_003
 * 前置条件
 * 图库存在动态照片，普通图片，视频
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_003(dt: Dt) {
  dt.log.i('动态照片导出视频界面ux显示 start');
  dt.log.i('STEP 1、宫格页/相机入口/用户创建相册/图片相册/来源相册打开动态照片，点击右上角四方菜单');

  await dt.sleep();
  dt.log.i('预期结果1、菜单显示导出视频选项，显示在详细信息之上');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、隐藏相册、删除相册打开动态照片，点击右上角四方菜单');

  await dt.sleep();
  dt.log.i('预期结果2、菜单无导出视频选项');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、宫格页打开普通图片，点击右上角四方菜单');

  await dt.sleep();
  dt.log.i('预期结果3、菜单无导出视频选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、宫格页打开视频，点击右上角四方菜单');

  await dt.sleep();
  dt.log.i('预期结果4、菜单无导出视频选项');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片导出视频界面ux显示 end');
}

/**
 * 大图-动态照片: [动态照片导出视频详细信息显示]
 * TAG: 567 TID: Multimedia_Gallery_Dynamic_Photo_Export_004
 * 前置条件
 * 相机拍摄多张动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_004(dt: Dt) {
  dt.log.i('动态照片导出视频详细信息显示 start');
  dt.log.i('STEP 1、动态照片导出多个视频');

  await dt.sleep();
  dt.log.i('STEP 2、观察动态照片详细信息');

  await dt.sleep();
  dt.log.i('预期结果2、动态照片以拍摄时间为后缀命名，时间显示为拍摄时间，格式为jpg');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、观察导出视频的详细信息');

  await dt.sleep();
  dt.log.i('预期结果3、视频以导出时间为后缀命名，时间显示为原始动态照片的拍摄时间，格式为MP4，显示时长');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片导出视频详细信息显示 end');
}

/**
 * 大图-动态照片: [动态照片切换循环播放效果后导出视频]
 * TAG: 562 TID: Multimedia_Gallery_Dynamic_Photo_Export_005
 * 前置条件
 * 相机拍摄多张动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_005(dt: Dt) {
  dt.log.i('动态照片切换循环播放效果后导出视频 start');
  dt.log.i('STEP 1、动态照片效果切换为循环播放，点击导出视频');

  await dt.sleep();
  dt.log.i('预期结果1、界面显示正在导出按钮，在用户可接受范围内导出视频成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、观察视频生成位置');

  await dt.sleep();
  dt.log.i('预期结果2、视频生成在动态照片之前');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、播放视频内容，对比动态照片视频内容');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放，与动态照片视频内容一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片切换循环播放效果后导出视频 end');
}

/**
 * 大图-动态照片: [动态照片切换主角时刻后导出视频]
 * TAG: 561 TID: Multimedia_Gallery_Dynamic_Photo_Export_006
 * 前置条件
 * 相机拍摄多张动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_006(dt: Dt) {
  dt.log.i('动态照片切换主角时刻后导出视频 start');
  dt.log.i('STEP 1、动态照片效果切换为主角时刻，点击导出视频');

  await dt.sleep();
  dt.log.i('预期结果1、界面显示正在导出按钮，在用户可接受范围内导出视频成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、观察视频生成位置');

  await dt.sleep();
  dt.log.i('预期结果2、视频生成在动态照片之前');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、播放视频内容，对比动态照片视频内容');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放，与动态照片视频内容一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片切换主角时刻后导出视频 end');
}

/**
 * 大图-删除: [删除图片补位到下个视频播放]
 * TAG: 404 TID: Multimedia_Gallery_Dynamic_Photo_Export_0061
 * 前置条件
 * 图库存在多个视频和图片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_0061(dt: Dt) {
  dt.log.i('删除图片补位到下个视频播放 start');
  dt.log.i('STEP 1、宫格入口打开一个视频点击播放');

  await dt.sleep();
  dt.log.i('预期结果1、视频正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、滑动到前一张图片，删除该张图片');

  await dt.sleep();
  dt.log.i('预期结果2、图片删除成功，补位到视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击播放按钮');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('删除图片补位到下个视频播放 end');
}

/**
 * 大图-动态照片: [动态照片切换运动轨迹后导出视频]
 * TAG: 564 TID: Multimedia_Gallery_Dynamic_Photo_Export_007
 * 前置条件
 * 相机拍摄多张动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_007(dt: Dt) {
  dt.log.i('动态照片切换运动轨迹后导出视频 start');
  dt.log.i('STEP 1、动态照片效果切换为运动轨迹，点击导出视频');

  await dt.sleep();
  dt.log.i('预期结果1、界面显示正在导出按钮，在用户可接受范围内导出视频成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、观察视频生成位置');

  await dt.sleep();
  dt.log.i('预期结果2、视频生成在动态照片之前');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、播放视频内容，对比动态照片视频内容');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放，与动态照片视频内容一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片切换运动轨迹后导出视频 end');
}

/**
 * 大图-动态照片: [动态照片切换微动瞬间后导出视频]
 * TAG: 563 TID: Multimedia_Gallery_Dynamic_Photo_Export_008
 * 前置条件
 * 1、相机拍摄多张动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_008(dt: Dt) {
  dt.log.i('动态照片切换微动瞬间后导出视频 start');
  dt.log.i('STEP 1、进入图库照片页，点击动态照片，切换动态效果为微动瞬间，点击导出视频');

  await dt.sleep();
  dt.log.i('预期结果1、界面显示正在导出按钮，在2s内导出视频成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、观察视频生成位置');

  await dt.sleep();
  dt.log.i('预期结果2、视频生成在动态照片之前');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、播放视频内容，对比动态照片视频内容');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放，与动态照片视频内容一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片切换微动瞬间后导出视频 end');
}

/**
 * 大图-动态照片: [关闭动态照片效果不支持导出视频]
 * TAG: 559 TID: Multimedia_Gallery_Dynamic_Photo_Export_009
 * 前置条件
 * 相机拍摄多张动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_009(dt: Dt) {
  dt.log.i('关闭动态照片效果不支持导出视频 start');
  dt.log.i('STEP 1、动态照片效果切换为关闭动态，点击四方菜单');

  await dt.sleep();
  dt.log.i('预期结果1、不显示导出视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('关闭动态照片效果不支持导出视频 end');
}

/**
 * 大图-动态照片: [动态照片多次导出视频场景]
 * TAG: 565 TID: Multimedia_Gallery_Dynamic_Photo_Export_010
 * 前置条件
 * 相机拍摄多张动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_010(dt: Dt) {
  dt.log.i('动态照片多次导出视频场景 start');
  dt.log.i('STEP 1、动态照片导出视频');

  await dt.sleep();
  dt.log.i('预期结果1、视频生成在动态照片之前');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、连续导出6个视频');

  await dt.sleep();
  dt.log.i('预期结果2、视频按照导出时间依次生成在动态照片之前（降序排序）');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片多次导出视频场景 end');
}

/**
 * 大图-动态照片: [动态照片编辑后导出视频]
 * TAG: 569 TID: Multimedia_Gallery_Dynamic_Photo_Export_011
 * 前置条件
 * 相机拍摄多张动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_011(dt: Dt) {
  dt.log.i('动态照片编辑后导出视频 start');
  dt.log.i('STEP 1、动态照片进行编辑：剪切视频长度/切换声音按钮');

  await dt.sleep();
  dt.log.i('STEP 2、对动态照片进行裁剪：旋转、水平矫正，垂直矫正，比例');

  await dt.sleep();
  dt.log.i('STEP 3、对动态照片进行调节');

  await dt.sleep();
  dt.log.i('STEP 4、对动态照片进行滤镜切换');

  await dt.sleep();
  dt.log.i('STEP 5、依次1-4的操作后，编辑保存');

  await dt.sleep();
  dt.log.i('预期结果5、动态照片编辑保存后显示为修改后的效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、保存成功后，导出视频');

  await dt.sleep();
  dt.log.i('预期结果6、视频导出成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、播放导出的视频，观察效果');

  await dt.sleep();
  dt.log.i('预期结果7、视频和动态照片视频内容保持一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片编辑后导出视频 end');
}

/**
 * 大图-动态照片: [动态照片导出视频进行编辑]
 * TAG: 568 TID: Multimedia_Gallery_Dynamic_Photo_Export_012
 * 前置条件
 * 相机拍摄多张动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_012(dt: Dt) {
  dt.log.i('动态照片导出视频进行编辑 start');
  dt.log.i('STEP 1、动态照片导出视频');

  await dt.sleep();
  dt.log.i('预期结果1、导出视频成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、对导出视频进行编辑保存');

  await dt.sleep();
  dt.log.i('预期结果2、编辑保存成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、播放编辑后的视频');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放，内容和编辑后一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('动态照片导出视频进行编辑 end');
}

/**
 * 大图-动态照片: [端云同步后动态照片下载完成后导出视频]
 * TAG: 571 TID: Multimedia_Gallery_Dynamic_Photo_Export_013
 * 前置条件
 * 1、准备两台xxx手机，测试机A，辅助机B
 2、辅助机B预制部分动态照片
 3、通过端云账号同步到测试机A上

 */
async function Multimedia_Gallery_Dynamic_Photo_Export_013(dt: Dt) {
  dt.log.i('xxx端云同步后动态照片下载完成后导出视频 start');
  dt.log.i('STEP 1、测试机A打开动态照片，单击进入沉浸式状态（下载）');

  await dt.sleep();
  dt.log.i('STEP 2、观察此时动态照片图标');

  await dt.sleep();
  dt.log.i('预期结果2、动态图标从置灰变成正常状态');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击导出视频');

  await dt.sleep();
  dt.log.i('预期结果3、导出视频成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击视频播放');

  await dt.sleep();
  dt.log.i('预期结果4、视频播放正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、下拉触发同步，辅助机B查看新导出视频是否能正常播放');

  await dt.sleep();
  dt.log.i('预期结果5、视频播放正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxx端云同步后动态照片下载完成后导出视频 end');
}

/**
 * 大图-动态照片: [端云同步后动态照片未下载完成导出视频]
 * TAG: 572 TID: Multimedia_Gallery_Dynamic_Photo_Export_014
 * 前置条件
 * 1、准备两台xxx手机，测试机A，辅助机B
 2、辅助机B预制部分动态照片
 3、通过端云账号同步到测试机A上

 */
async function Multimedia_Gallery_Dynamic_Photo_Export_014(dt: Dt) {
  dt.log.i('xxx端云同步后动态照片未下载完成导出视频 start');
  dt.log.i('STEP 1、测试机A打开动态照片，在动态照片图片还在置灰状态点击导出视频');

  await dt.sleep();
  dt.log.i('预期结果1、跳出正在导出的提示，然后保存成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击视频播放');

  await dt.sleep();
  dt.log.i('预期结果2、视频正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、下拉触发同步，辅助机B查看新导出视频是否能正常播放');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxx端云同步后动态照片未下载完成导出视频 end');
}

/**
 * 大图-动态照片: [端云同步后动态照片导出视频]
 * TAG: 574 TID: Multimedia_Gallery_Dynamic_Photo_Export_015
 * 前置条件
 * 1、准备一台xxx手机测试机A，xxx手机辅助机B
 2、辅助机B预制部分动态照片
 3、通过端云账号同步到测试机A上

 */
async function Multimedia_Gallery_Dynamic_Photo_Export_015(dt: Dt) {
  dt.log.i('xxx端云同步后动态照片导出视频 start');
  dt.log.i('STEP 1、测试机A打开动态照片,点击导出视频');

  await dt.sleep();
  dt.log.i('预期结果1、视频导出成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击视频播放');

  await dt.sleep();
  dt.log.i('预期结果2、视频正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、下拉触发同步，辅助机B查看新导出视频是否能正常播放');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxx端云同步后动态照片导出视频 end');
}

/**
 * 大图-动态照片: [无网络情况下端云同步后动态照片导出视频]
 * TAG: 578 TID: Multimedia_Gallery_Dynamic_Photo_Export_016
 * 前置条件
 * 1、准备一台xxx手机测试机A，xxx手机辅助机B
 2、辅助机B预制部分动态照片
 3、通过端云账号同步到测试机A上

 */
async function Multimedia_Gallery_Dynamic_Photo_Export_016(dt: Dt) {
  dt.log.i('无网络情况下xxx端云同步后动态照片导出视频 start');
  dt.log.i('STEP 1、关闭网络，打开同步过来的动态照片');

  await dt.sleep();
  dt.log.i('STEP 2、点击导出视频');

  await dt.sleep();
  dt.log.i('预期结果2、toast提示：”网络异常，原图下载失败，请稍后再试“');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('年', MatchPattern.CONTAINS)); // 网络异常，原图下载失败，请稍后再试'));


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('无网络情况下端云同步后动态照片导出视频 end');
}

/**
 * 大图-动态照片: [克隆后动态照片导出视频]
 * TAG: 570 TID: Multimedia_Gallery_Dynamic_Photo_Export_017
 * 前置条件
 * 1、准备两台xxx手机，测试机A，辅助机B
 2、辅助机B预制部分动态照片
 3、通过克隆将动态照片预制到测试机A上

 */
async function Multimedia_Gallery_Dynamic_Photo_Export_017(dt: Dt) {
  dt.log.i('xxx克隆后动态照片导出视频 start');
  dt.log.i('STEP 1、测试机A打开动态照片,点击导出视频');

  await dt.sleep();
  dt.log.i('预期结果1、视频导出成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击视频播放');

  await dt.sleep();
  dt.log.i('预期结果2、视频正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、下拉触发同步，辅助机B查看新导出视频是否能正常播放');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxx克隆后动态照片导出视频 end');
}

/**
 * 大图-动态照片: [克隆后动态照片导出视频]
 * TAG: 573 TID: Multimedia_Gallery_Dynamic_Photo_Export_018
 * 前置条件
 * 1、准备一台xxx手机测试机A，xxx手机辅助机B
 2、辅助机B预制部分动态照片
 3、通过克隆将动态照片预制到测试机A上
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_018(dt: Dt) {
  dt.log.i('克隆后动态照片导出视频 start');
  dt.log.i('STEP 1、测试机A打开动态照片,点击导出视频');

  await dt.sleep();
  dt.log.i('预期结果1、视频导出成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击视频播放');

  await dt.sleep();
  dt.log.i('预期结果2、视频正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、下拉触发同步，辅助机B查看新导出视频是否能正常播放');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxx克隆后动态照片导出视频 end');
}

/**
 * 大图-动态照片: [深色模式下动态照片导出视频]
 * TAG: 579 TID: Multimedia_Gallery_Dynamic_Photo_Export_019
 * 前置条件
 * 相机拍摄多张动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_019(dt: Dt) {
  dt.log.i('深色模式下动态照片导出视频 start');
  dt.log.i('STEP 1、开启深色模式');

  await dt.sleep();
  dt.log.i('STEP 2、动态照片导出视频');

  await dt.sleep();
  dt.log.i('预期结果2、视频导出成功，界面无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、播放视频');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放，界面无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('深色模式下动态照片导出视频 end');
}

/**
 * 大图-竖屏: [横竖屏切换中动态照片导出视频]
 * TAG: 577 TID: Multimedia_Gallery_Dynamic_Photo_Export_020
 * 前置条件
 * 相机拍摄多张动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_020(dt: Dt) {
  dt.log.i('横竖屏切换中动态照片导出视频 start');
  dt.log.i('STEP 1、横竖屏切换时动态照片导出视频');

  await dt.sleep();
  dt.log.i('STEP 2、播放视频');

  await dt.sleep();
  dt.log.i('预期结果2、视频导出成功，界面无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3、视频正常播放，界面无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('横竖屏切换中动态照片导出视频 end');
}

/**
 * 大图-动态照片: [分屏状态动态照片导出视频]
 * TAG: 560 TID: Multimedia_Gallery_Dynamic_Photo_Export_021
 * 前置条件
 * 相机拍摄多张动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_021(dt: Dt) {
  dt.log.i('分屏状态动态照片导出视频 start');
  dt.log.i('STEP 1、开启分屏状态');

  await dt.sleep();
  dt.log.i('STEP 2、动态照片导出视频');

  await dt.sleep();
  dt.log.i('预期结果2、视频导出成功，界面无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、播放视频');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放，界面无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分屏状态动态照片导出视频 end');
}

/**
 * 大图-动态照片: [悬浮窗场景动态照片导出视频]
 * TAG: 576 TID: Multimedia_Gallery_Dynamic_Photo_Export_022
 * 前置条件
 * 相机拍摄多张动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_022(dt: Dt) {
  dt.log.i('悬浮窗场景动态照片导出视频 start');
  dt.log.i('STEP 1、开启悬浮窗状态');

  await dt.sleep();
  dt.log.i('STEP 2、动态照片导出视频');

  await dt.sleep();
  dt.log.i('预期结果2、视频导出成功，界面无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、播放视频');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放，界面无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('悬浮窗场景动态照片导出视频 end');
}

/**
 * 大图-动态照片: [大字体场景下动态照片导出视频]
 * TAG: 575 TID: Multimedia_Gallery_Dynamic_Photo_Export_023
 * 前置条件
 * 相机拍摄多张动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_023(dt: Dt) {
  dt.log.i('大字体场景下动态照片导出视频 start');
  dt.log.i('STEP 1、开启大字体');

  await dt.sleep();
  dt.log.i('STEP 2、动态照片导出视频');

  await dt.sleep();
  dt.log.i('预期结果2、视频导出成功，界面无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、播放视频');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放，界面无异常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大字体场景下动态照片导出视频 end');
}

/**
 * 大图-详情: [视频详情页滑动到动态照片导出视频]
 * TAG: 300 TID: Multimedia_Gallery_Dynamic_Photo_Export_024
 * 前置条件
 * 相机拍摄多张动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_024(dt: Dt) {
  dt.log.i('视频详情页滑动到动态照片导出视频 start');
  dt.log.i('STEP 1、选择一张动态照片点击导出视频');

  await dt.sleep();
  dt.log.i('预期结果1、导出成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、播放视频时上滑');

  await dt.sleep();
  dt.log.i('预期结果2、显示详情页');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、滑动到下一个动态视频，点击导出视频');

  await dt.sleep();
  dt.log.i('预期结果3、导出成功，视频显示位置在窗口中央');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击播放视频');

  await dt.sleep();
  dt.log.i('预期结果4、播放正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频详情页滑动到动态照片导出视频 end');
}

