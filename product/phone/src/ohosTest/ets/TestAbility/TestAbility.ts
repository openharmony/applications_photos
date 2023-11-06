/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry';
import { Hypium } from 'hypium/index';
import testsuite from '../test/List.test';
import { Log } from '@ohos/common';

const TAG: string = 'TestAbility';

export default class TestAbility extends Ability {
  onCreate(want, launchParam): void {
    Log.info(TAG, 'TestAbility onCreate')
    var abilityDelegator: any
    abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
    var abilityDelegatorArguments: any
    abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments()
    Log.info(TAG, 'start run testcase!!!')
    Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite)
  }

  onDestroy(): void {
    Log.info(TAG, 'TestAbility onDestroy')
  }

  onWindowStageCreate(windowStage): void {
    Log.info(TAG, 'TestAbility onWindowStageCreate')
    windowStage.setUIContent(this.context, 'TestAbility/pages/index', null)

    AppStorage.setOrCreate('abilityContext', this.context);
  }

  onWindowStageDestroy(): void {
    Log.info(TAG, 'TestAbility onWindowStageDestroy')
  }

  onForeground(): void {
    Log.info(TAG, 'TestAbility onForeground')
  }

  onBackground(): void {
    Log.info(TAG, 'TestAbility onBackground')
  }
};