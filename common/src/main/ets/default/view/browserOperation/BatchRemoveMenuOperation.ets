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
import type { SelectManager } from '../../model/browser/SelectManager';
import type { MenuContext } from './MenuContext';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { ProcessMenuOperation } from './ProcessMenuOperation';
import lazy { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import lazy { BigDataConstants, BigDataMsg, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';
import lazy { Constants } from '../../model/common/Constants';
import type { PhotoAsset } from '../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import lazy { PhotoAccessHelperAccess, AssetAlbumRelation } from '../../access/PhotoAccessHelperAccess';
import { AlbumDefine } from '../../model/browser/AlbumDefine';
import type common from '@ohos.app.ability.common';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { MenuContextConstants } from '../../model/common/MenuContextConstants';
import { UiUtil } from '../../utils/UiUtil';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { BroadCastManager } from '../../model/common/BroadCastManager';

/* instrument ignore file */
const TAG: string = 'common_BatchRemoveMenuOperation';

export class BatchRemoveMenuOperation extends ProcessMenuOperation {
  readonly BATCH_SIZE: number = 1000;
  private batchRemoveCancelFunc: Function = (): void => this.cancelFunc();
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  constructor(menuContext: MenuContext) {
    super(menuContext);
  }

  public setConfirmText(): void {
    AppStorage.setOrCreate<Resource>(Constants.CONFIRM_TEXT_KEY, $r('app.string.dialog_remove'));
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
    this.count = selectManager.getSelectedCount();
    if (this.count <= 0) {
      Log.error(TAG, 'count <= 0, return');
      return;
    }

    this.setConfirmText();
    let removeMsgContentRes: Resource =
        this.menuContext.get<boolean>(MenuContextConstants.IS_FROM_PORTRAIT) ?
        $r('app.string.remove_from_album_tips') :
        $r('app.plural.remove_from_album_tips', this.count);
    this.menuContext.broadCast?.on(BroadCastConstants.CANCEL_PROGRESS_DIALOG, this.cancelProgress.bind(this));
    if (this.menuContext.get<boolean>(MenuContextConstants.IS_FROM_GROUP)) {
      this.initGroupDialog();
    } else {
      this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_REMOVE_DIALOG,
        [
            selectManager.isAllSelected ? $r('app.string.remove_all_files_tips') :
            (this.count === 1 ? $r('app.string.remove_single_file_tips') :
              $r('app.plural.remove_files_tips', this.count, this.count)),
          removeMsgContentRes,
          this.confirmCallback,
          this.cancelCallback
        ]
      );
    }
  }

  private initGroupDialog(): void {
    let message: Resource | string = '';
    let removeMsgContent: Resource | string = '';
    if (this.count === 0) {
      Log.error(TAG, `null mediaItem will be removed`)
      return;
    } else if (this.count === 1) {
      this.menuContext.selectManager?.getSelectAsset((assets: PhotoAsset[]) => {
        message = assets[0].photoType == UserFileManagerAccess.MEDIA_TYPE_VIDEO ?
          $r('app.string.remove_video_tips') : $r('app.string.remove_picture_tips');
        removeMsgContent = assets[0].photoType === UserFileManagerAccess.MEDIA_TYPE_VIDEO ?
          $r('app.string.remove_video_from_group_tip') : $r('app.string.remove_photo_from_group_tip')
      })
    } else {
      message = $r('app.string.remove_photo_from_group');
      removeMsgContent = $r('app.string.remove_photos_from_group_tip');
    }
    this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_REMOVE_DIALOG,
      [
        message,
        removeMsgContent,
        this.confirmCallback,
        this.cancelCallback
      ]
    );
  }

  // Asynchronous callback for selectedCallback
  public callback(uris: string[]): void {
    if (this.isCancelled) {
      return;
    }
    this.uris = uris;
    this.processOperation();
  }

  public selectAssetCallback(assets: PhotoAsset[]): void {
    if (this.isCancelled) {
      return;
    }
    this.selectAssets = assets;
    Log.info(TAG, `selectAssetCallback ${this.selectAssets.length}`);
    this.processOperation();
  }

  // Remove a batch of data
  public requestOneBatchOperation(): void {
    Log.info(TAG, 'requestOneBatchOperation');
    if (this.isCancelled) {
      return;
    }
    this.currentBatch++;
    let startIndex: number = (this.currentBatch - 1) * this.BATCH_SIZE;
    let endIndex: number = this.currentBatch * this.BATCH_SIZE;
    let batchAssets: PhotoAsset[] = this.selectAssets.slice(startIndex, Math.min(endIndex, this.selectAssets.length));
    Log.info(TAG, `requestOneBatchOperation ${batchAssets.length}`);

    TraceControllerUtils.startTraceWithTaskId('remove', this.currentBatch);
    this.remove(batchAssets as PhotoAsset[]);
    TraceControllerUtils.finishTraceWithTaskId('remove', this.currentBatch);
  }

  public confirmCallback = (): void => {
    Log.info(TAG, 'Batch remove confirm');

    // 1. Variable initialization
    this.onOperationEnd = this.menuContext.onOperationEnd;

    // 2. selectManager gets the URI of the data and starts processing deletion in the callback
    this.menuContext.selectManager?.getSelectAssetsWidthBurstPhotos(
      (assets: PhotoAsset[]) => this.selectAssetCallback(assets));

    // 3. onDeleteStart exit selection mode
    let onOperationStart: Function = this.menuContext.onOperationStart;
    onOperationStart?.();

    let msg: Record<string, number | string | boolean> = {
      'count': this.count,
      'from': BigDataConstants.GRID_ALBUM_PHOTO,
    };
    ReportToBigDataUtil.report(BigDataConstants.REMOVE_MENU_RESPONSE, msg);

    this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
      [$r('app.string.action_remove_process'), this.batchRemoveCancelFunc]);
  };

  public onOperateContinue(): void {
    Log.info(TAG, 'Operate Continue');
    this.isPause = false;
    this.cyclicOperation();
  }

  public cancelFunc(): void {
    Log.info(TAG, 'progress cancel');
    this.onOperatePause();
    let cancelMessage = $r('app.string.remove_cancel_message', `${this.getExpectProgress().toString()}%`);

    this.menuContext.broadCast?.emit(BroadCastConstants.CANCEL_OPERATE,
      [cancelMessage, (): void => this.onOperateContinue(), (): void => this.onOperateCancelled()]);
  }

  public cancelCallback = (): void => {
    Log.info(TAG, 'Batch delete cancel');
    this.setConfirmText();
    if (!this.menuContext.fromSelectMode) {
      this.menuContext.selectManager?.deSelectAll();
    }
  };
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
      Log.info(TAG, `mainClassify:${mainClassify}currentCard:${currentCard}`)

      try {
        let subClassifyAppend = ''
        allSubClassify.forEach((item, idx, arr) => subClassifyAppend += idx === arr.length - 1 ? `'${item}'` :
          `'${item}',`)
        const uriIdMap: Map<string, number> = new Map()
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
          Log.info(TAG, `batch remove in all albumList${albumList?.length}`)
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

  private async remove(source: PhotoAsset[]): Promise<void> {
    Log.debug(TAG, `debug-remove Parameters: source:${JSON.stringify(source)}`);
    try {
      ReportToBigDataUtil.report(BigDataConstants.REMOVE_FILE_OPERATION_START, undefined);
      const context = LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext');
      if (!context) {
        return;
      }

      const currentStage: Map<string, string | string[]> | undefined =
        AppStorage.get<Map<string, string | string[]>>('classifyTabClickParam')
      Log.info(TAG, `currentStage${JSON.stringify(currentStage)}`)

      if (currentStage) {
        // 分类相册页面并且存在二级分类
        if (source.length > 100) {
          UiUtil.showToast($r('app.string.document_scan_count_limit'), 100);
          this.menuContext.broadCast?.emit(BroadCastConstants.HIDE_PROGRESS_DIALOG,[]);
          return;
        }
        await this.removeCategorySub(context, currentStage, source);
      } else if (this.menuContext.get<boolean>(MenuContextConstants.IS_FROM_PORTRAIT)) {
        const album = await PhotoAccessHelperAccess.getAlbumByUri(context, {
          albumType: photoAccessHelper.AlbumType.SMART,
          albumSubtype: Constants.PORTRAIT_QUERY_SUB_TYPE,
          albumUri: this.menuContext.albumUri ?? '',
        });
        if (album) {
          await PhotoAccessHelperAccess.removeFromClassAlbum(context, album, source as PhotoAsset[]).then(() => {
          });
        }
      } else if (this.menuContext.get<boolean>(MenuContextConstants.IS_FROM_CLASS)) {
        const album = await PhotoAccessHelperAccess.getAlbumByUri(context, {
          albumType: photoAccessHelper.AlbumType.SMART,
          albumSubtype: photoAccessHelper.AlbumSubtype.CLASSIFY,
          albumUri: this.menuContext.albumUri ?? '',
        });
        if (album) {
          await PhotoAccessHelperAccess.removeFromClassAlbum(context, album, source as PhotoAsset[]);
        }
      } else if (this.menuContext.get<boolean>(MenuContextConstants.IS_FROM_GROUP)) {
        const album = await PhotoAccessHelperAccess.getAlbumByUri(context, {
          albumType: photoAccessHelper.AlbumType.SMART,
          albumSubtype: photoAccessHelper.AlbumSubtype.GROUP_PHOTO,
          albumUri: this.menuContext.albumUri ?? '',
        });
        if (album) {
          await PhotoAccessHelperAccess.removeFromClassAlbum(context, album, source as PhotoAsset[]);
        }
      } else {
        await UserFileManagerAccess.getInstance().removeFilesFromAlbum(this.menuContext.albumUri ?? '',
          source as PhotoAsset[]);
      }
      ReportToBigDataUtil.report(BigDataConstants.REMOVE_FILE_OPERATION_FINISH, undefined);
      this.onCompleted();
    } catch (error) {
      let msg: Record<string, number | string | boolean> = {
        'type': BigDataConstants.MEDIA_REMOVE_ERROR,
        'count': this.count,
        'errMsg': error,
      };
      ReportToBigDataUtil.errEventReport(BigDataConstants.ALBUM_OPERATION_ERROR_ID, msg);
      Log.error(TAG, `removeFile is error ${error}, code: ${error?.code}`);
      this.onError();
    }
  }
}