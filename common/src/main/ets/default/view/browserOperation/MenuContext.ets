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

import type { MediaItem } from '../../model/browser/photo/MediaItem';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import type { BroadCast } from '../../utils/BroadCast';
import type { AlbumSetDataSource } from '../../model/browser/album/AlbumSetDataSource';
import type { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import type { MenuOperation } from './MenuOperation';
import lazy { Action, ActionID } from './Action';
import lazy { RemoveMenuOperation } from './RemoveMenuOperation';
import lazy { DeleteMenuOperation } from './DeleteMenuOperation';
import lazy { ClearRecycleMenuOperation } from './ClearRecycleMenuOperation';
import lazy { LongPressDeleteMenuOperation } from './LongPressDeleteMenuOperation';
import lazy { FavoriteMenuOperation } from './FavoriteMenuOperation';
import lazy { RenameMenuOperation } from './RenameMenuOperation';
import lazy { AlbumSetRenameMenuOperation } from '../../view/album/AlbumSetRenameMenuOperation';
import lazy {
  AlbumSetDeleteWithoutDialogMenuOperation
} from '../../view/album/AlbumSetDeleteWithoutDialogMenuOperation';
import lazy { AlbumSetDeleteMenuOperation } from '../../view/album/AlbumSetDeleteMenuOperation';
import lazy { Log } from '../../utils/Log';
import lazy { RemoveAlbumMenuOperation } from './RemoveAlbumMenuOperation';
import lazy { ParamsWrapper } from '../actionbar/Menu';
import lazy { MoveMenuOperation } from './MoveMenuOperation';
import lazy { AddMenuOperation } from './AddMenuOperation';
import lazy { AlbumSetNewWithoutDialogMenuOperation } from './AlbumSetNewWithoutDialogMenuOperation';
import lazy { AlbumSetNewMenuOperation } from './AlbumSetNewMenuOperation';
import lazy { SaveBurstPhotosMenuOperation } from './SaveBurstPhotosMenuOperation';
import lazy { BatchRemoveMenuOperation } from './BatchRemoveMenuOperation';
import lazy { common } from '@kit.AbilityKit';
import lazy { DeleteGroupMenuOperation } from './DeleteGroupMenuOperation';
import lazy { RemoveFromGroupOperation } from './RemoveFromGroupOperation';
import lazy  { AlbumDataSource } from '../../model/AlbumDataSource';
import { RecoverMenuOperation } from './RecoverMenuOperation';

const TAG = 'MenuContext';

export enum SourceSceneType {
  INVALID,
  SYSTEM_ALBUM,
  USER_ALBUM,
  PICKER,
  BIG_PHOTO_COMPONENT,
}


export class MenuContext {
  private readonly params: ParamsWrapper = new ParamsWrapper();
  public mediaItem?: MediaItem;
  public albumUri?: string;
  public originalAlbumUri?: string;
  public navigationPageFunc?: Function;
  public selectManager?: SelectManager;
  /* instrument ignore next */
  public onOperationStart: Function = (): void => {
  };
  /* instrument ignore next */
  public onOperationEnd: Function = (): void => {
  };
  /* instrument ignore next */
  public onOperationFail: Function = (): void => {
  };
  public broadCast: BroadCast | undefined = undefined;
  public latlng: number[] = [];
  public jumpSourceToMain?: number;
  public deviceId?: string;
  public albumInfo?: AlbumInfo;
  public fromSelectMode?: boolean;
  public targetAlbumName?: string;
  public sourceScene: SourceSceneType = SourceSceneType.INVALID;
  public isHidden?: boolean;
  public fromLongPress?: boolean;
  /**
   * 标识手机还是pc场景
   */
  public fromPage?: string;
  /**
   * 大图组件拉起场景
   */
  public pageFrom? :string;
  public targetFavorStatus?: boolean;
  // 待操作文件是否为连拍封面
  public isBurstPhotos?: boolean;
  // 待操作的连拍封面对应的一组连拍
  public burstPhotos?: MediaItem[];
  public isSkipDeleteDialog?: boolean;
  public isFromPhotoBrowser?: boolean;
  public isFromHighlight?: boolean;

  /**
   * 是否被取消
   */
  public isCancelled: boolean = false;
  public isNewAlbumRequestFocus: boolean = true;
  // 重命名时拉起facardserviceability
  public uiContext?: common.UIAbilityContext;

  public dataSource?: AlbumDataSource | undefined = undefined;

  /**
   * 取参数
   *
   * @param key 键
   * @returns 参数
   */
  /* instrument ignore next */
  public get<T>(key: string): T | undefined {
    return this.params.get<T>(key);
  }

  /**
   * 设置参数
   *
   * @param key 键
   * @param obj 值
   * @returns 创建者模式本身，方便链式调用
   */
  public set(key: string, obj: Object | undefined): MenuContext {
    this.params.set(key, obj);
    return this;
  }

  /**
   * 取消
   */
  public cancel(): void {
    this.isCancelled = true;
  }

  public producer(operation: MenuOperation): void {
    Log.info(TAG, `createMenuOperation: ${operation.constructor.name}`);
    operation.doAction();
  }

  /* instrument ignore next */
  public operate(actionID: number): void {
    Log.info(TAG, ActionID[actionID]);
    switch (actionID) {
      case Action.ADD.actionID:
        this.producer(new AddMenuOperation(this));
        break;
      case Action.MOVE.actionID:
        this.producer(new MoveMenuOperation(this));
        break;
      case Action.DELETE.actionID:
        this.producer(new DeleteMenuOperation(this));
        break;
      case Action.DELETE_ALBUM.actionID:
        this.producer(new AlbumSetDeleteMenuOperation(this));
        break;
      case Action.DELETE_ALBUM_WITHOUT_DIALOG.actionID:
        this.producer(new AlbumSetDeleteWithoutDialogMenuOperation(this));
        break;
      case Action.LONG_PRESS_DELETE.actionID:
        this.producer(new LongPressDeleteMenuOperation(this));
        break;
      case Action.NEW_WITHOUT_DIALOG.actionID:
        this.producer(new AlbumSetNewWithoutDialogMenuOperation(this));
        break;
      case Action.CLEAR_RECYCLE.actionID:
        this.producer(new ClearRecycleMenuOperation(this));
        break;
      case Action.RECOVER.actionID:
        this.producer(new RecoverMenuOperation(this));
        break;
      case Action.REMOVE_FROM.actionID:
        this.producer(new RemoveMenuOperation(this));
        break;
      case Action.REMOVE_FROM_LARGE.actionID:
        this.producer(new RemoveAlbumMenuOperation(this));
        break;
      case Action.RENAME.actionID:
        this.producer(new RenameMenuOperation(this));
        break;
      case Action.RENAME_ALBUM.actionID:
        this.producer(new AlbumSetRenameMenuOperation(this));
        break;
      case Action.REMOVE_FROM_GROUP.actionID:
        this.producer(new RemoveFromGroupOperation(this));
        break;
      default:
        this.operateNext(actionID);
    }
  }

  /* instrument ignore next */
  private operateNext(actionID: number): void {
    switch (actionID) {
      case Action.FAVORITE.actionID:
      case Action.NOT_FAVORITE.actionID:
        this.producer(new FavoriteMenuOperation(this));
        break;
      case Action.ACTION_REMOVE.actionID:
        this.producer(new BatchRemoveMenuOperation(this));
        break;
      case Action.ALBUM_SET_NEW.actionID:
        this.producer(new AlbumSetNewMenuOperation(this));
        break;
      case Action.BURST_ABLE_SAVE.actionID:
        this.producer(new SaveBurstPhotosMenuOperation(this));
        break;
      case Action.DELETE_GROUP.actionID:
        this.producer(new DeleteGroupMenuOperation(this));
        break;
      default:
        Log.error(TAG, ActionID[actionID]);
    }
  }

  public withMediaItem(mediaItem: MediaItem | undefined): MenuContext {
    this.mediaItem = mediaItem;
    return this;
  }

  public withHighlight(isFromHighlight: boolean | undefined): MenuContext {
    this.isFromHighlight = isFromHighlight;
    return this;
  }

  public withAlbumUri(albumUri: string | undefined): MenuContext {
    this.albumUri = albumUri;
    return this;
  }

  public withOriginalAlbumUri(albumUri: string | undefined): MenuContext {
    this.originalAlbumUri = albumUri;
    return this;
  }

  public withNavigationPageFunc(navigationPageFunc: Function | undefined): MenuContext {
    this.navigationPageFunc = navigationPageFunc;
    return this;
  }

  public withSelectManager(selected: SelectManager | MediaItem | undefined): MenuContext {
    if (selected instanceof SelectManager) {
      this.selectManager = selected;
      this.fromSelectMode = true;
    } else {
      this.mediaItem = selected;
      this.fromSelectMode = false;
    }
    return this;
  }

  public withOperationStartCallback(onOperationStart: Function): MenuContext {
    this.onOperationStart = onOperationStart;
    return this;
  }

  public withOperationEndCallback(onOperationEnd: Function): MenuContext {
    this.onOperationEnd = onOperationEnd;
    return this;
  }

  public withOperationFailCallback(onOperationFail: Function): MenuContext {
    this.onOperationFail = onOperationFail;
    return this;
  }

  public withBroadCast(param: BroadCast): MenuContext {
    this.broadCast = param;
    return this;
  }

  public withNewAlbumFocusState(isNewAlbumRequestFocus: boolean): MenuContext {
    this.isNewAlbumRequestFocus = isNewAlbumRequestFocus;
    return this;
  }

  public withLatlng(latlng: number[]): MenuContext {
    this.latlng = latlng;
    return this;
  }

  public withJumpSourceToMain(jumpSourceToMain: number): MenuContext {
    this.jumpSourceToMain = jumpSourceToMain;
    return this;
  }

  public setIsFromPhotoBrowser(isFromPhotoBrowser: boolean): MenuContext {
    this.isFromPhotoBrowser = isFromPhotoBrowser;
    return this;
  }

  public withRemoteDevice(deviceId: string): MenuContext {
    this.deviceId = deviceId;
    return this;
  }

  public withAlbumInfo(albumInfo: AlbumInfo | null | undefined): MenuContext {
    if (albumInfo) {
      this.albumInfo = albumInfo ?? undefined;
    }
    this.albumUri = albumInfo?.uri;
    return this;
  }

  public withDataSource(dataSource: AlbumDataSource): MenuContext {
    this.dataSource = dataSource;
    return this;
  }

  public withTargetAlbumName(albumName: string | undefined): MenuContext {
    this.targetAlbumName = albumName;
    return this;
  }

  public withFromSelectMode(fromSelectMode: boolean): MenuContext {
    this.fromSelectMode = fromSelectMode;
    return this;
  }

  public withSourceScene(sourceScene: SourceSceneType): MenuContext {
    this.sourceScene = sourceScene;
    return this;
  }

  public withTargetFavorStatus(state: boolean): MenuContext {
    this.targetFavorStatus = state;
    return this;
  }

  public withHiddenState(state: boolean): MenuContext {
    this.isHidden = state;
    return this;
  }

  public withFromPage(fromPage: string): MenuContext {
    this.fromPage = fromPage;
    return this;
  }

  public withPageFrom(pageFrom: string): MenuContext {
    this.pageFrom = pageFrom;
    return this;
  }

  public withFromLongPress(state: boolean): MenuContext {
    this.fromLongPress = state;
    return this;
  }

  public withBurstPhotos(items: MediaItem[]): MenuContext {
    this.isBurstPhotos = true;
    this.burstPhotos = items;
    return this;
  }

  public withUIContext(context: common.UIAbilityContext) {
    this.uiContext = context;
    return this;
  }

  public setSkipDeleteDialog(value: boolean): MenuContext {
    this.isSkipDeleteDialog = value;
    return this;
  }
}