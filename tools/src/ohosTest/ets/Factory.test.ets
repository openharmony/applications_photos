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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Dt } from './Dt';
import { it, Level, TestType } from '@ohos/hypium';
import { DisplayRotation, WindowMode } from '@ohos.UiTest';
import { Timer } from '../../main/utils/Timer';
import { DELAY } from './Config.test';

export const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

export const abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments();

export namespace Factory {
  export interface Config {
    case?: string;
    rotate?: boolean;

    //切换悬浮窗或分屏
    winMode?: WindowMode;
  }

  export function callback(testCase: string, testFunc: (dt: Dt) => Promise<void>): (done: Function) => Promise<void> {
    return async (done: Function): Promise<void> => {
      const dt = new Dt(testCase);
      dt.log.i(`${testCase} started`);
      await dt.init();
      await testFunc(dt);
      dt.log.i(`${testCase} ended`);
      done();
    }
  }
}

export function run(name: string, attribute: (TestType | Size | Level),
  wrapped: (dt: Dt) => Promise<void>, conf?: Factory.Config): void {
  it(name, attribute, Factory.callback(name, async (dt: Dt): Promise<void> => {
    if (conf?.rotate) {
      await dt.rotate(DisplayRotation.ROTATION_90);
    } else {
      await dt.rotate(DisplayRotation.ROTATION_0);
    }
    if (conf?.winMode) {
      await dt.getScreen().switchMode(WindowMode.FLOATING);
    }
    //执行测试
    await wrapped(dt);

    await dt.rotate(DisplayRotation.ROTATION_0);
    if (conf?.winMode) {
      await dt.getScreen().switchMode(WindowMode.FULLSCREEN);
    }
    await Timer.sleep(DELAY.short);
  }));
}