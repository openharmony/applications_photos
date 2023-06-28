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

import type TestRunner from '@ohos.application.testRunner';
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry';
import { Log } from '@ohos/common';

const TAG: string = 'OpenHarmonyTestRunner';

var abilityDelegator = undefined;
var abilityDelegatorArguments = undefined;

function translateParamsToString(parameters): string {
  const keySet = new Set([
    '-s class', '-s notClass', '-s suite', '-s it',
    '-s level', '-s testType', '-s size', '-s timeout'
  ]);
  let targetParams: string = '';
  for (const key in parameters) {
    if (keySet.has(key)) {
      targetParams = `${targetParams} ${key} ${parameters[key]}`;
    }
  }
  return targetParams.trim();
}

async function onAbilityCreateCallback(): Promise<void> {
  Log.info(TAG, 'onAbilityCreateCallback');
}

async function addAbilityMonitorCallback(err: any): Promise<void> {
  Log.info(TAG, 'addAbilityMonitorCallback : ' + JSON.stringify(err));
}

export default class OpenHarmonyTestRunner implements TestRunner {
  constructor() {
  }

  onPrepare(): void {
    Log.info(TAG, 'OpenHarmonyTestRunner OnPrepare ');
  }

  async onRun(): Promise<void> {
    Log.info(TAG, 'OpenHarmonyTestRunner onRun run');
    abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments();
    abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    let testAbilityName: string = abilityDelegatorArguments.bundleName + '.TestAbility';
    let lMonitor = {
      abilityName: testAbilityName,
      onAbilityCreate: onAbilityCreateCallback,
    };
    abilityDelegator.addAbilityMonitor(lMonitor, addAbilityMonitorCallback);
    let cmd: string = 'aa start -d 0 -a TestAbility' + ' -b ' + abilityDelegatorArguments.bundleName;
    cmd += ' ' + translateParamsToString(abilityDelegatorArguments.parameters);
    Log.info(TAG, 'cmd : ' + cmd);
    abilityDelegator.executeShellCommand(cmd,
      (err, data) => {
        Log.info(TAG, 'executeShellCommand : err : ' + JSON.stringify(err));
        Log.info(TAG, 'executeShellCommand : data : ' + data.stdResult);
        Log.info(TAG, 'executeShellCommand : data : ' + data.exitCode);
      })
    Log.info(TAG, 'OpenHarmonyTestRunner onRun end');
  }
};