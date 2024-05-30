/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import worker, { MessageEvents } from '@ohos.worker';
import ArrayList from '@ohos.util.ArrayList';
import { Log } from '../../utils/Log';
import { Constants } from './Constants';


const TAG = 'WorkerThreadPool'

// 跨模块调用worker路径前缀
const crossModulePathPrefix: string = '@bundle:com.ohos.photos/';
const PHONE_ENTRY_NAME: string = 'phone_photos';
const PC_ENTRY_NAME: string = 'pc_photos';

/**
 * 自定义worker线程池，负责worker线程的创建、启动、销毁
 */
export class WorkerThreadPool {
  public static readonly CAPACITY: number = 3;
  private static workerThreadPoolInstance: WorkerThreadPool;
  private workerList: ArrayList<worker.ThreadWorker> = new ArrayList();

  private constructor() {
  }

  public static getInstance(): WorkerThreadPool {
    if (!this.workerThreadPoolInstance) {
      Log.info(TAG, 'single instance create')
      this.workerThreadPoolInstance = new WorkerThreadPool();
    }
    return this.workerThreadPoolInstance;
  }

  /**
   * 创建worker
   * @param relativePath  worker.ts文件所在的相对路径
   * @param deviceType    设备类型，对应不同entryName (phone, pc)
   */
  public static createWorker(relativePath: string, deviceType: string): worker.ThreadWorker {
    Log.info(TAG, 'create worker, relativePath: ' + relativePath);
    let entryName = deviceType == Constants.DEFAULT_DEVICE_TYPE ? PHONE_ENTRY_NAME : PC_ENTRY_NAME;
    let workerInstance: worker.ThreadWorker;
    try {
      workerInstance = new worker.ThreadWorker(crossModulePathPrefix + entryName + relativePath);
    } catch (err) {
      Log.error(TAG, 'create worker instance failed' + err);
    }
    return workerInstance;
  }

  /**
   * 启动一个worker
   * @param worker  worker对象
   * @param buffer  传入worker的buffer
   * @param excFunc 主线程回调函数
   * @param name    worker名称
   */
  public static startWorker(worker: worker.ThreadWorker, buffer: ArrayBuffer, callback: Function, name: string): void {
    if (!worker) {
      Log.error(TAG, 'worker' + name + 'is null');
    }
    worker.postMessage(buffer);
    worker.onmessage = function (e: MessageEvents) {
      callback(e, name);
      Log.info(TAG, 'worker onmessage end, terminate')
      worker.terminate();
    }
    worker.onexit = function () {
      Log.debug(TAG, 'worker' + name + 'exit');
    }
  }

  /**
   * 终止worker运行
   * @param worker
   */
  public static terminateWorker(worker: worker.ThreadWorker) {
    Log.info(TAG, 'terminate worker')
    if (!worker) {
      Log.error(TAG, 'worker is null');
    }
    try {
      worker.terminate();
    } catch (err) {
      Log.error(TAG, 'worker terminate error: ' + JSON.stringify(err));
    }
  }

  /**
   * 最大容量
   */
  public capacity(): number {
    return WorkerThreadPool.CAPACITY;
  }

  /**
   * 执行workerList中的worker
   * @param path                   worker.ts文件路径
   * @param data                   处理的数据
   * @param byteLengthOfOneGroup   需要以组为单位处理的数据，例如直方图的RGBA像素统计，一组4个字节，该值为4
   * @param excFunc                主线程回调函数，用于worker结果的数据汇总
   */
  public run(path: string, data: ArrayBuffer, byteLengthOfOneGroup: number, mainThreadCallback: Function) {
    Log.info(TAG, 'thread pool start running, capacity: ' + WorkerThreadPool.CAPACITY);
    let groupCount = data.byteLength / byteLengthOfOneGroup;
    let byteLengthOfOneWorker = Math.floor(groupCount / WorkerThreadPool.CAPACITY) * byteLengthOfOneGroup;
    let deviceType: string = AppStorage.get('deviceType');
    const FIRST_INDEX = 0;
    for (let i = WorkerThreadPool.CAPACITY - 1; i >= 0; i--) {
      let workerInstance = WorkerThreadPool.createWorker(path, deviceType);
      this.workerList.add(workerInstance);
      let dataSlice = (i == FIRST_INDEX) ? data.slice(i * byteLengthOfOneWorker) : data.slice(i *
      byteLengthOfOneWorker, (i + 1) *
      byteLengthOfOneWorker);
      WorkerThreadPool.startWorker(workerInstance, dataSlice, mainThreadCallback, 'worker instance ' + i);
    }
  }

  /**
   * 终止WorkerThreadPool的所有worker
   */
  public stop(): void {
    this.workerList.forEach((workerInstance, index) => {
      Log.info(TAG, 'worker ' + index + ' terminate.')
      WorkerThreadPool.terminateWorker(workerInstance);
    });
    this.workerList.clear();
  }
}