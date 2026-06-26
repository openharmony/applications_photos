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
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';

export default function MultimediaGalleryShare(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryShareTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryShare').init();
      dt.log.i('beforeAll MultimediaGalleryShare start');
      dt.log.i('beforeAll MultimediaGalleryShare finish');
    });
    /**
     * 打开大图
     */
    it('beforeMultimediaGalleryShare', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    // DT声明
    it('Multimedia_Gallery_share_001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [选择模式，图片正常分享（单张+批量）] TID: Multimedia_Gallery_share_001
      await Multimedia_Gallery_share_001(dt);
    });
    it('Multimedia_Gallery_share_0010', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [云端文件点击分享时，选择具体分享方式后，触发下载] TID: Multimedia_Gallery_share_0010
      await Multimedia_Gallery_share_0010(dt);
    });
    it('Multimedia_Gallery_share_0011', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [单张和多张选中后拉起分享框，支持打印] TID: Multimedia_Gallery_share_0011
      await Multimedia_Gallery_share_0011(dt);
    });
    it('Multimedia_Gallery_share_002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [相册宫格大图分享] TID: Multimedia_Gallery_share_002
      await Multimedia_Gallery_share_002(dt);
    });
    it('Multimedia_Gallery_share_003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-大图用例: [本地/云端时间轴界面大图分享] TID: Multimedia_Gallery_share_003
      await Multimedia_Gallery_share_003(dt);
    });
    it('Multimedia_Gallery_share_004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [本机拍摄不同模式+分辨率图片和视频大图分享] TID: Multimedia_Gallery_share_004
      await Multimedia_Gallery_share_004(dt);
    });
    it('Multimedia_Gallery_share_005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [接受分享文件] TID: Multimedia_Gallery_share_005
      await Multimedia_Gallery_share_005(dt);
    });
    it('Multimedia_Gallery_share_006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [FA进入大图分享] TID: Multimedia_Gallery_share_006
      await Multimedia_Gallery_share_006(dt);
    });
    it('Multimedia_Gallery_share_007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [不同应用之间的分享] TID: Multimedia_Gallery_share_007
      await Multimedia_Gallery_share_007(dt);
    });
    it('Multimedia_Gallery_share_008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [不同设备之间分享] TID: Multimedia_Gallery_share_008
      await Multimedia_Gallery_share_008(dt);
    });
    it('Multimedia_Gallery_share_011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [分享性能] TID: Multimedia_Gallery_share_011
      await Multimedia_Gallery_share_011(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryShare').init();
      dt.log.i('afterEach MultimediaGalleryShare start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryShare finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryShare').init();
      dt.log.i('afterAll MultimediaGalleryShare start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryShare finish');
    });
  });
}

// DT步骤
/**
 * 大图-格式: [选择模式，图片正常分享（单张+批量）]
 * GROUP: 大图 MODULE: 格式TID: Multimedia_Gallery_share_001
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_share_001(dt: Dt) {
  dt.log.i('选择模式，图片正常分享（单张+批量） start');
  dt.log.i('STEP 1、进入图库时间轴界面查看');

  
  dt.log.i('STEP 2、点击更多多选，进入选择模式，选择1张图片分享');

  
  dt.log.i('预期结果2 4 5.分享成功');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、勾选2张图片进行分享');

  
  dt.log.i('STEP 4、勾选100张分享');

  
  dt.log.i('STEP 5、分享101张');

  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('选择模式，图片正常分享（单张+批量） end');
}

/**
 * 大图-下载: [云端文件点击分享时，选择具体分享方式后，触发下载]
 * GROUP: 大图 MODULE: 下载TID: Multimedia_Gallery_share_0010
 * 前置条件
 * 1.云端多张图片，开启云图库，网络连接正常
 */
async function Multimedia_Gallery_share_0010(dt: Dt) {
  dt.log.i('云端文件点击分享时，选择具体分享方式后，触发下载 start');
  dt.log.i('STEP 1、不同入口（大图页面、照片页/相册内多选界面、长按云端图片宫格）选择云端图片，点击分享按钮');

  
  dt.log.i('预期结果1、点击按钮时调出分享框，不触发下载');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在分享框中选择具体分享方式，如分享、备忘录等');

  
  dt.log.i('预期结果2、触发下载，并显示下载进度');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云端文件点击分享时，选择具体分享方式后，触发下载 end');
}

/**
 * 大图-进入大图: [单张和多张选中后拉起分享框，支持打印]
 * GROUP: 大图 MODULE: 进入大图TID: Multimedia_Gallery_share_0011
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_share_0011(dt: Dt) {
  dt.log.i('单张和多张选中后拉起分享框，支持打印 start');
  dt.log.i('STEP 1、进入图库，单张进入大图，长按进入预览检查是否有打印');

  
  dt.log.i('预期结果1&2、图库内部不提供打印功能，分享框中有打印功能入口');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入多选后检查是否有打印');

  


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('单张和多张选中后拉起分享框，支持打印 end');
}

/**
 * 大图-大图: [相册宫格大图分享]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_share_002
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_share_002(dt: Dt) {
  dt.log.i('相册宫格大图分享 start');
  dt.log.i('STEP 1、进入相册宫格点击缩略图查看大图');

  
  dt.log.i('STEP 2、点击左下角分享按钮');

  
  dt.log.i('预期结果2、跳转到分享界面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、选择手机设备');

  
  dt.log.i('预期结果3、显示分享成功，手机图库上可以看到分享过来的照片');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册宫格大图分享 end');
}

/**
 * 大图-大图: [本地/云端时间轴界面大图分享]
 * GROUP: 大图 MODULE: 大图TID: Multimedia_Gallery_share_003
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_share_003(dt: Dt) {
  dt.log.i('本地/云端时间轴界面大图分享 start');
  dt.log.i('STEP 1、进入时间轴点击缩略图查看大图');

  
  dt.log.i('STEP 2、点击左下角的分享按钮');

  
  dt.log.i('预期结果2、跳转到分享界面');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本地/云端时间轴界面大图分享 end');
}

/**
 * 大图-视频: [本机拍摄不同模式+分辨率图片和视频大图分享]
 * GROUP: 大图 MODULE: 视频TID: Multimedia_Gallery_share_004
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_share_004(dt: Dt) {
  dt.log.i('本机拍摄不同模式+分辨率图片和视频大图分享 start');
  dt.log.i('STEP 1、进入相机拍摄不同模式+分辨率照片，进行视频录像');

  
  dt.log.i('STEP 2、点击相机缩略图查看图库大图');

  
  dt.log.i('STEP 3、点击右上角分享按钮');

  
  dt.log.i('预期结果3、不同模式+分辨率照片，录像分别分享成功，手机图库上可以看到分享过来的照片');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('本机拍摄不同模式+分辨率图片和视频大图分享 end');
}

/**
 * 大图-格式: [接受分享文件]
 * GROUP: 大图 MODULE: 格式TID: Multimedia_Gallery_share_005
 * 前置条件
 * 1、A设备图库中存在不同格式的照片和视频文件
 2、B设备打开分享开关
 */
async function Multimedia_Gallery_share_005(dt: Dt) {
  dt.log.i('接受分享文件 start');
  dt.log.i('STEP 1、进入图库照片页，多选任意照片和视频');

  
  dt.log.i('STEP 2、点击左下角分享按钮');

  
  dt.log.i('STEP 3、选择目标手机设备');

  
  dt.log.i('预期结果3、B设备可成功接收文件；保存文件目录在分享相册');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('接受分享文件 end');
}

/**
 * 大图-进入大图: [FA进入大图分享]
 * GROUP: 大图 MODULE: 进入大图TID: Multimedia_Gallery_share_006
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_share_006(dt: Dt) {
  dt.log.i('FA进入大图分享 start');
  dt.log.i('STEP 1、FA进入大图');

  
  dt.log.i('STEP 2、点击左下角分享按钮，选择');

  
  dt.log.i('预期结果2、跳转到分享界面');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果3、显示分享成功，手机图库上可以看到分享过来的照片');
  
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('FA进入大图分享 end');
}

/**
 * 大图-格式: [不同应用之间的分享]
 * GROUP: 大图 MODULE: 格式TID: Multimedia_Gallery_share_007
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_share_007(dt: Dt) {
  dt.log.i('不同应用之间的分享 start');
  dt.log.i('STEP 1、图库照片分享到备忘录');

  
  dt.log.i('预期结果2、分享成功，备忘录有显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同应用之间的分享 end');
}

/**
 * 大图-格式: [不同设备之间分享]
 * GROUP: 大图 MODULE: 格式TID: Multimedia_Gallery_share_008
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_share_008(dt: Dt) {
  dt.log.i('不同设备之间分享 start');
  dt.log.i('STEP 1、选择图片和视频格式文件');

  
  dt.log.i('STEP 2、分享至不同设备（其他手机和PC）');

  
  dt.log.i('预期结果2 、正常分享，接收后，图库正常显示图片和视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同设备之间分享 end');
}

/**
 * 大图-格式: [分享性能]
 * GROUP: 大图 MODULE: 格式TID: Multimedia_Gallery_share_011
 * 前置条件
 * 1、图库中存在不同格式的照片和视频文件
 */
async function Multimedia_Gallery_share_011(dt: Dt) {
  dt.log.i('分享性能 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分享性能 end');
}

