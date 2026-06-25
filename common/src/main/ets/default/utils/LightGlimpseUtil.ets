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

import { systemParameter } from '@kit.BasicServicesKit';
import { Log } from '@ohos/tools/src/main/utils/Log';

const TAG: string = 'LightGlimpseUtil';

const LIGHT_GLIMPSE_PROP: string = 'const.photo.light_glimpse_card.enable';
const LIGHT_GLIMPSE_ON: string = 'true';
const LIGHT_GLIMPSE_OFF: string = 'false';
const LIVE_CARD_PROP: string = 'persist.sys.fms.support.liveForm';
const LIVE_CARD_ON: string = '3';
const LIVE_CARD_OFF: string = '0';

const LIGHT_GLIMPSE_OVERFLOW_HEIGHT: string = 'const.photo.light_glimpse_card.overflow_height';
const LIGHT_GLIMPSE_DEFAULT_OVERFLOW_HEIGHT: string = '16';

export class LightGlimpseUtil {
  public static getSystemLightGlimpse(): boolean {
    let lightGlimpseEnable: boolean =
      systemParameter.getSync(LIGHT_GLIMPSE_PROP, LIGHT_GLIMPSE_OFF) === LIGHT_GLIMPSE_ON;
    let liveCardEnable: boolean =
      systemParameter.getSync(LIVE_CARD_PROP, LIVE_CARD_OFF) === LIVE_CARD_ON;
    return lightGlimpseEnable && liveCardEnable;
  }

  public static getSystemLightGlimpseOverflowHeight(): number {
    let overflowHeightStr: string =
      systemParameter.getSync(LIGHT_GLIMPSE_OVERFLOW_HEIGHT, LIGHT_GLIMPSE_DEFAULT_OVERFLOW_HEIGHT);
    Log.info(TAG, `getSystemLightGlimpseOverflowHeight: ${overflowHeightStr}`);
    return Number.parseInt(overflowHeightStr);
  }
}
