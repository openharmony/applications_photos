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

export default function MultimediaGallerylighlightFD003(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGallerylighlightFD003Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGallerylighlightFD003').init();
      dt.log.i('beforeAll MultimediaGallerylighlightFD003 start');
      dt.log.i('beforeAll MultimediaGallerylighlightFD003 finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGallerylighlightFD003', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGallerylighlightFD175', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [时刻轮播素材包含视频—操作/编辑视频] TID: Multimedia_Gallery_lighlight_FD_175
      await multimediaGallerylighlightFD175(dt);
    });
    run('MultimediaGallerylighlightFD176', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [导出包含视频的时刻] TID: Multimedia_Gallery_lighlight_FD_176
      await multimediaGallerylighlightFD176(dt);
    });
    run('MultimediaGallerylighlightFD177', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [导出包含视频的时刻-查看导出的视频] TID: Multimedia_Gallery_lighlight_FD_177
      await multimediaGallerylighlightFD177(dt);
    });
    run('MultimediaGallerylighlightFD179', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [3D运镜效果生成类型检查] TID: Multimedia_Gallery_lighlight_FD_179
      await multimediaGallerylighlightFD179(dt);
    });
    run('MultimediaGallerylighlightFD180', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [3D运镜效果播放检查] TID: Multimedia_Gallery_lighlight_FD_180
      await multimediaGallerylighlightFD180(dt);
    });
    run('MultimediaGallerylighlightFD181', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [3D运镜效果支持图片] TID: Multimedia_Gallery_lighlight_FD_181
      await multimediaGallerylighlightFD181(dt);
    });
    run('MultimediaGallerylighlightFD182', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [3D运镜效果-希区柯克支持人像] TID: Multimedia_Gallery_lighlight_FD_182
      await multimediaGallerylighlightFD182(dt);
    });
    run('MultimediaGallerylighlightFD183', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [3D运镜效果-无人机推拉支持风景] TID: Multimedia_Gallery_lighlight_FD_183
      await multimediaGallerylighlightFD183(dt);
    });
    run('MultimediaGallerylighlightFD184', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [3D运镜效果-希区柯克运镜] TID: Multimedia_Gallery_lighlight_FD_184
      await multimediaGallerylighlightFD184(dt);
    });
    run('MultimediaGallerylighlightFD185', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [3D运镜效果-无人机推拉运镜] TID: Multimedia_Gallery_lighlight_FD_185
      await multimediaGallerylighlightFD185(dt);
    });
    run('MultimediaGallerylighlightFD186', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [3D运镜效果支持视频分享导出] TID: Multimedia_Gallery_lighlight_FD_186
      await multimediaGallerylighlightFD186(dt);
    });
    run('MultimediaGallerylighlightFD187', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [3D运镜效果视频导出格式检查] TID: Multimedia_Gallery_lighlight_FD_187
      await multimediaGallerylighlightFD187(dt);
    });
    run('MultimediaGallerylighlightFD188', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [3D运镜效果-删除对应图片] TID: Multimedia_Gallery_lighlight_FD_188
      await multimediaGallerylighlightFD188(dt);
    });
    run('MultimediaGallerylighlightFD189', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [3D运镜效果-关闭云同步] TID: Multimedia_Gallery_lighlight_FD_189
      await multimediaGallerylighlightFD189(dt);
    });
    run('MultimediaGallerylighlightFD190', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [3D运镜效果视频仅支持轮播展示] TID: Multimedia_Gallery_lighlight_FD_190
      await multimediaGallerylighlightFD190(dt);
    });
    run('MultimediaGallerylighlightFD191', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-进度条用例: [导出包含高光片段的时刻] TID: Multimedia_Gallery_lighlight_FD_191
      await multimediaGallerylighlightFD191(dt);
    });
    run('MultimediaGallerylighlightFD207', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻封面支持过滤闭眼等不美观照片] TID: Multimedia_Gallery_lighlight_FD_207
      await multimediaGallerylighlightFD207(dt);
    });
    run('MultimediaGallerylighlightFD262', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-滑动用例: [息屏充电生成多个时刻，数量大于60，横屏上下滑动查看时刻] TID: Multimedia_Gallery_lighlight_FD_262
      await multimediaGallerylighlightFD262(dt);
    });
    run('MultimediaGallerylighlightFD447', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻封面字体显示和图片颜色有区分，字体显示清晰] TID: Multimedia_Gallery_lighlight_FD_447
      await multimediaGallerylighlightFD447(dt);
    });
    run('MultimediaGallerylighlightFD999', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [时刻一级界面退后台后，截图再次进入图库] TID: Multimedia_Gallery_lighlight_FD_999
      await multimediaGallerylighlightFD999(dt);
    });
    run('MultimediaGalleryMagicMomentscomposition001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [竖屏时刻中竖屏比例>75%验证] TID: Multimedia_Gallery_MagicMoments_composition_001
      await multimediaGalleryMagicMomentscomposition001(dt);
    });
    run('MultimediaGalleryMagicMomentscomposition002', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [横屏时刻中横屏比例>75%验证] TID: Multimedia_Gallery_MagicMoments_composition_002
      await multimediaGalleryMagicMomentscomposition002(dt);
    });
    run('MultimediaGalleryMagicMomentscomposition003', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-竖屏用例: [时刻照片裁切人脸排查] TID: Multimedia_Gallery_MagicMoments_composition_003
      await multimediaGalleryMagicMomentscomposition003(dt);
    });
    run('MultimediaGallerynetworksettings001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [“图库网络连接”，以及“无限量使用移动网络”设置开关项的默认状态] TID: Multimedia_Gallery_networksettings_001
      await multimediaGallerynetworksettings001(dt);
    });
    run('MultimediaGallerynetworksettings002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-滑动用例: [“图库网络连接”，以及“无限量使用移动网络”设置开关项的支持点击开关和滑动开关] TID: Multimedia_Gallery_networksettings_002
      await multimediaGallerynetworksettings002(dt);
    });
    run('MultimediaGallerynetworksettings003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [“图库网络连接”，以及“无限量使用移动网络”对云图的功能测试1] TID: Multimedia_Gallery_networksettings_003
      await multimediaGallerynetworksettings003(dt);
    });
    run('MultimediaGallerynetworksettings004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-解析用例: [“图库网络连接”，以及“无限量使用移动网络”对云图的功能测试2] TID: Multimedia_Gallery_networksettings_004
      await multimediaGallerynetworksettings004(dt);
    });
    run('MultimediaGallerynetworksettings005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-格式用例: [“图库网络连接”，以及“无限量使用移动网络”对云图的功能测试3] TID: Multimedia_Gallery_networksettings_005
      await multimediaGallerynetworksettings005(dt);
    });
    run('MultimediaGallerynetworksettings006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [首次点击地点相册弹出“地图相册服务”提示框] TID: Multimedia_Gallery_networksettings_006
      await multimediaGallerynetworksettings006(dt);
    });
    run('MultimediaGallerynetworksettings007', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-解析用例: [“图库网络连接”，以及“无限量使用移动网络”设置开关项支持其他语言] TID: Multimedia_Gallery_networksettings_007
      await multimediaGallerynetworksettings007(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGallerylighlightFD003').init();
      dt.log.i('afterEach MultimediaGallerylighlightFD003 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGallerylighlightFD003 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGallerylighlightFD003').init();
      dt.log.i('afterAll MultimediaGallerylighlightFD003 start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGallerylighlightFD003 finish');
    });
  });
}

// DT步骤
/**
 * 宫格-视频: [时刻轮播素材包含视频—操作/编辑视频]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_lighlight_FD_175
 * 前置条件
 * 1.图库中存在相机拍摄视频和图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD175(dt: Dt) {
  dt.log.i('时刻轮播素材包含视频—操作/编辑视频 start');
  dt.log.i('STEP 1. 打开精彩时刻，进入轮播界面');

  await dt.sleep();
  dt.log.i('预期结果1.切换到视频的缩略图时视频播放，无卡顿，播放流畅');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.滑动/点击轮播中的缩略图');

  await dt.sleep();
  dt.log.i('STEP 3.');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻轮播素材包含视频—操作/编辑视频 end');
}

/**
 * 宫格-视频: [导出包含视频的时刻]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_lighlight_FD_176
 * 前置条件
 * 1.图库中存在相机拍摄视频和图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD176(dt: Dt) {
  dt.log.i('导出包含视频的时刻 start');
  dt.log.i('STEP 1.在时刻轮播界面， 点击分享为视频');

  await dt.sleep();
  dt.log.i('预期结果1.视频正常导出，进度条显示导出进度，导出成功后会弹出分享界面');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('导出包含视频的时刻 end');
}

/**
 * 宫格-视频: [导出包含视频的时刻-查看导出的视频]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_lighlight_FD_177
 * 前置条件
 * 1.图库中存在相机拍摄视频和图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD177(dt: Dt) {
  dt.log.i('导出包含视频的时刻-查看导出的视频 start');
  dt.log.i('STEP 1.在时刻轮播界面， 点击分享为视频');

  await dt.sleep();
  dt.log.i('预期结果1.视频正常导出后， 在图库、三方应用中播放视频，视频正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('导出包含视频的时刻-查看导出的视频 end');
}

/**
 * 宫格-: [3D运镜效果生成检查]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_178
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 （覆盖xxx）
 */
async function multimediaGallerylighlightFD178(dt: Dt) {
  dt.log.i('3D运镜效果生成检查 start');
  dt.log.i('STEP 1、点击时刻相册进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、查看时刻，只有时刻里涉及到单人人像和风景区静态照片会生成一个3D运镜效果（希区柯克/无人机推拉）');

  await dt.sleep();
  dt.log.i('预期结果2.1带有运镜的时刻正常生成2.2有3D运镜效果生成（希区柯克/无人机推拉） 最多1个希区柯克运镜+1个无人机推拉运镜');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('3D运镜效果生成检查 end');
}

/**
 * 宫格-: [3D运镜效果生成类型检查]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_179
 * 前置条件
 * <p>1.图库中存在可生成时刻的图片，数量至少6张</p><p>2.手机电量大于50%，充电灭屏分析</p><p>3.有时刻相册生成</p><p>（覆盖xxx）</p>
 */
async function multimediaGallerylighlightFD179(dt: Dt) {
  dt.log.i('3D运镜效果生成类型检查 start');
  dt.log.i('STEP 1、点击时刻相册进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、查看支持生成3D运镜效果时刻类型');

  await dt.sleep();
  dt.log.i('预期结果2、仅支持新生成时刻和成长型时刻，已生成非成长型时刻无新增3D运镜效果');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('3D运镜效果生成类型检查 end');
}

/**
 * 宫格-: [3D运镜效果播放检查]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_180
 * 前置条件
 * <p>1.图库中存在可生成时刻的图片，数量至少6张</p><p>2.手机电量大于50%，充电灭屏分析</p><p>3.有时刻相册生成</p><p>（覆盖xxx）</p>
 */
async function multimediaGallerylighlightFD180(dt: Dt) {
  dt.log.i('3D运镜效果播放检查 start');
  dt.log.i('STEP 1、点击时刻相册进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、查看生成的3D运镜效果动效是否正常播放');

  await dt.sleep();
  dt.log.i('预期结果2.1、3D运镜效果（希区柯克/无人机推拉）动效正确，无异常运镜场景变化2.2、3D运镜效果播放流畅、无卡顿、黑屏、拉伸扭曲等异常现象');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('3D运镜效果播放检查 end');
}

/**
 * 宫格-视频: [3D运镜效果支持图片]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_lighlight_FD_181
 * 前置条件
 * <p>1.图库中存在可生成时刻的图片，数量至少6张</p><p>2.手机电量大于50%，充电灭屏分析</p><p>3.有时刻相册生成</p><p>（覆盖xxx）</p>
 */
async function multimediaGallerylighlightFD181(dt: Dt) {
  dt.log.i('3D运镜效果支持图片 start');
  dt.log.i('STEP 1、点击时刻相册进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、查看生成的3D运镜效果支持图片/视频');

  await dt.sleep();
  dt.log.i('预期结果2、随机选取时刻某张图片生成的运镜效果在轮播中展示，不支持视频效果');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('3D运镜效果支持图片 end');
}

/**
 * 宫格-: [3D运镜效果-希区柯克支持人像]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_182
 * 前置条件
 * <p>1.图库中存在可生成时刻的图片，数量至少6张</p><p>2.手机电量大于50%，充电灭屏分析</p><p>3.有时刻相册生成</p><p>（覆盖xxx）</p>
 */
async function multimediaGallerylighlightFD182(dt: Dt) {
  dt.log.i('3D运镜效果-希区柯克支持人像 start');
  dt.log.i('STEP 1、点击时刻相册进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、查看单人像图片运镜效果');

  await dt.sleep();
  dt.log.i('预期结果2、希区柯克运镜仅支持单人像静态图片');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('3D运镜效果-希区柯克支持人像 end');
}

/**
 * 宫格-: [3D运镜效果-无人机推拉支持风景]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_183
 * 前置条件
 * <p>1.图库中存在可生成时刻的图片，数量至少6张</p><p>2.手机电量大于50%，充电灭屏分析</p><p>3.有时刻相册生成</p><p>（覆盖xxx）</p>
 */
async function multimediaGallerylighlightFD183(dt: Dt) {
  dt.log.i('3D运镜效果-无人机推拉支持风景 start');
  dt.log.i('STEP 1、点击时刻相册进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、查看风景图片运镜效果');

  await dt.sleep();
  dt.log.i('预期结果2、无人机推拉运镜仅支持风景静态图片');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('3D运镜效果-无人机推拉支持风景 end');
}

/**
 * 宫格-: [3D运镜效果-希区柯克运镜]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_184
 * 前置条件
 * <p>1.图库中存在可生成时刻的图片，数量至少6张</p><p>2.手机电量大于50%，充电灭屏分析</p><p>3.有时刻相册生成</p><p>（覆盖xxx）</p>
 */
async function multimediaGallerylighlightFD184(dt: Dt) {
  dt.log.i('3D运镜效果-希区柯克运镜 start');
  dt.log.i('STEP 1、点击时刻相册进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、查看时刻中的希区柯克运镜效果变焦形式');

  await dt.sleep();
  dt.log.i('预期结果2、保持镜头中主体大小不变、背景大小改变，运镜节奏正常，无过快过慢情况');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('3D运镜效果-希区柯克运镜 end');
}

/**
 * 宫格-: [3D运镜效果-无人机推拉运镜]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_185
 * 前置条件
 * <p>1.图库中存在可生成时刻的图片，数量至少6张</p><p>2.手机电量大于50%，充电灭屏分析</p><p>3.有时刻相册生成</p><p>（覆盖xxx）</p>
 */
async function multimediaGallerylighlightFD185(dt: Dt) {
  dt.log.i('3D运镜效果-无人机推拉运镜 start');
  dt.log.i('STEP 1、点击时刻相册进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、查看时刻中的无人机视角运镜效果变化形式');

  await dt.sleep();
  dt.log.i('预期结果2、镜头整体随无人机直线方向前飞视角变化，突出主体形象和环境层级关系，运镜节奏正常，无过快过慢情况');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('3D运镜效果-无人机推拉运镜 end');
}

/**
 * 宫格-视频: [3D运镜效果支持视频分享导出]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_lighlight_FD_186
 * 前置条件
 * <p>1.图库中存在可生成时刻的图片，数量至少6张</p><p>2.手机电量大于50%，充电灭屏分析</p><p>3.有时刻相册生成</p><p>（覆盖xxx）</p>
 */
async function multimediaGallerylighlightFD186(dt: Dt) {
  dt.log.i('3D运镜效果支持视频分享导出 start');
  dt.log.i('STEP 1、点击时刻相册进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、点击视频分享导出成功后查看');

  await dt.sleep();
  dt.log.i('预期结果2.1、支持从轮播界面、二级宫格界面导出包含3D运镜效果时刻视频2.2、有3D运镜效果的时刻导出后播放也会有3D运镜效果');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('3D运镜效果支持视频分享导出 end');
}

/**
 * 宫格-格式: [3D运镜效果视频导出格式检查]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_lighlight_FD_187
 * 前置条件
 * <p>1.图库中存在可生成时刻的图片，数量至少6张</p><p>2.手机电量大于50%，充电灭屏分析</p><p>3.有时刻相册生成</p><p>（覆盖xxx）</p>
 */
async function multimediaGallerylighlightFD187(dt: Dt) {
  dt.log.i('3D运镜效果视频导出格式检查 start');
  dt.log.i('STEP 1、点击时刻相册进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、点击视频分享导出后进入相册查看');

  await dt.sleep();
  dt.log.i('预期结果2、视频格式为MP4格式');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('3D运镜效果视频导出格式检查 end');
}

/**
 * 宫格-删除: [3D运镜效果-删除对应图片]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_lighlight_FD_188
 * 前置条件
 * <p>1.图库中存在可生成时刻的图片，数量至少6张</p><p>2.手机电量大于50%，充电灭屏分析</p><p>3.有时刻相册生成</p><p>（覆盖xxx）</p>
 */
async function multimediaGallerylighlightFD188(dt: Dt) {
  dt.log.i('3D运镜效果-删除对应图片 start');
  dt.log.i('STEP 1、点击时刻相册进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、删除已生成3D运镜效果的对应图片到最近删除相册');

  await dt.sleep();
  dt.log.i('预期结果2、时刻轮播中该图片消失，且对应运镜效果视频删除');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('3D运镜效果-删除对应图片 end');
}

/**
 * 宫格-视频: [3D运镜效果-关闭云同步]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_lighlight_FD_189
 * 前置条件
 * <p>1.图库中存在可生成时刻的图片，数量至少6张</p><p>2.手机电量大于50%，充电灭屏分析</p><p>3.有时刻相册生成</p><p>（覆盖xxx）</p>
 */
async function multimediaGallerylighlightFD189(dt: Dt) {
  dt.log.i('3D运镜效果-关闭云同步 start');
  dt.log.i('STEP 1、关闭图库云同步开关');

  await dt.sleep();
  dt.log.i('预期结果1、对应已生成运镜效果的图片和视频从时刻中消失');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('3D运镜效果-关闭云同步 end');
}

/**
 * 宫格-视频: [3D运镜效果视频仅支持轮播展示]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_lighlight_FD_190
 * 前置条件
 * <p>1.图库中存在可生成时刻的图片，数量至少6张</p><p>2.手机电量大于50%，充电灭屏分析</p><p>3.有时刻相册生成</p><p>（覆盖xxx）</p>
 */
async function multimediaGallerylighlightFD190(dt: Dt) {
  dt.log.i('3D运镜效果视频仅支持轮播展示 start');
  dt.log.i('STEP 1、点击时刻相册进入时刻轮播');

  await dt.sleep();
  dt.log.i('STEP 2、查看时刻相册各级页面展示效果');

  await dt.sleep();
  dt.log.i('预期结果2、运镜视频效果仅在时刻轮播界面展示，时刻封面、二级宫格界面、缩略图以及大图浏览界面不展示运镜效果');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('3D运镜效果视频仅支持轮播展示 end');
}

/**
 * 宫格-进度条: [导出包含高光片段的时刻]
 * GROUP: 宫格 MODULE: 进度条TID: Multimedia_Gallery_lighlight_FD_191
 * 前置条件
 * 1.图库中存在能生成时刻的照片和高光片段视频
 2.手机电量大于50%，充电灭屏分析
 3.生成有高光片段的时刻
 */
async function multimediaGallerylighlightFD191(dt: Dt) {
  dt.log.i('导出包含高光片段的时刻 start');
  dt.log.i('STEP 1.在时刻轮播界面， 点击分享为视频');

  await dt.sleep();
  dt.log.i('预期结果1.视频正常导出，进度条显示导出进度，导出成功后会弹出分享界面');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('导出包含高光片段的时刻 end');
}

/**
 * 宫格-: [时刻封面支持过滤闭眼等不美观照片]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_207
 * 前置条件
 * 1.图库中存在的可生成时刻的人像图片，包括多张闭眼的照片
 */
async function multimediaGallerylighlightFD207(dt: Dt) {
  dt.log.i('时刻封面支持过滤闭眼等不美观照片 start');
  dt.log.i('STEP 1.手机电量大于50%，充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2.有时刻相册生成');

  await dt.sleep();
  dt.log.i('预期结果2.封面会过滤掉闭眼照片 ');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.查看时刻封面');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻封面支持过滤闭眼等不美观照片 end');
}

/**
 * 宫格-滑动: [息屏充电生成多个时刻，数量大于60，横屏上下滑动查看时刻]
 * GROUP: 宫格 MODULE: 滑动TID: Multimedia_Gallery_lighlight_FD_262
 * 前置条件
 * 1.图库中存在的可生成大于60个时刻的图片（概率出现两个完全相同的时刻）
 */
async function multimediaGallerylighlightFD262(dt: Dt) {
  dt.log.i('息屏充电生成多个时刻，数量大于60，横屏上下滑动查看时刻 start');
  dt.log.i('STEP 1.手机电量大于50%，充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2.进入时刻一级页面横屏上下滑动查看时刻');

  await dt.sleep();
  dt.log.i('预期结果2.时刻显示正常无白屏问题 ');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('息屏充电生成多个时刻，数量大于60，横屏上下滑动查看时刻 end');
}

/**
 * 宫格-: [时刻封面字体显示和图片颜色有区分，字体显示清晰]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_447
 * 前置条件
 * 1.图库中存在的可生成时刻的人像图片，图片背景为白色场景
 */
async function multimediaGallerylighlightFD447(dt: Dt) {
  dt.log.i('时刻封面字体显示和图片颜色有区分，字体显示清晰 start');
  dt.log.i('STEP 1.手机电量大于50%，充电灭屏分析');

  await dt.sleep();
  dt.log.i('STEP 2.有时刻相册生成');

  await dt.sleep();
  dt.log.i('预期结果2.时刻生成封面字体与图片背景色有差异，字体显示清晰 ');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.查看时刻标题');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻封面字体显示和图片颜色有区分，字体显示清晰 end');
}

/**
 * 宫格-: [时刻一级界面退后台后，截图再次进入图库]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_lighlight_FD_999
 * 前置条件
 * 1.图库中存在可生成时刻的图片，数量至少8张
 2.手机电量大于50%，充电灭屏分析
 3.有时刻相册生成
 */
async function multimediaGallerylighlightFD999(dt: Dt) {
  dt.log.i('时刻一级界面退后台后，截图再次进入图库 start');
  dt.log.i('STEP 1.点击tabbar上的时刻tab进入时刻界面');

  await dt.sleep();
  dt.log.i('STEP 2.直接退到桌面，截图，再次点击图库进入时刻界面');

  await dt.sleep();
  dt.log.i('预期结果2、图库时刻界面显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻一级界面退后台后，截图再次进入图库 end');
}

/**
 * 宫格-竖屏: [竖屏时刻中竖屏比例>75%验证]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_MagicMoments_composition_001
 * 前置条件
 * 复用时刻的图片测试模型库生成全部时刻
 */
async function multimediaGalleryMagicMomentscomposition001(dt: Dt) {
  dt.log.i('竖屏时刻中竖屏比例>75%验证 start');
  dt.log.i('STEP 1、手机竖屏点时刻播放，统计时刻视频中全屏照片个数做分子，在时刻素材中计算竖图的个数做分母，计算比例为铺满比例，原图为大脸照片和合影的不计算到分子和分母中');

  await dt.sleep();
  dt.log.i('STEP 2、重复1步骤至全部时刻分析完毕');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('竖屏时刻中竖屏比例>75%验证 end');
}

/**
 * 宫格-视频: [横屏时刻中横屏比例>75%验证]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_MagicMoments_composition_002
 * 前置条件
 * 复用时刻的图片测试模型库生成全部时刻
 */
async function multimediaGalleryMagicMomentscomposition002(dt: Dt) {
  dt.log.i('横屏时刻中横屏比例>75%验证 start');
  dt.log.i('STEP 1、手机横屏点时刻播放，统计时刻视频中全屏照片个数做分子，在时刻素材中计算竖图的个数做分母，计算比例为铺满比例，原图为大脸照片和合影的不计算到分子和分母中');

  await dt.sleep();
  dt.log.i('STEP 2、重复1步骤至全部时刻分析完毕');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('横屏时刻中横屏比例>75%验证 end');
}

/**
 * 宫格-竖屏: [时刻照片裁切人脸排查]
 * GROUP: 宫格 MODULE: 竖屏TID: Multimedia_Gallery_MagicMoments_composition_003
 * 前置条件
 * 复用时刻的图片测试模型库生成全部时刻
 */
async function multimediaGalleryMagicMomentscomposition003(dt: Dt) {
  dt.log.i('时刻照片裁切人脸排查 start');
  dt.log.i('STEP 1、手机横/竖屏播放全部时刻，查看视频中人像照片');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('时刻照片裁切人脸排查 end');
}

/**
 * 宫格-格式: [“图库网络连接”，以及“无限量使用移动网络”设置开关项的默认状态]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_networksettings_001
 * 前置条件
 * 1、准备一台手机/HAD/xxx/xiaoyao
 2、云上有超过3000张不同格式和不同分辨率的图片/视频资源
 */
async function multimediaGallerynetworksettings001(dt: Dt) {
  dt.log.i('“图库网络连接”，以及“无限量使用移动网络”设置开关项的默认状态 start');
  dt.log.i('STEP 1、图库设置页查看‘图库网络连接’');

  await dt.sleep();
  dt.log.i('预期结果1、默认是开启状态');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击开启‘无限量使用移动网络’按钮');

  await dt.sleep();
  dt.log.i('预期结果2、开启成功，‘无限量使用移动网盘’按钮是开启状态，同时设置云空间-图库开启中“使用移动网络数据按钮开启，两者之间是联动的had设备无“无限量使用移动网络”按钮');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('使用移动网络数据按钮开启，两者之间是联动的had设备无'));
  dt.log.i('STEP 3、在横屏模式下执行上面1-4操作');

  await dt.sleep();
  dt.log.i('预期结果3、PC不支持横屏，其他设备可以操作');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('“图库网络连接”，以及“无限量使用移动网络”设置开关项的默认状态 end');
}

/**
 * 宫格-滑动: [“图库网络连接”，以及“无限量使用移动网络”设置开关项的支持点击开关和滑动开关]
 * GROUP: 宫格 MODULE: 滑动TID: Multimedia_Gallery_networksettings_002
 * 前置条件
 * 1、准备一台手机/HAD/xxx/xiaoyao
 2、云上有超过3000张不同格式和不同分辨率的图片/视频资源
 */
async function multimediaGallerynetworksettings002(dt: Dt) {
  dt.log.i('“图库网络连接”，以及“无限量使用移动网络”设置开关项的支持点击开关和滑动开关 start');
  dt.log.i('STEP 1、“图库网络连接”，以及“无限量使用移动网络按钮进行点击开启关闭');

  await dt.sleep();
  dt.log.i('预期结果1、点击正常开启关闭');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、“图库网络连接”，以及“无限量使用移动网络按钮进行滑动开启关闭');

  await dt.sleep();
  dt.log.i('预期结果2、滑动正常触发开启关闭');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('“图库网络连接”，以及“无限量使用移动网络”设置开关项的支持点击开关和滑动开关 end');
}

/**
 * 宫格-格式: [“图库网络连接”，以及“无限量使用移动网络”对云图的功能测试1]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_networksettings_003
 * 前置条件
 * 1、准备一台手机/HAD/xxx/xiaoyao
 2、云上有超过3000张不同格式和不同分辨率的图片视频资源
 3、已经登录云账号
 4、整机WiFi开启，整机移动网络关闭/开启
 */
async function multimediaGallerynetworksettings003(dt: Dt) {
  dt.log.i('“图库网络连接”，以及“无限量使用移动网络”对云图的功能测试1 start');
  dt.log.i('STEP 1、点击同步按钮，“图库网络连接“按钮关闭状态');

  await dt.sleep();
  dt.log.i('预期结果1、同步按钮开启了，网络连接未开启，屏蔽所有图库网络业务');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、 “图库网络连接“按钮开启状态，“无限量使用移动网络”按钮关闭');

  await dt.sleep();
  dt.log.i('预期结果2、3、图库网络连接开启，同时“无限量使用移动网络”关闭的，支持所有网络业务，包括 ：逆地理编码，云相册元数据同步，原图上传，缩略图、LCD图、原图按需下载，以及后台自动下载缩略图、LCD图、原图（包括CV分析后台下载LCD图）等，优先使用WiFi4、正常操作显示');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('无限量使用移动网络'));
  dt.log.i('STEP 3、“图库网络连接“按钮开启状态，“无限量使用移动网络”按钮开启');

  await dt.sleep();
  dt.log.i('STEP 4、在横屏模式下操作以上步骤');

  await dt.sleep();
  dt.log.i('预期结果4、正常操作显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('“图库网络连接”，以及“无限量使用移动网络”对云图的功能测试1 end');
}

/**
 * 宫格-解析: [“图库网络连接”，以及“无限量使用移动网络”对云图的功能测试2]
 * GROUP: 宫格 MODULE: 解析TID: Multimedia_Gallery_networksettings_004
 * 前置条件
 * 1、准备一台手机/HAD/xxx/xiaoyao
 2、云上有超过3000张不同格式和不同分辨率的图片视频资源
 3、已经登录云账号
 4、整机WiFi关闭，整机移动网络开启
 */
async function multimediaGallerynetworksettings004(dt: Dt) {
  dt.log.i('“图库网络连接”，以及“无限量使用移动网络”对云图的功能测试2 start');
  dt.log.i('STEP 1、点击同步按钮，“图库网络连接“按钮关闭状态');

  await dt.sleep();
  dt.log.i('预期结果1、云同步下行失败，给出提示“照片页提示开启图库网络连接“');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('照片页提示开启图库网络连接'));
  dt.log.i('STEP 2、 “图库网络连接“按钮开启状态，“无限量使用移动网络”按钮关闭');

  await dt.sleep();
  dt.log.i('预期结果2、支持图库基础业务使用网络，包括：：缩略图、LCD图、原图按需下载；不支持充电灭屏分析的业务，地点信息解析不出来，不能上下行云图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、“图库网络连接“按钮开启状态，“无限量使用移动网络”按钮开启');

  await dt.sleep();
  dt.log.i('预期结果3、支持所有网络业务：包括 ：逆地理编码，云相册元数据同步，原图上传，缩略图、LCD图、原图按需下载，以及后台自动下载缩略图、LCD图、原图（包括CV分析后台下载LCD图）等');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、使用中关闭““无限量使用移动网络”按钮开启，');

  await dt.sleep();
  dt.log.i('预期结果4、支持图库基础业务使用网络，包括：：缩略图、LCD图、原图按需下载；不支持充电灭屏分析的业务，地点信息解析不出来，不能上下行云图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、使用中关闭了“图库网络连接“按钮/关闭整机移动网络');

  await dt.sleep();
  dt.log.i('预期结果5、屏蔽图库所有的网络业务');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('“图库网络连接”，以及“无限量使用移动网络”对云图的功能测试2 end');
}

/**
 * 宫格-格式: [“图库网络连接”，以及“无限量使用移动网络”对云图的功能测试3]
 * GROUP: 宫格 MODULE: 格式TID: Multimedia_Gallery_networksettings_005
 * 前置条件
 * 1、准备一台手机/HAD/xxx/xiaoyao
 2、云上有超过3000张不同格式和不同分辨率的图片视频资源
 3、已经登录云账号
 4、整机WiFi关闭，整机移动网络关闭
 */
async function multimediaGallerynetworksettings005(dt: Dt) {
  dt.log.i('“图库网络连接”，以及“无限量使用移动网络”对云图的功能测试3 start');
  dt.log.i('STEP 1、点击同步按钮');

  await dt.sleep();
  dt.log.i('预期结果1、开启不成功，点击无响应');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('“图库网络连接”，以及“无限量使用移动网络”对云图的功能测试3 end');
}

/**
 * 宫格-: [首次点击地点相册弹出“地图相册服务”提示框]
 * GROUP: 宫格 MODULE: TID: Multimedia_Gallery_networksettings_006
 * 前置条件
 * 1、准备一台手机/HAD/xxx/xiaoyao
 2、整机WiFi打开
 3、手机使用手机，有地图相册生成
 4、首次刷机后，本地有地点图片生成，整机WiFi打开，相册与云空间同步按钮未开启。首次点击地点相册
 */
async function multimediaGallerynetworksettings006(dt: Dt) {
  dt.log.i('首次点击地点相册弹出“地图相册服务”提示框 start');
  dt.log.i('STEP 1、本地有地点图片生成，整机WiFi打开，首次点击地点相册');

  await dt.sleep();
  dt.log.i('预期结果1、弹出提示：地点相册服务，有取消和确认按钮，点击取消后会界面显示同意地图服务条款后显示，点击查看后再次弹出提示；点击确认后进入地点相册');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('首次点击地点相册弹出“地图相册服务”提示框 end');
}

/**
 * 宫格-解析: [“图库网络连接”，以及“无限量使用移动网络”设置开关项支持其他语言]
 * GROUP: 宫格 MODULE: 解析TID: Multimedia_Gallery_networksettings_007
 * 前置条件
 * 1、准备一台手机/HAD/xxx/xiaoyao
 2、云上有超过3000张不同格式和不同分辨率的图片视频资源
 3、已经登录云账号
 4、整机WiFi关闭，整机移动网络开启
 5、其他语言模式下
 */
async function multimediaGallerynetworksettings007(dt: Dt) {
  dt.log.i('“图库网络连接”，以及“无限量使用移动网络”设置开关项支持其他语言 start');
  dt.log.i('STEP 1、点击同步按钮，“图库网络连接“按钮关闭状态');

  await dt.sleep();
  dt.log.i('预期结果1、云同步下行失败，给出提示“照片页提示开启图库网络连接“');
  await dt.sleep(DELAY.double);
  await dt.driver.assertComponentExist(ON.text('照片页提示开启图库网络连接'));
  dt.log.i('STEP 2、 “图库网络连接“按钮开启状态，“无限量使用移动网络”按钮关闭');

  await dt.sleep();
  dt.log.i('预期结果2、支持图库基础业务使用网络，包括：：缩略图、LCD图、原图按需下载；不支持充电灭屏分析的业务，地点信息解析不出来，不能上下行云图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、“图库网络连接“按钮开启状态，“无限量使用移动网络”按钮开启');

  await dt.sleep();
  dt.log.i('预期结果3、支持所有网络业务：包括 ：逆地理编码，云相册元数据同步，原图上传，缩略图、LCD图、原图按需下载，以及后台自动下载缩略图、LCD图、原图（包括CV分析后台下载LCD图）等');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、使用中关闭““无限量使用移动网络”按钮开启，');

  await dt.sleep();
  dt.log.i('预期结果4、支持图库基础业务使用网络，包括：：缩略图、LCD图、原图按需下载；不支持充电灭屏分析的业务，地点信息解析不出来，不能上下行云图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、使用中关闭了“图库网络连接“按钮/关闭整机移动网络');

  await dt.sleep();
  dt.log.i('预期结果5、屏蔽图库所有的网络业务');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('“图库网络连接”，以及“无限量使用移动网络”设置开关项支持其他语言 end');
}