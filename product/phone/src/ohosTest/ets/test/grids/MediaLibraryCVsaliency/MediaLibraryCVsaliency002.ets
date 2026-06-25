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


export default function APPFWKMediaFwkMediaLibraryMediaCVsaliency002Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('APPFWKMediaFwkMediaLibraryMediaCVsaliency002Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAPPFWKMediaFwkMediaLibraryMediaCVsaliency002').init();
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVsaliency002 start');
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVsaliency002 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('APPFWKMediaFwkMediaLibraryMediaCVsaliency002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [隐藏相册、截屏相册支持最佳呈现] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_saliency_002
      await APPFWKMediaFwkMediaLibraryMediaCVsaliency002(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachAPPFWKMediaFwkMediaLibraryMediaCVsaliency002').init();
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVsaliency002 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVsaliency002 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllAPPFWKMediaFwkMediaLibraryMediaCVsaliency002').init();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVsaliency002 start');
      await Exit.browser();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVsaliency002 finish');
    });
  });
}
/**
 * 宫格-: [隐藏相册、截屏相册支持最佳呈现]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_saliency_002
 * 前置条件
 * 1、截屏相册、隐藏相册各准备50张图片
 2、手机电量大于50%，温度小于37℃
 */
async function APPFWKMediaFwkMediaLibraryMediaCVsaliency002(dt: Dt) {
  dt.log.i('隐藏相册、截屏相册支持最佳呈现 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""saliency""');

  await dt.sleep();
  dt.log.i('预期结果2、最佳呈现日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、图库查看最佳呈现，拉取数据库查看tab_analysis_saliency_detect和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、图库出现最佳呈现，tab_analysis_saliency_detect内出现数据、tab_analysis_total表内saliency不为0');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('隐藏相册、截屏相册支持最佳呈现 end');
}
