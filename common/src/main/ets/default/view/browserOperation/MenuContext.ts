/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { MediaItem } from '../../model/browser/photo/MediaItem';
import { SelectManager } from '../../model/browser/SelectManager';
import { BroadCast } from '../../utils/BroadCast';
import { AlbumSetDataSource } from '../../model/browser/album/AlbumSetDataSource';
import { AlbumInfo } from '../../model/browser/album/AlbumInfo';

export enum SourceSceneType {
  INVALID,
  SYSTEM_ALBUM,
  USER_ALBUM,
  PICKER,
  BIG_PHOTO_COMPONENT
}

export class MenuContext {
  mediaItem: MediaItem;
  albumUri: string;
  selectManager: SelectManager;
  onOperationStart: Function;
  onOperationCancel: Function;
  onOperationEnd: Function;
  broadCast: BroadCast
  latlng: number[];
  jumpSourceToMain: number;
  albumSetDataSource: AlbumSetDataSource;
  deviceId: string;
  albumInfo: AlbumInfo;
  fromSelectMode: boolean;
  targetAlbumName: string;
  sourceScene: SourceSceneType = SourceSceneType.INVALID;

  withMediaItem(mediaItem: MediaItem): MenuContext {
    this.mediaItem = mediaItem;
    return this;
  }

  withAlbumUri(albumUri: string): MenuContext {
    this.albumUri = albumUri;
    return this;
  }

  withSelectManager(selectManager: SelectManager): MenuContext {
    this.selectManager = selectManager;
    return this;
  }

  withOperationStartCallback(onOperationStart: Function): MenuContext {
    this.onOperationStart = onOperationStart;
    return this;
  }

  withOperationCancelCallback(onOperationCancel: Function): MenuContext {
    this.onOperationCancel = onOperationCancel;
    return this;
  }

  withOperationEndCallback(onOperationEnd: Function): MenuContext {
    this.onOperationEnd = onOperationEnd;
    return this;
  }

  withBroadCast(param: BroadCast): MenuContext {
    this.broadCast = param;
    return this;
  }

  withLatlng(latlng: number[]): MenuContext {
    this.latlng = latlng;
    return this;
  }

  withJumpSourceToMain(jumpSourceToMain: number): MenuContext {
    this.jumpSourceToMain = jumpSourceToMain;
    return this;
  }

  withAlbumSetDataSource(albumSetDataSource: AlbumSetDataSource | null): MenuContext {
    this.albumSetDataSource = albumSetDataSource;
    return this;
  }

  withRemoteDevice(deviceId) {
    this.deviceId = deviceId;
    return this;
  }

  withAlbumInfo(albumInfo: AlbumInfo | null | undefined): MenuContext {
    this.albumInfo = albumInfo;
    return this;
  }

  withTargetAlbumName(albumName) {
    this.targetAlbumName = albumName;
    return this;
  }

  withFromSelectMode(fromSelectMode) {
    this.fromSelectMode = fromSelectMode;
    return this;
  }
}