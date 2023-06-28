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

import type { MenuContext, MenuOperation } from '@ohos/common';
import { BrowserOperationFactory, BrowserConstants as Constants, Log } from '@ohos/common';

const TAG: string = 'browser_FavoriteMenuOperation';

export class FavoriteMenuOperation implements MenuOperation {
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
    let requestState = mediaItem.isFavor;
    this.changeFavor(mediaItem.uri, requestState);
    Log.info(TAG, `progressFavorite: ${(requestState ? 'FAVORITE' : 'NOT_FAVORITE')}`);
  }

  private async changeFavor(uri, requestState) {
    let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
    let result = await operationImpl.favor(uri, requestState);
    this.menuContext.broadCast.emit(Constants.SAVE_SCALE, []);
    this.menuContext.broadCast.emit(Constants.SET_FAVOR, [result]);
  }
}