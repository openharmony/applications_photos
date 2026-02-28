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

export default function MultimediaGalleryPhotoPickerShare(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryPhotoPickerShareTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryPhotoPickerShare').init();
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerShare start');
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerShare finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryPhotoPickerShare', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryPhotoPickerShare001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-视频用例: [分享视频资源，picker拉起查看验证] TID: Multimedia_Gallery_PhotoPicker_Share_001
      await MultimediaGalleryPhotoPickerShare001(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryPhotoPickerShare').init();
      dt.log.i('afterEach MultimediaGalleryPhotoPickerShare start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryPhotoPickerShare finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryPhotoPickerShare').init();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerShare start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerShare finish');
    });
  });
}

// DT步骤
/**
 * picker-视频: [分享视频资源，picker拉起查看验证]
 * GROUP: picker MODULE: 视频TID: Multimedia_Gallery_PhotoPicker_Share_001
 * 前置条件
 * 1.分享到测试机任意一个以上视频（包含1个）
 */
async function MultimediaGalleryPhotoPickerShare001(dt: Dt) {
  dt.log.i('分享视频资源，picker拉起查看验证 start');
  dt.log.i('STEP 1.嵌入式picker如小红书，拉起picker');

  await dt.sleep();
  dt.log.i('STEP 2.查看图片和视频相册');

  await dt.sleep();
  dt.log.i('预期结果2.可以看到新增的分享视频');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.切换为分享相册查看');

  await dt.sleep();
  dt.log.i('预期结果3.分享相册内可以看到新增的分享过来的视频');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('分享视频资源，picker拉起查看验证 end');
}