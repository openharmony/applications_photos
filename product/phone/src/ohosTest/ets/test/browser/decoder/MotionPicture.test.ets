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

export default function motionPictureTest(): void {
  describe('MotionPictureTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    // 确认当前图库app处于启动状态
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMotionPictureTest').init();
      dt.log.i('beforeAll MotionPictureTest start');
      dt.log.i('beforeAll MotionPictureTest finish');
    });
    it('beforeMotionPictureTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      // 进入图库
      await dt.browser();
    });
    it('Multimedia_Gallery_SR20240305625869_006', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片不走yuv解码] TID: Multimedia_Gallery_SR20240305625869_006
      await Multimedia_Gallery_SR20240305625869_006(dt);
    });
    it('Multimedia_Gallery_PhotoBrowser_HEIC_033', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片hefi格式显示] TID: Multimedia_Gallery_PhotoBrowser_HEIC_033
      await Multimedia_Gallery_PhotoBrowser_HEIC_033(dt);
    });
    it('Multimedia_Gallery_Motion_picture_048', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片动态效果抠图] TID: Multimedia_Gallery_Motion_picture_048
      await Multimedia_Gallery_Motion_picture_048(dt);
    });
    it('Multimedia_Gallery_Motion_picture_015', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片长按播放支持松手停止播放] TID: Multimedia_Gallery_Motion_picture_015
      await Multimedia_Gallery_Motion_picture_015(dt);
    });
    it('Multimedia_Gallery_Motion_picture_021', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片支持自动播放] TID: Multimedia_Gallery_Motion_picture_021
      await Multimedia_Gallery_Motion_picture_021(dt);
    });
    it('Multimedia_Gallery_Motion_picture_024', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片效果播放正常] TID: Multimedia_Gallery_Motion_picture_024
      await Multimedia_Gallery_Motion_picture_024(dt);
    });
    it('Multimedia_Gallery_Dynamic_Photo_Export_001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [不同入口动态照片支持导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_001
      await Multimedia_Gallery_Dynamic_Photo_Export_001(dt);
    });
    it('Multimedia_Gallery_Dynamic_Photo_Export_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片导出视频界面ux显示] TID: Multimedia_Gallery_Dynamic_Photo_Export_003
      await Multimedia_Gallery_Dynamic_Photo_Export_003(dt);
    });
    it('Multimedia_Gallery_Motion_picture_023', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片效果切换] TID: Multimedia_Gallery_Motion_picture_023
      await Multimedia_Gallery_Motion_picture_023(dt);
    });
    it('Multimedia_Gallery_AICloudEnhancementService_007', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片支持云增强] TID: Multimedia_Gallery_AICloudEnhancementService_007
      await Multimedia_Gallery_AICloudEnhancementService_007(dt);
    });
    it('Multimedia_Gallery_Automatic_Cloudenhancement_18', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [自动云增强-水印动态照片支持自动云增强] TID: Multimedia_Gallery_Automatic_Cloudenhancement_18
      await Multimedia_Gallery_Automatic_Cloudenhancement_18(dt);
    });
    it('Multimedia_Gallery_Automatic_Cloudenhancement_20', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [自动云增强-自动云增强后的水印动态照片无对比按钮] TID: Multimedia_Gallery_Automatic_Cloudenhancement_20
      await Multimedia_Gallery_Automatic_Cloudenhancement_20(dt);
    });
    it('Multimedia_Gallery_Motion_picture_003', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [动态照片支持长按播放] TID: Multimedia_Gallery_Motion_picture_003
      await Multimedia_Gallery_Motion_picture_003(dt);
    });
    it('Multimedia_Gallery_Motion_picture_004', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-动态照片用例: [不同入口长按播放动态照片] TID: Multimedia_Gallery_Motion_picture_004
      await Multimedia_Gallery_Motion_picture_004(dt);
    });

    // 退出大图 回到时间线页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMotionPictureTest').init();
      await Exit.browser();
      dt.log.i('afterAll MotionPictureTest finish');
    });
    // 确保每次测试完毕回到大图页
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMotionPictureTest').init();
      dt.log.i('afterEach MotionPictureTest finish');
    });
  });
}

/**
 * 大图-动态照片用例: [动态照片不走yuv解码] TID: Multimedia_Gallery_SR20240305625869_006
 * 前置条件
 * 1、图库存在动态照片
 */
async function Multimedia_Gallery_SR20240305625869_006(dt: Dt) {
  dt.log.i('动态照片不走yuv解码 start');
  // 测试步骤
  // 1、大图浏览动态照片
  await dt.sleep(DELAY.short);
  // 2、查看日志
  await Multimedia_Gallery_SR20240305625869_006Expects(dt);
  dt.log.i('动态照片不走yuv解码 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_SR20240305625869_006Expects(dt: Dt): Promise<void> {
  // 1、大图浏览加载正常，无卡顿、刷新等场景
  await dt.showComponentsWithin();
  // 2、不打印picture decode mime, pixelmapFormat 11和No need LcdDocode

}

/**
 * 大图-动态照片用例: [动态照片hefi格式显示] TID: Multimedia_Gallery_PhotoBrowser_HEIC_033
 * 前置条件
 * 1、相机设置拍摄格式为HEIF，拍摄动态照片
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_033(dt: Dt) {
  dt.log.i('动态照片hefi格式显示 start');
  // 测试步骤
  // 1、不同入口查看hefi格式动态照片显示
  await dt.sleep(DELAY.short);
  // 2、hefi格式照片切换不同效果
  await dt.sleep(DELAY.short);
  // 3、切换不同效果导出视频后查看
  try {
    await abilityDelegator.startAbility(TestConstants.SMART_PICKER_BANK_CARD_WANT).then(() => {
      dt.log.i('start photo success with smart picker');
    });
  } catch (exception) {
    expect(0).assertEqual(exception.code);
    dt.log.i(`start failed :${exception.code}`);
  } finally {
    dt.log.i('start photo application');
  }
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  if (await dt.driver.findComponent(ON.text('全部'))) {
    await dt.assertComponentByText('全部');
  }
  if (await dt.driver.findComponent(ON.text('银行卡'))) {
    await dt.assertComponentByText('银行卡');
  }
  // 4、选中heif格式的动态照片长按播放（切换不同效果）
  await Multimedia_Gallery_PhotoBrowser_HEIC_033Expects(dt);
  dt.log.i('动态照片hefi格式显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_033Expects(dt: Dt): Promise<void> {
  // 1、图片显示正常，清晰
  // 2、可以正常切换不同的动态照片效果，显示正常
  // 3、图片可以正常导出视频，视频显示正常
  // 4、图库可以正常播放，清晰

}

/**
 * 大图-动态照片用例: [动态照片动态效果抠图] TID: Multimedia_Gallery_Motion_picture_048
 * 前置条件
 * 1、相机拍摄带主体动态照片（尽量保持主体一直在画面内）
 */
async function Multimedia_Gallery_Motion_picture_048(dt: Dt) {
  dt.log.i('动态照片动态效果抠图 start');
  // 测试步骤
  // 1、设置动态照片效果为动态照片效果
  await dt.sleep(DELAY.short);
  // 2、长按主体500ms左右松手抠图
  await dt.sleep(DELAY.short);
  // 3、对所抠动图进行保存，并查看该动图
  await Multimedia_Gallery_Motion_picture_048Expects(dt);
  dt.log.i('动态照片动态效果抠图 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Motion_picture_048Expects(dt: Dt): Promise<void> {
  // 2、出现菜单（复制、分享、全选（多主体存在该菜单操作）、小艺搜索、保存）
  await dt.showComponentsWithin();
  // 3、动图格式为gif

}

/**
 * 大图-动态照片用例: [动态照片支持长按播放] TID: Multimedia_Gallery_Motion_picture_003
 * 前置条件
 * 1、准备动态照片（可以使用相机拍摄动态照片）
 */
async function Multimedia_Gallery_Motion_picture_003(dt: Dt) {
  dt.log.i('动态照片支持长按播放 start');
  // 测试步骤
  // 1、从图库照片页进入动态照片大图
  await dt.sleep(DELAY.short);
  // 2、长按该动态照片大图
  await Multimedia_Gallery_Motion_picture_003Expects(dt);
  dt.log.i('动态照片支持长按播放 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Motion_picture_003Expects(dt: Dt): Promise<void> {
  // 1、动态照片宫格缩略图显示清晰无异常
  await dt.showComponentsWithin();
  // 2、能够正常播放动态照片，且播放清晰度正常，声音无异常，默认动态照片播放时长3s

}

/**
 * 大图-动态照片用例: [不同入口长按播放动态照片] TID: Multimedia_Gallery_Motion_picture_004
 * 前置条件
 * 1、准备动态照片（可以使用相机拍摄动态照片）
 */
async function Multimedia_Gallery_Motion_picture_004(dt: Dt) {
  dt.log.i('不同入口长按播放动态照片 start');
  // 测试步骤
  // 1、从图库照片页进入动态照片大图长按播放
  await dt.sleep(DELAY.short);
  // 2、从图片相册进入动态照片大图长按播放
  await dt.sleep(DELAY.short);
  // 3、从智慧相册（人像相册、地点相册、分类相册、拍摄模式）进入动态照片大图长按播放
  await dt.sleep(DELAY.short);
  // 4、从搜索入口进入动态照片大图长按播放
  try {
    await abilityDelegator.startAbility(TestConstants.SMART_PICKER_DRIVER_LICENSE_WANT).then(() => {
      dt.log.i('start photo success with smart picker');
    });
  } catch (exception) {
    expect(0).assertEqual(exception.code);
    dt.log.i(`start failed :${exception.code}`);
  } finally {
    dt.log.i('start photo application');
  }
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  if (await dt.driver.findComponent(ON.text('全部'))) {
    await dt.assertComponentByText('全部');
  }
  if (await dt.driver.findComponent(ON.text('驾驶证'))) {
    await dt.assertComponentByText('驾驶证');
  }
  await Multimedia_Gallery_Motion_picture_004Expects(dt);
  dt.log.i('不同入口长按播放动态照片 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Motion_picture_004Expects(dt: Dt): Promise<void> {
  // 1-10、支持长按播放动态照片，且播放清晰度正常，声音无异常

}

/**
 * 大图-动态照片用例: [动态照片长按播放支持松手停止播放] TID: Multimedia_Gallery_Motion_picture_015
 * 前置条件
 * 1、准备动态照片（可以使用相机拍摄动态照片）
 */
async function Multimedia_Gallery_Motion_picture_015(dt: Dt) {
  dt.log.i('动态照片长按播放支持松手停止播放 start');
  // 测试步骤
  // 1、从图库照片页进入动态照片大图
  await dt.sleep(DELAY.short);
  // 2、长按该动态照片大图播放，并且在播放过程中松手
  await Multimedia_Gallery_Motion_picture_015Expects(dt);
  dt.log.i('动态照片长按播放支持松手停止播放 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Motion_picture_015Expects(dt: Dt): Promise<void> {
  // 2、松手停止播放

}

/**
 * 大图-动态照片用例: [动态照片支持自动播放] TID: Multimedia_Gallery_Motion_picture_021
 * 前置条件
 * 1、图库存在动态照片，且动态照片效果设置为动态照片
 */
async function Multimedia_Gallery_Motion_picture_021(dt: Dt) {
  dt.log.i('动态照片支持自动播放 start');
  // 测试步骤
  // 1、从照片页宫格进入大图，左右滑动到动态照片
  await Multimedia_Gallery_Motion_picture_021Expects(dt);
  dt.log.i('动态照片支持自动播放 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Motion_picture_021Expects(dt: Dt): Promise<void> {
  // 1、动态照片自动播放一次后停止，播放过程无异常，停止后动态照片停留在封面帧

}

/**
 * 大图-动态照片用例: [动态照片效果播放正常] TID: Multimedia_Gallery_Motion_picture_024
 * 前置条件
 * 1、图库存在动态照片，且动态照片效果默认设置为动态照片
 */
async function Multimedia_Gallery_Motion_picture_024(dt: Dt) {
  dt.log.i('动态照片效果播放正常 start');
  // 测试步骤
  // 1、照片页进入动态照片大图，动态照片效果切换为循环播放
  await dt.sleep(DELAY.short);
  // 2、动态照片效果切换为主角时刻，效果切换完成后，长按动态照片大图
  await dt.sleep(DELAY.short);
  // 3、动态照片效果切换为运动轨迹，效果切换完成后，长按动态照片大图
  try {
    await abilityDelegator.startAbility(TestConstants.SMART_PICKER_DRIVING_LICENSE_WANT).then(() => {
      dt.log.i('start photo success with smart picker');
    });
  } catch (exception) {
    expect(0).assertEqual(exception.code);
    dt.log.i(`start failed :${exception.code}`);
  } finally {
    dt.log.i('start photo application');
  }
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  if (await dt.driver.findComponent(ON.text('全部'))) {
    await dt.assertComponentByText('全部');
  }
  if (await dt.driver.findComponent(ON.text('行驶证'))) {
    await dt.assertComponentByText('行驶证');
  }
  // 5、动态照片效果切换为动态照片，效果切换完成后，长按动态照片大图
  await Multimedia_Gallery_Motion_picture_024Expects(dt);
  dt.log.i('动态照片效果播放正常 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Motion_picture_024Expects(dt: Dt): Promise<void> {
  // 1、效果切换完成后，动态照片自动循环播放，是从开头-结尾的循环播放，播放过程无异常
  await dt.showComponentsWithin();
  // 2、效果为主角时刻，长按播放，播放过程无异常，播放一次后停止，不松手时动态照片停在尾帧，松手后动态照片停留在封面帧
  await dt.showComponentsWithin();
  // 3、效果为运动轨迹，长按播放，播放过程无异常，播放一次后停止，不松手时动态照片停在尾帧，松手后动态照片停留在封面帧
  await dt.showComponentsWithin();
  // 4、关闭动态照片播放效果，不论是否长按，动态照片都无法播放
  await dt.showComponentsWithin();
  // 5、效果为动态照片，长按播放，播放过程无异常，播放一次后停止，不松手时动态照片停在尾帧，松手后动态照片停留在封面帧

}

/**
 * 大图-动态照片用例: [不同入口动态照片支持导出视频] TID: Multimedia_Gallery_Dynamic_Photo_Export_001
 * 前置条件
 * 相机拍摄多张动态照片
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_001(dt: Dt) {
  dt.log.i('不同入口动态照片支持导出视频 start');
  // 测试步骤
  // 1、从照片宫格页打开动态照片，导出视频
  await dt.sleep(DELAY.short);
  // 2、从相机入口打开动态照片，导出视频
  await dt.sleep(DELAY.short);
  // 3、从用户创建相册打开动态照片，导出视频
  try {
    await abilityDelegator.startAbility(TestConstants.SMART_PICKER_FEATURED_SINGLE_PORTRAIT_WANT).then(() => {
      dt.log.i('start photo success with smart picker');
    });
  } catch (exception) {
    expect(0).assertEqual(exception.code);
    dt.log.i(`start failed :${exception.code}`);
  } finally {
    dt.log.i('start photo application');
  }
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  if (await dt.driver.findComponent(ON.text('全部'))) {
    await dt.assertComponentByText('全部');
  }
  if (await dt.driver.findComponent(ON.text('精选单人像'))) {
    await dt.assertComponentByText('精选单人像');
  }
  await Multimedia_Gallery_Dynamic_Photo_Export_001Expects(dt);
  dt.log.i('不同入口动态照片支持导出视频 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_001Expects(dt: Dt): Promise<void> {
  // 1-4、导出后跳转到新视频，可以正常播放，视频内容和动态照片一致
  await dt.showComponentsWithin();
  // 5、导出后停留当前页面，toats提示“导出成功，可在视频相册查看“
  await dt.showComponentsWithin();
  // 6、所有导出的视频都新增在视频相册内，正常播放

}

/**
 * 大图-动态照片用例: [动态照片导出视频界面ux显示] TID: Multimedia_Gallery_Dynamic_Photo_Export_003
 * 前置条件
 * 图库存在动态照片，普通图片，视频
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_003(dt: Dt) {
  dt.log.i('动态照片导出视频界面ux显示 start');
  // 测试步骤
  // 1、宫格页/相机入口/用户创建相册/图片相册/来源相册打开动态照片，点击右上角四方菜单
  await dt.sleep(DELAY.short);
  // 2、隐藏相册、删除相册打开动态照片，点击右上角四方菜单
  await dt.sleep(DELAY.short);
  // 3、宫格页打开普通图片，点击右上角四方菜单
  await dt.sleep(DELAY.short);
  // 4、宫格页打开视频，点击右上角四方菜单
  await Multimedia_Gallery_Dynamic_Photo_Export_003Expects(dt);
  dt.log.i('动态照片导出视频界面ux显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Dynamic_Photo_Export_003Expects(dt: Dt): Promise<void> {
  // 1、菜单显示导出视频选项，显示在详细信息之上
  await dt.showComponentsWithin();
  // 2、菜单无导出视频选项
  await dt.showComponentsWithin();
  // 3、菜单无导出视频选项
  await dt.showComponentsWithin();
  // 4、菜单无导出视频选项

}

/**
 * 大图-动态照片用例: [动态照片效果切换] TID: Multimedia_Gallery_Motion_picture_023
 * 前置条件
 * 1、手机保持稳定，相机拍摄动态照片（覆盖普通动态照片、带水印动态照片、云增强动态照片、编辑后的动态照片，各比例动态照片等；可多场景叠加）
 */
async function Multimedia_Gallery_Motion_picture_023(dt: Dt) {
  dt.log.i('动态照片效果切换 start');
  // 测试步骤
  // 1、动态照片效果切换为循环播放
  await dt.sleep(DELAY.short);
  // 2、动态照片效果切换为来回播放
  await dt.sleep(DELAY.short);
  // 3、动态照片效果切换为主角时刻
  await dt.sleep(DELAY.short);
  // 4、动态照片效果切换为运动轨迹
  await dt.sleep(DELAY.short);
  // 5、动态照片效果切换为微动瞬间
  await dt.sleep(DELAY.short);
  // 6、动态照片效果切换为关闭
  await dt.sleep(DELAY.short);
  // 7、动态照片效果切换为动态照片
  await Multimedia_Gallery_Motion_picture_023Expects(dt);
  dt.log.i('动态照片效果切换 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Motion_picture_023Expects(dt: Dt): Promise<void> {
  // 1-7、效果切换完成，封面显示正常，播放效果正常；微动瞬间需主体为人/猫/狗，否则效果退化为循环播放，但是界面显示微动瞬间

}

/**
 * 大图-动态照片用例: [动态照片支持云增强] TID: Multimedia_Gallery_AICloudEnhancementService_007
 * 前置条件
 * 1、手机连接WIFI
 */
async function Multimedia_Gallery_AICloudEnhancementService_007(dt: Dt) {
  dt.log.i('动态照片支持云增强 start');
  // 测试步骤
  // 1、相机拍摄动态照片(人像、超级微距、长焦等)
  await dt.sleep(DELAY.short);
  // 2、进入图库，打开新拍的图片
  await dt.sleep(DELAY.short);
  // 3、点击云增强图标
  await dt.sleep(DELAY.short);
  // 4、点击增强的动态照片切换效果
  await dt.sleep(DELAY.short);
  //
  await Multimedia_Gallery_AICloudEnhancementService_007Expects(dt);
  dt.log.i('动态照片支持云增强 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_AICloudEnhancementService_007Expects(dt: Dt): Promise<void> {
  // 3、可以正常触发云增强，增强后的图片显示正常
  await dt.showComponentsWithin();
  // 4、效果切换正常，播放效果正常

}

/**
 * 大图-动态照片用例: [自动云增强-水印动态照片支持自动云增强] TID: Multimedia_Gallery_Automatic_Cloudenhancement_18
 * 前置条件
 * 1、设备支持自动云增强
 2、设备连接网络（WiFi/移动数据）
 3、图库开启AI云增强
 4、图库开启自动云增强
 5、设备温度不高于37°电量不低于20%
 */
async function Multimedia_Gallery_Automatic_Cloudenhancement_18(dt: Dt) {
  dt.log.i('自动云增强-水印动态照片支持自动云增强 start');
  // 测试步骤
  // 1.相机拍摄多张可支持自动云增强的带水印动态照片
  await dt.swipeScreen?.left();
  // 2.等待1-2min
  await dt.sleep(DELAY.short);
  // 3.查看新生成的云增强照片是否有对比按钮
  await Multimedia_Gallery_Automatic_Cloudenhancement_18Expects(dt);
  dt.log.i('自动云增强-水印动态照片支持自动云增强 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Automatic_Cloudenhancement_18Expects(dt: Dt): Promise<void> {
  // 2.照片页自动生成云增强动态照片，照片无异常
  await dt.showComponentsWithin();
  // 3.云增强照片有对比按钮

}

/**
 * 大图-动态照片用例: [自动云增强-自动云增强后的水印动态照片无对比按钮] TID: Multimedia_Gallery_Automatic_Cloudenhancement_20
 * 前置条件
 * 1、设备支持自动云增强
 2、设备连接网络（WiFi/移动数据）
 3、图库开启AI云增强
 4、图库开启自动云增强
 5、设备温度不高于37°电量不低于20%
 */
async function Multimedia_Gallery_Automatic_Cloudenhancement_20(dt: Dt) {
  dt.log.i('自动云增强-自动云增强后的水印动态照片无对比按钮 start');
  // 测试步骤
  // 1.相机拍摄多张可支持自动云增强的带水印动态照片
  await dt.swipeScreen?.left();
  // 2.等待1-2min
  await dt.sleep(DELAY.short);
  // 3.删除原图
  await dt.sleep(DELAY.short);
  // 4.查看云增强照片是否有对比按钮
  await Multimedia_Gallery_Automatic_Cloudenhancement_20Expects(dt);
  dt.log.i('自动云增强-自动云增强后的水印动态照片无对比按钮 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Automatic_Cloudenhancement_20Expects(dt: Dt): Promise<void> {
  // 2.照片页自动生成云增强动态照片，照片无异常
  await dt.showComponentsWithin();
  // 3.云增强照片无对比按钮

}

/**
 * 大图-动态照片用例: [不同入口打开动态图片界面显示] TID: Multimedia_Gallery_VideoPlayer_Frame_002
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_002(dt: Dt) {
  dt.log.i('不同入口打开动态图片界面显示 start');
  // 测试步骤
  // 1、从照片宫格，相册（系统相册，三方相册，来源相册，地点相册）入口进入查看动态图片，观察界面布局
  await dt.sleep(DELAY.short);
  // 2、从隐藏相册入口进入查看大图，观察界面布局
  await dt.sleep(DELAY.short);
  // 3、从最近删除相册入口进入查看大图，观察界面布局
  await dt.sleep(DELAY.short);
  // 4、相机入口进大图
  await dt.sleep(DELAY.short);
  // 5、锁屏相机入口进大图
  await dt.sleep(DELAY.short);
  //
  await Multimedia_Gallery_VideoPlayer_Frame_002Expects(dt);
  dt.log.i('不同入口打开动态图片界面显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_VideoPlayer_Frame_002Expects(dt: Dt): Promise<void> {
  // 1、底部tab依次分享，收藏，动态照片图标，编辑，删除按钮，右上角显示四方菜单按钮和云增强按钮
  await dt.showComponentsWithin();
  // 2、底部tab依次显示收藏，动态照片图标，编辑，删除，右上角显示四方菜单
  await dt.showComponentsWithin();
  // 3、底部tab依次显示复原，动态照片图标，删除，右上角显示四方菜单
  await dt.showComponentsWithin();
  // 4、底部tab依次显示分享，收藏，动态照片图标，编辑，删除按钮，右上角显示四方菜单按钮和图库入口图标
  await dt.showComponentsWithin();
  // 5、同相机入口显示一致

}
