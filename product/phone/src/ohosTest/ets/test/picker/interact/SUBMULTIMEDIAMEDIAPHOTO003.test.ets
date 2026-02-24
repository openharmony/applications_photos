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

export default function SUBMULTIMEDIAMEDIAPHOTO003
(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('SUBMULTIMEDIAMEDIAPHOTO003' +
    'Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllSUBMULTIMEDIAMEDIAPHOTO003' +
        '').init();
      dt.log.i('beforeAll SUBMULTIMEDIAMEDIAPHOTO003' +
        ' start');
      dt.log.i('beforeAll SUBMULTIMEDIAMEDIAPHOTO003' +
        ' finish');
    });
    /**
     * 打开大图
     */
    run('beforeSUBMULTIMEDIAMEDIAPHOTO003' +
      '', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0217', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-进入大图用例: [PC端宫格选择样式验证] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0217
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0217(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0218', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [PC端拍照显示验证] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0218
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0218(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0222', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [PC端多选数量验证] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0222
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0222(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0223', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [PC端继承功能：动效验证] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0223
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0223(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0224', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-删除用例: [PC端继承功能：图库和picker中有相同图片，图库删除后验证] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0224
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0224(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0225', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-动态照片用例: [PC端继承功能：角标验证] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0225
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0225(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0226', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [PC端继承功能：多个应用拉起picker] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0226
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0226(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0227', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [PC端继承功能：关怀模式-大字体] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0227
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0227(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0228', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [继承功能：多语言切换] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0228
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0228(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0240', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [PC端键鼠：鼠标宫格框选] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0240
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0240(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0241', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [PC端键鼠：多选] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0241
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0241(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0244', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [PC端键鼠：浏览切换] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0244
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0244(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0245', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-进入大图用例: [PC端键鼠：返回宫格] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0245
      await SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0245(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERCLOUD0100', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [photoPicker云端媒体资源测试] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_CLOUD_0100
      await SUBMULTIMEDIAMEDIAPHOTOPICKERCLOUD0100(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERCLOUD0200', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [photoPicker云端媒体资源测试（反复取消下载）] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_CLOUD_0200
      await SUBMULTIMEDIAMEDIAPHOTOPICKERCLOUD0200(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERCLOUD0300', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [photoPicker云端媒体资源测试（下载时关闭应用）] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_CLOUD_0300
      await SUBMULTIMEDIAMEDIAPHOTOPICKERCLOUD0300(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERCLOUD0400', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [photoPicker云端媒体资源测试（下载时息屏）] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_CLOUD_0400
      await SUBMULTIMEDIAMEDIAPHOTOPICKERCLOUD0400(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERDTSE0100', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-用例: [DTSE-剪映多选重复照片] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_DTSE_0100
      await SUBMULTIMEDIAMEDIAPHOTOPICKERDTSE0100(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERDTSE0101', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-大图用例: [DTSE-美图秀秀大图查看checkbox] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_DTSE_0101
      await SUBMULTIMEDIAMEDIAPHOTOPICKERDTSE0101(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERDTSE0103', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-大图用例: [DTSE-美图秀秀退出大图动效] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_DTSE_0103
      await SUBMULTIMEDIAMEDIAPHOTOPICKERDTSE0103(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0100', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-用例: [相册列表组件增加图片过滤能力] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0100
      await SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0100(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0200', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [相册列表组件增加视频过滤能力] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0200
      await SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0200(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0300', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [相册列表组件增加图片+视频过滤能力] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0300
      await SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0300(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0400', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-用例: [空白区域回调使用方] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0400
      await SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0400(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachSUBMULTIMEDIAMEDIAPHOTO003' +
        '').init();
      dt.log.i('afterEach SUBMULTIMEDIAMEDIAPHOTO003' +
        ' start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach SUBMULTIMEDIAMEDIAPHOTO003' +
        ' finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllSUBMULTIMEDIAMEDIAPHOTO003' +
        '').init();
      dt.log.i('afterAll SUBMULTIMEDIAMEDIAPHOTO003' +
        ' start');
      await Exit.browser();
      dt.log.i('afterAll SUBMULTIMEDIAMEDIAPHOTO003' +
        ' finish');
    });
  });
}

// DT步骤
/**
 * picker-进入大图: [PC端宫格选择样式验证]
 * GROUP: picker MODULE: 进入大图TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0217
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0217(dt: Dt) {
  dt.log.i('PC端宫格选择样式验证 start');
  dt.log.i('STEP 1.demo拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2.点击一次宫格内的任意一张图片');

  await dt.sleep();
  dt.log.i('预期结果2.点击一次的图片被框选');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.再点击一次宫内其余的图片');

  await dt.sleep();
  dt.log.i('预期结果3.被点击一次的其余的图片也被框选');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.点击一次已经被点击过的一张图片');

  await dt.sleep();
  dt.log.i('预期结果4.进入大图');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端宫格选择样式验证 end');
}
/**
 * picker-下载: [PC端拍照显示验证]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0218
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0218(dt: Dt) {
  dt.log.i('PC端拍照显示验证 start');
  dt.log.i('STEP 1.demo拉起picker，查看图片和视频宫格页面');

  await dt.sleep();
  dt.log.i('预期结果1.有拍照组件');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.图库拉起picker，查看图片和视频宫格页面');

  await dt.sleep();
  dt.log.i('预期结果2.没有拍照组件');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端拍照显示验证 end');
}
/**
 * picker-下载: [PC端多选数量验证]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0222
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0222(dt: Dt) {
  dt.log.i('PC端多选数量验证 start');
  dt.log.i('STEP 1.demo拉起picker，选择分别1，500，501张');

  await dt.sleep();
  dt.log.i('预期结果1.选择1，500张时正常多选，选择第501张时弹出toast');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端多选数量验证 end');
}
/**
 * picker-下载: [PC端继承功能：动效验证]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0223
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0223(dt: Dt) {
  dt.log.i('PC端继承功能：动效验证 start');
  dt.log.i('STEP 1.相册切换');

  await dt.sleep();
  dt.log.i('预期结果1.切换动效正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.大图页面左右滑动');

  await dt.sleep();
  dt.log.i('预期结果2.左右滑动动效正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.相册进大图，大图返回动效');

  await dt.sleep();
  dt.log.i('预期结果3.相册进大图以及大图返回动效正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.宫格页滑动，滚动条滑动');

  await dt.sleep();
  dt.log.i('预期结果4.宫格页滑动以及滚动条滑动效正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端继承功能：动效验证 end');
}
/**
 * picker-删除: [PC端继承功能：图库和picker中有相同图片，图库删除后验证]
 * GROUP: picker MODULE: 删除TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0224
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源，如：图库中有图片a和图片b
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0224(dt: Dt) {
  dt.log.i('PC端继承功能：图库和picker中有相同图片，图库删除后验证 start');
  dt.log.i('STEP 1.demo拉起picker，picker宫格页面有图片a');

  await dt.sleep();
  dt.log.i('STEP 2.图库选择图片a进行删除后，返回demo宫格页面');

  await dt.sleep();
  dt.log.i('预期结果2.demo宫格页面对应的图片a被删除4.demo大图页面对应的图片b被删除，返回到宫格页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.demo大图页面有图片b');

  await dt.sleep();
  dt.log.i('STEP 4.图库选择图片b进行删除后，返回demo发图页面');

  await dt.sleep();
  dt.log.i('预期结果4.demo大图页面对应的图片b被删除，返回到宫格页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端继承功能：图库和picker中有相同图片，图库删除后验证 end');
}
/**
 * picker-动态照片: [PC端继承功能：角标验证]
 * GROUP: picker MODULE: 动态照片TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0225
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源，包含gif格式图片，动态照片，未下载的云图，有被收藏的图片
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0225(dt: Dt) {
  dt.log.i('PC端继承功能：角标验证 start');
  dt.log.i('STEP 1.demo拉起宫格页查看角标');

  await dt.sleep();
  dt.log.i('预期结果1.可以看到gif角标,动态照片角标，收藏的角标，未下载的云图角标');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.图片宫格页查看角标');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端继承功能：角标验证 end');
}
/**
 * picker-下载: [PC端继承功能：多个应用拉起picker]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0226
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0226(dt: Dt) {
  dt.log.i('PC端继承功能：多个应用拉起picker start');
  dt.log.i('STEP 1.demo拉起picker');

  await dt.sleep();
  dt.log.i('预期结果1.拉起picker正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.图库拉起picker');

  await dt.sleep();
  dt.log.i('预期结果2.拉起picker正常');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.备忘录拉起picker');

  await dt.sleep();
  dt.log.i('预期结果3.拉起picker正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.三者切换');

  await dt.sleep();
  dt.log.i('预期结果4.三者切换正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端继承功能：多个应用拉起picker end');
}
/**
 * picker-下载: [PC端继承功能：关怀模式-大字体]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0227
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 3.关怀模式-大字体调至最高级别
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0227(dt: Dt) {
  dt.log.i('PC端继承功能：关怀模式-大字体 start');
  dt.log.i('STEP 1.demo拉起picker，宫格页面，侧边栏，大图页面查看');

  await dt.sleep();
  dt.log.i('预期结果1.无截断等异常现象');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.图库拉起picker，宫格页面，侧边栏，大图页面查看');

  await dt.sleep();
  dt.log.i('预期结果2.无截断等异常现象');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端继承功能：关怀模式-大字体 end');
}
/**
 * picker-下载: [继承功能：多语言切换]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0228
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源

 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0228(dt: Dt) {
  dt.log.i('继承功能：多语言切换 start');
  dt.log.i('STEP 1.切换为维吾尔文');

  await dt.sleep();
  dt.log.i('STEP 2.demo拉起picker，宫格页，大图页查看；图库拉起picker，宫格页，大图页查看');

  await dt.sleep();
  dt.log.i('预期结果2.demo拉起的picker宫格页，大图页语言文字正确，图库拉起的picker，宫格页，大图页语言文字正确4.demo拉起的picker宫格页，大图页语言文字正确，图库拉起的picker，宫格页，大图页语言文字正确6.demo拉起的picker宫格页，大图页语言文字正确，图库拉起的picker，宫格页，大图页语言文字正确8.demo拉起的picker宫格页，大图页语言文字正确，图库拉起的picker，宫格页，大图页语言文字正确');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.切换为英文');

  await dt.sleep();
  dt.log.i('STEP 4.demo拉起picker，宫格页，大图页查看；图库拉起picker，宫格页，大图页查看');

  await dt.sleep();
  dt.log.i('预期结果4.demo拉起的picker宫格页，大图页语言文字正确，图库拉起的picker，宫格页，大图页语言文字正确6.demo拉起的picker宫格页，大图页语言文字正确，图库拉起的picker，宫格页，大图页语言文字正确8.demo拉起的picker宫格页，大图页语言文字正确，图库拉起的picker，宫格页，大图页语言文字正确');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.切换为藏文');

  await dt.sleep();
  dt.log.i('STEP 6.demo拉起picker，宫格页，大图页查看；图库拉起picker，宫格页，大图页查看');

  await dt.sleep();
  dt.log.i('预期结果6.demo拉起的picker宫格页，大图页语言文字正确，图库拉起的picker，宫格页，大图页语言文字正确8.demo拉起的picker宫格页，大图页语言文字正确，图库拉起的picker，宫格页，大图页语言文字正确');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7.切换为中文繁体');

  await dt.sleep();
  dt.log.i('STEP 8.demo拉起picker，宫格页，大图页查看；图库拉起picker，宫格页，大图页查看');

  await dt.sleep();
  dt.log.i('预期结果8.demo拉起的picker宫格页，大图页语言文字正确，图库拉起的picker，宫格页，大图页语言文字正确');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('继承功能：多语言切换 end');
}
/**
 * picker-下载: [PC端键鼠：鼠标宫格框选]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0240
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0240(dt: Dt) {
  dt.log.i('PC端键鼠：鼠标宫格框选 start');
  dt.log.i('STEP 1.demo拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2.手动拖动，缩放');

  await dt.sleep();
  dt.log.i('预期结果2.无法被拖动，无法缩放，位置固定');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端键鼠：鼠标宫格框选 end');
}
/**
 * picker-下载: [PC端键鼠：多选]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0241
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0241(dt: Dt) {
  dt.log.i('PC端键鼠：多选 start');
  dt.log.i('STEP 1.大图宫格页');

  await dt.sleep();
  dt.log.i('STEP 2.按住ctrl按住，鼠标/点击选择多个图片');

  await dt.sleep();
  dt.log.i('预期结果2.可以多选');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.shift按住时，鼠标点击选择两次点击中间的所有图片、视频');

  await dt.sleep();
  dt.log.i('预期结果3.可以多选');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.不选择按住shift/ctrl');

  await dt.sleep();
  dt.log.i('预期结果4.无任何反应');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端键鼠：多选 end');
}
/**
 * picker-下载: [PC端键鼠：浏览切换]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0244
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0244(dt: Dt) {
  dt.log.i('PC端键鼠：浏览切换 start');
  dt.log.i('STEP 1.大图浏览界面选择一张照片进大图');

  await dt.sleep();
  dt.log.i('STEP 2.page up ');

  await dt.sleep();
  dt.log.i('预期结果2，切换上一张进行浏览');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.page down');

  await dt.sleep();
  dt.log.i('预期结果3.切换后一张进行浏览');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端键鼠：浏览切换 end');
}
/**
 * picker-进入大图: [PC端键鼠：返回宫格]
 * GROUP: picker MODULE: 进入大图TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_BASECASECONNECT_0245
 * 前置条件
 * 1.下载pc的对应demo
 2.图库内有视频以及图片资源
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERBASECASECONNECT0245(dt: Dt) {
  dt.log.i('PC端键鼠：返回宫格 start');
  dt.log.i('STEP 1.进入大图页面');

  await dt.sleep();
  dt.log.i('STEP 2.按space键');

  await dt.sleep();
  dt.log.i('预期结果2.返回上级页面4.返回上级页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.进入大图页面');

  await dt.sleep();
  dt.log.i('STEP 4.按esc键');

  await dt.sleep();
  dt.log.i('预期结果4.返回上级页面');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('PC端键鼠：返回宫格 end');
}
/**
 * picker-下载: [photoPicker云端媒体资源测试]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_CLOUD_0100
 * 前置条件
 * 1、图库上有云端未下载到本地的图片与视频
 2、图库上有本地的图片与视频
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERCLOUD0100(dt: Dt) {
  dt.log.i('photoPicker云端媒体资源测试 start');
  dt.log.i('STEP 1、打开图库，新建一个相册');

  await dt.sleep();
  dt.log.i('STEP 2、打开相册，点击新增图片/视频按钮');

  await dt.sleep();
  dt.log.i('预期结果2、云端媒体资源（未下载到本地）上有云端标识');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击一张云端资源图片和点击一个云端视频文件。');

  await dt.sleep();
  dt.log.i('预期结果3、点击云端媒体文件后，云端标识符消失，显示下载进度条。下载完成后，该资源上没有云端标识符和进度条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、选中刚下载的云端媒体文件和本地图片与视频，点击完成');

  await dt.sleep();
  dt.log.i('预期结果4、相册中新增刚刚选中的媒体文件');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、点击相册中刚刚新增的图片/视频');

  await dt.sleep();
  dt.log.i('预期结果5、图片能正常显示，视频能正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('photoPicker云端媒体资源测试 end');
}
/**
 * picker-下载: [photoPicker云端媒体资源测试（反复取消下载）]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_CLOUD_0200
 * 前置条件
 * 1、图库上有云端未下载到本地的图片与视频
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERCLOUD0200(dt: Dt) {
  dt.log.i('photoPicker云端媒体资源测试（反复取消下载） start');
  dt.log.i('STEP 1、打开图库，新建一个相册');

  await dt.sleep();
  dt.log.i('STEP 2、打开相册，点击新增图片/视频按钮');

  await dt.sleep();
  dt.log.i('预期结果2、云端媒体资源（未下载到本地）上有云端标识');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、反复点击一个较大云端视频文件十次');

  await dt.sleep();
  dt.log.i('预期结果3、该视频文件正常下载和取消下载');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、点击该云端视频文件后等待下载完成');

  await dt.sleep();
  dt.log.i('预期结果4、该视频文件能正常完成下载');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、选中刚刚下载的视频文件，点击完成');

  await dt.sleep();
  dt.log.i('预期结果5、相册中显示刚刚下载的视频文件');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、点击相册中刚刚新增的图片/视频');

  await dt.sleep();
  dt.log.i('预期结果6、视频能正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('photoPicker云端媒体资源测试（反复取消下载） end');
}
/**
 * picker-下载: [photoPicker云端媒体资源测试（下载时关闭应用）]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_CLOUD_0300
 * 前置条件
 * 1、图库上有云端未下载到本地的图片与视频
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERCLOUD0300(dt: Dt) {
  dt.log.i('photoPicker云端媒体资源测试（下载时关闭应用） start');
  dt.log.i('STEP 1、打开图库，新建一个相册');

  await dt.sleep();
  dt.log.i('STEP 2、打开相册，点击新增图片/视频按钮');

  await dt.sleep();
  dt.log.i('预期结果2、云端媒体资源（未下载到本地）上有云端标识');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击一张云端资源图片和点击一个云端视频文件。');

  await dt.sleep();
  dt.log.i('预期结果3、点击的云端媒体资源开始下载5、刚刚点击的媒体资源处于下载状态或下载完成6、相册中显示刚刚下载的视频文件和图片7、图片能正常显示，视频能正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、关闭图库应用');

  await dt.sleep();
  dt.log.i('STEP 5、打开图库，重复步骤1-2');

  await dt.sleep();
  dt.log.i('预期结果5、刚刚点击的媒体资源处于下载状态或下载完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、选中刚刚下载的视频和图片，点击完成');

  await dt.sleep();
  dt.log.i('预期结果6、相册中显示刚刚下载的视频文件和图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、点击相册中刚刚新增的图片/视频');

  await dt.sleep();
  dt.log.i('预期结果7、图片能正常显示，视频能正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('photoPicker云端媒体资源测试（下载时关闭应用） end');
}
/**
 * picker-下载: [photoPicker云端媒体资源测试（下载时息屏）]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_CLOUD_0400
 * 前置条件
 * 1、图库上有云端未下载到本地的图片与视频
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERCLOUD0400(dt: Dt) {
  dt.log.i('photoPicker云端媒体资源测试（下载时息屏） start');
  dt.log.i('STEP 1、打开图库，新建一个相册');

  await dt.sleep();
  dt.log.i('STEP 2、打开相册，点击新增图片/视频按钮');

  await dt.sleep();
  dt.log.i('预期结果2、云端媒体资源（未下载到本地）上有云端标识');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、点击一张云端资源图片和点击一个云端视频文件。');

  await dt.sleep();
  dt.log.i('预期结果3、点击的云端媒体资源开始下载5、刚刚点击的媒体资源处于下载状态或下载完成6、相册中显示刚刚下载的视频和图片7、图片能正常显示，视频能正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、息屏');

  await dt.sleep();
  dt.log.i('STEP 5、亮屏');

  await dt.sleep();
  dt.log.i('预期结果5、刚刚点击的媒体资源处于下载状态或下载完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、选中刚刚下载的视频和图片，点击完成');

  await dt.sleep();
  dt.log.i('预期结果6、相册中显示刚刚下载的视频和图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、点击相册中刚刚新增的图片/视频');

  await dt.sleep();
  dt.log.i('预期结果7、图片能正常显示，视频能正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('photoPicker云端媒体资源测试（下载时息屏） end');
}
/**
 * picker-: [DTSE-剪映多选重复照片]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_DTSE_0100
 * 前置条件
 * 1、图库中存在图片
 2、安装剪映demo
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERDTSE0100(dt: Dt) {
  dt.log.i('DTSE-剪映多选重复照片 start');
  dt.log.i('STEP 1、点击剪映demo');

  await dt.sleep();
  dt.log.i('STEP 2、反复勾选两张相同的图片');

  await dt.sleep();
  dt.log.i('预期结果2、checkbox角标正常更新+1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('DTSE-剪映多选重复照片 end');
}
/**
 * picker-大图: [DTSE-美图秀秀大图查看checkbox]
 * GROUP: picker MODULE: 大图TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_DTSE_0101
 * 前置条件
 * 1、图库中存在图片
 2、安装美图秀秀demo
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERDTSE0101(dt: Dt) {
  dt.log.i('DTSE-美图秀秀大图查看checkbox start');
  dt.log.i('STEP 1、点击美图秀秀demo，进入多选模式');

  await dt.sleep();
  dt.log.i('STEP 2、勾选多张图片进入大图');

  await dt.sleep();
  dt.log.i('预期结果2、大图预览页图片下角标正常显示序号');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('DTSE-美图秀秀大图查看checkbox end');
}
/**
 * picker-大图: [DTSE-美图秀秀退出大图动效]
 * GROUP: picker MODULE: 大图TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_DTSE_0103
 * 前置条件
 * 1、图库中存在图片
 2、安装美图秀秀demo
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERDTSE0103(dt: Dt) {
  dt.log.i('DTSE-美图秀秀退出大图动效 start');
  dt.log.i('STEP 1、点击美图秀秀demo');

  await dt.sleep();
  dt.log.i('STEP 2、点击图片进入大图');

  await dt.sleep();
  dt.log.i('STEP 3、点击返回退出大图');

  await dt.sleep();
  dt.log.i('预期结果3、大图退出动效正常');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('DTSE-美图秀秀退出大图动效 end');
}
/**
 * picker-: [相册列表组件增加图片过滤能力]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0100
 * 前置条件
 * 1、图库存在图片资源文件
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0100(dt: Dt) {
  dt.log.i('相册列表组件增加图片过滤能力 start');
  dt.log.i('STEP 1、安装demo');

  await dt.sleep();
  dt.log.i('STEP 2、打开demo，点击图片文件按钮');

  await dt.sleep();
  dt.log.i('预期结果2、图库picker页面中的相册列表只显示存在图片的相册，并且统计的数量仅仅只为图片的数量，宫格页只展示图片');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册列表组件增加图片过滤能力 end');
}
/**
 * picker-视频: [相册列表组件增加视频过滤能力]
 * GROUP: picker MODULE: 视频TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0200
 * 前置条件
 * 1、图库存在视频资源文件
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0200(dt: Dt) {
  dt.log.i('相册列表组件增加视频过滤能力 start');
  dt.log.i('STEP 1、安装demo');

  await dt.sleep();
  dt.log.i('STEP 2、打开demo，点击视频文件按钮');

  await dt.sleep();
  dt.log.i('预期结果2、图库picker页面中的相册列表只显示存在视频的相册，并且统计的数量仅仅只为视频的数量，宫格页只展示视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册列表组件增加视频过滤能力 end');
}
/**
 * picker-视频: [相册列表组件增加图片+视频过滤能力]
 * GROUP: picker MODULE: 视频TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0300
 * 前置条件
 * 1、图库存在图片以及视频资源文件
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0300(dt: Dt) {
  dt.log.i('相册列表组件增加图片+视频过滤能力 start');
  dt.log.i('STEP 1、安装demo');

  await dt.sleep();
  dt.log.i('STEP 2、打开demo，点击图片和视频文件按钮');

  await dt.sleep();
  dt.log.i('预期结果2、图库picker页面中的相册列表显示全部相册，并且统计的数量是图片+视频的数量，宫格页展示图片+视频');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册列表组件增加图片+视频过滤能力 end');
}
/**
 * picker-: [空白区域回调使用方]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0400
 * 前置条件
 * 1、图库存在相册，且相册中存在资源文件，相册未铺满手机屏幕
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0400(dt: Dt) {
  dt.log.i('空白区域回调使用方 start');
  dt.log.i('STEP 1、安装demo');

  await dt.sleep();
  dt.log.i('STEP 2、打开demo，点击空白区域');

  await dt.sleep();
  dt.log.i('预期结果2、日志中存在回调：关键日志：onEmptyAreaClick');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('空白区域回调使用方 end');
}