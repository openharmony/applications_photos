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
import { abilityDelegator, run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { Enter } from '@ohos/tools/src/ohosTest/ets/Enter';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';
import { UiComponentId } from '../../utils/UiComponentId';

export default function LivePhotoAutoPlay(): void {


  describe('LivePhotoAutoPlay', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAllLivePhotoAutoPlay').init();
      dt.log.i('beforeAll LivePhotoAutoPlay start');
      await AppStart.photos();
      dt.log.i('beforeAll LivePhotoAutoPlay finish');
    });

    /**
     * 打开大图
     */
    it('beforeLivePhotoAutoPlay', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.assertComponent(UiComponentId.PHOTOS_BROWSER_INFO_FOCUS_COLUMN);
    });

    /**
     * 长按播放
     */
    it('longPressFullPlay', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await longPressFullPlay(dt);
    });

    /**
     * 上滑详情
     */
    it('showProperties', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await showProperties(dt);
    });

    /**
     * 滑动播放
     */
    it('swipePlay', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await swipePlay(dt);
    });

    /**
     * 退出大图 回到时间线页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllLivePhotoAutoPlay').init();
      dt.log.i('afterAll LivePhotoAutoPlay start');
      await Exit.browser();
      dt.log.i('afterAll LivePhotoAutoPlay finish');
    });
  });
}

async function longPressFullPlay(dt: Dt) {
  dt.log.i('longPressFullPlay start');
  if (await dt.isLivePhoto()) {
    await dt.assertLongClickById('movingPhoto', DELAY.default);
  } else {
    dt.log.w('current photo is not livePhoto');
  }
  dt.log.i('longPressFullPlay end');
}

async function showProperties(dt: Dt) {
  dt.log.i('showProperties start');
  if (await dt.isLivePhoto()) {
    await dt.slideUpHalfScreen();
    await dt.wait(TestConstants.DELAY_THREE_SECOND);
    await dt.slideLeftFromScreen();
    await dt.wait(TestConstants.DELAY_THREE_SECOND);
  } else {
    dt.log.w('current photo is not livePhoto');
  }
  dt.log.i('showProperties end');
  await dt.assertComponent(UiComponentId.PHOTOS_BROWSER_INFO_FOCUS_COLUMN);
}

async function swipePlay(dt: Dt) {
  dt.log.i('showProperties start');
  if (await dt.isLivePhoto()) {
    await dt.slideTreasureBox();
    await dt.wait(TestConstants.DELAY_THREE_SECOND);
    await dt.slideTreasureBoxRight();
  } else {
    dt.log.w('current photo is not livePhoto');
  }
  dt.log.i('showProperties end');
}