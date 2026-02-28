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

import type { AsyncCallback } from '../../model/common/AsyncCallback';
import lazy { Log } from '../../utils/Log';
import type { MenuOperationCallback } from './MenuOperationCallback';
import type { MenuOperation } from './MenuOperation';
import type { MenuContext } from './MenuContext';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { BrowserDataFactory } from '../../interface/BrowserDataFactory';
import lazy { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import type { PhotoAsset } from '../../access/UserFileManagerAccess';
import lazy { PhotoDataImpl } from '../../model/browser/photo/PhotoDataImpl';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';

const TAG: string = 'common_ProcessMenuOperation';

export class ProcessMenuOperation implements MenuOperation, AsyncCallback<String[]>, MenuOperationCallback {
  // Number of data operated in a batch
  public readonly BATCH_SIZE: number = 1;
  // Maximum progress
  public readonly MAX_PROGRESS: number = 100;
  public menuContext: MenuContext;
  public uris: string[] = [];
  public selectAssets: PhotoAsset[] = [];
  public count: number = Number.NaN;
  public onOperationEnd: Function | undefined = undefined;
  public navigationPageFunc?: Function;
  // Total batches operated
  public totalBatches: number = Number.NaN;
  public totalCount?: number = 0;
  public initialTotalCount?: number = undefined;
  // Currently operated batch
  public currentBatch: number = 0;
  public successBatch: number = 0;
  public isCancelled: boolean = false;
  public startTime: number = Number.NaN;
  public isPause: boolean = false;
  public isError: boolean = false;
  public operationType: string = 'PROCESS_MENU_OPERATION';
  public traceOperationType: string = 'PROCESS_MENU_OPERATION';
  private operationTypeList: string [] =
    ['DELETE_PHOTOS', 'HIDE_PHOTOS', 'FAVORATE_PHOTOS', 'ADD_PHOTOS_TO_ALBUM', 'REVERT_PHOTOS'];
  requestTime: number;
  protected clickedPathSet: Set<string> = new Set();

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
    this.requestTime = Date.now();
    this.navigationPageFunc = menuContext.navigationPageFunc;
  }

  public doAction(): void {

  }

  // Asynchronous callback for selectedCallback
  public callback(assets: String[]): void {

  }

  public onCompleted(): void {
    Log.info(TAG, `onCompleted ${this.isPause}`);
    this.successBatch++;
    if (!this.isPause) {
      this.cyclicOperation();
    }
  }

  public onError(err?: BusinessError | string): void {
    Log.error(TAG, `Operate the ${this.currentBatch} batch data error: ${
    err}, code: ${(err as BusinessError)?.code}, total ${this.totalBatches} batches`);
    this.isError = true;
    this.cyclicOperation();
  }

  public cancelProgress(): void {
    Log.info(TAG, 'cancelProgress');
    this.onOperatePause();
    this.onOperateCancelled();
  }

  // Operate a batch of data
  public requestOneBatchOperation(): void {

  }

  // Start processing operation
  public processOperation(): void {
    Log.info(TAG, 'processOperation start');
    TraceControllerUtils.startTraceWithTaskId(this.traceOperationType + '_ProgressOperation', this.requestTime);
    let length = 0;
    if (this.uris && this.uris.length > 0) {
      Log.info(TAG, 'processOperation start and length is uris length');
      length = this.uris.length;
    } else if (this.selectAssets) {
      Log.info(TAG, 'processOperation start and length is selectAssets.length');
      length = this.selectAssets.length;
    } else {
      Log.error(TAG, 'Invalid callback data, uris and selectAssets is null!');
      return;
    }
    Log.info(TAG, `selected count: ${this.count}, uris's length: ${length}`);
    // Batch deletion
    this.totalCount = this.menuContext.selectManager?.getSelectedCount();
    length = length > 0 ? length : (this.totalCount ?? 0);
    this.totalBatches = Math.floor(length / this.BATCH_SIZE) + ((length % this.BATCH_SIZE) ? 1 : 0);
    Log.info(TAG, `The count to be operate is ${length}, operate in ${this.totalBatches} batches`);
    if (this.isCancelled) {
      return;
    }
    this.startTime = Date.now();
    this.updateProgress(0, 0);
    this.requestOneBatchOperation();
  }

  // Batch circular deletion
  public cyclicOperation(): void {
    Log.info(TAG, 'cyclicOperation currentBatch: ' + this.currentBatch + `  totalBatches: ` + this.totalBatches);
    const completedCount = this.currentBatch * this.BATCH_SIZE;
    this.updateProgress(this.getExpectProgress(), completedCount);

    if (this.isCancelled) {
      this.isCancelled = false;
    }

    if (this.currentBatch >= this.totalBatches) {
      this.onProcessDone();
    } else {
      Log.info(TAG,'requestOneBatchOperation');
      this.requestOneBatchOperation();
    }
  }

  public onProcessDone(): void {
    Log.info(TAG,'onProcessDone');
    let finalCount: number = this.count;
    if (!Number.isFinite(finalCount) || finalCount <= 0) {
      finalCount = (this.totalCount && this.totalCount > 0)
        ? this.totalCount
        : this.currentBatch * this.BATCH_SIZE;
    }
    this.updateProgress(100, finalCount);
    this.navigationPageFunc?.();
    if (this.startTime != null) {
      let operateCount = this.currentBatch >= this.totalBatches ? finalCount : this.currentBatch * this.BATCH_SIZE;
      let costTime = Date.now() - this.startTime;
      Log.debug(TAG, `process data operate done, operate ${operateCount} items, cost time ${costTime} ms,\
            average ${(costTime / operateCount)} .`);
      let e2eLatency = Date.now() - this.startTime;
      if (e2eLatency >= BigDataConstants.FAULT_THRESHOLD && this.operationTypeList.includes(this.operationType)) {
        Log.info(TAG, 'onProcessDone reportOperationLatency');
        ReportToBigDataUtil.reportOperationLatency(this.operationType, this.startTime, e2eLatency, operateCount);
      }
    }
    TraceControllerUtils.finishTraceWithTaskId(this.traceOperationType + '_ProgressOperation', this.requestTime);
    this.onOperationEnd?.(this.isError, this.successBatch, this.count);
    this.selectAssets.splice(0, this.selectAssets.length);
  }

  public updateProgress(progress: number, currenCount: number): void {
    if (!this.menuContext?.broadCast) {
      Log.warn(TAG, 'onProcessDone broadCast undefined');
      return;
    }
    let finalProgress: number = Math.min(Math.max(progress, 0), this.MAX_PROGRESS);
    if (finalProgress >= this.MAX_PROGRESS) {
      finalProgress = this.MAX_PROGRESS;
      currenCount = this.count;
    }
    Log.info(TAG, `updateProgress: progress=${finalProgress}%, currentCount=${currenCount}, totalCount=${this.count}`);
    this.menuContext.broadCast?.emit(BroadCastConstants.UPDATE_PROGRESS, [finalProgress, currenCount]);
  }

  // Operate cancel callback
  public onOperateCancelled(): void {
    Log.info(TAG, 'Operate Cancel');
    this.isCancelled = true;
    this.onProcessDone();
  }

  // Operate cancel callback
  public onOperatePause(): void {
    Log.info(TAG, 'Operate Pause');
    this.isPause = true;
  }

  protected async waitIfPaused(): Promise<boolean> {
    while (this.isPause && !this.isCancelled) {
      await new Promise<void>((resolve: () => void) => setTimeout(resolve, 100));
    }
    return this.isCancelled;
  }

  // Calculate the operation progress according to the batch
  public getExpectProgress(): number {
    Log.info(TAG, 'getExpectProgress');
    if (this.count === 0) {
      return this.MAX_PROGRESS;
    }
    let progress = Math.min(
      Math.floor(this.MAX_PROGRESS * this.currentBatch * this.BATCH_SIZE / this.count), this.MAX_PROGRESS);
    return progress;
  }

  public async getFileAddOrMoveInfo(fileUri: string): Promise<PhotoAsset | undefined> {
    Log.info(TAG, `getFileCopyOrMoveInfo start uri: ${JSON.stringify(fileUri)}`);
    let dataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO) as PhotoDataImpl;
    let fileAsset = await dataImpl.getDataByUri(fileUri);
    return fileAsset;
  }

  public static async getFileAddOrMoveInfo(fileUri: string): Promise<PhotoAsset | undefined> {
    let dataImpl: PhotoDataImpl = new PhotoDataImpl();
    let fileAsset = await dataImpl.getDataByUri(fileUri);
    return fileAsset;
  }

  public onOperateContinue(): void {
    Log.info(TAG, 'Operate Continue');
    this.isPause = false;
    this.cyclicOperation();
  }

  /**
   * 反选场景，批量处理需要遍历全量数据，因此需要重新设置totalCount和totalBatch
   */
  public setTotalForInverseSelection(): void {
    if (this.menuContext.selectManager && this.menuContext.selectManager.inverseSelection) {
      this.totalCount = this.menuContext.selectManager.totalCount;
      this.totalBatches = Math.ceil((this.totalCount ?? 0) / this.BATCH_SIZE);
    }
  }

  /**
   * 批量处理选择的图片，包括连拍图片的处理
   *
   * @param operationCallback 待处理的操作，如移动、隐藏
   */
  protected batchOperationWidthBurstPhotos(operationCallback: AsyncCallback<PhotoAsset[]>) {
    this.currentBatch++;
    let startIndex = (this.currentBatch - 1) * this.BATCH_SIZE;
    let endIndex = Math.min(this.currentBatch * this.BATCH_SIZE, this.count);
    let inverseSelection = this.menuContext.selectManager?.inverseSelection ?? false;
    Log.info(TAG, `start do batch operation currentBatch: ${this.currentBatch}, totalCount: ${this.count}, inverseSelection: ${inverseSelection}`);
    if (inverseSelection) {
      let length = this.menuContext.selectManager?.totalCount ?? 0;
      startIndex = Math.max(length - (this.currentBatch * this.BATCH_SIZE), 0);
      let batchSize = (this.currentBatch === this.totalBatches) ? (length % this.BATCH_SIZE) : this.BATCH_SIZE;
      Log.info(TAG, `inverseSelection batch startIndex: ${startIndex}, batchSize=${batchSize}`);
      this.menuContext.selectManager?.batchGetSelectAssetsWidthBurstPhotos((assets: PhotoAsset[]) => {
        Log.info(TAG, `requestOneBatchOperation uris length is ${assets.length}`);
        operationCallback.callback(assets);
      }, this.clickedPathSet, inverseSelection, false, startIndex, batchSize, this.currentBatch);
    } else {
      if (!this.selectAssets) {
        Log.error(TAG, 'selectAssets is null');
        return;
      }
      let batchAssets: PhotoAsset[] = this.selectAssets.slice(startIndex, Math.min(endIndex, this.selectAssets.length));
      operationCallback.callback(batchAssets);
    }
  }

  /**
   * 设置批量操作已选择资源信息
   */
  protected setBatchSelectedInfo(): void {

    const selectManager = this.menuContext.selectManager;

    if (selectManager?.inverseSelection) {
      selectManager?.getClickedPath((clickedPath: Set<string>) => this.inverseSelectionCallback(clickedPath));
    } else {
      selectManager?.getSelectAssetsWidthBurstPhotos((assets: PhotoAsset[]) => this.selectedAssetCallback(assets));
    }
  }

  /**
   * 选择资源回调
   *
   * @param assets 选中的资源
   */
  protected selectedAssetCallback(assets: PhotoAsset[]): void {
    if (this.isCancelled) {
      return;
    }
    this.selectAssets = assets;
    this.count = assets.length;
    Log.info(TAG, `selectAssetCallback ${this.selectAssets.length}`);
    this.processOperation();
  }

  private inverseSelectionCallback(clickedPath: Set<string>): void {
    clickedPath.forEach((item) => {
      this.clickedPathSet?.add(item);
    });
    this.processOperation();
  }
}