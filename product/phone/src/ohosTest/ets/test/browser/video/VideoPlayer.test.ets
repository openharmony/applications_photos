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
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Component, ON } from '@ohos.UiTest';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Comp } from '@ohos/tools/src/ohosTest/ets/Comp';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { UiComponentId } from '../../utils/UiComponentId';

const TAG: string = 'VideoPlayerTest';

export default function VideoPlayerTest(): void {
  describe('VideoPlayerTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    it('beforeAll_VideoPlayer', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      dt.log.i('beforeAllVideoPlayerTest start');
      await AppStart.photos();
      await dt.videoBrowser();
      dt.log.i('beforeAllVideoPlayerTest finish');
    });
    it('Multimedia_Gallery_VideoPlayer_Frame_010', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-视频播放用例: [视频缩略图收起态点击播放] TID: Multimedia_Gallery_VideoPlayer_Frame_010
      await Multimedia_Gallery_VideoPlayer_Frame_010(dt);
    });
    it('Multimedia_Gallery_VideoPlayer_Frame_017', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [不同方式打开/切换视频] TID: Multimedia_Gallery_VideoPlayer_Frame_017
      await Multimedia_Gallery_VideoPlayer_Frame_017(dt);
    });

    it('Multimedia_Gallery_VideoPlayer_Frame_013', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频缩略图xxx自动播放] TID: Multimedia_Gallery_VideoPlayer_Frame_013
      await Multimedia_Gallery_VideoPlayer_Frame_013(dt);
    });
    it('Multimedia_Gallery_VideoPlayer_Frame_018', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频未播放缩略图收起态翻页切换] TID: Multimedia_Gallery_VideoPlayer_Frame_018
      await Multimedia_Gallery_VideoPlayer_Frame_018(dt);
    });
    it('Multimedia_Gallery_VideoPlayer_Frame_019', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频播放中缩略图xxx翻页切换] TID: Multimedia_Gallery_VideoPlayer_Frame_019
      await Multimedia_Gallery_VideoPlayer_Frame_019(dt);
    });
    it('Multimedia_Gallery_SR20240327153237_009', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频未播放状态下单帧截图] TID: Multimedia_Gallery_SR20240327153237_009
      await Multimedia_Gallery_SR20240327153237_009(dt);
    });
    it('Multimedia_Gallery_SR20240327153237_011', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频播放状态截图] TID: Multimedia_Gallery_SR20240327153237_011
      await Multimedia_Gallery_SR20240327153237_011(dt);
    });
    it('Multimedia_Gallery_SR20240327153237_012', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [连续切换视频再分个截图] TID: Multimedia_Gallery_SR20240327153237_012
      await Multimedia_Gallery_SR20240327153237_012(dt);
    });
    it('Multimedia_Gallery_SR20240327153237_013', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [支持连续快次点击截图按钮] TID: Multimedia_Gallery_SR20240327153237_013
      await Multimedia_Gallery_SR20240327153237_013(dt);
    });
    it('Multimedia_Gallery_SR20240327153237_010', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频暂停状态下单帧截图] TID: Multimedia_Gallery_SR20240327153237_010
      await Multimedia_Gallery_SR20240327153237_010(dt);
    });
    it('Multimedia_Gallery_SR20240327153237_024', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频截图时不存在截图相册] TID: Multimedia_Gallery_SR20240327153237_024
      await Multimedia_Gallery_SR20240327153237_024(dt);
    });
    it('Multimedia_Gallery_VideoPlayer_01', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [大图进入视频播放] TID: Multimedia_Gallery_VideoPlayer_01
      await Multimedia_Gallery_VideoPlayer_01(dt);
    });
    it('Multimedia_Gallery_Video_Frame_001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频逐帧播放优化] TID: Multimedia_Gallery_Video_Frame_001
      await Multimedia_Gallery_Video_Frame_001(dt);
    });
    it('Multimedia_Gallery_VideoPlayer_Frame_014', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频缩略图xxx播放过程中暂停] TID: Multimedia_Gallery_VideoPlayer_Frame_014
      await Multimedia_Gallery_VideoPlayer_Frame_014(dt);
    });
    it('Multimedia_Gallery_VideoPlayer_Frame_007', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频缩略图原有比例（1帧），视频比例收起态（2帧），逐帧xxx切换] TID: Multimedia_Gallery_VideoPlayer_Frame_007
      await Multimedia_Gallery_VideoPlayer_Frame_007(dt);
    });

    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachVideoPlayerTest').init();
      //规避沉浸模式
      let res = await dt.driver.findComponent(ON.id('PhotoBrowserActionBarButtonBack'));
      if (!res) {
        // 唤起顶部组件
        await dt.driver.click(700, 500);
        await dt.sleep(DELAY.short);
      }
      await dt.assertClick('PhotoBrowserActionBarButtonBack');
      await dt.sleep(DELAY.short);
      await dt.assertClick('photoGridView_gird_0');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach VideoPlayerTest finish');
    });
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllVideoPlayerTest').init();
      // 删除录屏
      await dt.assertClick('ToolBarButtonDelete');
      await dt.sleep(DELAY.short);
      await dt.assertClick('advanced_dialog_button_1');
      await dt.sleep(DELAY.short);
      await Exit.browser();
      dt.log.i('afterAll VideoPlayerTest finish');
    });
  });
}

/**
 * 大图-视频用例: [视频缩略图收起态点击播放]
 * TAG: 视频播放 TID: Multimedia_Gallery_VideoPlayer_Frame_010
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_010(dt: Dt) {
  dt.log.i('视频缩略图收起态点击播放 start');
  // 测试步骤
  // 1、点击隐藏底部缩略图
  await hidePreviewer(dt);
  // 2、打开视频，观察播放过程
  await play(dt);
  await dt.sleep(DELAY.default);
  await dt.driver.click(700, 500);
  await dt.sleep(DELAY.short);
  dt.log.i('视频缩略图收起态点击播放 end');
}

// 点击播放
async function play(dt: Dt) {
  await dt.clickIfExist('VideoPlayButton');
}

// 点击隐藏底部缩略图
async function hidePreviewer(dt: Dt) {
  await dt.driver.click(700, 500);
  await dt.sleep(DELAY.short);
}

/**
 * 大图-视频用例: [视频缩略图xxx自动播放]
 * TAG: 视频播放 TID: Multimedia_Gallery_VideoPlayer_Frame_013
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_013(dt: Dt) {
  dt.log.i('视频缩略图xxx自动播放 start');
  // 测试步骤
  // 2、点击底部缩略条
  await dt.assertClick('PreviewBarItemVideo 0');
  await dt.sleep(DELAY.enormous);
  // 3、查看播放结束状态
  await Multimedia_Gallery_VideoPlayer_Frame_013Expects(dt);
  dt.log.i('视频缩略图xxx自动播放 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_VideoPlayer_Frame_013Expects(dt: Dt): Promise<void> {
  // 1、视频自动播放，缩略图默认保持收起状态，展示视频比例（两帧）
  // 2、呈现逐帧展开状态,始终保持缩略进度，视频继续播放，进度条原地不动，缩略图随视频向左移动  // await dt.assertComponent('VideoPlayButton');
  // 3、播放结束,，播放按钮变为暂停状态，缩略条保持逐帧展开状态，进度条停留在最后一帧
}

/**
 * 大图-视频用例: [视频未播放缩略图收起态翻页切换]
 * TAG: 视频播放 TID: Multimedia_Gallery_VideoPlayer_Frame_018
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 2、首张为视频，最后一张是视频，中间存在视频大图相邻的图片
 3、视频未播放
 4、保持视频缩略图收起状态
 */
async function Multimedia_Gallery_VideoPlayer_Frame_018(dt: Dt) {
  dt.log.i('视频未播放缩略图收起态翻页切换 start');
  // 测试步骤
  // 1、点击隐藏底部缩略图
  await hidePreviewer(dt);
  for (let i = 0; i < 10; i++) {
    await dt.swipeScreen?.left();
  }
  for (let i = 0; i < 10; i++) {
    await dt.swipeScreen?.right();
  }
  await hidePreviewer(dt);
  dt.log.i('视频未播放缩略图收起态翻页切换 end');
}

/**
 * 大图-视频用例: [视频播放中缩略图xxx翻页切换]
 * TAG: 视频播放 TID: Multimedia_Gallery_VideoPlayer_Frame_019
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 2、首张为视频，最后一张是视频，中间存在视频大图相邻的图片
 3、保持视频在播放
 4、保持视频缩略图展开状态
 */
async function Multimedia_Gallery_VideoPlayer_Frame_019(dt: Dt) {
  dt.log.i('视频播放中缩略图xxx翻页切换 start');
  // 测试步骤
  await play(dt);
  await dt.sleep(DELAY.double);
  await Multimedia_Gallery_VideoPlayer_Frame_018(dt);

  dt.log.i('视频播放中缩略图xxx翻页切换 end');
}

/**
 * 大图-视频用例: [视频未播放状态下单帧截图]
 * TAG: 视频播放 TID: Multimedia_Gallery_SR20240327153237_009
 * 前置条件
 * 1、图库视频大图未播放状态
 */
async function Multimedia_Gallery_SR20240327153237_009(dt: Dt) {
  dt.log.i('视频未播放状态下单帧截图 start');
  // 测试步骤
  // 2、视频浏览未播放视频
  await dt.sleep(DELAY.short);
  // 3、点击截图按钮
  let shot =
    await dt.driver.findComponent(ON.id('PhotoBrowserActionBarButtonvideoScreenshot'));
  await shot.click();
  await Multimedia_Gallery_SR20240327153237_009Expects(dt);
  dt.log.i('视频未播放状态下单帧截图 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_SR20240327153237_009Expects(dt: Dt): Promise<void> {
  // 3、弹出截图窗口，提示“已保存至截图相册”，截图封面图片保存至截图相册，图片比例与视频一致
  await dt.driver.findComponent(ON.text('已保存至截图相册'));
}

/**
 * 大图-视频用例: [视频暂停状态下单帧截图]
 * TAG: 视频播放 TID: Multimedia_Gallery_SR20240327153237_010
 * 前置条件
 * 1、图库视频大图暂停状态
 */
async function Multimedia_Gallery_SR20240327153237_010(dt: Dt) {
  dt.log.i('视频暂停状态下单帧截图 start');
  // 测试步骤
  // 1、视频大图浏览
  await dt.sleep(DELAY.short);
  // 2、视频浏览播放之后频暂停
  await play(dt);
  await dt.sleep(DELAY.default);
  let ToolBarButtonvideoPlay =
    await dt.driver.findComponent(ON.id('ToolBarButtonvideoPlay'));
  if (ToolBarButtonvideoPlay) {
    await ToolBarButtonvideoPlay.click();
    await dt.sleep(DELAY.short);
  }
  // 3、点击截图按钮
  let shot =
    await dt.driver.findComponent(ON.id('PhotoBrowserActionBarButtonvideoScreenshot'));
  await shot.click();
  await Multimedia_Gallery_SR20240327153237_010Expects(dt);
  dt.log.i('视频暂停状态下单帧截图 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_SR20240327153237_010Expects(dt: Dt): Promise<void> {
  // 3、弹出截图窗口，提示“已保存至截图相册”，截图封面图片保存至截图相册，图片比例与视频一致
  await dt.driver.findComponent(ON.text('已保存至截图相册'));
}

/**
 * 大图-视频用例: [视频播放状态截图]
 * TAG: 视频播放 TID: Multimedia_Gallery_SR20240327153237_011
 * 前置条件
 * 1、图库视频大图播放状态
 */
async function Multimedia_Gallery_SR20240327153237_011(dt: Dt) {
  dt.log.i('视频播放状态截图 start');
  // 测试步骤
  await play(dt);
  await dt.sleep(DELAY.default);
  // 3、点击截图按钮
  let shot =
    await dt.driver.findComponent(ON.id('PhotoBrowserActionBarButtonvideoScreenshot'));
  await shot.click();
  await Multimedia_Gallery_SR20240327153237_011Expects(dt);
  dt.log.i('视频播放状态截图 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_SR20240327153237_011Expects(dt: Dt): Promise<void> {
  // 3、弹出截图窗口，提示“已保存至截图相册”，截图对应时间图片保存至截图相册，图片比例与视频一致
  await dt.driver.findComponent(ON.text('已保存至截图相册'));
}

/**
 * 大图-视频用例: [连续切换视频再分个截图]
 * TAG: 视频播放 TID: Multimedia_Gallery_SR20240327153237_012
 * 前置条件
 * 1、图库存在多个可播放的视频
 */
async function Multimedia_Gallery_SR20240327153237_012(dt: Dt) {
  dt.log.i('连续切换视频再分个截图 start');
  // 测试步骤

  for (let i = 0; i < 4; i++) {
    await play(dt);
    await dt.sleep(DELAY.default);
    await dt.clickIfExist('PhotoBrowserActionBarButtonvideoScreenshot');

    await dt.swipeScreen?.left();
  }
  dt.log.i('连续切换视频再分个截图 end');
}

/**
 * 大图-视频用例: [支持连续快次点击截图按钮]
 * TAG: 视频播放 TID: Multimedia_Gallery_SR20240327153237_013
 * 前置条件
 * 1、图库视频大图播放状态
 */
async function Multimedia_Gallery_SR20240327153237_013(dt: Dt) {
  dt.log.i('支持连续快次点击截图按钮 start');
  // 测试步骤
  await play(dt);
  // 3、短时间多次点击截图按钮
  let shot =
    await dt.driver.findComponent(ON.id('PhotoBrowserActionBarButtonvideoScreenshot'));
  for (let i = 4; i < 4; i++) {
    await shot.click();
    await dt.sleep(DELAY.short);
  }
  dt.log.i('支持连续快次点击截图按钮 end');
}

/**
 * 大图-视频用例: [视频截图时不存在截图相册]
 * TAG: 视频播放 TID: Multimedia_Gallery_SR20240327153237_024
 * 前置条件
 * 1、刷机后未生成截屏相册（非生成后隐藏）
 2、图库存在多个可播放的视频
 */
async function Multimedia_Gallery_SR20240327153237_024(dt: Dt) {
  dt.log.i('视频截图时不存在截图相册 start');
  // 测试步骤
  await dt.assertClick(UiComponentId.PHOTOS_BROWSER_BACK);
  await dt.sleep(DELAY.short);
  await dt.assertClick(UiComponentId.GRID_BACK_ALBUMS);
  await dt.sleep(DELAY.short);
  let shotAlbum = await dt.driver.findComponent(ON.text('截图'));
  // 清空截图相册
  if (shotAlbum) {
    await shotAlbum.click();
    await dt.sleep(DELAY.short);
    await dt.assertTextClick('多选');
    await dt.sleep(DELAY.short);
    await dt.assertTextClick('全选');
    await dt.sleep(DELAY.short);
    await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_DELETE);
    await dt.sleep(DELAY.short);
    await dt.assertClick(TestConstants.DIALOG_BUTTON_SECOND);
    await dt.sleep();
    await dt.assertClick(UiComponentId.GRID_BACK_ALBUMS);
  }

  await dt.sleep(DELAY.short);
  await dt.assertClick('Album_1');
  await dt.sleep(DELAY.short);
  await dt.assertClick('photoGridView_gird_0');
  await Multimedia_Gallery_SR20240327153237_011(dt);
  dt.log.i('视频截图时不存在截图相册 end');
}

/**
 * 大图-视频用例: [大图进入视频播放]
 * TAG: 视频播放 TID: Multimedia_Gallery_VideoPlayer_01
 * 前置条件
 * 图库中存在不同格式的图片和视频
 */
async function Multimedia_Gallery_VideoPlayer_01(dt: Dt) {
  dt.log.i('大图进入视频播放 start');
  // 测试步骤
  let videoPlayButton =
    await dt.driver.findComponent(ON.id('VideoPlayButton'));
  await videoPlayButton.click();
  await dt.sleep(DELAY.default);
  dt.log.i('大图进入视频播放 end');
}

/**
 * 大图-视频用例: [视频逐帧播放优化]
 * TAG: 视频播放 TID: Multimedia_Gallery_Video_Frame_001
 * 前置条件
 * 1、图库准备mp4格式视频和MOV格式视频
 
 */
async function Multimedia_Gallery_Video_Frame_001(dt: Dt) {
  dt.log.i('视频逐帧播放优化 start');
  // 测试步骤
  // 1、图库视频大图点击播放
  await dt.assertClick('VideoPlayButton');
  await dt.sleep(DELAY.short);
  // 2、滑动预览条查看大图变化，覆盖快滑和慢滑
  await Multimedia_Gallery_Video_Frame_001Expects(dt);
  dt.log.i('视频逐帧播放优化 end');
}

/**
 * 预期结果
 */
async function Multimedia_Gallery_Video_Frame_001Expects(dt: Dt): Promise<void> {
  // 2、滑动过程大图变化流畅，无明显卡顿
  const bar = await (new Comp('PhotoBrowserPreviewBar', dt.driver)).init();
  await bar.left();
  await bar.right();
  await bar.horizontal(0.45, 0.48);
  await bar.horizontal(0.52, 0.58);
  await bar.horizontal(0.3, 0.4);
  await bar.horizontal(0.6, 0.7);
  await bar.right();
  await bar.left();
  await bar.right();
  await bar.right();
  await bar.right();
}

/**
 * 大图-视频用例: [不同方式打开/切换视频]
 * TAG: 视频播放 TID: Multimedia_Gallery_VideoPlayer_Frame_017
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_017(dt: Dt) {
  dt.log.i('不同方式打开/切换视频 start');
  // 测试步骤
  // 1、宫格入口打开视频
  await dt.sleep(DELAY.short);
  // 2、点击底部缩略图切换视频
  let i = 1;
  let previewItem = await dt.driver.findComponent(ON.id(`PreviewBarItemVideo ${i}`));
  while (previewItem) {
    await previewItem.click();
    i++;
    previewItem = await dt.driver.findComponent(ON.id(`PreviewBarItemVideo ${i}`));
    if (i > 10) {
      dt.log.i('最多翻10页');
      break;
    }
  }

  // 3、翻页切换视频
  for (let j = 0; j < i; j++) {
    await dt.swipeScreen?.right();
  }
  await dt.sleep(DELAY.short);
  // 4、滑动底部缩略图切换视频
  await Multimedia_Gallery_Video_Frame_001Expects(dt);
  dt.log.i('不同方式打开/切换视频 end');
}

async function Multimedia_Gallery_VideoPlayer_Frame_014(dt: Dt) {
  dt.log.i('视频缩略图xxx播放过程中暂停 start');
  // 测试步骤
  // 1、准备23s的录屏
  await dt.prepareVideo(TestConstants.DELAY_TWENTY_SECOND);
  // 2、图库视频点击缩略图播放
  await dt.clickIfExist('PreviewBarItemVideo 0');
  await dt.sleep(DELAY.short);

  // 3、图库视频点击暂停
  await dt.clickIfExist('ToolBarButtonvideoPlay');
  await dt.sleep(DELAY.short);

  // 4、图库视频点击继续播放
  await dt.clickIfExist('ToolBarButtonvideoPlay');
  await dt.sleep(DELAY.short);
  dt.log.i('视频缩略图xxx播放过程中暂停 end');
}

/**
 * 大图-视频: [视频缩略图原有比例（1帧），视频比例收起态（2帧），逐帧xxx切换]
 * TAG: 342 TID: Multimedia_Gallery_VideoPlayer_Frame_007
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_007(dt: Dt) {
  dt.log.i('视频缩略图原有比例（1帧），视频比例收起态（2帧），逐帧xxx切换 start');
  dt.log.i('STEP 1、打开视频，查看底部缩略图');

  await dt.sleep();
  dt.log.i('预期结果1.1、视频图像帧预览条嵌入在大图底部缩略图预览条中1.2、缩略图默认保持收起状态，展示视频比例（两帧）');
  let image = await dt.driver.findComponents(ON.type('Image').within(ON.id('PreviewBarItemVideo 0')));
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击/滑动缩略条');
  await dt.clickIfExist('PreviewBarItemVideo 0');
  await dt.sleep(DELAY.short);

  dt.log.i('预期结果2、缩略图呈现逐帧展开状态');
  image = await dt.driver.findComponents(ON.type('Image').within(ON.id('PreviewBarItemVideo 0')));
  expect(image?.length > 1).assertTrue();
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、重新打开视频，点击暂停按钮');
  await dt.clickIfExist('ToolBarButtonvideoPlay');
  await dt.sleep(DELAY.short);

  dt.log.i('预期结果3、视频暂停，缩略图保持收起状态，展示视频比例（两帧），进度条始终保持缩略进度');
  dt.log.i('STEP 4、点击/滑动缩略条');
  await dt.clickIfExist('PreviewBarItemVideo 0');
  await dt.sleep();

  dt.log.i('预期结果4、缩略图呈现逐帧展开状态,始终保持缩略进度');
  image = await dt.driver.findComponents(ON.type('Image').within(ON.id('PreviewBarItemVideo 0')));
  expect(image?.length > 1).assertTrue();
  await dt.sleep();
  dt.log.i('STEP 5、再次点击缩略条');

  await dt.sleep();
  dt.log.i('预期结果5、缩略图展开后再次点击无法收起');
  await dt.sleep();

  dt.log.i('STEP 6、视频向右/左翻页滑动到下一张');
  await dt.sleep();
  dt.log.i('预期结果6、翻页到1/4位置时，主缩图由视频比例显示为原有比例（1帧）');
  await dt.sleep();

  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频缩略图原有比例（1帧），视频比例收起态（2帧），逐帧xxx切换 end');
}