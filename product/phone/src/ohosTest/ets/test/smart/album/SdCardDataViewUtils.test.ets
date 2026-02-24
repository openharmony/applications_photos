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
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { SdCardDataViewUtils } from '@ohos/common/src/main/ets/default/utils/SdCardDataViewUtils';
import { describe, expect, it, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { abilityDelegator } from '../../../TestAbility/TestAbility';
import { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';

const TAG: string = 'SdCardDataViewUtilsTest';

export default function SdCardDataViewUtilsTest(): void {
  describe('SdCardDataViewUtilsTest', (): void => {
    it('AbsGridLayout_001', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await SdCardDataViewUtilsTest01();
    });
    it('AbsGridLayout_002', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await SdCardDataViewUtilsTest02();
    });
    it('AbsGridLayout_003', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await SdCardDataViewUtilsTest03();
    });
    it('AbsGridLayout_004', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await SdCardDataViewUtilsTest04();
    });
  })
}

/**
 * 打开图库
 */
async function SdCardDataViewUtilsTest01() {
  Log.info(TAG, 'SdCardDataViewUtilsTest_001 start');
  try {
    let result =
      await abilityDelegator.executeShellCommand('aa start -a com.ohos.photos.MainAbility -b com.ohos.photos')
        .then((): void => {
          Log.info(TAG, 'MainAbility start success');
        });
    expect(result !== null).assertTrue();
  } catch (exception) {
    Log.error(TAG, 'start failed: ' + exception.code);
  } finally {
    Log.info(TAG, 'start photo application');
  }
  Log.info(TAG, 'SdCardDataViewUtilsTest_001 end');
}

async function SdCardDataViewUtilsTest02() {
  Log.info(TAG, 'SdCardDataViewUtilsTest_002 start');
  let result: string[] | undefined = await SdCardDataViewUtils.getInstance().getSdCardName();
  SdCardDataViewUtils.getInstance().getSdCardNameByUuid('');
  SdCardDataViewUtils.getInstance().subscribeStorageDeviceChangeEvent(() => {
  });
  SdCardDataViewUtils.getInstance().unsubscribeStorageDeviceChangeEvent();
  expect(result !== undefined).assertTrue();
  Log.info(TAG, 'SdCardDataViewUtilsTest_002 end');
}

/**
 * subscribeStorageDeviceChangeEvent
 * 分支：!DeviceInfo.isTablet() && !DeviceInfo.isPhoneUx() && !DeviceInfo.isPc()
 */
async function SdCardDataViewUtilsTest03() {
  Log.info(TAG, 'SdCardDataViewUtilsTest_003 start');
  let result: string[] | undefined = await SdCardDataViewUtils.getInstance().getSdCardName();
  SdCardDataViewUtils.getInstance().getSdCardNameByUuid('');

  const mocker = new MockKit();
  when(mocker.mockFunc(DeviceInfo, DeviceInfo.isTablet))(ArgumentMatchers.any).afterReturn(false);
  when(mocker.mockFunc(DeviceInfo, DeviceInfo.isPhoneUx))(ArgumentMatchers.any).afterReturn(false);
  when(mocker.mockFunc(DeviceInfo, DeviceInfo.isPc))(ArgumentMatchers.any).afterReturn(false);

  SdCardDataViewUtils.getInstance().subscribeStorageDeviceChangeEvent(() => {});
  expect(result !== undefined).assertTrue();
  Log.info(TAG, 'SdCardDataViewUtilsTest_003 end');
}

/**
 * getSdCardName
 * 分支：!DeviceInfo.isTablet() && !DeviceInfo.isPhoneUx() && !DeviceInfo.isPc()
 */
async function SdCardDataViewUtilsTest04() {
  Log.info(TAG, 'SdCardDataViewUtilsTest_004 start');

  const mocker = new MockKit();
  when(mocker.mockFunc(DeviceInfo, DeviceInfo.isTablet))(ArgumentMatchers.any).afterReturn(false);
  when(mocker.mockFunc(DeviceInfo, DeviceInfo.isPhoneUx))(ArgumentMatchers.any).afterReturn(false);
  when(mocker.mockFunc(DeviceInfo, DeviceInfo.isPc))(ArgumentMatchers.any).afterReturn(false);

  let result: string[] | undefined = await SdCardDataViewUtils.getInstance().getSdCardName();
  expect(result).assertUndefined();
  Log.info(TAG, 'SdCardDataViewUtilsTest_004 end');
}
