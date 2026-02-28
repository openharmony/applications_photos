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

import { describe, expect, it, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { YearMonthDataImpl } from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthDataImpl';
import { YearMonthQueryParam, Priority } from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthQueryParam';
import { Region } from '@ohos/common/src/main/ets/default/utils/Region';
import { YearMonthMediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthMediaItem';
import { YearMonthMediaQueryWorker } from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthMediaQueryWorker';

/**
 * YearMonthMediaQueryWorker Unittest
 *
 * @since 2025-06-03
 */
export default function YearMonthMediaQueryWorkerTest() {
  describe('YearMonthMediaQueryWorkerTest', () => {
    it('YearMonthMediaQueryWorkerTest_001', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest001();
    });
    it('YearMonthMediaQueryWorkerTest_002', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest002();
    });
    it('YearMonthMediaQueryWorkerTest_003', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest003();
    });
    it('YearMonthMediaQueryWorkerTest_004', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest004();
    });
    it('YearMonthMediaQueryWorkerTest_005', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest005();
    });
    it('YearMonthMediaQueryWorkerTest_006', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest006();
    });
    it('YearMonthMediaQueryWorkerTest_007', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest007();
    });
    it('YearMonthMediaQueryWorkerTest_008', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest008();
    });
    it('YearMonthMediaQueryWorkerTest_009', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest009();
    });
    it('YearMonthMediaQueryWorkerTest_010', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest010();
    });
    it('YearMonthMediaQueryWorkerTest_011', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest011();
    });
    it('YearMonthMediaQueryWorkerTest_012', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest012();
    });
    it('YearMonthMediaQueryWorkerTest_013', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest013();
    });
    it('YearMonthMediaQueryWorkerTest_014', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest014();
    });
    it('YearMonthMediaQueryWorkerTest_015', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest015();
    });
    it('YearMonthMediaQueryWorkerTest_016', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest016();
    });
    it('YearMonthMediaQueryWorkerTest_017', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest017();
    });
    it('YearMonthMediaQueryWorkerTest_018', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest018();
    });
    it('YearMonthMediaQueryWorkerTest_019', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest019();
    });
    it('YearMonthMediaQueryWorkerTest_020', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest020();
    });
    it('YearMonthMediaQueryWorkerTest_021', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest021();
    });
    it('YearMonthMediaQueryWorkerTest_022', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await YearMonthMediaQueryWorkerTest022();
    });
  })
}

/**
 * addHighMediaDataTask
 * 分支: queryParam.priority !== Priority.HIGH
 */
async function YearMonthMediaQueryWorkerTest001() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let currentMediaDataRegion: Region = new Region('currentMediaDataRegion');
  let start: number = currentMediaDataRegion.start;
  let count: number = currentMediaDataRegion.end - currentMediaDataRegion.start + 1;
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(start, count, Priority.LOW);
  let callbackFunc: Function = (queryParam: YearMonthQueryParam, items: YearMonthMediaItem[]): void => {};
  worker.addHighMediaDataTask(queryParam, callbackFunc);
  expect(worker.queryWorkingCount).assertEqual(0);
}

/**
 * addHighMediaDataTask
 * 分支: hasTask = true
 */
async function YearMonthMediaQueryWorkerTest002() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(0, 1, Priority.HIGH);
  let callbackFunc: Function = (queryParam: YearMonthQueryParam, items: YearMonthMediaItem[]): void => {};
  let mocker: MockKit = new MockKit();
  const hasMediaDataTask: Function = Reflect.get(worker, 'hasMediaDataTask');
  when(mocker.mockFunc(worker, hasMediaDataTask))(ArgumentMatchers.any).afterReturn(true);
  worker.addHighMediaDataTask(queryParam, callbackFunc);
  expect(worker.queryWorkingCount).assertEqual(0);
  mocker.ignoreMock(worker, Reflect.get(worker, 'hasMediaDataTask'));
}

/**
 * removeMediaDataTask
 * 分支: !queryParam.isValid() = true
 */
async function YearMonthMediaQueryWorkerTest003() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(1, 0, Priority.HIGH);
  worker.removeMediaDataTask(queryParam);
  expect(worker.queryWorkingCount).assertEqual(0);
}

/**
 * hasMediaDataTask
 * 分支: !queryParam.isValid() = true
 */
async function YearMonthMediaQueryWorkerTest004() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(1, 0, Priority.HIGH);
  const hasMediaDataTask: Function = Reflect.get(worker, 'hasMediaDataTask');
  let ret: boolean = hasMediaDataTask(queryParam);
  expect(!ret).assertTrue();
}

/**
 * executeTask
 * 分支: highTaskQueue.length = 0 && this.pauseLowTaskFlag
 */
async function YearMonthMediaQueryWorkerTest005() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(0, 1, Priority.LOW);
  let callbackFunc: Function = (queryParam: YearMonthQueryParam, items: YearMonthMediaItem[]): void => {};
  worker.addLowMediaDataTask(queryParam, callbackFunc);
  expect(worker.queryWorkingCount).assertEqual(0);
}

/**
 * addLowMediaDataTask
 * 分支: !queryParam.isValid() = true
 */
async function YearMonthMediaQueryWorkerTest006() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(1, 0, Priority.LOW);
  let callbackFunc: Function = (queryParam: YearMonthQueryParam, items: YearMonthMediaItem[]): void => {};
  worker.addLowMediaDataTask(queryParam, callbackFunc);
  expect(worker.queryWorkingCount).assertEqual(0);
}

/**
 * addBatchMediaDataTask
 * 分支: batchCount <= 0
 */
async function YearMonthMediaQueryWorkerTest007() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let callbackFunc: Function = (queryParam: YearMonthQueryParam, items: YearMonthMediaItem[]): void => {};
  worker.addBatchMediaDataTask(0, 1, 0,callbackFunc);
  expect(worker.queryWorkingCount).assertEqual(0);
}

/**
 * removeMediaDataTask
 * 分支: HIGH for && highTaskQueue[index] = queryParam || !queryParam
 */
async function YearMonthMediaQueryWorkerTest008() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(0, 1, Priority.HIGH);
  let callbackFunc: Function = (queryParam: YearMonthQueryParam, items: YearMonthMediaItem[]): void => {};

  let mocker: MockKit = new MockKit();
  const executeHighTask: Function = Reflect.get(worker, 'executeHighTask');
  when(mocker.mockFunc(worker, executeHighTask))(ArgumentMatchers.any).afterReturnNothing();

  worker.addHighMediaDataTask(queryParam, callbackFunc);
  worker.removeMediaDataTask(queryParam);
  let queryParam2: YearMonthQueryParam = new YearMonthQueryParam(1, 2, Priority.HIGH);
  worker.removeMediaDataTask(queryParam2);
  Reflect.set(worker, 'highTaskQueue', [{ queryParam: undefined }]);
  worker.removeMediaDataTask(queryParam);
  expect(worker.queryWorkingCount).assertEqual(1);
  mocker.ignoreMock(worker, executeHighTask);
}

/**
 * removeMediaDataTask
 * 分支: LOW for && lowTaskQueue[index] = queryParam || !queryParam
 */
async function YearMonthMediaQueryWorkerTest009() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(1, 1, Priority.LOW);
  let callbackFunc: Function = (queryParam: YearMonthQueryParam, items: YearMonthMediaItem[]): void => {};

  let mocker: MockKit = new MockKit();
  const executeLowTask: Function = Reflect.get(worker, 'executeLowTask');
  when(mocker.mockFunc(worker, executeLowTask))(ArgumentMatchers.any).afterReturnNothing();

  worker.addLowMediaDataTask(queryParam, callbackFunc);
  worker.resumeMediaDataTask();
  worker.removeMediaDataTask(queryParam);
  let queryParam2: YearMonthQueryParam = new YearMonthQueryParam(1, 2, Priority.LOW);
  worker.removeMediaDataTask(queryParam2);
  Reflect.set(worker, 'lowTaskQueue', [{ queryParam: undefined }]);
  worker.removeMediaDataTask(queryParam);
  expect(worker.queryWorkingCount).assertEqual(1);
  mocker.ignoreMock(worker, executeLowTask);
}

/**
 * hasMediaDataTask
 * 分支: HIGH
 */
async function YearMonthMediaQueryWorkerTest010() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(0, 1, Priority.HIGH);
  let callbackFunc: Function = (queryParam: YearMonthQueryParam, items: YearMonthMediaItem[]): void => {};

  let mocker: MockKit = new MockKit();
  const executeHighTask: Function = Reflect.get(worker, 'executeHighTask');
  when(mocker.mockFunc(worker, executeHighTask))(ArgumentMatchers.any).afterReturnNothing();

  const run = (queryParam: YearMonthQueryParam): boolean => Reflect.get(worker, 'hasMediaDataTask')
    .call(worker, queryParam);

  worker.addHighMediaDataTask(queryParam, callbackFunc);
  let ret: boolean = run(queryParam);
  expect(ret).assertTrue();

  let queryParam2: YearMonthQueryParam = new YearMonthQueryParam(1, 2, Priority.HIGH);
  let ret2: boolean = run(queryParam2);
  expect(!ret2).assertTrue();

  Reflect.set(worker, 'highTaskQueue', [{ queryParam: undefined }]);
  worker.addHighMediaDataTask(queryParam, callbackFunc);
  expect(worker.queryWorkingCount).assertEqual(1);
  mocker.ignoreMock(worker, executeHighTask);
}

/**
 * hasMediaDataTask
 * 分支: LOW
 */
async function YearMonthMediaQueryWorkerTest011() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(0, 1, Priority.LOW);
  let callbackFunc: Function = (queryParam: YearMonthQueryParam, items: YearMonthMediaItem[]): void => {};

  let mocker: MockKit = new MockKit();
  const executeLowTask: Function = Reflect.get(worker, 'executeLowTask');
  when(mocker.mockFunc(worker, executeLowTask))(ArgumentMatchers.any).afterReturnNothing();

  worker.addLowMediaDataTask(queryParam, callbackFunc);
  worker.resumeMediaDataTask();

  const run = (queryParam: YearMonthQueryParam): boolean => Reflect.get(worker, 'hasMediaDataTask')
    .call(worker, queryParam);

  let ret: boolean = run(queryParam);
  expect(ret).assertTrue();

  let queryParam2: YearMonthQueryParam = new YearMonthQueryParam(1, 2, Priority.LOW);
  let ret2: boolean = run(queryParam2);
  expect(!ret2).assertTrue();
  mocker.ignoreMock(worker, executeLowTask);
}

/**
 * hasMediaDataTask
 * 分支: LOW && !queryParam
 */
async function YearMonthMediaQueryWorkerTest012() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(0, 1, Priority.LOW);

  const run = (queryParam: YearMonthQueryParam): boolean => Reflect.get(worker, 'hasMediaDataTask')
    .call(worker, queryParam);

  Reflect.set(worker, 'lowTaskQueue', [{ queryParam: undefined }]);
  let ret: boolean = run(queryParam);
  expect(!ret).assertTrue();
}

/**
 * executeTask
 * 分支 queryWorkingCount < 0
 * executeHighTask
 */
async function YearMonthMediaQueryWorkerTest013() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  Reflect.set(worker, 'highTaskQueue', [undefined, undefined, { queryParam: undefined }, undefined, undefined, undefined]);
  Reflect.set(worker, 'queryWorkingCount', -1);
  worker.executeTask();
  expect(worker.queryWorkingCount).assertEqual(0);
}

/**
 * executeHighTask
 * 分支 !photoDataImpl
 */
async function YearMonthMediaQueryWorkerTest014() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(0, 1, Priority.HIGH);
  let callbackFunc: Function = (queryParam: YearMonthQueryParam, items: YearMonthMediaItem[]): void => {};
  Reflect.set(worker, 'photoDataImpl', undefined);
  worker.addHighMediaDataTask(queryParam, callbackFunc);
  expect(worker.queryWorkingCount).assertEqual(0);
}

/**
 * executeLowTask
 * 分支 !photoDataImpl
 */
async function YearMonthMediaQueryWorkerTest015() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(0, 1, Priority.LOW);
  let callbackFunc: Function = (queryParam: YearMonthQueryParam, items: YearMonthMediaItem[]): void => {};
  Reflect.set(worker, 'photoDataImpl', undefined);
  Reflect.set(worker, 'pauseLowTaskFlag', false);
  worker.addLowMediaDataTask(queryParam, callbackFunc);
  expect(worker.queryWorkingCount).assertEqual(0);
}

/**
 * executeLowTask
 * 分支 !task || !queryParam
 */
async function YearMonthMediaQueryWorkerTest016() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  Reflect.set(worker, 'lowTaskQueue', [undefined, undefined, { queryParam: undefined }, undefined, undefined, undefined]);
  Reflect.set(worker, 'pauseLowTaskFlag', false);
  worker.executeTask();
  expect(worker.queryWorkingCount).assertEqual(0);
}

/**
 * MediaDataQueryCallback.callback
 * 分支 !data
 */
async function YearMonthMediaQueryWorkerTest017() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(0, 1, Priority.LOW);
  let callbackFunc: Function = (queryParam: YearMonthQueryParam, items: YearMonthMediaItem[]): void => {};
  Reflect.set(worker, 'pauseLowTaskFlag', false);

  const getMetaDataAsync: Function = Reflect.get(yearMonthQueryMediaData, 'getMetaDataAsync');
  let getMetaDataAsyncRes: Function = (): Promise<null> => {
    return new Promise((res) => {
      res(null)
    });
  };
  Reflect.set(yearMonthQueryMediaData, 'getMetaDataAsync', getMetaDataAsyncRes);
  worker.addLowMediaDataTask(queryParam, callbackFunc);
  expect(worker.queryWorkingCount).assertEqual(1);
  Reflect.set(yearMonthQueryMediaData, 'getMetaDataAsync', getMetaDataAsync);
}

/**
 * removeAllTasks
 */
async function YearMonthMediaQueryWorkerTest018() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(0, 1, Priority.LOW);
  let callbackFunc: Function = (queryParam: YearMonthQueryParam, items: YearMonthMediaItem[]): void => {};
  worker.pauseLowMediaDataTask()
  worker.addLowMediaDataTask(queryParam, callbackFunc);
  worker.removeAllTasks();
  expect(worker.queryWorkingCount).assertEqual(0);
}

/**
 * executeHighTask
 */
async function  YearMonthMediaQueryWorkerTest019() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(0, 1, Priority.HIGH);
  let callbackFunc: Function = (queryParam: YearMonthQueryParam, items: YearMonthMediaItem[]): void => {};
  worker.addHighMediaDataTask(queryParam, callbackFunc);
  expect(worker.queryWorkingCount).assertEqual(1);
}

/**
 * addBatchMediaDataTask
 */
async function YearMonthMediaQueryWorkerTest020() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let callbackFunc: Function = (queryParam: YearMonthQueryParam, items: YearMonthMediaItem[]): void => {};
  worker.addBatchMediaDataTask(0, 5, 2,callbackFunc);
  worker.addBatchMediaDataTask(0, 4, 2,callbackFunc);
  expect(worker.queryWorkingCount).assertEqual(0);
}

/**
 * MediaDataQueryCallback.callback
 *  分支 this.task.callbackFunc
 */
async function YearMonthMediaQueryWorkerTest021() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(1, 1, Priority.LOW);
  let callbackFunc: Function = (queryParam: YearMonthQueryParam, items: YearMonthMediaItem[]): void => {};
  Reflect.set(worker, 'pauseLowTaskFlag', false);

  const getMetaDataAsync: Function = Reflect.get(yearMonthQueryMediaData, 'getMetaDataAsync');
  let getMetaDataAsyncRes: Function = (): Promise<number> => {
    return new Promise((res) => {
      res(100)
    });
  };
  Reflect.set(yearMonthQueryMediaData, 'getMetaDataAsync', getMetaDataAsyncRes);
  worker.addLowMediaDataTask(queryParam, callbackFunc);
  expect(worker.queryWorkingCount).assertEqual(1);
  Reflect.set(yearMonthQueryMediaData, 'getMetaDataAsync', getMetaDataAsync);
}

/**
 * MediaDataQueryCallback.callback
 * 分支 ！this.task.callbackFunc
 */
async function YearMonthMediaQueryWorkerTest022() {
  let yearMonthQueryMediaData = new YearMonthDataImpl();
  let worker: YearMonthMediaQueryWorker = new YearMonthMediaQueryWorker(yearMonthQueryMediaData);
  let queryParam: YearMonthQueryParam = new YearMonthQueryParam(1, 1, Priority.LOW);
  Reflect.set(worker, 'pauseLowTaskFlag', false);
  Reflect.set(worker, 'lowTaskQueue', [{ queryParam, callbackFunc: undefined, needExecute: true }]);

  const getMetaDataAsync: Function = Reflect.get(yearMonthQueryMediaData, 'getMetaDataAsync');
  let getMetaDataAsyncRes: Function = (): Promise<number> => {
    return new Promise((res) => {
      res(100)
    });
  };
  Reflect.set(yearMonthQueryMediaData, 'getMetaDataAsync', getMetaDataAsyncRes);
  worker.executeTask();
  expect(worker.queryWorkingCount).assertEqual(1);
  Reflect.set(yearMonthQueryMediaData, 'getMetaDataAsync', getMetaDataAsync);
}
