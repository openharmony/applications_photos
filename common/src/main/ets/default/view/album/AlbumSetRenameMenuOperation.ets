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

import type { AlbumInfo } from '../../../default/model/browser/album/AlbumInfo';
import type { MenuContext } from '../../../default/view/browserOperation/MenuContext';
import type { MenuOperation } from '../../../default/view/browserOperation/MenuOperation';
import type { MenuOperationCallback } from '../../../default/view/browserOperation/MenuOperationCallback';
import type { SelectManager } from '../../../default/model/browser/SelectManager';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../../default/utils/ReportToBigDataUtil';
import lazy { BroadCastConstants } from '../../../default/model/common/BroadCastConstants';
import lazy { Log } from '../../../default/utils/Log';
import lazy { UiUtil } from '../../../default/utils/UiUtil';
import lazy { UserFileManagerAccess } from '../../../default/access/UserFileManagerAccess';
import type photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { BroadCastManager } from '../../../default/model/common/BroadCastManager';
import type { BroadCast } from '../../../default/utils/BroadCast';
import lazy { AlbumDefine } from '../../../default/model/browser/AlbumDefine';
import lazy { TraceControllerUtils } from '../../../default/utils/TraceControllerUtils';
import lazy { FACardChangeTypesConstants as FACardConstants } from '../../../default/model/common/FormConstants';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { AlbumUtils } from '../../../default/utils/AlbumUtils';

/* instrument ignore file */

const TAG: string = 'browser_AlbumSetRenameMenuOperation';

export class AlbumSetRenameMenuOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;
  private sourceAlbum?: photoAccessHelper.Album;
  private sourceAlbumInfo?: AlbumInfo;
  private onOperationEnd?: Function;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  public doAction(): void {
    if (this.menuContext.fromSelectMode === undefined) {
      Log.error(TAG, 'menuContext or fromSelectMode is empty, return');
      return;
    }
    this.sourceAlbumInfo = this.menuContext?.albumInfo;
    const msg: Record<string, number | string | undefined> = {
      'type': BigDataConstants.ALBUM_RENAME,
      'albumType': this.sourceAlbumInfo?.subType,
    };
    ReportToBigDataUtil.report(BigDataConstants.ALBUM_OPERATION_ID, msg);
    let uri: string | undefined = undefined;
    if (this.menuContext.fromSelectMode) {
      let selectManager: SelectManager | undefined = this.menuContext.selectManager;
      if (!selectManager) {
        Log.error(TAG, 'selectManager is null, return');
        return;
      }
      let count = this.menuContext.selectManager?.clickedSet.size;
      if (count !== 1 && !selectManager?.albumUri) {
        Log.error(TAG, 'count != 1, return');
        return;
      }
      uri = Array.from(this.menuContext.selectManager?.clickedSet ?? [])[0] || selectManager?.albumUri;
    } else {
      if (!this.sourceAlbumInfo) {
        Log.error(TAG, 'sourceAlbumInfo is null, return');
        return;
      }
      uri = this.sourceAlbumInfo?.uri;
    }
    let confirmCallback = (newName: string): Promise<void> => this.confirmCallback(newName, uri);
    let cancelCallback = (): void => this.cancelCallback();

    UserFileManagerAccess.getInstance().getAlbumByUri(uri).then(async (album: photoAccessHelper.Album |
    undefined) => {
      this.sourceAlbum = album;
      Log.info(TAG, `The name of clicked album is ${AlbumDefine.getAnonymizeAlbumName(this.sourceAlbum?.albumName)}`);

      this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_RENAME_PHOTO_DIALOG,
        [this.sourceAlbum?.albumName, confirmCallback, cancelCallback]);
    });
  }

  public onCompleted(): void {
    Log.info(TAG, 'Rename data succeed!');
    this.onOperationEnd?.();
  }

  public onError(): void {
    Log.error(TAG, 'Rename data failed!');
    this.onOperationEnd?.();
  }

  private async confirmCallback(newName: string, oldUri: string | undefined): Promise<void> {
    Log.info(TAG, `AlbumSet rename confirm and the new name is: ${AlbumDefine.getAnonymizeAlbumName(newName)}`);

    this.onOperationEnd = this.menuContext.onOperationEnd;
    let onOperationStart: Function = this.menuContext.onOperationStart;
    onOperationStart?.();

    this.rename(newName, oldUri);
  }

  // 新框架重命名
  private async renameForNewPhotoGrid(name: string, oldUri: string | undefined): Promise<void> {
    try {
      let startTime: number = Date.now();
      TraceControllerUtils.startTraceWithTaskId('getAlbumByName', startTime);
      let targetAlbum = await UserFileManagerAccess.getInstance().getAlbumByName(name);
      TraceControllerUtils.finishTraceWithTaskId('getAlbumByName', startTime);
      Log.info(TAG, `getAlbumByName cost ${Date.now() - startTime} ms`);
      if (targetAlbum) {
        this.appBroadCast.emit(BroadCastConstants.UPDATE_TITLE,
          []);
        UiUtil.showToast($r('app.string.name_already_use'));
        this.onError();
        return;
      }
      // 用于新框架下未适配的老宫格 新建相册 适配完成可删除
      let isOldGrid: boolean | undefined = this.menuContext.get<boolean>('isOldGrid');
      isOldGrid = isOldGrid === undefined ? false : isOldGrid;
      // 刷新相册宫格页名称 用于老宫格 适配完成可删除
      if (isOldGrid) {
        Log.info(TAG, `oldGrid: broadcast UPDATE_TITLE before renameAlbum`);
        this.appBroadCast.emit(BroadCastConstants.UPDATE_TITLE, [name, oldUri]);
      }
      if (this.sourceAlbum) {
        await UserFileManagerAccess.getInstance().renameAlbum(this.sourceAlbum, name);
        const album = await UserFileManagerAccess.getInstance().getAlbumByName(name);
        if (album?.albumUri) {
          if (this.sourceAlbumInfo) {
            // 同步相册视图模式
            await AlbumUtils.setViewMode(getContext(), this.sourceAlbumInfo);
            await AlbumUtils.saveViewMode(getContext(), album?.albumSubtype, album?.lpath, this.sourceAlbumInfo?.viewMode);
          }
          this.startFACardService(album?.albumUri, oldUri);
          // 刷新相册页名称
          this.menuContext.uiContext?.eventHub
            .emit(BroadCastConstants.ALBUM_RENAME_ALBUM_TAB, this.sourceAlbum.albumUri, album?.albumUri);
          Log.info(TAG, `rename finish, albumUri: ${this.sourceAlbum.albumUri} -> ${album?.albumUri}`);
        } else {
          Log.info(TAG, 'rename cannot connectFACardService without new album uri');
        }
      }
      // 刷新相册宫格页名称 用于新宫格 全部适配完成可删除判断条件
      if (!isOldGrid) {
        Log.info(TAG, `newGrid: broadcast UPDATE_TITLE after renameAlbum`);
        this.appBroadCast.emit(BroadCastConstants.UPDATE_TITLE, [name, oldUri]);
      }
      Log.info(TAG, `rename all cost: ${Date.now() - startTime}`);
      this.onCompleted();
    } catch (error) {
      let msg: Record<string, number | string | boolean> = {
        'type': BigDataConstants.ALBUM_RENAME_ERROR,
        'errMsg': error,
      };
      ReportToBigDataUtil.errEventReport(BigDataConstants.ALBUM_OPERATION_ERROR_ID, msg);
      Log.error(TAG, `AlbumSet rename failed: ${error}, code: ${error?.code}`);
      this.onError();
    }
  }

  private async rename(name: string, oldUri: string | undefined): Promise<void> {
    if (AlbumUtils.useNewPhotoGrid()) {
      // 新框架走此分支
      Log.info(TAG, 'rename with function for new photo grid');
      this.renameForNewPhotoGrid(name, oldUri);
      return;
    }
    try {
      let startTime: number = Date.now();
      TraceControllerUtils.startTraceWithTaskId('getAlbumByName', startTime);
      let targetAlbum = await UserFileManagerAccess.getInstance().getAlbumByName(name);
      TraceControllerUtils.finishTraceWithTaskId('getAlbumByName', startTime);
      Log.info(TAG, `getAlbumByName cost ${Date.now() - startTime} ms`);
      if (targetAlbum) {
        this.appBroadCast.emit(BroadCastConstants.UPDATE_TITLE,
          []);
        UiUtil.showToast($r('app.string.name_already_use'));
        this.onError();
        return;
      }
      this.appBroadCast.emit(BroadCastConstants.UPDATE_TITLE, [name, oldUri]);
      if (this.sourceAlbum) {
        await UserFileManagerAccess.getInstance().renameAlbum(this.sourceAlbum, name);
        const album = await UserFileManagerAccess.getInstance().getAlbumByName(name);
        if (album?.albumUri) {
          this.startFACardService(album?.albumUri, oldUri);

          this.menuContext.uiContext?.eventHub
            .emit(BroadCastConstants.ALBUM_RENAME_ALBUM_TAB, this.sourceAlbum.albumUri, album?.albumUri);
          Log.info(TAG, `rename finish, albumUri: ${this.sourceAlbum.albumUri} -> ${album?.albumUri}`);
        } else {
          Log.info(TAG, 'rename cannot connectFACardService without new album uri');
        }
      }
      Log.info(TAG, `rename all cost: ${Date.now() - startTime}`);
      this.onCompleted();
    } catch (error) {
      let msg: Record<string, number | string | boolean> = {
        'type': BigDataConstants.ALBUM_RENAME_ERROR,
        'errMsg': error,
      };
      ReportToBigDataUtil.errEventReport(BigDataConstants.ALBUM_OPERATION_ERROR_ID, msg);
      Log.error(TAG, `AlbumSet rename failed: ${error}, code: ${error?.code}`);
      this.onError();
    }
  }

  private startFACardService(newAlbumUri: string, oldAlbumUri?: string) {
    Log.info(TAG, 'connectFACardService start');
    let want: Want = {
      deviceId: '',
      bundleName: 'com.ohos.photos',
      abilityName: 'FACardServiceAbility',
      parameters: {
        assetChangeType: FACardConstants.ALBUM_RENAME,
        assetChangeTypes: [],
        assetChangeUris: [newAlbumUri, oldAlbumUri],
      },
    };
    if (this.menuContext.uiContext) {
      try {
        this.menuContext.uiContext.startServiceExtensionAbility(want, () => {
          Log.info(TAG, 'connectFACardService success');
        });
      } catch (err) {
        Log.error(TAG, `connectFACardService failed, code is ${err.code}, message is ${err.message}`);
      }
    } else {
      Log.info(TAG, 'connectFACardService failed without context');
    }
  }

  private cancelCallback(): void {
    Log.info(TAG, 'AlbumSet rename cancel');
  }
}