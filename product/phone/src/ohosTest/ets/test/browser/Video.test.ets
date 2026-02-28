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
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Component, ON } from '@ohos.UiTest';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';

const TAG: string = 'VideoTest';

export default function VideoTest(): void {
  describe('VideoTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAllVideoTest').init();
      dt.log.i('beforeAll VideoTest start');
      await AppStart.photos();
      dt.log.i('beforeAll VideoTest finish');
    });
    it('prepareVideoTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.prepareVideo(2000);
      await dt.assertComponent(PageTitle.index);
    });
    it('beforeBrowserTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
    });
    it('swipeToVideo', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browserToVideo();
    });
    it('PhotoBrowserTest_019', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await photoBrowserTest19(dt);
    });
    it('zoomBrowserTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await zoomBrowserTest(dt);
    });
    it('swipeBrowserTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await swipeBrowserTest(dt);
    })
    it('swipeBrowserDetailTest', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await swipeBrowserDetailTest(dt);
    })
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllVideoTest').init();
      await Exit.browser();
      dt.log.i('afterAll VideoTest finish');
    });
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachVideoTest').init();
      dt.log.i('afterEach VideoTest finish');
    });
  });
}


async function swipeToVideo(dt: Dt) {
  const SCREEN_SHOT = dt.button.videoScreenshot();
  Log.info(TAG, `swipeToVideo ${SCREEN_SHOT}`);
  for (
    let component: Component | undefined = await dt.driver.findComponent(ON.id(SCREEN_SHOT));
    !component;
    component = await dt.driver.findComponent(ON.id(SCREEN_SHOT))
  ) {
    Log.info(TAG, `swipeToVideo left`);
    await dt.swipeScreen?.left();
  }
  await dt.assertClick(SCREEN_SHOT);
  await dt.sleep();
  Log.info(TAG, `swipeToVideo end`);
}

/**
 * 1、点击大图 进入浏览模式
 * 2、双击放大
 * 3、左滑
 * 4、右滑
 * 5、双击缩小
 * 6、点击图片退出浏览模式 Task_002_tab_toggle
 */
async function zoomBrowserTest(dt: Dt) {
  dt.log.i('Task_002_Immersive_Test01 start');
  // 点击大图 进入浏览模式
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.driver.click(700, 500);
  await dt.driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  dt.log.i('photo click enter preview');
  await dt.driver.doubleClick(700, 1300);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('image doubleClick enter preview');
  await dt.driver.swipe(800, 1400, 750, 1400, 3000);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('swipe to left');
  await dt.driver.swipe(750, 1400, 800, 1400, 3000);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('swipe to right');
  await dt.driver.doubleClick(700, 1300);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('image doubleClick exit preview');
  await dt.driver.click(700, 1300);
  await dt.driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  dt.log.i('photo clicked exit preview');
  dt.log.i('Task_002_Immersive_Test01 end');
}

/**
 * 1、图片左滑
 * 2、图片右滑
 * 3、点击进入浏览模式
 * 4、图片左滑
 * 5、图片右滑
 * 6、退出浏览模式
 */
async function swipeBrowserTest(dt: Dt) {
  dt.log.i('Task_002_Immersive_Test02 start');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.driver.swipe(1050, 1350, 220, 1350, 3000);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('swipe to left');
  await dt.driver.swipe(220, 1350, 1050, 1350, 3000);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('swipe to right');
  await dt.driver.click(829, 2100);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('photo clicked enter preview');
  await dt.driver.swipe(1050, 1350, 220, 1350, 3000);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('swipe to left');
  await dt.driver.swipe(220, 1350, 1050, 1350, 3000);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('swipe to right');
  await dt.driver.click(829, 2100);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('photo clicked enter preview');
  dt.log.i('Task_002_Immersive_Test02 end');
}

/**
 * 1、图片左滑
 * 2、图片右滑
 * 3、图片上滑
 * 4、图片左滑
 * 5、图片右滑
 * 6、图片下滑
 */
async function swipeBrowserDetailTest(dt: Dt) {
  dt.log.i('Task_002_Immersive_Test02 start');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.driver.swipe(660, 1800, 660, 400, 3000);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('image swipe up');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.driver.swipe(1050, 1350, 220, 1350, 3000);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('swipe to left');
  await dt.driver.swipe(220, 1350, 1050, 1350, 3000);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('swipe to right');
  await dt.driver.swipe(660, 400, 660, 1800, 3000);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('image swipe down');
  await dt.driver.swipe(1050, 1350, 220, 1350, 3000);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('swipe to left');
  await dt.driver.swipe(220, 1350, 1050, 1350, 3000);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('swipe to right');
  dt.log.i('Task_002_Immersive_Test02 end');
}

/**
 * 1、点击图片详情
 * 2、点击返回(点击图片位置返回：规避os中pressBack的bug)
 */
async function photoBrowserTest18(dt: Dt) {
  dt.log.i('Task_002_ImageDetail_Test01 start');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick('More_Image_More');
  dt.log.i('buttonMore clicked');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick('ActionBarButton_Text_Info');
  dt.log.i('buttonInfo clicked');

  if (await dt.driver.findComponent(ON.id('content'))) {
    await dt.driver.pressBack();
  }
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.driver.pressBack();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('pressBack clicked');
  dt.log.i('Task_002_ImageDetail_Test01 end');
}

/**
 * 1、点击图片详情
 * 2、点击编辑
 * 3、点击返回
 * 4、点击图片隐藏详情
 * 5、上滑显示图片详情
 * 6、下滑隐藏图片详情
 */
async function photoBrowserTest19(dt: Dt) {
  dt.log.i('Task_002_ImageDetail_Test02 start');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick('More_Image_More');
  dt.log.i('buttonMore clicked');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  await dt.assertClick('ActionBarButton_Text_Info');
  dt.log.i('buttonInfo clicked');
  await dt.assertClick('PhotoDetailTitle');
  dt.log.i('photoDetailEdit clicked');
  await dt.driver.pressBack();
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('pressBack clicked');
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('actionBarButtonBack clicked');
  await dt.driver.click(700, 300);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('image clicked hide detail info');
  await dt.driver.swipe(660, 1800, 660, 400, 3000);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('image swipe up');
  await dt.driver.swipe(660, 400, 660, 1800, 3000);
  await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  dt.log.i('image swipe down');
  dt.log.i('Task_002_ImageDetail_Test02 end');
}