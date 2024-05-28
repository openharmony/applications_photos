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
import { BroadCast } from '../../utils/BroadCast';
import { SelectManager } from '../../model/browser/SelectManager';
import { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import { AlbumDefine } from '../../model/browser/AlbumDefine';

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
    if (AppStorage.get<MoveOrCopyBroadCastProp>(Constants.INSTANCE_MOVE_OR_COPY_BROADCAST_PROP) == null) {
      AppStorage.setOrCreate(Constants.INSTANCE_MOVE_OR_COPY_BROADCAST_PROP, new MoveOrCopyBroadCastProp());
    }
    return AppStorage.get<MoveOrCopyBroadCastProp>(
      Constants.INSTANCE_MOVE_OR_COPY_BROADCAST_PROP) as MoveOrCopyBroadCastProp;
  }

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
        this.broadCast.emit(BroadCastConstants.SHOW_COPY_OR_MOVE_DIALOG,
          [async (): Promise<void> => await this.moveOperation(),
            async (): Promise<void> => await this.addOperation()]);
      }
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
    let selectManager: SelectManager =
      AppStorage.get<SelectManager>(Constants.APP_KEY_NEW_ALBUM_SELECTED) as SelectManager;
    let targetAlbumName: string = AppStorage.get<string>(Constants.APP_KEY_NEW_ALBUM_TARGET) as string;
    let targetAlbumUri: string = AppStorage.get<string>(Constants.APP_KEY_NEW_ALBUM_TARGET_URI) as string;
    if (this.broadCast === null || this.broadCast === undefined) {
      Log.error(TAG, 'addOperation error: null or undefined broadcast');
      return;
    }

    let menuContext = new MenuContext();
    menuContext
      .withSelectManager(selectManager)
      .withOperationStartCallback((): void => this.onOperationStartBindImpl())
      .withOperationEndCallback(async (): Promise<void> => await this.onOperationEndBindImpl())
      .withBroadCast(this.broadCast)
    menuContext.withTargetAlbumName(targetAlbumName).withAlbumUri(targetAlbumUri);
    let menuOperation = MenuOperationFactory.getInstance().createMenuOperation(AddMenuOperation, menuContext);
    menuOperation.doAction();
  }

  private async moveOperation() {
    let selectManager: SelectManager =
      AppStorage.get<SelectManager>(Constants.APP_KEY_NEW_ALBUM_SELECTED) as SelectManager;
    let targetAlbumName: string = AppStorage.get<string>(Constants.APP_KEY_NEW_ALBUM_TARGET) as string;
    let targetAlbumUri: string = AppStorage.get<string>(Constants.APP_KEY_NEW_ALBUM_TARGET_URI) as string;
    if (this.broadCast === null || this.broadCast === undefined) {
      Log.error(TAG, 'moveOperation error: null or undefined broadcast');
      return;
    }

    let menuContext = new MenuContext();
    menuContext
      .withSelectManager(selectManager)
      .withOperationStartCallback((): void => this.onOperationStartBindImpl())
      .withOperationEndCallback(async (): Promise<void> => await this.onOperationEndBindImpl())
      .withBroadCast(this.broadCast)
    menuContext.withTargetAlbumName(targetAlbumName).withAlbumUri(targetAlbumUri);
    let menuOperation = MenuOperationFactory.getInstance().createMenuOperation(MoveMenuOperation, menuContext);
    menuOperation.doAction();
  }

  private onOperationStart(): void {
    this.onOperationStartBindImpl();
  }

  private async onOperationEndBindImpl(): Promise<void> {
    AppStorage.setOrCreate(Constants.IS_DATA_FREEZE, false);
    let isNewAlbum: boolean = AppStorage.get<boolean>(Constants.APP_KEY_NEW_ALBUM) as boolean;
    let selectManager: SelectManager =
      AppStorage.get<SelectManager>(Constants.APP_KEY_NEW_ALBUM_SELECTED) as SelectManager;
    let targetAlbumName: string = AppStorage.get<string>(Constants.APP_KEY_NEW_ALBUM_TARGET) as string;

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
      AppStorage.delete(Constants.APP_KEY_NEW_ALBUM);
      AppStorage.delete(Constants.APP_KEY_NEW_ALBUM_TARGET);
      AppStorage.delete(Constants.APP_KEY_NEW_ALBUM_TARGET_URI);
      AppStorage.delete(Constants.APP_KEY_NEW_ALBUM_SELECTED);
      router.pushUrl({
        url: 'pages/PhotoGridPage',
        params: {
          item: JSON.stringify(albumInfo),
        }
      });
    } else {
      AppStorage.setOrCreate<ParamAlbumInfo>(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM, {
        item: JSON.stringify(albumInfo)
      });
      AppStorage.setOrCreate(Constants.KEY_OF_ALBUM_URI, albumInfo.uri);
      router.back({
        url: 'pages/index',
      });
    }
  }

  private onOperationStartBindImpl(): void {
    AppStorage.setOrCreate(Constants.IS_DATA_FREEZE, true);
  }

  private async onOperationEnd(): Promise<void> {
    await this.onOperationEndBindImpl();
  }
}