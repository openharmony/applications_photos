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

import { FileAsset, UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import { Log } from '../../utils/Log';
import type { MenuOperationCallback } from './MenuOperationCallback';
import type { MenuOperation } from './MenuOperation';
import { MenuContext } from './MenuContext';
import { BrowserOperationFactory } from '../../interface/BrowserOperationFactory';
import { BroadCastConstants } from '../../model/common/BroadCastConstants';
import { AlbumDefine } from '../../model/browser/AlbumDefine';
import { Constants as BrowserConstants } from '../../model/browser/photo/Constants';
import { BigDataConstants, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';
import { Constants } from '../../model/common/Constants';

const TAG: string = 'common_DeleteMenuOperation';

export class DeleteMenuOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;
  private isTrash = true;

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  doAction(): void {
    if (this.menuContext == null) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    let mediaItem = this.menuContext.mediaItem;
    if (mediaItem == null) {
      Log.error(TAG, 'mediaItem is null, return');
      return;
    }
    if (this.menuContext.albumInfo && this.menuContext.albumInfo.isTrashAlbum) {
      this.isTrash = false;
    }
    this.confirmCallback = this.confirmCallback.bind(this);
    this.cancelCallback = this.cancelCallback.bind(this);
    let message = mediaItem.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO
      ? $r('app.string.recycle_video_tips') : $r('app.string.recycle_picture_tips');
    this.setConfirmText();
    if (!this.isTrash) {
      message = $r('app.plural.recycleAlbum_delete_message', 1);
    }
    this.menuContext.broadCast.emit(BroadCastConstants.SHOW_DELETE_DIALOG,
      [message, this.confirmCallback, this.cancelCallback]);
  }

  setConfirmText(): void {
    if (!this.isTrash) {
      AppStorage.setOrCreate<Resource>(Constants.CONFIRM_TEXT_KEY, $r('app.string.dialog_delete_permanently'));
    } else {
      AppStorage.setOrCreate<Resource>(Constants.CONFIRM_TEXT_KEY, $r('app.string.dialog_delete'));
    }
  }

  onCompleted(): void {
    Log.info(TAG, 'Delete data succeed!');
    this.menuContext.broadCast.emit(BrowserConstants.DELETE, []);
  }

  onError(): void {
    Log.error(TAG, 'Delete data failed!');
  }

  private async confirmCallback() {
    this.menuContext.broadCast.emit(BrowserConstants.PHOTO_BROWSER_DELETE_CONFIRM, []);

    Log.info(TAG, 'Delete confirm');
    let mediaItem = this.menuContext.mediaItem;
    if (mediaItem == null) {
      Log.error(TAG, 'mediaItem is null, return');
      return;
    }
    let batchUris: Array<string> = new Array();
    batchUris.push(mediaItem.uri);
    let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
    try {
      if (this.isTrash) {
        await operationImpl.trash(batchUris);
      } else {
        let fileAssets = new Array<FileAsset>();
        fileAssets.push(await UserFileManagerAccess.getInstance().getTrashAssetByUri(mediaItem.uri));
        await operationImpl.deleteTrash(fileAssets);
      }
      this.onCompleted()
    } catch (error) {
      Log.error(TAG, `delete error: ${error}`);
      this.onError();
    }
    let msg = {
      'type': BigDataConstants.DELETE_LOCAL_ONLY,
      'FovMode': 0,
      'mode': this.isTrash ? 'trash' : 'delete'
    }
    ReportToBigDataUtil.report(BigDataConstants.DELETE_TYPE_ID, msg);
    Log.info(TAG, 'Single delete confirm');
  }

  private cancelCallback(): void {
    this.setConfirmText();
    Log.info(TAG, 'Delete cancel');

  }
}