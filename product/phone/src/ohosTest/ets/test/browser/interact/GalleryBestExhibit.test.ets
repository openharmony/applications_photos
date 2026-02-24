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

export default function GalleryBestExhibit(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('GalleryBestExhibitTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllGalleryBestExhibit').init();
      dt.log.i('beforeAll GalleryBestExhibit start');
      dt.log.i('beforeAll GalleryBestExhibit finish');
    });
    /**
     * 打开大图
     */
    it('beforeGalleryBestExhibit', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    it('Prototype_Multimedia_Gallery_Best_Exihibit_001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [不同入口最佳呈现展示] TID: Prototype_Multimedia_Gallery_Best_Exihibit_001
      await Prototype_Multimedia_Gallery_Best_Exihibit_001(dt);
    });
    it('Prototype_Multimedia_Gallery_Best_Exihibit_002', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [云端图片最佳呈现展示] TID: Prototype_Multimedia_Gallery_Best_Exihibit_002
      await Prototype_Multimedia_Gallery_Best_Exihibit_002(dt);
    });
    it('Prototype_Multimedia_Gallery_Best_Exihibit_003', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [风景/文档类图片按照默认居中显示] TID: Prototype_Multimedia_Gallery_Best_Exihibit_003
      await Prototype_Multimedia_Gallery_Best_Exihibit_003(dt);
    });
    it('Prototype_Multimedia_Gallery_Best_Exihibit_004', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-滑动用例: [最佳呈现左右滑动] TID: Prototype_Multimedia_Gallery_Best_Exihibit_004
      await Prototype_Multimedia_Gallery_Best_Exihibit_004(dt);
    });
    it('Prototype_Multimedia_Gallery_Best_Exihibit_005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [相机拍照后立即进入图库不支持最佳呈现] TID: Prototype_Multimedia_Gallery_Best_Exihibit_005
      await Prototype_Multimedia_Gallery_Best_Exihibit_005(dt);
    });
    it('Prototype_Multimedia_Gallery_Best_Exihibit_006', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [静态照片支持最佳呈现] TID: Prototype_Multimedia_Gallery_Best_Exihibit_006
      await Prototype_Multimedia_Gallery_Best_Exihibit_006(dt);
    });
    it('Prototype_Multimedia_Gallery_Best_Exihibit_007', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [横屏状态下最佳呈现] TID: Prototype_Multimedia_Gallery_Best_Exihibit_007
      await Prototype_Multimedia_Gallery_Best_Exihibit_007(dt);
    });
    it('Prototype_Multimedia_Gallery_Best_Exihibit_008', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [图片编辑后最佳呈现] TID: Prototype_Multimedia_Gallery_Best_Exihibit_008
      await Prototype_Multimedia_Gallery_Best_Exihibit_008(dt);
    });
    it('TC_Video_VDEC_ContainerFormat_0101', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-解析用例: [验证可以正常解析扩展名为mp4的媒体文件] TID: TC_Video_VDEC_ContainerFormat_0101
      await TC_Video_VDEC_ContainerFormat_0101(dt);
    });
    it('TC_Video_VDEC_Play_Compability_0101', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [验证H264编码格式的视频解码正常] TID: TC_Video_VDEC_Play_Compability_0101
      await TC_Video_VDEC_Play_Compability_0101(dt);
    });


    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachGalleryBestExhibit').init();
      dt.log.i('afterEach GalleryBestExhibit start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach GalleryBestExhibit finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllGalleryBestExhibit').init();
      dt.log.i('afterAll GalleryBestExhibit start');
      await Exit.browser();
      dt.log.i('afterAll GalleryBestExhibit finish');
    });
  });
}

/**
 * 大图-进入大图: [不同入口最佳呈现展示]
 * GROUP: 大图 MODULE: 进入大图TID: Prototype_Multimedia_Gallery_Best_Exihibit_001
 * 前置条件
 * 1、图库存在不同风格的图片
 2、充电灭屏，电量大于50%，触发算法分析
 */
async function Prototype_Multimedia_Gallery_Best_Exihibit_001(dt: Dt) {
  dt.log.i('不同入口最佳呈现展示 start');
  dt.log.i('STEP 1、从时间轴/图片相册/用户自定义相册/FA卡片/收藏相册、最近删除/相机左下角缩略图/截屏录屏进入大图');


  dt.log.i('STEP 2、大图上划或点击右上角详细信息');

  await dt.sleep();
  dt.log.i('预期结果2、图片按照最佳呈现显示（图片主体居中显示），动效符合ux设计  ');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不同入口最佳呈现展示 end');
}

/**
 * 大图-进入大图: [云端图片最佳呈现展示]
 * GROUP: 大图 MODULE: 进入大图TID: Prototype_Multimedia_Gallery_Best_Exihibit_002
 * 前置条件
 * 1、测试机和辅助机登陆同一云账号，开启图库云同步
 2、手机已连接WLAN
 3、充电灭屏，电量大于50%，触发算法分析
 */
async function Prototype_Multimedia_Gallery_Best_Exihibit_002(dt: Dt) {
  dt.log.i('云端图片最佳呈现展示 start');
  dt.log.i('STEP 1、打开图库，选择一张图片，进入大图模式');


  dt.log.i('STEP 2、大图上划或点击右上角详细信息');

  await dt.sleep();
  dt.log.i('预期结果2、图片按照最佳呈现显示（图片主体居中显示），动效符合ux设计 ');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('云端图片最佳呈现展示 end');
}

/**
 * 大图-进入大图: [风景/文档类图片按照默认居中显示]
 * GROUP: 大图 MODULE: 进入大图TID: Prototype_Multimedia_Gallery_Best_Exihibit_003
 * 前置条件
 * 1、图库存在风景和文档图片

 2、充电灭屏，电量大于50%，触发算法分析
 */
async function Prototype_Multimedia_Gallery_Best_Exihibit_003(dt: Dt) {
  dt.log.i('风景/文档类图片按照默认居中显示 start');
  dt.log.i('STEP 1、打开图库，点击图片进入大图模式');


  dt.log.i('STEP 2、大图上划或点击右上角详细信息');
  await dt.swipeScreen?.left();
  await dt.sleep();
  dt.log.i('预期结果2、风景或文档类图片居中显示 ');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('风景/文档类图片按照默认居中显示 end');
}

/**
 * 大图-滑动: [最佳呈现左右滑动]
 * GROUP: 大图 MODULE: 滑动TID: Prototype_Multimedia_Gallery_Best_Exihibit_004
 * 前置条件
 * 1、图库存在不同图片

 2、充电灭屏，电量大于50%，触发算法分析
 */
async function Prototype_Multimedia_Gallery_Best_Exihibit_004(dt: Dt) {
  dt.log.i('最佳呈现左右滑动 start');
  dt.log.i('STEP 1、打开图库，点击图片进入大图模式');


  dt.log.i('STEP 2、大图上划或点击右上角详细信息，左右滑动');

  await dt.sleep();
  dt.log.i('预期结果2、图片按照最佳呈现显示（图片主体居中显示） ');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最佳呈现左右滑动 end');
}

/**
 * 大图-进入大图: [相机拍照后立即进入图库不支持最佳呈现]
 * GROUP: 大图 MODULE: 进入大图TID: Prototype_Multimedia_Gallery_Best_Exihibit_005
 * 前置条件
 * 1、图库存在不同图片
 */
async function Prototype_Multimedia_Gallery_Best_Exihibit_005(dt: Dt) {
  dt.log.i('相机拍照后立即进入图库不支持最佳呈现 start');
  dt.log.i('STEP 1、打开相机拍照，点击左下角缩略图进入大图');


  dt.log.i('STEP 2、大图上滑查看详情');


  dt.log.i('预期结果2、图片居中显示4、图片最佳呈现显示（图片主体居中）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、充电灭屏，等电量超过50%，触发算法分析');


  dt.log.i('STEP 4、再次打开大图，上滑查看详情');


  dt.log.i('预期结果4、图片最佳呈现显示（图片主体居中）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  await dt.swipeScreen?.left();
  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相机拍照后立即进入图库不支持最佳呈现 end');
}

/**
 * 大图-进入大图: [静态照片支持最佳呈现]
 * GROUP: 大图 MODULE: 进入大图TID: Prototype_Multimedia_Gallery_Best_Exihibit_006
 * 前置条件
 * 1.预制heic、dng、ARW、wbmp、NEF、CR2、gif等不同类型图片
 2、充电灭屏，电量大于50%，触发算法分析
 */
async function Prototype_Multimedia_Gallery_Best_Exihibit_006(dt: Dt) {
  dt.log.i('静态照片支持最佳呈现 start');
  dt.log.i('STEP 1、打开图库，点击图片进入大图模式');


  dt.log.i('STEP 2、大图上划或点击右上角详细信息，左右滑动');

  await dt.sleep();
  dt.log.i('预期结果2、静态图片支持最佳呈现显示，动态图片居中显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('静态照片支持最佳呈现 end');
}

/**
 * 大图-进入大图: [横屏状态下最佳呈现]
 * GROUP: 大图 MODULE: 进入大图TID: Prototype_Multimedia_Gallery_Best_Exihibit_007
 * 前置条件
 * 1、图库中存在图片资源
 2、充电灭屏启动算法分析
 */
async function Prototype_Multimedia_Gallery_Best_Exihibit_007(dt: Dt) {
  dt.log.i('横屏状态下最佳呈现 start');
  dt.log.i('STEP 1、打开图库，选择图片进入大图界面，横屏');


  dt.log.i('STEP 2、大图上滑或点击右上角详细信息按钮，查看详细信息');

  await dt.sleep();
  dt.log.i('预期结果2、图片按照最佳呈现显示（图片主体居中显示），动效符合ux设计 ');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('横屏状态下最佳呈现 end');
}

/**
 * 大图-进入大图: [图片编辑后最佳呈现]
 * GROUP: 大图 MODULE: 进入大图TID: Prototype_Multimedia_Gallery_Best_Exihibit_008
 * 前置条件
 * 1、图库中存在图片资源
 2、充电灭屏启动算法分析
 */
async function Prototype_Multimedia_Gallery_Best_Exihibit_008(dt: Dt) {
  dt.log.i('图片编辑后最佳呈现 start');
  dt.log.i('STEP 1、打开图库，选择图片进入大图界面编辑图片后覆盖原图/另存');


  dt.log.i('STEP 2、大图上滑或点击右上角详细信息按钮，查看详细信息');
  await dt.swipeScreen?.left();
  await dt.sleep();
  dt.log.i('预期结果2、图片按照最佳呈现显示（图片主体居中显示），动效符合ux设计 ');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片编辑后最佳呈现 end');
}

/**
 * 大图-解析: [验证可以正常解析扩展名为mp4的媒体文件]
 * GROUP: 大图 MODULE: 解析TID: TC_Video_VDEC_ContainerFormat_0101
 * 前置条件
 * 1、将PC侧资源push到手机Videos文件夹下；
 */
async function TC_Video_VDEC_ContainerFormat_0101(dt: Dt) {
  dt.log.i('验证可以正常解析扩展名为mp4的媒体文件 start');
  dt.log.i('STEP 1、进入图库，点击文件进行播放；');


  dt.log.i('STEP 2、退出图库应用；');

  await dt.sleep();

  await dt.swipeScreen?.left();
  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('验证可以正常解析扩展名为mp4的媒体文件 end');
}

/**
 * 大图-格式: [验证H264编码格式的视频解码正常]
 * GROUP: 大图 MODULE: 格式TID: TC_Video_VDEC_Play_Compability_0101
 * 前置条件
 *  1、将PC侧资源push到手机media文件夹下；
 */
async function TC_Video_VDEC_Play_Compability_0101(dt: Dt) {
  dt.log.i('验证H264编码格式的视频解码正常 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('验证H264编码格式的视频解码正常 end');
}

