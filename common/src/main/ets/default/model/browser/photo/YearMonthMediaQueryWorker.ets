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

import lazy { AsyncCallback } from '../../common/AsyncCallback';
import lazy { Constants } from '../../common/Constants';
import lazy { Log } from '../../../utils/Log';
import lazy { MediaItem } from './MediaItem';
import lazy { Priority, YearMonthQueryParam } from './YearMonthQueryParam';
import lazy { YearMonthDataInterface } from '../../../interface/BrowserDataInterface';
import lazy { YearMonthMediaItem } from './YearMonthMediaItem';

const TAG: string = 'YearMonthMediaQueryWorker';

const MAX_QUERY_TASK_NUM = 1;

const HIGH_TASK_QUEUE_MAX_NUM = 5;

class MediaDataQueryTask {
  public queryParam: YearMonthQueryParam;
  public callbackFunc: Function;
  public needExecute: boolean;

  constructor(queryParam: YearMonthQueryParam, callbackFunc: Function) {
    this.queryParam = queryParam;
    this.callbackFunc = callbackFunc;
    this.needExecute = true;
  }
}

class MediaDataQueryCallback implements AsyncCallback<MediaItem[]> {
  public worker: YearMonthMediaQueryWorker;
  public task: MediaDataQueryTask;

  constructor(worker: YearMonthMediaQueryWorker, task: MediaDataQueryTask) {
    this.worker = worker;
    this.task = task;
  }

  callback(data: YearMonthMediaItem[]): void {
    if (!this.task || !this.worker || !data) {
      return;
    }

    // 查询任务结束，回调通知
    if (this.task.callbackFunc) {
      this.task.callbackFunc(this.task.queryParam, data);
    }

    // 从任务中移除掉查询区间相同的查询任务，避免冗余查询
    this.worker.removeMediaDataTask(this.task.queryParam);

    // 查询任务数减1，并发起下一个任务查询
    this.worker.queryWorkingCount--;
    this.worker.executeTask();
  }
}

/**
 * 年月视图元数据查询器
 */
export class YearMonthMediaQueryWorker {
  /**
   * 当前查询任务数
   */
  public queryWorkingCount: number = 0;
  /**
   * 高优先级查询任务队列
   */
  private highTaskQueue: MediaDataQueryTask[] = [];
  /**
   * 低优先级查询任务队列
   */
  private lowTaskQueue: MediaDataQueryTask[] = [];
  /**
   * 是否暂停低优先级任务。对于高优先级任务，队列最多支持5个任务，因此不需要暂停
   */
  private pauseLowTaskFlag: boolean = true;
  /**
   * 查询实现类
   */
  private photoDataImpl: YearMonthDataInterface;

  constructor(photoDataImpl: YearMonthDataInterface) {
    this.photoDataImpl = photoDataImpl;
  }

  /**
   * 创建元数据批量任务，一般是低优先级任务，后台执行，避免大数据量变更时影响主线程
   *
   * @param start 元数据起始
   * @param count 元数据个数
   * @param batchCount 批量查询个数
   * @param callbackFunc 查询回调
   */
  public addBatchMediaDataTask(start: number, count: number, batchCount: number, callbackFunc: Function): void {
    if (start < 0 || count <= 0 || batchCount <= 0) {
      return;
    }

    Log.i(TAG, `addBatchMediaDataTask [${start}, ${count}], left tasks len: ${this.lowTaskQueue.length}`);
    let taskNum: number = Math.floor(count / batchCount);
    for (let index: number = 0; index < taskNum; index++) {
      let startIndex: number = start + index * batchCount;
      let queryParam: YearMonthQueryParam = new YearMonthQueryParam(startIndex, batchCount, Priority.LOW);
      this.addLowMediaDataTask(queryParam, callbackFunc);
    }
    let lastCount: number = count - taskNum * batchCount;
    if (lastCount !== 0) {
      let queryParam: YearMonthQueryParam = new YearMonthQueryParam(
        start + taskNum * batchCount, lastCount, Priority.LOW);
      this.addLowMediaDataTask(queryParam, callbackFunc);
    }
  }

  /**
   * 创建单个低优先级查询任务
   * 注意：由于低优先级队列任务可能较多，因此创建前不要先查询低优先级队列中是否已有查询任务、已有的话不再创建，避免耗时遍历查询
   *
   * @param queryParam 查询参数
   * @param callbackFunc 查询回调
   */
  public addLowMediaDataTask(queryParam: YearMonthQueryParam, callbackFunc: Function): void {
    if (!queryParam || !queryParam.isValid() || queryParam.priority !== Priority.LOW) {
      return;
    }

    let newTask: MediaDataQueryTask = new MediaDataQueryTask(queryParam, callbackFunc);
    this.lowTaskQueue.push(newTask);
    this.executeTask();
  }

  /**
   * 创建单个高优先级查询任务
   * 注意：创建前，先查询高优先级队列中是否已有查询任务，已有的话不再创建
   *
   * @param queryParam 查询参数
   * @param callbackFunc 查询回调
   */
  public addHighMediaDataTask(queryParam: YearMonthQueryParam, callbackFunc: Function): void {
    if (!queryParam || !queryParam.isValid() || queryParam.priority !== Priority.HIGH) {
      return;
    }

    let hasTask: boolean = this.hasMediaDataTask(queryParam);
    Log.i(TAG, `addHighMediaDataTask, ${queryParam.toString()}, hasTask:${hasTask}`);
    if (hasTask) {
      return;
    }

    let newTask: MediaDataQueryTask = new MediaDataQueryTask(queryParam, callbackFunc);
    this.highTaskQueue.push(newTask);
    this.executeTask();
  }

  /**
   * 移除所有查询任务
   */
  public removeAllTasks(): void {
    this.removeAllHighTasks();
    this.removeAllLowTasks();
  }

  /**
   * 移除所有高优先级查询任务
   */
  public removeAllHighTasks(): void {
    Log.i(TAG, `removeAllHighTasks len:${this.highTaskQueue.length}`);
    this.highTaskQueue.splice(0, this.highTaskQueue.length);
  }

  /**
   * 移除所有低优先级查询任务
   */
  public removeAllLowTasks(): void {
    Log.i(TAG, `removeAllLowTasks len:${this.lowTaskQueue.length}`);
    this.lowTaskQueue.splice(0, this.lowTaskQueue.length);
  }

  /**
   * 移除单个查询任务
   *
   * @param queryParam 查询参数
   */
  public removeMediaDataTask(queryParam: YearMonthQueryParam): void {
    if (!queryParam || !queryParam.isValid()) {
      return;
    }

    if (queryParam.priority === Priority.HIGH) {
      for (let index: number = 0; index < this.highTaskQueue.length; index++) {
        if (!this.highTaskQueue[index].queryParam) {
          continue;
        }
        if (this.highTaskQueue[index].queryParam.start === queryParam.start &&
          this.highTaskQueue[index].queryParam.count === queryParam.count) {
          this.highTaskQueue[index].needExecute = false;
          break;
        }
      }
    } else if (queryParam.priority === Priority.LOW) {
      for (let index: number = 0; index < this.lowTaskQueue.length; index++) {
        if (!this.lowTaskQueue[index].queryParam) {
          continue;
        }
        if (this.lowTaskQueue[index].queryParam.start === queryParam.start &&
          this.lowTaskQueue[index].queryParam.count === queryParam.count) {
          this.lowTaskQueue[index].needExecute = false;
          break;
        }
      }
    }
  }

  /**
   * 任务队列中是否包含查询任务
   *
   * @param queryParam 查询参数
   * @returns 是否包含
   */
  private hasMediaDataTask(queryParam: YearMonthQueryParam): boolean {
    if (!queryParam || !queryParam.isValid()) {
      return false;
    }

    if (queryParam.priority === Priority.HIGH) {
      for (let index: number = 0; index < this.highTaskQueue.length; index++) {
        if (!this.highTaskQueue[index].queryParam) {
          continue;
        }
        if (this.highTaskQueue[index].queryParam.start === queryParam.start &&
          this.highTaskQueue[index].queryParam.count === queryParam.count &&
        this.highTaskQueue[index].needExecute) {
          return true;
        }
      }
    } else if (queryParam.priority === Priority.LOW) {
      for (let index: number = 0; index < this.lowTaskQueue.length; index++) {
        if (!this.lowTaskQueue[index].queryParam) {
          continue;
        }
        if (this.lowTaskQueue[index].queryParam.start === queryParam.start &&
          this.lowTaskQueue[index].queryParam.count === queryParam.count &&
        this.lowTaskQueue[index].needExecute) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * 暂停低优先级查询任务
   */
  public pauseLowMediaDataTask(): void {
    this.pauseLowTaskFlag = true;
  }

  /**
   * 恢复查询任务
   */
  public resumeMediaDataTask(): void {
    this.pauseLowTaskFlag = false;
    this.executeTask();
  }

  /**
   * 执行查询任务
   */
  public executeTask(): void {
    // 没有任何高/低优先级任务，不处理
    if (this.highTaskQueue.length === 0 && this.lowTaskQueue.length === 0) {
      return;
    }

    // 只有低优先级任务，且任务为暂停标志，不处理
    if (this.highTaskQueue.length === 0 && this.pauseLowTaskFlag) {
      return;
    }

    while (this.queryWorkingCount < MAX_QUERY_TASK_NUM) {
      if (this.queryWorkingCount < 0) {
        this.queryWorkingCount = 0;
      }
      this.queryWorkingCount++;
      if (this.highTaskQueue.length > 0) {
        this.executeHighTask();
      } else {
        this.executeLowTask();
      }
      break;
    }
  }

  private executeHighTask(): void {
    let task: MediaDataQueryTask | undefined = undefined;
    let isTaskWorking: boolean = false;
    while (this.highTaskQueue.length > 0) {
      // 高优先级队列最多5个任务
      let notNeedExecuteTaskNum: number = this.highTaskQueue.length - HIGH_TASK_QUEUE_MAX_NUM;
      for (let index: number = 0; index < notNeedExecuteTaskNum; index++) {
        this.highTaskQueue.shift();
      }
      // 高优先级任务，后进先出
      task = this.highTaskQueue.pop();
      if (!task) {
        Log.w(TAG, 'high task invalid');
        continue;
      }
      if (!task.needExecute || !task.queryParam || !task.queryParam.isValid()) {
        continue;
      }
      if (!this.photoDataImpl) {
        continue;
      }

      Log.i(TAG, `executeHighTask, ${task.queryParam.toString()}`);
      isTaskWorking = true;
      let callback: MediaDataQueryCallback = new MediaDataQueryCallback(this, task);
      this.photoDataImpl.getMediaData(callback, task.queryParam);
      break;
    }
    if (!isTaskWorking) {
      this.queryWorkingCount--;
      this.executeTask();
    }
  }

  private executeLowTask(): void {
    let task: MediaDataQueryTask | undefined = undefined;
    let isTaskWorking: boolean = false;
    while (this.lowTaskQueue.length > 0) {
      // 低优先级的任务，先进先出
      task = this.lowTaskQueue.shift();
      if (!task) {
        Log.w(TAG, 'low task invalid');
        continue;
      }
      if (!task.needExecute || !task.queryParam || !task.queryParam.isValid()) {
        continue;
      }
      if (!this.photoDataImpl) {
        continue;
      }

      if (task.queryParam.start % Constants.YEAR_MONTH_MEDIA_DATA_BATCH_NUM === 0) {
        // 控制低优先级任务的查询结果打印，避免低优先级打印高频
        Log.i(TAG, `executeLowTask, ${task.queryParam.toString()}`);
      }
      isTaskWorking = true;
      let callback: MediaDataQueryCallback = new MediaDataQueryCallback(this, task);
      this.photoDataImpl.getMediaData(callback, task.queryParam);
      break;
    }
    if (!isTaskWorking) {
      this.queryWorkingCount--;
      this.executeTask();
    }
  }
}