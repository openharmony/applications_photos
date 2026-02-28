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
import { afterEach, ArgumentMatchers, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import TaskManage from '@ohos/browsercommon/src/main/ets/default/utils/MoireTaskManage';
import { castManager } from '@ohos/castMirror/src/main/ets/CastManager';

export default function MoireTaskManageTest() {
  describe('MoireTaskManageTest', () => {

    beforeEach(() => {
    });

    afterEach(() => {
    });

    it('getContrastEnhancer', 0, () => {
      getContrastEnhancer();
    });
    it('calculateRatio', 0, () => {
      calculateRatio();
    });
    it('removeRatioTasks', 0, () => {
      removeRatioTasks();
    });
    it('update', 0, () => {
      update();
    });
    it('updatePixelMap', 0, () => {
      updatePixelMap();
    });
    it('tryRunTask', 0, () => {
      tryRunTask();
    });
    it('clearParseTaskTimeoutListener', 0, () => {
      clearParseTaskTimeoutListener();
    });
    it('notify', 0, () => {
      notify();
    });
    it('resetCache', 0, () => {
      resetCache();
    });
  })
}

function getContrastEnhancer() {
  let mocker: MockKit = new MockKit();
  let mockResetCache: Function = mocker.mockFunc(TaskManage, TaskManage.resetCache);
  let mockIsCastConnect: Function = mocker.mockFunc(castManager, castManager.isCastConnect);

  let updateOptions: ESObject = new Object();
  updateOptions.clearCache = true;
  TaskManage.resetCacheIfNeeded('test', updateOptions);

  updateOptions.clearCache = false;
  TaskManage.resetCacheIfNeeded('test', updateOptions);

  updateOptions.isCasted = true;
  TaskManage.resetCacheIfNeeded('test', updateOptions);

  updateOptions.isCasted = false;
  when(mockIsCastConnect)().afterReturnNothing();
  TaskManage.resetCacheIfNeeded('test', updateOptions);

  TaskManage.resetCacheIfNeeded('', updateOptions);
  mocker.verify('resetCache', []).atLeast(1);
  mocker.ignoreMock(TaskManage, TaskManage.resetCache);
  mocker.ignoreMock(castManager, castManager.isCastConnect);
}

function calculateRatio() {
  let updateOptions: ESObject = new Object();
  let thumbnail: ESObject = new Object();
  thumbnail.width = 1;
  thumbnail.height = 1;
  updateOptions.isCasted = false;
  TaskManage.calculateRatio(updateOptions);

  updateOptions.thumbnail = thumbnail;
  TaskManage.calculateRatio(updateOptions);

  updateOptions.isCasted = true;
  let result = TaskManage.calculateRatio(updateOptions);
  expect(result).assertEqual(1);
}

function removeRatioTasks() {
  let taskItem1: ESObject = new Object();
  let taskItem2: ESObject = new Object();
  taskItem1.cacheKey = 'test';
  taskItem2.cacheKey = 'test1';
  (TaskManage as ESObject).taskItems = [taskItem1, taskItem2];
  TaskManage.removeRatioTasks('test');
}

function update() {
  let mocker: MockKit = new MockKit();
  let mockResetCacheIfNeeded: Function = mocker.mockFunc(TaskManage, TaskManage.resetCacheIfNeeded);
  let mockCalculateRatio: Function = mocker.mockFunc(TaskManage, TaskManage.calculateRatio);
  let mockGetTaskItemCacheKey: Function = mocker.mockFunc(TaskManage, TaskManage.getTaskItemCacheKey);
  let mockAddToTask: Function = mocker.mockFunc(TaskManage, TaskManage.addToTask);
  let mockRemoveRatioTasks: Function = mocker.mockFunc(TaskManage, TaskManage.removeRatioTasks);
  let mockIsCastConnect: Function = mocker.mockFunc(castManager, castManager.isCastConnect);

  let updateOptions: ESObject = new Object();
  TaskManage.update('test', updateOptions);

  TaskManage.update('test', updateOptions, 1);

  let thumbnail: ESObject = new Object();
  updateOptions.thumbnail = thumbnail;
  TaskManage.update('test', updateOptions, 1, 'test');

  updateOptions.isCasted = true;
  TaskManage.update('test', updateOptions, 1, 'test');

  updateOptions.isCasted = false;
  (TaskManage as ESObject).currentExecTaskCacheKey = 'test';
  when(mockIsCastConnect)().afterReturn(false);
  TaskManage.update('test', updateOptions, 1, 'test');

  mocker.ignoreMock(TaskManage, TaskManage.resetCacheIfNeeded);
  mocker.ignoreMock(TaskManage, TaskManage.calculateRatio);
  mocker.ignoreMock(TaskManage, TaskManage.getTaskItemCacheKey);
  mocker.ignoreMock(TaskManage, TaskManage.addToTask);
  mocker.ignoreMock(TaskManage, TaskManage.removeRatioTasks);
  mocker.ignoreMock(castManager, castManager.isCastConnect);
}

function updatePixelMap() {
  let mocker: MockKit = new MockKit();
  let mockNotify: Function = mocker.mockFunc(TaskManage, TaskManage.notify);
  let taskItem: ESObject = new Object();
  taskItem.cacheKey = 'test';
  let res: ESObject = new Object();

  TaskManage.updatePixelMap(taskItem, res);

  let cacheItem: ESObject = new Object();
  cacheItem.thumbnail = undefined;
  TaskManage.cache.set('', cacheItem);
  TaskManage.updatePixelMap(taskItem, res);

  let thumbnail: ESObject = new Object();
  thumbnail.moireOriginPixelMap = undefined as ESObject;
  cacheItem.thumbnail = thumbnail;
  cacheItem.pixelMaps = new Map<string, ESObject>();
  res = [new Object() as ESObject, new Object() as ESObject];
  TaskManage.updatePixelMap(taskItem, res);

  (TaskManage as ESObject).defaultCacheKey = 'test';
  cacheItem.pixelMaps.set('test', new TestTaskItem() as ESObject);
  TaskManage.updatePixelMap(taskItem, res);
  mocker.ignoreMock(TaskManage, TaskManage.notify);
}

async function tryRunTask() {
  let mocker: MockKit = new MockKit();
  let mockRunTaskNext: Function = mocker.mockFunc(TaskManage, TaskManage.runTaskNext);
  (TaskManage as ESObject).runTaskAble = false;
  await TaskManage.tryRunTask();

  (TaskManage as ESObject).runTaskAble = true;
  (TaskManage as ESObject).taskItems = [];
  await TaskManage.tryRunTask();

  (TaskManage as ESObject).runTaskAble = true;
  let taskItems = new TestTaskItem();
  (TaskManage as ESObject).taskItems = [taskItems];
  await TaskManage.tryRunTask();

  mocker.ignoreMock(TaskManage, TaskManage.runTaskNext);
}

function clearParseTaskTimeoutListener() {
  (TaskManage as ESObject).runParseTaskTimer = 1;
  (TaskManage as ESObject).clearParseTaskTimeoutListener();
  (TaskManage as ESObject).runParseTaskTimer = undefined;
  (TaskManage as ESObject).clearParseTaskTimeoutListener();
}

function notify() {
  (TaskManage as ESObject).onNotify = undefined;
  TaskManage.notify('test', 1);
  (TaskManage as ESObject).onNotify = (id: string, pixelMap?: ESObject) => {
  };
  TaskManage.notify('test', 1);
}

function resetCache() {
  TaskManage.cache.clear();
  (TaskManage as ESObject).taskItems = [];
  TaskManage.resetCache();

  let cacheItem: ESObject = new Object();
  cacheItem.pixelMaps = new Map<string, ESObject>();
  cacheItem.pixelMaps.set('test', new TestTaskItem() as ESObject);
  TaskManage.cache.set('test', cacheItem);
  (TaskManage as ESObject).taskItems = [new TestTaskItem()];
  TaskManage.resetCache();
}

class TestTaskItem {
  release() {
  }

  getItem() {
  }

  cancel() {

  }
}