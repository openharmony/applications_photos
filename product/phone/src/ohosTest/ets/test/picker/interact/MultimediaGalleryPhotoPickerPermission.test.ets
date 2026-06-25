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

export default function MultimediaGalleryPhotoPickerPermission(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryPhotoPickerPermissionTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryPhotoPickerPermission').init();
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerPermission start');
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerPermission finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryPhotoPickerPermission', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryPhotoPickerPermission0100', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-用例: [系统应用-备忘录使用模态picker选择相机拍摄的图片，图片单独授权] TID: Multimedia_Gallery_PhotoPickerPermission_0100
      await MultimediaGalleryPhotoPickerPermission0100(dt);
    });
    run('MultimediaGalleryPhotoPickerPermission0103', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      //  picker-用例: [系统应用-备忘录使用模态picker选择截屏保存的图片，图片单独授权] TID: Multimedia_Gallery_PhotoPickerPermission_0103
      await MultimediaGalleryPhotoPickerPermission0103(dt);
    });
    run('MultimediaGalleryPhotoPickerPermission0106', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [系统应用-备忘录使用模态picker选择相机录像的视频，视频单独授权] TID: Multimedia_Gallery_PhotoPickerPermission_0106
      await MultimediaGalleryPhotoPickerPermission0106(dt);
    });
    run('MultimediaGalleryPhotoPickerPermission0109', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [系统应用-备忘录使用模态picker选择录屏保存的视频，视频单独授权] TID: Multimedia_Gallery_PhotoPickerPermission_0109
      await MultimediaGalleryPhotoPickerPermission0109(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryPhotoPickerPermission').init();
      dt.log.i('afterEach MultimediaGalleryPhotoPickerPermission start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryPhotoPickerPermission finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryPhotoPickerPermission').init();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerPermission start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerPermission finish');
    });
  });
}

// DT步骤
/**
 * picker-: [系统应用-备忘录使用模态picker选择相机拍摄的图片，图片单独授权]
 * GROUP: picker MODULE: TID: Multimedia_Gallery_PhotoPickerPermission_0100
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPermission0100(dt: Dt) {
  dt.log.i('系统应用-备忘录使用模态picker选择相机拍摄的图片，图片单独授权 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('系统应用-备忘录使用模态picker选择相机拍摄的图片，图片单独授权 end');
}

/**
 * picker-: [系统应用-备忘录使用模态picker选择截屏保存的图片，图片单独授权]
 * GROUP: picker MODULE: TID: Multimedia_Gallery_PhotoPickerPermission_0103
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPermission0103(dt: Dt) {
  dt.log.i('系统应用-备忘录使用模态picker选择截屏保存的图片，图片单独授权 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('系统应用-备忘录使用模态picker选择截屏保存的图片，图片单独授权 end');
}

/**
 * picker-视频: [系统应用-备忘录使用模态picker选择相机录像的视频，视频单独授权]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPermission_0106
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPermission0106(dt: Dt) {
  dt.log.i('系统应用-备忘录使用模态picker选择相机录像的视频，视频单独授权 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('系统应用-备忘录使用模态picker选择相机录像的视频，视频单独授权 end');
}

/**
 * picker-视频: [系统应用-备忘录使用模态picker选择录屏保存的视频，视频单独授权]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPickerPermission_0109
 * 前置条件
 *
 */
async function MultimediaGalleryPhotoPickerPermission0109(dt: Dt) {
  dt.log.i('系统应用-备忘录使用模态picker选择录屏保存的视频，视频单独授权 start');


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('系统应用-备忘录使用模态picker选择录屏保存的视频，视频单独授权 end');
}