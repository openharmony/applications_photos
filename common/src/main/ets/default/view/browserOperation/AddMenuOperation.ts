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

import { Log } from '../../utils/Log';
import { MenuContext } from './MenuContext';
import { ProcessMenuOperation } from './ProcessMenuOperation';
import { BroadCastConstants } from '../../model/common/BroadCastConstants';
import { SelectManager } from '../../model/browser/SelectManager';
import { MediaOperationType } from '../../model/common/MediaOperationType';
import { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import type { FileAsset } from '../../access/UserFileManagerAccess';
import { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import { BigDataConstants, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';

const TAG: string = 'common_AddMenuOperation';

export class AddMenuOperation extends ProcessMenuOperation {
  albumUri: string;
  albumName: string;

  constructor(menuContext: MenuContext) {
    super(menuContext);
    this.albumUri = menuContext.albumUri;
  }

  doAction(): void {
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
      let msg = {
        'Type': BigDataConstants.MEDIA_COPY,
        'Count': this.count
      };
      ReportToBigDataUtil.report(BigDataConstants.ALBUM_OPERATION_ID, msg);

      this.onOperationEnd = this.menuContext.onOperationEnd;

      selectManager.getSelection(this);

      let onOperationStart: Function = this.menuContext.onOperationStart;
      onOperationStart && onOperationStart();
    } else {
      this.count = 1;
      let mediaItem = this.menuContext.mediaItem;
      this.onOperationEnd = this.menuContext.onOperationEnd;
      if (mediaItem == null) {
        Log.error(TAG, 'mediaItem is null, return');
        return;
      }
      this.callback([mediaItem.uri]);
    }

    this.menuContext.broadCast.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
      [$r('app.string.add_progress_message', this.albumName),
      MediaOperationType.Add, this.cancelFunc.bind(this)]);
  }

  callback(uris: string[]): void {
    this.uris = uris;
    this.processOperation();
  }

  // Move a batch of data
  requestOneBatchOperation(): void {
    if (this.isCancelled) {
      return;
    }
    this.currentBatch++;
    let startIndex = (this.currentBatch - 1) * this.BATCH_SIZE;
    let endIndex = this.currentBatch * this.BATCH_SIZE;
    let batchUris: string[] = this.uris.slice(startIndex, Math.min(endIndex, this.uris.length));
    if (batchUris[0] == undefined) {
      this.onOperateContinue();
      return;
    }
    Log.info(TAG, `requestOneBatchOperation ${this.albumName}`);

    TraceControllerUtils.startTraceWithTaskId('getFileCopyOrMoveInfo', this.currentBatch);
    this.getFileAddOrMoveInfo(batchUris[0]).then((fileAsset: FileAsset) => {
      TraceControllerUtils.finishTraceWithTaskId('getFileCopyOrMoveInfo', this.currentBatch);
      this.copy(fileAsset);
    });
  }

  cancelFunc(): void {
    Log.info(TAG, `progress cancel`);
    this.onOperatePause();
    let cancelMessage = $r('app.string.copy_cancel_message', `${this.getExpectProgress().toString()}%`);

    this.menuContext.broadCast && this.menuContext.broadCast.emit(BroadCastConstants.CANCEL_OPERATE,
      [cancelMessage, this.onOperateContinue.bind(this), this.onOperateCancelled.bind(this)]);
  }

  // Copy cancel callback
  onOperateContinue(): void {
    Log.info(TAG, 'Operate Continue');
    this.isPause = false;
    this.cyclicOperation();
  }

  private async copy(source: FileAsset): Promise<void> {
    Log.debug(TAG, 'debug-copy Parameters: source:' + JSON.stringify(source));
    try {
      await UserFileManagerAccess.getInstance().addFileToAlbum(this.albumUri, source);
      this.onCompleted();
    } catch (error) {
      let msg = {
        'Type': BigDataConstants.MEDIA_COPY_ERROR,
        'errMsg': JSON.stringify(error)
      };
      ReportToBigDataUtil.errEventReport(BigDataConstants.ALBUM_OPERATION_ERROR_ID, msg);
      Log.error(TAG, `copyFile is error ${error}`);
      this.onError();
    }
  }
}