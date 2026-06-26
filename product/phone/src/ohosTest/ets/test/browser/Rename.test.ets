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

export default function RenameTest(): void {
  describe('RenameTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    // 确认当前图库app处于启动状态
    beforeAll(async (): Promise<void> => {
      // 进入图库
      await AppStart.photos()
    });
    // DT声明
    run('beforeRenameTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      // 打开大图
      await dt.browser();
    });

    // DT声明
    run('Multimedia_Gallery_Rename_001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [重命名入口检查] TID: Multimedia_Gallery_Rename_001
      await Multimedia_Gallery_Rename_001(dt);
    });
    run('Multimedia_Gallery_Rename_002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [图库入口-检查重命名弹窗中名称和详情中资源名称] TID: Multimedia_Gallery_Rename_002
      await Multimedia_Gallery_Rename_002(dt);
    });
    run('Multimedia_Gallery_Rename_003', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [图库入口-重命名支持无障碍模式] TID: Multimedia_Gallery_Rename_003
      await Multimedia_Gallery_Rename_003(dt);
    });
    run('Multimedia_Gallery_Rename_004', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [图库入口-取消重命名] TID: Multimedia_Gallery_Rename_004
      await Multimedia_Gallery_Rename_004(dt);
    });
    run('Multimedia_Gallery_Rename_005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [图库入口-空内容重命名] TID: Multimedia_Gallery_Rename_005
      await Multimedia_Gallery_Rename_005(dt);
    });
    run('Multimedia_Gallery_Rename_006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [图库入口-合法字符重命名] TID: Multimedia_Gallery_Rename_006
      await Multimedia_Gallery_Rename_006(dt);
    });
    run('Multimedia_Gallery_Rename_007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [图库入口-过长字符重命名] TID: Multimedia_Gallery_Rename_007
      await Multimedia_Gallery_Rename_007(dt);
    });
    run('Multimedia_Gallery_Rename_008', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [图库入口-非法字符重命名] TID: Multimedia_Gallery_Rename_008
      await Multimedia_Gallery_Rename_008(dt);
    });
    run('Multimedia_Gallery_Rename_009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [图库入口-上划查看详情的重命名对比] TID: Multimedia_Gallery_Rename_009
      await Multimedia_Gallery_Rename_009(dt);
    });
    run('Multimedia_Gallery_Rename_010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [相机入口-检查重命名弹窗中名称和详情中资源名称] TID: Multimedia_Gallery_Rename_010
      await Multimedia_Gallery_Rename_010(dt);
    });
    run('Multimedia_Gallery_Rename_011', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [相机入口-重命名支持无障碍模式] TID: Multimedia_Gallery_Rename_011
      await Multimedia_Gallery_Rename_011(dt);
    });
    run('Multimedia_Gallery_Rename_012', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [相机入口-取消重命名] TID: Multimedia_Gallery_Rename_012
      await Multimedia_Gallery_Rename_012(dt);
    });
    run('Multimedia_Gallery_Rename_013', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [相机入口-空内容重命名] TID: Multimedia_Gallery_Rename_013
      await Multimedia_Gallery_Rename_013(dt);
    });
    run('Multimedia_Gallery_Rename_014', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [相机入口-合法字符重命名] TID: Multimedia_Gallery_Rename_014
      await Multimedia_Gallery_Rename_014(dt);
    });
    run('Multimedia_Gallery_Rename_015', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [相机入口-过长字符重命名] TID: Multimedia_Gallery_Rename_015
      await Multimedia_Gallery_Rename_015(dt);
    });
    run('Multimedia_Gallery_Rename_016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [相机入口-非法字符重命名] TID: Multimedia_Gallery_Rename_016
      await Multimedia_Gallery_Rename_016(dt);
    });
    run('Multimedia_Gallery_Rename_017', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [相机入口-上划查看详情的重命名对比] TID: Multimedia_Gallery_Rename_017
      await Multimedia_Gallery_Rename_017(dt);
    });
    run('Multimedia_Gallery_Rename_018', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [云图上下行-检查重命名弹窗中名称和详情中资源名称] TID: Multimedia_Gallery_Rename_018
      await Multimedia_Gallery_Rename_018(dt);
    });
    run('Multimedia_Gallery_Rename_019', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [云图上下行-重命名支持无障碍模式] TID: Multimedia_Gallery_Rename_019
      await Multimedia_Gallery_Rename_019(dt);
    });
    run('Multimedia_Gallery_Rename_020', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [云图上下行-取消重命名] TID: Multimedia_Gallery_Rename_020
      await Multimedia_Gallery_Rename_020(dt);
    });
    run('Multimedia_Gallery_Rename_021', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [云图上下行-空内容重命名] TID: Multimedia_Gallery_Rename_021
      await Multimedia_Gallery_Rename_021(dt);
    });
    run('Multimedia_Gallery_Rename_022', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [云图上下行-合法字符重命名] TID: Multimedia_Gallery_Rename_022
      await Multimedia_Gallery_Rename_022(dt);
    });
    run('Multimedia_Gallery_Rename_023', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [云图上下行-过长字符重命名] TID: Multimedia_Gallery_Rename_023
      await Multimedia_Gallery_Rename_023(dt);
    });
    run('Multimedia_Gallery_Rename_024', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [云图上下行-非法字符重命名] TID: Multimedia_Gallery_Rename_024
      await Multimedia_Gallery_Rename_024(dt);
    });
    run('Multimedia_Gallery_Rename_025', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [云图上下行-上划查看详情的重命名对比] TID: Multimedia_Gallery_Rename_025
      await Multimedia_Gallery_Rename_025(dt);
    });
    run('Multimedia_Gallery_Rename_026', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [相机入口-相机入口-点击重命名，进入其他应用（备忘录等）返回] TID: Multimedia_Gallery_Rename_026
      await Multimedia_Gallery_Rename_026(dt);
    });


    // 退出大图 回到年月日视图
    afterAll(async (): Promise<void> => await Exit.browser());
    // 确保每次测试完毕回到大图页
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEach RenameTest').init();
      dt.log.i('afterEach RenameTest test');
      dt.log.i('afterEach RenameTest test finish');
    });
  });
}

// DT步骤
/**
 * 大图-删除: [重命名入口检查]
 * TAG: 716 TID: Multimedia_Gallery_Rename_001
 * 前置条件
 * 1、图库存在照片/视频
 */
async function Multimedia_Gallery_Rename_001(dt: Dt) {
  dt.log.i('重命名入口检查 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页（非最近删除）进入图片/视频宫格页面，点击图片/视频，点击右上角更多-检查是否存在重命名按钮');

  await dt.sleep();
  dt.log.i('预期结果2、更多中出现重命名弹窗，位置在详细信息上一个');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('重命名入口检查 end');
}

/**
 * 大图-详情: [图库入口-检查重命名弹窗中名称和详情中资源名称]
 * TAG: 718 TID: Multimedia_Gallery_Rename_002
 * 前置条件
 * 1、图库存在照片/视频
 */
async function Multimedia_Gallery_Rename_002(dt: Dt) {
  dt.log.i('图库入口-检查重命名弹窗中名称和详情中资源名称 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页（非最近删除）进入图片/视频宫格页面，点击图片/视频，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗，弹窗中的资源名称跟详情中的资源名称一致。');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，点击图片/视频，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果3、均出现重命名弹窗，弹窗中的资源名称跟详情中的资源名称一致。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库入口-检查重命名弹窗中名称和详情中资源名称 end');
}

/**
 * 大图-视频: [图库入口-重命名支持无障碍模式]
 * TAG: 715 TID: Multimedia_Gallery_Rename_003
 * 前置条件
 * 1、图库存在照片/视频
 */
async function Multimedia_Gallery_Rename_003(dt: Dt) {
  dt.log.i('图库入口-重命名支持无障碍模式 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库入口-重命名支持无障碍模式 end');
}

/**
 * 大图-竖屏: [图库入口-取消重命名]
 * TAG: 712 TID: Multimedia_Gallery_Rename_004
 * 前置条件
 * 1、图库存在照片/视频
 */
async function Multimedia_Gallery_Rename_004(dt: Dt) {
  dt.log.i('图库入口-取消重命名 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页（非最近删除）进入图片/视频宫格页面，点击图片/视频，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重命名弹窗的，取消按钮');

  await dt.sleep();
  dt.log.i('预期结果3、重命名弹窗消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，点击图片/视频，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果4、重命名弹窗均消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库入口-取消重命名 end');
}

/**
 * 大图-竖屏: [图库入口-空内容重命名]
 * TAG: 714 TID: Multimedia_Gallery_Rename_005
 * 前置条件
 * 1、图库存在照片/视频
 */
async function Multimedia_Gallery_Rename_005(dt: Dt) {
  dt.log.i('图库入口-空内容重命名 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页（非最近删除）进入图片/视频宫格页面，点击图片/视频，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重命名弹窗的，将内容置空，点击保存按钮');

  await dt.sleep();
  dt.log.i('预期结果3、出现“请输入名称”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('请输入名称', true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，将重命名弹窗中内容置空，点击保存按钮');

  await dt.sleep();
  dt.log.i('预期结果4、均出现“请输入名称”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('请输入名称', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库入口-空内容重命名 end');
}

/**
 * 大图-竖屏: [图库入口-合法字符重命名]
 * TAG: 713 TID: Multimedia_Gallery_Rename_006
 * 前置条件
 * 1、图库存在照片/视频
 */
async function Multimedia_Gallery_Rename_006(dt: Dt) {
  dt.log.i('图库入口-合法字符重命名 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页（非最近删除）进入图片/视频宫格页面，点击图片/视频，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重命名弹窗的，输入1-82位合法字符及其组合（中/英/数字/字母等非英文下的特殊字符 `  . \ / : * ? < > | [ ] { }），点击保存按钮');

  await dt.sleep();
  dt.log.i('预期结果3、重命名成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，输入合法字符重命名');

  await dt.sleep();
  dt.log.i('预期结果4、均重命名成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库入口-合法字符重命名 end');
}

/**
 * 大图-竖屏: [图库入口-过长字符重命名]
 * TAG: 709 TID: Multimedia_Gallery_Rename_007
 * 前置条件
 * 1、图库存在照片/视频
 */
async function Multimedia_Gallery_Rename_007(dt: Dt) {
  dt.log.i('图库入口-过长字符重命名 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页（非最近删除）进入图片/视频宫格页面，点击图片/视频，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重命名弹窗的，输入大于82位合法字符及其组合（中/英/数字/字母等非英文下的特殊字符 `  . \ / : * ? < > | [ ] { }）');

  await dt.sleep();
  dt.log.i('预期结果3、提示“已达长度上限”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已达长度上限', true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，输入大于82位的合法字符重命名');

  await dt.sleep();
  dt.log.i('预期结果4、提示“已达长度上限”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已达长度上限', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库入口-过长字符重命名 end');
}

/**
 * 大图-竖屏: [图库入口-非法字符重命名]
 * TAG: 717 TID: Multimedia_Gallery_Rename_008
 * 前置条件
 * 1、图库存在照片/视频
 */
async function Multimedia_Gallery_Rename_008(dt: Dt) {
  dt.log.i('图库入口-非法字符重命名 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页（非最近删除）进入图片/视频宫格页面，点击图片/视频，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重命名弹窗的，输入英文状态下的特殊字符 `  . \ / : * ? < > | [ ] { }）');

  await dt.sleep();
  dt.log.i('预期结果3、提示“不支持 ` ” . \ / : * ? < > | [ ] { }”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('不支持', true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，输入非法字符');

  await dt.sleep();
  dt.log.i('预期结果4、提示提示“不支持 ` ” . \ / : * ? < > | [ ] { }”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('不支持', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库入口-非法字符重命名 end');
}

/**
 * 大图-详情: [图库入口-上划查看详情的重命名对比]
 * TAG: 710 TID: Multimedia_Gallery_Rename_009
 * 前置条件
 * 1、图库存在照片/视频
 */
async function Multimedia_Gallery_Rename_009(dt: Dt) {
  dt.log.i('图库入口-上划查看详情的重命名对比 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页（非最近删除）进入图片/视频宫格页面，点击图片/视频，上划看大图详情，重命名后下滑');

  await dt.sleep();
  dt.log.i('预期结果2、重命名成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重命名弹窗的，检查重命名弹窗中内容是否已输入的一致');

  await dt.sleep();
  dt.log.i('预期结果3、弹窗中内容与修改的一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，上划查看详情重命名');

  await dt.sleep();
  dt.log.i('预期结果4、弹窗中内容与修改的一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库入口-上划查看详情的重命名对比 end');
}

/**
 * 大图-详情: [相机入口-检查重命名弹窗中名称和详情中资源名称]
 * TAG: 711 TID: Multimedia_Gallery_Rename_010
 * 前置条件
 * 1、相机拍摄照片/视频
 */
async function Multimedia_Gallery_Rename_010(dt: Dt) {
  dt.log.i('相机入口-检查重命名弹窗中名称和详情中资源名称 start');
  dt.log.i('STEP 1、点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果1、查看大图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入图片/视频大图页面，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗，弹窗中的资源名称跟详情中的资源名称一致');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，点击图片/视频，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果3、均出现重命名弹窗，弹窗中的资源名称跟详情中的资源名称一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机入口-检查重命名弹窗中名称和详情中资源名称 end');
}

/**
 * 大图-视频: [相机入口-重命名支持无障碍模式]
 * TAG: 723 TID: Multimedia_Gallery_Rename_011
 * 前置条件
 * 1、相机拍摄照片/视频
 */
async function Multimedia_Gallery_Rename_011(dt: Dt) {
  dt.log.i('相机入口-重命名支持无障碍模式 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机入口-重命名支持无障碍模式 end');
}

/**
 * 大图-竖屏: [相机入口-取消重命名]
 * TAG: 721 TID: Multimedia_Gallery_Rename_012
 * 前置条件
 * 1、相机拍摄照片/视频
 */
async function Multimedia_Gallery_Rename_012(dt: Dt) {
  dt.log.i('相机入口-取消重命名 start');
  dt.log.i('STEP 1、点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果1、查看大图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入图片/视频宫格大图页面，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击取消重命名');

  await dt.sleep();
  dt.log.i('预期结果3、重命名弹窗消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，取消重命名');

  await dt.sleep();
  dt.log.i('预期结果4、重命名弹窗均消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机入口-取消重命名 end');
}

/**
 * 大图-竖屏: [相机入口-空内容重命名]
 * TAG: 719 TID: Multimedia_Gallery_Rename_013
 * 前置条件
 * 1、相机拍摄照片/视频
 */
async function Multimedia_Gallery_Rename_013(dt: Dt) {
  dt.log.i('相机入口-空内容重命名 start');
  dt.log.i('STEP 1、点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果1、查看大图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入图片/视频大图页面，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、内容置空，点击保存');

  await dt.sleep();
  dt.log.i('预期结果3、出现“请输入名称”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('请输入名称', true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，内容置空，点击保存');

  await dt.sleep();
  dt.log.i('预期结果4、均出现“请输入名称”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('请输入名称', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机入口-空内容重命名 end');
}

/**
 * 大图-竖屏: [相机入口-合法字符重命名]
 * TAG: 722 TID: Multimedia_Gallery_Rename_014
 * 前置条件
 * 1、相机拍摄照片/视频
 */
async function Multimedia_Gallery_Rename_014(dt: Dt) {
  dt.log.i('相机入口-合法字符重命名 start');
  dt.log.i('STEP 1、点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果1、查看大图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入图片/视频大图页面，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重命名弹窗的，输入1-82位合法字符及其组合（中/英/数字/字母等非英文下的特殊字符 `  . \ / : * ? < > | [ ] { }），点击保存按钮');

  await dt.sleep();
  dt.log.i('预期结果3、重命名成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，输入合法字符重命名');

  await dt.sleep();
  dt.log.i('预期结果4、均重命名成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机入口-合法字符重命名 end');
}

/**
 * 大图-竖屏: [相机入口-过长字符重命名]
 * TAG: 724 TID: Multimedia_Gallery_Rename_015
 * 前置条件
 * 1、相机拍摄照片/视频
 */
async function Multimedia_Gallery_Rename_015(dt: Dt) {
  dt.log.i('相机入口-过长字符重命名 start');
  dt.log.i('STEP 1、点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果1、查看大图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入图片/视频大图页面，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重命名弹窗的，输入大于82位合法字符及其组合（中/英/数字/字母等非英文下的特殊字符 `  . \ / : * ? < > | [ ] { }）');

  await dt.sleep();
  dt.log.i('预期结果3、提示“已达长度上限”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已达长度上限', true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，输入大于82位的合法字符重命名');

  await dt.sleep();
  dt.log.i('预期结果4、提示“已达长度上限”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已达长度上限', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机入口-过长字符重命名 end');
}

/**
 * 大图-竖屏: [相机入口-非法字符重命名]
 * TAG: 720 TID: Multimedia_Gallery_Rename_016
 * 前置条件
 * 1、相机拍摄照片/视频
 */
async function Multimedia_Gallery_Rename_016(dt: Dt) {
  dt.log.i('相机入口-非法字符重命名 start');
  dt.log.i('STEP 1、点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果1、查看大图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入图片/视频大图页面，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重命名弹窗的，输入英文状态下的特殊字符 `  . \ / : * ? < > | [ ] { }）');

  await dt.sleep();
  dt.log.i('预期结果3、提示“不支持 ` ” . \ / : * ? < > | [ ] { }”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('不支持', true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，输入非法字符');

  await dt.sleep();
  dt.log.i('预期结果4、提示提示“不支持 ` ” . \ / : * ? < > | [ ] { }”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('不支持', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机入口-非法字符重命名 end');
}

/**
 * 大图-详情: [相机入口-上划查看详情的重命名对比]
 * TAG: 727 TID: Multimedia_Gallery_Rename_017
 * 前置条件
 * 1、相机拍摄照片/视频
 */
async function Multimedia_Gallery_Rename_017(dt: Dt) {
  dt.log.i('相机入口-上划查看详情的重命名对比 start');
  dt.log.i('STEP 1、点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果1、查看大图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入图片/视频大图页面，上划看大图详情，重命名后下滑');

  await dt.sleep();
  dt.log.i('预期结果2、重命名成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重命名弹窗的，检查重命名弹窗中内容是否已输入的一致');

  await dt.sleep();
  dt.log.i('预期结果3、弹窗中内容与修改的一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，上划查看详情重命名');

  await dt.sleep();
  dt.log.i('预期结果4、弹窗中内容与修改的一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机入口-上划查看详情的重命名对比 end');
}

/**
 * 大图-详情: [云图上下行-检查重命名弹窗中名称和详情中资源名称]
 * TAG: 729 TID: Multimedia_Gallery_Rename_018
 * 前置条件
 * 1、图库存在照片/视频
 2、图库在云同步过程中
 */
async function Multimedia_Gallery_Rename_018(dt: Dt) {
  dt.log.i('云图上下行-检查重命名弹窗中名称和详情中资源名称 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页（非最近删除）进入图片/视频宫格页面，点击图片/视频，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗，弹窗中的资源名称跟详情中的资源名称一致。');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，点击图片/视频，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果3、均出现重命名弹窗，弹窗中的资源名称跟详情中的资源名称一致。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云图上下行-检查重命名弹窗中名称和详情中资源名称 end');
}

/**
 * 大图-视频: [云图上下行-重命名支持无障碍模式]
 * TAG: 725 TID: Multimedia_Gallery_Rename_019
 * 前置条件
 * 1、图库存在照片/视频
 2、图库在云同步过程中
 */
async function Multimedia_Gallery_Rename_019(dt: Dt) {
  dt.log.i('云图上下行-重命名支持无障碍模式 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云图上下行-重命名支持无障碍模式 end');
}

/**
 * 大图-竖屏: [云图上下行-取消重命名]
 * TAG: 726 TID: Multimedia_Gallery_Rename_020
 * 前置条件
 * 1、图库存在照片/视频
 2、图库在云同步过程中
 */
async function Multimedia_Gallery_Rename_020(dt: Dt) {
  dt.log.i('云图上下行-取消重命名 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页（非最近删除）进入图片/视频宫格页面，点击图片/视频，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重命名弹窗的，取消按钮');

  await dt.sleep();
  dt.log.i('预期结果3、重命名弹窗消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，点击图片/视频，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果4、重命名弹窗均消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云图上下行-取消重命名 end');
}

/**
 * 大图-竖屏: [云图上下行-空内容重命名]
 * TAG: 728 TID: Multimedia_Gallery_Rename_021
 * 前置条件
 * 1、图库存在照片/视频
 2、图库在云同步过程中
 */
async function Multimedia_Gallery_Rename_021(dt: Dt) {
  dt.log.i('云图上下行-空内容重命名 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页（非最近删除）进入图片/视频宫格页面，点击图片/视频，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重命名弹窗的，将内容置空，点击保存按钮');

  await dt.sleep();
  dt.log.i('预期结果3、出现“请输入名称”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('请输入名称', true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，将重命名弹窗中内容置空，点击保存按钮');

  await dt.sleep();
  dt.log.i('预期结果4、均出现“请输入名称”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('请输入名称', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云图上下行-空内容重命名 end');
}

/**
 * 大图-竖屏: [云图上下行-合法字符重命名]
 * TAG: 730 TID: Multimedia_Gallery_Rename_022
 * 前置条件
 * 1、图库存在照片/视频
 2、图库在云同步过程中
 */
async function Multimedia_Gallery_Rename_022(dt: Dt) {
  dt.log.i('云图上下行-合法字符重命名 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页（非最近删除）进入图片/视频宫格页面，点击图片/视频，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重命名弹窗的，输入1-82位合法字符及其组合（中/英/数字/字母等非英文下的特殊字符 `  . \ / : * ? < > | [ ] { }），点击保存按钮');

  await dt.sleep();
  dt.log.i('预期结果3、重命名成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，输入合法字符重命名');

  await dt.sleep();
  dt.log.i('预期结果4、均重命名成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云图上下行-合法字符重命名 end');
}

/**
 * 大图-竖屏: [云图上下行-过长字符重命名]
 * TAG: 731 TID: Multimedia_Gallery_Rename_023
 * 前置条件
 * 1、图库存在照片/视频
 2、图库在云同步过程中
 */
async function Multimedia_Gallery_Rename_023(dt: Dt) {
  dt.log.i('云图上下行-过长字符重命名 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页（非最近删除）进入图片/视频宫格页面，点击图片/视频，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重命名弹窗的，输入大于82位合法字符及其组合（中/英/数字/字母等非英文下的特殊字符 `  . \ / : * ? < > | [ ] { }）');

  await dt.sleep();
  dt.log.i('预期结果3、提示“已达长度上限”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已达长度上限', true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，输入大于82位的合法字符重命名');

  await dt.sleep();
  dt.log.i('预期结果4、提示“已达长度上限”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('已达长度上限', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云图上下行-过长字符重命名 end');
}

/**
 * 大图-竖屏: [云图上下行-非法字符重命名]
 * TAG: 732 TID: Multimedia_Gallery_Rename_024
 * 前置条件
 * 1、图库存在照片/视频
 2、图库在云同步过程中
 */
async function Multimedia_Gallery_Rename_024(dt: Dt) {
  dt.log.i('云图上下行-非法字符重命名 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页（非最近删除）进入图片/视频宫格页面，点击图片/视频，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重命名弹窗的，输入英文状态下的特殊字符 `  . \ / : * ? < > | [ ] { }）');

  await dt.sleep();
  dt.log.i('预期结果3、提示“不支持 ` ” . \ / : * ? < > | [ ] { }”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('不支持', true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，输入非法字符');

  await dt.sleep();
  dt.log.i('预期结果4、提示提示“不支持 ` ” . \ / : * ? < > | [ ] { }”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('不支持', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云图上下行-非法字符重命名 end');
}

/**
 * 大图-详情: [云图上下行-上划查看详情的重命名对比]
 * TAG: 733 TID: Multimedia_Gallery_Rename_025
 * 前置条件
 * 1、图库存在照片/视频
 2、图库在云同步过程中
 */
async function Multimedia_Gallery_Rename_025(dt: Dt) {
  dt.log.i('云图上下行-上划查看详情的重命名对比 start');
  dt.log.i('STEP 1、点击图库应用');

  await dt.sleep();
  dt.log.i('预期结果1、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片页/相册页（非最近删除）进入图片/视频宫格页面，点击图片/视频，上划看大图详情，重命名后下滑');

  await dt.sleep();
  dt.log.i('预期结果2、重命名成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重命名弹窗的，检查重命名弹窗中内容是否已输入的一致');

  await dt.sleep();
  dt.log.i('预期结果3、弹窗中内容与修改的一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，上划查看详情重命名');

  await dt.sleep();
  dt.log.i('预期结果4、弹窗中内容与修改的一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云图上下行-上划查看详情的重命名对比 end');
}

/**
 * 大图-竖屏: [相机入口-相机入口-点击重命名，进入其他应用（备忘录等）返回]
 * TAG: 734 TID: Multimedia_Gallery_Rename_026
 * 前置条件
 * 1、图库存在照片/视频
 */
async function Multimedia_Gallery_Rename_026(dt: Dt) {
  dt.log.i('相机入口-相机入口-点击重命名，进入其他应用（备忘录等）返回 start');
  dt.log.i('STEP 1、点击左下角缩略图');

  await dt.sleep();
  dt.log.i('预期结果1、查看大图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入图片/视频大图页面，点击右上角更多-重命名');

  await dt.sleep();
  dt.log.i('预期结果2、出现重命名弹窗');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击重命名弹窗的，进入其他应用（备忘录等）返回，观察重命名弹窗显示，后输入1-82位合法字符及其组合（中/英/数字/字母等非英文下的特殊字符 `  . \ / : * ? < > | [ ] { }），点击保存按钮');

  await dt.sleep();
  dt.log.i('预期结果3、进入其他应用返回后，重命名弹窗正常展示，输入合法字符后，重命名成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、横竖屏、分屏、悬浮窗、大字体，多设备（手机/平板/xxx），隐私空间，输入合法字符重命名');

  await dt.sleep();
  dt.log.i('预期结果4、均重命名成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机入口-相机入口-点击重命名，进入其他应用（备忘录等）返回 end');
}

