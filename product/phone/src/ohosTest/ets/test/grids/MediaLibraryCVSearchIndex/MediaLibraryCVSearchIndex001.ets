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


export default function APPFWKMediaFwkMediaLibraryMediaCVSearchIndex001Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('APPFWKMediaFwkMediaLibraryMediaCVSearchIndex001Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAPPFWKMediaFwkMediaLibraryMediaCVSearchIndex001').init();
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex001 start');
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex001 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('APPFWKMediaFwkMediaLibraryMediaCVSearchIndex001', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [手机息屏、充电、电量>50%，智慧分析对接大搜正常启动，数据写入大搜数据库]
      //  TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_SearchIndex_001
      await APPFWKMediaFwkMediaLibraryMediaCVSearchIndex001(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachAPPFWKMediaFwkMediaLibraryMediaCVSearchIndex001').init();
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVSearchIndex001 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVSearchIndex001 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllAPPFWKMediaFwkMediaLibraryMediaCVSearchIndex001').init();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex001 start');
      await Exit.browser();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex001 finish');
    });
  });
}
/**
 * 宫格-视频: [手机息屏、充电、电量>50%，智慧分析对接大搜正常启动，数据写入大搜数据库]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_SearchIndex_001
 * 前置条件
 * 1、手机电量大于50%
 2、图片相册预置200张图片+4视频
 */
async function APPFWKMediaFwkMediaLibraryMediaCVSearchIndex001(dt: Dt) {
  dt.log.i('手机息屏、充电、电量>50%，智慧分析对接大搜正常启动，数据写入大搜数据库 start');
  dt.log.i('STEP 1、充电，息屏，cmd界面实时查看CV分析处理日志： hdc  shell hilog  | grep  ""MediaCV"" 开始注入： ' +
    'doIndexOperation结束注入：doIndexOperation end新增图片/视频插入索引数量：' +
    'search index insert size图片/视频索引信息更新数量：search index Update size');

  await dt.sleep();
  dt.log.i('预期结果1、有日志打印，数据开始写入大搜数据库');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、等待5分钟，拉取媒体数据库和大搜数据库查看智慧分析表内各字段');

  await dt.sleep();
  dt.log.i('预期结果2、1）媒体数据库tab_analysis_search_index表，' +
    'photo_status=1标识已注入基础信息cv_status=1标识已注入cv数据' +
    'geo_status标识已注入地点数据大搜数据库的智慧分析表内各字段内有图片信息被写入');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('手机息屏、充电、电量>50%，智慧分析对接大搜正常启动，数据写入大搜数据库 end');
}
