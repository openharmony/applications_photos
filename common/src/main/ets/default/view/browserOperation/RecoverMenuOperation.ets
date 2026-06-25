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

import lazy { Log } from '../../utils/Log';
import type { MenuContext } from '../../view/browserOperation/MenuContext';
import type { MenuOperation } from '../../view/browserOperation/MenuOperation';
import type { MenuOperationCallback } from '../../view/browserOperation/MenuOperationCallback';
import lazy { BrowserOperationFactory } from '../../interface/BrowserOperationFactory';
import { PhotoAsset } from '../dialog/MoveDialog';
import { Constants } from '../../model/browser/photo/Constants';

/* instrument ignore file */
const TAG: string = 'RecoverMenuOperation';

export class RecoverMenuOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  public doAction(): void {
    if (this.menuContext == null) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    AppStorage.setOrCreate<boolean>('isDoingRecoverBigPhotoAnim', true);
    this.doRecover();
  }

  public onCompleted(): void {
    Log.info(TAG, 'Recover data succeed!');
  };

  public onError(): void {
    Log.error(TAG, 'Recover data failed!');
  }

  private async doRecover(): Promise<void> {
    let mediaItem = this.menuContext.mediaItem;
    if (!mediaItem || !mediaItem.data) {
      Log.error(TAG, 'mediaItem is null');
      return;
    }
    let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
    try {
      let batchAssets: PhotoAsset[] = [];
      if (mediaItem.data) {
        batchAssets.push(mediaItem.data);
      }
      AppStorage.setOrCreate<boolean>('isDoingDeleteBigPhotoAnim', true);
      await operationImpl.recoverFromTrash(batchAssets);
      this.onCompleted();
    } catch (error) {
      Log.error(TAG, `recover error: ${error}`);
      this.onError();
    }
    this.menuContext.broadCast?.emit(Constants.DELETE, []);
    Log.info(TAG, 'Single Recover confirm');
  }
}