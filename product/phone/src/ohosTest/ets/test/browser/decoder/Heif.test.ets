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
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { common } from '@kit.AbilityKit';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { AsyncCallback } from '@ohos/common/src/main/ets/default/model/common/AsyncCallback';
import { QueryParam } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';
import { Size } from '@kit.ArkUI';

export default function HeifTest(): void {
  describe('HeifTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    // 确认当前图库app处于启动状态
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAllHeifTest').init();
      await AppStart.photos();
      dt.log.i('beforeAll HeifTest finish');
    });
    it('beforeHeifTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      // 进入图库
      await dt.browser();
    });
    it('Multimedia_Gallery_SR20240305625869_003', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-heif用例: [heif格式4.5K以内图片直接解码原图] TID: Multimedia_Gallery_SR20240305625869_003
      await Multimedia_Gallery_SR20240305625869_003(dt);
    });
    it('Multimedia_Gallery_SR20240305625869_004', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-heif用例: [heif格式4.5K以外图片先解码LCD图再显示] TID: Multimedia_Gallery_SR20240305625869_004
      await Multimedia_Gallery_SR20240305625869_004(dt);
    });
    it('Multimedia_Gallery_PhotoBrowser_HEIC_001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [相机拍摄的不同HEIF格式图片显示] TID: Multimedia_Gallery_PhotoBrowser_HEIC_001
      await Multimedia_Gallery_PhotoBrowser_HEIC_001(dt);
    });
    it('Multimedia_Gallery_PhotoBrowser_HEIC_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-HEIF用例: [宫格进大图-HEIF图片-一次性全图解码] TID: Multimedia_Gallery_PhotoBrowser_HEIC_002
      await Multimedia_Gallery_PhotoBrowser_HEIC_002(dt);
    });
    it('Multimedia_Gallery_Motion_picture_060', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-heif用例: [heif格式动态照片动态效果抠图] TID: Multimedia_Gallery_Motion_picture_060
      await Multimedia_Gallery_Motion_picture_060(dt);
    });
    it('Multimedia_Gallery_Motion_picture_045', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-heif用例: [heif格式动态照片效果切换] TID: Multimedia_Gallery_Motion_picture_045
      await Multimedia_Gallery_Motion_picture_045(dt);
    });

    // 退出大图 回到时间线页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllHeifTest').init();
      await Exit.browser();
      dt.log.i('afterAll HeifTest finish');
    });
    // 确保每次测试完毕回到大图页
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachHeifTest').init();
      dt.log.i('afterEach HeifTest finish');
    });
  });
}

/**
 * 大图-heif用例: [heif格式4.5K以内图片直接解码原图] TID: Multimedia_Gallery_SR20240305625869_003
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20240305625869_003(dt: Dt) {
  dt.log.i('heif格式4.5K以内图片直接解码原图 start');
  // 测试步骤
  // 1、图库中任意heif格式4.5K以内的照片大图浏览；
  await dt.sleep(DELAY.short);
  // 2、查看日志
  await Multimedia_Gallery_SR20240305625869_003Expects(dt);
  dt.log.i('heif格式4.5K以内图片直接解码原图 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_SR20240305625869_003Expects(dt: Dt): Promise<void> {
  // 1、大图浏览加载正常，无卡顿、刷新等场景
  await dt.showComponentsWithin();
  // 2、通过日志查看直接解码原图，日志只打印picture decode mime, pixelmapFormat 11

}

/**
 * 大图-heif用例: [heif格式4.5K以外图片先解码LCD图再显示] TID: Multimedia_Gallery_SR20240305625869_004
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20240305625869_004(dt: Dt) {
  dt.log.i('heif格式4.5K以外图片先解码LCD图再显示 start');
  // 测试步骤
  // 1、图库中任意jpeg格式4.5K以外的照片大图浏览；
  await dt.sleep(DELAY.short);
  // 2、查看日志
  await Multimedia_Gallery_SR20240305625869_004Expects(dt);
  dt.log.i('heif格式4.5K以外图片先解码LCD图再显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_SR20240305625869_004Expects(dt: Dt): Promise<void> {
  // 1、大图浏览加载正常，无卡顿、刷新等场景
  await dt.showComponentsWithin();
  // 2、通过日志查看先解码LCD图再显示，日志只打印picture decode mime, pixelmapFormat 3

}

/**
 * 大图-HEIF用例: [相机拍摄的不同HEIF格式图片显示] TID: Multimedia_Gallery_PhotoBrowser_HEIC_001
 * 前置条件
 * 1、xxx手机，相机设置拍摄格式为HEIF，拍摄图片超过50张
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_001(dt: Dt) {
  dt.log.i('相机拍摄的不同HEIF格式图片显示 start');
  // 测试步骤
  // 1、相机拍摄多张照片
  await dt.sleep(DELAY.short);
  // （依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像）
  // 2、从不同入口：相机入口，照片页，相册页浏览图片
  await Multimedia_Gallery_PhotoBrowser_HEIC_001Expects(dt);
  dt.log.i('相机拍摄的不同HEIF格式图片显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_001Expects(dt: Dt): Promise<void> {
  // 2、所有入口图片显示正常

}

/**
 * 大图-HEIF用例: [宫格进大图-HEIF图片-一次性全图解码] TID: Multimedia_Gallery_PhotoBrowser_HEIC_002
 * 前置条件
 * 1、预制HEIC图片分辨率(a*b)<=10K*10K(乘积），且最长边不超过16k(例如：16000*6250)
 设备：
 HL设备：KDY、OMJ、PNH、LLS
 cepi设备：PLR、PLA、PLU
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_002(dt: Dt) {
  dt.log.i('宫格进大图-HEIF图片-一次性全图解码 start');
  // 测试步骤
  // 1、宫格打开大图,图片分辨率为a*b (例如（16000*6250）
  // hilog | grep onThumbnailLoaded isCurrent
  await dt.sleep(DELAY.short);
  // 
  await Multimedia_Gallery_PhotoBrowser_HEIC_002Expects(dt);
  dt.log.i('宫格进大图-HEIF图片-一次性全图解码 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_002Expects(dt: Dt): Promise<void> {
  // 1、检测点;打开大图显示清晰
  await dt.showComponentsWithin();
  // 2、有关键日志： submit high request {desiredSize:{width:a,height:b}
  await dt.showComponentsWithin();
  // 备注：此数字为举例，具体数值和图片分辨率保持一致
  await dt.showComponentsWithin();
  // 3、有解码完成的关键日志：onThumbnailLoaded isCurrent: true
  await dt.showComponentsWithin();
  // 和width:a,height:b, 

}

/**
 * 大图-heif用例: [heif格式动态照片动态效果抠图] TID: Multimedia_Gallery_Motion_picture_060
 * 前置条件
 * 1、相机切换heif格式拍摄带主体动态照片（尽量保持主体一直在画面内）
 */
async function Multimedia_Gallery_Motion_picture_060(dt: Dt) {
  dt.log.i('heif格式动态照片动态效果抠图 start');
  // 测试步骤
  // 1、设置动态照片效果为动态照片效果
  // 2、长按主体抠图
  await Multimedia_Gallery_Motion_picture_060Expects(dt);
  dt.log.i('heif格式动态照片动态效果抠图 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Motion_picture_060Expects(dt: Dt): Promise<void> {
  // 2、支持动态抠图

}

/**
 * 大图-heif用例: [heif格式动态照片效果切换] TID: Multimedia_Gallery_Motion_picture_045
 * 前置条件
 * 1、相机拍摄heif格式动态照片（覆盖普通动态照片、带水印动态照片、云增强动态照片、编辑后的动态照片，各比例动态照片等；可多场景叠加）
 */
async function Multimedia_Gallery_Motion_picture_045(dt: Dt) {
  dt.log.i('heif格式动态照片效果切换 start');
  // 测试步骤
  // 1、heif格式动态照片各效果切换，并进行播放
  await dt.sleep(DELAY.short);
  // 2、heif格式动态照片宫格操作、大图操作
  await Multimedia_Gallery_Motion_picture_045Expects(dt);
  dt.log.i('heif格式动态照片效果切换 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Motion_picture_045Expects(dt: Dt): Promise<void> {
  // 1、heif格式动态照片效果播放无异常
  await dt.showComponentsWithin();
  // 2、heif格式动态照片非效果切换操作与图片一致，编辑为视频编辑

}

/**
 * 预期结果
 */
async function Multimedia_Gallery_AICloudEnhancementService_008Expects(dt: Dt): Promise<void> {
  // 3、可以正常触发云增强，增强后的图片显示正常

}
