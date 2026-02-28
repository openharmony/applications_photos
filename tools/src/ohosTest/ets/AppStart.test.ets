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

import { expect, it } from '@ohos/hypium';
import type { BusinessError } from '@ohos.base';
import type Want from '@ohos.app.ability.Want';
import { TestConstants } from './TestConstants';
import { Log } from '../../main/utils/Log';
import { abilityDelegator } from './Factory.test';
import { Timer } from '../../main/utils/Timer';

const TAG: string = `AppStart`;

export namespace AppStart {
  /**
   * 打开图库
   */
  export async function photos(): Promise<void> {
    await application(TestConstants.START_PHOTO_WANT, 'start photo');
  }

  export async function camera(): Promise<void> {
    await application(TestConstants.START_CAMERA_WANT, 'start camera');
  }

  export async function settings(): Promise<void> {
    await application(TestConstants.START_SETTINGS_WANT, 'start settings');
  }

  export async function reset(want: Want, msg: string): Promise<void> {
    await stop(TestConstants.START_PHOTO_WANT, 'start photo');
    await application(TestConstants.START_PHOTO_WANT, 'start photo');
  }

  export async function application(want: Want, msg: string = want.abilityName ?? 'anonymous'): Promise<void> {
    await shell(`aa start -a ${want.abilityName} -b ${want.bundleName}`, msg);
    await Timer.sleep(3000);
  }

  export async function stop(want: Want, msg: string): Promise<void> {
    await shell(`aa force-stop ${want.bundleName}`, msg);
  }

  export async function shell(cmd: string, msg: string = cmd): Promise<void> {
    Log.info(TAG, msg + 'shell cmd start ');
    try {
      await abilityDelegator.executeShellCommand(cmd);
    } catch (exception) {
      Log.info(TAG, `${msg} start failed :${exception} cmd :${cmd}`);
    } finally {
      Log.info(TAG, `${msg} start photo application`);
    }
    Log.info(TAG, msg + ' end');
  }

  export async function withScreenOn(want: Want, testCaseName: string): Promise<void> {
    Log.info(TAG, `${testCaseName} start`);
    await tryDelegator(want);
    Log.info(TAG, `${testCaseName} end`);
  }

  export async function testCase<T>(testCaseName: string, test: (...p: T[]) => Promise<void>,
    ...pram: T[]): Promise<void> {
    it(testCaseName, TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      Log.info(TAG, `${testCaseName} start`);
      await test(...pram);
      Log.info(TAG, `${testCaseName} end`);
    });
  }

  export async function tryDelegator(want: Want): Promise<void> {
    try {
      await abilityDelegator.startAbility(want).then((): void => {
        Log.info(TAG, want.abilityName, 'start success');
      });
    } catch (exception) {
      let exp: BusinessError = exception as BusinessError;
      expect(0).assertEqual(exp.code);
      Log.info(TAG, `start failed :${exp.code}`);
    } finally {
      Log.info(TAG, 'start photo application');
    }
  }
}