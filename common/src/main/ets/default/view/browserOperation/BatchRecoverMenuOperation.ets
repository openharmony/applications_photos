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

import lazy { BigDataConstants, ReportToBigDataUtil } from '../../../default/utils/ReportToBigDataUtil';
import lazy { BroadCastConstants } from '../../../default/model/common/BroadCastConstants';
import lazy { BrowserOperationFactory } from '../../../default/interface/BrowserOperationFactory';
import lazy { Log } from '../../../default/utils/Log';
import lazy { MenuContext } from '../../../default/view/browserOperation/MenuContext';
import lazy { PhotoAsset } from '../../../default/access/UserFileManagerAccess';
import lazy { ProcessMenuOperation } from '../../../default/view/browserOperation/ProcessMenuOperation';
import lazy { SelectManager } from '../../../default/model/browser/SelectManager';
import lazy { BusinessError } from '@ohos.base';

/* instrument ignore file */
const TAG: string = 'browser_BatchRecoverMenuOperation';

export class BatchRecoverMenuOperation extends ProcessMenuOperation {
  readonly BATCH_SIZE: number = 1000;
  private readonly RECOVER_PROGRESS_MESSAGE_WIDTH = 120;
  private callbackFunc?: Function;
  private clickedPath: Set<string> | undefined = new Set();
  private inverseSelection: boolean = false;
  private batchRemoveCancelFunc: Function = (): void => {
    this.cancelFunc();
  };

  constructor(menuContext: MenuContext) {
    super(menuContext);
    //初始化绑定this指向
    this.callbackFunc = (uris: string[]): void => this.callback(uris);
    this.operationType = 'REVERT_PHOTOS';
    this.traceOperationType = 'REVERT_PHOTOS';
  }

  doAction(): void {
    if (this.menuContext == null) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    let selectManager: SelectManager | undefined = this.menuContext.selectManager;
    if (selectManager == null) {
      Log.error(TAG, 'selectManager is null, return');
      return;
    }
    this.count = selectManager.getSelectedCount();
    this.totalCount = this.count;
    this.inverseSelection = selectManager?.inverseSelection;
    if (this.count <= 0) {
      Log.error(TAG, 'count <= 0, return');
      return;
    }

    this.onOperationEnd = this.menuContext.onOperationEnd;
    if (selectManager?.inverseSelection) {
      selectManager.getClickedPath((clickedPath: Set<string>) => this.clickedPathCallback(clickedPath));
    } else {
      selectManager.getSelectAssetsWidthBurstPhotos((assets: PhotoAsset[]) =>
      this.selectAssetCallback(assets), true);
    }
    let onOperationStart: Function = this.menuContext.onOperationStart;
    onOperationStart?.();

    interface Msg {
      count: number;
      from: string;
    }

    let msg: Msg = {
      count: this.count,
      from: BigDataConstants.GRID_ALBUM_PHOTO,
    };
    ReportToBigDataUtil.report(BigDataConstants.RECOVER_MENU_RESPONSE, msg);

    this.menuContext.broadCast?.on(BroadCastConstants.CANCEL_PROGRESS_DIALOG, (): void => this.cancelProgress());
    this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
      [$r('app.string.action_recover_process'), this.batchRemoveCancelFunc, undefined, this.RECOVER_PROGRESS_MESSAGE_WIDTH]);
  }

  selectAssetCallback(assets: PhotoAsset[]): void {
    this.selectAssets = assets;
    Log.info(TAG, `selectAssetCallback ${this.selectAssets.length}`);
    this.processOperation();
  }

  clickedPathCallback(clickedPath: Set<string>): void {
    clickedPath.forEach((item) => {
      this.clickedPath?.add(item);
    })
    Log.i(TAG, `inverseSelection clickedPath length  ${this.clickedPath?.size}`);
    this.processOperation();
  }

  onOperateContinue(): void {
    Log.info(TAG, 'Operate Continue');
    this.isPause = false;
    this.cyclicOperation();
  }

  cancelFunc(): void {
    Log.info(TAG, 'progress cancel');
    this.onOperatePause();
    let cancelMessage = $r('app.string.recover_cancel_message', `${this.getExpectProgress().toString()}%`);

    this.menuContext.broadCast?.emit(BroadCastConstants.CANCEL_OPERATE,
      [cancelMessage, (): void => {
        this.onOperateContinue();
      }, (): void => {
        this.onOperateCancelled();
      }]);
  }

  // Asynchronous callback for getSelection
  callback(uris: string[]): void {
    if (this.isCancelled) {
      return;
    }
    this.uris = uris;
    this.processOperation();
  }

  // Delete a batch of data
  public async requestOneBatchOperation(): Promise<void> {
    if (this.isCancelled) {
      Log.info(TAG, 'requestOneBatchOperation isCancelled, return.');
      return;
    }
    this.currentBatch++;
    this.setTotalForInverseSelection();
    let startIndex: number = (this.totalBatches - this.currentBatch) * this.BATCH_SIZE;
    let endIndex = startIndex + this.BATCH_SIZE;
    let batchAssets: PhotoAsset[] = [];
    if (this.inverseSelection && this.clickedPath) {
      this.menuContext.selectManager?.batchGetSelectAssetsWidthBurstPhotos((assets: PhotoAsset[]) => {
        batchAssets = assets;
        this.doRecoverOperation(batchAssets);
      }, this.clickedPath, this.inverseSelection, true, startIndex, this.BATCH_SIZE);
    } else {
      batchAssets = this.selectAssets.slice(startIndex, Math.min(endIndex, this.selectAssets.length));
      this.doRecoverOperation(batchAssets);
    }
  }

  public doRecoverOperation(batchAssets: PhotoAsset[]) {
    if (batchAssets.length === 0) {
      Log.warn(TAG, 'batchAssets is empty');
      return;
    }
    let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
    operationImpl.recoverFromTrash(batchAssets).then((): void => {
      this.onCompleted();
      batchAssets.splice(0, batchAssets.length);
    }).catch((error: BusinessError) => {
      Log.error(TAG, `recover error: ${error}, code: ${error?.code}`);
      this.onError();
      batchAssets.splice(0, batchAssets.length);
    })
  }
}