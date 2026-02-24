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

import { afterAll, afterEach, beforeAll, describe, Level } from '@ohos/hypium';
import { Component, ON, WindowMode } from '@ohos.UiTest';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';

export default function photoBrowserFloatTest(): void {
  describe('PhotoBrowserFloatTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      await AppStart.photos();
      const dt = await new Dt('beforeAllPhotoBrowserFloatTest').init();
      dt.log.i('beforeAll PhotoBrowserFloatTest start');
      dt.log.i('beforeAll PhotoBrowserFloatTest finish');
    });
    it('beforePhotoBrowserFloatTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachPhotoBrowserFloatTest').init();
      // 执行用例完成之后; 循环返回直到大图界面, 仅冲刺阶段使用, 正式阶段应移除
      await dt.loopUntil('PhotoBrowserPreviewBar', async () => {
        await dt.pressBack();
        await dt.sleep(DELAY.long);
      }, 5);
      // 执行单个用例完成之后, 应保持在大图页面
      dt.log.i('afterEach PhotoBrowserFloatTest');
      const compId = 'PhotoBrowserPreviewBar';
      await dt.sleep();
      await dt.assertComponent(compId, true);
      dt.log.i('afterEach photoBrowserFloatTest finish');
    });
    // 退出大图 执行测试套完成之后, 应保持在大图页面
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllPhotoBrowserFloatTest').init();
      await Exit.browser();
      dt.log.i('afterAll PhotoBrowserFloatTest finish');
    });
  });
}
