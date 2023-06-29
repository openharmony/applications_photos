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

import {
  BroadCastConstants,
  BrowserOperationFactory,
  FileAsset,
  Log,
  MenuContext,
  ProcessMenuOperation,
  SelectManager,
  UserFileManagerAccess
} from '@ohos/common';

const TAG: string = 'browser_BatchRecoverMenuOperation';

export class BatchRecoverMenuOperation extends ProcessMenuOperation {
  constructor(menuContext: MenuContext) {
    super(menuContext);
    //初始化绑定this指向
    this.callback = this.callback.bind(this)
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

    this.onOperationEnd = this.menuContext.onOperationEnd;
    if (this.menuContext.albumUri == UserFileManagerAccess.getInstance()
      .getSystemAlbumUri(UserFileManagerAccess.TRASH_ALBUM_SUB_TYPE)) {
      this.menuContext.selectManager.getDeleteSelection(this);
    } else {
      this.menuContext.selectManager.getSelection(this);
    }
    let onOperationStart: Function = this.menuContext.onOperationStart;
    onOperationStart && onOperationStart();

    this.menuContext.broadCast.emit(BroadCastConstants.DELETE_PROGRESS_DIALOG,
      [$r('app.string.action_recover'), this.count]);
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
    if (this.isCancelled) {
      return;
    }
    this.currentBatch++;
    let startIndex = (this.currentBatch - 1) * this.BATCH_SIZE;
    let endIndex = this.currentBatch * this.BATCH_SIZE;
    let batchUris: string[] = this.uris.slice(startIndex, Math.min(endIndex, this.uris.length));
    let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
    let fileAssets = new Array<FileAsset>();
    let fileItem = await UserFileManagerAccess.getInstance().getTrashAssetByUri(batchUris[0]);
    fileAssets.push(fileItem);
    operationImpl.recoverFromTrash(fileAssets).then(() => {
      this.onCompleted()
    }).catch((error) => {
      Log.error(TAG, `recover error: ${error}`);
      this.onError();
    })
  }
}