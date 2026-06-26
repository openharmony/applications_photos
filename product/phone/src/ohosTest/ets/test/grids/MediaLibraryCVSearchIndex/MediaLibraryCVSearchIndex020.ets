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


export default function APPFWKMediaFwkMediaLibraryMediaCVSearchIndex020Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('APPFWKMediaFwkMediaLibraryMediaCVSearchIndex020Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAPPFWKMediaFwkMediaLibraryMediaCVSearchIndex020').init();
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex020 start');
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex020 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('APPFWKMediaFwkMediaLibraryMediaCVSearchIndex020', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-收藏用例: [收藏一个/多个已分析的图片/视频，大搜数据库更新对应图片/视频数据] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_SearchIndex_020
      await APPFWKMediaFwkMediaLibraryMediaCVSearchIndex020(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachAPPFWKMediaFwkMediaLibraryMediaCVSearchIndex020').init();
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVSearchIndex020 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVSearchIndex020 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllAPPFWKMediaFwkMediaLibraryMediaCVSearchIndex020').init();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex020 start');
      await Exit.browser();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex020 finish');
    });
  });
}
/**
 * 宫格-收藏: [收藏一个/多个已分析的图片/视频，大搜数据库更新对应图片/视频数据]
 * GROUP: 宫格 MODULE: 收藏TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_SearchIndex_020
 * 前置条件
 * 1、手机电量大于50%
 2、图片/视频相册有已分析图片/视频10个
 */
async function APPFWKMediaFwkMediaLibraryMediaCVSearchIndex020(dt: Dt) {
  dt.log.i('收藏一个/多个已分析的图片/视频，大搜数据库更新对应图片/视频数据 start');
  dt.log.i('STEP 1、图片/视频相册收藏一个图片/视频');

  await dt.sleep();
  dt.log.i('STEP 2、充电息屏，等待智慧分析整体进程结束');

  await dt.sleep();
  dt.log.i('STEP 3、拉取大搜数据库，查看数据库智慧分析表内字段值');

  await dt.sleep();
  dt.log.i('预期结果3、Photos表中，is_favourite=1、大搜数据库中收藏的图片/视频的数据被更新，更新的字段：albumName5、所有图片/视频的数据被更新');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、收藏所有图片/视频');

  await dt.sleep();
  dt.log.i('STEP 5、重复步骤2、3');

  await dt.sleep();
  dt.log.i('预期结果5、所有图片/视频的数据被更新');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('收藏一个/多个已分析的图片/视频，大搜数据库更新对应图片/视频数据 end');
}
