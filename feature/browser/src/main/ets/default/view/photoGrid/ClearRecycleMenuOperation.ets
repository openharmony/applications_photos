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

import {
  BatchDeleteMenuOperation,
  BroadCastConstants,
  Constants,
  Log,
  MenuContext,
  SelectManager
} from '@ohos/common';

const TAG: string = 'browser_ClearRecycleMenuOperation';

export class ClearRecycleMenuOperation extends BatchDeleteMenuOperation {
  constructor(menuContext: MenuContext) {
    super(menuContext);
  }

  doAction(): void {
    if (this.menuContext == null) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    let selectManager: SelectManager = this.menuContext.selectManager;
    if (selectManager == null) {
      Log.error(TAG, 'selectManager is null, return');
      return;
    }
    selectManager.selectAllWithoutNotify(true, false);
    this.count = selectManager.getSelectedCount();
    if (this.count <= 0) {
      Log.error(TAG, 'count <= 0, return');
      return;
    }

    AppStorage.setOrCreate<Resource>(Constants.CONFIRM_TEXT_KEY, $r('app.string.dialog_clear'));
    this.menuContext.broadCast.emit(BroadCastConstants.SHOW_DELETE_DIALOG,
      [$r('app.string.recycleAlbum_clear_message'), (): void => this.confirmCallback(), (): void => this.cancelCallback()]);
  }

  cancelCallback(): void {
    Log.info(TAG, 'Batch delete cancel');
    this.menuContext.selectManager.deSelectAll();
  }
}