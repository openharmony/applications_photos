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

export default function MultimediaGalleryPhotoPickerPlayerStatus(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryPhotoPickerPlayerStatusTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryPhotoPickerPlayerStatus').init();
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerPlayerStatus start');
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerPlayerStatus finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryPhotoPickerPlayerStatus', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryPhotoPickerPlayerStatus0100', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放中检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0100
      await MultimediaGalleryPhotoPickerPlayerStatus0100(dt);
    });
    run('MultimediaGalleryPhotoPickerPlayerStatus0101', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放中暂停播放检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0101
      await MultimediaGalleryPhotoPickerPlayerStatus0101(dt);
    });
    run('MultimediaGalleryPhotoPickerPlayerStatus0102', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进度条用例: [视频播放中开始拖动进度条检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0102
      await MultimediaGalleryPhotoPickerPlayerStatus0102(dt);
    });
    run('MultimediaGalleryPhotoPickerPlayerStatus0103', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进度条用例: [视频播放暂停开始拖动进度条检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0103
      await MultimediaGalleryPhotoPickerPlayerStatus0103(dt);
    });
    run('MultimediaGalleryPhotoPickerPlayerStatus0104', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进度条用例: [视频播放中开始拖动进度条后结束拖动测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0104
      await MultimediaGalleryPhotoPickerPlayerStatus0104(dt);
    });
    run('MultimediaGalleryPhotoPickerPlayerStatus0105', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进度条用例: [视频播放暂停开始拖动进度条后结束拖动测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0105
      await MultimediaGalleryPhotoPickerPlayerStatus0105(dt);
    });
    run('MultimediaGalleryPhotoPickerPlayerStatus0106', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放完毕后重新播放检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0106
      await MultimediaGalleryPhotoPickerPlayerStatus0106(dt);
    });
    run('MultimediaGalleryPhotoPickerPlayerStatus0107', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放完毕后检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0107
      await MultimediaGalleryPhotoPickerPlayerStatus0107(dt);
    });
    run('MultimediaGalleryPhotoPickerPlayerStatus0108', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-进度条用例: [视频播放中拖拽进度条至播放完毕检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0108
      await MultimediaGalleryPhotoPickerPlayerStatus0108(dt);
    });
    run('MultimediaGalleryPhotoPickerPlayerStatus0109', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放中退后台，等待10S后重新拉到前台，检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0109
      await MultimediaGalleryPhotoPickerPlayerStatus0109(dt);
    });
    run('MultimediaGalleryPhotoPickerPlayerStatus0110', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放中退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0110
      await MultimediaGalleryPhotoPickerPlayerStatus0110(dt);
    });
    run('MultimediaGalleryPhotoPickerPlayerStatus0111', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放暂停中退后台，等待10S后重新拉到前台，检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0111
      await MultimediaGalleryPhotoPickerPlayerStatus0111(dt);
    });
    run('MultimediaGalleryPhotoPickerPlayerStatus0112', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放暂停中退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0112
      await MultimediaGalleryPhotoPickerPlayerStatus0112(dt);
    });
    run('MultimediaGalleryPhotoPickerPlayerStatus0113', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放停止退后台，等待10S后重新拉到前台，检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0113
      await MultimediaGalleryPhotoPickerPlayerStatus0113(dt);
    });
    run('MultimediaGalleryPhotoPickerPlayerStatus0114', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放停止退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0114
      await MultimediaGalleryPhotoPickerPlayerStatus0114(dt);
    });
    run('MultimediaGalleryPhotoPickerPlayerStatus0115', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放中退后台，点击打开图库，播放相同的视频，图库退后台，拉回demo到前台，检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0115
      await MultimediaGalleryPhotoPickerPlayerStatus0115(dt);
    });
    run('MultimediaGalleryPhotoPickerPlayerStatus0116', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [视频播放中退后台，点击打开音乐，播放音频，音乐退后台，拉回picker到前台检测回调状态] TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0116
      await MultimediaGalleryPhotoPickerPlayerStatus0116(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryPhotoPickerPlayerStatus').init();
      dt.log.i('afterEach MultimediaGalleryPhotoPickerPlayerStatus start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryPhotoPickerPlayerStatus finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryPhotoPickerPlayerStatus').init();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerPlayerStatus start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerPlayerStatus finish');
    });
  });
}

// DT步骤
/**
 * picker-视频: [视频播放中检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0100
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0100(dt: Dt) {
  dt.log.i('视频播放中检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为0-播放中');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中检测回调状态 end');
}

/**
 * picker-视频: [视频播放中暂停播放检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0101
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0101(dt: Dt) {
  dt.log.i('视频播放中暂停播放检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放后点击暂停');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为1-播放暂停中');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中暂停播放检测回调状态 end');
}

/**
 * picker-进度条: [视频播放中开始拖动进度条检测回调状态]
 * GROUP: picker MODULE: 进度条TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0102
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0102(dt: Dt) {
  dt.log.i('视频播放中开始拖动进度条检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放后拖动进度条');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为3-开始拖拽进度条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中开始拖动进度条检测回调状态 end');
}

/**
 * picker-进度条: [视频播放暂停开始拖动进度条检测回调状态]
 * GROUP: picker MODULE: 进度条TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0103
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0103(dt: Dt) {
  dt.log.i('视频播放暂停开始拖动进度条检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放后点击暂停，然后拖动进度条');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为3-开始拖拽进度条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放暂停开始拖动进度条检测回调状态 end');
}

/**
 * picker-进度条: [视频播放中开始拖动进度条后结束拖动测回调状态]
 * GROUP: picker MODULE: 进度条TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0104
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0104(dt: Dt) {
  dt.log.i('视频播放中开始拖动进度条后结束拖动测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放后拖动进度条，然后停止拖拽进度条');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为4-结束拖拽进度条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中开始拖动进度条后结束拖动测回调状态 end');
}

/**
 * picker-进度条: [视频播放暂停开始拖动进度条后结束拖动测回调状态]
 * GROUP: picker MODULE: 进度条TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0105
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0105(dt: Dt) {
  dt.log.i('视频播放暂停开始拖动进度条后结束拖动测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放后点击暂停，然后拖动进度条，然后停止拖拽进度条');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为4-结束拖拽进度条');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放暂停开始拖动进度条后结束拖动测回调状态 end');
}

/**
 * picker-视频: [视频播放完毕后重新播放检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0106
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0106(dt: Dt) {
  dt.log.i('视频播放完毕后重新播放检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放');

  await dt.sleep();
  dt.log.i('STEP 4.等待播放结束后重新点击播放');

  await dt.sleep();
  dt.log.i('预期结果4.demo中显示回调状态为0-播放中');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放完毕后重新播放检测回调状态 end');
}

/**
 * picker-视频: [视频播放完毕后检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0107
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0107(dt: Dt) {
  dt.log.i('视频播放完毕后检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放');

  await dt.sleep();
  dt.log.i('STEP 4.等待播放结束');

  await dt.sleep();
  dt.log.i('预期结果4.demo中显示回调状态为2-播放停止');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放完毕后检测回调状态 end');
}

/**
 * picker-进度条: [视频播放中拖拽进度条至播放完毕检测回调状态]
 * GROUP: picker MODULE: 进度条TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0108
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0108(dt: Dt) {
  dt.log.i('视频播放中拖拽进度条至播放完毕检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放，然后拖拽进度条至播放完毕');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为2-播放停止');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中拖拽进度条至播放完毕检测回调状态 end');
}

/**
 * picker-视频: [视频播放中退后台，等待10S后重新拉到前台，检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0109
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0109(dt: Dt) {
  dt.log.i('视频播放中退后台，等待10S后重新拉到前台，检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放，然后退demo到后台');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为0-播放中，且视频恢复正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.等待10S重新拉到前台');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中退后台，等待10S后重新拉到前台，检测回调状态 end');
}

/**
 * picker-视频: [视频播放中退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0110
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0110(dt: Dt) {
  dt.log.i('视频播放中退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放，然后退demo到后台，灭屏');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为0-播放中，且视频恢复正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.等待3min，亮屏，重新拉到前台');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态 end');
}

/**
 * picker-视频: [视频播放暂停中退后台，等待10S后重新拉到前台，检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0111
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0111(dt: Dt) {
  dt.log.i('视频播放暂停中退后台，等待10S后重新拉到前台，检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放然后暂停，然后退demo到后台');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为1-播放暂停，且视频还会处于播放暂停状态');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.等待10S重新拉到前台');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放暂停中退后台，等待10S后重新拉到前台，检测回调状态 end');
}

/**
 * picker-视频: [视频播放暂停中退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0112
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0112(dt: Dt) {
  dt.log.i('视频播放暂停中退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放，然后暂停，然后退demo到后台，灭屏');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为1-播放暂停，且视频还会处于播放暂停状态');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.等待3min，亮屏，重新拉到前台');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放暂停中退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态 end');
}

/**
 * picker-视频: [视频播放停止退后台，等待10S后重新拉到前台，检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0113
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0113(dt: Dt) {
  dt.log.i('视频播放停止退后台，等待10S后重新拉到前台，检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放等待视频播放结束，然后退demo到后台');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为2-播放停止，且视频还会处于播放完成状态');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.等待10S重新拉到前台');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放停止退后台，等待10S后重新拉到前台，检测回调状态 end');
}

/**
 * picker-视频: [视频播放停止退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0114
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0114(dt: Dt) {
  dt.log.i('视频播放停止退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放，播放视频停止，然后退demo到后台，灭屏');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为2-播放停止，且视频还会处于播放完成状态');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.等待3min，亮屏，重新拉到前台');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放停止退后台，灭屏等待3min后重新亮屏，并且拉到前台，检测回调状态 end');
}

/**
 * picker-视频: [视频播放中退后台，点击打开图库，播放相同的视频，图库退后台，拉回demo到前台，检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0115
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0115(dt: Dt) {
  dt.log.i('视频播放中退后台，点击打开图库，播放相同的视频，图库退后台，拉回demo到前台，检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放，然后退demo到后台');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为0-播放中，且视频恢复正常播放');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.点击图库，播放相同的视频');

  await dt.sleep();
  dt.log.i('STEP 5.图库退后台，拉回demo到前台');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中退后台，点击打开图库，播放相同的视频，图库退后台，拉回demo到前台，检测回调状态 end');
}

/**
 * picker-视频: [视频播放中退后台，点击打开音乐，播放音频，音乐退后台，拉回picker到前台检测回调状态]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPlayerStatus_0116
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPlayerStatus0116(dt: Dt) {
  dt.log.i('视频播放中退后台，点击打开音乐，播放音频，音乐退后台，拉回picker到前台检测回调状态 start');
  dt.log.i('STEP 1.点击demo label.hap');

  await dt.sleep();
  dt.log.i('STEP 2.点击视频，进入大图播放页');

  await dt.sleep();
  dt.log.i('STEP 3.点击播放，然后退demo到后台');

  await dt.sleep();
  dt.log.i('预期结果3.demo中显示回调状态为0-播放中，且视频恢复正常播放，音乐播放被打断');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.点击音乐，播放音频');

  await dt.sleep();
  dt.log.i('STEP 5.音乐退后台，拉回demo到前台');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('视频播放中退后台，点击打开音乐，播放音频，音乐退后台，拉回picker到前台检测回调状态 end');
}