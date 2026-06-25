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
import lazy { RestoreDefaultAlbumSortingDialog } from './RestoreDefaultAlbumSortingDialog';
import lazy { Log } from '../../utils/Log';
import lazy { DialogCallback } from '../../model/common/DialogUtil';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';

const TAG: string = 'common_RestoreDefaultAlbumSortingView';

@Component
export struct RestoreDefaultAlbumSortingView {
  /**
   * 广播
   */
  @Link broadCast: BroadCast;
  /**
   * 弹窗位置
   */
  @State private dialogAlignment: DialogAlignment | undefined = DialogAlignment.Center;
  /**
   * 恢复默认排序实现方法
   */
  private showRestoreDefaultAlbumSortingDialogFunc: Function = (confirmCallback: Function,
    cancelCallback: Function): void => this.showRestoreDefaultAlbumSortingDialog(confirmCallback, cancelCallback);
  /**
   *
   */
  @State private dialogCallback: DialogCallback = {
    confirmCallback: (): void => {
    }, cancelCallback: (): void => {
    }
  };
  /**
   * 恢复默认相册排序controller
   */
  public restoreDefaultAlbumSortingDialogController?: CustomDialogController | undefined;

  /**
   * 恢复默认相册排序弹窗方法
   */
  private showRestoreDefaultAlbumSortingDialog(confirmCallback: Function, cancelCallback: Function): void {
    Log.info(TAG, 'SHOW_RESTORE_DEFAULT_ALBUM_SORTING_DIALOG');
    this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
    this.restoreDefaultAlbumSortingDialogController = this.createRestoreDefaultAlbumSortingDialogController();
    this.restoreDefaultAlbumSortingDialogController?.open();
  }

  /**
   * 构建恢复默认排序Dialog
   * @returns
   */
  private createRestoreDefaultAlbumSortingDialogController(): CustomDialogController {
    return new CustomDialogController({
      builder: RestoreDefaultAlbumSortingDialog({
        closeFunc: (): void => this.closeRestoreDefaultAlbumSortingDialog(),
        cancelCallback: this.dialogCallback?.cancelCallback,
        confirmCallback: this.dialogCallback?.confirmCallback
      }),
      cancel: () => {
        this.restoreDefaultAlbumSortingDialogController?.close();
      },
      offset: {
        dx: 0,
        dy: 0,
      },
      alignment: this.dialogAlignment,
      autoCancel: false,
      customStyle: false,
    });
  }

  /**
   * 关闭恢复默认相册排序Dialog
   */
  private closeRestoreDefaultAlbumSortingDialog(): void {
    this.restoreDefaultAlbumSortingDialogController?.close?.();
  }

  aboutToDisAppear(): void {
    this.broadCast.off(BroadCastConstants.SHOW_RESTORE_DEFAULT_ALBUM_SORTING_DIALOG,
      this.showRestoreDefaultAlbumSortingDialogFunc);
  }

  aboutToAppear(): void {
    this.broadCast.on(BroadCastConstants.SHOW_RESTORE_DEFAULT_ALBUM_SORTING_DIALOG,
      this.showRestoreDefaultAlbumSortingDialogFunc);
  }

  build() {
  }
}