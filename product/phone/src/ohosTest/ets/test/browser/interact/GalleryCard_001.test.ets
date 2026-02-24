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

export default function GalleryCard001(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('GalleryCard001Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllGalleryCard001').init();
      dt.log.i('beforeAll GalleryCard001 start');
      dt.log.i('beforeAll GalleryCard001 finish');
    });
    /**
     * 打开大图
     */
    it('beforeGalleryCard001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    // DT声明
    it('ani_GalleryCard_061', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-用例: [绑定相同相册，轮播顺序一致] TID: ani_GalleryCard_061
      await ani_GalleryCard_061(dt);
    });
    it('ani_GalleryCard_062', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-用例: [开启云同步，拉起卡片正常] TID: ani_GalleryCard_062
      await ani_GalleryCard_062(dt);
    });
    it('ani_GalleryCard_063', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-用例: [换绑单张图片] TID: ani_GalleryCard_063
      await ani_GalleryCard_063(dt);
    });
    it('ani_GalleryCard_064', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-格式用例: [卡片支持不同格式图] TID: ani_GalleryCard_064
      await ani_GalleryCard_064(dt);
    });
    it('ani_GalleryCard_065', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  大图-用例: [关闭云同步，FA卡片显示默认图] TID: ani_GalleryCard_065
      await ani_GalleryCard_065(dt);
    });
    it('ani_GalleryCard_066', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  大图-用例: [编辑操作后卡片轮播效果] TID: ani_GalleryCard_066
      await ani_GalleryCard_066(dt);
    });
    it('ani_GalleryCard_067', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [点击卡片进入大图浏览完成时延] TID: ani_GalleryCard_067
      await ani_GalleryCard_067(dt);
    });
    it('ani_GalleryCard_068', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [点击卡片进入大图浏览响应时延] TID: ani_GalleryCard_068
      await ani_GalleryCard_068(dt);
    });
    it('ani_GalleryCard_069', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-进入大图用例: [点击卡片进入大图浏览最大连续丢帧] TID: ani_GalleryCard_069
      await ani_GalleryCard_069(dt);
    });
    it('ani_GalleryCard_070', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-用例: [添加图库卡片到桌面显示完成时延] TID: ani_GalleryCard_070
      await ani_GalleryCard_070(dt);
    });
    it('ani_GalleryCard_071', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-用例: [添加图库卡片到桌面响应时延] TID: ani_GalleryCard_071
      await ani_GalleryCard_071(dt);
    });
    it('ani_GalleryCard_072', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-用例: [卡片内容加载完成时延] TID: ani_GalleryCard_072
      await ani_GalleryCard_072(dt);
    });
    it('ani_GalleryCard_073', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-用例: [卡片内容加载响应时延] TID: ani_GalleryCard_073
      await ani_GalleryCard_073(dt);
    });
    it('ani_GalleryCard_074', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-用例: [卡片内容加载动效最大连续丢帧] TID: ani_GalleryCard_074
      await ani_GalleryCard_074(dt);
    });
    it('ani_GalleryCard_075', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-用例: [卡片图片内容加载速度（加载完成时延）] TID: ani_GalleryCard_075
      await ani_GalleryCard_075(dt);
    });
    it('ani_GalleryCard_076', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-用例: [卡片相册内容加载速度（加载完成时延）] TID: ani_GalleryCard_076
      await ani_GalleryCard_076(dt);
    });
    it('ani_GalleryCard_077', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-下载用例: [编辑卡片拉起编辑界面响应时延] TID: ani_GalleryCard_077
      await ani_GalleryCard_077(dt);
    });
    it('ani_GalleryCard_078', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [编辑卡片拉起编辑界面完成时延] TID: ani_GalleryCard_078
      await ani_GalleryCard_078(dt);
    });
    it('ani_GalleryCard_079', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  大图-视频用例: [编辑卡片选择相册加载时延] TID: ani_GalleryCard_079
      await ani_GalleryCard_079(dt);
    });
    it('ani_GalleryCard_080', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  大图-用例: [轮播动效完成时延] TID: ani_GalleryCard_080
      await ani_GalleryCard_080(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachGalleryCard001').init();
      dt.log.i('afterEach GalleryCard001 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach GalleryCard001 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllGalleryCard001').init();
      dt.log.i('afterAll GalleryCard001 start');
      await Exit.browser();
      dt.log.i('afterAll GalleryCard001 finish');
    });
  });
}

// DT步骤
/**
 * 大图-: [绑定相同相册，轮播顺序一致]
 * GROUP: 大图 MODULE: TID: ani_GalleryCard_061
 * 前置条件
 * 1、桌面有至少2个图库卡片
 */
async function ani_GalleryCard_061(dt: Dt) {
  dt.log.i('绑定相同相册，轮播顺序一致 start');
  dt.log.i('STEP 1、卡片都换绑相同的相册');


  dt.log.i('预期结果1、查看轮播顺序，都是一致的');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('绑定相同相册，轮播顺序一致 end');
}

/**
 * 大图-: [开启云同步，拉起卡片正常]
 * GROUP: 大图 MODULE: TID: ani_GalleryCard_062
 * 前置条件
 * 1、图库无图片
 2、有多张图片资源的账号
 */
async function ani_GalleryCard_062(dt: Dt) {
  dt.log.i('开启云同步，拉起卡片正常 start');
  dt.log.i('STEP 1、开启云同步');


  dt.log.i('STEP 2、云同步过程中，拉起卡片');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果2、可以正常拉起卡片，卡片预览图为默认图。相册存在可以预览的云图时，FA卡片显示正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('开启云同步，拉起卡片正常 end');
}

/**
 * 大图-: [换绑单张图片]
 * GROUP: 大图 MODULE: TID: ani_GalleryCard_063
 * 前置条件
 * 1、桌面有图库卡片
 */
async function ani_GalleryCard_063(dt: Dt) {
  dt.log.i('换绑单张图片 start');
  dt.log.i('STEP 1、换绑单张图片');


  dt.log.i('预期结果1、换绑单张图片切换流程，中途不会卡顿，太高延迟');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、重复10次');


  dt.log.i('预期结果2、换绑的图片不会出现默认图');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('换绑单张图片 end');
}

/**
 * 大图-格式: [卡片支持不同格式图]
 * GROUP: 大图 MODULE: 格式TID: ani_GalleryCard_064
 * 前置条件
 * 1、图库存在不同格式的图片，包括动态图，连拍图，编辑覆盖原图，编辑另存为图
 */
async function ani_GalleryCard_064(dt: Dt) {
  dt.log.i('卡片支持不同格式图 start');
  dt.log.i('STEP 1、换绑包含不同类型图相册');


  dt.log.i('预期结果1、不同格式，或编辑后的图正常轮播');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('卡片支持不同格式图 end');
}

/**
 * 大图-: [关闭云同步，FA卡片显示默认图]
 * GROUP: 大图 MODULE: TID: ani_GalleryCard_065
 * 前置条件
 * 1、桌面有图库卡片
 2、云同步已开启
 3、FA卡片绑定云图片相册
 */
async function ani_GalleryCard_065(dt: Dt) {
  dt.log.i('关闭云同步，FA卡片显示默认图 start');
  dt.log.i('STEP 1、绑定云图片相册');
  await dt.swipeScreen?.left();

  dt.log.i('STEP 2、关闭云同步');


  dt.log.i('预期结果2、FA卡片显示默认图');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('关闭云同步，FA卡片显示默认图 end');
}

/**
 * 大图-: [编辑操作后卡片轮播效果]
 * GROUP: 大图 MODULE: TID: ani_GalleryCard_066
 * 前置条件
 * 1、桌面有图库卡片
 */
async function ani_GalleryCard_066(dt: Dt) {
  dt.log.i('编辑操作后卡片轮播效果 start');
  dt.log.i('STEP 1、长按卡片进行各种编辑操作，如：换绑单张照片，换绑相册，更改时间间隔');


  dt.log.i('预期结果1、操作结束后，退回桌面，卡片轮播正常，不会出现连续轮播两次的情况');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑操作后卡片轮播效果 end');
}

/**
 * 大图-进入大图: [点击卡片进入大图浏览完成时延]
 * GROUP: 大图 MODULE: 进入大图TID: ani_GalleryCard_067
 * 前置条件
 * 1、图库没有照片，也未开启云同步
 */
async function ani_GalleryCard_067(dt: Dt) {
  dt.log.i('点击卡片进入大图浏览完成时延 start');
  dt.log.i('STEP 1、从测试开始录屏（使用高速相机）');


  dt.log.i('STEP 2、点击图库卡片，进入大图浏览页面，记录抬手第一帧时间T1，页面放大完全时间T2');


  dt.log.i('STEP 3、点击响应时延T3=T2-T1');


  dt.log.i('预期结果3.1、本地加载：T3 <600ms3.2、网络加载：T3 <900ms');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  await dt.swipeScreen?.left();
  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('点击卡片进入大图浏览完成时延 end');
}

/**
 * 大图-进入大图: [点击卡片进入大图浏览响应时延]
 * GROUP: 大图 MODULE: 进入大图TID: ani_GalleryCard_068
 * 前置条件
 * 1、图库没有照片，也未开启云同步
 2、桌面上有一张相册卡片
 */
async function ani_GalleryCard_068(dt: Dt) {
  dt.log.i('点击卡片进入大图浏览响应时延 start');
  dt.log.i('STEP 1、从测试开始录屏（使用高速相机）');


  dt.log.i('STEP 2、点击图库卡片，进入大图浏览页面，记录抬手第一帧时间T1，页面刚刚放大时间T2');


  dt.log.i('STEP 3、点击响应时延T3=T2-T1');


  dt.log.i('预期结果3、T3测试值不超过85ms');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('点击卡片进入大图浏览响应时延 end');
}

/**
 * 大图-进入大图: [点击卡片进入大图浏览最大连续丢帧]
 * GROUP: 大图 MODULE: 进入大图TID: ani_GalleryCard_069
 * 前置条件
 * 1、桌面上有正在轮播的相册卡片A
 */
async function ani_GalleryCard_069(dt: Dt) {
  dt.log.i('点击卡片进入大图浏览最大连续丢帧 start');
  dt.log.i('STEP 1、从测试开始录屏（使用高速相机）');


  dt.log.i('STEP 2、点击图库卡片，进入大图浏览页面，记录动效卡最大连续丢帧数');


  dt.log.i('预期结果2、帧率为满帧，最大连续丢帧为0');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('点击卡片进入大图浏览最大连续丢帧 end');
}

/**
 * 大图-: [添加图库卡片到桌面显示完成时延]
 * GROUP: 大图 MODULE: TID: ani_GalleryCard_070
 * 前置条件
 * 1、桌面上有单张图片形成的图库卡片A
 */
async function ani_GalleryCard_070(dt: Dt) {
  dt.log.i('添加图库卡片到桌面显示完成时延 start');
  dt.log.i('STEP 1、从测试开始录屏（使用高速相机）');


  dt.log.i('STEP 2、长按应用图标或卡片，点击卡片进入卡片页面，点击“添加至桌面”，抬手第一帧时间为T1，桌面上卡片内容加载完成时间为T2');


  dt.log.i('STEP 3、卡片加载完成时延T3=T2-T1');
  await dt.swipeScreen?.left();

  dt.log.i('预期结果3.1、本地加载：T3 <600ms3.2、网络加载：T3 <900ms');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('添加图库卡片到桌面显示完成时延 end');
}

/**
 * 大图-: [添加图库卡片到桌面响应时延]
 * GROUP: 大图 MODULE: TID: ani_GalleryCard_071
 * 前置条件
 * 1、桌面上有正在轮播的图库FA卡片
 */
async function ani_GalleryCard_071(dt: Dt) {
  dt.log.i('添加图库卡片到桌面响应时延 start');
  dt.log.i('STEP 1、从测试开始录屏（使用高速相机）');


  dt.log.i('STEP 2、长按应用图标或卡片，点击卡片进入卡片页面，点击“添加至桌面”，记录抬手第一帧时间T1，动效的第一帧时间T2');


  dt.log.i('STEP 3、卡片加载响应耗时T3=T2-T1');


  dt.log.i('预期结果3、T3测试值不超过600ms');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('添加图库卡片到桌面响应时延 end');
}

/**
 * 大图-: [卡片内容加载完成时延]
 * GROUP: 大图 MODULE: TID: ani_GalleryCard_072
 * 前置条件
 * 1、桌面上已经有相册卡片A
 2、图库有多张照片
 */
async function ani_GalleryCard_072(dt: Dt) {
  dt.log.i('卡片内容加载完成时延 start');
  dt.log.i('STEP 1、从测试开始录屏（使用高速相机）');


  dt.log.i('STEP 2、长按图库，点击卡片进入添加到桌面界面，记录抬手第一帧时间T1');


  dt.log.i('STEP 3、卡片完全加载出来的时间T2');


  dt.log.i('预期结果3、T3测试值不超过600ms');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、卡片内容加载完成时延T3=T2-T1');


  await dt.swipeScreen?.left();
  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('卡片内容加载完成时延 end');
}

/**
 * 大图-: [卡片内容加载响应时延]
 * GROUP: 大图 MODULE: TID: ani_GalleryCard_073
 * 前置条件
 * 1、未设置过图库卡片的轮播间隔
 */
async function ani_GalleryCard_073(dt: Dt) {
  dt.log.i('卡片内容加载响应时延 start');
  dt.log.i('STEP 1、从测试开始录屏（使用高速相机）');


  dt.log.i('STEP 2、长按图库，点击卡片进入添加到桌面界面，记录抬手第一帧时间T1');


  dt.log.i('STEP 3、卡片放大的第一帧时间T2');


  dt.log.i('预期结果3、T3测试值不超过85ms');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、卡片内容加载响应时延T3=T2-T1');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('卡片内容加载响应时延 end');
}

/**
 * 大图-: [卡片内容加载动效最大连续丢帧]
 * GROUP: 大图 MODULE: TID: ani_GalleryCard_074
 * 前置条件
 * 1、同一屏桌面上分别有两张2*2的相册卡片A和B
 */
async function ani_GalleryCard_074(dt: Dt) {
  dt.log.i('卡片内容加载动效最大连续丢帧 start');
  dt.log.i('STEP 1、从测试开始录屏（使用高速相机）');


  dt.log.i('STEP 2、长按图库，点击卡片进入添加到桌面界面，记录动效卡最大连续丢帧数');


  dt.log.i('预期结果2、帧率为满帧，最大连续丢帧为0');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  await dt.assertComponent(PageTitle.index, true);
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('卡片内容加载动效最大连续丢帧 end');
}

/**
 * 大图-: [卡片图片内容加载速度（加载完成时延）]
 * GROUP: 大图 MODULE: TID: ani_GalleryCard_075
 * 前置条件
 * 1、相册中仅有一张图片
 */
async function ani_GalleryCard_075(dt: Dt) {
  dt.log.i('卡片图片内容加载速度（加载完成时延） start');
  dt.log.i('STEP 1、重启手机后，输入密码，进入桌面到图标显示时间T1，到卡片显示时间T2');
  await dt.swipeScreen?.left();

  dt.log.i('STEP 2、卡片加载时延T3=T2-T1');


  dt.log.i('预期结果3、T3测试值不超过0ms');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('卡片图片内容加载速度（加载完成时延） end');
}

/**
 * 大图-: [卡片相册内容加载速度（加载完成时延）]
 * GROUP: 大图 MODULE: TID: ani_GalleryCard_076
 * 前置条件
 * 1、桌面上有相册卡片A
 */
async function ani_GalleryCard_076(dt: Dt) {
  dt.log.i('卡片相册内容加载速度（加载完成时延） start');
  dt.log.i('STEP 1、重启手机后进入桌面，滑入桌面第2屏时间T1，到卡片显示时间T2');


  dt.log.i('STEP 2、卡片加载时延T3=T2-T1');


  dt.log.i('预期结果3、T3测试值不超过0ms');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('卡片相册内容加载速度（加载完成时延） end');
}

/**
 * 大图-下载: [编辑卡片拉起编辑界面响应时延]
 * GROUP: 大图 MODULE: 下载TID: ani_GalleryCard_077
 * 前置条件
 * 1、相册卡片A正在轮播云端的相册
 2、为下载任何远端相册到本地
 */
async function ani_GalleryCard_077(dt: Dt) {
  dt.log.i('编辑卡片拉起编辑界面响应时延 start');
  dt.log.i('STEP 1、从测试开始录屏');


  dt.log.i('STEP 2、长按图库卡片，点击编辑，记录点击编辑按钮抬手第一帧时间T1，界面响应变化第一帧时间T2');


  dt.log.i('STEP 3、响应时延T3=T2-T1');


  dt.log.i('预期结果3、T3测试值不超过85ms');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);

  await dt.swipeScreen?.left();
  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑卡片拉起编辑界面响应时延 end');
}

/**
 * 大图-视频: [编辑卡片拉起编辑界面完成时延]
 * GROUP: 大图 MODULE: 视频TID: ani_GalleryCard_078
 * 前置条件
 * 1、桌面有FA卡片A
 2、相册A既有图片也有视频，视频非第一个元素
 */
async function ani_GalleryCard_078(dt: Dt) {
  dt.log.i('编辑卡片拉起编辑界面完成时延 start');
  dt.log.i('STEP 1、从测试开始录屏');


  dt.log.i('STEP 2、长按图库卡片，点击编辑，记录点击编辑按钮抬手第一帧时间T1，界面加载完成第一帧时间T2');


  dt.log.i('STEP 3、响应时延T3=T2-T1');


  dt.log.i('预期结果3.1、本地加载：T3 <600ms3.2、网络加载：T3 <900ms');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑卡片拉起编辑界面完成时延 end');
}

/**
 * 大图-视频: [编辑卡片选择相册加载时延]
 * GROUP: 大图 MODULE: 视频TID: ani_GalleryCard_079
 * 前置条件
 * 1、桌面有FA卡片A
 2、相册A第一个元素为视频
 */
async function ani_GalleryCard_079(dt: Dt) {
  dt.log.i('编辑卡片选择相册加载时延 start');
  dt.log.i('STEP 1、从测试开始录屏');


  dt.log.i('STEP 2、长按图库卡片，点击编辑，点击选择相册。点击任意相册，记录选择相册时抬手第一帧时间T1，界面加载完成第一帧时间T2');


  dt.log.i('STEP 3、响应时延T3=T2-T1');


  dt.log.i('预期结果3、T3测试值不超过600ms');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('编辑卡片选择相册加载时延 end');
  await dt.swipeScreen?.left();
}

/**
 * 大图-: [轮播动效完成时延]
 * GROUP: 大图 MODULE: TID: ani_GalleryCard_080
 * 前置条件
 * 1、桌面有FA卡片A
 2、相册A为空相册
 */
async function ani_GalleryCard_080(dt: Dt) {
  dt.log.i('轮播动效完成时延 start');
  dt.log.i('STEP 1、从测试开始录屏');


  dt.log.i('STEP 2、图库有卡片，轮播的第一帧时间T1，界面加载完成第一帧时间T2');


  dt.log.i('STEP 3、响应时延T3=T2-T1');


  dt.log.i('预期结果3、T3测试值不超过500ms');

  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('轮播动效完成时延 end');
}

