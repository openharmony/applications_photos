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

import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { Constants } from '../../model/common/Constants';
import lazy { MenuContext } from './MenuContext';
import lazy { Log } from '../../utils/Log';
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import type { BroadCast } from '../../utils/BroadCast';
import type { SelectManager } from '../../model/browser/SelectManager';
import lazy { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import lazy { AlbumDefine } from '../../model/browser/AlbumDefine';
import lazy { Action } from './Action';
import lazy { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import type { PhotoAsset } from '../../access/UserFileManagerAccess';

/* instrument ignore file */
const TAG: string = 'common_MoveOrCopyBroadCastProp';

interface ParamAlbumInfo {
  item: string;
  isFromFACard?: boolean;
}

export class MoveOrCopyBroadCastProp {
  private broadCast: BroadCast | null = null;

  private constructor() {
  }

  /**
   * Get MoveOrCopyBroadCastProp instance
   */
  public static getInstance(): MoveOrCopyBroadCastProp {
    if (!MoveOrCopyBroadCastProp.instance) {
      MoveOrCopyBroadCastProp.instance = new MoveOrCopyBroadCastProp();
    }
    return MoveOrCopyBroadCastProp.instance;
  }

  public static instance: MoveOrCopyBroadCastProp | undefined = undefined;

  /**
   * sendMoveOrCopyBroadCast
   *
   * @param broadCast broadCast
   */
  public sendMoveOrAddBroadCast(broadCast: BroadCast): void {
    if (broadCast === null || broadCast === undefined) {
      Log.error(TAG, 'sendMoveOrAddBroadCast error: null or undefined broadcast');
      return;
    }
    this.setBroadCast(broadCast);

    /// 如果是系统相册,或者是新建相册从PickerPage界面添加图片的场景，直接添加到，而不是弹窗选择添加还是移动
    let sourceAlbumUri = AppStorage.get<string>(Constants.APP_KEY_NEW_ALBUM_SOURCE);
    let isOnlyAddAlbumSource: boolean = sourceAlbumUri === Constants.APP_NEW_ALBUM_SOURCE_PICKER;
    if (!isOnlyAddAlbumSource) {
      UserFileManagerAccess.getInstance().getSystemAlbumUriMap().forEach(
        (value: string) => {
          if (sourceAlbumUri === value) {
            isOnlyAddAlbumSource = true;
            return;
          }
        });
    }
    if (isOnlyAddAlbumSource) {
      this.addOperation();
    } else {
      if (this.broadCast != null) {
        this.broadCast.emit(BroadCastConstants.SHOW_COPY_OR_MOVE_DIALOG, [async ():
          Promise<void> => await this.addOperation()]);
      }
    }
  }

  /**
   * DoCopyOperation
   *
   * @param broadCast broadCast
   */
  public doAddOperation(broadCast: BroadCast): void {
    if (broadCast === null || broadCast === undefined) {
      Log.error(TAG, 'doCopyOperation error: null or undefined broadcast');
      return;
    }
    this.setBroadCast(broadCast);
    this.addOperation();
  }

  private setBroadCast(broadCast: BroadCast): void {
    this.broadCast = broadCast;
  }

  private async addOperation(): Promise<void> {
    let selectManager: SelectManager |
    undefined = AppStorage.get<SelectManager>(Constants.APP_KEY_NEW_ALBUM_SELECTED);
    let targetAlbumName: string | undefined = AppStorage.get<string>(Constants.APP_KEY_NEW_ALBUM_TARGET);
    let targetAlbumUri: string | undefined = AppStorage.get<string>(Constants.APP_KEY_NEW_ALBUM_TARGET_URI);
    if (this.broadCast === null || this.broadCast === undefined) {
      Log.error(TAG, 'addOperation error: null or undefined broadcast');
      return;
    }

    let menuContext = new MenuContext();
    let onOperationStart = (): void => this.onOperationStartBindImpl();
    let onOperationEnd = async (): Promise<void> => await this.onOperationEndBindImpl();
    menuContext
      .withSelectManager(selectManager)
      .withOperationStartCallback(onOperationStart)
      .withOperationEndCallback(onOperationEnd)
      .withBroadCast(this.broadCast);
    if (targetAlbumName) {
      menuContext.withTargetAlbumName(targetAlbumName).withAlbumUri(targetAlbumUri);
    }
    menuContext.operate(Action.MOVE.actionID);
  }

  private onOperationStart(): void {
    this.onOperationStartBindImpl();
  }

  private onOperationStartBindImpl(): void {
    AppStorage.setOrCreate(Constants.IS_DATA_FREEZE, true);
  }

  private async onOperationEnd(): Promise<void> {
    await this.onOperationEndBindImpl();
  }

  private async onOperationEndBindImpl(): Promise<void> {
    AppStorage.setOrCreate(Constants.IS_DATA_FREEZE, false);
    let targetAlbumUri: string | undefined = AppStorage.get<string>(Constants.APP_KEY_NEW_ALBUM_TARGET_URI);

    let startTime: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('getAlbumByUri', startTime);
    let album = await UserFileManagerAccess.getInstance().getAlbumByUri(targetAlbumUri);
    TraceControllerUtils.finishTraceWithTaskId('getAlbumByUri', startTime);
    Log.info(TAG, `getAlbumByName cost ${Date.now() - startTime} ms`);
    let albumInfo: AlbumInfo = new AlbumInfo(album);
    let fetchOpt = AlbumDefine.getFileFetchOpt();
    if (album) {
      let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
      try {
        fetchResult = await album.getAssets(fetchOpt);
        let count = fetchResult.getCount();
        albumInfo.setCount(count);
      } catch (err) {
        Log.error(TAG, `on operation end bind impl, error: ${err?.code}, ${err?.message}`);
      } finally {
        fetchResult?.close();
        Log.info(TAG, `fetchResult is close.`);
      }


    }
    this.broadCast?.emit(BroadCastConstants.FINISH_PICKER_OPERATION, [albumInfo]);
  }
}