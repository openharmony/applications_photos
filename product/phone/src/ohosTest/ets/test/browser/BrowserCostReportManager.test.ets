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
import { BrowserCostReportManager } from '@ohos/browsercommon/src/main/ets/default/utils/BrowserCostReportManager';
import { afterEach, ArgumentMatchers, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';

export default function BrowserCostReportManagerTest() {
  describe('BrowserCostReportManagerTest', () => {

    beforeEach(() => {
    });

    afterEach(() => {
    });

    it('requestImage', 0, () => {
      requestImage();
    });
  })
}

function requestImage() {
  let browserCostReportManager: BrowserCostReportManager = BrowserCostReportManager.getInstance();
  let mocker: MockKit = new MockKit();
  let mockfunc: Function =
    mocker.mockFunc(browserCostReportManager, (browserCostReportManager as ESObject).requestImageCountStep);
  browserCostReportManager.requestImage(500);
  browserCostReportManager.requestImage(1000);
  browserCostReportManager.requestImage(2000);
  browserCostReportManager.requestImage(4000);
  browserCostReportManager.requestImage(5000);
  mocker.ignoreMock(browserCostReportManager, (browserCostReportManager as ESObject).requestImageCountStep);
}
