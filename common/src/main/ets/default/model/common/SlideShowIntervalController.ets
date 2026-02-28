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
/* instrument ignore file*/
import lazy common from '@ohos.app.ability.common';
import lazy settings from '@ohos.settings';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';

export enum SlideShowInterval {
  THREE = 3,
  FIVE = 5,
  TEN = 10,
  FIFTEEN = 15,
}

const TAG: string = 'SlideShowIntervalController';

export class SlideShowIntervalController {
  public static setSlideShowIntervalSettings(context: common.Context, interval: number): void {
    try {
      let result: boolean =
        settings.setValueSync(context, 'persist.photos.slideshow.interval', interval.toString());
      Log.info(TAG,
        `slideshow interval set as ${interval} ${result ? 'successfully' : 'failed'}`);
    } catch (err) {
      Log.error(TAG, `Set slideshow interval error: ${err}`);
    }
  }

  public static getSlideShowIntervalSettings(context: common.Context): number {
    try {
      let result: string =
        settings.getValueSync(context, 'persist.photos.slideshow.interval', '3');
      Log.info(TAG, `get slideshow interval is: ${result}`);
      return Number.parseInt(result);
    } catch (err) {
      Log.error(TAG, `Set slideshow interval error: ${err}`);
      return SlideShowInterval.THREE;
    }
  }
}