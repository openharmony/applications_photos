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


export default function APPFWKMediaFwkMediaLibraryMediaCVsaliency010Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('APPFWKMediaFwkMediaLibraryMediaCVsaliency010Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAPPFWKMediaFwkMediaLibraryMediaCVsaliency010').init();
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVsaliency010 start');
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVsaliency010 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('APPFWKMediaFwkMediaLibraryMediaCVsaliency010', Level.LEVEL4, async (dt: Dt): Promise<void> => {
      //  宫格-用例: [多人像图片聚集或均匀分散时最佳呈现计算图片中心，数据库保存多人像图片中心坐标] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_saliency_010
      await APPFWKMediaFwkMediaLibraryMediaCVsaliency010(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachAPPFWKMediaFwkMediaLibraryMediaCVsaliency010').init();
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVsaliency010 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVsaliency010 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllAPPFWKMediaFwkMediaLibraryMediaCVsaliency010').init();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVsaliency010 start');
      await Exit.browser();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVsaliency010 finish');
    });
  });
}
/**
 * 宫格-: [多人像图片聚集或均匀分散时最佳呈现计算图片中心，数据库保存多人像图片中心坐标]
 * GROUP: 宫格 MODULE: TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_saliency_010
 * 前置条件
 * 1、手机电量大于50%，温度小于37℃
 2、图片相册预置多人像图片且多人像聚集在一块图片5张
 3、图片相册预置多人像图片且多人像均匀分散图片5张
 */
async function APPFWKMediaFwkMediaLibraryMediaCVsaliency010(dt: Dt) {
  dt.log.i('多人像图片聚集或均匀分散时最佳呈现计算图片中心，数据库保存多人像图片中心坐标 start');
  dt.log.i('STEP 1、充电息屏');

  await dt.sleep();
  dt.log.i('STEP 2、查看日志hdc  shell hilog  | grep  ""saliency""');

  await dt.sleep();
  dt.log.i('预期结果2、最佳呈现日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3、图库查看最佳呈现，拉取数据库查看tab_analysis_saliency_detect和tab_analysis_total表内各字段');

  await dt.sleep();
  dt.log.i('预期结果3、图库出现最佳呈现且图片中心显示多个人像的中心，tab_analysis_saliency_detect.saliency_x、tab_analysis_saliency_detect.saliency_y显示主体坐标，tab_analysis_total表内saliency=1');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('多人像图片聚集或均匀分散时最佳呈现计算图片中心，数据库保存多人像图片中心坐标 end');
}
