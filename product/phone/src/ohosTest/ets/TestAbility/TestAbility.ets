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
import Ability from '@ohos.app.ability.UIAbility';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { expect, Hypium } from '@ohos/hypium';
import testsuite from '../test/List.test';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import window from '@ohos.window';

const TAG: string = 'TestAbility';

export const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

export const abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments();

export default class TestAbility extends Ability {
  onCreate(): void {
    Log.info(TAG, 'start run testcase!!!');
    Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite);
    Log.info(TAG, 'TestAbility onCreate');
  }

  onDestroy(): void {
    Log.info(TAG, 'TestAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    Log.info(TAG, 'TestAbility onWindowStageCreate');
    windowStage.loadContent('TestAbility/pages/index', (err, data) => {
      if (err.code) {
        Log.error(TAG, 'Failed to load the content. Cause: %{public}s', err + ', code: ' + err?.code ?? '');
        return;
      }
      Log.error(TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
    AppStorage.setOrCreate('abilityContext', this.context);
    this.setShowOnLockScreenTest(windowStage);
  }

  onWindowStageDestroy(): void {
    Log.info(TAG, 'TestAbility onWindowStageDestroy');
  }

  onForeground(): void {
    Log.info(TAG, 'TestAbility onForeground');
  }

  onBackground(): void {
    Log.info(TAG, 'TestAbility onBackground');
  }

  setShowOnLockScreenTest(windowStage: window.WindowStage): boolean {
    try {
      windowStage.setShowOnLockScreen(true);
      windowStage.setShowOnLockScreen(false);
      return true;
    } catch (err) {
      expect(0).assertEqual(err.code);
      Log.info(TAG, `start failed :${err.code}`);
    }
    return false;
  }
};