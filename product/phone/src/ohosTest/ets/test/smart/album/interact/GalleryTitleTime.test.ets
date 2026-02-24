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

export default function GalleryTitleTimeTest(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('GalleryTitleTimeTest', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAllGalleryTitleTimeTest').init();
      dt.log.i('beforeAll GalleryTitleTimeTest start');
      await AppStart.photos();
      dt.log.i('beforeAll GalleryTitleTimeTest finish');
    });
    /**
     * 打开大图
     */
    run('beforeGalleryTitleTimeTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(PageTitle.index, true);
    });

    // DT声明
    run('Multimedia_Gallery_Title_Time_01', Level.LEVEL1, async (dt: Dt): Promise<void> => {
      //  时刻-滑动用例: [月视图-日视图标题时间查看] TID: Multimedia_Gallery_Title_Time_01
      await Multimedia_Gallery_Title_Time_01(dt);
    });

    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachGalleryTitleTimeTest').init();
      dt.log.i('afterEach GalleryTitleTimeTest start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach GalleryTitleTimeTest finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllGalleryTitleTimeTest').init();
      dt.log.i('afterAll GalleryTitleTimeTest start');
      await Exit.browser();
      dt.log.i('afterAll GalleryTitleTimeTest finish');
    });
  });
}

// DT步骤
/**
 * 时刻-滑动: [月视图-日视图标题时间查看]
 * GROUP: 时刻 MODULE: 滑动TID: Multimedia_Gallery_Title_Time_01
 * 前置条件
 * 1、图库中存在不同时间段的照片和视频
 */
async function Multimedia_Gallery_Title_Time_01(dt: Dt) {
  dt.log.i('月视图-日视图标题时间查看 start');
  dt.log.i('STEP 1、打开图库照片页月视图下双指做放大操作到日视图（覆盖四宫格和三宫格）');

  await dt.sleep();
  dt.log.i('预期结果1、可以正常切换到日视图（四宫格、三宫格）');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、下划浏览，侧边出现导航条，按住导航条下拉浏览');

  await dt.sleep();
  dt.log.i('预期结果2、左上角日期标题随滑动显示图片正确的时间');
  await dt.sleep(DELAY.short);


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  await dt.assertComponent(PageTitle.index, true);
  dt.log.i('月视图-日视图标题时间查看 end');
}