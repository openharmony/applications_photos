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

import { afterAll, afterEach, beforeAll, describe, Level } from '@ohos/hypium';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
// 补充完成后修改为 run as it
import { run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';
import { Component, Driver, MatchPattern, On, ON } from '@ohos.UiTest';

/**
 * 不要使用Log.info, 使用dt.log.i(), 以方便定位当前执行的测试套
 * 每个用例测试完成之后必须回到大图界面
 */
export default function MoireTest(): void {
  describe('MoireTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMoireTest').init();
      dt.log.i('beforeAll MoireTest start');
      dt.log.i('beforeAll MoireTest finish');
    });
    run('Multimedia_Gallery_Moire_002', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-摩尔纹用例: [摩尔纹云图编辑下载后查看] TID: Multimedia_Gallery_Moire_002
      await Multimedia_Gallery_Moire_002(dt);
    });
    run('Multimedia_Gallery_Moire_001', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-摩尔纹用例: [摩尔纹照片编辑保存后查看] TID: Multimedia_Gallery_Moire_001
      await Multimedia_Gallery_Moire_001(dt);
    });
    run('Multimedia_Gallery_Moire_020', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-摩尔纹用例: [摩尔纹照片来源--克隆] TID: Multimedia_Gallery_Moire_020
      await Multimedia_Gallery_Moire_020(dt);
    });
    run('Multimedia_Gallery_Moire_011', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [摩尔纹时间轴界面进入大图左右滑动浏览] TID: Multimedia_Gallery_Moire_011
      await Multimedia_Gallery_Moire_011(dt);
    });
    run('Multimedia_Gallery_Moire_024', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-摩尔纹用例: [摩尔纹照片来源--升级] TID: Multimedia_Gallery_Moire_024
      await Multimedia_Gallery_Moire_024(dt);
    });
    run('Multimedia_Gallery_Moire_010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-摩尔纹用例: [摩尔纹图片大图双指捏合放大缩小] TID: Multimedia_Gallery_Moire_010
      await Multimedia_Gallery_Moire_010(dt);
    });
    run('Multimedia_Gallery_Moire_025', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-摩尔纹用例: [摩尔纹悬浮窗] TID: Multimedia_Gallery_Moire_025
      await Multimedia_Gallery_Moire_025(dt);
    });
    run('Multimedia_Gallery_Moire_016', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-摩尔纹用例: [摩尔纹大图编辑] TID: Multimedia_Gallery_Moire_016
      await Multimedia_Gallery_Moire_016(dt);
    });
    run('Multimedia_Gallery_Moire_018', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-摩尔纹用例: [摩尔纹三方picker页] TID: Multimedia_Gallery_Moire_018
      await Multimedia_Gallery_Moire_018(dt);
    });
    run('Multimedia_Gallery_Moire_015', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [摩尔纹不同宫格入口进入大图] TID: Multimedia_Gallery_Moire_015
      await Multimedia_Gallery_Moire_015(dt);
    });
    run('Multimedia_Gallery_Moire_009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-摩尔纹用例: [摩尔纹云图编辑下载后查看] TID: Multimedia_Gallery_Moire_009
      await Multimedia_Gallery_Moire_009(dt);
    });
    run('Multimedia_Gallery_Moire_021', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-摩尔纹用例: [摩尔纹照片来源--端云同步] TID: Multimedia_Gallery_Moire_021
      await Multimedia_Gallery_Moire_021(dt);
    });
    run('Multimedia_Gallery_Moire_019', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-摩尔纹用例: [摩尔纹相机进入图库大图] TID: Multimedia_Gallery_Moire_019
      await Multimedia_Gallery_Moire_019(dt);
    });
    run('Multimedia_Gallery_Moire_023', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-摩尔纹用例: [摩尔纹照片来源--隔空投送] TID: Multimedia_Gallery_Moire_023
      await Multimedia_Gallery_Moire_023(dt);
    });
    run('Multimedia_Gallery_Moire_017', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-摩尔纹用例: [摩尔纹视屏封面帧] TID: Multimedia_Gallery_Moire_017
      await Multimedia_Gallery_Moire_017(dt);
    });
    run('Multimedia_Gallery_Moire_022', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-摩尔纹用例: [照片来源--分享] TID: Multimedia_Gallery_Moire_022
      await Multimedia_Gallery_Moire_022(dt);
    });
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMoireTest').init();
      await Exit.browser();
      dt.log.i('afterAll MoireTest finish');
    });
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMoireTest').init();
      dt.log.i('afterEach MoireTest finish');
    });
  });
}

/**
 * 大图-摩尔纹: [摩尔纹云图编辑下载后查看]
 * TAG: 167 TID: Multimedia_Gallery_Moire_002
 * 前置条件
 * 1、图库云上存在摩尔纹资源
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_002(dt: Dt) {
  dt.log.i('摩尔纹云图编辑下载后查看 start');
  dt.log.i('STEP 1、摩尔纹云图大图点击编辑下载');

  await dt.sleep();
  dt.log.i('预期结果1、云图不进行去摩尔纹');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、编辑界面对照片进行双指缩小后返回大图');

  await dt.sleep();
  dt.log.i('预期结果2、大图有去摩尔纹效果');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('摩尔纹云图编辑下载后查看 end');
}

/**
 * 大图-摩尔纹: [摩尔纹照片编辑保存后查看]
 * TAG: 169 TID: Multimedia_Gallery_Moire_001
 * 前置条件
 * 1、图库中存在摩尔纹资源
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_001(dt: Dt) {
  dt.log.i('摩尔纹照片编辑保存后查看 start');
  dt.log.i('STEP 1、时间轴界面打开摩尔纹照片大图');

  await dt.sleep();
  dt.log.i('STEP 2、进入编辑后进行角度旋转、垂直/水平旋转，对照片进行裁剪后保存');

  await dt.sleep();
  dt.log.i('预期结果2、照片保存成功，返回大图时去除摩尔纹');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('摩尔纹照片编辑保存后查看 end');
}

/**
 * 大图-摩尔纹: [摩尔纹照片来源--克隆]
 * TAG: 592 TID: Multimedia_Gallery_Moire_020
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_020(dt: Dt) {
  dt.log.i('摩尔纹照片来源--克隆 start');
  dt.log.i('STEP 1、xxx图库克隆至xxx图库');

  await dt.sleep();
  dt.log.i('预期结果1\2、照片或者视频封面帧有去摩尔纹效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、xxx图库克隆至xxx图库');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('摩尔纹照片来源--克隆 end');
}

/**
 * 大图-进入大图: [摩尔纹时间轴界面进入大图左右滑动浏览]
 * TAG: 594 TID: Multimedia_Gallery_Moire_011
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_011(dt: Dt) {
  dt.log.i('摩尔纹时间轴界面进入大图左右滑动浏览 start');
  dt.log.i('STEP 1、时间轴点击缩略图进入大图');

  await dt.sleep();
  dt.log.i('预期结果1、进入大图丝滑顺畅，图片大图有去摩尔纹效果，在视频封面存在摩尔纹的情况下封面有去摩尔纹效果，最下方依次为分享、收藏、编辑、删除，动态照片有动态照片标识');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、左右滑动查看大图（需要涉及慢滑、快滑、抛滑等场景）');

  await dt.sleep();
  dt.log.i('预期结果2、滑动流畅，无卡顿，无正在加载，照片浏览正常，滑动后图片大图有去摩尔纹效果，在视频封面存在摩尔纹的情况下封面有去摩尔纹效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、调整横竖屏后，继续左右滑动浏览大图（pc仅横屏显示，无需调整横竖屏）');

  await dt.sleep();
  dt.log.i('预期结果3、滑动流畅，无卡顿，无正在加载，照片浏览正常，滑动后图片大图有去摩尔纹效果，在视频封面存在摩尔纹的情况下封面有去摩尔纹效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('摩尔纹时间轴界面进入大图左右滑动浏览 end');
}

/**
 * 大图-摩尔纹: [摩尔纹照片来源--升级]
 * TAG: 595 TID: Multimedia_Gallery_Moire_024
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_024(dt: Dt) {
  dt.log.i('摩尔纹照片来源--升级 start');
  dt.log.i('STEP 1、xxx图库升级至xxx图库');

  await dt.sleep();
  dt.log.i('预期结果1\2、照片或者视频封面帧有去摩尔纹效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、xxx图库升级至xxx图库');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('摩尔纹照片来源--升级 end');
}

/**
 * 大图-摩尔纹: [摩尔纹图片大图双指捏合放大缩小]
 * TAG: 596 TID: Multimedia_Gallery_Moire_010
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_010(dt: Dt) {
  dt.log.i('摩尔纹图片大图双指捏合放大缩小 start');
  dt.log.i('STEP 1、点击所有格式照片缩略图查看大图');

  await dt.sleep();
  dt.log.i('预期结果1、图片大图有去摩尔纹效果，在视频封面存在摩尔纹的情况下封面有去摩尔纹效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、双指捏合放大缩放大图');

  await dt.sleep();
  dt.log.i('预期结果2.1、操作流畅，放大到最大会回弹，界面无异常，符合UX设计2.2、操作流畅，缩小到最小时无法继续缩小， 缩小过程中会触发去摩尔纹流程，界面无异常，符合UX设计');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、横竖屏旋转后重复步骤2');

  await dt.sleep();
  dt.log.i('预期结果3、预期结果与2.1,2.1一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('摩尔纹图片大图双指捏合放大缩小 end');
}

/**
 * 大图-摩尔纹: [摩尔纹悬浮窗]
 * TAG: 597 TID: Multimedia_Gallery_Moire_025
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_025(dt: Dt) {
  dt.log.i('摩尔纹悬浮窗 start');
  dt.log.i('STEP 1、将图片进行悬浮窗操作');

  await dt.sleep();
  dt.log.i('预期结果1\2、照片或者视频封面帧有去摩尔纹效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、将视屏进行悬浮窗操作');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('摩尔纹悬浮窗 end');
}

/**
 * 大图-摩尔纹: [摩尔纹大图编辑]
 * TAG: 598 TID: Multimedia_Gallery_Moire_016
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_016(dt: Dt) {
  dt.log.i('摩尔纹大图编辑 start');
  dt.log.i('STEP 1、摩尔纹大图点击编辑');

  await dt.sleep();
  dt.log.i('STEP 2、编辑界面对照片进行旋转\水平校正\垂直校正\比例\涂鸦操作');

  await dt.sleep();
  dt.log.i('STEP 3、覆盖原照片');

  await dt.sleep();
  dt.log.i('预期结果3、新大图有去摩尔纹');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、另存照片吗');

  await dt.sleep();
  dt.log.i('预期结果4、新大图有去摩尔纹效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('摩尔纹大图编辑 end');
}

/**
 * 大图-摩尔纹: [摩尔纹三方picker页]
 * TAG: 599 TID: Multimedia_Gallery_Moire_018
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_018(dt: Dt) {
  dt.log.i('摩尔纹三方picker页 start');
  dt.log.i('STEP 1、打开联系人\备忘录\邮件');

  await dt.sleep();
  dt.log.i('STEP 2、点击照片icon');

  await dt.sleep();
  dt.log.i('STEP 3、点击照片或者视频，进入大图');

  await dt.sleep();
  dt.log.i('预期结果3、照片或者视频封面帧有去摩尔纹效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('摩尔纹三方picker页 end');
}

/**
 * 大图-进入大图: [摩尔纹不同宫格入口进入大图]
 * TAG: 601 TID: Multimedia_Gallery_Moire_015
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_015(dt: Dt) {
  dt.log.i('摩尔纹不同宫格入口进入大图 start');
  dt.log.i('STEP 1、地点相册进入大图');

  await dt.sleep();
  dt.log.i('预期结果1\2\3\4\5\6、进入大图后有去除摩尔纹效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、图片宫格进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、人像相册进入大图');

  await dt.sleep();
  dt.log.i('STEP 4、收藏相册进入大图');

  await dt.sleep();
  dt.log.i('STEP 5、最近删除进入大图');

  await dt.sleep();
  dt.log.i('STEP 6、截图相册进入大图');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('摩尔纹不同宫格入口进入大图 end');
}

/**
 * 大图-摩尔纹: [摩尔纹云图编辑下载后查看]
 * TAG: 602 TID: Multimedia_Gallery_Moire_009
 * 前置条件
 * 1、图库云上存在摩尔纹资源
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_009(dt: Dt) {
  dt.log.i('摩尔纹云图编辑下载后查看 start');
  dt.log.i('STEP 1、摩尔纹云图大图点击编辑下载');

  await dt.sleep();
  dt.log.i('预期结果1、云图不进行去摩尔纹');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、编辑界面对照片进行双指缩小后返回大图');

  await dt.sleep();
  dt.log.i('预期结果2、大图有去摩尔纹效果');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('摩尔纹云图编辑下载后查看 end');
}

/**
 * 大图-摩尔纹: [摩尔纹照片来源--端云同步]
 * TAG: 604 TID: Multimedia_Gallery_Moire_021
 * 前置条件
 * 1、图库云上存在摩尔纹资源
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_021(dt: Dt) {
  dt.log.i('摩尔纹照片来源--端云同步 start');
  dt.log.i('STEP 1、xxx图库端云同步至xxx图库');

  await dt.sleep();
  dt.log.i('预期结果1\2\3、照片或者视频封面帧有去摩尔纹效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、xxx图库端云同步至xxx图库');

  await dt.sleep();
  dt.log.i('STEP 3、端云同步至本地');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('摩尔纹照片来源--端云同步 end');
}

/**
 * 大图-摩尔纹: [摩尔纹相机进入图库大图]
 * TAG: 606 TID: Multimedia_Gallery_Moire_019
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_019(dt: Dt) {
  dt.log.i('摩尔纹相机进入图库大图 start');
  dt.log.i('STEP 1、相机内进行拍摄HDR\HEIF格式照片或者录像');

  await dt.sleep();
  dt.log.i('STEP 2、点击缩略图');

  await dt.sleep();
  dt.log.i('预期结果2、进入图库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击图片或者视频');

  await dt.sleep();
  dt.log.i('预期结果3、照片或者视频封面帧或者动态照片封面帧有去摩尔纹效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('摩尔纹相机进入图库大图 end');
}

/**
 * 大图-摩尔纹: [摩尔纹照片来源--隔空投送]
 * TAG: 607 TID: Multimedia_Gallery_Moire_023
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_023(dt: Dt) {
  dt.log.i('摩尔纹照片来源--隔空投送 start');
  dt.log.i('STEP 1、xxx图库隔空投送至xxx图库');

  await dt.sleep();
  dt.log.i('预期结果1\2、照片或者视频封面帧有去摩尔纹效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、xxx图库隔空投送至xxx图库');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('摩尔纹照片来源--隔空投送 end');
}

/**
 * 大图-摩尔纹: [摩尔纹视屏封面帧]
 * TAG: 608 TID: Multimedia_Gallery_Moire_017
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_017(dt: Dt) {
  dt.log.i('摩尔纹视屏封面帧 start');
  dt.log.i('STEP 1、打开视频大图');

  await dt.sleep();
  dt.log.i('STEP 2、对视频进行截取\裁剪\调节\滤镜操作');

  await dt.sleep();
  dt.log.i('STEP 3、覆盖原视频');

  await dt.sleep();
  dt.log.i('预期结果3、新视频封面帧有去摩尔纹');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、另存视频');

  await dt.sleep();
  dt.log.i('预期结果4、新视频封面帧有去摩尔纹效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('摩尔纹视屏封面帧 end');
}

/**
 * 大图-摩尔纹: [照片来源--分享]
 * TAG: 609 TID: Multimedia_Gallery_Moire_022
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_022(dt: Dt) {
  dt.log.i('照片来源--分享 start');
  dt.log.i('STEP 1、xxx图库分享至xxx图库');

  await dt.sleep();
  dt.log.i('预期结果1\2、照片或者视频封面帧有去摩尔纹效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、xxx图库分享至xxx图库');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片来源--分享 end');
}

