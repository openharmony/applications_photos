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

import { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
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

const TAG: string = 'common_RemoveMenuOperation';

export class RemoveMenuOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;

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
    this.confirmCallback = this.confirmCallback.bind(this);
    this.cancelCallback = this.cancelCallback.bind(this);
    let message = mediaItem.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO
      ? $r('app.string.remove_video_tips') : $r('app.string.remove_picture_tips');
    this.setConfirmText();
    this.menuContext.broadCast.emit(BroadCastConstants.SHOW_REMOVE_DIALOG,
      [message, this.confirmCallback, this.cancelCallback]);
  }

  setConfirmText(): void {
    AppStorage.setOrCreate<Resource>(Constants.CONFIRM_TEXT_KEY, $r('app.string.dialog_remove'));
  }

  onCompleted(): void {
    Log.info(TAG, 'Remove data succeed!');
    this.menuContext.broadCast.emit(BrowserConstants.Remove, []);
  }

  onError(): void {
    Log.error(TAG, 'Remove data failed!');
  }

  private async confirmCallback() {
    this.menuContext.broadCast.emit(BrowserConstants.PHOTO_BROWSER_REMOVE_CONFIRM, []);

    Log.info(TAG, 'Remove confirm');
    let mediaItem = this.menuContext.mediaItem;
    if (mediaItem == null) {
      Log.error(TAG, 'mediaItem is null, return');
      return;
    }
    let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
    try {
      await operationImpl.remove([mediaItem.uri], this.menuContext.albumUri);
      this.onCompleted()
    } catch (error) {
      Log.error(TAG, `remove error: ${error}`);
      this.onError();
    }
    let msg = {
      'type': BigDataConstants.REMOVE,
      'FovMode': 0,
      'mode': 'remove'
    }
    ReportToBigDataUtil.report(BigDataConstants.REMOVE_TYPE_ID, msg);
    Log.info(TAG, 'Single remove confirm');
  }

  private cancelCallback(): void {
    this.setConfirmText();
    Log.info(TAG, 'remove cancel');

  }
}