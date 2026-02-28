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
import { afterEach, ArgumentMatchers, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { NetQualityUtil } from '@ohos/browsercommon/src/main/ets/default/utils/NetQualityUtil';

let netQualityUtil: NetQualityUtil | undefined = undefined;

export default function NetQualityUtilTest() {
  describe('NetQualityUtilTest', () => {

    beforeEach(() => {
      netQualityUtil = NetQualityUtil.getInstance();
    });

    afterEach(() => {
      (NetQualityUtil as ESObject).netQualityUtil = null as ESObject;
      netQualityUtil = undefined
    });

    it('getInstance', 0, () => {
      getInstance();
    });
    it('netType', 0, () => {
      netType();
    });
    it('netDownWidthAvg', 0, () => {
      netDownWidthAvg();
    });
    it('netDownRateAvg', 0, () => {
      netDownRateAvg();
    });
    it('netRttMsAvg', 0, () => {
      netRttMsAvg();
    });

  })
}

function getInstance() {
  if (netQualityUtil == undefined) {
    return;
  }
  NetQualityUtil.getInstance();
  (netQualityUtil as ESObject).dataQueue = null as ESObject;
  (NetQualityUtil as ESObject).netQualityUtil = netQualityUtil;
  NetQualityUtil.getInstance();
}

function netType() {
  if (netQualityUtil == undefined) {
    return;
  }
  let result: number = netQualityUtil.netType();
  expect(result).assertEqual(-1);
  let object: ESObject = new Object();
  object.pathType = 1;
  (netQualityUtil as ESObject).dataQueue.add(object)
  result = netQualityUtil.netType();
  expect(result).assertEqual(1);
}

function netDownWidthAvg() {
  if (netQualityUtil == undefined) {
    return;
  }
  let result: number = netQualityUtil.netDownWidthAvg();
  expect(result).assertEqual(0);
  let object: ESObject = new Object();
  object.linkDownBandwidth = 1;
  (netQualityUtil as ESObject).dataQueue.add(object)
  result = netQualityUtil.netDownWidthAvg();
  expect(result).assertEqual(1);
}

function netDownRateAvg() {
  if (netQualityUtil == undefined) {
    return;
  }
  let result: number = netQualityUtil.netDownRateAvg();
  expect(result).assertEqual(0);
  let object: ESObject = new Object();
  object.linkDownRate = 1;
  (netQualityUtil as ESObject).dataQueue.add(object)
  result = netQualityUtil.netDownRateAvg();
  expect(result).assertEqual(1);
}

function netRttMsAvg() {
  if (netQualityUtil == undefined) {
    return;
  }
  let result: number = netQualityUtil.netRttMsAvg();
  expect(result).assertEqual(0);
  let object: ESObject = new Object();
  object.rttMs = 1;
  (netQualityUtil as ESObject).dataQueue.add(object)
  result = netQualityUtil.netRttMsAvg();
  expect(result).assertEqual(1);
}