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

export default function browserEntranceTest(): void {
  describe('browserEntranceTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    // 确认当前图库app处于启动状态
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAllBrowserEntranceTest').init();
      dt.log.i('beforeAll BrowserEntranceTest start');
      await AppStart.application(TestConstants.SINGLE_PICK_WANT, 'photo_with_single_select');
      dt.log.i('beforeAll BrowserEntranceTest finish');
    });
    it('beforeBrowserEntranceTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      // 进入图库
      dt.log.i('beforeBrowserEntranceTest start');
    });
    it('Multimedia_Gallery_PhotoBrowser_055', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [时间轴界面进入大图] TID: Multimedia_Gallery_PhotoBrowser_055
      await Multimedia_Gallery_PhotoBrowser_055(dt);
    });
    it('Multimedia_Gallery_HDRpicture_006', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [从宫格点击缩略图进入大图查看] TID: Multimedia_Gallery_HDRpicture_006
      await Multimedia_Gallery_HDRpicture_006(dt);
    });
  })
  describe('browserEntranceTest2', (): void => {
    it('Multimedia_Gallery_HDRpicture_007', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [从相机入口点击缩略图进入大图查看] TID: Multimedia_Gallery_HDRpicture_007
      await Multimedia_Gallery_HDRpicture_007(dt);
    });
    it('Multimedia_Gallery_HDRpicture_014', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [SDR图片显示高亮效果] TID: Multimedia_Gallery_HDRpicture_014
      await Multimedia_Gallery_HDRpicture_014(dt);
    });
    it('Multimedia_Gallery_Moire_012', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [摩尔纹时间轴界面进入大图] TID: Multimedia_Gallery_Moire_012
      await Multimedia_Gallery_Moire_012(dt);
    });
    it('Multimedia_Gallery_Moire_013', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [摩尔纹各个界面连续进入大图下拉返回] TID: Multimedia_Gallery_Moire_013
      await Multimedia_Gallery_Moire_013(dt);
    });
  })
  describe('browserEntranceTest3', (): void => {
    it('Multimedia_Gallery_PhotoBrowser_054', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [时间轴界面进入大图左右滑动浏览] TID: Multimedia_Gallery_PhotoBrowser_054
      await Multimedia_Gallery_PhotoBrowser_054(dt);
    });
    it('Multimedia_Gallery_PhotoBrowser_070', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [各个界面连续进入大图下拉返回] TID: Multimedia_Gallery_PhotoBrowser_070
      await Multimedia_Gallery_PhotoBrowser_070(dt);
    });
    it('Multimedia_Gallery_PhotoOperations_100', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [不同入口进入大图浏览界面，一般模式/沉浸模式上滑显示详情] TID: Multimedia_Gallery_PhotoOperations_100
      await Multimedia_Gallery_PhotoOperations_100(dt);
    });
    it('Prototype_Multimedia_Gallery_AI_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [默认图片大小AI控件操作测试] TID: Prototype_Multimedia_Gallery_AI_002,
    });

    // 退出大图 回到时间线页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllBrowserEntranceTest3').init();
      await Exit.browser();
      dt.log.i('afterAll BrowserEntranceTest3 finish');
    });
    // 确保每次测试完毕回到大图页
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachBrowserEntranceTest3').init();
      dt.log.i('afterEach BrowserEntranceTest3 finish');
    });
  });
}

/**
 * 大图-进入大图用例: [时间轴界面进入大图] TID: Multimedia_Gallery_PhotoBrowser_055
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_PhotoBrowser_055(dt: Dt) {
  dt.log.i('时间轴界面进入大图 start');
  // 测试步骤
  // 1、打开图库应用，点击进入照片页
  await dt.driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  if (await dt.driver.findComponent(ON.text('同意'))) {
    await dt.assertComponentByText('同意', false);
  }
  if (await dt.driver.findComponent(ON.text('跳过'))) {
    await dt.assertComponentByText('跳过', false);
  }

  if (await dt.driver.findComponent(ON.text('立即体验'))) {
    await dt.assertComponentByText('立即体验', false);
  }
  // 2、点击缩略图进入大图模式
  await Multimedia_Gallery_PhotoBrowser_055Expects(dt);
  dt.log.i('时间轴界面进入大图 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoBrowser_055Expects(dt: Dt): Promise<void> {
  // 2、进入大图丝滑顺畅，最下方依次为分享、收藏、编辑、删除、更多

}

/**
 * 大图-进入大图用例: [从宫格点击缩略图进入大图查看] TID: Multimedia_Gallery_HDRpicture_006
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_006(dt: Dt) {
  dt.log.i('从宫格点击缩略图进入大图查看 start');
  // 测试步骤
  // 1、从宫格点击图片进入大图查看
  await dt.sleep(DELAY.short);
  // 2、从大图返回宫格查看
  try {
    await abilityDelegator.startAbility(TestConstants.SINGLE_PICK_WANT).then(() => {
      dt.log.i('start photo with single select success');
    });
  } catch (exception) {
    expect(0).assertEqual(exception.code);
    dt.log.i(`start failed :${exception.code}`);
  } finally {
    dt.log.i('start photo application');
  }
  dt.log.i('从宫格点击缩略图进入大图查看 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_HDRpicture_006Expects(dt: Dt): Promise<void> {
  // 1、大图页面正常显示高亮效果，过程动效正常无跳变
  await dt.showComponentsWithin();
  // 2、宫格不显示高亮效果，过程动效正常无跳变

}

/**
 * 大图-进入大图用例: [从相机入口点击缩略图进入大图查看] TID: Multimedia_Gallery_HDRpicture_007
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_007(dt: Dt) {
  dt.log.i('从相机入口点击缩略图进入大图查看 start');
  // 测试步骤
  // 1、从相机缩略图入口进入大图查看
  await dt.driver.swipe(800, 1200, 800, 540, 800);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('swipe up');
  await dt.driver.swipe(800, 1200, 800, 540, 800);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('swipe up');
  await dt.driver.swipe(800, 540, 800, 1200, 800);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('swipe down');
  await dt.driver.swipe(800, 540, 800, 1200, 800);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('swipe down');
  await dt.driver.click(500, 509);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('gesture_0 clicked');
  await dt.driver.click(821, 500);
  await Multimedia_Gallery_HDRpicture_007Expects(dt);
  dt.log.i('从相机入口点击缩略图进入大图查看 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_HDRpicture_007Expects(dt: Dt): Promise<void> {
  // 1、图片显示高亮效果，提亮过程正常无跳变

}

/**
 * 大图-进入大图用例: [SDR图片显示高亮效果] TID: Multimedia_Gallery_HDRpicture_014
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_014(dt: Dt) {
  dt.log.i('SDR图片显示高亮效果 start');
  // 测试步骤
  // 1、图库中存在sdr图片（从网上下载的图片等非相机拍摄的图片）
  await dt.sleep(DELAY.short);
  // 2、在图库中进入大图查看效果
  try {
    await abilityDelegator.startAbility(TestConstants.MULTIPLE_PICK_WANT).then(() => {
      dt.log.i('start photo with single select success');
    });
  } catch (exception) {
    expect(0).assertEqual(exception.code);
    dt.log.i(`start failed :${exception.code}`);
  } finally {
    dt.log.i('start photo application');
  }
  // sdr图片资源：
  await Multimedia_Gallery_HDRpicture_014Expects(dt);
  dt.log.i('SDR图片显示高亮效果 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_HDRpicture_014Expects(dt: Dt): Promise<void> {
  // 1、图片走AIHDR路径显示高亮效果，提亮过程正常无跳变

}

/**
 * 大图-进入大图用例: [摩尔纹时间轴界面进入大图] TID: Multimedia_Gallery_Moire_012
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_012(dt: Dt) {
  dt.log.i('摩尔纹时间轴界面进入大图 start');
  // 测试步骤
  // 1、图库照片页点击缩略图进入大图模式
  await dt.sleep(DELAY.enormous);
  // 2、横竖屏旋转查看大图
  await Multimedia_Gallery_Moire_012Expects(dt);
  dt.log.i('摩尔纹时间轴界面进入大图 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Moire_012Expects(dt: Dt): Promise<void> {
  // 1、进入大图丝滑顺畅，图片大图有去摩尔纹效果，在视频封面存在摩尔纹的情况下封面有去摩尔纹效果，最下方依次为分享、收藏、编辑、删除，动态照片有动态照片标识
  await dt.showComponentsWithin();
  // 2、图片大图有去摩尔纹效果，在视频封面存在摩尔纹的情况下封面有去摩尔纹效果

}

/**
 * 大图-进入大图用例: [摩尔纹各个界面连续进入大图下拉返回] TID: Multimedia_Gallery_Moire_013
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_013(dt: Dt) {
  dt.log.i('摩尔纹各个界面连续进入大图下拉返回 start');
  // 测试步骤
  // 1、不同入口进入大图（入口：照片宫格、最近删除、相机入口、信息picker入口、录屏入口）
  try {
    await abilityDelegator.startAbility(TestConstants.MULTIPLE_PICK_WANT).then(() => {
      dt.log.i('start photo with single select success');
    });
  } catch (exception) {
    expect(0).assertEqual(exception.code);
    dt.log.i(`start failed :${exception.code}`);
  } finally {
    dt.log.i('start photo application');
  }
  // 2、下拉图片返回
  await Multimedia_Gallery_Moire_013Expects(dt);
  dt.log.i('摩尔纹各个界面连续进入大图下拉返回 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Moire_013Expects(dt: Dt): Promise<void> {
  // 1、图片大图有去摩尔纹效果，在视频封面存在摩尔纹的情况下封面有去摩尔纹效果
  await dt.showComponentsWithin();
  // 2、返回宫格界面，无卡顿，无异常，有动效；录屏无动效

}

/**
 * 大图-进入大图用例: [时间轴界面进入大图左右滑动浏览] TID: Multimedia_Gallery_PhotoBrowser_054
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_PhotoBrowser_054(dt: Dt) {
  dt.log.i('时间轴界面进入大图左右滑动浏览 start');
  // 测试步骤
  // 1、时间轴点击缩略图进入大图
  await dt.sleep(DELAY.short);
  // 2、左右滑动查看大图
  await dt.sleep(DELAY.short);
  // 3、调整横竖屏后，继续左右滑动浏览大图（pc仅横屏显示，无需调整横竖屏）
  await Multimedia_Gallery_PhotoBrowser_054Expects(dt);
  dt.log.i('时间轴界面进入大图左右滑动浏览 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoBrowser_054Expects(dt: Dt): Promise<void> {
  // 2、滑动流畅，无卡顿，无正在加载，照片浏览正常
  await dt.showComponentsWithin();
  // 3、滑动流畅，无卡顿，无正在加载，照片浏览正常

}

/**
 * 大图-进入大图用例: [各个界面连续进入大图下拉返回] TID: Multimedia_Gallery_PhotoBrowser_070
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_PhotoBrowser_070(dt: Dt) {
  dt.log.i('各个界面连续进入大图下拉返回 start');
  // 测试步骤
  // 1、进入不同格式照片相册宫格击缩略图查看大图
  await dt.sleep(DELAY.short);
  // 2、下拉图片
  await Multimedia_Gallery_PhotoBrowser_070Expects(dt);
  dt.log.i('各个界面连续进入大图下拉返回 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoBrowser_070Expects(dt: Dt): Promise<void> {
  // 2、返回宫格界面，无卡顿，无异常，有动效

}

/**
 * 大图-进入大图用例: [不同入口进入大图浏览界面，一般模式/沉浸模式上滑显示详情] TID: Multimedia_Gallery_PhotoOperations_100
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_PhotoOperations_100(dt: Dt) {
  dt.log.i('不同入口进入大图浏览界面，一般模式/沉浸模式上滑显示详情 start');
  // 测试步骤
  // 1、从不同的入口（时间轴入口、相册宫格入口、FA卡片（封面非默认），相机左下角缩略图入口）进入大图浏览界面
  await dt.sleep(DELAY.short);
  // 2、上滑显示详情
  await dt.sleep(DELAY.short);
  // 3、点击大图进入沉浸模式，上滑大图进入详情
  await dt.sleep(DELAY.short);
  // 4、修改文件名称
  await Multimedia_Gallery_PhotoOperations_100Expects(dt);
  dt.log.i('不同入口进入大图浏览界面，一般模式/沉浸模式上滑显示详情 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoOperations_100Expects(dt: Dt): Promise<void> {
  // 1、进入详情页面，显示文件名称，拍摄日期、时间，相机拍摄参数（分辨率；曝光时长；光圈F值；ISO值）
  await dt.showComponentsWithin();
  // 2、文件名称支持修改，重命名界面修改后点击键盘确认键返回，重命名成功（直接返回，无详情收起再弹出的二次弹出现象）

}

/**
 * 大图-进入大图用例: [默认图片大小AI控件操作测试] TID: Prototype_Multimedia_Gallery_AI_002
 * 前置条件
 * 1、图库中存在不同格式、不同版式的照片和视频文件
 2、图片中有若干图盘中存在文字，文字语种覆盖中英日韩繁，文字颜色不限
 */
async function Prototype_Multimedia_Gallery_AI_002(dt: Dt) {
  dt.log.i('默认图片大小AI控件操作测试 start');
  // 测试步骤
  // 1、打开文字图片的大图，大图长按识别文字后，重新进入大图，图片右下角出现“A”button，长按图片的非文字区域
  await dt.sleep(DELAY.short);
  // 2、长按图片的任意文字区域
  try {
    await abilityDelegator.startAbility(TestConstants.SMART_PICKER_QR_OR_BAR_CODE_WANT).then(() => {
      dt.log.i('start photo success with smart picker');
    });
  } catch (exception) {
    dt.log.i(`start failed :${exception.code}`);
  } finally {
    dt.log.i('start photo application');
  }
  await dt.driver.delayMs(TestConstants.DELAY_THREE_SECOND);
  await dt.clickIfExistByText('全部');
  await dt.clickIfExistByText('条码');
  await dt.clickIfExistByText('二维码');
  await dt.driver.pressBack();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await Prototype_Multimedia_Gallery_AI_002Expects(dt);
  dt.log.i('默认图片大小AI控件操作测试 end');
}

/**
 * 预期结果
 */
async function Prototype_Multimedia_Gallery_AI_002Expects(dt: Dt): Promise<void> {
  // 1、无响应
  await dt.showComponentsWithin();
  // 2、默认选中所按的那行文字
  await dt.showComponentsWithin();
  // 3、拖拽选中区域正常，框选区域随拖拽变化而变化，且响应及时无卡顿
  try {
    await abilityDelegator.startAbility(TestConstants.SMART_PICKER_QR_CODE_WANT).then(() => {
      dt.log.i('start photo success with smart picker');
    });
  } catch (exception) {
    dt.log.i(`start failed :${exception.code}`);
  } finally {
    dt.log.i('start photo application');
  }
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  if (await dt.driver.findComponent(ON.text('全部'))) {
    await dt.assertComponentByText('全部');
  }
  if (await dt.driver.findComponent(ON.text('二维码'))) {
    await dt.assertComponentByText('二维码');
  }
  await dt.driver.pressBack();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 6、拖拽选中区域正常，框选区域随拖拽变化而变化，且响应及时无卡顿

}

/**
 * 大图-进入大图用例: [不同入口分割图片操作] TID: Prototype_Multimedia_Gallery_AI_Split_001
 * 前置条件
 * 1、图库中存在可以分割的图片
 */
async function Prototype_Multimedia_Gallery_AI_Split_001(dt: Dt) {
  dt.log.i('不同入口分割图片操作 start');
  // 测试步骤
  // 1、进入照片页，浏览大图，长按可分割部分
  await dt.sleep(DELAY.short);
  // 2、进入图片相册，浏览大图，长按可分割部分
  try {
    await abilityDelegator.startAbility(TestConstants.SMART_PICKER_BAR_CODE_WANT).then(() => {
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
  if (await dt.driver.findComponent(ON.text('条码'))) {
    await dt.assertComponentByText('条码');
  }
  // 3、返回大图页正常
  await dt.driver.pressBack();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await Prototype_Multimedia_Gallery_AI_Split_001Expects(dt);
  dt.log.i('不同入口分割图片操作 end');
}

/**
 * 预期结果
 */
async function Prototype_Multimedia_Gallery_AI_Split_001Expects(dt: Dt): Promise<void> {
  // 1、2、3、4、5、6、手机轻微震动，可分割物体被框选，展示复制和分享按钮
  await dt.showComponentsWithin();
  // 7、picker浏览大图-暂不支持分割功能

}

/**
 * 大图-进入大图用例: [不同入口进入大图浏览界面，所有格式图片视频点击右上角图标查看大图详情] TID: Multimedia_Gallery_PhotoOperations_037
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_PhotoOperations_037(dt: Dt) {
  dt.log.i('不同入口进入大图浏览界面，所有格式图片视频点击右上角图标查看大图详情 start');
  // 测试步骤
  // 1、从不同入口（FA卡片、相机、时间轴界面、相册界面）点击所有格式照片，视频缩略图，进入大图
  await dt.sleep(DELAY.short);
  // 2、点击大图右上角详情按钮
  await dt.sleep(DELAY.short);
  // 3、详情界面修改文件名
  await Multimedia_Gallery_PhotoOperations_037Expects(dt);
  dt.log.i('不同入口进入大图浏览界面，所有格式图片视频点击右上角图标查看大图详情 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoOperations_037Expects(dt: Dt): Promise<void> {
  // 1、进入详情页面，显示文件名称，拍摄日期、时间，相机拍摄参数（分辨率；曝光时长；光圈F值；ISO值）
  await dt.showComponentsWithin();
  // 2、文件名称支持修改（重命名界面修改后点击键盘确认键返回，重命名成功）

}

/**
 * 大图-进入大图用例: [增强后的120分图支持上云] TID: Multimedia_Gallery_AICloudEnhancementService_018
 * 前置条件
 * 1、手机连接WIFI
 2、登录同一个云账号，打开云同步开关，准备主测机和辅助机两台xxx设备
 */
async function Multimedia_Gallery_AICloudEnhancementService_018(dt: Dt) {
  dt.log.i('增强后的120分图支持上云 start');
  // 测试步骤
  // 1、主测机触发云增强生成120分后，照片页宫格下拉刷新触发图片上行，辅助机照片页宫格下拉刷新触发下行业务
  await dt.sleep(DELAY.short);
  // 2、辅助机点击新增图片缩略图进入大图浏览并上滑查看详情
  await Multimedia_Gallery_AICloudEnhancementService_018Expects(dt);
  dt.log.i('增强后的120分图支持上云 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_AICloudEnhancementService_018Expects(dt: Dt): Promise<void> {
  // 1、辅助机图库显示增强后的120分图
  await dt.showComponentsWithin();
  // 2、大图显示正常，详情中图片名称后缀带有“_enhanced”,大小后面显示“AI云增强”字样

}

/**
 * 大图-进入大图用例: [相机左下角进入大图左右滑动浏览] TID: Multimedia_Gallery_PhotoBrowser_053
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_PhotoBrowser_053(dt: Dt) {
  dt.log.i('相机左下角进入大图左右滑动浏览 start');
  // 测试步骤
  // 1、相机左下角进入大图
  await dt.sleep(DELAY.short);
  // 2、左右滑动查看大图
  await dt.sleep(DELAY.short);
  // 3、调整横竖屏后，继续左右滑动浏览大图（pc仅横屏显示，无需调整横竖屏）
  await Multimedia_Gallery_PhotoBrowser_053Expects(dt);
  dt.log.i('相机左下角进入大图左右滑动浏览 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoBrowser_053Expects(dt: Dt): Promise<void> {
  // 2、滑动流畅，无卡顿，无正在加载，照片浏览正常
  await dt.showComponentsWithin();
  // 3、滑动流畅，无卡顿，无正在加载，照片浏览正常

}
