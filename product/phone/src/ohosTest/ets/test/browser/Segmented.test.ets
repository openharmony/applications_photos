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

export default function SegmentedTest(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('SegmentedTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllDemoUi').init();
      dt.log.i('beforeAll DemoUi start');
      dt.log.i('beforeAll DemoUi finish');
    });
    /**
     * 打开大图
     */
    run('beforeDemoUi', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('Multimedia_Gallery_Segmented_001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [【分段式拍照】相机拍摄20张图片，浏览查看大图] TID: Multimedia_Gallery_Segmented_001
      await Multimedia_Gallery_Segmented_001(dt);
    });
    run('Multimedia_Gallery_Segmented_002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [【分段式拍照】编辑低质量、高质量图片] TID: Multimedia_Gallery_Segmented_002
      await Multimedia_Gallery_Segmented_002(dt);
    });
    run('Multimedia_Gallery_Segmented_003', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-端云用例: [【分段式拍照】端云上下行低质量图、高质量图] TID: Multimedia_Gallery_Segmented_003
      await Multimedia_Gallery_Segmented_003(dt);
    });
    run('Multimedia_Gallery_Segmented_004', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [【分段式拍照】端云下载低质量、高质量图编辑后同步] TID: Multimedia_Gallery_Segmented_004
      await Multimedia_Gallery_Segmented_004(dt);
    });
    run('Multimedia_Gallery_Segmented_005', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进度条用例: [【分段式拍照】低质量、高质量图拼图创作] TID: Multimedia_Gallery_Segmented_005
      await Multimedia_Gallery_Segmented_005(dt);
    });
    run('Multimedia_Gallery_Segmented_006', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [【分段式拍照】低质量、高质量图大图详情重命名，添加备注] TID: Multimedia_Gallery_Segmented_006
      await Multimedia_Gallery_Segmented_006(dt);
    });
    run('Multimedia_Gallery_Segmented_007', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-收藏用例: [【分段式拍照】大图低质量、高质量图分享、收藏、添加至相册、复制、隐藏] TID: Multimedia_Gallery_Segmented_007
      await Multimedia_Gallery_Segmented_007(dt);
    });
    run('Multimedia_Gallery_Segmented_008', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [【分段式拍照】多选低质量、高质量图分享、添加至相册、复制、隐藏] TID: Multimedia_Gallery_Segmented_008
      await Multimedia_Gallery_Segmented_008(dt);
    });
    run('Multimedia_Gallery_Segmented_009', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [【分段式拍照】低质量、高质量图，图片对比] TID: Multimedia_Gallery_Segmented_009
      await Multimedia_Gallery_Segmented_009(dt);
    });
    run('Multimedia_Gallery_Segmented_010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-删除用例: [【分段式拍照】低质量、高质量图大图删除、多选删除] TID: Multimedia_Gallery_Segmented_010
      await Multimedia_Gallery_Segmented_010(dt);
    });
    run('Multimedia_Gallery_Segmented_011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-详情用例: [【分段式拍照】Picker选择低质量、高质量图] TID: Multimedia_Gallery_Segmented_011
      await Multimedia_Gallery_Segmented_011(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachDemoUi').init();
      dt.log.i('afterEach DemoUi start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach DemoUi finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllDemoUi').init();
      dt.log.i('afterAll DemoUi start');
      await Exit.browser();
      dt.log.i('afterAll DemoUi finish');
    });
  });
}

// DT步骤
/**
 * 大图-大图: [【分段式拍照】相机拍摄20张图片，浏览查看大图]
 * TAG: 73 TID: Multimedia_Gallery_Segmented_001
 * 前置条件
 * 设备支持分段式拍照
 */
async function Multimedia_Gallery_Segmented_001(dt: Dt) {
  dt.log.i('【分段式拍照】相机拍摄20张图片，浏览查看大图 start');
  dt.log.i('STEP 1.相机拍摄照片（普通拍照、锁屏相机、人像、夜景、不同比例）；');

  await dt.sleep();
  dt.log.i('预期结果1.相机拍摄照片成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击左下角缩略图进入大图，上滑查看大图详情；');

  await dt.sleep();
  dt.log.i('预期结果2.进大图动效正常，大图详情图片大小展示为高质量图；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.快速浏览至第十张大图，上滑查看大图详情；');

  await dt.sleep();
  dt.log.i('预期结果3.大图详情图片大小展示为低质量图，然后更新为高质量图；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.手机横屏，重复步骤1、2、3。');

  await dt.sleep();
  dt.log.i('预期结果4.横屏模式下正常拍摄，大图展示为高质量图。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【分段式拍照】相机拍摄20张图片，浏览查看大图 end');
}

/**
 * 大图-进入大图: [【分段式拍照】编辑低质量、高质量图片]
 * TAG: 77 TID: Multimedia_Gallery_Segmented_002
 * 前置条件
 * 设备支持分段式拍照
 */
async function Multimedia_Gallery_Segmented_002(dt: Dt) {
  dt.log.i('【分段式拍照】编辑低质量、高质量图片 start');
  dt.log.i('STEP 1.相机拍摄20照片（普通拍照、人像、夜景、不同比例）；');

  await dt.sleep();
  dt.log.i('预期结果1.相机拍摄照片成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击左下角缩略图进入大图，快速浏览至第5张大图，点击编辑，一键调节，调节滤镜，点击保存；');

  await dt.sleep();
  dt.log.i('预期结果2.进大图动效正常，大图详情图片大小展示为低质量图；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.大图界面等待30秒，查看编辑后图片大图详情，查看大图清晰度，查看宫格清晰度；');

  await dt.sleep();
  dt.log.i('预期结果3.大图详情图片大小展示为低质量图，编辑效果正常保存；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.手机横屏，重复步骤1、2、3。');

  await dt.sleep();
  dt.log.i('预期结果4.横屏模式下正常拍摄编辑，大图展示为低质量图，编辑效果正常保存。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【分段式拍照】编辑低质量、高质量图片 end');
}

/**
 * 大图-端云: [【分段式拍照】端云上下行低质量图、高质量图]
 * TAG: 76 TID: Multimedia_Gallery_Segmented_003
 * 前置条件
 * 设备支持分段式拍照
 */
async function Multimedia_Gallery_Segmented_003(dt: Dt) {
  dt.log.i('【分段式拍照】端云上下行低质量图、高质量图 start');
  dt.log.i('STEP 1.测试机a开启图库云同步开关，相机拍摄20张照片（普通拍照、人像、夜景、不同比例），点开图库照片页，上传图片完成，断网；');

  await dt.sleep();
  dt.log.i('预期结果1.测试机a低质量高质量图上传成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.测试机b登录云账号下行低质量图，高质量图，查看大图详情；');

  await dt.sleep();
  dt.log.i('预期结果2.测试机b低质量高质量图下行成功，大图详情低质量高质量图大小展示正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.待测试机a每张图片都更新为高质量图，连接网络，待同步完成；测试机b同步完成，查看大图详情；');

  await dt.sleep();
  dt.log.i('预期结果3.测试机a全部高质量图上行成功；测试机b下行成功，无低质量LCD图；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【分段式拍照】端云上下行低质量图、高质量图 end');
}

/**
 * 大图-下载: [【分段式拍照】端云下载低质量、高质量图编辑后同步]
 * TAG: 75 TID: Multimedia_Gallery_Segmented_004
 * 前置条件
 * 设备支持分段式拍照
 */
async function Multimedia_Gallery_Segmented_004(dt: Dt) {
  dt.log.i('【分段式拍照】端云下载低质量、高质量图编辑后同步 start');
  dt.log.i('STEP 1.测试机a开启图库云同步开关，相机拍摄20张照片（普通拍照、人像、夜景、不同比例），点开图库照片页，上传图片完成，断网；');

  await dt.sleep();
  dt.log.i('预期结果1.测试机a低质量高质量图上传成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.测试机b登录云账号下载低质量图，高质量图，查看大图详情；');

  await dt.sleep();
  dt.log.i('预期结果2.测试机b低质量高质量图下行成功，大图详情低质量高质量图大小展示正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.对下载下来的低质量、高质量图进行图片编辑，保存后；测试机b同步至云端，测试机a联网；');

  await dt.sleep();
  dt.log.i('预期结果3.测试机a同步完成后，展现编辑后的高质量图；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【分段式拍照】端云下载低质量、高质量图编辑后同步 end');
}

/**
 * 大图-进度条: [【分段式拍照】低质量、高质量图拼图创作]
 * TAG: 69 TID: Multimedia_Gallery_Segmented_005
 * 前置条件
 * 设备支持分段式拍照，图库存在低质量高质量图
 */
async function Multimedia_Gallery_Segmented_005(dt: Dt) {
  dt.log.i('【分段式拍照】低质量、高质量图拼图创作 start');
  dt.log.i('STEP 1.从照片页/相册页（普通相册、隐藏相册）进入图片宫格页面，点击右上角更多，点击多选，进入选择模式；');

  await dt.sleep();
  dt.log.i('预期结果1.正常进入选择模式；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.选择2-9张图片进行拼图创作；');

  await dt.sleep();
  dt.log.i('预期结果2.拼图创作操作正常，低质量图请求更新至高质量图才进行拼图创作，出现加载进度条；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.手机横屏，重复步骤1、2。');

  await dt.sleep();
  dt.log.i('预期结果3.横屏模式下拼图创作正常，低质量图请求更新至高质量图才进行拼图创作。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【分段式拍照】低质量、高质量图拼图创作 end');
}

/**
 * 大图-详情: [【分段式拍照】低质量、高质量图大图详情重命名，添加备注]
 * TAG: 70 TID: Multimedia_Gallery_Segmented_006
 * 前置条件
 * 设备支持分段式拍照，图库存在低质量高
 */
async function Multimedia_Gallery_Segmented_006(dt: Dt) {
  dt.log.i('【分段式拍照】低质量、高质量图大图详情重命名，添加备注 start');
  dt.log.i('STEP 1.从相机/照片页/相册页进入大图；');

  await dt.sleep();
  dt.log.i('预期结果1.正常进入大图；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.进入大图详情，对低质量图、高质量图操作重命名、添加备注（普通备注&超长备注）；');

  await dt.sleep();
  dt.log.i('预期结果2.正常进入大图详情，操作重命名、添加备注成功；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.操作完成，大图界面等待30s，查看大图详情图片大小；');

  await dt.sleep();
  dt.log.i('预期结果3.低质量图更新为高质量图，名称为重命名后的，备注正常展示，高质量图展示大小不变，重命名后的名称和备注正常展示；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.手机横屏重复步骤1、2、3。');

  await dt.sleep();
  dt.log.i('预期结果4.横屏模式下重命名，名称为重命名后的，备注正常展示。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【分段式拍照】低质量、高质量图大图详情重命名，添加备注 end');
}

/**
 * 大图-收藏: [【分段式拍照】大图低质量、高质量图分享、收藏、添加至相册、复制、隐藏]
 * TAG: 74 TID: Multimedia_Gallery_Segmented_007
 * 前置条件
 * 设备支持分段式拍照
 */
async function Multimedia_Gallery_Segmented_007(dt: Dt) {
  dt.log.i('【分段式拍照】大图低质量、高质量图分享、收藏、添加至相册、复制、隐藏 start');
  dt.log.i('STEP 1.从相机/照片页/相册页进入大图；');

  await dt.sleep();
  dt.log.i('预期结果1.进入低质量图片大图；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.对低质量、高质量图操作分享、收藏、添加至相册、复制、隐藏；');

  await dt.sleep();
  dt.log.i('预期结果2.低质量、高质量图分享、收藏、添加至相册、隐藏、复制操作正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.操作完成，大图界面等待30s，查看大图详情图片大小；');

  await dt.sleep();
  dt.log.i('预期结果3.大图详情图片大小展示为高质量图，复制到备忘录的图片大小为高质量图；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.手机横屏重复步骤1、2、3。');

  await dt.sleep();
  dt.log.i('预期结果4.横屏模式下正常拍摄，大图展示为高质量图。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【分段式拍照】大图低质量、高质量图分享、收藏、添加至相册、复制、隐藏 end');
}

/**
 * 大图-详情: [【分段式拍照】多选低质量、高质量图分享、添加至相册、复制、隐藏]
 * TAG: 71 TID: Multimedia_Gallery_Segmented_008
 * 前置条件
 * 设备支持分段式拍照
 */
async function Multimedia_Gallery_Segmented_008(dt: Dt) {
  dt.log.i('【分段式拍照】多选低质量、高质量图分享、添加至相册、复制、隐藏 start');
  dt.log.i('STEP 1.从相机/照片页/相册页进入图片宫格页；');

  await dt.sleep();
  dt.log.i('预期结果1.进入低质量图片大图；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.多选低质量图操作分享、收藏、添加至相册、复制、隐藏；');

  await dt.sleep();
  dt.log.i('预期结果2.多选低质量图分享、收藏、添加至相册、隐藏、复制操作正常；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.操作完成，大图界面等待30s，查看大图详情图片大小；');

  await dt.sleep();
  dt.log.i('预期结果3.大图详情图片大小展示为高质量图，复制到备忘录的图片大小为高质量图；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.手机横屏重复步骤1、2、3。');

  await dt.sleep();
  dt.log.i('预期结果4.横屏模式下正常拍摄，大图展示为高质量图。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【分段式拍照】多选低质量、高质量图分享、添加至相册、复制、隐藏 end');
}

/**
 * 大图-详情: [【分段式拍照】低质量、高质量图，图片对比]
 * TAG: 72 TID: Multimedia_Gallery_Segmented_009
 * 前置条件
 * 设备支持分段式拍照
 */
async function Multimedia_Gallery_Segmented_009(dt: Dt) {
  dt.log.i('【分段式拍照】低质量、高质量图，图片对比 start');
  dt.log.i('STEP 1.从相机/照片页/相册页进入图片宫格页；');

  await dt.sleep();
  dt.log.i('预期结果1.进入低质量图片大图；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.多选低质量图操作图片对比；');

  await dt.sleep();
  dt.log.i('预期结果2.多选低质量图进行图片对比；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.操作完成，大图界面等待30s，查看大图详情图片大小；');

  await dt.sleep();
  dt.log.i('预期结果3.大图详情图片大小展示为高质量图；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.手机横屏重复步骤1、2、3。');

  await dt.sleep();
  dt.log.i('预期结果4.横屏模式下正常拍摄，大图展示为高质量图。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【分段式拍照】低质量、高质量图，图片对比 end');
}

/**
 * 大图-删除: [【分段式拍照】低质量、高质量图大图删除、多选删除]
 * TAG: 67 TID: Multimedia_Gallery_Segmented_010
 * 前置条件
 * 设备支持分段式拍照
 */
async function Multimedia_Gallery_Segmented_010(dt: Dt) {
  dt.log.i('【分段式拍照】低质量、高质量图大图删除、多选删除 start');
  dt.log.i('STEP 1.从相机/照片页/相册页进入大图、进入图片宫格页；');

  await dt.sleep();
  dt.log.i('预期结果1.进入低质量图片大图；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.对低质量图操作大图删除，多选低质量图&高质量图、只有低质量图、只有高质量图操作删除；');

  await dt.sleep();
  dt.log.i('预期结果2.多选低质量图进行图片对，先申请更新为高质量才能进行对比操作；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.操作完成，进最近删除在低质量图大图界面等待30s，查看最近删除大图详情图片大小；');

  await dt.sleep();
  dt.log.i('预期结果3.大图详情图片大小展示为高质量图图；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.手机横屏重复步骤1、2、3。');

  await dt.sleep();
  dt.log.i('预期结果4.横屏模式下正常拍摄，大图展示为高质量图。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【分段式拍照】低质量、高质量图大图删除、多选删除 end');
}

/**
 * 大图-详情: [【分段式拍照】Picker选择低质量、高质量图]
 * TAG: 68 TID: Multimedia_Gallery_Segmented_011
 * 前置条件
 * 设备支持分段式拍照
 */
async function Multimedia_Gallery_Segmented_011(dt: Dt) {
  dt.log.i('【分段式拍照】Picker选择低质量、高质量图 start');
  dt.log.i('STEP 1.图库预置低质量图；');

  await dt.sleep();
  dt.log.i('STEP 2.拉起picker界面，选择低质量图，点击完成；');

  await dt.sleep();
  dt.log.i('预期结果2.低质量图可正常操作picker；');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.操作picker过程中点击低质量图宫格左上角进大图，等待30s，查看图片大图详情；');

  await dt.sleep();
  dt.log.i('预期结果3.大图详情图片大小展示为高质量图；');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.手机横屏重复步骤1、2。');

  await dt.sleep();
  dt.log.i('预期结果4.横屏模式下，大图展示为高质量图。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('【分段式拍照】Picker选择低质量、高质量图 end');
}

