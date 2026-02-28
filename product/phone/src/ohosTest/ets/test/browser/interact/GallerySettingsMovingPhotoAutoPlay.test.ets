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
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { AppStart } from '@ohos/tools/src/ohosTest/ets/AppStart.test';
import { Exit } from '@ohos/tools/src/ohosTest/ets/Exit';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { DELAY } from '@ohos/tools/src/ohosTest/ets/Config.test';
import { UiComponentId } from '../../utils/UiComponentId';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';

export default function GallerySettingsMovingPhotoAutoPlay(): void {


  describe('GallerySettingsMovingPhotoAutoPlay', (): void => {
    /**
     * 确认当前图库app处于启动状态
     */
    beforeAll(async (): Promise<void> => {
      const dt = await new Dt('beforeAllGallerySettingsMovingPhotoAutoPlay').init();
      dt.log.i('beforeAll GallerySettingsMovingPhotoAutoPlay start');
      await AppStart.photos();
      dt.log.i('beforeAll GallerySettingsMovingPhotoAutoPlay finish');
    });

    /**
     * 打开设置，自动播放动态照片
     */
    it('autoPlayMovingPhotoToggleSwitch', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.sleep(TestConstants.DELAY_ONE_SECOND);
      await dt.timeline();
      await dt.assertClick(UiComponentId.PHOTOS_MORE, true, DELAY.default);
      dt.log.i('moreButton clicked');
      await dt.assertClick(UiComponentId.PHOTOS_MORE_SETTING, true, DELAY.default);
      dt.log.i('settingButton clicked');
      await dt.clickIfExistByText("同意", DELAY.short);
      await dt.assertClick(UiComponentId.AUTO_PLAY_MOVING_PHOTO_SETTING, true, DELAY.default);
      dt.log.i('autoPlayMovingPhotoToggle clicked 1');
      await dt.assertClick(UiComponentId.AUTO_PLAY_MOVING_PHOTO_SETTING, true, DELAY.default);
      dt.log.i('autoPlayMovingPhotoToggle clicked 2');
      await dt.keyBack();
    });

    /**
     * 打开大图，滑动播放
     */
    it('MovingPhotoSwipePlay', Level.LEVEL0, async (dt: Dt): Promise<void> => {
      await dt.browser();
      await dt.sleep(TestConstants.DELAY_ONE_SECOND);
      await swipePlay(dt);
      dt.log.i('swipePlay');
      await dt.sleep(TestConstants.DELAY_ONE_SECOND);
      await Exit.browser();
    });

    /**
     * 确保照片页面
     */
    afterEach(async (): Promise<void> => {
      const dt = await new Dt('afterEachGallerySettingsMovingPhotoAutoPlay').init();
      dt.log.i('afterEach GallerySettingsMovingPhotoAutoPlay start');
      await dt.mustAtTimeline();
      dt.log.i('afterEach GallerySettingsMovingPhotoAutoPlay finish');
    });

    /**
     * 确保照片页面
     */
    afterAll(async (): Promise<void> => {
      const dt = await new Dt('afterAllGallerySettingsMovingPhotoAutoPlay').init();
      dt.log.i('afterAll GallerySettingsMovingPhotoAutoPlay start');
      await dt.mustAtTimeline();
      dt.log.i('afterAll GallerySettingsMovingPhotoAutoPlay finish');
    });
  });
}

async function swipePlay(dt: Dt) {
  dt.log.i('showProperties start');
  if (await dt.isLivePhoto()) {
    await dt.assertComponent('movingPhoto');
    await dt.swipeScreen?.left();
    await dt.wait(TestConstants.DELAY_THREE_SECOND);
    await dt.swipeScreen?.right();
  } else {
    dt.log.w('current photo is not livePhoto');
  }
  dt.log.i('showProperties end');
}