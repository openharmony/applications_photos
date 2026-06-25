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
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';


export default function multimediaEditorSecurity004572954Test(): void {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  // Presets an action, which is performed only once before all test cases of the test suite start.
  // This API supports only one parameter: preset action function.
  describe('MultimediaEditorSecurity004572954Test', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllMultimediaEditorSecurity004572954').init();
      dt.log.i('beforeAll MultimediaEditorSecurity004572954 start');
      dt.log.i('beforeAll MultimediaEditorSecurity004572954 finish');
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    /**
     * 打开大图
     */
    run('MultimediaEditorSecurity004572954', Level.LEVEL0, async (dt: Dt): Promise<void> => {
  //  宫格-用例: [图库权限弹框（存储权限）] TID: Multimedia_Editor_Security_004_572_954
      await multimediaEditorSecurity004572954(dt);
    });
    /**
     * 确保每次测试完毕回到大图页
     */
    afterEach(async (): Promise<void> => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterEachMultimediaEditorSecurity004572954').init();
      dt.log.i('afterEach MultimediaEditorSecurity004572954 start');
      await dt.sleep(DELAY.short);
      dt.log.i('afterEach MultimediaEditorSecurity004572954 finish');
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      const dt = await new Dt('afterAllMultimediaEditorSecurity004572954').init();
      dt.log.i('afterAll MultimediaEditorSecurity004572954 start');
      await Exit.browser();
      dt.log.i('afterAll MultimediaEditorSecurity004572954 finish');
    });
  });
}
/**
 * 宫格-: [图库权限弹框（存储权限）]
 * GROUP: 宫格 MODULE: TID: Multimedia_Editor_Security_004_572_954
 * 前置条件
 * 1、应用涉及申请敏感权限
 */
async function multimediaEditorSecurity004572954(dt: Dt) {
  dt.log.i('图库权限弹框（存储权限） start');
  dt.log.i('STEP 1、设置-应用管理-图库-权限');

  await dt.sleep();
  dt.log.i('预期结果1、权限关闭，需要重新弹框');
  await dt.sleep(DELAY.short);
  dt.log.i('STEP 2、关闭存储权限');

  await dt.sleep();
  dt.log.i('STEP 3、开启存储权限');

  await dt.sleep();


  dt.log.i('操作结束, 开始验证预期组件: 包含是否激活(enable), 是否可点击(clickable). ');
  // 打印当前存在compid的组件
  await dt.showComponentsWithin();
  // 使用 await dt.assertComponentClickable()和dt.assertComponent()确认组件存在
  dt.log.i('图库权限弹框（存储权限） end');
}