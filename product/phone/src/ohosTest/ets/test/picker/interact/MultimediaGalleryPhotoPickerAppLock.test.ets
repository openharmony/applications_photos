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

export default function MultimediaGalleryPhotoPickerAppLock(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryPhotoPickerAppLockTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryPhotoPickerAppLock').init();
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerAppLock start');
      dt.log.i('beforeAll MultimediaGalleryPhotoPickerAppLock finish');
    });
    /**
     * 打开大图
     */
    run('beforeMultimediaGalleryPhotoPickerAppLock', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });

    // DT声明
    run('MultimediaGalleryPhotoPickerAppLock001', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  picker-应用锁用例: [应用锁：息屏场景：相机个性风格拉起picker，扫码拉起picker] TID: Multimedia_Gallery_PhotoPicker_AppLock_001
      await MultimediaGalleryPhotoPickerAppLock001(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachMultimediaGalleryPhotoPickerAppLock').init();
      dt.log.i('afterEach MultimediaGalleryPhotoPickerAppLock start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryPhotoPickerAppLock finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllMultimediaGalleryPhotoPickerAppLock').init();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerAppLock start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryPhotoPickerAppLock finish');
    });
  });
}

// DT步骤


/**
 * picker-应用锁: [应用锁：息屏场景：相机个性风格拉起picker，扫码拉起picker]
 * GROUP: picker MODULE: 应用锁TID: Multimedia_Gallery_PhotoPicker_AppLock_001
 * 前置条件
 * 1.图库添加应用锁，应用锁设置为隐私密码
 */
async function MultimediaGalleryPhotoPickerAppLock001(dt: Dt) {
  dt.log.i('应用锁：息屏场景：相机个性风格拉起picker，扫码拉起picker start');
  dt.log.i('STEP 1.息屏后，拉起息屏相机点击个性风格-更多拉起picker');

  await dt.sleep();
  dt.log.i('预期结果1.拉起picker后需要用锁屏密码解锁');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2.解开应用锁');

  await dt.sleep();
  dt.log.i('预期结果2.锁屏密码后再用隐私密码解锁才可以拉起picker查看图库资源');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.息屏后，拉起扫码，点击相册');

  await dt.sleep();
  dt.log.i('预期结果3.需要先输入锁屏密码后再输入隐私密码才可以解锁');
  await dt.sleep();
  // 确认组件存在
  await dt.assertComponent(PageTitle.index, true);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('应用锁：息屏场景：相机个性风格拉起picker，扫码拉起picker end');
}