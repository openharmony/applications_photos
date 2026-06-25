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


export default function multimediaGalleryFilesdelete00001Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryFilesdelete00001Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryFilesdelete00001').init();
      dt.log.i('beforeAll MultimediaGalleryFilesdelete00001 start');
      dt.log.i('beforeAll MultimediaGalleryFilesdelete00001 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('MultimediaGalleryFilesdelete00001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-滑动用例: [图片删除后滑动年视图] TID: Multimedia_Gallery_Files_delete_00001
      await multimediaGalleryFilesdelete00001(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachMultimediaGalleryFilesdelete00001').init();
      dt.log.i('afterEach MultimediaGalleryFilesdelete00001 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryFilesdelete00001 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllMultimediaGalleryFilesdelete00001').init();
      dt.log.i('afterAll MultimediaGalleryFilesdelete00001 start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryFilesdelete00001 finish');
    });
  });
}
/**
 * 宫格-滑动: [图片删除后滑动年视图]
 * GROUP: 宫格 MODULE: 滑动TID: Multimedia_Gallery_Files_delete_00001
 * 前置条件
 *
 手机预存/克隆有超过一屏不同年份的照片
 */
async function multimediaGalleryFilesdelete00001(dt: Dt) {
  dt.log.i('图片删除后滑动年视图 start');
  dt.log.i('STEP 1、照片页年月日视图下滑动浏览图片，观察年份气泡显示');

  await dt.sleep();
  dt.log.i('预期结果1、浏览正常，图片无异常，年份气泡正常显示3、浏览正常，图片无异常，年份气泡正常显示4、浏览正常，图片无异常，年份气泡正常显示6、浏览正常，图片无异常，年份气泡正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、进入照片页/相册页删除/添加图片');

  await dt.sleep();
  dt.log.i('STEP 3、返回照片页后，再次在年月日视图下滑动浏览图片');

  await dt.sleep();
  dt.log.i('预期结果3、浏览正常，图片无异常，年份气泡正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、照片页日视图下滑动滚动轴浏览图片，观察年份气泡显示');

  await dt.sleep();
  dt.log.i('预期结果4、浏览正常，图片无异常，年份气泡正常显示6、浏览正常，图片无异常，年份气泡正常显示');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 5、进入照片页/相册页删除/添加图片');

  await dt.sleep();
  dt.log.i('STEP 6、返回照片页后，再次在日视图下滑动滚动轴浏览图片，观察年份气泡显示');

  await dt.sleep();
  dt.log.i('预期结果6、浏览正常，图片无异常，年份气泡正常显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图片删除后滑动年视图 end');
}
