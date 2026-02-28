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

/* instrument ignore file */

import lazy { Log } from '../../utils/Log';
import type { MenuContext } from './MenuContext';
import lazy { ProcessMenuOperation } from './ProcessMenuOperation';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import type { SelectManager } from '../../model/browser/SelectManager';
import lazy { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import type { PhotoAsset } from '../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import lazy { BigDataConstants, BigDataMsg, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';
import type { AlbumInfo } from '../../../default/model/browser/album/AlbumInfo';

const TAG: string = 'common_AddMenuOperation';

export class AddMenuOperation extends ProcessMenuOperation {
  public albumUri: string;
  public albumName: string;
  readonly BATCH_SIZE: number = 1000;
  public useUrlFlag: boolean = false;

  constructor(menuContext: MenuContext) {
    super(menuContext);
    this.albumUri = menuContext.albumUri ?? '';
    this.albumName = menuContext.targetAlbumName ?? '';
  }

  public doAction(): void {
    Log.info(TAG, 'doAction');
    if (this.menuContext == null) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    if (this.menuContext.selectManager) {
      let selectManager: SelectManager = this.menuContext.selectManager;
      if (selectManager === null || selectManager === undefined) {
        Log.error(TAG, 'selectManager is null, return');
        return;
      }

      this.count = selectManager.getSelectedCount();
      if (this.count <= 0) {
        Log.error(TAG, 'count <= 0, return');
        return;
      }

      this.onOperationEnd = this.menuContext.onOperationEnd;
      selectManager.getSelectAssetsWidthBurstPhotos((assets: PhotoAsset[]) => this.selectAssetCallback(assets));
      let onOperationStart: Function = this.menuContext.onOperationStart;
      onOperationStart?.();
    } else {
      this.count = 1;
      let mediaItem = this.menuContext.mediaItem;
      this.onOperationEnd = this.menuContext.onOperationEnd;
      if (mediaItem == null) {
        Log.error(TAG, 'mediaItem is null, return');
        return;
      }
      if (this.menuContext.isBurstPhotos) {
        this.selectAssetCallback(this.menuContext.burstPhotos?.map(item => item.data) as PhotoAsset[]);
      } else {
        this.callback([mediaItem.uri]);
      }
    }
    this.doActionNext();
  }

  doActionNext(): void {
    let isTargetSystem: boolean = false;
    let systemAlbumUris: IterableIterator<string> =
      UserFileManagerAccess.getInstance().getSystemAlbumUriMap().values();
    for (let uri of systemAlbumUris) {
      if (this.albumUri === uri) {
        isTargetSystem = true;
        break;
      }
    }
    let albumInfo: AlbumInfo | undefined = this.menuContext?.albumInfo;
    let msg: Record<string, number | string | boolean | undefined> = {
      'type': BigDataConstants.MEDIA_COPY,
      'targetAlbumType': isTargetSystem,
      'count': this.count,
      'albumType': albumInfo?.subType,
    };
    ReportToBigDataUtil.report(BigDataConstants.ALBUM_OPERATION_ID, msg);

    this.menuContext.broadCast?.on(BroadCastConstants.CANCEL_PROGRESS_DIALOG, this.cancelProgress.bind(this));
    this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
      [$r('app.string.add_progress_message', this.albumName), this.cancelFunc.bind(this)]);
  }

  public callback(uris: string[]): void {
    this.uris = uris;
    this.useUrlFlag = true;
    this.processOperation();
  }

  public selectAssetCallback(assets: PhotoAsset[]): void {
    this.selectAssets = assets;
    this.useUrlFlag = false;
    Log.info(TAG, `selectAssetCallback ${this.selectAssets.length}`);
    this.processOperation();
  }

  public requestOneBatchOperation(): void {
    if (this.isCancelled) {
      return;
    }
    this.currentBatch++;
    if (this.useUrlFlag) {
      let startIndex = (this.currentBatch - 1);
      let endIndex = this.currentBatch;
      let batchUrls: string[] = this.uris.slice(startIndex, Math.min(endIndex, this.uris.length));
      Log.info(TAG, `requestOneBatchOperation ${this.albumUri}, ${batchUrls.length}`);
      TraceControllerUtils.startTraceWithTaskId('copy', this.currentBatch);
      this.getFileAddOrMoveInfo(batchUrls[0]).then((fileAsset: PhotoAsset | undefined) => {
        TraceControllerUtils.finishTraceWithTaskId('copy', this.currentBatch);
        this.copy(fileAsset ? [fileAsset] : []);
      });
      Log.info(TAG, `requestOneBatchOperation batchUrls:${JSON.stringify(batchUrls)}`);
    } else {
      let startIndex = (this.currentBatch - 1) * this.BATCH_SIZE;
      let endIndex = this.currentBatch * this.BATCH_SIZE;
      let batchAssets: PhotoAsset[] =
        this.selectAssets.slice(startIndex, Math.min(endIndex, this.selectAssets.length));
      Log.info(TAG, `requestOneBatchOperation ${this.albumUri}, ${batchAssets.length}`);
      TraceControllerUtils.startTraceWithTaskId('copy', this.currentBatch);
      this.copy(batchAssets as PhotoAsset[]);
      TraceControllerUtils.finishTraceWithTaskId('copy', this.currentBatch);
      Log.info(TAG, `requestOneBatchOperation batchAssets:${JSON.stringify(batchAssets)}`);
    }
  }

  public cancelFunc(): void {
    Log.info(TAG, 'progress cancel');
    this.onOperatePause();
    let cancelMessage = $r('app.string.copy_cancel_message', `${this.getExpectProgress().toString()}%`);

    this.menuContext.broadCast?.emit(BroadCastConstants.CANCEL_OPERATE,
      [cancelMessage, this.onOperateContinue.bind(this), this.onOperateCancelled.bind(this)]);
  }

  // Copy cancel callback
  public onOperateContinue(): void {
    Log.info(TAG, 'Operate Continue');
    this.isPause = false;
    this.cyclicOperation();
  }

  private async copy(source: PhotoAsset[]): Promise<void> {
    Log.debug(TAG, `debug-copy Parameters: source:${JSON.stringify(source)}`);
    try {
      ReportToBigDataUtil.report(BigDataConstants.COPY_FILE_OPERATION_START, undefined);
      await UserFileManagerAccess.getInstance().addFilesToAlbum(this.albumUri, source);
      ReportToBigDataUtil.report(BigDataConstants.COPY_FILE_OPERATION_FINISH, undefined);
      this.onCompleted();
    } catch (error) {
      let msg: Record<string, number | string | boolean> = {
        'type': BigDataConstants.MEDIA_COPY_ERROR,
        'count': this.count,
        'errMsg': error,
      };
      ReportToBigDataUtil.errEventReport(BigDataConstants.ALBUM_OPERATION_ERROR_ID, msg);
      Log.error(TAG, `copyFile is error ${error}, code: ${error?.code}`);
      this.onError();
    }
  }
}