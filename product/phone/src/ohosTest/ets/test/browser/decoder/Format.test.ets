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

/**
 * 大图用例
 */
export default function FormatTest(): void {
  describe('FormatTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    // 确认当前图库app处于启动状态
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAllFormatTest').init();
      await AppStart.photos();
      dt.log.i('beforeAll FormatTest finish');
    });
    it('beforeFormatTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      // 进入图库
      await dt.browser();
    });
    it('Multimedia_Gallery_PhotoBrowser_001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [遍历所有常见格式图片和视频（使用图库已有图片视频资源库）] TID: Multimedia_Gallery_PhotoBrowser_001
      await Multimedia_Gallery_PhotoBrowser_001(dt);
    });
    it('Multimedia_Gallery_SR20240305625869_001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [jpeg格式4.5K以内图片直接解码原图] TID: Multimedia_Gallery_SR20240305625869_001
      await Multimedia_Gallery_SR20240305625869_001(dt);
    });
    it('Multimedia_Gallery_SR20240305625869_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [jpeg格式4.5K以外图片先解码LCD图再显示] TID: Multimedia_Gallery_SR20240305625869_002
      await Multimedia_Gallery_SR20240305625869_002(dt);
    });
    it('Multimedia_Gallery_SR20240305625869_005', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [jpeg格式4.5K以内图片预解码] TID: Multimedia_Gallery_SR20240305625869_005
      await Multimedia_Gallery_SR20240305625869_005(dt);
    });
    it('Multimedia_Gallery_PhotoBrowser_HEIC_034', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [云增强图片hefi格式显示] TID: Multimedia_Gallery_PhotoBrowser_HEIC_034
      await Multimedia_Gallery_PhotoBrowser_HEIC_034(dt);
    });
    it('Multimedia_Gallery_PhotoBrowser_HEIC_038', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [hefi格式图片xxx同步（5.1和5.1)] TID: Multimedia_Gallery_PhotoBrowser_HEIC_038
      await Multimedia_Gallery_PhotoBrowser_HEIC_038(dt);
    });
    it('Multimedia_Gallery_VideoPlayer_Frame_081', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [HDR视频不同类型视频显示效果] TID: Multimedia_Gallery_VideoPlayer_Frame_081
      await Multimedia_Gallery_VideoPlayer_Frame_081(dt);
    });
    it('Multimedia_Gallery_VideoPlayer_Frame_082', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [HDR视频播放显示效果] TID: Multimedia_Gallery_VideoPlayer_Frame_082
      await Multimedia_Gallery_VideoPlayer_Frame_082(dt);
    });
    it('Multimedia_Gallery_Continuousphotoshoots_0001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [连拍照片的删除] TID: Multimedia_Gallery_Continuousphotoshoots_0001
      await Multimedia_Gallery_Continuousphotoshoots_0001(dt);
    });
    it('Multimedia_Gallery_Continuousphotoshoots_001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [相机连拍照片拉起大图] TID: Multimedia_Gallery_Continuousphotoshoots_001
      await Multimedia_Gallery_Continuousphotoshoots_001(dt);
    });
    it('Multimedia_Gallery_Continuousphotoshoots_002', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [图库照片页浏览连拍照片] TID: Multimedia_Gallery_Continuousphotoshoots_002
      await Multimedia_Gallery_Continuousphotoshoots_002(dt);
    });
    it('Multimedia_Gallery_Continuousphotoshoots_017', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [连拍照片的保存与删除] TID: Multimedia_Gallery_Continuousphotoshoots_017
      await Multimedia_Gallery_Continuousphotoshoots_017(dt);
    });
    it('Multimedia_Gallery_DeleteScenes_005', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [相机连拍照片后，选择部分或全部删除] TID: Multimedia_Gallery_DeleteScenes_005
      await Multimedia_Gallery_DeleteScenes_005(dt);
    });
    it('Multimedia_Gallery_AICloudEnhancementService_017', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [增强后的120分图支持HDR高显效果] TID: Multimedia_Gallery_AICloudEnhancementService_017
      await Multimedia_Gallery_AICloudEnhancementService_017(dt);
    });

    // 退出大图 回到时间线页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllFormatTest').init();
      await Exit.browser();
      dt.log.i('afterAll FormatTest finish');
    });
    // 确保每次测试完毕回到大图页
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachFormatTest').init();
      dt.log.i('afterEach FormatTest finish');
    });
  });
}

/**
 * 大图-格式用例: [遍历所有常见格式图片和视频（使用图库已有图片视频资源库）] TID: Multimedia_Gallery_PhotoBrowser_001
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_PhotoBrowser_001(dt: Dt) {
  dt.log.i('遍历所有常见格式图片和视频（使用图库已有图片视频资源库） start');
  // 测试步骤
  // 1、点击所有格式照片缩略图查看大图
  await Multimedia_Gallery_PhotoBrowser_001Expects(dt);
  dt.log.i('遍历所有常见格式图片和视频（使用图库已有图片视频资源库） end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoBrowser_001Expects(dt: Dt): Promise<void> {
  // 1、大图显示结果符合预期，和原型机解码能一致；且大图的布局正常，上方控件和下方actionbar显示正常

}

/**
 * 大图-格式用例: [jpeg格式4.5K以内图片直接解码原图] TID: Multimedia_Gallery_SR20240305625869_001
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20240305625869_001(dt: Dt) {
  dt.log.i('jpeg格式4.5K以内图片直接解码原图 start');
  // 测试步骤
  // 1、图库中任意jpeg格式4.5K以内的照片大图浏览；
  await dt.sleep(DELAY.short);
  // 2、查看日志
  await Multimedia_Gallery_SR20240305625869_001Expects(dt);
  dt.log.i('jpeg格式4.5K以内图片直接解码原图 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_SR20240305625869_001Expects(dt: Dt): Promise<void> {
  // 1、大图浏览加载正常，无卡顿、刷新等场景
  await dt.showComponentsWithin();
  // 2、通过日志查看直接解码原图，不再解码LCD图，日志打印picture decode mime, pixelmapFormat 11和No need LcdDocode

}

/**
 * 大图-格式用例: [jpeg格式4.5K以外图片先解码LCD图再显示] TID: Multimedia_Gallery_SR20240305625869_002
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20240305625869_002(dt: Dt) {
  dt.log.i('jpeg格式4.5K以外图片先解码LCD图再显示 start');
  // 测试步骤
  // 1、图库中任意jpeg格式4.5K以外的照片大图浏览；
  await dt.sleep(DELAY.short);
  // 2、查看日志
  await Multimedia_Gallery_SR20240305625869_002Expects(dt);
  dt.log.i('jpeg格式4.5K以外图片先解码LCD图再显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_SR20240305625869_002Expects(dt: Dt): Promise<void> {
  // 1、大图浏览加载正常，无卡顿、刷新等场景
  await dt.showComponentsWithin();
  // 2、通过日志查看先解码LCD图再显示，日志打印picture decode mime, pixelmapFormat 3

}

/**
 * 大图-格式用例: [jpeg格式4.5K以内图片预解码] TID: Multimedia_Gallery_SR20240305625869_005
 * 前置条件
 * 1、图库存在照片
 */
async function Multimedia_Gallery_SR20240305625869_005(dt: Dt) {
  dt.log.i('jpeg格式4.5K以内图片预解码 start');
  // 测试步骤
  // 1、大图浏览加载正常，无卡顿、刷新等场景
  await dt.sleep(DELAY.short);
  // 2、通过日志查看直接解码原图，不再解码LCD图，日志打印3次+:K8picture decode mime, pixelmapFormat 11和No need LcdDocode
  await Multimedia_Gallery_SR20240305625869_005Expects(dt);
  dt.log.i('jpeg格式4.5K以内图片预解码 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_SR20240305625869_005Expects(dt: Dt): Promise<void> {
  // 1、大图浏览加载正常，无卡顿、刷新等场景
  await dt.showComponentsWithin();
  // 2、通过日志查看直接解码原图，不再解码LCD图，日志打印picture decode mime, pixelmapFormat 11和No need LcdDocode

}

/**
 * 大图-格式用例: [云增强图片hefi格式显示] TID: Multimedia_Gallery_PhotoBrowser_HEIC_034
 * 前置条件
 * 1、相机设置拍摄格式为HEIF，选择后置人像模式或者超级微距模式拍摄照片
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_034(dt: Dt) {
  dt.log.i('云增强图片hefi格式显示 start');
  // 测试步骤
  // 1、图片点击右上角云增强按钮
  await dt.sleep(DELAY.short);
  //
  await Multimedia_Gallery_PhotoBrowser_HEIC_034Expects(dt);
  dt.log.i('云增强图片hefi格式显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_034Expects(dt: Dt): Promise<void> {
  // 1、正常生成一张云增强后的图片，显示正常清晰
  await dt.showComponentsWithin();
  //

}

/**
 * 大图-格式用例: [hefi格式图片xxx同步（5.1和5.1)] TID: Multimedia_Gallery_PhotoBrowser_HEIC_038
 * 前置条件
 * 1、准备端云账号，有不同的hefi格式图片
 2、准备两台,5.1版本XXX手机A，B
 3、分别登陆云账号
  4、覆盖不同格式的图片（相机拍摄多张照片（依次覆盖普通照片，人像/大光圈，高像素，超级微距，闪拍，夜景，专业流光快门，水印照片，全景模式照片，前置人像），各种不用分辨率的图片，16k以下，16k以上的
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_038(dt: Dt) {
  dt.log.i('hefi格式图片xxx同步（5.1和5.1) start');
  // 测试步骤
  //
  await dt.sleep(DELAY.short);
  // 1、A手机上hefi格式，通过端云同步到B手机上
  await dt.sleep(DELAY.short);
  // 2、B手机上heif格式图片，通过端云同步到A手机上
  await dt.sleep(DELAY.short);
  // 3、分别在A、B手机上大图浏览，宫格浏览，大图操作（收藏,，删除，隐藏，添加，分享等），宫格操作（多选删除，隐藏，添加等）
  await Multimedia_Gallery_PhotoBrowser_HEIC_038Expects(dt);
  dt.log.i('hefi格式图片xxx同步（5.1和5.1) end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_PhotoBrowser_HEIC_038Expects(dt: Dt): Promise<void> {
  // 1、图片同步成功，图片和格式显示正常，清晰
  await dt.showComponentsWithin();
  // 2、图片同步成功，图片和格式显示正常，清晰
  await dt.showComponentsWithin();
  // 3、图片操作无异常，能够正常浏览的操作

}

/**
 * 大图-HDR用例: [HDR格式图片显示] TID: Multimedia_Gallery_HDRpicture_001
 * 前置条件
 * 1、设备已具备HDR图片显示功能
 */
async function Multimedia_Gallery_HDRpicture_001(dt: Dt) {
  dt.log.i('HDR格式图片显示 start');
  // 测试步骤
  // 1、XXX相机拍摄一张HDR格式图片（相机拍的图片默认是HDR格式）
  await dt.sleep(DELAY.short);
  // 2、进大图查看图片显示
  await Multimedia_Gallery_HDRpicture_001Expects(dt);
  dt.log.i('HDR格式图片显示 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_HDRpicture_001Expects(dt: Dt): Promise<void> {
  // 1、图片亮部有逐渐的提亮效果，过程动效正常无跳变

}

/**
 * 大图-HDR用例: [HDR视频不同类型视频显示效果] TID: Multimedia_Gallery_VideoPlayer_Frame_081
 * 前置条件
 * 图库存在HDR格式视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_081(dt: Dt) {
  dt.log.i('HDR视频不同类型视频显示效果 start');
  // 测试步骤
  // 1、用相机拍摄不同分辨率的视频：16:9 4k(30fps/60fps)，全屏1080p(30fps/60fps)，16:9 1080p(30fps/60fps),16:9 720p(30fps/60fps)
  await dt.sleep(DELAY.short);
  // 2、用相机拍摄不同滤镜的视频：原色，鲜艳，明快，黑白
  await dt.sleep(DELAY.short);
  // 3、打开视频查看视频封面显示，大图底部缩略图显示，视频播放图像帧显示
  await Multimedia_Gallery_VideoPlayer_Frame_081Expects(dt);
  dt.log.i('HDR视频不同类型视频显示效果 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_VideoPlayer_Frame_081Expects(dt: Dt): Promise<void> {
  // 3、显示的视频封面帧，播放区视频显示为HDR效果，大图底部缩略图显示SDR效果

}

/**
 * 大图-HDR用例: [HDR视频播放显示效果] TID: Multimedia_Gallery_VideoPlayer_Frame_082
 * 前置条件
 * 图库存在HDR格式视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_082(dt: Dt) {
  dt.log.i('HDR视频播放显示效果 start');
  // 测试步骤
  // 1、打开视频，观察视频封面帧，大图底部缩略图显示效果
  await dt.sleep(DELAY.short);
  // 2、播放视频，观察视频播放区显示效果
  await Multimedia_Gallery_VideoPlayer_Frame_082Expects(dt);
  dt.log.i('HDR视频播放显示效果 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_VideoPlayer_Frame_082Expects(dt: Dt): Promise<void> {
  // 1、视频封面帧显示HDR效果，大图底部缩略图显示为SDR效果
  await dt.showComponentsWithin();
  // 2、视频播放显示HDR效果，预览条显示SDR效果
  await dt.showComponentsWithin();
  // 3、大图底部缩略图显示SDR效果
  await dt.showComponentsWithin();
  // 4、播放区逐帧刷新视频帧图像，播放区图像显示HDR效果
  await dt.showComponentsWithin();
  // 5、视频暂停后，播放区显示暂停时间图像帧，图像显示HDR效果

}

/**
 * 大图-摩尔纹用例: [摩尔纹照片编辑保存后查看] TID: Multimedia_Gallery_Moire_008
 * 前置条件
 * 1、图库中存在摩尔纹资源
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_008(dt: Dt) {
  dt.log.i('摩尔纹照片编辑保存后查看 start');
  // 测试步骤
  // 1、时间轴界面打开摩尔纹照片大图
  await dt.sleep(DELAY.short);
  // 2、进入编辑后进行角度旋转、垂直/水平旋转，对照片进行裁剪后保存
  await Multimedia_Gallery_Moire_008Expects(dt);
  dt.log.i('摩尔纹照片编辑保存后查看 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Moire_008Expects(dt: Dt): Promise<void> {
  // 2、照片保存成功，返回大图时去除摩尔纹

}

/**
 * 大图-摩尔纹用例: [摩尔纹不同入口进入视频播放] TID: Multimedia_Gallery_Moire_014
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 摩尔纹资源：
 */
async function Multimedia_Gallery_Moire_014(dt: Dt) {
  dt.log.i('摩尔纹不同入口进入视频播放 start');
  // 测试步骤
  // 1、时间轴界面打开视频大图
  await dt.sleep(DELAY.short);
  // 2、相机入口打开视频大图
  await dt.sleep(DELAY.short);
  // 3、最近删除打开视频大图
  // 5、录屏后点击左下角录屏文件打开视频大图
  await Multimedia_Gallery_Moire_014Expects(dt);
  dt.log.i('摩尔纹不同入口进入视频播放 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Moire_014Expects(dt: Dt): Promise<void> {
  // 1、进入大图视频自动播放，待自动播放完成回到封面查看封面，在视频封面存在摩尔纹的情况下封面有去摩尔纹效果
  await dt.showComponentsWithin();
  // 2、进入大图视频自动播放，待自动播放完成回到封面查看封面，在视频封面存在摩尔纹的情况下封面有去摩尔纹效果，点击返回按钮时跳转至相机
  await dt.showComponentsWithin();
  // 3、进入大图视频自动播放，待自动播放完成回到封面查看封面，在视频封面存在摩尔纹的情况下封面有去摩尔纹效果，点击返回按钮跳转至最近删除
  await dt.showComponentsWithin();
  // 4、进入视频大图，在视频封面存在摩尔纹的情况下封面有去摩尔纹效果
  await dt.showComponentsWithin();
  // 5、进入大图视频自动播放，待自动播放完成回到封面查看封面，在视频封面存在摩尔纹的情况下封面有去摩尔纹效果

}

/**
 * 大图-格式用例: [图片重命名-覆盖不同格式图片视频] TID: Multimedia_Gallery_image_renaming_002
 * 前置条件
 * 图库中存在不同格式的照片和视频文件，当前版本已支持新增英文字符 [] {} . ` '
 */
async function Multimedia_Gallery_image_renaming_002(dt: Dt) {
  dt.log.i('图片重命名-覆盖不同格式图片视频 start');
  // 测试步骤
  // 1、选择不同格式的图片:jpg,dng,heif,png,jpeg,wbmp，nef， arw， gif， cr2, webp, bmp等,
  await dt.sleep(DELAY.short);
  // 视频mp4, webm, mkv, mov,rmvb, 3gp等重命名覆盖英文字符 [] {} . ` '
  await Multimedia_Gallery_image_renaming_002Expects(dt);
  dt.log.i('图片重命名-覆盖不同格式图片视频 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_image_renaming_002Expects(dt: Dt): Promise<void> {
  // 1、重命名成功，图片无异常，大图名称显示无异常
  await dt.showComponentsWithin();
  //

}

/**
 * 大图-连拍用例: [连拍照片的删除] TID: Multimedia_Gallery_Continuousphotoshoots_0001
 * 前置条件
 *
 1、图库存在连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_0001(dt: Dt) {
  dt.log.i('连拍照片的删除 start');
  // 测试步骤
  // 1.点击连拍照片大图界面下方菜单连拍按钮，进入子界面；
  await dt.swipeScreen?.left();
  // 2.选择全部的连拍照片，点击保存-删除；
  await dt.sleep(DELAY.short);
  // 3.选择一张连拍照片，点击保存-删除；
  await dt.sleep(DELAY.short);
  // 4.选择多张连拍照片，点击保存-删除;
  await dt.sleep(DELAY.short);
  // 5.不选择照片，查看保存按钮；
  await dt.sleep(DELAY.short);
  // 6.手机横屏，重复步骤1、2、3、4、5
  await dt.sleep(DELAY.short);
  //
  await dt.sleep(DELAY.short);
  //
  await Multimedia_Gallery_Continuousphotoshoots_0001Expects(dt);
  dt.log.i('连拍照片的删除 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Continuousphotoshoots_0001Expects(dt: Dt): Promise<void> {
  // 1.进入连拍照片子界面成功；
  await dt.showComponentsWithin();
  // 2.保存成功保存时间超过1秒，展示保存loding弹窗，跳转至最后一张连拍照片的大图界面，连拍照片有个被删除的动效，然后消失跳转到下一张图片；
  await dt.showComponentsWithin();
  // 3.保存成功保存时间超过1秒，展示保存loding弹窗，跳转至所选连拍照片的大图界面，连拍照片有个被删除的动效，然后消失跳转到下一张图片；
  await dt.showComponentsWithin();
  // 4.保存成功保存时间超过1秒，展示保存loding弹窗，跳转至所选最后一张连拍照片的大图界面，连拍照片有个被删除的动效，然后消失跳转到下一张图片；
  await dt.showComponentsWithin();
  // 5.不选择照片，保存按钮置灰无法点击；
  await dt.showComponentsWithin();
  // 6.手机横屏，操作成功；

}

/**
 * 大图-连拍用例: [相机连拍照片拉起大图] TID: Multimedia_Gallery_Continuousphotoshoots_001
 * 前置条件
 * 1、设备支持连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_001(dt: Dt) {
  dt.log.i('相机连拍照片拉起大图 start');
  // 测试步骤
  // 1.打开设备相机长按左滑连拍照片（PC不支持连拍需导入资源）；
  await dt.swipeScreen?.left();
  // 2.1相机左下角拉起大图，查看大图；
  await dt.swipeScreen?.left();
  // 2.2点击大图右上角的图库入口，进入图库查看宫格；
  await dt.swipeScreen?.left();
  // 2.3点击连拍照片进入大图，查看大图，上滑查看大图详情；
  await dt.sleep(DELAY.short);
  // 3.手机横屏，重复步骤1、2
  await Multimedia_Gallery_Continuousphotoshoots_001Expects(dt);
  dt.log.i('相机连拍照片拉起大图 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Continuousphotoshoots_001Expects(dt: Dt): Promise<void> {
  // 1.连拍成功；
  await dt.showComponentsWithin();
  // 2.1大图拉起成功，大图下方中间有连拍标识；
  await dt.showComponentsWithin();
  // 2.2进入图库成功，连拍照片宫格不展示连拍标识；
  await dt.showComponentsWithin();
  // 2.3大图下方中间有连拍标识，大图详情展示正常；
  await dt.showComponentsWithin();
  // 3.手机横屏，展示正常。

}

/**
 * 大图-连拍用例: [图库照片页浏览连拍照片] TID: Multimedia_Gallery_Continuousphotoshoots_002
 * 前置条件
 * 1、图库存在连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_002(dt: Dt) {
  dt.log.i('图库照片页浏览连拍照片 start');
  // 测试步骤
  // 1.打开图库进入照片页，日视图查看连拍照片的宫格；
  await dt.swipeScreen?.left();
  // 2.切换月、年视图，查看连拍照片的宫格；
  await dt.sleep(DELAY.short);
  // 3.再从月/年视图切回日视图，点击连拍照片进入大图，查看大图；
  await dt.sleep(DELAY.short);
  // 4.手机横屏，重复步骤1、2、3
  await Multimedia_Gallery_Continuousphotoshoots_002Expects(dt);
  dt.log.i('图库照片页浏览连拍照片 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Continuousphotoshoots_002Expects(dt: Dt): Promise<void> {
  // 1.日视图连拍照片宫格不展示连拍标识；
  await dt.showComponentsWithin();
  // 2.年月视图连拍照片宫格不展示连拍标识；
  await dt.showComponentsWithin();
  // 3.连拍照片大图展示连拍标识;
  await dt.showComponentsWithin();
  // 4.手机横屏，展示正常。

}

/**
 * 大图-连拍用例: [连拍照片的保存与删除] TID: Multimedia_Gallery_Continuousphotoshoots_017
 * 前置条件
 * 1、图库存在连拍照片
 */
async function Multimedia_Gallery_Continuousphotoshoots_017(dt: Dt) {
  dt.log.i('连拍照片的保存与删除 start');
  // 测试步骤
  // 1.点击连拍照片大图界面下方菜单连拍按钮，进入子界面；
  await dt.swipeScreen?.left();
  // 2.选择全部的连拍照片，点击保存；
  await dt.sleep(DELAY.short);
  // 3.选择一张连拍照片，点击保存；
  await dt.sleep(DELAY.short);
  // 4.选择多张连拍照片，点击保存;
  await dt.sleep(DELAY.short);
  // 5.不选择照片，查看保存按钮；
  await dt.sleep(DELAY.short);
  // 6.手机横屏，重复步骤1、2、3、4、5
  await Multimedia_Gallery_Continuousphotoshoots_017Expects(dt);
  dt.log.i('连拍照片的保存与删除 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Continuousphotoshoots_017Expects(dt: Dt): Promise<void> {
  // 1.进入连拍照片子界面成功；
  await dt.showComponentsWithin();
  // 2.保存成功保存时间超过1秒，展示保存loding弹窗，跳转至最后一张连拍照片的大图界面；
  await dt.showComponentsWithin();
  // 3.保存成功保存时间超过1秒，展示保存loding弹窗，跳转至所选连拍照片的大图界面；
  await dt.showComponentsWithin();
  // 4.保存成功保存时间超过1秒，展示保存loding弹窗，跳转至所选最后一张连拍照片的大图界面
  await dt.showComponentsWithin();
  // 5.不选择照片，保存按钮置灰无法点击；
  await dt.showComponentsWithin();
  // 6.手机横屏，操作成功；

}

/**
 * 大图-连拍用例: [相机连拍照片后，选择部分或全部删除] TID: Multimedia_Gallery_DeleteScenes_005
 * 前置条件
 * 图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_DeleteScenes_005(dt: Dt) {
  dt.log.i('相机连拍照片后，选择部分或全部删除 start');
  // 测试步骤
  // 1.相机拍摄连拍照片
  await dt.swipeScreen?.left();
  // 2.点击进入连拍照片，全选/部分选择图片删除
  await dt.sleep(DELAY.short);
  //
  await Multimedia_Gallery_DeleteScenes_005Expects(dt);
  dt.log.i('相机连拍照片后，选择部分或全部删除 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_DeleteScenes_005Expects(dt: Dt): Promise<void> {
  // 1.图片删除动效正常，大图界面刷新正常

}

/**
 * 大图-HDR用例: [增强后的120分图支持HDR高显效果] TID: Multimedia_Gallery_AICloudEnhancementService_017
 * 前置条件
 * 1、手机连接WIFI
 */
async function Multimedia_Gallery_AICloudEnhancementService_017(dt: Dt) {
  dt.log.i('增强后的120分图支持HDR高显效果 start');
  // 测试步骤
  // 1、相机拍摄动态照片或者静态照片(人像、超级微距、长焦等)
  await dt.sleep(DELAY.short);
  // 2、进入图库大图，点击AI云增强图标
  await Multimedia_Gallery_AICloudEnhancementService_017Expects(dt);
  dt.log.i('增强后的120分图支持HDR高显效果 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_AICloudEnhancementService_017Expects(dt: Dt): Promise<void> {
  // 2、云增强正常触发，增强成功后跳转增强后的120分图，并且增强后的图片支持HDR高显效果

}