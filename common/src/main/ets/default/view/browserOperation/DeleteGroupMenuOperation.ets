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
import type { MenuContext } from './MenuContext';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import type { MenuOperationCallback, MenuOperationCallbackParam } from './MenuOperationCallback';
import type { MenuOperation } from './MenuOperation';
import lazy { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import lazy { PhotoAlbum } from '../../access/PhotoAccessHelperAccess';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { Constants } from '../../model/common/Constants';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import type { PositionParams } from './DeleteMenuOperation';

/* instrument ignore file */
const TAG: string = 'isRemoveFromGroupMenuOperation';

export class DeleteGroupMenuOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  onCompleted(result?: MenuOperationCallbackParam | undefined): void {
    Log.info(TAG, `delete group complete`)
  }

  onError(): void {
    Log.error(TAG, `delete group error`)
  }

  public doAction(): void {
    if (!this.menuContext) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }

    this.handleSelectedUris();
  }

  private async handleSelectedUris(): Promise<void> {
    let selectedUris: string[] = [];
    if (this.menuContext.selectManager?.albumUri) {
      selectedUris = [this.menuContext.selectManager.albumUri];
    } else if (this.menuContext.albumUri) {
      selectedUris = [this.menuContext.albumUri];
    } else {
      selectedUris = await this.menuContext.selectManager?.getSelectedUri() || [];
    }
    Log.info(TAG, `handleSelectedUris: ${selectedUris.length},
      ${await this.menuContext.selectManager?.getSelectedUri()},  ${this.menuContext.selectManager?.albumUri}`)
    this.initDialog(selectedUris)
  }

  private initDialog(albumUris: string[]): void {
    let confirmCallback = (): Promise<void> => this.confirmCallback(albumUris);
    let cancelCallback = (): void => this.cancelCallback();
    let message: Resource | string = '';
    let removeMsgContent: Resource | string = '';
    let mes = this.getDialog(albumUris);
    message = mes[0];
    removeMsgContent = mes[1];
    this.setConfirmText();
    let locationParams: PositionParams = {
      isClearRecycle: false,
      isHoldPosition: false,
    };
    this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_DELETE_DIALOG,
      [[message, removeMsgContent], confirmCallback, cancelCallback, true, locationParams]);
  }

  // 一阶段不做删除，先预留
  public async confirmCallback(albumUris: string[]): Promise<void> {
    this.menuContext.broadCast?.emit(BroadCastConstants.REMOVE_FROM_GROUP_COMPLETE_DIALOG, []);
    Log.info(TAG, 'Remove confirm');
    for (let albumUri of albumUris) {
      try {
        let album: PhotoAlbum = await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri) as PhotoAlbum;
        let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
            new photoAccessHelper.MediaAlbumChangeRequest(album);
        albumChangeRequest.dismiss();
        await photoAccessHelper.getPhotoAccessHelper(getContext(this))
          .applyChanges(albumChangeRequest);
        Log.info(TAG, 'dismiss successfully');
      } catch (err) {
        console.error(`dismissDemo failed with error: ${err.code}, ${err.message}`);
      }
    }
    let selectManager: SelectManager | undefined = this.menuContext.selectManager;
    for (let albumUri of albumUris) {
      selectManager?.removeItem(albumUri)
    }
    if (selectManager?.totalCount && selectManager.totalCount <= 0) {
      selectManager?.onModeChange(false);
    }
    Log.info(TAG, `Change isDoingDeleteBigPhotoAnim, ${selectManager?.totalCount}`);
    if (this.menuContext.fromPage === 'FromPhotoBrowser') {
      AppStorage.setOrCreate<boolean>('isDoingDeleteBigPhotoAnim', true);
    }
    if (this.menuContext.onOperationEnd) {
      this.menuContext.onOperationEnd?.();
    }
  }

  private cancelCallback(): void {
    Log.info(TAG, 'remove cancel');
    this.setConfirmText();
  }

  public setConfirmText(): void {
    AppStorage.setOrCreate<Resource>(Constants.CONFIRM_TEXT_KEY, $r('app.string.dialog_delete'));
  }

  private getDialog(selectedUris: string[]): Resource[] {
    if (!selectedUris?.length) {
      Log.error(TAG, 'selected uris is empty, return');
      return [];
    }
    if (selectedUris.length === 1) {
      return [
        $r('app.string.delete_this_group_album'),
        $r('app.string.delete_from_one_group_tips')
      ];
    }
    return [
      $r('app.plural.remove_selected_group_albums', selectedUris.length, selectedUris.length),
      $r('app.string.delete_from_group_tips')
    ];
  }
}