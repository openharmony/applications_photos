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

import type { MenuOperation, MenuOperationCallback, } from '@ohos/common';
import {
  BrowserOperationFactory,
  BrowserConstants as Constants,
  FileAsset,
  Log,
  MenuContext,
  UserFileManagerAccess
} from '@ohos/common';

const TAG: string = 'browser_RecoverMenuOperation';

export class RecoverMenuOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  doAction(): void {
    if (this.menuContext == null) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    this.doRecover();
  }

  onCompleted(): void {
    Log.info(TAG, 'Recover data succeed!');
  }

  onError(): void {
    Log.error(TAG, 'Recover data failed!');
  }

  private async doRecover() {
    let mediaItem = this.menuContext.mediaItem;
    if (mediaItem == null) {
      Log.error(TAG, 'mediaItem is null, return');
      return;
    }
    let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
    try {
      let fileAssets = new Array<FileAsset>();
      fileAssets.push(await UserFileManagerAccess.getInstance().getTrashAssetByUri(mediaItem.uri));
      await operationImpl.recoverFromTrash(fileAssets);
      this.onCompleted()

    } catch (error) {
      Log.error(TAG, `recover error: ${error}`);
      this.onError();
    }

    this.menuContext.broadCast.emit(Constants.DELETE, []);
    Log.info(TAG, 'Single Recover confirm');
  }
}