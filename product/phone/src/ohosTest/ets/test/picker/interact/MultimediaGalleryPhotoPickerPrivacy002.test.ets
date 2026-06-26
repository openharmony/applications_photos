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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, Level } from '@ohos/hypium';
import { Component, Driver, On, ON, Point } from '@ohos.UiTest';
import { abilityDelegator, run as run } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';


export default function MultimediaGalleryPhotoPickerPrivacyTest002(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryPhotoPickerPrivacy0208Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryPhotoPickerPrivacy0208').init();
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerPrivacy0208 start');
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerPrivacy0208 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('MultimediaGalleryPhotoPickerPrivacy0208', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-大图用例: [隐私空间，大图预览验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0208
      await MultimediaGalleryPhotoPickerPrivacy0208(dt);
    });

    run('MultimediaGalleryPhotoPickerPrivacy0209', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-删除用例: [图片移动到隐私空间后，主空间校验] TID: Multimedia_Gallery_PhotoPickerPrivacy_0209
      await MultimediaGalleryPhotoPickerPrivacy0209(dt);
    });

    run('MultimediaGalleryPhotoPickerPrivacy0210', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-动态照片用例: [图片移动到隐私空间后，隐私空间校验] TID: Multimedia_Gallery_PhotoPickerPrivacy_0210
      await MultimediaGalleryPhotoPickerPrivacy0210(dt);
    });

    run('MultimediaGalleryPhotoPickerPrivacy0211', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-滑动用例: [隐私空间，滑动性能] TID: Multimedia_Gallery_PhotoPickerPrivacy_0211
      await MultimediaGalleryPhotoPickerPrivacy0211(dt);
    });

    run('MultimediaGalleryPhotoPickerPrivacy0212', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-大图用例: [隐私空间，进大图性能] TID: Multimedia_Gallery_PhotoPickerPrivacy_0212
      await MultimediaGalleryPhotoPickerPrivacy0212(dt);
    });

    run('MultimediaGalleryPhotoPickerPrivacy0213', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-格式用例: [隐私空间，日志校验] TID: Multimedia_Gallery_PhotoPickerPrivacy_0213
      await MultimediaGalleryPhotoPickerPrivacy0213(dt);
    });

    run('MultimediaGalleryPhotoPickerPrivacy0214', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-格式用例: [隐私空间，内存校验] TID: Multimedia_Gallery_PhotoPickerPrivacy_0214
      await MultimediaGalleryPhotoPickerPrivacy0214(dt);
    });

    run('MultimediaGalleryPhotoPickerPrivacy0215', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-格式用例: [隐私空间拉起主空间picker性能] TID: Multimedia_Gallery_PhotoPickerPrivacy_0215
      await MultimediaGalleryPhotoPickerPrivacy0215(dt);
    });

    run('MultimediaGalleryPhotoPickerPrivacy0216', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-格式用例: [隐私空间调起picker访问主空间，息屏验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0216
      await MultimediaGalleryPhotoPickerPrivacy0216(dt);
    });

    run('MultimediaGalleryPhotoPickerPrivacy0217', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-壁纸用例: [隐私空间图片迁移到主空间，编辑保存，设置为壁纸验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0217
      await MultimediaGalleryPhotoPickerPrivacy0217(dt);
    });

    run('MultimediaGalleryPhotoPickerWeChat0200', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [勾选单个图片下方出现已选中图片的缩略图] TID: Multimedia_Gallery_PhotoPickerWeChat_0200
      await MultimediaGalleryPhotoPickerWeChat0200(dt);
    });

    run('MultimediaGalleryPhotoPickerWeChat0201', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [勾选多个图片下方出现已选中图片的缩略图] TID: Multimedia_Gallery_PhotoPickerWeChat_0201
      await MultimediaGalleryPhotoPickerWeChat0201(dt);
    });

    run('MultimediaGalleryPhotoPickerWeChat0202', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [勾选单个图片后进行预览，下方缩略图显示焦点] TID: Multimedia_Gallery_PhotoPickerWeChat_0202
      await MultimediaGalleryPhotoPickerWeChat0202(dt);
    });

    run('MultimediaGalleryPhotoPickerWeChat0203', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-滑动用例: [勾选多个图片后进行预览，下方缩略图显示当前图片的焦点] TID: Multimedia_Gallery_PhotoPickerWeChat_0203
      await MultimediaGalleryPhotoPickerWeChat0203(dt);
    });

    run('MultimediaGalleryPhotoPickerWeChat0204', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-格式用例: [不勾选图片直接进行预览，下方无缩略图显示] TID: Multimedia_Gallery_PhotoPickerWeChat_0204
      await MultimediaGalleryPhotoPickerWeChat0204(dt);
    });

    run('MultimediaGalleryPhotoPickerWeChat0205', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-滑动用例: [勾选图片直接进行预览，预览界面滑动至未勾选图片，下方缩略图不显示当前图片焦点] TID: Multimedia_Gallery_PhotoPickerWeChat_0205
      await MultimediaGalleryPhotoPickerWeChat0205(dt);
    });

    run('MultimediaGalleryPhotoPickerWeChat0206', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [宫格页选择图片，不会返回该图片所属相册的相册名称] TID: Multimedia_Gallery_PhotoPickerWeChat_0206
      await MultimediaGalleryPhotoPickerWeChat0206(dt);
    });

    run('MultimediaGalleryRefinementNotify004', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-滑动用例: [照片页处于前台，日视图（三宫格），多选5000张移动到新建相册，查看照片页和相册页显示] TID: Multimedia_Gallery_RefinementNotify_004
      await MultimediaGalleryRefinementNotify004(dt);
    });

    run('MultimediaGalleryRefinementNotify005', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-滑动用例: [照片页处于前台，日视图（三宫格），多选5000张移动到已有建相册，查看照片页和相册页显示] TID: Multimedia_Gallery_RefinementNotify_005
      await MultimediaGalleryRefinementNotify005(dt);
    });

    run('MultimediaGalleryRefinementNotify019', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [相册宫格内多选5000张移动到新建相册，查看照片页显示，相册页显示] TID: Multimedia_Gallery_RefinementNotify_019
      await MultimediaGalleryRefinementNotify019(dt);
    });

    run('MultimediaGalleryRefinementNotify020', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [相册宫格内多选5000张移动到相机相册，查看照片页显示，相册页显示] TID: Multimedia_Gallery_RefinementNotify_020
      await MultimediaGalleryRefinementNotify020(dt);
    });

    run('MultimediaGalleryRefinementNotify021', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [最近删除相册多选5000张彻底删除] TID: Multimedia_Gallery_RefinementNotify_021
      await MultimediaGalleryRefinementNotify021(dt);
    });

    run('MultimediaGalleryRefinementNotify022', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [最近删除相册多选5000张恢复] TID: Multimedia_Gallery_RefinementNotify_022
      await MultimediaGalleryRefinementNotify022(dt);
    });

    run('MultimediaGalleryRefinementNotify023', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-端云用例: [图库设置中，连续开关云同步开关50次，查看照片页显示，相册页显示] TID: Multimedia_Gallery_RefinementNotify_023
      await MultimediaGalleryRefinementNotify023(dt);
    });

    run('MultimediaGalleryRefinementNotify024', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [备用机克隆过程中，连续中断10次，查看照片页显示，相册页显示] TID: Multimedia_Gallery_RefinementNotify_024
      await MultimediaGalleryRefinementNotify024(dt);
    });

    run('MultimediaGalleryRefinementNotify025', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-滑动用例: [图库照片页连续不停的滑动100次，每次滑动至少一屏以上（日视图三宫格）] TID: Multimedia_Gallery_RefinementNotify_025
      await MultimediaGalleryRefinementNotify025(dt);
    });

    run('MultimediaGalleryRefinementNotify026', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-滑动用例: [图库照片页连续不停的滑动100次，每次滑动至少一屏以上（日视图四宫格）] TID: Multimedia_Gallery_RefinementNotify_026
      await MultimediaGalleryRefinementNotify026(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachMultimediaGalleryPhotoPickerPrivacy0208').init();
      dt.log.i('afterEach MultimediaGalleryPhotoPickerPrivacy0208 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryPhotoPickerPrivacy0208 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllMultimediaGalleryPhotoPickerPrivacy0208').init();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerPrivacy0208 start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerPrivacy0208 finish');
    });
  });
}

/**
 * picker-大图: [隐私空间，大图预览验证]
 * GROUP: picker MODULE: 大图TID: Multimedia_Gallery_PhotoPickerPrivacy_0208
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在包含动态照片在内的各种格式的图片及视频资源
 3.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0208(dt: Dt) {
  dt.log.i('隐私空间，大图预览验证 start');
  dt.log.i('STEP 1.调起隐私空间内picker ');

  await dt.sleep();
  dt.log.i('STEP 2.选中包含动态照片在内的5张照片，取消当中一张的选中状态');

  await dt.sleep();
  dt.log.i('STEP 3.点击图片进大图，左右滑动');

  await dt.sleep();
  dt.log.i('预期结果3.图片非高亮显示。滑动正常，且滑到动态照片时会自动播放，取消选中的图片，勾选框未被勾选。下方预览条展示被选中的图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.选中一张被选中的大图，取消勾选框');

  await dt.sleep();
  dt.log.i('预期结果4.取消选中后的图片预览条不在显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5.系统设置-开启图片HDR显示，回到picker 页面，点击图片进大图');

  await dt.sleep();
  dt.log.i('预期结果5.图片高亮显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，大图预览验证 end');
}

/**
 * picker-删除: [图片移动到隐私空间后，主空间校验]
 * GROUP: picker MODULE: 删除TID: Multimedia_Gallery_PhotoPickerPrivacy_0209
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在智慧相册，精彩时刻，地图相册，最近删除以及其他相册，且有图片资源
 3.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0209(dt: Dt) {
  dt.log.i('图片移动到隐私空间后，主空间校验 start');
  dt.log.i('STEP 1.主空间打开图库，搜索被删除的图片');

  await dt.sleep();
  dt.log.i('预期结果1.被删除的照片无法被搜索到');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击智慧相册，查看图片');

  await dt.sleep();
  dt.log.i('预期结果2.人像以及地点相册被迁移到隐私空间的都无法查看到');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击精彩时刻，查看图片');

  await dt.sleep();
  dt.log.i('预期结果3.精彩时刻无法查看到被迁移到隐私空间的图片');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.点击最近删除，查看图片');

  await dt.sleep();
  dt.log.i('预期结果4.最近删除无法查看到被迁移到隐私空间的图片');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片移动到隐私空间后，主空间校验 end');
}

/**
 * picker-动态照片: [图片移动到隐私空间后，隐私空间校验]
 * GROUP: picker MODULE: 动态照片TID: Multimedia_Gallery_PhotoPickerPrivacy_0210
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.主空间图库中存在智慧相册，精彩时刻，地图相册，视频及动态照片且相册中均有图片资源
 3.主空间图库编辑一张图片

 */
async function MultimediaGalleryPhotoPickerPrivacy0210(dt: Dt) {
  dt.log.i('图片移动到隐私空间后，隐私空间校验 start');
  dt.log.i('STEP 1.隐私空间访问主空间，选择上述资源进行迁移');

  await dt.sleep();
  dt.log.i('预期结果1.智慧分析相册，精彩时刻，地图相册无法被识别到，无法被迁移。除此之外的相册均可迁移');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.隐私空间图库新建相册拉起picker ,点击播放视频相册的视频');

  await dt.sleep();
  dt.log.i('预期结果2.视频正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击图片相册内的动态照片');

  await dt.sleep();
  dt.log.i('预期结果3.动态照片正常播放');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.备忘录拉起picker选择被编辑的那张照片，点击编辑');

  await dt.sleep();
  dt.log.i('预期结果4.可以看到右上方有没有还原功能');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片移动到隐私空间后，隐私空间校验 end');
}

/**
 * picker-滑动: [隐私空间，滑动性能]
 * GROUP: picker MODULE: 滑动TID: Multimedia_Gallery_PhotoPickerPrivacy_0211
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在各种格式的图片及视频
 3.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0211(dt: Dt) {
  dt.log.i('隐私空间，滑动性能 start');
  dt.log.i('STEP 1.调起隐私空间内picker');

  await dt.sleep();
  dt.log.i('STEP 2.执行抓Trace脚本，开始滑动宫格页8S，将生成的Trace文件在网站： 打开');

  await dt.sleep();
  dt.log.i('预期结果2.无白块卡顿，查看8S内的平均滑动帧率正常未丢帧');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.执行抓Trace脚本，点击图片进大图往右滑动8S，将生成的Trace文件在网站 打开');

  await dt.sleep();
  dt.log.i('预期结果3.无白块卡顿，查看8S内的平均滑动帧率正常未丢帧');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，滑动性能 end');
}

/**
 * picker-大图: [隐私空间，进大图性能]
 * GROUP: picker MODULE: 大图TID: Multimedia_Gallery_PhotoPickerPrivacy_0212
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在各种格式的图片及视频
 3.隐私空间访问主空间，选择上述资源进行迁移
 4.被测xxx手机与辅助机各一台
 */
async function MultimediaGalleryPhotoPickerPrivacy0212(dt: Dt) {
  dt.log.i('隐私空间，进大图性能 start');
  dt.log.i('STEP 1.调起隐私空间内picker ');

  await dt.sleep();
  dt.log.i('STEP 2.点击图片进大图（响应时延：手指离开屏幕第一帧->picker动效出现第一帧   完成时延：手指离开屏幕第一帧->picker被完全拉起第一帧）');

  await dt.sleep();
  dt.log.i('预期结果2.响应时延达人因S标，完成时延达人因S标');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，进大图性能 end');
}

/**
 * picker-格式: [隐私空间，日志校验]
 * GROUP: picker MODULE: 格式TID: Multimedia_Gallery_PhotoPickerPrivacy_0213
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在各种格式的图片及视频
 3.隐私空间访问主空间，选择上述资源进行迁移

 */
async function MultimediaGalleryPhotoPickerPrivacy0213(dt: Dt) {
  dt.log.i('隐私空间，日志校验 start');
  dt.log.i('STEP 1.调起隐私空间内picker');

  await dt.sleep();
  dt.log.i('STEP 2.拉取日志，查看userld,INTERACT_ACROSS_LOCAL_ACCOUNTS');

  await dt.sleep();
  dt.log.i('预期结果2.可以看到userld,INTERACT_ACROSS_LOCAL_ACCOUNTS关键字');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，日志校验 end');
}

/**
 * picker-格式: [隐私空间，内存校验]
 * GROUP: picker MODULE: 格式TID: Multimedia_Gallery_PhotoPickerPrivacy_0214
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在各种格式的图片及视频
 3.隐私空间访问主空间，选择上述资源进行迁移

 */
async function MultimediaGalleryPhotoPickerPrivacy0214(dt: Dt) {
  dt.log.i('隐私空间，内存校验 start');
  dt.log.i('STEP 1.调起隐私空间内picker');

  await dt.sleep();
  dt.log.i('STEP 2.宫格浏览');

  await dt.sleep();
  dt.log.i('预期结果2.宫格浏览，内存不增加');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.大图浏览');

  await dt.sleep();
  dt.log.i('预期结果3.大图浏览内存不增加');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，内存校验 end');
}

/**
 * picker-格式: [隐私空间拉起主空间picker性能]
 * GROUP: picker MODULE: 格式TID: Multimedia_Gallery_PhotoPickerPrivacy_0215
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在各种格式的图片及视频
 3.隐私空间访问主空间，选择上述资源进行迁移
 4.被测xxx手机与辅助机各一台
 */
async function MultimediaGalleryPhotoPickerPrivacy0215(dt: Dt) {
  dt.log.i('隐私空间拉起主空间picker性能 start');
  dt.log.i('STEP 1.隐私空间拉起主空间picker');

  await dt.sleep();
  dt.log.i('STEP 2.隐私空间-主空间至隐私空间-点击图库进入picker（响应时延：手指离开屏幕第一帧->picker动效出现第一帧   完成时延：手指离开屏幕第一帧->picker被完全拉起第一帧）');

  await dt.sleep();
  dt.log.i('预期结果2.响应时延达人因S标，完成时延达人因S标');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间拉起主空间picker性能 end');
}

/**
 * picker-格式: [隐私空间调起picker访问主空间，息屏验证]
 * GROUP: picker MODULE: 格式TID: Multimedia_Gallery_PhotoPickerPrivacy_0216
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在各种格式的图片及视频
 */
async function MultimediaGalleryPhotoPickerPrivacy0216(dt: Dt) {
  dt.log.i('隐私空间调起picker访问主空间，息屏验证 start');
  dt.log.i('STEP 1.隐私空间调起picker访问主空间');

  await dt.sleep();
  dt.log.i('预期结果1.正常访问主空间3.picker访问的内容正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.息屏三分钟');

  await dt.sleep();
  dt.log.i('STEP 3.亮屏');

  await dt.sleep();
  dt.log.i('预期结果3.picker访问的内容正常显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间调起picker访问主空间，息屏验证 end');
}

/**
 * picker-壁纸: [隐私空间图片迁移到主空间，编辑保存，设置为壁纸验证]
 * GROUP: picker MODULE: 壁纸TID: Multimedia_Gallery_PhotoPickerPrivacy_0217
 * 前置条件
 * 隐私空间图库有图片
 */
async function MultimediaGalleryPhotoPickerPrivacy0217(dt: Dt) {
  dt.log.i('隐私空间图片迁移到主空间，编辑保存，设置为壁纸验证 start');
  dt.log.i('STEP 1.隐私空间系统相机拍摄照片');

  await dt.sleep();
  dt.log.i('STEP 2.隐私空间的照片转移一张到主空间');

  await dt.sleep();
  dt.log.i('STEP 3.主空间图库对这张照片进行编辑保存');

  await dt.sleep();
  dt.log.i('预期结果3.可以进行编辑正常保存');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.主空间图库对这张照片进行设置壁纸');

  await dt.sleep();
  dt.log.i('预期结果4.设置壁纸成功');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间图片迁移到主空间，编辑保存，设置为壁纸验证 end');
}

/**
 * picker-视频: [勾选单个图片下方出现已选中图片的缩略图]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerWeChat_0200
 * 前置条件
 * 1.图库中存在视频和图片
 */
async function MultimediaGalleryPhotoPickerWeChat0200(dt: Dt) {
  dt.log.i('勾选单个图片下方出现已选中图片的缩略图 start');
  dt.log.i('STEP 1.点击demo User.hap');

  await dt.sleep();
  dt.log.i('STEP 2.宫格页勾选一张图片');

  await dt.sleep();
  dt.log.i('预期结果2.宫格页底部出现该张图片的图略图');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('勾选单个图片下方出现已选中图片的缩略图 end');
}

/**
 * picker-视频: [勾选多个图片下方出现已选中图片的缩略图]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerWeChat_0201
 * 前置条件
 * 1.图库中存在视频和图片
 */
async function MultimediaGalleryPhotoPickerWeChat0201(dt: Dt) {
  dt.log.i('勾选多个图片下方出现已选中图片的缩略图 start');
  dt.log.i('STEP 1.点击demo User.hap');

  await dt.sleep();
  dt.log.i('STEP 2.宫格页勾选多张图片');

  await dt.sleep();
  dt.log.i('预期结果2.宫格页底部出现已选中的多张图片的略图');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('勾选多个图片下方出现已选中图片的缩略图 end');
}

/**
 * picker-视频: [勾选单个图片后进行预览，下方缩略图显示焦点]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerWeChat_0202
 * 前置条件
 * 1.图库中存在视频和图片
 */
async function MultimediaGalleryPhotoPickerWeChat0202(dt: Dt) {
  dt.log.i('勾选单个图片后进行预览，下方缩略图显示焦点 start');
  dt.log.i('STEP 1.点击demo User.hap');

  await dt.sleep();
  dt.log.i('STEP 2.宫格页勾选一张图片');

  await dt.sleep();
  dt.log.i('预期结果2.宫格页底部出现该张图片的图略图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击预览');

  await dt.sleep();
  dt.log.i('预期结果3.预览页面底部该张图片的缩略图出现焦点');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('勾选单个图片后进行预览，下方缩略图显示焦点 end');
}

/**
 * picker-滑动: [勾选多个图片后进行预览，下方缩略图显示当前图片的焦点]
 * GROUP: picker MODULE: 滑动TID: Multimedia_Gallery_PhotoPickerWeChat_0203
 * 前置条件
 * 1.图库中存在视频和图片
 */
async function MultimediaGalleryPhotoPickerWeChat0203(dt: Dt) {
  dt.log.i('勾选多个图片后进行预览，下方缩略图显示当前图片的焦点 start');
  dt.log.i('STEP 1.点击demo User.hap');

  await dt.sleep();
  dt.log.i('STEP 2.宫格页勾选多张图片');

  await dt.sleep();
  dt.log.i('预期结果2.宫格页底部出现当前已选中图片的图略图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击预览');

  await dt.sleep();
  dt.log.i('预期结果3.预览页面底部当前正在预览图片的缩略图出现焦点');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.点击滑动，滑动至已勾选的另一张图片');

  await dt.sleep();
  dt.log.i('预期结果4.预览页面底部当前正在预览图片的缩略图出现焦点');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('勾选多个图片后进行预览，下方缩略图显示当前图片的焦点 end');
}

/**
 * picker-格式: [不勾选图片直接进行预览，下方无缩略图显示]
 * GROUP: picker MODULE: 格式TID: Multimedia_Gallery_PhotoPickerWeChat_0204
 * 前置条件
 * 1.图库中存在视频和图片
 2.存在gif格式图片
 */
async function MultimediaGalleryPhotoPickerWeChat0204(dt: Dt) {
  dt.log.i('不勾选图片直接进行预览，下方无缩略图显示 start');
  dt.log.i('STEP 1.点击demo User.hap');

  await dt.sleep();
  dt.log.i('STEP 2.宫格页点击预览一张图片');

  await dt.sleep();
  dt.log.i('预期结果2.宫格页底部不会出现该张图片的图略图');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('不勾选图片直接进行预览，下方无缩略图显示 end');
}

/**
 * picker-滑动: [勾选图片直接进行预览，预览界面滑动至未勾选图片，下方缩略图不显示当前图片焦点]
 * GROUP: picker MODULE: 滑动TID: Multimedia_Gallery_PhotoPickerWeChat_0205
 * 前置条件
 * 1.图库中存在视频和图片
 */
async function MultimediaGalleryPhotoPickerWeChat0205(dt: Dt) {
  dt.log.i('勾选图片直接进行预览，预览界面滑动至未勾选图片，下方缩略图不显示当前图片焦点 start');
  dt.log.i('STEP 1.点击demo User.hap');

  await dt.sleep();
  dt.log.i('STEP 2.宫格页勾选多张图片');

  await dt.sleep();
  dt.log.i('预期结果2.宫格页底部出现当前已选中图片的图略图');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击预览');

  await dt.sleep();
  dt.log.i('预期结果3.预览页面底部当前正在预览图片的缩略图出现焦点');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4.点击滑动，滑动至未勾选的另一张图片');

  await dt.sleep();
  dt.log.i('预期结果4.预览页面底部当前正在预览图片无所缩略图出现');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('勾选图片直接进行预览，预览界面滑动至未勾选图片，下方缩略图不显示当前图片焦点 end');
}

/**
 * picker-视频: [宫格页选择图片，不会返回该图片所属相册的相册名称]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerWeChat_0206
 * 前置条件
 * 1.图库中存在视频和图片
 */
async function MultimediaGalleryPhotoPickerWeChat0206(dt: Dt) {
  dt.log.i('宫格页选择图片，不会返回该图片所属相册的相册名称 start');
  dt.log.i('STEP 1.点击demo User.hap');

  await dt.sleep();
  dt.log.i('STEP 2.宫格页勾选一张图片');

  await dt.sleep();
  dt.log.i('预期结果2.页面中不显示当前图片所归属相册的名称');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('宫格页选择图片，不会返回该图片所属相册的相册名称 end');
}

/**
 * 宫格-滑动: [照片页处于前台，日视图（三宫格），多选5000张移动到新建相册，查看照片页和相册页显示]
 * GROUP: 宫格 MODULE: 滑动TID: Multimedia_Gallery_RefinementNotify_004
 * 前置条件
 * 1、登录图库通用测试模型（3W图片+3k视频），正常完成数据同步
 */
async function MultimediaGalleryRefinementNotify004(dt: Dt) {
  dt.log.i('照片页处于前台，日视图（三宫格），多选5000张移动到新建相册，查看照片页和相册页显示 start');
  dt.log.i('STEP 1.进入图库照片页，滑动多选，选择5000张，移动到新建相册');

  await dt.sleep();
  dt.log.i('STEP 2、查看照片页显示和相册页显示');

  await dt.sleep();
  dt.log.i('预期结果2、照片页正常缩略图刷新且顶部数字正常变化，相册页的相册封面正常刷新，且相册的数量正常变化');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页处于前台，日视图（三宫格），多选5000张移动到新建相册，查看照片页和相册页显示 end');
}

/**
 * 宫格-滑动: [照片页处于前台，日视图（三宫格），多选5000张移动到已有建相册，查看照片页和相册页显示]
 * GROUP: 宫格 MODULE: 滑动TID: Multimedia_Gallery_RefinementNotify_005
 * 前置条件
 * 1、登录图库通用测试模型（3W图片+3k视频），正常完成数据同步
 */
async function MultimediaGalleryRefinementNotify005(dt: Dt) {
  dt.log.i('照片页处于前台，日视图（三宫格），多选5000张移动到已有建相册，查看照片页和相册页显示 start');
  dt.log.i('STEP 1.进入图库照片页，滑动多选，选择5000张，移动到新建相册');

  await dt.sleep();
  dt.log.i('STEP 2、查看照片页显示和相册页显示');

  await dt.sleep();
  dt.log.i('预期结果2、照片页正常缩略图刷新且顶部数字正常变化，相册页的相册封面正常刷新，且相册的数量正常变化');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('照片页处于前台，日视图（三宫格），多选5000张移动到已有建相册，查看照片页和相册页显示 end');
}

/**
 * 宫格-视频: [相册宫格内多选5000张移动到新建相册，查看照片页显示，相册页显示]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_RefinementNotify_019
 * 前置条件
 * 1、登录图库通用测试模型（3W图片+3k视频），正常完成数据同步
 */
async function MultimediaGalleryRefinementNotify019(dt: Dt) {
  dt.log.i('相册宫格内多选5000张移动到新建相册，查看照片页显示，相册页显示 start');
  dt.log.i('STEP 1、进入图库相册界面，点击进入相机相册');

  await dt.sleep();
  dt.log.i('STEP 2、多选5000张，点击移动到，创建新相册');

  await dt.sleep();
  dt.log.i('预期结果2、照片页正常缩略图刷新且顶部数字正常变化，相册页的相册封面正常刷新，且相册的数量正常变化');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、移动结束后，查看图库界面显示');

  await dt.sleep();
  dt.log.i('STEP 4、重复步骤1，相册变更为用户自建相册，三方app来源相册');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册宫格内多选5000张移动到新建相册，查看照片页显示，相册页显示 end');
}

/**
 * 宫格-视频: [相册宫格内多选5000张移动到相机相册，查看照片页显示，相册页显示]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_RefinementNotify_020
 * 前置条件
 * 1、登录图库通用测试模型（3W图片+3k视频），正常完成数据同步
 */
async function MultimediaGalleryRefinementNotify020(dt: Dt) {
  dt.log.i('相册宫格内多选5000张移动到相机相册，查看照片页显示，相册页显示 start');
  dt.log.i('STEP 1、进入图库相册界面，点击进入图片相册');

  await dt.sleep();
  dt.log.i('STEP 2、多选5000张，点击移动到相机相册');

  await dt.sleep();
  dt.log.i('预期结果2、照片页正常缩略图刷新且顶部数字正常变化，相册页的相册封面正常刷新，且相册的数量正常变化');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、移动结束后，查看图库界面显示');

  await dt.sleep();
  dt.log.i('STEP 4、重复步骤1，分别从用户自建相册，三方app来源相册移动数据到相机相册');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册宫格内多选5000张移动到相机相册，查看照片页显示，相册页显示 end');
}

/**
 * 宫格-删除: [最近删除相册多选5000张彻底删除]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_RefinementNotify_021
 * 前置条件
 * 1、登录图库通用测试模型（3W图片+3k视频），正常完成数据同步
 */
async function MultimediaGalleryRefinementNotify021(dt: Dt) {
  dt.log.i('最近删除相册多选5000张彻底删除 start');
  dt.log.i('STEP 1、进入相机相册，选择5000张点击删除');

  await dt.sleep();
  dt.log.i('STEP 2、进入最近删除，选择5000张点击删除，弹窗点击彻底删除');

  await dt.sleep();
  dt.log.i('预期结果2、照片页正常缩略图刷新且顶部数字正常变化，相册页的相册封面正常刷新，且相册的数量正常变化');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看图库各界面显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除相册多选5000张彻底删除 end');
}

/**
 * 宫格-删除: [最近删除相册多选5000张恢复]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_RefinementNotify_022
 * 前置条件
 * 1、登录图库通用测试模型（3W图片+3k视频），正常完成数据同步
 */
async function MultimediaGalleryRefinementNotify022(dt: Dt) {
  dt.log.i('最近删除相册多选5000张恢复 start');
  dt.log.i('STEP 1、进入相机相册，选择5000张点击删除');

  await dt.sleep();
  dt.log.i('STEP 2、进入最近删除，选择5000张点击恢复');

  await dt.sleep();
  dt.log.i('预期结果2、照片页正常缩略图刷新且顶部数字正常变化，相册页的相册封面正常刷新，且相册的数量正常变化');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看图库各界面显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('最近删除相册多选5000张恢复 end');
}

/**
 * 宫格-端云: [图库设置中，连续开关云同步开关50次，查看照片页显示，相册页显示]
 * GROUP: 宫格 MODULE: 端云TID: Multimedia_Gallery_RefinementNotify_023
 * 前置条件
 * 1、登录图库通用测试模型（3W图片+3k视频），正常完成数据同步
 */
async function MultimediaGalleryRefinementNotify023(dt: Dt) {
  dt.log.i('图库设置中，连续开关云同步开关50次，查看照片页显示，相册页显示 start');
  dt.log.i('STEP 1、进入图库设置页，每隔5秒点击一次端云同步开关 ，构造端云的开关反复操作的场景；累计操作50次');

  await dt.sleep();
  dt.log.i('STEP 2、查看图库各界面显示');

  await dt.sleep();
  dt.log.i('预期结果2、照片页正常缩略图刷新且顶部数字正常变化，相册页的相册封面正常刷新，且相册的数量正常变化');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库设置中，连续开关云同步开关50次，查看照片页显示，相册页显示 end');
}

/**
 * 宫格-视频: [备用机克隆过程中，连续中断10次，查看照片页显示，相册页显示]
 * GROUP: 宫格 MODULE: 视频TID: Multimedia_Gallery_RefinementNotify_024
 * 前置条件
 * 1、登录图库通用测试模型（3W图片+3k视频），正常完成数据同步
 */
async function MultimediaGalleryRefinementNotify024(dt: Dt) {
  dt.log.i('备用机克隆过程中，连续中断10次，查看照片页显示，相册页显示 start');
  dt.log.i('STEP 1、备用机（xxx）克隆到单，仅仅克隆图库数据即可');

  await dt.sleep();
  dt.log.i('STEP 2、克隆过程中主动中断克隆 ，连续克隆后中断10次');

  await dt.sleep();
  dt.log.i('预期结果2、照片页正常缩略图刷新且顶部数字正常变化，相册页的相册封面正常刷新，且相册的数量正常变化');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、查看图库各界面显示');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('备用机克隆过程中，连续中断10次，查看照片页显示，相册页显示 end');
}

/**
 * 宫格-滑动: [图库照片页连续不停的滑动100次，每次滑动至少一屏以上（日视图三宫格）]
 * GROUP: 宫格 MODULE: 滑动TID: Multimedia_Gallery_RefinementNotify_025
 * 前置条件
 * 1、登录图库通用测试模型（3W图片+3k视频），正常完成数据同步
 */
async function MultimediaGalleryRefinementNotify025(dt: Dt) {
  dt.log.i('图库照片页连续不停的滑动100次，每次滑动至少一屏以上（日视图三宫格） start');
  dt.log.i('STEP 1、打开图库照片页，三宫格界面 ，反复滑动100次，每次滑动1屏以上（若已经滑到底部，则从下往上继续滑动）');

  await dt.sleep();
  dt.log.i('STEP 2、查看图库各界面显示');

  await dt.sleep();
  dt.log.i('预期结果2、照片页正常缩略图刷新且顶部数字正常变化，相册页的相册封面正常刷新，且相册的数量正常变化');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库照片页连续不停的滑动100次，每次滑动至少一屏以上（日视图三宫格） end');
}

/**
 * 宫格-滑动: [图库照片页连续不停的滑动100次，每次滑动至少一屏以上（日视图四宫格）]
 * GROUP: 宫格 MODULE: 滑动TID: Multimedia_Gallery_RefinementNotify_026
 * 前置条件
 * 1、登录图库通用测试模型（3W图片+3k视频），正常完成数据同步
 */
async function MultimediaGalleryRefinementNotify026(dt: Dt) {
  dt.log.i('图库照片页连续不停的滑动100次，每次滑动至少一屏以上（日视图四宫格） start');
  dt.log.i('STEP 1、打开图库照片页，四宫格界面 ，反复滑动100次，每次滑动1屏以上（若已经滑到底部，则从下往上继续滑动）');

  await dt.sleep();
  dt.log.i('STEP 2、查看图库各界面显示');

  await dt.sleep();
  dt.log.i('预期结果2、照片页正常缩略图刷新且顶部数字正常变化，相册页的相册封面正常刷新，且相册的数量正常变化');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库照片页连续不停的滑动100次，每次滑动至少一屏以上（日视图四宫格） end');
}
