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

export default function MultimediaGalleryPhotoPickerPrivacy(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryPhotoPickerPrivacyTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryPhotoPickerPrivacy').init();
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerPrivacy start');
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerPrivacy finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryPhotoPickerPrivacy', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryPhotoPickerPrivacy0200', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [隐私空间，图片位置展示验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0200
      await MultimediaGalleryPhotoPickerPrivacy0200(dt);
    });
    run('MultimediaGalleryPhotoPickerPrivacy0201', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-进入大图用例: [隐私空间，不同图片类型展示验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0201
      await MultimediaGalleryPhotoPickerPrivacy0201(dt);
    });
    run('MultimediaGalleryPhotoPickerPrivacy0202', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-格式用例: [隐私空间，不同相册展示验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0202
      await MultimediaGalleryPhotoPickerPrivacy0202(dt);
    });
    run('MultimediaGalleryPhotoPickerPrivacy0203', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [隐私空间，排序规则验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0203
      await MultimediaGalleryPhotoPickerPrivacy0203(dt);
    });
    run('MultimediaGalleryPhotoPickerPrivacy0204', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-详情用例: [隐私空间，安全访问弹窗验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0204
      await MultimediaGalleryPhotoPickerPrivacy0204(dt);
    });
    run('MultimediaGalleryPhotoPickerPrivacy0205', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [隐私空间，图片选择数量限制验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0205
      await MultimediaGalleryPhotoPickerPrivacy0205(dt);
    });
    run('MultimediaGalleryPhotoPickerPrivacy0206', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  picker-格式用例: [隐私空间，相机入口、搜索入口、编辑入口不展示验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0206
      await MultimediaGalleryPhotoPickerPrivacy0206(dt);
    });
    run('MultimediaGalleryPhotoPickerPrivacy0207', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-动态照片用例: [隐私空间，角标展示验证] TID: Multimedia_Gallery_PhotoPickerPrivacy_0207
      await MultimediaGalleryPhotoPickerPrivacy0207(dt);
    });
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
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryPhotoPickerPrivacy').init();
      dt.log.i('afterEach MultimediaGalleryPhotoPickerPrivacy start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryPhotoPickerPrivacy finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryPhotoPickerPrivacy').init();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerPrivacy start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerPrivacy finish');
    });
  });
}

// DT步骤
/**
 * picker-下载: [隐私空间，图片位置展示验证]
 * GROUP: picker MODULE: 下载TID: Multimedia_Gallery_PhotoPickerPrivacy_0200
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在纯云端图片，云端下行且本地下载的图片，本地有但云端没有的图片
 3.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0200(dt: Dt) {
  dt.log.i('隐私空间，图片位置展示验证 start');
  dt.log.i('STEP 1.调起隐私空间内的picker，查看图片');

  await dt.sleep();
  dt.log.i('预期结果1.隐私空间内的纯云端的图库数据不展示，本地存在的图库数据展示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.打开隐私空间内的文件管理器，查看图片');

  await dt.sleep();
  dt.log.i('预期结果2.隐私空间内的文件管理中无法查看主空间的图库资源');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，图片位置展示验证 end');
}

/**
 * picker-进入大图: [隐私空间，不同图片类型展示验证]
 * GROUP: picker MODULE: 进入大图TID: Multimedia_Gallery_PhotoPickerPrivacy_0201
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在静态图片，连拍的图片，动态图片，以及视频
 3.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0201(dt: Dt) {
  dt.log.i('隐私空间，不同图片类型展示验证 start');
  dt.log.i('STEP 1.调起隐私空间内的picker ，查看图片');

  await dt.sleep();
  dt.log.i('预期结果1.静态照片，连拍照片，动态照片，视频均支持展示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击宫格页面动态图片进大图');

  await dt.sleep();
  dt.log.i('预期结果2.进入大图动态照片自动播放动态效果');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，不同图片类型展示验证 end');
}

/**
 * picker-格式: [隐私空间，不同相册展示验证]
 * GROUP: picker MODULE: 格式TID: Multimedia_Gallery_PhotoPickerPrivacy_0202
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在各种格式的图片及视频资源
 3.登录账号且有智慧相册，删除相册以及隐藏相册
 4.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0202(dt: Dt) {
  dt.log.i('隐私空间，不同相册展示验证 start');
  dt.log.i('STEP 1.调起隐私空间内的picker，切换到相册页');

  await dt.sleep();
  dt.log.i('STEP 2.向上滑动查看所有相册');

  await dt.sleep();
  dt.log.i('预期结果2.可以看到的相册有：视频相册，图片相册，收藏相册，自定义相册。 不可以看到的相册有智慧相册，删除相册，隐藏相册');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，不同相册展示验证 end');
}

/**
 * picker-视频: [隐私空间，排序规则验证]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPrivacy_0203
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在不同时间段的视频及图片
 3.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0203(dt: Dt) {
  dt.log.i('隐私空间，排序规则验证 start');
  dt.log.i('STEP 1.调起隐私空间内的picker，查看图片');

  await dt.sleep();
  dt.log.i('STEP 2.上划查看图片顺序');

  await dt.sleep();
  dt.log.i('预期结果2.排序顺序正常，和图库相册顺序保持一致');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，排序规则验证 end');
}

/**
 * picker-详情: [隐私空间，安全访问弹窗验证]
 * GROUP: picker MODULE: 详情TID: Multimedia_Gallery_PhotoPickerPrivacy_0204
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在不同时间段的视频及图片
 3.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0204(dt: Dt) {
  dt.log.i('隐私空间，安全访问弹窗验证 start');
  dt.log.i('STEP 1.第一次调起隐私空间内picker ');

  await dt.sleep();
  dt.log.i('预期结果1.上方展示有安全访问图库字段');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.不点击×，再次进入picker ');

  await dt.sleep();
  dt.log.i('预期结果2.仍然可以看到上方展示的有安全访问图库的字段');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.点击了解详情');

  await dt.sleep();
  dt.log.i('预期结果3.拉起安全详情弹窗');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4. 点击×，再次进入picker');

  await dt.sleep();
  dt.log.i('预期结果4.上方无展示安全访问图库的字段');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，安全访问弹窗验证 end');
}

/**
 * picker-视频: [隐私空间，图片选择数量限制验证]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPrivacy_0205
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在不同时间段的视频及图片超过100张
 3.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0205(dt: Dt) {
  dt.log.i('隐私空间，图片选择数量限制验证 start');
  dt.log.i('STEP 1.调起隐私空间内picker');

  await dt.sleep();
  dt.log.i('STEP 2.不选择图片');

  await dt.sleep();
  dt.log.i('预期结果2.完成按钮置灰');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.选择1张图片，点击完成。');

  await dt.sleep();
  dt.log.i('预期结果3.拉起弹窗');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4. 选择100张图片，点击完成');

  await dt.sleep();
  dt.log.i('预期结果4.拉起弹窗');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.选择101张图片，点击完成');

  await dt.sleep();
  dt.log.i('预期结果5.选择第100图片后，完成按钮置灰，且点击弹出toast提示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，图片选择数量限制验证 end');
}

/**
 * picker-格式: [隐私空间，相机入口、搜索入口、编辑入口不展示验证]
 * GROUP: picker MODULE: 格式TID: Multimedia_Gallery_PhotoPickerPrivacy_0206
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在各种格式的图片及视频资源
 3.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0206(dt: Dt) {
  dt.log.i('隐私空间，相机入口、搜索入口、编辑入口不展示验证 start');
  dt.log.i('STEP 1.调起隐私空间内picker ，并查看该界面');

  await dt.sleep();
  dt.log.i('预期结果1.无拍照功能，无搜索功能');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.点击图片进大图');

  await dt.sleep();
  dt.log.i('预期结果2.大图无编辑入口');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，相机入口、搜索入口、编辑入口不展示验证 end');
}

/**
 * picker-动态照片: [隐私空间，角标展示验证]
 * GROUP: picker MODULE: 动态照片TID: Multimedia_Gallery_PhotoPickerPrivacy_0207
 * 前置条件
 * 1.设置主空间与隐私空间密码
 2.图库中存在收藏的图片，动态照片以及gif图片
 3.隐私空间访问主空间，选择上述资源进行迁移
 */
async function MultimediaGalleryPhotoPickerPrivacy0207(dt: Dt) {
  dt.log.i('隐私空间，角标展示验证 start');
  dt.log.i('STEP 1.调起隐私空间内picker,如隐私空间内picker ，并查看该界面');

  await dt.sleep();
  dt.log.i('预期结果1.动态照片以及gif图片都有对应的角标展示。导入的收藏的照片只有在隐私空间拉起主空间的picker页面才可看到。');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间，角标展示验证 end');
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
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.选中一张被选中的大图，取消勾选框');

  await dt.sleep();
  dt.log.i('预期结果4.取消选中后的图片预览条不在显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 5.系统设置-开启图片HDR显示，回到picker 页面，点击图片进大图');

  await dt.sleep();
  dt.log.i('预期结果5.图片高亮显示');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


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
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.点击最近删除，查看图片');

  await dt.sleep();
  dt.log.i('预期结果4.最近删除无法查看到被迁移到隐私空间的图片');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


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
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.备忘录拉起picker选择被编辑的那张照片，点击编辑');

  await dt.sleep();
  dt.log.i('预期结果4.可以看到右上方有没有还原功能');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


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
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


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
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


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
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


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
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.主空间图库对这张照片进行设置壁纸');

  await dt.sleep();
  dt.log.i('预期结果4.设置壁纸成功');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐私空间图片迁移到主空间，编辑保存，设置为壁纸验证 end');
}