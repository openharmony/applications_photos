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


export default function APPFWKMediaFwkMediaLibraryMediaCVSearchIndex006Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('APPFWKMediaFwkMediaLibraryMediaCVSearchIndex006Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAPPFWKMediaFwkMediaLibraryMediaCVSearchIndex006').init();
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex006 start');
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex006 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('APPFWKMediaFwkMediaLibraryMediaCVSearchIndex006', Level.LEVEL2, async (dt: Dt): Promise<void> => {
      //  宫格-解析用例: [50张图片和4个视频完成cv分析和地理位置解析后，大搜数据库正确写入图片的基本信息、智慧分析结果、地理位置信息和其他信息] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_SearchIndex_006
      await APPFWKMediaFwkMediaLibraryMediaCVSearchIndex006(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachAPPFWKMediaFwkMediaLibraryMediaCVSearchIndex006').init();
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVSearchIndex006 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVSearchIndex006 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllAPPFWKMediaFwkMediaLibraryMediaCVSearchIndex006').init();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex006 start');
      await Exit.browser();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex006 finish');
    });
  });
}
/**
 * 宫格-解析: [50张图片和4个视频完成cv分析和地理位置解析后，大搜数据库正确写入图片的基本信息、智慧分析结果、地理位置信息和其他信息]
 * GROUP: 宫格 MODULE: 解析TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_SearchIndex_006
 * 前置条件
 * 1、手机电量大于50%
 2、图片相册预置50张图片和4个视频
 */
async function APPFWKMediaFwkMediaLibraryMediaCVSearchIndex006(dt: Dt) {
  dt.log.i('50张图片和4个视频完成cv分析和地理位置解析后，大搜数据库正确写入图片的基本信息、智慧分析结果、地理位置信息和其他信息 start');
  dt.log.i('STEP 1、充电息屏 ，实时查看日志，等待索引构建日志第二次出现');

  await dt.sleep();
  dt.log.i('STEP 2、拉取大搜数据库，查看数据库内各个字段');

  await dt.sleep();
  dt.log.i('预期结果2.大搜数据库内智慧分析表内各字段内有图片/视频信息被写入（视频信息的位置信息由于组件问题应该无法写入）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 3.根据图片/视频分类标签进行搜索');

  await dt.sleep();
  dt.log.i('预期结果3.搜索结果正确显示');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('50张图片和4个视频完成cv分析和地理位置解析后，大搜数据库正确写入图片的基本信息、智慧分析结果、地理位置信息和其他信息 end');
}