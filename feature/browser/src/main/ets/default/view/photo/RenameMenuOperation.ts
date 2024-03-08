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

import type { MenuOperation, MenuOperationCallback, } from '@ohos/common';
import {
  BroadCastConstants,
  BrowserDataFactory,
  BrowserOperationFactory,
  BrowserConstants as Constants,
  Log,
  MenuContext,
  UiUtil
} from '@ohos/common';
import userFileManager from '@ohos.filemanagement.userFileManager';

const TAG: string = 'browser_RenameMenuOperation';

export class RenameMenuOperation implements MenuOperation, MenuOperationCallback {
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
    let fileName = '';
    let title: string = mediaItem.getTitle();
    if (title) {
      fileName = title;
    } else {
      let index = mediaItem.displayName.lastIndexOf('.');
      fileName = mediaItem.displayName.substr(0, index)
    }

    this.menuContext.broadCast.emit(BroadCastConstants.SHOW_RENAME_PHOTO_DIALOG,
      [fileName, this.confirmCallback, this.cancelCallback]);
  }

  onCompleted(result: {title: string, displayName: string}): void {
    Log.info(TAG, 'Rename data succeed!');
  }

  onError(): void {
    Log.error(TAG, 'Rename data failed!');
  }

  async rename(uri: string, name: string): Promise<{title: string, displayName: string}> {
    Log.info(TAG, 'renameSinglePhoto start');
    let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
    let dataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO);
    let fileAsset = await dataImpl.getDataByUri(uri);
    operationImpl.setName(fileAsset, name);
    await operationImpl.change(fileAsset);
    return { title: String(fileAsset.get(userFileManager.ImageVideoKey.TITLE.toString())),
      displayName: fileAsset.displayName };
  }

  async confirmCallback(title: string): Promise<void> {
    Log.info(TAG, `Rename confirm new name: ${title}`);
    let mediaItem = this.menuContext.mediaItem;
    if (mediaItem == null) {
      Log.error(TAG, 'mediaItem is null, return');
      return;
    }
    try {
      let result = await this.rename(mediaItem.uri, title);
      Log.info(TAG, `Rename confirm result: ${JSON.stringify(result)}`);
      this.menuContext.broadCast.emit(Constants.RENAME, [result]);
      this.onCompleted(result);
    } catch (err) {
      Log.error(TAG, `Rename error: ${err}`);
      UiUtil.showToast($r('app.string.rename_failed'));
    }
  }

  private cancelCallback(): void {
    Log.info(TAG, 'Rename cancel');
  }
}