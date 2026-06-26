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

import lazy { BrowserOperationFactory } from '../../interface/BrowserOperationFactory';
import lazy { Log } from '../../utils/Log';
import type { MenuContext } from './MenuContext';
import lazy { ProcessMenuOperation } from './ProcessMenuOperation';
import type { SelectManager } from '../../model/browser/SelectManager';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import type { PhotoAsset } from '../../access/PhotoAccessHelperAccess';
import lazy { AlbumSetDataSourceManager } from '../../model/browser/album/AlbumSetDataSourceManager';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { MediaItem } from '../../model/browser/photo/MediaItem';

/* instrument ignore file */
const TAG: string = 'browser_FavoriteMenuOperation';

export class FavoriteMenuOperation extends ProcessMenuOperation {
  readonly BATCH_SIZE: number = 500;
  private targetFavorStatus: boolean | undefined;
  private favorCancelFunc: Function = (): void => {
    this.cancelFunc();
  };
  private clickedPath: Set<String> | undefined;

  constructor(menuContext: MenuContext) {
    super(menuContext);
    this.targetFavorStatus = menuContext.targetFavorStatus;
    this.operationType = 'FAVORATE_PHOTOS';
    this.traceOperationType = this.targetFavorStatus ? 'FAVORITE_PHOTOS' : 'CANCEL_FAVORITE_PHOTOS';
  }

  public doAction(): void {
    if (this.menuContext == null) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    this.count = 1;
    if (this.menuContext.mediaItem) {
      this.confirmCallback();
      return;
    }
    let selectManager: SelectManager | undefined = this.menuContext.selectManager;
    if (selectManager) {
      this.count = selectManager.getSelectedCount();
      if (this.count <= 0) {
        Log.error(TAG, 'count <= 0, return');
        return;
      }
    }
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      AlbumSetDataSourceManager.getInstance()?.getDataSource()?.pause();
    }

    this.confirmCallback();
  }

  // Asynchronous callback for getSelection
  /* instrument ignore next */
  public callback(uris: string[]): void {
    if (this.isCancelled) {
      return;
    }
    this.uris = uris;
    this.processOperation();
  }

  public selectAssetCallback(assets: PhotoAsset[]): void {
    this.selectAssets = assets;
    Log.info(TAG, `selectAssetCallback ${this.selectAssets.length}`);
    this.processOperation();
  }

  // favor a batch of data
  public async requestOneBatchOperation(): Promise<void> {
    Log.info(TAG, `favor requestOneBatchOperation ${JSON.stringify(this.isCancelled)}`);
    if (this.isCancelled) {
      return;
    }
    this.currentBatch++;
    this.setTotalForInverseSelection();
    let startIndex: number = (this.totalBatches - this.currentBatch) * this.BATCH_SIZE;
    let endIndex = startIndex + this.BATCH_SIZE;
    let batchAssets: PhotoAsset[] = [];
    Log.info(TAG, `inversion ` + this.menuContext.selectManager?.inverseSelection);
    if (this.menuContext.selectManager?.inverseSelection) {
      this.menuContext.selectManager.batchGetSelectAsset((items: MediaItem[]) => {
        let assets: PhotoAsset[] = [];
        for (let item of items) {
          if (item?.data) {
            assets.push(item.data);
          }
        }
        batchAssets.push(...assets);
        this.doBatchOperation(batchAssets);
      }, startIndex, this.BATCH_SIZE);
    } else {
      batchAssets = (this.selectAssets as PhotoAsset[])
        .slice(startIndex, Math.min(endIndex, this.selectAssets.length));
      this.doBatchOperation(batchAssets);
    }
    Log.info(TAG, `batchAssets ` + batchAssets.length.toString());
  }

  async doBatchOperation(batchAssets: PhotoAsset[]) {
    let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
    if (this.targetFavorStatus !== undefined) {
      await operationImpl.setFavorite(batchAssets, this.targetFavorStatus);
      batchAssets.splice(0, batchAssets.length);
    }
    this.onCompleted();
  }

  clickedPathCallback(clickedPath: Set<String>): void {
    this.clickedPath = clickedPath;
    Log.i(TAG, `inverseSelection clickedPath length  ${this.clickedPath?.size}`);
    this.processOperation();
  }

  public confirmCallback(): void {
    let mediaItem = this.menuContext.mediaItem;
    // 1. Variable initialization
    this.onOperationEnd = () => {
      this.menuContext.onOperationEnd();
      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        let timerId: number = setTimeout((): void => {
          AlbumSetDataSourceManager.getInstance()?.getDataSource()?.resume()
          clearTimeout(timerId)
        }, 300);
      }
    };
    if (mediaItem) {
      this.selectAssets = mediaItem.data ? [mediaItem.data] : [];
      if (this.menuContext.isBurstPhotos && this.menuContext.burstPhotos) {
        this.selectAssets = [...this.menuContext.burstPhotos.map(item => item.data)] as PhotoAsset[];
      }
      this.processOperation();
      Log.info(TAG, 'Single favor confirmed');
      return;
    }

    // 2. selectManager gets the assets of the data and starts processing favor in the callback
    const selectManager = this.menuContext.selectManager;
    if (selectManager?.inverseSelection) {
      selectManager?.getClickedPath((clickedPath: Set<String>) => this.clickedPathCallback(clickedPath));
    } else {
      selectManager?.getSelectAsset((assets: PhotoAsset[]) => this.selectAssetCallback(assets), true);
    }

    // 3. onFavorStart exit selection mode
    let onOperationStart: Function = this.menuContext.onOperationStart;
    onOperationStart?.();

    if (this.menuContext.targetFavorStatus) {
      this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
        [$r('app.string.action_favor_process'), this.favorCancelFunc]);
    } else {
      this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
        [$r('app.string.action_unfavor_process'), this.favorCancelFunc]);
    }
    this.menuContext.broadCast?.on(BroadCastConstants.CANCEL_PROGRESS_DIALOG, (): void => this.cancelProgress());
  }

  public cancelCallback(): void {
    Log.info(TAG, 'Batch favor cancel');
    if (!this.menuContext.fromSelectMode) {
      this.menuContext.selectManager?.deSelectAll();
    }
  }

  public cancelFunc(): void {
    Log.info(TAG, 'progress cancel');
    this.onOperatePause();
    let cancelMessage: Resource;
    if (this.menuContext.targetFavorStatus) {
      cancelMessage = $r('app.string.favor_cancel_message', `${this.getExpectProgress().toString()}%`);
    } else {
      cancelMessage = $r('app.string.unfavor_cancel_message', `${this.getExpectProgress().toString()}%`);
    }

    this.menuContext.broadCast?.emit(BroadCastConstants.CANCEL_OPERATE,
      [cancelMessage, (): void => {
        this.onOperateContinue();
      }, (): void => {
        this.onOperateCancelled();
      }]);
  }
}