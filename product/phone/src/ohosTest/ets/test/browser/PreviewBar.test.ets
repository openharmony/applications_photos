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
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Component, ON, WindowMode } from '@ohos.UiTest';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Comp } from '@ohos/tools/src/ohosTest/ets/Comp';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';

export default function PreviewBarTest(): void {
  describe('PreviewBarTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAllPreviewBarTest').init();
      dt.log.i('beforeAll PreviewBarTest start');
      await AppStart.photos();
      dt.log.i('beforeAll PreviewBarTest finish');
    });
    it('beforeBrowserTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });
    it('PhotoBrowserPreviewBar', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await PhotoBrowserPreviewBar(dt);
    });
    it('PhotoBrowserPreviewBarRotate', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await PhotoBrowserPreviewBar(dt);
    }, {
      rotate: true,
    });
    it('swipeToVideo', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browserToVideo();
    });
    it('swipeToVideoPhotoBrowserPreviewBar', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      // 点击大图 进入浏览模式
      await swipeToVideoPhotoBrowserPreviewBar(dt);
    }, {
      rotate: true,
    });
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachPreviewBarTest').init();
      dt.log.i('afterEach PreviewBarTest');
      const compId = 'PhotoBrowserPreviewBar';
      await dt.sleep();
      await dt.assertComponent(compId, true);
      dt.log.i('afterEach PreviewBarTest finish');
    });
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllPreviewBarTest').init();
      await Exit.browser();
      dt.log.i('afterAll PreviewBarTest finish');
    });
  });
}

async function swipeToVideo(dt: Dt) {
  const SCREEN_SHOT = dt.button.videoScreenshot();
  for (
    let component: Component | undefined = undefined;
    !component;
    component = await dt.driver.findComponent(ON.id(SCREEN_SHOT))
  ) {
    await dt.swipeScreen?.left();
    dt.log.i('swiping to right');
  }
  dt.log.i('swiped to video');
  await dt.assertClick(SCREEN_SHOT);
  await dt.sleep();
}

async function swipeToVideoPhotoBrowserPreviewBar(dt: Dt): Promise<void> {
  // 点击大图 进入浏览模式
  await dt.driver.click(700, 500);
  await dt.sleep();
  dt.log.i('photo click enter preview');
  await dt.driver.click(700, 500);
  await dt.sleep();
  dt.log.i('photo click enter preview');
  await dt.sleep();
  await PhotoBrowserPreviewBar(dt);
}

async function PhotoBrowserPreviewBar(dt: Dt) {
  const compId = 'PhotoBrowserPreviewBar';
  dt.log.i(compId + 'started');
  const bar = await (new Comp(compId, dt.driver)).init();
  await bar.left(); //等价于 await bar.horizontal(0.9, 0.1);
  await bar.right();
  await bar.horizontal(0.45, 0.48);
  await bar.horizontal(0.52, 0.58);
  await bar.horizontal(0.3, 0.4);
  await bar.horizontal(0.6, 0.7);
  await bar.right();
  await bar.left();
  await bar.right();
  await bar.right();
  await bar.right();
}