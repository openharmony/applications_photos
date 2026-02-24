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

import { Drv } from './Drv.test';
import { Dt } from './Dt';
import { abilityDelegator } from './Factory.test';
import { TestConstants } from './TestConstants';

export namespace Exit {
  /**
   * 点击返回， 返回到图片首页
   */
  export async function browser() {
    const dt = await new Dt('exitBrowser').init();
    await dt.assertComponentClickable('photoItem_Column');
    await dt.driver.pressBack();
    await dt.wait();
    await dt.driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    dt.log.i('pressBack');
    await dt.assertComponentClickable('TabPhotos');
    dt.log.i('Task end');
  }

  /**
   * 判断当前页面是否存在对应相册，不存在则往上或者往下滑动
   */
  export async function album(expectId: string, y1: number, y2: number) {
    const dt = await new Dt('exitAlbum').init();
    await dt.loopUntil(expectId, async () => {
      await dt.driver.swipe(800, y1, 800, y2, 800);
      await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    }, 10);
    await dt.driver.swipe(800, y1, 800, y2, 800);
    await dt.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    dt.log.i('exitAlbum Task end');
  }
}