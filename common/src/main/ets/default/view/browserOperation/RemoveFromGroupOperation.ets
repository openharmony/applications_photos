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

import lazy { PhotoAsset, UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import lazy { Log } from '../../utils/Log';
import type { MenuOperationCallback } from './MenuOperationCallback';
import type { MenuOperation } from './MenuOperation';
import type { MenuContext } from './MenuContext';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { Constants as BrowserConstants } from '../../model/browser/photo/Constants';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';
import lazy { Constants } from '../../model/common/Constants';
import lazy { PhotoAlbum } from '../../access/PhotoAccessHelperAccess';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import lazy { MediaItem } from '../../model/browser/photo/MediaItem';
import lazy {  MenuConstants } from '../actionbar/Menu';

/* instrument ignore file */
const TAG: string = 'common_RemoveFromGroupOperation';

export class RemoveFromGroupOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  public doAction(): void {
    if (this.menuContext == null) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }

    let mediaItem = this.menuContext.get<MediaItem>(MenuConstants.KEY_CURRENT_PHOTO) ?? this.menuContext.mediaItem;
    Log.info(TAG, `mediaItem: ${this.menuContext.get<MediaItem>(MenuConstants.KEY_CURRENT_PHOTO)} ${this.menuContext.mediaItem}`)
    if (mediaItem) {
      if (!mediaItem.data) {
        Log.error(TAG, `mediaItem data is undefined`);
        return;
      }
      this.initDialog([mediaItem.data]);
      Log.i(TAG, 'Single share confirmed');
      return;
    }

    let selectManager: SelectManager | undefined = this.menuContext.selectManager;
    if (!selectManager) {
      Log.error(TAG, `selectManager is null, return`);
      return;
    }
    selectManager?.getSelectAsset((assets: PhotoAsset[]) => this.initDialog(assets));
  }

  public setConfirmText(): void {
    AppStorage.setOrCreate<Resource>(Constants.CONFIRM_TEXT_KEY, $r('app.string.dialog_remove'));
  }

  public onCompleted(): void {
    Log.info(TAG, 'Remove data succeed!');
    this.menuContext.broadCast?.emit(BrowserConstants.REMOVE, []);
  }

  public onError(): void {
    Log.error(TAG, 'Remove data failed!');
  }

  private initDialog(assets: PhotoAsset[]): void {
    let confirmCallback = (): Promise<void> => this.confirmCallback(assets);
    let cancelCallback = (): void => this.cancelCallback();
    let message: Resource | string = '';
    let removeMsgContent: Resource | string = '';
    if (assets.length === 0) {
      Log.error(TAG, `null mediaItem will be removed`)
      return;
    } else if (assets.length === 1) {
      message = assets[0].photoType == UserFileManagerAccess.MEDIA_TYPE_VIDEO ?
      $r('app.string.remove_video_tips') : $r('app.string.remove_picture_tips');
      removeMsgContent = assets[0].photoType === UserFileManagerAccess.MEDIA_TYPE_VIDEO ?
      $r('app.string.remove_video_from_group_tip') : $r('app.string.remove_photo_from_group_tip')
    } else {
      message = $r('app.string.remove_photo_from_group');
      removeMsgContent = $r('app.string.remove_photos_from_group_tip');
    }
    this.setConfirmText();
    this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_REMOVE_DIALOG,
      [message, removeMsgContent, confirmCallback, cancelCallback]);
  }

  private async confirmCallback(assets: PhotoAsset[]): Promise<void> {
    this.menuContext.broadCast?.emit(BrowserConstants.PHOTO_BROWSER_REMOVE_CONFIRM, []);

    Log.info(TAG, 'Remove confirm');

    let album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getAlbumByUri(this.menuContext.albumUri);
    if (!album) {
      Log.error(TAG, `album uri is null!`);
      return;
    }
    if (album.count === assets.length) {
      Log.info(TAG, `album count = assets count`)
      await UserFileManagerAccess.dismissAssets(album, assets);
      this.menuContext.broadCast?.emit(BroadCastConstants.HIGHLIGHT_UPDATE_BACK, []);
    } else if (album.count < assets.length) {
      Log.error(TAG, `album count is error`)
      return;
    } else {
      Log.info(TAG, 'Remove doing');
      await UserFileManagerAccess.dismissAssets(album, assets);
    }
    let selectManager: SelectManager | undefined = this.menuContext.selectManager;
    selectManager?.onModeChange(false);
    Log.info(TAG, `Change isDoingDeleteBigPhotoAnim, fromPage:${this.menuContext.fromPage}`);
    if (this.menuContext.fromPage === 'FromPhotoBrowser') {
      AppStorage.setOrCreate<boolean>('isDoingDeleteBigPhotoAnim', true);
    }
  }

  public removeReportBigData(): void {
    let removeCount: number = 1;
    let msg: Record<string, number | string | boolean> = {
      'count': removeCount,
      'from': BigDataConstants.REMOVE_LARGER_ALBUM_PHOTO,
    };
    ReportToBigDataUtil.report(BigDataConstants.REMOVE_MENU_RESPONSE, msg);

    Log.info(TAG, 'Single remove confirm');
  }

  private cancelCallback(): void {
    this.setConfirmText();
    Log.info(TAG, 'remove cancel');
  }
}