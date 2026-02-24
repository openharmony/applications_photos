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

import { describe, it, expect } from '@ohos/hypium';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { Log, getStack, expand, isEmpty, reportEmpty } from '@ohos/common/src/main/ets/default/utils/Log'

const TAG = 'LogTest'

/**
 * Log Unittest
 *
 * @since 2025-05-29
 */
export default function LogTest() {
  describe('LogTest', () => {
    it('LogTest_001', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest001();
    });

    it('LogTest_002', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest002();
    });

    it('LogTest_003', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest003();
    });

    it('LogTest_004', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest004();
    });

    it('LogTest_005', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest005();
    });

    it('LogTest_006', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest006();
    });

    it('LogTest_007', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest007();
    });

    it('LogTest_008', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest008();
    });

    it('LogTest_009', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest009();
    });

    it('LogTest_010', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest010();
    });

    it('LogTest_011', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest011();
    });

    it('LogTest_012', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest012();
    });

    it('LogTest_013', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest013();
    });

    it('LogTest_014', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest014();
    });

    it('LogTest_015', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest015();
    });

    it('LogTest_016', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest016();
    });

    it('LogTest_017', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest017();
    });

    it('LogTest_018', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest018();
    });

    it('LogTest_019', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest019();
    });

    it('LogTest_020', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest020();
    });

    it('LogTest_021', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest021();
    });

    it('LogTest_022', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest022();
    });

    it('LogTest_023', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest023();
    });

    it('LogTest_024', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest024();
    });

    it('LogTest_025', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest025();
    });

    it('LogTest_026', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest026();
    });

    it('LogTest_027', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest027();
    });

    it('LogTest_028', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest028();
    });

    it('LogTest_029', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await LogTest029();
    });
  });
}

/**
 * debug
 * 分支 isDebugLoggable
 */
async function LogTest001() {
  let isDebugLoggable: boolean = Reflect.get(Log, 'isDebugLoggable');
  let res = Log.debug(TAG, 'LogTest001');
  expect(res).assertEqual(isDebugLoggable);
}

/**
 * debug
 * 分支 !isDebugLoggable
 */
async function LogTest002() {
  let isDebugLoggable: boolean = Reflect.get(Log, 'isDebugLoggable');
  Reflect.set(Log, 'isDebugLoggable', !isDebugLoggable);
  let res = Log.debug(TAG, 'LogTest002');
  Reflect.set(Log, 'isDebugLoggable', isDebugLoggable);
  expect(res).assertEqual(!isDebugLoggable);
}

/**
 * info
 * 分支 isInfoLoggable
 */
async function LogTest003() {
  let isInfoLoggable: boolean = Reflect.get(Log, 'isInfoLoggable');
  let res = Log.info(TAG, 'LogTest003');
  expect(res).assertEqual(isInfoLoggable);
}

/**
 * info
 * 分支 !isInfoLoggable
 */
async function LogTest004() {
  let isInfoLoggable: boolean = Reflect.get(Log, 'isInfoLoggable');
  Reflect.set(Log, 'isInfoLoggable', !isInfoLoggable);
  let res = Log.info(TAG, 'LogTest004');
  Reflect.set(Log, 'isInfoLoggable', isInfoLoggable);
  expect(res).assertEqual(!isInfoLoggable);
}

/**
 * i
 * 分支 isInfoLoggable
 */
async function LogTest005() {
  let isInfoLoggable: boolean = Reflect.get(Log, 'isInfoLoggable');
  let res = Log.i(TAG, 'LogTest005');
  expect(res).assertEqual(isInfoLoggable);
}

/**
 * i
 * 分支 !isInfoLoggable
 */
async function LogTest006() {
  let isInfoLoggable: boolean = Reflect.get(Log, 'isInfoLoggable');
  Reflect.set(Log, 'isInfoLoggable', !isInfoLoggable);
  let res = Log.i(TAG, 'LogTest006');
  Reflect.set(Log, 'isInfoLoggable', isInfoLoggable);
  expect(res).assertEqual(!isInfoLoggable);
}

/**
 * warn
 * 分支 isWarnLoggable
 */
async function LogTest007() {
  let isWarnLoggable: boolean = Reflect.get(Log, 'isWarnLoggable');
  let res = Log.warn(TAG, 'LogTest007');
  expect(res).assertEqual(isWarnLoggable);
}

/**
 * warn
 * 分支 !isWarnLoggable
 */
async function LogTest008() {
  let isWarnLoggable: boolean = Reflect.get(Log, 'isWarnLoggable');
  Reflect.set(Log, 'isWarnLoggable', !isWarnLoggable);
  let res = Log.warn(TAG, 'LogTest008');
  Reflect.set(Log, 'isWarnLoggable', isWarnLoggable);
  expect(res).assertEqual(!isWarnLoggable);
}

/**
 * w
 * 分支 isWarnLoggable
 */
async function LogTest009() {
  let isWarnLoggable: boolean = Reflect.get(Log, 'isWarnLoggable');
  let res = Log.w(TAG, 'LogTest009');
  expect(res).assertEqual(isWarnLoggable);
}

/**
 * w
 * 分支 !isWarnLoggable
 */
async function LogTest010() {
  let isWarnLoggable: boolean = Reflect.get(Log, 'isWarnLoggable');
  Reflect.set(Log, 'isWarnLoggable', !isWarnLoggable);
  let res = Log.w(TAG, 'LogTest010');
  Reflect.set(Log, 'isWarnLoggable', isWarnLoggable);
  expect(res).assertEqual(!isWarnLoggable);
}

/**
 * error
 * 分支 isErrorLoggable
 */
async function LogTest011() {
  let isErrorLoggable: boolean = Reflect.get(Log, 'isErrorLoggable');
  let res = Log.error(TAG, 'LogTest011');
  expect(res).assertEqual(isErrorLoggable);
}

/**
 * error
 * 分支 !isErrorLoggable
 */
async function LogTest012() {
  let isErrorLoggable: boolean = Reflect.get(Log, 'isErrorLoggable');
  Reflect.set(Log, 'isErrorLoggable', !isErrorLoggable);
  let res = Log.error(TAG, 'LogTest012');
  Reflect.set(Log, 'isErrorLoggable', isErrorLoggable);
  expect(res).assertEqual(!isErrorLoggable);
}

/**
 * e
 * 分支 isErrorLoggable
 */
async function LogTest013() {
  let isErrorLoggable: boolean = Reflect.get(Log, 'isErrorLoggable');
  let res = Log.e(TAG, 'LogTest013');
  expect(res).assertEqual(isErrorLoggable);
}

/**
 * e
 * 分支 !isErrorLoggable
 */
async function LogTest014() {
  let isErrorLoggable: boolean = Reflect.get(Log, 'isErrorLoggable');
  Reflect.set(Log, 'isErrorLoggable', !isErrorLoggable);
  let res = Log.e(TAG, 'LogTest014');
  Reflect.set(Log, 'isErrorLoggable', isErrorLoggable);
  expect(res).assertEqual(!isErrorLoggable);
}

/**
 * fatal
 * 分支 isFatalLoggable
 */
async function LogTest015() {
  let isFatalLoggable: boolean = Reflect.get(Log, 'isFatalLoggable');
  let res = Log.fatal(TAG, 'LogTest015');
  expect(res).assertEqual(isFatalLoggable);
}

/**
 * fatal
 * 分支 !isFatalLoggable
 */
async function LogTest016() {
  let isFatalLoggable: boolean = Reflect.get(Log, 'isFatalLoggable');
  Reflect.set(Log, 'isFatalLoggable', !isFatalLoggable);
  let res = Log.fatal(TAG, 'LogTest016');
  Reflect.set(Log, 'isFatalLoggable', isFatalLoggable);
  expect(res).assertEqual(!isFatalLoggable);
}

/**
 * stringify
 * 分支 a instanceof Error
 */
async function LogTest017() {
  let error: Error = new Error('test error');
  const result = Log.stringify(error);
  expect(result).assertEqual(getStack(error));
}

/**
 * stringify
 * 分支 typeof a === 'undefined'
 */
async function LogTest018() {
  const result = Log.stringify(undefined);
  expect(result).assertEqual(typeof undefined);
}

/**
 * stringify
 * 分支 typeof a === 'string'
 */
async function LogTest019() {
  const result = Log.stringify('test string');
  expect(result).assertEqual('test string');
}

/**
 * stringify
 * 分支 typeof a === 'function'
 */
async function LogTest020() {
  let testFunc = () => {};
  let res = Log.stringify(testFunc);
  expect(res).assertEqual(testFunc.name);
}

/**
 * stringify
 * 分支 typeof a === 'object'
 */
async function LogTest021() {
  interface MyObj {
    key?: string;
  }
  let obj: MyObj = { key: 'value' };
  let res = Log.stringify(obj);
  expect(res).assertEqual(expand(obj));
}

/**
 * stringify
 * 分支 typeof a not in case
 */
async function LogTest022() {
  let num: number = 123;
  const result = Log.stringify(num);
  expect(result).assertEqual(String(num));
}

/**
 * isEmpty
 * 分支 typeof target === 'boolean'
 */
async function LogTest023() {
  const result = isEmpty<boolean>(true);
  expect(result).assertEqual(false);
}

/**
 * isEmpty
 * 分支 typeof target === 'number'
 */
async function LogTest024() {
  const result = isEmpty<number>(10);
  expect(result).assertEqual(false);
}

/**
 * isEmpty
 * 分支 typeof target not in case
 */
async function LogTest025() {
  const result = isEmpty<string>('test isEmpty non in case');
  expect(result).assertEqual(false);
}

/**
 * expand
 * 分支 typeof target !== 'object'
 */
async function LogTest026() {
  let target: string = 'test';
  const result = expand(target);
  expect(result).assertEqual(String(target));
}

/**
 * expand
 * 分支 typeof target === 'object' && no properties
 */
async function LogTest027() {
  interface MyObj {}
  let target: MyObj = {};
  const result = expand(target);
  expect(result).assertEqual('{}');
}

/**
 * expand
 * 分支 typeof target === 'object'
 */
async function LogTest028() {
  interface MyObj {
    prop1: string,
    prop2: string
  }
  let target: MyObj = {
    prop1: 'value1',
    prop2: 'value2'
  };
  const result = expand(target);
  expect(result).assertEqual('{prop1: "value1", prop2: "value2", }');
}

/**
 * reportEmpty
 * 分支 !isEmpty(target)
 */
async function LogTest029() {
  let target: string = 'test reportEmpty';
  let res: string = reportEmpty<string>(target);
  expect(res).assertEqual(target);
}
