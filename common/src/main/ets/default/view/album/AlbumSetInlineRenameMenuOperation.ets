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
import lazy { StringUtil } from '../../../default/utils/StringUtil';
import type { BroadCast } from '../../../default/utils/BroadCast';
import lazy { AlbumDefine } from '../../../default/model/browser/AlbumDefine';
import lazy { TraceControllerUtils } from '../../../default/utils/TraceControllerUtils';

/* instrument ignore file */

const TAG: string = 'AlbumSetInlineRenameMenuOperation';

export class AlbumSetInlineRenameMenuOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;
  private sourceAlbum: photoAccessHelper.Album | undefined = undefined;
  private onOperationEnd: Function = (): void => {
  };
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  public async onInlineRenameSubmit(newName: string): Promise<boolean> {
    Log.info(TAG, 'onInlineRenameSubmit');
    if (this.menuContext.fromSelectMode === undefined) {
      Log.error(TAG, 'menuContext or fromSelectMode is empty, return');
      return Promise.resolve(false);
    }
    let albumInfo: AlbumInfo | undefined = this.menuContext.albumInfo;
    ReportToBigDataUtil.report(BigDataConstants.ALBUM_OPERATION_ID,
      { 'type': BigDataConstants.ALBUM_RENAME, 'ALBUM_TYPE': albumInfo?.subType });
    let uri: string | undefined;
    if (this.menuContext.fromSelectMode) {
      let selectManager: SelectManager | undefined = this.menuContext.selectManager;
      if (!selectManager) {
        Log.error(TAG, 'selectManager is null, return');
        return Promise.resolve(false);
      }
      let count = this.menuContext.selectManager?.clickedSet.size;
      if (count !== 1 && !selectManager.albumUri) {
        Log.error(TAG, 'count != 1, return');
        return Promise.resolve(false);
      }
      uri = Array.from(this.menuContext.selectManager?.clickedSet ?? [])?.[0] || selectManager.albumUri;
    } else {
      let albumInfo: AlbumInfo | undefined | null = this.menuContext.albumInfo;
      if (!albumInfo) {
        Log.error(TAG, 'albumInfo is null, return');
        return Promise.resolve(false);
      }
      uri = albumInfo?.uri || '';
    }
    Log.info(TAG, `onInlineRenameSubmit uri is ${uri}`);
    try {
      this.sourceAlbum = await UserFileManagerAccess.getInstance().getAlbumByUri(uri);
      if (this.sourceAlbum) {
        Log.info(TAG, `sourceAlbum exitst ${JSON.stringify(this.sourceAlbum)}`);
        await this.confirmCallback(newName);
        return Promise.resolve(true);
      }
    } catch (error) {
      ReportToBigDataUtil.errEventReport(BigDataConstants.ALBUM_OPERATION_ERROR_ID,
        { 'type': BigDataConstants.ALBUM_RENAME_ERROR, 'errMsg': error });
      Log.error(TAG, `AlbumSet inLine rename failed: ${error}, code: ${error?.code}`);
      this.onError();
    }
    return Promise.resolve(false);
  }

  public static async checkIsNameValid(name: string, defaultName?: string): Promise<boolean> {
    if (!name || !name.trim()) {
      UiUtil.showToast($r('app.string.please_enter_name'));
      return false;
    }
    let startTime: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('getAlbumByName', startTime);
    let targetAlbum: photoAccessHelper.Album | undefined =
      await UserFileManagerAccess.getInstance().getAlbumByName(name);
    if (!targetAlbum) {
      Log.info(TAG, 'checkIsNameValid didn\'t find album occupying the name');
    }
    TraceControllerUtils.finishTraceWithTaskId('getAlbumByName', startTime);
    Log.info(TAG, `checkIsNameValid getAlbumByName cost ${Date.now() - startTime} ms`);
    if (targetAlbum && (name !== defaultName)) {
      UiUtil.showToast($r('app.string.name_already_use'));
      return false;
    }
    if (StringUtil.checkNameInvalid(name)) {
      UiUtil.showToast($r('app.string.specific_characters_not_supported'));
      return false;
    }
    return true;
  }

  public doAction(): void {
  }

  public onCompleted(): void {
    Log.info(TAG, 'Rename data succeed!');
    this.onOperationEnd?.();
  }

  public onError(): void {
    Log.error(TAG, 'Rename data failed!');
    this.onOperationEnd?.();
  }

  private async confirmCallback(newName: string): Promise<void> {
    Log.info(TAG, `AlbumSet rename confirm and the new name is: ${AlbumDefine.getAnonymizeAlbumName(newName)}`);

    this.onOperationEnd = this.menuContext.onOperationEnd;
    this.menuContext.onOperationStart?.();
    this.rename(newName);
  }

  private async rename(name: string): Promise<void> {
    try {
      await UserFileManagerAccess.getInstance().renameAlbum(this.sourceAlbum, name);
      this.appBroadCast.emit(BroadCastConstants.UPDATE_TITLE, [name, this.menuContext.albumUri]);
      this.onCompleted();
    } catch (error) {
      ReportToBigDataUtil.errEventReport(BigDataConstants.ALBUM_OPERATION_ERROR_ID,
        { 'type': BigDataConstants.ALBUM_RENAME_ERROR, 'errMsg': error });
      Log.error(TAG, `AlbumSet rename failed: ${error}, code: ${error?.code}`);
      this.onError();
    }
  }
}