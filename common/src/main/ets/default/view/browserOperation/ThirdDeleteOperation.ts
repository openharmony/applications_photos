/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import { SelectManager } from '../../model/browser/SelectManager';
import { MenuContext } from './MenuContext';
import { BrowserOperationFactory } from '../../interface/BrowserOperationFactory';
import { BroadCastConstants } from '../../model/common/BroadCastConstants';
import { ProcessMenuOperation } from './ProcessMenuOperation';
import { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import { BigDataConstants, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';
import { Constants } from '../../model/common/Constants';

const TAG = "ThirdDeleteMenuOperation"

export class ThirdDeleteOperation extends ProcessMenuOperation {
  private isTrash = true;

  constructor(menuContext: MenuContext) {
    super(menuContext);
    this.callback = this.callback.bind(this);
  }

  setConfirmText(): void {
    if (!this.isTrash) {
      AppStorage.setOrCreate<Resource>(Constants.CONFIRM_TEXT_KEY, $r('app.string.dialog_delete_permanently'));
    } else {
      AppStorage.setOrCreate<Resource>(Constants.CONFIRM_TEXT_KEY, $r('app.string.dialog_delete'));
    }
  }

  doAction(): void {
    if (this.menuContext == null) {
      Log.warn(TAG, 'menuContext is null, return');
      return;
    }

    let selectManager: SelectManager = this.menuContext.selectManager;
    if (selectManager == null) {
      Log.warn(TAG, 'selectManager is null, return');
      return;
    }
    this.count = selectManager.getSelectedCount();
    if (this.count <= 0) {
      Log.warn(TAG, 'count <= 0, return');
      return;
    }

    this.confirmCallback = this.confirmCallback.bind(this);
    this.cancelCallback = this.cancelCallback.bind(this);
    this.setConfirmText();

    this.menuContext.broadCast.emit(BroadCastConstants.SHOW_THIRD_DELETE_DIALOG,
      [(this.count == 1 ? $r('app.string.recycle_single_file_tips') :
      $r('app.string.recycle_files_tips', this.count)), this.confirmCallback, this.cancelCallback]);
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
  async requestOneBatchOperation(): Promise<void> {
    Log.info(TAG, `requestOneBatchOperation`);
    if (this.isCancelled) {
      return;
    }
    this.currentBatch++;
    let startIndex: number = (this.currentBatch - 1) * this.BATCH_SIZE;
    const endIndex: number = Math.min(this.currentBatch * this.BATCH_SIZE, this.uris.length);
    let batchUris: Array<string> = new Array();
    for (let index = startIndex; index < endIndex; index++) {
      batchUris.push(this.uris[index]);
    }

    let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);

    TraceControllerUtils.startTraceWithTaskId('trash', this.currentBatch)
    operationImpl.trash(batchUris).then(() => {
      TraceControllerUtils.finishTraceWithTaskId('trash', this.currentBatch)
      this.onCompleted()
    }).catch((error) => {
      Log.error(TAG, `delete error: ${error}`);
      this.onError();
    })
  }

  confirmCallback(): void {
    Log.info(TAG, 'Batch delete confirm');
    // 1. Variable initialization
    this.onOperationEnd = this.menuContext.onOperationEnd;
    // 2. selectManager gets the URI of the data and starts processing deletion in the callback
    if (this.menuContext.albumInfo && this.menuContext.albumInfo.isTrashAlbum) {
      this.menuContext.selectManager.getDeleteSelection(this);
    } else {
      this.menuContext.selectManager.getSelection(this);
    }

    // 3. onDeleteStart exit selection mode
    let onOperationStart: Function = this.menuContext.onOperationStart;
    onOperationStart && onOperationStart();
    let msg = {
      'type': BigDataConstants.DELETE_LOCAL_ONLY,
      'FovMode': 0
    }
    ReportToBigDataUtil.report(BigDataConstants.DELETE_TYPE_ID, msg);

    this.menuContext.broadCast.emit(BroadCastConstants.DELETE_PROGRESS_DIALOG,
      [$r('app.string.action_delete'), this.count]);
  }

  cancelCallback(): void {
    Log.info(TAG, 'Batch delete cancel');
    let onOperationCancel: Function = this.menuContext.onOperationCancel;
    onOperationCancel && onOperationCancel();
  }
}