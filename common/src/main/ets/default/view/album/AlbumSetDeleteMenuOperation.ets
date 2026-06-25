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

import type { AlbumInfo } from '../../../default/model/browser/album/AlbumInfo';
import type { AlbumSimpleInfo } from '../../../default/model/browser/album/AlbumDataImpl';
import type { MenuContext } from '../../../default/view/browserOperation/MenuContext';
import type { SelectManager } from '../../../default/model/browser/SelectManager';
import lazy { BigDataConstants, BigDataMsg, ReportToBigDataUtil } from '../../../default/utils/ReportToBigDataUtil';
import lazy { BroadCastConstants } from '../../../default/model/common/BroadCastConstants';
import lazy { BrowserDataFactory } from '../../../default/interface/BrowserDataFactory';
import lazy { Constants } from '../../../default/model/common/Constants';
import lazy { Log } from '../../../default/utils/Log';
import lazy { ProcessMenuOperation } from '../../../default/view/browserOperation/ProcessMenuOperation';
import lazy { UserFileManagerAccess } from '../../../default/access/UserFileManagerAccess';
import type { PositionParams } from '../../../default/view/browserOperation/DeleteMenuOperation';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { AsyncCallback } from '../../../default/model/common/AsyncCallback';

/* instrument ignore file */

const TAG: string = 'browser_AlbumSetDeleteMenuOperation';

export class AlbumSetDeleteMenuOperation extends ProcessMenuOperation {
  // 视频数量
  public videoCount: number = Number.NaN;
  public photoCount: number = Number.NaN;
  public dialogTitle: Resource | undefined = undefined;
  private primaryTitle: Resource | undefined;
  public clickSetCount: number = Number.NaN;
  private retentionDays: number = 30;

  constructor(menuContext: MenuContext) {
    super(menuContext);
    this.operationType = 'ALBUM_DELETE';
    this.traceOperationType = 'ALBUM_DELETE';
  }

  public doAction(): void {
    if (!this.isPrepareUrisSuccess()) {
      return;
    }
    // api9：获取相册内图片，把相册内图片删完，相册也就删除了
    // api10：直接删除相册
    let albumDataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_ALBUM);
    let callback: AsyncCallback<AlbumSimpleInfo> = {
      callback: (info: AlbumSimpleInfo): void => {
        this.dataCallback(info);
      }
    };
    albumDataImpl.getData(callback, { uris: this.uris });
  }

  public isPrepareUrisSuccess(): boolean {
    if (this.menuContext.fromSelectMode === undefined) {
      Log.error(TAG, 'menuContext or fromSelectMode is empty, return');
      return false;
    }
    if (this.menuContext.fromSelectMode) {
      let selectManager: SelectManager | undefined = this.menuContext.selectManager;
      if (!selectManager) {
        Log.error(TAG, 'selectManager is null, return');
        return false;
      }
      if (selectManager.albumUri) {
        selectManager.clickedSet.clear();
        selectManager.clickedSet.add(selectManager.albumUri);
      } else {
        this.clickSetCount = selectManager.clickedSet.size;
      }
      if (this.clickSetCount <= 0 && !selectManager.albumUri) {
        Log.error(TAG, 'clickSetCount <= 0, return');
        return false;
      }
      this.uris = Array.from(selectManager.clickedSet);
    } else {
      let albumInfo: AlbumInfo | undefined = this.menuContext.albumInfo;
      this.clickSetCount = 1;
      if (!albumInfo) {
        Log.error(TAG, 'albumInfo is null, return');
        return false;
      }
      this.uris = [albumInfo.uri];
    }
    return true;
  }

  // Asynchronous callback for getSelection
  public callback(): void {
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
  public requestOneBatchOperation(): void {
    if (this.isCancelled) {
      return;
    }
    let batchUris: string[] = this.getBatchUris();
    UserFileManagerAccess.getInstance().deleteAlbumByUri(batchUris[0]).then((): void => {
      this.onCompleted();
    }).catch((error: BusinessError): void => {
      this.onError(error);
    });
  }

  public getBatchUris(): string[] {
    this.currentBatch++;
    let startIndex = (this.currentBatch - 1) * this.BATCH_SIZE;
    let endIndex = this.currentBatch * this.BATCH_SIZE;
    Log.info(TAG, 'album delete getBatchUris ' + startIndex + ` endIndex ${endIndex}` + '  size ' +
    JSON.stringify(this.uris));
    return this.uris.slice(startIndex, Math.min(endIndex, this.uris.length)) as string[];
  }

  // 统计所有选中相册的uris，查询所有待删除的图片和视频个数并显示在dialog
  dataCallback = (object: AlbumSimpleInfo, isWithDialog = true): void => {
    Log.debug(TAG, 'album delete callback coming');
    this.videoCount = object.videoCount;
    this.photoCount = object.count - object.videoCount;
    this.count = object.uris.length;
    let cloudDriveStatus: boolean | undefined = AppStorage.get<boolean>('cloudDriveStatus');
    Log.debug(TAG, `album delete uris: ${JSON.stringify(this.uris)} count:${this.count}` +
                      `cloudDriveStatus = ${cloudDriveStatus}`);

    if (this.clickSetCount === 1 || !this.clickSetCount) {
      if (this.videoCount <= 0 && this.photoCount <= 0) {
        this.primaryTitle = undefined;
        this.dialogTitle = $r('app.string.recycle_single_empty_album_tips');
      } else {
        this.primaryTitle = $r('app.string.recycle_single_empty_album_tips');
        this.dialogTitle = cloudDriveStatus ? $r('app.plural.items_in_single_album_will_be_recycled',
          this.count, this.count, this.retentionDays) : $r('app.plural.single_photo_album_will_be_recycled',
          this.count, this.count, this.retentionDays);
      }
    } else {
      if (this.videoCount <= 0 && this.photoCount <= 0) {
        this.primaryTitle = undefined;
        this.dialogTitle = $r('app.string.recycle_selected_albums');
      } else {
        this.primaryTitle = $r('app.string.recycle_selected_albums');
        this.dialogTitle = cloudDriveStatus ? $r('app.plural.items_in_albums_will_be_recycled',
          this.count, this.count, this.retentionDays) : $r('app.plural.photo_albums_will_be_recycled',
          this.count, this.count, this.retentionDays);
      }
    }
    AppStorage.setOrCreate<Resource>(Constants.CONFIRM_TEXT_KEY, $r('app.string.dialog_delete'));
    let locationParams: PositionParams = {
      isClearRecycle: false,
      isHoldPosition: false,
    };
    if (isWithDialog) {
      this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_DELETE_DIALOG,
        [[this.primaryTitle, this.dialogTitle], this.confirmCallback, this.cancelCallback, true, locationParams]);
    } else {
      this.confirmCallback();
    }
  };
  confirmCallback = (): void => {
    this.doConfirm();
    let msg: Record<string, number | string | boolean> = {
      'count': this.clickSetCount,
      'from': BigDataConstants.ALBUM_DELETE,
    };
    ReportToBigDataUtil.report(BigDataConstants.DELETE_MENU_RESPONSE, msg);

    this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
      [$r('app.string.action_delete_process')]);
  };

  public doConfirm(): void {
    Log.info(TAG, 'AlbumSet delete confirm');
    this.menuContext.broadCast?.emit(BroadCastConstants.UPDATE_BACK, [true]);
    // 1. Variable initialization
    this.onOperationEnd = this.menuContext.onOperationEnd;
    // 2. selectManager gets the URI of the data and starts processing deletion in the callback
    if (this.menuContext.fromSelectMode) {
      this.menuContext.selectManager?.selectedCallback(this);
    } else {
      this.callback();
    }
    // 3. onDeleteStart exit selection mode
    let onOperationStart: Function = this.menuContext.onOperationStart;
    onOperationStart?.();
  }

  protected cancelCallback = (): void => {
    Log.info(TAG, 'AlbumSet delete cancel');
    this.menuContext.broadCast?.emit(BroadCastConstants.SETTING_MULTIPLE_CLICKS, []);
  };
}