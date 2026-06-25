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

export default function SUBMULTIMEDIAMEDIAPHOTO004(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('SUBMULTIMEDIAMEDIAPHOTO004Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllSUBMULTIMEDIAMEDIAPHOTO004').init();
      dt.log.i('beforeAll SUBMULTIMEDIAMEDIAPHOTO004 start');
      dt.log.i('beforeAll SUBMULTIMEDIAMEDIAPHOTO004 finish');
    });
    /**
     * 打开大图
     */
    run('beforeSUBMULTIMEDIAMEDIAPHOTO004', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0500', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-删除用例: [图库与三方应用相册列表动态联动] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0500
      await SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0500(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0600', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-删除用例: [图库与三方应用图片宫格页动态联动，图片已勾选] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0600
      await SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0600(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0700', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-删除用例: [图库与三方应用图片宫格页动态联动，图片未勾选] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0700
      await SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0700(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0800', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [pickerview可选最大数量回调三方-最大限制9张] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0800
      await SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0800(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0900', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [pickerview可选最大数量回调三方-最大限制99张] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0900
      await SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0900(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW1000', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-用例: [最近照片新增返回图片信息接口(60秒之内的图片)-RecentPhotoCheckInfoCallback] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_1000
      await SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW1000(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW1100', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [最近照片新增返回图片信息接口(60秒之内的视频)-RecentPhotoCheckInfoCallback] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_1100
      await SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW1100(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW1200', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-用例: [最近照片新增返回图片信息接口(最新的图片)-RecentPhotoCheckInfoCallback] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_1200
      await SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW1200(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW1300', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [最近照片新增返回图片信息接口(最新的视频)-RecentPhotoCheckInfoCallback] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_1300
      await SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW1300(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0100', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-滑动用例: [微信-滑动多选-朋友圈最大限制选择10张的场景] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0100
      await SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0100(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0200', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-滑动用例: [微信-滑动多选-聊天最大限制选择99张的场景] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0200
      await SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0200(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0300', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-大图用例: [微信-支持自定义checkbox位置与显隐，按钮显示且位于大图中间] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0300
      await SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0300(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0400', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-大图用例: [微信-支持自定义checkbox位置与显隐，按钮不显示] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0400
      await SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0400(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0500', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进入大图用例: [微信-支持返回按钮显隐，按钮显示] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0500
      await SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0500(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0600', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进入大图用例: [微信-支持返回按钮显隐，按钮功能测试] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0600
      await SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0600(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0700', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进入大图用例: [微信-支持返回按钮显隐，按钮隐藏] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0700
      await SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0700(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0800', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进入大图用例: [微信-勾选多张图片，点击预览按钮进入大图，大图左右滑动，下方缩略图跟随联动] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0800
      await SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0800(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0900', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进入大图用例: [微信-勾选多张图片，点击预览按钮进入大图，大图左右滑动范围仅为选中图片] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0900
      await SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0900(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT1000', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进入大图用例: [微信-勾选多张图片，点击预览按钮进入大图，点击缩略图，大图跟随联动显示] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_1000
      await SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT1000(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT1100', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进入大图用例: [微信-勾选多张图片，点击图片进入大图，滑动范围是全部的图片] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_1100
      await SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT1100(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTORELIABLE0100', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-用例: [图库picker-拉起picker后，杀掉picker进程，重新拉起查看是否可以正常拉起] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_RELIABLE_0100
      await SUBMULTIMEDIAMEDIAPHOTORELIABLE0100(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0100', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-锁屏用例: [图库picker-锁屏场景-小艺视觉-识文] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_SECURITYPRIVACY_0100
      await SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0100(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0101', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-锁屏用例: [图库picker-锁屏场景-小艺视觉-翻译] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_SECURITYPRIVACY_0101
      await SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0101(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0102', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-锁屏用例: [图库picker-锁屏场景-小艺视觉-扫一扫] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_SECURITYPRIVACY_0102
      await SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0102(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0103', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-锁屏用例: [图库picker-锁屏场景-小艺视觉-扫描] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_SECURITYPRIVACY_0103
      await SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0103(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0104', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-用例: [图库picker-安全访问图库提示-半模态picker] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_SECURITYPRIVACY_0104
      await SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0104(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0105', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-用例: [图库picker-安全访问图库提示-PickerComponent] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_SECURITYPRIVACY_0105
      await SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0105(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOSTABILITY0100', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-滑动用例: [图库picker-宫格页滑动MTBF测试] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_STABILITY_0100
      await SUBMULTIMEDIAMEDIAPHOTOSTABILITY0100(dt);
    });
    run('SUBMULTIMEDIAMEDIAPHOTOSTABILITY0101', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-大图用例: [图库picker-进/退大图MTBF测试] TID: SUB_MULTIMEDIA_MEDIA_PHOTO_STABILITY_0101
      await SUBMULTIMEDIAMEDIAPHOTOSTABILITY0101(dt);
    });
    run('SUBMULTIMEDIAMEDIAPICKERVIEWCLOUD0100', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [photoView云端媒体资源测试] TID: SUB_MULTIMEDIA_MEDIA_PICKER_VIEW_CLOUD_0100
      await SUBMULTIMEDIAMEDIAPICKERVIEWCLOUD0100(dt);
    });
    run('SUBMULTIMEDIAMEDIAPICKERVIEWCLOUD0200', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [photoView云端媒体资源测试（反复取消下载）] TID: SUB_MULTIMEDIA_MEDIA_PICKER_VIEW_CLOUD_0200
      await SUBMULTIMEDIAMEDIAPICKERVIEWCLOUD0200(dt);
    });
    run('SUBMULTIMEDIAMEDIAPICKERVIEWCLOUD0300', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [photoView云端媒体资源测试（下载时关闭应用）] TID: SUB_MULTIMEDIA_MEDIA_PICKER_VIEW_CLOUD_0300
      await SUBMULTIMEDIAMEDIAPICKERVIEWCLOUD0300(dt);
    });
    run('SUBMULTIMEDIAMEDIAPICKERVIEWCLOUD0400', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [photoView云端媒体资源测试（下载时息屏）] TID: SUB_MULTIMEDIA_MEDIA_PICKER_VIEW_CLOUD_0400
      await SUBMULTIMEDIAMEDIAPICKERVIEWCLOUD0400(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachSUBMULTIMEDIAMEDIAPHOTO004').init();
      dt.log.i('afterEach SUBMULTIMEDIAMEDIAPHOTO004 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach SUBMULTIMEDIAMEDIAPHOTO004 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllSUBMULTIMEDIAMEDIAPHOTO004').init();
      dt.log.i('afterAll SUBMULTIMEDIAMEDIAPHOTO004 start');
      await Exit.browser();
      dt.log.i('afterAll SUBMULTIMEDIAMEDIAPHOTO004 finish');
    });
  });
}

// DT步骤
/**
 * picker-删除: [图库与三方应用相册列表动态联动]
 * GROUP: picker MODULE: 删除TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0500
 * 前置条件
 * 1、图库存在相册，且相册中存在资源文件
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0500(dt: Dt) {
  dt.log.i('图库与三方应用相册列表动态联动 start');
  dt.log.i('STEP 1、安装demo');

  await dt.sleep();
  dt.log.i('STEP 2、打开demo，查看相册列表');

  await dt.sleep();
  dt.log.i('预期结果2、相册列表中存在新建相册24、删除相册成功6、相册列表中已经不存在新建相册2');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、demo退后台，点击图库，打开图库');

  await dt.sleep();
  dt.log.i('STEP 4、删除新建相册2，图库退后台');

  await dt.sleep();
  dt.log.i('预期结果4、删除相册成功6、相册列表中已经不存在新建相册2');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、打开demo，查看相册列表');

  await dt.sleep();
  dt.log.i('预期结果6、相册列表中已经不存在新建相册2');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库与三方应用相册列表动态联动 end');
}
/**
 * picker-删除: [图库与三方应用图片宫格页动态联动，图片已勾选]
 * GROUP: picker MODULE: 删除TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0600
 * 前置条件
 * 1、图库中存在图片资源文件-图片已勾选
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0600(dt: Dt) {
  dt.log.i('图库与三方应用图片宫格页动态联动，图片已勾选 start');
  dt.log.i('STEP 1、安装demo');

  await dt.sleep();
  dt.log.i('STEP 2、打开demo，点击图片相册');

  await dt.sleep();
  dt.log.i('STEP 3、勾选前三张图片');

  await dt.sleep();
  dt.log.i('STEP 4、demo退后台，点击图库，打开图库');

  await dt.sleep();
  dt.log.i('预期结果4、删除图片成功6、图片宫格页已勾选的三张图片已消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、删除已勾选的三张图片，图库退后台');

  await dt.sleep();
  dt.log.i('STEP 6、打开demo，查看图片宫格页');

  await dt.sleep();
  dt.log.i('预期结果6、图片宫格页已勾选的三张图片已消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库与三方应用图片宫格页动态联动，图片已勾选 end');
}
/**
 * picker-删除: [图库与三方应用图片宫格页动态联动，图片未勾选]
 * GROUP: picker MODULE: 删除TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0700
 * 前置条件
 * 1、图库中存在图片资源文件-图片未勾选
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0700(dt: Dt) {
  dt.log.i('图库与三方应用图片宫格页动态联动，图片未勾选 start');
  dt.log.i('STEP 1、安装demo');

  await dt.sleep();
  dt.log.i('STEP 2、打开demo，点击图片相册');

  await dt.sleep();
  dt.log.i('STEP 3、demo退后台，点击图库，打开图库');

  await dt.sleep();
  dt.log.i('STEP 4、删除前三张图片，图库退后台');

  await dt.sleep();
  dt.log.i('预期结果4、删除图片成功6、图片宫格页图库中删除的三张图片已消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、打开demo，查看图片宫格页');

  await dt.sleep();
  dt.log.i('预期结果6、图片宫格页图库中删除的三张图片已消失');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库与三方应用图片宫格页动态联动，图片未勾选 end');
}
/**
 * picker-视频: [pickerview可选最大数量回调三方-最大限制9张]
 * GROUP: picker MODULE: 视频TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0800
 * 前置条件
 * 1、图库中存在图片以及视频资源文件

 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0800(dt: Dt) {
  dt.log.i('pickerview可选最大数量回调三方-最大限制9张 start');
  dt.log.i('STEP 1、微信朋友圈拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2、点击勾选图片和视频');

  await dt.sleep();
  dt.log.i('STEP 3、勾选到最大值为9，再次勾选图片或视频');

  await dt.sleep();
  dt.log.i('预期结果3.最多可勾选数量为9，超过9张弹出toast');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('pickerview可选最大数量回调三方-最大限制9张 end');
}
/**
 * picker-视频: [pickerview可选最大数量回调三方-最大限制99张]
 * GROUP: picker MODULE: 视频TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_0900
 * 前置条件
 * 1、图库中存在图片以及视频资源文件

 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW0900(dt: Dt) {
  dt.log.i('pickerview可选最大数量回调三方-最大限制99张 start');
  dt.log.i('STEP 1、微信好友发信息界面，+号拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2、点击勾选图片和视频');

  await dt.sleep();
  dt.log.i('STEP 3、勾选到最大值为99，再次勾选图片或视频');

  await dt.sleep();
  dt.log.i('预期结果3.最多勾选99张，第100张弹toast');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('pickerview可选最大数量回调三方-最大限制99张 end');
}
/**
 * picker-: [最近照片新增返回图片信息接口(60秒之内的图片)-RecentPhotoCheckInfoCallback]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_1000
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW1000(dt: Dt) {
  dt.log.i('最近照片新增返回图片信息接口(60秒之内的图片)-RecentPhotoCheckInfoCallback start');
  dt.log.i('STEP 1、相册中存在60秒内新增的图片');

  await dt.sleep();
  dt.log.i('STEP 2、安装demo，打开demo');

  await dt.sleep();
  dt.log.i('STEP 3、点击获取60秒图片按钮');

  await dt.sleep();
  dt.log.i('预期结果3、demo页面可正常查看到接口返回的该图片的dataTaken以及identifier');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近照片新增返回图片信息接口(60秒之内的图片)-RecentPhotoCheckInfoCallback end');
}
/**
 * picker-视频: [最近照片新增返回图片信息接口(60秒之内的视频)-RecentPhotoCheckInfoCallback]
 * GROUP: picker MODULE: 视频TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_1100
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW1100(dt: Dt) {
  dt.log.i('最近照片新增返回图片信息接口(60秒之内的视频)-RecentPhotoCheckInfoCallback start');
  dt.log.i('STEP 1、相册中存在60秒内新增的视频');

  await dt.sleep();
  dt.log.i('STEP 2、安装demo，打开demo');

  await dt.sleep();
  dt.log.i('STEP 3、点击获取60秒视频按钮');

  await dt.sleep();
  dt.log.i('预期结果3、demo页面可正常查看到接口返回的该视频的dataTaken以及identifier');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近照片新增返回图片信息接口(60秒之内的视频)-RecentPhotoCheckInfoCallback end');
}
/**
 * picker-: [最近照片新增返回图片信息接口(最新的图片)-RecentPhotoCheckInfoCallback]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_1200
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW1200(dt: Dt) {
  dt.log.i('最近照片新增返回图片信息接口(最新的图片)-RecentPhotoCheckInfoCallback start');
  dt.log.i('STEP 1、相册中存在新增的图片');

  await dt.sleep();
  dt.log.i('STEP 2、安装demo，打开demo');

  await dt.sleep();
  dt.log.i('STEP 3、点击获取最新图片按钮');

  await dt.sleep();
  dt.log.i('预期结果3、demo页面可正常查看到接口返回的该图片的dataTaken以及identifier');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近照片新增返回图片信息接口(最新的图片)-RecentPhotoCheckInfoCallback end');
}
/**
 * picker-视频: [最近照片新增返回图片信息接口(最新的视频)-RecentPhotoCheckInfoCallback]
 * GROUP: picker MODULE: 视频TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_VIEW_1300
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERVIEW1300(dt: Dt) {
  dt.log.i('最近照片新增返回图片信息接口(最新的视频)-RecentPhotoCheckInfoCallback start');
  dt.log.i('STEP 1、相册中存在新增的视频');

  await dt.sleep();
  dt.log.i('STEP 2、安装demo，打开demo');

  await dt.sleep();
  dt.log.i('STEP 3、点击获取最新视频按钮');

  await dt.sleep();
  dt.log.i('预期结果3、demo页面可正常查看到接口返回的该视频的dataTaken以及identifier');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近照片新增返回图片信息接口(最新的视频)-RecentPhotoCheckInfoCallback end');
}
/**
 * picker-滑动: [微信-滑动多选-朋友圈最大限制选择10张的场景]
 * GROUP: picker MODULE: 滑动TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0100
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0100(dt: Dt) {
  dt.log.i('微信-滑动多选-朋友圈最大限制选择10张的场景 start');
  dt.log.i('STEP 1.登录微信');

  await dt.sleep();
  dt.log.i('STEP 2.进入朋友圈，调起picker view');

  await dt.sleep();
  dt.log.i('STEP 3.宫格页滑动进行图片多选-限制9张图片');

  await dt.sleep();
  dt.log.i('预期结果3.滑动选中的图片正常被勾选-限制9张图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('微信-滑动多选-朋友圈最大限制选择10张的场景 end');
}
/**
 * picker-滑动: [微信-滑动多选-聊天最大限制选择99张的场景]
 * GROUP: picker MODULE: 滑动TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0200
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0200(dt: Dt) {
  dt.log.i('微信-滑动多选-聊天最大限制选择99张的场景 start');
  dt.log.i('STEP 1.登录微信');

  await dt.sleep();
  dt.log.i('STEP 2.选择一个好友进入聊天界面');

  await dt.sleep();
  dt.log.i('STEP 3.调起picker view');

  await dt.sleep();
  dt.log.i('STEP 4.宫格页滑动进行图片多选-限制99张图片');

  await dt.sleep();
  dt.log.i('预期结果4.滑动选中的图片正常被勾选-限制99张图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('微信-滑动多选-聊天最大限制选择99张的场景 end');
}
/**
 * picker-大图: [微信-支持自定义checkbox位置与显隐，按钮显示且位于大图中间]
 * GROUP: picker MODULE: 大图TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0300
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0300(dt: Dt) {
  dt.log.i('微信-支持自定义checkbox位置与显隐，按钮显示且位于大图中间 start');
  dt.log.i('STEP 1.下载微信并登录');

  await dt.sleep();
  dt.log.i('STEP 2.选择一个好友进入聊天界面');

  await dt.sleep();
  dt.log.i('STEP 3.点击加号照片调起picker');

  await dt.sleep();
  dt.log.i('预期结果3.调起picker view宫格界面5.下方中间有checkbox按钮');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.宫格点击图片缩略图进大图');

  await dt.sleep();
  dt.log.i('预期结果5.下方中间有checkbox按钮');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('微信-支持自定义checkbox位置与显隐，按钮显示且位于大图中间 end');
}
/**
 * picker-大图: [微信-支持自定义checkbox位置与显隐，按钮不显示]
 * GROUP: picker MODULE: 大图TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0400
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0400(dt: Dt) {
  dt.log.i('微信-支持自定义checkbox位置与显隐，按钮不显示 start');
  dt.log.i('STEP 1.登录微信');

  await dt.sleep();
  dt.log.i('STEP 2.发现-朋友圈');

  await dt.sleep();
  dt.log.i('STEP 3.点击相机，从相册选择');

  await dt.sleep();
  dt.log.i('STEP 4.点击任意一张图片缩略图进大图');

  await dt.sleep();
  dt.log.i('STEP 5.点击图片展示区域');

  await dt.sleep();
  dt.log.i('预期结果5.checkbox复选框被隐藏');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('微信-支持自定义checkbox位置与显隐，按钮不显示 end');
}
/**
 * picker-进入大图: [微信-支持返回按钮显隐，按钮显示]
 * GROUP: picker MODULE: 进入大图TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0500
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0500(dt: Dt) {
  dt.log.i('微信-支持返回按钮显隐，按钮显示 start');
  dt.log.i('STEP 1.点击demo User.hap');

  await dt.sleep();
  dt.log.i('STEP 2.宫格页点击图片，进入大图，查看按钮是否显示');

  await dt.sleep();
  dt.log.i('预期结果2.大图界面顶端出现返回按钮');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('微信-支持返回按钮显隐，按钮显示 end');
}
/**
 * picker-进入大图: [微信-支持返回按钮显隐，按钮功能测试]
 * GROUP: picker MODULE: 进入大图TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0600
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0600(dt: Dt) {
  dt.log.i('微信-支持返回按钮显隐，按钮功能测试 start');
  dt.log.i('STEP 1.点击demo User.hap');

  await dt.sleep();
  dt.log.i('STEP 2.宫格页点击图片，进入大图');

  await dt.sleep();
  dt.log.i('预期结果2.大图界面顶端出现返回按钮');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击按钮');

  await dt.sleep();
  dt.log.i('预期结果3.大图退出');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('微信-支持返回按钮显隐，按钮功能测试 end');
}
/**
 * picker-进入大图: [微信-支持返回按钮显隐，按钮隐藏]
 * GROUP: picker MODULE: 进入大图TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0700
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0700(dt: Dt) {
  dt.log.i('微信-支持返回按钮显隐，按钮隐藏 start');
  dt.log.i('STEP 1.点击demo User.hap');

  await dt.sleep();
  dt.log.i('STEP 2.宫格页点击图片，进入大图');

  await dt.sleep();
  dt.log.i('预期结果2.大图界面未出现返回按钮');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('微信-支持返回按钮显隐，按钮隐藏 end');
}
/**
 * picker-进入大图: [微信-勾选多张图片，点击预览按钮进入大图，大图左右滑动，下方缩略图跟随联动]
 * GROUP: picker MODULE: 进入大图TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0800
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0800(dt: Dt) {
  dt.log.i('微信-勾选多张图片，点击预览按钮进入大图，大图左右滑动，下方缩略图跟随联动 start');
  dt.log.i('STEP 1.点击demo User.hap');

  await dt.sleep();
  dt.log.i('STEP 2.宫格页勾选多张图片');

  await dt.sleep();
  dt.log.i('预期结果2.宫格页底部出现当前已选中图片的图略图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击预览');

  await dt.sleep();
  dt.log.i('预期结果3.大图页面底部当前正在预览图片的缩略图出现高亮框');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.大图页左右滑动');

  await dt.sleep();
  dt.log.i('预期结果4.下方缩略图跟随大图联动显示高亮框');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('微信-勾选多张图片，点击预览按钮进入大图，大图左右滑动，下方缩略图跟随联动 end');
}
/**
 * picker-进入大图: [微信-勾选多张图片，点击预览按钮进入大图，大图左右滑动范围仅为选中图片]
 * GROUP: picker MODULE: 进入大图TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_0900
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT0900(dt: Dt) {
  dt.log.i('微信-勾选多张图片，点击预览按钮进入大图，大图左右滑动范围仅为选中图片 start');
  dt.log.i('STEP 1.点击demo User.hap');

  await dt.sleep();
  dt.log.i('STEP 2.宫格页勾选多张图片');

  await dt.sleep();
  dt.log.i('预期结果2.宫格页底部出现当前已选中图片的图略图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击预览');

  await dt.sleep();
  dt.log.i('预期结果3.大图页面底部当前正在预览图片的缩略图出现高亮框');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.大图左右滑动预览');

  await dt.sleep();
  dt.log.i('预期结果4.大图左右滑动范围仅为选中图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('微信-勾选多张图片，点击预览按钮进入大图，大图左右滑动范围仅为选中图片 end');
}
/**
 * picker-进入大图: [微信-勾选多张图片，点击预览按钮进入大图，点击缩略图，大图跟随联动显示]
 * GROUP: picker MODULE: 进入大图TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_1000
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT1000(dt: Dt) {
  dt.log.i('微信-勾选多张图片，点击预览按钮进入大图，点击缩略图，大图跟随联动显示 start');
  dt.log.i('STEP 1.点击demo User.hap');

  await dt.sleep();
  dt.log.i('STEP 2.宫格页勾选多张图片');

  await dt.sleep();
  dt.log.i('预期结果2.宫格页底部出现当前已选中图片的图略图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击预览');

  await dt.sleep();
  dt.log.i('预期结果3.大图页面底部当前正在预览图片的缩略图出现高亮框');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.点击缩略图');

  await dt.sleep();
  dt.log.i('预期结果4.上方大图跟随缩略图联动');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('微信-勾选多张图片，点击预览按钮进入大图，点击缩略图，大图跟随联动显示 end');
}
/**
 * picker-进入大图: [微信-勾选多张图片，点击图片进入大图，滑动范围是全部的图片]
 * GROUP: picker MODULE: 进入大图TID: SUB_MULTIMEDIA_MEDIA_PHOTO_PICKER_WECHAT_1100
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTOPICKERWECHAT1100(dt: Dt) {
  dt.log.i('微信-勾选多张图片，点击图片进入大图，滑动范围是全部的图片 start');
  dt.log.i('STEP 1.点击demo User.hap');

  await dt.sleep();
  dt.log.i('STEP 2.宫格页勾选多张图片');

  await dt.sleep();
  dt.log.i('预期结果2.宫格页底部出现当前已选中图片的图略图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击预览');

  await dt.sleep();
  dt.log.i('预期结果3.大图页面底部当前正在预览图片的缩略图出现高亮框');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.大图左右滑动');

  await dt.sleep();
  dt.log.i('预期结果4.大图左右滑动范围包含选中与未选中的图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('微信-勾选多张图片，点击图片进入大图，滑动范围是全部的图片 end');
}
/**
 * picker-: [图库picker-拉起picker后，杀掉picker进程，重新拉起查看是否可以正常拉起]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_RELIABLE_0100
 * 前置条件
 * 1、图库picker已被拉起
 2、xxx查询进程号
 hdc shell
 ps -ef | grep 进程名字
 */
async function SUBMULTIMEDIAMEDIAPHOTORELIABLE0100(dt: Dt) {
  dt.log.i('图库picker-拉起picker后，杀掉picker进程，重新拉起查看是否可以正常拉起 start');
  dt.log.i('STEP 1、查找picker进程：hdc shellps -ef | grep com.ohos.photos:PickerUIExtensionAbility');

  await dt.sleep();
  dt.log.i('STEP 2、kill -9 进程号');

  await dt.sleep();
  dt.log.i('预期结果2、picker界面关闭');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、新建备忘录拉起picker');

  await dt.sleep();
  dt.log.i('预期结果3、picker界面被拉起');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker-拉起picker后，杀掉picker进程，重新拉起查看是否可以正常拉起 end');
}
/**
 * picker-锁屏: [图库picker-锁屏场景-小艺视觉-识文]
 * GROUP: picker MODULE: 锁屏TID: SUB_MULTIMEDIA_MEDIA_PHOTO_SECURITYPRIVACY_0100
 * 前置条件
 * 1、图库中存在图片
 2、设置锁屏密码
 */
async function SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0100(dt: Dt) {
  dt.log.i('图库picker-锁屏场景-小艺视觉-识文 start');
  dt.log.i('STEP 1、锁屏状态下长按导航条拉起小艺视觉，点击识文，点击拉起图库picker');

  await dt.sleep();
  dt.log.i('预期结果1、弹出密码界面，需要输入密码后才可以拉起图库picker');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker-锁屏场景-小艺视觉-识文 end');
}
/**
 * picker-锁屏: [图库picker-锁屏场景-小艺视觉-翻译]
 * GROUP: picker MODULE: 锁屏TID: SUB_MULTIMEDIA_MEDIA_PHOTO_SECURITYPRIVACY_0101
 * 前置条件
 * 1、图库中存在图片
 2、设置锁屏密码
 */
async function SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0101(dt: Dt) {
  dt.log.i('图库picker-锁屏场景-小艺视觉-翻译 start');
  dt.log.i('STEP 1、锁屏状态下长按导航条拉起小艺视觉，点击翻译，点击拉起图库picker');

  await dt.sleep();
  dt.log.i('预期结果1、弹出密码界面，需要输入密码后才可以拉起图库picker');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker-锁屏场景-小艺视觉-翻译 end');
}
/**
 * picker-锁屏: [图库picker-锁屏场景-小艺视觉-扫一扫]
 * GROUP: picker MODULE: 锁屏TID: SUB_MULTIMEDIA_MEDIA_PHOTO_SECURITYPRIVACY_0102
 * 前置条件
 * 1、图库中存在图片
 2、设置锁屏密码
 */
async function SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0102(dt: Dt) {
  dt.log.i('图库picker-锁屏场景-小艺视觉-扫一扫 start');
  dt.log.i('STEP 1、锁屏状态下长按导航条拉起小艺视觉，点击扫一扫，点击拉起图库picker');

  await dt.sleep();
  dt.log.i('预期结果1、弹出密码界面，需要输入密码后才可以拉起图库picker');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker-锁屏场景-小艺视觉-扫一扫 end');
}
/**
 * picker-锁屏: [图库picker-锁屏场景-小艺视觉-扫描]
 * GROUP: picker MODULE: 锁屏TID: SUB_MULTIMEDIA_MEDIA_PHOTO_SECURITYPRIVACY_0103
 * 前置条件
 * 1、图库中存在图片
 2、设置锁屏密码
 */
async function SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0103(dt: Dt) {
  dt.log.i('图库picker-锁屏场景-小艺视觉-扫描 start');
  dt.log.i('STEP 1、锁屏状态下长按导航条拉起小艺视觉，点击扫描，点击拉起图库picker');

  await dt.sleep();
  dt.log.i('预期结果1、弹出密码界面，需要输入密码后才可以拉起图库picker');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker-锁屏场景-小艺视觉-扫描 end');
}
/**
 * picker-: [图库picker-安全访问图库提示-半模态picker]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_SECURITYPRIVACY_0104
 * 前置条件
 * 1、首次进入半模态picker
 */
async function SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0104(dt: Dt) {
  dt.log.i('图库picker-安全访问图库提示-半模态picker start');
  dt.log.i('STEP 1、首次拉起半模态picker');

  await dt.sleep();
  dt.log.i('预期结果1、首次拉起半模态picker会进行安全访问图库提示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、关闭提示后再次拉起半模态picker');

  await dt.sleep();
  dt.log.i('预期结果2、关闭后再次拉起半模态picker安全访问图库提示已消失');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker-安全访问图库提示-半模态picker end');
}
/**
 * picker-: [图库picker-安全访问图库提示-PickerComponent]
 * GROUP: picker MODULE: TID: SUB_MULTIMEDIA_MEDIA_PHOTO_SECURITYPRIVACY_0105
 * 前置条件
 * 1、首次进入pickerview（小红书拉起pickerview）
 */
async function SUBMULTIMEDIAMEDIAPHOTOSECURITYPRIVACY0105(dt: Dt) {
  dt.log.i('图库picker-安全访问图库提示-PickerComponent start');
  dt.log.i('STEP 1、首次拉起pickerview');

  await dt.sleep();
  dt.log.i('预期结果1、pickerview会进行安全访问图库提示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、关闭后再次拉起半模态picker');

  await dt.sleep();
  dt.log.i('预期结果2、安全访问图库提示已消失取而代之的则是安全访问toast');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker-安全访问图库提示-PickerComponent end');
}
/**
 * picker-滑动: [图库picker-宫格页滑动MTBF测试]
 * GROUP: picker MODULE: 滑动TID: SUB_MULTIMEDIA_MEDIA_PHOTO_STABILITY_0100
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTOSTABILITY0100(dt: Dt) {
  dt.log.i('图库picker-宫格页滑动MTBF测试 start');
  dt.log.i('STEP 1、执行自动化脚本：SUB_Multimedia_PhotoPicker_MTBF_001');

  await dt.sleep();
  dt.log.i('预期结果1、脚本正常运行');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker-宫格页滑动MTBF测试 end');
}
/**
 * picker-大图: [图库picker-进/退大图MTBF测试]
 * GROUP: picker MODULE: 大图TID: SUB_MULTIMEDIA_MEDIA_PHOTO_STABILITY_0101
 * 前置条件
 *
 */
async function SUBMULTIMEDIAMEDIAPHOTOSTABILITY0101(dt: Dt) {
  dt.log.i('图库picker-进/退大图MTBF测试 start');
  dt.log.i('STEP 1、执行自动化脚本：SUB_Multimedia_PhotoPicker_MTBF_002');

  await dt.sleep();
  dt.log.i('预期结果2、脚本正常运行');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库picker-进/退大图MTBF测试 end');
}
/**
 * picker-下载: [photoView云端媒体资源测试]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PICKER_VIEW_CLOUD_0100
 * 前置条件
 * 1、图库上有云端未下载到本地的图片与视频
 2、图库上有本地的图片与视频
 3、下载嵌入式picker应用，如小红书

 */
async function SUBMULTIMEDIAMEDIAPICKERVIEWCLOUD0100(dt: Dt) {
  dt.log.i('photoView云端媒体资源测试 start');
  dt.log.i('STEP 1、打开小红书，拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2、向下滑动，选择未下载到本地的一张图片和一个视频，点击一下');

  await dt.sleep();
  dt.log.i('预期结果2、点击后该未下载的云图开始下载，下载过程中展示进度条4、刚才下载的图片与视频没有云图未下载的图标。5、图片正常查看，视频正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、再次打开小红书，拉起picker');

  await dt.sleep();
  dt.log.i('STEP 4、查看刚才点击的图片与视频');

  await dt.sleep();
  dt.log.i('预期结果4、刚才下载的图片与视频没有云图未下载的图标。');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5、点击缩略图进大图查看');

  await dt.sleep();
  dt.log.i('预期结果5、图片正常查看，视频正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('photoView云端媒体资源测试 end');
}
/**
 * picker-下载: [photoView云端媒体资源测试（反复取消下载）]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PICKER_VIEW_CLOUD_0200
 * 前置条件
 * 1、图库上有云端未下载到本地的图片与视频
 2、图库上有本地的图片与视频
 3、下载嵌入式picker应用，如小红书
 */
async function SUBMULTIMEDIAMEDIAPICKERVIEWCLOUD0200(dt: Dt) {
  dt.log.i('photoView云端媒体资源测试（反复取消下载） start');
  dt.log.i('STEP 1、打开小红书，拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2、向下滑动，');

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
  dt.log.i('STEP 5、选中刚才下载的视频文件，点击下一步');

  await dt.sleep();
  dt.log.i('预期结果5、相册中显示刚刚下载的视频文件');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、点击播放');

  await dt.sleep();
  dt.log.i('预期结果6、视频可以正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('photoView云端媒体资源测试（反复取消下载） end');
}
/**
 * picker-下载: [photoView云端媒体资源测试（下载时关闭应用）]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PICKER_VIEW_CLOUD_0300
 * 前置条件
 * 1、图库上有云端未下载到本地的图片与视频
 2、图库上有本地的图片与视频
 3、下载嵌入式picker应用，如小红书

 */
async function SUBMULTIMEDIAMEDIAPICKERVIEWCLOUD0300(dt: Dt) {
  dt.log.i('photoView云端媒体资源测试（下载时关闭应用） start');
  dt.log.i('STEP 1、打开小红书，拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2、向下滑动，');

  await dt.sleep();
  dt.log.i('预期结果2、云端媒体资源（未下载到本地）上有云端标识');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、选择未下载到本地的一张图片和一个视频，点击一下');

  await dt.sleep();
  dt.log.i('预期结果3、点击的云端媒体资源开始下载5、刚才点击的媒体资源处于下载状态或下载完成6、可以看到刚刚下载的视频和图片7、图片可以正常显示，视频能正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、关闭小红书');

  await dt.sleep();
  dt.log.i('STEP 5、再次打开小红书，拉起picker，重复1-2');

  await dt.sleep();
  dt.log.i('预期结果5、刚才点击的媒体资源处于下载状态或下载完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、查看刚才点击的图片与视频');

  await dt.sleep();
  dt.log.i('预期结果6、可以看到刚刚下载的视频和图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、点击缩略图进大图查看');

  await dt.sleep();
  dt.log.i('预期结果7、图片可以正常显示，视频能正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('photoView云端媒体资源测试（下载时关闭应用） end');
}
/**
 * picker-下载: [photoView云端媒体资源测试（下载时息屏）]
 * GROUP: picker MODULE: 下载TID: SUB_MULTIMEDIA_MEDIA_PICKER_VIEW_CLOUD_0400
 * 前置条件
 * 1、图库上有云端未下载到本地的图片与视频
 2、图库上有本地的图片与视频
 3、下载嵌入式picker应用，如小红书
 */
async function SUBMULTIMEDIAMEDIAPICKERVIEWCLOUD0400(dt: Dt) {
  dt.log.i('photoView云端媒体资源测试（下载时息屏） start');
  dt.log.i('STEP 1、打开小红书，拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2、向下滑动，');

  await dt.sleep();
  dt.log.i('预期结果2、云端媒体资源（未下载到本地）上有云端标识');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、选择未下载到本地的一张图片和一个视频，点击一下');

  await dt.sleep();
  dt.log.i('预期结果3、点击的云端媒体资源开始下载5、刚才点击的媒体资源处于下载状态或下载完成6、可以看到刚刚下载的视频和图片7、图片可以正常显示，视频能正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4、息屏');

  await dt.sleep();
  dt.log.i('STEP 5、亮屏');

  await dt.sleep();
  dt.log.i('预期结果5、刚才点击的媒体资源处于下载状态或下载完成');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 6、查看刚才点击的图片与视频');

  await dt.sleep();
  dt.log.i('预期结果6、可以看到刚刚下载的视频和图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 7、点击缩略图进大图查看');

  await dt.sleep();
  dt.log.i('预期结果7、图片可以正常显示，视频能正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('photoView云端媒体资源测试（下载时息屏） end');
}