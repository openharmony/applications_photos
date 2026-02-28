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
import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { SettingCardAccess } from '../../../../../../main/ets/SettingCardDataShareAbility/SettingCardAccess';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import { common } from '@kit.AbilityKit';
import { abilityDelegator } from '../../../../TestAbility/TestAbility';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG = 'SettingCardAccessTest';

/**
 * Description.
 *
 * @since 2024-07-26
 */
export default function SettingCardAccessTest() {
  describe('SettingCardAccessTest', () => {
    it('SettingCardAccessTest_01', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await SettingCardAccessTest01();
    });

    it('SettingCardAccessTest_02', 0, async () => {
      let settingcardaccess: SettingCardAccess = SettingCardAccess.getInstance();
      let mocker: MockKit = new MockKit();
      let userFileManagerAccess: UserFileManagerAccess = UserFileManagerAccess.getInstance();
      let mockfunc: Function = mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.onCreate);
      when(mockfunc)(ArgumentMatchers.any).afterThrow("error");
      let callback: Function = () => {
      };
      let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
      if (context) {
        await settingcardaccess.fetchAssetsInfo('queryVideoSize', new dataSharePredicates.DataSharePredicates(),
          callback, context);
        mocker.ignoreMock(userFileManagerAccess, userFileManagerAccess.onCreate);
      }
      expect(context !== undefined).assertTrue();
    });

    it('SettingCardAccessTest_03', 0, async () => {
      let settingcardaccess: SettingCardAccess = SettingCardAccess.getInstance();
      let mocker: MockKit = new MockKit();
      let userFileManagerAccess: UserFileManagerAccess = UserFileManagerAccess.getInstance();
      let mockfunc1: Function = mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.onCreate);
      when(mockfunc1)(ArgumentMatchers.any).afterReturnNothing();
      let mockfunc2: Function = mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.getAllLocalVideoSize);
      when(mockfunc2)().afterThrow("error");
      let callback: Function = () => {
      };
      let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
      if (context) {
        await settingcardaccess.fetchAssetsInfo('queryVideoSize', new dataSharePredicates.DataSharePredicates(),
          callback, context);
        mocker.ignoreMock(userFileManagerAccess, userFileManagerAccess.onCreate);
        mocker.ignoreMock(userFileManagerAccess, userFileManagerAccess.getAllLocalVideoSize);
      }
      expect(context !== undefined).assertTrue();
    });

    it('SettingCardAccessTest_04', 0, async () => {
      let settingcardaccess: SettingCardAccess = SettingCardAccess.getInstance();
      let mocker: MockKit = new MockKit();
      let userFileManagerAccess: UserFileManagerAccess = UserFileManagerAccess.getInstance();
      let mockfunc1: Function = mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.onCreate);
      when(mockfunc1)(ArgumentMatchers.any).afterReturnNothing();
      let mockfunc2: Function = mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.getAllLocalVideoSize);
      when(mockfunc2)().afterReturn(100);
      let callback: Function = () => {
      };
      let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
      if (context) {
        await settingcardaccess.fetchAssetsInfo('otherRequestType', new dataSharePredicates.DataSharePredicates(),
          callback, context);
        mocker.ignoreMock(userFileManagerAccess, userFileManagerAccess.onCreate);
        mocker.ignoreMock(userFileManagerAccess, userFileManagerAccess.getAllLocalVideoSize);
      }
      expect(context !== undefined).assertTrue();
    });

  })
}

async function SettingCardAccessTest01() {
  try {
    await abilityDelegator.executeShellCommand('aa start -a com.ohos.photos.MainAbility -b com.ohos.photos')
      .then((): void => {
        Log.info(TAG, 'MainAbility start success');
      });
  } catch (exception) {
    Log.error(TAG, 'start failed: ' + exception.code);
  } finally {
    Log.info(TAG, 'start photo application');
  }
  let ret: boolean = SettingCardAccess?.getInstance() !== null;
  expect(ret).assertTrue();
}