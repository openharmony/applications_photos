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


export default function APPFWKMediaFwkMediaLibraryMediaCVSearchIndex002Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('APPFWKMediaFwkMediaLibraryMediaCVSearchIndex002Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllAPPFWKMediaFwkMediaLibraryMediaCVSearchIndex002').init();
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex002 start');
      dt.log.i('beforeAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex002 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('APPFWKMediaFwkMediaLibraryMediaCVSearchIndex002', Level.LEVEL3, async (dt: Dt): Promise<void> => {
      //  宫格-视频用例: [接口支持任务可接续, 当任务因为亮屏或拔电被中断, 媒体库写入大搜数据库中断,
      //  下次时机具备并接续时, 可以接续进行写入] TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_SearchIndex_002
      await APPFWKMediaFwkMediaLibraryMediaCVSearchIndex002(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachAPPFWKMediaFwkMediaLibraryMediaCVSearchIndex002').init();
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVSearchIndex002 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach APPFWKMediaFwkMediaLibraryMediaCVSearchIndex002 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllAPPFWKMediaFwkMediaLibraryMediaCVSearchIndex002').init();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex002 start');
      await Exit.browser();
      dt.log.i('afterAll APPFWKMediaFwkMediaLibraryMediaCVSearchIndex002 finish');
    });
  });
}
/**
 * 宫格-视频: [接口支持任务可接续, 当任务因为亮屏或拔电被中断, 媒体库写入大搜数据库中断, 下次时机具备并接续时, 可以接续进行写入]
 * GROUP: 宫格 MODULE: 视频TID: APPFWK_MediaFwk__MediaLibrary_MediaCV_SearchIndex_002
 * 前置条件
 * 1、手机电量大于50%
 2、图片相册预置200张图片+4视频
 */
async function APPFWKMediaFwkMediaLibraryMediaCVSearchIndex002(dt: Dt) {
  dt.log.i('接口支持任务可接续, 当任务因为亮屏或拔电被中断, 媒体库写入大搜数据库中断, 下次时机具备并接续时, 可以接续进行写入 start');
  dt.log.i('STEP 1、充电息屏分析');

  await dt.sleep();
  dt.log.i('预期结果1）可以接续分析，出现日志打印');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、亮屏或拔电1）查看日志，亮屏任务中断： The process is about to end息屏任务开始：' +
    'doIndexOperation2）间隔一分钟两次拉取大搜数据库查看写入的图片信息');

  await dt.sleep();
  dt.log.i('STEP 3、继续充电息屏分析1）查看日志打印新增图片/视频插入索引数量：search index insert size' +
    '图片/视频索引信息更新数量：search index Update size2）拉取媒体库，查看索引状态表Photos3）拉取大搜数据库查看写入的图片信息');

  await dt.sleep();
  dt.log.i('预期结果3、1）可以接续分析，出现日志打印2）媒体数据库tab_analysis_search_index表中新增，' +
    'photo_status=1标识已注入基础信息cv_status=1标识已注入cv数据geo_status标识已注入地点数据息屏后会继续注入数据。' +
    '2）大搜数据库中新增内容信息');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('接口支持任务可接续, 当任务因为亮屏或拔电被中断, 媒体库写入大搜数据库中断, 下次时机具备并接续时, 可以接续进行写入 end');
}
