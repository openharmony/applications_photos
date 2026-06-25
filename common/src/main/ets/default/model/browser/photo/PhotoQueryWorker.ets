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

import lazy { BrowserDataFactory } from '../../../interface/BrowserDataFactory';
import type { BrowserDataInterface, FetchType, QueryParam } from '../../../interface/BrowserDataInterface';
import lazy { Log } from '../../../utils/Log';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import type { AsyncCallback } from '../../common/AsyncCallback';
import type { MediaItem } from './MediaItem';
import type { PhotoDataImpl } from './PhotoDataImpl';

/* instrument ignore file */
const TAG: string = 'PhotoQueryWorker';

class GetDataTask {
  start: number;
  count: number;
  callbackFunc: Function;
  albumUri: string | undefined;
  filterMediaType: string | undefined;
  fetchType: FetchType | undefined;
  startTime: number;

  constructor(start: number, count: number, callbackFunc: Function, albumUri?: string, filterMediaType?: string,
    fetchType?: FetchType) {
    this.start = start;
    this.count = count;
    this.callbackFunc = callbackFunc;
    this.albumUri = albumUri;
    this.filterMediaType = filterMediaType;
    this.fetchType = fetchType;
    this.startTime = Date.now();
  }
}

class GetDataCountTask {
  albumUri: string | undefined;
  filterMediaType?: string | undefined;
  callbackFunc: Function;
  needThumbnailReady?: boolean;
  startTime: number;

  constructor(callbackFunc: Function, albumUri?: string, filterMediaType?: string, needThumbnailReady?: boolean) {
    this.callbackFunc = callbackFunc;
    this.albumUri = albumUri;
    this.filterMediaType = filterMediaType;
    this.needThumbnailReady = needThumbnailReady;
    this.startTime = Date.now();
  }
}

export class GetPhotoDataCallback implements AsyncCallback<MediaItem[]> {
  requestTime: number;
  worker: PhotoQueryWorker;
  task: GetDataTask;

  constructor(worker: PhotoQueryWorker, task: GetDataTask) {
    this.worker = worker;
    this.task = task;
    this.requestTime = Date.now();
    TraceControllerUtils.startTraceWithTaskId('GetPhotoData', this.requestTime);
  }

  public callback(assets: MediaItem[], dataAlbumUri?: string): void {
    TraceControllerUtils.finishTraceWithTaskId('GetPhotoData', this.requestTime);
    Log.info(TAG, `took ${Date.now() - this.requestTime} / ${Date.now() - this.task.startTime} ` +
      `milliseconds to get photo data: start = ${this.task.start}, ` +
      `count = ${this.task.count}, and result length = ${assets.length}`);
    this.task.callbackFunc(assets, this.task.start, dataAlbumUri);
    this.worker.getDataWorkingCount--;
    this.worker.doGetDataTask();
  }
}

export class GetPhotoDataCountCallback implements AsyncCallback<number> {
  requestTime: number;
  worker: PhotoQueryWorker;
  task: GetDataCountTask;

  constructor(worker: PhotoQueryWorker, task: GetDataCountTask) {
    this.worker = worker;
    this.task = task;
    this.requestTime = Date.now();
    TraceControllerUtils.startTraceWithTaskId('GetPhotoDataCount', this.requestTime);
  }

  public callback(count: number, dataAlbumUri?: string): void {
    TraceControllerUtils.finishTraceWithTaskId('GetPhotoDataCount', this.requestTime);
    Log.info(TAG, `took ${Date.now() - this.requestTime} / ${Date.now() - this.task.startTime} ` +
      `milliseconds to get data count: ${count}`);
    this.task.callbackFunc(count, dataAlbumUri);
    this.worker.getDataCountWorkingCount--;
    this.worker.doGetDataCountTask();
  }
}

export class PhotoQueryWorker {
  private getDataTaskQueue: GetDataTask[];
  private getDataCountTaskQueue: GetDataCountTask[];
  private photoDataImpl: BrowserDataInterface | PhotoDataImpl;
  public getDataWorkingCount: number;
  public getDataCountWorkingCount: number;
  private activeStart: number;
  private activeEnd: number;
  private static readonly PARALLEL_GET_DATA_TASK_COUNT: number = 3;
  private static readonly PARALLEL_GET_DATA_COUNT_TASK_COUNT: number = 1;

  constructor(photoDataImpl?: BrowserDataInterface) {
    this.photoDataImpl =
      photoDataImpl ?? BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO) as PhotoDataImpl;
    this.getDataTaskQueue = [];
    this.getDataCountTaskQueue = [];
    this.getDataWorkingCount = 0;
    this.getDataCountWorkingCount = 0;
    this.activeStart = 0;
    this.activeEnd = 0;
  }

  public addDataTask(start: number, count: number, callbackFunc: Function, albumUri?: string, filterMediaType?: string,
    fetchType?: FetchType): void {
    let newTask: GetDataTask = new GetDataTask(start, count, callbackFunc, albumUri, filterMediaType, fetchType);
    this.getDataTaskQueue.push(newTask);
    Log.info(TAG, `addDataTask [${start}, ${count}], left tasks: ${this.getDataTaskQueue.length}`);
    this.doGetDataTask();
  }

  public addDataCountTask(callbackFunc: Function, albumUri?: string, filterMediaType?: string): void {
    let newTask: GetDataCountTask = new GetDataCountTask(callbackFunc, albumUri, filterMediaType, true);
    Log.info(TAG, 'addDataCountTask');
    this.getDataCountTaskQueue.push(newTask);
    this.doGetDataCountTask();
  }

  public doGetDataTask(): void {
    Log.info(TAG, `doGetDataTask, working: ${this.getDataWorkingCount}, ` +
      `left: ${this.getDataTaskQueue.length}`);
    if (this.getDataTaskQueue.length === 0) {
      return;
    }
    while (this.getDataWorkingCount < PhotoQueryWorker.PARALLEL_GET_DATA_TASK_COUNT) {
      let task: GetDataTask | undefined = undefined;
      while (this.getDataTaskQueue.length > 0) {
        task = this.getDataTaskQueue.shift();
        if ((this.activeStart === 0) && (this.activeEnd === 0)) {
          break;
        }
        if (!task) {
          continue;
        }
        if ((task && task.start <= this.activeEnd) && ((task.start + task.count) >= this.activeStart)) {
          break;
        }
        Log.info(TAG, `drop task [${task?.start}, ${task?.count}] beyond [${this.activeStart}, ${this.activeEnd}], ` +
          `left task: ${this.getDataTaskQueue.length}`);
        task = undefined;
      }
      if (!task) {
        return;
      }
      this.getDataWorkingCount++;
      Log.info(TAG, `do task [${task.start}, ${task.count}] in [${this.activeStart}, ${this.activeEnd}]`);
      let callback: GetPhotoDataCallback = new GetPhotoDataCallback(this, task);
      let param: QueryParam = {
        albumUri: task.albumUri,
        start: task.start,
        count: task.count,
        filterMediaType: task.filterMediaType,
        fetchType: task.fetchType,
        startTime: task.startTime,
      };
      this.photoDataImpl.getData(callback, param);
    }

  }

  public doGetDataCountTask(): void {
    Log.info(TAG, `doGetDataCountTask, working: ${this.getDataCountWorkingCount}, ` +
      `left: ${this.getDataCountTaskQueue.length}`);
    if (this.getDataCountTaskQueue.length === 0) {
      return;
    }
    while (this.getDataCountWorkingCount < PhotoQueryWorker.PARALLEL_GET_DATA_COUNT_TASK_COUNT) {
      this.getDataCountWorkingCount++;
      let task: GetDataCountTask | undefined = this.getDataCountTaskQueue.shift();
      if (!task) {
        continue;
      }
      Log.info(TAG, 'do task');
      let callback: GetPhotoDataCountCallback = new GetPhotoDataCountCallback(this, task);
      let param: QueryParam = {
        albumUri: task.albumUri,
        filterMediaType: task.filterMediaType,
        needThumbnailReady: task.needThumbnailReady,
      };
      this.photoDataImpl.getDataCount(callback, param);
    }
  }

  public updateGetDataTaskCoverage(activeStart: number, activeEnd: number): void {
    this.activeStart = activeStart;
    this.activeEnd = activeEnd;
  }
}