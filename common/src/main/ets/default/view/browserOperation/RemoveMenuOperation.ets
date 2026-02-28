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
import lazy { BrowserOperationFactory } from '../../interface/BrowserOperationFactory';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { Constants as BrowserConstants } from '../../model/browser/photo/Constants';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';
import lazy { Constants } from '../../model/common/Constants';
import lazy { MenuContextConstants } from '../../model/common/MenuContextConstants';
import type { MenuOptionOtherParams } from './interfaces';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { BroadCastManager } from '../../model/common/BroadCastManager';

/* instrument ignore file */
const TAG: string = 'common_RemoveMenuOperation';

export class RemoveMenuOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  public doAction(): void {
    if (this.menuContext == null) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    let mediaItem = this.menuContext.mediaItem;
    if (mediaItem == null) {
      Log.error(TAG, 'mediaItem is null, return');
      return;
    }
    let confirmCallback = (): Promise<void> => this.confirmCallback();
    let cancelCallback = (): void => this.cancelCallback();
    let message = mediaItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO ?
    $r('app.string.remove_video_tips') : $r('app.string.remove_picture_tips');
    this.setConfirmText();
    let removeMsgContent: Resource = $r('app.string.remove_from_album_tips');
    // 从时刻中移除
    let menuOptionOtherParams: MenuOptionOtherParams | undefined =
      this.menuContext.get<MenuOptionOtherParams>(MenuContextConstants.MENU_OPTION_OTHER_PARAMS);
    if (menuOptionOtherParams?.isFromHighlight) {
      removeMsgContent = $r('app.string.remove_from_highlight_tips');
    }
    this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_REMOVE_DIALOG,
      [message, removeMsgContent, confirmCallback, cancelCallback]);
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

  private async confirmCallback(): Promise<void> {
    this.menuContext.broadCast?.emit(BrowserConstants.PHOTO_BROWSER_REMOVE_CONFIRM, []);

    Log.info(TAG, 'Remove confirm');
    let mediaItem = this.menuContext.mediaItem;
    if (mediaItem == null) {
      Log.error(TAG, 'mediaItem is null, return');
      return;
    }
    let menuOptionOtherParams: MenuOptionOtherParams | undefined =
      this.menuContext.get<MenuOptionOtherParams>(MenuContextConstants.MENU_OPTION_OTHER_PARAMS);
    Log.info(TAG, `menuOptionOtherParams: ${JSON.stringify(menuOptionOtherParams)}`);
    if (menuOptionOtherParams?.isFromHighlight) {
      if (menuOptionOtherParams?.album) {
        if (menuOptionOtherParams?.album.count === 1) {
          this.menuContext.broadCast?.emit(BroadCastConstants.HIGHLIGHT_UPDATE_BACK, []);
        } else {
          setTimeout((): void => {
            this.menuContext.broadCast?.emit(BroadCastConstants.HIGHLIGHT_UPDATE_CAROUSEL, []);
          });
        }
        Log.info(TAG, `Change isDoingDeleteBigPhotoAnim, fromPage:${this.menuContext.fromPage}`);
        if (this.menuContext.fromPage === 'FromPhotoBrowser') {
          AppStorage.setOrCreate<boolean>('isDoingDeleteBigPhotoAnim', true);
        }
      }
      return;
    }
    const context = global.uiAbilityContext();
    let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
    let assets: PhotoAsset[] = [mediaItem.data as PhotoAsset];
    if (this.menuContext.isBurstPhotos && this.menuContext.burstPhotos) {
      assets = [...this.menuContext.burstPhotos.map(item => item.data)] as PhotoAsset[];
    }
    try {
      if (this.menuContext.get<boolean>(MenuContextConstants.IS_FROM_PORTRAIT)) {
        await operationImpl.dismissAsset(context, this.menuContext.albumUri as string, assets, 4102);
      } else if (this.menuContext.get<boolean>(MenuContextConstants.IS_FROM_GROUP)) {
        await operationImpl.dismissAsset(context, this.menuContext.albumUri as string, assets, 4103);
      } else if (this.menuContext.get<boolean>(MenuContextConstants.IS_FROM_CLASS)) {
        await operationImpl.dismissAsset(context, this.menuContext.albumUri as string, assets, 4097);
      } else {
        await operationImpl.remove(assets, this.menuContext.albumUri ?? '');
      }
      this.onCompleted();
    } catch (error) {
      Log.error(TAG, `remove error: ${error}, code: ${error?.code}`);
      this.onError();
    }
    this.removeReportBigData();
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