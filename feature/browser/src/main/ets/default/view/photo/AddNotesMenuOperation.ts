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

import type { MenuOperation, MenuOperationCallback } from '@ohos/common';
import { BroadCastConstants, BrowserOperationFactory, Log, MenuContext } from '@ohos/common';

const TAG: string = 'browser_AddNotesMenuOperation';

export class AddNotesMenuOperation implements MenuOperation, MenuOperationCallback {
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

    this.menuContext.broadCast.emit(BroadCastConstants.SHOW_ADD_NOTES_PHOTO_DIALOG,
      [this.confirmCallback, this.cancelCallback]);
  }

  onCompleted(): void {
    Log.info(TAG, 'Add notes data succeed!');
  }

  onError(): void {
    Log.error(TAG, 'Add notes data failed!');
  }

  private async confirmCallback(text: string) {
    Log.info(TAG, `Add notes confirm new name: ${text}`);
    let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
    let mediaItem = this.menuContext.mediaItem
    if (mediaItem == null) {
      Log.error(TAG, 'Add notes is null, return');
      return;
    }
  }

  private cancelCallback(): void {
    Log.info(TAG, 'Add notes cancel');
  }
}