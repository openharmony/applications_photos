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


export default function multimediaGalleryFilesdeleteSR20241202149659011Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaGalleryFilesdeleteSR20241202149659011Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaGalleryFilesdeleteSR20241202149659011').init();
      dt.log.i('beforeAll MultimediaGalleryFilesdeleteSR20241202149659011 start');
      dt.log.i('beforeAll MultimediaGalleryFilesdeleteSR20241202149659011 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('MultimediaGalleryFilesdeleteSR20241202149659011', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [图库清理界面] TID: Multimedia_Gallery_Files_delete_SR20241202149659_011
      await multimediaGalleryFilesdeleteSR20241202149659011(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachMultimediaGalleryFilesdeleteSR20241202149659011').init();
      dt.log.i('afterEach MultimediaGalleryFilesdeleteSR20241202149659011 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaGalleryFilesdeleteSR20241202149659011 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllMultimediaGalleryFilesdeleteSR20241202149659011').init();
      dt.log.i('afterAll MultimediaGalleryFilesdeleteSR20241202149659011 start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaGalleryFilesdeleteSR20241202149659011 finish');
    });
  });
}
/**
 * 宫格-删除: [图库清理界面]
 * GROUP: 宫格 MODULE: 删除TID: Multimedia_Gallery_Files_delete_SR20241202149659_011
 * 前置条件
 * 1、设置中有图库清理卡片
 */
async function multimediaGalleryFilesdeleteSR20241202149659011(dt: Dt) {
  dt.log.i('图库清理界面 start');
  dt.log.i('STEP 1、进入图库清理页，点击返回');

  await dt.sleep();
  dt.log.i('预期结果1、返回设置');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、在图库清理页，点击视频清理');

  await dt.sleep();
  dt.log.i('预期结果2、跳转到视频清理页面');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、在图库清理页，点击最近删除');

  await dt.sleep();
  dt.log.i('预期结果3、跳转到最近删除页面');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库清理界面 end');
}
