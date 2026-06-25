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
export default function VideoShowTest(): void {
  describe('VideoShowTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllVideoShowTest').init();
      dt.log.i('beforeAll VideoShowTest start');
      dt.log.i('beforeAll VideoShowTest finish');
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_041', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [缩略图展开播放结束-翻页] TID: Multimedia_Gallery_VideoPlayer_Frame_041
      await Multimedia_Gallery_VideoPlayer_Frame_041(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_042', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-沉浸用例: [视频进入/退出沉浸式] TID: Multimedia_Gallery_VideoPlayer_Frame_042
      await Multimedia_Gallery_VideoPlayer_Frame_042(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_043', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频双击放大] TID: Multimedia_Gallery_VideoPlayer_Frame_043
      await Multimedia_Gallery_VideoPlayer_Frame_043(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_044', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频双指捏合放大缩小] TID: Multimedia_Gallery_VideoPlayer_Frame_044
      await Multimedia_Gallery_VideoPlayer_Frame_044(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_045', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频侧滑/下拉返回宫格页] TID: Multimedia_Gallery_VideoPlayer_Frame_045
      await Multimedia_Gallery_VideoPlayer_Frame_045(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_046', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频分享] TID: Multimedia_Gallery_VideoPlayer_Frame_046
      await Multimedia_Gallery_VideoPlayer_Frame_046(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_047', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [视频收藏/取消收藏] TID: Multimedia_Gallery_VideoPlayer_Frame_047
      await Multimedia_Gallery_VideoPlayer_Frame_047(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_048', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频播放开启/关闭声音按钮] TID: Multimedia_Gallery_VideoPlayer_Frame_048
      await Multimedia_Gallery_VideoPlayer_Frame_048(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_049', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频进入退出编辑] TID: Multimedia_Gallery_VideoPlayer_Frame_049
      await Multimedia_Gallery_VideoPlayer_Frame_049(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_050', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [视频删除/恢复] TID: Multimedia_Gallery_VideoPlayer_Frame_050
      await Multimedia_Gallery_VideoPlayer_Frame_050(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_051', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频添加相册] TID: Multimedia_Gallery_VideoPlayer_Frame_051
      await Multimedia_Gallery_VideoPlayer_Frame_051(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_052', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频隐藏/取消隐藏] TID: Multimedia_Gallery_VideoPlayer_Frame_052
      await Multimedia_Gallery_VideoPlayer_Frame_052(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_053', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [视频上滑/查看详细信息] TID: Multimedia_Gallery_VideoPlayer_Frame_053
      await Multimedia_Gallery_VideoPlayer_Frame_053(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_054', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [云端视频逐帧播放] TID: Multimedia_Gallery_VideoPlayer_Frame_054
      await Multimedia_Gallery_VideoPlayer_Frame_054(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_055', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [云端视频播放前断网] TID: Multimedia_Gallery_VideoPlayer_Frame_055
      await Multimedia_Gallery_VideoPlayer_Frame_055(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_056', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-端云用例: [云端播放过程中断网] TID: Multimedia_Gallery_VideoPlayer_Frame_056
      await Multimedia_Gallery_VideoPlayer_Frame_056(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_057', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [picker界面播放视频] TID: Multimedia_Gallery_VideoPlayer_Frame_057
      await Multimedia_Gallery_VideoPlayer_Frame_057(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_058', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [控件key值核查（命名、事件控件）] TID: Multimedia_Gallery_VideoPlayer_Frame_058
      await Multimedia_Gallery_VideoPlayer_Frame_058(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_059', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [逐帧播放性能-滑动逐帧播放刷新帧率] TID: Multimedia_Gallery_VideoPlayer_Frame_059
      await Multimedia_Gallery_VideoPlayer_Frame_059(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_060', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-进度条用例: [逐帧播放性能-起播时延] TID: Multimedia_Gallery_VideoPlayer_Frame_060
      await Multimedia_Gallery_VideoPlayer_Frame_060(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_061', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [逐帧播放功耗-峰值内存] TID: Multimedia_Gallery_VideoPlayer_Frame_061
      await Multimedia_Gallery_VideoPlayer_Frame_061(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_062', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-预览条用例: [大数据打点] TID: Multimedia_Gallery_VideoPlayer_Frame_062
      await Multimedia_Gallery_VideoPlayer_Frame_062(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_080', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [非HDR视频不同类型视频显示效果] TID: Multimedia_Gallery_VideoPlayer_Frame_080
      await Multimedia_Gallery_VideoPlayer_Frame_080(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_085', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [深色模式下HDR视频显示效果] TID: Multimedia_Gallery_VideoPlayer_Frame_085
      await Multimedia_Gallery_VideoPlayer_Frame_085(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_086', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-竖屏用例: [横竖屏下HDR视频显示效果] TID: Multimedia_Gallery_VideoPlayer_Frame_086
      await Multimedia_Gallery_VideoPlayer_Frame_086(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_087', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [分屏悬浮窗下HDR视频显示效果] TID: Multimedia_Gallery_VideoPlayer_Frame_087
      await Multimedia_Gallery_VideoPlayer_Frame_087(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_088', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [操作HDR视频显示效果] TID: Multimedia_Gallery_VideoPlayer_Frame_088
      await Multimedia_Gallery_VideoPlayer_Frame_088(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_089', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [xxx拍摄的HDR视频云同步/分享/克隆后显示效果] TID: Multimedia_Gallery_VideoPlayer_Frame_089
      await Multimedia_Gallery_VideoPlayer_Frame_089(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_090', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [xxx拍摄的HDR视频云同步/分享/克隆后显示] TID: Multimedia_Gallery_VideoPlayer_Frame_090
      await Multimedia_Gallery_VideoPlayer_Frame_090(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_091', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [播放HDR视频性能测试用例] TID: Multimedia_Gallery_VideoPlayer_Frame_091
      await Multimedia_Gallery_VideoPlayer_Frame_091(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_092', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-HDR用例: [播放HDR视频功耗测试用例] TID: Multimedia_Gallery_VideoPlayer_Frame_092
      await Multimedia_Gallery_VideoPlayer_Frame_092(dt);
    });
    run('Multimedia_Gallery_VideoPlayer_Frame_199', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [大图界面删除图片后视频可以正常播放] TID: Multimedia_Gallery_VideoPlayer_Frame_199
      await Multimedia_Gallery_VideoPlayer_Frame_199(dt);
    });
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachVideoShowTest').init();
      dt.log.i('afterEach VideoShowTest finish');
    });
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllVideoShowTest').init();
      await Exit.browser();
      dt.log.i('afterAll VideoShowTest finish');
    });
  });
}

/**
 * 大图-删除: [缩略图展开播放结束-翻页]
 * TAG: 393 TID: Multimedia_Gallery_VideoPlayer_Frame_041
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_041(dt: Dt) {
  dt.log.i('缩略图展开播放结束-翻页 start');
  dt.log.i('STEP 1、视频点击缩略图展开，播放结束后，翻页，观察界面动效');

  await dt.sleep();
  dt.log.i('预期结果1、视频播放结束后翻页，长缩图收起时会以当前屏幕内的缩图长度收起，并在收起至两帧宽度时，首帧图片开始淡入；');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2、长缩图收起时，左侧缩图从屏外位移至目标位置。并保持与长缩图之间的间距不变');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('缩略图展开播放结束-翻页 end');
}

/**
 * 大图-沉浸: [视频进入/退出沉浸式]
 * TAG: 395 TID: Multimedia_Gallery_VideoPlayer_Frame_042
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_042(dt: Dt) {
  dt.log.i('视频进入/退出沉浸式 start');
  dt.log.i('STEP 1、图库入口打开视频');

  await dt.sleep();
  dt.log.i('预期结果1、视频默认非沉浸式状态，自动播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击视频');

  await dt.sleep();
  dt.log.i('预期结果2、视频进入沉浸式状态，视频播放不受影响');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次点击视频');

  await dt.sleep();
  dt.log.i('预期结果3、视频退出沉浸式，视频播放不受影响');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、视频暂停后单击页面');

  await dt.sleep();
  dt.log.i('预期结果4、视频进入沉浸式，视频保存暂停状态');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、再次点击视频');

  await dt.sleep();
  dt.log.i('预期结果5、视频退出沉浸式，视频保存暂停状态');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频进入/退出沉浸式 end');
}

/**
 * 大图-视频: [视频双击放大]
 * TAG: 344 TID: Multimedia_Gallery_VideoPlayer_Frame_043
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_043(dt: Dt) {
  dt.log.i('视频双击放大 start');
  dt.log.i('STEP 1、视频播放状态，双击视频');

  await dt.sleep();
  dt.log.i('预期结果1、视频放大，进入沉浸式状态，视频播放不受影响');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、再次双击视频');

  await dt.sleep();
  dt.log.i('预期结果2、视频缩小，保持沉浸式状态，播放状态不手影响');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、视频暂停状态，双击视频');

  await dt.sleep();
  dt.log.i('预期结果3、视频放大，进入沉浸式状态,暂停状态不受影响');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、再次双击视频');

  await dt.sleep();
  dt.log.i('预期结果4、视频缩小，保持沉浸式状态,暂停状态不受影响');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频双击放大 end');
}

/**
 * 大图-视频: [视频双指捏合放大缩小]
 * TAG: 397 TID: Multimedia_Gallery_VideoPlayer_Frame_044
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_044(dt: Dt) {
  dt.log.i('视频双指捏合放大缩小 start');
  dt.log.i('STEP 1、视频播放状态，双指捏合放大');

  await dt.sleep();
  dt.log.i('预期结果1、视频进入沉浸式，随双指捏合放大，到一定比例后无法放大，有回弹效果，视频播放不受影响');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、视频播放状态，双指捏合缩小');

  await dt.sleep();
  dt.log.i('预期结果2、保持沉浸式，随双指捏合缩小，到一定比例后无法缩小，有回弹效果，视频播放不受影响');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、视频暂停状态，双击捏合放大');

  await dt.sleep();
  dt.log.i('预期结果3、视频进入沉浸式，随双指捏合放大，到一定比例后无法放大，有回弹效果，视频保持暂停状态');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、视频暂停状态，双击捏合缩小');

  await dt.sleep();
  dt.log.i('预期结果4、视频进入沉浸式，随双指捏合放大，到一定比例后无法放大，有回弹效果，视频保持暂停状态');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频双指捏合放大缩小 end');
}

/**
 * 大图-视频: [视频侧滑/下拉返回宫格页]
 * TAG: 340 TID: Multimedia_Gallery_VideoPlayer_Frame_045
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_045(dt: Dt) {
  dt.log.i('视频侧滑/下拉返回宫格页 start');
  dt.log.i('STEP 1、视频播放状态侧滑返回/下拉返回');

  await dt.sleep();
  dt.log.i('预期结果1、返回到宫格页，视频暂停播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、再次打开视频');

  await dt.sleep();
  dt.log.i('预期结果2、进度清空，重新播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、视频暂停状态侧滑返回/下拉返回');

  await dt.sleep();
  dt.log.i('预期结果3、返回到宫格页');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、再次打开视频');

  await dt.sleep();
  dt.log.i('预期结果4、进度清空，重新播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频侧滑/下拉返回宫格页 end');
}

/**
 * 大图-视频: [视频分享]
 * TAG: 347 TID: Multimedia_Gallery_VideoPlayer_Frame_046
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_046(dt: Dt) {
  dt.log.i('视频分享 start');
  dt.log.i('STEP 1、视频播放状态点击分享');

  await dt.sleep();
  dt.log.i('预期结果1、拉起分享页面，预览图显示封面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、视频暂停状态点击分享');

  await dt.sleep();
  dt.log.i('预期结果2、拉起分享页面，预览条显示封面');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频分享 end');
}

/**
 * 大图-收藏: [视频收藏/取消收藏]
 * TAG: 339 TID: Multimedia_Gallery_VideoPlayer_Frame_047
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_047(dt: Dt) {
  dt.log.i('视频收藏/取消收藏 start');
  dt.log.i('STEP 1、视频播放状态点击收藏');

  await dt.sleep();
  dt.log.i('预期结果1、收藏图标变蓝，视频播放不受影响，视频出现在收藏相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、视频暂停状态点击收藏');

  await dt.sleep();
  dt.log.i('预期结果2、收藏图标变蓝，视频暂停不受影响，视频出现在收藏相册');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、视频播放状态取消收藏');

  await dt.sleep();
  dt.log.i('预期结果3、收藏图标变白，视频播放不受影响，视频在收藏相册消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、视频暂停状态取消收藏');

  await dt.sleep();
  dt.log.i('预期结果4、收藏图标变白，视频暂停不受影响，视频在收藏相册消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频收藏/取消收藏 end');
}

/**
 * 大图-视频: [视频播放开启/关闭声音按钮]
 * TAG: 351 TID: Multimedia_Gallery_VideoPlayer_Frame_048
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_048(dt: Dt) {
  dt.log.i('视频播放开启/关闭声音按钮 start');
  dt.log.i('STEP 1、声音按钮开启后，打开视频');

  await dt.sleep();
  dt.log.i('预期结果1、视频有声播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、切换视频');

  await dt.sleep();
  dt.log.i('预期结果2、切换视频后，默认开启声音播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、声音按钮关闭，打开视频');

  await dt.sleep();
  dt.log.i('预期结果3、视频无声播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、切换视频');

  await dt.sleep();
  dt.log.i('预期结果4、切换视频后，默认关闭声音播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放开启/关闭声音按钮 end');
}

/**
 * 大图-视频: [视频进入退出编辑]
 * TAG: 346 TID: Multimedia_Gallery_VideoPlayer_Frame_049
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_049(dt: Dt) {
  dt.log.i('视频进入退出编辑 start');
  dt.log.i('STEP 1、视频播放过程中进入编辑页面');

  await dt.sleep();
  dt.log.i('预期结果1、进入编辑页面,视频暂停，预览图显示视频封面，进度停留在初始位置');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、退出编辑页面');

  await dt.sleep();
  dt.log.i('预期结果2、视频进度清空，从头开始自动播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、视频暂停过程中进入编辑页面');

  await dt.sleep();
  dt.log.i('预期结果3、进入编辑页面，视频保持暂停，预览图显示视频封面，进度停留在初始位置');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、退出编辑页面');

  await dt.sleep();
  dt.log.i('预期结果4、');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、视频缩略图xxx进编辑');

  await dt.sleep();
  dt.log.i('STEP 6、退出编辑');

  await dt.sleep();
  dt.log.i('STEP 7、视频缩略图收起态进编辑');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频进入退出编辑 end');
}

/**
 * 大图-删除: [视频删除/恢复]
 * TAG: 350 TID: Multimedia_Gallery_VideoPlayer_Frame_050
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_050(dt: Dt) {
  dt.log.i('视频删除/恢复 start');
  dt.log.i('STEP 1、视频缩略图xxx播放过程中删除/恢复');

  await dt.sleep();
  dt.log.i('预期结果1、删除/恢复过程中播放不受影响，删除/恢复成功后视频消失，切换到下一张，删除/恢复动效流畅');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、视频缩略图xxx暂停过程中删除/恢复');

  await dt.sleep();
  dt.log.i('预期结果2、删除/恢复成功后视频消失，切换到下一张，删除/恢复动效流畅');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、视频缩略图收起态播放过程中删除/恢复');

  await dt.sleep();
  dt.log.i('预期结果3、删除/恢复过程中播放不受影响，删除/恢复成功后视频消失，切换到下一张，删除/恢复动效流畅');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、视频缩略图收起态暂停过程中删除/恢复');

  await dt.sleep();
  dt.log.i('预期结果4、删除/恢复成功后视频消失，切换到下一张，删除/恢复动效流畅');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、视频删除后到删除相册查看');

  await dt.sleep();
  dt.log.i('预期结果5、删除的视频出现在删除相册');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、视频恢复后到视频相册查看');

  await dt.sleep();
  dt.log.i('预期结果6、恢复的视频出现在视频相册');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频删除/恢复 end');
}

/**
 * 大图-视频: [视频添加相册]
 * TAG: 354 TID: Multimedia_Gallery_VideoPlayer_Frame_051
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_051(dt: Dt) {
  dt.log.i('视频添加相册 start');
  dt.log.i('STEP 1、视频播放过程中添加到相册');

  await dt.sleep();
  dt.log.i('预期结果1、添加过程中视频播放不受影响，保持原状态继续播放，添加成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、视频暂停过程中添加到相册');

  await dt.sleep();
  dt.log.i('预期结果2、添加过程中视频状态不受影响，添加成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、到已添加视频的相册中查看');

  await dt.sleep();
  dt.log.i('预期结果3、添加的视频出现在相册');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频添加相册 end');
}

/**
 * 大图-视频: [视频隐藏/取消隐藏]
 * TAG: 357 TID: Multimedia_Gallery_VideoPlayer_Frame_052
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_052(dt: Dt) {
  dt.log.i('视频隐藏/取消隐藏 start');
  dt.log.i('STEP 1、视频缩略图xxx播放过程中隐藏/取消隐藏');

  await dt.sleep();
  dt.log.i('预期结果1、隐藏/取消隐藏过程中播放不受影响，隐藏/取消隐藏成功后视频消失，切换到下一张，隐藏/取消隐藏动效流畅');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、视频缩略图xxx暂停过程中隐藏/取消隐藏');

  await dt.sleep();
  dt.log.i('预期结果2、隐藏/取消隐藏成功后视频消失，切换到下一张，隐藏/取消隐藏动效流畅');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、视频缩略图收起态播放过程中隐藏/取消隐藏');

  await dt.sleep();
  dt.log.i('预期结果3、隐藏/取消隐藏过程中播放不受影响，隐藏/取消隐藏成功后视频消失，切换到下一张，隐藏/取消隐藏动效流畅');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、视频缩略图收起态暂停过程中隐藏/取消隐藏');

  await dt.sleep();
  dt.log.i('预期结果4、隐藏/取消隐藏成功后视频消失，切换到下一张，隐藏/取消隐藏动效流畅');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、视频隐藏后到隐藏相册查看');

  await dt.sleep();
  dt.log.i('预期结果5、隐藏的视频出现在隐藏相册');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、视频取消隐藏后到视频相册查看');

  await dt.sleep();
  dt.log.i('预期结果6、取消隐藏的视频出现在视频相册');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频隐藏/取消隐藏 end');
}

/**
 * 大图-视频: [视频上滑/查看详细信息]
 * TAG: 352 TID: Multimedia_Gallery_VideoPlayer_Frame_053
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_053(dt: Dt) {
  dt.log.i('视频上滑/查看详细信息 start');
  dt.log.i('STEP 1、视频缩略图xxx播放过程中上滑/四方菜单点击详细信息');

  await dt.sleep();
  dt.log.i('预期结果1、视频播放不受影响，慢慢上滑出现详细信息页面，最佳呈现效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、视频缩略图xxx暂停过程中上滑/四方菜单点击详细信息');

  await dt.sleep();
  dt.log.i('预期结果2、视频状态不受影响，慢慢上滑出现详细信息页面，最佳呈现效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、视频缩略图收起态播放过程中上滑/四方菜单点击详细信息');

  await dt.sleep();
  dt.log.i('预期结果3、视频播放不受影响，慢慢上滑出现详细信息页面，最佳呈现效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、视频缩略图收起态暂停过程中上滑/四方菜单点击详细信息');

  await dt.sleep();
  dt.log.i('预期结果4、视频状态不受影响，慢慢上滑出现详细信息页面，最佳呈现效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、视频播放过程中详细信息页面下滑');

  await dt.sleep();
  dt.log.i('预期结果5、视频播放不受影响，退出详细信息页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、视频暂停过程中详细信息页面下滑');

  await dt.sleep();
  dt.log.i('预期结果6、视频状态不受影响，退出详细信息页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频上滑/查看详细信息 end');
}

/**
 * 大图-视频: [云端视频逐帧播放]
 * TAG: 358 TID: Multimedia_Gallery_VideoPlayer_Frame_054
 * 前置条件
 * 1、图库预制不同的端云视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_054(dt: Dt) {
  dt.log.i('云端视频逐帧播放 start');
  dt.log.i('STEP 1、打开端云视频播放');

  await dt.sleep();
  dt.log.i('预期结果1、起播前右下角转圈，视频正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、切换端云视频播放');

  await dt.sleep();
  dt.log.i('预期结果2、切换端云视频正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击缩略图展开播放');

  await dt.sleep();
  dt.log.i('预期结果3、视频正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、播放过程中调节进度条');

  await dt.sleep();
  dt.log.i('预期结果4、调节进度条后正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云端视频逐帧播放 end');
}

/**
 * 大图-视频: [云端视频播放前断网]
 * TAG: 362 TID: Multimedia_Gallery_VideoPlayer_Frame_055
 * 前置条件
 * 1、图库预制不同的端云视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_055(dt: Dt) {
  dt.log.i('云端视频播放前断网 start');
  dt.log.i('STEP 1、关闭wifi或者网络连接');

  await dt.sleep();
  dt.log.i('STEP 2、打开端云视频');

  await dt.sleep();
  dt.log.i('预期结果2、视频无法播放，播放按钮保持暂停状态，提示“无可用网络”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('无可用网络');
  dt.log.i('STEP 3、切换到下一个端云视频');

  await dt.sleep();
  dt.log.i('预期结果3、视频无法播放，播放按钮保持暂停状态，提示“无可用网络”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('无可用网络', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云端视频播放前断网 end');
}

/**
 * 大图-端云: [云端播放过程中断网]
 * TAG: 355 TID: Multimedia_Gallery_VideoPlayer_Frame_056
 * 前置条件
 * 1、图库预制不同时间超2分钟的端云视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_056(dt: Dt) {
  dt.log.i('云端播放过程中断网 start');
  dt.log.i('STEP 1、打开2分钟端云视频');

  await dt.sleep();
  dt.log.i('预期结果1、视频转圈后正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、起播后立即关闭网络');

  await dt.sleep();
  dt.log.i('预期结果2、视频播放完已缓冲的部分，播放按钮保持暂停状态，播放到未缓冲部分提示“无可用网络”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('无可用网络');
  dt.log.i('STEP 3、切换到下一个端云视频');

  await dt.sleep();
  dt.log.i('预期结果3、视频无法播放，播放按钮保持暂停状态，提示“无可用网络”');
  await dt.sleep(DELAY.double);
  await dt.assertComponentByText('无可用网络', true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云端播放过程中断网 end');
}

/**
 * 大图-视频: [picker界面播放视频]
 * TAG: 365 TID: Multimedia_Gallery_VideoPlayer_Frame_057
 * 前置条件
 * 1、图库有不同相册，系统相册，三方相册，来源相册，地点相册，隐藏相册，最近删除相册等
 2、预制普通图片，动态图片，视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_057(dt: Dt) {
  dt.log.i('picker界面播放视频 start');
  dt.log.i('STEP 1、picker界面拉起图库，选择一个视频打开，点击播放控件');

  await dt.sleep();
  dt.log.i('预期结果1、视频播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、点击页面');

  await dt.sleep();
  dt.log.i('预期结果2、页面自动暂停播放，保持进度，中间有暂停的icon');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次点击');

  await dt.sleep();
  dt.log.i('预期结果3、视频继续播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('picker界面播放视频 end');
}

/**
 * 大图-收藏: [控件key值核查（命名、事件控件）]
 * TAG: 359 TID: Multimedia_Gallery_VideoPlayer_Frame_058
 * 前置条件
 * 1、图库存在视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_058(dt: Dt) {
  dt.log.i('控件key值核查（命名、事件控件） start');
  dt.log.i('STEP 1、进入DevEco Testing-实用工具-UIViewer');

  await dt.sleep();
  dt.log.i('STEP 2、打开视频，分享按钮，收藏按钮，播放按钮，声音按钮，编辑按钮，删除按钮，点击视频播放，展开缩略图，获取界面查看控件key值');

  await dt.sleep();
  dt.log.i('预期结果2、控件均有compid，命名正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、使用平板重复12');

  await dt.sleep();
  dt.log.i('预期结果3、平板控件均有compid，命名正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、使用xxx重复12');

  await dt.sleep();
  dt.log.i('预期结果4、xxx控件均有compid，命名正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、使用PC重复12');

  await dt.sleep();
  dt.log.i('预期结果5、PC控件均有compid，命名正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('控件key值核查（命名、事件控件） end');
}

/**
 * 大图-滑动: [逐帧播放性能-滑动逐帧播放刷新帧率]
 * TAG: 360 TID: Multimedia_Gallery_VideoPlayer_Frame_059
 * 前置条件
 * 1、图库存在1000+图片和视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_059(dt: Dt) {
  dt.log.i('逐帧播放性能-滑动逐帧播放刷新帧率 start');
  dt.log.i('STEP 1、xxx展开视频缩略图，调节进度条，测试滑动逐帧播放刷新率');

  await dt.sleep();
  dt.log.i('STEP 2、xxx展开视频缩略图，调节进度条，测试滑动逐帧播放刷新率');

  await dt.sleep();
  dt.log.i('STEP 3、对比xxx数据');

  await dt.sleep();
  dt.log.i('预期结果3、同场景xxx优于xxx');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('逐帧播放性能-滑动逐帧播放刷新帧率 end');
}

/**
 * 大图-进度条: [逐帧播放性能-起播时延]
 * TAG: 372 TID: Multimedia_Gallery_VideoPlayer_Frame_060
 * 前置条件
 * 1、图库存在1000+图片和视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_060(dt: Dt) {
  dt.log.i('逐帧播放性能-起播时延 start');
  dt.log.i('STEP 1、xxx展开视频缩略图，调节进度条，测试视频播放起播时延');

  await dt.sleep();
  dt.log.i('STEP 2、xxx展开视频缩略图，调节进度条，测试视频播放起播时延');

  await dt.sleep();
  dt.log.i('STEP 3、对比xxx数据');

  await dt.sleep();
  dt.log.i('预期结果3、同场景xxx优于xxx');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('逐帧播放性能-起播时延 end');
}

/**
 * 大图-视频: [逐帧播放功耗-峰值内存]
 * TAG: 363 TID: Multimedia_Gallery_VideoPlayer_Frame_061
 * 前置条件
 * 1、图库存在1000+图片和视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_061(dt: Dt) {
  dt.log.i('逐帧播放功耗-峰值内存 start');
  dt.log.i('STEP 1、进入DevEco Testing-性能功耗测试-场景化测试');

  await dt.sleep();
  dt.log.i('预期结果1、功耗峰值内存符合预期');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、使用平板重复1');

  await dt.sleep();
  dt.log.i('预期结果2、功耗峰值内存符合预期');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、使用xxx重复1');

  await dt.sleep();
  dt.log.i('预期结果3、功耗峰值内存符合预期');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、使用PC重复1');

  await dt.sleep();
  dt.log.i('预期结果4、功耗峰值内存符合预期');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('逐帧播放功耗-峰值内存 end');
}

/**
 * 大图-预览条: [大数据打点]
 * TAG: 366 TID: Multimedia_Gallery_VideoPlayer_Frame_062
 * 前置条件
 * 1、图库存在视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_062(dt: Dt) {
  dt.log.i('大数据打点 start');
  dt.log.i('STEP 1、打开视频，滑动缩略图预览条');

  await dt.sleep();
  dt.log.i('预期结果1、支持用户进行视频图像帧预览条滑动操作的打点');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2、支持统计用户滑动方向');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3、起手，离手一个点位');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大数据打点 end');
}

/**
 * 大图-HDR: [非HDR视频不同类型视频显示效果]
 * TAG: 4 TID: Multimedia_Gallery_VideoPlayer_Frame_080
 * 前置条件
 * 图库存在非HDR格式视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_080(dt: Dt) {
  dt.log.i('非HDR视频不同类型视频显示效果 start');
  dt.log.i('STEP 1、用相机拍摄不同分辨率的视频：16:9 4k(30fps/60fps)，全屏1080p(30fps/60fps)，16:9 1080p(30fps/60fps),16:9 720p(30fps/60fps)');

  await dt.sleep();
  dt.log.i('STEP 2、用相机拍摄不同滤镜的视频：原色，鲜艳，明快，黑白');

  await dt.sleep();
  dt.log.i('STEP 3、打开视频查看视频封面显示，大图底部缩略图显示，视频播放图像帧显示');

  await dt.sleep();
  dt.log.i('预期结果3、显示的视频封面帧，大图底部缩略图显示，播放区视频显示为SDR效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('非HDR视频不同类型视频显示效果 end');
}

/**
 * 大图-HDR: [深色模式下HDR视频显示效果]
 * TAG: 12 TID: Multimedia_Gallery_VideoPlayer_Frame_085
 * 前置条件
 * 图库存在HDR格式视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_085(dt: Dt) {
  dt.log.i('深色模式下HDR视频显示效果 start');
  dt.log.i('STEP 1、开启深色模式，打开视频播放，观察视频界面显示效果');

  await dt.sleep();
  dt.log.i('预期结果1、显示的视频封面帧，播放区视频显示为HDR效果，大图底部缩略图显示SDR效果');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('深色模式下HDR视频显示效果 end');
}

/**
 * 大图-竖屏: [横竖屏下HDR视频显示效果]
 * TAG: 3 TID: Multimedia_Gallery_VideoPlayer_Frame_086
 * 前置条件
 * 图库存在HDR格式视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_086(dt: Dt) {
  dt.log.i('横竖屏下HDR视频显示效果 start');
  dt.log.i('STEP 1、竖屏旋转横屏后，打开视频播放，观察视频界面显示效果');

  await dt.sleep();
  dt.log.i('预期结果1、显示的视频封面帧，播放区视频显示为HDR效果，大图底部缩略图显示SDR效果');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('横竖屏下HDR视频显示效果 end');
}

/**
 * 大图-HDR: [分屏悬浮窗下HDR视频显示效果]
 * TAG: 7 TID: Multimedia_Gallery_VideoPlayer_Frame_087
 * 前置条件
 * 图库存在HDR格式视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_087(dt: Dt) {
  dt.log.i('分屏悬浮窗下HDR视频显示效果 start');
  dt.log.i('STEP 1、开启分屏后，打开视频播放，观察视频界面显示效果');

  await dt.sleep();
  dt.log.i('预期结果1、显示的视频封面帧，播放区视频显示为HDR效果，大图底部缩略图显示SDR效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、开启悬浮窗后，打开视频播放，观察视频界面显示效果');

  await dt.sleep();
  dt.log.i('预期结果2、显示的视频封面帧，播放区视频显示为HDR效果，大图底部缩略图显示SDR效果');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分屏悬浮窗下HDR视频显示效果 end');
}

/**
 * 大图-HDR: [操作HDR视频显示效果]
 * TAG: 6 TID: Multimedia_Gallery_VideoPlayer_Frame_088
 * 前置条件
 * 图库存在HDR格式视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_088(dt: Dt) {
  dt.log.i('操作HDR视频显示效果 start');
  dt.log.i('STEP 1、打开视频播放，上滑详情，点击分享，收藏，编辑，删除等操作，观察视频界面显示效果');

  await dt.sleep();
  dt.log.i('预期结果1、显示的视频封面帧，播放区视频显示为HDR效果，大图底部缩略图显示SDR效果');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('操作HDR视频显示效果 end');
}

/**
 * 大图-HDR: [xxx拍摄的HDR视频云同步/分享/克隆后显示效果]
 * TAG: 10 TID: Multimedia_Gallery_VideoPlayer_Frame_089
 * 前置条件
 * 图库存在HDR格式视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_089(dt: Dt) {
  dt.log.i('xxx拍摄的HDR视频云同步/分享/克隆后显示效果 start');
  dt.log.i('STEP 1、xxx辅助机拍摄HDR视频');

  await dt.sleep();
  dt.log.i('STEP 2、拍摄的视频通过云空间同步到测试机，播放视频，观察视频显示效果');

  await dt.sleep();
  dt.log.i('预期结果2、显示的视频封面帧，播放区视频显示为HDR效果，大图底部缩略图显示SDR效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拍摄的视频通过分享同步到测试机，播放视频，观察视频显示效果');

  await dt.sleep();
  dt.log.i('预期结果3、显示的视频封面帧，播放区视频显示为HDR效果，大图底部缩略图显示SDR效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、拍摄的视频通过克隆同步到测试机，播放视频，观察视频显示效果');

  await dt.sleep();
  dt.log.i('预期结果4、显示的视频封面帧，播放区视频显示为HDR效果，大图底部缩略图显示SDR效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxx拍摄的HDR视频云同步/分享/克隆后显示效果 end');
}

/**
 * 大图-HDR: [xxx拍摄的HDR视频云同步/分享/克隆后显示]
 * TAG: 9 TID: Multimedia_Gallery_VideoPlayer_Frame_090
 * 前置条件
 * 图库存在HDR格式视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_090(dt: Dt) {
  dt.log.i('xxx拍摄的HDR视频云同步/分享/克隆后显示 start');
  dt.log.i('STEP 1、xxx辅助机拍摄HDR视频');

  await dt.sleep();
  dt.log.i('STEP 2、拍摄的视频通过云空间同步到测试机，播放视频，观察视频显示效果');

  await dt.sleep();
  dt.log.i('预期结果2、显示的视频封面帧，播放区视频显示为HDR效果，大图底部缩略图显示SDR效果');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、拍摄的视频通过分享同步到测试机，播放视频，观察视频显示效果');

  await dt.sleep();
  dt.log.i('预期结果3、显示的视频封面帧，播放区视频显示为HDR效果，大图底部缩略图显示SDR效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、拍摄的视频通过克隆同步到测试机，播放视频，观察视频显示效果');

  await dt.sleep();
  dt.log.i('预期结果4、显示的视频封面帧，播放区视频显示为HDR效果，大图底部缩略图显示SDR效果');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('xxx拍摄的HDR视频云同步/分享/克隆后显示 end');
}

/**
 * 大图-HDR: [播放HDR视频性能测试用例]
 * TAG: 11 TID: Multimedia_Gallery_VideoPlayer_Frame_091
 * 前置条件
 * 图库存在HDR格式视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_091(dt: Dt) {
  dt.log.i('播放HDR视频性能测试用例 start');
  dt.log.i('STEP 1、测试机播放HDR视频，测试性能');

  await dt.sleep();
  dt.log.i('STEP 2、xxx播放HDR视频，测试性能');

  await dt.sleep();
  dt.log.i('STEP 3、测试机性能对比');

  await dt.sleep();
  dt.log.i('预期结果3、测试机对比xxx手机无劣化');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('播放HDR视频性能测试用例 end');
}

/**
 * 大图-HDR: [播放HDR视频功耗测试用例]
 * TAG: 8 TID: Multimedia_Gallery_VideoPlayer_Frame_092
 * 前置条件
 * 图库存在HDR格式视频
 */
async function Multimedia_Gallery_VideoPlayer_Frame_092(dt: Dt) {
  dt.log.i('播放HDR视频功耗测试用例 start');
  dt.log.i('STEP 1、测试机播放HDR视频，测试功耗');

  await dt.sleep();
  dt.log.i('STEP 2、xxx播放HDR视频，测试功耗');

  await dt.sleep();
  dt.log.i('STEP 3、测试机功耗对比');

  await dt.sleep();
  dt.log.i('预期结果3、测试机功耗不高于xxx');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('播放HDR视频功耗测试用例 end');
}

/**
 * 大图-删除: [大图界面删除图片后视频可以正常播放]
 * TAG: 402 TID: Multimedia_Gallery_VideoPlayer_Frame_199
 * 前置条件
 * 1、图库中存在图片和视频，尤其时相机相册要存在这些数据
 */
async function Multimedia_Gallery_VideoPlayer_Frame_199(dt: Dt) {
  dt.log.i('大图界面删除图片后视频可以正常播放 start');
  dt.log.i('STEP 1、图库照片页打开大图，左右滑动查看50张，连续删除大图10张，确保第11张是视频');

  await dt.sleep();
  dt.log.i('STEP 2、点击视频查看播放情况');

  await dt.sleep();
  dt.log.i('预期结果2 4 、视频正常播放，过程流畅自然，视频播放声音和画面正常，音画同步无主观延迟感受');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、相机入口进入大图，左右滑动查看50张后，连续删除大图10张，确保第11张是视频');

  await dt.sleep();
  dt.log.i('STEP 4、点击视频看播放情况');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('大图界面删除图片后视频可以正常播放 end');
}

