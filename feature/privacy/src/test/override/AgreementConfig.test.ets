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

import { afterEach, beforeEach, describe, it, MockKit } from '@ohos/hypium';
import { AgreementConfig } from '../../main/ets/about/AgreementConfig';

export default function setAgreedTest() {
  describe('setAgreed_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_and_set_agreed_when_agreed_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();

      await AgreementConfig.setAgreed(true);


    });

    it('should_log_info_and_set_agreed_when_agreed_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();

      await AgreementConfig.setAgreed(false);


    });
  });
}