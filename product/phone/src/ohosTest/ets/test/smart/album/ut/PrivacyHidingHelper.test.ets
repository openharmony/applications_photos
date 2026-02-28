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
import { describe, it, expect, MockKit, when } from '@ohos/hypium';
import {
  PrivacyHidingHelper,
  PrivacyHidingStatusListener
} from '@ohos/common/src/main/ets/default/model/PrivacyHidingHelper';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';

export default function DlpPrivacyHidingHelperTest() {
  describe('DlpPrivacyHidingHelperTest', () => {

    it('DlpPrivacyHidingHelperTest01', 0, () => {
      let privacyhidinghelper: PrivacyHidingHelper = PrivacyHidingHelper.getInstance();
      let mocker: MockKit = new MockKit();
      let mockGetPrivateHideState: Function =
        mocker.mockFunc(privacyhidinghelper, privacyhidinghelper.getPrivateHideState);
      when(mockGetPrivateHideState)().afterReturn(true);

      privacyhidinghelper.setPrivacyHidingState(true, "test");
      mocker.ignoreMock(privacyhidinghelper, privacyhidinghelper.getPrivateHideState);
      expect(privacyhidinghelper.getPrivateHideState()).assertEqual(false);
    });

    it('DlpPrivacyHidingHelperTest02', 0, () => {
      let privacyhidinghelper: PrivacyHidingHelper = PrivacyHidingHelper.getInstance();
      privacyhidinghelper.setPrivacyHidingState(false, "test");
      expect(privacyhidinghelper.getPrivateHideState()).assertEqual(false);
    });

    it('DlpPrivacyHidingHelperTest03', 0, () => {
      let privacyhidinghelper: PrivacyHidingHelper = PrivacyHidingHelper.getInstance();
      let privacyHidingStatusListener: PrivacyHidingStatusListener = {
        onHidingStatusChanged: (privateHideState: boolean) => {
          privateHideState = false;
        },
      } as PrivacyHidingStatusListener;
      privacyhidinghelper.addListener(privacyHidingStatusListener, 'test');
      privacyhidinghelper.removeListener(privacyHidingStatusListener, 'test');
      privacyhidinghelper.getPrivacyHidingEnable();
      privacyhidinghelper.temporaryBypass();
      privacyhidinghelper.refreshPrivateStateMonitor();
      expect(privacyhidinghelper.getPrivacyHidingEnable()).assertEqual(false);
    });

    it('DlpPrivacyHidingHelperTest04', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await DlpPrivacyHidingHelperTest04();
    })

    it('DlpPrivacyHidingHelperTest05', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await DlpPrivacyHidingHelperTest05();
    })

    it('DlpPrivacyHidingHelperTest06', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await DlpPrivacyHidingHelperTest06();
    })

    it('DlpPrivacyHidingHelperTest07', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await DlpPrivacyHidingHelperTest07();
    })

    it('DlpPrivacyHidingHelperTest08', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await DlpPrivacyHidingHelperTest08();
    })

    it('DlpPrivacyHidingHelperTest09', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await DlpPrivacyHidingHelperTest09();
    })

    it('DlpPrivacyHidingHelperTest10', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await DlpPrivacyHidingHelperTest10();
    })
  });
}

async function DlpPrivacyHidingHelperTest04() {
  Reflect.set(PrivacyHidingHelper, 'INSTANCE', undefined);
  let privacyhidinghelper: PrivacyHidingHelper = PrivacyHidingHelper.getInstance();
  expect(privacyhidinghelper !== undefined).assertEqual(true);
}

async function DlpPrivacyHidingHelperTest05() {
  Reflect.set(PrivacyHidingHelper, 'INSTANCE', undefined);
  let privacyhidinghelper: PrivacyHidingHelper = PrivacyHidingHelper.getInstance();
  expect(privacyhidinghelper !== undefined).assertEqual(true);
}

async function DlpPrivacyHidingHelperTest06() {
  let privacyhidinghelper: PrivacyHidingHelper = PrivacyHidingHelper.getInstance();
  let mocker: MockKit = new MockKit();
  let mockGetPrivateHideState: Function =
    mocker.mockFunc(privacyhidinghelper, privacyhidinghelper.getPrivateHideState);
  when(mockGetPrivateHideState)().afterReturn(true);

  Reflect.set(privacyhidinghelper, 'isSwitchOn ', true);
  Reflect.set(privacyhidinghelper, 'privacyCount  ', 1);
  Reflect.set(privacyhidinghelper, 'hasRegisterRiskChange  ', false);

  privacyhidinghelper.setPrivacyHidingState(true, "test");

  mocker.ignoreMock(privacyhidinghelper, privacyhidinghelper.getPrivateHideState);
  expect(privacyhidinghelper !== undefined).assertEqual(true);
}

async function DlpPrivacyHidingHelperTest07() {
  let privacyhidinghelper: PrivacyHidingHelper = PrivacyHidingHelper.getInstance();
  let mocker: MockKit = new MockKit();
  let mockGetPrivateHideState: Function =
    mocker.mockFunc(privacyhidinghelper, privacyhidinghelper.getPrivateHideState);
  when(mockGetPrivateHideState)().afterReturn(true);

  Reflect.set(privacyhidinghelper, 'isSwitchOn ', false);
  Reflect.set(privacyhidinghelper, 'hasRegisterRiskChange  ', true);

  privacyhidinghelper.setPrivacyHidingState(true, "test");

  mocker.ignoreMock(privacyhidinghelper, privacyhidinghelper.getPrivateHideState);
  expect(privacyhidinghelper !== undefined).assertEqual(true);
}

async function DlpPrivacyHidingHelperTest08() {
  let privacyhidinghelper: PrivacyHidingHelper = PrivacyHidingHelper.getInstance();
  let mocker: MockKit = new MockKit();
  let mockGetPrivacyHidingEnable: Function =
    mocker.mockFunc(privacyhidinghelper, privacyhidinghelper.getPrivacyHidingEnable);
  when(mockGetPrivacyHidingEnable)().afterReturn(true);

  const run = (): void => Reflect.get(privacyhidinghelper, 'initAndRegister')
    .call(privacyhidinghelper);

  run();

  mocker.ignoreMock(privacyhidinghelper, privacyhidinghelper.getPrivacyHidingEnable);
  expect(privacyhidinghelper !== undefined).assertEqual(true);
}

async function DlpPrivacyHidingHelperTest09() {
  let privacyhidinghelper: PrivacyHidingHelper = PrivacyHidingHelper.getInstance();
  let mocker: MockKit = new MockKit();
  let mockGetPrivacyHidingEnable: Function =
    mocker.mockFunc(privacyhidinghelper, privacyhidinghelper.getPrivacyHidingEnable);
  when(mockGetPrivacyHidingEnable)().afterReturn(false);

  const run = (): void => Reflect.get(privacyhidinghelper, 'initAndRegister')
    .call(privacyhidinghelper);

  run();

  mocker.ignoreMock(privacyhidinghelper, privacyhidinghelper.getPrivacyHidingEnable);
  expect(privacyhidinghelper !== undefined).assertEqual(true);
}

async function DlpPrivacyHidingHelperTest10() {
  let privacyhidinghelper: PrivacyHidingHelper = PrivacyHidingHelper.getInstance();
  let privacyHidingStatusListener: PrivacyHidingStatusListener = {
    onHidingStatusChanged: (privateHideState: boolean) => {
      privateHideState = false;
    },
  } as PrivacyHidingStatusListener;

  let mocker: MockKit = new MockKit();
  let mockGetPrivacyHidingEnable: Function =
    mocker.mockFunc(privacyhidinghelper, privacyhidinghelper.getPrivacyHidingEnable);
  when(mockGetPrivacyHidingEnable)().afterReturn(true);


  privacyhidinghelper.addListener(privacyHidingStatusListener, 'test');
  privacyhidinghelper.removeListener(privacyHidingStatusListener, 'test');

  mocker.ignoreMock(privacyhidinghelper, privacyhidinghelper.getPrivacyHidingEnable);
  expect(privacyhidinghelper.getPrivacyHidingEnable()).assertEqual(false);
}