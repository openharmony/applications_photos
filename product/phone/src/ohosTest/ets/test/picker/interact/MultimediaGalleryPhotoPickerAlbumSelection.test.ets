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

export default function MultimediaGalleryPhotoPickeAlbumSelection(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryPhotoPickeAlbumSelectionTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryPhotoPickeAlbumSelection').init();
      dt.log.i('beforeAll MultimediaGalleryPhotoPickeAlbumSelection start');
      dt.log.i('beforeAll MultimediaGalleryPhotoPickeAlbumSelection finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryPhotoPickeAlbumSelection', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryPhotoPickerAlbumSelection001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  picker-下载用例: [三方拉起picker，相册选择(如微信)] TID: Multimedia_Gallery_PhotoPicker_AlbumSelection_001
      await MultimediaGalleryPhotoPickerAlbumSelection001(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryPhotoPickeAlbumSelection').init();
      dt.log.i('afterEach MultimediaGalleryPhotoPickeAlbumSelection start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryPhotoPickeAlbumSelection finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryPhotoPickeAlbumSelection').init();
      dt.log.i('afterAll MultimediaGalleryPhotoPickeAlbumSelection start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryPhotoPickeAlbumSelection finish');
    });
  });
}

// DT步骤
/**
 * picker-下载: [三方拉起picker，相册选择(如微信)]
 * GROUP: picker MODULE: 下载TID: Multimedia_Gallery_PhotoPicker_AlbumSelection_001
 * 前置条件
 * 1、下载安装微信
 2、登录微信账号
 */
async function MultimediaGalleryPhotoPickerAlbumSelection001(dt: Dt) {
  dt.log.i('三方拉起picker，相册选择(如微信) start');
  dt.log.i('STEP 1、好友发消息界面，右下方加号,照片拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2、点击上方图片和视频，展开所有相册');

  await dt.sleep();
  dt.log.i('预期结果2、所有相册相册名以及资源数量全为白字显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('三方拉起picker，相册选择(如微信) end');
}