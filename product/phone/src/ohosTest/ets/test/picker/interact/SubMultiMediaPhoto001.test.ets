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

export default function SubMultiMediaPhoto001(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('SubMultiMediaPhoto001Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllSubMultiMediaPhoto001').init();
      dt.log.i('beforeAll SubMultiMediaPhoto001 start');
      dt.log.i('beforeAll SubMultiMediaPhoto001 finish');
    });
    /**
     * 打开大图
     */
    run('beforeSubMultiMediaPhoto001', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });


    // DT声明
    run('SUBMULTIMEDIAMEDIAPHOTODEMO0100', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-用例: [图库picker-部分三方未接入但是功能已支持的特性测试依赖测试demo-微信] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_DEMO_0100
      await SUBMULTIMEDIAMEDIAPHOTODEMO0100(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOGLOBAL0100', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-用例: [图库picker-更换不同语言查看图库picker组件显示是否正常] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_GLOBAL_0100
      await SUBMULTIMEDIAMEDIAPHOTOGLOBAL0100(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0100', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-用例: [图库picker-性能:拉起性能] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PERFORMANCE_0100
      await SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0100(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0101', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-大图用例: [图库picker-性能:进大图性能] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PERFORMANCE_0101
      await SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0101(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0102', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-用例: [图库picker-性能:选图完成性能] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PERFORMANCE_0102
      await SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0102(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0103', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-滑动用例: [图库picker-性能:大图预览页滑动流畅不掉帧] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PERFORMANCE_0103
      await SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0103(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0104', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-滑动用例: [图库picker-性能:宫格页滑动流畅不掉帧] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PERFORMANCE_0104
      await SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0104(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0105', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-滑动用例: [图库picker-性能:滚动条滑动流畅不掉帧] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PERFORMANCE_0105
      await SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0105(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0700', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-滑动用例: [picker适老化大字体] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PERFORMANCE_0700
      await SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0700(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0100', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-用例: [系统应用-备忘录使用模态picker选择相机拍摄的图片，图片单独授权] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0100
      await SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0100(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0200', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-用例: [三方应用-微博使用嵌入式picker选择相机拍摄的图片，图片单独授权] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0200
      await SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0200(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0300', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-用例: [三方应用-小红书使用嵌入式picker选择相机拍摄的图片，图片单独授权] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0300
      await SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0300(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0400', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-用例: [系统应用-备忘录使用模态picker选择截屏保存的图片，图片单独授权] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0400
      await SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0400(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0500', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-用例: [三方应用-微博使用嵌入式picker选择截屏保存的图片，图片单独授权] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0500
      await SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0500(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0600', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-用例: [三方应用-小红书使用嵌入式picker选择截屏保存的图片，图片单独授权] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0600
      await SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0600(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0700', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [系统应用-备忘录使用模态picker选择相机录像的视频，视频单独授权] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0700
      await SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0700(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0800', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [三方应用-微博使用嵌入式picker选择相机录像的视频，视频单独授权] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0800
      await SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0800(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0900', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [三方应用-小红书使用嵌入式picker选择相机录像的视频，视频单独授权] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0900
      await SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0900(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1000', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [系统应用-备忘录使用模态picker选择录屏保存的视频，视频单独授权] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_1000
      await SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1000(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1100', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [三方应用-微博使用嵌入式picker选择保存的视频，视频单独授权] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_1100
      await SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1100(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1200', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [三方应用-小红书使用嵌入式picker选择保存的视频，视频单独授权] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_1200
      await SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1200(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0100', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [备忘录：新建备忘录] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0100
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0100(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachSubMultiMediaPhoto001').init();
      dt.log.i('afterEach SubMultiMediaPhoto001 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach SubMultiMediaPhoto001 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllSubMultiMediaPhoto001').init();
      dt.log.i('afterAll SubMultiMediaPhoto001 start');
      await Exit.browser();
      dt.log.i('afterAll SubMultiMediaPhoto001 finish');
    });
  });
}

// DT步骤
/**
 * picker-: [图库picker-部分三方未接入但是功能已支持的特性测试依赖测试demo-微信]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_DEMO_0100
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTODEMO0100(dt: Dt) {
  dt.log.i('图库picker-部分三方未接入但是功能已支持的特性测试依赖测试demo-微信 start');
  dt.log.i('STEP 1、微信-最近照片');

  await dt.sleep();
  dt.log.i('预期结果1、功能正常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker-部分三方未接入但是功能已支持的特性测试依赖测试demo-微信 end');
}

/**
 * picker-: [图库picker-更换不同语言查看图库picker组件显示是否正常]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_GLOBAL_0100
 * 前置条件
 * 1、图库中存在图片以及带有图片的相册
 2、点击开启关怀模式，将字体调整为最大

 */
async function SUBMULTIMEDIAMEDIAPHOTOGLOBAL0100(dt: Dt) {
  dt.log.i('图库picker-更换不同语言查看图库picker组件显示是否正常 start');
  dt.log.i('STEP 1、更换语言为维吾尔语，拉起的图库picker');

  await dt.sleep();
  dt.log.i('预期结果1、拉起的图库picker中组件显示正常，安全弹框中的提示信息无异常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、更换语言为英语，拉起的图库picker');

  await dt.sleep();
  dt.log.i('预期结果2、拉起的图库picker中组件显示正常，安全弹框中的提示信息无异常');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker-更换不同语言查看图库picker组件显示是否正常 end');
}

/**
 * picker-: [图库picker-性能:拉起性能]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PERFORMANCE_0100
 * 前置条件
 * 1、登录12W+云图账号
 */
async function SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0100(dt: Dt) {
  dt.log.i('图库picker-性能:拉起性能 start');
  dt.log.i('STEP 1、新建备忘录&微信分享图片时拉起图库picker界面');

  await dt.sleep();
  dt.log.i('预期结果1、响应时延：手指离开屏幕第一帧->picker动效出现第一帧');
  await dt.sleep(DELAY.short);
  dt.log.i('预期结果2、完成时延：手指离开屏幕第一帧->picker被完全拉起第一帧');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker-性能:拉起性能 end');
}

/**
 * picker-大图: [图库picker-性能:进大图性能]
 * GROUP: picker MODULE: 大图TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PERFORMANCE_0101
 * 前置条件
 * 1、登录12W+云图账号
 2、当前处于图库picker宫格页
 */
async function SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0101(dt: Dt) {
  dt.log.i('图库picker-性能:进大图性能 start');
  dt.log.i('STEP 1、点击图片进入大图');

  await dt.sleep();
  dt.log.i('预期结果1、完成时延：手指离开屏幕第一帧->进大图动效开始第一帧');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker-性能:进大图性能 end');
}

/**
 * picker-: [图库picker-性能:选图完成性能]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PERFORMANCE_0102
 * 前置条件
 * 1、登录12W+云图账号

 */
async function SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0102(dt: Dt) {
  dt.log.i('图库picker-性能:选图完成性能 start');
  dt.log.i('STEP 1、当前已勾选图片，处于图库宫格页，点击完成');

  await dt.sleep();
  dt.log.i('预期结果1、完成时延：手指离开屏幕第一帧->图库picker消失动效第一帧');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker-性能:选图完成性能 end');
}

/**
 * picker-滑动: [图库picker-性能:大图预览页滑动流畅不掉帧]
 * GROUP: picker MODULE: 滑动TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PERFORMANCE_0103
 * 前置条件
 * 1、登录12W+云图账号
 2、当前处于图库picker大图预览页
 */
async function SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0103(dt: Dt) {
  dt.log.i('图库picker-性能:大图预览页滑动流畅不掉帧 start');
  dt.log.i('STEP 1、执行抓Trace脚本，开始滑动大图预览页8S，将生成的Trace文件在网站： 打开');

  await dt.sleep();
  dt.log.i('预期结果1、查看8S内的平均滑动帧率');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker-性能:大图预览页滑动流畅不掉帧 end');
}

/**
 * picker-滑动: [图库picker-性能:宫格页滑动流畅不掉帧]
 * GROUP: picker MODULE: 滑动TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PERFORMANCE_0104
 * 前置条件
 * 1、登录12W+云图账号
 2、当前处于图库picker宫格页
 */
async function SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0104(dt: Dt) {
  dt.log.i('图库picker-性能:宫格页滑动流畅不掉帧 start');
  dt.log.i('STEP 1、执行抓Trace脚本，开始滑动宫格页8S，将生成的Trace文件在网站： 打开');

  await dt.sleep();
  dt.log.i('预期结果1、查看8S内的平均滑动帧率');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker-性能:宫格页滑动流畅不掉帧 end');
}

/**
 * picker-滑动: [图库picker-性能:滚动条滑动流畅不掉帧]
 * GROUP: picker MODULE: 滑动TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PERFORMANCE_0105
 * 前置条件
 * 1、登录12W+云图账号
 2、当前处于图库picker宫格页
 */
async function SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0105(dt: Dt) {
  dt.log.i('图库picker-性能:滚动条滑动流畅不掉帧 start');
  dt.log.i('STEP 1、执行抓Trace脚本，开始拖动滚动条滑动宫格页8S，将生成的Trace文件在网站： 打开');

  await dt.sleep();
  dt.log.i('预期结果1、查看8S内的平均滑动帧率');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker-性能:滚动条滑动流畅不掉帧 end');
}

/**
 * picker-滑动: [picker适老化大字体]
 * GROUP: picker MODULE: 滑动TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PERFORMANCE_0700
 * 前置条件
 * 1.设置-辅助功能-关怀模式，设置最大尺寸大6档
 2.语言设置为维吾尔语
 */
async function SUBMULTIMEDIAMEDIAPHOTOPERFORMANCE0700(dt: Dt) {
  dt.log.i('picker适老化大字体 start');
  dt.log.i('STEP 1、进入图库应用');

  await dt.sleep();
  dt.log.i('STEP 2、新建相册进入picker选择界面，观察宫格，列表下显示效果');

  await dt.sleep();
  dt.log.i('预期结果2.内容完整，无截断，内容丢失，内容符合换行及省略规则。无挤压现象。水平方向和垂直方向对齐无问题。内容不超出边界。（维吾尔语展示为镜像）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、切换到所有相册，上下滑动');

  await dt.sleep();
  dt.log.i('预期结果3.内容完整，无截断，内容丢失，内容符合换行及省略规则。无挤压现象。水平方向和垂直方向对齐无问题。内容不超出边界。（维吾尔语展示为镜像）');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('picker适老化大字体 end');
}

/**
 * picker-: [系统应用-备忘录使用模态picker选择相机拍摄的图片，图片单独授权]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0100
 * 前置条件
 * 1.图库存在相机拍摄的照片
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0100(dt: Dt) {
  dt.log.i('系统应用-备忘录使用模态picker选择相机拍摄的图片，图片单独授权 start');
  dt.log.i('STEP 1.点击备忘录，新建备忘录');

  await dt.sleep();
  dt.log.i('STEP 2.点击选择图片，勾选图片');

  await dt.sleep();
  dt.log.i('STEP 3.点击确定');

  await dt.sleep();
  dt.log.i('STEP 4.拉取数据库');

  await dt.sleep();
  dt.log.i('预期结果4.数据库拉取成功6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.SQLLite打开数据库');

  await dt.sleep();
  dt.log.i('STEP 6.打开UriPermission表查看permission_type字段');

  await dt.sleep();
  dt.log.i('预期结果6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('系统应用-备忘录使用模态picker选择相机拍摄的图片，图片单独授权 end');
}

/**
 * picker-: [三方应用-微博使用嵌入式picker选择相机拍摄的图片，图片单独授权]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0200
 * 前置条件
 * 1.图库存在相机拍摄的照片
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0200(dt: Dt) {
  dt.log.i('三方应用-微博使用嵌入式picker选择相机拍摄的图片，图片单独授权 start');
  dt.log.i('STEP 1.点击微博，点击+号');

  await dt.sleep();
  dt.log.i('STEP 2.点击图片按钮');

  await dt.sleep();
  dt.log.i('STEP 3.选择图片，点击下一步');

  await dt.sleep();
  dt.log.i('STEP 4.拉取数据库');

  await dt.sleep();
  dt.log.i('预期结果4.数据库拉取成功6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.SQLLite打开数据库');

  await dt.sleep();
  dt.log.i('STEP 6.打开UriPermission表查看permission_type字段');

  await dt.sleep();
  dt.log.i('预期结果6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('三方应用-微博使用嵌入式picker选择相机拍摄的图片，图片单独授权 end');
}

/**
 * picker-: [三方应用-小红书使用嵌入式picker选择相机拍摄的图片，图片单独授权]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0300
 * 前置条件
 * 1.图库存在相机拍摄的照片
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0300(dt: Dt) {
  dt.log.i('三方应用-小红书使用嵌入式picker选择相机拍摄的图片，图片单独授权 start');
  dt.log.i('STEP 1.点击小红书，点击+号');

  await dt.sleep();
  dt.log.i('STEP 2.点击图片按钮');

  await dt.sleep();
  dt.log.i('STEP 3.选择图片，点击下一步');

  await dt.sleep();
  dt.log.i('STEP 4.拉取数据库');

  await dt.sleep();
  dt.log.i('预期结果4.数据库拉取成功6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.SQLLite打开数据库');

  await dt.sleep();
  dt.log.i('STEP 6.打开UriPermission表查看permission_type字段');

  await dt.sleep();
  dt.log.i('预期结果6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('三方应用-小红书使用嵌入式picker选择相机拍摄的图片，图片单独授权 end');
}

/**
 * picker-: [系统应用-备忘录使用模态picker选择截屏保存的图片，图片单独授权]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0400
 * 前置条件
 * 1.图库存在截屏保存的照片
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0400(dt: Dt) {
  dt.log.i('系统应用-备忘录使用模态picker选择截屏保存的图片，图片单独授权 start');
  dt.log.i('STEP 1.点击备忘录，新建备忘录');

  await dt.sleep();
  dt.log.i('STEP 2.点击选择图片，勾选图片');

  await dt.sleep();
  dt.log.i('STEP 3.点击确定');

  await dt.sleep();
  dt.log.i('STEP 4.拉取数据库');

  await dt.sleep();
  dt.log.i('预期结果4.数据库拉取成功6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.SQLLite打开数据库');

  await dt.sleep();
  dt.log.i('STEP 6.打开UriPermission表查看permission_type字段');

  await dt.sleep();
  dt.log.i('预期结果6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('系统应用-备忘录使用模态picker选择截屏保存的图片，图片单独授权 end');
}

/**
 * picker-: [三方应用-微博使用嵌入式picker选择截屏保存的图片，图片单独授权]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0500
 * 前置条件
 * 1.图库存在截屏保存的照片
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0500(dt: Dt) {
  dt.log.i('三方应用-微博使用嵌入式picker选择截屏保存的图片，图片单独授权 start');
  dt.log.i('STEP 1.点击微博，点击+号');

  await dt.sleep();
  dt.log.i('STEP 2.点击图片按钮');

  await dt.sleep();
  dt.log.i('STEP 3.选择图片，点击下一步');

  await dt.sleep();
  dt.log.i('STEP 4.拉取数据库');

  await dt.sleep();
  dt.log.i('预期结果4.数据库拉取成功6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.SQLLite打开数据库');

  await dt.sleep();
  dt.log.i('STEP 6.打开UriPermission表查看permission_type字段');

  await dt.sleep();
  dt.log.i('预期结果6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('三方应用-微博使用嵌入式picker选择截屏保存的图片，图片单独授权 end');
}

/**
 * picker-: [三方应用-小红书使用嵌入式picker选择截屏保存的图片，图片单独授权]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0600
 * 前置条件
 * 1.图库存在截屏保存的照片
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0600(dt: Dt) {
  dt.log.i('三方应用-小红书使用嵌入式picker选择截屏保存的图片，图片单独授权 start');
  dt.log.i('STEP 1.点击小红书，点击+号');

  await dt.sleep();
  dt.log.i('STEP 2.点击图片按钮');

  await dt.sleep();
  dt.log.i('STEP 3.选择图片，点击下一步');

  await dt.sleep();
  dt.log.i('STEP 4.拉取数据库');

  await dt.sleep();
  dt.log.i('预期结果4.数据库拉取成功6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.SQLLite打开数据库');

  await dt.sleep();
  dt.log.i('STEP 6.打开UriPermission表查看permission_type字段');

  await dt.sleep();
  dt.log.i('预期结果6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('三方应用-小红书使用嵌入式picker选择截屏保存的图片，图片单独授权 end');
}

/**
 * picker-视频: [系统应用-备忘录使用模态picker选择相机录像的视频，视频单独授权]
 * GROUP: picker MODULE: 视频TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0700
 * 前置条件
 * 1.图库存在相机录像的视频
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0700(dt: Dt) {
  dt.log.i('系统应用-备忘录使用模态picker选择相机录像的视频，视频单独授权 start');
  dt.log.i('STEP 1.点击备忘录，新建备忘录');

  await dt.sleep();
  dt.log.i('STEP 2.点击选择视频，勾选视频');

  await dt.sleep();
  dt.log.i('STEP 3.点击确定');

  await dt.sleep();
  dt.log.i('STEP 4.拉取数据库');

  await dt.sleep();
  dt.log.i('预期结果4.数据库拉取成功6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.SQLLite打开数据库');

  await dt.sleep();
  dt.log.i('STEP 6.打开UriPermission表查看permission_type字段');

  await dt.sleep();
  dt.log.i('预期结果6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('系统应用-备忘录使用模态picker选择相机录像的视频，视频单独授权 end');
}

/**
 * picker-视频: [三方应用-微博使用嵌入式picker选择相机录像的视频，视频单独授权]
 * GROUP: picker MODULE: 视频TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0800
 * 前置条件
 * 1.图库存在相机录像的视频
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0800(dt: Dt) {
  dt.log.i('三方应用-微博使用嵌入式picker选择相机录像的视频，视频单独授权 start');
  dt.log.i('STEP 1.点击微博，点击+号');

  await dt.sleep();
  dt.log.i('STEP 2.点击图片按钮');

  await dt.sleep();
  dt.log.i('STEP 3.选择视频，点击下一步');

  await dt.sleep();
  dt.log.i('STEP 4.拉取数据库');

  await dt.sleep();
  dt.log.i('预期结果4.数据库拉取成功6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.SQLLite打开数据库');

  await dt.sleep();
  dt.log.i('STEP 6.打开UriPermission表查看permission_type字段');

  await dt.sleep();
  dt.log.i('预期结果6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('三方应用-微博使用嵌入式picker选择相机录像的视频，视频单独授权 end');
}

/**
 * picker-视频: [三方应用-小红书使用嵌入式picker选择相机录像的视频，视频单独授权]
 * GROUP: picker MODULE: 视频TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_0900
 * 前置条件
 * 1.图库存在相机录像的视频
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED0900(dt: Dt) {
  dt.log.i('三方应用-小红书使用嵌入式picker选择相机录像的视频，视频单独授权 start');
  dt.log.i('STEP 1.点击小红书，点击+号');

  await dt.sleep();
  dt.log.i('STEP 2.点击图片按钮');

  await dt.sleep();
  dt.log.i('STEP 3.选择视频，点击下一步');

  await dt.sleep();
  dt.log.i('STEP 4.拉取数据库');

  await dt.sleep();
  dt.log.i('预期结果4.数据库拉取成功6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.SQLLite打开数据库');

  await dt.sleep();
  dt.log.i('STEP 6.打开UriPermission表查看permission_type字段');

  await dt.sleep();
  dt.log.i('预期结果6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('三方应用-小红书使用嵌入式picker选择相机录像的视频，视频单独授权 end');
}

/**
 * picker-视频: [系统应用-备忘录使用模态picker选择录屏保存的视频，视频单独授权]
 * GROUP: picker MODULE: 视频TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_1000
 * 前置条件
 * 1.图库存在录屏保存的视频
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1000(dt: Dt) {
  dt.log.i('系统应用-备忘录使用模态picker选择录屏保存的视频，视频单独授权 start');
  dt.log.i('STEP 1.点击备忘录，新建备忘录');

  await dt.sleep();
  dt.log.i('STEP 2.点击选择视频，勾选视频');

  await dt.sleep();
  dt.log.i('STEP 3.点击确定');

  await dt.sleep();
  dt.log.i('STEP 4.拉取数据库');

  await dt.sleep();
  dt.log.i('预期结果4.数据库拉取成功6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.SQLLite打开数据库');

  await dt.sleep();
  dt.log.i('STEP 6.打开UriPermission表查看permission_type字段');

  await dt.sleep();
  dt.log.i('预期结果6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('系统应用-备忘录使用模态picker选择录屏保存的视频，视频单独授权 end');
}

/**
 * picker-视频: [三方应用-微博使用嵌入式picker选择保存的视频，视频单独授权]
 * GROUP: picker MODULE: 视频TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_1100
 * 前置条件
 * 1.图库存在录屏保存的视频
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1100(dt: Dt) {
  dt.log.i('三方应用-微博使用嵌入式picker选择保存的视频，视频单独授权 start');
  dt.log.i('STEP 1.点击微博，点击+号');

  await dt.sleep();
  dt.log.i('STEP 2.点击图片按钮');

  await dt.sleep();
  dt.log.i('STEP 3.选择视频，点击下一步');

  await dt.sleep();
  dt.log.i('STEP 4.拉取数据库');

  await dt.sleep();
  dt.log.i('预期结果4.数据库拉取成功6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.SQLLite打开数据库');

  await dt.sleep();
  dt.log.i('STEP 6.打开UriPermission表查看permission_type字段');

  await dt.sleep();
  dt.log.i('预期结果6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('三方应用-微博使用嵌入式picker选择保存的视频，视频单独授权 end');
}

/**
 * picker-视频: [三方应用-小红书使用嵌入式picker选择保存的视频，视频单独授权]
 * GROUP: picker MODULE: 视频TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_AUTHORIZED_1200
 * 前置条件
 * 1.图库存在录屏保存的视频
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERAUTHORIZED1200(dt: Dt) {
  dt.log.i('三方应用-小红书使用嵌入式picker选择保存的视频，视频单独授权 start');
  dt.log.i('STEP 1.点击小红书，点击+号');

  await dt.sleep();
  dt.log.i('STEP 2.点击图片按钮');

  await dt.sleep();
  dt.log.i('STEP 3.选择视频，点击下一步');

  await dt.sleep();
  dt.log.i('STEP 4.拉取数据库');

  await dt.sleep();
  dt.log.i('预期结果4.数据库拉取成功6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.SQLLite打开数据库');

  await dt.sleep();
  dt.log.i('STEP 6.打开UriPermission表查看permission_type字段');

  await dt.sleep();
  dt.log.i('预期结果6.UriPermission表的permission_type字段值为1');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('三方应用-小红书使用嵌入式picker选择保存的视频，视频单独授权 end');
}

/**
 * picker-下载: [备忘录：新建备忘录]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASE_0100
 * 前置条件
 * 1、图库中存在未下载的云图
 2、图库中存在带有图片的相册
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASE0100(dt: Dt) {
  dt.log.i('备忘录：新建备忘录 start');
  dt.log.i('STEP 1、备忘录拉起picker，点击下方图片图标，选择图片拉起picker，宫格页滑动');

  await dt.sleep();
  dt.log.i('预期结果1、宫格页滑动流畅不掉帧，无白屏现象出现');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、滚动条滑动');

  await dt.sleep();
  dt.log.i('预期结果2、滚动条滑动流畅不掉帧，无白屏现象出现');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击缩略图进大图，大图预览界面点击编辑，进入编辑页面，编辑后保存');

  await dt.sleep();
  dt.log.i('预期结果3、大图预览界面点击编辑，正常进入编辑页面，编辑后的图片正常保存，正常显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、所有图片宫格页滑动多选');

  await dt.sleep();
  dt.log.i('预期结果4、宫格页滑动多选正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、所有相册页滑动多选');

  await dt.sleep();
  dt.log.i('预期结果5、相册页滑动多选正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、云图下载，图标显示');

  await dt.sleep();
  dt.log.i('预期结果6、云图正常下载，图标显示正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、勾选图片后点击确定');

  await dt.sleep();
  dt.log.i('预期结果7、勾选后点击确定的图片正常显示在新建备忘录中');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 8、所有图片切换相册页');

  await dt.sleep();
  dt.log.i('预期结果8、所有图片切换相册页，流畅不卡顿');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('备忘录：新建备忘录 end');
}