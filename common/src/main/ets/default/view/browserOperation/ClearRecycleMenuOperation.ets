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

import lazy { BroadCastConstants } from '../../../default/model/common/BroadCastConstants';
import lazy { Constants } from '../../../default/model/common/Constants';
import type { PositionParams } from '../../../default/view/browserOperation/DeleteMenuOperation';
import lazy { DeleteMenuOperation } from '../../../default/view/browserOperation/DeleteMenuOperation';
import lazy { Log } from '../../../default/utils/Log';
import type { MenuContext } from '../../../default/view/browserOperation/MenuContext';
import type { SelectManager } from '../../../default/model/browser/SelectManager';

/* instrument ignore file */
const TAG: string = 'ClearRecycleMenuOperation';

export class ClearRecycleMenuOperation extends DeleteMenuOperation {
  constructor(menuContext: MenuContext) {
    super(menuContext);
    this.isClear = true;
  }

  public doAction(): void {
    if (this.menuContext == null) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    let selectManager: SelectManager | undefined = this.menuContext.selectManager;
    if (selectManager == null) {
      Log.error(TAG, 'selectManager is null, return');
      return;
    }
    selectManager.selectAllWithoutNotify(true, false);
    this.count = selectManager.getSelectedCountForRecycle();
    if (this.count <= 0) {
      Log.error(TAG, 'count <= 0, return');
      return;
    }
    let locationParams: PositionParams = {
      isClearRecycle: this.isClear,
      isHoldPosition: this.isHoldPosition,
    };

    AppStorage.setOrCreate<Resource>(Constants.CONFIRM_TEXT_KEY, $r('app.string.dialog_clear'));
    this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_DELETE_DIALOG,
      [this.getClearDialog(), (): void => this.confirmCallback(),
        (): void => this.cancelCallback(), false, locationParams]);
  }

  private getClearDialog(): Resource[] {
    let cloudDriveStatus: boolean | undefined = AppStorage.get<boolean>('cloudDriveStatus');
    return cloudDriveStatus ?
      [$r('app.string.clear_tips'), $r('app.string.cloud_all_files_dialog_delete_permanently_not_recover_tips')] :
      [$r('app.string.clear_tips'), $r('app.string.recycleAlbum_clear_message')];
  }

  protected cancelCallback = (): void => {
    Log.info(TAG, 'Batch delete cancel');
    this.menuContext.selectManager?.deSelectAll();
  };
}