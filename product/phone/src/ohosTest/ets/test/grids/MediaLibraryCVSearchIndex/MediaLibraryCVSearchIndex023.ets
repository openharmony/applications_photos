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


export default function APPFWKMediaFwkMediaLibraryMediaCVSearchIndex023Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('APPFWKMediaFwkMediaLibraryMediaCVSearchIndex023Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAPPFWKMediaFwkMediaLibraryMediaCVSearchIndex023').init();
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex023 start');
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex023 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('APPFWKMediaFwkMediaLibraryMediaCVSearchIndex023', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-删除用例: [删除时刻内的图片剩余8张及以上，时刻数据正确写入大搜数据库，可以搜索到该时刻] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_SearchIndex_023
      await APPFWKMediaFwkMediaLibraryMediaCVSearchIndex023(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachAPPFWKMediaFwkMediaLibraryMediaCVSearchIndex023').init();
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVSearchIndex023 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVSearchIndex023 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllAPPFWKMediaFwkMediaLibraryMediaCVSearchIndex023').init();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex023 start');
      await Exit.browser();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex023 finish');
    });
  });
}
/**
 * 宫格-删除: [删除时刻内的图片剩余8张及以上，时刻数据正确写入大搜数据库，可以搜索到该时刻]
 * GROUP: 宫格 MODULE: 删除TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_SearchIndex_023
 * 前置条件
 * 1、手机电量大于50%
 2、手机已生成时刻
 */
async function APPFWKMediaFwkMediaLibraryMediaCVSearchIndex023(dt: Dt) {
  dt.log.i('删除时刻内的图片剩余8张及以上，时刻数据正确写入大搜数据库，可以搜索到该时刻 start');
  dt.log.i('STEP 1、删除时刻内图片，剩余8张及以上');

  await dt.sleep();
  dt.log.i('STEP 2、充电息屏，等待索引构建完成');

  await dt.sleep();
  dt.log.i('STEP 3、拉取大搜数据库，查看相关字段：storyAlbumName');

  await dt.sleep();
  dt.log.i('预期结果3、数据库中，时刻相册内对应图片，字段storyAlbumName正确写入');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 4、图库搜索时刻名称');

  await dt.sleep();
  dt.log.i('预期结果4、搜索到对应时刻');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('删除时刻内的图片剩余8张及以上，时刻数据正确写入大搜数据库，可以搜索到该时刻 end');
}
