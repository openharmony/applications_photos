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

import type { AlbumSimpleInfo } from '@ohos/common';
import {
  AlbumInfo,
  BroadCastConstants,
  BrowserDataFactory,
  DateUtil,
  Log,
  MenuContext,
  ProcessMenuOperation,
  SelectManager,
  UserFileManagerAccess
} from '@ohos/common';

const TAG: string = 'browser_AlbumSetDeleteMenuOperation';

export class AlbumSetDeleteMenuOperation extends ProcessMenuOperation {
  videoCount: number;
  photoCount: number;
  dialogTitle: Resource;
  clickSetCount: number;

  constructor(menuContext: MenuContext) {
    super(menuContext);
  }

  doAction(): void {
    if (DateUtil.isEmpty(this.menuContext) || DateUtil.isEmpty(this.menuContext.fromSelectMode)) {
      Log.error(TAG, 'menuContext or fromSelectMode is empty, return');
      return;
    }
    if (this.menuContext.fromSelectMode) {
      let selectManager: SelectManager = this.menuContext.selectManager;
      if (DateUtil.isEmpty(selectManager)) {
        Log.error(TAG, 'selectManager is null, return');
        return;
      }
      this.clickSetCount = selectManager.clickedSet.size;
      if (this.clickSetCount <= 0) {
        Log.error(TAG, 'clickSetCount <= 0, return');
        return;
      }
      this.uris = Array.from(selectManager.clickedSet);
    } else {
      let albumInfo: AlbumInfo = this.menuContext.albumInfo;
      if (!DateUtil) {
        Log.error(TAG, 'albumInfo is null, return');
        return;
      }
      this.uris = [albumInfo.uri];
    }
    this.confirmCallback = this.confirmCallback.bind(this);
    this.cancelCallback = this.cancelCallback.bind(this);
    this.dataCallback = this.dataCallback.bind(this);

    // api9：获取相册内图片，把相册内图片删完，相册也就删除了
    // api10：直接删除相册
    let albumDataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_ALBUM);
    let callback = {
      callback: (info: AlbumSimpleInfo): void => {
        this.dataCallback(info);
      }
    };
    albumDataImpl.getData(callback, { uris: this.uris });
  }

  // Asynchronous callback for getSelection
  callback(): void {
    if (this.isCancelled) {
      return;
    }
    if (this.uris == null) {
      Log.error(TAG, 'Invalid callback data, uris is null!');
      return;
    }

    this.processOperation();
  }

  // Delete a batch of data
  requestOneBatchOperation(): void {
    if (this.isCancelled) {
      return;
    }
    this.currentBatch++;
    let startIndex = (this.currentBatch - 1) * this.BATCH_SIZE;
    let endIndex = this.currentBatch * this.BATCH_SIZE;
    let batchUris: string[] = this.uris.slice(startIndex, Math.min(endIndex, this.uris.length));
    UserFileManagerAccess.getInstance().deleteAlbumByUri(batchUris[0]).then(() => {
      this.onCompleted()
    }).catch((error) => {
      Log.error(TAG, `delete error: ${error}`);
      this.onError();
    });
  }

  // 统计所有选中相册的uris，查询所有待删除的图片和视频个数并显示在dialog
  private dataCallback(object: AlbumSimpleInfo): void {
    Log.debug(TAG, `album delete callback coming`);
    this.videoCount = object.videoCount;
    this.photoCount = object.count - object.videoCount;
    this.count = object.uris.length

    Log.debug(TAG, `album delete uris: ${JSON.stringify(this.uris)} count:${this.count}`);

    if (this.clickSetCount == 1) {
      if (this.videoCount > 0 && this.photoCount > 0) {
        this.dialogTitle = $r('app.string.recycle_single_album_tips', this.photoCount, this.videoCount);
      } else if (this.videoCount > 0 && this.photoCount <= 0) {
        this.dialogTitle = $r('app.string.recycle_single_album_with_videos_tips', this.videoCount);
      } else if (this.videoCount <= 0 && this.photoCount > 0) {
        this.dialogTitle = $r('app.string.recycle_single_album_with_photos_tips', this.photoCount);
      } else if (this.videoCount <= 0 && this.photoCount <= 0) {
        this.dialogTitle = $r('app.string.recycle_single_empty_album_tips');
      }
    } else {
      if (this.videoCount > 0 && this.photoCount > 0) {
        this.dialogTitle = $r('app.string.recycle_albums_tips', this.clickSetCount, this.photoCount, this.videoCount);
      } else if (this.videoCount > 0 && this.photoCount <= 0) {
        this.dialogTitle = $r('app.string.recycle_albums_with_videos_tips', this.clickSetCount, this.videoCount);
      } else if (this.videoCount <= 0 && this.photoCount > 0) {
        this.dialogTitle = $r('app.string.recycle_albums_with_photos_tips', this.clickSetCount, this.photoCount);
      } else if (this.videoCount <= 0 && this.photoCount <= 0) {
        this.dialogTitle = $r('app.string.recycle_empty_albums_tips', this.clickSetCount);
      }
    }

    this.menuContext.broadCast.emit(BroadCastConstants.SHOW_DELETE_DIALOG,
      [this.dialogTitle, this.confirmCallback, this.cancelCallback]);
  }

  private confirmCallback(): void {
    Log.info(TAG, 'AlbumSet delete confirm')
    // 1. Variable initialization
    this.onOperationEnd = this.menuContext.onOperationEnd;
    // 2. selectManager gets the URI of the data and starts processing deletion in the callback
    if (this.menuContext.fromSelectMode) {
      this.menuContext.selectManager.getSelection(this);
    } else {
      this.callback();
    }
    // 3. onDeleteStart exit selection mode
    let onOperationStart: Function = this.menuContext.onOperationStart;
    onOperationStart && onOperationStart();

    this.menuContext.broadCast.emit(BroadCastConstants.DELETE_PROGRESS_DIALOG,
      [$r('app.string.action_delete'), this.count]);
  }

  private cancelCallback(): void {
    Log.info(TAG, 'AlbumSet delete cancel');
  }
}