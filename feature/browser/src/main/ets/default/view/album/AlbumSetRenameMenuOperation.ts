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

import type { AsyncCallback, MenuOperation, MenuOperationCallback } from '@ohos/common';
import {
  AlbumDefine,
  AlbumInfo,
  BigDataConstants,
  BroadCastConstants,
  BrowserDataFactory,
  BrowserOperationFactory,
  DateUtil,
  Log,
  MenuContext,
  ReportToBigDataUtil,
  SelectManager,
  UiUtil,
  UserFileManagerAccess
} from '@ohos/common';
import userFileManager from '@ohos.filemanagement.userFileManager';

const TAG: string = 'browser_AlbumSetRenameMenuOperation';

export class AlbumSetRenameMenuOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;
  private sourceAlbum;
  private onOperationEnd: Function;
  private dataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_ALBUM);

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  doAction(): void {
    if (DateUtil.isEmpty(this.menuContext) || DateUtil.isEmpty(this.menuContext.fromSelectMode)) {
      Log.error(TAG, 'menuContext or fromSelectMode is empty, return');
      return;
    }
    let msg = {
      'Type': BigDataConstants.ALBUM_RENAME
    };
    ReportToBigDataUtil.report(BigDataConstants.ALBUM_OPERATION_ID, msg);
    let uri;
    if (this.menuContext.fromSelectMode) {
      let selectManager: SelectManager = this.menuContext.selectManager;
      if (DateUtil.isEmpty(selectManager)) {
        Log.error(TAG, 'selectManager is null, return');
        return;
      }
      let count = this.menuContext.selectManager.clickedSet.size;
      if (count != 1) {
        Log.error(TAG, 'count != 1, return');
        return;
      }
      uri = Array.from(this.menuContext.selectManager.clickedSet)[0];
    } else {
      let albumInfo: AlbumInfo = this.menuContext.albumInfo;
      if (DateUtil.isEmpty(albumInfo)) {
        Log.error(TAG, 'albumInfo is null, return');
        return;
      }
      uri = albumInfo.uri;
    }
    this.confirmCallback = this.confirmCallback.bind(this);
    this.cancelCallback = this.cancelCallback.bind(this);

    UserFileManagerAccess.getInstance().getAlbumByUri(uri).then(async (album: userFileManager.Album) => {
      this.sourceAlbum = album;
      Log.info(TAG, `The name of clicked album is ${this.sourceAlbum.albumName}`);

      this.menuContext.broadCast.emit(BroadCastConstants.SHOW_RENAME_PHOTO_DIALOG,
        [this.sourceAlbum.albumName, this.confirmCallback, this.cancelCallback]);
    });
  }

  onCompleted(): void {
    Log.info(TAG, 'Rename data succeed!');
    this.onOperationEnd && this.onOperationEnd();
  }

  onError(): void {
    Log.error(TAG, 'Rename data failed!');
    this.onOperationEnd && this.onOperationEnd();
  }

  private async confirmCallback(newName: string) {
    Log.info(TAG, `AlbumSet rename confirm and the new name is: ${newName}`);

    this.onOperationEnd = this.menuContext.onOperationEnd;
    let onOperationStart: Function = this.menuContext.onOperationStart;
    onOperationStart && onOperationStart();

    this.rename(newName);
  }

  private async rename(name) {
    try {
      let targetAlbum = await UserFileManagerAccess.getInstance().getAlbumByName(name);
      if (targetAlbum) {
        UiUtil.showToast($r('app.string.name_already_use'));
        this.onError();
        return;
      }
      await UserFileManagerAccess.getInstance().renameAlbum(this.sourceAlbum, name);
      this.onCompleted();
    } catch (error) {
      let msg = {
        'Type': BigDataConstants.ALBUM_RENAME_ERROR,
        'errMsg': JSON.stringify(error)
      };
      ReportToBigDataUtil.errEventReport(BigDataConstants.ALBUM_OPERATION_ERROR_ID, msg);
      Log.error(TAG, `AlbumSet rename failed: ${error}`);
      this.onError();
    }
  }

  private cancelCallback(): void {
    Log.info(TAG, 'AlbumSet rename cancel');
  }
}