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
import { afterEach, ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from "@ohos/hypium";
import { LightGlimpseUtil } from '@ohos/common/src/main/ets/default/utils/LightGlimpseUtil';
import { systemParameter } from "@kit.BasicServicesKit";

const TAG: string = 'SkimmingRuleMgrTest';

const LIGHT_GLIMPSE_PROP: string = 'const.photo.light_glimpse_card.enable';
const LIGHT_GLIMPSE_ON: string = 'true';
const LIGHT_GLIMPSE_OFF: string = 'false';
const LIVE_CARD_PROP: string = 'persist.sys.fms.support.liveForm';
const LIVE_CARD_ON: string = '3';
const LIVE_CARD_OFF: string = '0';

const LIGHT_GLIMPSE_OVERFLOW_HEIGHT: string = 'const.photo.light_glimpse_card.overflow_height';
const LIGHT_GLIMPSE_DEFAULT_OVERFLOW_HEIGHT: string = '16';

export default function LightGlimpseUtilTest() {
  describe('LightGlimpseUtil', () => {
    it('getSystemLightGlimpseTest001', 0, () => {
      // !resultSet
      let expectRet: boolean = systemParameter.getSync(LIGHT_GLIMPSE_PROP, LIGHT_GLIMPSE_OFF) === LIGHT_GLIMPSE_ON &&
        systemParameter.getSync(LIVE_CARD_PROP, LIVE_CARD_OFF) === LIVE_CARD_ON;
      let actualRet: boolean = LightGlimpseUtil.getSystemLightGlimpse();

      expect(expectRet === actualRet).assertTrue();
    })

    it('getSystemLightGlimpseTest002', 0, () => {
      // !resultSet
      let expectRet: number =
        Number(systemParameter.getSync(LIGHT_GLIMPSE_OVERFLOW_HEIGHT, LIGHT_GLIMPSE_DEFAULT_OVERFLOW_HEIGHT));
      let actualRet: number = LightGlimpseUtil.getSystemLightGlimpseOverflowHeight();

      expect(expectRet === actualRet).assertTrue();
    })
  })
}