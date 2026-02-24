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
import { describe, expect, it, MockKit } from '@ohos/hypium';
import { Throttle } from '@ohos/common/src/main/ets/default/utils/Throttle';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG: string = 'Throttle';

export default function ThrottleTest() {
  class fuc{
    constructor() {
    }
    public immediate(): void{
      Log.info(TAG, 'fuction immediate is running...');
      return;
    }
    public delay(): void{
      Log.info(TAG, 'fuction delay is running...');
      return;
    }
    public logMessage(message: string): void{
      Log.info(TAG, `message: ${message}`);
    }

  }

  describe('ThrottleTest', () => {
    //测试isPassable: passTime < this.interval && passTime > 0
    it('isPassableTest_passTime_smaller_than_interval', 0, () => {
      let throttleInstance: Throttle<void> = new Throttle(100, 'tag');
      throttleInstance.lastPassTime = new Date().getTime() - 10;
      const res = throttleInstance.isPassable();
      expect(res).assertFalse();
    });

    //测试run: this.interval <= 0
    it('isPassableTest_interval_smaller_than_zero', 0, () => {
      let throttleInstance: Throttle<string> = new Throttle(-1, 'testTag');
      let functions = new fuc();
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(Log, Log.warn);
      throttleInstance.lastPassTime = new Date().getTime() - 1500;
      // 调用 run 方法
      throttleInstance.run(functions.logMessage, "hello");
      mocker.verify('warn', ['testTag', 'interval can not be less than or equal to 0']).once()
      mocker.ignoreMock(Log, Log.warn);
    });

    //this.isPassable() = true
    it('isPassableTest_isPassable_is_true', 0, () => {
      let throttleInstance: Throttle<string> = new Throttle(1000, 'testTag');
      let functions = new fuc();
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(functions, functions.logMessage);
      throttleInstance.lastPassTime = new Date().getTime() - 1200;
      // 调用 run 方法
      throttleInstance.run(functions.logMessage, "hello");
      mocker.verify('logMessage', ["hello"]).once();
      mocker.ignoreMock(functions, functions.logMessage);
      mocker.clear(functions);

    });

    //测试execute: this.timer > 0, 检查Log信息
    it('executeTest_timer_bigger_than_zero', 0, () => {
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(Log, Log.info);
      let immediate: (newCount: number) => void = (newCount: number) => {
        Log.info(TAG, `new count: ${newCount}`);
      };
      let throttle: Throttle<void> = new Throttle(1000, 'testTag');
      Reflect.set(throttle, 'timer', 1);
      throttle.execute(immediate);
      mocker.verify('info',['testTag', 'Throttle not passable has pending task']);
      mocker.ignoreMock(Log, Log.info);
    });

  });
}