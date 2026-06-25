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
import lazy { Constants as BrowserConstants } from '../../model/browser/photo/Constants';
import lazy { BigDataConstants, BigDataMsg, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';
import lazy { Constants } from '../../model/common/Constants';
import type common from '@ohos.app.ability.common';
import lazy { BrowserOperationFactory } from '../../interface/BrowserOperationFactory';
import type { OperationImpl } from '../../model/browser/photo/OperationImpl';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import { PhotoAccessHelperAccess, AssetAlbumRelation } from '../../access/PhotoAccessHelperAccess';
import { AlbumDefine } from '../../model/browser/AlbumDefine';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

/* instrument ignore file */
const TAG: string = 'common_RemoveAlbumMenuOperation';

export class RemoveAlbumMenuOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;

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
    let confirmCallback = (): void => {
      this.confirmCallback();
    };
    let cancelCallback = (): void => {
      this.cancelCallback();
    };
    let message = mediaItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO ?
      $r('app.string.remove_video_tips') : $r('app.string.remove_picture_tips');
    this.setConfirmText();
    this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_REMOVE_DIALOG,
      [message, $r('app.string.remove_from_album_tips'), confirmCallback, cancelCallback]);
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

  private doRemoveInSpecificCategory =
    async (context: common.UIAbilityContext, subClassifyAppend: string, sourceUris: number[], mainClassify: string,
      source: PhotoAsset[], uriIdMap: Map<string, number>, currentCard: string): Promise<void> => {
      // 删除在当前分类的数据
      const currentAlbumList =
        await PhotoAccessHelperAccess.getCategoryAlbums(context, photoAccessHelper.AlbumSubtype.CLASSIFY,
          [currentCard], 1);
      currentAlbumList.forEach(album => {
        PhotoAccessHelperAccess.removeFromClassAlbum(context, album, source as PhotoAsset[]);
      })
    }
  private removeCategorySub =
    async (context: common.UIAbilityContext, currentStage: Map<string, string | string[]>,
      source: PhotoAsset[]): Promise<void> => {
      const mainClassify: string = currentStage.get('mainClassify') as string;
      const currentCard: string = currentStage.get('currentCard') as string;
      const allSubClassify: string[] = currentStage.get('allSubClassify') as string[];
      Log.info(TAG, `mainClassify:${mainClassify}currentCard:${currentCard}allSubClassify:${allSubClassify}`)
      try {
        let subClassifyAppend = ''
        allSubClassify.forEach((item, idx, arr) => subClassifyAppend += idx === arr.length - 1 ? `'${item}'` :
          `'${item}',`);
        const uriIdMap: Map<string, number> = new Map();
        const sourceUris = source.map(asset => {
          const id = AlbumDefine.getFileIdFromUri(asset.uri ?? '') as number ?? Number.NaN;
          uriIdMap.set(asset.uri, id);
          return id;
        }) ?? [];
        Log.info(TAG, `check current tab${currentCard !== mainClassify}`)
        // 存在二级，且选择不是全部
        if (currentCard !== mainClassify) {
          await this.doRemoveInSpecificCategory(context, subClassifyAppend, sourceUris, mainClassify, source, uriIdMap,
            currentCard);
        } else {
          // 如果是全部,循环删除所有当前一级分类下的数据
          const albumList =
            await PhotoAccessHelperAccess.getCategoryAlbums(context, photoAccessHelper.AlbumSubtype.CLASSIFY,
              [...allSubClassify, mainClassify], 0);
          Log.info(TAG, `batch remove in all albumList${albumList.length}`)
          if (albumList) {
            albumList.forEach(album => {
              PhotoAccessHelperAccess.removeFromClassAlbum(context, album, source as PhotoAsset[]);
            })
          }
        }
      } catch (e) {
        Log.info(TAG, `do removeCategorySub error ${e.message}`)
      }
    }

  private async confirmCallback(): Promise<void> {
    this.menuContext.broadCast?.emit(BrowserConstants.PHOTO_BROWSER_REMOVE_CONFIRM, []);

    Log.info(TAG, 'Remove confirm');
    let mediaItem = this.menuContext.mediaItem;
    let albumUri = this.menuContext.albumUri;
    if (mediaItem == null) {
      Log.error(TAG, 'mediaItem is null, return');
      return;
    }
    const context = LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext');
    const currentStage: Map<string, string | string[]> | undefined =
      AppStorage.get<Map<string, string | string[]>>('classifyTabClickParam')
    Log.info(TAG, `currentStage${currentStage}`)
    if (currentStage) {
      try {
        if (context) {
          await this.removeCategorySub(context, currentStage, [mediaItem.data as PhotoAsset])
        }
        this.onCompleted();
      } catch (error) {
        Log.error(TAG, `currentStage remove error: ${error}, code: ${error?.code}`);
        this.onError();
      }
    } else {
      let operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
      try {
        let assets: PhotoAsset[] = [mediaItem.data as PhotoAsset];
        if (this.menuContext.isBurstPhotos && this.menuContext.burstPhotos) {
          assets = [...this.menuContext.burstPhotos.map(item => item.data)] as PhotoAsset[];
        }
        if (albumUri && context && mediaItem.data) {
          await (operationImpl as OperationImpl).dismissAsset(context, albumUri, [mediaItem.data]);
        }
        this.onCompleted();
      } catch (error) {
        Log.error(TAG, `remove error: ${error}, code: ${error?.code}`);
        this.onError();
      }
    }


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