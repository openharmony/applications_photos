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
import { SelectManager } from '../../model/browser/SelectManager';
import { MenuContext } from './MenuContext';
import { BrowserOperationFactory } from '../../interface/BrowserOperationFactory';
import { BroadCastConstants } from '../../model/common/BroadCastConstants';
import { AlbumDefine } from '../../model/browser/AlbumDefine';
import { ProcessMenuOperation } from './ProcessMenuOperation';
import { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import { BigDataConstants, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';
import { Constants } from '../../model/common/Constants';

const TAG: string = 'common_BatchRemoveMenuOperation';

export class BatchRemoveMenuOperation extends ProcessMenuOperation {
  constructor(menuContext: MenuContext) {
    super(menuContext);
    //初始化绑定this指向
    this.callback = this.callback.bind(this)
  }

  setConfirmText(): void {
    AppStorage.setOrCreate<Resource>(Constants.CONFIRM_TEXT_KEY, $r('app.string.dialog_remove'));
  }

  doAction(): void {
    if (this.menuContext == null) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    let selectManager: SelectManager = this.menuContext.selectManager;
    if (selectManager == null) {
      Log.error(TAG, 'selectManager is null, return');
      return;
    }
    this.count = selectManager.getSelectedCount();
    if (this.count <= 0) {
      Log.error(TAG, 'count <= 0, return');
      return;
    }

    this.confirmCallback = this.confirmCallback.bind(this);
    this.cancelCallback = this.cancelCallback.bind(this);
    this.setConfirmText();
    this.menuContext.broadCast.emit(BroadCastConstants.SHOW_REMOVE_DIALOG,
      [selectManager.isAllSelected ? $r('app.string.remove_all_files_tips') :
        (this.count == 1 ? $r('app.string.remove_single_file_tips') :
        $r('app.string.remove_files_tips', this.count)), this.confirmCallback, this.cancelCallback]);
  }

  // Asynchronous callback for getSelection
  callback(uris: string[]): void {
    if (this.isCancelled) {
      return;
    }
    this.uris = uris;
    this.processOperation();
  }

  // Remove a batch of data
  requestOneBatchOperation(): void {
    Log.info(TAG, `requestOneBatchOperation`);
    if (this.isCancelled) {
      return;
    }
    this.currentBatch++;
    let startIndex: number = (this.currentBatch - 1) * this.BATCH_SIZE;
    let endIndex: number = this.currentBatch * this.BATCH_SIZE;
    let batchUris: string[] = this.uris.slice(startIndex, Math.min(endIndex, this.uris.length));

    let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
    TraceControllerUtils.startTraceWithTaskId('remove', this.currentBatch)
    operationImpl.remove(batchUris, this.menuContext.albumUri).then(() => {
      TraceControllerUtils.finishTraceWithTaskId('remove', this.currentBatch)
      this.onCompleted()
    }).catch((error) => {
      Log.error(TAG, `remove error: ${error}`);
      this.onError();
    })
  }

  confirmCallback(): void {
    Log.info(TAG, 'Batch remove confirm');

    // 1. Variable initialization
    this.onOperationEnd = this.menuContext.onOperationEnd;

    // 2. selectManager gets the URI of the data and starts processing deletion in the callback
    this.menuContext.selectManager.getSelection(this);

    // 3. onDeleteStart exit selection mode
    let onOperationStart: Function = this.menuContext.onOperationStart;
    onOperationStart && onOperationStart();
    let msg = {
      'type': BigDataConstants.REMOVE,
      'FovMode': 0
    }
    ReportToBigDataUtil.report(BigDataConstants.REMOVE_TYPE_ID, msg);

    this.menuContext.broadCast.emit(BroadCastConstants.REMOVE_PROGRESS_DIALOG,
      [$r('app.string.action_remove'), this.count]);
  }

  cancelCallback(): void {
    Log.info(TAG, 'Batch delete cancel');
    this.setConfirmText();
    if (!this.menuContext.fromSelectMode) {
      this.menuContext.selectManager.deSelectAll();
    }
  }
}