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

export default function MultimediaGalleryPhotoPickerWeChat(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryPhotoPickerWeChatTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryPhotoPickerWeChat').init();
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerWeChat start');
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerWeChat finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryPhotoPickerWeChat', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });


    // DT声明
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
    run('MultimediaGalleryPhotoPickerWeChat0207', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [相册页选择相册，接口返回当前相册的相册名称] TID: Multimedia_Gallery_PhotoPickerWeChat_0207
      await MultimediaGalleryPhotoPickerWeChat0207(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryPhotoPickerWeChat').init();
      dt.log.i('afterEach MultimediaGalleryPhotoPickerWeChat start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryPhotoPickerWeChat finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryPhotoPickerWeChat').init();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerWeChat start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerWeChat finish');
    });
  });
}

// DT步骤
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
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


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
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.点击滑动，滑动至已勾选的另一张图片');

  await dt.sleep();
  dt.log.i('预期结果4.预览页面底部当前正在预览图片的缩略图出现焦点');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


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
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('STEP 4.点击滑动，滑动至未勾选的另一张图片');

  await dt.sleep();
  dt.log.i('预期结果4.预览页面底部当前正在预览图片无所缩略图出现');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


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
 * picker-视频: [相册页选择相册，接口返回当前相册的相册名称]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerWeChat_0207
 * 前置条件
 * 1.图库中存在视频和图片
 */
async function MultimediaGalleryPhotoPickerWeChat0207(dt: Dt) {
  dt.log.i('相册页选择相册，接口返回当前相册的相册名称 start');
  dt.log.i('STEP 1.点击demo User.hap');

  await dt.sleep();
  dt.log.i('STEP 2.相册页，选择新建相册1');

  await dt.sleep();
  dt.log.i('预期结果2.页面中显示当前相册名称');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('相册页选择相册，接口返回当前相册的相册名称 end');
}