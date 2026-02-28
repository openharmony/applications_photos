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
export default function VideoThumbnailTest(): void {
  describe('VideoThumbnailTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllVideoThumbnailTest').init();
      dt.log.i('beforeAll VideoThumbnailTest start');
      dt.log.i('beforeAll VideoThumbnailTest finish');
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_004', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-连拍用例: [不同入口打开连拍图片界面显示] TID: Multimedia_Gallery_VideoPlayer_Frame_004
      await Multimedia_Gallery_VideoPlayer_Frame_004(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [横屏状态不同入口大图界面显示] TID: Multimedia_Gallery_VideoPlayer_Frame_005
      await Multimedia_Gallery_VideoPlayer_Frame_005(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [横屏状态不同入口视频界面显示] TID: Multimedia_Gallery_VideoPlayer_Frame_006
      await Multimedia_Gallery_VideoPlayer_Frame_006(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-进度条用例: [视频进度条显示] TID: Multimedia_Gallery_VideoPlayer_Frame_008
      await Multimedia_Gallery_VideoPlayer_Frame_008(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频时间胶囊显示] TID: Multimedia_Gallery_VideoPlayer_Frame_009
      await Multimedia_Gallery_VideoPlayer_Frame_009(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_011', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频缩略图收起态自动播放过程中暂停] TID: Multimedia_Gallery_VideoPlayer_Frame_011
      await Multimedia_Gallery_VideoPlayer_Frame_011(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_012', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频缩略图收起态自动播放后再次播放] TID: Multimedia_Gallery_VideoPlayer_Frame_012
      await Multimedia_Gallery_VideoPlayer_Frame_012(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_015', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频缩略图xxx播放结束后再次播放] TID: Multimedia_Gallery_VideoPlayer_Frame_015
      await Multimedia_Gallery_VideoPlayer_Frame_015(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_016', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [只有一张图片或者视频时大图浏览] TID: Multimedia_Gallery_VideoPlayer_Frame_016
      await Multimedia_Gallery_VideoPlayer_Frame_016(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_020', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频暂停缩略图收起态翻页切换] TID: Multimedia_Gallery_VideoPlayer_Frame_020
      await Multimedia_Gallery_VideoPlayer_Frame_020(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_021', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频暂停缩略图xxx翻页切换] TID: Multimedia_Gallery_VideoPlayer_Frame_021
      await Multimedia_Gallery_VideoPlayer_Frame_021(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_022', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频播放中缩略图收起态点击缩略图切换] TID: Multimedia_Gallery_VideoPlayer_Frame_022
      await Multimedia_Gallery_VideoPlayer_Frame_022(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_023', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频播放中缩略图xxx点击缩略图切换] TID: Multimedia_Gallery_VideoPlayer_Frame_023
      await Multimedia_Gallery_VideoPlayer_Frame_023(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_024', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频暂停缩略图收起态点击缩略图切换] TID: Multimedia_Gallery_VideoPlayer_Frame_024
      await Multimedia_Gallery_VideoPlayer_Frame_024(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_025', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频暂停缩略图xxx点击缩略图切换] TID: Multimedia_Gallery_VideoPlayer_Frame_025
      await Multimedia_Gallery_VideoPlayer_Frame_025(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_026', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [视频播放中缩略图收起态滑动缩略图切换] TID: Multimedia_Gallery_VideoPlayer_Frame_026
      await Multimedia_Gallery_VideoPlayer_Frame_026(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_027', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [视频播放中缩略图xxx滑动缩略图切换] TID: Multimedia_Gallery_VideoPlayer_Frame_027
      await Multimedia_Gallery_VideoPlayer_Frame_027(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_028', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [视频暂停缩略图收起态滑动缩略图切换] TID: Multimedia_Gallery_VideoPlayer_Frame_028
      await Multimedia_Gallery_VideoPlayer_Frame_028(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_029', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [视频暂停缩略图xxx滑动缩略图切换] TID: Multimedia_Gallery_VideoPlayer_Frame_029
      await Multimedia_Gallery_VideoPlayer_Frame_029(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_031', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [不同视频格式逐帧播放] TID: Multimedia_Gallery_VideoPlayer_Frame_031
      await Multimedia_Gallery_VideoPlayer_Frame_031(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_032', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [不同类型视频逐帧播放] TID: Multimedia_Gallery_VideoPlayer_Frame_032
      await Multimedia_Gallery_VideoPlayer_Frame_032(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_033', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [不同分辨率视频逐帧播放] TID: Multimedia_Gallery_VideoPlayer_Frame_033
      await Multimedia_Gallery_VideoPlayer_Frame_033(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_034', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [不同帧率视频逐帧播放] TID: Multimedia_Gallery_VideoPlayer_Frame_034
      await Multimedia_Gallery_VideoPlayer_Frame_034(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_035', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [不同时长视频逐帧播放] TID: Multimedia_Gallery_VideoPlayer_Frame_035
      await Multimedia_Gallery_VideoPlayer_Frame_035(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_036', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [不同来源视频逐帧播放] TID: Multimedia_Gallery_VideoPlayer_Frame_036
      await Multimedia_Gallery_VideoPlayer_Frame_036(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_037', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [不同视频比例逐帧播放] TID: Multimedia_Gallery_VideoPlayer_Frame_037
      await Multimedia_Gallery_VideoPlayer_Frame_037(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_038', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频缩略图收起态自动播放完成 Copy of (1)] TID: Multimedia_Gallery_VideoPlayer_Frame_038
      await Multimedia_Gallery_VideoPlayer_Frame_038(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_039', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频缩略图xxx自动播放完成 Copy of (1)] TID: Multimedia_Gallery_VideoPlayer_Frame_039
      await Multimedia_Gallery_VideoPlayer_Frame_039(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_040', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [缩略图展开后播放到一半-翻页] TID: Multimedia_Gallery_VideoPlayer_Frame_040
      await Multimedia_Gallery_VideoPlayer_Frame_040(dt);
    });
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachVideoThumbnailTest').init();
      dt.log.i('afterEach VideoThumbnailTest finish');
    });
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllVideoThumbnailTest').init();
      await Exit.browser();
      dt.log.i('afterAll VideoThumbnailTest finish');
    });
  });
}

/**
 * 大图-连拍: [不同入口打开连拍图片界面显示]
 * TAG: 392 TID: Multimedia_Gallery_VideoPlayer_Frame_004
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_004(dt: Dt) {
  dt.log.i('不同入口打开连拍图片界面显示 start');
  dt.log.i('STEP 1、从照片宫格，相册（系统相册，三方相册，来源相册，地点相册）入口进入查看连拍图片显示，观察界面布局');

  await dt.sleep();
  dt.log.i('预期结果1、底部tab依次分享，收藏，连拍图标，声音，编辑，删除按钮，右上角显示四方菜单按钮和云增强按钮');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从隐藏相册入口进入查看大图，观察界面布局');

  await dt.sleep();
  dt.log.i('预期结果2、底部tab依次显示收藏，连拍图标，编辑，删除，右上角显示四方菜单');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、从最近删除相册入口进入查看大图，观察界面布局');

  await dt.sleep();
  dt.log.i('预期结果3、底部tab依次显示复原，连拍图标，收藏，右上角显示四方菜单');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同入口打开连拍图片界面显示 end');
}

/**
 * 大图-大图: [横屏状态不同入口大图界面显示]
 * TAG: 394 TID: Multimedia_Gallery_VideoPlayer_Frame_005
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_005(dt: Dt) {
  dt.log.i('横屏状态不同入口大图界面显示 start');
  dt.log.i('STEP 1、开启横竖屏开关，进入图库，切换到横屏');

  await dt.sleep();
  dt.log.i('预期结果1、图库切换到横屏显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片宫格，相册（系统相册，三方相册，来源相册，地点相册）入口进入查看大图');

  await dt.sleep();
  dt.log.i('预期结果2、大图tab显示在右上角，依次为：分享，收藏，（动态图标/连拍图标），编辑，删除，四方菜单');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、从隐藏相册入口进入查看大图');

  await dt.sleep();
  dt.log.i('预期结果3、大图tab显示在右上角，依次为：收藏，（动态图标/连拍图标），编辑，删除，四方菜单');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、从最近删除相册入口进入查看大图');

  await dt.sleep();
  dt.log.i('预期结果4、大图tab显示在右上角，依次为：复原，（动态图标/连拍图标）删除，四方菜单');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、从相机入口查看大图');

  await dt.sleep();
  dt.log.i('预期结果5、大图tab显示在右上角，依次为：分享，收藏，（动态图标/连拍图标），编辑，删除，图库入口图标，四方菜单');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、从锁屏相机入口查看大图');

  await dt.sleep();
  dt.log.i('预期结果6、同相机入口一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('横屏状态不同入口大图界面显示 end');
}

/**
 * 大图-视频: [横屏状态不同入口视频界面显示]
 * TAG: 345 TID: Multimedia_Gallery_VideoPlayer_Frame_006
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_006(dt: Dt) {
  dt.log.i('横屏状态不同入口视频界面显示 start');
  dt.log.i('STEP 1、开启横竖屏开关，进入图库，切换到横屏');

  await dt.sleep();
  dt.log.i('预期结果1、图库切换到横屏显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、从照片宫格，相册（系统相册，三方相册，来源相册，地点相册）入口进入查看大图，视频界面布局');

  await dt.sleep();
  dt.log.i('预期结果2、视频tab显示在右上角，依次为：分享，收藏，视频播放按钮，声音，编辑，删除，四方菜单');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、从隐藏相册入口进入查看大图，视频界面布局');

  await dt.sleep();
  dt.log.i('预期结果3、视频tab显示在右上角，依次为：收藏，视频播放按钮，声音，编辑，删除，四方菜单');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、从最近删除相册入口进入查看大图，视频界面布局');

  await dt.sleep();
  dt.log.i('预期结果4、视频tab显示在右上角，依次为：复原，视频播放按钮，声音，删除，四方菜单');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、从相机入口查看大图/视频');

  await dt.sleep();
  dt.log.i('预期结果5、大图tab显示在右上角，依次为：分享，收藏，视频播放按钮，声音，编辑，删除，图库入口图标，四方菜单');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、从锁屏相机入口查看大图/视频');

  await dt.sleep();
  dt.log.i('预期结果6、同相机入口一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、从录屏入口查看视频');

  await dt.sleep();
  dt.log.i('预期结果7、同相机入口一致');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('横屏状态不同入口视频界面显示 end');
}

/**
 * 大图-进度条: [视频进度条显示]
 * TAG: 343 TID: Multimedia_Gallery_VideoPlayer_Frame_008
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_008(dt: Dt) {
  dt.log.i('视频进度条显示 start');
  dt.log.i('STEP 1、打开视频播放，观察进度条位置');

  await dt.sleep();
  dt.log.i('预期结果1、播放前在首帧左侧');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、缩略图收起状态视频播放，观察进度条位置');

  await dt.sleep();
  dt.log.i('预期结果2、播放过程中随视频进度移动');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、缩略图xxx视频播放，观察进度条位置');

  await dt.sleep();
  dt.log.i('预期结果3、进度条原地不动');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、缩略图收起态播放结束，观察进度条位置');

  await dt.sleep();
  dt.log.i('预期结果4、播放条自动回到起始位置并暂停');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、缩略图xxx播放结束，观察进度条位置');

  await dt.sleep();
  dt.log.i('预期结果5、播放条停留在结束位置');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、缩略图收起态切换到下一个视频，观察进度条');

  await dt.sleep();
  dt.log.i('预期结果6、播放定位条跟随主缩图的左侧边位移，慢慢消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、缩略图xxx切换到下一个视频，观察进度条');

  await dt.sleep();
  dt.log.i('预期结果7、播放定位条原地不动，慢慢消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频进度条显示 end');
}

/**
 * 大图-视频: [视频时间胶囊显示]
 * TAG: 349 TID: Multimedia_Gallery_VideoPlayer_Frame_009
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_009(dt: Dt) {
  dt.log.i('视频时间胶囊显示 start');
  dt.log.i('STEP 1、视频播放中缩略图收起态，点击底部缩略图，等待3s');

  await dt.sleep();
  dt.log.i('预期结果1、显示时间胶囊，时间随视频播放进度增长，过3s消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、视频播放中逐帧xxx，点击视频进入沉浸式，退出沉浸式，等待3s');

  await dt.sleep();
  dt.log.i('预期结果2、退出沉浸式后显示时间胶囊，时间随视频播放进度增长，过3s消失');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、视频播放中逐帧xxx，点击/拖动底部缩略图预览条，等待3s');

  await dt.sleep();
  dt.log.i('预期结果3、显示时间胶囊，，时间随视频播放进度增长，过3s消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、视频暂停缩略图收起态，点击底部缩略图，等待3s');

  await dt.sleep();
  dt.log.i('预期结果4、显示时间胶囊，时间不变，过3s消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、视频暂停逐帧xxx，点击视频进入沉浸式，退出沉浸式，等待3s');

  await dt.sleep();
  dt.log.i('预期结果5、退出沉浸式后显示时间胶囊，时间不变，过3s消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、视频暂停逐帧xxx，点击/拖动底部缩略图预览条，等待3s');

  await dt.sleep();
  dt.log.i('预期结果6、显示时间胶囊，时间不变，过3s消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、逐帧xxx，点击缩略图，未等待3s，翻页到下一张');

  await dt.sleep();
  dt.log.i('预期结果7、翻页后时间胶囊直接消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 8、视频缩略图收起态，播放一段时间暂停，再点击展开缩略图');

  await dt.sleep();
  dt.log.i('预期结果8、时间胶囊显示播放进度的时间');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频时间胶囊显示 end');
}

/**
 * 大图-视频: [视频缩略图收起态自动播放过程中暂停]
 * TAG: 353 TID: Multimedia_Gallery_VideoPlayer_Frame_011
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_011(dt: Dt) {
  dt.log.i('视频缩略图收起态自动播放过程中暂停 start');
  dt.log.i('STEP 1、打开视频，观察播放过程');

  await dt.sleep();
  dt.log.i('预期结果1.1、视频自动播放，缩略图默认保持收起状态，展示视频比例（两帧），1.2、播放按钮按钮从暂停（三角）变为播放（竖线）1.3、进度条随视频播放移动，大图画面同步刷新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、未播放结束时点击暂停');

  await dt.sleep();
  dt.log.i('预期结果2、视频暂停，缩略图保持收起状态，展示视频比例（两帧），进度条始终保持缩略进度');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次点击播放');

  await dt.sleep();
  dt.log.i('预期结果3、视频继续播放，进度条继续随播放移动');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、查看播放结束状态');

  await dt.sleep();
  dt.log.i('预期结果4、播放结束后进度条回到顶部，缩略图保持收起状态，播放按钮变为暂停状态（三角）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频缩略图收起态自动播放过程中暂停 end');
}

/**
 * 大图-视频: [视频缩略图收起态自动播放后再次播放]
 * TAG: 396 TID: Multimedia_Gallery_VideoPlayer_Frame_012
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_012(dt: Dt) {
  dt.log.i('视频缩略图收起态自动播放后再次播放 start');
  dt.log.i('STEP 1、打开视频，观察播放过程');

  await dt.sleep();
  dt.log.i('预期结果1.1、视频自动播放，缩略图默认保持收起状态，展示视频比例（两帧），1.2、播放按钮按钮从暂停（三角）变为播放（竖线）1.3、进度条随视频播放移动，大图画面同步刷新1.4、播放结束后进度条回到顶部，缩略图保持收起状态，播放按钮变为暂停状态（三角）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、播放结束后再次点击播放');

  await dt.sleep();
  dt.log.i('预期结果2、视频重新起播，同步骤1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频缩略图收起态自动播放后再次播放 end');
}

/**
 * 大图-视频: [视频缩略图xxx播放结束后再次播放]
 * TAG: 348 TID: Multimedia_Gallery_VideoPlayer_Frame_015
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_015(dt: Dt) {
  dt.log.i('视频缩略图xxx播放结束后再次播放 start');
  dt.log.i('STEP 1、打开视频');

  await dt.sleep();
  dt.log.i('预期结果1、视频自动播放，缩略图默认保持收起状态，展示视频比例（两帧）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击底部缩略条');

  await dt.sleep();
  dt.log.i('预期结果2、呈现逐帧展开状态,始终保持缩略进度，视频继续播放，进度条原地不动，缩略图随视频向左移动');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看播放结束状态');

  await dt.sleep();
  dt.log.i('预期结果3、播放结束,，播放按钮变为暂停状态，缩略条保持逐帧展开状态，进度条停留在最后一帧');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、播放结束后再次点击播放');

  await dt.sleep();
  dt.log.i('预期结果4、视频重新播放，进度条不动，缩略图从首帧开始像左移动，同步骤1,2,3');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频缩略图xxx播放结束后再次播放 end');
}

/**
 * 大图-视频: [只有一张图片或者视频时大图浏览]
 * TAG: 336 TID: Multimedia_Gallery_VideoPlayer_Frame_016
 * 前置条件
 * 1、图库无图片
 */
async function Multimedia_Gallery_VideoPlayer_Frame_016(dt: Dt) {
  dt.log.i('只有一张图片或者视频时大图浏览 start');
  dt.log.i('STEP 1、拍摄一张图片，打开大图');

  await dt.sleep();
  dt.log.i('预期结果1、底部不显示缩略图预览条');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、删除大图后拍摄一张视频，打开视频');

  await dt.sleep();
  dt.log.i('预期结果2、底部显示缩略图预览条');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('只有一张图片或者视频时大图浏览 end');
}

/**
 * 大图-视频: [视频暂停缩略图收起态翻页切换]
 * TAG: 368 TID: Multimedia_Gallery_VideoPlayer_Frame_020
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 2、首张为视频，最后一张是视频，中间存在视频大图相邻的图片
 3、保持视频暂停状态
 4、保持视频缩略图收起状态
 */
async function Multimedia_Gallery_VideoPlayer_Frame_020(dt: Dt) {
  dt.log.i('视频暂停缩略图收起态翻页切换 start');
  dt.log.i('STEP 1、首张视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果1、往前翻页有回弹动效，往后翻页切换到下一个视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、最后一张视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果2、往前翻页切换到上一张视频，往后翻页有回弹动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、中间视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果3、往前切换到上一张图片，往后切换到下一个图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、大图右滑打开视频');

  await dt.sleep();
  dt.log.i('预期结果4、缩略图从原有比例（1帧）变化为视频比例（2帧），出现进度条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、大图左滑打开视频');

  await dt.sleep();
  dt.log.i('预期结果5、缩略图从原有比例（1帧）变化为视频比例（2帧），出现进度条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、视频右滑到视频');

  await dt.sleep();
  dt.log.i('预期结果6、左边视频缩略图收起（1帧），右边视频缩略图从原有比例（1帧）变化为视频比例（2帧）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、视频左滑到视频');

  await dt.sleep();
  dt.log.i('预期结果7、右边视频缩略图收起（1帧），左边视频缩略图从原有比例（1帧）变化为视频比例（2帧）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频暂停缩略图收起态翻页切换 end');
}

/**
 * 大图-视频: [视频暂停缩略图xxx翻页切换]
 * TAG: 367 TID: Multimedia_Gallery_VideoPlayer_Frame_021
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 2、首张为视频，最后一张是视频，中间存在视频大图相邻的图片
 3、保持视频暂停状态
 4、保持视频缩略图展开状态
 */
async function Multimedia_Gallery_VideoPlayer_Frame_021(dt: Dt) {
  dt.log.i('视频暂停缩略图xxx翻页切换 start');
  dt.log.i('STEP 1、首张视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果1、往前翻页有回弹动效，往后翻页切换到下一个视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、最后一张视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果2、往前翻页切换到上一张视频，往后翻页有回弹动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、中间视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果3、往前切换到上一张图片，往后切换到下一个图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、大图右滑打开视频');

  await dt.sleep();
  dt.log.i('预期结果4、缩略图从原有比例（1帧）变化为视频比例（2帧），出现进度条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、大图左滑打开视频');

  await dt.sleep();
  dt.log.i('预期结果5、缩略图从原有比例（1帧）变化为视频比例（2帧），出现进度条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、视频右滑到视频');

  await dt.sleep();
  dt.log.i('预期结果6、左边视频缩略图收起（1帧），右边视频缩略图从原有比例（1帧）变化为视频比例（2帧）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、视频左滑到视频');

  await dt.sleep();
  dt.log.i('预期结果7、右边视频缩略图收起（1帧），左边视频缩略图从原有比例（1帧）变化为视频比例（2帧）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频暂停缩略图xxx翻页切换 end');
}

/**
 * 大图-视频: [视频播放中缩略图收起态点击缩略图切换]
 * TAG: 373 TID: Multimedia_Gallery_VideoPlayer_Frame_022
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 2、首张为视频，最后一张是视频，中间存在视频大图相邻的图片
 3、保持视频在播放
 4、保持视频缩略图收起状态
 */
async function Multimedia_Gallery_VideoPlayer_Frame_022(dt: Dt) {
  dt.log.i('视频播放中缩略图收起态点击缩略图切换 start');
  dt.log.i('STEP 1、点击首张视频切换');

  await dt.sleep();
  dt.log.i('预期结果1、原有视频缩略图收起，点击的视频从原有比例（1帧）变化为视频比例（2帧）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击中间视频切换');

  await dt.sleep();
  dt.log.i('预期结果2、同1');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击最后视频切换');

  await dt.sleep();
  dt.log.i('预期结果3、同1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中缩略图收起态点击缩略图切换 end');
}

/**
 * 大图-视频: [视频播放中缩略图xxx点击缩略图切换]
 * TAG: 369 TID: Multimedia_Gallery_VideoPlayer_Frame_023
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 2、首张为视频，最后一张是视频，中间存在视频大图相邻的图片
 3、保持视频在播放
 4、保持视频缩略图展开状态
 */
async function Multimedia_Gallery_VideoPlayer_Frame_023(dt: Dt) {
  dt.log.i('视频播放中缩略图xxx点击缩略图切换 start');
  dt.log.i('STEP 1、点击首张视频切换');

  await dt.sleep();
  dt.log.i('预期结果1、原有视频缩略图收起，点击的视频从原有比例（1帧）变化为视频比例（2帧）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击中间视频切换');

  await dt.sleep();
  dt.log.i('预期结果2、同1');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击最后视频切换');

  await dt.sleep();
  dt.log.i('预期结果3、同1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中缩略图xxx点击缩略图切换 end');
}

/**
 * 大图-视频: [视频暂停缩略图收起态点击缩略图切换]
 * TAG: 374 TID: Multimedia_Gallery_VideoPlayer_Frame_024
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 2、首张为视频，最后一张是视频，中间存在视频大图相邻的图片
 3、保持视频暂停状态
 4、保持视频缩略图收起状态
 */
async function Multimedia_Gallery_VideoPlayer_Frame_024(dt: Dt) {
  dt.log.i('视频暂停缩略图收起态点击缩略图切换 start');
  dt.log.i('STEP 1、点击首张视频切换');

  await dt.sleep();
  dt.log.i('预期结果1、原有视频缩略图收起，点击的视频从原有比例（1帧）变化为视频比例（2帧）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击中间视频切换');

  await dt.sleep();
  dt.log.i('预期结果2、同1');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击最后视频切换');

  await dt.sleep();
  dt.log.i('预期结果3、同1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频暂停缩略图收起态点击缩略图切换 end');
}

/**
 * 大图-视频: [视频暂停缩略图xxx点击缩略图切换]
 * TAG: 371 TID: Multimedia_Gallery_VideoPlayer_Frame_025
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 2、首张为视频，最后一张是视频，中间存在视频大图相邻的图片
 3、保持视频暂停状态
 4、保持视频缩略图展开状态
 */
async function Multimedia_Gallery_VideoPlayer_Frame_025(dt: Dt) {
  dt.log.i('视频暂停缩略图xxx点击缩略图切换 start');
  dt.log.i('STEP 1、点击首张视频切换');

  await dt.sleep();
  dt.log.i('预期结果1、原有视频缩略图收起，点击的视频从原有比例（1帧）变化为视频比例（2帧）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击中间视频切换');

  await dt.sleep();
  dt.log.i('预期结果2、同1');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击最后视频切换');

  await dt.sleep();
  dt.log.i('预期结果3、同1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频暂停缩略图xxx点击缩略图切换 end');
}

/**
 * 大图-滑动: [视频播放中缩略图收起态滑动缩略图切换]
 * TAG: 376 TID: Multimedia_Gallery_VideoPlayer_Frame_026
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 2、首张为视频，最后一张是视频，中间存在视频大图相邻的图片
 3、保持视频在播放
 4、保持视频缩略图收起状态
 */
async function Multimedia_Gallery_VideoPlayer_Frame_026(dt: Dt) {
  dt.log.i('视频播放中缩略图收起态滑动缩略图切换 start');
  dt.log.i('STEP 1、首张视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果1、往前翻页有回弹动效，往后翻页切换到下一个视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、最后一张视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果2、往前翻页切换到上一张视频，往后翻页有回弹动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、中间视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果3、往前切换到上一张图片，往后切换到下一个图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、大图右滑打开视频');

  await dt.sleep();
  dt.log.i('预期结果4、缩略图从原有比例（1帧）变化为视频比例（2帧），出现进度条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、大图左滑打开视频');

  await dt.sleep();
  dt.log.i('预期结果5、缩略图从原有比例（1帧）变化为视频比例（2帧），出现进度条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、视频右滑到视频');

  await dt.sleep();
  dt.log.i('预期结果6、左边视频缩略图收起（1帧），右边视频缩略图从原有比例（1帧）变化为视频比例（2帧）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、视频左滑到视频');

  await dt.sleep();
  dt.log.i('预期结果7、右边视频缩略图收起（1帧），左边视频缩略图从原有比例（1帧）变化为视频比例（2帧）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中缩略图收起态滑动缩略图切换 end');
}

/**
 * 大图-滑动: [视频播放中缩略图xxx滑动缩略图切换]
 * TAG: 387 TID: Multimedia_Gallery_VideoPlayer_Frame_027
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 2、首张为视频，最后一张是视频，中间存在视频大图相邻的图片
 3、保持视频在播放
 4、保持视频缩略图展开状态
 */
async function Multimedia_Gallery_VideoPlayer_Frame_027(dt: Dt) {
  dt.log.i('视频播放中缩略图xxx滑动缩略图切换 start');
  dt.log.i('STEP 1、首张视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果1、往前翻页有回弹动效，往后翻页切换到下一个视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、最后一张视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果2、往前翻页切换到上一张视频，往后翻页有回弹动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、中间视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果3、往前切换到上一张图片，往后切换到下一个图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、大图右滑打开视频');

  await dt.sleep();
  dt.log.i('预期结果4、缩略图从原有比例（1帧）变化为视频比例（2帧），出现进度条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、大图左滑打开视频');

  await dt.sleep();
  dt.log.i('预期结果5、缩略图从原有比例（1帧）变化为视频比例（2帧），出现进度条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、视频右滑到视频');

  await dt.sleep();
  dt.log.i('预期结果6、左边视频缩略图为收起（1帧），右边视频缩略图从原有比例（1帧）变化为视频比例（2帧）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、视频左滑到视频');

  await dt.sleep();
  dt.log.i('预期结果7、右边视频缩略图收起（1帧），左边视频缩略图从原有比例（1帧）变化为视频比例（2帧）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中缩略图xxx滑动缩略图切换 end');
}

/**
 * 大图-滑动: [视频暂停缩略图收起态滑动缩略图切换]
 * TAG: 378 TID: Multimedia_Gallery_VideoPlayer_Frame_028
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 2、首张为视频，最后一张是视频，中间存在视频大图相邻的图片
 3、保持视频暂停状态
 4、保持视频缩略图收起状态
 */
async function Multimedia_Gallery_VideoPlayer_Frame_028(dt: Dt) {
  dt.log.i('视频暂停缩略图收起态滑动缩略图切换 start');
  dt.log.i('STEP 1、首张视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果1、往前翻页有回弹动效，往后翻页切换到下一个视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、最后一张视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果2、往前翻页切换到上一张视频，往后翻页有回弹动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、中间视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果3、往前切换到上一张图片，往后切换到下一个图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、大图右滑打开视频');

  await dt.sleep();
  dt.log.i('预期结果4、缩略图从原有比例（1帧）变化为视频比例（2帧），出现进度条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、大图左滑打开视频');

  await dt.sleep();
  dt.log.i('预期结果5、缩略图从原有比例（1帧）变化为视频比例（2帧），出现进度条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、视频右滑到视频');

  await dt.sleep();
  dt.log.i('预期结果6、左边视频缩略图收起（1帧），右边视频缩略图从原有比例（1帧）变化为视频比例（2帧）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、视频左滑到视频');

  await dt.sleep();
  dt.log.i('预期结果7、右边视频缩略图收起（1帧），左边视频缩略图从原有比例（1帧）变化为视频比例（2帧）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频暂停缩略图收起态滑动缩略图切换 end');
}

/**
 * 大图-滑动: [视频暂停缩略图xxx滑动缩略图切换]
 * TAG: 386 TID: Multimedia_Gallery_VideoPlayer_Frame_029
 * 前置条件
 * 1、图库预制视频资源，包括本地视频，云端视频
 2、首张为视频，最后一张是视频，中间存在视频大图相邻的图片
 3、保持视频暂停状态
 4、保持视频缩略图展开状态
 */
async function Multimedia_Gallery_VideoPlayer_Frame_029(dt: Dt) {
  dt.log.i('视频暂停缩略图xxx滑动缩略图切换 start');
  dt.log.i('STEP 1、首张视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果1、往前翻页有回弹动效，往后翻页切换到下一个视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、最后一张视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果2、往前翻页切换到上一张视频，往后翻页有回弹动效');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、中间视频往前滑动翻页，往后滑动翻页');

  await dt.sleep();
  dt.log.i('预期结果3、往前切换到上一张图片，往后切换到下一个图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、大图右滑打开视频');

  await dt.sleep();
  dt.log.i('预期结果4、缩略图从原有比例（1帧）变化为视频比例（2帧），出现进度条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、大图左滑打开视频');

  await dt.sleep();
  dt.log.i('预期结果5、缩略图从原有比例（1帧）变化为视频比例（2帧），出现进度条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、视频右滑到视频');

  await dt.sleep();
  dt.log.i('预期结果6、左边视频缩略图收起（1帧），右边视频缩略图从原有比例（1帧）变化为视频比例（2帧）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、视频左滑到视频');

  await dt.sleep();
  dt.log.i('预期结果7、右边视频缩略图收起（1帧），左边视频缩略图从原有比例（1帧）变化为视频比例（2帧）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频暂停缩略图xxx滑动缩略图切换 end');
}

/**
 * 大图-格式: [不同视频格式逐帧播放]
 * TAG: 383 TID: Multimedia_Gallery_VideoPlayer_Frame_031
 * 前置条件
 * 1、预制不同视频格式视频（支持视频编解码格式
 •支持硬件H264 /H265编码
 •支持硬件H264/H265
 •支持HDR vivid编解码
 •支持H264软件解码/H265软解（5.0））
 2、预制不支持的其余格式
 */
async function Multimedia_Gallery_VideoPlayer_Frame_031(dt: Dt) {
  dt.log.i('不同视频格式逐帧播放 start');
  dt.log.i('STEP 1、覆盖支持的不同格式的视频，打开视频播放');

  await dt.sleep();
  dt.log.i('预期结果1、视频正常播放，支持逐帧播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、打开不支持格式的视频播放');

  await dt.sleep();
  dt.log.i('预期结果2、视频播放失败，提示“格式不支持”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('格式不支持');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同视频格式逐帧播放 end');
}

/**
 * 大图-视频: [不同类型视频逐帧播放]
 * TAG: 377 TID: Multimedia_Gallery_VideoPlayer_Frame_032
 * 前置条件
 * 1、预制普通视频，慢动作视频，HDR视频等
 */
async function Multimedia_Gallery_VideoPlayer_Frame_032(dt: Dt) {
  dt.log.i('不同类型视频逐帧播放 start');
  dt.log.i('STEP 1、打开普通视频播放');

  await dt.sleep();
  dt.log.i('预期结果1、视频正常播放，支持逐帧播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、打开慢动作视频播放');

  await dt.sleep();
  dt.log.i('预期结果2、视频正常播放，支持逐帧播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、打开HDR格式视频播放');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放，支持逐帧播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、其他类型视频依次覆盖');

  await dt.sleep();
  dt.log.i('预期结果4、视频正常播放，支持逐帧播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同类型视频逐帧播放 end');
}

/**
 * 大图-视频: [不同分辨率视频逐帧播放]
 * TAG: 375 TID: Multimedia_Gallery_VideoPlayer_Frame_033
 * 前置条件
 * 1、预制不同分辨率的视频，分别覆盖4k,1080p,720p
 */
async function Multimedia_Gallery_VideoPlayer_Frame_033(dt: Dt) {
  dt.log.i('不同分辨率视频逐帧播放 start');
  dt.log.i('STEP 1、覆盖不同分辨率视频播放');

  await dt.sleep();
  dt.log.i('预期结果1、视频正常播放，支持逐帧播放');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同分辨率视频逐帧播放 end');
}

/**
 * 大图-视频: [不同帧率视频逐帧播放]
 * TAG: 382 TID: Multimedia_Gallery_VideoPlayer_Frame_034
 * 前置条件
 * 1、预制不同帧率的视频，分别覆盖30fps，60fps
 */
async function Multimedia_Gallery_VideoPlayer_Frame_034(dt: Dt) {
  dt.log.i('不同帧率视频逐帧播放 start');
  dt.log.i('STEP 1、覆盖不同帧率视频播放');

  await dt.sleep();
  dt.log.i('预期结果1、视频正常播放，支持逐帧播放');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同帧率视频逐帧播放 end');
}

/**
 * 大图-视频: [不同时长视频逐帧播放]
 * TAG: 385 TID: Multimedia_Gallery_VideoPlayer_Frame_035
 * 前置条件
 * 1、预制不同时长的视频，最小300ms，1s，1分钟，5分钟，20分钟
 */
async function Multimedia_Gallery_VideoPlayer_Frame_035(dt: Dt) {
  dt.log.i('不同时长视频逐帧播放 start');
  dt.log.i('STEP 1、覆盖不同视频播放');

  await dt.sleep();
  dt.log.i('预期结果1、视频正常播放，支持逐帧播放');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同时长视频逐帧播放 end');
}

/**
 * 大图-视频: [不同来源视频逐帧播放]
 * TAG: 388 TID: Multimedia_Gallery_VideoPlayer_Frame_036
 * 前置条件
 * 1、预制不同来源的视频，本地视频，云端视频，xxx同步视频，克隆的视频，分享的视频，三方保存视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_036(dt: Dt) {
  dt.log.i('不同来源视频逐帧播放 start');
  dt.log.i('STEP 1、覆盖所有视频播放');

  await dt.sleep();
  dt.log.i('预期结果1、视频正常播放，支持逐帧播放');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同来源视频逐帧播放 end');
}

/**
 * 大图-视频: [不同视频比例逐帧播放]
 * TAG: 384 TID: Multimedia_Gallery_VideoPlayer_Frame_037
 * 前置条件
 * 1、预制不同比例的视频，16:9，全屏，4:3,1:1,xxx，竞品支持的比例视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_037(dt: Dt) {
  dt.log.i('不同视频比例逐帧播放 start');
  dt.log.i('STEP 1、覆盖所有视频播放');

  await dt.sleep();
  dt.log.i('预期结果1、视频正常播放，支持逐帧播放');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同视频比例逐帧播放 end');
}

/**
 * 大图-视频: [视频缩略图收起态自动播放完成 Copy of (1)]
 * TAG: 389 TID: Multimedia_Gallery_VideoPlayer_Frame_038
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_038(dt: Dt) {
  dt.log.i('视频缩略图收起态自动播放完成 Copy of (1) start');
  dt.log.i('STEP 1、大图翻页到视频自动播放，观察界面动效');

  await dt.sleep();
  dt.log.i('预期结果1、大图翻页到视频时，翻过去会先显示原有比例，再展开变成视频比例（两帧），并进入自动播放；');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2、自动播放结束后，播放条自动回到初始位置并暂停；');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3、滑动大图翻页时，新大图边缘位移到屏幕的1\4位置，才出发切换底部图标与云增强图标；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果4、滑动翻页时，主缩图的收起，缩放锚点的位置会以滑动方向来确认；     大图向左划，缩图锚点在左侧，大图向右划，缩图锚点在右侧');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果5、缩图收起的缩放与位移弹簧与大图翻页的弹簧一致，跟手时1:1跟手，离手后继承手速做离手运动。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果6、缩图两帧大图翻页时，播放定位条跟随主缩图的左侧边位移，并不透明度100%-0%， Sharp curve淡出');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频缩略图收起态自动播放完成 Copy of (1) end');
}

/**
 * 大图-视频: [视频缩略图xxx自动播放完成 Copy of (1)]
 * TAG: 381 TID: Multimedia_Gallery_VideoPlayer_Frame_039
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_039(dt: Dt) {
  dt.log.i('视频缩略图xxx自动播放完成 Copy of (1) start');
  dt.log.i('STEP 1、大图翻页到视频后点击缩略图展开自动播放，观察界面动效');

  await dt.sleep();
  dt.log.i('预期结果1、大图翻页到视频时，翻过去会先显示原有比例，再展开变成视频比例（两帧），并进入自动播放；');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2、自动播放结束后，播放条暂停在结束位置；');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3、滑动大图翻页时，新大图边缘位移到屏幕的1\4位置，再触发切换底部图标与云增强图标；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果4、滑动翻页时，主缩图的收起，缩放锚点的位置会以滑动方向来确认；大图向左划，缩图锚点在左侧，大图向右划，缩图锚点在右侧');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果5、缩图收起的缩放与位移弹簧与大图翻页的弹簧一致，跟手时1:1跟手，离手后继承手速做离手运动。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果6、缩图两帧大图翻页时，播放定位条跟随主缩图的左侧边位移，并不透明度100%-0%， Sharp curve淡出');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频缩略图xxx自动播放完成 Copy of (1) end');
}

/**
 * 大图-滑动: [缩略图展开后播放到一半-翻页]
 * TAG: 391 TID: Multimedia_Gallery_VideoPlayer_Frame_040
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_040(dt: Dt) {
  dt.log.i('缩略图展开后播放到一半-翻页 start');
  dt.log.i('STEP 1、视频点击缩略图展开，播放到一半后，翻页，观察界面动效');

  await dt.sleep();
  dt.log.i('预期结果1、播放结束后，播放条自动回到固定在结束位置');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2、滑动翻页时，主缩图的收起，缩放锚点的位置会以滑动方向来确认；大图向左划，缩图锚点在左侧，大图向右划，缩图锚点在右侧');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3、缩图收起的缩放与位移弹簧与大图翻页的弹簧一致，跟手时1:1跟手，离手后继承手速做离手运动。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果4、缩图全展开大图翻页时，播放定位条原地不透明度100%-0%， Sharp curve淡出');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('预期结果5、手拖拽长缩图时，会出现时间胶囊，3s后淡出');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('缩略图展开后播放到一半-翻页 end');
}

