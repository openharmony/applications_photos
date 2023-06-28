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

import type { AsyncCallback } from '../../model/common/AsyncCallback';
import { Log } from '../../utils/Log';
import type { MenuOperationCallback } from './MenuOperationCallback';
import type { MenuOperation } from './MenuOperation';
import { MenuContext } from './MenuContext';
import { BroadCastConstants } from '../../model/common/BroadCastConstants';
import { BrowserDataFactory } from '../../interface/BrowserDataFactory';
import { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import type { FileAsset } from '../../access/UserFileManagerAccess';

const TAG: string = 'common_ProcessMenuOperation';

export class ProcessMenuOperation implements MenuOperation, AsyncCallback<String[]>, MenuOperationCallback {
  // Number of data operated in a batch
  readonly BATCH_SIZE: number = 1;

  // Maximum progress
  readonly MAX_PROGRESS: number = 100;
  menuContext: MenuContext;
  uris: string[];
  count: number;
  onOperationEnd: Function;

  // Total batches operated
  totalBatches: number;

  // Currently operated batch
  currentBatch: number = 0;
  successBatch: number = 0;
  isCancelled: boolean = false;
  startTime: number;
  isPause: boolean = false;
  isError: boolean = false;
  requestTime: number;

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
    this.requestTime = Date.now();
  }

  doAction(): void {

  }

  // Asynchronous callback for getSelection
  callback(uris: string[]): void {

  }

  onCompleted(): void {
    Log.info(TAG, `onCompleted ${this.isPause}`);
    this.successBatch++;
    if (!this.isPause) {
      this.cyclicOperation();
    }
  }

  onError(): void {
    Log.error(TAG, `Operate the ${this.currentBatch} batch data error, total ${this.totalBatches} batches`);
    this.isError = true;
    this.cyclicOperation();
  }

  // Operate a batch of data
  requestOneBatchOperation(): void {

  }

  // Start processing operation
  processOperation(): void {
    Log.info(TAG, 'processOperation start');
    TraceControllerUtils.startTraceWithTaskId('ProgressOperation', this.requestTime);
    if (this.uris == null) {
      Log.error(TAG, 'Invalid callback data, uris is null!');
      return;
    }
    let length = this.uris.length;
    Log.info(TAG, `selected count: ${this.count}, uris's length: ${length}`);
    // Batch deletion
    this.totalBatches = Math.floor(length / this.BATCH_SIZE) + ((length % this.BATCH_SIZE) ? 1 : 0);
    Log.info(TAG, `The count to be operate is ${length}, operate in ${this.totalBatches} batches`);
    if (this.isCancelled) {
      return;
    }
    this.startTime = Date.now();
    this.requestOneBatchOperation();
  }

  // Batch circular deletion
  cyclicOperation() {
    Log.info(TAG, 'cyclicOperation');
    this.menuContext.broadCast.emit(BroadCastConstants.UPDATE_PROGRESS,
      [this.getExpectProgress(), this.currentBatch]);

    if (this.isCancelled) {
      this.isCancelled = false;
    }

    if (this.currentBatch >= this.totalBatches) {
      this.onProcessDone();
    } else {
      this.requestOneBatchOperation();
    }
  }

  onProcessDone(): void {
    this.menuContext.broadCast.emit(BroadCastConstants.UPDATE_PROGRESS, [100]);
    if (this.startTime != null) {
      let operateCount = this.currentBatch >= this.totalBatches ? this.count : this.currentBatch * this.BATCH_SIZE;
      let costTime = Date.now() - this.startTime;
      Log.debug(TAG, `process data operate done, operate ${operateCount} items, cost time ${costTime} ms,\
            average ${(costTime / operateCount)} .`);
    }
    TraceControllerUtils.finishTraceWithTaskId('ProgressOperation', this.requestTime);
    this.onOperationEnd && this.onOperationEnd(this.isError, this.successBatch, this.count);
  }

  // Operate cancel callback
  onOperateCancelled(): void {
    Log.info(TAG, 'Operate Cancel');
    this.isCancelled = true;
    this.onProcessDone();
  }

  // Operate cancel callback
  onOperatePause(): void {
    Log.info(TAG, 'Operate Pause');
    this.isPause = true;
  }

  // Calculate the operation progress according to the batch
  getExpectProgress(): number {
    Log.info(TAG, 'getExpectProgress');
    let progress = Math.min(
      Math.floor(this.MAX_PROGRESS * this.currentBatch * this.BATCH_SIZE / this.count), this.MAX_PROGRESS);
    return progress;
  }

  async getFileAddOrMoveInfo(fileUri: string): Promise<FileAsset> {
    Log.debug(TAG, `getFileCopyOrMoveInfo start uri: ${JSON.stringify(fileUri)}`);
    let dataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO);
    let fileAsset = await dataImpl.getDataByUri(fileUri);
    return fileAsset;
  }
}