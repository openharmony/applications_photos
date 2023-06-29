/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { BroadCastConstants } from '../../model/common/BroadCastConstants';
import { Constants } from '../../model/common/Constants';
import { AddMenuOperation } from './AddMenuOperation';
import { MenuContext } from './MenuContext';
import { MenuOperationFactory } from '../../interface/MenuOperationFactory';
import { MoveMenuOperation } from './MoveMenuOperation';
import { Log } from '../../utils/Log';
import router from '@ohos.router';
import { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import type { BroadCast } from '../../utils/BroadCast';
import type { SelectManager } from '../../model/browser/SelectManager';
import { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import { AlbumDefine } from '../../model/browser/AlbumDefine';

const TAG: string = 'common_MoveOrCopyBroadCastProp';

export class MoveOrCopyBroadCastProp {
  private broadCast: BroadCast;

  private constructor() {
  }

  /**
   * Get MoveOrCopyBroadCastProp instance
   */
  public static getInstance(): MoveOrCopyBroadCastProp {
    if (AppStorage.Get(Constants.INSTANCE_MOVE_OR_COPY_BROADCAST_PROP) == null) {
      AppStorage.SetOrCreate(Constants.INSTANCE_MOVE_OR_COPY_BROADCAST_PROP, new MoveOrCopyBroadCastProp());
    }
    return AppStorage.Get(Constants.INSTANCE_MOVE_OR_COPY_BROADCAST_PROP);
  }

  /**
   * sendMoveOrCopyBroadCast
   *
   * @param broadCast broadCast
   */
  public sendMoveOrAddBroadCast(broadCast: BroadCast) {
    if (broadCast === null || broadCast === undefined) {
      Log.error(TAG, 'sendMoveOrAddBroadCast error: null or undefined broadcast');
      return;
    }
    this.setBroadCast(broadCast);

    // 如果是系统相册，则直接添加到，而不是弹窗选择添加还是移动
    let isSystemAlbumSource: boolean = false;
    let sourceAlbumUri: string = AppStorage.Get(Constants.APP_KEY_NEW_ALBUM_SOURCE);
    let systemAlbumUris: IterableIterator<string> = UserFileManagerAccess.getInstance().getSystemAlbumUriMap().values();
    for (let uri of systemAlbumUris) {
      if (sourceAlbumUri === uri) {
        isSystemAlbumSource = true;
        break;
      }
    }
    if (isSystemAlbumSource) {
      this.addOperation();
    } else {
      this.broadCast.emit(BroadCastConstants.SHOW_COPY_OR_MOVE_DIALOG,
        [this.moveOperation.bind(this), this.addOperation.bind(this)]);
    }
  }

  /**
   * DoCopyOperation
   *
   * @param broadCast broadCast
   */
  public doAddOperation(broadCast: BroadCast) {
    if (broadCast === null || broadCast === undefined) {
      Log.error(TAG, 'doCopyOperation error: null or undefined broadcast');
      return;
    }
    this.setBroadCast(broadCast);
    this.addOperation();
  }

  private setBroadCast(broadCast: BroadCast) {
    this.broadCast = broadCast;
  }

  private async addOperation() {
    let selectManager: SelectManager = AppStorage.Get(Constants.APP_KEY_NEW_ALBUM_SELECTED);
    let targetAlbumName: string = AppStorage.Get(Constants.APP_KEY_NEW_ALBUM_TARGET);
    let targetAlbumUri: string = AppStorage.Get(Constants.APP_KEY_NEW_ALBUM_TARGET_URI);
    if (this.broadCast === null || this.broadCast === undefined) {
      Log.error(TAG, 'addOperation error: null or undefined broadcast');
      return;
    }

    let menuContext = new MenuContext();
    this.onOperationStart = this.onOperationStart.bind(this);
    this.onOperationEnd = this.onOperationEnd.bind(this);
    menuContext
      .withSelectManager(selectManager)
      .withOperationStartCallback(this.onOperationStart)
      .withOperationEndCallback(this.onOperationEnd)
      .withBroadCast(this.broadCast)
    menuContext.withTargetAlbumName(targetAlbumName).withAlbumUri(targetAlbumUri);
    let menuOperation = MenuOperationFactory.getInstance().createMenuOperation(AddMenuOperation, menuContext);
    menuOperation.doAction();
  }

  private async moveOperation() {
    let selectManager: SelectManager = AppStorage.Get(Constants.APP_KEY_NEW_ALBUM_SELECTED);
    let targetAlbumName: string = AppStorage.Get(Constants.APP_KEY_NEW_ALBUM_TARGET);
    let targetAlbumUri: string = AppStorage.Get(Constants.APP_KEY_NEW_ALBUM_TARGET_URI);
    if (this.broadCast === null || this.broadCast === undefined) {
      Log.error(TAG, 'moveOperation error: null or undefined broadcast');
      return;
    }

    let menuContext = new MenuContext();
    this.onOperationStart = this.onOperationStart.bind(this);
    this.onOperationEnd = this.onOperationEnd.bind(this);
    menuContext
      .withSelectManager(selectManager)
      .withOperationStartCallback(this.onOperationStart)
      .withOperationEndCallback(this.onOperationEnd)
      .withBroadCast(this.broadCast)
    menuContext.withTargetAlbumName(targetAlbumName).withAlbumUri(targetAlbumUri);
    let menuOperation = MenuOperationFactory.getInstance().createMenuOperation(MoveMenuOperation, menuContext);
    menuOperation.doAction();
  }

  private onOperationStart(): void {
    AppStorage.SetOrCreate(Constants.IS_DATA_FREEZE, true);
  }

  private async onOperationEnd(): Promise<void> {
    AppStorage.SetOrCreate(Constants.IS_DATA_FREEZE, false);
    let isNewAlbum: boolean = AppStorage.Get(Constants.APP_KEY_NEW_ALBUM);
    let selectManager: SelectManager = AppStorage.Get(Constants.APP_KEY_NEW_ALBUM_SELECTED);
    let targetAlbumName: string = AppStorage.Get(Constants.APP_KEY_NEW_ALBUM_TARGET);

    let album = await UserFileManagerAccess.getInstance().getAlbumByName(targetAlbumName);
    let albumInfo: AlbumInfo = new AlbumInfo(album);
    albumInfo.setAlbumName(targetAlbumName);
    let fetchOpt = AlbumDefine.getFileFetchOpt();
    let fetchResult = await album.getPhotoAssets(fetchOpt);
    let count = fetchResult.getCount();
    fetchResult.close();
    albumInfo.setCount(count);

    if (isNewAlbum) {
      selectManager.onModeChange(false);
      AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM);
      AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_TARGET);
      AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_TARGET_URI);
      AppStorage.Delete(Constants.APP_KEY_NEW_ALBUM_SELECTED);
      router.pushUrl({
        url: 'pages/PhotoGridPage',
        params: {
          item: JSON.stringify(albumInfo),
        }
      });
    } else {
      AppStorage.SetOrCreate(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM, { item: JSON.stringify(albumInfo) });
      AppStorage.SetOrCreate(Constants.KEY_OF_ALBUM_URI, albumInfo.uri);
      router.back({
        url: 'pages/index',
      });
    }
  }
}